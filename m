Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 878882B4F77
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388516AbgKPS3u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:29:50 -0500
Received: from mga06.intel.com ([134.134.136.31]:20649 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388222AbgKPS2P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:28:15 -0500
IronPort-SDR: 2rxnuFspw0Qi4BKqa3IifUxLHHsBDFusgWRMF3jrCesNzaDix7NzDcuLpy8irQ0bzCBaRcYEEp
 r0ww239Li6vQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="232410058"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="232410058"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:11 -0800
IronPort-SDR: 3UtirH/84+e6dvcSYrCP+yRqlh1ZjkSE1JXgMa/E8+gzeH3z1qiCTBbEhC5MglwiZuCnN83dy5
 eUzgkP7swLNg==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400528173"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:11 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH 41/67] KVM: x86/mmu: Frame in support for private/inaccessible shadow pages
Date:   Mon, 16 Nov 2020 10:26:26 -0800
Message-Id: <c18d4561104de20ff78e00385032aeb8f1d5eb23.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add kvm_x86_ops hooks to set/clear private SPTEs, i.e. SEPT entries, and
to link/free private shadow pages, i.e. non-leaf SEPT pages.

Because SEAMCALLs are bloody expensive, and because KVM's MMU is already
complex enough, TDX's SEPT will mirror KVM's shadow pages instead of
replacing them outright.  This costs extra memory, but is simpler and
far more performant.

Add a separate list for tracking active private shadow pages.  Zapping
and freeing SEPT entries is subject to very different rules than normal
pages/memory, and need to be preserved (along with their shadow page
counterparts) when KVM gets trigger happy, e.g. zaps everything during a
memslot update.

Zap any aliases of a GPA when mapping in a guest that supports guest
private GPAs.  This is necessary to avoid integrity failures with TDX
due to pointing shared and private GPAs at the same HPA.

Do not prefetch private pages (this should probably be a property of the
VM).

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  23 ++-
 arch/x86/kvm/mmu.h              |   3 +-
 arch/x86/kvm/mmu/mmu.c          | 270 +++++++++++++++++++++++++++-----
 arch/x86/kvm/mmu/mmu_internal.h |   4 +
 arch/x86/kvm/mmu/spte.h         |  11 +-
 arch/x86/kvm/x86.c              |   4 +-
 6 files changed, 269 insertions(+), 46 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d4fd9859fcd5..9f7349aa3c77 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -361,6 +361,7 @@ struct kvm_mmu {
 	void (*update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 			   u64 *spte, const void *pte);
 	hpa_t root_hpa;
+	hpa_t private_root_hpa;
 	gpa_t root_pgd;
 	union kvm_mmu_role mmu_role;
 	u8 root_level;
@@ -595,6 +596,7 @@ struct kvm_vcpu_arch {
 	struct kvm_mmu_memory_cache mmu_shadow_page_cache;
 	struct kvm_mmu_memory_cache mmu_gfn_array_cache;
 	struct kvm_mmu_memory_cache mmu_page_header_cache;
+	struct kvm_mmu_memory_cache mmu_private_sp_cache;
 
 	/*
 	 * QEMU userspace and the guest each have their own FPU state.
@@ -910,6 +912,7 @@ struct kvm_arch {
 	 * Hash table of struct kvm_mmu_page.
 	 */
 	struct list_head active_mmu_pages;
+	struct list_head private_mmu_pages;
 	struct list_head zapped_obsolete_pages;
 	struct list_head lpage_disallowed_mmu_pages;
 	struct kvm_page_track_notifier_node mmu_sp_tracker;
@@ -1020,6 +1023,8 @@ struct kvm_arch {
 	struct list_head tdp_mmu_roots;
 	/* List of struct tdp_mmu_pages not being used as roots */
 	struct list_head tdp_mmu_pages;
+
+	gfn_t gfn_shared_mask;
 };
 
 struct kvm_vm_stat {
@@ -1199,6 +1204,17 @@ struct kvm_x86_ops {
 	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, unsigned long pgd,
 			     int pgd_level);
 
+	void (*set_private_spte)(struct kvm_vcpu *vcpu, gfn_t gfn, int level,
+				 kvm_pfn_t pfn);
+	void (*drop_private_spte)(struct kvm *kvm, gfn_t gfn, int level,
+				  kvm_pfn_t pfn);
+	void (*zap_private_spte)(struct kvm *kvm, gfn_t gfn, int level);
+	void (*unzap_private_spte)(struct kvm *kvm, gfn_t gfn, int level);
+	int (*link_private_sp)(struct kvm_vcpu *vcpu, gfn_t gfn, int level,
+			       void *private_sp);
+	int (*free_private_sp)(struct kvm *kvm, gfn_t gfn, int level,
+			       void *private_sp);
+
 	bool (*has_wbinvd_exit)(void);
 
 	/* Returns actual tsc_offset set in active VMCS */
@@ -1378,7 +1394,8 @@ void kvm_mmu_slot_set_dirty(struct kvm *kvm,
 void kvm_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 				   struct kvm_memory_slot *slot,
 				   gfn_t gfn_offset, unsigned long mask);
-void kvm_mmu_zap_all(struct kvm *kvm);
+void kvm_mmu_zap_all_active(struct kvm *kvm);
+void kvm_mmu_zap_all_private(struct kvm *kvm);
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen);
 unsigned long kvm_mmu_calculate_default_mmu_pages(struct kvm *kvm);
 void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long kvm_nr_mmu_pages);
@@ -1532,7 +1549,9 @@ static inline int __kvm_irq_line_state(unsigned long *irq_state,
 
 #define KVM_MMU_ROOT_CURRENT		BIT(0)
 #define KVM_MMU_ROOT_PREVIOUS(i)	BIT(1+i)
-#define KVM_MMU_ROOTS_ALL		(~0UL)
+#define KVM_MMU_ROOT_PRIVATE		BIT(1+KVM_MMU_NUM_PREV_ROOTS)
+#define KVM_MMU_ROOTS_ALL		((u32)(~KVM_MMU_ROOT_PRIVATE))
+#define KVM_MMU_ROOTS_ALL_INC_PRIVATE	(KVM_MMU_ROOTS_ALL | KVM_MMU_ROOT_PRIVATE)
 
 int kvm_pic_set_irq(struct kvm_pic *pic, int irq, int irq_source_id, int level);
 void kvm_pic_clear_all(struct kvm_pic *pic, int irq_source_id);
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index e9598a51090b..3b1243cfc280 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -225,8 +225,7 @@ void kvm_mmu_pre_destroy_vm(struct kvm *kvm);
 
 static inline gfn_t kvm_gfn_stolen_mask(struct kvm *kvm)
 {
-	/* Currently there are no stolen bits in KVM */
-	return 0;
+	return kvm->arch.gfn_shared_mask;
 }
 
 static inline gfn_t vcpu_gfn_stolen_mask(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8d847c3abf1d..e4e0c883b52d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -554,15 +554,15 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
  * state bits, it is used to clear the last level sptep.
  * Returns the old PTE.
  */
-static u64 mmu_spte_clear_track_bits(u64 *sptep)
+static u64 __mmu_spte_clear_track_bits(u64 *sptep, u64 clear_value)
 {
 	kvm_pfn_t pfn;
 	u64 old_spte = *sptep;
 
 	if (!spte_has_volatile_bits(old_spte))
-		__update_clear_spte_fast(sptep, shadow_init_value);
+		__update_clear_spte_fast(sptep, clear_value);
 	else
-		old_spte = __update_clear_spte_slow(sptep, shadow_init_value);
+		old_spte = __update_clear_spte_slow(sptep, clear_value);
 
 	if (!is_shadow_present_pte(old_spte))
 		return old_spte;
@@ -585,6 +585,11 @@ static u64 mmu_spte_clear_track_bits(u64 *sptep)
 	return old_spte;
 }
 
+static inline u64 mmu_spte_clear_track_bits(u64 *sptep)
+{
+	return __mmu_spte_clear_track_bits(sptep, shadow_init_value);
+}
+
 /*
  * Rules for using mmu_spte_clear_no_track:
  * Directly clear spte without caring the state bits of sptep,
@@ -691,6 +696,13 @@ static int mmu_topup_shadow_page_cache(struct kvm_vcpu *vcpu)
 	struct kvm_mmu_memory_cache *mc = &vcpu->arch.mmu_shadow_page_cache;
 	int start, end, i, r;
 
+	if (vcpu->kvm->arch.gfn_shared_mask) {
+		r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_private_sp_cache,
+					       PT64_ROOT_MAX_LEVEL);
+		if (r)
+			return r;
+	}
+
 	if (shadow_init_value)
 		start = kvm_mmu_memory_cache_nr_free_objects(mc);
 
@@ -732,6 +744,7 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 {
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
+	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_private_sp_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_gfn_array_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
 }
@@ -874,6 +887,23 @@ gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu, gfn_t gfn,
 	return slot;
 }
 
+static inline bool __is_private_gfn(struct kvm *kvm, gfn_t gfn_stolen_bits)
+{
+	gfn_t gfn_shared_mask = kvm->arch.gfn_shared_mask;
+
+	return gfn_shared_mask && !(gfn_shared_mask & gfn_stolen_bits);
+}
+
+static inline bool is_private_gfn(struct kvm_vcpu *vcpu, gfn_t gfn_stolen_bits)
+{
+	return __is_private_gfn(vcpu->kvm, gfn_stolen_bits);
+}
+
+static inline bool is_private_spte(struct kvm *kvm, u64 *sptep)
+{
+	return __is_private_gfn(kvm, sptep_to_sp(sptep)->gfn);
+}
+
 /*
  * About rmap_head encoding:
  *
@@ -1023,7 +1053,7 @@ static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 	return pte_list_add(vcpu, spte, rmap_head);
 }
 
-static void rmap_remove(struct kvm *kvm, u64 *spte)
+static void rmap_remove(struct kvm *kvm, u64 *spte, u64 old_spte)
 {
 	struct kvm_mmu_page *sp;
 	gfn_t gfn;
@@ -1033,6 +1063,10 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 	gfn = kvm_mmu_page_get_gfn(sp, spte - sp->spt);
 	rmap_head = gfn_to_rmap(kvm, gfn, sp);
 	__pte_list_remove(spte, rmap_head);
+
+	if (__is_private_gfn(kvm, sp->gfn_stolen_bits))
+		kvm_x86_ops.drop_private_spte(kvm, gfn, sp->role.level - 1,
+					      spte_to_pfn(old_spte));
 }
 
 /*
@@ -1070,7 +1104,8 @@ static u64 *rmap_get_first(struct kvm_rmap_head *rmap_head,
 	iter->pos = 0;
 	sptep = iter->desc->sptes[iter->pos];
 out:
-	BUG_ON(!is_shadow_present_pte(*sptep));
+	BUG_ON(!is_shadow_present_pte(*sptep) &&
+	       !is_zapped_private_pte(*sptep));
 	return sptep;
 }
 
@@ -1115,8 +1150,9 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
 {
 	u64 old_spte = mmu_spte_clear_track_bits(sptep);
 
-	if (is_shadow_present_pte(old_spte))
-		rmap_remove(kvm, sptep);
+	if (is_shadow_present_pte(old_spte) ||
+	    is_zapped_private_pte(old_spte))
+		rmap_remove(kvm, sptep, old_spte);
 }
 
 
@@ -1364,17 +1400,51 @@ static bool rmap_write_protect(struct kvm_vcpu *vcpu, u64 gfn)
 	return kvm_mmu_slot_gfn_write_protect(vcpu->kvm, slot, gfn);
 }
 
+static bool kvm_mmu_zap_private_spte(struct kvm *kvm, u64 *sptep)
+{
+	struct kvm_mmu_page *sp;
+	kvm_pfn_t pfn;
+	gfn_t gfn;
+
+	/* Skip the lookup if the VM doesn't support private memory. */
+	if (likely(!kvm->arch.gfn_shared_mask))
+		return false;
+
+	sp = sptep_to_sp(sptep);
+	if (!__is_private_gfn(kvm, sp->gfn_stolen_bits))
+		return false;
+
+	gfn = kvm_mmu_page_get_gfn(sp, sptep - sp->spt);
+	pfn = spte_to_pfn(*sptep);
+
+	kvm_x86_ops.zap_private_spte(kvm, gfn, sp->role.level - 1);
+
+	__mmu_spte_clear_track_bits(sptep,
+				    SPTE_PRIVATE_ZAPPED | pfn << PAGE_SHIFT);
+	return true;
+}
+
 static bool kvm_zap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head)
 {
 	u64 *sptep;
 	struct rmap_iterator iter;
 	bool flush = false;
 
-	while ((sptep = rmap_get_first(rmap_head, &iter))) {
+restart:
+	for_each_rmap_spte(rmap_head, &iter, sptep) {
 		rmap_printk("%s: spte %p %llx.\n", __func__, sptep, *sptep);
 
-		pte_list_remove(rmap_head, sptep);
+		if (is_zapped_private_pte(*sptep))
+			continue;
+
 		flush = true;
+
+		/* Keep the rmap if the private SPTE couldn't be zapped. */
+		if (kvm_mmu_zap_private_spte(kvm, sptep))
+			continue;
+
+		pte_list_remove(rmap_head, sptep);
+		goto restart;
 	}
 
 	return flush;
@@ -1408,6 +1478,9 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 
 		need_flush = 1;
 
+		/* Private page relocation is not yet supported. */
+		KVM_BUG_ON(is_private_spte(kvm, sptep), kvm);
+
 		if (pte_write(*ptep)) {
 			pte_list_remove(rmap_head, sptep);
 			goto restart;
@@ -1673,7 +1746,7 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, unsigned long nr)
 	percpu_counter_add(&kvm_total_used_mmu_pages, nr);
 }
 
-static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
+static void kvm_mmu_free_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	MMU_WARN_ON(!is_empty_shadow_page(sp->spt));
 	hlist_del(&sp->hash_link);
@@ -1681,6 +1754,11 @@ static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
 	free_page((unsigned long)sp->spt);
 	if (!sp->role.direct)
 		free_page((unsigned long)sp->gfns);
+	if (sp->private_sp &&
+	    !kvm_x86_ops.free_private_sp(kvm, sp->gfn, sp->role.level,
+					 sp->private_sp))
+		free_page((unsigned long)sp->private_sp);
+
 	kmem_cache_free(mmu_page_header_cache, sp);
 }
 
@@ -1711,7 +1789,8 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
 	mmu_spte_clear_no_track(parent_pte);
 }
 
-static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct)
+static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
+					       int direct, bool private)
 {
 	struct kvm_mmu_page *sp;
 
@@ -1727,7 +1806,10 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct
 	 * comments in kvm_zap_obsolete_pages().
 	 */
 	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
-	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
+	if (private)
+		list_add(&sp->link, &vcpu->kvm->arch.private_mmu_pages);
+	else
+		list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
 	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
 	return sp;
 }
