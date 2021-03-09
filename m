Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D81D33310F
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 22:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232076AbhCIVjK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 16:39:10 -0500
Received: from mail-bn8nam12on2044.outbound.protection.outlook.com ([40.107.237.44]:47776
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232038AbhCIVjA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 16:39:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YNgkj3fkni2VO3QFxiHebaeNUxU8vp91D/j8/Tl9Yu18b+zMzp6DG+68PUZn9IPTHHMxiz28JXAaPbRzhcHzZfwISkVAg/ryYPQfy5lRJfxjd3A1sgKrZkQecg5+1k9kDbckw98gt2ne8c5cSEv3pIyumkNZri+VMcVmdpn4WrEj1Eu2Wa/sg+ccUsc9VOetwK4QnfSQLS43HbogJ+vmms7liFjiUitritgyLW97yyWT82ZnjWtb5FIENQf5IEFvh/N/vGNiUOhBIYGP6p6EfiS504KNEUX8lW7rotOu//Nwf20kNnrMCVYjMwwzf+f4AbFjHkN13JKhN2+o46gLwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CVocayPatYuE35Y02vSqQhvgQaMyFnNFEQsfelVvCWY=;
 b=WVHStV33iXFWj1pDQuKb9nv+iATRa6pqGOeJoGwCGimuu/0uZYBGQPHDrbP0zwwOMn6v060MJifr4NZU7h6t4jSh5oWAIo9gTw9UMZINZ8uw2Z6oXnYkwWn0WnK2qWaA5GvC40f3GTuBCaP2cxvX5qiY8e04SVTGn0pnaGf2lewh9311/dqH5xrFxqBESFC9ab/gISqsoTEvoEdj2RVCCTXQ6AAwGqbi+X/lut4iCaoiJSw5qJkUVo6WH2BJ/LLJv6c5gedO0Zrr2lYOlTb4Km4AhRJ980sdWfWy3uOYCi+VVjcyp5dPbbZpOSIbP28bxDfNKUxUEDlNj2RtAPN88w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CVocayPatYuE35Y02vSqQhvgQaMyFnNFEQsfelVvCWY=;
 b=L0ga3+ha28ZCBfTl59AZVEbkIsIphe/GPULO+QokzixgVpQnLiPhguffG4DjLWiV3Mly5Meen2UkFg4LZ/ZAcZJiqKhFtIeqZu2i9aaUC8pKL6ziJijWhv510rLt8VNG8oaeJohMJmdhTQA7SNbAui5leVK+gA8/lazGO0H13WGOUKmFTx9/bb4F8fI/CqjJRViKCVmVbOZVtzBD/Do9+vgDPxKLjNdyJs7UwTaqNAJJBnMqyoMed0LFPoTaVQ6Jk4n7ZspBBA49T8wfafm0jUAperMTUdNKAUs3TtG3QkaB8gYLF5rZvxmx52kv5K0tEUmhq9MzoTZ83/yJWObt9g==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1243.namprd12.prod.outlook.com (2603:10b6:3:74::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Tue, 9 Mar
 2021 21:38:57 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3912.027; Tue, 9 Mar 2021
 21:38:57 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH 10/10] vfio: Remove device_data from the vfio bus driver API
Date:   Tue,  9 Mar 2021 17:38:52 -0400
Message-Id: <10-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
In-Reply-To: <0-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR15CA0018.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::31) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR15CA0018.namprd15.prod.outlook.com (2603:10b6:208:1b4::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 21:38:55 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lJk45-00AVJF-0M; Tue, 09 Mar 2021 17:38:53 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30df3582-3723-418f-1ef4-08d8e343bd57
X-MS-TrafficTypeDiagnostic: DM5PR12MB1243:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB124306AC2639B865A762812CC2929@DM5PR12MB1243.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aaUjN5002+/7+W+LP01Nrsd0Vbwz1IZNrcOaaNitT8tVJYw9eNjHKJ4JG/hsDXWmRsF/3rAtUWQ9uiLWLv0ZRTiKBEdLT+m2+l3m2PNT47vo4226LnUMLKea1doIlcy6fJS7LHqpcLXgYfMX97XhRZ62QKLpfsvL0Xhmnn+l95yuO/GQvEPJmm2DXLLLslywKimFWflKccjhvK5keApJr9P5DnUV1P3W9RK82n1F61cX6Vt5Ch83TnR3Nga0CpixkZDlWMD+Oh8SqXcanKN6pjJ2A3xC8WJU2FxBu65TAEQAWn0BGM1YkiP5q9JnCERxEPee4VaGhxqQQAvJKgU7Y72SpX9qIC0ErOuHKVk4why0AOUEBWHZb+2pmRk/D5BHC3LsJjeQIOr3ggOUYspln13tjYqqoOVW/yGiGPoay13TgRFRi1Kg6Mf4gx5H0y3INp2I3SNU2QVBj2ZpfhU2NgzFr8dDwBU3d3iV4lZQdxQjSLiwUjDgaIVI/93Bs4TfxeyfXmvoFAafbcIUN6QQ0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(396003)(376002)(136003)(346002)(2616005)(83380400001)(426003)(66556008)(9786002)(66476007)(9746002)(107886003)(66946007)(8936002)(186003)(2906002)(86362001)(8676002)(26005)(36756003)(7416002)(54906003)(4326008)(316002)(5660300002)(110136005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?X5yR7NuU5399vp1zS8UhvMwSKPHrYd1uCCZ/4Z4ggjOZOgwHDxB6Fv0X/LhU?=
 =?us-ascii?Q?UKlcNClsvHDOz1BiGzdSMLIAkDAk4ABz0HeMi6icbWzFxGPi3fFhNx3afkL9?=
 =?us-ascii?Q?Zh2BfcSXpwTiN3lZE1RN7XQUS6c23HpzzJmD5V2UEtseKkem8jO9oYyjlyxr?=
 =?us-ascii?Q?nSC7ypWAUP8mNPp5upnBj1NLNlACg4ejUrDPckGGkUmuh01xa4rh1BGno8H1?=
 =?us-ascii?Q?i8ClzsyGxq+SDMTAyzotfItPL0fJnMdKFS1dg7HMO2XxCgqVt49TO8P9fgV7?=
 =?us-ascii?Q?hOjGHRFm+E2CO14xWOcqXSlOd12WvzFlnp31MjM227z80zku7AM3eI7OyBs/?=
 =?us-ascii?Q?3srhaaUW8SZ60KLUiTRUh7uQW8s9QbwnqAQ/WVOwDN1amTtippl6CsgrAe4x?=
 =?us-ascii?Q?zVUKWM3pW1wRDcjlm22PbRtTxt5E2TRHw2PX23c6cwOoEzVMx8VtVdisWNIC?=
 =?us-ascii?Q?XelHbEgi/rWYikoC9a7Z68xxRwhVqs1xNRmqDR+EexoCAacJ3ZRlgK4ba93M?=
 =?us-ascii?Q?iFYsyT1qxSsCQc181DRW7z+xQuJkLCAmOOc9pOk0qFDOWbRty/C0JmMzByo7?=
 =?us-ascii?Q?Jy0q9VqigTiWsBs+ljNJDhrBI7rJx1mIDx5d2EUWGNMQ0nsNXOesGI1VxN+D?=
 =?us-ascii?Q?Fsi2UHLUaADShaksYnQHFmMbHZ+TUXs0QwpHINGPeuUSEpe2QNwYyPRr1ESE?=
 =?us-ascii?Q?iI/T3FVBHxcF8jKIiqKr2HpUhXjbWH8Y07BOkqCWMc3DyzxJaN12L5yo2bAc?=
 =?us-ascii?Q?KXJOy1ujdfr+TTqISjTbS1VwqeckCI03uUp8JkEh/MfIppqM6rhC+MfLv7N5?=
 =?us-ascii?Q?pUMuMiOel0f239sceyQ+kskfwKLce9+zwl0v6r8zcgdB/NWY+BtnTyt4PH2Q?=
 =?us-ascii?Q?1/GdM0OkwUiYnGZW7R433EDIOFyBbwHBY2l7KZb/oLAlEONboUicFJ9ExPE2?=
 =?us-ascii?Q?g7cNoO7p+263JCVZUjvluvlH5/6nmJXyvtkPZ1bm6HKAkE7mKOrwDR/zyTnG?=
 =?us-ascii?Q?1fGIKKSTZ+BkLJczfBRojQbFP9xxc8Ijd/jZgVwfbAxm1eV1VFIfZs/Ez5gv?=
 =?us-ascii?Q?wN/k4xvJP8CGyIgoPkSdd4AFPhi4QxRg7qKYKkcGwQ5PvXUrghDJEbPSBk+8?=
 =?us-ascii?Q?r5W172UfqvTyIpGhb6tnnKOQI02QjRuyJukB5/hR6VGVGN/IV69nyc092NU8?=
 =?us-ascii?Q?WRt1D6Gt7yfSkwm/K/Ya4nt8cOoqGiKHOdMUbMPUVIYIyqQHSkRdXyLque1I?=
 =?us-ascii?Q?r+7uoPPEMa5t1MgAu/TkAvnKsQ34G6MwgRCWbCNmNXblZrlnDyd2nUEmqqUt?=
 =?us-ascii?Q?wty8jphBZ+HC8tvbvZoLB+2kA74bqC3p+ZttWY+dC0OCEA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30df3582-3723-418f-1ef4-08d8e343bd57
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 21:38:55.6759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jsVejDkgwtByKiFS6yiwmz3gnMhLd35brNmLLUUSR900S8VmSoUg7TY/x7fc795N
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1243
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are no longer any users, so it can go away. Everything is using
container_of now.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 Documentation/driver-api/vfio.rst            |  3 +--
 drivers/vfio/fsl-mc/vfio_fsl_mc.c            |  5 +++--
 drivers/vfio/mdev/vfio_mdev.c                |  2 +-
 drivers/vfio/pci/vfio_pci.c                  |  2 +-
 drivers/vfio/platform/vfio_platform_common.c |  2 +-
 drivers/vfio/vfio.c                          | 12 +-----------
 include/linux/vfio.h                         |  4 +---
 7 files changed, 9 insertions(+), 21 deletions(-)

diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api/vfio.rst
index 3337f337293a32..decc68cb8114ac 100644
--- a/Documentation/driver-api/vfio.rst
+++ b/Documentation/driver-api/vfio.rst
@@ -254,8 +254,7 @@ vfio_unregister_group_dev() respectively::
 
 	void vfio_init_group_dev(struct vfio_device *device,
 				struct device *dev,
-				const struct vfio_device_ops *ops,
-				void *device_data);
+				const struct vfio_device_ops *ops);
 	int vfio_register_group_dev(struct vfio_device *device);
 	void vfio_unregister_group_dev(struct vfio_device *device);
 
diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index 74a5de1b791934..07f636b9f6b472 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -75,7 +75,8 @@ static int vfio_fsl_mc_reflck_attach(struct vfio_fsl_mc_device *vdev)
 			goto unlock;
 		}
 
