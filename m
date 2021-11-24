Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84D4B45CF6A
	for <lists+kvm@lfdr.de>; Wed, 24 Nov 2021 22:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245544AbhKXVrp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 16:47:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244658AbhKXVro (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 16:47:44 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 206F0C061574
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 13:44:34 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id a23-20020a62bd17000000b004a3f6892612so2208398pff.22
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 13:44:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=tLduHLCEhFBJGcWmSSIdFrH+R691pR5vCSBmZR8vuZw=;
        b=CC1gtVLupTA8rueVdjI6wawbrHV3whgvmB7lktq3CbWDlJgYE5Xoh3R3YmR7xG15wY
         WmsDDWVcGDHm30fDQR6mvoYLfD/2RKXmsflI2saH+GKIu4h2hO8CvcOjxa4u9JZnoUQn
         9Jm+ZJPP4tbUfBkUDXd4ivqbi/7paSZRbVabJ25gU5qSQyYyMpbD+HkxuxkhZiUl5aJw
         Gikx1kcdduPjRWpXPSJLYna3Dxpg7+qROiXBxjdB3ASH8l7N0Blc9cLRwz0ss0iTz4xr
         9w46X7fZ77nUOrQFs4lmnFLFg22YxpR9bu/VfAxD99z7g15Uo2MpNuCi0/fQrQZvknBA
         jpGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=tLduHLCEhFBJGcWmSSIdFrH+R691pR5vCSBmZR8vuZw=;
        b=ulWz5LFg9UftW4qgECi0U6vz6gNcnZJr7/4Ul1tZT4KfK5yKi4lF7DzDnMrvDhucxT
         udxwRr6+j8LwGaP3YnJjpipstR/AjW4Js9NgYpdG97IRtQ2qZaybPhqJBW3bMAHt99TA
         tffTkUEM/6Q++LBLSMB4qSQ0Xs7+EAkQF7hgMkAtFEOGcotiE0OWcmzSe9KYTV4mqoXS
         HLEEZJ4RC3yH+ZNxpu8TZiqHCx3PCUmEExKuw1e7Mg0q1WLbvUjjz1FUWKj9ulE5mZ95
         5mx/Pv8McE7ikH4MXBRXT7WiNHlz0PbwBX2AHlJjWAC4l3zstNcMUvKe94ZapodeeISy
         66aw==
X-Gm-Message-State: AOAM532u6eEvzU8FAlIuu89WjR+NyW7Bx/m6XD3mCI1glTnp/iSPJbuK
        y6LhW3M3YTqZtkPvaf0q0BJUgV/PKEmZ
X-Google-Smtp-Source: ABdhPJxAwhAbOfBn4cRf5CvmBdeRB86tn3Jv7VCI4xG5hdBCs5xuCb6jf2Bd1OteJPkMhIlOQgc+e6g558TL
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a05:6a00:15c7:b0:49f:f48b:f96e with SMTP
 id o7-20020a056a0015c700b0049ff48bf96emr9491719pfu.65.1637790273655; Wed, 24
 Nov 2021 13:44:33 -0800 (PST)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Wed, 24 Nov 2021 21:44:21 +0000
In-Reply-To: <20211124214421.458549-1-mizhang@google.com>
Message-Id: <20211124214421.458549-3-mizhang@google.com>
Mime-Version: 1.0
References: <20211124214421.458549-1-mizhang@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH 2/2] KVM: mmu/x86: optimize zapping by retaining non-leaf
 SPTEs and avoid rcu stall
From:   Mingwei Zhang <mizhang@google.com>
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

TDP MMU SPTE zapping process currently uses two levels of iterations. The
first level iteration happens at the for loop within the zap_gfn_range()
with the purpose of calibrating the accurate range for zapping. The second
level itreration start at tdp_mmu_set_spte{,_atomic}() that tears down the
whole paging structures (leaf and non-leaf SPTEs) within the range. The
former iteration is yield safe, while the second one is not.

In many cases, zapping SPTE process could be optimized since the non-leaf
SPTEs could most likely be retained for the next allocation. On the other
hand, for large scale SPTE zapping scenarios, we may end up zapping too
many SPTEs and use excessive CPU time that causes the RCU stall warning.

The follow selftest reproduces the warning:

	(env: kvm.tdp_mmu=Y)
	./dirty_log_perf_test -v 64 -b 8G

