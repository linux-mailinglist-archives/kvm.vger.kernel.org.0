Return-Path: <kvm+bounces-11749-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 902C787AAA4
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 16:48:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B3A681C20E06
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 15:48:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEFD147F54;
	Wed, 13 Mar 2024 15:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l+G/PNFS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E3945BE4
	for <kvm@vger.kernel.org>; Wed, 13 Mar 2024 15:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710344870; cv=none; b=jqiYHWPcPwvJCz4N/KkJHZ6Xymz7YJA83ltYX+JcEaj2MMIhpUgiRpUHWUkTqHssipnZsV2M73T7Vuth5sG7eNy6CDmjBoG+siLgA5NDDk+0PU7TW2v7yrWD+Y2yJleS2P9Qy2qDDeQmzBiBpVYDnP/B/1rBdZ9Y7DcDa6W/YDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710344870; c=relaxed/simple;
	bh=DXU7ph51IFvnFqSwDtmBTf5RGlHHgDbueVIPKluOaU8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A07UyIxGRL6pvjXQSYov3UypX/bxn5Rct1jLgjAcs9CVD2nHvcbVeP/LHMHIueU1QFlFn5y6bHVCLKgGglsKAVA8uZhl3Avm3uZ8PIymURM9lZKEPavUyOvZMtPwo5tdQUK3wSQKzwWn1osYVkV5LX/xBeCzwIyC7PCxXfwuDHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l+G/PNFS; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1dd8158ed26so12928295ad.1
        for <kvm@vger.kernel.org>; Wed, 13 Mar 2024 08:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710344869; x=1710949669; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e/Z6H8FJpqkR5eo4Ljxl8hO8FSLCWuqRj+smCk6ObEc=;
        b=l+G/PNFSwp9RZZPCNF8SnQzJGaDxO/et1tiXBiyQ6KezckROFd2upWKeQKeNXK/kVd
         LlyUhOI7jJTbdiLeWY8ILK/UJO3nzs/cOLMb53mZT0mDkcjgzsrUrU3sCg9tnVNN9q7q
         6zmj6yCvBiU8wGJEVDciMjykfyHU8kGaJgkvSNuyF4SEgspOr8vIOStK02XEgww7cNsu
         lgQ539GCoEg7jv/7G7Hc4WNOtW3+roxHAvo/XGFLpD0iSM/RubbStfnAtFBkm3E11uxy
         TL/+CaTiJRXEqmJL7ghb6PW1HGgV7GLfjQw/ScTVA9OOU5/6bvzV9tFChOUmyBDcGPs5
         /etw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710344869; x=1710949669;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=e/Z6H8FJpqkR5eo4Ljxl8hO8FSLCWuqRj+smCk6ObEc=;
        b=RmbN5Hn3OjYs0MRpviEfUjJ5kEm4ckQJMYXYqGdEM8Jvl77tC43Voff4Puh/u2GNnE
         W+huUokimcv5ZTcvn1ZcpxPpis2fq+Edmls+1Ab8XrqxkpzQYD/wGZbuL5yl8Z6HOUjT
         mqKCbiPm0IaQEgD1CYJZTIGdeIf4yDDXzBlQzFdj8SzNSw800dQpVn8zbypnDJVXjo3L
         613HeLIyW4aURCj9lmK2wDHAbodus+ue/ojfEZNdwFi/wYnvZpK582drrfk/HSP6KffV
         +lWD2M8yS6DQeWz5BK8O+YmoPtnzZTkNIcMDZpndmJr2ryxWbc1p+mqz3I/rWwczfdrh
         MzHg==
X-Forwarded-Encrypted: i=1; AJvYcCWC188nheLjI9Hfe+GjD+O96UjonjHl0imPWV7RA76/+CWhtIbepjIpPavlLonirOpdmXi0Y94ETC1/VPe67z7mCmiS
X-Gm-Message-State: AOJu0YymQHx3bh+jn31k7AdPgykb9RllNeDceD9JRpI4zBnFmwwwPdk0
	lKNism0ChhyLbOyFbNPBAvJ3NJvLkdiiXWzdJe5uI3orJQSaNlKnxeH0UBapgxBDEQNZetrDAKC
	JCg==
X-Google-Smtp-Source: AGHT+IGJ6RZ0IkgPXm+643N45QY0e2z6ADAKgdz99dpQRYWWh6VJ9xo8TROXQkD9DyMcWkMBuXFLtkFK0+w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d4c4:b0:1dd:47b7:47f9 with SMTP id
 o4-20020a170902d4c400b001dd47b747f9mr9378plg.11.1710344868617; Wed, 13 Mar
 2024 08:47:48 -0700 (PDT)
Date: Wed, 13 Mar 2024 15:47:47 +0000
In-Reply-To: <9e604f99-5b63-44d7-8476-00859dae1dc4@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240229025759.1187910-1-stevensd@google.com> <ZeCIX5Aw5s1L0YEh@infradead.org>
 <CAD=HUj7fT2CVXLfi5mty0rSzpG_jK9fhcKYGQnTf_H8Hg-541Q@mail.gmail.com>
 <72285e50-6ffc-4f24-b97b-8c381b1ddf8e@amd.com> <ZfGrS4QS_WhBWiDl@google.com>
 <0b109bc4-ee4c-4f13-996f-b89fbee09c0b@amd.com> <ZfG801lYHRxlhZGT@google.com> <9e604f99-5b63-44d7-8476-00859dae1dc4@amd.com>
