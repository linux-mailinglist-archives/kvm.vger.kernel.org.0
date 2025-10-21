Return-Path: <kvm+bounces-60633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 95C7BBF51B5
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 09:55:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 05E1A48104C
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 07:54:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D65DF30147A;
	Tue, 21 Oct 2025 07:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ppU0f2fb"
X-Original-To: kvm@vger.kernel.org
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAFD928B400
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 07:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761032948; cv=none; b=Ty/P6UD2WpyxbAIct5TPT5RmuEFQm2khnNTw5ERJMoTr13xegn2XlkB9YF6vFNz5pCuF3WqYg5BFSsURYQNgBQLRJUeFzDqGiSKRLeRMvvlDo1vmCm62HtiauZKWvf/P14IFp7g3UV1iFkIv1Osw8R7EMArnWXBbWf1SZ1Jf+mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761032948; c=relaxed/simple;
	bh=BWjjU2HKoLpoa5fyPHPeS2e/Dk30hm1fbnvjRdjuM1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ncLBUtGIwI/s5ILPWKBeFko4fDrblmcWrRrCFLTBkplVJ0TOtJRYmXTbDTV0XUj42er8Rk1a4bCPokrTnbcTMgDcc8yAWMKWyp5HvQYMOE4Uy0Pc9R2TjO3TvxNssVVEN3yOnmSmIWrB4d0+1hY8tgRoEOzWiVCVgVSfQm5MEv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ppU0f2fb; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761032945;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=43aBeNU09hJRraidYPzzQ4LCuZvZURAPpWAOqYnF9OM=;
	b=ppU0f2fbMfFk/9wxi4fKboQA48FVbeNvJTOjY2Prc7FPdQHFdaFwujnt2Hihh/rlOaSkv+
	jRjY/BQJgVyYr6WBgdb8OEBjTrldkvcfxUcYi9iM5d2o3US4AJRWOS5lPXUIMDCUCQdgtE
	sV8hz0ZRTWvVfzLZhF0Ey1upvSdFw/U=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v2 23/23] KVM: selftests: Extend vmx_dirty_log_test to cover SVM
Date: Tue, 21 Oct 2025 07:47:36 +0000
Message-ID: <20251021074736.1324328-24-yosry.ahmed@linux.dev>
In-Reply-To: <20251021074736.1324328-1-yosry.ahmed@linux.dev>
References: <20251021074736.1324328-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add prepare_ncr3() to initialize the nested NPTs, and enable NPT from L1
accordingly. Everything else should work for creating nested NPT
mappings.

Generalize the code in vmx_dirty_log_test.c by adding SVM-specific L1
code, doing some renaming (e.g. EPT -> TDP), and having setup code for
both SVM and VMX in test_dirty_log().

Having multiple points to check for SVM vs VMX is not ideal, but the
alternatives either include a lot of redundancy or a lot of abstracting
functions that will make the test logic harder to follow.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 tools/testing/selftests/kvm/Makefile.kvm      |  2 +-
 .../selftests/kvm/include/x86/svm_util.h      |  8 ++
 tools/testing/selftests/kvm/lib/x86/svm.c     | 19 ++++
 ...rty_log_test.c => nested_dirty_log_test.c} | 96 +++++++++++++------
 4 files changed, 97 insertions(+), 28 deletions(-)
 rename tools/testing/selftests/kvm/x86/{vmx_dirty_log_test.c => nested_dirty_log_test.c} (62%)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 6625ac53545e8..5da95776fc9c2 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -114,7 +114,7 @@ TEST_GEN_PROGS_x86 += x86/userspace_io_test
 TEST_GEN_PROGS_x86 += x86/userspace_msr_exit_test
 TEST_GEN_PROGS_x86 += x86/vmx_apic_access_test
 TEST_GEN_PROGS_x86 += x86/close_while_nested_test
-TEST_GEN_PROGS_x86 += x86/vmx_dirty_log_test
+TEST_GEN_PROGS_x86 += x86/nested_dirty_log_test
 TEST_GEN_PROGS_x86 += x86/vmx_exception_with_invalid_guest_state
 TEST_GEN_PROGS_x86 += x86/vmx_msrs_test
 TEST_GEN_PROGS_x86 += x86/vmx_invalid_nested_guest_state
diff --git a/tools/testing/selftests/kvm/include/x86/svm_util.h b/tools/testing/selftests/kvm/include/x86/svm_util.h
index b74c6dcddcbd6..70bb22dd6de54 100644
--- a/tools/testing/selftests/kvm/include/x86/svm_util.h
+++ b/tools/testing/selftests/kvm/include/x86/svm_util.h
@@ -27,6 +27,11 @@ struct svm_test_data {
 	void *msr; /* gva */
 	void *msr_hva;
 	uint64_t msr_gpa;
+
+	/* NPT */
+	void *ncr3; /* gva */
+	void *ncr3_hva;
+	uint64_t ncr3_gpa;
 };
 
 static inline void vmmcall(void)
