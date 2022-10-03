Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B06145F32C0
	for <lists+kvm@lfdr.de>; Mon,  3 Oct 2022 17:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiJCPj6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Oct 2022 11:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiJCPjt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Oct 2022 11:39:49 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 319D3DFC5
        for <kvm@vger.kernel.org>; Mon,  3 Oct 2022 08:39:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RRKhQ6CFa7FUOIi0HQQcNsCiDd6KmpEB/1PC4CYZ7BEOgrdByxamX7TZSyk71O+QxvPRzPsvMkP3XW8v2WT95252P2U4ZAsWvlI3B+fIT1HhU+nv1HCwOFJQ/n3pMCwr4phEwfm+I/LNBHOmjULsXTwgg8rxJN3GX344lmGfAt4s7wavxu0EC1E+mOTqtrauYiA8OaCtgyEbdLN8obMgfqVzfDkND3xHC8z85QjvENgALM6+gzvrDLWqwXah8e+20JCY4irIo9hIPoJfuXPWs4wxX2oj05tb6EeM3a6nhQjhvbonUFXv1mdOOOruxzv3AQfkNVuDnO36Zel/2Rvk7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pgOlMbaga5CZsfXBvzkZoHfO8+ZGU9PmWmTPfxVSUmw=;
 b=TFXLYL5zM9f9VKK1AGGQQskyBFgkbQp5mS13SagTAYI7chmtInjoTJPpsdEkxCYuobaKjXQ+lKzGgAFD6SKLUoShERHzKXtEkn4PcQCd5WDFkaKNrHBy0XtYYmVTjgqdtWOUVlb44EKv10CQX0T9aykO1ussP5fO3XjzqbU6jtUl4sp1JVGxTu9v7Y4Nh9gN91TSQMeTrGxn9F5kelv4XrgHwqYMKyw6sTCOt/FOt6MLRXTsk1fOdH2eRTSxzJ68YTJQMCZft8qWD6j7hvHSMwQEN5R27Ml/PrTQJrxgIix8YK96CeIu+oq4q5E6tsdV7RlNir7ciy8Ogdj0N1OKOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pgOlMbaga5CZsfXBvzkZoHfO8+ZGU9PmWmTPfxVSUmw=;
 b=Vkv4lNHPp99JW4B12oSB31LNqx9E3wisQeD/XEhhro2zV51LbBozBEYEg4imZ1c7w8Odyc7jbcFuQ8eSnw+J1m391s5hVwEVty7lbpvzedpuaZPRmaGGvXeU87FzJ4Exu21Gi+8JLvdiXm2S7j07iR+dSDPJ2ciBrDLwiYfV0Sh87BE4CvPkqNUD3d6m5Q+nKgcaf6KKeMR5NI5xSuC39uNTTwVNO5rIanrlyhDjl7FYjTS82jWvxmtTGm4gpTpDUuimFJxEk7Cjjoc/A3ABpbvxkFBPcypMf4ua0emBofUEhppJTOFqfHDby6BxACgIdGKii8redz3QXnyJ/zn+4w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SJ0PR12MB5471.namprd12.prod.outlook.com (2603:10b6:a03:300::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Mon, 3 Oct
 2022 15:39:37 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::8557:6d56:cba9:dbba]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::8557:6d56:cba9:dbba%5]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 15:39:36 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v2 2/4] vfio: Move vfio_spapr_iommu_eeh_ioctl into vfio_iommu_spapr_tce.c
