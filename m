Return-Path: <kvm+bounces-20051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 939F090FF70
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 10:51:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F1F302858FC
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 08:51:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 921B21A4F22;
	Thu, 20 Jun 2024 08:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3pQBhQm+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D383319939B
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 08:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718873297; cv=none; b=fho8bm5m1uW7ARpfi+4vk103zDc+YswhnpNmDQDpmyv98MVS4f1BBf+HPO6RN1B7BmgjEc+4lA/u3/A8c0Qx2jwAQNZ9TynUyzNi00sFK5Czdkg+Mpz66sWNgBGAEEhj9FBpT1JOxCd6NT84YMVgz/QVZTpF+wU9hLbQSI7Q6HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718873297; c=relaxed/simple;
	bh=oWPtw0QtaFsH1/E9pl1fDuu8ryfWebNgGgY+iHzXzWA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LbOUO3X8I+Mi6goRPnfIDLAtRuZSEgVGz5UqYp5+MSURoE/PPV/EcVsOewauXrG7PwMUjZIXrkn67UWE6EjYHZdOxR6kTB/XivO7WnVGzctnPQbR+ipD9MEsIGv9pJoeE/gJA8E93IFRub32nBscOg5cFyRciMPXtyuBoamQGY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3pQBhQm+; arc=none smtp.client-ip=209.85.217.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-48c4c5c0614so217890137.1
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 01:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718873295; x=1719478095; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MaguyLJRfckUMNCt0LbPp1LmWhc5UBYEsFNMYuWx6U4=;
        b=3pQBhQm+I0Y58HE5JrmyVYey9mO7VQVUWCE9JjU4mEwNa2CTlkYsRg6wzQC5UdcCVY
         lxcQ47c4ST1F9j1T0sUycEgB6Ycww/wOU0/iTCk1OBX8Z2k0oir++Al6y+SDNFi9CDAc
         l1bijyufj4nzR2uK7IK8nFy7SlcerWIoP6fY5YY7fp0zv4cVgVP3m6+ulp4lVpjdHv0H
         r1PhWYrhvdBft7QGIFT9VeSPHKpRc3Hj66QSFFedSecfCUy5tdm5eih5BctpppA54w1c
         Zx/Og1LS5mXokDsFzE9oHws8tV6Ej9s2ZUmrcbkVU2ggBKGZFG5sZWQAGWoTVPMrzErK
         8iag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718873295; x=1719478095;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MaguyLJRfckUMNCt0LbPp1LmWhc5UBYEsFNMYuWx6U4=;
        b=Qy1LOqbRqxKBM547578eSANoVeLQkR+GAeQzMvmoRsLRA+Ag2oP3y0HaqkR43r4fCj
         beIsMUfvUfqQBtcn8U4lzOs1EQaqfQ5SlyhJE7UsMNJwtRKWKIpSYygzMpWD1BOsNtlF
         3bX9GcNvRHiywfUFfNGCs7nwd3/qiKto8qzS0bzhp6HZu16wHfBEExvoyXahj+CTFPPx
         f77TDNOjGLDJQUj+H204n/mLKuCWVIfE3i12s+wChmgIvxUOmLBE2pr64BO8yFHuzjIM
         fJk8YCR4YIzz5VhT6GuaN50nAinYKA3rzOqoa6+a0mXzqGUfhgsBbkv9h4393aWDvt2F
         e68A==
X-Forwarded-Encrypted: i=1; AJvYcCWo11lguTnZyjOzLc+T/mjRYstBvNptMaB0C9iHSoOQlFMDHgRCWmddlm8CgZneTaRvduDftXa7r81LioxHOUxWSh0v
X-Gm-Message-State: AOJu0Yxft0wfHZLfaEYPJPDU1LLTb9X9IAHO3ycHEH0MwDfnkqVXLK9L
	csu3ugK8Oj1xUrWzL6gi/6Lgxtp2JmiERgyB0LOS9116VbhYbcRqHKgoX3EqxzWMjVjgVMg1UBz
	XLdXy9FG+treznbsDFAYYsGEfuz8iY9xDn4kL
X-Google-Smtp-Source: AGHT+IHJHzGsTLlHdkGDfsllSRh8iQMAMrbMYzPHQDEIz67b8VjhtYs5x/lKsIwdroHEofnKgRGum5trjIiYD3NwmSE=
X-Received: by 2002:a05:6102:83b:b0:48f:1ec2:2921 with SMTP id
 ada2fe7eead31-48f1ec22ad1mr2601049137.3.1718873294579; Thu, 20 Jun 2024
 01:48:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240618-exclusive-gup-v1-0-30472a19c5d1@quicinc.com>
 <7fb8cc2c-916a-43e1-9edf-23ed35e42f51@nvidia.com> <14bd145a-039f-4fb9-8598-384d6a051737@redhat.com>
 <CA+EHjTxWWEHfjZ9LJqZy+VCk43qd3SMKiPF7uvAwmDdPeVhrvQ@mail.gmail.com> <489d1494-626c-40d9-89ec-4afc4cd0624b@redhat.com>
