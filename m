Return-Path: <kvm+bounces-54270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9552FB1DDB4
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 21:54:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 94095188937E
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 19:54:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43F1D22ACEF;
	Thu,  7 Aug 2025 19:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D5v5tuJ5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0422155A4D
	for <kvm@vger.kernel.org>; Thu,  7 Aug 2025 19:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754596472; cv=none; b=rnOv7+9yJRpIeaAkkwV5YesrneUXKTvoHluZUNPaSC++cYaV8oWzFYZ2fosM1SFKVij09FE4h3PUA19qeqk0/bjEr170nx4R9sLYgvi1fwAlzVD270zzgbq47m0EABsvZy43nuDQSwYFd0qYh9vAjUN3V2b5Td+kJMX9F6v6yLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754596472; c=relaxed/simple;
	bh=RDW1L4heffGGrQZz8MKbIc+mhugsmDh4Lc4XGGof6Fg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bmXD2W0nVLnhaTyqEB4Lz/RIutV8K2CeytV6T4biL3aUAjie1B8ecsLIbtIZidi4fbXg1fluFEyF+oF43yDxp5oabXJFzla1vp5B846GG+TB8Hlt1kjxXcn+10Ru6AvxBAI8c1ThZ2EiH5Qhfr0rPnqPeM+uE9hH8IClzdfL3V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D5v5tuJ5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754596469;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+Rt5Kdvd1zTtx8U/AFDDJ9DpprmGWCIqsQzFa5iz5KU=;
	b=D5v5tuJ5cWsGiDf7U6RAe0Wg93BgRbx1mcFrlVDAZSFB1IBIKojen2qxKYcM0pJTymY3DS
	CJYov6+57B0jlYevGtIZF7UnvogJKCh85IZYvTy5dtB95g1B9ymBE0S+sAdzKg67uxwaeD
	LKj8PB09vYWB71pjCEQbMw5w2/n4LFk=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-211-AP744-F0M3e0O62ZQroxXg-1; Thu, 07 Aug 2025 15:54:24 -0400
X-MC-Unique: AP744-F0M3e0O62ZQroxXg-1
X-Mimecast-MFC-AGG-ID: AP744-F0M3e0O62ZQroxXg_1754596463
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-881789cd9caso26604839f.1
        for <kvm@vger.kernel.org>; Thu, 07 Aug 2025 12:54:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754596463; x=1755201263;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+Rt5Kdvd1zTtx8U/AFDDJ9DpprmGWCIqsQzFa5iz5KU=;
        b=T8dtQgdIV+O5Gn7ixYmtM44cYdzBHNa6MI2RqJwRRvNWaBT4YIYkqfniRJ5HNcgqQd
         Oly18XmkkvaJjAEsvN7epwSSg0CYt4k7oRcjCsQjcC+Pbii/zArzO8qX/Xu/zXpY6rGQ
         D/mrs+siqs33wujzvzG9HjUDf27RGki0oG702Gwkt+w+rcIPz6sHQuBARGS3CSz/cshz
         0YIDwiDtw7Tg9A5JqCyOmjVuMeq/HGEU9DSfaGUl0F16kBWftKb6ODLNtqoUgC/7LfvT
         2nt7RhsLfE6aFBCcIBH2oh7D6mrMzyoyX3kacQi/xgRc9PFiJg+mGid7FEVZjTniYWrS
         yNJA==
X-Forwarded-Encrypted: i=1; AJvYcCWbG7hd3AvtDkzIny8+8T/Rs7DXqJWDp/FtLO6Zjtagpznzt5Xiu7LQ57nE3gOJShZbYPY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxX64e6SM1usw73AOXIf7IpuZ43KwvAcxlDxlLL2SJGucc6kM1o
	OI+oAZxvdhiWFW9mRErsV4zXwcvz/XqCWnpm5TMQXEq93ZVPUe0pyXgxSaOX9uSJr4pXfJ90PuH
	xO8Nx8FchZ+KzgjJmU80Oa6IYGpfsWyAcQYVFc4lR8cGCHbqugt21pQ==
