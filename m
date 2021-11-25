Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85CB345D1B2
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 01:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353314AbhKYAY4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 19:24:56 -0500
Received: from mga12.intel.com ([192.55.52.136]:16253 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352975AbhKYAY1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 19:24:27 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="215432212"
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="215432212"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:17 -0800
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="675042255"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:16 -0800
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
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v3 36/59] KVM: x86/mmu: Frame in support for private/inaccessible shadow pages
Date:   Wed, 24 Nov 2021 16:20:19 -0800
Message-Id: <b54d52e6527dd0ac56a281b61cada2cf7195668b.1637799475.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
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
 arch/x86/include/asm/kvm-x86-ops.h |   7 +
 arch/x86/include/asm/kvm_host.h    |  32 +-
 arch/x86/kvm/mmu.h                 |  16 +-
 arch/x86/kvm/mmu/mmu.c             | 478 +++++++++++++++++++++++------
 arch/x86/kvm/mmu/mmu_internal.h    |  13 +-
 arch/x86/kvm/mmu/paging_tmpl.h     |  11 +-
 arch/x86/kvm/mmu/spte.h            |  16 +-
 arch/x86/kvm/x86.c                 |  10 +-
 virt/kvm/kvm_main.c                |   1 +
 9 files changed, 463 insertions(+), 121 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 1009541fd6c2..ef94a535f452 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -20,6 +20,7 @@ KVM_X86_OP(has_emulated_msr)
 KVM_X86_OP(vcpu_after_set_cpuid)
 KVM_X86_OP(is_vm_type_supported)
 KVM_X86_OP(vm_init)
+KVM_X86_OP_NULL(mmu_prezap)
 KVM_X86_OP_NULL(vm_teardown)
 KVM_X86_OP_NULL(vm_destroy)
 KVM_X86_OP(vcpu_create)
@@ -89,6 +90,12 @@ KVM_X86_OP(set_tss_addr)
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
 KVM_X86_OP(get_l2_tsc_offset)
 KVM_X86_OP(get_l2_tsc_multiplier)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2dab0899d82c..7ce0641d54dd 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -320,7 +320,8 @@ union kvm_mmu_page_role {
 		unsigned smap_andnot_wp:1;
 		unsigned ad_disabled:1;
 		unsigned guest_mode:1;
-		unsigned :6;
+		unsigned private:1;
+		unsigned :5;
 
 		/*
 		 * This is left at the top of the word so that
@@ -427,6 +428,7 @@ struct kvm_mmu {
 			 struct kvm_mmu_page *sp);
 	void (*invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa);
 	hpa_t root_hpa;
+	hpa_t private_root_hpa;
 	gpa_t root_pgd;
 	union kvm_mmu_role mmu_role;
 	u8 root_level;
@@ -463,6 +465,8 @@ struct kvm_mmu {
 
 	struct rsvd_bits_validate guest_rsvd_check;
 
+	bool no_prefetch;
+
 	u64 pdptrs[4]; /* pae */
 };
 
@@ -685,6 +689,7 @@ struct kvm_vcpu_arch {
 	struct kvm_mmu_memory_cache mmu_shadow_page_cache;
 	struct kvm_mmu_memory_cache mmu_gfn_array_cache;
 	struct kvm_mmu_memory_cache mmu_page_header_cache;
+	struct kvm_mmu_memory_cache mmu_private_sp_cache;
 
 	/*
 	 * QEMU userspace and the guest each have their own FPU state.
@@ -1052,6 +1057,7 @@ struct kvm_arch {
 	u8 mmu_valid_gen;
 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
 	struct list_head active_mmu_pages;
+	struct list_head private_mmu_pages;
 	struct list_head zapped_obsolete_pages;
 	struct list_head lpage_disallowed_mmu_pages;
 	struct kvm_page_track_notifier_node mmu_sp_tracker;
@@ -1236,6 +1242,8 @@ struct kvm_arch {
 	hpa_t	hv_root_tdp;
 	spinlock_t hv_root_tdp_lock;
 #endif
+
+	gfn_t gfn_shared_mask;
 };
 
 struct kvm_vm_stat {
@@ -1328,6 +1336,7 @@ struct kvm_x86_ops {
 	bool (*is_vm_type_supported)(unsigned long vm_type);
 	unsigned int vm_size;
 	int (*vm_init)(struct kvm *kvm);
+	void (*mmu_prezap)(struct kvm *kvm);
 	void (*vm_teardown)(struct kvm *kvm);
 	void (*vm_destroy)(struct kvm *kvm);
 
@@ -1423,6 +1432,17 @@ struct kvm_x86_ops {
 	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			     int root_level);
 
+	void (*set_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				 kvm_pfn_t pfn);
+	void (*drop_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				  kvm_pfn_t pfn);
+	void (*zap_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level);
+	void (*unzap_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level);
+	int (*link_private_sp)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+			       void *private_sp);
+	int (*free_private_sp)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+			       void *private_sp);
+
 	bool (*has_wbinvd_exit)(void);
 
 	u64 (*get_l2_tsc_offset)(struct kvm_vcpu *vcpu);
@@ -1602,7 +1622,8 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 				   const struct kvm_memory_slot *memslot);
 void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 				   const struct kvm_memory_slot *memslot);
-void kvm_mmu_zap_all(struct kvm *kvm);
+void kvm_mmu_zap_all_active(struct kvm *kvm);
+void kvm_mmu_zap_all_private(struct kvm *kvm);
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen);
 unsigned long kvm_mmu_calculate_default_mmu_pages(struct kvm *kvm);
 void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long kvm_nr_mmu_pages);
@@ -1765,7 +1786,9 @@ static inline int __kvm_irq_line_state(unsigned long *irq_state,
 
 #define KVM_MMU_ROOT_CURRENT		BIT(0)
 #define KVM_MMU_ROOT_PREVIOUS(i)	BIT(1+i)
-#define KVM_MMU_ROOTS_ALL		(~0UL)
+#define KVM_MMU_ROOT_PRIVATE		BIT(1+KVM_MMU_NUM_PREV_ROOTS)
+#define KVM_MMU_ROOTS_ALL		((u32)(~KVM_MMU_ROOT_PRIVATE))
+#define KVM_MMU_ROOTS_ALL_INC_PRIVATE	(KVM_MMU_ROOTS_ALL | KVM_MMU_ROOT_PRIVATE)
 
 int kvm_pic_set_irq(struct kvm_pic *pic, int irq, int irq_source_id, int level);
 void kvm_pic_clear_all(struct kvm_pic *pic, int irq_source_id);
@@ -1973,4 +1996,7 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
 #define KVM_CLOCK_VALID_FLAGS						\
 	(KVM_CLOCK_TSC_STABLE | KVM_CLOCK_REALTIME | KVM_CLOCK_HOST_TSC)
 
+bool kvm_is_private_gfn(struct kvm *kvm, gfn_t gfn);
+bool kvm_vcpu_is_private_gfn(struct kvm_vcpu *vcpu, gfn_t gfn);
+
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 79ccee8bbc38..9c22dedbb228 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -355,13 +355,7 @@ static inline void kvm_update_page_stats(struct kvm *kvm, int level, int count)
 
 static inline gfn_t kvm_gfn_stolen_mask(struct kvm *kvm)
 {
-	/* Currently there are no stolen bits in KVM */
-	return 0;
-}
-
-static inline gfn_t vcpu_gfn_stolen_mask(struct kvm_vcpu *vcpu)
-{
-	return kvm_gfn_stolen_mask(vcpu->kvm);
+	return kvm->arch.gfn_shared_mask;
 }
 
 static inline gpa_t kvm_gpa_stolen_mask(struct kvm *kvm)
