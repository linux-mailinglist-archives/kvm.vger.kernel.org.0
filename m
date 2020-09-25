Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48FF027920A
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 22:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbgIYUdN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 16:33:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54314 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728476AbgIYUVk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 16:21:40 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601065298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VhnUc2BbOi73m+9TFwo34hZOzGKUsTVaCJO+A+GVqYs=;
        b=N2VKVWU5YWAdGCDKeOTChntXLsrCQnt5q31a4BUGDhnBhnvbb9BIC5pCBn/lEYp4wlUUF1
        wO6fvlTX9/h3qXJHHhZutTjukjvle4Fz9Vz7bFqHbrMNNr3AxjInrVNC/EQhQ4BJfS9Wg8
        uiCPG64Syru9bSocItOTBR1zPlUwL3o=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-82-EKR8Gz1pOoixOqD4SopEzg-1; Fri, 25 Sep 2020 16:21:36 -0400
X-MC-Unique: EKR8Gz1pOoixOqD4SopEzg-1
Received: by mail-wm1-f69.google.com with SMTP id a7so70408wmc.2
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 13:21:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VhnUc2BbOi73m+9TFwo34hZOzGKUsTVaCJO+A+GVqYs=;
        b=O8C7lX8oox8EjgYAEfddhAQd96+2z9f0kS/XyVaLAMKV5bJACbt4g6t7YoubmXccgy
         8IwbvWV9HNkllc8fwQfu389qPyQdeex0NwqmvKuXOMHIu4J5YyiJhJfSDO09COk93Gkq
         GhaDzyPnyd80LDxHvnIWFtKOaoCl5ZNsEL9piQWllx18Z4hSOfOpP3Q7RuKA5rCnxqTV
         CZBOrosHtx5WFfWMOkVQR+f85cQZbFK82+dPIqRNoD5iX1JNmg20Phqnqd5w1E1BTjz5
         LTwlqdjs0+D2WrVzoUFu4Pl6XAG6rK9wEBThwOeyLEl/Z+P6QavMAs3o+VqdgJOH+0hY
         6HAg==
X-Gm-Message-State: AOAM533gT7lyV646KgRmPvx+8iW/6PLXSrOfspBSKWNlXl1BNwqyu5Dk
        ArNCvlPuCQJGEDDn4lAYFbs9I63Ioxp4BdI6waKiz/pa3KApm/2rndb7X05387ohwYssfUClaLQ
        w/PFmT+lPoYUH
X-Received: by 2002:adf:e449:: with SMTP id t9mr6369251wrm.154.1601065294776;
        Fri, 25 Sep 2020 13:21:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxjj+1kICKsk0vFm9QSXgJpCGrYthL/ij347pkP9nVBx0LscWSW1Z+WTzrstXac7yYtZ/F/EQ==
X-Received: by 2002:adf:e449:: with SMTP id t9mr6369226wrm.154.1601065294447;
        Fri, 25 Sep 2020 13:21:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec9b:111a:97e3:4baf? ([2001:b07:6468:f312:ec9b:111a:97e3:4baf])
        by smtp.gmail.com with ESMTPSA id l126sm146057wmf.39.2020.09.25.13.21.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 13:21:33 -0700 (PDT)
Subject: Re: [PATCH v2 4/4] KVM: VMX: Add a helper and macros to reduce
 boilerplate for sec exec ctls
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <7d7daea0-57be-83be-a0d4-8a481249ef85@redhat.com>
 <20200925003011.21016-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9bbc8568-3d9b-2c0a-7fac-fd708cbd271d@redhat.com>
