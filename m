Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45CF3473832
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 23:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244092AbhLMW7d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 17:59:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244071AbhLMW7d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 17:59:33 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACED5C061574
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 14:59:32 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id bs14-20020a05620a470e00b0046b1e29f53cso15974422qkb.0
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 14:59:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=NOgYZl20nuzj8fG4+DAG1wWXIv0xjdk8c+/nZNXlwis=;
        b=jFZn4tVVuETK5sVmX65cljDVjDeVNpmI/wox6rhf53J2ZOd1EagBapndwYSMWKA/0W
         ho0XOi6nntwM+SrHIu1Qf6d5z+WaAEd+UMn4l/WgDAbVropsGO1lTfuLscPqlMZb/QgZ
         Q9hWYyI4qGtV3pVwTG3rTLPKNwXb7qwHe0VTqwk1TTLrqDOjoGXViTZGH426NGClFFEb
         5hBghiDOXJFnsTD7epFX4Ofw4+Fzgnod4jpiZXbVaJ7dwEDzd/DkgTspSHIbZqVATuSG
         khtnZsEDPbG/MRWJc5DUBNXfZuWY4EIJ2ustuGpulRmlKopTAkNS2x9Eppotta7C8ZXz
         eeJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NOgYZl20nuzj8fG4+DAG1wWXIv0xjdk8c+/nZNXlwis=;
        b=V5Xh/fDCkEkp+joCY8stmIOQNwOO4ACbwZuZ8jsULOZWoATw0dlVP2Zr+XYfidEizG
         N2kD8k7NXdGmcwgbWfrkL6W5IVPckj05i+Sp1WfFpVJMMMU2vlP78O/3/4+Ch0qf95LR
         JxuMFrBsXKizlB8YEaXWBgZHIWQ4vC/NgW46ODJRiA4XZqttCU80ojQfmChrij0doT0b
         k8abB8d4pu37xHXbH2MNKmAJpE5flZPWUA08f+rSe5HVAekXdS7zQ9O06oVovsKBy31d
         Wp8bK1A08yNi2vmTapEZM1lna3/RzYDARIlU+S6bHafFgD0sXkol0mqZI4z8AxGFD/3v
         B/Vg==
X-Gm-Message-State: AOAM533WLn+EFcFxgqRgmMi7VK+RWRww39XmQXx98EwE+i+SATesJoq8
        QEWC4lP2eE4XNrnfCUYcpvzLRS+NAzYDbg==
X-Google-Smtp-Source: ABdhPJzBPWNKAk0WbXAy88XhQI/1ggjFYVsEExKh6UMrl/2jN0yx8LHNgf9a+i+YX1wjV1Tvz/gPQfa7yYPIXg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:ac8:7595:: with SMTP id
 s21mr1724407qtq.132.1639436371689; Mon, 13 Dec 2021 14:59:31 -0800 (PST)
Date:   Mon, 13 Dec 2021 22:59:11 +0000
In-Reply-To: <20211213225918.672507-1-dmatlack@google.com>
Message-Id: <20211213225918.672507-7-dmatlack@google.com>
Mime-Version: 1.0
References: <20211213225918.672507-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH v1 06/13] KVM: x86/mmu: Refactor tdp_mmu iterators to take
 kvm_mmu_page root
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instead of passing a pointer to the root page table and the root level
separately, pass in a pointer to the kvm_mmu_page that backs the root.
This reduces the number of arguments by 1, cutting down on line lengths.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_iter.c |  5 ++++-
 arch/x86/kvm/mmu/tdp_iter.h | 10 +++++-----
 arch/x86/kvm/mmu/tdp_mmu.c  | 14 +++++---------
 3 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
index b3ed302c1a35..92b3a075525a 100644
--- a/arch/x86/kvm/mmu/tdp_iter.c
+++ b/arch/x86/kvm/mmu/tdp_iter.c
@@ -39,9 +39,12 @@ void tdp_iter_restart(struct tdp_iter *iter)
  * Sets a TDP iterator to walk a pre-order traversal of the paging structure
  * rooted at root_pt, starting with the walk to translate next_last_level_gfn.
  */