@@ -369,14 +363,14 @@ static inline gpa_t kvm_gpa_stolen_mask(struct kvm *kvm)
 	return kvm_gfn_stolen_mask(kvm) << PAGE_SHIFT;
 }
 
-static inline gpa_t vcpu_gpa_stolen_mask(struct kvm_vcpu *vcpu)
+static inline gpa_t kvm_gpa_unalias(struct kvm *kvm, gpa_t gpa)
 {
-	return kvm_gpa_stolen_mask(vcpu->kvm);
+	return gpa & ~kvm_gpa_stolen_mask(kvm);
 }
 
-static inline gfn_t vcpu_gpa_to_gfn_unalias(struct kvm_vcpu *vcpu, gpa_t gpa)
+static inline gfn_t kvm_gfn_unalias(struct kvm *kvm, gpa_t gpa)
 {
-	return (gpa >> PAGE_SHIFT) & ~vcpu_gfn_stolen_mask(vcpu);
+	return kvm_gpa_unalias(kvm, gpa) >> PAGE_SHIFT;
 }
 
 #endif
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f1bd7d952bfe..c3effcbb726e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -616,16 +616,16 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
  * state bits, it is used to clear the last level sptep.
  * Returns the old PTE.
  */
-static u64 mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
+static u64 __mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep, u64 clear_value)
 {
 	kvm_pfn_t pfn;
 	u64 old_spte = *sptep;
 	int level = sptep_to_sp(sptep)->role.level;
 
 	if (!spte_has_volatile_bits(old_spte))
-		__update_clear_spte_fast(sptep, shadow_init_value);
+		__update_clear_spte_fast(sptep, clear_value);
 	else
-		old_spte = __update_clear_spte_slow(sptep, shadow_init_value);
+		old_spte = __update_clear_spte_slow(sptep, clear_value);
 
 	if (!is_shadow_present_pte(old_spte))
 		return old_spte;
@@ -650,6 +650,11 @@ static u64 mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
 	return old_spte;
 }
 
+static inline u64 mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
+{
+	return __mmu_spte_clear_track_bits(kvm, sptep, shadow_init_value);
+}
+
 /*
  * Rules for using mmu_spte_clear_no_track:
  * Directly clear spte without caring the state bits of sptep,
@@ -764,6 +769,13 @@ static int mmu_topup_shadow_page_cache(struct kvm_vcpu *vcpu)
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
 
@@ -805,6 +817,7 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 {
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
+	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_private_sp_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_gfn_array_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
 }
@@ -1058,34 +1071,6 @@ static void pte_list_remove(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 	__pte_list_remove(sptep, rmap_head);
 }
 
-/* Return true if rmap existed, false otherwise */
-static bool pte_list_destroy(struct kvm *kvm, struct kvm_rmap_head *rmap_head)
-{
-	struct pte_list_desc *desc, *next;
-	int i;
-
-	if (!rmap_head->val)
-		return false;
-
-	if (!(rmap_head->val & 1)) {
-		mmu_spte_clear_track_bits(kvm, (u64 *)rmap_head->val);
-		goto out;
-	}
-
-	desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
-
-	for (; desc; desc = next) {
-		for (i = 0; i < desc->spte_count; i++)
-			mmu_spte_clear_track_bits(kvm, desc->sptes[i]);
-		next = desc->more;
-		mmu_free_pte_list_desc(desc);
-	}
-out:
-	/* rmap_head is meaningless now, remember to reset it */
-	rmap_head->val = 0;
-	return true;
-}
-
 unsigned int pte_list_count(struct kvm_rmap_head *rmap_head)
 {
 	struct pte_list_desc *desc;
@@ -1123,7 +1108,7 @@ static bool rmap_can_add(struct kvm_vcpu *vcpu)
 	return kvm_mmu_memory_cache_nr_free_objects(mc);
 }
 
