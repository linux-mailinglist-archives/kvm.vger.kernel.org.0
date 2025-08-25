Return-Path: <kvm+bounces-55687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89149B34E52
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 23:47:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B05D5E07CD
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 21:46:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5135929C328;
	Mon, 25 Aug 2025 21:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hDwzQNyz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2052.outbound.protection.outlook.com [40.107.243.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40B3288C26;
	Mon, 25 Aug 2025 21:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756158398; cv=fail; b=NLxb5dK72dGyhIGg66Kwhho7SD+ejfM+mKsxj8OcJgyra5xOXi22jzg3r+QQ9jJposUbO1bRFYhTOOBNGTk+CKia7iGRar43fILsow730oAcBq6rp7JBL41AWaYaRpPBpgai1LxAfB7X5oWI9tBTqLJr5QFnX35+jW2Xws9yIbE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756158398; c=relaxed/simple;
	bh=bHTnjLgJwnSVpHACnPUyzM9leMeLGB6DQmbQfUxz5NM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jQdxf0r2WEJXAH/q1pHYWmOiZrZ2jC7KeR2VMPP8Go3zp06B6IAdgpKnyHnCcV2lfM6Yn+nipS3/SfEpz9yL3oWrHc3I0Z3fhzVP4eLRdZ7io0RPp/N2uQOA8kW21Bze3esPZttgpROOp3YvW0CrpRBFBQVjdUQB3N60MNbOURI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hDwzQNyz; arc=fail smtp.client-ip=40.107.243.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B3trDpgG8qHnHSwqZUW2qEwYXZl1q+xqzX2PUHqKlzZxZAK7UyG1TXf2SmA3CiN8D6FGuHeAMjqHejLDwHMtXhWzK3+kGsnguRFloYngdw+kFoBqsSoBBPoAJLxg6C4+m6B9VchLbTRvEfIsbxgKCt0o9QasOAYGyQ0ON7C/N4DGkZ14OvBqK7zA+wpKfDp1XVWNPsSkoOPxHTlJJ8MTTP+0AscU4a5s4LEipYF5eP2FwayQT9RyvrLevubRBRrltImi6V+ZDI6R/k13WxAvoN4gnbeIGFFQ9QCXyZUMwbDU2YVMjqarbsjm7wb2GXE1YnKpTwkgtTopE+jrKb3MHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JDT0qSd83Go8IFarCvYaLWg58sO9pNlCZ3p7itu2sE8=;
 b=ZBavJfKMqlipIDtrGcYL2h1ZZyDo2i6Af1NDUvREvnvXU+d3otLgmvz3dQjdgjysd/Vqb5IOYMqow89aiI6u81XrB7NrV6Hynikj3btZUi2FB2cQSEVY8U3cnG8tKpqrEB9fo4IViIl8xC2BeUYxPzoD2QmlsiYa/D0/1xtwRyYHqSlOu3RPBRzQusE5ZitNldsBhUag8tgoUR+uYxMo/af4eukDn3y7E7KOUTD2cwIpXuISHYYybXkgrqK+EsOiKh0Bf7/6D2l3eGngRU7kvgr4ZMPbPfBrZ0WWc7sHlU6qWd6WWlqHbJH/RbZqJSjmlbZ9TMvLafO6RFw7MmRMRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=8bytes.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JDT0qSd83Go8IFarCvYaLWg58sO9pNlCZ3p7itu2sE8=;
 b=hDwzQNyzUw9XUuQBBtR+aCaiGqUnwhyJ2uWaJXwsJ7FCfRf24zVn+aoz50wTvu9YjXajEskT86eWSxLm/o3YVijPOgkUBy67Kjs3uiIBiSsE2yydOUd6D+O1rGaQIPPemj3uU+scKFHLV3J4zJqiO608KiMoMXHJqLBAF5P7YRA=
Received: from BL1PR13CA0020.namprd13.prod.outlook.com (2603:10b6:208:256::25)
 by DS4PR12MB9561.namprd12.prod.outlook.com (2603:10b6:8:282::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.19; Mon, 25 Aug
 2025 21:46:30 +0000
Received: from BN3PEPF0000B371.namprd21.prod.outlook.com
 (2603:10b6:208:256:cafe::84) by BL1PR13CA0020.outlook.office365.com
 (2603:10b6:208:256::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.12 via Frontend Transport; Mon,
 25 Aug 2025 21:46:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B371.mail.protection.outlook.com (10.167.243.168) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.0 via Frontend Transport; Mon, 25 Aug 2025 21:46:29 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 25 Aug
 2025 16:46:28 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <joro@8bytes.org>, <suravee.suthikulpanit@amd.com>,
	<thomas.lendacky@amd.com>, <Sairaj.ArunKodilkar@amd.com>,
	<Vasant.Hegde@amd.com>, <herbert@gondor.apana.org.au>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <will@kernel.org>,
	<robin.murphy@arm.com>, <john.allen@amd.com>, <davem@davemloft.net>,
	<michael.roth@amd.com>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<kvm@vger.kernel.org>
Subject: [PATCH v6 2/4] iommu/amd: Reuse device table for kdump
Date: Mon, 25 Aug 2025 21:46:15 +0000
Message-ID: <3a31036fb2f7323e6b1a1a1921ac777e9f7bdddc.1756157913.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1756157913.git.ashish.kalra@amd.com>
References: <cover.1756157913.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B371:EE_|DS4PR12MB9561:EE_
X-MS-Office365-Filtering-Correlation-Id: 489a995a-421d-4ee3-7184-08dde420d968
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KSJPjO8OSDPkUlWFiqk8aZNGY4ERSeGaINqGfjN/gbLpIH8gY6JW7QWaS0D5?=
 =?us-ascii?Q?iiWum0NYdzRBLINY+GOOfsJ23pGw0IKw0kKcP+8wpeLIbccZ/xhDW3ttWFEw?=
 =?us-ascii?Q?aWIh6dDNNyRnfEGQ/T+Uh9k5HxwEMUFOUY8Cz8RzxLmwJyifUoxRbadl+N6U?=
 =?us-ascii?Q?Mw3UogPAF73HrHLXLTvY8+ivdFTO5ag7RkyQMJJXEthgamoboEeT+I38xwC2?=
 =?us-ascii?Q?oteQ/EQPO3xAB6buiVmmCtS0DYXX+ca7ORfTkopCJ4QuI5i6+n7mrPijGspo?=
 =?us-ascii?Q?5vJrQejuJ/vW/qV+WVyVFQZXQ+CkAT+OrLb4IjE76FrpuRhmBl7jBFzWedly?=
 =?us-ascii?Q?t4Wb6aqdUZFAivOOWyG4zvUpLMDCCJrE46vsKSu4iRMpX2xgQH/Vjgq56ILT?=
 =?us-ascii?Q?FYKoPnTzZjjrQ0FmN3ddhK4iTotwxg82O8yPZ/mWLRnZBSzy6DJ15P3hu/Ld?=
 =?us-ascii?Q?HfSe7dx32RvgOIZUBrZ/YGxJy0ceI+qdxHrboivig828Rq4D1Sf/6Rc5Syax?=
 =?us-ascii?Q?XXA82wueCB4QsZOlHyMQpey1ug2XpibOzdu6G8FX/o4ZGAg8dOb30dN7rvFk?=
 =?us-ascii?Q?TIdTBJ5BgOTMb0FDTZ4ZsYLXafK0T54SC0B+CNRSJYZ5W6w5f8Jfw3CFm1Xe?=
 =?us-ascii?Q?p8Vwt9eTmqY+NhOKdc/P43smmdB3PGAWjC9lRf+0VDsCkXKQFcaQtnEqmrFU?=
 =?us-ascii?Q?g4nsLOD/lWq6llZ1zDteRhsWO/BgXIam9yyhNk7sQUYuwU0cgfY9pXY8toeO?=
 =?us-ascii?Q?7ra59LqVh0ruxuSSjEwFIMwzS7R28H783MwGN0kON0BEqPTt/J3q2NHoNT2g?=
 =?us-ascii?Q?lrLwfBYi5cLI/ZVMQpxtHlRAD++vZYyEuxkrzrF27HCNZYSiAMIDo4WpdDEP?=
 =?us-ascii?Q?oX/Ran6ozspR8T+Kz6RavGGZjbPR0csn95eeUEN3jdTSL20+JJgRcLX39MMU?=
 =?us-ascii?Q?iPD/Wha/j8whV47tn7esJVa8YINALAg0yd9R2JRscNIyg9oFVXq3yYfaOLWD?=
 =?us-ascii?Q?aC2DvtuiPbAwLZMRq0sAUBgzSeaRD0cgMUs43IYkMKzXCIZWlLY1MTL6lvJS?=
 =?us-ascii?Q?pZoUSwECEkrc/SaS9sPGYNPRULKLHX473nM/T35Jmga5xw2MAwNxL758/Rj5?=
 =?us-ascii?Q?OFfWyLk3lMd3K5OgcZyvgBi3vFvUyHQ826ZKHteiOfKkj2Oy7IT3rZd9FEur?=
 =?us-ascii?Q?P3S9DEQpRKzu6Hh39ToLI9oPHXjrhcK0k7AyohVaixeg9FmNKovMS4tdCW5D?=
 =?us-ascii?Q?xaqB0LT5wpliuxiqQxc9FuPobt5pqIQfjCwWzCaIMS/RtPduS3q/giEqtsjv?=
 =?us-ascii?Q?n4QlhU5YqHCT/zMJR2YenjzBekSBwO6uqrmgRkO3MflEbWxdFxMVF+TwsAig?=
 =?us-ascii?Q?wPCrUzaTM/puJtls+GKC1Ei8NBk63KOrzxQISsbCG0NPUTB6z1UKbIJnmffG?=
 =?us-ascii?Q?0Pg9g0jMpphxow4yvsYYxWRuHeOBntfN7gZKMxyV1H07+kS/t/oQdA2S1ex8?=
 =?us-ascii?Q?7Bj+tcvCQ78W05kU4pkK0hFLRQHbE4bZc0AG?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 21:46:29.3638
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 489a995a-421d-4ee3-7184-08dde420d968
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B371.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9561

From: Ashish Kalra <ashish.kalra@amd.com>

After a panic if SNP is enabled in the previous kernel then the kdump
kernel boots with IOMMU SNP enforcement still enabled.

IOMMU device table register is locked and exclusive to the previous
kernel. Attempts to copy old device table from the previous kernel
fails in kdump kernel as hardware ignores writes to the locked device
table base address register as per AMD IOMMU spec Section 2.12.2.1.

This causes the IOMMU driver (OS) and the hardware to reference
different memory locations. As a result, the IOMMU hardware cannot
process the command which results in repeated "Completion-Wait loop
timed out" errors and a second kernel panic: "Kernel panic - not
syncing: timer doesn't work through Interrupt-remapped IO-APIC".

Reuse device table instead of copying device table in case of kdump
boot and remove all copying device table code.

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/iommu/amd/init.c | 104 +++++++++++++--------------------------
 1 file changed, 34 insertions(+), 70 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 5b8e9d6befa5..dac6282675da 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -406,6 +406,9 @@ static void iommu_set_device_table(struct amd_iommu *iommu)
 
 	BUG_ON(iommu->mmio_base == NULL);
 
+	if (is_kdump_kernel())
+		return;
+
 	entry = iommu_virt_to_phys(dev_table);
 	entry |= (dev_table_size >> 12) - 1;
 	memcpy_toio(iommu->mmio_base + MMIO_DEV_TABLE_OFFSET,
@@ -646,7 +649,10 @@ static inline int __init alloc_dev_table(struct amd_iommu_pci_seg *pci_seg)
 
 static inline void free_dev_table(struct amd_iommu_pci_seg *pci_seg)
 {
-	iommu_free_pages(pci_seg->dev_table);
+	if (is_kdump_kernel())
+		memunmap((void *)pci_seg->dev_table);
+	else
+		iommu_free_pages(pci_seg->dev_table);
 	pci_seg->dev_table = NULL;
 }
 
@@ -1117,15 +1123,12 @@ static void set_dte_bit(struct dev_table_entry *dte, u8 bit)
 	dte->data[i] |= (1UL << _bit);
 }
 
-static bool __copy_device_table(struct amd_iommu *iommu)
+static bool __reuse_device_table(struct amd_iommu *iommu)
 {
-	u64 int_ctl, int_tab_len, entry = 0;
 	struct amd_iommu_pci_seg *pci_seg = iommu->pci_seg;
-	struct dev_table_entry *old_devtb = NULL;
-	u32 lo, hi, devid, old_devtb_size;
+	u32 lo, hi, old_devtb_size;
 	phys_addr_t old_devtb_phys;
-	u16 dom_id, dte_v, irq_v;
-	u64 tmp;
+	u64 entry;
 
 	/* Each IOMMU use separate device table with the same size */
 	lo = readl(iommu->mmio_base + MMIO_DEV_TABLE_OFFSET);
@@ -1150,66 +1153,20 @@ static bool __copy_device_table(struct amd_iommu *iommu)
 		pr_err("The address of old device table is above 4G, not trustworthy!\n");
 		return false;
 	}
-	old_devtb = (cc_platform_has(CC_ATTR_HOST_MEM_ENCRYPT) && is_kdump_kernel())
-		    ? (__force void *)ioremap_encrypted(old_devtb_phys,
-							pci_seg->dev_table_size)
-		    : memremap(old_devtb_phys, pci_seg->dev_table_size, MEMREMAP_WB);
-
-	if (!old_devtb)
-		return false;
 
-	pci_seg->old_dev_tbl_cpy = iommu_alloc_pages_sz(
-		GFP_KERNEL | GFP_DMA32, pci_seg->dev_table_size);
+	/*
+	 * Re-use the previous kernel's device table for kdump.
+	 */
+	pci_seg->old_dev_tbl_cpy = iommu_memremap(old_devtb_phys, pci_seg->dev_table_size);
 	if (pci_seg->old_dev_tbl_cpy == NULL) {
-		pr_err("Failed to allocate memory for copying old device table!\n");
-		memunmap(old_devtb);
+		pr_err("Failed to remap memory for reusing old device table!\n");
 		return false;
 	}
 
-	for (devid = 0; devid <= pci_seg->last_bdf; ++devid) {
-		pci_seg->old_dev_tbl_cpy[devid] = old_devtb[devid];
-		dom_id = old_devtb[devid].data[1] & DEV_DOMID_MASK;
-		dte_v = old_devtb[devid].data[0] & DTE_FLAG_V;
-
-		if (dte_v && dom_id) {
-			pci_seg->old_dev_tbl_cpy[devid].data[0] = old_devtb[devid].data[0];
-			pci_seg->old_dev_tbl_cpy[devid].data[1] = old_devtb[devid].data[1];
-			/* Reserve the Domain IDs used by previous kernel */
-			if (ida_alloc_range(&pdom_ids, dom_id, dom_id, GFP_ATOMIC) != dom_id) {
-				pr_err("Failed to reserve domain ID 0x%x\n", dom_id);
-				memunmap(old_devtb);
-				return false;
-			}
-			/* If gcr3 table existed, mask it out */
-			if (old_devtb[devid].data[0] & DTE_FLAG_GV) {
-				tmp = (DTE_GCR3_30_15 | DTE_GCR3_51_31);
-				pci_seg->old_dev_tbl_cpy[devid].data[1] &= ~tmp;
-				tmp = (DTE_GCR3_14_12 | DTE_FLAG_GV);
-				pci_seg->old_dev_tbl_cpy[devid].data[0] &= ~tmp;
-			}
-		}
-
-		irq_v = old_devtb[devid].data[2] & DTE_IRQ_REMAP_ENABLE;
-		int_ctl = old_devtb[devid].data[2] & DTE_IRQ_REMAP_INTCTL_MASK;
-		int_tab_len = old_devtb[devid].data[2] & DTE_INTTABLEN_MASK;
-		if (irq_v && (int_ctl || int_tab_len)) {
-			if ((int_ctl != DTE_IRQ_REMAP_INTCTL) ||
-			    (int_tab_len != DTE_INTTABLEN_512 &&
-			     int_tab_len != DTE_INTTABLEN_2K)) {
-				pr_err("Wrong old irq remapping flag: %#x\n", devid);
-				memunmap(old_devtb);
-				return false;
-			}
-
-			pci_seg->old_dev_tbl_cpy[devid].data[2] = old_devtb[devid].data[2];
-		}
-	}
-	memunmap(old_devtb);
-
 	return true;
 }
 
-static bool copy_device_table(void)
+static bool reuse_device_table(void)
 {
 	struct amd_iommu *iommu;
 	struct amd_iommu_pci_seg *pci_seg;
@@ -1217,17 +1174,17 @@ static bool copy_device_table(void)
 	if (!amd_iommu_pre_enabled)
 		return false;
 
-	pr_warn("Translation is already enabled - trying to copy translation structures\n");
+	pr_warn("Translation is already enabled - trying to reuse translation structures\n");
 
 	/*
 	 * All IOMMUs within PCI segment shares common device table.
-	 * Hence copy device table only once per PCI segment.
+	 * Hence reuse device table only once per PCI segment.
 	 */
 	for_each_pci_segment(pci_seg) {
 		for_each_iommu(iommu) {
 			if (pci_seg->id != iommu->pci_seg->id)
 				continue;
-			if (!__copy_device_table(iommu))
+			if (!__reuse_device_table(iommu))
 				return false;
 			break;
 		}
@@ -2906,8 +2863,8 @@ static void early_enable_iommu(struct amd_iommu *iommu)
  * This function finally enables all IOMMUs found in the system after
  * they have been initialized.
  *
- * Or if in kdump kernel and IOMMUs are all pre-enabled, try to copy
- * the old content of device table entries. Not this case or copy failed,
+ * Or if in kdump kernel and IOMMUs are all pre-enabled, try to reuse
+ * the old content of device table entries. Not this case or reuse failed,
  * just continue as normal kernel does.
  */
 static void early_enable_iommus(void)
@@ -2915,18 +2872,25 @@ static void early_enable_iommus(void)
 	struct amd_iommu *iommu;
 	struct amd_iommu_pci_seg *pci_seg;
 
-	if (!copy_device_table()) {
+	if (!reuse_device_table()) {
 		/*
-		 * If come here because of failure in copying device table from old
+		 * If come here because of failure in reusing device table from old
 		 * kernel with all IOMMUs enabled, print error message and try to
 		 * free allocated old_dev_tbl_cpy.
 		 */
-		if (amd_iommu_pre_enabled)
-			pr_err("Failed to copy DEV table from previous kernel.\n");
+		if (amd_iommu_pre_enabled) {
+			pr_err("Failed to reuse DEV table from previous kernel.\n");
+			/*
+			 * Bail out early if unable to remap/reuse DEV table from
+			 * previous kernel if SNP enabled as IOMMU commands will
+			 * time out without DEV table and cause kdump boot panic.
+			 */
+			BUG_ON(check_feature(FEATURE_SNP));
+		}
 
 		for_each_pci_segment(pci_seg) {
 			if (pci_seg->old_dev_tbl_cpy != NULL) {
-				iommu_free_pages(pci_seg->old_dev_tbl_cpy);
+				memunmap((void *)pci_seg->old_dev_tbl_cpy);
 				pci_seg->old_dev_tbl_cpy = NULL;
 			}
 		}
@@ -2936,7 +2900,7 @@ static void early_enable_iommus(void)
 			early_enable_iommu(iommu);
 		}
 	} else {
-		pr_info("Copied DEV table from previous kernel.\n");
+		pr_info("Reused DEV table from previous kernel.\n");
 
 		for_each_pci_segment(pci_seg) {
 			iommu_free_pages(pci_seg->dev_table);
-- 
2.34.1


