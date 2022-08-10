Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7AA58F487
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 00:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233585AbiHJWuL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 18:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233610AbiHJWuJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 18:50:09 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5826126540
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 15:50:07 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-31f3959ba41so136316327b3.2
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 15:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
        bh=/4quRU01d/dGSqf+Z4b6fU1eZQPxJ5zcYi48Xjmdo1Q=;
        b=hRkHeC83R300XZQvPtkcRRWC3J/L5Oi6BHtddkTLlDG/umWbEt7G7RU2+0gLlVBn4f
         flVvrnJIkPZX/OjtyvnifpZSYCNGlUfEDCaw22YweV1fDkYeF3e9Wk4ldKO3bZ+tic3h
         f7cwA6dD0O1vzcXIS+N7uKZvHCSmGkSy0gxkx844Rf1Nkp7b6Nei7bG9UhVYFGE9mquV
         3eeGErHJdW4a7U9pvw8PLEp4DM+fkqnl6blMrG5JbsghmwL3+Ed3RuKuca3fSgInxVFl
         efceh1xohzeUZPmUQU//ZopzlER3Em5d1yDPcq8aqDt1CKb85oe8HJpSw15LWqFnmhcs
         EHxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc;
        bh=/4quRU01d/dGSqf+Z4b6fU1eZQPxJ5zcYi48Xjmdo1Q=;
        b=D+1NR25dCOBY2FpBj3BJxm0AbZ1OYUH0+uLinqwdCrwZ1r5TsEXXE8YvWeBcVswy6a
         aC/7TuhU9D7h0kQ/GPaVIKgA5eCIQLtDVXNyNaTT2SHESZPIcOOKsJIEsuRwZ+itD2pI
         Clwud6VvlK7Ei7XtZ/d/kJ+26G8vRqu2foC8Jivms+zmzDTZuPrPAeTQj4/6kZ+qmchD
         y11hwEZEyud+PIUbyQLVu5ppz4SnXecqKiQELwV3zR0E1BRnO4UsDZDMmFj/V5lB2BsZ
         nd6xM/vZnrP2XT4hkk+8J6N2PX7you5rtqgTE4oxTeDHG7VdjDbKCN5g1Hg2cbE2cgDi
         TG/w==
X-Gm-Message-State: ACgBeo2GCnkSVF7BKim16TPTV8SScUwzwjvRQR8zb2ShHyhzUxGvQlSH
        U3Ij0+Z1ux67NXjWzDFXlgkQNyad69M9j75KlCHBHQAjfIJH2aQvbpv/1WXger/j/QEhmMx2BA1
        e4d/+DH/mb/S7or1k4koWmexxOyEryfAUiJLByQIa/dvXFeMGBF8lbd4viSNF
X-Google-Smtp-Source: AA6agR6xMIM9bLJP3bveni5yFI8f6/AJlefTo+kBWgpKdUa4bpV1dz3tDWkubIZba7GFk6zq5NxX6l3RvY6+
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2d4:203:762:d936:685c:7f38])
 (user=junaids job=sendgmr) by 2002:a05:6902:114d:b0:66d:9fa6:4bd4 with SMTP
 id p13-20020a056902114d00b0066d9fa64bd4mr26209397ybu.362.1660171806554; Wed,
 10 Aug 2022 15:50:06 -0700 (PDT)
Date:   Wed, 10 Aug 2022 15:49:39 -0700
Message-Id: <20220810224939.2611160-1-junaids@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [PATCH v3] kvm: x86: mmu: Always flush TLBs when enabling dirty logging
From:   Junaid Shahid <junaids@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     seanjc@google.com, dmatlack@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When A/D bits are not available, KVM uses a software access tracking
mechanism, which involves making the SPTEs inaccessible. However,
the clear_young() MMU notifier does not flush TLBs. So it is possible
that there may still be stale, potentially writable, TLB entries.
This is usually fine, but can be problematic when enabling dirty
logging, because it currently only does a TLB flush if any SPTEs were
modified. But if all SPTEs are in access-tracked state, then there
won't be a TLB flush, which means that the guest could still possibly
write to memory and not have it reflected in the dirty bitmap.

So just unconditionally flush the TLBs when enabling dirty logging.
As an alternative, KVM could explicitly check the MMU-Writable bit when
write-protecting SPTEs to decide if a flush is needed (instead of
checking the Writable bit), but given that a flush almost always happens
anyway, so just making it unconditional seems simpler.

