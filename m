Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F542339A97
	for <lists+kvm@lfdr.de>; Sat, 13 Mar 2021 01:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232905AbhCMA4d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 19:56:33 -0500
Received: from mail-dm6nam12on2065.outbound.protection.outlook.com ([40.107.243.65]:30549
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231789AbhCMA4N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 19:56:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X/7Ixe7y6nXGq6NPiYBb7NLjbeQuNnSzzVzxp229dzfZfKOUVXVWniohN7ixMnaaJI+suyHqoMM6eyJaFd8+4fvdDoTlXb0CLElxGTjJ0CyKcxGG7ZP60r7PUm9VUybTSXyORxrlT58Lb6pThmcIg6TiFbQwEWgw+eMUmgQlsBwWM63j4BeCBdXpMEnTG3h1qArdYG6Fx46lmYP3/6uClIYzCHnnCO09THIvsUeXWUNXrkCgMJOGGdS+SAeC++H87lqw6ua10VLFhZteZ+ohCw8JDl/ff+wHNLwKAVWEiUPDL9hs+J1pHZx1RmF7WU4Hc7roLoNqQI8MUeGQxsdyBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ng5NFfyxeRi9RQLflfTqs0wpY89UAqOCtXaqT89KMJM=;
 b=gqAgyzglqHe4pM5F1xHu92a7QuQDXZbZgjY4JsIhEkrMOApkYBr8OpP2BUTfK0rdulxR4ADSYLya4jEh4sVEPrKat45YTuvIqruVAFWqThugvP85Ozm0SKlxMEsRpaUTgT3vpn0ftsGKnJ7h278s6iKlLW53zGHhsaxbnCmE844oGj2zCDzgpJzW3gecCtgnubXNBF6ugLwvPXRP7JKx8aQZ6cjshtOxpOcwIAnkMgaFIzLzMGpjzWN2MBpXdAOExkU9kXRgBc80X9SnCUUNkZEtWlnHHCg0jg+6NORo2rNc5PSp2EC4O/xx9w3US0D5c9/sbCj56KD43DthWvMTMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ng5NFfyxeRi9RQLflfTqs0wpY89UAqOCtXaqT89KMJM=;
 b=i0fZdB1hetNUzh3FIcjYED0EIekNL03sploI9p2Qobd6Sf2hx5/DFUwbvuFNg8XecuWek0A99dVOB3E6Um/C7Sp/8odzsNUZxrhFol7edp7YA6hR8Mz+wAMex3GjiJPKZllbkKN8FI6XOeI0CyE/0XUj2NhEOuth8ZiIpkDU/shLnX1zN1SAOFqqJ21zsKIIMncskFCdo+UnOMtSDpXhgATwHyYkjcSrmn0R8LxEAhMR6b0xxeNPjXukReYi9ld+8X0IRwU21++kH2mTQTXDtD7kgfmghkqdrkw9uc37jRpY8jQpRx/UIOethSViERSVhZFIEMY7qXkAG/LVT+3fyg==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB2940.namprd12.prod.outlook.com (2603:10b6:5:15f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Sat, 13 Mar
 2021 00:56:11 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3933.032; Sat, 13 Mar 2021
 00:56:11 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>,
        Liu Yi L <yi.l.liu@intel.com>
Subject: [PATCH v2 10/14] vfio/mdev: Use vfio_init/register/unregister_group_dev
Date:   Fri, 12 Mar 2021 20:56:02 -0400
Message-Id: <10-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
In-Reply-To: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL0PR02CA0013.namprd02.prod.outlook.com
 (2603:10b6:207:3c::26) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR02CA0013.namprd02.prod.outlook.com (2603:10b6:207:3c::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Sat, 13 Mar 2021 00:56:09 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lKsZb-00EMBL-5a; Fri, 12 Mar 2021 20:56:07 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5acad42c-b35a-40c9-b8b9-08d8e5baca70
X-MS-TrafficTypeDiagnostic: DM6PR12MB2940:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB2940F9056428DCDA78ECC4BFC26E9@DM6PR12MB2940.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pzpe33WkZSze4HN5Ai+PB4CdPbcDQUyiKeFhgLjMoDHQFT0GuMt+qEbvqvQGeAS6NWlROI+8l5KLzIEsn9l5s1z8JMK08ZVCDQnGob3TQAwwzRgRKUpcgL1IVv+O0qXiSiVisq8NExP9c27aJoPhJKBfJ5/7LRcRR4VqeGsLFY/EOGHqxcuEB051OiM41Y6NQhDoNMg5gLbkBELQ8ULge+/aA6fFW+We2JdwvC68mQgfIUxH4/bjzjRS7zkP7JhBWPoUabG9oERheNjrSi8g9X8Adc+SfynZ6Kmb/ay2GlRm/X8/MJthvaosjnfxUCoQBHJVf5+FRXkWOVYKuPuDhq98iU+w1mKWZ9Oj2vSppLJOV2f0Pxp6WGMiY5Z1WjJOtbUgIvOjcT1JCMfzAwvF4Ic7fqYDydYJgmHW9iapppQ22bxXu4MDkmbDMohlEFng+OMRsvgiQDomSoKcofcn39E3c7vUcmeacb1FjRJbU/5aw0MSfTX3W6iUQMeWCcpoCsEpy7/WR1+bJRxYYVZFGd4jMjE5YaJ/lu2syFg+MprPztmHzaTVmT7K8LrzIqXG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(136003)(366004)(346002)(9746002)(9786002)(8676002)(6666004)(4326008)(54906003)(8936002)(5660300002)(36756003)(316002)(110136005)(83380400001)(66946007)(6636002)(66556008)(186003)(26005)(66476007)(478600001)(2906002)(426003)(86362001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?CzqoEbuahJnQjrL+b4kf8ZhNy1NdyhoY75qMB1lrCE2afNyAc/N474DVZeeE?=
 =?us-ascii?Q?LL1YdAVgdBWQnfCyajQ4IZFAxQCjn9zMbh0EfsCMrJBlPnN2URl8f9CysyJr?=
 =?us-ascii?Q?kiQIazjm99FzqGVEOBSnxJSzI494LxFIH+1QMiI7VQ6IkwJylAAaAM1XKM2w?=
 =?us-ascii?Q?h9LVZ9ZCELfHnayuGgJc4e2rRc1od2A+kS0yNyKJvYUPKaJCYyyCGkjcN9zD?=
 =?us-ascii?Q?pGYGoCFdnFvFxqHm8ryHn8Z3BB5maJJ9dkfkz8PPOx1Cco30uONPRszPEp+d?=
 =?us-ascii?Q?gZEoKaPAYBZVg+JMOAQRIiDnxNt76MLYH3wXj+dFSxrn54UYyHfQI682JtIm?=
 =?us-ascii?Q?hcXic7JUAx8RM0jI2B4aZdsaydSDfT3La9iqk/H0bdt+OKcZPt8kGfzrYL1o?=
 =?us-ascii?Q?Hs7iHXoFoYvW46VRBKAKd2xgunXwx1/6bpfWsBYNh64FI8cb+yWtMXztqwix?=
 =?us-ascii?Q?V4tuAQsNJ5mskDtSVltkMyUK1XXWQ1qVgmXLb9tfNsrX2mzsjrI3gor0M3pt?=
 =?us-ascii?Q?7fkXlFa2Z3YmqfXZnl4kM0H+B3z1mUJBxanb5zerKG5Qt2OL7vTZOEvKj8L0?=
 =?us-ascii?Q?5tU17AXdHKBX70aMEhNOiEGUIbiFXDl7+PJk2Dux76YtWZK9yH29eyPYm4FD?=
 =?us-ascii?Q?absNfVThbni9HVrwcRE8OBF7L/B7o0QZ5AjmIuQG6g/eb2GiQELaWKy+l+hJ?=
 =?us-ascii?Q?4Q0YttC3zp3VRzYa6EeyfRoC0Z42joUPqQqYcPS8nMrOhe8GZhBDipexBykQ?=
 =?us-ascii?Q?BmYLEcY6JmQ50s95FCunBmPD8OE0qxwK99Xb5GAYN9RmPK0MZ3duUEhPmLFE?=
 =?us-ascii?Q?66I20l7wIUdNpq/OMrNRnYsji1ZJJmH6Cn4O16AhIw+pbLZexpcGQL7kpqpZ?=
 =?us-ascii?Q?jkULGxrNr9pOawnwnfi9Zfa6zqDxN+CpQhqa1D+zL3UB7c2d6GZYsrpubcCK?=
 =?us-ascii?Q?HM0h/OF1tS4SIIXyFXczvOoDzCmIWjvmRfLKVy75JZ++xW0oZZxodo8jlkK5?=
 =?us-ascii?Q?1hEBTya5ndxIols5TL9x2jV3vBaKuW4PWRbLS5AvINpAjUbOpfuThVATBk0F?=
 =?us-ascii?Q?AqqaFKoiQGbBgrzThq/fTnU/CGeMSbuUIA36rXL+koRQL9tXab/RZ/MksXW6?=
 =?us-ascii?Q?Cu8Y4/7HfV05dO8qPYslsXbWLYxw32A2DT8T2wAhW01b7HLGq3iSQYORcGvX?=
 =?us-ascii?Q?/PHwyIFZ0Pb5/MDFJ89RM/bwvVxb/joCC556u0yLMWb/Is2P5CgHEi73xkgC?=
 =?us-ascii?Q?N6UsWCTQBGXHfh5kUYRBWOD55JFwMcJuBzYC/M3E3GAREATj0Lz7webISbmD?=
 =?us-ascii?Q?5Cu18Wy7x7V2sQKRvRJlYtNJsf1orYONEzuhh1Lc1STgGw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5acad42c-b35a-40c9-b8b9-08d8e5baca70
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2021 00:56:09.8646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: As4fTmady0z6J/aVaJdt/1xbUxnwpyAPRJEoOW/8fSqdVIWm85RsyTNWfUsQ61Xg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2940
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

mdev gets little benefit because it doesn't actually do anything, however
it is the last user, so move the code here for now.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Liu Yi L <yi.l.liu@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/mdev/vfio_mdev.c | 24 +++++++++++++++++++--
 drivers/vfio/vfio.c           | 39 ++---------------------------------
 include/linux/vfio.h          |  5 -----
 3 files changed, 24 insertions(+), 44 deletions(-)

diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.c
index b52eea128549ee..4469aaf31b56cb 100644
--- a/drivers/vfio/mdev/vfio_mdev.c
+++ b/drivers/vfio/mdev/vfio_mdev.c
@@ -21,6 +21,10 @@
 #define DRIVER_AUTHOR   "NVIDIA Corporation"
 #define DRIVER_DESC     "VFIO based driver for Mediated device"
 
+struct mdev_vfio_device {
+	struct vfio_device vdev;
+};
+
 static int vfio_mdev_open(void *device_data)
 {
 	struct mdev_device *mdev = device_data;
@@ -124,13 +128,29 @@ static const struct vfio_device_ops vfio_mdev_dev_ops = {
 static int vfio_mdev_probe(struct device *dev)
 {
 	struct mdev_device *mdev = to_mdev_device(dev);
+	struct mdev_vfio_device *mvdev;
+	int ret;
 
-	return vfio_add_group_dev(dev, &vfio_mdev_dev_ops, mdev);
+	mvdev = kzalloc(sizeof(*mvdev), GFP_KERNEL);
+	if (!mvdev)
+		return -ENOMEM;
+
+	vfio_init_group_dev(&mvdev->vdev, &mdev->dev, &vfio_mdev_dev_ops, mdev);
+	ret = vfio_register_group_dev(&mvdev->vdev);
+	if (ret) {
+		kfree(mvdev);
+		return ret;
+	}
+	dev_set_drvdata(&mdev->dev, mvdev);
+	return 0;
 }
 
 static void vfio_mdev_remove(struct device *dev)
 {
-	vfio_del_group_dev(dev);
+	struct mdev_vfio_device *mvdev = dev_get_drvdata(dev);
+
+	vfio_unregister_group_dev(&mvdev->vdev);
+	kfree(mvdev);
 }
 
 static struct mdev_driver vfio_mdev_driver = {
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index cfa06ae3b9018b..2d6d7cc1d1ebf9 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -99,8 +99,8 @@ MODULE_PARM_DESC(enable_unsafe_noiommu_mode, "Enable UNSAFE, no-IOMMU mode.  Thi
 /*
  * vfio_iommu_group_{get,put} are only intended for VFIO bus driver probe
  * and remove functions, any use cases other than acquiring the first
- * reference for the purpose of calling vfio_add_group_dev() or removing
- * that symmetric reference after vfio_del_group_dev() should use the raw
+ * reference for the purpose of calling vfio_register_group_dev() or removing
+ * that symmetric reference after vfio_unregister_group_dev() should use the raw
  * iommu_group_{get,put} functions.  In particular, vfio_iommu_group_put()
  * removes the device from the dummy group and cannot be nested.
  */
@@ -799,29 +799,6 @@ int vfio_register_group_dev(struct vfio_device *device)
 }
 EXPORT_SYMBOL_GPL(vfio_register_group_dev);
 
-int vfio_add_group_dev(struct device *dev, const struct vfio_device_ops *ops,
-		       void *device_data)
-{
-	struct vfio_device *device;
-	int ret;
-
-	device = kzalloc(sizeof(*device), GFP_KERNEL);
-	if (!device)
-		return -ENOMEM;
-
-	vfio_init_group_dev(device, dev, ops, device_data);
-	ret = vfio_register_group_dev(device);
-	if (ret)
-		goto err_kfree;
-	dev_set_drvdata(dev, device);
-	return 0;
-
-err_kfree:
-	kfree(device);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(vfio_add_group_dev);
-
 /**
  * Get a reference to the vfio_device for a device.  Even if the
  * caller thinks they own the device, they could be racing with a
@@ -962,18 +939,6 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 }
 EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
 
-void *vfio_del_group_dev(struct device *dev)
-{
-	struct vfio_device *device = dev_get_drvdata(dev);
-	void *device_data = device->device_data;
-
-	vfio_unregister_group_dev(device);
-	dev_set_drvdata(dev, NULL);
-	kfree(device);
-	return device_data;
-}
-EXPORT_SYMBOL_GPL(vfio_del_group_dev);
-
 /**
  * VFIO base fd, /dev/vfio/vfio
  */
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index ad8b579d67d34a..4995faf51efeae 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -63,11 +63,6 @@ extern void vfio_iommu_group_put(struct iommu_group *group, struct device *dev);
 void vfio_init_group_dev(struct vfio_device *device, struct device *dev,
 			 const struct vfio_device_ops *ops, void *device_data);
 int vfio_register_group_dev(struct vfio_device *device);
-extern int vfio_add_group_dev(struct device *dev,
-			      const struct vfio_device_ops *ops,
-			      void *device_data);
-
-extern void *vfio_del_group_dev(struct device *dev);
 void vfio_unregister_group_dev(struct vfio_device *device);
 extern struct vfio_device *vfio_device_get_from_dev(struct device *dev);
 extern void vfio_device_put(struct vfio_device *device);
-- 
2.30.2