Date:   Mon,  3 Oct 2022 12:39:31 -0300
Message-Id: <2-v2-18daead6a41e+98-vfio_modules_jgg@nvidia.com>
In-Reply-To: <0-v2-18daead6a41e+98-vfio_modules_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P223CA0001.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::6) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|SJ0PR12MB5471:EE_
X-MS-Office365-Filtering-Correlation-Id: dcde6393-a069-49a0-9f48-08daa5557955
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BLOArkd15ke3zdDVF6mFwuvZhi8tTzkqu5wHMUJa8Yv8wN0Gs+jy6yeArotV4u6gm2E8HVb13vEEmH/tF/6jmpUAe2Cmsyy5W4NHFU79zmB4UJ4oKhhcT3ibMkjhdaP7h+sKFFtv7hSLGe6EBXJj7DkyE2PJAmJfiy4KHjSb5LpPoZdsVMYrVsydzGIkr92C22lZvIYh21pWBQIu1svmq2JnTXK2mi+mAUBorrIVts/blWlWidwjeoZ70oikROd5kjLauZEj48bFWT9bPcWYDMaSfZxzF4xzGoPsGllPoBJepFfZ7njdxg54S7mf5c0zG4Pk2EFZmDickgtxzMvNOh5uhGHYgPrEi9EWhwjnl2/R4BduSWcR+LeKHIqxZLpwXj6qSfIW96TGcYs1GGSs7I92PscBtr6cKdqq9pzC9wrExNziF/5h+bDpQPN7vz/Ehv3dQe+s4a7JgV/6RgDe1DlCSaLumIx/4bdKsKF8SWpZ4Oz/1c9ug2Z35Iyn8kzsuX8S/1XrTl38aahuAHn+K3afh88A8fbEXDvn6UsgmXRdO9Fvb8XT5VdT89SZoxDp5JB7Z16tDQeDzjktJup5Mzrs629QJSdrSifh0WuCNIj1y0o3j50WptkwxRG240f+/EwRi6ENIR8A2BVoifOOW/kmMRRdysVjI7oQxiRKYQsec58X/O00KiMIjxU149tUsib4bs2aDapepi9mhkLfgim6UfjrzNL6CJeSSuOiY+o4AJwuX2q8//CsNpW+atgc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(366004)(346002)(376002)(136003)(451199015)(6506007)(6666004)(38100700002)(8676002)(66556008)(66946007)(66476007)(36756003)(86362001)(478600001)(2616005)(186003)(26005)(6512007)(6486002)(110136005)(316002)(2906002)(5660300002)(8936002)(83380400001)(41300700001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Bt3A0p/WfwGPhLrxxt8/jPDPHqG71arTtmssV3WYqtsBddi0Sl4hQRL700SO?=
 =?us-ascii?Q?o+TibPUUlxcNAWQVxyCh2f5S8nMxxOAlvxvgRfB1S4Qt4vxcYiCHoZDna2qD?=
 =?us-ascii?Q?e5KooIgdfM8FICDE11nenLbc8YSIaqsV5Vh6H1F2MrHMM8kSvpQDqJhvAQ8s?=
 =?us-ascii?Q?ZLtZhgST9fNs0bSYU/H4dnvnpvB/aILHFTjVXgKzw4vI8akGq9jVM4o7t8e7?=
 =?us-ascii?Q?f+i9W8vDFRSQfk2ghn+/rKZbgaUS+rqY5TZWfRcJAudKlMroi9l39NSmOaSI?=
 =?us-ascii?Q?oCv7F7sDnC7P7U0vOGVVyo7ETjJSrrDFHtyNbHu4RUlGVcQdbqWd5NxKnHl+?=
 =?us-ascii?Q?Fyt5VxdsAOScSIpKSQa4l8/CiigPjWVdBSIE7QfaCMD7CAbF/VyYFPrFqO0p?=
 =?us-ascii?Q?3lw2MSoWOl7zHsQPVUzo8iXqfI/fggtqY0LOVXYrh+On9snitz88oAZ4rtR5?=
 =?us-ascii?Q?GD1zl6Mu+6pzIciMDLwMYk6+D0sSHwL3+i46XH7U0/W/XJazK9g3eRKXei3i?=
 =?us-ascii?Q?dehGevmjLHvYYNi99OFOfLR5VVTbVDcyfXG+T3o37PdvDFYCi+qOCZSwnO2G?=
 =?us-ascii?Q?uF+CYGKAZGzeXJ8tEiXKmj1LFoX/FjSYHNGUHvSN4Zt+5aXz/3CqXCW2yzp1?=
 =?us-ascii?Q?zhUibiVlxyQshTozv5hA4ql7nQepUbpHViEqWOwF2NHON/Jwkc8BTHjSFzXH?=
 =?us-ascii?Q?z3ChRBUjqcBTrUj/rj7XdvZrxDUoTB9wz5rn2qypI3tOsxPRuooCtJbeMGYX?=
 =?us-ascii?Q?3vs5FxEB4E/7Ldt8Sqxpd6DARAIIRLqagVFeLkAKcZEp0+XIKlSAO9z8pAR5?=
 =?us-ascii?Q?aTJ3wOwmrqLvFp4EOrqJEoUPVGgZNLC5Al7inlOO4achZbzqZzo6PUdWAMew?=
 =?us-ascii?Q?21klcc+I1CfWXfDSo0+qZ1UGgB7TVgq8nTqZSxBy2uyyDW6XjBKiIij4ztl4?=
 =?us-ascii?Q?k27m6JKaRJ1CHEK2/AEIETiZiurEg0ljOFk7//GFz0oqAE2SsDzhVY1RCOJJ?=
 =?us-ascii?Q?WSWQUgPaHaXntOf5NlUcGoV1ILii17aF6ENSm/qDOVUNhbzKsmwUcWw9fAU9?=
 =?us-ascii?Q?fpmXYAZRIH44EY99RVDrTxsN0ajT6Af/M8lE9Dex9DamjQjVDX3KhiRWYgc9?=
 =?us-ascii?Q?+r0Mz7mPsLpK/LzH4fGI6kUgwKyYL4GqSMpkRvzLu3Jf0rna1MFrSAaNW1ql?=
 =?us-ascii?Q?REd9PtfLQRteFkcsLSMvfIEL15gIyXwgpmFiuePEGpb9bMZk3Try8ZHSdBUX?=
 =?us-ascii?Q?kZ0b+jbxTGNJdGwdxXeQv0ZrLv+TheAXEUTxu1N2UsMrK8ZNPD1sora7FuIW?=
 =?us-ascii?Q?JcG8/m3U8QDet5kkcr0I09zZOCrSzL1CcTYhk1BI4z1YPM1H28yy4aeUESP4?=
 =?us-ascii?Q?cphRkvoRVfRTmBb3d5VS+GJWV0GRmCnjgOX6Wqh2eVYWn/XR/3XQ6OjHDoPR?=
 =?us-ascii?Q?ve+D70rjq19SkJReDuQPZsA0fH0ucWiPNXDcmRimYTTBrL5rxcjgICyuoN9a?=
 =?us-ascii?Q?RSsQYuhNTWCm2Mn7T3BcN1ebPlTt/eJQZ5R4pLgNfm4q/o5Fou97a1wrKu3u?=
 =?us-ascii?Q?y/zldIjZEE3qfI4oCZjX0jJoOe9DLnmz7+q7wMf/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcde6393-a069-49a0-9f48-08daa5557955
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 15:39:35.4848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fu3bh7s6ZDHgH81enKgwAqLbiMyNCQbwRmQmTzo6l4UZJsyJFT/HQ8AmXmlCYGs6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5471
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This helper function is only used to implement the ioctl for the SPAPR
container, put it logically where it belongs.