-static void rmap_remove(struct kvm *kvm, u64 *spte)
+static void rmap_remove(struct kvm *kvm, u64 *spte, u64 old_spte)
 {
 	struct kvm_memslots *slots;
 	struct kvm_memory_slot *slot;
@@ -1145,6 +1130,10 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
 
 	__pte_list_remove(spte, rmap_head);
+
+	if (is_private_sp(sp))
+		static_call(kvm_x86_drop_private_spte)(
+			kvm, gfn, sp->role.level, spte_to_pfn(old_spte));
 }
 
 /*
@@ -1182,7 +1171,8 @@ static u64 *rmap_get_first(struct kvm_rmap_head *rmap_head,
 	iter->pos = 0;
 	sptep = iter->desc->sptes[iter->pos];
 out:
-	BUG_ON(!is_shadow_present_pte(*sptep));
+	WARN_ON(!is_shadow_present_pte(*sptep) &&
+		!is_zapped_private_pte(*sptep));
 	return sptep;
 }
 
@@ -1227,8 +1217,9 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
 {
 	u64 old_spte = mmu_spte_clear_track_bits(kvm, sptep);
 
-	if (is_shadow_present_pte(old_spte))
-		rmap_remove(kvm, sptep);
+	if (is_shadow_present_pte(old_spte) ||
+	    is_zapped_private_pte(old_spte))
+		rmap_remove(kvm, sptep, old_spte);
 }
 
 
@@ -1483,17 +1474,153 @@ static bool rmap_write_protect(struct kvm_vcpu *vcpu, u64 gfn)
 	return kvm_mmu_slot_gfn_write_protect(vcpu->kvm, slot, gfn, PG_LEVEL_4K);
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
+	if (!is_private_spte(sptep))
+		return false;
+
+	sp = sptep_to_sp(sptep);
+	gfn = kvm_mmu_page_get_gfn(sp, sptep - sp->spt);
+	pfn = spte_to_pfn(*sptep);
+
+	static_call(kvm_x86_zap_private_spte)(kvm, gfn, sp->role.level);
+
+	__mmu_spte_clear_track_bits(kvm, sptep,
+				    SPTE_PRIVATE_ZAPPED | pfn << PAGE_SHIFT);
+	return true;
+}
+
+/* Return true if rmap existed, false otherwise */
+static bool __kvm_zap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head)
+{
+#if 0
+	/* Non-optimized version. */
+	u64 *sptep;
+	struct rmap_iterator iter;
+	bool flush = false;
+
+restart:
+	for_each_rmap_spte(rmap_head, &iter, sptep) {
+		rmap_printk("%s: spte %p %llx.\n", __func__, sptep, *sptep);
+
+		if (is_zapped_private_pte(*sptep))
+			continue;
+
+		flush = true;
+
+		/* Keep the rmap if the private SPTE couldn't be zapped. */
+		if (kvm_mmu_zap_private_spte(kvm, sptep))
+			continue;
+
+		pte_list_remove(kvm, rmap_head, sptep);
+		goto restart;
+	}
+
+	return flush;
+#else
+	/*
+	 * optimized version following the commint.
+	 *
+	 * commit a75b540451d20ef1aebaa09d183ddc5c44c6f86a
+	 * Author: Peter Xu <peterx@redhat.com>
+	 * Date:   Fri Jul 30 18:06:05 2021 -0400
+	 *
+	 * KVM: X86: Optimize zapping rmap
+	 *
+	 * Using rmap_get_first() and rmap_remove() for zapping a huge rmap list could be
+	 * slow.  The easy way is to travers the rmap list, collecting the a/d bits and
+	 * free the slots along the way.
+	 *
+	 * Provide a pte_list_destroy() and do exactly that.
+	 */
+	struct pte_list_desc *desc, *prev, *next;
+	bool flush = false;
+	u64 *sptep;
+	int i;
+
+	if (!rmap_head->val)
+		return false;
+
+	if (!(rmap_head->val & 1)) {
+retry_head:
+		sptep = (u64 *)rmap_head->val;
+		if (is_zapped_private_pte(*sptep))
+			return flush;
+
+		flush = true;
+		/* Keep the rmap if the private SPTE couldn't be zapped. */
+		if (kvm_mmu_zap_private_spte(kvm, sptep))
+			goto retry_head;
+
+		mmu_spte_clear_track_bits(kvm, (u64 *)rmap_head->val);
+		rmap_head->val = 0;
+		return true;
+	}
+
+retry:
+	prev = NULL;
+	desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
+
+	for (; desc; desc = next) {
+		for (i = 0; i < desc->spte_count; i++) {
+			sptep = desc->sptes[i];
+			if (is_zapped_private_pte(*sptep))
+				continue;
+
+			flush = true;
+			/*
+			 * Keep the rmap if the private SPTE couldn't be
+			 * zapped.
+			 */
+			if (kvm_mmu_zap_private_spte(kvm, sptep))
+				goto retry;
+
+			mmu_spte_clear_track_bits(kvm, desc->sptes[i]);
+
+			desc->spte_count--;
+			desc->sptes[i] = desc->sptes[desc->spte_count];
+			desc->sptes[desc->spte_count] = NULL;
+			i--;	/* start from same index. */
+		}
+
+		next = desc->more;
+		if (desc->spte_count) {
+			prev = desc;
+		} else {
+			if (!prev && !desc->more)
+				rmap_head->val = 0;
+			else
+				if (prev)
+					prev->more = next;
+				else
+					rmap_head->val = (unsigned long)desc->more | 1;
+			mmu_free_pte_list_desc(desc);
+		}
+	}
+
+	return flush;
+#endif
+}
+
 static bool kvm_zap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
