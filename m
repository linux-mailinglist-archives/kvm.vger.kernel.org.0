Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0862B50C70D
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 05:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232784AbiDWDvT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 23:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232756AbiDWDvM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 23:51:12 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A42A1C2415
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 20:48:16 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id m8-20020a62a208000000b0050593296139so6575343pff.1
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 20:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=moq5t2aceAdbzIzukfRmgSKet+BsMKCYgSlsSAirzs0=;
        b=FbDhbCaF8hOQ7EYUVhNkt6Tmwu1NFcBdYH6RBxl2Sh3YMMQBgs0eDoRhoGrFjg3HBX
         WaQaXIJWLH1C5vWv397BpYdWwHWnhAVDs6kIib54ckP1KMbipi/UZEj1oFKGgoRqWee3
         PxJ1j32pQ6Uqq3FkvX0hfj4D7UuXKPC3boSebggtMZxhnkAeDZo3AT1tHnQQLCfwMPPZ
         Y4DtNppAsVRLppmn2mBkDINvS0VmaA0s2WFX92khgy9kE0g4qPnXX1iR8ATFxRRb3mo2
         YUtzfLWgjxZDrLgGnKgvKWc5/57X7tlzAFj8RSVtOpdVwQt4BEAwWGycFivQazrN1PE8
         JKAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=moq5t2aceAdbzIzukfRmgSKet+BsMKCYgSlsSAirzs0=;
        b=B8eorJoVVqdjCg3MYkHR0ZkVjMxXEfDCgO2l420dHht8L91LOuryyhzbkpnXjYfGLl
         G8CmEyKlnkV745hp1axRgv/srUduv4xaTSqsgeRbtXhCv6MCdK3EaZ1RlV6cbY1dsSxt
         C6MgzTXliSpGZ3I9lltbYJ6Smb5EfNRlAPyaRasoaiaHWlIGmiPpy1TTfu6gZYqvGqPR
         fjMUqWXZNVtcwLKpZub3+3ryVClVgmH9RBrJoNsyilwIMqkNtPCAsJRvyhUYs6okWYmm
         /bWVUMRbAhvfejh8gERijs71CJQmZLxRPbzvxN8rrMOoGP63/xA3i2rzT5YPV3DF/THl
         AQHg==
X-Gm-Message-State: AOAM532gYDJOEvXOi/SxduK3/tvVKmUpA94pzmHeeFdfFF0XNp9CAUH1
        ryfECIifL8L/8oRBcPtF1+o1MyLBbsE=
X-Google-Smtp-Source: ABdhPJzcS9IArhXpxbfXdD5/BljR1DmGHgBCCOg8nBjyT9uxpr1r7vUEFp8lVhJl8c/G5V31ziU92656SWc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:a593:b0:1c9:b837:e77d with SMTP id
 b19-20020a17090aa59300b001c9b837e77dmr8653466pjq.205.1650685695924; Fri, 22
 Apr 2022 20:48:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Apr 2022 03:47:43 +0000
In-Reply-To: <20220423034752.1161007-1-seanjc@google.com>
Message-Id: <20220423034752.1161007-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220423034752.1161007-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH 03/12] KVM: x86/mmu: Use atomic XCHG to write TDP MMU SPTEs
 with volatile bits
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Venkatesh Srinivas <venkateshs@google.com>,
        Chao Peng <chao.p.peng@linux.intel.com>
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

Use an atomic XCHG to write TDP MMU SPTEs that have volatile bits, even
if mmu_lock is held for write, as volatile SPTEs can be written by other
tasks/vCPUs outside of mmu_lock.  If a vCPU uses the to-be-modified SPTE
to write a page, the CPU can cache the translation as WRITABLE in the TLB
despite it being seen by KVM as !WRITABLE, and/or KVM can clobber the
Accessed/Dirty bits and not properly tag the backing page.

Exempt non-leaf SPTEs from atomic updates as KVM itself doesn't modify
non-leaf SPTEs without holding mmu_lock, they do not have Dirty bits, and
KVM doesn't consume the Accessed bit of non-leaf SPTEs.

Dropping the Dirty and/or Writable bits is most problematic for dirty
logging, as doing so can result in a missed TLB flush and eventually a
missed dirty page.  In the unlikely event that the only dirty page(s) is
a clobbered SPTE, clear_dirty_gfn_range() will see the SPTE as not dirty
(based on the Dirty or Writable bit depending on the method) and so not
update the SPTE and ultimately not flush.  If the SPTE is cached in the
TLB as writable before it is clobbered, the guest can continue writing
the associated page without ever taking a write-protect fault.

For most (all?) file back memory, dropping the Dirty bit is a non-issue.
The primary MMU write-protects its PTEs on writeback, i.e. KVM's dirty
bit is effectively ignored because the primary MMU will mark that page
dirty when the write-protection is lifted, e.g. when KVM faults the page
back in for write.

