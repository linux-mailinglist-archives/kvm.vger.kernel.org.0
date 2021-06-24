Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6D43B2450
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 02:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbhFXAqS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 20:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbhFXAqR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 20:46:17 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E9BC061574;
        Wed, 23 Jun 2021 17:43:59 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1624495436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OhcZBk377doSNrAPrVqup2bUfrH9nLPQMVIkGeS2uzw=;
        b=E1NFyhPTpD/eRa1Rs6Y60glyw1eAflp6eBJj9UE4wbw2O8Q/S5pD9/siXQtOpkfU9HV+V6
        bsfE1PPFZOTsvthbKoRKUFigvaQig3ejFLiPYrOYRTNWceThId2z5nduTTzaPStTdxdp6h
        Yr4cGAwPEB8G6RHr0nWquh8G2b6Buf676ECKiuS3JhNpoZ5TOQitNnaZVllOGg3HRoLzM3
        Y1FzR2vc7v7XUSwG2nsjQZi2HFTb6DmZ6BK8hEk8C8hhJBl085bP/bw381TZV0oOH7YURe
        w2PVqilyrF0c3i1yV4uSEL7p3EFLym4tQOKt2U6Jtl/PwxLRGCFuFW4rfHqmOg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1624495436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OhcZBk377doSNrAPrVqup2bUfrH9nLPQMVIkGeS2uzw=;
        b=Jb8snIzaZgPVlCM/It3dGUBmehflf9cJDDazru9iuZJLbwzfLRaxjMYvPiR0TZnemmhyor
        35YU4k0ZkcImAPAQ==
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Kevin Tian <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Megha Dey <megha.dey@intel.com>,
        Ashok Rai <ashok.raj@intel.com>,
        Jacob Pan <jacob.jun.pan@intel.com>,
        Dave Jiang <dave.jiang@intel.com>, Yi Liu <yi.l.liu@intel.com>,
        Baolu Lu <baolu.lu@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Sanjay Kumar <sanjay.k.kumar@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: Virtualizing MSI-X on IMS via VFIO
In-Reply-To: <20210623091935.3ab3e378.alex.williamson@redhat.com>
References: <20210622131217.76b28f6f.alex.williamson@redhat.com> <87o8bxcuxv.ffs@nanos.tec.linutronix.de> <20210623091935.3ab3e378.alex.williamson@redhat.com>
Date:   Thu, 24 Jun 2021 02:43:55 +0200
Message-ID: <87wnqkay7o.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Alex!

On Wed, Jun 23 2021 at 09:19, Alex Williamson wrote:
> On Wed, 23 Jun 2021 01:59:24 +0200
> Thomas Gleixner <tglx@linutronix.de> wrote:
>> That's dangerous and makes weird assumptions about interrupts being
>> requested early in the driver init() function. But that's wishful
>> thinking, really. There are enough drivers, especially networking which
>> request interrupts on device open() and not on device init(). Some
>> special functions only request the irq way later, i.e. only when someone
>> uses that special function and at this point the other irqs of that very
>> same device are already in use.
>
> I'd consider allocating vectors on open() to be setup time, device
> initialization.  Chances of inflight interrupts is low.  If you have

It does not matter whether chances are low or not. Again: At datacenter
scale 'unlikely' does not exist except in wishful thinking.

It does not matter whether it's unlikely or not. What matters is that
this problem exists.

If only one of one million resize operations results in a lost interrupt
and subsequently in a stale device then it is exactly _one_ fail too
much especially for cases where it could have been avoided.

If you would have argued, that you can't do anything about it for
unmodified, i.e. unaware guests, but otherwise acknowledged that this
_is_ a problem which could and should have been fixed long ago, then we
can just move on and have a conversation about technical ways to fix it,
but handwaving it away is definitely _not_ an option.

It's not even documented anywhere. It's just implemented that way to
prove the theorem that virtualization creates more problems than it
solves.

> examples of drivers where the irq request comes way later please let
> me know, maybe there's some way we can identify that use case.

IOW, please tell me where I need to add more heuristics in order to
"fix" the symptom instead of the root cause?

Here we go nevertheless:

1) Multi-queue devices with managed interrupts.

   A queue and it's interrupt(s) are not started up when the associated
   CPU(s) is/are not online or not present. But a later hotplug brings
   them up and that's the point where such interrupts are unmasked the
   first time.

   All the other queues are active already at that point. Now you just
   have to ensure that there is load on the already online queues and
   the chances of getting a stale queue or running into a hopefully
   recoverable timeout are not longer low. That fail is pretty much
   guaranteed. I'm sure Joe Admin will appreciate all the helpful tools
   to debug that and the extensive documentation about this kind of
   failure.

   Surely you will tell me that these kind of devices are already
   covered by weird heuristics in the hypervisor which allocate all
   vectors upfront based on PCI ID or whatever, but I still have to tell
   you that this is beyond wrong and could have been avoided long ago at
   least for the not so uncommon case of an up-to-date hypervisor and
   up-to-date host and guest kernels.

2) Some drivers request interrupts with IRQF_NO_AUTOEN (or the older
   mechanism of marking it as NOAUTOEN before request_irq() which does
   not start it up. It's fully initialized but it gets unmasked when
   later on the driver invokes enable_irq(). And for some drivers that
   can be very late.

3) Multi-function devices where a subfunction gets initialized only when
   needed.

4) We have at least one case here with a custom FPGA driver where a
   certain power hungry IP block is only initialized when the program
   loaded by the end-user uses a particular library which enables it.

   At that point the interrupt gets requested and unmasked but there is
   already other functionality enabled in the FPGA with heavy interrupt
   load, so ripping MSI-X temporarily off for resizing would be a
   guarantee for losing interrupts in hard to debug ways. That stuff
   runs today only on bare metal fortunately, but there are plans to
   have it exposed to guests...

   Good thing we talked about this well documented VFIO 'feature' now,
   so we can spare us the head scratching later.

There are certainly others, but that's from the top of my head.

>> Let's look at this from a driver perspective:
>> 
>>   1) Driver checks how many entries are possible in the MSI-X table
>> 
>>   2) Driver invokes pci_msix_enable[_range]() which returns the number
>>      of vectors the system is willing to hand out to the driver.
>> 
>>   3) Driver assigns the vectors to the different resources in the
>>      hardware
>> 
>>   4) Later on these interrupts are requested, but not necessarily during
>>      device init.
>> 
>>      Yes, request_irq() can fail and today it can fail also due to CPU
>>      vector exhaustion. That's perfectly fine as the driver can handle
>>      the fail and act accordingly.
>> 
>> All of this is consistent and well defined.
>
> We can't know in the hypervisor how many vectors the guest driver asked
> for, we only know that it's somewhere between one and the number
> supported by the vector table.  We'd contribute to vector exhaustion if
> we always assume the max.

I understand that, but that does not make it more consistent.

>> Now lets look at the guest. This VFIO mechanism introduces two brand new
>> failure modes because of this:
>> 
>>     guest::unmask()
>>       trapped_by_host()
>>         free_irqs();
>>         pci_free_irq_vectors();
>>           pci_disable_msix();
>>         pci_alloc_irq_vectors();
>>           pci_enable_msix();
>>         request_irqs();
>>         
>>    #1 What happens if the host side allocation or the host side request_irq()
>>       fails?
>> 
>>         a) Guest is killed?
>>         b) Failure is silently ignored and guest just does not receive
>>            interrupts?
>>         c) Any other mechanism?
>
> QEMU generates a log on failure.  At vfio-pci we're emulating the MSI-X
> capability and vector table, there is no mechanism in the PCI spec
> defined protocol that manipulating a vector table entry can fail, but
> clearly it can fail on the host.  That's just the world we live in,
> either we overestimate vector usage on the host or we do the best we
> can to infer how the device is actually being used.
>
> Within the vfio API we have a mechanism to describe that the above
> behavior is required, ie. that we can't dynamically resize the number
> of MSI-X vectors.  If we had kernel interfaces to dynamically change
> our vector allocation after pci_alloc_irq_vectors() we could remove
> that flag and QEMU could wouldn't need to go through this process.
>
>> 
>>        Whatever it is, it simply _cannot_ make request_irq() in the
>>        guest fail because the guest has already passed all failure
>>        points and is in the low level function of unmasking the
>>        interrupt for the first time after which is will return 0, aka
>>        success.
>> 
>>        So if you answer #a, fine with me. It's well defined.
>
> As far as the guest is concerned, #b.  As you say, we're at the point
> in the guest where the guest interrupt code is interacting with MSI-X
> directly and there is no way it can fail on hardware.  It's not
> entirely silent though, the hypervisor logs an error.  Whether you
> think "the device I hot-added to my VM doesn't work" is worse than "I
> hot-added a device to my VM and it crashed" is a better failure mode is
> a matter of perspective.

