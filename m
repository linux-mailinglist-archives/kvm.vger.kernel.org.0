Return-Path: <kvm+bounces-13509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 209CF897CD8
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 02:15:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 76B641F27945
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 00:15:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 977FA819;
	Thu,  4 Apr 2024 00:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xnQ627Dd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3088D163
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 00:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712189723; cv=none; b=RM97SwdQPxaF+ARILZg89bQ66RbTOSOHmBHzqFmByFbOJhj5i7ooFwVX/f81+mdsQb+N5FtUC2S+aKgG0eQ3xS9fHU2idE02dSwXfnh9224c1fFK4eksCx12zOmZ6uUOV6J0dAWX6FYRWT6Q2EQsZa/Jj/XcqAy+cElqvFftrNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712189723; c=relaxed/simple;
	bh=eX/5XwpAdJ07lgszyC/2ZORfv0TDVbW4NRdjZlFf3Qo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IgKeXaEOxQsmD4D9oPLcq7kwTZExJG5Tcs/tt7YvXwCYoenIYhFfIoZhGwbXrshIQ7gONQs0md5HMuI4aEZ3ye2WPHUeNu9v54UZG9J0n5WgADIwpo03JBDW5nLjnhV0qZHgLVgqEKmOUbXzI6ylQp24pzfCE7lXW1GOdpv8jSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xnQ627Dd; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60cbba6f571so7668937b3.1
        for <kvm@vger.kernel.org>; Wed, 03 Apr 2024 17:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712189721; x=1712794521; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mCeSr4wJkFCp2IdLwGAwGp7GdqdkS33tB/AmL1dElBE=;
        b=xnQ627Dde/lXmtPUc3Yl97zLnlxen+y5JIAmEPb2h/BKy5kcqPK2K1znHXZ3kPKLlR
         hyWCFYUgMX1tr1b1+9u2sWgbQ6lXRXldHSizJsCg+ExjyaosKhItkGTpoibZXzeDezFy
         2XMqTzc8ikmiGmx6nPYdeOFHcM8mD8N33Cq0caAvjUyHf0roLctqnUpFBgM5nLOW0940
         vTJtSj1T0z7zHq+2bQOk4uTpH05DZCYkg1zfn8RNvMakuLFkWwU/1qNJQ6OsX9EES1xr
         xXcKBNGAOVSo8CPX2a+MFiRHV01cjQ4ob7kUshHiZMTXB1pZkqYDl/z75IVUgpx4NJky
         GY4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712189721; x=1712794521;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mCeSr4wJkFCp2IdLwGAwGp7GdqdkS33tB/AmL1dElBE=;
        b=M026cDwDVBpzSPnnD5KlBYstzPMwUVnFGtKFt5DdLbOtG+CWzRt1glILbTrwX0oofl
         6hOrukXZQzDI2yJId50ufGAZEDmvosTixfS6t6hbVPsKWbFpLVTdU+mMfY7wa+PfG9Vw
         2DWt8J5WmIHRLQKOedx/izzR8JZQxQLO8b49CroRDa3zzQo8CH6j8sIa54WKLG6rhL9k
         L/iFU0D8ZU7yzWQISLsCrFPd5l+0Olr95P0139VwxFkYpv74DX6mJ+g1JVmC9eEsAepX
         giO5z8kAmEo1G8Gp6X9eo5PZ0y+fuuqIJ9/nklWo2gQaW6UpK5qqN1dSTkkUf0Dl2/fW
         WzgA==
X-Forwarded-Encrypted: i=1; AJvYcCX2pmkyqze7ieJgXt/CFBrt6gvnrlsYoByetPxpMFWS/jZlsNWtsxlIw3891FEp3SbQbAyabR5/ujkTHLHi8hE9QvK3
X-Gm-Message-State: AOJu0YynWjTW4Aqyvsdi+8f4H4ZRVy17eIdVt42AvnXY8zYW8viGW007
	0eJtBEhOGyCRNpyg4cktUkf6cZHANkk4sPa9xRkubYIhyveI+BXg/pEgfGhgwYbwRKnuLJsFpt6
	ryg==
X-Google-Smtp-Source: AGHT+IFAMIRH3R/vig8IV5/mJg6X5qS3pE27tIxvM6f0sLO7l47QQKGi+iyrrJK0mXp82lG2rh9Ii9Npzng=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:6dd1:0:b0:614:f416:9415 with SMTP id
 i200-20020a816dd1000000b00614f4169415mr249120ywc.7.1712189721201; Wed, 03 Apr
 2024 17:15:21 -0700 (PDT)
Date: Wed, 3 Apr 2024 17:15:19 -0700
In-Reply-To: <20240327193454.GB11880@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <ZeYbUjiIkPevjrRR@google.com> <ae187fa6-0bc9-46c8-b81d-6ef9dbd149f7@redhat.com>
 <CAGtprH-17s7ipmr=+cC6YuH-R0Bvr7kJS7Zo9a+Dc9VEt2BAcQ@mail.gmail.com>
 <7470390a-5a97-475d-aaad-0f6dfb3d26ea@redhat.com> <CAGtprH8B8y0Khrid5X_1twMce7r-Z7wnBiaNOi-QwxVj4D+L3w@mail.gmail.com>
 <ZfjYBxXeh9lcudxp@google.com> <40f82a61-39b0-4dda-ac32-a7b5da2a31e8@redhat.com>
 <20240319143119.GA2736@willie-the-truck> <2d6fc3c0-a55b-4316-90b8-deabb065d007@redhat.com>
 <20240327193454.GB11880@willie-the-truck>
