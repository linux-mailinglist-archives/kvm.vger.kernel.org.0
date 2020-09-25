Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8820F279354
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 23:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729217AbgIYVYm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 17:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729123AbgIYVX0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Sep 2020 17:23:26 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B4AC0613D3
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:23:26 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id r1so258082pjp.5
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=UXulVPbiF44P5UU9x1p1VstHMCrG+98/OCotusC7CPo=;
        b=mLl9v8SRq2DChfgcA/HugGpbD/RpzoGh095opA24xNizabwnO7XZxuPQUb96ngIDes
         uCLvAPFmKY4dnj4gUGpn5Ny6Gn8ZCIq/8LEH8IZ8tpTFscy5SFT7oMBxEIPsuRPZWWZN
         NxddiUF/vKAI1UmvKQBawE43/4Y1yvH6GqOECBfvSy9CWOJ2jlNHL/NnOBycBNg9pbPk
         09KqPZRVJf8f3SZQtK0xAIp0EZKjU9ZaGJmsjauG2yB573DCkPivLB2xrhEV9/LtX1ro
         7mOZATKugtdMEZAYQrQnXE9ByOX5L8+lyvothlF0w6WgCKV9lSPIBOwuoilb1T85vOj2
         NOTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=UXulVPbiF44P5UU9x1p1VstHMCrG+98/OCotusC7CPo=;
        b=NHqJBk/wSnTPHED9HY6koYBu77DV9LYKa/nfXcPkPBj64qYOqE4FaarO5iBK0ehOgS
         JHzUxQBPDWECiCIv/tEz9XyhbeVQwnvrO7f1M4kvH5eMlOH8aFNoSOBslzYzCQXj7qoe
         gpHOkxAOaD2U32qSnS7iZaA7MXU569fndGzXAVzMy57iM1cINc7pRL6XyMTWpOpIool4
         1AcVAocRP+JkPqcu6vDcvhtsG0ba44F71lzRAhGFO1MblgpIzAuXD284JwQ17HiBL+zp
         sFeJpp2nIOg7erjOdNuWWwr79+D76yYV0webPGW+NEutQ0URUsHlrOcuq4tHXXIiqn9X
         Guog==
X-Gm-Message-State: AOAM530e3cmlRFOh7uHEsVrFlDDY0/TOyIYGX0qjGCvbjA+GO1wbCy6r
        j0L4QobwqHIyEbd2Tu62KcRNqW5/7Oux
X-Google-Smtp-Source: ABdhPJy5xZyaRSfJpW0pxmioNMPR5q8KeqZ1vKi4+AZXIJg5PolRY8PK+UyD00xi7mhxJ0lspvBTzQumbu2X
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a63:d449:: with SMTP id
 i9mr648654pgj.83.1601069006244; Fri, 25 Sep 2020 14:23:26 -0700 (PDT)
Date:   Fri, 25 Sep 2020 14:22:50 -0700
In-Reply-To: <20200925212302.3979661-1-bgardon@google.com>
Message-Id: <20200925212302.3979661-11-bgardon@google.com>
Mime-Version: 1.0
References: <20200925212302.3979661-1-bgardon@google.com>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH 10/22] kvm: mmu: Add TDP MMU PF handler
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
 arch/x86/kvm/mmu/mmu.c          |  66 ++++++-----------
 arch/x86/kvm/mmu/mmu_internal.h |  45 +++++++++++
 arch/x86/kvm/mmu/tdp_mmu.c      | 127 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.h      |   4 +
 4 files changed, 200 insertions(+), 42 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f6e6fc9959c04..52d661a758585 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -153,12 +153,6 @@ module_param(dbg, bool, 0644);
 #else
 #define PT64_BASE_ADDR_MASK (((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1))
 #endif
-#define PT64_LVL_ADDR_MASK(level) \
-	(PT64_BASE_ADDR_MASK & ~((1ULL << (PAGE_SHIFT + (((level) - 1) \
-						* PT64_LEVEL_BITS))) - 1))
-#define PT64_LVL_OFFSET_MASK(level) \
-	(PT64_BASE_ADDR_MASK & ((1ULL << (PAGE_SHIFT + (((level) - 1) \
-						* PT64_LEVEL_BITS))) - 1))
 
 #define PT32_BASE_ADDR_MASK PAGE_MASK
 #define PT32_DIR_BASE_ADDR_MASK \
