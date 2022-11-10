Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 112EF623E3C
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 10:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbiKJJDo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 04:03:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiKJJDl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 04:03:41 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CAD033C;
        Thu, 10 Nov 2022 01:03:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=euI2vGaCMOurHqYTryBqSzQToVvfrQztpsrGNy9bXsQ=; b=TP1THSpJ+c3gRZNp5f+dqEfJoe
        wzxT9yY8Lb3IXEf6f3/b9Hr2C7XntmdicAQ7NQGD68PdDKXVGmbxIcs93VUmHmTD22kjI7o4pARUV
        cLGKyOvQ7Krk5HXHofjIm5rBTLkPhVwpLR+IniSy1b28WkKzPNPloH90eaUjHX1L9UetEv+Xs7JZc
        WyZvmgJ5SJSA/nWZoyMp8R5EO63PiUC01GKBKq6ZzO8xkDSGOiEULGYhqzdX/JFypgtER4Wnh/2DU
        vHN4c/m8Tlp+xrb0tvJcm0LJfv6OFolPpM9Dd/bMHGJyWV3uUXZdiKdFH17yHsbaBj3lrHpHfUlqO
        mKLxxmSQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ot3T8-00AF8u-Qq; Thu, 10 Nov 2022 09:03:31 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 3169130013F;
        Thu, 10 Nov 2022 10:03:30 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 146BA2016A1E7; Thu, 10 Nov 2022 10:03:30 +0100 (CET)
Date:   Thu, 10 Nov 2022 10:03:30 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Xin Li <xin3.li@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, kevin.tian@intel.com
Subject: Re: [RESEND PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq()
 for NMI/IRQ reinjection
Message-ID: <Y2y+YgBUYuUHbPtd@hirez.programming.kicks-ass.net>
References: <20221110061545.1531-1-xin3.li@intel.com>
 <20221110061545.1531-6-xin3.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110061545.1531-6-xin3.li@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 09, 2022 at 10:15:44PM -0800, Xin Li wrote:
> To eliminate dispatching NMI/IRQ through the IDT, add
> kvm_vmx_reinject_nmi_irq(), which calls external_interrupt()
> for IRQ reinjection.
> 
> Lastly replace calling a NMI/IRQ handler in an IDT descriptor
> with calling kvm_vmx_reinject_nmi_irq().
> 
> Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
> Signed-off-by: Xin Li <xin3.li@intel.com>

Idem.


> +#if IS_ENABLED(CONFIG_KVM_INTEL)
> +/*
> + * KVM VMX reinjects NMI/IRQ on its current stack, it's a sync
> + * call thus the values in the pt_regs structure are not used in
> + * executing NMI/IRQ handlers, except cs.RPL and flags.IF, which
> + * are both always 0 in the VMX NMI/IRQ reinjection context. Thus
> + * we simply allocate a zeroed pt_regs structure on current stack
> + * to call external_interrupt().
> + */
> +void kvm_vmx_reinject_nmi_irq(u32 vector)

noinstr ?

> +{
> +	struct pt_regs irq_regs;
> +
> +	memset(&irq_regs, 0, sizeof(irq_regs));
> +
> +	if (vector == NMI_VECTOR)
> +		return exc_nmi(&irq_regs);
> +
> +	external_interrupt(&irq_regs, vector);
> +}
> +EXPORT_SYMBOL_GPL(kvm_vmx_reinject_nmi_irq);
> +#endif

> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 63247c57c72c..b457e4888468 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -46,6 +46,7 @@
>  #include <asm/mshyperv.h>
>  #include <asm/mwait.h>
>  #include <asm/spec-ctrl.h>
> +#include <asm/traps.h>
>  #include <asm/virtext.h>
>  #include <asm/vmx.h>
>  
> @@ -6758,15 +6759,11 @@ static void vmx_apicv_post_state_restore(struct kvm_vcpu *vcpu)
>  	memset(vmx->pi_desc.pir, 0, sizeof(vmx->pi_desc.pir));
>  }
>  
> -void vmx_do_interrupt_nmi_irqoff(unsigned long entry);
> -
> -static void handle_interrupt_nmi_irqoff(struct kvm_vcpu *vcpu,
> -					unsigned long entry)
> +static void handle_interrupt_nmi_irqoff(struct kvm_vcpu *vcpu, u32 vector)
>  {
> -	bool is_nmi = entry == (unsigned long)asm_exc_nmi_noist;
> -
> -	kvm_before_interrupt(vcpu, is_nmi ? KVM_HANDLING_NMI : KVM_HANDLING_IRQ);
> -	vmx_do_interrupt_nmi_irqoff(entry);
> +	kvm_before_interrupt(vcpu, vector == NMI_VECTOR ?
> +				   KVM_HANDLING_NMI : KVM_HANDLING_IRQ);
> +	kvm_vmx_reinject_nmi_irq(vector);
>  	kvm_after_interrupt(vcpu);
>  }
>  
> @@ -6792,7 +6789,6 @@ static void handle_nm_fault_irqoff(struct kvm_vcpu *vcpu)
>  
>  static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
>  {
> -	const unsigned long nmi_entry = (unsigned long)asm_exc_nmi_noist;
>  	u32 intr_info = vmx_get_intr_info(&vmx->vcpu);
>  
>  	/* if exit due to PF check for async PF */
> @@ -6806,20 +6802,19 @@ static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
>  		kvm_machine_check();
>  	/* We need to handle NMIs before interrupts are enabled */
>  	else if (is_nmi(intr_info))
> -		handle_interrupt_nmi_irqoff(&vmx->vcpu, nmi_entry);
> +		handle_interrupt_nmi_irqoff(&vmx->vcpu, NMI_VECTOR);
>  }
>  
>  static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
>  {
>  	u32 intr_info = vmx_get_intr_info(vcpu);
>  	unsigned int vector = intr_info & INTR_INFO_VECTOR_MASK;
> -	gate_desc *desc = (gate_desc *)host_idt_base + vector;
>  
>  	if (KVM_BUG(!is_external_intr(intr_info), vcpu->kvm,
>  	    "KVM: unexpected VM-Exit interrupt info: 0x%x", intr_info))
>  		return;
>  
> -	handle_interrupt_nmi_irqoff(vcpu, gate_offset(desc));
> +	handle_interrupt_nmi_irqoff(vcpu, vector);
>  	vcpu->arch.at_instruction_boundary = true;
>  }

How does any of this work? You're calling into entry/noinstr code from a
random context.