Message-ID: <Zg3xF7dTtx6hbmZj@google.com>
Subject: Re: folio_mmapped
From: Sean Christopherson <seanjc@google.com>
To: Will Deacon <will@kernel.org>
Cc: David Hildenbrand <david@redhat.com>, Vishal Annapurve <vannapurve@google.com>, 
	Quentin Perret <qperret@google.com>, Matthew Wilcox <willy@infradead.org>, Fuad Tabba <tabba@google.com>, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_mnalajal@quicinc.com, 
	quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, keirf@google.com, linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 27, 2024, Will Deacon wrote:
> Hi again, David,
>=20
> On Fri, Mar 22, 2024 at 06:52:14PM +0100, David Hildenbrand wrote:
> > On 19.03.24 15:31, Will Deacon wrote:
> > sorry for the late reply!
>=20
> Bah, you and me both!

Hold my beer ;-)

> > > On Tue, Mar 19, 2024 at 11:26:05AM +0100, David Hildenbrand wrote:
> > > > On 19.03.24 01:10, Sean Christopherson wrote:
> > > > > On Mon, Mar 18, 2024, Vishal Annapurve wrote:
> > > > > > On Mon, Mar 18, 2024 at 3:02=E2=80=AFPM David Hildenbrand <davi=
d@redhat.com> wrote:
> > >  From the pKVM side, we're working on guest_memfd primarily to avoid
> > > diverging from what other CoCo solutions end up using, but if it gets
> > > de-featured (e.g. no huge pages, no GUP, no mmap) compared to what we=
 do
> > > today with anonymous memory, then it's a really hard sell to switch o=
ver
> > > from what we have in production. We're also hoping that, over time,
> > > guest_memfd will become more closely integrated with the mm subsystem=
 to
> > > enable things like hypervisor-assisted page migration, which we would
> > > love to have.
> >=20
> > Reading Sean's reply, he has a different view on that. And I think that=
's
> > the main issue: there are too many different use cases and too many
> > different requirements that could turn guest_memfd into something that =
maybe
> > it really shouldn't be.
>=20
> No argument there, and we're certainly not tied to any specific
> mechanism on the pKVM side. Maybe Sean can chime in, but we've
> definitely spoken about migration being a goal in the past, so I guess
> something changed since then on the guest_memfd side.

What's "hypervisor-assisted page migration"?  More specifically, what's the
mechanism that drives it?

I am not opposed to page migration itself, what I am opposed to is adding d=
eep
integration with core MM to do some of the fancy/complex things that lead t=
o page
migration.

Another thing I want to avoid is taking a hard dependency on "struct page",=
 so
that we can have line of sight to eliminating "struct page" overhead for gu=
est_memfd,
but that's definitely a more distant future concern.

> > This makes sense: shared memory is neither nasty nor special. You can
> > migrate it, swap it out, map it into page tables, GUP it, ... without a=
ny
> > issues.
>=20
> Slight aside and not wanting to derail the discussion, but we have a few
> different types of sharing which we'll have to consider:
>=20
>   * Memory shared from the host to the guest. This remains owned by the
>     host and the normal mm stuff can be made to work with it.

This seems like it should be !guest_memfd, i.e. can't be converted to guest
private (without first unmapping it from the host, but at that point it's
completely different memory, for all intents and purposes).

>   * Memory shared from the guest to the host. This remains owned by the
>     guest, so there's a pin on the pages and the normal mm stuff can't
>     work without co-operation from the guest (see next point).

Do you happen to have a list of exactly what you mean by "normal mm stuff"?=
  I
am not at all opposed to supporting .mmap(), because long term I also want =
to
use guest_memfd for non-CoCo VMs.  But I want to be very conservative with =
respect
to what is allowed for guest_memfd.   E.g. host userspace can map guest_mem=
fd,
and do operations that are directly related to its mapping, but that's abou=
t it.

>   * Memory relinquished from the guest to the host. This actually unmaps
>     the pages from the host and transfers ownership back to the host,
>     after which the pin is dropped and the normal mm stuff can work. We
>     use this to implement ballooning.
>=20
> I suppose the main thing is that the architecture backend can deal with
> these states, so the core code shouldn't really care as long as it's
> aware that shared memory may be pinned.
>=20
> > So if I would describe some key characteristics of guest_memfd as of to=
day,
> > it would probably be:
> >=20
> > 1) Memory is unmovable and unswappable. Right from the beginning, it is
> >    allocated as unmovable (e.g., not placed on ZONE_MOVABLE, CMA, ...).
> > 2) Memory is inaccessible. It cannot be read from user space, the
> >    kernel, it cannot be GUP'ed ... only some mechanisms might end up
> >    touching that memory (e.g., hibernation, /proc/kcore) might end up
> >    touching it "by accident", and we usually can handle these cases.
> > 3) Memory can be discarded in page granularity. There should be no case=
s
> >    where you cannot discard memory to over-allocate memory for private
> >    pages that have been replaced by shared pages otherwise.
> > 4) Page tables are not required (well, it's an memfd), and the fd could
> >    in theory be passed to other processes.o

More broadly, no VMAs are required.  The lack of stage-1 page tables are ni=
ce to
have; the lack of VMAs means that guest_memfd isn't playing second fiddle, =
e.g.
it's not subject to VMA protections, isn't restricted to host mapping size,=
 etc.

> > Having "ordinary shared" memory in there implies that 1) and 2) will ha=
ve to
> > be adjusted for them, which kind-of turns it "partially" into ordinary =
shmem
> > again.
>=20
> Yes, and we'd also need a way to establish hugepages (where possible)
> even for the *private* memory so as to reduce the depth of the guest's
> stage-2 walk.

Yeah, hugepage support for guest_memfd is very much a WIP.  Getting _someth=
ing_
is easy, getting the right thing is much harder.

