Return-Path: <kvm+bounces-54463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AC82AB219D7
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 02:33:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 55275620ACC
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 00:32:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5B9D2D5C64;
	Tue, 12 Aug 2025 00:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="dHjwSuTj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E5E2D543E
	for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 00:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754958658; cv=none; b=kvLsOEeGc/Ua4yhwyf0BC0Tqeg4iH9Vt5SmF5mWqwp71Swf21Xreqqis5Y5X32PmwYTudcKCoJETj1euGvZDTViN4eCl/W4Wc/T6BCsxqdyv74si9J/fHiM5CKgqXly7J+4Vh9no7yCKERrJ6oPzuHGPmUYdIDTzN+izzTDwQPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754958658; c=relaxed/simple;
	bh=y/c9kX45UVJ4GzvH/t8Z2v1Lk96zt3YAKlJNRCyHv4k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P/OW3kylixYDqUgSQFzXJD2Y+Ng1FiwW9sFKtMIB+PZREb9ubrvlxSbVAvnlTqpzTDbef6TJb71MHn6eUm6sC1rw9tNiGYyzlsaKJt1s1pOR3EC873FxaRZpxFqfEGo42r8OuC7fZMVLQIVTrHhLiSs4+bVW0WNEv1oxUisJoeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=dHjwSuTj; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-6fa980d05a8so49243526d6.2
        for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 17:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1754958655; x=1755563455; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KmVwfoTJ4NeyzAoIX3yWz0o8K+DsD2kIlKRL7bj3WRA=;
        b=dHjwSuTjFk0zaDGpSXMutl2wMatuAxcpCufKZ2RayKqd4tLz90SDgsS3mA6MtVhNBv
         XsFUHLSvajrKk6vrBNZzMjUJMbTc/zIVdvh31s8ZQsx1xN9U2XRcmuKiFQmq9ybMOzFu
         EtKIlW8Rx/FyyEkT5TC0N6e9pNbWa2QJhWsOG72aU2g+FxRqhTwj1tsJap0ZNUY2Ylgz
         XegIajd6JJxyqes2ih5eXC9Eq6Wy5UkfsSSFv+V37/5ZIFKmC7leG3tEFh9s5zcu/3TV
         uPmjuANQG8x4bJAss8NveELswEwTUo7RKFfl6GrscFa56UX8Ui+aZJBallRnkA6LHlGs
         jl2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754958655; x=1755563455;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KmVwfoTJ4NeyzAoIX3yWz0o8K+DsD2kIlKRL7bj3WRA=;
        b=duENYtOpzc7/jUpk3YiuRZF4CXQ3AJ8nnS0GPsOMDKgGwhR6yT3SByzP/rc9MxBpCU
         lfAniDdj1cMF0CitRVsvLAVj+5ccA7Bj/a0og7VkfLTRTCGCkbp0kYVRTFKHn6d1Re5C
         hcAf6rbIqvuPi+t90ocO5cL413kfxfdI0q28xiumQ1++hT9oa67k+HYkyqJrnaowUtDo
         HUGGtGTBNqYD6+l3P7m66zKavVzdC0NbZLVeHwDJQGGqk8WqwdCuaIACoRfUIyQnYU3d
         akKFsGqHQfnIJuE3mWtSu9LviiLneM0oTPD2BzfxPD4qHE1LpHl63W9QvCE9R2CG0p1+
         MvIw==
X-Forwarded-Encrypted: i=1; AJvYcCXz7V5nTzQ+6YljfB43ecytlGLzEsvdg5dHTrke2b9AnmGc0R9TjoW8ZGLyoH5X4yXYn6s=@vger.kernel.org
X-Gm-Message-State: AOJu0YzS1cneGsp3jZBcenJIdhzKjehNeA8KEgGrZ08XRm1Et1Rs7SBX
	f5SPEsq/9XKdnjctXj61Dg6yIWdSmrtFP5Cepm15qfIm1Z2ojpVs1Y8dLFPqpuUYYqE=
X-Gm-Gg: ASbGncvTlOiHKlr/rodyf22tRlCA/CfxtgEBp0Pg+hVSqpzLIAA0E6rf/+E7R90b8AO
	9nZxrzrCD4svn5A8HtsOjcsHJOJky1RVRPlzEBm1VnnyFo8bk7bOlkVahCPf1CTa1xzHUoVWyQQ
	5BtA/M5DWRus7ihprLuwhx799M6Yrd4WJEjJogfcAsQogt2YuCFEHHUguWOZHVknXMKjZJBxkEt
	4x0sL3csYpZLRrqVbfvlms7le8qvhJN6egItsEAcfL1qOcVD2/LMKQXJE3OV0FaMXhxjM658h7/
	WgYvtseMjF8B+Q6pjPqw1+FQ5IsU5VhJN5yNS4Ep6YonDNf1Cx+Wfa1NV3Uibg5wu1f6aRUfNRO
	uTuQmkL+S+D/sFL0FaC0+3N1Alsx1nTynfwMpsHZNaDL4A9RLdvBlUuwgzKysqju/A6Ri
