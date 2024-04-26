Return-Path: <kvm+bounces-16062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCA528B3C9C
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 18:17:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C5233B26E52
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 16:17:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF30814A4EE;
	Fri, 26 Apr 2024 16:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Oo73nFeL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30E614884B
	for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 16:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714148255; cv=none; b=sQ2dTHmwTxlcdtwTcdhYmZnPbmSR18/PMI9oDrfeI3MHt2kz7g3T5J7/6KhYE590d29S3V9Hih8Eh9Oa7r2Dtsn/VNm0K5OK31qJPZQJ9IDmdUEuJV0EHMv9EP6fem6A9Rlptu6pjGLbaSwlBre2dgQbWI+OhfhOrPYRTnH8u04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714148255; c=relaxed/simple;
	bh=wxSyCXxcEgS+eqV6Ht+as6IVr7APUKBtQzz/23MTmxk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=e5nef2Umqc6G8bfJVjYoRqVWzGO5jcuiX6eQ2ZzSnDnQOwO+q9giSbugaNeC9uICDB9+vm+Upeqnw2muShwueaOw0pkgBn6Z5e3wXUTDKP9jziuGHgU93juBziVknmFrB46sIzX+YwgZh4v7P8h5YJQo+rLjTrdYAgizzxzDuL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Oo73nFeL; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1e2bb241663so25300725ad.1
        for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 09:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714148252; x=1714753052; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E4doQfOzXnAzhk3INfD6TFqodx/4Vrdpgw8xtFDXCeM=;
        b=Oo73nFeL0zj61fEzYlIyAHJRdt/6lwy9JmZqvCHdUg7qwyZEDTG+naUTTxTTMmCXAO
         quNpx2r7Qna0dCcONYGhXb3wontyyIhAJybFZrutLDRTJe7xy9+rX5y36mtHrojgUQHB
         sBjkZEu/eJ66zVvFtgOrXWnGOOFvMJDAZKpFdNBd7TkdC7YPuEZICTXZqmJEfawx9uAh
         p0j/1kwqCRBJBwSUHgMeyN+pipBxtykF6XFeUSTDMDQ9J+7Gu1X/by25lC0Ds1b7RQD+
         LKIQFtKMDfHKjsFx7perr/LBLHCcFVwOfWvaiYn3nP/bktRtMZXab4Jqs5XDd66VZ5wt
         XsoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714148252; x=1714753052;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=E4doQfOzXnAzhk3INfD6TFqodx/4Vrdpgw8xtFDXCeM=;
        b=aEnSq1DRd4BPCo1TAU9g/Ku/mJrBw3sJyK6ZmaleK6OEOZTXRX9t71FqeKzgHejj1W
         lTchp2KLecwJpcYtr/F1UBuX65T4FK8TRbOaCNLxwSmdZRUZLSf5OkKYTi2I6Nf4ieWo
         howWwQUfEKuO60lX0nQWadnidrxFgCrkQT9OtEShTB8hsd3ojpsXkVJ+UQ/nMeHfOhdb
         8PEpHfhn/SVawqcJrCTw+/h+S8xQbwfFQ5Aat5EKEH2ZYLKpaUMjgd/UhZnQtDWQCCNv
         tRr+dIy7csywM2dw4qfRbLGRxThSMkqt431Z+FWxZmhRpqwPwKmxyyBdMamtAxUbpoDZ
         rAHw==
X-Forwarded-Encrypted: i=1; AJvYcCXEgxREZXACKb56qIRvMp39YkFhu99OOn1T8L3ueuPQmPZN6O9Qzx/GEL3bWgOBgaKzVE6laiwPUJ9ReQe8Nk0Unerh
X-Gm-Message-State: AOJu0Yw6efdF9l9QSe77D8p/v8jlVD7+gsSx1VWLW9JQc3BkZYZ2g1Wj
	P1Qo60repYhJRXyiB5C397ffIF2PZye+jB8xxaQGLoyjSf3CT4OCJPfhJC0uqj7pHVGNg2ltBcl
	CxA==
X-Google-Smtp-Source: AGHT+IEzAixRcvwhKil34I5h8fFCTUmbekLoK1dGk2ycFZFtNIVD/TnqV6/QVATT1qpQ6iDxyL2lBlrwCag=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c942:b0:1eb:3dd4:b9d with SMTP id
 i2-20020a170902c94200b001eb3dd40b9dmr40810pla.10.1714148251744; Fri, 26 Apr
 2024 09:17:31 -0700 (PDT)
Date: Fri, 26 Apr 2024 09:17:30 -0700
In-Reply-To: <CAOfLF_+ZP-X8yT7qDb0t57ZZu7RNhdOGyCNfR2fheZG+h_jZ7w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240423024933.80143-1-kele@cs.columbia.edu> <de0096bf-08a8-4ee4-94d7-6e5854b056b4@intel.com>
 <CAOfLF_L2UgSUyUsbiBDhLPskt2xLWujy1GBAhpcWzi2i3brAww@mail.gmail.com> <CAOfLF_+ZP-X8yT7qDb0t57ZZu7RNhdOGyCNfR2fheZG+h_jZ7w@mail.gmail.com>
