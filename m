Return-Path: <kvm+bounces-18041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E0728CD22B
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 14:19:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B84CB283FC5
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 12:19:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A38F13EFFB;
	Thu, 23 May 2024 12:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LMY0TvAa"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2047.outbound.protection.outlook.com [40.107.92.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9789B13E032;
	Thu, 23 May 2024 12:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716466773; cv=fail; b=PBWE5xOAha5sruBUB4KX1gj6e/vokNJUeuYPca+ZIbzwwcMJG9uOqoRFs/ukxJvPRp5fMeZGCk9Qhdmwhms7NT00wiYB9DRuiZHs7Yuxuq3q2eNXGNUFxT/Knw9/AJ+O/9srC5/IUgOc2tdBIq5+wQrLj8xlTbf+HHncb0KRIV4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716466773; c=relaxed/simple;
	bh=uoUKkxVBipWuVYqt1cX59xWJPF6zujtmCrxAo7x5mJs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W6yZ+vTEvC9GSTP8pepFCT6qkDiaS5czn6Fy0IJJQXx86VlwvalsU4TbuoGiVbVpLb+sEneYgucinbeJmHJYvWAYAk1R4t/Qwb+FfBSo9Ws/sXKARRSLXbmST7Q4y2UQzaW+dmcAtv29ir2fJf5FRfO6YJKsOlIT1dQ2HKeL88g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LMY0TvAa; arc=fail smtp.client-ip=40.107.92.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=APAEwyB/7JH2htT3dpFGA3kQ+uJCazsW8KK+fEbbHn+HZJvxEbpBizxSDc089+wrJNQOg8WG/LJmt80AeRg8O8OoE9N2p05VBBqBN1o7EUPbbdV48N4VgIfkWnBvVzx0W7WFnRRp2RyboH+Zuf5ACQgMqsljgKG3/53UEe7mV5lFmAwYz4/SBKqNZ4LbRSl2uaDlxsm3QfE7ulPwpU39fbdK4cKDclOEH8JsrWM7Af3Tl8/Yirbdsc9j7yjsosg1zCkPw24Z6vVGnnI5V6E6c35oBDLZd8K/2H1J292TGgt2yVrLX5XZ3sMLMZ1r2wXXVxlSJPSQT4TTanhmST6OWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2zTPP1r9BEzLxXecZu69TsQw82L/otKe/Cp2fh20Qao=;
 b=g/9vgW9SFAt1mWkORbamgF4gwKG3GBME0/gpAnEUau7Y6UzoetWavDoKfBOqJ7FpEGp+q00OHDLwknU79kg7fuN3Ti73cv95y8o41FW3XbCB8iPsKFHbjNDAdCW+MpG2W26JCQJgPvE+Wcv6zaBTW4k1wFlqc99KXpI/3IfondsL8r0IJj2h11IXHj0ICkYhGDYydeL/vH8fo5wiLtgLs+flCln5hZwqhFdtr8iwnmq24TDhEg/ZsJWxiOTzqYegPd5deEAZw+DVpoRrg16mMMjkR/jsLfxVQ3Dy3B9ccaDMuwoVMiuixmgcQFDTUZxZWrPOvY+Ef2ua4kdhu0VbhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2zTPP1r9BEzLxXecZu69TsQw82L/otKe/Cp2fh20Qao=;
 b=LMY0TvAa5df3mwi8cqYfhxlISaPhHJzxcEQhMnJihSJOCxwq5VuUfIezJ4QJQ5hZb6fd8eauVVNvNzJvXH45FMJ3XHBKWlwfeMlLRWORNweRZtK1MyPl9ckEmMyaIHHjEehqwBOmvfOyOCkdMxtzbWgatTF4no8WynvA9ray5jk=
