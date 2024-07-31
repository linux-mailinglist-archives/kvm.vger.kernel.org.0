Return-Path: <kvm+bounces-22802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D9B5C9434AC
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 19:04:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 362FFB25478
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 17:04:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B3241BD014;
	Wed, 31 Jul 2024 17:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hSDpPVfY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82DD01B14F1
	for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 17:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722445485; cv=none; b=egG/ZmSSmBwA5DMIlI9kSZW7CaTB+LHsHXzLvRa6QsnoNJDuueC5Qfn90kDsO1GUr22u52ODIwz2+4Pur5WUx1DNbFw9mYLe0FiR3WOgdwiE8wYLWzWfP+CHRxDvonX89wIc4soA1rNJLlr/YIJWqEgkqu3wUc2JLoO+RhLRqZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722445485; c=relaxed/simple;
	bh=m87xK56yFr1TC7o//iwXmX6182f06/FzjjQFbeK/Y0Q=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rfw536ZEBwuUKpDb5Pqy3awk1Xzbv/ei8O/KioXEzSQpxnTCvc/TnCRPOmy3zEHBaCIiXW0tL4hSk64W2q8zkPxiTLf+auLHLhiJ5esg5/eTg4aMQrJgFA64hM777Fnv+xkr9f8v6uo1bCzREfgQsBs0fXibvfvO7wmUSlsrP/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hSDpPVfY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722445482;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h1ouC8/orPuHRKQfRRI7RoQT0OOkVorA7V7PiXZQIdA=;
	b=hSDpPVfY82OdELitOficXpVkL+KvlwK8gpc1O8UUZEBwPu1S9SvoWTpMeJHnYcnImBq8Uj
	W4isbC2PB4GGsmqkImd/4YxxlRAtKY6Hh3a556fwC0twF3RHoGoADt1VLC9V0XNVfNOm+u
	3/wAdR24WiDOkJBQYXPiAvEBSLC/O38=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-663-Hzyh4Xx8MLmCuwX8OChiow-1; Wed, 31 Jul 2024 13:04:40 -0400
X-MC-Unique: Hzyh4Xx8MLmCuwX8OChiow-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3987dace329so102190655ab.0
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 10:04:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722445480; x=1723050280;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h1ouC8/orPuHRKQfRRI7RoQT0OOkVorA7V7PiXZQIdA=;
        b=fBOFBIO/qr0VTVPqBCLLZiEXjP8/FJnKEV32yFs/FHTkmS83hpM1pqL/kl8mXJw2po
         6Qs+jJO43zDzCU3Q3YJ17wodDJqprEMLc7viIE95YtCraOIXCM5lHOkOG+gdt91g5gwS
         8OwmWsOQ/hvh+mg1M6rw8jqoaJ7WAWR+BiPVg528VJJ2aiM05016af0uzEbMogkacPuH
         H6xzw61rD+OafSqsddgBONZFwv76ngLyJhCc+akzSp9qV6lnim/oME+ObvShopEongLw
         zkaPRaq/hEvAgQ3dpVef1ECCYsrhkFQazfC3SlZxJ9lcUwtiOE4MEQJ++gJTGSPG1F/K
         5EnQ==
X-Forwarded-Encrypted: i=1; AJvYcCUqFnbTJ7GM7/ScHoEnZN79KQ3ICYTYSAe7L2BXAq2tFG2uxnSWYoqbSi+/VhxrYscacyofHUEfEUAy2pU3uD6I8IYh
X-Gm-Message-State: AOJu0YwWZHl6wxULmWB4l6DU/uH0jxxH70fxOzZH93arDEBTe+g0KvUz
	7xYyDdq0c3T5/Ap07DMGmjj327MdkNqipYFFuNL01enUcRih7hyoLJcamhs2lpQPoNFArypCRLS
	n9Bjj8ga/dbYcRb1GNft/3o4Ql2r5lI/0WKA6KfC0yt0VEjOd8w==
X-Received: by 2002:a05:6e02:1526:b0:374:a781:64b9 with SMTP id e9e14a558f8ab-39aec2e536bmr188517055ab.13.1722445479511;
        Wed, 31 Jul 2024 10:04:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF902HF8tpem7zLZ9Z74C0eR3H3b56lrOKTVf+enUH/SQxiNWR9VdFY09KPQbUMU3a1BsL3tg==
X-Received: by 2002:a05:6e02:1526:b0:374:a781:64b9 with SMTP id e9e14a558f8ab-39aec2e536bmr188516165ab.13.1722445478827;
        Wed, 31 Jul 2024 10:04:38 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-39a23108185sm56151605ab.88.2024.07.31.10.04.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Jul 2024 10:04:38 -0700 (PDT)
