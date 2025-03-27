Return-Path: <kvm+bounces-42134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1262A73CA1
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 18:40:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 58268179BF3
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 17:40:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44002219A8C;
	Thu, 27 Mar 2025 17:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="r2LMzaOI"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2049.outbound.protection.outlook.com [40.107.101.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E0C2192EB;
	Thu, 27 Mar 2025 17:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743097220; cv=fail; b=ZjTvS69GbZa/NdYPJ7hatelycymJgIEgmNkBO7MqGOZVcjjxbFLUMsg5cQBchqd/m00H0xAIKej00osPYIVXdrHzzYPP+m1iuhKMKEW8bC7kpklams58xqbI3kAafks50RgTj96I1+XG8VTZl+93oPVzYGdSo8V+FeuokZTr+XQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743097220; c=relaxed/simple;
	bh=eUeljwIBciPJ5DzbhDUZXV95F0qv92S99ihTGVS0kRk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=poNg1nmU/IvghfpFh7CEK779tQjywW0QN80FlES68rJqJp54dkN4JetdIYEQ0HGdZQ9uNVg3n2dOeerYP4xO4ms/ugq9IDxZj1ASR2a2SptKMNiMvW1Si3BNV7K/jSNbpjvLogp+Qbs3+aRmvZcRwc2b36I8IxuDq+uF05jlG9U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=r2LMzaOI; arc=fail smtp.client-ip=40.107.101.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CiAlD4XAmIp/VUoMcT4EL+9ermXPEUwdJks/LXR5Wk1JyNUGyodqLqmYs/WwReJHbDvoDSZquPlr9nggV88pE4yPda5zu3qybGTyZPlZ/cTNgvQfKouk3lTdVYR0xIGucyAXxXtQPTpv+n9+CHMoQxICSW3BqVhbQ8ICqYvY11yRZiRJqz7Yxn/s5LqMAa1JP8t5YUp3S3TpLFbbuMb5ll42zL8DV1EHh+DafdM9m8RkG50LueD/sM7M6Q2e3sCxkUxtppsEsttN7da+gteR9+KVhRepHgzMERg4DugDRebbyMXA8Ghsog+m2JKGRW5vK23vLLIwkjjJliWs3cUnhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KSw9FBkonIwUfvErTl0UKYxWAyXQCxNOaXITg6vvHig=;
 b=mUUHM4QjwnVgQjwrJl/L35J8C5k6x7XJyXm1O668N0yqfzZcNfJNRVTwRyYBGw0JCskfUfUfqNH4G8qX2qLFVUTO1Rzmyv6y9DEzX83i2tT0+q4OLXOyFgT5TlO6lvtzg2jXPQed19qgAofZZc30uPQPEIvQvmqmvhSaPwD/udUxPzJ+PI+nEdxSSuiAPkRldsHsPqx8sbNEiAMrSBQw16rSZOkcPVFRDfOvC6VEYmhOo9aykPbwyLWyDRptSN6atoEbm6GXNnGH9PT+6lHmgk1s5PMch7qJ/sPZzhhvn/daJuCFra+MzlW73MlJ1bjtLSeRnW+AcEuPUnDFBj3aTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KSw9FBkonIwUfvErTl0UKYxWAyXQCxNOaXITg6vvHig=;
 b=r2LMzaOI5R3qF/NXNLTwhVGFtChAayvapUCwdG0WwhG8sdV0kgSqpvstGlSh0FHGrq1UxHlNFmsjBEkU1HSlR2aOFL+3i5x2N9mw6xoHhXPPW9zStZ+C8cje2i79OrnEhoQG7eO2XVA9eLCk/T77gd1iP37ePTMpscq/C7IT1e8=
Received: from SJ0PR13CA0094.namprd13.prod.outlook.com (2603:10b6:a03:2c5::9)
 by SA3PR12MB7859.namprd12.prod.outlook.com (2603:10b6:806:305::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Thu, 27 Mar
 2025 17:40:11 +0000
Received: from MWH0EPF000A672E.namprd04.prod.outlook.com
 (2603:10b6:a03:2c5:cafe::76) by SJ0PR13CA0094.outlook.office365.com
 (2603:10b6:a03:2c5::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.43 via Frontend Transport; Thu,
 27 Mar 2025 17:40:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000A672E.mail.protection.outlook.com (10.167.249.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8534.20 via Frontend Transport; Thu, 27 Mar 2025 17:40:11 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 27 Mar
 2025 12:40:09 -0500
From: Tom Lendacky <thomas.lendacky@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>
Subject: [PATCH v2] KVM: SVM: Fix SNP AP destroy race with VMRUN
Date: Thu, 27 Mar 2025 12:39:56 -0500
Message-ID: <fe2c885bf35643dd224e91294edb6777d5df23a4.1743097196.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.46.2
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000A672E:EE_|SA3PR12MB7859:EE_
X-MS-Office365-Filtering-Correlation-Id: bbf6423c-98e2-4ef2-cc51-08dd6d566ca3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ulYQ/2jTAOAoR2o743eIjPgd1XUYWaGBqINnC3ItF65Nv6aFFLkBACJt/v5D?=
 =?us-ascii?Q?v/0ZORVyQPd/r8+McjtIzjSm6WWLeoyIYVknJRtFMLhfnKuWwZMriwaNshQG?=
 =?us-ascii?Q?0xEjcKE6Vu0phCRa5bogRcx98J2nLG73PaOlWBRqx25K/7OOE1dQ4tfNVXxK?=
 =?us-ascii?Q?7WlhAu+OJ74UCjX9DLg8b1Rkzp1f3lt4mA3fiFNs8FJJb6hC2m6ry1+fqywp?=
 =?us-ascii?Q?XNcDDZ22f9VLo7lISLexOMfClx4Xn+OUvdzrcQhNcRw1yAVUhWrQhrgoZiKg?=
 =?us-ascii?Q?bPc1PEn2+3m2CsHu/wjEbVL3+60pLE1+7Lm7mY2vBRJjCcW1EJQfcfiBDfPx?=
 =?us-ascii?Q?Vne/KwCZv034EmM2Z0rDcX5dibWeKakmKT/Pbs1aFW/sJZhyBnrt1c0zjj7v?=
 =?us-ascii?Q?sgLYgPBB26qm4h2LY/WKhAwxNFMEuEJMXtEkMNDhncxRAoW5Fu+waBYzUy92?=
 =?us-ascii?Q?MKdBoHoYlhX5hTTYbupI3wGtRFtVVIDu0+tCQUkNXvu5Ms9pLOxO5vYNQmja?=
 =?us-ascii?Q?FMJbDSGVjPUNOFUkO1Kq21+5BJRusp3fcOPUdqQPJ2KOWFvc8jJr/JYPz8ic?=
 =?us-ascii?Q?l6NEztexF2gwUo+s9itHtq3S2cH3FYW3uOnjZ7pIX1v5EbE9B6xiv6niuM3d?=
 =?us-ascii?Q?XhNfqIgSKkm31gcRSXunMkIUKpCPlLPtZP/i7Is9ClmmVBsUpOzyP/4teSuA?=
 =?us-ascii?Q?dsYUekrMpfUSIn/DIduU8DE8zWl5ZKYs/E8LJbOh0ucpVw1Vp+TbBqyRNnBU?=
 =?us-ascii?Q?pdzXpKnOQt4Hl1OjWx9zchmjPKgKTQv9H7xUewSBLnDV5VJVaV8yygVpsOkH?=
 =?us-ascii?Q?CLHK/nT357PDTFZACM9IAeisseZbu+QV6LBd/chuPbZO6UvYTD3C9KBSZ+CM?=
 =?us-ascii?Q?JZNmnf1UXZTe7kdvbVtKqvBa9HV1gk9yDDK3yZYweOJOj3OWKuAy0Lliis+F?=
 =?us-ascii?Q?RlVxsjNgTDrRXhuUuRqqBQd2CPnP8Xc2YZx+G1qnqMKpm7kQZWcyHuTH0g+E?=
 =?us-ascii?Q?CvzUrG9grWpeuC/rXYfkb9XAh/ZZD0fTF3gptK7Q30fqwO2dhMjPSKIJgYHb?=
 =?us-ascii?Q?xhFo0J6EAVjMP6p2gxsmq3ZtwMW6m7CeZ6n6Xi33sYhYjHIz0RmGvf7NPUNd?=
 =?us-ascii?Q?uFlcqyMjuV99/OHClZrihMd/vVQZpR/Yqo8phQfIMKSgNoRpXABNTGTzASJo?=
 =?us-ascii?Q?d5i2Pi94TbdcMLbcaplrsEjHZQDWTklag3CcCxDwoXuMp5e8yzog9Xhjw+fy?=
 =?us-ascii?Q?YJcZ08lVMVahLw7JdfwXF4oX4fAbZq5Lfrv11TK6otgewpMuoTpk07hEDPJF?=
 =?us-ascii?Q?Wl1heToI/0A6x3rLXeP/w+OLH3UPEViyG+0Cr56ymJQsMcPm6yl977IEtZ9q?=
 =?us-ascii?Q?Uoxx6QOgIOFPjIFNRcwhElq40fVaHBe1VrX9ZiH3Ka1xto/F0RfvY7K7CZy3?=
 =?us-ascii?Q?yqcfs6gAY/oy7d0F45us+wbp9VwP7hS2wVhXQsxzLo0IkbgULy6R8wP6xuvZ?=
 =?us-ascii?Q?XNRioBhT/sYZkztsMwZACKRwGLZPg9xohLoa?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2025 17:40:11.2361
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bbf6423c-98e2-4ef2-cc51-08dd6d566ca3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A672E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7859

An AP destroy request for a target vCPU is typically followed by an
RMPADJUST to remove the VMSA attribute from the page currently being
used as the VMSA for the target vCPU. This can result in a vCPU that
is about to VMRUN to exit with #VMEXIT_INVALID.

This usually does not happen as APs are typically sitting in HLT when
being destroyed and therefore the vCPU thread is not running at the time.
However, if HLT is allowed inside the VM, then the vCPU could be about to
VMRUN when the VMSA attribute is removed from the VMSA page, resulting in
a #VMEXIT_INVALID when the vCPU actually issues the VMRUN and causing the
guest to crash. An RMPADJUST against an in-use (already running) VMSA
results in a #NPF for the vCPU issuing the RMPADJUST, so the VMSA
attribute cannot be changed until the VMRUN for target vCPU exits. The
Qemu command line option '-overcommit cpu-pm=on' is an example of allowing
HLT inside the guest.

Update the KVM_REQ_UPDATE_PROTECTED_GUEST_STATE event to include the
KVM_REQUEST_WAIT flag. The kvm_vcpu_kick() function will not wait for
requests to be honored, so create kvm_make_request_and_kick() that will
add a new event request and honor the KVM_REQUEST_WAIT flag. This will
ensure that the target vCPU sees the AP destroy request before returning
to the initiating vCPU should the target vCPU be in guest mode.

Fixes: e366f92ea99e ("KVM: SEV: Support SEV-SNP AP Creation NAE event")
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

---
Changes from v1:
- Add the KVM_REQUEST_WAIT flag to the event request and create a new
  kvm_make_request_and_kick() to ensure the request is seen before
  returning to the guest.
---
 arch/x86/include/asm/kvm_host.h |  3 ++-
 arch/x86/kvm/svm/sev.c          |  6 ++----
 include/linux/kvm_host.h        | 19 ++++++++++++++++++-
 virt/kvm/kvm_main.c             | 12 ++++++++----
 4 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 32ae3aa50c7e..51aa63591b0a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -123,7 +123,8 @@
 	KVM_ARCH_REQ_FLAGS(31, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_HV_TLB_FLUSH \
 	KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
-#define KVM_REQ_UPDATE_PROTECTED_GUEST_STATE	KVM_ARCH_REQ(34)
+#define KVM_REQ_UPDATE_PROTECTED_GUEST_STATE \
+	KVM_ARCH_REQ_FLAGS(34, KVM_REQUEST_WAIT)
 
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 6e3f5042d9ce..9b12e3c91b8e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4037,10 +4037,8 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
 	}
 
 out:
-	if (kick) {
-		kvm_make_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, target_vcpu);
-		kvm_vcpu_kick(target_vcpu);
-	}
+	if (kick)
+		kvm_make_request_and_kick(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, target_vcpu);
 
 	mutex_unlock(&target_svm->sev_es.snp_vmsa_mutex);
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f34f4cfaa513..15c57bee7762 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1504,7 +1504,16 @@ bool kvm_vcpu_block(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu);
 bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu);
-void kvm_vcpu_kick(struct kvm_vcpu *vcpu);
+
+#ifndef CONFIG_S390
+void __kvm_vcpu_kick(struct kvm_vcpu *vcpu, bool wait);
+
+static inline void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
+{
+	__kvm_vcpu_kick(vcpu, false);
+}
+#endif
+
 int kvm_vcpu_yield_to(struct kvm_vcpu *target);
 void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool yield_to_kernel_mode);
 
@@ -2252,6 +2261,14 @@ static __always_inline void kvm_make_request(int req, struct kvm_vcpu *vcpu)
 	__kvm_make_request(req, vcpu);
 }
 
