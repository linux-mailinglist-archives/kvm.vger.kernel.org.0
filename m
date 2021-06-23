Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BDEE3B1D85
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 17:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbhFWPV6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 11:21:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23915 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230061AbhFWPV5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 11:21:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624461579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vc3DMzOS67LQ+nfdmh+aylrce35bcu3u3LE8/fizjSQ=;
        b=fj7MvpP0APqQCRpYiZ8yona/HjtL4okIBdgl5i8253rqxcTLZ0h0ug1EB/x2Jpu9ZkjL1J
        9M9THIRk5dWdjr0dTG7OqaE2suBG4KpPmDVQACoi9cckg1bZb0jckhF6X3EYQxh949rIwp
        Lrah+K5DkEMUkON0g5vOmim/2AhBf5I=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-GyqZIOkZMm2-TVVmFoba7g-1; Wed, 23 Jun 2021 11:19:38 -0400
X-MC-Unique: GyqZIOkZMm2-TVVmFoba7g-1
Received: by mail-oi1-f197.google.com with SMTP id w12-20020aca490c0000b02901f1fdc1435aso1900055oia.14
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 08:19:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vc3DMzOS67LQ+nfdmh+aylrce35bcu3u3LE8/fizjSQ=;
        b=QN6/rz1l88g71J5aHUDXCGOft1lCjlmmCsy4QVSTzmSpbNcYxqZjeN3O0oPXVkw8lC
         cZE+4tdWsxxIo4YPIebHHwjUCXygIV7CAeDr/ePHZ6oiRgkNPDpznpKT4TPd4RjxqlTL
         YVM1ecouHb44jFDbYZM73Fd72Kg7uCOy8mZMY+Dcr4x6iIjhmyJGgjcK1hR1ZmUUFKJA
         wnvMENzdIfqO4fw3D7xAXpCbIa7Vh9nVwg8M9b6yej37+Nv+gAS0hRV6n0ZO68BgCQw1
         xcuhCGla7gWRbcCkJZmO3h6TQiSMs0iGtdG5BnKaWEr8bsdL/f34871/zfwHsFqUWC99
         mEVQ==
X-Gm-Message-State: AOAM532DNhD4giLNFAdM01XJB7YHgJGdTJaKPFfkMtKbbGnF0wjkda3k
        wwAQoZTN0gc9tKMADlnrRG4H328ZAnCMlN2To6a/acDHL/pJqxG6ENAss8MDz3eE0RO4dBxuuQg
        PlDTjsjHC35CS
X-Received: by 2002:a05:6830:2047:: with SMTP id f7mr385559otp.296.1624461577726;
        Wed, 23 Jun 2021 08:19:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxKR+MFoC2HJjbwooWLF5ETw3fFbkPApta/Qrwy7Jh/EZ0FVPEbduPhmE6q96BPw9p22UscQQ==
X-Received: by 2002:a05:6830:2047:: with SMTP id f7mr385518otp.296.1624461577364;
        Wed, 23 Jun 2021 08:19:37 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id 35sm36190oth.49.2021.06.23.08.19.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 08:19:37 -0700 (PDT)
Date:   Wed, 23 Jun 2021 09:19:35 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Thomas Gleixner <tglx@linutronix.de>
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
Message-ID: <20210623091935.3ab3e378.alex.williamson@redhat.com>
In-Reply-To: <87o8bxcuxv.ffs@nanos.tec.linutronix.de>
References: <20210622131217.76b28f6f.alex.williamson@redhat.com>
        <87o8bxcuxv.ffs@nanos.tec.linutronix.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 23 Jun 2021 01:59:24 +0200
Thomas Gleixner <tglx@linutronix.de> wrote:

> Alex,
> 
> [ Resend due to a delivery issue here. Sorry if you got this twice. ]
> 
> On Tue, Jun 22 2021 at 13:12, Alex Williamson wrote:
> > On Tue, 22 Jun 2021 10:16:15 +0000 "Tian, Kevin" <kevin.tian@intel.com> wrote:
> >
> > Now the 2nd open requires your help. Below is what I learned from   
> >> current vfio/qemu code (for vfio-pci device):
> >> 
> >>     0) Qemu doesn't attempt to allocate all irqs as reported by msix->
> >>         table_size. It is done in an dynamic and incremental way.  
> >
> > Not by table_size, our expectation is that the device interrupt
> > behavior can be implicitly affected by the enabled vectors and the
> > table size may support far more vectors than the driver might actually
> > use.  It's also easier if we never need to get into the scenario of
> > pci_alloc_irq_vectors() returning a smaller than requested number of
> > vectors and needing to fallback to a vector negotiation that doesn't
> > exist via MSI-X.
> >
> > FWIW, more recent QEMU will scan the vector table for the highest
> > non-masked vector to initially enable that number of vectors in the
> > host, both to improve restore behavior after migration and avoid
> > overhead for guests that write the vector table before setting the
> > MSI-X capability enable bit (Windows?).
> >  
> >>     1) VFIO provides just one command (VFIO_DEVICE_SET_IRQS) for 
> >>          allocating/enabling irqs given a set of vMSIX vectors [start, count]:
> >>         a) if irqs not allocated, allocate irqs [start+count]. Enable irqs for 
> >>             specified vectors [start, count] via request_irq();
> >>         b) if irqs already allocated, enable irqs for specified vectors;
> >>         c) if irq already enabled, disable and re-enable irqs for specified
> >>              vectors because user may specify a different eventfd;
> >> 
> >>     2) When guest enables virtual MSI-X capability, Qemu calls VFIO_
> >>         DEVICE_SET_IRQS to enable vector#0, even though it's currently 
> >>         masked by the guest. Interrupts are received by Qemu but blocked
> >>         from guest via mask/pending bit emulation. The main intention is 
> >>         to enable physical MSI-X;  
> >
> > Yes, this is a bit awkward since the interrupt API is via SET_IRQS and
> > we don't allow writes to the MSI-X enable bit via config space.
> >    
> >>     3) When guest unmasks vector#0 via request_irq(), Qemu calls VFIO_
> >>         DEVICE_SET_IRQS to enable vector#0 again, with a eventfd different
> >>         from the one provided in 2);
> >> 
> >>     4) When guest unmasks vector#1, Qemu finds it's outside of allocated
> >>         vectors (only vector#0 now):
> >> 
> >>         a) Qemu first calls VFIO_DEVICE_SET_IRQS to disable and free 
> >>             irq for vector#0;
> >> 
> >>         b) Qemu then calls VFIO_DEVICE_SET_IRQS to allocate and enable
> >>             irqs for both vector#0 and vector#1;
> >> 
> >>      5) When guest unmasks vector#2, same flow in 4) continues.  
> 
> That's dangerous and makes weird assumptions about interrupts being
> requested early in the driver init() function. But that's wishful
> thinking, really. There are enough drivers, especially networking which
> request interrupts on device open() and not on device init(). Some
> special functions only request the irq way later, i.e. only when someone
> uses that special function and at this point the other irqs of that very
> same device are already in use.

I'd consider allocating vectors on open() to be setup time, device
initialization.  Chances of inflight interrupts is low.  If you have
examples of drivers where the irq request comes way later please let
me know, maybe there's some way we can identify that use case.

> >> If above understanding is correct, how is lost interrupt avoided between 
> >> 4.a) and 4.b) given that irq has been torn down for vector#0 in the middle
> >> while from guest p.o.v this vector is actually unmasked? There must be
> >> a mechanism in place, but I just didn't figure it out...  
> >
> > In practice unmasking new vectors is rare and done only at
> > initialization.  Risk from lost interrupts at this time is low.  
> 
> See above. Wishful thinking.
> 
> OMG, I really don't want to be the one to debug _WHY_ a device lost
> interrupts just because it did a late request_irq() when the device is
> operational already and has other interrupts active.
> 
> > When masking and unmasking vectors that are already in use, we're only
> > changing the signaling eventfd between KVM and QEMU such that QEMU can
> > set emulated pending bits in response to interrupts (and our lack of
> > interfaces to handle the mask/unmask at the host).  I believe that
> > locking in the vfio-pci driver prevents an interrupt from being lost
> > during the eventfd switch.  
> 
> Let's look at this from a driver perspective:
> 
>   1) Driver checks how many entries are possible in the MSI-X table
> 
>   2) Driver invokes pci_msix_enable[_range]() which returns the number
>      of vectors the system is willing to hand out to the driver.
> 
>   3) Driver assigns the vectors to the different resources in the
>      hardware
> 
>   4) Later on these interrupts are requested, but not necessarily during
>      device init.
> 
>      Yes, request_irq() can fail and today it can fail also due to CPU
>      vector exhaustion. That's perfectly fine as the driver can handle
>      the fail and act accordingly.
> 
> All of this is consistent and well defined.

