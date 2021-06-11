Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7300F3A4B84
	for <lists+kvm@lfdr.de>; Sat, 12 Jun 2021 01:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbhFLAAl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 20:00:41 -0400
Received: from mail-pj1-f73.google.com ([209.85.216.73]:39853 "EHLO
        mail-pj1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbhFLAAk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Jun 2021 20:00:40 -0400
Received: by mail-pj1-f73.google.com with SMTP id w4-20020a17090a4f44b029016bab19a594so6874006pjl.4
        for <kvm@vger.kernel.org>; Fri, 11 Jun 2021 16:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=KY5nFFut95ziz/p5qqfU7JOBjyPM21Fmr4qGyxbPUSE=;
        b=hjnavhQDp75bZrAHSJtJu1ThhKwEv1ggAZZy9W8PFV7oO6E5O0CSNFqIxZCW0O1hze
         W1+xapQ47Evl3lm0WWwiWm6NA3U8KelnT48EHfHy+uqCiCzNO4K12woub4XAJnqCIf82
         bE4bd6d7wd/8iGjQtgLqi7F0GhUpX8Y9joZgwidG+ClbZMeN0vBiQky80z9yHHcuiFQe
         6tb8RV7+917eqr2YolS8KNUQxCq6LnjPJ/kVEk9CshcXJ2HkHNbLkxRxQ5wbyA0ICCG6
         XCwr6uIHD+es/ksiS7nFOxSJ9N1cSIN8YfYL8FVq58ebr48K5qfQarkTU9Q02nMnCE9y
         h22w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=KY5nFFut95ziz/p5qqfU7JOBjyPM21Fmr4qGyxbPUSE=;
        b=P/kuFwB/+rVjpbfIkzoCZbzcKG9GE56rmwK5FTGPOKaPD2cO4sK7YYR47LfY4BicyB
         mR9gjFNP8C325WsDh4FFZnQSyY6PcLdLrKOrb7xlmlBSbaMEYI5Q1brHUIYVRx/p4hW9
         2ZVT8gcPSZYSyuKxFBm1jSiY6ZyW6Z2h17PVpjkln46OaGTQ9FFt1QgKNKpXuMVHj9lU
         sQ6V0jqkV4mRd8tOb7r3mABayIjW2x/7+krq+/ThotktM/7j2NN3ZxzHE1vL+TU1r0cs
         dg6BnYPmW61Fv2hNv2p/7CVI7B1mWCWWw0qa/gbYV0FSRBLmHT8UiF3kitqhvq+zDa98
         BQgQ==
X-Gm-Message-State: AOAM532IUIg30/zBdtf+PtTVfqLdIX4FfQHOkh3nA2CdYbA//3NDFWhp
        YulavlSK6wUkawo2IWAOEs0wItBXkRXgww/ac8VtjuCUPcdWaZKaIEmBoEtrc8FE2KXL7G58/aF
        tY66cKpvkMpA+ADwTJvegtLnD6i5JcqL+qMjZw5jAl0furbcLlZHlIkrNvjHt2jc=
X-Google-Smtp-Source: ABdhPJx5d4RxhMz2O6nogSgIotzrc+hsbpMefYEY5R1zh/Yqw/hxyMU3rk2jo+T+/GvE/90FG6kaBkSyLV7l9w==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:82c2:b029:118:df43:e2f4 with SMTP
 id u2-20020a17090282c2b0290118df43e2f4mr3302205plz.14.1623455845467; Fri, 11
 Jun 2021 16:57:25 -0700 (PDT)
Date:   Fri, 11 Jun 2021 23:56:57 +0000
In-Reply-To: <20210611235701.3941724-1-dmatlack@google.com>
Message-Id: <20210611235701.3941724-5-dmatlack@google.com>
Mime-Version: 1.0
References: <20210611235701.3941724-1-dmatlack@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH 4/8] KVM: x86/mmu: Common API for lockless shadow page walks
From:   David Matlack <dmatlack@google.com>
To:     kvm@vger.kernel.org
Cc:     Ben Gardon <bgardon@google.com>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a common API for walking the shadow page tables locklessly
that abstracts away whether the TDP MMU is enabled or not. This will be
used in a follow-up patch to support the TDP MMU in fast_page_fault.

The API can be used as follows:

  struct shadow_page_walk walk;

  walk_shadow_page_lockless_begin(vcpu);
  if (!walk_shadow_page_lockless(vcpu, addr, &walk))
    goto out;

  ... use `walk` ...

out:
  walk_shadow_page_lockless_end(vcpu);

