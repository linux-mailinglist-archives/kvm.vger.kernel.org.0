Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73A104A9F6C
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 19:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377712AbiBDSpn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 13:45:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377783AbiBDSpm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Feb 2022 13:45:42 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A25C06173D
        for <kvm@vger.kernel.org>; Fri,  4 Feb 2022 10:45:42 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id g15-20020a17090a67cf00b001b7d5b6bedaso6886160pjm.4
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 10:45:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gf593opMzUkEFK3tkBnZbu7cRzsoKyOlw/rIRToe0ac=;
        b=VpJq89SA99pGTZGihoJEHsjwAxCgw8CctLfFMpaUDVIKjP8gqFG9tVsMjC7svKnYKw
         GQNJvU89pauWdxt168WBcwO+6ppmytdvoyEMO1x84ZwuAVmXs3x0KMTGQmfnneGXecGG
         L/TFbujMiuZdM67Zo6685pkixvqD1Dx2iD3ryJyJ9H9pzjfKJNc8gH9qvC42w/zL7GB9
         Hjy0NQQBF+NZxGKW3NBgMaJw0CspDifVu4+K4AHbGlLPRGzcgBI9ns04VRoZ8kLFh40U
         PeOHOeuNlEBxm5KHwBpbvNGXTP3HLFaW5IfQeA4PbRe/y24NMwL3eSfE8BsXABeo/1at
         1/mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gf593opMzUkEFK3tkBnZbu7cRzsoKyOlw/rIRToe0ac=;
        b=VzbJVNjPx6MR/c6rg5p+XOz5t0PgBHkCOn0CTOqOqs5Yjzy2TSMp+Fm8RiVz1KDXez
         BswJ3iIu4fyvyTlubQtV12lEfEKcCxsvFgHgDWXRjnA9pIkHyohmvKlCcAGm0tt5iyzi
         mOZtF1K4pAgH5KJ+AdpPkSXbvxeqbxJkR6CvWqGY6RAu3bBX45A7uawbYaCFfYW8+jZK
         QBPjDzMn606UqZk+acGdTWlXcUm70+iDIDq+CAg1zWzcB2VXTJRvjzdA0QS+/393rgVM
         D70S1JZd1TfHhvyOGSZk1LyDyzFC9q0ClsGc1gsITEcoJnGsVXfjU3beBw0TTfJVWnql
         PrcA==
X-Gm-Message-State: AOAM532FTcQr8SuRuidu/InqhkMzZg6cFLWhhXy+wZgKEKlm/8cJ/06u
        f+LRV8L4iQeXbzl8GjmM7jR4jQ==
X-Google-Smtp-Source: ABdhPJycSLWY7IYjsj5ZtRStDt5vmI7UjLZM7E0uZrthMB0W8a2jlm/J4AQbWFoKIMVQbh0bXEbArQ==
X-Received: by 2002:a17:90b:1016:: with SMTP id gm22mr4680992pjb.155.1644000341823;
        Fri, 04 Feb 2022 10:45:41 -0800 (PST)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id u19sm3340304pfi.150.2022.02.04.10.45.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 10:45:40 -0800 (PST)
Date:   Fri, 4 Feb 2022 18:45:37 +0000
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, vkuznets@redhat.com
Subject: Re: [PATCH 05/23] KVM: MMU: pull computation of kvm_mmu_role_regs to
 kvm_init_mmu
Message-ID: <Yf10UbHmV85rFz6G@google.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
 <20220204115718.14934-6-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204115718.14934-6-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 04, 2022 at 06:57:00AM -0500, Paolo Bonzini wrote:
> The init_kvm_*mmu functions, with the exception of shadow NPT,
> do not need to know the full values of CR0/CR4/EFER; they only
> need to know the bits that make up the "role".  This cleanup
> however will take quite a few incremental steps.  As a start,
> pull the common computation of the struct kvm_mmu_role_regs
> into their caller: all of them extract the struct from the vcpu
> as the very first step.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 33 +++++++++++++++++----------------
>  1 file changed, 17 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 3add9d8b0630..577e70509510 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4736,12 +4736,12 @@ kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
>  	return role;
>  }
>  
> -static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
> +static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
> +			     const struct kvm_mmu_role_regs *regs)
>  {
>  	struct kvm_mmu *context = &vcpu->arch.root_mmu;
> -	struct kvm_mmu_role_regs regs = vcpu_to_role_regs(vcpu);
>  	union kvm_mmu_role new_role =
> -		kvm_calc_tdp_mmu_root_page_role(vcpu, &regs, false);
> +		kvm_calc_tdp_mmu_root_page_role(vcpu, regs, false);
>  
>  	if (new_role.as_u64 == context->mmu_role.as_u64)
>  		return;
> @@ -4755,7 +4755,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
>  	context->get_guest_pgd = get_cr3;
>  	context->get_pdptr = kvm_pdptr_read;
>  	context->inject_page_fault = kvm_inject_page_fault;
> -	context->root_level = role_regs_to_root_level(&regs);
> +	context->root_level = role_regs_to_root_level(regs);
>  
>  	if (!is_cr0_pg(context))
>  		context->gva_to_gpa = nonpaging_gva_to_gpa;
> @@ -4803,7 +4803,7 @@ kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu,
>  }
>  
>  static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *context,
> -				    struct kvm_mmu_role_regs *regs,
> +				    const struct kvm_mmu_role_regs *regs,
>  				    union kvm_mmu_role new_role)
>  {
>  	if (new_role.as_u64 == context->mmu_role.as_u64)
> @@ -4824,7 +4824,7 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
>  }
>  
>  static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
> -				struct kvm_mmu_role_regs *regs)
> +				const struct kvm_mmu_role_regs *regs)
>  {
>  	struct kvm_mmu *context = &vcpu->arch.root_mmu;
>  	union kvm_mmu_role new_role =
> @@ -4845,7 +4845,7 @@ static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
>  
>  static union kvm_mmu_role
>  kvm_calc_shadow_npt_root_page_role(struct kvm_vcpu *vcpu,
> -				   struct kvm_mmu_role_regs *regs)
> +				   const struct kvm_mmu_role_regs *regs)

Should these go in the previous commit? Aside from that,

Reviewed-by: David Matlack <dmatlack@google>

>  {
>  	union kvm_mmu_role role =
>  		kvm_calc_shadow_root_page_role_common(vcpu, regs, false);
> @@ -4930,12 +4930,12 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
>  }
>  EXPORT_SYMBOL_GPL(kvm_init_shadow_ept_mmu);
>  
> -static void init_kvm_softmmu(struct kvm_vcpu *vcpu)
> +static void init_kvm_softmmu(struct kvm_vcpu *vcpu,
> +			     const struct kvm_mmu_role_regs *regs)
>  {
>  	struct kvm_mmu *context = &vcpu->arch.root_mmu;
> -	struct kvm_mmu_role_regs regs = vcpu_to_role_regs(vcpu);
>  
> -	kvm_init_shadow_mmu(vcpu, &regs);
> +	kvm_init_shadow_mmu(vcpu, regs);
>  
>  	context->get_guest_pgd     = get_cr3;
>  	context->get_pdptr         = kvm_pdptr_read;
> @@ -4959,10 +4959,9 @@ kvm_calc_nested_mmu_role(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *
>  	return role;
>  }
>  
> -static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
> +static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
>  {
> -	struct kvm_mmu_role_regs regs = vcpu_to_role_regs(vcpu);
> -	union kvm_mmu_role new_role = kvm_calc_nested_mmu_role(vcpu, &regs);
> +	union kvm_mmu_role new_role = kvm_calc_nested_mmu_role(vcpu, regs);
>  	struct kvm_mmu *g_context = &vcpu->arch.nested_mmu;
>  
>  	if (new_role.as_u64 == g_context->mmu_role.as_u64)
> @@ -5002,12 +5001,14 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
>  
>  void kvm_init_mmu(struct kvm_vcpu *vcpu)
>  {
> +	struct kvm_mmu_role_regs regs = vcpu_to_role_regs(vcpu);
> +
>  	if (mmu_is_nested(vcpu))
> -		init_kvm_nested_mmu(vcpu);
> +		init_kvm_nested_mmu(vcpu, &regs);
>  	else if (tdp_enabled)
> -		init_kvm_tdp_mmu(vcpu);
> +		init_kvm_tdp_mmu(vcpu, &regs);
>  	else
> -		init_kvm_softmmu(vcpu);
> +		init_kvm_softmmu(vcpu, &regs);
>  }
>  EXPORT_SYMBOL_GPL(kvm_init_mmu);
>  
> -- 
> 2.31.1
> 
> 
