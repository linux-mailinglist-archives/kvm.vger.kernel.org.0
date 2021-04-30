Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78567370419
	for <lists+kvm@lfdr.de>; Sat,  1 May 2021 01:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232868AbhD3X3F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 19:29:05 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:35800 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232743AbhD3X3E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 19:29:04 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1619825294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZWIXGxsC9fIrA9QtkZ2ON4W1CtmbVqdtSPqPS/LyVLs=;
        b=4pGKVfILoKjrDk7FCKteZbqgCDaUqpPgOhAIhlaZiqfIjqP7VoptwlWB9Z1fa4J2Wldift
        HfIfZ2zxJCcH/Xk5rw+eJmZVGwQD6oujNuMLGL7CoEWZPAEB6Yglxu4pQlp2EMsC0Cj4O/
        k3OZh5Wjp1riPtMfewopsimcWs+v2VRnkOgorrELvqyKuKpjGC64IFZPGlIFNHrA6Urjx4
        2y2pbthYNF2YCJAqwpyHXNSJBkdbgrYzdt4AtuNDHFTBUxErXhxXwJa2RBPYj5rFmsmYs9
        tjtJXLt5b6NlBFNqysL1FY+m4i4JNVRYguzQtutXpBOF+D99JC1pB515eldKCg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1619825294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZWIXGxsC9fIrA9QtkZ2ON4W1CtmbVqdtSPqPS/LyVLs=;
        b=71xiDsgwftD2kQ+g1zDYJ6vqX/OR0RbRckWWZcZ1E3GLEWkaUSE/Oqfsx6zlbOAyaXTLfg
        fdnAmKT49xgROkBQ==
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 4/4] KVM/VMX: Fold handle_interrupt_nmi_irqoff() into its solo caller
In-Reply-To: <ba3f6230-8766-92e5-1189-a114c236fd48@redhat.com>
References: <20210426230949.3561-1-jiangshanlai@gmail.com> <20210426230949.3561-5-jiangshanlai@gmail.com> <87y2d0du02.ffs@nanos.tec.linutronix.de> <ba3f6230-8766-92e5-1189-a114c236fd48@redhat.com>
Date:   Sat, 01 May 2021 01:28:14 +0200
Message-ID: <87im43e4j5.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 30 2021 at 11:06, Paolo Bonzini wrote:

> On 30/04/21 11:03, Thomas Gleixner wrote:
>> Lai,
>> 
>> On Tue, Apr 27 2021 at 07:09, Lai Jiangshan wrote:
>>>   	u32 intr_info = vmx_get_intr_info(&vmx->vcpu);
>>> @@ -6427,12 +6417,19 @@ static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
>>>   static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
>>>   {
>>>   	u32 intr_info = vmx_get_intr_info(vcpu);
>>> +	unsigned int vector;
>>> +	gate_desc *desc;
>>>   
>>>   	if (WARN_ONCE(!is_external_intr(intr_info),
>>>   	    "KVM: unexpected VM-Exit interrupt info: 0x%x", intr_info))
>>>   		return;
>>>   
>>> -	handle_interrupt_nmi_irqoff(vcpu, intr_info);
>>> +	vector = intr_info & INTR_INFO_VECTOR_MASK;
>>> +	desc = (gate_desc *)host_idt_base + vector;
>>> +
>>> +	kvm_before_interrupt(vcpu);
>>> +	vmx_do_interrupt_nmi_irqoff(gate_offset(desc));
>>> +	kvm_after_interrupt(vcpu);
>> 
>> So the previous patch does:
>> 
>> +               kvm_before_interrupt(&vmx->vcpu);
>> +               vmx_do_interrupt_nmi_irqoff((unsigned long)asm_noist_exc_nmi);
>> +               kvm_after_interrupt(&vmx->vcpu);
>> 
>> What is this idt gate descriptor dance for in this code?
>
> NMIs are sent through a different vmexit code (the same one as 
> exceptions).  This one is for interrupts.

Duh. Yes. The ability to read is clearly an advantage...
