Return-Path: <kvm+bounces-66881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CE3ACEAD86
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 00:15:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B47AF306F68B
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 23:12:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39333222560;
	Tue, 30 Dec 2025 23:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f1jCb/It"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8ED62FBDF0
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 23:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767135734; cv=none; b=O0VHj1nvxofRl8GGrRRg2KklaJnPjxYqhPffHuX1EpqHLt3IZynaOQLUhJmYJcHnN7enwAAT0YDRaZ3hnzSskXveUBYUEv10d4JYEX54AlTuC7jWL/Pem2Rc8hwHQjuKDsJr7Kv7ahzANVAYTj483lF0AfJgoF1ifPUWVS9MTgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767135734; c=relaxed/simple;
	bh=3mr7O/tvT5uy5dzcKxhclQgiEmpVIdBzfbqLItSl0DI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Fb46++dkK7ElmmSwUEi/4kt/VKDGTHssaXcJXAQx1L5iWbmp0XNnjXbbjwcrQysqE3xYWkJ7HiFPepsX0JAih6Y7p8bMssCF1ur2Gl20dDeTx27Dvsmqb/y8F73o8zyXG+ahzRIB7AkLMPuH38yPbLJYfmzffVlitMMR9gWxbTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f1jCb/It; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c5d203988so21955455a91.3
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 15:02:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767135730; x=1767740530; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=HoCo7aJ171z3a/CeRUy13gZIVr8qzfglNXk4q+wsZUs=;
        b=f1jCb/ItWHMs/h/oYxf/fQGLgiNnhYN5XLGo1PdKr7oVuj7G2/Ahhbwoj0AIPcTbT6
         lhgERrwycBab8iflJUsmHDT4+KFDe/Cx2z8ZUqdBZ1qy0igCBllD9rvF+q5BzcNPmccH
         FJHPBDP6higQvfHWYItPhQQZU3K0pHo6+gSiQlhZAGEQlF12pO32q7xuSLKWm8wwcHyj
         FfwSLqUwuc8MNdJWv8lb4Q+ynwHNLJEdinF/Mel/QYGeP2910vM6OjNtIYzcJUDGBLNg
         T40vCQ4/Hyhbj3C6oh+8wXBuHMfNWXuiTzm/bmpBuqljMpfJHjWTG8OxIOtSqS+/vb6o
         7wtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767135730; x=1767740530;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HoCo7aJ171z3a/CeRUy13gZIVr8qzfglNXk4q+wsZUs=;
        b=FhjzdTRkrInjk/42CKwMNNaraVWPX7l44hEF2Ry6uYoDKZNuSL2PE8MNqnrvIpDrwj
         u7WSg9elTAoFDRyvPDuiXzbsFaIJgF2hjN/6Zs2mTwBYBJgy9N3iUL5tMncUrG2Suayx
         4tNtCEsGv70tKNVh2n5JZjkP9sgGkQ2DscqfA1FOWhceDpasYBXgdMXqeswqxJFR2pzR
         jId+5rgXCPzbqMf6uC1z0A5pPjW5nA3cXx+3nw4mFM3Wj4tlYQGpzekDoFSaEc6egq+p
         EF2GJTak3628FDTGtmz1upk/mKd1r2CF72nBsT7/Wu5V8qoSu4A8fmtHNMbBHvnkKb1N
         NkzA==
X-Gm-Message-State: AOJu0YzfHGPheDbRC64Wm9mfnQ3BLSNMlhlzwrIZ9+Nq2qVoq7jDj/vr
	ZiIvJEiSCOzK/aQZFF2MlcVILataj3wx5uZF25bURUhLA9+ladYYJLt1iX0J2anl/tUW2hc7/6b
	RXXqg6A==
