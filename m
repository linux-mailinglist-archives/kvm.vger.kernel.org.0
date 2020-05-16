Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3790F1D610D
	for <lists+kvm@lfdr.de>; Sat, 16 May 2020 14:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbgEPMx6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 May 2020 08:53:58 -0400
Received: from mga07.intel.com ([134.134.136.100]:47556 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726525AbgEPMx5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 May 2020 08:53:57 -0400
IronPort-SDR: yqy3rkjeItwYw5B0KlEJY83nawS+MRcmwxt+R3dbYuIvYSE1lGeiz79UmSxTYcJd7RZgEPTMAE
 q76Rmxsfpmpg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2020 05:53:52 -0700
IronPort-SDR: E0nFDXIqBESd4FMfKSL8TEP3u/Xj9y4VOP2nfhjCFIztz54t+bG3L81jDbYjxnZiiCA/VYOigc
 ceKb4LpF9Y8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,398,1583222400"; 
   d="scan'208";a="288076571"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by fmsmga004.fm.intel.com with ESMTP; 16 May 2020 05:53:49 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Cc:     yu.c.zhang@linux.intel.com, alazar@bitdefender.com,
        edwin.zhai@intel.com, ssicleru@bitdefender.com,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v12 02/11] mmu: spp: Add a new header file to put definitions shared by MMU and SPP
Date:   Sat, 16 May 2020 20:54:58 +0800
Message-Id: <20200516125507.5277-3-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200516125507.5277-1-weijiang.yang@intel.com>
References: <20200516125507.5277-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SPP re-uses many MMU data structures, macros and functions etc. To separate spp.c
as a new compilation unit, put these shared parts into a new mmu_internal.h file.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/mmu.h          |   7 --
 arch/x86/kvm/mmu/mmu.c      | 140 ++++++++++------------------------
 arch/x86/kvm/mmu_internal.h | 145 ++++++++++++++++++++++++++++++++++++
 3 files changed, 185 insertions(+), 107 deletions(-)
 create mode 100644 arch/x86/kvm/mmu_internal.h

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 8a3b1bce722a..da199f0a69db 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -22,8 +22,6 @@
 #define PT_ACCESSED_MASK (1ULL << PT_ACCESSED_SHIFT)
 #define PT_DIRTY_SHIFT 6
 #define PT_DIRTY_MASK (1ULL << PT_DIRTY_SHIFT)
-#define PT_PAGE_SIZE_SHIFT 7
-#define PT_PAGE_SIZE_MASK (1ULL << PT_PAGE_SIZE_SHIFT)
 #define PT_PAT_MASK (1ULL << 7)
 #define PT_GLOBAL_MASK (1ULL << 8)
 #define PT64_NX_SHIFT 63
@@ -38,11 +36,6 @@
 #define PT32_DIR_PSE36_MASK \
 	(((1ULL << PT32_DIR_PSE36_SIZE) - 1) << PT32_DIR_PSE36_SHIFT)
 
