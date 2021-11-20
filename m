Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3461D457B71
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 05:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237326AbhKTEzI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 23:55:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237056AbhKTEyr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 23:54:47 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37DA1C06175B
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:51:32 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id y18-20020a634952000000b002ecc060ccc8so5039669pgk.17
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:51:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=R+xR4dB0SrLQ0VZ58WtR4G/GrCBgMyNN0nCF2HPw2dQ=;
        b=gqpwn9pHZ4g6pYG6AVhQgiMnMPsZYNvSumH5PXHxAnXkNyz1W/zdHPhHGDMVw5L3Yq
         xZ37Nbs9mIUxaAPPkTJQwhNgwHUBud2F6SqiU/dvsc5mc8EV+FTPUKQVyN4RK59u3Epp
         NLYwFua5cWir9VPaGFxXpwsttMQzCYUcxAkPY20UBeYFdJO99f5MyE4zcOIzvT0yW3k4
         ITt+PYVGyjgaAW9h48riXG20gRDaXzmKxa9VgHNt4A+tSk3Tb/OrLEkD8rIt4Eup7GRt
         qhd31eoGjNeBAUTd1q6tKbKl4JnUFWzI8RfDER0KYXAc8wQqso5YTA96N2Y2id/HYkWr
         rYLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=R+xR4dB0SrLQ0VZ58WtR4G/GrCBgMyNN0nCF2HPw2dQ=;
        b=EUnvlltpXhMzNj7kaM1r/oz1f2+cO9tVk3woXp496svJ9+uD2wtFbpyxIpvZfsmQ3k
         u5XznyfBHfv+dh5av9l6DAsaw2OuuFLtZfHZ3hrP6C/jJ6R83dGuDlM5wkmKlq1a7KHo
         9Xj9ahgyxiBmKvpLibQibtmGj+wvtVYdyVC3TVw1tqlHUENQuM+TU44RO7rZGydKbpcK
         o6KZzMHlkIZroL9Dl5yN658u+p6yiBbfUOLMuZe4enU0zZJ4zd6FPufiAnjcnUTnP5oj
         4u/Q0J3mVerDizspyK2gMQ5Q5M2Ydn4+6G88iB/cAHvoKQThXFh9482Wf1cqdU7U1IrP
         3tBQ==
X-Gm-Message-State: AOAM530suvY5QK7F1JSspfRmoG9K6x2liuTz5wfrV5pXj/AqgmsmHZTW
        YVr826OMMkPeErNCv2/XL+UiYQcHOYE=
X-Google-Smtp-Source: ABdhPJwAIdWUnoyg5YlFXfq3C5DtwOTUQUvthPWJR7bALAzMo8ocjw4EHasvxXQ2gykdnPILEPB6EATB5Gk=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1344:b0:49f:f357:ac9 with SMTP id
 k4-20020a056a00134400b0049ff3570ac9mr28234284pfu.62.1637383891775; Fri, 19
 Nov 2021 20:51:31 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 20 Nov 2021 04:50:42 +0000
In-Reply-To: <20211120045046.3940942-1-seanjc@google.com>
Message-Id: <20211120045046.3940942-25-seanjc@google.com>
Mime-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH 24/28] KVM: x86/mmu: Add dedicated helper to zap TDP MMU root
 shadow page
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

Convert tdp_mmu_zap_root() into its own dedicated flow instead of simply
redirecting into zap_gfn_range().  In addition to hardening zapping of
roots, this will allow future simplification of zap_gfn_range() by having
it zap only leaf SPTEs, and by removing its tricky "zap all" heuristic.
By having all paths that truly need to free _all_ SPs flow through the
dedicated root zapper, the generic zapper can be freed of those concerns.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 91 +++++++++++++++++++++++++++-----------
 1 file changed, 66 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 99ea19e763da..0e5a0d40e54a 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -53,10 +53,6 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 	rcu_barrier();
 }
 
-static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
-			  gfn_t start, gfn_t end, bool can_yield, bool flush,
-			  bool shared);
-
 static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
 {
 	free_page((unsigned long)sp->spt);
@@ -79,11 +75,8 @@ static void tdp_mmu_free_sp_rcu_callback(struct rcu_head *head)
 	tdp_mmu_free_sp(sp);
 }
 
