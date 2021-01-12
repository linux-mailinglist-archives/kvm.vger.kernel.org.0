Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DBDF2F3838
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 19:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406602AbhALSOG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 13:14:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406231AbhALSMi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 13:12:38 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C61C061344
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 10:11:21 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id 33so2158562pgv.0
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 10:11:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=weYuAzHiKmuI5kx/0dPz0XMIF8zLAlYQHLKS7oXdpNI=;
        b=LyiTsCYxm1PQhsdCDlJG0ixdReyEi3wVVCEj5VPqU5LFhcbiaVSyogHEmZi+JAzqAV
         hqAI50dZ9VxGt8CbLZaz6CX9o9l60nqxHPp7bhDpjcd6qS3cvsz+IsiVvkYqGRXODRky
         YoSFIPgh0IIZPipsc/Ml5qe1FjsOV9espjt4ZPq2VuIMOz+HtCj9fj/cOZ+iWeOifC8m
         xk7Vq/U9kNG45GLKs6AebAu44lYkqpylwVfR/IXyC7pzimJcCwYqt6CKdwAn8owaOPqU
         82VAdYAvM8Tmh5CIKSszhOsyh7LfWaLNayuh/82EkIkAbUZ6Xfea9P05Y7Z8rC5+lu6z
         THIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=weYuAzHiKmuI5kx/0dPz0XMIF8zLAlYQHLKS7oXdpNI=;
        b=oR2BMia6ACJCX8iR0KI6/p9rj61lk/lobmwO/9TzknZ+TvbUowMhJ6JPiuTufPEKga
         69Cvnb9vUrDLvFjdaSpDDgcZjatjtxROY1U8lj/0hrwrbUXtUdzCkcbMEdEJZEg/a8+s
         J54uPWDO7V5xUWb4GC10HtxxWiX/Immpam84EKhOOW1bMYhfDrc3k+fE+1UFgQqh3gSJ
         9EUwcDG2u6wzqkhVSksFbhOvPtJT/qv2MX1t5uZflMfbAy9MOCNzP1Q8K2r0kASzB3QS
         ToFG403ReoXEX0nnNVAiAFqP8PkydjGw7M8Osd+S9CxO7SsGSIJnctNHL0TqZCXVTMvy
         /YIw==
X-Gm-Message-State: AOAM532+vkSk/EcDkJLzPGWa//t1pbQ++tj0IMIgsYG6aoj+cHPU4Dh2
        OWTT7yWYHH/EHr2L1GP7ZzIwvfIBQV1c
X-Google-Smtp-Source: ABdhPJzXcA/BDbM8k8s2YwSAeag6O4e2HhzU8tM/6UDUIcpNDCme8y8mPYUq+1bGJv+VCTffQZqlBYOrHYnL
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:aa7:9357:0:b029:1a5:43da:b90d with SMTP id
 23-20020aa793570000b02901a543dab90dmr484505pfn.54.1610475081090; Tue, 12 Jan
 2021 10:11:21 -0800 (PST)
Date:   Tue, 12 Jan 2021 10:10:37 -0800
In-Reply-To: <20210112181041.356734-1-bgardon@google.com>
Message-Id: <20210112181041.356734-21-bgardon@google.com>
Mime-Version: 1.0
References: <20210112181041.356734-1-bgardon@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH 20/24] kvm: x86/mmu: Add atomic option for setting SPTEs
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to allow multiple TDP MMU operations to proceed in parallel,
there must be an option to modify SPTEs atomically so that changes are
not lost. Add that option to __tdp_mmu_set_spte and
__handle_changed_spte.

Reviewed-by: Peter Feiner <pfeiner@google.com>

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 67 ++++++++++++++++++++++++++++++++------
 1 file changed, 57 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 264594947c3b..1380ed313476 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -7,6 +7,7 @@
 #include "tdp_mmu.h"
 #include "spte.h"
 
+#include <asm/cmpxchg.h>
 #include <trace/events/kvm.h>
 
 #ifdef CONFIG_X86_64
@@ -226,7 +227,8 @@ static void tdp_mmu_free_sp_rcu_callback(struct rcu_head *head)
 }
 
 static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
