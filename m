Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E48A53B0D81
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 21:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232614AbhFVTOj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 15:14:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45810 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230146AbhFVTOi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 15:14:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624389141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w/kiGqfvKmHlvvODf12+NKLRbxkAQ5ugskJmY6siGHk=;
        b=hjNWB7h5kEhDK4bQok6Rdc1TJbL1Y1eyygoRbWy6m+oi7UoQ93SflaAtJkASh0LmNUFh58
        pM3wIWEsQTAZug7rkyqstxh1S/R8Rs5oJkqm0x+vPdR5Tv+9ECN+eOFwsxMM0QjHafZADb
        os45mbiPfBM/0dikyiW+zqcrWykshMY=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-QGb_j9CePIKGtZ7YZMA6Gg-1; Tue, 22 Jun 2021 15:12:20 -0400
X-MC-Unique: QGb_j9CePIKGtZ7YZMA6Gg-1
Received: by mail-ot1-f69.google.com with SMTP id z60-20020a9d24c20000b029045ef35e4636so595805ota.2
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 12:12:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=w/kiGqfvKmHlvvODf12+NKLRbxkAQ5ugskJmY6siGHk=;
        b=t2dcon4oagp5lrZrulxaasyE5C7H7vY+YSKESXUkE58jDAcnV1QbXXZy54n8CpRZV+
         Etv+zXVTUEwhol+T8ak5eJhPof3EffatLDKZ1pkgLcTp1RcAicCx6eTOJMJ2CyNo97VZ
         Hz6KLiVsxEVaDf5TiytYkg5Drvut/63KKv7W943/5oFXOO18EHZdcP7bYSSYIq6cmNIt
         TLUobpE5z5yCBVuxNLwy52WO8u0Fmn/N5lgCxE76QAOK8e1AgaXFkVb8B/iU9zNqUaAk
         OktpCKehkINZ6/aGpXBai5WFjVMvEWFD+480pPU8hPiLqUxr9t3eBDOCBCwTj4/VYear
         Rwrw==
X-Gm-Message-State: AOAM530YGf0Ir7lk09A/fRy8aR64u5PsDm8hv9uv2jfN+0FwpAfxFtAA
        0oMapp4PN7MOQsjLYsQyzR3OSwIy1v/QRGNXDWt69i+Ey1MRQoChLiupjKGI1alI+7xKeyK77Xi
        befhB7gXPJDMx
X-Received: by 2002:a05:6808:60e:: with SMTP id y14mr215422oih.105.1624389139941;
        Tue, 22 Jun 2021 12:12:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzTbIHJ0ujoAPprlki2Iz6RXGVi3W9WlzesdoICOvQDuvhj4xQg7LDpOgVZu3i41y2ImTenAA==
X-Received: by 2002:a05:6808:60e:: with SMTP id y14mr215402oih.105.1624389139699;
        Tue, 22 Jun 2021 12:12:19 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id y16sm50876oto.60.2021.06.22.12.12.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 12:12:19 -0700 (PDT)
