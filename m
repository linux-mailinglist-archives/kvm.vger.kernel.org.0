Return-Path: <kvm+bounces-67992-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 698EAD1BC01
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 00:48:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 34732303B1AE
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 23:48:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B43C355050;
	Tue, 13 Jan 2026 23:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nCzrI/qd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB4821D585
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 23:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768348106; cv=none; b=gCX3Bvlv4wnQppYdUJC+OWs437pmZxWd/uzWXOs1fcvg3BoNTk1n1LuIv5PlyyXG/c7PJAWbpFLD1ND9UZCexLlK4frHEYMUyWQmU9x/oOkDUxbN4YQJlqEzbZ0jWlwsLWpB2pzWbcnCI7Qn9W2p7pIV3tropAL8F9QWn46tW70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768348106; c=relaxed/simple;
	bh=/3nEZHruNblgDoS195XRf5u7JVjr67KdR83C5VowS9Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=REnygxwe5NcTfhYLjf1hs3vl0RzQ58Vfagcj2nMTmUhL7QqyqGdL0RDatKyygQe0ylJhZTO/PMxlDhEMXVtb6L8u6MVNzVQQBiDImoFqRf0pii9RQSm2Z0F9uMNk1DENGTF+zDurzmhCEn+PA9uVLpjR27ISjVtepcingvjVZB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nCzrI/qd; arc=none smtp.client-ip=209.85.222.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-943d0cafe77so2659462241.3
        for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 15:48:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768348104; x=1768952904; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sVWLNrdwIQNBKBOwJy78In7uUpvJppqCzymGUhTOU5w=;
        b=nCzrI/qd2XChWascNusYWBbbJ0/LTp8VqDkYaycSBvUrYLEXFlue2RIWiLid3jTXe8
         1WyxAyq3Yv3djLD+U9W0CnrNGsezCLLfoDwYPuxi2XGfVmJ4NOZx+/akKAYbaGXRmB2k
         suETMjDzWspF78UIbKwu0Cl+MUzwK6P8dl53QORhLK+ugC7gted9PqGkidTpRDnQBE0C
         9OcwupbP9kuX+YC7P9lDjvnTClfsp6maxwAQxNDSmpFJlNjiJTc0gEzSj0TM3gtLCVMW
         kNFxRBLPUaSUsqQ+uET0O0CwvW45NlRB9lgwv450tWplYurWgOmEzEm6PHqWYnHGWOde
         /VdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768348104; x=1768952904;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sVWLNrdwIQNBKBOwJy78In7uUpvJppqCzymGUhTOU5w=;
        b=KdgA0gxp7np7BJhrgbVD32yw64H8MWu1Eg67DqHaB74THZpkQX3Rm2Jx7oULE/HNTS
         rWO9UeSoDLqud6UkdqzNAOBk1v9gYev9hnN1829jLHGFx4XvQyySDgFsT+golmh8/TU8
         X9klZ/61oW6JZL5LliwwpxF0y0YT8931XvHylPb2s50Clu4SVqKdTRWrH8eiY2ZJJoTW
         j//agSReQJHwrgwnhh2LdBp/fzv+u0ULOudghFUJMK+QYVUb3SOedUazZYMDcknQz6CS
         NAzuzvuPMKExhwvid3mN4vv0mAfFLqLkONfI8KBzE4cmkCgEjwzQqej+iyZWt2uC9UdM
         NmSQ==
X-Forwarded-Encrypted: i=1; AJvYcCVeirNJHI1jmzFzCLrOOeayxKIKqLrJLJonF9ge+U+JRQqRaCVQIhOmLqLOAj89/AsD/JI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyzQ2H3gY3gZM4c3RonQA2pTjZ92I+M/oTZ5UmcXcre1vQ/A0kA
	P4ANW151sjNH50LWfjGbOcX+gO7gY9ehvr6dynC2L6pIgvi9fk1meGJ8Mi5VLETrPZ5bpq8p2Ei
	GwgJlbGaJ+ITUkaVjtYOecAaCHsOppeC7pg/OUcWRbZKNJ+hGhqvysm5e
X-Gm-Gg: AY/fxX4KEY5VS8d8UZOuo79txahPjdMTyw2A2h18h4Fr6FogfL96iXlfz5Zb3ljkuwf
	KCSK9cKS3VrJm2PR+J6aLAtn4sWYpG3HSh7PrdMg6sNClFJ5+C5Io/wMX/kktXjtAiTy3eq7U/b
	GaOaOUelMUIYYyp2HCRiPXnpIiHE4KX1H+mGJK2bapoqBi3kAinRTXjIUwSYEq1GIbIKUdJvQTd
	OX6HvEIrEBzmZweyxJBNSg7bh+nTghUyYyXD9wyEwwroxKT9yQaANKhjmb2p+VN9ga4JbXB