-			  const struct kvm_memory_slot *slot)
+			const struct kvm_memory_slot *slot)
 {
-	return pte_list_destroy(kvm, rmap_head);
+	return __kvm_zap_rmapp(kvm, rmap_head);
 }
 
 static bool kvm_unmap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 			    struct kvm_memory_slot *slot, gfn_t gfn, int level,
 			    pte_t unused)
 {
-	return kvm_zap_rmapp(kvm, rmap_head, slot);
+	return __kvm_zap_rmapp(kvm, rmap_head);
 }
 
 static bool kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
@@ -1516,6 +1643,9 @@ static bool kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 
 		need_flush = 1;
 
+		/* Private page relocation is not yet supported. */
+		KVM_BUG_ON(is_private_spte(sptep), kvm);
+
 		if (pte_write(pte)) {
 			pte_list_remove(kvm, rmap_head, sptep);
 			goto restart;
@@ -1750,7 +1880,7 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, long nr)
 	percpu_counter_add(&kvm_total_used_mmu_pages, nr);
 }
 
-static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
+static void kvm_mmu_free_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	MMU_WARN_ON(!is_empty_shadow_page(sp->spt));
 	hlist_del(&sp->hash_link);
@@ -1758,6 +1888,11 @@ static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
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
 
@@ -1788,7 +1923,8 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
 	mmu_spte_clear_no_track(parent_pte);
 }
 
-static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct)
+static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
+					       int direct, bool private)
 {
 	struct kvm_mmu_page *sp;
 
@@ -1804,7 +1940,10 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct
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
@@ -2112,16 +2251,15 @@ static void clear_sp_write_flooding_count(u64 *spte)
 	__clear_sp_write_flooding_count(sptep_to_sp(spte));
 }
 
-static struct kvm_mmu_page *__kvm_mmu_get_page(struct kvm_vcpu *vcpu,
-					       gfn_t gfn,
-					       gfn_t gfn_stolen_bits,
-					       gva_t gaddr,
-					       unsigned int level,
-					       int direct,
-					       unsigned int access)
+static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
+					     gfn_t gfn,
+					     gva_t gaddr,
+					     unsigned int level,
+					     int direct,
+					     unsigned int access,
+					     unsigned int private)
 {
 	bool direct_mmu = vcpu->arch.mmu->direct_map;
-	gpa_t gfn_and_stolen = gfn | gfn_stolen_bits;
 	union kvm_mmu_page_role role;
 	struct hlist_head *sp_list;
 	unsigned quadrant;
@@ -2140,10 +2278,11 @@ static struct kvm_mmu_page *__kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 		quadrant &= (1 << ((PT32_PT_BITS - PT64_PT_BITS) * level)) - 1;
 		role.quadrant = quadrant;
 	}
+	role.private = private;
 
-	sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn_and_stolen)];
+	sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
 	for_each_valid_sp(vcpu->kvm, sp, sp_list) {
-		if ((sp->gfn | sp->gfn_stolen_bits) != gfn_and_stolen) {
+		if (sp->gfn != gfn) {
 			collisions++;
 			continue;
 		}
@@ -2196,10 +2335,9 @@ static struct kvm_mmu_page *__kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 
 	++vcpu->kvm->stat.mmu_cache_miss;
 
-	sp = kvm_mmu_alloc_page(vcpu, direct);
+	sp = kvm_mmu_alloc_page(vcpu, direct, private);
 
 	sp->gfn = gfn;
-	sp->gfn_stolen_bits = gfn_stolen_bits;
 	sp->role = role;
 	hlist_add_head(&sp->hash_link, sp_list);
 	if (!direct) {
@@ -2216,13 +2354,6 @@ static struct kvm_mmu_page *__kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	return sp;
 }
 
-static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
-					     gva_t gaddr, unsigned int level,
-					     int direct, unsigned int access)
-{
-	return __kvm_mmu_get_page(vcpu, gfn, 0, gaddr, level, direct, access);
-}
-
 static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterator,
 					struct kvm_vcpu *vcpu, hpa_t root,
 					u64 addr)
@@ -2255,8 +2386,13 @@ static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterato
 static void shadow_walk_init(struct kvm_shadow_walk_iterator *iterator,
 			     struct kvm_vcpu *vcpu, u64 addr)
 {
-	shadow_walk_init_using_root(iterator, vcpu, vcpu->arch.mmu->root_hpa,
-				    addr);
+	hpa_t root;
+
+	if (tdp_enabled && kvm_vcpu_is_private_gfn(vcpu, addr >> PAGE_SHIFT))
+		root = vcpu->arch.mmu->private_root_hpa;
+	else
+		root = vcpu->arch.mmu->root_hpa;
+	shadow_walk_init_using_root(iterator, vcpu, root, addr);
 }
 
 static bool shadow_walk_okay(struct kvm_shadow_walk_iterator *iterator)
@@ -2333,13 +2469,16 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 	struct kvm_mmu_page *child;
 
 	pte = *spte;
