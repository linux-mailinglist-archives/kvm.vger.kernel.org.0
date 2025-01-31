Return-Path: <kvm+bounces-36958-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 31DFDA23885
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 02:11:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E28A1888DE3
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 01:11:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 964611F95E;
	Fri, 31 Jan 2025 01:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JrsxfvXM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2046.outbound.protection.outlook.com [40.107.93.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B7211CA0;
	Fri, 31 Jan 2025 01:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738285895; cv=fail; b=FvmrE6vXPOdI+HaVuTUvv1LEgxvrFVmmft3iugazANFOlY3Bme0+YimuGHPzyrW938odr2xmMXk4f/x45Ib025tzJQDL59FeDgoUVCrtA5NkeAU+P7tmqZ7a1EIuXWlf/dI2ELzMr1iaRj6+P4UPZ8QPMpGZAgUdYmEPHgyYfaI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738285895; c=relaxed/simple;
	bh=18VFga2A8U+f99oeKM021zUOftlyBdM23l5rIu2JuuE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mHN/bFCY1k+6csr/fjcaIJNEI9wiLKv+IGRwbKR8RWxSKBDJzkDtb5inV4cCp5r2RU0p+p20mn6FSgPZh267VheeOekLvqEkEy+M/PJROZmHzkOk8fU5/9+OzRtuR2Kv8qGX9xk4LA8Bxtt8aiBwx7HAWy6GST4t0ujvL7F/UuU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JrsxfvXM; arc=fail smtp.client-ip=40.107.93.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YXuwg2gv+oRvmMEWmjmUUh73ujl5Yk4U7qWZXbDv9SewdRhCiAla+u/mYHEb+CEal4tqBo94BqjMlay1TY40hQ4zutRoiNkpo0sY7rSCPSggOM7m/swh1XbwGXbQ6T6JClJgXnOkvBbj09ZouJ/f1uJjDiLEgT7+7jeXmzcwp12rOlPkRB77Nozt96UC29LAHEojFEnVYK8CRNzxXmoADXdwwjVVCmc5AHb8LsLlkM8JZ1ExJVyqmMr2mRTjLrxwU+HnqL087btg2uFp+cEdhsH+CRV45LjIBipBJufdcvy9CN7+J183TXn07ER5XwwnqjPdYG6nKuTVDQroioNGqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HtivGPbnb883clbG9t0WfS7v7VES/bz2yFmdZ6WXJAk=;
 b=l7eAKJfKkNANekKkvOhNXJTGjjiMnob5Qp/gcSzkKRny6XbP+bC/BddBvWIhei5t5p7x3DFcUZ413jyMAh8vAA3JqO0yKoBRVkvQtZs97Mc8bia7UnhdZMzdNA2Hf6PPue5VDnJ56Q1w1NKpUP97PKzIcNlqI2oSnleCYwmGSfvbGCI7c7qkqJG20mlJdsxnSC+Dbd4NiaV6waK/rgHrjctz9AfqkG3k2fVlRI5kQTVao01TcdBgW/w+0UO7x79uaTC5IgnhmDegJh/ghIp4b9NOzzYakGLKU3JQy+St1fnVyDGgWgryZeF+E1slS46fMhXudwbvbFWDKraxYHTtQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HtivGPbnb883clbG9t0WfS7v7VES/bz2yFmdZ6WXJAk=;
 b=JrsxfvXMvwYw5O70cqVusCBfB8HyJfbTarG+HUUwp8qvZAPeeT5ny/2Y49hhHUskkQDPuvGunx25tennHvdFNq2DcJecjafCwHztT26vdCqTCcv18TIGxpmmdSBEoKRkPB936NKjGzmQID7BCWizSIQcLjRro6pnpq9wGkajaYk=
Received: from BY3PR10CA0028.namprd10.prod.outlook.com (2603:10b6:a03:255::33)
 by SJ2PR12MB7866.namprd12.prod.outlook.com (2603:10b6:a03:4cc::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.17; Fri, 31 Jan
 2025 01:11:28 +0000
Received: from SJ5PEPF000001CA.namprd05.prod.outlook.com
 (2603:10b6:a03:255:cafe::c4) by BY3PR10CA0028.outlook.office365.com
 (2603:10b6:a03:255::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.18 via Frontend Transport; Fri,
 31 Jan 2025 01:11:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001CA.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8398.14 via Frontend Transport; Fri, 31 Jan 2025 01:11:28 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 30 Jan
 2025 19:11:26 -0600
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
Subject: [PATCH v2 3/4] x86/sev: Fix broken SNP support with KVM module built-in
Date: Fri, 31 Jan 2025 01:11:16 +0000
Message-ID: <8f73fc5a68f6713ba7ae1cbdbb7418145c4bd190.1738274758.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1738274758.git.ashish.kalra@amd.com>
References: <cover.1738274758.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CA:EE_|SJ2PR12MB7866:EE_
X-MS-Office365-Filtering-Correlation-Id: ff4b437b-9deb-4ef9-25d3-08dd419430b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|82310400026|36860700013|921020|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yZFS5pQUMbDVIPMM6bIvE/7HXY77xV3oTeSIlzCl5dIGCBvGJcM26TXKUnCg?=
 =?us-ascii?Q?DBAAgXJYi9hcfYmvxtCAfnjBI8l9SnRSyuZTdyPWwc+rSTJcekoQIlHxezmq?=
 =?us-ascii?Q?mUHDtEbrRPxJNt+GkOF1subjBb05LyBgOFa/ckFPva2Id2B+4a3HI8q4QaIA?=
 =?us-ascii?Q?NK1HWqevx/IAQTnzGYnxXCHRhyUHYigummCxTOfy4vCi9mhTJxc14jBufgL7?=
 =?us-ascii?Q?tK/4KBRj8+uKfRi0d1PR9JJQnCwsV09Cb8i1YtRoZTkAftTdobqfrl5hKDJc?=
 =?us-ascii?Q?mxnBCQ+qpEFLSUus5HPOjFnDkT21lvTa2Hwg81a9wnarQvR38s0eR18jnEVB?=
 =?us-ascii?Q?dyJnJm0ldOh/fkXZ6lRGtQR0qqP7jzhyW7j8+iH6Fqx5gNHjdGgxFrkeJxIu?=
 =?us-ascii?Q?/hajxVg7vLgKn2dDmWbc9L8l+IqcUHlat8BRdxVLjFewIBAG1AKsRI3IYPiP?=
 =?us-ascii?Q?/b87qeB+JarkT3DQQ94607vhoiARmbVguZpuNlSSgw0Elj8zVSZhmNE07N8B?=
 =?us-ascii?Q?5+v25BbyV6D56+e5TjbzcZOMq6mv3INLVGtk06u7SMLqpEktu4wQ+ODr+CaV?=
 =?us-ascii?Q?qEaFJ8kcQ+nPfmSfNJh+pgVpe78avie8ylbIUB02lKomfGjQY9qEIFOROdGq?=
 =?us-ascii?Q?mVCBtxupOkhX5OQgbRGR4PFRSr32S8cq9uofl3/HN72/27mw3WhNTMEMo7gk?=
 =?us-ascii?Q?HRqOai4beJNnbrDm+EUk3yu7aHLdkQWxDwPWexQo+60kweLnCjd4UUbUvokd?=
 =?us-ascii?Q?PS22LoWpy3g5chSCSFxAZZTkxoveECR4La3vMEmMZmA6dj4bmYeEPUSrtmy0?=
 =?us-ascii?Q?pdwSN9m0VaE52Rue6v6yMks2DGycmGDeT4BXRgB8n8g2+vWQNfJUnECJrGkr?=
 =?us-ascii?Q?d7v0UboOogbPveJ3hdVX8CumjWo9isvS9nPXE/yBdvzrNpMP21emkk1ECuxu?=
 =?us-ascii?Q?uiUSwckOxMtTkGHDpcaulchmwLhNagBWbxMRFqyxox697VPWb08ktPHiY93+?=
 =?us-ascii?Q?6uDmGMc2KKfML+rHhluINMg3BVR7JmACAJDYl/Vm1gK71H8qJH1UU+fK9Snu?=
 =?us-ascii?Q?59DAEeBIA/H+tsqFSEUghnRsE3DZ0lJAv14BqYg0phPUSkYQa8R5CQMeAIlS?=
 =?us-ascii?Q?rHn2bkT766Eq4hQfYQ8oL8R59hMDznqMH4ZTCzTIrmaPrqnEFaZAFWo4EzvL?=
 =?us-ascii?Q?dOvvRoP+1kd6ZCKCS9IKcd8o/zut0EJgDxv1RxY/JvvrjsMHmutXFZY5ujtq?=
 =?us-ascii?Q?BDzyKhDKoHRcBqX7VrS+2P1Ubt9zquJNnIW63qM+q9LEcs43FRtkut2yToTP?=
 =?us-ascii?Q?j735v41uJ1Wm46Qey1uzrCcWXT7iZqtuAUXJNL8FocEdxBlYiHetGsi9JDt+?=
 =?us-ascii?Q?Aah9er7SJOq2PIAnqJcrzUgb703rBsvZR3FEObl7GKFvQpsOKx+o0Geec1Hr?=
 =?us-ascii?Q?ahC8oYqYUUa6FvX89G+px+iTOvuso4cm9FIM6u3h8i46bXmutVBWcF43/Ysd?=
 =?us-ascii?Q?LgiYZ6ZA+XE9PeeALq9svxYvO9Yve7URgEi+?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(82310400026)(36860700013)(921020)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2025 01:11:28.3321
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ff4b437b-9deb-4ef9-25d3-08dd419430b9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7866

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

Now, snp_rmptable_init() will be called early from iommu_snp_enable()
directly and not invoked via device_initcall() which enables SNP host
support before KVM initialization with kvm_amd module built-in.

Fixes: c3b86e61b756 ("x86/cpufeatures: Enable/unmask SEV-SNP CPU feature")
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/sev.h |  2 ++
 arch/x86/virt/svm/sev.c    | 23 +++++++----------------
 2 files changed, 9 insertions(+), 16 deletions(-)

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
-- 
2.34.1


