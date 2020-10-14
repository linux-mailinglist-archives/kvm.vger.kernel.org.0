Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D75B828E64C
	for <lists+kvm@lfdr.de>; Wed, 14 Oct 2020 20:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388879AbgJNS11 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Oct 2020 14:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388617AbgJNS1Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Oct 2020 14:27:25 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB43C0613DA
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 11:27:17 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id 62so81161pfv.3
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 11:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=aAKqStLipLNglfnBbmU4uyjlvVKmWH6/nWK4t/GH5Is=;
        b=DAmtf0nm71gj2upbd1Pn2uJRMrrJxd4M5dUhRTc/4DlackeHh1+BqWFO0MGJ7kSRjX
         zx56TqPsi42djPGNaSj4cgWI2dCt3GF1ESoY5sugLNZaO65ZbWytCYjoMUJvTA9PCeav
         uBYcb5XloRf3CApZ2M14dZhI/OI/G2EY4qvNqKpDVlD+6xk0hD64Z6MZlhYzJd8+WVub
         SZ5swH0/c3YDNWBq7+O3c78sn5Q5WGbI3QJB98nnQuEvcU/3O3CCnajv0f13QXwq8nTh
         5DYV5/LpNK8T+kNlT/Trk/Qia9iiHgla5p5p5eZ0d+ABLfLRjsHmO6HaNIU3IovMpXEc
         gheA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=aAKqStLipLNglfnBbmU4uyjlvVKmWH6/nWK4t/GH5Is=;
        b=gXpe4kojUI1GfyYfgm+lhb2Ff13Nwfkbv2cGjF7Gk5Y0a8JjNQnBIdrQP4LQsYqP0X
         jrKmJKeeVT9lum3bnqIKE6nRjTnFjjRxSJ/4Uu+5UBh1qicHk6iKojWdG5Bs7HaBmFeI
         f1jLklIO3t2C+J6UPWIALGbPri6OsCdwn87qjJpI2Q7cAahyjsUP1e0eDOz+Nn0lMMLM
         XwCtlfalPsUy1kKaSAq1Jzz+9hY4VcWqngGonkuHDgsRcCA2yei7VuozvpOHGSD62W5a
         Een6JsFF9PKpXLEZYEz67iS2TYxWVWJaqne0SCSoSlPozkFjg9iLCQ/PA5o/j5qri8Tp
         8k9g==
X-Gm-Message-State: AOAM532tRs1XVrt86tJBChcyVGZbcJJ31wEEixA2n5nFGUexDLj7qxNH
        6ezeeXe3SveJ2xo1TmIugAwErFAOlacn
X-Google-Smtp-Source: ABdhPJz2yHgeAniS7COQn6lwNA9KzYfa0mNAGrrqZgWeCdb07jIgmKw1Nw7EQ2FYMayr3yTAxpE4s6szK5Wz
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:aa7:96f8:0:b029:152:94c0:7e5 with SMTP id
 i24-20020aa796f80000b029015294c007e5mr558245pfq.76.1602700036584; Wed, 14 Oct
 2020 11:27:16 -0700 (PDT)
Date:   Wed, 14 Oct 2020 11:26:47 -0700
In-Reply-To: <20201014182700.2888246-1-bgardon@google.com>
Message-Id: <20201014182700.2888246-8-bgardon@google.com>
Mime-Version: 1.0
References: <20201014182700.2888246-1-bgardon@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v2 07/20] kvm: x86/mmu: Support zapping SPTEs in the TDP MMU
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

Add functions to zap SPTEs to the TDP MMU. These are needed to tear down
TDP MMU roots properly and implement other MMU functions which require
tearing down mappings. Future patches will add functions to populate the
page tables, but as for this patch there will not be any work for these
functions to do.

Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
machine. This series introduced no new failures.

This series can be viewed in Gerrit at:
	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c      |  15 +++++
 arch/x86/kvm/mmu/tdp_iter.c |   5 ++
 arch/x86/kvm/mmu/tdp_iter.h |   1 +
 arch/x86/kvm/mmu/tdp_mmu.c  | 109 ++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.h  |   2 +
 5 files changed, 132 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8bf20723c6177..337ab6823e312 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5787,6 +5787,10 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 	kvm_reload_remote_mmus(kvm);
 
 	kvm_zap_obsolete_pages(kvm);
+
+	if (kvm->arch.tdp_mmu_enabled)
+		kvm_tdp_mmu_zap_all(kvm);
+
 	spin_unlock(&kvm->mmu_lock);
 }
 
@@ -5827,6 +5831,7 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 	struct kvm_memslots *slots;
 	struct kvm_memory_slot *memslot;
 	int i;
+	bool flush;
 
 	spin_lock(&kvm->mmu_lock);
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
@@ -5846,6 +5851,12 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 		}
 	}
 
+	if (kvm->arch.tdp_mmu_enabled) {
+		flush = kvm_tdp_mmu_zap_gfn_range(kvm, gfn_start, gfn_end);
+		if (flush)
+			kvm_flush_remote_tlbs(kvm);
+	}
+
 	spin_unlock(&kvm->mmu_lock);
 }
 
@@ -6012,6 +6023,10 @@ void kvm_mmu_zap_all(struct kvm *kvm)
 	}
 
 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
+
+	if (kvm->arch.tdp_mmu_enabled)
+		kvm_tdp_mmu_zap_all(kvm);
+
 	spin_unlock(&kvm->mmu_lock);
 }
 
diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
index b07e9f0c5d4aa..701eb753b701e 100644
--- a/arch/x86/kvm/mmu/tdp_iter.c
+++ b/arch/x86/kvm/mmu/tdp_iter.c
@@ -174,3 +174,8 @@ void tdp_iter_refresh_walk(struct tdp_iter *iter)
 		       iter->root_level, iter->min_level, goal_gfn);
 }
 
