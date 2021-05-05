Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A40DB37369B
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 10:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232201AbhEEIuq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 04:50:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56142 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231936AbhEEIup (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 May 2021 04:50:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620204589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=29V+H59ihZvB+veqIvoMKc9+NOTSbPAa2eKaOK9eB7o=;
        b=JGHiOtNVUCkFpVY+sRDKe5/lJ0HbHxANNBHyBfMeIass5DkXMVSt1X2R31nzQILyBXRhpR
        /6OTexxVwzDAESESOEe8kqTFgq2zitagrg4xYJOI5u1Gn0jMGx2fvEln23mN1/LEbbcmjU
        R3s3A6LVMED2G3k2GmGs7mRnsbyj/DA=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-nP8P8qXrNTqtZZMRWR757g-1; Wed, 05 May 2021 04:49:47 -0400
X-MC-Unique: nP8P8qXrNTqtZZMRWR757g-1
Received: by mail-ed1-f69.google.com with SMTP id y19-20020a0564022713b029038a9f36060dso524011edd.4
        for <kvm@vger.kernel.org>; Wed, 05 May 2021 01:49:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=29V+H59ihZvB+veqIvoMKc9+NOTSbPAa2eKaOK9eB7o=;
        b=INkfTGjpKXDk8EMkaIHfj4sk8uGIIaHYgx2bENVSjCTbzZOcIr9MQfu38JlUD0kB8M
         xgX/1z6KeQBexVsUFldHToiMq7pPwt7M6neDezqamDAsGurKrhkA03QjwdMRW8uFvpUJ
         NZWOgfSEKfwXexbkjZzNcL0H940ljnFZ0sr7GT6gXm1v3sgb5mAjlIUHYM5ixKn2byOt
         9y3+0BPecOOjq3YGhH+HKqv/gK7x1PSWTLEXnqAHdcPk9kWEt8chFainFByG7oq19zQ6
         aJeVt2axmPomLnh/nRgUr5wen9uAkzcsiu+Jnfaj4TArN6XIlH//I4IY24uVpmK9vot9
         GtwA==
X-Gm-Message-State: AOAM531lPYV+3nqhjleyfY539/ca9/qIsblJR6jmXPe1Pcy1NMJFDmVj
        zbyEorcvtyqUWqn6awZPVZaoP+lac45cX/obwrrtcp1S+cGNv/0S1uw906+xZBUicjTDor0Alz5
        /fpCGkztBtlBq
X-Received: by 2002:a17:906:168f:: with SMTP id s15mr25878204ejd.220.1620204586295;
        Wed, 05 May 2021 01:49:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzi+ao8G1OtHyMGJx8iniEaDVC4+0sEIRI0oG5ZRyybeoPnAJbchOxnoCpdmbD9TPJncJvljw==
X-Received: by 2002:a17:906:168f:: with SMTP id s15mr25878182ejd.220.1620204586102;
        Wed, 05 May 2021 01:49:46 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id g13sm2621744ejx.51.2021.05.05.01.49.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 May 2021 01:49:45 -0700 (PDT)
Subject: Re: [PATCH 11/15] KVM: VMX: Disable loading of TSX_CTRL MSR the more
 conventional way
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
References: <20210504171734.1434054-1-seanjc@google.com>
 <20210504171734.1434054-12-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <08a4afca-c3cb-1999-02a6-a72440ab2214@redhat.com>
Date:   Wed, 5 May 2021 10:49:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210504171734.1434054-12-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/05/21 19:17, Sean Christopherson wrote:
> Tag TSX_CTRL as not needing to be loaded when RTM isn't supported in the
> host.  Crushing the write mask to '0' has the same effect, but requires
> more mental gymnastics to understand.

This doesn't explain _why_ this is now possible.  What about:

Now that user return MSRs is always present in the list, we don't have
the problem that the TSX_CTRL MSR needs a slot vmx->guest_uret_msrs even
if RTM is not supported in the host (and therefore there is nothing to
enable).  Thus we can simply tag TSX_CTRL as not needing to be loaded
instead of crushing the write mask to '0'.  That has the same effect,
but requires less mental gymnastics to understand.

Paolo

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 22 ++++++++++------------
>   1 file changed, 10 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 4b432d2bbd06..7a53568b34fc 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1771,7 +1771,13 @@ static void setup_msrs(struct vcpu_vmx *vmx)
>   			   guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDTSCP) ||
>   			   guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDPID));
>   
> -	vmx_setup_uret_msr(vmx, MSR_IA32_TSX_CTRL, true);
> +	/*
> +	 * hle=0, rtm=0, tsx_ctrl=1 can be found with some combinations of new
> +	 * kernel and old userspace.  If those guests run on a tsx=off host, do
> +	 * allow guests to use TSX_CTRL, but don't change the value in hardware
> +	 * so that TSX remains always disabled.
> +	 */
> +	vmx_setup_uret_msr(vmx, MSR_IA32_TSX_CTRL, boot_cpu_has(X86_FEATURE_RTM));
>   
>   	if (cpu_has_vmx_msr_bitmap())
>   		vmx_update_msr_bitmap(&vmx->vcpu);
> @@ -6919,23 +6925,15 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
>   		vmx->guest_uret_msrs[i].data = 0;
>   		vmx->guest_uret_msrs[i].mask = -1ull;
>   	}
> -	tsx_ctrl = vmx_find_uret_msr(vmx, MSR_IA32_TSX_CTRL);
> -	if (tsx_ctrl) {
> +	if (boot_cpu_has(X86_FEATURE_RTM)) {
>   		/*
>   		 * TSX_CTRL_CPUID_CLEAR is handled in the CPUID interception.
>   		 * Keep the host value unchanged to avoid changing CPUID bits
>   		 * under the host kernel's feet.
> -		 *
> -		 * hle=0, rtm=0, tsx_ctrl=1 can be found with some combinations
> -		 * of new kernel and old userspace.  If those guests run on a
> -		 * tsx=off host, do allow guests to use TSX_CTRL, but do not
> -		 * change the value on the host so that TSX remains always
> -		 * disabled.
>   		 */
> -		if (boot_cpu_has(X86_FEATURE_RTM))
> +		tsx_ctrl = vmx_find_uret_msr(vmx, MSR_IA32_TSX_CTRL);
> +		if (tsx_ctrl)
>   			vmx->guest_uret_msrs[i].mask = ~(u64)TSX_CTRL_CPUID_CLEAR;
> -		else
> -			vmx->guest_uret_msrs[i].mask = 0;
>   	}
>   
>   	err = alloc_loaded_vmcs(&vmx->vmcs01);
> 