The PPC64 kconfig is a bit of a rats nest, but it turns out that if
CONFIG_SPAPR_TCE_IOMMU is on then EEH must be too:

config SPAPR_TCE_IOMMU
	bool "sPAPR TCE IOMMU Support"
	depends on PPC_POWERNV || PPC_PSERIES
	select IOMMU_API
	help
	  Enables bits of IOMMU API required by VFIO. The iommu_ops
	  is not implemented as it is not necessary for VFIO.

config PPC_POWERNV
	select FORCE_PCI

config PPC_PSERIES
	select FORCE_PCI

config EEH
	bool
	depends on (PPC_POWERNV || PPC_PSERIES) && PCI
	default y

So we don't need to worry about the fact that asm/eeh.h doesn't define
enough stuff to compile vfio_spapr_iommu_eeh_ioctl() in !CONFIG_EEH. If
someday someone changes the kconfig around they can also fix the ifdefs in
asm/eeh.h to compile this code too.

This eliminates an unnecessary module and SPAPR code in a global header.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/Makefile               |  1 -
 drivers/vfio/vfio_iommu_spapr_tce.c | 75 +++++++++++++++++++++++
 drivers/vfio/vfio_spapr_eeh.c       | 94 -----------------------------
 include/linux/vfio.h                | 12 ----
 4 files changed, 75 insertions(+), 107 deletions(-)
 delete mode 100644 drivers/vfio/vfio_spapr_eeh.c

diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
index b693a1169286f8..50b8e8e3fb10dd 100644
--- a/drivers/vfio/Makefile
+++ b/drivers/vfio/Makefile
@@ -10,7 +10,6 @@ vfio-y += vfio_main.o \
 obj-$(CONFIG_VFIO_VIRQFD) += vfio_virqfd.o
 obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
 obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
