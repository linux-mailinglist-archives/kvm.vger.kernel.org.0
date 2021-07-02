Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81E423BA57C
	for <lists+kvm@lfdr.de>; Sat,  3 Jul 2021 00:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233455AbhGBWI2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 18:08:28 -0400
Received: from mga12.intel.com ([192.55.52.136]:50204 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233247AbhGBWIB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 18:08:01 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10033"; a="188472761"
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="188472761"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:28 -0700
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="642814829"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:27 -0700
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v2 46/69] KVM: x86/mmu: Frame in support for private/inaccessible shadow pages
Date:   Fri,  2 Jul 2021 15:04:52 -0700
Message-Id: <c3c52cab560fe8b089594db1abe2676c7ca7d5e3.1625186503.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625186503.git.isaku.yamahata@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

TDX needs one more bits in spte for SPTE_PRIVATE_ZAPPED. Steal 1 bit
from MMIO generation as 62 bit and re-purpose it for non-present
SPTE, SPTE_PRIVATE_ZAPPED.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |   6 +
 arch/x86/include/asm/kvm_host.h    |  24 ++-
 arch/x86/kvm/mmu.h                 |   3 +-
 arch/x86/kvm/mmu/mmu.c             | 292 ++++++++++++++++++++++++-----
 arch/x86/kvm/mmu/mmu_internal.h    |   2 +
 arch/x86/kvm/mmu/spte.h            |  16 +-
 arch/x86/kvm/x86.c                 |   4 +-
 7 files changed, 293 insertions(+), 54 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 95ae4a71cfbc..3074c1bfa3dc 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -88,6 +88,12 @@ KVM_X86_OP(set_tss_addr)
 KVM_X86_OP(set_identity_map_addr)
 KVM_X86_OP(get_mt_mask)
 KVM_X86_OP(load_mmu_pgd)
+KVM_X86_OP(set_private_spte)
+KVM_X86_OP(drop_private_spte)
+KVM_X86_OP(zap_private_spte)
+KVM_X86_OP(unzap_private_spte)
+KVM_X86_OP(link_private_sp)
+KVM_X86_OP(free_private_sp)
 KVM_X86_OP_NULL(has_wbinvd_exit)
 KVM_X86_OP(write_l1_tsc_offset)
 KVM_X86_OP(get_exit_info)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c641654307c6..9631b985ebdc 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -385,6 +385,7 @@ struct kvm_mmu {
 			 struct kvm_mmu_page *sp);
 	void (*invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa);
 	hpa_t root_hpa;
+	hpa_t private_root_hpa;
 	gpa_t root_pgd;
 	union kvm_mmu_role mmu_role;
 	u8 root_level;
@@ -424,6 +425,7 @@ struct kvm_mmu {
 	u8 last_nonleaf_level;
 
 	bool nx;
+	bool no_prefetch;
 
 	u64 pdptrs[4]; /* pae */
 };
@@ -639,6 +641,7 @@ struct kvm_vcpu_arch {
 	struct kvm_mmu_memory_cache mmu_shadow_page_cache;
 	struct kvm_mmu_memory_cache mmu_gfn_array_cache;
 	struct kvm_mmu_memory_cache mmu_page_header_cache;
+	struct kvm_mmu_memory_cache mmu_private_sp_cache;
 
 	/*
 	 * QEMU userspace and the guest each have their own FPU state.
@@ -989,6 +992,7 @@ struct kvm_arch {
 	u8 mmu_valid_gen;
 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
 	struct list_head active_mmu_pages;
+	struct list_head private_mmu_pages;
 	struct list_head zapped_obsolete_pages;
 	struct list_head lpage_disallowed_mmu_pages;
 	struct kvm_page_track_notifier_node mmu_sp_tracker;
@@ -1137,6 +1141,8 @@ struct kvm_arch {
 	 */
 	spinlock_t tdp_mmu_pages_lock;
 #endif /* CONFIG_X86_64 */
+
+	gfn_t gfn_shared_mask;
 };
 
 struct kvm_vm_stat {
@@ -1319,6 +1325,17 @@ struct kvm_x86_ops {
 	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			     int root_level);
 
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
@@ -1490,7 +1507,8 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 				   const struct kvm_memory_slot *memslot);
 void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 				   struct kvm_memory_slot *memslot);