-				u64 old_spte, u64 new_spte, int level);
+				u64 old_spte, u64 new_spte, int level,
+				bool atomic);
 
 static int kvm_mmu_page_as_id(struct kvm_mmu_page *sp)
 {
@@ -320,15 +322,19 @@ static void tdp_mmu_unlink_page(struct kvm *kvm, struct kvm_mmu_page *sp,
  *
  * @kvm: kvm instance
  * @pt: the page removed from the paging structure
+ * @atomic: Use atomic operations to clear the SPTEs in any disconnected
+ *	    pages of memory.
  *
  * Given a page table that has been removed from the TDP paging structure,
  * iterates through the page table to clear SPTEs and free child page tables.
  */
-static void handle_disconnected_tdp_mmu_page(struct kvm *kvm, u64 *pt)
+static void handle_disconnected_tdp_mmu_page(struct kvm *kvm, u64 *pt,
+					     bool atomic)
 {
 	struct kvm_mmu_page *sp;
 	gfn_t gfn;
 	int level;
+	u64 *sptep;
 	u64 old_child_spte;
 	int i;
 
@@ -341,11 +347,17 @@ static void handle_disconnected_tdp_mmu_page(struct kvm *kvm, u64 *pt)
 	tdp_mmu_unlink_page(kvm, sp, atomic);
 
 	for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
-		old_child_spte = READ_ONCE(*(pt + i));
-		WRITE_ONCE(*(pt + i), 0);
+		sptep = pt + i;
+
+		if (atomic) {
+			old_child_spte = xchg(sptep, 0);
+		} else {
+			old_child_spte = READ_ONCE(*sptep);
+			WRITE_ONCE(*sptep, 0);
+		}
 		handle_changed_spte(kvm, kvm_mmu_page_as_id(sp),
 			gfn + (i * KVM_PAGES_PER_HPAGE(level - 1)),
-			old_child_spte, 0, level - 1);
+			old_child_spte, 0, level - 1, atomic);
 	}
 
 	kvm_flush_remote_tlbs_with_address(kvm, gfn,
@@ -362,12 +374,15 @@ static void handle_disconnected_tdp_mmu_page(struct kvm *kvm, u64 *pt)
  * @old_spte: The value of the SPTE before the change
  * @new_spte: The value of the SPTE after the change
  * @level: the level of the PT the SPTE is part of in the paging structure
+ * @atomic: Use atomic operations to clear the SPTEs in any disconnected
+ *	    pages of memory.
  *
  * Handle bookkeeping that might result from the modification of a SPTE.
  * This function must be called for all TDP SPTE modifications.
  */
 static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
-				u64 old_spte, u64 new_spte, int level)
+				  u64 old_spte, u64 new_spte, int level,
+				  bool atomic)
 {
 	bool was_present = is_shadow_present_pte(old_spte);
 	bool is_present = is_shadow_present_pte(new_spte);
@@ -439,18 +454,50 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	 */
 	if (was_present && !was_leaf && (pfn_changed || !is_present))
 		handle_disconnected_tdp_mmu_page(kvm,
-				spte_to_child_pt(old_spte, level));
+				spte_to_child_pt(old_spte, level), atomic);
 }
 
 static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
-				u64 old_spte, u64 new_spte, int level)
+				u64 old_spte, u64 new_spte, int level,
+				bool atomic)
 {
-	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level);
+	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level,
+			      atomic);
 	handle_changed_spte_acc_track(old_spte, new_spte, level);
 	handle_changed_spte_dirty_log(kvm, as_id, gfn, old_spte,
 				      new_spte, level);
 }
 
+/*
+ * tdp_mmu_set_spte_atomic - Set a TDP MMU SPTE atomically and handle the
+ * associated bookkeeping
+ *
+ * @kvm: kvm instance
+ * @iter: a tdp_iter instance currently on the SPTE that should be set
+ * @new_spte: The value the SPTE should be set to
+ * Returns: true if the SPTE was set, false if it was not. If false is returned,
+ *	    this function will have no side-effects.
+ */
+static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
+					   struct tdp_iter *iter,
+					   u64 new_spte)
+{
+	u64 *root_pt = tdp_iter_root_pt(iter);
+	struct kvm_mmu_page *root = sptep_to_sp(root_pt);
+	int as_id = kvm_mmu_page_as_id(root);
+
+	kvm_mmu_lock_assert_held_shared(kvm);
+
+	if (cmpxchg64(iter->sptep, iter->old_spte, new_spte) != iter->old_spte)
+		return false;
+
+	handle_changed_spte(kvm, as_id, iter->gfn, iter->old_spte, new_spte,
+			    iter->level, true);
+
+	return true;
+}
+
+
 /*
  * __tdp_mmu_set_spte - Set a TDP MMU SPTE and handle the associated bookkeeping
  * @kvm: kvm instance
@@ -480,7 +527,7 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 	WRITE_ONCE(*iter->sptep, new_spte);
 
 	__handle_changed_spte(kvm, as_id, iter->gfn, iter->old_spte, new_spte,
-			      iter->level);
+			      iter->level, false);
 	if (record_acc_track)
 		handle_changed_spte_acc_track(iter->old_spte, new_spte,
 					      iter->level);
-- 
2.30.0.284.gd98b1dd5eaa7-goog