+u64 *tdp_iter_root_pt(struct tdp_iter *iter)
+{
+	return iter->pt_path[iter->root_level - 1];
+}
+
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index d629a53e1b73f..884ed2c70bfed 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -52,5 +52,6 @@ void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
 		    int min_level, gfn_t goal_gfn);
 void tdp_iter_next(struct tdp_iter *iter);
 void tdp_iter_refresh_walk(struct tdp_iter *iter);
+u64 *tdp_iter_root_pt(struct tdp_iter *iter);
 
 #endif /* __KVM_X86_MMU_TDP_ITER_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index f2bd3a6928ce9..9b5cd4a832f1a 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -56,8 +56,13 @@ bool is_tdp_mmu_root(struct kvm *kvm, hpa_t hpa)
 	return sp->tdp_mmu_page && sp->root_count;
 }
 
+static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
+			  gfn_t start, gfn_t end);
+
 void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root)
 {
+	gfn_t max_gfn = 1ULL << (boot_cpu_data.x86_phys_bits - PAGE_SHIFT);
+
 	lockdep_assert_held(&kvm->mmu_lock);
 
 	WARN_ON(root->root_count);
@@ -65,6 +70,8 @@ void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root)
 
 	list_del(&root->link);
 
+	zap_gfn_range(kvm, root, 0, max_gfn);
+
 	free_page((unsigned long)root->spt);
 	kmem_cache_free(mmu_page_header_cache, root);
 }
@@ -155,6 +162,11 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 				u64 old_spte, u64 new_spte, int level);
 
+static int kvm_mmu_page_as_id(struct kvm_mmu_page *sp)
+{
+	return sp->role.smm ? 1 : 0;
+}
+
 /**
  * handle_changed_spte - handle bookkeeping associated with an SPTE change
  * @kvm: kvm instance
@@ -262,3 +274,100 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 {
 	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level);
 }
+
+static inline void tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
+				    u64 new_spte)
+{
+	u64 *root_pt = tdp_iter_root_pt(iter);
+	struct kvm_mmu_page *root = sptep_to_sp(root_pt);
+	int as_id = kvm_mmu_page_as_id(root);
+
+	*iter->sptep = new_spte;
+
+	handle_changed_spte(kvm, as_id, iter->gfn, iter->old_spte, new_spte,
+			    iter->level);
+}
+
+#define tdp_root_for_each_pte(_iter, _root, _start, _end) \
+	for_each_tdp_pte(_iter, _root->spt, _root->role.level, _start, _end)
+
+static bool tdp_mmu_iter_cond_resched(struct kvm *kvm, struct tdp_iter *iter)
+{
+	if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
+		kvm_flush_remote_tlbs(kvm);
+		cond_resched_lock(&kvm->mmu_lock);
+		tdp_iter_refresh_walk(iter);
+		return true;
+	}
+
+	return false;
+}
+
+/*
+ * Tears down the mappings for the range of gfns, [start, end), and frees the
+ * non-root pages mapping GFNs strictly within that range. Returns true if
+ * SPTEs have been cleared and a TLB flush is needed before releasing the
+ * MMU lock.
+ */
+static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
+			  gfn_t start, gfn_t end)
+{
+	struct tdp_iter iter;
+	bool flush_needed = false;
+
+	tdp_root_for_each_pte(iter, root, start, end) {
+		if (!is_shadow_present_pte(iter.old_spte))
+			continue;
+
+		/*
+		 * If this is a non-last-level SPTE that covers a larger range
+		 * than should be zapped, continue, and zap the mappings at a
+		 * lower level.
+		 */
+		if ((iter.gfn < start ||
+		     iter.gfn + KVM_PAGES_PER_HPAGE(iter.level) > end) &&
+		    !is_last_spte(iter.old_spte, iter.level))
+			continue;
+
+		tdp_mmu_set_spte(kvm, &iter, 0);
+
+		flush_needed = !tdp_mmu_iter_cond_resched(kvm, &iter);
+	}
+	return flush_needed;
+}
+
+/*
+ * Tears down the mappings for the range of gfns, [start, end), and frees the
+ * non-root pages mapping GFNs strictly within that range. Returns true if
+ * SPTEs have been cleared and a TLB flush is needed before releasing the
+ * MMU lock.
+ */
+bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end)
+{
+	struct kvm_mmu_page *root;
+	bool flush = false;
+
+	for_each_tdp_mmu_root(kvm, root) {
+		/*
+		 * Take a reference on the root so that it cannot be freed if
+		 * this thread releases the MMU lock and yields in this loop.
+		 */
+		get_tdp_mmu_root(kvm, root);
+
+		flush |= zap_gfn_range(kvm, root, start, end);
+
+		put_tdp_mmu_root(kvm, root);
+	}
+
+	return flush;
+}
+
+void kvm_tdp_mmu_zap_all(struct kvm *kvm)
+{
+	gfn_t max_gfn = 1ULL << (boot_cpu_data.x86_phys_bits - PAGE_SHIFT);
+	bool flush;
+
+	flush = kvm_tdp_mmu_zap_gfn_range(kvm, 0, max_gfn);
+	if (flush)
+		kvm_flush_remote_tlbs(kvm);
+}
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index ac0ef91294420..6de2d007fc03c 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -12,4 +12,6 @@ bool is_tdp_mmu_root(struct kvm *kvm, hpa_t root);
 hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
 void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root);
 
+bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end);
+void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 #endif /* __KVM_X86_MMU_TDP_MMU_H */
-- 
2.28.0.1011.ga647a8990f-goog

