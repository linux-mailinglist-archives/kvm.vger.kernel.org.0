Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8E1057EB92
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 04:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232859AbiGWCld (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 22:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbiGWClc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 22:41:32 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF12C4D17C
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 19:41:30 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id o135-20020a25738d000000b0066f58989d75so4975492ybc.13
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 19:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=OXyQUxnzJQNf39HdEH0kOwYd5hjJ/7wvFw731NHTrQM=;
        b=oIplEIG8pmMCuxqvTNDmOOkCcuSL/3uOK9bu824dKh0d78zPBmdrmdFt2US5FwRxcP
         te4VmdYo1ypthHye1Orhcsaf/aydFXWSt1sP5tP5p76dOnm0lCzBSF8/vdxsYOu/ULUY
         /B/OluGfHy98qeLCKp8vquGRUpniNQgZ1820fr1Zuf7nv7ToMQUFO0Lb/l8iKAOCJh8b
         DaL9ketr04hu1+Enbp2btf5PokXwwSbhx1uMT0Epr/Z4e5UnT+cIiv/ihCoFDsEl/zQm
         zY2dbfexmgpLcueKwl3RF+EzHz01fIRNgC/nLChwO+NbfoaoszyTZEvfFK6Lx66bDDyL
         DpOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=OXyQUxnzJQNf39HdEH0kOwYd5hjJ/7wvFw731NHTrQM=;
        b=1MY+Prl1UNhVYQ21wMJ2tspJuOx/pPFwU55t7XbhyzsuGXZ6fHuguVS73FvZ2YJLAY
         VEBLh7T2DMvcMIom3H+rWlHupH8cjFjy9gKlLa4aEsp+RQ/jXaJKU1qxmjFrRWAMs5xm
         ARc9E4MIz54RB/43N/rV8ixIW8BDDKBxYALxaZVHDgEsWC+d5Ld0d6r2WY4XD2JzRAvH
         Bo3GGBiWf+lBLWYD2ALkHByp/bhIZAFDDYlFirmSPnmUANmFrKSfmrARrcoyOIWQoaa+
         u8O0niIewUxgl0MAUEPl52HjJZcEWA+z8bhTznTTY6bkJzaKE0pW4GB51/6zSSPIEJGb
         JfjA==
X-Gm-Message-State: AJIora+zl41fgCpNjjFn7yktX3f9BQuT/0aqR7Y2NPHNGSmpv722dSzj
        xrqEBHd1uaFlzKOW4lKErZUHlp3xoJjGncPyMeTQVtwwR01+mizOBb7J8u3AWAI1SuEAyap8r2x
        GAs1QZKPxIXCO6T+ThS+it832g4ZZj60UqesTDoR4Q7ATfRCXFqPkubegtOwV
X-Google-Smtp-Source: AGRyM1v/YOC9hc/mcml0MB4ePGnMm6S7W4NKwqRR2BmTigfy5r8XmpLEeQsWBPYpb2EMd5S93ak6TYl7OxSp
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2d4:203:3131:3935:802a:97ba])
 (user=junaids job=sendgmr) by 2002:a25:80c4:0:b0:670:941f:2a6d with SMTP id
 c4-20020a2580c4000000b00670941f2a6dmr2218073ybm.101.1658544090204; Fri, 22
 Jul 2022 19:41:30 -0700 (PDT)
Date:   Fri, 22 Jul 2022 19:41:16 -0700
Message-Id: <20220723024116.2724796-1-junaids@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH] kvm: x86: mmu: Always flush TLBs when enabling dirty logging
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
We could also do something more sophisticated if needed, but given
that a flush almost always happens anyway, so just making it
unconditional doesn't seem too bad.

Signed-off-by: Junaid Shahid <junaids@google.com>
---
 arch/x86/kvm/mmu/mmu.c  | 28 ++++++++++------------------
 arch/x86/kvm/mmu/spte.h |  9 +++++++--
 arch/x86/kvm/x86.c      |  7 +++++++
 3 files changed, 24 insertions(+), 20 deletions(-)

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
index ba3dccb202bc..ec3e79ac4449 100644
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
@@ -348,6 +348,8 @@ static __always_inline bool is_rsvd_spte(struct rsvd_bits_validate *rsvd_check,
  *     read-only memslot or guest memory backed by a read-only VMA. Writes to
  *     such pages are disallowed entirely.
  *
+ *  4. To track the Accessed status for SPTEs without A/D bits.
+ *
  * To keep track of why a given SPTE is write-protected, KVM uses 2
  * software-only bits in the SPTE:
  *
@@ -358,6 +360,8 @@ static __always_inline bool is_rsvd_spte(struct rsvd_bits_validate *rsvd_check,
  *  shadow_host_writable_mask, aka Host-writable -
  *    Cleared on SPTEs that are not host-writable (case 3 above)
  *
+ * In addition, is_acc_track_spte() is true in the case 4 above.
+ *
  * Note, not all possible combinations of PT_WRITABLE_MASK,
  * shadow_mmu_writable_mask, and shadow_host_writable_mask are valid. A given
  * SPTE can be in only one of the following states, which map to the
@@ -378,7 +382,8 @@ static __always_inline bool is_rsvd_spte(struct rsvd_bits_validate *rsvd_check,
  * shadow page tables between vCPUs. Write-protecting an SPTE for dirty logging
  * (which does not clear the MMU-writable bit), does not flush TLBs before
  * dropping the lock, as it only needs to synchronize guest writes with the
- * dirty bitmap.
+ * dirty bitmap. Similarly, the clear_young() MMU notifier also does not flush
+ * TLBs even though the SPTE can become non-writable because of case 4.
  *
  * So, there is the problem: clearing the MMU-writable bit can encounter a
  * write-protected SPTE while CPUs still have writable mappings for that SPTE
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f389691d8c04..8e33e35e4da4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12448,6 +12448,13 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 		} else {
 			kvm_mmu_slot_remove_write_access(kvm, new, PG_LEVEL_4K);
 		}
+
+		/*
+		 * Always flush the TLB even if no PTEs were modified above,
+		 * because it is possible that there may still be stale writable
+		 * TLB entries for non-AD PTEs from a prior clear_young().
+		 */
+		kvm_arch_flush_remote_tlbs_memslot(kvm, new);
 	}
 }
 

base-commit: a4850b5590d01bf3fb19fda3fc5d433f7382a974
-- 
2.37.1.359.gd136c6c3e2-goog

