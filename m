Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36572701362
	for <lists+kvm@lfdr.de>; Sat, 13 May 2023 02:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241920AbjEMAhy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 20:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241184AbjEMAhJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 20:37:09 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD8A65A6
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 17:36:49 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-55a7d1f6914so201015837b3.1
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 17:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683938201; x=1686530201;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=yBETkGnGrC8xyRU9tqoXVGFHlyOCEt0u5rcLYF6ohy4=;
        b=ZXGeAKEgO8hcDtjKpOXSnd1FbTzMf1+7DyVEZOA9BrMq9Tl7hGxQEzG/Fl1cU7yZhg
         u3Jy0T8wQykwBT1qHFXsHxlN5FIEKv02d3rVwzux3mJSTfb0D/7uMNLaEyb2gH9xYrkr
         WELoXfba5L0iPT22FkArGeve/0l5axDlImnWWHzdm7cSBVRxRoPzAF53f0wCIiHJB83W
         Zsct/PIdzW5XOp7SR/OCJPZOvq+sJZCUjz5sEKbIyxIg2y009eLzW8Qtmud6WTpisUMW
         n0pDLKH7s6WSInK2gy6hit353+jnmdLB04+6fToS9m7ApQSsdUH2geLdkYWa+KrfuChT
         BrPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683938201; x=1686530201;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yBETkGnGrC8xyRU9tqoXVGFHlyOCEt0u5rcLYF6ohy4=;
        b=cFtcz6W3PiPs6mffunWxQqJt5apieozQCzP+/9dyeH7cf57SWaT2c81gJWREtwRP5v
         OHW/3HNXjwq2sBpQUi7mhh8QWHd9w1pyfZlCEkyEjp/PPSFDZwN+ohuiVEAuX9yeyeiQ
         +pc2mOuhgu+uxm64/fUfamAdPbb8cM3RWBAsIpF5YmKIW01pXqGc4BLbLtWSCBHw6k5p
         0zOoO5hwbCTQFrCzjJpS4ccvkEpFAVjxGj6wEqyERNjOXj4uM0j1AhJ2ige/DWGz42MC
         hx2PGjwEivkzTQggS7uAjUov7nN7CuqQC9q0ZQcHHE5SfXUzPeVEQDL4pS5fb22aK48a
         v72g==
X-Gm-Message-State: AC+VfDzLitbcprhSPggT5A8lG5w22UNGbvPf2epGCs9OlrEoM9pqZWSU
        z2fKXYEFRQQV1UnRzTTrkFcDL4VIpi4=
X-Google-Smtp-Source: ACHHUZ7l3ePv6zKDFzoAhujwIzaWMwTG2FjHBPR4kh0IXDS7Hk0xhSDs9YHZN+pcUE3y+CqYI16b+YuhSro=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:e549:0:b0:55d:d26c:9aff with SMTP id
 c9-20020a81e549000000b0055dd26c9affmr13085374ywm.8.1683938201688; Fri, 12 May
 2023 17:36:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 12 May 2023 17:35:51 -0700
In-Reply-To: <20230513003600.818142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230513003600.818142-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230513003600.818142-20-seanjc@google.com>
Subject: [PATCH v3 19/28] KVM: x86: Remove the unused page-track hook track_flush_slot()
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yan Zhao <yan.y.zhao@intel.com>

Remove ->track_remove_slot(), there are no longer any users and it's
unlikely a "flush" hook will ever be the correct API to provide to an
external page-track user.

Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_page_track.h | 11 -----------
 arch/x86/kvm/mmu/mmu.c                |  2 --
 arch/x86/kvm/mmu/page_track.c         | 26 --------------------------
 3 files changed, 39 deletions(-)

diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index cfd36c22b467..5c348ffdc194 100644
--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -33,16 +33,6 @@ struct kvm_page_track_notifier_node {
 	 */
 	void (*track_write)(gpa_t gpa, const u8 *new, int bytes,
 			    struct kvm_page_track_notifier_node *node);
-	/*
-	 * It is called when memory slot is being moved or removed
-	 * users can drop write-protection for the pages in that memory slot
-	 *
-	 * @kvm: the kvm where memory slot being moved or removed
-	 * @slot: the memory slot being moved or removed
-	 * @node: this node
-	 */
-	void (*track_flush_slot)(struct kvm *kvm, struct kvm_memory_slot *slot,
-			    struct kvm_page_track_notifier_node *node);
 
 	/*
 	 * Invoked when a memory region is removed from the guest.  Or in KVM
@@ -85,7 +75,6 @@ kvm_page_track_unregister_notifier(struct kvm *kvm,
 				   struct kvm_page_track_notifier_node *n);
 void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
 			  int bytes);
-void kvm_page_track_flush_slot(struct kvm *kvm, struct kvm_memory_slot *slot);
 void kvm_page_track_delete_slot(struct kvm *kvm, struct kvm_memory_slot *slot);
 
 bool kvm_page_track_has_external_user(struct kvm *kvm);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index af3e562d3106..3f9030650c3d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6734,8 +6734,6 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 				   struct kvm_memory_slot *slot)
 {
 	kvm_mmu_zap_all_fast(kvm);
-
-	kvm_page_track_flush_slot(kvm, slot);
 }
 
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index d971c28be99d..2a6ab7c455c0 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -278,32 +278,6 @@ void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
 	kvm_mmu_track_write(vcpu, gpa, new, bytes);
 }
 
-/*
- * Notify the node that memory slot is being removed or moved so that it can
- * drop write-protection for the pages in the memory slot.
- *
- * The node should figure out it has any write-protected pages in this slot
- * by itself.
- */
-void kvm_page_track_flush_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
-{
-	struct kvm_page_track_notifier_head *head;
-	struct kvm_page_track_notifier_node *n;
-	int idx;
-
-	head = &kvm->arch.track_notifier_head;
-
-	if (hlist_empty(&head->track_notifier_list))
-		return;
-
-	idx = srcu_read_lock(&head->track_srcu);
-	hlist_for_each_entry_srcu(n, &head->track_notifier_list, node,
-				  srcu_read_lock_held(&head->track_srcu))
-		if (n->track_flush_slot)
-			n->track_flush_slot(kvm, slot, n);
-	srcu_read_unlock(&head->track_srcu, idx);
-}
-
 /*
  * Notify external page track nodes that a memory region is being removed from
  * the VM, e.g. so that users can free any associated metadata.
-- 
2.40.1.606.ga4b1b128d6-goog

