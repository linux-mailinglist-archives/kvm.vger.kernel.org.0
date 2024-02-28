Return-Path: <kvm+bounces-10253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3505486B057
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 14:29:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E3AA628B024
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 13:29:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DA8214F97A;
	Wed, 28 Feb 2024 13:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TAxh1R06"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959E814DFD6
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 13:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709126943; cv=none; b=NZtI2T26k/Qnna1EQm5ForY40AReBHeOSt3CnuxC+qrFXxlWNhxKytGn347QWeAEkTpzYujq+hq7orIpT4iyM90e8uLWR5D+RIboa558zniAANKA5RGKydU5f1U5mOvTEHuFdgW2hMeYCnxF4QIRvByKbCTI7lxfPFqAads8zqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709126943; c=relaxed/simple;
	bh=IfmFXfbK3R/LIyE90QHJWRfTx4KyigVZpqXpto5Q4DU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qi6D53Cg3ScsDaT/5R3iwUmndb+6mNqOQJOHi8X/5aD5AoaSsEBGm5yH4aYjz27Fi4omuJEYn29jilXhAC34DaT25qXsmCdvd6N5iytE3+oeUdx9ucT1FlQJ5S+Fc7JJKy7NcdlU371yVhwmJLAjlfwleJzAmBhst/24KUjoHos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TAxh1R06; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709126940;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZzKz87X7zhw07wGgQEpRWyJyCCLZwlQ33or22c6llKE=;
	b=TAxh1R065+ZO/3KuTOom3uXfIAfPVqlvaTffvKUQuFn44gOoZtb6WTM7ddnIUQ+w/Eftrm
	NHDc1r/iJCkEZjanMQo+VnQGml5VSQdcKgWPCwFf+wJlTc16Eni32Si8Q0EUMCmcNog36X
	RNB/XHo339lBVYgJnwU3l01bocEbr24=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-656-snKAbynjNL-OYwL04b29HQ-1; Wed, 28 Feb 2024 08:28:59 -0500
X-MC-Unique: snKAbynjNL-OYwL04b29HQ-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-33d51bb9353so2900743f8f.2
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 05:28:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709126938; x=1709731738;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZzKz87X7zhw07wGgQEpRWyJyCCLZwlQ33or22c6llKE=;
        b=Z1khmHfPzLVLGXXfZ49uDq0AD9ofsgfg7WKpCKBGPKT0S6ZNG+KdFQmL9/pN9xo9m7
         IjjdtDvu1DL2lLP6zWxLShQo+KjZFPs+gYIyF94s9NLA3IqtA9npDNqLzqcxKWfn5ToH
         uo/ZwcLxYk7806Q7DmptOa7vdW3oyuDiFvn0t5irWzGtauZs7DnkA8jGLP+SOrCvd3+M
         YRnpCr8gJdaxFqNLnfo6cyKQXSepf1JTje/9L6ZUWlXm/50f92K/vOoNG8opxMJ9onHX
         Wt0a5lvIwHfjT09S1FxmCmQzubVYgcewIFQx9hdznizSN69GQ6JSbCeMBB8Y+dlLzTWC
         SSKQ==
X-Forwarded-Encrypted: i=1; AJvYcCU6Dp5CsFdfYMWMbDfkyRh3VpGLlJsw/jKJNCqQCfFt1ZQKgs5jZjcYCIQ+Nnw8YsLrvFpHOZVKnFTKDpYGNbVwPYT4
X-Gm-Message-State: AOJu0YzBHAsEgu/2KdlKf1r2yCT3yfSg9sE7bNRdA2VwxRInLcfsL32Q
	BAu70ITvJMzHYwkHoFzzK7d/jT3StFLXvqlFuMQWuBj3OO25uj0tI+OxzHHKVrsWnX5Dyzies6C
	yi+tluyd1iYv4ITrO95IEjXE2i5g2k5rSI0Lx4PdMq8qyBJrhtMzNoYoqopi+6coLspyY4nymTF
	47rPVlqbhl6b/aHHVrnXZsf9yP
X-Received: by 2002:adf:e810:0:b0:33d:debe:15ee with SMTP id o16-20020adfe810000000b0033ddebe15eemr5490343wrm.41.1709126938104;
        Wed, 28 Feb 2024 05:28:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH/7tTth1UugRontBQamP0uQUJItTsuBcfEuO2T9Qe+0sz/72aEcJpcLxVCnucG0jdzD9JxAvhSiIh44nXuwU0=
X-Received: by 2002:adf:e810:0:b0:33d:debe:15ee with SMTP id
 o16-20020adfe810000000b0033ddebe15eemr5490327wrm.41.1709126937780; Wed, 28
 Feb 2024 05:28:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240227232100.478238-1-pbonzini@redhat.com> <20240227232100.478238-18-pbonzini@redhat.com>
 <Zd6W-aLnovAI1FL3@google.com> <CAJD7tkapC6es9qjaOf=SmE9XYUdbh_fAperjSe9hy=_iqdB0wQ@mail.gmail.com>
 <Zd8x3w2mwyAufKvm@casper.infradead.org>