X-Google-Smtp-Source: AGHT+IFoJJqXN4kbuYVCRaiwJrEFyV8GG/s4NZOPDauDm6pLtHquR7n8W2LrTd2aQnZv90zOam++4Q==
X-Received: by 2002:ad4:4ea9:0:b0:709:76b4:5936 with SMTP id 6a1803df08f44-709d5e9a8d1mr23941406d6.55.1754958654840;
        Mon, 11 Aug 2025 17:30:54 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077e263efcsm165425706d6.85.2025.08.11.17.30.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Aug 2025 17:30:54 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1ulcuj-00000002YSC-2CTa;
	Mon, 11 Aug 2025 21:30:53 -0300
Date: Mon, 11 Aug 2025 21:30:53 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Kumar, Praveen" <pravkmr@amazon.de>,
	"Adam, Mahmoud" <mngyadam@amazon.de>,
	"Woodhouse, David" <dwmw@amazon.co.uk>,
	"nagy@khwaternagy.com" <nagy@khwaternagy.com>
Subject: Re: [RFC PATCH 0/9] vfio: Introduce mmap maple tree
Message-ID: <20250812003053.GA599331@ziepe.ca>
References: <lrkyq5xf27ss7.fsf@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
 <20250805143134.GP26511@ziepe.ca>
 <lrkyqpld96a8a.fsf_-_@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
 <20250805130046.0527d0c7.alex.williamson@redhat.com>
 <80dc87730f694b2d6e6aabbd29df49cf3c7c44fb.camel@amazon.com>
 <20250806115224.GB377696@ziepe.ca>
 <cec694f109f705ab9e20c2641c1558aa19bcb25b.camel@amazon.com>
 <20250807130605.644ac9f6.alex.williamson@redhat.com>
 <20250811155558.GF377696@ziepe.ca>
 <20250811160710.174ca708.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250811160710.174ca708.alex.williamson@redhat.com>

On Mon, Aug 11, 2025 at 04:07:10PM -0600, Alex Williamson wrote:
> We do this today with device specific regions, see
> vfio_pci_core_register_dev_region().  We use this to provide several
> additional regions for IGD.  If we had an interface for users to
> trigger new regions we'd need some protection for exceeding the index
> space (-ENOSPC), but adding a small number of regions is not a problem.

That is pretty incomplete..

If we go down the maple tree direction I expect to eliminate
vfio_pci_core_register_dev_region() and replace it with core code
handling the dispatch of mmap and rw through the struct vfio_mmap.

What it is now isn't locked properly to be dynamic, and it's operation
is different from the actual physical regions. 

> > > > Well, we want to be able to WC map. Introducing "more cookies"
> > > > again is just one way to get there. How do you create those
> > > > cookies ? Upon request or each region automatically gets multiple
> > > > with different attributes ? Do they represent entire regions or
> > > > subsets ? etc...   
> > 
> > It doesn't matter. Fixing how mmap works internally lets you use all
> > of those options.
> 
> What exactly is the "fix how mmap works internally" proposal?

I explained it to Mahmoud previously:
https://lore.kernel.org/kvm/20250716184028.GA2177603@ziepe.ca/

> > I don't think we need sub-regions, it is too complicated in the kernel
> > and pretty much useless.
> 
> So we infer that mmap cookies are an alias to an entire region.

Ideally

> We have an existing ABI that maps BARs, config space, and VGA spaces to
> fixed region indexes.  That "region index" to "device space" mapping
> cannot change, but the offset of a given region and the total number of
> regions is not ABI. 

Yes.

> Therefore we can introduce an API where a user
> says "give me a new region index that aliases region 0 with mmap
> attribute FOO".  

I know, but I really dislike this as a uAPI. It becomes confusing for
the user to get a list of, what should be, physical regions and now
suddenly has to deal with non-physial alias regions it may have
created.

Our uAPI has a simple input to describe the region:

 	__u32	region_index;

Which I think should always describe the physical uAPI region number
and never something else. Drivers like igd have more "physical"
regions, but they are still ultimately physical regions decided by the
kernel, set in a fixed list.

The region_index is effectively uAPI with things like 0 always being
BAR 0 of a PCI function.

