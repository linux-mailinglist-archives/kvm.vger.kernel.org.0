Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 379B0348DA
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 15:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbfFDNdv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 09:33:51 -0400
Received: from foss.arm.com ([217.140.101.70]:44090 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727705AbfFDNdu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 09:33:50 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0925D15BF;
        Tue,  4 Jun 2019 06:33:50 -0700 (PDT)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.144.41])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9752F3F690;
        Tue,  4 Jun 2019 06:33:49 -0700 (PDT)
From:   Christoffer Dall <christoffer.dall@arm.com>
To:     kvm@vger.kernel.org
Cc:     kvmarm@lists.cs.columbia.edu,
        Christoffer Dall <christoffer.dall@arm.com>,
        James Hogan <jhogan@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Suzuki K Poulose <Suzuki.Poulose@arm.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v3 4/4] KVM: mips: Move to common kvm_mmu_memcache infrastructure
Date:   Tue,  4 Jun 2019 15:33:36 +0200
Message-Id: <20190604133336.22226-5-christoffer.dall@arm.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20190604133336.22226-1-christoffer.dall@arm.com>
References: <20190604133336.22226-1-christoffer.dall@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that we have a common infrastructure for doing MMU cache
allocations, use this for mips as well.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
---
 arch/mips/include/asm/kvm_host.h  | 15 ++-------
 arch/mips/include/asm/kvm_types.h |  6 ++++
 arch/mips/kvm/mips.c              |  2 +-
 arch/mips/kvm/mmu.c               | 54 ++++++-------------------------
 4 files changed, 19 insertions(+), 58 deletions(-)

diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 41204a49cf95..418c941f1382 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -293,17 +293,6 @@ struct kvm_mips_tlb {
 	long tlb_lo[2];
 };
 
-#define KVM_NR_MEM_OBJS     4
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
 #define KVM_MIPS_AUX_FPU	0x1
 #define KVM_MIPS_AUX_MSA	0x2
 
