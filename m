Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07E83B10E0
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 01:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbhFWABm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 20:01:42 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:32958 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbhFWABm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 20:01:42 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1624406365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=RzYa72mioInPwQvI3NEpRj5PoaDVGEY7YubgtuSnqRw=;
        b=S/e/szlvUv0xGBmwhxTzk8Notvpd5128Z2lJK76DZiGW3UVNLX6hWh/8aPQ3tdEGOKB6uj
        Fb9zYvwQSerZuL140DAHp5D58CWOj6jm/P7K8RPraBUyTHGQ6nOpeixr7drLcFFNR8fvyP
        pxhg3gbvyJJVXrLRYJZZ5R+9W/jrdTCF7cZ0PQuT2FS4nb7Oh7+yqOSjUv3Ufh7auO0A4r
        sndd1Vd9t7VpYqIlKAIR5scmD89+ngBvrCmWfaIgrNea9AgJfI0HhYoLc/EOUnOskLYc6+
        OkjtfOR5dzxVx1GoLPzhi1O5Jx1BidRU0hvkq+HbjBvEPxSqTQrljnh+DFCGcg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1624406365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=RzYa72mioInPwQvI3NEpRj5PoaDVGEY7YubgtuSnqRw=;
        b=XqfxyzhPwSRUbUgsSq+pfRJ2e6N4Bi5Qnd8OxT5OeiqHiYA1N5B/QCvnby4RVWidFZVnGJ
        /rvtiiltecdX1oBw==
To:     Alex Williamson <alex.williamson@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Megha Dey <megha.dey@intel.com>,
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
In-Reply-To: <20210622131217.76b28f6f.alex.williamson@redhat.com>
Date:   Wed, 23 Jun 2021 01:59:24 +0200
Message-ID: <87o8bxcuxv.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Alex,

[ Resend due to a delivery issue here. Sorry if you got this twice. ]

On Tue, Jun 22 2021 at 13:12, Alex Williamson wrote:
> On Tue, 22 Jun 2021 10:16:15 +0000 "Tian, Kevin" <kevin.tian@intel.com> wrote:
>
> Now the 2nd open requires your help. Below is what I learned from 
>> current vfio/qemu code (for vfio-pci device):
>> 
>>     0) Qemu doesn't attempt to allocate all irqs as reported by msix->
>>         table_size. It is done in an dynamic and incremental way.
>
> Not by table_size, our expectation is that the device interrupt
> behavior can be implicitly affected by the enabled vectors and the
> table size may support far more vectors than the driver might actually
> use.  It's also easier if we never need to get into the scenario of
> pci_alloc_irq_vectors() returning a smaller than requested number of
> vectors and needing to fallback to a vector negotiation that doesn't
> exist via MSI-X.
>
> FWIW, more recent QEMU will scan the vector table for the highest
> non-masked vector to initially enable that number of vectors in the
> host, both to improve restore behavior after migration and avoid
> overhead for guests that write the vector table before setting the
> MSI-X capability enable bit (Windows?).
>
>>     1) VFIO provides just one command (VFIO_DEVICE_SET_IRQS) for 
>>          allocating/enabling irqs given a set of vMSIX vectors [start, count]:
>>         a) if irqs not allocated, allocate irqs [start+count]. Enable irqs for 
>>             specified vectors [start, count] via request_irq();
>>         b) if irqs already allocated, enable irqs for specified vectors;
>>         c) if irq already enabled, disable and re-enable irqs for specified
>>              vectors because user may specify a different eventfd;
>> 
>>     2) When guest enables virtual MSI-X capability, Qemu calls VFIO_
>>         DEVICE_SET_IRQS to enable vector#0, even though it's currently 
>>         masked by the guest. Interrupts are received by Qemu but blocked
>>         from guest via mask/pending bit emulation. The main intention is 
>>         to enable physical MSI-X;
>
> Yes, this is a bit awkward since the interrupt API is via SET_IRQS and
> we don't allow writes to the MSI-X enable bit via config space.
>  
>>     3) When guest unmasks vector#0 via request_irq(), Qemu calls VFIO_
>>         DEVICE_SET_IRQS to enable vector#0 again, with a eventfd different
>>         from the one provided in 2);
>> 
>>     4) When guest unmasks vector#1, Qemu finds it's outside of allocated
>>         vectors (only vector#0 now):
>> 
>>         a) Qemu first calls VFIO_DEVICE_SET_IRQS to disable and free 
>>             irq for vector#0;
>> 
>>         b) Qemu then calls VFIO_DEVICE_SET_IRQS to allocate and enable
>>             irqs for both vector#0 and vector#1;
>> 
>>      5) When guest unmasks vector#2, same flow in 4) continues.

That's dangerous and makes weird assumptions about interrupts being
requested early in the driver init() function. But that's wishful
thinking, really. There are enough drivers, especially networking which
request interrupts on device open() and not on device init(). Some
special functions only request the irq way later, i.e. only when someone
uses that special function and at this point the other irqs of that very
same device are already in use.

>> If above understanding is correct, how is lost interrupt avoided between 
>> 4.a) and 4.b) given that irq has been torn down for vector#0 in the middle
>> while from guest p.o.v this vector is actually unmasked? There must be
>> a mechanism in place, but I just didn't figure it out...
>
> In practice unmasking new vectors is rare and done only at
> initialization.  Risk from lost interrupts at this time is low.