We can't know in the hypervisor how many vectors the guest driver asked
for, we only know that it's somewhere between one and the number
supported by the vector table.  We'd contribute to vector exhaustion if
we always assume the max.
 
> Now lets look at the guest. This VFIO mechanism introduces two brand new
> failure modes because of this:
> 
>     guest::unmask()
>       trapped_by_host()
>         free_irqs();
>         pci_free_irq_vectors();
>           pci_disable_msix();
>         pci_alloc_irq_vectors();
>           pci_enable_msix();
>         request_irqs();
>         
>    #1 What happens if the host side allocation or the host side request_irq()
>       fails?
> 
>         a) Guest is killed?
>         b) Failure is silently ignored and guest just does not receive
>            interrupts?
>         c) Any other mechanism?

QEMU generates a log on failure.  At vfio-pci we're emulating the MSI-X
capability and vector table, there is no mechanism in the PCI spec
defined protocol that manipulating a vector table entry can fail, but
clearly it can fail on the host.  That's just the world we live in,
either we overestimate vector usage on the host or we do the best we
can to infer how the device is actually being used.

Within the vfio API we have a mechanism to describe that the above
behavior is required, ie. that we can't dynamically resize the number
of MSI-X vectors.  If we had kernel interfaces to dynamically change
our vector allocation after pci_alloc_irq_vectors() we could remove
that flag and QEMU could wouldn't need to go through this process.

> 
>        Whatever it is, it simply _cannot_ make request_irq() in the
>        guest fail because the guest has already passed all failure
>        points and is in the low level function of unmasking the
>        interrupt for the first time after which is will return 0, aka
>        success.
> 
>        So if you answer #a, fine with me. It's well defined.

As far as the guest is concerned, #b.  As you say, we're at the point
in the guest where the guest interrupt code is interacting with MSI-X
directly and there is no way it can fail on hardware.  It's not
entirely silent though, the hypervisor logs an error.  Whether you
think "the device I hot-added to my VM doesn't work" is worse than "I
hot-added a device to my VM and it crashed" is a better failure mode is
a matter of perspective.

>    #2 What happens to already active interrupts on that device which might
>       fire during that time?
> 
>        They get lost or are redirected to the legacy PCI interrupt and
>        there is absolutely nothing you can do about that.
> 
>        Simply because to prevent that the host side would have to
>        disable the interrupt source at the device level, i.e. fiddle
>        with actual device registers to shut up interrupt delivery and
>        reenable it afterwards again and thereby racing against some
>        other VCPU of the same guest which fiddles with that very same
>        registers.
> 
>        IOW, undefined behaviour, which the "VFIO design" shrugged off on
>        completely unjustified assumptions.

The vfio design signals to userspace that this behavior is required via
a flag on the IRQ info structure.  Should host interfaces become
available that allow us to re-size the number of vectors for a device,
we can remove the flag and userspace would no longer need this
disable/re-enable process.
 
> No matter how much you argue about this being unlikely, this is just
> broken. Unlikely simply does not exist at cloud scale.
> 
> Aside of that. How did you come to the conclusion that #2 does not
> matter? By analyzing _every_ open and closed source driver for their
> usage patterns and documenting that all drivers which want to work in
> VFIO-PCI space have to follow specific rules vs. interrupt setup and
> usage? I'm pretty sure that you have a mechanism in place which
> monitors closely whether a driver violates those well documented rules.
> 
> Yes, I know that I'm dreaming and the reality is that this is based on
> interesting assumptions and just works by chance.
> 
> I have no idea _why_ this has been done that way. The changelogs of the
> relevant commits are void of useful content and lack links to the
> possibly existing discussions about this.
> 
> I only can assume that back then the main problem was vector exhaustion
> on the host and to avoid allocating memory for interrupt descriptors
> etc, right?

