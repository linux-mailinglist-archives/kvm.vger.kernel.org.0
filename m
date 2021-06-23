Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24F3C3B1EB7
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 18:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbhFWQdy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 12:33:54 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:38514 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhFWQdx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 12:33:53 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1624465895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vum7XhG4Y/D6N0CnClS6m9YiPMuQUmjUuLSjPUe4UiU=;
        b=18q/s0XeWySvRpSD4BYDKY2u8rjH27TrHKNHyCwaERbA2eDl9yPULzJTIeXzLbaQmRLGZk
        A1UqKD9EFVmq/Rx4yrsFNWA9lQRff0+LFrI4+CckZPhxIhXM+Wb2Nd2qunWK85gdr2Y3Gm
        Ri8qKu2H2ghtfoKx2sNlarTy8J1QWVJZfOmEK2u36npqCbC+7UWmWPzqW3rPE8gtW3Tx9x
        WbBmLcZsOR/onwmu77lsVzZgSueBq922cO3XZUJqPoEBvm/v8ZsUa5+QAL4e1R8IzZpkSG
        4EAprE5Fuj7Z/Z8D2qrnNrM3kWbsxQyhiKQlPVk6Y3RHF4LJnHS3K6CfR5d/Uw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1624465895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vum7XhG4Y/D6N0CnClS6m9YiPMuQUmjUuLSjPUe4UiU=;
        b=cCSiRfYI4Pn9pQ/AytopE5opHmoRRL5BB7oRhn6jszRJQsvy4Y1D155HtVPYk9E/leEBw4
        0p9D1eDFTEb0iRAw==
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
In-Reply-To: <MWHPR11MB1886811339F7873A8E34549A8C089@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210622131217.76b28f6f.alex.williamson@redhat.com> <87o8bxcuxv.ffs@nanos.tec.linutronix.de> <MWHPR11MB1886811339F7873A8E34549A8C089@MWHPR11MB1886.namprd11.prod.outlook.com>
Date:   Wed, 23 Jun 2021 18:31:34 +0200
Message-ID: <87bl7wczkp.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 23 2021 at 06:12, Kevin Tian wrote:
>> From: Thomas Gleixner <tglx@linutronix.de>
>> So the only downside today of allocating more MSI-X vectors than
>> necessary is memory consumption for the irq descriptors.
>
> Curious about irte entry when IRQ remapping is enabled. Is it also
> allocated at request_irq()?

Good question. No, it has to be allocated right away. We stick the
shutdown vector into the IRTE and then request_irq() will update it with
the real one.

> So the correct flow is like below:
>
>     guest::enable_msix()
>       trapped_by_host()
>         pci_alloc_irq_vectors(); // for all possible vMSI-X entries
>           pci_enable_msix();      
>
>     guest::unmask()
>       trapped_by_host()
>         request_irqs();
>
> the first trap calls a new VFIO ioctl e.g. VFIO_DEVICE_ALLOC_IRQS.
>
> the 2nd trap can reuse existing VFIO_DEVICE_SET_IRQS which just
> does request_irq() if specified irqs have been allocated.
>
> Then map ims to this flow:
>
>     guest::enable_msix()
>       trapped_by_host()
>         msi_domain_alloc_irqs(); // for all possible vMSI-X entries
>         for_all_allocated_irqs(i)
>           pci_update_msi_desc_id(i, default_pasid); // a new helper func
>
>     guest::unmask(entry#0) 
>       trapped_by_host()
>         request_irqs();
>           ims_array_irq_startup(); // write msi_desc.id (default_pasid) to ims entry
>
>     guest::set_msix_perm(entry#1, guest_sva_pasid)
>       trapped_by_host()
>         pci_update_msi_desc_id(1, host_sva_pasid);
>
>     guest::unmask(entry#1)
>       trapped_by_host()
>         request_irqs();
>           ims_array_irq_startup(); // write msi_desc.id (host_sva_pasid) to ims entry

That's one way to do that, but that still has the same problem that the
request_irq() in the guest succeeds even if the host side fails.

As this is really new stuff there is no real good reason to force that
into the existing VFIO/MSIX stuff with all it's known downsides and
limitations.

The point is, that IMS can just add another interrupt to a device on the
fly without doing any of the PCI/MSIX nasties. So why not take advantage
of that?

I can see the point of using PCI to expose the device to the guest
because it's trivial to enumerate, but contrary to VF devices there is
no legacy and the mechanism how to setup the device interrupts can be
completely different from PCI/MSIX.

Exposing some trappable "IMS" storage in a separate PCI bar won't cut it
because this still has the same problem that the allocation or
request_irq() on the host can fail w/o feedback.

So IMO creating a proper paravirt interface is the right approach.  It
avoids _all_ of the trouble and will be necessary anyway once you want
to support devices which store the message/pasid in system memory and
not in on-device memory.

Thanks,

        tglx




