Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE0833D232
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 11:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbhCPKzb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 06:55:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36608 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229792AbhCPKz3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Mar 2021 06:55:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615892129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jRb4B0KcEhZ4s3dOTpeBpsNGyWunNOch3xmQG6Fbmpw=;
        b=JLu6M0hXiBZOAPaYDZ1zB460VgV3F/BeN4VKVAiVuxWJqz77w+GG88EUQxBbciPDvqBvzk
        l2rZOCr/wWI99vsgWyST5nUhpqOiNll6Nd+zhuvgOgv1C48Gc4c0z0ejPUOXGQkiaoBcQ0
        rJ8YqVOl8JPbsw2/W9/nWtS5iVF/6Jw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-337-I_-lJ1JOOpyBsehK4z4uTg-1; Tue, 16 Mar 2021 06:55:27 -0400
X-MC-Unique: I_-lJ1JOOpyBsehK4z4uTg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 351F2107ACCA;
        Tue, 16 Mar 2021 10:55:25 +0000 (UTC)
Received: from starship (unknown [10.35.207.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 90F5F63633;
        Tue, 16 Mar 2021 10:55:20 +0000 (UTC)
Message-ID: <4cc6b314049d040ef878ee270ec8fa924cf7c9ec.camel@redhat.com>
Subject: Re: [PATCH 2/3] KVM: x86: guest debug: don't inject interrupts
 while single stepping
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Kieran Bingham <kbingham@kernel.org>,
        Jessica Yu <jeyu@kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>
Date:   Tue, 16 Mar 2021 12:55:19 +0200
In-Reply-To: <YE/vtYYwMakERzTS@google.com>
References: <20210315221020.661693-1-mlevitsk@redhat.com>
         <20210315221020.661693-3-mlevitsk@redhat.com> <YE/vtYYwMakERzTS@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-03-15 at 16:37 -0700, Sean Christopherson wrote:
> On Tue, Mar 16, 2021, Maxim Levitsky wrote:
> > This change greatly helps with two issues:
> > 
> > * Resuming from a breakpoint is much more reliable.
> > 
> >   When resuming execution from a breakpoint, with interrupts enabled, more often
> >   than not, KVM would inject an interrupt and make the CPU jump immediately to
> >   the interrupt handler and eventually return to the breakpoint, to trigger it
> >   again.
> > 
> >   From the user point of view it looks like the CPU never executed a
> >   single instruction and in some cases that can even prevent forward progress,
> >   for example, when the breakpoint is placed by an automated script
> >   (e.g lx-symbols), which does something in response to the breakpoint and then
> >   continues the guest automatically.
> >   If the script execution takes enough time for another interrupt to arrive,
> >   the guest will be stuck on the same breakpoint RIP forever.
> > 
> > * Normal single stepping is much more predictable, since it won't land the
> >   debugger into an interrupt handler, so it is much more usable.
> > 
> >   (If entry to an interrupt handler is desired, the user can still place a
> >   breakpoint at it and resume the guest, which won't activate this workaround
> >   and let the gdb still stop at the interrupt handler)
> > 
> > Since this change is only active when guest is debugged, it won't affect
> > KVM running normal 'production' VMs.
> > 
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > Tested-by: Stefano Garzarella <sgarzare@redhat.com>
> > ---
> >  arch/x86/kvm/x86.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index a9d95f90a0487..b75d990fcf12b 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -8458,6 +8458,12 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
> >  		can_inject = false;
> >  	}
> >  
> > +	/*
> > +	 * Don't inject interrupts while single stepping to make guest debug easier
> > +	 */
> > +	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
> > +		return;
> 
> Is this something userspace can deal with?  E.g. disable IRQs and/or set NMI
> blocking at the start of single-stepping, unwind at the end?  Deviating this far
> from architectural behavior will end in tears at some point.

I don't worry about NMI, but for IRQs, userspace can clear EFLAGS.IF, but that
can be messy to unwind, if an instruction that clears the interrupt flag was
single stepped over.

There is also notion of interrupt shadow but it also is reserved for things
like delaying interrupts for one cycle after sti, and such.

IMHO KVM_GUESTDBG_SINGLESTEP is already non architectural feature (userspace
basically tell the KVM to single step the guest but it doesn't set TF flag
or something like that), so changing its definition shouldn't be a problem.

If you worry about some automated script breaking due to the change,
(I expect that KVM_GUESTDBG_SINGLESTEP is mostly used manually, especially
since single stepping is never 100% reliable due to various issues like that),
I can add another flag to it which will block all the interrupts.
(like say KVM_GUESTDBG_BLOCKEVENTS).

In fact qemu already has single step flags, enabled over special qemu gdb extension
'maintenance packet qqemu.sstepbits'

Those single step flags allow to disable interrupts and qemu timers during the single stepping,
(and both modes are enabled by default)
However kvm code in qemu ignores these bits.


What do you think? 

Best regards,
	Maxim Levitsky


> 
> > +
> >  	/*
> >  	 * Finally, inject interrupt events.  If an event cannot be injected
> >  	 * due to architectural conditions (e.g. IF=0) a window-open exit
> > -- 
> > 2.26.2
> > 


