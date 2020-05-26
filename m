Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D000E1BB313
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 02:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgD1Ayd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 20:54:33 -0400
Received: from mga05.intel.com ([192.55.52.43]:42479 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726360AbgD1Ayc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 20:54:32 -0400
IronPort-SDR: rqiHTyS5lUOYSKGMVhCNtfJ+TKOjbJ7m8Mi1+d+rD3L5+5EH6SUW09eGp0uumB568FWpauarxB
 ovZ5IkQKW96w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2020 17:54:23 -0700
IronPort-SDR: vXwpQVgPJQT5uqZ45hn3ZVOR6WDCaNaIxqb9z5WCwzOAJBFuaKlxUhUO2i38JMym0AY66WIzeT
 o9Z5LJ/as1vQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,325,1583222400"; 
   d="scan'208";a="260920810"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 27 Apr 2020 17:54:23 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Barret Rhoden <brho@google.com>
Subject: [PATCH 3/3] KVM: x86/mmu: Drop KVM's hugepage enums in favor of the kernel's enums
Date:   Mon, 27 Apr 2020 17:54:22 -0700
Message-Id: <20200428005422.4235-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200428005422.4235-1-sean.j.christopherson@intel.com>
References: <20200428005422.4235-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace KVM's PT_PAGE_TABLE_LEVEL, PT_DIRECTORY_LEVEL and PT_PDPE_LEVEL
with the kernel's PG_LEVEL_4K, PG_LEVEL_2M and PG_LEVEL_1G.  KVM's
enums are borderline impossible to remember and result in code that is
visually difficult to audit, e.g.

        if (!enable_ept)
                ept_lpage_level = 0;
        else if (cpu_has_vmx_ept_1g_page())
                ept_lpage_level = PT_PDPE_LEVEL;
        else if (cpu_has_vmx_ept_2m_page())
                ept_lpage_level = PT_DIRECTORY_LEVEL;
        else
                ept_lpage_level = PT_PAGE_TABLE_LEVEL;

versus

        if (!enable_ept)
                ept_lpage_level = 0;
        else if (cpu_has_vmx_ept_1g_page())
                ept_lpage_level = PG_LEVEL_1G;
        else if (cpu_has_vmx_ept_2m_page())
                ept_lpage_level = PG_LEVEL_2M;
        else
                ept_lpage_level = PG_LEVEL_4K;

No functional change intended.

Suggested-by: Barret Rhoden <brho@google.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  12 +---
 arch/x86/kvm/mmu/mmu.c          | 107 +++++++++++++++-----------------
 arch/x86/kvm/mmu/page_track.c   |   4 +-
 arch/x86/kvm/mmu/paging_tmpl.h  |  18 +++---
 arch/x86/kvm/mmu_audit.c        |   6 +-
 arch/x86/kvm/svm/svm.c          |   2 +-
 arch/x86/kvm/vmx/vmx.c          |   6 +-
 arch/x86/kvm/x86.c              |   4 +-
 8 files changed, 73 insertions(+), 86 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 204f742bf096..5b83e3dc673a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -110,14 +110,8 @@
 #define UNMAPPED_GVA (~(gpa_t)0)
 
 /* KVM Hugepage definitions for x86 */
-enum {
-	PT_PAGE_TABLE_LEVEL   = 1,
-	PT_DIRECTORY_LEVEL    = 2,
-	PT_PDPE_LEVEL         = 3,
-};
-#define KVM_MAX_HUGEPAGE_LEVEL	PT_PDPE_LEVEL
-#define KVM_NR_PAGE_SIZES	(KVM_MAX_HUGEPAGE_LEVEL - \
-				 PT_PAGE_TABLE_LEVEL + 1)
+#define KVM_MAX_HUGEPAGE_LEVEL	PG_LEVEL_1G
+#define KVM_NR_PAGE_SIZES	(KVM_MAX_HUGEPAGE_LEVEL - PG_LEVEL_4K + 1)
 #define KVM_HPAGE_GFN_SHIFT(x)	(((x) - 1) * 9)
 #define KVM_HPAGE_SHIFT(x)	(PAGE_SHIFT + KVM_HPAGE_GFN_SHIFT(x))
 #define KVM_HPAGE_SIZE(x)	(1UL << KVM_HPAGE_SHIFT(x))