Optimize the zapping process by skipping all SPTEs above a certain level in
the first iteration. This allows us to control the granularity of the
actual zapping and invoke tdp_mmu_iter_cond_resched() on time. In addition,
we would retain some of the non-leaf SPTEs to accelerate next allocation.

For the selection of the `certain level`, we choose the PG_LEVEL_1G because
it is currently the largest page size supported and it natually fits the
scenario of splitting large pages.

For `zap_all` case (usually) at VM teardown time, we use a two-phase
mechanism: the 1st phase zaps all SPTEs at PG_LEVEL_1G level and 2nd phase
zaps everything else. This is achieved by the helper function
__zap_gfn_range().

Cc: Sean Christopherson <seanjc@google.com>
Cc: Ben Gardon <bgardon@google.com>
Cc: David Matlack <dmatlack@google.com>

Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 57 ++++++++++++++++++++++++++------------
 1 file changed, 40 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 89d16bb104de..3fadc51c004a 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -697,24 +697,16 @@ static inline bool tdp_mmu_iter_cond_resched(struct kvm *kvm,
  * account for the possibility that other threads are modifying the paging
  * structures concurrently. If shared is false, this thread should hold the
  * MMU lock in write mode.
+ *
+ * If zap_all is true, eliminate all the paging structures that contains the
+ * SPTEs.
  */
-static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
-			  gfn_t start, gfn_t end, bool can_yield, bool flush,
-			  bool shared)
+static bool __zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
+			    gfn_t start, gfn_t end, bool can_yield, bool flush,
+			    bool shared, bool zap_all)
 {
-	gfn_t max_gfn_host = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
-	bool zap_all = (start == 0 && end >= max_gfn_host);
 	struct tdp_iter iter;
 
-	/*
-	 * Bound the walk at host.MAXPHYADDR, guest accesses beyond that will
-	 * hit a #PF(RSVD) and never get to an EPT Violation/Misconfig / #NPF,
-	 * and so KVM will never install a SPTE for such addresses.
-	 */
-	end = min(end, max_gfn_host);
-
-	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
-
 	rcu_read_lock();
 
 	tdp_root_for_each_pte(iter, root, start, end) {
@@ -725,17 +717,24 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 			continue;
 		}
 
-		if (!is_shadow_present_pte(iter.old_spte))
+		/*
+		 * In zap_all case, ignore the checking of present since we have
+		 * to zap everything.
+		 */
+		if (!zap_all && !is_shadow_present_pte(iter.old_spte))
 			continue;
 
 		/*
 		 * If this is a non-last-level SPTE that covers a larger range
 		 * than should be zapped, continue, and zap the mappings at a
-		 * lower level, except when zapping all SPTEs.
+		 * lower level. Actual zapping started at proper granularity
+		 * that is not so large as to cause a soft lockup when handling
+		 * the changed pte (which does not yield).
 		 */
 		if (!zap_all &&
 		    (iter.gfn < start ||
-		     iter.gfn + KVM_PAGES_PER_HPAGE(iter.level) > end) &&
+		     iter.gfn + KVM_PAGES_PER_HPAGE(iter.level) > end ||
+		     iter.level > PG_LEVEL_1G) &&
 		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
 
@@ -756,6 +755,30 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 	return flush;
 }
 
+static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
+			  gfn_t start, gfn_t end, bool can_yield, bool flush,
+			  bool shared)
+{
+	gfn_t max_gfn_host = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
+	bool zap_all = (start == 0 && end >= max_gfn_host);
+
+	/*
+	 * Bound the walk at host.MAXPHYADDR, guest accesses beyond that will
+	 * hit a #PF(RSVD) and never get to an EPT Violation/Misconfig / #NPF,
+	 * and so KVM will never install a SPTE for such addresses.
+	 */
+	end = min(end, max_gfn_host);
+
+	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
+
+	flush = __zap_gfn_range(kvm, root, start, end, can_yield, flush, shared,
+				false);
+	if (zap_all)
+		flush = __zap_gfn_range(kvm, root, start, end, can_yield, flush,
+					shared, true);
+	return flush;
+}
+
 /*
  * Tears down the mappings for the range of gfns, [start, end), and frees the
  * non-root pages mapping GFNs strictly within that range. Returns true if
-- 
2.34.0.rc2.393.gf8c9666880-goog

