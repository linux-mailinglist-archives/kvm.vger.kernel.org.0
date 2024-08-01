Return-Path: <kvm+bounces-22972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 10138945250
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 19:53:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 875861F2516C
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 17:53:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37F9B1B9B3A;
	Thu,  1 Aug 2024 17:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="PwT59Baj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5CB1B4C2A
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 17:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722534823; cv=none; b=t32/jRMspy6xTRWaaTTZNL1i5uKg4SeEN+1N+rNnK1eOvNdJIG7KoyFvCX/MBWlcbYLTdlC+VGyXqZycYxYMLyhOnRbQpmH/Le4+0lf8SidmmAs+RBtayXgiX0vAeevKqyo/t/owOlDtSOo79QgfX8uUNe46YkZr38bth3onJKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722534823; c=relaxed/simple;
	bh=i9rtgsOq79uQabYSm01caNcxa7Ml/jsnXOQUAaeZ5U8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YMtEhfs0fInwJIchUa3oWn+UEoPFfbZCRDlUP9b7kTBJKyNrvb73Td/f08ptaIRUeqdQIKLqt+5OfjW7J7FiTg1gLUkP6cDIoV50kF2KzE68/4AU99Lw8uC8dauwIWDzbgE45vvc5SVQE9T7hSZvHRyrrmG2mdMRUjA8WrAHZ2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=PwT59Baj; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-7a1d42da3e9so469299585a.1
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 10:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1722534820; x=1723139620; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qVCu6c8jgrnQNeancvxkzjjOMXa+EbaCuJUb0gzcs7k=;
        b=PwT59BajIrAIYqqArg48Xa1NS8Z0kla9tSVI0chOG5HG9IjoCIoyjt404T1IHjj9cy
         KgtJILAI4q7y91UlmcQnASj6IlBs4tt8bJqIYOhpRV1v8EaoE2XX77qf2ZWIs1FSaLcT
         wyHEiajdDU2wjstKXy/pd4kbIG7BZKqcuxH+YMG5uLiDmE1VjzESlxrNN9Z2n1mpHWDU
         lJncndK+ViWggoR2Red0ThRfkfnHqP7wRZew6eO79FzHh+8Te7DzwngN2WH1DlzQNWhj
         kfLin5nYeJjH5JtZOGhT8I56ykgDZi83XlXsl9NRMXB0KV0600nA9xX358WR9VYz8K8Z
         nfMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722534820; x=1723139620;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qVCu6c8jgrnQNeancvxkzjjOMXa+EbaCuJUb0gzcs7k=;
        b=lV1SEpZecCOwTj7aed0I6yuto1SfXa61ws9lK8FRSU+hLViQbFGQASgkfvrG2mtnKt
         Z+XPrQGFG+pl761y9tR/jSErUIhyqq8+J706XPJ88vofWOEjDme2ZDidodtMpX7hwMBG
         0NnWu/ICyhq+U4wkGhwSZrU76vSHrpENiQHUg6uhf8DuuyM4Lb640QRWwz975pJMpiqb
         8JvMbf4Ka6g5y0jOExX6Wxs2DZGZU1jCcnDvYWF5CAY5gVeigG3affvqwnH8+ubJKtLr
         6tN8ToTG++BfHXXZmpqdGL/wITGDc2TXnFMRA4hJRfnd+K75hTOTy9dyEos6ALfhHTdp
         xKZg==
X-Forwarded-Encrypted: i=1; AJvYcCW+JLkUky5mXzjSVsp51RGKwpsrPIjSOF3fh9RaAy0vRzy3fOhxZZdwvh0SKfio2LIvphN09sdI03cMgq/FsdZ2vvoU
X-Gm-Message-State: AOJu0Yz7nm4JYJwMcWBYXLIXDhAYnyvLRAJ/JpoiW+zzxmXPUUKuJVEb
	MgNDf13VsR3YPXWERFlgCjTIwjOtdYUj4ZZ1elEKJoVKzslrU5yVk3LwLgF4lis=
