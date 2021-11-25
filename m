Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7405845D1BB
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 01:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353524AbhKYAZG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 19:25:06 -0500
Received: from mga14.intel.com ([192.55.52.115]:6415 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352926AbhKYAYZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 19:24:25 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="235649720"
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="235649720"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:14 -0800
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="675042218"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:14 -0800
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
        Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [RFC PATCH v3 31/59] KVM: x86: Add infrastructure for stolen GPA bits
Date:   Wed, 24 Nov 2021 16:20:14 -0800
Message-Id: <89046548aa74778658c6e66d219e157e71e439ab.1637799475.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Rick Edgecombe <rick.p.edgecombe@intel.com>

Add support in KVM's MMU for aliasing multiple GPAs (from a hardware
perspective) to a single GPA (from a memslot perspective). GPA alising
will be used to repurpose GPA bits as attribute bits, e.g. to expose an
execute-only permission bit to the guest. To keep the implementation
simple (relatively speaking), GPA aliasing is only supported via TDP.

Today KVM assumes two things that are broken by GPA aliasing.
  1. GPAs coming from hardware can be simply shifted to get the GFNs.
  2. GPA bits 51:MAXPHYADDR are reserved to zero.

With GPA aliasing, translating a GPA to GFN requires masking off the
repurposed bit, and a repurposed bit may reside in 51:MAXPHYADDR.

To support GPA aliasing, introduce the concept of per-VM GPA stolen bits,
that is, bits stolen from the GPA to act as new virtualized attribute
bits. A bit in the mask will cause the MMU code to create aliases of the
GPA. It can also be used to find the GFN out of a GPA coming from a tdp
fault.

To handle case (1) from above, retain any stolen bits when passing a GPA
in KVM's MMU code, but strip them when converting to a GFN so that the
GFN contains only the "real" GFN, i.e. never has repurposed bits set.

GFNs (without stolen bits) continue to be used to:
	-Specify physical memory by userspace via memslots
	-Map GPAs to TDP PTEs via RMAP
	-Specify dirty tracking and write protection
	-Look up MTRR types
	-Inject async page faults

Since there are now multiple aliases for the same aliased GPA, when
userspace memory backing the memslots is paged out, both aliases need to be
modified. Fortunately this happens automatically. Since rmap supports
multiple mappings for the same GFN for PTE shadowing based paging, by
adding/removing each alias PTE with its GFN, kvm_handle_hva() based
operations will be applied to both aliases.

In the case of the rmap being removed in the future, the needed
information could be recovered by iterating over the stolen bits and
walking the TDP page tables.

For TLB flushes that are address based, make sure to flush both aliases
in the stolen bits case.

Only support stolen bits in 64 bit guest paging modes (long, PAE).
Features that use this infrastructure should restrict the stolen bits to
exclude the other paging modes. Don't support stolen bits for shadow EPT.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu.h              | 27 +++++++++++
 arch/x86/kvm/mmu/mmu.c          | 82 +++++++++++++++++++++++----------
 arch/x86/kvm/mmu/mmu_internal.h |  1 +
 arch/x86/kvm/mmu/paging_tmpl.h  | 25 ++++++----
 4 files changed, 100 insertions(+), 35 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 9ae6168d381e..583483bb6f71 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -351,4 +351,31 @@ static inline void kvm_update_page_stats(struct kvm *kvm, int level, int count)
 {
 	atomic64_add(count, &kvm->stat.pages[level - 1]);
 }
+
+static inline gfn_t kvm_gfn_stolen_mask(struct kvm *kvm)
+{
+	/* Currently there are no stolen bits in KVM */
+	return 0;
+}
+
+static inline gfn_t vcpu_gfn_stolen_mask(struct kvm_vcpu *vcpu)
+{
+	return kvm_gfn_stolen_mask(vcpu->kvm);
+}
+
+static inline gpa_t kvm_gpa_stolen_mask(struct kvm *kvm)
+{
+	return kvm_gfn_stolen_mask(kvm) << PAGE_SHIFT;
+}
+
+static inline gpa_t vcpu_gpa_stolen_mask(struct kvm_vcpu *vcpu)
+{
+	return kvm_gpa_stolen_mask(vcpu->kvm);
+}
+
+static inline gfn_t vcpu_gpa_to_gfn_unalias(struct kvm_vcpu *vcpu, gpa_t gpa)
+{
+	return (gpa >> PAGE_SHIFT) & ~vcpu_gfn_stolen_mask(vcpu);
+}
+
 #endif
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1e11b14f4f82..5305d1d9a976 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -276,27 +276,37 @@ static inline bool kvm_available_flush_tlb_with_range(void)
 	return kvm_x86_ops.tlb_remote_flush_with_range;
 }
 