@@ -57,6 +62,9 @@ struct svm_test_data *vcpu_alloc_svm(struct kvm_vm *vm, vm_vaddr_t *p_svm_gva);
 void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_rsp);
 void run_guest(struct vmcb *vmcb, uint64_t vmcb_gpa);
 
+bool kvm_cpu_has_npt(void);
+void prepare_ncr3(struct svm_test_data *svm, struct kvm_vm *vm);
+
 int open_sev_dev_path_or_exit(void);
 
 #endif /* SELFTEST_KVM_SVM_UTILS_H */
diff --git a/tools/testing/selftests/kvm/lib/x86/svm.c b/tools/testing/selftests/kvm/lib/x86/svm.c
index d239c20973918..190a8044dba0e 100644
--- a/tools/testing/selftests/kvm/lib/x86/svm.c
+++ b/tools/testing/selftests/kvm/lib/x86/svm.c
@@ -59,6 +59,20 @@ static void vmcb_set_seg(struct vmcb_seg *seg, u16 selector,
 	seg->base = base;
 }
 
+bool kvm_cpu_has_npt(void)
+{
+	return kvm_cpu_has(X86_FEATURE_NPT);
+}
+
+void prepare_ncr3(struct svm_test_data *svm, struct kvm_vm *vm)
+{
+	TEST_ASSERT(kvm_cpu_has_npt(), "KVM doesn't support nested NPT");
+
+	svm->ncr3 = (void *)vm_vaddr_alloc_page(vm);
+	svm->ncr3_hva = addr_gva2hva(vm, (uintptr_t)svm->ncr3);
+	svm->ncr3_gpa = addr_gva2gpa(vm, (uintptr_t)svm->ncr3);
+}
+
 void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_rsp)
 {
 	struct vmcb *vmcb = svm->vmcb;
@@ -102,6 +116,11 @@ void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_r
 	vmcb->save.rip = (u64)guest_rip;
 	vmcb->save.rsp = (u64)guest_rsp;
 	guest_regs.rdi = (u64)svm;
+
+	if (svm->ncr3_gpa) {
+		ctrl->nested_ctl |= SVM_NESTED_CTL_NP_ENABLE;
+		ctrl->nested_cr3 = svm->ncr3_gpa;
+	}
 }
 
 /*
diff --git a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c b/tools/testing/selftests/kvm/x86/nested_dirty_log_test.c
similarity index 62%
rename from tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
rename to tools/testing/selftests/kvm/x86/nested_dirty_log_test.c
index b8ebb246aaf15..06c94e77b44bd 100644
--- a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
+++ b/tools/testing/selftests/kvm/x86/nested_dirty_log_test.c
@@ -12,6 +12,7 @@
 #include "test_util.h"
 #include "kvm_util.h"
 #include "processor.h"
+#include "svm_util.h"
 #include "vmx.h"
 
 /* The memory slot index to track dirty pages */
@@ -25,6 +26,8 @@
 #define NESTED_TEST_MEM1		0xc0001000
 #define NESTED_TEST_MEM2		0xc0002000
 
+#define L2_GUEST_STACK_SIZE 64
+
 static void l2_guest_code(u64 *a, u64 *b)
 {
 	READ_ONCE(*a);
@@ -42,20 +45,19 @@ static void l2_guest_code(u64 *a, u64 *b)
 	vmcall();
 }
 
-static void l2_guest_code_ept_enabled(void)
+static void l2_guest_code_tdp_enabled(void)
 {
 	l2_guest_code((u64 *)NESTED_TEST_MEM1, (u64 *)NESTED_TEST_MEM2);
 }
 
-static void l2_guest_code_ept_disabled(void)
+static void l2_guest_code_tdp_disabled(void)
 {
-	/* Access the same L1 GPAs as l2_guest_code_ept_enabled() */
+	/* Access the same L1 GPAs as l2_guest_code_tdp_enabled() */
 	l2_guest_code((u64 *)GUEST_TEST_MEM, (u64 *)GUEST_TEST_MEM);
 }
 