Signed-off-by: Junaid Shahid <junaids@google.com>
---
Changes in v1+v2:
- Updated comments based on suggestions from David Matlack and 
  Sean Christopherson

 arch/x86/kvm/mmu/mmu.c  | 45 +++++++----------------------------------
 arch/x86/kvm/mmu/spte.h | 14 +++++++++----
 arch/x86/kvm/x86.c      | 44 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 61 insertions(+), 42 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index eccddb136954..75928984cf14 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6085,47 +6085,18 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 				      const struct kvm_memory_slot *memslot,
 				      int start_level)
 {
-	bool flush = false;
-
 	if (kvm_memslots_have_rmaps(kvm)) {
 		write_lock(&kvm->mmu_lock);
-		flush = slot_handle_level(kvm, memslot, slot_rmap_write_protect,
-					  start_level, KVM_MAX_HUGEPAGE_LEVEL,
-					  false);
+		slot_handle_level(kvm, memslot, slot_rmap_write_protect,
+				  start_level, KVM_MAX_HUGEPAGE_LEVEL, false);
 		write_unlock(&kvm->mmu_lock);
 	}
 
 	if (is_tdp_mmu_enabled(kvm)) {
 		read_lock(&kvm->mmu_lock);
-		flush |= kvm_tdp_mmu_wrprot_slot(kvm, memslot, start_level);
+		kvm_tdp_mmu_wrprot_slot(kvm, memslot, start_level);
 		read_unlock(&kvm->mmu_lock);
 	}
-
-	/*
-	 * Flush TLBs if any SPTEs had to be write-protected to ensure that
-	 * guest writes are reflected in the dirty bitmap before the memslot
-	 * update completes, i.e. before enabling dirty logging is visible to
-	 * userspace.
-	 *
-	 * Perform the TLB flush outside the mmu_lock to reduce the amount of
-	 * time the lock is held. However, this does mean that another CPU can
-	 * now grab mmu_lock and encounter a write-protected SPTE while CPUs
-	 * still have a writable mapping for the associated GFN in their TLB.
-	 *
-	 * This is safe but requires KVM to be careful when making decisions
-	 * based on the write-protection status of an SPTE. Specifically, KVM
-	 * also write-protects SPTEs to monitor changes to guest page tables
-	 * during shadow paging, and must guarantee no CPUs can write to those
-	 * page before the lock is dropped. As mentioned in the previous
-	 * paragraph, a write-protected SPTE is no guarantee that CPU cannot
-	 * perform writes. So to determine if a TLB flush is truly required, KVM
-	 * will clear a separate software-only bit (MMU-writable) and skip the
-	 * flush if-and-only-if this bit was already clear.
-	 *
-	 * See is_writable_pte() for more details.
-	 */
-	if (flush)
-		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
 }
 
 static inline bool need_topup(struct kvm_mmu_memory_cache *cache, int min)
