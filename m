Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E90CE6B56A1
	for <lists+kvm@lfdr.de>; Sat, 11 Mar 2023 01:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbjCKAY6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 19:24:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbjCKAYR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 19:24:17 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB36C584AA
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:23:45 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id t12-20020aa7938c000000b005ac41980708so3592218pfe.7
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:23:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678494225;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=eI+0rE5rcqcw4Y+N2iURH7RbtJkRm18wlxJt3fsxccM=;
        b=n8G0BIaC3mw6A2srrMDg6mQInnquGNPk6fYVwyET1bWGy+wRboFaC0W+yZ0rSj9ctz
         a+j5tK/HpgT4QYjwu3HFxHkusUSfi8gT5s3W1n1C6yLipFGjLpHBl/k4b+EcNr/Ii3Kd
         Z2+mMAAtkNPFC0bY8IpCm8hQZnNR/9YaaJXtUIlVb/WEKc6aM3uqbDKxW3sBkezrIK85
         OScpEfah22LRjfsjj/zmJzlIvHwtdZYElmyyc/iQ2tnj/JE04zrLISCRF252dsS/yBhr
         BO4GA+LMeKdN+2DRePL/olvUAA3O7bi1oZgnj1ysY6r6bsR/nx5+67sgk9AEmszHyp2T
         k/Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678494225;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eI+0rE5rcqcw4Y+N2iURH7RbtJkRm18wlxJt3fsxccM=;
        b=XAYrHlzi+Qov4h+TwJ7tTmXAwTlPZSZ0rDAot9j8maXVO0LuN5l7rzvlOtNhorSzZB
         nkE4OIJcnQ/QO+sAIvZzbmwLV8kocH50HHUYkLHLGvvhylG5v89cHKda8g3/mb4FqVsp
         TyqyzTHsiDrrrlBSwuR+ENnc3phXGQSIDTn5dpTy1BY0P/4AaqPOIOUJ9kn3dpR/UjDv
         SargF4nwn/2x7hkBaH8eP4Fjw4X4BXas8clFuaj8d3z6HBQ2bcQyZQxrLMI0WuYhUhQs
         e4Ibq8L6kWdvFOznQ794rvr3fniuKWuXUMN2DzbIbftH2kbDKajbiU6kwFhwPARe64D4
         dFSA==
X-Gm-Message-State: AO0yUKXORWih+s0bDx9JBX/b+Eo/q4izy0zM2Cw8gpJcQ6UmgBscr9lp
        Jc6fzzW8H6bv1Cf6E0ikBeStji/F/G4=
X-Google-Smtp-Source: AK7set/Myj6rPomfAhiXqjuXU1viCJq55HVihuuLvR0R9WN4BQISlKpHk+BpgF5UjYMbOeGwJK4E4IHeIYM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:1a46:0:b0:4f1:1bbc:be70 with SMTP id
 a6-20020a631a46000000b004f11bbcbe70mr1360372pgm.6.1678494225603; Fri, 10 Mar
 2023 16:23:45 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Mar 2023 16:22:52 -0800
In-Reply-To: <20230311002258.852397-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230311002258.852397-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230311002258.852397-22-seanjc@google.com>
Subject: [PATCH v2 21/27] KVM: x86/mmu: Drop infrastructure for multiple
 page-track modes
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     kvm@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>,
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

Drop "support" for multiple page-track modes, as there is no evidence
that array-based and refcounted metadata is the optimal solution for
other modes, nor is there any evidence that other use cases, e.g. for
access-tracking, will be a good fit for the page-track machinery in
general.

