Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0161A31A90F
	for <lists+kvm@lfdr.de>; Sat, 13 Feb 2021 01:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232435AbhBMAxb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 19:53:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232388AbhBMAws (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Feb 2021 19:52:48 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 898E1C0611C0
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 16:50:50 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id u14so985974qke.14
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 16:50:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=bF14ErUVX+UBo5e1DmjEeRuMTBgvOOGaRVvf7ECwhSc=;
        b=F9S+sMjcAv2NeqcY+KxShiklpZpZOdR2GNLaMP/mYCzYQ6Ev13GHJkLjnqRycXrcbf
         i1cLnn6qwQj2lVE0QHCq19vcSSKaE9EgvpC6RvjdicYpF6H2qiCllKf2uwdpE8dktV0P
         ADRLh0aF429Z5/WSzJCijNmU6ImxWOBPy8efSyqKiaOjy+4NBq43HJQfu2hUgdnMykLL
         D/clAPgE5Ld82ovRlpXMJN/C6TL2Pj2bohzM4gJxXWPvFFrC/HLA12qlhrIZHgZteOUO
         hy1kdL6lS26ZWDC97pqgcD0BzpJ8EudlJE7mFu731IsddarwECQOcgV3iKkVLzjiUD4Y
         310Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=bF14ErUVX+UBo5e1DmjEeRuMTBgvOOGaRVvf7ECwhSc=;
        b=RiBSCC7kijefGddxJnv4unt5pWcEOWNPLjShe4uGqZpWFk59zh7BQ1xCvbebii/mZN
         JdWq/5B1fCJwLv2tkxU2ir20jyBUHgD3Kp3kaMsE01kXMNQSX0Z7m8h+Bi2oSPZ16eWX
         qXiMuMDks8Ib1H/Tb9nYXTW/RldBzieYa24W1yoG/CYc9mSusRjmMTTkv7wJR2OfbG8n
         qVemhZBIPQ+TuwqguSkvt8veXae4wte/KR9OxxVrBkLthpPGyyVDdBryY+bB/Eg561F/
         +0XX2FSJJYhMg6y9/MaLaoyzhAzYOHDoCmzJDByubFmFoKeOTPYCxfFqH3FvZ3e7soYl
         0SWw==
X-Gm-Message-State: AOAM530IhtWFACFIKCCqkzMOWbbu0dHxeNzgorWWaWIgNCp8V+MKpXtl
        I7UfCaGLb7gWEZX1ap0XXqOllKBENMc=
X-Google-Smtp-Source: ABdhPJwHfC5qiRrwILSKinBtYfACaPZ6484V39/wwESfEmROgSNzj8uE29BmfLnJEPJ7XEBdVg6jWzNkXrg=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:b407:1780:13d2:b27])
 (user=seanjc job=sendgmr) by 2002:a05:6214:7cd:: with SMTP id
 bb13mr5161078qvb.7.1613177449760; Fri, 12 Feb 2021 16:50:49 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 12 Feb 2021 16:50:13 -0800
In-Reply-To: <20210213005015.1651772-1-seanjc@google.com>
Message-Id: <20210213005015.1651772-13-seanjc@google.com>
Mime-Version: 1.0
References: <20210213005015.1651772-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH 12/14] KVM: x86/mmu: Don't set dirty bits when disabling dirty
 logging w/ PML
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Makarand Sonare <makarandsonare@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Stop setting dirty bits for MMU pages when dirty logging is disabled for
a memslot, as PML is now completely disabled when there are no memslots
with dirty logging enabled.

This means that spurious PML entries will be created for memslots with
dirty logging disabled if at least one other memslot has dirty logging
enabled, but for all known use cases, dirty logging is a global VMM
control.  Furthermore, spurious PML entries are already possible since
dirty bits are set only when a dirty logging is turned off, i.e. memslots
that are never dirty logged will have dirty bits cleared.

In the end, it's faster overall to eat a few spurious PML entries in the
window where dirty logging is being disabled across all memslots.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 -
 arch/x86/kvm/mmu/mmu.c          | 45 -----------------
 arch/x86/kvm/mmu/tdp_mmu.c      | 54 --------------------
 arch/x86/kvm/mmu/tdp_mmu.h      |  1 -
 arch/x86/kvm/x86.c              | 87 ++++++++++++++-------------------
 5 files changed, 36 insertions(+), 153 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ffcfa84c969d..c15d6de8c457 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1421,8 +1421,6 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 				   struct kvm_memory_slot *memslot);
 void kvm_mmu_slot_largepage_remove_write_access(struct kvm *kvm,
 					struct kvm_memory_slot *memslot);
-void kvm_mmu_slot_set_dirty(struct kvm *kvm,
-			    struct kvm_memory_slot *memslot);
 void kvm_mmu_zap_all(struct kvm *kvm);
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen);
 unsigned long kvm_mmu_calculate_default_mmu_pages(struct kvm *kvm);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 86182e79beaf..44ee55b26c3d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1181,36 +1181,6 @@ static bool __rmap_clear_dirty(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 	return flush;
 }
 
