Return-Path: <kvm+bounces-62657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BA74C49C21
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 00:30:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 09CF24EF713
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 23:30:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E77434403E;
	Mon, 10 Nov 2025 23:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hsALnKYI"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22101343D67
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 23:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762817247; cv=none; b=KTgL7WE7Ng5q+0VUlU6xSbpdRtzPD0xA9TwLMygC6YMRQW5s7mTQJroOK5d+HvCGLpeyiJyVIUD1dltD+LHtN5giAZ6x/jbLy1/WhZSBSpXd0zTHu9bWwffhLUXq5+XQtgkD8eSUo/qrNgu9ATdbQzW4jxCbjO+P6IdI2UShqzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762817247; c=relaxed/simple;
	bh=6cMSkWiFcxCeUdr+GFhK5aJIyWWK4/bAle6E3Rq/rYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ii5EoGixM6eaOU7clrseZeoZ6y6mZPV8qXtuWsZur+juYZYewlnro/sceElO4wlR3QF+4VolMhR/6RiPMNUYyGTiObmJpOhdaVJXLfkhwc5i+btfkAJ1XoZlWRGOc4U1RMbCU8COxC+S0yMr/EkxSEmJUWjckZg7eHAA0y6/Pw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hsALnKYI; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762817243;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RFlZ027NSXi28xsnB5O4aQTD9p2O2sueEXLrszMepZA=;
	b=hsALnKYIK6Zg7jwDtnqJ6ONAuEjzQaOwHKV6R4UNEHU5M4VVE6FVKJ1J+9uD4b2CU/WUyT
	X5UqZWK/2iTzVoQmljw8jcW0plF3JPcNESfFHYq8zC8tr3BSCVlt7I8voxoPT+v01nEiN7
	Sdjt/Lsidft8m0pJIB+7hehSOVlF8pU=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Kevin Cheng <chengkev@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v3 13/14] x86/svm: Add more LBRV test cases
Date: Mon, 10 Nov 2025 23:26:41 +0000
Message-ID: <20251110232642.633672-14-yosry.ahmed@linux.dev>
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

Add tests exercising using LBR, disabling it, then running a guest which
enables and uses LBR but does not disable it.

Make sure that when LBRV is disabled by virtual host, the guest state
correctly leaks into virtual host, but not when LBRV is enabled.  This
also exercises KVM disabling intercepts for LBRs in L2 but re-enabling
them when exiting to L1.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 x86/svm_tests.c | 80 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 80 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 33c92b17c87db..47a2edfbb6c9b 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -3031,11 +3031,14 @@ static __always_inline void get_lbr_ips(u64 *from, u64 *to)
 
 extern u64 guest_branch0_from, guest_branch0_to;
 extern u64 guest_branch2_from, guest_branch2_to;
+extern u64 guest_branch3_from, guest_branch3_to;
 
 extern u64 host_branch0_from, host_branch0_to;
 extern u64 host_branch2_from, host_branch2_to;
 extern u64 host_branch3_from, host_branch3_to;
 extern u64 host_branch4_from, host_branch4_to;
+extern u64 host_branch5_from, host_branch5_to;
+extern u64 host_branch6_from, host_branch6_to;
 
 u64 dbgctl;
 
@@ -3095,6 +3098,23 @@ static void svm_lbrv_test_guest2(void)
 	asm volatile ("vmmcall\n");
 }
 
+static void svm_lbrv_test_guest3(void)
+{
+	/*
+	 * This guest expects LBR to be disabled, it enables LBR and does a
+	 * branch, then exits to L1 without disabling LBR or doing more
+	 * branches.
+	 */
+	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
+	TEST_EXPECT_EQ(dbgctl, 0);
+
+	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
+	DO_BRANCH(guest_branch3);
+
+	/* Do not call the vmmcall() fn to avoid overriding the last branch */
+	asm volatile ("vmmcall\n\t");
+}
+
 static void svm_lbrv_test0(void)
 {
 	u64 from_ip, to_ip;
@@ -3156,6 +3176,33 @@ static void svm_lbrv_test2(void)
 	TEST_EXPECT_EQ((u64)&guest_branch2_to, to_ip);
 }
 
+/*
+ * Test that without LBRV enabled, enabling LBR in the guest then exiting will
+ * keep LBR enabled and 'leak' state to the host correctly.
+ */
+static void svm_lbrv_test3(void)
+{
+	u64 from_ip, to_ip;
+
+	svm_setup_vmrun((u64)svm_lbrv_test_guest3);
+	vmcb->control.virt_ext = 0;
+
+	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
+	DO_BRANCH(host_branch5);
+	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
+
+	SVM_BARE_VMRUN;
+	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
+	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
+	TEST_EXPECT_EQ(dbgctl, DEBUGCTLMSR_LBR);
+
+	TEST_EXPECT_EQ(vmcb->control.exit_code, SVM_EXIT_VMMCALL);
+
+	get_lbr_ips(&from_ip, &to_ip);
+	TEST_EXPECT_EQ((u64)&guest_branch3_from, from_ip);
+	TEST_EXPECT_EQ((u64)&guest_branch3_to, to_ip);
+}
+
 /* Test that with LBRV enabled, guest LBR state doesn't leak (1) */
 static void svm_lbrv_nested_test1(void)
 {
@@ -3217,6 +3264,37 @@ static void svm_lbrv_nested_test2(void)
 	TEST_EXPECT_EQ((u64)&host_branch4_to, to_ip);
 }
 
+/*
+ * Test that with LBRV enabled, enabling LBR in the guest then exiting does not
+ * 'leak' state to the host.
+ */
+static void svm_lbrv_nested_test3(void)
+{
+	u64 from_ip, to_ip;
+
+	if (!lbrv_supported()) {
+		report_skip("LBRV not supported in the guest");
+		return;
+	}
+
+	svm_setup_vmrun((u64)svm_lbrv_test_guest3);
+	vmcb->control.virt_ext = LBR_CTL_ENABLE_MASK;
+	vmcb->save.dbgctl = 0;
+
+	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
+	DO_BRANCH(host_branch6);
+	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
+
+	SVM_BARE_VMRUN;
+	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
+	TEST_EXPECT_EQ(dbgctl, 0);
+
+	TEST_EXPECT_EQ(vmcb->control.exit_code, SVM_EXIT_VMMCALL);
+
+	get_lbr_ips(&from_ip, &to_ip);
+	TEST_EXPECT_EQ((u64)&host_branch6_from, from_ip);
+	TEST_EXPECT_EQ((u64)&host_branch6_to, to_ip);
+}
 
 // test that a nested guest which does enable INTR interception
 // but doesn't enable virtual interrupt masking works
@@ -3622,8 +3700,10 @@ struct svm_test svm_tests[] = {
 	TEST(svm_lbrv_test0),
 	TEST(svm_lbrv_test1),
 	TEST(svm_lbrv_test2),
+	TEST(svm_lbrv_test3),
 	TEST(svm_lbrv_nested_test1),
 	TEST(svm_lbrv_nested_test2),
+	TEST(svm_lbrv_nested_test3),
 	TEST(svm_intr_intercept_mix_if),
 	TEST(svm_intr_intercept_mix_gif),
 	TEST(svm_intr_intercept_mix_gif2),
-- 
2.51.2.1041.gc1ab5b90ca-goog