-#define PT64_ROOT_5LEVEL 5
-#define PT64_ROOT_4LEVEL 4
-#define PT32_ROOT_LEVEL 2
-#define PT32E_ROOT_LEVEL 3
-
 static inline u64 rsvd_bits(int s, int e)
 {
 	if (e < s)
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8071952e9cf2..615effaf5814 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -16,6 +16,7 @@
  */
 
 #include "irq.h"
+#include "mmu_internal.h"
 #include "mmu.h"
 #include "x86.h"
 #include "kvm_cache_regs.h"
@@ -116,7 +117,6 @@ module_param(dbg, bool, 0644);
 #define PTE_PREFETCH_NUM		8
 
 #define PT_FIRST_AVAIL_BITS_SHIFT 10
-#define PT64_SECOND_AVAIL_BITS_SHIFT 54
 
 /*
  * The mask used to denote special SPTEs, which can be either MMIO SPTEs or
@@ -128,15 +128,6 @@ module_param(dbg, bool, 0644);
 #define SPTE_AD_WRPROT_ONLY_MASK (2ULL << 52)
 #define SPTE_MMIO_MASK (3ULL << 52)
 
-#define PT64_LEVEL_BITS 9
-
-#define PT64_LEVEL_SHIFT(level) \
-		(PAGE_SHIFT + (level - 1) * PT64_LEVEL_BITS)
-
-#define PT64_INDEX(address, level)\
-	(((address) >> PT64_LEVEL_SHIFT(level)) & ((1 << PT64_LEVEL_BITS) - 1))
-
-
 #define PT32_LEVEL_BITS 10
 
 #define PT32_LEVEL_SHIFT(level) \
@@ -149,7 +140,6 @@ module_param(dbg, bool, 0644);
 #define PT32_INDEX(address, level)\
 	(((address) >> PT32_LEVEL_SHIFT(level)) & ((1 << PT32_LEVEL_BITS) - 1))
 
-
 #ifdef CONFIG_DYNAMIC_PHYSICAL_MASK
 #define PT64_BASE_ADDR_MASK (physical_mask & ~(u64)(PAGE_SIZE-1))
 #else
@@ -186,11 +176,6 @@ module_param(dbg, bool, 0644);
 #define SPTE_HOST_WRITEABLE	(1ULL << PT_FIRST_AVAIL_BITS_SHIFT)
 #define SPTE_MMU_WRITEABLE	(1ULL << (PT_FIRST_AVAIL_BITS_SHIFT + 1))
 
-#define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)
-
-/* make pte_list_desc fit well in cache line */
-#define PTE_LIST_EXT 3
-
 /*
  * Return values of handle_mmio_page_fault and mmu.page_fault:
  * RET_PF_RETRY: let CPU fault again on the address.
@@ -205,30 +190,6 @@ enum {
 	RET_PF_INVALID = 2,
 };
 
-struct pte_list_desc {
-	u64 *sptes[PTE_LIST_EXT];
-	struct pte_list_desc *more;
-};
-
-struct kvm_shadow_walk_iterator {
-	u64 addr;
-	hpa_t shadow_addr;
-	u64 *sptep;
-	int level;
-	unsigned index;
-};
-
-#define for_each_shadow_entry_using_root(_vcpu, _root, _addr, _walker)     \
-	for (shadow_walk_init_using_root(&(_walker), (_vcpu),              \
-					 (_root), (_addr));                \
-	     shadow_walk_okay(&(_walker));			           \
-	     shadow_walk_next(&(_walker)))
-
-#define for_each_shadow_entry(_vcpu, _addr, _walker)            \
-	for (shadow_walk_init(&(_walker), _vcpu, _addr);	\
-	     shadow_walk_okay(&(_walker));			\
-	     shadow_walk_next(&(_walker)))
-
 #define for_each_shadow_entry_lockless(_vcpu, _addr, _walker, spte)	\
 	for (shadow_walk_init(&(_walker), _vcpu, _addr);		\
 	     shadow_walk_okay(&(_walker)) &&				\
@@ -237,15 +198,15 @@ struct kvm_shadow_walk_iterator {
 
 static struct kmem_cache *pte_list_desc_cache;
 static struct kmem_cache *mmu_page_header_cache;
-static struct percpu_counter kvm_total_used_mmu_pages;
+struct percpu_counter kvm_total_used_mmu_pages;
 
 static u64 __read_mostly shadow_nx_mask;
 static u64 __read_mostly shadow_x_mask;	/* mutual exclusive with nx_mask */
 static u64 __read_mostly shadow_user_mask;
 static u64 __read_mostly shadow_accessed_mask;
 static u64 __read_mostly shadow_dirty_mask;
-static u64 __read_mostly shadow_mmio_mask;
-static u64 __read_mostly shadow_mmio_value;
+u64 __read_mostly shadow_mmio_mask;
+u64 __read_mostly shadow_mmio_value;
 static u64 __read_mostly shadow_mmio_access_mask;
 static u64 __read_mostly shadow_present_mask;
 static u64 __read_mostly shadow_me_mask;
@@ -294,7 +255,7 @@ static u64 __read_mostly shadow_nonpresent_or_rsvd_lower_gfn_mask;
  */
 static u8 __read_mostly shadow_phys_bits;
 
-static void mmu_spte_set(u64 *sptep, u64 spte);
+void mmu_spte_set(u64 *sptep, u64 spte);
 static bool is_executable_pte(u64 spte);
 static union kvm_mmu_page_role
 kvm_mmu_calc_root_page_role(struct kvm_vcpu *vcpu);
@@ -341,7 +302,7 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_mask, u64 mmio_value, u64 access_mask)
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);
 
