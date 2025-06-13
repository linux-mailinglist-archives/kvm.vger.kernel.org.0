Return-Path: <kvm+bounces-49523-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CDF6CAD9673
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 22:36:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C3C201890DDF
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 20:36:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9264F2571A5;
	Fri, 13 Jun 2025 20:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D1ZhRBL0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378BC248F59
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 20:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749846889; cv=none; b=bhHAzBk1wcyuOse/4tkBwvYV/ZEfUJ/kYhsywj1l2bHMwv0ffDtFJsYBr7DYunNm+wNkHJci/uZJa4xTKATOx4KHz2ejaChgmfzJDrJv0Tym/ET9wDpbCZhXwy3yn/rwaTdbDkMDltUmn1X8iaImlmnKAcshSyFNxUW6r6sX+eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749846889; c=relaxed/simple;
	bh=Nwmsmo0C/ausEQGIIbloA5FMUwaktHOEeO6I/CS7P3k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XQD5Un/A44gtadG7tPeCoY9mHQqREqNk1N1li5yNKFvKsA0TkSHuB31x2NLKdZh+C//jEr1+lln7NYh8xEZUGTsVVGsOg/i8pVnyJtntrUZ2i3GoExKPjF0U9fYRYBc6yj7Cj8K9oMMnfyG0gRW9FrSqu/ns9Jj1U8RtKdLhHZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D1ZhRBL0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749846885;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i/VkZvh+/TfWzzVLXxuCe+XlMS5iPUK+Iz2nXOO9uZk=;
	b=D1ZhRBL0Wk/o6Q9HUv82cLQTTArOKO9jwFNsEHHdO1iNKuUYC+BFDbTp0m/dljYgLEu5Uo
	U2nbNPUZnqa/iQ1H7L41rT74os983G5T0atOEjXG1lQ3mfuQ5LOOCtE7j93SiPz/5vT4s+
	gimgMFQEAuLodg+KmrZQO+jl2NE663o=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-182-Mf48BG2IMVyVKCutfHsdmw-1; Fri, 13 Jun 2025 16:34:42 -0400
X-MC-Unique: Mf48BG2IMVyVKCutfHsdmw-1
X-Mimecast-MFC-AGG-ID: Mf48BG2IMVyVKCutfHsdmw_1749846882
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6fac4b26c69so23137056d6.3
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 13:34:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749846882; x=1750451682;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i/VkZvh+/TfWzzVLXxuCe+XlMS5iPUK+Iz2nXOO9uZk=;
        b=dQgP1ShrcctZBFWbZutvCnTnMEMwTHSFXx7Skhd78Ap85qLvTWZDAt18+Pt/aWuMjr
         D0XdRhbuPxV23zRQCFruB3sPaZhwen7b3luZ6REVkAZsIYKUDiaWkUTHwVzqYdsRIXpV
         oX40UkbZ6UL3cxlpgSWDf8C7LWoBrqT0lUaGFXPHtv0vcdVKsnhu3BYPkeFyipBtMd0U
         zvKSYCumNx3/9xDAwiFSEV/2pJZV7UdpYSNbor20NPhC2CHaOdrELZ8Kb9FKHc6gOBnM
         t9uVfjFqkLd2Q9FECeoNnIMUI/nIs2TB5qGgffCti1kHPCb51ahEEzZToCpFud0ZfYZV
         W1HA==
X-Forwarded-Encrypted: i=1; AJvYcCWNmYyi2k6ODLjd2r66PIicg1Rq0cDe5Vmbj/Q/P9pZDni4zvWxDThxVP4Bb2+IF8tx3IM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2hhApdnwmN2GOZxs/Al/Gn777jvmDQRDjvGbbVwXli0XWW/wT
	WIMt1M18ZYnu1ij48XTGLudThE9oIJIWr3eYczHDLlSqyD/xEVFIZzbB6YOVpdLoruJ3hh+aG6C
	cpiYD3sBNxPpoJtYwYJYUoDNDdIYL7C5NXWtakhGQPN008gm/0+OvLg==
X-Gm-Gg: ASbGnctt3NP9C/gnIencBaM6C6Axt6pA4c3hx9zmob3t8fZflOxxmWDP3q6/Jew47MI
	IYPfMwIpAACHI+lGPRWFXPVOJDRJTu2jWwNQW0ZVkeaKZtmgkMRAHp7GUm0AJMYagNICjOLbAvx
	JBEEVFSP+FQunAfHjhbscX/PPN7VcCbBeTm9xeiE3XgBF8WjVUrLeud+e0GJLRreEhEwzJuh+4Q
	DB/sHlxm8vo2HOxNtXIlAsdp5q+0VgrjI+6NYA0GPth41FZME3DlR4nnKQhCfz0nlNkDimVn87S
	RZGQZBLAnds4Ig==