In-Reply-To: <489d1494-626c-40d9-89ec-4afc4cd0624b@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 20 Jun 2024 09:47:38 +0100
Message-ID: <CA+EHjTzuqd5PYdZzAGWTjH+EyhomCeGSaFvDjgZfU7GUAWqu9A@mail.gmail.com>
Subject: Re: [PATCH RFC 0/5] mm/gup: Introduce exclusive GUP pinning
To: David Hildenbrand <david@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>, Elliot Berman <quic_eberman@quicinc.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, maz@kernel.org, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	pbonzini@redhat.com, Jason Gunthorpe <jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi David,

On Wed, Jun 19, 2024 at 1:16=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 19.06.24 11:11, Fuad Tabba wrote:
> > Hi John and David,
> >
> > Thank you for your comments.
> >
> > On Wed, Jun 19, 2024 at 8:38=E2=80=AFAM David Hildenbrand <david@redhat=
.com> wrote:
> >>
> >> Hi,
> >>
> >> On 19.06.24 04:44, John Hubbard wrote:
> >>> On 6/18/24 5:05 PM, Elliot Berman wrote:
> >>>> In arm64 pKVM and QuIC's Gunyah protected VM model, we want to suppo=
rt
> >>>> grabbing shmem user pages instead of using KVM's guestmemfd. These
> >>>> hypervisors provide a different isolation model than the CoCo
> >>>> implementations from x86. KVM's guest_memfd is focused on providing
> >>>> memory that is more isolated than AVF requires. Some specific exampl=
es
> >>>> include ability to pre-load data onto guest-private pages, dynamical=
ly
> >>>> sharing/isolating guest pages without copy, and (future) migrating
> >>>> guest-private pages.  In sum of those differences after a discussion=
 in
> >>>> [1] and at PUCK, we want to try to stick with existing shmem and ext=
end
> >>>> GUP to support the isolation needs for arm64 pKVM and Gunyah.
> >>
> >> The main question really is, into which direction we want and can
> >> develop guest_memfd. At this point (after talking to Jason at LSF/MM),=
 I
> >> wonder if guest_memfd should be our new target for guest memory, both
> >> shared and private. There are a bunch of issues to be sorted out thoug=
h ...
> >>
> >> As there is interest from Red Hat into supporting hugetlb-style huge
> >> pages in confidential VMs for real-time workloads, and wasting memory =
is
> >> not really desired, I'm going to think some more about some of the
> >> challenges (shared+private in guest_memfd, mmap support, migration of
> >> !shared folios, hugetlb-like support, in-place shared<->private
> >> conversion, interaction with page pinning). Tricky.
> >>
> >> Ideally, we'd have one way to back guest memory for confidential VMs i=
n
> >> the future.
> >
> > As you know, initially we went down the route of guest memory and
> > invested a lot of time on it, including presenting our proposal at LPC
> > last year. But there was resistance to expanding it to support more
> > than what was initially envisioned, e.g., sharing guest memory in
> > place migration, and maybe even huge pages, and its implications such
> > as being able to conditionally mmap guest memory.
>
> Yes, and I think we might have to revive that discussion, unfortunately.
> I started thinking about this, but did not reach a conclusion. Sharing
> my thoughts.
>
> The minimum we might need to make use of guest_memfd (v1 or v2 ;) ) not
> just for private memory should be:
>
> (1) Have private + shared parts backed by guest_memfd. Either the same,
>      or a fd pair.
> (2) Allow to mmap only the "shared" parts.
> (3) Allow in-place conversion between "shared" and "private" parts.

These three were covered (modulo bugs) in the guest_memfd() RFC I'd
sent a while back:

https://lore.kernel.org/all/20240222161047.402609-1-tabba@google.com/

> (4) Allow migration of the "shared" parts.

We would really like that too, if they allow us :)

> A) Convert shared -> private?
> * Must not be GUP-pinned
> * Must not be mapped
> * Must not reside on ZONE_MOVABLE/MIGRATE_CMA
> * (must rule out any other problematic folio references that could
>     read/write memory, might be feasible for guest_memfd)
>
> B) Convert private -> shared?
> * Nothing to consider
>
> C) Map something?
> * Must not be private

A,B and C were covered (again, modulo bugs) in the RFC.

