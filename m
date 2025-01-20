Return-Path: <kvm+bounces-35975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97CEBA16AF7
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 11:44:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96E213A64F0
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 10:43:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0CA41B413E;
	Mon, 20 Jan 2025 10:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4fNYZGUh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC3B1B87CE
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 10:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737369826; cv=none; b=MrPeIZQFlqE8E4yPf1OMGfo+pO8jwQca36+ZsXEprCLZPCTcln9DvZNcyLl1v7iMbjWm8jeBWWkd4Zfh9gWd3vtKxuBlYnuSEMDVxonrp7qD9bxneWVFs5eUInA/F7z6mvrNELTIheXkIcAWccFiQ99kOtzsjR7iYjUrPJk4MPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737369826; c=relaxed/simple;
	bh=9FfZVe4b3vhg+Sfn5IiARIE7pS6oqmRvc1QDczltBuo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rb+lpWZjF/5FWz/ocfWFuFq/pqG2g2jDEGejpqO3nPyrhN9yOCCKmTOmYdzZjf/sJhpmEo2RdsaWW+Ysk66JN41ll4qZryZ+LicKvXI6YrlPObJxv/rTW5GebzytjnMJA7i1N5eAEiu3X5SwZrceFQu58xrs4XqKeiOlLJBTioE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4fNYZGUh; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-435b0df5dbdso73045e9.0
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 02:43:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737369823; x=1737974623; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gtyHizTgd9OfFYLkI8lyOfPyBAyYNnRj5gwYAtdvydI=;
        b=4fNYZGUh9ScYp/gzs+YDc/RxDMrRj6o2QMlet0TT1qIeoBC0Noll0u3CjfmGWYi0ck
         vLYiLyJB6+5BP9V+kAymv+rrfRD64yLhW+JWF9HQOi8rv7mLsL+LvC7UOsPanHy1i0wK
         5gL9CaYIR6fyT/tVtzM9/ChfwTs7NilkJVwRwg6jZboXx3/GYQMDShF0LRF71FzXHHUB
         a2xEBliDWoc5ct5LYWAjiSnMBBOFNb2EnLbCdioz9Ed1NzTVTPHNyKTNxboEY0DxKqmL
         nbyXi2+81H1vCrLaSMsSTQLPKAm81QTv+ktIO7CU7A/OBOYbNp5qQr9itP5zS+75J4ZC
         arjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737369823; x=1737974623;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gtyHizTgd9OfFYLkI8lyOfPyBAyYNnRj5gwYAtdvydI=;
        b=JXL4YsMwf3/EArU4SVSo6PIq4FUdtWthyjUyw+WhXXJJ6/rLKUkYLucGwww/xVpVy9
         mR5ZAma610XiFpguxnS6E8wU6gDLtVdI/+12UBgVIE+nikCLQu3j8hiFHqaNInx6mo5X
         cX5JsKCmz2jMjsIVOijKxsMU2AJCbZMWqclVcogV6UICFDE9H1+pqWg5E0vrddRCr/J9
         thL7YS6jX5JzjWphmjG9lodYoBOfT59ox9Ui9qIWoMwoVmg6eTdQSLhHPcYBHZdpmPvF
         FAutBpXz1OnJe2Ii1uANFZYCfsFtcP9p3Cxx2aum4xN4pRr3We26heHiWvuODA9LcalD
         w1YA==
X-Gm-Message-State: AOJu0YwEC5RpntPcbCok6D7nTeOg0D3NHBWcYT65wVldMtEhREXwgd+S
	KY3HojcwA0DfDuodOVbDhqTcfZXvgTSn8ALbpn/jfGKWXepUD9Do/D5dDpMTEp+IybOvkK6FXer
	xXBsbnC0pVXFTW2M8PoU8DWyPJvrKFPNqjkXx
X-Gm-Gg: ASbGnctqlbozAMKqFBuaymjR7yuIxkA4yzeKrs0set9LA9vncAogPjdqMKXO8+Czb0N
	3k7KfYrRwOxFUyPt02O1QzrEmfMwQnRcFng948iSLpJPr0nlqWg==
