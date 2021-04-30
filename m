Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFA436F77B
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 11:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbhD3JEP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 05:04:15 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:59716 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbhD3JEP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 05:04:15 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1619773405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bQLJe2vWc77QZO90MG/WZK52RC28OAEA93KFg1edhos=;
        b=RKCg+BApqYuVq7uEf/l3PnLOt+vVeI1FI9YvgjIu3V32QCQUNu3+G7gB+vWO4I4u3vzVQM
        98oDDxwoGtW0q9YcZZ/r08BmGaTdkoanliK0uDB5GXn1fAlrDJ3duh65/K51XMMSceOJIR
        hir50rUQGaNTkXEoVCpGPgO+X3OD4+nT7t3XF/krEH3OJPL19ezSRkq1ZK1RfLRTdWUjtq
        lHmq5wiICOgQ2PzK1r497nihQlNZHwCp9WGru7ZZbuWN/x/jP9k1yob0uh9VOCgvH2jXEK
        TA5tfQaOIcFOOwj2A+assSH/qQkphcApwVV5wSy3NtiMs9dhaVbcoGSKONaB2Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1619773405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bQLJe2vWc77QZO90MG/WZK52RC28OAEA93KFg1edhos=;
        b=tQCKyw1A0DB2zxwte4lI4q+fVS+chFnBaPqnDZh6nwoaxiWHbZfWeyUyAnHEsA66/whM5F
        nOKhLIr6vo/vtPDw==
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 4/4] KVM/VMX: Fold handle_interrupt_nmi_irqoff() into its solo caller
In-Reply-To: <20210426230949.3561-5-jiangshanlai@gmail.com>
References: <20210426230949.3561-1-jiangshanlai@gmail.com> <20210426230949.3561-5-jiangshanlai@gmail.com>
Date:   Fri, 30 Apr 2021 11:03:25 +0200
Message-ID: <87y2d0du02.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Lai,

On Tue, Apr 27 2021 at 07:09, Lai Jiangshan wrote:
>  	u32 intr_info = vmx_get_intr_info(&vmx->vcpu);
> @@ -6427,12 +6417,19 @@ static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
>  static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
>  {
>  	u32 intr_info = vmx_get_intr_info(vcpu);
> +	unsigned int vector;
> +	gate_desc *desc;
>  
>  	if (WARN_ONCE(!is_external_intr(intr_info),
>  	    "KVM: unexpected VM-Exit interrupt info: 0x%x", intr_info))
>  		return;
>  
> -	handle_interrupt_nmi_irqoff(vcpu, intr_info);
> +	vector = intr_info & INTR_INFO_VECTOR_MASK;
> +	desc = (gate_desc *)host_idt_base + vector;
> +
> +	kvm_before_interrupt(vcpu);
> +	vmx_do_interrupt_nmi_irqoff(gate_offset(desc));
> +	kvm_after_interrupt(vcpu);

So the previous patch does:

+               kvm_before_interrupt(&vmx->vcpu);
+               vmx_do_interrupt_nmi_irqoff((unsigned long)asm_noist_exc_nmi);
+               kvm_after_interrupt(&vmx->vcpu);

What is this idt gate descriptor dance for in this code?

Thanks,

        tglx
