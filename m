Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECD933E8480
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 22:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233317AbhHJUnA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 16:43:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42995 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232453AbhHJUm7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 16:42:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628628156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hHnrIWkzZ7LkFQAJEORQbPUdKrZ3WDQnEsS9T+9/pd4=;
        b=I7HLrjMs2JV8RGOGzMuymLZDnghxUE2/X+v0BomNuuzyqDqnRLzelH7XaBIdDtJHs/cu6c
        O0hYjaDzSEHPFyQH80bks+76v2YLQCaZKKyHoiS8bHVnXIB7EtWQN13SfJUiwOWzQkB+Zo
        4PSi+srEp/+76PrUcAeEbfZQ8TG6Lt0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-33-UQBarrSZPcm-SrZF67zyFw-1; Tue, 10 Aug 2021 16:42:35 -0400
X-MC-Unique: UQBarrSZPcm-SrZF67zyFw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8BC76801AE7;
        Tue, 10 Aug 2021 20:42:33 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C11773AFD;
        Tue, 10 Aug 2021 20:42:29 +0000 (UTC)
Message-ID: <bb889453a1082c132846296744706a4e1456f127.camel@redhat.com>
Subject: Re: KVM's support for non default APIC base
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Date:   Tue, 10 Aug 2021 23:42:28 +0300
In-Reply-To: <CALMp9eRxthu+5NMRTL4+NtcsAcMyYmLiQs4Get5=UAAH_yqH=w@mail.gmail.com>
References: <20210713142023.106183-1-mlevitsk@redhat.com>
         <20210713142023.106183-9-mlevitsk@redhat.com>
         <c51d3f0b46bb3f73d82d66fae92425be76b84a68.camel@redhat.com>
         <YPXJQxLaJuoF6aXl@google.com>
         <564fd4461c73a4ec08d68e2364401db981ecba3a.camel@redhat.com>
         <YQ2vv7EXGN2jgQBb@google.com>
         <5f991ac11006ae890961a76d35a63b7c9c56b47c.camel@redhat.com>
         <CALMp9eRxthu+5NMRTL4+NtcsAcMyYmLiQs4Get5=UAAH_yqH=w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-08-09 at 09:47 -0700, Jim Mattson wrote:
> On Mon, Aug 9, 2021 at 2:40 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
> > On Fri, 2021-08-06 at 21:55 +0000, Sean Christopherson wrote:
> > > On Thu, Jul 22, 2021, Maxim Levitsky wrote:
> > > > On Mon, 2021-07-19 at 18:49 +0000, Sean Christopherson wrote:
> > > > > On Sun, Jul 18, 2021, Maxim Levitsky wrote:
> > > > -> APIC MMIO area has to be MMIO for 'apic_mmio_write' to be called,
> > > >    thus must contain no guest memslots.
> > > >    If the guest relocates the APIC base somewhere where we have a memslot,
> > > >    memslot will take priority, while on real hardware, LAPIC is likely to
> > > >    take priority.
> > > 
> > > Yep.  The thing that really bites us is that other vCPUs should still be able to
> > > access the memory defined by the memslot, e.g. to make it work we'd have to run
> > > the vCPU with a completely different MMU root.
> > That is something I haven't took in the account.
> > Complexity of supporting this indeed isn't worth it.
> > 
> > > > As far as I know the only good reason to relocate APIC base is to access it
> > > > from the real mode which is not something that is done these days by modern
> > > > BIOSes.
> > > > 
> > > > I vote to make it read only (#GP on MSR_IA32_APICBASE write when non default
> > > > base is set and apic enabled) and remove all remains of the support for
> > > > variable APIC base.
> > > 
> > > Making up our own behavior is almost never the right approach.  E.g. _best_ case
> > > scenario for an unexpected #GP is the guest immediately terminates.  Worst case
> > > scenario is the guest eats the #GP and continues on, which is basically the status
> > > quo, except it's guaranteed to now work, whereas todays behavior can at least let
> > > the guest function, for some definitions of "function".
> > 
> > Well, at least the Intel's PRM does state that APIC base relocation is not guaranteed
> > to work on all CPUs, so giving the guest a #GP is like telling it that current CPU doesn't
> > support it. In theory, a very well behaving guest can catch the exception and
> > fail back to the default base.
> > 
> > I don't understand what do you mean by 'guaranteed to now work'. If the guest
> > ignores this #GP and still thinks that APIC base relocation worked, it is its fault.
> > A well behaving guest should never assume that a msr write that failed with #GP
> > worked.
> > 
> > 
> > > I think the only viable "solution" is to exit to userspace on the guilty WRMSR.
> > > Whether or not we can do that without breaking userspace is probably the big
> > > question.  Fully emulating APIC base relocation would be a tremendous amount of
> > > effort and complexity for practically zero benefit.
> > 
> > I have nothing against this as well although I kind of like the #GP approach a bit more,
> > and knowing that there are barely any reasons
> > to relocate the APIC base, and that it doesn't work well, there is a good chance
> > that no one does it anyway (except our kvm unit tests, but that isn't an issue).
> > 
> > > > (we already have a warning when APIC base is set to non default value)
> > > 
> > > FWIW, that warning is worthless because it's _once(), i.e. won't help detect a
> > > misbehaving guest unless it's the first guest to misbehave on a particular
> > > instantiation of KVM.   _ratelimited() would improve the situation, but not
> > > completely eliminate the possibility of a misbehaving guest going unnoticed.
> > > Anything else isn't an option becuase it's obviously guest triggerable.
> > 
> > 100% agree.
> > 
> > I'll say I would first make it _ratelimited() for few KVM versions, and then
> > if nobody complains, make it a KVM internal error / #GP, and remove all the leftovers
> > from the code that pretend that it can work.
> 
> Printing things to syslog is not very helpful. Any time that kvm
> violates the architectural specification, it should provide
> information about the emulation error to userspace.
> 
Paolo, what do you think?

My personal opinion is that we should indeed cause KVM internal error
on all attempts to change the APIC base.

If someone complains, then we can look at their use-case.

My view is that any half-working feature is bound to bitrot
and cause harm and confusion.

Best regards,
	Maxim Levitsky


