Return-Path: <kvm+bounces-24912-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 820E895CDEE
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 15:32:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A76CE1C23A55
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 13:32:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 545AB187847;
	Fri, 23 Aug 2024 13:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jWWRrfWy"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2041.outbound.protection.outlook.com [40.107.243.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B4B185B5C;
	Fri, 23 Aug 2024 13:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724419895; cv=fail; b=dbSIT3Ya+OnTphclLEjoSFacix+zS1zlosvB/WRv7rJBm742tc8wxpOwA/W9qc+deKdaO2ajUF/pvOU6vkBY2xNHo906c1Xy//jAFb/D4w7UjCKkirwBbiXcjTQK/KIltA7PIzUDHw3PErqHMJjmIEMQ/DLxrJHHWnh5eWCJIiY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724419895; c=relaxed/simple;
	bh=DVYmquRXc6haxg2hb1v/Ott/JyEZRTVcz9NOFh04jOw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c/ZIOpBYH3UgT+7FZTaTR1pdrRUTUFLzvSDoXKHOPFXQKXAWdRynGVkxDAKqSA/OyhBamRxrkPlUeKmlqqTJ/f12WCWkDuw5IDsdDOdTbEJ4DRwdrEp27W1lmvSZahNmTc3F718XZbTbi7szlpLoQ5+XCrvz51iEL6F+4eVRZLw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jWWRrfWy; arc=fail smtp.client-ip=40.107.243.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LYWIbeMjQvqBKkt8ifKv6EGwXyD43juZjfEYumII+1oKhGCOLkznt12CQMY/fc8+lZxdnXXkfG+2Mr0he0uJ7h2Bi+JmojIw4ISCjSzwRGjYZllrZuXI2HYtcm992QueTf4O/An7Beib8t7kufMutWcZCGSnRJaVcpiyy4jwl3gv7Lh+wRVXU0Rore6H6EEyOFwIbhwL1bcFyNDdYwKCqSyG7KeIMgBlR3JbduHEen9Q0+uCIaTFZV+HMJwBZ5lU9VhoY0o4ofscQ880ugPUVLfWGVN5T7hCs1JthDl9w2gTMAi+EohP0qQAJi00LRhbJ/EPl9rG2p9oYYTORBqVcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CfHbBvzcZsUbH+nIjbRE2CVUfaXe64pBFGG/FShb17w=;
 b=XcUxAT7IS4F5noxNY9weMvJzNkI+oc/u6jZqkRmm7OAiqrKM++RyfE7+HNYinfriN8nU1lNRA8CJ3a3heXzaBF0QRB7qBJNtDRyvcM00tzM0Qnw5IXcYA4OtKkItlRf3dCPtljuCu5DP38zOLLEkYfrFIzDb3Lchir2o1mEYUhLRA8FH9SVzbSrtC8JkzwiO2JUAPErBcZoBpjdUcyxddgygtkMgp+wy+ePG5Zr9V8+FLgDgMPTgzkeWCXVD93Kna/puawFiKDPasK7vqdb0vOWCEAIXpbFFN8PaWjEqAE+BZELyhKO1Gx/K7pX+xHQzuOoN9ePJCJgzEtq3ZcVB0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CfHbBvzcZsUbH+nIjbRE2CVUfaXe64pBFGG/FShb17w=;
 b=jWWRrfWyVbAYkRER0R7y09UL/+gaLOrvjyxiuLdLqGSzQyIr8dlpgWPfyUhhSR0E6qLAgv7Y2ExsKu77Kh8UBceRavjx38HT7jsll+zOc4k4E92og03bs4GknY/KNLsu21bRlQzjtu7aRQPGELJhmuGHgJS5BoKdtRc+6YHi2b8=
