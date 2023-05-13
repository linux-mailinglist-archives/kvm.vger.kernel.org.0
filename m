Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38CDD70136B
	for <lists+kvm@lfdr.de>; Sat, 13 May 2023 02:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240577AbjEMAi0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 20:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241566AbjEMAhl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 20:37:41 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F3F5B90
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 17:36:57 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1aaf5dcd999so104492825ad.1
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 17:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683938207; x=1686530207;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=5osPeSp5NshN59a0GSWdu0T0inckOvzdkguH3sE8u+4=;
        b=TyxksrxFuPh+a7FlS7lU2fy+RTf1numk8H6URtk7+K3KtiNTUd/GMOsezQJmP8h2mM
         hGXn7ko0IYfO0PYWNj6jb1sBJ+u3BU5yYJn2ilHPeuzFtCKuPYE6w3d1k7ormPzBwsRe
         0l/6BuemtrKbQ2R9xfXjJGVOM+V4oBFcsI0SJCpC7Z2l1WYKdYcQMNSMiNz4D8gnGbJY
         TSLNgnMOjV0j0il82vgm5s1mvgnOtNV5vKs3Y0o+sVrm2y3bM02W0v/Pav7zrt3ZxZNU
         P11yzxZT57oRK/cQStbY3M6x8+dz2Wa8GeMN7Ek4IWYzAYv/X4pPi6eno34rzNVXYD/y
         bIgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683938207; x=1686530207;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5osPeSp5NshN59a0GSWdu0T0inckOvzdkguH3sE8u+4=;
        b=Ib2Cs6TiMKE8+q8uHsi1FuiVONTDAoPi9g8x5Q4lmOTLE4FZWz4yoi0ZLM7iFHTHSj
         IaZWVMsgTf2oypqI3zCli+hR7bE8MAfabROBtztbn+FWHACzeKqNieraaoIqzSLMA5ZE
         cHOUEFaCw/IK+5uIY3jvyFjlOHoUq8cqmhqJjqZd7ldhzvZT8s4Oc/8UVwLR1lewy/f8
         mYqotPWVbWo+Hh2ypLGfAnloKxBVjHshspARltYTuA3jZGTrvHsUUrkum46p8NeutPQT
         OnfvDbjC69ZC8JcMRKzu1vCwfAPVcl4YR/ypvZrESg9QaD4zXHwXwuvovEMEIaxyANkp
         7KIw==
X-Gm-Message-State: AC+VfDwNKXHjCcjUoRINF4u8+kC5mV+kgiPXurwhCM3jGV9CWe382JTQ
        BQC1yRAAK4iFRGqPIHmU8YLweFb894A=
X-Google-Smtp-Source: ACHHUZ63ucpp0B3k6I7mZxsAmgh2Lb2YEJNi1SvFriIyFQSs51BkGWQrygIjU+KuH3Cr52pWrEsvqntDsB4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:6a89:b0:1a6:a50d:652c with SMTP id
 n9-20020a1709026a8900b001a6a50d652cmr9192827plk.9.1683938207724; Fri, 12 May
 2023 17:36:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 12 May 2023 17:35:54 -0700
