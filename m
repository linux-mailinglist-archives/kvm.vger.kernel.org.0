Return-Path: <kvm+bounces-18497-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0868D8D599E
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 06:48:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B7A51C235C4
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 04:48:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38CC37E575;
	Fri, 31 May 2024 04:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mRE/zRCl"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2048.outbound.protection.outlook.com [40.107.94.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A6178B50;
	Fri, 31 May 2024 04:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717130846; cv=fail; b=cS2IiLTjPcfgyx+gS0COkARfq6iscIITV45GPdbOd876d4GWSurEsvqWlVJg2U+tuvfH2MgtgvbyEG/6KZpDut/FYKVppGmI/CVVGg4cU58WP3lDYLySjOtkihHj174pJdHvE8ISrSYk9DAbGJjFZgU0v0ePRbGahS5FB9xohTQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717130846; c=relaxed/simple;
	bh=+ptCLeH/s49tGdQBHYVQa/bWaRjQTSSlb0OsCjTBfEw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VZIxzIq9Ax7mCiXbthENEUGcpNyBIFimSdwodN2vO2kBpJyhgleMKq5ajc95teVhgdDCAXdJITYubjjNhjTKQWwZiEvKGuaPWKjdTS251Atnk5ONhJ/Q0F1zH/uR/+NvSpBUB18SKfYMEDJ9n0LCRmjMWky7QLwmdYJ9yibsCwM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mRE/zRCl; arc=fail smtp.client-ip=40.107.94.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TVqHkxlfKsm/juXoDMO+1FQNcEpuHGluJHjOHP1Bp2GbR1VA+9GjaSODp197GoYc27pBblYSYB3HVONgHFHG9E5So3CGxHiEf6PAhvItfB77W14wofkwNSwAz80WrgsrS4YaEIPORxifMreiool+teXIpNyp/pTfxbcHhtnY+xZTLFmF4O2aM8dWPr+ZvykSsa4OcxGKzwIGSnUxI9pTjk7msTdDEmKwJrNJ0ZHdO/R4RSomo5MOilsI3HzC2cyzYpwbDL/p/AdGBJP5UNPQAM+hkMVM5G9bemvCJFFh4nXUuPUZIi7wOIl+as4SippKcisv5QKO3UH1qe0CdVggeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=prSxU6rH51BVzK8S4I2agQOPISMZXvuRmANcAgsbhO0=;
 b=MGrqC5w6GQEGm2hzx/64qwCh2xcv5fYi+My9rDWPKPNZ50DyvgU1g8FSMDTHqa9wtBFPSv3wuzaYJA+gkDUSJDQXyn7VN/5UuLXGWaoueua8zbsjIdmJfM9APGlJVdtryQtlO7v/4oiF5RarxkZYAodcDOZN+E/YoT4l4S0QbDyn2dbyT+xOgT+v/0WmKcJMa7TdFc40u6PAbLoFqjUipkDNDyC12u61bpLtzoeGB+P06FS6O2M4uT91jUCIDtvYo6PrsIgYT5rIgkkR2BSiN2waPsI5yiSQjTMVO0Cb2mGDAOElm9/TBaQgWR0La5lFU9R2Ga7sh/YjCmsx6OWwPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=prSxU6rH51BVzK8S4I2agQOPISMZXvuRmANcAgsbhO0=;
 b=mRE/zRClGaT07aVR3K6sup1zbJlX3H0LyYLvVLQ3EnVcA0rQROdcEsJxY2WD6IGPQw8+yVAbAcFYuTvVOqnDsW5FOnp/2shKvZfMyQLAmy6uclL/pYJcAIvfCgWEJUEzaTKr1tFIGtHuHa+zds/V9lOq8s3jMHB2aNNM8K1FDR8=
