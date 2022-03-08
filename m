Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D46D34D1F41
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 18:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349239AbiCHRmU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 12:42:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349229AbiCHRmS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 12:42:18 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 924FC53702
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 09:41:21 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id k92so8754169pjh.5
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 09:41:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rEjzn09eYdcPw8zgSp9GRXhCcrP0HGBMdICZ+yuOnPA=;
        b=rT2oKUw8j6AboD5zninI0fTWpt+shY+0HAQaCJeMq1tUrPZTtw1w2b1ZN3vWavLtNn
         sOyBYDvqMYKmRgXrehd7tkx351JCXu8evyfalFzOYktxpY6Wm+TWpnazMGuGGELa//KS
         eeZMKazhUxCvEp1YoHNXr0wcRZ4i/aDJIWsTxNB2dvVzGnsUwDlS1Fm9msjgGqrOPfMt
         r+b4ufhEy9lHSI1m0nKPj3Hd1sE8l2lD76Fkr26kMiXq7TLAEYEUA46+o3Uyg5Ae7bwe
         Tbe4bHsyohU9gCDC4LyYwslN8wtUIyPQELNkpRngiKg1WlduxDX3jfi3aNizWsdUs2nK
         WxJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rEjzn09eYdcPw8zgSp9GRXhCcrP0HGBMdICZ+yuOnPA=;
        b=Jr5YdDPYf3qES1ECiHa0tkF8XoWxnidDfk6LQ4xMO676K4YTuk/65+/964Ji6K/zED
         SnJY3Hh6Auy3wjiEDUJVYSWcpT8BlQ8uTlj5uMkux1ff3No6urbX+xaHMwaBxZShJiA2
         xZw5auddHFewWVete4Wug83U0Q1f7KNtFr3Gahuhu4LpKanF+LaOoRJNQQZuKKl7GO1Y
         n6kPwre4uXgA7bUmUilTfXOtpV03ljOa4tXfq9orj2YEKf0LYdZ/KEOhm7B8Ei2VmCT8
         eBKHl4rnGKr1phxWsfCFW1J3X6zoeyboPCASc87j+e51m32pzPco5FNhzPHjRvYm0SLc
         bvqA==
X-Gm-Message-State: AOAM530YUXG535J1BZGf5cL2xCDtVQeTgY++DohBeN/f/Gd0ugZ+nn1F
        oHEl6iMTuE5bmV7YAe/oXQEtZg==
X-Google-Smtp-Source: ABdhPJxjjdilHkK2/7OlLGWa+ROoJM0h25Zlo6kuCVIsMv0zAfwBnHUy/lIP+qwJUeyYd66AvrHRYA==
X-Received: by 2002:a17:90b:4a92:b0:1bf:2a03:987c with SMTP id lp18-20020a17090b4a9200b001bf2a03987cmr5794219pjb.186.1646761280899;
        Tue, 08 Mar 2022 09:41:20 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 1-20020a17090a1a0100b001bf3ba1508fsm3565283pjk.33.2022.03.08.09.41.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 09:41:20 -0800 (PST)
Date:   Tue, 8 Mar 2022 17:41:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dmatlack@google.com
Subject: Re: [PATCH v2 09/25] KVM: x86/mmu: do not recompute root level from
 kvm_mmu_role_regs
Message-ID: <YieVPL2rwAQGB+cj@google.com>
References: <20220221162243.683208-1-pbonzini@redhat.com>
 <20220221162243.683208-10-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221162243.683208-10-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 21, 2022, Paolo Bonzini wrote:
> The root_level can be found in the cpu_mode (in fact the field
> is superfluous and could be removed, but one thing at a time).
> Since there is only one usage left of role_regs_to_root_level,
> inline it into kvm_calc_cpu_mode.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 23 ++++++++---------------
>  1 file changed, 8 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 1af898f0cf87..6e539fc2c9c7 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -244,19 +244,6 @@ static struct kvm_mmu_role_regs vcpu_to_role_regs(struct kvm_vcpu *vcpu)
>  	return regs;
>  }
>  
> -static int role_regs_to_root_level(const struct kvm_mmu_role_regs *regs)
> -{
> -	if (!____is_cr0_pg(regs))
> -		return 0;
> -	else if (____is_efer_lma(regs))
> -		return ____is_cr4_la57(regs) ? PT64_ROOT_5LEVEL :
> -					       PT64_ROOT_4LEVEL;
> -	else if (____is_cr4_pae(regs))
> -		return PT32E_ROOT_LEVEL;
> -	else
> -		return PT32_ROOT_LEVEL;
> -}
> -
>  static inline bool kvm_available_flush_tlb_with_range(void)
>  {
>  	return kvm_x86_ops.tlb_remote_flush_with_range;
> @@ -4695,7 +4682,13 @@ kvm_calc_cpu_mode(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
>  		role.base.smep_andnot_wp = ____is_cr4_smep(regs) && !____is_cr0_wp(regs);
>  		role.base.smap_andnot_wp = ____is_cr4_smap(regs) && !____is_cr0_wp(regs);
>  		role.base.has_4_byte_gpte = !____is_cr4_pae(regs);
> -		role.base.level = role_regs_to_root_level(regs);
> +
> +		if (____is_efer_lma(regs))
> +			role.base.level = ____is_cr4_la57(regs) ? PT64_ROOT_5LEVEL : PT64_ROOT_4LEVEL;

Can we wrap this, even if indentation is reduced?  I find it much easier to quickly
understand the if-else paths if they're stacked and not run out to almost 100 chars.

	if (____is_efer_lma(regs))
		role.base.level = ____is_cr4_la57(regs) ? PT64_ROOT_5LEVEL :
							  PT64_ROOT_4LEVEL;
	else if (____is_cr4_pae(regs))
		role.base.level = PT32E_ROOT_LEVEL;
	else
		role.base.level = PT32_ROOT_LEVEL;

> +		else if (____is_cr4_pae(regs))
> +			role.base.level = PT32E_ROOT_LEVEL;
> +		else
> +			role.base.level = PT32_ROOT_LEVEL;
>  
>  		role.ext.cr0_pg = 1;
>  		role.ext.cr4_pae = ____is_cr4_pae(regs);
> @@ -4790,7 +4783,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
>  	context->get_guest_pgd = kvm_get_guest_cr3;
>  	context->get_pdptr = kvm_pdptr_read;
>  	context->inject_page_fault = kvm_inject_page_fault;
> -	context->root_level = role_regs_to_root_level(regs);
> +	context->root_level = cpu_mode.base.level;
>  
>  	if (!is_cr0_pg(context))
>  		context->gva_to_gpa = nonpaging_gva_to_gpa;
> -- 
> 2.31.1
> 
> 
