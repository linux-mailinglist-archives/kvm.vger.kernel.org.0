Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5F34E58B8
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 19:50:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344106AbiCWSvL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 14:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344061AbiCWSvB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 14:51:01 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7055260CC9
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 11:49:31 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id 11-20020a62180b000000b004fa65805047so1427249pfy.12
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 11:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=i3y/R2G/yOzk3wi7p2qOKXA2BvyWMGeSAE7HqxAnaPU=;
        b=eZP/RLC9xeAaOFNwwbxYUIxPtQMvTN3IXnMmR4pGyi2YtpEhddJBpbpmaTPlJD1MYD
         1LivnC4WvLcy+TtAP1TFFzuD35h42ZXmVOtHd4cn7vMNKfDVtNNrKdVPLAfNJnajfCsb
         c8DX7jLm1/Da4Cv8rR+1R2oBGizMEEbDZoaWHGXlr5I9XdE4M1aMRAc6VjZxJ+wyU6KC
         OBZoBMaArnYbwAU3rogO0VToAPFYgdJY//UDGCMX6YljpHNPHkHAwHMoPOld2MbEBSKF
         d8WjcmsMnQYBKH6f2XJ1VP19vPxMpbypqayzj/MUSwLpUkChdDY1hmBHhP2ZRb3KhWQf
         GC1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=i3y/R2G/yOzk3wi7p2qOKXA2BvyWMGeSAE7HqxAnaPU=;
        b=Ev5/CE+w97TBDjcjWzCrp4dYmaZLUcACmthNQPb+hhW+hyfmDunHF7y735DWrlswZ6
         +JLASM1Etks99NPY3mz1zTThICYjoQ0aMZuVW6fwSfhTBKzlCmWwLu5L+sIrgx4VV1JM
         VscUk/5Dxr8n0xloyDYofD8rSSMpLjYwDTsmCtVW/hTwLLCq9VXWb3HRdlrLrgFUQd/d
         wsd9lZzaIBv+V3YMAYWvr59X5QKHMB6N1Frr+qPxv4FcV8NC0IJQCzmygU0R99nW5Tzb
         oUNTyBY/vYeN+FUcB1sIMf6MUtphPna5Mx1uyMNznoo8vBbrRnX8ODteKkcUKmCyY9fp
         G84w==
X-Gm-Message-State: AOAM531bnZAdDHlZOAsjs0xbuvbWS3JgH5T+At0RskcvvLK0DJSBvg6R
        uORiIO6AB+kEbje7riFMY64u+5r/j7+Z
X-Google-Smtp-Source: ABdhPJwy9+hoP4haE+2RiusYHIP0dKJx4cZVl9ra6s7X/D91BaloL9b86cNA0SFB2RLUzX7nIuAmslbBtlfI
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a17:90a:1d04:b0:1bc:98ca:5e6f with SMTP id
 c4-20020a17090a1d0400b001bc98ca5e6fmr13721397pjd.32.1648061370937; Wed, 23
 Mar 2022 11:49:30 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Wed, 23 Mar 2022 18:49:14 +0000
In-Reply-To: <20220323184915.1335049-1-mizhang@google.com>
Message-Id: <20220323184915.1335049-5-mizhang@google.com>
Mime-Version: 1.0
References: <20220323184915.1335049-1-mizhang@google.com>
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH v2 3/4] KVM: x86/mmu: explicitly check nx_hugepage in disallowed_hugepage_adjust()
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Peter Xu <peterx@redhat.com>
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

Add extra check to specify the case of nx hugepage and allow KVM to
reconstruct large mapping after dirty logging is disabled. Existing code
works only for nx hugepage but the condition is too general in that does
not consider other usage case (such as dirty logging). Note that
when dirty logging is disabled, KVM calls kvm_mmu_zap_collapsible_sptes()
which only zaps leaf SPTEs. Moreover, existing code assumes that a present
PMD or PUD indicates that there exist 'smaller SPTEs' under the paging
structure. This assumption may no be true if KVM zaps only leafs in MMU.

Missing the check causes KVM incorrectly regards the faulting page as a NX
huge page and refuse to map it at desired level. And this leads to back
performance issue in shadow mmu and potentially in TDP mmu as well.

Fixes: b8e8c8303ff2 ("kvm: mmu: ITLB_MULTIHIT mitigation")
Cc: stable@vger.kernel.org

Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5628d0ba637e..d9b2001d8217 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2919,6 +2919,16 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
 	    cur_level == fault->goal_level &&
 	    is_shadow_present_pte(spte) &&
 	    !is_large_pte(spte)) {
+		struct kvm_mmu_page *sp;
+		u64 page_mask;
+		/*
+		 * When nx hugepage flag is not set, there is no reason to go
+		 * down to another level. This helps KVM re-generate large
+		 * mappings after dirty logging disabled.
+		 */
+		sp = to_shadow_page(spte & PT64_BASE_ADDR_MASK);
+		if (!sp->lpage_disallowed)
+			return;
 		/*
 		 * A small SPTE exists for this pfn, but FNAME(fetch)
 		 * and __direct_map would like to create a large PTE
@@ -2926,8 +2936,8 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
 		 * patching back for them into pfn the next 9 bits of
 		 * the address.
 		 */
-		u64 page_mask = KVM_PAGES_PER_HPAGE(cur_level) -
-				KVM_PAGES_PER_HPAGE(cur_level - 1);
+		page_mask = KVM_PAGES_PER_HPAGE(cur_level) -
+			KVM_PAGES_PER_HPAGE(cur_level - 1);
 		fault->pfn |= fault->gfn & page_mask;
 		fault->goal_level--;
 	}
-- 
2.35.1.1021.g381101b075-goog

