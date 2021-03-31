Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0653508E0
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 23:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232833AbhCaVJa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 17:09:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232757AbhCaVJJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Mar 2021 17:09:09 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED69C061574
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 14:09:08 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id n13so3605756ybp.14
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 14:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=foMxttOwu6SYavjwnG7oqUJ2WlokRAISZJZJ0feAVWI=;
        b=HzxTpFc/w24AxMwjTtlYMwP/8TI8y0GPxp/iMkyEs8ZgTb5INW2FMmZ0BvrnErb0th
         vnhXeNY52N5SBFtKxNlrSJTx2m90miUf/WEck1JveNYjPzVo96FX9aJBMeBEueAJSt5J
         /fCjKv9wLbyN7K51nHzWtvcmpc8Qv5vvtsGipYUGvmaDiMyusliXiIZkdiStcBvUYz1A
         DKBUoHDVbnjSGSRvVG9Oh4iU+yGVlrG2JD5UM+bN7GKkNbGK+qPcVWayK8ePB36GogGl
         kglGA3fvGdmSEdiwU5bEagRZnwlmsK6eqDpr/KoDbJPBmX6P2HdeZfalogN12hfkfCOt
         nXQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=foMxttOwu6SYavjwnG7oqUJ2WlokRAISZJZJ0feAVWI=;
        b=IsmBmC78MDyiZXon9JsF2skMSPoxrZ8QJcm+DisP3zzBrkNRt0k2wz54wmJQFjtoz3
         iM9hek1cUKpZYAx+ZjnfCQaw9I7h20V2019C5+eIov4bDf6+EJ/m2VLkWsGIP3FuEJ2M
         rn0PfShD5xOKnn/bpSZlmiLGzKp8lZkLGGSlcneyEg/n/PHUA5I4uQttgojsWZLOiJjT
         gFNvX1tHKvjkxy/NhuRtM5jZ9QsmCvyO0ln931lupvSI9j04lVbw0vGc2bQtp2PlgZ2P
         LRZPf79pogAE4+DzliVMP9RJ0um+kCRy0T9sAez+EYu+zp4GsMFYK7GzYsgrqI7AUFbY
         p8aA==
X-Gm-Message-State: AOAM532jWLBOGPk30A67mCZuXh3JMJj1YUHV1J43D+irL5nw+rR8dbPT
        k96F1VWQEeDOG4/US4FThhB32F3/SUlR
X-Google-Smtp-Source: ABdhPJyeLb8XwRV0troRnkuHZqf7A5YX/XYnXQT2L3T51rF0GWkqeTSsx2jj9AFTCqsKyHNf1fLEUQ4iCBtd
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:8026:6888:3d55:3842])
 (user=bgardon job=sendgmr) by 2002:a25:d093:: with SMTP id
 h141mr7341271ybg.292.1617224947988; Wed, 31 Mar 2021 14:09:07 -0700 (PDT)
Date:   Wed, 31 Mar 2021 14:08:31 -0700
In-Reply-To: <20210331210841.3996155-1-bgardon@google.com>
Message-Id: <20210331210841.3996155-4-bgardon@google.com>
Mime-Version: 1.0
References: <20210331210841.3996155-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 03/13] KVM: x86/mmu: use tdp_mmu_free_sp to free roots
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Minor cleanup to deduplicate the code used to free a struct kvm_mmu_page
in the TDP MMU.

No functional change intended.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 1929cc7a42ac..5a2698d64957 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -88,6 +88,12 @@ static inline struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 			  gfn_t start, gfn_t end, bool can_yield);
 
+static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
+{
+	free_page((unsigned long)sp->spt);
+	kmem_cache_free(mmu_page_header_cache, sp);
+}
+
 void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root)
 {
 	gfn_t max_gfn = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
@@ -101,8 +107,7 @@ void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root)
 
 	zap_gfn_range(kvm, root, 0, max_gfn, false);
 
-	free_page((unsigned long)root->spt);
-	kmem_cache_free(mmu_page_header_cache, root);
+	tdp_mmu_free_sp(root);
 }
 
 static union kvm_mmu_page_role page_role_for_level(struct kvm_vcpu *vcpu,
@@ -164,12 +169,6 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 	return __pa(root->spt);
 }
 
-static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
-{
-	free_page((unsigned long)sp->spt);
-	kmem_cache_free(mmu_page_header_cache, sp);
-}
-
 /*
  * This is called through call_rcu in order to free TDP page table memory
  * safely with respect to other kernel threads that may be operating on
-- 
2.31.0.291.g576ba9dcdaf-goog

