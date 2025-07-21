Return-Path: <kvm+bounces-53034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AC75EB0CCE8
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 23:53:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F1F931651C3
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 21:53:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 677E522F164;
	Mon, 21 Jul 2025 21:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jbiseG4A"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2074.outbound.protection.outlook.com [40.107.243.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BACD122F16C;
	Mon, 21 Jul 2025 21:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753134793; cv=fail; b=lbNv+C+C28FKUzw8ZTcVckMJLhRibwqeMRHy/xtAOatNaHpNvy1VeYBw3TczwXBLjVQDOyv5y0C63xQiGJG2CNJwWYnAv6yqs6q+24EauFz4QJhajBlF2EsQPYmXlThQ72LWeq0H/P9vwcNeaIcIVaaFgawXpaau7Cr0ZVeFTXs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753134793; c=relaxed/simple;
	bh=n+PooeJCZPZYvWcD4Mr/i117666rBo3/MVbbFalO4dg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tZuKhKYPvmfRNeHPtvYaqj67cD7Jw8DquaNQzYH1xLJzvY81FEVu8dm5uQofA0fUpXuoPV7FUZzYRHejatsbKU9TnSCB2wnkYOdtfTidjc6SPSuXQR3JVPtZQ537i93mTrjrHmC5T+BwDS5K4/khGFMiZQDhFhOIceHWOqtJw38=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jbiseG4A; arc=fail smtp.client-ip=40.107.243.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G7s3ijXkzmcsPREIpDKyCRCAOGzGAkzFu3V4qC2yYKhvSEIpGFkg1ixxu3A/UQG7tALGqT1bCsKPUXWVyL1ifhvsRI8PKDbskXQULn9WEhvc3qG/ltjAxiJrONXd5t9Rq+1nTw/+X9UR9VHf7ujVeDIe3J+37iz92O+SynHmN5sS1+RScVURQol4HvfOWLZweJjcg2gbn/R8ZBxot+jOyvz6KiWIxvYi6TWF5AYNN+ApGZsOfa5AMC3IXNcq19RWpQEsQFfNlHGKD/pTAURhk/MAIgQnu/1c2HhzgCVCTk25wyJhkcmpdYAgth3NCeTCkCa2APgf1B29GBaXuAgR7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0+0lxj80+/r6j76c8x7b52hxuoOA6dAGoqz2j1o4n1k=;
 b=vd2yaJfCBDEocdfNvq4nQFkZiJNwVr/yLjLEY6NGclEnOAKAfsEBkqdCdex4uS+D0NY51ziSPQl9y1wU4y6kJxf1O1cBnbWwAdL8OxBjkqO+l0EeWSLY0iD/KXAE6aZEVARUXwIWE5oOru+roWksf+HGdJOqgVQVyDXgBU5oOVcigQ4lSRK5b6qalJZ8rEUyE8dKhjKSK3DP9Mlk4S5hPCeb9/nRbc9Mu0b9OptA6ZEUPkkZsfuT09CAjKdPYd+n8lQy6bLNF9TWvmz1I+R/v2l9ULU9ZDWYE7WEB/tPZr5g8qnfGSR/4BkCjiXDq9R+jg4YHNoAXviruW3c6hXuag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=8bytes.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0+0lxj80+/r6j76c8x7b52hxuoOA6dAGoqz2j1o4n1k=;
 b=jbiseG4AokPxeM+ymwYB2wsOZVL1N2snPC0rdVeFVLta2Hmg5/4FgyeoQ0DA15iztkOYHpZzt0ezsVO2eEbji8VqP0TsljvRNFkDataK1zszuogf15IqIVs3FMhz7oaFOmLsBsZk8T/U4mmaoEXhZlZHjngmfKiMmHDlfbnmJXg=
