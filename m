Return-Path: <kvm+bounces-15868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E5B368B1448
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 22:14:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5DDCF1F273A0
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 20:14:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79D3D143C56;
	Wed, 24 Apr 2024 20:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a1yJNLno"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E552C143C4D
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 20:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713989636; cv=none; b=QZy6uJMoQIXEN2KnPUztN2hq/B6FhKwl76fAeie0hTU/R3R9XDe89YcD3rr/QfH0egCoBYe8UisYgrk4LR4X/j01JsJhOkgc/7b8riQp8eSRevmGEll8cCaswx6WTSHbYtRS7rPtx9K200s1T92t/VmnXaka//lrzXzosenxaMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713989636; c=relaxed/simple;
	bh=AM1q6e73KfmGBdEpYzRzuKvNqC08OTjFdLkVMj9unpk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=adwrnE7V9mFKudyXjIwF+fueP+7MA+MYuxstLeuFaEEiThCnPaBa6eDljMj6PxWKaVeO3uARVFDyR43XPGv+4tUKbUruvupCcn629S0JYpux3ebczAPDAmRtcbiFEBzkjxMEcLJSy4qsswu4QcJXLR9dZcHGo+7gnR+nQ6pK4J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a1yJNLno; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713989633;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J0pNSJhCUzRQ+iJ8HncGThgziJwiZ06q3YEsIpOB3KY=;
	b=a1yJNLno0Ei0i5gCBM8ug4Sv+ZIzF8sJ/w9e1o/F+CkwbYBreBx41ibCjauXESWCrLiQgO
	uqn+Go6FWl3ZTaiiRcwFMITOpinI0c4g6DJbY9J7l5n9mQVyoolHc/qswr56srROz5B3Ue
	dOMGjT2vQQ0jo8CTPutU52mZHGB2i7Y=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-6pygKUkrMSGGE3dt0KiqSQ-1; Wed, 24 Apr 2024 16:13:52 -0400
X-MC-Unique: 6pygKUkrMSGGE3dt0KiqSQ-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-36afb9ef331so3258835ab.1
        for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 13:13:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713989631; x=1714594431;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J0pNSJhCUzRQ+iJ8HncGThgziJwiZ06q3YEsIpOB3KY=;
        b=Xz47vKkZIeeytrmtmGtgCg7yx62Yt595b+/L7jdjkySyD+kqOtqa9E6ZY//6L3566A
         1Z0MG0X8gli+WQNdA5r6K62l0Nprj3mBF2VZA9BT6gieQDWBvQqPNCObtvjdZ7LxgQ/h
         adS8MzTlrrCEeKgNVBOrgD5C3Yc43ppROUjwWIR8xd9jY8FNzDt/gRXXBaNgfQfQUwyl
         fpNOjDDIfOBD0HDSjuQUtScb9Za0oqcKM8hPCvV05eglQfiZTGkOVt3cFVkot+ErOO23
         zniPgYyTax//pzpao967o/GGhaoXhbW4s75GnOQjH/oK1PwpdoFJkVtOsidzI9tFMyMW
         Qsbg==
X-Forwarded-Encrypted: i=1; AJvYcCXymcFiM4WEArqRNbbpQT1s95t1IYURzBfAr8yQU0X3mvNsmWE5ay7wMgHR3rk3j9tVerf8dSDwQRDaL/LibTCeol4C
X-Gm-Message-State: AOJu0YxS7sYkVf4jkNpVRkk13lf3VIul07doQLTlmDx3V4NJYzi6ksQn
	pNJlwp6xZpVm401ZlFPdhSn4ctU71+QoS613y7bLye5R8qvYKeRFUmB5IjROHLsH2mkPAZFgG3S
	+KSFBJpUhnAn3CpUzoNB1/aW6rWNB15ImsYd5DDpYGNmi5d2Hng==
X-Received: by 2002:a05:6e02:19c9:b0:36a:ff03:d2c9 with SMTP id r9-20020a056e0219c900b0036aff03d2c9mr4276965ill.8.1713989631728;
        Wed, 24 Apr 2024 13:13:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEckZt9UvEa5gTTmD8N8zTvp3UVH5oTkGXMywYgKCDGgilCVq6OCUSNQTabnQn/JK0k+rvc8g==
X-Received: by 2002:a05:6e02:19c9:b0:36a:ff03:d2c9 with SMTP id r9-20020a056e0219c900b0036aff03d2c9mr4276946ill.8.1713989631405;
        Wed, 24 Apr 2024 13:13:51 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id x5-20020a056638160500b00484f72550ccsm3167420jas.174.2024.04.24.13.13.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Apr 2024 13:13:50 -0700 (PDT)
Date: Wed, 24 Apr 2024 14:13:49 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>,
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
Message-ID: <20240424141349.376bdbf9.alex.williamson@redhat.com>
In-Reply-To: <20240424183626.GT941030@nvidia.com>
References: <BN9PR11MB52765314C4E965D4CEADA2178C0E2@BN9PR11MB5276.namprd11.prod.outlook.com>
	<4037d5f4-ae6b-4c17-97d8-e0f7812d5a6d@intel.com>
	<20240418143747.28b36750.alex.williamson@redhat.com>
	<BN9PR11MB5276819C9596480DB4C172228C0D2@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240419103550.71b6a616.alex.williamson@redhat.com>
	<BN9PR11MB52766862E17DF94F848575248C112@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240423120139.GD194812@nvidia.com>
	<BN9PR11MB5276B3F627368E869ED828558C112@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240424001221.GF941030@nvidia.com>
	<20240424122437.24113510.alex.williamson@redhat.com>
	<20240424183626.GT941030@nvidia.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 24 Apr 2024 15:36:26 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Apr 24, 2024 at 12:24:37PM -0600, Alex Williamson wrote:
> > > The only reason to pass the PF's PASID cap is to give free space to
> > > the VMM. If we are saying that gaps are free space (excluding a list
> > > of bad devices) then we don't acutally need to do that anymore.  
> > 
> > Are we saying that now??  That's new.  
> 
> I suggested it a few times
> 
> >   
> > > VMM will always create a synthetic PASID cap and kernel will always
> > > suppress a real one.
> > > 
> > > An iommufd query will indicate if the vIOMMU can support vPASID on
> > > that device.
> > > 
> > > Same for all the troublesome non-physical caps.
> > >   
> > > > > There are migration considerations too - the blocks need to be
> > > > > migrated over and end up in the same place as well..    
> > > > 
> > > > Can you elaborate what is the problem with the kernel emulating
> > > > the PASID cap in this consideration?    
> > > 
> > > If the kernel changes the algorithm, say it wants to do PASID, PRI,
> > > something_new then it might change the layout
> > > 
> > > We can't just have the kernel decide without also providing a way for
> > > userspace to say what the right layout actually is. :\  
> > 
> > The capability layout is only relevant to migration, right?    
> 
> Yes, proabbly
> 
> > A variant
> > driver that supports migration is a prerequisite and would also be
> > responsible for exposing the PASID capability.  This isn't as disjoint
> > as it's being portrayed.  
> 
> I guess..  But also not quite. We still have the problem that kernel
> migration driver V1 could legitimately create a different config space
> that migration driver V2
> 
> And now you are saying that the migration driver has to parse the
> migration stream and readjust its own layout
> 
> And every driver needs to do this?
> 
> We can, it is a quite big bit of infrastructure I think, but sure..
> 
> I fear the VMM still has to be involved somehow because it still has
> to know if the source VMM has removed any kernel created caps.

This is kind of an absurd example to portray as a ubiquitous problem.
Typically the config space layout is a reflection of hardware whether
the device supports migration or not.  If a driver were to insert a
virtual capability, then yes it would want to be consistent about it if
it also cares about migration.  If the driver needs to change the
location of a virtual capability, problems will arise, but that's also
not something that every driver needs to do.

Also, how exactly does emulating the capability in the VMM solve this
problem?  Currently QEMU migration simply applies state to an identical
VM on the target.  QEMU doesn't modify the target VM to conform to the
data stream.  So in either case, the problem might be more along the
lines of how to make a V1 device from a V2 driver, which is more the
device type/flavor/persona problem.

> > Outside of migration, what does it matter if the cap layout is
> > different?  A driver should never hard code the address for a
> > capability.  
> 
> Yes, talking about migration here - migration is the hardest case it
> seems.
>  
> > > At least if the VMM is doing this then the VMM can include the
> > > information in its migration scheme and use it to recreate the PCI
> > > layout withotu having to create a bunch of uAPI to do so.  
> > 
> > We're again back to migration compatibility, where again the capability
> > layout would be governed by the migration support in the in-kernel
> > variant driver.  Once migration is involved the location of a PASID
> > shouldn't be arbitrary, whether it's provided by the kernel or the VMM.  
> 
> I wasn't going in this direction. I was thinking to make the VMM
> create the config space layout that is approriate and hold it stable
> as a migration ABI.
> 
> I think in practice many VMMs are going to do this anyhow unless we
> put full support for config space synthesis, stable versions, and
> version selection in the kernel directly. I was thinking to avoid
> doing that.

Currently QEMU replies on determinism that a given command line results
in an identical machine configuration and identical devices.  State of
that target VM is then populated, not defined by, the migration stream.

> > Regardless, the VMM ultimately has the authority what the guest
> > sees in config space.  The VMM is not bound to expose the PASID at the
> > offset provided by the kernel, or bound to expose it at all.  The
> > kernel exposed PASID can simply provide an available location and set
> > of enabled capabilities.   
> 
> And if the VMM is going to ignore the kernel layout then why do so
> much work in the kernel to create it?

Ok, let's not ignore it ;)

> I think we need to decide, either only the VMM or only the kernel
> should do this.

What are you actually proposing?  Are you suggesting that if a device
supports the Power Management capability it will be virtualized at
offset 0x60, if the device supports the MSI capability it will be
virtualized at 0x68,... if a device supports PASID it will be
virtualized at offset 0x300, etc...?

That's not only impractical because we can't layout all the capabilities
within the available space, but also because we will run into masking
hidden registers and devices where the driver hard codes a capability
offset.

If the VMM implements the "find a gap" solution then it's just as
subject to config space changes in hardware or provided by the variant
driver.

If not either of those, are we hard coding a device specific config
space map into the VMM or providing one on the command line?  I thought
we were using vfio-pci variant drivers and a defined vfio migration API
in order to prevent modifying the VMM for every device we want to
support migration.  Also I'd wonder if the driver itself shouldn't be
configured to provide a compatible type.  Thanks,

Alex


