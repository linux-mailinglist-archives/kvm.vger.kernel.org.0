Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 508B728E64D
	for <lists+kvm@lfdr.de>; Wed, 14 Oct 2020 20:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389046AbgJNS12 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Oct 2020 14:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388915AbgJNS11 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Oct 2020 14:27:27 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A10EC0613E3
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 11:27:22 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id gv16so326437pjb.9
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 11:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=pklO+jwBIipq5NQFFX826HVIUc5GwohyzBnzowsJx+o=;
        b=iQmi7ClCXbTDTA9EZX41sdojQr4nYCEbzmICck2/AdyPhSwU/oveu5W9m6IU0m5kiB
         Y//60xdDNEyIhLushifYssrTWXjaS0Y0X3kHWRPfk4W0ihEIabXcVQ9/E0Q65yk+mLe3
         /apl6JY9Dze27wqLAxPI87ZO980oHuVyyZIdm3SAkPwJOpi5bF/ojoaX/ILLuuRagq6F
         uqDUc+tEF2ncof/1LsdSQCgw/OKenuF95etsWYf/jiQ20WIIEr7u1iz1H2dwZXSA5wM7
         k88bnDdPJsFxcIIlbthHRc/ujzKZh6nMHOIdicuUrjt8OnfmgtbWr9QI+HGV4YwqENfq
         bbmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=pklO+jwBIipq5NQFFX826HVIUc5GwohyzBnzowsJx+o=;
        b=K+XtRP3jV9SO9ZCgIdCOHP6a7mGy2RVXgvWM9EPzPtvdIzIUrt6H8nCUn2EU7grZd9
         d7OuNn2HvyuMh8OJoL2ejcXUXETwQTqNjck+u7IoefQ5+JMa+6wqAeYe1nXM7pNopfEm
         JMwHCm417sJuVU9GQOZiWLvmEnnC5oSxWTzxHhABePhYlhE0OC7CZPyJHmV6vX3AMiDj
         4RBCWhjjmGbUPGP/r+ksQRLx/sOxBXVxsnODY23+b8biSWkoWlh7QtbAOqVGv6Y/BDnN
         H+LGJ4SGYmCQTT9Dpk2zNJVNUtcGOZzpfMGR7CKoj2Ugl9aFR9YE/r0XO00uZdvrEuMV
         CPPg==
X-Gm-Message-State: AOAM533Y8OQ3/ljLFp6kgAqC9vQIqimwwZQcOtBCexStRctDElehZ9B0
        ifnrWBX3jF0C2w2VngPOO8Akx5PR0sZP
X-Google-Smtp-Source: ABdhPJxZN/dZw0hHtNcSqmqzmvg48WqFfCKRdyaASKbcwWArn92spnZndm4D3O+B3b9cOPm+JebgUJ5iy4dR
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a63:d74b:: with SMTP id
 w11mr208702pgi.147.1602700042015; Wed, 14 Oct 2020 11:27:22 -0700 (PDT)
Date:   Wed, 14 Oct 2020 11:26:50 -0700
In-Reply-To: <20201014182700.2888246-1-bgardon@google.com>
Message-Id: <20201014182700.2888246-11-bgardon@google.com>
Mime-Version: 1.0
References: <20201014182700.2888246-1-bgardon@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v2 10/20] kvm: x86/mmu: Add TDP MMU PF handler
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Cannon Matthews <cannonmatthews@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add functions to handle page faults in the TDP MMU. These page faults
are currently handled in much the same way as the x86 shadow paging
based MMU, however the ordering of some operations is slightly
different. Future patches will add eager NX splitting, a fast page fault
handler, and parallel page faults.

Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
machine. This series introduced no new failures.