@@ -2146,7 +2228,8 @@ static struct kvm_mmu_page *__kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 
 	++vcpu->kvm->stat.mmu_cache_miss;
 
-	sp = kvm_mmu_alloc_page(vcpu, direct);
+	sp = kvm_mmu_alloc_page(vcpu, direct,
+				is_private_gfn(vcpu, gfn_stolen_bits));
 
 	sp->gfn = gfn;
 	sp->gfn_stolen_bits = gfn_stolen_bits;
@@ -2213,8 +2296,13 @@ static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterato
 static void shadow_walk_init(struct kvm_shadow_walk_iterator *iterator,
 			     struct kvm_vcpu *vcpu, u64 addr)
 {
-	shadow_walk_init_using_root(iterator, vcpu, vcpu->arch.mmu->root_hpa,
-				    addr);
+	hpa_t root;
+
+	if (is_private_gfn(vcpu, addr >> PAGE_SHIFT))
+		root = vcpu->arch.mmu->private_root_hpa;
+	else
+		root = vcpu->arch.mmu->root_hpa;
+	shadow_walk_init_using_root(iterator, vcpu, root, addr);
 }
 
 static bool shadow_walk_okay(struct kvm_shadow_walk_iterator *iterator)
@@ -2291,7 +2379,7 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 	struct kvm_mmu_page *child;
 
 	pte = *spte;
