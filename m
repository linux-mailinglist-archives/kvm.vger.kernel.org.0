Return-Path: <kvm+bounces-23888-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8661994F930
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 23:59:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4396B283393
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 21:59:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C61C196D8F;
	Mon, 12 Aug 2024 21:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CnWqPKo/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A22291586D3
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 21:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723499957; cv=none; b=OOEXy7+sXft5jp/TT9aICwxT4xSKNCOsFUpXCPRcPd5iqeu5KzIpC2KZEeqVrbdvV7olJJ85GzpmcOwM/BbdhxK/CVdhK2EoD/v+pJ33ipmtcMscnvmpCv7ltKoM3UzuOoUjU/YaT8yv6bLpk9uuJIq38Dn7x+u0m5lGsxI5AS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723499957; c=relaxed/simple;
	bh=eaEm1/G9eIZ0Ax/mETbWHt8Rk/ajLxiS3U/lBhO6fr8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GQYaHQIQw0yqpcu6FSqQFVZeJubwUfeyOqYWjuKfJXlBXqSm4KQAqo6T/reEWWjriXvKpUvRPPu6wbt9Pu+sbAVODWsOuJEee/mftA5Cv51DidOIvrW0rbHS8Glan9b3hwZp2jHz/N+txhaG4OhD3O2Osrl+eezcakKT0B7PWoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CnWqPKo/; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4281ca54fd3so36881785e9.2
        for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 14:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723499954; x=1724104754; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=32AKu6esuiq7RMdqH+zKe95PkUgMqLZi/1g6Bq3g66I=;
        b=CnWqPKo/lWWpGiwDnYV/zyNjUcI+LwUyunJkI9R+K7v6P99fskHtR/NYR2h59z9o7d
         ufpZueXApsfxaetR9X/ASIk67RjVySVkPwcUCjHKNbiHRXqeXkosYVbMm5n3TQGrLDYD
         80wOajMfZB2jxB2ip7tMTnUNDAaw8J8jM2oLNOp2Fw+hYmPmgbHS5DU+dLuz4AYpxq5h
         fOkoQU/841bXk2V0s0QCuUPJ1PS1/LnxhWoFOF5m3FnZD4LP/3AXxii2gKC1pbsIfrzu
         80DtRPEbLwnbi4FTGyTFNGq6B9NQqlwNAZ8tRUXxDImeiIr8x7HOHY32gbD2RvDEkzxl
         W9/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723499954; x=1724104754;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=32AKu6esuiq7RMdqH+zKe95PkUgMqLZi/1g6Bq3g66I=;
        b=tKC34mtvh9CrbwYOD1xMm0w11lRN75YhwrYkUGUlXfUlqo7CWMEyX66evqKCovYRyV
         6zxSo/zxxkEQwCt/VGaRiCnMNcGa6F5EXP10UjwzBl8+aPfpqub6DjglELZ6GHlG+emJ
         lnOgLDeZ91FRFQ/BUI3heWzyzM9oHmQ7GLwZ5wMghkPJYbssVrSgjYpoC4HN+9WWwKWz
         RnXqB80LkLHSIEEjDZTAwGpnJ3uiiwk+Sfz61NdoBw+QZgkUFShD29qy8512tnRYAE4S
         b4FUdURnYYD8CKZGPIHWHRr8QuSAAHGfFELYO9pUKRDqnNDS5f4Y8SWdGuQj8/EwIQH7
         AJAA==
X-Forwarded-Encrypted: i=1; AJvYcCWlqueZgB52/NYXAJAAeSGL6rc69V58HcR3ouMtGaEugB5sFgjxt3GyJBLlpQJObbpTkRY4ju7a9kumdKw+mJVVLDi8
X-Gm-Message-State: AOJu0YxLbggMrQIZy2/xe9w2P8IIrI73g57T9Wa0r5WORDeJ3CpXBMWp
	taw/aYm2ysvPlFhYtXvK7uPXTdcUbqBcOWtEVKOFz/NcyWAAvNQVBiXUdZ/zXHBb+7jpDCdL1Y6
	txU8JTNdq67CoBNE2oIa/nDc3FCH1DrFcJPWi
X-Google-Smtp-Source: AGHT+IGpQR4kIRSOioBB8aRbn1/lCXeqn51RFDvtwpsOfR0VW8YdEmHVWS2iLr5ZLie1AWw0fBCU3Rz+Gpvuy8h0Fn8=
X-Received: by 2002:a05:600c:4f46:b0:426:50e1:ea6e with SMTP id
 5b1f17b1804b1-429d4818767mr14511085e9.18.1723499953689; Mon, 12 Aug 2024
 14:59:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240809194335.1726916-1-seanjc@google.com> <20240809194335.1726916-15-seanjc@google.com>
 <CALzav=cYv4ZqD5q6-hP=WN8gYFxt7xYKCTm8dLaGtjk-kmCy=w@mail.gmail.com>
In-Reply-To: <CALzav=cYv4ZqD5q6-hP=WN8gYFxt7xYKCTm8dLaGtjk-kmCy=w@mail.gmail.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 12 Aug 2024 14:58:47 -0700
Message-ID: <CALzav=fPS3Q43tq74Le754EvxboCvW--TMKWES3e2z=kjV+0cg@mail.gmail.com>
Subject: Re: [PATCH 14/22] KVM: x86/mmu: Morph kvm_handle_gfn_range() into an
 aging specific helper
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Peter Xu <peterx@redhat.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 12, 2024 at 2:53=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On Fri, Aug 9, 2024 at 12:48=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 0a33857d668a..88b656a1453d 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > +static bool kvm_rmap_age_gfn_range(struct kvm *kvm,
> > +                                  struct kvm_gfn_range *range, bool te=
st_only)
> > +{
> > +       struct slot_rmap_walk_iterator iterator;
> > +       struct rmap_iterator iter;
> > +       bool young =3D false;
> > +       u64 *sptep;
> > +
> > +       for_each_slot_rmap_range(range->slot, PG_LEVEL_4K, KVM_MAX_HUGE=
PAGE_LEVEL,
> > +                                range->start, range->end - 1, &iterato=
r) {
> > +               for_each_rmap_spte(iterator.rmap, &iter, sptep) {
> > +                       if (test_only && is_accessed_spte(*sptep))
> > +                               return true;
> > +
> > +                       young =3D mmu_spte_age(sptep);
>
> It's jarring to see that mmu_spte_age() can get called in the
> test_only case, even though I think the code is technically correct
> (it will only be called if !is_accessed_spte() in which case
> mmu_spte_age() will do nothing).

Nevermind, I see this is cleaned up in the following patch.

