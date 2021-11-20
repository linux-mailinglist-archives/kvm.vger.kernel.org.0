Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5684C457B83
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 05:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237168AbhKTEzm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 23:55:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237003AbhKTEyq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 23:54:46 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86CEAC0613BE
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:51:24 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id a16-20020a17090aa51000b001a78699acceso7781482pjq.8
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:51:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=gmb9iqM6TQtffVUwK+PAaeKM8snKM4LPmLp96MJkI9Y=;
        b=ZUIKgr4atayA3IiGbzhuQh8hykZcOLuryQ9Guw3+KgmYWeqBwS5F7GEpiPuRd1owYR
         ZU610lrQ+bCWQNGdIcJIe6Po6H/pyp/CRU8YVCHqcFmzR9pX1RKuz/u3bdKGjHf45uFO
         L+gyh4Buo7YrQo+ZBB1uExk8/Q4xYrlpbE8pqHAaXR5U9fqFai1WGkxX18qaVAbTs341
         oPwQBDNoMjk6dIBZfFU+twKhvMTOqwjXtQ4O/tDfTqxnVdx0kVvEe7HCOl4qIoIXGTNt
         rXRSGVqSu0fHJcMXT3RoUHO6d5TmGeZ0IM8tH9KJMdIwQoM8kOS5FmydebjM50Ccv17z
         Ok2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=gmb9iqM6TQtffVUwK+PAaeKM8snKM4LPmLp96MJkI9Y=;
        b=3MOL4A3y4wkPoHOXeq9OKx6PTRpwY7idZDq4n8Vy2tpc/E4dpEzlEgsUsPkjhrte76
         dXQFi68xiFIYRUxW4M9bwpZTFEQ2vgkORoL3JDf9e4M0hFFpWnzJjl88gCu19iScYgOU
         KcFMF1gSUkDh+ltEYZsNMAUUWD2KqNEgvYf1AH5a2AG2dCw3vkjUSfxsP0I6+yIQFizm
         D0hJsoziHVifZRBSdeJT1xqGIy1iXCRMN02CfnG7wncUpxmUhMfeOPhoN7mwinJCMNFt
         oci01i0mEwC3K4/+wcy8bBaQMcw75GIQzh3DQKcBK1PDsdeaxZSCJyd1qJEibPxI4TJl
         uRfw==
X-Gm-Message-State: AOAM532qSrMelDun9NII8qR2nhmuyUQh9HnOkMEcHqEy96rV6RfI9mvL
        xxsiBfUCE/hab1L0eTIUj64/JAjVPV4=
X-Google-Smtp-Source: ABdhPJwPyad1HncAl8MWl7zHi5uyd/RUWepCt32iuC7DZSo8bYjqtw6l39eeKoo47cgL6pVSbyRzg5+5RVk=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a62:7a54:0:b0:494:6e78:994b with SMTP id
 v81-20020a627a54000000b004946e78994bmr28256646pfc.5.1637383884084; Fri, 19
 Nov 2021 20:51:24 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 20 Nov 2021 04:50:37 +0000
In-Reply-To: <20211120045046.3940942-1-seanjc@google.com>
Message-Id: <20211120045046.3940942-20-seanjc@google.com>
Mime-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH 19/28] KVM: x86/mmu: Zap only the target TDP MMU shadow page
 in NX recovery
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When recovering a potential hugepage that was shattered for the iTLB
multihit workaround, precisely zap only the target page instead of
iterating over the TDP MMU to find the SP that was passed in.  This will
allow future simplification of zap_gfn_range() by having it zap only
leaf SPTEs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu_internal.h |  7 ++++++-
 arch/x86/kvm/mmu/tdp_iter.h     |  2 --
 arch/x86/kvm/mmu/tdp_mmu.c      | 28 ++++++++++++++++++++++++++--
 arch/x86/kvm/mmu/tdp_mmu.h      | 18 +-----------------
 4 files changed, 33 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 52c6527b1a06..8ede43a826af 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -30,6 +30,8 @@ extern bool dbg;
 #define INVALID_PAE_ROOT	0
 #define IS_VALID_PAE_ROOT(x)	(!!(x))
 
