Return-Path: <kvm+bounces-37699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AD31DA2F27C
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 17:05:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 489A31625E8
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 16:05:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D70FB247DCE;
	Mon, 10 Feb 2025 16:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rrTNYMcE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10EE2451F9
	for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 16:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739203488; cv=none; b=ug/f4A9k/tP0KWbCFGlcASjcHjhozdWTNvcKRegzQWGf0Av1e4gfAYBvF2OpaKu4gj53C+V2p4uw5b4+wvDArXrlgAtgbvkq8zFb0lOf8HCmLByzNm7g1XaHB8rb6YwBpAEZz3vT8bi9dwzOX4R87TVb44OeMYwJDAb4K6otASE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739203488; c=relaxed/simple;
	bh=8DHJ2UWLp7t2pVbkAlQFBbotjxQbfZDhI8zO9c6/tJc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LmZRYOMVhH9yk2B3hKGoe/gUGjHmbMcpDj8Dzhkz7AoipRxqrPFaVJcRIzadsnZlUVgyabUU28Ba0Kk4dRgGYNW5y1lDyVlpiGC+iYpDJUK96MkVk0ZlZyph5il36RFuT3hQj7MQfc5sR3T4NHmQ3LzbpQsDO9RmH9+/ZrdtS+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rrTNYMcE; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-47190a013d4so271911cf.1
        for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 08:04:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739203485; x=1739808285; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AcBTg4Wgx9l1UkrbP4fO7M94HUL3Hslq3degNWAQgeA=;
        b=rrTNYMcE+UCzVN4tqDqmGpA8gB8RtWyw5yTW0/r0EI5kbVtpt4OOhEC39tf8rd8MKi
         NoTiNjbE8+368PWV6QaQq06A+4HF8SKADRmDGiGpOHAHQM2Tcz5pmikvwoC1b9OQ82l/
         MOegItFUx59Q52mtrD3XjGoualbE1LMTvGAFiXPPbbbcUY9gfMjyLxulb19PM9b15y1J
         QIvwNz855tZZhBFPKSMAJXtBYv7ZSsBpZPQibgDogEjLvBIFgnXRDwDOeCH2HOMGOQNf
         vtg1hgc1zPR44cfcRewo3LRXiMNB0ny/Kf2AQ1Cb+u3r374aI+LZOPwEZJe28bdsa4Ny
         8DHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739203485; x=1739808285;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AcBTg4Wgx9l1UkrbP4fO7M94HUL3Hslq3degNWAQgeA=;
        b=opLOYYDr/7hXfL+mefhOxEyV/JOpXrmsMad0Mt++ZgldCzpqeSfw0i09IU9egYDnbO
         aJF5OuY6lpFuGeJdfPBMjUxl33OW/XHklvvLytqx7AnakHWcjjjg1+eS1xl+NlptmA2B
         akN4pmnQlA8O3l86aXfoVCkbxA1k5xj+XA++y0ec4IFsGFcJNGLlzi6mFXG9IfUDJ/OB
         sWcL0P5eTYZbzppznova42bjUVuEho0imB8JI6hunyuW0kn3E+p4eQYOYmhKZG7pgKnb
         T1A8+3wg37Fo3Zn+zrjliXesnl0hCWrgR7HOdshSTEBgrDCeEJflDIqU2bmj3ttJtKAK
         UByw==
X-Forwarded-Encrypted: i=1; AJvYcCURlzuvi/iB0Uf/v6ZraEgYKHsqz+YhKbQHuAj6Nuaf2rfLWA87mdBgD9RqgCJH/ZHeMaM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzuakoZxGFErrW2Xtp9r8AKgsHT0aHRtwLL52BW0Wi86m0CILLA
	N0kE1+z4LPqW7zzG4HKIXDNTH0Ei3WrnZN1Qs5MoAuNUxwaAU5qCuDn18YpICw8PTLO/7aDRV+6
	Juf5/tbO17/TNDmgVurDROWZ6ihTlXeW5MY4m