This series can be viewed in Gerrit at:
	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c          |  82 +++++++--------------
 arch/x86/kvm/mmu/mmu_internal.h |  59 +++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.c      | 124 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.h      |   5 ++
 4 files changed, 212 insertions(+), 58 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 288b97e96202e..421a12a247b67 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -141,23 +141,6 @@ enum {
 /* make pte_list_desc fit well in cache line */
 #define PTE_LIST_EXT 3
 
-/*
- * Return values of handle_mmio_page_fault, mmu.page_fault, and fast_page_fault().
- *
- * RET_PF_RETRY: let CPU fault again on the address.
- * RET_PF_EMULATE: mmio page fault, emulate the instruction directly.
- * RET_PF_INVALID: the spte is invalid, let the real page fault path update it.
- * RET_PF_FIXED: The faulting entry has been fixed.
- * RET_PF_SPURIOUS: The faulting entry was already fixed, e.g. by another vCPU.
- */
-enum {
-	RET_PF_RETRY = 0,
-	RET_PF_EMULATE,
-	RET_PF_INVALID,
-	RET_PF_FIXED,
-	RET_PF_SPURIOUS,
-};
-
 struct pte_list_desc {
 	u64 *sptes[PTE_LIST_EXT];
 	struct pte_list_desc *more;
@@ -195,19 +178,11 @@ static struct percpu_counter kvm_total_used_mmu_pages;
 static u64 __read_mostly shadow_nx_mask;
 static u64 __read_mostly shadow_x_mask;	/* mutual exclusive with nx_mask */
 static u64 __read_mostly shadow_user_mask;
-static u64 __read_mostly shadow_accessed_mask;
 static u64 __read_mostly shadow_mmio_value;
 static u64 __read_mostly shadow_mmio_access_mask;
 static u64 __read_mostly shadow_present_mask;
 static u64 __read_mostly shadow_me_mask;
 
-/*
- * SPTEs used by MMUs without A/D bits are marked with SPTE_AD_DISABLED_MASK;
- * shadow_acc_track_mask is the set of bits to be cleared in non-accessed
- * pages.
- */
-static u64 __read_mostly shadow_acc_track_mask;
-
 /*
  * The mask/shift to use for saving the original R/X bits when marking the PTE
  * as not-present for access tracking purposes. We do not save the W bit as the
@@ -314,22 +289,11 @@ static inline bool spte_ad_need_write_protect(u64 spte)
 	return (spte & SPTE_SPECIAL_MASK) != SPTE_AD_ENABLED_MASK;
 }
 
-static bool is_nx_huge_page_enabled(void)
+bool is_nx_huge_page_enabled(void)
 {
 	return READ_ONCE(nx_huge_pages);
 }
 
-static inline u64 spte_shadow_accessed_mask(u64 spte)
-{
-	MMU_WARN_ON(is_mmio_spte(spte));
-	return spte_ad_enabled(spte) ? shadow_accessed_mask : 0;
-}
-
-static inline bool is_access_track_spte(u64 spte)
-{
-	return !spte_ad_enabled(spte) && (spte & shadow_acc_track_mask) == 0;
-}
-
 /*
  * Due to limited space in PTEs, the MMIO generation is a 19 bit subset of
  * the memslots generation and is derived as follows:
@@ -377,7 +341,7 @@ static u64 get_mmio_spte_generation(u64 spte)
 	return gen;
 }
 
-static u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access)
+u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access)
 {
 
 	u64 gen = kvm_vcpu_memslots(vcpu)->generation & MMIO_SPTE_GEN_MASK;
@@ -2468,7 +2432,7 @@ static void shadow_walk_next(struct kvm_shadow_walk_iterator *iterator)
 	__shadow_walk_next(iterator, *iterator->sptep);
 }
 
-static u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled)
+u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled)
 {
 	u64 spte;
 
@@ -2886,15 +2850,10 @@ static bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
 				     E820_TYPE_RAM);
 }
 
-/* Bits which may be returned by set_spte() */
-#define SET_SPTE_WRITE_PROTECTED_PT	BIT(0)
-#define SET_SPTE_NEED_REMOTE_TLB_FLUSH	BIT(1)
-#define SET_SPTE_SPURIOUS		BIT(2)
-
-static int make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
-		     gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool speculative,
-		     bool can_unsync, bool host_writable, bool ad_disabled,
-		     u64 *new_spte)
+int make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
+	      gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool speculative,
+	      bool can_unsync, bool host_writable, bool ad_disabled,
+	      u64 *new_spte)
 {
 	u64 spte = 0;
 	int ret = 0;
@@ -3187,9 +3146,9 @@ static int host_pfn_mapping_level(struct kvm_vcpu *vcpu, gfn_t gfn,
 	return level;
 }
 
-static int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
-				   int max_level, kvm_pfn_t *pfnp,
-				   bool huge_page_disallowed, int *req_level)
+int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn, int max_level,
+			    kvm_pfn_t *pfnp, bool huge_page_disallowed,
+			    int *req_level)
 {
 	struct kvm_memory_slot *slot;
 	struct kvm_lpage_info *linfo;
@@ -3243,8 +3202,8 @@ static int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
 	return level;
 }
 
-static void disallowed_hugepage_adjust(u64 spte, gfn_t gfn, int cur_level,
-				       kvm_pfn_t *pfnp, int *levelp)
+void disallowed_hugepage_adjust(u64 spte, gfn_t gfn, int cur_level,
+				kvm_pfn_t *pfnp, int *levelp)
 {
 	int level = *levelp;
 
@@ -4068,9 +4027,11 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	if (page_fault_handle_page_track(vcpu, error_code, gfn))
 		return RET_PF_EMULATE;
 
-	r = fast_page_fault(vcpu, gpa, error_code);
-	if (r != RET_PF_INVALID)
-		return r;
+	if (!is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa)) {
+		r = fast_page_fault(vcpu, gpa, error_code);
+		if (r != RET_PF_INVALID)
+			return r;
+	}
 
 	r = mmu_topup_memory_caches(vcpu, false);
 	if (r)
