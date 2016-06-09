//
//  ViewController.swift
//  photomaster
//
//  Created by 福島達也 on 2016/06/10.
//  Copyright © 2016年 福島達也. All rights reserved.
//

import UIKit
import Social

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    @IBOutlet weak var photoImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func precentPickerController(sourceType : UIImagePickerControllerSourceType){
        if UIImagePickerController.isSourceTypeAvailable(sourceType){
            let picker = UIImagePickerController()
            
            picker.sourceType = sourceType
            picker.delegate = self
            
            self.presentViewController(picker, animated: true, completion: nil)
            
        }
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image : UIImage!, editingInfo: NSDictionary!){
        self.dismissViewControllerAnimated(true, completion: nil)
        
        photoImageView.image = image
    }
    
    @IBAction func selectButtonTapped(sender: UIButton){
        let alertController = UIAlertController(title:"画像の取得先を選択", message: nil, preferredStyle: .ActionSheet)
        
        let firstAction = UIAlertAction(title: "カメラ", style: .Default){
            action in
            self.precentPickerController(.Camera)
        }
        let secondAction = UIAlertAction(title: "アルバム", style: .Default){
            action in
            self.precentPickerController(.PhotoLibrary)
        }
        let cancelAction = UIAlertAction(title:"キャンセル",style: .Cancel, handler: nil)
        
        alertController.addAction(firstAction)
        alertController.addAction(secondAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    func drawText(image: UIImage) -> UIImage{
        let text = "Life is Tech!" as NSString
        
        UIGraphicsBeginImageContext(image.size)
        
        image.drawInRect (CGRectMake(0,0, image.size.width, image.size.height))
        
        let textRect = CGRectMake(5,5, image.size.width - 5, image.size.height - 5)
        
        let textFontAttributes = [
            NSFontAttributeName : UIFont.boldSystemFontOfSize(120),
            NSForegroundColorAttributeName : UIColor.redColor(),
            NSParagraphStyleAttributeName : NSMutableParagraphStyle.defaultParagraphStyle()
        ]
        
        text.drawInRect(textRect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func drawMaskImage(image : UIImage) -> UIImage{
        
        UIGraphicsBeginImageContext(image.size)
        
        image.drawInRect(CGRectMake(0,0, image.size.width, image.size.height))
        
        let maskImage = UIImage(named: "IMG_7749.JPG")
        
        let offset: CGFloat = 50.0
        let maskRect = CGRectMake(image.size.width - maskImage!.size.width - offset,
                                  image.size.height - maskImage!.size.height - offset,
                                  maskImage!.size.width,
                                  maskImage!.size.height)
        maskImage!.drawInRect(maskRect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
    func simpleAlert(titleString: String){
        
        let alertController = UIAlertController(title: titleString, message: nil, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func processButtonTapped(sender: UIButton){
        guard let selectedPhoto = photoImageView.image else{
            
            simpleAlert("画像がありません")
            return
    }
        
        let alertController = UIAlertController(title: "合成するパーツを選択", message: nil, preferredStyle:.ActionSheet)
        let firstAction = UIAlertAction(title:"テキスト", style: .Default){
            action in
            
            self.photoImageView.image = self.drawText(selectedPhoto)
            
        }
        let secondAction = UIAlertAction(title:"サンタマーク", style: .Default){
            action in
            
            self.photoImageView.image = self.drawMaskImage(selectedPhoto)
        }
        let cancelAction = UIAlertAction(title:"キャンセル", style: .Cancel, handler: nil)
        
        alertController.addAction(firstAction)
        alertController.addAction(secondAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func postToSNS(serviceType: String){
        
        let myComposeView = SLComposeViewController(forServiceType : serviceType)
        
        myComposeView.setInitialText("PhotoMasterからの投稿")
        myComposeView.addImage(photoImageView.image)
        
        self.presentViewController(myComposeView, animated: true, completion: nil)
        
    }
    
    @IBAction func uploadButtonTapped(sender: UIButton){
        
        guard let selectedPhoto = photoImageView.image else{
            simpleAlert("画像がありません")
            return
        }
        
        let alertController = UIAlertController(title:"アップロード先を選択",message: nil, preferredStyle: .ActionSheet)
        let firstAction = UIAlertAction(title: "Facebookでシェア",style: .Default){
            action in
            self.postToSNS(SLServiceTypeFacebook)
        }
        let secondAction = UIAlertAction(title: "Twitterでシェア",style: .Default){
            action in
            self.postToSNS(SLServiceTypeTwitter)
        }
        let thirdAction = UIAlertAction(title: "カメラロールに保存",style: .Default){
            action in
            UIImageWriteToSavedPhotosAlbum(selectedPhoto, self, nil, nil)
            self.simpleAlert("アルバムに保存されました。")
        }
        let cancelAction = UIAlertAction(title:"キャンセル",style: .Cancel, handler: nil)
        
        alertController.addAction(firstAction)
        alertController.addAction(secondAction)
        alertController.addAction(thirdAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


    