Received: from BY3PR10CA0019.namprd10.prod.outlook.com (2603:10b6:a03:255::24)
 by BN5PR12MB9537.namprd12.prod.outlook.com (2603:10b6:408:2a9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.39; Mon, 21 Jul
 2025 21:53:07 +0000
Received: from SJ1PEPF000023D7.namprd21.prod.outlook.com
 (2603:10b6:a03:255:cafe::c9) by BY3PR10CA0019.outlook.office365.com
 (2603:10b6:a03:255::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.23 via Frontend Transport; Mon,
 21 Jul 2025 21:53:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF000023D7.mail.protection.outlook.com (10.167.244.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8989.1 via Frontend Transport; Mon, 21 Jul 2025 21:53:06 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 21 Jul
 2025 16:52:59 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <joro@8bytes.org>, <suravee.suthikulpanit@amd.com>,
	<thomas.lendacky@amd.com>, <Sairaj.ArunKodilkar@amd.com>,
	<Vasant.Hegde@amd.com>, <herbert@gondor.apana.org.au>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <will@kernel.org>,
	<robin.murphy@arm.com>, <john.allen@amd.com>, <davem@davemloft.net>,
	<michael.roth@amd.com>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<kvm@vger.kernel.org>
Subject: [PATCH v4 1/4] iommu/amd: Add support to remap/unmap IOMMU buffers for kdump
Date: Mon, 21 Jul 2025 21:52:49 +0000
Message-ID: <6a48567cd99a0ef915862b3c6590d1415d287870.1753133022.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1753133022.git.ashish.kalra@amd.com>
References: <cover.1753133022.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D7:EE_|BN5PR12MB9537:EE_
X-MS-Office365-Filtering-Correlation-Id: a17b9154-9040-44bc-f988-08ddc8a0f9ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|7416014|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZituTHA3aXJrN0l4dkVub1dkNHFyZlBaRTVadzVZcys2Njg1QmNJZUNrZVZ0?=
 =?utf-8?B?MzhCLzluWWRFUTFiRmRPV0dSNS9BVzhUT3VCb1d4NTk5ZXZCcTN4aFl6dVBZ?=
 =?utf-8?B?MkpKM2cwOWc4b0tnWXJwbFFWT0JEQlFXNXppd2NmeHlzanFqVnRlcEdrUEtI?=
 =?utf-8?B?a3VOMnorRFJOVDF2eDFBZWczVGV4Z3NvZmk4d241Nktid3c5c0h5NHRmMWxr?=
 =?utf-8?B?ajVNTWlNTENMQjdReEE1Y05XNCtTMVFvb3VpeEpwVVg3QjRHZW1wZ3ludXJw?=
 =?utf-8?B?K1ljak9BQmtHUUZNOVJOWVlqNXh0elBNT3c4c3FyNW8zNlhVdlI4ZWh4OUNW?=
 =?utf-8?B?YXA2MGJQMHE3QU1OcGZHMWdQWDNRZ0VGNTVHdHZyNXR6NmdPQlZHWTNWT0tF?=
 =?utf-8?B?T1ppb29zNGtkbHdrTEZXZ0RrODdDS28zRjh5eW8wUHdDM25LU2s2c2IvTisy?=
 =?utf-8?B?OUxzT2h4NzVuczg1QWpRMXhMN1FZS2FFTFBYN1RaTEJ3aUFnazdjQnE3UHZI?=
 =?utf-8?B?VnY3T3RTWFM2dFRpNFhkNUh2ckVhbGs2RUFURlQxaXVZaDhRSC9TU2ZlenVW?=
 =?utf-8?B?WDI0ZW56MFdrL3FJWVU2ZGtpQlZrRStqZ1hHeS9XSVdYMkNzNzNtaURmUlNS?=
 =?utf-8?B?b0R5V2MwYlFSWW9NUWZieW03WVBMUWpjeEQ4T29namRFdGZIWVNuSmhyQ0dY?=
 =?utf-8?B?eFpyMU9uVldRUS9jNHVGWjRJSWZ1WHVDQ2hKY05BTDZOVjlYVnRvWkZtZmtn?=
 =?utf-8?B?Q25RVkk4enE1R1QzcUdDUkZkY3NCT29LZEwyUXNHbElaRzBJOXV5eVhXZDVG?=
 =?utf-8?B?bC93WVAwaTlPUkhKbUIrWEh6bXVGZENQTWZqTmpXZHhhQmVpQUpTTFpURVo4?=
 =?utf-8?B?eDRBME16T2xSTFdYc0pCNTVQQ2lnMzZtUEJnbE1wcVVQd0JPc3ZMbUtEV3hP?=
 =?utf-8?B?ZWZsQ2tJNktIWmMzczZrbmhuRTZDeUVrTW05ekVYRVNZU29PRDJQWjY1V2h5?=
 =?utf-8?B?UVhEcDlVMHh1RnQrTjM2NUM4Wkkzd1czTHhhSFRqQ3dUSXRrMmJVamhlSkE1?=
 =?utf-8?B?S3h5SjVEb21RVTVKL3U5NTkwbFViZDJ6RjhzL2NCS2ptUEtaME82Q0ZJS01l?=
 =?utf-8?B?THUvWldiRUZPTUxHTHdHREh0ajdEWnl4ekxiMmJGUWRBZ1Mzc1oyTklhbGNa?=
 =?utf-8?B?QjZhSnhDTjV2UStyc2lWNy9kbTZ5V3VjUzk1NXNUWnBmajRxVHlha3VEMEJG?=
 =?utf-8?B?T3NPeWUwRXVDTGt0R2VlRVVEWlBMb3JYYitMcnlvNjBCTmovTm1iZnU4MVMw?=
 =?utf-8?B?NW4ybUJuR2xMbzUzdmxoRnFoQThaYXU3NTczcHBpcVdya2tPVWJTVWFlMzdY?=
 =?utf-8?B?SHo0bmZwKzdBRDJqZVBhTXJDeGtnVVdlUTJUVnNZSVBFNEhmTEUySFZldUdh?=
 =?utf-8?B?SzNmQ3lhbVJnOVlsYnBNM2tZNXBGbzR4UHlKRUJ1ZDhzWklsVFU3ME12RFE2?=
 =?utf-8?B?YjVWRUxTNEVpSlczNzRiQms5WC8yZklueHdrdDNLUm1lVktON2s0Ymd3RHht?=
 =?utf-8?B?aVdwcWNlRFRiM1RLcksyU2hpTzFpb0R3aGZ1K0N3UXhzenRGNDdkVlJWM3RT?=
 =?utf-8?B?ckY0Sm5vSGp2VU1VWVhpYjY4bFJnUzNLRlRBM1FabkFVUUdWNWt1Y2ZWK3BR?=
 =?utf-8?B?Tm5MTWJNbnNsaHRoMjhFZE5HNm0xditPOUs3Z2tzZERSYktTWVR1ZU9TT0Uv?=
 =?utf-8?B?WWlpWmpld0p6cnE4VjhqRnRoalBTSTZTQi8wd3Y1UXZTeThlYVljbUp5d2lK?=
 =?utf-8?B?akdKMG1UdldzY3FxUzFsT0dSdVk5OUNPZ0hoOUFLRWwzdk4yM1E2UzlVVGpV?=
 =?utf-8?B?cmp3NHlCSzl5MDZ3U3BWSjVqVDlCU2VhNUpQTVFhaGhmRVNwVDhpZlZoenpP?=
 =?utf-8?B?N1NSQkgxREVuNHBYbVdEQ2V3LzdjbmZsUytaelR3UHZtVS96dnZtOGpNVHB4?=
 =?utf-8?B?QUh4dWhVbjJpV1B1d3RkTHdhdzZ0aUhaR3I4OU5Sam9wVVVwQ2NOK0NaakNw?=
 =?utf-8?B?bU4wWHplQ0dhWGg4dSswME8weUhKT29MNGtVQT09?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(7416014)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2025 21:53:06.9737
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a17b9154-9040-44bc-f988-08ddc8a0f9ff
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D7.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN5PR12MB9537

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

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/iommu/amd/amd_iommu_types.h |   5 +
 drivers/iommu/amd/init.c            | 164 ++++++++++++++++++++++++++--
 drivers/iommu/amd/iommu.c           |   2 +-
 3 files changed, 158 insertions(+), 13 deletions(-)

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
index 7b5af6176de9..49e02f55c3ce 100644
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
+		return ioremap_encrypted(phys, size);
+	else
+		return memremap(phys, size, MEMREMAP_WB);
+}
+
 /*
  * Allocates the command buffer. This buffer is per AMD IOMMU. We can
  * write commands to that buffer later and the IOMMU will execute them
@@ -942,8 +962,103 @@ static int iommu_init_ga_log(struct amd_iommu *iommu)
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
+	/*
+	 * Read-back the event log base address register and apply
+	 * PM_ADDR_MASK to obtain the event log base address.
+	 */
+	paddr = readq(iommu->mmio_base + MMIO_EVT_BUF_OFFSET) & PM_ADDR_MASK;
+	iommu->evt_buf = iommu_memremap(paddr, EVT_BUFFER_SIZE);
 
-	return iommu->cmd_sem ? 0 : -ENOMEM;
+	return iommu->evt_buf ? 0 : -ENOMEM;
+}
+
+static int __init remap_command_buffer(struct amd_iommu *iommu)
+{
+	u64 paddr;
+
+	pr_info_once("Re-using command buffer from the previous kernel\n");
+	/*
+	 * Read-back the command buffer base address register and apply
+	 * PM_ADDR_MASK to obtain the command buffer base address.
+	 */
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
+		/*
+		 * Read-back the exclusion base register and apply PM_ADDR_MASK
+		 * to obtain the exclusion range base address.
+		 */
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
@@ -951,6 +1066,38 @@ static void __init free_cwwb_sem(struct amd_iommu *iommu)
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
@@ -1655,9 +1802,7 @@ static void __init free_sysfs(struct amd_iommu *iommu)
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
@@ -1821,14 +1966,9 @@ static int __init init_iommu_one_late(struct amd_iommu *iommu)
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


