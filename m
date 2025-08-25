Return-Path: <kvm+bounces-55686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE98FB34E45
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 23:46:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A11415E23D9
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 21:46:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DC9B29C33F;
	Mon, 25 Aug 2025 21:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="nVsaU7OL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2080.outbound.protection.outlook.com [40.107.92.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF882874FC;
	Mon, 25 Aug 2025 21:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756158382; cv=fail; b=TWCwTOfDRYNt9b0tMDGvoH5UnPZ3DfZm3b4OFWwrvZ4dMdBQnbbEY+M9PiuVyIhTa3zElIMV9sdZttcF6n+1tvlyd1yizaSQukW52kUVAxpi9wxOD4FUFdA2oXJGPIjlEq7lr6n+EXAufPr0DCGDkYpBxhudpzta9nWRE4eHjSQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756158382; c=relaxed/simple;
	bh=azHyGY317SRPaEOZzlamdAVbxdu4s4ahjgkuzib7/pw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OMHzisV7Wr2fVgtkoPb53tPg2qUVLAsauCCynkKN4MnDCZaastWE03mklqHm+yrTzEoJ+hla3Fl6wV9XCRv557Cs3o8lNwo2f0LjFLGv1pHJGfY0ETMnIY7Fo6viR49H8kKcCpmO8oopCTuOa3N9IbWwUi1FrxI0TTn1ktef/7Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=nVsaU7OL; arc=fail smtp.client-ip=40.107.92.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wmHzv4yimYHmG2B6zr8f5UcvgFTdnYFB1lcLBXImhCg2QTaezjILEzI5DuRtiaaontSlf51inW5rfL/ro9IoX3HFjfY82uOa2+Y8GcuQBSqO1D9mHXxC9RsukT0B/DMZLcNSjhcJVFjHbkZUeuClGLeK3GHCaEgmOINdzLBSV2cdHMt9wNXq9HCnICViNZYq194GRg+0fv7vUsWoiT3/BeMqovD8jcNyltPcaYspGGAOb6u3I+2aLXNkJFWAzUQ1bFqjmNGKdH1lGi/zslaN/4+mMu3ki76nGwZ9wPD4GJ3c+hKFsN2u9e8TLyIjFvmo3y4yZ6lwZyMNFYjGzKyVzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+/ii1EYyBBnOu8+l4JdC9d6on9mItISZkZAfq2ZfB94=;
 b=uMkiLtCXm20B3hEWe+qymBwAUUfScKvVSMpMsxv955GmdzGtnbJd0SRuXyJ/csrQUtfw32r9ds2gXK70hOxdmU4k4kUTmlkeGLwfaJralt3WBiw8wJUumi+rUyTG6aibzj+iSzadBVzGAazN1wij4pggH9rkGf/hCqkpiiF7brBexI+E8olyhB2f+Sl7A00HDfOAl1zj8uTnxwMRSBtwr/oBstPqgyq88IAgFWt32t2YNE0N+Ei4TG/XeGZgB8SVAgkduUkLyekF71ghe2smScyeEIxJKE+M5p3867eCO3F4XDYGJV3fUxNc/ULDDgnh7vp62UhZmdtuJjFytv60pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=8bytes.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+/ii1EYyBBnOu8+l4JdC9d6on9mItISZkZAfq2ZfB94=;
 b=nVsaU7OLYeqEnObXSqzTRLLRaq/gsFLppQ8U6snj6ueozLsMFfrLDEWX+F78C4P3iUJDlrHtPGTQgw9KGPWLNSr4T1+ANi1zD2pDKnbjR0vgJJlu0jWBveu0GsNF9c7wYmF/tvGjo54kKp4Xy2CxrGIRavI85pgJfaBAswOYn2E=