-		cont_vdev = vfio_device_data(device);
+		cont_vdev =
+			container_of(device, struct vfio_fsl_mc_device, vdev);
 		if (!cont_vdev || !cont_vdev->reflck) {
 			vfio_device_put(device);
 			ret = -ENODEV;
@@ -614,7 +615,7 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
 		goto out_group_put;
 	}
 
-	vfio_init_group_dev(&vdev->vdev, dev, &vfio_fsl_mc_ops, vdev);
+	vfio_init_group_dev(&vdev->vdev, dev, &vfio_fsl_mc_ops);
 	mutex_init(&vdev->igate);
 	vdev->mc_dev = mc_dev;
 
diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.c
index e7309caa99c71b..71bd28f976e5af 100644
--- a/drivers/vfio/mdev/vfio_mdev.c
+++ b/drivers/vfio/mdev/vfio_mdev.c
@@ -138,7 +138,7 @@ static int vfio_mdev_probe(struct device *dev)
 	if (!mvdev)
 		return -ENOMEM;
 
-	vfio_init_group_dev(&mvdev->vdev, &mdev->dev, &vfio_mdev_dev_ops, mdev);
+	vfio_init_group_dev(&mvdev->vdev, &mdev->dev, &vfio_mdev_dev_ops);
 	ret = vfio_register_group_dev(&mvdev->vdev);
 	if (ret) {
 		kfree(mvdev);
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 4b0d60f7602e40..3c2497ba79460c 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1962,7 +1962,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto out_group_put;
 	}
 
