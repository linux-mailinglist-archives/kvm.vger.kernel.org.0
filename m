Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00510333111
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 22:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbhCIVjJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 16:39:09 -0500
Received: from mail-bn7nam10on2073.outbound.protection.outlook.com ([40.107.92.73]:49607
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231894AbhCIVi6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 16:38:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KlkZyRrfeTD8lYh5D4VIMMoL0RUGgvsFMM9HvHwsRmkfP1nDZonDYv/t+5KxgyphhHlbaX+Gg4BBr9JIm4Ta3H0IQzKO9fQE3h2XVEMKNuR/cAm2eh9pU2uuWivzRuVxk6iiLcLZZ+zs6ORhxBMbCmjSRFQHGGK7qVhXFJkndInG0Ms0Kn4jpIiUmOEJPGjaYmgWh98s6eiZCtqJBQ6tJuz0rF/iuKfH06jsLUXIB6w2oQ0HPtazewisET8v19tLTYfQ08xNiNFcXEfvJ8J0es9pGgjwTgvc1Idrhq5SBVzhfHt+Jtb0a31VRwU6no/mDuFW8uGNBPWC24PyjJzQIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9f9DBzewDDncQNMQrir+ASCLSEiAcXrv9ZjSenurhKY=;
 b=aYfjbeNoluD5LzphoY0To+jzNkrU9i6emfDjfbbFzdlOChKM8U95aATzt2b692ha0m9/M3zrjHaEolbstSe86IoUuiKLBuOwCF84bVHEIb/zl2x/8miCzGrb6yNIKR0ZK4KU9k3k3gnQ1Ani5DHQMogwS0pWvXFstrSi3IO3AZg6MXGSkXw7lm7+4xnHzKFudTYQ18dikVLbma9ZjOd5x9v+ynL4tlUHMVcjnn62ovSQLXOzZaqU+c0OETEIDySO30WFLcefrfKTMfwwXNmRxUlDIxzATEMphFCKKM4lw2GG3rCd0yOaybzK9kEmJLxb1qhonlsi9sT+9BzSDshBfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9f9DBzewDDncQNMQrir+ASCLSEiAcXrv9ZjSenurhKY=;
 b=o6tF+q3Ft5MpaVfJkfGNspSc5I1E0/hEflabE3kS+An0K9O9HYoNk1tEPWksK7YIJurUpJ2nsXGHwjeV2wFnubRoeSGf8fyDOZB2+WXkrnYeWcY2abvx1InjaDP9AhH4cG7HLDh9cQUkUpp8zLDTeXQ4Q4aj3OVDNv6n2eHICAZM6Foj0XX4MK+Ur5Np3KJ2BYm/DWfHTsWVAJ9lxOAnUQT/FiCUuwC0EbY9zW57+0lmRHue04dpO62EufoHJrD4CVHNM0QHA/t12/MXs/bvtDymS57odOjKFpP7d6rMfVy7zWLUWv1JwASu348mQ3Zbl9oY6jxvGruftoZtkDA+Cw==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR1201MB2489.namprd12.prod.outlook.com (2603:10b6:3:e2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Tue, 9 Mar
 2021 21:38:56 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3912.027; Tue, 9 Mar 2021
 21:38:56 +0000
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
Subject: [PATCH 03/10] vfio/platform: Use vfio_init/register/unregister_group_dev
Date:   Tue,  9 Mar 2021 17:38:45 -0400
Message-Id: <3-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
In-Reply-To: <0-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR19CA0066.namprd19.prod.outlook.com
 (2603:10b6:208:19b::43) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR19CA0066.namprd19.prod.outlook.com (2603:10b6:208:19b::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 21:38:55 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lJk44-00AVIj-Ox; Tue, 09 Mar 2021 17:38:52 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf5b29a2-c8a1-4c71-69c7-08d8e343bd47
X-MS-TrafficTypeDiagnostic: DM5PR1201MB2489:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB24898B3E8561C3025481F073C2929@DM5PR1201MB2489.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u7copqZAHCHitW16XHNwze9DHSvyiB6SLGVtY9TLCJlkGwrrbPJN7J6j5vE1URFwgmniC5dKa9NEvl9i3iqGLXNfT83i5Tf9qSKwtYCq79hYP0w2nI+V96sh+TJo2Ck8ZliMYYFlpNl3MEqJiAF70EnyAh2s6CcCv4RuiITL2yjqFoXh7gKHJ/EEHvTZZ+H0eK192jNQdtQRJ4pFKgNg6u7jL2ZG0VP7fQhqCiAWE9qBjBC9FIREFnGewflOakXUD5NhPUIZiD61MId/5IZnk8dISz0Gv//WwaMVktCHlBsaa8opmGgvtVWdHi9zapZWnMl+cGxRsvsaZBaUd8YDkXSlLejKFYbmHpda1S0LMqQkyBDzWU2qH3N+OKmdVMeMboa7TQ+MNVzY20L7OtK84D/4i0nBcue6PsXD26Gj7r1fuWhujIU7gBflbX3PZH7xxWdSlDjH/M4NCHVciwJZ031CI+eXzZIQpGYA5qv9cO0CPxqIwNhKdpRfX2hOe8OwrQ33nxfWZ/7O9kIaH6vC5AwAq/pOh+Xei+GAxoNqqGDf+8PZ5t1PLDQxdQ7GOR88
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(39860400002)(396003)(366004)(6666004)(26005)(36756003)(316002)(5660300002)(4326008)(478600001)(54906003)(110136005)(9746002)(426003)(66556008)(66476007)(2616005)(9786002)(8936002)(86362001)(186003)(2906002)(8676002)(107886003)(83380400001)(66946007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Ne+n2Wy71n3TLxaJ1gmSAPffQRe8FMRMItwOxT4x3Bd9xDUSChmPJk5Ou8pc?=
 =?us-ascii?Q?UxlSda9wOUgo4nbuk8FHZOUhMBsKlErdJq5dydg51z6azIkTrX7eyT1vGfR6?=
 =?us-ascii?Q?1kfgTFqmi06MSIDdLWDrqDDd3lIbnx0mgK+kIlCLhU7Ky3+v1RBnXzekYxSi?=
 =?us-ascii?Q?jtLGrGSOiLclD+R9SkVgZY2D8uin0ta1Ch1XZdNC5PF1hPEaq5W1iQxba6pA?=
 =?us-ascii?Q?aETZnuf4HhKqTM3pYlyTw48HkmUCHqNwOJsGhVuyiYxct3eDPhhqBMhGmlZC?=
 =?us-ascii?Q?IM44heYWYgJqeXcJwtGTzm2vhdvvc27t0c9PnnuhhWAlo/LFJInDAi4OJ+Xh?=
 =?us-ascii?Q?sMbSjpNmcDfE2sdOIiBiNlwVYJsRABIjOPY3CcseRP4ur78PPeAw27cmdi75?=
 =?us-ascii?Q?ftSAZzKhecYq5i+kee2f2ZWeUOD7VTq4v1ld0Po5yGcRWTduNZM/AoL2YfXR?=
 =?us-ascii?Q?kNx+cM8t/yId2CQvohPRdWfXCRfs2/NVmbcZG/eYOmzMpBn53yJAzaonf6eS?=
 =?us-ascii?Q?0iiG7mpC6mZKk5P0BLPaa8myCS/Ub0XaDdImTi59wc/03n83U22ZqxLAdNLV?=
 =?us-ascii?Q?jEPz8+E3NTKUWiDBkQYHu+XnNKaA7POuFir30Sc/8K4e7i52W+nbtRh7QzbE?=
 =?us-ascii?Q?5p7/KcMtfZ9u0gzWZDI2kqQIpp8L+cA5FIzJxmZePnaIk/IsSDw1Yq84+eIO?=
 =?us-ascii?Q?oehy6mTpyNL9aZa1BK8Hj8o1qpe3A878BuRs/BP0ph3oFCTA0zSCDmeMJAUe?=
 =?us-ascii?Q?PxMT8VUdynaRZhKNR1lgnNj5sI0vsZQqsU/UdmprqTyPhb7MosJYwtAzVoPj?=
 =?us-ascii?Q?h9qO6/sIOyGN7J3dMS4jvx76Qec3QG2AeHx4WkiGsUu0QteNS3Tax0+Dd1+Z?=
 =?us-ascii?Q?EBSFWYe58E3SoGiW7N0uye6wolMIGeDRPnZ7O41dvXc8fdEIdSvIbbAkISWK?=
 =?us-ascii?Q?bM2go7sh8xWHqYEQdRGYHeThlHKPIN/WpXgPC4TaBYQ1LqROCT33IK38sBRZ?=
 =?us-ascii?Q?KpCLsm665wvHiN4LVZg73mhEVBUSCTYk/kGuWZZ0h+gWUwqFL/jDwF+WPRLG?=
 =?us-ascii?Q?nP6bLusODwJJQ8weO69F/p0P6/9x6ScZ1G8068vy2neyc7q/ohJKYuUBILv7?=
 =?us-ascii?Q?ETA1Yjuo7AWZot63NQB6dkmOL9FvbeYp1ooSyxcrmeTfClffxOjhn39pV2sZ?=
 =?us-ascii?Q?AAfqhtqHEsg+RcTlSGXLwVcK7gQptcsluqDA/8BX7naxVYZcMDwgfce/odhw?=
 =?us-ascii?Q?yh/xqprA8pABAsaM26GvFzSLo6qLXpg/Pya5J8/dzmLXA2RfjlSGRkWOcj33?=
 =?us-ascii?Q?sfHaddAO1MsYMW3x51y7NUmLAi4NLT4fQsmsVx1f4MMdaw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf5b29a2-c8a1-4c71-69c7-08d8e343bd47
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 21:38:55.5780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rbJ7fKimuXRuoQcOIo/PAJxyKVJV2C0/NhT3wcNxFiIV9cPsNViYqLWQ2HSUKH7e
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB2489
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

platform already allocates a struct vfio_platform_device with exactly
the same lifetime as vfio_device, switch to the new API and embed
vfio_device in vfio_platform_device.

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
2.30.1

