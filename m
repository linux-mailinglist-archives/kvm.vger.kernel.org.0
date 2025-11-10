Return-Path: <kvm+bounces-62656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD197C49C24
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 00:30:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2985D3A14A5
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 23:30:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFFEA343D85;
	Mon, 10 Nov 2025 23:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PcjpC3Rl"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68027342CA2
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 23:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762817245; cv=none; b=GliWJBJsM8w0ZU8rR6zkFiZreFlmUuwp6+dXoroE8wRNCKwcZ0m2vS5y2J0t8OEvsROx3UCquLovpkiNbm+s2B1L3prWuL4b92rF0e261R4x97aaARKmwcpnA+fxkKpNa94SEZP+ocZz8mKrRVWjMDLzNcDzTE5xOg2M6jc47XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762817245; c=relaxed/simple;
	bh=MyCaylPcd6jL0fIRkiI4QdgSLFfZ2xzQS4bB56Mbxgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JVVM18NwvKOLcit4ix9HMGHYFuHkdhZs3qgVD5Cq+PsmaRtmH19QYuCp5QxtBhiKk55waVeYhB3/3ChLIm31LBbtBFPEv+dPPNxfslKjKnqj7yTdTrbbAfbg/tEXPWayV+WVugrEZ4Sm+cQsxlyZ7E2OPNUOt+RzmYaUo/7CB0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PcjpC3Rl; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762817241;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AJL9VPq8VyFGZh9HkMtyxbYE/+SCo1Ep+KzagzKZdJ8=;
	b=PcjpC3RlbL4DgCATn6T1Bu68WMVT3+Uk74PwQclGz/QBdPSthJ7VrpGFs5AUwEsYK+4iQj
	xT42a21N2CgSfq7cqKJty6ps2qwUgSxOk2yDkwAa6iiVxrK++jqZMNWOycLy40bKmLEiQc
	M+9xfGGc69VPQjWdvl8kYBiT1m1/Bhg=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Kevin Cheng <chengkev@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v3 12/14] x86/svm: Cleanup LBRV tests
Date: Mon, 10 Nov 2025 23:26:40 +0000
Message-ID: <20251110232642.633672-13-yosry.ahmed@linux.dev>
In-Reply-To: <20251110232642.633672-1-yosry.ahmed@linux.dev>
References: <20251110232642.633672-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

In LBRV tests, failures in the guest trigger a #UD and do not convey
useful debugging info (i.e. expected and actual values of MSRs). Also, a
lot of macros are used to perform branch checks, obscuring the tests to
an extent.

Instead, add a helper to read the branch IPs, and remove the check
macros. Consistently use TEST_EXPECT_EQ() in both virtual host and guest
code, instead of a mix of report(), TEST_EXPECT_EQ(), and #UD.

Opportunisitcally slightly reorder test checks to improve semantics, and
replace the report(true, ..) calls that document the test with comments.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 x86/svm_tests.c | 138 +++++++++++++++++++++++-------------------------
 1 file changed, 65 insertions(+), 73 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 40e9e7e344ed8..33c92b17c87db 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -3006,34 +3006,17 @@ static void svm_no_nm_test(void)
 	       "fnop with CR0.TS and CR0.EM unset no #NM exception");
 }
 
-static u64 amd_get_lbr_rip(u32 msr)
+/* These functions have to be inlined to avoid affecting LBR registers */
+static __always_inline u64 amd_get_lbr_rip(u32 msr)
 {
 	return rdmsr(msr) & ~AMD_LBR_RECORD_MISPREDICT;
 }
 
