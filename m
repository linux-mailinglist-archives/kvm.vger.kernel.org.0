Return-Path: <kvm+bounces-54416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A337B21188
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 18:20:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 015E3504805
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 16:06:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C59BA2C21D4;
	Mon, 11 Aug 2025 15:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="er6svQKy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2408296BA2
	for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 15:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754927764; cv=none; b=YcDegwZuEpOq+0Cx9kx4JG0quBR8lSi173F+2btfpek7gm4UvpkgmUi/mrjvN1N6dxwR+BmQBeigBMFXXnmUDQSh2lvidr98XlhJ2MUByGSAbVVuZfhKs1aUP1lc3oK8Q7qE7BTEFE2ckXMa+zRaILkpPvzE1sgZWHBWe1PPR3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754927764; c=relaxed/simple;
	bh=Wk/0igpH6J2nYknxk2p2T6J5el/kfFJ0YfyF9gHMzBU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GtGv5w+HLLtkcPpgTj+UaKL3L5zPdJ102cNvj3uLofj6YCy4kTM4FmhLN3Og/qSg5DswqUYR+E/05gklK2encA098iUPAPw1wCcZGf3fPa/pLqCWgKRUsfkFDE6XcTT+AFTBRcW8/InPMsPrA+pzrSdZozN8uZQKG4MWABbREC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=er6svQKy; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-7072ed7094aso42922306d6.1
        for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 08:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1754927761; x=1755532561; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zsejvaWwyq36fSrz052SvQxpf//SMI3MnHJNuBxStAE=;
        b=er6svQKyPQfyTsdt0uAsI6yzwfOt0TcbMEs0mi3crNT/qB78HyZgteXsifGpNdiRRj
         As1ru195g1i8YExJ2LRKV/PDy4dMOGmByUytLzLeY7hc7faagOw8Ej4PZqbeD9dk4eqN
         zIlx5+Z4co0NWJiPFAc74D0tSjvxdhZeCksRjihSGZhnlk7+/i4BRGxD9SydmpKMDt6n
         FVUf/Slcp5Dga3JCuMbcZWrS4kmDitkW3Gr65Yx7Yt3+R7ECgMBn0MKMDSEgc4obxYYF
         h9bpSZdkxQdmprH5bIWTUu5kkNHagdFlRvyMG8KGVk71AsYjbczu6B/vkrZ5WD6XVcRD
         hctg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754927761; x=1755532561;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zsejvaWwyq36fSrz052SvQxpf//SMI3MnHJNuBxStAE=;
        b=a+ypyVixKJ/XP5ElRevdTaMxhURYQQEZM7hKRoSzPV4h5LolFY1W6P6WQhwwJ6yXBm
         gaZzxnFWv8e7+VOTj6bHJA9tATybIdIOB5P7mdJdc13MEbLIIHyWolOWFJGV5S9azok+
         gcN9KFD/H2B6FOJYBZP1l7l307y7mibdM5bddZJJPzrMxP51sZHtOTZVQGcixL8zwbzl
         KF4J/dETGfEJbXp5eBC8NvWP2btb15+hYcAEPV+nFdow7tsV/pfV312wj0EEoA/Clbhs
         jP0a6e2orLvQX9SnFZ1XgYdpupyh6+8ekguzl4Ap2h4JHC3gbZ8UbMBMVxAunN4qXru3
         vBUw==
X-Forwarded-Encrypted: i=1; AJvYcCWSl788fQy82pD5zYUcL5iEvDgvGLLH82yYwFJrGtermNJ2OuLqn6vFk8YgxOLAKrmwuXs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzbNrpD/mQlg/5/2jkKpCE6Eq7Q4LpgORfXz3z9A1SCw/ej+ZSd
	zB+Rg2QUEdu5TW229OIgWVsLB4hRg3uPs+5Pd2R5HuSIyiOm3YY3QqO86sj3lKoZw8s=
