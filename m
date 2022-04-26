Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5A3B510ADC
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 22:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355212AbiDZVCq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 17:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349114AbiDZVCp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 17:02:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 121744DF71
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 13:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651006776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yFssX/3Sirt7PD9ShzxinAjKs8uWAPR9IqbfxLYFptw=;
        b=YXSvKU2n3Hfg/u6isSyRcYvyz9bUehH2E5eo7/dXBcfzSfZeXLruIr4GF3VDsLgpSXSko3
        QeomDft1Opc0mC+D2hj7lKag80/7DNnFO9i/hvwpz8KWqiy8glUbPsuoH5WVB7fd6x4hRy
        /TURyzgwNkkp7FzV9Zj6Q3qleeAwI4U=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-490-M7d54q76PhCVhM5VKaErOA-1; Tue, 26 Apr 2022 16:59:34 -0400
X-MC-Unique: M7d54q76PhCVhM5VKaErOA-1
Received: by mail-io1-f72.google.com with SMTP id k20-20020a5e9314000000b00649d55ffa67so33930iom.20
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 13:59:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=yFssX/3Sirt7PD9ShzxinAjKs8uWAPR9IqbfxLYFptw=;
        b=r7Iq0oPSLE1c1hxkUsurvj8n4Q9i6TmYe1Ax49PSyaN6aIFkpXsMjJ9p3MHJPJ5aDO
         9n3jJWFrrQ/v467Hz3JV5ML8wHM6zHq2/npA19xtc+za86d1Ij4Nz+6DLpZgC2ntY1QL
         bDjwYxiLI/o0aHGWiBqBTxTPjlIDgIEFZzF6Djm36lK0x3swLEOrHPGLrHt7Hke+Zd7H
         4LX1zUmposEl+u4gGpKIWUyuKAnfed8vH6lFDIJKqlWySi6/G13E5mNpATaXScWaClJe
         DLuEF0MWZa1M7dKxo8CtgMPMvoUB9XcHuDp22dbpOfsSz2YM0/ZWVZYKyrUtCLxh5E+D
         DqZQ==
X-Gm-Message-State: AOAM531pReaajaOZmUzQrtcd8Rdc8FEAj/Jx4rLHC4Vnt9xsbqOpUAgG
        2m9vrdefwkMuvUFKi0e1pIlNFICLMJ5FQk0qMi4Jcwb/dAgh2OiRVVzfaVo+ziVEdOuKNIeRbdz
        Tab7RoEWn7j8R
X-Received: by 2002:a05:6e02:148c:b0:2cd:9399:369b with SMTP id n12-20020a056e02148c00b002cd9399369bmr4799701ilk.300.1651006773748;
        Tue, 26 Apr 2022 13:59:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzsRLDM6Lvs6heEinL0EeuS1qhq29rV39BskKBzgX31u3W5bIxR/6UBFUG9tcEZCsIIotsBQw==
X-Received: by 2002:a05:6e02:148c:b0:2cd:9399:369b with SMTP id n12-20020a056e02148c00b002cd9399369bmr4799693ilk.300.1651006773408;
        Tue, 26 Apr 2022 13:59:33 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id a9-20020a926609000000b002ca50234d00sm8449673ilc.2.2022.04.26.13.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 13:59:33 -0700 (PDT)
Date:   Tue, 26 Apr 2022 14:59:31 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yi Liu <yi.l.liu@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
        "Peng, Chao P" <chao.p.peng@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "thuth@redhat.com" <thuth@redhat.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "peterx@redhat.com" <peterx@redhat.com>
Subject: Re: [RFC 15/18] vfio/iommufd: Implement iommufd backend
Message-ID: <20220426145931.23cb976b.alex.williamson@redhat.com>
In-Reply-To: <20220426192703.GS2125828@nvidia.com>
References: <20220414104710.28534-1-yi.l.liu@intel.com>
        <20220414104710.28534-16-yi.l.liu@intel.com>
        <20220422145815.GK2120790@nvidia.com>
        <3576770b-e4c2-cf11-da0c-821c55ab9902@intel.com>
        <BN9PR11MB5276AD0B0DAA59A44ED705618CFB9@BN9PR11MB5276.namprd11.prod.outlook.com>
        <20220426134114.GM2125828@nvidia.com>
        <79de081d-31dc-41a4-d38f-1e28327b1152@intel.com>
        <20220426141156.GO2125828@nvidia.com>
        <20220426124541.5f33f357.alex.williamson@redhat.com>
        <20220426192703.GS2125828@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 26 Apr 2022 16:27:03 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Apr 26, 2022 at 12:45:41PM -0600, Alex Williamson wrote:
> > On Tue, 26 Apr 2022 11:11:56 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Tue, Apr 26, 2022 at 10:08:30PM +0800, Yi Liu wrote:
> > >   
> > > > > I think it is strange that the allowed DMA a guest can do depends on
> > > > > the order how devices are plugged into the guest, and varys from
> > > > > device to device?
> > > > > 
> > > > > IMHO it would be nicer if qemu would be able to read the new reserved
> > > > > regions and unmap the conflicts before hot plugging the new device. We
> > > > > don't have a kernel API to do this, maybe we should have one?    
> > > > 
> > > > For userspace drivers, it is fine to do it. For QEMU, it's not quite easy
> > > > since the IOVA is GPA which is determined per the e820 table.    
> > > 
> > > Sure, that is why I said we may need a new API to get this data back
> > > so userspace can fix the address map before attempting to attach the
> > > new device. Currently that is not possible at all, the device attach
> > > fails and userspace has no way to learn what addresses are causing
> > > problems.  
> > 
> > We have APIs to get the IOVA ranges, both with legacy vfio and the
> > iommufd RFC, QEMU could compare these, but deciding to remove an
> > existing mapping is not something to be done lightly.   
> 
> Not quite, you can get the IOVA ranges after you attach the device,
> but device attach will fail if the new range restrictions intersect
> with the existing mappings. So we don't have an easy way to learn the
> new range restriction in a way that lets userspace ensure an attach
> will not fail due to reserved ranged overlapping with mappings.
> 
> The best you could do is make a dummy IOAS then attach the device,
> read the mappings, detatch, and then do your unmaps.