X-Received: by 2002:a05:6214:3389:b0:6fa:ce87:230c with SMTP id 6a1803df08f44-6fb47770502mr13831836d6.25.1749846882128;
        Fri, 13 Jun 2025 13:34:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEKxAs3uYXgwVSM7lRZYkiKWh4BQ0onEp9YDvbKtc5uf+/6cXoFXUN+SDamUNzixpYIF6V8eA==
X-Received: by 2002:a05:6214:3389:b0:6fa:ce87:230c with SMTP id 6a1803df08f44-6fb47770502mr13831426d6.25.1749846881629;
        Fri, 13 Jun 2025 13:34:41 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6fb35c5812csm25479996d6.93.2025.06.13.13.34.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jun 2025 13:34:40 -0700 (PDT)
Date: Fri, 13 Jun 2025 16:34:37 -0400
From: Peter Xu <peterx@redhat.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Zi Yan <ziy@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
	Alex Mastro <amastro@fb.com>, David Hildenbrand <david@redhat.com>,
	Nico Pache <npache@redhat.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>
Subject: Re: [PATCH 3/5] mm: Rename __thp_get_unmapped_area to
 mm_get_unmapped_area_aligned
Message-ID: <aEyLXXV_4OR5_ArX@x1.local>
References: <20250613134111.469884-1-peterx@redhat.com>
 <20250613134111.469884-4-peterx@redhat.com>
 <08193194-3217-4c43-923e-c72cdbbd82e7@lucifer.local>
 <aExxy3WUp6gZx24f@x1.local>
 <9733d8cf-edab-4b2b-bf2e-11457ef63dc8@lucifer.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9733d8cf-edab-4b2b-bf2e-11457ef63dc8@lucifer.local>

On Fri, Jun 13, 2025 at 08:18:42PM +0100, Lorenzo Stoakes wrote:
> On Fri, Jun 13, 2025 at 02:45:31PM -0400, Peter Xu wrote:
> > On Fri, Jun 13, 2025 at 04:36:57PM +0100, Lorenzo Stoakes wrote:
> > > On Fri, Jun 13, 2025 at 09:41:09AM -0400, Peter Xu wrote:
> > > > This function is pretty handy for any type of VMA to provide a size-aligned
> > > > VMA address when mmap().  Rename the function and export it.
> > >
> > > This isn't a great commit message, 'to provide a size-aligned VMA address when
> > > mmap()' is super unclear - do you mean 'to provide an unmapped address that is
> > > also aligned to the specified size'?
> >
> > I sincerely don't know the difference, not a native speaker here..
> > Suggestions welcomed, I can update to whatever both of us agree on.
> 
> Sure, sorry I don't mean to be pedantic I just think it would be clearer to
> sort of expand upon this, as the commit message is rather short.
> 
> I think saying something like this function allows you to locate an
> unmapped region which is aligned to the specified size should suffice.

I changed the commit message to this:

    This function is pretty handy to locate an unmapped region which is aligned
    to the specified alignment, meanwhile taking pgoff into considerations.
    
    Rename the function and export it.  VFIO will be the first candidate to
    reuse this function in follow up patches to calculate mmap() virtual
    addresses for MMIO mappings.

> 
> >
> > >
> > > I think you should also specify your motive, renaming and exporting something
> > > because it seems handy isn't sufficient justifiation.
> > >
> > > Also why would we need to export this? What modules might want to use this? I'm
> > > generally not a huge fan of exporting things unless we strictly have to.
> >
> > It's one of the major reasons why I sent this together with the VFIO
> > patches.  It'll be used in VFIO patches that is in the same series.  I will
> > mention it in the commit message when repost.
> 
> OK cool, I've not dug through those as not my area, really it's about
> having the appropriate justification.
> 
> I'm always inclined to not want us to export things by default, based on
> experience of finding 'unusual' uses of various mm interfaces in drivers in
> the past which have caused problems :)
> 
> But of course there are situations that warrant it, they just need to be
> spelled out.
> 
> >
> > >
> > > >
> > > > About the rename:
> > > >
> > > >   - Dropping "THP" because it doesn't really have much to do with THP
> > > >     internally.
> > >
> > > Well the function seems specifically tailored to the THP use. I think you'll
> > > need to further adjust this.
> >
> > Actually.. it is almost exactly what I need so far.  I can justify it below.
> 
> Yeah, but it's not a general function that gives you an unmapped area that
> is aligned.
> 
> It's a 'function that gets you an aligned unmapped area but only for 64-bit
> kernels and when you are not invoking it from a compat syscall and returns
> 0 instead of errors'.
> 
> This doesn't sound general to me?

