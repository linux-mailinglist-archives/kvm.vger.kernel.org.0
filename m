Return-Path: <kvm+bounces-15914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A87928B2218
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 14:58:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 34E7B1F24446
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 12:58:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 940FD149C40;
	Thu, 25 Apr 2024 12:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cZgdSCFq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D2F1494D5
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 12:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714049914; cv=none; b=Dsfx638q7HEvViSxNA/MIjbQdZ3FXvm53sR8k3JZnU2ACWbTlVsFXODTE3aFyCZnpQRwx3QsOpcfWPvkmWpe1hwLcniCcDHzO00Fc7kuSmpRaktF7Rz6ZGEIjzFwIpUUiaal4N3Cmlm/6DxRYUqqhRa/+JmBhVmwoVkhzB9xlIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714049914; c=relaxed/simple;
	bh=huSHmgwNZoKmZ4sDWq2VEkac4v3i4yIZb3m7C6JnJKI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TmVPVU+Kqylqpc7iNhaAJNr1qufS6+PCsvA7nMvNhX7aglawGSafPFis2NpUnOFfTc4WbdW2XrP2MHq60Aa4t+0KFlxN74/VGeVsDHnh2BVbEB90J9fU5BKQy6ekqwj3lL5WOEylmcvP9y5FXh5y54tojf90wrgsInl0gCz6LTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cZgdSCFq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714049912;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x7iA+SejiEUVWTFOqtHa2Ktzgnz5x6ewuM8DWhNlr3Y=;
	b=cZgdSCFqb6XXnaFDtrFkowBRK6fcf2hMk9Zevw1O92f8XK50WzepA6JDj9WlxKO3f/HmiT
	N39E8N92xGef8HSOhyvKUNglzE12d6HUgb8AUo3ittuHqe3pVxzJ2gNyBIkdFVbjNtyUKs
	fMfmavzjiti2TqPy2sQ4wGwZKmvYWQY=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-452-WOl-hXgnOPaMPeiykw4Jsg-1; Thu, 25 Apr 2024 08:58:30 -0400
X-MC-Unique: WOl-hXgnOPaMPeiykw4Jsg-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-36a0f6b6348so9824125ab.3
        for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 05:58:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714049910; x=1714654710;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x7iA+SejiEUVWTFOqtHa2Ktzgnz5x6ewuM8DWhNlr3Y=;
        b=k2FP5enjuMXBYrv5NKknbGR7GSMe0ez8gr1Hh17nX6sKyqi8eSmawZa1U2nw7QFXCq
         332WgKSnvYmKJ5CQ1QJ11wDCd+hIksFTgHwHbmkU98Q0QLc0r6vChzTXurrpC1YiIWQO
         6lb4Sp1Vwl7on/jFSZjA690//7MvDGwI/fZufJweOYtMQgKcF4ihfR82GR3eh9PvaNMD
         mDKaHSJ9w2eX6VFLqQTZc7aRQisJ32u7lJV6glb2dmPmyoQCj5qsSkdDtzGTR8NxDIB7
         +FkA6CbXOSwinRO7V1LrP4N+AIgriJfqo/89HHQNGewLOB/nobwWbzutbUN84dJPwa4l
         rrhw==
X-Forwarded-Encrypted: i=1; AJvYcCU4HStlXvpdl9qhGzHwZbq5qDSi4V+D2ZIRNfBzcBagdYsH5Wmj8UsNrVT0Omfb5JYnuMQqf6NavDRpjQqRhzRJWx5G
X-Gm-Message-State: AOJu0YxgrYYN1FzFuh+R0+WEiNj7u0GWsL3C+iHgf6nhRdY8j0ANh00t
	nKrgzN45QxJ0T97fz6cNwmmDIgTJkxkf/bMFDx5Mu5VgQr36hzgLH3YFRhN8fPBSgxcCUwL2ZFz
	vQLTykIPiM0vwrlKIwgOaVWIeZIbVSgVeyCeROPzHwGXX4Yvr2A==
