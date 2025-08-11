Return-Path: <kvm+bounces-54461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 868C6B217EE
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 00:07:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 659107B0D54
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 22:06:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6910E2D63E5;
	Mon, 11 Aug 2025 22:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UMPOE/U2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32EC71F5619
	for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 22:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754950041; cv=none; b=OvKAEyqtLFfRCX9Hlrccsg0hFiv2T0Fw3UHCTYT+vq5CCJvZnwbdSZUIz949ko7p53wEPOtCUacXTfG8atkFI/W/ZA5WXroU5ETso5LKhfhXDQPiXXoHKsgHDSZtqHc/ri5RPJrfoEBEHnyNgo+ZKO2LzELVy9K1lfmkFPa1Y6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754950041; c=relaxed/simple;
	bh=Z8ewOk4o/F1S41WUWqfhy7EE2RnrqwO5WMg3UC8XJBU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t9DvFQRcOblPSSfZuU7Al+PjX1ggRvQhBJuoXKMxfzAJwW89/k4qJYR9S6RKdLl/5gIimFGVvIwm/F3CscjFyglWVxEMDFiKEz7CGp6532ULd1b955KDMUNgJEyITSfVdJB8qodGVZOCEfP1a6HEr+W8CpRqWXlLNceSIAVST+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UMPOE/U2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754950037;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WshyWfAoF5D8VMLfSXyV3rA6ba2CaTBlYLdePlWlBTY=;
	b=UMPOE/U2QCUdQ6mfrFySpHcoOBSzi2TPVZGXXEkdLABkAg2nP5P5VXzuyYChVzjmTK4hQy
	F6qnya4cmFyQOcYTIx8YlYdukFffEt9x/jMb1pQmPFF1wAgwAoR1tuIvWyDRyhDoYDEMd3
	EuTBSdcCnfDjfGzXM5qchwh8ugqqR2c=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-654-B8XIIOd8MPO3KBuKoyvpEg-1; Mon, 11 Aug 2025 18:07:15 -0400
X-MC-Unique: B8XIIOd8MPO3KBuKoyvpEg-1
X-Mimecast-MFC-AGG-ID: B8XIIOd8MPO3KBuKoyvpEg_1754950034
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3e55b9cbb5eso741665ab.1
        for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 15:07:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754950034; x=1755554834;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WshyWfAoF5D8VMLfSXyV3rA6ba2CaTBlYLdePlWlBTY=;
        b=Q/gCe0zLVdElDZgGnZjwAi/j8o6LwZW0V2V5LWIujTf+U3Df5HHgv7dakrj4oKm/q9
         4rklQ1VrIjADIfgL6xVGihmtORSfG5+YmBJWMKtFp58onmThYmJAeUglbrVrBUgMzoix
         G2mJlnaOaxKOBXbsdAHqGDA4RL+NHQ35ctLTznFlzhb4sXV8xguJXZsiurr7LWrXJvoI
         eD4HxKN0uwYZg+C4pBry6/a6cQ4fXT9yLlrBJBoKRaGHO0T1Bd8I/RVtUBHxP8iSSwxK
         rvZWoiEX7np3LOCfYhq5lhUL8C4b/if8b9sc747ZyNqtYdavsknCKNeW42dN0q+PaHjE
         nw3Q==
X-Forwarded-Encrypted: i=1; AJvYcCW/tgjfIY3EOYVK2RYhbSuUV8P2j+4q8mku2dFMxQCKXofhHGaIfWR5Op+s8ZXeA2fueeA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwmvLL3tG73NPfYbb6ttv1AKnf1bTlpJMarUgrgAPJYKzrObm7b
	WteYcgDWTczAqOU/UvrAy1YQ1zXjkEkHYQe1wOWIdOc8PouUKaqRiL3YlKWhJ3FTawIkNBE1BSU
	3Zxpb+VDZMxw9B/JOi8LFoTd9Q8HzVUgm8bHhUtZKotKndUQS7QWfjw==