E.g. one potential use case of access-tracking would be to prevent guest
access to poisoned memory (from the guest's perspective).  In that case,
the number of poisoned pages is likely to be a very small percentage of
the guest memory, and there is no need to reference count the number of
access-tracking users, i.e. expanding gfn_track[] for a new mode would be
grossly inefficient.  And for poisoned memory, host userspace would also
likely want to trap accesses, e.g. to inject #MC into the guest, and that
isn't currently supported by the page-track framework.

A better alternative for that poisoned page use case is likely a
variation of the proposed per-gfn attributes overlay (linked), which
would allow efficiently tracking the sparse set of poisoned pages, and by
default would exit to userspace on access.

Link: https://lore.kernel.org/all/Y2WB48kD0J4VGynX@google.com
Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h       |  12 +--
 arch/x86/include/asm/kvm_page_track.h |  11 +--
 arch/x86/kvm/mmu/mmu.c                |  14 ++--
 arch/x86/kvm/mmu/page_track.c         | 111 ++++++++------------------
 arch/x86/kvm/mmu/page_track.h         |   3 +-
 drivers/gpu/drm/i915/gvt/kvmgt.c      |   4 +-
 6 files changed, 51 insertions(+), 104 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a3423711e403..23567b851864 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -288,13 +288,13 @@ struct kvm_kernel_irq_routing_entry;
  * kvm_mmu_page_role tracks the properties of a shadow page (where shadow page
  * also includes TDP pages) to determine whether or not a page can be used in
  * the given MMU context.  This is a subset of the overall kvm_cpu_role to
- * minimize the size of kvm_memory_slot.arch.gfn_track, i.e. allows allocating
- * 2 bytes per gfn instead of 4 bytes per gfn.
+ * minimize the size of kvm_memory_slot.arch.gfn_write_track, i.e. allows
+ * allocating 2 bytes per gfn instead of 4 bytes per gfn.
  *
  * Upper-level shadow pages having gptes are tracked for write-protection via
- * gfn_track.  As above, gfn_track is a 16 bit counter, so KVM must not create
- * more than 2^16-1 upper-level shadow pages at a single gfn, otherwise
- * gfn_track will overflow and explosions will ensure.
+ * gfn_write_track.  As above, gfn_write_track is a 16 bit counter, so KVM must
+ * not create more than 2^16-1 upper-level shadow pages at a single gfn,
+ * otherwise gfn_write_track will overflow and explosions will ensue.
  *
  * A unique shadow page (SP) for a gfn is created if and only if an existing SP
  * cannot be reused.  The ability to reuse a SP is tracked by its role, which
@@ -1023,7 +1023,7 @@ struct kvm_lpage_info {
 struct kvm_arch_memory_slot {
 	struct kvm_rmap_head *rmap[KVM_NR_PAGE_SIZES];
 	struct kvm_lpage_info *lpage_info[KVM_NR_PAGE_SIZES - 1];
-	unsigned short *gfn_track[KVM_PAGE_TRACK_MAX];
+	unsigned short *gfn_write_track;
 };
 
 /*
diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index 53c2adb25a07..42a4ae451d36 100644
--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -4,11 +4,6 @@
 
 #include <linux/kvm_types.h>
 
-enum kvm_page_track_mode {
-	KVM_PAGE_TRACK_WRITE,
-	KVM_PAGE_TRACK_MAX,
-};
-
 /*
  * The notifier represented by @kvm_page_track_notifier_node is linked into
  * the head which will be notified when guest is triggering the track event.
@@ -49,11 +44,9 @@ struct kvm_page_track_notifier_node {
 };
 
 void kvm_slot_page_track_add_page(struct kvm *kvm,
-				  struct kvm_memory_slot *slot, gfn_t gfn,
-				  enum kvm_page_track_mode mode);
+				  struct kvm_memory_slot *slot, gfn_t gfn);
 void kvm_slot_page_track_remove_page(struct kvm *kvm,
-				     struct kvm_memory_slot *slot, gfn_t gfn,
-				     enum kvm_page_track_mode mode);
+				     struct kvm_memory_slot *slot, gfn_t gfn);
 
 #ifdef CONFIG_KVM_EXTERNAL_WRITE_TRACKING
 enum pg_level kvm_page_track_max_mapping_level(struct kvm *kvm, gfn_t gfn,
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e192968340bf..7f21a1705438 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -820,8 +820,7 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 
 	/* the non-leaf shadow pages are keeping readonly. */
 	if (sp->role.level > PG_LEVEL_4K)
-		return kvm_slot_page_track_add_page(kvm, slot, gfn,
-						    KVM_PAGE_TRACK_WRITE);
+		return kvm_slot_page_track_add_page(kvm, slot, gfn);
 
 	kvm_mmu_gfn_disallow_lpage(slot, gfn);
 
@@ -867,8 +866,7 @@ static void unaccount_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 	slots = kvm_memslots_for_spte_role(kvm, sp->role);
 	slot = __gfn_to_memslot(slots, gfn);
 	if (sp->role.level > PG_LEVEL_4K)
-		return kvm_slot_page_track_remove_page(kvm, slot, gfn,
-						       KVM_PAGE_TRACK_WRITE);
+		return kvm_slot_page_track_remove_page(kvm, slot, gfn);
 
 	kvm_mmu_gfn_allow_lpage(slot, gfn);
 }
@@ -2747,7 +2745,7 @@ int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
 	 * track machinery is used to write-protect upper-level shadow pages,
 	 * i.e. this guards the role.level == 4K assertion below!
 	 */
-	if (kvm_slot_page_track_is_active(kvm, slot, gfn, KVM_PAGE_TRACK_WRITE))
+	if (kvm_slot_page_track_is_active(kvm, slot, gfn))
 		return -EPERM;
 
 	/*
@@ -4155,7 +4153,7 @@ static bool page_fault_handle_page_track(struct kvm_vcpu *vcpu,
 	 * guest is writing the page which is write tracked which can
 	 * not be fixed by page fault handler.
 	 */
-	if (kvm_slot_page_track_is_active(vcpu->kvm, fault->slot, fault->gfn, KVM_PAGE_TRACK_WRITE))
+	if (kvm_slot_page_track_is_active(vcpu->kvm, fault->slot, fault->gfn))
 		return true;
 
 	return false;
@@ -5387,8 +5385,8 @@ void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	 * physical address properties) in a single VM would require tracking
 	 * all relevant CPUID information in kvm_mmu_page_role. That is very
 	 * undesirable as it would increase the memory requirements for
