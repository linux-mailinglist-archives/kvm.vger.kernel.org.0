Return-Path: <kvm+bounces-15169-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF6738AA41A
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 22:38:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9FFE82821B6
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 20:38:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58D78190661;
	Thu, 18 Apr 2024 20:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cBAbLwMf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7A22E416
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 20:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713472675; cv=none; b=KsfRmmOqz+RUxv2ltFVYVyZrKrn6r5DReZEQ7UqobRDZ6m4+F3s5QtXXNi6qaZPlz4TRXU0Z9H9vs9OTC6rwNsI4XbLks+8DwzGBnLfV3DsOd/n3XyN8i3zgspxeqO6R+KjOO5KFb9bpLUB4LlfymaGaUZdmA8LUJsR5DI0LE8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713472675; c=relaxed/simple;
	bh=9rCCdJIOXGK5mMIJxWx6y9XaXwhCfvryMYkeNkglHYg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E4zhdjo40h6FAiumI2fydp4f6qGUyqFnxbfOXmxHlUwpKC/m8IkJWqQ5iTNJfgaSsu7eVPwtXfY1aDl+d5AUyyj2XmEXp4MI+Duko+9HDW/rUNdoJrBX59HDE76xAByvv2T/8V2XmXNyS4qVcZpUjRVn+Xril85BKyek9rmCCXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cBAbLwMf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713472672;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pn2/BXHQsJTtbsxPcLAeb1M670ku7QSTpIAaDmdaDfE=;
	b=cBAbLwMfNQG0lQbG9fmV5FHxM6dXz6p5JT2/b7wnj4xgl1s5g63HRRhIVGs/gfmeig0VoW
	qhUHJbUxvYul6sHawvn/EaYPj2vQ24SwRtPUKLcfmDsEOPNXXUhtPQKMEjSlVZsUb8OfVr
	mnfIgoDjldh5Dj6fPh4KVQQmQp/PVxA=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-333-FXowgnq1MB6z7JmuHgcuzw-1; Thu, 18 Apr 2024 16:37:51 -0400
X-MC-Unique: FXowgnq1MB6z7JmuHgcuzw-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-36b34b3a5fdso16619745ab.0
        for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 13:37:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713472670; x=1714077470;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pn2/BXHQsJTtbsxPcLAeb1M670ku7QSTpIAaDmdaDfE=;
        b=HaBa4cS5ytU7JpLRGaGT4IE3B51CXofyvPs9YDe4cchWL/UIdU7PEDDn8PHKlIOQEQ
         9lhkEwKgUq06eZ4dbEAybid6KfSkEifEfsvukKOxyoO2syXuQrIyQJh9Sv1+nVrK7jRF
         2yxPVwOoVWJHWys+RV/EGlQWdJRlTG/pZdx198E7y7AiUluv0LCqMqWDjSLWmDZVnIoJ
         MfNAdGaZLDvAf+t+Y77IMn+YG/KO0PHxMx1ZDfa/4Y4nYdTlR390UDcRfgy40NEIn1yn
         AjbIlH7eHZwDdWiyTSRiZDBeGMQ1cqMBNWZ0oiB4riuMWiy/HV9QuKpFd+BSUf1ECfpD
         6n+A==
X-Forwarded-Encrypted: i=1; AJvYcCXGMJ9iRkuVCKexSv/L+reP56W2JZ7uTKRjyVYO6VhXGPwQ7t8klpjsi19h9sfJ2MeYpj2xhK22zYducS0gVQ+XaPjw
X-Gm-Message-State: AOJu0YzJ6IRuCPsN+M5P4xBD94kSSyeJTd0j5AEG6YEYNTNbKzo40/DE
	0StFkmmHI6jtbGnW40pZMRuwUWS1gNfLD6URQ7HZZz9S/fAoKgdjitEivPNmeXSUNFf7tpwqD8R
	NUlhmsBJBa5rvKplGE3HneIwrsqYF4MiwHgWk+YYvA7zlNFvqHg==