X-Gm-Gg: ASbGncuyOgM2pmHyTgKDYD3wXwY9Q1EAkw/sy6b2oTzKpFTMFzlt5yZTH2WGKzXqdGF
	dDpxwdTadHZqxbGQHD66OzLGZ9SutAaJYGbZ9WoTG57sPPw/sAUnhuHY14Ph6ys4maEMM2OvSsz
	1rdclz22WHl5bnQFTfsTC/RG7zPwhmwonXZ8fsJWsV7hZgyFL3KuAB7Ejy6hu4zxDc4xVqnqXYA
	Wn3kLkaRrxwTbyMwxzXrmp+bLLfG3YtepBju/uzrQPjkaje+ww0HVLFBFBBONNg2yQ+8q7miw/a
	s8kW08y2b2slROswWDZQBWnxrogbxSIW4WN+8j9zF6E=
X-Received: by 2002:a05:6e02:160e:b0:3dd:ce1c:f1bc with SMTP id e9e14a558f8ab-3e53e9e4d1bmr54173755ab.7.1754950034191;
        Mon, 11 Aug 2025 15:07:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHDrnhTiplamgPXIi40OPT1nggkH43HA31S1vap3RxKXjOJF0ULz38ExOujDzih885Wll6yLQ==
X-Received: by 2002:a05:6e02:160e:b0:3dd:ce1c:f1bc with SMTP id e9e14a558f8ab-3e53e9e4d1bmr54173475ab.7.1754950033484;
        Mon, 11 Aug 2025 15:07:13 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50ae9c36dc6sm2518406173.74.2025.08.11.15.07.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Aug 2025 15:07:12 -0700 (PDT)
Date: Mon, 11 Aug 2025 16:07:10 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, "Kumar, Praveen" <pravkmr@amazon.de>, "Adam,
 Mahmoud" <mngyadam@amazon.de>, "Woodhouse, David" <dwmw@amazon.co.uk>,
 "nagy@khwaternagy.com" <nagy@khwaternagy.com>
Subject: Re: [RFC PATCH 0/9] vfio: Introduce mmap maple tree
Message-ID: <20250811160710.174ca708.alex.williamson@redhat.com>
In-Reply-To: <20250811155558.GF377696@ziepe.ca>
References: <20250804104012.87915-1-mngyadam@amazon.de>
	<20250804124909.67462343.alex.williamson@redhat.com>
	<lrkyq5xf27ss7.fsf@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
	<20250805143134.GP26511@ziepe.ca>
	<lrkyqpld96a8a.fsf_-_@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
	<20250805130046.0527d0c7.alex.williamson@redhat.com>
	<80dc87730f694b2d6e6aabbd29df49cf3c7c44fb.camel@amazon.com>
	<20250806115224.GB377696@ziepe.ca>
	<cec694f109f705ab9e20c2641c1558aa19bcb25b.camel@amazon.com>
	<20250807130605.644ac9f6.alex.williamson@redhat.com>
	<20250811155558.GF377696@ziepe.ca>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 11 Aug 2025 12:55:58 -0300
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Thu, Aug 07, 2025 at 01:06:05PM -0600, Alex Williamson wrote:
>=20
> > So to a large extent I think we're causing our own grief here and I do
> > agree that if we created an API that allows new regions to be created
> > as lightweight (mmap-only) aliases of other regions, then we could just
> > re-use REGION_INFO with the new region index, get the offset/mmap
> > cookie, return -ENOSPC when we run out of indexes, and implement a
> > maple tree to get a more compact region space as a follow-on. =20
>=20
> That still needs to dynamically create mmap cookies - which is really the
> whole problem here. It is not so easy to just change the existing code
> with hardwired math converting pgoff to indexes to support multiple
> indexes.

