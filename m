Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0E2D4FC394
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 19:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348964AbiDKRm5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 13:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243215AbiDKRmc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 13:42:32 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF09220FE
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 10:40:17 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id o5-20020a17090ad20500b001ca8a1dc47aso19099237pju.1
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 10:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sQCHq0FJCQCb202jCqiBkk2qEW8qbj3cAAejjt3ZhIw=;
        b=YNUDkwzrRRqMsBPmWzwwyvclqsWZPjwu/jvI+6MuOHOXGNWhar37TDEgpRsU8TzaDa
         5Ao11aLCPxvj/nrN0ymTJGfTa1e08H9ejWLbyU9zD5mvtLyxG7bKKfNlhtGt1geCxVop
         79XCKePjpuNzPuVxA98+sMF9pnCcrH0mddBq6tfbkLp5AWh0ZFKLscZKU5ULHxbcg07n
         OnSVBtZj0c97O6CpY9wie/kDKgB5tgdnl2y8dMnV/6APk3vj3QF/CoSEBIPxYKt+e11Q
         d0fpmkUsKneUkd0LNzQGuMEBcWoRvwt0S8n7HVgQhLBypr9H1VXcXPLQoF0ZqjLPyVLQ
         4I9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sQCHq0FJCQCb202jCqiBkk2qEW8qbj3cAAejjt3ZhIw=;
        b=jZoHahbo40XpwtA/VWwEmhuYWI+d4UdldlgCTQpwv8nkDISTYnPsHJC1V9dOBJzyhA
         LCNGJKx8LqOS56xCo98+dYz0datF1Bxd+Tnn3oavMAOmrIT7sPoQQOlvvty3eSYx+2eW
         j3FfQ2ygxE8X7tS4HYms1C8UhNcHipcq/LrrG9YO+RvRXvmMgfiUC5hdpX34oZeFdBGm
         CrXAr+ZU5hXDelG+xhbr+7LG19DO/s0KtixjxF72vh2vO7Dqga9YxklWbEEeI6/G2SKw
         l1SCdUZqNvuHquZG2HDEzw1im5XI7Q1SXaCGOrrltWDkGj3EkUmd65+0M1N4Z0w5s490
         ubww==
X-Gm-Message-State: AOAM531JIEOydFCgK8y4oepyDWLeTTS0vZbV9lVw5lgdCS176jBEDG1Y
        /qs3rCn+Sy4hmKuOjYu1Ib8iqA==
X-Google-Smtp-Source: ABdhPJyXR6Mz/4IA9vUqZoo5b52e+z00+XiGJBigvXvxZz4N7sJwtKX3j6nn9XkHEcz6fNsorvdRsA==
X-Received: by 2002:a17:902:a613:b0:156:b53d:c137 with SMTP id u19-20020a170902a61300b00156b53dc137mr33808219plq.73.1649698816643;
        Mon, 11 Apr 2022 10:40:16 -0700 (PDT)
Received: from google.com (226.75.127.34.bc.googleusercontent.com. [34.127.75.226])
        by smtp.gmail.com with ESMTPSA id be11-20020a056a001f0b00b004fb29215dd9sm33801120pfb.30.2022.04.11.10.40.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 10:40:15 -0700 (PDT)
Date:   Mon, 11 Apr 2022 17:40:11 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] KVM: x86/mmu: Properly account NX huge page
 workaround for nonpaging MMUs
Message-ID: <YlRn+8bYsHqNIbTU@google.com>
References: <20220409003847.819686-1-seanjc@google.com>
 <20220409003847.819686-3-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220409003847.819686-3-seanjc@google.com>
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