See above. Wishful thinking.

OMG, I really don't want to be the one to debug _WHY_ a device lost
interrupts just because it did a late request_irq() when the device is
operational already and has other interrupts active.

> When masking and unmasking vectors that are already in use, we're only
> changing the signaling eventfd between KVM and QEMU such that QEMU can
> set emulated pending bits in response to interrupts (and our lack of
> interfaces to handle the mask/unmask at the host).  I believe that
> locking in the vfio-pci driver prevents an interrupt from being lost
> during the eventfd switch.

Let's look at this from a driver perspective:

  1) Driver checks how many entries are possible in the MSI-X table

  2) Driver invokes pci_msix_enable[_range]() which returns the number
     of vectors the system is willing to hand out to the driver.

  3) Driver assigns the vectors to the different resources in the
     hardware

  4) Later on these interrupts are requested, but not necessarily during
     device init.

     Yes, request_irq() can fail and today it can fail also due to CPU
     vector exhaustion. That's perfectly fine as the driver can handle
     the fail and act accordingly.

All of this is consistent and well defined.

Now lets look at the guest. This VFIO mechanism introduces two brand new
failure modes because of this:

    guest::unmask()
      trapped_by_host()
        free_irqs();
        pci_free_irq_vectors();
          pci_disable_msix();
        pci_alloc_irq_vectors();
          pci_enable_msix();
        request_irqs();
        
   #1 What happens if the host side allocation or the host side request_irq()
      fails?

        a) Guest is killed?
        b) Failure is silently ignored and guest just does not receive
           interrupts?
        c) Any other mechanism?

       Whatever it is, it simply _cannot_ make request_irq() in the
       guest fail because the guest has already passed all failure
       points and is in the low level function of unmasking the
       interrupt for the first time after which is will return 0, aka
       success.

       So if you answer #a, fine with me. It's well defined.

   #2 What happens to already active interrupts on that device which might
      fire during that time?

       They get lost or are redirected to the legacy PCI interrupt and
       there is absolutely nothing you can do about that.

       Simply because to prevent that the host side would have to
       disable the interrupt source at the device level, i.e. fiddle
       with actual device registers to shut up interrupt delivery and
       reenable it afterwards again and thereby racing against some
       other VCPU of the same guest which fiddles with that very same
       registers.

       IOW, undefined behaviour, which the "VFIO design" shrugged off on
       completely unjustified assumptions.

No matter how much you argue about this being unlikely, this is just
broken. Unlikely simply does not exist at cloud scale.

Aside of that. How did you come to the conclusion that #2 does not
matter? By analyzing _every_ open and closed source driver for their
usage patterns and documenting that all drivers which want to work in
VFIO-PCI space have to follow specific rules vs. interrupt setup and
usage? I'm pretty sure that you have a mechanism in place which
monitors closely whether a driver violates those well documented rules.

Yes, I know that I'm dreaming and the reality is that this is based on
interesting assumptions and just works by chance.

I have no idea _why_ this has been done that way. The changelogs of the
relevant commits are void of useful content and lack links to the
possibly existing discussions about this.

I only can assume that back then the main problem was vector exhaustion
on the host and to avoid allocating memory for interrupt descriptors
etc, right?

The host vector exhaustion problem was that each MSIX vector consumed a
real CPU vector which is a limited resource on X86. This is not longer
the case today:

    1) pci_msix_enable[range]() consumes exactly zero CPU vectors from
       the allocatable range independent of the number of MSIX vectors
       it allocates, unless it is in multi-queue managed mode where it
       will actually reserve a vector (maybe two) per CPU.

       But for devices which are not using that mode, they just
       opportunistically "reserve" vectors.

       All entries are initialized with a special system vector which
       when raised will emit a nastigram in dmesg.

    2) request_irq() actually allocates a CPU vector from the
       allocatable vector space which can obviously still fail, which is
       perfectly fine.

So the only downside today of allocating more MSI-X vectors than
necessary is memory consumption for the irq descriptors.

Though for virtualization there is still another problem:

  Even if all possible MSI-X vectors for a passthrough PCI device would
  be allocated upfront independent of the actual usage in the guest,
  then there is still the issue of request_irq() failing on the host
  once the guest decides to use any of those interrupts.

It's a halfways reasonable argumentation by some definition of
reasonable, that this case would be a host system configuration problem
and the admin who overcommitted is responsible for the consequence.

Where the only reasonable consequence is to kill the guest right there
because there is no mechanism to actually tell it that the host ran out
of resources.

Not at all a pretty solution, but it is contrary to the status quo well
defined. The most important aspect is that it is well defined for the
case of success:

  If it succeeds then there is no way that already requested interrupts
  can be lost or end up being redirected to the legacy PCI irq due to
  clearing the MSIX enable bit, which is a gazillion times better than
  the "let's hope it works" based tinkerware we have now.

So, aside of the existing VFIO/PCI/MSIX thing being just half thought
out, even thinking about proliferating this with IMS is bonkers.

IMS is meant to avoid the problem of MSI-X which needs to disable MSI-X
in order to expand the number of vectors. The use cases are going to be
even more dynamic than the usual device drivers, so the lost interrupt
issue will be much more likely to trigger.

So no, we are not going to proliferate this complete ignorance of how
MSI-X actually works and just cram another "feature" into code which is
known to be incorrect.

Thanks,

        tglx