We do this today with device specific regions, see
vfio_pci_core_register_dev_region().  We use this to provide several
additional regions for IGD.  If we had an interface for users to
trigger new regions we'd need some protection for exceeding the index
space (-ENOSPC), but adding a small number of regions is not a problem.
=20
> > > Well, we want to be able to WC map. Introducing "more cookies"
> > > again is just one way to get there. How do you create those
> > > cookies ? Upon request or each region automatically gets multiple
> > > with different attributes ? Do they represent entire regions or
> > > subsets ? etc...  =20
>=20
> It doesn't matter. Fixing how mmap works internally lets you use all
> of those options.

What exactly is the "fix how mmap works internally" proposal?

> > > > > =C2=A0* What I originally proposed ages ago when we discussed it
> > > > > at LPC which is to have an ioctl to create "subregions" of a
> > > > > region with different attributes. This means creating a new
> > > > > index (and a new corresponding "cookie") that represents a
> > > > > portion of an existing region
> > > > > with a different attribute set to be later used by mmap.   =20
> > > >=20
> > > > I never liked this, and it is still creating more cookies but
> > > > now with
> > > > weird hacky looking uapi.   =20
> > >=20
> > > "weird hacky looking" isn't a great way of understanding your
> > > objections :-) Yes, it's a bit more complicated, it allows to
> > > break down BARs basically into sub-regions with different
> > > attributes which is fairly close to what users really want to do,
> > > but it does complexify the UAPI a bit. =20
>=20
> I don't think we need sub-regions, it is too complicated in the kernel
> and pretty much useless.

So we infer that mmap cookies are an alias to an entire region.

> > > That said I'm not married to the idea, I just don't completely
> > > understand the alternative you are proposing...  =20
> >=20
> > Obviously Jason can correct if the interpretation I gleaned from the
> > previous thread above is incorrect, but I don't really see that new
> > region indexes are weird or hacky.  They fit into the REGION_INFO
> > scheme, they could be managed via DEVICE_FEATURE. =20
>=20
> I think I said before, adding more region indexes just makes a PITA
> for the driver to manage this.
>=20
> Indexes should refer to the physical object, the BAR in PCI. This is
> easy for the drivers to manage, any easy for userspace to understand.
>=20
> If you make dynamic indexes then every driver needs its own scheme to
> map them to physical indexes and we end up re-inventing the maple tree
> stuff without the cleanup or generality it brings.

I'd like to better understand why you believe this to be the case.

We have an existing ABI that maps BARs, config space, and VGA spaces to
fixed region indexes.  That "region index" to "device space" mapping
cannot change, but the offset of a given region and the total number of
regions is not ABI.  Therefore we can introduce an API where a user
says "give me a new region index that aliases region 0 with mmap
attribute FOO".  Maybe this returns to them region index 10.  The
DEVICE_INFO ioctl now reports more regions and REGION_INFO for index 10
provides the "mmap cookie", ie. offset, for this new region.

To a limited extent we can provide this within fixed index/pgoff
implementation (not ABI) we use now, but AIUI we could use a maple tree
to block out ranges and get more dense packing of regions across the
device fd.

This is compatible with existing userspace drivers, they don't invoke
any new APIs to create new regions and ideally they shouldn't have any
ABI dependencies on specific offsets (but we might provide limited
compatibility if that proves otherwise).  Drivers invoke the new API
specifically to get a region index with the desired mmap attribute and
use the existing REGION_INFO ioctl to get the offset of the region.

I don't understand how this introduces so much complication to drivers
that, for example, BAR0 might be accessible through region index 0 for
legacy mappings and index 10 for modified mmap attributes.  It might
make our unmap_mapping_range() call more complicated if we have a
non-contiguous mmap space, but I suspect we can just call it across the
furthest region extent.

Can you describe the driver scenario where having two different
mmap cookies for region index 0 makes things significantly easier for
drivers?

It seems like Ben's suggestion below of a call that modifies the mmap
attributes of an existing region is the least overall change to
existing drivers, though I'm not sure if that's what we should be
optimizing for.

