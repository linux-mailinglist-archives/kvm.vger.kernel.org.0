Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD4316B56B5
	for <lists+kvm@lfdr.de>; Sat, 11 Mar 2023 01:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbjCKA0S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 19:26:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231602AbjCKAZd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 19:25:33 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60691146265
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:24:16 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id q9-20020a17090a9f4900b00237d026fc55so5053738pjv.3
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:24:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678494233;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RRkrAIsaiUsim3X1xrzgj6Qg6wccIAn12FNO0Z1AEVQ=;
        b=JFm0A7iNy6yLbEFrd2ziU7JCkOwOpcNh+NQIr1XpAKi2K35DE4bVfuvqrS37bWOOce
         oBZ79+LVNGpL6nxbvLO4ixPtUji/5PUl834E1ctRL5C3+LBCHsH+ngGPK49PX5P2DqYi
         MbZo6R4fx/n6oIDsljy/gS7XW+ofMYbrr7ttaoBJb0ru3wrrMPlR8Jmhl6m2OIrsn7pn
         viIYhr2MvceE2I36+2nxAoruBqrVv2FiXWr3jatPzrexhhSFTCGPbCAHSzS3qmhPKsGr
         oZ/Hw+mbFMURotSHzT69yGo49nuimXa+UzRyCNoBYCWqCgGB62O30L1zBFGlB0RHivCX
         8A1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678494233;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RRkrAIsaiUsim3X1xrzgj6Qg6wccIAn12FNO0Z1AEVQ=;
        b=Fe8GjEdlBmtTZhRjxawfitx0/kaurODQ/tTNWtgJF/nn7D02yXUuKop3n2kkucpH+B
         rR9kWISXJbLqv0SNnwobZnKS+Ia2JUsI2aAoOQ0LtzUGXU6J6D8mzxC3EOZnRF12761n
         GUpG9+uSn8XHIVejC5GrkPzln7wO6KMmJI4jQ+mEkhdUyZcOXvU6hNWsoAg4pcDf97bd
         H3qLRz+m8ckDOnFYgJ9hOIHzT1PK4y8CFyOLT3g02UL9FgsbdM66o7YYxJAf+/ke739+
         7WgcG2nmQFwTQEAX2FcAFP+MK6hsPgIpdmyrJaxEV45LgckvoVrOKRuQ75T7eF/PZUkd
         o/3w==
X-Gm-Message-State: AO0yUKX9q3wv1TwWexH3wRwqApqtamlo8G2u/O0s0zy1SLTjsQuVEoiE
        d+w9DY0PbK/9xChwsOgi4XT3GSOjecA=
X-Google-Smtp-Source: AK7set87/sUC1mGuQlVVI+5Ih+TBJJK0+jsOXDunRvMecYhsofDAEZerBdAkQofJb8s4zA9xuhccM2Vb3qU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:edcd:b0:199:49d7:cead with SMTP id
 q13-20020a170902edcd00b0019949d7ceadmr10456698plk.11.1678494233199; Fri, 10
 Mar 2023 16:23:53 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Mar 2023 16:22:56 -0800
In-Reply-To: <20230311002258.852397-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230311002258.852397-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230311002258.852397-26-seanjc@google.com>
Subject: [PATCH v2 25/27] KVM: x86/mmu: Drop @slot param from
 exported/external page-track APIs
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

Refactor KVM's exported/external page-track, a.k.a. write-track, APIs
to take only the gfn and do the required memslot lookup in KVM proper.
Forcing users of the APIs to get the memslot unnecessarily bleeds
KVM internals into KVMGT and complicates usage of the APIs.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_page_track.h |  8 +--
 arch/x86/kvm/mmu/mmu.c                |  4 +-
 arch/x86/kvm/mmu/page_track.c         | 86 ++++++++++++++++++++-------
 arch/x86/kvm/mmu/page_track.h         |  5 ++
 drivers/gpu/drm/i915/gvt/kvmgt.c      | 37 +++---------
 5 files changed, 82 insertions(+), 58 deletions(-)

diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index 20055064793a..415537ce45b4 100644
--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -43,11 +43,6 @@ struct kvm_page_track_notifier_node {
 				    struct kvm_page_track_notifier_node *node);
 };
 
-void kvm_write_track_add_gfn(struct kvm *kvm,
-			     struct kvm_memory_slot *slot, gfn_t gfn);
-void kvm_write_track_remove_gfn(struct kvm *kvm, struct kvm_memory_slot *slot,
-				gfn_t gfn);
-
 #ifdef CONFIG_KVM_EXTERNAL_WRITE_TRACKING
 enum pg_level kvm_page_track_max_mapping_level(struct kvm *kvm, gfn_t gfn,
 					       enum pg_level max_level);