-#define HOST_CHECK_LBR(from_expected, to_expected)					\
-do {											\
-	TEST_EXPECT_EQ((u64)from_expected, amd_get_lbr_rip(MSR_IA32_LASTBRANCHFROMIP));	\
-	TEST_EXPECT_EQ((u64)to_expected, amd_get_lbr_rip(MSR_IA32_LASTBRANCHTOIP));	\
-} while (0)
-
-/*
- * FIXME: Do something other than generate an exception to communicate failure.
- * Debugging without expected vs. actual is an absolute nightmare.
- */
-#define GUEST_CHECK_LBR(from_expected, to_expected)				\
-do {										\
-	if ((u64)(from_expected) != amd_get_lbr_rip(MSR_IA32_LASTBRANCHFROMIP))	\
-		asm volatile("ud2");						\
-	if ((u64)(to_expected) != amd_get_lbr_rip(MSR_IA32_LASTBRANCHTOIP))	\
-		asm volatile("ud2");						\
-} while (0)
-
-#define REPORT_GUEST_LBR_ERROR(vmcb)						\
-	report(false, "LBR guest test failed.  Exit reason 0x%x, RIP = %lx, from = %lx, to = %lx, ex from = %lx, ex to = %lx", \
-		       vmcb->control.exit_code, vmcb->save.rip,			\
-		       vmcb->save.br_from, vmcb->save.br_to,			\
-		       vmcb->save.last_excp_from, vmcb->save.last_excp_to)
+static __always_inline void get_lbr_ips(u64 *from, u64 *to)
+{
+	*from = amd_get_lbr_rip(MSR_IA32_LASTBRANCHFROMIP);
+	*to = amd_get_lbr_rip(MSR_IA32_LASTBRANCHTOIP);
+}
 
 #define DO_BRANCH(branch_name)				\
 	asm volatile (					\
@@ -3058,55 +3041,64 @@ u64 dbgctl;
 
 static void svm_lbrv_test_guest1(void)
 {
+	u64 from_ip, to_ip;
+
 	/*
 	 * This guest expects the LBR to be already enabled when it starts,
 	 * it does a branch, and then disables the LBR and then checks.
 	 */
+	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
+	TEST_EXPECT_EQ(dbgctl, DEBUGCTLMSR_LBR);
 
 	DO_BRANCH(guest_branch0);
 
-	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
+	/* Disable LBR before the checks to avoid changing the last branch */
 	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
+	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
+	TEST_EXPECT_EQ(dbgctl, 0);
 
-	if (dbgctl != DEBUGCTLMSR_LBR)
-		asm volatile("ud2\n");
-	if (rdmsr(MSR_IA32_DEBUGCTLMSR) != 0)
-		asm volatile("ud2\n");
+	get_lbr_ips(&from_ip, &to_ip);
+	TEST_EXPECT_EQ((u64)&guest_branch0_from, from_ip);
+	TEST_EXPECT_EQ((u64)&guest_branch0_to, to_ip);
 
-	GUEST_CHECK_LBR(&guest_branch0_from, &guest_branch0_to);
 	asm volatile ("vmmcall\n");
 }
 
 static void svm_lbrv_test_guest2(void)
 {
+	u64 from_ip, to_ip;
+
 	/*
 	 * This guest expects the LBR to be disabled when it starts,
 	 * enables it, does a branch, disables it and then checks.
 	 */
-
-	DO_BRANCH(guest_branch1);
 	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
+	TEST_EXPECT_EQ(dbgctl, 0);
 
-	if (dbgctl != 0)
-		asm volatile("ud2\n");
+	DO_BRANCH(guest_branch1);
 
-	GUEST_CHECK_LBR(&host_branch2_from, &host_branch2_to);
+	get_lbr_ips(&from_ip, &to_ip);
+	TEST_EXPECT_EQ((u64)&host_branch2_from, from_ip);
+	TEST_EXPECT_EQ((u64)&host_branch2_to, to_ip);
 
 	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
 	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
+	TEST_EXPECT_EQ(dbgctl, DEBUGCTLMSR_LBR);
+
 	DO_BRANCH(guest_branch2);
 	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
 
-	if (dbgctl != DEBUGCTLMSR_LBR)
-		asm volatile("ud2\n");
-	GUEST_CHECK_LBR(&guest_branch2_from, &guest_branch2_to);
+	get_lbr_ips(&from_ip, &to_ip);
+	TEST_EXPECT_EQ((u64)&guest_branch2_from, from_ip);
+	TEST_EXPECT_EQ((u64)&guest_branch2_to, to_ip);
 
 	asm volatile ("vmmcall\n");
 }
 
 static void svm_lbrv_test0(void)
 {
-	report(true, "Basic LBR test");
+	u64 from_ip, to_ip;
+
 	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
 	DO_BRANCH(host_branch0);
 	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
@@ -3116,12 +3108,15 @@ static void svm_lbrv_test0(void)
 	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
 	TEST_EXPECT_EQ(dbgctl, 0);
 
-	HOST_CHECK_LBR(&host_branch0_from, &host_branch0_to);
+	get_lbr_ips(&from_ip, &to_ip);
+	TEST_EXPECT_EQ((u64)&host_branch0_from, from_ip);
+	TEST_EXPECT_EQ((u64)&host_branch0_to, to_ip);
 }
 
+/* Test that without LBRV enabled, guest LBR state does 'leak' to the host(1) */
 static void svm_lbrv_test1(void)
 {
-	report(true, "Test that without LBRV enabled, guest LBR state does 'leak' to the host(1)");
+	u64 from_ip, to_ip;
 
 	svm_setup_vmrun((u64)svm_lbrv_test_guest1);
 	vmcb->control.virt_ext = 0;
@@ -3130,19 +3125,19 @@ static void svm_lbrv_test1(void)
 	DO_BRANCH(host_branch1);
 	SVM_BARE_VMRUN;
 	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
+	TEST_EXPECT_EQ(dbgctl, 0);
 
-	if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
-		REPORT_GUEST_LBR_ERROR(vmcb);
-		return;
-	}
+	TEST_EXPECT_EQ(vmcb->control.exit_code, SVM_EXIT_VMMCALL);
 
-	TEST_EXPECT_EQ(dbgctl, 0);
-	HOST_CHECK_LBR(&guest_branch0_from, &guest_branch0_to);
+	get_lbr_ips(&from_ip, &to_ip);
+	TEST_EXPECT_EQ((u64)&guest_branch0_from, from_ip);
+	TEST_EXPECT_EQ((u64)&guest_branch0_to, to_ip);
 }
 
