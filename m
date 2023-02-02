Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09B76688656
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 19:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232256AbjBBS2R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 13:28:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232048AbjBBS2P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 13:28:15 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1550B1E1CA
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 10:28:14 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id 84-20020a630257000000b00477f88d334eso1371460pgc.11
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 10:28:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SvvKkW75+gdxQjUlvNBkeiHOn7ZjUPUrkdnVT/ZkYsk=;
        b=D8+uY0IwwkhAM0wjz6tGjWHmroHIAqQNhGYpcXwU3usVKzeklVUJT/qLUp9slcFtyf
         hoCrm+MMG/4mwarivWDAcU3jO+n8M5t4sRZfcrdnHJG/ERQhauamLgBJuAk7ewlKMDqW
         58SEYIw8EBpKYvX7A1onz2XNAPWLcNPYBO4Kwq/qKaxkqOgnkvoc+wM03GqZN/HMKZWa
         2F38iTqHWnSsb5aLv6EUT8KhwiEzTauEr/d87z19n3wVfLp/rzOMsyiXXuJhUyNOzLLP
         /8wozJR7QfRfDRxZAacAGNdn3ue3w5hQqG7aZeOZHPAf2uNb7Go2XbSp0RObkPmhAt93
         HyjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SvvKkW75+gdxQjUlvNBkeiHOn7ZjUPUrkdnVT/ZkYsk=;
        b=w0hoPPes9JLpuyfvA+B0MrMOOUmFOzpDZbshJ31eiafuKyZVSDTCDEyXYXJFOerKgt
         qu/XZSF34F4+9WfbRGADkVtnCoavHWQTYFZJN/QSJdvv4uMC+xbUjV599sxnxqLcegYM
         1rbujS9oFsBjsd/+JUuTKhlUDv6wIjj5Y0ofS2TUAmesAWhkUdgd8UXjWN6Z23gJd362
         V8auHfXuZU4xWTAdpD/GIdMHC+1hy6LLAO277SpEuFTeG3Rl3Cv2/8Prfad5aYz1zIco
         QL+owo3dARPzHquI/onq9D1PH39L+bKOOYBa8Tlaij7UoktIDcyko+HzIpy1myYn4Tng
         27Jw==
X-Gm-Message-State: AO0yUKXQCvlKf9gg7S27US14aAglxs2An8cXRjijd6+2MsjmD5nDCzLY
        kGH2TZDCUBnFnAyx8c+0hHXE65llrMEf
X-Google-Smtp-Source: AK7set8up62HzVic7cwUd/zWob1l4/oaE1pAVg6bhoiFuxEXIDwQTXzMFkjE+iB5ptvb7p11T1hGKjc9cK78
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a05:6a00:190c:b0:593:a079:639a with SMTP
 id y12-20020a056a00190c00b00593a079639amr1783509pfi.44.1675362493497; Thu, 02
 Feb 2023 10:28:13 -0800 (PST)
Date:   Thu,  2 Feb 2023 18:27:49 +0000
In-Reply-To: <20230202182809.1929122-1-bgardon@google.com>
Mime-Version: 1.0
References: <20230202182809.1929122-1-bgardon@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230202182809.1929122-2-bgardon@google.com>
Subject: [PATCH 01/21] KVM: x86/mmu: Rename slot rmap walkers to add clarity
 and clean up code
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Replace "slot_handle_level" with "walk_slot_rmaps" to better capture what
the helpers are doing, and to slightly shorten the function names so that
each function's return type and attributes can be placed on the same line
as the function declaration.

No functional change intended.

Link: https://lore.kernel.org/mm-commits/CAHk-=wjS-Jg7sGMwUPpDsjv392nDOOs0CtUtVkp=S6Q7JzFJRw@mail.gmail.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 66 +++++++++++++++++++++---------------------
 1 file changed, 33 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index aeb240b339f54..09a0a2cc76bae 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5801,23 +5801,24 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 EXPORT_SYMBOL_GPL(kvm_configure_mmu);
 
 /* The return value indicates if tlb flush on all vcpus is needed. */