X-Google-Smtp-Source: AGHT+IH45Rs3T+8F5+Wd1IIb/Ak8KbA9EOOstuL3bdGWydmU5fvTuUv9+rR9JOeSj+DYshgTNVvnDg==
X-Received: by 2002:a05:620a:2988:b0:79f:776:a9f2 with SMTP id af79cd13be357-7a34ef9e509mr84029185a.56.1722534820067;
        Thu, 01 Aug 2024 10:53:40 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a34f7882b0sm11290085a.110.2024.08.01.10.53.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Aug 2024 10:53:39 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1sZZzf-000D7A-21;
	Thu, 01 Aug 2024 14:53:39 -0300
Date: Thu, 1 Aug 2024 14:53:39 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Keith Busch <kbusch@meta.com>, kvm@vger.kernel.org,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH rfc] vfio-pci: Allow write combining
Message-ID: <20240801175339.GB4830@ziepe.ca>
References: <20240731155352.3973857-1-kbusch@meta.com>
 <20240801141914.GC3030761@ziepe.ca>
 <20240801094123.4eda2e91.alex.williamson@redhat.com>
 <20240801161130.GD3030761@ziepe.ca>
 <20240801105218.7c297f9a.alex.williamson@redhat.com>
 <20240801171355.GA4830@ziepe.ca>
 <20240801113344.1d5b5bfe.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240801113344.1d5b5bfe.alex.williamson@redhat.com>

On Thu, Aug 01, 2024 at 11:33:44AM -0600, Alex Williamson wrote:
> On Thu, 1 Aug 2024 14:13:55 -0300
> Jason Gunthorpe <jgg@ziepe.ca> wrote:
> 
> > On Thu, Aug 01, 2024 at 10:52:18AM -0600, Alex Williamson wrote:
> > > > > vfio_region_info.flags in not currently tested for input therefore this
> > > > > proposal could lead to unexpected behavior for a caller that doesn't
> > > > > currently zero this field.  It's intended as an output-only field.    
> > > > 
> > > > Perhaps a REGION_INFO2 then?
> > > > 
> > > > I still think per-request is better than a global flag  
> > > 
> > > I don't understand why we'd need a REGION_INFO2, we already have
> > > support for defining new regions.  
> > 
> > It is not a new region, it is a modified mmap behavior for an existing
> > region.
> 
> If we're returning a different offset into the vfio device file from
> which to get a WC mapping, what's the difference? 

I think it is a pretty big difference.. The offset is just a "mmap
cookie", it doesn't have to be 1:1 with the idea of a region.

> A vfio "region" is
> describing a region or range of the vfio device file descriptor.

I'm thinking a region is describing an area of memory that is
available in the VFIO device. The offset output is just a "mmap
cookie" to tell userspace how to mmap it. Having N mmap cookies for 1
region is OK.

> > > We'd populate these new regions only for BARs that support prefetch and
> > > mmap   
> >
> > That's not the point, prefetch has nothing to do with write combining.
> 
> I was following the original proposal in this thread that added a
> prefetch flag to REGION_INFO and allowed enabling WC only for
> IORESOURCE_PREFETCH.

Oh, I didn't notice that, it shouldn't do that. Returning the
VFIO_REGION_FLAG_WRITE_COMBINE makes sense, but it shouldn't effect
what the kernel allows.

> > Doubling all the region indexes just for WC does not seem like a good
> > idea to me...
> 
> Is the difference you see that in the REQ_WC proposal the user is
> effectively asking vfio to pop a WC region into existence vs here
> they're pre-populated? 

?? This didn't create more regions AFAICT. It created a new global

+	bool			bar_write_combine[PCI_STD_NUM_BARS];

Which controls what NC/WC the mmap creates when called:

+	if (vdev->bar_write_combine[index])
+		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
+	else
+		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);

You get the same output from REGION_INFO, same number of regions.

It was the other proposal from long ago that created more regions.

This is what I like and would prefer to stick with. REGION_INFO
doesn't really change, we don't have two regions refering to the same
physical memory, and we find some way to request NC/WC of a region at
mmap time.

A global is a neat trick, but it would be cleaner to request
properties of the mmap when the "mmap cookie" is obtained.

> At the limit they're the same.  We could use a
> DEVICE_FEATURE to ask vfio to selectively populate WC regions after
> which the user could re-enumerate additional regions, or in fact to
> switch on WC for a given region if we want to go that route.  Thanks,

This is still adding more regions and reporting more stuff from
REGION_INFO, that is what I would like to avoid.

Jason