X-Received: by 2002:a05:6e02:1a28:b0:36b:2c7d:cd91 with SMTP id g8-20020a056e021a2800b0036b2c7dcd91mr306698ile.25.1713472670672;
        Thu, 18 Apr 2024 13:37:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF1WTU9ZaZTA/+3VejLlx0uNmpHA2zKOaPH8HbGoZrE1W44hFuolUWSTZ3FJje7EeKvr4YJ3A==
X-Received: by 2002:a05:6e02:1a28:b0:36b:2c7d:cd91 with SMTP id g8-20020a056e021a2800b0036b2c7dcd91mr306682ile.25.1713472670299;
        Thu, 18 Apr 2024 13:37:50 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id y26-20020a056638015a00b004829428d517sm633977jao.63.2024.04.18.13.37.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Apr 2024 13:37:49 -0700 (PDT)
Date: Thu, 18 Apr 2024 14:37:47 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 "joro@8bytes.org" <joro@8bytes.org>, "robin.murphy@arm.com"
 <robin.murphy@arm.com>, "eric.auger@redhat.com" <eric.auger@redhat.com>,
 "nicolinc@nvidia.com" <nicolinc@nvidia.com>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
 <chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
 <iommu@lists.linux.dev>, "baolu.lu@linux.intel.com"
 <baolu.lu@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
 "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: Re: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Message-ID: <20240418143747.28b36750.alex.williamson@redhat.com>
In-Reply-To: <4037d5f4-ae6b-4c17-97d8-e0f7812d5a6d@intel.com>
References: <20240412082121.33382-1-yi.l.liu@intel.com>
	<BN9PR11MB5276318EF2CD66BEF826F59A8C082@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240416175018.GJ3637727@nvidia.com>
	<BN9PR11MB5276E6975F78AE96F8DEC66D8C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240417122051.GN3637727@nvidia.com>
	<20240417170216.1db4334a.alex.williamson@redhat.com>
	<BN9PR11MB52765314C4E965D4CEADA2178C0E2@BN9PR11MB5276.namprd11.prod.outlook.com>
	<4037d5f4-ae6b-4c17-97d8-e0f7812d5a6d@intel.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 18 Apr 2024 17:03:15 +0800
Yi Liu <yi.l.liu@intel.com> wrote:

> On 2024/4/18 08:06, Tian, Kevin wrote:
> >> From: Alex Williamson <alex.williamson@redhat.com>
> >> Sent: Thursday, April 18, 2024 7:02 AM
> >>
> >> On Wed, 17 Apr 2024 09:20:51 -0300
> >> Jason Gunthorpe <jgg@nvidia.com> wrote:
> >>  
> >>> On Wed, Apr 17, 2024 at 07:16:05AM +0000, Tian, Kevin wrote:  
> >>>>> From: Jason Gunthorpe <jgg@nvidia.com>
> >>>>> Sent: Wednesday, April 17, 2024 1:50 AM
> >>>>>
> >>>>> On Tue, Apr 16, 2024 at 08:38:50AM +0000, Tian, Kevin wrote:  
> >>>>>>> From: Liu, Yi L <yi.l.liu@intel.com>
> >>>>>>> Sent: Friday, April 12, 2024 4:21 PM
> >>>>>>>
> >>>>>>> A userspace VMM is supposed to get the details of the device's  
> >> PASID  
> >>>>>>> capability
> >>>>>>> and assemble a virtual PASID capability in a proper offset in the  
> >> virtual  
> >>>>> PCI  
> >>>>>>> configuration space. While it is still an open on how to get the  
> >> available  
> >>>>>>> offsets. Devices may have hidden bits that are not in the PCI cap  
> >> chain.  
> >>>>> For  
> >>>>>>> now, there are two options to get the available offsets.[2]
> >>>>>>>
> >>>>>>> - Report the available offsets via ioctl. This requires device-specific  
> >> logic  
> >>>>>>>    to provide available offsets. e.g., vfio-pci variant driver. Or may the  
> >>>>> device  
> >>>>>>>    provide the available offset by DVSEC.
> >>>>>>> - Store the available offsets in a static table in userspace VMM.  
> >> VMM gets  
> >>>>> the  
> >>>>>>>    empty offsets from this table.
> >>>>>>>  
> >>>>>>
> >>>>>> I'm not a fan of requesting a variant driver for every PASID-capable
> >>>>>> VF just for the purpose of reporting a free range in the PCI config  
> >> space.  
> >>>>>>
> >>>>>> It's easier to do that quirk in userspace.
> >>>>>>
> >>>>>> But I like Alex's original comment that at least for PF there is no  
> >> reason  
> >>>>>> to hide the offset. there could be a flag+field to communicate it. or
> >>>>>> if there will be a new variant VF driver for other purposes e.g.  
> >> migration  
> >>>>>> it can certainly fill the field too.  
> >>>>>
> >>>>> Yes, since this has been such a sticking point can we get a clean
> >>>>> series that just enables it for PF and then come with a solution for
> >>>>> VF?
> >>>>>  
> >>>>
> >>>> sure but we at least need to reach consensus on a minimal required
> >>>> uapi covering both PF/VF to move forward so the user doesn't need
> >>>> to touch different contracts for PF vs. VF.  
> >>>
> >>> Do we? The situation where the VMM needs to wholly make a up a PASID
> >>> capability seems completely new and seperate from just using an
> >>> existing PASID capability as in the PF case.  
> >>
> >> But we don't actually expose the PASID capability on the PF and as
> >> argued in path 4/ we can't because it would break existing userspace.
> > > Come back to this statement.  
> > 
> > Does 'break' means that legacy Qemu will crash due to a guest write
> > to the read-only PASID capability, or just a conceptually functional
> > break i.e. non-faithful emulation due to writes being dropped?