@@ -58,6 +53,9 @@ kvm_page_track_register_notifier(struct kvm *kvm,
 void
 kvm_page_track_unregister_notifier(struct kvm *kvm,
 				   struct kvm_page_track_notifier_node *n);
+
+int kvm_write_track_add_gfn(struct kvm *kvm, gfn_t gfn);
+int kvm_write_track_remove_gfn(struct kvm *kvm, gfn_t gfn);
 #endif /* CONFIG_KVM_EXTERNAL_WRITE_TRACKING */
 
 #endif
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3d1aad44c2ec..cf59b44de912 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -820,7 +820,7 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 
 	/* the non-leaf shadow pages are keeping readonly. */
 	if (sp->role.level > PG_LEVEL_4K)
-		return kvm_write_track_add_gfn(kvm, slot, gfn);
+		return __kvm_write_track_add_gfn(kvm, slot, gfn);
 
 	kvm_mmu_gfn_disallow_lpage(slot, gfn);
 
@@ -866,7 +866,7 @@ static void unaccount_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 	slots = kvm_memslots_for_spte_role(kvm, sp->role);
 	slot = __gfn_to_memslot(slots, gfn);
 	if (sp->role.level > PG_LEVEL_4K)
-		return kvm_write_track_remove_gfn(kvm, slot, gfn);
+		return __kvm_write_track_remove_gfn(kvm, slot, gfn);
 
 	kvm_mmu_gfn_allow_lpage(slot, gfn);
 }
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 327e73be62d6..69b6431b394b 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -74,16 +74,8 @@ static void update_gfn_write_track(struct kvm_memory_slot *slot, gfn_t gfn,
 	slot->arch.gfn_write_track[index] += count;
 }
 
-/*
- * add guest page to the tracking pool so that corresponding access on that
- * page will be intercepted.
- *
- * @kvm: the guest instance we are interested in.
- * @slot: the @gfn belongs to.
- * @gfn: the guest page.
- */
-void kvm_write_track_add_gfn(struct kvm *kvm, struct kvm_memory_slot *slot,
-			     gfn_t gfn)
+void __kvm_write_track_add_gfn(struct kvm *kvm, struct kvm_memory_slot *slot,
+			       gfn_t gfn)
 {
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
@@ -104,18 +96,9 @@ void kvm_write_track_add_gfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 	if (kvm_mmu_slot_gfn_write_protect(kvm, slot, gfn, PG_LEVEL_4K))
 		kvm_flush_remote_tlbs(kvm);
 }
-EXPORT_SYMBOL_GPL(kvm_write_track_add_gfn);
 
