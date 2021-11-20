Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1139457B76
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 05:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237436AbhKTEzO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 23:55:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237123AbhKTEyz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 23:54:55 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67FD2C061375
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:51:35 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id p13-20020a63c14d000000b002da483902b1so5048171pgi.12
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:51:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=XMCAjExlQAxuAyQnJrnUESA+pU01ySIknUDVI3iplPg=;
        b=JAh8zLein7IFaIs0p47zlTEMrlssV3eGJjaMh3ZuocIJXfKEjEoUQZKLvp+SZ0gpmj
         3caw8+Uflc7ZML3fA/VisbGSEtVBcYgSOGJLBpJZRUL3g87sJ8L1W9uwu58niJNqMYir
         NAcbfFGfo4sVxsHTf4cvdl21feDxjsyJDKRjSXNfdBoQSkPD+JTqKr4rWg76M5TrOJO4
         xe3JWPlO4ZFQ+VRchBH154TWvg9VcZgEsEloBVlbJN1uoZ6a9ACspJ+IYtA57+OfYmk4
         +gqwMJCPNJpA17c1Ltqxj0A3su79UWaE0885vr+Dw2ANO6CaxcaFeR3jcfW1vEFLOKKd
         rfzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=XMCAjExlQAxuAyQnJrnUESA+pU01ySIknUDVI3iplPg=;
        b=avA0kgXPHHvdn+cdYKw478tZpVHQA2w76f70ePF+YY3QtuT7Yb7+cruNOBSeHyX6QS
         ck1V2AQ67tVttklPY5atipKS0bmIF0aSyhJi9L9qistCz8C3bC6wu9kSluO2ROnYrrLP
         B07hkizLFtDMzdjnrhAgREejL0lDB8P4F4w1uiWv/cVYAtl+OBjg1SApt1441ohLUoOh
         j+7t1AhIACtEZ2EzdMIT8xojXwC6SL/b3NoB/XZOCT2XMUnimQYJUotZnZLDWcuh2a3g
         V8lJ0okEE4H5Thw5oom2XswZwjBetVfrwDt6+uJ3D/gMRID8bd356S2cnUnRJOYlEHJi
         iGog==
X-Gm-Message-State: AOAM5306WVEqSJqdvMWjxtdtwNsm7V7ANSL1fdw+8odDeReyiJ3BySO4
        K0RvIiU3gOPBPAeDbnOqkZpiBTSqavw=
X-Google-Smtp-Source: ABdhPJxl01w0A1eKfmxsVUo9nyACoXWy78Y2/pldR20QNAs3o4rB3GtX/Vad2kib0Ld1ItCg3WSNv3lBI7E=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:284f:: with SMTP id
 p15mr729880pjf.1.1637383894641; Fri, 19 Nov 2021 20:51:34 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 20 Nov 2021 04:50:44 +0000
In-Reply-To: <20211120045046.3940942-1-seanjc@google.com>
Message-Id: <20211120045046.3940942-27-seanjc@google.com>
Mime-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH 26/28] KVM: x86/mmu: Zap only TDP MMU leafs in kvm_zap_gfn_range()
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

Zap only leaf SPTEs in the TDP MMU's zap_gfn_range(), and rename various
functions according.  When removing mappings for functional correctness
(except for the stupid VFIO GPU passthrough memslots bug), zapping the
leaf SPTEs is sufficient as the paging structures themselves do not point
at guest memory and do not directly impact the final translation (in the
TDP MMU).