-void l1_guest_code(struct vmx_pages *vmx)
+void l1_vmx_code(struct vmx_pages *vmx)
 {
-#define L2_GUEST_STACK_SIZE 64
 	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
 	void *l2_rip;
 
@@ -64,23 +66,51 @@ void l1_guest_code(struct vmx_pages *vmx)
 	GUEST_ASSERT(load_vmcs(vmx));
 
 	if (vmx->eptp_gpa)
-		l2_rip = l2_guest_code_ept_enabled;
+		l2_rip = l2_guest_code_tdp_enabled;
 	else
-		l2_rip = l2_guest_code_ept_disabled;
+		l2_rip = l2_guest_code_tdp_disabled;
 
 	prepare_vmcs(vmx, l2_rip, &l2_guest_stack[L2_GUEST_STACK_SIZE]);
 
 	GUEST_SYNC(false);
 	GUEST_ASSERT(!vmlaunch());
 	GUEST_SYNC(false);
-	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
+	GUEST_ASSERT_EQ(vmreadz(VM_EXIT_REASON), EXIT_REASON_VMCALL);
+	GUEST_DONE();
+}
+
+static void l1_svm_code(struct svm_test_data *svm)
+{
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+	void *l2_rip;
+
+	if (svm->ncr3_gpa)
+		l2_rip = l2_guest_code_tdp_enabled;
+	else
+		l2_rip = l2_guest_code_tdp_disabled;
+
+	generic_svm_setup(svm, l2_rip, &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+
+	GUEST_SYNC(false);
+	run_guest(svm->vmcb, svm->vmcb_gpa);
+	GUEST_SYNC(false);
+	GUEST_ASSERT_EQ(svm->vmcb->control.exit_code, SVM_EXIT_VMMCALL);
 	GUEST_DONE();
 }
 
-static void test_vmx_dirty_log(bool enable_ept)
+static void l1_guest_code(void *data)
 {
-	vm_vaddr_t vmx_pages_gva = 0;
-	struct vmx_pages *vmx;
+	if (this_cpu_has(X86_FEATURE_VMX))
+		l1_vmx_code(data);
+	else
+		l1_svm_code(data);
+}
+
+static void test_dirty_log(bool nested_tdp)
+{
+	struct svm_test_data *svm = NULL;
+	struct vmx_pages *vmx = NULL;
+	vm_vaddr_t nested_gva = 0;
 	unsigned long *bmap;
 	uint64_t *host_test_mem;
 
@@ -89,12 +119,16 @@ static void test_vmx_dirty_log(bool enable_ept)
 	struct ucall uc;
 	bool done = false;
 
-	pr_info("Nested EPT: %s\n", enable_ept ? "enabled" : "disabled");
+	pr_info("Nested TDP: %s\n", nested_tdp ? "enabled" : "disabled");
 
 	/* Create VM */
 	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
-	vmx = vcpu_alloc_vmx(vm, &vmx_pages_gva);
-	vcpu_args_set(vcpu, 1, vmx_pages_gva);
+	if (kvm_cpu_has(X86_FEATURE_VMX))
+		vmx = vcpu_alloc_vmx(vm, &nested_gva);
+	else
+		svm = vcpu_alloc_svm(vm, &nested_gva);
+
+	vcpu_args_set(vcpu, 1, nested_gva);
 
 	/* Add an extra memory slot for testing dirty logging */
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
@@ -113,17 +147,25 @@ static void test_vmx_dirty_log(bool enable_ept)
 	 * ... pages in the L2 GPA range [0xc0001000, 0xc0003000) will map to
 	 * 0xc0000000.
 	 *
-	 * Note that prepare_eptp should be called only L1's GPA map is done,
-	 * meaning after the last call to virt_map.
+	 * Note that prepare_eptp()/prepare_ncr3() should be called only when
+	 * L1's GPA map is done, meaning after the last call to virt_map.
 	 *
-	 * When EPT is disabled, the L2 guest code will still access the same L1
-	 * GPAs as the EPT enabled case.
+	 * When TDP is disabled, the L2 guest code will still access the same L1
+	 * GPAs as the TDP enabled case.
 	 */
-	if (enable_ept) {
-		prepare_eptp(vmx, vm);
-		nested_identity_map_default_memslots(vm, vmx->eptp_gpa);
-		nested_map(vm, vmx->eptp_gpa, NESTED_TEST_MEM1, GUEST_TEST_MEM, PAGE_SIZE);
-		nested_map(vm, vmx->eptp_gpa, NESTED_TEST_MEM2, GUEST_TEST_MEM, PAGE_SIZE);
+	if (nested_tdp) {
+		uint64_t root_gpa;
+
+		if (kvm_cpu_has(X86_FEATURE_VMX)) {
+			prepare_eptp(vmx, vm);
+			root_gpa = vmx->eptp_gpa;
+		} else {
+			prepare_ncr3(svm, vm);
+			root_gpa = svm->ncr3_gpa;
+		}
+		nested_identity_map_default_memslots(vm, root_gpa);
+		nested_map(vm, root_gpa, NESTED_TEST_MEM1, GUEST_TEST_MEM, PAGE_SIZE);
+		nested_map(vm, root_gpa, NESTED_TEST_MEM2, GUEST_TEST_MEM, PAGE_SIZE);
 	}
 
 	bmap = bitmap_zalloc(TEST_MEM_PAGES);
@@ -168,12 +210,12 @@ static void test_vmx_dirty_log(bool enable_ept)
 
 int main(int argc, char *argv[])
 {
-	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX) || kvm_cpu_has(X86_FEATURE_SVM));
 
-	test_vmx_dirty_log(/*enable_ept=*/false);
+	test_dirty_log(/*nested_tdp=*/false);
 
-	if (kvm_cpu_has_ept())
-		test_vmx_dirty_log(/*enable_ept=*/true);
+	if (kvm_cpu_has_ept() || kvm_cpu_has_npt())
+		test_dirty_log(/*nested_tdp=*/true);
 
 	return 0;
 }
-- 
2.51.0.869.ge66316f041-goog


