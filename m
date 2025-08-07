Return-Path: <kvm+bounces-54269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17370B1DD50
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 21:06:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C5C3D3B238B
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 19:06:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02B7E2737E7;
	Thu,  7 Aug 2025 19:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NwSkcIKV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08448F6E
	for <kvm@vger.kernel.org>; Thu,  7 Aug 2025 19:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754593585; cv=none; b=KwO9NeefZMMHipfFooJkoEExDTDNfwqQJiu1vAZnizDWUru9Ygn0lR6i6PuilhYrFzigkLp0A7TRusQe9swriaYdygF63lfV2IegMCWAgKKrGXa3NbbmUShX2RPtOPHptlN4BUNzV6gdHqCbbfAYz0jX1rfLn4+6V6OSGh0wxKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754593585; c=relaxed/simple;
	bh=7MvZwMcVQ6Wv2mbmLGmOLey7Ffk23UHWkrQ1PyAbYx4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R8nLbfAe62HpCOqLEzfd94nOaMd2MKf4Gz8MNfgu/SpzNGUqmgbiap16Ekk7kUlstu7FdzrZA/kcyvB5wIi5PRhXNTuiSDJHWMYck3A4rRgq2NNahSoS2+ztXCsDEOAt/wBxEMxitnGWO8kdzgKqLsJvC48SAx63NqrFz0jYHtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NwSkcIKV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754593577;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9LgriUJ3pf7AiFvFu6qIsSz0iwZOZ9G0kjBWjQ05ooA=;
	b=NwSkcIKVa4ajOnSHRAfYdAn75UfmqWashmORdcqOQsUrQLrAO0Mvkv6CBF3AJUkQ7jV+/p
	swVLOaZAOvXJBSIi6rDNJmQ0VSqdzRgQUMtKZYRx/jrfvTnMxZqgaHGOsG/0as/pS7pf6T
	A7VgLYChBtUbmc6JI4edPdHVu/T5vJk=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-45-dXj4pR4EPne8iswAueMUjg-1; Thu, 07 Aug 2025 15:06:10 -0400
X-MC-Unique: dXj4pR4EPne8iswAueMUjg-1
X-Mimecast-MFC-AGG-ID: dXj4pR4EPne8iswAueMUjg_1754593569
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3e40c6fc7ccso1891815ab.2
        for <kvm@vger.kernel.org>; Thu, 07 Aug 2025 12:06:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754593569; x=1755198369;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9LgriUJ3pf7AiFvFu6qIsSz0iwZOZ9G0kjBWjQ05ooA=;
        b=QBmfV429maXg3TUJehb642rXmugPyRMOBegMhINVLeCcircvJg8fNyXsznqC0NrZh4
         2cBxH2lPj9bQVDqYulohMJ9JE1CfqvNDYqiL4yclhGPsyYNQokIPqpx78VWeDgfJWsab
         mV5i/6Vah3wd8iACQKWblwNr4no2o58E5lxUZbRBoAwG0yFznR2YJ6vtKjczEsEYDDrn
         z/zd8S0lPFPbnGNPa4aOlJkVYqq0JhmlqHBk6a+T+4WuwAEXmASBElbWtWh05+iezTvl
         q3OCSLfcyU/D6mdj7TmWnMahFec6idMYnMp/fYBFiAYNjUwIJ4hmDBz9O1zJwcuO06E4
         batw==
X-Gm-Message-State: AOJu0YymSofdaALn+lEyQqk2h6STors3CcwF0jChs8lqPQ7Hd9WMaxYA
	qCk4zcNSLNidrGWOMTDxMooJWFI9pZrBsAnuk7KenEoxmZSweWV6fMmhRPOXWXo7Hle5OwkjP0U
	aQ77QOWLq6z57jMwsTPLp9GabfZuu+nK9uPqCQH9z4tHlSFMI2GaaTg==