X-Gm-Gg: ASbGncvPCa6OLQeAddLWYEayQSBMyAnYTfeVcAuD2UKC27b5PXO4fEAWYig4cTk9CjA
	pOWaF03vpdYo2pWFNaKmYW3bkToVOzDeyrIfEAPXM+vJ86bpXJHIg73WIC2NEPRHW/LeYnMr0YF
	x7yfDnEd6AwZ+qGbiifuz1rZ+VeGPCQoI3xdG1DXIJncAKlWoI6jT1vh4o9s8F2ZB7BW3xtNP+N
	B4z2oN3IgtPWvDIItLuK2Euy1jctJh7ouiTvYuAZIlkXbspUO65nu00hn/NF2EWCzjw6HQxxzbt
	Nu1IO5S28yqxUG71zWZrx9VOch+Q/t5r4WArl7bPRXU=
X-Received: by 2002:a05:6e02:1d8c:b0:3dc:8bd3:3ce7 with SMTP id e9e14a558f8ab-3e532f0f8eamr2514245ab.0.1754596462919;
        Thu, 07 Aug 2025 12:54:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF6+uOfXqxk9kyoKgMDS4BtEmbqoaKl5b8upfnuVVvS4bcsnaytEnzK8ROpVDssxo2p396ncQ==
X-Received: by 2002:a05:6e02:1d8c:b0:3dc:8bd3:3ce7 with SMTP id e9e14a558f8ab-3e532f0f8eamr2514145ab.0.1754596462495;
        Thu, 07 Aug 2025 12:54:22 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50ae9bd89d7sm6033173.59.2025.08.07.12.54.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Aug 2025 12:54:21 -0700 (PDT)
Date: Thu, 7 Aug 2025 13:54:20 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: lizhe.67@bytedance.com
Cc: david@redhat.com, jgg@nvidia.com, kvm@vger.kernel.org,
 torvalds@linux-foundation.org
Subject: Re: [PATCH] vfio/type1: Absorb num_pages_contiguous()
Message-ID: <20250807135420.0168a781.alex.williamson@redhat.com>
In-Reply-To: <20250807041419.54591-1-lizhe.67@bytedance.com>
References: <f4c464d0-2a98-4c17-8b56-abf86fd15215@redhat.com>
	<20250807041419.54591-1-lizhe.67@bytedance.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  7 Aug 2025 12:14:19 +0800
lizhe.67@bytedance.com wrote:

> On Wed, 6 Aug 2025 14:35:15 +0200, david@redhat.com wrote:
>  
> > On 05.08.25 03:24, Alex Williamson wrote:  
> > > Objections were raised to adding this helper to common code with only a
> > > single user and dubious generalism.  Pull it back into subsystem code.
> > > 
> > > Link: https://lore.kernel.org/all/CAHk-=whhYRMS7Xc9k_JBdrGvp++JLmU0T2xXEgn046hWrj7q8Q@mail.gmail.com/
> > > Cc: David Hildenbrand <david@redhat.com>
> > > Cc: Jason Gunthorpe <jgg@nvidia.com>
> > > Cc: Li Zhe <lizhe.67@bytedance.com>
> > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > ---  
> > 
> > So, I took the original patch and
> > * moved the code to mm_inline.h (sounds like a better fit)
> > * Tweaked the patch description
> > * Tweaked the documentation and turned it into proper kerneldoc
> > * Made the function return "size_t" as well
> > * Use the page_to_section() trick to avoid nth_page().
> > 
> > Only compile-tested so far. Still running it through some cross compiles.
> > 
> > 
> >  From 36d67849bfdbc184990f21464c53585d35648616 Mon Sep 17 00:00:00 2001
> > From: Li Zhe <lizhe.67@bytedance.com>
> > Date: Thu, 10 Jul 2025 16:53:51 +0800
> > Subject: [PATCH] mm: introduce num_pages_contiguous()
> > 
> > Let's add a simple helper for determining the number of contiguous pages
> > that represent contiguous PFNs.
> > 
> > In an ideal world, this helper would be simpler or not even required.
> > Unfortunately, on some configs we still have to maintain (SPARSEMEM
> > without VMEMMAP), the memmap is allocated per memory section, and we might
> > run into weird corner cases of false positives when blindly testing for
> > contiguous pages only.
> > 
> > One example of such false positives would be a memory section-sized hole
> > that does not have a memmap. The surrounding memory sections might get
> > "struct pages" that are contiguous, but the PFNs are actually not.
> > 
> > This helper will, for example, be useful for determining contiguous PFNs
> > in a GUP result, to batch further operations across returned "struct
> > page"s. VFIO will utilize this interface to accelerate the VFIO DMA map
> > process.
> > 
> > Implementation based on Linus' suggestions to avoid new usage of
> > nth_page() where avoidable.
> > 
> > Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
> > Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> > Co-developed-by: David Hildenbrand <david@redhat.com>
> > Signed-off-by: David Hildenbrand <david@redhat.com>
> > ---
> >   include/linux/mm.h        |  7 ++++++-
> >   include/linux/mm_inline.h | 35 +++++++++++++++++++++++++++++++++++
> >   2 files changed, 41 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index fa538feaa8d95..2852bcd792745 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -1759,7 +1759,12 @@ static inline unsigned long page_to_section(const struct page *page)
> >   {
> >   	return (page->flags >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
> >   }
> > -#endif
> > +#else /* !SECTION_IN_PAGE_FLAGS */
> > +static inline unsigned long page_to_section(const struct page *page)
> > +{
> > +	return 0;
> > +}
> > +#endif /* SECTION_IN_PAGE_FLAGS */
> >   
> >   /**
> >    * folio_pfn - Return the Page Frame Number of a folio.
> > diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> > index 89b518ff097e6..58cb99b69f432 100644
> > --- a/include/linux/mm_inline.h
> > +++ b/include/linux/mm_inline.h
> > @@ -616,4 +616,39 @@ static inline bool vma_has_recency(struct vm_area_struct *vma)
> >   	return true;
> >   }
> >   
> > +/**
> > + * num_pages_contiguous() - determine the number of contiguous pages
> > + *                          that represent contiguous PFNs
> > + * @pages: an array of page pointers
> > + * @nr_pages: length of the array, at least 1
> > + *
> > + * Determine the number of contiguous pages that represent contiguous PFNs
> > + * in @pages, starting from the first page.
> > + *
> > + * In kernel configs where contiguous pages might not imply contiguous PFNs
> > + * over memory section boundaries, this function will stop at the memory
> > + * section boundary.
> > + *
> > + * Returns the number of contiguous pages.
> > + */
> > +static inline size_t num_pages_contiguous(struct page **pages, size_t nr_pages)
> > +{
> > +	struct page *cur_page = pages[0];
> > +	unsigned long section = page_to_section(cur_page);
> > +	size_t i;
> > +
> > +	for (i = 1; i < nr_pages; i++) {
> > +		if (++cur_page != pages[i])
> > +			break;
> > +		/*
> > +		 * In unproblematic kernel configs, page_to_section() == 0 and
> > +		 * the whole check will get optimized out.
> > +		 */
> > +		if (page_to_section(cur_page) != section)
> > +			break;
> > +	}
> > +
> > +	return i;
> > +}
> > +
> >   #endif  
> 
> I sincerely appreciate your thoughtful revisions to this patch. The
> code looks great.
> 
> Based on this patch, I reran the performance tests for the VFIO
> optimizations. The results show no significant change from the
> previous data.
> 
> Since num_pages_contiguous() is now defined in mm_inline.h, the
> second patch "vfio/type1: optimize vfio_pin_pages_remote()" in this
> series needs to include that header to resolve the build error.
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 1136d7ac6b59..af98cb94153c 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -37,6 +37,7 @@
>  #include <linux/vfio.h>
>  #include <linux/workqueue.h>
>  #include <linux/notifier.h>
> +#include <linux/mm_inline.h>
>  #include "vfio.h"
>  
>  #define DRIVER_VERSION  "0.2"

Hi Zhe,

Once we're all satisfied with the update, please post a full new
series.  Since we're restarting with fresh commits, please include the
fixes directly in the original patches.  Thanks,

Alex