@@ -126,7 +120,7 @@ enum {
 
 static inline gfn_t gfn_to_index(gfn_t gfn, gfn_t base_gfn, int level)
 {
-	/* KVM_HPAGE_GFN_SHIFT(PT_PAGE_TABLE_LEVEL) must be 0. */
+	/* KVM_HPAGE_GFN_SHIFT(PG_LEVEL_4K) must be 0. */
 	return (gfn >> KVM_HPAGE_GFN_SHIFT(level)) -
 		(base_gfn >> KVM_HPAGE_GFN_SHIFT(level));
 }
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 324734db25ce..5c3e8d65f20f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -623,7 +623,7 @@ static int is_large_pte(u64 pte)
 
 static int is_last_spte(u64 pte, int level)
 {
-	if (level == PT_PAGE_TABLE_LEVEL)
+	if (level == PG_LEVEL_4K)
 		return 1;
 	if (is_large_pte(pte))
 		return 1;
@@ -1199,7 +1199,7 @@ static void update_gfn_disallow_lpage_count(struct kvm_memory_slot *slot,
 	struct kvm_lpage_info *linfo;
 	int i;
 
-	for (i = PT_DIRECTORY_LEVEL; i <= KVM_MAX_HUGEPAGE_LEVEL; ++i) {
+	for (i = PG_LEVEL_2M; i <= KVM_MAX_HUGEPAGE_LEVEL; ++i) {
 		linfo = lpage_info_slot(gfn, slot, i);
 		linfo->disallow_lpage += count;
 		WARN_ON(linfo->disallow_lpage < 0);
@@ -1228,7 +1228,7 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 	slot = __gfn_to_memslot(slots, gfn);
 
 	/* the non-leaf shadow pages are keeping readonly. */
-	if (sp->role.level > PT_PAGE_TABLE_LEVEL)
+	if (sp->role.level > PG_LEVEL_4K)
 		return kvm_slot_page_track_add_page(kvm, slot, gfn,
 						    KVM_PAGE_TRACK_WRITE);
 
@@ -1256,7 +1256,7 @@ static void unaccount_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 	gfn = sp->gfn;
 	slots = kvm_memslots_for_spte_role(kvm, sp->role);
 	slot = __gfn_to_memslot(slots, gfn);
-	if (sp->role.level > PT_PAGE_TABLE_LEVEL)
+	if (sp->role.level > PG_LEVEL_4K)
 		return kvm_slot_page_track_remove_page(kvm, slot, gfn,
 						       KVM_PAGE_TRACK_WRITE);
 
@@ -1401,7 +1401,7 @@ static struct kvm_rmap_head *__gfn_to_rmap(gfn_t gfn, int level,
 	unsigned long idx;
 
 	idx = gfn_to_index(gfn, slot->base_gfn, level);
-	return &slot->arch.rmap[level - PT_PAGE_TABLE_LEVEL][idx];
+	return &slot->arch.rmap[level - PG_LEVEL_4K][idx];
 }
 
 static struct kvm_rmap_head *gfn_to_rmap(struct kvm *kvm, gfn_t gfn,
@@ -1532,8 +1532,7 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
 static bool __drop_large_spte(struct kvm *kvm, u64 *sptep)
 {
 	if (is_large_pte(*sptep)) {
-		WARN_ON(page_header(__pa(sptep))->role.level ==
-			PT_PAGE_TABLE_LEVEL);
+		WARN_ON(page_header(__pa(sptep))->role.level == PG_LEVEL_4K);
 		drop_spte(kvm, sptep);
 		--kvm->stat.lpages;
 		return true;
@@ -1685,7 +1684,7 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 
 	while (mask) {
 		rmap_head = __gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
-					  PT_PAGE_TABLE_LEVEL, slot);
+					  PG_LEVEL_4K, slot);
 		__rmap_write_protect(kvm, rmap_head, false);
 
 		/* clear the first set bit */
@@ -1711,7 +1710,7 @@ void kvm_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 
 	while (mask) {
 		rmap_head = __gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
-					  PT_PAGE_TABLE_LEVEL, slot);
+					  PG_LEVEL_4K, slot);
 		__rmap_clear_dirty(kvm, rmap_head);
 
 		/* clear the first set bit */
@@ -1763,7 +1762,7 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 	int i;
 	bool write_protected = false;
 
-	for (i = PT_PAGE_TABLE_LEVEL; i <= KVM_MAX_HUGEPAGE_LEVEL; ++i) {
+	for (i = PG_LEVEL_4K; i <= KVM_MAX_HUGEPAGE_LEVEL; ++i) {
 		rmap_head = __gfn_to_rmap(gfn, i, slot);
 		write_protected |= __rmap_write_protect(kvm, rmap_head, true);
 	}
@@ -1951,7 +1950,7 @@ static int kvm_handle_hva_range(struct kvm *kvm,
 			gfn_start = hva_to_gfn_memslot(hva_start, memslot);
 			gfn_end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, memslot);
 
-			for_each_slot_rmap_range(memslot, PT_PAGE_TABLE_LEVEL,
+			for_each_slot_rmap_range(memslot, PG_LEVEL_4K,
 						 KVM_MAX_HUGEPAGE_LEVEL,
 						 gfn_start, gfn_end - 1,
 						 &iterator)
@@ -2346,7 +2345,7 @@ static bool kvm_sync_pages(struct kvm_vcpu *vcpu, gfn_t gfn,
 		if (!s->unsync)
 			continue;
 
-		WARN_ON(s->role.level != PT_PAGE_TABLE_LEVEL);
+		WARN_ON(s->role.level != PG_LEVEL_4K);
 		ret |= kvm_sync_page(vcpu, s, invalid_list);
 	}
 
@@ -2375,7 +2374,7 @@ static int mmu_pages_next(struct kvm_mmu_pages *pvec,
 		int level = sp->role.level;
 
 		parents->idx[level-1] = idx;
-		if (level == PT_PAGE_TABLE_LEVEL)
+		if (level == PG_LEVEL_4K)
 			break;
 
 		parents->parent[level-2] = sp;
@@ -2397,7 +2396,7 @@ static int mmu_pages_first(struct kvm_mmu_pages *pvec,
 
 	sp = pvec->page[0].sp;
 	level = sp->role.level;
-	WARN_ON(level == PT_PAGE_TABLE_LEVEL);
+	WARN_ON(level == PG_LEVEL_4K);
 
 	parents->parent[level-2] = sp;
 
@@ -2545,11 +2544,10 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 		 * be inconsistent with guest page table.
 		 */
 		account_shadowed(vcpu->kvm, sp);
-		if (level == PT_PAGE_TABLE_LEVEL &&
-		      rmap_write_protect(vcpu, gfn))
+		if (level == PG_LEVEL_4K && rmap_write_protect(vcpu, gfn))
 			kvm_flush_remote_tlbs_with_address(vcpu->kvm, gfn, 1);
 
-		if (level > PT_PAGE_TABLE_LEVEL && need_sync)
+		if (level > PG_LEVEL_4K && need_sync)
 			flush |= kvm_sync_pages(vcpu, gfn, &invalid_list);
 	}
 	clear_page(sp->spt);
@@ -2600,7 +2598,7 @@ static void shadow_walk_init(struct kvm_shadow_walk_iterator *iterator,
 
 static bool shadow_walk_okay(struct kvm_shadow_walk_iterator *iterator)
 {
-	if (iterator->level < PT_PAGE_TABLE_LEVEL)
+	if (iterator->level < PG_LEVEL_4K)
 		return false;
 
 	iterator->index = SHADOW_PT_INDEX(iterator->addr, iterator->level);
@@ -2721,7 +2719,7 @@ static int mmu_zap_unsync_children(struct kvm *kvm,
 	struct mmu_page_path parents;
 	struct kvm_mmu_pages pages;
 
-	if (parent->role.level == PT_PAGE_TABLE_LEVEL)
+	if (parent->role.level == PG_LEVEL_4K)
 		return 0;
 
 	while (mmu_unsync_walk(parent, &pages)) {
@@ -2920,7 +2918,7 @@ static bool mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
 		if (sp->unsync)
 			continue;
 
-		WARN_ON(sp->role.level != PT_PAGE_TABLE_LEVEL);
+		WARN_ON(sp->role.level != PG_LEVEL_4K);
 		kvm_unsync_page(vcpu, sp);
 	}
 
@@ -3019,7 +3017,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	if (!speculative)
 		spte |= spte_shadow_accessed_mask(spte);
 
-	if (level > PT_PAGE_TABLE_LEVEL && (pte_access & ACC_EXEC_MASK) &&
+	if (level > PG_LEVEL_4K && (pte_access & ACC_EXEC_MASK) &&
 	    is_nx_huge_page_enabled()) {
 		pte_access &= ~ACC_EXEC_MASK;
 	}
@@ -3032,7 +3030,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	if (pte_access & ACC_USER_MASK)
 		spte |= shadow_user_mask;
 
-	if (level > PT_PAGE_TABLE_LEVEL)
+	if (level > PG_LEVEL_4K)
 		spte |= PT_PAGE_SIZE_MASK;
 	if (tdp_enabled)
 		spte |= kvm_x86_ops.get_mt_mask(vcpu, gfn,
@@ -3102,8 +3100,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		 * If we overwrite a PTE page pointer with a 2MB PMD, unlink
 		 * the parent of the now unreachable PTE.
 		 */
-		if (level > PT_PAGE_TABLE_LEVEL &&
-		    !is_large_pte(*sptep)) {
+		if (level > PG_LEVEL_4K && !is_large_pte(*sptep)) {
 			struct kvm_mmu_page *child;
 			u64 pte = *sptep;
 
@@ -3227,7 +3224,7 @@ static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
 	if (sp_ad_disabled(sp))
 		return;
 
-	if (sp->role.level > PT_PAGE_TABLE_LEVEL)
+	if (sp->role.level > PG_LEVEL_4K)
 		return;
 
 	__direct_pte_prefetch(vcpu, sp, sptep);
@@ -3240,12 +3237,8 @@ static int host_pfn_mapping_level(struct kvm_vcpu *vcpu, gfn_t gfn,
 	pte_t *pte;
 	int level;
 
-	BUILD_BUG_ON(PT_PAGE_TABLE_LEVEL != (int)PG_LEVEL_4K ||
-		     PT_DIRECTORY_LEVEL != (int)PG_LEVEL_2M ||
-		     PT_PDPE_LEVEL != (int)PG_LEVEL_1G);
-
 	if (!PageCompound(pfn_to_page(pfn)) && !kvm_is_zone_device_pfn(pfn))
-		return PT_PAGE_TABLE_LEVEL;
+		return PG_LEVEL_4K;
 
 	/*
 	 * Note, using the already-retrieved memslot and __gfn_to_hva_memslot()
@@ -3259,7 +3252,7 @@ static int host_pfn_mapping_level(struct kvm_vcpu *vcpu, gfn_t gfn,
 
 	pte = lookup_address_in_mm(vcpu->kvm->mm, hva, &level);
 	if (unlikely(!pte))
-		return PT_PAGE_TABLE_LEVEL;
+		return PG_LEVEL_4K;
 
 	return level;
 }
@@ -3273,28 +3266,28 @@ static int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
 	kvm_pfn_t mask;
 	int level;
 
-	if (unlikely(max_level == PT_PAGE_TABLE_LEVEL))
-		return PT_PAGE_TABLE_LEVEL;
+	if (unlikely(max_level == PG_LEVEL_4K))
+		return PG_LEVEL_4K;
 
 	if (is_error_noslot_pfn(pfn) || kvm_is_reserved_pfn(pfn))
-		return PT_PAGE_TABLE_LEVEL;
+		return PG_LEVEL_4K;
 
 	slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn, true);
 	if (!slot)
-		return PT_PAGE_TABLE_LEVEL;
+		return PG_LEVEL_4K;
 
 	max_level = min(max_level, max_page_level);
-	for ( ; max_level > PT_PAGE_TABLE_LEVEL; max_level--) {
+	for ( ; max_level > PG_LEVEL_4K; max_level--) {
 		linfo = lpage_info_slot(gfn, slot, max_level);
 		if (!linfo->disallow_lpage)
 			break;
 	}
 
-	if (max_level == PT_PAGE_TABLE_LEVEL)
-		return PT_PAGE_TABLE_LEVEL;
+	if (max_level == PG_LEVEL_4K)
+		return PG_LEVEL_4K;
 
 	level = host_pfn_mapping_level(vcpu, gfn, pfn, slot);
-	if (level == PT_PAGE_TABLE_LEVEL)
+	if (level == PG_LEVEL_4K)
 		return level;
 
 	level = min(level, max_level);
@@ -3316,7 +3309,7 @@ static void disallowed_hugepage_adjust(struct kvm_shadow_walk_iterator it,
 	int level = *levelp;
 	u64 spte = *it.sptep;
 
-	if (it.level == level && level > PT_PAGE_TABLE_LEVEL &&
+	if (it.level == level && level > PG_LEVEL_4K &&
 	    is_nx_huge_page_enabled() &&
 	    is_shadow_present_pte(spte) &&
 	    !is_large_pte(spte)) {
@@ -3573,7 +3566,7 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			 *
 			 * See the comments in kvm_arch_commit_memory_region().
 			 */
-			if (sp->role.level > PT_PAGE_TABLE_LEVEL)
+			if (sp->role.level > PG_LEVEL_4K)
 				break;
 		}
 
@@ -4132,7 +4125,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		return r;
 
 	if (lpage_disallowed)
-		max_level = PT_PAGE_TABLE_LEVEL;
+		max_level = PG_LEVEL_4K;
 
 	if (fast_page_fault(vcpu, gpa, error_code))
 		return RET_PF_RETRY;
@@ -4168,7 +4161,7 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa,
 
 	/* This path builds a PAE pagetable, we can map 2mb pages at maximum. */
 	return direct_page_fault(vcpu, gpa & PAGE_MASK, error_code, prefault,
-				 PT_DIRECTORY_LEVEL, false);
+				 PG_LEVEL_2M, false);
 }
 
 int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
@@ -4215,7 +4208,7 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	int max_level;
 
 	for (max_level = KVM_MAX_HUGEPAGE_LEVEL;
-	     max_level > PT_PAGE_TABLE_LEVEL;
+	     max_level > PG_LEVEL_4K;
 	     max_level--) {
 		int page_num = KVM_PAGES_PER_HPAGE(max_level);
 		gfn_t base = (gpa >> PAGE_SHIFT) & ~(page_num - 1);
@@ -4376,11 +4369,11 @@ static inline bool is_last_gpte(struct kvm_mmu *mmu,
 	gpte &= level - mmu->last_nonleaf_level;
 
 	/*
-	 * PT_PAGE_TABLE_LEVEL always terminates.  The RHS has bit 7 set
-	 * iff level <= PT_PAGE_TABLE_LEVEL, which for our purpose means
-	 * level == PT_PAGE_TABLE_LEVEL; set PT_PAGE_SIZE_MASK in gpte then.
+	 * PG_LEVEL_4K always terminates.  The RHS has bit 7 set
+	 * iff level <= PG_LEVEL_4K, which for our purpose means
+	 * level == PG_LEVEL_4K; set PT_PAGE_SIZE_MASK in gpte then.
 	 */
-	gpte |= level - PT_PAGE_TABLE_LEVEL - 1;
+	gpte |= level - PG_LEVEL_4K - 1;
 
 	return gpte & PT_PAGE_SIZE_MASK;
 }
@@ -5193,7 +5186,7 @@ static void mmu_pte_write_new_pte(struct kvm_vcpu *vcpu,
 				  struct kvm_mmu_page *sp, u64 *spte,
 				  const void *new)
 {
-	if (sp->role.level != PT_PAGE_TABLE_LEVEL) {
+	if (sp->role.level != PG_LEVEL_4K) {
 		++vcpu->kvm->stat.mmu_pde_zapped;
 		return;
         }
@@ -5251,7 +5244,7 @@ static bool detect_write_flooding(struct kvm_mmu_page *sp)
 	 * Skip write-flooding detected for the sp whose level is 1, because
 	 * it can become unsync, then the guest page is not write-protected.
 	 */
-	if (sp->role.level == PT_PAGE_TABLE_LEVEL)
+	if (sp->role.level == PG_LEVEL_4K)
 		return false;
 
 	atomic_inc(&sp->write_flooding_count);
@@ -5582,9 +5575,9 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_page_level)
 	if (tdp_enabled)
 		max_page_level = tdp_page_level;
 	else if (boot_cpu_has(X86_FEATURE_GBPAGES))
-		max_page_level = PT_PDPE_LEVEL;
+		max_page_level = PG_LEVEL_1G;
 	else
-		max_page_level = PT_DIRECTORY_LEVEL;
+		max_page_level = PG_LEVEL_2M;
 }
 EXPORT_SYMBOL_GPL(kvm_configure_mmu);
 
@@ -5640,7 +5633,7 @@ static __always_inline bool
 slot_handle_all_level(struct kvm *kvm, struct kvm_memory_slot *memslot,
 		      slot_level_handler fn, bool lock_flush_tlb)
 {
-	return slot_handle_level(kvm, memslot, fn, PT_PAGE_TABLE_LEVEL,
+	return slot_handle_level(kvm, memslot, fn, PG_LEVEL_4K,
 				 KVM_MAX_HUGEPAGE_LEVEL, lock_flush_tlb);
 }
 
@@ -5648,7 +5641,7 @@ static __always_inline bool
 slot_handle_large_level(struct kvm *kvm, struct kvm_memory_slot *memslot,
 			slot_level_handler fn, bool lock_flush_tlb)
 {
-	return slot_handle_level(kvm, memslot, fn, PT_PAGE_TABLE_LEVEL + 1,
+	return slot_handle_level(kvm, memslot, fn, PG_LEVEL_4K + 1,
 				 KVM_MAX_HUGEPAGE_LEVEL, lock_flush_tlb);
 }
 
@@ -5656,8 +5649,8 @@ static __always_inline bool
 slot_handle_leaf(struct kvm *kvm, struct kvm_memory_slot *memslot,
 		 slot_level_handler fn, bool lock_flush_tlb)
 {
-	return slot_handle_level(kvm, memslot, fn, PT_PAGE_TABLE_LEVEL,
-				 PT_PAGE_TABLE_LEVEL, lock_flush_tlb);
+	return slot_handle_level(kvm, memslot, fn, PG_LEVEL_4K,
+				 PG_LEVEL_4K, lock_flush_tlb);
 }
 
 static void free_mmu_pages(struct kvm_mmu *mmu)
@@ -5867,7 +5860,7 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 				continue;
 
 			slot_handle_level_range(kvm, memslot, kvm_zap_rmapp,
-						PT_PAGE_TABLE_LEVEL,
+						PG_LEVEL_4K,
 						KVM_MAX_HUGEPAGE_LEVEL,
 						start, end - 1, true);
 		}
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index ddc1ec3bdacd..a7bcde34d1f2 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -61,7 +61,7 @@ static void update_gfn_track(struct kvm_memory_slot *slot, gfn_t gfn,
 {
 	int index, val;
 
-	index = gfn_to_index(gfn, slot->base_gfn, PT_PAGE_TABLE_LEVEL);
+	index = gfn_to_index(gfn, slot->base_gfn, PG_LEVEL_4K);
 
 	val = slot->arch.gfn_track[mode][index];
 
@@ -151,7 +151,7 @@ bool kvm_page_track_is_active(struct kvm_vcpu *vcpu, gfn_t gfn,
 	if (!slot)
 		return false;
 
-	index = gfn_to_index(gfn, slot->base_gfn, PT_PAGE_TABLE_LEVEL);
+	index = gfn_to_index(gfn, slot->base_gfn, PG_LEVEL_4K);
 	return !!READ_ONCE(slot->arch.gfn_track[mode][index]);
 }
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index ca39bd315f70..38c576495048 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -75,7 +75,7 @@
 #define PT_GUEST_ACCESSED_MASK (1 << PT_GUEST_ACCESSED_SHIFT)
 
 #define gpte_to_gfn_lvl FNAME(gpte_to_gfn_lvl)
-#define gpte_to_gfn(pte) gpte_to_gfn_lvl((pte), PT_PAGE_TABLE_LEVEL)
+#define gpte_to_gfn(pte) gpte_to_gfn_lvl((pte), PG_LEVEL_4K)
 
 /*
  * The guest_walker structure emulates the behavior of the hardware page
@@ -198,7 +198,7 @@ static bool FNAME(prefetch_invalid_gpte)(struct kvm_vcpu *vcpu,
 	    !(gpte & PT_GUEST_ACCESSED_MASK))
 		goto no_present;
 
-	if (FNAME(is_rsvd_bits_set)(vcpu->arch.mmu, gpte, PT_PAGE_TABLE_LEVEL))
+	if (FNAME(is_rsvd_bits_set)(vcpu->arch.mmu, gpte, PG_LEVEL_4K))
 		goto no_present;
 
 	return false;
@@ -436,7 +436,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	gfn = gpte_to_gfn_lvl(pte, walker->level);
 	gfn += (addr & PT_LVL_OFFSET_MASK(walker->level)) >> PAGE_SHIFT;
 
-	if (PTTYPE == 32 && walker->level > PT_PAGE_TABLE_LEVEL && is_cpuid_PSE36())
+	if (PTTYPE == 32 && walker->level > PG_LEVEL_4K && is_cpuid_PSE36())
 		gfn += pse36_gfn_delta(pte);
 
 	real_gpa = mmu->translate_gpa(vcpu, gfn_to_gpa(gfn), access, &walker->fault);
@@ -552,7 +552,7 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	 * we call mmu_set_spte() with host_writable = true because
 	 * pte_prefetch_gfn_to_pfn always gets a writable pfn.
 	 */
-	mmu_set_spte(vcpu, spte, pte_access, 0, PT_PAGE_TABLE_LEVEL, gfn, pfn,
+	mmu_set_spte(vcpu, spte, pte_access, 0, PG_LEVEL_4K, gfn, pfn,
 		     true, true);
 
 	kvm_release_pfn_clean(pfn);
@@ -575,7 +575,7 @@ static bool FNAME(gpte_changed)(struct kvm_vcpu *vcpu,
 	u64 mask;
 	int r, index;
 
-	if (level == PT_PAGE_TABLE_LEVEL) {
+	if (level == PG_LEVEL_4K) {
 		mask = PTE_PREFETCH_NUM * sizeof(pt_element_t) - 1;
 		base_gpa = pte_gpa & ~mask;
 		index = (pte_gpa - base_gpa) / sizeof(pt_element_t);
@@ -600,7 +600,7 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
 
 	sp = page_header(__pa(sptep));
 
-	if (sp->role.level > PT_PAGE_TABLE_LEVEL)
+	if (sp->role.level > PG_LEVEL_4K)
 		return;
 
 	if (sp->role.direct)
@@ -828,7 +828,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	      &walker, user_fault, &vcpu->arch.write_fault_to_shadow_pgtable);
 
 	if (lpage_disallowed || is_self_change_mapping)
-		max_level = PT_PAGE_TABLE_LEVEL;
+		max_level = PG_LEVEL_4K;
 	else
 		max_level = walker.level;
 
@@ -884,7 +884,7 @@ static gpa_t FNAME(get_level1_sp_gpa)(struct kvm_mmu_page *sp)
 {
 	int offset = 0;
 
-	WARN_ON(sp->role.level != PT_PAGE_TABLE_LEVEL);
+	WARN_ON(sp->role.level != PG_LEVEL_4K);
 
 	if (PTTYPE == 32)
 		offset = sp->role.quadrant << PT64_LEVEL_BITS;
@@ -1070,7 +1070,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		host_writable = sp->spt[i] & SPTE_HOST_WRITEABLE;
 
 		set_spte_ret |= set_spte(vcpu, &sp->spt[i],
-					 pte_access, PT_PAGE_TABLE_LEVEL,
+					 pte_access, PG_LEVEL_4K,
 					 gfn, spte_to_pfn(sp->spt[i]),
 					 true, false, host_writable);
 	}
diff --git a/arch/x86/kvm/mmu_audit.c b/arch/x86/kvm/mmu_audit.c
index ca39f62aabc6..9d2844f87f6d 100644
--- a/arch/x86/kvm/mmu_audit.c
+++ b/arch/x86/kvm/mmu_audit.c
@@ -100,7 +100,7 @@ static void audit_mappings(struct kvm_vcpu *vcpu, u64 *sptep, int level)
 	sp = page_header(__pa(sptep));
 
 	if (sp->unsync) {
-		if (level != PT_PAGE_TABLE_LEVEL) {
+		if (level != PG_LEVEL_4K) {
 			audit_printk(vcpu->kvm, "unsync sp: %p "
 				     "level = %d\n", sp, level);
 			return;
@@ -176,7 +176,7 @@ static void check_mappings_rmap(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	int i;
 
-	if (sp->role.level != PT_PAGE_TABLE_LEVEL)
+	if (sp->role.level != PG_LEVEL_4K)
 		return;
 
 	for (i = 0; i < PT64_ENT_PER_PAGE; ++i) {
@@ -200,7 +200,7 @@ static void audit_write_protection(struct kvm *kvm, struct kvm_mmu_page *sp)
 
 	slots = kvm_memslots_for_spte_role(kvm, sp->role);
 	slot = __gfn_to_memslot(slots, sp->gfn);
-	rmap_head = __gfn_to_rmap(sp->gfn, PT_PAGE_TABLE_LEVEL, slot);
+	rmap_head = __gfn_to_rmap(sp->gfn, PG_LEVEL_4K, slot);
 
 	for_each_rmap_spte(rmap_head, &iter, sptep) {
 		if (is_writable_pte(*sptep))
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8f8fc65bfa3e..ee8756ef8543 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -891,7 +891,7 @@ static __init int svm_hardware_setup(void)
 	if (npt_enabled && !npt)
 		npt_enabled = false;
 
-	kvm_configure_mmu(npt_enabled, PT_PDPE_LEVEL);
+	kvm_configure_mmu(npt_enabled, PG_LEVEL_1G);
 	pr_info("kvm: Nested Paging %sabled\n", npt_enabled ? "en" : "dis");
 
 	if (nrips) {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3ab6ca6062ce..c84de7b6eda5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8002,11 +8002,11 @@ static __init int hardware_setup(void)
 	if (!enable_ept)
 		ept_lpage_level = 0;
 	else if (cpu_has_vmx_ept_1g_page())
-		ept_lpage_level = PT_PDPE_LEVEL;
+		ept_lpage_level = PG_LEVEL_1G;
 	else if (cpu_has_vmx_ept_2m_page())
-		ept_lpage_level = PT_DIRECTORY_LEVEL;
+		ept_lpage_level = PG_LEVEL_2M;
 	else
-		ept_lpage_level = PT_PAGE_TABLE_LEVEL;
+		ept_lpage_level = PG_LEVEL_4K;
 	kvm_configure_mmu(enable_ept, ept_lpage_level);
 
 	/*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 856b6fc2c2ba..0df27e578705 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10017,7 +10017,7 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 {
 	/* Still write protect RO slot */
 	if (new->flags & KVM_MEM_READONLY) {
-		kvm_mmu_slot_remove_write_access(kvm, new, PT_PAGE_TABLE_LEVEL);
+		kvm_mmu_slot_remove_write_access(kvm, new, PG_LEVEL_4K);
 		return;
 	}
 
@@ -10057,7 +10057,7 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 		} else {
 			int level =
 				kvm_dirty_log_manual_protect_and_init_set(kvm) ?
-				PT_DIRECTORY_LEVEL : PT_PAGE_TABLE_LEVEL;
+				PG_LEVEL_2M : PG_LEVEL_4K;
 
 			/*
 			 * If we're with initial-all-set, we don't need
-- 
2.26.0