-	if (is_shadow_present_pte(pte)) {
+	if (is_shadow_present_pte(pte) || is_zapped_private_pte(pte)) {
 		if (is_last_spte(pte, sp->role.level)) {
 			drop_spte(kvm, spte);
 		} else {
 			child = to_shadow_page(pte & PT64_BASE_ADDR_MASK);
 			drop_parent_pte(child, spte);
 
+			if (!is_shadow_present_pte(pte))
+				return 0;
+
 			/*
 			 * Recursively zap nested TDP SPs, parentless SPs are
 			 * unlikely to be used again in the near future.  This
@@ -2490,7 +2629,7 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 
 	list_for_each_entry_safe(sp, nsp, invalid_list, link) {
 		WARN_ON(!sp->role.invalid || sp->root_count);
-		kvm_mmu_free_page(sp);
+		kvm_mmu_free_page(kvm, sp);
 	}
 }
 
@@ -2751,6 +2890,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 	bool host_writable = !fault || fault->map_writable;
 	bool prefetch = !fault || fault->prefetch;
 	bool write_fault = fault && fault->write;
+	u64 pte = *sptep;
 
 	pgprintk("%s: spte %llx write_fault %d gfn %llx\n", __func__,
 		 *sptep, write_fault, gfn);
@@ -2760,25 +2900,27 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
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
 
 	wrprot = make_spte(vcpu, sp, slot, pte_access, gfn, pfn, *sptep, prefetch,
@@ -2824,8 +2966,7 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
 	gfn = kvm_mmu_page_get_gfn(sp, start - sp->spt);
 	slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn, access & ACC_WRITE_MASK);
 
-	/* Don't map private memslots for stolen bits */
-	if (!slot || (sp->gfn_stolen_bits && slot->id >= KVM_USER_MEM_SLOTS))
+	if (!slot || (is_private_sp(sp) && slot->id > KVM_USER_MEM_SLOTS))
 		return -1;
 
 	ret = gfn_to_page_many_atomic(slot, gfn, pages, end - start);
@@ -2997,15 +3138,105 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
 	}
 }
 
+bool kvm_is_private_gfn(struct kvm *kvm, gfn_t gfn)
+{
+	gfn_t gfn_shared_mask = kvm->arch.gfn_shared_mask;
+
+	return gfn_shared_mask && !(gfn_shared_mask & gfn);
+}
+
+bool kvm_vcpu_is_private_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
+{
+	return kvm_is_private_gfn(vcpu->kvm, gfn);
+}
+
+static void kvm_mmu_link_private_sp(struct kvm_vcpu *vcpu,
+				    struct kvm_mmu_page *sp)
+{
+	void *p = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_private_sp_cache);
+
+	if (!static_call(kvm_x86_link_private_sp)(vcpu->kvm, sp->gfn,
+						  sp->role.level + 1, p))
+		sp->private_sp = p;
+	else
+		free_page((unsigned long)p);
+}
+
+static void kvm_mmu_zap_alias_spte(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+{
+	struct kvm_shadow_walk_iterator it;
+	struct kvm_rmap_head *rmap_head;
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_memslots *slots;
+	struct kvm_memory_slot *slot;
+	struct rmap_iterator iter;
+	struct kvm_mmu_page *sp;
+	gpa_t gpa_alias = fault->addr ^
+		(vcpu->kvm->arch.gfn_shared_mask << PAGE_SHIFT);
+	u64 *sptep;
+	u64 spte;
+
+	for_each_shadow_entry(vcpu, gpa_alias, it) {
+		if (!is_shadow_present_pte(*it.sptep))
+			break;
+	}
+
+	spte = *it.sptep;
+	sp = sptep_to_sp(it.sptep);
+
+	if (!is_last_spte(spte, sp->role.level))
+		return;
+
+	/*
+	 * multiple vcpus can race to zap same alias spte when vcpus caused EPT
+	 * violation on same gpa and come to __direct_map() at the same time.
+	 * In such case, __direct_map() handles it as spurious.
+	 *
+	 * rmap (or __kvm_zap_rmapp()) doesn't distinguish private/shared gpa.
+	 * And rmap is not supposed to co-exit with both shared and private
+	 * spte.  Check if other vcpu already zapped alias and established rmap
+	 * for same gpa to avoid zapping faulting gpa.
+	 *
+	 * shared  gpa_alias: !is_shadow_present_pte(spte)
+	 *                    is_zapped_private_pte(spte) is always false
+	 * private gpa_alias: !is_shadow_present_pte(spte) &&
+	 *                    !is_zapped_private_pte(spte)
+	 */
+	if (!is_shadow_present_pte(spte) && !is_zapped_private_pte(spte))
+		return;
+
+	slots = kvm_memslots_for_spte_role(kvm, sp->role);
+	slot = __gfn_to_memslot(slots, fault->gfn);
+	rmap_head = gfn_to_rmap(fault->gfn, sp->role.level, slot);
+	if (__kvm_zap_rmapp(kvm, rmap_head))
+		kvm_flush_remote_tlbs_with_address(kvm, fault->gfn, 1);
+
+	if (!is_private_sp(sp))
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
 static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_shadow_walk_iterator it;
 	struct kvm_mmu_page *sp;
 	int ret;
-	gpa_t gpa = fault->addr;
-	gpa_t gpa_stolen_mask = vcpu_gpa_stolen_mask(vcpu);
-	gfn_t gfn_stolen_bits = (gpa & gpa_stolen_mask) >> PAGE_SHIFT;
 	gfn_t base_gfn = fault->gfn;
+	bool is_private = kvm_vcpu_is_private_gfn(vcpu, fault->addr >> PAGE_SHIFT);
+	bool is_zapped_pte;
+
+	if (is_error_noslot_pfn(fault->pfn) || kvm_is_reserved_pfn(fault->pfn)) {
+		if (is_private)
+			return -EFAULT;
+	} else if (vcpu->kvm->arch.gfn_shared_mask) {
+		kvm_mmu_zap_alias_spte(vcpu, fault);
+	}
 
 	kvm_mmu_hugepage_adjust(vcpu, fault);
 
@@ -3026,24 +3257,39 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		if (is_shadow_present_pte(*it.sptep))
 			continue;
 
-		sp = __kvm_mmu_get_page(vcpu, base_gfn, gfn_stolen_bits,
-					it.addr, it.level - 1, true, ACC_ALL);
+		sp = kvm_mmu_get_page(vcpu, base_gfn, it.addr, it.level - 1,
+				true, ACC_ALL, is_private);
 
 		link_shadow_page(vcpu, it.sptep, sp);
 		if (fault->is_tdp && fault->huge_page_disallowed &&
 		    fault->req_level >= it.level)
 			account_huge_nx_page(vcpu->kvm, sp);
+		if (is_private)
+			kvm_mmu_link_private_sp(vcpu, sp);
 	}
 
 	if (WARN_ON_ONCE(it.level != fault->goal_level))
 		return -EFAULT;
 
+	is_zapped_pte = is_zapped_private_pte(*it.sptep);
+
 	ret = mmu_set_spte(vcpu, fault->slot, it.sptep, ACC_ALL,
 			   base_gfn, fault->pfn, fault);
 	if (ret == RET_PF_SPURIOUS)
 		return ret;
 
-	direct_pte_prefetch(vcpu, it.sptep);
+	if (!is_private) {
+		if (!vcpu->arch.mmu->no_prefetch)
+			direct_pte_prefetch(vcpu, it.sptep);
+	} else if (!WARN_ON_ONCE(ret != RET_PF_FIXED)) {
+		if (is_zapped_pte)
+			static_call(kvm_x86_unzap_private_spte)(
+				vcpu->kvm, base_gfn, it.level);
+		else
+			static_call(kvm_x86_set_private_spte)(
+				vcpu->kvm, base_gfn, it.level, fault->pfn);
+	}
+
 	++vcpu->stat.pf_fixed;
 	return ret;
 }
