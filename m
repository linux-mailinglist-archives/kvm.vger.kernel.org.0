Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7884EF173
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 16:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347561AbiDAOjL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 10:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347389AbiDAOfV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 10:35:21 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E251DEC09
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 07:33:14 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id o68-20020a17090a0a4a00b001c686a48263so5122030pjo.1
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 07:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=k4bN/0aTPe4C1wZQvO0SYhx4k2cWLhq656Tv/Tf/44Q=;
        b=Pdr4qXTrSN6HO6EW00C3G26qTRcxrkqJNfj684zrI3WaeqK9l5ggIwGJ+WkMpJ9SJm
         nbbzWGGzq1aSkJMclTKolCLJ2d+HDQdMRKBRy7IKNg4t12HYJWMruSkmDiQiSI5IpqGz
         o4JN1E56/U21WKsUB3fii0cBwaNafgM7Y1Q33+fUUwl0vCDWB0hspps8UAD0yeEp6tRz
         HvMRcY4zYkAywZde69EE22cMKPLVuJ3jVyLyzqSCg6BYCE1Z9l7Zb+e4xhwwCPKFB9QK
         DEOdozm+Fr8HJyYtXFo6MnQ1BZdeSozSBp3QZORbgfVezJ2NjdRCh0CpSXJtI1BeYR5h
         RXyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=k4bN/0aTPe4C1wZQvO0SYhx4k2cWLhq656Tv/Tf/44Q=;
        b=Zcr9IM2jgashZ1u7/Wq+djfzmZ9hCiGcXvjt2j1qgPcVJuAB5YbcqRVkarsKzaxrPt
         tQ3OwTfquHpmnU+MxlsI0rHAeTrmegsKdngKcn3jAIBeMI/g+wxDOXDLW1JWUH8G4JRW
         akB7PT1WSa72shbpTnTt3JxR5zXVxBLBPPvQy88yLRuudApAI/tS+hx+EsJdotR6E3ML
         IBcj4v99SauqQm4AX9PG1bsqUVi2ah52SSFBhpd5OwAt21yFiPSuJNp9xmg6W/LjBIX2
         7Mc3W+QV0FogRcRVcKq3oVBNQ49V0S0R4Ag0KRYfEYfsqdaxpklefUAxZ3wshrQP2eTI
         DVwQ==
X-Gm-Message-State: AOAM530mHR3BWj2bYHmEdYD5PxxBx3Nq2PTGw9K0gIf1uOzUyyms3MYQ
        dqz0GJOFesqALRmHuKD5aQuc+g==
X-Google-Smtp-Source: ABdhPJyZr/LEQ/N3wCmeTeBzQjGN5hVBv4JdlD3t3GYtrHw2ufdpM/juOTCs0cgXG7LWrG+Szun8Pg==
X-Received: by 2002:a17:90b:1811:b0:1c7:832a:3388 with SMTP id lw17-20020a17090b181100b001c7832a3388mr12316590pjb.40.1648823593409;
        Fri, 01 Apr 2022 07:33:13 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id ep2-20020a17090ae64200b001c6a7c22aedsm2700568pjb.37.2022.04.01.07.33.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Apr 2022 07:33:12 -0700 (PDT)
Date:   Fri, 1 Apr 2022 14:33:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v3 3/6] KVM: x86/mmu: explicitly check nx_hugepage in
 disallowed_hugepage_adjust()
Message-ID: <YkcNJF+ugsdSffpG@google.com>
References: <20220401063636.2414200-1-mizhang@google.com>
 <20220401063636.2414200-4-mizhang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220401063636.2414200-4-mizhang@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 01, 2022, Mingwei Zhang wrote:
> Explicitly check if a NX huge page is disallowed when determining if a page
> fault needs to be forced to use a smaller sized page. KVM incorrectly
> assumes that the NX huge page mitigation is the only scenario where KVM
> will create a shadow page instead of a huge page. Any scenario that causes
> KVM to zap leaf SPTEs may result in having a SP that can be made huge
> without violating the NX huge page mitigation. E.g. disabling of dirty
> logging, zapping from mmu_notifier due to page migration, guest MTRR
> changes that affect the viability of a huge page, etc...
> 
> Fixes: b8e8c8303ff2 ("kvm: mmu: ITLB_MULTIHIT mitigation")
> 
> Reviewed-by: Ben Gardon <bgardon@google.com>

Reviewed-by (and Acked-by and Tested-by) tags should be dropped when there is a
non-trivial, functional, and/or semantic change between versions.  It's often a
judgment call, but in this case I would definitely drop Ben's review.  It's usually
better to err on the side of caution for this rule/guideline.

> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 5cb845fae56e..033609e8b332 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2896,6 +2896,16 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
>  	    cur_level == fault->goal_level &&
>  	    is_shadow_present_pte(spte) &&
>  	    !is_large_pte(spte)) {
> +		struct kvm_mmu_page *sp;
> +		u64 page_mask;
> +
> +		sp = to_shadow_page(spte & PT64_BASE_ADDR_MASK);
> +
> +		/* Prevent lpage_disallowed read from moving ahead. */
> +		smp_rmb();

smp_rmb() needs to be paired with e.g. smp_wmb(), and the comment is supposed to
tie the two together (the reason checkpatch warns about comments is to try and
prevent sprinking bogus barriers everywhere).  These types of barriers always need
to be paired with something, as both the reader(s) and the writer need to have
specific, coordinated ordering.  E.g. reading lpage_disallowed after checking for
a present SPTE is meaningless if the writer doesn't set lpage_disallowed before
setting the SPTE present (which is the purpose of patch 1).  I didn't add the
smp_wmb() in patch 1 because it's not necessary as of that patch, it's only when
the concurrent reader comes along in this patch that the barrier becomes necessary.

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9f73c175845e..041b1ab838f0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2901,7 +2901,12 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_

                sp = to_shadow_page(spte & PT64_BASE_ADDR_MASK);

-               /* Prevent lpage_disallowed read from moving ahead. */
+               /*
+                * Ensure lpage_disallowed is read after checking for a present
+                * SPTE.  A different vCPU may be concurrently installing the
+                * shadow page if mmu_lock is held for read.  Pairs with the
+                * smp_wmb() in kvm_tdp_mmu_map().
+                */
                smp_rmb();

                if (!sp->lpage_disallowed)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 1f44826cf794..2422684f1dc3 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1186,6 +1186,13 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)

                        sp->lpage_disallowed = account_nx;

+                       /*
+                        * Ensure lpage_disallowed is visible before the SP is
+                        * marked present, as mmu_lock is held for read.  Pairs
+                        * with the smp_rmb() in disallowed_hugepage_adjust().
+                        */
+                       smp_wmb();
+
                        if (tdp_mmu_link_sp(kvm, &iter, sp, true)) {
                                tdp_mmu_free_sp(sp);
                                break;