X-Received: by 2002:a05:6102:3f09:b0:5e5:672a:b19 with SMTP id
 ada2fe7eead31-5f17f419d9fmr365708137.4.1768348103587; Tue, 13 Jan 2026
 15:48:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aV8ZRoDjKzjZaw5r@devgpu015.cco6.facebook.com> <20260108141044.GC545276@ziepe.ca>
 <20260108084514.1d5e3ee3@shazbot.org> <CALzav=eRa49+2wSqrDL1gSw8MpMwXVxb9bx4hvGU0x_bOXypuw@mail.gmail.com>
 <20260108183339.GF545276@ziepe.ca> <aWAhuSgEQzr_hzv9@google.com>
 <20260109003621.GG545276@ziepe.ca> <aWBPNHOsaP1sNvze@google.com>
 <20260109005440.GH545276@ziepe.ca> <CALzav=cBGkhbbyggkfaYh3wfqodxRHZKXTNdnmjoXOgwMouBuA@mail.gmail.com>
 <20260109180153.GI545276@ziepe.ca> <20260109143830.176dc279@shazbot.org>
In-Reply-To: <20260109143830.176dc279@shazbot.org>
From: David Matlack <dmatlack@google.com>
Date: Tue, 13 Jan 2026 15:47:53 -0800
X-Gm-Features: AZwV_QjdcFsJsgt85dNhSC_YTux420gKxRVuQRmmDpaV4k1qPluDDfAJcne_NFU
Message-ID: <CALzav=cE4SQbbcWL9-bhHPEjCq3DPOWnGZnqrHcvR5mYB_t3cA@mail.gmail.com>
Subject: Re: [PATCH] vfio: selftests: Add vfio_dma_mapping_mmio_test
To: Alex Williamson <alex@shazbot.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Alex Mastro <amastro@fb.com>, Shuah Khan <shuah@kernel.org>, 
	Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 9, 2026 at 1:38=E2=80=AFPM Alex Williamson <alex@shazbot.org> w=
rote:
>
> On Fri, 9 Jan 2026 14:01:53 -0400
> Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
> > On Fri, Jan 09, 2026 at 09:04:30AM -0800, David Matlack wrote:
> > > > If you really want to test TYPE1 you need to test what makes it
> > > > unique, which is that you can map any VMA and then unmap any slice =
of
> > > > it. Including within what should otherwise be a 1G page.
> > > >
> > > > But I doubt anyone cares enough to fix this, so just exclude
> > > > VFIO_TYPE1_IOMMU from this test?
> > >
> > > Ah, ok, thanks for the explanation. So VFIO_TYPE1_IOMMU should always
> > > use 4K mappings regardless of backend (VFIO or iommufd) so that unmap
> > > can work as intended.
> >
> > IDK, I think you should just ignore testing TYPE1v0. The actual real
> > semantics that it had are quite confusing and iommufd provides an
> > emulation that is going to be functionally OK (indeed, functionally
> > more capable) but is not the exactly the same.
> >
> > The old comment here is sort of enlightening:
> >
> > +        * vfio-iommu-type1 (v1) - User mappings were coalesced togethe=
r to
> > +        * avoid tracking individual mappings.  This means that the gra=
nularity
> > +        * of the original mapping was lost and the user was allowed to=
 attempt
> > +        * to unmap any range.  Depending on the contiguousness of phys=
ical
> > +        * memory and page sizes supported by the IOMMU, arbitrary unma=
ps may
> > +        * or may not have worked.  We only guaranteed unmap granularit=
y
> > +        * matching the original mapping; even though it was untracked =
here,
> > +        * the original mappings are reflected in IOMMU mappings.  This
> > +        * resulted in a couple unusual behaviors.  First, if a range i=
s not
> > +        * able to be unmapped, ex. a set of 4k pages that was mapped a=
s a
> > +        * 2M hugepage into the IOMMU, the unmap ioctl returns success =
but with
> > +        * a zero sized unmap.  Also, if an unmap request overlaps the =
first
> > +        * address of a hugepage, the IOMMU will unmap the entire hugep=
age.
> > +        * This also returns success and the returned unmap size reflec=
ts the
> > +        * actual size unmapped.
> >
> > iommufd does not try to do this "returned unmap size reflects the
> > actual size unmapped" part, it always unmaps exactly what was
> > requested, because it disables huge pages.
>
> I think there was also some splitting code in the IOMMU drivers that
> has since been removed that may have made the v1 interface slightly
> more sane.  It certainly never restricted mappings to PAGE_SIZE in
> order to allow arbitrary unmaps, it relied on users to do sane things
> and examine the results.  Those "sane things" sort of became the v2
> interface.
>
> In any case, we've had v2 for a long time and if IOMMUFD compat make v1
> more bloated and slow such that users realize they're using an old,
> crappy interface, that's probably for the best.  Examining what page
> size is used for v1 is probably not worthwhile though.  Thanks,

Ack. I'll send a patch to skip the page size checks for v1.