-	vfio_init_group_dev(&vdev->vdev, &pdev->dev, &vfio_pci_ops, vdev);
+	vfio_init_group_dev(&vdev->vdev, &pdev->dev, &vfio_pci_ops);
 	vdev->pdev = pdev;
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
 	mutex_init(&vdev->igate);
diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index f5f6b537084a67..361e5b57e36932 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -666,7 +666,7 @@ int vfio_platform_probe_common(struct vfio_platform_device *vdev,
 	struct iommu_group *group;
 	int ret;
 
-	vfio_init_group_dev(&vdev->vdev, dev, &vfio_platform_ops, vdev);
+	vfio_init_group_dev(&vdev->vdev, dev, &vfio_platform_ops);
 
 	ret = vfio_platform_acpi_probe(vdev, dev);
 	if (ret)
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 01de47d1810b6b..39ea77557ba0c4 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -741,12 +741,11 @@ static int vfio_iommu_group_notifier(struct notifier_block *nb,
  * VFIO driver API
  */
 void vfio_init_group_dev(struct vfio_device *device, struct device *dev,
-			 const struct vfio_device_ops *ops, void *device_data)
+			 const struct vfio_device_ops *ops)
 {
 	init_completion(&device->comp);
 	device->dev = dev;
 	device->ops = ops;
-	device->device_data = device_data;
 }
 EXPORT_SYMBOL_GPL(vfio_init_group_dev);
 
@@ -851,15 +850,6 @@ static struct vfio_device *vfio_device_get_from_name(struct vfio_group *group,
 	return device;
 }
 
-/*
- * Caller must hold a reference to the vfio_device
- */
-void *vfio_device_data(struct vfio_device *device)
-{
-	return device->device_data;
-}
-EXPORT_SYMBOL_GPL(vfio_device_data);
-
 /*
  * Decrement the device reference count and wait for the device to be
  * removed.  Open file descriptors for the device... */
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 784c34c0a28763..a2c5b30e1763ba 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -24,7 +24,6 @@ struct vfio_device {
 	refcount_t refcount;
 	struct completion comp;
 	struct list_head group_next;
-	void *device_data;
 };
 
 /**
@@ -61,12 +60,11 @@ extern struct iommu_group *vfio_iommu_group_get(struct device *dev);
 extern void vfio_iommu_group_put(struct iommu_group *group, struct device *dev);
 
 void vfio_init_group_dev(struct vfio_device *device, struct device *dev,
-			 const struct vfio_device_ops *ops, void *device_data);
+			 const struct vfio_device_ops *ops);
 int vfio_register_group_dev(struct vfio_device *device);
 void vfio_unregister_group_dev(struct vfio_device *device);
 extern struct vfio_device *vfio_device_get_from_dev(struct device *dev);
 extern void vfio_device_put(struct vfio_device *device);
-extern void *vfio_device_data(struct vfio_device *device);
 
 /* events for the backend driver notify callback */
 enum vfio_iommu_notify_type {
-- 
2.30.1