Received: from BN9PR03CA0983.namprd03.prod.outlook.com (2603:10b6:408:109::28)
 by CY5PR12MB6552.namprd12.prod.outlook.com (2603:10b6:930:40::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.19; Thu, 23 May
 2024 12:19:27 +0000
Received: from BN1PEPF00004685.namprd03.prod.outlook.com
 (2603:10b6:408:109:cafe::a) by BN9PR03CA0983.outlook.office365.com
 (2603:10b6:408:109::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.19 via Frontend
 Transport; Thu, 23 May 2024 12:19:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00004685.mail.protection.outlook.com (10.167.243.86) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7611.14 via Frontend Transport; Thu, 23 May 2024 12:19:26 +0000
Received: from BLR-L-RBANGORI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 23 May
 2024 07:19:14 -0500
From: Ravi Bangoria <ravi.bangoria@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <nikunj.dadhania@amd.com>
CC: <ravi.bangoria@amd.com>, <thomas.lendacky@amd.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <michael.roth@amd.com>,
	<pankaj.gupta@amd.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <santosh.shukla@amd.com>
Subject: [PATCH v3 3/3] KVM: SEV-ES: Fix LBRV code
Date: Thu, 23 May 2024 12:18:28 +0000
Message-ID: <20240523121828.808-4-ravi.bangoria@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240523121828.808-1-ravi.bangoria@amd.com>
References: <20240523121828.808-1-ravi.bangoria@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004685:EE_|CY5PR12MB6552:EE_
X-MS-Office365-Filtering-Correlation-Id: e1b24e82-6289-4117-169c-08dc7b22969f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|376005|36860700004|7416005|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JaDhv80cCLRt+LduT8eX1wTkqxI5WRgKAc+YIn9tg/NK3GK9fX2T3nzZDqcz?=
 =?us-ascii?Q?otoIusaZr2967yZfna7oy/dRbVc+FETHZyzj4FVb8k5CpSKOOBtG+dskUP7l?=
 =?us-ascii?Q?s7wY8Pooh9vxfFbD9Bp+o/5giXJxRjpxRlDQJk4v5JYpAqrpANzaquTR4DrL?=
 =?us-ascii?Q?+WpPXVX6AnUl0e1E/ji0+luH2P95hdCDBBXTzHRv2y9gwbFkknIOyvafHRLQ?=
 =?us-ascii?Q?IHOQMbEOcD35zUhet9NLVORM1G/JezGw95Ka3/YZID09fahkGTnhD2bPOP+N?=
 =?us-ascii?Q?X6VYMOPwPIo90lyH7D1L+6ezsPgZ3P1rhlqoZrjjpxIReCWT+95x4mE2IiU4?=
 =?us-ascii?Q?AN9VuBiRZ/UIInvWGohtmHTmPcTLHzmPFK17ZFL/9VwXrHwnJ/E0/lNvR5Zk?=
 =?us-ascii?Q?VOmhZoEl2uNX2sbAndkCva2JkNTwLNgTxAeFvSDBObYHVz4jpaSH++3njF17?=
 =?us-ascii?Q?4OT8p1Mq3yp1CKJtOTO9OqvAUP7091qvN609iIePvSC13znpP9wEeQULwao9?=
 =?us-ascii?Q?8tcIXIh0UGeD1NQd56Ik2whqceaLHVmEVeH9UaULqI4Dj+aqvqGWPJzal9gO?=
 =?us-ascii?Q?0/giZ5NOkmETKmFOn08WMInNuvlXIskRGT1aXlCz7DXzWbutexY3gbKTtwhR?=
 =?us-ascii?Q?tdNxyuLP8wcPh1speFpvcjUOcNeWPhz5NYZS2I7WuteUF36mWzRG1ZcRLMMq?=
 =?us-ascii?Q?CSVVGC/IyhVaBPdjJPWadC+LfAT8T/uBIdOfO7bSRHVYlknVXt+pSWRXA2L8?=
 =?us-ascii?Q?6AKgfsj3NU1HwrkqYhFVjCziU9u06okxWSJdHFGYiFE+1GfJetHjpFrKGhTu?=
 =?us-ascii?Q?Lc63bfLZE8+vVN/1gdu58u8Bqc7CvpsZG/6HCqCGboOXT595riBwmhl9nPAT?=
 =?us-ascii?Q?2KgpJh+iuhEzGN9SWFp0R4+lWp6hXnWrf4xlWPVtI0W0ZRB1Oe1N9jovfpZm?=
 =?us-ascii?Q?EBP/MgmsuLyaiYW1hKZDb7wFcXY6g8iknWhrCaSNdabFfyWlphNAx+WUGy5j?=
 =?us-ascii?Q?hdxd3LbT0OLMd9Q0pgBl6Wsksqt/+M6lJSGLYy8ZOeplW+7Eblb4UE2Ig4Uo?=
 =?us-ascii?Q?Sgp2F327CecesjwNCbStbLW0MuuP1dqFRnBoiQ39o8w/bEi5sfV2jjr/+Wbp?=
 =?us-ascii?Q?zZjZedfwJFyXq6ET1JsLWUU6luv4C7aO2mpoMNnjC9nKybsxngGV3zy1Cr/9?=
 =?us-ascii?Q?BUnWRiFcu7DDQ/DG3ygZtYqYh4Tiom+zuKZCnnaMck/4KJEg3YZL6tudtrEF?=
 =?us-ascii?Q?TIvCX4dWr+Ahyi+VcNt2fO+ZwdvElTzIIJMs8IlObPlvyQa2GHBEiFGWQty8?=
 =?us-ascii?Q?Jgv3MFCxsdUjU6YbmeTJXIv+?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(376005)(36860700004)(7416005)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2024 12:19:26.5411
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e1b24e82-6289-4117-169c-08dc7b22969f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004685.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6552

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

Co-developed-by: Nikunj A Dadhania <nikunj@amd.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
---
 arch/x86/kvm/svm/sev.c | 13 ++++++++-----
 arch/x86/kvm/svm/svm.c |  8 +++++++-
 arch/x86/kvm/svm/svm.h |  3 ++-
 3 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 1a2bde579727..3f0c3dbce0c5 100644
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
index dcb5eb00a4f5..011e8e6c5c53 100644
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
index 2d7fd09c08c9..c483d7149420 100644
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
@@ -582,6 +582,7 @@ u32 *svm_vcpu_alloc_msrpm(void);
 void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu, u32 *msrpm);
 void svm_vcpu_free_msrpm(u32 *msrpm);
 void svm_copy_lbrs(struct vmcb *to_vmcb, struct vmcb *from_vmcb);
+void svm_enable_lbrv(struct kvm_vcpu *vcpu);
 void svm_update_lbrv(struct kvm_vcpu *vcpu);
 
 int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer);
-- 
2.45.1


