Return-Path: <kvm+bounces-53760-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DF0E7B168A1
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 23:56:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A75204E71C0
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 21:55:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A7D32264B0;
	Wed, 30 Jul 2025 21:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dWiDzrKa"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2079.outbound.protection.outlook.com [40.107.237.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC052253A5;
	Wed, 30 Jul 2025 21:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753912563; cv=fail; b=Ue25Jqyi8WqmzjUAHo309zjBy9n3UTXYZJIq//fPKUyx+tWlLSRaK+CCY1IPphV6uaFLspmaN2o/6Dp63Yyjs6lAfSpFiWjGgBrRFEpf35y0GkuNjfTpkLzA/ntY40NN8QoITYaw9fPdC4QhB/9o+xLoGxIGQ0/KNBhaBDiFzss=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753912563; c=relaxed/simple;
	bh=OcH9X7dq/I+HW23IiRDmWVmAruIfxwuNfvTYCGUZpvc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JAVZny9L0PQAXDvkC9mKaLFFdDForVeauJF0iUc/L7WjplbxsAVkNhfoaOOYcwLa0BWKKRA9RRMQkyRThaeE8/z1kZEp70nhVbOoBVfv/aT/48VQlI/uPzVnVa+hGzi8HYLD8yhoBVZja9LFMO1yBkJxsCgZenQdhFvNDw00FDE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dWiDzrKa; arc=fail smtp.client-ip=40.107.237.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IWcAE+MkZYIxuBgIN6rtM/kCdewCu+K3FCxNXJ8j6b9F9CnbkhGPw+rUHs75yjreeprvFTrFPfjNgnJEDj0Z7cGPUcfjlLzptiduiU+Ki8TwVUu+M+eVqjFI+GXYMSvKKHVffA8r7/ImNsrhZdrBa1/EQNokeCYNDQL5VA8xRwiCt5RQ5wsa2S0Ktag/lznAxFCEj1492o+cGzTmrGYlItgSej1sXYPQ0emIahOx9hDXJWDhdE84kpeR1ThLx2enEBFmhR+IrKotpJHE/ShqfCNmG9SifoIAneMj6xOs7bxvDwvjzLPzP8Hsj30YMztzaC2cdSm62pcTpGzKsG+Eug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UV/pvAIfGzSn8e8K9qgx+dRToXHMgz8oND1CxjcvJlM=;
 b=a3XpeR2zTXhh7Y8r9BGlMnAMX14J/QmPZDSnJrTIXJ5qcHYUxMbdD1+kzKo3HbEo+uMJxjaW2n08lCBHYOZYiJIm2/6FUQhzsHV3ZOWT+PCe9iIr4e6nfGrwKpmqsAAMMEUERSeZc124f2p/vUEDOT64uQfn6sQrYKxiYBo8wxermta0QXP6Qez6yNkYphAeEsybp6gEv8OZERiVq2GAGnsSnamCfRW/JtcBJXbQ4h0sl1A67l1VrN75/kEtxlZUoygAHKU5rS7/ZgY0nyOWk0IgsEG8RUh/VTh6gOvj07PS4+ok4rv4jR7yzpQpFW5uOjaABbiTepHltyvyknF05w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=8bytes.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UV/pvAIfGzSn8e8K9qgx+dRToXHMgz8oND1CxjcvJlM=;
 b=dWiDzrKa9jeXohh8aLAbPt5vTXPLI/kubRIr+pbpPz4rVbfiZOzbZyWyiQpWEINyryQBdbTt1yJxU0ikEkVAhgOnyCzui6ekhJg+X7SI9395+U/Ct3fped/onHoMvHWMQo1jYgee7EgamM3fG1P/LfFGWx9NegCWN1eQvLBKL/0=
