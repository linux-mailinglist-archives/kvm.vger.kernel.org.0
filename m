Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC8147E952
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 23:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350515AbhLWWX7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 17:23:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350461AbhLWWXy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Dec 2021 17:23:54 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C0AC061401
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:23:52 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id m14-20020a633f0e000000b0033fc903c6a4so3875302pga.12
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:23:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=/C3VB2aYSnMeLUhQSsL7UqIJMPi2v/9JP8zRWM/80L8=;
        b=WuV/B8WuGmqt6FNXhJhidQyLJqByY8R6S4ZMlQAbUXQZQUDMDuSLC68P/xmjUnvDLP
         JnubPJVQiV7ttO7tFrLc5QmqHgHRjPvdci+BrdZN8hQyU2n3Guv4NZpTRrkxrezcs76J
         i7x/qN85MEICBd9nxqSRuv0XSE4PG8tsJD5PMvY3fC1uEt/du6GFEASv4mOlyQJUpj0r
         gZ6BVbSpidgHzxXq/eAud7xsDaiApk5WZXPTm10Gt9gRw0oFd1LTx2asedpN7L2ITwev
         QM0FxO15N98a0sOzrsuJeXqMJvABv/E+QVzGke+etsP8z9sXHOIMBSVQF+lA14rGSZu4
         ko9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=/C3VB2aYSnMeLUhQSsL7UqIJMPi2v/9JP8zRWM/80L8=;
        b=R+T6I3lFrntGm5MCbiXT5Yn/msk8dJF2IhtzOscnVDNscC88GngReukkAkLZOFAk75
         8m3TevQPPQaBNNDdtqsA2hMSY17D0vc4yvxYb/UKi6/tNJUN1PkGlqIlzd1sqH58q5Bx
         FH3ChxSH9JZ+cAZgD0gYj+OUZFdCt6c9D6/29pnP6reHU1EZAeYZBWr+QpVcJq66gYHS
         x6HFE7PUq8B0yQtO6ZVWf8HFGQ9PyLHrNzZSVKHAhf94SzzSGdjcuFVLmrHY5DymaS1O
         ZB7pM0o7FD8MyNVQ64zAqutWkA9zwoYTdOA1DNbZQYthsOUXnzEkiO/oFTd25u0cinG5
         Apcg==
X-Gm-Message-State: AOAM533iY9yams8wrECXPP8PjyWB5BldVO50xsfdSHgalFNK6yJeb7Jc
        eLfoFT67R6K6A5vx1kdj05w41AfP9nw=
X-Google-Smtp-Source: ABdhPJx/W4+wNaHw8WuqGA4G5O9fXG26GZ5qtzGiOo9Q9/SYGQyULfCkHCCJuiCApMAwzTTiAEQ/rD6Mryo=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:aa7:8545:0:b0:4ba:7163:7dfd with SMTP id
 y5-20020aa78545000000b004ba71637dfdmr4278433pfn.61.1640298231685; Thu, 23 Dec
 2021 14:23:51 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 23 Dec 2021 22:22:54 +0000
In-Reply-To: <20211223222318.1039223-1-seanjc@google.com>
Message-Id: <20211223222318.1039223-7-seanjc@google.com>
Mime-Version: 1.0
References: <20211223222318.1039223-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [PATCH v2 06/30] KVM: x86/mmu: Fix wrong/misleading comments in TDP
 MMU fast zap
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

Fix misleading and arguably wrong comments in the TDP MMU's fast zap
flow.  The comments, and the fact that actually zapping invalid roots was
added separately, strongly suggests that zapping invalid roots is an
optimization and not required for correctness.  That is a lie.

KVM _must_ zap invalid roots before returning from kvm_mmu_zap_all_fast(),
because when it's called from kvm_mmu_invalidate_zap_pages_in_memslot(),
KVM is relying on it to fully remove all references to the memslot.  Once
the memslot is gone, KVM's mmu_notifier hooks will be unable to find the
stale references as the hva=>gfn translation is done via the memslots.
If KVM doesn't immediately zap SPTEs and userspace unmaps a range after
deleting a memslot, KVM will fail to zap in response to the mmu_notifier
due to not finding a memslot corresponding to the notifier's range, which
leads to a variation of use-after-free.

The other misleading comment (and code) explicitly states that roots
without a reference should be skipped.  While that's technically true,
it's also extremely misleading as it should be impossible for KVM to
encounter a defunct root on the list while holding mmu_lock for write.
Opportunstically add a WARN to enforce that invariant.

