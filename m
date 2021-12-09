Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D39FB46E9A9
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 15:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238425AbhLIOPE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 09:15:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238416AbhLIOPD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 09:15:03 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47610C061746;
        Thu,  9 Dec 2021 06:11:30 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id o20so20023868eds.10;
        Thu, 09 Dec 2021 06:11:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=S6sz9Atp4rL/yKWgC+JomL+J1EODMe3Iav1XoDK6GSM=;
        b=ELynI2A8NZ0+8hNP5+URK0b0QCChrJa/X092xEWJm+JQVJaEsRFCUOsrXTQW+1y6qZ
         fkgejIhxXFmc3QNvt1YWl/mQyrTeafE7QmNzZ8XXvKNyPhUub9Ccz906DtD4FcU8s0ym
         BNEOE8b/i2lTscJ+IQNrgpVHg1Nk3QBGLmGJSQ2nQq/CydFCmcNZkZSXjvfCf7N76FrY
         GQcy5DLu+7aVn3hCoGVwGNx3ncS0ro7Ht+fK26tNGH7RR0UTVhSZ+U62xMwRU4O1TeeT
         IWNMFuasoHC1hJgsYecPlJwexrvqPsED1d+/Gc0So/uibYHfxoQIIfSuH7837c/OOPYu
         89mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=S6sz9Atp4rL/yKWgC+JomL+J1EODMe3Iav1XoDK6GSM=;
        b=nOrAXn9zU0MhYEuWSsQta8yXiIvABEWAcy01KIJg/d7aDzyf66h0UouXw+3DyYYKRR
         kc4nkYFJQnzjDeZDRn3x3btaZO77n60a1pN/E5WCP4nt1uSj+5Al9Ds//LasXheNrqJm
         KuxMBISLlxIqCzo7NuHlQc16TU+xYRzL1TPqpcX1hWKWa2kw6NL8QkSvya1SACZRqPDw
         2IuFh4va2JBINzilqw2HeQi/OdzfmYTKaEk3GB5F4oGFhu6+f7VYxfFaGcsjEyGQ026A
         RLiREe1Gcb518RHOA/FA8zEpZndyu+OrBGUGp1vzKQTAGGz91VzGOq0UjpcJLSn2QC3U
         LY+A==
X-Gm-Message-State: AOAM530EcajN7+Xz1Z6vreNHJsKZk9HfpWvW6D5ZLjDyvI2h6Vp6GlE7
        OJjPz3Hb7lOMSOC5cjox3wA=
X-Google-Smtp-Source: ABdhPJxabksuPImxrznQuxxEGmI/Khoo9EthgkBYzvVg4ontXCLqpWK2N5yCZ3oT81+tDSGxQj26aA==
X-Received: by 2002:aa7:ca4f:: with SMTP id j15mr28464368edt.178.1639059085688;
        Thu, 09 Dec 2021 06:11:25 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id ht7sm1639ejc.27.2021.12.09.06.11.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 06:11:25 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <4d723b07-e626-190d-63f4-fd0b5497dd9b@redhat.com>
Date:   Thu, 9 Dec 2021 15:11:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 3/6] KVM: SVM: fix AVIC race of host->guest IPI delivery
 vs AVIC inhibition
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Wanpeng Li <wanpengli@tencent.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>
References: <20211209115440.394441-1-mlevitsk@redhat.com>
 <20211209115440.394441-4-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211209115440.394441-4-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/9/21 12:54, Maxim Levitsky wrote:
> If svm_deliver_avic_intr is called just after the target vcpu's AVIC got
> inhibited, it might read a stale value of vcpu->arch.apicv_active
> which can lead to the target vCPU not noticing the interrupt.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>   arch/x86/kvm/svm/avic.c | 16 +++++++++++++---
>   1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 859ad2dc50f1..8c1b934bfa9b 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -691,6 +691,15 @@ int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
>   	 * automatically process AVIC interrupts at VMRUN.
>   	 */
>   	if (vcpu->mode == IN_GUEST_MODE) {
> +
> +		/*
> +		 * At this point we had read the vcpu->arch.apicv_active == true
> +		 * and the vcpu->mode == IN_GUEST_MODE.
> +		 * Since we have a memory barrier after setting IN_GUEST_MODE,
> +		 * it ensures that AVIC inhibition is complete and thus
> +		 * the target is really running with AVIC enabled.
> +		 */
> +
>   		int cpu = READ_ONCE(vcpu->cpu);

I don't think it's correct.  The vCPU has apicv_active written (in 
kvm_vcpu_update_apicv) before vcpu->mode.

For the acquire/release pair to work properly you need to 1) read 
apicv_active *after* vcpu->mode here 2) use store_release and 
load_acquire for vcpu->mode, respectively in vcpu_enter_guest and here.

Paolo

>   		/*
> @@ -706,10 +715,11 @@ int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
>   		put_cpu();
>   	} else {
>   		/*
> -		 * Wake the vCPU if it was blocking.  KVM will then detect the
> -		 * pending IRQ when checking if the vCPU has a wake event.
> +		 * Kick the target vCPU otherwise, to make sure
> +		 * it processes the interrupt even if its AVIC is inhibited.
>   		 */
> -		kvm_vcpu_wake_up(vcpu);
> +		kvm_make_request(KVM_REQ_EVENT, vcpu);
> +		kvm_vcpu_kick(vcpu);
>   	}
>   
>   	return 0;
> 

