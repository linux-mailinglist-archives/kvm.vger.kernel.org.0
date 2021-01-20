Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA3292FC60C
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 01:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbhATAq0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 19:46:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbhATAqX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jan 2021 19:46:23 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73806C061573
        for <kvm@vger.kernel.org>; Tue, 19 Jan 2021 16:45:43 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id i63so6339057pfg.7
        for <kvm@vger.kernel.org>; Tue, 19 Jan 2021 16:45:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OiQfP1FY0MVP9VcexBSjuA75vJdRqwc8f0Dci/XAUcc=;
        b=YQeCYVEAi1iYe1fcZLNfFOgKuVU82dAlQUXvc4Bbf6pUqhW1j3IL0qErN5VcdioJWw
         JGmNjQ8EatSag4qO8lm0/czdoUrJwL2LVrV+AAey5ZwREOHLP7xdUOmI3krh2ce30QCV
         XGrCRp0LiDcxZM4i/VKqazoQ/t8UmY/awlRGZ2G+nthlGbIkYk4S6A8Di0ATaDVhWBdh
         fViRSa3Um/34BDPhBMkjjDqa5bo36aSdNM0ywNSVAQ3yei1x7Lr/okOsgAtWdzmMvg0P
         piFvcm7njCPSRUw1t23oO5JdY1+GDT42w4K2sUpxTUp7tIJJG6u41OdFA/bBc9baWF2f
         ugxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OiQfP1FY0MVP9VcexBSjuA75vJdRqwc8f0Dci/XAUcc=;
        b=c93cYrrqO00RuPbsPn5LktRVrwTp9GEwKhl1fMjPk17hUnUSbeg6ErFAs5S8McXUJN
         puswrYGKqSwmPly5WxddLRzvsV6amb1+YaNnSoov/vtdrqOCLTOtVmICH7gnYxUDz4CO
         7E0vuMqiyTrfT3ftmM3PJoS2+eldxUiZ35UsTaDwOgVAxanh/eRn0jWrB1leOBHNbO9x
         eaORz58D1Kadt5cxtFK0/egziLLi2KVuC0DzSrnpbqWPkuq0rr6nKaejRg0or+ByK6ym
         MxfErlHzCQqU1UG15/uypC2Ot6Vsx0qDSJHS2QTH69aF4bD/yhXtDL/TyshX3BKIT3ZL
         kVjg==
X-Gm-Message-State: AOAM5328fVeL2rzF+tBX1Vuj4Tul3Ebs1F3RI3yeG7Yl/CdeG9oLSqZ9
        N9xPQbVeNeYp51ijBzUXZeAPETZIARM4sw==
X-Google-Smtp-Source: ABdhPJy76savpGBuzVLnlsBdBNYNiMx13iEkxrEHaE5KmaHac7YQrWCMJDBTFgebGMAM1+P3otfzWw==
X-Received: by 2002:a63:db05:: with SMTP id e5mr651942pgg.104.1611103542761;
        Tue, 19 Jan 2021 16:45:42 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id o1sm234633pgq.1.2021.01.19.16.45.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 16:45:42 -0800 (PST)
Date:   Tue, 19 Jan 2021 16:45:36 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH 1/3 v2] nSVM: Check addresses of MSR and IO bitmap
Message-ID: <YAd9MBkpDjC1MY6E@google.com>
References: <20210116022039.7316-1-krish.sadhukhan@oracle.com>
 <20210116022039.7316-2-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210116022039.7316-2-krish.sadhukhan@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jan 16, 2021, Krish Sadhukhan wrote:
> According to section "Canonicalization and Consistency Checks" in APM vol 2,
> the following guest state is illegal:
> 
>         "The MSR or IOIO intercept tables extend to a physical address that
>          is greater than or equal to the maximum supported physical address."
> 
> Also check that these addresses are aligned on page boundary.
> 
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> ---
>  arch/x86/kvm/svm/nested.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index cb4c6ee10029..2419f392a13d 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -211,7 +211,8 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
>  	return true;
>  }
>  
> -static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
> +static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
> +				       struct vmcb_control_area *control)
>  {
>  	if ((vmcb_is_intercept(control, INTERCEPT_VMRUN)) == 0)
>  		return false;
> @@ -223,10 +224,15 @@ static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
>  	    !npt_enabled)
>  		return false;
>  
> +	if (!page_address_valid(vcpu, control->msrpm_base_pa))
> +		return false;
> +	if (!page_address_valid(vcpu, control->iopm_base_pa))

These checks are wrong.  The MSRPM is 8kb in size, and the IOPM is 12kb, and the
APM explicitly states that the last byte is checked:

  if the address of the last byte in the table is greater than or equal to the
  maximum supported physical address, this is treated as illegal VMCB state and
  causes a #VMEXIT(VMEXIT_INVALID).

KVM can't check just the last byte, as that would fail to detect a wrap of the
64-bit boundary.  Might be worth adding yet another helper?  I think this will
work, though I'm sure Paolo has a much more clever solution :-)

  static inline bool page_range_valid(struct kvm_vcpu *vcpu, gpa_t gpa, int size)
  {
	gpa_t last_page = gpa + size - PAGE_SIZE;

	if (last_page < gpa)
		return false;

	return page_address_valid(last_page);
  }

Note, the IOPM is 12kb in size, but KVM allocates and initializes 16kb, i.e.
using IOPM_ALLOC_ORDER for the check would be wrong.  Maybe define the actual
size for both bitmaps and use get_order() instead of hardcoding the order?  That
would make it easy to "fix" svm_hardware_setup() so that it doesn't initialize
unused memory.

> +		return false;
> +
>  	return true;
>  }
>  
> -static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb12)
> +static bool nested_vmcb_checks(struct kvm_vcpu *vcpu, struct vmcb *vmcb12)
>  {
>  	bool vmcb12_lma;
>  
> @@ -255,10 +261,10 @@ static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb12)
>  		    (vmcb12->save.cr3 & MSR_CR3_LONG_MBZ_MASK))
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
> @@ -485,7 +491,7 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
>  	if (WARN_ON_ONCE(!svm->nested.initialized))
>  		return -EINVAL;
>  
> -	if (!nested_vmcb_checks(svm, vmcb12)) {
> +	if (!nested_vmcb_checks(&svm->vcpu, vmcb12)) {
>  		vmcb12->control.exit_code    = SVM_EXIT_ERR;
>  		vmcb12->control.exit_code_hi = 0;
>  		vmcb12->control.exit_info_1  = 0;
> @@ -1173,7 +1179,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
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
