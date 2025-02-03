Return-Path: <kvm+bounces-37165-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3635DA2663B
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 22:57:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C41EA3A3533
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 21:57:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AAFA211471;
	Mon,  3 Feb 2025 21:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="22m0lC23"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2071.outbound.protection.outlook.com [40.107.243.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C668A20F095;
	Mon,  3 Feb 2025 21:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738619829; cv=fail; b=ir+2dSeuMzA83ztZnwV8DFysM1DjHOws23PCRaHsv8CcmewiqKw/BUdW2k/o4XF0kGXg4vl9ewKCENzI6f0lrt8myKJYTmpUgKuB7y5clUofZEn0pqqgdRGCDvDEz5iX9+M7oI5MbCY1nZbc0z8iAwS+PCz1adSpfXDbrkK5C3Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738619829; c=relaxed/simple;
	bh=ahrqolp7y0l6zwOhI4WEBVIA5EZjhj+5vdo9+PA1ND8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hahdHWfnD6XnxBy2XwzbZqDz1ghx0ULMMlWU/nhbqTDwLQ8RUdH/+trtmpv/nele8X9M+pXgMp3Tu5azIOkIMuNMPMlofaW0Vt0SsOc5f+prWawuJOq+6LClI4Kg/JXFi4xpm9Pa3g7rqn2cG5JHTYcB+CEBojgmAEduizj9ysw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=22m0lC23; arc=fail smtp.client-ip=40.107.243.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OdgKfQ25LBnhQ/w2bRqpvXO2LIF5lTZHApYm3vhRu+JLnzp97OjVXo36c8Ebcqb0jDEExirzRvpIBiqBeYjOJ8MYgBX8JpJCv8GY0hZFDpn11p8paAKNU1GqlyCctcar3qeiFdiGILMazNB8mC/jS7BZ3ao1fs/6pwyRSSoPEwoOoep7Vx/2/JMl9eTFicOeHt4XZFF6+yHHTPNFtJDoXQ0X54Yc952FM4Gv9FEiyyQBabh0KL7eyHz9Ov2Qp5CNBpLnprH9Ok+/R7Fn+/DfCVPtTDDRUVz9laLtqTlnQZX621Nb96xENwizd+kqq8E71k+Nt3cl+GqN2AzmpXn5KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LatrBRHu+6oGbrq88UsvfgNG9DsjJ+lIC91l85VI8ZY=;
 b=xxhD/VaLhfSPjKbrNM1c3PDGfTM1wuKHsBfsnFlgBspmoG6S7ZKh8ZePNd9R4xTTs8GF1pIxj0h6i0mdZkVBAUGz/o3DyTA0wp5MdqBn2xCu2BUVyM8Mk85O/u2jlgrKrdSgw8merhtaOpud3rPeAj1cX//matPUZT74Wqr+dRyVnE4YWa2KaN/F+OmEOcHLd3kMVw8h10DQCfr+bMzCFwb+7MnkvgyfiR7by6oCDwDs+1tIcCi6r9Pq/domQNtExflWqeva1V1bmZKTs4faBX2dcYRecTU26rqYuMUFXyanw9udrwKLNiPErocoMI5dPFwZ9dqxeZVIrlLzfWNB1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LatrBRHu+6oGbrq88UsvfgNG9DsjJ+lIC91l85VI8ZY=;
 b=22m0lC23+B0z3CispEtGbByeAAsO53KqU7VOoIBHdfIUqZBtxeHn67TJk4JItSWWorneoy5qmPw8yOQ4kuhzD62ZJ822rzuf+gTUAauKUq72Kbh3JhvIJRjbNGZma+Nn/dnsfPKAaWMdwvG+BwKxjEgi6mJ78GfhoNLdJepuxaU=
Received: from CH2PR12CA0006.namprd12.prod.outlook.com (2603:10b6:610:57::16)
 by IA1PR12MB9061.namprd12.prod.outlook.com (2603:10b6:208:3ab::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.23; Mon, 3 Feb
 2025 21:57:05 +0000
Received: from CH1PEPF0000A345.namprd04.prod.outlook.com
 (2603:10b6:610:57:cafe::d6) by CH2PR12CA0006.outlook.office365.com
 (2603:10b6:610:57::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.24 via Frontend Transport; Mon,
 3 Feb 2025 21:57:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000A345.mail.protection.outlook.com (10.167.244.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8398.14 via Frontend Transport; Mon, 3 Feb 2025 21:57:04 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 3 Feb
 2025 15:57:03 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<joro@8bytes.org>, <suravee.suthikulpanit@amd.com>, <will@kernel.org>,
	<robin.murphy@arm.com>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <nikunj@amd.com>,
	<ardb@kernel.org>, <kevinloughlin@google.com>, <Neeraj.Upadhyay@amd.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<iommu@lists.linux.dev>
Subject: [PATCH v3 3/3] x86/sev: Fix broken SNP support with KVM module built-in
Date: Mon, 3 Feb 2025 21:56:53 +0000
Message-ID: <e9f542b9f96a3de5bb7983245fa94f293ef96c9f.1738618801.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1738618801.git.ashish.kalra@amd.com>
References: <cover.1738618801.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A345:EE_|IA1PR12MB9061:EE_
X-MS-Office365-Filtering-Correlation-Id: 373032de-2816-4f85-552e-08dd449db241
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|7416014|1800799024|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SVRBcBKKcvPGS5MywMmXXfCtEVTaOK7B75t9QAZm4Cm3HmOAnAcK9xD7qQLd?=
 =?us-ascii?Q?2jWP+TBonqNet81Hx0SUjRcLES2rTohezP+zeRbyF/SEU0bz+cPsuz3fkOLz?=
 =?us-ascii?Q?xCiycTBPQEOWqgezG7/OfMyGeVi5tzWjr+PDMoqJHBh/av+bA92uDTTNzW9U?=
 =?us-ascii?Q?MrHEL2aUJQ/Uf5SBwf63eSotBSx05YmLxepgzQJprA1jmh28795JbELyvwFu?=
 =?us-ascii?Q?Kzz2C4tUMeZlomgEHBRJETMLvcvm4cEVRGeXrl+fpvwiTbM60DuJDxYv3s+1?=
 =?us-ascii?Q?UGgCPA/uYkQwY551yyaywPKhY1mXJX46txei+mgRUSDi9RYVLrAnA9Rd01Bi?=
 =?us-ascii?Q?kwcMuDRW2RZ/G6w3xGHL4IjF8GmyGot/J2C0610LTLcX39QA28CTCyq+F4oy?=
 =?us-ascii?Q?ifvfGn+ks6vJ6KkTxGfjSrLF/RjkagV7e05rhEUzgxFKIikOvoT3TEDp+a7C?=
 =?us-ascii?Q?YwUri/lGNeKFQ3TDaK7Kc9A7GyWydbEIlC/gjRYyr+YSy9xkk7H+JsA4OJ8g?=
 =?us-ascii?Q?FXum1gZw9PK99HUBpHVXBHDfsO/t4GCr2Qkc+X2yD77s5xynZ2rT2QloUVR+?=
 =?us-ascii?Q?wqH+HSUOdqy8RyZBGbbm3D7jhgXaUcc0s+7RRbJQ0Qn5o8mPGqs7GU9zOUjS?=
 =?us-ascii?Q?Tn2k0G7QWw+XUX1QCNY8TA3JaFIezkKKXQAO0baL7bYTa7KEG7EKXKQdRVjl?=
 =?us-ascii?Q?82EksSNcour0yaVyjzlF0NrGFxGKhqg5CtwdFjyKhPzqevj3GvnWyjL8jxvX?=
 =?us-ascii?Q?Kr7Ac3m0KJnXum2tU8pJTUxLeiBYzRtzNAgiBbztOgLNIJigM57vsfiTnMsd?=
 =?us-ascii?Q?/3MDRWfGMFVIUWXwjw9kks+ceV17iT68KUYc9EKb9CMNVoCXfxN6gtF2ip6E?=
 =?us-ascii?Q?0lv5g0zPeAVBizLXoxSBn0cm6UEnjVXa6KRh5VmwoZBeh+beCoXQBwTOrsev?=
 =?us-ascii?Q?KqcRXtH57J4cnivbD7dog3fiKesnG8ny7m2ErQQWoD3aGOaL/Inqan8HlEDq?=
 =?us-ascii?Q?sJnstgBU/5fgdA880kWLj6lfc1Qcc0pFvqqtnX4ZeyBgqWlcxaTxcdX+1EPQ?=
 =?us-ascii?Q?48fst146SH64lgI8ApVwLKm8t/Tzs3FBGIxcE4XnRrXe9S+D/Xrt1Al5/46f?=
 =?us-ascii?Q?X6ICZP0yHI6H8s9ar9xlCuaHpxW8xK8E/S3cQXdBBA2v3p3XOQRkycSBspQE?=
 =?us-ascii?Q?FKtCo7jfTHdQ12pjujDcMX5cwMP1cJMm8RkFJXsSIdyR5/M/1whLfb9SHcsm?=
 =?us-ascii?Q?WHyoe6zdBWVNXEuaJdaO2LFcgUJj9HF5bG+lrQ0vsqcOPru+W8LXpEKyOEbN?=
 =?us-ascii?Q?YWJCKgWSigYrbADM1+3/xAJcEQLTkhKS5NIU8029q2s/i75WcWQK36BRQ9s2?=
 =?us-ascii?Q?7mbWpLHT+I1eWzfYfBVvTRqCBRULFBncn4b55Zz7LI4FnU9AYAeeBypSL4RN?=
 =?us-ascii?Q?YOhns+a57A/s9qtWUAy/NsBNwSvQ9fBnrFwJbWsTY/ZvCmmKGIKbd7pbRESn?=
 =?us-ascii?Q?eg/GG1NFZGdZf6HgNT6mrotjpoV8rK1qUMX3?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(7416014)(1800799024)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2025 21:57:04.6721
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 373032de-2816-4f85-552e-08dd449db241
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A345.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9061

From: Ashish Kalra <ashish.kalra@amd.com>

Fix issues with enabling SNP host support and effectively SNP support
which is broken with respect to the KVM module being built-in.

SNP host support is enabled in snp_rmptable_init() which is invoked as
device_initcall(). SNP check on IOMMU is done during IOMMU PCI init
(IOMMU_PCI_INIT stage). And for that reason snp_rmptable_init() is
currently invoked via device_initcall() and cannot be invoked via
subsys_initcall() as core IOMMU subsystem gets initialized via
subsys_initcall().

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

Essentially SNP host enabling code should be invoked before KVM
initialization, which is currently not the case when KVM is built-in.

Add fix to call snp_rmptable_init() early from iommu_snp_enable()
directly and not invoked via device_initcall() which enables SNP host
support before KVM initialization with kvm_amd module built-in.

Add additional handling for `iommu=off` or `amd_iommu=off` options.

Note that IOMMUs need to be enabled for SNP initialization, therefore,
if host SNP support is enabled but late IOMMU initialization fails
then that will cause PSP driver's SNP_INIT to fail as IOMMU SNP sanity
checks in SNP firmware will fail with invalid configuration error as
below:

[    9.723114] ccp 0000:23:00.1: sev enabled
[    9.727602] ccp 0000:23:00.1: psp enabled
[    9.732527] ccp 0000:a2:00.1: enabling device (0000 -> 0002)
[    9.739098] ccp 0000:a2:00.1: no command queues available
[    9.745167] ccp 0000:a2:00.1: psp enabled
[    9.805337] ccp 0000:23:00.1: SEV-SNP: failed to INIT rc -5, error 0x3
[    9.866426] ccp 0000:23:00.1: SEV API:1.53 build:5
...
and that will cause CC_ATTR_HOST_SEV_SNP flag to be cleared.

Fixes: c3b86e61b756 ("x86/cpufeatures: Enable/unmask SEV-SNP CPU feature")
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/sev.h |  2 ++
 arch/x86/virt/svm/sev.c    | 23 +++++++----------------
 drivers/iommu/amd/init.c   | 24 ++++++++++++++++++++----
 3 files changed, 29 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 5d9685f92e5c..1581246491b5 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -531,6 +531,7 @@ static inline void __init snp_secure_tsc_init(void) { }
 
 #ifdef CONFIG_KVM_AMD_SEV
 bool snp_probe_rmptable_info(void);
+int snp_rmptable_init(void);
 int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level);
 void snp_dump_hva_rmpentry(unsigned long address);
 int psmash(u64 pfn);
@@ -541,6 +542,7 @@ void kdump_sev_callback(void);
 void snp_fixup_e820_tables(void);
 #else
 static inline bool snp_probe_rmptable_info(void) { return false; }
+static inline int snp_rmptable_init(void) { return -ENOSYS; }
 static inline int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level) { return -ENODEV; }
 static inline void snp_dump_hva_rmpentry(unsigned long address) {}
 static inline int psmash(u64 pfn) { return -ENODEV; }
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 1dcc027ec77e..42e74a5a7d78 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -505,19 +505,19 @@ static bool __init setup_rmptable(void)
  * described in the SNP_INIT_EX firmware command description in the SNP
  * firmware ABI spec.
  */
-static int __init snp_rmptable_init(void)
+int __init snp_rmptable_init(void)
 {
 	unsigned int i;
 	u64 val;
 
-	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
-		return 0;
+	if (WARN_ON_ONCE(!cc_platform_has(CC_ATTR_HOST_SEV_SNP)))
+		return -ENOSYS;
 
-	if (!amd_iommu_snp_en)
-		goto nosnp;
+	if (WARN_ON_ONCE(!amd_iommu_snp_en))
+		return -ENOSYS;
 
 	if (!setup_rmptable())
-		goto nosnp;
+		return -ENOSYS;
 
 	/*
 	 * Check if SEV-SNP is already enabled, this can happen in case of
@@ -530,7 +530,7 @@ static int __init snp_rmptable_init(void)
 	/* Zero out the RMP bookkeeping area */
 	if (!clear_rmptable_bookkeeping()) {
 		free_rmp_segment_table();
-		goto nosnp;
+		return -ENOSYS;
 	}
 
 	/* Zero out the RMP entries */
@@ -562,17 +562,8 @@ static int __init snp_rmptable_init(void)
 	crash_kexec_post_notifiers = true;
 
 	return 0;
-
-nosnp:
-	cc_platform_clear(CC_ATTR_HOST_SEV_SNP);
-	return -ENOSYS;
 }
 
-/*
- * This must be called after the IOMMU has been initialized.
- */
-device_initcall(snp_rmptable_init);
-
 static void set_rmp_segment_info(unsigned int segment_shift)
 {
 	rmp_segment_shift = segment_shift;
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index c5cd92edada0..4bcb474e2252 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3194,7 +3194,7 @@ static bool __init detect_ivrs(void)
 	return true;
 }
 
-static void iommu_snp_enable(void)
+static __init void iommu_snp_enable(void)
 {
 #ifdef CONFIG_KVM_AMD_SEV
 	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
@@ -3219,6 +3219,14 @@ static void iommu_snp_enable(void)
 		goto disable_snp;
 	}
 
+	/*
+	 * Enable host SNP support once SNP support is checked on IOMMU.
+	 */
+	if (snp_rmptable_init()) {
+		pr_warn("SNP: RMP initialization failed, SNP cannot be supported.\n");
+		goto disable_snp;
+	}
+
 	pr_info("IOMMU SNP support enabled.\n");
 	return;
 
@@ -3318,6 +3326,9 @@ static int __init iommu_go_to_state(enum iommu_init_state state)
 		ret = state_next();
 	}
 
+	if (ret && !amd_iommu_snp_en && cc_platform_has(CC_ATTR_HOST_SEV_SNP))
+		cc_platform_clear(CC_ATTR_HOST_SEV_SNP);
+
 	return ret;
 }
 
@@ -3426,18 +3437,23 @@ void __init amd_iommu_detect(void)
 	int ret;
 
 	if (no_iommu || (iommu_detected && !gart_iommu_aperture))
-		return;
+		goto disable_snp;
 
 	if (!amd_iommu_sme_check())
-		return;
+		goto disable_snp;
 
 	ret = iommu_go_to_state(IOMMU_IVRS_DETECTED);
 	if (ret)
-		return;
+		goto disable_snp;
 
 	amd_iommu_detected = true;
 	iommu_detected = 1;
 	x86_init.iommu.iommu_init = amd_iommu_init;
+	return;
+
+disable_snp:
+	if (cc_platform_has(CC_ATTR_HOST_SEV_SNP))
+		cc_platform_clear(CC_ATTR_HOST_SEV_SNP);
 }
 
 /****************************************************************************
-- 
2.34.1


