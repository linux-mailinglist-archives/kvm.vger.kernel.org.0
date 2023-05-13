Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F423370135E
	for <lists+kvm@lfdr.de>; Sat, 13 May 2023 02:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241884AbjEMAhs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 20:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241771AbjEMAhB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 20:37:01 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64EE45BA9
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 17:36:44 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-ba718f5cd50so2254128276.0
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 17:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683938197; x=1686530197;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=hOk4dWcQ6V4EoeQWEtnRQYqLFa7qU2Y1lMtcKl3MnMo=;
        b=q+j64L86t7KGU6pwwliYDlDG+3EtI69rBLeRmnLLYn7PEYrWo8+5g4PJc7MuisqX0+
         hTFtttgNbvWF2f86bIw1cqH3ne0LecMt9CRUoEcL3nIyYitqW7O6xMNq6rldgo38UsbM
         G9rkbsHodF1V3Bc6+SberFsjgRTRLGg+a1eswoFOQLIO++VHXvu0t4iknXMrJ4Yc85Cj
         quSy8CNA0KVydnJrnGGypMg/S1wcUxbkCbSNBgmMp+NAZFboW4Gqhpz30lxvXjV1lfCm
         DmjXpBUn0AdQRSDS9JF9biDw6lAL+ETQ2fcFvKRskFfE2Q4ssn2l1zy/XhAiURGqRGBk
         GQVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683938197; x=1686530197;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hOk4dWcQ6V4EoeQWEtnRQYqLFa7qU2Y1lMtcKl3MnMo=;
        b=NQQmmRwSY4fP7WADGl7cqk41xkxJiwEeq+b+AJiPnWlB62s14x/cuSR6R5ghkxHrgs
         7xhsoiMsA8MyPLwWapRlsge5xGBpF7ngGtOgqmdvX2baq8GuJRfydOY2DCn0E9DKMEJv
         kCgRgO0nwNGtk5hFllF+88Tn+s08eMBZVA1v58aq827Y50LgEZf+Rb/LaMto5rRGkIAj
         PR9Q3t4+A4oQFOdVCt/LWIQj1/aWyl68VeMo2THXoaZN4cBh6NSwd+RqvtCax4mAltGg
         ka2jcetMuCjMHNJwHrecyM3LBiU+pMl0/ZOc3huYcaDdFKUjhKX00Bubr/KHUBJgBPTz
         mQ6Q==
X-Gm-Message-State: AC+VfDxc7gkR8RKmpvYzWilbwEtOGCVJyiXKPClrqpuZ2n9wJ4Z45w/S
        RjDqJjU1q3Frb3VrHqn34tPV7Xe+umY=
X-Google-Smtp-Source: ACHHUZ4R8BMhyZByNc7/fx+yaocfqIk1P1bwZj6v6jHEhgl2PDmqaACwrKRzYrBOMI4EaNGh3acPSZjZRAY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:aa67:0:b0:ba7:2fb9:f6e with SMTP id
 s94-20020a25aa67000000b00ba72fb90f6emr1094362ybi.12.1683938197787; Fri, 12
 May 2023 17:36:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 12 May 2023 17:35:49 -0700
In-Reply-To: <20230513003600.818142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230513003600.818142-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230513003600.818142-18-seanjc@google.com>
Subject: [PATCH v3 17/28] KVM: x86: Add a new page-track hook to handle
 memslot deletion
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

Add a new page-track hook, track_remove_region(), that is called when a
memslot DELETE operation is about to be committed.  The "remove" hook
will be used by KVMGT and will effectively replace the existing
track_flush_slot() altogether now that KVM itself doesn't rely on the
"flush" hook either.

The "flush" hook is flawed as it's invoked before the memslot operation
is guaranteed to succeed, i.e. KVM might ultimately keep the existing
memslot without notifying external page track users, a.k.a. KVMGT.  In
practice, this can't currently happen on x86, but there are no guarantees
that won't change in the future, not to mention that "flush" does a very
poor job of describing what is happening.

Pass in the gfn+nr_pages instead of the slot itself so external users,
i.e. KVMGT, don't need to exposed to KVM internals (memslots).  This will
help set the stage for additional cleanups to the page-track APIs.