The Accessed bit is a complete non-issue.  Aside from being unused for
non-leaf SPTEs, KVM doesn't do a TLB flush when aging SPTEs, i.e. the
Accessed bit may be dropped anyways.

Lastly, the Writable bit is also problematic as an extension of the Dirty
bit, as KVM (correctly) treats the Dirty bit as volatile iff the SPTE is
!DIRTY && WRITABLE.  If KVM fixes an MMU-writable, but !WRITABLE, SPTE
out of mmu_lock, then it can allow the CPU to set the Dirty bit despite
the SPTE being !WRITABLE when it is checked by KVM.  But that all depends
on the Dirty bit being problematic in the first place.

Fixes: 2f2fad0897cb ("kvm: x86/mmu: Add functions to handle changed TDP SPTEs")
Cc: stable@vger.kernel.org
Cc: Ben Gardon <bgardon@google.com>
Cc: David Matlack <dmatlack@google.com>
Cc: Venkatesh Srinivas <venkateshs@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_iter.h | 34 ++++++++++++++-
 arch/x86/kvm/mmu/tdp_mmu.c  | 82 ++++++++++++++++++++++++-------------
 2 files changed, 85 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index b1eaf6ec0e0b..f0af385c56e0 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -6,6 +6,7 @@
 #include <linux/kvm_host.h>
 
 #include "mmu.h"
+#include "spte.h"
 
 /*
  * TDP MMU SPTEs are RCU protected to allow paging structures (non-leaf SPTEs)
@@ -17,9 +18,38 @@ static inline u64 kvm_tdp_mmu_read_spte(tdp_ptep_t sptep)
 {
 	return READ_ONCE(*rcu_dereference(sptep));
 }
-static inline void kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 val)
+
+static inline u64 kvm_tdp_mmu_write_spte_atomic(tdp_ptep_t sptep, u64 new_spte)
 {
-	WRITE_ONCE(*rcu_dereference(sptep), val);
+	return xchg(rcu_dereference(sptep), new_spte);
+}
+
+static inline void __kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 new_spte)
+{
+	WRITE_ONCE(*rcu_dereference(sptep), new_spte);
+}
+
+static inline u64 kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 old_spte,
+					 u64 new_spte, int level)
+{
+	/*
+	 * Atomically write the SPTE if it is a shadow-present, leaf SPTE with
+	 * volatile bits, i.e. has bits that can be set outside of mmu_lock.
+	 * The Writable bit can be set by KVM's fast page fault handler, and
+	 * Accessed and Dirty bits can be set by the CPU.
+	 *
+	 * Note, non-leaf SPTEs do have Accessed bits and those bits are
+	 * technically volatile, but KVM doesn't consume the Accessed bit of
+	 * non-leaf SPTEs, i.e. KVM doesn't care if it clobbers the bit.  This
+	 * logic needs to be reassessed if KVM were to use non-leaf Accessed
+	 * bits, e.g. to skip stepping down into child SPTEs when aging SPTEs.
+	 */
+	if (is_shadow_present_pte(old_spte) && is_last_spte(old_spte, level) &&
+	    spte_has_volatile_bits(old_spte))
+		return kvm_tdp_mmu_write_spte_atomic(sptep, new_spte);
+
+	__kvm_tdp_mmu_write_spte(sptep, new_spte);
+	return old_spte;
 }
 
 /*
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 566548a3efa7..e9033cce8aeb 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -426,9 +426,9 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
 	tdp_mmu_unlink_sp(kvm, sp, shared);
 
 	for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
-		u64 *sptep = rcu_dereference(pt) + i;
+		tdp_ptep_t sptep = pt + i;
 		gfn_t gfn = base_gfn + i * KVM_PAGES_PER_HPAGE(level);
-		u64 old_child_spte;
+		u64 old_spte;
 
 		if (shared) {
 			/*
@@ -440,8 +440,8 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
 			 * value to the removed SPTE value.
 			 */
 			for (;;) {
-				old_child_spte = xchg(sptep, REMOVED_SPTE);
-				if (!is_removed_spte(old_child_spte))
+				old_spte = kvm_tdp_mmu_write_spte_atomic(sptep, REMOVED_SPTE);
+				if (!is_removed_spte(old_spte))
 					break;
 				cpu_relax();
 			}
@@ -455,23 +455,43 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
 			 * are guarded by the memslots generation, not by being
 			 * unreachable.
 			 */