Date:   Fri, 25 Sep 2020 22:21:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200925003011.21016-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/09/20 02:30, Sean Christopherson wrote:
> Add a helper function and several wrapping macros to consolidate the
> copy-paste code in vmx_compute_secondary_exec_control() for adjusting
> controls that are dependent on guest CPUID bits.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
> 
> v2: Comment the new helper and macros.
> 
>  arch/x86/kvm/vmx/vmx.c | 151 +++++++++++++++++------------------------
>  1 file changed, 64 insertions(+), 87 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 5180529f6531..48673eea0c0d 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4072,6 +4072,61 @@ u32 vmx_exec_control(struct vcpu_vmx *vmx)
>  	return exec_control;
>  }
>  
> +/*
> + * Adjust a single secondary execution control bit to intercept/allow an
> + * instruction in the guest.  This is usually done based on whether or not a
> + * feature has been exposed to the guest in order to correctly emulate faults.
> + */
> +static inline void
> +vmx_adjust_secondary_exec_control(struct vcpu_vmx *vmx, u32 *exec_control,
> +				  u32 control, bool enabled, bool exiting)
> +{
> +	/*
> +	 * If the control is for an opt-in feature, clear the control if the
> +	 * feature is not exposed to the guest, i.e. not enabled.  If the
> +	 * control is opt-out, i.e. an exiting control, clear the control if
> +	 * the feature _is_ exposed to the guest, i.e. exiting/interception is
> +	 * disabled for the associated instruction.  Note, the caller is
> +	 * responsible presetting exec_control to set all supported bits.
> +	 */
> +	if (enabled == exiting)
> +		*exec_control &= ~control;
> +
> +	/*
> +	 * Update the nested MSR settings so that a nested VMM can/can't set
> +	 * controls for features that are/aren't exposed to the guest.
> +	 */
> +	if (nested) {
> +		if (enabled)
> +			vmx->nested.msrs.secondary_ctls_high |= control;
> +		else
> +			vmx->nested.msrs.secondary_ctls_high &= ~control;
> +	}
> +}
> +
> +/*
> + * Wrapper macro for the common case of adjusting a secondary execution control
> + * based on a single guest CPUID bit, with a dedicated feature bit.  This also
> + * verifies that the control is actually supported by KVM and hardware.
> + */
> +#define vmx_adjust_sec_exec_control(vmx, exec_control, name, feat_name, ctrl_name, exiting) \
> +({									 \
> +	bool __enabled;							 \
> +									 \
> +	if (cpu_has_vmx_##name()) {					 \
> +		__enabled = guest_cpuid_has(&(vmx)->vcpu,		 \
> +					    X86_FEATURE_##feat_name);	 \
> +		vmx_adjust_secondary_exec_control(vmx, exec_control,	 \
> +			SECONDARY_EXEC_##ctrl_name, __enabled, exiting); \
> +	}								 \
> +})
> +
> +/* More macro magic for ENABLE_/opt-in versus _EXITING/opt-out controls. */
> +#define vmx_adjust_sec_exec_feature(vmx, exec_control, lname, uname) \
> +	vmx_adjust_sec_exec_control(vmx, exec_control, lname, uname, ENABLE_##uname, false)
> +
> +#define vmx_adjust_sec_exec_exiting(vmx, exec_control, lname, uname) \
> +	vmx_adjust_sec_exec_control(vmx, exec_control, lname, uname, uname##_EXITING, true)
>  
>  static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
>  {
> @@ -4121,33 +4176,12 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
>  
>  		vcpu->arch.xsaves_enabled = xsaves_enabled;
>  
> -		if (!xsaves_enabled)
> -			exec_control &= ~SECONDARY_EXEC_XSAVES;
> -
> -		if (nested) {
> -			if (xsaves_enabled)
> -				vmx->nested.msrs.secondary_ctls_high |=
> -					SECONDARY_EXEC_XSAVES;
> -			else
> -				vmx->nested.msrs.secondary_ctls_high &=
> -					~SECONDARY_EXEC_XSAVES;
> -		}
> +		vmx_adjust_secondary_exec_control(vmx, &exec_control,
> +						  SECONDARY_EXEC_XSAVES,
> +						  xsaves_enabled, false);
>  	}
>  
> -	if (cpu_has_vmx_rdtscp()) {
> -		bool rdtscp_enabled = guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP);
> -		if (!rdtscp_enabled)
> -			exec_control &= ~SECONDARY_EXEC_ENABLE_RDTSCP;
> -
> -		if (nested) {
> -			if (rdtscp_enabled)
> -				vmx->nested.msrs.secondary_ctls_high |=
> -					SECONDARY_EXEC_ENABLE_RDTSCP;
> -			else
> -				vmx->nested.msrs.secondary_ctls_high &=
> -					~SECONDARY_EXEC_ENABLE_RDTSCP;
> -		}
> -	}
> +	vmx_adjust_sec_exec_feature(vmx, &exec_control, rdtscp, RDTSCP);
>  
>  	/*
>  	 * Expose INVPCID if and only if PCID is also exposed to the guest.
> @@ -4157,71 +4191,14 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
>  	 */
>  	if (!guest_cpuid_has(vcpu, X86_FEATURE_PCID))
>  		guest_cpuid_clear(vcpu, X86_FEATURE_INVPCID);
> +	vmx_adjust_sec_exec_feature(vmx, &exec_control, invpcid, INVPCID);
>  
> -	if (cpu_has_vmx_invpcid()) {
> -		/* Exposing INVPCID only when PCID is exposed */
> -		bool invpcid_enabled =
> -			guest_cpuid_has(vcpu, X86_FEATURE_INVPCID);
>  
> -		if (!invpcid_enabled)
> -			exec_control &= ~SECONDARY_EXEC_ENABLE_INVPCID;
> +	vmx_adjust_sec_exec_exiting(vmx, &exec_control, rdrand, RDRAND);
> +	vmx_adjust_sec_exec_exiting(vmx, &exec_control, rdseed, RDSEED);
>  
> -		if (nested) {
> -			if (invpcid_enabled)
> -				vmx->nested.msrs.secondary_ctls_high |=
> -					SECONDARY_EXEC_ENABLE_INVPCID;
> -			else
> -				vmx->nested.msrs.secondary_ctls_high &=
> -					~SECONDARY_EXEC_ENABLE_INVPCID;
> -		}
> -	}
> -
> -	if (cpu_has_vmx_rdrand()) {
> -		bool rdrand_enabled = guest_cpuid_has(vcpu, X86_FEATURE_RDRAND);
> -		if (rdrand_enabled)
> -			exec_control &= ~SECONDARY_EXEC_RDRAND_EXITING;
> -
> -		if (nested) {
> -			if (rdrand_enabled)
> -				vmx->nested.msrs.secondary_ctls_high |=
> -					SECONDARY_EXEC_RDRAND_EXITING;
> -			else
> -				vmx->nested.msrs.secondary_ctls_high &=
> -					~SECONDARY_EXEC_RDRAND_EXITING;
> -		}
> -	}
> -
> -	if (cpu_has_vmx_rdseed()) {
> -		bool rdseed_enabled = guest_cpuid_has(vcpu, X86_FEATURE_RDSEED);
> -		if (rdseed_enabled)
> -			exec_control &= ~SECONDARY_EXEC_RDSEED_EXITING;
> -
> -		if (nested) {
> -			if (rdseed_enabled)
> -				vmx->nested.msrs.secondary_ctls_high |=
> -					SECONDARY_EXEC_RDSEED_EXITING;
> -			else
> -				vmx->nested.msrs.secondary_ctls_high &=
> -					~SECONDARY_EXEC_RDSEED_EXITING;
> -		}
> -	}
> -
> -	if (cpu_has_vmx_waitpkg()) {
> -		bool waitpkg_enabled =
> -			guest_cpuid_has(vcpu, X86_FEATURE_WAITPKG);
> -
> -		if (!waitpkg_enabled)
> -			exec_control &= ~SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE;
> -
> -		if (nested) {
> -			if (waitpkg_enabled)
> -				vmx->nested.msrs.secondary_ctls_high |=
> -					SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE;
> -			else
> -				vmx->nested.msrs.secondary_ctls_high &=
> -					~SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE;
> -		}
> -	}
> +	vmx_adjust_sec_exec_control(vmx, &exec_control, waitpkg, WAITPKG,
> +				    ENABLE_USR_WAIT_PAUSE, false);
>  
>  	vmx->secondary_exec_control = exec_control;
>  }
> 

Queued with the rest, thanks.

Paolo