> > > > > =C2=A0* A simpler approach which is to have an ioctl to change the
> > > > > attributes over a range of a region, so that *any* mapping of
> > > > > that range now uses that attribute. This can be done
> > > > > completely dynamically
> > > > > (see below).   =20
> > > >=20
> > > > And I really, really don't like this. The meaning of a memmap
> > > > cookie should not be changing dynamically. That is a bad
> > > > precedent.   =20
> > >=20
> > > What do you mean "a cookie changing dynamically" ? The cookie
> > > doesn't change. The attributes of a portion of a mapping change
> > > based on what userspace requested. =20
>=20
> Exactly. You have changed the underlying meaning of the cookie
> dynamicaly.

At the direction of the user.  Why is that a problem?

> > > The biggest advantage of that approach is that it completely
> > > precludes multiple conflicting mappings for a given region (at
> > > least within a given process, though it might be possible to
> > > extend it globally if we =20
>=20
> It doesn't. It just makes a messy uapi. At the time of mmap the vma
> would stil have to capture the attributes (no fault by fault!) into
> the VMA so we will see real users doing things like:
>=20
>  set to wc(cookie)
>  mmap(cookie + XXX)
>  set to !wc(cookie)
>  mmap(cookie + YY)
>=20
> And then if you try to debug this all our file/vma debug tools will
> just show cookie everywhere with no distinction that some VMAs are WC
> and some VMAs are !WC.
>=20
> Basically, it fundamentally breaks how pgoff is supposed to work here
> by making its meaning unstable.

We could require the mmap attribute is set before mmap and not changed
after, but yes, we don't get simultaneous mmaps with different
attributes without different cookies.

> > > want) which has been a concern expressed last time we talked
> > > about this by the folks from the ARM world. =20
> >=20
> > This precludes that a user could simultaneously have mappings to the
> > same device memory with different mmap attributes, =20
>=20
> Indeed, that is required for most HW. mlx5 for example has BARs that
> mix WC and non WC access modes. There are too few BARs for most HW to
> be able to dedicate an entire BAR to WC only.

So do we want to revisit whether an mmap attribute applies to a whole
region or only part of a region?  If the WC/UC ranges are spatially
separate, we could still handle that via a "modify mmap attribute
across sub-range of region" type API and userspace would be required to
do separate mmaps for the ranges.

> > > > The uAPI I prefer is a 'get region info2' which would be
> > > > simplified and allow userspace to pass in some flags. One of
> > > > those flags can be 'request wc'.   =20
> > >=20
> > > So talking of "weird hacky looking" having something called
> > > "get_info" taking "request" flags ... ahem ... :-) =20
> >=20
> > Yup... =20
>=20
> We've already confused returning the mmap cookie and the other
> information about the region. If you want to have flags to customize
> what mmap cookie is returned, this is the simplest answer.

I think either mechanism presented above is easier and more consistent
with the existing API.

> > > If what you really mean is that under the hood, a given "index"
> > > produces multiple "regions" (cookies) and "get_info2" allows to
> > > specify which one you want to get info about ? =20
>=20
> There is only one index. You can ask for different mmap options, and
> pgoff space for them is created dynamically.
>=20
> A "region" is not a mmap cookie, a region can have multiple mmap
> cookies.

Our ABI requires that BAR0 is region 0, but our API does not require
that BAR0 is only region 0.  Therefore I would say that a region is an
mmap cookie is more correct than a region can have multiple mmap
cookies in our current API.

> > > I disagree ... I find it actually cumbersome but we can just
> > > agree to disagree here and as I said, I don't care that much as
> > > long as there is no fundamental reason why it wouldn't work in
> > > the end. =20
> >=20
> > I'm not a fan of the REGION_INFO2 idea either.  A new region index
> > that provides an alias to another region with different mmap
> > semantics is much more intuitive in our existing UAPI, imo. =20
>=20
> It would not be another region index. That is the whole point. It is
> another pgoff for an existing index.

