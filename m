Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4B5A1E257E
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 17:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729601AbgEZPao (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 11:30:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21774 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728166AbgEZPan (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 11:30:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590507041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oICMtBevH79U5i33q6gFVls3d8AwSemn8edp7fR4BSg=;
        b=BGszRfSS3h9elWNkhzKdzrkXMF3lg0XXJ/qb+4gha08tHPf5deb5F9KLmI9SI2tv+j7TGG
        LGxD2R+oeg1J5TKPwuOmLQBqFY94A++uDxyK2nfBNEctYPl53MmQpnE2uBwM6bW4rsfro1
        6vLz74c+5fubEqk0bsm2+zWkkUFlrx0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-482-_cw3D9X7MCaO3aetw38ALQ-1; Tue, 26 May 2020 11:30:39 -0400
X-MC-Unique: _cw3D9X7MCaO3aetw38ALQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4DFF8EC1A3
        for <kvm@vger.kernel.org>; Tue, 26 May 2020 15:30:38 +0000 (UTC)
Received: from starship (unknown [10.35.206.69])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 39B458ECE1;
        Tue, 26 May 2020 15:30:37 +0000 (UTC)
Message-ID: <db1da9b57ac55d436e8a83bca614de9a8691fd58.camel@redhat.com>
Subject: Re: #DE
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org
Date:   Tue, 26 May 2020 18:30:35 +0300
In-Reply-To: <deb611de-76a9-b0b4-751b-8ef91d5f8902@redhat.com>
References: <0fa0acac-f3b6-96c0-6ac8-18ec4d573aab@redhat.com>
         <233a810765c8b026778e76e9f8828a9ad0b3716d.camel@redhat.com>
         <b58b5d08-97a6-1e64-d8db-7ce74084553a@redhat.com>
         <3957e9600ae84bf8548d05ab8fbeb343d0239843.camel@redhat.com>
         <deb611de-76a9-b0b4-751b-8ef91d5f8902@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2020-05-25 at 18:45 +0200, Paolo Bonzini wrote:
> On 25/05/20 17:13, Maxim Levitsky wrote:
> > With all this said, this is what is happening:
> > 
> > 1. The host sets interrupt window. It needs interrupts window because (I guess) that guest
> > disabled interrupts and it waits till interrupts are enabled to inject the interrupt.
> > 
> > To be honest this is VMX limitation, and in SVM (I think according to the spec) you can inject
> > interrupts whenever you want and if the guest can't accept then interrupt, the vector written to EVENTINJ field,
> > will be moved to V_INTR_VECTOR and V_INTR flag will be set,
> 
> Not exactly, EVENTINJ ignores the interrupt flag and everything else.  
Aha! I totaly missed this, that is why I told that I am somewhat guessing
this since I haven't found the place that said otherwise. Now I understand.
Moreover this means that V_IRQ can't be _set_ by the processor as I feared
it could, and can only be cleared, when the interrupt is taken, thus
this is what they mean whey they say that V_IRQ is written back on VmExit.
This changes everything.


> But yes, you can inject the interrupt any time you want using V_IRQ + 
> V_INTR_VECTOR and it will be injected by the processor.  This is a 
> very interesting feature but it doesn't fit very well in the KVM
> architecture so we're not using it.  Hyper-V does (and it is also
> why it broke mercilessly).
Aha, now I understand that well. I was under impression that V_IRQ/V_INTR_VECTOR,
are more like set by CPU and and EVENTINJ is the way to inject interrupts.
Now it is all clear.

> 
> > 2. Since SVM doesn't really have a concept of interrupt window 
> > intercept, this is faked by setting V_INTR, as if injected (or as
> > they call it virtual) interrupt is pending, together with intercept
> > of virtual interrupts,
> Correct.
> 
> > 4. After we enter the nested guest, we eventually get an VMexit due
> > to unrelated reason and we sync the V_INTR that *we* set
> > to the nested vmcs, since in theory that flag could have beeing set
> > by the CPU itself, if the guest itself used EVENTINJ to inject
> > an event to its nested guest while the nested guest didn't have
> > interrupts enabled (KVM doesn't do this, but we can't assume that)
> 
> I suppose you mean in sync_nested_vmcb_control.  Here, in the latest version,
Yep.
> we have:
> 
>         mask = V_IRQ_MASK | V_TPR_MASK;
>         if (!(svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK) &&
>             is_intercept(svm, SVM_EXIT_VINTR)) {
>                 /*
>                  * In order to request an interrupt window, L0 is usurping
>                  * svm->vmcb->control.int_ctl and possibly setting V_IRQ
>                  * even if it was clear in L1's VMCB.  Restoring it would be
>                  * wrong.  However, in this case V_IRQ will remain true until
>                  * interrupt_window_interception calls svm_clear_vintr and
>                  * restores int_ctl.  We can just leave it aside.
>                  */
>                 mask &= ~V_IRQ_MASK;
>         }
> 
> and svm_clear_vintr will copy V_IRQ, V_INTR_VECTOR, etc. back from the nested_vmcb
> into svm->vmcb.  Is that enough to fix the bug?

No I have the exact same version, however as is turned out that for some reason
you didn't publish the changes, thus I indeed was running an outdated version.
It works now, and the fix for the reference was that you made the code
not to set interrupt window at all when running a nested guest
since nested guest getting an interrupt almost always meanst VMEXIT
which can't be masked. The only case where it is still needed is
when the guest doesn't intercept physical interrupts which should 
be handled as well (I haven't yet studied how that works now,
but since it is a corner case almost nobody uses, it doesn't matter much).


> 
> > 5. At that point the bomb is ticking. Once the guest ends dealing
> > with the nested guest VMexit, and executes VMRUN, we enter the nested
> > guest with V_INTR enabled. V_INTER intercept is disabled since we
> > disabled our interrupt window long ago, guest is also currently
> > doesn't enable any interrupt window, so we basically injecting to the
> > guest whatever is there in V_INTR_VECTOR in the nested guest's VMCB.
> 
> Yep, this sounds correct.  The question is whether it can still happen
> in the latest version of the code, where I tried to think more about who
> owns which int_ctl bits when.
Works now.
> 
> > Now that I am thinking about this the issue is deeper that I thought
> > and it stems from the abuse of the V_INTR on AMD. IMHO the best
> > solution is to avoid interrupt windows on AMD unless really needed
> > (like with level-triggered interrupts or so)
> 
> Yes, that is the root cause.  However I'm not sure it would be that
> much simpler if we didn't abuse VINTR like that, because INT_CTL is a
> very complicated field.
> 
> > Now the problem is that it is next to impossible to know the source
> > of the VINTR pending flag. Even if we remember that host is currently
> > setup an interrupt window, the guest afterwards could have used
> > EVENTINJ + interrupt disabled nested guest, to raise that flag as
> > well, and might need to know about it.
> 
> Actually it is possible!  is_intercept tests L0's VINTR intercept
> (see get_host_vmcb in svm.h), and that will be true if and only if
> we are abusing the V_IRQ/V_INTR_PRIO/V_INTR_VECTOR fields.
Yep. I wasn't aware of logic in svm_check_nested_events.
In fact I think that it was added by the path that I found via bisect,
since which the nesting started to not work well.

BTW, since nesting is broken with that #DE on mainline, should we prepare
some patches to -stable to fix that?


> 
> Furthermore, L0 should not use VINTR during nested VMRUN only if both
> the following conditions are true:
> 
> - L1 is not using V_INTR_MASKING
> 
> - L0 has a pending interrupt (of course)
> 
> This is because when virtual interrupts are in use, you can inject
> physical interrupts into L1 at any time by taking an EXIT_INTR vmexit.

I agree, and now this is done this way





> 
> My theory as to why the bug could happen involved a race between
> the call to kvm_x86_ops.interrupt_allowed(vcpu, true) in
> inject_pending_event and the call to kvm_cpu_has_injectable_intr
> in vcpu_enter_guest.  Again, that one should be fixed in the
> latest version on the branch, but there could be more than one bug!
> 
> > I have an idea on how to fix this, which is about 99% correct and will only fail if the guest attempt something that
> > is undefined anyway.
> > 
> > Lets set the vector of the fake VINTR to some reserved exception value, rather that 0 (which the guest is not supposed to inject ever to the nested guest),
> > so then we will know if the VINTR is from our fake injection or from the guest itself.
> > If it is our VINTR then we will not sync it to the guest.
> > In theory it can be even 0, since exceptions should never be injected as interrupts anyway, this is also reserved operation.
> 
> Unfortunately these are interrupts, not exceptions.  You _can_ configure
> the PIC (or probably the IOAPIC too) to inject vectors in the 0-31 range.
> Are you old enough to remember INT 8 as the timer interrupt? :)

No sadly :-) My computer life started with pentium 133 and windows 98 
But I am aware of this, I was just thinking that nobody would do this anyway.

I still remember from my Intel's job, closing about 2-3 bugreports per year for 
user error of injecting an random interrupt vector and hitting an exception handler
which expects an error code, and thus crashing the whole thing.


> 
> Thanks very much for the detective work though!  You made a good walkthrough
> overall so you definitely understood good parts of the code.

Thank you too. I think that this bug was probably the thing
I enjoyed the most since I joined Red-Hat.
(closely followed by my nvme-mdev driver)

> 
> Paolo
> 

Best regards,
	Maxim Levitsky


