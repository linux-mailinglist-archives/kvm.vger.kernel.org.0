Return-Path: <kvm+bounces-23030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 01915945D6F
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 13:53:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C57C3B21171
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 11:53:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA5301E289D;
	Fri,  2 Aug 2024 11:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="hXLq0DsQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED7B1DF660
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 11:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722599593; cv=none; b=qzrsVGIf3pUPkCoWMrLLYm+zvwV6JmdtxrMEtU0JbNBZULVhb6kiHi8c0NrCpb+VEn+pzyetYH3m97Bf0FOvCYPWHWEiBb28/ntGgW0P3ayfJuJSOnye0TRAk6i95bAAFNCUGpgTfK/4TAdIV7ZpqjkEORTQjXW7Du7KS9HC+3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722599593; c=relaxed/simple;
	bh=MCIn1+xsBaSpE0QsU6s5svPv+VVsVbonIpXmi8X0JyA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ifr26jB/f3W/7qJWyCItTtC01a+F1aeFVT6g1lV1ASlIHUTnBYOhSEuYsRS3eDZDki0mCp8cGwbyXztb9x4YnSxacHkKY9vOTSkJmNDxNTGfaXCGh1W58xFfYIX+HqmxaCowUZnjWN0ZjwvoE/YEtWROLlqp2oC4MuwXorhQAe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=hXLq0DsQ; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-7a20b8fa6dcso178618785a.3
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 04:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1722599590; x=1723204390; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zMZrxWtfpNPZ2fm2KVk57wotJxUWPYI8ZsWDXsbq9mY=;
        b=hXLq0DsQEa1q8pq8Tr3JE0do4a2Qi/D1cV77OVchyhvvHapHFAK5djD272M44k+bDP
         o1YHu5RSenlYjCGwGMsYGZtxSXLQrTSXH0/P0fXq6oflYtoaMQVRDR9nUrJWbBY0kx2o
         COk01ef62rNTzHYyDtVJ60eJFx3Xl7byWJzLLw+aCdVDY+/Pia74QfAchy/bN/JPDCpi
         udUj8AY6poZe8xj7rVU2sC59MMylyPewTTOh28jYSu3r1wlqNF/LwSk5Dgwi9iTV4g72
         JPxKi9E2esR6jIGw+Gh93ThkZAdcsrlnu8iOcqvcnwjGHOCY60a8WsFqwJmnygB+tMfI
         DpcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722599590; x=1723204390;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zMZrxWtfpNPZ2fm2KVk57wotJxUWPYI8ZsWDXsbq9mY=;
        b=C3s46QZy7WSYNBepSxu510uFhc8m4a/7DdvSN12neVc3Mne5rgpUHPDFqZ0PEa0aO3
         mrN8FV/iU+b1y+jFv7octQGvWoyj7Ggdql/aw8xVpk0B/68QLONt/D1VzOkiixyXC7P9
         4LihnEsHvh1Q5ML4HzKd94Y2IGl8K6IPPsOpy06ZAF4G11dTpeBoY8knxG6alW8qmNKm
         Y2QiBu4YEJ5ROzzNjPjrK6VwgsptgYyFVrlSKaxJUP5qd3l840ORxGo2Hs/lz3iYo7Wr
         vzFD6xc07tDVm5jpDPEIUVOLeZy7AhsItgrUby/Q5i2F40aUKQzTbFpC8viI4XOQ7kWp
         kyyA==
X-Forwarded-Encrypted: i=1; AJvYcCXOtyTM4ps6pk+Y/2JmPCCvgg657otikCCe/4IBRzDt1lgcNbZ9Gplo92u7djqpN66BhTC4OKZv0dTs3Ood/+VGYLn+
X-Gm-Message-State: AOJu0YzkBixsTtk5krooxvyB/KJnLo/XaSXniVhCkOKFiA/pQEO4lFwc
	Nv127ws0UkloILD2J6SaQdXG2CkT9sZd6VAnNW9vNwUoEpgLqEDNcD4BLuw+8x0=
X-Google-Smtp-Source: AGHT+IHbZYP+Df1u7MHAcffXRoNEB3qBsrCJugpSaB1zcuzXpQbrivnr3cz1GtG9bpYPxTTz8RcanA==
X-Received: by 2002:a05:620a:4103:b0:7a2:d63:4cc6 with SMTP id af79cd13be357-7a34ef5ce33mr340534385a.39.1722599589866;
        Fri, 02 Aug 2024 04:53:09 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a34f7724c1sm78627685a.84.2024.08.02.04.53.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Aug 2024 04:53:09 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1sZqqK-002sFQ-HD;
	Fri, 02 Aug 2024 08:53:08 -0300
Date: Fri, 2 Aug 2024 08:53:08 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Keith Busch <kbusch@meta.com>, kvm@vger.kernel.org,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH rfc] vfio-pci: Allow write combining
Message-ID: <20240802115308.GA676757@ziepe.ca>
References: <20240731155352.3973857-1-kbusch@meta.com>
 <20240801141914.GC3030761@ziepe.ca>
 <20240801094123.4eda2e91.alex.williamson@redhat.com>
 <20240801161130.GD3030761@ziepe.ca>
 <20240801105218.7c297f9a.alex.williamson@redhat.com>
 <20240801171355.GA4830@ziepe.ca>
 <20240801113344.1d5b5bfe.alex.williamson@redhat.com>
 <20240801175339.GB4830@ziepe.ca>
 <20240801121657.20f0fdb4.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240801121657.20f0fdb4.alex.williamson@redhat.com>

