Return-Path: <kvm+bounces-23406-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 322009495ED
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 18:53:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DB0B7281D9F
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 16:53:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD9243D984;
	Tue,  6 Aug 2024 16:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="lv5kU9QK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D8518EB0
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 16:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722963196; cv=none; b=d3+Xp/7ugFTY9ZrIrhOgaepF2nUVnjQIjlKHJzV81UrGmndBtKMCLwBrn07m76yMC21pH8ozrqWUJgMTz3XzHMJ7j4ZuON3/NwRBJ2YU6J1oQtpvz81vY+rbXPLRbmgqThDnNyVARRQpSWlUTub0I6fXuGWEIbX/M9W02cEYTEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722963196; c=relaxed/simple;
	bh=59I/EfNtkhPFa32mMdLUDZ7Y8dwMwBuXWyOX3mbBBbg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TWOQ+YbCROjidptTnZ1etLPNCsFGSe+ROK9PUh/a9b6WnFIEvmZfxwu41d104tNP+Mkzu7yFUAf81VZwk+vMOpWPfBj+U4qmYWjT6/TKpPKx/zS5+5S1x9vc44dNyMeFMhBtUKgGM0+E37eN0tSs2V8VGEkYwRPsfJqyBEkdQ58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=lv5kU9QK; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-6b79b93a4c9so286426d6.1
        for <kvm@vger.kernel.org>; Tue, 06 Aug 2024 09:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1722963193; x=1723567993; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xeg5GckbQBBaWWJXE7gVEgiW4GgyLv98Wv9htvQwTzI=;
        b=lv5kU9QKcnn7eJGoic3H+fCrW/IjBSOBqGf8oA3kLRvvLr7+HVnQYAuJGZKOGBjY8P
         u8S3aVzXT8lmwZf8UmCMCXp3RandiG4+8xoAImTup2nDSkOJGirm/xyL0wMeWPZqWgEO
         4g/uLqb8tLElwOhzS7/t4R2SWVBzouxxAAq9amnzruLnfC4jxR8rbMisc7bmSEXxARu0
         g9/N0GecnoGCLn/Nz6+7UfzX0tQjStLQGiffkjbZPQDbMJw/GaYlQ4HFu2CjQMGPmMzU
         0LKHnD7VegJkIQSQML4Fe2/6j70fzRFvL9Su3Wf9dVcJ14XYVAmlS5iXXL6ob/DBbxWt
         HMig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722963193; x=1723567993;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xeg5GckbQBBaWWJXE7gVEgiW4GgyLv98Wv9htvQwTzI=;
        b=tl0znspJjvjrRoIXzCwcfxeKe8IkhpZ+DRENW1ta14IQDsZM40aVtyqNlHMcOKf7/b
         hPnqyBfGj/vZETedv/VHc11AXIiZJ0pRhIyjLSyHFe5uPdpbgUzZCXvhcB+rRA31WVC8
         yT/GqYXzeNvuSRCiwcgZZ75odS9KU+7k+uRrWBmtXSWa6aH/NfNAinQsXEKbQvkt4RK6
         /gk9MHRQLCAS94hxaK4EFBsZqmkv5BJ4vXj5xRHLC9FWnEpShQcpFfghXa3J7BYxm3V1
         /XBSs5CrrGMFxtvVIVnKGotp9FT4Z7lQNT3Xs1pD0fB15PJT5LEwZSXW5E1f6q7FwFGd
         gT1w==
X-Forwarded-Encrypted: i=1; AJvYcCW+gYL9mWCEKLXniHOwiCuapC8nHlihXUxPfm3zQuTteuEcwdL5ey5LC7OhSLrb9oUDgBnd/jevhCHeGmiv1eg/72Ed
X-Gm-Message-State: AOJu0Yyc20n8u6mOP+WXKcrg+XQRFQITsXX9d9/rx3ldOL/AWmDGTpEb
	Uqqfv6ThlVraU0keq80EhzMP71f0U6qzjsHQM78KgKXOqtqDG0HUlnLaQj4OiV4=
