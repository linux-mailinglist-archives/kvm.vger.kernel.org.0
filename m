Return-Path: <kvm+bounces-36204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 120DEA18946
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 02:01:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 63CE3188B999
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 01:01:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17EBF38FA6;
	Wed, 22 Jan 2025 01:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FvFoqwRY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2088.outbound.protection.outlook.com [40.107.95.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862AD136347;
	Wed, 22 Jan 2025 01:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737507676; cv=fail; b=BLm2fIu/kAa/ndXqtFRgLNk7jy6rtythg+yIdrXPENevvYq3vtEfoJlYsZahwN4y3fOhMQvmP2VzXtjZXqfgXi2SGimF8ZkhSVpc2smNF37f6HR9Ao016TlEpxZkbAaFzN3GnDJUSmycuqSTdAXQfnQAZG8N77s5uVVS4oHiW7U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737507676; c=relaxed/simple;
	bh=zpGaR6EHG5fQfxBeXMMpbMsE069zeSMeHAjT9DdqQO8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WTlFhTHlZAibqBuBZPXwFEYCsIqdYs9wEsGgDHhQeebB1nvUUvQ4DscD03z8Rdoa2EiUYLC/KSIr+5xEAKfx4Rtjf+vld+oQkCKmyu1ZEkP7ra9w+V1q/On0fQIzm00B+UZhow3NHo4C7FDWCbKc7AfvtVT+gJ+uJQwibdwd+hw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FvFoqwRY; arc=fail smtp.client-ip=40.107.95.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AN2KOpahZxx/nhlnuMLWsmaXDq+Snq0kZ+cmV5pWGWR4+UQ+b+EoaAyh0XwCrbdPxwrVxDjOSPtl0DH424X3YPkOxpdCSwgh+U9hjTjXEhlHluZ95BUUOcaIVD7SirEEfdE4OunjmZCysSWsgBmJlpQUUA4UVTL4y0tF4182HvkkIKIhtUaF/Xx/oukbo4I3gd7G4AaK3GPRtUQ6cAVcdybhHBi5pg4Wz0ULVvQRQWXaIIX7rl4nIJxxZ1Lh0KEE7olInbUFXVyPofnOT68VE/Z5LAWbq772rNurFKTefL9Ars0TailTYp8/UKm3wB6mHA2pAfEYXoXR2MACNp5ioA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cAzKFq3HueqHWIEXHbd93DcO2eDTOy88QFga8E6xVa4=;
 b=BMSB+eK/7F6Sk4kiDROEn85X6J1QB3vIz4KVN4qUszxkMML4Vi2of4WtC1hzTJ5nXCCRCmambMWH9qBgM1RyQreyUqahcC0pril+UTkwYLlMmvkCCQhf+1PbSiBE0+ToMS6PwpOzghKecj8kCsqyjkpyzUUeWfh0H/oVwBiBoPShB+UHqqivLVykq0h4uqRREcU3ZVPd8ZJyZJzBjBqqYVrKXXwQf43fbPns7q1EWwsSPgHAMMR6Nwk06Y9MvODNw06ZUZhhUT9j00Q03HPMsEPRsv0WhZtycVI0YyNeMfcb1YpilrzYkM6RDI+E9JC4RUeYJCNdLGFwlgxka2O9kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cAzKFq3HueqHWIEXHbd93DcO2eDTOy88QFga8E6xVa4=;
 b=FvFoqwRYECzfdREcwHBuyO09hAxuVaXLspc48enoC/nm9O+JyHaIh/lPtJc2HaTqN8F70gbERSLxWRaOp9/LxID4/lvlKVcp0q0MGA3hFqDi4bdeZmqfalGkqr4l0SJsyoZ2iLWIVAIMz+wRsM2hU6CFDUyvChiDqitHwPdHAUA=
Received: from BYAPR11CA0084.namprd11.prod.outlook.com (2603:10b6:a03:f4::25)
 by MN2PR12MB4237.namprd12.prod.outlook.com (2603:10b6:208:1d6::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.22; Wed, 22 Jan
 2025 01:01:09 +0000
Received: from SJ5PEPF000001F6.namprd05.prod.outlook.com
 (2603:10b6:a03:f4:cafe::4f) by BYAPR11CA0084.outlook.office365.com
 (2603:10b6:a03:f4::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.14 via Frontend Transport; Wed,
 22 Jan 2025 01:01:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001F6.mail.protection.outlook.com (10.167.242.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8377.8 via Frontend Transport; Wed, 22 Jan 2025 01:01:08 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 21 Jan
 2025 19:01:07 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<joro@8bytes.org>, <suravee.suthikulpanit@amd.com>, <will@kernel.org>,
	<robin.murphy@arm.com>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <vasant.hegde@amd.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<iommu@lists.linux.dev>
Subject: [PATCH 4/4] x86/sev: Fix broken SNP support with KVM module built-in
Date: Wed, 22 Jan 2025 01:00:56 +0000
Message-ID: <6fc4cd0f07f884da4345951670aebff8815270b7.1737505394.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1737505394.git.ashish.kalra@amd.com>
References: <cover.1737505394.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F6:EE_|MN2PR12MB4237:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d72c32d-c011-471c-e510-08dd3a8041c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|36860700013|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KHjy4RQ3ZGjUzyExy0ly/U0NfG844+5XBXGYVYWXhQc7R4djDNAbuPzBmW1K?=
 =?us-ascii?Q?fAOfgUYEHt2xMlz1m0LjIySX9jQ8DZjVxbS6Vl5GIq9SbAHawXa25zJw1VPI?=
 =?us-ascii?Q?zyMqU3hka2ajbtIFIIkYJUN4zLTcLBxO4sTpQuI0jfQw4eRR0SVyd+WEvDV2?=
 =?us-ascii?Q?xcTVqSi9xL89kchcB22leashJDr1pJ+XYHgJ7VJMxrQOFZxuzY0PJyuzsh9o?=
 =?us-ascii?Q?oV8x3bXRHMIvDvb8PpKvt96itsuogML913f9/zmt8J1j++gCQGAQfkuNlU6T?=
 =?us-ascii?Q?dvVS0HD8mxbTPRNTno5XbN6qh0LK4FXwyNmCP7mBIf/+ez6nzxl7zAUM3mrr?=
 =?us-ascii?Q?8cCwKUQim0EkwthxtM5sZNVmnCO1f42cfJcbdWG9FXUMKbFQPFPMNtQaAQNI?=
 =?us-ascii?Q?F1+vYS2Mvf6bBsaN/whPkClj8GN7DtXWSHzSTJQ0X4WkTK/BTH7ZB8TIWPDp?=
 =?us-ascii?Q?vWkfZDfUMdqBmtePRVqxYSspCPQ9xEeDo4dIGfmXzclhnBkQTxPSdQ2A4X4h?=
 =?us-ascii?Q?RJkEwg+sYvQF7LVNxvXOdXChc3Cs8QqItJLbg+2Q5g98Laj2RBnYtt+L+ijr?=
 =?us-ascii?Q?Gcms1ZIwymzdKYp6i68Xwk+F+o/VnFHlxwn8qhJa/1HbzBjpJEHrJjrf05mx?=
 =?us-ascii?Q?teN7TEBAUYZZIgOFRKeogrxRGsLriO8hq/1X+2nwhk/wLwYzvBfXeBgVS8t1?=
 =?us-ascii?Q?THm8WZ84NV9OsJe4Y9u/xiK4uxjCBfRgrEijLp0ZSvg7BGHir9Br5jPmOiAg?=
 =?us-ascii?Q?L0LrYbWkodmFt64dF2SCbQKqkw8wLjfuRalNOfiYwZ2vx4hMFZ9C1HbLVhpV?=
 =?us-ascii?Q?dSes048FUq7H3RZP1o4bLwNgJgce8PURZ9lWdgp/x/4lqDxP7HDVnOhQM33F?=
 =?us-ascii?Q?cFy0HrTje7OEoZdv2Ok/3V7WgdWWL5KK0kf62sIPBSn8YOjU9H6CwJnROz1N?=
 =?us-ascii?Q?rONzps6g9B9XLLp4LsFNf23rHwldRlasulbANsGUzd/Vj3zN0IH0HmjO4kbW?=
 =?us-ascii?Q?JBb2HCfX3rbsW5RJq40a2KTzi8xKmUk4e2TSBYN22TYuqrJAIkOM+mJ//3f8?=
 =?us-ascii?Q?tget5hu35i35/Ku+TULrmhIdpfsoV2fAyPiNEE/3XJ2JTE+4SfArINfIsUiw?=
 =?us-ascii?Q?lugtwsKYhyDpIUnOkwD0poxJH2f4n1yc2RbDDCnlOWd+o/CCMzpz+ujPvShk?=
 =?us-ascii?Q?zs2RjRNbVTMhCIrVuLXoXPD7BbwqQM5EqBcyAK6xmbLnf0yDtKiTGlrQgayK?=
 =?us-ascii?Q?CV8WOGWa756rWZrR164+Loc7/Mfg/ro4mzEvQ+DykLsu7MyT7Ve9vR+IFIfQ?=
 =?us-ascii?Q?m+sDuAhZm9RL2EslU5MV/LnKzuqzbPELMwttmIJ6RX9YYDF/P6NyxWMiDLSH?=
 =?us-ascii?Q?SbxDD0hIYpnZmjEYyIGZrXBqXgdC8crbrfgrOWsZIujpIM4mhHYPycS5nAP5?=
 =?us-ascii?Q?4A9V84Sx8RWD9hgXGBz+M59/kMe+P31TYUGXL6KcqfQte4gYA8s+0Ap+m0JN?=
 =?us-ascii?Q?iYG5eKAJ2p8mAdfgVOf4VKCApM8FdXcCNw2J?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(36860700013)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2025 01:01:08.8669
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d72c32d-c011-471c-e510-08dd3a8041c8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4237

From: Ashish Kalra <ashish.kalra@amd.com>

This patch fixes issues with enabling SNP host support and effectively
SNP support which is broken with respect to the KVM module being
built-in.

SNP host support is enabled in snp_rmptable_init() which is invoked as a
device_initcall(). Here device_initcall() is used as snp_rmptable_init()
expects AMD IOMMU SNP support to be enabled prior to it and the AMD
IOMMU driver enables SNP support after PCI bus enumeration.

Now, if kvm_amd module is built-in, it gets initialized before SNP host
support is enabled in snp_rmptable_init() :

[   10.131811] kvm_amd: TSC scaling supported
[   10.136384] kvm_amd: Nested Virtualization enabled
[   10.141734] kvm_amd: Nested Paging enabled
[   10.146304] kvm_amd: LBR virtualization supported
[   10.151557] kvm_amd: SEV enabled (ASIDs 100 - 509)
[   10.156905] kvm_amd: SEV-ES enabled (ASIDs 1 - 99)
[   10.162256] kvm_amd: SEV-SNP enabled (ASIDs 1 - 99)
[   10.171508] kvm_amd: Virtual VMLOAD VMSAVE supported
[   10.177052] kvm_amd: Virtual GIF supported
...
...
[   10.201648] kvm_amd: in svm_enable_virtualization_cpu

And then svm_x86_ops->enable_virtualization_cpu()
(svm_enable_virtualization_cpu) programs MSR_VM_HSAVE_PA as following:
wrmsrl(MSR_VM_HSAVE_PA, sd->save_area_pa);

So VM_HSAVE_PA is non-zero before SNP support is enabled on all CPUs.

snp_rmptable_init() gets invoked after svm_enable_virtualization_cpu()
as following :
...
[   11.256138] kvm_amd: in svm_enable_virtualization_cpu
...
[   11.264918] SEV-SNP: in snp_rmptable_init

This triggers a #GP exception in snp_rmptable_init() when snp_enable()
is invoked to set SNP_EN in SYSCFG MSR:

[   11.294289] unchecked MSR access error: WRMSR to 0xc0010010 (tried to write 0x0000000003fc0000) at rIP: 0xffffffffaf5d5c28 (native_write_msr+0x8/0x30)
...
[   11.294404] Call Trace:
[   11.294482]  <IRQ>
[   11.294513]  ? show_stack_regs+0x26/0x30
[   11.294522]  ? ex_handler_msr+0x10f/0x180
[   11.294529]  ? search_extable+0x2b/0x40
[   11.294538]  ? fixup_exception+0x2dd/0x340
[   11.294542]  ? exc_general_protection+0x14f/0x440
[   11.294550]  ? asm_exc_general_protection+0x2b/0x30
[   11.294557]  ? __pfx_snp_enable+0x10/0x10
[   11.294567]  ? native_write_msr+0x8/0x30
[   11.294570]  ? __snp_enable+0x5d/0x70
[   11.294575]  snp_enable+0x19/0x20
[   11.294578]  __flush_smp_call_function_queue+0x9c/0x3a0
[   11.294586]  generic_smp_call_function_single_interrupt+0x17/0x20
[   11.294589]  __sysvec_call_function+0x20/0x90
[   11.294596]  sysvec_call_function+0x80/0xb0
[   11.294601]  </IRQ>
[   11.294603]  <TASK>
[   11.294605]  asm_sysvec_call_function+0x1f/0x30
...
[   11.294631]  arch_cpu_idle+0xd/0x20
[   11.294633]  default_idle_call+0x34/0xd0
[   11.294636]  do_idle+0x1f1/0x230
[   11.294643]  ? complete+0x71/0x80
[   11.294649]  cpu_startup_entry+0x30/0x40
[   11.294652]  start_secondary+0x12d/0x160
[   11.294655]  common_startup_64+0x13e/0x141
[   11.294662]  </TASK>

This #GP exception is getting triggered due to the following errata for
AMD family 19h Models 10h-1Fh Processors:

Processor may generate spurious #GP(0) Exception on WRMSR instruction:
Description:
The Processor will generate a spurious #GP(0) Exception on a WRMSR
instruction if the following conditions are all met:
- the target of the WRMSR is a SYSCFG register.
- the write changes the value of SYSCFG.SNPEn from 0 to 1.
- One of the threads that share the physical core has a non-zero
value in the VM_HSAVE_PA MSR.

The document being referred to above:
https://www.amd.com/content/dam/amd/en/documents/processor-tech-docs/revision-guides/57095-PUB_1_01.pdf

To summarize, with kvm_amd module being built-in, KVM/SVM initialization
happens before host SNP is enabled and this SVM initialization
sets VM_HSAVE_PA to non-zero, which then triggers a #GP when
SYSCFG.SNPEn is being set and this will subsequently cause
SNP_INIT(_EX) to fail with INVALID_CONFIG error as SYSCFG[SnpEn] is not
set on all CPUs.

This patch fixes the current SNP host enabling code and effectively SNP
which is broken with respect to the KVM module being built-in.

Essentially SNP host enabling code should be invoked before KVM
initialization, which is currently not the case when KVM is built-in.

With the AMD IOMMU driver patch applied which moves SNP enable check
before enabling IOMMUs, snp_rmptable_init() can now be called early
with subsys_initcall() which enables SNP host support before KVM
initialization with kvm_amd module built-in.

Fixes: c3b86e61b756 ("x86/cpufeatures: Enable/unmask SEV-SNP CPU feature")
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/virt/svm/sev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 1dcc027ec77e..d5dc4889c445 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -571,7 +571,7 @@ static int __init snp_rmptable_init(void)
 /*
  * This must be called after the IOMMU has been initialized.
  */
-device_initcall(snp_rmptable_init);
+subsys_initcall(snp_rmptable_init);
 
 static void set_rmp_segment_info(unsigned int segment_shift)
 {
-- 
2.34.1


