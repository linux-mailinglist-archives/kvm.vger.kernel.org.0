Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D99CB5B0C79
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 20:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbiIGSZ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 14:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbiIGSZ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 14:25:57 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1877BBA5A
        for <kvm@vger.kernel.org>; Wed,  7 Sep 2022 11:25:54 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id x1-20020a17090ab00100b001fda21bbc90so19181105pjq.3
        for <kvm@vger.kernel.org>; Wed, 07 Sep 2022 11:25:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=q7D/Z6Bs3er9DCMl6VMbOrWC19uTlXD8Te0jKVH9bfE=;
        b=oEUPqMTgXvhPFGYkREmEGnA+cIUBdzLpeeB2EGvEBY/domNHzeMzopXURXDLL+lPQU
         mnBrOQYPObPumTDgYrxh7R+LKc56pigw0Jy/d/d13NkXLLd1JQa4gLEnZjse340yTMBQ
         ImH3amq6bw8NG9OFghDi3OCl6mEzN6gtN0WYinqHTBG3TcWwSgZmsxBLksFEQCJ1KvWZ
         3fqGJEiwsHmnkcEnEUhwrmzkZelFstFffk8jM5eVeZ8xiDErq7aKQ9mTib6WV7ZudExb
         +vOefT+tfOco/x2ol+vDidKUoAKF7ZXfEtNK+mWwaIwDA87rCNUbaXn88wmmp3g40wZI
         tu0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=q7D/Z6Bs3er9DCMl6VMbOrWC19uTlXD8Te0jKVH9bfE=;
        b=vSTS5H+hAg2k18ulahuPWMWgp28/atZF7oy0tUCGgi1brKRl9PYu+bRyOHWyKEp3Ry
         IP5pRS95eNxbbd7DG+temujVE0slwfjcS/tNKoP0ABIMuxANiMTUhNyFSB0uHVA5ysh0
         2mPypBB9cr9Bb+wBD5H2ZnSX8i7YhwoPi8cLucm6ptbV5JcA1MN2DGU7g35sKgjRWAf7
         aJKbjg3OOXD96+arAd1fuoBKQMy5i8LSdGmgeOw4w50zawN9dbLERyd8gP7mtR6hoNvL
         iJkyS4c9r9x+xrOlwk0iApjBb6WZ/x+1biLm7S8Hq5hNGT/W7OX4eg6H6MTk2GE3M6nh
         kTug==
X-Gm-Message-State: ACgBeo2jkzhIEjQ8ViF5ZRZjfpiua/ngt42+EKrmNBtO55ybIL5Y+vex
        FxXoHK2xr08W7YHBLlourFro47KX/19rZw==
X-Google-Smtp-Source: AA6agR4pRVPppRuzcj+NVbAvfCFcI2n8qoerzcQ+aPYA85pnNIsTXu5xd3ZpSYRSzBaLPxuZkCMfjA==
X-Received: by 2002:a17:90a:9907:b0:1f5:2318:ea6d with SMTP id b7-20020a17090a990700b001f52318ea6dmr5425613pjp.163.1662575153632;
        Wed, 07 Sep 2022 11:25:53 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id 8-20020a17090a000800b001fd77933fb3sm11401627pja.17.2022.09.07.11.25.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 11:25:53 -0700 (PDT)
Date:   Wed, 7 Sep 2022 11:25:42 -0700
From:   David Matlack <dmatlack@google.com>
To:     Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/6] KVM: x86/mmu: Fix wrong start gfn of tlb flushing
 with range
Message-ID: <YxjiJougYfG1seBT@google.com>
References: <cover.1661331396.git.houwenlong.hwl@antgroup.com>
 <888399c78eab9d965657c5983f8096c707664c30.1661331396.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <888399c78eab9d965657c5983f8096c707664c30.1661331396.git.houwenlong.hwl@antgroup.com>
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