X-Gm-Gg: ASbGnctyMhvtF/ulmlQCfBEw32SqnxynmbHD1tmgXSiJvEMczex3Kjod8wnCbZ+0MhD
	aWnXNv+kU3xqcaHNE9UEKqAl5fwHkEWhblOE8GLPEQn1MFF37N6xuyDRj8UDJWHtac5oAGg239e
	q3Q6VyT0H938EHHNpKN6+ipt+eo+B8d1a07vc83CSD7AbS7G5fZHWWsm9yf8x2Na13yAFgO5utu
	tcRBa4waBOoo2m0ArkgKt1Mtw1Q1L2kQx/b7om51yAiOrM6QELqSNfo6MX2Awv2I9UV4+s7SEAq
	3X+IMF0PcvXFwpa6FoXtIecmyT9y6hbEFbrUfeWj4x0=
X-Received: by 2002:a05:6602:6d0b:b0:881:659f:cd6c with SMTP id ca18e2360f4ac-883f11bbc8amr8018639f.1.1754593569032;
        Thu, 07 Aug 2025 12:06:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGw3XhWUZGKmVArF87IErqCKgxMRnatMNc5Wc3WngUy6DYUKrGLkAZnIp8jYIPsRA5uda3KQw==
X-Received: by 2002:a05:6602:6d0b:b0:881:659f:cd6c with SMTP id ca18e2360f4ac-883f11bbc8amr8016739f.1.1754593568398;
        Thu, 07 Aug 2025 12:06:08 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-881738bd93fsm394978039f.25.2025.08.07.12.06.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Aug 2025 12:06:07 -0700 (PDT)
Date: Thu, 7 Aug 2025 13:06:05 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Kumar, Praveen"
 <pravkmr@amazon.de>, "Adam, Mahmoud" <mngyadam@amazon.de>, "Woodhouse,
 David" <dwmw@amazon.co.uk>, "nagy@khwaternagy.com" <nagy@khwaternagy.com>,
 "jgg@ziepe.ca" <jgg@ziepe.ca>
Subject: Re: [RFC PATCH 0/9] vfio: Introduce mmap maple tree
Message-ID: <20250807130605.644ac9f6.alex.williamson@redhat.com>
In-Reply-To: <cec694f109f705ab9e20c2641c1558aa19bcb25b.camel@amazon.com>
References: <20250804104012.87915-1-mngyadam@amazon.de>
	<20250804124909.67462343.alex.williamson@redhat.com>
	<lrkyq5xf27ss7.fsf@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
	<20250805143134.GP26511@ziepe.ca>
	<lrkyqpld96a8a.fsf_-_@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
	<20250805130046.0527d0c7.alex.williamson@redhat.com>
	<80dc87730f694b2d6e6aabbd29df49cf3c7c44fb.camel@amazon.com>
	<20250806115224.GB377696@ziepe.ca>
	<cec694f109f705ab9e20c2641c1558aa19bcb25b.camel@amazon.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 7 Aug 2025 08:12:04 +0000
"Herrenschmidt, Benjamin" <benh@amazon.com> wrote:

> Re-sending with the list this time. Also I've fixed my email so back to
> benh@kernel.crashing.org :)

Replacing the To: in this reply as well, hopefully it reaches you.

>    1. On Wed, 2025-08-06 at 08:52 -0300, Jason Gunthorpe wrote:
> >=20
> >=20
> > On Tue, Aug 05, 2025 at 10:19:29PM +0000, Herrenschmidt, Benjamin
> > wrote: =20
> > >=20
> > > Right, that's my main objection here too. The way I see things is
> > > that
> > > we are somewhat conflating two different issues:
> > >=20
> > > =C2=A0* Wanting to change the index -> offset "cooking" mapping to
> > > create a
> > > more dense cookie space
> > >=20
> > > =C2=A0* Wanting to define attributes for mappings... =20
> >=20
> > I don't think that is right. The first is, yes, creating more dense
> > cookie space which I think we need to do the second item, which is
> > really 'add 2x more cookies, or maybe more'. =20
>=20
> Hrm... the end *goal* is to define attribute for mappings. This whole
> conversation is "we want to map things WC". "defining more cookies" is
> a possible *how* here.
>=20
> The reason I don't like presenting it that way is that you conflate
> what we are trying to achieve with an implementation detail.
>=20
> By defining more cookies, what you mean is creating multiple cookies
> pointing to the same physical regions with different mapping
> attributes, correct ? This is very similar to my sub-region idea in
> practice I think unless I misunderstand.