-static bool is_mmio_spte(u64 spte)
+bool is_mmio_spte(u64 spte)
 {
 	return (spte & shadow_mmio_mask) == shadow_mmio_value;
 }
@@ -608,17 +569,17 @@ static int is_nx(struct kvm_vcpu *vcpu)
 	return vcpu->arch.efer & EFER_NX;
 }
 
-static int is_shadow_present_pte(u64 pte)
+int is_shadow_present_pte(u64 pte)
 {
 	return (pte != 0) && !is_mmio_spte(pte);
 }
 
-static int is_large_pte(u64 pte)
+int is_large_pte(u64 pte)
 {
 	return pte & PT_PAGE_SIZE_MASK;
 }
 
-static int is_last_spte(u64 pte, int level)
+int is_last_spte(u64 pte, int level)
 {
 	if (level == PT_PAGE_TABLE_LEVEL)
 		return 1;
@@ -645,7 +606,7 @@ static gfn_t pse36_gfn_delta(u32 gpte)
 }
 
 #ifdef CONFIG_X86_64
-static void __set_spte(u64 *sptep, u64 spte)
+void __set_spte(u64 *sptep, u64 spte)
 {
 	WRITE_ONCE(*sptep, spte);
 }
@@ -660,7 +621,7 @@ static u64 __update_clear_spte_slow(u64 *sptep, u64 spte)
 	return xchg(sptep, spte);
 }
 
-static u64 __get_spte_lockless(u64 *sptep)
+u64 __get_spte_lockless(u64 *sptep)
 {
 	return READ_ONCE(*sptep);
 }
@@ -685,7 +646,7 @@ static void count_spte_clear(u64 *sptep, u64 spte)
 	sp->clear_spte_count++;
 }
 
