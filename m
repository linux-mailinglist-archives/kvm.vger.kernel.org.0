Return-Path: <kvm+bounces-59303-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA074BB0ECE
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 17:05:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9507E3B8B57
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 15:01:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A195C3081D9;
	Wed,  1 Oct 2025 14:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fbKidQ23"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93DF3304BC6;
	Wed,  1 Oct 2025 14:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759330725; cv=none; b=pRrLNCqVcWKJuVl8i5aOuExcTqhqCB0cEmAQv9zjsyZisZvtpBSSo0AUyKsP55SaMU5FoP0A4giLRN+hkbplY7g4OYPXNXCab35pBGukQBeC6HS4jvvaU3XUHrWgN7vtYicervOBYCSY3ps1YRROj1b+hBZExXL7LxlaqN36XeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759330725; c=relaxed/simple;
	bh=ceAZ4PjmP3sd/XfFUS76NUQmGMmpIwOKSc+9I8nxVDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TZ5KQRfBYkqYdD33b6mNEiJi553U/9HbK+v37DGnKahTEykcgtIzhLmZXFzEqh6wd8ROagYVDWb/5cemGtrmKAecYUPkcQewkVNQCLjBNdux7O89in2o6KyiqpZLeUjhQKzyszwnTT8M6n5RqXzbzejQfCwQRGywG+PVm+Rgsi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fbKidQ23; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759330721;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ICnHDNBwoB1fVGmbv1qEbjn1Z8+EX9iLIuDTuF6fUy8=;
	b=fbKidQ23eafd9R627wbdXyEzi+LpC5gbz0h012JleBGuIbX9lqNkLwwM08ZjuTb8oq7Xao
	PasiKZBNlmOsYofZY5m6lAMPnZk6/BGq3jWmQXHL+2tVpdpUJu8CLY/qRM601Zhl0r95YX
	LwWbFBuMtXjpQ/VUQwXRsvsAlm8cQE0=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosryahmed@google.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 02/12] KVM: selftests: Extend vmx_set_nested_state_test to cover SVM
Date: Wed,  1 Oct 2025 14:58:06 +0000
Message-ID: <20251001145816.1414855-3-yosry.ahmed@linux.dev>
In-Reply-To: <20251001145816.1414855-1-yosry.ahmed@linux.dev>
References: <20251001145816.1414855-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Yosry Ahmed <yosryahmed@google.com>

Add test cases for the validation checks in svm_set_nested_state(), and
allow the test to run with SVM as well as VMX.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   2 +-
 ...d_state_test.c => set_nested_state_test.c} | 122 ++++++++++++++++--
 2 files changed, 113 insertions(+), 11 deletions(-)
 rename tools/testing/selftests/kvm/x86/{vmx_set_nested_state_test.c => set_nested_state_test.c} (70%)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 148d427ff24be..6582396518b19 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -116,7 +116,7 @@ TEST_GEN_PROGS_x86 += x86/vmx_dirty_log_test
 TEST_GEN_PROGS_x86 += x86/vmx_exception_with_invalid_guest_state
 TEST_GEN_PROGS_x86 += x86/vmx_msrs_test
 TEST_GEN_PROGS_x86 += x86/vmx_invalid_nested_guest_state
-TEST_GEN_PROGS_x86 += x86/vmx_set_nested_state_test
+TEST_GEN_PROGS_x86 += x86/set_nested_state_test
 TEST_GEN_PROGS_x86 += x86/vmx_tsc_adjust_test
 TEST_GEN_PROGS_x86 += x86/vmx_nested_tsc_scaling_test
 TEST_GEN_PROGS_x86 += x86/apic_bus_clock_test
diff --git a/tools/testing/selftests/kvm/x86/vmx_set_nested_state_test.c b/tools/testing/selftests/kvm/x86/set_nested_state_test.c
similarity index 70%
rename from tools/testing/selftests/kvm/x86/vmx_set_nested_state_test.c
rename to tools/testing/selftests/kvm/x86/set_nested_state_test.c
index c4c400d2824c1..98a9cd4873d19 100644
--- a/tools/testing/selftests/kvm/x86/vmx_set_nested_state_test.c
+++ b/tools/testing/selftests/kvm/x86/set_nested_state_test.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * vmx_set_nested_state_test
+ * set_nested_state_test
  *
  * Copyright (C) 2019, Google LLC.
  *
@@ -11,6 +11,7 @@
 #include "kvm_util.h"
 #include "processor.h"
 #include "vmx.h"
+#include "svm_util.h"
 
 #include <errno.h>
 #include <linux/kvm.h>
@@ -253,6 +254,104 @@ void test_vmx_nested_state(struct kvm_vcpu *vcpu)
 	free(state);
 }
 