I think this is turning a region index into something it was not meant
to be.
=20
> > > Talking of cookie space, one thing we do need to preserve is the
> > > natural alignment to the BAR size. Userspace *will* do "|"
> > > instead of "+" on top of a cookie when mmap'ing (beyond mmap own
> > > alignment requirements). =20
>=20
> I think that's just wrong userspace, sorry. :(
>=20
> Still, we want to do this anyhow as the VMA alignment stuff Peter was
> working on also requires pgoff alignment.
>=20
> > > > > Now, within the context of VFIO PCI, since we use a fault
> > > > > handler, it
> > > > > doesn't even have to be done before mmap, we can just
> > > > > dynamically fault
> > > > > a given page with the right attributes (and zap mappings on
> > > > > attributes
> > > > > changes). I would go down that path personally and generalize
> > > > > the fault
> > > > > handler to all VFIO implementations.   =20
> > > >=20
> > > > Even worse. fault by fault changing of attributes? No way,
> > > > that's a completely crazy uAPI!   =20
> > >=20
> > > Why ? first userspace doesn't know or see it happens fault by
> > > fault (and it could be full established at mmap time in fact, but
> > > fault time makes the implementation a lot easier).
> > >=20
> > > Here you are conflating implementation details with "uAPI" ...
> > > uAPI is what is presented to userspace, which in this case is
> > > "set the attributes for this portion of a region". Then at map
> > > time, that portion of the region gets the requested attributes.
> > > There is nothing in the uAPI that carries the fact that it
> > > happens at fault time.
> > >=20
> > > You keep coming up with "ugly", "crazy" etc... without every
> > > actually spelling out the technical pro/cons that would actually
> > > substantiate those adjectives. Basically anything that isn't your=20
> > > get_region2 is "crazy" or "ugly" ... NIH syndrome ? =20
>=20
> This is not how the mm ever works *anywhere* in the main kernel, the
> only reason I can see you are propsing this because it avoids doing
> the cleanup work.
>=20
> It makes it impossible for userspace to get both WC and non-WC
> mappings. It makes it indeterminate what behavior userspace gets at
> every store operation. Real HW like mlx5 would need mixed WC/!WC on
> the same bar, so I view this as an entirely bad uAPI.
>=20
> > > > I don't know what this is about, I don't want to see APIs to
> > > > slice up regions. The vfio driver should report full regions in
> > > > the pgoff space, and VMAs should be linked to single maple tree
> > > > ranges only. If userspace wants something weird it can call
> > > > mmap multiple times and get different VMAs.   =20
> > >=20
> > > Why ? What are the pros/cons of each approach ? =20
>=20
> Extra complexity in the kernel, no usecase that isn't already handled
> by mmap directly.
>=20
> > > The big advantages of that latter approach is that it's very
> > > clear and simple for userspace (this bit of the BAR is meant to
> > > be WC) and completely
> > > avoids the multiple mapping problem. =20
>=20
> What is the "multiple mapping problem" ? We've discussed this
> extensively with ARM when we added WC support to KVM and I think we
> have a general agreement that multiple mappings are not something the
> kernel needs to actively prevent, in the limited case of WC and !WC.
>=20
> > >The inconvenient is that we have to generalize the fault handler
> > > mechanism to all backends, and it makes the multi-mapping
> > > impossible (in the maybe possible case where might want to allow
> > > it in some cases).
> > >=20
> > > Overall I find a lot of putting cart before horses here. Can we
> > > first agree
> > > on a clear definition of the uAPI first, then we can figure out
> > > the implementation details ? =20
> >=20
> > +1.  Thanks, =20
>=20
> All the uAPI proposals I've seen are all trying to work around the
> current state of the code.
>=20
> This is broadly what I've proposed consistently since the beginning,
> adjusted for the various remarks since:
>=20
> struct vfio_region_get_mmap {
> 	__u32	argsz;
> 	__u32	region_index; // only one, no aliases
> 	__u32   mmap_flags; // Set WC here
>=20
> 	__aligned_u64 region_size;
> 	__aligned_u64 fd_offset;
> };
>=20
> struct vfio_region_get_caps {
> 	__u32	argsz;
> 	__u32	region_index;
>=20
> 	__u32	region_flags; // READ/WRITE/etc
> 	__aligned_u64 region_size;
> 	__u32	cap_offset;	/* Offset within info struct
> of first cap */ };
>=20
> Alex, you pointed out that the parsing of the existing
> VFIO_DEVICE_GET_REGION_INFO has made it non-extendable. So the above
> two are creating a new extendable version that are replacements.

