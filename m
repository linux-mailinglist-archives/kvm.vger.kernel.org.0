Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42AC557E8A3
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 22:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbiGVU7R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 16:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234547AbiGVU7J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 16:59:09 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 042FBAF941
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 13:59:03 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id f11so5338950pgj.7
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 13:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sRtc60bVHDuSQyy9YfLGbb/EZRQBkQQyTX+neLttrJI=;
        b=VT9WZjGGoaYO6wyINeAk1IALZT19I8nvGaJlOLvSTsMGMXO2aI48bLngF7CtjZAvoY
         Nk4dj0ETYHZSQT86zOPNHYg7GeO54xGWEIJhFv/C0BrBO+t5mqhus74Y4xbk+8fyul8M
         HfArgcswQSvdoHC84nrbwn2mXJxz+9qFiCBQ69YkVOPUHk9BdnilnJfVEOdrt3RS3CJ4
         +mBwVu+wySOMJ/nQcZ/3u7v3umsb304sjJE7eni7WKU27HJWuFzI6grkrasDGOuFewyR
         5YIPM89seaz3zWvRqyMCiwRGPEmx5/kbjcwH21G8dckWuQ/kFANi+7LycZSgyao947dV
         do6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sRtc60bVHDuSQyy9YfLGbb/EZRQBkQQyTX+neLttrJI=;
        b=F7wJb3GRtuzjKX+aOVf51AYAOydWoAxnhNG+W1lQWlAhSTvhEtf2Xi0QX/XUBoN46p
         hsXGflQ/XwdaPptIfmoJPMfMGpFnqhOV+q3IKdXSmWr8Uwh6PzrpJJ0wf03vgaFYCSTg
         0sRkTFP+Kpc1o7fSuY43H7HGGFsfoUqConglMLNo3tXlpxPSetcMZTTHGvXY7aOHeySD
         fUtwVBe3YlGyKLxiRy+XU24TxeDjkTg468bC0cmO3R89R1ndgsuFRo5zqboBgC25TNeD
         ycAAlsQChyu5exB26AGSClLUzzN2P6KLkfMxLabNY15lRmABstK54KNO0eFfAWEzuVws
         wWmQ==
X-Gm-Message-State: AJIora9fwzYpUi0BEsqyu/ZPg0VlBNZ/lkiMNZQQkvNZ/K2Fjjeqqvwc
        nu5gFaGdOdOPIFJKrMiw5FTioA==
X-Google-Smtp-Source: AGRyM1tTvyJodPHKaLxzuJZFM95uuASDg1Sh5BgVVmp6RF38yEdu4iqgj2c7B6w9K0El2nFlSq1YJQ==
X-Received: by 2002:a63:6a45:0:b0:419:cb1b:891b with SMTP id f66-20020a636a45000000b00419cb1b891bmr1367197pgc.135.1658523543280;
        Fri, 22 Jul 2022 13:59:03 -0700 (PDT)
Received: from google.com (59.39.145.34.bc.googleusercontent.com. [34.145.39.59])
        by smtp.gmail.com with ESMTPSA id d26-20020a634f1a000000b004088f213f68sm3893786pgb.56.2022.07.22.13.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 13:59:02 -0700 (PDT)
Date:   Fri, 22 Jul 2022 20:58:59 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Oliver Upton <oupton@google.com>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v4 3/4] KVM: x86/mmu: count KVM mmu usage in secondary
 pagetable stats.
Message-ID: <YtsPk5+hZNMEwT0c@google.com>
References: <20220429201131.3397875-1-yosryahmed@google.com>
 <20220429201131.3397875-4-yosryahmed@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220429201131.3397875-4-yosryahmed@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 29, 2022, Yosry Ahmed wrote:
> Count the pages used by KVM mmu on x86 for in secondary pagetable stats.
> 
> For the legacy mmu, accounting pagetable stats is combined KVM's
> existing for mmu pages in newly introduced kvm_[un]account_mmu_page()
> helpers.
> 
> For tdp mmu, introduce new tdp_[un]account_mmu_page() helpers. That
> combines accounting pagetable stats with the tdp_mmu_pages counter
> accounting.
> 
> tdp_mmu_pages counter introduced in this series [1]. This patch was
> rebased on top of the first two patches in that series.
> 
> [1]https://lore.kernel.org/lkml/20220401063636.2414200-1-mizhang@google.com/
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> ---

It looks like there are two metrics for mmu in x86: one for shadow mmu
and the other for TDP mmu. Is there any plan to merge them together?

>  arch/x86/kvm/mmu/mmu.c     | 16 ++++++++++++++--
>  arch/x86/kvm/mmu/tdp_mmu.c | 16 ++++++++++++++--
>  2 files changed, 28 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 78d8e1d8fb99..e5b0e826445d 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1679,6 +1679,18 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, long nr)
>  	percpu_counter_add(&kvm_total_used_mmu_pages, nr);
>  }
>  
> +static void kvm_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> +{
> +	kvm_mod_used_mmu_pages(kvm, +1);
> +	kvm_account_pgtable_pages((void *)sp->spt, +1);
> +}
> +
> +static void kvm_unaccount_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> +{
> +	kvm_mod_used_mmu_pages(kvm, -1);
> +	kvm_account_pgtable_pages((void *)sp->spt, -1);
> +}
> +
>  static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
>  {
>  	MMU_WARN_ON(!is_empty_shadow_page(sp->spt));
> @@ -1734,7 +1746,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct
>  	 */
>  	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
>  	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
> -	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
> +	kvm_account_mmu_page(vcpu->kvm, sp);
>  	return sp;
>  }
>  
> @@ -2363,7 +2375,7 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
>  			list_add(&sp->link, invalid_list);
>  		else
>  			list_move(&sp->link, invalid_list);
> -		kvm_mod_used_mmu_pages(kvm, -1);
> +		kvm_unaccount_mmu_page(kvm, sp);
>  	} else {
>  		/*
>  		 * Remove the active root from the active page list, the root
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 3456277ade18..6295c4da5dee 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -371,6 +371,18 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
>  	}
>  }
>  
> +static void tdp_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> +{
> +	atomic64_inc(&kvm->arch.tdp_mmu_pages);
> +	kvm_account_pgtable_pages((void *)sp->spt, +1);
> +}
> +
> +static void tdp_unaccount_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> +{
> +	atomic64_dec(&kvm->arch.tdp_mmu_pages);
> +	kvm_account_pgtable_pages((void *)sp->spt, -1);
> +}
> +
>  /**
>   * tdp_mmu_unlink_sp() - Remove a shadow page from the list of used pages
>   *
> @@ -383,7 +395,7 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
>  static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
>  			      bool shared)
>  {
> -	atomic64_dec(&kvm->arch.tdp_mmu_pages);
> +	tdp_unaccount_mmu_page(kvm, sp);
>  
>  	if (!sp->lpage_disallowed)
>  		return;
> @@ -1121,7 +1133,7 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
>  		tdp_mmu_set_spte(kvm, iter, spte);
>  	}
>  
> -	atomic64_inc(&kvm->arch.tdp_mmu_pages);
> +	tdp_account_mmu_page(kvm, sp);
>  
>  	return 0;
>  }
> -- 
> 2.36.0.464.gb9c8b46e94-goog
> 