Received: from DM6PR11CA0043.namprd11.prod.outlook.com (2603:10b6:5:14c::20)
 by SJ0PR12MB7476.namprd12.prod.outlook.com (2603:10b6:a03:48d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.22; Fri, 31 May
 2024 04:47:21 +0000
Received: from DS2PEPF00003443.namprd04.prod.outlook.com
 (2603:10b6:5:14c:cafe::3d) by DM6PR11CA0043.outlook.office365.com
 (2603:10b6:5:14c::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.22 via Frontend
 Transport; Fri, 31 May 2024 04:47:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF00003443.mail.protection.outlook.com (10.167.17.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Fri, 31 May 2024 04:47:21 +0000
Received: from BLR-L-RBANGORI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 23:47:16 -0500
From: Ravi Bangoria <ravi.bangoria@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <nikunj.dadhania@amd.com>
CC: <ravi.bangoria@amd.com>, <thomas.lendacky@amd.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <michael.roth@amd.com>,
	<pankaj.gupta@amd.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <santosh.shukla@amd.com>
Subject: [PATCH v4 3/3] KVM: SEV-ES: Fix LBRV code
Date: Fri, 31 May 2024 04:46:44 +0000
Message-ID: <20240531044644.768-4-ravi.bangoria@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240531044644.768-1-ravi.bangoria@amd.com>
References: <20240531044644.768-1-ravi.bangoria@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF00003443:EE_|SJ0PR12MB7476:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ed14e20-e38a-47a9-7f12-08dc812cc220
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|36860700004|376005|7416005|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Cn4FqCACYdrrxMsNmAvmrTd0v19QzLjINK1K0yiRzVx0wkhDrkQk03Lz767k?=
 =?us-ascii?Q?B2Ktl58bgXo0aSwbkDp62LKT2Mr1qSW8N9xXsunGDe8bwjsYenMLHr3UrTOa?=
 =?us-ascii?Q?kUhcF+Tn4hMZILsncRG7oZ8dMvP+qA3nP1dXqusr/7JJSR7bPy5SDcL2vTYt?=
 =?us-ascii?Q?9LAYIvZsRC2cz/enLiZg7o8Mc3bMFoqacdwJ/e7ctN3VWVVIB13RMNYzL5XL?=
 =?us-ascii?Q?hYf0nEguqu03Si/n1ZYk2NIoEKXlnoOLvABNvfb+pro1sfVvxp6XaeoFVQwD?=
 =?us-ascii?Q?cndEFds8DdcoQLTVY+/NsMqkIjEadmfMIYmq4QHavUIr7eCQIhaKY97ZvXR3?=
 =?us-ascii?Q?m6jpYfc6Z5RMK6+ZewJAzgwxgH7oUrOGPl84/zE+rZJmBZR0rKkDXprLuYxu?=
 =?us-ascii?Q?+EczVRWCLWD9J5Dbym8bj381Dt2eM/n00AkBnP+g1ZHCbMVcYoJuSKYc5qAI?=
 =?us-ascii?Q?v84VROVMKxf0Z+ygrhU6hsnxocUTL4Nd5kwWb6qnqK6h/tiKUgLiDSOW7ycg?=
 =?us-ascii?Q?0/gu5+XWogtqvm9olLrzZAO4LNTRK4224Yt+KiVMoB4UuqRxcjspX/O6GLBF?=
 =?us-ascii?Q?oTVWlbBtkKGySvIULFLn8srS7G2jBB8GFmlR0uoHNWGxDeqthJQcyfs0SII+?=
 =?us-ascii?Q?uYe3HMonqrKSxykoE7E6WfrJKSfo7XveZNixdfwPb5jGbjK81c3uNRJYSH+R?=
 =?us-ascii?Q?scGQ2S2FOjenDbj4kCFZ8OGuDhXCAjvP8+2Ah5cGtKdUtiuQaBOCC8IPpk7H?=
 =?us-ascii?Q?3sY8XM9QP5WKZYVaDJYAsHHCTnvXHEVk33XtbO89V3QucMmz45FmgPYqKrIc?=
 =?us-ascii?Q?7ba3wDNx40femqCNAy1ma9tOM3UMZWi4+LSa3oVDJDt7KhA18UPMhXE4zF7c?=
 =?us-ascii?Q?9aQp4OFgwkK1wIwaGxSTUInfLcrz2Q47khPDQPfhKLM5RjZc6ZY0sdwfueb3?=
 =?us-ascii?Q?FqXRhWUFvRo12nWDwy/f0JCyyeO88qx7NQGd3Mq6dZhMFtV6QvPtPl9LnVwL?=
 =?us-ascii?Q?uEXtLpiykshgBhSs+8JcOMGUHZdygPQuG5ucpLsr6Zr1e5jQYNqCEQXcfQVB?=
 =?us-ascii?Q?MVJA76k/GYIwZxSzT8prOVrAJgx1xh1VLjqA1eAKz4J+D8sdIkW7ezpadwlD?=
 =?us-ascii?Q?kSlmVciU21H3GgQBvGlyANDoGfb3R4t11QuzLNMZyAQQB9UL126cRtCsirYg?=
 =?us-ascii?Q?DgdZAMfP3v/ZxoHvOIBUAH91uNQZTnh71EtqgTqvRYVXBgUyOA50otZt27Mn?=
 =?us-ascii?Q?RdwXr2kDQPlOE9Cd+hgUGhLex9I895W/493fclPGlDuTeAlaxNPMNVMVwdxR?=
 =?us-ascii?Q?/EzNbm6vvr9PVTdp4Vx1EA9d?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400017)(36860700004)(376005)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 04:47:21.4440
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ed14e20-e38a-47a9-7f12-08dc812cc220
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003443.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7476

As documented in APM[1], LBR Virtualization must be enabled for SEV-ES
guests. Although KVM currently enforces LBRV for SEV-ES guests, there
are multiple issues with it:

o MSR_IA32_DEBUGCTLMSR is still intercepted. Since MSR_IA32_DEBUGCTLMSR
  interception is used to dynamically toggle LBRV for performance reasons,
  this can be fatal for SEV-ES guests. For ex SEV-ES guest on Zen3:

  [guest ~]# wrmsr 0x1d9 0x4
  KVM: entry failed, hardware error 0xffffffff
  EAX=00000004 EBX=00000000 ECX=000001d9 EDX=00000000

  Fix this by never intercepting MSR_IA32_DEBUGCTLMSR for SEV-ES guests.
  No additional save/restore logic is required since MSR_IA32_DEBUGCTLMSR
  is of swap type A.

o KVM will disable LBRV if userspace sets MSR_IA32_DEBUGCTLMSR before the
  VMSA is encrypted. Fix this by moving LBRV enablement code post VMSA
  encryption.

[1]: AMD64 Architecture Programmer's Manual Pub. 40332, Rev. 4.07 - June
     2023, Vol 2, 15.35.2 Enabling SEV-ES.
     https://bugzilla.kernel.org/attachment.cgi?id=304653

Fixes: 376c6d285017 ("KVM: SVM: Provide support for SEV-ES vCPU creation/loading")
Co-developed-by: Nikunj A Dadhania <nikunj@amd.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
---
 arch/x86/kvm/svm/sev.c | 13 ++++++++-----
 arch/x86/kvm/svm/svm.c |  8 +++++++-
 arch/x86/kvm/svm/svm.h |  3 ++-
 3 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 8345a5098ab7..7d401f8a3001 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -851,6 +851,14 @@ static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
 	 */
 	fpstate_set_confidential(&vcpu->arch.guest_fpu);
 	vcpu->arch.guest_state_protected = true;
+
+	/*
+	 * SEV-ES guest mandates LBR Virtualization to be _always_ ON. Enable it
+	 * only after setting guest_state_protected because KVM_SET_MSRS allows
+	 * dynamic toggling of LBRV (for performance reason) on write access to
+	 * MSR_IA32_DEBUGCTLMSR when guest_state_protected is not set.
+	 */
+	svm_enable_lbrv(vcpu);
 	return 0;
 }
 
@@ -4279,7 +4287,6 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 
 	svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_SEV_ES_ENABLE;
-	svm->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
 
 	/*
 	 * An SEV-ES guest requires a VMSA area that is a separate from the
@@ -4331,10 +4338,6 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 	/* Clear intercepts on selected MSRs */
 	set_msr_interception(vcpu, svm->msrpm, MSR_EFER, 1, 1);
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_CR_PAT, 1, 1);
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHFROMIP, 1, 1);
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHTOIP, 1, 1);
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTFROMIP, 1, 1);
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTTOIP, 1, 1);
 }
 
 void sev_init_vmcb(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index cadf3085f183..bff08729c0e9 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -99,6 +99,7 @@ static const struct svm_direct_access_msrs {
 	{ .index = MSR_IA32_SPEC_CTRL,			.always = false },
 	{ .index = MSR_IA32_PRED_CMD,			.always = false },
 	{ .index = MSR_IA32_FLUSH_CMD,			.always = false },
+	{ .index = MSR_IA32_DEBUGCTLMSR,		.always = false },
 	{ .index = MSR_IA32_LASTBRANCHFROMIP,		.always = false },
 	{ .index = MSR_IA32_LASTBRANCHTOIP,		.always = false },
 	{ .index = MSR_IA32_LASTINTFROMIP,		.always = false },
@@ -990,7 +991,7 @@ void svm_copy_lbrs(struct vmcb *to_vmcb, struct vmcb *from_vmcb)
 	vmcb_mark_dirty(to_vmcb, VMCB_LBR);
 }
 
-static void svm_enable_lbrv(struct kvm_vcpu *vcpu)
+void svm_enable_lbrv(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -1000,6 +1001,9 @@ static void svm_enable_lbrv(struct kvm_vcpu *vcpu)
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTFROMIP, 1, 1);
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTTOIP, 1, 1);
 
