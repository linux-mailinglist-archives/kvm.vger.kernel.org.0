Return-Path: <kvm+bounces-54250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DBD41B1D66F
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 13:13:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E48AE17120E
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 11:13:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 072F126B2CE;
	Thu,  7 Aug 2025 11:13:24 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7B521E32CF
	for <kvm@vger.kernel.org>; Thu,  7 Aug 2025 11:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.228.1.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754565203; cv=none; b=O2GzXHKWiCXfyxw0b0rRW31LlIr4QyXv8/s9rsmvIAOXsN5SopxOu/MAa6j8I7D87OCfDpUeSGmQBzXiPXM2u+D2m3RKJ5osNwkBcu0Om1hzihOeJFMV3GIsAHgLhhvc10rmNjMRmP3iDQulw27K5jGH5Yj8UzuNLcYOTNx5RLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754565203; c=relaxed/simple;
	bh=80TjaHDMcwcDSGVzQPOuJkpwNmi2tSczhTDqWUtMtHA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GmBhNAyU5tsXkx+4d/8yVXFoAE0cxksiizMdil4tADboe+gGMeFpZ8qGA6zl9wzuy6128m21vyUnRCDbIPXD0hcZcIc1TYyDFGipvxotLoNYE5rbD50HFzcCAvMMZDzz5RbalQow7dGhVNIg6sKA4nPBNHMBiPRkjmq63Ktsupg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.crashing.org; spf=pass smtp.mailfrom=kernel.crashing.org; arc=none smtp.client-ip=63.228.1.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.crashing.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.crashing.org
Received: from [IPv6:::1] (localhost [127.0.0.1])
	by gate.crashing.org (8.18.1/8.18.1/Debian-2) with ESMTP id 5778D7ZE2074367;
	Thu, 7 Aug 2025 03:13:41 -0500
Message-ID: <431011ca82cd7db46a704b43f122f845af0d26f1.camel@kernel.crashing.org>
Subject: Re: [RFC PATCH 0/9] vfio: Introduce mmap maple tree
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: kvm@vger.kernel.org
Cc: "Adam, Mahmoud" <mngyadam@amazon.de>
Date: Thu, 07 Aug 2025 18:13:07 +1000
In-Reply-To: <20250806115224.GB377696@ziepe.ca>
References: <20250804104012.87915-1-mngyadam@amazon.de>
	 <20250804124909.67462343.alex.williamson@redhat.com>
	 <lrkyq5xf27ss7.fsf@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
	 <20250805143134.GP26511@ziepe.ca>
	 <lrkyqpld96a8a.fsf_-_@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
	 <20250805130046.0527d0c7.alex.williamson@redhat.com>
	 <80dc87730f694b2d6e6aabbd29df49cf3c7c44fb.camel@amazon.com>
	 <20250806115224.GB377696@ziepe.ca>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Re-sending with the list this time. Also I've fixed my email so back to
benh@kernel.crashing.org=C2=A0:)


=C2=A0=C2=A0 1. On Wed, 2025-08-06 at 08:52 -0300, Jason Gunthorpe wrote:
>=20
>=20
> On Tue, Aug 05, 2025 at 10:19:29PM +0000, Herrenschmidt, Benjamin
> wrote:
> >=20
> > Right, that's my main objection here too. The way I see things is
> > that
> > we are somewhat conflating two different issues:
> >=20
> > =C2=A0* Wanting to change the index -> offset "cooking" mapping to
> > create a
> > more dense cookie space
> >=20
> > =C2=A0* Wanting to define attributes for mappings...
>=20
> I don't think that is right. The first is, yes, creating more dense
> cookie space which I think we need to do the second item, which is
> really 'add 2x more cookies, or maybe more'.

Hrm... the end *goal* is to define attribute for mappings. This whole
conversation is "we want to map things WC". "defining more cookies" is
a possible *how* here.

The reason I don't like presenting it that way is that you conflate
what we are trying to achieve with an implementation detail.

By defining more cookies, what you mean is creating multiple cookies
pointing to the same physical regions with different mapping
attributes, correct ? This is very similar to my sub-region idea in
practice I think unless I misunderstand.

> One of the things we want to do with more cookies is to create unique
> cookies for WC mmap requests.

Well, we want to be able to WC map. Introducing "more cookies" again is
just one way to get there. How do you create those cookies ? Upon
request or each region automatically gets multiple with different
attributes ? Do they represent entire regions or subsets ? etc...=20

Here too, I'd rather we start from a clear idea of the actual UAPI we
want, then we can look at how it gets plumbed under the hood.

> I'm not convinced we should try to introduce more cookies without
> improving the infrastructure. It is already pretty weak, I think
> trying to mangle the indexes or something "clever" would result in
> something even harder to maintain even if it might be less patches to
> write in the first place.

VFIO-pci already allocates dynamic indexes but yes, I don't disagree
that cleaning up the infrastructure first is a good idea. However, I
would prefer if we had a clearer idea of the end goal first,
specifically the details/shape of the UAPI and underlying structure
*before* we start hacking at this all.

