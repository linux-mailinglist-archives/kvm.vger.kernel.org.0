Return-Path: <kvm+bounces-54558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D0A93B23D02
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 02:17:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EA06618C2B94
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 00:17:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 782E01E519;
	Wed, 13 Aug 2025 00:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="IruaY6Xo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7164689
	for <kvm@vger.kernel.org>; Wed, 13 Aug 2025 00:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755044236; cv=none; b=s9kKCPXtF+NM0s3vaZcBtEUEdL7z/Did8rnlxTC3l2LfWkZoEJ2CkICYulRjFWAzJecdHXODAYrJypPwa2e2upk2LPB06uLuPXKnFLGpGmFBD185L5ni8im4NKVNrYACwbpRzM8tynaWMlbGvYsg6wWOF7XJ1oA1gfiRBkHoT60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755044236; c=relaxed/simple;
	bh=si+FNazYR5upodfvC2uB4XFKattAxInazp4IQ/Q+WJw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Euo0bgVB4bTQk8JqmV5gkx+CjMvdBKp0vd8dCUg+vbqFH2+1f5JdAb2Y6Dwtmcu9FXOWDI5lit2LL8EMa+Tyln6ybnnabArwUUnaKBy64sZjaTRD8N/gPXFIooj9+GjED7uvZftX/zKPDFUmjwPPLmm8zCgPG8n3XlRqL32P4eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=IruaY6Xo; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-7e806613af8so704306385a.2
        for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 17:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1755044232; x=1755649032; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Hz+5bmW9ejAB6PSHnq99fOMMV55/7S0shvYmAGJC7Ks=;
        b=IruaY6XoCbTMdkgeRZXVCwr7Dr5VABO+mN8QSD6pzdZ26J6MvVhg+37eI4D4RfCdJF
         5UrZeHKkPWv24I+Lv89h0Xkhn5AZwVlFZ7hvGyzw1Gh1wCl61Y1nNgRNsV5nfG5F7mAv
         gU2jsea6iMbIoPDVv1j1hw0lePEmqH7HjuRx2LQzWn0bZ2XhE5YrH53hgdoC2/NvQ/uv
         cZeHl9A2CbUqEtT4p0piyB1p/ook2Hhe0mEfwkVTIGwvC/LTjXl/1taj79IRW1dT10p9
         efksI3VL3+K2tNEz5ikXI/MXzE6OWeyQuevPrKqBrFhhovtMu/7X1bSmITeAR/ppfh5c
         lahA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755044232; x=1755649032;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hz+5bmW9ejAB6PSHnq99fOMMV55/7S0shvYmAGJC7Ks=;
        b=V5dduXeKvm6uE23ck0Ixx15ydoi48n/pDv92mR3hxfLl0ijC05p1mcuygBVgkK0LpR
         4de27SGfVV09m3/X6jLPV+ZW7ETcJBoAETizzGrF7udpAUHITDIh9irhEkzXBebI6m86
         YwSvPPiIcVLVtM7BSUuj8ORMTbYdruQku7C1jglwKYj67tem9mSAeu6XObuPJ6ni4YCG
         Hq/VT+aNqPicN3p9ddOZa7WRH9SqaYic8tBF7ZNmUGwF7eWLJwE1Nqs/3idHwpTMcH7l
         wih7hiv3A8gbNxxjvGNlPZ2wCM79ndM4PcBwMuiXqGgQDn1VNLi0c91qRnPr9tdxRcbu
         eUiQ==
X-Forwarded-Encrypted: i=1; AJvYcCV3RD9Vtx06M7aVRR5MwNFUIaAXIcIePk9s/JFObY5TeIBHIssND3eSQavXiHOicbLvDBo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzcbVE39pgQcj+k7Za+RPjvyPnttE1UF63gF3Umz7CF1WyQOly5
	3JTTiG4iJAmpGZ6GIqJgln0KFySPmb8md+gdHeUWTAXfJhGsXlehM5vUCkLA7Wz+to4=
X-Gm-Gg: ASbGncsfDDqdnAajAIsyZT9ESYL+PSl1YUibXL7KOCe3MSkMbMExz7owqTZdkJwIUxW
	6Ce9sjRieDS4+DxRv3duK+2mGF78ic8aBm1dIhb0eaLesGDSQ/nWFyV7Y6a68U1zHtmujk21bot
	1XjQql0OS9jMmda/eAL/qA6HkSnCj5eAh8jcvwhxaDdmPiTqhfYYEplrlMQlBC51WD5IMiLmvPM
	MXNxE+N61mjJaHxQbqnFSdALVyvuvqK4C/WvsyYNOrhHtpCISEU8ebAxlEIMQeriXB94wdfVNyq
	hpAWNyODCUhx/SHDwEiKULmy2d5K/b+YPdiQvZm9QZ8n0YhFXsEU8j5Zr/B3+mqUp/BUOQYPk9+
	AWFsjHJajYCmd5lofSXxUFNyAuPhO5WjSZL5XIkdARfSiexkEXhRVt1uTy2WZor/k0zvM