+	if (sev_es_guest(vcpu->kvm))
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_DEBUGCTLMSR, 1, 1);
+
 	/* Move the LBR msrs to the vmcb02 so that the guest can see them. */
 	if (is_guest_mode(vcpu))
 		svm_copy_lbrs(svm->vmcb, svm->vmcb01.ptr);
@@ -1009,6 +1013,8 @@ static void svm_disable_lbrv(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	KVM_BUG_ON(sev_es_guest(vcpu->kvm), vcpu->kvm);
+
 	svm->vmcb->control.virt_ext &= ~LBR_CTL_ENABLE_MASK;
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHFROMIP, 0, 0);
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHTOIP, 0, 0);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 2d6c19c55b1a..3424a9577872 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -30,7 +30,7 @@
 #define	IOPM_SIZE PAGE_SIZE * 3
 #define	MSRPM_SIZE PAGE_SIZE * 2
 
-#define MAX_DIRECT_ACCESS_MSRS	47
+#define MAX_DIRECT_ACCESS_MSRS	48
 #define MSRPM_OFFSETS	32
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
@@ -583,6 +583,7 @@ u32 *svm_vcpu_alloc_msrpm(void);
 void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu, u32 *msrpm);
 void svm_vcpu_free_msrpm(u32 *msrpm);
 void svm_copy_lbrs(struct vmcb *to_vmcb, struct vmcb *from_vmcb);
+void svm_enable_lbrv(struct kvm_vcpu *vcpu);
 void svm_update_lbrv(struct kvm_vcpu *vcpu);
 
 int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer);
-- 
2.45.1