On Thu, Aug 01, 2024 at 12:16:57PM -0600, Alex Williamson wrote:
> On Thu, 1 Aug 2024 14:53:39 -0300
> Jason Gunthorpe <jgg@ziepe.ca> wrote:
> 
> > On Thu, Aug 01, 2024 at 11:33:44AM -0600, Alex Williamson wrote:
> > > On Thu, 1 Aug 2024 14:13:55 -0300
> > > Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > >   
> > > > On Thu, Aug 01, 2024 at 10:52:18AM -0600, Alex Williamson wrote:  
> > > > > > > vfio_region_info.flags in not currently tested for input therefore this
> > > > > > > proposal could lead to unexpected behavior for a caller that doesn't
> > > > > > > currently zero this field.  It's intended as an output-only field.      
> > > > > > 
> > > > > > Perhaps a REGION_INFO2 then?
> > > > > > 
> > > > > > I still think per-request is better than a global flag    
> > > > > 
> > > > > I don't understand why we'd need a REGION_INFO2, we already have
> > > > > support for defining new regions.    
> > > > 
> > > > It is not a new region, it is a modified mmap behavior for an existing
> > > > region.  
> > > 
> > > If we're returning a different offset into the vfio device file from
> > > which to get a WC mapping, what's the difference?   
> > 
> > I think it is a pretty big difference.. The offset is just a "mmap
> > cookie", it doesn't have to be 1:1 with the idea of a region.
> > 
> > > A vfio "region" is
> > > describing a region or range of the vfio device file descriptor.  
> > 
> > I'm thinking a region is describing an area of memory that is
> > available in the VFIO device. The offset output is just a "mmap
> > cookie" to tell userspace how to mmap it. Having N mmap cookies for 1
> > region is OK.
> 
> Is an "mmap cookie" an offset into the vfio device file where mmap'ing
> that offset results in a WC mapping to a specific device resource?

Yes

> Isn't that just a region that doesn't have an index or supporting
> infrastructure?

No? It is a "mmap cookie" that has the requested mmap-time properties.

Today the kernel side binds the mmap offset to the index in a computed
way, but from a API perspective userspace does REGION_INFO and gets
back an opaque "mmap cookie" that it uses to pass to mmap to get back
the thing describe by REGION_INFO. Userspace has no idea about any
structure to the cookie numbers.
  
> > Which controls what NC/WC the mmap creates when called:
> > 
> > +	if (vdev->bar_write_combine[index])
> > +		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
> > +	else
> > +		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> > 
> > You get the same output from REGION_INFO, same number of regions.
> 
> It was your proposal that introduced REQ_WC, this is Keith's original
> proposal.  I'm equating a REQ_WC request inventing an "mmap cookie" as
> effectively the same as bringing a lightweight region into existence
> because it defines a section of the vfio device file to have specific
> mmap semantics.

Well, again, it is not a region, it is just a record that this mmap
cookie uses X region with Y mapping flags. The number of regions don't
change. Critically from a driver perspective the number of regions and
region indexes wouldn't change.

I am not thing of making a new region, I am thinking of adjusting how
mmap works. Like today we do this:

	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);

So maybe instead it is something like:

      vfio_decode_mmap_cookie(vma, &index, &flags);
      if (flags & VFIO_MMAP_WC)
          prot = pgprot_writecombine(..)

From a driver perspective the region indexes don't change at all. This
is what I think is important here.

> > It was the other proposal from long ago that created more regions.
> > 
> > This is what I like and would prefer to stick with. REGION_INFO
> > doesn't really change, we don't have two regions refering to the same
> > physical memory, and we find some way to request NC/WC of a region at
> > mmap time.
> 
> "At mmap time" means that something in the vma needs to describe to us
> to use the WC semantics, where I think you're proposing that the "mmap
> cookie" provides a specific vm_pgoff which we already use to determine
> the region index.  

Yes

> So whether or not we want to call this a region,
> it's effectively in the same address space as regions.  Therefore "mmap
> cookie" ~= "region offset".

Well, that is just the current implementation. What we did in RDMA
when we switched from hard coded mmap cookies to dynamic ones is
use an xarray (today this should be a maple tree) to dynamically
allocate mmap cookies whenever the driver returns something to
userspace. During the mmap fop the pgoff is fed back through the maple
tree to get the description of what the cookie represents.

So the encoding of cookies is completely disjoint from whatever the
underlying thing is. If you want the same region to be mapped with two
or three different prot flags you just ask for two or three cookies
and at mmap time you can recover the region pointer and the mmap
flags.

So VFIO could do several different things here to convay the mmap
flags through the cookie, including somehow encoding it in a pgoff
bit, or using a dynamic maple tree scheme.

My point is to not confuse the pgoff encoding with the driver concept
of a region. The region is a single peice of memory, the "mmap cookie"s
are just handles to it. Adding more data to the handle is not the same
as adding more regions.

> > > At the limit they're the same.  We could use a
> > > DEVICE_FEATURE to ask vfio to selectively populate WC regions after
> > > which the user could re-enumerate additional regions, or in fact to
> > > switch on WC for a given region if we want to go that route.  Thanks,  
> > 
> > This is still adding more regions and reporting more stuff from
> > REGION_INFO, that is what I would like to avoid.
> 
> Why?  This reminds me of hidden registers outside of capability chains
> in PCI config space.  Thanks,

The mmap offsets are not (supposed to be) ABI in the VFIO ioctls. The
encoding is entirely opaque inside the kernel already. Apps are
supposed to use REGION_INFO to learn the value to pass to mmap. ie
things like VFIO_PCI_OFFSET_SHIFT are not in the uAPI header.

Jason

