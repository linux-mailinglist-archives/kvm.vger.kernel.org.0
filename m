Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 235D828E647
	for <lists+kvm@lfdr.de>; Wed, 14 Oct 2020 20:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389185AbgJNS1d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Oct 2020 14:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389101AbgJNS13 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Oct 2020 14:27:29 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3252CC061755
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 11:27:28 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id 88so87820pla.1
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 11:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=VI5/Pw2MzQNcasIq6ZWSOveKR1kTIPf2ndCQ73ieBgs=;
        b=BdHIEDlqcnGXgcwr852S828XphdU4eYFsVFhKyJlAvvzeaMTQ2qG5bqZecWjmvrXtZ
         rb3t5PKM7yoBSmMAFC/3tUGyROxWa/va4JKnnFONCeF6NsX0w4dRwP81sUu7BfF+Dqfg
         csrY14LbMMpmBBzEBBfeeMPMCn4Ga2NTYMa8HeeggoX87cfWQKEKVlhOzbBuFEUrXWZw
         W1loWCCmA7OhyG3ROqx9JT+WfEsuZeUd8G8OgxkV2aCWeWS+dtYOjWHUaLzXc9HTd10X
         Wh5gSan8ia1x6bzO5btGusS1txnarFJnrVf+nYzVI57dRu9UWb6WwH4FyBr3tYIsyDpK
         Qlpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VI5/Pw2MzQNcasIq6ZWSOveKR1kTIPf2ndCQ73ieBgs=;
        b=hlg+CvM+bsjNT8ILQtE8QpVSiT0UZfH+woS23HG+hKXQfO6COM8Z/nS0LD1J134o06
         BQHuw4n914L2uWzR06jnemshY+cznzEC45iBtKrT2q0Rocoyye1EpM3L3WjPtqldh4db
         AzRwA3ZTcdsAamscfuYtq+UcEMx6NUHC0UojLeGDMfQA6Y+lv182R0uy0876C9RhJOBO
         fb8p/8fKir4ZQwGTizkrLK43w7nMExgtIfnuGWZH82zazVOULjrGiGFkcnljgGIJZ0oH
         v2Stg2iCOCdGaDs4L28KWlnnHdvsmABBKta3NkhNRzqzQHXZGrs67GJaZCYhwFbjYKFn
         owcg==
X-Gm-Message-State: AOAM530wPc1K2ff8AkTbDT3c2x7lesT4DpiowPS6m2pZTgmlKtclpA/C
        R+rVL99xMGy7et+XwF9F3mjO/SULEYBA
X-Google-Smtp-Source: ABdhPJz1QBMN2RSBI6dnloZch5sHXamwZ8ITSsdnrPdf1YaNNok84MmRjtEIEo6Uwy1PosyHmFg1sndoUF1S
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a17:902:23:b029:d5:b88a:c782 with SMTP id
 32-20020a1709020023b02900d5b88ac782mr361350pla.5.1602700047640; Wed, 14 Oct
 2020 11:27:27 -0700 (PDT)
Date:   Wed, 14 Oct 2020 11:26:53 -0700
In-Reply-To: <20201014182700.2888246-1-bgardon@google.com>
Message-Id: <20201014182700.2888246-14-bgardon@google.com>
Mime-Version: 1.0
References: <20201014182700.2888246-1-bgardon@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v2 13/20] kvm: x86/mmu: Add access tracking for tdp_mmu
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

In order to interoperate correctly with the rest of KVM and other Linux
subsystems, the TDP MMU must correctly handle various MMU notifiers. The
main Linux MM uses the access tracking MMU notifiers for swap and other
features. Add hooks to handle the test/flush HVA (range) family of
MMU notifiers.

Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
machine. This series introduced no new failures.

This series can be viewed in Gerrit at:
	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c          |  34 +++++-----
 arch/x86/kvm/mmu/mmu_internal.h |  17 +++++
 arch/x86/kvm/mmu/tdp_mmu.c      | 113 ++++++++++++++++++++++++++++++--
 arch/x86/kvm/mmu/tdp_mmu.h      |   4 ++
 4 files changed, 145 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 00534133f99fc..e6ab79d8f215f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -175,8 +175,6 @@ static struct kmem_cache *pte_list_desc_cache;
 struct kmem_cache *mmu_page_header_cache;
 static struct percpu_counter kvm_total_used_mmu_pages;
 
-static u64 __read_mostly shadow_nx_mask;
-static u64 __read_mostly shadow_x_mask;	/* mutual exclusive with nx_mask */
 static u64 __read_mostly shadow_user_mask;
 static u64 __read_mostly shadow_mmio_value;
 static u64 __read_mostly shadow_mmio_access_mask;
@@ -221,7 +219,6 @@ static u64 __read_mostly shadow_nonpresent_or_rsvd_lower_gfn_mask;
 static u8 __read_mostly shadow_phys_bits;
 
 static void mmu_spte_set(u64 *sptep, u64 spte);
-static bool is_executable_pte(u64 spte);
 static union kvm_mmu_page_role
 kvm_mmu_calc_root_page_role(struct kvm_vcpu *vcpu);
 