@@ -3204,6 +3450,14 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	u64 *sptep = NULL;
 	uint retry_count = 0;
 
+	/*
+	 * TDX private mapping doesn't support fast page fault, since there's
+	 * no secure EPT API to support it.
+	 */
+	if (fault->is_tdp &&
+		kvm_is_private_gfn(vcpu->kvm, fault->addr >> PAGE_SHIFT))
+		return ret;
+
 	if (!page_fault_can_be_fast(fault))
 		return ret;
 
@@ -3333,7 +3587,9 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			    VALID_PAGE(mmu->prev_roots[i].hpa))
 				break;
 
-		if (i == KVM_MMU_NUM_PREV_ROOTS)
+		if (i == KVM_MMU_NUM_PREV_ROOTS &&
+		    (!(roots_to_free & KVM_MMU_ROOT_PRIVATE) ||
+		     !VALID_PAGE(mmu->private_root_hpa)))
 			return;
 	}
 
@@ -3362,6 +3618,9 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 		mmu->root_pgd = 0;
 	}
 
+	if (roots_to_free & KVM_MMU_ROOT_PRIVATE)
+		mmu_free_root_page(kvm, &mmu->private_root_hpa, &invalid_list);
+
 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
 	write_unlock(&kvm->mmu_lock);
 }
@@ -3407,11 +3666,12 @@ static int mmu_check_root(struct kvm_vcpu *vcpu, gfn_t root_gfn)
 }
 
 static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, gva_t gva,
-			    u8 level, bool direct)
+			    u8 level, bool direct, bool private)
 {
 	struct kvm_mmu_page *sp;
 
-	sp = kvm_mmu_get_page(vcpu, gfn, gva, level, direct, ACC_ALL);
+	sp = kvm_mmu_get_page(vcpu, gfn, gva, level, direct, ACC_ALL,
+			private);
 	++sp->root_count;
 
 	return __pa(sp->spt);
@@ -3421,6 +3681,7 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	u8 shadow_root_level = mmu->shadow_root_level;
+	gfn_t gfn_shared = vcpu->kvm->arch.gfn_shared_mask;
 	hpa_t root;
 	unsigned i;
 	int r;
@@ -3434,9 +3695,17 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
 		mmu->root_hpa = root;
 	} else if (shadow_root_level >= PT64_ROOT_4LEVEL) {
-		root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level, true);
-		mmu->root_hpa = root;
+		if (gfn_shared && !VALID_PAGE(vcpu->arch.mmu->private_root_hpa)) {
+			root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level,
+					true, true);
+			vcpu->arch.mmu->private_root_hpa = root;
+		}
+		root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level, true,
+				false);
+		vcpu->arch.mmu->root_hpa = root;
 	} else if (shadow_root_level == PT32E_ROOT_LEVEL) {
+		WARN_ON_ONCE(gfn_shared);
+
 		if (WARN_ON_ONCE(!mmu->pae_root)) {
 			r = -EIO;
 			goto out_unlock;
@@ -3446,7 +3715,8 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 			WARN_ON_ONCE(IS_VALID_PAE_ROOT(mmu->pae_root[i]));
 
 			root = mmu_alloc_root(vcpu, i << (30 - PAGE_SHIFT),
-					      i << 30, PT32_ROOT_LEVEL, true);
+					      i << 30, PT32_ROOT_LEVEL, true,
+					      false);
 			mmu->pae_root[i] = root | PT_PRESENT_MASK |
 					   shadow_me_mask;
 		}
@@ -3569,8 +3839,8 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
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
@@ -3615,7 +3885,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 			root_gfn = pdptrs[i] >> PAGE_SHIFT;
 		}
 
-		root = mmu_alloc_root(vcpu, root_gfn, i << 30,
+		root = mmu_alloc_root(vcpu, root_gfn, 0, i << 30,
 				      PT32_ROOT_LEVEL, false);
 		mmu->pae_root[i] = root | pm_mask;
 	}
