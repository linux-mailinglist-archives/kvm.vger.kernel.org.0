Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF3093BDE70
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 22:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbhGFUc2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 16:32:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34524 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229781AbhGFUc2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 16:32:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625603388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d8tEA/jaNVVhmwIw6ly8R8E8/6ffrRq5U58cNS03CS8=;
        b=ZI0AtFUspGyJ/otpmeu3j781k8DHDb5G5wLSqIVmM2Imsq2aFbhqkWBtEMrTpgVnxowCBi
        7EZOWNMxAAKAnTNifQdQpE/o/qdibSAwy/hW8ScYGmNCUrDu1Q8vJ23+bXhPkDyLx4+7hx
        +yM9qFRGS5OAIGuever/EMRvQ2+Lo4M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-576-uIR8tikhNme5ppua3zAcNQ-1; Tue, 06 Jul 2021 16:29:47 -0400
X-MC-Unique: uIR8tikhNme5ppua3zAcNQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CA72D1B18BC0;
        Tue,  6 Jul 2021 20:29:45 +0000 (UTC)
Received: from starship (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 164852EB30;
        Tue,  6 Jul 2021 20:29:41 +0000 (UTC)
Message-ID: <71e0308e9e289208b8457306b3cb6d6f23e795f9.camel@redhat.com>
Subject: Re: [PATCH v2] KVM: X86: Fix exception untrigger on ret to user
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     stsp <stsp2@yandex.ru>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Jan Kiszka <jan.kiszka@siemens.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Date:   Tue, 06 Jul 2021 23:29:40 +0300
In-Reply-To: <7f264d9f-cb59-0d10-d435-b846f9b61333@yandex.ru>
References: <20210628124814.1001507-1-stsp2@yandex.ru>
         <32451d4990cad450f6c8269dbd5fa6a59d126221.camel@redhat.com>
         <7969ff6b1406329a5a931c4ae39cb810db3eefcd.camel@redhat.com>
         <7f264d9f-cb59-0d10-d435-b846f9b61333@yandex.ru>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-07-06 at 15:06 +0300, stsp wrote:
> 06.07.2021 14:49, Maxim Levitsky пишет:
> > Now about the KVM's userspace API where this is exposed:
> >   
> > I see now too that KVM_SET_REGS clears the pending exception.
> > This is new to me and it is IMHO *wrong* thing to do.
> > However I bet that someone somewhere depends on this,
> > since this behavior is very old.
> 
> What alternative would you suggest?
> Check for ready_for_interrupt_injection
> and never call KVM_SET_REGS if it indicates
> "not ready"?
> But what if someone calls it nevertheless?
> Perhaps return an error from KVM_SET_REGS
> if exception is pending? Also KVM_SET_SREGS
> needs some treatment here too, as it can
> also be called when an exception is pending,
> leading to problems.

As I explained you can call KVM_GET_VCPU_EVENTS before calling
KVM_SET_REGS and then call KVM_SET_VCPU_EVENTS with the struct
that was filled by KVM_GET_VCPU_EVENTS.
That will preserve all the cpu events.

> 
> 
> > This doesn't affect qemu since when it does KVM_SET_REGS,
> > it also does KVM_SET_VCPU_EVENTS afterward, and that
> > restores either pending or injected exception state.
> > (that state is first read with KVM_GET_VCPU_EVENTS ioctl).
> >   
> > Also note just for reference that KVM_SET_SREGS has ability
> > to set a pending interrupt, something that is also redundant
> > since KVM_SET_VCPU_EVENTS does this.
> > I recently added KVM_SET_SREGS2 ioctl which now lacks this
> > ability.
> > 
> > KVM_SET_VCPU_EVENTS/KVM_GET_VCPU_EVENTS allows to read/write
> > state of both pending and injected exception and on top of that
> > allows to read/write the exception payload of a pending exception.
> > 
> > You should consider using it to preserve/modify the exception state,
> > although the later isn't recommended (qemu does this in few places,
> > but it is a bit buggy, especially in regard to nested guests).
> I need neither to preserve nor modify
> the exception state. All I need is to safely
> call KVM_SET_REGS/KVM_SET_SREGS, but
> that appears unsafe when exception is
> pending.
> 
> Please take a look into this commit:
> https://www.lkml.org/lkml/2020/12/1/324
> 
> It was suggested that the removal
> of "!kvm_event_needs_reinjection(vcpu)"
> condition from kvm_vcpu_ready_for_interrupt_injection()
> is what introduced the problem, as
> right now ready_for_interrupt_injection
> doesn't account for pending exception.
> I already added the check to my
> user-space code, and now it works
> reliably on some very old kernels
> prior to the aforementioned patch.
> So should we treat that as a regressions,
> or any other proposal?

I haven't studied the userspace interrupt injection code much but
it does sound like if we signal to userspace that irq window is
open, that means that indeed there must be no injected interrupts/exceptions.

Now let me explain how nesting of events supposed to work on real hardware:

Event nesting happens when during delivery of an event (interrupt or exception)
we got another event (it has to be exception practically, and it happens
only when the delivery process (like switching stacks, reading IDT,
pushing stuff to the stack, etc causes an exception)

There are 4 combinations of an event, and event that happened  during delivery
of it.


1. Exception->Exception:
There is an  exception, and during delivery of it we got an exception
(like #PF on accessing GDT, or #NP, #SS, or something like that)
In this case exceptions are merged which means that they are either converted to 
#DF,  first exception is lost, or we get a triple fault (SDM has a table
for all cases).


2. Interrupt->Exception
If there is an injected interrupt and during delivery of it, we get an exception
this means that jump to the interrupt handler caused an exception,
in which case the interrupt is lost and we run the exception handler instead.


3. Interrupt->Interrupt
4. Exception->Interrupt.

Those two cases can't happen, as interrupts should not be processed while delivering
an exception/interrupt.

Therefore indeed if we signal the userspace that interrupt window is open,
that means that there must be no injected interrupt/exception.

If the userspace however wants to inject an exception, currently it
can only correctly do so if it uses KVM_GET_VCPU_EVENTS, to see if we
already have a injected exception there and then merge itself new
exception. And that still doesn't work correctly when nested guests
are involved. As I said the userspace exception injection via KVM_GET_VCPU_EVENTS
is kind of broken, and only works in qemu since it uses it very rarely.

Paolo, what do you think?


Best regards,
	Maxim Levitsky

