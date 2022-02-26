Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F20C4C5291
	for <lists+kvm@lfdr.de>; Sat, 26 Feb 2022 01:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240580AbiBZARd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 19:17:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240813AbiBZARH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 19:17:07 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA28227588
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:16:28 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id 62-20020a621541000000b004f110fdb1aeso3961595pfv.13
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:16:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=jE7hvTIwynzoEhqj9gg0C8wmmkSrwJFvj0OAsRaPAlA=;
        b=srFn6/Gu6kkdg0tWw8AP8f0ag5lnSoNgNzSyKt42ty/ArJ0sDsbGxDiqG9F8WTo4+i
         s8o3gb4AqaCFm5tB68JP2sp3xMK4tDhMaRXTCNoW8ye0qMuuOB+k/sXSxj4EHbzDw9XD
         bLZHLWHYvbyp245DKxFfD5ART5g0xwZkpyxaH9wDt07/SvRGs4J/TWTClLP+tHywhJYF
         q43b5YGS3wGKDHqz5KPZCJ/ALfjcWBtccT0kMd+eNLQAwPZEXJywwx0pZrC8+S7NNd+b
         7BPpblxaes9aNc98ZZfjhcFwaCXUOtgodIKlDTiIRS4KASmSRSRgrz8o5RNiE5w/QZna
         amTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=jE7hvTIwynzoEhqj9gg0C8wmmkSrwJFvj0OAsRaPAlA=;
        b=CU1fdyhaC63YD0/hmLY23ivA8XQ2mUwEymaW9NeKZcrZsfSRvwr47Q/kEKtXUS9DXr
         6RHlLMsZNwdRqm7zM+WCAWbbVGE5YbXq4xDlTIwJMi/hss0lteXeNyAX5pGwFl7bzZPj
         2PE213Xh76akreuu3wo5gkknoNlB++H8xTgBQ0MvvzR26pxAK9mqyatKNyK5975fXkDE
         ztsG7SJqmC9cYoQyHS9rjMpg18kGVEuBumkGrQWiSlHSaQPRPWZgarExmgudDbOWlBn6
         etcEumlf03QEAaYroiPwIoleHbGA56KV1MoHmBqvT9NgJrxkluJjjkPnjYCFYhuDXrV4
         QYXw==
X-Gm-Message-State: AOAM530VVl1+QJg3EODcMchNKWZpaJPTK/tTvstzdVKoKsZjsQVVbR5M
        rvCWBbP+oB1NuW6y7m5MeKjhyMjFySU=
X-Google-Smtp-Source: ABdhPJwJp2sMRKVTOQNmfwDXuQFGza9n04onJWCaorDfzPz3xBNBNE+5W7ARgHLaTP78NXYR+Qw1NgKOM9Q=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a63:ad47:0:b0:373:4c14:35e2 with SMTP id
 y7-20020a63ad47000000b003734c1435e2mr8128596pgo.67.1645834588279; Fri, 25 Feb
 2022 16:16:28 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 26 Feb 2022 00:15:34 +0000
In-Reply-To: <20220226001546.360188-1-seanjc@google.com>
Message-Id: <20220226001546.360188-17-seanjc@google.com>
Mime-Version: 1.0
References: <20220226001546.360188-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v3 16/28] KVM: x86/mmu: Require mmu_lock be held for write to
 zap TDP MMU range
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
 arch/x86/kvm/mmu/tdp_mmu.c | 24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index c5df9a552470..b55eb7bec308 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -858,15 +858,9 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
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
@@ -879,14 +873,13 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	end = min(end, tdp_mmu_max_gfn_host());
 
-	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
+	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	rcu_read_lock();
 
 	for_each_tdp_pte_min_level(iter, root, min_level, start, end) {
-retry:
 		if (can_yield &&
-		    tdp_mmu_iter_cond_resched(kvm, &iter, flush, shared)) {
+		    tdp_mmu_iter_cond_resched(kvm, &iter, flush, false)) {
 			flush = false;
 			continue;
 		}
@@ -905,12 +898,8 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
 
-		if (!shared) {
-			tdp_mmu_set_spte(kvm, &iter, 0);
-			flush = true;
-		} else if (tdp_mmu_zap_spte_atomic(kvm, &iter)) {
-			goto retry;
-		}
+		tdp_mmu_set_spte(kvm, &iter, 0);
+		flush = true;
 	}
 
 	rcu_read_unlock();
@@ -929,8 +918,7 @@ bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
 	struct kvm_mmu_page *root;
 
 	for_each_tdp_mmu_root_yield_safe(kvm, root, as_id, false)
-		flush = zap_gfn_range(kvm, root, start, end, can_yield, flush,
-				      false);
+		flush = zap_gfn_range(kvm, root, start, end, can_yield, flush);
 
 	return flush;
 }
-- 
2.35.1.574.g5d30c73bfb-goog