-static void kvm_flush_remote_tlbs_with_range(struct kvm *kvm,
-		struct kvm_tlb_range *range)
-{
-	int ret = -ENOTSUPP;
-
-	if (range && kvm_x86_ops.tlb_remote_flush_with_range)
-		ret = static_call(kvm_x86_tlb_remote_flush_with_range)(kvm, range);
-
-	if (ret)
-		kvm_flush_remote_tlbs(kvm);
-}
-
 void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
 		u64 start_gfn, u64 pages)
 {
 	struct kvm_tlb_range range;
+	u64 gfn_stolen_mask;
+
+	if (!kvm_available_flush_tlb_with_range())
+		goto generic_flush;
+
+	/*
+	 * Fall back to the big hammer flush if there is more than one
+	 * GPA alias that needs to be flushed.
+	 */
+	gfn_stolen_mask = kvm_gfn_stolen_mask(kvm);
+	if (hweight64(gfn_stolen_mask) > 1)
+		goto generic_flush;
 
 	range.start_gfn = start_gfn;
 	range.pages = pages;
+	if (static_call(kvm_x86_tlb_remote_flush_with_range)(kvm, &range))
+		goto generic_flush;
 
-	kvm_flush_remote_tlbs_with_range(kvm, &range);
+	if (!gfn_stolen_mask)
+		return;
+
+	range.start_gfn |= gfn_stolen_mask;
+	static_call(kvm_x86_tlb_remote_flush_with_range)(kvm, &range);
+	return;
+
+generic_flush:
+	kvm_flush_remote_tlbs(kvm);
 }
 
 static void mark_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, u64 gfn,
@@ -2067,14 +2077,16 @@ static void clear_sp_write_flooding_count(u64 *spte)
 	__clear_sp_write_flooding_count(sptep_to_sp(spte));
 }
 
-static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
-					     gfn_t gfn,
-					     gva_t gaddr,
-					     unsigned level,
-					     int direct,
-					     unsigned int access)
+static struct kvm_mmu_page *__kvm_mmu_get_page(struct kvm_vcpu *vcpu,
+					       gfn_t gfn,
+					       gfn_t gfn_stolen_bits,
+					       gva_t gaddr,
+					       unsigned int level,
+					       int direct,
+					       unsigned int access)
 {
 	bool direct_mmu = vcpu->arch.mmu->direct_map;
+	gpa_t gfn_and_stolen = gfn | gfn_stolen_bits;
 	union kvm_mmu_page_role role;
 	struct hlist_head *sp_list;
 	unsigned quadrant;
@@ -2094,9 +2106,9 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 		role.quadrant = quadrant;
 	}
 
-	sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
+	sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn_and_stolen)];
 	for_each_valid_sp(vcpu->kvm, sp, sp_list) {
-		if (sp->gfn != gfn) {
+		if ((sp->gfn | sp->gfn_stolen_bits) != gfn_and_stolen) {
 			collisions++;
 			continue;
 		}
@@ -2152,6 +2164,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	sp = kvm_mmu_alloc_page(vcpu, direct);
 
 	sp->gfn = gfn;
+	sp->gfn_stolen_bits = gfn_stolen_bits;
 	sp->role = role;
 	hlist_add_head(&sp->hash_link, sp_list);
 	if (!direct) {
@@ -2168,6 +2181,13 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	return sp;
 }
 
+static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
+					     gva_t gaddr, unsigned int level,
+					     int direct, unsigned int access)
+{
+	return __kvm_mmu_get_page(vcpu, gfn, 0, gaddr, level, direct, access);
+}
+
 static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterator,
 					struct kvm_vcpu *vcpu, hpa_t root,
 					u64 addr)
@@ -2768,7 +2788,9 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
 
 	gfn = kvm_mmu_page_get_gfn(sp, start - sp->spt);
 	slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn, access & ACC_WRITE_MASK);
