Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 835AA33DC09
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 19:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239544AbhCPSD2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 14:03:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30463 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239708AbhCPSCX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Mar 2021 14:02:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615917740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=afsQu3bkkEzFNASra05V5QqxmElNZlOjrd3Yv2bOpaA=;
        b=YjjcCj5qrfX5qOZ2Qxu6A0CEnyHEU9Tv/rDlkZxC4zSlgP7VaENigTFI/q1JTx917tRSY6
        tDWdW9DxMbiZVFnQp+4o5Ivp/KPlAZ/LvYA7RbYhYjg2F0cIhQ8Aeynx0IF4Esnb+2SOr4
        GUUaTmqTHacqqA7H9TRIFp3plIux01k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-503-ZkgpDO6cNIqS8wDM8lBh4w-1; Tue, 16 Mar 2021 14:02:17 -0400
X-MC-Unique: ZkgpDO6cNIqS8wDM8lBh4w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6435E107ACCA;
        Tue, 16 Mar 2021 18:02:14 +0000 (UTC)
Received: from starship (unknown [10.35.206.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4DF995D747;
        Tue, 16 Mar 2021 18:02:08 +0000 (UTC)
Message-ID: <f6c6eee97772264eff62a8c1dafa325c82173d64.camel@redhat.com>
Subject: Re: [PATCH 2/3] KVM: x86: guest debug: don't inject interrupts
 while single stepping
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Jan Kiszka <jan.kiszka@siemens.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Kieran Bingham <kbingham@kernel.org>,
        Jessica Yu <jeyu@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>
Date:   Tue, 16 Mar 2021 20:02:07 +0200
In-Reply-To: <31c0bba9-0399-1f15-a59b-a8f035e366e8@siemens.com>
References: <20210315221020.661693-3-mlevitsk@redhat.com>
         <YE/vtYYwMakERzTS@google.com>
         <1259724f-1bdb-6229-2772-3192f6d17a4a@siemens.com>
         <bede3450413a7c5e7e55b19a47c8f079edaa55a2.camel@redhat.com>
         <ca41fe98-0e5d-3b4c-8ed8-bdd7cd5bc60f@siemens.com>
         <71ae8b75c30fd0f87e760216ad310ddf72d31c7b.camel@redhat.com>
         <2a44c302-744e-2794-59f6-c921b895726d@siemens.com>
         <1d27b215a488f8b8fc175e97c5ab973cc811922d.camel@redhat.com>
         <727e5ef1-f771-1301-88d6-d76f05540b01@siemens.com>
         <e2cd978e357155dbab21a523bb8981973bd10da7.camel@redhat.com>
         <CAMS+r+XFLsFRFLGLaAH3_EnBcxOmyN-XiZqcmKEx2utjNErYsQ@mail.gmail.com>
         <31c0bba9-0399-1f15-a59b-a8f035e366e8@siemens.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-03-16 at 18:01 +0100, Jan Kiszka wrote:
> On 16.03.21 17:50, Sean Christopherson wrote:
> > On Tue, Mar 16, 2021, Maxim Levitsky wrote:
> > > On Tue, 2021-03-16 at 16:31 +0100, Jan Kiszka wrote:
> > > > Back then, when I was hacking on the gdb-stub and KVM support, the
> > > > monitor trap flag was not yet broadly available, but the idea to once
> > > > use it was already there. Now it can be considered broadly available,
> > > > but it would still require some changes to get it in.
> > > > 
> > > > Unfortunately, we don't have such thing with SVM, even recent versions,
> > > > right? So, a proper way of avoiding diverting event injections while we
> > > > are having the guest in an "incorrect" state should definitely be the goal.
> > > Yes, I am not aware of anything like monitor trap on SVM.
> > > 
> > > > Given that KVM knows whether TF originates solely from guest debugging
> > > > or was (also) injected by the guest, we should be able to identify the
> > > > cases where your approach is best to apply. And that without any extra
> > > > control knob that everyone will only forget to set.
> > > Well I think that the downside of this patch is that the user might actually
> > > want to single step into an interrupt handler, and this patch makes it a bit
> > > more complicated, and changes the default behavior.
> > 
> > Yes.  And, as is, this also blocks NMIs and SMIs.  I suspect it also doesn't
> > prevent weirdness if the guest is running in L2, since IRQs for L1 will cause
> > exits from L2 during nested_ops->check_events().
> > 
> > > I have no objections though to use this patch as is, or at least make this
> > > the new default with a new flag to override this.
> > 
> > That's less bad, but IMO still violates the principle of least surprise, e.g.
> > someone that is single-stepping a guest and is expecting an IRQ to fire will be
> > all kinds of confused if they see all the proper IRR, ISR, EFLAGS.IF, etc...
> > settings, but no interrupt.
> 
> From my practical experience with debugging guests via single step,
> seeing an interrupt in that case is everything but handy and generally
> also not expected (though logical, I agree). IOW: When there is a knob
> for it, it will remain off in 99% of the time.
> 
> But I see the point of having some control, in an ideal world also an
> indication that there are pending events, permitting the user to decide
> what to do. But I suspect the gdb frontend and protocol does not easily
> permit that.

Qemu gdbstub actually does have control over suppression of the interrupts
over a single step and it is even enabled by default:

https://qemu.readthedocs.io/en/latest/system/gdb.html
(advanced debug options)

However it is currently only implemented in TCG (software emulator) mode 
and not in KVM mode (I can argue that this is a qemu bug).

So my plan was to add a new kvm guest debug flag KVM_GUESTDBG_BLOCKEVENTS,
and let qemu enable it when its 'NOIRQ' mode is enabled (it is by default).

However due to the discussion in this thread about the leakage of the RFLAGS.TF,
I wonder if kvm should by default suppress events and have something like
KVM_GUESTDBG_SSTEP_ALLOW_EVENTS to override this and wire 
that to qemu's NOIRQ=false case.

This will allow older qemu to work correctly and new qemu will be able to choose
the old less ideal behavior.

> 
> > > Sean Christopherson, what do you think?
> > 
> > Rather than block all events in KVM, what about having QEMU "pause" the timer?
> > E.g. save MSR_TSC_DEADLINE and APIC_TMICT (or inspect the guest to find out
> > which flavor it's using), clear them to zero, then restore both when
> > single-stepping is disabled.  I think that will work?
> > 
> 
> No one can stop the clock, and timers are only one source of interrupts.
> Plus they do not all come from QEMU, some also from KVM or in-kernel
> sources directly. Would quickly become a mess.

This, plus as we see, even changing with RFLAGS.TF leaks it.
Changing things like MSR_TSC_DEADLINE will also make it visible to the guest,
sooner or later and is a mess that I rather not get into.

It is _possible_ to disable timer interrupts 'out of band', but that is messy too
if done from userspace. For example, what if the timer interrupt is already pending
in local apic, when qemu decides to single step?

Also with gdbstub the user doesn't have to stop all vcpus (there is a non-stop mode),
in which only some vcpus are stopped which is actually a very cool feature,
and of course running vcpus can raise events.

Also interrupts can indeed come from things like vhost.

Best regards,
	Maxim Levitsky


> Jan
> 


