Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 516B972EBED
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 21:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232435AbjFMTZQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 15:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240844AbjFMTY4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 15:24:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D6401BF0
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 12:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686684249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o0Xp4cZRzSm04wF//W6ULMDJ6pAy04YCwjnVzsE4FtU=;
        b=SsvKEXTxeIar6Kn4GIEwPW6ohbcUEkmCH+kcfXecPqk4q8IO6cMJvt567lFAndQNgC5+hl
        RzhFOzbwM5Jv5El56gqd4bqEX+u0ioFtferjFtr+EY3MmjI3YWLDgfyo40zbxx5YVuDh1e
        CYRf9Nfty8aTKWGnkeMy1gzraQ61vAI=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-646-VAExVrElNKm3b-qJoiZZ6w-1; Tue, 13 Jun 2023 15:24:05 -0400
X-MC-Unique: VAExVrElNKm3b-qJoiZZ6w-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-33b372d1deeso52054025ab.3
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 12:24:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686684244; x=1689276244;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o0Xp4cZRzSm04wF//W6ULMDJ6pAy04YCwjnVzsE4FtU=;
        b=VWF9vCBkUQ0ZJJ83avx6OQuD7i/f0McU0TiL4WjXESkFy+1KcsIKkL7KB0T0ndJUUJ
         spu4pa3cqcGs2ze2RfD+pf59us3zydv6eVJGgRd3wAvAKFbdug1dcOY1GrwKcfas+cPN
         cSwB8XhugfrfkuOE3zgDqYlccvyXWEw4zn1SyKjZ/x8c8oD0z48lIam6UcpvyWS0junK
         7mAN6U6E+mo2zHrtZJ4d+UEXo+uCwjn/iUqCG5dJLPUNxNtrmlw5HZtWYqC0a89i9cZe
         Bmr0zwkkUif4hScfKlfD6dupEAal4ZLZcQv+nS8Gh5KFMdY1AZsb+ZkQ1xKDamRGiumL
         xMIQ==
X-Gm-Message-State: AC+VfDxvzbf3s7mKeIFVl2Bi/EkD6h8Lau9EfMrMz4FoOkwW1UloWM+R
        dJrwpPPUjUOR/AbAUdvAFU5s5zgFeUJ/PYC4tZueUpG8UrUMlZFCZMpklSPTBv1GyDJpQ0XGZ4Z
        LBdv6jeWBRH7c
X-Received: by 2002:a05:6e02:544:b0:33b:f86:d2ac with SMTP id i4-20020a056e02054400b0033b0f86d2acmr11024592ils.1.1686684244553;
        Tue, 13 Jun 2023 12:24:04 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6UjVusKH334SviJEX1YcZHvyy4usNg7QiXPX6t9JZvkQId9cz2LdV7NKff5YpRTYpUaSrDZQ==
X-Received: by 2002:a05:6e02:544:b0:33b:f86:d2ac with SMTP id i4-20020a056e02054400b0033b0f86d2acmr11024581ils.1.1686684244203;
        Tue, 13 Jun 2023 12:24:04 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id x24-20020a02ac98000000b00420c5d10c38sm3508457jan.74.2023.06.13.12.24.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 12:24:03 -0700 (PDT)
Date:   Tue, 13 Jun 2023 13:24:02 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     ankita@nvidia.com, aniketa@nvidia.com, cjia@nvidia.com,
        kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
        acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
        danw@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] vfio/nvgpu: Add vfio pci variant module for
 grace hopper
Message-ID: <20230613132402.2765b6cb.alex.williamson@redhat.com>
In-Reply-To: <ZIh+wXFrls7StWzc@nvidia.com>
References: <20230606025320.22647-1-ankita@nvidia.com>
        <20230606083238.48ea50e9.alex.williamson@redhat.com>
        <ZH9RfXhbuED2IUgJ@nvidia.com>
        <20230606110510.0f87952c.alex.williamson@redhat.com>
        <ZH9p+giEs6bCYfw8@nvidia.com>
        <20230606121348.670229ff.alex.williamson@redhat.com>
        <ZH+DdVIyZ6hHCDaK@nvidia.com>
        <20230606153057.4cbc36a0.alex.williamson@redhat.com>
        <ZH/LzyF/uttviRnQ@nvidia.com>
        <20230607122303.5d25c973.alex.williamson@redhat.com>
        <ZIh+wXFrls7StWzc@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 13 Jun 2023 11:35:45 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Jun 07, 2023 at 12:23:03PM -0600, Alex Williamson wrote:
> 
> > > The fixing is generic, a generic function does not elevate to create a
> > > vendor uAPI IMHO.  
> > 
> > Who else is trying to expose a non-power-of-2 region as a BAR right
> > now?   
> 
> I see a few needs in other places internally that are not public yet,
> especially in the SIOV world I alluded to below.
> 
> > We have neither a specification nor a complimentary implementation
> > from which to derive generic support.    
> 
> "specification"? It is literally - the size of the bar is not a power
> of two, so make the resulting hole when mapping that to a vPCI discard
> writes and read 0s.
> 
> This isn't a PCI specification, it is a contract between the kernel
> side and the VMM side within VFIO about how to handle VFIO devices
> where the kernel driver wants to have a padding.
> 
> It makes sense that we shouldn't just do this blidly for the existing
> indexes without some negotation, but that isn't a PCI "compliance"
> problem, that is a incomplete VFIO uAPI design in this patch.
> 
> > GPUs seem to manage to have non-power-of-2 size VRAM while still
> > providing BARs that are a power-of-2, ex. 6GB VRAM, 8GB BAR.    
> 
> Generally excess BAR is modeled in HW as discard writes return 0 (or
> maybe return -1). HW can do this easially. SW is more tricky
> 
> > Why shouldn't the variant driver here extend the BAR region to a
> > power-of-2 and then we can decide the error handling should accesses
> > exceed the implemented range?  
> 
> This sounds doable, I don't know if Ankit had a problem with using the
> sparse mmap feature to do this. We'd need to have the padding be
> non-mmapable space and then the kernel driver would do the discard/0
> with the read/write calls.
> 
> If this works out I'm happy enough if we go this way too. I suppose it
> allows better compatibility with all the VMMs.

I'd even forgotten about the sparse mmap solution here, that's even
better than trying to do something clever with the mmap.

Existing QEMU has an assert in pci_register_bar() that the size of the
MemoryRegion must be a power of 2, therefore it is ABI that the a vfio
PCI BAR region must be a power of 2.  It's not sufficient to change
QEMU, an old QEMU running on a kernel with this device would assert.
The BAR region must either be properly sized or we define a new region
definition which requires new QEMU support to mimic a BAR, but I don't
know why we wouldn't just use this sparse mmap trick.

> > > I would say if the thing that is showing up on the VM side is not PCI
> > > then maybe a vendor label might make sense.  
> > 
> > Well, how do you suppose a device with a non-power-of-2 BAR is PCI
> > compliant?  You're asking the VMM to assume what the driver meant by
> > providing that non-standard BAR, which sounds vendor specific to me.  
> 
> It shows up as a PCI compliant device in the VM, with a compliant
> power of two size.
> 
> > Is your primary complaint here that you don't want
> > that region to be labeled VFIO_PCI_NVGPU_BAR1?    
> 
> Yes. This modified VFIO uAPI contract is general enough it should not
> be forced as unique to this device.
> 
> > We could certainly define VFIO_PCI_VENDOR_BAR0..5 where QEMU knows
> > that it's supposed to relax expectations and mangle the region into
> > a compliant BAR, but now you're adding complexity that may never be
> > used elsewhere.  
> 
> I wouldn't use a _VENDOR_ name for this since it is generic.
> 
> I would suggest using a FEATURE:
> 
> /*
>  * When SET to 1 it indicates that the userspace understands non-power of two
>  * region sizes on VFIO_PCI_BARx_REGION_INDEX. If the kernel driver requests a
>  * non-power of two size then if userspace needs to round the size back up to a
>  * power of two, eg to create a vPCI device, it should return 0 for reads and
>  * discard writes for the padding that was added.
>  *
>  * If this flag is not set, and the VFIO driver cannot work without non-power of
>  * two BARs then mmap of those BAR indexes will fail. (FIXME: maybe
>  * this needs more thinking)
>  */
> #define VFIO_DEVICE_FEATURE_PCI_PAD_BARS 10
> 
> As adding new index types for every new functionality will become
> combinatoral, and adding discovery of which vPCI BAR index the new
> indexes should map too is also complicated..
> 
> Though sparse mmap is probably better.