-	 * gfn_track (see struct kvm_mmu_page_role comments).  For now that
-	 * problem is swept under the rug; KVM's CPUID API is horrific and
+	 * gfn_write_track (see struct kvm_mmu_page_role comments).  For now
+	 * that problem is swept under the rug; KVM's CPUID API is horrific and
 	 * it's all but impossible to solve it without introducing a new API.
 	 */
 	vcpu->arch.root_mmu.root_role.word = 0;
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 619ec8e5fd32..f8c89110f896 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -27,76 +27,50 @@ bool kvm_page_track_write_tracking_enabled(struct kvm *kvm)
 
 void kvm_page_track_free_memslot(struct kvm_memory_slot *slot)
 {
-	int i;
+	kvfree(slot->arch.gfn_write_track);
+	slot->arch.gfn_write_track = NULL;
+}
 
-	for (i = 0; i < KVM_PAGE_TRACK_MAX; i++) {
-		kvfree(slot->arch.gfn_track[i]);
-		slot->arch.gfn_track[i] = NULL;
-	}
+static int __kvm_page_track_write_tracking_alloc(struct kvm_memory_slot *slot,
+						 unsigned long npages)
+{
+	const size_t size = sizeof(*slot->arch.gfn_write_track);
+
+	if (!slot->arch.gfn_write_track)
+		slot->arch.gfn_write_track = __vcalloc(npages, size,
+						       GFP_KERNEL_ACCOUNT);
+
+	return slot->arch.gfn_write_track ? 0 : -ENOMEM;
 }
 
 int kvm_page_track_create_memslot(struct kvm *kvm,
 				  struct kvm_memory_slot *slot,
 				  unsigned long npages)
 {
-	int i;
-
-	for (i = 0; i < KVM_PAGE_TRACK_MAX; i++) {
-		if (i == KVM_PAGE_TRACK_WRITE &&
-		    !kvm_page_track_write_tracking_enabled(kvm))
-			continue;
-
-		slot->arch.gfn_track[i] =
-			__vcalloc(npages, sizeof(*slot->arch.gfn_track[i]),
-				  GFP_KERNEL_ACCOUNT);
-		if (!slot->arch.gfn_track[i])
-			goto track_free;
-	}
-
-	return 0;
-
-track_free:
-	kvm_page_track_free_memslot(slot);
-	return -ENOMEM;
-}
-
-static inline bool page_track_mode_is_valid(enum kvm_page_track_mode mode)
-{
-	if (mode < 0 || mode >= KVM_PAGE_TRACK_MAX)
-		return false;
-
-	return true;
-}
-
-int kvm_page_track_write_tracking_alloc(struct kvm_memory_slot *slot)
-{
-	unsigned short *gfn_track;
-
-	if (slot->arch.gfn_track[KVM_PAGE_TRACK_WRITE])
+	if (!kvm_page_track_write_tracking_enabled(kvm))
 		return 0;
 
-	gfn_track = __vcalloc(slot->npages, sizeof(*gfn_track),
-			      GFP_KERNEL_ACCOUNT);
-	if (gfn_track == NULL)
-		return -ENOMEM;
+	return __kvm_page_track_write_tracking_alloc(slot, npages);
+}
 