Received: from BN9PR03CA0040.namprd03.prod.outlook.com (2603:10b6:408:fb::15)
 by CH1PR12MB9693.namprd12.prod.outlook.com (2603:10b6:610:2b0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.22; Mon, 25 Aug
 2025 21:46:11 +0000
Received: from BN3PEPF0000B374.namprd21.prod.outlook.com
 (2603:10b6:408:fb:cafe::d3) by BN9PR03CA0040.outlook.office365.com
 (2603:10b6:408:fb::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.21 via Frontend Transport; Mon,
 25 Aug 2025 21:46:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B374.mail.protection.outlook.com (10.167.243.171) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.0 via Frontend Transport; Mon, 25 Aug 2025 21:46:11 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 25 Aug
 2025 16:46:10 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <joro@8bytes.org>, <suravee.suthikulpanit@amd.com>,
	<thomas.lendacky@amd.com>, <Sairaj.ArunKodilkar@amd.com>,
	<Vasant.Hegde@amd.com>, <herbert@gondor.apana.org.au>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <will@kernel.org>,
	<robin.murphy@arm.com>, <john.allen@amd.com>, <davem@davemloft.net>,
	<michael.roth@amd.com>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<kvm@vger.kernel.org>
Subject: [PATCH v6 1/4] iommu/amd: Add support to remap/unmap IOMMU buffers for kdump
Date: Mon, 25 Aug 2025 21:46:01 +0000
Message-ID: <ff04b381a8fe774b175c23c1a336b28bc1396511.1756157913.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1756157913.git.ashish.kalra@amd.com>
References: <cover.1756157913.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B374:EE_|CH1PR12MB9693:EE_
X-MS-Office365-Filtering-Correlation-Id: 02cff8d8-ebbb-4b6b-3247-08dde420ceb8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|7416014|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SHY1bDdGSjBoUnVjRHU5akwxNTFoUnlvUlFOM3FJcXdMUHVkMkRqdWpjZm8z?=
 =?utf-8?B?SW5xYjVQRm9yb0ZmYUM4WjZTd3Z2WHkySDE2Z0NJNUFjM2FRVkxjV3RIZWlv?=
 =?utf-8?B?K2VxNkNyQzlPNEdJWWNVMnJoY2t5djA4MGNuczU1aVVMQkRKb0ErQjZNV2Qz?=
 =?utf-8?B?UXhMSjdmWHpabkgrWXpuK1dXY0EzOG5RTFdTMllyZFpmUk1scnNGeW5GbXVi?=
 =?utf-8?B?Slg4WVdaTjErVGpMemZ3SlV4UldMVUJwOUFhb3dwRTNvWWtvdXJ4anJYNWdt?=
 =?utf-8?B?MHY1TXo2MzAzZkQxcE5XcHd1UHV5SExUeTRKQVoreEQ3d2p2WjEyYU1lbU5B?=
 =?utf-8?B?WlNtQ05sdmsrNERHbG9mdVpmVFg2cThoYnhVeUdOQkdYUGM5RVpQYTlia3Ju?=
 =?utf-8?B?K1NMTmNtS1pSa0RmcWkyZHlzbmZRdTZjQ3Q3WW1nb3BWU2xvZjRCcXRjdE5P?=
 =?utf-8?B?ZUZsZjRCWG1mZ0tGN1YrRXo3T1VJL2FlNXRaSDRyVnRmcXNINmVQbDF2VlZZ?=
 =?utf-8?B?RXB5OVF0YVFPOFY2cUMvR0dZWUkxdENvdGxKcGJhZEo0cTEwdXo0amxaTUlG?=
 =?utf-8?B?bG1zQnRHcFJCMjVDNWZObEhGMFcvdTBLR3lueDdRYTRVckt5NjJjQlRsTnBN?=
 =?utf-8?B?NExwc1IzSUVOVmExOExqellzU3djU2V6Z21mUTlEQXlTU1lBbjY1enNCTUJr?=
 =?utf-8?B?T0ZnL0d3WGZQbmJQL3QwcVpNRDhOQW0raUZWcVZKZmtuWXplTnBYRE9MSmFj?=
 =?utf-8?B?dVpVNzZwU0NMMFhVaGUxQkEyUEE1QkloQnUwREtQWXlWaWNuNkhzall0VG05?=
 =?utf-8?B?elE5bmN1ZzBJbkM2RlVTTTVFeVAzNngxUWRjcGpYaXA4UlpNYWlscFQ5Mld2?=
 =?utf-8?B?eklnNkl4dmdTUnhVMTZyTUlIcitkWURTMHJ5UjhLTVA0RUFxRS9BdmVxZkZy?=
 =?utf-8?B?eFRHdkRKdy9UODZ4Tkgra0tHdFJHN0VUSzh6OXhTcXB0WmMwRmcwSG9rWnFH?=
 =?utf-8?B?aUlIRDNEbW5USGVML0YzNUZWb2ZWdFg3a0pOSktrQzhDU1lSQmFnWU96c0I5?=
 =?utf-8?B?cFJJYWtkaFN5K2NYcjM3anlObC9XSkdoQ0xRLzRGQ0xJQStqZmZiWkRLdFg0?=
 =?utf-8?B?ZlZJcGk0dmpMRXRGdUlxQXd3ZldnSzBwb0dhcnUvK1VWejRNTXEvN2tSYXZx?=
 =?utf-8?B?UnpMQ2l6OEV1dXdZNk8wR3Yyb3VGaFFYSG9QQk9ZNWNDWWNEbFVVMzhxOVJK?=
 =?utf-8?B?QkplUHh0QmZjNVNKR3dndXk4UTVLRGJEUnJnd0R2NGNUQXVWMnNUd0hCUHBO?=
 =?utf-8?B?bzF5N0VIVWdRdHgyZGh3c0RqcUNLK2lEYmZXbi96SWhneUlmNEl1YVBDN3FS?=
 =?utf-8?B?Sk41aSs3YVBrYkZCZ3BienlzeVpvdUIxN0J0MEFUbDMzWUszc1NQdHU2TUpV?=
 =?utf-8?B?VTlCTVRsd3c4UXRSaG82OGVCWkN5VkRRRGxxYlIrSlpSc01Td3Q0cmdzbSs0?=
 =?utf-8?B?Wk0xbm9xem44MjM4VkVMK3ZlVzdDSGUvekswSER1QUV1d1BwU21oWjU0aVI0?=
 =?utf-8?B?R3ZlYWkwVlNLVEdYYVVEOURHVkVnVHBud2xMU3JCVk5EcDFRWmdleXdrazRv?=
 =?utf-8?B?UDNpa2U1VldsUzB3b0hmdkw1cUZLcFh0eVhPSnkyR3RMQ0VhWFg5bTJzVWFB?=
 =?utf-8?B?clppNisvZWRncWg2ZTdyQjdaR0lUOGo1M3VnN2pwaElNaTkrdVREYVN1dVkx?=
 =?utf-8?B?M2lvOUdCdUN2U1ZwcjZSamFaRGsvUTN6a3cyM1pDMVczcG5ZdE5ZTDVDTVBu?=
 =?utf-8?B?OG5rVTdFbTRSZmVDY2RnL0pRdXJnNnhYSTBWRGM3UkxzakkybzgxYWlpQlVy?=
 =?utf-8?B?NlBEWXB0RS85SEZDU040Z0FRVytaZjNodmxxc0hUY3BkUG1uMUZRM2EwSUxT?=
 =?utf-8?B?NWVHT1NzVU5JKzBxL1NydllnUDFBVWJUV3FkWFM2K0lOWHRCWW5YNDI3anFE?=
 =?utf-8?B?azhnRlo0UC9lejA1ZnhCNXM3WWJaSDBUQXMrQmdLSHRKYVVZTE9KRStLdERi?=
 =?utf-8?Q?m/Jyja?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(7416014)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 21:46:11.4318
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 02cff8d8-ebbb-4b6b-3247-08dde420ceb8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B374.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9693

From: Ashish Kalra <ashish.kalra@amd.com>

After a panic if SNP is enabled in the previous kernel then the kdump
kernel boots with IOMMU SNP enforcement still enabled.

IOMMU completion wait buffers (CWBs), command buffers and event buffer
registers remain locked and exclusive to the previous kernel. Attempts
to allocate and use new buffers in the kdump kernel fail, as hardware
ignores writes to the locked MMIO registers as per AMD IOMMU spec
Section 2.12.2.1.

This results in repeated "Completion-Wait loop timed out" errors and a
second kernel panic: "Kernel panic - not syncing: timer doesn't work
through Interrupt-remapped IO-APIC"

The list of MMIO registers locked and which ignore writes after failed
SNP shutdown are mentioned in the AMD IOMMU specifications below:

Section 2.12.2.1.
https://docs.amd.com/v/u/en-US/48882_3.10_PUB

Reuse the pages of the previous kernel for completion wait buffers,
command buffers, event buffers and memremap them during kdump boot
and essentially work with an already enabled IOMMU configuration and
re-using the previous kernel’s data structures.

Reusing of command buffers and event buffers is now done for kdump boot
irrespective of SNP being enabled during kdump.

Re-use of completion wait buffers is only done when SNP is enabled as
the exclusion base register is used for the completion wait buffer
(CWB) address only when SNP is enabled.

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/iommu/amd/amd_iommu_types.h |   5 +
 drivers/iommu/amd/init.c            | 152 +++++++++++++++++++++++++---
 drivers/iommu/amd/iommu.c           |   2 +-
 3 files changed, 146 insertions(+), 13 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index 5219d7ddfdaa..8a863cae99db 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -791,6 +791,11 @@ struct amd_iommu {
 	u32 flags;
 	volatile u64 *cmd_sem;
 	atomic64_t cmd_sem_val;
+	/*
+	 * Track physical address to directly use it in build_completion_wait()
+	 * and avoid adding any special checks and handling for kdump.
+	 */
+	u64 cmd_sem_paddr;
 
 #ifdef CONFIG_AMD_IOMMU_DEBUGFS
 	/* DebugFS Info */
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 8de689b2c5ed..5b8e9d6befa5 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -710,6 +710,26 @@ static void __init free_alias_table(struct amd_iommu_pci_seg *pci_seg)
 	pci_seg->alias_table = NULL;
 }
 
+static inline void *iommu_memremap(unsigned long paddr, size_t size)
+{
+	phys_addr_t phys;
+
+	if (!paddr)
+		return NULL;
+
+	/*
+	 * Obtain true physical address in kdump kernel when SME is enabled.
+	 * Currently, previous kernel with SME enabled and kdump kernel
+	 * with SME support disabled is not supported.
+	 */
+	phys = __sme_clr(paddr);
+
+	if (cc_platform_has(CC_ATTR_HOST_MEM_ENCRYPT))
+		return (__force void *)ioremap_encrypted(phys, size);
+	else
+		return memremap(phys, size, MEMREMAP_WB);
+}
+
 /*
  * Allocates the command buffer. This buffer is per AMD IOMMU. We can
  * write commands to that buffer later and the IOMMU will execute them
@@ -942,8 +962,91 @@ static int iommu_init_ga_log(struct amd_iommu *iommu)
 static int __init alloc_cwwb_sem(struct amd_iommu *iommu)
 {
 	iommu->cmd_sem = iommu_alloc_4k_pages(iommu, GFP_KERNEL, 1);
+	if (!iommu->cmd_sem)
+		return -ENOMEM;
+	iommu->cmd_sem_paddr = iommu_virt_to_phys((void *)iommu->cmd_sem);
+	return 0;
+}
+
+static int __init remap_event_buffer(struct amd_iommu *iommu)
+{
+	u64 paddr;
+
+	pr_info_once("Re-using event buffer from the previous kernel\n");
+	paddr = readq(iommu->mmio_base + MMIO_EVT_BUF_OFFSET) & PM_ADDR_MASK;
+	iommu->evt_buf = iommu_memremap(paddr, EVT_BUFFER_SIZE);
+
+	return iommu->evt_buf ? 0 : -ENOMEM;
+}
+
+static int __init remap_command_buffer(struct amd_iommu *iommu)
+{
+	u64 paddr;
 
-	return iommu->cmd_sem ? 0 : -ENOMEM;
+	pr_info_once("Re-using command buffer from the previous kernel\n");
+	paddr = readq(iommu->mmio_base + MMIO_CMD_BUF_OFFSET) & PM_ADDR_MASK;
+	iommu->cmd_buf = iommu_memremap(paddr, CMD_BUFFER_SIZE);
+
+	return iommu->cmd_buf ? 0 : -ENOMEM;
+}
+
+static int __init remap_or_alloc_cwwb_sem(struct amd_iommu *iommu)
+{
+	u64 paddr;
+
+	if (check_feature(FEATURE_SNP)) {
+		/*
+		 * When SNP is enabled, the exclusion base register is used for the
+		 * completion wait buffer (CWB) address. Read and re-use it.
+		 */
+		pr_info_once("Re-using CWB buffers from the previous kernel\n");
+		paddr = readq(iommu->mmio_base + MMIO_EXCL_BASE_OFFSET) & PM_ADDR_MASK;
+		iommu->cmd_sem = iommu_memremap(paddr, PAGE_SIZE);
+		if (!iommu->cmd_sem)
+			return -ENOMEM;
+		iommu->cmd_sem_paddr = paddr;
+	} else {
+		return alloc_cwwb_sem(iommu);
+	}
+
+	return 0;
+}
+
+static int __init alloc_iommu_buffers(struct amd_iommu *iommu)
+{
+	int ret;
+
+	/*
+	 * Reuse/Remap the previous kernel's allocated completion wait
+	 * command and event buffers for kdump boot.
+	 */
+	if (is_kdump_kernel()) {
+		ret = remap_or_alloc_cwwb_sem(iommu);
+		if (ret)
+			return ret;
+
+		ret = remap_command_buffer(iommu);
+		if (ret)
+			return ret;
+
+		ret = remap_event_buffer(iommu);
+		if (ret)
+			return ret;
+	} else {
+		ret = alloc_cwwb_sem(iommu);
+		if (ret)
+			return ret;
+
+		ret = alloc_command_buffer(iommu);
+		if (ret)
+			return ret;
+
+		ret = alloc_event_buffer(iommu);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
 }
 
 static void __init free_cwwb_sem(struct amd_iommu *iommu)
@@ -951,6 +1054,38 @@ static void __init free_cwwb_sem(struct amd_iommu *iommu)
 	if (iommu->cmd_sem)
 		iommu_free_pages((void *)iommu->cmd_sem);
 }
