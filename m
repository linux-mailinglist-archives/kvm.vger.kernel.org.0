Return-Path: <kvm+bounces-53035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 742C3B0CCE9
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 23:53:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DBA9A3AC71F
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 21:53:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E71DF24113A;
	Mon, 21 Jul 2025 21:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="r6jCetJ+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2084.outbound.protection.outlook.com [40.107.236.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3871522F16C;
	Mon, 21 Jul 2025 21:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753134803; cv=fail; b=SRPaMNgR+gCvusT8yU0pq6MVUXT4u2M7KN0VrY0SpH4qlzcaxZX51TMfNuVMaWSpdXBEexCHj4zII0asfM8pt+RFi2vWziPvjbGmVuafJBwNV6jgjB/DMCuwI194TT5Hi4bwcshg0NcAWXKB1rnyHhtvcgEXgeyBSWR66LsjpSo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753134803; c=relaxed/simple;
	bh=meiRoKWuHdbmqxLjKsK3MiSzs3ZPkxOjxwM2ek/Pzes=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H5Fmc4jXRX+S5sM3KcXaulo5/JsPyB4Bg7VcEy2SwYceFhWYNsHhZjx1Zp7eptRD8ayceBJ04pKDUjY039yRqzkM0LphtKxgtHcPMEdJB47QVcpJeH8Cfu+L+rzGd9ri/bRen0mYnmTANGv/Hpn9hlgHGVJ68jznFaPrs0WohB0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=r6jCetJ+; arc=fail smtp.client-ip=40.107.236.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=plGi2nm0Y8ikTFgO5H+YT5wWQJNFMO7X2nhoKG90wzUpbKBi+sdCDafccDLZmgPfgN7dw9O/RVbMN24vUzEEtupip1qb+k6MCyDj09GLXtIKrpaUPIfgokoNKx+xzRYi5wFBCle/qjaPnr7LEB0t+wsvWePodgTAyvP9W0FPrp8AxlBhuvdXViy+xsiRjaaxLQjDupL4h5p59FqJktdKTFgDGkIJetwm0eAd09cKp/AGWD7b+zRHZOIGlijaYaIJ9gZT2fhDZI7KleG1EtYyc8r0gqKxqJ9B/FljJs/5aiGD+Vwj5vlzdkmQ1K5HXMOfPRrb+jDwrgkp9q4bvBoMqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wtWMb8d3N8TVrTVh/uOUd9hNlzIPfefX91A4Js2LxKo=;
 b=TcOt9OdreUKlrN6EfgjoMSnyHRQF4VlufBo/N6lkbx7/g2XBTIUgT2Y5rl1Mj0ZOo5PHdYE7d5kEuqoyJr34oAAKNPwdkab7WiTa8wn2YgvNediV0tsrZG8xYTFSX/0GE+QPLUn+Ecelng4sUDdAUDwTZ9KCB0au2cT/jaep0jwky4GIne8Sry+hXGVhB/y6jyLbQuaJogEmMmAaH3I9/26KndyBAHMPyvU/KYW7+g79F2lOxF5yJzjB8F3anTwiW/PZvVfGO9EIezAqVFuAxlI9CdfZykRs1nGyvaIQNpBwDU1nkKmyGQWfqxU5+e0h0ZXknsx2UWc+BhP27aWqMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=8bytes.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wtWMb8d3N8TVrTVh/uOUd9hNlzIPfefX91A4Js2LxKo=;
 b=r6jCetJ+cqxYTP6r9V3M3o7j9dx43Cr0/5rDp0cVFuzoJRjbVbWUIgx9lIJdcS8RQtq/aVH+tZLe8Up56SY6VR2chOBviz2liITDgw+wmgU+Yx2rGUviBbP2Gj4lliagVj2qPZMvTihxvb6bKXXEAzwLrn+0xxgVxAS9W4UybBw=
