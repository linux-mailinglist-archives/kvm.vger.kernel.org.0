Return-Path: <kvm+bounces-67189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E3F50CFB5F9
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 00:45:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DC9E3302AB86
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 23:43:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F08D30AAAE;
	Tue,  6 Jan 2026 23:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JpkcKQJA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6243830EF71
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 23:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767743013; cv=none; b=TGi+d4oU4UwZdKYloi3QY7PhaxgtlXtgOqBVoVOmifCkd3InLHRaJhAT7LxW4gsT1r4pMD+dKC7dj5bfyyPaNcTwcJGwpFTIHeR98SeaRAWizi6tAPsQb9PQLdGTvAbfEuBz51VuqK2R1Zjk2nMm9jIgxeUxLsKvw7kbnfYzpY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767743013; c=relaxed/simple;
	bh=VqlAMj3zhYXoC0OdURecxOgC++qyw3AsxgfnrDpB0u8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dojgZ2t8k9+rl1ZfwT2MiYdPLhIJxAyYO5Repuno70Pj4s+n1KHSi4i0rcsCnxBOH2bPjQzj9Bp/+h8pkfllbjYqphrgAbgDmjVUFV00uGY0UN47Ojg5jg0lFDTiZhDtipGhW10i54+TR/KsVu5rD+FIfczd9uEP4eqF00fVUZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JpkcKQJA; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c314af2d4so1288168a91.3
        for <kvm@vger.kernel.org>; Tue, 06 Jan 2026 15:43:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767743011; x=1768347811; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AFLe2qYsLV+D2iZNcYbO4V3mWanhyRl+kO9tBEe1F6c=;
        b=JpkcKQJA9jIr2hXeOHZi96OlJEhtLJe4X/SUkO8YRx7cqU6j28vQp/i8RBKXV3JeFk
         /vUz0fc/MC7RPXl3/iVWfhO71k+VQEcR8qd5nDBMRzD7cV5tQTPOuMmP33dbfWJVouOY
         pC5lOG2pdLUvPqIBqWHVjk5NNLDmakLH2jhNwMa8XzytiWVIyzwOZbUjh/pTwVdoEY3d
         G9gnEPz3Ka7gEbfJysso+bdvE3+H6g9Ey0Zwo8MRijmsRvYhoJNzqf0dUfQMUVUVcQuk
         KUMl5UdYashySH/LgeCI/rVDKCHN5wG/FxTtWdWbx8kyM/MYWn+/Sy1ZRBDmEGYMRpwO
         HJig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767743011; x=1768347811;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AFLe2qYsLV+D2iZNcYbO4V3mWanhyRl+kO9tBEe1F6c=;
        b=TbnrcUXcMGmsL6hl1Hl5xjT06LxhFu9RFhO/NOV99OKEb/Xl3d7eu9B6GeZgQhs072
         GMWCPK9lYwTk1IeZqalpDwWspQ+3asamQkTdCSn0DFOBEKBgJCSb9YnuV7/IwJdU4aZV
         UwelEWi0kLfvM2h8srdHh5FVnnGMz5OIgkSmkzQ6i0XIHrHyxCAEE53zsA8clsqhkks0
         3DjShraXvGIhyEVj5eNMgwkOXNaXxUDEXyfJsrYsaBhOyc8u0Tkd7PDbPQJZz8rqLT3Z
         G5XB6otPNTlcQ/LBeRaRuI/EcrnTKuageyaJEyzlcupN1EgJWYERG5FlmKzyGD4NBiXr
         0+OQ==
X-Forwarded-Encrypted: i=1; AJvYcCWuAMfZgX5hJxzCVReyj3fZXXjihKcMWatEwNM4ZepxDAEs4i0NbA6C7lQmx1YdAYUXJ8M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7x6Yz0nbquiOI8quFPrHAbkScMJWQbHAsl7B9j9j8EYbZBNOf
	TnXzyljY5xNjjcTGNVCRYL9TV5BP2+DekwoKVW/kq44pTg23c6e8cXxKAW10Ow8v2aMJFHlwEkv
	kxHbXVA==
