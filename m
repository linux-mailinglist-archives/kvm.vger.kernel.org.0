Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12923BFBDB
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 01:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729034AbfIZXTV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 19:19:21 -0400
Received: from mail-qk1-f201.google.com ([209.85.222.201]:46448 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729060AbfIZXTV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 19:19:21 -0400
Received: by mail-qk1-f201.google.com with SMTP id x186so817032qke.13
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 16:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zUj93KTO3Bj0DuO7C1ywcJksue4QOJ1xOkJ8pFn7qX0=;
        b=AVaY56eN6ZkokF6BsY3KMUTU6xzOaYVEl9pcF61NUz4f1pT1/b4ep7zvdd6D6lkTO2
         4xzLhnMeJDa9PpGARIlh5LvKCjijWxDEODkzLaBF5bvIKVXkv9w2mG/FLFNxCB+rmI1x
         PFf6PFyQBl374jFYbVcLBGecHy2KQwEskmkSQ6BuWhm3vFCYHTKiuZaIKcPAFP8GYzqD
         sqeLbvWg3dWC6Iu4yHAGj9U3r+gj9zRjQfe+EpaZAaJmhSQ+dTsfAlNDqmUiw67+jFfL
         OuVNRG4yGW46busQtaK1JaLByJoer3plqIEmiTishskOBVXvS6pmGuR4eBgZN0ZVKXKQ
         Ws+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zUj93KTO3Bj0DuO7C1ywcJksue4QOJ1xOkJ8pFn7qX0=;
        b=BhualqJ9knGxP1ngXqwbqOY4L9ZlQW1+t2GMX1n56Y5fxbtQyfmpDq9IOwQFdhXiSi
         drbGoIUD8iMZt/rzh6mrRse/vBT3XnsQntlw9ky6zq8diHQ1apz20ZRlAPPbp9fvCUZo
         H8tjtn4HFew4Ihvp4uReXyxGicUpTCYcUXdO01KCqtLbpPrtuWrXtPNzqPYoaMU1tLmr
         QZVn3KRY0ddrfgwnY4qfnudpq+1WrEAelWHJtggKYnVD2cGFiw+KkLuZQZuD7suMV6sc
         s0Ur/zxsDfUL8IEUNyKU6VM19ce7CLKci+/ylqcaOI/Bg0DjCExvU3UTdO7jyuZpEGGu
         e5Lw==
X-Gm-Message-State: APjAAAXYlFXpNZhMwuTSB1z4LH/dan0zwYGARdJlYSp6GPlkVyzvkN+a
        asmTE6nje5l7gH/67L3j9plQFWH3LQiPIiQkPFqPnR055qk5t+s0FqeS25UYocC/Vavh/X2+LjF
        mFzzWkSIwM/U3XbR44ygj9ZYB1zcUoCpcrH+aNpOsbuWGxrDV4y34wcDKYbLe
X-Google-Smtp-Source: APXvYqwkjfOAxyVkFOdXaNuE2POb89kbOdFWBlXXqCMIcvwhdKkiX71CUbjWrn/i4wo5z3LEQDjhuvVDEbqq
X-Received: by 2002:ac8:75cd:: with SMTP id z13mr6748518qtq.87.1569539958233;
 Thu, 26 Sep 2019 16:19:18 -0700 (PDT)
Date:   Thu, 26 Sep 2019 16:18:18 -0700
In-Reply-To: <20190926231824.149014-1-bgardon@google.com>
Message-Id: <20190926231824.149014-23-bgardon@google.com>
Mime-Version: 1.0
References: <20190926231824.149014-1-bgardon@google.com>
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [RFC PATCH 22/28] kvm: mmu: Implement access tracking for the direct MMU
From:   Ben Gardon <bgardon@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adds functions for dealing with the accessed state of PTEs which
can operate with the direct MMU.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu.c  | 153 +++++++++++++++++++++++++++++++++++++++++---
 virt/kvm/kvm_main.c |   7 +-
 2 files changed, 150 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index b144c803c36d2..cc81ba5ee46d6 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -779,6 +779,17 @@ static bool spte_has_volatile_bits(u64 spte)
 	return false;
 }
 
+static bool is_accessed_direct_pte(u64 pte, int level)
+{
+	if (!is_last_spte(pte, level))
+		return false;
+
+	if (shadow_accessed_mask)
+		return pte & shadow_accessed_mask;
+
+	return pte & shadow_acc_track_mask;
+}
+
 static bool is_accessed_spte(u64 spte)
 {
 	u64 accessed_mask = spte_shadow_accessed_mask(spte);
@@ -929,6 +940,14 @@ static u64 mmu_spte_get_lockless(u64 *sptep)
 	return __get_spte_lockless(sptep);
 }
 
