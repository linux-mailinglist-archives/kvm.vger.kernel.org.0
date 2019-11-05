Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86CFAF06EE
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 21:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729730AbfKEUaB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 15:30:01 -0500
Received: from foss.arm.com ([217.140.110.172]:59912 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727401AbfKEU36 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 15:29:58 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 936127B9;
        Tue,  5 Nov 2019 12:29:56 -0800 (PST)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.145.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A4E583FE87;
        Tue,  5 Nov 2019 03:04:08 -0800 (PST)
From:   Christoffer Dall <christoffer.dall@arm.com>
To:     kvm@vger.kernel.org
Cc:     kvmarm@lists.cs.columbia.edu,
        Christoffer Dall <christoffer.dall@arm.com>,
        James Hogan <jhogan@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Mike Rapoport <rppt@linux.ibm.com>
Subject: [PATCH v4 4/5] KVM: arm/arm64: Move to common kvm_mmu_memcache infrastructure
Date:   Tue,  5 Nov 2019 12:03:56 +0100
Message-Id: <20191105110357.8607-5-christoffer.dall@arm.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20191105110357.8607-1-christoffer.dall@arm.com>
References: <20191105110357.8607-1-christoffer.dall@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now when we have a common mmu mmemcache implementation, we can reuse
this for arm and arm64.

The common implementation has a slightly different behavior when
allocating objects under high memory pressure; whereas the current
arm/arm64 implementation will give up and return -ENOMEM if the full
size of the cache cannot be allocated during topup, the common
implementation is happy with any allocation between min and max.  There
should be no architecture-specific requirement for doing it one way or
the other and it's in fact better to enforce a cross-architecture KVM
policy on this behavior.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
---
 arch/arm/include/asm/kvm_host.h    | 13 +-----
 arch/arm/include/asm/kvm_mmu.h     |  2 +-
 arch/arm/include/asm/kvm_types.h   |  4 ++
 arch/arm64/include/asm/kvm_host.h  | 13 +-----
 arch/arm64/include/asm/kvm_mmu.h   |  2 +-
 arch/arm64/include/asm/kvm_types.h |  5 ++-
 virt/kvm/arm/arm.c                 |  2 +-
 virt/kvm/arm/mmu.c                 | 68 ++++++++----------------------
 8 files changed, 30 insertions(+), 79 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 8a37c8e89777..04e7c5868132 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -78,17 +78,6 @@ struct kvm_arch {
 	u32 psci_version;
 };
 
-#define KVM_NR_MEM_OBJS     40
-
-/*
- * We don't want allocation failures within the mmu code, so we preallocate
- * enough memory for a single page fault in a cache.
- */
-struct kvm_mmu_memory_cache {
-	int nobjs;
-	void *objects[KVM_NR_MEM_OBJS];
-};
-
 struct kvm_vcpu_fault_info {
 	u32 hsr;		/* Hyp Syndrome Register */
 	u32 hxfar;		/* Hyp Data/Inst. Fault Address Register */
@@ -196,7 +185,7 @@ struct kvm_vcpu_arch {
 	struct kvm_decode mmio_decode;
 
 	/* Cache some mmu pages needed inside spinlock regions */
-	struct kvm_mmu_memory_cache mmu_page_cache;
+	struct kvm_mmu_memcache mmu_page_cache;
 
 	struct vcpu_reset_state reset_state;
 
diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 0d84d50bf9ba..b1ff76aac0cd 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -59,7 +59,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 
 int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run);
 
-void kvm_mmu_free_memory_caches(struct kvm_vcpu *vcpu);
+void kvm_mmu_free_memcaches(struct kvm_vcpu *vcpu);
 
 phys_addr_t kvm_mmu_get_httbr(void);
 phys_addr_t kvm_get_idmap_vector(void);
diff --git a/arch/arm/include/asm/kvm_types.h b/arch/arm/include/asm/kvm_types.h
index bc389f82e88d..de5be31a5a77 100644
--- a/arch/arm/include/asm/kvm_types.h
+++ b/arch/arm/include/asm/kvm_types.h
@@ -2,4 +2,8 @@
 #ifndef _ASM_ARM_KVM_TYPES_H
 #define _ASM_ARM_KVM_TYPES_H
 
+#define KVM_ARCH_WANT_MMU_MEMCACHE
+
+#define KVM_MMU_NR_MEMCACHE_OBJS 40
+
 #endif /* _ASM_ARM_KVM_TYPES_H */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f656169db8c3..00b8d1f65e44 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -85,17 +85,6 @@ struct kvm_arch {
 	u32 psci_version;
 };
 
-#define KVM_NR_MEM_OBJS     40
-
-/*
- * We don't want allocation failures within the mmu code, so we preallocate
- * enough memory for a single page fault in a cache.
- */
-struct kvm_mmu_memory_cache {
-	int nobjs;
-	void *objects[KVM_NR_MEM_OBJS];
-};
-
 struct kvm_vcpu_fault_info {
 	u32 esr_el2;		/* Hyp Syndrom Register */
 	u64 far_el2;		/* Hyp Fault Address Register */
@@ -320,7 +309,7 @@ struct kvm_vcpu_arch {
 	struct kvm_decode mmio_decode;
 
 	/* Cache some mmu pages needed inside spinlock regions */
-	struct kvm_mmu_memory_cache mmu_page_cache;
+	struct kvm_mmu_memcache mmu_page_cache;
 
 	/* Target CPU and feature flags */
 	int target;
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index befe37d4bc0e..e23e91f368ae 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -160,7 +160,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 
 int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run);
 
-void kvm_mmu_free_memory_caches(struct kvm_vcpu *vcpu);
+void kvm_mmu_free_memcaches(struct kvm_vcpu *vcpu);
 
 phys_addr_t kvm_mmu_get_httbr(void);
 phys_addr_t kvm_get_idmap_vector(void);
diff --git a/arch/arm64/include/asm/kvm_types.h b/arch/arm64/include/asm/kvm_types.h
index d0987007d581..89b15f62e466 100644
--- a/arch/arm64/include/asm/kvm_types.h
+++ b/arch/arm64/include/asm/kvm_types.h
@@ -2,5 +2,8 @@
 #ifndef _ASM_ARM64_KVM_TYPES_H
 #define _ASM_ARM64_KVM_TYPES_H
 
-#endif /* _ASM_ARM64_KVM_TYPES_H */
+#define KVM_ARCH_WANT_MMU_MEMCACHE
+
+#define KVM_MMU_NR_MEMCACHE_OBJS 40
 
+#endif /* _ASM_ARM64_KVM_TYPES_H */
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 86c6aa1cb58e..96e2df4f8fc9 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -300,7 +300,7 @@ void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.has_run_once && unlikely(!irqchip_in_kernel(vcpu->kvm)))
 		static_branch_dec(&userspace_irqchip_in_use);
 
-	kvm_mmu_free_memory_caches(vcpu);
+	kvm_mmu_free_memcaches(vcpu);
 	kvm_timer_vcpu_terminate(vcpu);
 	kvm_pmu_vcpu_destroy(vcpu);
 	kvm_vcpu_uninit(vcpu);
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 38b4c910b6c3..0daa79230226 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -120,38 +120,6 @@ static void stage2_dissolve_pud(struct kvm *kvm, phys_addr_t addr, pud_t *pudp)
 	put_page(virt_to_page(pudp));
 }
 