-void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
+void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
 		    int min_level, gfn_t next_last_level_gfn)
 {
+	u64 *root_pt = root->spt;
+	int root_level = root->role.level;
+
 	WARN_ON(root_level < 1);
 	WARN_ON(root_level > PT64_ROOT_MAX_LEVEL);
 
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index b1748b988d3a..ec1f58013428 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -51,17 +51,17 @@ struct tdp_iter {
  * Iterates over every SPTE mapping the GFN range [start, end) in a
  * preorder traversal.
  */
-#define for_each_tdp_pte_min_level(iter, root, root_level, min_level, start, end) \
-	for (tdp_iter_start(&iter, root, root_level, min_level, start); \
+#define for_each_tdp_pte_min_level(iter, root, min_level, start, end) \
+	for (tdp_iter_start(&iter, root, min_level, start); \
 	     iter.valid && iter.gfn < end;		     \
 	     tdp_iter_next(&iter))
 
-#define for_each_tdp_pte(iter, root, root_level, start, end) \
-	for_each_tdp_pte_min_level(iter, root, root_level, PG_LEVEL_4K, start, end)
+#define for_each_tdp_pte(iter, root, start, end) \
+	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_4K, start, end)
 
 tdp_ptep_t spte_to_child_pt(u64 pte, int level);
 
-void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
+void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
 		    int min_level, gfn_t next_last_level_gfn);
 void tdp_iter_next(struct tdp_iter *iter);
 void tdp_iter_restart(struct tdp_iter *iter);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index dbd07c10d11a..2fb2d7677fbf 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -632,7 +632,7 @@ static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
 }
 
 #define tdp_root_for_each_pte(_iter, _root, _start, _end) \
-	for_each_tdp_pte(_iter, _root->spt, _root->role.level, _start, _end)
+	for_each_tdp_pte(_iter, _root, _start, _end)
 
 #define tdp_root_for_each_leaf_pte(_iter, _root, _start, _end)	\
 	tdp_root_for_each_pte(_iter, _root, _start, _end)		\
@@ -642,8 +642,7 @@ static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
 		else
 
 #define tdp_mmu_for_each_pte(_iter, _mmu, _start, _end)		\
-	for_each_tdp_pte(_iter, __va(_mmu->root_hpa),		\
-			 _mmu->shadow_root_level, _start, _end)
+	for_each_tdp_pte(_iter, to_shadow_page(_mmu->root_hpa), _start, _end)
 
 /*
  * Yield if the MMU lock is contended or this thread needs to return control
@@ -733,8 +732,7 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	rcu_read_lock();
 
-	for_each_tdp_pte_min_level(iter, root->spt, root->role.level,
-				   min_level, start, end) {
+	for_each_tdp_pte_min_level(iter, root, min_level, start, end) {
 retry:
 		if (can_yield &&
 		    tdp_mmu_iter_cond_resched(kvm, &iter, flush, shared)) {
@@ -1205,8 +1203,7 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	BUG_ON(min_level > KVM_MAX_HUGEPAGE_LEVEL);
 
-	for_each_tdp_pte_min_level(iter, root->spt, root->role.level,
-				   min_level, start, end) {
+	for_each_tdp_pte_min_level(iter, root, min_level, start, end) {
 retry:
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
 			continue;
@@ -1445,8 +1442,7 @@ static bool write_protect_gfn(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	rcu_read_lock();
 
-	for_each_tdp_pte_min_level(iter, root->spt, root->role.level,
-				   min_level, gfn, gfn + 1) {
+	for_each_tdp_pte_min_level(iter, root, min_level, gfn, gfn + 1) {
 		if (!is_shadow_present_pte(iter.old_spte) ||
 		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
-- 
2.34.1.173.g76aa8bc2d0-goog