@@ -182,20 +176,6 @@ module_param(dbg, bool, 0644);
 /* make pte_list_desc fit well in cache line */
 #define PTE_LIST_EXT 3
 
-/*
- * Return values of handle_mmio_page_fault and mmu.page_fault:
- * RET_PF_RETRY: let CPU fault again on the address.
- * RET_PF_EMULATE: mmio page fault, emulate the instruction directly.
- *
- * For handle_mmio_page_fault only:
- * RET_PF_INVALID: the spte is invalid, let the real page fault path update it.
- */
-enum {
-	RET_PF_RETRY = 0,
-	RET_PF_EMULATE = 1,
-	RET_PF_INVALID = 2,
-};
-
 struct pte_list_desc {
 	u64 *sptes[PTE_LIST_EXT];
 	struct pte_list_desc *more;
@@ -233,7 +213,7 @@ static struct percpu_counter kvm_total_used_mmu_pages;
 static u64 __read_mostly shadow_nx_mask;
 static u64 __read_mostly shadow_x_mask;	/* mutual exclusive with nx_mask */
 static u64 __read_mostly shadow_user_mask;
-static u64 __read_mostly shadow_accessed_mask;
+u64 __read_mostly shadow_accessed_mask;
 static u64 __read_mostly shadow_dirty_mask;
 static u64 __read_mostly shadow_mmio_value;
 static u64 __read_mostly shadow_mmio_access_mask;
@@ -364,7 +344,7 @@ static inline bool spte_ad_need_write_protect(u64 spte)
 	return (spte & SPTE_SPECIAL_MASK) != SPTE_AD_ENABLED_MASK;
 }
 
-static bool is_nx_huge_page_enabled(void)
+bool is_nx_huge_page_enabled(void)
 {
 	return READ_ONCE(nx_huge_pages);
 }
@@ -381,7 +361,7 @@ static inline u64 spte_shadow_dirty_mask(u64 spte)
 	return spte_ad_enabled(spte) ? shadow_dirty_mask : 0;
 }
 
-static inline bool is_access_track_spte(u64 spte)
+inline bool is_access_track_spte(u64 spte)
 {
 	return !spte_ad_enabled(spte) && (spte & shadow_acc_track_mask) == 0;
 }
@@ -433,7 +413,7 @@ static u64 get_mmio_spte_generation(u64 spte)
 	return gen;
 }
 
-static u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access)
+u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access)
 {
 
 	u64 gen = kvm_vcpu_memslots(vcpu)->generation & MMIO_SPTE_GEN_MASK;
@@ -613,7 +593,7 @@ int is_shadow_present_pte(u64 pte)
 	return (pte != 0) && !is_mmio_spte(pte);
 }
 
-static int is_large_pte(u64 pte)
+int is_large_pte(u64 pte)
 {
 	return pte & PT_PAGE_SIZE_MASK;
 }
@@ -2555,7 +2535,7 @@ static void shadow_walk_next(struct kvm_shadow_walk_iterator *iterator)
 	__shadow_walk_next(iterator, *iterator->sptep);
 }
 
-static u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled)
+u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled)
 {
 	u64 spte;
 
@@ -2961,14 +2941,9 @@ static bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
 				     E820_TYPE_RAM);
 }
 
-/* Bits which may be returned by set_spte() */
-#define SET_SPTE_WRITE_PROTECTED_PT	BIT(0)
-#define SET_SPTE_NEED_REMOTE_TLB_FLUSH	BIT(1)
-
-static u64 make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
-		     gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool speculative,
-		     bool can_unsync, bool host_writable, bool ad_disabled,
-		     int *ret)
+u64 make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
+	      gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool speculative,
+	      bool can_unsync, bool host_writable, bool ad_disabled, int *ret)
 {
 	u64 spte = 0;
 
@@ -3249,8 +3224,8 @@ static int host_pfn_mapping_level(struct kvm_vcpu *vcpu, gfn_t gfn,
 	return level;
 }
 
-static int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
-				   int max_level, kvm_pfn_t *pfnp)
+int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
+			    int max_level, kvm_pfn_t *pfnp)
 {
 	struct kvm_memory_slot *slot;
 	struct kvm_lpage_info *linfo;
@@ -3295,8 +3270,8 @@ static int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
 	return level;
 }
 