-/*
- * remove the guest page from the tracking pool which stops the interception
- * of corresponding access on that page.
- *
- * @kvm: the guest instance we are interested in.
- * @slot: the @gfn belongs to.
- * @gfn: the guest page.
- */
-void kvm_write_track_remove_gfn(struct kvm *kvm,
-				struct kvm_memory_slot *slot, gfn_t gfn)
+void __kvm_write_track_remove_gfn(struct kvm *kvm,
+				  struct kvm_memory_slot *slot, gfn_t gfn)
 {
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
@@ -133,7 +116,6 @@ void kvm_write_track_remove_gfn(struct kvm *kvm,
 	 */
 	kvm_mmu_gfn_allow_lpage(slot, gfn);
 }
-EXPORT_SYMBOL_GPL(kvm_write_track_remove_gfn);
 
 /*
  * check if the corresponding access on the specified guest page is tracked.
@@ -274,4 +256,64 @@ enum pg_level kvm_page_track_max_mapping_level(struct kvm *kvm, gfn_t gfn,
 	return max_level;
 }
 EXPORT_SYMBOL_GPL(kvm_page_track_max_mapping_level);
+
+/*
+ * add guest page to the tracking pool so that corresponding access on that
+ * page will be intercepted.
+ *
+ * @kvm: the guest instance we are interested in.
+ * @gfn: the guest page.
+ */
+int kvm_write_track_add_gfn(struct kvm *kvm, gfn_t gfn)
+{
+	struct kvm_memory_slot *slot;
+	int idx;
+
+	idx = srcu_read_lock(&kvm->srcu);
+
+	slot = gfn_to_memslot(kvm, gfn);
+	if (!slot) {
+		srcu_read_unlock(&kvm->srcu, idx);
+		return -EINVAL;
+	}
+
+	write_lock(&kvm->mmu_lock);
+	__kvm_write_track_add_gfn(kvm, slot, gfn);
+	write_unlock(&kvm->mmu_lock);
+
+	srcu_read_unlock(&kvm->srcu, idx);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_write_track_add_gfn);
+
+/*
+ * remove the guest page from the tracking pool which stops the interception
+ * of corresponding access on that page.
+ *
+ * @kvm: the guest instance we are interested in.
+ * @gfn: the guest page.
+ */
+int kvm_write_track_remove_gfn(struct kvm *kvm, gfn_t gfn)
+{
+	struct kvm_memory_slot *slot;
+	int idx;
+
+	idx = srcu_read_lock(&kvm->srcu);
+
+	slot = gfn_to_memslot(kvm, gfn);
+	if (!slot) {
+		srcu_read_unlock(&kvm->srcu, idx);
+		return -EINVAL;
+	}
+
+	write_lock(&kvm->mmu_lock);
+	__kvm_write_track_remove_gfn(kvm, slot, gfn);
+	write_unlock(&kvm->mmu_lock);
+
+	srcu_read_unlock(&kvm->srcu, idx);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_write_track_remove_gfn);
 #endif
diff --git a/arch/x86/kvm/mmu/page_track.h b/arch/x86/kvm/mmu/page_track.h
index 50d3278e8c69..62f98c6c5af3 100644
--- a/arch/x86/kvm/mmu/page_track.h
+++ b/arch/x86/kvm/mmu/page_track.h
@@ -15,6 +15,11 @@ int kvm_page_track_create_memslot(struct kvm *kvm,
 				  struct kvm_memory_slot *slot,
 				  unsigned long npages);
 
+void __kvm_write_track_add_gfn(struct kvm *kvm, struct kvm_memory_slot *slot,
+			       gfn_t gfn);
+void __kvm_write_track_remove_gfn(struct kvm *kvm,
+				  struct kvm_memory_slot *slot, gfn_t gfn);
+
 bool kvm_gfn_is_write_tracked(struct kvm *kvm,
 			      const struct kvm_memory_slot *slot, gfn_t gfn);
 
diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index e5a18d92030b..898f1f1d308d 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -1560,9 +1560,7 @@ static struct mdev_driver intel_vgpu_mdev_driver = {
 
 int intel_gvt_page_track_add(struct intel_vgpu *info, u64 gfn)
 {
-	struct kvm *kvm = info->vfio_device.kvm;
-	struct kvm_memory_slot *slot;
-	int idx;
+	int r;
 
 	if (!test_bit(INTEL_VGPU_STATUS_ATTACHED, info->status))
 		return -ESRCH;
@@ -1570,18 +1568,9 @@ int intel_gvt_page_track_add(struct intel_vgpu *info, u64 gfn)
 	if (kvmgt_gfn_is_write_protected(info, gfn))
 		return 0;
 
-	idx = srcu_read_lock(&kvm->srcu);
-	slot = gfn_to_memslot(kvm, gfn);
-	if (!slot) {
-		srcu_read_unlock(&kvm->srcu, idx);
-		return -EINVAL;
-	}
-
-	write_lock(&kvm->mmu_lock);
-	kvm_write_track_add_gfn(kvm, slot, gfn);
-	write_unlock(&kvm->mmu_lock);
-
-	srcu_read_unlock(&kvm->srcu, idx);
+	r = kvm_write_track_add_gfn(info->vfio_device.kvm, gfn);
+	if (r)
+		return r;
 
 	kvmgt_protect_table_add(info, gfn);
 	return 0;
@@ -1589,9 +1578,7 @@ int intel_gvt_page_track_add(struct intel_vgpu *info, u64 gfn)
 
 int intel_gvt_page_track_remove(struct intel_vgpu *info, u64 gfn)
 {
-	struct kvm *kvm = info->vfio_device.kvm;
-	struct kvm_memory_slot *slot;
-	int idx;
+	int r;
 
 	if (!test_bit(INTEL_VGPU_STATUS_ATTACHED, info->status))
 		return -ESRCH;
@@ -1599,17 +1586,9 @@ int intel_gvt_page_track_remove(struct intel_vgpu *info, u64 gfn)
 	if (!kvmgt_gfn_is_write_protected(info, gfn))
 		return 0;
 
-	idx = srcu_read_lock(&kvm->srcu);
-	slot = gfn_to_memslot(kvm, gfn);
-	if (!slot) {
-		srcu_read_unlock(&kvm->srcu, idx);
-		return -EINVAL;
-	}
-
-	write_lock(&kvm->mmu_lock);
-	kvm_write_track_remove_gfn(kvm, slot, gfn);
-	write_unlock(&kvm->mmu_lock);
-	srcu_read_unlock(&kvm->srcu, idx);
+	r = kvm_write_track_remove_gfn(info->vfio_device.kvm, gfn);
+	if (r)
+		return r;
 
 	kvmgt_protect_table_del(info, gfn);
 	return 0;
-- 
2.40.0.rc1.284.g88254d51c5-goog