-	if (is_shadow_present_pte(pte)) {
+	if (is_shadow_present_pte(pte) || is_zapped_private_pte(pte)) {
 		if (is_last_spte(pte, sp->role.level)) {
 			drop_spte(kvm, spte);
 			if (is_large_pte(pte))
@@ -2300,6 +2388,9 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 			child = to_shadow_page(pte & PT64_BASE_ADDR_MASK);
 			drop_parent_pte(child, spte);
 
+			if (!is_shadow_present_pte(pte))
+				return 0;
+
 			/*
 			 * Recursively zap nested TDP SPs, parentless SPs are
 			 * unlikely to be used again in the near future.  This
@@ -2450,7 +2541,7 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 
 	list_for_each_entry_safe(sp, nsp, invalid_list, link) {
 		WARN_ON(!sp->role.invalid || sp->root_count);
-		kvm_mmu_free_page(sp);
+		kvm_mmu_free_page(kvm, sp);
 	}
 }
 
@@ -2663,29 +2754,33 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	int set_spte_ret;
 	int ret = RET_PF_FIXED;
 	bool flush = false;
+	u64 pte = *sptep;
 
 	pgprintk("%s: spte %llx write_fault %d gfn %llx\n", __func__,
 		 *sptep, write_fault, gfn);
 
-	if (is_shadow_present_pte(*sptep)) {
+	if (is_shadow_present_pte(pte)) {
 		/*
 		 * If we overwrite a PTE page pointer with a 2MB PMD, unlink
 		 * the parent of the now unreachable PTE.
 		 */
-		if (level > PG_LEVEL_4K && !is_large_pte(*sptep)) {
+		if (level > PG_LEVEL_4K && !is_large_pte(pte)) {
 			struct kvm_mmu_page *child;
-			u64 pte = *sptep;
 
 			child = to_shadow_page(pte & PT64_BASE_ADDR_MASK);
 			drop_parent_pte(child, sptep);
 			flush = true;
-		} else if (pfn != spte_to_pfn(*sptep)) {
+		} else if (pfn != spte_to_pfn(pte)) {
 			pgprintk("hfn old %llx new %llx\n",
-				 spte_to_pfn(*sptep), pfn);
+				 spte_to_pfn(pte), pfn);
 			drop_spte(vcpu->kvm, sptep);
 			flush = true;
 		} else
 			was_rmapped = 1;
+	} else if (is_zapped_private_pte(pte)) {
+		WARN_ON(pfn != spte_to_pfn(pte));
+		ret = RET_PF_UNZAPPED;
+		was_rmapped = 1;
 	}
 
 	set_spte_ret = set_spte(vcpu, sptep, pte_access, level, gfn, pfn,
@@ -2918,6 +3013,53 @@ void disallowed_hugepage_adjust(u64 spte, gfn_t gfn, int cur_level,
 	}
 }
 
+static void kvm_mmu_link_private_sp(struct kvm_vcpu *vcpu,
+				    struct kvm_mmu_page *sp)
+{
+	void *p = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_private_sp_cache);
+
+	if (!kvm_x86_ops.link_private_sp(vcpu, sp->gfn, sp->role.level, p))
+		sp->private_sp = p;
+	else
+		free_page((unsigned long)p);
+}
+
+static void kvm_mmu_zap_alias_spte(struct kvm_vcpu *vcpu, gfn_t gfn,
+				   gpa_t gpa_alias)
+{
+	struct kvm_shadow_walk_iterator it;
+	struct kvm_rmap_head *rmap_head;
+	struct kvm *kvm = vcpu->kvm;
+	struct rmap_iterator iter;
+	struct kvm_mmu_page *sp;
+	u64 *sptep;
+
+	for_each_shadow_entry(vcpu, gpa_alias, it) {
+		if (!is_shadow_present_pte(*it.sptep))
+			break;
+	}
+
+	sp = sptep_to_sp(it.sptep);
+	if (!is_last_spte(*it.sptep, sp->role.level))
+		return;
+
+	rmap_head = gfn_to_rmap(kvm, gfn, sp);
+	if (!kvm_zap_rmapp(kvm, rmap_head))
+		return;
+
+	kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
+
+	if (!is_private_gfn(vcpu, sp->gfn_stolen_bits))
+		return;
+
+	for_each_rmap_spte(rmap_head, &iter, sptep) {
+		if (!is_zapped_private_pte(*sptep))
+			continue;
+
+		drop_spte(kvm, sptep);
+	}
+}
+
 static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 			int map_writable, int max_level, kvm_pfn_t pfn,
 			bool prefault, bool is_tdp)
