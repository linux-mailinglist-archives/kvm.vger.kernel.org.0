Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE95414B61
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 16:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234793AbhIVOJE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 10:09:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51521 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232401AbhIVOJD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 10:09:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632319653;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vNQu7vqB0RAW1n7hwL+Jo3n15qaypRhapeW5ybKJfXg=;
        b=i1ZYDs6Vk99UTIPlEZV/YN/L65pqk2nEPBWt1EkTSl9StA9pdTHu7yv2lEz5HXY6krspXI
        W8mOhD1YCSVco4YlHECMVpEG4bV+Rz+eTYksE4DaKp7qW7AAvcSRUbIT6QImVFUb6aIodb
        GYEyFvZ1rFEjwgp+ft+7TZwJO4KEA9E=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-584-Pe9Q4uQHMX2w5M_2jTzfkQ-1; Wed, 22 Sep 2021 10:07:32 -0400
X-MC-Unique: Pe9Q4uQHMX2w5M_2jTzfkQ-1
Received: by mail-ed1-f70.google.com with SMTP id w24-20020a056402071800b003cfc05329f8so3174548edx.19
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 07:07:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vNQu7vqB0RAW1n7hwL+Jo3n15qaypRhapeW5ybKJfXg=;
        b=79r6H94mVduOxnErkJsrmCjYMrTxNeLuH2RWKsftMgeUJvIhVJCxX/E1LZDRIgMQZl
         qee2ymRV+7oJAJRSjfNukHwN+banhdFEqMRUGG6081t9sp+3l12AN6rwuljls9AcpCJw
         UQQHqZRHDudCf8tt+ye0cKQ3Q6mbo2WQXl48mtj3RvMFZhhuKQFp7fU75eG2ux8QIxYn
         bZT1hPu2WPkwX9uJqA0dI9YfSglryO6rtQwGBrtzqNBArzKPJkIKogorWaBvWnlKbzGE
         +WhZ8ifcDHsSacQM2AjU63UJlnmDdPypqTBLB/EuBwfCnHB/9UlCbAf5f07tawzQKSvU
         9ARQ==
X-Gm-Message-State: AOAM532LN3yErbRqsGO+yHwECMYDxF+k7W/lAFj97kpbC7JteAsM7RmR
        5z8sGQQQnKMGEiF/I+RhDH3u1vvAYkKrrp9cjlrA+UiIkwJBpo42qTHLsKUA9UZRU+BMl8wH9vk
        mY7y4j+ncbBFL
X-Received: by 2002:aa7:cb8a:: with SMTP id r10mr42451082edt.237.1632319651139;
        Wed, 22 Sep 2021 07:07:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzWEdYDNyCSzJ1D42Lyuc6m4iibSelaJntWUNe8JaZheTpbrRXJKgsx+zBI2IwELlTZ5BenHw==
X-Received: by 2002:aa7:cb8a:: with SMTP id r10mr42451057edt.237.1632319650926;
        Wed, 22 Sep 2021 07:07:30 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r2sm1248160edo.59.2021.09.22.07.07.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Sep 2021 07:07:30 -0700 (PDT)
Subject: Re: [PATCH] KVM: nVMX: Filter out all unsupported controls when eVMCS
 was activated
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
References: <20210907163530.110066-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <03184da6-76f4-3b4a-25ca-be8883b93cae@redhat.com>
Date:   Wed, 22 Sep 2021 16:07:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210907163530.110066-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/09/21 18:35, Vitaly Kuznetsov wrote:
> Windows Server 2022 with Hyper-V role enabled failed to boot on KVM when
> enlightened VMCS is advertised. Debugging revealed there are two exposed
> secondary controls it is not happy with: SECONDARY_EXEC_ENABLE_VMFUNC and
> SECONDARY_EXEC_SHADOW_VMCS. These controls are known to be unsupported,
> as there are no corresponding fields in eVMCSv1 (see the comment above
> EVMCS1_UNSUPPORTED_2NDEXEC definition).
> 
> Previously, commit 31de3d2500e4 ("x86/kvm/hyper-v: move VMX controls
> sanitization out of nested_enable_evmcs()") introduced the required
> filtering mechanism for VMX MSRs but for some reason put only known
> to be problematic (and not full EVMCS1_UNSUPPORTED_* lists) controls
> there.
> 
> Note, Windows Server 2022 seems to have gained some sanity check for VMX
> MSRs: it doesn't even try to launch a guest when there's something it
> doesn't like, nested_evmcs_check_controls() mechanism can't catch the
> problem.
> 
> Let's be bold this time and instead of playing whack-a-mole just filter out
> all unsupported controls from VMX MSRs.
> 
> Fixes: 31de3d2500e4 ("x86/kvm/hyper-v: move VMX controls sanitization out of nested_enable_evmcs()")
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>   arch/x86/kvm/vmx/evmcs.c | 12 +++++++++---
>   arch/x86/kvm/vmx/vmx.c   |  9 +++++----
>   2 files changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
> index 0dab1b7b529f..ba6f99f584ac 100644
> --- a/arch/x86/kvm/vmx/evmcs.c
> +++ b/arch/x86/kvm/vmx/evmcs.c
> @@ -353,14 +353,20 @@ void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata)
>   	switch (msr_index) {
>   	case MSR_IA32_VMX_EXIT_CTLS:
>   	case MSR_IA32_VMX_TRUE_EXIT_CTLS:
> -		ctl_high &= ~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
> +		ctl_high &= ~EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
>   		break;
>   	case MSR_IA32_VMX_ENTRY_CTLS:
>   	case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
> -		ctl_high &= ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
> +		ctl_high &= ~EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
>   		break;
>   	case MSR_IA32_VMX_PROCBASED_CTLS2:
> -		ctl_high &= ~SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
> +		ctl_high &= ~EVMCS1_UNSUPPORTED_2NDEXEC;
> +		break;
> +	case MSR_IA32_VMX_PINBASED_CTLS:
> +		ctl_high &= ~EVMCS1_UNSUPPORTED_PINCTRL;
> +		break;
> +	case MSR_IA32_VMX_VMFUNC:
> +		ctl_low &= ~EVMCS1_UNSUPPORTED_VMFUNC;
>   		break;
>   	}
>   
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index fada1055f325..d7c5257eb5c0 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1837,10 +1837,11 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   				    &msr_info->data))
>   			return 1;
>   		/*
> -		 * Enlightened VMCS v1 doesn't have certain fields, but buggy
> -		 * Hyper-V versions are still trying to use corresponding
> -		 * features when they are exposed. Filter out the essential
> -		 * minimum.
> +		 * Enlightened VMCS v1 doesn't have certain VMCS fields but
> +		 * instead of just ignoring the features, different Hyper-V
> +		 * versions are either trying to use them and fail or do some
> +		 * sanity checking and refuse to boot. Filter all unsupported
> +		 * features out.
>   		 */
>   		if (!msr_info->host_initiated &&
>   		    vmx->nested.enlightened_vmcs_enabled)
> 

Queued, thanks.

Paolo

