Return-Path: <kvm+bounces-64252-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 548F6C7BABD
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 21:49:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08FB73A704F
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 20:49:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 772CF3081A1;
	Fri, 21 Nov 2025 20:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gmf6c3tL"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D262305070
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 20:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763758117; cv=none; b=Nt54fCHMXOwAwT7w+3jJ7hoP4F6J8uD8bR70+L6v83fjAapwGfnEBcCTv53kiyJR3cYS1xy4JsezYwcKk3LzYc1PkKmH2/7hoRDcgBOfAFsOPA1h5EwSJtA9MVNt6HwwjrJXU9eE+88xA1KGiAk/ZCE2AKts4pALR+aLvdd4k5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763758117; c=relaxed/simple;
	bh=4T6VDR8OuY7sP91VdfNMvexuxSvuDWulSwJAHvV0mBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ouCz7tR44zPiQVqjHuIGNR4RCIAbipR1qgqPI3zmHNd0kzxprxg7IRvpimJ37/JQmrAZK84UaqZ738jXbyTjKiiowXRyKieI/kJctVwdhuvc3roW3p9Ad42q1thWY6HVQi87HGfXlNxA59l3njvnoIGpZlhFnCJ3zwX22lnqxko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gmf6c3tL; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763758113;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rn79UncaPYjOQZlM47cG5rQ0+9uQVhhgAQM0iqUBzDo=;
	b=gmf6c3tLwCPWQvvfQvZAvWH85psJvV37tw5EzrvFcw1gDjZHZ5MHqwdjPexvmuoXc7rvli
	LIvKtatm56gkEdw48UK+Zlv5xJtqM+HJXdcPxLXLwXIlFRsX1lNgJ4B48/w5Vohbc3ld2S
	VzS2JDbN49eM5IQi/kt5k/q9JG9lGuU=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v3 4/4] KVM: selftests: Extend vmx_set_nested_state_test to cover SVM
Date: Fri, 21 Nov 2025 20:48:03 +0000
Message-ID: <20251121204803.991707-5-yosry.ahmed@linux.dev>
In-Reply-To: <20251121204803.991707-1-yosry.ahmed@linux.dev>
References: <20251121204803.991707-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add test cases for the validation checks in svm_set_nested_state(), and
allow the test to run with SVM as well as VMX. The SVM test also makes
sure that KVM_SET_NESTED_STATE accepts GIF being set or cleared if
EFER.SVME is cleared, verifying a recently fixed bug where GIF was
incorrectly expected to always be set when EFER.SVME is cleared.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   2 +-
 ...d_state_test.c => nested_set_state_test.c} | 122 ++++++++++++++++--
 2 files changed, 112 insertions(+), 12 deletions(-)
 rename tools/testing/selftests/kvm/x86/{vmx_set_nested_state_test.c => nested_set_state_test.c} (71%)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 7ebf30a87a2b..7567c936202f 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -92,6 +92,7 @@ TEST_GEN_PROGS_x86 += x86/nested_close_kvm_test
 TEST_GEN_PROGS_x86 += x86/nested_emulation_test
 TEST_GEN_PROGS_x86 += x86/nested_exceptions_test
 TEST_GEN_PROGS_x86 += x86/nested_invalid_cr3_test
+TEST_GEN_PROGS_x86 += x86/nested_set_state_test
 TEST_GEN_PROGS_x86 += x86/nested_tsc_adjust_test
 TEST_GEN_PROGS_x86 += x86/nested_tsc_scaling_test
 TEST_GEN_PROGS_x86 += x86/platform_info_test
@@ -120,7 +121,6 @@ TEST_GEN_PROGS_x86 += x86/vmx_exception_with_invalid_guest_state
 TEST_GEN_PROGS_x86 += x86/vmx_msrs_test
 TEST_GEN_PROGS_x86 += x86/vmx_invalid_nested_guest_state
 TEST_GEN_PROGS_x86 += x86/vmx_nested_la57_state_test
-TEST_GEN_PROGS_x86 += x86/vmx_set_nested_state_test
 TEST_GEN_PROGS_x86 += x86/apic_bus_clock_test
 TEST_GEN_PROGS_x86 += x86/xapic_ipi_test
 TEST_GEN_PROGS_x86 += x86/xapic_state_test
diff --git a/tools/testing/selftests/kvm/x86/vmx_set_nested_state_test.c b/tools/testing/selftests/kvm/x86/nested_set_state_test.c
similarity index 71%
rename from tools/testing/selftests/kvm/x86/vmx_set_nested_state_test.c
rename to tools/testing/selftests/kvm/x86/nested_set_state_test.c
index b59a8a17084d..0f2102b43629 100644
--- a/tools/testing/selftests/kvm/x86/vmx_set_nested_state_test.c
+++ b/tools/testing/selftests/kvm/x86/nested_set_state_test.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * vmx_set_nested_state_test
- *
  * Copyright (C) 2019, Google LLC.
  *
  * This test verifies the integrity of calling the ioctl KVM_SET_NESTED_STATE.
@@ -11,6 +9,7 @@
 #include "kvm_util.h"
 #include "processor.h"
 #include "vmx.h"
+#include "svm_util.h"
 
 #include <errno.h>
 #include <linux/kvm.h>
@@ -249,6 +248,104 @@ void test_vmx_nested_state(struct kvm_vcpu *vcpu)
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
+	/*
+	 * If EFER.SVME is clear, guest mode is disallowed and GIF can be set or
+	 * cleared.
+	 */
+	vcpu_efer_disable_svm(vcpu);
+
+	set_default_svm_state(state, state_sz);
+	state->flags = KVM_STATE_NESTED_GUEST_MODE;
+	test_nested_state_expect_einval(vcpu, state);
+
+	state->flags = 0;
+	test_nested_state(vcpu, state);
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
+
+	TEST_ASSERT_EQ(state->hdr.svm.vmcb_pa, 0);
+	TEST_ASSERT_EQ(state->flags, KVM_STATE_NESTED_GIF_SET);
+
+	free(state);
+}
+
 int main(int argc, char *argv[])
 {
 	struct kvm_vm *vm;
@@ -257,20 +354,20 @@ int main(int argc, char *argv[])
 
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
@@ -299,7 +396,10 @@ int main(int argc, char *argv[])
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
2.52.0.rc2.455.g230fcf2819-goog


