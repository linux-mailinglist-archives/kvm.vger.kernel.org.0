Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA9F2762640
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232339AbjGYWUk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232318AbjGYWTx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:19:53 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBC8346A9;
        Tue, 25 Jul 2023 15:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690323414; x=1721859414;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TcAj6qtDbJdlu3C9bJRLWto/yTJqbDJNJ0pT5Zv4Tpc=;
  b=nDRxnUv3S7pKX3wDqtgv81n4JSPDuvrO0ro8C2umMlH50cIU6WfcPOb7
   0XTOp6lto+YVEw52AzXASXRYEJVOYj2Ee4G/XQxcY4rqgXUGc5roKaZRc
   LFg7loWXR8lOEUvqDVPzS34P3LiftqvLU4cRjFMY4lD/cpJi/AaLi2M5x
   cBq66WQ7pIfoOSxMFHTNeCvTh4hBk7ql+ASD9vyH2W8whZU9eT0MhtKYj
   0u1JFelVESW+QYqabOH4NW5BUY4M8fa14+qttBxZcXMw+H//dwb2j9xxf
   wlFHzoJ+TR8ybWl5AkHr6MmEsfUd4NQZDyq+GiTzey22wTANLumiqnSO/
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="357863282"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="357863282"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="1056938938"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="1056938938"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:38 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com
Subject: [PATCH v15 046/115] KVM: x86/tdp_mmu: Support TDX private mapping for TDP MMU
Date:   Tue, 25 Jul 2023 15:13:57 -0700
Message-Id: <9e641e1368b37e108ff8a8b1078a73588f7f9539.1690322424.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1690322424.git.isaku.yamahata@intel.com>
References: <cover.1690322424.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Allocate protected page table for private page table, and add hooks to
operate on protected page table.  This patch adds allocation/free of
protected page tables and hooks.  When calling hooks to update SPTE entry,
freeze the entry, call hooks and unfreeze the entry to allow concurrent
updates on page tables.  Which is the advantage of TDP MMU.  As
kvm_gfn_shared_mask() returns false always, those hooks aren't called yet
with this patch.

When the faulting GPA is private, the KVM fault is called private.  When
resolving private KVM fault, allocate protected page table and call hooks
to operate on protected page table. On the change of the private PTE entry,
invoke kvm_x86_ops hook in __handle_changed_spte() to propagate the change
to protected page table. The following depicts the relationship.

  private KVM page fault   |
      |                    |
      V                    |
 private GPA               |     CPU protected EPTP
      |                    |           |
      V                    |           V
 private PT root           |     protected PT root
      |                    |           |
      V                    |           V
   private PT --hook to propagate-->protected PT
      |                    |           |
      \--------------------+------\    |
                           |      |    |
                           |      V    V
                           |    private guest page
                           |
                           |
     non-encrypted memory  |    encrypted memory
                           |
PT: page table

The existing KVM TDP MMU code uses atomic update of SPTE.  On populating
the EPT entry, atomically set the entry.  However, it requires TLB
shootdown to zap SPTE.  To address it, the entry is frozen with the special
SPTE value that clears the present bit. After the TLB shootdown, the entry
is set to the eventual value (unfreeze).

For protected page table, hooks are called to update protected page table
in addition to direct access to the private SPTE. For the zapping case, it
works to freeze the SPTE. It can call hooks in addition to TLB shootdown.
For populating the private SPTE entry, there can be a race condition
without further protection

  vcpu 1: populating 2M private SPTE
  vcpu 2: populating 4K private SPTE
  vcpu 2: TDX SEAMCALL to update 4K protected SPTE => error
  vcpu 1: TDX SEAMCALL to update 2M protected SPTE

To avoid the race, the frozen SPTE is utilized.  Instead of atomic update
of the private entry, freeze the entry, call the hook that update protected
SPTE, set the entry to the final value.

Support 4K page only at this stage.  2M page support can be done in future
patches.

