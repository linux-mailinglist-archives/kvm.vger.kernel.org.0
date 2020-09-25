Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33FAF27934C
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 23:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728967AbgIYVXn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 17:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729203AbgIYVXf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Sep 2020 17:23:35 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A7CC0613DE
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:23:33 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id p11so278827pjv.2
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=V/5gyg3b1e2ud3cg8TI5rpqY4AhLEdY7X2TDge3jAek=;
        b=ijNRLRNmK8bNQMiKB51n8oMQdPgAncOf8UKcf7TPO/35Qp7hv/fwsayZJTr8T7viay
         tUGLUo8vbV04OgAZNtShTIwuaPdUXN7nOe5d1enViWhGiDqya4Vm39ToNUxCeCQkqkjq
         jU6NnvnQPuchegsnhjWOl94QGfD0oRkYQkjXVGM0HlwH+o7r0SukFZIOlOAreLujy9/G
         ajdqhKMRg8wl6qhjrH9KYgCGXzbMA+W4hEB3sFPE31+0D6HrwtuXrpeqVrltXXQfuTkJ
         apVe0gD7Uf+ajpH32IO6IE4/7KKj9SE44RSJG3CFpQpeFpkCjP3s/fvBCdTX/bS9IfMM
         P8NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=V/5gyg3b1e2ud3cg8TI5rpqY4AhLEdY7X2TDge3jAek=;
        b=Z14licQCbQ8Zgx0fKaHd2qs5ZXYCJEmI8s85dZ/GbSDVh3I9zMfdZolF67PvAzEdJD
         zCtc5VUTtyg2g3V/wYGMLoyUR468DPP52Ws/fed3WagrAxFZIVjefelf8QJeKlUSDbzp
         6DhggGhW5nZCCdFa4HK5MXz+ZjJTDGPod9BdL7dh8+HqQy3QQcC7+Ae45l7Ptfkg9NnT
         1xG1tSRJ4z+OO4z84o+lB7dk6KL/zECIgAg6mAqhlyUv/N6ZaLVpZ+/kBXF5dCU12HXZ
         irzzjfXNUyMsa8MCqC3wJPanjt8uEG9YafgaH1lHoOI60ZztUb736kGvkyZvRAM3UYH2
         /Jnw==
X-Gm-Message-State: AOAM5324y/0hQkv/KNRpABR/mD0GpHqQWz8EuZnWDlQffA0hlbXZz7Nm
        fFoWHRNANCfb/8xiRhgALY7fXwoUMgiR
X-Google-Smtp-Source: ABdhPJyAaseQrHpUJntVt4+GThwAkECWq7yLGgUxzMprjqzyHSSxPzY5gPa5abbqexeNVzqcEZcoJdBqAOFn
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a17:902:fe83:b029:d2:2359:e64b with SMTP
 id x3-20020a170902fe83b02900d22359e64bmr1313762plm.7.1601069013480; Fri, 25
 Sep 2020 14:23:33 -0700 (PDT)
Date:   Fri, 25 Sep 2020 14:22:54 -0700
In-Reply-To: <20200925212302.3979661-1-bgardon@google.com>
Message-Id: <20200925212302.3979661-15-bgardon@google.com>
Mime-Version: 1.0
References: <20200925212302.3979661-1-bgardon@google.com>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH 14/22] kvm: mmu: Add access tracking for tdp_mmu
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
 arch/x86/kvm/mmu/mmu.c          |  29 ++++++---
 arch/x86/kvm/mmu/mmu_internal.h |   7 +++
 arch/x86/kvm/mmu/tdp_mmu.c      | 103 +++++++++++++++++++++++++++++++-
 arch/x86/kvm/mmu/tdp_mmu.h      |   4 ++
 4 files changed, 133 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0ddfdab942554..8c1e806b3d53f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -212,12 +212,12 @@ static struct percpu_counter kvm_total_used_mmu_pages;
 
 static u64 __read_mostly shadow_nx_mask;
 static u64 __read_mostly shadow_x_mask;	/* mutual exclusive with nx_mask */
-static u64 __read_mostly shadow_user_mask;
+u64 __read_mostly shadow_user_mask;
 u64 __read_mostly shadow_accessed_mask;
 static u64 __read_mostly shadow_dirty_mask;
 static u64 __read_mostly shadow_mmio_value;
 static u64 __read_mostly shadow_mmio_access_mask;