I expect more the latter.

> > If the latter it's probably not a bad idea to allow exposing the PASID
> > capability on the PF as a sane guest shouldn't enable the PASID
> > capability w/o seeing vIOMMU supporting PASID. And there is no
> > status bit defined in the PASID capability to check back so even
> > if an insane guest wants to blindly enable PASID it will naturally
> > write and done. The only niche case is that the enable bits are
> > defined as RW so ideally reading back those bits should get the
> > latest written value. But probably this can be tolerated?

Some degree of inconsistency is likely tolerated, the guest is unlikely
to check that a RW bit was set or cleared.  How would we virtualize the
control registers for a VF and are they similarly virtualized for a PF
or would we allow the guest to manipulate the physical PASID control
registers?

> > With that then should we consider exposing the PASID capability
> > in PCI config space as the first option? For PF it's simple as how
> > other caps are exposed. For VF a variant driver can also fake the
> > PASID capability or emulate a DVSEC capability for unused space
> > (to motivate the physical implementation so no variant driver is
> > required in the future)  
> 
> If kernel exposes pasid cap for PF same as other caps, and in the meantime
> the variant driver chooses to emulate a DVSEC cap, then userspace follows
> the below steps to expose pasid cap to VM.

If we have a variant driver, why wouldn't it expose an emulated PASID
capability rather than a DVSEC if we're choosing to expose PASID for
PFs?

> 
> 1) Check if a pasid cap is already present in the virtual config space
>     read from kernel. If no, but user wants pasid, then goto step 2).
> 2) Userspace invokes VFIO_DEVICE_FETURE to check if the device support
>     pasid cap. If yes, goto step 3).

Why do we need the vfio feature interface if a physical or virtual PASID
capability on the device exposes the same info?

> 3) Userspace gets an available offset via reading the DVSEC cap.

What's the scenario where we'd have a VF wanting to expose PASID
support which doesn't also have a variant driver that could implement a
virtual PASID?

> 4) Userspace assembles a pasid cap and inserts it to the vconfig space.
> 
> For PF, step 1) is enough. For VF, it needs to go through all the 4 steps.
> This is a bit different from what we planned at the beginning. But sounds
> doable if we want to pursue the staging direction.

Seems like if we decide that we can just expose the PASID capability
for a PF then we should just have any VF variant drivers also implement
a virtual PASID capability.  In this case DVSEC would only be used to
provide information for a purely userspace emulation of PASID (in which
case it also wouldn't necessarily need the vfio feature because it
might implicitly know the PASID capabilities of the device).  Thanks,

Alex


