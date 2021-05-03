Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 477D1372111
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 22:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbhECUDl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 16:03:41 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:49378 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhECUDl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 May 2021 16:03:41 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1620072166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XgZpXyzMSt2ZuSYziPI65CE3gq9cUvnBGAFcSg9BFNk=;
        b=0i59kTSGkQNolbf+b00nTId26MVXzcV5mMXdgH+7pm5p9eZTQxLdS5ke1KZ1fcn0Sted+p
        SVhLjMIy8xe2gdBAI9KELdGngxDTAGEEOdKNHagihHIfQdW1VIFyVDPVUErdnrZBshowNe
        iRX8KFp3zcwl9eMIaNfj56CED/9F8Nb2eFDuVNB+rMgdfphdSZFuyj2Xm8uxdUKnf6r2Bo
        bwxK++/NdjUiTXupD3kWuFL8Y9F1Lx5MmWAGGsVDscaaNyPdanXtH7W+kJzQnEQUkUq7EM
        WhKmzVfOoZg3xWiIO8SPCU0KJGBtW8V8U5vQ2KyoTdhEbJI743slY1chrXC2Wg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1620072166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XgZpXyzMSt2ZuSYziPI65CE3gq9cUvnBGAFcSg9BFNk=;
        b=RQOjtFI0ZhFjpV5vlGvNQ+NvXBfAy77dvWKiYp6tyVG5UhVtN0a221OcYkCYj7rFCuiK2W
        0ma3zEvtPU+pV8Dg==
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
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
Subject: Re: [PATCH 3/4] KVM/VMX: Invoke NMI non-IST entry instead of IST entry
In-Reply-To: <20210426230949.3561-4-jiangshanlai@gmail.com>
References: <20210426230949.3561-1-jiangshanlai@gmail.com> <20210426230949.3561-4-jiangshanlai@gmail.com>
Date:   Mon, 03 May 2021 22:02:46 +0200
Message-ID: <87eeenk2l5.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 27 2021 at 07:09, Lai Jiangshan wrote:
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index bcbf0d2139e9..96e59d912637 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -36,6 +36,7 @@
>  #include <asm/debugreg.h>
>  #include <asm/desc.h>
>  #include <asm/fpu/internal.h>
> +#include <asm/idtentry.h>
>  #include <asm/io.h>
>  #include <asm/irq_remapping.h>
>  #include <asm/kexec.h>
> @@ -6416,8 +6417,11 @@ static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
>  	else if (is_machine_check(intr_info))
>  		kvm_machine_check();
>  	/* We need to handle NMIs before interrupts are enabled */
> -	else if (is_nmi(intr_info))
> -		handle_interrupt_nmi_irqoff(&vmx->vcpu, intr_info);
> +	else if (is_nmi(intr_info)) {

Lacks curly braces for all of the above conditions according to coding style.

> +		kvm_before_interrupt(&vmx->vcpu);
> +		vmx_do_interrupt_nmi_irqoff((unsigned long)asm_noist_exc_nmi);
> +		kvm_after_interrupt(&vmx->vcpu);
> +	}

but this and the next patch are not really needed. The below avoids the
extra kvm_before/after() dance in both places. Hmm?

Thanks,

        tglx
---
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -526,6 +526,10 @@ DEFINE_IDTENTRY_RAW(exc_nmi)
 
 DEFINE_IDTENTRY_RAW_ALIAS(exc_nmi, exc_nmi_noist);
 
+#if IS_MODULE(CONFIG_KVM_INTEL)
+EXPORT_SYMBOL_GPL(asm_exc_nmi_noist);
+#endif
+
 void stop_nmi(void)
 {
 	ignore_nmis++;
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -36,6 +36,7 @@
 #include <asm/debugreg.h>
 #include <asm/desc.h>
 #include <asm/fpu/internal.h>
+#include <asm/idtentry.h>
 #include <asm/io.h>
 #include <asm/irq_remapping.h>
 #include <asm/kexec.h>
@@ -6395,18 +6396,17 @@ static void vmx_apicv_post_state_restore
 
 void vmx_do_interrupt_nmi_irqoff(unsigned long entry);
 
-static void handle_interrupt_nmi_irqoff(struct kvm_vcpu *vcpu, u32 intr_info)
+static void handle_interrupt_nmi_irqoff(struct kvm_vcpu *vcpu,
+					unsigned long entry)
 {
-	unsigned int vector = intr_info & INTR_INFO_VECTOR_MASK;
-	gate_desc *desc = (gate_desc *)host_idt_base + vector;
-
 	kvm_before_interrupt(vcpu);
-	vmx_do_interrupt_nmi_irqoff(gate_offset(desc));
+	vmx_do_interrupt_nmi_irqoff(entry);
 	kvm_after_interrupt(vcpu);
 }
 
 static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
 {
+	const unsigned long nmi_entry = (unsigned long)asm_exc_nmi_noist;
 	u32 intr_info = vmx_get_intr_info(&vmx->vcpu);
 
 	/* if exit due to PF check for async PF */
@@ -6417,18 +6417,20 @@ static void handle_exception_nmi_irqoff(
 		kvm_machine_check();
 	/* We need to handle NMIs before interrupts are enabled */
 	else if (is_nmi(intr_info))
-		handle_interrupt_nmi_irqoff(&vmx->vcpu, intr_info);
+		handle_interrupt_nmi_irqoff(&vmx->vcpu, nmi_entry);
 }
 
 static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
 {
 	u32 intr_info = vmx_get_intr_info(vcpu);
+	unsigned int vector = intr_info & INTR_INFO_VECTOR_MASK;
+	gate_desc *desc = (gate_desc *)host_idt_base + vector;
 
 	if (WARN_ONCE(!is_external_intr(intr_info),
 	    "KVM: unexpected VM-Exit interrupt info: 0x%x", intr_info))
 		return;
 
-	handle_interrupt_nmi_irqoff(vcpu, intr_info);
+	handle_interrupt_nmi_irqoff(vcpu, gate_offset(desc));
 }
 
 static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