On Wed, Aug 24, 2022 at 05:29:21PM +0800, Hou Wenlong wrote:
> When a spte is dropped, the start gfn of tlb flushing should
> be the gfn of spte not the base gfn of SP which contains the
> spte. Also introduce a helper function to do range-based
> flushing when a spte is dropped, which would help prevent
> future buggy use of kvm_flush_remote_tlbs_with_address() in
> such case.
> 
> Fixes: c3134ce240eed ("KVM: Replace old tlb flush function with new one to flush a specified range.")
> Suggested-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> ---
>  arch/x86/kvm/mmu/mmu.c         | 20 +++++++++++++++-----
>  arch/x86/kvm/mmu/paging_tmpl.h |  3 +--
>  2 files changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 3bcff56df109..e0b9432b9491 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -260,6 +260,18 @@ void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
>  	kvm_flush_remote_tlbs_with_range(kvm, &range);
>  }
>  
> +static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index);
> +
> +/* Flush the range of guest memory mapped by the given SPTE. */
> +static void kvm_flush_remote_tlbs_sptep(struct kvm *kvm, u64 *sptep)
> +{
> +	struct kvm_mmu_page *sp = sptep_to_sp(sptep);
> +	gfn_t gfn = kvm_mmu_page_get_gfn(sp, spte_index(sptep));
> +
> +	kvm_flush_remote_tlbs_with_address(kvm, gfn,
> +					   KVM_PAGES_PER_HPAGE(sp->role.level));

How is the range-based TLB flushing supposed to work with indirect MMUs?
When KVM is using shadow paging, the gfn here is not part of the actual
translation.

For example, when TDP is disabled, KVM's shadow page tables translate
GVA to HPA. When Nested Virtualization is in use and running L2, KVM's
shadow page tables translate nGPA to HPA.

Ah, I see x86_ops.tlb_remote_flush_with_range is only set when running
on Hyper-V and TDP is enabled (VMX checks enable_ept and SVM checks
npt_enabled). But it looks like the nested case might still be broken?

> +}
> +
>  /* Flush all memory mapped by the given direct SP. */
>  static void kvm_flush_remote_tlbs_direct_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
>  {
> @@ -1156,8 +1168,7 @@ static void drop_large_spte(struct kvm *kvm, u64 *sptep, bool flush)
>  	drop_spte(kvm, sptep);
>  
>  	if (flush)
> -		kvm_flush_remote_tlbs_with_address(kvm, sp->gfn,
> -			KVM_PAGES_PER_HPAGE(sp->role.level));
> +		kvm_flush_remote_tlbs_sptep(kvm, sptep);
>  }
>  
>  /*
> @@ -1608,7 +1619,7 @@ static void __rmap_add(struct kvm *kvm,
>  	if (rmap_count > RMAP_RECYCLE_THRESHOLD) {
>  		kvm_zap_all_rmap_sptes(kvm, rmap_head);
>  		kvm_flush_remote_tlbs_with_address(
> -				kvm, sp->gfn, KVM_PAGES_PER_HPAGE(sp->role.level));
> +				kvm, gfn, KVM_PAGES_PER_HPAGE(sp->role.level));
>  	}
>  }
>  
> @@ -6402,8 +6413,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
>  			kvm_zap_one_rmap_spte(kvm, rmap_head, sptep);
>  
>  			if (kvm_available_flush_tlb_with_range())
> -				kvm_flush_remote_tlbs_with_address(kvm, sp->gfn,
> -					KVM_PAGES_PER_HPAGE(sp->role.level));
> +				kvm_flush_remote_tlbs_sptep(kvm, sptep);
>  			else
>  				need_tlb_flush = 1;
>  
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 39e0205e7300..04149c704d5b 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -937,8 +937,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
>  
>  			mmu_page_zap_pte(vcpu->kvm, sp, sptep, NULL);
>  			if (is_shadow_present_pte(old_spte))
> -				kvm_flush_remote_tlbs_with_address(vcpu->kvm,
> -					sp->gfn, KVM_PAGES_PER_HPAGE(sp->role.level));
> +				kvm_flush_remote_tlbs_sptep(vcpu->kvm, sptep);
>  
>  			if (!rmap_can_add(vcpu))
>  				break;
> -- 
> 2.31.1
> 
