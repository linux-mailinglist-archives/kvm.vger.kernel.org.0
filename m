Return-Path: <kvm+bounces-22684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 74863941EE3
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 19:35:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E8FE01F21AC5
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 17:35:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55285189905;
	Tue, 30 Jul 2024 17:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VYDCXo8i"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BB31A76B4
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 17:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360926; cv=none; b=ozRVMUTTVfH/Oo+Wpm22ncz6AoKw+d4jCseesT/RqE8TWN9afWwn6FucRswW4tUVSsD4VyHm43P3MMZmmfCPJgBr3VFIT1xZzhMNS+zOVymTA30ZEvdcPOBLwtlaR3wcQhD987/6cr//LOkUH3hnc/7Huuv2Shjken3FMipziSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360926; c=relaxed/simple;
	bh=kaHR19k0/F/oLlfNxYx6jh9dp6SYMsv+JIi44ubapSI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=knojSHjnva1Gj7o4pc6vrvx9IEXksATpwSpEKl7T0x40traq4y1Y+QzVW8UiNTXePEwtoHN8qJBiirMaYqMtUaO7Qeda5NfxCIBQZwiEyGPMbV6M0fiv8T19BgpjfvFNvOYG9rhlfr0nwYALB2uZRT2u3ZkJ76LL71IslGcqZy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VYDCXo8i; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722360923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JGvvLnyHosynzU4qCCDWzexJdT4L2I6G7pAHyddJSVE=;
	b=VYDCXo8iDQDUNZdB/gMIJK/82olrsv3KGks8j/4LIrk/9LA3aZzEnsqcwucDZn07/EorLS
	D+UGRb6/ZSSrqj2QMxZC0GaO8wrNZu3zbfeOXhDAcWXQvEtxvZZig+J/iMRiTYE7wbDqMO
	clY9x/aNgQyfL29KjIpT7lvoSo6/VXY=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-lZaxWa2nOtikkVhdI2DyQQ-1; Tue, 30 Jul 2024 13:35:22 -0400
X-MC-Unique: lZaxWa2nOtikkVhdI2DyQQ-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-81f968e53b0so554873839f.1
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 10:35:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722360921; x=1722965721;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JGvvLnyHosynzU4qCCDWzexJdT4L2I6G7pAHyddJSVE=;
        b=MN2KpgJYiVloh78RVhpJtsPYW7Sap/nZQQ+Wtu75KYR3zwGYbZc78Zo7ZKkYZmff0n
         O6C4BOzOLglN4YUcTHx4QGO5l/Rz5+3Q05ahUBmwQ1J7DFtSg9WpmBmQrUdhRQoZNcpx
         VpC5cxolkBhUUW7m/n+wUh46lqJW1mfMkFwvJoDoVR05Dxk9qZ/kmdT0h9A799mdh6rW
         maKypq+ANlXb+uKRNaOVMXd63lWX8nV9M1Qlcha+SYHN73rR/rX57OFBIxFbdzL/2QjX
         jQ1WHvAzjmhwOOjw27MXaJtEw3tiS05b9jgrTK9HZ6X6+sX/MUOjSFU917oZQbHWgR2l
         n73w==
X-Forwarded-Encrypted: i=1; AJvYcCWwe0NBzTCX1PSnhG8Y993VstlqDstJHIzlItOWWN3Vz7L5Ggsq+ubJIkib4Y+Y+PiTBf2gGTEX9ag6iwBo2olkDZaG
X-Gm-Message-State: AOJu0Yzl5aW0JDyoPk2oVIwad4rFwI/gIRog+D3GbO98S+sx3h+ElPnd
	h0DIvDihxxK+ElcVx1+1fFtpAfdnYuRVGJNex/hBRg32a+M1yIyMixqtlVL9UdR8dIo5V+2rp55
	i4rxbn1x+KMZHvYeLCqhjOQUc1IBuQInwNdI7z3s03IL7UziDxg==
X-Received: by 2002:a05:6602:6b8c:b0:7f6:8650:9684 with SMTP id ca18e2360f4ac-81f95a478bamr1579929839f.5.1722360921399;
        Tue, 30 Jul 2024 10:35:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHgpSmEalpua89Fpxw1wV639nT7n76zuIKZpMFI5rYYGWUEnZ2dK1ruqZiSANyryCDBNwUBow==
X-Received: by 2002:a05:6602:6b8c:b0:7f6:8650:9684 with SMTP id ca18e2360f4ac-81f95a478bamr1579927739f.5.1722360920971;
        Tue, 30 Jul 2024 10:35:20 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-81f7d74d59csm361138139f.22.2024.07.30.10.35.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jul 2024 10:35:20 -0700 (PDT)
Date: Tue, 30 Jul 2024 11:35:17 -0600
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
Message-ID: <20240730113517.27b06160.alex.williamson@redhat.com>
In-Reply-To: <BN9PR11MB5276C4EF3CFB6075C7FC60AC8CAA2@BN9PR11MB5276.namprd11.prod.outlook.com>
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
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 24 Jul 2024 02:26:20 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, April 30, 2024 1:45 AM
> > 
> > On Fri, Apr 26, 2024 at 02:13:54PM -0600, Alex Williamson wrote:  
> > > Regarding "if we accept that text file configuration should be
> > > something the VMM supports", I'm not on board with this yet, so
> > > applying it to PASID discussion seems premature.  
> > 
> > Sure, I'm just explaining a way this could all fit together.
> >   
> 
> Thinking more along this direction.
> 
> I'm not sure how long it will take to standardize such text files and
> share them across VMMs. We may need a way to move in steps in
> Qemu to unblock the kernel development toward that end goal, e.g.
> first accepting a pasid option plus user-specified offset (if offset
> unspecified then auto-pick one in cap holes). Later when the text
> file is ready then such per-cap options can be deprecated.

