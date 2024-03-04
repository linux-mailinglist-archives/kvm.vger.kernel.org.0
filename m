Return-Path: <kvm+bounces-10745-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AA27F86F8BB
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 03:59:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 20D461F21544
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 02:59:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF8AE4696;
	Mon,  4 Mar 2024 02:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gPRhWubK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE1E17C9;
	Mon,  4 Mar 2024 02:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709521188; cv=none; b=cR3FoGtUdHUT2iGUwprV7OHoSc47enD6k9iySl9SlOoi9A9rXy+QcGvyVvBm26BzKVafCk9Z5pLU+AmBhL0FddexNOUsY2WMuETrfmz1JVhCB8tfyB9lfrbTu1yv4loT16ossQ6K5gpp3ZIxvzGwAOaJseGQq3HGzKmDzhZyg0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709521188; c=relaxed/simple;
	bh=baAlzvP/8gvZkunwMUl4mKXb0Fl9O5lk3e87e/oqOtM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dv0TRdsYOyGg4tEwBkimdTdwgOwLDlIkPljPjBNfubzh7hd/cw6wLcXpFP0ju7xcc7y/2rXUkCsUNToJY+ka7F4Et19ryGwT0e1VlAJSKoEOFCDZ8jqOnulsTAtAtyevOqPwhDveAtyJZz65U3eknN/87pTRaElVIO/lpRMiZ9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gPRhWubK; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709521186; x=1741057186;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=baAlzvP/8gvZkunwMUl4mKXb0Fl9O5lk3e87e/oqOtM=;
  b=gPRhWubKG+ZrRBjylEPrzODXxe6R5gyrq3OfLdQSACa67qNRhnnaNFho
   UJqban+TwUTzuZ0fBZKzlHdKSlCq4buIMcsVm/rryMC4u6oipFOQ/xdE8
   f/q6GIVA6BClrQzj70H1/Y1wlCLORbr5LhUf6w64ZdU2YLCHnieekuG1C
   +QP1I26EJgkJtvWYyialzSV5MHUFGBNfGpbiUB6M4k27fT4spx67dRV4J
   sbNk1flf8tDw21/xGIBpvCaXk2yJBfQqPZTGdj+ExSR/Dm5bJKZP5nSYg
   hiMdxcQqIhb/8BPIPY8hafUkBsbqqukUTTIMlWAkPuK8GizESuccpv4YW
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11002"; a="4160406"
X-IronPort-AV: E=Sophos;i="6.06,203,1705392000"; 
   d="scan'208";a="4160406"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2024 18:59:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,203,1705392000"; 
   d="scan'208";a="9201834"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa007.jf.intel.com with ESMTP; 03 Mar 2024 18:59:43 -0800
Date: Mon, 4 Mar 2024 10:55:31 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>,
	Yosry Ahmed <yosryahmed@google.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	michael.roth@amd.com, isaku.yamahata@intel.com,
	thomas.lendacky@amd.com
Subject: Re: [PATCH 17/21] filemap: add FGP_CREAT_ONLY
Message-ID: <ZeU4I+w7DfRgtDMO@yilunxu-OptiPlex-7050>
References: <20240227232100.478238-1-pbonzini@redhat.com>
 <20240227232100.478238-18-pbonzini@redhat.com>
 <Zd6W-aLnovAI1FL3@google.com>
 <CAJD7tkapC6es9qjaOf=SmE9XYUdbh_fAperjSe9hy=_iqdB0wQ@mail.gmail.com>
 <Zd8x3w2mwyAufKvm@casper.infradead.org>
 <CABgObfZ9LFDrtLkMaT5LVwy0Z2QMk6SqJ104+D=w7o9i0gEu+g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfZ9LFDrtLkMaT5LVwy0Z2QMk6SqJ104+D=w7o9i0gEu+g@mail.gmail.com>

