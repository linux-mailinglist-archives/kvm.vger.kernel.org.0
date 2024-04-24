Return-Path: <kvm+bounces-15858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 12AF48B1270
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 20:34:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1398BB3016D
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 18:31:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AFE41779B4;
	Wed, 24 Apr 2024 18:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D1nM1wnb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A2E16EC12
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 18:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713983084; cv=none; b=kRROkfvTFQS8R1LSMzLbLcqvDldiE9KhEHMz7P/oBg1uFOAgb9k20oSyFUymOb4xEnZfD1TPLmddRLCY1N+/Qk7u1DJGUFMcajPS3vToB1OOeSHHXp3PB9CuVLmCrnNWJcuKQjM+xbs0yB9bNcx4IDAK1n9MdKHv6AHhH469Pvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713983084; c=relaxed/simple;
	bh=jjC6skZ2GOntTeo2OM26tneWmFhSGk3j+D2cgYiZ87s=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hC4NNDZOAVQy1E9xFqFCAkeXwNMvwRmYmJWkh6uE5BEjv5IDftto70eI3n3zrJLgV5f/92VmQu+nofquxFlc0w0mIz1M0IQx/woQ0qepswzfggJeRCf3ub6QBH6Fale/kBDQ9LpB6TIzjUtAi+Wu2A0XPNC5qj21AlFMV5H8eoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D1nM1wnb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713983082;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FnKq2U3fRDJWPm0C3LVL8dpQqqXexDD8FcFI9Cb/pmo=;
	b=D1nM1wnbyapmG3+ADDmx+kgd0pqCT8Cr1KQnq2ET9UPzLsoU9aR95mg0f4DZQqdmIk/sb8
	In4AVoTSta7ZyXLuETyXOAB478owA7svbN6ALYPwpIKTeFTFR+puNTLU1KsGxQW1MhHNYh
	8HxUmvJwOoD/NZhFzHD3OknS56Q+CF4=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-616-8KYF3GS5P4yakAR2ean1TA-1; Wed, 24 Apr 2024 14:24:40 -0400
X-MC-Unique: 8KYF3GS5P4yakAR2ean1TA-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-36a20206746so1900035ab.3
        for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 11:24:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713983080; x=1714587880;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FnKq2U3fRDJWPm0C3LVL8dpQqqXexDD8FcFI9Cb/pmo=;
        b=qkZ+K/GavRsOdEivKOgfD5SA6oRhG/tP5a05pzR8alKcoYVaHqujTxB55pPbMdjhX+
         nGSaQZLeYqdRXR/rLHV6p3jFlNOjahRKOO7ZW3pqrzMU837q+ElPXnIiVmgAwUjTZsdH
         pyazNV8jac7a0zLjfIAcLT5Bc1ppp6PmE6iKqjZAc/L0AY+oV0iyQSrZZq+0jmelZCrp
         dr3Bpo0py13khhdntP4rYv8aOnp696haGcMRSz8KjNAeA2J7GBSvJSKTMndO1nFDIa+X
         JMq7833SkDgI5Xxy7MUG6YiRwViKecT16FbEnwIjqXs1o+ZfO9CLovIRA8Nb33kJRDNO
         E7YQ==
X-Forwarded-Encrypted: i=1; AJvYcCUYI73B9WiJUdz1sdWnQefVnHJlsx1A7QYRMMsXgiS9gdI4NtV9Qb0ERdR0kAOK7Yjd+a7+sU/SUgVPEwsO/t3Dkno0
X-Gm-Message-State: AOJu0Yy4iEJxPPXHdBsZZsD8ThoXtop8jRkrkusl5IYANgpCSmmrCIsi
	++1bRJwQlBK9eidiQ0tNhj03vQJUTxel9wu4ePwwmMqw2R7aAiabtl6ChtH8pnEW8knCe2EILhp
	5fhUJK6iamFLfaqg9iLsRxLHbMJopQKCyKJBgqJt0qc/r0HOt9A==
X-Received: by 2002:a05:6e02:156e:b0:36b:26df:cce9 with SMTP id k14-20020a056e02156e00b0036b26dfcce9mr4012862ilu.22.1713983079842;
        Wed, 24 Apr 2024 11:24:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGJRE81Lsld2/Anqpcdy+p8VCTYAOTeRxzlkPJx/J4ZyxQS0hy7J4OMpPBrRG+0N7s8o1zMMA==
X-Received: by 2002:a05:6e02:156e:b0:36b:26df:cce9 with SMTP id k14-20020a056e02156e00b0036b26dfcce9mr4012828ilu.22.1713983079458;
        Wed, 24 Apr 2024 11:24:39 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id m7-20020a056638260700b0047bf7a10f23sm4278005jat.170.2024.04.24.11.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Apr 2024 11:24:38 -0700 (PDT)
Date: Wed, 24 Apr 2024 12:24:37 -0600
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
 "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: Re: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Message-ID: <20240424122437.24113510.alex.williamson@redhat.com>
