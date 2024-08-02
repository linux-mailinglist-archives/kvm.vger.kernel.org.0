Return-Path: <kvm+bounces-23084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E19C94623A
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 19:05:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C46971F22760
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 17:05:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FDDB1537A0;
	Fri,  2 Aug 2024 17:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hj5BT8RI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A547416BE2D
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 17:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722618314; cv=none; b=prqeXcpLidXTQDL3twMNComnf5uuyuSOAcvjDdXirGP4wjLvISgygWv4fwSvwc2fii3PWtm4PgzVqJY+of0W+n7tCf2VV3i2q0XBa2us6iNFPCXnbx5Jc2rENSAyu0YI0LSOEA6aZcR4H7f/ZoU+eUnmgc4JHQl7HATKDePirD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722618314; c=relaxed/simple;
	bh=LYZeEoXD1MRcP7FnteINA5VYc1IRTum2LPZ8Op3jy5g=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PO17+gHW0G82pl2sBUy+MF+PIQiiN3ayciTw6Q1jThHKWSmtkSXmGATGeWUD4RYe1Ad2g17yrZJ11/Xji5jEgbJFPNVFNjqePaE7qCaLgVUyCcLufMWYrMdNzugErnwbkRHmqOvX3IKBM2XhoMAdpgbyc298mnIbj5EUSmHUYgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hj5BT8RI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722618311;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NiwMIboffiHIHm8ZNuV6tBbNURnyVhFmDSlOxVZsJZE=;
	b=hj5BT8RIIRbEx6TDpM7BWm0Jz3QcgFzuN9z8is1pBfbonFdqkIICsmeIbKOPdvw5h4gBHk
	ZWrvL6XtXKSLApHq6uqWqzJKw7DCv/PhxSaLgSiCMfP78vy2whIoP1dSJBoSEEJsgc11yd
	T7cXt8kXgzWbqA+LFsoYa5pVL0Wz9Gc=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-539-3LUvMvv6Nq-KbzO4sdYoOg-1; Fri, 02 Aug 2024 13:05:10 -0400
X-MC-Unique: 3LUvMvv6Nq-KbzO4sdYoOg-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-81f8edd731cso1170857639f.0
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 10:05:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722618309; x=1723223109;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NiwMIboffiHIHm8ZNuV6tBbNURnyVhFmDSlOxVZsJZE=;
        b=q5XW6M4dw5zDp9jE53pugN1ugAoOC0X+exB8TU9fMKgnmNkRP+nM0jOn0QtFlRcu0T
         wZzjpQLj6zjYzHvFH8cm0VYaN/w9AdGzgvSFnfEIvxBwqE28rGdD/lEGxKYJFMljaAg2
         qkYXVkEbetWfmKQNXJOuOcTEJFhxOIJ5R9nJO1BqItm5owf6UxdRJbaYdk1miLk4LsTd
         x1DXQiiNmff4bm8WcGiFsa83XO5tyHNAvMF9ZUikKUgtIKLMpYG6Kf0uqJIyzAH/og4q
         gvD6eLbyX3uyXgASUs5+GkvQMS0cJtW9dlxjFOpdjI4Zm+bQEQ9ixyuXO6eXcIFjkEBf
         cMig==
X-Forwarded-Encrypted: i=1; AJvYcCXVHNXTCQ6opD0TZh/6UO0FuZcObLKI++t+WltNhFfINN5BS7speX4SAMOiGvebwJ8++5kVz9mg1NMFflPSC8cG5hFm
X-Gm-Message-State: AOJu0YzzU9YhGbrL6DsM2EXspPCHv++O8qSoXnMyoUfNV4NpbUNpLrB0
	o/tn1dvMKShYLs5jmjlK+UjaUjYX0LVHUtyubzrX/bxQJTUmBNV5/tsDsJ8sAp+B2rr57A/w3UT
	M0PAqj+yy1KwJ/PwOKRPjuM0xhUTSY8/PXbWuhkrqcO3BNkP2uqCjBC6apg==
X-Received: by 2002:a05:6602:3fc3:b0:81f:945b:7f6d with SMTP id ca18e2360f4ac-81fd4364336mr583644539f.6.1722618308777;
        Fri, 02 Aug 2024 10:05:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEmwj7ILacE2PwC+KISiQWi0MFEeCxVDRLlojbE7Wvet94Gg/jU7apem7YxTLJf80UCdBJ8nQ==
X-Received: by 2002:a05:6602:3fc3:b0:81f:945b:7f6d with SMTP id ca18e2360f4ac-81fd4364336mr583638539f.6.1722618307960;
        Fri, 02 Aug 2024 10:05:07 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4c8d69a8009sm535597173.49.2024.08.02.10.05.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Aug 2024 10:05:07 -0700 (PDT)
