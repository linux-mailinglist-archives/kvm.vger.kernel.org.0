Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 926C32F5152
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 18:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727738AbhAMRob (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 12:44:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726996AbhAMRob (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jan 2021 12:44:31 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC11C061786
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 09:43:50 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id b5so1640666pjk.2
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 09:43:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oaQsNjRhoAZl0RHvyLWlkaLr8NJpjR0ZxqlStJNcrdc=;
        b=WqZWrb5UHj5b0aWUa9pk9U2Xj9H/NTDHJIfjzVcUdJygLURobZuic53cjYMAotxknz
         S94TNSqBz8mdQh/tThZz0Eq+NHxWMQNHUdAt0ceo/XNopsnDnsJXiaosDQeNG9GFYvAR
         OXSibBk3tqw1gwvAADA4qqzXxjRtmSbxbFCQ02dBqhXneKnzMsdU9eFuPdRT0E7LjnPd
         X/no9ZEISTRdF5w2HVzD1XjCvXHpkxn36SFpO/r42sdQ5FTl2p9La07gZvvvrBTtVcFE
         9Xz1cc+hKqRYluJj/96wkpMSWzAuWWPxXU32h9Vq+OA374EogJ6BtTmNIrrOoFcq0L9H
         titw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oaQsNjRhoAZl0RHvyLWlkaLr8NJpjR0ZxqlStJNcrdc=;
        b=DA7XAc9c0WhhQnEHXVNH4g4vrpAkQh4uR5l7febZywFKcFQP+HLDSo2g9xeTlJKEgM
         YRqmAraIKzBAjXsxNENKSwhfIpJp/lpM49r53vZLgbGen3tdawBbR4YnyLRXx32L1Wvm
         RslwK5bJ1qS0Kol/IvzT45KPYUndob9k8cDjsOU1KE3x22lTCNvadpR9jdcHveWtChkp
         KMOodXChRSCe80xmwmyk7s6YVUVo9BOXQSIT3UaR52C1g1CDMLqkxKDEbD9OeXfsqOsp
         pad3qEAY6rRJPiK0tzzQA7/4hprWUSgJSZbiMtCXCuDf2HmCBdMUyo0mmjxwCWUIO4s6
         gS5Q==
X-Gm-Message-State: AOAM5328zcVhPrwVCActxu6ClrqMOX1DRi1x2WlFUlOSmmOIdywbcsuB
        hG+Pi074WyTlRxyTubiHVYTnbA==
X-Google-Smtp-Source: ABdhPJyAtaSBZByfyseG0SRnazL5WBot5iqKUru1F60RCWbTFIpk0Z4HhIJXrQHy00arCnnYaUia8A==
X-Received: by 2002:a17:90b:1901:: with SMTP id mp1mr361420pjb.233.1610559829517;
        Wed, 13 Jan 2021 09:43:49 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id d6sm3064181pfd.69.2021.01.13.09.43.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 09:43:48 -0800 (PST)
Date:   Wed, 13 Jan 2021 09:43:42 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH 1/3] KVM: nSVM: Check addresses of MSR and IO bitmap
Message-ID: <X/8xTqMVtznyB8sN@google.com>
References: <20210113024633.8488-1-krish.sadhukhan@oracle.com>
 <20210113024633.8488-2-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113024633.8488-2-krish.sadhukhan@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 13, 2021, Krish Sadhukhan wrote:
> According to section "Canonicalization and Consistency Checks" in APM vol 2,
> the following guest state is illegal:
> 
>     "The MSR or IOIO intercept tables extend to a physical address that
>      is greater than or equal to the maximum supported physical address."
> 
> Also check that these addresses are aligned on page boundary.
> 
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> ---
>  arch/x86/kvm/svm/nested.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index cb4c6ee10029..389a8108ddb5 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -211,8 +211,11 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
>  	return true;
>  }
>  
> -static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
> +static bool nested_vmcb_check_controls(struct vcpu_svm *svm,

It's probably worth passing vcpu instead of svm.  svm_set_nested_state() already
takes vcpu, and nested_vmcb_checks() could easily do the same (in a separate
cleanup), especially if nested_svm_vmrun() were cleaned up to capture vcpu in a
local variable instead of constantly doing &svm->vcpu.

> +				       struct vmcb_control_area *control)
>  {
> +	int maxphyaddr;
> +
>  	if ((vmcb_is_intercept(control, INTERCEPT_VMRUN)) == 0)
>  		return false;
>  
> @@ -223,6 +226,14 @@ static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
>  	    !npt_enabled)
>  		return false;
>  
> +	maxphyaddr = cpuid_maxphyaddr(&svm->vcpu);
> +	if (!IS_ALIGNED(control->msrpm_base_pa, PAGE_SIZE) ||
> +	    control->msrpm_base_pa >> maxphyaddr)

These can use page_address_valid().

Unrelated to this patch, we really should consolidate all the different flavors
of open-coded variants of maxphyaddr checks to use kvm_vcpu_is_illegal_gpa(),
and maybe add a helper to do an arbitrary alignment check.  VMX has a handful of
checks that fit that pattern and aren't exactly intuitive at first glance.

We could also add a kvm_vcpu_rsvd_gpa_bits() too.  Somehow even that has
multiple open-coded variants.

I'll add those cleanups to the todo list.

> +		return false;
> +	if (!IS_ALIGNED(control->iopm_base_pa, PAGE_SIZE) ||
> +	    control->iopm_base_pa >> maxphyaddr)
> +		return false;
> +
>  	return true;
>  }
>  
> @@ -258,7 +269,7 @@ static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb12)
>  	if (!kvm_is_valid_cr4(&svm->vcpu, vmcb12->save.cr4))
>  		return false;
>  
> -	return nested_vmcb_check_controls(&vmcb12->control);
> +	return nested_vmcb_check_controls(svm, &vmcb12->control);
>  }
>  
>  static void load_nested_vmcb_control(struct vcpu_svm *svm,
> @@ -1173,7 +1184,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  		goto out_free;
>  
>  	ret = -EINVAL;
> -	if (!nested_vmcb_check_controls(ctl))
> +	if (!nested_vmcb_check_controls(svm, ctl))
>  		goto out_free;
>  
>  	/*
> -- 
> 2.27.0
> 