X-Gm-Gg: ASbGncuMEmNPgeV1hrLNYmWL7dNQF4kQf1H+eQ3MjZ7r90YwTUElTIuSwoevsiShVIX
	ZbDwnJifdWbyPJDnfTknYMN0N4hmDsIKaNxMaQx7OgjJwS67TI+Yx6rSUl3d82199jhhQChk=
X-Google-Smtp-Source: AGHT+IEPhqgOY7/vjDJO9G9Kayo09mPAh4Owza9DV8lkYNo3V2kODOd7QSjFL6dbJJ0yHi4xvJ0CuU/eQiqf60I7yl4=
X-Received: by 2002:ac8:4a02:0:b0:465:3d28:8c02 with SMTP id
 d75a77b69052e-471837d8db6mr4873031cf.26.1739203484270; Mon, 10 Feb 2025
 08:04:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGtprH-K0hKYXbH82_9pObn1Cnau74JWVNQ+xkiSSqnmh6BUUQ@mail.gmail.com>
 <diqzed0aowwa.fsf@ackerleytng-ctop-specialist.c.googlers.com>
In-Reply-To: <diqzed0aowwa.fsf@ackerleytng-ctop-specialist.c.googlers.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 10 Feb 2025 16:04:07 +0000
X-Gm-Features: AWEUYZlYCTGs061p_Xgk33zraHEj1D0BCc_wrNzz8QY6p-YEtOzRpN_eEkVL548
Message-ID: <CA+EHjTwGMYkGUWCghBqN=MTuLLn_SCWZJNhdGYAmg=mn-YQiyg@mail.gmail.com>
Subject: Re: [RFC PATCH v5 06/15] KVM: guest_memfd: Handle final folio_put()
 of guestmem pages
To: Ackerley Tng <ackerleytng@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com, 
	yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, 
	amoorthy@google.com, dmatlack@google.com, yu.c.zhang@linux.intel.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Ackerley,

