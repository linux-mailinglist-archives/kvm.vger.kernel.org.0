Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB8C3464BA
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 17:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233193AbhCWQPk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 12:15:40 -0400
Received: from mail-bn7nam10on2089.outbound.protection.outlook.com ([40.107.92.89]:23521
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233155AbhCWQPS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 12:15:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V0jUrG5fUqFvNv4DismhgtQ3P+VYLwMYMZNXDVhLp0zqs8Ii9Za+tKyYf4jeGJe7KUvI7sa+WjNpJSqg2Vfbwzzpy7n/Tqim13UQ0LY0H7FE2DR4wpaMkd69Y8VwBXFItVfTREZGAc5bpnIElD0DisrQMNf2Y5mSxwXcgBHNH2XoxQPFlXQJLFuCSnatMkwUoGK8d/vScj7msoXHg+yr+q7Ir2hcAr6z5dxrT7CgSnmE14+V9pk08nzCLHm08GdBVedMTWpiQPVZ0mXIJ1sWLvbWNoZfR1YTGVYNKLdp1qV5LHBDvMLIoVYwjWLPSo19cVRGoqjpYLq/lBAPF/Tirw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/y54WC9a+FVWZaqM3M97wYPuLmnZdtfElYFZssIdjgo=;
 b=aOP1qojK7dIDU4zX788FSVxY9bggaOowYOyRvW3ly/JKP4EL1XQyP7pjEadX/DCNuz5z17u/8yxIrCn8Z7y4vuUWLYLppz2JL3fCuC7Kq4tslqFx+DobQOtfdCA31oFtvIF0rMsU0K1Xkq+lfr0ixZiAUoBP4RfYLY4UVM2cTInzQF4z4p2tm3Y9TMZyasQyV+Jhflmc/JCa1ItJbzBWizGlYC3dYvJZ39TNetI9zfaqKaDjVhp3PxO+ZzAkdcoNAQAKjOh/KCjCNdIxySsx3fFmTgRzCro3CUYV8pP9oxPyFR0HTBsVYw6sA5TZLldRgxJa2eEMRx32bkCizvpauQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/y54WC9a+FVWZaqM3M97wYPuLmnZdtfElYFZssIdjgo=;
 b=kvvl068PbSI2i9XMQRjFyxx3Khuz3u4by/IcMJn4l9OUiy7286BdkbeoqJKZjQFTGJdN8QAnd0J06tQFadkBQf36tUnaBvXErdzte53ial1J4A+b0w4+18qJ/kob4VC6+cJfWgLRn98tdEBaorPEl/+OzTqnhFsnrRSBprAAzui98RnEpDllDZOkmZBd84hi9ZX5xGCygVgHvSdXD3u44TuqLlPq/KMJKFVyEhOolyPNiINbse7/xzI0hYkSL1EEFRBJBf6g6sXK8QppqB9gpxp7AajiJHgSi4rfzxKyg4CmQTqsdz237H4/C9113hgKTj1qo0WAGDyZl6ZmSK2qSA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4267.namprd12.prod.outlook.com (2603:10b6:5:21e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Tue, 23 Mar
 2021 16:15:13 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 16:15:13 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Eric Auger <eric.auger@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH v3 04/14] vfio/platform: Use vfio_init/register/unregister_group_dev
Date:   Tue, 23 Mar 2021 13:14:56 -0300
Message-Id: <4-v3-225de1400dfc+4e074-vfio1_jgg@nvidia.com>
In-Reply-To: <0-v3-225de1400dfc+4e074-vfio1_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: BL1PR13CA0189.namprd13.prod.outlook.com
 (2603:10b6:208:2be::14) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by BL1PR13CA0189.namprd13.prod.outlook.com (2603:10b6:208:2be::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.10 via Frontend Transport; Tue, 23 Mar 2021 16:15:09 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lOjgQ-001aCb-G5; Tue, 23 Mar 2021 13:15:06 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8198eceb-cfa8-4989-3796-08d8ee16d49a
X-MS-TrafficTypeDiagnostic: DM6PR12MB4267:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB42674ED8204956AA5CE32663C2649@DM6PR12MB4267.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QaKBvV3wH2egMyXb3DmViamSEDvenug7i7LBw20YVxq3gpCpOWmTX8sUrSOvJrpZ91sYkXAERNM8AtG36a8z/tJjLxGmW3Cu8ohydx5HUmMTUCV+dZQqt1YNiBL/jdPa+7bturuz2oo6gmiaONCnJSB+/+VsWdeKBJB8NkGyg3XywMSNJ/vRdJ1Y3Ssvod20rLNzq8KKjoq/Yqqi/G1zBUl8a6A2Pruvbcs95TC27n4v8MC36rkwzp8f5oqPcB1gm+fW5dM912q8h6vJpcqOdhFV2/GbIf86zsxdjA5m8DJAzXUM4HaX6fl54YDzJSEI3h7GkJdcu/AbdyJidRL+sA3WHqRUymj/OqLwhHeUoeNf/r7ZfZVCkm2B3APg5pKwHvwbyUqkmqFhtoUwI9PN3J5swfWI48PvVQ81C79eXGSHxLinxQ94zDIs2/jb+aNgYujyiHhwNmHPwnaYSsx+cfepz8/ei5Vcym3g1ekvD8Xj68ttSJH4Cj5WDV1vJfoZQ8IgbZMn0LERL4mw2obZmOFqqJX8HCLQMaRcn8cmBE4XNfDUEUJ/bovOPISTD+aAEygkZ57tK3U4+PfEuiwZ3AHELdCQPIynhtZVQK/FWEk1/NNRDJTqwGd4CQdjHmg6DIrFriTstGHzYbr10gvoCT+3DTNIxFkIzq5zsaJdPnacu+7CHlOt55INhMlZJtOi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(5660300002)(66476007)(2616005)(66946007)(66556008)(2906002)(186003)(6666004)(83380400001)(426003)(54906003)(316002)(8936002)(478600001)(8676002)(107886003)(4326008)(26005)(9746002)(9786002)(86362001)(36756003)(38100700001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Sxgd2i7ByDCMbO51CQe0jSePAfBp/fbY5bSYlGoN5LjJ5ixCWxBWbQvWfHS5?=
 =?us-ascii?Q?QHrLNk/voHOntFVM1iMOvDyBQGqVe9BXyq+opCBjV7zzH7s3Kn0oi32A9IxD?=
 =?us-ascii?Q?kprMfwtKzfAU24P/1w3E2Fiii9jW6ZPizxRMUEz1fpOLUoijWtMskRNJKsjg?=
 =?us-ascii?Q?ONbMbkDVMrbSemTTKLktnK7Cw94asvYjzrEgFbZNbnJk+YJpTh3KjNm0ztTb?=
 =?us-ascii?Q?AlP6ABiUhOOIPP04TlD2JVpZHS0WIXl9SWWO1bJQ7PynsHrApTwQ/Zw1/cuE?=
 =?us-ascii?Q?J/gtyXlgbyVL/BbjRj1jgmF1EMM0PqUzi8vPjNwsu/gLq9w9g4pPLuQn26Tr?=
 =?us-ascii?Q?DwSlRGcButclFp1aL1s5ogMJozJ4K9n/5ePXVCjB3oSjWDjP9oXQyNpjq1lT?=
 =?us-ascii?Q?CBBrWd+6rkhrBchL4K2UlnMl8paVbPnZjgjQAAzP6WEapqEveKmKtWdCoNiP?=
 =?us-ascii?Q?GRTiXpFZWErD8lMPziuoBwVa51sHybLAJVvMmIg/Ezwej7I3DJVHrTcpwiiC?=
 =?us-ascii?Q?FrNThcHN5u7mMQz1EEw8qwQrfOowFHkLMqmJtcpdg/HzANwVUWqLZug5cbtB?=
 =?us-ascii?Q?UIQpDUl7SEngD6IbRkQX7DKWKasDquRrEjq/RRMHCafhQRvWAaQTsGni2tGn?=
 =?us-ascii?Q?H/LtYmg9a4yXW9huGl1/tpXWqXpTNM+WzB4ltSpbH7o5ZsL/Lvx5z+Dpe0XT?=
 =?us-ascii?Q?/wQsj+w4aKOpLPEC5o4Du47kS6LLPyXTll6wyvgQci8MdqIqE2LIrjlLCcvv?=
 =?us-ascii?Q?D1BLS2mlzkLSFxEVZNX9LCpCzUgi2lERBrpyMlrfsx0DlAOMvZNcN06iQL2K?=
 =?us-ascii?Q?x9YYYAJqwnzS6bmm/1QHTNUx76TrlBoutbOHwQQ0emeS/dR6c37WEm5dThrS?=
 =?us-ascii?Q?EdaPcd1kzl3CroAwAq+6/kb3hPaaJfszhJF7pucKKOU2s4sHkawfqRbFCpGk?=
 =?us-ascii?Q?VbaMQ2b2uyJ7MVQbr8q2TdGuqYApUtdfd48hUpjo+u2TsxnR0+htSAe2wMkF?=
 =?us-ascii?Q?9aWYqjHe4R2jyf6Q9XPvumEwpzByILUJXT2BQYD60SdOvEbXihApsuv8JKP2?=
 =?us-ascii?Q?D00ab+q4vuu65ZO6TJ6c8k6RJJBeB/FeevcSGxV50oK3Mhw5mJDIG6GnQCdc?=
 =?us-ascii?Q?IKfktMzP3cc+EC58YQj1uVLIuxQuIEA3Q2cFDuDn2q747voiWemxb0XrQ8PP?=
 =?us-ascii?Q?0XB1oq4T3jtBXMniIYVflqDhfniHZejk6d9DQ0LmAelwwQvGZcbNIBCy4uEA?=
 =?us-ascii?Q?9K7zmVijV/4yuP5I2T40DV2ZG6h6yuIEW5ypcvMwG7b/srzoNb5cmjw9uVkE?=
 =?us-ascii?Q?EbBJg5xjBbx9B6Il7JukMrqJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8198eceb-cfa8-4989-3796-08d8ee16d49a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 16:15:09.8072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Qt2QF8QzxltuRJloDXkceYmA0H5erdiQqIl5bFlue0jd6NWIBKRWdgIu+pW/t0+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4267
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

platform already allocates a struct vfio_platform_device with exactly
the same lifetime as vfio_device, switch to the new API and embed
vfio_device in vfio_platform_device.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Acked-by: Eric Auger <eric.auger@redhat.com>
Tested-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/platform/vfio_amba.c             |  8 ++++---
 drivers/vfio/platform/vfio_platform.c         | 20 ++++++++--------
 drivers/vfio/platform/vfio_platform_common.c  | 23 +++++++------------
 drivers/vfio/platform/vfio_platform_private.h |  5 ++--
 4 files changed, 25 insertions(+), 31 deletions(-)

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
index 9fb6818cea12cb..e4027799a154ff 100644
--- a/drivers/vfio/platform/vfio_platform.c
+++ b/drivers/vfio/platform/vfio_platform.c
@@ -54,23 +54,21 @@ static int vfio_platform_probe(struct platform_device *pdev)
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
2.31.0

