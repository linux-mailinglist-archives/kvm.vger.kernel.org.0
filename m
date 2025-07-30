Return-Path: <kvm+bounces-53761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AB76B168A3
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 23:56:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 67FE94E6B6A
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 21:56:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 064CC2264B0;
	Wed, 30 Jul 2025 21:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="oSd7mJZn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2052.outbound.protection.outlook.com [40.107.95.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93CF12253A5;
	Wed, 30 Jul 2025 21:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753912581; cv=fail; b=Vf+OJ/qinKlmjkXC/mfTkkjzkEnl382UImnv+p4wLfEinS71YuLpUNpIc2tZIDx4sNIhlh1nyvM13v8zQRTuffo8gNSpKI5PAuqE4PXodXvsHc5GC13OVasf2oVZUFseID55juQVSgE22GQYDxlHhR87wtc0mn28/ptbHEOapa8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753912581; c=relaxed/simple;
	bh=EXw6VZVFPUUcn1knUuLGa1OAD06Gd5QzP8BUIHB4IV4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jY22ugzQWYsf9mVqPoIT1/fwnS+tWmdr6l5UKwCijNfhB7p+6nmTNmasArzmKnAjp680lLf2O2vs/lzZu8G4StlKyUnh+7jKmsZrqovnY/pujVZrQ2Xq70X3l2uZsoJshvFGzJSM/EFdkgMOpxsljGniP/OFEU+NXc9LFSgb7yQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=oSd7mJZn; arc=fail smtp.client-ip=40.107.95.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WV2cLxbL/hbhQB/ia2ed22/IvHAwwf41IrxH9GjIiUN6b/DDfjoeUU8OMM2PMz6lEyjedCGk3YsRQJVod8LDmNpwra2idH6SPV7cv8uE0NiDLNocCo2LnW4SlytFGbvMUrb1W0lP4zP8QBNXynpvnRQQEONv9vOLbaFDi/fZCcDPf89OxoOgCKCIXAy4GB8FrNIuskjWY43K5nL79rHs7GLRLc8/x4w0WpFXCFjDERQ6fRhzzGdWjOAWZ5EmaZDwYfungXc8fthqdTB/WICaruNikFTXRaq6ohhfsF21w8TCLGfTLEqwvbRQHL7Bm9vYd+MYmY9x4SpjXQAK2ENI7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mjpIzl6GTk6LVgR9xegp4Iez4yKdbg3+go6bGePvKLU=;
 b=G/unb8t/q/ZPCi5N7uXEZoYw2qW3HTFxbgApXzBqtD9mm8M22OnYE7wJdSdtR+vLK3ua/GmGp02rbLNuVkoyuHse4HzTK80d+ypcNm1LNRK3n7gL8ugOgN4O0V9hrs1qosJFOyvQQXASiKikbALmnCXvm1yYV4AfH/ZB+LNN9jBK6L5diHGT08ecRzNa+aV3Brv4tUNfH0SzZkRq5+3NaY/hYQwmhd1sgdl9ee2gMlqsk6GC42b7BOYg/JO//U5zLWbZtScfpzXW7deQGabAVOTkWmZFeQdpnN+gk7nGW/hMc/5nCniB/vudwvcFZTSW3zeJugeOTsyYkwFTxa50iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=8bytes.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mjpIzl6GTk6LVgR9xegp4Iez4yKdbg3+go6bGePvKLU=;
 b=oSd7mJZnFgjd1mc1g3haZ2HNK//LFBWjBQirRF9CSjABS1R05HgIQE6vewtNgThf8OoX7pDhhvJ9+ptI/OV3LJ4VfICUJ+a/5BSKWVmolAD5Iv8L68hDLSSIhbiYzjl8tW5R29JsxSQYrryax94CjDIkkSo6BLr59IIcjO48l2k=
Received: from BN9PR03CA0543.namprd03.prod.outlook.com (2603:10b6:408:138::8)
 by DS5PPFD22966BE3.namprd12.prod.outlook.com (2603:10b6:f:fc00::662) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.13; Wed, 30 Jul
 2025 21:56:13 +0000