+typedef u64 __rcu *tdp_ptep_t;
+
 struct kvm_mmu_page {
 	/*
 	 * Note, "link" through "spt" fit in a single 64 byte cache line on
@@ -59,7 +61,10 @@ struct kvm_mmu_page {
 		refcount_t tdp_mmu_root_count;
 	};
 	unsigned int unsync_children;
-	struct kvm_rmap_head parent_ptes; /* rmap pointers to parent sptes */
+	union {
+		struct kvm_rmap_head parent_ptes; /* rmap pointers to parent sptes */
+		tdp_ptep_t ptep;
+	};
 	DECLARE_BITMAP(unsync_child_bitmap, 512);
 
 	struct list_head lpage_disallowed_link;
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index 9c04d8677cb3..0693f1fdb81e 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -7,8 +7,6 @@
 
 #include "mmu.h"
 
-typedef u64 __rcu *tdp_ptep_t;
-
 /*
  * TDP MMU SPTEs are RCU protected to allow paging structures (non-leaf SPTEs)
  * to be zapped while holding mmu_lock for read.  Holding RCU isn't required for
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7d354344924d..ea6651e735c2 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -318,12 +318,16 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
  *
  * @kvm: kvm instance
  * @sp: the new page
+ * @sptep: pointer to the new page's SPTE (in its parent)
  * @account_nx: This page replaces a NX large page and should be marked for
  *		eventual reclaim.
  */
 static void tdp_mmu_link_page(struct kvm *kvm, struct kvm_mmu_page *sp,
-			      bool account_nx)
+			      tdp_ptep_t sptep, bool account_nx)
 {
+	WARN_ON_ONCE(sp->ptep);
+	sp->ptep = sptep;
+
 	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
 	list_add(&sp->link, &kvm->arch.tdp_mmu_pages);
 	if (account_nx)
@@ -755,6 +759,26 @@ static inline bool tdp_mmu_iter_cond_resched(struct kvm *kvm,
 	return false;
 }
 
+bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
+{
+	u64 old_spte;
+
+	rcu_read_lock();
+
+	old_spte = kvm_tdp_mmu_read_spte(sp->ptep);
+	if (WARN_ON_ONCE(!is_shadow_present_pte(old_spte))) {
+		rcu_read_unlock();
+		return false;
+	}
+
+	__tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte, 0,
+			   sp->gfn, sp->role.level + 1, true, true);
+
+	rcu_read_unlock();
+
+	return true;
+}
+
 /*
  * Tears down the mappings for the range of gfns, [start, end), and frees the
  * non-root pages mapping GFNs strictly within that range. Returns true if
@@ -1062,7 +1086,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 						     !shadow_accessed_mask);
 
 			if (tdp_mmu_set_spte_atomic(vcpu->kvm, &iter, new_spte)) {
-				tdp_mmu_link_page(vcpu->kvm, sp,
+				tdp_mmu_link_page(vcpu->kvm, sp, iter.sptep,
 						  fault->huge_page_disallowed &&
 						  fault->req_level >= iter.level);
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index ced6d8e47362..8ad1717f4a1d 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -31,24 +31,8 @@ static inline bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id,
 {
 	return __kvm_tdp_mmu_zap_gfn_range(kvm, as_id, start, end, true, flush);
 }
-static inline bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
-{
-	gfn_t end = sp->gfn + KVM_PAGES_PER_HPAGE(sp->role.level + 1);
-
-	/*
-	 * Don't allow yielding, as the caller may have a flush pending.  Note,
-	 * if mmu_lock is held for write, zapping will never yield in this case,
-	 * but explicitly disallow it for safety.  The TDP MMU does not yield
-	 * until it has made forward progress (steps sideways), and when zapping
-	 * a single shadow page that it's guaranteed to see (thus the mmu_lock
-	 * requirement), its "step sideways" will always step beyond the bounds
-	 * of the shadow page's gfn range and stop iterating before yielding.
-	 */
-	lockdep_assert_held_write(&kvm->mmu_lock);
-	return __kvm_tdp_mmu_zap_gfn_range(kvm, kvm_mmu_page_as_id(sp),
-					   sp->gfn, end, false, false);
-}
 
+bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm,
 				      struct list_head *invalidated_roots);
-- 
2.34.0.rc2.393.gf8c9666880-goog

