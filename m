Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9929B5ADAFD
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 23:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbiIEV6V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 17:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbiIEV6U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 17:58:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 196C356BA1
        for <kvm@vger.kernel.org>; Mon,  5 Sep 2022 14:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662415098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y3nl9tCsqmEvjle0ma7YPgEK8txZe+k8HAvLSO7Q7mo=;
        b=bGC6MdyB7FRsG/mqoL+gjDxM9IkN0++Rk6LHqa1nx9FrC/cXetUljvGeZ5rYfQokNkgTE6
        yuxmbDW9h7mOs84/QdIe18h15+XuxTJg7RiANBfGVwQlinAMJg7pN+gro073i76Lke83AZ
        tYmKVpRs2+x6v1f5RCLCxsHeSHhfXC0=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-359-zvMZ10TaOBWfDBr0zrCLGA-1; Mon, 05 Sep 2022 17:58:17 -0400
X-MC-Unique: zvMZ10TaOBWfDBr0zrCLGA-1
Received: by mail-ed1-f69.google.com with SMTP id x21-20020a05640226d500b0044856301c62so6359606edd.12
        for <kvm@vger.kernel.org>; Mon, 05 Sep 2022 14:58:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Y3nl9tCsqmEvjle0ma7YPgEK8txZe+k8HAvLSO7Q7mo=;
        b=7SjL1BZEEz8HhfoCCNhR1fSfOHnABecoiLp4ma+QEMk1V0R82iiGw6jGRzlZvTXlxv
         I93y+p5Iwb1clgxCfURZQfdyAYgAEigBCrfKfpANDDBz577BMcB3EuAkyq3SXGRNB6aw
         8mW/MthiYCBTXsRv8RWH5h4yuk8wFPgsykVFL8Spi9YseIwA75aUOXnkpdBiHncUwRen
         7ibd/CqO+1uX4BhVO56PkfIAPnsc/UmuMPbH+F/eqmxlU1nEIrf4++dUbNIfR1/lsZ7d
         R3Od3Wnm2j/FAPdscX5Z7t9LgJQQeo0/Q7aGjBtQz0ntNzQnrza3EMTttQUSSsRMEjLh
         wf0A==
X-Gm-Message-State: ACgBeo02cWlpxwNRI+xFj2ROm42Ll/LBkZ39Qm+1CmjlFEOL4AhKS448
        aqogObBk72Kajwu8VeBnSigyZsjxxIE1BrBbQ64Ne5zG/mBUoAwQBLXa4eeLKcxMt1RtHs5vQ/K
        ZaHQ+JOacKnWd
X-Received: by 2002:a05:6402:354f:b0:448:2385:b998 with SMTP id f15-20020a056402354f00b004482385b998mr36279102edd.57.1662415095941;
        Mon, 05 Sep 2022 14:58:15 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5RI16k6sg5ULbSMla52BrJrq7wX0j6zZg29hKO5aWgejwOSqtB/KbvQbs0UbPZ5gri3CQW9w==
X-Received: by 2002:a05:6402:354f:b0:448:2385:b998 with SMTP id f15-20020a056402354f00b004482385b998mr36279092edd.57.1662415095720;
        Mon, 05 Sep 2022 14:58:15 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:e3ec:5559:7c5c:1928? ([2001:b07:6468:f312:e3ec:5559:7c5c:1928])
        by smtp.googlemail.com with ESMTPSA id f18-20020a17090631d200b007336c3f05bdsm5638371ejf.178.2022.09.05.14.58.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Sep 2022 14:58:15 -0700 (PDT)
Message-ID: <38f5cb16-84d3-d50c-7a85-c4940f3ef319@redhat.com>
Date:   Mon, 5 Sep 2022 23:58:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v2 01/23] KVM: x86: Purge "highest ISR" cache when
 updating APICv state
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
References: <20220903002254.2411750-1-seanjc@google.com>
 <20220903002254.2411750-2-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220903002254.2411750-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/3/22 02:22, Sean Christopherson wrote:
> Purge the "highest ISR" cache when updating APICv state on a vCPU.  The
> cache must not be used when APICv is active as hardware may emulate EOIs
> (and other operations) without exiting to KVM.
> 
> This fixes a bug where KVM will effectively block IRQs in perpetuity due
> to the "highest ISR" never getting reset if APICv is activated on a vCPU
> while an IRQ is in-service.  Hardware emulates the EOI and KVM never gets
> a chance to update its cache.
> 
> Fixes: b26a695a1d78 ("kvm: lapic: Introduce APICv update helper function")
> Cc: stable@vger.kernel.org
> Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/lapic.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 9dda989a1cf0..38e9b8e5278c 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2429,6 +2429,7 @@ void kvm_apic_update_apicv(struct kvm_vcpu *vcpu)
>   		 */
>   		apic->isr_count = count_vectors(apic->regs + APIC_ISR);
>   	}
> +	apic->highest_isr_cache = -1;
>   }
>   EXPORT_SYMBOL_GPL(kvm_apic_update_apicv);
>   
> @@ -2485,7 +2486,6 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
>   		kvm_lapic_set_reg(apic, APIC_TMR + 0x10 * i, 0);
>   	}
>   	kvm_apic_update_apicv(vcpu);
> -	apic->highest_isr_cache = -1;
>   	update_divide_count(apic);
>   	atomic_set(&apic->lapic_timer.pending, 0);
>   
> @@ -2772,7 +2772,6 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
>   	__start_apic_timer(apic, APIC_TMCCT);
>   	kvm_lapic_set_reg(apic, APIC_TMCCT, 0);
>   	kvm_apic_update_apicv(vcpu);
> -	apic->highest_isr_cache = -1;
>   	if (apic->apicv_active) {
>   		static_call_cond(kvm_x86_apicv_post_state_restore)(vcpu);
>   		static_call_cond(kvm_x86_hwapic_irr_update)(vcpu, apic_find_highest_irr(apic));

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

