Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7B7F654A46
	for <lists+kvm@lfdr.de>; Fri, 23 Dec 2022 02:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235904AbiLWBAl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 20:00:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235829AbiLWA7q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 19:59:46 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889CF2657E
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 16:58:26 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id h67-20020a25d046000000b00729876d3b2bso3658943ybg.17
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 16:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=OftwLhQlc3ILYP64Rx0ZoF0RinJzoLM1dueGgX9jUXs=;
        b=ogdVxFv8UK1fTIG0q+V0K+37QRfyFaXZy9qh7NOaHP9YJehENPH9J7hUf4ukH8p4B+
         s2m5kUhBDPSie23D4CQdKRDMBCyd7tehAmhILqMsttO6SsOfTXbH8fBxLh68b0C/3CF4
         6RjIx7KNzt4WN3/u9bVVZq+lcpfrMDric7mRNgMfcFml/HNfNB/t6cCDuKnM+AJh0fPh
         F2miMXnfcg4SnPzx5vqD3WUoh5MVVyNwPZXD3tXFxZYeUHHngkgjProymf2/RuocMLhm
         MBa+LEkJtOavAlEefdXAlQ/x3er7lJbRz1aVhpj9Scgke51DWsA7og0itSh1CQYjS4lq
         kjzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OftwLhQlc3ILYP64Rx0ZoF0RinJzoLM1dueGgX9jUXs=;
        b=dT1VKiCoQrauiECTsEZSUBrYICschFUmT63AoPJbdSmUyOWahLuBQDWNKscH5fq5dO
         rVtyVRaDrkynIxAzafTipCLxmyl7ZTlaZkOai4sSbMWHQ52qebd3lcBlwqJMFd1u9hH/
         xOwr2QsU7OsoJ+EJaAYDO2A+4YirsZ2H/avXqWZusIn2snWxB5IDd1tyraHPbxBViD76
         3+/jzrJKF6EJ/8cbLSyfWsM42lhwvKJ8AsWbdGxcjGTTRgSCWBPUneHhybrQ8LAnpyWl
         SeBaR6JUZiHBxluVAJDsG7ZN6HQTUYZWK914kNAR+TT+Hn3PKlhq1LFwHfWnyJkD2OST
         X6hQ==
X-Gm-Message-State: AFqh2kqDuLKWsy1l7lNbUwUCkQTr+0P9yoaSoDD1YLGLlOdMRJmSfhzP
        /nTrHKBt1UqJ6tIwO9JD5U9bTEqiZbs=
X-Google-Smtp-Source: AMrXdXtpBTQ36Lkov+En41Ue7zOfo1vvPEz1s7SvFBnlOkEiLikuUhgRE5OKYWnjvoahybMX3TV8KaDRPKU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:6dc6:0:b0:376:f7e2:b8de with SMTP id
 i189-20020a816dc6000000b00376f7e2b8demr788275ywc.335.1671757101450; Thu, 22
 Dec 2022 16:58:21 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Dec 2022 00:57:33 +0000
In-Reply-To: <20221223005739.1295925-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221223005739.1295925-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221223005739.1295925-22-seanjc@google.com>
Subject: [PATCH 21/27] KVM: x86/mmu: Rename page-track APIs to reflect the new reality
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

Rename the page-track APIs to capture that they're all about tracking
writes, now that the facade of supporting multiple modes is gone.

Opportunstically replace "slot" with "gfn" in anticipation of removing
the @slot param from the external APIs.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_page_track.h |  8 ++++----
 arch/x86/kvm/mmu/mmu.c                |  8 ++++----
 arch/x86/kvm/mmu/page_track.c         | 21 +++++++++------------
 arch/x86/kvm/mmu/page_track.h         |  4 ++--
 drivers/gpu/drm/i915/gvt/kvmgt.c      |  4 ++--
 5 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index 42a4ae451d36..20055064793a 100644
--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -43,10 +43,10 @@ struct kvm_page_track_notifier_node {
 				    struct kvm_page_track_notifier_node *node);
 };
 