+static void __init unmap_cwwb_sem(struct amd_iommu *iommu)
+{
+	if (iommu->cmd_sem) {
+		if (check_feature(FEATURE_SNP))
+			memunmap((void *)iommu->cmd_sem);
+		else
+			iommu_free_pages((void *)iommu->cmd_sem);
+	}
+}
+
+static void __init unmap_command_buffer(struct amd_iommu *iommu)
+{
+	memunmap((void *)iommu->cmd_buf);
+}
+
+static void __init unmap_event_buffer(struct amd_iommu *iommu)
+{
+	memunmap(iommu->evt_buf);
+}
+
+static void __init free_iommu_buffers(struct amd_iommu *iommu)
+{
+	if (is_kdump_kernel()) {
+		unmap_cwwb_sem(iommu);
+		unmap_command_buffer(iommu);
+		unmap_event_buffer(iommu);
+	} else {
+		free_cwwb_sem(iommu);
+		free_command_buffer(iommu);
+		free_event_buffer(iommu);
+	}
+}
 
 static void iommu_enable_xt(struct amd_iommu *iommu)
 {
@@ -1655,9 +1790,7 @@ static void __init free_sysfs(struct amd_iommu *iommu)
 static void __init free_iommu_one(struct amd_iommu *iommu)
 {
 	free_sysfs(iommu);
-	free_cwwb_sem(iommu);
-	free_command_buffer(iommu);
-	free_event_buffer(iommu);
+	free_iommu_buffers(iommu);
 	amd_iommu_free_ppr_log(iommu);
 	free_ga_log(iommu);
 	iommu_unmap_mmio_space(iommu);
@@ -1821,14 +1954,9 @@ static int __init init_iommu_one_late(struct amd_iommu *iommu)
 {
 	int ret;
 
-	if (alloc_cwwb_sem(iommu))
-		return -ENOMEM;
-
-	if (alloc_command_buffer(iommu))
-		return -ENOMEM;
-
-	if (alloc_event_buffer(iommu))
-		return -ENOMEM;
+	ret = alloc_iommu_buffers(iommu);
+	if (ret)
+		return ret;
 
 	iommu->int_enabled = false;
 
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index eb348c63a8d0..05a9ab3da1a3 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1195,7 +1195,7 @@ static void build_completion_wait(struct iommu_cmd *cmd,
 				  struct amd_iommu *iommu,
 				  u64 data)
 {
-	u64 paddr = iommu_virt_to_phys((void *)iommu->cmd_sem);
+	u64 paddr = iommu->cmd_sem_paddr;
 
 	memset(cmd, 0, sizeof(*cmd));
 	cmd->data[0] = lower_32_bits(paddr) | CMD_COMPL_WAIT_STORE_MASK;
-- 
2.34.1