-static bool spte_set_dirty(u64 *sptep)
-{
-	u64 spte = *sptep;
-
-	rmap_printk("spte %p %llx\n", sptep, *sptep);
-
-	/*
-	 * Similar to the !kvm_x86_ops.slot_disable_log_dirty case,
-	 * do not bother adding back write access to pages marked
-	 * SPTE_AD_WRPROT_ONLY_MASK.
-	 */
-	spte |= shadow_dirty_mask;
-
-	return mmu_spte_update(sptep, spte);
-}
-
-static bool __rmap_set_dirty(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
-			     struct kvm_memory_slot *slot)
-{
-	u64 *sptep;
-	struct rmap_iterator iter;
-	bool flush = false;
-
-	for_each_rmap_spte(rmap_head, &iter, sptep)
-		if (spte_ad_enabled(*sptep))
-			flush |= spte_set_dirty(sptep);
-
-	return flush;
-}
-
 /**
  * kvm_mmu_write_protect_pt_masked - write protect selected PT level pages
  * @kvm: kvm instance
@@ -5630,21 +5600,6 @@ void kvm_mmu_slot_largepage_remove_write_access(struct kvm *kvm,
 		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
 }
 
-void kvm_mmu_slot_set_dirty(struct kvm *kvm,
-			    struct kvm_memory_slot *memslot)
-{
-	bool flush;
-
-	write_lock(&kvm->mmu_lock);
-	flush = slot_handle_all_level(kvm, memslot, __rmap_set_dirty, false);
-	if (is_tdp_mmu_enabled(kvm))
-		flush |= kvm_tdp_mmu_slot_set_dirty(kvm, memslot);
-	write_unlock(&kvm->mmu_lock);
-
-	if (flush)
-		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
-}
-
 void kvm_mmu_zap_all(struct kvm *kvm)
 {
 	struct kvm_mmu_page *sp, *node;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index f8fa1f64e10d..c926c6b899a1 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1268,60 +1268,6 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 	}
 }
 
-/*
- * Set the dirty status of all the SPTEs mapping GFNs in the memslot. This is
- * only used for PML, and so will involve setting the dirty bit on each SPTE.
- * Returns true if an SPTE has been changed and the TLBs need to be flushed.
- */
-static bool set_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
-				gfn_t start, gfn_t end)
-{
-	struct tdp_iter iter;
-	u64 new_spte;
-	bool spte_set = false;
-
-	rcu_read_lock();
-
-	tdp_root_for_each_pte(iter, root, start, end) {
-		if (tdp_mmu_iter_cond_resched(kvm, &iter, false))
-			continue;
-
-		if (!is_shadow_present_pte(iter.old_spte) ||
-		    iter.old_spte & shadow_dirty_mask)
-			continue;
-
-		new_spte = iter.old_spte | shadow_dirty_mask;
-
-		tdp_mmu_set_spte(kvm, &iter, new_spte);
-		spte_set = true;
-	}
-
-	rcu_read_unlock();
-	return spte_set;
-}
-
-/*
- * Set the dirty status of all the SPTEs mapping GFNs in the memslot. This is
- * only used for PML, and so will involve setting the dirty bit on each SPTE.
- * Returns true if an SPTE has been changed and the TLBs need to be flushed.
- */
-bool kvm_tdp_mmu_slot_set_dirty(struct kvm *kvm, struct kvm_memory_slot *slot)
-{
-	struct kvm_mmu_page *root;
-	int root_as_id;
-	bool spte_set = false;
-
-	for_each_tdp_mmu_root_yield_safe(kvm, root) {
-		root_as_id = kvm_mmu_page_as_id(root);
-		if (root_as_id != slot->as_id)
-			continue;
-
-		spte_set |= set_dirty_gfn_range(kvm, root, slot->base_gfn,
-				slot->base_gfn + slot->npages);
-	}
-	return spte_set;
-}
-
 /*
  * Clear leaf entries which could be replaced by large mappings, for
  * GFNs within the slot.
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index d31c5ed81a18..3b761c111bff 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -33,7 +33,6 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 				       struct kvm_memory_slot *slot,
 				       gfn_t gfn, unsigned long mask,
 				       bool wrprot);
-bool kvm_tdp_mmu_slot_set_dirty(struct kvm *kvm, struct kvm_memory_slot *slot);
 void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
 				       struct kvm_memory_slot *slot);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b9a8c8af9713..dca2c3333ef2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10789,7 +10789,18 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 
 	/*
 	 * Nothing more to do for RO slots (which can't be dirtied and can't be
-	 * made writable) or CREATE/MOVE/DELETE of a slot.  See comments below.
+	 * made writable) or CREATE/MOVE/DELETE of a slot.
+	 *
+	 * For a memslot with dirty logging disabled:
+	 * CREATE:      No dirty mappings will already exist.
+	 * MOVE/DELETE: The old mappings will already have been cleaned up by
+	 *		kvm_arch_flush_shadow_memslot()
+	 *
+	 * For a memslot with dirty logging enabled:
+	 * CREATE:      No shadow pages exist, thus nothing to write-protect
+	 *		and no dirty bits to clear.
+	 * MOVE/DELETE: The old mappings will already have been cleaned up by
+	 *		kvm_arch_flush_shadow_memslot().
 	 */
 	if ((change != KVM_MR_FLAGS_ONLY) || (new->flags & KVM_MEM_READONLY))
 		return;