-static u64 __read_mostly shadow_present_mask;
+u64 __read_mostly shadow_present_mask;
 static u64 __read_mostly shadow_me_mask;
 
 /*
@@ -265,7 +265,6 @@ static u64 __read_mostly shadow_nonpresent_or_rsvd_lower_gfn_mask;
 static u8 __read_mostly shadow_phys_bits;
 
 static void mmu_spte_set(u64 *sptep, u64 spte);
-static bool is_executable_pte(u64 spte);
 static union kvm_mmu_page_role
 kvm_mmu_calc_root_page_role(struct kvm_vcpu *vcpu);
 
@@ -332,7 +331,7 @@ static inline bool kvm_vcpu_ad_need_write_protect(struct kvm_vcpu *vcpu)
 	return vcpu->arch.mmu == &vcpu->arch.guest_mmu;
 }
 
-static inline bool spte_ad_enabled(u64 spte)
+inline bool spte_ad_enabled(u64 spte)
 {
 	MMU_WARN_ON(is_mmio_spte(spte));
 	return (spte & SPTE_SPECIAL_MASK) != SPTE_AD_DISABLED_MASK;
@@ -607,7 +606,7 @@ int is_last_spte(u64 pte, int level)
 	return 0;
 }
 
-static bool is_executable_pte(u64 spte)
+bool is_executable_pte(u64 spte)
 {
 	return (spte & (shadow_x_mask | shadow_nx_mask)) == shadow_x_mask;
 }
@@ -791,7 +790,7 @@ static bool spte_has_volatile_bits(u64 spte)
 	return false;
 }
 
-static bool is_accessed_spte(u64 spte)
+bool is_accessed_spte(u64 spte)
 {
 	u64 accessed_mask = spte_shadow_accessed_mask(spte);
 
@@ -941,7 +940,7 @@ static u64 mmu_spte_get_lockless(u64 *sptep)
 	return __get_spte_lockless(sptep);
 }
 
-static u64 mark_spte_for_access_track(u64 spte)
+u64 mark_spte_for_access_track(u64 spte)
 {
 	if (spte_ad_enabled(spte))
 		return spte & ~shadow_accessed_mask;
@@ -1945,12 +1944,24 @@ static void rmap_recycle(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 
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
index 4cef9da051847..228bda0885552 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -80,7 +80,9 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 	(PT64_BASE_ADDR_MASK & ((1ULL << (PAGE_SHIFT + (((level) - 1) \
 						* PT64_LEVEL_BITS))) - 1))
 
+extern u64 shadow_user_mask;
 extern u64 shadow_accessed_mask;
+extern u64 shadow_present_mask;
 
 #define ACC_EXEC_MASK    1
 #define ACC_WRITE_MASK   PT_WRITABLE_MASK
@@ -95,6 +97,9 @@ int is_last_spte(u64 pte, int level);
 bool is_dirty_spte(u64 spte);
 int is_large_pte(u64 pte);
 bool is_access_track_spte(u64 spte);
+bool is_accessed_spte(u64 spte);
+bool spte_ad_enabled(u64 spte);
+bool is_executable_pte(u64 spte);
 
 void kvm_flush_remote_tlbs_with_address(struct kvm *kvm, u64 start_gfn,
 					u64 pages);
@@ -132,4 +137,6 @@ bool is_nx_huge_page_enabled(void);
 
 void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 
+u64 mark_spte_for_access_track(u64 spte);
+
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 1cea58db78a13..0a4b98669b3ef 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -224,6 +224,18 @@ static int kvm_mmu_page_as_id(struct kvm_mmu_page *sp)
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
@@ -236,7 +248,7 @@ static int kvm_mmu_page_as_id(struct kvm_mmu_page *sp)
  * Handle bookkeeping that might result from the modification of a SPTE.
  * This function must be called for all TDP SPTE modifications.
  */
-static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
+static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 				u64 old_spte, u64 new_spte, int level)
 {
 	bool was_present = is_shadow_present_pte(old_spte);
@@ -331,6 +343,13 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	}
 }
 
+static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
+				u64 old_spte, u64 new_spte, int level)
+{
+	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level);
+	handle_changed_spte_acc_track(old_spte, new_spte, level);
+}
+
 #define for_each_tdp_pte_root(_iter, _root, _start, _end) \
 	for_each_tdp_pte(_iter, _root->spt, _root->role.level, _start, _end)
 
@@ -621,3 +640,85 @@ int kvm_tdp_mmu_zap_hva_range(struct kvm *kvm, unsigned long start,
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
+	int as_id = kvm_mmu_page_as_id(root);
+
+	for_each_tdp_pte_root(iter, root, start, end) {
+		if (!is_shadow_present_pte(iter.old_spte) ||
+		    !is_last_spte(iter.old_spte, iter.level))
+			continue;
+
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
+		*iter.sptep = new_spte;
+		__handle_changed_spte(kvm, as_id, iter.gfn, iter.old_spte,
+				      new_spte, iter.level);
+		young = true;
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
+	int young = 0;
+
+	for_each_tdp_pte_root(iter, root, gfn, gfn + 1) {
+		if (!is_shadow_present_pte(iter.old_spte) ||
+		    !is_last_spte(iter.old_spte, iter.level))
+			continue;
+
+		if (is_accessed_spte(iter.old_spte))
+			young = true;
+	}
+
+	return young;
+}
+
+int kvm_tdp_mmu_test_age_hva(struct kvm *kvm, unsigned long hva)
+{
+	return kvm_tdp_mmu_handle_hva_range(kvm, hva, hva + 1, 0,
+					    test_age_gfn);
+}
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index ce804a97bfa1d..f316773b7b5a8 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -21,4 +21,8 @@ int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu, int write, int map_writable,
 
 int kvm_tdp_mmu_zap_hva_range(struct kvm *kvm, unsigned long start,
 			      unsigned long end);
+
+int kvm_tdp_mmu_age_hva_range(struct kvm *kvm, unsigned long start,
+			      unsigned long end);
+int kvm_tdp_mmu_test_age_hva(struct kvm *kvm, unsigned long hva);
 #endif /* __KVM_X86_MMU_TDP_MMU_H */
-- 
2.28.0.709.gb0816b6eb0-goog