In-Reply-To: <20240424001221.GF941030@nvidia.com>
References: <20240417122051.GN3637727@nvidia.com>
	<20240417170216.1db4334a.alex.williamson@redhat.com>
	<BN9PR11MB52765314C4E965D4CEADA2178C0E2@BN9PR11MB5276.namprd11.prod.outlook.com>
	<4037d5f4-ae6b-4c17-97d8-e0f7812d5a6d@intel.com>
	<20240418143747.28b36750.alex.williamson@redhat.com>
	<BN9PR11MB5276819C9596480DB4C172228C0D2@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240419103550.71b6a616.alex.williamson@redhat.com>
	<BN9PR11MB52766862E17DF94F848575248C112@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240423120139.GD194812@nvidia.com>
	<BN9PR11MB5276B3F627368E869ED828558C112@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240424001221.GF941030@nvidia.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 23 Apr 2024 21:12:21 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Apr 23, 2024 at 11:47:50PM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Tuesday, April 23, 2024 8:02 PM
> > > 
> > > On Tue, Apr 23, 2024 at 07:43:27AM +0000, Tian, Kevin wrote:  
> > > > I'm not sure how userspace can fully handle this w/o certain assistance
> > > > from the kernel.
> > > >
> > > > So I kind of agree that emulated PASID capability is probably the only
> > > > contract which the kernel should provide:
> > > >   - mapped 1:1 at the physical location, or
> > > >   - constructed at an offset according to DVSEC, or
> > > >   - constructed at an offset according to a look-up table
> > > >
> > > > The VMM always scans the vfio pci config space to expose vPASID.
> > > >
> > > > Then the remaining open is what VMM could do when a VF supports
> > > > PASID but unfortunately it's not reported by vfio. W/o the capability
> > > > of inspecting the PASID state of PF, probably the only feasible option
> > > > is to maintain a look-up table in VMM itself and assumes the kernel
> > > > always enables the PASID cap on PF.  
> > > 
> > > I'm still not sure I like doing this in the kernel - we need to do the
> > > same sort of thing for ATS too, right?  
> > 
> > VF is allowed to implement ATS.
> > 
> > PRI has the same problem as PASID.  
> 
> I'm surprised by this, I would have guessed ATS would be the device
> global one, PRI not being per-VF seems problematic??? How do you
> disable PRI generation to get a clean shutdown?
> 
> > > It feels simpler if the indicates if PASID and ATS can be supported
> > > and userspace builds the capability blocks.  
> > 
> > this routes back to Alex's original question about using different
> > interfaces (a device feature vs. PCI PASID cap) for VF and PF.  
> 
> I'm not sure it is different interfaces..
> 
> The only reason to pass the PF's PASID cap is to give free space to
> the VMM. If we are saying that gaps are free space (excluding a list
> of bad devices) then we don't acutally need to do that anymore.

Are we saying that now??  That's new.

> VMM will always create a synthetic PASID cap and kernel will always
> suppress a real one.
> 
> An iommufd query will indicate if the vIOMMU can support vPASID on
> that device.
> 
> Same for all the troublesome non-physical caps.
> 
> > > There are migration considerations too - the blocks need to be
> > > migrated over and end up in the same place as well..  
> > 
> > Can you elaborate what is the problem with the kernel emulating
> > the PASID cap in this consideration?  
> 
> If the kernel changes the algorithm, say it wants to do PASID, PRI,
> something_new then it might change the layout
> 
> We can't just have the kernel decide without also providing a way for
> userspace to say what the right layout actually is. :\

The capability layout is only relevant to migration, right?  A variant
driver that supports migration is a prerequisite and would also be
responsible for exposing the PASID capability.  This isn't as disjoint
as it's being portrayed.

> > Does it talk about a case where the devices between src/dest are
> > different versions (but backward compatible) with different unused
> > space layout and the kernel approach may pick up different offsets
> > while the VMM can guarantee the same offset?  
> 
> That is also a concern where the PCI cap layout may change a bit but
> they are still migration compatible, but my bigger worry is that the
> kernel just lays out the fake caps in a different way because the
> kernel changes.

Outside of migration, what does it matter if the cap layout is
different?  A driver should never hard code the address for a
capability.
 
> At least if the VMM is doing this then the VMM can include the
> information in its migration scheme and use it to recreate the PCI
> layout withotu having to create a bunch of uAPI to do so.

We're again back to migration compatibility, where again the capability
layout would be governed by the migration support in the in-kernel
variant driver.  Once migration is involved the location of a PASID
shouldn't be arbitrary, whether it's provided by the kernel or the VMM.

Regardless, the VMM ultimately has the authority what the guest
sees in config space.  The VMM is not bound to expose the PASID at the
offset provided by the kernel, or bound to expose it at all.  The
kernel exposed PASID can simply provide an available location and set
of enabled capabilities.  Thanks,

Alex


