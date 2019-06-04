Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D573348D6
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 15:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727710AbfFDNdq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 09:33:46 -0400
Received: from foss.arm.com ([217.140.101.70]:44038 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727688AbfFDNdq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 09:33:46 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 56AA215A2;
        Tue,  4 Jun 2019 06:33:45 -0700 (PDT)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.144.41])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BC0AF3F690;
        Tue,  4 Jun 2019 06:33:44 -0700 (PDT)
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
Subject: [PATCH v3 2/4] KVM: x86: Rename mmu_memory_cache to kvm_mmu_memcache
Date:   Tue,  4 Jun 2019 15:33:34 +0200
Message-Id: <20190604133336.22226-3-christoffer.dall@arm.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20190604133336.22226-1-christoffer.dall@arm.com>
References: <20190604133336.22226-1-christoffer.dall@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As we have moved the mmu memory cache definitions and functions to
common code, they are exported as symols to the rest of the kernel.

Let's rename the functions and data types to have a kvm_ prefix to make
it clear where these functions belong and take this chance to rename
memory_cache to memcache to avoid overly long lines.

This is a bit tedious on the callsites but ends up looking more
palatable.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
---
 arch/x86/include/asm/kvm_host.h  |  6 ++---
 arch/x86/include/asm/kvm_types.h |  4 ++--
 arch/x86/kvm/mmu.c               | 38 ++++++++++++++++----------------
 arch/x86/kvm/paging_tmpl.h       |  4 ++--
 include/linux/kvm_host.h         | 14 ++++++------
 include/linux/kvm_types.h        |  6 ++---
 virt/kvm/kvm_main.c              | 14 ++++++------
 7 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 85d54aff72ec..908e07fb2368 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -593,9 +593,9 @@ struct kvm_vcpu_arch {
 	 */
 	struct kvm_mmu *walk_mmu;
 
-	struct kvm_mmu_memory_cache mmu_pte_list_desc_cache;
-	struct kvm_mmu_memory_cache mmu_page_cache;
-	struct kvm_mmu_memory_cache mmu_page_header_cache;
+	struct kvm_mmu_memcache mmu_pte_list_desc_cache;
+	struct kvm_mmu_memcache mmu_page_cache;
+	struct kvm_mmu_memcache mmu_page_header_cache;
 
 	/*
 	 * QEMU userspace and the guest each have their own FPU state.
diff --git a/arch/x86/include/asm/kvm_types.h b/arch/x86/include/asm/kvm_types.h
index ef35a627f69e..d2da445502ba 100644
--- a/arch/x86/include/asm/kvm_types.h
+++ b/arch/x86/include/asm/kvm_types.h
@@ -2,9 +2,9 @@
 #ifndef _ASM_X86_KVM_TYPES_H
 #define _ASM_X86_KVM_TYPES_H
 
-#define KVM_ARCH_WANT_MMU_MEMORY_CACHE
+#define KVM_ARCH_WANT_MMU_MEMCACHE
 
-#define KVM_NR_MEM_OBJS 40
+#define KVM_MMU_NR_MEMCACHE_OBJS 40
 
 #define KVM_MMU_CACHE_GFP_FLAGS		__GFP_ACCOUNT
 
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 79cf345e5d7c..0cfa219b186a 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -971,35 +971,35 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
 	local_irq_enable();
 }
 
-static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
+static int kvm_mmu_topup_memcaches(struct kvm_vcpu *vcpu)
 {
 	int r;
 
-	r = mmu_topup_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
+	r = kvm_mmu_topup_memcache(&vcpu->arch.mmu_pte_list_desc_cache,
 				   pte_list_desc_cache, 8 + PTE_PREFETCH_NUM);
 	if (r)
 		goto out;
-	r = mmu_topup_memory_cache_page(&vcpu->arch.mmu_page_cache, 8);
+	r = kvm_mmu_topup_memcache_page(&vcpu->arch.mmu_page_cache, 8);
 	if (r)
 		goto out;
-	r = mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache,
+	r = kvm_mmu_topup_memcache(&vcpu->arch.mmu_page_header_cache,
 				   mmu_page_header_cache, 4);
 out:
 	return r;
 }
 
-static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
+static void kvm_mmu_free_memcaches(struct kvm_vcpu *vcpu)
 {
-	mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
+	kvm_mmu_free_memcache(&vcpu->arch.mmu_pte_list_desc_cache,
 				pte_list_desc_cache);
-	mmu_free_memory_cache_page(&vcpu->arch.mmu_page_cache);
-	mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache,
+	kvm_mmu_free_memcache_page(&vcpu->arch.mmu_page_cache);
+	kvm_mmu_free_memcache(&vcpu->arch.mmu_page_header_cache,
 				mmu_page_header_cache);
 }
 
 static struct pte_list_desc *mmu_alloc_pte_list_desc(struct kvm_vcpu *vcpu)
 {
-	return mmu_memory_cache_alloc(&vcpu->arch.mmu_pte_list_desc_cache);
+	return kvm_mmu_memcache_alloc(&vcpu->arch.mmu_pte_list_desc_cache);
 }
 
 static void mmu_free_pte_list_desc(struct pte_list_desc *pte_list_desc)
@@ -1319,10 +1319,10 @@ static struct kvm_rmap_head *gfn_to_rmap(struct kvm *kvm, gfn_t gfn,
 
 static bool rmap_can_add(struct kvm_vcpu *vcpu)
 {
-	struct kvm_mmu_memory_cache *cache;
+	struct kvm_mmu_memcache *cache;
 
 	cache = &vcpu->arch.mmu_pte_list_desc_cache;
-	return mmu_memory_cache_free_objects(cache);
+	return kvm_mmu_memcache_free_objects(cache);
 }
 
 static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
@@ -2005,10 +2005,10 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct
 {
 	struct kvm_mmu_page *sp;
 
-	sp = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
-	sp->spt = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_cache);
+	sp = kvm_mmu_memcache_alloc(&vcpu->arch.mmu_page_header_cache);
+	sp->spt = kvm_mmu_memcache_alloc(&vcpu->arch.mmu_page_cache);
 	if (!direct)
-		sp->gfns = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_cache);
+		sp->gfns = kvm_mmu_memcache_alloc(&vcpu->arch.mmu_page_cache);
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
 	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
@@ -3936,7 +3936,7 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 	if (page_fault_handle_page_track(vcpu, error_code, gfn))
 		return RET_PF_EMULATE;
 
-	r = mmu_topup_memory_caches(vcpu);
+	r = kvm_mmu_topup_memcaches(vcpu);
 	if (r)
 		return r;
 
@@ -4065,7 +4065,7 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
 	if (page_fault_handle_page_track(vcpu, error_code, gfn))
 		return RET_PF_EMULATE;
 
-	r = mmu_topup_memory_caches(vcpu);
+	r = kvm_mmu_topup_memcaches(vcpu);
 	if (r)
 		return r;
 
@@ -5042,7 +5042,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 {
 	int r;
 
-	r = mmu_topup_memory_caches(vcpu);
+	r = kvm_mmu_topup_memcaches(vcpu);
 	if (r)
 		goto out;
 	r = mmu_alloc_roots(vcpu);
@@ -5220,7 +5220,7 @@ static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	 * or not since pte prefetch is skiped if it does not have
 	 * enough objects in the cache.
 	 */
-	mmu_topup_memory_caches(vcpu);
+	kvm_mmu_topup_memcaches(vcpu);
 
 	spin_lock(&vcpu->kvm->mmu_lock);
 
@@ -6009,7 +6009,7 @@ void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 {
 	kvm_mmu_unload(vcpu);
 	free_mmu_pages(vcpu);
-	mmu_free_memory_caches(vcpu);
+	kvm_mmu_free_memcaches(vcpu);
 }
 
 void kvm_mmu_module_exit(void)
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 367a47df4ba0..a2535d0d109f 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -767,7 +767,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 
 	pgprintk("%s: addr %lx err %x\n", __func__, addr, error_code);
 
-	r = mmu_topup_memory_caches(vcpu);
+	r = kvm_mmu_topup_memcaches(vcpu);
 	if (r)
 		return r;
 
@@ -890,7 +890,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
 	 * No need to check return value here, rmap_can_add() can
 	 * help us to skip pte prefetch later.
 	 */
-	mmu_topup_memory_caches(vcpu);
+	kvm_mmu_topup_memcaches(vcpu);
 
 	if (!VALID_PAGE(root_hpa)) {
 		WARN_ON(1);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 819b95e090f6..11b5716edf6f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -790,15 +790,15 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool usermode_vcpu_not_eligible);
 void kvm_flush_remote_tlbs(struct kvm *kvm);
 void kvm_reload_remote_mmus(struct kvm *kvm);
 
-#ifdef KVM_ARCH_WANT_MMU_MEMORY_CACHE
-int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
+#ifdef KVM_ARCH_WANT_MMU_MEMCACHE
+int kvm_mmu_topup_memcache(struct kvm_mmu_memcache *cache,
 			   struct kmem_cache *base_cache, int min);
-int mmu_memory_cache_free_objects(struct kvm_mmu_memory_cache *cache);
-void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc,
+int kvm_mmu_memcache_free_objects(struct kvm_mmu_memcache *cache);
+void kvm_mmu_free_memcache(struct kvm_mmu_memcache *mc,
 			   struct kmem_cache *cache);
-int mmu_topup_memory_cache_page(struct kvm_mmu_memory_cache *cache, int min);
-void mmu_free_memory_cache_page(struct kvm_mmu_memory_cache *mc);
-void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
+int kvm_mmu_topup_memcache_page(struct kvm_mmu_memcache *cache, int min);
+void kvm_mmu_free_memcache_page(struct kvm_mmu_memcache *mc);
+void *kvm_mmu_memcache_alloc(struct kvm_mmu_memcache *mc);
 #endif
 
 bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 6cee379588ee..10eaf5f53931 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -64,14 +64,14 @@ struct gfn_to_hva_cache {
 	struct kvm_memory_slot *memslot;
 };
 
-#ifdef KVM_ARCH_WANT_MMU_MEMORY_CACHE
+#ifdef KVM_ARCH_WANT_MMU_MEMCACHE
 /*
  * We don't want allocation failures within the mmu code, so we preallocate
  * enough memory for a single page fault in a cache.
  */
-struct kvm_mmu_memory_cache {
+struct kvm_mmu_memcache {
 	int nobjs;
-	void *objects[KVM_NR_MEM_OBJS];
+	void *objects[KVM_MMU_NR_MEMCACHE_OBJS];
 };
 #endif
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 61cee2052bfd..72ae434cfb72 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -290,8 +290,8 @@ void kvm_reload_remote_mmus(struct kvm *kvm)
 	kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_RELOAD);
 }
 
