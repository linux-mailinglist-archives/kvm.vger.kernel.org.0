Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1C1472B85
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 12:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236173AbhLMLej (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 06:34:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235966AbhLMLeh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 06:34:37 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9793CC061370;
        Mon, 13 Dec 2021 03:34:36 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id e3so51686286edu.4;
        Mon, 13 Dec 2021 03:34:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2e+UzRHJrxGPPbZbFl3bp02hL6qW3g/3CXhqDegQXgY=;
        b=lH4bKcV/MYfbCayfl/Uz5ftNa5t2S1eJFIcB/ZAt0HfLIZVovbwizoyOdLSYqVkWr1
         +JdNtbtLiNsqRZnFgTxKuj3KfXt7UABFNmO6ogqDJGkqcyL6D7Bu5Np3m4rzk5QOA+bA
         2yndlT2MKmnryf6RacXKnVDdmp3AfSDVUZ43rlVvhksTxHfTnuIfZD9ZC7QwSFa1kiux
         ZcG4dgeOsTjzjPdknhx1uLPI9CrHGgVCn7yUm8oYWFyTYwQkMpFJJAM5MDXkGxfzhoZB
         DZUdeQzQKzC1jTmTs3snbIV5L2rdBhhu5uwedDZIHsjNX02nIzTbPnEcEgKqpAVbGPcr
         R/Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2e+UzRHJrxGPPbZbFl3bp02hL6qW3g/3CXhqDegQXgY=;
        b=AyZfgVcrdVWi4mfoF8pBG4DyEZK/IqEDZe9IDL2TCvAdIbMnQCSMD/qSNZfkn+T2uH
         ANksM/VLDqKiuajuQeRlpqcfya1UI1q0rhNkHJDy8Oxlk9XpScTjcr7OcrSTgUNlFm6B
         3lABLGdPYdMYAmb2/WKcuaqR8FumEG0y2y2l35QNTS/4SeWj8VCs/OqOIujnoyeD6+Da
         FpcqKJ46takng8Lr8yU9dDNChhyz5X7OZmMlcG1tkk0+S4n7wHAeppRy0QZhdusBJ/6M
         vo+BLY8qmQlFqQMC/ruKF5hksfUk9WZeg6KJp05+skeJeNtU0zrroYYXz0EjtMZLHF2D
         456Q==
X-Gm-Message-State: AOAM532URgedxTL+52tFkuHoPiQmCNWHKSVwbwNI2nE9CGqAcAeigleT
        d2pA2ciOVPVJidjEAoqOaA4=
X-Google-Smtp-Source: ABdhPJxQ75d60voASMmkeQXmRq5Wk8RM74ghwGmxeGWXH15Kc/F0Yv1JhPRcJGGlp8B7ljQdpgXQ7A==
X-Received: by 2002:a50:9e0f:: with SMTP id z15mr63057251ede.278.1639395275080;
        Mon, 13 Dec 2021 03:34:35 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id sc27sm6043432ejc.125.2021.12.13.03.34.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 03:34:34 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <0d893664-ff8d-83ed-e9be-441b45992f68@redhat.com>
Date:   Mon, 13 Dec 2021 12:34:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 1/5] KVM: nSVM: deal with L1 hypervisor that intercepts
 interrupts but lets L2 control EFLAGS.IF
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>
References: <20211213104634.199141-1-mlevitsk@redhat.com>
 <20211213104634.199141-2-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211213104634.199141-2-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/13/21 11:46, Maxim Levitsky wrote:
> Fix a corner case in which L1 hypervisor intercepts interrupts (INTERCEPT_INTR)
> and either doesn't use virtual interrupt masking (V_INTR_MASKING) or
> enters a nested guest with EFLAGS.IF disabled prior to the entry.
> 
> In this case, despite the fact that L1 intercepts the interrupts,
> KVM still needs to set up an interrupt window to wait before it
> can deliver INTR vmexit.
> 
> Currently instead, the KVM enters an endless loop of 'req_immediate_exit'.
> 
> Note that on VMX this case is impossible as there is only
> 'vmexit on external interrupts' execution control which either set,
> in which case both host and guest's EFLAGS.IF
> is ignored, or clear, in which case no VMexit is delivered.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>   arch/x86/kvm/svm/svm.c | 10 +++++++---
>   1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index e57e6857e0630..c9668a3b51011 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3372,17 +3372,21 @@ bool svm_interrupt_blocked(struct kvm_vcpu *vcpu)
>   static int svm_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
>   {
>   	struct vcpu_svm *svm = to_svm(vcpu);
> +	bool blocked;
> +
>   	if (svm->nested.nested_run_pending)
>   		return -EBUSY;
>   
> +	blocked = svm_interrupt_blocked(vcpu);
> +
>   	/*
>   	 * An IRQ must not be injected into L2 if it's supposed to VM-Exit,
>   	 * e.g. if the IRQ arrived asynchronously after checking nested events.
>   	 */
>   	if (for_injection && is_guest_mode(vcpu) && nested_exit_on_intr(svm))
> -		return -EBUSY;
> -
> -	return !svm_interrupt_blocked(vcpu);
> +		return !blocked ? -EBUSY : 0;
> +	else
> +		return !blocked;
>   }
>   
>   static void svm_enable_irq_window(struct kvm_vcpu *vcpu)
> 

Right, another case is when CLGI is not trapped and the guest therefore
runs with GIF=0.  I think that means that a similar change has to be
done in all the *_allowed functions.

I would write it as

   	if (svm->nested.nested_run_pending)
   		return -EBUSY;
   
	if (svm_interrupt_blocked(vcpu))
		return 0;

   	/*
   	 * An IRQ must not be injected into L2 if it's supposed to VM-Exit,
   	 * e.g. if the IRQ arrived asynchronously after checking nested events.
   	 */
   	if (for_injection && is_guest_mode(vcpu) && nested_exit_on_intr(svm))
		return -EBUSY;
	return 1;

Paolo