I agree and I think this is likely heading down the path of rehashing
the previous thread

https://lore.kernel.org/kvm/20240801141914.GC3030761@ziepe.ca/

I honestly still don't have a firm idea how "mmap cookies" are
different from some sort of extended region ID space, whether it's
sub-regions, device specific regions, or just dynamic regions.  I think
there is an underlying desire to say, for example, that "region 0" is
BAR0, period, full stop, but there should be a way to get multiple mmap
cookies to region 0 with different mmap semantics.  Of course
REGION_INFO provides the default mmap cookie via the offset field, but
since we don't want to dynamically create region N+1 (under this
interpretation) as an alias of region 0 with different mmap semantics,
now we're stuck in a conundrum of how to describe different mmap cookies
for one region.

So to a large extent I think we're causing our own grief here and I do
agree that if we created an API that allows new regions to be created
as lightweight (mmap-only) aliases of other regions, then we could just
re-use REGION_INFO with the new region index, get the offset/mmap
cookie, return -ENOSPC when we run out of indexes, and implement a
maple tree to get a more compact region space as a follow-on.

> > One of the things we want to do with more cookies is to create unique
> > cookies for WC mmap requests. =20
>=20
> Well, we want to be able to WC map. Introducing "more cookies" again is
> just one way to get there. How do you create those cookies ? Upon
> request or each region automatically gets multiple with different
> attributes ? Do they represent entire regions or subsets ? etc...=20
>=20
> Here too, I'd rather we start from a clear idea of the actual UAPI we
> want, then we can look at how it gets plumbed under the hood.
>=20
> > I'm not convinced we should try to introduce more cookies without
> > improving the infrastructure. It is already pretty weak, I think
> > trying to mangle the indexes or something "clever" would result in
> > something even harder to maintain even if it might be less patches to
> > write in the first place. =20
>=20
> VFIO-pci already allocates dynamic indexes but yes, I don't disagree
> that cleaning up the infrastructure first is a good idea. However, I
> would prefer if we had a clearer idea of the end goal first,
> specifically the details/shape of the UAPI and underlying structure
> *before* we start hacking at this all.

Yes, the UAPI here is shadowed by a maple tree conversion that isn't
really required by the UAPI.  We need to lead with a good UAPI.

> > > =C2=A0* What I originally proposed ages ago when we discussed it at L=
PC
> > > which is to have an ioctl to create "subregions" of a region with
> > > different attributes. This means creating a new index (and a new
> > > corresponding "cookie") that represents a portion of an existing
> > > region
> > > with a different attribute set to be later used by mmap. =20
> >=20
> > I never liked this, and it is still creating more cookies but now
> > with
> > weird hacky looking uapi. =20
>=20
> "weird hacky looking" isn't a great way of understanding your
> objections :-) Yes, it's a bit more complicated, it allows to break
> down BARs basically into sub-regions with different attributes which is
> fairly close to what users really want to do, but it does complexify
> the UAPI a bit.
>=20
> That said I'm not married to the idea, I just don't completely
> understand the alternative you are proposing...=20

Obviously Jason can correct if the interpretation I gleaned from the
previous thread above is incorrect, but I don't really see that new
region indexes are weird or hacky.  They fit into the REGION_INFO
scheme, they could be managed via DEVICE_FEATURE.

> > > =C2=A0* A simpler approach which is to have an ioctl to change the
> > > attributes over a range of a region, so that *any* mapping of that
> > > range now uses that attribute. This can be done completely
> > > dynamically
> > > (see below). =20
> >=20
> > And I really, really don't like this. The meaning of a memmap cookie
> > should not be changing dynamically. That is a bad precedent. =20
>=20
> What do you mean "a cookie changing dynamically" ? The cookie doesn't
> change. The attributes of a portion of a mapping change based on what
> userspace requested. It is also a pretty close match to the use case
> which is to define that a given part of the device MMIO space is meant
> to be accessed WC. There is no fundamental change to the "cookies".
>=20
> The biggest advantage of that approach is that it completely precludes
> multiple conflicting mappings for a given region (at least within a
> given process, though it might be possible to extend it globally if we
> want) which has been a concern expressed last time we talked about this
> by the folks from the ARM world.