X-Google-Smtp-Source: AGHT+IF2PTmbPEnlUgCbD05WGOtqaVQ31Tuy2CxyrqTJ1xkATiTtLjJtIo8rmaOviLzNJI+SiduTbw==
X-Received: by 2002:a05:620a:7209:b0:7e3:3cbc:786d with SMTP id af79cd13be357-7e865291a01mr161592985a.28.1755044232053;
        Tue, 12 Aug 2025 17:17:12 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e67f595525sm1861645185a.2.2025.08.12.17.17.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 17:17:11 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1ulzB0-000000038W5-1smq;
	Tue, 12 Aug 2025 21:17:10 -0300
Date: Tue, 12 Aug 2025 21:17:10 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Kumar, Praveen" <pravkmr@amazon.de>,
	"Adam, Mahmoud" <mngyadam@amazon.de>,
	"Woodhouse, David" <dwmw@amazon.co.uk>,
	"nagy@khwaternagy.com" <nagy@khwaternagy.com>
Subject: Re: [RFC PATCH 0/9] vfio: Introduce mmap maple tree
Message-ID: <20250813001710.GD599331@ziepe.ca>
References: <lrkyqpld96a8a.fsf_-_@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
 <20250805130046.0527d0c7.alex.williamson@redhat.com>
 <80dc87730f694b2d6e6aabbd29df49cf3c7c44fb.camel@amazon.com>
 <20250806115224.GB377696@ziepe.ca>
 <cec694f109f705ab9e20c2641c1558aa19bcb25b.camel@amazon.com>
 <20250807130605.644ac9f6.alex.williamson@redhat.com>
 <20250811155558.GF377696@ziepe.ca>
 <20250811160710.174ca708.alex.williamson@redhat.com>
 <20250812003053.GA599331@ziepe.ca>
 <20250812132642.634b542d.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250812132642.634b542d.alex.williamson@redhat.com>

On Tue, Aug 12, 2025 at 01:26:42PM -0600, Alex Williamson wrote:
> > On Mon, Aug 11, 2025 at 04:07:10PM -0600, Alex Williamson wrote:
> > > We do this today with device specific regions, see
> > > vfio_pci_core_register_dev_region().  We use this to provide several
> > > additional regions for IGD.  If we had an interface for users to
> > > trigger new regions we'd need some protection for exceeding the index
> > > space (-ENOSPC), but adding a small number of regions is not a problem.  
> > 
> > That is pretty incomplete..
> > 
> > If we go down the maple tree direction I expect to eliminate
> > vfio_pci_core_register_dev_region() and replace it with core code
> > handling the dispatch of mmap and rw through the struct vfio_mmap.
> 
> Do note the inconsistency of having a vfio_mmap object that's used for
> read/write.

We can bikeshed the naming at some later point.

> > I know, but I really dislike this as a uAPI. It becomes confusing for
> > the user to get a list of, what should be, physical regions and now
> > suddenly has to deal with non-physial alias regions it may have
> > created.
> 
> This is subjective though.  Personally I find it confusing to have this
> fixation that BAR0 is _only_ accessed through region index 0.

I don't see why. The user story here is "give me a WC mapping for 4096
bytes at offset 0x1245000 in BAR 0"

My version of the uAPI is very simple and logical:
  ioctl(fd, GET_MMAP, {.region_index = VFIO_PCI_BAR0_REGION_INDEX,
                   .map_flags = WC,
                   .mmap_pgoff = &pgoff})
  reg = mmap(NULL, 4098, prot, MMAP_SHARED, fd, pgoff + 0x1245000)

Simple direct, exactly matches the user story.

Why force the user to mess with some virtual region index, I can't see
any justification for that, and it only makes the user's job more
complicated.

Even if you take the position that region indexes are dynamic, it
still makes sense, for a user story, to have an API flow like

   region_index = get_region_by_name("registers");
   ioctl(fd, GET_MMAP, {.region_index = region_index,
                   .map_flags = WC,
                   .mmap_pgoff = &pgoff})
  reg = mmap(NULL, 4098, prot, MMAP_SHARED, fd, pgoff + 0x1245000)

And I can easially imagine something like the VFIO abstraction layer
in DPDK happily working like the above.