@@ -2933,10 +3075,18 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	gfn_t gfn = (gpa & ~gpa_stolen_mask) >> PAGE_SHIFT;
 	gfn_t gfn_stolen_bits = (gpa & gpa_stolen_mask) >> PAGE_SHIFT;
 	gfn_t base_gfn = gfn;
+	bool is_private = is_private_gfn(vcpu, gfn_stolen_bits);
 
 	if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa)))
 		return RET_PF_RETRY;
 
+	if (is_error_noslot_pfn(pfn) || kvm_is_reserved_pfn(pfn)) {
+		if (is_private)
+			return -EFAULT;
+	} else if (vcpu->kvm->arch.gfn_shared_mask) {
+		kvm_mmu_zap_alias_spte(vcpu, gfn, gpa ^ gpa_stolen_mask);
+	}
+
 	level = kvm_mmu_hugepage_adjust(vcpu, gfn, max_level, &pfn,
 					huge_page_disallowed, &req_level);
 
@@ -2964,6 +3114,8 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		link_shadow_page(vcpu, it.sptep, sp);
 		if (is_tdp && huge_page_disallowed && req_level >= it.level)
 			account_huge_nx_page(vcpu->kvm, sp);
+		if (is_private)
+			kvm_mmu_link_private_sp(vcpu, sp);
 	}
 
 	ret = mmu_set_spte(vcpu, it.sptep, ACC_ALL,
@@ -2972,7 +3124,12 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	if (ret == RET_PF_SPURIOUS)
 		return ret;
 
-	direct_pte_prefetch(vcpu, it.sptep);
+	if (!is_private)
+		direct_pte_prefetch(vcpu, it.sptep);
+	else if (ret == RET_PF_UNZAPPED)
+		kvm_x86_ops.unzap_private_spte(vcpu->kvm, gfn, level - 1);
+	else if (!WARN_ON_ONCE(ret != RET_PF_FIXED))
+		kvm_x86_ops.set_private_spte(vcpu, gfn, level, pfn);
 	++vcpu->stat.pf_fixed;
 	return ret;
 }