Fixes: b7cccd397f31 ("KVM: x86/mmu: Fast invalidation for TDP MMU")
Fixes: 4c6654bd160d ("KVM: x86/mmu: Tear down roots before kvm_mmu_zap_all_fast returns")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c     |  8 +++++++
 arch/x86/kvm/mmu/tdp_mmu.c | 46 +++++++++++++++++++++-----------------
 2 files changed, 33 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1d275e9d76b5..94590bc97a67 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5692,6 +5692,14 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 
 	write_unlock(&kvm->mmu_lock);
 
+	/*
+	 * Zap the invalidated TDP MMU roots, all SPTEs must be dropped before
+	 * returning to the caller, e.g. if the zap is in response to a memslot
+	 * deletion, mmu_notifier callbacks will be unable to reach the SPTEs
+	 * associated with the deleted memslot once the update completes, and
+	 * Deferring the zap until the final reference to the root is put would
+	 * lead to use-after-free.
+	 */
 	if (is_tdp_mmu_enabled(kvm)) {
 		read_lock(&kvm->mmu_lock);
 		kvm_tdp_mmu_zap_invalidated_roots(kvm);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index fcbae282af6f..4f5c8e7380a9 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -827,12 +827,11 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 }
 
 /*
- * Since kvm_tdp_mmu_zap_all_fast has acquired a reference to each
- * invalidated root, they will not be freed until this function drops the
- * reference. Before dropping that reference, tear down the paging
- * structure so that whichever thread does drop the last reference
- * only has to do a trivial amount of work. Since the roots are invalid,
- * no new SPTEs should be created under them.
+ * Zap all invalidated roots to ensure all SPTEs are dropped before the "fast
+ * zap" completes.  Since kvm_tdp_mmu_invalidate_all_roots() has acquired a
+ * reference to each invalidated root, roots will not be freed until after this
+ * function drops the gifted reference, e.g. so that vCPUs don't get stuck with
+ * tearing paging structures.
  */
 void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
 {
@@ -856,21 +855,25 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
 }
 
 /*
- * Mark each TDP MMU root as invalid so that other threads
- * will drop their references and allow the root count to
- * go to 0.
+ * Mark each TDP MMU root as invalid to prevent vCPUs from reusing a root that
+ * is about to be zapped, e.g. in response to a memslots update.  The caller is
+ * responsible for invoking kvm_tdp_mmu_zap_invalidated_roots() to the actual
+ * zapping.
  *
- * Also take a reference on all roots so that this thread
- * can do the bulk of the work required to free the roots
- * once they are invalidated. Without this reference, a
- * vCPU thread might drop the last reference to a root and
- * get stuck with tearing down the entire paging structure.
+ * Take a reference on all roots to prevent the root from being freed before it
+ * is zapped by this thread.  Freeing a root is not a correctness issue, but if
+ * a vCPU drops the last reference to a root prior to the root being zapped, it
+ * will get stuck with tearing down the entire paging structure.
  *
- * Roots which have a zero refcount should be skipped as
- * they're already being torn down.
- * Already invalid roots should be referenced again so that
- * they aren't freed before kvm_tdp_mmu_zap_all_fast is
- * done with them.
+ * Get a reference even if the root is already invalid,
+ * kvm_tdp_mmu_zap_invalidated_roots() assumes it was gifted a reference to all
+ * invalid roots, e.g. there's no epoch to identify roots that were invalidated
+ * by a previous call.  Roots stay on the list until the last reference is
+ * dropped, so even though all invalid roots are zapped, a root may not go away
+ * for quite some time, e.g. if a vCPU blocks across multiple memslot updates.
+ *
+ * Because mmu_lock is held for write, it should be impossible to observe a
+ * root with zero refcount, i.e. the list of roots cannot be stale.
  *
  * This has essentially the same effect for the TDP MMU
  * as updating mmu_valid_gen does for the shadow MMU.
@@ -880,9 +883,10 @@ void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
 	struct kvm_mmu_page *root;
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
-	list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link)
-		if (refcount_inc_not_zero(&root->tdp_mmu_root_count))
+	list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link) {
+		if (!WARN_ON_ONCE(!kvm_tdp_mmu_get_root(kvm, root)))
 			root->role.invalid = true;
+	}
 }
 
 /*
-- 
2.34.1.448.ga2b2bfdf31-goog