@@ -4092,8 +4053,13 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	r = make_mmu_pages_available(vcpu);
 	if (r)
 		goto out_unlock;
-	r = __direct_map(vcpu, gpa, error_code, map_writable, max_level, pfn,
-			 prefault, is_tdp);
+
+	if (is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
+		r = kvm_tdp_mmu_map(vcpu, gpa, error_code, map_writable,
+				    max_level, pfn, prefault, is_tdp);
+	else
+		r = __direct_map(vcpu, gpa, error_code, map_writable, max_level,
+				 pfn, prefault, is_tdp);
 
 out_unlock:
 	spin_unlock(&vcpu->kvm->mmu_lock);
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index c053a157e4d55..f7fe5616eff98 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -121,6 +121,14 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 #define ACC_ALL          (ACC_EXEC_MASK | ACC_WRITE_MASK | ACC_USER_MASK)
 
 static u64 __read_mostly shadow_dirty_mask;
+static u64 __read_mostly shadow_accessed_mask;
+
+/*
+ * SPTEs used by MMUs without A/D bits are marked with SPTE_AD_DISABLED_MASK;
+ * shadow_acc_track_mask is the set of bits to be cleared in non-accessed
+ * pages.
+ */
+static u64 __read_mostly shadow_acc_track_mask;
 
 /* Functions for interpreting SPTEs */
 static inline bool is_mmio_spte(u64 spte)
@@ -186,6 +194,57 @@ static inline bool is_dirty_spte(u64 spte)
 	return dirty_mask ? spte & dirty_mask : spte & PT_WRITABLE_MASK;
 }
 
+static inline u64 spte_shadow_accessed_mask(u64 spte)
+{
+	MMU_WARN_ON(is_mmio_spte(spte));
+	return spte_ad_enabled(spte) ? shadow_accessed_mask : 0;
+}
+
+static inline bool is_access_track_spte(u64 spte)
+{
+	return !spte_ad_enabled(spte) && (spte & shadow_acc_track_mask) == 0;
+}
+
 void kvm_flush_remote_tlbs_with_address(struct kvm *kvm, u64 start_gfn,
 					u64 pages);
+
+/*
+ * Return values of handle_mmio_page_fault, mmu.page_fault, and fast_page_fault().
+ *
+ * RET_PF_RETRY: let CPU fault again on the address.
+ * RET_PF_EMULATE: mmio page fault, emulate the instruction directly.
+ * RET_PF_INVALID: the spte is invalid, let the real page fault path update it.
+ * RET_PF_FIXED: The faulting entry has been fixed.
+ * RET_PF_SPURIOUS: The faulting entry was already fixed, e.g. by another vCPU.
+ */
+enum {
+	RET_PF_RETRY = 0,
+	RET_PF_EMULATE,
+	RET_PF_INVALID,
+	RET_PF_FIXED,
+	RET_PF_SPURIOUS,
+};
+
+/* Bits which may be returned by set_spte() */
+#define SET_SPTE_WRITE_PROTECTED_PT	BIT(0)
+#define SET_SPTE_NEED_REMOTE_TLB_FLUSH	BIT(1)
+#define SET_SPTE_SPURIOUS		BIT(2)
+
+int make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
+	      gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool speculative,
+	      bool can_unsync, bool host_writable, bool ad_disabled,
+	      u64 *new_spte);
+u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
+u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
+
+int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn, int max_level,
+			    kvm_pfn_t *pfnp, bool huge_page_disallowed,
+			    int *req_level);
+void disallowed_hugepage_adjust(u64 spte, gfn_t gfn, int cur_level,
+				kvm_pfn_t *pfnp, int *levelp);
+
+bool is_nx_huge_page_enabled(void);
+
+void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
+
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 9b5cd4a832f1a..f92c12c4ce31a 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -291,6 +291,10 @@ static inline void tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 #define tdp_root_for_each_pte(_iter, _root, _start, _end) \
 	for_each_tdp_pte(_iter, _root->spt, _root->role.level, _start, _end)
 
+#define tdp_mmu_for_each_pte(_iter, _mmu, _start, _end)		\
+	for_each_tdp_pte(_iter, __va(_mmu->root_hpa),		\
+			 _mmu->shadow_root_level, _start, _end)
+
 static bool tdp_mmu_iter_cond_resched(struct kvm *kvm, struct tdp_iter *iter)
 {
 	if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
@@ -371,3 +375,123 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 	if (flush)
 		kvm_flush_remote_tlbs(kvm);
 }