Date: Wed, 31 Jul 2024 11:04:36 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, "Liu, Yi L" <yi.l.liu@intel.com>,
 "joro@8bytes.org" <joro@8bytes.org>, "robin.murphy@arm.com"
 <robin.murphy@arm.com>, "eric.auger@redhat.com" <eric.auger@redhat.com>,
 "nicolinc@nvidia.com" <nicolinc@nvidia.com>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
 <chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
 <iommu@lists.linux.dev>, "baolu.lu@linux.intel.com"
 <baolu.lu@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
 "Pan, Jacob jun" <jacob.jun.pan@intel.com>, =?UTF-8?B?Q8OpZHJpYw==?= Le
 Goater <clg@redhat.com>
Subject: Re: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Message-ID: <20240731110436.7a569ce0.alex.williamson@redhat.com>
In-Reply-To: <BN9PR11MB5276D184783C687B0B1B6FE68CB12@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240419103550.71b6a616.alex.williamson@redhat.com>
	<BN9PR11MB52766862E17DF94F848575248C112@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240423120139.GD194812@nvidia.com>
	<BN9PR11MB5276B3F627368E869ED828558C112@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240424001221.GF941030@nvidia.com>
	<20240424122437.24113510.alex.williamson@redhat.com>
	<20240424183626.GT941030@nvidia.com>
	<20240424141349.376bdbf9.alex.williamson@redhat.com>
	<20240426141117.GY941030@nvidia.com>
	<20240426141354.1f003b5f.alex.williamson@redhat.com>
	<20240429174442.GJ941030@nvidia.com>
	<BN9PR11MB5276C4EF3CFB6075C7FC60AC8CAA2@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240730113517.27b06160.alex.williamson@redhat.com>
	<BN9PR11MB5276D184783C687B0B1B6FE68CB12@BN9PR11MB5276.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 31 Jul 2024 05:15:25 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Wednesday, July 31, 2024 1:35 AM
> > 
> > On Wed, 24 Jul 2024 02:26:20 +0000
> > "Tian, Kevin" <kevin.tian@intel.com> wrote:
> >   
> > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > Sent: Tuesday, April 30, 2024 1:45 AM
> > > >
> > > > On Fri, Apr 26, 2024 at 02:13:54PM -0600, Alex Williamson wrote:  
> > > > > Regarding "if we accept that text file configuration should be
> > > > > something the VMM supports", I'm not on board with this yet, so
> > > > > applying it to PASID discussion seems premature.  
> > > >
> > > > Sure, I'm just explaining a way this could all fit together.
> > > >  
> > >
> > > Thinking more along this direction.
> > >
> > > I'm not sure how long it will take to standardize such text files and
> > > share them across VMMs. We may need a way to move in steps in
> > > Qemu to unblock the kernel development toward that end goal, e.g.
> > > first accepting a pasid option plus user-specified offset (if offset
> > > unspecified then auto-pick one in cap holes). Later when the text
> > > file is ready then such per-cap options can be deprecated.  
> > 
> > Planned obsolescence is a hard sell.
> >   
> > > This simple way won't fix the migration issue, but at least it's on
> > > par with physical caps (i.e. fail the migration if offset mismatched
> > > between dest/src) and both will be fixed when the text file model
> > > is ready.
> > >
> > > Then look at what uAPI is required to report the vPASID cap.
> > >
> > > In earlier discussion it's leaning toward extending GET_HW_INFO
> > > in iommufd given both iommu/pci support are required to get
> > > PASID working and iommu driver will not report such support until
> > > pasid has been enabled in both iommu/pci. With that there is no
> > > need to further report PASID in vfio-pci.
> > >
> > > But there may be other caps which are shared between VF and
> > > PF while having nothing to do with the iommu. e.g. the Device
> > > Serial Number extended cap (permitted but not recommended
> > > in VF). If there is a need to report such cap on VF which doesn't
> > > implement it to userspace, a vfio uAPI (device_feature or a new
> > > one dedicated to synthetical vcap) appears to be inevitable.
> > >
> > > So I wonder whether we leave this part untouched until a real
> > > demand comes or use vpasid to formalize that uAPI to be forward
> > > looking. If in the end such uAPI will exist then it's a bit weird to
> > > have PASID escaped (especially when vfio-pci already reports
> > > PRI/ATS  which have iommu dependency too in vconfig).
> > >
> > > In concept the Qemu logic will be clearer if any PCI caps (real
> > > or synthesized) is always conveyed via vfio-pci while iommufd is
> > > for identifying a viommu cap.  
> > 
> > There are so many moving pieces here and the discussion trailed off a
> > long time ago.  I have trouble keeping all the relevant considerations
> > in my head, so let me try to enumerate them, please correct/add.  
> 
> Thanks for the summary!
> 
> > 
> >  - The PASID capability cannot be implemented on VFs per the PCIe spec.
> >    All VFs share the PF PASID configuration.  This also implies that
> >    the VF PASID capability is essentially emulated since the VF driver
> >    cannot manipulate the PF PASID directly.
> > 
> >  - VFIO does not currently expose the PASID capability for PFs, nor
> >    does anything construct a vPASID capability for VFs.
> > 
> >  - The PASID capability is only useful in combination with a vIOMMU
> >    with PASID support, which does not yet exist in QEMU.
> > 
> >  - Some devices are known to place registers in configuration space,
> >    outside of the capability chains, which historically makes it
> >    difficult to place a purely virtual capability without potentially
> >    masking such hidden registers.  Current virtual capabilities are
> >    placed at vendor defined fixed locations to avoid conflicts.
> > 
> >  - There is some expectation that otherwise compatible devices may
> >    not present identical capability chains, for example devices running
> >    different firmware or devices from different vendors implementing a
> >    standard register ABI (virtio) where capability chain layout is not
> >    standardized.
> > 
> >  - There have been arguments that the layout of device capabilities is
> >    a policy choice, where both the kernel and libvirt traditionally try
> >    to avoid making policy decisions.
> > 
> >  - Seamless live migration of devices requires that configuration space
> >    remains at least consistent, if not identical for much of it.  
> 
> I didn't quite get it. I thought being consistent means fully identical
> config space from guest p.o.v.