This precludes that a user could simultaneously have mappings to the
same device memory with different mmap attributes, but otherwise it
honestly sounds like the most consistent mechanism if we don't want to
expand the region index space.

> > The uAPI I prefer is a 'get region info2' which would be simplified
> > and allow userspace to pass in some flags. One of those flags can be
> > 'request wc'. =20
>=20
> So talking of "weird hacky looking" having something called "get_info"
> taking "request" flags ... ahem ... :-)

Yup...

> If what you really mean is that under the hood, a given "index"
> produces multiple "regions" (cookies) and "get_info2" allows to specify
> which one you want to get info about ?
>=20
> I mean ... this would work. But I don't see how it's superior to any of
> the above. I don't care *that much*, but it does make it a bit harder
> to avoid the multiple mappings issue and will waste much more cookie
> space than any of the alternatives.
>=20
> > This is logical and future extensible. =20
>=20
> I disagree ... I find it actually cumbersome but we can just agree to
> disagree here and as I said, I don't care that much as long as there is
> no fundamental reason why it wouldn't work in the end.

I'm not a fan of the REGION_INFO2 idea either.  A new region index that
provides an alias to another region with different mmap semantics is
much more intuitive in our existing UAPI, imo.

> Talking of cookie space, one thing we do need to preserve is the
> natural alignment to the BAR size. Userspace *will* do "|" instead of
> "+" on top of a cookie when mmap'ing (beyond mmap own alignment
> requirements).
>=20
> > > Now, within the context of VFIO PCI, since we use a fault handler,
> > > it
> > > doesn't even have to be done before mmap, we can just dynamically
> > > fault
> > > a given page with the right attributes (and zap mappings on
> > > attributes
> > > changes). I would go down that path personally and generalize the
> > > fault
> > > handler to all VFIO implementations. =20
> >=20
> > Even worse. fault by fault changing of attributes? No way, that's a
> > completely crazy uAPI! =20
>=20
> Why ? first userspace doesn't know or see it happens fault by fault
> (and it could be full established at mmap time in fact, but fault time
> makes the implementation a lot easier).
>=20
> Here you are conflating implementation details with "uAPI" ... uAPI is
> what is presented to userspace, which in this case is "set the
> attributes for this portion of a region". Then at map time, that
> portion of the region gets the requested attributes. There is nothing
> in the uAPI that carries the fact that it happens at fault time.
>=20
> You keep coming up with "ugly", "crazy" etc... without every actually
> spelling out the technical pro/cons that would actually substantiate
> those adjectives. Basically anything that isn't your=20
> get_region2 is "crazy" or "ugly" ... NIH syndrome ?
>=20
> > > For example, if I put a 4k WC page in a middle of index 1, then the
> > > tree would have an entry for before the WC page, an entry for the
> > > WC
> > > page and an entry for after. They all point to region index 1, but
> > > the
> > > fault handler can use the maple tree to find the right attributes
> > > at
> > > fault time for the page. =20
> >=20
> > I don't know what this is about, I don't want to see APIs to slice up
> > regions. The vfio driver should report full regions in the pgoff
> > space, and VMAs should be linked to single maple tree ranges only. If
> > userspace wants something weird it can call mmap multiple times and
> > get different VMAs. =20
>=20
> Why ? What are the pros/cons of each approach ?
>=20
> > Each VMA should refer to a single vfio_mmap struct with the same
> > pgprot for every page. It is easy and simple. =20
>=20
> Maybe ... we have precedents of doing differently but I don't have big
> beef in that game.
>=20
> The big advantages of that latter approach is that it's very clear and
> simple for userspace (this bit of the BAR is meant to be WC) and
> completely
> avoids the multiple mapping problem. The inconvenient is that we have
> to
> generalize the fault handler mechanism to all backends, and it makes
> the
> multi-mapping impossible (in the maybe possible case where might want
> to
> allow it in some cases).
>=20
> Overall I find a lot of putting cart before horses here. Can we first
> agree
> on a clear definition of the uAPI first, then we can figure out the
> implementation details ?

+1.  Thanks,

Alex


