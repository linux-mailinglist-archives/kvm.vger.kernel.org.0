Return-Path: <kvm+bounces-22979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CA209452A7
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 20:17:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4FC171C20B78
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 18:17:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46DF214374D;
	Thu,  1 Aug 2024 18:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bx17xFoF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722853A8F7
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 18:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722536228; cv=none; b=HTuuSihtmruZcoOISuYiSk7HVN9fN27VzjubzZbFHcHouJMJZB0Qi1wUB12v2UYTiCVBjqSBZ8P94gPCrV2ZrORkhyQzQEHRlRaeqmuIJej1DjAeyNVAwNKtFCiEdnmKFtNAj/5z1Nu3WW5KBRg2MfQC59WIpNk28wuDF+l4SnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722536228; c=relaxed/simple;
	bh=rmRX+y/Ej1+8Rcrosw+lzasPZb6Wp1vWqYKcskl81vk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m8vgHGZ8Almm/34qFm6qvDXTP+8PDYhrU+EOcALo+YOKTdi/O9yk3y4tDd6AgIQ5fLWeASsOSTSflqlX93PF45XBOAhQz++EyRj7vkwyTUVdnf5vMWrl2GNMFrG2P4+r+SXu+NW8CX83UmAWY8m2KtSnrsb8p9fn3Lr8GNm16H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bx17xFoF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722536225;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TVHOrpYoPcJT+tNfiWQq/a0OCpSzgRKdA7SS9IhH11w=;
	b=bx17xFoFv5E+vLDVeExPpaLJXCVfFAUG0fZHnUlDfEA60g4Pq0QmcEKog6g/5EdcbUTZgi
	LDC0B/nkjdowPLa1p5w0rxo9kvKT7eEhSOdREcPI2pkC8av8zStsaF0MWgv6vbAawO9xKh
	h98E/8BD10ax6eB2edhJeb0ksizH9nk=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-413-TyEPj2GjOPuLYmXBjTtW9g-1; Thu, 01 Aug 2024 14:17:00 -0400
X-MC-Unique: TyEPj2GjOPuLYmXBjTtW9g-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-81f93601444so1027425839f.2
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 11:17:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722536220; x=1723141020;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TVHOrpYoPcJT+tNfiWQq/a0OCpSzgRKdA7SS9IhH11w=;
        b=OdMnCm4mm4Na8pmapRiDwuTQcLKaFBYxxAZwGJhZid1GJx8I+Qm3sdrs8s9jZaHqLR
         AbOe55S+jxT6cQWYeVwwwzwt0khHV5mupgXtuts5Z+ix3Uw3E4W8Mid16b00y8Q48yKE
         5+a0eBN51x4GDIq3H51+xv9cdJ1uX2Iki/aCkq1GjDheVht6mCpKuzyDdcSDzUetpeGQ
         y4/QMpXlKG7UWR9SCaM8987d1ZHeViQCxl18CjTscfg2CH50EBioRD9F4Dc3rWjH5Y9n
         e3uJkHjcDk285SPqzRUMaSQFY0izrpVEWzOQxiGVyLkppoJE9sNF/Jn2aS9vPAf81F6O
         XpkA==
X-Forwarded-Encrypted: i=1; AJvYcCVOx+9Adn/e77VPlipeAmQ+VsfMJ5J+EDA1fDcyg6B2QBRoyCZ7Dp7LavKGdwH8UAkmWueD6ndX/smTNDuo9HNqXqQC
X-Gm-Message-State: AOJu0YzdxwS8t0EDPMpmAr5XTAYJ19UzivgbeJShiyQoLM4Jaswt9MbI
	YzGXrgbyk1W/NUi1E3WyxBSux0Bh7ADQ2JaDg7kFUaHtGcxVub1xHflRK4rO/FpnSNjhbBkSP+A
	B7r2d06sdK8r3R7gOaH9tYMGvxO3t2TlALQj7MliE5xQwM4kg4w==
X-Received: by 2002:a05:6602:2d8f:b0:81f:9de7:57ee with SMTP id ca18e2360f4ac-81fd43650c6mr135509539f.7.1722536220075;
        Thu, 01 Aug 2024 11:17:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGJ9IaNXbuUxh4C2kt23/sZXAfuCKTZ/vYjOkJCL7jwjave4qhFmlrQnXt4jdUrXG0cyUUh3Q==
X-Received: by 2002:a05:6602:2d8f:b0:81f:9de7:57ee with SMTP id ca18e2360f4ac-81fd43650c6mr135506339f.7.1722536219373;
        Thu, 01 Aug 2024 11:16:59 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4c8d6988402sm46102173.9.2024.08.01.11.16.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Aug 2024 11:16:58 -0700 (PDT)
Date: Thu, 1 Aug 2024 12:16:57 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Keith Busch <kbusch@meta.com>, kvm@vger.kernel.org, Keith Busch
 <kbusch@kernel.org>
