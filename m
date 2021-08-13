Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A685D3EBD77
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 22:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234433AbhHMUfo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 16:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234365AbhHMUfn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 16:35:43 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B0A4C0617AD
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 13:35:16 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id o17-20020ae9f5110000b02903d22e54c86eso8219227qkg.8
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 13:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=YexKCcJGTHEvrqc5W+Lk2o+DH61+xdD3D5sl+BOf8D4=;
        b=fc9y0myyE09foimYLPZWehqj1f/DpdIs2E3xy4vL3EzI1u4AvgO4Oms/4weetwFOvl
         OWdNSBiKid2X8wD54UppFQPhknjmtbBVOT5QTuuzyMk8OGPJtZZ1EaDAVRGoJEVz3lLm
         9Tm7GTf+2EXqpXVWNpV96YDAU7mVrFAPOGV2ajOd2Fa2UkzTNHqPIVmsZFgAQ7jbyp5g
         wD4cBJLIg9gYUc+fpHcSW7wMk4B2pDIVc0BU/bZbfS+GXUoIxc88lieQ/0A/NX2PXXkB
         rNgxBx7zFLIE37cPf1OzL1Q69WuPqdxu+AMgxwlzCcC2dogAHBRTgR9A5wvK6yAoAXUc
         8vGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YexKCcJGTHEvrqc5W+Lk2o+DH61+xdD3D5sl+BOf8D4=;
        b=MzlIowc9rSsgWIHRqXL9rkK7t+OZKA2cxY8UDwSlma2tAMr66Jo5rSOnT1kykZZqg4
         0FBusGlctwYvoQCKWUKoDqRhVD/vj9aUoxyKUEWizXcII3bcc08iGsuBHQQK0ZLnR0xW
         z+6VipEfIAVOiJMt9MwtVt0/3lB1f+3A+Oij3zfIFXLbrfC0gyVuDu3/itNqh3lvKeIy
         SI0ZHn9J5Uzfz1Xed2LPwLW3vXSoGX8uw/wCrUy/rAsraMp1MkFzMUOf8zznMBkjFy/t
         1L9vq8uUmVaQvjlW4UnxBAu+Tth4LAP+yWD094joBTas+3lyHrL8xfqqzFquv3ZOSXE4
         b5Bg==
X-Gm-Message-State: AOAM532edmpmw2QXFz2aU7+7/j7MzEIUr5m457Jp+OgxRJjgACZmvVjU
        CZu7QTJ7/Zoy5imeTzGeL7GBYrz88V1E2Q==
X-Google-Smtp-Source: ABdhPJwnZIlhDRx5bQDknB4NHTcz7lqW3mjF0oDUen/sbB9SwQbTfpIfjjNRkm7+mh4Pu2u90aZctK2Axz2Kmw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a0c:aac2:: with SMTP id
 g2mr4524117qvb.44.1628886915759; Fri, 13 Aug 2021 13:35:15 -0700 (PDT)
Date:   Fri, 13 Aug 2021 20:35:04 +0000
In-Reply-To: <20210813203504.2742757-1-dmatlack@google.com>
Message-Id: <20210813203504.2742757-7-dmatlack@google.com>
Mime-Version: 1.0
References: <20210813203504.2742757-1-dmatlack@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [RFC PATCH 6/6] KVM: x86/mmu: Avoid memslot lookup in mmu_try_to_unsync_pages
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

mmu_try_to_unsync_pages checks if page tracking is active for the given
gfn, which requires knowing the memslot. We can pass down the memslot
all the way from mmu_set_spte to avoid this lookup.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/include/asm/kvm_page_track.h |  2 --
 arch/x86/kvm/mmu/mmu.c                | 16 +++++++++-------
 arch/x86/kvm/mmu/mmu_internal.h       |  3 ++-
 arch/x86/kvm/mmu/page_track.c         | 14 +++-----------
 arch/x86/kvm/mmu/paging_tmpl.h        |  4 +++-
 arch/x86/kvm/mmu/spte.c               | 11 ++++++-----
 arch/x86/kvm/mmu/spte.h               |  9 +++++----
 arch/x86/kvm/mmu/tdp_mmu.c            |  2 +-
 8 files changed, 29 insertions(+), 32 deletions(-)

diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index 8766adb52a73..be76dda0952b 100644
--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -59,8 +59,6 @@ void kvm_slot_page_track_add_page(struct kvm *kvm,
 void kvm_slot_page_track_remove_page(struct kvm *kvm,
 				     struct kvm_memory_slot *slot, gfn_t gfn,
 				     enum kvm_page_track_mode mode);
-bool kvm_page_track_is_active(struct kvm_vcpu *vcpu, gfn_t gfn,
-			      enum kvm_page_track_mode mode);
 bool kvm_slot_page_track_is_active(struct kvm_memory_slot *slot, gfn_t gfn,
 				   enum kvm_page_track_mode mode);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 41e2ef8ad09b..136056b13e15 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2583,7 +2583,8 @@ static void kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
  * were marked unsync (or if there is no shadow page), -EPERM if the SPTE must
  * be write-protected.
  */
-int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, gfn_t gfn, bool can_unsync)
+int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
+			    gfn_t gfn, bool can_unsync)
 {
 	struct kvm_mmu_page *sp;
 
@@ -2592,7 +2593,7 @@ int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, gfn_t gfn, bool can_unsync)
 	 * track machinery is used to write-protect upper-level shadow pages,
 	 * i.e. this guards the role.level == 4K assertion below!
 	 */
-	if (kvm_page_track_is_active(vcpu, gfn, KVM_PAGE_TRACK_WRITE))
+	if (kvm_slot_page_track_is_active(slot, gfn, KVM_PAGE_TRACK_WRITE))
 		return -EPERM;
 
 	/*
@@ -2654,8 +2655,8 @@ int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, gfn_t gfn, bool can_unsync)
 	return 0;
 }
 
-static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
-		    unsigned int pte_access, int level,
+static int set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
+		    u64 *sptep, unsigned int pte_access, int level,
 		    gfn_t gfn, kvm_pfn_t pfn, bool speculative,
 		    bool can_unsync, bool host_writable)
 {
@@ -2665,8 +2666,9 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 
 	sp = sptep_to_sp(sptep);
 
-	ret = make_spte(vcpu, pte_access, level, gfn, pfn, *sptep, speculative,
-			can_unsync, host_writable, sp_ad_disabled(sp), &spte);
+	ret = make_spte(vcpu, slot, pte_access, level, gfn, pfn, *sptep,
+			speculative, can_unsync, host_writable,
+			sp_ad_disabled(sp), &spte);
 
 	if (spte & PT_WRITABLE_MASK)
 		kvm_vcpu_mark_page_dirty(vcpu, gfn);
@@ -2717,7 +2719,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 			was_rmapped = 1;
 	}
 
-	set_spte_ret = set_spte(vcpu, sptep, pte_access, level, gfn, pfn,
+	set_spte_ret = set_spte(vcpu, slot, sptep, pte_access, level, gfn, pfn,
 				speculative, true, host_writable);
 	if (set_spte_ret & SET_SPTE_WRITE_PROTECTED_PT) {
 		if (write_fault)
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 658d8d228d43..e0c9c68ff617 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -116,7 +116,8 @@ static inline bool kvm_vcpu_ad_need_write_protect(struct kvm_vcpu *vcpu)
 	       kvm_x86_ops.cpu_dirty_log_size;
 }
 
-int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, gfn_t gfn, bool can_unsync);
+int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
+			    gfn_t gfn, bool can_unsync);
 
 void kvm_mmu_gfn_disallow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn);
 void kvm_mmu_gfn_allow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn);
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index a9e2e02f2f4f..4179f4712152 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -136,6 +136,9 @@ void kvm_slot_page_track_remove_page(struct kvm *kvm,
 }
 EXPORT_SYMBOL_GPL(kvm_slot_page_track_remove_page);
 
+/*
+ * check if the corresponding access on the specified guest page is tracked.
+ */
 bool kvm_slot_page_track_is_active(struct kvm_memory_slot *slot, gfn_t gfn,
 				   enum kvm_page_track_mode mode)
 {
@@ -151,17 +154,6 @@ bool kvm_slot_page_track_is_active(struct kvm_memory_slot *slot, gfn_t gfn,
 	return !!READ_ONCE(slot->arch.gfn_track[mode][index]);
 }
 
-/*
- * check if the corresponding access on the specified guest page is tracked.
- */
-bool kvm_page_track_is_active(struct kvm_vcpu *vcpu, gfn_t gfn,
-			      enum kvm_page_track_mode mode)
-{
-	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
-
-	return kvm_slot_page_track_is_active(slot, gfn, mode);
-}
-
 void kvm_page_track_cleanup(struct kvm *kvm)
 {
 	struct kvm_page_track_notifier_head *head;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 653ca44afa58..f85786534d86 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -1086,6 +1086,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 	first_pte_gpa = FNAME(get_level1_sp_gpa)(sp);
 
 	for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
+		struct kvm_memory_slot *slot;
 		unsigned pte_access;
 		pt_element_t gpte;
 		gpa_t pte_gpa;
@@ -1135,7 +1136,8 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 
 		host_writable = sp->spt[i] & shadow_host_writable_mask;
 
-		set_spte_ret |= set_spte(vcpu, &sp->spt[i],
+		slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
+		set_spte_ret |= set_spte(vcpu, slot, &sp->spt[i],
 					 pte_access, PG_LEVEL_4K,
 					 gfn, spte_to_pfn(sp->spt[i]),
 					 true, false, host_writable);
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 3e97cdb13eb7..5f0c99532a96 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -89,10 +89,11 @@ static bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
 				     E820_TYPE_RAM);
 }
 
-int make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
-		     gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool speculative,
-		     bool can_unsync, bool host_writable, bool ad_disabled,
-		     u64 *new_spte)
+int make_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
+	      unsigned int pte_access, int level,
+	      gfn_t gfn, kvm_pfn_t pfn,
+	      u64 old_spte, bool speculative, bool can_unsync,
+	      bool host_writable, bool ad_disabled, u64 *new_spte)
 {
 	u64 spte = SPTE_MMU_PRESENT_MASK;
 	int ret = 0;
@@ -159,7 +160,7 @@ int make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
 		 * e.g. it's write-tracked (upper-level SPs) or has one or more
 		 * shadow pages and unsync'ing pages is not allowed.
 		 */
-		if (mmu_try_to_unsync_pages(vcpu, gfn, can_unsync)) {
+		if (mmu_try_to_unsync_pages(vcpu, slot, gfn, can_unsync)) {
 			pgprintk("%s: found shadow page for %llx, marking ro\n",
 				 __func__, gfn);
 			ret |= SET_SPTE_WRITE_PROTECTED_PT;
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index eb7b227fc6cf..6d2446f4c591 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -339,10 +339,11 @@ static inline u64 get_mmio_spte_generation(u64 spte)
 #define SET_SPTE_NEED_REMOTE_TLB_FLUSH BIT(1)
 #define SET_SPTE_SPURIOUS              BIT(2)
 
-int make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
-		     gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool speculative,
-		     bool can_unsync, bool host_writable, bool ad_disabled,
-		     u64 *new_spte);
+int make_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
+	      unsigned int pte_access, int level,
+	      gfn_t gfn, kvm_pfn_t pfn,
+	      u64 old_spte, bool speculative, bool can_unsync,
+	      bool host_writable, bool ad_disabled, u64 *new_spte);
 u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
 u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
 u64 mark_spte_for_access_track(u64 spte);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 6f733a68d750..cd72184327a4 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -927,7 +927,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 	if (unlikely(is_noslot_pfn(fault->pfn)))
 		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
 	else
-		make_spte_ret = make_spte(vcpu, ACC_ALL, iter->level, iter->gfn,
+		make_spte_ret = make_spte(vcpu, fault->slot, ACC_ALL, iter->level, iter->gfn,
 					 fault->pfn, iter->old_spte, fault->prefault, true,
 					 fault->map_writable, !shadow_accessed_mask,
 					 &new_spte);
-- 
2.33.0.rc1.237.g0d66db33f3-goog