-	if (!slot)
+
+	/* Don't map private memslots for stolen bits */
+	if (!slot || (sp->gfn_stolen_bits && slot->id >= KVM_USER_MEM_SLOTS))
 		return -1;
 
 	ret = gfn_to_page_many_atomic(slot, gfn, pages, end - start);
@@ -2945,6 +2967,9 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	struct kvm_shadow_walk_iterator it;
 	struct kvm_mmu_page *sp;
 	int ret;
+	gpa_t gpa = fault->addr;
+	gpa_t gpa_stolen_mask = vcpu_gpa_stolen_mask(vcpu);
+	gfn_t gfn_stolen_bits = (gpa & gpa_stolen_mask) >> PAGE_SHIFT;
 	gfn_t base_gfn = fault->gfn;
 
 	kvm_mmu_hugepage_adjust(vcpu, fault);
@@ -2966,8 +2991,8 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		if (is_shadow_present_pte(*it.sptep))
 			continue;
 
-		sp = kvm_mmu_get_page(vcpu, base_gfn, it.addr,
-				      it.level - 1, true, ACC_ALL);
+		sp = __kvm_mmu_get_page(vcpu, base_gfn, gfn_stolen_bits,
+					it.addr, it.level - 1, true, ACC_ALL);
 
 		link_shadow_page(vcpu, it.sptep, sp);
 		if (fault->is_tdp && fault->huge_page_disallowed &&
@@ -3923,6 +3948,13 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	struct kvm_memory_slot *slot = fault->slot;
 	bool async;
 
+	/* Don't expose aliases for no slot GFNs or private memslots */
+	if ((fault->addr & vcpu_gpa_stolen_mask(vcpu)) &&
+	    !kvm_is_visible_memslot(slot)) {
+		fault->pfn = KVM_PFN_NOSLOT;
+		return false;
+	}
+
 	/*
 	 * Retry the page fault if the gfn hit a memslot that is being deleted
 	 * or moved.  This ensures any existing SPTEs for the old memslot will
@@ -3986,7 +4018,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	unsigned long mmu_seq;
 	int r;
 
-	fault->gfn = fault->addr >> PAGE_SHIFT;
+	fault->gfn = vcpu_gpa_to_gfn_unalias(vcpu, fault->addr);
 	fault->slot = kvm_vcpu_gfn_to_memslot(vcpu, fault->gfn);
 
 	if (page_fault_handle_page_track(vcpu, fault))
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 52c6527b1a06..90de2d2ebfff 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -49,6 +49,7 @@ struct kvm_mmu_page {
 	 */
 	union kvm_mmu_page_role role;
 	gfn_t gfn;
+	gfn_t gfn_stolen_bits;
 
 	u64 *spt;
 	/* hold the gfn of each spte inside spt */
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index f87d36898c44..3a515c71e09c 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -25,7 +25,8 @@
 	#define guest_walker guest_walker64
 	#define FNAME(name) paging##64_##name
 	#define PT_BASE_ADDR_MASK GUEST_PT64_BASE_ADDR_MASK
-	#define PT_LVL_ADDR_MASK(lvl) PT64_LVL_ADDR_MASK(lvl)
+	#define PT_LVL_ADDR_MASK(vcpu, lvl) (~vcpu_gpa_stolen_mask(vcpu) & \
+					     PT64_LVL_ADDR_MASK(lvl))
 	#define PT_LVL_OFFSET_MASK(lvl) PT64_LVL_OFFSET_MASK(lvl)
 	#define PT_INDEX(addr, level) PT64_INDEX(addr, level)
 	#define PT_LEVEL_BITS PT64_LEVEL_BITS
@@ -44,7 +45,7 @@
 	#define guest_walker guest_walker32
 	#define FNAME(name) paging##32_##name
 	#define PT_BASE_ADDR_MASK PT32_BASE_ADDR_MASK
-	#define PT_LVL_ADDR_MASK(lvl) PT32_LVL_ADDR_MASK(lvl)
+	#define PT_LVL_ADDR_MASK(vcpu, lvl) PT32_LVL_ADDR_MASK(lvl)
 	#define PT_LVL_OFFSET_MASK(lvl) PT32_LVL_OFFSET_MASK(lvl)
 	#define PT_INDEX(addr, level) PT32_INDEX(addr, level)
 	#define PT_LEVEL_BITS PT32_LEVEL_BITS
