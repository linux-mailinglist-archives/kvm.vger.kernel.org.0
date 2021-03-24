Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5C03481B6
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 20:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237780AbhCXTQO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 15:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238048AbhCXTPs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 15:15:48 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 495DEC061763
        for <kvm@vger.kernel.org>; Wed, 24 Mar 2021 12:15:47 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id u19so15327920pgh.10
        for <kvm@vger.kernel.org>; Wed, 24 Mar 2021 12:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/kJ7YygRvPPo4EgHv8aSuiyknAVhOHDcZ/c1aMxcE3w=;
        b=Hf4bucpwE9xB0JBep7SQCrYcvn2QErPi7pTB6NazD5B/c1FxRuujj2y6kw8Uj8554R
         +Bl0iz9YNAT93ikYOEOeYC8P5eTXt7nCL41ambFjKK5SVsfAWE/djL3tua90AAAZdqje
         J5R9tYMDGXYP4JxredZSpLm9qxNFEo1Ls3WsP7tytwAYFtFEpyDhKeY0Uzhc4YKX5dBe
         Sa5Eqm9Q7LQKT68CACPqgzgKwFtFz7hZ0khxDiblIrLhCBYzCr5fJXiwBJeSCtrk1Kw7
         lnBQjLrX24qgccV5mYhJp7pPC2dK77DioEL7EDCTO+IGIVR/rRJJa165RcDcH+UHSpLs
         1Mgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/kJ7YygRvPPo4EgHv8aSuiyknAVhOHDcZ/c1aMxcE3w=;
        b=fDQTQVqnkL8ie72wjbm57UHP0ZTmE0hFyJJkfLMb198PdJTXBXOojwR1DuiWLeONfl
         GOxZFxw60wecvyVxrEiwWkNExqol2SlMyOVP0BDP9wUkbdZfU9i9jJYgy7iAVNHZZQhP
         RBVz+/mUuzlw8ukqbAZAGLJ42U7dzIfGh2zozXFlhVnXzUdPT6QRIquY4DSeVUxGYyK4
         kQHTJm/322VwF2AunNrUaFVzZ6BpsJ71gnOXSF5z0tLo4WKvaJhZ7S7iNU+yFSgqRIxQ
         4brOhT3s3+RFJVFRef2HFIzqtKbEoGTAMCd6a/Vnp+q4YVWlKxaphgQCX0CRO+2TBaKJ
         iaOQ==
X-Gm-Message-State: AOAM533PbvIqVOW6KwW5lk9G594qzRBSecza0Hr26TzH6R2FvPSOh4z/
        SyFvr+I3tBwZ4S/NrCL1AuEQGg==
X-Google-Smtp-Source: ABdhPJxZq+BMA7uBzsXBlyN2rzb+GYJSGkSeCfaDBGiIe+9dYM6TPX5hru8TiFD69cW7FXlQY7k74A==
X-Received: by 2002:a63:e214:: with SMTP id q20mr4337778pgh.4.1616613346542;
        Wed, 24 Mar 2021 12:15:46 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id z9sm2896945pgf.87.2021.03.24.12.15.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 12:15:45 -0700 (PDT)
Date:   Wed, 24 Mar 2021 19:15:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH 2/5 v4] KVM: nSVM: Check addresses of MSR and IO
 permission maps
Message-ID: <YFuP3tNOLQfXAY1l@google.com>
References: <20210324175006.75054-1-krish.sadhukhan@oracle.com>
 <20210324175006.75054-3-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324175006.75054-3-krish.sadhukhan@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 24, 2021, Krish Sadhukhan wrote:
> According to section "Canonicalization and Consistency Checks" in APM vol 2,
> the following guest state is illegal:
> 
>     "The MSR or IOIO intercept tables extend to a physical address that
>      is greater than or equal to the maximum supported physical address."
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> ---
>  arch/x86/kvm/svm/nested.c | 28 +++++++++++++++++++++-------
>  1 file changed, 21 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 35891d9a1099..b08d1c595736 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -231,7 +231,15 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
>  	return true;
>  }
>  
> -static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
> +static bool nested_svm_check_bitmap_pa(struct kvm_vcpu *vcpu, u64 pa,
> +				       u8 order)
> +{
> +	u64 last_pa = PAGE_ALIGN(pa) + (PAGE_SIZE << order) - 1;

Ugh, I really wish things that "must" happen were actually enforced by hardware.

  The MSRPM must be aligned on a 4KB boundary... The VMRUN instruction ignores
  the lower 12 bits of the address specified in the VMCB.

So, ignoring an unaligned @pa is correct, but that means
nested_svm_exit_handled_msr() and nested_svm_intercept_ioio() are busted.

> +	return last_pa > pa && !(last_pa >> cpuid_maxphyaddr(vcpu));

Please use kvm_vcpu_is_legal_gpa().

> +}
> +
> +static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
> +				       struct vmcb_control_area *control)
>  {
>  	if ((vmcb_is_intercept(control, INTERCEPT_VMRUN)) == 0)
>  		return false;
> @@ -243,12 +251,18 @@ static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
>  	    !npt_enabled)
>  		return false;
>  
> +	if (!nested_svm_check_bitmap_pa(vcpu, control->msrpm_base_pa,
> +	    MSRPM_ALLOC_ORDER))
> +		return false;
> +	if (!nested_svm_check_bitmap_pa(vcpu, control->iopm_base_pa,
> +	    IOPM_ALLOC_ORDER))

I strongly dislike using the alloc orders, relying on kernel behavior to
represent architectural values it sketchy.  Case in point, IOPM_ALLOC_ORDER is a
16kb size, whereas the actual size of the IOPM is 12kb.  I also called this out
in v1...

https://lkml.kernel.org/r/YAd9MBkpDjC1MY6E@google.com

> +		return false;
> +
>  	return true;
>  }
>  
> -static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb12)
> +static bool nested_vmcb_checks(struct kvm_vcpu *vcpu, struct vmcb *vmcb12)
>  {
> -	struct kvm_vcpu *vcpu = &svm->vcpu;
>  	bool vmcb12_lma;
>  
>  	if ((vmcb12->save.efer & EFER_SVME) == 0)
> @@ -268,10 +282,10 @@ static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb12)
>  		    kvm_vcpu_is_illegal_gpa(vcpu, vmcb12->save.cr3))
>  			return false;
>  	}
> -	if (!kvm_is_valid_cr4(&svm->vcpu, vmcb12->save.cr4))
> +	if (!kvm_is_valid_cr4(vcpu, vmcb12->save.cr4))
>  		return false;
>  
> -	return nested_vmcb_check_controls(&vmcb12->control);
> +	return nested_vmcb_check_controls(vcpu, &vmcb12->control);
>  }
>  
>  static void load_nested_vmcb_control(struct vcpu_svm *svm,
> @@ -515,7 +529,7 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
>  	if (WARN_ON_ONCE(!svm->nested.initialized))
>  		return -EINVAL;
>  
> -	if (!nested_vmcb_checks(svm, vmcb12)) {
> +	if (!nested_vmcb_checks(&svm->vcpu, vmcb12)) {

Please use @vcpu directly.  Looks like this needs a rebase, as the prototype for
nested_svm_vmrun() is wrong relative to kvm/queue.

>  		vmcb12->control.exit_code    = SVM_EXIT_ERR;
>  		vmcb12->control.exit_code_hi = 0;
>  		vmcb12->control.exit_info_1  = 0;
> @@ -1191,7 +1205,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  		goto out_free;
>  
>  	ret = -EINVAL;
> -	if (!nested_vmcb_check_controls(ctl))
> +	if (!nested_vmcb_check_controls(vcpu, ctl))
>  		goto out_free;
>  
>  	/*
> -- 
> 2.27.0
> 
