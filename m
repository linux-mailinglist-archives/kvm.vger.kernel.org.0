Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB0937AC17
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 18:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbhEKQiY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 12:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbhEKQiX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 12:38:23 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB27C06174A
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 09:37:16 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id i190so16423671pfc.12
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 09:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3bG2YjHFxw2IUcvWWfrYi6Mn8YwbVedGoWY/g26m+0M=;
        b=OM2kuCVzGBNZXt25qURATdM5R+e8BKXX2FSii4MeTP64ksBnqzdwtZxZZub8LgzhXa
         N6yoEfBNNEg4YSvLoYQZerPBHD3LImYN0s5qXSg1BhtXkSNH2Ah1ZGi6u5amDqeoigHM
         aIHEodLagPxqE+6Vy5Uwnlzp1Mnq+4EJjhVRjxK7HH5lYjPxaNL3W8PVZZUqsGhZ3J/v
         h97cCGwu5fPbep2a2KJO1WHcKoY6f1ADEQcYeHuSYl7CoUJGwR3dfmffNVh5lbmOJaxO
         maNxrYdESRWDJaoQhwvBULekqvqUwV4gL6qF4uf5b9bne1go7ozn7wuPnJw6zSz7EZGH
         5LCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3bG2YjHFxw2IUcvWWfrYi6Mn8YwbVedGoWY/g26m+0M=;
        b=fHRpbf95gmoeXw3nnwaBvzc/64IfkdkA9f7JoJSPxXNtQS4IhatG3w8vxgTsSManKY
         CfDAtEeZ1XBZRQrctq0ZYqRuPqW7P2mAQrRk/pdyezMIg5fZQvzpkJNm6K3HRTm+Bkx+
         dL/l6Ihw39TEaWCrOMdOZiyLyaRor+TZR9lh/69kdbfE+mK9VgC3B4c4fCCR8P9cvaMY
         d5lUQXwB7meQos4DvI4qgPBV11wHRZHx0s/L3qgu03SEHDe9rCfT3xRg/gvHVsO17LDo
         JleAtOz2rNCOvLGFdj+Nj52QTvdFDDSEZuQQ8NRdMixRapp4GedVff8HErahYfokFFgF
         lKng==
X-Gm-Message-State: AOAM533nTsjcHZoiK/cGqzV4tc7vZEk5HAksOX7CqAQHbNM2d90ewyNQ
        RAwXrOgQi5tbwJaybNL9CwN9CA==
X-Google-Smtp-Source: ABdhPJwbonQdlDKxDyuS4GYe9D4jlnb7qNRNzXU/ISmqKwx9QJ0asZNITRb8jXZo8SKoqH1pfhwDnA==
X-Received: by 2002:a63:575a:: with SMTP id h26mr32432818pgm.35.1620751036132;
        Tue, 11 May 2021 09:37:16 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id t1sm14049000pjo.33.2021.05.11.09.37.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 09:37:15 -0700 (PDT)
Date:   Tue, 11 May 2021 16:37:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 3/7] KVM: nVMX: Ignore 'hv_clean_fields' data when eVMCS
 data is copied in vmx_get_nested_state()
Message-ID: <YJqytyu7+Q7+bqeG@google.com>
References: <20210511111956.1555830-1-vkuznets@redhat.com>
 <20210511111956.1555830-4-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511111956.1555830-4-vkuznets@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 11, 2021, Vitaly Kuznetsov wrote:
> 'Clean fields' data from enlightened VMCS is only valid upon vmentry: L1
> hypervisor is not obliged to keep it up-to-date while it is mangling L2's
> state, KVM_GET_NESTED_STATE request may come at a wrong moment when actual
> eVMCS changes are unsynchronized with 'hv_clean_fields'. As upon migration
> VMCS12 is used as a source of ultimate truce, we must make sure we pick all
> the changes to eVMCS and thus 'clean fields' data must be ignored.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 43 +++++++++++++++++++++++----------------
>  1 file changed, 25 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index ea2869d8b823..7970a16ee6b1 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1607,16 +1607,23 @@ static void copy_vmcs12_to_shadow(struct vcpu_vmx *vmx)
>  	vmcs_load(vmx->loaded_vmcs->vmcs);
>  }
>  
> -static int copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx)
> +static int copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, bool from_vmentry)
>  {
>  	struct vmcs12 *vmcs12 = vmx->nested.cached_vmcs12;
>  	struct hv_enlightened_vmcs *evmcs = vmx->nested.hv_evmcs;
> +	u32 hv_clean_fields;
>  
>  	/* HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE */
>  	vmcs12->tpr_threshold = evmcs->tpr_threshold;
>  	vmcs12->guest_rip = evmcs->guest_rip;
>  
> -	if (unlikely(!(evmcs->hv_clean_fields &
> +	/* Clean fields data can only be trusted upon vmentry */
> +	if (likely(from_vmentry))
> +		hv_clean_fields = evmcs->hv_clean_fields;
> +	else
> +		hv_clean_fields = 0;

...

> @@ -3503,7 +3510,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
>  		return nested_vmx_failInvalid(vcpu);
>  
>  	if (vmx->nested.hv_evmcs) {
> -		copy_enlightened_to_vmcs12(vmx);
> +		copy_enlightened_to_vmcs12(vmx, true);

Rather than pass a bool, what about having the caller explicitly specify the
clean fields?  Then the migration path can have a comment about needing to
assume all fields are dirty, and the normal path would be self-documenting.
E.g. with evmcs captured in a local var:

	if (evmcs) {
		copy_enlightened_to_vmcs12(vmx, evmcs->hv_clean_fields);
	} else if (...) {
	}

>  		/* Enlightened VMCS doesn't have launch state */
>  		vmcs12->launch_state = !launch;
>  	} else if (enable_shadow_vmcs) {
> @@ -6136,7 +6143,7 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
>  		copy_vmcs02_to_vmcs12_rare(vcpu, get_vmcs12(vcpu));
>  		if (!vmx->nested.need_vmcs12_to_shadow_sync) {
>  			if (vmx->nested.hv_evmcs)
> -				copy_enlightened_to_vmcs12(vmx);
> +				copy_enlightened_to_vmcs12(vmx, false);
>  			else if (enable_shadow_vmcs)
>  				copy_shadow_to_vmcs12(vmx);
>  		}
> -- 
> 2.30.2
> 
