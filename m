Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B90444469
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 16:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbhKCPOq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 11:14:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39499 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229603AbhKCPOo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Nov 2021 11:14:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635952327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Q0kkUjDrPbxxe3vqZwu6SNDZQ57Gyckg2LuXgi6MtoI=;
        b=WgD1k8XnR0Y5pwGZ2mo1DJR7FwW6HgIYtsnSr4Zd6mkhzboFIjI/n6INIDp9qRSV0JsUwl
        7Avw8P1Jm4uxLpnT20xMoSUmK2IAzrSZNv2eaBmr2Y5KxTmJsBpWI4StSNDjp/x14tlE4m
        QfMiLaRjcHtjkljeQIxIZ3SGJheNgqs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-481-V8K9Wj7xP5iHsGbfDr8XBA-1; Wed, 03 Nov 2021 11:12:06 -0400
X-MC-Unique: V8K9Wj7xP5iHsGbfDr8XBA-1
Received: by mail-wm1-f69.google.com with SMTP id k5-20020a7bc3050000b02901e081f69d80so1179533wmj.8
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 08:12:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Q0kkUjDrPbxxe3vqZwu6SNDZQ57Gyckg2LuXgi6MtoI=;
        b=tPOpMNYkc2zYQ/fd5H79kzOe+0H/eTFExA9mv3XPHkKU0NbtcoGCMKoCGNb65yef/F
         biFPgubmw2SWAKq4dOyP6U5auwW0JREgbIeOhNj9NVXSN/bPOQXcxd/rCnv14kxIucUK
         4X3JJFvIfwHd1uCIR2RnkKC4mqk4ofxTR/i+T9cRLtl5cAixsrPKDJXdhAjQdOhNa8jG
         lhR14+UmmMs0bmVzFzeMPP2TzxLoKtZQ1nGKdo9Ews7cAuhePe4DAOxSNUKF+t/DPNk5
         GdhUWxQa9zkDIw54gWswcwUTKQWTpqsZ4p/KN7CjYnLTUZh7cmHLZFA8TqC2vQdUCeZ0
         XRxg==
X-Gm-Message-State: AOAM531+Njg+iF+VqNOdiso1TmvcPrcRGGow7fWcwKccQou+41ZDkWn3
        9TGI4ljL4eUfgD05fi3EhnWJCdlBmf4i91n51LQc2jdBfx18aEqim5gXn5NsGjIVscau9C1WgKS
        zxWZGR8vAdqFF3fz9nAoBAOEyzB7P/DGJdBfydMg+QBKD0ZfMdmQipWBICE4CLPSl
X-Received: by 2002:a7b:c157:: with SMTP id z23mr16200004wmi.113.1635952324891;
        Wed, 03 Nov 2021 08:12:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxneK8A+uMzpSWQRxthB2Qz5GIxq2FiIxn73+TFNRcp/rPhnzqO2+olwEKz8eJCCk5JFgRdxA==
X-Received: by 2002:a7b:c157:: with SMTP id z23mr16199946wmi.113.1635952324589;
        Wed, 03 Nov 2021 08:12:04 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id w17sm2251876wrp.79.2021.11.03.08.12.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 08:12:03 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Li RongQing <lirongqing@baidu.com>
Cc:     lirongqing@baidu.com, pbonzini@redhat.com, seanjc@google.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org
Subject: Re: [PATCH][v2] KVM: Clear pv eoi pending bit only when it is set
In-Reply-To: <1634797513-11005-1-git-send-email-lirongqing@baidu.com>
References: <1634797513-11005-1-git-send-email-lirongqing@baidu.com>
Date:   Wed, 03 Nov 2021 16:12:02 +0100
Message-ID: <87tugtmfy5.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Li RongQing <lirongqing@baidu.com> writes:

> merge pv_eoi_get_pending and pv_eoi_clr_pending into a single
> function pv_eoi_test_and_clear_pending, which returns and clear
> the value of the pending bit.
>
> and clear pv eoi pending bit only when it is set, to avoid calling
> pv_eoi_put_user(), this can speed about 300 nsec on AMD EPYC most
> of the time
>
> and make pv_eoi_set_pending as inline as there is only one user

Compiler is likely smart enough to inline static functions with a single
user anyway.

