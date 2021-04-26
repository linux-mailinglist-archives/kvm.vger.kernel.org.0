Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40F5536B069
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 11:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbhDZJUl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 05:20:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36570 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232078AbhDZJUk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Apr 2021 05:20:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619428799;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u5y9MbpARwgkPq2SvXUNV26BaQxXBbXVOds45fh2m+E=;
        b=dwY01GAoLtT0KTwnxQUdxcfjKA2ZxnhY5mFY/EFbPavj+HUDBxjOTKo/xjA6rodVXDNubY
        sx6uDyVI4HWab9mpsLr7eeQxoqUoH7JuCGzrxck8geHGBm5NSQhb6trcMPya9XMwqYcMbz
        NbduAKLzOeLkXUha1MXVL2waI7cmfu8=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-kogep6EPNhylQCkIQMXhig-1; Mon, 26 Apr 2021 05:19:57 -0400
X-MC-Unique: kogep6EPNhylQCkIQMXhig-1
Received: by mail-ed1-f70.google.com with SMTP id c13-20020a05640227cdb0290385526e5de5so12583850ede.21
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 02:19:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=u5y9MbpARwgkPq2SvXUNV26BaQxXBbXVOds45fh2m+E=;
        b=md1tVE/jmqyxNqNuLL/SHgfH9VXiVnQLQKOC5Xs5hvOkRGDxbDogOhSVbteu7p7ofj
         30xXL+ijgBim9ex4Kxs7KBxMe5KErwSf2iR0RE1GNP7kiGB9d/56Eia/c/WYfc+DjZp/
         fjeAMhXYVLQvRHTSjVnbNYCuycQSDXTQHwqO2csopeCrvxVwJBtwvoeF+OzTet46f+5F
         JxVzv8I+Nz1vqDW3Xp+CA94suXH3bxty8/U5KsO3UnD8WDze5Xdi4ak9rjzRvKPAdmos
         APZ9EwhcETn9Qh3cKRHR1Vz7yRlY2pwJ/eB6SmECbJSD66VM6HDDwtcmW5LDRG9g/kvL
         OzVg==
X-Gm-Message-State: AOAM531TrxiYK+Iy16lP1S6WItHXg/KXECvp8Ysu5ca30bICtaOZKjCE
        N/ueeReCc72OOTdIMeREHr5S7z33WhugsnXfiBZSBdXBCrMun/1DUIs9GsdU1QYR9u2RidtfjYK
        mmzggB9lp9MCc
X-Received: by 2002:a17:906:3e4a:: with SMTP id t10mr17498528eji.553.1619428796088;
        Mon, 26 Apr 2021 02:19:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxrek5egfR4D2g9yAozsojjVO+x8fQ99nZX2lKb3Y8yfMfaH8gO6li+33RlkIEZlXkcEkau7A==
X-Received: by 2002:a17:906:3e4a:: with SMTP id t10mr17498508eji.553.1619428795850;
        Mon, 26 Apr 2021 02:19:55 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id cn10sm13624649edb.28.2021.04.26.02.19.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Apr 2021 02:19:55 -0700 (PDT)
Subject: Re: [PATCH] KVM: VMX: Invert the inlining of MSR interception helpers
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210423221912.3857243-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <febab7f6-aab8-6278-5782-07d75dd40166@redhat.com>
Date:   Mon, 26 Apr 2021 11:19:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210423221912.3857243-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/04/21 00:19, Sean Christopherson wrote:
> Invert the inline declarations of the MSR interception helpers between
> the wrapper, vmx_set_intercept_for_msr(), and the core implementations,
> vmx_{dis,en}able_intercept_for_msr().  Letting the compiler _not_
> inline the implementation reduces KVM's code footprint by ~3k bytes.
> 
> Back when the helpers were added in commit 904e14fb7cb9 ("KVM: VMX: make
> MSR bitmaps per-VCPU"), both the wrapper and the implementations were
> __always_inline because the end code distilled down to a few conditionals
> and a bit operation.  Today, the implementations involve a variety of
> checks and bit ops in order to support userspace MSR filtering.
> 
> Furthermore, the vast majority of calls to manipulate MSR interception
> are not performance sensitive, e.g. vCPU creation and x2APIC toggling.
> On the other hand, the one path that is performance sensitive, dynamic
> LBR passthrough, uses the wrappers, i.e. is largely untouched by
> inverting the inlining.
> 
> In short, forcing the low level MSR interception code to be inlined no
> longer makes sense.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 17 ++---------------
>   arch/x86/kvm/vmx/vmx.h | 15 +++++++++++++--
>   2 files changed, 15 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 6501d66167b8..b77bc72d97a4 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -362,8 +362,6 @@ static const struct kernel_param_ops vmentry_l1d_flush_ops = {
>   module_param_cb(vmentry_l1d_flush, &vmentry_l1d_flush_ops, NULL, 0644);
>   
>   static u32 vmx_segment_access_rights(struct kvm_segment *var);
> -static __always_inline void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu,
> -							  u32 msr, int type);
>   
>   void vmx_vmexit(void);
>   
> @@ -3818,8 +3816,7 @@ static void vmx_set_msr_bitmap_write(ulong *msr_bitmap, u32 msr)
>   		__set_bit(msr & 0x1fff, msr_bitmap + 0xc00 / f);
>   }
>   
> -static __always_inline void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu,
> -							  u32 msr, int type)
> +void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
>   {
>   	struct vcpu_vmx *vmx = to_vmx(vcpu);
>   	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
> @@ -3864,8 +3861,7 @@ static __always_inline void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu,
>   		vmx_clear_msr_bitmap_write(msr_bitmap, msr);
>   }
>   
> -static __always_inline void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu,
> -							 u32 msr, int type)
> +void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
>   {
>   	struct vcpu_vmx *vmx = to_vmx(vcpu);
>   	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
> @@ -3898,15 +3894,6 @@ static __always_inline void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu,
>   		vmx_set_msr_bitmap_write(msr_bitmap, msr);
>   }
>   
> -void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu,
> -						      u32 msr, int type, bool value)
> -{
> -	if (value)
> -		vmx_enable_intercept_for_msr(vcpu, msr, type);
> -	else
> -		vmx_disable_intercept_for_msr(vcpu, msr, type);
> -}
> -
>   static u8 vmx_msr_bitmap_mode(struct kvm_vcpu *vcpu)
>   {
>   	u8 mode = 0;
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 19fe09fad2fe..008cb87ff088 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -392,8 +392,19 @@ void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
>   bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
>   int vmx_find_loadstore_msr_slot(struct vmx_msrs *m, u32 msr);
>   void vmx_ept_load_pdptrs(struct kvm_vcpu *vcpu);
> -void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu,
> -	u32 msr, int type, bool value);
> +
> +void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type);
> +void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type);
> +
> +static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
> +					     int type, bool value)
> +{
> +	if (value)
> +		vmx_enable_intercept_for_msr(vcpu, msr, type);
> +	else
> +		vmx_disable_intercept_for_msr(vcpu, msr, type);
> +}
> +
>   void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
>   
>   static inline u8 vmx_get_rvi(void)
> 

Queued (and pretty much closing the 5.13 kvm/next branch after this).

Paolo

