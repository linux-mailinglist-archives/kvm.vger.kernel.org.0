Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 216524CC634
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 20:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236086AbiCCTk2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 14:40:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236158AbiCCTkV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 14:40:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1C07918FAD1
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 11:39:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646336347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dg+b407c/wjePAneunGPnBZxOmmeea28pGkVl+COpao=;
        b=aGFutl6YQbW0VHPZqN/vO0ikU5K8HxLBubly/wlp1spYt3INftIJw+gDpv6wQ3Z2UK8Zkj
        plZyg8G1k+5Scp/vcQ36FKS+htXw//8BZPTW61xK6FfLspszK7kpPJbiTESwxxO651gflg
        vIg701NuafhD4LBqg0HoL2IncnojicA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-EiISusXzP_mnS-1z2kJvDw-1; Thu, 03 Mar 2022 14:39:02 -0500
X-MC-Unique: EiISusXzP_mnS-1z2kJvDw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 453F71006AA6;
        Thu,  3 Mar 2022 19:39:00 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 71F085DF2E;
        Thu,  3 Mar 2022 19:38:59 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Subject: [PATCH v4 16/30] KVM: x86/mmu: Add dedicated helper to zap TDP MMU root shadow page
Date:   Thu,  3 Mar 2022 14:38:28 -0500
Message-Id: <20220303193842.370645-17-pbonzini@redhat.com>
In-Reply-To: <20220303193842.370645-1-pbonzini@redhat.com>
References: <20220303193842.370645-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Add a dedicated helper for zapping a TDP MMU root, and use it in the three
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
Reviewed-by: Ben Gardon <bgardon@google.com>
Message-Id: <20220226001546.360188-16-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 98 +++++++++++++++++++++++++++++++-------
 1 file changed, 82 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index f59f3ff5cb75..970376297b30 100644
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
@@ -737,6 +736,76 @@ static inline bool __must_check tdp_mmu_iter_cond_resched(struct kvm *kvm,
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
+	for_each_tdp_pte_min_level(iter, root, root->role.level, start, end) {
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
+		} else if (tdp_mmu_set_spte_atomic(kvm, &iter, 0)) {
+			/*
+			 * cmpxchg() shouldn't fail if the root is unreachable.
+			 * Retry so as not to leak the page and its children.
+			 */
+			WARN_ONCE(root_is_unreachable,
+				  "Contended TDP MMU SPTE in unreachable root.");
+			goto retry;
+		}
+
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
@@ -785,8 +854,7 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 			  gfn_t start, gfn_t end, bool can_yield, bool flush,
 			  bool shared)
 {
-	gfn_t max_gfn_host = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
-	bool zap_all = (start == 0 && end >= max_gfn_host);
+	bool zap_all = (start == 0 && end >= tdp_mmu_max_gfn_host());
 	struct tdp_iter iter;
 
 	/*
@@ -795,12 +863,7 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
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
 
@@ -860,6 +923,7 @@ bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
 
 void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 {
+	struct kvm_mmu_page *root;
 	int i;
 
 	/*
@@ -867,8 +931,10 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 	 * is being destroyed or the userspace VMM has exited.  In both cases,
 	 * KVM_RUN is unreachable, i.e. no vCPUs will ever service the request.
 	 */
-	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
-		(void)kvm_tdp_mmu_zap_gfn_range(kvm, i, 0, -1ull, false);
+	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		for_each_tdp_mmu_root_yield_safe(kvm, root, i)
+			tdp_mmu_zap_root(kvm, root, false);
+	}
 }
 
 static struct kvm_mmu_page *next_invalidated_root(struct kvm *kvm,
@@ -925,7 +991,7 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
 		 * will still flush on yield, but that's a minor performance
 		 * blip and not a functional issue.
 		 */
-		(void)zap_gfn_range(kvm, root, 0, -1ull, true, false, true);
+		tdp_mmu_zap_root(kvm, root, true);
 
 		/*
 		 * Put the reference acquired in
-- 
2.31.1