See for example:

https://gitlab.com/qemu-project/qemu/-/commit/187716feeba406b5a3879db66a7bafd687472a1f 

The layout of config space and most of the contents therein need to be
identical, but there are arguably elements that could be volatile which
only need to be consistent.

> >    Capability offsets cannot change during live migration.  This leads
> >    to the text file reference above, which is essentially just the
> >    notion that if the VMM defines the capability layout in config
> >    space, it would need to do so via a static reference, independent of
> >    the layout of the physical device and we might want to share that
> >    among multiple VMMs.
> > 
> >  - For a vfio-pci device to support live migration it must be enabled
> >    to do so by a vfio-pci variant driver.
> > 
> >  - We've discussed in the community and seem to have a consensus that a
> >    DVSEC (Designated Vendor Specific Extended Capability) could be
> >    defined to describe unused configuration space.  Such a DVSEC could
> >    be implemented natively by the device or supplied by a vfio-pci
> >    variant driver.  There is currently no definition of such a DVSEC.  
> 
> I'm not sure whether DVSEC is still that necessary if the direction is
> to go userspace-defined layout. In a synthetic world the unused
> physical space doesn't really matter.
> 
> So this consensus IMHO was better placed under the umbrella of
> the other direction having the kernel define the layout.

I agree that we don't seem to be headed in a direction that requires
this, but I just wanted to include that there was a roughly agreed upon
way for devices and variant drivers to annotate unused config space
ranges for higher levels.  If we head in a direction where the VMM
chooses an offset for the PASID capability, we need to keep track of
whether this DVSEC comes to fruition and how that affects the offset
that QEMU might choose.

> > So what are we trying to accomplish here.  PASID is the first
> > non-device specific virtual capability that we'd like to insert into
> > the VM view of the capability chain.  It won't be the last.
> > 
> >  - Do we push the policy of defining the capability offset to the user?  
> 
> Looks yes as I didn't see a strong argument for the opposite way.