X-Google-Smtp-Source: AGHT+IEAkUJPDpscwJVh7JC5GryCgdtDEgFNrcWsgeSmMq5HgUXevzojlHCifyKfSkXtmu9upi4Zsw==
X-Received: by 2002:ad4:41cf:0:b0:6b0:8991:a2f7 with SMTP id 6a1803df08f44-6bb91d83d3cmr336285196d6.12.1722963193456;
        Tue, 06 Aug 2024 09:53:13 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6bb9c77099asm48527246d6.12.2024.08.06.09.53.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Aug 2024 09:53:12 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1sbNQu-00FQAY-Fp;
	Tue, 06 Aug 2024 13:53:12 -0300
Date: Tue, 6 Aug 2024 13:53:12 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Keith Busch <kbusch@meta.com>, kvm@vger.kernel.org,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH rfc] vfio-pci: Allow write combining
Message-ID: <20240806165312.GI676757@ziepe.ca>
References: <20240801141914.GC3030761@ziepe.ca>
 <20240801094123.4eda2e91.alex.williamson@redhat.com>
 <20240801161130.GD3030761@ziepe.ca>
 <20240801105218.7c297f9a.alex.williamson@redhat.com>
 <20240801171355.GA4830@ziepe.ca>
 <20240801113344.1d5b5bfe.alex.williamson@redhat.com>
 <20240801175339.GB4830@ziepe.ca>
 <20240801121657.20f0fdb4.alex.williamson@redhat.com>
 <20240802115308.GA676757@ziepe.ca>
 <20240802110506.23815394.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240802110506.23815394.alex.williamson@redhat.com>

On Fri, Aug 02, 2024 at 11:05:06AM -0600, Alex Williamson wrote:

> > Well, again, it is not a region, it is just a record that this mmap
> > cookie uses X region with Y mapping flags. The number of regions don't
> > change. Critically from a driver perspective the number of regions and
> > region indexes wouldn't change.
> 
> Why is this critical?

So we don't leak this too much into the drivers? Why should all the
VFIO drivers have to be changed to alter how their region indexes work
just to add a single flag?? 

> > Well, that is just the current implementation. What we did in RDMA
> > when we switched from hard coded mmap cookies to dynamic ones is
> > use an xarray (today this should be a maple tree) to dynamically
> > allocate mmap cookies whenever the driver returns something to
> > userspace. During the mmap fop the pgoff is fed back through the maple
> > tree to get the description of what the cookie represents.
> 
> Sure, we could do that too, the current implementation (not uAPI) just
> uses some upper bits to create fixed region address spaces.  The only
> thing we should need to keep consistent is the mapping of indexes to
> device resources up through VFIO_PCI_NUM_REGIONS.

I fear we might need to do this as there may not be room in the pgoff
space (at least for 32 bit) to duplicate everything....

> > My point is to not confuse the pgoff encoding with the driver concept
> > of a region. The region is a single peice of memory, the "mmap cookie"s
> > are just handles to it. Adding more data to the handle is not the same
> > as adding more regions.
> 
> I don't get it.  Take for instance PCI config space.  Given the right
> GPU, I can get to config space through an I/O port region, an MMIO
> region (possibly multiple ways), and the config space region itself.
> Therefore based on this hardware implementation there is no unique
> mapping that says that config space is uniquely accessible via a single
> region.  

That doesn't seem like this sitation. Those are multiple different HW
paths with different HW addresses, sure they can have different
regions.

Here we are talking about the same HW path with the same HW
addresses. It shouldn't be duplicated.

> BAR can only be accessed via a signle region and we need to play games
> with terminology to call it an mmap cookie rather than officially
> creating a region with WC mmap semantics?

Because if you keep adding more regions for what are attributes of a
mapping we may end up with a combinatoral explosion of regions.

I already know there is interest in doing non-cache/cache mapping
attributes too.

Approaching this as a fixed number of regions reflecting the HW
addresses and a variable number of flags requested by the user is alot
more reasonable than trying to have a list of every permutation of
every address for every combination of flags.

Jason