Received: from PH7PR02CA0026.namprd02.prod.outlook.com (2603:10b6:510:33d::35)
 by DS0PR12MB7559.namprd12.prod.outlook.com (2603:10b6:8:134::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.19; Fri, 23 Aug
 2024 13:31:28 +0000
Received: from CY4PEPF0000EE31.namprd05.prod.outlook.com
 (2603:10b6:510:33d:cafe::ea) by PH7PR02CA0026.outlook.office365.com
 (2603:10b6:510:33d::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21 via Frontend
 Transport; Fri, 23 Aug 2024 13:31:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE31.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7897.11 via Frontend Transport; Fri, 23 Aug 2024 13:31:27 +0000
Received: from aiemdee.2.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 23 Aug
 2024 08:31:22 -0500
From: Alexey Kardashevskiy <aik@amd.com>
To: <kvm@vger.kernel.org>
CC: <iommu@lists.linux.dev>, <linux-coco@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, Dan Williams <dan.j.williams@intel.com>,
	<pratikrajesh.sampat@amd.com>, <michael.day@amd.com>, <david.kaplan@amd.com>,
	<dhaval.giani@amd.com>, Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>, Alexey Kardashevskiy
	<aik@amd.com>
Subject: [RFC PATCH 14/21] RFC: iommu/iommufd/amd: Add IOMMU_HWPT_TRUSTED flag, tweak DTE's DomainID, IOTLB
Date: Fri, 23 Aug 2024 23:21:28 +1000
Message-ID: <20240823132137.336874-15-aik@amd.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240823132137.336874-1-aik@amd.com>
References: <20240823132137.336874-1-aik@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE31:EE_|DS0PR12MB7559:EE_
X-MS-Office365-Filtering-Correlation-Id: b45b41d5-374e-468a-3f58-08dcc377e418
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rz6bnsvP6o4dX4/Q1T9roFohV98RQGpmWs1FXSgAF+pevXEM7UBYeAHKJEZM?=
 =?us-ascii?Q?ZAVzMSmshkncSOWMsJ2+7dOhK38s5dzvRNtnzSoja0h9Fn12qiJuaUcUsnSw?=
 =?us-ascii?Q?GzrSkvw3OqG3pxbEbsnbt/fvLH8diSmYWBNb5YARWm8yL6L/TKCw0a1ygRfF?=
 =?us-ascii?Q?b+ncz5Yi9WE20fWOb9z/ra0QGMI8zlUFi9hiDT0TWYUOHyXZE9cXV18ZBG0i?=
 =?us-ascii?Q?ruAdxlZmfPJBxbieSvy41nyFgtIv7KMxxPNaxqVMsn4JHD+5bnBvuObS706k?=
 =?us-ascii?Q?lUpsXPgSwf1I+fkfwMNnMVGjhlcA1EuYHJM9WI32nZzdzePbxps/7caqqTje?=
 =?us-ascii?Q?gXagvaZXobL2ZrpB+gemmAO1ae07fwZrjhO2uCT/KeEV7wdtqLxo7uhy/T2G?=
 =?us-ascii?Q?ZughE95s1H6VWe1IKEtvEjZpulztTdaw3ygva0FioZyiGpKMwk4BlBguCJvr?=
 =?us-ascii?Q?cTsLdDi+vhyG3aeXNyubXV4173XfR4r0raUcAg2ziZnuUiM/UQ0wQ+f5A0H3?=
 =?us-ascii?Q?YedD6BGtbG/R5Dn1BLnjSEIDzhStGW8f9QfJQFIuz13II5EhJCke0S8kOWzb?=
 =?us-ascii?Q?jk03GgfZi8t2LHlkzC4VOy9scq+lbNOaT8sFiZOJGnizLh4hPh/IFXkIjpQp?=
 =?us-ascii?Q?+riY7Qs4Q6JzyM9aMjrr5EOYfBdcGGrewFXRrXZ61KpkubhqvmURXKAu/Tvv?=
 =?us-ascii?Q?YuWuWYs1wprvwtlszOjAWavK/Pm2w2iWZ9GfHV2YNGNxGI+iB0cSmnqN6tdA?=
 =?us-ascii?Q?qBJoicQ8jIn3bgWdkvPe/5Nvfv1KMKZPCZX9bj6B7TS4eUiszmbnSQKH2fQV?=
 =?us-ascii?Q?GcM2JLcI3e0DIsSk5BUXk4cBi3VtrLJ7sEySIWOACEfLUfOc8m7OLuxIN8uB?=
 =?us-ascii?Q?LY6x4s25HfTRa3iW6gbdA3b1hTTFtn08JlhkQ9NgRB57tllDMCHY+SxnRhwe?=
 =?us-ascii?Q?iHzfdGaOxa12aaCs0RY3dP1rQPk66cWtyAY97CclVPhq9wSvi6vPZZDptx52?=
 =?us-ascii?Q?J7KZjK9LPyL8i960ys01FfFJ2AaKHbCc0PVFw3Gv+23Y6dzoNK5Crnv6bGc1?=
 =?us-ascii?Q?TO9p9LrHAR8MOzzDOSh2yyAnwij5DhQ/xECfNpU2nsHAtDFMcbB/1obaGPqG?=
 =?us-ascii?Q?b4VDPkogXy3kNAu1DnwXRJG6D7THRYW+P30lQ+L5hP2xOdpoLdqhjMzEzlvy?=
 =?us-ascii?Q?tsjPKdZ26J+bKStmxDxAyZxCJ52mJ6Xl+xOeJaT3vuRNMoV05/RzM+qRyeA8?=
 =?us-ascii?Q?dZ7jZ7OFlFCeeJ0AUtkd88B63Gf2vW9r9wFkj4AUSAD88q1S5EYMmWiVhWuY?=
 =?us-ascii?Q?KcLOcdVvZsTeGoW0LcBZ4AEbLlrLH8+bkoBA5/1TBBeIDr/2XqFTCjJzpH91?=
 =?us-ascii?Q?8fgAHVQYdhYb4KT4zN8biieWjWF8TXhoxfm/BA+QvzaRTClhX/fNMd3jbrMy?=
 =?us-ascii?Q?4fzyAH5/elops8tIrS1zcKj033eEvCgF?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2024 13:31:27.3836
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b45b41d5-374e-468a-3f58-08dcc377e418
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE31.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7559

AMD IOMMUs use a device table where one entry (DTE) describes IOMMU
setup per a PCI BDFn. DMA accesses via these DTEs are always
unencrypted.

In order to allow DMA to/from private memory, AMD IOMMUs use another
memory structure called "secure device table" which entries (sDTEs)
are similar to DTE and contain configuration for private DMA operations.
The sDTE table is in the private memory and is managed by the PSP on
behalf of a SNP VM. So the host OS does not have access to it and
does not need to manage it.

However if sDTE is enabled, some fields of a DTE are now marked as
reserved in a DTE and managed by an sDTE instead (such as DomainID),
other fields need to stay in sync (IR/IW).

Mark IOMMU HW page table with a flag saying that the memory is
backed by KVM (effectively MEMFD).

Skip setting the DomainID in DTE. Enable IOTLB enable (bit 96) to
match what the PSP writes to sDTE.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 drivers/iommu/amd/amd_iommu_types.h  |  2 ++
 include/uapi/linux/iommufd.h         |  1 +
 drivers/iommu/amd/iommu.c            | 20 ++++++++++++++++++--
 drivers/iommu/iommufd/hw_pagetable.c |  4 ++++
 4 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index 2b76b5dedc1d..cf435c1f2839 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -588,6 +588,8 @@ struct protection_domain {
 
 	struct mmu_notifier mn;	/* mmu notifier for the SVA domain */
 	struct list_head dev_data_list; /* List of pdom_dev_data */
+
+	u32 flags;
 };
 
 /*
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index 4dde745cfb7e..c5536686b0b1 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -364,6 +364,7 @@ enum iommufd_hwpt_alloc_flags {
 	IOMMU_HWPT_ALLOC_NEST_PARENT = 1 << 0,
 	IOMMU_HWPT_ALLOC_DIRTY_TRACKING = 1 << 1,
 	IOMMU_HWPT_FAULT_ID_VALID = 1 << 2,
+	IOMMU_HWPT_TRUSTED = 1 << 3,
 };
 
 /**
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index b19e8c0f48fa..e2f8fb79ee53 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1930,7 +1930,20 @@ static void set_dte_entry(struct amd_iommu *iommu,
 	}
 
 	flags &= ~DEV_DOMID_MASK;
-	flags |= domid;
+
+	if (dev_data->dev->tdi_enabled && (domain->flags & IOMMU_HWPT_TRUSTED)) {
+		/*
+		 * Do hack for VFIO with TSM enabled.
+		 * This runs when VFIO is being bound to a device and before TDI is bound.
+		 * Ideally TSM should change DTE only when TDI is bound.
+		 * Probably better test for (domain->domain.type & __IOMMU_DOMAIN_DMA_API)
+		 */
+		dev_info(dev_data->dev, "Skip DomainID=%x and set bit96\n", domid);
+		flags |= 1ULL << (96 - 64);
+	} else {
+		//dev_info(dev_data->dev, "Not skip DomainID=%x and not set bit96\n", domid);
+		flags |= domid;
+	}
 
 	old_domid = dev_table[devid].data[1] & DEV_DOMID_MASK;
 	dev_table[devid].data[1]  = flags;
@@ -2413,6 +2426,8 @@ static struct iommu_domain *do_iommu_domain_alloc(unsigned int type,
 
 		if (dirty_tracking)
 			domain->domain.dirty_ops = &amd_dirty_ops;
+
+		domain->flags = flags;
 	}
 
 	return &domain->domain;
@@ -2437,7 +2452,8 @@ amd_iommu_domain_alloc_user(struct device *dev, u32 flags,
 {
 	unsigned int type = IOMMU_DOMAIN_UNMANAGED;
 
-	if ((flags & ~IOMMU_HWPT_ALLOC_DIRTY_TRACKING) || parent || user_data)
+	if ((flags & ~(IOMMU_HWPT_ALLOC_DIRTY_TRACKING | IOMMU_HWPT_TRUSTED)) ||
+	    parent || user_data)
 		return ERR_PTR(-EOPNOTSUPP);
 
 	return do_iommu_domain_alloc(type, dev, flags);
diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
index aefde4443671..23ae95fc95ee 100644
--- a/drivers/iommu/iommufd/hw_pagetable.c
+++ b/drivers/iommu/iommufd/hw_pagetable.c
@@ -136,6 +136,10 @@ iommufd_hwpt_paging_alloc(struct iommufd_ctx *ictx, struct iommufd_ioas *ioas,
 	hwpt_paging->nest_parent = flags & IOMMU_HWPT_ALLOC_NEST_PARENT;
 
 	if (ops->domain_alloc_user) {
+		if (ictx->kvm) {
+			pr_info("Trusted domain");
+			flags |= IOMMU_HWPT_TRUSTED;
+		}
 		hwpt->domain = ops->domain_alloc_user(idev->dev, flags, NULL,
 						      user_data);
 		if (IS_ERR(hwpt->domain)) {
-- 
2.45.2


