Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14F55654A45
	for <lists+kvm@lfdr.de>; Fri, 23 Dec 2022 02:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbiLWBAg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 20:00:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235825AbiLWA7q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 19:59:46 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF2F931367
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 16:58:25 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id b13-20020a056a000a8d00b0057348c50123so1842328pfl.18
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 16:58:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=9m65ii3Z2+Up6+6w2LLwtE7Z6LW+UUiTVcqlaNkFHlw=;
        b=ESn3CEaTFzNpO3PrJz43vYQOHNedAIz3HDNy5AyNS+sAk59aFjTZu1kQvvcCvGfPtt
         T2Lm764qOKTgd+190SVlnprE3B9HYzgF2SIX0acm6Pf2JTpzsTn65K1nD6btT5Kl0ayi
         cEqujvpdPNT+Qjx8dcBIWjMzimyDkrN0aD4bzZWfBdMW527OYGwfwsXq+xrcvdrH8ILj
         W7z/DeDIe55wzK2irFEdX8OOVORywI3P7GclsJAdj9iYjl5pq0TYn6I902rLnmIuJ0ZF
         AI7gyXp3MWJs1GPqWaXYbSuFlXfuCWUk1tn+HSKcUHQ8yeY5NHkemgMZLXKoyWIcQJTF
         St5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9m65ii3Z2+Up6+6w2LLwtE7Z6LW+UUiTVcqlaNkFHlw=;
        b=xDpTEL64hZf3ectEUU6qPlGsprUa6d1GyS2EfZfbV5qHKThNxaH1mFdMHZ1m8gVnDs
         L6vpzHEM35LR2caSQobnkgPZTDO2sTW8fb3mnjCG8E3UFta8bSzyA66fBuWH9qz1xK1I
         pFrROYFi9YIsJ4YwLdCpuNxWV3r+QNXkNKDF7e1hmvGZ6rhI0ucG8cHbdQalMbxuo2hN
         JJ9fWkw/Yk6pka3hdKvnYBBRCt5mZKDhzs3MvoBZ0jRsvpgZuYcfcG8mKxHiItywG+H+
         wF7DVa7bYQiSbNaHmAtF4Xz75NQFJE3VUBukKBqMXB5WKVuZutDi561clZl0yDo9Bu50
         Q6Xg==
X-Gm-Message-State: AFqh2krrE39N7Urx/IVpR7r5N3ObULN9996IN+Nx4GMqdh5v4fF9bcDR
        VXU2Ib3ar6rC+syNAUIfnu5pIsbFS8c=
X-Google-Smtp-Source: AMrXdXugKzOP22znJBp0tIWixqeqWvn0SC0/ftTv2Hfa17Sk+zYDJLqEIjbzFnTOEZiEv1yPTc+HBgZiqck=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:d1b:0:b0:479:3910:c5a8 with SMTP id
 c27-20020a630d1b000000b004793910c5a8mr430879pgl.195.1671757099679; Thu, 22
 Dec 2022 16:58:19 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Dec 2022 00:57:32 +0000
In-Reply-To: <20221223005739.1295925-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221223005739.1295925-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221223005739.1295925-21-seanjc@google.com>
Subject: [PATCH 20/27] KVM: x86/mmu: Drop infrastructure for multiple
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
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
index e8f8e1bd96c7..f110e1bd1282 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -290,13 +290,13 @@ struct kvm_kernel_irq_routing_entry;
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
@@ -1018,7 +1018,7 @@ struct kvm_lpage_info {
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
index 6477ef435575..ffcfc75cd4c1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -807,8 +807,7 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 
 	/* the non-leaf shadow pages are keeping readonly. */
 	if (sp->role.level > PG_LEVEL_4K)
-		return kvm_slot_page_track_add_page(kvm, slot, gfn,
-						    KVM_PAGE_TRACK_WRITE);
+		return kvm_slot_page_track_add_page(kvm, slot, gfn);
 
 	kvm_mmu_gfn_disallow_lpage(slot, gfn);
 
@@ -854,8 +853,7 @@ static void unaccount_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 	slots = kvm_memslots_for_spte_role(kvm, sp->role);
 	slot = __gfn_to_memslot(slots, gfn);
 	if (sp->role.level > PG_LEVEL_4K)
-		return kvm_slot_page_track_remove_page(kvm, slot, gfn,
-						       KVM_PAGE_TRACK_WRITE);
+		return kvm_slot_page_track_remove_page(kvm, slot, gfn);
 
 	kvm_mmu_gfn_allow_lpage(slot, gfn);
 }
