Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96886333113
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 22:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232078AbhCIVjL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 16:39:11 -0500
Received: from mail-bn8nam12on2044.outbound.protection.outlook.com ([40.107.237.44]:47776
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232035AbhCIVjA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 16:39:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R75jtXERmsBMgkOpzopU5m2IAzjUBiUipAgzDRrhScuUkyUO6Ja2+SQEmgD3Vrdd5VzfjpUDNU5QQ8x+040G6UeyT1uoAje69DLmjTQfNRdz91CWNyPdWpGoi3AuZ+BHI/hDhYJoaXjreyAWiZwOnlGBp5IzRy3bWTgDYeR9zil/z0lwjviitGtov8Hu9JPe30MEMk75DnuzeKFt7CPzqNkR+9H0157PVKvG8Wow/MAWS3j+qHT/fNTRHTx9Oiowlk9LFR4BaZsil6BjqVWnH388q9amytaxpDtPUERa5WjXTqvt8paT3hPRRj1c8ZXbpZKJq1NgQlDiqrRDaYm6xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i/s6BxxhtS5ho34pulIne5hnPitsX2ZJS2IZWfjG7Ek=;
 b=CmwLKZSZhYRJyo/R5QJ7xq5VlQvlLH6H3S24YYWKSpcrUqQDWhhWjAN1wqeR/ICJrd4J0qrp373Xd8v47BAaEvZ5TKyxF3ipE4v8weUVvzgsxV0Er9Z0STJlA65mEFTuWnpfy8S3yiB/F7G/Jh9DfXftYnDuOdqKxZx6+z/cyc2uFxEYlx/Wg71H/6TESAXucjsuZeBXB2OJW3jmMHSpCBGWshT0ecFID/aeSF9KNHAo/RGwcXvfoEwnDY7zQm70FU1Fh9rc3XS51p8fWkPtOl3JVY1l5JGloTY+3jwxPrgJyTF9S33c6npfZLvjJiS3F1MQ+UB/d2E/3O2EEivZeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i/s6BxxhtS5ho34pulIne5hnPitsX2ZJS2IZWfjG7Ek=;
 b=lzv81OgRfnu0LSgKJBFPGUA0u0DeXOrB10JO1zdwXYFO+Vx7qd/a2sk8pmMeb5S+ncSwGA4AfmLXb6Gf7QEZHPeidYgTWZJqDmaR6MrAPum1hIu1s0mibBnHTmWug2TvqaNYw9+n+0oFF8D6MpR3TxobDo0CJjKwTsoaQtHSuF1inwtbJIdXSAubYWlsFQi9DffvrR5ka5jzh291+7I/NWCbSbS8PxV2CxnwX3EG8kUGhRMYCBgMf3y2rbS4ur9dqaWQjnKLsOFvaO15u91jcKZ6h4K47OKrGccQ1uplqi3L64cpSKLR0Kr2xjriWMKTUV86AjY4HwQpyDZMrNzsiQ==
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
        Diana Craciun <diana.craciun@oss.nxp.com>, kvm@vger.kernel.org
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH 04/10] vfio/fsl-mc: Use vfio_init/register/unregister_group_dev
Date:   Tue,  9 Mar 2021 17:38:46 -0400
Message-Id: <4-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
In-Reply-To: <0-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL0PR0102CA0055.prod.exchangelabs.com
 (2603:10b6:208:25::32) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR0102CA0055.prod.exchangelabs.com (2603:10b6:208:25::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 21:38:56 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lJk44-00AVIn-QE; Tue, 09 Mar 2021 17:38:52 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 889cf6ab-123b-4599-c2b1-08d8e343be25
X-MS-TrafficTypeDiagnostic: DM5PR12MB1243:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB12435AA2422E6B54AF8F84A5C2929@DM5PR12MB1243.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jVqw4berub8EgAWlNUIupEfrRkDGrJ8zLYQqrVcCqNAW8F4aqaMM/f6nfsZPzytI2nqBk1+Dln578wPYoa5OKSMAbMrAE8TlhDLsx+7LF/eu2+awEjLGXqagbgKf7uQrNa/pEEFH2TdDXawZhxCzv5bCcSQCiYaKj3xQnUD/F095ZYOnqmPeTduKjnYflWUmyxcy6sAAOD20L+mwrsMZSFLt6Br18tcJqWaq5OBmq6Dskb+ApWNPLTXvHsKkNllopZjMKZXWQQiMYcgx0SlZXBT0C1Vgpu4DLSKzUY8X6LiVv1l+1GmTdNjiirki7MY2ofpCRkJg5GqYBW0bRDhsgXFXnATwwMYyHtbdQ2X3PU1xbPk7HuQ/b89h5Jf41g3sDuqheHmFYadKEjmSCa0Mhak35403mj/KHwPPGGRLSxVoNjX1Pg8SCaY4GngEXY2EQPSEtTfEFC05wdDpmu/UM8Rk7sGCj0DC3iR78RpEnrPf3x5ZiyoOBgelp6FgN9NuZcgLs9T/8ABWKADmQsdY1ce2rdseEU15YJraNJi/5tWc2R3p5H4Pw8HS1A4RdkxR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(396003)(376002)(136003)(346002)(2616005)(83380400001)(426003)(66556008)(9786002)(66476007)(9746002)(107886003)(66946007)(8936002)(186003)(2906002)(86362001)(8676002)(26005)(36756003)(6666004)(54906003)(4326008)(316002)(5660300002)(110136005)(478600001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?t/aU6M/nIkpdljpKM+xt+L7T/KKlXhfMCaQiDUb2Ttrvc6/6FKiyqRCy93lf?=
 =?us-ascii?Q?aLahdWISQNq99YVytGbWjz2gBrugRg8RCXf3jyU/Zarhxuj7VPR5bTuDVZMf?=
 =?us-ascii?Q?7q//R64CjAC71H03ODOf2cYx8ecpqMZApVEq4gqfRY89+PKf+kIBOeXfv8eU?=
 =?us-ascii?Q?LDvpyFnW7TqIt/pggK7egjL0+nRg7RJa+9pWQHpT4/t9p5EeAfNUfv5FG0hy?=
 =?us-ascii?Q?EM/zC7swgYNmTpsGkmnp1fjWmRwpk8tS5G/znHd9nD4qWuYd6uIsZvbgyj7p?=
 =?us-ascii?Q?nZ3Mzbw+OJir9fbYUq0EOp/0ogkfqYVFk58tBbvfxEBBrYlkZ6GpnIeo1aIv?=
 =?us-ascii?Q?034NUgbS4Zq3B6rMjKjrSRbVr7fX1i3prRJYG8DohBBpqKHnk/REwwkNL+3F?=
 =?us-ascii?Q?zvqKrqZq4UXaAcOv68grWSCm24yqigqlsROhMmDFd46DdrquwTO8VLLGTN1K?=
 =?us-ascii?Q?OxeZ6KWYWoykKBb4P8OqxmvaW3P94toBiSPi+EtbrKe2l3E+TyGIi8NJdFjm?=
 =?us-ascii?Q?G0sr2W1Y0zptE8PovZYuf25W/+F1H05VPXRPPiq0Q7V3n3zTDtBpdMGNEnGa?=
 =?us-ascii?Q?3901sJwcBytQ3tShKsAYSPEj6/B3PcBJbejGiyR9B4dfJPG+egoRw7qLmfq0?=
 =?us-ascii?Q?ASDe4baLHXEr0H8L64pDOlk29+xDl2wWzXM0/srH6SKWakfx6HfqK6yIK0bW?=
 =?us-ascii?Q?knGy9eMGiUBrgcIs5DJEQmhxXfNmKMYjN3TifGlUwM1fuQyopmFbu0qNiYc8?=
 =?us-ascii?Q?jiz6rvoES/wpSmc5uGkE3lod0JpHt0UkVnhfB5817yc1xR3zQ2NE9HQObLpi?=
 =?us-ascii?Q?qNPpUIETtVlYBBLjq8mvynZ6Z2zpJcSxrNxdA+Tq/v/OHQYR6MMBUSoea1n3?=
 =?us-ascii?Q?NrvaF+T1283MAmQqvAUrEZ4EffKojExa72ve+ei0DgNS0f/sZ3FCQ0iKb6Qn?=
 =?us-ascii?Q?gjJ9QLdEpfFmrAUMzL/PWtOs9tQ+KltMBMN3DDsx5lD7tNR+lJtgUdTzJEG1?=
 =?us-ascii?Q?oWbTrxTXxN9j/1arSNmF9ZG0s1ZRStTIAo98efKrmN14Ez2oamEfpkR0iItW?=
 =?us-ascii?Q?jiiyJfKtb9L95fNhCj9u3oUqDXEPHSgMJu6rIwTfUvrqy4e2iFQUJy1JZrN9?=
 =?us-ascii?Q?lcgCQDLfjZKeIoTMMGXoFF25qTPVuzlChD0UTXtg+nbF+YhXvaJjx5xZjEt5?=
 =?us-ascii?Q?bZ6yuwVYRrVaxsS3Z2MQeJwB/kGhHth0RlW1e7uXYOIIHXmu3wEzhx8ECgxQ?=
 =?us-ascii?Q?btLFH1bOfGbOS/4snCd+f9EzF2eFONKfeCLbdSFS9zJYnROJaMM+aopDX6FV?=
 =?us-ascii?Q?/sWqdOQdy5ed+2ppq+7S794HoN1+wHePl8Z7eIp6WR/odg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 889cf6ab-123b-4599-c2b1-08d8e343be25
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 21:38:56.6953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AWiw8y2juHXSivRvtJMfDMcCUgaQ75AIzbGsCjpGJ1bIBXsKaeFqpAJUDCJ9pYWx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1243
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

fsl-mc already allocates a struct vfio_fsl_mc_device with exactly the same
lifetime as vfio_device, switch to the new API and embed vfio_device in
vfio_fsl_mc_device. While here remove the devm usage for the vdev, this
code is clean and doesn't need devm.

Add a note the probe ordering is racy.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/fsl-mc/vfio_fsl_mc.c         | 30 +++++++++++++----------
 drivers/vfio/fsl-mc/vfio_fsl_mc_private.h |  1 +
 2 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index f27e25112c4037..ddee6ed20c4523 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -600,20 +600,28 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
 		return -EINVAL;
 	}
 
-	vdev = devm_kzalloc(dev, sizeof(*vdev), GFP_KERNEL);
+	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
 	if (!vdev) {
 		ret = -ENOMEM;
 		goto out_group_put;
 	}
 
+	vfio_init_group_dev(&vdev->vdev, dev, &vfio_fsl_mc_ops, vdev);
+	mutex_init(&vdev->igate);
 	vdev->mc_dev = mc_dev;
 
-	ret = vfio_add_group_dev(dev, &vfio_fsl_mc_ops, vdev);
+	ret = vfio_register_group_dev(&vdev->vdev);
 	if (ret) {
 		dev_err(dev, "VFIO_FSL_MC: Failed to add to vfio group\n");
-		goto out_group_put;
+		goto out_kfree;
 	}
+	dev_set_drvdata(dev, vdev);
 
+	/*
+	 * FIXME: vfio_register_group_dev() allows VFIO_GROUP_GET_DEVICE_FD to
+	 * immediately return the device to userspace, but we haven't finished
+	 * setting it up yet.
+	 */
 	ret = vfio_fsl_mc_reflck_attach(vdev);
 	if (ret)
 		goto out_group_dev;
@@ -621,15 +629,14 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
 	ret = vfio_fsl_mc_init_device(vdev);
 	if (ret)
 		goto out_reflck;
-
-	mutex_init(&vdev->igate);
-
 	return 0;
 
 out_reflck:
 	vfio_fsl_mc_reflck_put(vdev->reflck);
 out_group_dev:
-	vfio_del_group_dev(dev);
+	vfio_unregister_group_dev(&vdev->vdev);
+out_kfree:
+	kfree(vdev);
 out_group_put:
 	vfio_iommu_group_put(group, dev);
 	return ret;
@@ -637,13 +644,10 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
 
 static int vfio_fsl_mc_remove(struct fsl_mc_device *mc_dev)
 {
-	struct vfio_fsl_mc_device *vdev;
 	struct device *dev = &mc_dev->dev;
+	struct vfio_fsl_mc_device *vdev = dev_get_drvdata(dev);
 
-	vdev = vfio_del_group_dev(dev);
-	if (!vdev)
-		return -EINVAL;
-
+	vfio_unregister_group_dev(&vdev->vdev);
 	mutex_destroy(&vdev->igate);
 
 	vfio_fsl_mc_reflck_put(vdev->reflck);
@@ -656,8 +660,8 @@ static int vfio_fsl_mc_remove(struct fsl_mc_device *mc_dev)
 	if (vdev->nb.notifier_call)
 		bus_unregister_notifier(&fsl_mc_bus_type, &vdev->nb);
 
+	kfree(vdev);
 	vfio_iommu_group_put(mc_dev->dev.iommu_group, dev);
-
 	return 0;
 }
 
diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
index a97ee691ed47ec..89700e00e77d10 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
@@ -36,6 +36,7 @@ struct vfio_fsl_mc_region {
 };
 
 struct vfio_fsl_mc_device {
+	struct vfio_device		vdev;
 	struct fsl_mc_device		*mc_dev;
 	struct notifier_block        nb;
 	int				refcnt;
-- 
2.30.1

