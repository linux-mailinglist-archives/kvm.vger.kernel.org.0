Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5169D54C990
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 15:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348551AbiFONQJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 09:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348671AbiFONQG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 09:16:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A4CC62AE0E
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 06:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655298962;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GGMoK0dBr7jI0WO9jxsn/4g0PcNmGPG/r/RjMpd5QKw=;
        b=JE7o6Cs3UZxPB8QshboRSI/8jz1glJd+TObHZRra7SjkLj/QHcHSbzBXRFvG3CoFbfAicm
        lcfmif7Ko/pWbNIXJ04GgOnC8FeFV6QwDxxcvUNdZxdsTTPdR90DH7XxPxHT00FiFvozD0
        VXufpLztXJO54x7cjxlup8wrCkmBU8o=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-369-9IltEqetMqmgp5CfCAO6UQ-1; Wed, 15 Jun 2022 09:16:00 -0400
X-MC-Unique: 9IltEqetMqmgp5CfCAO6UQ-1
Received: by mail-wm1-f72.google.com with SMTP id l17-20020a05600c4f1100b0039c860db521so1210197wmq.5
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 06:16:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GGMoK0dBr7jI0WO9jxsn/4g0PcNmGPG/r/RjMpd5QKw=;
        b=fcxSU47xuhywG+K/OFPd1IJ2UE4vDmkbV7EO3yi0PpD08muuZ8w3eUV/I9kMHsOQ2n
         Rm/VpOhmsozda9oBuiBDYEA1f5bAnjKoITJgZbJzt3nsnFOHkjcldyARwrxYPxjcWNM3
         l5gMfO5lcH5draoa6wmkoqqQUpfIdUscPSGPbgnfhjMsUy8zjoQLwxmUa+0kNMOvC4dO
         gJwnB1VXb4ZBShNoidfeBtYCHld8Fcal+qbRnl7R0KPLdiUE5yUbL4Eu7ewIOslKSjlN
         vWXQVms6J+MxjZNc5uIUArbjVDV9Gp+ilsNy+oeX94rirYgbWv71nzMdAvx4Bs27WZq1
         nkIw==
X-Gm-Message-State: AJIora/Sqh+Snj4LvZ+3LlcxLCxU32E3VZvg3+Toe6YXsY+KCc0GXU/o
        ejK3oVvsdbgo8q0jVv6RrWQJHSfJEpu65GwJYzUkROr4dEU+HiKd/L82dmnPOa4Anq2Fy1BEbpv
        Oqvs/ygZClS8F
X-Received: by 2002:a5d:5343:0:b0:210:2f76:649f with SMTP id t3-20020a5d5343000000b002102f76649fmr9857363wrv.554.1655298959671;
        Wed, 15 Jun 2022 06:15:59 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uZTTUuLIhwW/JKSpydaV5zNU+WdofNfbjpGUkhFVdMKyfyyfOpV3eIwJqM4HNrL7XxzX+5CQ==
X-Received: by 2002:a5d:5343:0:b0:210:2f76:649f with SMTP id t3-20020a5d5343000000b002102f76649fmr9857342wrv.554.1655298959355;
        Wed, 15 Jun 2022 06:15:59 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id d14-20020a056000114e00b0020fffbc122asm17152597wrx.99.2022.06.15.06.15.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jun 2022 06:15:58 -0700 (PDT)
Message-ID: <c7f07be6-3674-4553-0ae9-548886ba9b6f@redhat.com>
Date:   Wed, 15 Jun 2022 15:15:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 2/5] KVM: x86: Drop @vcpu parameter from
 kvm_x86_ops.hwapic_isr_update()
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220614230548.3852141-1-seanjc@google.com>
 <20220614230548.3852141-3-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220614230548.3852141-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/15/22 01:05, Sean Christopherson wrote:
> Drop the unused @vcpu parameter from hwapic_isr_update().  AMD/AVIC is
> unlikely to implement the helper, and VMX/APICv doesn't need the vCPU as
> it operates on the current VMCS.  The result is somewhat odd, but allows
> for a decent amount of (future) cleanup in the APIC code.
> 
> No functional change intended.