Co-developed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

---
v14 -> v15:
- Refined is_private condition check in kvm_tdp_mmu_map().
  Add kvm_gfn_shared_mask() check.
- catch up for struct kvm_range change

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |   5 +
 arch/x86/include/asm/kvm_host.h    |  11 ++
 arch/x86/kvm/mmu/mmu.c             |  13 +-
 arch/x86/kvm/mmu/mmu_internal.h    |  19 +-
 arch/x86/kvm/mmu/tdp_iter.h        |   2 +-
 arch/x86/kvm/mmu/tdp_mmu.c         | 293 +++++++++++++++++++++++++----
 arch/x86/kvm/mmu/tdp_mmu.h         |   2 +-
 virt/kvm/kvm_main.c                |   1 +
 8 files changed, 307 insertions(+), 39 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index bcf04a75b506..49f19cfeb11d 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -98,6 +98,11 @@ KVM_X86_OP_OPTIONAL_RET0(set_tss_addr)
 KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
 KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
 KVM_X86_OP(load_mmu_pgd)
+KVM_X86_OP_OPTIONAL(link_private_spt)
+KVM_X86_OP_OPTIONAL(free_private_spt)
+KVM_X86_OP_OPTIONAL(set_private_spte)
+KVM_X86_OP_OPTIONAL(remove_private_spte)
+KVM_X86_OP_OPTIONAL(zap_private_spte)
 KVM_X86_OP(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
 KVM_X86_OP(get_l2_tsc_multiplier)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a57c2c96ffc4..9705e9f30068 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -475,6 +475,7 @@ struct kvm_mmu {
 	int (*sync_spte)(struct kvm_vcpu *vcpu,
 			 struct kvm_mmu_page *sp, int i);
 	struct kvm_mmu_root_info root;
+	hpa_t private_root_hpa;
 	union kvm_cpu_role cpu_role;
 	union kvm_mmu_page_role root_role;
 
@@ -1698,6 +1699,16 @@ struct kvm_x86_ops {
 	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			     int root_level);
 
+	int (*link_private_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				void *private_spt);
+	int (*free_private_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				void *private_spt);
+	int (*set_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				 kvm_pfn_t pfn);
+	int (*remove_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				    kvm_pfn_t pfn);
+	int (*zap_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level);
+
 	bool (*has_wbinvd_exit)(void);
 
 	u64 (*get_l2_tsc_offset)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 513083a14552..5b48ac4a5fbc 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3757,7 +3757,12 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 		goto out_unlock;
 
 	if (tdp_mmu_enabled) {
-		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
+		if (kvm_gfn_shared_mask(vcpu->kvm) &&
+		    !VALID_PAGE(mmu->private_root_hpa)) {
+			root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu, true);
+			mmu->private_root_hpa = root;
+		}
+		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu, false);
 		mmu->root.hpa = root;
 	} else if (shadow_root_level >= PT64_ROOT_4LEVEL) {
 		root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level);
