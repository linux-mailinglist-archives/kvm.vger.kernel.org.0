Return-Path: <kvm+bounces-59043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54D58BAA966
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 22:19:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1145D3A839B
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 20:19:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 252142222D1;
	Mon, 29 Sep 2025 20:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UL96x8Af"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D91520FA81
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 20:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759177183; cv=none; b=bi5KK/vjS+wNtTZXXAKxi6DMWQ6BX9UYpa68lPOxMzjM0YEDFcP5mlr6k4HBCh8xplvItZ8vptFGAyu7vR1g8K7LQW5lBbv8bGg5H6IN2/khs34gSgj4YieQM/nJMvAAl22Dr9hoLMmM606J9fMfWhah+5mMn3BohFPWkB29no8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759177183; c=relaxed/simple;
	bh=WAUVufQadGZ6iaCgTRiX1vrVAU1fA6tMX6H0XjrjnnM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cQkMhiNvr7mkvkp8CfPqksnq9RRvCnKZaUt7vrbXD51LoLRbFZEQx3gFHHmKE2HfvB4M5itBroFGDNGCURjQJYCfys3ZE/2oS3/E3M3n9chuy3muBRaNVQyqw7+Ef5cWE2QLJinSc/WxIf8b17twItItYlTN/3Ne2GCnDt9U7dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UL96x8Af; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759177180;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X8ywJFugGxnr1LmswaQ85vv4q8MLDZAIEAlvTcaswu4=;
	b=UL96x8AfanuhtGy3Pw56fEC3MoJBq18kKZ8S0ESBu3FvM3lq5jPSAY+6Wv0cXcwK1nq3dA
	wksClgRhNOcinRKrv9US1w6wHkanAyOgKKBBVJx01uUcRisxf/hjrZqKkz+QKop0x4OUJX
	Rj+TM8xReLtAiR+Sor8rw8YVXBiy6nc=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-216-g1SZ6_-NMmy1JWKwL1jKTQ-1; Mon, 29 Sep 2025 16:19:38 -0400
X-MC-Unique: g1SZ6_-NMmy1JWKwL1jKTQ-1
X-Mimecast-MFC-AGG-ID: g1SZ6_-NMmy1JWKwL1jKTQ_1759177178
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7b30885170eso847302a34.1
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 13:19:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759177178; x=1759781978;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X8ywJFugGxnr1LmswaQ85vv4q8MLDZAIEAlvTcaswu4=;
        b=L0An6WonZDSqkW4jTMulrxtr1Dg41im9tUvzQthl1BzRVNkXz9rncz1bZHXzE8mXXx
         1Rem0t8ZUiiKzwoTP3JfP0BiNSTLoDXzWDiVcZJUAf8Y77Q25LE6UWepg73YDdASG6kH
         RQjX5Wf6BjR2cziIxf1vDoaodaeq6PKyWWsyJMxGgxrpC3iyuAZm1vB6LDvRjSY/PqIy
         I+g2BuvL82lLlwU55up15wiDChaC5ZS9pKl/y/Sxp6v2OSj0AxP0mIXCIlix1jibqZ/T
         TBmNKzURNWVyAQDN/yz1FuT/UbXf37XdszM8bP37xvQVayU6YyP2KjJ0u2m6XwXYkIyg
         6Ong==
X-Forwarded-Encrypted: i=1; AJvYcCUrBL87JrZ9Dm0Q7rCdJ1qz4udxg4JL4pyJPgEcBJPxrnUSZnodtPoUzkpWduB9B0hXT4A=@vger.kernel.org
X-Gm-Message-State: AOJu0YxR922DV+N4CEDrSAbt5N/QywZNTd5fJhWnmPy92KOozFn/FDEn
	Ox7GBwXq3doRfoX+txW2r0hmtJF9xeF7/0VA1fAJxPDAIJv9vmkuqATKxF8A5+18vbPeNhaFFgg
	vrjwZuKeZ+XCOIsyV0FWmYIuCX4E952lrl2ohSlmPdNUWkQgEHcywwA==
