//
//  ShareViewController.swift
//  ShareIntent
//
//  Created by 장동현 on 2023/08/31.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }
  
    override func didSelectPost() {
      let urlTypeIdentifier = kUTTypeURL as String
      
      guard let itemProvider = (self.extensionContext?.inputItems.first as? NSExtensionItem)?.attachments?.first as? NSItemProvider else { return }
      
      if itemProvider.hasItemConformingToTypeIdentifier(urlTypeIdentifier) {
        itemProvider.loadItem(forTypeIdentifier: urlTypeIdentifier, options: nil) { (item, error) in
          if let url = item as? URL {
            // 1. URL이 잘 공유 되었는지 확인
            print("Successfully retrieved URL item: \(url)")
            // 2. 공유하기 동작을 종료
            DispatchQueue.main.async {
              let alert = UIAlertController(title: "알림", message: "공유가 완료 되었습니다.", preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                  self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
              }))
              self.present(alert, animated: true, completion: nil)
            }
          } else {
            print("Error while retrieving URL item: \(error?.localizedDescription ?? "Unknown error")")
          }
        }
      }
    }


    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}