In-Reply-To: <Zd8x3w2mwyAufKvm@casper.infradead.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 28 Feb 2024 14:28:45 +0100
Message-ID: <CABgObfZ9LFDrtLkMaT5LVwy0Z2QMk6SqJ104+D=w7o9i0gEu+g@mail.gmail.com>
Subject: Re: [PATCH 17/21] filemap: add FGP_CREAT_ONLY
To: Matthew Wilcox <willy@infradead.org>
Cc: Yosry Ahmed <yosryahmed@google.com>, Sean Christopherson <seanjc@google.com>, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, michael.roth@amd.com, 
	isaku.yamahata@intel.com, thomas.lendacky@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 28, 2024 at 2:15=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Tue, Feb 27, 2024 at 06:17:34PM -0800, Yosry Ahmed wrote:
> > On Tue, Feb 27, 2024 at 6:15=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > On Tue, Feb 27, 2024, Paolo Bonzini wrote:
> > >
> > > This needs a changelog, and also needs to be Cc'd to someone(s) that =
can give it
> > > a thumbs up.
> >
> > +Matthew Wilcox
>
> If only there were an entry in MAINTAINERS for filemap.c ...

Not CCing you (or mm in general) was intentional because I first
wanted a review of the KVM APIs; of course I wouldn't have committed
it without an Acked-by. But yeah, not writing the changelog yet was
pure laziness.

Since you're here: KVM would like to add a ioctl to encrypt and
install a page into guest_memfd, in preparation for launching an
encrypted guest. For this API we want to rule out the possibility of
overwriting a page that is already in the guest_memfd's filemap,
therefore this API would pass FGP_CREAT_ONLY|FGP_CREAT
into__filemap_get_folio. Do you think this is bogus...

> This looks bogus to me, and if it's not bogus, it's incomplete.

... or if not, what incompleteness can you spot?

Thanks,

Paolo

> But it's hard to judge without a commit message that describes what it's
> supposed to mean.
>
> > >
> > > > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > > > ---
> > > >  include/linux/pagemap.h | 2 ++
> > > >  mm/filemap.c            | 4 ++++
> > > >  2 files changed, 6 insertions(+)
> > > >
> > > > diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> > > > index 2df35e65557d..e8ac0b32f84d 100644
> > > > --- a/include/linux/pagemap.h
> > > > +++ b/include/linux/pagemap.h
> > > > @@ -586,6 +586,7 @@ pgoff_t page_cache_prev_miss(struct address_spa=
ce *mapping,
> > > >   * * %FGP_CREAT - If no folio is present then a new folio is alloc=
ated,
> > > >   *   added to the page cache and the VM's LRU list.  The folio is
> > > >   *   returned locked.
> > > > + * * %FGP_CREAT_ONLY - Fail if a folio is not present
> > > >   * * %FGP_FOR_MMAP - The caller wants to do its own locking dance =
if the
> > > >   *   folio is already in cache.  If the folio was allocated, unloc=
k it
> > > >   *   before returning so the caller can do the same dance.
> > > > @@ -606,6 +607,7 @@ typedef unsigned int __bitwise fgf_t;
> > > >  #define FGP_NOWAIT           ((__force fgf_t)0x00000020)
> > > >  #define FGP_FOR_MMAP         ((__force fgf_t)0x00000040)
> > > >  #define FGP_STABLE           ((__force fgf_t)0x00000080)
> > > > +#define FGP_CREAT_ONLY               ((__force fgf_t)0x00000100)
> > > >  #define FGF_GET_ORDER(fgf)   (((__force unsigned)fgf) >> 26) /* to=
p 6 bits */
> > > >
> > > >  #define FGP_WRITEBEGIN               (FGP_LOCK | FGP_WRITE | FGP_C=
REAT | FGP_STABLE)
> > > > diff --git a/mm/filemap.c b/mm/filemap.c
> > > > index 750e779c23db..d5107bd0cd09 100644
> > > > --- a/mm/filemap.c
> > > > +++ b/mm/filemap.c
> > > > @@ -1854,6 +1854,10 @@ struct folio *__filemap_get_folio(struct add=
ress_space *mapping, pgoff_t index,
> > > >               folio =3D NULL;
> > > >       if (!folio)
> > > >               goto no_page;
> > > > +     if (fgp_flags & FGP_CREAT_ONLY) {
> > > > +             folio_put(folio);
> > > > +             return ERR_PTR(-EEXIST);
> > > > +     }
> > > >
> > > >       if (fgp_flags & FGP_LOCK) {
> > > >               if (fgp_flags & FGP_NOWAIT) {
> > > > --
> > > > 2.39.0
> > > >
> > > >
> > >
>


