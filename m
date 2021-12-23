Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0AAD47E969
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 23:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350681AbhLWWZt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 17:25:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234802AbhLWWYZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Dec 2021 17:24:25 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E89C061756
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:24:09 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id k21-20020a63f015000000b0033db7baf101so3863997pgh.19
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:24:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=0Ar+ik+Ixb7U4ZRrfqeBX6o/I8VZg+05g6JXxnNr4p4=;
        b=IJcs/ufo8XgwOG4jI9SZNlx2jrySMJYLnDwA/R8TIzelevXdK9hGKU3Wwvvo/IOCcT
         RvEtBugx65J+sCoFGlfntiS6TVXrI8QSeIYmWaKhaR1a4KR/z8H1N+S9KlEDbHhl8s2X
         +IGa1+0xtTlkg8ktrycfXGjU0CY7lG/zzRT42safJcYlOW2PfGR4HWGDkvNQ4rk0De/e
         eW85D1R0v+gkHObhkVwnFsPqO6kUeasl+yxTjEPKNAtMjTkklDUegArPRP9wse2gojKq
         hhRgcJSUKlqoTE4mpnprqT0Tb812N/cStq2TabVQmyWHLaCCL7EJGan+CcoXOPrJGGQp
         UdoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=0Ar+ik+Ixb7U4ZRrfqeBX6o/I8VZg+05g6JXxnNr4p4=;
        b=AvAcz2A1v63fXonqAlv43jgo/lvT8CbWI892YiR5cDtZH0YYAknGl1sR5yc9CQG8Jb
         Ej22CCvzIxXfXqF3al04zGld94XKMiUbbZr58//8D0/D1L5dOmzSSZAGQFcnM7pPWYTh
         YOqeoIZ3vbo/cQ/kEUCy8uO6QclmIOhiIvqnsrfQvxr6d1hQcO1t/V8tkbu4zoML7ax/
         GgrUG/lepoYgrpWvVQ06kfCYuDkdqmW3zZxImW13KdTsavAzi0jojFXiBjCVQf6xeEsh
         bb3plPNTFAJlWVSFlpEpEohzgDjOanB8/4xQiXseAvHK4g9KMFh5LtypY57ahbDPrsbj
         n0tg==
X-Gm-Message-State: AOAM532g6CzaZ63NiV8m9DLTIJByIede4lfKAUmuK6BLs4nP/RJFh/Ba
        Q1NSrBzuNWiRmt2bqwTVcgePgHItIzo=
X-Google-Smtp-Source: ABdhPJyTYQ0iYmk4z5GT1h5ERJ9qs0AOt2sOEIubClOUu6HpStBFmEirYwwyHs0Xg2PnmsEJU3ouv1Q1upg=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a62:2546:0:b0:4ba:ef4e:c43f with SMTP id
 l67-20020a622546000000b004baef4ec43fmr4152523pfl.57.1640298248807; Thu, 23
 Dec 2021 14:24:08 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 23 Dec 2021 22:23:05 +0000
In-Reply-To: <20211223222318.1039223-1-seanjc@google.com>
Message-Id: <20211223222318.1039223-18-seanjc@google.com>
Mime-Version: 1.0
References: <20211223222318.1039223-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [PATCH v2 17/30] KVM: x86/mmu: Zap only the target TDP MMU shadow
 page in NX recovery
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>
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
index da6166b5c377..be063b6c91b7 100644
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
index 3cdfaf391a49..1de6c1c9ff7b 100644
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
index 61596b4a8121..d23c2d42ad60 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -305,12 +305,16 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
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
@@ -745,6 +749,26 @@ static inline bool __must_check tdp_mmu_iter_cond_resched(struct kvm *kvm,
 	return iter->yielded;
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
@@ -1041,7 +1065,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 						     !shadow_accessed_mask);
 
 			if (tdp_mmu_set_spte_atomic(vcpu->kvm, &iter, new_spte)) {
-				tdp_mmu_link_page(vcpu->kvm, sp,
+				tdp_mmu_link_page(vcpu->kvm, sp, iter.sptep,
 						  fault->huge_page_disallowed &&
 						  fault->req_level >= iter.level);
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 6b9bdd652bca..ccb12f1914ba 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -22,24 +22,8 @@ static inline bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id,
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
 void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm);
 void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm);
-- 
2.34.1.448.ga2b2bfdf31-goog