Date:   Tue, 22 Jun 2021 13:12:17 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Dey, Megha" <megha.dey@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: Virtualizing MSI-X on IMS via VFIO
Message-ID: <20210622131217.76b28f6f.alex.williamson@redhat.com>
In-Reply-To: <MWHPR11MB188603D0D809C1079F5817DC8C099@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <MWHPR11MB188603D0D809C1079F5817DC8C099@MWHPR11MB1886.namprd11.prod.outlook.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 22 Jun 2021 10:16:15 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> Hi, Alex,
> 
> Need your help to understand the current MSI-X virtualization flow in 
> VFIO. Some background info first.
> 
> Recently we are discussing how to virtualize MSI-X with Interrupt 
> Message Storage (IMS) on mdev:
> 	https://lore.kernel.org/kvm/87im2lyiv6.ffs@nanos.tec.linutronix.de/ 
> 
> IMS is a device specific interrupt storage, allowing an optimized and 
> scalable manner for generating interrupts. idxd mdev exposes virtual 
> MSI-X capability to guest but uses IMS entries physically for generating 
> interrupts. 
> 
> Thomas has helped implement a generic ims irqchip driver:
> 	https://lore.kernel.org/linux-hyperv/20200826112335.202234502@linutronix.de/
> 
> idxd device allows software to specify an IMS entry (for triggering 
> completion interrupt) when submitting a descriptor. To prevent one 
> mdev triggering malicious interrupt into another mdev (by specifying 
> an arbitrary entry), idxd ims entry includes a PASID field for validation - 
> only a matching PASID in the executed descriptor can trigger interrupt 
> via this entry. idxd driver is expected to program ims entries with 
> PASIDs that are allocated to the mdev which owns those entries.
> 
> Other devices may have different ID and format to isolate ims entries. 
> But we need abstract a generic means for programming vendor-specific 
> ID into vendor-specific ims entry, without violating the layering model. 
> 
> Thomas suggested vendor driver to first register ID information (possibly 
> plus the location where to write ID to) in msi_desc when allocating irqs 
> (extend existing alloc function or via new helper function) and then have 
> the generic ims irqchip driver to update ID to the ims entry when it's 
> started up by request_irq().
> 
> Then there are two questions to be answered:
> 
>     1) How does vendor driver decide the ID to be registered to msi_desc?
>     2) How is Thomas's model mapped to the MSI-X virtualization flow in VFIO?
> 
> For the 1st open, there are two types of PASIDs on idxd mdev:
> 
>     1) default PASID: one per mdev and allocated when mdev is created;
>     2) sva PASIDs: multiple per mdev and allocated on-demand (via vIOMMU);
> 
> If vIOMMU is not exposed, all ims entries of this mdev should be 
> programmed with default PASID which is always available in mdev's 
> lifespan.
> 
> If vIOMMU is exposed and guest sva is enabled, entries used for sva 
> should be tagged with sva PASIDs, leaving others tagged with default 
> PASID. To help achieve intra-guest interrupt isolation, guest idxd driver 
> needs program guest sva PASIDs into virtual MSIX_PERM register (one 
> per MSI-X entry) for validation. Access to MSIX_PERM is trap-and-emulated 
> by host idxd driver which then figure out which PASID to register to 
> msi_desc (require PASID translation info via new /dev/iommu proposal).
> 
> The guest driver is expected to update MSIX_PERM before request_irq().
> 
> Now the 2nd open requires your help. Below is what I learned from 
> current vfio/qemu code (for vfio-pci device):
> 
>     0) Qemu doesn't attempt to allocate all irqs as reported by msix->
>         table_size. It is done in an dynamic and incremental way.

Not by table_size, our expectation is that the device interrupt
behavior can be implicitly affected by the enabled vectors and the
table size may support far more vectors than the driver might actually
use.  It's also easier if we never need to get into the scenario of
pci_alloc_irq_vectors() returning a smaller than requested number of
vectors and needing to fallback to a vector negotiation that doesn't
exist via MSI-X.

FWIW, more recent QEMU will scan the vector table for the highest
non-masked vector to initially enable that number of vectors in the
host, both to improve restore behavior after migration and avoid
overhead for guests that write the vector table before setting the
MSI-X capability enable bit (Windows?).

>     1) VFIO provides just one command (VFIO_DEVICE_SET_IRQS) for 
>          allocating/enabling irqs given a set of vMSIX vectors [start, count]:
> 
>         a) if irqs not allocated, allocate irqs [start+count]. Enable irqs for 
>             specified vectors [start, count] via request_irq();
>         b) if irqs already allocated, enable irqs for specified vectors;
>         c) if irq already enabled, disable and re-enable irqs for specified
>              vectors because user may specify a different eventfd;
> 
>     2) When guest enables virtual MSI-X capability, Qemu calls VFIO_
>         DEVICE_SET_IRQS to enable vector#0, even though it's currently 
>         masked by the guest. Interrupts are received by Qemu but blocked
>         from guest via mask/pending bit emulation. The main intention is 
>         to enable physical MSI-X;

Yes, this is a bit awkward since the interrupt API is via SET_IRQS and
we don't allow writes to the MSI-X enable bit via config space.
 
>     3) When guest unmasks vector#0 via request_irq(), Qemu calls VFIO_
>         DEVICE_SET_IRQS to enable vector#0 again, with a eventfd different
>         from the one provided in 2);
> 
>     4) When guest unmasks vector#1, Qemu finds it's outside of allocated
>         vectors (only vector#0 now):
> 
>         a) Qemu first calls VFIO_DEVICE_SET_IRQS to disable and free 
>             irq for vector#0;
> 
>         b) Qemu then calls VFIO_DEVICE_SET_IRQS to allocate and enable
>             irqs for both vector#0 and vector#1;
> 
>      5) When guest unmasks vector#2, same flow in 4) continues.
> 
>      ....
> 
> If above understanding is correct, how is lost interrupt avoided between 
> 4.a) and 4.b) given that irq has been torn down for vector#0 in the middle
> while from guest p.o.v this vector is actually unmasked? There must be
> a mechanism in place, but I just didn't figure it out...