X-Received: by 2002:a05:6e02:20c1:b0:36c:9b0:2e65 with SMTP id 1-20020a056e0220c100b0036c09b02e65mr6306194ilq.27.1714049909831;
        Thu, 25 Apr 2024 05:58:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE5gcq2Rdji4p0OHnA6LZ1psN6NYhfibag8KpMBvS78cvkKPAzlJqpMKeydHJj6TvqJnrUy4w==
X-Received: by 2002:a05:6e02:20c1:b0:36c:9b0:2e65 with SMTP id 1-20020a056e0220c100b0036c09b02e65mr6306163ilq.27.1714049909356;
        Thu, 25 Apr 2024 05:58:29 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id r13-20020a056638300d00b00482b12a0776sm4835469jak.27.2024.04.25.05.58.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Apr 2024 05:58:28 -0700 (PDT)
Date: Thu, 25 Apr 2024 06:58:27 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, "Tian, Kevin" <kevin.tian@intel.com>,
 "joro@8bytes.org" <joro@8bytes.org>, "robin.murphy@arm.com"
 <robin.murphy@arm.com>, "eric.auger@redhat.com" <eric.auger@redhat.com>,
 "nicolinc@nvidia.com" <nicolinc@nvidia.com>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
 <chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
 <iommu@lists.linux.dev>, "baolu.lu@linux.intel.com"
 <baolu.lu@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
 "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: Re: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Message-ID: <20240425065827.66b3b9b8.alex.williamson@redhat.com>
In-Reply-To: <07fbea50-b88d-46d8-b438-b4abda0447bb@intel.com>
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
	<20240424122437.24113510.alex.williamson@redhat.com>
	<07fbea50-b88d-46d8-b438-b4abda0447bb@intel.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 25 Apr 2024 17:26:54 +0800
Yi Liu <yi.l.liu@intel.com> wrote:

> On 2024/4/25 02:24, Alex Williamson wrote:
> > On Tue, 23 Apr 2024 21:12:21 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> >> On Tue, Apr 23, 2024 at 11:47:50PM +0000, Tian, Kevin wrote:  
> >>>> From: Jason Gunthorpe <jgg@nvidia.com>
> >>>> Sent: Tuesday, April 23, 2024 8:02 PM
> >>>>
> >>>> On Tue, Apr 23, 2024 at 07:43:27AM +0000, Tian, Kevin wrote:  
> >>>>> I'm not sure how userspace can fully handle this w/o certain assistance
> >>>>> from the kernel.
> >>>>>
> >>>>> So I kind of agree that emulated PASID capability is probably the only
> >>>>> contract which the kernel should provide:
> >>>>>    - mapped 1:1 at the physical location, or
> >>>>>    - constructed at an offset according to DVSEC, or
> >>>>>    - constructed at an offset according to a look-up table
> >>>>>
> >>>>> The VMM always scans the vfio pci config space to expose vPASID.
> >>>>>
> >>>>> Then the remaining open is what VMM could do when a VF supports
> >>>>> PASID but unfortunately it's not reported by vfio. W/o the capability
> >>>>> of inspecting the PASID state of PF, probably the only feasible option
> >>>>> is to maintain a look-up table in VMM itself and assumes the kernel
> >>>>> always enables the PASID cap on PF.  
> >>>>
> >>>> I'm still not sure I like doing this in the kernel - we need to do the
> >>>> same sort of thing for ATS too, right?  
> >>>
> >>> VF is allowed to implement ATS.
> >>>
> >>> PRI has the same problem as PASID.  
> >>
> >> I'm surprised by this, I would have guessed ATS would be the device
> >> global one, PRI not being per-VF seems problematic??? How do you
> >> disable PRI generation to get a clean shutdown?
> >>  
> >>>> It feels simpler if the indicates if PASID and ATS can be supported
> >>>> and userspace builds the capability blocks.  
> >>>
> >>> this routes back to Alex's original question about using different
> >>> interfaces (a device feature vs. PCI PASID cap) for VF and PF.  
> >>
> >> I'm not sure it is different interfaces..
> >>
> >> The only reason to pass the PF's PASID cap is to give free space to
> >> the VMM. If we are saying that gaps are free space (excluding a list
> >> of bad devices) then we don't acutally need to do that anymore.  
> > 
> > Are we saying that now??  That's new.
> >   
> >> VMM will always create a synthetic PASID cap and kernel will always
> >> suppress a real one.
> >>
> >> An iommufd query will indicate if the vIOMMU can support vPASID on
> >> that device.
> >>
> >> Same for all the troublesome non-physical caps.
> >>  
> >>>> There are migration considerations too - the blocks need to be
> >>>> migrated over and end up in the same place as well..  
> >>>
> >>> Can you elaborate what is the problem with the kernel emulating
> >>> the PASID cap in this consideration?  
> >>
> >> If the kernel changes the algorithm, say it wants to do PASID, PRI,
> >> something_new then it might change the layout
> >>
> >> We can't just have the kernel decide without also providing a way for
> >> userspace to say what the right layout actually is. :\  
> > 
> > The capability layout is only relevant to migration, right?  A variant
> > driver that supports migration is a prerequisite and would also be
> > responsible for exposing the PASID capability.  This isn't as disjoint
> > as it's being portrayed.
> >   
> >>> Does it talk about a case where the devices between src/dest are
> >>> different versions (but backward compatible) with different unused
> >>> space layout and the kernel approach may pick up different offsets
> >>> while the VMM can guarantee the same offset?  
> >>
> >> That is also a concern where the PCI cap layout may change a bit but
> >> they are still migration compatible, but my bigger worry is that the
> >> kernel just lays out the fake caps in a different way because the
> >> kernel changes.  
> > 
> > Outside of migration, what does it matter if the cap layout is
    ^^^^^^^^^^^^^^^^^^^^
