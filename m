Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6065A7219
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 01:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbiH3X4m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 19:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231941AbiH3X4M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 19:56:12 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AFCF6A4A8
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:55:56 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id v65-20020a626144000000b0052f89472f54so5253213pfb.11
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=y3kz8obqLBonD5tHztG2UKXsESWQEw13imz9n7vKM28=;
        b=QO4pr/OUWywfeGPew6Vl8vnqc3SYijsxKpAsnxfE5RTke1B7w5vPsYPaSlXahQSRM0
         IFSjVWD2W8wZzhkPsUga2Qcy4LplXxzYUCdwOQa2fTzBcFfUmwDswKPc2KGBUp5hKseA
         8jRRBhirZ1LvG1KiamPdIh/XZXfZQ4Lv6Syx6aZnoEZmL+WBGvq2MZUoSE6oKYbP7EQ0
         hAwP/Hjnhd2/AgR1OYTOgk1cZsAulgKYVxH3dYIuLW0pTe1LMispqZh7Jq2cP4Vqm9tz
         Jk347ukWwIPKiPZJv5FY12eMr59Ss8UKeSIGU+ss+mtyFLw51QCHcsavhOdZTEllbWE/
         DO8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=y3kz8obqLBonD5tHztG2UKXsESWQEw13imz9n7vKM28=;
        b=so83Zo/3GIopXTCsWHStbrSrnp52bG6DNgHvUmRs8bVopFvJQO2cA2CNzxd46O4vrM
         /UPt7wajGFn8qoJjAsb/s0OnbEjhLPTYvWoj7e7DPYeQKKcRZanZqVBcYWyPVjCO3Oxn
         5ZR2H3fK+r8rq2hMIhK7gOcOw3F23Vebik+rnSrCSx8S2uFOokCWczKwld/7I0oBcCSH
         cUvj9+hwAU8fUbKDE/UGiKKrKJgT/wJw3JdCsDn4w2i8R/34QWB2WlUpwfo4/sHz6O4Y
         CLGx61o4D6PLbcnAd6XhIccW7WNGEteQsti+u8ijTTBFj9zi7QGp1FHoGKPSVIODcqL1
         DhFA==
X-Gm-Message-State: ACgBeo3fr75huPheEh4K/qONHDsrb7fChhXdukzj93pENK3fpJRJOqSX
        zJ8l0Vm6ClFeMMW7KD5+CeSD+qFG1pU=
X-Google-Smtp-Source: AA6agR4HYZOMjM4W62nKOMIMchdSJkN3Hvv4lk2xn8FabErsvrvhPNo3yhKmT05mKEsy59hy1iNCMgt1VDI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:e558:b0:1fb:c4b7:1a24 with SMTP id
 ei24-20020a17090ae55800b001fbc4b71a24mr18202pjb.1.1661903754875; Tue, 30 Aug
 2022 16:55:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 30 Aug 2022 23:55:37 +0000
In-Reply-To: <20220830235537.4004585-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220830235537.4004585-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830235537.4004585-10-seanjc@google.com>
Subject: [PATCH v4 9/9] KVM: x86/mmu: explicitly check nx_hugepage in disallowed_hugepage_adjust()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Ben Gardon <bgardon@google.com>
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
[sean: use spte_to_child_sp(), massage changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4737da767a40..d1fc087f86bf 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3102,6 +3102,11 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
 	    cur_level == fault->goal_level &&
 	    is_shadow_present_pte(spte) &&
 	    !is_large_pte(spte)) {
+		u64 page_mask;
+
+		if (!spte_to_child_sp(spte)->nx_huge_page_disallowed)
+			return;
+
 		/*
 		 * A small SPTE exists for this pfn, but FNAME(fetch)
 		 * and __direct_map would like to create a large PTE
@@ -3109,8 +3114,8 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
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
-- 
2.37.2.672.g94769d06f0-goog

