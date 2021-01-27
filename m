Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBB4630604F
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 16:56:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236756AbhA0Pzu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 10:55:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47736 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235961AbhA0Pyj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Jan 2021 10:54:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611762792;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PXYtX1skbuLwvPsvbYxJ0NQhgAlgq6m7r/w0lmFC0hE=;
        b=id12GhprtFREZcFLG8zNQJsVOCimvlkSfr9b7zNUBnLtY2VZFxJVVgaJNBDVXa/tZGmTnN
        SOp+Z4QyKlwEye+G+utztUlEhN4lNyd74GpIloFEtPJwysNdgj09cXjDcmDTpXcQutZLjc
        sF3E0/4pDLJKPA38SrwpCAlXjwKU6D8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-Qgk7fIELOpKnIcyiNNqqJQ-1; Wed, 27 Jan 2021 10:53:08 -0500
X-MC-Unique: Qgk7fIELOpKnIcyiNNqqJQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1F0FC1800D42;
        Wed, 27 Jan 2021 15:53:07 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6880360C62;
        Wed, 27 Jan 2021 15:53:06 +0000 (UTC)
Date:   Wed, 27 Jan 2021 08:53:05 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     cohuck@redhat.com, schnelle@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@de.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] vfio-pci/zdev: Introduce the zPCI I/O vfio region
Message-ID: <20210127085305.153e01e4@omen.home.shazbot.org>
In-Reply-To: <b2d4e3bf-1c73-79fa-9f31-76286d394116@linux.ibm.com>
References: <1611086550-32765-1-git-send-email-mjrosato@linux.ibm.com>
        <1611086550-32765-5-git-send-email-mjrosato@linux.ibm.com>
        <20210122164843.269f806c@omen.home.shazbot.org>
        <9c363ff5-b76c-d697-98e2-cf091a404d15@linux.ibm.com>
        <20210126161817.683485e0@omen.home.shazbot.org>
        <b2d4e3bf-1c73-79fa-9f31-76286d394116@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 27 Jan 2021 09:23:04 -0500
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> On 1/26/21 6:18 PM, Alex Williamson wrote:
> > On Mon, 25 Jan 2021 09:40:38 -0500
> > Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> >   
> >> On 1/22/21 6:48 PM, Alex Williamson wrote:  
> >>> On Tue, 19 Jan 2021 15:02:30 -0500
> >>> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> >>>      
> >>>> Some s390 PCI devices (e.g. ISM) perform I/O operations that have very
> >>>> specific requirements in terms of alignment as well as the patterns in
> >>>> which the data is read/written. Allowing these to proceed through the
> >>>> typical vfio_pci_bar_rw path will cause them to be broken in up in such a
> >>>> way that these requirements can't be guaranteed. In addition, ISM devices
> >>>> do not support the MIO codepaths that might be triggered on vfio I/O coming
> >>>> from userspace; we must be able to ensure that these devices use the
> >>>> non-MIO instructions.  To facilitate this, provide a new vfio region by
> >>>> which non-MIO instructions can be passed directly to the host kernel s390
> >>>> PCI layer, to be reliably issued as non-MIO instructions.
> >>>>
> >>>> This patch introduces the new vfio VFIO_REGION_SUBTYPE_IBM_ZPCI_IO region
> >>>> and implements the ability to pass PCISTB and PCILG instructions over it,
> >>>> as these are what is required for ISM devices.  
> >>>
> >>> There have been various discussions about splitting vfio-pci to allow
> >>> more device specific drivers rather adding duct tape and bailing wire
> >>> for various device specific features to extend vfio-pci.  The latest
> >>> iteration is here[1].  Is it possible that such a solution could simply
> >>> provide the standard BAR region indexes, but with an implementation that
> >>> works on s390, rather than creating new device specific regions to
> >>> perform the same task?  Thanks,
> >>>
> >>> Alex
> >>>
> >>> [1]https://lore.kernel.org/lkml/20210117181534.65724-1-mgurtovoy@nvidia.com/
> >>>      
> >>
> >> Thanks for the pointer, I'll have to keep an eye on this.  An approach
> >> like this could solve some issues, but I think a main issue that still
> >> remains with relying on the standard BAR region indexes (whether using
> >> the current vfio-pci driver or a device-specific driver) is that QEMU
> >> writes to said BAR memory region are happening in, at most, 8B chunks
> >> (which then, in the current general-purpose vfio-pci code get further
> >> split up into 4B iowrite operations).  The alternate approach I'm
> >> proposing here is allowing for the whole payload (4K) in a single
> >> operation, which is significantly faster.  So, I suspect even with a
> >> device specific driver we'd want this sort of a region anyhow..  
> > 
> > Why is this device specific behavior?  It would be a fair argument that
> > acceptable device access widths for MMIO are always device specific, so
> > we should never break them down.  Looking at the PCI spec, a TLP
> > requires a dword (4-byte) aligned address with a 10-bit length field > indicating the number of dwords, so up to 4K data as you suggest is the  
> 
> Well, as I mentioned in a different thread, it's not really device 

