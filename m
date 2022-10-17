Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C11BF601673
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 20:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbiJQSij (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 14:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbiJQSii (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 14:38:38 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2057.outbound.protection.outlook.com [40.107.243.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B2247295E
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 11:38:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ls1Ij6atkaPxD62oJN60/Y2oYAlh6saLckKYb1dN0+FeJ1djs/8W1F9UowEpkBUlYZ2Za/A2vf1+qn2pb+TasjPpD0GpY/rXL53dfCGtRbSdM0sTdheR2BYEzYehiwRg/2a/kspmhcdX7P5FFjxLhSJedNiYFEdFeoY2/dUyPYmw/nyxnI/aq3ZLxK5ox7I+/luAMdJqEbMyjeyUbg0hS23+2cFf3ROjVzp+HRUq0wSBLxUp+UwG6+q1jkAsocwhwr2f+J15+4VsQY1N0nNPKbqa7S7HSG2gWlPI2uqANIVm3gxajYLHaUetvkKsh/oooRJP75+zU1ln7FxcDVaf9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JhOkLzteOvM6q9h/O72bsPqcOOuUZxFpO728bW9AZ8k=;
 b=FM9p7LVYq2zYlN1GnUlSU7vabhGwozwmj4arAVcdMeOq8RaK98GFerkGG3yxINsQeUSUTUX4vW4otYNqyETpY1B9dctZvGm7Y5vT7YAUgAdIJ5CIdah2kyG/qsv5kC89rNE2grj+MHVIm2CjDf4MUan1+YLK9lPkkmlaMaN/uOPDleUE4TUeQSON+3v2yColk5wfYiHhErTroU1kvTmIpzrXzEKHRN9CVaboWGJj123JG8fjKC3uoo1f92LPj7ev4lXBsqpCy11TUrFrMSlCK8cxkBanlKfAwCXf8l5Tt3jhTgq6AL/UCmUWe0c+hdjbSbRae7N7+mRhZyCLsbzkHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JhOkLzteOvM6q9h/O72bsPqcOOuUZxFpO728bW9AZ8k=;
 b=IUM848gL2+VmrCrG9/rICF0e+7oUdlpssBCzleBBlDbfO0weN3AeVAt+gsLr2EI5CgsGBXi8jTRFtfFNYiiQlKCC73uuWC3OnKAF6PwWCa8YMsKWgLuAFxqB9TFDvTbBuvCppY0eLm5LkMKgcHdTM44ClOQiybEYuJ57z1XmWayjQdlZeKX1sWh8Pw75XlSa7NMLZbRUFG4/dNJOlMiFZR378QdpLbe4NckM70s/KbCbH1hSL7wjlpfkfyBcmxMLXiw328HNNc6Sl0NzR+cZmBtiUuXGofSj7a36Lej3hZFlpPWiWwt6kZPu1JrU/kZIqzQCgNY8HHUDkgRhdEm/Fw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB7161.namprd12.prod.outlook.com (2603:10b6:510:200::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Mon, 17 Oct
 2022 18:38:35 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%6]) with mapi id 15.20.5723.033; Mon, 17 Oct 2022
 18:38:34 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v3 3/5] vfio: Move vfio_spapr_iommu_eeh_ioctl into vfio_iommu_spapr_tce.c
Date:   Mon, 17 Oct 2022 15:38:31 -0300
Message-Id: <3-v3-8db96837cdf9+784-vfio_modules_jgg@nvidia.com>
In-Reply-To: <0-v3-8db96837cdf9+784-vfio_modules_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR10CA0011.namprd10.prod.outlook.com
 (2603:10b6:208:120::24) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB7161:EE_
X-MS-Office365-Filtering-Correlation-Id: 232d46c7-73e7-4261-29d5-08dab06ecc43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zlxm88V8iaYH9nb1hkrryx2JFO+sLabkxjLDt7TQvWju4r6W5F+f6umgK6bx5Pk3VxlyFnzRP324McKhOrpKyZfxHmt4CJ/YAINaPt3AwERd03J2CRnirPZ3Tef1+4MmKxSYuUwLI8wfe3EH9XUgH2ZgJO4/RPTFm+qwXk0vaSl3NOMsomNDSu/BuuMmKbiOVFaliagEbt3iH5rgWKVicDQEX955OgKK60T9yn1kprD5/non2i3QNX7xG80MUzS9KZYBmXX3dwg9YVzFHQw90ylMGVgYGB/RRip/zvtGpmLE/qI9aowzU78/wErf+jdLsIvum5gDRZ06be7fK5MuVM/ygHCvhT0ET6DThDsujRcLrkAaQNfyt2LpTscw6ij5FUpXhjby4+XObWcTI9AUy8sqZF2vKYHxaFJx9HWuLtTlrb9sesiz2k9biVb5rr06ZDSWWuSXj/UicGUa4YC4OiWMnAb0wuJkxWdoFywb2DRPkXTaSVpIuwveKuU8QweAnv+COpZcz3fyxLLGSjAEA8BxkAa/kyX4KJsXs9h2R0UghQX76ozc/GlzPRZRhNTBI8cqlrzMy/bVnWmbZdZtDqWUgjjaNyprwNCujQrT5XlGIov2LTQmAuasjbTl84xttMCyM1wHQJ9vDwf6zqkKo5mh9X4eEHg5NcpUeaJm9hkP/fpIgKIFEhjWwFE+wozxlKHEX6A7b5r0MXDlW0HicEwbmFYJfzFfq+llPSfBkFkmZWpDcyf5dTCMrcvXV1ti
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(346002)(136003)(396003)(376002)(451199015)(316002)(110136005)(186003)(36756003)(2616005)(6506007)(2906002)(8936002)(26005)(86362001)(41300700001)(83380400001)(6512007)(6666004)(66946007)(66556008)(66476007)(5660300002)(8676002)(6486002)(478600001)(38100700002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ObBtbJrJut4oy+aseYZHGD7rUhJiXRbweptDkixfJKZs//+idBBn9+8J9SOg?=
 =?us-ascii?Q?FlmCVTWtw905gZ+co3/CZMfNaXC4lcVIfAT+0oEdyjnxfUuJhU0G34ffh2Bp?=
 =?us-ascii?Q?A/M94I/Xc3rSFv1QU/77Vx5BtEKjybKTrDA/Hs0RSDVl+jfAP9vD3SoPDXNJ?=
 =?us-ascii?Q?xCujTUbawOCYrfsDcEz2ZtrpJrckBm07CaCFG/xbozYDkPSRv0L15vE3swQj?=
 =?us-ascii?Q?sfjuj+4MdFdTKQFcpJybOTgXgZdGNdIIJzt3YPgRK1vdhMslGQnsvHjAu6NA?=
 =?us-ascii?Q?x0ft20wTk0csAVXhXEliTl1crWSq7ElKJbpiQ68THHm1SFnZnsoJ/BYX57MZ?=
 =?us-ascii?Q?5BZXGDiVZANhulrTWLjdb84n8/UvY4oygxyV5Afa2P3FNVAGmGKDvdTfqtc8?=
 =?us-ascii?Q?Ol31X0CPqqEymUsN2WN4IDE9383JOvo8SD5ynsVoE6OtJZb8wIfMYoPO/qKv?=
 =?us-ascii?Q?YozTBv/fRR8fYHli6tn5Q5r81+Ome9ae3KslLMHVZMR5AdekCRLdYVYbzadR?=
 =?us-ascii?Q?Q4Jv3jmGNnldfTx5Y0VukcNZyUDs8Yaul/OQeN4jvMfqnCEUSne6f/94tUk1?=
 =?us-ascii?Q?MPZaUtMqQBhrrpkrYeQ2xt7ytz645uB++B7D4O9B3oaZuBF3utuQW9g3qycD?=
 =?us-ascii?Q?hhMORzDAPvwivCl+s9MJ2zEvBxMcFvfJrBXWyP8Iu8a8W9cqhZjkHhCyPzfp?=
 =?us-ascii?Q?+vHIk48V5Wo40xySvO4Jb6Z/PevUFcBeRwDT8yDz8I5k2kz3N3eFk0KlA3p2?=
 =?us-ascii?Q?YUui90VGFLqUMqcmyTXSot9BjvimItdXWU/vvotL2W7qDGe4ZxhraiWygnDa?=
 =?us-ascii?Q?C8IFb1z26E50y5gj7y8eoksJfSw7asz1t7rk9GdHcxMNnG/N0qjFFjo6fm47?=
 =?us-ascii?Q?g1AZzku/l1bmtpbXj5dZHWyU7XKyWPrvqC3PYDCznwY9wuswmb/zTYao49OP?=
 =?us-ascii?Q?8/7QXFRjYZ4iRzyWr7orzFCJ6CcsixEB3M8e23tXbYgg+gZ+IFDdtzmjnJqY?=
 =?us-ascii?Q?UDyth8IHk86/60cP1l6UuVeU7Rw1g45rnb6zFgEC8jrrtKywwgJYsjygbQQS?=
 =?us-ascii?Q?w9AO1udExfz+U6lZBfs9/ohFfNAWxAE0O3JFqAZC9Hv+hBvFhprGCCa2qSIj?=
 =?us-ascii?Q?ASpLT+s1vxgD8ZstPYwbFRYVKGvjitbDGH8wtNUOzSFm+GvZEYPW1mms6qD/?=
 =?us-ascii?Q?zRd2sXeFivd5pUpV75Ipbtcf8n1B84/8DLKXOpa8f+rWhMdf0fNOAgkO8cu5?=
 =?us-ascii?Q?GY11gUSN/L4eINmfxl+jJ7bVDsd7WHnzSNAvPOws00PyJrLY159beQ22tKQ+?=
 =?us-ascii?Q?ocpJ5Y1jb6gfJuvuKm+78MmI43fVYN0px0nGbcMOMz6pvGdZg6/Se6FLgLve?=
 =?us-ascii?Q?hofmsC1Nk/ynAjNY3QFAUM3khI+lUdOcRHUBBFaCXLN0vAtw1+38bOyTH3HO?=
 =?us-ascii?Q?xUxTlinpz6VhUZEDPW8N0aVGX4E8c0qUmGnS1g4LBQ9nw3Yl+rDbVnN7TVxj?=
 =?us-ascii?Q?4dEWy3nlXXPkPof6vq3yx8BqwWG/vNi4dTTgolm7bazfWVdM2OmAbk7/zmS2?=
 =?us-ascii?Q?OW5xQw9S7nQZyqan80k=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 232d46c7-73e7-4261-29d5-08dab06ecc43
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2022 18:38:34.8222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /8xeY9ZNvvW1dY4+PJCggxUNtJSG6eIfiy4Cf5NXlyKC5YedVKgc3b3hFPK1D/T7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7161
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As with the previous patch EEH is always enabled if SPAPR_TCE_IOMMU, so
move this last bit of code into the main module.

Now that this function only processes VFIO_EEH_PE_OP remove a level of
indenting as well, it is only called by a case statement that already
checked VFIO_EEH_PE_OP.

This eliminates an unnecessary module and SPAPR code in a global header.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/Makefile               |  1 -
 drivers/vfio/vfio_iommu_spapr_tce.c | 65 ++++++++++++++++++++-
 drivers/vfio/vfio_spapr_eeh.c       | 88 -----------------------------
 include/linux/vfio.h                | 12 ----
 4 files changed, 63 insertions(+), 103 deletions(-)
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
index 73cec2beae70b1..3ea0e7b75c2455 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -773,6 +773,68 @@ static long tce_iommu_create_default_window(struct tce_container *container)
 	return ret;
 }
 
+static long vfio_spapr_ioctl_eeh_pe_op(struct iommu_group *group,
+				       unsigned long arg)
+{
+	struct eeh_pe *pe;
+	struct vfio_eeh_pe_op op;
+	unsigned long minsz;
+	long ret = -EINVAL;
+
+	pe = eeh_iommu_group_to_pe(group);
+	if (!pe)
+		return -ENODEV;
+
+	minsz = offsetofend(struct vfio_eeh_pe_op, op);
+	if (copy_from_user(&op, (void __user *)arg, minsz))
+		return -EFAULT;
+	if (op.argsz < minsz || op.flags)
+		return -EINVAL;
+
+	switch (op.op) {
+	case VFIO_EEH_PE_DISABLE:
+		ret = eeh_pe_set_option(pe, EEH_OPT_DISABLE);
+		break;
+	case VFIO_EEH_PE_ENABLE:
+		ret = eeh_pe_set_option(pe, EEH_OPT_ENABLE);
+		break;
+	case VFIO_EEH_PE_UNFREEZE_IO:
+		ret = eeh_pe_set_option(pe, EEH_OPT_THAW_MMIO);
+		break;
+	case VFIO_EEH_PE_UNFREEZE_DMA:
+		ret = eeh_pe_set_option(pe, EEH_OPT_THAW_DMA);
+		break;
+	case VFIO_EEH_PE_GET_STATE:
+		ret = eeh_pe_get_state(pe);
+		break;
+	case VFIO_EEH_PE_RESET_DEACTIVATE:
+		ret = eeh_pe_reset(pe, EEH_RESET_DEACTIVATE, true);
+		break;
+	case VFIO_EEH_PE_RESET_HOT:
+		ret = eeh_pe_reset(pe, EEH_RESET_HOT, true);
+		break;
+	case VFIO_EEH_PE_RESET_FUNDAMENTAL:
+		ret = eeh_pe_reset(pe, EEH_RESET_FUNDAMENTAL, true);
+		break;
+	case VFIO_EEH_PE_CONFIGURE:
+		ret = eeh_pe_configure(pe);
+		break;
+	case VFIO_EEH_PE_INJECT_ERR:
+		minsz = offsetofend(struct vfio_eeh_pe_op, err.mask);
+		if (op.argsz < minsz)
+			return -EINVAL;
+		if (copy_from_user(&op, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		ret = eeh_pe_inject_err(pe, op.err.type, op.err.func,
+					op.err.addr, op.err.mask);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+	return ret;
+}
+
 static long tce_iommu_ioctl(void *iommu_data,
 				 unsigned int cmd, unsigned long arg)
 {
@@ -1044,8 +1106,7 @@ static long tce_iommu_ioctl(void *iommu_data,
 
 		ret = 0;
 		list_for_each_entry(tcegrp, &container->group_list, next) {
-			ret = vfio_spapr_iommu_eeh_ioctl(tcegrp->grp,
-					cmd, arg);
+			ret = vfio_spapr_ioctl_eeh_pe_op(tcegrp->grp, arg);
 			if (ret)
 				return ret;
 		}
diff --git a/drivers/vfio/vfio_spapr_eeh.c b/drivers/vfio/vfio_spapr_eeh.c
deleted file mode 100644
index 221b1b637e18b0..00000000000000
--- a/drivers/vfio/vfio_spapr_eeh.c
+++ /dev/null
@@ -1,88 +0,0 @@
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
index e8a5a9cdb9067f..bd9faaab85de18 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -231,18 +231,6 @@ int vfio_set_irqs_validate_and_prepare(struct vfio_irq_set *hdr,
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
2.38.0