-static void disallowed_hugepage_adjust(u64 spte, gfn_t gfn, int cur_level,
-					kvm_pfn_t *pfnp, int *goal_levelp)
+void disallowed_hugepage_adjust(u64 spte, gfn_t gfn, int cur_level,
+				kvm_pfn_t *pfnp, int *goal_levelp)
 {
 	int goal_level = *goal_levelp;
 
@@ -4113,8 +4088,9 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	if (page_fault_handle_page_track(vcpu, error_code, gfn))
 		return RET_PF_EMULATE;
 
-	if (fast_page_fault(vcpu, gpa, error_code))
-		return RET_PF_RETRY;
+	if (!is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
+		if (fast_page_fault(vcpu, gpa, error_code))
+			return RET_PF_RETRY;
 
 	r = mmu_topup_memory_caches(vcpu, false);
 	if (r)
@@ -4139,8 +4115,14 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	r = make_mmu_pages_available(vcpu);
 	if (r)
 		goto out_unlock;
-	r = __direct_map(vcpu, gpa, write, map_writable, max_level, pfn,
-			 prefault, is_tdp && lpage_disallowed);
+
+	if (is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
+		r = kvm_tdp_mmu_page_fault(vcpu, write, map_writable, max_level,
+					   gpa, pfn, prefault,
+					   is_tdp && lpage_disallowed);
+	else
+		r = __direct_map(vcpu, gpa, write, map_writable, max_level, pfn,
+				 prefault, is_tdp && lpage_disallowed);
 
 out_unlock:
 	spin_unlock(&vcpu->kvm->mmu_lock);
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index ff1fe0e04fba5..4cef9da051847 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -73,6 +73,15 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 	(((address) >> PT64_LEVEL_SHIFT(level)) & ((1 << PT64_LEVEL_BITS) - 1))
 #define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)
 
+#define PT64_LVL_ADDR_MASK(level) \
+	(PT64_BASE_ADDR_MASK & ~((1ULL << (PAGE_SHIFT + (((level) - 1) \
+						* PT64_LEVEL_BITS))) - 1))
+#define PT64_LVL_OFFSET_MASK(level) \
+	(PT64_BASE_ADDR_MASK & ((1ULL << (PAGE_SHIFT + (((level) - 1) \
+						* PT64_LEVEL_BITS))) - 1))
+
+extern u64 shadow_accessed_mask;
+
 #define ACC_EXEC_MASK    1
 #define ACC_WRITE_MASK   PT_WRITABLE_MASK
 #define ACC_USER_MASK    PT_USER_MASK
@@ -84,7 +93,43 @@ bool is_mmio_spte(u64 spte);
 int is_shadow_present_pte(u64 pte);
 int is_last_spte(u64 pte, int level);
 bool is_dirty_spte(u64 spte);
+int is_large_pte(u64 pte);
+bool is_access_track_spte(u64 spte);
 
 void kvm_flush_remote_tlbs_with_address(struct kvm *kvm, u64 start_gfn,
 					u64 pages);
+
+/*
+ * Return values of handle_mmio_page_fault and mmu.page_fault:
+ * RET_PF_RETRY: let CPU fault again on the address.
+ * RET_PF_EMULATE: mmio page fault, emulate the instruction directly.
+ *
+ * For handle_mmio_page_fault only:
+ * RET_PF_INVALID: the spte is invalid, let the real page fault path update it.
+ */
+enum {
+	RET_PF_RETRY = 0,
+	RET_PF_EMULATE = 1,
+	RET_PF_INVALID = 2,
+};
+
+/* Bits which may be returned by set_spte() */
+#define SET_SPTE_WRITE_PROTECTED_PT	BIT(0)
+#define SET_SPTE_NEED_REMOTE_TLB_FLUSH	BIT(1)
+
+u64 make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
+	      gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool speculative,
+	      bool can_unsync, bool host_writable, bool ad_disabled, int *ret);
+u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
+u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
+
+int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
+			    int max_level, kvm_pfn_t *pfnp);
+void disallowed_hugepage_adjust(u64 spte, gfn_t gfn, int cur_level,
+				kvm_pfn_t *pfnp, int *goal_levelp);
+
+bool is_nx_huge_page_enabled(void);
+
+void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
+
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index d96fc182c8497..37bdebc2592ea 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -311,6 +311,10 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 #define for_each_tdp_pte_root(_iter, _root, _start, _end) \
 	for_each_tdp_pte(_iter, _root->spt, _root->role.level, _start, _end)
 
+#define for_each_tdp_pte_vcpu(_iter, _vcpu, _start, _end)		   \
+	for_each_tdp_pte(_iter, __va(_vcpu->arch.mmu->root_hpa),	   \
+			 _vcpu->arch.mmu->shadow_root_level, _start, _end)
+
 /*
  * If the MMU lock is contended or this thread needs to yield, flushes
  * the TLBs, releases, the MMU lock, yields, reacquires the MMU lock,
@@ -400,3 +404,126 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 	if (flush)
 		kvm_flush_remote_tlbs(kvm);
 }
+
+/*
+ * Installs a last-level SPTE to handle a TDP page fault.
+ * (NPT/EPT violation/misconfiguration)
+ */
+static int page_fault_handle_target_level(struct kvm_vcpu *vcpu, int write,
+					  int map_writable, int as_id,
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
+		new_spte = make_spte(vcpu, ACC_ALL, iter->level, iter->gfn,
+				     pfn, iter->old_spte, prefault, true,
+				     map_writable, !shadow_accessed_mask,
+				     &make_spte_ret);
+
+	/*
+	 * If the page fault was caused by a write but the page is write
+	 * protected, emulation is needed. If the emulation was skipped,
+	 * the vCPU would have the same fault again.
+	 */
+	if ((make_spte_ret & SET_SPTE_WRITE_PROTECTED_PT) && write)
+		ret = RET_PF_EMULATE;
+
+	/* If a MMIO SPTE is installed, the MMIO will need to be emulated. */
+	if (unlikely(is_mmio_spte(new_spte)))
+		ret = RET_PF_EMULATE;
+
+	*iter->sptep = new_spte;
+	handle_changed_spte(vcpu->kvm, as_id, iter->gfn, iter->old_spte,
+			    new_spte, iter->level);
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
+int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu, int write, int map_writable,
+			   int max_level, gpa_t gpa, kvm_pfn_t pfn,
+			   bool prefault, bool account_disallowed_nx_lpage)
+{
+	struct tdp_iter iter;
+	struct kvm_mmu_memory_cache *pf_pt_cache =
+			&vcpu->arch.mmu_shadow_page_cache;
+	u64 *child_pt;
+	u64 new_spte;
+	int ret;
+	int as_id = kvm_arch_vcpu_memslots_id(vcpu);
+	gfn_t gfn = gpa >> PAGE_SHIFT;
+	int level;
+
+	if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa)))
+		return RET_PF_RETRY;
+
+	if (WARN_ON(!is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa)))
+		return RET_PF_RETRY;
+
+	level = kvm_mmu_hugepage_adjust(vcpu, gfn, max_level, &pfn);
+
+	for_each_tdp_pte_vcpu(iter, vcpu, gfn, gfn + 1) {
+		disallowed_hugepage_adjust(iter.old_spte, gfn, iter.level,
+					   &pfn, &level);
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
+			*iter.sptep = 0;
+			handle_changed_spte(vcpu->kvm, as_id, iter.gfn,
+					    iter.old_spte, 0, iter.level);
+			kvm_flush_remote_tlbs_with_address(vcpu->kvm, iter.gfn,
+					KVM_PAGES_PER_HPAGE(iter.level));
+
+			/*
+			 * The iter must explicitly re-read the spte here
+			 * because the new is needed before the next iteration
+			 * of the loop.
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
+			*iter.sptep = new_spte;
+			handle_changed_spte(vcpu->kvm, as_id, iter.gfn,
+					    iter.old_spte, new_spte,
+					    iter.level);
+		}
+	}
+
+	if (WARN_ON(iter.level != level))
+		return RET_PF_RETRY;
+
+	ret = page_fault_handle_target_level(vcpu, write, map_writable,
+					     as_id, &iter, pfn, prefault);
+
+	/* If emulating, flush this vcpu's TLB. */
+	if (ret == RET_PF_EMULATE)
+		kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
+
+	return ret;
+}
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index cb86f9fe69017..abf23dc0ab7ad 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -14,4 +14,8 @@ void kvm_tdp_mmu_put_root_hpa(struct kvm *kvm, hpa_t root_hpa);
 
 bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end);
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
+
+int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu, int write, int map_writable,
+			   int level, gpa_t gpa, kvm_pfn_t pfn, bool prefault,
+			   bool lpage_disallowed);
 #endif /* __KVM_X86_MMU_TDP_MMU_H */
-- 
2.28.0.709.gb0816b6eb0-goog

