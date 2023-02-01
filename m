Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6652E687078
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 22:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbjBAVZz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 16:25:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjBAVZy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 16:25:54 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0307760C98
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 13:25:52 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id m2so14821776plg.4
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 13:25:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DU5kTbNl+RH3eeIIffmTeIkUYxWjZwy4jUC25mAWpXo=;
        b=P+CF/FJz7/GKyrALzTPK8wmUlpbwRa7n75eWAZGzcVUuOD4zOaiJsQWX3wctOYApMp
         wFz6mw7xxPIh0zvq+sYvHCVAYkaw5cJ6DaVyDcs7DRlfgsXPA/RsxwtX+LIVrV1dXLCN
         gUoOgvigfUHyjiNazJr2ZUPH767mKEqYUvV426kxVGXi9z8AZSsbiGrNL2ciAdNV3Ezk
         e7gF2cw0o/Mq0fAWte4f3pwmEO97/blDTWmnR4aETaYBbhIOEoR2+AzRzL8EJcx/xP8q
         tYo/gg2juFbxSsnizaVYAjjWcHVDye6CZBvy2uN8duhnuU3WCt60p6vOhpEcUIsdITq/
         P9bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DU5kTbNl+RH3eeIIffmTeIkUYxWjZwy4jUC25mAWpXo=;
        b=KcWH+IPcP4TT51ZS63OOacQiiD51tWvMUQI2rtPGFJkeMmM/wQ5ZVmJdN3SdT9rqzV
         0S6XTwVimsfFOT6cbATkEQr1LMbLOpBZ6CrfgryuCtW6HLLeYZzY/W0vxVoqcJCrLHKP
         qAFldnwXebKZOrCw2ywXmqZBCsHs6+0UTW6iFDR93x7H5XGces641SxHCB/yTPDLU9EE
         7vYPbj/JYQTFpJ8+cEJl2AV+zFvncso09tAm06SP+oBY+ybkP1QwDpwA0Usje5LBXhac
         FDmWbpBdSg6PlhR2/6ZHnIiarLq7JFqVqX3kW8jrQmPMX8PvfbgeEVs0kZAWrKv52Pwe
         XvBQ==
X-Gm-Message-State: AO0yUKVJFecnt32zV63Xmd0vLwHk/5zwdGTKzLP3WDHp2PLj3D8ICqXK
        8K/L53ugJfmCiAQBON5wAQghrWj4emj5xig+b+4=
X-Google-Smtp-Source: AK7set8DPQiMYJ5mthDpfrhzB3TtGbn30C6FCoM3UC2zsP3u8wANtaddfYoZioRYpkKNrjUj4TzmSg==
X-Received: by 2002:a17:902:d903:b0:198:af4f:de0d with SMTP id c3-20020a170902d90300b00198af4fde0dmr87638plz.13.1675286751260;
        Wed, 01 Feb 2023 13:25:51 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id iw6-20020a170903044600b00189f2fdbdd0sm12242514plb.234.2023.02.01.13.25.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 13:25:50 -0800 (PST)
Date:   Wed, 1 Feb 2023 21:25:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Nagareddy Reddy <nspreddy@google.com>
Subject: Re: [RFC 13/14] KVM: x86/MMU: Wrap uses of kvm_handle_gfn_range in
 mmu.c
Message-ID: <Y9rY2zE/xIgFbc5Q@google.com>
References: <20221221222418.3307832-1-bgardon@google.com>
 <20221221222418.3307832-14-bgardon@google.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="fK8BCxiiY00vw+CK"
Content-Disposition: inline
In-Reply-To: <20221221222418.3307832-14-bgardon@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--fK8BCxiiY00vw+CK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 21, 2022, Ben Gardon wrote:
> @@ -978,9 +978,13 @@ static void slot_rmap_walk_next(struct slot_rmap_walk_iterator *iterator)
>  	     slot_rmap_walk_okay(_iter_);				\
>  	     slot_rmap_walk_next(_iter_))
>  
> -__always_inline bool kvm_handle_gfn_range(struct kvm *kvm,
> -					  struct kvm_gfn_range *range,
> -					  rmap_handler_t handler)
> +typedef bool (*rmap_handler_t)(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
> +			       struct kvm_memory_slot *slot, gfn_t gfn,
> +			       int level, pte_t pte);
> +
> +static __always_inline bool
> +kvm_handle_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,