X-Gm-Gg: ASbGnculLopPmu04ONykC2Dn//EtQyWe34ixJar9+ckvjZIEs2PzjxS0DUGHfpporcg
	Vqyw80BrZPFXOLvUWrpigq4jBZqnM3o58MwnPwFKqDaYtgSnEnuRY5DOH2G+orwHexGJVmb+tgt
	JPR3E1KC2hsIvWSZ1dPvmby/e5x8pDIROEslb4rkbx7gjXdUbGxdO22ZNKz/AMAogr4Kq+BgME2
	un+79Bcbxuf6AeNs/VuEboCWBT99usOqEXJouOTBCsaDxm8G9gppb+olcujNrB3y5AEUSbrhAHg
	S0Y3LVM6z2mInj0pns6cbNePlvq7nAwlR0c+uwI4sdnBlKYMEap//+NOgiDmnQMMUe2UISybWT/
	0l58Bhqmg7/Nup4rYDdJLrPLeaLetw86W6KlxBGIpsNgPxgKDGDVPQVuODT87SjBGXELP
X-Google-Smtp-Source: AGHT+IEHwjhhdj+hIekLIPL5JWvY545oij2zTEKsJMCLJVPqYIneue/XpiU2fHytmnjfkCDR+l2cSQ==
X-Received: by 2002:a05:6214:dc9:b0:702:d7ff:27f9 with SMTP id 6a1803df08f44-7099a3339bdmr151284096d6.24.1754927760291;
        Mon, 11 Aug 2025 08:56:00 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077ca3c73asm156288626d6.32.2025.08.11.08.55.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Aug 2025 08:55:59 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1ulUsQ-00000002TR3-3qZD;
	Mon, 11 Aug 2025 12:55:58 -0300
Date: Mon, 11 Aug 2025 12:55:58 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Kumar, Praveen" <pravkmr@amazon.de>,
	"Adam, Mahmoud" <mngyadam@amazon.de>,
	"Woodhouse, David" <dwmw@amazon.co.uk>,
	"nagy@khwaternagy.com" <nagy@khwaternagy.com>
Subject: Re: [RFC PATCH 0/9] vfio: Introduce mmap maple tree
Message-ID: <20250811155558.GF377696@ziepe.ca>
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
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250807130605.644ac9f6.alex.williamson@redhat.com>

On Thu, Aug 07, 2025 at 01:06:05PM -0600, Alex Williamson wrote:

> So to a large extent I think we're causing our own grief here and I do
> agree that if we created an API that allows new regions to be created
> as lightweight (mmap-only) aliases of other regions, then we could just
> re-use REGION_INFO with the new region index, get the offset/mmap
> cookie, return -ENOSPC when we run out of indexes, and implement a
> maple tree to get a more compact region space as a follow-on.

That still needs to dynamically create mmap cookies - which is really the
whole problem here. It is not so easy to just change the existing code
with hardwired math converting pgoff to indexes to support multiple
indexes.

> > Well, we want to be able to WC map. Introducing "more cookies" again is
> > just one way to get there. How do you create those cookies ? Upon
> > request or each region automatically gets multiple with different
> > attributes ? Do they represent entire regions or subsets ? etc... 

It doesn't matter. Fixing how mmap works internally lets you use all
of those options.

> 
> > > >  * What I originally proposed ages ago when we discussed it at LPC
> > > > which is to have an ioctl to create "subregions" of a region with
> > > > different attributes. This means creating a new index (and a new
> > > > corresponding "cookie") that represents a portion of an existing
> > > > region
> > > > with a different attribute set to be later used by mmap.  
> > > 
> > > I never liked this, and it is still creating more cookies but now
> > > with
> > > weird hacky looking uapi.  
> > 
> > "weird hacky looking" isn't a great way of understanding your
> > objections :-) Yes, it's a bit more complicated, it allows to break
> > down BARs basically into sub-regions with different attributes which is
> > fairly close to what users really want to do, but it does complexify
> > the UAPI a bit.

I don't think we need sub-regions, it is too complicated in the kernel
and pretty much useless.

> > That said I'm not married to the idea, I just don't completely
> > understand the alternative you are proposing... 
> 
> Obviously Jason can correct if the interpretation I gleaned from the
> previous thread above is incorrect, but I don't really see that new
> region indexes are weird or hacky.  They fit into the REGION_INFO
> scheme, they could be managed via DEVICE_FEATURE.

I think I said before, adding more region indexes just makes a PITA
for the driver to manage this.

Indexes should refer to the physical object, the BAR in PCI. This is
easy for the drivers to manage, any easy for userspace to understand.

If you make dynamic indexes then every driver needs its own scheme to
map them to physical indexes and we end up re-inventing the maple tree
stuff without the cleanup or generality it brings.