> > =C2=A0* What I originally proposed ages ago when we discussed it at LPC
> > which is to have an ioctl to create "subregions" of a region with
> > different attributes. This means creating a new index (and a new
> > corresponding "cookie") that represents a portion of an existing
> > region
> > with a different attribute set to be later used by mmap.
>=20
> I never liked this, and it is still creating more cookies but now
> with
> weird hacky looking uapi.

"weird hacky looking" isn't a great way of understanding your
objections :-) Yes, it's a bit more complicated, it allows to break
down BARs basically into sub-regions with different attributes which is
fairly close to what users really want to do, but it does complexify
the UAPI a bit.

That said I'm not married to the idea, I just don't completely
understand the alternative you are proposing...=20

> > =C2=A0* A simpler approach which is to have an ioctl to change the
> > attributes over a range of a region, so that *any* mapping of that
> > range now uses that attribute. This can be done completely
> > dynamically
> > (see below).
>=20
> And I really, really don't like this. The meaning of a memmap cookie
> should not be changing dynamically. That is a bad precedent.

What do you mean "a cookie changing dynamically" ? The cookie doesn't
change. The attributes of a portion of a mapping change based on what
userspace requested. It is also a pretty close match to the use case
which is to define that a given part of the device MMIO space is meant
to be accessed WC. There is no fundamental change to the "cookies".

The biggest advantage of that approach is that it completely precludes
multiple conflicting mappings for a given region (at least within a
given process, though it might be possible to extend it globally if we
want) which has been a concern expressed last time we talked about this
by the folks from the ARM world.

> The uAPI I prefer is a 'get region info2' which would be simplified
> and allow userspace to pass in some flags. One of those flags can be
> 'request wc'.

So talking of "weird hacky looking" having something called "get_info"
taking "request" flags ... ahem ... :-)

If what you really mean is that under the hood, a given "index"
produces multiple "regions" (cookies) and "get_info2" allows to specify
which one you want to get info about ?

I mean ... this would work. But I don't see how it's superior to any of
the above. I don't care *that much*, but it does make it a bit harder
to avoid the multiple mappings issue and will waste much more cookie
space than any of the alternatives.

> This is logical and future extensible.

I disagree ... I find it actually cumbersome but we can just agree to
disagree here and as I said, I don't care that much as long as there is
no fundamental reason why it wouldn't work in the end.

Talking of cookie space, one thing we do need to preserve is the
natural alignment to the BAR size. Userspace *will* do "|" instead of
"+" on top of a cookie when mmap'ing (beyond mmap own alignment
requirements).

> > Now, within the context of VFIO PCI, since we use a fault handler,
> > it
> > doesn't even have to be done before mmap, we can just dynamically
> > fault
> > a given page with the right attributes (and zap mappings on
> > attributes
> > changes). I would go down that path personally and generalize the
> > fault
> > handler to all VFIO implementations.
>=20
> Even worse. fault by fault changing of attributes? No way, that's a
> completely crazy uAPI!

Why ? first userspace doesn't know or see it happens fault by fault
(and it could be full established at mmap time in fact, but fault time
makes the implementation a lot easier).

Here you are conflating implementation details with "uAPI" ... uAPI is
what is presented to userspace, which in this case is "set the
attributes for this portion of a region". Then at map time, that
portion of the region gets the requested attributes. There is nothing
in the uAPI that carries the fact that it happens at fault time.

You keep coming up with "ugly", "crazy" etc... without every actually
spelling out the technical pro/cons that would actually substantiate
those adjectives. Basically anything that isn't your=20
get_region2 is "crazy" or "ugly" ... NIH syndrome ?

> > For example, if I put a 4k WC page in a middle of index 1, then the
> > tree would have an entry for before the WC page, an entry for the
> > WC
> > page and an entry for after. They all point to region index 1, but
> > the
> > fault handler can use the maple tree to find the right attributes
> > at
> > fault time for the page.
>=20
> I don't know what this is about, I don't want to see APIs to slice up
> regions. The vfio driver should report full regions in the pgoff
> space, and VMAs should be linked to single maple tree ranges only. If
> userspace wants something weird it can call mmap multiple times and
> get different VMAs.

Why ? What are the pros/cons of each approach ?

> Each VMA should refer to a single vfio_mmap struct with the same
> pgprot for every page. It is easy and simple.

Maybe ... we have precedents of doing differently but I don't have big
beef in that game.

The big advantages of that latter approach is that it's very clear and
simple for userspace (this bit of the BAR is meant to be WC) and
completely
avoids the multiple mapping problem. The inconvenient is that we have
to
generalize the fault handler mechanism to all backends, and it makes
the
multi-mapping impossible (in the maybe possible case where might want
to
allow it in some cases).

Overall I find a lot of putting cart before horses here. Can we first
agree
on a clear definition of the uAPI first, then we can figure out the
implementation details ?

Cheers,
Ben.



