Return-Path: <kvm+bounces-59314-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 823F5BB0F43
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 17:08:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9895E3ACCA9
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 15:04:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6E4D30EF7E;
	Wed,  1 Oct 2025 14:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FZ1Y/c5W"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EDE230E0C7
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 14:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759330745; cv=none; b=fKRMUNNfGCzGd4CtGh4btaGkKaqgaMWN3oOtN97i0xyMYBKH0mk4+uB867VN0a13OuBHSTkA4K6cfqHeN+13CayGM6yac2jjQ1hLstB86VX+zjeQjXFeh9c6Doq09yuuha5IIfCG/HAUgBoLGrPaRZzjSoQzK8/BOUfvJTU36pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759330745; c=relaxed/simple;
	bh=3XZH7BRfy9GZsl2l9dW0v0fS+AFAUfjkshK6UQgXYew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WPW/KupyUXqX6VehX5fymU24AdCWHtAb3//gWJXn5IU6tQjqYqJxxTqRPyh0/nGC+BVVXWAgfzPA8Z0C0nnv02cKlpYofPZqGwJBdi1VGf2cWaKAhAdDyaJQci/LmbBHR/dwTg8ICWs2c8U46fpufiIuVU1CWT8W83Xc3DPm5Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FZ1Y/c5W; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759330740;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=njLgviB8zkOyaMBe4TukJ4UcfLgF0Cr0ukv2OYqfgrI=;
	b=FZ1Y/c5WydlXzXQ6g6dQwVlvLoBYC2BsJimarpYifney7ha8MVlq//kjk06omLorh+N8M7
	MPgvAE86qGjwt0h982X1UV5eAQSlwZE70GTZXqvyy4FNon70Qg6sm7kY3CBJcL9+APUWag
	aofYjPDQ6e0IsCBl3BLG8ng6elG9y6Q=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosryahmed@google.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 12/12] KVM: selftests: Extend vmx_dirty_log_test to cover SVM
Date: Wed,  1 Oct 2025 14:58:16 +0000
Message-ID: <20251001145816.1414855-13-yosry.ahmed@linux.dev>
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

Add the necessary infrastructure to support setting up nested NPTs and
creating nested NPT mappings. There is some redundancy between
nested_npt_create_pte() and nested_ept_create_pte(), especially that we
access the same fields in both. An alternative is to have a single
function in nested_map.c, and use macros to cast an obaque PTE pointer
to the correct type (EPT entry vs NPT entry).

Add a check in kvm_cpu_has_ept() to return false on AMD CPUs without
attempting to read VMX-specific MSRs, since now it can be called on AMD
CPUs. Generalize the code in vmx_dirty_log_test.c by adding SVM-specific
L1 code, doing some renaming (e.g. EPT -> TDP), and having setup code
for both SVM and VMX in test_dirty_log().

Having multiple points to check for SVM vs VMX is not ideal, but the
alternatives either include a lot of redundancy or a lot of abstracting
functions that will make the test logic harder to follow.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 tools/testing/selftests/kvm/Makefile.kvm      |  2 +-
 .../selftests/kvm/include/x86/svm_util.h      | 13 +++
 tools/testing/selftests/kvm/lib/x86/svm.c     | 70 ++++++++++++++
 tools/testing/selftests/kvm/lib/x86/vmx.c     |  3 +
 ...rty_log_test.c => nested_dirty_log_test.c} | 94 ++++++++++++++-----
 5 files changed, 155 insertions(+), 27 deletions(-)
 rename tools/testing/selftests/kvm/x86/{vmx_dirty_log_test.c => nested_dirty_log_test.c} (62%)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 9547d7263e236..acedbf726f493 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -113,7 +113,7 @@ TEST_GEN_PROGS_x86 += x86/userspace_io_test
 TEST_GEN_PROGS_x86 += x86/userspace_msr_exit_test
 TEST_GEN_PROGS_x86 += x86/vmx_apic_access_test
 TEST_GEN_PROGS_x86 += x86/close_while_nested_test
-TEST_GEN_PROGS_x86 += x86/vmx_dirty_log_test
+TEST_GEN_PROGS_x86 += x86/nested_dirty_log_test
 TEST_GEN_PROGS_x86 += x86/vmx_exception_with_invalid_guest_state
 TEST_GEN_PROGS_x86 += x86/vmx_msrs_test
 TEST_GEN_PROGS_x86 += x86/vmx_invalid_nested_guest_state
diff --git a/tools/testing/selftests/kvm/include/x86/svm_util.h b/tools/testing/selftests/kvm/include/x86/svm_util.h
index b74c6dcddcbd6..84b79113b5433 100644
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
@@ -57,6 +62,14 @@ struct svm_test_data *vcpu_alloc_svm(struct kvm_vm *vm, vm_vaddr_t *p_svm_gva);
 void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_rsp);
 void run_guest(struct vmcb *vmcb, uint64_t vmcb_gpa);
 