> For ordinary (small) pages, that might be feasible.
> (ZONE_MOVABLE/MIGRATE_CMA might be feasible, but maybe we could just not
> support them initially)
>
> The real fun begins once we want to support huge pages/large folios and
> can end up having a mixture of "private" and "shared" per huge page. But
> really, that's what we want in the end I think.

I agree.

> Unless we can teach the VM to not convert arbitrary physical memory
> ranges on a 4k basis to a mixture of private/shared ... but I've been
> told we don't want that. Hm.
>
>
> There are two big problems with that that I can see:
>
> 1) References/GUP-pins are per folio
>
> What if some shared part of the folio is pinned but another shared part
> that we want to convert to private is not? Core-mm will not provide the
> answer to that: the folio maybe pinned, that's it. *Disallowing* at
> least long-term GUP-pins might be an option.

Right.

> To get stuff into an IOMMU, maybe a per-fd interface could work, and
> guest_memfd would track itself which parts are currently "handed out",
> and with which "semantics" (shared vs. private).
>
> [IOMMU + private parts might require that either way? Because, if we
> dissallow mmap, how should that ever work with an IOMMU otherwise].

Not sure if IOMMU + private makes that much sense really, but I think
I might not really understand what you mean by this.

> 2) Tracking of mappings will likely soon be per folio.
>
> page_mapped() / folio_mapped() only tell us if any part of the folio is
> mapped. Of course, what always works is unmapping the whole thing, or
> walking the rmap to detect if a specific part is currently mapped.

This might complicate things a but, but we could be conservative, at
least initially in what we allow to be mapped.

>
> Then, there is the problem of getting huge pages into guest_memfd (using
> hugetlb reserves, but not using hugetlb), but that should be solvable.
>
>
> As raised in previous discussions, I think we should then allow the
> whole guest_memfd to be mapped, but simply SIGBUS/... when trying to
> access a private part. We would track private/shared internally, and
> track "handed out" pages to IOMMUs internally. FOLL_LONGTERM would be
> disallowed.
>
> But that's only the high level idea I had so far ... likely ignore way
> too many details.
>
> Is there broader interest to discuss that and there would be value in
> setting up a meeting and finally make progress with that?
>
> I recall quite some details with memory renting or so on pKVM ... and I
> have to refresh my memory on that.

I really would like to get to a place where we could investigate and
sort out all of these issues. It would be good to know though, what,
in principle (and not due to any technical limitations), we might be
allowed to do and expand guest_memfd() to do, and what out of
principle is off the table.

> >
> > To be honest, personally (speaking only for myself, not necessarily
> > for Elliot and not for anyone else in the pKVM team), I still would
> > prefer to use guest_memfd(). I think that having one solution for
> > confidential computing that rules them all would be best. But we do
> > need to be able to share memory in place, have a plan for supporting
> > huge pages in the near future, and migration in the not-too-distant
> > future.
>
> Yes, huge pages are also of interest for RH. And memory-overconsumption
> due to having partially used huge pages in private/shared memory is not
> desired.
>
> >
> > We are currently shipping pKVM in Android as it is, warts and all.
> > We're also working on upstreaming the rest of it. Currently, this is
> > the main blocker for us to be able to upstream the rest (same probably
> > applies to Gunyah).
> >
> >> Can you comment on the bigger design goal here? In particular:
> >
> > At a high level: We want to prevent a misbehaving host process from
> > crashing the system when attempting to access (deliberately or
> > accidentally) protected guest memory. As it currently stands in pKVM
> > and Gunyah, the hypervisor does prevent the host from accessing
> > (private) guest memory. In certain cases though, if the host attempts
> > to access that memory and is prevented by the hypervisor (either out
> > of ignorance or out of malice), the host kernel wouldn't be able to
> > recover, causing the whole system to crash.
> >
> > guest_memfd() prevents such accesses by not allowing confidential
> > memory to be mapped at the host to begin with. This works fine for us,
> > but there's the issue of being able to share memory in place, which
> > implies mapping it conditionally (among others that I've mentioned).
> >
> > The approach we're taking with this proposal is to instead restrict
> > the pinning of protected memory. If the host kernel can't pin the
> > memory, then a misbehaving process can't trick the host into accessing
> > it.
>
> Got it, thanks. So once we pinned it, nobody else can pin it. But we can
> still map it?

This proposal (the exclusive gup) places no limitations on mapping,
only on pinning. If private memory is mapped and then accessed, then
the worst thing that could happen is the userspace process gets
killed, potentially taking down the guest with it (if that process
happens to be the VMM for example).

The reason why we care about pinning is to ensure that the host kernel
doesn't access protected memory, thereby crashing the system.

> >
> >>
> >> 1) Who would get the exclusive PIN and for which reason? When would we
> >>      pin, when would we unpin?
> >
> > The exclusive pin would be acquired for private guest pages, in
> > addition to a normal pin. It would be released when the private memory
> > is released, or if the guest shares that memory.
>
> Understood.
>
> >
> >> 2) What would happen if there is already another PIN? Can we deal with
> >>      speculative short-term PINs from GUP-fast that could introduce
> >>      errors?
> >
> > The exclusive pin would be rejected if there's any other pin
> > (exclusive or normal). Normal pins would be rejected if there's an
> > exclusive pin.
>
> Makes sense, thanks.
>
> >
> >> 3) How can we be sure we don't need other long-term pins (IOMMUs?) in
> >>      the future?
> >
> > I can't :)
>
> :)
>
> >
> >> 4) Why are GUP pins special? How one would deal with other folio
> >>      references (e.g., simply mmap the shmem file into a different
> >>      process).
> >
> > Other references would crash the userspace process, but the host
> > kernel can handle them, and shouldn't cause the system to crash. The
> > way things are now in Android/pKVM, a userspace process can crash the
> > system as a whole.
>
> Okay, so very Android/pKVM specific :/

