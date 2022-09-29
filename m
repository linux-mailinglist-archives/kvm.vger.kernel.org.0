Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 510E15EF849
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 17:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235419AbiI2PFN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 11:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235229AbiI2PFL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 11:05:11 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2062.outbound.protection.outlook.com [40.107.244.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAAC653025
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 08:05:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z+M/bYBLQGTcR+6PP+8u+xprz+q7WIkbD4dJzdQMrtA2urKKxF14AxINA+3bBAuUose8r6ja57J9ht5a9ND9TGK3BZV6MdJEvE9OOCh6ktYnbeNNwHN690dIzykBi4cdPFpvWhfx+R+Ero3UNlBZaxnd0xj5Kr20Qmz0pa+h+08khCRfIsaeJfOnNt96CaiLpjCroapH6RJRDWWBajOyXGsIBAfs73pq1T6UjU9GuK+a/hQwZqbCCU058/3kFm2ZfqEsLnPAF2QCOoXMwlQ7cI0oEswOpjZMXrSAWe6PR+6icSaugw0R9U/s0QhoAZNrH9G6KX/o2Kh5vaK5Ksh8aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pgOlMbaga5CZsfXBvzkZoHfO8+ZGU9PmWmTPfxVSUmw=;
 b=oU0xntVEO/lmfqc6UrgSxIJ36M9Z9rgCPqh3eLWRnKmQ26Owz33zmxu5SoCaI2YWx15SO6jtbLTHyKliknSwU/GtZtWz8OYjetJ/ZQZgSu50jqOtfbzBEwmk0ufe8q5qJICPdCIF2LGoKUOh/2lRQDhD9IvKl8S1s5hdEqnYNJyNAf52UPL0WeGn9jEITZ3R0QQUIyoffK0uZtXIaqvwiuVWIbgt59qQXmqyeCGCFeDpcjVCffFkl62KLVbFjdoKSk88EoaoaGj9feJsW+Jm+NU7qe1pdt0hDCzTzgaRkUq2fVf79UeoJfTNvN3y2Bf310nFySZpjckl8XIOYChDhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pgOlMbaga5CZsfXBvzkZoHfO8+ZGU9PmWmTPfxVSUmw=;
 b=IdGqRyMMrKd9dpErKJPnkuepjXZNfF/gHHYPKisG5C1Ba/b0In2X+LQLV8idzan3XV4YV8mPyG+9m7l4d5k71cUDS50/ZLBP4fJbBD9/ksvRSeRAqvRn6ZuW+Up0HIcjFAV/+9YKi6YGcP3+//VJqB+g3T+LGt3RhW+f6o6MoCOp78UBFl9jM/3zV1dZ5K0+cEBB5fUA0DiNY8LoriLDlkxKGnDnmBmURyMThwKYr17Xn/oL9HLqo6C5D8mudV0iW3uiS2Rv+qnyRRfAY/+rDAGmz/5U3/OH0IVL/XsRGGCOF1DL45blDTyVLE8poESvn78uhqr6HWQta3DgF2Yfyw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by PH0PR12MB5645.namprd12.prod.outlook.com (2603:10b6:510:140::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.19; Thu, 29 Sep
 2022 15:05:00 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::f0c0:3a28:55e9:e99c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::f0c0:3a28:55e9:e99c%5]) with mapi id 15.20.5676.019; Thu, 29 Sep 2022
 15:05:00 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH 2/4] vfio: Move vfio_spapr_iommu_eeh_ioctl into vfio_iommu_spapr_tce.c
Date:   Thu, 29 Sep 2022 12:04:56 -0300
Message-Id: <2-v1-10a2dba77915+c23-vfio_modules_jgg@nvidia.com>
In-Reply-To: <0-v1-10a2dba77915+c23-vfio_modules_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0034.namprd20.prod.outlook.com
 (2603:10b6:208:e8::47) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|PH0PR12MB5645:EE_