-typedef bool (*slot_level_handler) (struct kvm *kvm,
+typedef bool (*slot_rmaps_handler) (struct kvm *kvm,
 				    struct kvm_rmap_head *rmap_head,
 				    const struct kvm_memory_slot *slot);
 
 /* The caller should hold mmu-lock before calling this function. */
-static __always_inline bool
-slot_handle_level_range(struct kvm *kvm, const struct kvm_memory_slot *memslot,
-			slot_level_handler fn, int start_level, int end_level,
-			gfn_t start_gfn, gfn_t end_gfn, bool flush_on_yield,
-			bool flush)
+static __always_inline bool __walk_slot_rmaps(struct kvm *kvm,
+					      const struct kvm_memory_slot *slot,
+					      slot_rmaps_handler fn,
+					      int start_level, int end_level,
+					      gfn_t start_gfn, gfn_t end_gfn,
+					      bool flush_on_yield, bool flush)
 {
 	struct slot_rmap_walk_iterator iterator;
 
-	for_each_slot_rmap_range(memslot, start_level, end_level, start_gfn,
+	for_each_slot_rmap_range(slot, start_level, end_level, start_gfn,
 			end_gfn, &iterator) {
 		if (iterator.rmap)
-			flush |= fn(kvm, iterator.rmap, memslot);
+			flush |= fn(kvm, iterator.rmap, slot);
 
 		if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
 			if (flush && flush_on_yield) {
@@ -5833,23 +5834,23 @@ slot_handle_level_range(struct kvm *kvm, const struct kvm_memory_slot *memslot,
 	return flush;
 }
 
-static __always_inline bool
-slot_handle_level(struct kvm *kvm, const struct kvm_memory_slot *memslot,
-		  slot_level_handler fn, int start_level, int end_level,
-		  bool flush_on_yield)
+static __always_inline bool walk_slot_rmaps(struct kvm *kvm,
+					    const struct kvm_memory_slot *slot,
+					    slot_rmaps_handler fn,
+					    int start_level, int end_level,
+					    bool flush_on_yield)
 {
-	return slot_handle_level_range(kvm, memslot, fn, start_level,
-			end_level, memslot->base_gfn,
-			memslot->base_gfn + memslot->npages - 1,
-			flush_on_yield, false);
+	return __walk_slot_rmaps(kvm, slot, fn, start_level, end_level,
+				 slot->base_gfn, slot->base_gfn + slot->npages - 1,
+				 flush_on_yield, false);
 }
 
-static __always_inline bool
-slot_handle_level_4k(struct kvm *kvm, const struct kvm_memory_slot *memslot,
-		     slot_level_handler fn, bool flush_on_yield)
+static __always_inline bool walk_slot_rmaps_4k(struct kvm *kvm,
+					       const struct kvm_memory_slot *slot,
+					       slot_rmaps_handler fn,
+					       bool flush_on_yield)
 {
-	return slot_handle_level(kvm, memslot, fn, PG_LEVEL_4K,
-				 PG_LEVEL_4K, flush_on_yield);
+	return walk_slot_rmaps(kvm, slot, fn, PG_LEVEL_4K, PG_LEVEL_4K, flush_on_yield);
 }
 
 static void free_mmu_pages(struct kvm_mmu *mmu)
@@ -6144,9 +6145,9 @@ static bool kvm_rmap_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_e
 			if (WARN_ON_ONCE(start >= end))
 				continue;
 
-			flush = slot_handle_level_range(kvm, memslot, __kvm_zap_rmap,
-							PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL,
-							start, end - 1, true, flush);
+			flush = __walk_slot_rmaps(kvm, memslot, __kvm_zap_rmap,
+						  PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL,
+						  start, end - 1, true, flush);
 		}
 	}
 
@@ -6199,8 +6200,8 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 {
 	if (kvm_memslots_have_rmaps(kvm)) {
 		write_lock(&kvm->mmu_lock);
-		slot_handle_level(kvm, memslot, slot_rmap_write_protect,
-				  start_level, KVM_MAX_HUGEPAGE_LEVEL, false);
+		walk_slot_rmaps(kvm, memslot, slot_rmap_write_protect,
+				start_level, KVM_MAX_HUGEPAGE_LEVEL, false);
 		write_unlock(&kvm->mmu_lock);
 	}
 
@@ -6435,10 +6436,9 @@ static void kvm_shadow_mmu_try_split_huge_pages(struct kvm *kvm,
 	 * all the way to the target level. There's no need to split pages
 	 * already at the target level.
 	 */
-	for (level = KVM_MAX_HUGEPAGE_LEVEL; level > target_level; level--) {
-		slot_handle_level_range(kvm, slot, shadow_mmu_try_split_huge_pages,
-					level, level, start, end - 1, true, false);
-	}
+	for (level = KVM_MAX_HUGEPAGE_LEVEL; level > target_level; level--)
+		__walk_slot_rmaps(kvm, slot, shadow_mmu_try_split_huge_pages,
+				  level, level, start, end - 1, true, false);
 }
 
 /* Must be called with the mmu_lock held in write-mode. */
@@ -6537,8 +6537,8 @@ static void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
 	 * Note, use KVM_MAX_HUGEPAGE_LEVEL - 1 since there's no need to zap
 	 * pages that are already mapped at the maximum hugepage level.
 	 */
-	if (slot_handle_level(kvm, slot, kvm_mmu_zap_collapsible_spte,
-			      PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL - 1, true))
+	if (walk_slot_rmaps(kvm, slot, kvm_mmu_zap_collapsible_spte,
+			    PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL - 1, true))
 		kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
 }
 
@@ -6582,7 +6582,7 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 		 * Clear dirty bits only on 4k SPTEs since the legacy MMU only
 		 * support dirty logging at a 4k granularity.
 		 */
-		slot_handle_level_4k(kvm, memslot, __rmap_clear_dirty, false);
+		walk_slot_rmaps_4k(kvm, memslot, __rmap_clear_dirty, false);
 		write_unlock(&kvm->mmu_lock);
 	}
 
-- 
2.39.1.519.gcb327c4b5f-goog