Gunyah too.

> >
> >> 5) Why you have to bother about anonymous pages at all (skimming over =
s
> >>      some patches), when you really want to handle shmem differently o=
nly?
> >
> > I'm not sure I understand the question. We use anonymous memory for pKV=
M.
> >
>
> "we want to support grabbing shmem user pages instead of using KVM's
> guestmemfd" indicated to me that you primarily care about shmem with
> FOLL_EXCLUSIVE?

Right, maybe we should have clarified this better when we sent out this ser=
ies.

This patch series is meant as an alternative to guest_memfd(), and not
as something to be used in conjunction with it. This came about from
the discussions we had with you and others back when Elliot and I sent
our respective RFCs, and found that there was resistance into adding
guest_memfd() support that would make it practical to use with pKVM or
Gunyah.

https://lore.kernel.org/all/ZdfoR3nCEP3HTtm1@casper.infradead.org/

Thanks again for your ideas and comments!
/fuad

> >>>> To that
> >>>> end, we introduce the concept of "exclusive GUP pinning", which enfo=
rces
> >>>> that only one pin of any kind is allowed when using the FOLL_EXCLUSI=
VE
> >>>> flag is set. This behavior doesn't affect FOLL_GET or any other foli=
o
> >>>> refcount operations that don't go through the FOLL_PIN path.
> >>
> >> So, FOLL_EXCLUSIVE would fail if there already is a PIN, but
> >> !FOLL_EXCLUSIVE would succeed even if there is a single PIN via
> >> FOLL_EXCLUSIVE? Or would the single FOLL_EXCLUSIVE pin make other pins
> >> that don't have FOLL_EXCLUSIVE set fail as well?
> >
> > A FOLL_EXCLUSIVE would fail if there's any other pin. A normal pin
> > (!FOLL_EXCLUSIVE) would fail if there's a FOLL_EXCLUSIVE pin. It's the
> > PIN to end all pins!
> >
> >>>>
> >>>> [1]: https://lore.kernel.org/all/20240319143119.GA2736@willie-the-tr=
uck/
> >>>>
> >>>
> >>> Hi!
> >>>
> >>> Looking through this, I feel that some intangible threshold of "this =
is
> >>> too much overloading of page->_refcount" has been crossed. This is a =
very
> >>> specific feature, and it is using approximately one more bit than is
> >>> really actually "available"...
> >>
> >> Agreed.
> >
> > We are gating it behind a CONFIG flag :)
>
> ;)
>
> >
> > Also, since pin is already overloading the refcount, having the
> > exclusive pin there helps in ensuring atomic accesses and avoiding
> > races.
> >
> >>>
> >>> If we need a bit in struct page/folio, is this really the only way? W=
illy
> >>> is working towards getting us an entirely separate folio->pincount, I
> >>> suppose that might take too long? Or not?
> >>
> >> Before talking about how to implement it, I think we first have to lea=
rn
> >> whether that approach is what we want at all, and how it fits into the
> >> bigger picture of that use case.
> >>
> >>>
> >>> This feels like force-fitting a very specific feature (KVM/CoCo handl=
ing
> >>> of shmem pages) into a more general mechanism that is running low on
> >>> bits (gup/pup).
> >>
> >> Agreed.
> >>
> >>>
> >>> Maybe a good topic for LPC!
> >>
> >> The KVM track has plenty of guest_memfd topics, might be a good fit
> >> there. (or in the MM track, of course)
> >
> > We are planning on submitting a proposal for LPC (see you in Vienna!) :=
)
>
> Great!
>
> --
> Cheers,
>
> David / dhildenb
>