-static void __set_spte(u64 *sptep, u64 spte)
+void __set_spte(u64 *sptep, u64 spte)
 {
 	union split_spte *ssptep, sspte;
 
@@ -757,7 +718,7 @@ static u64 __update_clear_spte_slow(u64 *sptep, u64 spte)
  * present->non-present updates: if it changed while reading the spte,
  * we might have hit the race.  This is done using clear_spte_count.
  */
-static u64 __get_spte_lockless(u64 *sptep)
+u64 __get_spte_lockless(u64 *sptep)
 {
 	struct kvm_mmu_page *sp =  page_header(__pa(sptep));
 	union split_spte spte, *orig = (union split_spte *)sptep;
@@ -832,7 +793,7 @@ static bool is_dirty_spte(u64 spte)
  * or in a state where the hardware will not attempt to update
  * the spte.
  */
-static void mmu_spte_set(u64 *sptep, u64 new_spte)
+void mmu_spte_set(u64 *sptep, u64 new_spte)
 {
 	WARN_ON(is_shadow_present_pte(*sptep));
 	__set_spte(sptep, new_spte);
@@ -842,7 +803,7 @@ static void mmu_spte_set(u64 *sptep, u64 new_spte)
  * Update the SPTE (excluding the PFN), but do not track changes in its
  * accessed/dirty status.
  */
-static u64 mmu_spte_update_no_track(u64 *sptep, u64 new_spte)
+u64 mmu_spte_update_no_track(u64 *sptep, u64 new_spte)
 {
 	u64 old_spte = *sptep;
 
@@ -874,7 +835,7 @@ static u64 mmu_spte_update_no_track(u64 *sptep, u64 new_spte)
  *
  * Returns true if the TLB needs to be flushed
  */
-static bool mmu_spte_update(u64 *sptep, u64 new_spte)
+bool mmu_spte_update(u64 *sptep, u64 new_spte)
 {
 	bool flush = false;
 	u64 old_spte = mmu_spte_update_no_track(sptep, new_spte);
@@ -915,7 +876,7 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
  * state bits, it is used to clear the last level sptep.
  * Returns non-zero if the PTE was previously valid.
  */
-static int mmu_spte_clear_track_bits(u64 *sptep)
+int mmu_spte_clear_track_bits(u64 *sptep)
 {
 	kvm_pfn_t pfn;
 	u64 old_spte = *sptep;
@@ -956,7 +917,7 @@ static void mmu_spte_clear_no_track(u64 *sptep)
 	__update_clear_spte_fast(sptep, 0ull);
 }
 
-static u64 mmu_spte_get_lockless(u64 *sptep)
+u64 mmu_spte_get_lockless(u64 *sptep)
 {
 	return __get_spte_lockless(sptep);
 }
@@ -1109,7 +1070,7 @@ static void mmu_free_memory_cache_page(struct kvm_mmu_memory_cache *mc)
 		free_page((unsigned long)mc->objects[--mc->nobjs]);
 }
 
-static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
+int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
 {
 	int r;
 
@@ -1135,7 +1096,7 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 				mmu_page_header_cache);
 }
 
-static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
+void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
 {
 	void *p;
 
@@ -1144,7 +1105,7 @@ static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
 	return p;
 }
 
-static struct pte_list_desc *mmu_alloc_pte_list_desc(struct kvm_vcpu *vcpu)
+struct pte_list_desc *mmu_alloc_pte_list_desc(struct kvm_vcpu *vcpu)
 {
 	return mmu_memory_cache_alloc(&vcpu->arch.mmu_pte_list_desc_cache);
 }
@@ -1293,7 +1254,7 @@ gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu, gfn_t gfn,
 /*
  * Returns the number of pointers in the rmap chain, not counting the new one.
  */
-static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
+int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
 			struct kvm_rmap_head *rmap_head)
 {
 	struct pte_list_desc *desc;
@@ -1350,7 +1311,7 @@ pte_list_desc_remove_entry(struct kvm_rmap_head *rmap_head,
 	mmu_free_pte_list_desc(desc);
 }
 
-static void __pte_list_remove(u64 *spte, struct kvm_rmap_head *rmap_head)
+void __pte_list_remove(u64 *spte, struct kvm_rmap_head *rmap_head)
 {
 	struct pte_list_desc *desc;
 	struct pte_list_desc *prev_desc;
@@ -1386,13 +1347,13 @@ static void __pte_list_remove(u64 *spte, struct kvm_rmap_head *rmap_head)
 	}
 }
 
-static void pte_list_remove(struct kvm_rmap_head *rmap_head, u64 *sptep)
+void pte_list_remove(struct kvm_rmap_head *rmap_head, u64 *sptep)
 {
 	mmu_spte_clear_track_bits(sptep);
 	__pte_list_remove(sptep, rmap_head);
 }
 
-static struct kvm_rmap_head *__gfn_to_rmap(gfn_t gfn, int level,
+struct kvm_rmap_head *__gfn_to_rmap(gfn_t gfn, int level,
 					   struct kvm_memory_slot *slot)
 {
 	unsigned long idx;
@@ -1431,7 +1392,7 @@ static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 	return pte_list_add(vcpu, spte, rmap_head);
 }
 
-static void rmap_remove(struct kvm *kvm, u64 *spte)
+void rmap_remove(struct kvm *kvm, u64 *spte)
 {
 	struct kvm_mmu_page *sp;
 	gfn_t gfn;
@@ -1443,16 +1404,6 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 	__pte_list_remove(spte, rmap_head);
 }
 
-/*
- * Used by the following functions to iterate through the sptes linked by a
- * rmap.  All fields are private and not assumed to be used outside.
- */
-struct rmap_iterator {
-	/* private fields */
-	struct pte_list_desc *desc;	/* holds the sptep if not NULL */
-	int pos;			/* index of the sptep */
-};
-
 /*
  * Iteration must be started by this function.  This should also be used after
  * removing/dropping sptes from the rmap link because in such cases the
@@ -1460,7 +1411,7 @@ struct rmap_iterator {
  *
  * Returns sptep if found, NULL otherwise.
  */
-static u64 *rmap_get_first(struct kvm_rmap_head *rmap_head,
+u64 *rmap_get_first(struct kvm_rmap_head *rmap_head,
 			   struct rmap_iterator *iter)
 {
 	u64 *sptep;
@@ -1487,7 +1438,7 @@ static u64 *rmap_get_first(struct kvm_rmap_head *rmap_head,
  *
  * Returns sptep if found, NULL otherwise.
  */
-static u64 *rmap_get_next(struct rmap_iterator *iter)
+u64 *rmap_get_next(struct rmap_iterator *iter)
 {
 	u64 *sptep;
 
@@ -1515,11 +1466,7 @@ static u64 *rmap_get_next(struct rmap_iterator *iter)
 	return sptep;
 }
 
-#define for_each_rmap_spte(_rmap_head_, _iter_, _spte_)			\
-	for (_spte_ = rmap_get_first(_rmap_head_, _iter_);		\
-	     _spte_; _spte_ = rmap_get_next(_iter_))
-
-static void drop_spte(struct kvm *kvm, u64 *sptep)
+void drop_spte(struct kvm *kvm, u64 *sptep)
 {
 	if (mmu_spte_clear_track_bits(sptep))
 		rmap_remove(kvm, sptep);
@@ -1562,7 +1509,7 @@ static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
  *
  * Return true if tlb need be flushed.
  */
-static bool spte_write_protect(u64 *sptep, bool pt_protect)
+bool spte_write_protect(u64 *sptep, bool pt_protect)
 {
 	u64 spte = *sptep;
 
@@ -2057,7 +2004,7 @@ static int is_empty_shadow_page(u64 *spt)
  * aggregate version in order to make the slab shrinker
  * faster
  */
-static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, unsigned long nr)
+inline void kvm_mod_used_mmu_pages(struct kvm *kvm, unsigned long nr)
 {
 	kvm->arch.n_used_mmu_pages += nr;
 	percpu_counter_add(&kvm_total_used_mmu_pages, nr);
@@ -2074,12 +2021,12 @@ static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
 	kmem_cache_free(mmu_page_header_cache, sp);
 }
 
-static unsigned kvm_page_table_hashfn(gfn_t gfn)
+unsigned kvm_page_table_hashfn(gfn_t gfn)
 {
 	return hash_64(gfn, KVM_MMU_HASH_SHIFT);
 }
 
-static void mmu_page_add_parent_pte(struct kvm_vcpu *vcpu,
+void mmu_page_add_parent_pte(struct kvm_vcpu *vcpu,
 				    struct kvm_mmu_page *sp, u64 *parent_pte)
 {
 	if (!parent_pte)
@@ -2101,7 +2048,7 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
 	mmu_spte_clear_no_track(parent_pte);
 }
 
-static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct)
+struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct)
 {
 	struct kvm_mmu_page *sp;
 
@@ -2262,13 +2209,6 @@ static bool kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
 static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 				    struct list_head *invalid_list);
 
-
-#define for_each_valid_sp(_kvm, _sp, _gfn)				\
-	hlist_for_each_entry(_sp,					\
-	  &(_kvm)->arch.mmu_page_hash[kvm_page_table_hashfn(_gfn)], hash_link) \
-		if (is_obsolete_sp((_kvm), (_sp))) {			\
-		} else
-
 #define for_each_gfn_indirect_valid_sp(_kvm, _sp, _gfn)			\
 	for_each_valid_sp(_kvm, _sp, _gfn)				\
 		if ((_sp)->gfn != (_gfn) || (_sp)->role.direct) {} else
@@ -2323,7 +2263,7 @@ static void kvm_mmu_audit(struct kvm_vcpu *vcpu, int point) { }
 static void mmu_audit_disable(void) { }
 #endif
 
-static bool is_obsolete_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
+bool is_obsolete_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	return sp->role.invalid ||
 	       unlikely(sp->mmu_valid_gen != kvm->arch.mmu_valid_gen);
@@ -2563,7 +2503,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	return sp;
 }
 
-static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterator,
+void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterator,
 					struct kvm_vcpu *vcpu, hpa_t root,
 					u64 addr)
 {
@@ -2592,14 +2532,14 @@ static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterato
 	}
 }
 
-static void shadow_walk_init(struct kvm_shadow_walk_iterator *iterator,
+void shadow_walk_init(struct kvm_shadow_walk_iterator *iterator,
 			     struct kvm_vcpu *vcpu, u64 addr)
 {
 	shadow_walk_init_using_root(iterator, vcpu, vcpu->arch.mmu->root_hpa,
 				    addr);
 }
 
-static bool shadow_walk_okay(struct kvm_shadow_walk_iterator *iterator)
+bool shadow_walk_okay(struct kvm_shadow_walk_iterator *iterator)
 {
 	if (iterator->level < PT_PAGE_TABLE_LEVEL)
 		return false;
@@ -2609,7 +2549,7 @@ static bool shadow_walk_okay(struct kvm_shadow_walk_iterator *iterator)
 	return true;
 }
 
-static void __shadow_walk_next(struct kvm_shadow_walk_iterator *iterator,
+void __shadow_walk_next(struct kvm_shadow_walk_iterator *iterator,
 			       u64 spte)
 {
 	if (is_last_spte(spte, iterator->level)) {
@@ -2621,7 +2561,7 @@ static void __shadow_walk_next(struct kvm_shadow_walk_iterator *iterator,
 	--iterator->level;
 }
 
-static void shadow_walk_next(struct kvm_shadow_walk_iterator *iterator)
+void shadow_walk_next(struct kvm_shadow_walk_iterator *iterator)
 {
 	__shadow_walk_next(iterator, *iterator->sptep);
 }
diff --git a/arch/x86/kvm/mmu_internal.h b/arch/x86/kvm/mmu_internal.h
new file mode 100644
index 000000000000..68e8179e7642
--- /dev/null
+++ b/arch/x86/kvm/mmu_internal.h
@@ -0,0 +1,145 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __KVM_X86_MMU_INTERNAL_H
+#define __KVM_X86_MMU_INTERNAL_H
+
+/* make pte_list_desc fit well in cache line */
+#define PTE_LIST_EXT 3
+#define PT64_SECOND_AVAIL_BITS_SHIFT 54
+#define PT64_ROOT_5LEVEL 5
+#define PT64_ROOT_4LEVEL 4
+#define PT32_ROOT_LEVEL 2
+#define PT32E_ROOT_LEVEL 3
+#define PT64_LEVEL_BITS 9
+#define PT_PAGE_SIZE_SHIFT 7
+#define PT_PAGE_SIZE_MASK (1ULL << PT_PAGE_SIZE_SHIFT)
+
+#define PT64_LEVEL_SHIFT(level) \
+		(PAGE_SHIFT + (level - 1) * PT64_LEVEL_BITS)
+
+#define PT64_INDEX(address, level)\
+	(((address) >> PT64_LEVEL_SHIFT(level)) & ((1 << PT64_LEVEL_BITS) - 1))
+
+#define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)
+
+#ifdef CONFIG_DYNAMIC_PHYSICAL_MASK
+#define PT64_BASE_ADDR_MASK (physical_mask & ~(u64)(PAGE_SIZE-1))
+#else
+#define PT64_BASE_ADDR_MASK (((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1))
+#endif
+#define PT64_LVL_ADDR_MASK(level) \
+	(PT64_BASE_ADDR_MASK & ~((1ULL << (PAGE_SHIFT + (((level) - 1) \
+						* PT64_LEVEL_BITS))) - 1))
+#define PT64_SPP_SAVED_BIT      (1ULL << (PT64_SECOND_AVAIL_BITS_SHIFT + 1))
+/*
+ * Used by the following functions to iterate through the sptes linked by a
+ * rmap.  All fields are private and not assumed to be used outside.
+ */
+struct rmap_iterator {
+	/* private fields */
+	struct pte_list_desc *desc;	/* holds the sptep if not NULL */
+	int pos;			/* index of the sptep */
+};
+
+struct pte_list_desc {
+	u64 *sptes[PTE_LIST_EXT];
+	struct pte_list_desc *more;
+};
+
+struct kvm_shadow_walk_iterator {
+	u64 addr;
+	hpa_t shadow_addr;
+	u64 *sptep;
+	int level;
+	unsigned index;
+};
+
+int is_large_pte(u64 pte);
+int is_last_spte(u64 pte, int level);
+
+u64 mmu_spte_update_no_track(u64 *sptep, u64 new_spte);
+
+void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterator,
+					struct kvm_vcpu *vcpu, hpa_t root,
+					u64 addr);
+void shadow_walk_init(struct kvm_shadow_walk_iterator *iterator,
+			     struct kvm_vcpu *vcpu, u64 addr);
+bool shadow_walk_okay(struct kvm_shadow_walk_iterator *iterator);
+
+void __shadow_walk_next(struct kvm_shadow_walk_iterator *iterator,
+			       u64 spte);
+void shadow_walk_next(struct kvm_shadow_walk_iterator *iterator);
+
+u64 *rmap_get_first(struct kvm_rmap_head *rmap_head,
+			   struct rmap_iterator *iter);
+
+bool spte_write_protect(u64 *sptep, bool pt_protect);
+
+u64 *rmap_get_next(struct rmap_iterator *iter);
+
+bool is_obsolete_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
+
+#define for_each_valid_sp(_kvm, _sp, _gfn)				\
+	hlist_for_each_entry(_sp,					\
+	  &(_kvm)->arch.mmu_page_hash[kvm_page_table_hashfn(_gfn)], hash_link) \
+		if (is_obsolete_sp((_kvm), (_sp))) {			\
+		} else
+
+#define for_each_rmap_spte(_rmap_head_, _iter_, _spte_)			\
+	for (_spte_ = rmap_get_first(_rmap_head_, _iter_);		\
+	     _spte_; _spte_ = rmap_get_next(_iter_))
+
+#define for_each_shadow_entry_using_root(_vcpu, _root, _addr, _walker)     \
+	for (shadow_walk_init_using_root(&(_walker), (_vcpu),              \
+					 (_root), (_addr));                \
+	     shadow_walk_okay(&(_walker));			           \
+	     shadow_walk_next(&(_walker)))
+
+#define for_each_shadow_entry(_vcpu, _addr, _walker)            \
+	for (shadow_walk_init(&(_walker), _vcpu, _addr);	\
+	     shadow_walk_okay(&(_walker));			\
+	     shadow_walk_next(&(_walker)))
+
+bool is_mmio_spte(u64 spte);
+
+int is_shadow_present_pte(u64 pte);
+
+void __set_spte(u64 *sptep, u64 spte);
+
+int mmu_topup_memory_caches(struct kvm_vcpu *vcpu);
+
+void drop_spte(struct kvm *kvm, u64 *sptep);
+
+int mmu_spte_clear_track_bits(u64 *sptep);
+
+void rmap_remove(struct kvm *kvm, u64 *spte);
+
+bool mmu_spte_update(u64 *sptep, u64 new_spte);
+
+struct kvm_rmap_head *__gfn_to_rmap(gfn_t gfn, int level,
+				    struct kvm_memory_slot *slot);
+
+void __pte_list_remove(u64 *spte, struct kvm_rmap_head *rmap_head);
+
+void pte_list_remove(struct kvm_rmap_head *rmap_head, u64 *sptep);
+
+u64 __get_spte_lockless(u64 *sptep);
+
+u64 mmu_spte_get_lockless(u64 *sptep);
+
+unsigned kvm_page_table_hashfn(gfn_t gfn);
+
+void mmu_spte_set(u64 *sptep, u64 new_spte);
+
+void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
+
+struct pte_list_desc *mmu_alloc_pte_list_desc(struct kvm_vcpu *vcpu);
+
+int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
+			struct kvm_rmap_head *rmap_head);
+
+void mmu_page_add_parent_pte(struct kvm_vcpu *vcpu,
+				    struct kvm_mmu_page *sp, u64 *parent_pte);
+void kvm_mod_used_mmu_pages(struct kvm *kvm, unsigned long nr);
+
+struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct);
+#endif
-- 
2.17.2