>
> Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
> diff with v1:
>  merge as pv_eoi_test_and_clear_pending
>  add inline for pv_eoi_set_pending
>
>  arch/x86/kvm/lapic.c |   47 +++++++++++++++++++++++------------------------
>  1 files changed, 23 insertions(+), 24 deletions(-)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 76fb009..4da5db8 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -673,18 +673,7 @@ static inline bool pv_eoi_enabled(struct kvm_vcpu *vcpu)
>  	return vcpu->arch.pv_eoi.msr_val & KVM_MSR_ENABLED;
>  }
>  
> -static bool pv_eoi_get_pending(struct kvm_vcpu *vcpu)
> -{
> -	u8 val;
> -	if (pv_eoi_get_user(vcpu, &val) < 0) {
> -		printk(KERN_WARNING "Can't read EOI MSR value: 0x%llx\n",
> -			   (unsigned long long)vcpu->arch.pv_eoi.msr_val);
> -		return false;
> -	}
> -	return val & KVM_PV_EOI_ENABLED;
> -}
> -
> -static void pv_eoi_set_pending(struct kvm_vcpu *vcpu)
> +static inline void pv_eoi_set_pending(struct kvm_vcpu *vcpu)
>  {
>  	if (pv_eoi_put_user(vcpu, KVM_PV_EOI_ENABLED) < 0) {
>  		printk(KERN_WARNING "Can't set EOI MSR value: 0x%llx\n",
> @@ -694,14 +683,31 @@ static void pv_eoi_set_pending(struct kvm_vcpu *vcpu)
>  	__set_bit(KVM_APIC_PV_EOI_PENDING, &vcpu->arch.apic_attention);
>  }
>  
> -static void pv_eoi_clr_pending(struct kvm_vcpu *vcpu)
> +static inline bool pv_eoi_test_and_clr_pending(struct kvm_vcpu *vcpu)
>  {
> -	if (pv_eoi_put_user(vcpu, KVM_PV_EOI_DISABLED) < 0) {
> +	u8 val;
> +
> +	if (pv_eoi_get_user(vcpu, &val) < 0) {
> +		printk(KERN_WARNING "Can't read EOI MSR value: 0x%llx\n",
> +			   (unsigned long long)vcpu->arch.pv_eoi.msr_val);

pr_warn() would probably be a better choice but looking at this makes me
wonder: isn't it triggerable by the guest? I think it is when the value
written to MSR_KVM_PV_EOI_EN is bogus and this is bad: we don't even
ratelimit these messages! I think this printk() needs to be dropped.

> +		return false;
> +	}
> +
> +	val &= KVM_PV_EOI_ENABLED;
> +
> +	/*
> +	 * Clear pending bit in any case: it will be set again on vmentry.
> +	 * While this might not be ideal from performance point of view,
> +	 * this makes sure pv eoi is only enabled when we know it's safe.
> +	 */
> +	if (val && pv_eoi_put_user(vcpu, KVM_PV_EOI_DISABLED) < 0) {
>  		printk(KERN_WARNING "Can't clear EOI MSR value: 0x%llx\n",
>  			   (unsigned long long)vcpu->arch.pv_eoi.msr_val);

... and this one, probably, too.

> -		return;
> +		return false;
>  	}
>  	__clear_bit(KVM_APIC_PV_EOI_PENDING, &vcpu->arch.apic_attention);
> +
> +	return !!val;
>  }
>  
>  static int apic_has_interrupt_for_ppr(struct kvm_lapic *apic, u32 ppr)
> @@ -2673,7 +2679,6 @@ void __kvm_migrate_apic_timer(struct kvm_vcpu *vcpu)
>  static void apic_sync_pv_eoi_from_guest(struct kvm_vcpu *vcpu,
>  					struct kvm_lapic *apic)
>  {
> -	bool pending;
>  	int vector;
>  	/*
>  	 * PV EOI state is derived from KVM_APIC_PV_EOI_PENDING in host
> @@ -2687,14 +2692,8 @@ static void apic_sync_pv_eoi_from_guest(struct kvm_vcpu *vcpu,
>  	 * 	-> host enabled PV EOI, guest executed EOI.
>  	 */
>  	BUG_ON(!pv_eoi_enabled(vcpu));
> -	pending = pv_eoi_get_pending(vcpu);
> -	/*
> -	 * Clear pending bit in any case: it will be set again on vmentry.
> -	 * While this might not be ideal from performance point of view,
> -	 * this makes sure pv eoi is only enabled when we know it's safe.
> -	 */
> -	pv_eoi_clr_pending(vcpu);
> -	if (pending)
> +
> +	if (pv_eoi_test_and_clr_pending(vcpu))
>  		return;
>  	vector = apic_set_eoi(apic);
>  	trace_kvm_pv_eoi(apic, vector);

-- 
Vitaly

