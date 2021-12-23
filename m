Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8220547E96C
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 23:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350712AbhLWWZy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 17:25:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350742AbhLWWY1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Dec 2021 17:24:27 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0125C061401
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:24:12 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id u21-20020a17090a891500b001b14cf69a22so4232026pjn.2
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:24:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=j7zjELqiKcyIXQzSS76hhwYO0SvmRw+6i72sM7ruJEc=;
        b=ZoC766AfGINLUGXjt38ST4kBuMMelcysWS4PXgZoAKD7GlcQtoqoLW8wlfUmGIxZg8
         oRJwJzg0E+xIpxaWXFufdxBDNU/IfIHwyDQsNTWUTJacNadE7cLUTEXZqvlcnECUZJf7
         NYl6NypBIB9uSh1e6QAW/ZAqOWkjvCM9Ilj2CAb4i3D2ak9I1PECGwstFf+PkaMf9mvv
         ca61Sx8c2gaIR6tkuY3SSBwQHGqYrDPABAuIERrpD25oxvfwg+4uFLext+lBOQQtetyd
         3qGb6zN3HE+z/n0IWvCJt5NGe831LVxKlfpWF0+BdfZ0pIH0KMnz3cOQvCOT2rq9bXnI
         WtDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=j7zjELqiKcyIXQzSS76hhwYO0SvmRw+6i72sM7ruJEc=;
        b=TFC9LRqTE0NuEDSegzRFtt0PAMD5c+J1HwaLd0+/X8KvUFVMbYxiIjS/WHNy2sTMur
         xYyZZRwQjItFBhIEWSRF7x+VulxZDBqU48NOhdFc6/VB6dTmsIvyG+Rh6V+o7xiiS7vp
         30VAmDw3SWtW8ptKl1amQAvwIQkE0qHZcdtVLhQ0qOlAQO0OKP4sTs9X/RmL064fOn9I
         y6ca58bmE7xKVuaSLXzR8gWjvFSsd7GXHzONIv2lcLR/5kqZTzYm3IjKJwpOrpU6rK5V
         rO/y7k3n4rhSPmQmAjEihxisu1hytv+mGxePwXtOWdTrTONCacpbXK/qB+egy0CVPcSa
         NrXg==
X-Gm-Message-State: AOAM530TPUtg06BSY5jmJPkyHDnDMcn1oI//UOX9Zmn847WHeJdSxOgq
        0/KKc/JeHeaDqsxU31DG9DvhZYGzJyo=
X-Google-Smtp-Source: ABdhPJwpuVkvPCVR6sbOFqDkFoBIMP3ReGI+OXovB6sQfYb005odNoXif0w3zQ/6eO1W3gmhZSbp79VEUFU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:82c1:b0:149:5a6d:c59 with SMTP id
 u1-20020a17090282c100b001495a6d0c59mr1585675plz.83.1640298252210; Thu, 23 Dec
 2021 14:24:12 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 23 Dec 2021 22:23:07 +0000
In-Reply-To: <20211223222318.1039223-1-seanjc@google.com>
Message-Id: <20211223222318.1039223-20-seanjc@google.com>
Mime-Version: 1.0
References: <20211223222318.1039223-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [PATCH v2 19/30] KVM: x86/mmu: Add dedicated helper to zap TDP MMU
 root shadow page
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

Add a dedicate helper for zapping a TDP MMU root, and use it in the three
flows that do "zap_all" and intentionally do not do a TLB flush if SPTEs
are zapped (zapping an entire root is safe if and only if it cannot be in
use by any vCPU).  Because a TLB flush is never required, unconditionally
pass "false" to tdp_mmu_iter_cond_resched() when potentially yielding.

Opportunistically document why KVM must not yield when zapping roots that
are being zapped by kvm_tdp_mmu_put_root(), i.e. roots whose refcount has
reached zero, and further harden the flow to detect improper KVM behavior
with respect to roots that are supposed to be unreachable.