-static bool tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
-			     bool shared)
-{
-	return zap_gfn_range(kvm, root, 0, -1ull, true, false, shared);
-}
+static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
+			     bool shared, bool root_is_unreachable);
 
 /*
  * Note, putting a root might sleep, i.e. the caller must have IRQs enabled and
@@ -120,13 +113,8 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 	 * invalidates any paging-structure-cache entries, i.e. TLB entries for
 	 * intermediate paging structures, that may be zapped, as such entries
 	 * are associated with the ASID on both VMX and SVM.
-	 *
-	 * WARN if a flush is reported for an invalid root, as its child SPTEs
-	 * should have been zapped by kvm_tdp_mmu_zap_invalidated_roots(), and
-	 * inserting new SPTEs under an invalid root is a KVM bug.
 	 */
-	if (tdp_mmu_zap_root(kvm, root, shared))
-		WARN_ON_ONCE(root->role.invalid);
+	tdp_mmu_zap_root(kvm, root, shared, true);
 
 	call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);
 }
@@ -766,6 +754,65 @@ static inline bool tdp_mmu_iter_cond_resched(struct kvm *kvm,
 	return false;
 }
 
+static inline gfn_t tdp_mmu_max_gfn_host(void)
+{
+	/*
+	 * Bound TDP MMU walks at host.MAXPHYADDR, guest accesses beyond that
+	 * will hit a #PF(RSVD) and never hit an EPT Violation/Misconfig / #NPF,
+	 * and so KVM will never install a SPTE for such addresses.
+	 */
+	return 1ULL << (shadow_phys_bits - PAGE_SHIFT);
+}
+
+static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
+			     bool shared, bool root_is_unreachable)
+{
+	struct tdp_iter iter;
+
+	gfn_t end = tdp_mmu_max_gfn_host();
+	gfn_t start = 0;
+
+	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
+
+	rcu_read_lock();
+
+	/*
+	 * No need to try to step down in the iterator when zapping an entire
+	 * root, zapping an upper-level SPTE will recurse on its children.
+	 */
+	for_each_tdp_pte_min_level(iter, root->spt, root->role.level,
+				   root->role.level, start, end) {
+retry:
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, shared))
+			continue;
+
+		if (!is_shadow_present_pte(iter.old_spte))
+			continue;
+
+		if (!shared) {
+			tdp_mmu_set_spte(kvm, &iter, 0);
+		} else if (!tdp_mmu_set_spte_atomic(kvm, &iter, 0)) {
+			/*
+			 * cmpxchg() shouldn't fail if the root is unreachable.
+			 * to be unreachable.  Re-read the SPTE and retry so as
+			 * not to leak the page and its children.
+			 */
+			WARN_ONCE(root_is_unreachable,
+				  "Contended TDP MMU SPTE in unreachable root.");
+			iter.old_spte = kvm_tdp_mmu_read_spte(iter.sptep);
+			goto retry;
+		}
+		/*
+		 * WARN if the root is invalid and is unreachable, all SPTEs
+		 * should've been zapped by kvm_tdp_mmu_zap_invalidated_roots(),
+		 * and inserting new SPTEs under an invalid root is a KVM bug.
+		 */
+		WARN_ON_ONCE(root_is_unreachable && root->role.invalid);
+	}
+
+	rcu_read_unlock();
+}
+
 bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	u64 old_spte;
@@ -807,8 +854,7 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 			  gfn_t start, gfn_t end, bool can_yield, bool flush,
 			  bool shared)
 {
-	gfn_t max_gfn_host = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
-	bool zap_all = (start == 0 && end >= max_gfn_host);
+	bool zap_all = (start == 0 && end >= tdp_mmu_max_gfn_host());
 	struct tdp_iter iter;
 
 	/*
@@ -817,12 +863,7 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 	 */
 	int min_level = zap_all ? root->role.level : PG_LEVEL_4K;
 
-	/*
-	 * Bound the walk at host.MAXPHYADDR, guest accesses beyond that will
-	 * hit a #PF(RSVD) and never get to an EPT Violation/Misconfig / #NPF,
-	 * and so KVM will never install a SPTE for such addresses.
-	 */
-	end = min(end, max_gfn_host);
+	end = min(end, tdp_mmu_max_gfn_host());
 
 	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
 
@@ -898,7 +939,7 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 	 */
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
 		for_each_tdp_mmu_root_yield_safe(kvm, root, i, false)
-			(void)tdp_mmu_zap_root(kvm, root, false);
+			tdp_mmu_zap_root(kvm, root, false, true);
 	}
 }
 
@@ -934,7 +975,7 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm,
 		 * will still flush on yield, but that's a minor performance
 		 * blip and not a functional issue.
 		 */
-		(void)tdp_mmu_zap_root(kvm, root, true);
+		tdp_mmu_zap_root(kvm, root, true, false);
 		kvm_tdp_mmu_put_root(kvm, root, true);
 	}
 }
-- 
2.34.0.rc2.393.gf8c9666880-goog

