Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 304AA642BCC
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 16:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbiLEPbR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 10:31:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232706AbiLEPao (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 10:30:44 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2066.outbound.protection.outlook.com [40.107.93.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218EDC48
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 07:29:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iAuAueROo4eV1TS/FyEz6i5JF9n4nGDWDsLl5odeaHCsMt7erTo6Jf6MbkgHWK1joABueGSULiMC9tvobJfDIwPqR8bvr/0kGONi9g1oEAXUmxtFvPIuXPKg7J6roQYCXCDDBxdLODpFvZk1gAtubsc1vEHwHtUZNAeN49Z1m8PTkOBIld6NHm2qEVUPBMY/WEFBa/205Icz02Vb6hKR/yOm0uHHz1aLmn1wBUgiIlcRyym6UMQtF/pNIElP/EL5lt6PqBtGYalNjP5h72FoKY+1eZGydPZrPGuVzfGnkbV93ynZAMWZB8a/n4Esoz4fg9OhCHV0czG+8WBcWVBbEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hI0erIstKao6pkNqRabiNycIXQSTAmgFkRzFq5QkFmg=;
 b=i2AFMhLrOO40exo1B8QECStymed4k9LfXiKBetC8PySHcJpyKApEGGgHJi6UV5Ueu5AsrWzlDxGnwjiv1qKwDh9ihRNVkGyAKZGMzMmByTHUR3aKaFbc0NjvO3JRZ8Yo43r9zZ4qMZuO3vu4gOSlGkCPyn8eFVh6eYt3qsFQO/l6ZdplZ6Y1BTxNNB5gRYyuzq6MOYPj9rYBJ9u3o1YS/ldNJCFcFioVGTR9PSuHobT8YnQp2zUiR3jm7CQaQMvEX8v9Grw7dUaBejBVruueSy8o4C0D8EGYc15v07XZcdbG+YOTs+4HSHxEtz8f5PCGz7FBtRs2zrjkx1qayyvwVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hI0erIstKao6pkNqRabiNycIXQSTAmgFkRzFq5QkFmg=;
 b=lBqSQ4FVGh1aeG4A6cmimswBftSaW1YI1Ssr7L/luD/SE8UTGQarH/6HMCGZcwJQzIVsuzOdRiuE27wzDUmdVMca+7zNNOyKzS3MM5mRp67XezwXreIh2PHqOON+RnFitGH33VqopVYgviuZHcqsyTLbK+iViAj8dyi4igLIkla9xBjKPyn4jmJahXm4JprZsV+XcAYm/7yv4dDRXfdfzjzl8F2TUZoIV3peqpSymnD7gnc8PyWRpn8q/Cap4hrJGOKFawjrzr8Y/PkfuL0QZYn8uIfjudBY64sndWqWB0GgxIJicQxcXWYMQURnGA2WKW7SVn+GInvBh9G3mDJ4hw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB6662.namprd12.prod.outlook.com (2603:10b6:8:bb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 5 Dec
 2022 15:29:26 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5880.013; Mon, 5 Dec 2022
 15:29:25 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        =?utf-8?q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v5 3/5] vfio: Move vfio_spapr_iommu_eeh_ioctl into vfio_iommu_spapr_tce.c
Date:   Mon,  5 Dec 2022 11:29:18 -0400
Message-Id: <3-v5-fc5346cacfd4+4c482-vfio_modules_jgg@nvidia.com>
In-Reply-To: <0-v5-fc5346cacfd4+4c482-vfio_modules_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0036.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::49) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB6662:EE_
X-MS-Office365-Filtering-Correlation-Id: c06bdcc4-8d52-46e7-42d0-08dad6d57cc6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RfQy+o3SgAkSiB9g7KMIsj9uY9PovdPj40TAbZdQaIuJQE/KaPdyWH/PT3X/heUCsrOjoQ6iSZBX9rnZyCD3uGiccD7UX6xS90TwITby+ByK6EVhBdb+z7v4tTYvNeAZxJFHJ6S2r4ISAjK3MzHhd++21qWe/LZz2E88QMPF67XKvfxYpz8+mm1fJd6C5YX20Gls5T8QoTFB3sMkJ9M26adM3Q/npA71iek8sD/2jZD231/p6W9nHmiExIjNH5yRsLEIhse4TNsLUFMYmZsGXpDChVjv8i7tNmQR/doPAIbhAIYVT1RNFsydDCtCaydaqxYLh3tSR5PvRHd0e17jSlkt7czBUNQyTuM6MWJO7fuqeG1iQNOGb6tFeLx9VeBnjB0gpl7PpqYhij4DNLZC2782BpOB0ugfeEq79S4FletBBS4i/C86NhX4eoNLbn/zg0VtVZuhqL2aBBCsfluKSjKzmtnXy549DMfQOiQaG3v4lKuxdZu4ImLVSEuWkf7j8jPpJy0mre1e7EVQ3523Ak1Zps4nJGt1SM23QuloWF3mExRZ501SDxbpxAla40dSdCPFL1/IpgbunoZZPQQ8zfrbwbvkj34eBIpVE2C4515QA2r+zxT8C8jGcL3DXSuAorI/MEGSWgwyyR8LmSUOv5XuGHe+VDEl5r995ZMmehi5VU5LnWHug+AQLx35ww5F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(396003)(366004)(136003)(346002)(451199015)(66476007)(36756003)(38100700002)(2906002)(41300700001)(4326008)(5660300002)(8936002)(83380400001)(86362001)(478600001)(6666004)(66556008)(2616005)(8676002)(54906003)(110136005)(186003)(316002)(6506007)(6486002)(66946007)(6512007)(26005)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kXePglzU+Scu/cte2u4UO11mfJKiI1jv3FJX3DIN6B0pQ4jzB9sLfrP8MzDG?=
 =?us-ascii?Q?+vpHs2Qm0hf0ZTwZV1DiLDAUbyW6Koo++EgBXdVbu5pJkK4OPGj6bY7lUE/v?=
 =?us-ascii?Q?LEyKxVnpdDpnE0xnDGMKeleR1dNu9kNSzznkMjiYa6xagS/63bRojfXW9bGA?=
 =?us-ascii?Q?+LVryUohBnaFiqCkp0ImFki/gGtNviF7NPNR0FtL/ciy4Y5v39+GIzmj6hLk?=
 =?us-ascii?Q?ERQU+AcPYhBz8I28Q50kP9k84Gf5hJ0P6S/arbm2uBK2cRQVbBh7NBQRjihu?=
 =?us-ascii?Q?ArYPdgOs0NE2dkmpxBCW2D6Bp7avWHKdDdB3ouYrwBqdY0if+5v76aSLlDWR?=
 =?us-ascii?Q?V/4kVIvqzb4hrEKsf9MNUMSfVh1PfAwJ8zzSfi2DDCG71wLWd2uavOJF4p43?=
 =?us-ascii?Q?18AhJSiYrH7rlbH8lsNUgAfsKNMhcfMMDzDBKmAm0wLPtEB7GnduEhhBhnZi?=
 =?us-ascii?Q?WWakFlTgm6mM1lyGm+zda9XRf037ydSOfIjFoyHAGGrmuOqHhd5OFHhcY2ka?=
 =?us-ascii?Q?Nv1rGvvZ+oB9/lvJaWoR+EL3fEum71bAmgq5xMkso08ZS1Fbc4rJnTpgv0ip?=
 =?us-ascii?Q?LFF77URpzoDocUkllv+TQytwrStADWVeCDt0HDQbk7EF7BuwyWswXuDbKVoA?=
 =?us-ascii?Q?kNaUDwjnHhM+C6Srhv4BrExIhkUJpIAs5ha4xhnnmgqEwNBxShYyJOoSkNL9?=
 =?us-ascii?Q?rCd2hOxESRv9cI9f6tEoXWbvs5aaudKUHXl/JLpNgGOwpDmM9Zabk/MQF2X/?=
 =?us-ascii?Q?+TO6mOvh94zlqM3AAg+0Lq4mC/1cBmpyPYWiaGONR20c7nhY59zmy4XNb4SX?=
 =?us-ascii?Q?JNIQ8lk7WIPWsocHHSeElzcsMrPzvvZZRZodrO0039vSAmaN0UwPlIM12yOa?=
 =?us-ascii?Q?hPD13R/g6DWMJ0vcCfXgShaI5cIYYBHyk5t5Q8eKhw0LIPv+x6KO8XldBu4E?=
 =?us-ascii?Q?8VgqMbhRpaCWM3zIDnF1I9Ac23gO9v/Uxd+6OwA0HYzNAISMtKhsbnQGnoLE?=
 =?us-ascii?Q?5IIqmCkgCcS8f/rOPD0UfILMwOXqXZPwwElBL9s31oiuqkNABAypCbixw195?=
 =?us-ascii?Q?7RjP5KNVQd/7qD4w0HzMwR9PMfHA0ycFL4PSRCpQVH4kfJooPmpTduJ+wm0c?=
 =?us-ascii?Q?rDMeffthNa/msYpbQxV/xPmDffhE//3V3qWU0RGISQ/7BlrT3F09XrzTeBJ0?=
 =?us-ascii?Q?UCRjLASbvVnBxveQbRGW1QIA0zy7l/uBAGVUp+wJqhDDbnu8eo+chdVZS1Kt?=
 =?us-ascii?Q?m8fLtrOv5a9jwruW3kF07Z5idxeBYnW2nzbuH6jAtV4fAcvtpxkW4KjSOfF6?=
 =?us-ascii?Q?pLuQ/FllGu3mVLkVXcVaBCLNeoiDGfB1VBjlrA3humCwRSUmcn/BI6fR0tBk?=
 =?us-ascii?Q?YrMKMdw7f9a8ejyP8afo+TtQrH2G1xL5CdruN52u7L+JVSno5dCnTLrdu0MW?=
 =?us-ascii?Q?zwSSdjnzn7E7oA/Y4S8bRcBJ/IUWUlv5TkO5gS+4+7QUVEhNBushduqny4TE?=
 =?us-ascii?Q?LxSBIKkqJnUkSi3a3mZ9cCAQ+cmoGF18a+q41QBhzkUQcB/tsILgmHhlcvm5?=
 =?us-ascii?Q?XHVEq02VpXuH08ldblCUlYK/3dJqrhZl8y0y6Seb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c06bdcc4-8d52-46e7-42d0-08dad6d57cc6
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 15:29:23.6717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5u6s9YinfTRF0dS4n2wHI/RLS7SSW4WAXGyDxtJKnJxrQFPp1CkNCMozZAowFMug
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6662
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/Makefile               |  1 -
 drivers/vfio/vfio_iommu_spapr_tce.c | 55 +++++++++++++++++-
 drivers/vfio/vfio_spapr_eeh.c       | 88 -----------------------------
 include/linux/vfio.h                | 12 ----
 4 files changed, 53 insertions(+), 103 deletions(-)
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
index 73cec2beae70b1..60a50ce8701e5c 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -4,6 +4,7 @@
  *
  * Copyright (C) 2013 IBM Corp.  All rights reserved.
  *     Author: Alexey Kardashevskiy <aik@ozlabs.ru>
+ * Copyright Gavin Shan, IBM Corporation 2014.
  *
  * Derived from original vfio_iommu_type1.c:
  * Copyright (C) 2012 Red Hat, Inc.  All rights reserved.
@@ -773,6 +774,57 @@ static long tce_iommu_create_default_window(struct tce_container *container)
 	return ret;
 }
 