@@ -4651,7 +4656,7 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	if (shadow_memtype_mask && kvm_arch_has_noncoherent_dma(vcpu->kvm)) {
 		for ( ; fault->max_level > PG_LEVEL_4K; --fault->max_level) {
 			int page_num = KVM_PAGES_PER_HPAGE(fault->max_level);
-			gfn_t base = gfn_round_for_level(fault->gfn,
+			gfn_t base = gfn_round_for_level(gpa_to_gfn(fault->addr),
 							 fault->max_level);
 
 			if (kvm_mtrr_check_gfn_range_consistency(vcpu, base, page_num))
@@ -6138,6 +6143,7 @@ static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
 
 	mmu->root.hpa = INVALID_PAGE;
 	mmu->root.pgd = 0;
+	mmu->private_root_hpa = INVALID_PAGE;
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
 		mmu->prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
 
@@ -7206,6 +7212,9 @@ int kvm_mmu_vendor_module_init(void)
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 {
 	kvm_mmu_unload(vcpu);
+	if (tdp_mmu_enabled)
+		mmu_free_root_page(vcpu->kvm, &vcpu->arch.mmu->private_root_hpa,
+				NULL);
 	free_mmu_pages(&vcpu->arch.root_mmu);
 	free_mmu_pages(&vcpu->arch.guest_mmu);
 	mmu_free_memory_caches(vcpu);
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 17ad9df1bb71..d65324d87a17 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -6,6 +6,8 @@
 #include <linux/kvm_host.h>
 #include <asm/kvm_host.h>
 
+#include "mmu.h"
+
 #undef MMU_DEBUG
 
 #ifdef MMU_DEBUG
@@ -204,6 +206,15 @@ static inline void kvm_mmu_free_private_spt(struct kvm_mmu_page *sp)
 	if (sp->private_spt)
 		free_page((unsigned long)sp->private_spt);
 }
+
+static inline gfn_t kvm_gfn_for_root(struct kvm *kvm, struct kvm_mmu_page *root,
+				     gfn_t gfn)
+{
+	if (is_private_sp(root))
+		return kvm_gfn_to_private(kvm, gfn);
+	else
+		return kvm_gfn_to_shared(kvm, gfn);
+}
 #else
 static inline void *kvm_mmu_private_spt(struct kvm_mmu_page *sp)
 {
@@ -221,6 +232,12 @@ static inline void kvm_mmu_alloc_private_spt(struct kvm_vcpu *vcpu, struct kvm_m
 static inline void kvm_mmu_free_private_spt(struct kvm_mmu_page *sp)
 {
 }
+
+static inline gfn_t kvm_gfn_for_root(struct kvm *kvm, struct kvm_mmu_page *root,
+				     gfn_t gfn)
+{
+	return gfn;
+}
 #endif
 
 static inline bool kvm_mmu_page_ad_need_write_protect(struct kvm_mmu_page *sp)
@@ -386,7 +403,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	int r;
 
 	if (vcpu->arch.mmu->root_role.direct) {
-		fault.gfn = fault.addr >> PAGE_SHIFT;
+		fault.gfn = gpa_to_gfn(fault.addr) & ~kvm_gfn_shared_mask(vcpu->kvm);
 		fault.slot = kvm_vcpu_gfn_to_memslot(vcpu, fault.gfn);
 	}
 
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index e1e40e3f5eb7..a9c9cd0db20a 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -91,7 +91,7 @@ struct tdp_iter {
 	tdp_ptep_t pt_path[PT64_ROOT_MAX_LEVEL];
 	/* A pointer to the current SPTE */
 	tdp_ptep_t sptep;
-	/* The lowest GFN mapped by the current SPTE */
+	/* The lowest GFN (shared bits included) mapped by the current SPTE */
 	gfn_t gfn;
 	/* The level of the root page given to the iterator */
 	int root_level;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index d3788a414551..95ba78944712 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -237,6 +237,9 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu,
 	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
 	sp->role = role;
 
+	if (kvm_mmu_page_role_is_private(role))
+		kvm_mmu_alloc_private_spt(vcpu, sp);
+
 	return sp;
 }
 
@@ -259,7 +262,8 @@ static void tdp_mmu_init_sp(struct kvm_mmu_page *sp, tdp_ptep_t sptep,
 	trace_kvm_mmu_get_page(sp, true);
 }
 
-hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
+static struct kvm_mmu_page *kvm_tdp_mmu_get_vcpu_root(struct kvm_vcpu *vcpu,
+						      bool private)
 {
 	union kvm_mmu_page_role role = vcpu->arch.mmu->root_role;
 	struct kvm *kvm = vcpu->kvm;
@@ -271,6 +275,8 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 	 * Check for an existing root before allocating a new one.  Note, the
 	 * role check prevents consuming an invalid root.
 	 */
+	if (private)
+		kvm_mmu_page_role_set_private(&role);
 	for_each_tdp_mmu_root(kvm, root, kvm_mmu_role_as_id(role)) {
 		if (root->role.word == role.word &&
 		    kvm_tdp_mmu_get_root(root))
@@ -294,12 +300,17 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 
 out:
-	return __pa(root->spt);
+	return root;
+}
+
+hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu, bool private)
+{
+	return __pa(kvm_tdp_mmu_get_vcpu_root(vcpu, private)->spt);
 }
 
 static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
-				u64 old_spte, u64 new_spte, int level,
-				bool shared);
+				u64 old_spte, u64 new_spte,
+				union kvm_mmu_page_role role, bool shared);
 
 static void tdp_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
@@ -436,12 +447,78 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
 							  REMOVED_SPTE, level);
 		}
 		handle_changed_spte(kvm, kvm_mmu_page_as_id(sp), gfn,
-				    old_spte, REMOVED_SPTE, level, shared);
+				    old_spte, REMOVED_SPTE, sp->role,
+				    shared);
+	}
+
+	if (is_private_sp(sp) &&
+	    WARN_ON(static_call(kvm_x86_free_private_spt)(kvm, sp->gfn, sp->role.level,
+							  kvm_mmu_private_spt(sp)))) {
+		/*
+		 * Failed to unlink Secure EPT page and there is nothing to do
+		 * further.  Intentionally leak the page to prevent the kernel
+		 * from accessing the encrypted page.
+		 */
+		kvm_mmu_init_private_spt(sp, NULL);
 	}
 
 	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
 }
 