-	slot->arch.gfn_track[KVM_PAGE_TRACK_WRITE] = gfn_track;
-	return 0;
+int kvm_page_track_write_tracking_alloc(struct kvm_memory_slot *slot)
+{
+	return __kvm_page_track_write_tracking_alloc(slot, slot->npages);
 }
 
-static void update_gfn_track(struct kvm_memory_slot *slot, gfn_t gfn,
-			     enum kvm_page_track_mode mode, short count)
+static void update_gfn_write_track(struct kvm_memory_slot *slot, gfn_t gfn,
+				   short count)
 {
 	int index, val;
 
 	index = gfn_to_index(gfn, slot->base_gfn, PG_LEVEL_4K);
 
-	val = slot->arch.gfn_track[mode][index];
+	val = slot->arch.gfn_write_track[index];
 
 	if (WARN_ON(val + count < 0 || val + count > USHRT_MAX))
 		return;
 
-	slot->arch.gfn_track[mode][index] += count;
+	slot->arch.gfn_write_track[index] += count;
 }
 
 /*
@@ -109,21 +83,15 @@ static void update_gfn_track(struct kvm_memory_slot *slot, gfn_t gfn,
  * @kvm: the guest instance we are interested in.
  * @slot: the @gfn belongs to.
  * @gfn: the guest page.
- * @mode: tracking mode, currently only write track is supported.
  */
 void kvm_slot_page_track_add_page(struct kvm *kvm,
-				  struct kvm_memory_slot *slot, gfn_t gfn,
-				  enum kvm_page_track_mode mode)
+				  struct kvm_memory_slot *slot, gfn_t gfn)
 {
 
-	if (WARN_ON(!page_track_mode_is_valid(mode)))
+	if (WARN_ON(!kvm_page_track_write_tracking_enabled(kvm)))
 		return;
 
-	if (WARN_ON(mode == KVM_PAGE_TRACK_WRITE &&
-		    !kvm_page_track_write_tracking_enabled(kvm)))
-		return;
-
-	update_gfn_track(slot, gfn, mode, 1);
+	update_gfn_write_track(slot, gfn, 1);
 
 	/*
 	 * new track stops large page mapping for the
@@ -131,9 +99,8 @@ void kvm_slot_page_track_add_page(struct kvm *kvm,
 	 */
 	kvm_mmu_gfn_disallow_lpage(slot, gfn);
 
-	if (mode == KVM_PAGE_TRACK_WRITE)
-		if (kvm_mmu_slot_gfn_write_protect(kvm, slot, gfn, PG_LEVEL_4K))
-			kvm_flush_remote_tlbs(kvm);
+	if (kvm_mmu_slot_gfn_write_protect(kvm, slot, gfn, PG_LEVEL_4K))
+		kvm_flush_remote_tlbs(kvm);
 }
 EXPORT_SYMBOL_GPL(kvm_slot_page_track_add_page);
 