It's a policy choice though, so where and how is it implemented?  It
works fine for those of us willing to edit xml or launch VMs by command
line, but libvirt isn't going to sign up to insert a policy choice for
a device.  If we get to even higher level tools, does anything that
wants to implement PASID support required a vendor operator driver to
make such policy choices (btw, I'm just throwing out the "operator"
term as if I know what it means, I don't).

> >  - Do we do some hand waving that devices supporting PASID shouldn't
> >    have hidden registers and therefore the VMM can simply find a gap?  
> 
> I assume 'handwaving' doesn't mean any measure in code to actually
> block those devices (as doing so likely requires certain denylist based on
> device/vendor ID but then why not going a step further to also hard
> code an offset?). It's more a try-and-fail model where vPASID is opted
> in via a cmdline parameter then a device with hidden registers may
> misbehave if the VMM happens to find a conflict gap. And the impact
> is restricted only to a new setup where the user is interested in
> PASID  to opt hence can afford diagnostics effort to figure out the restriction.

If you want to hard code an offset then we're effectively introducing a
device specific quirk to enable PASID support.  I thought we wanted
this to work generically for any device exposing PASID, therefore I was
thinking more of "find a gap" as the default strategy with quirks used
to augment the resulting offset where necessary.

I'd also be careful about command line parameters.  I think we require
one for the vIOMMU to enable PASID support, but I'd prefer to avoid one
on the vfio-pci device, instead simply enabling support when both the
vIOMMU support is enabled and the device is detected to support it.
Each command line option requires support in the upper level tools to
enable it.

> >  - Do we ask the hardware vendor or variant driver to insert a DVSEC to
> >    identify available config space?  
> 
> As said I don't think it's necessary if leaving the policy to the user

Leaving the policy to the user is essentially just kicking the can down
the road and I don't know where that policy actually gets implemented
in a cloud, production environment.  I think it would align with QEMU
practices if the user could override a default policy on the command
line, but ultimately if we want to keep the policy decision out of the
kernel then the defaults probably need to be implemented in QEMU.

> >  - Do we handle this as just another device quirk, where we maintain a
> >    table of supported devices and vPASID offset for each?
> > 
> >  - Do we consider this an inflection point where the VMM entirely takes
> >    over the layout of the capability spaces to impose a stable
> >    migration layout?  On what basis do we apply that inflection?
> > 
> >  - Also, do we require the same policy for both standard and extended
> >    capability chains?  
> 
> suppose yes.
> 
> > 
> > I understand the desire to make some progress, but QEMU relies on
> > integration with management tools, so a temporary option for a user to
> > specify a PASID offset in isolation sounds like a non-starter to me.
> > 
> > This might be a better sell if the user interface allowed fully
> > defining the capability chain layout from the command line and this
> > interface would continue to exist and supersede how the VMM might
> > otherwise define the capability chain when used.  A fully user defined
> > layout would be complicated though, so I think there would still be a
> > desire for QEMU to consume or define a consistent policy itself.
> > 
> > Even if QEMU defines the layout for a device, there may be multiple
> > versions of that device.  For example, maybe we just add PASID now, but
> > at some point we decide that we do want to replicate the PF serial
> > number capability.  At that point we have versions of the device which
> > would need to be tied to versions of the machine and maybe also
> > selected via a profile switch on the device command line.
> > 
> > If we want to simplify this, maybe we do just look at whether the
> > vIOMMU is configured for PASID support and if the device supports it,  
> 
> and this is related to the open which I raised in last mail - whether we
> want to report the PASID support both in iommufd and vfio-pci uAPI.
> 
> My impression is yes as there may be requirement of exposing a virtual
> capability which doesn't rely on the IOMMU.

What's the purpose of reporting PASID via both iommufd and vfio-pci?  I
agree that there will be capabilities related to the iommufd and
capabilities only related to the device, but I disagree that that
provides justification to report PASID via both uAPIs.  Are we also
going to ask iommufd to report that a device has an optional serial
number capability?  It clearly doesn't make sense for iommufd to be
involved with that, so why does it make sense for vfio-pci to be
involved in reporting something that is more iommufd specific?

> > then we just look for a gap and add the capability.  If we end up with
> > different results between source and target for migration, then
> > migration will fail.  Possibly we end up with a quirk table to override
> > the default placement of specific capabilities on specific devices.  
> 
> emm how does a quirk table work with devices having volatile config
> space layout cross FW versions? Can VMM assigned with a VF be able
> to check the FW version of the PF?

If the VMM can't find the same gap between source and destination then
a quirk could make sure that the PASID offset is consistent.  But also
if the VMM doesn't find the same gap then that suggests the config
space is already different and not only the offset of the PASID
capability will need to be fixed via a quirk, so then we're into
quirking the entire capability space for the device.

The VMM should not be assumed to have any additional privileges beyond
what we provide it through the vfio device and iommufd interface.
Testing anything about the PF would require access on the host that
won't work in more secure environments.  Therefore if we can't
consistently place the PASID for a device, we probably need to quirk it
based on the vendor/device IDs or sub-IDs or we need to rely on a
management implied policy such as a device profile option on the QEMU
command line or maybe different classes of the vfio-pci driver in QEMU.

> > That might evolve into a lookup for where we place all capabilities,
> > which essentially turns into the "file" where the VMM defines the entire
> > layout for some devices.  
> 
> Overall this sounds a feasible path to move forward - starting with
> the VMM to find the gap automatically if a new PASID option is
> opted in. Devices with hidden registers may fail. Devices with volatile
> config space due to FW upgrade or cross vendors may fail to migrate.
> Then evolving it to the file-based scheme, and there is time to discuss
> any intermediate improvement (fixed quirks, cmdline offset, etc.) in
> between.

As above, let's be careful about introducing unnecessary command line
options, especially if we expect support for them in higher level
tools.  If we place the PASID somewhere that makes the device not work,
then disabling PASID on the vIOMMU should resolve that.  It won't be a
regression, it will only be an incompatibility with a new feature.
That incompatibility may require a quirk to resolve to have the PASID
placed somewhere else.  If the PASID is placed at different offsets
based on device firmware or vendor then the location of the PASID alone
isn't the only thing preventing migration and we'll need to introduce
code for the VMM to take ownership of the capability layout at that
point.  Thanks,

Alex