-			old_child_spte = READ_ONCE(*sptep);
-			if (!is_shadow_present_pte(old_child_spte))
+			old_spte = kvm_tdp_mmu_read_spte(sptep);
+			if (!is_shadow_present_pte(old_spte))
 				continue;
 
 			/*
-			 * Marking the SPTE as a removed SPTE is not
-			 * strictly necessary here as the MMU lock will
-			 * stop other threads from concurrently modifying
-			 * this SPTE. Using the removed SPTE value keeps
-			 * the two branches consistent and simplifies
-			 * the function.
+			 * Use the common helper instead of a raw WRITE_ONCE as
+			 * the SPTE needs to be updated atomically if it can be
+			 * modified by a different vCPU outside of mmu_lock.
+			 * Even though the parent SPTE is !PRESENT, the TLB
+			 * hasn't yet been flushed, and both Intel and AMD
+			 * document that A/D assists can use upper-level PxE
+			 * entries that are cached in the TLB, i.e. the CPU can
+			 * still access the page and mark it dirty.
+			 *
+			 * No retry is needed in the atomic update path as the
+			 * sole concern is dropping a Dirty bit, i.e. no other
+			 * task can zap/remove the SPTE as mmu_lock is held for
+			 * write.  Marking the SPTE as a removed SPTE is not
+			 * strictly necessary for the same reason, but using
+			 * the remove SPTE value keeps the shared/exclusive
+			 * paths consistent and allows the handle_changed_spte()
+			 * call below to hardcode the new value to REMOVED_SPTE.
+			 *
+			 * Note, even though dropping a Dirty bit is the only
+			 * scenario where a non-atomic update could result in a
+			 * functional bug, simply checking the Dirty bit isn't
+			 * sufficient as a fast page fault could read the upper
+			 * level SPTE before it is zapped, and then make this
+			 * target SPTE writable, resume the guest, and set the
+			 * Dirty bit between reading the SPTE above and writing
+			 * it here.
 			 */
-			WRITE_ONCE(*sptep, REMOVED_SPTE);
+			old_spte = kvm_tdp_mmu_write_spte(sptep, old_spte,
+							  REMOVED_SPTE, level);
 		}
 		handle_changed_spte(kvm, kvm_mmu_page_as_id(sp), gfn,
-				    old_child_spte, REMOVED_SPTE, level,
-				    shared);
+				    old_spte, REMOVED_SPTE, level, shared);
 	}
 
 	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
@@ -667,14 +687,13 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 					   KVM_PAGES_PER_HPAGE(iter->level));
 
 	/*
-	 * No other thread can overwrite the removed SPTE as they
-	 * must either wait on the MMU lock or use
-	 * tdp_mmu_set_spte_atomic which will not overwrite the
-	 * special removed SPTE value. No bookkeeping is needed
-	 * here since the SPTE is going from non-present
-	 * to non-present.
+	 * No other thread can overwrite the removed SPTE as they must either
+	 * wait on the MMU lock or use tdp_mmu_set_spte_atomic() which will not
+	 * overwrite the special removed SPTE value. No bookkeeping is needed
+	 * here since the SPTE is going from non-present to non-present.  Use
+	 * the raw write helper to avoid an unnecessary check on volatile bits.
 	 */
-	kvm_tdp_mmu_write_spte(iter->sptep, 0);
+	__kvm_tdp_mmu_write_spte(iter->sptep, 0);
 
 	return 0;
 }
@@ -699,10 +718,13 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
  *		      unless performing certain dirty logging operations.
  *		      Leaving record_dirty_log unset in that case prevents page
  *		      writes from being double counted.
+ *
+ * Returns the old SPTE value, which _may_ be different than @old_spte if the
+ * SPTE had voldatile bits.
  */
-static void __tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
-			       u64 old_spte, u64 new_spte, gfn_t gfn, int level,
-			       bool record_acc_track, bool record_dirty_log)
+static u64 __tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
+			      u64 old_spte, u64 new_spte, gfn_t gfn, int level,
+			      bool record_acc_track, bool record_dirty_log)
 {
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
@@ -715,7 +737,7 @@ static void __tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 	 */
 	WARN_ON(is_removed_spte(old_spte) || is_removed_spte(new_spte));
 
-	kvm_tdp_mmu_write_spte(sptep, new_spte);
+	old_spte = kvm_tdp_mmu_write_spte(sptep, old_spte, new_spte, level);
 
 	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level, false);
 
@@ -724,6 +746,7 @@ static void __tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 	if (record_dirty_log)
 		handle_changed_spte_dirty_log(kvm, as_id, gfn, old_spte,
 					      new_spte, level);
+	return old_spte;
 }
 
 static inline void _tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
@@ -732,9 +755,10 @@ static inline void _tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 {
 	WARN_ON_ONCE(iter->yielded);
 
-	__tdp_mmu_set_spte(kvm, iter->as_id, iter->sptep, iter->old_spte,
-			   new_spte, iter->gfn, iter->level,
-			   record_acc_track, record_dirty_log);
+	iter->old_spte = __tdp_mmu_set_spte(kvm, iter->as_id, iter->sptep,
+					    iter->old_spte, new_spte,
+					    iter->gfn, iter->level,
+					    record_acc_track, record_dirty_log);
 }
 
 static inline void tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