On Wed, Feb 28, 2024 at 02:28:45PM +0100, Paolo Bonzini wrote:
> On Wed, Feb 28, 2024 at 2:15 PM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Tue, Feb 27, 2024 at 06:17:34PM -0800, Yosry Ahmed wrote:
> > > On Tue, Feb 27, 2024 at 6:15 PM Sean Christopherson <seanjc@google.com> wrote:
> > > >
> > > > On Tue, Feb 27, 2024, Paolo Bonzini wrote:
> > > >
> > > > This needs a changelog, and also needs to be Cc'd to someone(s) that can give it
> > > > a thumbs up.
> > >
> > > +Matthew Wilcox
> >
> > If only there were an entry in MAINTAINERS for filemap.c ...
> 
> Not CCing you (or mm in general) was intentional because I first
> wanted a review of the KVM APIs; of course I wouldn't have committed
> it without an Acked-by. But yeah, not writing the changelog yet was
> pure laziness.
> 
> Since you're here: KVM would like to add a ioctl to encrypt and
> install a page into guest_memfd, in preparation for launching an
> encrypted guest. For this API we want to rule out the possibility of
> overwriting a page that is already in the guest_memfd's filemap,
> therefore this API would pass FGP_CREAT_ONLY|FGP_CREAT
> into__filemap_get_folio. Do you think this is bogus...
> 
> > This looks bogus to me, and if it's not bogus, it's incomplete.
> 
> ... or if not, what incompleteness can you spot?
> 
> Thanks,
> 
> Paolo
> 
> > But it's hard to judge without a commit message that describes what it's
> > supposed to mean.
> >
> > > >
> > > > > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > > > > ---
> > > > >  include/linux/pagemap.h | 2 ++
> > > > >  mm/filemap.c            | 4 ++++
> > > > >  2 files changed, 6 insertions(+)
> > > > >
> > > > > diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> > > > > index 2df35e65557d..e8ac0b32f84d 100644
> > > > > --- a/include/linux/pagemap.h
> > > > > +++ b/include/linux/pagemap.h
> > > > > @@ -586,6 +586,7 @@ pgoff_t page_cache_prev_miss(struct address_space *mapping,
> > > > >   * * %FGP_CREAT - If no folio is present then a new folio is allocated,
> > > > >   *   added to the page cache and the VM's LRU list.  The folio is
> > > > >   *   returned locked.
> > > > > + * * %FGP_CREAT_ONLY - Fail if a folio is not present
                                                     ^
So should be: Fail if a folio is present.

Thanks,
Yilun

> > > > >   * * %FGP_FOR_MMAP - The caller wants to do its own locking dance if the
> > > > >   *   folio is already in cache.  If the folio was allocated, unlock it
> > > > >   *   before returning so the caller can do the same dance.
> > > > > @@ -606,6 +607,7 @@ typedef unsigned int __bitwise fgf_t;
> > > > >  #define FGP_NOWAIT           ((__force fgf_t)0x00000020)
> > > > >  #define FGP_FOR_MMAP         ((__force fgf_t)0x00000040)
> > > > >  #define FGP_STABLE           ((__force fgf_t)0x00000080)
> > > > > +#define FGP_CREAT_ONLY               ((__force fgf_t)0x00000100)
> > > > >  #define FGF_GET_ORDER(fgf)   (((__force unsigned)fgf) >> 26) /* top 6 bits */
> > > > >
> > > > >  #define FGP_WRITEBEGIN               (FGP_LOCK | FGP_WRITE | FGP_CREAT | FGP_STABLE)
> > > > > diff --git a/mm/filemap.c b/mm/filemap.c
> > > > > index 750e779c23db..d5107bd0cd09 100644
> > > > > --- a/mm/filemap.c
> > > > > +++ b/mm/filemap.c
> > > > > @@ -1854,6 +1854,10 @@ struct folio *__filemap_get_folio(struct address_space *mapping, pgoff_t index,
> > > > >               folio = NULL;
> > > > >       if (!folio)
> > > > >               goto no_page;
> > > > > +     if (fgp_flags & FGP_CREAT_ONLY) {
> > > > > +             folio_put(folio);
> > > > > +             return ERR_PTR(-EEXIST);
> > > > > +     }
> > > > >
> > > > >       if (fgp_flags & FGP_LOCK) {
> > > > >               if (fgp_flags & FGP_NOWAIT) {
> > > > > --
> > > > > 2.39.0
> > > > >
> > > > >
> > > >
> >
> 
> 