I don't think we should be changing that property..

> To a limited extent we can provide this within fixed index/pgoff
> implementation (not ABI) we use now, but AIUI we could use a maple tree
> to block out ranges and get more dense packing of regions across the
> device fd.

It is not regions, the maple tree packs mmap cookies - the pgoff.

Today we algorithmically derive pgoff from region_index in the kernel
but this is not ABI and is exactly what I want to divorce here. pgoff
goes through the maple tree to obtain the region index, not the other
way around.

> I don't understand how this introduces so much complication to drivers
> that, for example, BAR0 might be accessible through region index 0 for
> legacy mappings and index 10 for modified mmap attributes.  

Because all the drivers assume the pgoff encoding:

int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma)
{
	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);

And index == region_index which is uAPI that defines the physical BAR:

	if (!vdev->bar_mmap_supported[index])
		return -EINVAL;

So this all needs remapping logic if you want to make index dynamic.
Yes you can abuse the vfio_pci_core_register_dev_region() to make
alias regions and somehow provide ops or special cases to handle the
aliases and probably make it work for PCI.

But I'm saying to just have to core handle it:

int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma, struct vfio_mmap *mmap)
{
   index = mmap->index;

The code is simpler and cleaner, it generalizes outside of PCI. No
more open coding vm_pgoff shifting. We get nice things like pgoff
packing, better 32 bit compatability, and a huge number of mmap
cookies for whatever we need.

> Can you describe the driver scenario where having two different
> mmap cookies for region index 0 makes things significantly easier for
> drivers?

Above

> It seems like Ben's suggestion below of a call that modifies the mmap
> attributes of an existing region is the least overall change to
> existing drivers, though I'm not sure if that's what we should be
> optimizing for.

I agreee it is the least overall code change, but it is a bad uAPI
design since it violates the principle that what pgoff points should
behave consistently.

> > > > The biggest advantage of that approach is that it completely
> > > > precludes multiple conflicting mappings for a given region (at
> > > > least within a given process, though it might be possible to
> > > > extend it globally if we  
> > 
> > It doesn't. It just makes a messy uapi. At the time of mmap the vma
> > would stil have to capture the attributes (no fault by fault!) into
> > the VMA so we will see real users doing things like:
> > 
> >  set to wc(cookie)
> >  mmap(cookie + XXX)
> >  set to !wc(cookie)
> >  mmap(cookie + YY)
> > 
> > And then if you try to debug this all our file/vma debug tools will
> > just show cookie everywhere with no distinction that some VMAs are WC
> > and some VMAs are !WC.
> > 
> > Basically, it fundamentally breaks how pgoff is supposed to work here
> > by making its meaning unstable.
> 
> We could require the mmap attribute is set before mmap and not changed
> after, but yes, we don't get simultaneous mmaps with different
> attributes without different cookies.

Not allowing WC and !WC is fatal to any proposal, IMHO.

So as above, it is messy and poor to make the pgoff unstable, and it
will be abused by userspace as I showed if that is the uAPI.

> > Indeed, that is required for most HW. mlx5 for example has BARs that
> > mix WC and non WC access modes. There are too few BARs for most HW to
> > be able to dedicate an entire BAR to WC only.
> 
> So do we want to revisit whether an mmap attribute applies to a whole
> region or only part of a region?  

So long as mmap() can take a slice out of a cookie I don't know of a
functional reason to do more..

> > It would not be another region index. That is the whole point. It is
> > another pgoff for an existing index.
> 
> I think this is turning a region index into something it was not meant
> to be.

What do you mean? Region index is the uAPI we have to refer to a fixed
physical part of the device.

Reallly, what makes more sense as userspace operations:

'give me a WC mapping for region index 0 which is BAR 0'

'Make a new region index for region index 0 which is bar 0 and then give me a mapping for region X"

The first is very logical, the second is pretty obfuscated.

> > This is broadly what I've proposed consistently since the beginning,
> > adjusted for the various remarks since:
> > 
> > struct vfio_region_get_mmap {
> > 	__u32	argsz;
> > 	__u32	region_index; // only one, no aliases
> > 	__u32   mmap_flags; // Set WC here
> > 
> > 	__aligned_u64 region_size;
> > 	__aligned_u64 fd_offset;
> > };
> > 
> > struct vfio_region_get_caps {
> > 	__u32	argsz;
> > 	__u32	region_index;
> > 
> > 	__u32	region_flags; // READ/WRITE/etc
> > 	__aligned_u64 region_size;
> > 	__u32	cap_offset;	/* Offset within info struct
> > of first cap */ };
> > 
> > Alex, you pointed out that the parsing of the existing
> > VFIO_DEVICE_GET_REGION_INFO has made it non-extendable. So the above
> > two are creating a new extendable version that are replacements.
> 
> Can you be more specific on this claim? 

I don't remember exactly. I think you said something about argsz isn't
parsed right by the kernel so we can't make struct vfio_region_info
any bigger to add something like mmap_flags in a backwards compatible
way because the old kernel wouldn't check for 0 in the expanded
structure.

> We are no longer creating static region indexes after the
> introduction of device specific regions, but I don't see why we're
> not using the mechanisms of the device specific region to create new
> region indexes with new offsets that have specified mmap attributes
> here.

Well, because that is not my proposal.

My proposal is the above, where region_index only takes on values that
the current uAPI defines and nothing more.

The driver continues to use region_index for all its internal
operations, like when PCI does this:

	if (!vdev->bar_mmap_supported[index])

And we don't mess with that stuff at all. This is what I'm proposing,
concretely.

> I imagine a DEVICE_FEATURE that creates a new region, returning at
> least the region index, DEVICE_INFO and REGION_INFO are updated to
> describe the new region, ie.  mmap-only, new offset/cookie, likely a
> capability embedded in the REGION_INFO to provide introspection that
> this regions is an alias of another.

And this is what you've been suggesting for a while, and I still
continue to dislike it for the reasons given. :)

> > To avoid the naming confusion we have a specific ioctl to get
> > mmap'able access, and another one for the cap list. I guess this also
> > gives access to read/write so maybe the name needs more bikeshedding.
> 
> Largely duplicating REGION_INFO.

As I said, we can't extend REGION_INFO so to make changes to it we
need new functions.

> > There is still one index per physical object (ie BAR) in the uAPI.
> 
> This is a non-requirement.

Disagree!

> > We get one cookie that describes the VMA behavior exactly and
> > immutably.
> 
> So does the above.

Yes
 
> > The existing VFIO_DEVICE_GET_REGION_INFO is expressed in terms of the
> > above two operations with mmap_flags = 0.
> 
> Still more complicated that new region index and existing ioctls.

I think it would simplify the drivers. Inside the drivers we can split
the cap and mmap return paths into seperate function ops. Currently
this is all open coded inside switch statements and it is pretty
duplicitive.

> I see the device fd as segmented into regions.  The base set of regions
> happen to have fixed definitions relative to device objects.

I don't - the device fd is segmented in to pgoff spaces which are
managed by "mmap cookies". Physical device regions map into many mmap
cookies within the pgoff number space.

> Introducing mmap cookies as a new mapping to a region where we can have
> N:1 cookies to region really seems unnecessarily complicated vs a 1:1
> cookie to region space.

Your version is creating a 1:N:1 mapping, which I think is more
complicated. One physical region, N virtual regions, one pgoff.

> > If we later decide we need to solve the ARM multi-device issue then we
> > can cleanly extend an additional start/len to vfio_region_get_mmap
> > which can ensure mmaps cookies are disjoint. This is not subregions,
> > or new regions, this is just a cookie with a restriction.
> 
> No different if REGION_INFO supplies disjoint offset/length.

We can't extend REGION_INFO so you'd have to create a new region index
which is a slice of a physical index, further complicating the
implementation :(
 
> > In terms of implementation once you do the maple tree work that
> > Mahmoud started we end up with vfio_region_get_mmap allocating a
> > struct vfio_mmap for each unique region_index/mmap_flags and returning
> > it to userspace.
> 
> And we get an entirely disjoint API from legacy vfio.

I don't see how you can say that. Arguably it is closer to legacy
VIFIO because we don't create new region_index's that are not defined
in the uAPI header! Instead we add a single new ioctl.

> Currently we have a struct vfio_pci_region stored in an array that we
> dynamically resize for device specific regions and the offset is
> determined statically from the array index.  We could easily specify an
> offset and alias field on that object if we wanted to make the address
> space more compact (without a maple tree) and facilitate multiple
> regions referencing the same device resource.  

vfio_pci_region isn't shared outside PCI, so it doesn't improve the
core/driver API. It isn't locked so it can't be changed dynmically.
It is based on region index so we still have the pgoff shifting and
poor pgoff untilization.

> There are a lot of new APIs being proposed here in the name of this
> idea that we shouldn't create new regions/sub-regions/alias-regions,
> which ultimately seems like a non-issue to me.  Thanks,

Two APIs, and the CAPS one is more for illustration - like if we had a
time machine how could we have desinged this from day 0 to be
extensible.

So I see add vfio_region_get_mmap or vfio_feature_create_region - same
number of APIs. <shrug>

Jason

