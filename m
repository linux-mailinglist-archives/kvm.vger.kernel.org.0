Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99092584838
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 00:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232734AbiG1W2w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 18:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232400AbiG1W2r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 18:28:47 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B3A379ECC
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 15:28:46 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id bu13-20020a056902090d00b00671743601f1so2572104ybb.0
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 15:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=XryKGjH30kdoHbfzHHt82gWC28k2ErteYjCKEWgqhz8=;
        b=MLKseAfNckahYtATeZk/FJVoIlmn7rFmO5ySF4FdPex2ZIXD+B4G46CPo3pCDxrcq1
         oBhwrGMK1wGhjwydYrhNoYjqzYLsPL/yv/7pZRoZecRShOfsDRyMXs254ihJ3WQLgZZ8
         w1CMLiPcmMdTq/KSaca34EvLCR2HH13zeVX0DBrQuQoN2jyqSNaKs5iyR08DS4/mbT2V
         DKEXKyaQRHyLsbPuUvV4pEPgpNmg7I2V5Hqj+b7XYC8VEX2qxMhFDD1C9IyJaVtCsiKA
         jlxL7JynS0BfBh77jk3wo3rCsMaIq2LvQZ9y3pILBE9WLbX1Sm6V2tkEMakMFFKn0rGi
         zI/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=XryKGjH30kdoHbfzHHt82gWC28k2ErteYjCKEWgqhz8=;
        b=yLcU/wGuwJDzcu6cFd/KECacklrCkkexbnNrVdPzQKG0mrn4z0Npg+yMQJiIAB5iEB
         +K3NX2Fr9Cs1pPnTjJ0QmR0+NwGv+v+PC5EwyG8wsLzszk+eYUiKSthHUXQCj9zfiF3Q
         IEa0Ow2+cs/5XGvW2Rf82G7V6SVjRBLCA45JddxZcdgwE1lnYdXXjioN5dcVijEnAP1j
         ZVsEDitMay8VJXyk6F74L0QsIrT+cFqxRZ8MDe6EnDiPc3Kc0vHNP2PpKYaLd/DxHUYQ
         LWbPPQhLYK7I+uUky2gwpwJ0/bzcFTsqw/gZ+UjMxxRZBjnETvxGwpy84xs269mI1alB
         QQOg==
X-Gm-Message-State: ACgBeo3WnJIcKYAMKizdpjKU86XUUGl1sXDi/GvHsfiF8L1dORLPN2E3
        0UCxVwvxnvo0FkSQ2FGfQB7NfxjjPd7gdJV+EuLpJPotknFR2GOmk14JbgZ+zppcn22jM3IUujD
        77BpW0OEYSHNYGB+SCJX68BxXmV+m9JHEQGCsyUpRUvbpa/7+uMJo2zCIjstu
X-Google-Smtp-Source: AA6agR77v2yH0A0y+PVDN3rLoSlgScpkKztWliQcoR/z1IqL2lWe6Zt1Zf/5LVy7q67Vr9liG3FZyor13paw
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2d4:203:14b0:5318:8d0f:301a])
 (user=junaids job=sendgmr) by 2002:a5b:982:0:b0:63e:7d7e:e2f2 with SMTP id
 c2-20020a5b0982000000b0063e7d7ee2f2mr583348ybq.549.1659047325386; Thu, 28 Jul
 2022 15:28:45 -0700 (PDT)
Date:   Thu, 28 Jul 2022 15:28:33 -0700
Message-Id: <20220728222833.3850065-1-junaids@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.455.g008518b4e5-goog
Subject: [PATCH v2] kvm: x86: mmu: Always flush TLBs when enabling dirty logging
From:   Junaid Shahid <junaids@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     seanjc@google.com, dmatlack@google.com
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
As an alternative, we could explicitly check the MMU-Writable bit when
write-protecting SPTEs to decide if a flush is needed (instead of
checking the Writable bit), but given that a flush almost always happens
anyway, so just making it unconditional seems simpler (and probably
slightly more efficient).

Signed-off-by: Junaid Shahid <junaids@google.com>
---
Changes since v1:
- Updated comments based on suggestions from David Matlack and 
  Sean Christopherson

 arch/x86/kvm/mmu/mmu.c  | 28 ++++++++++------------------
 arch/x86/kvm/mmu/spte.h | 14 ++++++++++----
 arch/x86/kvm/x86.c      | 19 +++++++++++++++++++
 3 files changed, 39 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 52664c3caaab..f0d7193db455 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6058,27 +6058,23 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
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
 
 	/*
-	 * Flush TLBs if any SPTEs had to be write-protected to ensure that
-	 * guest writes are reflected in the dirty bitmap before the memslot
-	 * update completes, i.e. before enabling dirty logging is visible to
-	 * userspace.
+	 * The caller will flush TLBs to ensure that guest writes are reflected
+	 * in the dirty bitmap before the memslot update completes, i.e. before
+	 * enabling dirty logging is visible to userspace.
 	 *
 	 * Perform the TLB flush outside the mmu_lock to reduce the amount of
 	 * time the lock is held. However, this does mean that another CPU can
@@ -6097,8 +6093,6 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 	 *
 	 * See is_writable_pte() for more details.
 	 */
-	if (flush)
-		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
 }
 
 static inline bool need_topup(struct kvm_mmu_memory_cache *cache, int min)
@@ -6468,32 +6462,30 @@ void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
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
index ba3dccb202bc..0e43c4a2dd7a 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -330,7 +330,7 @@ static __always_inline bool is_rsvd_spte(struct rsvd_bits_validate *rsvd_check,
 }
 
 /*
- * An shadow-present leaf SPTE may be non-writable for 3 possible reasons:
+ * A shadow-present leaf SPTE may be non-writable for 4 possible reasons:
  *
  *  1. To intercept writes for dirty logging. KVM write-protects huge pages
  *     so that they can be split be split down into the dirty logging
@@ -348,8 +348,13 @@ static __always_inline bool is_rsvd_spte(struct rsvd_bits_validate *rsvd_check,
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
@@ -378,7 +383,8 @@ static __always_inline bool is_rsvd_spte(struct rsvd_bits_validate *rsvd_check,
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
index f389691d8c04..f8b215405fe3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12448,6 +12448,25 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 		} else {
 			kvm_mmu_slot_remove_write_access(kvm, new, PG_LEVEL_4K);
 		}
+
+		/*
+		 * We need to flush the TLBs in either of the following cases:
+		 *
+		 * 1. We had to clear the Dirty bits for some SPTEs
+		 * 2. We had to write-protect some SPTEs and any of those SPTEs
+		 *    had the MMU-Writable bit set, regardless of whether the
+		 *    actual hardware Writable bit was set. This is because as
+		 *    long as the SPTE is MMU-Writable, some CPU may still have
+		 *    writable TLB entries for it, even after the Writable bit
+		 *    has been cleared. For more details, see the comments for
+		 *    is_writable_pte() [specifically the case involving
+		 *    access-tracking SPTEs].
+		 *
+		 * In almost all cases, one of the above conditions will be true.
+		 * So it is simpler (and probably slightly more efficient) to
+		 * just flush the TLBs unconditionally.
+		 */
+		kvm_arch_flush_remote_tlbs_memslot(kvm, new);
 	}
 }
 

base-commit: a4850b5590d01bf3fb19fda3fc5d433f7382a974
-- 
2.37.1.455.g008518b4e5-goog