@@ -516,11 +513,6 @@ static int is_nx(struct kvm_vcpu *vcpu)
 	return vcpu->arch.efer & EFER_NX;
 }
 
-static bool is_executable_pte(u64 spte)
-{
-	return (spte & (shadow_x_mask | shadow_nx_mask)) == shadow_x_mask;
-}
-
 static gfn_t pse36_gfn_delta(u32 gpte)
 {
 	int shift = 32 - PT32_DIR_PSE36_SHIFT - PAGE_SHIFT;
@@ -695,14 +687,6 @@ static bool spte_has_volatile_bits(u64 spte)
 	return false;
 }
 
-static bool is_accessed_spte(u64 spte)
-{
-	u64 accessed_mask = spte_shadow_accessed_mask(spte);
-
-	return accessed_mask ? spte & accessed_mask
-			     : !is_access_track_spte(spte);
-}
-
 /* Rules for using mmu_spte_set:
  * Set the sptep from nonpresent to present.
  * Note: the sptep being assigned *must* be either not present
@@ -838,7 +822,7 @@ static u64 mmu_spte_get_lockless(u64 *sptep)
 	return __get_spte_lockless(sptep);
 }
 
-static u64 mark_spte_for_access_track(u64 spte)
+u64 mark_spte_for_access_track(u64 spte)
 {
 	if (spte_ad_enabled(spte))
 		return spte & ~shadow_accessed_mask;
@@ -1842,12 +1826,24 @@ static void rmap_recycle(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 
 int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
 {
-	return kvm_handle_hva_range(kvm, start, end, 0, kvm_age_rmapp);
+	int young = false;
+
+	young = kvm_handle_hva_range(kvm, start, end, 0, kvm_age_rmapp);
+	if (kvm->arch.tdp_mmu_enabled)
+		young |= kvm_tdp_mmu_age_hva_range(kvm, start, end);
+
+	return young;
 }
 
 int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
 {
-	return kvm_handle_hva(kvm, hva, 0, kvm_test_age_rmapp);
+	int young = false;
+
+	young = kvm_handle_hva(kvm, hva, 0, kvm_test_age_rmapp);
+	if (kvm->arch.tdp_mmu_enabled)
+		young |= kvm_tdp_mmu_test_age_hva(kvm, hva);
+
+	return young;
 }
 
 #ifdef MMU_DEBUG
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index f7fe5616eff98..d886fe750be38 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -122,6 +122,8 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 
 static u64 __read_mostly shadow_dirty_mask;
 static u64 __read_mostly shadow_accessed_mask;
+static u64 __read_mostly shadow_nx_mask;
+static u64 __read_mostly shadow_x_mask;	/* mutual exclusive with nx_mask */
 
 /*
  * SPTEs used by MMUs without A/D bits are marked with SPTE_AD_DISABLED_MASK;
@@ -205,6 +207,19 @@ static inline bool is_access_track_spte(u64 spte)
 	return !spte_ad_enabled(spte) && (spte & shadow_acc_track_mask) == 0;
 }
 
+static inline bool is_accessed_spte(u64 spte)
+{
+	u64 accessed_mask = spte_shadow_accessed_mask(spte);
+
+	return accessed_mask ? spte & accessed_mask
+			     : !is_access_track_spte(spte);
+}
+
+static inline bool is_executable_pte(u64 spte)
+{
+	return (spte & (shadow_x_mask | shadow_nx_mask)) == shadow_x_mask;
+}
+
 void kvm_flush_remote_tlbs_with_address(struct kvm *kvm, u64 start_gfn,
 					u64 pages);
 
@@ -247,4 +262,6 @@ bool is_nx_huge_page_enabled(void);
 
 void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 
+u64 mark_spte_for_access_track(u64 spte);
+
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 9ec6c26ed6619..575970d8805a4 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -168,6 +168,18 @@ static int kvm_mmu_page_as_id(struct kvm_mmu_page *sp)
 	return sp->role.smm ? 1 : 0;
 }
 
+static void handle_changed_spte_acc_track(u64 old_spte, u64 new_spte, int level)
+{
+	bool pfn_changed = spte_to_pfn(old_spte) != spte_to_pfn(new_spte);
+
+	if (!is_shadow_present_pte(old_spte) || !is_last_spte(old_spte, level))
+		return;
+
+	if (is_accessed_spte(old_spte) &&
+	    (!is_accessed_spte(new_spte) || pfn_changed))
+		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
+}
+
 /**
  * handle_changed_spte - handle bookkeeping associated with an SPTE change
  * @kvm: kvm instance
@@ -279,10 +291,11 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 				u64 old_spte, u64 new_spte, int level)
 {
 	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level);
+	handle_changed_spte_acc_track(old_spte, new_spte, level);
 }
 
-static inline void tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
-				    u64 new_spte)
+static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
+				      u64 new_spte, bool record_acc_track)
 {
 	u64 *root_pt = tdp_iter_root_pt(iter);
 	struct kvm_mmu_page *root = sptep_to_sp(root_pt);
@@ -290,13 +303,36 @@ static inline void tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 
 	*iter->sptep = new_spte;
 
-	handle_changed_spte(kvm, as_id, iter->gfn, iter->old_spte, new_spte,
-			    iter->level);
+	__handle_changed_spte(kvm, as_id, iter->gfn, iter->old_spte, new_spte,
+			      iter->level);
+	if (record_acc_track)
+		handle_changed_spte_acc_track(iter->old_spte, new_spte,
+					      iter->level);
+}
+
+static inline void tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
+				    u64 new_spte)
+{
+	__tdp_mmu_set_spte(kvm, iter, new_spte, true);
+}
+
+static inline void tdp_mmu_set_spte_no_acc_track(struct kvm *kvm,
+						 struct tdp_iter *iter,
+						 u64 new_spte)
+{
+	__tdp_mmu_set_spte(kvm, iter, new_spte, false);
 }
 
 #define tdp_root_for_each_pte(_iter, _root, _start, _end) \
 	for_each_tdp_pte(_iter, _root->spt, _root->role.level, _start, _end)
 
+#define tdp_root_for_each_leaf_pte(_iter, _root, _start, _end)	\
+	tdp_root_for_each_pte(_iter, _root, _start, _end)		\
+		if (!is_shadow_present_pte(_iter.old_spte) ||		\
+		    !is_last_spte(_iter.old_spte, _iter.level))		\
+			continue;					\
+		else
+
 #define tdp_mmu_for_each_pte(_iter, _mmu, _start, _end)		\
 	for_each_tdp_pte(_iter, __va(_mmu->root_hpa),		\
 			 _mmu->shadow_root_level, _start, _end)
@@ -572,3 +608,72 @@ int kvm_tdp_mmu_zap_hva_range(struct kvm *kvm, unsigned long start,
 	return kvm_tdp_mmu_handle_hva_range(kvm, start, end, 0,
 					    zap_gfn_range_hva_wrapper);
 }
+
+/*
+ * Mark the SPTEs range of GFNs [start, end) unaccessed and return non-zero
+ * if any of the GFNs in the range have been accessed.
+ */
+static int age_gfn_range(struct kvm *kvm, struct kvm_memory_slot *slot,
+			 struct kvm_mmu_page *root, gfn_t start, gfn_t end,
+			 unsigned long unused)
+{
+	struct tdp_iter iter;
+	int young = 0;
+	u64 new_spte = 0;
+
+	tdp_root_for_each_leaf_pte(iter, root, start, end) {
+		/*
+		 * If we have a non-accessed entry we don't need to change the
+		 * pte.
+		 */
+		if (!is_accessed_spte(iter.old_spte))
+			continue;
+
+		new_spte = iter.old_spte;
+
+		if (spte_ad_enabled(new_spte)) {
+			clear_bit((ffs(shadow_accessed_mask) - 1),
+				  (unsigned long *)&new_spte);
+		} else {
+			/*
+			 * Capture the dirty status of the page, so that it doesn't get
+			 * lost when the SPTE is marked for access tracking.
+			 */
+			if (is_writable_pte(new_spte))
+				kvm_set_pfn_dirty(spte_to_pfn(new_spte));
+
+			new_spte = mark_spte_for_access_track(new_spte);
+		}
+
+		tdp_mmu_set_spte_no_acc_track(kvm, &iter, new_spte);
+		young = 1;
+	}
+
+	return young;
+}
+
+int kvm_tdp_mmu_age_hva_range(struct kvm *kvm, unsigned long start,
+			      unsigned long end)
+{
+	return kvm_tdp_mmu_handle_hva_range(kvm, start, end, 0,
+					    age_gfn_range);
+}
+
+static int test_age_gfn(struct kvm *kvm, struct kvm_memory_slot *slot,
+			struct kvm_mmu_page *root, gfn_t gfn, gfn_t unused,
+			unsigned long unused2)
+{
+	struct tdp_iter iter;
+
+	tdp_root_for_each_leaf_pte(iter, root, gfn, gfn + 1)
+		if (is_accessed_spte(iter.old_spte))
+			return 1;
+
+	return 0;
+}
+
+int kvm_tdp_mmu_test_age_hva(struct kvm *kvm, unsigned long hva)
+{
+	return kvm_tdp_mmu_handle_hva_range(kvm, hva, hva + 1, 0,
+					    test_age_gfn);
+}
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 026ceb6284102..bdb86f61e75eb 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -21,4 +21,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 
 int kvm_tdp_mmu_zap_hva_range(struct kvm *kvm, unsigned long start,
 			      unsigned long end);
+
+int kvm_tdp_mmu_age_hva_range(struct kvm *kvm, unsigned long start,
+			      unsigned long end);
+int kvm_tdp_mmu_test_age_hva(struct kvm *kvm, unsigned long hva);
 #endif /* __KVM_X86_MMU_TDP_MMU_H */
-- 
2.28.0.1011.ga647a8990f-goog

