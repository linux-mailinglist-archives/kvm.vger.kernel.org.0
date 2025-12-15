Return-Path: <kvm+bounces-66008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A02A5CBF8D6
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 20:32:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 71BBD3064AFF
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 19:28:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC1BA335074;
	Mon, 15 Dec 2025 19:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iUY0s+Y3"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF3A331A61
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 19:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765826885; cv=none; b=EErS938iPUxNEaxMlUMNjZCwcGfePOOM4yMnfSfjiVadOfE84/7v8ZW8JM4TTVVfT89KnVZYaZmiSSktCNmLGADFsSgu/sRbMrOWVhgWtO6YsDDksKnnqT5u1fYFyd7Icf/aGTArgXFuNs0a+p18zRH/Gmk/1pWgoLVnlRkstd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765826885; c=relaxed/simple;
	bh=JMu+nav32/6jSiqHlWaokmwfZDSFXeRjS4z6HN/a9V8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kRaf/JQo34hCLEiTMxgk6kFdySAgZ0EA2i0F/0mOWqEhsZ+5F1V5A0gsG4iyHYLPK9K14N20CBQhW5VxjSAoK7C8g60Fd7Z3eBDUHqABHYTELcryO7o/4hLBIgrmukrYCHyk7AM04bpAuEEOZiNfSvWEMNurQxXiYo4If2dg9ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iUY0s+Y3; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765826881;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r2Sx5iN5diw9/TVwmnJZPfs9EnFNTBhzNLtGtuRxwuY=;
	b=iUY0s+Y3WTY4LCAJc9woG/4vaZTWK5/7hTmZ9JIBQ6ybFGSV/+ku4JeZgiOrHbpdMkAY4U
	QQxeftC7citGc1zMvidjbTWX5yLivUsywe7gWW0utIKidS97M52ZDYqqZ+ZuRzTBs+nzjy
	8NDE6dTnonLyDBN3vBPTiYGzgP5oGUU=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v3 03/26] KVM: selftests: Add a test for LBR save/restore (ft. nested)
Date: Mon, 15 Dec 2025 19:26:58 +0000
Message-ID: <20251215192722.3654335-5-yosry.ahmed@linux.dev>
In-Reply-To: <20251215192722.3654335-1-yosry.ahmed@linux.dev>
References: <20251215192722.3654335-1-yosry.ahmed@linux.dev>
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
index ba5c2b643efa..5cc972bcb8a7 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -109,6 +109,7 @@ TEST_GEN_PROGS_x86 += x86/svm_vmcall_test
 TEST_GEN_PROGS_x86 += x86/svm_int_ctl_test
 TEST_GEN_PROGS_x86 += x86/svm_nested_shutdown_test
 TEST_GEN_PROGS_x86 += x86/svm_nested_soft_inject_test
+TEST_GEN_PROGS_x86 += x86/svm_lbr_nested_state
 TEST_GEN_PROGS_x86 += x86/tsc_scaling_sync
 TEST_GEN_PROGS_x86 += x86/sync_regs_test
 TEST_GEN_PROGS_x86 += x86/ucna_injection_test
diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index 57d62a425109..aeb672927d69 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -1367,6 +1367,11 @@ static inline bool kvm_is_ignore_msrs(void)
 	return get_kvm_param_bool("ignore_msrs");
 }
 
+static inline bool kvm_is_lbrv_enabled(void)
+{
+	return !!get_kvm_amd_param_integer("lbrv");
+}
+
 uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr,
 				    int *level);
 uint64_t *vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr);
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
2.52.0.239.gd5f0c6e74e-goog