@@ -58,7 +59,7 @@
 	#define guest_walker guest_walkerEPT
 	#define FNAME(name) ept_##name
 	#define PT_BASE_ADDR_MASK GUEST_PT64_BASE_ADDR_MASK
-	#define PT_LVL_ADDR_MASK(lvl) PT64_LVL_ADDR_MASK(lvl)
+	#define PT_LVL_ADDR_MASK(vcpu, lvl) PT64_LVL_ADDR_MASK(lvl)
 	#define PT_LVL_OFFSET_MASK(lvl) PT64_LVL_OFFSET_MASK(lvl)
 	#define PT_INDEX(addr, level) PT64_INDEX(addr, level)
 	#define PT_LEVEL_BITS PT64_LEVEL_BITS
@@ -75,7 +76,7 @@
 #define PT_GUEST_ACCESSED_MASK (1 << PT_GUEST_ACCESSED_SHIFT)
 
 #define gpte_to_gfn_lvl FNAME(gpte_to_gfn_lvl)
-#define gpte_to_gfn(pte) gpte_to_gfn_lvl((pte), PG_LEVEL_4K)
+#define gpte_to_gfn(vcpu, pte) gpte_to_gfn_lvl(vcpu, pte, PG_LEVEL_4K)
 
 /*
  * The guest_walker structure emulates the behavior of the hardware page
@@ -96,9 +97,9 @@ struct guest_walker {
 	struct x86_exception fault;
 };
 
-static gfn_t gpte_to_gfn_lvl(pt_element_t gpte, int lvl)
+static gfn_t gpte_to_gfn_lvl(struct kvm_vcpu *vcpu, pt_element_t gpte, int lvl)
 {
-	return (gpte & PT_LVL_ADDR_MASK(lvl)) >> PAGE_SHIFT;
+	return (gpte & PT_LVL_ADDR_MASK(vcpu, lvl)) >> PAGE_SHIFT;
 }
 
 static inline void FNAME(protect_clean_gpte)(struct kvm_mmu *mmu, unsigned *access,
@@ -395,7 +396,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 		--walker->level;
 
 		index = PT_INDEX(addr, walker->level);
-		table_gfn = gpte_to_gfn(pte);
+		table_gfn = gpte_to_gfn(vcpu, pte);
 		offset    = index * sizeof(pt_element_t);
 		pte_gpa   = gfn_to_gpa(table_gfn) + offset;
 
@@ -461,7 +462,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	if (unlikely(errcode))
 		goto error;
 
-	gfn = gpte_to_gfn_lvl(pte, walker->level);
+	gfn = gpte_to_gfn_lvl(vcpu, pte, walker->level);
 	gfn += (addr & PT_LVL_OFFSET_MASK(walker->level)) >> PAGE_SHIFT;
 
 	if (PTTYPE == 32 && walker->level > PG_LEVEL_4K && is_cpuid_PSE36())
@@ -566,12 +567,14 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	gfn_t gfn;
 	kvm_pfn_t pfn;
 
+	WARN_ON(gpte & vcpu_gpa_stolen_mask(vcpu));
+
 	if (FNAME(prefetch_invalid_gpte)(vcpu, sp, spte, gpte))
 		return false;
 
 	pgprintk("%s: gpte %llx spte %p\n", __func__, (u64)gpte, spte);
 
-	gfn = gpte_to_gfn(gpte);
+	gfn = gpte_to_gfn(vcpu, gpte);
 	pte_access = sp->role.access & FNAME(gpte_access)(gpte);
 	FNAME(protect_clean_gpte)(vcpu->arch.mmu, &pte_access, gpte);
 
@@ -667,6 +670,8 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	WARN_ON_ONCE(gw->gfn != base_gfn);
 	direct_access = gw->pte_access;
 
+	WARN_ON(fault->addr & vcpu_gpa_stolen_mask(vcpu));
+
 	top_level = vcpu->arch.mmu->root_level;
 	if (top_level == PT32E_ROOT_LEVEL)
 		top_level = PT32_ROOT_LEVEL;
@@ -1111,7 +1116,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 			continue;
 		}
 
-		gfn = gpte_to_gfn(gpte);
+		gfn = gpte_to_gfn(vcpu, gpte);
 		pte_access = sp->role.access;
 		pte_access &= FNAME(gpte_access)(gpte);
 		FNAME(protect_clean_gpte)(vcpu->arch.mmu, &pte_access, gpte);
-- 
2.25.1

