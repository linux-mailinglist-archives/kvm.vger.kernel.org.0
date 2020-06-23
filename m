Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81DBD204F7E
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 12:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732213AbgFWKse (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 06:48:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32897 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728472AbgFWKsd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 06:48:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592909312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ky8iFv1h6LPmF3FBkPey2j/azT3a5HnwVWrFIZh/Ck0=;
        b=Fdg+whi9bpBd6SVvaXmlWIwnx7Xi9+7fNWxc8iCu4IFuNaB9YAopwh8/NxfAmXddiQIgzw
        fBwKDfphqHk3je70/5sNUh4oOhlR2YcJ3kFkeWt0DeJTJyFlAcFQsuT9l+6sPHSSlS7EOI
        LenkOrNsY/IYZKi3bX//E62GdmYKfMc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-DvYM-PtvNvm4r5lbUy37_Q-1; Tue, 23 Jun 2020 06:48:30 -0400
X-MC-Unique: DvYM-PtvNvm4r5lbUy37_Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BBCE8464
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 10:48:29 +0000 (UTC)
Received: from starship (unknown [10.35.206.216])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A7D3B5C660;
        Tue, 23 Jun 2020 10:48:28 +0000 (UTC)
Message-ID: <fdc7db39d2f806b25ac3ab26d2cf692c0e22b53d.camel@redhat.com>
Subject: Re: [PATCH] SVM: add test for nested guest RIP corruption
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>
Date:   Tue, 23 Jun 2020 13:48:27 +0300
In-Reply-To: <fc46c0a2-7a05-797e-3909-36b47ae302e0@redhat.com>
References: <20200622165533.145882-1-mlevitsk@redhat.com>
         <fc46c0a2-7a05-797e-3909-36b47ae302e0@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2020-06-22 at 19:30 +0200, Paolo Bonzini wrote:
> On 22/06/20 18:55, Maxim Levitsky wrote:
> > +/*
> > + * Detect nested guest RIP corruption as explained in kernel commit
> > + * b6162e82aef19fee9c32cb3fe9ac30d9116a8c73
> > + *
> > + * In the assembly loop below, execute 'ins' from a IO port,
> > + * while not intercepting IO violations, so that this instruction is
> > + * intercepted and emulated by the L0 qemu.
> > + *
> > + * At the same time we are getting interrupts from the local APIC timer,
> > + * and we do intercept them in L1
> > + *
> > + * If interrupt happens on the insb instruction, L0 will VMexit, emulate
> > + * the insb instruction and then it will try to inject the interrupt to L1
> > + * by doing a nested VMexit (since L1 intercepts interrupts),
> > + * and due to a bug it will use pre-emulation value of RIP,RAX and RSP.
> > + *
> > + * In our intercept handler we check that RIP is of the insb instruction,
> > + * (corrupted) but its memory operand is already written meaning,
> > + * that insb was already executed.
> > + */
> 
> Looks good, just some wording improvements
> 
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index 30009c4..827ff87 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -1793,21 +1793,20 @@ static bool virq_inject_check(struct svm_test *test)
>   * Detect nested guest RIP corruption as explained in kernel commit
>   * b6162e82aef19fee9c32cb3fe9ac30d9116a8c73
>   *
> - * In the assembly loop below, execute 'ins' from a IO port,
> - * while not intercepting IO violations, so that this instruction is
> - * intercepted and emulated by the L0 qemu.
> + * In the assembly loop below 'ins' is executed while IO instructions
> + * are not intercepted; the instruction is emulated by L0.
>   *
>   * At the same time we are getting interrupts from the local APIC timer,
>   * and we do intercept them in L1
>   *
> - * If interrupt happens on the insb instruction, L0 will VMexit, emulate
> - * the insb instruction and then it will try to inject the interrupt to L1
> - * by doing a nested VMexit (since L1 intercepts interrupts),
> - * and due to a bug it will use pre-emulation value of RIP,RAX and RSP.
> + * If the interrupt happens on the insb instruction, L0 will VMexit, emulate
> + * the insb instruction and then it will inject the interrupt to L1 through
> + * a nested VMexit.  Due to a bug, it would leave pre-emulation values of RIP,
> + * RAX and RSP in the VMCB.
>   *
> - * In our intercept handler we check that RIP is of the insb instruction,
> - * (corrupted) but its memory operand is already written meaning,
> - * that insb was already executed.
> + * In our intercept handler we detect the bug by checking that RIP is that of
> + * the insb instruction, but its memory operand has already been written.
> + * This means that insb was already executed.
>   */
Fixed.

>  
> > +static void reg_corruption_test(struct svm_test *test)
> > +{
> > +    /* this is endless loop, which is interrupted by the timer interrupt */
> > +    asm volatile (
> > +            "again:\n\t"
> > +            "movw $0x4d0, %%dx\n\t" // IO port
> > +            "lea %[_io_port_var], %%rdi\n\t"
> > +            "movb $0xAA, %[_io_port_var]\n\t"
> > +            "insb_instruction_label:\n\t"
> > +            "insb\n\t"
> > +            "jmp again\n\t"
> 
> And here you could use "1:" and "jmp 1b" instead of a global label.
Good idea, I will do this in V2.

> 
> You said offlist that an "inb" instruction would not work, but I'm not sure
> I understand why.  Wouldn't you see "0xAA" in vmcb->save.rax with the fixed
> kernel, and something else with the broken one?

The problem is that when you use orginary inb, you can't distinguish between
case when inb just wasn't yet executed (and we got an interrupt on previous instruction)
or it was executed, but due to corruption all its side effects were reverted

(since inb only effect is a change of RIP and a change of EAX, and sadly EAX is hardcoded
for this instruction, since this is good old instruction from the good old 
 days when 'a' meant accumulator, and both are corrupted (reverted to old values) )

On the other hand, insb, effect is to write to memory the value, and change RIP,
and only RIP is reverted to old value, so I can detect this.

I'll send a V2 now.

Best regards,
	Maxim Levitsky


> 
> Paolo
> 
> > +
> > +            : [_io_port_var] "=m" (io_port_var)
> > +            : /* no inputs*/
> > +            : "rdx", "rdi"
> > +    );
> > +}
> > +
> > +static bool reg_corruption_finished(struct svm_test *test)
> > +{
> > +    if (isr_cnt == 10000) {
> > +        report(true,
> > +               "No RIP corruption detected after %d timer interrupts",
> > +               isr_cnt);
> > +        set_test_stage(test, 1);
> > +        return true;
> > +    }
> > +
> > +    if (vmcb->control.exit_code == SVM_EXIT_INTR) {
> > +
> > +        void* guest_rip = (void*)vmcb->save.rip;
> > +
> > +        irq_enable();
> > +        asm volatile ("nop");
> > +        irq_disable();
> > +
> > +        if (guest_rip == insb_instruction_label && io_port_var != 0xAA) {
> > +            report(false,
> > +                   "RIP corruption detected after %d timer interrupts",
> > +                   isr_cnt);
> > +            return true;
> > +        }
> > +
> > +    }
> > +    return false;
> > +}
> > +
> > +static bool reg_corruption_check(struct svm_test *test)
> > +{
> > +    return get_test_stage(test) == 1;
> > +}
> > +
> >  #define TEST(name) { #name, .v2 = name }
> >  
> >  /*
> > @@ -1950,6 +2050,9 @@ struct svm_test svm_tests[] = {
> >      { "virq_inject", default_supported, virq_inject_prepare,
> >        default_prepare_gif_clear, virq_inject_test,
> >        virq_inject_finished, virq_inject_check },
> > +    { "reg_corruption", default_supported, reg_corruption_prepare,
> > +      default_prepare_gif_clear, reg_corruption_test,
> > +      reg_corruption_finished, reg_corruption_check },
> >      TEST(svm_guest_state_test),
> >      { NULL, NULL, NULL, NULL, NULL, NULL, NULL }
> >  };
> > 