Note: Separating walk_shadow_page_lockless_begin() from
walk_shadow_page_lockless() seems superfluous at first glance but is
needed to support fast_page_fault() since it performs multiple walks
under the same begin/end block.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 96 ++++++++++++++++++++-------------
 arch/x86/kvm/mmu/mmu_internal.h | 15 ++++++
 arch/x86/kvm/mmu/tdp_mmu.c      | 34 ++++++------
 arch/x86/kvm/mmu/tdp_mmu.h      |  6 ++-
 4 files changed, 96 insertions(+), 55 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1d0fe1445e04..8140c262f4d3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -623,6 +623,11 @@ static bool mmu_spte_age(u64 *sptep)
 
 static void walk_shadow_page_lockless_begin(struct kvm_vcpu *vcpu)
 {
+	if (is_vcpu_using_tdp_mmu(vcpu)) {
+		kvm_tdp_mmu_walk_lockless_begin();
+		return;
+	}
+
 	/*
 	 * Prevent page table teardown by making any free-er wait during
 	 * kvm_flush_remote_tlbs() IPI to all active vcpus.
@@ -638,6 +643,11 @@ static void walk_shadow_page_lockless_begin(struct kvm_vcpu *vcpu)
 
 static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
 {
+	if (is_vcpu_using_tdp_mmu(vcpu)) {
+		kvm_tdp_mmu_walk_lockless_end();
+		return;
+	}
+
 	/*
 	 * Make sure the write to vcpu->mode is not reordered in front of
 	 * reads to sptes.  If it does, kvm_mmu_commit_zap_page() can see us
@@ -3501,59 +3511,61 @@ static bool mmio_info_in_cache(struct kvm_vcpu *vcpu, u64 addr, bool direct)
 }
 
 /*
- * Return the level of the lowest level SPTE added to sptes.
- * That SPTE may be non-present.
+ * Walks the shadow page table for the given address until a leaf or non-present
+ * spte is encountered.
+ *
+ * Returns false if no walk could be performed, in which case `walk` does not
+ * contain any valid data.
+ *
+ * Must be called between walk_shadow_page_lockless_{begin,end}.
  */
-static int get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes, int *root_level)
+static bool walk_shadow_page_lockless(struct kvm_vcpu *vcpu, u64 addr,
+				      struct shadow_page_walk *walk)
 {
-	struct kvm_shadow_walk_iterator iterator;
-	int leaf = -1;
+	struct kvm_shadow_walk_iterator it;
+	bool walk_ok = false;
 	u64 spte;
 
-	walk_shadow_page_lockless_begin(vcpu);
+	if (is_vcpu_using_tdp_mmu(vcpu))
+		return kvm_tdp_mmu_walk_lockless(vcpu, addr, walk);
 
-	for (shadow_walk_init(&iterator, vcpu, addr),
-	     *root_level = iterator.level;
-	     shadow_walk_okay(&iterator);
-	     __shadow_walk_next(&iterator, spte)) {
-		leaf = iterator.level;
-		spte = mmu_spte_get_lockless(iterator.sptep);
+	shadow_walk_init(&it, vcpu, addr);
+	walk->root_level = it.level;
 
-		sptes[leaf] = spte;
+	for (; shadow_walk_okay(&it); __shadow_walk_next(&it, spte)) {
+		walk_ok = true;
+
+		spte = mmu_spte_get_lockless(it.sptep);
+		walk->last_level = it.level;
+		walk->sptes[it.level] = spte;
 
 		if (!is_shadow_present_pte(spte))
 			break;
 	}
 
-	walk_shadow_page_lockless_end(vcpu);
-
-	return leaf;
+	return walk_ok;
 }
 
 /* return true if reserved bit(s) are detected on a valid, non-MMIO SPTE. */
 static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
 {
-	u64 sptes[PT64_ROOT_MAX_LEVEL + 1];
+	struct shadow_page_walk walk;
 	struct rsvd_bits_validate *rsvd_check;
-	int root, leaf, level;
+	int last_level, level;
 	bool reserved = false;
 
-	if (!VALID_PAGE(vcpu->arch.mmu->root_hpa)) {
-		*sptep = 0ull;
+	*sptep = 0ull;
+
+	if (!VALID_PAGE(vcpu->arch.mmu->root_hpa))
 		return reserved;
-	}
 
-	if (is_vcpu_using_tdp_mmu(vcpu))
-		leaf = kvm_tdp_mmu_get_walk(vcpu, addr, sptes, &root);
-	else
-		leaf = get_walk(vcpu, addr, sptes, &root);
+	walk_shadow_page_lockless_begin(vcpu);
 
-	if (unlikely(leaf < 0)) {
-		*sptep = 0ull;
-		return reserved;
-	}
+	if (!walk_shadow_page_lockless(vcpu, addr, &walk))
+		goto out;
 
-	*sptep = sptes[leaf];
+	last_level = walk.last_level;
+	*sptep = walk.sptes[last_level];
 
 	/*
 	 * Skip reserved bits checks on the terminal leaf if it's not a valid
@@ -3561,29 +3573,37 @@ static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
 	 * design, always have reserved bits set.  The purpose of the checks is
 	 * to detect reserved bits on non-MMIO SPTEs. i.e. buggy SPTEs.
 	 */
-	if (!is_shadow_present_pte(sptes[leaf]))
-		leaf++;
+	if (!is_shadow_present_pte(walk.sptes[last_level]))
+		last_level++;
 
 	rsvd_check = &vcpu->arch.mmu->shadow_zero_check;
 
-	for (level = root; level >= leaf; level--)
+	for (level = walk.root_level; level >= last_level; level--) {
+		u64 spte = walk.sptes[level];
+
 		/*
 		 * Use a bitwise-OR instead of a logical-OR to aggregate the
 		 * reserved bit and EPT's invalid memtype/XWR checks to avoid
 		 * adding a Jcc in the loop.
 		 */
-		reserved |= __is_bad_mt_xwr(rsvd_check, sptes[level]) |
-			    __is_rsvd_bits_set(rsvd_check, sptes[level], level);
+		reserved |= __is_bad_mt_xwr(rsvd_check, spte) |
+			    __is_rsvd_bits_set(rsvd_check, spte, level);
+	}
 
 	if (reserved) {
 		pr_err("%s: reserved bits set on MMU-present spte, addr 0x%llx, hierarchy:\n",
 		       __func__, addr);
-		for (level = root; level >= leaf; level--)
+		for (level = walk.root_level; level >= last_level; level--) {
+			u64 spte = walk.sptes[level];
+
 			pr_err("------ spte = 0x%llx level = %d, rsvd bits = 0x%llx",
-			       sptes[level], level,
-			       rsvd_check->rsvd_bits_mask[(sptes[level] >> 7) & 1][level-1]);
+			       spte, level,
+			       rsvd_check->rsvd_bits_mask[(spte >> 7) & 1][level-1]);
+		}
 	}
 
+out:
+	walk_shadow_page_lockless_end(vcpu);
 	return reserved;
 }
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index d64ccb417c60..26da6ca30fbf 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -165,4 +165,19 @@ void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 
+struct shadow_page_walk {
+	/* The level of the root spte in the walk. */
+	int root_level;
+
+	/*
+	 * The level of the last spte in the walk. The last spte is either the
+	 * leaf of the walk (which may or may not be present) or the first
+	 * non-present spte encountered during the walk.
+	 */
+	int last_level;
+
+	/* The spte value at each level. */
+	u64 sptes[PT64_ROOT_MAX_LEVEL + 1];
+};
+
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index f4cc79dabeae..36f4844a5f95 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1504,28 +1504,32 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 	return spte_set;
 }
 