+static void *get_private_spt(gfn_t gfn, u64 new_spte, int level)
+{
+	if (is_shadow_present_pte(new_spte) && !is_last_spte(new_spte, level)) {
+		struct kvm_mmu_page *sp = to_shadow_page(pfn_to_hpa(spte_to_pfn(new_spte)));
+		void *private_spt = kvm_mmu_private_spt(sp);
+
+		WARN_ON_ONCE(!private_spt);
+		WARN_ON_ONCE(sp->role.level + 1 != level);
+		WARN_ON_ONCE(sp->gfn != gfn);
+		return private_spt;
+	}
+
+	return NULL;
+}
+
+static void handle_removed_private_spte(struct kvm *kvm, gfn_t gfn,
+					u64 old_spte, u64 new_spte,
+					int level)
+{
+	bool was_present = is_shadow_present_pte(old_spte);
+	bool is_present = is_shadow_present_pte(new_spte);
+	bool was_leaf = was_present && is_last_spte(old_spte, level);
+	bool is_leaf = is_present && is_last_spte(new_spte, level);
+	kvm_pfn_t old_pfn = spte_to_pfn(old_spte);
+	kvm_pfn_t new_pfn = spte_to_pfn(new_spte);
+	int ret;
+
+	/* Ignore change of software only bits. e.g. host_writable */
+	if (was_leaf == is_leaf && was_present == is_present)
+		return;
+
+	/*
+	 * Allow only leaf page to be zapped.  Reclaim Non-leaf page tables at
+	 * destroying VM.
+	 */
+	WARN_ON_ONCE(is_present);
+	if (!was_leaf)
+		return;
+
+	/* non-present -> non-present doesn't make sense. */
+	KVM_BUG_ON(!was_present, kvm);
+	KVM_BUG_ON(new_pfn, kvm);
+
+	/* Zapping leaf spte is allowed only when write lock is held. */
+	lockdep_assert_held_write(&kvm->mmu_lock);
+	ret = static_call(kvm_x86_zap_private_spte)(kvm, gfn, level);
+	/* Because write lock is held, operation should success. */
+	if (KVM_BUG_ON(ret, kvm))
+		return;
+
+	ret = static_call(kvm_x86_remove_private_spte)(kvm, gfn, level, old_pfn);
+	KVM_BUG_ON(ret, kvm);
+}
+
 /**
  * handle_changed_spte - handle bookkeeping associated with an SPTE change
  * @kvm: kvm instance
@@ -449,7 +526,7 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
  * @gfn: the base GFN that was mapped by the SPTE
  * @old_spte: The value of the SPTE before the change
  * @new_spte: The value of the SPTE after the change
- * @level: the level of the PT the SPTE is part of in the paging structure
+ * @role: the role of the PT the SPTE is part of in the paging structure
  * @shared: This operation may not be running under the exclusive use of
  *	    the MMU lock and the operation must synchronize with other
  *	    threads that might be modifying SPTEs.
@@ -459,14 +536,18 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
  * and fast_pf_fix_direct_spte()).
  */
 static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