> > > >  * A simpler approach which is to have an ioctl to change the
> > > > attributes over a range of a region, so that *any* mapping of that
> > > > range now uses that attribute. This can be done completely
> > > > dynamically
> > > > (see below).  
> > > 
> > > And I really, really don't like this. The meaning of a memmap cookie
> > > should not be changing dynamically. That is a bad precedent.  
> > 
> > What do you mean "a cookie changing dynamically" ? The cookie doesn't
> > change. The attributes of a portion of a mapping change based on what
> > userspace requested.

Exactly. You have changed the underlying meaning of the cookie
dynamicaly.

> > The biggest advantage of that approach is that it completely precludes
> > multiple conflicting mappings for a given region (at least within a
> > given process, though it might be possible to extend it globally
> > if we

It doesn't. It just makes a messy uapi. At the time of mmap the vma
would stil have to capture the attributes (no fault by fault!) into
the VMA so we will see real users doing things like:

 set to wc(cookie)
 mmap(cookie + XXX)
 set to !wc(cookie)
 mmap(cookie + YY)

And then if you try to debug this all our file/vma debug tools will
just show cookie everywhere with no distinction that some VMAs are WC
and some VMAs are !WC.

Basically, it fundamentally breaks how pgoff is supposed to work here
by making its meaning unstable.

> > want) which has been a concern expressed last time we talked about this
> > by the folks from the ARM world.
> 
> This precludes that a user could simultaneously have mappings to the
> same device memory with different mmap attributes,

Indeed, that is required for most HW. mlx5 for example has BARs that
mix WC and non WC access modes. There are too few BARs for most HW to
be able to dedicate an entire BAR to WC only.

> > > The uAPI I prefer is a 'get region info2' which would be simplified
> > > and allow userspace to pass in some flags. One of those flags can be
> > > 'request wc'.  
> > 
> > So talking of "weird hacky looking" having something called "get_info"
> > taking "request" flags ... ahem ... :-)
> 
> Yup...

We've already confused returning the mmap cookie and the other
information about the region. If you want to have flags to customize
what mmap cookie is returned, this is the simplest answer.

> > If what you really mean is that under the hood, a given "index"
> > produces multiple "regions" (cookies) and "get_info2" allows to specify
> > which one you want to get info about ?

There is only one index. You can ask for different mmap options, and
pgoff space for them is created dynamically.

A "region" is not a mmap cookie, a region can have multiple mmap cookies.

> > I disagree ... I find it actually cumbersome but we can just agree to
> > disagree here and as I said, I don't care that much as long as there is
> > no fundamental reason why it wouldn't work in the end.
> 
> I'm not a fan of the REGION_INFO2 idea either.  A new region index that
> provides an alias to another region with different mmap semantics is
> much more intuitive in our existing UAPI, imo.

It would not be another region index. That is the whole point. It is
another pgoff for an existing index.

> > Talking of cookie space, one thing we do need to preserve is the
> > natural alignment to the BAR size. Userspace *will* do "|" instead of
> > "+" on top of a cookie when mmap'ing (beyond mmap own alignment
> > requirements).

I think that's just wrong userspace, sorry. :(

Still, we want to do this anyhow as the VMA alignment stuff Peter was
working on also requires pgoff alignment.

> > > > Now, within the context of VFIO PCI, since we use a fault handler,
> > > > it
> > > > doesn't even have to be done before mmap, we can just dynamically
> > > > fault
> > > > a given page with the right attributes (and zap mappings on
> > > > attributes
> > > > changes). I would go down that path personally and generalize the
> > > > fault
> > > > handler to all VFIO implementations.  
> > > 
> > > Even worse. fault by fault changing of attributes? No way, that's a
> > > completely crazy uAPI!  
> > 
> > Why ? first userspace doesn't know or see it happens fault by fault
> > (and it could be full established at mmap time in fact, but fault time
> > makes the implementation a lot easier).
> > 
> > Here you are conflating implementation details with "uAPI" ... uAPI is
> > what is presented to userspace, which in this case is "set the
> > attributes for this portion of a region". Then at map time, that
> > portion of the region gets the requested attributes. There is nothing
> > in the uAPI that carries the fact that it happens at fault time.
> > 
> > You keep coming up with "ugly", "crazy" etc... without every actually
> > spelling out the technical pro/cons that would actually substantiate
> > those adjectives. Basically anything that isn't your 
> > get_region2 is "crazy" or "ugly" ... NIH syndrome ?

