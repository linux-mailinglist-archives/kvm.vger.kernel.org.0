Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56CF943B8C3
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 19:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238007AbhJZSAJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 14:00:09 -0400
Received: from mail-bn8nam11on2062.outbound.protection.outlook.com ([40.107.236.62]:57056
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236589AbhJZSAD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Oct 2021 14:00:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ybdd2Ak23I8iczv1BWDPMIs/bBysL4Fsutn0O1XLp2RwlFe7mPQZE2Rk0Qo+AtPIDOh4yQcSNKNT10uKaDwMDsDgwypR6iEKB7TOj+4jnZj1hEv5c3MlFThftDsgi1IyClO+EGlAxDZgrzjOuNmRV4uiplDVwDtk18A3Ffaopg0tCHihFl0tvViuH7rpOryCxkC42ILuX0vb1Xh5EEk82Z1wP2bvvnGaOr76i+wxvotoyP+2Fsz4cJs9k2gYCcDBtA9IQHV4VvsYD94gDuWCY3cAgGXpmhRQuXNYNDMkc06cbKr/Kso4vEf2RVGlwSGBRzBUO755Haa3msFfwDTYNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W4VL6PuHi5a5+MX1ro02IDczVKwAYeaIkjY305cS1kI=;
 b=LeN8zvN5qAt7K/0LOz4fXhTqssx5jqgtvMQ0uGMxcOIh6PpCKrC7GsXoOp4cb0GpEVwvIEYDpCQl2jQTxW8B9z0d2b8KkHABJ+upMXcEFzYRggpX75pfnF5kXGYtSZKvKzPVn9y6aNPFPz1u4qH3y0Xh7Xikd8mLHTigGaod5Sh7Q2z5F7aORRjhYfjWdIgBQGkjI3A4oLAqMWFNPEagUaGSHfXYgsKeYJ1lq9Q2Hzqq+DdwZgdsIc2iSrw1Q6rhflGuYxyrA8CSwAtfqw4sFrnfKFN6ln1J2Y4gOmB5RsaAltrHWRvtN9WssHv+Qw2fJtpUpCFG3uXt/nh7X1Spsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W4VL6PuHi5a5+MX1ro02IDczVKwAYeaIkjY305cS1kI=;
 b=CYerfw/I7UzFkWwvrg38DtvqJpzaIrBPzdVsEhVwCxSrkiJkvagHjdayIadNjPE2dMJ09jfXQsG5vx3uzl9fkDl4pdx45MGI2xLC/OCBl4hd/wR0X0Cbs7zva1caB0XeY9YhfyRw2ESs6XafmXB3nSdODmJMOX69hnnzlhJLoYoWRuhQF0OGgyg7iud7VPHdlx8mk+MBMQtwmkDp9RpaWgz0VxjL9OsvTcPT7sDV9Hh2Aq34SqPmEnjENKUijiZUnHsPVXDqD8WOHeTbhwWtIVMCe5o1wjyfDAtW7EBkZWIJa9rzEz2ZJH+cht9vBtWf827M6SVs6WT2yiUen4A9Ww==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5048.namprd12.prod.outlook.com (2603:10b6:208:30a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13; Tue, 26 Oct
 2021 17:57:37 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4649.014; Tue, 26 Oct 2021
 17:57:37 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>
Cc:     Eric Farman <farman@linux.ibm.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH v4 4/4] vfio/ccw: Convert to use vfio_register_emulated_iommu_dev()
Date:   Tue, 26 Oct 2021 14:57:33 -0300
Message-Id: <4-v4-cea4f5bd2c00+b52-ccw_mdev_jgg@nvidia.com>
In-Reply-To: <0-v4-cea4f5bd2c00+b52-ccw_mdev_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0114.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:85::31) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by YT3PR01CA0114.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:85::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.22 via Frontend Transport; Tue, 26 Oct 2021 17:57:36 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mfQhZ-002BK5-IV; Tue, 26 Oct 2021 14:57:33 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b6262367-d3ac-42a0-6cda-08d998aa182b
X-MS-TrafficTypeDiagnostic: BL1PR12MB5048:
X-Microsoft-Antispam-PRVS: <BL1PR12MB50485881A60DAD8E53C98814C2849@BL1PR12MB5048.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EzgobSZ43RsI9TVwi8wrqynHAiiLeZaNmk5CvJ/AGw6iiz0JysyZaWW3a92F9cdINSHC/FvYFr0y/5by1W1/vhY5JJlLsXf2Jvc4EHuD9fjY8QcBBFwVSsj8WObi4HCIlkpBksJoG1GJkOEieVIUJYa81fSL7+AE/OYxXB3j1lEt9N1ZNO0sRfDaBJnYvzMerg/TAk97JyBNuZvzuw0Fivm9pD39l5MlHE/yXeixb97geGuhDA8khVQEekYc4gK2LKNbNvn+HVa4AnPtTc9vV3O7VEq5PCOZUO3GkSGeomw0YSoe0/8Ufe487ufJPtKcIxp7d6Qn31wNAXhHZhfJs041jnEAkPgAYCh7b16cuDULe9Il0GO9XJf0DEnulHm5qyVujkdjqZzebgSIYKy6m9jU5VQcwZRNKylpTVixz8TsZG93Cv32sSMGEZfdy/jH3i4kybBNL1WTpCXBXCdoJKzc+uVPFMn3vrxCkfGGFccZm7/aRuVkvjp16Pagcys9RWvAQKrPAOnU5LCOvjhAwHuO5YPfsej37fvIDjRv0SdG4fXDpkR3emKholPL11+Y6PlUF654rBKRmRZ0uLGekQriBCj7NBnLl5VVF8pqieGfve5BEAfTxYDUvaDoBOoZTjFBxES552q9pMMJpLVkLbozH3G6cFOZJ1o8UhFmpEoEkcELNc7Y4ZfMEjM55unXR6xLGrltxh6aHdf1gFS0sVDEfziQyjxMpbMLvUlx1ws=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(110136005)(54906003)(2906002)(36756003)(508600001)(2616005)(9746002)(316002)(921005)(426003)(30864003)(8676002)(66556008)(83380400001)(8936002)(86362001)(26005)(5660300002)(186003)(38100700002)(66946007)(4326008)(66476007)(9786002)(7416002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xhiO+cPM5SpBiA+ZHmxqVq1mV90PMaGltqqU3ELs5FFgV8TlfTU++zYeH31t?=
 =?us-ascii?Q?RLE+x1cTOvLq/KELqGMTGOVACcnLLFNRyTgmhl4OTBfTPJNLFqpcXqWSsLia?=
 =?us-ascii?Q?elZlwFW/KawtZusr4T2pkqE0/14XSuqToj49d4syLepqWSTbh9PSXbZqkX/P?=
 =?us-ascii?Q?mm4aO7O7tMA0JVFnilc64LCNbC8je4AQogWFnheYpoIQUVetG5lvbR8GgPS3?=
 =?us-ascii?Q?SGSFbxvvT6ZMMx81sbri+nzIhp75Zkblkju5vOJAWnTx/qI0drr8uGZfZdSk?=
 =?us-ascii?Q?G0c9d/AYlR8j5SZkFNslfvNPVtwC1cnVfVBkWxKbf24WSDVaf3g6Pfc8BDnn?=
 =?us-ascii?Q?w9dP0+TukWvGhbxn62sP9BljtYCF4x2uzzX7NZtK4DOqeIXPMfQZfXLrThVL?=
 =?us-ascii?Q?cJEmerrQCpOIWNHexYLlkv6BXm2VQHNw6iNmMZIPZ8Fx58G4H071488eEmgI?=
 =?us-ascii?Q?+OiysQJ7qso+17PEP4Y2kWLyBuckwyrmna+cKJ0ZjatOKenE9MVJ3RaH0WQU?=
 =?us-ascii?Q?pYjsT6E/969iMJYB65vQDt5w6hAFhHylvNU6C7eCk8O5v06yiAdEVabdaJq5?=
 =?us-ascii?Q?1hJBkM50wtqxhV5WFgwnfp8ncz6PXhD+/8BeIfYpvbyCLy2SIqeF6807sWs6?=
 =?us-ascii?Q?9yrg2bcSNpLCXlaUJoMgcgteEGBEATRLGdKbEc1umTCbL9vDNAVmGzgZNcWM?=
 =?us-ascii?Q?phOVW32xNWfzYKXBjr1GVPnCDAUuO1s8Abv1xNpHPW/NfGo1+uVMZ9flQVFf?=
 =?us-ascii?Q?AYiaR+xmA2cD17dwRlkH7fuop/stbaR2BJc+/6VA06fRflQGDya9ZbpR1kCF?=
 =?us-ascii?Q?8LAyGA1DqV8XUenF/upY7jOtwNshRMy38ippQmFl9fTN8zUZ50cvCo3s0RD+?=
 =?us-ascii?Q?t8Z9fGFOtq5cy90qICDkT5w0UYCVjVQJu5PLd/UJAFcYW+F9UUTJ+L8JDEoH?=
 =?us-ascii?Q?eEFa1hlmHaWWl9KyqiuJjuTZ1K/Xwn7n0bCZj+cRIkfKSOEuwmItuwN/dDGt?=
 =?us-ascii?Q?NrJJcF9mOaAllSMM/fidnZZtxg0ovZbEXNsq5KnmjxCpTwSsQpigUye9F5e1?=
 =?us-ascii?Q?JasfFqFLM3VXWsi7EC9Wg2gFUczbaM/shXhIH32X2bJ29dyuMUp82FVL45/Z?=
 =?us-ascii?Q?SNwz20q07T+C8Y5zIIBJ8lgrFCWskh0sUclK3XOghMNNW+Acyz707RlETvPf?=
 =?us-ascii?Q?WucpE8U2gjeVUCeMCw6RymbPXICKmZ6p3eTvlPiqgzPHy9GAZ8udadPbvazN?=
 =?us-ascii?Q?AuFio6b61Ad8oVoXqRQq0WciFi/hZW0RS5DMpV+twwddsCxfNc8y4dABZdJG?=
 =?us-ascii?Q?+rT09/Te1Vor5eRzFi8SGoOi/+ZvOyjdChJBl6nEtlyCa5Ks3ZnXWjF/ti/Q?=
 =?us-ascii?Q?jPxMMFr3SZ7FUSTP4tXcqNzAYrf/1u2WDHXPkUqNY+fGLznCKJW93pwx9p/A?=
 =?us-ascii?Q?v3nc6l/K2f/Q1mt1D53DFtAw6iXUoVn55RbVXs6MGG9QRASUURmwh3iXu1Ky?=
 =?us-ascii?Q?UliZ6VEYMSjBtEJ+8QtGHo8kJQq01Nb9CmzKKvK+rgWN9lGqpc0cKq7bpdTt?=
 =?us-ascii?Q?+eXdqYYVQDETcZCVj2I=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6262367-d3ac-42a0-6cda-08d998aa182b
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 17:57:36.9804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CEyFQX/tpsc5Z1/1Q8gC3zOM5vv8OEY1wjtJe0BiaXn8WYczy6gyNdNRomcTw4/h
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5048
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a more complicated conversion because vfio_ccw is sharing the
vfio_device between both the mdev_device, its vfio_device and the
css_driver.

The mdev is a singleton, and the reason for this sharing is so the extra
css_driver function callbacks to be delivered to the vfio_device
implementation.

This keeps things as they are, with the css_driver allocating the
singleton, not the mdev_driver.

Embed the vfio_device in the vfio_ccw_private and instantiate it as a
vfio_device when the mdev probes. The drvdata of both the css_device and
the mdev_device point at the private, and container_of is used to get it
back from the vfio_device.

Reviewed-by: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/s390/cio/vfio_ccw_drv.c     |  21 ++++--
 drivers/s390/cio/vfio_ccw_ops.c     | 107 +++++++++++++++++-----------
 drivers/s390/cio/vfio_ccw_private.h |   5 ++
 3 files changed, 85 insertions(+), 48 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index e32678a71644fb..0407427770955d 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -468,7 +468,7 @@ static int __init vfio_ccw_sch_init(void)
 	vfio_ccw_work_q = create_singlethread_workqueue("vfio-ccw");
 	if (!vfio_ccw_work_q) {
 		ret = -ENOMEM;
-		goto out_err;
+		goto out_regions;
 	}
 
 	vfio_ccw_io_region = kmem_cache_create_usercopy("vfio_ccw_io_region",
@@ -477,7 +477,7 @@ static int __init vfio_ccw_sch_init(void)
 					sizeof(struct ccw_io_region), NULL);
 	if (!vfio_ccw_io_region) {
 		ret = -ENOMEM;
-		goto out_err;
+		goto out_regions;
 	}
 
 	vfio_ccw_cmd_region = kmem_cache_create_usercopy("vfio_ccw_cmd_region",
@@ -486,7 +486,7 @@ static int __init vfio_ccw_sch_init(void)
 					sizeof(struct ccw_cmd_region), NULL);
 	if (!vfio_ccw_cmd_region) {
 		ret = -ENOMEM;
-		goto out_err;
+		goto out_regions;
 	}
 
 	vfio_ccw_schib_region = kmem_cache_create_usercopy("vfio_ccw_schib_region",
@@ -496,7 +496,7 @@ static int __init vfio_ccw_sch_init(void)
 
 	if (!vfio_ccw_schib_region) {
 		ret = -ENOMEM;
-		goto out_err;
+		goto out_regions;
 	}
 
 	vfio_ccw_crw_region = kmem_cache_create_usercopy("vfio_ccw_crw_region",
@@ -506,19 +506,25 @@ static int __init vfio_ccw_sch_init(void)
 
 	if (!vfio_ccw_crw_region) {
 		ret = -ENOMEM;
-		goto out_err;
+		goto out_regions;
 	}
 
+	ret = mdev_register_driver(&vfio_ccw_mdev_driver);
+	if (ret)
+		goto out_regions;
+
 	isc_register(VFIO_CCW_ISC);
 	ret = css_driver_register(&vfio_ccw_sch_driver);
 	if (ret) {
 		isc_unregister(VFIO_CCW_ISC);
-		goto out_err;
+		goto out_driver;
 	}
 
 	return ret;
 
-out_err:
+out_driver:
+	mdev_unregister_driver(&vfio_ccw_mdev_driver);
+out_regions:
 	vfio_ccw_destroy_regions();
 	destroy_workqueue(vfio_ccw_work_q);
 	vfio_ccw_debug_exit();
@@ -528,6 +534,7 @@ static int __init vfio_ccw_sch_init(void)
 static void __exit vfio_ccw_sch_exit(void)
 {
 	css_driver_unregister(&vfio_ccw_sch_driver);
+	mdev_unregister_driver(&vfio_ccw_mdev_driver);
 	isc_unregister(VFIO_CCW_ISC);
 	vfio_ccw_destroy_regions();
 	destroy_workqueue(vfio_ccw_work_q);
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index 1edbea9de0ec42..d8589afac272f1 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -17,6 +17,8 @@
 
 #include "vfio_ccw_private.h"
 
+static const struct vfio_device_ops vfio_ccw_dev_ops;
+
 static int vfio_ccw_mdev_reset(struct vfio_ccw_private *private)
 {
 	struct subchannel *sch;
@@ -111,10 +113,10 @@ static struct attribute_group *mdev_type_groups[] = {
 	NULL,
 };
 
-static int vfio_ccw_mdev_create(struct mdev_device *mdev)
+static int vfio_ccw_mdev_probe(struct mdev_device *mdev)
 {
-	struct vfio_ccw_private *private =
-		dev_get_drvdata(mdev_parent_dev(mdev));
+	struct vfio_ccw_private *private = dev_get_drvdata(mdev->dev.parent);
+	int ret;
 
 	if (private->state == VFIO_CCW_STATE_NOT_OPER)
 		return -ENODEV;
@@ -122,6 +124,10 @@ static int vfio_ccw_mdev_create(struct mdev_device *mdev)
 	if (atomic_dec_if_positive(&private->avail) < 0)
 		return -EPERM;
 
+	memset(&private->vdev, 0, sizeof(private->vdev));
+	vfio_init_group_dev(&private->vdev, &mdev->dev,
+			    &vfio_ccw_dev_ops);
+
 	private->mdev = mdev;
 	private->state = VFIO_CCW_STATE_IDLE;
 
@@ -130,19 +136,31 @@ static int vfio_ccw_mdev_create(struct mdev_device *mdev)
 			   private->sch->schid.ssid,
 			   private->sch->schid.sch_no);
 
+	ret = vfio_register_emulated_iommu_dev(&private->vdev);
+	if (ret)
+		goto err_atomic;
+	dev_set_drvdata(&mdev->dev, private);
 	return 0;
+
+err_atomic:
+	vfio_uninit_group_dev(&private->vdev);
+	atomic_inc(&private->avail);
+	private->mdev = NULL;
+	private->state = VFIO_CCW_STATE_IDLE;
+	return ret;
 }
 
-static int vfio_ccw_mdev_remove(struct mdev_device *mdev)
+static void vfio_ccw_mdev_remove(struct mdev_device *mdev)
 {
-	struct vfio_ccw_private *private =
-		dev_get_drvdata(mdev_parent_dev(mdev));
+	struct vfio_ccw_private *private = dev_get_drvdata(mdev->dev.parent);
 
 	VFIO_CCW_MSG_EVENT(2, "mdev %pUl, sch %x.%x.%04x: remove\n",
 			   mdev_uuid(mdev), private->sch->schid.cssid,
 			   private->sch->schid.ssid,
 			   private->sch->schid.sch_no);
 
+	vfio_unregister_group_dev(&private->vdev);
+
 	if ((private->state != VFIO_CCW_STATE_NOT_OPER) &&
 	    (private->state != VFIO_CCW_STATE_STANDBY)) {
 		if (!vfio_ccw_sch_quiesce(private->sch))
@@ -150,23 +168,22 @@ static int vfio_ccw_mdev_remove(struct mdev_device *mdev)
 		/* The state will be NOT_OPER on error. */
 	}
 
+	vfio_uninit_group_dev(&private->vdev);
 	cp_free(&private->cp);
 	private->mdev = NULL;
 	atomic_inc(&private->avail);
-
-	return 0;
 }
 
-static int vfio_ccw_mdev_open_device(struct mdev_device *mdev)
+static int vfio_ccw_mdev_open_device(struct vfio_device *vdev)
 {
 	struct vfio_ccw_private *private =
-		dev_get_drvdata(mdev_parent_dev(mdev));
+		container_of(vdev, struct vfio_ccw_private, vdev);
 	unsigned long events = VFIO_IOMMU_NOTIFY_DMA_UNMAP;
 	int ret;
 
 	private->nb.notifier_call = vfio_ccw_mdev_notifier;
 
-	ret = vfio_register_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
+	ret = vfio_register_notifier(vdev->dev, VFIO_IOMMU_NOTIFY,
 				     &events, &private->nb);
 	if (ret)
 		return ret;
@@ -187,15 +204,15 @@ static int vfio_ccw_mdev_open_device(struct mdev_device *mdev)
 
 out_unregister:
 	vfio_ccw_unregister_dev_regions(private);
-	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
+	vfio_unregister_notifier(vdev->dev, VFIO_IOMMU_NOTIFY,
 				 &private->nb);
 	return ret;
 }
 
-static void vfio_ccw_mdev_close_device(struct mdev_device *mdev)
+static void vfio_ccw_mdev_close_device(struct vfio_device *vdev)
 {
 	struct vfio_ccw_private *private =
-		dev_get_drvdata(mdev_parent_dev(mdev));
+		container_of(vdev, struct vfio_ccw_private, vdev);
 
 	if ((private->state != VFIO_CCW_STATE_NOT_OPER) &&
 	    (private->state != VFIO_CCW_STATE_STANDBY)) {
@@ -206,8 +223,7 @@ static void vfio_ccw_mdev_close_device(struct mdev_device *mdev)
 
 	cp_free(&private->cp);
 	vfio_ccw_unregister_dev_regions(private);
-	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
-				 &private->nb);
+	vfio_unregister_notifier(vdev->dev, VFIO_IOMMU_NOTIFY, &private->nb);
 }
 
 static ssize_t vfio_ccw_mdev_read_io_region(struct vfio_ccw_private *private,
@@ -231,15 +247,14 @@ static ssize_t vfio_ccw_mdev_read_io_region(struct vfio_ccw_private *private,
 	return ret;
 }
 
-static ssize_t vfio_ccw_mdev_read(struct mdev_device *mdev,
+static ssize_t vfio_ccw_mdev_read(struct vfio_device *vdev,
 				  char __user *buf,
 				  size_t count,
 				  loff_t *ppos)
 {
+	struct vfio_ccw_private *private =
+		container_of(vdev, struct vfio_ccw_private, vdev);
 	unsigned int index = VFIO_CCW_OFFSET_TO_INDEX(*ppos);
-	struct vfio_ccw_private *private;
-
-	private = dev_get_drvdata(mdev_parent_dev(mdev));
 
 	if (index >= VFIO_CCW_NUM_REGIONS + private->num_regions)
 		return -EINVAL;
@@ -284,15 +299,14 @@ static ssize_t vfio_ccw_mdev_write_io_region(struct vfio_ccw_private *private,
 	return ret;
 }
 
-static ssize_t vfio_ccw_mdev_write(struct mdev_device *mdev,
+static ssize_t vfio_ccw_mdev_write(struct vfio_device *vdev,
 				   const char __user *buf,
 				   size_t count,
 				   loff_t *ppos)
 {
+	struct vfio_ccw_private *private =
+		container_of(vdev, struct vfio_ccw_private, vdev);
 	unsigned int index = VFIO_CCW_OFFSET_TO_INDEX(*ppos);
-	struct vfio_ccw_private *private;
-
-	private = dev_get_drvdata(mdev_parent_dev(mdev));
 
 	if (index >= VFIO_CCW_NUM_REGIONS + private->num_regions)
 		return -EINVAL;
@@ -510,12 +524,12 @@ void vfio_ccw_unregister_dev_regions(struct vfio_ccw_private *private)
 	private->region = NULL;
 }
 
-static ssize_t vfio_ccw_mdev_ioctl(struct mdev_device *mdev,
+static ssize_t vfio_ccw_mdev_ioctl(struct vfio_device *vdev,
 				   unsigned int cmd,
 				   unsigned long arg)
 {
 	struct vfio_ccw_private *private =
-		dev_get_drvdata(mdev_parent_dev(mdev));
+		container_of(vdev, struct vfio_ccw_private, vdev);
 	int ret = 0;
 	unsigned long minsz;
 
@@ -606,37 +620,48 @@ static ssize_t vfio_ccw_mdev_ioctl(struct mdev_device *mdev,
 }
 
 /* Request removal of the device*/
-static void vfio_ccw_mdev_request(struct mdev_device *mdev, unsigned int count)
+static void vfio_ccw_mdev_request(struct vfio_device *vdev, unsigned int count)
 {
-	struct vfio_ccw_private *private = dev_get_drvdata(mdev_parent_dev(mdev));
-
-	if (!private)
-		return;
+	struct vfio_ccw_private *private =
+		container_of(vdev, struct vfio_ccw_private, vdev);
+	struct device *dev = vdev->dev;
 
 	if (private->req_trigger) {
 		if (!(count % 10))
-			dev_notice_ratelimited(mdev_dev(private->mdev),
+			dev_notice_ratelimited(dev,
 					       "Relaying device request to user (#%u)\n",
 					       count);
 
 		eventfd_signal(private->req_trigger, 1);
 	} else if (count == 0) {
-		dev_notice(mdev_dev(private->mdev),
+		dev_notice(dev,
 			   "No device request channel registered, blocked until released by user\n");
 	}
 }
 
+static const struct vfio_device_ops vfio_ccw_dev_ops = {
+	.open_device = vfio_ccw_mdev_open_device,
+	.close_device = vfio_ccw_mdev_close_device,
+	.read = vfio_ccw_mdev_read,
+	.write = vfio_ccw_mdev_write,
+	.ioctl = vfio_ccw_mdev_ioctl,
+	.request = vfio_ccw_mdev_request,
+};
+
+struct mdev_driver vfio_ccw_mdev_driver = {
+	.driver = {
+		.name = "vfio_ccw_mdev",
+		.owner = THIS_MODULE,
+		.mod_name = KBUILD_MODNAME,
+	},
+	.probe = vfio_ccw_mdev_probe,
+	.remove = vfio_ccw_mdev_remove,
+};
+
 static const struct mdev_parent_ops vfio_ccw_mdev_ops = {
 	.owner			= THIS_MODULE,
+	.device_driver		= &vfio_ccw_mdev_driver,
 	.supported_type_groups  = mdev_type_groups,
-	.create			= vfio_ccw_mdev_create,
-	.remove			= vfio_ccw_mdev_remove,
-	.open_device		= vfio_ccw_mdev_open_device,
-	.close_device		= vfio_ccw_mdev_close_device,
-	.read			= vfio_ccw_mdev_read,
-	.write			= vfio_ccw_mdev_write,
-	.ioctl			= vfio_ccw_mdev_ioctl,
-	.request		= vfio_ccw_mdev_request,
 };
 
 int vfio_ccw_mdev_reg(struct subchannel *sch)
diff --git a/drivers/s390/cio/vfio_ccw_private.h b/drivers/s390/cio/vfio_ccw_private.h
index b2c762eb42b9bb..7272eb78861244 100644
--- a/drivers/s390/cio/vfio_ccw_private.h
+++ b/drivers/s390/cio/vfio_ccw_private.h
@@ -17,6 +17,7 @@
 #include <linux/eventfd.h>
 #include <linux/workqueue.h>
 #include <linux/vfio_ccw.h>
+#include <linux/vfio.h>
 #include <asm/crw.h>
 #include <asm/debug.h>
 
@@ -67,6 +68,7 @@ struct vfio_ccw_crw {
 
 /**
  * struct vfio_ccw_private
+ * @vdev: Embedded VFIO device
  * @sch: pointer to the subchannel
  * @state: internal state of the device
  * @completion: synchronization helper of the I/O completion
@@ -90,6 +92,7 @@ struct vfio_ccw_crw {
  * @crw_work: work for deferral process of CRW handling
  */
 struct vfio_ccw_private {
+	struct vfio_device vdev;
 	struct subchannel	*sch;
 	int			state;
 	struct completion	*completion;
@@ -121,6 +124,8 @@ extern void vfio_ccw_mdev_unreg(struct subchannel *sch);
 
 extern int vfio_ccw_sch_quiesce(struct subchannel *sch);
 
+extern struct mdev_driver vfio_ccw_mdev_driver;
+
 /*
  * States of the device statemachine.
  */
-- 
2.33.0