In-Reply-To: <20230513003600.818142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230513003600.818142-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230513003600.818142-23-seanjc@google.com>
Subject: [PATCH v3 22/28] KVM: x86/mmu: Drop infrastructure for multiple
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
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
index 5ce06a75d3de..3dde3a11113a 100644
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
@@ -1005,7 +1005,7 @@ struct kvm_lpage_info {
 struct kvm_arch_memory_slot {
 	struct kvm_rmap_head *rmap[KVM_NR_PAGE_SIZES];
 	struct kvm_lpage_info *lpage_info[KVM_NR_PAGE_SIZES - 1];
-	unsigned short *gfn_track[KVM_PAGE_TRACK_MAX];
+	unsigned short *gfn_write_track;
 };
 
 /*
diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index 61adb07b5927..9e4ee26d1779 100644
--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -4,17 +4,10 @@
 
 #include <linux/kvm_types.h>
 
-enum kvm_page_track_mode {
-	KVM_PAGE_TRACK_WRITE,
-	KVM_PAGE_TRACK_MAX,
-};
-
 void kvm_slot_page_track_add_page(struct kvm *kvm,
-				  struct kvm_memory_slot *slot, gfn_t gfn,
-				  enum kvm_page_track_mode mode);
+				  struct kvm_memory_slot *slot, gfn_t gfn);
 void kvm_slot_page_track_remove_page(struct kvm *kvm,
-				     struct kvm_memory_slot *slot, gfn_t gfn,
-				     enum kvm_page_track_mode mode);
+				     struct kvm_memory_slot *slot, gfn_t gfn);
 
 #ifdef CONFIG_KVM_EXTERNAL_WRITE_TRACKING
 /*
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0d9fe54ecb01..8041f5747704 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -837,8 +837,7 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 
 	/* the non-leaf shadow pages are keeping readonly. */
 	if (sp->role.level > PG_LEVEL_4K)
-		return kvm_slot_page_track_add_page(kvm, slot, gfn,
-						    KVM_PAGE_TRACK_WRITE);
+		return kvm_slot_page_track_add_page(kvm, slot, gfn);
 
 	kvm_mmu_gfn_disallow_lpage(slot, gfn);
 
@@ -884,8 +883,7 @@ static void unaccount_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 	slots = kvm_memslots_for_spte_role(kvm, sp->role);
 	slot = __gfn_to_memslot(slots, gfn);
 	if (sp->role.level > PG_LEVEL_4K)
-		return kvm_slot_page_track_remove_page(kvm, slot, gfn,
-						       KVM_PAGE_TRACK_WRITE);
+		return kvm_slot_page_track_remove_page(kvm, slot, gfn);
 
 	kvm_mmu_gfn_allow_lpage(slot, gfn);
 }
@@ -2825,7 +2823,7 @@ int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
 	 * track machinery is used to write-protect upper-level shadow pages,
 	 * i.e. this guards the role.level == 4K assertion below!
 	 */
-	if (kvm_slot_page_track_is_active(kvm, slot, gfn, KVM_PAGE_TRACK_WRITE))
+	if (kvm_slot_page_track_is_active(kvm, slot, gfn))
 		return -EPERM;
 
 	/*
@@ -4226,7 +4224,7 @@ static bool page_fault_handle_page_track(struct kvm_vcpu *vcpu,
 	 * guest is writing the page which is write tracked which can
 	 * not be fixed by page fault handler.
 	 */
-	if (kvm_slot_page_track_is_active(vcpu->kvm, fault->slot, fault->gfn, KVM_PAGE_TRACK_WRITE))
+	if (kvm_slot_page_track_is_active(vcpu->kvm, fault->slot, fault->gfn))
 		return true;
 
 	return false;
@@ -5461,8 +5459,8 @@ void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
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
index b20aad7ac3fe..cdc6069b8caf 100644
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
index 2e65901270ca..25226e4e3417 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -1563,7 +1563,7 @@ int intel_gvt_page_track_add(struct intel_vgpu *info, u64 gfn)
 	}
 
 	write_lock(&kvm->mmu_lock);
-	kvm_slot_page_track_add_page(kvm, slot, gfn, KVM_PAGE_TRACK_WRITE);
+	kvm_slot_page_track_add_page(kvm, slot, gfn);
 	write_unlock(&kvm->mmu_lock);
 
 	srcu_read_unlock(&kvm->srcu, idx);
@@ -1592,7 +1592,7 @@ int intel_gvt_page_track_remove(struct intel_vgpu *info, u64 gfn)
 	}
 
 	write_lock(&kvm->mmu_lock);
-	kvm_slot_page_track_remove_page(kvm, slot, gfn, KVM_PAGE_TRACK_WRITE);
+	kvm_slot_page_track_remove_page(kvm, slot, gfn);
 	write_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, idx);
 
-- 
2.40.1.606.ga4b1b128d6-goog

