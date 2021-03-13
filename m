Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 321B6339A93
	for <lists+kvm@lfdr.de>; Sat, 13 Mar 2021 01:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232840AbhCMA4a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 19:56:30 -0500
Received: from mail-dm6nam12on2065.outbound.protection.outlook.com ([40.107.243.65]:30549
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231679AbhCMA4N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 19:56:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fLUbJyoHKXovFC0s3duvPWbhVYRvSs33MQ6Pe7VLEUtXgs1/fXGXPw08qW7JcvliRX8bL68m357ujnTDtTejsC/hY8XxZqn0xnkdnHETpeIGoxrv9OZPg7Wnf/xg75vYAgUAeeXxj31EeEBnH1F5GXWJmk+cBGgqoLn4xvx4fGQ1F22OEWq5SM/t1GDdGWMgjpPAu41STfwJQ4DmouXXTpJ933oBttkLPnZ8T6t937daRlwAEWmqypf6d6f0U7QJVLpiO0hedz0ubHaFYtSFh0F36Oe6oHyXl0El1Xk0E5yvGvtXEau6RjExk/m0Ksf3GiNQYVZveM6lpI0MXlhapQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9UHYrFLiPZV8NmFSDwiIQzvR9eTpwaX5BQQ4w4AsxPg=;
 b=mbdSPUtk/6Fg2ORu4sCAnfL5xks/PDr9OruEh2MlRK2iFyrDMjkJ6bUkUb6ZnernRHOgh3t0AGUx58peG4rrOWSpdsVPagfqKE9xKBM8B/RVN+0QBSkO5BQ9ZIhjw0SyCYNdqzNky1CqqiqGiDSHAO4PKPK2ENk7Kt9g16Q6dVkElCjtSNg6sc181Pi93iZddPC9YYlLXg/tsqxSn6iUR76dRV/H5JI3N0IChMHsxkcSNcXPiDyfDOfAsGMP8niUSoBhdUsqEHOLVE9/0ss+zfUedr1hkrWmn1H8q2hQmquvipD5Gzy66AthFDXXu3/+GpVjufeTCiTYugsKSz0nQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9UHYrFLiPZV8NmFSDwiIQzvR9eTpwaX5BQQ4w4AsxPg=;
 b=fPFj4CJTOgDyqESMSAbtvePzEDZaE26UZEYQjiVfqvUpvmRUc5XnaqUKMQXtVoZQzoQbI5sQpyhLlcfQPSt2i9wZBfANDvZLy3V8ABNxybbekH+OSavtfj8+lLHOhmgzgNRWzc5ictB2Cp0rThdMhvGJfQDzON2DfZQnZCDtCUnqkqwpsLstWFSfRFbC+yaxk9y/jOReN8S/eRrXPYdyE7tMFu/hWQTbwAFtt1GUMXm+naVP1gCFEeprS6rwOtkLvEy4yXj3uGEWAXwAOE8AN8KvOAGH2cBUGBQt8xJpWFmf9Sp7rvZxn+AjtoXScZPJJK/kowWBUJbHTMxKIEpZUw==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB2940.namprd12.prod.outlook.com (2603:10b6:5:15f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Sat, 13 Mar
 2021 00:56:10 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3933.032; Sat, 13 Mar 2021
 00:56:10 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH v2 04/14] vfio/platform: Use vfio_init/register/unregister_group_dev
Date:   Fri, 12 Mar 2021 20:55:56 -0400
Message-Id: <4-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
In-Reply-To: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL1PR13CA0175.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::30) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0175.namprd13.prod.outlook.com (2603:10b6:208:2bd::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.11 via Frontend Transport; Sat, 13 Mar 2021 00:56:09 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lKsZa-00EMAx-T9; Fri, 12 Mar 2021 20:56:06 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87da1b21-3055-46b5-2070-08d8e5baca77
X-MS-TrafficTypeDiagnostic: DM6PR12MB2940:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB29409E4420D9FF11F3FE4BBCC26E9@DM6PR12MB2940.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /vKyNFH84lCZsP/yb5CFYWAZ0YvgpPWniJCA2fR2qM6fUbxOYxyisTSdKjWfr6tDHaRIHC0LyPBp1ilS+PojBHHSewfpKU4/88v6Gr6xAcrxu31eg01Y7hkJ8Wy/+xx07g7w6n5Gl8Y96IlaL0AGLzWxXpNgrX+x+RKqEe5I2BVXRCyhMfVE00pSlBaTTg3c7W2qJmAS0ZfRyNt9Ye7/yHJji/aZ0leVyWTwZdmBubfuSuYpBKG+Ygs6+K6HFgYm8gfEy4Yz17tJhN+5pJTpi7I+ShVVT7WntCcbKC2iqmdMxZtB0aI2ks1VfZPvUvgPjHEa/UrzZsPhyHXfy6ltJhhH1hMV9ddG9ntuLhzAgRFCN1tWrpHfy+XnMXLpM/ns32XfOvKMtcgE/rs8G4SFt4XC6ixnqKLXIWtr0qZDYBK09dTTr0J0X52cO1wA5hWrQK+/6usESq9gMzZTRxbfc6vaKBGbJolTfnraQNQ98St3j+cT2TsZFOAMaW/tyQB4pN5XPqql5194nymr2wF8+Rgg4TzDn0l2iZDSqdYbIbw+m2sK/vXWrPPiM0GiAsVtu9RY0yApKSTLD3x3OrQYXy1cvpBupcg9Yh26QjxhDkw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(136003)(366004)(346002)(9746002)(9786002)(8676002)(6666004)(4326008)(107886003)(54906003)(8936002)(5660300002)(36756003)(316002)(110136005)(83380400001)(66946007)(66556008)(186003)(26005)(66476007)(478600001)(2906002)(426003)(86362001)(2616005)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ifcE6GfbHWk/mf5LqSrjzESjbe/NjlZ216CuwrFugOHKc/U8bVA+EQ/H9hzw?=
 =?us-ascii?Q?gHKKkBjhnstANdgK/Dm40xTkr+djd945gxHO0Baqth5ELwD1TpD0MUi+lAUX?=
 =?us-ascii?Q?8ptiI+BVpZrL9weXylMQlWwPkZ/U9CNi2vNCTX0Yui5ExVMQAVZSybEReAzn?=
 =?us-ascii?Q?UBLwBs9r977scEQZY61/UlxhjO92kSMyk0da2IRebvqNfreownUS7W6aDvE+?=
 =?us-ascii?Q?JJNLTR1WopU24MQ5Z6BjEXS0RjjXEMaTxlUc9Vd78p+SYp2YDBVmdFAwSymC?=
 =?us-ascii?Q?QnhuouBpdIbNeRaJZrZQ5I8aoaiTze4VkKPO3XR4KcqNBHq7CZVagleHkI1x?=
 =?us-ascii?Q?IQxCr1GAxUafzDCsPbp6itO8Re7CemUXoPWZj/hccUPxMN6EiBzTfhrPn1zD?=
 =?us-ascii?Q?trCp6Ux6HhqIEMnwv4ruK6NWSofroNebJlCMJTmKRGoSSlJOGo2e/1BjLbja?=
 =?us-ascii?Q?moCY1e6NiPExaVnQLvgbFPJq+FE+AgpypEI0mr/3o/CcJunpPHT71oF16a9l?=
 =?us-ascii?Q?RPiitRhaX9FVcoI0NNg3SYYXkcXC7arv+UF2UUWBjub+5pBRKfARvk4dCPSm?=
 =?us-ascii?Q?VKRrOKGu/pkf6jMU4M3W16lliKVAaqdi5c6JvPRW8CCpcWi9q2zsMgLCJCZz?=
 =?us-ascii?Q?hUmX+wrn7QadCsp7Qjs461i6JEGSGNy9jtIwPcWTvhwnDfYNJUU7ehjxZ9FK?=
 =?us-ascii?Q?mnMMvASaTLYAVjrpm5wCZSvTfpVgFyLq9q/j6Vlht1jDDyVwevkYhYgtI6US?=
 =?us-ascii?Q?BEalqTZTT8XnTt4vzYRr4nBv9x+Nry+RI+Q4LaaL6I8e3N70z0eaDcOidr+V?=
 =?us-ascii?Q?PXY6sYxLlWbqAh3SItQ0TV/+aJiExo8IKkd/RUqNH7KHlWW1pWE9Ni6hNElB?=
 =?us-ascii?Q?JynkfXzxnJTb7xNvUA+p/QdanEba3ULiu632h56pdvzIiYqwBEcyevRupQBt?=
 =?us-ascii?Q?oecD5Y/BRnHZ2tKro5X3YEVNgIUny1FqMVDeevg0lTUy55Y8ItOG2KLCRh6E?=
 =?us-ascii?Q?JzRrno3PBY6PfX74hiwRkSgSUBLZEo0HTY1XX43/fzZyFiICfnWjcIWon3Id?=
 =?us-ascii?Q?2riFTd5667cA5KO3OfIbsmosrCjSxZhCeuBrltqnjQhdogrq58uvSXYLVGrW?=
 =?us-ascii?Q?1CJPcRmhSxAn45/CUErYRr+wEv4c6Y9L3T4kTn4mNHvj2uOABPaeo06Em3IG?=
 =?us-ascii?Q?hUtB/pI+smwObXAAiBzFxlntyveW4dSHwDBzSxAUUkCfrpwM9oAMpprIBlbK?=
 =?us-ascii?Q?x/RjFE2VzdKDttZnAUq4XeFOGbYILRQg+f1LQbEYMZFDBvoNVeHqg68iflli?=
 =?us-ascii?Q?ZQDvERrZIcx5xOi6LuNDGgWqWhohrGLVwTLj9fW7kbylWw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87da1b21-3055-46b5-2070-08d8e5baca77
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2021 00:56:09.8466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QCPDbAF04Cr6vbvcjVRAI+SwYHru8pNvhanaQ45NcO341otsmmfj+4Dh3Zu9Dja5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2940
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

platform already allocates a struct vfio_platform_device with exactly
the same lifetime as vfio_device, switch to the new API and embed
vfio_device in vfio_platform_device.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/platform/vfio_amba.c             |  8 ++++---
 drivers/vfio/platform/vfio_platform.c         | 21 ++++++++---------
 drivers/vfio/platform/vfio_platform_common.c  | 23 +++++++------------
 drivers/vfio/platform/vfio_platform_private.h |  5 ++--
 4 files changed, 26 insertions(+), 31 deletions(-)

diff --git a/drivers/vfio/platform/vfio_amba.c b/drivers/vfio/platform/vfio_amba.c
index 3626c21501017e..f970eb2a999f29 100644
--- a/drivers/vfio/platform/vfio_amba.c
+++ b/drivers/vfio/platform/vfio_amba.c
@@ -66,16 +66,18 @@ static int vfio_amba_probe(struct amba_device *adev, const struct amba_id *id)
 	if (ret) {
 		kfree(vdev->name);
 		kfree(vdev);
+		return ret;
 	}
 
-	return ret;
+	dev_set_drvdata(&adev->dev, vdev);
+	return 0;
 }
 
 static void vfio_amba_remove(struct amba_device *adev)
 {
-	struct vfio_platform_device *vdev =
-		vfio_platform_remove_common(&adev->dev);
+	struct vfio_platform_device *vdev = dev_get_drvdata(&adev->dev);
 
+	vfio_platform_remove_common(vdev);
 	kfree(vdev->name);
 	kfree(vdev);
 }
diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
index 9fb6818cea12cb..f7b3f64ecc7f6c 100644
--- a/drivers/vfio/platform/vfio_platform.c
+++ b/drivers/vfio/platform/vfio_platform.c
@@ -54,23 +54,22 @@ static int vfio_platform_probe(struct platform_device *pdev)
 	vdev->reset_required = reset_required;
 
 	ret = vfio_platform_probe_common(vdev, &pdev->dev);
-	if (ret)
+	if (ret) {
 		kfree(vdev);
-
-	return ret;
+		return ret;
+	}
+	dev_set_drvdata(&pdev->dev, vdev);
+	return 0;
 }
 
 static int vfio_platform_remove(struct platform_device *pdev)
 {
-	struct vfio_platform_device *vdev;
-
-	vdev = vfio_platform_remove_common(&pdev->dev);
-	if (vdev) {
-		kfree(vdev);
-		return 0;
-	}
+	struct vfio_platform_device *vdev = dev_get_drvdata(&pdev->dev);
 
-	return -EINVAL;
+	vfio_platform_remove_common(vdev);
+	kfree(vdev->name);
+	kfree(vdev);
+	return 0;
 }
 
 static struct platform_driver vfio_platform_driver = {
diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index fb4b385191f288..6eb749250ee41c 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -659,8 +659,7 @@ int vfio_platform_probe_common(struct vfio_platform_device *vdev,
 	struct iommu_group *group;
 	int ret;
 
-	if (!vdev)
-		return -EINVAL;
+	vfio_init_group_dev(&vdev->vdev, dev, &vfio_platform_ops, vdev);
 
 	ret = vfio_platform_acpi_probe(vdev, dev);
 	if (ret)
@@ -685,13 +684,13 @@ int vfio_platform_probe_common(struct vfio_platform_device *vdev,
 		goto put_reset;
 	}
 
-	ret = vfio_add_group_dev(dev, &vfio_platform_ops, vdev);
+	ret = vfio_register_group_dev(&vdev->vdev);
 	if (ret)
 		goto put_iommu;
 
 	mutex_init(&vdev->igate);
 
-	pm_runtime_enable(vdev->device);
+	pm_runtime_enable(dev);
 	return 0;
 
 put_iommu:
@@ -702,19 +701,13 @@ int vfio_platform_probe_common(struct vfio_platform_device *vdev,
 }
 EXPORT_SYMBOL_GPL(vfio_platform_probe_common);
 
-struct vfio_platform_device *vfio_platform_remove_common(struct device *dev)
+void vfio_platform_remove_common(struct vfio_platform_device *vdev)
 {
-	struct vfio_platform_device *vdev;
-
-	vdev = vfio_del_group_dev(dev);
+	vfio_unregister_group_dev(&vdev->vdev);
 
-	if (vdev) {
-		pm_runtime_disable(vdev->device);
-		vfio_platform_put_reset(vdev);
-		vfio_iommu_group_put(dev->iommu_group, dev);
-	}
-
-	return vdev;
+	pm_runtime_disable(vdev->device);
+	vfio_platform_put_reset(vdev);
+	vfio_iommu_group_put(vdev->vdev.dev->iommu_group, vdev->vdev.dev);
 }
 EXPORT_SYMBOL_GPL(vfio_platform_remove_common);
 
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index 289089910643ac..a5ba82c8cbc354 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -9,6 +9,7 @@
 
 #include <linux/types.h>
 #include <linux/interrupt.h>
+#include <linux/vfio.h>
 
 #define VFIO_PLATFORM_OFFSET_SHIFT   40
 #define VFIO_PLATFORM_OFFSET_MASK (((u64)(1) << VFIO_PLATFORM_OFFSET_SHIFT) - 1)
@@ -42,6 +43,7 @@ struct vfio_platform_region {
 };
 
 struct vfio_platform_device {
+	struct vfio_device		vdev;
 	struct vfio_platform_region	*regions;
 	u32				num_regions;
 	struct vfio_platform_irq	*irqs;
@@ -80,8 +82,7 @@ struct vfio_platform_reset_node {
 
 extern int vfio_platform_probe_common(struct vfio_platform_device *vdev,
 				      struct device *dev);
-extern struct vfio_platform_device *vfio_platform_remove_common
-				     (struct device *dev);
+void vfio_platform_remove_common(struct vfio_platform_device *vdev);
 
 extern int vfio_platform_irq_init(struct vfio_platform_device *vdev);
 extern void vfio_platform_irq_cleanup(struct vfio_platform_device *vdev);
-- 
2.30.2