@@ -10802,55 +10813,31 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 	if (WARN_ON_ONCE(!((old->flags ^ new->flags) & KVM_MEM_LOG_DIRTY_PAGES)))
 		return;
 
-	/*
-	 * Dirty logging tracks sptes in 4k granularity, meaning that large
-	 * sptes have to be split.  If live migration is successful, the guest
-	 * in the source machine will be destroyed and large sptes will be
-	 * created in the destination. However, if the guest continues to run
-	 * in the source machine (for example if live migration fails), small
-	 * sptes will remain around and cause bad performance.
-	 *
-	 * Scan sptes if dirty logging has been stopped, dropping those
-	 * which can be collapsed into a single large-page spte.  Later
-	 * page faults will create the large-page sptes.
-	 *
-	 * There is no need to do this in any of the following cases:
-	 * CREATE:      No dirty mappings will already exist.
-	 * MOVE/DELETE: The old mappings will already have been cleaned up by
-	 *		kvm_arch_flush_shadow_memslot()
-	 */
-	if (!log_dirty_pages)
+	if (!log_dirty_pages) {
+		/*
+		 * Dirty logging tracks sptes in 4k granularity, meaning that
+		 * large sptes have to be split.  If live migration succeeds,
+		 * the guest in the source machine will be destroyed and large
+		 * sptes will be created in the destination.  However, if the
+		 * guest continues to run in the source machine (for example if
+		 * live migration fails), small sptes will remain around and
+		 * cause bad performance.
+		 *
+		 * Scan sptes if dirty logging has been stopped, dropping those
+		 * which can be collapsed into a single large-page spte.  Later
+		 * page faults will create the large-page sptes.
+		 */
 		kvm_mmu_zap_collapsible_sptes(kvm, new);
-
-	/*
-	 * Enable or disable dirty logging for the slot.
-	 *
-	 * For KVM_MR_DELETE and KVM_MR_MOVE, the shadow pages of the old
-	 * slot have been zapped so no dirty logging updates are needed for
-	 * the old slot.
-	 * For KVM_MR_CREATE and KVM_MR_MOVE, once the new slot is visible
-	 * any mappings that might be created in it will consume the
-	 * properties of the new slot and do not need to be updated here.
-	 *
-	 * When PML is enabled, the kvm_x86_ops dirty logging hooks are
-	 * called to enable/disable dirty logging.
-	 *
-	 * When disabling dirty logging with PML enabled, the D-bit is set
-	 * for sptes in the slot in order to prevent unnecessary GPA
-	 * logging in the PML buffer (and potential PML buffer full VMEXIT).
-	 * This guarantees leaving PML enabled for the guest's lifetime
-	 * won't have any additional overhead from PML when the guest is
-	 * running with dirty logging disabled.
-	 *
-	 * When enabling dirty logging, large sptes are write-protected
-	 * so they can be split on first write.  New large sptes cannot
-	 * be created for this slot until the end of the logging.
-	 * See the comments in fast_page_fault().
-	 * For small sptes, nothing is done if the dirty log is in the
-	 * initial-all-set state.  Otherwise, depending on whether pml
-	 * is enabled the D-bit or the W-bit will be cleared.
-	 */
-	if (log_dirty_pages) {
+	} else {
+		/*
+		 * Large sptes are write-protected so they can be split on first
+		 * write. New large sptes cannot be created for this slot until
+		 * the end of the logging. See the comments in fast_page_fault().
+		 *
+		 * For small sptes, nothing is done if the dirty log is in the
+		 * initial-all-set state.  Otherwise, depending on whether pml
+		 * is enabled the D-bit or the W-bit will be cleared.
+		 */
 		if (kvm_x86_ops.cpu_dirty_log_size) {
 			if (!kvm_dirty_log_manual_protect_and_init_set(kvm))
 				kvm_mmu_slot_leaf_clear_dirty(kvm, new);
@@ -10870,8 +10857,6 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 			 */
 			kvm_mmu_slot_remove_write_access(kvm, new, level);
 		}
-	} else if (kvm_x86_ops.cpu_dirty_log_size) {
-		kvm_mmu_slot_set_dirty(kvm, new);
 	}
 }
 
-- 
2.30.0.478.g8a0d178c01-goog