I still think it's general.  I think it's a general request for any huge
mappings.  For example, I do not want to enable aggressive VA allocations
on 32 bits systems because I know it's easier to get overloaded VA address
space with 32 bits.  It should also apply to all potential users whoever
wants to use this function by default.

I don't think it always needs to do so, if there's an user that, for
example, want to keep the calculation but still work on 32 bits, we can
provide yet another helper.  But it's not the case as of now, and I can't
think of such user.  In this case, I think it's OK we keep this in the
helper for all existing users, including VFIO.

> 
> >
> > >
> > > >
> > > >   - The suffix "_aligned" imply it is a helper to generate aligned virtual
> > > >     address based on what is specified (which can be not PMD_SIZE).
> > >
> > > Ack this is sensible!
> > >
> > > >
> > > > Cc: Zi Yan <ziy@nvidia.com>
> > > > Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> > > > Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > > > Cc: Ryan Roberts <ryan.roberts@arm.com>
> > > > Cc: Dev Jain <dev.jain@arm.com>
> > > > Cc: Barry Song <baohua@kernel.org>
> > > > Signed-off-by: Peter Xu <peterx@redhat.com>
> > > > ---
> > > >  include/linux/huge_mm.h | 14 +++++++++++++-
> > > >  mm/huge_memory.c        |  6 ++++--
> > > >  2 files changed, 17 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> > > > index 2f190c90192d..706488d92bb6 100644
> > > > --- a/include/linux/huge_mm.h
> > > > +++ b/include/linux/huge_mm.h
> > >
> > > Why are we keeping everything in huge_mm.h, huge_memory.c if this is being made
> > > generic?
> > >
> > > Surely this should be moved out into mm/mmap.c no?
> >
> > No objections, but I suggest a separate discussion and patch submission
> > when the original function resides in huge_memory.c.  Hope it's ok for you.
> 
> I like to be as flexible as I can be in review, but I'm afraid I'm going to
> have to be annoying about this one :)
> 
> It simply makes no sense to have non-THP stuff in 'the THP file'. Also this
> makes this a general memory mapping function that should live with the
> other related code.
> 
> I don't really think much discussion is required here? You could do this as
> 2 separate commits if that'd make life easier?
> 
> Sorry to be a pain here, but I'm really allergic to our having random
> unrelated things in the wrong files, it's something mm has done rather too
> much...

I don't understand why the helper is non-THP.  The alignment so far is
really about huge mappings.  Core mm's HUGE_PFNMAP config option also
depends on THP at least as of now.

# TODO: Allow to be enabled without THP
config ARCH_SUPPORTS_HUGE_PFNMAP
	def_bool n
	depends on TRANSPARENT_HUGEPAGE