In practice unmasking new vectors is rare and done only at
initialization.  Risk from lost interrupts at this time is low.  When
masking and unmasking vectors that are already in use, we're only
changing the signaling eventfd between KVM and QEMU such that QEMU can
set emulated pending bits in response to interrupts (and our lack of
interfaces to handle the mask/unmask at the host).  I believe that
locking in the vfio-pci driver prevents an interrupt from being lost
during the eventfd switch.

> Given above flow is robust, mapping Thomas's model to this flow is
> straightforward. Assume idxd mdev has two vectors: vector#0 for
> misc/error interrupt and vector#1 as completion interrupt for guest
> sva. VFIO_DEVICE_SET_IRQS is handled by idxd mdev driver:
> 
>     2) When guest enables virtual MSI-X capability, Qemu calls VFIO_
>         DEVICE_SET_IRQS to enable vector#0. Because vector#0 is not
>         used for sva, MSIX_PERM#0 has PASID disabled. Host idxd driver 
>         knows to register default PASID to msi_desc#0 when allocating irqs. 
>         Then .startup() callback of ims irqchip is called to program default 
>         PASID saved in msi_desc#0 to the target ims entry when request_irq().
> 
>     3) When guest unmasks vector#0 via request_irq(), Qemu calls VFIO_
>         DEVICE_SET_IRQS to enable vector#0 again. Following same logic
>         as vfio-pci, idxd driver first disable irq#0 via free_irq() and then
>         re-enable irq#0 via request_irq(). It's still default PASID being used
>         according to msi_desc#0.
> 
>     4) When guest unmasks vector#1, Qemu finds it's outside of allocated
>         vectors (only vector#0 now):
> 
>         a) Qemu first calls VFIO_DEVICE_SET_IRQS to disable and free 
>             irq for vector#0. msi_desc#0 is also freed.
> 
>         b) Qemu then calls VFIO_DEVICE_SET_IRQS to allocate and enable
>             irqs for both vector#0 and vector#1. At this point, MSIX_PERM#0
>            has PASID disabled while MSIX_PERM#1 has a valid guest PASID1
>            for sva. idxd driver registers default PASID to msix_desc#0 and 
>            host PASID2 (translated from guest PASID1) to msix_desc#1 when
>            allocating irqs. Later when both irqs are enabled via request_irq(),
>            ims irqchip driver updates the target ims entries according to 
>            msix_desc#0 and misx_desc#1 respectively.
> 
> But this is specific to how Qemu virtualizes MSI-X today. What about it
> may change (or another device model) to allocate all table_size irqs 
> when guest enables MSI-X capability? At that point we don't have valid
> MSIX_PERM content to register PASID info to msix_desc. Possibly what 
> we really require is a separate helper function allowing driver to update 
> msix_desc after irq allocation, e.g. when guest unmasks a vector...

I think you're basically asking how you can guarantee that you always
have a mechanism to update your device specific MSIX_PERM table before
or after the vector tables.  You're trapping and emulating the
MSIX_PERM table, so every write traps to your driver.  Therefore
shouldn't the driver be able to setup any vector using the default PASID
if MSIX_PERM is not configured and update it with the correct PASID
translation based on the trapped write to the register?  Logically I
think you'd want your guest driver to mask and unmask the affected
vector around modifying the MSIX_PERM entry as well, so it would be
another option to reevaluate MSI_PERM on unmask, which triggers a
SET_IRQS ioctl into the idxd host driver.  Either entry point could
trigger a descriptor update to the host irqchip driver.
 
> and do you see any other facets which are overlooked here?

AIUI, the default with no sva PASID should always work, the host driver
initializes the device with a virtual MSIX_PERM table with all the
entries disabled, no special guest/host driver coordination is
required.  In the case of setting a PASID for a vector, you have entry
points into the driver either by the virtualization of the MSIX_PERM
table or likely also at the unmasking of the vector, so it seems fully
contained.  Thanks,

Alex