Yes, it's a matter of perspective, but crashing the thing is at least
well defined. Silently breaking the device is an interesting choice and
completely undefined whether you log it or not.

Even if it does not break because the host side request_irq() succeeds,
risking that it can lose interrupts is daft and if that happens then it
still malfunctions and this is _not_ going to be logged in any
hypervisor log. It's going to be a nightmare to debug.

>>    #2 What happens to already active interrupts on that device which might
>>       fire during that time?
>> 
>>        They get lost or are redirected to the legacy PCI interrupt and
>>        there is absolutely nothing you can do about that.
>> 
>>        Simply because to prevent that the host side would have to
>>        disable the interrupt source at the device level, i.e. fiddle
>>        with actual device registers to shut up interrupt delivery and
>>        reenable it afterwards again and thereby racing against some
>>        other VCPU of the same guest which fiddles with that very same
>>        registers.
>> 
>>        IOW, undefined behaviour, which the "VFIO design" shrugged off on
>>        completely unjustified assumptions.
>
> The vfio design signals to userspace that this behavior is required via
> a flag on the IRQ info structure.  Should host interfaces become
> available that allow us to re-size the number of vectors for a device,
> we can remove the flag and userspace would no longer need this
> disable/re-enable process.

You cannot resize MSI-X without clearing the MSI-X enable bit. And
that's not going to change anytime soon. It's how MSI-X is specified.

So what are you trying to tell me? That your design is great because it
allows to remove a flag which cannot be removed for the particular class
of devices utilizing true MSI-X which is affected by this problem? 

I'm amazed how you emphasize design all over the place. I'm truly
impressed that this very design does not even document that the
re-sizing business can cause losing interrupts on already active
interrupts on the same device.

>>     2) request_irq() actually allocates a CPU vector from the
>>        allocatable vector space which can obviously still fail, which is
>>        perfectly fine.
>
> request_irq() is where the vector table entry actually gets unmasked
> though, that act of unmasking the vector table entry in hardware cannot
> fail, but virtualization of that act is backed by a request_irq() in
> the host, which can fail.

Again: request_irq() does not necessarily unmask. Just because for a
large part of the drivers the first unmask happens from request_irq()
does not make it an universal law. The unmask can be completely detached
from request_irq().

What this mechanism observes is the first unmask() operation on a
particalar MSI-X vector, nothing else.

You _cannot_ make assumptions about when and where that unmask happens
especially not with closed source guests, but your assumptions do not
even hold with open source guests.

Can we pretty please use the proper and precise terminology and not some
blurb based on random assumptions about how things might work or might
have worked 20 years ago?

>> So the only downside today of allocating more MSI-X vectors than
>> necessary is memory consumption for the irq descriptors.
>
> As above, this is a QEMU policy of essentially trying to be a good
> citizen and allocate only what we can infer the guest is using.  What's
> a good way for QEMU, or any userspace, to know it's running on a host
> where vector exhaustion is not an issue?

If the kernel is halfways recent (4.15+) then it uses reservation mode
on x86:

  - It does not consume CPU vectors for not requested interrupts (except
    for multi-queue devices with managed interrupts).

  - It consumes an IRTE entry per vector, which might or might not be an
    issue. There are 64k entries per IOMMU on Intel and sizeable number
    of entries per PCI function on AMD.

  - It consumes host memory obviously

Of course this does still not solve the problem that the actual
request_irq() can fail due to vector exhaustion (or other reasons), but
it at least prevents losing interrupts for already activated vectors due
to resizing.