@@ -6493,32 +6464,30 @@ void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
 void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 				   const struct kvm_memory_slot *memslot)
 {
-	bool flush = false;
-
 	if (kvm_memslots_have_rmaps(kvm)) {
 		write_lock(&kvm->mmu_lock);
 		/*
 		 * Clear dirty bits only on 4k SPTEs since the legacy MMU only
 		 * support dirty logging at a 4k granularity.
 		 */
-		flush = slot_handle_level_4k(kvm, memslot, __rmap_clear_dirty, false);
+		slot_handle_level_4k(kvm, memslot, __rmap_clear_dirty, false);
 		write_unlock(&kvm->mmu_lock);
 	}
 
 	if (is_tdp_mmu_enabled(kvm)) {
 		read_lock(&kvm->mmu_lock);
-		flush |= kvm_tdp_mmu_clear_dirty_slot(kvm, memslot);
+		kvm_tdp_mmu_clear_dirty_slot(kvm, memslot);
 		read_unlock(&kvm->mmu_lock);
 	}
 
 	/*
+	 * The caller will flush the TLBs after this function returns.
+	 *
 	 * It's also safe to flush TLBs out of mmu lock here as currently this
 	 * function is only used for dirty logging, in which case flushing TLB
 	 * out of mmu lock also guarantees no dirty pages will be lost in
 	 * dirty_bitmap.
 	 */
-	if (flush)
-		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
 }
 
 void kvm_mmu_zap_all(struct kvm *kvm)
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index f3744eea45f5..7670c13ce251 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -343,7 +343,7 @@ static __always_inline bool is_rsvd_spte(struct rsvd_bits_validate *rsvd_check,
 }
 
 /*
- * An shadow-present leaf SPTE may be non-writable for 3 possible reasons:
+ * A shadow-present leaf SPTE may be non-writable for 4 possible reasons:
  *
  *  1. To intercept writes for dirty logging. KVM write-protects huge pages
  *     so that they can be split be split down into the dirty logging
@@ -361,8 +361,13 @@ static __always_inline bool is_rsvd_spte(struct rsvd_bits_validate *rsvd_check,
  *     read-only memslot or guest memory backed by a read-only VMA. Writes to
  *     such pages are disallowed entirely.
  *
- * To keep track of why a given SPTE is write-protected, KVM uses 2
- * software-only bits in the SPTE:
+ *  4. To emulate the Accessed bit for SPTEs without A/D bits.  Note, in this
+ *     case, the SPTE is access-protected, not just write-protected!
+ *
+ * For cases #1 and #4, KVM can safely make such SPTEs writable without taking
+ * mmu_lock as capturing the Accessed/Dirty state doesn't require taking it.
+ * To differentiate #1 and #4 from #2 and #3, KVM uses two software-only bits
+ * in the SPTE:
  *
  *  shadow_mmu_writable_mask, aka MMU-writable -
  *    Cleared on SPTEs that KVM is currently write-protecting for shadow paging
@@ -391,7 +396,8 @@ static __always_inline bool is_rsvd_spte(struct rsvd_bits_validate *rsvd_check,
  * shadow page tables between vCPUs. Write-protecting an SPTE for dirty logging
  * (which does not clear the MMU-writable bit), does not flush TLBs before
  * dropping the lock, as it only needs to synchronize guest writes with the
- * dirty bitmap.
+ * dirty bitmap. Similarly, making the SPTE inaccessible (and non-writable) for
+ * access-tracking via the clear_young() MMU notifier also does not flush TLBs.
  *
  * So, there is the problem: clearing the MMU-writable bit can encounter a
  * write-protected SPTE while CPUs still have writable mappings for that SPTE
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 132d662d9713..fefacab335fb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12474,6 +12474,50 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 		} else {
 			kvm_mmu_slot_remove_write_access(kvm, new, PG_LEVEL_4K);
 		}
+
+		/*
+		 * Unconditionally flush the TLBs after enabling dirty logging.
+		 * A flush is almost always going to be necessary (see below),
+		 * and unconditionally flushing allows the helpers to omit
+		 * the subtly complex checks when removing write access.
+		 *
+		 * Do the flush outside of mmu_lock to reduce the amount of
+		 * time mmu_lock is held.  Flushing after dropping mmu_lock is
+		 * safe as KVM only needs to guarantee the slot is fully
+		 * write-protected before returning to userspace, i.e. before
+		 * userspace can consume the dirty status.
+		 *
+		 * Flushing outside of mmu_lock requires KVM to be careful when
+		 * making decisions based on writable status of an SPTE, e.g. a
+		 * !writable SPTE doesn't guarantee a CPU can't perform writes.
+		 *
+		 * Specifically, KVM also write-protects guest page tables to
+		 * monitor changes when using shadow paging, and must guarantee
+		 * no CPUs can write to those page before mmu_lock is dropped.
+		 * Because CPUs may have stale TLB entries at this point, a
+		 * !writable SPTE doesn't guarantee CPUs can't perform writes.
+		 *
+		 * KVM also allows making SPTES writable outside of mmu_lock,
+		 * e.g. to allow dirty logging without taking mmu_lock.
+		 *
+		 * To handle these scenarios, KVM uses a separate software-only
+		 * bit (MMU-writable) to track if a SPTE is !writable due to
+		 * a guest page table being write-protected (KVM clears the
+		 * MMU-writable flag when write-protecting for shadow paging).
+		 *
+		 * The use of MMU-writable is also the primary motivation for
+		 * the unconditional flush.  Because KVM must guarantee that a
+		 * CPU doesn't contain stale, writable TLB entries for a
+		 * !MMU-writable SPTE, KVM must flush if it encounters any
+		 * MMU-writable SPTE regardless of whether the actual hardware
+		 * writable bit was set.  I.e. KVM is almost guaranteed to need
+		 * to flush, while unconditionally flushing allows the "remove
+		 * write access" helpers to ignore MMU-writable entirely.
+		 *
+		 * See is_writable_pte() for more details (the case involving
+		 * access-tracked SPTEs is particularly relevant).
+		 */
+		kvm_arch_flush_remote_tlbs_memslot(kvm, new);
 	}
 }
 

base-commit: 6348aafa8d24c156124f76b5a1507079c3213112
-- 
2.37.1.559.g78731f0fdb-goog