+/* Test that without LBRV enabled, guest LBR state does 'leak' to the host(2) */
 static void svm_lbrv_test2(void)
 {
-	report(true, "Test that without LBRV enabled, guest LBR state does 'leak' to the host(2)");
+	u64 from_ip, to_ip;
 
 	svm_setup_vmrun((u64)svm_lbrv_test_guest2);
 	vmcb->control.virt_ext = 0;
@@ -3152,25 +3147,25 @@ static void svm_lbrv_test2(void)
 	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
 	SVM_BARE_VMRUN;
 	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
-	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
+	TEST_EXPECT_EQ(dbgctl, 0);
 
-	if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
-		REPORT_GUEST_LBR_ERROR(vmcb);
-		return;
-	}
+	TEST_EXPECT_EQ(vmcb->control.exit_code, SVM_EXIT_VMMCALL);
 
-	TEST_EXPECT_EQ(dbgctl, 0);
-	HOST_CHECK_LBR(&guest_branch2_from, &guest_branch2_to);
+	get_lbr_ips(&from_ip, &to_ip);
+	TEST_EXPECT_EQ((u64)&guest_branch2_from, from_ip);
+	TEST_EXPECT_EQ((u64)&guest_branch2_to, to_ip);
 }
 
+/* Test that with LBRV enabled, guest LBR state doesn't leak (1) */
 static void svm_lbrv_nested_test1(void)
 {
+	u64 from_ip, to_ip;
+
 	if (!lbrv_supported()) {
 		report_skip("LBRV not supported in the guest");
 		return;
 	}
 
-	report(true, "Test that with LBRV enabled, guest LBR state doesn't leak (1)");
 	svm_setup_vmrun((u64)svm_lbrv_test_guest1);
 	vmcb->control.virt_ext = LBR_CTL_ENABLE_MASK;
 	vmcb->save.dbgctl = DEBUGCTLMSR_LBR;
@@ -3181,28 +3176,26 @@ static void svm_lbrv_nested_test1(void)
 	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
 	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
 
-	if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
-		REPORT_GUEST_LBR_ERROR(vmcb);
-		return;
-	}
-
-	if (vmcb->save.dbgctl != 0) {
-		report(false, "unexpected virtual guest MSR_IA32_DEBUGCTLMSR value 0x%lx", vmcb->save.dbgctl);
-		return;
-	}
+	TEST_EXPECT_EQ(vmcb->control.exit_code, SVM_EXIT_VMMCALL);
 
 	TEST_EXPECT_EQ(dbgctl, DEBUGCTLMSR_LBR);
-	HOST_CHECK_LBR(&host_branch3_from, &host_branch3_to);
+	TEST_EXPECT_EQ(vmcb->save.dbgctl, 0);
+
+	get_lbr_ips(&from_ip, &to_ip);
+	TEST_EXPECT_EQ((u64)&host_branch3_from, from_ip);
+	TEST_EXPECT_EQ((u64)&host_branch3_to, to_ip);
 }
 
+/* Test that with LBRV enabled, guest LBR state doesn't leak (2) */
 static void svm_lbrv_nested_test2(void)
 {
+	u64 from_ip, to_ip;
+
 	if (!lbrv_supported()) {
 		report_skip("LBRV not supported in the guest");
 		return;
 	}
 
-	report(true, "Test that with LBRV enabled, guest LBR state doesn't leak (2)");
 	svm_setup_vmrun((u64)svm_lbrv_test_guest2);
 	vmcb->control.virt_ext = LBR_CTL_ENABLE_MASK;
 
@@ -3215,14 +3208,13 @@ static void svm_lbrv_nested_test2(void)
 	SVM_BARE_VMRUN;
 	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
 	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
+	TEST_EXPECT_EQ(dbgctl, DEBUGCTLMSR_LBR);
 
-	if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
-		REPORT_GUEST_LBR_ERROR(vmcb);
-		return;
-	}
+	TEST_EXPECT_EQ(vmcb->control.exit_code, SVM_EXIT_VMMCALL);
 
-	TEST_EXPECT_EQ(dbgctl, DEBUGCTLMSR_LBR);
-	HOST_CHECK_LBR(&host_branch4_from, &host_branch4_to);
+	get_lbr_ips(&from_ip, &to_ip);
+	TEST_EXPECT_EQ((u64)&host_branch4_from, from_ip);
+	TEST_EXPECT_EQ((u64)&host_branch4_to, to_ip);
 }
 
 
-- 
2.51.2.1041.gc1ab5b90ca-goog