>> Not at all a pretty solution, but it is contrary to the status quo well
>> defined. The most important aspect is that it is well defined for the
>> case of success:
>> 
>>   If it succeeds then there is no way that already requested interrupts
>>   can be lost or end up being redirected to the legacy PCI irq due to
>>   clearing the MSIX enable bit, which is a gazillion times better than
>>   the "let's hope it works" based tinkerware we have now.
>> 
>> So, aside of the existing VFIO/PCI/MSIX thing being just half thought
>> out, even thinking about proliferating this with IMS is bonkers.
>> 
>> IMS is meant to avoid the problem of MSI-X which needs to disable MSI-X
>> in order to expand the number of vectors. The use cases are going to be
>> even more dynamic than the usual device drivers, so the lost interrupt
>> issue will be much more likely to trigger.
>> 
>> So no, we are not going to proliferate this complete ignorance of how
>> MSI-X actually works and just cram another "feature" into code which is
>> known to be incorrect.
>
> Some of the issues of virtualizing MSI-X are unsolvable without
> creating a new paravirtual interface, but obviously we want to work
> with existing drivers and unmodified guests, so that's not an option.

I grant you that unmodified, i.e. unaware guests are an issue which is
pretty much impossible to fix, but at least it could have been
documented.

So this has been known for almost _ten_ years now and the only answer
you have is 'not an option' for everything and not just for unaware
guests?

Sorry, but that's hillarious and it's absolutely not rocket science to
fix that.

You do not even have to modify _one_ single PCI device driver if you put
the hypercall into the obvious place, i.e. pci_enable_msix[_range](),
which is invoked when the driver initializes and sizes and negotiates
the resources.

Existing and completely unmodified drivers handle the situation
perfectly fine when this function tells them: No, you can't get 1000
vectors, I grant you only one.

Those which don't are broken even w/o virt.

So the only situation where you really can by some means justify the
'try and pray' approach is on guests which are unaware of that mechanism
for whatever reason. That's it. And that want's proper documentation of
the potential consequences.

> To work with what we've got, the vfio API describes the limitation of
> the host interfaces via the VFIO_IRQ_INFO_NORESIZE flag.  QEMU then
> makes a choice in an attempt to better reflect what we can infer of the
> guest programming of the device to incrementally enable vectors.  We
> could a) work to provide host kernel interfaces that allow us to remove
> that noresize flag and b) decide whether QEMU's usage policy can be
> improved on kernels where vector exhaustion is no longer an issue.

For IMS "work with what we've got" is just not a reasonable answer and
IMS needs hypercalls sooner than later anyway for:

   1) Message store in guest system RAM which obviously cannot be
      trapped.

      That's the case where a single subdevice (not VF) provided by the
      host driver managed PCI device is wrapped and exposed as "PCI"
      device to the guest because that makes it simple to enumerate and
      probe.

      Obviously this just covers the device-memory storage of IDXD as
      well because that's just a an implementation detail.

   2) Passthrough of a full IMS capable device into the guest which has
      different requirements.

What we are looking at right now is #1. #2 is a different story and
needs way more than #1.

So the question is where such a hypercall should be located.

   A) IMS device specific which is going to end up with code duplication
      and slightly different bugs all over the place. Not really
      desirable.

   B) Part of PCI/MSI[X] is the right thing as it can be used to address
      the existing issues as well in a sane way.

So #B would look like this:

    device_init(dev)
      pci_enable_msix_range(dev, msidescs, minvec, maxvec)
        ....
        ret = hypercall(MSIX_ENABLE, &alloc_info);

We need to find the right spot for that call and the alloc_info
structure needs some thought obviously, but none of this is rocket
science.

The hypervisor can then:

 1) Grant the request and do the required allocation/setup for
    the vectors which the guest device driver asked for

 2) Grant and setup only $N vectors

 3) Refuse the request and return a proper error code

and everything just falls in place including sane error handling on all
ends.

Now add the reverse operation for MSIX_DISABLE and suddenly all of this
becomes a design.

I'm really amazed that this does not exist today because it's so bloody
obvious.

Maybe it's just bloody obvious to me, but I very well remember that I
explained on several occasions in great length why resizing MSI-X with
already active interrupts is bloody wrong.

Both in email and face to face, the last face to face was at a table
during Plumbers 2019 in Lisbon where IMS was discussed for the first
time in public.

Thanks,

        tglx
