Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B98B3466F9
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 18:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbhCWR4W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 13:56:22 -0400
Received: from mail-bn8nam12on2077.outbound.protection.outlook.com ([40.107.237.77]:36673
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231338AbhCWRzq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 13:55:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZAB9gnNgjPwOf8c+ckGKi3irbdxKxWR86W/4Gu+U3IecaFre4W8NFr7aCCywuM5MsYmSKiIUHYJhl5MEkxhzY0PuWu72x2j3YhUGEDQJM7+mfirBcNFcpJ7OTZDlHafxoiEjB/HBIz4svDglh+MXaH9rBq750mfytu12wdyQKFzazfmqD2Vl+Tg+razUGR0+GIwgc+7eGlj2YTizTEw4nosAPR+K/CvVljDsD4TkWLj65/qJdeQLyHEmgGsMSQ7aITEfUSAzErQydGRvFwXx556DDmalzoFWTJDrOoJUHzfivbuElP2/EyOwc5ukZSgl356mkKbxadXsHg2tX3sq0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rN+SzwthwoTDPJovcRyTFOvgz1yqbotPudBWjrbNd1k=;
 b=jf9ARZN63jnRuIIuRMjOOV1KqwtvpYZQT3xk+1mTCTLaGyM8VJN5xRYZwZAuwv+K2nZaj6WN478jFzpqhBSX14/oRhmQdeFPcE2K2TbrpuSZ/kD166U+t7epy2m5bVpPyjCE/lbVxWuxc1mqoRlpm9eecEDQM5dAaVXSMp/dE79F63BuYg9tNFKxjuaNtnOmVFcJYLtIDcrUVAUyUbpsRNmxqCFTBaebe2zs+38bXiaVPf3s0m55gZsbU5itqVkRKq2vTtJZ1Uz1aDadfohbRVEidnOTJo5OvN3PSQhsuZbKSLxQrqxz9ofp2Xz3qf8xFJUS9hd07BW9wdPXlRG/Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rN+SzwthwoTDPJovcRyTFOvgz1yqbotPudBWjrbNd1k=;
 b=DEWAFWOXtcPiDGA99uN5DxgzTyqXBfTqVO/0cUVmlYn8FU/5QuOuNEQRKycMzJes+k/eQzZAKs7qSXqrFG7RJE4FjbSCA2Mx5P6G5PC4282QuerkPEbS+DYT295+PoMVOi7p2rGNCuiHf76XLabVKBpAbu6K1eQTodZpiv3Enp7gLRvVNAPmpZOLTp0kyz6f0sdAOpLAqJAFULYrd6OObpTP/OtILTXRLf8FR4K0FozQc/obTORjrlabojd5kzMgVfq/yGwcwt+PynqZN406W9Me95hvdTZ8c33hQPhOQGsan9PPyQRJFG6qNNDRQRBIIlvNeKpmclTr7ATBN71Tvg==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4943.namprd12.prod.outlook.com (2603:10b6:5:1bc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Tue, 23 Mar
 2021 17:55:44 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 17:55:43 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH 02/18] vfio/mdev: Add missing typesafety around mdev_device
Date:   Tue, 23 Mar 2021 14:55:19 -0300
Message-Id: <2-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
In-Reply-To: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: BL0PR0102CA0007.prod.exchangelabs.com
 (2603:10b6:207:18::20) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by BL0PR0102CA0007.prod.exchangelabs.com (2603:10b6:207:18::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Tue, 23 Mar 2021 17:55:40 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lOlFf-001cgU-7Z; Tue, 23 Mar 2021 14:55:35 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a382bd8f-cad8-4c58-2806-08d8ee24df5c
X-MS-TrafficTypeDiagnostic: DM6PR12MB4943:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4943E4CE9FB6451DE15E4599C2649@DM6PR12MB4943.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YeV6d8+BSjTwxwDx9x6ju3gmdzBNOXC2IW3KSVm0dqNJtATEg8fxLieM7PFdBPOMNPdKGblCb9OigFdphb+fnFTFpDIP2q79vtTRtUBToaaOYxrD9uigab+ZdFVSD3ySXAVX+zqpVHuhpaSwKlJRz0xudX2UV3RD5V98qK2fQT0AYxm//Glj8BzyuIx2WqjhpW8DbUNG2anQciMEnqy80ZNeO3HpkII9wB+MtYLTlllzAKFvzH68S4MX34Bv8FVXYQh4ApaN9vW7wWeOKsBxJtobXrd11oNjJriiP+hIzsVsG1P7jYRsuJ27ECtSMeg0BPqRaCdtvi34HVRSJppzXBU+H7bibt8hgnyeFFQpRjP5QqMsAcHe5lamKTaK7riPoCSKmBr1FGxkpbhtzbB5kcAYTY+LZEq9xC7V3BdBdPWkYneAU91s1O/l45+dFQPLgk8iB+kdbQpdfncxBLlKPG/z30GMLxx2kMPJ2A+2wGcUGCJdLyQHP4O3gvP+FJUSyw6DuwDXKARrJThkJtya/LXVcXlvC6FKoEyS96Tb+uOcW5e2HBGa8/aVvP/M2f/NlRkmc2HtrakfRugmOW4/oPkhqFTLi42rMrByWAM2VNPtcX1JmOK+8/qEuDdz8shjt/9J8MBBAfQFis2goUbx8IZBlWLOM/Xsv8zEFYlEe8M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(376002)(366004)(346002)(66476007)(186003)(107886003)(6666004)(8936002)(110136005)(36756003)(426003)(86362001)(54906003)(83380400001)(2616005)(38100700001)(30864003)(66946007)(5660300002)(478600001)(9746002)(66556008)(8676002)(4326008)(2906002)(26005)(316002)(9786002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?mR5AcRZsXSeUyx46Z3+EZ01WUN9kvTwjkYtPQji9HWG666+lNNmz4tU4Q5qp?=
 =?us-ascii?Q?0MlR0ahDo3OEmU+RqU7Xrr469kIq01Tawnbmm1E6k3b375StE/Fgj8/yh7Va?=
 =?us-ascii?Q?H3G9m3f5t+U+Pgf39FKGWK+alo8BXY0yxTviR+32GZ9IF1OFM/CTXwcdOQjv?=
 =?us-ascii?Q?sLAjrRSPei2ZkXrCknXlo2QkPvzz0KA3YdO6++Vv5X5vkQMWd3HBftNhQqJt?=
 =?us-ascii?Q?lFL7Ddobzt6jXKqy+pwmb84v51gakj1DF13GKq2YYTGFqnmRzw9HCaDQgLU4?=
 =?us-ascii?Q?LdD2LPIX3x1n4be7whYzSgmAHxplqEkfH486IlXeAb5qo19FC0+HAUt6qJ+l?=
 =?us-ascii?Q?DJPmZ4H88hsj8euBxJprU0qT70cakawkWltIV7jFWtU2F7fwkrreY0IeAJ0a?=
 =?us-ascii?Q?s28Mru7Rt3YnWICcPvtB4yfgTkMvgqE2RQOOdFv1HaicJyWHCo/Sa/q8mI6U?=
 =?us-ascii?Q?3oBPb+mj8Ml1CktN+iTV1sc+dmiD38Zju4Uy/h3O/ui04RQimQpO3aL7bW24?=
 =?us-ascii?Q?KZ3SxQ6pYiQMUGmf0SSRSzletEDq0x1FbzYQ1nbzK+nLiVPCsYjgOYHxO2Wh?=
 =?us-ascii?Q?sj0EbwAp9PTgGnyilksJlpPuT3TB0gLdtXRrmYzafK3VOFVao7blxmCHfHRu?=
 =?us-ascii?Q?G147ySk5cR8LQ8hRetnCkeSXvwH0aGJoVN2AETdVDY/hxlnC2wiSRYWHbr5L?=
 =?us-ascii?Q?R8Jr+Of41iai5kDfSb7caylmiiHK+KtY+sjJ8iVcmG+6dWuPFz+Wp7g/CqfE?=
 =?us-ascii?Q?wcjsGPuokGzB2OlXYh/lbFlwP1zaGQJKxNhAjgD6Rf91/NYS69Thb33HA+Dp?=
 =?us-ascii?Q?jAedzpH+VcjABU84CnGK8OTHqj1uySDAlj56XjOGvI9faI+36/kZfzNmFe03?=
 =?us-ascii?Q?UPb516VZiK9ybxvuL09a2CP2xOLomW1PqkhvkNwb2Uqs3PS/RKl17pDuPKpl?=
 =?us-ascii?Q?iUrs9dcXmDg9hDM8FM2zQsyUmcbCIn+Ap5odvPAFq69OCZDrkD5EzHtm1p7x?=
 =?us-ascii?Q?QPqOd89z3Ud7aWdeZzjY+VJTnNGG280zif6CdZegE5jCn/920FnimYTazKJO?=
 =?us-ascii?Q?xTWsYygfrGKlwT0JAycNqRlwFA1dOF7knz44HBnwvCK43MSKFOIqaKXYE2Ct?=
 =?us-ascii?Q?yioszuvVRPdj8/R7s+/kMd4r4BVdQ9SABG9mRFB+wxvO6Hd108CFHxODFmdI?=
 =?us-ascii?Q?Sr5kJbAgEAmdOCl8U7Dv0vjCpcLXjFp2a8BLKHgIwOFirA3JGWeP7r7sDPWb?=
 =?us-ascii?Q?3nJCR10ShAzRwMfxn57OfEcGt13XK5QLu+lriKKO3hL0fSUznm+QGAHsUFtX?=
 =?us-ascii?Q?rOkgRWqOICo1xG9wLZB5OjOY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a382bd8f-cad8-4c58-2806-08d8ee24df5c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 17:55:41.2584
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jrGnUrJ8KzjkS3YZGuyZvHhJSlW+8Gr+oN3RvsdIJmc7TPQ5rYiCgYNMF2/0NXx7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4943
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The mdev API should accept and pass a 'struct mdev_device *' in all
places, not pass a 'struct device *' and cast it internally with
to_mdev_device(). Particularly in its struct mdev_driver functions, the
whole point of a bus's struct device_driver wrapper is to provide type
safety compared to the default struct device_driver.

Further, the driver core standard is for bus drivers to expose their
device structure in their public headers that can be used with
container_of() inlines and '&foo->dev' to go between the class levels, and
'&foo->dev' to be used with dev_err/etc driver core helper functions. Move
'struct mdev_device' to mdev.h

Once done this allows moving some one instruction exported functions to
static inlines, which in turns allows removing one of the two grotesque
symbol_get()'s related to mdev in the core code.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../driver-api/vfio-mediated-device.rst       |  4 +-
 drivers/vfio/mdev/mdev_core.c                 | 64 ++-----------------
 drivers/vfio/mdev/mdev_driver.c               |  4 +-
 drivers/vfio/mdev/mdev_private.h              | 23 +------
 drivers/vfio/mdev/mdev_sysfs.c                | 26 ++++----
 drivers/vfio/mdev/vfio_mdev.c                 |  7 +-
 drivers/vfio/vfio_iommu_type1.c               | 25 ++------
 include/linux/mdev.h                          | 58 +++++++++++++----
 8 files changed, 83 insertions(+), 128 deletions(-)

diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
index 25eb7d5b834ba3..c43c1dc3333373 100644
--- a/Documentation/driver-api/vfio-mediated-device.rst
+++ b/Documentation/driver-api/vfio-mediated-device.rst
@@ -105,8 +105,8 @@ structure to represent a mediated device's driver::
       */
      struct mdev_driver {
 	     const char *name;
-	     int  (*probe)  (struct device *dev);
-	     void (*remove) (struct device *dev);
+	     int  (*probe)  (struct mdev_device *dev);
+	     void (*remove) (struct mdev_device *dev);
 	     struct device_driver    driver;
      };
 
diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index 6de97d25a3f87d..057922a1707e04 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -33,36 +33,6 @@ struct device *mdev_parent_dev(struct mdev_device *mdev)
 }
 EXPORT_SYMBOL(mdev_parent_dev);
 
-void *mdev_get_drvdata(struct mdev_device *mdev)
-{
-	return mdev->driver_data;
-}
-EXPORT_SYMBOL(mdev_get_drvdata);
-
-void mdev_set_drvdata(struct mdev_device *mdev, void *data)
-{
-	mdev->driver_data = data;
-}
-EXPORT_SYMBOL(mdev_set_drvdata);
-
-struct device *mdev_dev(struct mdev_device *mdev)
-{
-	return &mdev->dev;
-}
-EXPORT_SYMBOL(mdev_dev);
-
-struct mdev_device *mdev_from_dev(struct device *dev)
-{
-	return dev_is_mdev(dev) ? to_mdev_device(dev) : NULL;
-}
-EXPORT_SYMBOL(mdev_from_dev);
-
-const guid_t *mdev_uuid(struct mdev_device *mdev)
-{
-	return &mdev->uuid;
-}
-EXPORT_SYMBOL(mdev_uuid);
-
 /* Should be called holding parent_list_lock */
 static struct mdev_parent *__find_parent_device(struct device *dev)
 {
@@ -107,7 +77,7 @@ static void mdev_device_remove_common(struct mdev_device *mdev)
 	int ret;
 
 	type = to_mdev_type(mdev->type_kobj);
-	mdev_remove_sysfs_files(&mdev->dev, type);
+	mdev_remove_sysfs_files(mdev, type);
 	device_del(&mdev->dev);
 	parent = mdev->parent;
 	lockdep_assert_held(&parent->unreg_sem);
@@ -122,12 +92,10 @@ static void mdev_device_remove_common(struct mdev_device *mdev)
 
 static int mdev_device_remove_cb(struct device *dev, void *data)
 {
-	if (dev_is_mdev(dev)) {
-		struct mdev_device *mdev;
+	struct mdev_device *mdev = mdev_from_dev(dev);
 
-		mdev = to_mdev_device(dev);
+	if (mdev)
 		mdev_device_remove_common(mdev);
-	}
 	return 0;
 }
 
@@ -332,7 +300,7 @@ int mdev_device_create(struct kobject *kobj,
 	if (ret)
 		goto add_fail;
 
-	ret = mdev_create_sysfs_files(&mdev->dev, type);
+	ret = mdev_create_sysfs_files(mdev, type);
 	if (ret)
 		goto sysfs_fail;
 
@@ -354,13 +322,11 @@ int mdev_device_create(struct kobject *kobj,
 	return ret;
 }
 
-int mdev_device_remove(struct device *dev)
+int mdev_device_remove(struct mdev_device *mdev)
 {
-	struct mdev_device *mdev, *tmp;
+	struct mdev_device *tmp;
 	struct mdev_parent *parent;
 
-	mdev = to_mdev_device(dev);
-
 	mutex_lock(&mdev_list_lock);
 	list_for_each_entry(tmp, &mdev_list, next) {
 		if (tmp == mdev)
@@ -390,24 +356,6 @@ int mdev_device_remove(struct device *dev)
 	return 0;
 }
 
-int mdev_set_iommu_device(struct device *dev, struct device *iommu_device)
-{
-	struct mdev_device *mdev = to_mdev_device(dev);
-
-	mdev->iommu_device = iommu_device;
-
-	return 0;
-}
-EXPORT_SYMBOL(mdev_set_iommu_device);
-
-struct device *mdev_get_iommu_device(struct device *dev)
-{
-	struct mdev_device *mdev = to_mdev_device(dev);
-
-	return mdev->iommu_device;
-}
-EXPORT_SYMBOL(mdev_get_iommu_device);
-
 static int __init mdev_init(void)
 {
 	return mdev_bus_register();
diff --git a/drivers/vfio/mdev/mdev_driver.c b/drivers/vfio/mdev/mdev_driver.c
index 0d3223aee20b83..44c3ba7e56d923 100644
--- a/drivers/vfio/mdev/mdev_driver.c
+++ b/drivers/vfio/mdev/mdev_driver.c
@@ -48,7 +48,7 @@ static int mdev_probe(struct device *dev)
 		return ret;
 
 	if (drv && drv->probe) {
-		ret = drv->probe(dev);
+		ret = drv->probe(mdev);
 		if (ret)
 			mdev_detach_iommu(mdev);
 	}
@@ -62,7 +62,7 @@ static int mdev_remove(struct device *dev)
 	struct mdev_device *mdev = to_mdev_device(dev);
 
 	if (drv && drv->remove)
-		drv->remove(dev);
+		drv->remove(mdev);
 
 	mdev_detach_iommu(mdev);
 
diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
index 74c2e541146999..bb60ec4a8d9d21 100644
--- a/drivers/vfio/mdev/mdev_private.h
+++ b/drivers/vfio/mdev/mdev_private.h
@@ -24,23 +24,6 @@ struct mdev_parent {
 	struct rw_semaphore unreg_sem;
 };
 
-struct mdev_device {
-	struct device dev;
-	struct mdev_parent *parent;
-	guid_t uuid;
-	void *driver_data;
-	struct list_head next;
-	struct kobject *type_kobj;
-	struct device *iommu_device;
-	bool active;
-};
-
-static inline struct mdev_device *to_mdev_device(struct device *dev)
-{
-	return container_of(dev, struct mdev_device, dev);
-}
-#define dev_is_mdev(d)		((d)->bus == &mdev_bus_type)
-
 struct mdev_type {
 	struct kobject kobj;
 	struct kobject *devices_kobj;
@@ -57,11 +40,11 @@ struct mdev_type {
 int  parent_create_sysfs_files(struct mdev_parent *parent);
 void parent_remove_sysfs_files(struct mdev_parent *parent);
 
-int  mdev_create_sysfs_files(struct device *dev, struct mdev_type *type);
-void mdev_remove_sysfs_files(struct device *dev, struct mdev_type *type);
+int  mdev_create_sysfs_files(struct mdev_device *mdev, struct mdev_type *type);
+void mdev_remove_sysfs_files(struct mdev_device *mdev, struct mdev_type *type);
 
 int  mdev_device_create(struct kobject *kobj,
 			struct device *dev, const guid_t *uuid);
-int  mdev_device_remove(struct device *dev);
+int  mdev_device_remove(struct mdev_device *dev);
 
 #endif /* MDEV_PRIVATE_H */
diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
index 917fd84c1c6f24..6a5450587b79e9 100644
--- a/drivers/vfio/mdev/mdev_sysfs.c
+++ b/drivers/vfio/mdev/mdev_sysfs.c
@@ -225,6 +225,7 @@ int parent_create_sysfs_files(struct mdev_parent *parent)
 static ssize_t remove_store(struct device *dev, struct device_attribute *attr,
 			    const char *buf, size_t count)
 {
+	struct mdev_device *mdev = to_mdev_device(dev);
 	unsigned long val;
 
 	if (kstrtoul(buf, 0, &val) < 0)
@@ -233,7 +234,7 @@ static ssize_t remove_store(struct device *dev, struct device_attribute *attr,
 	if (val && device_remove_file_self(dev, attr)) {
 		int ret;
 
-		ret = mdev_device_remove(dev);
+		ret = mdev_device_remove(mdev);
 		if (ret)
 			return ret;
 	}
@@ -248,34 +249,37 @@ static const struct attribute *mdev_device_attrs[] = {
 	NULL,
 };
 
-int  mdev_create_sysfs_files(struct device *dev, struct mdev_type *type)
+int mdev_create_sysfs_files(struct mdev_device *mdev, struct mdev_type *type)
 {
+	struct kobject *kobj = &mdev->dev.kobj;
 	int ret;
 
-	ret = sysfs_create_link(type->devices_kobj, &dev->kobj, dev_name(dev));
+	ret = sysfs_create_link(type->devices_kobj, kobj, dev_name(&mdev->dev));
 	if (ret)
 		return ret;
 
-	ret = sysfs_create_link(&dev->kobj, &type->kobj, "mdev_type");
+	ret = sysfs_create_link(kobj, &type->kobj, "mdev_type");
 	if (ret)
 		goto type_link_failed;
 
-	ret = sysfs_create_files(&dev->kobj, mdev_device_attrs);
+	ret = sysfs_create_files(kobj, mdev_device_attrs);
 	if (ret)
 		goto create_files_failed;
 
 	return ret;
 
 create_files_failed:
-	sysfs_remove_link(&dev->kobj, "mdev_type");
+	sysfs_remove_link(kobj, "mdev_type");
 type_link_failed:
-	sysfs_remove_link(type->devices_kobj, dev_name(dev));
+	sysfs_remove_link(type->devices_kobj, dev_name(&mdev->dev));
 	return ret;
 }
 
-void mdev_remove_sysfs_files(struct device *dev, struct mdev_type *type)
+void mdev_remove_sysfs_files(struct mdev_device *mdev, struct mdev_type *type)
 {
-	sysfs_remove_files(&dev->kobj, mdev_device_attrs);
-	sysfs_remove_link(&dev->kobj, "mdev_type");
-	sysfs_remove_link(type->devices_kobj, dev_name(dev));
+	struct kobject *kobj = &mdev->dev.kobj;
+
+	sysfs_remove_files(kobj, mdev_device_attrs);
+	sysfs_remove_link(kobj, "mdev_type");
+	sysfs_remove_link(type->devices_kobj, dev_name(&mdev->dev));
 }
diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.c
index ae7e322fbe3c26..91b7b8b9eb9cb8 100644
--- a/drivers/vfio/mdev/vfio_mdev.c
+++ b/drivers/vfio/mdev/vfio_mdev.c
@@ -124,9 +124,8 @@ static const struct vfio_device_ops vfio_mdev_dev_ops = {
 	.request	= vfio_mdev_request,
 };
 
-static int vfio_mdev_probe(struct device *dev)
+static int vfio_mdev_probe(struct mdev_device *mdev)
 {
-	struct mdev_device *mdev = to_mdev_device(dev);
 	struct vfio_device *vdev;
 	int ret;
 
@@ -144,9 +143,9 @@ static int vfio_mdev_probe(struct device *dev)
 	return 0;
 }
 
-static void vfio_mdev_remove(struct device *dev)
+static void vfio_mdev_remove(struct mdev_device *mdev)
 {
-	struct vfio_device *vdev = dev_get_drvdata(dev);
+	struct vfio_device *vdev = dev_get_drvdata(&mdev->dev);
 
 	vfio_unregister_group_dev(vdev);
 	kfree(vdev);
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 4bb162c1d649b3..90b45ff1d87a7b 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1923,28 +1923,13 @@ static bool vfio_iommu_has_sw_msi(struct list_head *group_resv_regions,
 	return ret;
 }
 
-static struct device *vfio_mdev_get_iommu_device(struct device *dev)
-{
-	struct device *(*fn)(struct device *dev);
-	struct device *iommu_device;
-
-	fn = symbol_get(mdev_get_iommu_device);
-	if (fn) {
-		iommu_device = fn(dev);
-		symbol_put(mdev_get_iommu_device);
-
-		return iommu_device;
-	}
-
-	return NULL;
-}
-
 static int vfio_mdev_attach_domain(struct device *dev, void *data)
 {
+	struct mdev_device *mdev = to_mdev_device(dev);
 	struct iommu_domain *domain = data;
 	struct device *iommu_device;
 
-	iommu_device = vfio_mdev_get_iommu_device(dev);
+	iommu_device = mdev_get_iommu_device(mdev);
 	if (iommu_device) {
 		if (iommu_dev_feature_enabled(iommu_device, IOMMU_DEV_FEAT_AUX))
 			return iommu_aux_attach_device(domain, iommu_device);
@@ -1957,10 +1942,11 @@ static int vfio_mdev_attach_domain(struct device *dev, void *data)
 
 static int vfio_mdev_detach_domain(struct device *dev, void *data)
 {
+	struct mdev_device *mdev = to_mdev_device(dev);
 	struct iommu_domain *domain = data;
 	struct device *iommu_device;
 
-	iommu_device = vfio_mdev_get_iommu_device(dev);
+	iommu_device = mdev_get_iommu_device(mdev);
 	if (iommu_device) {
 		if (iommu_dev_feature_enabled(iommu_device, IOMMU_DEV_FEAT_AUX))
 			iommu_aux_detach_device(domain, iommu_device);
@@ -2008,9 +1994,10 @@ static bool vfio_bus_is_mdev(struct bus_type *bus)
 
 static int vfio_mdev_iommu_device(struct device *dev, void *data)
 {
+	struct mdev_device *mdev = to_mdev_device(dev);
 	struct device **old = data, *new;
 
-	new = vfio_mdev_get_iommu_device(dev);
+	new = mdev_get_iommu_device(mdev);
 	if (!new || (*old && *old != new))
 		return -EINVAL;
 
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index 27eb383cb95de0..52f7ea19dd0f56 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -10,7 +10,21 @@
 #ifndef MDEV_H
 #define MDEV_H
 
-struct mdev_device;
+struct mdev_device {
+	struct device dev;
+	struct mdev_parent *parent;
+	guid_t uuid;
+	void *driver_data;
+	struct list_head next;
+	struct kobject *type_kobj;
+	struct device *iommu_device;
+	bool active;
+};
+
+static inline struct mdev_device *to_mdev_device(struct device *dev)
+{
+	return container_of(dev, struct mdev_device, dev);
+}
 
 /*
  * Called by the parent device driver to set the device which represents
@@ -19,12 +33,17 @@ struct mdev_device;
  *
  * @dev: the mediated device that iommu will isolate.
  * @iommu_device: a pci device which represents the iommu for @dev.
- *
- * Return 0 for success, otherwise negative error value.
  */
-int mdev_set_iommu_device(struct device *dev, struct device *iommu_device);
+static inline void mdev_set_iommu_device(struct mdev_device *mdev,
+					 struct device *iommu_device)
+{
+	mdev->iommu_device = iommu_device;
+}
 
-struct device *mdev_get_iommu_device(struct device *dev);
+static inline struct device *mdev_get_iommu_device(struct mdev_device *mdev)
+{
+	return mdev->iommu_device;
+}
 
 /**
  * struct mdev_parent_ops - Structure to be registered for each parent device to
@@ -126,16 +145,25 @@ struct mdev_type_attribute mdev_type_attr_##_name =		\
  **/
 struct mdev_driver {
 	const char *name;
-	int  (*probe)(struct device *dev);
-	void (*remove)(struct device *dev);
+	int (*probe)(struct mdev_device *dev);
+	void (*remove)(struct mdev_device *dev);
 	struct device_driver driver;
 };
 
 #define to_mdev_driver(drv)	container_of(drv, struct mdev_driver, driver)
 
-void *mdev_get_drvdata(struct mdev_device *mdev);
-void mdev_set_drvdata(struct mdev_device *mdev, void *data);
-const guid_t *mdev_uuid(struct mdev_device *mdev);
+static inline void *mdev_get_drvdata(struct mdev_device *mdev)
+{
+	return mdev->driver_data;
+}
+static inline void mdev_set_drvdata(struct mdev_device *mdev, void *data)
+{
+	mdev->driver_data = data;
+}
+static inline const guid_t *mdev_uuid(struct mdev_device *mdev)
+{
+	return &mdev->uuid;
+}
 
 extern struct bus_type mdev_bus_type;
 
@@ -146,7 +174,13 @@ int mdev_register_driver(struct mdev_driver *drv, struct module *owner);
 void mdev_unregister_driver(struct mdev_driver *drv);
 
 struct device *mdev_parent_dev(struct mdev_device *mdev);
-struct device *mdev_dev(struct mdev_device *mdev);
-struct mdev_device *mdev_from_dev(struct device *dev);
+static inline struct device *mdev_dev(struct mdev_device *mdev)
+{
+	return &mdev->dev;
+}
+static inline struct mdev_device *mdev_from_dev(struct device *dev)
+{
+	return dev->bus == &mdev_bus_type ? to_mdev_device(dev) : NULL;
+}
 
 #endif /* MDEV_H */
-- 
2.31.0

