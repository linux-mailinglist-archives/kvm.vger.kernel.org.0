Return-Path: <kvm+bounces-11848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DFF1A87C5CE
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 00:14:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B8D51F2206D
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 23:14:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0487717BAF;
	Thu, 14 Mar 2024 23:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xJQdVpWg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9113C179AB
	for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 23:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710458064; cv=none; b=JeuWWiJFGXU7neKuwQZuOh61BwwKZmE23jfWuUPYdsUuUYFR8cjqxjRq35Ixji2iDVBdS0pduA4LS6EPTVyM3qL0jPOFfkUlMmzAGAEPvcTYa0LSVz3YDCMwZ1xbw+4tg0Dhq4hfJK1FXg33DOpWd/hXBRnke05gOo+0EI+p11w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710458064; c=relaxed/simple;
	bh=iyvfN2zMYG8PeuOq1sOUP4/DPmERJTi8qXuVaXp2b/0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bZflIe1ONzAulnYbj2F8rWG7h8hsju1K/G6EqMGqIYs/vEJscGb/7O0NgXAYo4TyqjHWnfTQ8OXQcf7n+Of1Gj0HCyEkPteRTt7W+f82ebJFXJxLQZuM2zrg62IwvINei79rulDRO2k+Kjj5Vf3C1X/wNBzv2eOMVuN8qI8gg94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xJQdVpWg; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5ce12b4c1c9so984253a12.1
        for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 16:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710458062; x=1711062862; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G2gXkrk25ApWi0AZWQrl7oyv31LVyXSVxJ0dKarlmGM=;
        b=xJQdVpWgoPVVgIu0+YzxdwIap7k0UlhxUSNL8NA515LMSIQJN/1C2FfkLncxWG5Y4T
         hpfgnd8xrAsdup+k3p3ilBsEqE8RcOFHUGmUsGNxs/0EgcDdqqbpe00HWHoEexWNDvKY
         RudJks6kR9FJSkrIfAjPEx4OhWa5rvVttO7iZtXPpqw7xiKP4QHlFWn0Orx+ktdwGzje
         ahZKtw5hhBnXEfr8lRKu05oLICcNMvS83jdxxMxFsCHrgBrdePS0wv6hvihLykA2xR8+
         /N5dyou9vu5d1ysSkIcLiaZDhaCg9GWaKJTQn1Zeo69ItsHtMKIbKLaBVi7jrC8H3rGd
         AGXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710458062; x=1711062862;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=G2gXkrk25ApWi0AZWQrl7oyv31LVyXSVxJ0dKarlmGM=;
        b=ToLDoRPyK/EvGhHvOrPyB/+jZv68kemu/nH8m3LG8BdliqWZ9RFfmtW8Hv5iAVoNZL
         WqdUniBtFYPbXB5O/ZrJnBEPbwP+PX7nB/+HqER/mwHQNPhV3PExntzpaHw+24Hq9v2y
         XBs8Pcgk0+jZ4CH22oJdxbOX8wEc1OlwVamQk3Oh7kPCSwfOg3TCflqPpwBTMp5LQLou
         WNr+Hx59BtPj0gGdah+mm/VeV/78fscflXxIv5769NRsuqQwzC3cii1XfVf+BS6vDKJY
         2vxa/zWoa2aIWAKEDX3GvHMcphc4AHO6h6VD323/quayxQ1Gt96c4SttTKN646YpwpqG
         F2vQ==
X-Forwarded-Encrypted: i=1; AJvYcCV2mafGn+aZ40K4lvZKEFOhmzBYCLxZ8RU4MryhpcCzJDGOmwn+VWUrzNGPYdmF9TGmlRl1va+HvjEWX4FkYlKlzysx
X-Gm-Message-State: AOJu0YzoMsGRgXHeLLx0Mtu3TqJY8/ghPK0800+nv2gs5OL5b+4ewniA
	EpYOlE0qOPvejnJzL6ZdcG6phXeTY1ao+D8YobigGIch9Daw/F088QrLAQqlAodX4F6oTqOPTo5
	atw==
X-Google-Smtp-Source: AGHT+IFiXTYK9GMo11ntza57cJEtjARh0bkS7xUvMkE6sH3xE3jj1bsUvg09KJ6XAocLLcqYBMMbu7T6pfo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:c18:0:b0:5d3:3a61:16a9 with SMTP id
 b24-20020a630c18000000b005d33a6116a9mr7517pgl.12.1710458061833; Thu, 14 Mar
 2024 16:14:21 -0700 (PDT)
Date: Thu, 14 Mar 2024 16:14:20 -0700
In-Reply-To: <CALzav=fGUnYHiEc40Ym2Yh-H6wMRdw6biYj4+e1vZ0xmBDAnsg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240307194255.1367442-1-dmatlack@google.com> <ZepBlYLPSuhISTTc@google.com>
 <ZepNYLTPghJPYCtA@google.com> <CALzav=cSzbZXhasD7iAtB4u0xO-iQ+vMPiDeXXz5mYMfjOfwaw@mail.gmail.com>
 <ZfG41PbWqXXf6CF-@google.com> <CALzav=fGUnYHiEc40Ym2Yh-H6wMRdw6biYj4+e1vZ0xmBDAnsg@mail.gmail.com>
Message-ID: <ZfOEzMxn73M0kZk_@google.com>
Subject: Re: [PATCH] KVM: selftests: Create memslot 0 at GPA 0x100000000 on x86_64
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Peter Gonda <pgonda@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Michael Roth <michael.roth@amd.com>, Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org, 
	nrb@linux.ibm.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 14, 2024, David Matlack wrote:
> On Wed, Mar 13, 2024 at 7:31=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Thu, Mar 07, 2024, David Matlack wrote:
> > > On Thu, Mar 7, 2024 at 3:27=E2=80=AFPM David Matlack <dmatlack@google=
.com> wrote:
> > > >
> > > > On 2024-03-07 02:37 PM, Sean Christopherson wrote:
> > > > > On Thu, Mar 07, 2024, David Matlack wrote:
> > > > > > Create memslot 0 at 0x100000000 (4GiB) to avoid it overlapping =
with
> > > > > > KVM's private memslot for the APIC-access page.
> > > > >
> > > > > Any chance we can solve this by using huge pages in the guest, an=
d adjusting the
> > > > > gorilla math in vm_nr_pages_required() accordingly?  There's real=
ly no reason to
> > > > > use 4KiB pages for a VM with 256GiB of memory.  That'd also be mo=
re represantitive
> > > > > of real world workloads (at least, I hope real world workloads ar=
e using 2MiB or
> > > > > 1GiB pages in this case).
> > > >
> > > > There are real world workloads that use TiB of RAM with 4KiB mappin=
gs
> > > > (looking at you SAP HANA).
> > > >
> > > > What about giving tests an explicit "start" GPA they can use? That =
would
> > > > fix max_guest_memory_test and avoid tests making assumptions about =
4GiB
> > > > being a magically safe address to use.
> >
> > So, rather than more hardcoded addresses and/or a knob to control _all_=
 code
> > allocations, I think we should provide knob to say that MEM_REGION_PT s=
hould go
> > to memory above 4GiB. And to make memslot handling maintainable in the =
long term:
> >
> >   1. Add a knob to place MEM_REGION_PT at 4GiB (and as of this initial =
patch,
> >      conditionally in their own memslot).
> >
> >   2. Use the PT_AT_4GIB (not the real name) knob for the various memstr=
ess tests
> >      that need it.
>=20
> Making tests pick when to place page tables at 4GiB seems unnecessary.
> Tests that don't otherwise need a specific physical memory layout
> should be able to create a VM with any amount of memory and have it
> just work.
>=20
> It's also not impossible that a test has 4GiB+ .bss because the guest
> needs a big array for something. In that case we'd need a knob to move
> MEM_REGION_CODE above 4GiB on x86_64 as well.

LOL, at that point, the test can darn well dynamically allocate its memory.
Though I'd love to see a test that needs a 3GiB array :-)

> For x86_64 (which is the only architecture AFAIK that has a private
> memslot in KVM the framework can overlap with), what's the downside of
> always putting all memslots above 4GiB?

Divergence from other architectures, divergence from "real" VM configuratio=
ns,
and a more compliciated programming environment for the vast majority of te=
sts.
E.g. a test that uses more than ~3GiB of memory would need to dynamically p=
lace
its test specific memslots, whereas if the core library keeps everything un=
der
4GiB by default, then on x86 every test knows it has 4GiB+ to play with.

One could argue that dynamically placing test specific would be more elegan=
t,
but I'd prefer to avoid that because I can't think of any value it would ad=
d
from a test coverage perspective, and static addresses are much easier when=
 it
comes to debug.

Having tests use e.g. 2GiB-3GiB or 1GiB-3GiB, would kinda sorta work, but t=
hat
2GiB limit isn't a trivial, e.g. max_guest_memory_test creates TiBs of mems=
lots.

IMO, memstress is the odd one out, it should be the one that needs to do sp=
ecial
things.

> >   3. Formalize memslots 0..2 (CODE, DATA, and PT) as being owned by the=
 library,
> >      with memslots 3..MAX available for test usage.
> >
> >   4. Modify tests that assume memslots 1..MAX are available, i.e. force=
 them to
> >      start at MEM_REGION_TEST_DATA.
>=20
> I think MEM_REGION_TEST_DATA is just where the framework will satisfy
> test-initiated dynamic memory allocations. That's different from which
> slots are free for the test to use.
>=20
> But assuming I understand your intention, I agree in spirit... Tests
> should be allowed to use slots TEST_SLOT..MAX and physical addresses
> TEST_GPA..MAX. The framework should provide both TEST_SLOT and
> TEST_GPA (names pending), and existing tests should use those instead
> of random hard-coded values.
>=20
> >
> >   5. Use separate memslots for CODE, DATA, and PT by default.  This wil=
l allow
> >      for more precise sizing of the CODE and DATA slots.
>=20
> What do you mean by "[separate memslots] will allow for more precise sizi=
ng"?

I suspect there is a _lot_ of slop in the arbitrary 512 pages that are tack=
ed on
by vm_nr_pages_required().  Those 2MiBs probably don't matter, I just don't=
 like
completely magical numbers.

> >   6. Shrink the number of pages for CODE to a more reasonable number.  =
Currently
> >      vm_nr_pages_required() reserves 512 pages / 2MiB for per-VM assets=
, which
> >      at a glance seems ridiculously excessive.
> >
> >   7. Use the PT_AT_4GIB knob in s390's CMMA test?  I suspect it does me=
mslot
> >      shenanigans purely so that a low gfn (4096 in the test) is guarant=
eed to
> >      be available.
>=20
> +Nico
>=20
> Hm, if this test _needs_ to use GFN 4096, then maybe the framework can
> give tests two regions 0..KVM_FRAMEWORK_GPA and TEST_GPA..MAX.
>=20
> If the test just needs any GFN then it can use TEST_GPA instead of
> 4096 << page_shift.