-void kvm_slot_page_track_add_page(struct kvm *kvm,
-				  struct kvm_memory_slot *slot, gfn_t gfn);
-void kvm_slot_page_track_remove_page(struct kvm *kvm,
-				     struct kvm_memory_slot *slot, gfn_t gfn);
+void kvm_write_track_add_gfn(struct kvm *kvm,
+			     struct kvm_memory_slot *slot, gfn_t gfn);
+void kvm_write_track_remove_gfn(struct kvm *kvm, struct kvm_memory_slot *slot,
+				gfn_t gfn);
 
 #ifdef CONFIG_KVM_EXTERNAL_WRITE_TRACKING
 enum pg_level kvm_page_track_max_mapping_level(struct kvm *kvm, gfn_t gfn,
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ffcfc75cd4c1..b4cc762cfe11 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -807,7 +807,7 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 
 	/* the non-leaf shadow pages are keeping readonly. */
 	if (sp->role.level > PG_LEVEL_4K)
-		return kvm_slot_page_track_add_page(kvm, slot, gfn);
+		return kvm_write_track_add_gfn(kvm, slot, gfn);
 
 	kvm_mmu_gfn_disallow_lpage(slot, gfn);
 
@@ -853,7 +853,7 @@ static void unaccount_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 	slots = kvm_memslots_for_spte_role(kvm, sp->role);
 	slot = __gfn_to_memslot(slots, gfn);
 	if (sp->role.level > PG_LEVEL_4K)
-		return kvm_slot_page_track_remove_page(kvm, slot, gfn);
+		return kvm_write_track_remove_gfn(kvm, slot, gfn);
 
 	kvm_mmu_gfn_allow_lpage(slot, gfn);
 }
@@ -2725,7 +2725,7 @@ int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
 	 * track machinery is used to write-protect upper-level shadow pages,
 	 * i.e. this guards the role.level == 4K assertion below!
 	 */
-	if (kvm_slot_page_track_is_active(kvm, slot, gfn))
+	if (kvm_gfn_is_write_tracked(kvm, slot, gfn))
 		return -EPERM;
 
 	/*
@@ -4135,7 +4135,7 @@ static bool page_fault_handle_page_track(struct kvm_vcpu *vcpu,
 	 * guest is writing the page which is write tracked which can
 	 * not be fixed by page fault handler.
 	 */
-	if (kvm_slot_page_track_is_active(vcpu->kvm, fault->slot, fault->gfn))
+	if (kvm_gfn_is_write_tracked(vcpu->kvm, fault->slot, fault->gfn))
 		return true;
 
 	return false;
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 4077aa6d6ff4..1eb516119fdb 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -83,10 +83,9 @@ static void update_gfn_write_track(struct kvm_memory_slot *slot, gfn_t gfn,
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
 
@@ -101,12 +100,11 @@ void kvm_slot_page_track_add_page(struct kvm *kvm,
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
@@ -115,8 +113,8 @@ EXPORT_SYMBOL_GPL(kvm_slot_page_track_add_page);
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
@@ -129,14 +127,13 @@ void kvm_slot_page_track_remove_page(struct kvm *kvm,
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
index ae2860bdf560..b27ccc588648 100644
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
index cabad0ff722c..325afeb1246c 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -1584,7 +1584,7 @@ int intel_gvt_page_track_add(struct intel_vgpu *info, u64 gfn)
 	}
 
 	write_lock(&kvm->mmu_lock);
-	kvm_slot_page_track_add_page(kvm, slot, gfn);
+	kvm_write_track_add_gfn(kvm, slot, gfn);
 	write_unlock(&kvm->mmu_lock);
 
 	srcu_read_unlock(&kvm->srcu, idx);
@@ -1618,7 +1618,7 @@ int intel_gvt_page_track_remove(struct intel_vgpu *info, u64 gfn)
 	}
 
 	write_lock(&kvm->mmu_lock);
-	kvm_slot_page_track_remove_page(kvm, slot, gfn);
+	kvm_write_track_remove_gfn(kvm, slot, gfn);
 	write_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, idx);
 
-- 
2.39.0.314.g84b9a713c41-goog