X-Google-Smtp-Source: AGHT+IEFtQ6XvmXZuX/8tACQygJkjqQww0pl9ZAAKVz9eTLzDlyCLWLq0l2L6OY8U+uEiBnaF1CwVJq7Ea7mRykWRo8=
X-Received: by 2002:a05:600c:3b9c:b0:436:186e:13a6 with SMTP id
 5b1f17b1804b1-438a0c4c155mr2424435e9.6.1737369823127; Mon, 20 Jan 2025
 02:43:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250117163001.2326672-1-tabba@google.com> <20250117163001.2326672-2-tabba@google.com>
 <0f588655-62c0-46c3-bd15-01016615953f@redhat.com>
In-Reply-To: <0f588655-62c0-46c3-bd15-01016615953f@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 20 Jan 2025 10:43:06 +0000
X-Gm-Features: AbW1kvZLQbxvixcsMAGSfw-d4tIbwHt3wKcd2__DJ7I2f8BhUWRabX-EZuB6KlU
Message-ID: <CA+EHjTwxeEwN4RV_ga+qd_cOQut+_Ry8RA_ROK9jYkspSW1nqA@mail.gmail.com>
Subject: Re: [RFC PATCH v5 01/15] mm: Consolidate freeing of typed folios on
 final folio_put()
To: David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
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

On Mon, 20 Jan 2025 at 10:39, David Hildenbrand <david@redhat.com> wrote:
>
> On 17.01.25 17:29, Fuad Tabba wrote:
> > Some folio types, such as hugetlb, handle freeing their own
> > folios. Moreover, guest_memfd will require being notified once a
> > folio's reference count reaches 0 to facilitate shared to private
> > folio conversion, without the folio actually being freed at that
> > point.
> >
> > As a first step towards that, this patch consolidates freeing
> > folios that have a type. The first user is hugetlb folios. Later
> > in this patch series, guest_memfd will become the second user of
> > this.
> >
> > Suggested-by: David Hildenbrand <david@redhat.com>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >   include/linux/page-flags.h | 15 +++++++++++++++
> >   mm/swap.c                  | 24 +++++++++++++++++++-----
> >   2 files changed, 34 insertions(+), 5 deletions(-)
> >
> > diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> > index 691506bdf2c5..6615f2f59144 100644
> > --- a/include/linux/page-flags.h
> > +++ b/include/linux/page-flags.h
> > @@ -962,6 +962,21 @@ static inline bool page_has_type(const struct page *page)
> >       return page_mapcount_is_type(data_race(page->page_type));
> >   }
> >
> > +static inline int page_get_type(const struct page *page)
> > +{
> > +     return page->page_type >> 24;
> > +}
> > +
> > +static inline bool folio_has_type(const struct folio *folio)
> > +{
> > +     return page_has_type(&folio->page);
> > +}
> > +
> > +static inline int folio_get_type(const struct folio *folio)
> > +{
> > +     return page_get_type(&folio->page);
> > +}
> > +
> >   #define FOLIO_TYPE_OPS(lname, fname)                                        \
> >   static __always_inline bool folio_test_##fname(const struct folio *folio) \
> >   {                                                                   \
> > diff --git a/mm/swap.c b/mm/swap.c
> > index 10decd9dffa1..6f01b56bce13 100644
> > --- a/mm/swap.c
> > +++ b/mm/swap.c
> > @@ -94,6 +94,20 @@ static void page_cache_release(struct folio *folio)
> >               unlock_page_lruvec_irqrestore(lruvec, flags);
> >   }
> >
> > +static void free_typed_folio(struct folio *folio)
> > +{
> > +     switch (folio_get_type(folio)) {
> > +     case PGTY_hugetlb:
> > +             free_huge_folio(folio);
> > +             return;
> > +     case PGTY_offline:
> > +             /* Nothing to do, it's offline. */
> > +             return;
>
> Please drop the PGTY_offline part for now, it was rather to highlight
> what could be done.

Will do.

Thanks,
/fuad

>
> But the real goal will be to not make offline pages
> use the refcount at all (frozen).
>
> If we really want the temporary PGTY_offline change, it should be
> introduced separately.
>
> Apart from that LGTM!
>
> --
> Cheers,
>
> David / dhildenb
>