Yes.

> > > It really has nothing to do with the regions, it is something that is
> > > needed if this variant driver is being used at all. The vPCI device
> > > will work without the ACPI, but the Linux drivers won't like it.  
> > 
> > OTOH if the ACPI work is based on device specific regions, the list of
> > device IDs in QEMU goes away and support for a new device requires no
> > VMM changes.  
> 
> Using the device ID seems like the better approach as we don't know
> what future devices using this varient driver are going to need for
> ACPI modeling.
> 
> It also seems I was too optimistic to think a simple variant driver ID
> would be sufficient. IMHO you are closer below, it depends on what
> bare metal FW qemu is trying to emulate, which I suppose is
> technically a combination of the machine type and the installed vPCI
> devices..
> 
> > > The ACPI is not related to the region. It is just creating many empty
> > > NUMA nodes. They should have no CPUs and no memory. The patch is
> > > trying to make the insertion of the ACPI automatic. Keying it off a
> > > region is not right for the purpose.  
> > 
> > Why aren't the different NUMA nodes a machine type option?  If we start
> > having each device mangle the machine in incompatible ways it seems
> > like we're going to get conflicts not only with other devices, but also
> > user specified NUMA configurations.  
> 
> You may be right, I think this patch is trying to make things
> automatic for user, but a dedicated machine type might make more
> sense.

Juan and I discussed this with Ankit last week, there are a lot of down
sides with another machine type, but the automatic manipulation of the
machine is still problematic.  Another option we have is to use QEMU
command line options for each feature.  For example we already support
NUMA VM configurations and loading command line ACPI tables, hopefully
also associating devices to nodes.  Do we end up with just a
configuration spec for the VM to satisfy the in-guest drivers?
Potentially guest driver requirements may changes over time, so a hard
coded recipe built-in to QEMU might not be the best solution anyway.

> > I'm struggling with whether I can
> > set some bits in the root port devcap2 register[1] based on device
> > capabilities and here this is fundamentally manipulating the VM
> > topology.
> > 
> > [1]https://lore.kernel.org/all/20230526231558.1660396-1-alex.williamson@redhat.com/  
> 
> That does seem a bit dicey - alot of this stuff, especially ACPI, is
> reasonably assumed to be set at boot time by an OS. Changing it
> dynamically becomes exciting..

I think we need to be careful about how and where we apply it.  Yes,
there could be a guest OS that caches the capabilities of the root
ports and could have stale information at the time the driver probes
Atomic Ops information.  But the spec doesn't prohibit RO defined bits
from changing that I can find... and I can't come up with a better
solution to support atomic ops.

The alternative would again be device switches on the QEMU command
line, which I think would have a dependency on disabling hotplug for
the slot (pcie-root-port,hotplug=off) and also need to validate that
all virtual downstream devices capable of those atomic ops have
equivalent host support.  I couldn't find enough downsides to the risk
that a guest booted with an Atomic Ops capable device that also caches
the capabilities of the root port (Linux doesn't) might hot-unplug that
device, hot-plug a new device w/o the same host support (ex. different
slot or different host after a migration), and report the stale atomic
ops support.

I think NVIDIA might have an interest in enabling Atomic Ops support in
VMs as well, so please comment in the series thread if there are
concerns here or if anyone can definitively says that another guest OS
we might care about does cache root port capability bits.  Thanks,

Alex