Opportunistically align the existing srcu_read_lock_held() usage so that
the new case doesn't stand out like a sore thumb (and not aligning the
new code makes bots unhappy).

Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_page_track.h | 12 ++++++++++++
 arch/x86/kvm/mmu/page_track.c         | 27 +++++++++++++++++++++++++--
 arch/x86/kvm/x86.c                    |  3 +++
 3 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index f744682648e7..cfd36c22b467 100644
--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -43,6 +43,17 @@ struct kvm_page_track_notifier_node {
 	 */
 	void (*track_flush_slot)(struct kvm *kvm, struct kvm_memory_slot *slot,
 			    struct kvm_page_track_notifier_node *node);
+
+	/*
+	 * Invoked when a memory region is removed from the guest.  Or in KVM
+	 * terms, when a memslot is deleted.
+	 *
+	 * @gfn:       base gfn of the region being removed
+	 * @nr_pages:  number of pages in the to-be-removed region
+	 * @node:      this node
+	 */
+	void (*track_remove_region)(gfn_t gfn, unsigned long nr_pages,
+				    struct kvm_page_track_notifier_node *node);
 };
 
 int kvm_page_track_init(struct kvm *kvm);
@@ -75,6 +86,7 @@ kvm_page_track_unregister_notifier(struct kvm *kvm,
 void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
 			  int bytes);
 void kvm_page_track_flush_slot(struct kvm *kvm, struct kvm_memory_slot *slot);
+void kvm_page_track_delete_slot(struct kvm *kvm, struct kvm_memory_slot *slot);
 
 bool kvm_page_track_has_external_user(struct kvm *kvm);
 
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index e6de9638e560..d971c28be99d 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -270,7 +270,7 @@ void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
 
 	idx = srcu_read_lock(&head->track_srcu);
 	hlist_for_each_entry_srcu(n, &head->track_notifier_list, node,
-				srcu_read_lock_held(&head->track_srcu))
+				  srcu_read_lock_held(&head->track_srcu))
 		if (n->track_write)
 			n->track_write(gpa, new, bytes, n);
 	srcu_read_unlock(&head->track_srcu, idx);
@@ -298,12 +298,35 @@ void kvm_page_track_flush_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
 
 	idx = srcu_read_lock(&head->track_srcu);
 	hlist_for_each_entry_srcu(n, &head->track_notifier_list, node,
-				srcu_read_lock_held(&head->track_srcu))
+				  srcu_read_lock_held(&head->track_srcu))
 		if (n->track_flush_slot)
 			n->track_flush_slot(kvm, slot, n);
 	srcu_read_unlock(&head->track_srcu, idx);
 }
 
+/*
+ * Notify external page track nodes that a memory region is being removed from
+ * the VM, e.g. so that users can free any associated metadata.
+ */
+void kvm_page_track_delete_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
+{
+	struct kvm_page_track_notifier_head *head;
+	struct kvm_page_track_notifier_node *n;
+	int idx;
+
+	head = &kvm->arch.track_notifier_head;
+
+	if (hlist_empty(&head->track_notifier_list))
+		return;
+
+	idx = srcu_read_lock(&head->track_srcu);
+	hlist_for_each_entry_srcu(n, &head->track_notifier_list, node,
+				  srcu_read_lock_held(&head->track_srcu))
+		if (n->track_remove_region)
+			n->track_remove_region(slot->base_gfn, slot->npages, n);
+	srcu_read_unlock(&head->track_srcu, idx);
+}
+
 bool kvm_page_track_has_external_user(struct kvm *kvm)
 {
 	return hlist_empty(&kvm->arch.track_notifier_head.track_notifier_list);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c6bbd8ffd8c8..6ae2b612f8c6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12749,6 +12749,9 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
 {
+	if (change == KVM_MR_DELETE)
+		kvm_page_track_delete_slot(kvm, old);
+
 	if (!kvm->arch.n_requested_mmu_pages &&
 	    (change == KVM_MR_CREATE || change == KVM_MR_DELETE)) {
 		unsigned long nr_mmu_pages;
-- 
2.40.1.606.ga4b1b128d6-goog