Received: from BN1PR14CA0021.namprd14.prod.outlook.com (2603:10b6:408:e3::26)
 by IA0PR12MB8376.namprd12.prod.outlook.com (2603:10b6:208:40b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.26; Wed, 30 Jul
 2025 21:55:57 +0000
Received: from BL6PEPF0001AB78.namprd02.prod.outlook.com
 (2603:10b6:408:e3:cafe::c1) by BN1PR14CA0021.outlook.office365.com
 (2603:10b6:408:e3::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8989.12 via Frontend Transport; Wed,
 30 Jul 2025 21:55:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB78.mail.protection.outlook.com (10.167.242.171) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8989.10 via Frontend Transport; Wed, 30 Jul 2025 21:55:57 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 30 Jul
 2025 16:55:56 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <joro@8bytes.org>, <suravee.suthikulpanit@amd.com>,
	<thomas.lendacky@amd.com>, <Sairaj.ArunKodilkar@amd.com>,
	<Vasant.Hegde@amd.com>, <herbert@gondor.apana.org.au>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <will@kernel.org>,
	<robin.murphy@arm.com>, <john.allen@amd.com>, <davem@davemloft.net>,
	<michael.roth@amd.com>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<kvm@vger.kernel.org>
Subject: [PATCH v5 1/4] iommu/amd: Add support to remap/unmap IOMMU buffers for kdump
Date: Wed, 30 Jul 2025 21:55:46 +0000
Message-ID: <d1285938266d753b9d215e7c649126d261208143.1753911773.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1753911773.git.ashish.kalra@amd.com>
References: <cover.1753911773.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB78:EE_|IA0PR12MB8376:EE_
X-MS-Office365-Filtering-Correlation-Id: d0230620-6a6a-43d2-f1d4-08ddcfb3dd31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WmxXRlBPZitRbENnUTNmMmJSbVd5U0RwUlRES0RkNkNOK0pGWUhCK21TS2RM?=
 =?utf-8?B?azFQaDJza3BmV3lFN0FzWThMaSthcFA5VEYrd24rUkpOSVpNZ0kweTBDSnp1?=
 =?utf-8?B?UEQzM0ZzWUV6c2haeDllSVVhbmEycC96UFFxOFQ3TzNlN2s3c0pzaldEY1V1?=
 =?utf-8?B?V2pPczNVc01HWUNtQWtwTVhXTWYvRXptUEhGRjBCaUl6RCtFdjIzY2oyZ3lW?=
 =?utf-8?B?WEJSVXh1a1pCeGxoVklseG8zU0ZDbUVaYzJWT0grRWh2ODBpaDBnamlENHhH?=
 =?utf-8?B?blhJL1crbXpSQms1Yks5bkE2NVNMWVVRRUwxdE1hLzNGK0hPalVETlpsREZZ?=
 =?utf-8?B?OXMvQS85ZlhMMzN1U2ZiQmUvcThjY2VBOUhUL05VOG9XYVVQaW83d0hCOVFD?=
 =?utf-8?B?YlE1eG5rVXNmQ0JaWkQ0bG9yQzhvOHdJcU9iVjBVZDZzblMrVzVuMitOYmo1?=
 =?utf-8?B?ajV0Rk53a1lmb0FoS2Z6UWpZTjdHUWtTZmRHVnRmcGhFNXFhamZvSjJhcVVD?=
 =?utf-8?B?RzUrTlJmUXBORDBSSHFZRURBMGJRQ2ljeUFKSmRqUmRRaHdCSGlDTGZoejM3?=
 =?utf-8?B?TG14UnVpbURScVkrU3pRTzcxd0EzbmNqVzRxUjJvbXNsZFBscWxsLzQzRHdj?=
 =?utf-8?B?MHZOUjlNTTVua2RBYU42Qm9rcWJNNnNsbXV6RzY5K2EwMkwvY2VVc0ZSL08z?=
 =?utf-8?B?dytWc1E1N3VQNXl0UTBac2REbDJSNW9DK1NUaVFnVlJHbnUwRzd1UXV0SE1m?=
 =?utf-8?B?UjBhWFhsOWhwSXVrZ09BRG45SmhMT1R4QkFKZllaZmxtdHFMUTRMZXNxT2dm?=
 =?utf-8?B?UFFmc3hKcndxNU81bUpSZCt3SklFbXB5R2N4ZGxNUlpnaHM5ZDU3UmsyNnFj?=
 =?utf-8?B?UjJmZHV4c0xUaGtqdWcveDFmOUh6THJDSFlZd09Ld3JHZHpoNzRBbjhTMFdQ?=
 =?utf-8?B?TmdWN2RBOUdqbm5jOCt4NE9rODFqUXkxaVBudy83a05JWmIxekMxRWZaRnBw?=
 =?utf-8?B?Q3RENnVLcVhNZnBWU1hKRjZ4ZHpBY3RCekVQaVBPTUtvenlrbi8zaUJLeWpL?=
 =?utf-8?B?QWZVS1NndGlVQVJyd3pJaW8reHhsajNTSlYxMFRGYWMvbW1sMUIxOEpJRmQr?=
 =?utf-8?B?aHphbjErczZhOTA5QmZGb0tmbVdQaTNtSXlFQ0pEMENpQjJRNk9ob2NselNr?=
 =?utf-8?B?S2dSalZXRXplbDZlRjFwTlM5dzNVMFRNSDI5RXNNSTY2ZjU3cWtEWHVTdlk2?=
 =?utf-8?B?Q1pvWWwvanZPekt0VWRPOUsvY3pzWE55WG15dFprQUdOeG1sOGFUM0tOalFG?=
 =?utf-8?B?dzJSakFmdnpmUUZBZktuVEpjNHFEODJxWHF5SE5KMTM3bmt6alR2N3pVdERa?=
 =?utf-8?B?bXp6WWF5ZERwa3R2eHd5MVAyZWhGRUM1ZUozS2oxUEVZYkxxTStNVndhUUFQ?=
 =?utf-8?B?MEQ2b3llS1NFYXFOYUpXWjBRY1lKN1REYjBOWmNUMXB3S1ZsYjE2cWF5emdD?=
 =?utf-8?B?ekZ0MlFKS3lybzMzL2c3TGh1UVN3YWlhMFEwNVVyRlhZQ0RFcVlCdXdsMVBy?=
 =?utf-8?B?YlhJOGo2bW5sUU92eGJDY0FjNFRUOUp0YzVRVFZIaDZMU253V2E2a2lYRlNl?=
 =?utf-8?B?d2JwNzdoRHJweXNLWnk1anRNNEsvQnZ6RmhOUEhuaFo1emdHT3Zja1FMRi9a?=
 =?utf-8?B?cHJOY1FWRU5iTHB6U3R4VFNGR1ZlRElKRW51MmliejN1WUc1c05IeWlacVVL?=
 =?utf-8?B?M3lCREh6Qno5SmJFR01RcEhlazlzV2dGaEQ2SjBNNXppbFEyN3JMdEt1UTdT?=
 =?utf-8?B?VjVnWmtHSFVHcjZXY2NKcTlsQjZYOSt0RFBCdnpqbWdrWU0xTjBIczJTNkJU?=
 =?utf-8?B?STFhVTlmTUQzRVdldlZZOEVnenJKekRYZDJCUU04L3Q4cVVBcnpLZkkxUVRK?=
 =?utf-8?B?M2Fza2psTEtIaW1MN203bC90WHNSenhPR015ejFaQk1pTjBFQjN6VVQwVitz?=
 =?utf-8?B?TmJ6UVd6Y3EzWHVjcFkxNHBkeVp3T2tob2pXZUFGZ0o5MXhYcW5NMWx2WHo5?=
 =?utf-8?B?KzRITmRubmF4cjRFU3FrZ2VFTUlQRW9sZnV5UT09?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2025 21:55:57.3173
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d0230620-6a6a-43d2-f1d4-08ddcfb3dd31
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB78.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8376

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

Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
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
index 7b5af6176de9..aae1aa7723a5 100644
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