Planned obsolescence is a hard sell.

> This simple way won't fix the migration issue, but at least it's on
> par with physical caps (i.e. fail the migration if offset mismatched
> between dest/src) and both will be fixed when the text file model
> is ready.
> 
> Then look at what uAPI is required to report the vPASID cap.
> 
> In earlier discussion it's leaning toward extending GET_HW_INFO
> in iommufd given both iommu/pci support are required to get
> PASID working and iommu driver will not report such support until
> pasid has been enabled in both iommu/pci. With that there is no
> need to further report PASID in vfio-pci.
> 
> But there may be other caps which are shared between VF and
> PF while having nothing to do with the iommu. e.g. the Device
> Serial Number extended cap (permitted but not recommended
> in VF). If there is a need to report such cap on VF which doesn't
> implement it to userspace, a vfio uAPI (device_feature or a new
> one dedicated to synthetical vcap) appears to be inevitable.
> 
> So I wonder whether we leave this part untouched until a real
> demand comes or use vpasid to formalize that uAPI to be forward
> looking. If in the end such uAPI will exist then it's a bit weird to
> have PASID escaped (especially when vfio-pci already reports
> PRI/ATS  which have iommu dependency too in vconfig).
> 
> In concept the Qemu logic will be clearer if any PCI caps (real
> or synthesized) is always conveyed via vfio-pci while iommufd is
> for identifying a viommu cap.

There are so many moving pieces here and the discussion trailed off a
long time ago.  I have trouble keeping all the relevant considerations
in my head, so let me try to enumerate them, please correct/add.

 - The PASID capability cannot be implemented on VFs per the PCIe spec.
   All VFs share the PF PASID configuration.  This also implies that
   the VF PASID capability is essentially emulated since the VF driver
   cannot manipulate the PF PASID directly.

 - VFIO does not currently expose the PASID capability for PFs, nor
   does anything construct a vPASID capability for VFs.

 - The PASID capability is only useful in combination with a vIOMMU
   with PASID support, which does not yet exist in QEMU.

 - Some devices are known to place registers in configuration space,
   outside of the capability chains, which historically makes it
   difficult to place a purely virtual capability without potentially
   masking such hidden registers.  Current virtual capabilities are
   placed at vendor defined fixed locations to avoid conflicts.

 - There is some expectation that otherwise compatible devices may
   not present identical capability chains, for example devices running
   different firmware or devices from different vendors implementing a
   standard register ABI (virtio) where capability chain layout is not
   standardized.

 - There have been arguments that the layout of device capabilities is
   a policy choice, where both the kernel and libvirt traditionally try
   to avoid making policy decisions.

 - Seamless live migration of devices requires that configuration space
   remains at least consistent, if not identical for much of it.
   Capability offsets cannot change during live migration.  This leads
   to the text file reference above, which is essentially just the
   notion that if the VMM defines the capability layout in config
   space, it would need to do so via a static reference, independent of
   the layout of the physical device and we might want to share that
   among multiple VMMs.

 - For a vfio-pci device to support live migration it must be enabled
   to do so by a vfio-pci variant driver.

 - We've discussed in the community and seem to have a consensus that a
   DVSEC (Designated Vendor Specific Extended Capability) could be
   defined to describe unused configuration space.  Such a DVSEC could
   be implemented natively by the device or supplied by a vfio-pci
   variant driver.  There is currently no definition of such a DVSEC.

So what are we trying to accomplish here.  PASID is the first
non-device specific virtual capability that we'd like to insert into
the VM view of the capability chain.  It won't be the last.

 - Do we push the policy of defining the capability offset to the user?

 - Do we do some hand waving that devices supporting PASID shouldn't
   have hidden registers and therefore the VMM can simply find a gap?

 - Do we ask the hardware vendor or variant driver to insert a DVSEC to
   identify available config space?

 - Do we handle this as just another device quirk, where we maintain a
   table of supported devices and vPASID offset for each?

 - Do we consider this an inflection point where the VMM entirely takes
   over the layout of the capability spaces to impose a stable
   migration layout?  On what basis do we apply that inflection?

 - Also, do we require the same policy for both standard and extended
   capability chains?

I understand the desire to make some progress, but QEMU relies on
integration with management tools, so a temporary option for a user to
specify a PASID offset in isolation sounds like a non-starter to me.

This might be a better sell if the user interface allowed fully
defining the capability chain layout from the command line and this
interface would continue to exist and supersede how the VMM might
otherwise define the capability chain when used.  A fully user defined
layout would be complicated though, so I think there would still be a
desire for QEMU to consume or define a consistent policy itself.

Even if QEMU defines the layout for a device, there may be multiple
versions of that device.  For example, maybe we just add PASID now, but
at some point we decide that we do want to replicate the PF serial
number capability.  At that point we have versions of the device which
would need to be tied to versions of the machine and maybe also
selected via a profile switch on the device command line.

If we want to simplify this, maybe we do just look at whether the
vIOMMU is configured for PASID support and if the device supports it,
then we just look for a gap and add the capability.  If we end up with
different results between source and target for migration, then
migration will fail.  Possibly we end up with a quirk table to override
the default placement of specific capabilities on specific devices.
That might evolve into a lookup for where we place all capabilities,
which essentially turns into the "file" where the VMM defines the entire
layout for some devices.

This is already TL;DR, so I'll end with that before I further drowned
the possibility of discussion.  Thanks,

Alex


