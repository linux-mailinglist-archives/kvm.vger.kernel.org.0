Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 987032A1826
	for <lists+kvm@lfdr.de>; Sat, 31 Oct 2020 15:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbgJaO2e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 31 Oct 2020 10:28:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24759 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726196AbgJaO2c (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 31 Oct 2020 10:28:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604154510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o7rVtPMLa1zoW0QyAyamFfCoB/BjAKpY9EIGfp0w3V4=;
        b=SN0m5NW7vH5oYmUYMsfdXnEH10dW+DXuAWTRCA78p36Klyhr545IxM3Ckg+nJgmKnJQa+a
        4aJrqdYgPtKAaOYuWnMsqUUkm1Vst813CnH8zvDy6BfMnF+SQL38Ndjek4DbOjwaJI1chQ
        8pMjskgM9uGsErIujAPH9wi3LWuw0bg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-CJr3ZSLOOqa8nZ7hgPgZyw-1; Sat, 31 Oct 2020 10:28:28 -0400
X-MC-Unique: CJr3ZSLOOqa8nZ7hgPgZyw-1
Received: by mail-wr1-f72.google.com with SMTP id x16so4037373wrg.7
        for <kvm@vger.kernel.org>; Sat, 31 Oct 2020 07:28:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o7rVtPMLa1zoW0QyAyamFfCoB/BjAKpY9EIGfp0w3V4=;
        b=UFOGsMzbGb666faIsNWk3jvOVlD0I/fB4xsX9vRnOyFx8vNnQ6SY61uUoKfkABKQzV
         1kc/HyuZN+mdoajB5g8gVymTaUk0h5VdHGSPOxG0QZ7R//+Z8kHMVE7W3Panf4mS44qh
         vkmTxmev9slo79biACRwL42zpPUt7m/v0ynEVkoj/nkzP1+ZGXwREVJFbonGhTzcj9wX
         rtPEJGIM2Nz4QUM3yDwZeVYBLUAMF8INvt1ShAuhB6LaVIJ8ff+4TUVlMV3eS6zAnR3d
         R0SZtnj0ni2iy6jISfNMqIXP5yq40xiFv7FejrhfcHkHwjiCbBjVg64CELCRxmf+ee9A
         Ou6g==
X-Gm-Message-State: AOAM531YvRFWGtFStDgYHMNIsysAUg+2IaJyIhX1kokRUHCPFg0Ne0+z
        CyIjxYz81VrkkAfdAaJI7bucOn9MahPa2pYJiDONb9mAWL9OPCiY3gHW2UIqEf3cpPODy+sQ6Ih
        45laLrfS5uT1U
X-Received: by 2002:adf:c045:: with SMTP id c5mr9659452wrf.405.1604154507393;
        Sat, 31 Oct 2020 07:28:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyCn08N7g/j8KOD/wSOw1Us3xWEOQLuWxKTaimi12NFCS7t6mUKGKYcJuFI/4oGPXb2EoQCHA==
X-Received: by 2002:adf:c045:: with SMTP id c5mr9659436wrf.405.1604154507199;
        Sat, 31 Oct 2020 07:28:27 -0700 (PDT)
Received: from [192.168.178.64] ([151.20.250.56])
        by smtp.gmail.com with ESMTPSA id t5sm16605772wrb.21.2020.10.31.07.28.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Oct 2020 07:28:26 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: VMX: eVMCS: make evmcs_sanitize_exec_ctrls() work
 again
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        linux-kernel@vger.kernel.org
References: <20201014143346.2430936-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <06f37925-0578-a197-3bfc-fa7d5c6ae543@redhat.com>
Date:   Sat, 31 Oct 2020 15:28:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201014143346.2430936-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/10/20 16:33, Vitaly Kuznetsov wrote:
> It was noticed that evmcs_sanitize_exec_ctrls() is not being executed
> nowadays despite the code checking 'enable_evmcs' static key looking
> correct. Turns out, static key magic doesn't work in '__init' section
> (and it is unclear when things changed) but setup_vmcs_config() is called
> only once per CPU so we don't really need it to. Switch to checking
> 'enlightened_vmcs' instead, it is supposed to be in sync with
> 'enable_evmcs'.
> 
> Opportunistically make evmcs_sanitize_exec_ctrls '__init' and drop unneeded
> extra newline from it.
> 
> Reported-by: Yang Weijiang <weijiang.yang@intel.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
> - Changes since v1:
>   put '#if IS_ENABLED(CONFIG_HYPERV)' around enlightened_vmcs check
>   [ktest robot]
> ---
>  arch/x86/kvm/vmx/evmcs.c | 3 +--
>  arch/x86/kvm/vmx/evmcs.h | 3 +--
>  arch/x86/kvm/vmx/vmx.c   | 4 +++-
>  3 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
> index e5325bd0f304..f3199bb02f22 100644
> --- a/arch/x86/kvm/vmx/evmcs.c
> +++ b/arch/x86/kvm/vmx/evmcs.c
> @@ -297,14 +297,13 @@ const struct evmcs_field vmcs_field_to_evmcs_1[] = {
>  };
>  const unsigned int nr_evmcs_1_fields = ARRAY_SIZE(vmcs_field_to_evmcs_1);
>  
> -void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf)
> +__init void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf)
>  {
>  	vmcs_conf->pin_based_exec_ctrl &= ~EVMCS1_UNSUPPORTED_PINCTRL;
>  	vmcs_conf->cpu_based_2nd_exec_ctrl &= ~EVMCS1_UNSUPPORTED_2NDEXEC;
>  
>  	vmcs_conf->vmexit_ctrl &= ~EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
>  	vmcs_conf->vmentry_ctrl &= ~EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
> -
>  }
>  #endif
>  
> diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
> index e5f7a7ebf27d..bd41d9462355 100644
> --- a/arch/x86/kvm/vmx/evmcs.h
> +++ b/arch/x86/kvm/vmx/evmcs.h
> @@ -185,7 +185,7 @@ static inline void evmcs_load(u64 phys_addr)
>  	vp_ap->enlighten_vmentry = 1;
>  }
>  
> -void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf);
> +__init void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf);
>  #else /* !IS_ENABLED(CONFIG_HYPERV) */
>  static inline void evmcs_write64(unsigned long field, u64 value) {}
>  static inline void evmcs_write32(unsigned long field, u32 value) {}
> @@ -194,7 +194,6 @@ static inline u64 evmcs_read64(unsigned long field) { return 0; }
>  static inline u32 evmcs_read32(unsigned long field) { return 0; }
>  static inline u16 evmcs_read16(unsigned long field) { return 0; }
>  static inline void evmcs_load(u64 phys_addr) {}
> -static inline void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf) {}
>  static inline void evmcs_touch_msr_bitmap(void) {}
>  #endif /* IS_ENABLED(CONFIG_HYPERV) */
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 96979c09ebd1..682f2b2f9a18 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2607,8 +2607,10 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  	vmcs_conf->vmexit_ctrl         = _vmexit_control;
>  	vmcs_conf->vmentry_ctrl        = _vmentry_control;
>  
> -	if (static_branch_unlikely(&enable_evmcs))
> +#if IS_ENABLED(CONFIG_HYPERV)
> +	if (enlightened_vmcs)
>  		evmcs_sanitize_exec_ctrls(vmcs_conf);
> +#endif
>  
>  	return 0;
>  }
> 

Queued, thanks.

Paolo

