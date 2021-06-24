Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 158653B325A
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 17:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbhFXPRB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 11:17:01 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:45510 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbhFXPRB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 11:17:01 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1624547680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=NIkP5GnQOhkJ5OQDu9J0jh1rUD1xYTF9U9nmzJJ+nx4=;
        b=Oazwc6H+zXQ2ppEwCdrAAwnE6rYdGnY5Zayhq+2pEX3pC+rlLRFLtauBi8fShZZVMIKe08
        fZYyS1L53e7yZgvwNEROmDvl5kJwV5y+hNHax/kVdYz+i1dfFVyPJ9qu8T+IYblGkLjROR
        c1eU1uWYmEDlQNNuPXIDkipjxel/Ax5rLU2im+SHBHLPJp30DZX288hfHYK6cRZNYZLAWP
        kJcux6AWtjH2XQKk+YtieliyOzD82w///k3ouJ+2NccJ8bfHmihPCUUHdlu7FRSycnyT6f
        lpZrmAV+1RbwKdNW/CRi1WSVc1Zer7DS8Cjs2uHlWxTS6fSQU49lYzJkP4+yTQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1624547680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=NIkP5GnQOhkJ5OQDu9J0jh1rUD1xYTF9U9nmzJJ+nx4=;
        b=MHJJTBAa+0xt/ewGZKyVuQN5JKA0SpAY6qwr/rHtBz3sXKN+xqWA1hSr9ZhvJ1l9qMXBQy
        82ABeChYHniy9nAw==
To:     "Tian\, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "Dey\, Megha" <megha.dey@intel.com>,
        "Raj\, Ashok" <ashok.raj@intel.com>,
        "Pan\, Jacob jun" <jacob.jun.pan@intel.com>,
        "Jiang\, Dave" <dave.jiang@intel.com>,
        "Liu\, Yi L" <yi.l.liu@intel.com>,
        "Lu\, Baolu" <baolu.lu@intel.com>,
        "Williams\, Dan J" <dan.j.williams@intel.com>,
        "Luck\, Tony" <tony.luck@intel.com>,
        "Kumar\, Sanjay K" <sanjay.k.kumar@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Bjorn Helgaas <helgaas@kernel.org>
Subject: RE: Virtualizing MSI-X on IMS via VFIO
In-Reply-To: <MWHPR11MB1886E14C57689A253D9B40C08C079@MWHPR11MB1886.namprd11.prod.outlook.com>
Date:   Thu, 24 Jun 2021 17:14:39 +0200
Message-ID: <8735t7wazk.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Kevin!

On Thu, Jun 24 2021 at 02:41, Kevin Tian wrote:
>> From: Thomas Gleixner <tglx@linutronix.de>
>> On Wed, Jun 23 2021 at 23:37, Kevin Tian wrote:

>> > 1)  Fix the lost interrupt issue in existing MSI virtualization flow;
>> 
>> That _cannot_ be fixed without a hypercall. See my reply to Alex.
>
> The lost interrupt issue was caused due to resizing based on stale 
> impression of vector exhaustion.
>
> With your explanation this issue can be partially fixed by having Qemu 
> allocate all possible irqs when guest enables msi-x and never resizes 
> it before guest disables msi-x.

Yes, that works with all the downsides attached to it.

> The remaining problem is no feedback to block guest request_irq()
> in case of vector shortage. This has to be solved via paravirt interface
> but fixing lost interrupt alone is still a step forward for guest which
> doesn't implement the paravirt interface.

Fair enough.

> At any time guest OSes can be categorized into three classes:
>
> a)   doesn't implement any paravirt interface for vector allocation;
>
> b)   implement one paravirt interface that has been supported by KVM;
>
> c)   implement one paravirt interface which has not been supported by KVM;
>
> The transition phase from c) to b) is undefined, but it does exist more
> or less. For example a windows guest will never implement the interface
> defined between Linux guest and Linux host. It will have its own hyperv
> variation which likely takes time for KVM to emulate and claim support.
>
> Transition from a) to b) or a) to c) is a guest-side choice. It's not
> controlled by the host world.

That's correct.

> Here I didn't further differentiate whether a guest OS support ims, since
> once a supported paravirt interface is in place both msi and ims can get
> necessary feedback info from the host side. 
>
> Then let's look at the host side:
>
> 1) kernel versions before we conduct any discussed change:
>
>          This is a known broken world as you explained. irq resizing could
>          lead to lost interrupts in all three guest classes. The only mitigation 
>          is to document this limitation somewhere.
>
>          We'll not enable ims based on this broken framework.
>
> 2) kernel versions after we make a clean refactoring:
>
>          a) For guest OS which doesn't implement paravirt interface:
>          c) For guest OS which implement a paravirt interface not 
>              supported by KVM:
>
>              You confirmed that recent kernels (since 4.15+) all uses
>              reservation mode to avoid vector exhaustion. So VFIO can
>              define a new protocol asking its userspace to disable resizing
>              by allocating all possible irqs when guest msix is enabled. This
>              is one step forward by fixing the lost interrupt issue and is what
>              the step-1) in my proposal tries to achieve.

After studying the MSI-X specification again, I think there is another
option to solve this for MSI-X, i.e. the dynamic sizing part:

MSI requires to disable MSI in order to update the number of enabled
vectors in the control word.

MSI-X does not have that requirement as there is no 'number of used
vectors' control field. MSI-X provides a fixed sized vector table and
enabling MSI-X "activates" the full table.

System software has to set proper messages in the table and eventually
associate the table entries to device (sub)functions if that's not
hardwired in the device and controlled by queue enablement etc.

According to the specification there is no requirement for masked table
entries to contain a valid message:

 "Mask Bit: ... When this bit is set, the function is prohibited from
                sending a message using this MSI-X Table entry."

which means that the function must reread the table entry when the mask
bit in the vector control word is cleared.

So instead of tearing down the whole set and then bringing it up again,
which is wrong, the kernel could allocate an interrupt descriptor and
append an MSI entry, write the table entry and unmask it afterwards.

There are a couple of things to get there:

 1) MSI descriptor list handling.

    The msi descriptor list of a device is assumed to be unmutable after
    pci_enable_msix() has successfully enabled all of it, which means
    that there is no serialization in place.

    IIRC, the original attempt to glue IMS into the existing MSI
    management had a patch to add the required protections. That part
    could be dusted off.

 2) Provide the required functionality in the MSI irq domain
    infrastructure

 3) Expose this functionality through a proper interface.

That's append only of course.

It's not clear to me whether this is worth the effort, but at least it
is a viable solution if memory consumption, IRTE consumption is an
actual concern.

Thanks,

        tglx