@@ -148,20 +115,14 @@ EXPORT_SYMBOL_GPL(kvm_slot_page_track_add_page);
  * @kvm: the guest instance we are interested in.
  * @slot: the @gfn belongs to.
  * @gfn: the guest page.
- * @mode: tracking mode, currently only write track is supported.
  */
 void kvm_slot_page_track_remove_page(struct kvm *kvm,
-				     struct kvm_memory_slot *slot, gfn_t gfn,
-				     enum kvm_page_track_mode mode)
+				     struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	if (WARN_ON(!page_track_mode_is_valid(mode)))
+	if (WARN_ON(!kvm_page_track_write_tracking_enabled(kvm)))
 		return;
 
-	if (WARN_ON(mode == KVM_PAGE_TRACK_WRITE &&
-		    !kvm_page_track_write_tracking_enabled(kvm)))
-		return;
-
-	update_gfn_track(slot, gfn, mode, -1);
+	update_gfn_write_track(slot, gfn, -1);
 
 	/*
 	 * allow large page mapping for the tracked page
@@ -176,22 +137,18 @@ EXPORT_SYMBOL_GPL(kvm_slot_page_track_remove_page);
  */
 bool kvm_slot_page_track_is_active(struct kvm *kvm,
 				   const struct kvm_memory_slot *slot,
-				   gfn_t gfn, enum kvm_page_track_mode mode)
+				   gfn_t gfn)
 {
 	int index;
 
-	if (WARN_ON(!page_track_mode_is_valid(mode)))
-		return false;
-
 	if (!slot)
 		return false;
 
-	if (mode == KVM_PAGE_TRACK_WRITE &&
-	    !kvm_page_track_write_tracking_enabled(kvm))
+	if (!kvm_page_track_write_tracking_enabled(kvm))
 		return false;
 
 	index = gfn_to_index(gfn, slot->base_gfn, PG_LEVEL_4K);
-	return !!READ_ONCE(slot->arch.gfn_track[mode][index]);
+	return !!READ_ONCE(slot->arch.gfn_write_track[index]);
 }
 
 #ifdef CONFIG_KVM_EXTERNAL_WRITE_TRACKING
diff --git a/arch/x86/kvm/mmu/page_track.h b/arch/x86/kvm/mmu/page_track.h
index 931b26b8fc8f..789d0c479519 100644
--- a/arch/x86/kvm/mmu/page_track.h
+++ b/arch/x86/kvm/mmu/page_track.h
@@ -16,8 +16,7 @@ int kvm_page_track_create_memslot(struct kvm *kvm,
 				  unsigned long npages);
 
 bool kvm_slot_page_track_is_active(struct kvm *kvm,
-				   const struct kvm_memory_slot *slot,
-				   gfn_t gfn, enum kvm_page_track_mode mode);
+				   const struct kvm_memory_slot *slot, gfn_t gfn);
 
 #ifdef CONFIG_KVM_EXTERNAL_WRITE_TRACKING
 int kvm_page_track_init(struct kvm *kvm);
diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index 9f188b6c3edf..1e0f4ec55782 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -1578,7 +1578,7 @@ int intel_gvt_page_track_add(struct intel_vgpu *info, u64 gfn)
 	}
 
 	write_lock(&kvm->mmu_lock);
-	kvm_slot_page_track_add_page(kvm, slot, gfn, KVM_PAGE_TRACK_WRITE);
+	kvm_slot_page_track_add_page(kvm, slot, gfn);
 	write_unlock(&kvm->mmu_lock);
 
 	srcu_read_unlock(&kvm->srcu, idx);
@@ -1607,7 +1607,7 @@ int intel_gvt_page_track_remove(struct intel_vgpu *info, u64 gfn)
 	}
 
 	write_lock(&kvm->mmu_lock);
-	kvm_slot_page_track_remove_page(kvm, slot, gfn, KVM_PAGE_TRACK_WRITE);
+	kvm_slot_page_track_remove_page(kvm, slot, gfn);
 	write_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, idx);
 
-- 
2.40.0.rc1.284.g88254d51c5-goog