+static u64 save_pte_permissions_for_access_track(u64 pte)
+{
+	pte |= (pte & shadow_acc_track_saved_bits_mask) <<
+		shadow_acc_track_saved_bits_shift;
+	pte &= ~shadow_acc_track_mask;
+	return pte;
+}
+
 static u64 mark_spte_for_access_track(u64 spte)
 {
 	if (spte_ad_enabled(spte))
@@ -944,16 +963,13 @@ static u64 mark_spte_for_access_track(u64 spte)
 	 */
 	WARN_ONCE((spte & PT_WRITABLE_MASK) &&
 		  !spte_can_locklessly_be_made_writable(spte),
-		  "kvm: Writable SPTE is not locklessly dirty-trackable\n");
+		  "kvm: Writable PTE is not locklessly dirty-trackable\n");
 
 	WARN_ONCE(spte & (shadow_acc_track_saved_bits_mask <<
 			  shadow_acc_track_saved_bits_shift),
 		  "kvm: Access Tracking saved bit locations are not zero\n");
 
-	spte |= (spte & shadow_acc_track_saved_bits_mask) <<
-		shadow_acc_track_saved_bits_shift;
-	spte &= ~shadow_acc_track_mask;
-
+	spte = save_pte_permissions_for_access_track(spte);
 	return spte;
 }
 
@@ -1718,6 +1734,15 @@ static void free_pt_rcu_callback(struct rcu_head *rp)
 	free_page((unsigned long)disconnected_pt);
 }
 
