Return-Path: <kvm+bounces-11834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2561787C49C
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 22:12:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 88A03282BE9
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 21:12:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C74276C6B;
	Thu, 14 Mar 2024 21:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b1LPJXet"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB86E76C61
	for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 21:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710450748; cv=none; b=dWlED/TJKyOjZSN22liMOymAjLaRI3axzKqvkrMUnWkMlTenQTWz0ovmBI3CUv0tJ5I6NLhi+wPgYbL8HCn0LFkCcTua43ySi1wjn8X4ffDrV6NwO6DRlS6kqLL3OIfK+UB8xKca79qygN3UbCTmPm28Y1NS4y+5t3Em08YAde8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710450748; c=relaxed/simple;
	bh=aFOcY5DV26ZBBevBXdfgOMJBTNL+RHl/cywCGLeNbTk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LBICRA2KKM9k0yqCLEtqmx8oGIc/bS+jWE72F5B7EbztvNaAzRgrKT14F7VQ3lyKQ3GRxqkefmV9nI2D8EqYpktsiR/72gKeg3BL1eRWJcOCeHj1c/acAUYOQl8exBbHsymu/Prc9mAoto64SIxlEjrn2wqiL4N4dusH+W40tBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=b1LPJXet; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-33e9ba0eadcso1116123f8f.2
        for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 14:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710450745; x=1711055545; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q35GJDj8lJfmIP41Qj9wPusUPDhBqRA0eYm4BYx8XVA=;
        b=b1LPJXet8dH+VXloddWWRZ5/Ua4bUgpM4viwtAk/enjoXh0480aP0x2olkz3laLSxt
         kx7haNlrJ/AXwRV/37a66ocU2GnC1D+/w5p1+QiWwid3AFVylC162A/U71mvAK3Smjgl
         Y7qGRpO7p5EOlaiA0c233OC9CJMzykt3yiTYtVecS3GAQu4F31mcB5Bz+EBSMrMHMcyB
         TXvCSOgsZq9zSV2OC7kzKrBosOSTYQZ24L7dP8MLHLNkjHBwUwQZHMrNNLwRPyjFVocC
         UPaSnh9RPr2r2yds2Y1gpKfDdMVkkOdfcfIlnO7F5Un6VhK/Jieg+z0yU49aGgt3mgro
         eS9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710450745; x=1711055545;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q35GJDj8lJfmIP41Qj9wPusUPDhBqRA0eYm4BYx8XVA=;
        b=YtIn0tvaABDI8sZF/YsO3yEwQ/hMHAsMYXQcmjj/Qs9bAb/lQoux8+9t88ia9Ag0bs
         Xss/Cq8SpAhTiS2No+L4BCEMpUIblQLq3gsA/LVcZIsJec9HDGjFZr6Tv2SHPcmovRv7
         Asv7lRjf+Cs5KvghdInfPEnMnoO6q6/pTketc3pLy1JzzmkVgtziHQj4toBU4AyPBvyF
         Z0fJp+sjM/3q4AcSwrbF7DOZV9tRdzgy51xSmWf6+8TNpyujxJEMk2k0me8swm6g49MK
         MAh7HFbyjByFORyoUccGpmD4/6BtklA1XKBgSDy0es/9ZPO7hij8tyq4a56E9Mev992+
         MuiQ==
X-Forwarded-Encrypted: i=1; AJvYcCXZk1znxFZvrBfHNAHAIbhUA7xT0RqcIuuaeJkgR+9SJ0BA7zTJB//gqs9+22GDaiXAB8vLZBE4wu/fQcIXKfDAxiqK
X-Gm-Message-State: AOJu0Yyybt5DX2IZMmYtp5V3jMk5+KnTHEjHrgybRVIyVjR3pVV9dBSV
	LeOBRefvtBIsXE7FgwYb/PihYlChOmCmMzbELaqloY69UxLYxgm/BJNmBxtmWjdzL1V0cuIqQQ+
	L9SyaIw6HCImRpZStC3u0A5wOXwKNm1n72/Ct
X-Google-Smtp-Source: AGHT+IGpwFSkYK4BUrmq1OnlKoV4j7aeUvNrPG/Oduff3o8iWs6dpnR328Df46WPyyiw/MPrW81B++jxYuZSfCmfkkc=
X-Received: by 2002:a5d:4e51:0:b0:33e:c308:9e56 with SMTP id
 r17-20020a5d4e51000000b0033ec3089e56mr1875069wrt.54.1710450744941; Thu, 14
 Mar 2024 14:12:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240307194255.1367442-1-dmatlack@google.com> <ZepBlYLPSuhISTTc@google.com>
 <ZepNYLTPghJPYCtA@google.com> <CALzav=cSzbZXhasD7iAtB4u0xO-iQ+vMPiDeXXz5mYMfjOfwaw@mail.gmail.com>
 <ZfG41PbWqXXf6CF-@google.com>