Date: Fri, 2 Aug 2024 11:05:06 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Keith Busch <kbusch@meta.com>, kvm@vger.kernel.org, Keith Busch
 <kbusch@kernel.org>
Subject: Re: [PATCH rfc] vfio-pci: Allow write combining
Message-ID: <20240802110506.23815394.alex.williamson@redhat.com>
In-Reply-To: <20240802115308.GA676757@ziepe.ca>
References: <20240731155352.3973857-1-kbusch@meta.com>
	<20240801141914.GC3030761@ziepe.ca>
	<20240801094123.4eda2e91.alex.williamson@redhat.com>
	<20240801161130.GD3030761@ziepe.ca>
	<20240801105218.7c297f9a.alex.williamson@redhat.com>
	<20240801171355.GA4830@ziepe.ca>
	<20240801113344.1d5b5bfe.alex.williamson@redhat.com>
	<20240801175339.GB4830@ziepe.ca>
	<20240801121657.20f0fdb4.alex.williamson@redhat.com>
	<20240802115308.GA676757@ziepe.ca>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 2 Aug 2024 08:53:08 -0300
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Thu, Aug 01, 2024 at 12:16:57PM -0600, Alex Williamson wrote:
> > On Thu, 1 Aug 2024 14:53:39 -0300
> > Jason Gunthorpe <jgg@ziepe.ca> wrote:
> >   
> > > On Thu, Aug 01, 2024 at 11:33:44AM -0600, Alex Williamson wrote:  
> > > > On Thu, 1 Aug 2024 14:13:55 -0300
> > > > Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > > >     
> > > > > On Thu, Aug 01, 2024 at 10:52:18AM -0600, Alex Williamson wrote:    
> > > > > > > > vfio_region_info.flags in not currently tested for input therefore this
> > > > > > > > proposal could lead to unexpected behavior for a caller that doesn't
> > > > > > > > currently zero this field.  It's intended as an output-only field.        
> > > > > > > 
> > > > > > > Perhaps a REGION_INFO2 then?
> > > > > > > 
> > > > > > > I still think per-request is better than a global flag      
> > > > > > 
> > > > > > I don't understand why we'd need a REGION_INFO2, we already have
> > > > > > support for defining new regions.      
> > > > > 
> > > > > It is not a new region, it is a modified mmap behavior for an existing
> > > > > region.    
> > > > 
> > > > If we're returning a different offset into the vfio device file from
> > > > which to get a WC mapping, what's the difference?     
> > > 
> > > I think it is a pretty big difference.. The offset is just a "mmap
> > > cookie", it doesn't have to be 1:1 with the idea of a region.
> > >   
> > > > A vfio "region" is
> > > > describing a region or range of the vfio device file descriptor.    
> > > 
> > > I'm thinking a region is describing an area of memory that is
> > > available in the VFIO device. The offset output is just a "mmap
> > > cookie" to tell userspace how to mmap it. Having N mmap cookies for 1
> > > region is OK.  
> > 
> > Is an "mmap cookie" an offset into the vfio device file where mmap'ing
> > that offset results in a WC mapping to a specific device resource?  
> 
> Yes
> 
> > Isn't that just a region that doesn't have an index or supporting
> > infrastructure?  
> 
> No? It is a "mmap cookie" that has the requested mmap-time properties.
> 
> Today the kernel side binds the mmap offset to the index in a computed
> way, but from a API perspective userspace does REGION_INFO and gets
> back an opaque "mmap cookie" that it uses to pass to mmap to get back
> the thing describe by REGION_INFO. Userspace has no idea about any
> structure to the cookie numbers.

REGION_INFO is part of what I'm referring to as infrastructure.
Userspace knows a number of regions, ie. indexes, via DEVICE_INFO and
iterates those regions using REGION_INFO to get the mmap cookie, ie.
file offset.  The ABI is flexible here, the first few region indexes
are static mappings to vfio-pci specific device resources and
additional mappings are described as device specific resources using
the REGION_INFO capability chain.

> > > Which controls what NC/WC the mmap creates when called:
> > > 
> > > +	if (vdev->bar_write_combine[index])
> > > +		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
> > > +	else
> > > +		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> > > 
> > > You get the same output from REGION_INFO, same number of regions.  
> > 
> > It was your proposal that introduced REQ_WC, this is Keith's original
> > proposal.  I'm equating a REQ_WC request inventing an "mmap cookie" as
> > effectively the same as bringing a lightweight region into existence
> > because it defines a section of the vfio device file to have specific
> > mmap semantics.  
> 
> Well, again, it is not a region, it is just a record that this mmap
> cookie uses X region with Y mapping flags. The number of regions don't
> change. Critically from a driver perspective the number of regions and
> region indexes wouldn't change.