+static void vcpu_efer_enable_svm(struct kvm_vcpu *vcpu)
+{
+	uint64_t old_efer = vcpu_get_msr(vcpu, MSR_EFER);
+
+	vcpu_set_msr(vcpu, MSR_EFER, old_efer | EFER_SVME);
+}
+
+static void vcpu_efer_disable_svm(struct kvm_vcpu *vcpu)
+{
+	uint64_t old_efer = vcpu_get_msr(vcpu, MSR_EFER);
+
+	vcpu_set_msr(vcpu, MSR_EFER, old_efer & ~EFER_SVME);
+}
+
+void set_default_svm_state(struct kvm_nested_state *state, int size)
+{
+	memset(state, 0, size);
+	state->format = 1;
+	state->size = size;
+	state->hdr.svm.vmcb_pa = 0x3000;
+}
+
+void test_svm_nested_state(struct kvm_vcpu *vcpu)
+{
+	/* Add a page for VMCB. */
+	const int state_sz = sizeof(struct kvm_nested_state) + getpagesize();
+	struct kvm_nested_state *state =
+		(struct kvm_nested_state *)malloc(state_sz);
+
+	vcpu_set_cpuid_feature(vcpu, X86_FEATURE_SVM);
+
+	/* The format must be set to 1. 0 for VMX, 1 for SVM. */
+	set_default_svm_state(state, state_sz);
+	state->format = 0;
+	test_nested_state_expect_einval(vcpu, state);
+
+	/* Invalid flags are rejected, KVM_STATE_NESTED_EVMCS is VMX-only  */
+	set_default_svm_state(state, state_sz);
+	state->flags = KVM_STATE_NESTED_EVMCS;
+	test_nested_state_expect_einval(vcpu, state);
+
+	/* If EFER.SVME is clear, GIF must be set and guest mode is disallowed */
+	vcpu_efer_disable_svm(vcpu);
+
+	set_default_svm_state(state, state_sz);
+	state->flags = 0;
+	test_nested_state_expect_einval(vcpu, state);
+
+	state->flags = KVM_STATE_NESTED_GUEST_MODE;
+	test_nested_state_expect_einval(vcpu, state);
+
+	state->flags = KVM_STATE_NESTED_GIF_SET;
+	test_nested_state(vcpu, state);
+
+	/* Enable SVM in the guest EFER. */
+	vcpu_efer_enable_svm(vcpu);
+
+	/* Setting vmcb_pa to a non-aligned address is only fine when not entering guest mode */
+	set_default_svm_state(state, state_sz);
+	state->hdr.svm.vmcb_pa = -1ull;
+	state->flags = 0;
+	test_nested_state(vcpu, state);
+	state->flags = KVM_STATE_NESTED_GUEST_MODE;
+	test_nested_state_expect_einval(vcpu, state);
+
+	/*
+	 * Size must be large enough to fit kvm_nested_state and VMCB
+	 * only when entering guest mode.
+	 */
+	set_default_svm_state(state, state_sz/2);
+	state->flags = 0;
+	test_nested_state(vcpu, state);
+	state->flags = KVM_STATE_NESTED_GUEST_MODE;
+	test_nested_state_expect_einval(vcpu, state);
+
+	/*
+	 * Test that if we leave nesting the state reflects that when we get it
+	 * again, except for vmcb_pa, which is always returned as 0 when not in
+	 * guest mode.
+	 */
+	set_default_svm_state(state, state_sz);
+	state->hdr.svm.vmcb_pa = -1ull;
+	state->flags = KVM_STATE_NESTED_GIF_SET;
+	test_nested_state(vcpu, state);
+	vcpu_nested_state_get(vcpu, state);
+	TEST_ASSERT(state->size >= sizeof(*state) && state->size <= state_sz,
+		    "Size must be between %ld and %d.  The size returned was %d.",
+		    sizeof(*state), state_sz, state->size);
+	TEST_ASSERT(state->hdr.svm.vmcb_pa == 0,
+		    "vmcb_pa must be 0, but was %llx",
+		    state->hdr.svm.vmcb_pa);
+	TEST_ASSERT(state->flags == KVM_STATE_NESTED_GIF_SET,
+		    "Flags must be equal to 0x%hx, but was 0x%hx",
+		    KVM_STATE_NESTED_GIF_SET, state->flags);
+
+	free(state);
+}
+
 int main(int argc, char *argv[])
 {
 	struct kvm_vm *vm;
@@ -261,20 +360,20 @@ int main(int argc, char *argv[])
 
 	have_evmcs = kvm_check_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS);
 
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX) ||
+		     kvm_cpu_has(X86_FEATURE_SVM));
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_NESTED_STATE));
 
-	/*
-	 * AMD currently does not implement set_nested_state, so for now we
-	 * just early out.
-	 */
-	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
-
 	vm = vm_create_with_one_vcpu(&vcpu, NULL);
 
 	/*
-	 * First run tests with VMX disabled to check error handling.
+	 * First run tests with VMX/SVM disabled to check error handling.
+	 * test_{vmx/svm}_nested_state() will re-enable as needed.
 	 */
-	vcpu_clear_cpuid_feature(vcpu, X86_FEATURE_VMX);
+	if (kvm_cpu_has(X86_FEATURE_VMX))
+		vcpu_clear_cpuid_feature(vcpu, X86_FEATURE_VMX);
+	else
+		vcpu_clear_cpuid_feature(vcpu, X86_FEATURE_SVM);
 
 	/* Passing a NULL kvm_nested_state causes a EFAULT. */
 	test_nested_state_expect_efault(vcpu, NULL);
@@ -303,7 +402,10 @@ int main(int argc, char *argv[])
 	state.flags = KVM_STATE_NESTED_RUN_PENDING;
 	test_nested_state_expect_einval(vcpu, &state);
 
-	test_vmx_nested_state(vcpu);
+	if (kvm_cpu_has(X86_FEATURE_VMX))
+		test_vmx_nested_state(vcpu);
+	else
+		test_svm_nested_state(vcpu);
 
 	kvm_vm_free(vm);
 	return 0;
-- 
2.51.0.618.g983fd99d29-goog