-				u64 old_spte, u64 new_spte, int level,
-				bool shared)
+				u64 old_spte, u64 new_spte,
+				union kvm_mmu_page_role role, bool shared)
 {
+	bool is_private = kvm_mmu_page_role_is_private(role);
+	int level = role.level;
 	bool was_present = is_shadow_present_pte(old_spte);
 	bool is_present = is_shadow_present_pte(new_spte);
 	bool was_leaf = was_present && is_last_spte(old_spte, level);
 	bool is_leaf = is_present && is_last_spte(new_spte, level);
-	bool pfn_changed = spte_to_pfn(old_spte) != spte_to_pfn(new_spte);
+	kvm_pfn_t old_pfn = spte_to_pfn(old_spte);
+	kvm_pfn_t new_pfn = spte_to_pfn(new_spte);
+	bool pfn_changed = old_pfn != new_pfn;
 
 	WARN_ON(level > PT64_ROOT_MAX_LEVEL);
 	WARN_ON(level < PG_LEVEL_4K);
@@ -533,7 +614,7 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 
 	if (was_leaf && is_dirty_spte(old_spte) &&
 	    (!is_present || !is_dirty_spte(new_spte) || pfn_changed))
-		kvm_set_pfn_dirty(spte_to_pfn(old_spte));
+		kvm_set_pfn_dirty(old_pfn);
 
 	/*
 	 * Recursively handle child PTs if the change removed a subtree from
@@ -542,14 +623,82 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	 * pages are kernel allocations and should never be migrated.
 	 */
 	if (was_present && !was_leaf &&
-	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed)))
+	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed))) {
+		KVM_BUG_ON(is_private != is_private_sptep(spte_to_child_pt(old_spte, level)),
+			   kvm);
 		handle_removed_pt(kvm, spte_to_child_pt(old_spte, level), shared);
+	}
+
+	/*
+	 * Secure-EPT requires to remove Secure-EPT tables after removing
+	 * children.  hooks after handling lower page table by above
+	 * handle_remove_pt().
+	 */
+	if (is_private && !is_present)
+		handle_removed_private_spte(kvm, gfn, old_spte, new_spte, role.level);
 
 	if (was_leaf && is_accessed_spte(old_spte) &&
 	    (!is_present || !is_accessed_spte(new_spte) || pfn_changed))
 		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
 }
 
