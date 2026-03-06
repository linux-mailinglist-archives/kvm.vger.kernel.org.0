Return-Path: <kvm+bounces-73167-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GLkpKJtCq2nJbgEAu9opvQ
	(envelope-from <kvm+bounces-73167-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 22:09:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C640227BB7
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 22:09:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B69A33035011
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 21:09:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F292D48BD49;
	Fri,  6 Mar 2026 21:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mDn2NpkC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244D448AE20;
	Fri,  6 Mar 2026 21:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772831353; cv=none; b=rAUvYc8wkPm4lIxKmm1237VXQ5+hxW1sbeYvNG7qPGfSJ+NAtl+P0h+Ieo93GCwWA5nET2holfPV++qQp4qVNgR1ZGQKH19GFFu7ruQEnKBUjclsxH09L4omkCkdRXzNA9KKwWi2G1f5xBm+T1DpIj07Pbv81O043nwthJH3s0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772831353; c=relaxed/simple;
	bh=Av1cyNcaTB4l8UeQo3DpVXvBAlWkTHHvygscY34OLk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AG41CA1W86Y+1L0XUhQg4IakgQXahOxBelw5gPNClzKR+pVb4zPB0aSZ15F1TYiqvQktSyIMnue+CWmGlwPj8PwJ3yLO3UiThd/4lowIJNszLBLd6TDxX4UfGKitt7U/XFUJ+IL40GxupMTiD9zHVvIbzCN3TePA7Sy8txBKMHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mDn2NpkC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1434C2BCB1;
	Fri,  6 Mar 2026 21:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772831352;
	bh=Av1cyNcaTB4l8UeQo3DpVXvBAlWkTHHvygscY34OLk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mDn2NpkCUND+DWxA5/u3AR6+RqtDHuJDdAteMk+AiVpeVsplIvsnZhTxAIg8qXc8j
	 4SyDlSNUpNkCqVgRDJbwSoTi03eEr/rnmv4GG8DmNvAoNihJNpH9aLKK3Ji+iNRrrB
	 QYEvOmmK3Uz2kc6Y/LO7m5CZA/kSf9inIACk89IB0qxNRAuiNK9IyQNm62U5AAyfWI
	 HVPQIJCA7FhfpV7tPdlxNYFZntaJXHNOZAeDBqJABTJFF7Zh/+/R9IkBbKWMO8mAo9
	 TH/w2HYJUk6brY/yx9MX5mBdG8EcB6xrTQHjcbI97US/sCWQXbGQxm5fP0y4IkVSab
	 F1ZTyymg2w7tQ==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH v2 5/6] KVM: selftests: Rework svm_nested_invalid_vmcb12_gpa
Date: Fri,  6 Mar 2026 21:08:59 +0000
Message-ID: <20260306210900.1933788-6-yosry@kernel.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
In-Reply-To: <20260306210900.1933788-1-yosry@kernel.org>
References: <20260306210900.1933788-1-yosry@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4C640227BB7
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73167-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-0.981];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

The test currently allegedly makes sure that VMRUN causes a #GP in
vmcb12 GPA is valid but unmappable. However, it calls run_guest() with
an the test vmcb12 GPA, and the #GP is produced from VMLOAD, not VMRUN.

Additionally, the underlying just changed to match architectural
behavior, and all of VMRUN/VMLOAD/VMSAVE fail emulation if vmcb12 cannot
be mapped. The CPU still injects a #GP if the vmcb12 GPA exceeds
maxphyaddr.

Rework the test such to use the KVM_ONE_VCPU_TEST[_SUITE] harness, and
test all of VMRUN/VMLOAD/VMSAVE with both an invalid GPA (-1ULL) causing
a #GP, and a valid but unmappable GPA causing emulation failure. Execute
the instructions directly from L1 instead of run_guest() to make sure
the #GP or emulation failure is produced by the right instruction.

Leave the #VMEXIT with unmappable GPA test case as-is, but wrap it with
a test harness as well.

Opportunisitically drop gp_triggered, as the test already checks that
a #GP was injected through a SYNC, and add an assertion that the max
legal GPA is in fact not mapped by userspace (i.e. KVM cannot map it).

Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 .../testing/selftests/kvm/include/kvm_util.h  |   1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |   6 +
 .../kvm/x86/svm_nested_invalid_vmcb12_gpa.c   | 153 +++++++++++++-----
 3 files changed, 124 insertions(+), 36 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 8b39cb919f4fc..61fb2cb7df288 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -734,6 +734,7 @@ void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa);
 void *addr_gva2hva(struct kvm_vm *vm, vm_vaddr_t gva);
 vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva);
 void *addr_gpa2alias(struct kvm_vm *vm, vm_paddr_t gpa);