-/*
- * Return the level of the lowest level SPTE added to sptes.
- * That SPTE may be non-present.
- */
-int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
-			 int *root_level)
+void kvm_tdp_mmu_walk_lockless_begin(void)
+{
+	rcu_read_lock();
+}
+
+void kvm_tdp_mmu_walk_lockless_end(void)
+{
+	rcu_read_unlock();
+}
+
+bool kvm_tdp_mmu_walk_lockless(struct kvm_vcpu *vcpu, u64 addr,
+			       struct shadow_page_walk *walk)
 {
 	struct tdp_iter iter;
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	gfn_t gfn = addr >> PAGE_SHIFT;
-	int leaf = -1;
+	bool walk_ok = false;
 
-	*root_level = vcpu->arch.mmu->shadow_root_level;
-
-	rcu_read_lock();
+	walk->root_level = vcpu->arch.mmu->shadow_root_level;
 
 	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
-		leaf = iter.level;
-		sptes[leaf] = iter.old_spte;
-	}
+		walk_ok = true;
 
-	rcu_read_unlock();
+		walk->last_level = iter.level;
+		walk->sptes[iter.level] = iter.old_spte;
+	}
 
-	return leaf;
+	return walk_ok;
 }
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index c8cf12809fcf..772d11bbb92a 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -76,8 +76,10 @@ bool kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
 bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn);
 
-int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
-			 int *root_level);
+void kvm_tdp_mmu_walk_lockless_begin(void);
+void kvm_tdp_mmu_walk_lockless_end(void);
+bool kvm_tdp_mmu_walk_lockless(struct kvm_vcpu *vcpu, u64 addr,
+			       struct shadow_page_walk *walk);
 
 #ifdef CONFIG_X86_64
 void kvm_mmu_init_tdp_mmu(struct kvm *kvm);
-- 
2.32.0.272.g935e593368-goog

