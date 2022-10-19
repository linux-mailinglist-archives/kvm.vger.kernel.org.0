Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0AED604DF3
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 18:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231573AbiJSQ5E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 12:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbiJSQ4r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 12:56:47 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A91421D066D
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 09:56:35 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id s13-20020a170902ea0d00b00183243c7a0fso12109895plg.3
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 09:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=GscSUgsZGmj923/aia3vL9pbn6x7hvYEHqUbfgDwtc8=;
        b=EEYb/VsMizKiUoFVd4rA6w3z6WaZeZLTGOTALE6KAhnCcBnYhEXMFPjDuNc4rzrZHO
         nUFmb16EjwmVJfqiyDksrVEzabLxWMpScBPXbdJQUDqsH3BYALeiEkgnazdHZ08SDTWm
         pMYzsafuQf6bB0R8JZxi6+3SdTIbQYywOUJJoSeUwfT4C/tI/gURJ7ZZqEljbSEl0pYF
         ofyj11F5quyUEKESmgKhZz+Qz5tsUxfJJ2toI+fr6KON8xxn9hYtHKa3auN/hKaVVo05
         FlFcYetlto1j4ks++Bnrx2snmEGCvmqDASi99sKXlRwH/EXuK7ugvY4BoYkx/gQYd3hz
         eczw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GscSUgsZGmj923/aia3vL9pbn6x7hvYEHqUbfgDwtc8=;
        b=RORZB4Fdg9NKdHbWoNSiCYiqoJV+bVFk43q2Qq4MF6GijylnxvwJ/k7pfBS3zkhMD8
         GghVpIphaz9NVuSy2sHC/t3eIp2cS/A1WZmh7V/2uauvw8LHfb51mGYteDM/w2xBD6is
         HlqNFZUSwK3Va+ARqlWPgVql03V5K5EcTl9cVOkqgy5EYU3xDbjm0T9wfjAg4adUs9z3
         9b9VPTywdPlzVrwl3+e4mvUmiNC2rZ2EycyqC8EAekuRVZ0vjpwPeoz7XsauSKELVXAf
         Q04in9j2bcXkj6AxnWk+yeWEX0L6rtLyn3KCkEGl6sIQmR7ovGcb6Me7asHIljKP2jmK
         IuCQ==
X-Gm-Message-State: ACrzQf2uqHSJw8q7YVYNryf1NvpemSy5EBxTVX4IVtEAwOCndbKh9q7l
        ULN6B+NkvxIlHHQupcbUPoYnKPnjfuw=
X-Google-Smtp-Source: AMsMyM6C2OUBHA2Qh+2aXSV1vqJhhOvokoI0sAWn7iB6BoqYVldMoGUB5JUprkgTa0sQ/WOPmjum4FK8ZJk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c986:b0:205:f08c:a82b with SMTP id
 w6-20020a17090ac98600b00205f08ca82bmr2823103pjt.1.1666198594436; Wed, 19 Oct
 2022 09:56:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 19 Oct 2022 16:56:17 +0000
In-Reply-To: <20221019165618.927057-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221019165618.927057-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221019165618.927057-8-seanjc@google.com>
Subject: [PATCH v6 7/8] KVM: x86/mmu: explicitly check nx_hugepage in disallowed_hugepage_adjust()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>,
        David Matlack <dmatlack@google.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
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
[sean: use spte_to_child_sp(), massage changelog, fold into if-statement]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f4f1b1591a02..14674c9e10f7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3111,7 +3111,8 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
 	if (cur_level > PG_LEVEL_4K &&
 	    cur_level == fault->goal_level &&
 	    is_shadow_present_pte(spte) &&
-	    !is_large_pte(spte)) {
+	    !is_large_pte(spte) &&
+	    spte_to_child_sp(spte)->nx_huge_page_disallowed) {
 		/*
 		 * A small SPTE exists for this pfn, but FNAME(fetch)
 		 * and __direct_map would like to create a large PTE
-- 
2.38.0.413.g74048e4d9e-goog