> > different?  A driver should never hard code the address for a
> > capability.
> >     
> 
> But it may store the offset of capability to make next cap access more
> convenient. I noticted struct pci_dev stores the offset of PRI and PASID
> cap. So if the layout of config space changed between src and dst, it may
> result in problem in guest when guest driver uses the offsets to access
> PRI/PASID cap. I can see pci_dev stores offsets of other caps (acs, msi,
> msix). So there is already a problem even put aside the PRI and PASID cap.

Yes, I had noted "outside of migration" above.  Config space must be
consistent to a running VM.  But the possibility of config space
changing like this only exists in the case where the driver supports
migration, so I think we're inventing an unrealistic concern that a
driver that supports migration would arbitrarily modify the config space
layout in order to make an argument for VMM managed layout.  Thanks,

Alex

> #ifdef CONFIG_PCI_PRI
> 	u16		pri_cap;	/* PRI Capability offset */
> 	u32		pri_reqs_alloc; /* Number of PRI requests allocated */
> 	unsigned int	pasid_required:1; /* PRG Response PASID Required */
> #endif
> #ifdef CONFIG_PCI_PASID
> 	u16		pasid_cap;	/* PASID Capability offset */
> 	u16		pasid_features;
> #endif
> #ifdef CONFIG_PCI_P2PDMA
> 	struct pci_p2pdma __rcu *p2pdma;
> #endif
> #ifdef CONFIG_PCI_DOE
> 	struct xarray	doe_mbs;	/* Data Object Exchange mailboxes */
> #endif
> 	u16		acs_cap;	/* ACS Capability offset */
> 
> https://github.com/torvalds/linux/blob/master/include/linux/pci.h#L350
> 
> >> At least if the VMM is doing this then the VMM can include the
> >> information in its migration scheme and use it to recreate the PCI
> >> layout withotu having to create a bunch of uAPI to do so.  
> > 
> > We're again back to migration compatibility, where again the capability
> > layout would be governed by the migration support in the in-kernel
> > variant driver.  Once migration is involved the location of a PASID
> > shouldn't be arbitrary, whether it's provided by the kernel or the VMM.
> > 
> > Regardless, the VMM ultimately has the authority what the guest
> > sees in config space.  The VMM is not bound to expose the PASID at the
> > offset provided by the kernel, or bound to expose it at all.  The
> > kernel exposed PASID can simply provide an available location and set
> > of enabled capabilities.  Thanks,
> > 
> > Alex
> >   
> 


