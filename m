Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9970B739369
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 01:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbjFUX4t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 19:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbjFUX4R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 19:56:17 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2056.outbound.protection.outlook.com [40.107.100.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31DFD19BF;
        Wed, 21 Jun 2023 16:56:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hk/TJ3InfuZo4HKmP9eFhOS4C8NUIwtG4z3L+jL2cgHBmycYwhnIcMhL1VA7snTNOdHOF6xglK9/lSqfQ8UIKZoV9L09j5l9AporMkPIdoMVCZKpAcgf4/2TB5Wo+dLlrg7mP5QDPFPLFWNl3aNr1nPkP05X82P3Fzx6NLoB2ZC7sZTChbw67zI2NqbjE4P3lnQKDaadR4uYMCTgFmgUEFcaDheG/za8IiYdeCpM8naUPiI5HvvfRJjZWTm2BToZ7kUJVUrH0BmFP0spHFNpjH383GSPCTN3Bdo0cAK5KrD14GHe0OdvdQ/YNUYiWsUDx0KKSn5JzN+cDtOD7c9O1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yz2e1ho/bJYIFckNsG7A9GQvcwB0Nzbs6swFKcCVxkM=;
 b=Ewsq2SPp/5a462qP3iyIXt2hcZ34gc9N90v4PH//4pdPE534POqCvrQC0PcvPEwPKCYzxBw29j0VYp6zcR5vjbJY/M/os3BOcrR3Trct/umqXfT4OHYkQZrdNVj8OhiCvUrU4kTBT/F/paRnVneud8LoEN9Cpkxg5tvKjB90EXUHqJJNYC0LSBKJqMojhqj6UVfFc+tMbLeUtXkebjRIhCeFvOYs9UEvQztCaefMyjfrNoRsx8BCwjlXAFwKq2/TmfCjmhtjYbi0wxXLPSUoC8SUYUQTx48qswtpjtPbsVA3jkXcxk8S+H3tjpJoGVAsIg6iotHe1qFAou8LEGNVCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yz2e1ho/bJYIFckNsG7A9GQvcwB0Nzbs6swFKcCVxkM=;
 b=f0sbbkep96LrVfmXMH7Fane5D2Nzt/5BLpPKPnrOpSECxnFnfw8hfQ3ZRrTfeGcx1Te+slXQnLfQ46JL83SCygpT4IJUEIxk+qmKP18vrooFVW1+ASvDlTpt1hqomSyyLh2+b4p1p9KRK9zG8fJo47DbjpHzys7xO7hyeeodX+U=
Received: from CY5PR15CA0040.namprd15.prod.outlook.com (2603:10b6:930:1b::35)
 by CO6PR12MB5460.namprd12.prod.outlook.com (2603:10b6:5:357::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21; Wed, 21 Jun
 2023 23:55:57 +0000
Received: from CY4PEPF0000E9D4.namprd03.prod.outlook.com
 (2603:10b6:930:1b:cafe::5d) by CY5PR15CA0040.outlook.office365.com
 (2603:10b6:930:1b::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21 via Frontend
 Transport; Wed, 21 Jun 2023 23:55:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9D4.mail.protection.outlook.com (10.167.241.147) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6521.21 via Frontend Transport; Wed, 21 Jun 2023 23:55:57 +0000
Received: from ruby-95f9host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 21 Jun
 2023 18:55:55 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <iommu@lists.linux.dev>,
        <kvm@vger.kernel.org>
CC:     <joro@8bytes.org>, <robin.murphy@arm.com>, <yi.l.liu@intel.com>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <nicolinc@nvidia.com>, <baolu.lu@linux.intel.com>,
        <eric.auger@redhat.com>, <pandoh@google.com>,
        <kumaranand@google.com>, <jon.grimm@amd.com>,
        <santosh.shukla@amd.com>, <vasant.hegde@amd.com>,
        <jay.chen@amd.com>, <joseph.chung@amd.com>,
        "Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>
Subject: [RFC PATCH 14/21] iommu/amd: Initialize vIOMMU private address space regions
Date:   Wed, 21 Jun 2023 18:55:01 -0500
Message-ID: <20230621235508.113949-15-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230621235508.113949-1-suravee.suthikulpanit@amd.com>
References: <20230621235508.113949-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D4:EE_|CO6PR12MB5460:EE_
X-MS-Office365-Filtering-Correlation-Id: ab321304-2be8-4053-eaa2-08db72b30e84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5TmKQVtWa0LJAlYgCx4H2bWbMsyM2AMIZQjuU1nQlbRLTrNXadeKTOp8A/DRrya7CLqtr7P5rT4Ax+Q/pqaItIgGK9t3jaSFTUb3h2894zsGFLFNQ9FdQRGSnhC7kSrtdMP4e/xzfxorlzMU/0cUxoxE7IxmjblbFaXQRm9wUNsD1zNCf8CIm26fHM9cHyta5JyAo6qWyAflcVb6fmkOQhA3pdJ2AVgqEHnReBccfJ0jFAJCVFxk0/5BwjtfUMGlDVZwW1yFTADw3BfVaWztl/MWXmeweb4ilGOZK5vrsx2wg5/t365+nb5hEAsXv86HaOsBG/Ws1O91eZb5/ReBcF5AKmFLT4sKkxZD7fXPTB+QpyyAEiTKt7bO2+Kt5Mv8rhWsgzQe+LRfjBhY9hgH6sMMgJJx278/tcbGBzYkJY8sDyc2Putj4kHtlCC0+lZ7J92GjwaXBO6m9hv5PmYLYvIsISn3cuAHZqdu+D5ZPQl3HxuKnXYdOk2TFNz/2g43dxcg7pn30CWp7ZyhtRiUOeRsEwzPERPusn5NR3MJIjA5vGsltyLvaVo566EreZCsol9uqZHXcx1JCNzxDpQTy5eVS9mU7/KHZLYipnI8agqBdek8Ky0iSoWQplNeKHqG5JV5MUSLWc4FsDcpQWUOSBW2siAlIaFH+oDEQIzZ0DTf2rh2KcifQeqIXHStbwUeew7GcIBQV5LuLW7aPp1t0M+YDg1mvpJVw2QrrFDGT824mKrv6ybmvfAdEoFRLikmawsF4iK54gY1NXwYRp6ryQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(396003)(376002)(346002)(451199021)(36840700001)(46966006)(40470700004)(82310400005)(36860700001)(16526019)(36756003)(356005)(81166007)(7416002)(70206006)(40460700003)(44832011)(5660300002)(41300700001)(8936002)(8676002)(4326008)(70586007)(40480700001)(316002)(86362001)(82740400003)(30864003)(1076003)(47076005)(426003)(2616005)(186003)(2906002)(26005)(336012)(54906003)(6666004)(7696005)(478600001)(110136005)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2023 23:55:57.0267
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ab321304-2be8-4053-eaa2-08db72b30e84
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9D4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5460
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Initialing vIOMMU private address space regions includes parsing
PCI vendor-specific capability (VSC), and use information to
setup vIOMMU private address space regions.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 drivers/iommu/amd/Makefile          |   2 +-
 drivers/iommu/amd/amd_iommu_types.h |  40 +++++
 drivers/iommu/amd/amd_viommu.h      |  57 +++++++
 drivers/iommu/amd/init.c            |   3 +
 drivers/iommu/amd/viommu.c          | 227 ++++++++++++++++++++++++++++
 5 files changed, 328 insertions(+), 1 deletion(-)
 create mode 100644 drivers/iommu/amd/amd_viommu.h
 create mode 100644 drivers/iommu/amd/viommu.c

diff --git a/drivers/iommu/amd/Makefile b/drivers/iommu/amd/Makefile
index 773d8aa00283..89c045716448 100644
--- a/drivers/iommu/amd/Makefile
+++ b/drivers/iommu/amd/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-$(CONFIG_AMD_IOMMU) += iommu.o init.o quirks.o io_pgtable.o io_pgtable_v2.o
+obj-$(CONFIG_AMD_IOMMU) += iommu.o init.o quirks.o io_pgtable.o io_pgtable_v2.o viommu.o
 obj-$(CONFIG_AMD_IOMMU_DEBUGFS) += debugfs.o
 obj-$(CONFIG_AMD_IOMMU_V2) += iommu_v2.o
diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index 019a9182df87..5cb5a709b31b 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -34,6 +34,17 @@
 #define MMIO_RANGE_OFFSET	0x0c
 #define MMIO_MISC_OFFSET	0x10
 
+/* vIOMMU Capability offsets (from IOMMU Capability Header) */
+#define MMIO_VSC_HDR_OFFSET		0x00
+#define MMIO_VSC_INFO_OFFSET		0x00
+#define MMIO_VSC_VF_BAR_LO_OFFSET	0x08
+#define MMIO_VSC_VF_BAR_HI_OFFSET	0x0c
+#define MMIO_VSC_VF_CNTL_BAR_LO_OFFSET	0x10
+#define MMIO_VSC_VF_CNTL_BAR_HI_OFFSET	0x14
+
+#define IOMMU_VSC_INFO_REV(x)	((x >> 16) & 0xFF)
+#define IOMMU_VSC_INFO_ID(x)	(x & 0xFFFF)
+
 /* Masks, shifts and macros to parse the device range capability */
 #define MMIO_RANGE_LD_MASK	0xff000000
 #define MMIO_RANGE_FD_MASK	0x00ff0000
@@ -61,12 +72,15 @@
 #define MMIO_PPR_LOG_OFFSET	0x0038
 #define MMIO_GA_LOG_BASE_OFFSET	0x00e0
 #define MMIO_GA_LOG_TAIL_OFFSET	0x00e8
+#define MMIO_PPRB_LOG_OFFSET	0x00f0
+#define MMIO_EVTB_LOG_OFFSET	0x00f8
 #define MMIO_MSI_ADDR_LO_OFFSET	0x015C
 #define MMIO_MSI_ADDR_HI_OFFSET	0x0160
 #define MMIO_MSI_DATA_OFFSET	0x0164
 #define MMIO_INTCAPXT_EVT_OFFSET	0x0170
 #define MMIO_INTCAPXT_PPR_OFFSET	0x0178
 #define MMIO_INTCAPXT_GALOG_OFFSET	0x0180
+#define MMIO_VIOMMU_STATUS_OFFSET	0x0190
 #define MMIO_EXT_FEATURES2	0x01A0
 #define MMIO_CMD_HEAD_OFFSET	0x2000
 #define MMIO_CMD_TAIL_OFFSET	0x2008
@@ -180,8 +194,16 @@
 #define CONTROL_GAM_EN		25
 #define CONTROL_GALOG_EN	28
 #define CONTROL_GAINT_EN	29
+#define CONTROL_DUALPPRLOG_EN   30
+#define CONTROL_DUALEVTLOG_EN   32
+
+#define CONTROL_PPR_AUTO_RSP_EN 39
+#define CONTROL_BLKSTOPMRK_EN   41
+#define CONTROL_PPR_AUTO_RSP_AON 48
 #define CONTROL_XT_EN		50
 #define CONTROL_INTCAPXT_EN	51
+#define CONTROL_VCMD_EN         52
+#define CONTROL_VIOMMU_EN       53
 #define CONTROL_SNPAVIC_EN	61
 
 #define CTRL_INV_TO_MASK	(7 << CONTROL_INV_TIMEOUT)
@@ -414,6 +436,13 @@
 
 #define DTE_GPT_LEVEL_SHIFT	54
 
+/* vIOMMU bit fields */
+#define DTE_VIOMMU_EN_SHIFT		15
+#define DTE_VIOMMU_GUESTID_SHIFT	16
+#define DTE_VIOMMU_GUESTID_MASK		0xFFFF
+#define DTE_VIOMMU_GDEVICEID_SHIFT	32
+#define DTE_VIOMMU_GUESTID_MASK		0xFFFF
+
 #define GCR3_VALID		0x01ULL
 
 #define IOMMU_PAGE_MASK (((1ULL << 52) - 1) & ~0xfffULL)
@@ -694,6 +723,17 @@ struct amd_iommu {
 	 */
 	u16 cap_ptr;
 
+	/* Vendor-Specific Capability (VSC) pointer. */
+	u16 vsc_offset;
+
+	/* virtual addresses of vIOMMU VF/VF_CNTL BAR */
+	u8 __iomem *vf_base;
+	u8 __iomem *vfctrl_base;
+
+	struct protection_domain *viommu_pdom;
+	void *guest_mmio;
+	void *cmdbuf_dirty_mask;
+
 	/* pci domain of this IOMMU */
 	struct amd_iommu_pci_seg *pci_seg;
 
diff --git a/drivers/iommu/amd/amd_viommu.h b/drivers/iommu/amd/amd_viommu.h
new file mode 100644
index 000000000000..c1dbc2e37eab
--- /dev/null
+++ b/drivers/iommu/amd/amd_viommu.h
@@ -0,0 +1,57 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2023 Advanced Micro Devices, Inc.
+ * Author: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
+ */
+
+#ifndef AMD_VIOMMU_H
+#define AMD_VIOMMU_H
+
+#define VIOMMU_MAX_GUESTID	(1 << 16)
+
+#define VIOMMU_VF_MMIO_ENTRY_SIZE		4096
+#define VIOMMU_VFCTRL_MMIO_ENTRY_SIZE		64
+
+#define VIOMMU_VFCTRL_GUEST_DID_MAP_CONTROL0_OFFSET	0x00
+#define VIOMMU_VFCTRL_GUEST_DID_MAP_CONTROL1_OFFSET	0x08
+#define VIOMMU_VFCTRL_GUEST_MISC_CONTROL_OFFSET		0x10
+
+#define VIOMMU_VFCTRL_GUEST_CMD_CONTROL_OFFSET	0x20
+#define VIOMMU_VFCTRL_GUEST_EVT_CONTROL_OFFSET	0x28
+#define VIOMMU_VFCTRL_GUEST_PPR_CONTROL_OFFSET	0x30
+
+#define VIOMMU_VF_MMIO_BASE(iommu, guestId) \
+	(iommu->vf_base + (guestId * VIOMMU_VF_MMIO_ENTRY_SIZE))
+#define VIOMMU_VFCTRL_MMIO_BASE(iommu, guestId) \
+	(iommu->vfctrl_base + (guestId * VIOMMU_VFCTRL_MMIO_ENTRY_SIZE))
+
+#define VIOMMU_GUEST_MMIO_BASE		0
+#define VIOMMU_GUEST_MMIO_SIZE		(64 * VIOMMU_MAX_GUESTID)
+
+#define VIOMMU_CMDBUF_DIRTY_STATUS_BASE	0x400000ULL
+#define VIOMMU_CMDBUF_DIRTY_STATUS_SIZE	0x2000
+
+#define VIOMMU_DEVID_MAPPING_BASE	0x1000000000ULL
+#define VIOMMU_DEVID_MAPPING_ENTRY_SIZE	(1 << 20)
+
+#define VIOMMU_DOMID_MAPPING_BASE	0x2000000000ULL
+#define VIOMMU_DOMID_MAPPING_ENTRY_SIZE	(1 << 19)
+
+#define VIOMMU_GUEST_CMDBUF_BASE	0x2800000000ULL
+#define VIOMMU_GUEST_CMDBUF_SIZE	(1 << 19)
+
+#define VIOMMU_GUEST_PPR_LOG_BASE	0x3000000000ULL
+#define VIOMMU_GUEST_PPR_LOG_SIZE	(1 << 19)
+
+#define VIOMMU_GUEST_PPR_B_LOG_BASE	0x3800000000ULL
+#define VIOMMU_GUEST_PPR_B_LOG_SIZE	(1 << 19)
+
+#define VIOMMU_GUEST_EVT_LOG_BASE	0x4000000000ULL
+#define VIOMMU_GUEST_EVT_LOG_SIZE	(1 << 19)
+
+#define VIOMMU_GUEST_EVT_B_LOG_BASE	0x4800000000ULL
+#define VIOMMU_GUEST_EVT_B_LOG_SIZE	(1 << 19)
+
+extern int iommu_init_viommu(struct amd_iommu *iommu);
+
+#endif /* AMD_VIOMMU_H */
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 4dd9f09e16c4..48aa71fe76dc 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -34,6 +34,7 @@
 #include <linux/crash_dump.h>
 
 #include "amd_iommu.h"
+#include "amd_viommu.h"
 #include "../irq_remapping.h"
 
 /*
@@ -2068,6 +2069,8 @@ static int __init iommu_init_pci(struct amd_iommu *iommu)
 	if (iommu_feature(iommu, FEATURE_PPR) && alloc_ppr_log(iommu))
 		return -ENOMEM;
 
+	iommu_init_viommu(iommu);
+
 	if (iommu->cap & (1UL << IOMMU_CAP_NPCACHE)) {
 		pr_info("Using strict mode due to virtualization\n");
 		iommu_set_dma_strict();
diff --git a/drivers/iommu/amd/viommu.c b/drivers/iommu/amd/viommu.c
new file mode 100644
index 000000000000..18036d03c747
--- /dev/null
+++ b/drivers/iommu/amd/viommu.c
@@ -0,0 +1,227 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2023 Advanced Micro Devices, Inc.
+ * Author: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
+ */
+
+#define pr_fmt(fmt)     "AMD-Vi: " fmt
+#define dev_fmt(fmt)    pr_fmt(fmt)
+
+#include <linux/iommu.h>
+#include <linux/amd-iommu.h>
+
+#include <linux/fs.h>
+#include <linux/cdev.h>
+#include <linux/ioctl.h>
+#include <linux/iommufd.h>
+#include <linux/mem_encrypt.h>
+#include <uapi/linux/amd_viommu.h>
+
+#include <asm/iommu.h>
+#include <asm/set_memory.h>
+
+#include "amd_iommu.h"
+#include "amd_iommu_types.h"
+#include "amd_viommu.h"
+
+#define GET_CTRL_BITS(reg, bit, msk)	(((reg) >> (bit)) & (ULL(msk)))
+#define SET_CTRL_BITS(reg, bit1, bit2, msk) \
+	((((reg) >> (bit1)) & (ULL(msk))) << (bit2))
+
+LIST_HEAD(viommu_devid_map);
+
+struct amd_iommu *get_amd_iommu_from_devid(u16 devid)
+{
+	struct amd_iommu *iommu;
+
+	for_each_iommu(iommu)
+		if (iommu->devid == devid)
+			return iommu;
+	return NULL;
+}
+
+static void viommu_enable(struct amd_iommu *iommu)
+{
+	if (!amd_iommu_viommu)
+		return;
+	iommu_feature_enable(iommu, CONTROL_VCMD_EN);
+	iommu_feature_enable(iommu, CONTROL_VIOMMU_EN);
+}
+
+static int viommu_init_pci_vsc(struct amd_iommu *iommu)
+{
+	iommu->vsc_offset = pci_find_capability(iommu->dev, PCI_CAP_ID_VNDR);
+	if (!iommu->vsc_offset)
+		return -ENODEV;
+
+	DUMP_printk("device:%s, vsc offset:%04x\n",
+		    pci_name(iommu->dev), iommu->vsc_offset);
+	return 0;
+}
+
+static int __init viommu_vf_vfcntl_init(struct amd_iommu *iommu)
+{
+	u32 lo, hi;
+	u64 vf_phys, vf_cntl_phys;
+
+	/* Setting up VF and VF_CNTL MMIOs */
+	pci_read_config_dword(iommu->dev, iommu->vsc_offset + MMIO_VSC_VF_BAR_LO_OFFSET, &lo);
+	pci_read_config_dword(iommu->dev, iommu->vsc_offset + MMIO_VSC_VF_BAR_HI_OFFSET, &hi);
+	vf_phys = hi;
+	vf_phys = (vf_phys << 32) | lo;
+	if (!(vf_phys & 1)) {
+		pr_err(FW_BUG "vf_phys disabled\n");
+		return -EINVAL;
+	}
+
+	pci_read_config_dword(iommu->dev, iommu->vsc_offset + MMIO_VSC_VF_CNTL_BAR_LO_OFFSET, &lo);
+	pci_read_config_dword(iommu->dev, iommu->vsc_offset + MMIO_VSC_VF_CNTL_BAR_HI_OFFSET, &hi);
+	vf_cntl_phys = hi;
+	vf_cntl_phys = (vf_cntl_phys << 32) | lo;
+	if (!(vf_cntl_phys & 1)) {
+		pr_err(FW_BUG "vf_cntl_phys disabled\n");
+		return -EINVAL;
+	}
+
+	if (!vf_phys || !vf_cntl_phys) {
+		pr_err(FW_BUG "AMD-Vi: Unassigned VF resources.\n");
+		return -ENOMEM;
+	}
+
+	/* Mapping 256MB of VF and 4MB of VF_CNTL BARs */
+	vf_phys &= ~1ULL;
+	iommu->vf_base = iommu_map_mmio_space(vf_phys, 0x10000000);
+	if (!iommu->vf_base) {
+		pr_err("Can't reserve vf_base\n");
+		return -ENOMEM;
+	}
+
+	vf_cntl_phys &= ~1ULL;
+	iommu->vfctrl_base = iommu_map_mmio_space(vf_cntl_phys, 0x400000);
+
+	if (!iommu->vfctrl_base) {
+		pr_err("Can't reserve vfctrl_base\n");
+		return -ENOMEM;
+	}
+
+	pr_debug("%s: IOMMU device:%s, vf_base:%#llx, vfctrl_base:%#llx\n",
+		 __func__, pci_name(iommu->dev), vf_phys, vf_cntl_phys);
+	return 0;
+}
+
+static void *alloc_private_region(struct amd_iommu *iommu,
+				  u64 base, size_t size)
+{
+	int ret;
+	void *region;
+
+	region  = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
+						get_order(size));
+	if (!region)
+		return NULL;
+
+	ret = set_memory_uc((unsigned long)region, size >> PAGE_SHIFT);
+	if (ret)
+		goto err_out;
+
+	if (amd_iommu_v1_map_pages(&iommu->viommu_pdom->iop.iop.ops, base,
+				   iommu_virt_to_phys(region), PAGE_SIZE, (size / PAGE_SIZE),
+				   IOMMU_PROT_IR | IOMMU_PROT_IW, GFP_KERNEL, NULL))
+		goto err_out;
+
+	pr_debug("%s: base=%#llx, size=%#lx\n", __func__, base, size);
+
+	return region;
+
+err_out:
+	free_pages((unsigned long)region, get_order(size));
+	return NULL;
+}
+
+static int viommu_private_space_init(struct amd_iommu *iommu)
+{
+	u64 pte_root = 0;
+	struct iommu_domain *dom;
+	struct protection_domain *pdom;
+
+	/*
+	 * Setup page table root pointer, Guest MMIO and
+	 * Cmdbuf Dirty Status regions.
+	 */
+	dom = amd_iommu_domain_alloc(IOMMU_DOMAIN_UNMANAGED);
+	if (!dom)
+		goto err_out;
+
+	pdom = to_pdomain(dom);
+	iommu->viommu_pdom = pdom;
+	set_dte_entry(iommu, iommu->devid, pdom, NULL, pdom->gcr3_tbl,
+		      false, false);
+
+	iommu->guest_mmio = alloc_private_region(iommu,
+						 VIOMMU_GUEST_MMIO_BASE,
+						 VIOMMU_GUEST_MMIO_SIZE);
+	if (!iommu->guest_mmio)
+		goto err_out;
+
+	iommu->cmdbuf_dirty_mask = alloc_private_region(iommu,
+							VIOMMU_CMDBUF_DIRTY_STATUS_BASE,
+							VIOMMU_CMDBUF_DIRTY_STATUS_SIZE);
+	if (!iommu->cmdbuf_dirty_mask)
+		goto err_out;
+
+	pte_root = iommu_virt_to_phys(pdom->iop.root);
+	pr_debug("%s: devid=%#x, pte_root=%#llx(%#llx), guest_mmio=%#llx(%#llx), cmdbuf_dirty_mask=%#llx(%#llx)\n",
+		 __func__, iommu->devid, (unsigned long long)pdom->iop.root, pte_root,
+		 (unsigned long long)iommu->guest_mmio, iommu_virt_to_phys(iommu->guest_mmio),
+		 (unsigned long long)iommu->cmdbuf_dirty_mask,
+		 iommu_virt_to_phys(iommu->cmdbuf_dirty_mask));
+
+	return 0;
+err_out:
+	if (iommu->guest_mmio)
+		free_pages((unsigned long)iommu->guest_mmio, get_order(VIOMMU_GUEST_MMIO_SIZE));
+
+	if (dom)
+		amd_iommu_domain_free(dom);
+	return -ENOMEM;
+}
+
+/*
+ * When IOMMU Virtualization is enabled, host software must:
+ *	- allocate system memory for IOMMU private space
+ *	- program IOMMU as an I/O device in Device Table
+ *	- maintain the I/O page table for IOMMU private addressing to SPA translations.
+ *	- specify the base address of the IOMMU Virtual Function MMIO and
+ *	  IOMMU Virtual Function Control MMIO region.
+ *	- enable Guest Virtual APIC enable (MMIO Offset 0x18[GAEn]).
+ */
+int __init iommu_init_viommu(struct amd_iommu *iommu)
+{
+	int ret = -EINVAL;
+
+	if (!amd_iommu_viommu)
+		return 0;
+
+	if (!iommu_feature(iommu, FEATURE_VIOMMU))
+		goto err_out;
+
+	ret = viommu_init_pci_vsc(iommu);
+	if (ret)
+		goto err_out;
+
+	ret = viommu_vf_vfcntl_init(iommu);
+	if (ret)
+		goto err_out;
+
+	ret = viommu_private_space_init(iommu);
+	if (ret)
+		goto err_out;
+
+	viommu_enable(iommu);
+
+	return ret;
+
+err_out:
+	amd_iommu_viommu = false;
+	return ret;
+}
-- 
2.34.1