Essentially yes, and it's largely userspace policy, ie. QEMU.  QEMU
owns the device, it has a right to allocate an entire vector table
worth of interrupts if it wants.

> The host vector exhaustion problem was that each MSIX vector consumed a
> real CPU vector which is a limited resource on X86. This is not longer
> the case today:
> 
>     1) pci_msix_enable[range]() consumes exactly zero CPU vectors from
>        the allocatable range independent of the number of MSIX vectors
>        it allocates, unless it is in multi-queue managed mode where it
>        will actually reserve a vector (maybe two) per CPU.
> 
>        But for devices which are not using that mode, they just
>        opportunistically "reserve" vectors.
> 
>        All entries are initialized with a special system vector which
>        when raised will emit a nastigram in dmesg.
> 
>     2) request_irq() actually allocates a CPU vector from the
>        allocatable vector space which can obviously still fail, which is
>        perfectly fine.

request_irq() is where the vector table entry actually gets unmasked
though, that act of unmasking the vector table entry in hardware cannot
fail, but virtualization of that act is backed by a request_irq() in
the host, which can fail.
 
> So the only downside today of allocating more MSI-X vectors than
> necessary is memory consumption for the irq descriptors.

As above, this is a QEMU policy of essentially trying to be a good
citizen and allocate only what we can infer the guest is using.  What's
a good way for QEMU, or any userspace, to know it's running on a host
where vector exhaustion is not an issue?

> Though for virtualization there is still another problem:
> 
>   Even if all possible MSI-X vectors for a passthrough PCI device would
>   be allocated upfront independent of the actual usage in the guest,
>   then there is still the issue of request_irq() failing on the host
>   once the guest decides to use any of those interrupts.

Yup.

> It's a halfways reasonable argumentation by some definition of
> reasonable, that this case would be a host system configuration problem
> and the admin who overcommitted is responsible for the consequence.
> 
> Where the only reasonable consequence is to kill the guest right there
> because there is no mechanism to actually tell it that the host ran out
> of resources.

People tend not to like their VM getting killed and potentially losing
data, so kill-the-guest vs device-doesn't-work is still debatable imo.

> Not at all a pretty solution, but it is contrary to the status quo well
> defined. The most important aspect is that it is well defined for the
> case of success:
> 
>   If it succeeds then there is no way that already requested interrupts
>   can be lost or end up being redirected to the legacy PCI irq due to
>   clearing the MSIX enable bit, which is a gazillion times better than
>   the "let's hope it works" based tinkerware we have now.
> 
> So, aside of the existing VFIO/PCI/MSIX thing being just half thought
> out, even thinking about proliferating this with IMS is bonkers.
> 
> IMS is meant to avoid the problem of MSI-X which needs to disable MSI-X
> in order to expand the number of vectors. The use cases are going to be
> even more dynamic than the usual device drivers, so the lost interrupt
> issue will be much more likely to trigger.
> 
> So no, we are not going to proliferate this complete ignorance of how
> MSI-X actually works and just cram another "feature" into code which is
> known to be incorrect.

Some of the issues of virtualizing MSI-X are unsolvable without
creating a new paravirtual interface, but obviously we want to work
with existing drivers and unmodified guests, so that's not an option.

To work with what we've got, the vfio API describes the limitation of
the host interfaces via the VFIO_IRQ_INFO_NORESIZE flag.  QEMU then
makes a choice in an attempt to better reflect what we can infer of the
guest programming of the device to incrementally enable vectors.  We
could a) work to provide host kernel interfaces that allow us to remove
that noresize flag and b) decide whether QEMU's usage policy can be
improved on kernels where vector exhaustion is no longer an issue.
Thanks,

Alex