X-Gm-Gg: ASbGncuW+L5JE+oWSkRbaVWirOHo/yChdaOOYaFwgn20m67cTGnJ55Tr34/ICngr8IE
	PiD8QMiM4nfz3rE/VayDjbS3YtSPuiVfyh2tNYx4KHKemKaQbnmJ2QR6ml4zruOYLM6RhnumcXp
	pQKggJ8lppk5sj2RFJq+5+qekRL8sdhFLS+vwly5IXovY10rBGqrUVuo60nYmUUwyiBvuL7Rrma
	DfudNDxaw6CgD3vbTiCX4gVz/DqLAqRrYptcIoSQZtsYvVPuIEdq1r/y7zs0SW8xIKD06hQXKmU
	KwJo2rC/jkuVA8VOYfFRV7fNmTw5Z+RxL5oupxpWlRw=
X-Received: by 2002:a05:6830:4492:b0:782:169e:f46f with SMTP id 46e09a7af769-7a02bc53852mr4848801a34.0.1759177178073;
        Mon, 29 Sep 2025 13:19:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGCdfxCEo9JDyJ4uNvftVSj1cdS1vG2p2nUgTKSU7nTCB1I+48ULTqz0ZC9Fep708GzDwXwMA==
X-Received: by 2002:a05:6830:4492:b0:782:169e:f46f with SMTP id 46e09a7af769-7a02bc53852mr4848785a34.0.1759177177587;
        Mon, 29 Sep 2025 13:19:37 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7b5b3b3649esm1213289a34.11.2025.09.29.13.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 13:19:35 -0700 (PDT)
Date: Mon, 29 Sep 2025 14:19:33 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: lizhe.67@bytedance.com
Cc: akpm@linux-foundation.org, david@redhat.com, farman@linux.ibm.com,
 jgg@nvidia.com, jgg@ziepe.ca, kvm@vger.kernel.org, linux-mm@kvack.org,
 torvalds@linux-foundation.org, willy@infradead.org
Subject: Re: [PATCH v5 1/5] mm: introduce num_pages_contiguous()
Message-ID: <20250929141933.2c9c78fc.alex.williamson@redhat.com>
In-Reply-To: <20250929032107.7512-1-lizhe.67@bytedance.com>
References: <20250901032532.67154-1-lizhe.67@bytedance.com>
	<20250929032107.7512-1-lizhe.67@bytedance.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 29 Sep 2025 11:21:07 +0800
lizhe.67@bytedance.com wrote:

