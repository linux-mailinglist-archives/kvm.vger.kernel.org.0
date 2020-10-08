Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4222F28719C
	for <lists+kvm@lfdr.de>; Thu,  8 Oct 2020 11:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729078AbgJHJeo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Oct 2020 05:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgJHJeo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Oct 2020 05:34:44 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B06DAC061755;
        Thu,  8 Oct 2020 02:34:43 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602149682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9C7ddO1tNV07uZeIsPkqBSRRefFYTYdf/Bk9HtBWaAc=;
        b=2SneWtOR1bW8bJ5ysFYPc3ncNp8IS/WuUh1nRHvF0MwqeIXQN620hAfWoKQKxhSCHf07ug
        8ljcQgTDhou3MPkC2dRgAzU0ECJ6YzXegZGhwhaoaU0MSEru0IPxY19ByLZj9ejsgrrGOk
        uz0JdvUcj4NsSrXQkPmUCYnS+Myq+on7HaBKjTDK8XtEKM2AdqU6KXGwwU+3d4p+V4KBqD
        7IIMDd8ee0cYngiLAAQiva7QMU+bwTt9uaCSoIXgCPADFny+wBNvw9dQvDlD0gzAAqNQve
        WWKVRaDWUkVQHedA5mJq3hTLzwljke47y3mlzLUe8wQFj96SUSs4R9dWbEbviA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602149682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9C7ddO1tNV07uZeIsPkqBSRRefFYTYdf/Bk9HtBWaAc=;
        b=ZrTnF/5spy/B5ZqVsTLHTAERKFuiuTT39QCwKbwwvaDAZD4apgQ8RBWZuA45ujKTbk6ruw
        zzI8hyjxP5o81dCg==
To:     David Woodhouse <dwmw2@infradead.org>, x86@kernel.org
Cc:     iommu <iommu@lists.linux-foundation.org>,
        kvm <kvm@vger.kernel.org>, linux-hyperv@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 07/13] irqdomain: Add max_affinity argument to irq_domain_alloc_descs()
In-Reply-To: <119c2f993cac5d57c54d4720addc9f32bf1daadd.camel@infradead.org>
References: <77e64f977f559412f62b467fd062d051ea288f14.camel@infradead.org> <20201005152856.974112-1-dwmw2@infradead.org> <20201005152856.974112-7-dwmw2@infradead.org> <87lfgj59mp.fsf@nanos.tec.linutronix.de> <75d79c50d586c18f0b1509423ed673670fc76431.camel@infradead.org> <87tuv640nw.fsf@nanos.tec.linutronix.de> <336029ca32524147a61b6fa1eb734debc9d51a00.camel@infradead.org> <87a6wy3u6n.fsf@nanos.tec.linutronix.de> <119c2f993cac5d57c54d4720addc9f32bf1daadd.camel@infradead.org>
Date:   Thu, 08 Oct 2020 11:34:41 +0200
Message-ID: <87k0w12h8u.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 08 2020 at 08:21, David Woodhouse wrote:
> On Wed, 2020-10-07 at 17:57 +0200, Thomas Gleixner wrote:
>> Multiqueue devices want to have at max 1 queue per CPU or if the device
>> has less queues than CPUs they want the queues to have a fixed
>> association to a set of CPUs.
>> 
>> At setup time this is established considering possible CPUs to handle
>> 'physical' hotplug correctly.
>> 
>> If a queue has no online CPUs it cannot be started. If it's active and
>> the last CPU goes down then it's quiesced and stopped and the core code
>> shuts down the interrupt and does not move it to a still online CPU.
>> 
>> So with your hackery, we end up in a situation where we have a large
>> possible mask, but not all CPUs in that mask can be reached, which means
>> in a 1 queue per CPU scenario all unreachable CPUs would have
>> disfunctional queues.
>> 
>> So that spreading algorithm needs to know about this limitation.
>
> OK, thanks. So the queue exists, with an MSI assigned to point to an
> offline CPU(s), but it cannot actually be used until/unless at least
> one CPU in its mask comes online.

The MSI entry in that case is actually directed to an online CPU's
MANAGED_IRQ_SHUTDOWN_VECTOR to catch cases where an interrupt is raised
by the device after shutdown.

> So when I said I wanted to try treating "reachable" the same way as
> "online", that would mean the queue can't start until/unless at least
> one *reachable* CPU in its mask comes online.
>
> The underlying problem here is that until a CPU comes online, we don't
> actually *know* if it's reachable or not.

It's known before online, i.e. when the CPU is registered which is
either at boot time for present CPUs or at 'physical' hotplug.

> So if we want carefully create the affinity masks at setup time so that
> they don't include any unreachable CPUs... that basically means we
> don't include any non-present CPUs at all (unless they've been added
> once and then removed).

That breaks _all_ multi-queue assumptions in one go. :)

> But those really do seem like hacks which might only apply on x86,
> while the generic approach of treating "reachable" like "online" seems
> like it would work in other cases too.
>
> Fundamentally, there are three sets of CPUs. There are those known to
> be reachable, those known not to be, and those which are not yet
> known.

Unfortunately there are lots of assumptions all over the place that
possible CPUs are reachable. Multi-queue using managed interrupts is
just the tip of the iceberg.

> So another approach we could use is to work with a cpumask of those
> *known* not to be reachable, and to filter those *out* of the prebuilt
> affinities. That gives us basically the right behaviour without
> hotplug, but does include absent CPUs in a mask that *if* they are ever
> added, wouldn't be able to receive the IRQ. Which does mean we'd have
> to refrain from bringing up the corresponding queue. 

The multi-queue drivers rely on the interrupt setup to create their
queues and the fundamental assumption is that this setup works. The
managed interrupt mechanism guarantees that the queue has a vector
available on all CPUs which are in the queues assigned affinity mask. As
of today it also guarantees that these CPUs are reachable once they come
online.

So in order to make that work you'd need to teach the multi-queue stuff
about this new world order:

 1) On hotplug the queue needs to be able to figure out whether the
    interrupt is functional. If not it has to redirect any requests to
    some actually functional queue.

 2) On unplug it needs to be able to figure out whether the interrupt
    will shutdown because the outgoing CPU is the last reachable in the
    group and if there are still online but unreachable CPUs then use
    the redirect mechanism.

I'm sure that the multi-queue people will be enthusiastic to add all of
this and deal with all the nasty corner cases coming out of it.

The overall conclusion for this is:

 1) X2APIC support on bare metal w/o irq remapping is not going to
    happen unless you:

      - added support in multi-queue devices which utilize managed
        interrupts
        
      - audited the whole tree for other assumptions related to the
        reachability of possible CPUs.

    I'm not expecting you to be done with that before I retire so for
    me it's just not going to happen :)

 2) X2APIC support on VIRT is possible if the extended ID magic is
    supported by the hypervisor because that does not make any CPU
    unreachable for MSI and therefore the multi-queue muck and
    everything else just works.

    This requires to have either the domain affinity limitation for HPET
    in place or just to force disable HPET or at least HPET-MSI which is
    a reasonable tradeoff.

    HPET is not required for guests which have kvmclock and
    APIC/deadline timer and known (hypervisor provided) frequencies.

Anything else is just wishful thinking, really.

Thanks,

        tglx