Subject: Re: [PATCH rfc] vfio-pci: Allow write combining
Message-ID: <20240801121657.20f0fdb4.alex.williamson@redhat.com>
In-Reply-To: <20240801175339.GB4830@ziepe.ca>
References: <20240731155352.3973857-1-kbusch@meta.com>
	<20240801141914.GC3030761@ziepe.ca>
	<20240801094123.4eda2e91.alex.williamson@redhat.com>
	<20240801161130.GD3030761@ziepe.ca>
	<20240801105218.7c297f9a.alex.williamson@redhat.com>
	<20240801171355.GA4830@ziepe.ca>
	<20240801113344.1d5b5bfe.alex.williamson@redhat.com>
	<20240801175339.GB4830@ziepe.ca>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 1 Aug 2024 14:53:39 -0300
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Thu, Aug 01, 2024 at 11:33:44AM -0600, Alex Williamson wrote:
> > On Thu, 1 Aug 2024 14:13:55 -0300
> > Jason Gunthorpe <jgg@ziepe.ca> wrote:
> >   
> > > On Thu, Aug 01, 2024 at 10:52:18AM -0600, Alex Williamson wrote:  
> > > > > > vfio_region_info.flags in not currently tested for input therefore this
> > > > > > proposal could lead to unexpected behavior for a caller that doesn't
> > > > > > currently zero this field.  It's intended as an output-only field.      
> > > > > 
> > > > > Perhaps a REGION_INFO2 then?
> > > > > 
> > > > > I still think per-request is better than a global flag    
> > > > 
> > > > I don't understand why we'd need a REGION_INFO2, we already have
> > > > support for defining new regions.    
> > > 
> > > It is not a new region, it is a modified mmap behavior for an existing
> > > region.  
> > 
> > If we're returning a different offset into the vfio device file from
> > which to get a WC mapping, what's the difference?   
> 
> I think it is a pretty big difference.. The offset is just a "mmap
> cookie", it doesn't have to be 1:1 with the idea of a region.
> 
> > A vfio "region" is
> > describing a region or range of the vfio device file descriptor.  
> 
> I'm thinking a region is describing an area of memory that is
> available in the VFIO device. The offset output is just a "mmap
> cookie" to tell userspace how to mmap it. Having N mmap cookies for 1
> region is OK.

Is an "mmap cookie" an offset into the vfio device file where mmap'ing
that offset results in a WC mapping to a specific device resource?
Isn't that just a region that doesn't have an index or supporting
infrastructure?
 
> > > > We'd populate these new regions only for BARs that support prefetch and
> > > > mmap     
> > >
> > > That's not the point, prefetch has nothing to do with write combining.  
> > 
> > I was following the original proposal in this thread that added a
> > prefetch flag to REGION_INFO and allowed enabling WC only for
> > IORESOURCE_PREFETCH.  
> 
> Oh, I didn't notice that, it shouldn't do that. Returning the
> VFIO_REGION_FLAG_WRITE_COMBINE makes sense, but it shouldn't effect
> what the kernel allows.
> 
> > > Doubling all the region indexes just for WC does not seem like a good
> > > idea to me...  
> > 
> > Is the difference you see that in the REQ_WC proposal the user is
> > effectively asking vfio to pop a WC region into existence vs here
> > they're pre-populated?   
> 
> ?? This didn't create more regions AFAICT. It created a new global
> 
> +	bool			bar_write_combine[PCI_STD_NUM_BARS];
> 
> Which controls what NC/WC the mmap creates when called:
> 
> +	if (vdev->bar_write_combine[index])
> +		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
> +	else
> +		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> 
> You get the same output from REGION_INFO, same number of regions.

It was your proposal that introduced REQ_WC, this is Keith's original
proposal.  I'm equating a REQ_WC request inventing an "mmap cookie" as
effectively the same as bringing a lightweight region into existence
because it defines a section of the vfio device file to have specific
mmap semantics.

> It was the other proposal from long ago that created more regions.
> 
> This is what I like and would prefer to stick with. REGION_INFO
> doesn't really change, we don't have two regions refering to the same
> physical memory, and we find some way to request NC/WC of a region at
> mmap time.

"At mmap time" means that something in the vma needs to describe to us
to use the WC semantics, where I think you're proposing that the "mmap
cookie" provides a specific vm_pgoff which we already use to determine
the region index.  So whether or not we want to call this a region,
it's effectively in the same address space as regions.  Therefore "mmap
cookie" ~= "region offset".

> A global is a neat trick, but it would be cleaner to request
> properties of the mmap when the "mmap cookie" is obtained.
> 
> > At the limit they're the same.  We could use a
> > DEVICE_FEATURE to ask vfio to selectively populate WC regions after
> > which the user could re-enumerate additional regions, or in fact to
> > switch on WC for a given region if we want to go that route.  Thanks,  
> 
> This is still adding more regions and reporting more stuff from
> REGION_INFO, that is what I would like to avoid.

Why?  This reminds me of hidden registers outside of capability chains
in PCI config space.  Thanks,

Alex