In terms of uAPI usage from a user there is zero value in adding a
virtual region index to this flow. It does nothing to help the user at
all, it just some weird hoop to jump through.

> > int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma, struct vfio_mmap *mmap)
> > {
> >    index = mmap->index;
> > 
> > The code is simpler and cleaner, it generalizes outside of PCI. No
> > more open coding vm_pgoff shifting. We get nice things like pgoff
> > packing, better 32 bit compatability, and a huge number of mmap
> > cookies for whatever we need.
> 
> We're in agreement that we need to derive an object from a pgoff and
> that will universally replace embedding the region index in the high
> order bits of the pgoff. 

Ok

> However everything else here is just the implementation of that
> returned object.  The object could easily have a region field that
> maps to the uAPI region and a device region field that maps to the
> physical resource.  Some objects have the same value for these
> fields, some objects don't.  It's not fundamentally important.

Again, I agree we can implement what you are proposing, and it can be
implemented with the maple tree pgoff cleanups too (maybe even
requires it to really be a clean implementation as well).

I just don't think it is a good uapi design for what is ultimately a
very simple user action.

> > > > It would not be another region index. That is the whole point. It is
> > > > another pgoff for an existing index.  
> > > 
> > > I think this is turning a region index into something it was not meant
> > > to be.  
> > 
> > What do you mean? Region index is the uAPI we have to refer to a fixed
> > physical part of the device.
> > 
> > Reallly, what makes more sense as userspace operations:
> > 
> > 'give me a WC mapping for region index 0 which is BAR 0'
> > 
> > 'Make a new region index for region index 0 which is bar 0 and then give me a mapping for region X"
> > 
> > The first is very logical, the second is pretty obfuscated.
> 
> Current situation: We already have an API that says give me a mapping
> for region X.
> 
> Therefore a new operation that says "give me a new region index for
> mapping index 0 with attribute FOO" is much more congruent to our
> current API.

I think that is extremely subjective.

I view it as we have a api to get a mapping for region X, that is
nonextensible and lacks a feature we need.

The logical answer is to improve the API to get a mapping for region
X.

There is many precendents for this in Linux. We have an endless number
of systemcall extensions, eg open, openat(), openat2().

I view my suggestion of GET_REGION_MMAP as the openat() to
GET_REGION_INFO as open().

So I don't agree with your leap that GET_REGION_INFO is perfect and
the issue is we need an entirely new conceputal model for region_index
to keep GET_REGION_INFO unchanged. :(

> Oh!  This was the proposal to use flags as an input value when we call
> REGION_INFO.  Yeah, that's not possible.  But the above two new APIs
> don't logically then follow as our only path forward though.

I'm not fussy here, any option to let us extend GET_REGION_INFO gets
my vote :)

> > > Introducing mmap cookies as a new mapping to a region where we can have
> > > N:1 cookies to region really seems unnecessarily complicated vs a 1:1
> > > cookie to region space.  
> > 
> > Your version is creating a 1:N:1 mapping, which I think is more
> > complicated. One physical region, N virtual regions, one pgoff.
> 
> No, the region index to pgoff is 1:1, REGION_INFO returns 1 offset per
> region.  Therefore I think it's 1:N:N in this denotation vs I think you
> want 1:1:N, but here you've referred to it as a _virtual_ region, which
> is exactly what it is, there is no 1:1 requirement for physical regions
> to virtual regions.

Ultimately the user is only dealing in the physical regions. That is
how it knows what MMIO to reach.

Adding an indirection where the user has to go from the physical
region, be it statically set as uAPI or discovered once dynamically,
to some other virtual region, and then to a pgoff, is confusing and
uncessary. It is not 1:1:N, I'm aiming for a simple 1:N with no new
virtual region concept at all.

> uAPI where a user could invoke a DEVICE_FEATURE (or pick your own
> IOCTL, but DEVICE_FEATURE is very extensible) to dynamically generate a
> new region with specified mmap attributes, DEVICE_INFO.num_regions is
> updated, the offset/mmap_cookie is obtained via REGION_INFO, along with
> a capability in the return buffer allowing introspection.  New ioctls:
> potentially zero.

DEVICE_FEATURE_XX is basically a new ioctl, just multiplexed.

> vfio-core.  I think this is where BenH and I are confused by the
> insistence to start with the maple tree rather than focusing on the API.

I guided working on the maple tree because doing so makes it trivial
and clean to implement the GET_MMAP style API which is what I have
been consistently advocating for.

Anyhow, I think we should stop writing these emails, this has gone on
long enough. If this last round hasn't convinced either one of us lets
call it quits. Tell them to do the extra region and help them make a
clean implementation if that is what you want to do.

Jason

