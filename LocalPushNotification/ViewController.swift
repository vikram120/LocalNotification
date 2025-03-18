//
//  ViewController.swift
//  LocalPushNotification
//
//  Created by Vikram Kunwar on 18/03/25.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
           super.viewDidLoad()
           requestNotificationPermission()
           
          
           NotificationCenter.default.addObserver(self,
                                                 selector: #selector(appBecameActive),
                                                 name: UIApplication.didBecomeActiveNotification,
                                                 object: nil)
           resetBadgeCount()
       }
       
       @objc func appBecameActive() {
           resetBadgeCount()
       }
    
    // Request permission for notifications
    func requestNotificationPermission() {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if granted {
                    print("Notification permission granted")
                } else {
                    print("Notification permission denied")
                }
            }
        }
    
    
    @IBAction func pressNotificatioBtn(_ sender: UIButton){
        
        scheduleNotification()
    }
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Hello!"
        content.body = "This is your notification after 3 seconds."
        content.sound = UNNotificationSound.default

        
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let pendingCount = requests.count + 1
            content.badge = NSNumber(value: pendingCount)
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error adding notification: \(error.localizedDescription)")
                } else {
                    print("Notification scheduled with badge count: \(pendingCount)")
                }
            }
        }
    }
        
    func resetBadgeCount() {
        UNUserNotificationCenter.current().setBadgeCount(0) { error in
            if let error = error {
                print("Error resetting badge count: \(error.localizedDescription)")
            } else {
                print("Badge count reset to 0")
                
            }
        }
    }
}