X-Google-Smtp-Source: AGHT+IGrSHkXO8OJk7Ce749uGfc1vt5vcOfHVVkx+8gcVN8rRM2bUlnULx13EgUhgyaiYuDoxIVlqdDODbk=
X-Received: from pjbfr15.prod.google.com ([2002:a17:90a:e2cf:b0:34c:84ee:67c4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5708:b0:34a:b459:bd10
 with SMTP id 98e67ed59e1d1-34f68cc2ab3mr628773a91.24.1767743010489; Tue, 06
 Jan 2026 15:43:30 -0800 (PST)
Date: Tue, 6 Jan 2026 15:43:29 -0800
In-Reply-To: <CAEvNRgFOER_j61-3u2dEoYdFMPNKaVGEL_=o2WVHfBi8nN+T0A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260106101646.24809-1-yan.y.zhao@intel.com> <CAGtprH-eEUzHDUB0CK2V162HHqvE8kT3bAacb6d3xDYJPwBiYA@mail.gmail.com>
 <CAEvNRgGG+xYhsz62foOrTeAxUCYxpCKCJnNgTAMYMV=w2eq+6Q@mail.gmail.com>
 <aV2A39fXgzuM4Toa@google.com> <CAEvNRgFOER_j61-3u2dEoYdFMPNKaVGEL_=o2WVHfBi8nN+T0A@mail.gmail.com>
Message-ID: <aV2eIalRLSEGozY0@google.com>
Subject: Re: [PATCH v3 00/24] KVM: TDX huge page support for private memory
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>, Yan Zhao <yan.y.zhao@intel.com>, pbonzini@redhat.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org, 
	rick.p.edgecombe@intel.com, dave.hansen@intel.com, kas@kernel.org, 
	tabba@google.com, michael.roth@amd.com, david@kernel.org, sagis@google.com, 
	vbabka@suse.cz, thomas.lendacky@amd.com, nik.borisov@suse.com, 
	pgonda@google.com, fan.du@intel.com, jun.miao@intel.com, 
	francescolavra.fl@gmail.com, jgross@suse.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, xiaoyao.li@intel.com, kai.huang@intel.com, 
	binbin.wu@linux.intel.com, chao.p.peng@intel.com, chao.gao@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 06, 2026, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
>=20
> > On Tue, Jan 06, 2026, Ackerley Tng wrote:
> >> Vishal Annapurve <vannapurve@google.com> writes:
> >>
> >> > On Tue, Jan 6, 2026 at 2:19=E2=80=AFAM Yan Zhao <yan.y.zhao@intel.co=
m> wrote:
> >> >>
> >> >> - EPT mapping size and folio size
> >> >>
> >> >>   This series is built upon the rule in KVM that the mapping size i=
n the
> >> >>   KVM-managed secondary MMU is no larger than the backend folio siz=
e.
> >> >>
> >>
> >> I'm not familiar with this rule and would like to find out more. Why i=
s
> >> this rule imposed?
> >
> > Because it's the only sane way to safely map memory into the guest? :-D
> >
> >> Is this rule there just because traditionally folio sizes also define =
the
> >> limit of contiguity, and so the mapping size must not be greater than =
folio
> >> size in case the block of memory represented by the folio is not conti=
guous?
> >
> > Pre-guest_memfd, KVM didn't care about folios.  KVM's mapping size was =
(and still
> > is) strictly bound by the host mapping size.  That's handles contiguous=
 addresses,
> > but it _also_ handles contiguous protections (e.g. RWX) and other attri=
butes.
> >
> >> In guest_memfd's case, even if the folio is split (just for refcount
> >> tracking purposese on private to shared conversion), the memory is sti=
ll
> >> contiguous up to the original folio's size. Will the contiguity addres=
s
> >> the concerns?
> >
> > Not really?  Why would the folio be split if the memory _and its attrib=
utes_ are
> > fully contiguous?  If the attributes are mixed, KVM must not create a m=
apping
> > spanning mixed ranges, i.e. with multiple folios.
>=20
> The folio can be split if any (or all) of the pages in a huge page range
> are shared (in the CoCo sense). So in a 1G block of memory, even if the
> attributes all read 0 (!KVM_MEMORY_ATTRIBUTE_PRIVATE), the folio
> would be split, and the split folios are necessary for tracking users of
> shared pages using struct page refcounts.

Ahh, that's what the refcounting was referring to.  Gotcha.

> However the split folios in that 1G range are still fully contiguous.
>=20
> The process of conversion will split the EPT entries soon after the
> folios are split so the rule remains upheld.
>=20
> I guess perhaps the question is, is it okay if the folios are smaller
> than the mapping while conversion is in progress? Does the order matter
> (split page table entries first vs split folios first)?

Mapping a hugepage for memory that KVM _knows_ is contiguous and homogenous=
 is
conceptually totally fine, i.e. I'm not totally opposed to adding support f=
or
mapping multiple guest_memfd folios with a single hugepage.   As to whether=
 we
do (a) nothing, (b) change the refcounting, or (c) add support for mapping
multiple folios in one page, probably comes down to which option provides "=
good
enough" performance without incurring too much complexity.