Can you be more specific on this claim?  We are no longer creating
static region indexes after the introduction of device specific
regions, but I don't see why we're not using the mechanisms of the
device specific region to create new region indexes with new offsets
that have specified mmap attributes here.  I imagine a DEVICE_FEATURE
that creates a new region, returning at least the region index,
DEVICE_INFO and REGION_INFO are updated to describe the new region, ie.
mmap-only, new offset/cookie, likely a capability embedded in the
REGION_INFO to provide introspection that this regions is an alias of
another.

> To avoid the naming confusion we have a specific ioctl to get
> mmap'able access, and another one for the cap list. I guess this also
> gives access to read/write so maybe the name needs more bikeshedding.

Largely duplicating REGION_INFO.

> Compared to the existing we add a single new concept, 'mmap_flags',
> which customizes how the fd_offset will behave with mmap. The kernel
> will internally de-duplicate region_index/mmap_flags -> fd_offset.

Ok.  The above could also de-duplicate.

> There is still one index per physical object (ie BAR) in the uAPI.

This is a non-requirement.

> We get one cookie that describes the VMA behavior exactly and
> immutably.

So does the above.

> The existing VFIO_DEVICE_GET_REGION_INFO is expressed in terms of the
> above two operations with mmap_flags =3D 0.

Still more complicated that new region index and existing ioctls.

> No new subregion concept. No alias region indexes. No changing the
> meaning of returned cookies.

The above doesn't change the meaning of returned cookies and I don't
see why the rest is an issue.

> We simply allow the userspace to request a mmap cookie for a region
> index that will always cause mmap to create a VMA with WC pgrot.

Or we allow userspace to request a region index that will always cause
mmap to create a vma with wc pgprot.

I see the device fd as segmented into regions.  The base set of regions
happen to have fixed definitions relative to device objects.

Introducing mmap cookies as a new mapping to a region where we can have
N:1 cookies to region really seems unnecessarily complicated vs a 1:1
cookie to region space.

> If we someday want cachable, or ARM's DEVICE_GRE or whatever we can
> trivially add more flags to mmap_flags and userspace can get
> more cookies.

Yup, same same.

> If we later decide we need to solve the ARM multi-device issue then we
> can cleanly extend an additional start/len to vfio_region_get_mmap
> which can ensure mmaps cookies are disjoint. This is not subregions,
> or new regions, this is just a cookie with a restriction.

No different if REGION_INFO supplies disjoint offset/length.

> In terms of implementation once you do the maple tree work that
> Mahmoud started we end up with vfio_region_get_mmap allocating a
> struct vfio_mmap for each unique region_index/mmap_flags and returning
> it to userspace.

And we get an entirely disjoint API from legacy vfio.
=20
> All the drivers will use the struct vfio_mmap everywhere instead of
> trying to decode pgoff to index with macros. Inside the vfio_mmap we
> store the index for the driver to use directly. The driver has a
> simple implementation, one index mapped to one physical resource. A
> pgprot value in the struct vfio_mmap to specify how to create the VMA.
>=20
> No dynamic driver aware regions or subregions.

Currently we have a struct vfio_pci_region stored in an array that we
dynamically resize for device specific regions and the offset is
determined statically from the array index.  We could easily specify an
offset and alias field on that object if we wanted to make the address
space more compact (without a maple tree) and facilitate multiple
regions referencing the same device resource.  This is all just
implementation decisions.  We also don't need to support read/write on
new regions, we could have them exist advertising only mmap support via
REGION_INFO, which simplifies and is consistent with the existing API.

There are a lot of new APIs being proposed here in the name of this
idea that we shouldn't create new regions/sub-regions/alias-regions,
which ultimately seems like a non-issue to me.  Thanks,

Alex


