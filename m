Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4A7B767B36
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 03:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237715AbjG2BiM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 21:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236093AbjG2Bhs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 21:37:48 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4371D5277
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:37:14 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5840614b107so28646327b3.1
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690594582; x=1691199382;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=wTpX1Frbl1CZzWkMqdhrj26zVSxgif99bFB2HFXi9YM=;
        b=soHE3UQWev13aw3qeydbbk/YoO8A/lYgEoQqHJ/4+aQ2CCp6MzbKUqVF7XbIv2NZiT
         W9oqIwgdmT1ly2ZaP/K5+Xvi/Jr8zrMHfh4yUJvWq3GmjwJoMgNikPbWAlKt+SMK+ky6
         RPfHUWutT5ObWs2jTu+excv7gZcL1DSWVEJ+vbfD1j01rp3X2ZTzJzg8WA1aq8d9OU+q
         ckjx0KCmHi2Qs++tb4YKs3+R0YqNnsARd8cblNKaSw2TLxWCwtVLTekGs1HQBvRgZLWu
         o6idRi/DkgbRvwiM7tOgYiaXu7QwMm3qXln4Pu/7iXH1foYDFK6pTEO6xSiMbAXNF9AL
         cU0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690594582; x=1691199382;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wTpX1Frbl1CZzWkMqdhrj26zVSxgif99bFB2HFXi9YM=;
        b=CXUCL4JrwksY834KpQVrH6I8coKI7BkBkr0eQObk+tFNLI9LM42qLoOs2J+MDDHw/3
         bQXggiBw+8UV6JO59BFUb6j9TY6VYixRPQfh8/c03LRXhdgARabtqvf5LG64b7U07BJZ
         hoBfdZTLXc6GTXZBRlNCG/X7iO7BvMn0pnO3anMdIDYR9dYPeVXacKhem+UnmOJUx/so
         lWREKqbu/iso1dUeDZL3o0vsd9vNyTkesbur1jorFcBi7/HVmKdPwtDZTiC9F2FGazwN
         fkRTImuyaXEPUzxImkOqLczuKhCPfS8SVf+/E5Bu7ofRN/b0kbCW2QJVMYioqCwzFtX2
         rVgg==
X-Gm-Message-State: ABy/qLYXyVEpK5R3fYej55mcwuMBB2KE03OUJ3/UQP4rpHZ5FGs8MzNf
        LIOU/6BNiUEj01cPp+oQtOs0MTlCsHE=
X-Google-Smtp-Source: APBJJlFD/lES1hgMqXg3+qYGai6w1fjrQFKm50RkaBdliF1EQGlMqXmoVxnFcW/8hagaSj1QCxhIJvVvwo4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:450f:0:b0:576:de5f:95e1 with SMTP id
 s15-20020a81450f000000b00576de5f95e1mr23487ywa.1.1690594582658; Fri, 28 Jul
 2023 18:36:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 18:35:26 -0700
In-Reply-To: <20230729013535.1070024-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729013535.1070024-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729013535.1070024-21-seanjc@google.com>
Subject: [PATCH v4 20/29] KVM: x86: Remove the unused page-track hook track_flush_slot()
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

From: Yan Zhao <yan.y.zhao@intel.com>

Remove ->track_remove_slot(), there are no longer any users and it's
unlikely a "flush" hook will ever be the correct API to provide to an
external page-track user.

Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
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
index c404264f8de5..c1d3ac303964 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6749,8 +6749,6 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
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
2.41.0.487.g6d72f3e995-goog

