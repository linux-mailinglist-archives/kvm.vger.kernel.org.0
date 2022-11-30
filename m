Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66DF563CC4F
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 01:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiK3AKo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 19:10:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbiK3AKd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 19:10:33 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2046.outbound.protection.outlook.com [40.107.100.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEAAD3FBAE
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 16:10:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BHGJ8ljLY8nOgUAtC2aEuFpr/75MqU8PyEJoKwXE1JzA6Y0CvaqO3KtsaBsL3aw1wOS/nGTjaUnPv6WxL6q07tttX7gOek/8Y5ZIfMrijw9WfkyWZpEk6Ui1g22ALu4HldsbB+kKOOPR81OEm4Zr58mCYYByx0DjCjeOGASdMIKCwr5/nF5xrNKDkw2Gp4fyYfvnSzFdiuw4knrEL1noWx20+pGWSU1Ln1BKT0mK5Oy6TVM2Y4qxHovJdD7amoUWqL97Mdcm5HRyQTSNGCLmygCf5ji/+uiILG8HMPz0ZGF7lcKeFYeTXFnC88lsnVckw6+wivT6vE/7q/7Quv8MRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+pMOJ3jKpj1zGjN0hjZrEYlt3jYFeuj51czu0vc7GLo=;
 b=N895NnvC3tGxnjTeHI+fTQOm41MxeJSIwMhI0yWaZ48N435uOsMgDOvpKdxuYCV6oY72k3Lesof5nhTIkzE7iPl6YA7JuAHHaFTKGJ0IcXEu1XkWRJ7DUyrtACtBPzi9ALDk5hZ624rFCqdU5OONWhTpUPk4ItZcWfPpAAR1WzBb4vn8wGJ0jb7hkpmgSy0M7Au0uVeDTpRQihC5w5MYkknJQQddbuzL2UHizZKYFPP96/yZqECQi0A8v4oSTAVl0ukLQV7ar8yrl90TUelNBGwMGybXqPRcHf7TIWQEpBXtJOn7fSMjrWz4Cu6cUvf4mRr/FO0vjpK0w+6YaeuETQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+pMOJ3jKpj1zGjN0hjZrEYlt3jYFeuj51czu0vc7GLo=;
 b=bLtaFJihrVvLzhEaBsLoIsd/zz8/S1eVQcEhJp03GOzAL9WTIUssbS+IABqWcsNuzMBoWs2pB+Y0+5mmeJBC+SeiZ8rHSn5g5SfCTqfUVDW0h/JJWZvVK4ZCRfzynbQLTPOBTJGkZVkajVN5qMcHBSd7Urb+mjAtiMn4O0F/Pkodi3BC+4mQ9AGQN7C6F0+1rmX6byXhb0Se2J4U16lBVd+Jgp79tFZYo6l6wS5GeqbyOjFq5Mz75qXiHJWzkwCtOA+Fx1HYq3clTZ9JJOkUQNV7R5JSsK+lRAKAqxVjdZxR+L60yVn/gMUpphcbj206ZDok+De5uRLKBG1nHCMU3Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB7411.namprd12.prod.outlook.com (2603:10b6:806:2b1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 00:10:25 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 00:10:25 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        =?utf-8?q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v4 3/5] vfio: Move vfio_spapr_iommu_eeh_ioctl into vfio_iommu_spapr_tce.c
Date:   Tue, 29 Nov 2022 20:10:20 -0400
Message-Id: <3-v4-7993c351e9dc+33a818-vfio_modules_jgg@nvidia.com>
In-Reply-To: <0-v4-7993c351e9dc+33a818-vfio_modules_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0410.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::25) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB7411:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f566430-23f9-4e4e-f2b7-08dad26746f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ziLEkguZXgwGQ8+ITnnaGrZpT4BrdVWcVt+2DAVpyr/3WYKbuLfw92rEpYQdSaBJsLmQm96be44N+bttz77zMARapFU+DoaTw/rPlj9gyT8Egzjlr/n4o3n4JtMENIJZ1DU7gUhXa0XdNF/MHVSgwwbAuUFMSLI82Wr3KErT5R+2n8PnLsW/qthYJzAbxV5GDZ369yo1BwBzVyPdm5fX2G97Q80ign3Wn7pNPq/LkPiQ39DF3Hu/SfrJzvrVwX37go0hcHbwdCYVKfLYwNU5bAGOLCc5Qzpayta6cF1JfS5zT8GdIoyxBYfs3l91wovJl3Ik1r0hJvEMDa+SyeBCxXaBSmFw21ey7enA3iQUZ/9CCVQIRwUbjqDTgAsvp0Lv0I6nFj+OloetLi/i06P8ircGLJPBjfr2w7dvYY03ZEYpNd81HwLSjd8pJtDaBRXlbzha6DkpfG3dGF1EuZYeOwL8lInese8asWXeS4/HKPGiWjWDuubjjkulod3xoaFdCHpUamjKHCLMDW2AZd06JOxlqNfLbN9MkOIzmRfkGJ/B/jv7giMeUdeIXMYQI85m1jXRI9/YKi9MNOdQOx6LNkewcg1YonIYgndCAOZ9xnw2nhfDSX51aHtTMPKQpXxL3LQQN7sN8fuHSNo8oZj+ShkfA2kZIhffq1GJBKvrVFXWEUuB3fuCA3s+O8/i/LZd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(376002)(366004)(39860400002)(136003)(451199015)(6506007)(110136005)(2616005)(316002)(54906003)(6512007)(478600001)(26005)(6486002)(36756003)(186003)(38100700002)(86362001)(6666004)(83380400001)(66946007)(4326008)(8676002)(5660300002)(66556008)(8936002)(66476007)(41300700001)(2906002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WT/hTnLIJJPvsNxyoFumu1Fqa7xv/nZtk3hvqeaFHWIuihUdU0JLtZVRrR2R?=
 =?us-ascii?Q?MLnmLBa1jCJtRnHFKS3NFtrh79fO/HIuxidUrVsTH8zLAk1UmVNqfuAOIcaB?=
 =?us-ascii?Q?+hb2WKIllaR7/ltr0Wr2V793tuNxD/1KlV2phq2+9kk8NOjTBthbuYt9ag84?=
 =?us-ascii?Q?GMSG0cwdzlNVlyZUVT8l9sUeTc9L0pGnuhiliz/dIoZtv9+qhSZz9hVpZLVl?=
 =?us-ascii?Q?iZH39/H0m7WEw58xBnSTkOgJ8oobWox5+4AZXCAjgHH+kOCVGpWkMQINAlm4?=
 =?us-ascii?Q?FiCsXK8uGxg2REX36+wCyChGee4CYEiLeD3iGDiQBFzG7b/xkMHvUOb5hwg8?=
 =?us-ascii?Q?4kRI7DE0HJ6p5mDNrdWO00lWvyq1mlBqyOUpBJDWgF5cBFJmEPEU5l50MuWG?=
 =?us-ascii?Q?AUUzdsh+EwqADheygQfGKffIcpXZ4pQwpjy4tOCW+k8CpjukK2Zmc6QXLRYO?=
 =?us-ascii?Q?ebhh/d1aKaDVYDty0pYu6m5iEgtk1UUXt0IQvCdRbMhRpzD2gyCZHhbmO6Si?=
 =?us-ascii?Q?nHbnr8F0m8zgz7veYdGzRVGhF5bKOekWTbm/sHw5c8/2N9gfJsGvAf/SrBpv?=
 =?us-ascii?Q?UC1r6qSgt4yJQ3ocjK69H7wvUEikqdjk1hiutRShLIfWYoaF+25KytFr1hQo?=
 =?us-ascii?Q?GscTG3iQ1714uTW4sVl0VoW1Jza9dbmj7y/SNFBflgs5oOcHt1FqUrJN5Hvv?=
 =?us-ascii?Q?AHevPpJ41xubvq0tvnLTLvqTt86VD4uBFE60M8HYS8JaJGX/T7P7Hn74pYAk?=
 =?us-ascii?Q?MUAnn0qN6WeHc4/F88DMmqbNWSh+ZJlKUUxx7QqSEMtyA1XmJDmIR0Cv9Z1P?=
 =?us-ascii?Q?k+eMcMqtqjKn7+bvc+R96OotsX7ZvgoIqADlDc1Dkoaipxvh4jvy/YfMIo8v?=
 =?us-ascii?Q?lNYvI3ESKsyPaKwTBAJ7N6MIIQxhJ6LeMgH2SmFMFwzGWQSozT7QyMI+Ch4O?=
 =?us-ascii?Q?YKOKc3C5OyWcnYyY7QsH2Ws46gqJvFqaD8FP0cLJB0CfHO7BcBc6aVLqGZ5x?=
 =?us-ascii?Q?Qd3q5ikHPuQqU0/QlXQ85xVkk97AcCyeZhCf/D+DXB1Rh46I8ZgwlRqsNruG?=
 =?us-ascii?Q?sG5wQVxE5s24B0x6Hf2stQnLqdLtQeV7eq5qMEnullELuAkicDfRx+uBumys?=
 =?us-ascii?Q?BYyKSFBUvq3KKyjlYzFQseHoML2srvI9vR4TE/ZrJldWQ7KPA+1TW0M2CoMF?=
 =?us-ascii?Q?5DPWrFkCmSuU31SDdlRwLTYcDj47F09ySxC6AZNWK1bhVGeX7HbYwUkAdkOF?=
 =?us-ascii?Q?061j0o1uRQPq8nriYplFSM7W2JR8Aq805C7yo80ZY3FHi86tyv0lmaNBYC1D?=
 =?us-ascii?Q?ExK0ySS55TvBHbuvmgo3tSgR5339wb2LWv8sjzElypK/24jJvaiGjjOz7EAl?=
 =?us-ascii?Q?KxE5xnGvF6vofclAG+PR3gFrADlkO6ZJDXmfa3s4OUhPA6zfemvIpOFEsIBo?=
 =?us-ascii?Q?62H7KiRNJqTjP4FyUmRVq//cTmCv2p8jmyzuvwNwx7cS8CEZ8nwSyiRsa/s5?=
 =?us-ascii?Q?2A3qv/dVpmtmSo66kO1qo8m7l9l8EsMn3bpjwcTlLJBmhxEfi7xw/01syhp1?=
 =?us-ascii?Q?bskdLULaRyrCr8v3e0M=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f566430-23f9-4e4e-f2b7-08dad26746f1
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 00:10:24.1322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qp1lP3kFgWdXVNT8LFe3N2lfvtUCFUqNF3WG51SYQjQgs71ACRuzTRW2TeWT111j
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7411
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