-static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
-				  int min, int max)
-{
-	void *page;
-
-	BUG_ON(max > KVM_NR_MEM_OBJS);
-	if (cache->nobjs >= min)
-		return 0;
-	while (cache->nobjs < max) {
-		page = (void *)__get_free_page(GFP_PGTABLE_USER);
-		if (!page)
-			return -ENOMEM;
-		cache->objects[cache->nobjs++] = page;
-	}
-	return 0;
-}
-
-static void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
-{
-	while (mc->nobjs)
-		free_page((unsigned long)mc->objects[--mc->nobjs]);
-}
-
-static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
-{
-	void *p;
-
-	BUG_ON(!mc || !mc->nobjs);
-	p = mc->objects[--mc->nobjs];
-	return p;
-}
-
 static void clear_stage2_pgd_entry(struct kvm *kvm, pgd_t *pgd, phys_addr_t addr)
 {
 	pud_t *pud_table __maybe_unused = stage2_pud_offset(kvm, pgd, 0UL);
@@ -1008,7 +976,7 @@ void kvm_free_stage2_pgd(struct kvm *kvm)
 		free_pages_exact(pgd, stage2_pgd_size(kvm));
 }
 
-static pud_t *stage2_get_pud(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
+static pud_t *stage2_get_pud(struct kvm *kvm, struct kvm_mmu_memcache *cache,
 			     phys_addr_t addr)
 {
 	pgd_t *pgd;
@@ -1018,7 +986,7 @@ static pud_t *stage2_get_pud(struct kvm *kvm, struct kvm_mmu_memory_cache *cache
 	if (stage2_pgd_none(kvm, *pgd)) {
 		if (!cache)
 			return NULL;
-		pud = mmu_memory_cache_alloc(cache);
+		pud = kvm_mmu_memcache_alloc(cache);
 		stage2_pgd_populate(kvm, pgd, pud);
 		get_page(virt_to_page(pgd));
 	}
@@ -1026,7 +994,7 @@ static pud_t *stage2_get_pud(struct kvm *kvm, struct kvm_mmu_memory_cache *cache
 	return stage2_pud_offset(kvm, pgd, addr);
 }
 
-static pmd_t *stage2_get_pmd(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
+static pmd_t *stage2_get_pmd(struct kvm *kvm, struct kvm_mmu_memcache *cache,
 			     phys_addr_t addr)
 {
 	pud_t *pud;
@@ -1039,7 +1007,7 @@ static pmd_t *stage2_get_pmd(struct kvm *kvm, struct kvm_mmu_memory_cache *cache
 	if (stage2_pud_none(kvm, *pud)) {
 		if (!cache)
 			return NULL;
-		pmd = mmu_memory_cache_alloc(cache);
+		pmd = kvm_mmu_memcache_alloc(cache);
 		stage2_pud_populate(kvm, pud, pmd);
 		get_page(virt_to_page(pud));
 	}
@@ -1047,7 +1015,7 @@ static pmd_t *stage2_get_pmd(struct kvm *kvm, struct kvm_mmu_memory_cache *cache
 	return stage2_pmd_offset(kvm, pud, addr);
 }
 
-static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
+static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memcache
 			       *cache, phys_addr_t addr, const pmd_t *new_pmd)
 {
 	pmd_t *pmd, old_pmd;
@@ -1111,7 +1079,7 @@ static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
 	return 0;
 }
 
-static int stage2_set_pud_huge(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
+static int stage2_set_pud_huge(struct kvm *kvm, struct kvm_mmu_memcache *cache,
 			       phys_addr_t addr, const pud_t *new_pudp)
 {
 	pud_t *pudp, old_pud;
@@ -1213,7 +1181,7 @@ static bool stage2_is_exec(struct kvm *kvm, phys_addr_t addr)
 		return kvm_s2pte_exec(ptep);
 }
 
-static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
+static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memcache *cache,
 			  phys_addr_t addr, const pte_t *new_pte,
 			  unsigned long flags)
 {
@@ -1245,7 +1213,7 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
 	if (stage2_pud_none(kvm, *pud)) {
 		if (!cache)
 			return 0; /* ignore calls from kvm_set_spte_hva */
-		pmd = mmu_memory_cache_alloc(cache);
+		pmd = kvm_mmu_memcache_alloc(cache);
 		stage2_pud_populate(kvm, pud, pmd);
 		get_page(virt_to_page(pud));
 	}
@@ -1270,7 +1238,7 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
 	if (pmd_none(*pmd)) {
 		if (!cache)
 			return 0; /* ignore calls from kvm_set_spte_hva */
-		pte = mmu_memory_cache_alloc(cache);
+		pte = kvm_mmu_memcache_alloc(cache);
 		kvm_pmd_populate(pmd, pte);
 		get_page(virt_to_page(pmd));
 	}
@@ -1337,7 +1305,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 	phys_addr_t addr, end;
 	int ret = 0;
 	unsigned long pfn;
-	struct kvm_mmu_memory_cache cache = { 0, };
+	struct kvm_mmu_memcache cache = { 0, };
 
 	end = (guest_ipa + size + PAGE_SIZE - 1) & PAGE_MASK;
 	pfn = __phys_to_pfn(pa);
@@ -1348,9 +1316,8 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 		if (writable)
 			pte = kvm_s2pte_mkwrite(pte);
 
-		ret = mmu_topup_memory_cache(&cache,
-					     kvm_mmu_cache_min_pages(kvm),
-					     KVM_NR_MEM_OBJS);
+		ret = kvm_mmu_topup_memcache_page(&cache,
+						  kvm_mmu_cache_min_pages(kvm));
 		if (ret)
 			goto out;
 		spin_lock(&kvm->mmu_lock);
@@ -1364,7 +1331,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 	}
 
 out:
-	mmu_free_memory_cache(&cache);
+	kvm_mmu_free_memcache_page(&cache);
 	return ret;
 }
 
@@ -1671,7 +1638,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	unsigned long mmu_seq;
 	gfn_t gfn = fault_ipa >> PAGE_SHIFT;
 	struct kvm *kvm = vcpu->kvm;
-	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
+	struct kvm_mmu_memcache *memcache = &vcpu->arch.mmu_page_cache;
 	struct vm_area_struct *vma;
 	kvm_pfn_t pfn;
 	pgprot_t mem_type = PAGE_S2;
@@ -1716,8 +1683,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	up_read(&current->mm->mmap_sem);
 
 	/* We need minimum second+third level pages */
-	ret = mmu_topup_memory_cache(memcache, kvm_mmu_cache_min_pages(kvm),
-				     KVM_NR_MEM_OBJS);
+	ret = kvm_mmu_topup_memcache_page(memcache, kvm_mmu_cache_min_pages(kvm));
 	if (ret)
 		return ret;
 
@@ -2137,9 +2103,9 @@ int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
 	return handle_hva_to_gpa(kvm, hva, hva, kvm_test_age_hva_handler, NULL);
 }
 
-void kvm_mmu_free_memory_caches(struct kvm_vcpu *vcpu)
+void kvm_mmu_free_memcaches(struct kvm_vcpu *vcpu)
 {
-	mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
+	kvm_mmu_free_memcache_page(&vcpu->arch.mmu_page_cache);
 }
 
 phys_addr_t kvm_mmu_get_httbr(void)
-- 
2.18.0