-obj-$(CONFIG_VFIO_SPAPR_EEH) += vfio_spapr_eeh.o
 obj-$(CONFIG_VFIO_PCI) += pci/
 obj-$(CONFIG_VFIO_PLATFORM) += platform/
 obj-$(CONFIG_VFIO_MDEV) += mdev/
diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
index 169f07ac162d9c..47a8b138cf7f6d 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -773,6 +773,81 @@ static long tce_iommu_create_default_window(struct tce_container *container)
 	return ret;
 }
 
+static long vfio_spapr_iommu_eeh_ioctl(struct iommu_group *group,
+				unsigned int cmd, unsigned long arg)
+{
+	struct eeh_pe *pe;
+	struct vfio_eeh_pe_op op;
+	unsigned long minsz;
+	long ret = -EINVAL;
+
+	if (!IS_ENABLED(CONFIG_EEH))
+		return -ENOTTY;
+
+	switch (cmd) {
+	case VFIO_CHECK_EXTENSION:
+		if (arg == VFIO_EEH)
+			ret = eeh_enabled() ? 1 : 0;
+		else
+			ret = 0;
+		break;
+	case VFIO_EEH_PE_OP:
+		pe = eeh_iommu_group_to_pe(group);
+		if (!pe)
+			return -ENODEV;
+
+		minsz = offsetofend(struct vfio_eeh_pe_op, op);
+		if (copy_from_user(&op, (void __user *)arg, minsz))
+			return -EFAULT;
+		if (op.argsz < minsz || op.flags)
+			return -EINVAL;
+
+		switch (op.op) {
+		case VFIO_EEH_PE_DISABLE:
+			ret = eeh_pe_set_option(pe, EEH_OPT_DISABLE);
+			break;
+		case VFIO_EEH_PE_ENABLE:
+			ret = eeh_pe_set_option(pe, EEH_OPT_ENABLE);
+			break;
+		case VFIO_EEH_PE_UNFREEZE_IO:
+			ret = eeh_pe_set_option(pe, EEH_OPT_THAW_MMIO);
+			break;
+		case VFIO_EEH_PE_UNFREEZE_DMA:
+			ret = eeh_pe_set_option(pe, EEH_OPT_THAW_DMA);
+			break;
+		case VFIO_EEH_PE_GET_STATE:
+			ret = eeh_pe_get_state(pe);
+			break;
+		case VFIO_EEH_PE_RESET_DEACTIVATE:
+			ret = eeh_pe_reset(pe, EEH_RESET_DEACTIVATE, true);
+			break;
+		case VFIO_EEH_PE_RESET_HOT:
+			ret = eeh_pe_reset(pe, EEH_RESET_HOT, true);
+			break;
+		case VFIO_EEH_PE_RESET_FUNDAMENTAL:
+			ret = eeh_pe_reset(pe, EEH_RESET_FUNDAMENTAL, true);
+			break;
+		case VFIO_EEH_PE_CONFIGURE:
+			ret = eeh_pe_configure(pe);
+			break;
+		case VFIO_EEH_PE_INJECT_ERR:
+			minsz = offsetofend(struct vfio_eeh_pe_op, err.mask);
+			if (op.argsz < minsz)
+				return -EINVAL;
+			if (copy_from_user(&op, (void __user *)arg, minsz))
+				return -EFAULT;
+
+			ret = eeh_pe_inject_err(pe, op.err.type, op.err.func,
+						op.err.addr, op.err.mask);
+			break;
+		default:
+			ret = -EINVAL;
+		}
+	}
+
+	return ret;
+}
+
 static long tce_iommu_ioctl(void *iommu_data,
 				 unsigned int cmd, unsigned long arg)
 {
diff --git a/drivers/vfio/vfio_spapr_eeh.c b/drivers/vfio/vfio_spapr_eeh.c
deleted file mode 100644
index c9d102aafbcd11..00000000000000
--- a/drivers/vfio/vfio_spapr_eeh.c
+++ /dev/null
@@ -1,94 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * EEH functionality support for VFIO devices. The feature is only
- * available on sPAPR compatible platforms.
- *
- * Copyright Gavin Shan, IBM Corporation 2014.
- */
-
-#include <linux/module.h>
-#include <linux/uaccess.h>
-#include <linux/vfio.h>
-#include <asm/eeh.h>
-
-#define DRIVER_VERSION	"0.1"
-#define DRIVER_AUTHOR	"Gavin Shan, IBM Corporation"
-#define DRIVER_DESC	"VFIO IOMMU SPAPR EEH"
-
-long vfio_spapr_iommu_eeh_ioctl(struct iommu_group *group,
-				unsigned int cmd, unsigned long arg)
-{
-	struct eeh_pe *pe;
-	struct vfio_eeh_pe_op op;
-	unsigned long minsz;
-	long ret = -EINVAL;
-
-	switch (cmd) {
-	case VFIO_CHECK_EXTENSION:
-		if (arg == VFIO_EEH)
-			ret = eeh_enabled() ? 1 : 0;
-		else
-			ret = 0;
-		break;
-	case VFIO_EEH_PE_OP:
-		pe = eeh_iommu_group_to_pe(group);
-		if (!pe)
-			return -ENODEV;
-
-		minsz = offsetofend(struct vfio_eeh_pe_op, op);
-		if (copy_from_user(&op, (void __user *)arg, minsz))
-			return -EFAULT;
-		if (op.argsz < minsz || op.flags)
-			return -EINVAL;
-
-		switch (op.op) {
-		case VFIO_EEH_PE_DISABLE:
-			ret = eeh_pe_set_option(pe, EEH_OPT_DISABLE);
-			break;
-		case VFIO_EEH_PE_ENABLE:
-			ret = eeh_pe_set_option(pe, EEH_OPT_ENABLE);
-			break;
-		case VFIO_EEH_PE_UNFREEZE_IO:
-			ret = eeh_pe_set_option(pe, EEH_OPT_THAW_MMIO);
-			break;
-		case VFIO_EEH_PE_UNFREEZE_DMA:
-			ret = eeh_pe_set_option(pe, EEH_OPT_THAW_DMA);
-			break;
-		case VFIO_EEH_PE_GET_STATE:
-			ret = eeh_pe_get_state(pe);
-			break;
-		case VFIO_EEH_PE_RESET_DEACTIVATE:
-			ret = eeh_pe_reset(pe, EEH_RESET_DEACTIVATE, true);
-			break;
-		case VFIO_EEH_PE_RESET_HOT:
-			ret = eeh_pe_reset(pe, EEH_RESET_HOT, true);
-			break;
-		case VFIO_EEH_PE_RESET_FUNDAMENTAL:
-			ret = eeh_pe_reset(pe, EEH_RESET_FUNDAMENTAL, true);
-			break;
-		case VFIO_EEH_PE_CONFIGURE:
-			ret = eeh_pe_configure(pe);
-			break;
-		case VFIO_EEH_PE_INJECT_ERR:
-			minsz = offsetofend(struct vfio_eeh_pe_op, err.mask);
-			if (op.argsz < minsz)
-				return -EINVAL;
-			if (copy_from_user(&op, (void __user *)arg, minsz))
-				return -EFAULT;
-
-			ret = eeh_pe_inject_err(pe, op.err.type, op.err.func,
-						op.err.addr, op.err.mask);
-			break;
-		default:
-			ret = -EINVAL;
-		}
-	}
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(vfio_spapr_iommu_eeh_ioctl);
-
-MODULE_VERSION(DRIVER_VERSION);
-MODULE_LICENSE("GPL v2");
-MODULE_AUTHOR(DRIVER_AUTHOR);
-MODULE_DESCRIPTION(DRIVER_DESC);
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index b0557e46b777a2..73bcb92179a224 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -230,18 +230,6 @@ int vfio_set_irqs_validate_and_prepare(struct vfio_irq_set *hdr,
 				       int num_irqs, int max_irq_type,
 				       size_t *data_size);
 
-#if IS_ENABLED(CONFIG_VFIO_SPAPR_EEH)
-long vfio_spapr_iommu_eeh_ioctl(struct iommu_group *group, unsigned int cmd,
-				unsigned long arg);
-#else
-static inline long vfio_spapr_iommu_eeh_ioctl(struct iommu_group *group,
-					      unsigned int cmd,
-					      unsigned long arg)
-{
-	return -ENOTTY;
-}
-#endif /* CONFIG_VFIO_SPAPR_EEH */
-
 /*
  * IRQfd - generic
  */
-- 
2.37.3