Why is this critical?  As above, for vfio-pci devices the first few
region indexes are static mappings to specific PCI resources and
additional resources beyond VFIO_PCI_NUM_REGIONS are device specific
and described by a region type in the capability chain.

None of the static regions move and it's part of the defined ABI for
userspace to iterate additional regions.

> I am not thing of making a new region, I am thinking of adjusting how
> mmap works. Like today we do this:
> 
> 	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
> 
> So maybe instead it is something like:
> 
>       vfio_decode_mmap_cookie(vma, &index, &flags);
>       if (flags & VFIO_MMAP_WC)
>           prot = pgprot_writecombine(..)
> 
> From a driver perspective the region indexes don't change at all. This
> is what I think is important here.

The only thing that changes is that num_regions increases and the user
can go check REGION_INFO on those newly reported regions.  The way we
currently calculate the index from the vm_pgoff is implementation, not
uAPI.  We can change that if necessary.  Userspace should always get
the offset, ie. mmap cookie, from REGION_INFO and the initial set of
region indexes to device resources are fixed, they will not change.

> > > It was the other proposal from long ago that created more regions.
> > > 
> > > This is what I like and would prefer to stick with. REGION_INFO
> > > doesn't really change, we don't have two regions refering to the same
> > > physical memory, and we find some way to request NC/WC of a region at
> > > mmap time.  
> > 
> > "At mmap time" means that something in the vma needs to describe to us
> > to use the WC semantics, where I think you're proposing that the "mmap
> > cookie" provides a specific vm_pgoff which we already use to determine
> > the region index.    
> 
> Yes
> 
> > So whether or not we want to call this a region,
> > it's effectively in the same address space as regions.  Therefore "mmap
> > cookie" ~= "region offset".  
> 
> Well, that is just the current implementation. What we did in RDMA
> when we switched from hard coded mmap cookies to dynamic ones is
> use an xarray (today this should be a maple tree) to dynamically
> allocate mmap cookies whenever the driver returns something to
> userspace. During the mmap fop the pgoff is fed back through the maple
> tree to get the description of what the cookie represents.

Sure, we could do that too, the current implementation (not uAPI) just
uses some upper bits to create fixed region address spaces.  The only
thing we should need to keep consistent is the mapping of indexes to
device resources up through VFIO_PCI_NUM_REGIONS.

> So the encoding of cookies is completely disjoint from whatever the
> underlying thing is. If you want the same region to be mapped with two
> or three different prot flags you just ask for two or three cookies
> and at mmap time you can recover the region pointer and the mmap
> flags.
> 
> So VFIO could do several different things here to convay the mmap
> flags through the cookie, including somehow encoding it in a pgoff
> bit, or using a dynamic maple tree scheme.
> 
> My point is to not confuse the pgoff encoding with the driver concept
> of a region. The region is a single peice of memory, the "mmap cookie"s
> are just handles to it. Adding more data to the handle is not the same
> as adding more regions.

I don't get it.  Take for instance PCI config space.  Given the right
GPU, I can get to config space through an I/O port region, an MMIO
region (possibly multiple ways), and the config space region itself.
Therefore based on this hardware implementation there is no unique
mapping that says that config space is uniquely accessible via a single
region.  Each of these regions has different semantics.  If the layout
of the device can cause this, why do we restrict ourselves that a given
BAR can only be accessed via a signle region and we need to play games
with terminology to call it an mmap cookie rather than officially
creating a region with WC mmap semantics?

> > > > At the limit they're the same.  We could use a
> > > > DEVICE_FEATURE to ask vfio to selectively populate WC regions after
> > > > which the user could re-enumerate additional regions, or in fact to
> > > > switch on WC for a given region if we want to go that route.  Thanks,    
> > > 
> > > This is still adding more regions and reporting more stuff from
> > > REGION_INFO, that is what I would like to avoid.  
> > 
> > Why?  This reminds me of hidden registers outside of capability chains
> > in PCI config space.  Thanks,  
> 
> The mmap offsets are not (supposed to be) ABI in the VFIO ioctls. The
> encoding is entirely opaque inside the kernel already. Apps are
> supposed to use REGION_INFO to learn the value to pass to mmap. ie
> things like VFIO_PCI_OFFSET_SHIFT are not in the uAPI header.

Exactly, which gives us the flexibility to add new regions as
necessary.  The mechanism by which userspace iterates regions is
already provided in the uABI.  The initial set of static vfio-pci
regions require fixed indexes, but not fixed offsets.
VFIO_PCI_OFFSET_SHIFT is only an internal implementation detail.  Thanks

Alex