+bool addr_gpa_has_hva(struct kvm_vm *vm, vm_paddr_t gpa);
 
 #ifndef vcpu_arch_put_guest
 #define vcpu_arch_put_guest(mem, val) do { (mem) = (val); } while (0)
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 1959bf556e88e..9cf68a558c08b 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1710,6 +1710,12 @@ void *addr_gpa2alias(struct kvm_vm *vm, vm_paddr_t gpa)
 	return (void *) ((uintptr_t) region->host_alias + offset);
 }
 
+bool addr_gpa_has_hva(struct kvm_vm *vm, vm_paddr_t gpa)
+{
+	gpa = vm_untag_gpa(vm, gpa);
+	return !!userspace_mem_region_find(vm, gpa, gpa);
+}
+
 /* Create an interrupt controller chip for the specified VM. */
 void vm_create_irqchip(struct kvm_vm *vm)
 {
diff --git a/tools/testing/selftests/kvm/x86/svm_nested_invalid_vmcb12_gpa.c b/tools/testing/selftests/kvm/x86/svm_nested_invalid_vmcb12_gpa.c
index c6d5f712120d1..3eaee8ad90211 100644
--- a/tools/testing/selftests/kvm/x86/svm_nested_invalid_vmcb12_gpa.c
+++ b/tools/testing/selftests/kvm/x86/svm_nested_invalid_vmcb12_gpa.c
@@ -6,6 +6,8 @@
 #include "vmx.h"
 #include "svm_util.h"
 #include "kselftest.h"
+#include "kvm_test_harness.h"
+#include "test_util.h"
 
 
 #define L2_GUEST_STACK_SIZE 64
@@ -13,86 +15,165 @@
 #define SYNC_GP 101
 #define SYNC_L2_STARTED 102
 
-u64 valid_vmcb12_gpa;
-int gp_triggered;
+static unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
 
 static void guest_gp_handler(struct ex_regs *regs)
 {
-	GUEST_ASSERT(!gp_triggered);
 	GUEST_SYNC(SYNC_GP);
-	gp_triggered = 1;
-	regs->rax = valid_vmcb12_gpa;
 }
 
-static void l2_guest_code(void)
+static void l2_code(void)
 {
 	GUEST_SYNC(SYNC_L2_STARTED);
 	vmcall();
 }
 
-static void l1_guest_code(struct svm_test_data *svm, u64 invalid_vmcb12_gpa)
+static void l1_vmrun(struct svm_test_data *svm, u64 gpa)
 {
-	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+	generic_svm_setup(svm, l2_code, &l2_guest_stack[L2_GUEST_STACK_SIZE]);
 
-	generic_svm_setup(svm, l2_guest_code,
-			  &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+	asm volatile ("vmrun %[gpa]" : : [gpa] "a" (gpa) : "memory");
+}
+
+static void l1_vmload(struct svm_test_data *svm, u64 gpa)
+{
+	generic_svm_setup(svm, l2_code, &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+
+	asm volatile ("vmload %[gpa]" : : [gpa] "a" (gpa) : "memory");
+}
 
-	valid_vmcb12_gpa = svm->vmcb_gpa;
+static void l1_vmsave(struct svm_test_data *svm, u64 gpa)
+{
+	generic_svm_setup(svm, l2_code, &l2_guest_stack[L2_GUEST_STACK_SIZE]);
 
-	run_guest(svm->vmcb, invalid_vmcb12_gpa); /* #GP */
+	asm volatile ("vmsave %[gpa]" : : [gpa] "a" (gpa) : "memory");
+}
 
-	/* GP handler should jump here */
+static void l1_vmexit(struct svm_test_data *svm, u64 gpa)
+{
+	generic_svm_setup(svm, l2_code, &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+
+	run_guest(svm->vmcb, svm->vmcb_gpa);
 	GUEST_ASSERT(svm->vmcb->control.exit_code == SVM_EXIT_VMMCALL);
 	GUEST_DONE();
 }
 
-int main(int argc, char *argv[])
+/*
+ * Find the max legal GPA that is not backed by a memslot (i.e. cannot be mapped
+ * by KVM).
+ */
+static u64 unmappable_gpa(struct kvm_vcpu *vcpu)
 {
-	struct kvm_x86_state *state;
-	vm_vaddr_t nested_gva = 0;
-	struct kvm_vcpu *vcpu;
 	uint32_t maxphyaddr;
 	u64 max_legal_gpa;
-	struct kvm_vm *vm;
-	struct ucall uc;
-
-	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SVM));
-
-	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
-	vm_install_exception_handler(vcpu->vm, GP_VECTOR, guest_gp_handler);
 
-	/*
-	 * Find the max legal GPA that is not backed by a memslot (i.e. cannot
-	 * be mapped by KVM).
-	 */
 	maxphyaddr = kvm_cpuid_property(vcpu->cpuid, X86_PROPERTY_MAX_PHY_ADDR);
 	max_legal_gpa = BIT_ULL(maxphyaddr) - PAGE_SIZE;
-	vcpu_alloc_svm(vm, &nested_gva);
-	vcpu_args_set(vcpu, 2, nested_gva, max_legal_gpa);
+	TEST_ASSERT(!addr_gpa_has_hva(vcpu->vm, max_legal_gpa),
+		    "Expected max_legal_gpa to not be mapped by userspace");
+
+	return max_legal_gpa;
+}
+
+static void test_invalid_vmcb12(struct kvm_vcpu *vcpu)
+{
+	vm_vaddr_t nested_gva = 0;
+	struct ucall uc;
+
 
-	/* VMRUN with max_legal_gpa, KVM injects a #GP */
+	vm_install_exception_handler(vcpu->vm, GP_VECTOR, guest_gp_handler);
+	vcpu_alloc_svm(vcpu->vm, &nested_gva);
+	vcpu_args_set(vcpu, 2, nested_gva, -1ULL);
 	vcpu_run(vcpu);
+
 	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 	TEST_ASSERT_EQ(get_ucall(vcpu, &uc), UCALL_SYNC);
 	TEST_ASSERT_EQ(uc.args[1], SYNC_GP);
+}
+
+static void test_unmappable_vmcb12(struct kvm_vcpu *vcpu)
+{
+	vm_vaddr_t nested_gva = 0;
+
+	vcpu_alloc_svm(vcpu->vm, &nested_gva);
+	vcpu_args_set(vcpu, 2, nested_gva, unmappable_gpa(vcpu));
+	vcpu_run(vcpu);
+
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_INTERNAL_ERROR);
+	TEST_ASSERT_EQ(vcpu->run->emulation_failure.suberror, KVM_INTERNAL_ERROR_EMULATION);
+}
+
+static void test_unmappable_vmcb12_vmexit(struct kvm_vcpu *vcpu)
+{
+	struct kvm_x86_state *state;
+	vm_vaddr_t nested_gva = 0;
+	struct ucall uc;
 
 	/*
-	 * Enter L2 (with a legit vmcb12 GPA), then overwrite vmcb12 GPA with
-	 * max_legal_gpa. KVM will fail to map vmcb12 on nested VM-Exit and
+	 * Enter L2 (with a legit vmcb12 GPA), then overwrite vmcb12 GPA with an
+	 * unmappable GPA. KVM will fail to map vmcb12 on nested VM-Exit and
 	 * cause a shutdown.
 	 */
+	vcpu_alloc_svm(vcpu->vm, &nested_gva);
+	vcpu_args_set(vcpu, 2, nested_gva, unmappable_gpa(vcpu));
 	vcpu_run(vcpu);
 	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 	TEST_ASSERT_EQ(get_ucall(vcpu, &uc), UCALL_SYNC);
 	TEST_ASSERT_EQ(uc.args[1], SYNC_L2_STARTED);
 
 	state = vcpu_save_state(vcpu);
-	state->nested.hdr.svm.vmcb_pa = max_legal_gpa;
+	state->nested.hdr.svm.vmcb_pa = unmappable_gpa(vcpu);
 	vcpu_load_state(vcpu, state);
 	vcpu_run(vcpu);
 	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_SHUTDOWN);
 
 	kvm_x86_state_cleanup(state);
-	kvm_vm_free(vm);
-	return 0;
+}
+
+KVM_ONE_VCPU_TEST_SUITE(vmcb12_gpa);
+
+KVM_ONE_VCPU_TEST(vmcb12_gpa, vmrun_invalid, l1_vmrun)
+{
+	test_invalid_vmcb12(vcpu);
+}
+
+KVM_ONE_VCPU_TEST(vmcb12_gpa, vmload_invalid, l1_vmload)
+{
+	test_invalid_vmcb12(vcpu);
+}
+
+KVM_ONE_VCPU_TEST(vmcb12_gpa, vmsave_invalid, l1_vmsave)
+{
+	test_invalid_vmcb12(vcpu);
+}
+
+KVM_ONE_VCPU_TEST(vmcb12_gpa, vmrun_unmappable, l1_vmrun)
+{
+	test_unmappable_vmcb12(vcpu);
+}
+
+KVM_ONE_VCPU_TEST(vmcb12_gpa, vmload_unmappable, l1_vmload)
+{
+	test_unmappable_vmcb12(vcpu);
+}
+
+KVM_ONE_VCPU_TEST(vmcb12_gpa, vmsave_unmappable, l1_vmsave)
+{
+	test_unmappable_vmcb12(vcpu);
+}
+
+/*
+ * Invalid vmcb12_gpa cannot be test for #VMEXIT as KVM_SET_NESTED_STATE will
+ * reject it.
+ */
+KVM_ONE_VCPU_TEST(vmcb12_gpa, vmexit_unmappable, l1_vmexit)
+{
+	test_unmappable_vmcb12_vmexit(vcpu);
+}
+
+int main(int argc, char *argv[])
+{
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SVM));
+
+	return test_harness_run(argc, argv);
 }
-- 
2.53.0.473.g4a7958ca14-goog


