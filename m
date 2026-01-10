Return-Path: <kvm+bounces-67650-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 46038D0CA69
	for <lists+kvm@lfdr.de>; Sat, 10 Jan 2026 01:50:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4E2483073E1A
	for <lists+kvm@lfdr.de>; Sat, 10 Jan 2026 00:48:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B44851DA0E1;
	Sat, 10 Jan 2026 00:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pgLcd8rQ"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680F01F5437
	for <kvm@vger.kernel.org>; Sat, 10 Jan 2026 00:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768006134; cv=none; b=RlrWF2g5cCMyLB5KdHp1bFvSS1hSg8YPbdcVmNLK4kKRiZbV+P3xyv9McYSu15X1guOs3uqLol1BygW+mlu4ijpNhEv97+wGrQvc9gDAEs0X9+k7JGpVCozhdFcpgefkgqTgFvOs6cU4bBUya8bX/jDpI9JICWHjXlmU01MV+0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768006134; c=relaxed/simple;
	bh=7GgFo/l8sMREafrKJTJHq3osoq2OSC8qKgonoJg8xtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LYfNQDlzt66TbkoxYWKaf9exxKZcgUIfSOb+GjzqpoRgkKuEWZvI6BQOSzQ+IL3bsI4kujo0iwnHt6WIGaTJWlxqBQCpeHsR/DEkfriarjgtUo4dKi+9KVbgGOayjqai+4J81MhuA8MdCE3yDlw+H3ETlPw+HMitSIeLE93d9SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pgLcd8rQ; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768006126;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4Y9MfcXmWbUdSqP3HqBOWqq07ebTF1bLhYdjrHeB8qA=;
	b=pgLcd8rQMqDzH4FXNVzX4Je67A0Nria+DhJHv+YAnjErwGCoTgdSZz0T2v94djpkcS84FO
	FX61eg8q5LstH91Pv66XtkRK+/AGbrSnpqqfyulgVQdNrbfZeT0Pjr6DaYEupsUhM5eSDl
	FQc1H5g/i49KbH+WsGXhtIOAyw4stbo=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	Kevin Cheng <chengkev@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 3/4] KVM: selftests: Add a selftests for nested VMLOAD/VMSAVE
Date: Sat, 10 Jan 2026 00:48:20 +0000
Message-ID: <20260110004821.3411245-4-yosry.ahmed@linux.dev>
In-Reply-To: <20260110004821.3411245-1-yosry.ahmed@linux.dev>
References: <20260110004821.3411245-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add a test for VMLOAD/VMSAVE in an L2 guest. The test verifies that L1
intercepts for VMSAVE/VMLOAD always work regardless of
VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK.

Then, more interestingly, it makes sure that when L1 does not intercept
VMLOAD/VMSAVE, they work as intended in L2. When
VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK is enabled by L1, VMSAVE/VMLOAD from
L2 should interpret the GPA as an L2 GPA and translate it through the
NPT. When VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK is disabled by L1,
VMSAVE/VMLOAD from L2 should interpret the GPA as an L1 GPA.

To test this, put two VMCBs (0 and 1) in L1's physical address space,
and have a single L2 GPA where:
- L2 VMCB GPA == L1 VMCB(0) GPA
- L2 VMCB GPA maps to L1 VMCB(1) via the NPT in L1.

This setup allows detecting how the GPA is interpreted based on which L1
VMCB is actually accessed.

In both cases, L2 sets KERNEL_GS_BASE (one of the fields handled by
VMSAVE/VMLOAD), and executes VMSAVE to write its value to the VMCB. The
test userspace code then checks that the write was made to the correct
VMCB (based on whether VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK is set by L1),
and writes a new value to that VMCB. L2 then executes VMLOAD to load the
new value and makes sure it's reflected correctly in KERNERL_GS_BASE.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/include/x86/processor.h     |   1 +
 .../kvm/x86/nested_vmsave_vmload_test.c       | 197 ++++++++++++++++++
 3 files changed, 199 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86/nested_vmsave_vmload_test.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 33ff81606638..482d237b83f8 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -96,6 +96,7 @@ TEST_GEN_PROGS_x86 += x86/nested_invalid_cr3_test
 TEST_GEN_PROGS_x86 += x86/nested_set_state_test
 TEST_GEN_PROGS_x86 += x86/nested_tsc_adjust_test
 TEST_GEN_PROGS_x86 += x86/nested_tsc_scaling_test
+TEST_GEN_PROGS_x86 += x86/nested_vmsave_vmload_test
 TEST_GEN_PROGS_x86 += x86/platform_info_test
 TEST_GEN_PROGS_x86 += x86/pmu_counters_test
 TEST_GEN_PROGS_x86 += x86/pmu_event_filter_test
diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index 8f130e7d7048..6bfffc3b0a33 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -201,6 +201,7 @@ struct kvm_x86_cpu_feature {
 #define X86_FEATURE_TSCRATEMSR          KVM_X86_CPU_FEATURE(0x8000000A, 0, EDX, 4)
 #define X86_FEATURE_PAUSEFILTER         KVM_X86_CPU_FEATURE(0x8000000A, 0, EDX, 10)
 #define X86_FEATURE_PFTHRESHOLD         KVM_X86_CPU_FEATURE(0x8000000A, 0, EDX, 12)
+#define	X86_FEATURE_V_VMSAVE_VMLOAD	KVM_X86_CPU_FEATURE(0x8000000A, 0, EDX, 15)
 #define	X86_FEATURE_VGIF		KVM_X86_CPU_FEATURE(0x8000000A, 0, EDX, 16)
 #define X86_FEATURE_IDLE_HLT		KVM_X86_CPU_FEATURE(0x8000000A, 0, EDX, 30)
 #define X86_FEATURE_SEV			KVM_X86_CPU_FEATURE(0x8000001F, 0, EAX, 1)
diff --git a/tools/testing/selftests/kvm/x86/nested_vmsave_vmload_test.c b/tools/testing/selftests/kvm/x86/nested_vmsave_vmload_test.c
new file mode 100644
index 000000000000..6764a48f9d4d
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/nested_vmsave_vmload_test.c
@@ -0,0 +1,197 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2026, Google LLC.
+ */
+#include "kvm_util.h"
+#include "vmx.h"
+#include "svm_util.h"
+#include "kselftest.h"
+
+/*
+ * Allocate two VMCB pages for testing. Both pages have different GVAs (shared
+ * by both L1 and L2) and L1 GPAs. A single L2 GPA is used such that:
+ * - L2 GPA == L1 GPA for VMCB0.
+ * - L2 GPA is mapped to L1 GPA for VMCB1 using NPT in L1.
+ *
+ * This allows testing whether the GPA used by VMSAVE/VMLOAD in L2 is
+ * interpreted as a direct L1 GPA or translated using NPT as an L2 GPA, depends
+ * on which VMCB is accessed.
+ */
+#define TEST_MEM_SLOT_INDEX		1
+#define TEST_MEM_PAGES			2
+#define TEST_MEM_BASE			0xc0000000
+
+#define TEST_GUEST_ADDR(idx)		(TEST_MEM_BASE + (idx) * PAGE_SIZE)
+
+#define TEST_VMCB_L1_GPA(idx)		TEST_GUEST_ADDR(idx)
+#define TEST_VMCB_GVA(idx)		TEST_GUEST_ADDR(idx)
+
+#define TEST_VMCB_L2_GPA		TEST_VMCB_L1_GPA(0)
+
+#define L2_GUEST_STACK_SIZE		64
+
+static void l2_guest_code_vmsave(void)
+{
+	asm volatile("vmsave %0" : : "a"(TEST_VMCB_L2_GPA) : "memory");
+}
+
+static void l2_guest_code_vmload(void)
+{
+	asm volatile("vmload %0" : : "a"(TEST_VMCB_L2_GPA) : "memory");
+}
+
+static void l2_guest_code_vmcb(int vmcb_idx)
+{
+	wrmsr(MSR_KERNEL_GS_BASE, 0xaaaa);
+	l2_guest_code_vmsave();
+
+	/* Verify the VMCB used by VMSAVE and update KERNEL_GS_BASE to 0xbbbb */
+	GUEST_SYNC(vmcb_idx);
+
+	l2_guest_code_vmload();
+	GUEST_ASSERT_EQ(rdmsr(MSR_KERNEL_GS_BASE), 0xbbbb);
+
+	/* Reset MSR_KERNEL_GS_BASE */
+	wrmsr(MSR_KERNEL_GS_BASE, 0);
+	l2_guest_code_vmsave();
+
+	vmmcall();
+}
+
+static void l2_guest_code_vmcb0(void)
+{
+	l2_guest_code_vmcb(0);
+}
+
+static void l2_guest_code_vmcb1(void)
+{
+	l2_guest_code_vmcb(1);
+}
+
+static void l1_guest_code(struct svm_test_data *svm)
+{
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+
+	/* Each test case initializes the guest RIP below */
+	generic_svm_setup(svm, NULL, &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+
+	/* Set VMSAVE/VMLOAD intercepts and make sure they work with.. */
+	svm->vmcb->control.intercept |= (BIT_ULL(INTERCEPT_VMSAVE) |
+					 BIT_ULL(INTERCEPT_VMLOAD));
+
+	 /* ..VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK cleared.. */
+	svm->vmcb->control.virt_ext &= ~VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
+
+	svm->vmcb->save.rip = (u64)l2_guest_code_vmsave;
+	run_guest(svm->vmcb, svm->vmcb_gpa);
+	GUEST_ASSERT_EQ(svm->vmcb->control.exit_code, SVM_EXIT_VMSAVE);
+
+	svm->vmcb->save.rip = (u64)l2_guest_code_vmload;
+	run_guest(svm->vmcb, svm->vmcb_gpa);
+	GUEST_ASSERT_EQ(svm->vmcb->control.exit_code, SVM_EXIT_VMLOAD);
+
+	/* ..and VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK set */
+	svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
+
+	svm->vmcb->save.rip = (u64)l2_guest_code_vmsave;
+	run_guest(svm->vmcb, svm->vmcb_gpa);
+	GUEST_ASSERT_EQ(svm->vmcb->control.exit_code, SVM_EXIT_VMSAVE);
+
+	svm->vmcb->save.rip = (u64)l2_guest_code_vmload;
+	run_guest(svm->vmcb, svm->vmcb_gpa);
+	GUEST_ASSERT_EQ(svm->vmcb->control.exit_code, SVM_EXIT_VMLOAD);
+
+	/* Now clear the intercepts to test VMSAVE/VMLOAD behavior */
+	svm->vmcb->control.intercept &= ~(BIT_ULL(INTERCEPT_VMSAVE) |
+					  BIT_ULL(INTERCEPT_VMLOAD));
+
+	/*
+	 * Without VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK, the GPA will be
+	 * interpreted as an L1 GPA, so VMCB0 should be used.
+	 */
+	svm->vmcb->save.rip = (u64)l2_guest_code_vmcb0;
+	svm->vmcb->control.virt_ext &= ~VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
+	run_guest(svm->vmcb, svm->vmcb_gpa);
+	GUEST_ASSERT_EQ(svm->vmcb->control.exit_code, SVM_EXIT_VMMCALL);
+
+	/*
+	 * With VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK, the GPA will be interpeted as
+	 * an L2 GPA, and translated through the NPT to VMCB1.
+	 */
+	svm->vmcb->save.rip = (u64)l2_guest_code_vmcb1;
+	svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
+	run_guest(svm->vmcb, svm->vmcb_gpa);
+	GUEST_ASSERT_EQ(svm->vmcb->control.exit_code, SVM_EXIT_VMMCALL);
+
+	GUEST_DONE();
+}
+
+int main(int argc, char *argv[])
+{
+	vm_vaddr_t nested_gva = 0;
+	struct vmcb *test_vmcb[2];
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	int i;
+
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SVM));
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_NPT));
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_V_VMSAVE_VMLOAD));
+
+	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
+	vm_enable_tdp(vm);
+
+	vcpu_alloc_svm(vm, &nested_gva);
+	vcpu_args_set(vcpu, 1, nested_gva);
+
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
+				    TEST_MEM_BASE, TEST_MEM_SLOT_INDEX,
+				    TEST_MEM_PAGES, 0);
+
+	for (i = 0; i <= 1; i++) {
+		virt_map(vm, TEST_VMCB_GVA(i), TEST_VMCB_L1_GPA(i), 1);
+		test_vmcb[i] = (struct vmcb *)addr_gva2hva(vm, TEST_VMCB_GVA(i));
+	}
+
+	tdp_identity_map_default_memslots(vm);
+
+	/*
+	 * L2 GPA == L1_GPA(0), but map it to L1_GPA(1), to allow testing
+	 * whether the L2 GPA is interpreted as an L1 GPA or translated through
+	 * the NPT.
+	 */
+	TEST_ASSERT_EQ(TEST_VMCB_L2_GPA, TEST_VMCB_L1_GPA(0));
+	tdp_map(vm, TEST_VMCB_L2_GPA, TEST_VMCB_L1_GPA(1), PAGE_SIZE);
+
+	for (;;) {
+		struct ucall uc;
+
+		vcpu_run(vcpu);
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+		case UCALL_SYNC:
+			i = uc.args[1];
+			TEST_ASSERT(i == 0 || i == 1, "Unexpected VMCB idx: %d", i);
+
+			/*
+			 * Check that only the expected VMCB has KERNEL_GS_BASE
+			 * set to 0xaaaa, and update it to 0xbbbb.
+			 */
+			TEST_ASSERT_EQ(test_vmcb[i]->save.kernel_gs_base, 0xaaaa);
+			TEST_ASSERT_EQ(test_vmcb[1-i]->save.kernel_gs_base, 0);
+			test_vmcb[i]->save.kernel_gs_base = 0xbbbb;
+			break;
+		case UCALL_DONE:
+			goto done;
+		default:
+			TEST_FAIL("Unknown ucall %lu", uc.cmd);
+		}
+	}
+
+done:
+	kvm_vm_free(vm);
+	return 0;
+}
-- 
2.52.0.457.g6b5491de43-goog


