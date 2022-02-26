Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 801ED4C5282
	for <lists+kvm@lfdr.de>; Sat, 26 Feb 2022 01:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240143AbiBZAQn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 19:16:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240122AbiBZAQl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 19:16:41 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 366B4218CDD
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:16:07 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id 2-20020aa79202000000b004cef2fc59f0so3956505pfo.12
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:16:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Jj10j2aUg8MzEq8hNDXHAtFe0jk7/OZgYIYqdt1cOoc=;
        b=D2bVuMswqCIu+UG+EbEQzN6gM9KXJVT/zxc3AY9+iTQqtXVpHhdM9v0rQKNQOneKYn
         TQuXm3NDvUYi2SmHd4dr0u+ZMKGEOtqN798Hl830qR4uSuTKj6SwrOv/iG1EmfH95473
         zSN+CrNkkuFMFH2/evxrT9A2Gy7Mdsg++tsrtvD/M9yNK75LEI2fqokwA85WII7OOmHL
         6FLI7TpHmCd2tEVHkUq5XxG92BPqrfEifCe1XZZ5u1Fe0M3idj3nPxZCN2KAvAehEgf9
         ZzBbOryoXNMqmhCpVH9edTem6LJAoVZ6xV2yHTV429B9uQ1qT/NiXinAvUBsEh0yng7h
         Tw6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Jj10j2aUg8MzEq8hNDXHAtFe0jk7/OZgYIYqdt1cOoc=;
        b=KBQWOs5bdbkebyX04JcYcAyEETBuq9EYmr7/vs/KLp/VlHOlx4w8G6jJNZ1CSRYhqH
         xamj5L/z/j2B0QCQVd4/T55iaHbw0HDDhpo7qHVHF0xfIyF42nWD63+U9915pAklrS95
         PMHoEioH5N+pUdKe9TARxSljXi+jMP4ev6qawHgcZxVz7qMlidgegmQ4wGQ78haHmYwu
         bgZJS0fRmyvCdaYo5y6iU0XucLLwmmsiG9n99iKTuZOeBOskry4WcQ5OlxByB8tVbgi+
         1yrW7sTQCE9EIq3yDwMxL6CbHfb0izxY6akSvPffrsPuwvfU8lk09nI5tD6FQDkIScE5
         iFzg==
X-Gm-Message-State: AOAM5338qjuYLb265scS5Llx6EWRI0385QjmNrI37UHUb1xqgDL0nw6x
        agsTFmgNFNrN5GkVNgzruaZyLYOvNcQ=
X-Google-Smtp-Source: ABdhPJxTsqEjDeM7T6Ba1EZBe2JaFy1Xue5S2foiQNfqnVpKVKsbF7n7QWvcOf2FFnbszq/jivwVk86lxIs=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4b52:b0:1bc:b208:dc5c with SMTP id
 mi18-20020a17090b4b5200b001bcb208dc5cmr761796pjb.1.1645834566189; Fri, 25 Feb
 2022 16:16:06 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 26 Feb 2022 00:15:21 +0000
In-Reply-To: <20220226001546.360188-1-seanjc@google.com>
Message-Id: <20220226001546.360188-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220226001546.360188-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v3 03/28] KVM: x86/mmu: Fix wrong/misleading comments in TDP
 MMU fast zap
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index b2c1c4eb6007..80607513a1f2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5662,6 +5662,14 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 
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
index 9357780ec28f..12866113fb4f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -826,12 +826,11 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
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
@@ -855,21 +854,25 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
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
@@ -879,9 +882,10 @@ void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
 	struct kvm_mmu_page *root;
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
-	list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link)
-		if (refcount_inc_not_zero(&root->tdp_mmu_root_count))
+	list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link) {
+		if (!WARN_ON_ONCE(!kvm_tdp_mmu_get_root(root)))
 			root->role.invalid = true;
+	}
 }
 
 /*
-- 
2.35.1.574.g5d30c73bfb-goog