+#ifndef CONFIG_S390
+static inline void kvm_make_request_and_kick(int req, struct kvm_vcpu *vcpu)
+{
+	kvm_make_request(req, vcpu);
+	__kvm_vcpu_kick(vcpu, req & KVM_REQUEST_WAIT);
+}
+#endif
+
 static inline bool kvm_request_pending(struct kvm_vcpu *vcpu)
 {
 	return READ_ONCE(vcpu->requests);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ba0327e2d0d3..99f4998f975f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3725,7 +3725,7 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_wake_up);
 /*
  * Kick a sleeping VCPU, or a guest VCPU in guest mode, into host kernel mode.
  */
-void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
+void __kvm_vcpu_kick(struct kvm_vcpu *vcpu, bool wait)
 {
 	int me, cpu;
 
@@ -3754,13 +3754,17 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 	 */
 	if (kvm_arch_vcpu_should_kick(vcpu)) {
 		cpu = READ_ONCE(vcpu->cpu);
-		if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
-			smp_send_reschedule(cpu);
+		if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu)) {
+			if (wait)
+				smp_call_function_single(cpu, ack_kick, NULL, wait);
+			else
+				smp_send_reschedule(cpu);
+		}
 	}
 out:
 	put_cpu();
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_kick);
+EXPORT_SYMBOL_GPL(__kvm_vcpu_kick);
 #endif /* !CONFIG_S390 */
 
 int kvm_vcpu_yield_to(struct kvm_vcpu *target)

base-commit: a880678afd9488e1dd6017445802712f7c02cc6d
-- 
2.46.2