> 
> >
> > >
> > > > @@ -339,7 +339,10 @@ unsigned long thp_get_unmapped_area(struct file *filp, unsigned long addr,
> > > >  unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
> > > >  		unsigned long len, unsigned long pgoff, unsigned long flags,
> > > >  		vm_flags_t vm_flags);
> > > > -
> > > > +unsigned long mm_get_unmapped_area_aligned(struct file *filp,
> > > > +		unsigned long addr, unsigned long len,
> > > > +		loff_t off, unsigned long flags, unsigned long size,
> > > > +		vm_flags_t vm_flags);
> > >
> > > I echo Jason's comments about a kdoc and explanation of what this function does.
> > >
> > > >  bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
> > > >  int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
> > > >  		unsigned int new_order);
> > > > @@ -543,6 +546,15 @@ thp_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
> > > >  	return 0;
> > > >  }
> > > >
> > > > +static inline unsigned long
> > > > +mm_get_unmapped_area_aligned(struct file *filp,
> > > > +			     unsigned long addr, unsigned long len,
> > > > +			     loff_t off, unsigned long flags, unsigned long size,
> > > > +			     vm_flags_t vm_flags)
> > > > +{
> > > > +	return 0;
> > > > +}
> > > > +
> > > >  static inline bool
> > > >  can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins)
> > > >  {
> > > > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > > > index 4734de1dc0ae..52f13a70562f 100644
> > > > --- a/mm/huge_memory.c
> > > > +++ b/mm/huge_memory.c
> > > > @@ -1088,7 +1088,7 @@ static inline bool is_transparent_hugepage(const struct folio *folio)
> > > >  		folio_test_large_rmappable(folio);
> > > >  }
> > > >
> > > > -static unsigned long __thp_get_unmapped_area(struct file *filp,
> > > > +unsigned long mm_get_unmapped_area_aligned(struct file *filp,
> > > >  		unsigned long addr, unsigned long len,
> > > >  		loff_t off, unsigned long flags, unsigned long size,
> > > >  		vm_flags_t vm_flags)
> > > > @@ -1132,6 +1132,7 @@ static unsigned long __thp_get_unmapped_area(struct file *filp,
> > > >  	ret += off_sub;
> > > >  	return ret;
> > > >  }
> > > > +EXPORT_SYMBOL_GPL(mm_get_unmapped_area_aligned);
> > >
> > > I'm not convinced about exporting this... shouldn't be export only if we
> > > explicitly have a user?
> > >
> > > I'd rather we didn't unless we needed to.
> > >
> > > >
> > > >  unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
> > > >  		unsigned long len, unsigned long pgoff, unsigned long flags,
> > > > @@ -1140,7 +1141,8 @@ unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long add
> > > >  	unsigned long ret;
> > > >  	loff_t off = (loff_t)pgoff << PAGE_SHIFT;
> > > >
> > > > -	ret = __thp_get_unmapped_area(filp, addr, len, off, flags, PMD_SIZE, vm_flags);
> > > > +	ret = mm_get_unmapped_area_aligned(filp, addr, len, off, flags,
> > > > +					   PMD_SIZE, vm_flags);
> > > >  	if (ret)
> > > >  		return ret;
> > > >
> > > > --
> > > > 2.49.0
> > > >
> > >
> > > So, you don't touch the original function but there's stuff there I think we
> > > need to think about if this is generalised.
> > >
> > > E.g.:
> > >
> > > 	if (!IS_ENABLED(CONFIG_64BIT) || in_compat_syscall())
> > > 		return 0;
> > >
> > > This still valid?
> >
> > Yes.  I want this feature (for VFIO) to not be enabled on 32bits, and not
> > enabled with compat syscals.
> 
> OK, but then is this a 'general' function any more?
> 
> These checks were introduced by commit 4ef9ad19e176 ("mm: huge_memory:
> don't force huge page alignment on 32 bit") and so are _absolutely
> specifically_ intended for a THP use-case.
> 
> And now they _just happen_ to be useful to you but nothing about the
> function name suggests that this is the case?
> 
> I mean it seems like you should be doing this check separately in both VFIO
> and THP code and having the 'general 'function not do this no?

I don't understand, sorry.

If this helper only has two users, the two users want the same check,
shouldn't we keep the check in the helper, rather than duplicating in the
two callers?

> 
> >
> > >
> > > 	/*
> > > 	 * The failure might be due to length padding. The caller will retry
> > > 	 * without the padding.
> > > 	 */
> > > 	if (IS_ERR_VALUE(ret))
> > > 		return 0;
> > >
> > > This is assuming things the (currently single) caller will do, that is no longer
> > > an assumption you can make, especially if exported.
> >
> > It's part of core function we want from a generic helper.  We want to know
> > when the va allocation, after padded, would fail due to the padding. Then
> > the caller can decide what to do next.  It needs to fail here properly.
> 
> I'm no sure I understand what you mean?
> 
> It's not just this case, it's basically any error condition results in 0.
> 
> It's actually quite dangerous, as the get_unmapped_area() functions are
> meant to return either an error value or the located address _and zero is a
> valid response_.

Not by default, when you didn't change vm.mmap_min_addr. I don't think it's
a good idea to be able to return NULL as a virtual address, unless
extremely necessary.  I don't even know whether Linux can do that now.

OTOH, it's common too so far to use this retval in get_unmapped_area().

Currently, the mm API is defined as:

	unsigned long (*get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);

Its retval is unsigned long, and its error is returned by IS_ERR_VALUE().
That's the current API across the whole mm, and that's why this function
does it because when used in THP it's easier for retval processing.  Same
to VFIO, as long as the API didn't change.

I'm OK if any of us wants to refactor this as a whole, but it'll be great
if you could agree we can do it separately, and also discussed separately.

> 
> So if somebody used this function naively, they'd potentially have a very
> nasty bug occur when an error arose.
> 
> If you want to export this, I just don't think we can have this be a thing
> here.
> 
> >
> > >
> > > Actually you maybe want to abstract the whole of thp_get_unmapped_area_vmflags()
> > > no? As this has a fallback mode?
> > >
> > > 	/*
> > > 	 * Do not try to align to THP boundary if allocation at the address
> > > 	 * hint succeeds.
> > > 	 */
> > > 	if (ret == addr)
> > > 		return addr;
> >
> > This is not a fallback. This is when user specified a hint address (no
> > matter with / without MAP_FIXED), if that address works then we should
> > reuse that address, ignoring the alignment requirement from the driver.
> > This is exactly the behavior VFIO needs, and this should also be the
> > suggested behavior for whatever new drivers that would like to start using
> > this generic helper.
> 
> I didn't say this was the fallback :) this just happened to be the code
> underneath my comment. Sorry if that wasn't clear.
> 
> This is another kinda non-general thing but one that makes more sense. This
> comment needs updating, however, obviously. You could just delete 'THP' in
> the comment that'd probalby do it.

Yes, the THP word does not apply anymore.   I'll change it, thanks for
pointing this out.

> 
> The fallback is in:
> 
> unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
> 		unsigned long len, unsigned long pgoff, unsigned long flags,
> 		vm_flags_t vm_flags)
> {
> 	unsigned long ret;
> 	loff_t off = (loff_t)pgoff << PAGE_SHIFT;
> 
> 	ret = __thp_get_unmapped_area(filp, addr, len, off, flags, PMD_SIZE, vm_flags);
> 	if (ret)
> 		return ret;
> 
> So here, if ret returns an address, then it's fine we return that.
> 
> Otherwise, we invoke the below (the fallback):
> 
> 	return mm_get_unmapped_area_vmflags(current->mm, filp, addr, len, pgoff, flags,
> 					    vm_flags);
> }
> 
> >
> > >
> > > What was that about this no longer being relevant to THP? :>)
> > >
> > > Are all of these 'return 0' cases expected by any sensible caller? It seems like
> > > it's a way for thp_get_unmapped_area_vmflags() to recognise when to fall back to
> > > non-aligned?
> >
> > Hope above justfies everything.  It's my intention to reuse everything
> > here.  If you have any concern on any of the "return 0" cases in the
> > function being exported, please shoot, we can discuss.
> 
> Of course, I have some doubts here :)
> 
> >
> > Thanks,
> >
> > --
> > Peter Xu
> >
> 
> To be clearer perhaps, what I think would work here is:
> 
> 1. Remove the CONFIG_64BIT, in_compat_syscall() check and place it in THP
>    and VFIO code separately, as this isn't a general thing.

