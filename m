Return-Path: <kvm+bounces-52539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97E2CB066CD
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 21:27:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE9333A5643
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 19:27:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53ACD2BEFEF;
	Tue, 15 Jul 2025 19:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QOhcMPGJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2078.outbound.protection.outlook.com [40.107.101.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C9826E6F9;
	Tue, 15 Jul 2025 19:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752607645; cv=fail; b=YfQoS84K/fGE4aZOW+dXc6mly/FrC9R6Q6/eSlyIehModQwSfsME9gVhQMC6Dfa5PGIdMFRallRXnFi96Nt5LViB8wlSFkavYJD7FhqWvDFPfGtxFxojsbGbntCJM80KcOAut67k/MT1qvJ1hPU1YoG51IO9+f6TLrCxAR9rPX4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752607645; c=relaxed/simple;
	bh=RsLsMBfT3oFtSQPVaOY83qAm5tohUg50yrPM4/5mepE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pKk1sJmcInaEx2fxP8hD14CUsBzmnIZkQh8pSTPwvPubYxjRwIELHSIsQjpoOAUfsm5+gUkBzWBJ9EpcU2C4O/rL09FE90ZNbbWIkeQqjiadpCxHzC3J1maen5JyTQyRsUnfcMPuH2hm0Lu1ij1E/MdIioxNUF4agBhJ8xX+PtU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QOhcMPGJ; arc=fail smtp.client-ip=40.107.101.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eWG5TuMxpVph+KMW+gcs4adL5myAqp0dgDhPStgc4f7wNcCH+MWBu2o4LhxNY6kTYexzQa2QPo28fCzCS8nGYPpZH7yZXQ8eSYly3V1HlSm4gDtS0s8OdgiR4GHO0G+87CpqDr4GOWBBp6dXcVEzSWNO6HK/Dp/n0ogYhzzKFOUsaKCFooXsu03KmBivX9MOgsKxFs9CcltYkt1hhkWL08kliTQQADWlL7uTAJB0i8Qc1rODXgym3p4IvdnJcSS7kWZVAZSQYxBd2P8NtrQriE8VMQIN6pX5p17MBBJd66iLIitLU5D4Yy6Uzia0UyrJdW+rgET4byYmh5d7pH5cCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LOmz/Qfnesm1R+qGj0SuSYM+CAJKsBOxrpgII8SeKy4=;
 b=gac+mjQOoAyTiwJV94wzpCVPzVuvjIpOs2WuLnUjl1OqOI6LlqPK+iKS2Kq6VCZ9g4qYXAirF0s2aW0pcPbyuE2TP/iW9nzE1S+AV6WqPdNWLkXBGAhoeRzsEuq77Y9kke+Ga4sKLfZT6gN6mqG6zM8jFenI0t9CcHM3w706S8s0+LUjTIx6/u5apaQ7oyk6OVQECUc4cH4M5NUUJF19kUCSISWytZP5XgWjMiTWHHTjMwY3BTYmJN5QEbmr0nNNtF1wXZf7Q69kEAxxR91WJ3NGqNHVj0CHNdzSRMACE6guJ8hZkDkEcSSKOEbkxOCLKL+GwgZwhmc8uLHmXmTiKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=8bytes.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LOmz/Qfnesm1R+qGj0SuSYM+CAJKsBOxrpgII8SeKy4=;
 b=QOhcMPGJyGvLUhCUkQLpDSfEG8kkxxx5O7wwa6nxQ5SB9GJ/Q/rwjXDxszc7JJ8rcMkLzBe+EBjuZf17WnM4GZ/BoqWlPBpE+Z6mkgPOnndCxzxThThuBoOT04yZ1V8Z/TF0Pp6+9RjJnCrFVosyZqL2WdqokqaooflLOBxQL6s=
Received: from SJ0PR03CA0375.namprd03.prod.outlook.com (2603:10b6:a03:3a1::20)
 by CH3PR12MB8459.namprd12.prod.outlook.com (2603:10b6:610:139::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.35; Tue, 15 Jul
 2025 19:27:21 +0000
Received: from SJ1PEPF00001CEB.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1:cafe::83) by SJ0PR03CA0375.outlook.office365.com
 (2603:10b6:a03:3a1::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.17 via Frontend Transport; Tue,
 15 Jul 2025 19:27:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CEB.mail.protection.outlook.com (10.167.242.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8922.22 via Frontend Transport; Tue, 15 Jul 2025 19:27:20 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 15 Jul
 2025 14:27:19 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <joro@8bytes.org>, <suravee.suthikulpanit@amd.com>,
	<thomas.lendacky@amd.com>, <Sairaj.ArunKodilkar@amd.com>,
	<Vasant.Hegde@amd.com>, <herbert@gondor.apana.org.au>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <will@kernel.org>,
	<robin.murphy@arm.com>, <john.allen@amd.com>, <davem@davemloft.net>,
	<bp@alien8.de>, <michael.roth@amd.com>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<kvm@vger.kernel.org>
Subject: [PATCH v3 2/4] iommu/amd: Reuse device table for kdump
Date: Tue, 15 Jul 2025 19:27:05 +0000
Message-ID: <42842f0455c1439327aaa593ef22576ef97c16ee.1752605725.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1752605725.git.ashish.kalra@amd.com>
References: <cover.1752605725.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CEB:EE_|CH3PR12MB8459:EE_
X-MS-Office365-Filtering-Correlation-Id: f503860a-3b6b-4b16-d88a-08ddc3d59e8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fsjWKTiQ0WFGy58pmy9y6JXB5gA5ZIQ0kQjEN3kYWjw2FdH+DsOk7bcPiS3Y?=
 =?us-ascii?Q?dC5COGa1qvIqPIUiIZ5SmZdy3jefatkI3ym73LyaDudeZx72Mkg0dObn5nwR?=
 =?us-ascii?Q?76LRxfamID2ssY5C12uUHtk/LqSAKXuIC6Yz4KIEFXs6jk6lEedVqNAo42rw?=
 =?us-ascii?Q?cs2PtFOd5JAPnnL6bY1vvdbw3goq1iQSa7PfoFwOuzt6LcbepwM4txK6Fdlk?=
 =?us-ascii?Q?VTDicKFsDR2QJC0jPXjnA4P7C+pOizWErhLB8pRL7ntRcspkLEDfUZPrcpML?=
 =?us-ascii?Q?tEQ7v1gT7e8XFzNtUVjrN3OFHT5DYQRfd1HLIhsY41RKgcsPs9TaoGa6EknQ?=
 =?us-ascii?Q?9mZtcz4N9A5Yrqc/19RZI2FbID2B7IwjzzB/Qd36+MuoHKOyxkZc9mXkxpuo?=
 =?us-ascii?Q?W00RsG4d8LrqHde/0mkLld4N+MWBxgr3uMaHZ6Wf/ltFWi1ayNYSah1RJLo6?=
 =?us-ascii?Q?pgx8HEXKnXhYWTrHInwUANTaTUUuviq8ebSYcrB/I1nLGCgprW3Wk7OeMiDW?=
 =?us-ascii?Q?7wac5Ioo5egoGK3PyjgBzwjF/vgyqPnlQV+1iLQKqrBdffThpCXJS4XgoJyT?=
 =?us-ascii?Q?B6KBNlN9qpbboZBhg/8jmtMLgtxJKmOs781IMnB76+zPcF4PPfUdUsbSZpMd?=
 =?us-ascii?Q?8oWZf6wXNpj0cmr1uoeguKUQ2CkumkSfzYb4diRztPJzppYpcuUE3rVLp4QB?=
 =?us-ascii?Q?t58pHszzGrj+oPNicOke/7NjJL+6BzGi9q9wb1WnbwpLB+OK3cg/yrP1qCQx?=
 =?us-ascii?Q?jcXB+AV2wQaP6TVpjxKJdOf6GL5TdwEVgeB5gi9sVvUFW7Wt8fsl+6Yd/ph0?=
 =?us-ascii?Q?KEB2wbScD3Tje72J6ZRWGhTEp4I4Bz6m3DCZ9/cymxqjiu7kafXnMOhWoTIu?=
 =?us-ascii?Q?U8Jrm/lfDPX/RFu97YhzzMILTASgSasLvWJww1M3udDQ8xN8g6LKMVkLKZZm?=
 =?us-ascii?Q?MAegtxh4Is2g6mqHjYFfpXJtRPHQrmTmMSXPWaTxj8e6ZeMcXo86lSZtK4OT?=
 =?us-ascii?Q?bf5vPkeqCFPYELoa5rLP8pslIH6jD1hWdYMAG0G8RlT1BWd0oqMrmowzo9y/?=
 =?us-ascii?Q?rgdYadQvZ6EtzopnOgcFhMmN8Y09NrV+s/yqgVrBXfNOeqF0gkhC6MmHisn1?=
 =?us-ascii?Q?J0J8Z2l0mMHvmVXZPtWWIE8Yy4hJVOw5t7Gbd9HLUJ/Iu2DSuLzt19mmzy3a?=
 =?us-ascii?Q?HDtZkgB7fLO/Rceo0zNx6w8EWPHlDzlzph3MX3Kfd+D2DcFm36Zm51/v9ToB?=
 =?us-ascii?Q?YZhqUfLK/SS1sByKmbkMwaQzoeFrIE91tikPbfSZlflmPXmENbz05430TJRE?=
 =?us-ascii?Q?RLBlp+3jn8zFIt/fTddCB9plhrhFgeeEsmFUjNEyvUA2pngu506oKW8JZRBe?=
 =?us-ascii?Q?PSle82GYUioWaFgl5moMPHpjJaBlYe7IRZoTJmr/HypCgQr6eK07tOg8fu4l?=
 =?us-ascii?Q?7ZvLXFUv12yBHTtm96PDghu+4CqECyXqmqxUNZa93u6GsjX7cNJeNsAffMZ4?=
 =?us-ascii?Q?Y5IswL/ybmNlOoJS4/lHCSJOexCGVdnMGLdX?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2025 19:27:20.8882
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f503860a-3b6b-4b16-d88a-08ddc3d59e8e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CEB.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8459

From: Ashish Kalra <ashish.kalra@amd.com>

After a panic if SNP is enabled in the previous kernel then the kdump
kernel boots with IOMMU SNP enforcement still enabled.

IOMMU device table register is locked and exclusive to the previous
kernel. Attempts to copy old device table from the previous kernel
fails in kdump kernel as hardware ignores writes to the locked device
table base address register as per AMD IOMMU spec Section 2.12.2.1.

This results in repeated "Completion-Wait loop timed out" errors and a
second kernel panic: "Kernel panic - not syncing: timer doesn't work
through Interrupt-remapped IO-APIC".

Reuse device table instead of copying device table in case of kdump
boot and remove all copying device table code.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/iommu/amd/init.c | 97 ++++++++++++----------------------------
 1 file changed, 28 insertions(+), 69 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 32295f26be1b..18bd869a82d9 100644
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
 
@@ -1128,15 +1134,12 @@ static void set_dte_bit(struct dev_table_entry *dte, u8 bit)
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
@@ -1161,66 +1164,22 @@ static bool __copy_device_table(struct amd_iommu *iommu)
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
+	 * IOMMU Device Table Base Address MMIO register is locked
+	 * if SNP is enabled during kdump, reuse the previous kernel's
+	 * device table.
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
@@ -1228,17 +1187,17 @@ static bool copy_device_table(void)
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
@@ -2917,8 +2876,8 @@ static void early_enable_iommu(struct amd_iommu *iommu)
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
@@ -2926,18 +2885,18 @@ static void early_enable_iommus(void)
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
 		if (amd_iommu_pre_enabled)
-			pr_err("Failed to copy DEV table from previous kernel.\n");
+			pr_err("Failed to reuse DEV table from previous kernel.\n");
 
 		for_each_pci_segment(pci_seg) {
 			if (pci_seg->old_dev_tbl_cpy != NULL) {
-				iommu_free_pages(pci_seg->old_dev_tbl_cpy);
+				memunmap((void *)pci_seg->old_dev_tbl_cpy);
 				pci_seg->old_dev_tbl_cpy = NULL;
 			}
 		}
@@ -2947,7 +2906,7 @@ static void early_enable_iommus(void)
 			early_enable_iommu(iommu);
 		}
 	} else {
-		pr_info("Copied DEV table from previous kernel.\n");
+		pr_info("Reused DEV table from previous kernel.\n");
 
 		for_each_pci_segment(pci_seg) {
 			iommu_free_pages(pci_seg->dev_table);
-- 
2.34.1