+static long vfio_spapr_ioctl_eeh_pe_op(struct iommu_group *group,
+				       unsigned long arg)
+{
+	struct eeh_pe *pe;
+	struct vfio_eeh_pe_op op;
+	unsigned long minsz;
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
+		return eeh_pe_set_option(pe, EEH_OPT_DISABLE);
+	case VFIO_EEH_PE_ENABLE:
+		return eeh_pe_set_option(pe, EEH_OPT_ENABLE);
+	case VFIO_EEH_PE_UNFREEZE_IO:
+		return eeh_pe_set_option(pe, EEH_OPT_THAW_MMIO);
+	case VFIO_EEH_PE_UNFREEZE_DMA:
+		return eeh_pe_set_option(pe, EEH_OPT_THAW_DMA);
+	case VFIO_EEH_PE_GET_STATE:
+		return eeh_pe_get_state(pe);
+		break;
+	case VFIO_EEH_PE_RESET_DEACTIVATE:
+		return eeh_pe_reset(pe, EEH_RESET_DEACTIVATE, true);
+	case VFIO_EEH_PE_RESET_HOT:
+		return eeh_pe_reset(pe, EEH_RESET_HOT, true);
+	case VFIO_EEH_PE_RESET_FUNDAMENTAL:
+		return eeh_pe_reset(pe, EEH_RESET_FUNDAMENTAL, true);
+	case VFIO_EEH_PE_CONFIGURE:
+		return eeh_pe_configure(pe);
+	case VFIO_EEH_PE_INJECT_ERR:
+		minsz = offsetofend(struct vfio_eeh_pe_op, err.mask);
+		if (op.argsz < minsz)
+			return -EINVAL;
+		if (copy_from_user(&op, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		return eeh_pe_inject_err(pe, op.err.type, op.err.func,
+					 op.err.addr, op.err.mask);
+	default:
+		return -EINVAL;
+	}
+}
+
 static long tce_iommu_ioctl(void *iommu_data,
 				 unsigned int cmd, unsigned long arg)
 {
@@ -1044,8 +1096,7 @@ static long tce_iommu_ioctl(void *iommu_data,
 
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
2.38.1

