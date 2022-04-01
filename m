Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 608DF4EFD20
	for <lists+kvm@lfdr.de>; Sat,  2 Apr 2022 01:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353411AbiDAXjq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 19:39:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235236AbiDAXjp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 19:39:45 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51BE939BBD
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 16:37:55 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id e15-20020a17090ab38f00b001c9989ae56cso2296467pjr.9
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 16:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=/07WefWYm1wjvVb2w15UWKePj9kXzDuj1TWXAOE2EVo=;
        b=eYTTX5lfE6p222+w72/5uNt0nD792l5cxW4Ex9/heJZNpEjSUtlCXjCSasxn9jCEWR
         1wOuc/q2/lxKJ6SO5wKU6mPF+WxOg2GvP+yO8L7bx31A/dWKRtYHsIvyzUjZthAeUmMj
         ch5PKnX41GoMkVLROrjTRW8B+yGgDbDw6tcnY/J9XaVoPQ1nWhYY6dN3d3roQVyzjqzZ
         MHL7FDykPKPFkcCIuzCwyQJC3JibB/uBcW+XjMMeOtmStAvo1yfxIYaWGq/lbfqpc+gk
         6JKT45aqu3ELMNAQLjDQDV0T81WhPdQA77Dig0b6TtNAVk0CK0BZQ80lSVOnbW2rCnin
         KPaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/07WefWYm1wjvVb2w15UWKePj9kXzDuj1TWXAOE2EVo=;
        b=JJJVnjvwQbdloNYbDGrcJkbm8cp2uXp4zVJFLwZ1fOu5vcxXZu51Z3W+LIcf4JjCbj
         XYqzHb1S1uRo6eg56Y9PK1E4sv0OpBW/6qoPvRysroysThRTk+qvuHwocA6ZuEGPxHbc
         OZ+ZF9OViJQAgEW+8iQxnOw9WBALDF+g8rSvFFtc6Y2IyrBgwuUMn49STK0GxoFopH3k
         AIJQkEmxKORzEdfYIwZg78+c5qDzC0q/Ul7pZ3Sl2RRzd7i+NK0jOly8Pk43FiE2qlet
         kSv64RrvTpk0xy5NZ3C8t04QJAZ1V1fGWUIEXhMM8Ikz48hu7H3V/6fG9H6JB+yfbWF8
         jqZg==
X-Gm-Message-State: AOAM531CzvaInX95kXa7CJdLuTm9J1hSsJL1wmb7ZNPtEQdVeR19fEBG
        6z6Nr9N3pu8KJZPaRpY+8yuAF+qmSNY1yw==
X-Google-Smtp-Source: ABdhPJxHQibJi37gdIS76x91BNH9kBJAg7rh3O7oMRDnpRvtI6uIWHoKF9/gODtt/fBp29LCwEOHm6G4yFajaw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:3316:b0:4fa:80fd:f3f6 with SMTP
 id cq22-20020a056a00331600b004fa80fdf3f6mr13133642pfb.65.1648856274826; Fri,
 01 Apr 2022 16:37:54 -0700 (PDT)
Date:   Fri,  1 Apr 2022 23:37:36 +0000
In-Reply-To: <20220401233737.3021889-1-dmatlack@google.com>
Message-Id: <20220401233737.3021889-3-dmatlack@google.com>
Mime-Version: 1.0
References: <20220401233737.3021889-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH 2/3] KVM: x86/mmu: Pass account_nx to tdp_mmu_split_huge_page()
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        "open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)" 
        <kvm@vger.kernel.org>, Peter Xu <peterx@redhat.com>
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

In preparation for splitting huge pages during fault, pass account_nx to
tdp_mmu_split_huge_page(). Eager page splitting hard-codes account_nx to
false because the splitting is being done for dirty-logging rather than
vCPU execution faults.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index d71d177ae6b8..9263765c8068 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1456,7 +1456,8 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 }
 
 static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
-				   struct kvm_mmu_page *sp, bool shared)
+				   struct kvm_mmu_page *sp, bool shared,
+				   bool account_nx)
 {
 	const u64 huge_spte = iter->old_spte;
 	const int level = iter->level;
@@ -1479,7 +1480,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
 	 * correctness standpoint since the translation will be the same either
 	 * way.
 	 */
-	ret = tdp_mmu_link_sp(kvm, iter, sp, false, shared);
+	ret = tdp_mmu_link_sp(kvm, iter, sp, account_nx, shared);
 	if (ret)
 		goto out;
 
@@ -1539,7 +1540,7 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 				continue;
 		}
 
-		if (tdp_mmu_split_huge_page(kvm, &iter, sp, shared))
+		if (tdp_mmu_split_huge_page(kvm, &iter, sp, shared, false))
 			goto retry;
 
 		sp = NULL;
-- 
2.35.1.1094.g7c7d902a7c-goog

