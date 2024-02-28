Return-Path: <kvm+bounces-10185-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 734F286A672
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 03:18:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2F71A284C71
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 02:18:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E59DD1947E;
	Wed, 28 Feb 2024 02:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ppEAyUak"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7919C4C90
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 02:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709086695; cv=none; b=PT1QxmHT7wkRCghLcHi/EjBP4kWchuTxqAtLAQ0Vd6BJhqsmAqCJlgGnXFx74XAT1QpckRk8WQUSunIzjJzXfjRhju0DkabhLvlGVdoyc7de7m0bDRusfphev/bOFEapCho62X+n+BEA/MG+ear8E8i+RmB8h5G91Gk0+ZnmjHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709086695; c=relaxed/simple;
	bh=wAJMP/rjGSTVeulk/izYYwgmW/lGJuNoksrR8Forbog=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m/xl95W4zMmmZP2pWRWKQ+DuDyZtNdON6n0Z4p+xWO0gMdDxv51ljetiJ6LU7oB5nfph8agKOc5jvv0X4K3ImMiScyw88sQIOOW3avysqyMkfOwLXo4UUWK/Bn2Ze1L6oAPqslmGONi5ev2Y209xBoHmO1n0rmwm70L5DStpNXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ppEAyUak; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-563c403719cso6171919a12.2
        for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 18:18:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709086692; x=1709691492; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mnovH/WwqoUfUjM68lvOHqxD1r2xoiTwaBE2RBdRmeQ=;
        b=ppEAyUak2msSbz0GDvZoh8d+j7zul/4gR+KjBlqqEFZvzY9IVaJxCTPb+O3NgqFWIL
         LbRkCciGEEoDZh2XmdUUJpctWN7PGih0Tky99SnIW9ZWNvL2ZC+6X5GYSlJPrNbxyKiX
         8+/spiuRQVywK+gmQCUO4yFxiYh2MPrqMynE/uEuHbvrMgyyMcjmchDZxyErze+6otb5
         o/Vn4edZssixeJaST6EJtLyRnQjgXfNfxqlWB9zvARV33nCdzrNMBcSk5J0ppqvVs5tV
         vU2SX088K5YMZKp5XUg53UG8ZxY1Xf6Qm/ucrOy7co6xjIwYv8p2n17o0UZgKIAFAtDi
         As7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709086692; x=1709691492;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mnovH/WwqoUfUjM68lvOHqxD1r2xoiTwaBE2RBdRmeQ=;
        b=eLzY24GYZPJWZclt7sAHBkvKJ8r65j02ztZnvsZuiKq+XVSne2czJ4FpYdjZGF8Qda
         GSmdW6Eg0b5hYL1x5OLaIbNhCxZINcDmDhlGnyhp8pNTVfr4/yKmokxychVebFuqNLut
         M7YPoJrKK7sgIsRTIdgz6W8cY6/I5lrYGXuF/vjuSBPr4WPyxhRdtfv/I5WzIWY2CoHM
         UGo2mRJpCgoqrmHtgbHv4k3f8kw6j1KV6uku8sTBf4UfYuBys88dD+bum1S9zWCD3hHH
         nSiwKfaYXtielSwv4EE0lnBpy9l42+LCMk3orFlHkh1viK07XfYKLAjRqtVhVRkYnAbG
         1+Sw==
X-Forwarded-Encrypted: i=1; AJvYcCU91oyrIwcW9ZByH++zTbzOMIiPMDiss0nqXll7TDd0iKmbehubPTF0tkLqSU3kplDhv3doYRQXUwqATVFgPIc43JI5
X-Gm-Message-State: AOJu0YyQwrY5JWxtYntEb86pHjz6JjBYgMvnJuQs+d46NOxR5Y060FdE
	g6CsAHwtiekLN72PD1RJu6YQcgJ+oNoHQqN5OuGQMLI1nfrET+nemHHIZi4YuAmnfFRBPgenu+r
	cEhqdvgvmuknaVJudfjZ0/iQQyRE7L8bPGR6n