Received: from BL6PEPF0001AB71.namprd02.prod.outlook.com
 (2603:10b6:408:138:cafe::e4) by BN9PR03CA0543.outlook.office365.com
 (2603:10b6:408:138::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.29 via Frontend Transport; Wed,
 30 Jul 2025 21:56:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB71.mail.protection.outlook.com (10.167.242.164) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8989.10 via Frontend Transport; Wed, 30 Jul 2025 21:56:13 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 30 Jul
 2025 16:56:12 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <joro@8bytes.org>, <suravee.suthikulpanit@amd.com>,
	<thomas.lendacky@amd.com>, <Sairaj.ArunKodilkar@amd.com>,
	<Vasant.Hegde@amd.com>, <herbert@gondor.apana.org.au>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <will@kernel.org>,
	<robin.murphy@arm.com>, <john.allen@amd.com>, <davem@davemloft.net>,
	<michael.roth@amd.com>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<kvm@vger.kernel.org>
Subject: [PATCH v5 2/4] iommu/amd: Reuse device table for kdump
Date: Wed, 30 Jul 2025 21:56:03 +0000
Message-ID: <5ad4c4525a2fd673cabcc763f0ccdb9b3595aaf4.1753911773.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1753911773.git.ashish.kalra@amd.com>
References: <cover.1753911773.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB71:EE_|DS5PPFD22966BE3:EE_
X-MS-Office365-Filtering-Correlation-Id: 452811cb-9bb9-4633-681d-08ddcfb3e6bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4uVJ2FiNSkBt7JhN2F5G/e5KQ1s2eRIDjqIOBHGPCmVs4sYX7jgPB7viDTXu?=
 =?us-ascii?Q?NkTJvVQzpImzxOX19DrzC6V84d35Zk6IZ8NMXr7YKQMgvua4MLLHmu9PEQSE?=
 =?us-ascii?Q?lJWEugfmq5m1J6fYCu9vcs+q3o13V6+d+SaltRN/vNQlbNchID4lj7wy3qdQ?=
 =?us-ascii?Q?+8zB9uk4WvjIeg5DTQ+gL082T09kUiT8NVfYjpJrxrx466rZQHJqxRHwk+BL?=
 =?us-ascii?Q?CASWVPL6+7Z0ZA9g1VeGiQx1wFwsXSrC7L15Rg6j3r6fF7oaBlb523VqG16C?=
 =?us-ascii?Q?E578JQiMQgdeX58pRS0B7UJohD3+UmhSSilrkola/ex18q30RBDu7MY/DEnn?=
 =?us-ascii?Q?bxF6Jk4ixP4oFkfViHBOapUWvdjbvS+jXGuoBb3hxtgemmCtWv8p4jzianPP?=
 =?us-ascii?Q?ZN05Q2Awwe7PmBHW1ry3xlCAlhWOz74JrfFUgiW8p+zCkZZq73Prv5wkjeLj?=
 =?us-ascii?Q?E6obWzrCYBM7WlLkiSQuMpcG63zaSK+RAcHmIfaecjVR69Q6w22cwXPJwF5N?=
 =?us-ascii?Q?wJ8hWh/WHbIrNzXFgqi+/vRQIaWizZVSPw2JuMSn0FKXUt8HUR3ZV62tS4Zg?=
 =?us-ascii?Q?e1WCua+hyxlWGV1z98BZnEbCS6HX/dljFR2VEWWVfVdgBSrh/F7Sv18Xf1v7?=
 =?us-ascii?Q?LpFiIHaDe5OOvfDdsccMtiRgpcrh+3snJa+xCRlgaNhWb/S1iVztKoeE350o?=
 =?us-ascii?Q?SVt0uwbII359sSCbS/jzyGIn+hERdgjeasagroW+HJcWZsCoORo6+pfosvY6?=
 =?us-ascii?Q?zsJ4hkS94jbGJbAYGNuN17JVhdjl9EJseVX9sRvw9M98aV3RXV+ABYnlGgDs?=
 =?us-ascii?Q?069aEcRrI+CUH+dyEr8Dh/FoJNrw4GFAQBz9+wx0aF89RasTxJ/eTZtkR6ks?=
 =?us-ascii?Q?7ewuMme7AeiASJOoNzT6INB8yR5sMvw/ScORtzNpOBk5LG2dwztTQfAn2Qa0?=
 =?us-ascii?Q?aJLfqlXKSbGf1v8cEXsj/UiFDj9UrZfOhzV+5wYGc6w5qlZno6J90a8ZLGzw?=
 =?us-ascii?Q?85E27Cvqhpb9UnieGxrArNsUQ00t6HxLDUxfPMUi7qCzjPPQfYgboLN6Lod4?=
 =?us-ascii?Q?YumDPH8Rg7POHbOOgjeysbGKpr7ye5pjOcg4fo6KONBf6iCw8XDIs6vUb8h7?=
 =?us-ascii?Q?dRFfCqQqb7RDxkXpPb9db66uvyw7o9vE27kaugxpA0vrlwi7xsqSxO2iEAGI?=
 =?us-ascii?Q?3NZ5ZFiWvVL7xGJyC7QoqDDsm8nxN38QcrnfEO6IO4WMTiKUxF99vIYOEzk9?=
 =?us-ascii?Q?ZrDaGtletbPEFWAhpJot0oDycExfw8n0489ALSdYHFKnSok5DyKP0nekHXrV?=
 =?us-ascii?Q?ZB/X1rqU9dUk2Ab8KjuM2hBkd1xyDep0jVb7iIb9F3+A2tPRksaoy0E3lv7o?=
 =?us-ascii?Q?TQMB8lQRT5PZ1wrF1qnyku/QwOHx+NZLXcyZ9RdTiK1zhXI858lLP+VQldRz?=
 =?us-ascii?Q?pQXxPAmcdhX5NSsnpfqIXtKySD+Jb7dMDcdbvGNmG4KOYCCoXs00WPTN0jBb?=
 =?us-ascii?Q?Bkse1NnvKDPgqfmfdFFqmJup/AXYHiypNhhe?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2025 21:56:13.3159
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 452811cb-9bb9-4633-681d-08ddcfb3e6bb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB71.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPFD22966BE3

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
 
Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/iommu/amd/init.c | 106 +++++++++++++--------------------------
 1 file changed, 36 insertions(+), 70 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index aae1aa7723a5..05d9c1764883 100644
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
 
@@ -1129,15 +1135,12 @@ static void set_dte_bit(struct dev_table_entry *dte, u8 bit)
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
@@ -1162,66 +1165,22 @@ static bool __copy_device_table(struct amd_iommu *iommu)
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
@@ -1229,17 +1188,17 @@ static bool copy_device_table(void)
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
@@ -2918,8 +2877,8 @@ static void early_enable_iommu(struct amd_iommu *iommu)
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
@@ -2927,18 +2886,25 @@ static void early_enable_iommus(void)
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
@@ -2948,7 +2914,7 @@ static void early_enable_iommus(void)
 			early_enable_iommu(iommu);
 		}
 	} else {
-		pr_info("Copied DEV table from previous kernel.\n");
+		pr_info("Reused DEV table from previous kernel.\n");
 
 		for_each_pci_segment(pci_seg) {
 			iommu_free_pages(pci_seg->dev_table);
-- 
2.34.1


