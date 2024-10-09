Return-Path: <kvm+bounces-28355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7037B997659
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 22:22:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E8263B20EB3
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 20:22:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0AAC1E1C3F;
	Wed,  9 Oct 2024 20:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TeVUz6jQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AEE81DFE2B
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 20:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728505353; cv=none; b=D0VIEXXvdILmkvPHOMgJLUmqn78hTCOLGCHBrFvfZXjTZPu4tZP16Ry7/ahqO7beTD0gJEpAhop3ZM6XjrsJLvLLvt3yt2r3kDpxMkwWRD+cBoZe6AnO3UbSCVtdsbPYxUunE/IAuk32jRjeRkn7lu/XHanTo0Jg6uRREUmMZY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728505353; c=relaxed/simple;
	bh=bV90d0HsQxGQ2Ui1FN7hqrsubA+nhJLXuFCduvxDNyU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i6MtUBQT2w2/EsCtz4+rrFRLV+8ViPz6i6SBEFI+JaTyIBm/Mt3rLbsRTkS9kyYy6gWI9fP+UzaHN2IwaHdaR4zaiymTrxUbD2NJFbKqz8+Tq7FecQ5TiVl1a3pkGnVSW/tZOS+o9/FNRJDf2QezEUbAn0tO6dBgYf2yvW8GgAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TeVUz6jQ; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43111d23e29so14495e9.1
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 13:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728505350; x=1729110150; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hzs1gzfYHswy0si+R7XAn07+PaSqO7kZbgiwonbMNlM=;
        b=TeVUz6jQ+ID6tfNLKYjLpLRQWOLpJthdWzaCEmhfhRHOs0zLrNaUy4NOrO3dvi4nxO
         PWj1115td7JDApdCUigHEsU7uiF9JhjazPgvr9i4QJfEq05uwKG6S4w+58KGiTLX+fq9
         y4sQO+YvUUs6I19P2J9xl5VdjzSyJw9C0sL0qFSUO4DKxZ72YMycgz4qAqBktREPgT6f
         g+9Fh0oVNKYbyFxe0G8VTda6Ez0iBfLHahTySMQGOe80Ow6w3wpPymnl19b+1dIz15Pc
         ruFSSm6cuzIxy8DzvSTYNCQo2p6P73AWc9JlVusCGwX/shH360wemMDQpkBPf6QTlWpA
         q7JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728505350; x=1729110150;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hzs1gzfYHswy0si+R7XAn07+PaSqO7kZbgiwonbMNlM=;
        b=gF8RNYhMTXrEJtHPF6IrpVDxxItG+iw+j++eNo2wyaLXBbVP1H0lnLKLSDlN/AmIOf
         OjvJeF34kjFTbbpJSrCCQGz48JplcNo8mEQmw/17rUCJAjaLW+Uh20Izzqc8oIgauUjL
         PnFprzpZiEz5g8G+yLt/KrkvEt+KbnOuWbBE86odXruvWa1cr/db6E+cFIG4CVhjwqYZ
         mKzA7hAlxsGvSMWTZmOYtaT8qXZtYt5JGADrC1zbw/i16LH6FV7x4Q9O5jovAoWDHBcv
         pcLVBKI+guUjqsvg5nFsgMd0MLU5ndSgik2/OUXBqU6k1bvIffB5BEHtfIQ6+dKEjkHo
         2DSw==
X-Forwarded-Encrypted: i=1; AJvYcCXFL7E/vSM7iBcUniccZCK3HqwrPg4JUiuwyp/mFcS2UkVag6zgTSQD/0ugJJDho+16tKk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzej9DF4HUoOYiXeNjxef39uiPIfn1T1MjifWrvgeqU3FATlp9H
	hVqRdhvT10szqvGamfZAzImkOk1gxfXNu5OK8UtQkiA9lLUcLGCHk59D8kLCRG7GMAQllZQK0jR
	t5YRM/b8UooBj74ovlgnC3e9MlPFpHxKykd1J
X-Google-Smtp-Source: AGHT+IGZ5s+xfpwPSbOtejqwfZnx/hf6qsZbzQl2k3HROvI0Is2tQu3TnsQeOOSOP+CtDDbO5FljpJjN2LTB239psrY=
X-Received: by 2002:a05:600c:1f06:b0:42c:abae:2ed5 with SMTP id
 5b1f17b1804b1-43116e07766mr33155e9.3.1728505349466; Wed, 09 Oct 2024 13:22:29
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240823235648.3236880-1-dmatlack@google.com> <20240823235648.3236880-5-dmatlack@google.com>
 <CAHVum0ffQFnu2-uGYCsxQJt4HxmC+dTKP=StzRJgHxajJ7tYoA@mail.gmail.com> <Zwa-9mItmmiKeVsd@google.com>
In-Reply-To: <Zwa-9mItmmiKeVsd@google.com>
From: Vipin Sharma <vipinsh@google.com>
Date: Wed, 9 Oct 2024 13:21:52 -0700
Message-ID: <CAHVum0di0z1G7qDfexErzi_f99_T_fTPbZM0s2=TYFCQ8K5pBg@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] KVM: x86/mmu: Recover TDP MMU huge page mappings
 in-place instead of zapping
To: Sean Christopherson <seanjc@google.com>
Cc: David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 9, 2024 at 10:35=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Wed, Oct 09, 2024, Vipin Sharma wrote:
> > On Fri, Aug 23, 2024 at 4:57=E2=80=AFPM David Matlack <dmatlack@google.=
com> wrote:
> > > +static u64 modify_spte_protections(u64 spte, u64 set, u64 clear)
> > >  {
> > >         bool is_access_track =3D is_access_track_spte(spte);
> > >
> > >         if (is_access_track)
> > >                 spte =3D restore_acc_track_spte(spte);
> > >
> > > -       spte &=3D ~shadow_nx_mask;
> > > -       spte |=3D shadow_x_mask;
> > > +       spte =3D (spte | set) & ~clear;
> >
> > We should add a check here WARN_ON_ONCE(set & clear) because if both
> > have a common bit set to 1 then the result  will be different between:
> > 1. spte =3D (spt | set) & ~clear
> > 2. spte =3D (spt | ~clear) & set
> >
> > In the current form, 'clear' has more authority in the final value of s=
pte.
>
> KVM_MMU_WARN_ON(), overlapping @set and @clear is definitely something th=
at should
> be caught during development, i.e. we don't need to carry the WARN_ON_ONC=
E() in
> production kernels
>
> > > +u64 make_huge_spte(struct kvm *kvm, u64 small_spte, int level)
> > > +{
> > > +       u64 huge_spte;
> > > +
> > > +       if (KVM_BUG_ON(!is_shadow_present_pte(small_spte), kvm))
> > > +               return SHADOW_NONPRESENT_VALUE;
> > > +
> > > +       if (KVM_BUG_ON(level =3D=3D PG_LEVEL_4K, kvm))
> > > +               return SHADOW_NONPRESENT_VALUE;
> > > +
> >
> > KVM_BUG_ON() is very aggressive. We should replace it with WARN_ON_ONCE=
()
>
> I'm tempted to say KVM_MMU_WARN_ON() here too.

I am fine with KVM_MMU_WARN_ON() here. Callers should check for the
value they provided and returned from this API and if it's important
to them in Production then decide on next steps accordingly.

