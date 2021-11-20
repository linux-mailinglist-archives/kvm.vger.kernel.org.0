Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 887F9457B81
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 05:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237099AbhKTEzk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 23:55:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237125AbhKTEyz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 23:54:55 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5C00C061374
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:51:33 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id n22-20020a6563d6000000b0029261ffde9bso5036607pgv.22
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:51:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=42DaXauIdpG24pcjChNOUF7qlaJ5Uil0BKQ1MDhNlyA=;
        b=D+fOhZ1plVeLB1Jn6c6lApr95baPGWraXVaZAV1+lnJi8MvcCVMy+cKsjgiIwNMe9y
         D4CGX4aMLbamoYAJCIhv77nAYrOAl3cpeG6DYWr8em/SCBNA4wYXfd191fqalF2yOZdW
         7H+VEKPxdnDbHljrZlinxhk0hu+fNYgJ7BXdbw52U5yMZCHC3fVSlLh2jVyrJwwOTV/s
         qtJbBT4Wyh0P3FPKPnp3GckG88NMDG3w1yenBbBlX83jCW3Efy8CsWYoQkVOH3jLT7oz
         8HACCs+XfZ0nfvWBpEJuk3rdwhN8aVzBXNdpRuo1cjvmPWQCQd4ublpjDuexSMNE19NF
         OOBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=42DaXauIdpG24pcjChNOUF7qlaJ5Uil0BKQ1MDhNlyA=;
        b=p1HNDoyaucSLWA5mlg09tNJyCKew1FMivMCf9rMXNf9zINVKbNbLTPRmkB2LPPIkgl
         W/8Ln9h5Hvdxbi+kYRRE/EsUNP9G7vbFHbnBHXM7zEhq23U0isppHKglUb1tw/VZDnc1
         xeTzGJY0LiWXxyd7YwIyes5Nxg1N7a4qi2it3TXMpJV6+ACDDamFOhkxKv+kvJUD2uO6
         UtmmyQI3FGMOgiLuVckBDauqdJkyPMMYTDZC0eV0ETOdyvBW4bG3K7yAJvWzTmKSFSVl
         wfiTjgPcCPikxMz3HAWYZtK3WfT+eQy1HQqThFwhhb0+4lOcgvDSDkBsIyIgSqdbJd50
         qmYQ==
X-Gm-Message-State: AOAM533JE8ti+MkZCYsNLBekMgla+zJAYVsMeiDomxpoQLh31IqwiRJG
        JRM6Mj9dTxsNoL7leI17cQ6Q6XrQiIw=
X-Google-Smtp-Source: ABdhPJzSX92uv0u4Wjus30slzU6I553I+FR99wA5VBW5EKYkoMPh9GsWrGG2jKBO068qywz8W3mO5nk8p+8=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4d8c:: with SMTP id
 oj12mr6762630pjb.100.1637383893300; Fri, 19 Nov 2021 20:51:33 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 20 Nov 2021 04:50:43 +0000
In-Reply-To: <20211120045046.3940942-1-seanjc@google.com>
Message-Id: <20211120045046.3940942-26-seanjc@google.com>
Mime-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH 25/28] KVM: x86/mmu: Require mmu_lock be held for write to zap
 TDP MMU range
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
---
 arch/x86/kvm/mmu/tdp_mmu.c | 29 ++++++-----------------------
 1 file changed, 6 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 0e5a0d40e54a..926e92473e92 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -844,15 +844,9 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
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
@@ -865,15 +859,14 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
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
@@ -892,17 +885,8 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
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
@@ -921,8 +905,7 @@ bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
 	struct kvm_mmu_page *root;
 
 	for_each_tdp_mmu_root_yield_safe(kvm, root, as_id, false)
-		flush = zap_gfn_range(kvm, root, start, end, can_yield, flush,
-				      false);
+		flush = zap_gfn_range(kvm, root, start, end, can_yield, flush);
 
 	return flush;
 }
-- 
2.34.0.rc2.393.gf8c9666880-goog