On Fri, 7 Feb 2025 at 10:46, Ackerley Tng <ackerleytng@google.com> wrote:
>
> Vishal Annapurve <vannapurve@google.com> writes:
>
> > On Wed, Feb 5, 2025 at 9:39=E2=80=AFAM Vishal Annapurve <vannapurve@goo=
gle.com> wrote:
> >>
> >> On Wed, Feb 5, 2025 at 2:07=E2=80=AFAM Fuad Tabba <tabba@google.com> w=
rote:
> >> >
> >> > Hi Vishal,
> >> >
> >> > On Wed, 5 Feb 2025 at 00:42, Vishal Annapurve <vannapurve@google.com=
> wrote:
> >> > >
> >> > > On Fri, Jan 17, 2025 at 8:30=E2=80=AFAM Fuad Tabba <tabba@google.c=
om> wrote:
> >> > > >
> >> > > > Before transitioning a guest_memfd folio to unshared, thereby
> >> > > > disallowing access by the host and allowing the hypervisor to
> >> > > > transition its view of the guest page as private, we need to be
> >> > > > sure that the host doesn't have any references to the folio.
> >> > > >
> >> > > > This patch introduces a new type for guest_memfd folios, and use=
s
> >> > > > that to register a callback that informs the guest_memfd
> >> > > > subsystem when the last reference is dropped, therefore knowing
> >> > > > that the host doesn't have any remaining references.
> >> > > >
> >> > > > Signed-off-by: Fuad Tabba <tabba@google.com>
> >> > > > ---
> >> > > > The function kvm_slot_gmem_register_callback() isn't used in thi=
s
> >> > > > series. It will be used later in code that performs unsharing of
> >> > > > memory. I have tested it with pKVM, based on downstream code [*]=
.
> >> > > > It's included in this RFC since it demonstrates the plan to
> >> > > > handle unsharing of private folios.
> >> > > >
> >> > > > [*] https://android-kvm.googlesource.com/linux/+/refs/heads/tabb=
a/guestmem-6.13-v5-pkvm
> >> > >
> >> > > Should the invocation of kvm_slot_gmem_register_callback() happen =
in
> >> > > the same critical block as setting the guest memfd range mappabili=
ty
> >> > > to NONE, otherwise conversion/truncation could race with registrat=
ion
> >> > > of callback?
> >> >
> >> > I don't think it needs to, at least not as far potencial races are
> >> > concerned. First because kvm_slot_gmem_register_callback() grabs the
> >> > mapping's invalidate_lock as well as the folio lock, and
> >> > gmem_clear_mappable() grabs the mapping lock and the folio lock if a
> >> > folio has been allocated before.
> >>
> >> I was hinting towards such a scenario:
> >> Core1
> >> Shared to private conversion
> >>   -> Results in mappability attributes
> >>       being set to NONE
> >> ...
> >>         Trigger private to shared conversion/truncation for
> >> ...
> >>         overlapping ranges
> >> ...
> >> kvm_slot_gmem_register_callback() on
> >>       the guest_memfd ranges converted
> >>       above (This will end up registering callback
> >>       for guest_memfd ranges which possibly don't
> >>       carry *_MAPPABILITY_NONE)
> >>
> >
> > Sorry for the format mess above.
> >
> > I was hinting towards such a scenario:
> > Core1-
> > Shared to private conversion -> Results in mappability attributes
> > being set to NONE
> > ...
> > Core2
> > Trigger private to shared conversion/truncation for overlapping ranges
> > ...
> > Core1
> > kvm_slot_gmem_register_callback() on the guest_memfd ranges converted
> > above (This will end up registering callback for guest_memfd ranges
> > which possibly don't carry *_MAPPABILITY_NONE)
> >
>
> In my model (I'm working through internal processes to open source this)
> I set up the the folio_put() callback to be registered on truncation
> regardless of mappability state.
>
> The folio_put() callback has multiple purposes, see slide 5 of this deck
> [1]:
>
> 1. Transitioning mappability from NONE to GUEST
> 2. Merging the folio if it is ready for merging
> 3. Keeping subfolio around (even if refcount =3D=3D 0) until folio is rea=
dy
>    for merging or return it to hugetlb
>
> So it is okay and in fact better to have the callback registered:
>
> 1. Folios with mappability =3D=3D NONE can be transitioned to GUEST
> 2. Folios with mappability =3D=3D GUEST/ALL can be merged if the other su=
bfolios
>    are ready for merging
> 3. And no matter the mappability, if subfolios are not yet merged, they
>    have to be kept around even with refcount 0 until they are merged.
>
> The model doesn't model locking so I'll have to code it up for real to
> verify this, but for now I think we should take a mappability lock
> during mappability read/write, and do any necessary callback
> (un)registration while holding the lock. There's no concern of nested
> locking here since callback registration will purely (un)set
> PGTY_guest_memfd and does not add/drop refcounts.
>
> With the callback registration locked with mappability updates, the
> refcounting and folio_put() callback should keep guest_memfd in a
> consistent state.

So if I understand you correctly, we'll need to always register for
large folios, right? If that's the case, we could expand the check to
whether to register the callback, and ensure it's always registered
for large folios. Since, like I said, the common case for small folios
is that it would be just additional overhead. Right?

Cheers,
/fuad

> >> >
> >> > Second, __gmem_register_callback() checks before returning whether a=
ll
> >> > references have been dropped, and adjusts the mappability/shareabili=
ty
> >> > if needed.
> >> >
> >> > Cheers,
> >> > /fuad
>
> [1] https://lpc.events/event/18/contributions/1764/attachments/1409/3704/=
guest-memfd-1g-page-support-2025-02-06.pdf