X-MS-Office365-Filtering-Correlation-Id: c0768e60-1697-4f44-2c3d-08daa22bfaaa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9W80//nwemLWuWJwsg03NduCOwqIM7WvbWTnPRr62TAH0s9ez+QMXAOs1Cst3JismRKDfPsWOmAm81Wm2sA15m/KiuEVlepqpmmqxkMIOxU7V5ilLJQNdqD9h93NZLaayyhVYtlQ2aQEiGgJwXxtdGhiNVhYRBii8wCwGaaKsQj0Ni1DiTWyZVkk326p70ujSOQzF8GALyiNsSMqbLeam8dlT1zZMSxkBOz2ZWJ8QU4I/VFTsAIbfaUR8rpUjVlSeATjj012oAAtUbhTHG2iXNihoBxzLoFW1S/WqGBVTMrBpA45cgm91hz2yTv3kgcO+NdZYd2X1xZer/7C7B5kJF0gl4pak27IqDddrUKIfuHceCOCoVRPOIYtApZQJejRSE95n8BdzjkB4fvt7J+G9kjJ2Pe0+nGeCGo/iFsfdNbAplELp+h45iqmcpCMhjp16PwQrYKlVxqe4jhQjoXdAA9RhEQ4y2Q4cKXjI27ta1EgRoe2vkC+Rr7KcvlH2cJ4OsPD5Ryn25FJeX0neKuQYyPPv6HvV0XhW8EcezKpp4aXXZdZQ4FU1bbFp3Zle3sBiIKvbNw0U1Drg7W5fygkRhTjG93WwMsEQyMeguLIQ31eXM3LeQmqfgxyhvrjSIov17ObzcU8IAJB8lzRkoB79qYxt+LXZ6AFnhQjW7Zn0RvuPYYUTtuIutjTCmwxeXukCCOsRvle9FZnLkZORe/lOsb2KKldN+U6BFzGoV3SVvD03cskXphawj57vm5Alg84
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(346002)(136003)(366004)(451199015)(8676002)(83380400001)(186003)(38100700002)(2616005)(6512007)(2906002)(41300700001)(8936002)(5660300002)(6486002)(478600001)(26005)(6506007)(6666004)(66476007)(66556008)(316002)(66946007)(110136005)(36756003)(86362001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rKgpW2+v8bi9xIvU6dGN49ezGMRj582Cdq+VrX1qz4nTkiYSKdJ1Ndbyc73W?=
 =?us-ascii?Q?BrhNDxrMMYy1hrcUuYvxXK4DjY2npuGKwwZANxtgwNS7yjiivLVedZjBnOpd?=
 =?us-ascii?Q?tH6FLOCd07Q2hqt/3IDV74Xjxd2yWBF2xW9gUmgw1YlE2euPrOfhBTLyoqbI?=
 =?us-ascii?Q?hDDYNFJcTUJv4yz/P/IcDLz7l2C8BRbTXKb8nlPaaisY0rGo9WurtSENuv3A?=
 =?us-ascii?Q?UV1W9qiedq7CJ78bmIN+0JmtJkGv9t5pHSj7dRr70bbPtPW572+BhY4uGaI6?=
 =?us-ascii?Q?HjsAkMrB0GGSrMQGvPAY+rd95wCeJkoxbUTn0fjGnAojpbKB/LQv8jhoDhs8?=
 =?us-ascii?Q?odmYR+4EPQixQJYCbWryvSUGNZONkF3nRQMN/mCHlxzwCKyyou3drDtv1dLA?=
 =?us-ascii?Q?hjCkseg5KThEUAnAigit96GrobgFWs+ZSIyf3004rM0QxxukZyi0X1a98uLX?=
 =?us-ascii?Q?AtkG3vfJ6M1lo8rn2bhfNOnc8JCrL6rdGK+AHPv7fsaFinhaqs3CQNm02I9y?=
 =?us-ascii?Q?PaC4LYVejEs0m6so7pMhjCYnyeNpd6qUD6Ca5oMjW5/oISVQI1fe6w6M3wd4?=
 =?us-ascii?Q?g6VHBt0Xa4mHfyCRsulMUmOUOI77NbAZ5XbvJhKHTgXKsLsxB02K6V+u0Lxe?=
 =?us-ascii?Q?BSm15NoUAkxFwQYRgrvz2EQvu7TOvCGWlq4uo2e6oUH9AQ06TcV/cq2E+SQj?=
 =?us-ascii?Q?6YZHm/ShT2kaX7Tf5B+r039nkrr9edCEMVx8EZm30GACBwPQ83tRueAbdeEg?=
 =?us-ascii?Q?2GIAPfQywh/2PLsKYy6ORXzbner7JLdLdk+tWysrD1undDhTdfT+A4lDcmSx?=
 =?us-ascii?Q?7C8kC8h0ldVapDBH3pnPCIiUKkdyFVmkNKq7D1oFMmsoyXvnuQpJWqCGusZV?=
 =?us-ascii?Q?eRuE0d2WM38V+tE3GZZLMBc5Fs8EEQuUEnHtDoQYNBuky9NNnvaKewxm+Tsm?=
 =?us-ascii?Q?Huu2cDGtxwjIsoB8G/gt7VaZdWPjhgnK7ABVgtJLsi6QQ2b9Apz6QujZpGfA?=
 =?us-ascii?Q?szT5faiWMDhBkV+tMpYWvdZa+DiQYt6kBUL8EqbXKSYo2iHg16rtizkOwp9D?=
 =?us-ascii?Q?5fb9vmmVaxTvuVFjDoG/9ahzQm9rMOvHif3ubrQmDAsqcLJvjOv1mJNbJhD9?=
 =?us-ascii?Q?WLzPh5+5aXmzG76nE6SnEj9i6lWMonwkLKF73ZtwGUhPac9ch9WbfJcfiV61?=
 =?us-ascii?Q?n4A26Y+czDaTM/i0j97hX3fQIqFiqB3efaPZJ1ErSyaPgwwvNfDqCKtJYj9s?=
 =?us-ascii?Q?GBKZnaRUmYPTTS0zNfwp26PkwJa8/yLCCNsTax/f+mlK5xLVW/R3s99DiRk/?=
 =?us-ascii?Q?Tb+fvS+AQaMxiyTF3mazZpKfiYt5P+SvmSj4HYrnWS/yxoCplmKe0kDqkxOf?=
 =?us-ascii?Q?NoiKW4bp+ko7WfTv0bK9u7TYaNaahzQ2IMXp4uc6Qa/RCwpntDEUyvrjx9rp?=
 =?us-ascii?Q?qSF/HwTcs+rHpZAQBRfO0kq9utQ8mfXFp+YahLpII6xF3/yAoKhh+hU2RYs3?=
 =?us-ascii?Q?ADn90X39Xwb30UG4Z3D2iNDUg+C6yerJ/9aMgLIRlkaeM2eZ9pl3BoYVk6+w?=
 =?us-ascii?Q?UmtCbceRaf3mhdf/MZU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0768e60-1697-4f44-2c3d-08daa22bfaaa
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 15:05:00.0346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NUMlag97KswDc+4j64B24+4SWygqOaHEJTIsli4P6zpTI3V1Qb2dFtLvOcQ81P+j
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5645
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

