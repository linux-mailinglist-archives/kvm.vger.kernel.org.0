Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA6E58B2A7
	for <lists+kvm@lfdr.de>; Sat,  6 Aug 2022 01:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241751AbiHEXGU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 19:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241626AbiHEXFk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 19:05:40 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD947AC15
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 16:05:34 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id y81-20020a253254000000b0067ba548d2a1so1528910yby.15
        for <kvm@vger.kernel.org>; Fri, 05 Aug 2022 16:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=a0sejF7LmfikJFmz6Lcl1SsiJbupoK1D9mnUFihc8VU=;
        b=UN/syhFvQS+2ABKiiRlWZevZVkyMjjsByGEV3Y+bQXxcB7y8FC9Cnha9pEVQ3n/745
         /w8b0GESJducYshuMoCL1A7OIB2kBBFDLaSBFg9h/hv20ySYOCKWDLaR9uE4WeZ6jFrz
         dFQARovx6wq+grTzXeYH+njsy/flyfO2ANOL6T9SMKwbJcOojBc/xwLN1GYhfGeVqa8K
         ADZV9TDVUXSfMbcyGCxOphzyU3qBtO71i/D+A5xccpK0vLo7/5tV5jtD0ap9M431NbaF
         LZQe0Fe/wU6HURE6VJ6LhW2Qog4ffqgDMyThZgPU142k2eXGz+LQ34I1TzLTiQjuTmR4
         D3yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=a0sejF7LmfikJFmz6Lcl1SsiJbupoK1D9mnUFihc8VU=;
        b=jyBPBgCNfaCkog9t0h5l9zO31rNRQDHUNbha/nQggsCDJE/dR6C1r6djqELsqWy8tM
         uoWHoWc+iDSKyqRyMP8xY9rFUCTc2By4tmiGTkcbQgXutR3SsYlaTJyhBVJfeWk6jpuK
         JFQLe6gPYIm8tDjT0VozaGHDE73B0jCu4be9KZyzmFHtU8PWCyZBfRsc/+Mt/URSSTVw
         wSV6TtFmVoMvePs5vMVjJAy8Q/efC7fI3jEubsW8a6Gop8OgSbRCboLZhWrwJ/ziqmRS
         bPPC9Mg2sL/Iz1gxjKB/22BeOlCHG4lfFyR5A2og2h0GJigARnthcVdb7vqqp3toJ0Zw
         5/kw==
X-Gm-Message-State: ACgBeo3iLkqe+W64ZhiVFteEzRaVS68KvaOn26rpT6UUT9anrnKZLiVE
        7SWaeiFvwfrt/cEFghj/3g+ftKNYn28=
X-Google-Smtp-Source: AA6agR4jfD1+2IaL8aoXi2FQlkXtc/IkU6FWDrTk0ASjCLegEJ1d43RrPHpEHZDnVTBaOUPannz8B4FmaYw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b91:0:b0:324:f022:5d5e with SMTP id
 139-20020a810b91000000b00324f0225d5emr8124524ywl.353.1659740733576; Fri, 05
 Aug 2022 16:05:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  5 Aug 2022 23:05:13 +0000
In-Reply-To: <20220805230513.148869-1-seanjc@google.com>
Message-Id: <20220805230513.148869-9-seanjc@google.com>
Mime-Version: 1.0
References: <20220805230513.148869-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [PATCH v3 8/8] KVM: x86/mmu: explicitly check nx_hugepage in disallowed_hugepage_adjust()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Mingwei Zhang <mizhang@google.com>,
        Ben Gardon <bgardon@google.com>
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

From: Mingwei Zhang <mizhang@google.com>

Explicitly check if a NX huge page is disallowed when determining if a
page fault needs to be forced to use a smaller sized page.  KVM currently
assumes that the NX huge page mitigation is the only scenario where KVM
will force a shadow page instead of a huge page, and so unnecessarily
keeps an existing shadow page instead of replacing it with a huge page.

Any scenario that causes KVM to zap leaf SPTEs may result in having a SP
that can be made huge without violating the NX huge page mitigation.
E.g. prior to commit 5ba7c4c6d1c7 ("KVM: x86/MMU: Zap non-leaf SPTEs when
disabling dirty logging"), KVM would keep shadow pages after disabling
dirty logging due to a live migration being canceled, resulting in
degraded performance due to running with 4kb pages instead of huge pages.

Although the dirty logging case is "fixed", that fix is coincidental,
i.e. is an implementation detail, and there are other scenarios where KVM
will zap leaf SPTEs.  E.g. zapping leaf SPTEs in response to a host page
migration (mmu_notifier invalidation) to create a huge page would yield a
similar result; KVM would see the shadow-present non-leaf SPTE and assume
a huge page is disallowed.

Fixes: b8e8c8303ff2 ("kvm: mmu: ITLB_MULTIHIT mitigation")
Reviewed-by: Ben Gardon <bgardon@google.com>
Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
[sean: add barrier comments, use spte_to_child_sp(), massage changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 17 +++++++++++++++--
 arch/x86/kvm/mmu/tdp_mmu.c |  3 ++-
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1442129c85e0..3ddfc82868fd 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3090,6 +3090,19 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
 	    cur_level == fault->goal_level &&
 	    is_shadow_present_pte(spte) &&
 	    !is_large_pte(spte)) {
+		u64 page_mask;
+
+		/*
+		 * Ensure nx_huge_page_disallowed is read after checking for a
+		 * present shadow page.  A different vCPU may be concurrently
+		 * installing the shadow page if mmu_lock is held for read.
+		 * Pairs with the smp_wmb() in kvm_tdp_mmu_map().
+		 */
+		smp_rmb();
+
+		if (!spte_to_child_sp(spte)->nx_huge_page_disallowed)
+			return;
+
 		/*
 		 * A small SPTE exists for this pfn, but FNAME(fetch)
 		 * and __direct_map would like to create a large PTE
@@ -3097,8 +3110,8 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
 		 * patching back for them into pfn the next 9 bits of
 		 * the address.
 		 */
-		u64 page_mask = KVM_PAGES_PER_HPAGE(cur_level) -
-				KVM_PAGES_PER_HPAGE(cur_level - 1);
+		page_mask = KVM_PAGES_PER_HPAGE(cur_level) -
+			    KVM_PAGES_PER_HPAGE(cur_level - 1);
 		fault->pfn |= fault->gfn & page_mask;
 		fault->goal_level--;
 	}
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 526d38704e5c..c5314ca95e08 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1202,7 +1202,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			/*
 			 * Ensure nx_huge_page_disallowed is visible before the
 			 * SP is marked present, as mmu_lock is held for read.
-			 * Pairs with the smp_rmb() in tdp_mmu_unlink_sp().
+			 * Pairs with the smp_rmb() in tdp_mmu_unlink_sp() and
+			 * in disallowed_hugepage_adjust().
 			 */
 			smp_wmb();
 
-- 
2.37.1.559.g78731f0fdb-goog

