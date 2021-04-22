Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7700A367DE8
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 11:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235755AbhDVJmG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 05:42:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55895 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235742AbhDVJmE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Apr 2021 05:42:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619084489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MRXM9RIwGAzOvqMViksoCgJRxC5LWVQ/YL3QO9+2J5w=;
        b=ESgM2D7uCUikgWajvU/cy2xM0Q9ov0/3GgjoS0wAsiABO+1KraqtK7vSVJXqu9zG3MZKmc
        2TH7+CE9czEwPdc49OdAPKZWSB/zIPmcRCV7rURBGdev1pfzp48jFVytnKSyh6K1NjzuMI
        eQ5veheoebXvG/5slKp5qV3UhwqLuRs=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-147-5fdNMsBFPZ2BgEMxNO-73w-1; Thu, 22 Apr 2021 05:40:52 -0400
X-MC-Unique: 5fdNMsBFPZ2BgEMxNO-73w-1
Received: by mail-ej1-f71.google.com with SMTP id ne22-20020a1709077b96b02903803a047edeso5667074ejc.3
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 02:40:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MRXM9RIwGAzOvqMViksoCgJRxC5LWVQ/YL3QO9+2J5w=;
        b=AN9V3ReceMtnBgbS1YX5ymL4fSpfThERsPQ+lL+woWTzyxzWnSdFYn4ZmBeAiQ2Krq
         wgG+7KqZDXvNECH/1epB2Ud1pGnIdOjFb48RBEt1/xu0eJja91C8stEcHwbec6BcIyeI
         PIaQB4gA0ZI1ctpC4wHOWyNX7gQmPgJcdAh6TfJa48URqw2LeqlMXwMi3LdaYZG/c3Sa
         I5yKWNjJ+0XELTT6x/vauvwaAJOpJAnjIg+hTrsSJuPlHAzOi0iqQ0tv4LR39Qq4WChw
         QUpvZpmNF8KxuWU8IYCUYqHIk/CmmZw02Az3eIxcoUaNZOwa2qZQ6mQ/r3vyk0XfXntD
         kBrw==
X-Gm-Message-State: AOAM533VmaQxHaDvgSn8gpu5uv9y3gosvYZC4LxcvBZTTiV/rlejyELc
        bOImrsm8Dd6EapK0QGRQBwG8V85USKGhj4STsLGsIObjViHogpTJiX9P2lYyZAg+TqgmvD7lpbs
        qUWZWUO0PwZVv
X-Received: by 2002:a05:6402:7cf:: with SMTP id u15mr2612988edy.297.1619084450887;
        Thu, 22 Apr 2021 02:40:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxnMzqy1125yms4Nol3cFwtHxqmArRXTyoltonwXQvq5a1i+kLde1d2VZXwKNGWHqM1hcuLOw==
X-Received: by 2002:a05:6402:7cf:: with SMTP id u15mr2612972edy.297.1619084450679;
        Thu, 22 Apr 2021 02:40:50 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id q10sm1649695eds.26.2021.04.22.02.40.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 02:40:50 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: Properly handle APF vs disabled LAPIC situation
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Sebastien Boeuf <sebastien.boeuf@intel.com>,
        linux-kernel@vger.kernel.org
References: <20210422092948.568327-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9a4601c7-c6a3-1b38-96de-e9d470fcaa8d@redhat.com>
Date:   Thu, 22 Apr 2021 11:40:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210422092948.568327-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/04/21 11:29, Vitaly Kuznetsov wrote:
> Async PF 'page ready' event may happen when LAPIC is (temporary) disabled.
> In particular, Sebastien reports that when Linux kernel is directly booted
> by Cloud Hypervisor, LAPIC is 'software disabled' when APF mechanism is
> initialized. On initialization KVM tries to inject 'wakeup all' event and
> puts the corresponding token to the slot. It is, however, failing to inject
> an interrupt (kvm_apic_set_irq() -> __apic_accept_irq() -> !apic_enabled())
> so the guest never gets notified and the whole APF mechanism gets stuck.
> The same issue is likely to happen if the guest temporary disables LAPIC
> and a previously unavailable page becomes available.
> 
> Do two things to resolve the issue:
> - Avoid dequeuing 'page ready' events from APF queue when LAPIC is
>    disabled.
> - Trigger an attempt to deliver pending 'page ready' events when LAPIC
>    becomes enabled (SPIV or MSR_IA32_APICBASE).
> 
> Reported-by: Sebastien Boeuf <sebastien.boeuf@intel.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>   arch/x86/kvm/lapic.c | 6 ++++++
>   arch/x86/kvm/x86.c   | 2 +-
>   2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index cc369b9ad8f1..49a839d0567a 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -296,6 +296,10 @@ static inline void apic_set_spiv(struct kvm_lapic *apic, u32 val)
>   
>   		atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
>   	}
> +
> +	/* Check if there are APF page ready requests pending */
> +	if (enabled)
> +		kvm_make_request(KVM_REQ_APF_READY, apic->vcpu);
>   }
>   
>   static inline void kvm_apic_set_xapic_id(struct kvm_lapic *apic, u8 id)
> @@ -2261,6 +2265,8 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
>   		if (value & MSR_IA32_APICBASE_ENABLE) {
>   			kvm_apic_set_xapic_id(apic, vcpu->vcpu_id);
>   			static_branch_slow_dec_deferred(&apic_hw_disabled);
> +			/* Check if there are APF page ready requests pending */
> +			kvm_make_request(KVM_REQ_APF_READY, vcpu);
>   		} else {
>   			static_branch_inc(&apic_hw_disabled.key);
>   			atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a06a6f48386d..001c6a445eaf 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11296,7 +11296,7 @@ bool kvm_arch_can_dequeue_async_page_present(struct kvm_vcpu *vcpu)
>   	if (!kvm_pv_async_pf_enabled(vcpu))
>   		return true;
>   	else
> -		return apf_pageready_slot_free(vcpu);
> +		return kvm_lapic_enabled(vcpu) && apf_pageready_slot_free(vcpu);
>   }
>   
>   void kvm_arch_start_assignment(struct kvm *kvm)
> 

Queued, with

Cc: stable@vger.kernel.org

Paolo

