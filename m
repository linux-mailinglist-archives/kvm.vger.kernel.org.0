Return-Path: <kvm+bounces-64809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 09F04C8C927
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 02:37:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1C76E4E7FD0
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 01:37:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C5D9258EC1;
	Thu, 27 Nov 2025 01:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="key3w0ui"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC68425524C
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 01:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764207317; cv=none; b=QN7jGFzBpmJUCbSf0sA9u4eWGRRM5+U+e2cAzKeb1YO/6BtnOCVNtCMKJOy+ag1VC/epftJt2+gVr4/c8RpUG36ptQqoJPhksV63zG+nFaR861swyp5L7kIGiifO9BiVaY4LE0Xgo2dSHd8g9Wl+6Ljv40c2SV+QXqNrnaMO+6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764207317; c=relaxed/simple;
	bh=9J4gOoOLLBaaPkuAOJpUOQ38ee/Jp+i0964SqQllsE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rC9zqZmrl0NBz5tz+6ZAbTnpNWI2tFgcvBkXnxZB8ACdytEygbQLUER+Mkw0rE9wmvuzLachiTJDC0iSGB1B8VvLIuopMYfiiGi6Fe1qwpQFbKxi3YtQefxRP4aVZtg87LEqwy5ZZltZu2AloCad0eqWVDHC9b6k4MivbrUCQnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=key3w0ui; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764207310;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vUAdpq0tM8xfaKfzdDru2JHD0ntk7pfaOK0qFsQsUaM=;
	b=key3w0uiaIvv0OcfVmp0pxvkcNeg7M9eJgVA/4gAS9wZKfnicm8FU+HulhNFyVk6b3jxqm
	g351yIQcSTKC0kQD9AgBysSX6jkgRMLo1rVFr6AOfW0ErCLpfIM7XJpDmVgA5X88fvhI5y
	Xpp6zbsiu3Ta9/uuZuH78f5zqPm/LpM=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v3 08/16] KVM: selftests: Use a nested MMU to share nested EPTs between vCPUs
Date: Thu, 27 Nov 2025 01:34:32 +0000
Message-ID: <20251127013440.3324671-9-yosry.ahmed@linux.dev>
In-Reply-To: <20251127013440.3324671-1-yosry.ahmed@linux.dev>
References: <20251127013440.3324671-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

prepare_eptp() currently allocates new EPTs for each vCPU. memstress has
its own hack to share the EPTs between vCPUs. Currently, there is no
reason to have separate EPTs for each vCPU, and the complexity is
significant. The only reason it doesn't matter now is because memstress
is the only user with multiple vCPUs.

Replace prepare_eptp() with vm_enable_ept(), which enables EPT for an
entire VM. It allocates a new nested MMU and uses it to keep track of
the common EPT root (PTE masks are currently unused, but will be by
following changes).

Drop 'eptp' and 'eptp_hva' from struct vmx_pages. Only keep 'eptp_gpa'
and initialize it from the nested MMU root GPA. 'eptp' is unused, and
addr2_gpa2hva() is used to get the HVA in __tdp_pg_map() instead of
using 'eptp_hva'.

Remove the workaround in memstress to copy the EPT root between vCPUs
since it's handled by prepare_eptp() now.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 .../selftests/kvm/include/x86/kvm_util_arch.h |  3 +++
 .../selftests/kvm/include/x86/processor.h     |  2 ++
 tools/testing/selftests/kvm/include/x86/vmx.h |  8 +++---
 .../testing/selftests/kvm/lib/x86/memstress.c | 19 +++++---------
 .../testing/selftests/kvm/lib/x86/processor.c |  8 +++---
 tools/testing/selftests/kvm/lib/x86/vmx.c     | 25 +++++++++++--------
 .../selftests/kvm/x86/vmx_dirty_log_test.c    |  7 +++---
 7 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h b/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
index d8808fa33faa..1f5308f30566 100644
--- a/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
+++ b/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
@@ -23,6 +23,9 @@ struct kvm_vm_arch {
 	bool is_pt_protected;
 
 	struct kvm_mmu *mmu;
+	struct {
+		struct kvm_mmu *mmu;
+	} nested;
 };
 
 static inline bool __vm_arch_has_protected_memory(struct kvm_vm_arch *arch)
diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index 3a1a82fd42b2..fb2b2e53d453 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -1477,6 +1477,8 @@ struct kvm_mmu {
 #define pte_c(mmu, pte) (!!(*(pte) & PTE_C_MASK(mmu)))
 #define pte_s(mmu, pte) (!!(*(pte) & PTE_S_MASK(mmu)))
 
+struct kvm_mmu *mmu_create(struct kvm_vm *vm, int pgtable_levels,
+			   struct pte_masks *pte_masks);
 void __virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, uint64_t vaddr,
 		   uint64_t paddr,  int level);
 void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