Yeah, that's a bit odd; what it saves is essentially the apic->vcpu 
dereference.  I don't really like it, so if you want to have a v2 that 
passes the struct kvm_lapic* instead (which is free and keeps irr/isr 
functions consistent), I'll gladly switch.  But I _have_ queued the 
series in the meanwhile, so that's a good reason to ignore me.

Paolo

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h | 2 +-
>   arch/x86/kvm/lapic.c            | 8 ++++----
>   arch/x86/kvm/vmx/vmx.c          | 2 +-
>   3 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 7e98b2876380..16acc54d49a7 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1517,7 +1517,7 @@ struct kvm_x86_ops {
>   	bool (*check_apicv_inhibit_reasons)(enum kvm_apicv_inhibit reason);
>   	void (*refresh_apicv_exec_ctrl)(struct kvm_vcpu *vcpu);
>   	void (*hwapic_irr_update)(struct kvm_vcpu *vcpu, int max_irr);
> -	void (*hwapic_isr_update)(struct kvm_vcpu *vcpu, int isr);
> +	void (*hwapic_isr_update)(int isr);
>   	bool (*guest_apic_has_interrupt)(struct kvm_vcpu *vcpu);
>   	void (*load_eoi_exitmap)(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
>   	void (*set_virtual_apic_mode)(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index a413a1d8df4c..cc0da5671eb9 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -556,7 +556,7 @@ static inline void apic_set_isr(int vec, struct kvm_lapic *apic)
>   	 * just set SVI.
>   	 */
>   	if (unlikely(vcpu->arch.apicv_active))
> -		static_call_cond(kvm_x86_hwapic_isr_update)(vcpu, vec);
> +		static_call_cond(kvm_x86_hwapic_isr_update)(vec);
>   	else {
>   		++apic->isr_count;
>   		BUG_ON(apic->isr_count > MAX_APIC_VECTOR);
> @@ -604,7 +604,7 @@ static inline void apic_clear_isr(int vec, struct kvm_lapic *apic)
>   	 * and must be left alone.
>   	 */
>   	if (unlikely(vcpu->arch.apicv_active))
> -		static_call_cond(kvm_x86_hwapic_isr_update)(vcpu, apic_find_highest_isr(apic));
> +		static_call_cond(kvm_x86_hwapic_isr_update)(apic_find_highest_isr(apic));
>   	else {
>   		--apic->isr_count;
>   		BUG_ON(apic->isr_count < 0);
> @@ -2457,7 +2457,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
>   	if (vcpu->arch.apicv_active) {
>   		static_call_cond(kvm_x86_apicv_post_state_restore)(vcpu);
>   		static_call_cond(kvm_x86_hwapic_irr_update)(vcpu, -1);
> -		static_call_cond(kvm_x86_hwapic_isr_update)(vcpu, -1);
> +		static_call_cond(kvm_x86_hwapic_isr_update)(-1);
>   	}
>   
>   	vcpu->arch.apic_arb_prio = 0;
> @@ -2737,7 +2737,7 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
>   	if (vcpu->arch.apicv_active) {
>   		static_call_cond(kvm_x86_apicv_post_state_restore)(vcpu);
>   		static_call_cond(kvm_x86_hwapic_irr_update)(vcpu, apic_find_highest_irr(apic));
> -		static_call_cond(kvm_x86_hwapic_isr_update)(vcpu, apic_find_highest_isr(apic));
> +		static_call_cond(kvm_x86_hwapic_isr_update)(apic_find_highest_isr(apic));
>   	}
>   	kvm_make_request(KVM_REQ_EVENT, vcpu);
>   	if (ioapic_in_kernel(vcpu->kvm))
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 5e14e4c40007..42f8924a90f4 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6556,7 +6556,7 @@ static void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
>   	put_page(page);
>   }
>   
> -static void vmx_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
> +static void vmx_hwapic_isr_update(int max_isr)
>   {
>   	u16 status;
>   	u8 old;