Message-ID: <ZivTmpMmeuIShbcC@google.com>
Subject: Re: [1/1] KVM: restrict kvm_gfn_to_hva_cache_init() to only accept
 address ranges within one page
From: Sean Christopherson <seanjc@google.com>
To: Kele Huang <kele@cs.columbia.edu>
Cc: Zide Chen <zide.chen@intel.com>, pbonzini@redhat.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 26, 2024, Kele Huang wrote:

Please don't top post.  https://people.kernel.org/tglx/notes-about-netiquet=
te

> > On Thu, Apr 25, 2024 at 9:16=E2=80=AFPM Chen, Zide <zide.chen@intel.com=
> wrote:
> >> On 4/22/2024 7:49 PM, Kele Huang wrote:
> >> > Function kvm_gfn_to_hva_cache_init() is exported and used to init
> >> > gfn to hva cache at various places, such as called in function
> >> > kvm_pv_enable_async_pf().  However, this function directly tail
> >> > calls function __kvm_gfn_to_hva_cache_init(), which assigns
> >> > ghc->memslot to NULL and returns 0 for cache initialization of
> >> > cross pages cache.  This is unsafe as 0 typically means a successful
> >> > return, but it actually fails to return a valid ghc->memslot.
> >> > The functions call kvm_gfn_to_hva_cache_init(), such as
> >> > kvm_lapic_set_vapicz_addr() do not make future checking on the
> >> > ghc->memslot if kvm_gfn_to_hva_cache_init() returns a 0.  Moreover,
> >> > other developers may try to initialize a cache across pages by
> >> > calling this function but fail with a success return value.
> >> >
> >> > This patch fixes this issue by explicitly restricting function
> >> > kvm_gfn_to_hva_cache_init() to only accept address ranges within
> >> > one page and adding comments to the function accordingly.
> >> >
> >>
> >> For cross page cache, returning a zero is not really a mistake, since =
it
> >> verifies the entire region against the memslot and does initialize ghc=
.
> >>
> >> The nullified memslot is to indicate that the read or write should
> >> follow the slow path, and it's the caller's responsibility to check
> >> ghc->memslot if needed.  e.g., kvm_read_guest_offset_cached() and
> >> kvm_write_guest_offset_cached().  Please refer to commit fcfbc617547f
> >> ("KVM: Check for a bad hva before dropping into the ghc slow path")
>
> Thanks for the feedback!  Yes, callers including kvm_read_guest_offset_ca=
ched()
> and kvm_write_guest_offset_cached() checked if the read or write should f=
ollow
> the slow path for the guest memory read/write by checking if
> ghc->memslot is nullified.
> However, please note that they are calling the static function
> `__kvm_gfn_to_hva_cache_init()` instead of the exported function
> `kvm_gfn_to_hva_cache_init()`.
>=20
> Although `__kvm_gfn_to_hva_cache_init()` has detailed comments about usin=
g
> a slow path for cross page but actually the "slow path" is to read/write =
guest
> memory instead of for setting up a cross page cache.  The difference here
> I think is that `kvm_gfn_to_hva_cache_init()` is an exported function and
> its name indicates it is used for gfn to hva cache init, while the
> return value 0
> does not really guarantee the cache is initialized when the address range
> crosses pages.

The exports from kvm.ko are intended for use only by KVM itself, e.g. by
kvm-intel.ko and kvm-amd.ko on x86.  Anyone trying to use KVM's exports in =
random
drivers is in for a world of hurt, as there many, many subtleties throughou=
t KVM
that bleed all over the exports.

It's gross that KVM has "internal" exports, and we have line of sight to re=
moving
them for most architectures, including x86, but that isn't the easiest of c=
hanges.

If there is a real problem with in-tree upstream KVM, then we'll fix it, bu=
t
changing the behavior of KVM functions just because they are exported isn't=
 going
to happen.

> For example, function kvm_lapic_set_vapicz_addr()
> called `kvm_gfn_to_hva_cache_init()` and simply assumes the cache is
> successfully initialized by checking the return value.

I don't follow the concern here.  It's userspace's responsibility to provid=
e a
page-aligned address.  KVM needs to not explode on an unaligned address, bu=
t
ensuring that KVM can actually use the fast path isn't KVM's problem.

> My thought is there probably should be another function to provide correc=
t
> cross page cache initialization but I am not sure if this is really neede=
d.

If there were a legitimate use case where it was truly valuable, then we co=
uld
add that functionality.  But all of the usage in KVM either deals with asse=
ts
that are exactly one page in size and must be page aligned, or with assets =
that
are userspace or guest controlled and not worth optimizing for page splits =
because
a well-behavior userspace/guest should ensure the asset doesn't split a pag=
e.

> Nevertheless, I think we could at least make the existing function
> more accurate?

More accurate with respect to what?

