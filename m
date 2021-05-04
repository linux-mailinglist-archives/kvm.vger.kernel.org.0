Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD4783726F5
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 10:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbhEDILo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 04:11:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56030 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230043AbhEDILn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 May 2021 04:11:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620115848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7qjyE39N3bF2ncX4ajvi/suOmZwRdS2DR748897diBQ=;
        b=ZS21iLNPjETakXLPHft8/Wpthuc2BGbuaubDvdpRy+uujyl0Nkc6FruCX5GeJCSG8247nh
        InHOLNCnyLqZE71RgnouWdJoQwXMSsfHMZlBFdAyhBruqTkRFyJfndQX4F+Ua/u3IGrquA
        cJuQn++wrRltgOuytJW01elNzuLZDok=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-589-K4eV2F-BPdCv1rE7bqKohg-1; Tue, 04 May 2021 04:10:45 -0400
X-MC-Unique: K4eV2F-BPdCv1rE7bqKohg-1
Received: by mail-ej1-f72.google.com with SMTP id z13-20020a1709067e4db02903a28208c9bdso2822458ejr.0
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 01:10:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7qjyE39N3bF2ncX4ajvi/suOmZwRdS2DR748897diBQ=;
        b=qKPy5JtRj078ch9EVQPKh5GXwHGBFLL4xEcjUBA3Q6Ctck/PNirnz8rakMHuxMPia0
         ScNF8Wi9c3GyLTiwbIhK/tQ3/BztvyVUKBTkr6iKCMPOnF9z9wYHSNUCwt9QfUS/Jd/0
         ZyCuoX0e8eAQiI+fQOJOIVd1WUpLb8S2MG1lXP/NQeiUhbpmHu1m43HOxwrHm7vQbgCe
         tUKbc9d8uJWOrU09jvWw5Q+T0MW1weo91tP2EzTRfc9XjYjYJeqNMmeebE5VrsuLUZC7
         wemAATTlB1/lC+1GS2Fcsw/10L7O8ysJZnTtWdaeYyYf3JrTru2Pv8Axqh5H2+8M5fKX
         VbUw==
X-Gm-Message-State: AOAM533IsU2nhmVazsFZb7BnW0+ovT4C9cij0ij0Af89UocH47e+DAtd
        iIw35UBBSvb0FizZR4T6Ry+m3ml8o3qWhhWgx+gPNmk9fd8FbPcttxr6nc+PG4GryCRLkTA3dIq
        IpquYki5/Nk85
X-Received: by 2002:a17:907:72cc:: with SMTP id du12mr20177460ejc.436.1620115844192;
        Tue, 04 May 2021 01:10:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyQcuwOUeVVSnFxwEpEhamj+QvCvZG06wMaGnmC6TdRZGX6Bbm18WADkqIA+ZYd6bsqEgPagQ==
X-Received: by 2002:a17:907:72cc:: with SMTP id du12mr20177447ejc.436.1620115844009;
        Tue, 04 May 2021 01:10:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id q16sm14094053edv.61.2021.05.04.01.10.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 May 2021 01:10:43 -0700 (PDT)
Subject: Re: [PATCH 3/4] KVM/VMX: Invoke NMI non-IST entry instead of IST
 entry
To:     Thomas Gleixner <tglx@linutronix.de>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andi Kleen <ak@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
References: <20210426230949.3561-1-jiangshanlai@gmail.com>
 <20210426230949.3561-4-jiangshanlai@gmail.com>
 <87eeenk2l5.ffs@nanos.tec.linutronix.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <baa499a7-2b63-2970-04a6-e2c68796adc7@redhat.com>
Date:   Tue, 4 May 2021 10:10:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <87eeenk2l5.ffs@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/05/21 22:02, Thomas Gleixner wrote:
> but this and the next patch are not really needed. The below avoids the
> extra kvm_before/after() dance in both places. Hmm?

Sure, that's good as well.

Paolo

> Thanks,
> 
>          tglx
> ---
> --- a/arch/x86/kernel/nmi.c
> +++ b/arch/x86/kernel/nmi.c
> @@ -526,6 +526,10 @@ DEFINE_IDTENTRY_RAW(exc_nmi)
>   
>   DEFINE_IDTENTRY_RAW_ALIAS(exc_nmi, exc_nmi_noist);
>   
> +#if IS_MODULE(CONFIG_KVM_INTEL)
> +EXPORT_SYMBOL_GPL(asm_exc_nmi_noist);
> +#endif
> +
>   void stop_nmi(void)
>   {
>   	ignore_nmis++;
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -36,6 +36,7 @@
>   #include <asm/debugreg.h>
>   #include <asm/desc.h>
>   #include <asm/fpu/internal.h>
> +#include <asm/idtentry.h>
>   #include <asm/io.h>
>   #include <asm/irq_remapping.h>
>   #include <asm/kexec.h>
> @@ -6395,18 +6396,17 @@ static void vmx_apicv_post_state_restore
>   
>   void vmx_do_interrupt_nmi_irqoff(unsigned long entry);
>   
> -static void handle_interrupt_nmi_irqoff(struct kvm_vcpu *vcpu, u32 intr_info)
> +static void handle_interrupt_nmi_irqoff(struct kvm_vcpu *vcpu,
> +					unsigned long entry)
>   {
> -	unsigned int vector = intr_info & INTR_INFO_VECTOR_MASK;
> -	gate_desc *desc = (gate_desc *)host_idt_base + vector;
> -
>   	kvm_before_interrupt(vcpu);
> -	vmx_do_interrupt_nmi_irqoff(gate_offset(desc));
> +	vmx_do_interrupt_nmi_irqoff(entry);
>   	kvm_after_interrupt(vcpu);
>   }
>   
>   static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
>   {
> +	const unsigned long nmi_entry = (unsigned long)asm_exc_nmi_noist;
>   	u32 intr_info = vmx_get_intr_info(&vmx->vcpu);
>   
>   	/* if exit due to PF check for async PF */
> @@ -6417,18 +6417,20 @@ static void handle_exception_nmi_irqoff(
>   		kvm_machine_check();
>   	/* We need to handle NMIs before interrupts are enabled */
>   	else if (is_nmi(intr_info))
> -		handle_interrupt_nmi_irqoff(&vmx->vcpu, intr_info);
> +		handle_interrupt_nmi_irqoff(&vmx->vcpu, nmi_entry);
>   }
>   
>   static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
>   {
>   	u32 intr_info = vmx_get_intr_info(vcpu);
> +	unsigned int vector = intr_info & INTR_INFO_VECTOR_MASK;
> +	gate_desc *desc = (gate_desc *)host_idt_base + vector;
>   
>   	if (WARN_ONCE(!is_external_intr(intr_info),
>   	    "KVM: unexpected VM-Exit interrupt info: 0x%x", intr_info))
>   		return;
>   
> -	handle_interrupt_nmi_irqoff(vcpu, intr_info);
> +	handle_interrupt_nmi_irqoff(vcpu, gate_offset(desc));
>   }
>   
>   static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)