X-Google-Smtp-Source: AGHT+IHXyCRNTO0LITU2dGt9isyL83xRKJpOSaQ7I3QFob4WUrF/8KVGlxXnGM2mybHxASS/pACiFt+892M=
X-Received: from pjo20.prod.google.com ([2002:a17:90b:5674:b0:34c:2124:a2b0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:28ce:b0:340:c64d:38d3
 with SMTP id 98e67ed59e1d1-34e921448b2mr30537997a91.12.1767135730226; Tue, 30
 Dec 2025 15:02:10 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Dec 2025 15:01:39 -0800
In-Reply-To: <20251230230150.4150236-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251230230150.4150236-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251230230150.4150236-11-seanjc@google.com>
Subject: [PATCH v4 10/21] KVM: selftests: Use a TDP MMU to share EPT page
 tables between vCPUs
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

From: Yosry Ahmed <yosry.ahmed@linux.dev>

prepare_eptp() currently allocates new EPTs for each vCPU.  memstress has
its own hack to share the EPTs between vCPUs.  Currently, there is no
reason to have separate EPTs for each vCPU, and the complexity is
significant.  The only reason it doesn't matter now is because memstress
is the only user with multiple vCPUs.

Add vm_enable_ept() to allocate EPT page tables for an entire VM, and use
it everywhere to replace prepare_eptp().  Drop 'eptp' and 'eptp_hva' from
'struct vmx_pages' as they serve no purpose (e.g. the EPTP can be built
from the PGD), but keep 'eptp_gpa' so that the MMU structure doesn't need
to be passed in along with vmx_pages.  Dynamically allocate the TDP MMU
structure to avoid a cyclical dependency between kvm_util_arch.h and
kvm_util.h.

Remove the workaround in memstress to copy the EPT root between vCPUs
since that's now the default behavior.

Name the MMU tdp_mmu instead of e.g. nested_mmu or nested.mmu to avoid
recreating the same mess that KVM has with respect to "nested" MMUs, e.g.
does nested refer to the stage-2 page tables created by L1, or the stage-1
page tables created by L2?

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86/kvm_util_arch.h |  4 +++
 .../selftests/kvm/include/x86/processor.h     |  3 ++
 tools/testing/selftests/kvm/include/x86/vmx.h |  8 ++---
 .../testing/selftests/kvm/lib/x86/memstress.c | 19 ++++--------
 .../testing/selftests/kvm/lib/x86/processor.c |  9 ++++++
 tools/testing/selftests/kvm/lib/x86/vmx.c     | 30 ++++++++++++-------
 .../selftests/kvm/x86/vmx_dirty_log_test.c    |  7 ++---
 7 files changed, 48 insertions(+), 32 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h b/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
index bad381d63b6a..05a1fc1780f2 100644
--- a/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
+++ b/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
@@ -26,6 +26,8 @@ struct kvm_mmu_arch {
 	struct pte_masks pte_masks;
 };
 
+struct kvm_mmu;
+
 struct kvm_vm_arch {
 	vm_vaddr_t gdt;
 	vm_vaddr_t tss;
@@ -35,6 +37,8 @@ struct kvm_vm_arch {
 	uint64_t s_bit;
 	int sev_fd;
 	bool is_pt_protected;
+
+	struct kvm_mmu *tdp_mmu;
 };
 
 static inline bool __vm_arch_has_protected_memory(struct kvm_vm_arch *arch)
diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index b2084434dd8b..973f2069cd3b 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -1457,6 +1457,9 @@ enum pg_level {
 #define is_huge_pte(mmu, pte)		(!!(*(pte) & PTE_HUGE_MASK(mmu)))
 #define is_nx_pte(mmu, pte)		(!!(*(pte) & PTE_NX_MASK(mmu)))
 
+void tdp_mmu_init(struct kvm_vm *vm, int pgtable_levels,
+		  struct pte_masks *pte_masks);
+
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
index 3800f4ff6770..8a9298a72897 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -187,6 +187,15 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 	virt_mmu_init(vm, &vm->mmu, &pte_masks);
 }
 
+void tdp_mmu_init(struct kvm_vm *vm, int pgtable_levels,
+		  struct pte_masks *pte_masks)
+{
+	TEST_ASSERT(!vm->arch.tdp_mmu, "TDP MMU already initialized");
+
+	vm->arch.tdp_mmu = calloc(1, sizeof(*vm->arch.tdp_mmu));
+	virt_mmu_init(vm, vm->arch.tdp_mmu, pte_masks);
+}
+
 static void *virt_get_pte(struct kvm_vm *vm, struct kvm_mmu *mmu,
 			  uint64_t *parent_pte, uint64_t vaddr, int level)
 {
diff --git a/tools/testing/selftests/kvm/lib/x86/vmx.c b/tools/testing/selftests/kvm/lib/x86/vmx.c
index a3e2eae981da..9d4e391fdf2c 100644
--- a/tools/testing/selftests/kvm/lib/x86/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
@@ -56,6 +56,21 @@ int vcpu_enable_evmcs(struct kvm_vcpu *vcpu)
 	return evmcs_ver;
 }
 
+void vm_enable_ept(struct kvm_vm *vm)
+{
+	TEST_ASSERT(kvm_cpu_has_ept(), "KVM doesn't support nested EPT");
+	if (vm->arch.tdp_mmu)
+		return;
+
+	/* TODO: Drop eptPageTableEntry in favor of PTE masks. */
+	struct pte_masks pte_masks = (struct pte_masks) {
+
+	};
+
+	/* TODO: Add support for 5-level EPT. */
+	tdp_mmu_init(vm, 4, &pte_masks);
+}
+
 /* Allocate memory regions for nested VMX tests.
  *
  * Input Args:
@@ -105,6 +120,9 @@ vcpu_alloc_vmx(struct kvm_vm *vm, vm_vaddr_t *p_vmx_gva)
 	vmx->vmwrite_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->vmwrite);
 	memset(vmx->vmwrite_hva, 0, getpagesize());
 
+	if (vm->arch.tdp_mmu)
+		vmx->eptp_gpa = vm->arch.tdp_mmu->pgd;
+
 	*p_vmx_gva = vmx_gva;
 	return vmx;
 }
@@ -395,7 +413,8 @@ void __tdp_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 		  uint64_t nested_paddr, uint64_t paddr, int target_level)
 {
 	const uint64_t page_size = PG_LEVEL_SIZE(target_level);
-	struct eptPageTableEntry *pt = vmx->eptp_hva, *pte;
+	void *eptp_hva = addr_gpa2hva(vm, vm->arch.tdp_mmu->pgd);
+	struct eptPageTableEntry *pt = eptp_hva, *pte;
 	uint16_t index;
 
 	TEST_ASSERT(vm->mode == VM_MODE_PXXVYY_4K,
@@ -525,15 +544,6 @@ bool kvm_cpu_has_ept(void)
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
2.52.0.351.gbe84eed79e-goog