On Sat, Apr 09, 2022, Sean Christopherson wrote:
> Account and track NX huge pages for nonpaging MMUs so that a future
> enhancement to precisely check if shadow page cannot be replaced by a NX
> huge page doesn't get false positives.  Without correct tracking, KVM can
> get stuck in a loop if an instruction is fetching and writing data on the
> same huge page, e.g. KVM installs a small executable page on the fetch
> fault, replaces it with an NX huge page on the write fault, and faults
> again on the fetch.
> 
> Alternatively, and perhaps ideally, KVM would simply not enforce the
> workaround for nonpaging MMUs.  The guest has no page tables to abuse
> and KVM is guaranteed to switch to a different MMU on CR0.PG being
> toggled so there're no security or performance concerns.  But getting
> make_spte() to play nice now and in the future is unnecessarily complex.
> In the current code base, make_spte() can enforce the mitigation if TDP
> is enabled or the MMU is indirect, but other in-flight patches aim to
> drop the @vcpu param[*].  Without a @vcpu, KVM could either pass in the
> correct information and/or derive it from the shadow page, but the former
> is ugly and the latter subtly non-trivial due to the possitibility of
> direct shadow pages in indirect MMUs.  Given that using shadow paging
> with an unpaged guest is far from top priority in terms of performance,
> _and_ has been subjected to the workaround since its inception, keep it
> simple and just fix the accounting glitch.
> 
> [*] https://lore.kernel.org/all/20220321224358.1305530-5-bgardon@google.com
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu.h      |  9 +++++++++
>  arch/x86/kvm/mmu/mmu.c  |  2 +-
>  arch/x86/kvm/mmu/spte.c | 11 +++++++++++
>  3 files changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 671cfeccf04e..89df062d5921 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -191,6 +191,15 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  		.user = err & PFERR_USER_MASK,
>  		.prefetch = prefetch,
>  		.is_tdp = likely(vcpu->arch.mmu->page_fault == kvm_tdp_page_fault),
> +
> +		/*
> +		 * Note, enforcing the NX huge page mitigation for nonpaging
> +		 * MMUs (shadow paging, CR0.PG=0 in the guest) is completely
> +		 * unnecessary.  The guest doesn't have any page tables to
> +		 * abuse and is guaranteed to switch to a different MMU when
> +		 * CR0.PG is toggled on (may not always be guaranteed when KVM
> +		 * is using TDP).  See make_spte() for details.
> +		 */
>  		.nx_huge_page_workaround_enabled = is_nx_huge_page_enabled(),

hmm. I think there could be a minor issue here (even in original code).
The nx_huge_page_workaround_enabled is attached here with page fault.
However, at the time of make_spte(), we call is_nx_huge_page_enabled()
again. Since this function will directly check the module parameter,
there might be a race condition here. eg., at the time of page fault,
the workround was 'true', while by the time we reach make_spte(), the
parameter was set to 'false'.

I have not figured out what the side effect is. But I feel like the
make_spte() should just follow the information in kvm_page_fault instead
of directly querying the global config.
>
>  		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index d230d2d78ace..9416445afa3e 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2954,7 +2954,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  				      it.level - 1, true, ACC_ALL);
>  
>  		link_shadow_page(vcpu, it.sptep, sp);
> -		if (fault->is_tdp && fault->huge_page_disallowed)
> +		if (fault->huge_page_disallowed)
>  			account_nx_huge_page(vcpu->kvm, sp,
>  					     fault->req_level >= it.level);
>  	}
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 4739b53c9734..14ad821cb0c7 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -115,6 +115,17 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>  	if (!prefetch)
>  		spte |= spte_shadow_accessed_mask(spte);
>  
> +	/*
> +	 * For simplicity, enforce the NX huge page mitigation even if not
> +	 * strictly necessary.  KVM could ignore if the mitigation if paging is
> +	 * disabled in the guest, but KVM would then have to ensure a new MMU
> +	 * is loaded (or all shadow pages zapped) when CR0.PG is toggled on,
> +	 * and that's a net negative for performance when TDP is enabled.  KVM
> +	 * could ignore the mitigation if TDP is disabled and CR0.PG=0, as KVM
> +	 * will always switch to a new MMU if paging is enabled in the guest,
> +	 * but that adds complexity just to optimize a mode that is anything
> +	 * but performance critical.
> +	 */
>  	if (level > PG_LEVEL_4K && (pte_access & ACC_EXEC_MASK) &&
>  	    is_nx_huge_page_enabled()) {
>  		pte_access &= ~ACC_EXEC_MASK;
> -- 
> 2.35.1.1178.g4f1659d476-goog
> 