Don't split function returns/attributes from the function declaration.  I don't
think the rule ended up getting officially documented and enforced, but Linus was
unequivocal when it came up[*], and I happen to agree with him :-)

Actually, since I'm guessing you got the idea from existing code, can you fold
in the attached patches to purge the existing cases in mmu.c before those uglies
get moved around?  Assuming you don't dislike the proposed rename, that is.

[*] https://lore.kernel.org/mm-commits/CAHk-=wjS-Jg7sGMwUPpDsjv392nDOOs0CtUtVkp=S6Q7JzFJRw@mail.gmail.com

--fK8BCxiiY00vw+CK
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-KVM-x86-mmu-Rename-slot-rmap-walkers-to-add-clarity-.patch"

From 1d263c3b37a74d04bd4dbd0ea2944e1692051e95 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 1 Feb 2023 12:20:52 -0800
Subject: [PATCH 1/3] KVM: x86/mmu: Rename slot rmap walkers to add clarity and
 clean up code

Replace "slot_handle_level" with "walk_slot_rmaps" to better capture what
the helpers are doing, and to slightly shorten the function names so that
each function's return type and attributes can be placed on the same line
as the function declaration.

No functional change intended.

Link: https://lore.kernel.org/mm-commits/CAHk-=wjS-Jg7sGMwUPpDsjv392nDOOs0CtUtVkp=S6Q7JzFJRw@mail.gmail.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 66 +++++++++++++++++++++---------------------
 1 file changed, 33 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c91ee2927dd7..3b2c477bbcd5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5813,23 +5813,24 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
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
@@ -5845,23 +5846,23 @@ slot_handle_level_range(struct kvm *kvm, const struct kvm_memory_slot *memslot,
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
@@ -6156,9 +6157,9 @@ static bool kvm_rmap_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_e
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
 
@@ -6211,8 +6212,8 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 {
 	if (kvm_memslots_have_rmaps(kvm)) {
 		write_lock(&kvm->mmu_lock);
-		slot_handle_level(kvm, memslot, slot_rmap_write_protect,
-				  start_level, KVM_MAX_HUGEPAGE_LEVEL, false);
+		walk_slot_rmaps(kvm, memslot, slot_rmap_write_protect,
+				start_level, KVM_MAX_HUGEPAGE_LEVEL, false);
 		write_unlock(&kvm->mmu_lock);
 	}
 
@@ -6447,10 +6448,9 @@ static void kvm_shadow_mmu_try_split_huge_pages(struct kvm *kvm,
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
@@ -6548,8 +6548,8 @@ static void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
 	 * Note, use KVM_MAX_HUGEPAGE_LEVEL - 1 since there's no need to zap
 	 * pages that are already mapped at the maximum hugepage level.
 	 */
-	if (slot_handle_level(kvm, slot, kvm_mmu_zap_collapsible_spte,
-			      PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL - 1, true))
+	if (walk_slot_rmaps(kvm, slot, kvm_mmu_zap_collapsible_spte,
+			    PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL - 1, true))
 		kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
 }
 
@@ -6593,7 +6593,7 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 		 * Clear dirty bits only on 4k SPTEs since the legacy MMU only
 		 * support dirty logging at a 4k granularity.
 		 */
-		slot_handle_level_4k(kvm, memslot, __rmap_clear_dirty, false);
+		walk_slot_rmaps_4k(kvm, memslot, __rmap_clear_dirty, false);
 		write_unlock(&kvm->mmu_lock);
 	}
 

base-commit: 11b36fe7d4500c8ef73677c087f302fd713101c2
-- 
2.39.1.456.gfc5497dd1b-goog


--fK8BCxiiY00vw+CK
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-KVM-x86-mmu-Replace-comment-with-an-actual-lockdep-a.patch"

From 2771b3dee6637b3f8699ec6cc41692d73ae7f892 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 1 Feb 2023 12:32:39 -0800
Subject: [PATCH 2/3] KVM: x86/mmu: Replace comment with an actual lockdep
 assertion on mmu_lock

Assert that mmu_lock is held for write in __walk_slot_rmaps() instead of
hoping the function comment will magically prevent introducing bugs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3b2c477bbcd5..80448b96cf19 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5817,7 +5817,6 @@ typedef bool (*slot_rmaps_handler) (struct kvm *kvm,
 				    struct kvm_rmap_head *rmap_head,
 				    const struct kvm_memory_slot *slot);
 
-/* The caller should hold mmu-lock before calling this function. */
 static __always_inline bool __walk_slot_rmaps(struct kvm *kvm,
 					      const struct kvm_memory_slot *slot,
 					      slot_rmaps_handler fn,
@@ -5827,6 +5826,8 @@ static __always_inline bool __walk_slot_rmaps(struct kvm *kvm,
 {
 	struct slot_rmap_walk_iterator iterator;
 
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
 	for_each_slot_rmap_range(slot, start_level, end_level, start_gfn,
 			end_gfn, &iterator) {
 		if (iterator.rmap)
-- 
2.39.1.456.gfc5497dd1b-goog


--fK8BCxiiY00vw+CK
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0003-KVM-x86-mmu-Clean-up-mmu.c-functions-that-put-return.patch"

From a67e6eaf356f08ca58c9d28f7845ae3e511f24b8 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 1 Feb 2023 12:33:54 -0800
Subject: [PATCH 3/3] KVM: x86/mmu: Clean up mmu.c functions that put return
 type on separate line

Adjust a variety of functions in mmu.c to put the function return type on
the same line as the function declaration.  As stated in the Linus
specification:

  But the "on their own line" is complete garbage to begin with. That
  will NEVER be a kernel rule. We should never have a rule that assumes
  things are so long that they need to be on multiple lines.

  We don't put function return types on their own lines either, even if
  some other projects have that rule (just to get function names at the
  beginning of lines or some other odd reason).

Leave the functions generated by BUILD_MMU_ROLE_REGS_ACCESSOR() as-is,
that code is basically illegible no matter how it's formatted.

No functional change intended.

Link: https://lore.kernel.org/mm-commits/CAHk-=wjS-Jg7sGMwUPpDsjv392nDOOs0CtUtVkp=S6Q7JzFJRw@mail.gmail.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 59 ++++++++++++++++++++----------------------
 1 file changed, 28 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 80448b96cf19..9bb72c22e757 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -888,9 +888,9 @@ static void unaccount_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 	untrack_possible_nx_huge_page(kvm, sp);
 }
 
-static struct kvm_memory_slot *
-gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu, gfn_t gfn,
-			    bool no_dirty_log)
+static struct kvm_memory_slot *gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu,
+							   gfn_t gfn,
+							   bool no_dirty_log)
 {
 	struct kvm_memory_slot *slot;
 
@@ -950,10 +950,9 @@ static int pte_list_add(struct kvm_mmu_memory_cache *cache, u64 *spte,
 	return count;
 }
 
-static void
-pte_list_desc_remove_entry(struct kvm_rmap_head *rmap_head,
-			   struct pte_list_desc *desc, int i,
-			   struct pte_list_desc *prev_desc)
+static void pte_list_desc_remove_entry(struct kvm_rmap_head *rmap_head,
+				       struct pte_list_desc *desc, int i,
+				       struct pte_list_desc *prev_desc)
 {
 	int j = desc->spte_count - 1;
 
@@ -1504,8 +1503,8 @@ struct slot_rmap_walk_iterator {
 	struct kvm_rmap_head *end_rmap;
 };
 
-static void
-rmap_walk_init_level(struct slot_rmap_walk_iterator *iterator, int level)
+static void rmap_walk_init_level(struct slot_rmap_walk_iterator *iterator,
+				 int level)
 {
 	iterator->level = level;
 	iterator->gfn = iterator->start_gfn;
@@ -1513,10 +1512,10 @@ rmap_walk_init_level(struct slot_rmap_walk_iterator *iterator, int level)
 	iterator->end_rmap = gfn_to_rmap(iterator->end_gfn, level, iterator->slot);
 }
 
-static void
-slot_rmap_walk_init(struct slot_rmap_walk_iterator *iterator,
-		    const struct kvm_memory_slot *slot, int start_level,
-		    int end_level, gfn_t start_gfn, gfn_t end_gfn)
+static void slot_rmap_walk_init(struct slot_rmap_walk_iterator *iterator,
+				const struct kvm_memory_slot *slot,
+				int start_level, int end_level,
+				gfn_t start_gfn, gfn_t end_gfn)
 {
 	iterator->slot = slot;
 	iterator->start_level = start_level;
@@ -3304,9 +3303,9 @@ static bool page_fault_can_be_fast(struct kvm_page_fault *fault)
  * Returns true if the SPTE was fixed successfully. Otherwise,
  * someone else modified the SPTE from its original value.
  */
-static bool
-fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
-			u64 *sptep, u64 old_spte, u64 new_spte)
+static bool fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu,
+				    struct kvm_page_fault *fault,
+				    u64 *sptep, u64 old_spte, u64 new_spte)
 {
 	/*
 	 * Theoretically we could also set dirty bit (and flush TLB) here in
@@ -4638,10 +4637,9 @@ static bool sync_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, gfn_t gfn,
 #include "paging_tmpl.h"
 #undef PTTYPE
 
-static void
-__reset_rsvds_bits_mask(struct rsvd_bits_validate *rsvd_check,
-			u64 pa_bits_rsvd, int level, bool nx, bool gbpages,
-			bool pse, bool amd)
+static void __reset_rsvds_bits_mask(struct rsvd_bits_validate *rsvd_check,
+				    u64 pa_bits_rsvd, int level, bool nx,
+				    bool gbpages, bool pse, bool amd)
 {
 	u64 gbpages_bit_rsvd = 0;
 	u64 nonleaf_bit8_rsvd = 0;
@@ -4754,9 +4752,9 @@ static void reset_guest_rsvds_bits_mask(struct kvm_vcpu *vcpu,
 				guest_cpuid_is_amd_or_hygon(vcpu));
 }
 
-static void
-__reset_rsvds_bits_mask_ept(struct rsvd_bits_validate *rsvd_check,
-			    u64 pa_bits_rsvd, bool execonly, int huge_page_level)
+static void __reset_rsvds_bits_mask_ept(struct rsvd_bits_validate *rsvd_check,
+					u64 pa_bits_rsvd, bool execonly,
+					int huge_page_level)
 {
 	u64 high_bits_rsvd = pa_bits_rsvd & rsvd_bits(0, 51);
 	u64 large_1g_rsvd = 0, large_2m_rsvd = 0;
@@ -4856,8 +4854,7 @@ static inline bool boot_cpu_is_amd(void)
  * the direct page table on host, use as much mmu features as
  * possible, however, kvm currently does not do execution-protection.
  */
-static void
-reset_tdp_shadow_zero_bits_mask(struct kvm_mmu *context)
+static void reset_tdp_shadow_zero_bits_mask(struct kvm_mmu *context)
 {
 	struct rsvd_bits_validate *shadow_zero_check;
 	int i;
@@ -5072,8 +5069,8 @@ static void paging32_init_context(struct kvm_mmu *context)
 	context->invlpg = paging32_invlpg;
 }
 
-static union kvm_cpu_role
-kvm_calc_cpu_role(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
+static union kvm_cpu_role kvm_calc_cpu_role(struct kvm_vcpu *vcpu,
+					    const struct kvm_mmu_role_regs *regs)
 {
 	union kvm_cpu_role role = {0};
 
@@ -6664,8 +6661,8 @@ void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
 	}
 }
 
-static unsigned long
-mmu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
+static unsigned long mmu_shrink_scan(struct shrinker *shrink,
+				     struct shrink_control *sc)
 {
 	struct kvm *kvm;
 	int nr_to_scan = sc->nr_to_scan;
@@ -6723,8 +6720,8 @@ mmu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 	return freed;
 }
 
-static unsigned long
-mmu_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
+static unsigned long mmu_shrink_count(struct shrinker *shrink,
+				      struct shrink_control *sc)
 {
 	return percpu_counter_read_positive(&kvm_total_used_mmu_pages);
 }
-- 
2.39.1.456.gfc5497dd1b-goog


--fK8BCxiiY00vw+CK--