+static int __must_check __set_private_spte_present(struct kvm *kvm, tdp_ptep_t sptep,
+						   gfn_t gfn, u64 old_spte,
+						   u64 new_spte, int level)
+{
+	bool was_present = is_shadow_present_pte(old_spte);
+	bool is_present = is_shadow_present_pte(new_spte);
+	bool is_leaf = is_present && is_last_spte(new_spte, level);
+	kvm_pfn_t new_pfn = spte_to_pfn(new_spte);
+	int ret = 0;
+
+	lockdep_assert_held(&kvm->mmu_lock);
+	/* TDP MMU doesn't change present -> present */
+	KVM_BUG_ON(was_present, kvm);
+
+	/*
+	 * Use different call to either set up middle level
+	 * private page table, or leaf.
+	 */
+	if (is_leaf)
+		ret = static_call(kvm_x86_set_private_spte)(kvm, gfn, level, new_pfn);
+	else {
+		void *private_spt = get_private_spt(gfn, new_spte, level);
+
+		KVM_BUG_ON(!private_spt, kvm);
+		ret = static_call(kvm_x86_link_private_spt)(kvm, gfn, level, private_spt);
+	}
+
+	return ret;
+}
+
+static int __must_check set_private_spte_present(struct kvm *kvm, tdp_ptep_t sptep,
+						 gfn_t gfn, u64 old_spte,
+						 u64 new_spte, int level)
+{
+	int ret;
+
+	/*
+	 * For private page table, callbacks are needed to propagate SPTE
+	 * change into the protected page table.  In order to atomically update
+	 * both the SPTE and the protected page tables with callbacks, utilize
+	 * freezing SPTE.
+	 * - Freeze the SPTE. Set entry to REMOVED_SPTE.
+	 * - Trigger callbacks for protected page tables.
+	 * - Unfreeze the SPTE.  Set the entry to new_spte.
+	 */
+	lockdep_assert_held(&kvm->mmu_lock);
+	if (!try_cmpxchg64(sptep, &old_spte, REMOVED_SPTE))
+		return -EBUSY;
+
+	ret = __set_private_spte_present(kvm, sptep, gfn, old_spte, new_spte, level);
+	if (ret)
+		__kvm_tdp_mmu_write_spte(sptep, old_spte);
+	else
+		__kvm_tdp_mmu_write_spte(sptep, new_spte);
+	return ret;
+}
+
 /*
  * tdp_mmu_set_spte_atomic - Set a TDP MMU SPTE atomically
  * and handle the associated bookkeeping.  Do not mark the page dirty
@@ -572,6 +721,7 @@ static inline int __must_check tdp_mmu_set_spte_atomic(struct kvm *kvm,
 						       u64 new_spte)
 {
 	u64 *sptep = rcu_dereference(iter->sptep);
+	bool freezed = false;
 
 	/*
 	 * The caller is responsible for ensuring the old SPTE is not a REMOVED
@@ -583,19 +733,36 @@ static inline int __must_check tdp_mmu_set_spte_atomic(struct kvm *kvm,
 
 	lockdep_assert_held_read(&kvm->mmu_lock);
 
-	/*
-	 * Note, fast_pf_fix_direct_spte() can also modify TDP MMU SPTEs and
-	 * does not hold the mmu_lock.  On failure, i.e. if a different logical
-	 * CPU modified the SPTE, try_cmpxchg64() updates iter->old_spte with
-	 * the current value, so the caller operates on fresh data, e.g. if it
-	 * retries tdp_mmu_set_spte_atomic()
-	 */
-	if (!try_cmpxchg64(sptep, &iter->old_spte, new_spte))
-		return -EBUSY;
+	if (is_private_sptep(iter->sptep) && !is_removed_spte(new_spte)) {
+		int ret;
 
-	handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
-			    new_spte, iter->level, true);
+		if (is_shadow_present_pte(new_spte)) {
+			ret = set_private_spte_present(kvm, iter->sptep, iter->gfn,
+						       iter->old_spte, new_spte, iter->level);
+			if (ret)
+				return ret;
+		} else {
+			if (!try_cmpxchg64(sptep, &iter->old_spte, REMOVED_SPTE))
+				return -EBUSY;
+			freezed = true;
+		}
+	} else {
+		/*
+		 * Note, fast_pf_fix_direct_spte() can also modify TDP MMU SPTEs
+		 * and does not hold the mmu_lock.  On failure, i.e. if a
+		 * different logical CPU modified the SPTE, try_cmpxchg64()
+		 * updates iter->old_spte with the current value, so the caller
+		 * operates on fresh data, e.g. if it retries
+		 * tdp_mmu_set_spte_atomic()
+		 */
+		if (!try_cmpxchg64(sptep, &iter->old_spte, new_spte))
+			return -EBUSY;
+	}
 
