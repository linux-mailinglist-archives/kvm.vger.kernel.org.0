Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D47E23BD6A8
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 14:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234456AbhGFMlq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 08:41:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31709 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345459AbhGFMf7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 08:35:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625574800;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IKAolIkWfGXIHgVjjUzyC4kaIUHRAjQA2cb6xVYX4ig=;
        b=euCjEuiBVsyzsK2sh+4oo4M6FbCtrovBOeu8t+E09DwbxitqCnx6C5bv3OvR3nItoDzXyc
        z8wMR4pid8oDp3YC4HbVm3mWK0l6ZeGT9mMQkouoWw4lor23IFSdYNQjsCcDinRG0Gcfyc
        IEx3JwQE8lXOU2qnlGRjeqYehSOKlBA=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-ukMdJOHNN6Sbn6PDR5QKZg-1; Tue, 06 Jul 2021 08:33:19 -0400
X-MC-Unique: ukMdJOHNN6Sbn6PDR5QKZg-1
Received: by mail-ed1-f72.google.com with SMTP id n13-20020a05640206cdb029039589a2a771so2784642edy.5
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 05:33:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IKAolIkWfGXIHgVjjUzyC4kaIUHRAjQA2cb6xVYX4ig=;
        b=asZgZysEHQX/MyKQMbJoslKIJv+Gouww2/iszrd2CD2ZhJOEGLvyG1PpuVnrkKcTSU
         83o8WVSkPq1qDgTRiWU7TO2XPycUpforvcKAJQbluQm16Sr7EFxGcglAGojcsjfn8hVF
         247PpSIjJPUtEGsq4snLzXQ2x3KhG61opUfw2LiTrGjXd5lPnLY0ghmEAtCrMHzMTwO4
         2AAiRy/nmBq4B7GQOhrpxRJ9QLA+T9FZ9DwrrlF2lOPBvGEfHBfrpNrC2sH/ihzIlMgh
         VSWxGeRT4BO4f2fo7Txqs+rP1+1RLFh2E6negk2ngkcT6gws8I3+bufXAsUtOIRu3ejO
         UOJQ==
X-Gm-Message-State: AOAM533BSeiWP2PIP+9a56/QdXxX7Z4wXN2LFGBnBH/RotWiEsEU21Ro
        wF9VIalNJ9f12wctNLezKvYkRA/DraHpmCmIZ2EWuaRt7oFP87xUd6xKFH25h+tvaEBJPGr4iXu
        Whd902Zk1IDod
X-Received: by 2002:a05:6402:510d:: with SMTP id m13mr22472190edd.179.1625574797932;
        Tue, 06 Jul 2021 05:33:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzKvbEYLkOKiDEWkJdNUVXWSloDVpCNUhfsMNw0ISwJpI+/ox2yxxHXME+f+tc+GZAzZzAY8g==
X-Received: by 2002:a05:6402:510d:: with SMTP id m13mr22472161edd.179.1625574797715;
        Tue, 06 Jul 2021 05:33:17 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id x21sm7186737eds.38.2021.07.06.05.33.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 05:33:16 -0700 (PDT)
Subject: Re: [RFC PATCH v2 02/69] KVM: X86: move kvm_cpu_vmxon() from vmx.c to
 virtext.h
To:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@gmail.com
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <cb2256563ec5aacdb7ab6122343e86be9f1cbd60.1625186503.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e50cb6a3-04df-0a81-c68e-00901e3cba63@redhat.com>
Date:   Tue, 6 Jul 2021 14:33:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <cb2256563ec5aacdb7ab6122343e86be9f1cbd60.1625186503.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/21 00:04, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> This is preparatory clean up for TDX support.
> Move out kvm_cpu_vmxon() from vmx.c to virtext.h with rename to
> vcpu_vmxon(). Which will be used outside of kvm.
> SEAMLDER to load TDX module which occurs at kernel early boot phase.
> As bonus, this also increases the symetry with cpu_vmxoff().
> 
> No functional change is intended.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/include/asm/virtext.h | 25 +++++++++++++++++++++++++
>   arch/x86/kvm/vmx/vmx.c         | 22 +---------------------
>   2 files changed, 26 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/x86/include/asm/virtext.h b/arch/x86/include/asm/virtext.h
> index 8757078d4442..9234b85dac24 100644
> --- a/arch/x86/include/asm/virtext.h
> +++ b/arch/x86/include/asm/virtext.h
> @@ -30,6 +30,31 @@ static inline int cpu_has_vmx(void)
>   }
>   
>   
> +/**
> + * cpu_vmxon() - Enable VMX on the current CPU
> + *
> + * Set CR4.VMXE and enable VMX
> + */
> +static inline int cpu_vmxon(u64 vmxon_pointer)
> +{
> +	u64 msr;
> +
> +	cr4_set_bits(X86_CR4_VMXE);
> +
> +	asm_volatile_goto("1: vmxon %[vmxon_pointer]\n\t"
> +			  _ASM_EXTABLE(1b, %l[fault])
> +			  : : [vmxon_pointer] "m"(vmxon_pointer)
> +			  : : fault);
> +	return 0;
> +
> +fault:
> +	WARN_ONCE(1, "VMXON faulted, MSR_IA32_FEAT_CTL (0x3a) = 0x%llx\n",
> +		  rdmsrl_safe(MSR_IA32_FEAT_CTL, &msr) ? 0xdeadbeef : msr);
> +	cr4_clear_bits(X86_CR4_VMXE);
> +
> +	return -EFAULT;
> +}
> +
>   /**
>    * cpu_vmxoff() - Disable VMX on the current CPU
>    *
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c2a779b688e6..d73ba7a6ff8d 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2376,26 +2376,6 @@ static __init int vmx_disabled_by_bios(void)
>   	       !boot_cpu_has(X86_FEATURE_VMX);
>   }
>   
> -static int kvm_cpu_vmxon(u64 vmxon_pointer)
> -{
> -	u64 msr;
> -
> -	cr4_set_bits(X86_CR4_VMXE);
> -
> -	asm_volatile_goto("1: vmxon %[vmxon_pointer]\n\t"
> -			  _ASM_EXTABLE(1b, %l[fault])
> -			  : : [vmxon_pointer] "m"(vmxon_pointer)
> -			  : : fault);
> -	return 0;
> -
> -fault:
> -	WARN_ONCE(1, "VMXON faulted, MSR_IA32_FEAT_CTL (0x3a) = 0x%llx\n",
> -		  rdmsrl_safe(MSR_IA32_FEAT_CTL, &msr) ? 0xdeadbeef : msr);
> -	cr4_clear_bits(X86_CR4_VMXE);
> -
> -	return -EFAULT;
> -}
> -
>   static int hardware_enable(void)
>   {
>   	int cpu = raw_smp_processor_id();
> @@ -2415,7 +2395,7 @@ static int hardware_enable(void)
>   
>   	intel_pt_handle_vmx(1);
>   
> -	r = kvm_cpu_vmxon(phys_addr);
> +	r = cpu_vmxon(phys_addr);
>   	if (r) {
>   		intel_pt_handle_vmx(0);
>   		return r;
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