Received: from SJ0PR03CA0014.namprd03.prod.outlook.com (2603:10b6:a03:33a::19)
 by IA0PR12MB8713.namprd12.prod.outlook.com (2603:10b6:208:48e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.29; Mon, 21 Jul
 2025 21:53:15 +0000
Received: from SJ1PEPF000023DA.namprd21.prod.outlook.com
 (2603:10b6:a03:33a:cafe::be) by SJ0PR03CA0014.outlook.office365.com
 (2603:10b6:a03:33a::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.29 via Frontend Transport; Mon,
 21 Jul 2025 21:53:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF000023DA.mail.protection.outlook.com (10.167.244.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8989.1 via Frontend Transport; Mon, 21 Jul 2025 21:53:14 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 21 Jul
 2025 16:53:13 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <joro@8bytes.org>, <suravee.suthikulpanit@amd.com>,
	<thomas.lendacky@amd.com>, <Sairaj.ArunKodilkar@amd.com>,
	<Vasant.Hegde@amd.com>, <herbert@gondor.apana.org.au>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <will@kernel.org>,
	<robin.murphy@arm.com>, <john.allen@amd.com>, <davem@davemloft.net>,
	<michael.roth@amd.com>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<kvm@vger.kernel.org>
Subject: [PATCH v4 2/4] iommu/amd: Reuse device table for kdump
Date: Mon, 21 Jul 2025 21:53:04 +0000
Message-ID: <0a9f79741e8a5b1619069a892bc5c22f17df1c34.1753133022.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1753133022.git.ashish.kalra@amd.com>
References: <cover.1753133022.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023DA:EE_|IA0PR12MB8713:EE_
X-MS-Office365-Filtering-Correlation-Id: 15ef8143-164c-45a5-2aa4-08ddc8a0feae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?leFjbmry0Ne3ak75z/c9CJfSBH0AVgYGOtmmjwXg1uUXt0KVA+lyHNHg7U3h?=
 =?us-ascii?Q?bg9jhFc1EIRKzOdjszNOtGF1XgKPSJlI/PYjHKqQitmI2LqP9Omek73s8VHT?=
 =?us-ascii?Q?wJw+zfPS2fU7dC2AC/p57PYbZ9+lRtmdURLU34jFhaH+gp/9Wsm1h+B3nDse?=
 =?us-ascii?Q?Lyf7T/B4+29FRIYnBnk0YtGrytssoOs4gBfJ9VEpheL2LcNl0ZdUsURKEz2k?=
 =?us-ascii?Q?EUZJ7Vn2wICu4YSQVFbsrd4w14ZMRuP6wmc+1ggjisOH7sDjecyshC5iPQlr?=
 =?us-ascii?Q?G8HfC4gg+r/FdBTAA+TBIIz4HE+x9Fx+/LRKr7kCOh79tHwNRz8YqeLOXA57?=
 =?us-ascii?Q?k8nnVGVfGO/XkRxnMlKnC3mpxkGFknSiuT5A17meSlDUAmLMYu2w4KkVUro9?=
 =?us-ascii?Q?Kf49gPW1Pw5l7sphzxR3823w4AIkntzpjXToLTMc1dVE7z6ze4GhV680aq2N?=
 =?us-ascii?Q?njyBNnQx1joN1I4lhF6kTtddIooAlg0JNS4Rvcc4X2ROleicNQorOapyeNNU?=
 =?us-ascii?Q?zbpaijOkI9aZFQXYzxZjpwnOUTcRNVIVImEXK+If30+nhdt996pmtmNO2hWd?=
 =?us-ascii?Q?1glMNNhnayUS619VTexp/ZG5jFv7BZ9IOL+ULAs+7h/+rsTcmMvk06C+hzls?=
 =?us-ascii?Q?RYLnzHUoZvcIP8UZD9GJAwvVLdGNPjHx+e7/b4SXLladCIdUL3afbCHGQeF+?=
 =?us-ascii?Q?0QtJ/byDTOjdOkjgmGqudwcruxJN4cgWQ6A32eC44/YWZLYLr0nBTKdeXDcN?=
 =?us-ascii?Q?a1MCFI4taDpZVPfPq3LSuKg+cY2kOOkTH3gpt695cRD3tmbP2wRis7uWY8NK?=
 =?us-ascii?Q?o2ogfYoLMd8jWG8R1poyR2FtO3WsPJrUBDOR0oHIWBIPrGEE0HuLW3ZN8jUD?=
 =?us-ascii?Q?11bzYr77XVhhZir+zcjQ+Itqf9eP2oRzw0ohQqfyfyzp0nJv5DuFwkqDVgZa?=
 =?us-ascii?Q?s5VVz8XtrnGdBxJ8FsRz4j6FioKgahNCiHHXJLWhd+6pD+CfrlnY3e1Pu0DP?=
 =?us-ascii?Q?CZ0sUJrohvTCxQAzVw1MSR3lsLzJ/TNpriZ7+QSzz6g4LmZnNSWszaoCAWob?=
 =?us-ascii?Q?DJHq9rFtDOZliJX0mbEwCgYK0MGkaQ/mP1RimCCsDK9IweJAyktC/J/kyp3C?=
 =?us-ascii?Q?1PSOOkWTTtvCEEL33QpJEP/1qM659P1fP5hPQipA/xO/mYc16Cy6jlInQYnr?=
 =?us-ascii?Q?Lvs7zW1F5FUNKLnjbicFmebSgmX+X2d9esUHoNs0nMYPcmsAvNdjWbYC8I1p?=
 =?us-ascii?Q?teynzy/+tvRX3iS+yVO6r4/yGrwHt5sNUaYGXCVQHSbKouPoya0FNXUpYrj5?=
 =?us-ascii?Q?cwOPD5zd8FdcWl+9Fbz4/m1SVMDZ3WOJSf7SvG9POcjjxKFY69YDSvGi0x12?=
 =?us-ascii?Q?6l8cp8DWLJGM3E3y5vdX/8sr72RiGMZgjaZvHxdq1InbG60kbnRZ4TNH/HLT?=
 =?us-ascii?Q?OFsTpDmWuj2vuDH/BUdNZ9VNH61tGDco/IdMsGYljOUDgo4QWxsih+XtLIEX?=
 =?us-ascii?Q?A7B+vEqLzIpTJUu079OOF/+0MeXn/d9VJwU3?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2025 21:53:14.8287
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 15ef8143-164c-45a5-2aa4-08ddc8a0feae
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023DA.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8713

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
 drivers/iommu/amd/init.c | 106 +++++++++++++--------------------------
 1 file changed, 36 insertions(+), 70 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 49e02f55c3ce..4ba2281e06f2 100644
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
+			 * time out without DEV table.
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