Sorry, I tried to follow the thread, not sure it's possible w/o lots of
preexisting s390 knowledge.

> specific behavior but rather architecture/s390x specific behavior; 
> PCISTB is an interface available to all PCI devices on s390x, it just so 
> happens that ISM is the first device type that is running into the 
> nuance.  The architecture is designed in such a way that other devices 
> can use the same interface in the same manner.

As a platform access mechanism, this leans towards a platform specific
implementation of the PCI BAR regions.
 
> To drill down a bit, the PCISTB payload can either be 'strict' or 
> 'relaxed', which via the s390x architecture 'relaxed' means it's not 
> dword-aligned but rather byte-aligned up to 4K.  We find out at init 
> time which interface a device supports --  So, for a device that 
> supports 'relaxed' PCISTB like ISM, an example would be a PCISTB of 11 
> bytes coming from a non-dword-aligned address is permissible, which 
> doesn't match the TLP from the spec as you described...  I believe this 
> 'relaxed' operation that steps outside of the spec is unique to s390x. 
> (Conversely, devices that use 'strict' PCISTB conform to the typical TLP 
> definition)
> 
> This deviation from spec is to my mind is another argument to treat 
> these particular PCISTB separately.

I think that's just an accessor abstraction, we're not asking users to
generate TLPs.  If we expose a byte granularity interface, some
platforms might pass that directly to the PCISTB command, otherwise
might align the address, perform a dword access, and return the
requested byte.  AFAICT, both conventional and express PCI use dword
alignement on the bus, so this should be valid and at best questions
whether ISM is really PCI or not.

> > whole payload.  It's quite possible that the reason we don't have more
> > access width problems is that MMIO is typically mmap'd on other
> > platforms.  We get away with using the x-no-mmap=on flag for debugging,
> > but it's not unheard of that the device also doesn't work quite
> > correctly with that flag, which could be due to access width or timing
> > difference.
> > 
> > So really, I don't see why we wouldn't want to maintain the guest
> > access width through QEMU and the kernel interface for all devices.  It
> > seems like that should be our default vfio-pci implementation.  I think
> > we chose the current width based on the QEMU implementation that was
> > already splitting accesses, and it (mostly) worked.  Thanks,
> >   
> 
> But unless you think that allowing more flexibility than the PCI spec 
> dictates (byte-aligned up to 4K rather than dword-aligned up to 4K, see 
> above) this still wouldn't allow me to solve the issue I'm trying to 
> with this patch set.

As above, it still seems like an improvement to honor user access width
to the ability of the platform or bus/device interface.  If ISM is
really that different from PCI in this respect, it only strengthens the
argument to make a separate bus driver derived from vfio-pci(-core) imo.

> If you DO think allowing byte-aligned access up to 4K is OK, then I'm 
> still left with a further issue (@Niklas):  I'm also using this 
> region-based approach to ensure that the host uses a matching interface 
> when talking to the host device (basically, s390x has two different 
> versions of access to PCI devices, and for ISM at least we need to 
> ensure that the same operation intercepted from the guest is being used 
> on the host vs attempting to 'upgrade', which always happens via the 
> standard s390s kernel PCI interfaces).

In the proposed vfio-pci-core library model, devices would be attached
to the most appropriate vfio bus driver, an ISM device might be bound
to a vfio-zpci-ism (heh, "-ism") driver on the host, standard device
might simply be attached to vfio-pci.  Thanks,

Alex

