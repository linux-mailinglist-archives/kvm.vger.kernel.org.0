Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 127EC767B50
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 03:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234323AbjG2Bos (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 21:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235560AbjG2Boo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 21:44:44 -0400
Received: from mail-oi1-x249.google.com (mail-oi1-x249.google.com [IPv6:2607:f8b0:4864:20::249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D944F1FC9
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:44:35 -0700 (PDT)
Received: by mail-oi1-x249.google.com with SMTP id 5614622812f47-3a5ab2d2a31so5009778b6e.2
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690595075; x=1691199875;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=9vAdDrMzBYVHHQ4WFSPjYDLe28mx0kAseFtg2XLVMp4=;
        b=WkmxE2l2i/YiqMJd/AJXwZtBaZLJR3MMMIAWtYakFrfUYpLYySgQJhdrnsbnshau6P
         6AEiQ+8umkmwGkW77SGPdSJdqvsxwRYO2NQvJ9MXhn5jqxzg+s93fM3iA8JcrztlILZ4
         vKEYMXR8SJy8hAraYYxP5Xy923r5FoskPEi8z0lnHcm6U+5H4hOBMhkE4DpdxM02ieQ2
         YMWtFpGwKeYQhOOlN55M5j02TofR4KqsX5u4BxUJBtrRadBILAnWMEpBp1Cu7240xA0o
         G33aADMh5jjfh62Yoh43ej0HqycendpTeZw6FGdOSjIiq+akksyRV4Qb4aPPBRIem0iP
         bY5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690595075; x=1691199875;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9vAdDrMzBYVHHQ4WFSPjYDLe28mx0kAseFtg2XLVMp4=;
        b=a1ntVEo3QxVdUydVeRBiucR/QHfEP73hdwDcQI8FAlplk+a0Y4lqC4WzCprhmdWadK
         fHp2vlqd2pPImFk4ygSdWhSVfVI+/+j8vRNXCzrlP92o1irlVGJY19qPGwVVz1PB0xV1
         FVJS3YEJvdmrtq9MDa4F7MRbc0eAf40NB3WYRCcPILwKDioAXevtEOL1r48DpWI/OHrm
         EIJZ7o071ya8kE6bYkGSs9zouOIq/MQF2OeVgK5FY7L86ON2s/GO7MGZelaSzXTlOORU
         n2meFqJDFd0y4+YGdamEYt9Lt90gRbYQdBbQn0cRPQTXHe8gxKmceGTPFEZ3I1VljYrt
         oCJw==
X-Gm-Message-State: ABy/qLbspmR5wIoYBVEsnpwILipBp7ZITRkOUZ+wSjjxzXmNDeA9dD1T
        WhReBtfu/gCbBea9qAke8WTzwGdefG0=
X-Google-Smtp-Source: APBJJlFt2HUQIFRb6EqUZeZ2Ch0VOFFLk3lQZKafVSbOEoKhvLjWUDsyJB0QpOr3or3KM2I0J8SSrPngUaY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2807:b0:1a2:3436:4119 with SMTP id
 kp7-20020a170903280700b001a234364119mr10970plb.8.1690594589996; Fri, 28 Jul
 2023 18:36:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 18:35:30 -0700
In-Reply-To: <20230729013535.1070024-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729013535.1070024-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729013535.1070024-25-seanjc@google.com>
Subject: [PATCH v4 24/29] KVM: x86/mmu: Rename page-track APIs to reflect the
 new reality
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     kvm@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>,
        Yongwei Ma <yongwei.ma@intel.com>,
        Ben Gardon <bgardon@google.com>
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

Rename the page-track APIs to capture that they're all about tracking
writes, now that the facade of supporting multiple modes is gone.

Opportunstically replace "slot" with "gfn" in anticipation of removing
the @slot param from the external APIs.

No functional change intended.

Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_page_track.h |  8 ++++----
 arch/x86/kvm/mmu/mmu.c                |  8 ++++----
 arch/x86/kvm/mmu/page_track.c         | 21 +++++++++------------
 arch/x86/kvm/mmu/page_track.h         |  4 ++--
 drivers/gpu/drm/i915/gvt/kvmgt.c      |  4 ++--
 5 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index 9e4ee26d1779..f5c1db36cdb7 100644
--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -4,10 +4,10 @@
 
 #include <linux/kvm_types.h>
 
-void kvm_slot_page_track_add_page(struct kvm *kvm,
-				  struct kvm_memory_slot *slot, gfn_t gfn);
-void kvm_slot_page_track_remove_page(struct kvm *kvm,
-				     struct kvm_memory_slot *slot, gfn_t gfn);
+void kvm_write_track_add_gfn(struct kvm *kvm,
+			     struct kvm_memory_slot *slot, gfn_t gfn);
+void kvm_write_track_remove_gfn(struct kvm *kvm, struct kvm_memory_slot *slot,
+				gfn_t gfn);
 
 #ifdef CONFIG_KVM_EXTERNAL_WRITE_TRACKING
 /*
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b8dce17bffdc..a0309fde3549 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -840,7 +840,7 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 
 	/* the non-leaf shadow pages are keeping readonly. */
 	if (sp->role.level > PG_LEVEL_4K)
-		return kvm_slot_page_track_add_page(kvm, slot, gfn);
+		return kvm_write_track_add_gfn(kvm, slot, gfn);
 
 	kvm_mmu_gfn_disallow_lpage(slot, gfn);
 
@@ -886,7 +886,7 @@ static void unaccount_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 	slots = kvm_memslots_for_spte_role(kvm, sp->role);
 	slot = __gfn_to_memslot(slots, gfn);
 	if (sp->role.level > PG_LEVEL_4K)
-		return kvm_slot_page_track_remove_page(kvm, slot, gfn);
+		return kvm_write_track_remove_gfn(kvm, slot, gfn);
 
 	kvm_mmu_gfn_allow_lpage(slot, gfn);
 }
@@ -2830,7 +2830,7 @@ int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
 	 * track machinery is used to write-protect upper-level shadow pages,
 	 * i.e. this guards the role.level == 4K assertion below!
 	 */
-	if (kvm_slot_page_track_is_active(kvm, slot, gfn))
+	if (kvm_gfn_is_write_tracked(kvm, slot, gfn))
 		return -EPERM;
 
 	/*
@@ -4231,7 +4231,7 @@ static bool page_fault_handle_page_track(struct kvm_vcpu *vcpu,
 	 * guest is writing the page which is write tracked which can
 	 * not be fixed by page fault handler.
 	 */
-	if (kvm_slot_page_track_is_active(vcpu->kvm, fault->slot, fault->gfn))
+	if (kvm_gfn_is_write_tracked(vcpu->kvm, fault->slot, fault->gfn))
 		return true;
 
 	return false;
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index cdc6069b8caf..b835ba7f325c 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -84,10 +84,9 @@ static void update_gfn_write_track(struct kvm_memory_slot *slot, gfn_t gfn,
  * @slot: the @gfn belongs to.
  * @gfn: the guest page.
  */
-void kvm_slot_page_track_add_page(struct kvm *kvm,
-				  struct kvm_memory_slot *slot, gfn_t gfn)
+void kvm_write_track_add_gfn(struct kvm *kvm, struct kvm_memory_slot *slot,
+			     gfn_t gfn)
 {
-
 	if (WARN_ON(!kvm_page_track_write_tracking_enabled(kvm)))
 		return;
 
@@ -102,12 +101,11 @@ void kvm_slot_page_track_add_page(struct kvm *kvm,
 	if (kvm_mmu_slot_gfn_write_protect(kvm, slot, gfn, PG_LEVEL_4K))
 		kvm_flush_remote_tlbs(kvm);
 }
-EXPORT_SYMBOL_GPL(kvm_slot_page_track_add_page);
+EXPORT_SYMBOL_GPL(kvm_write_track_add_gfn);
 
 /*
  * remove the guest page from the tracking pool which stops the interception
- * of corresponding access on that page. It is the opposed operation of
- * kvm_slot_page_track_add_page().
+ * of corresponding access on that page.
  *
  * It should be called under the protection both of mmu-lock and kvm->srcu
  * or kvm->slots_lock.
@@ -116,8 +114,8 @@ EXPORT_SYMBOL_GPL(kvm_slot_page_track_add_page);
  * @slot: the @gfn belongs to.
  * @gfn: the guest page.
  */
-void kvm_slot_page_track_remove_page(struct kvm *kvm,
-				     struct kvm_memory_slot *slot, gfn_t gfn)
+void kvm_write_track_remove_gfn(struct kvm *kvm,
+				struct kvm_memory_slot *slot, gfn_t gfn)
 {
 	if (WARN_ON(!kvm_page_track_write_tracking_enabled(kvm)))
 		return;
@@ -130,14 +128,13 @@ void kvm_slot_page_track_remove_page(struct kvm *kvm,
 	 */
 	kvm_mmu_gfn_allow_lpage(slot, gfn);
 }
-EXPORT_SYMBOL_GPL(kvm_slot_page_track_remove_page);
+EXPORT_SYMBOL_GPL(kvm_write_track_remove_gfn);
 
 /*
  * check if the corresponding access on the specified guest page is tracked.
  */
-bool kvm_slot_page_track_is_active(struct kvm *kvm,
-				   const struct kvm_memory_slot *slot,
-				   gfn_t gfn)
+bool kvm_gfn_is_write_tracked(struct kvm *kvm,
+			      const struct kvm_memory_slot *slot, gfn_t gfn)
 {
 	int index;
 
diff --git a/arch/x86/kvm/mmu/page_track.h b/arch/x86/kvm/mmu/page_track.h
index 789d0c479519..50d3278e8c69 100644
--- a/arch/x86/kvm/mmu/page_track.h
+++ b/arch/x86/kvm/mmu/page_track.h
@@ -15,8 +15,8 @@ int kvm_page_track_create_memslot(struct kvm *kvm,
 				  struct kvm_memory_slot *slot,
 				  unsigned long npages);
 
-bool kvm_slot_page_track_is_active(struct kvm *kvm,
-				   const struct kvm_memory_slot *slot, gfn_t gfn);
+bool kvm_gfn_is_write_tracked(struct kvm *kvm,
+			      const struct kvm_memory_slot *slot, gfn_t gfn);
 
 #ifdef CONFIG_KVM_EXTERNAL_WRITE_TRACKING
 int kvm_page_track_init(struct kvm *kvm);
diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index e71182b8a3f2..05a7e614ead0 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -1564,7 +1564,7 @@ int intel_gvt_page_track_add(struct intel_vgpu *info, u64 gfn)
 	}
 
 	write_lock(&kvm->mmu_lock);
-	kvm_slot_page_track_add_page(kvm, slot, gfn);
+	kvm_write_track_add_gfn(kvm, slot, gfn);
 	write_unlock(&kvm->mmu_lock);
 
 	srcu_read_unlock(&kvm->srcu, idx);
@@ -1593,7 +1593,7 @@ int intel_gvt_page_track_remove(struct intel_vgpu *info, u64 gfn)
 	}
 
 	write_lock(&kvm->mmu_lock);
-	kvm_slot_page_track_remove_page(kvm, slot, gfn);
+	kvm_write_track_remove_gfn(kvm, slot, gfn);
 	write_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, idx);
 
-- 
2.41.0.487.g6d72f3e995-goog

