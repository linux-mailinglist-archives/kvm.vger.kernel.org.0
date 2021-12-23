Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C055247E96F
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 23:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350747AbhLWWZ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 17:25:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350772AbhLWWYc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Dec 2021 17:24:32 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF22AC061374
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:24:14 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id r1-20020a17090a438100b001b1906bd90cso6400904pjg.2
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:24:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=tDGnOGhCcvxTaWavsfwTLmgOIvYC3gf4ygJSFWS9QqU=;
        b=kTOgrcc6BfePm0z+hvCdTFuh79DXEp5GuDndlgpAJVWC9FsuKerF77p60i8Amw364c
         A0YRrVZzYsMnaM4DfzZuKv1bn6YWYQX3XY8gpy3FGp7+sJD9s9ZB6tHTF/1mMVkH0djH
         gFphFTPgEquFo/vSlX88ZbEbCwx+ioHc4R3ur6f3p982PtAJSt7n5fr8/Bd6nv51l8M+
         NUCmo0Eted2NZ54Y8RQMG9ni5K9eeXGrOrYwV0AakuEuQYuK8e/w8T0xKE4JBgRAT8Ee
         P6XL9aI7G9VXbC1/v5QwlPUgp/prj07a2SnR3Yo0iDn9+cr9YaMvA8HiVyDiKR4sq+wj
         +aaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=tDGnOGhCcvxTaWavsfwTLmgOIvYC3gf4ygJSFWS9QqU=;
        b=JrEmtMpitvyoLT+7rR0/TRvpqW62Vwk9jjOesbq9LI7PbJOMwnU5cR0d4Wy2NW+66f
         +uN+Z1nRtbcK5GeZoliuC/sZBNdqFsCE/Gufj5qJEfDDO0K5lmiUH6dSLH1zNust1uX7
         QfoG+DMc6IxxVaPXdOs+UDFwb64Nrvdr1GhwAjafiKfQCX/lsHEBiwyeh+jGe2EnRfTP
         NQbQw6Q7e+ZI9MB1OB7EA+hglq+RtIY+SlC9RAaSEXqNIA2NYjfd7fJFlGlMuEb1LNpv
         jDaqnZ33Y/u4Ijx0hGhXrlPwGebYsFB522BQANdL33F+CV5KWL2XzrQTo1+4OCvgn3Di
         XgBw==
X-Gm-Message-State: AOAM531X5hcbgxXltyfp7eIb5SCXqVyN3hzOR2Sxgw/s32IsbosVk9Tw
        t9Vf9O2R4EQNqLOrqyyhRst5blO32zw=
X-Google-Smtp-Source: ABdhPJynTFDTwq9OPWP3NGC2k4NnBfjNzEbTDYwrQOTcJqWU8FH5hTFzrUrGniBxYNwYQlCQwxy11xHnRYg=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:3d42:: with SMTP id
 o2mr738629pjf.1.1640298253827; Thu, 23 Dec 2021 14:24:13 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 23 Dec 2021 22:23:08 +0000
In-Reply-To: <20211223222318.1039223-1-seanjc@google.com>
Message-Id: <20211223222318.1039223-21-seanjc@google.com>
Mime-Version: 1.0
References: <20211223222318.1039223-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [PATCH v2 20/30] KVM: x86/mmu: Require mmu_lock be held for write to
 zap TDP MMU range
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

Now that all callers of zap_gfn_range() hold mmu_lock for write, drop
support for zapping with mmu_lock held for read.  That all callers hold
mmu_lock for write isn't a random coincedence; now that the paths that
need to zap _everything_ have their own path, the only callers left are
those that need to zap for functional correctness.  And when zapping is
required for functional correctness, mmu_lock must be held for write,
otherwise the caller has no guarantees about the state of the TDP MMU
page tables after it has run, e.g. the SPTE(s) it zapped can be
immediately replaced by a vCPU faulting in a page.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 29 ++++++-----------------------
 1 file changed, 6 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index c4bfd6aac999..c7529de776be 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -851,15 +851,9 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
  * function cannot yield, it will not release the MMU lock or reschedule and
  * the caller must ensure it does not supply too large a GFN range, or the
  * operation can cause a soft lockup.
- *
- * If shared is true, this thread holds the MMU lock in read mode and must
- * account for the possibility that other threads are modifying the paging
- * structures concurrently. If shared is false, this thread should hold the
- * MMU lock in write mode.
  */
 static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
-			  gfn_t start, gfn_t end, bool can_yield, bool flush,
-			  bool shared)
+			  gfn_t start, gfn_t end, bool can_yield, bool flush)
 {
 	bool zap_all = (start == 0 && end >= tdp_mmu_max_gfn_host());
 	struct tdp_iter iter;
@@ -872,15 +866,14 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	end = min(end, tdp_mmu_max_gfn_host());
 
-	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
+	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	rcu_read_lock();
 
 	for_each_tdp_pte_min_level(iter, root->spt, root->role.level,
 				   min_level, start, end) {
-retry:
 		if (can_yield &&
-		    tdp_mmu_iter_cond_resched(kvm, &iter, flush, shared)) {
+		    tdp_mmu_iter_cond_resched(kvm, &iter, flush, false)) {
 			flush = false;
 			continue;
 		}
@@ -899,17 +892,8 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
 
-		if (!shared) {
-			tdp_mmu_set_spte(kvm, &iter, 0);
-			flush = true;
-		} else if (!tdp_mmu_zap_spte_atomic(kvm, &iter)) {
-			/*
-			 * The iter must explicitly re-read the SPTE because
-			 * the atomic cmpxchg failed.
-			 */
-			iter.old_spte = kvm_tdp_mmu_read_spte(iter.sptep);
-			goto retry;
-		}
+		tdp_mmu_set_spte(kvm, &iter, 0);
+		flush = true;
 	}
 
 	rcu_read_unlock();
@@ -928,8 +912,7 @@ bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
 	struct kvm_mmu_page *root;
 
 	for_each_tdp_mmu_root_yield_safe(kvm, root, as_id, false)
-		flush = zap_gfn_range(kvm, root, start, end, can_yield, flush,
-				      false);
+		flush = zap_gfn_range(kvm, root, start, end, can_yield, flush);
 
 	return flush;
 }
-- 
2.34.1.448.ga2b2bfdf31-goog