+	handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
+			    new_spte, sptep_to_sp(sptep)->role, true);
+	if (freezed)
+		__kvm_tdp_mmu_write_spte(sptep, new_spte);
 	return 0;
 }
 
@@ -645,6 +812,8 @@ static inline int __must_check tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 static u64 tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 			    u64 old_spte, u64 new_spte, gfn_t gfn, int level)
 {
+	union kvm_mmu_page_role role;
+
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	/*
@@ -657,8 +826,17 @@ static u64 tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 	WARN_ON(is_removed_spte(old_spte) || is_removed_spte(new_spte));
 
 	old_spte = kvm_tdp_mmu_write_spte(sptep, old_spte, new_spte, level);
+	if (is_private_sptep(sptep) && !is_removed_spte(new_spte) &&
+	    is_shadow_present_pte(new_spte)) {
+		lockdep_assert_held_write(&kvm->mmu_lock);
+		/* Because write spin lock is held, no race.  It should success. */
+		KVM_BUG_ON(__set_private_spte_present(kvm, sptep, gfn, old_spte,
+						      new_spte, level), kvm);
+	}
 
-	handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level, false);
+	role = sptep_to_sp(sptep)->role;
+	role.level = level;
+	handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, role, false);
 	return old_spte;
 }
 
@@ -681,8 +859,11 @@ static inline void tdp_mmu_iter_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 			continue;					\
 		else
 
