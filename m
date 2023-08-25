Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9570B787D86
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 04:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240524AbjHYCIB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 22:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240778AbjHYCHj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 22:07:39 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5099219A
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 19:07:37 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-68bee0c327eso584901b3a.1
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 19:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692929257; x=1693534057;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=IGe/iF9SBZy5+j6HXUabX6OshBa9kEx+gGQsGFRDhhI=;
        b=u3xIqi9osuTvUCTmUOsYQxgIxFLIf96g/NRPmenE/NCUekvOeA3QZmB+K52LPFPwNF
         xEVmV1L/UKl0Xrfn/eWKc4r/IlOTYLpHE8VprA5emav26PB+zZLBQW7Dm58jOCtAmYuD
         QBWCtjzSC1HkAKZynbCpalz5g7KSPmdGRrGawljdc3pv4JedzRwhHMlgjEniNstJoa/m
         wSYsv96Av9ZAajSCFP8BGXixBnq+Ve4A3NdqqBf6V0x29ai/Z9BBDRJgDdruOj7OAJP6
         fp9xQ8TBpf2+7OytS6xy8wLi2ejBOUpmWOtZzlFxdkVWxTjn7wLHY0EsvM/Uxayr7afa
         Ufhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692929257; x=1693534057;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IGe/iF9SBZy5+j6HXUabX6OshBa9kEx+gGQsGFRDhhI=;
        b=gcHzKw+Krz0vWw2LaMj4rvEtCZBowCDhetwbiQu53Ox0EeK6jFsJADmmUwfyTH7SOL
         5PSroKuzsyTwOrACg+kC5cgtU4YylcWOrLNBYsluKyYbAilCh39rd8wAyczUnRUlsBPW
         dsjvOdmlNsQtSa62FV9czgnGgxPio4ZeKKoZB3DB8wQMSt7SdbNbnDNr4p2RaNOF9J5F
         aq/QD+kUmdV+MME9ZcE3/3sLHr2NQpFm8NYV9Bf9a3eaz7lEg5asdhEaMFuXPN4uS4Ia
         LoUIFTH7qCI9ulKYE3tzZm9eKFVeM75XgLOpUBmdk3bxHHu5ln+r1WvH5sOH4BAlhl9u
         IXDQ==
X-Gm-Message-State: AOJu0YyL1oWi04WHb2mGCaqsjuXgmuOnau/lHn9m3m8GdfWmg6cI6nSu
        aoi5atUmm8uikEHPCOnKJ4dzC3p/LGA=
X-Google-Smtp-Source: AGHT+IH6trbdMiY01sxIrZj6hxaaLAYXKk3TyN33OwO8ttuBlmlUrTwS7e+FDOumukPVb66A8xaSRMzmG8U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2389:b0:687:9855:ab23 with SMTP id
 f9-20020a056a00238900b006879855ab23mr9667830pfc.1.1692929256877; Thu, 24 Aug
 2023 19:07:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 24 Aug 2023 19:07:32 -0700
In-Reply-To: <20230825020733.2849862-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230825020733.2849862-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.rc2.253.gd59a3bf2b4-goog
Message-ID: <20230825020733.2849862-2-seanjc@google.com>
Subject: [PATCH 1/2] KVM: Allow calling mmu_invalidate_retry_hva() without
 holding mmu_lock
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow checking mmu_invalidate_retry_hva() without holding mmu_lock, even
though mmu_lock must be held to guarantee correctness, i.e. to avoid
false negatives.  Dropping the requirement that mmu_lock be held will
allow pre-checking for retry before acquiring mmu_lock, e.g. to avoid
contending mmu_lock when the guest is accessing a range that is being
invalidated by the host.

Contending mmu_lock can have severe negative side effects for x86's TDP
MMU when running on preemptible kernels, as KVM will yield from the
zapping task (holds mmu_lock for write) when there is lock contention,
and yielding after any SPTEs have been zapped requires a VM-scoped TLB
flush.

Wrap mmu_invalidate_in_progress in READ_ONCE() to ensure that calling
mmu_invalidate_retry_hva() in a loop won't put KVM into an infinite loop,
e.g. due to caching the in-progress flag and never seeing it go to '0'.

Force a load of mmu_invalidate_seq as well, even though it isn't strictly
necessary to avoid an infinite loop, as doing so improves the probability
that KVM will detect an invalidation that already completed before
acquiring mmu_lock and bailing anyways.

Note, adding READ_ONCE() isn't entirely free, e.g. on x86, the READ_ONCE()
may generate a load into a register instead of doing a direct comparison
(MOV+TEST+Jcc instead of CMP+Jcc), but practically speaking the added cost
is a few bytes of code and maaaaybe a cycle or three.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7418e881c21c..7314138ba5f4 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1962,18 +1962,29 @@ static inline int mmu_invalidate_retry_hva(struct kvm *kvm,
 					   unsigned long mmu_seq,
 					   unsigned long hva)
 {
-	lockdep_assert_held(&kvm->mmu_lock);
 	/*
 	 * If mmu_invalidate_in_progress is non-zero, then the range maintained
 	 * by kvm_mmu_notifier_invalidate_range_start contains all addresses
 	 * that might be being invalidated. Note that it may include some false
 	 * positives, due to shortcuts when handing concurrent invalidations.
+	 *
+	 * Note the lack of a memory barriers!  The caller *must* hold mmu_lock
+	 * to avoid false negatives!  Holding mmu_lock is not mandatory though,
+	 * e.g. to allow pre-checking for an in-progress invalidation to
+	 * avoiding contending mmu_lock.  Ensure that the in-progress flag and
+	 * sequence counter are always read from memory, so that checking for
+	 * retry in a loop won't result in an infinite retry loop.  Don't force
+	 * loads for start+end, as the key to avoiding an infinite retry loops
+	 * is observing the 1=>0 transition of in-progress, i.e. getting false
+	 * negatives (if mmu_lock isn't held) due to stale start+end values is
+	 * acceptable.
 	 */
-	if (unlikely(kvm->mmu_invalidate_in_progress) &&
+	if (unlikely(READ_ONCE(kvm->mmu_invalidate_in_progress)) &&
 	    hva >= kvm->mmu_invalidate_range_start &&
 	    hva < kvm->mmu_invalidate_range_end)
 		return 1;
-	if (kvm->mmu_invalidate_seq != mmu_seq)
+
+	if (READ_ONCE(kvm->mmu_invalidate_seq) != mmu_seq)
 		return 1;
 	return 0;
 }
-- 
2.42.0.rc2.253.gd59a3bf2b4-goog