Note, this aligns the TDP MMU with the legacy/full MMU, which zaps only
the rmaps, a.k.a. leaf SPTEs, in kvm_zap_gfn_range() and
kvm_unmap_gfn_range().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c     |  4 ++--
 arch/x86/kvm/mmu/tdp_mmu.c | 41 ++++++++++----------------------------
 arch/x86/kvm/mmu/tdp_mmu.h |  8 +-------
 3 files changed, 14 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e3cd330c9532..ef689b8bab12 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5796,8 +5796,8 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 
 	if (is_tdp_mmu_enabled(kvm)) {
 		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
-			flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, gfn_start,
-							  gfn_end, flush);
+			flush = kvm_tdp_mmu_zap_leafs(kvm, i, gfn_start,
+						      gfn_end, true, flush);
 	}
 
 	if (flush)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 926e92473e92..79a52717916c 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -834,10 +834,8 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 }
 
 /*
- * Tears down the mappings for the range of gfns, [start, end), and frees the
- * non-root pages mapping GFNs strictly within that range. Returns true if
- * SPTEs have been cleared and a TLB flush is needed before releasing the
- * MMU lock.
+ * Zap leafs SPTEs for the range of gfns, [start, end). Returns true if SPTEs
+ * have been cleared and a TLB flush is needed before releasing the MMU lock.
  *
  * If can_yield is true, will release the MMU lock and reschedule if the
  * scheduler needs the CPU or there is contention on the MMU lock. If this
@@ -845,18 +843,11 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
  * the caller must ensure it does not supply too large a GFN range, or the
  * operation can cause a soft lockup.
  */
-static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
-			  gfn_t start, gfn_t end, bool can_yield, bool flush)
+static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
+			      gfn_t start, gfn_t end, bool can_yield, bool flush)
 {
-	bool zap_all = (start == 0 && end >= tdp_mmu_max_gfn_host());
 	struct tdp_iter iter;
 
-	/*
-	 * No need to try to step down in the iterator when zapping all SPTEs,
-	 * zapping the top-level non-leaf SPTEs will recurse on their children.
-	 */
-	int min_level = zap_all ? root->role.level : PG_LEVEL_4K;
-
 	end = min(end, tdp_mmu_max_gfn_host());
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
@@ -864,24 +855,14 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 	rcu_read_lock();
 
 	for_each_tdp_pte_min_level(iter, root->spt, root->role.level,
-				   min_level, start, end) {
+				   PG_LEVEL_4K, start, end) {
 		if (can_yield &&
 		    tdp_mmu_iter_cond_resched(kvm, &iter, flush, false)) {
 			flush = false;
 			continue;
 		}
 
-		if (!is_shadow_present_pte(iter.old_spte))
-			continue;
-
-		/*
-		 * If this is a non-last-level SPTE that covers a larger range
-		 * than should be zapped, continue, and zap the mappings at a
-		 * lower level, except when zapping all SPTEs.
-		 */
-		if (!zap_all &&
-		    (iter.gfn < start ||
-		     iter.gfn + KVM_PAGES_PER_HPAGE(iter.level) > end) &&
+		if (!is_shadow_present_pte(iter.old_spte) ||
 		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
 
@@ -899,13 +880,13 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
  * SPTEs have been cleared and a TLB flush is needed before releasing the
  * MMU lock.
  */
-bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
-				 gfn_t end, bool can_yield, bool flush)
+bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start, gfn_t end,
+			   bool can_yield, bool flush)
 {
 	struct kvm_mmu_page *root;
 
 	for_each_tdp_mmu_root_yield_safe(kvm, root, as_id, false)
-		flush = zap_gfn_range(kvm, root, start, end, can_yield, flush);
+		flush = tdp_mmu_zap_leafs(kvm, root, start, end, can_yield, false);
 
 	return flush;
 }
@@ -1147,8 +1128,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
 				 bool flush)
 {
-	return __kvm_tdp_mmu_zap_gfn_range(kvm, range->slot->as_id, range->start,
-					   range->end, range->may_block, flush);
+	return kvm_tdp_mmu_zap_leafs(kvm, range->slot->as_id, range->start,
+				     range->end, range->may_block, flush);
 }
 
 typedef bool (*tdp_handler_t)(struct kvm *kvm, struct tdp_iter *iter,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 8ad1717f4a1d..6e7c32170608 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -24,14 +24,8 @@ __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
 void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 			  bool shared);
 
-bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
+bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start,
 				 gfn_t end, bool can_yield, bool flush);
-static inline bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id,
-					     gfn_t start, gfn_t end, bool flush)
-{
-	return __kvm_tdp_mmu_zap_gfn_range(kvm, as_id, start, end, true, flush);
-}
-
 bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm,
-- 
2.34.0.rc2.393.gf8c9666880-goog