diff --git a/tools/testing/selftests/kvm/include/x86/vmx.h b/tools/testing/selftests/kvm/include/x86/vmx.h
index 04b8231d032a..1fd83c23529a 100644
--- a/tools/testing/selftests/kvm/include/x86/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86/vmx.h
@@ -520,13 +520,11 @@ struct vmx_pages {
 	uint64_t vmwrite_gpa;
 	void *vmwrite;
 
-	void *eptp_hva;
-	uint64_t eptp_gpa;
-	void *eptp;
-
 	void *apic_access_hva;
 	uint64_t apic_access_gpa;
 	void *apic_access;
+
+	uint64_t eptp_gpa;
 };
 
 union vmx_basic {
@@ -568,7 +566,7 @@ void tdp_identity_map_default_memslots(struct vmx_pages *vmx,
 void tdp_identity_map_1g(struct vmx_pages *vmx, struct kvm_vm *vm,
 			 uint64_t addr, uint64_t size);
 bool kvm_cpu_has_ept(void);
-void prepare_eptp(struct vmx_pages *vmx, struct kvm_vm *vm);
+void vm_enable_ept(struct kvm_vm *vm);
 void prepare_virtualize_apic_accesses(struct vmx_pages *vmx, struct kvm_vm *vm);
 
 #endif /* SELFTEST_KVM_VMX_H */
diff --git a/tools/testing/selftests/kvm/lib/x86/memstress.c b/tools/testing/selftests/kvm/lib/x86/memstress.c
index 1928b00bde51..00f7f11e5f0e 100644
--- a/tools/testing/selftests/kvm/lib/x86/memstress.c
+++ b/tools/testing/selftests/kvm/lib/x86/memstress.c
@@ -59,12 +59,10 @@ uint64_t memstress_nested_pages(int nr_vcpus)
 	return 513 + 10 * nr_vcpus;
 }
 
-void memstress_setup_ept(struct vmx_pages *vmx, struct kvm_vm *vm)
+static void memstress_setup_ept_mappings(struct vmx_pages *vmx, struct kvm_vm *vm)
 {
 	uint64_t start, end;
 
-	prepare_eptp(vmx, vm);
-
 	/*
 	 * Identity map the first 4G and the test region with 1G pages so that
 	 * KVM can shadow the EPT12 with the maximum huge page size supported
@@ -79,7 +77,7 @@ void memstress_setup_ept(struct vmx_pages *vmx, struct kvm_vm *vm)
 
 void memstress_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vcpus[])
 {
-	struct vmx_pages *vmx, *vmx0 = NULL;
+	struct vmx_pages *vmx;
 	struct kvm_regs regs;
 	vm_vaddr_t vmx_gva;
 	int vcpu_id;
@@ -87,18 +85,13 @@ void memstress_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vc
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
 	TEST_REQUIRE(kvm_cpu_has_ept());
 
+	vm_enable_ept(vm);
 	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
 		vmx = vcpu_alloc_vmx(vm, &vmx_gva);
 
-		if (vcpu_id == 0) {
-			memstress_setup_ept(vmx, vm);
-			vmx0 = vmx;
-		} else {
-			/* Share the same EPT table across all vCPUs. */
-			vmx->eptp = vmx0->eptp;
-			vmx->eptp_hva = vmx0->eptp_hva;
-			vmx->eptp_gpa = vmx0->eptp_gpa;
-		}
+		/* The EPTs are shared across vCPUs, setup the mappings once */
+		if (vcpu_id == 0)
+			memstress_setup_ept_mappings(vmx, vm);
 
 		/*
 		 * Override the vCPU to run memstress_l1_guest_code() which will
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index dc568d70f9d6..bff75ff05364 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -156,14 +156,14 @@ bool kvm_is_tdp_enabled(void)
 		return get_kvm_amd_param_bool("npt");
 }
 
-static struct kvm_mmu *mmu_create(struct kvm_vm *vm,
-				  int pgtable_levels,
-				  struct pte_masks *pte_masks)
+struct kvm_mmu *mmu_create(struct kvm_vm *vm, int pgtable_levels,
+			   struct pte_masks *pte_masks)
 {
 	struct kvm_mmu *mmu = calloc(1, sizeof(*mmu));
 
 	TEST_ASSERT(mmu, "-ENOMEM when allocating MMU");
-	mmu->pte_masks = *pte_masks;
+	if (pte_masks)
+		mmu->pte_masks = *pte_masks;
 	mmu->root_gpa = vm_alloc_page_table(vm);
 	mmu->pgtable_levels = pgtable_levels;
 	return mmu;
diff --git a/tools/testing/selftests/kvm/lib/x86/vmx.c b/tools/testing/selftests/kvm/lib/x86/vmx.c
index a3e2eae981da..5d799ec5f7c6 100644
--- a/tools/testing/selftests/kvm/lib/x86/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
@@ -56,6 +56,16 @@ int vcpu_enable_evmcs(struct kvm_vcpu *vcpu)
 	return evmcs_ver;
 }
 
+void vm_enable_ept(struct kvm_vm *vm)
+{
+	TEST_ASSERT(kvm_cpu_has_ept(), "KVM doesn't support nested EPT");
+	if (vm->arch.nested.mmu)
+		return;
+
+	/* EPTP_PWL_4 is always used */
+	vm->arch.nested.mmu = mmu_create(vm, 4, NULL);
+}
+
 /* Allocate memory regions for nested VMX tests.
  *
  * Input Args:
@@ -105,6 +115,9 @@ vcpu_alloc_vmx(struct kvm_vm *vm, vm_vaddr_t *p_vmx_gva)
 	vmx->vmwrite_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->vmwrite);
 	memset(vmx->vmwrite_hva, 0, getpagesize());
 
+	if (vm->arch.nested.mmu)
+		vmx->eptp_gpa = vm->arch.nested.mmu->root_gpa;
+
 	*p_vmx_gva = vmx_gva;
 	return vmx;
 }
@@ -395,7 +408,8 @@ void __tdp_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 		  uint64_t nested_paddr, uint64_t paddr, int target_level)
 {
 	const uint64_t page_size = PG_LEVEL_SIZE(target_level);
-	struct eptPageTableEntry *pt = vmx->eptp_hva, *pte;
+	void *eptp_hva = addr_gpa2hva(vm, vm->arch.nested.mmu->root_gpa);
+	struct eptPageTableEntry *pt = eptp_hva, *pte;
 	uint16_t index;
 
 	TEST_ASSERT(vm->mode == VM_MODE_PXXVYY_4K,
@@ -525,15 +539,6 @@ bool kvm_cpu_has_ept(void)
 	return ctrl & SECONDARY_EXEC_ENABLE_EPT;
 }
 
-void prepare_eptp(struct vmx_pages *vmx, struct kvm_vm *vm)
-{
-	TEST_ASSERT(kvm_cpu_has_ept(), "KVM doesn't support nested EPT");
-
-	vmx->eptp = (void *)vm_vaddr_alloc_page(vm);
-	vmx->eptp_hva = addr_gva2hva(vm, (uintptr_t)vmx->eptp);
-	vmx->eptp_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->eptp);
-}
-
 void prepare_virtualize_apic_accesses(struct vmx_pages *vmx, struct kvm_vm *vm)
 {
 	vmx->apic_access = (void *)vm_vaddr_alloc_page(vm);
diff --git a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c b/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
index e7d0c08ba29d..5c8cf8ac42a2 100644
--- a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
@@ -93,6 +93,9 @@ static void test_vmx_dirty_log(bool enable_ept)
 
 	/* Create VM */
 	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
+	if (enable_ept)
+		vm_enable_ept(vm);
+
 	vmx = vcpu_alloc_vmx(vm, &vmx_pages_gva);
 	vcpu_args_set(vcpu, 1, vmx_pages_gva);
 
@@ -113,14 +116,10 @@ static void test_vmx_dirty_log(bool enable_ept)
 	 * ... pages in the L2 GPA range [0xc0001000, 0xc0003000) will map to
 	 * 0xc0000000.
 	 *
-	 * Note that prepare_eptp should be called only L1's GPA map is done,
-	 * meaning after the last call to virt_map.
-	 *
 	 * When EPT is disabled, the L2 guest code will still access the same L1
 	 * GPAs as the EPT enabled case.
 	 */
 	if (enable_ept) {
-		prepare_eptp(vmx, vm);
 		tdp_identity_map_default_memslots(vmx, vm);
 		tdp_map(vmx, vm, NESTED_TEST_MEM1, GUEST_TEST_MEM, PAGE_SIZE);
 		tdp_map(vmx, vm, NESTED_TEST_MEM2, GUEST_TEST_MEM, PAGE_SIZE);
-- 
2.52.0.158.g65b55ccf14-goog