@@ -3984,7 +4254,7 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	bool async;
 
 	/* Don't expose aliases for no slot GFNs or private memslots */
-	if ((fault->addr & vcpu_gpa_stolen_mask(vcpu)) &&
+	if ((fault->addr & kvm_gpa_stolen_mask(vcpu->kvm)) &&
 	    !kvm_is_visible_memslot(slot)) {
 		fault->pfn = KVM_PFN_NOSLOT;
 		return false;
@@ -4053,7 +4323,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	unsigned long mmu_seq;
 	int r;
 
-	fault->gfn = vcpu_gpa_to_gfn_unalias(vcpu, fault->addr);
+	fault->gfn = kvm_gfn_unalias(vcpu->kvm, fault->addr);
 	fault->slot = kvm_vcpu_gfn_to_memslot(vcpu, fault->gfn);
 
 	if (page_fault_handle_page_track(vcpu, fault))
@@ -4150,7 +4420,8 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	while (fault->max_level > PG_LEVEL_4K) {
 		int page_num = KVM_PAGES_PER_HPAGE(fault->max_level);
-		gfn_t base = (fault->addr >> PAGE_SHIFT) & ~(page_num - 1);
+		gfn_t base = kvm_gfn_unalias(vcpu->kvm, fault->addr) &
+			~(page_num - 1);
 
 		if (kvm_mtrr_check_gfn_range_consistency(vcpu, base, page_num))
 			break;
@@ -5153,14 +5424,19 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
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
@@ -5565,8 +5841,10 @@ static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
 	int i;
 
 	mmu->root_hpa = INVALID_PAGE;
+	mmu->private_root_hpa = INVALID_PAGE;
 	mmu->root_pgd = 0;
 	mmu->translate_gpa = translate_gpa;
+	mmu->no_prefetch = false;
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
 		mmu->prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
 
@@ -5912,6 +6190,9 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 		sp = sptep_to_sp(sptep);
 		pfn = spte_to_pfn(*sptep);
 
+		/* Private page dirty logging is not supported. */
+		KVM_BUG_ON(is_private_spte(sptep), kvm);
+
 		/*
 		 * We cannot do huge page mapping for indirect shadow pages,
 		 * which are found on the last rmap (level = 1) when not using
@@ -6010,7 +6291,7 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
 }
 
-void kvm_mmu_zap_all(struct kvm *kvm)
+static void __kvm_mmu_zap_all(struct kvm *kvm, struct list_head *mmu_pages)
 {
 	struct kvm_mmu_page *sp, *node;
 	LIST_HEAD(invalid_list);
@@ -6018,7 +6299,7 @@ void kvm_mmu_zap_all(struct kvm *kvm)
 
 	write_lock(&kvm->mmu_lock);
 restart:
-	list_for_each_entry_safe(sp, node, &kvm->arch.active_mmu_pages, link) {
+	list_for_each_entry_safe(sp, node, mmu_pages, link) {
 		if (WARN_ON(sp->role.invalid))
 			continue;
 		if (__kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list, &ign))
@@ -6026,7 +6307,6 @@ void kvm_mmu_zap_all(struct kvm *kvm)
 		if (cond_resched_rwlock_write(&kvm->mmu_lock))
 			goto restart;
 	}
-
 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
 
 	if (is_tdp_mmu_enabled(kvm))
@@ -6035,6 +6315,12 @@ void kvm_mmu_zap_all(struct kvm *kvm)
 	write_unlock(&kvm->mmu_lock);
 }
 
+void kvm_mmu_zap_all_active(struct kvm *kvm)
+{
+	__kvm_mmu_zap_all(kvm, &kvm->arch.active_mmu_pages);
+	__kvm_mmu_zap_all(kvm, &kvm->arch.private_mmu_pages);
+}
+
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
 {
 	WARN_ON(gen & KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS);
@@ -6254,7 +6540,7 @@ unsigned long kvm_mmu_calculate_default_mmu_pages(struct kvm *kvm)
 
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 {
-	kvm_mmu_unload(vcpu);
+	__kvm_mmu_unload(vcpu, KVM_MMU_ROOTS_ALL_INC_PRIVATE);
 	free_mmu_pages(&vcpu->arch.root_mmu);
 	free_mmu_pages(&vcpu->arch.guest_mmu);
 	mmu_free_memory_caches(vcpu);
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 90de2d2ebfff..d718a1783112 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -49,11 +49,12 @@ struct kvm_mmu_page {
 	 */
 	union kvm_mmu_page_role role;
 	gfn_t gfn;
-	gfn_t gfn_stolen_bits;
 
 	u64 *spt;
 	/* hold the gfn of each spte inside spt */
 	gfn_t *gfns;
+	/* associated private shadow page, e.g. SEPT page */
+	void *private_sp;
 	/* Currently serving as active root */
 	union {
 		int root_count;
@@ -105,6 +106,16 @@ static inline int kvm_mmu_page_as_id(struct kvm_mmu_page *sp)
 	return kvm_mmu_role_as_id(sp->role);
 }
 
+static inline bool is_private_sp(struct kvm_mmu_page *sp)
+{
+	return sp->role.private;
+}
+
+static inline bool is_private_spte(u64 *sptep)
+{
+	return is_private_sp(sptep_to_sp(sptep));
+}
+
 static inline bool kvm_vcpu_ad_need_write_protect(struct kvm_vcpu *vcpu)
 {
 	/*
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 80e821996728..3e1759c68912 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -25,7 +25,7 @@
 	#define guest_walker guest_walker64
 	#define FNAME(name) paging##64_##name
 	#define PT_BASE_ADDR_MASK GUEST_PT64_BASE_ADDR_MASK
-	#define PT_LVL_ADDR_MASK(vcpu, lvl) (~vcpu_gpa_stolen_mask(vcpu) & \
+	#define PT_LVL_ADDR_MASK(vcpu, lvl) (~kvm_gpa_stolen_mask(vcpu->kvm) & \
 					     PT64_LVL_ADDR_MASK(lvl))
 	#define PT_LVL_OFFSET_MASK(lvl) PT64_LVL_OFFSET_MASK(lvl)
 	#define PT_INDEX(addr, level) PT64_INDEX(addr, level)
@@ -567,7 +567,7 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	gfn_t gfn;
 	kvm_pfn_t pfn;
 
-	WARN_ON(gpte & vcpu_gpa_stolen_mask(vcpu));
+	WARN_ON(gpte & kvm_gpa_stolen_mask(vcpu->kvm));
 
 	if (FNAME(prefetch_invalid_gpte)(vcpu, sp, spte, gpte))
 		return false;
@@ -670,7 +670,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	WARN_ON_ONCE(gw->gfn != base_gfn);
 	direct_access = gw->pte_access;
 
-	WARN_ON(fault->addr & vcpu_gpa_stolen_mask(vcpu));
+	WARN_ON(fault->addr & kvm_gpa_stolen_mask(vcpu->kvm));
 
 	top_level = vcpu->arch.mmu->root_level;
 	if (top_level == PT32E_ROOT_LEVEL)
@@ -700,7 +700,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 			table_gfn = gw->table_gfn[it.level - 2];
 			access = gw->pt_access[it.level - 2];
 			sp = kvm_mmu_get_page(vcpu, table_gfn, fault->addr,
-					      it.level-1, false, access);
+					      it.level-1, false, access, false);
 			/*
 			 * We must synchronize the pagetable before linking it
 			 * because the guest doesn't need to flush tlb when
@@ -757,7 +757,8 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 
 		if (!is_shadow_present_pte(*it.sptep)) {
 			sp = kvm_mmu_get_page(vcpu, base_gfn, fault->addr,
-					      it.level - 1, true, direct_access);
+					      it.level - 1, true, direct_access,
+					      false);
 			link_shadow_page(vcpu, it.sptep, sp);
 			if (fault->huge_page_disallowed &&
 			    fault->req_level >= it.level)
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index b53b301301dc..43f0d2a773f7 100644
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
@@ -95,11 +98,11 @@ static_assert(!(EPT_SPTE_MMU_WRITABLE & SHADOW_ACC_TRACK_SAVED_MASK));
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
@@ -113,7 +116,7 @@ static_assert(!(EPT_SPTE_MMU_WRITABLE & SHADOW_ACC_TRACK_SAVED_MASK));
 #define MMIO_SPTE_GEN_LOW_END		10
 
 #define MMIO_SPTE_GEN_HIGH_START	52
-#define MMIO_SPTE_GEN_HIGH_END		62
+#define MMIO_SPTE_GEN_HIGH_END		61
 
 #define MMIO_SPTE_GEN_LOW_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_END, \
 						    MMIO_SPTE_GEN_LOW_START)
@@ -126,7 +129,7 @@ static_assert(!(SPTE_MMU_PRESENT_MASK &
 #define MMIO_SPTE_GEN_HIGH_BITS		(MMIO_SPTE_GEN_HIGH_END - MMIO_SPTE_GEN_HIGH_START + 1)
 
 /* remember to adjust the comment above as well if you change these */
-static_assert(MMIO_SPTE_GEN_LOW_BITS == 8 && MMIO_SPTE_GEN_HIGH_BITS == 11);
+static_assert(MMIO_SPTE_GEN_LOW_BITS == 8 && MMIO_SPTE_GEN_HIGH_BITS == 10);
 
 #define MMIO_SPTE_GEN_LOW_SHIFT		(MMIO_SPTE_GEN_LOW_START - 0)
 #define MMIO_SPTE_GEN_HIGH_SHIFT	(MMIO_SPTE_GEN_HIGH_START - MMIO_SPTE_GEN_LOW_BITS)
@@ -267,6 +270,11 @@ static inline bool is_access_track_spte(u64 spte)
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
index c6e56f105673..4dd8ec2641a2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11436,6 +11436,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	INIT_HLIST_HEAD(&kvm->arch.mask_notifier_list);
 	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
+	INIT_LIST_HEAD(&kvm->arch.private_mmu_pages);
 	INIT_LIST_HEAD(&kvm->arch.zapped_obsolete_pages);
 	INIT_LIST_HEAD(&kvm->arch.lpage_disallowed_mmu_pages);
 	INIT_LIST_HEAD(&kvm->arch.assigned_dev_head);
@@ -11872,7 +11873,14 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
-	kvm_mmu_zap_all(kvm);
+	/*
+	 * kvm_mmu_zap_all_active() zaps both private and shared page tables.
+	 * Before tearing down private page tables, TDX requires TD has started
+	 * to be destroyed (i.e. keyID must have been reclaimed, etc).  Invoke
+	 * kvm_x86_mmu_prezap() for this.
+	 */
+	static_call_cond(kvm_x86_mmu_prezap)(kvm);
+	kvm_mmu_zap_all_active(kvm);
 }
 
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5bf456734e7d..b56d97d43ad9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -190,6 +190,7 @@ bool kvm_is_reserved_pfn(kvm_pfn_t pfn)
 
 	return true;
 }
+EXPORT_SYMBOL_GPL(kvm_is_reserved_pfn);
 
 /*
  * Switches to specified vcpu, until a matching vcpu_put()
-- 
2.25.1