Right, the same thing the kernel does currently.

> I'm imagining something like IOMMUFD_DEVICE_GET_RANGES that can be
> called prior to attaching on the device ID.

Something like /sys/kernel/iommu_groups/$GROUP/reserved_regions?

> > We must be absolutely certain that there is no DMA to that range
> > before doing so.  
> 
> Yes, but at the same time if the VM thinks it can DMA to that memory
> then it is quite likely to DMA to it with the new device that doesn't
> have it mapped in the first place.

Sorry, this assertion doesn't make sense to me.  We can't assume a
vIOMMU on x86, so QEMU typically maps the entire VM address space (ie.
device address space == system memory).  Some of those mappings are
likely DMA targets (RAM), but only a tiny fraction of the address space
may actually be used for DMA.  Some of those mappings are exceedingly
unlikely P2P DMA targets (device memory), so we don't consider mapping
failures to be fatal to attaching the device.

If we have a case where a range failed for one device but worked for a
previous, we're in the latter scenario, because we should have failed
the device attach otherwise.  Your assertion would require that there
are existing devices (plural) making use of this mapping and that the
new device is also likely to make use of this mapping.  I have a hard
time believing that evidence exists to support that statement.
 
> It is also a bit odd that the behavior depends on the order the
> devices are installed as if you plug the narrower device first then
> the next device will happily use the narrower ranges, but viceversa
> will get a different result.

P2P use cases are sufficiently rare that this hasn't been an issue.  I
think there's also still a sufficient healthy dose of FUD whether a
system supports P2P that drivers do some validation before relying on
it.
 
> This is why I find it bit strange that qemu doesn't check the
> ranges. eg I would expect that anything declared as memory in the E820
> map has to be mappable to the iommu_domain or the device should not
> attach at all.

You have some interesting assumptions around associating
MemoryRegionSegments from the device AddressSpace to something like an
x86 specific E820 table.  The currently used rule of thumb is that if
we think it's memory, mapping failure is fatal to the device, otherwise
it's not.  If we want each device to have the most complete mapping
possible, then we'd use a container per device, but that implies a lot
of extra overhead.  Instead we try to attach the device to an existing
container within the address space and assume if it was good enough
there, it's good enough here.

> The P2P is a bit trickier, and I know we don't have a good story
> because we lack ACPI description, but I would have expected the same
> kind of thing. Anything P2Pable should be in the iommu_domain or the
> device should not attach. As with system memory there are only certain
> parts of the E820 map that an OS would use for P2P.
> 
> (ideally ACPI would indicate exactly what combinations of devices are
> P2Pable and then qemu would use that drive the mandatory address
> ranges in the IOAS)

How exactly does ACPI indicate that devices can do P2P?  How can we
rely on ACPI for a problem that's not unique to platforms that
implement ACPI?

> > > > yeah. qemu can filter the P2P BAR mapping and just stop it in qemu. We
> > > > haven't added it as it is something you will add in future. so didn't
> > > > add it in this RFC. :-) Please let me know if it feels better to filter
> > > > it from today.    
> > > 
> > > I currently hope it will use a different map API entirely and not rely
> > > on discovering the P2P via the VMA. eg using a DMABUF FD or something.
> > > 
> > > So blocking it in qemu feels like the right thing to do.  
> > 
> > Wait a sec, so legacy vfio supports p2p between devices, which has a
> > least a couple known use cases, primarily involving GPUs for at least
> > one of the peers, and we're not going to make equivalent support a
> > feature requirement for iommufd?    
> 
> I said "different map API" - something like IOMMU_FD_MAP_DMABUF
> perhaps.

For future support, yes, but your last sentence above states to
outright block it for now, which would be a visible feature regression
vs legacy vfio.

> The trouble with taking in a user pointer to MMIO memory is that it
> becomes quite annoying to go from a VMA back to the actual owner
> object so we can establish proper refcounting and lifetime of struct-page-less
> memory. Requiring userspace to make that connection via a FD
> simplifies and generalizes this.
> 
> So, qemu would say 'oh this memory is exported by VFIO, I will do
> VFIO_EXPORT_DMA_BUF, then do IOMMU_FD_MAP_DMABUF, then close the FD'
> 
> For vfio_compat we'd have to build some hacky compat approach to
> discover the dmabuf for vfio-pci from the VMA.
> 
> But if qemu is going this way with a new implementation I would prefer
> the new implementation use the new way, when we decide what it should
> be.
> 
> As I mentioned before I would like to use DMABUF since I already have
> a use-case to expose DMABUF from vfio-pci to connect to RDMA. I will
> post the vfio DMABUF patch I have already.

I'm not suggesting there aren't issues with P2P mappings, we all know
that legacy vfio has various issues currently.  I'm only stating that
there are use cases for it and if we cannot support those use cases
then we can't do a transparent switch to iommufd when it's available.
Switching would depend not only on kernel/QEMU support, but the
necessary features for the VM, where we have no means to
programmatically determine the latter.  Thanks,

Alex