@@ -3242,7 +3399,9 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			    VALID_PAGE(mmu->prev_roots[i].hpa))
 				break;
 
-		if (i == KVM_MMU_NUM_PREV_ROOTS)
+		if (i == KVM_MMU_NUM_PREV_ROOTS &&
+		    (!(roots_to_free & KVM_MMU_ROOT_PRIVATE) ||
+		     !VALID_PAGE(mmu->private_root_hpa)))
 			return;
 	}
 
@@ -3268,6 +3427,9 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 		mmu->root_pgd = 0;
 	}
 
+	if (roots_to_free & KVM_MMU_ROOT_PRIVATE)
+		mmu_free_root_page(kvm, &mmu->private_root_hpa, &invalid_list);
+
 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
 	spin_unlock(&kvm->mmu_lock);
 }
@@ -3285,8 +3447,9 @@ static int mmu_check_root(struct kvm_vcpu *vcpu, gfn_t root_gfn)
 	return ret;
 }
 
-static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, gva_t gva,
-			    u8 level, bool direct)
+static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn,
+			    gfn_t gfn_stolen_bits, gva_t gva, u8 level,
+			    bool direct)
 {
 	struct kvm_mmu_page *sp;
 
@@ -3296,7 +3459,8 @@ static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, gva_t gva,
 		spin_unlock(&vcpu->kvm->mmu_lock);
 		return INVALID_PAGE;
 	}
