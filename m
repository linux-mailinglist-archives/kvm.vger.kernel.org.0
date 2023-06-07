Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7882572689C
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 20:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231585AbjFGSZO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 14:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231626AbjFGSZC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 14:25:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B59A26AF
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 11:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686162188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wlm0G7x30CnhSolBIx64+/Gh1I5IPiqWKD1I4nhgFYs=;
        b=fuBySzCT+IaV2qABzPSCIJzLPa2TWJ7ld3ThA1dM+l/7d516nar4XN2Jn24A2/XkLcQmy3
        tmqBa5qaCcXL96KTDnt/X9G/GJmBQHmQ2EQNOC3dJ+27Vz9gBQVnwyn0u6UR/Q09YQD1Zn
        /ef5l3tTrcrKgX7q+ZYf/4bNwpQLI7c=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-480-CqyhAQwLPtKQ3rBNWzZ8dw-1; Wed, 07 Jun 2023 14:23:07 -0400
X-MC-Unique: CqyhAQwLPtKQ3rBNWzZ8dw-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-777b6a2582dso289746739f.2
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 11:23:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686162186; x=1688754186;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wlm0G7x30CnhSolBIx64+/Gh1I5IPiqWKD1I4nhgFYs=;
        b=hn0QE0gtnuz+HaHOA07+KR+El/PV77rej2lIWh3f21wx8eniZlbfu+Bum12a70ZXSj
         BV+RnCwbGF038NUqRMYgqv3citRZyBEeDK0a5ioTSWusFjlThHDCdQK7liC6Qd9vZ8/K
         HHAwh5aBOa10mRGMvnXFynxPLjIBc7ifIeaayTeRk32SZeGb+o3jKNEIqaJS6Oys5EQ3
         +VSL3YeovlGAeHkwGroUAG/5nPttECJ1H2niuKHqKLfU2+KBpOeMYHg41JDNAz8Fspc/
         jzteCKnyn9zm8I9Xt97JkVeDgROGc3RbFZXF2ejjSuh9emVQ+So+txt2x86J/i9/H8vO
         4WKA==
X-Gm-Message-State: AC+VfDzp3MApdMFl8yfBgXjpHnCOpPXlCsbvG5sNzYRDaFMjgeWYbZCU
        YIxVfnztANXpRwpylJPKpXovCSDqmY8j/z9/r/xvKX5aFqbbw2FaeERMCEbvwjVzlqB16BssH/7
        kUQCSjuDBCxl4
X-Received: by 2002:a5d:938f:0:b0:774:934c:d178 with SMTP id c15-20020a5d938f000000b00774934cd178mr5210280iol.20.1686162186213;
        Wed, 07 Jun 2023 11:23:06 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5NnizS34TbpUagSIXwDPCP0qM3+NYdzQsgsSosfRmD56iPfdUOhAeyB0ZfQSVww2ZTcFZqDQ==
X-Received: by 2002:a5d:938f:0:b0:774:934c:d178 with SMTP id c15-20020a5d938f000000b00774934cd178mr5210256iol.20.1686162185789;
        Wed, 07 Jun 2023 11:23:05 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id l22-20020a6bd116000000b0076c81bf2731sm3995712iob.20.2023.06.07.11.23.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 11:23:05 -0700 (PDT)
Date:   Wed, 7 Jun 2023 12:23:03 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     ankita@nvidia.com, aniketa@nvidia.com, cjia@nvidia.com,
        kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
        acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
        danw@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] vfio/nvgpu: Add vfio pci variant module for
 grace hopper
Message-ID: <20230607122303.5d25c973.alex.williamson@redhat.com>
In-Reply-To: <ZH/LzyF/uttviRnQ@nvidia.com>
References: <20230606025320.22647-1-ankita@nvidia.com>
        <20230606083238.48ea50e9.alex.williamson@redhat.com>
        <ZH9RfXhbuED2IUgJ@nvidia.com>
        <20230606110510.0f87952c.alex.williamson@redhat.com>
        <ZH9p+giEs6bCYfw8@nvidia.com>
        <20230606121348.670229ff.alex.williamson@redhat.com>
        <ZH+DdVIyZ6hHCDaK@nvidia.com>
        <20230606153057.4cbc36a0.alex.williamson@redhat.com>
        <ZH/LzyF/uttviRnQ@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 6 Jun 2023 21:14:07 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Jun 06, 2023 at 03:30:57PM -0600, Alex Williamson wrote:
> > > To emulate PCI, someone, somewhere, has to fix this mismatch up.
> > > 
> > > So given choices
> > >   1) Qemu sees a special NVIDIA thing and fixes it
> > >   2) Qemu sees a VFIO_PCI_BAR0_REGION with an odd size and fixes it
> > >   3) Kernel lies and makes a power-2 size and it fixes it
> > > 
> > > 2 seems the most forward looking and reusable.  
> > 
> > What?!  It's not just a matter of fixing it.  The vfio-pci uAPI should
> > never return a BAR region that's not compatible as a BAR.   
> 
> Why? But OK, if you don't like then then let's call it
> VFIO_PCI_BAR0_REGION_NOT_POW2. Not seeing that it really helps so
> much..
> 
> > It's incorrectly sized, it does special things with mmap under the
> > covers, and it doesn't honor the memory enable bit.  
> 
> The mmap attributes stuff is not uAPI visible, so it doesn't matter.
> 
> Normal vfio-pci devices will SIGBUS on memory disable, this could do
> that if it was really important (I don't think it is)
> 
> So we are left with.. The size is weird. Someone has to provide the
> fixing to fit that into the PCI config space world because we are
> emulating a real PCI device.
> 
> The fixing is generic, a generic function does not elevate to create a
> vendor uAPI IMHO.

Who else is trying to expose a non-power-of-2 region as a BAR right
now?  We have neither a specification nor a complimentary implementation
from which to derive generic support.  It's possible that the vendor
uAPI could become the de facto implementation, at which point we still
might share the code and generalize the interface, but I have no
crystal ball to predict that.

GPUs seem to manage to have non-power-of-2 size VRAM while still
providing BARs that are a power-of-2, ex. 6GB VRAM, 8GB BAR.  Why
shouldn't the variant driver here extend the BAR region to a power-of-2
and then we can decide the error handling should accesses exceed the
implemented range? (as we know, calling remap_pfn_range() as done here
from a fault handler is troublesome)  If you really want to eliminate
VMM changes, it would be through this.

If there's a requirement for providing the actual size, a vfio
capability on the region or variant driver implementaiton of a device
specific capability in config space of the device could provide that.

> > And then QEMU goes on to ignore this peculiarity when setting up all
> > the ACPI features, instead relying on the PCI vendor/device ID when
> > it could be using a device specific region to initiate that support.  
> 
> We really should not rely on vendor regions to trigger device specific
> VMM behaviors for a variant driver. If we want to do this better than
> vendor/device ID we should have a VFIO ioctl report which variant
> driver is running the device so userspace can do whatever.

Disagree, vendor specific regions or capabilities are the preferred way
to trigger device specific behavior in QEMU.  Surely we don't really
want to endorse a solution of exposing a driver name to infer the
feature set when we have a means to explicitly report features through
capabilities and device specific regions...

> > > I definately don't think this is important enough to stick a vendor
> > > label on it.  
> > 
> > How high is the bar for a device specific region?  This certainly looks
> > and smells like one to me.  
> 
> I would say if the thing that is showing up on the VM side is not PCI
> then maybe a vendor label might make sense.

Well, how do you suppose a device with a non-power-of-2 BAR is PCI
compliant?  You're asking the VMM to assume what the driver meant by
providing that non-standard BAR, which sounds vendor specific to me.

> > > Broadly, we are looking toward a way for the kernel VFIO variant
> > > driver to provide the majority of the "PCI emulation" and the VMM can
> > > be general. It is not nice if every PCI emulation type driver needs
> > > unique modifications to the VMM to support it. We are planning more
> > > than one of these things already, and there are industry standards
> > > afoot that will widly open the door here.  
> > 
> > Meanwhile every VMM needs a hook to extend non-compliant BAR sizes,
> > assuming the kernel will fixup mappings beyond the region extent,  
> 
> Yes! It is a basically a new generic VFIO ability to allow this size
> adaptation. If you don't like this version of the uAPI then lets tweak
> it, but it still needs the same basic operation where the kernel tells
> userspace that a certain mmap is to be placed in a certain BAR config
> space.

"Size adaptation", that sounds like marketing spin for non-compliant.

> > pretend that none of this is a device bug?  It really is a very small
> > amount of code in QEMU to setup a MemoryRegion based on a device
> > specific region and register it as a PCI BAR.  The non-standard size is
> > a factor here when mapping to the VM address space, but I'm a bit
> > surprised to hear an argument for hacking that in the kernel rather
> > than userspace.  
> 
> Well, I'd rather do it in userspace.

A device specific region is the only way I see to do it in userspace.
We should never be providing a non-standard size BAR through the vfio
BAR region indexes.  Is your primary complaint here that you don't want
that region to be labeled VFIO_PCI_NVGPU_BAR1?  We could certainly
define VFIO_PCI_VENDOR_BAR0..5 where QEMU knows that it's supposed to
relax expectations and mangle the region into a compliant BAR, but now
you're adding complexity that may never be used elsewhere.

> > > The only special bit is emulating the weird Grace FW ACPI stuff.  
> > 
> > And a device specific region seems like the ideal jumping off point to
> > create that memory-only node for this thing.  
> 
> It really has nothing to do with the regions, it is something that is
> needed if this variant driver is being used at all. The vPCI device
> will work without the ACPI, but the Linux drivers won't like it.

OTOH if the ACPI work is based on device specific regions, the list of
device IDs in QEMU goes away and support for a new device requires no
VMM changes.

> > > So lets find a way to give these things appropriate generic names at
> > > the ABI level please..  
> > 
> > What is the generic feature that "these things" implement?  
> 
> As far as I can see, non-power-2 size is the thing the VMM needs to
> worry about.
> 
> And maybe a generic way to detect which variant driver is running.

Technically a capability on the device info would allow for this, but I
think it's the wrong approach.  Either expose a compliant BAR region
and do whatever you want with device IDs to hook in the ACPI changes or
make the VMM handle the emulation of a device specific region as a BAR,
at which point not basing the ACPI hooks on those regions would be
redundant and require more maintenance overhead.

> > There's a lot of vendor specific things going on here.  Not only is all
> > that "weird Grace FW ACPI stuff" based on this region, but also if we
> > are exposing it as a BAR, which BAR index(s) for a given device.  
> 
> The kernel decides the BAR indexes, not the vmm, because broadly we
> want to have the kernel in charge of making the synthetic config
> space.
> 
> The ACPI is not related to the region. It is just creating many empty
> NUMA nodes. They should have no CPUs and no memory. The patch is
> trying to make the insertion of the ACPI automatic. Keying it off a
> region is not right for the purpose.

Why aren't the different NUMA nodes a machine type option?  If we start
having each device mangle the machine in incompatible ways it seems
like we're going to get conflicts not only with other devices, but also
user specified NUMA configurations.  I'm struggling with whether I can
set some bits in the root port devcap2 register[1] based on device
capabilities and here this is fundamentally manipulating the VM
topology.

[1]https://lore.kernel.org/all/20230526231558.1660396-1-alex.williamson@redhat.com/

> > If "the industry" does come out with a spec for "these things",
> > couldn't QEMU optionally plug a device specific region into the
> > implementation of that spec, potentially along with some commonly
> > defined region to make this device appear to honor that new spec?
> > Versus with the in-kernel variant driver masquerading the BAR, we're
> > stuck with what the kernel implements.  Would future hardware
> > implementing to this new spec require a variant driver or would we
> > extend vfio-pci to support them with extended regions and expect the
> > VMM to compose them appropriately?    
> 
> Look at Intel's SIOV document for some idea, I expect devices like
> that will be a VFIO driver (not a variant PCI driver) that largely
> exposes the vfio-pci uAPI with the purpose of creating a vPCI device
> in the VM.
> 
> There is no real PCI function under this so all the config space and
> so on will be synthetic. It is convenient if the kernel driver does
> this so that it works on all the VMMs generically.
> 
> Non-power-2 BAR is desirable in this world because address space is
> precious at high scale and power2 scaling gets wasteful.
> 
> Further, I would expect there will be a generic CXL driver and generic
> CXL related ACPI someday.
> 
> This device is sort of in the middle where it does have a real PCI
> function but it is also synthesizing some config space. We have
> another VFIO driver in progress that is also doing some modification
> of the config space..

Thanks for the background, but PCI is still a standard that requires
power-of-2 BAR sizes, so either the in-kernel variant driver needs to
round up and handle the empty space or the VMM does, and the VMM should
specifically enable this for new region indexes and be allowed to
assume PCI compliant BARs through the existing region indexes.  Thanks,

Alex