X-Google-Smtp-Source: AGHT+IHQZZ3zPmlSGvwEFJE+4UsPeBBcNupU3Pyfe+fYGWNJx1MOqwEHgIODePoyh3qPMjbtY9EfahMZlzE8HUkFmM0=
X-Received: by 2002:a17:906:4809:b0:a3f:1b49:c92b with SMTP id
 w9-20020a170906480900b00a3f1b49c92bmr7585886ejq.48.1709086691753; Tue, 27 Feb
 2024 18:18:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240227232100.478238-1-pbonzini@redhat.com> <20240227232100.478238-18-pbonzini@redhat.com>
 <Zd6W-aLnovAI1FL3@google.com>
In-Reply-To: <Zd6W-aLnovAI1FL3@google.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Tue, 27 Feb 2024 18:17:34 -0800
Message-ID: <CAJD7tkapC6es9qjaOf=SmE9XYUdbh_fAperjSe9hy=_iqdB0wQ@mail.gmail.com>
Subject: Re: [PATCH 17/21] filemap: add FGP_CREAT_ONLY
To: Sean Christopherson <seanjc@google.com>, Matthew Wilcox <willy@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	michael.roth@amd.com, isaku.yamahata@intel.com, thomas.lendacky@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 27, 2024 at 6:15=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Tue, Feb 27, 2024, Paolo Bonzini wrote:
>
> This needs a changelog, and also needs to be Cc'd to someone(s) that can =
give it
> a thumbs up.

+Matthew Wilcox

>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >  include/linux/pagemap.h | 2 ++
> >  mm/filemap.c            | 4 ++++
> >  2 files changed, 6 insertions(+)
> >
> > diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> > index 2df35e65557d..e8ac0b32f84d 100644
> > --- a/include/linux/pagemap.h
> > +++ b/include/linux/pagemap.h
> > @@ -586,6 +586,7 @@ pgoff_t page_cache_prev_miss(struct address_space *=
mapping,
> >   * * %FGP_CREAT - If no folio is present then a new folio is allocated=
,
> >   *   added to the page cache and the VM's LRU list.  The folio is
> >   *   returned locked.
> > + * * %FGP_CREAT_ONLY - Fail if a folio is not present
> >   * * %FGP_FOR_MMAP - The caller wants to do its own locking dance if t=
he
> >   *   folio is already in cache.  If the folio was allocated, unlock it
> >   *   before returning so the caller can do the same dance.
> > @@ -606,6 +607,7 @@ typedef unsigned int __bitwise fgf_t;
> >  #define FGP_NOWAIT           ((__force fgf_t)0x00000020)
> >  #define FGP_FOR_MMAP         ((__force fgf_t)0x00000040)
> >  #define FGP_STABLE           ((__force fgf_t)0x00000080)
> > +#define FGP_CREAT_ONLY               ((__force fgf_t)0x00000100)
> >  #define FGF_GET_ORDER(fgf)   (((__force unsigned)fgf) >> 26) /* top 6 =
bits */
> >
> >  #define FGP_WRITEBEGIN               (FGP_LOCK | FGP_WRITE | FGP_CREAT=
 | FGP_STABLE)
> > diff --git a/mm/filemap.c b/mm/filemap.c
> > index 750e779c23db..d5107bd0cd09 100644
> > --- a/mm/filemap.c
> > +++ b/mm/filemap.c
> > @@ -1854,6 +1854,10 @@ struct folio *__filemap_get_folio(struct address=
_space *mapping, pgoff_t index,
> >               folio =3D NULL;
> >       if (!folio)
> >               goto no_page;
> > +     if (fgp_flags & FGP_CREAT_ONLY) {
> > +             folio_put(folio);
> > +             return ERR_PTR(-EEXIST);
> > +     }
> >
> >       if (fgp_flags & FGP_LOCK) {
> >               if (fgp_flags & FGP_NOWAIT) {
> > --
> > 2.39.0
> >
> >
>