-#define tdp_mmu_for_each_pte(_iter, _mmu, _start, _end)		\
-	for_each_tdp_pte(_iter, to_shadow_page(_mmu->root.hpa), _start, _end)
+#define tdp_mmu_for_each_pte(_iter, _mmu, _private, _start, _end)	\
+	for_each_tdp_pte(_iter,						\
+		 to_shadow_page((_private) ? _mmu->private_root_hpa :	\
+				_mmu->root.hpa),			\
+		_start, _end)
 
 /*
  * Yield if the MMU lock is contended or this thread needs to return control
@@ -844,6 +1025,14 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 	if (!zap_private && is_private_sp(root))
 		return false;
 
+	/*
+	 * start and end doesn't have GFN shared bit.  This function zaps
+	 * a region including alias.  Adjust shared bit of [start, end) if the
+	 * root is shared.
+	 */
+	start = kvm_gfn_for_root(kvm, root, start);
+	end = kvm_gfn_for_root(kvm, root, end);
+
 	rcu_read_lock();
 
 	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_4K, start, end) {
@@ -991,10 +1180,19 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 
 	if (unlikely(!fault->slot))
 		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
-	else
-		wrprot = make_spte(vcpu, sp, fault->slot, ACC_ALL, iter->gfn,
-					 fault->pfn, iter->old_spte, fault->prefetch, true,
-					 fault->map_writable, &new_spte);
+	else {
+		unsigned long pte_access = ACC_ALL;
+
+		/* TDX shared GPAs are no executable, enforce this for the SDV. */
+		if (kvm_gfn_shared_mask(vcpu->kvm) && !fault->is_private)
+			pte_access &= ~ACC_EXEC_MASK;
+
+		wrprot = make_spte(vcpu, sp, fault->slot, pte_access,
+				   gpa_to_gfn(fault->addr)/* include shared bit */,
+				   fault->pfn, iter->old_spte,
+				   fault->prefetch, true, fault->map_writable,
+				   &new_spte);
+	}
 
 	if (new_spte == iter->old_spte)
 		ret = RET_PF_SPURIOUS;
@@ -1072,6 +1270,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	struct kvm *kvm = vcpu->kvm;
 	struct tdp_iter iter;
 	struct kvm_mmu_page *sp;
+	gfn_t raw_gfn;
+	bool is_private = fault->is_private && kvm_gfn_shared_mask(kvm);
 	int ret = RET_PF_RETRY;
 
 	kvm_mmu_hugepage_adjust(vcpu, fault);
@@ -1080,7 +1280,17 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 
 	rcu_read_lock();
 
-	tdp_mmu_for_each_pte(iter, mmu, fault->gfn, fault->gfn + 1) {
+	raw_gfn = gpa_to_gfn(fault->addr);
+
+	if (is_error_noslot_pfn(fault->pfn) ||
+	    !kvm_pfn_to_refcounted_page(fault->pfn)) {
+		if (is_private) {
+			rcu_read_unlock();
+			return -EFAULT;
+		}
+	}
+
+	tdp_mmu_for_each_pte(iter, mmu, is_private, raw_gfn, raw_gfn + 1) {
 		int r;
 
 		if (fault->nx_huge_page_workaround_enabled)
@@ -1110,9 +1320,14 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 
 		sp->nx_huge_page_disallowed = fault->huge_page_disallowed;
 
-		if (is_shadow_present_pte(iter.old_spte))
+		if (is_shadow_present_pte(iter.old_spte)) {
+			/*
+			 * TODO: large page support.
+			 * Doesn't support large page for TDX now
+			 */
+			KVM_BUG_ON(is_private_sptep(iter.sptep), vcpu->kvm);
 			r = tdp_mmu_split_huge_page(kvm, &iter, sp, true);
-		else
+		} else
 			r = tdp_mmu_link_sp(kvm, &iter, sp, true);
 
 		/*
@@ -1369,6 +1584,8 @@ static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp, union kvm_mm
 
 	sp->role = role;
 	sp->spt = (void *)__get_free_page(gfp);
+	/* TODO: large page support for private GPA. */
+	WARN_ON_ONCE(kvm_mmu_page_role_is_private(role));
 	if (!sp->spt) {
 		kmem_cache_free(mmu_page_header_cache, sp);
 		return NULL;
@@ -1384,6 +1601,11 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 	union kvm_mmu_page_role role = tdp_iter_child_role(iter);
 	struct kvm_mmu_page *sp;
 
+	KVM_BUG_ON(kvm_mmu_page_role_is_private(role) !=
+		   is_private_sptep(iter->sptep), kvm);
+	/* TODO: Large page isn't supported for private SPTE yet. */
+	KVM_BUG_ON(kvm_mmu_page_role_is_private(role), kvm);
+
 	/*
 	 * Since we are allocating while under the MMU lock we have to be
 	 * careful about GFP flags. Use GFP_NOWAIT to avoid blocking on direct
@@ -1808,7 +2030,7 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 
 	*root_level = vcpu->arch.mmu->root_role.level;
 
-	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
+	tdp_mmu_for_each_pte(iter, mmu, false, gfn, gfn + 1) {
 		leaf = iter.level;
 		sptes[leaf] = iter.old_spte;
 	}
@@ -1835,7 +2057,10 @@ u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, u64 addr,
 	gfn_t gfn = addr >> PAGE_SHIFT;
 	tdp_ptep_t sptep = NULL;
 
-	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
+	/* fast page fault for private GPA isn't supported. */
+	WARN_ON_ONCE(kvm_is_private_gpa(vcpu->kvm, addr));
+
+	tdp_mmu_for_each_pte(iter, mmu, false, gfn, gfn + 1) {
 		*spte = iter.old_spte;
 		sptep = iter.sptep;
 	}
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 3df604352648..6ae311b5e988 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -10,7 +10,7 @@
 int kvm_mmu_init_tdp_mmu(struct kvm *kvm);
 void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
 
-hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
+hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu, bool private);
 
 __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
 {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 14b1fa9fe644..0c277e1f5f12 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -203,6 +203,7 @@ struct page *kvm_pfn_to_refcounted_page(kvm_pfn_t pfn)
 
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(kvm_pfn_to_refcounted_page);
 
 /*
  * Switches to specified vcpu, until a matching vcpu_put()
-- 
2.25.1

