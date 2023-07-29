Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFE4767B33
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 03:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237650AbjG2Bh5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 21:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237646AbjG2Bhe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 21:37:34 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7536D421F
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:37:08 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d05883d850fso2540022276.3
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690594579; x=1691199379;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=XilozmZkv3qT4uvOk9OGfExlIfdE0xODj7rqa2Bh8PM=;
        b=hO+4fiF1fkHnVD3UtJj0dyBOtLlEfJYvUvCIOLPoBwDENVolx+BkFi91s6HNCqGH+j
         btF/f+3/6aZZs711i2sxid1ZXbFkwyF9VUwB5BnTZ9cTQHcX3D9mXN3x42LvCtn3cpy7
         0h82vDAJxNZQqiQjV29unyyftMYVH15pLRpV3MwOAUnrpchjL9e6b9Cm9kikbVKI29UH
         alm0EEIP5+Ul5poFOocf7Haz6qYJe6L80hnqP7PX07ohKA11ufDJLc2sIFgWCTKKZe2p
         bAVrpvUfXDZekQdfVf4BXGh56pVVZMRFZNbCb0h4jH9pAngMRbqvuqVgOgF7pU6SxXBj
         ivfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690594579; x=1691199379;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XilozmZkv3qT4uvOk9OGfExlIfdE0xODj7rqa2Bh8PM=;
        b=DSzrSCPBeTBO3EPYBB7hooi9Zy+DGf2jsAYuNm1FsO5Uja5CgxYRLEXBuGmBWzvt7q
         Igy5E5VhAnavtiMIYNvdR9q6DTz84IUxoMa89fYksHEmEWuNspiMGQ1DdcaPpPhJviS+
         ST2soc+AIEH/yMlu42jTsSx5E0T9odeEbECYYEqy9bRfW0jzV/JZvVaBYYoByC2NX6F9
         inazc32VBVKA3NTbBLNzV9VJlBHFZhb9JEMWGlAtab64/8KF0KIC/EeSD2wwiFPn6ubI
         BSh1y2IqQk/XFuGEfFXe6vfUeJ28HO+sa+HdgmXhranjwOZqvVno4YgM0hZVNxqT84hC
         fI+g==
X-Gm-Message-State: ABy/qLbofIzqfdblyrahg609rbuMUmEn7+VljtBwHfRgBK8AeYjBRmSR
        hAWIXOIu+Z61sJRM5E04CqsvD1UEJng=
X-Google-Smtp-Source: APBJJlFFg9PA0dMhGk1hg2f3xzbBSDfFFMH/c4uNW7pFudReHIN1iuacXZDpVNtm1EKw3A4+tg2F7UDPB9E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:69c7:0:b0:d07:f1ed:521a with SMTP id
 e190-20020a2569c7000000b00d07f1ed521amr18224ybc.4.1690594578971; Fri, 28 Jul
 2023 18:36:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 18:35:24 -0700
In-Reply-To: <20230729013535.1070024-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729013535.1070024-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729013535.1070024-19-seanjc@google.com>
Subject: [PATCH v4 18/29] KVM: x86: Add a new page-track hook to handle
 memslot deletion
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
        autolearn=unavailable autolearn_force=no version=3.4.6
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
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
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
index 4394bb49051f..e9ecdf5fbdac 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12767,6 +12767,9 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
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
2.41.0.487.g6d72f3e995-goog

