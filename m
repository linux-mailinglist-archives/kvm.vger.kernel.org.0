Return-Path: <kvm+bounces-68113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 66F78D21F59
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 02:15:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E1BBE3087382
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 01:13:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 627C023EA88;
	Thu, 15 Jan 2026 01:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sjjaI41W"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DCFA21C9FD
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 01:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768439617; cv=none; b=khoFtLRb+nYEfWzal3g4VPFBhxv8g8jtn+cbqFGnqquFhmMoYeAMDX/odevy139n0g42+u2r5iA5i86wBw+umrOGdUY9fyylUuNYzBsGOiZ2/kYeR48/cB4jvodrnxYazGe4hR1/f7xvdSXGg+koz1wsbwuL5FsksLmRUhTJtPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768439617; c=relaxed/simple;
	bh=8KcsBXVOOyyGKmxX7UEdEQdFNc9BgDj+bpUHeZ4MD/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqOVQYWyIlmqIF5sjDJMiCb7bfW8pGw8ZKknhqs5mwClYHhYxIZIobxMeOxU0MYR1N5OL7DCL72//UX0M6jqR2/qPbfIptJp4/PaVhtxnJupDiRCZnbrbMg6gqZeyMAWNVt8BdTCF5AU+YXkQgF+gdngPu/Tx9MXMzEmfQ7pETg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sjjaI41W; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768439612;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MIGZmNEH1XnLZ0kZvZ028HYRTub7tS3joetCerTLltA=;
	b=sjjaI41WLtIeWiE1GZQK2a4aX2SehCbExLGd1dvX6e4FCghlJ4gghfadI9L+MLzNLXxKg/
	PBSBMMicYzLTDADWtOylky00Vd3Dxsp+jVbOmFQXRmBPbV4e6/iJ/2xATtwBrWpOVXK7SY
	/4tcNnEkBzOYVNGQ8cDUplaVTHMQ5nk=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v4 03/26] KVM: selftests: Add a test for LBR save/restore (ft. nested)
Date: Thu, 15 Jan 2026 01:12:49 +0000
Message-ID: <20260115011312.3675857-4-yosry.ahmed@linux.dev>
In-Reply-To: <20260115011312.3675857-1-yosry.ahmed@linux.dev>
References: <20260115011312.3675857-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add a selftest exercising save/restore with usage of LBRs in both L1 and
L2, and making sure all LBRs remain intact.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/include/x86/processor.h     |   5 +
 .../selftests/kvm/x86/svm_lbr_nested_state.c  | 155 ++++++++++++++++++
 3 files changed, 161 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86/svm_lbr_nested_state.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 33ff81606638..a7dbd7a79fca 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -111,6 +111,7 @@ TEST_GEN_PROGS_x86 += x86/svm_vmcall_test
 TEST_GEN_PROGS_x86 += x86/svm_int_ctl_test
 TEST_GEN_PROGS_x86 += x86/svm_nested_shutdown_test
 TEST_GEN_PROGS_x86 += x86/svm_nested_soft_inject_test
+TEST_GEN_PROGS_x86 += x86/svm_lbr_nested_state
 TEST_GEN_PROGS_x86 += x86/tsc_scaling_sync
 TEST_GEN_PROGS_x86 += x86/sync_regs_test
 TEST_GEN_PROGS_x86 += x86/ucna_injection_test
diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index 8f130e7d7048..855cc7aae83c 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -1359,6 +1359,11 @@ static inline bool kvm_is_ignore_msrs(void)
 	return get_kvm_param_bool("ignore_msrs");
 }
 
+static inline bool kvm_is_lbrv_enabled(void)
+{
+	return !!get_kvm_amd_param_integer("lbrv");
+}
+
 uint64_t *vm_get_pte(struct kvm_vm *vm, uint64_t vaddr);
 
 uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