In-Reply-To: <ZfG41PbWqXXf6CF-@google.com>
From: David Matlack <dmatlack@google.com>
Date: Thu, 14 Mar 2024 14:11:57 -0700
Message-ID: <CALzav=fGUnYHiEc40Ym2Yh-H6wMRdw6biYj4+e1vZ0xmBDAnsg@mail.gmail.com>
Subject: Re: [PATCH] KVM: selftests: Create memslot 0 at GPA 0x100000000 on x86_64
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Peter Gonda <pgonda@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Michael Roth <michael.roth@amd.com>, Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org, 
	nrb@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 13, 2024 at 7:31=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Thu, Mar 07, 2024, David Matlack wrote:
> > On Thu, Mar 7, 2024 at 3:27=E2=80=AFPM David Matlack <dmatlack@google.c=
om> wrote:
> > >
> > > On 2024-03-07 02:37 PM, Sean Christopherson wrote:
> > > > On Thu, Mar 07, 2024, David Matlack wrote:
> > > > > Create memslot 0 at 0x100000000 (4GiB) to avoid it overlapping wi=
th
> > > > > KVM's private memslot for the APIC-access page.
> > > >
> > > > Any chance we can solve this by using huge pages in the guest, and =
adjusting the
> > > > gorilla math in vm_nr_pages_required() accordingly?  There's really=
 no reason to
> > > > use 4KiB pages for a VM with 256GiB of memory.  That'd also be more=
 represantitive
> > > > of real world workloads (at least, I hope real world workloads are =
using 2MiB or
> > > > 1GiB pages in this case).
> > >
> > > There are real world workloads that use TiB of RAM with 4KiB mappings
> > > (looking at you SAP HANA).
> > >
> > > What about giving tests an explicit "start" GPA they can use? That wo=
uld
> > > fix max_guest_memory_test and avoid tests making assumptions about 4G=
iB
> > > being a magically safe address to use.
>
> So, rather than more hardcoded addresses and/or a knob to control _all_ c=
ode
> allocations, I think we should provide knob to say that MEM_REGION_PT sho=
uld go
> to memory above 4GiB. And to make memslot handling maintainable in the lo=
ng term:
>
>   1. Add a knob to place MEM_REGION_PT at 4GiB (and as of this initial pa=
tch,
>      conditionally in their own memslot).
>
>   2. Use the PT_AT_4GIB (not the real name) knob for the various memstres=
s tests
>      that need it.

Making tests pick when to place page tables at 4GiB seems unnecessary.
Tests that don't otherwise need a specific physical memory layout
should be able to create a VM with any amount of memory and have it
just work.

It's also not impossible that a test has 4GiB+ .bss because the guest
needs a big array for something. In that case we'd need a knob to move
MEM_REGION_CODE above 4GiB on x86_64 as well.

For x86_64 (which is the only architecture AFAIK that has a private
memslot in KVM the framework can overlap with), what's the downside of
always putting all memslots above 4GiB?

>
>   3. Formalize memslots 0..2 (CODE, DATA, and PT) as being owned by the l=
ibrary,
>      with memslots 3..MAX available for test usage.
>
>   4. Modify tests that assume memslots 1..MAX are available, i.e. force t=
hem to
>      start at MEM_REGION_TEST_DATA.

I think MEM_REGION_TEST_DATA is just where the framework will satisfy
test-initiated dynamic memory allocations. That's different from which
slots are free for the test to use.

But assuming I understand your intention, I agree in spirit... Tests
should be allowed to use slots TEST_SLOT..MAX and physical addresses
TEST_GPA..MAX. The framework should provide both TEST_SLOT and
TEST_GPA (names pending), and existing tests should use those instead
of random hard-coded values.

>
>   5. Use separate memslots for CODE, DATA, and PT by default.  This will =
allow
>      for more precise sizing of the CODE and DATA slots.

What do you mean by "[separate memslots] will allow for more precise sizing=
"?

>
>   6. Shrink the number of pages for CODE to a more reasonable number.  Cu=
rrently
>      vm_nr_pages_required() reserves 512 pages / 2MiB for per-VM assets, =
which
>      at a glance seems ridiculously excessive.
>
>   7. Use the PT_AT_4GIB knob in s390's CMMA test?  I suspect it does mems=
lot
>      shenanigans purely so that a low gfn (4096 in the test) is guarantee=
d to
>      be available.

+Nico

Hm, if this test _needs_ to use GFN 4096, then maybe the framework can
give tests two regions 0..KVM_FRAMEWORK_GPA and TEST_GPA..MAX.

If the test just needs any GFN then it can use TEST_GPA instead of
4096 << page_shift.