-void kvm_mmu_zap_all(struct kvm *kvm);
+void kvm_mmu_zap_all_active(struct kvm *kvm);
+void kvm_mmu_zap_all_private(struct kvm *kvm);
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen);
 unsigned long kvm_mmu_calculate_default_mmu_pages(struct kvm *kvm);
 void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long kvm_nr_mmu_pages);
@@ -1656,7 +1674,9 @@ static inline int __kvm_irq_line_state(unsigned long *irq_state,
 
 #define KVM_MMU_ROOT_CURRENT		BIT(0)
 #define KVM_MMU_ROOT_PREVIOUS(i)	BIT(1+i)
-#define KVM_MMU_ROOTS_ALL		(~0UL)
+#define KVM_MMU_ROOT_PRIVATE		BIT(1+KVM_MMU_NUM_PREV_ROOTS)
+#define KVM_MMU_ROOTS_ALL		((u32)(~KVM_MMU_ROOT_PRIVATE))
+#define KVM_MMU_ROOTS_ALL_INC_PRIVATE	(KVM_MMU_ROOTS_ALL | KVM_MMU_ROOT_PRIVATE)
 
 int kvm_pic_set_irq(struct kvm_pic *pic, int irq, int irq_source_id, int level);
 void kvm_pic_clear_all(struct kvm_pic *pic, int irq_source_id);
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 6ec8d9fdff35..c3e241088851 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -235,8 +235,7 @@ void kvm_mmu_pre_destroy_vm(struct kvm *kvm);
 
 static inline gfn_t kvm_gfn_stolen_mask(struct kvm *kvm)
 {
-	/* Currently there are no stolen bits in KVM */
-	return 0;
+	return kvm->arch.gfn_shared_mask;
 }
 
 static inline gfn_t vcpu_gfn_stolen_mask(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6b0c8c84aabe..c343e546b7c5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -544,15 +544,15 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
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
@@ -575,6 +575,11 @@ static u64 mmu_spte_clear_track_bits(u64 *sptep)
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
@@ -681,6 +686,13 @@ static int mmu_topup_shadow_page_cache(struct kvm_vcpu *vcpu)
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
 
@@ -722,6 +734,7 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 {
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
+	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_private_sp_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_gfn_array_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
 }
@@ -863,6 +876,23 @@ gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu, gfn_t gfn,
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
+	return __is_private_gfn(kvm, sptep_to_sp(sptep)->gfn_stolen_bits);
+}
+
 /*
  * About rmap_head encoding:
  *
@@ -1014,7 +1044,7 @@ static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 	return pte_list_add(vcpu, spte, rmap_head);
 }
 
-static void rmap_remove(struct kvm *kvm, u64 *spte)
+static void rmap_remove(struct kvm *kvm, u64 *spte, u64 old_spte)
 {
 	struct kvm_mmu_page *sp;
 	gfn_t gfn;
@@ -1024,6 +1054,10 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 	gfn = kvm_mmu_page_get_gfn(sp, spte - sp->spt);
 	rmap_head = gfn_to_rmap(kvm, gfn, sp);
 	__pte_list_remove(spte, rmap_head);
+
+	if (__is_private_gfn(kvm, sp->gfn_stolen_bits))
+		static_call(kvm_x86_drop_private_spte)(
+			kvm, gfn, sp->role.level - 1, spte_to_pfn(old_spte));
 }
 
 /*
@@ -1061,7 +1095,8 @@ static u64 *rmap_get_first(struct kvm_rmap_head *rmap_head,
 	iter->pos = 0;
 	sptep = iter->desc->sptes[iter->pos];
 out:
-	BUG_ON(!is_shadow_present_pte(*sptep));
+	BUG_ON(!is_shadow_present_pte(*sptep) &&
+	       !is_zapped_private_pte(*sptep));
 	return sptep;
 }
 
@@ -1106,8 +1141,9 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
 {
 	u64 old_spte = mmu_spte_clear_track_bits(sptep);
 
-	if (is_shadow_present_pte(old_spte))
-		rmap_remove(kvm, sptep);
+	if (is_shadow_present_pte(old_spte) ||
+	    is_zapped_private_pte(old_spte))
+		rmap_remove(kvm, sptep, old_spte);
 }
 
 
@@ -1330,28 +1366,67 @@ static bool rmap_write_protect(struct kvm_vcpu *vcpu, u64 gfn)
 	return kvm_mmu_slot_gfn_write_protect(vcpu->kvm, slot, gfn);
 }
 
-static bool kvm_zap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
-			  struct kvm_memory_slot *slot)
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
+	static_call(kvm_x86_zap_private_spte)(kvm, gfn, sp->role.level - 1);
+
+	__mmu_spte_clear_track_bits(sptep,
+				    SPTE_PRIVATE_ZAPPED | pfn << PAGE_SHIFT);
+	return true;
+}
+
+static bool __kvm_zap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head)
 {
 	u64 *sptep;
 	struct rmap_iterator iter;
 	bool flush = false;
 
-	while ((sptep = rmap_get_first(rmap_head, &iter))) {
-		rmap_printk("spte %p %llx.\n", sptep, *sptep);
+restart:
+	for_each_rmap_spte(rmap_head, &iter, sptep) {
+		rmap_printk("%s: spte %p %llx.\n", __func__, sptep, *sptep);
+
+		if (is_zapped_private_pte(*sptep))
+			continue;
 
-		pte_list_remove(rmap_head, sptep);
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
 }
 
+static inline bool kvm_zap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
+				  struct kvm_memory_slot *slot)
+{
+	return __kvm_zap_rmapp(kvm, rmap_head);
+}
+
 static bool kvm_unmap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 			    struct kvm_memory_slot *slot, gfn_t gfn, int level,
 			    pte_t unused)
 {
-	return kvm_zap_rmapp(kvm, rmap_head, slot);
+	return __kvm_zap_rmapp(kvm, rmap_head);
 }
 
 static bool kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
@@ -1374,6 +1449,9 @@ static bool kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 
 		need_flush = 1;
 
+		/* Private page relocation is not yet supported. */
+		KVM_BUG_ON(is_private_spte(kvm, sptep), kvm);
+
 		if (pte_write(pte)) {
 			pte_list_remove(rmap_head, sptep);
 			goto restart;
@@ -1600,7 +1678,7 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, unsigned long nr)
 	percpu_counter_add(&kvm_total_used_mmu_pages, nr);
 }
 