+static void handle_changed_pte_acc_track(u64 old_pte, u64 new_pte, int level)
+{
+	bool pfn_changed = spte_to_pfn(old_pte) != spte_to_pfn(new_pte);
+
+	if (is_accessed_direct_pte(old_pte, level) &&
+	    (!is_accessed_direct_pte(new_pte, level) || pfn_changed))
+		kvm_set_pfn_accessed(spte_to_pfn(old_pte));
+}
+
 /*
  * Takes a snapshot of, and clears, the direct MMU disconnected pt list. Once
  * TLBs have been flushed, this snapshot can be transferred to the direct MMU
@@ -1847,6 +1872,7 @@ static void mark_pte_disconnected(struct kvm *kvm, int as_id, gfn_t gfn,
 
 	handle_changed_pte(kvm, as_id, gfn, old_pte, DISCONNECTED_PTE, level,
 			   vm_teardown, disconnected_pts);
+	handle_changed_pte_acc_track(old_pte, DISCONNECTED_PTE, level);
 }
 
 /**
@@ -2412,8 +2438,8 @@ static bool cmpxchg_pte(u64 *ptep, u64 old_pte, u64 new_pte, int level, u64 gfn)
 	return r == old_pte;
 }
 
-static bool direct_walk_iterator_set_pte(struct direct_walk_iterator *iter,
-					 u64 new_pte)
+static bool direct_walk_iterator_set_pte_raw(struct direct_walk_iterator *iter,
+					 u64 new_pte, bool handle_acc_track)
 {
 	bool r;
 
@@ -2435,6 +2461,10 @@ static bool direct_walk_iterator_set_pte(struct direct_walk_iterator *iter,
 				   iter->old_pte, new_pte, iter->level, false,
 				   &iter->disconnected_pts);
 
+		if (handle_acc_track)
+			handle_changed_pte_acc_track(iter->old_pte, new_pte,
+						     iter->level);
+
 		if (iter->lock_mode & (MMU_WRITE_LOCK | MMU_READ_LOCK))
 			iter->tlbs_dirty++;
 	} else
@@ -2443,6 +2473,18 @@ static bool direct_walk_iterator_set_pte(struct direct_walk_iterator *iter,
 	return r;
 }
 
+static bool direct_walk_iterator_set_pte_no_acc_track(
+		struct direct_walk_iterator *iter, u64 new_pte)
+{
+	return direct_walk_iterator_set_pte_raw(iter, new_pte, false);
+}
+
+static bool direct_walk_iterator_set_pte(struct direct_walk_iterator *iter,
+					 u64 new_pte)
+{
+	return direct_walk_iterator_set_pte_raw(iter, new_pte, true);
+}
+
 static u64 generate_nonleaf_pte(u64 *child_pt, bool ad_disabled)
 {
 	u64 pte;
@@ -2965,14 +3007,107 @@ static void rmap_recycle(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 			KVM_PAGES_PER_HPAGE(sp->role.level));
 }
 
+static int age_direct_gfn_range(struct kvm *kvm, struct kvm_memory_slot *slot,
+				 gfn_t start, gfn_t end, unsigned long ignored)
+{
+	struct direct_walk_iterator iter;
+	int young = 0;
+	u64 new_pte = 0;
+
+	direct_walk_iterator_setup_walk(&iter, kvm, slot->as_id, start, end,
+					MMU_WRITE_LOCK);
+	while (direct_walk_iterator_next_present_leaf_pte(&iter)) {
+		/*
+		 * If we have a non-accessed entry we don't need to change the
+		 * pte.
+		 */
+		if (!is_accessed_direct_pte(iter.old_pte, iter.level))
+			continue;
+
+		if (shadow_accessed_mask)
+			new_pte = iter.old_pte & ~shadow_accessed_mask;
+		else {
+			new_pte = save_pte_permissions_for_access_track(
+					iter.old_pte);
+			new_pte |= shadow_acc_track_value;
+		}
+
+		/*
+		 * We've created a new pte with the accessed state cleared.
+		 * Warn if we're about to put in a pte that still looks
+		 * accessed.
+		 */
+		WARN_ON(is_accessed_direct_pte(new_pte, iter.level));
+
+		if (!direct_walk_iterator_set_pte_no_acc_track(&iter, new_pte))
+			continue;
+
+		young = true;
+
+		if (shadow_accessed_mask)
+			trace_kvm_age_page(iter.pte_gfn_start, iter.level, slot,
+					   young);
+	}
+	direct_walk_iterator_end_traversal(&iter);
+
+	return young;
+}
+
 int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
 {
-	return kvm_handle_hva_range(kvm, start, end, 0, kvm_age_rmapp);
+	int young = 0;
+
+	if (kvm->arch.direct_mmu_enabled)
+		young |= kvm_handle_direct_hva_range(kvm, start, end, 0,
+						     age_direct_gfn_range);
+
+	if (!kvm->arch.pure_direct_mmu)
+		young |= kvm_handle_hva_range(kvm, start, end, 0,
+					      kvm_age_rmapp);
+	return young;
+}
+
+static int test_age_direct_gfn_range(struct kvm *kvm,
+				     struct kvm_memory_slot *slot,
+				     gfn_t start, gfn_t end,
+				     unsigned long ignored)
+{
+	struct direct_walk_iterator iter;
+	int young = 0;
+
+	direct_walk_iterator_setup_walk(&iter, kvm, slot->as_id, start, end,
+					MMU_WRITE_LOCK);
+	while (direct_walk_iterator_next_present_leaf_pte(&iter)) {
+		if (is_accessed_direct_pte(iter.old_pte, iter.level)) {
+			young = true;
+			break;
+		}
+	}
+	direct_walk_iterator_end_traversal(&iter);
+
+	return young;
 }
 
 int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
 {
-	return kvm_handle_hva(kvm, hva, 0, kvm_test_age_rmapp);
+	int young = 0;
+
+	/*
+	 * If there's no access bit in the secondary pte set by the
+	 * hardware it's up to gup-fast/gup to set the access bit in
+	 * the primary pte or in the page structure.
+	 */
+	if (!shadow_accessed_mask)
+		return young;
+
+	if (kvm->arch.direct_mmu_enabled)
+		young |= kvm_handle_direct_hva_range(kvm, hva, hva + 1, 0,
+						     test_age_direct_gfn_range);
+
+	if (!kvm->arch.pure_direct_mmu)
+		young |= kvm_handle_hva(kvm, hva, 0, kvm_test_age_rmapp);
+
+	return young;
 }
 
 #ifdef MMU_DEBUG
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d494044104270..771e159d6bea9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -439,7 +439,12 @@ static int kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,
 	write_lock(&kvm->mmu_lock);
 
 	young = kvm_age_hva(kvm, start, end);
-	if (young)
+
+	/*
+	 * If there was an accessed page in the provided range, or there are
+	 * un-flushed paging structure changes, flush the TLBs.
+	 */
+	if (young || kvm->tlbs_dirty)
 		kvm_flush_remote_tlbs(kvm);
 
 	write_unlock(&kvm->mmu_lock);
-- 
2.23.0.444.g18eeb5a265-goog