This is not how the mm ever works *anywhere* in the main kernel, the
only reason I can see you are propsing this because it avoids doing
the cleanup work.

It makes it impossible for userspace to get both WC and non-WC
mappings. It makes it indeterminate what behavior userspace gets at
every store operation. Real HW like mlx5 would need mixed WC/!WC on
the same bar, so I view this as an entirely bad uAPI.

> > > I don't know what this is about, I don't want to see APIs to slice up
> > > regions. The vfio driver should report full regions in the pgoff
> > > space, and VMAs should be linked to single maple tree ranges only. If
> > > userspace wants something weird it can call mmap multiple times and
> > > get different VMAs.  
> > 
> > Why ? What are the pros/cons of each approach ?

Extra complexity in the kernel, no usecase that isn't already handled
by mmap directly.

> > The big advantages of that latter approach is that it's very clear and
> > simple for userspace (this bit of the BAR is meant to be WC) and
> > completely
> > avoids the multiple mapping problem.

What is the "multiple mapping problem" ? We've discussed this
extensively with ARM when we added WC support to KVM and I think we
have a general agreement that multiple mappings are not something the
kernel needs to actively prevent, in the limited case of WC and !WC.

> >The inconvenient is that we have to generalize the fault handler
> > mechanism to all backends, and it makes the multi-mapping
> > impossible (in the maybe possible case where might want to allow
> > it in some cases).
> > 
> > Overall I find a lot of putting cart before horses here. Can we first
> > agree
> > on a clear definition of the uAPI first, then we can figure out the
> > implementation details ?
> 
> +1.  Thanks,

All the uAPI proposals I've seen are all trying to work around the
current state of the code.

This is broadly what I've proposed consistently since the beginning,
adjusted for the various remarks since:

struct vfio_region_get_mmap {
	__u32	argsz;
	__u32	region_index; // only one, no aliases
	__u32   mmap_flags; // Set WC here

	__aligned_u64 region_size;
	__aligned_u64 fd_offset;
};

struct vfio_region_get_caps {
	__u32	argsz;
	__u32	region_index;

	__u32	region_flags; // READ/WRITE/etc
	__aligned_u64 region_size;
	__u32	cap_offset;	/* Offset within info struct of first cap */
};

Alex, you pointed out that the parsing of the existing
VFIO_DEVICE_GET_REGION_INFO has made it non-extendable. So the above
two are creating a new extendable version that are replacements.

To avoid the naming confusion we have a specific ioctl to get
mmap'able access, and another one for the cap list. I guess this also
gives access to read/write so maybe the name needs more bikeshedding.

Compared to the existing we add a single new concept, 'mmap_flags',
which customizes how the fd_offset will behave with mmap. The kernel
will internally de-duplicate region_index/mmap_flags -> fd_offset.

There is still one index per physical object (ie BAR) in the uAPI.

We get one cookie that describes the VMA behavior exactly and immutably.

The existing VFIO_DEVICE_GET_REGION_INFO is expressed in terms of the
above two operations with mmap_flags = 0.

No new subregion concept. No alias region indexes. No changing the
meaning of returned cookies.

We simply allow the userspace to request a mmap cookie for a region
index that will always cause mmap to create a VMA with WC pgrot.

If we someday want cachable, or ARM's DEVICE_GRE or whatever we can
trivially add more flags to mmap_flags and userspace can get
more cookies.

If we later decide we need to solve the ARM multi-device issue then we
can cleanly extend an additional start/len to vfio_region_get_mmap
which can ensure mmaps cookies are disjoint. This is not subregions,
or new regions, this is just a cookie with a restriction.

In terms of implementation once you do the maple tree work that
Mahmoud started we end up with vfio_region_get_mmap allocating a
struct vfio_mmap for each unique region_index/mmap_flags and returning
it to userspace.

All the drivers will use the struct vfio_mmap everywhere instead of
trying to decode pgoff to index with macros. Inside the vfio_mmap we
store the index for the driver to use directly. The driver has a
simple implementation, one index mapped to one physical resource. A
pgprot value in the struct vfio_mmap to specify how to create the VMA.

No dynamic driver aware regions or subregions.

Jason