+bool nested_npt_create_pte(struct kvm_vm *vm,
+			   uint64_t *pte,
+			   uint64_t paddr,
+			   uint64_t *address,
+			   bool *leaf);
+bool kvm_cpu_has_npt(void);
+void prepare_npt(struct svm_test_data *svm, struct kvm_vm *vm);
+
 int open_sev_dev_path_or_exit(void);
 
 #endif /* SELFTEST_KVM_SVM_UTILS_H */
diff --git a/tools/testing/selftests/kvm/lib/x86/svm.c b/tools/testing/selftests/kvm/lib/x86/svm.c
index d239c20973918..9524abf7e779a 100644
--- a/tools/testing/selftests/kvm/lib/x86/svm.c
+++ b/tools/testing/selftests/kvm/lib/x86/svm.c
@@ -16,6 +16,23 @@
 struct gpr64_regs guest_regs;
 u64 rflags;
 
+struct nptPageTableEntry {
+       uint64_t present:1;
+       uint64_t writable:1;
+       uint64_t user:1;
+       uint64_t pwt:1;
+       uint64_t pcd:1;
+       uint64_t accessed:1;
+       uint64_t dirty:1;
+       uint64_t page_size:1;
+       uint64_t global:1;
+       uint64_t avail1:3;
+       uint64_t address:40;
+       uint64_t avail2:11;
+       uint64_t nx:1;
+};
+static_assert(sizeof(struct nptPageTableEntry) == sizeof(uint64_t));
+
 /* Allocate memory regions for nested SVM tests.
  *
  * Input Args:
@@ -59,6 +76,54 @@ static void vmcb_set_seg(struct vmcb_seg *seg, u16 selector,
 	seg->base = base;
 }
 
+bool nested_npt_create_pte(struct kvm_vm *vm,
+			   uint64_t *pte,
+			   uint64_t paddr,
+			   uint64_t *address,
+			   bool *leaf)
+{
+	struct nptPageTableEntry *npte = (struct nptPageTableEntry *)pte;
+
+	if (npte->present) {
+		*leaf = npte->page_size;
+		*address = npte->address;
+		return false;
+	}
+
+	npte->present = true;
+	npte->writable = true;
+	npte->page_size = *leaf;
+
+	if (*leaf)
+		npte->address = paddr >> vm->page_shift;
+	else
+		npte->address = vm_alloc_page_table(vm) >> vm->page_shift;
+
+	*address = npte->address;
+
+	/*
+	 * For now mark these as accessed and dirty because the only
+	 * testcase we have needs that.  Can be reconsidered later.
+	 */
+	npte->accessed = *leaf;
+	npte->dirty = *leaf;
+	return true;
+}
+
+bool kvm_cpu_has_npt(void)
+{
+       return kvm_cpu_has(X86_FEATURE_NPT);
+}
+
+void prepare_npt(struct svm_test_data *svm, struct kvm_vm *vm)
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
@@ -102,6 +167,11 @@ void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_r
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
diff --git a/tools/testing/selftests/kvm/lib/x86/vmx.c b/tools/testing/selftests/kvm/lib/x86/vmx.c
index 24345213fcd04..0ced959184cd9 100644
--- a/tools/testing/selftests/kvm/lib/x86/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
@@ -405,6 +405,9 @@ bool kvm_cpu_has_ept(void)
 {
 	uint64_t ctrl;
 
+	if (!kvm_cpu_has(X86_FEATURE_VMX))
+		return false;
+
 	ctrl = kvm_get_feature_msr(MSR_IA32_VMX_TRUE_PROCBASED_CTLS) >> 32;
 	if (!(ctrl & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS))
 		return false;
diff --git a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c b/tools/testing/selftests/kvm/x86/nested_dirty_log_test.c
similarity index 62%
rename from tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
rename to tools/testing/selftests/kvm/x86/nested_dirty_log_test.c
index db88a1e5e9d0c..56f741ddce944 100644
--- a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
+++ b/tools/testing/selftests/kvm/x86/nested_dirty_log_test.c
@@ -13,6 +13,7 @@
 #include "kvm_util.h"
 #include "nested_map.h"
 #include "processor.h"
+#include "svm_util.h"
 #include "vmx.h"
 
 /* The memory slot index to track dirty pages */
@@ -26,6 +27,8 @@
 #define NESTED_TEST_MEM1		0xc0001000
 #define NESTED_TEST_MEM2		0xc0002000
 
+#define L2_GUEST_STACK_SIZE 64
+
 static void l2_guest_code(u64 *a, u64 *b)
 {
 	READ_ONCE(*a);
@@ -43,20 +46,19 @@ static void l2_guest_code(u64 *a, u64 *b)
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
 
@@ -65,9 +67,9 @@ void l1_guest_code(struct vmx_pages *vmx)
 	GUEST_ASSERT(load_vmcs(vmx));
 
 	if (vmx->eptp_gpa)
-		l2_rip = l2_guest_code_ept_enabled;
+		l2_rip = l2_guest_code_tdp_enabled;
 	else
-		l2_rip = l2_guest_code_ept_disabled;
+		l2_rip = l2_guest_code_tdp_disabled;
 
 	prepare_vmcs(vmx, l2_rip, &l2_guest_stack[L2_GUEST_STACK_SIZE]);
 
@@ -78,10 +80,38 @@ void l1_guest_code(struct vmx_pages *vmx)
 	GUEST_DONE();
 }
 
-static void test_vmx_dirty_log(bool enable_ept)
+static void l1_svm_code(struct svm_test_data *svm)
+{
+       unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+       void *l2_rip;
+
+       if (svm->ncr3_gpa)
+               l2_rip = l2_guest_code_tdp_enabled;
+       else
+               l2_rip = l2_guest_code_tdp_disabled;
+
+       generic_svm_setup(svm, l2_rip, &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+
+       GUEST_SYNC(false);
+       run_guest(svm->vmcb, svm->vmcb_gpa);
+       GUEST_SYNC(false);
+       GUEST_ASSERT(svm->vmcb->control.exit_code == SVM_EXIT_VMMCALL);
+       GUEST_DONE();
+}
+
+static void l1_guest_code(void *data)
+{
+	if (this_cpu_has(X86_FEATURE_VMX))
+		l1_vmx_code(data);
+	else
+		l1_svm_code(data);
+}
+
+static void test_dirty_log(bool enable_tdp)
 {
-	vm_vaddr_t vmx_pages_gva = 0;
-	struct vmx_pages *vmx;
+	struct svm_test_data *svm = NULL;
+	struct vmx_pages *vmx = NULL;
+	vm_vaddr_t nested_gva = 0;
 	unsigned long *bmap;
 	uint64_t *host_test_mem;
 
@@ -90,12 +120,16 @@ static void test_vmx_dirty_log(bool enable_ept)
 	struct ucall uc;
 	bool done = false;
 
-	pr_info("Nested EPT: %s\n", enable_ept ? "enabled" : "disabled");
+	pr_info("Nested TDP: %s\n", enable_tdp ? "enabled" : "disabled");
 
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
@@ -114,17 +148,25 @@ static void test_vmx_dirty_log(bool enable_ept)
 	 * ... pages in the L2 GPA range [0xc0001000, 0xc0003000) will map to
 	 * 0xc0000000.
 	 *
-	 * Note that prepare_eptp should be called only L1's GPA map is done,
-	 * meaning after the last call to virt_map.
+	 * Note that prepare_eptp()/prepare_npt() should be called only when
+	 * L1's GPA map is done, meaning after the last call to virt_map.
 	 *
-	 * When EPT is disabled, the L2 guest code will still access the same L1
-	 * GPAs as the EPT enabled case.
+	 * When TDP is disabled, the L2 guest code will still access the same L1
+	 * GPAs as the TDP enabled case.
 	 */
-	if (enable_ept) {
-		prepare_eptp(vmx, vm, 0);
-		nested_map_memslot(vmx->eptp_hva, vm, 0);
-		nested_map(vmx->eptp_hva, vm, NESTED_TEST_MEM1, GUEST_TEST_MEM, 4096);
-		nested_map(vmx->eptp_hva, vm, NESTED_TEST_MEM2, GUEST_TEST_MEM, 4096);
+	if (enable_tdp) {
+		void *root_hva;
+
+		if (kvm_cpu_has(X86_FEATURE_VMX)) {
+			prepare_eptp(vmx, vm, 0);
+			root_hva = vmx->eptp_hva;
+		} else {
+			prepare_npt(svm, vm);
+			root_hva = svm->ncr3_hva;
+		}
+		nested_map_memslot(root_hva, vm, 0);
+		nested_map(root_hva, vm, NESTED_TEST_MEM1, GUEST_TEST_MEM, 4096);
+		nested_map(root_hva, vm, NESTED_TEST_MEM2, GUEST_TEST_MEM, 4096);
 	}
 
 	bmap = bitmap_zalloc(TEST_MEM_PAGES);
@@ -169,12 +211,12 @@ static void test_vmx_dirty_log(bool enable_ept)
 
 int main(int argc, char *argv[])
 {
-	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX) || kvm_cpu_has(X86_FEATURE_SVM));
 
-	test_vmx_dirty_log(/*enable_ept=*/false);
+	test_dirty_log(/*enable_tdp=*/false);
 
-	if (kvm_cpu_has_ept())
-		test_vmx_dirty_log(/*enable_ept=*/true);
+	if (kvm_cpu_has_ept() || kvm_cpu_has_npt())
+		test_dirty_log(/*enable_tdp=*/true);
 
 	return 0;
 }
-- 
2.51.0.618.g983fd99d29-goog


