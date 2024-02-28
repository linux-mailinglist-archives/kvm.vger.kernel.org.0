Return-Path: <kvm+bounces-10252-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BD0486B016
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 14:15:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C8541C23D1C
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 13:15:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2161714AD3A;
	Wed, 28 Feb 2024 13:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="afJQMzgR"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F7314A4FB;
	Wed, 28 Feb 2024 13:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709126117; cv=none; b=ArZKQNJ4izRYOUNy8d4TAkpru6dZEvBJj8awxZh7MxQYlB+gP4ecmkFb2gNEmuu0DFayx1/IZ/aZn5bycWy64EwB8dWglEDTk28zIqwS+8ZnnSVj40g63LeC1rnHz2HYU0pT3SA+7i4tYmZUpI9mWGMcMHX/JC351jFTdU1IXSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709126117; c=relaxed/simple;
	bh=x5DAa4w3ucuQL2gRP9LGTsa9jfwHP3rQYy7xsCi5Wmw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SsZEDf+lNKtsorFJ7YJG7VEEDK6Dcbg90/tvLUmu4QIaLHhYYwN0GR08GEM2ZhGJS6zvzbm80avRr+iFpWDYfkOkEXSQn74fZQ2LRYAMd+rKfE7bxEJ0MKBqKgKwKsbxq2bkt5aChxxS7CZnr3wJxYRyQkxDJs51wBwpjiHkxUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=afJQMzgR; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=r8vbNEwwu+aBkNpFD6Z1wwPalWetOGt3ThcRRchjvf4=; b=afJQMzgRmi9QJv2I9KZKPZSj9A
	yzmjVmPqSi8q04wv+igzpCR+aTfETNiVH1gWB0OdF4SmudJlSaV8va3TNQ4DX02Ep2tz3RHvsh8RU
	i3RgAksSmM9+IO946LtjgSLrL64ycVg21jl441XIjobz39NXESJ0mqYeIHfy8eqJLfgWM5u1MOSOp
	9txR1owwuyFXWvFt6agqUx1DTB3jD10ZKyTJ6tj0qlDWxB8Ya1qP/CvKWKFliHx5Vd5I8lDrFmHg2
	6PoIKzjiv57RmbIB6jfI4aJlXt/Gt2ELCjO6d8Vt5Tf/Nx4J+u3/brpRH3PDThUACvSWRBjfhehIm
	y+MNaNdA==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfJmB-00000005GZt-24JJ;
	Wed, 28 Feb 2024 13:15:11 +0000
Date: Wed, 28 Feb 2024 13:15:11 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, michael.roth@amd.com, isaku.yamahata@intel.com,
	thomas.lendacky@amd.com
Subject: Re: [PATCH 17/21] filemap: add FGP_CREAT_ONLY
Message-ID: <Zd8x3w2mwyAufKvm@casper.infradead.org>
References: <20240227232100.478238-1-pbonzini@redhat.com>
 <20240227232100.478238-18-pbonzini@redhat.com>
 <Zd6W-aLnovAI1FL3@google.com>
 <CAJD7tkapC6es9qjaOf=SmE9XYUdbh_fAperjSe9hy=_iqdB0wQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJD7tkapC6es9qjaOf=SmE9XYUdbh_fAperjSe9hy=_iqdB0wQ@mail.gmail.com>

On Tue, Feb 27, 2024 at 06:17:34PM -0800, Yosry Ahmed wrote:
> On Tue, Feb 27, 2024 at 6:15 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Tue, Feb 27, 2024, Paolo Bonzini wrote:
> >
> > This needs a changelog, and also needs to be Cc'd to someone(s) that can give it
> > a thumbs up.
> 
> +Matthew Wilcox

If only there were an entry in MAINTAINERS for filemap.c ...

This looks bogus to me, and if it's not bogus, it's incomplete.
But it's hard to judge without a commit message that describes what it's
supposed to mean.

> >
> > > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > > ---
> > >  include/linux/pagemap.h | 2 ++
> > >  mm/filemap.c            | 4 ++++
> > >  2 files changed, 6 insertions(+)
> > >
> > > diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> > > index 2df35e65557d..e8ac0b32f84d 100644
> > > --- a/include/linux/pagemap.h
> > > +++ b/include/linux/pagemap.h
> > > @@ -586,6 +586,7 @@ pgoff_t page_cache_prev_miss(struct address_space *mapping,
> > >   * * %FGP_CREAT - If no folio is present then a new folio is allocated,
> > >   *   added to the page cache and the VM's LRU list.  The folio is
> > >   *   returned locked.
> > > + * * %FGP_CREAT_ONLY - Fail if a folio is not present
> > >   * * %FGP_FOR_MMAP - The caller wants to do its own locking dance if the
> > >   *   folio is already in cache.  If the folio was allocated, unlock it
> > >   *   before returning so the caller can do the same dance.
> > > @@ -606,6 +607,7 @@ typedef unsigned int __bitwise fgf_t;
> > >  #define FGP_NOWAIT           ((__force fgf_t)0x00000020)
> > >  #define FGP_FOR_MMAP         ((__force fgf_t)0x00000040)
> > >  #define FGP_STABLE           ((__force fgf_t)0x00000080)
> > > +#define FGP_CREAT_ONLY               ((__force fgf_t)0x00000100)
> > >  #define FGF_GET_ORDER(fgf)   (((__force unsigned)fgf) >> 26) /* top 6 bits */
> > >
> > >  #define FGP_WRITEBEGIN               (FGP_LOCK | FGP_WRITE | FGP_CREAT | FGP_STABLE)
> > > diff --git a/mm/filemap.c b/mm/filemap.c
> > > index 750e779c23db..d5107bd0cd09 100644
> > > --- a/mm/filemap.c
> > > +++ b/mm/filemap.c
> > > @@ -1854,6 +1854,10 @@ struct folio *__filemap_get_folio(struct address_space *mapping, pgoff_t index,
> > >               folio = NULL;
> > >       if (!folio)
> > >               goto no_page;
> > > +     if (fgp_flags & FGP_CREAT_ONLY) {
> > > +             folio_put(folio);
> > > +             return ERR_PTR(-EEXIST);
> > > +     }
> > >
> > >       if (fgp_flags & FGP_LOCK) {
> > >               if (fgp_flags & FGP_NOWAIT) {
> > > --
> > > 2.39.0
> > >
> > >
> >