+
+/*
+ * Installs a last-level SPTE to handle a TDP page fault.
+ * (NPT/EPT violation/misconfiguration)
+ */
+static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
+					  int map_writable,
+					  struct tdp_iter *iter,
+					  kvm_pfn_t pfn, bool prefault)
+{
+	u64 new_spte;
+	int ret = 0;
+	int make_spte_ret = 0;
+
+	if (unlikely(is_noslot_pfn(pfn)))
+		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
+	else
+		make_spte_ret = make_spte(vcpu, ACC_ALL, iter->level, iter->gfn,
+					 pfn, iter->old_spte, prefault, true,
+					 map_writable, !shadow_accessed_mask,
+					 &new_spte);
+
+	tdp_mmu_set_spte(vcpu->kvm, iter, new_spte);
+
+	/*
+	 * If the page fault was caused by a write but the page is write
+	 * protected, emulation is needed. If the emulation was skipped,
+	 * the vCPU would have the same fault again.
+	 */
+	if (make_spte_ret & SET_SPTE_WRITE_PROTECTED_PT) {
+		if (write)
+			ret = RET_PF_EMULATE;
+		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
+	}
+
+	/* If a MMIO SPTE is installed, the MMIO will need to be emulated. */
+	if (unlikely(is_mmio_spte(new_spte)))
+		ret = RET_PF_EMULATE;
+
+	if (!prefault)
+		vcpu->stat.pf_fixed++;
+
+	return ret;
+}
+
+/*
+ * Handle a TDP page fault (NPT/EPT violation/misconfiguration) by installing
+ * page tables and SPTEs to translate the faulting guest physical address.
+ */
+int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
+		    int map_writable, int max_level, kvm_pfn_t pfn,
+		    bool prefault, bool is_tdp)
+{
+	bool nx_huge_page_workaround_enabled = is_nx_huge_page_enabled();
+	bool write = error_code & PFERR_WRITE_MASK;
+	bool exec = error_code & PFERR_FETCH_MASK;
+	bool huge_page_disallowed = exec && nx_huge_page_workaround_enabled;
+	struct kvm_mmu *mmu = vcpu->arch.mmu;
+	struct tdp_iter iter;
+	struct kvm_mmu_memory_cache *pf_pt_cache =
+			&vcpu->arch.mmu_shadow_page_cache;
+	u64 *child_pt;
+	u64 new_spte;
+	int ret;
+	gfn_t gfn = gpa >> PAGE_SHIFT;
+	int level;
+	int req_level;
+
+	BUG_ON(!is_tdp);
+	BUG_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa));
+	BUG_ON(!is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa));
+
+	level = kvm_mmu_hugepage_adjust(vcpu, gfn, max_level, &pfn,
+					huge_page_disallowed, &req_level);
+
+	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
+		if (nx_huge_page_workaround_enabled)
+			disallowed_hugepage_adjust(iter.old_spte, gfn,
+						   iter.level, &pfn, &level);
+
+		if (iter.level == level)
+			break;
+
+		/*
+		 * If there is an SPTE mapping a large page at a higher level
+		 * than the target, that SPTE must be cleared and replaced
+		 * with a non-leaf SPTE.
+		 */
+		if (is_shadow_present_pte(iter.old_spte) &&
+		    is_large_pte(iter.old_spte)) {
+			tdp_mmu_set_spte(vcpu->kvm, &iter, 0);
+
+			kvm_flush_remote_tlbs_with_address(vcpu->kvm, iter.gfn,
+					KVM_PAGES_PER_HPAGE(iter.level));
+
+			/*
+			 * The iter must explicitly re-read the spte here
+			 * because the new value informs the !present
+			 * path below.
+			 */
+			iter.old_spte = READ_ONCE(*iter.sptep);
+		}
+
+		if (!is_shadow_present_pte(iter.old_spte)) {
+			child_pt = kvm_mmu_memory_cache_alloc(pf_pt_cache);
+			clear_page(child_pt);
+			new_spte = make_nonleaf_spte(child_pt,
+						     !shadow_accessed_mask);
+
+			tdp_mmu_set_spte(vcpu->kvm, &iter, new_spte);
+		}
+	}
+
+	BUG_ON(iter.level != level);
+
+	ret = tdp_mmu_map_handle_target_level(vcpu, write, map_writable, &iter,
+					      pfn, prefault);
+
+	return ret;
+}
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 6de2d007fc03c..4d111a4dd332f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -14,4 +14,9 @@ void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root);
 
 bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end);
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
+
+int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
+		    int map_writable, int max_level, kvm_pfn_t pfn,
+		    bool prefault, bool is_tdp);
+
 #endif /* __KVM_X86_MMU_TDP_MMU_H */
-- 
2.28.0.1011.ga647a8990f-goog