Message-ID: <ZfHKoxVMcBAMqcSC@google.com>
Subject: Re: [PATCH v11 0/8] KVM: allow mapping non-refcounted pages
From: Sean Christopherson <seanjc@google.com>
To: "Christian =?utf-8?B?S8O2bmln?=" <christian.koenig@amd.com>
Cc: David Stevens <stevensd@chromium.org>, Christoph Hellwig <hch@infradead.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@gmail.com>, Zhi Wang <zhi.wang.linux@gmail.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 13, 2024, Christian K=C3=B6nig wrote:
> Am 13.03.24 um 15:48 schrieb Sean Christopherson:
> > On Wed, Mar 13, 2024, Christian K=C3=B6nig wrote:
> > > Am 13.03.24 um 14:34 schrieb Sean Christopherson:
> > > > What Christoph is objecting to is that, in this series, KVM is expl=
icitly adding
> > > > support for mapping non-compound (huge)pages into KVM guests.  Davi=
d is arguing
> > > > that Christoph's objection to _KVM_ adding support is unfair, becau=
se the real
> > > > problem is that the kernel already maps such pages into host usersp=
ace.  I.e. if
> > > > the userspace mapping ceases to exist, then there are no mappings f=
or KVM to follow
> > > > and propagate to KVM's stage-2 page tables.
> > > And I have to agree with Christoph that this doesn't make much sense.=
 KVM
> > > should *never* map (huge) pages from VMAs marked with VM_PFNMAP into =
KVM
> > > guests in the first place.
> > >=20
> > > What it should do instead is to mirror the PFN from the host page tab=
les
> > > into the guest page tables.
> > That's exactly what this series does.  Christoph is objecting to KVM pl=
aying nice
> > with non-compound hugepages, as he feels that such mappings should not =
exist
> > *anywhere*.
>=20
> Well Christoph is right those mappings shouldn't exists and they also don=
't
> exists.
>
> What happens here is that a driver has allocated some contiguous memory t=
o
> do DMA with. And then some page table is pointing to a PFN inside that
> memory because userspace needs to provide parameters for the DMA transfer=
.
>=20
> This is *not* a mapping of a non-compound hugepage, it's simply a PTE
> pointing to some PFN.=20

Yes, I know.  And David knows.  By "such mappings" I did not mean "huge PMD=
 mappings
that point at non-compound pages", I meant "any mapping in the host userspa=
ce
VMAs and page tables that points at memory that is backed by a larger-than-=
order-0,
non-compound allocation".

And even then, the whole larger-than-order-0 mapping is not something we on=
 the
KVM side care about, at all.  The _only_ new thing KVM is trying to do in t=
his
series is to allow mapping non-refcounted struct page memory into KVM guest=
.
Those details were brought up purely because they provide context on how/wh=
y such
non-refcounted pages exist.

> It can trivially be that userspace only maps 4KiB of some 2MiB piece of
> memory the driver has allocate.
>
> > I.e. Christoph is (implicitly) saying that instead of modifying KVM to =
play nice,
> > we should instead fix the TTM allocations.  And David pointed out that =
that was
> > tried and got NAK'd.
>=20
> Well as far as I can see Christoph rejects the complexity coming with the
> approach of sometimes grabbing the reference and sometimes not.

Unless I've wildly misread multiple threads, that is not Christoph's object=
ion.
From v9 (https://lore.kernel.org/all/ZRpiXsm7X6BFAU%2Fy@infradead.org):

  On Sun, Oct 1, 2023 at 11:25=E2=80=AFPM Christoph Hellwig <hch@infradead.=
org> wrote:
  >
  > On Fri, Sep 29, 2023 at 09:06:34AM -0700, Sean Christopherson wrote:
  > > KVM needs to be aware of non-refcounted struct page memory no matter =
what; see
  > > CVE-2021-22543 and, commit f8be156be163 ("KVM: do not allow mapping v=
alid but
  > > non-reference-counted pages"). =C2=A0I don't think it makes any sense=
 whatsoever to
  > > remove that code and assume every driver in existence will do the rig=
ht thing.
  >
  > Agreed.
  >
  > >
  > > With the cleanups done, playing nice with non-refcounted paged instea=
d of outright
  > > rejecting them is a wash in terms of lines of code, complexity, and o=
ngoing
  > > maintenance cost.
  >
  > I tend to strongly disagree with that, though. =C2=A0We can't just let =
these
  > non-refcounted pages spread everywhere and instead need to fix their
  > usage.

> And I have to agree that this is extremely odd.

Yes, it's odd and not ideal.  But with nested virtualization, KVM _must_ "m=
ap"
pfns directly into the guest via fields in the control structures that are
consumed by hardware.  I.e. pfns are exposed to the guest in an "out-of-ban=
d"
structure that is NOT part of the stage-2 page tables.  And wiring those up=
 to
the MMU notifiers is extremely difficult for a variety of reasons[*].

Because KVM doesn't control which pfns are mapped this way, KVM's compromis=
e is
to grab a reference to the struct page while the out-of-band mapping exists=
, i.e.
to pin the page to prevent use-after-free.  And KVM's historical ABI is to =
support
any refcounted page for these out-of-band mappings, regardless of whether t=
he
page was obtained by gup() or follow_pte().

Thus, to support non-refouncted VM_PFNMAP pages without breaking existing u=
serspace,
KVM resorts to conditionally grabbing references and disllowing non-refcoun=
ted
pages from being inserted into the out-of-band mappings.

But again, I don't think these details are relevant to Christoph's objectio=
n.

[*] https://lore.kernel.org/all/ZBEEQtmtNPaEqU1i@google.com

