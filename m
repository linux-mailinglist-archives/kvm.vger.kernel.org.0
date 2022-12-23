Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29019654A37
	for <lists+kvm@lfdr.de>; Fri, 23 Dec 2022 01:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235943AbiLWA7x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 19:59:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235443AbiLWA7U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 19:59:20 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C4F430F48
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 16:58:17 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id x33-20020a056a0018a100b00577808a75c9so1856638pfh.13
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 16:58:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=X9EHB+RzWsWWDtGZg2fi2KUK6Xky3sXoaWyuBFV7tYw=;
        b=faSnv4jQrmW5NUcqzJ2WGLzWcQllkNhqoyOREQMeig2czZ8KGDuFWyKa6x847GE+VX
         o/P3LUqleQwxYP3TQaf4XGOp37Ot02n5vwTtLgPoEsMUKlATkqax06ahv17x5FpsTCTu
         09SIQXfz/4xxcXAAaeUEvXMOXUISpYK0NVGDB9qKyC/vvx4ccCdga81eEfDrQt3zdISK
         6l2MeGCDHEvEu2ISC43VWNyFCpjNShBpzKR2UlRl7gJBVy/tzx0zv9NxzG2YoHaTUVPs
         Ay8tDsrQbxQ4W2KLa4J2F3Rx6KoRButgm6QkS0p8RbPT5LR7YtwxjQar0pZAc9bW3Zmb
         Nh5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X9EHB+RzWsWWDtGZg2fi2KUK6Xky3sXoaWyuBFV7tYw=;
        b=gKxValiOp9JjCImynklXpso32/ON60HJeIG6xH9DhbssQh3T/LG6SbbbhsZnT8knAA
         3KlczbnvFZOlzoUA5W4cl3Ug6+i6spegfSkUqjnZ52zh/4WQY52/EkA//q+cE3IRd7VG
         Sb6lp1mE2Zlha0aac1IIfpCEqoGVl9NzKYx+x7IQlOJKI5PSWn7wqypKvs7zpBFKJk1L
         W1mQPB1oQLDmRWT6J1beVieO/CMCkFFhc5cdF/qyJecWTL0ftEPhMFKalU21mhVSp8dq
         znSDX+5qGnGrCPnc9050fpSWClL9uNLF2JA4l2EwIgc9P56+JXasUAw/9s1hzZcS/krz
         lDPg==
X-Gm-Message-State: AFqh2kr0euZP/x0ukVPzsX13fgC8Hed66zZ1NXQPJa6uq9V64sIxor5A
        7pRp8tID3RclQPnDk0kPZmj8c0tGyEs=
X-Google-Smtp-Source: AMrXdXvHntSuAvyCvkSHScjoEI+pXpAEx/uWsZ44sBr128HcVHu3yNpj/ax6VoZ1ZvxheE3B45dTuP6M/oE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2581:b0:18f:a4f8:31db with SMTP id
 jb1-20020a170903258100b0018fa4f831dbmr584202plb.28.1671757090047; Thu, 22 Dec
 2022 16:58:10 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Dec 2022 00:57:27 +0000
In-Reply-To: <20221223005739.1295925-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221223005739.1295925-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221223005739.1295925-16-seanjc@google.com>
Subject: [PATCH 15/27] KVM: x86: Add a new page-track hook to handle memslot deletion
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

Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_page_track.h | 12 ++++++++++++
 arch/x86/kvm/mmu/page_track.c         | 23 +++++++++++++++++++++++
 arch/x86/kvm/x86.c                    |  3 +++
 3 files changed, 38 insertions(+)

diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index 6a287bcbe8a9..152c5e7d7868 100644
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
@@ -77,6 +88,7 @@ kvm_page_track_unregister_notifier(struct kvm *kvm,
 void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
 			  int bytes);
 void kvm_page_track_flush_slot(struct kvm *kvm, struct kvm_memory_slot *slot);
+void kvm_page_track_delete_slot(struct kvm *kvm, struct kvm_memory_slot *slot);
 
 bool kvm_page_track_has_external_user(struct kvm *kvm);
 
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index c474a0ff24ba..959be672e2ad 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -303,6 +303,29 @@ void kvm_page_track_flush_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
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
+				srcu_read_lock_held(&head->track_srcu))
+		if (n->track_remove_region)
+			n->track_remove_region(slot->base_gfn, slot->npages, n);
+	srcu_read_unlock(&head->track_srcu, idx);
+}
+
 enum pg_level kvm_page_track_max_mapping_level(struct kvm *kvm, gfn_t gfn,
 					       enum pg_level max_level)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b587858e878e..cb0005e4baf0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12582,6 +12582,9 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
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
2.39.0.314.g84b9a713c41-goog