@@ -378,7 +367,7 @@ struct kvm_vcpu_arch {
 	unsigned int last_user_gasid;
 
 	/* Cache some mmu pages needed inside spinlock regions */
-	struct kvm_mmu_memory_cache mmu_page_cache;
+	struct kvm_mmu_memcache mmu_page_cache;
 
 #ifdef CONFIG_KVM_MIPS_VZ
 	/* vcpu's vzguestid is different on each host cpu in an smp system */
@@ -915,7 +904,7 @@ void kvm_mips_flush_gva_pt(pgd_t *pgd, enum kvm_mips_flush flags);
 bool kvm_mips_flush_gpa_pt(struct kvm *kvm, gfn_t start_gfn, gfn_t end_gfn);
 int kvm_mips_mkclean_gpa_pt(struct kvm *kvm, gfn_t start_gfn, gfn_t end_gfn);
 pgd_t *kvm_pgd_alloc(void);
-void kvm_mmu_free_memory_caches(struct kvm_vcpu *vcpu);
+void kvm_mmu_free_memcaches(struct kvm_vcpu *vcpu);
 void kvm_trap_emul_invalidate_gva(struct kvm_vcpu *vcpu, unsigned long addr,
 				  bool user);
 void kvm_trap_emul_gva_lockless_begin(struct kvm_vcpu *vcpu);
diff --git a/arch/mips/include/asm/kvm_types.h b/arch/mips/include/asm/kvm_types.h
index 5efeb32a5926..f821c659a5b1 100644
--- a/arch/mips/include/asm/kvm_types.h
+++ b/arch/mips/include/asm/kvm_types.h
@@ -2,4 +2,10 @@
 #ifndef _ASM_MIPS_KVM_TYPES_H
 #define _ASM_MIPS_KVM_TYPES_H
 
+#define KVM_ARCH_WANT_MMU_MEMCACHE
+
+#define KVM_MMU_NR_MEMCACHE_OBJS 4
+
+#define KVM_MMU_CACHE_GFP_FLAGS 0
+
 #endif /* _ASM_MIPS_KVM_TYPES_H */
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 6d0517ac18e5..2737f837cd9f 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -425,7 +425,7 @@ void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
 
 	kvm_mips_dump_stats(vcpu);
 
-	kvm_mmu_free_memory_caches(vcpu);
+	kvm_mmu_free_memcaches(vcpu);
 	kfree(vcpu->arch.guest_ebase);
 	kfree(vcpu->arch.kseg0_commpage);
 	kfree(vcpu);
diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
index 97e538a8c1be..aed5284d642e 100644
--- a/arch/mips/kvm/mmu.c
+++ b/arch/mips/kvm/mmu.c
@@ -25,41 +25,9 @@
 #define KVM_MMU_CACHE_MIN_PAGES 2
 #endif
 
-static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
-				  int min, int max)
+void kvm_mmu_free_memcaches(struct kvm_vcpu *vcpu)
 {
-	void *page;
-
-	BUG_ON(max > KVM_NR_MEM_OBJS);
-	if (cache->nobjs >= min)
-		return 0;
-	while (cache->nobjs < max) {
-		page = (void *)__get_free_page(GFP_KERNEL);
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
-void kvm_mmu_free_memory_caches(struct kvm_vcpu *vcpu)
-{
-	mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
+	kvm_mmu_free_memcache_page(&vcpu->arch.mmu_page_cache);
 }
 
 /**
@@ -133,7 +101,7 @@ pgd_t *kvm_pgd_alloc(void)
  *		NULL if a page table doesn't exist for @addr and !@cache.
  *		NULL if a page table allocation failed.
  */
-static pte_t *kvm_mips_walk_pgd(pgd_t *pgd, struct kvm_mmu_memory_cache *cache,
+static pte_t *kvm_mips_walk_pgd(pgd_t *pgd, struct kvm_mmu_memcache *cache,
 				unsigned long addr)
 {
 	pud_t *pud;
@@ -151,7 +119,7 @@ static pte_t *kvm_mips_walk_pgd(pgd_t *pgd, struct kvm_mmu_memory_cache *cache,
 
 		if (!cache)
 			return NULL;
-		new_pmd = mmu_memory_cache_alloc(cache);
+		new_pmd = kvm_mmu_memcache_alloc(cache);
 		pmd_init((unsigned long)new_pmd,
 			 (unsigned long)invalid_pte_table);
 		pud_populate(NULL, pud, new_pmd);
@@ -162,7 +130,7 @@ static pte_t *kvm_mips_walk_pgd(pgd_t *pgd, struct kvm_mmu_memory_cache *cache,
 
 		if (!cache)
 			return NULL;
-		new_pte = mmu_memory_cache_alloc(cache);
+		new_pte = kvm_mmu_memcache_alloc(cache);
 		clear_page(new_pte);
 		pmd_populate_kernel(NULL, pmd, new_pte);
 	}
@@ -171,7 +139,7 @@ static pte_t *kvm_mips_walk_pgd(pgd_t *pgd, struct kvm_mmu_memory_cache *cache,
 
 /* Caller must hold kvm->mm_lock */
 static pte_t *kvm_mips_pte_for_gpa(struct kvm *kvm,
-				   struct kvm_mmu_memory_cache *cache,
+				   struct kvm_mmu_memcache *cache,
 				   unsigned long addr)
 {
 	return kvm_mips_walk_pgd(kvm->arch.gpa_mm.pgd, cache, addr);
@@ -688,7 +656,7 @@ static int kvm_mips_map_page(struct kvm_vcpu *vcpu, unsigned long gpa,
 			     pte_t *out_entry, pte_t *out_buddy)
 {
 	struct kvm *kvm = vcpu->kvm;
-	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
+	struct kvm_mmu_memcache *memcache = &vcpu->arch.mmu_page_cache;
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	int srcu_idx, err;
 	kvm_pfn_t pfn;
@@ -705,8 +673,7 @@ static int kvm_mips_map_page(struct kvm_vcpu *vcpu, unsigned long gpa,
 		goto out;
 
 	/* We need a minimum of cached pages ready for page table creation */
-	err = mmu_topup_memory_cache(memcache, KVM_MMU_CACHE_MIN_PAGES,
-				     KVM_NR_MEM_OBJS);
+	err = kvm_mmu_topup_memcache_page(memcache, KVM_MMU_CACHE_MIN_PAGES);
 	if (err)
 		goto out;
 
@@ -785,13 +752,12 @@ static int kvm_mips_map_page(struct kvm_vcpu *vcpu, unsigned long gpa,
 static pte_t *kvm_trap_emul_pte_for_gva(struct kvm_vcpu *vcpu,
 					unsigned long addr)
 {
-	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
+	struct kvm_mmu_memcache *memcache = &vcpu->arch.mmu_page_cache;
 	pgd_t *pgdp;
 	int ret;
 
 	/* We need a minimum of cached pages ready for page table creation */
-	ret = mmu_topup_memory_cache(memcache, KVM_MMU_CACHE_MIN_PAGES,
-				     KVM_NR_MEM_OBJS);
+	ret = kvm_mmu_topup_memcache_page(memcache, KVM_MMU_CACHE_MIN_PAGES);
 	if (ret)
 		return NULL;
 
-- 
2.18.0