-static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
+static void kvm_mmu_free_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	MMU_WARN_ON(!is_empty_shadow_page(sp->spt));
 	hlist_del(&sp->hash_link);
@@ -1608,6 +1686,11 @@ static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
 	free_page((unsigned long)sp->spt);
 	if (!sp->role.direct)
 		free_page((unsigned long)sp->gfns);
+	if (sp->private_sp &&
+	    !static_call(kvm_x86_free_private_sp)(kvm, sp->gfn, sp->role.level,
+						  sp->private_sp))
+		free_page((unsigned long)sp->private_sp);
+
 	kmem_cache_free(mmu_page_header_cache, sp);
 }
 
@@ -1638,7 +1721,8 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
 	mmu_spte_clear_no_track(parent_pte);
 }
 
-static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct)
+static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
+					       int direct, bool private)
 {
 	struct kvm_mmu_page *sp;
 
@@ -1654,7 +1738,10 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct
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
@@ -2066,7 +2153,8 @@ static struct kvm_mmu_page *__kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 
 	++vcpu->kvm->stat.mmu_cache_miss;
 
-	sp = kvm_mmu_alloc_page(vcpu, direct);
+	sp = kvm_mmu_alloc_page(vcpu, direct,
+				is_private_gfn(vcpu, gfn_stolen_bits));
 
 	sp->gfn = gfn;
 	sp->gfn_stolen_bits = gfn_stolen_bits;
@@ -2133,8 +2221,13 @@ static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterato
 static void shadow_walk_init(struct kvm_shadow_walk_iterator *iterator,
 			     struct kvm_vcpu *vcpu, u64 addr)
 {
-	shadow_walk_init_using_root(iterator, vcpu, vcpu->arch.mmu->root_hpa,
-				    addr);
+	hpa_t root;
+
+	if (tdp_enabled && is_private_gfn(vcpu, addr >> PAGE_SHIFT))
+		root = vcpu->arch.mmu->private_root_hpa;
+	else
+		root = vcpu->arch.mmu->root_hpa;
+	shadow_walk_init_using_root(iterator, vcpu, root, addr);
 }
 
 static bool shadow_walk_okay(struct kvm_shadow_walk_iterator *iterator)
@@ -2211,7 +2304,7 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 	struct kvm_mmu_page *child;
 
 	pte = *spte;
-	if (is_shadow_present_pte(pte)) {
+	if (is_shadow_present_pte(pte) || is_zapped_private_pte(pte)) {
 		if (is_last_spte(pte, sp->role.level)) {
 			drop_spte(kvm, spte);
 			if (is_large_pte(pte))
@@ -2220,6 +2313,9 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 			child = to_shadow_page(pte & PT64_BASE_ADDR_MASK);
 			drop_parent_pte(child, spte);
 
+			if (!is_shadow_present_pte(pte))
+				return 0;
+
 			/*
 			 * Recursively zap nested TDP SPs, parentless SPs are
 			 * unlikely to be used again in the near future.  This
@@ -2370,7 +2466,7 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 
 	list_for_each_entry_safe(sp, nsp, invalid_list, link) {
 		WARN_ON(!sp->role.invalid || sp->root_count);
-		kvm_mmu_free_page(sp);
+		kvm_mmu_free_page(kvm, sp);
 	}
 }
 
@@ -2603,6 +2699,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	int set_spte_ret;
 	int ret = RET_PF_FIXED;
 	bool flush = false;
+	u64 pte = *sptep;
 
 	pgprintk("%s: spte %llx write_fault %d gfn %llx\n", __func__,
 		 *sptep, write_fault, gfn);
@@ -2612,25 +2709,27 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		return RET_PF_EMULATE;
 	}
 
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
+		was_rmapped = 1;
 	}
 
 	set_spte_ret = set_spte(vcpu, sptep, pte_access, level, gfn, pfn,
@@ -2875,6 +2974,52 @@ void disallowed_hugepage_adjust(u64 spte, gfn_t gfn, int cur_level,
 	}
 }
 
+static void kvm_mmu_link_private_sp(struct kvm_vcpu *vcpu,
+				    struct kvm_mmu_page *sp)
+{
+	void *p = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_private_sp_cache);
+
+	if (!static_call(kvm_x86_link_private_sp)(vcpu, sp->gfn,
+						  sp->role.level, p))
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
+	if (__kvm_zap_rmapp(kvm, rmap_head))
+		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
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
@@ -2890,10 +3035,19 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	gfn_t gfn = (gpa & ~gpa_stolen_mask) >> PAGE_SHIFT;
 	gfn_t gfn_stolen_bits = (gpa & gpa_stolen_mask) >> PAGE_SHIFT;
 	gfn_t base_gfn = gfn;
+	bool is_private = is_private_gfn(vcpu, gfn_stolen_bits);
+	bool is_zapped_pte;
 
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
 
@@ -2921,15 +3075,30 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		link_shadow_page(vcpu, it.sptep, sp);
 		if (is_tdp && huge_page_disallowed && req_level >= it.level)
 			account_huge_nx_page(vcpu->kvm, sp);
+		if (is_private)
+			kvm_mmu_link_private_sp(vcpu, sp);
 	}
 
+	is_zapped_pte = is_zapped_private_pte(*it.sptep);
+
 	ret = mmu_set_spte(vcpu, it.sptep, ACC_ALL,
 			   write, level, base_gfn, pfn, prefault,
 			   map_writable);
 	if (ret == RET_PF_SPURIOUS)
 		return ret;
 
-	direct_pte_prefetch(vcpu, it.sptep);
+	if (!is_private) {
+		if (!vcpu->arch.mmu->no_prefetch)
+			direct_pte_prefetch(vcpu, it.sptep);
+	} else if (!WARN_ON_ONCE(ret != RET_PF_FIXED)) {
+		if (is_zapped_pte)
+			static_call(kvm_x86_unzap_private_spte)(vcpu->kvm, gfn,
+								level - 1);
+		else
+			static_call(kvm_x86_set_private_spte)(vcpu, gfn, level,
+							      pfn);
+	}
+
 	++vcpu->stat.pf_fixed;
 	return ret;
 }
@@ -3210,7 +3379,9 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			    VALID_PAGE(mmu->prev_roots[i].hpa))
 				break;
 
-		if (i == KVM_MMU_NUM_PREV_ROOTS)
+		if (i == KVM_MMU_NUM_PREV_ROOTS &&
+		    (!(roots_to_free & KVM_MMU_ROOT_PRIVATE) ||
+		     !VALID_PAGE(mmu->private_root_hpa)))
 			return;
 	}
 
@@ -3239,6 +3410,9 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 		mmu->root_pgd = 0;
 	}
 
+	if (roots_to_free & KVM_MMU_ROOT_PRIVATE)
+		mmu_free_root_page(kvm, &mmu->private_root_hpa, &invalid_list);
+
 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
 	write_unlock(&kvm->mmu_lock);
 }
@@ -3256,12 +3430,14 @@ static int mmu_check_root(struct kvm_vcpu *vcpu, gfn_t root_gfn)
 	return ret;
 }
 
-static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, gva_t gva,
-			    u8 level, bool direct)
+static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn,
+			    gfn_t gfn_stolen_bits, gva_t gva, u8 level,
+			    bool direct)
 {
 	struct kvm_mmu_page *sp;
 
-	sp = kvm_mmu_get_page(vcpu, gfn, gva, level, direct, ACC_ALL);
+	sp = __kvm_mmu_get_page(vcpu, gfn, gfn_stolen_bits, gva, level, direct,
+				ACC_ALL);
 	++sp->root_count;
 
 	return __pa(sp->spt);
@@ -3271,6 +3447,7 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	u8 shadow_root_level = mmu->shadow_root_level;
+	gfn_t gfn_shared = vcpu->kvm->arch.gfn_shared_mask;
 	hpa_t root;
 	unsigned i;
 	int r;
@@ -3284,9 +3461,15 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
 		mmu->root_hpa = root;
 	} else if (shadow_root_level >= PT64_ROOT_4LEVEL) {
-		root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level, true);
-		mmu->root_hpa = root;
+		if (gfn_shared && !VALID_PAGE(vcpu->arch.mmu->private_root_hpa)) {
+			root = mmu_alloc_root(vcpu, 0, 0, 0, shadow_root_level, true);
+			vcpu->arch.mmu->private_root_hpa = root;
+		}
+		root = mmu_alloc_root(vcpu, 0, gfn_shared, 0, shadow_root_level, true);
+		vcpu->arch.mmu->root_hpa = root;
 	} else if (shadow_root_level == PT32E_ROOT_LEVEL) {
+		WARN_ON_ONCE(gfn_shared);
+
 		if (WARN_ON_ONCE(!mmu->pae_root)) {
 			r = -EIO;
 			goto out_unlock;
@@ -3295,7 +3478,7 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 		for (i = 0; i < 4; ++i) {
 			WARN_ON_ONCE(IS_VALID_PAE_ROOT(mmu->pae_root[i]));
 
-			root = mmu_alloc_root(vcpu, i << (30 - PAGE_SHIFT),
+			root = mmu_alloc_root(vcpu, i << (30 - PAGE_SHIFT), 0,
 					      i << 30, PT32_ROOT_LEVEL, true);
 			mmu->pae_root[i] = root | PT_PRESENT_MASK |
 					   shadow_me_mask;
@@ -3354,8 +3537,8 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	 * write-protect the guests page table root.
 	 */
 	if (mmu->root_level >= PT64_ROOT_4LEVEL) {
-		root = mmu_alloc_root(vcpu, root_gfn, 0,
-				      mmu->shadow_root_level, false);
+		root = mmu_alloc_root(vcpu, root_gfn, 0, 0,
+				      vcpu->arch.mmu->shadow_root_level, false);
 		mmu->root_hpa = root;
 		goto set_root_pgd;
 	}
@@ -3393,7 +3576,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 			root_gfn = pdptrs[i] >> PAGE_SHIFT;
 		}
 
-		root = mmu_alloc_root(vcpu, root_gfn, i << 30,
+		root = mmu_alloc_root(vcpu, root_gfn, 0, i << 30,
 				      PT32_ROOT_LEVEL, false);
 		mmu->pae_root[i] = root | pm_mask;
 	}
@@ -4325,7 +4508,6 @@ reset_ept_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
 	 (6 & (access) ? 64 : 0) | \
 	 (7 & (access) ? 128 : 0))
 
-
 static void update_permission_bitmask(struct kvm_vcpu *vcpu,
 				      struct kvm_mmu *mmu, bool ept)
 {
@@ -4953,14 +5135,19 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 	return r;
 }
 
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
 
+void kvm_mmu_unload(struct kvm_vcpu *vcpu)
+{
+	__kvm_mmu_unload(vcpu, KVM_MMU_ROOTS_ALL);
+}
+
 static bool need_remote_flush(u64 old, u64 new)
 {
 	if (!is_shadow_present_pte(old))
@@ -5365,8 +5552,10 @@ static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
 	int i;
 
 	mmu->root_hpa = INVALID_PAGE;
+	mmu->private_root_hpa = INVALID_PAGE;
 	mmu->root_pgd = 0;
 	mmu->translate_gpa = translate_gpa;
+	mmu->no_prefetch = false;
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
 		mmu->prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
 
@@ -5694,6 +5883,9 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 		sp = sptep_to_sp(sptep);
 		pfn = spte_to_pfn(*sptep);
 
+		/* Private page dirty logging is not supported. */
+		KVM_BUG_ON(is_private_spte(kvm, sptep), kvm);
+
 		/*
 		 * We cannot do huge page mapping for indirect shadow pages,
 		 * which are found on the last rmap (level = 1) when not using
@@ -5784,7 +5976,7 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
 }
 
-void kvm_mmu_zap_all(struct kvm *kvm)
+static void __kvm_mmu_zap_all(struct kvm *kvm, struct list_head *mmu_pages)
 {
 	struct kvm_mmu_page *sp, *node;
 	LIST_HEAD(invalid_list);
@@ -5792,7 +5984,7 @@ void kvm_mmu_zap_all(struct kvm *kvm)
 
 	write_lock(&kvm->mmu_lock);
 restart:
-	list_for_each_entry_safe(sp, node, &kvm->arch.active_mmu_pages, link) {
+	list_for_each_entry_safe(sp, node, mmu_pages, link) {
 		if (WARN_ON(sp->role.invalid))
 			continue;
 		if (__kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list, &ign))
@@ -5800,7 +5992,6 @@ void kvm_mmu_zap_all(struct kvm *kvm)
 		if (cond_resched_rwlock_write(&kvm->mmu_lock))
 			goto restart;
 	}
-
 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
 
 	if (is_tdp_mmu_enabled(kvm))
@@ -5809,6 +6000,17 @@ void kvm_mmu_zap_all(struct kvm *kvm)
 	write_unlock(&kvm->mmu_lock);
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
@@ -6028,7 +6230,7 @@ unsigned long kvm_mmu_calculate_default_mmu_pages(struct kvm *kvm)
 
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 {
-	kvm_mmu_unload(vcpu);
+	__kvm_mmu_unload(vcpu, KVM_MMU_ROOTS_ALL_INC_PRIVATE);
 	free_mmu_pages(&vcpu->arch.root_mmu);
 	free_mmu_pages(&vcpu->arch.guest_mmu);
 	mmu_free_memory_caches(vcpu);
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index c896ec9f3159..43df47a24d13 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -51,6 +51,8 @@ struct kvm_mmu_page {
 	u64 *spt;
 	/* hold the gfn of each spte inside spt */
 	gfn_t *gfns;
+	/* associated private shadow page, e.g. SEPT page */
+	void *private_sp;
 	/* Currently serving as active root */
 	union {
 		int root_count;
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index f88cf3db31c7..6c4feabcef56 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -14,6 +14,9 @@
  */
 #define SPTE_MMU_PRESENT_MASK		BIT_ULL(11)
 
+/* Masks that used to track metadata for not-present SPTEs. */
+#define SPTE_PRIVATE_ZAPPED	BIT_ULL(62)
+
 /*
  * TDP SPTES (more specifically, EPT SPTEs) may not have A/D bits, and may also
  * be restricted to using write-protection (for L2 when CPU dirty logging, i.e.
@@ -101,11 +104,11 @@ static_assert(!(EPT_SPTE_MMU_WRITABLE & SHADOW_ACC_TRACK_SAVED_MASK));
 #undef SHADOW_ACC_TRACK_SAVED_MASK
 
 /*
- * Due to limited space in PTEs, the MMIO generation is a 19 bit subset of
+ * Due to limited space in PTEs, the MMIO generation is a 18 bit subset of
  * the memslots generation and is derived as follows:
  *
  * Bits 0-7 of the MMIO generation are propagated to spte bits 3-10
- * Bits 8-18 of the MMIO generation are propagated to spte bits 52-62
+ * Bits 8-17 of the MMIO generation are propagated to spte bits 52-61
  *
  * The KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS flag is intentionally not included in
  * the MMIO generation number, as doing so would require stealing a bit from
@@ -119,7 +122,7 @@ static_assert(!(EPT_SPTE_MMU_WRITABLE & SHADOW_ACC_TRACK_SAVED_MASK));
 #define MMIO_SPTE_GEN_LOW_END		10
 
 #define MMIO_SPTE_GEN_HIGH_START	52
-#define MMIO_SPTE_GEN_HIGH_END		62
+#define MMIO_SPTE_GEN_HIGH_END		61
 
 #define MMIO_SPTE_GEN_LOW_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_END, \
 						    MMIO_SPTE_GEN_LOW_START)
@@ -132,7 +135,7 @@ static_assert(!(SPTE_MMU_PRESENT_MASK &
 #define MMIO_SPTE_GEN_HIGH_BITS		(MMIO_SPTE_GEN_HIGH_END - MMIO_SPTE_GEN_HIGH_START + 1)
 
 /* remember to adjust the comment above as well if you change these */
-static_assert(MMIO_SPTE_GEN_LOW_BITS == 8 && MMIO_SPTE_GEN_HIGH_BITS == 11);
+static_assert(MMIO_SPTE_GEN_LOW_BITS == 8 && MMIO_SPTE_GEN_HIGH_BITS == 10);
 
 #define MMIO_SPTE_GEN_LOW_SHIFT		(MMIO_SPTE_GEN_LOW_START - 0)
 #define MMIO_SPTE_GEN_HIGH_SHIFT	(MMIO_SPTE_GEN_HIGH_START - MMIO_SPTE_GEN_LOW_BITS)
@@ -260,6 +263,11 @@ static inline bool is_access_track_spte(u64 spte)
 	return !spte_ad_enabled(spte) && (spte & shadow_acc_track_mask) == 0;
 }
 
+static inline bool is_zapped_private_pte(u64 pte)
+{
+	return !!(pte & SPTE_PRIVATE_ZAPPED);
+}
+
 static inline bool is_large_pte(u64 pte)
 {
 	return pte & PT_PAGE_SIZE_MASK;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 92d5a6649a21..a8299add443f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10874,6 +10874,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	INIT_HLIST_HEAD(&kvm->arch.mask_notifier_list);
 	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
+	INIT_LIST_HEAD(&kvm->arch.private_mmu_pages);
 	INIT_LIST_HEAD(&kvm->arch.zapped_obsolete_pages);
 	INIT_LIST_HEAD(&kvm->arch.lpage_disallowed_mmu_pages);
 	INIT_LIST_HEAD(&kvm->arch.assigned_dev_head);
@@ -11299,7 +11300,8 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
-	kvm_mmu_zap_all(kvm);
+	/* Zapping private pages must be deferred until VM destruction. */
+	kvm_mmu_zap_all_active(kvm);
 }
 
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
-- 
2.25.1