> On Mon, 1 Sep 2025 11:25:32 +0800, lizhe.67@bytedance.com wrote:
> 
> > On Wed, 27 Aug 2025 12:10:55 -0600, alex.williamson@redhat.com wrote:
> >   
> > > On Thu, 14 Aug 2025 14:47:10 +0800
> > > lizhe.67@bytedance.com wrote:
> > >   
> > > > From: Li Zhe <lizhe.67@bytedance.com>
> > > > 
> > > > Let's add a simple helper for determining the number of contiguous pages
> > > > that represent contiguous PFNs.
> > > > 
> > > > In an ideal world, this helper would be simpler or not even required.
> > > > Unfortunately, on some configs we still have to maintain (SPARSEMEM
> > > > without VMEMMAP), the memmap is allocated per memory section, and we might
> > > > run into weird corner cases of false positives when blindly testing for
> > > > contiguous pages only.
> > > > 
> > > > One example of such false positives would be a memory section-sized hole
> > > > that does not have a memmap. The surrounding memory sections might get
> > > > "struct pages" that are contiguous, but the PFNs are actually not.
> > > > 
> > > > This helper will, for example, be useful for determining contiguous PFNs
> > > > in a GUP result, to batch further operations across returned "struct
> > > > page"s. VFIO will utilize this interface to accelerate the VFIO DMA map
> > > > process.
> > > > 
> > > > Implementation based on Linus' suggestions to avoid new usage of
> > > > nth_page() where avoidable.
> > > > 
> > > > Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> > > > Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
> > > > Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> > > > Co-developed-by: David Hildenbrand <david@redhat.com>
> > > > Signed-off-by: David Hildenbrand <david@redhat.com>
> > > > ---
> > > >  include/linux/mm.h        |  7 ++++++-
> > > >  include/linux/mm_inline.h | 35 +++++++++++++++++++++++++++++++++++
> > > >  2 files changed, 41 insertions(+), 1 deletion(-)  
> > > 
> > > 
> > > Does this need any re-evaluation after Willy's series?[1]  Patch 2/
> > > changes page_to_section() to memdesc_section() which takes a new
> > > memdesc_flags_t, ie. page->flags.  The conversion appears trivial, but
> > > mm has many subtleties.
> > > 
> > > Ideally we could also avoid merge-time fixups for linux-next and
> > > mainline.  
> > 
> > Thank you for your reminder.
> > 
> > In my view, if Willy's series is integrated, this patch will need to
> > be revised as follows. Please correct me if I'm wrong.
> > 
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index ab4d979f4eec..bad0373099ad 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -1763,7 +1763,12 @@ static inline unsigned long memdesc_section(memdesc_flags_t mdf)
> >  {
> >  	return (mdf.f >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
> >  }
> > -#endif
> > +#else /* !SECTION_IN_PAGE_FLAGS */
> > +static inline unsigned long memdesc_section(memdesc_flags_t mdf)
> > +{
> > +	return 0;
> > +}
> > +#endif /* SECTION_IN_PAGE_FLAGS */
> >  
> >  /**
> >   * folio_pfn - Return the Page Frame Number of a folio.
> > diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> > index 150302b4a905..bb23496d465b 100644
> > --- a/include/linux/mm_inline.h
> > +++ b/include/linux/mm_inline.h
> > @@ -616,4 +616,40 @@ static inline bool vma_has_recency(struct vm_area_struct *vma)
> >  	return true;
> >  }
> >  
> > +/**
> > + * num_pages_contiguous() - determine the number of contiguous pages
> > + *			    that represent contiguous PFNs
> > + * @pages: an array of page pointers
> > + * @nr_pages: length of the array, at least 1
> > + *
> > + * Determine the number of contiguous pages that represent contiguous PFNs
> > + * in @pages, starting from the first page.
> > + *
> > + * In some kernel configs contiguous PFNs will not have contiguous struct
> > + * pages. In these configurations num_pages_contiguous() will return a num
> > + * smaller than ideal number. The caller should continue to check for pfn
> > + * contiguity after each call to num_pages_contiguous().
> > + *
> > + * Returns the number of contiguous pages.
> > + */
> > +static inline size_t num_pages_contiguous(struct page **pages, size_t nr_pages)
> > +{
> > +	struct page *cur_page = pages[0];
> > +	unsigned long section = memdesc_section(cur_page->flags);
> > +	size_t i;
> > +
> > +	for (i = 1; i < nr_pages; i++) {
> > +		if (++cur_page != pages[i])
> > +			break;
> > +		/*
> > +		 * In unproblematic kernel configs, page_to_section() == 0 and
> > +		 * the whole check will get optimized out.
> > +		 */
> > +		if (memdesc_section(cur_page->flags) != section)
> > +			break;
> > +	}
> > +
> > +	return i;
> > +}
> > +
> >  #endif  
> 
> Hi Alex,
> 
> I noticed that Willy's series has been merged into the mm-stable
> branch. Could you please let me know if this vfio optimization
> series is also ready to be merged?

I was hoping for a shared branch here, it doesn't seem like a good idea
to merge mm-stable into my next branch.  My current plan is to send a
pull request without this series.  If there are no objections we
could try for a second pull request once mm-stable is merged that would
include just this series.  Otherwise it would need to wait one more
cycle, which I know would be frustrating for something we tried to
include in the previous merge window.  Thanks,

Alex