Commented above.  I still think it should be kept until we have a valid use
case to not enable it.

> 
> 2. Rather than return 0 in this function, return error codes so it matches
>    the other mm_get_unmapped_area_*() functions.

Commented above.

> 
> 3. Adjust thp_get_unmapped_area_vmflags() to detect the error value from
>    this function and do the fallback logic in this case. There's no need
>    for this 0 stuff (and it's possibly broken actually, since _in theory_
>    you can get unmapped zero).

Please see the discussion in the other thread, where I replied to Jason to
explain why the fallback might not be what the user always want.

For example, the last patch does try 1G first and if it fails somehow it'll
try 2M.  It doesn't want to fallback to 4K when 1G alloc fails.

> 
> 4. (sorry :) move the code to mm/mmap.c

Commented above.  Note: I'm not saying it _can't_ be moved out, but it
still makes sense to me to be in huge_memory.c.

> 
> 5. Obviously address comments from others, most importantly (in my view)
>    ensuring that there is a good kernel doc comment around the function.
> 
> 6. Put the justifiation for exporting the function + stuff about VFIO in
>    the commit message + expand it a little bit as discussed.

Please check if above version works for you.

> 
> 7. Other small stuff raised above (e.g. remove 'THP' comment etc.)

I'll do this.

> 
> Again, sorry to be a pain, but I think we need to be careful to get this
> right so we don't leave any footguns for ourselves in the future with
> 'implicit' stuff.
> 
> Thanks!
> 

Thanks,

-- 
Peter Xu