diff --git a/tools/testing/selftests/kvm/x86/svm_lbr_nested_state.c b/tools/testing/selftests/kvm/x86/svm_lbr_nested_state.c
new file mode 100644
index 000000000000..a343279546fd
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/svm_lbr_nested_state.c
@@ -0,0 +1,155 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * svm_lbr_nested_state
+ *
+ * Test that LBRs are maintained correctly in both L1 and L2 during
+ * save/restore.
+ *
+ * Copyright (C) 2025, Google, Inc.
+ */
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+#include "svm_util.h"
+
+
+#define L2_GUEST_STACK_SIZE 64
+
+#define DO_BRANCH() asm volatile("jmp 1f\n 1: nop")
+
+struct lbr_branch {
+	u64 from, to;
+};
+
+volatile struct lbr_branch l2_branch;
+
+#define RECORD_BRANCH(b, s)						\
+({									\
+	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);			\
+	DO_BRANCH();							\
+	(b)->from = rdmsr(MSR_IA32_LASTBRANCHFROMIP);			\
+	(b)->to = rdmsr(MSR_IA32_LASTBRANCHTOIP);			\
+	/* Disabe LBR right after to avoid overriding the IPs */	\
+	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);					\
+									\
+	GUEST_ASSERT_NE((b)->from, 0);					\
+	GUEST_ASSERT_NE((b)->to, 0);					\
+	GUEST_PRINTF("%s: (0x%lx, 0x%lx)\n", (s), (b)->from, (b)->to);	\
+})									\
+
+#define CHECK_BRANCH_MSRS(b)						\
+({									\
+	GUEST_ASSERT_EQ((b)->from, rdmsr(MSR_IA32_LASTBRANCHFROMIP));	\
+	GUEST_ASSERT_EQ((b)->to, rdmsr(MSR_IA32_LASTBRANCHTOIP));	\
+})
+
+#define CHECK_BRANCH_VMCB(b, vmcb)					\
+({									\
+	GUEST_ASSERT_EQ((b)->from, vmcb->save.br_from);			\
+	GUEST_ASSERT_EQ((b)->to, vmcb->save.br_to);			\
+})									\
+
+static void l2_guest_code(struct svm_test_data *svm)
+{
+	/* Record a branch, trigger save/restore, and make sure LBRs are intact */
+	RECORD_BRANCH(&l2_branch, "L2 branch");
+	GUEST_SYNC(true);
+	CHECK_BRANCH_MSRS(&l2_branch);
+	vmmcall();
+}
+
+static void l1_guest_code(struct svm_test_data *svm, bool nested_lbrv)
+{
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+	struct vmcb *vmcb = svm->vmcb;
+	struct lbr_branch l1_branch;
+
+	/* Record a branch, trigger save/restore, and make sure LBRs are intact */
+	RECORD_BRANCH(&l1_branch, "L1 branch");
+	GUEST_SYNC(true);
+	CHECK_BRANCH_MSRS(&l1_branch);
+
+	/* Run L2, which will also do the same */
+	generic_svm_setup(svm, l2_guest_code,
+			  &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+
+	if (nested_lbrv)
+		vmcb->control.virt_ext = LBR_CTL_ENABLE_MASK;
+	else
+		vmcb->control.virt_ext &= ~LBR_CTL_ENABLE_MASK;
+
+	run_guest(vmcb, svm->vmcb_gpa);
+	GUEST_ASSERT(svm->vmcb->control.exit_code == SVM_EXIT_VMMCALL);
+
+	/* Trigger save/restore one more time before checking, just for kicks */
+	GUEST_SYNC(true);
+
+	/*
+	 * If LBR_CTL_ENABLE is set, L1 and L2 should have separate LBR MSRs, so
+	 * expect L1's LBRs to remain intact and L2 LBRs to be in the VMCB.
+	 * Otherwise, the MSRs are shared between L1 & L2 so expect L2's LBRs.
+	 */
+	if (nested_lbrv) {
+		CHECK_BRANCH_MSRS(&l1_branch);
+		CHECK_BRANCH_VMCB(&l2_branch, vmcb);
+	} else {
+		CHECK_BRANCH_MSRS(&l2_branch);
+	}
+	GUEST_DONE();
+}
+
+void test_lbrv_nested_state(bool nested_lbrv)
+{
+	struct kvm_x86_state *state = NULL;
+	struct kvm_vcpu *vcpu;
+	vm_vaddr_t svm_gva;
+	struct kvm_vm *vm;
+	struct ucall uc;
+
+	pr_info("Testing with nested LBRV %s\n", nested_lbrv ? "enabled" : "disabled");
+
+	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
+	vcpu_alloc_svm(vm, &svm_gva);
+	vcpu_args_set(vcpu, 2, svm_gva, nested_lbrv);
+
+	for (;;) {
+		vcpu_run(vcpu);
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_SYNC:
+			/* Save the vCPU state and restore it in a new VM on sync */
+			pr_info("Guest triggered save/restore.\n");
+			state = vcpu_save_state(vcpu);
+			kvm_vm_release(vm);
+			vcpu = vm_recreate_with_one_vcpu(vm);
+			vcpu_load_state(vcpu, state);
+			break;
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			/* NOT REACHED */
+		case UCALL_DONE:
+			goto done;
+		case UCALL_PRINTF:
+			pr_info("%s", uc.buffer);
+			break;
+		default:
+			TEST_FAIL("Unknown ucall %lu", uc.cmd);
+		}
+	}
+done:
+	if (state)
+		kvm_x86_state_cleanup(state);
+	kvm_vm_free(vm);
+}
+
+int main(int argc, char *argv[])
+{
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SVM));
+	TEST_REQUIRE(kvm_is_lbrv_enabled());
+
+	test_lbrv_nested_state(/*nested_lbrv=*/false);
+	test_lbrv_nested_state(/*nested_lbrv=*/true);
+
+	return 0;
+}
-- 
2.52.0.457.g6b5491de43-goog