-#ifdef KVM_ARCH_WANT_MMU_MEMORY_CACHE
-int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
+#ifdef KVM_ARCH_WANT_MMU_MEMCACHE
+int kvm_mmu_topup_memcache(struct kvm_mmu_memcache *cache,
 			   struct kmem_cache *base_cache, int min)
 {
 	void *obj;
@@ -307,19 +307,19 @@ int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
 	return 0;
 }
 
-int mmu_memory_cache_free_objects(struct kvm_mmu_memory_cache *cache)
+int kvm_mmu_memcache_free_objects(struct kvm_mmu_memcache *cache)
 {
 	return cache->nobjs;
 }
 
-void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc,
+void kvm_mmu_free_memcache(struct kvm_mmu_memcache *mc,
 			   struct kmem_cache *cache)
 {
 	while (mc->nobjs)
 		kmem_cache_free(cache, mc->objects[--mc->nobjs]);
 }
 
-int mmu_topup_memory_cache_page(struct kvm_mmu_memory_cache *cache, int min)
+int kvm_mmu_topup_memcache_page(struct kvm_mmu_memcache *cache, int min)
 {
 	void *page;
 
@@ -334,13 +334,13 @@ int mmu_topup_memory_cache_page(struct kvm_mmu_memory_cache *cache, int min)
 	return 0;
 }
 
-void mmu_free_memory_cache_page(struct kvm_mmu_memory_cache *mc)
+void kvm_mmu_free_memcache_page(struct kvm_mmu_memcache *mc)
 {
 	while (mc->nobjs)
 		free_page((unsigned long)mc->objects[--mc->nobjs]);
 }
 
-void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
+void *kvm_mmu_memcache_alloc(struct kvm_mmu_memcache *mc)
 {
 	void *p;
 
-- 
2.18.0