In addition to hardening zapping of roots, isolating zapping of roots
will allow future simplification of zap_gfn_range() by having it zap only
leaf SPTEs, and by removing its tricky "zap all" heuristic.  By having
all paths that truly need to free _all_ SPs flow through the dedicated
root zapper, the generic zapper can be freed of those concerns.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 100 +++++++++++++++++++++++++++++++------
 1 file changed, 84 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index e9232ef2194e..c4bfd6aac999 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -56,10 +56,6 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 	rcu_barrier();
 }
 
-static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
-			  gfn_t start, gfn_t end, bool can_yield, bool flush,
-			  bool shared);
-
 static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
 {
 	free_page((unsigned long)sp->spt);
@@ -82,6 +78,9 @@ static void tdp_mmu_free_sp_rcu_callback(struct rcu_head *head)
 	tdp_mmu_free_sp(sp);
 }
 
+static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
+			     bool shared);
+
 void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 			  bool shared)
 {
@@ -104,7 +103,7 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 	 * intermediate paging structures, that may be zapped, as such entries
 	 * are associated with the ASID on both VMX and SVM.
 	 */
-	(void)zap_gfn_range(kvm, root, 0, -1ull, false, false, shared);
+	tdp_mmu_zap_root(kvm, root, shared);
 
 	call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);
 }
@@ -749,6 +748,78 @@ static inline bool __must_check tdp_mmu_iter_cond_resched(struct kvm *kvm,
 	return iter->yielded;
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
+			     bool shared)
+{
+	bool root_is_unreachable = !refcount_read(&root->tdp_mmu_root_count);
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
+		/*
+		 * Yielding isn't allowed when zapping an unreachable root as
+		 * the root won't be processed by mmu_notifier callbacks.  When
+		 * handling an unmap/release mmu_notifier command, KVM must
+		 * drop all references to relevant pages prior to completing
+		 * the callback.  Dropping mmu_lock can result in zapping SPTEs
+		 * for an unreachable root after a relevant callback completes,
+		 * which leads to use-after-free as zapping a SPTE triggers
+		 * "writeback" of dirty/accessed bits to the SPTE's associated
+		 * struct page.
+		 */
+		if (!root_is_unreachable &&
+		    tdp_mmu_iter_cond_resched(kvm, &iter, false, shared))
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
@@ -790,8 +861,7 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 			  gfn_t start, gfn_t end, bool can_yield, bool flush,
 			  bool shared)
 {
-	gfn_t max_gfn_host = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
-	bool zap_all = (start == 0 && end >= max_gfn_host);
+	bool zap_all = (start == 0 && end >= tdp_mmu_max_gfn_host());
 	struct tdp_iter iter;
 
 	/*
@@ -800,12 +870,7 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
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
 
@@ -871,6 +936,7 @@ bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
 
 void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 {
+	struct kvm_mmu_page *root;
 	int i;
 
 	/*
@@ -878,8 +944,10 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 	 * is being destroyed or the userspace VMM has exited.  In both cases,
 	 * KVM_RUN is unreachable, i.e. no vCPUs will ever service the request.
 	 */
-	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
-		(void)kvm_tdp_mmu_zap_gfn_range(kvm, i, 0, -1ull, false);
+	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		for_each_tdp_mmu_root_yield_safe(kvm, root, i, false)
+			tdp_mmu_zap_root(kvm, root, false);
+	}
 }
 
 /*
@@ -905,7 +973,7 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
 		 * will still flush on yield, but that's a minor performance
 		 * blip and not a functional issue.
 		 */
-		(void)zap_gfn_range(kvm, root, 0, -1ull, true, false, true);
+		tdp_mmu_zap_root(kvm, root, true);
 
 		/*
 		 * Put the reference acquired in kvm_tdp_mmu_invalidate_roots().
-- 
2.34.1.448.ga2b2bfdf31-goog

