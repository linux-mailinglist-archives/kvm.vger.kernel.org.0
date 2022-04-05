Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81FC34F4977
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 02:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388543AbiDEWRX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 18:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457222AbiDEQC5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 12:02:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F2D26198
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 08:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649172836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iGOKDprACpATycXmJsJYt0TllS34C5LvZmKh+gyonAQ=;
        b=KNRGDcoIJYi0FhWh3t4fufY2bBzPXVj39HwY5PCXVBARvBsaJrnQuYDTQ/G+VXEEme4QbV
        FugiiNjzKEmcloI9egT9Wyc278dwwIH+nusp6w8u0bpTeh2R6mSTdj0jZXVm5KpHri4MG6
        DYeT5exSveoXrfrgT1t4iP+raWJxLMM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-237-9emytrnuMV2BWbXfBIlJgw-1; Tue, 05 Apr 2022 11:33:55 -0400
X-MC-Unique: 9emytrnuMV2BWbXfBIlJgw-1
Received: by mail-wm1-f69.google.com with SMTP id l19-20020a05600c1d1300b0038e736f98faso1672181wms.4
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 08:33:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=iGOKDprACpATycXmJsJYt0TllS34C5LvZmKh+gyonAQ=;
        b=W3udf+EyviON63K0/a5eAOgpJhdQttiveZlUBOWaA53FWY0mroQXLwTt1zekXLyukO
         r1+5/oCam26n8+f510enL4PnsbZOc2sLUW3EO7/Y04obrqfCBsdh6KG45vnzC7ukCn5m
         VFg4Ib9P81BTKKfCGh/fLfmT+PYseySDTdFpImYaPC74urxCFJGtJoOi59l7Uf7Dk+09
         ZabO6Jyw+bA07fzzZtAYyZWTxR2gOD8WfM/kJD1OLTtJUqjjaNZxADLIKVahbWBvF5oA
         0eBn7Ztu3vt09Ssj4YL9QEh2S+9RotOJESAnZhVgVILFSLHWKqOaIX5hbLhsr0soDNu2
         olyQ==
X-Gm-Message-State: AOAM532vBqEUcFuOpMQJCOiX9uP7vuAVB2sKAkQUBpJgtMAzeGUmifZx
        pXVArmQm1A7cS1mVKSMPqUutYLxtofL8fC4bYCa0CuA/qzR3KrfUegVQrbpR2LXMdpno3d3lPJG
        IXO0cBeHeed69
X-Received: by 2002:adf:9062:0:b0:206:b5e:e934 with SMTP id h89-20020adf9062000000b002060b5ee934mr3260389wrh.434.1649172833798;
        Tue, 05 Apr 2022 08:33:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxZlE3/xOwZtXTofjeLu7evIxwxLrhbxXRly/qWwB4adoa71jNtkNARlrTJNIUNiWWNVyFiPw==
X-Received: by 2002:adf:9062:0:b0:206:b5e:e934 with SMTP id h89-20020adf9062000000b002060b5ee934mr3260366wrh.434.1649172833544;
        Tue, 05 Apr 2022 08:33:53 -0700 (PDT)
Received: from [10.32.181.87] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id e12-20020a5d6d0c000000b001a65e479d20sm14953605wrq.83.2022.04.05.08.33.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 08:33:52 -0700 (PDT)
Message-ID: <ad71b70b-34da-c14b-5cca-cf8a0b544050@redhat.com>
Date:   Tue, 5 Apr 2022 17:33:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 076/104] KVM: x86: Add option to force LAPIC
 expiration wait
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <52b0451a4ffba54455acf710b443715ac16effd4.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <52b0451a4ffba54455acf710b443715ac16effd4.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:49, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Add an option to skip the IRR check-in kvm_wait_lapic_expire().  This
> will be used by TDX to wait if there is an outstanding notification for
> a TD, i.e. a virtual interrupt is being triggered via posted interrupt
> processing.  KVM TDX doesn't emulate PI processing, i.e. there will
> never be a bit set in IRR/ISR, so the default behavior for APICv of
> querying the IRR doesn't work as intended.

Would be better to explain "doesn't work as intended" more verbosely. 
Otherwise,

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/lapic.c   | 4 ++--
>   arch/x86/kvm/lapic.h   | 2 +-
>   arch/x86/kvm/svm/svm.c | 2 +-
>   arch/x86/kvm/vmx/vmx.c | 2 +-
>   4 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 9322e6340a74..d49f029ef0e3 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1620,12 +1620,12 @@ static void __kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
>   		__wait_lapic_expire(vcpu, tsc_deadline - guest_tsc);
>   }
>   
> -void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
> +void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu, bool force_wait)
>   {
>   	if (lapic_in_kernel(vcpu) &&
>   	    vcpu->arch.apic->lapic_timer.expired_tscdeadline &&
>   	    vcpu->arch.apic->lapic_timer.timer_advance_ns &&
> -	    lapic_timer_int_injected(vcpu))
> +	    (force_wait || lapic_timer_int_injected(vcpu)))
>   		__kvm_wait_lapic_expire(vcpu);
>   }
>   EXPORT_SYMBOL_GPL(kvm_wait_lapic_expire);
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index 2b44e533fc8d..2a0119ef9e96 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -233,7 +233,7 @@ static inline int kvm_lapic_latched_init(struct kvm_vcpu *vcpu)
>   
>   bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector);
>   
> -void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu);
> +void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu, bool force_wait);
>   
>   void kvm_bitmap_or_dest_vcpus(struct kvm *kvm, struct kvm_lapic_irq *irq,
>   			      unsigned long *vcpu_bitmap);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index c7eec23e9ebe..a46415845f48 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3766,7 +3766,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>   	clgi();
>   	kvm_load_guest_xsave_state(vcpu);
>   
> -	kvm_wait_lapic_expire(vcpu);
> +	kvm_wait_lapic_expire(vcpu, false);
>   
>   	/*
>   	 * If this vCPU has touched SPEC_CTRL, restore the guest's value if
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 00f88aa25047..9b7bd52d19a9 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6838,7 +6838,7 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>   	if (enable_preemption_timer)
>   		vmx_update_hv_timer(vcpu);
>   
> -	kvm_wait_lapic_expire(vcpu);
> +	kvm_wait_lapic_expire(vcpu, false);
>   
>   	/*
>   	 * If this vCPU has touched SPEC_CTRL, restore the guest's value if