@@ -2727,7 +2725,7 @@ int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
 	 * track machinery is used to write-protect upper-level shadow pages,
 	 * i.e. this guards the role.level == 4K assertion below!
 	 */
-	if (kvm_slot_page_track_is_active(kvm, slot, gfn, KVM_PAGE_TRACK_WRITE))
+	if (kvm_slot_page_track_is_active(kvm, slot, gfn))
 		return -EPERM;
 
 	/*
@@ -4137,7 +4135,7 @@ static bool page_fault_handle_page_track(struct kvm_vcpu *vcpu,
 	 * guest is writing the page which is write tracked which can
 	 * not be fixed by page fault handler.
 	 */
-	if (kvm_slot_page_track_is_active(vcpu->kvm, fault->slot, fault->gfn, KVM_PAGE_TRACK_WRITE))
+	if (kvm_slot_page_track_is_active(vcpu->kvm, fault->slot, fault->gfn))
 		return true;
 
 	return false;
@@ -5366,8 +5364,8 @@ void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
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
index f932909aa9b5..4077aa6d6ff4 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -26,76 +26,50 @@ bool kvm_page_track_write_tracking_enabled(struct kvm *kvm)
 
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
@@ -108,21 +82,15 @@ static void update_gfn_track(struct kvm_memory_slot *slot, gfn_t gfn,
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
@@ -130,9 +98,8 @@ void kvm_slot_page_track_add_page(struct kvm *kvm,
 	 */
 	kvm_mmu_gfn_disallow_lpage(slot, gfn);
 
-	if (mode == KVM_PAGE_TRACK_WRITE)
-		if (kvm_mmu_slot_gfn_write_protect(kvm, slot, gfn, PG_LEVEL_4K))
-			kvm_flush_remote_tlbs(kvm);
+	if (kvm_mmu_slot_gfn_write_protect(kvm, slot, gfn, PG_LEVEL_4K))
+		kvm_flush_remote_tlbs(kvm);
 }
 EXPORT_SYMBOL_GPL(kvm_slot_page_track_add_page);
 
@@ -147,20 +114,14 @@ EXPORT_SYMBOL_GPL(kvm_slot_page_track_add_page);
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
@@ -175,22 +136,18 @@ EXPORT_SYMBOL_GPL(kvm_slot_page_track_remove_page);
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
index 1b363784aa4a..ae2860bdf560 100644
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
index 9f251bc00a7e..cabad0ff722c 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -1584,7 +1584,7 @@ int intel_gvt_page_track_add(struct intel_vgpu *info, u64 gfn)
 	}
 
 	write_lock(&kvm->mmu_lock);
-	kvm_slot_page_track_add_page(kvm, slot, gfn, KVM_PAGE_TRACK_WRITE);
+	kvm_slot_page_track_add_page(kvm, slot, gfn);
 	write_unlock(&kvm->mmu_lock);
 
 	srcu_read_unlock(&kvm->srcu, idx);
@@ -1618,7 +1618,7 @@ int intel_gvt_page_track_remove(struct intel_vgpu *info, u64 gfn)
 	}
 
 	write_lock(&kvm->mmu_lock);
-	kvm_slot_page_track_remove_page(kvm, slot, gfn, KVM_PAGE_TRACK_WRITE);
+	kvm_slot_page_track_remove_page(kvm, slot, gfn);
 	write_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, idx);
 
-- 
2.39.0.314.g84b9a713c41-goog