-	sp = kvm_mmu_get_page(vcpu, gfn, gva, level, direct, ACC_ALL);
+	sp = __kvm_mmu_get_page(vcpu, gfn, gfn_stolen_bits, gva, level, direct,
+				ACC_ALL);
 	++sp->root_count;
 
 	spin_unlock(&vcpu->kvm->mmu_lock);
@@ -3306,6 +3470,7 @@ static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, gva_t gva,
 static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 {
 	u8 shadow_root_level = vcpu->arch.mmu->shadow_root_level;
+	gfn_t gfn_shared = vcpu->kvm->arch.gfn_shared_mask;
 	hpa_t root;
 	unsigned i;
 
@@ -3316,17 +3481,23 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 			return -ENOSPC;
 		vcpu->arch.mmu->root_hpa = root;
 	} else if (shadow_root_level >= PT64_ROOT_4LEVEL) {
-		root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level,
-				      true);
-
+		if (gfn_shared && !VALID_PAGE(vcpu->arch.mmu->private_root_hpa)) {
+			root = mmu_alloc_root(vcpu, 0, 0, 0, shadow_root_level, true);
+			if (!VALID_PAGE(root))
+				return -ENOSPC;
+			vcpu->arch.mmu->private_root_hpa = root;
+		}
+		root = mmu_alloc_root(vcpu, 0, gfn_shared, 0, shadow_root_level, true);
 		if (!VALID_PAGE(root))
 			return -ENOSPC;
 		vcpu->arch.mmu->root_hpa = root;
 	} else if (shadow_root_level == PT32E_ROOT_LEVEL) {
+		WARN_ON_ONCE(gfn_shared);
+
 		for (i = 0; i < 4; ++i) {
 			MMU_WARN_ON(VALID_PAGE(vcpu->arch.mmu->pae_root[i]));
 
-			root = mmu_alloc_root(vcpu, i << (30 - PAGE_SHIFT),
+			root = mmu_alloc_root(vcpu, i << (30 - PAGE_SHIFT), 0,
 					      i << 30, PT32_ROOT_LEVEL, true);
 			if (!VALID_PAGE(root))
 				return -ENOSPC;
@@ -3362,7 +3533,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.mmu->root_level >= PT64_ROOT_4LEVEL) {
 		MMU_WARN_ON(VALID_PAGE(vcpu->arch.mmu->root_hpa));
 
-		root = mmu_alloc_root(vcpu, root_gfn, 0,
+		root = mmu_alloc_root(vcpu, root_gfn, 0, 0,
 				      vcpu->arch.mmu->shadow_root_level, false);
 		if (!VALID_PAGE(root))
 			return -ENOSPC;
@@ -3392,7 +3563,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 				return 1;
 		}
 
-		root = mmu_alloc_root(vcpu, root_gfn, i << 30,
+		root = mmu_alloc_root(vcpu, root_gfn, 0, i << 30,
 				      PT32_ROOT_LEVEL, false);
 		if (!VALID_PAGE(root))
 			return -ENOSPC;
@@ -4871,13 +5042,18 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_load);
 
-void kvm_mmu_unload(struct kvm_vcpu *vcpu)
+static void __kvm_mmu_unload(struct kvm_vcpu *vcpu, u32 roots_to_free)
 {
-	kvm_mmu_free_roots(vcpu, &vcpu->arch.root_mmu, KVM_MMU_ROOTS_ALL);
+	kvm_mmu_free_roots(vcpu, &vcpu->arch.root_mmu, roots_to_free);
 	WARN_ON(VALID_PAGE(vcpu->arch.root_mmu.root_hpa));
-	kvm_mmu_free_roots(vcpu, &vcpu->arch.guest_mmu, KVM_MMU_ROOTS_ALL);
+	kvm_mmu_free_roots(vcpu, &vcpu->arch.guest_mmu, roots_to_free);
 	WARN_ON(VALID_PAGE(vcpu->arch.guest_mmu.root_hpa));
 }
+
+void kvm_mmu_unload(struct kvm_vcpu *vcpu)
+{
+	__kvm_mmu_unload(vcpu, KVM_MMU_ROOTS_ALL);
+}
 EXPORT_SYMBOL_GPL(kvm_mmu_unload);
 
 static void mmu_pte_write_new_pte(struct kvm_vcpu *vcpu,
@@ -5354,6 +5530,7 @@ static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
 	int i;
 
 	mmu->root_hpa = INVALID_PAGE;
+	mmu->private_root_hpa = INVALID_PAGE;
 	mmu->root_pgd = 0;
 	mmu->translate_gpa = translate_gpa;
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
@@ -5640,6 +5817,9 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 		sp = sptep_to_sp(sptep);
 		pfn = spte_to_pfn(*sptep);
 
+		/* Private page dirty logging is not supported. */
+		KVM_BUG_ON(is_private_spte(kvm, sptep), kvm);
+
 		/*
 		 * We cannot do huge page mapping for indirect shadow pages,
 		 * which are found on the last rmap (level = 1) when not using
@@ -5748,7 +5928,7 @@ void kvm_mmu_slot_set_dirty(struct kvm *kvm,
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_slot_set_dirty);
 
-void kvm_mmu_zap_all(struct kvm *kvm)
+static void __kvm_mmu_zap_all(struct kvm *kvm, struct list_head *mmu_pages)
 {
 	struct kvm_mmu_page *sp, *node;
 	LIST_HEAD(invalid_list);
@@ -5756,7 +5936,7 @@ void kvm_mmu_zap_all(struct kvm *kvm)
 
 	spin_lock(&kvm->mmu_lock);
 restart:
-	list_for_each_entry_safe(sp, node, &kvm->arch.active_mmu_pages, link) {
+	list_for_each_entry_safe(sp, node, mmu_pages, link) {
 		if (WARN_ON(sp->role.invalid))
 			continue;
 		if (__kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list, &ign))
@@ -5764,7 +5944,6 @@ void kvm_mmu_zap_all(struct kvm *kvm)
 		if (cond_resched_lock(&kvm->mmu_lock))
 			goto restart;
 	}
-
 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
 
 	if (kvm->arch.tdp_mmu_enabled)
@@ -5773,6 +5952,17 @@ void kvm_mmu_zap_all(struct kvm *kvm)
 	spin_unlock(&kvm->mmu_lock);
 }
 
+void kvm_mmu_zap_all_active(struct kvm *kvm)
+{
+	__kvm_mmu_zap_all(kvm, &kvm->arch.active_mmu_pages);
+}
+
+void kvm_mmu_zap_all_private(struct kvm *kvm)
+{
+	__kvm_mmu_zap_all(kvm, &kvm->arch.private_mmu_pages);
+}
+EXPORT_SYMBOL_GPL(kvm_mmu_zap_all_private);
+
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
 {
 	WARN_ON(gen & KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS);
@@ -5992,7 +6182,7 @@ unsigned long kvm_mmu_calculate_default_mmu_pages(struct kvm *kvm)
 
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 {
-	kvm_mmu_unload(vcpu);
+	__kvm_mmu_unload(vcpu, KVM_MMU_ROOTS_ALL_INC_PRIVATE);
 	free_mmu_pages(&vcpu->arch.root_mmu);
 	free_mmu_pages(&vcpu->arch.guest_mmu);
 	mmu_free_memory_caches(vcpu);
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 4d30f1562142..f385a05d5eb7 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -41,6 +41,8 @@ struct kvm_mmu_page {
 	u64 *spt;
 	/* hold the gfn of each spte inside spt */
 	gfn_t *gfns;
+	/* associated private shadow page, e.g. SEPT page */
+	void *private_sp;
 	int root_count;          /* Currently serving as active root */
 	unsigned int unsync_children;
 	struct kvm_rmap_head parent_ptes; /* rmap pointers to parent sptes */
@@ -120,6 +122,7 @@ static inline bool kvm_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *sp)
  * RET_PF_INVALID: the spte is invalid, let the real page fault path update it.
  * RET_PF_FIXED: The faulting entry has been fixed.
  * RET_PF_SPURIOUS: The faulting entry was already fixed, e.g. by another vCPU.
+ * RET_PF_UNZAPPED: A private SPTE was unzapped.
  */
 enum {
 	RET_PF_RETRY = 0,
@@ -127,6 +130,7 @@ enum {
 	RET_PF_INVALID,
 	RET_PF_FIXED,
 	RET_PF_SPURIOUS,
+	RET_PF_UNZAPPED,
 };
 
 /* Bits which may be returned by set_spte() */
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index a5eab5607606..89b5fdaf165b 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -8,6 +8,9 @@
 #define PT_FIRST_AVAIL_BITS_SHIFT 10
 #define PT64_SECOND_AVAIL_BITS_SHIFT 54
 
+/* Masks that used to track metadata for not-present SPTEs. */
+#define SPTE_PRIVATE_ZAPPED	BIT_ULL(62)
+
 /*
  * The mask used to denote special SPTEs, which can be either MMIO SPTEs or
  * Access Tracking SPTEs.
@@ -176,6 +179,11 @@ static inline bool is_access_track_spte(u64 spte)
 	return !spte_ad_enabled(spte) && (spte & shadow_acc_track_mask) == 0;
 }
 
+static inline bool is_zapped_private_pte(u64 pte)
+{
+	return !!(pte & SPTE_PRIVATE_ZAPPED);
+}
+
 static inline bool __is_shadow_present_pte(u64 pte)
 {
 	/*
@@ -191,7 +199,8 @@ static inline bool __is_shadow_present_pte(u64 pte)
 
 static inline bool is_shadow_present_pte(u64 pte)
 {
-	return __is_shadow_present_pte(pte) && !is_mmio_spte(pte);
+	return __is_shadow_present_pte(pte) && !is_mmio_spte(pte) &&
+	       !is_zapped_private_pte(pte);
 }
 
 static inline int is_large_pte(u64 pte)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c233e7ef3366..f7ffb36c318c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10388,6 +10388,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	INIT_HLIST_HEAD(&kvm->arch.mask_notifier_list);
 	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
+	INIT_LIST_HEAD(&kvm->arch.private_mmu_pages);
 	INIT_LIST_HEAD(&kvm->arch.zapped_obsolete_pages);
 	INIT_LIST_HEAD(&kvm->arch.lpage_disallowed_mmu_pages);
 	INIT_LIST_HEAD(&kvm->arch.assigned_dev_head);
@@ -10771,7 +10772,8 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
-	kvm_mmu_zap_all(kvm);
+	/* Zapping private pages must be deferred until VM destruction. */
+	kvm_mmu_zap_all_active(kvm);
 }
 
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
-- 
2.17.1

