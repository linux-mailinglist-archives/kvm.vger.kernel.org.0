Return-Path: <kvm+bounces-49833-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 19FF0ADE745
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 11:41:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 25BAF3A461D
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 09:38:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6167283C91;
	Wed, 18 Jun 2025 09:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="cvfK7hgB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73BBD281365
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 09:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750239555; cv=none; b=sZ6uv5FLtUE9YsgBQg8BQOsCclfLZrOmlXmOBKhSEE2zkGgvG2ZfJ+fmBCyjEv+GORp4n155GcAfoahqsDO5ydcXOC4Xnnj0h0ZqMXtODZjy5ybJKcMgB+p/RiUiQ7ryCHvngfuI9ji5n1gOyR8nYroBuasi61CmDCXQI0/EX8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750239555; c=relaxed/simple;
	bh=YUggoR187y24+mpnfBDPskA4yZEGsh0T2wbx9RjKmmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OfqAPt78cbBjSTN3m8rs2M7hybBCZPhG4Rx0n2z/Xm8tyAS0CRpOKq8tjlWE533QN8ant3kQ+8XcsuwBTMV4ZF19TEoHuAciRBnAU5rZ3qU9VffuQM1g7nuGPmEZ8x2jvIRE9uUgtZuiBfM1Wqdr4cKmfE9+n79jfzPsIBZJyRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=cvfK7hgB; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7406c6dd2b1so476755b3a.0
        for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 02:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1750239553; x=1750844353; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gXRO5EKnkAxok5EOtq3Fx6436ytc5fPcTfeu9ljY/iM=;
        b=cvfK7hgBOSau+R9Q9b85VjECCLEAxjv0o84W3sxgNyOwOFYjCqYxWhWaRkHsP5G/xV
         3TmJn0c1OP5LDq5sKfS7cO68O1/xn6CkesYKfetJVFhLm1gIMdcwxsn5Wk3JQOjUmuZX
         HTTZ9Bg9tCOlDVFcKGVjEvbu9p8/7++gxaQ6PevEpFlB/ZRrWanlyd3zCgmniUWCBXkI
         kXzIfCHdtN6ujDLRQRk1uLBouHrMwAlnAO8l+/WHmEljnnqBzNJeyTnA9OWXnXUJz4E1
         j+he2CPohMoxVDDwN9jHes6yf4L/99woXZj54W4Tnygok6nTezGXRvFoXzV4GOQAsP6w
         Letg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750239553; x=1750844353;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gXRO5EKnkAxok5EOtq3Fx6436ytc5fPcTfeu9ljY/iM=;
        b=KM3poClCziG1ClNx/ZM2Klg+RB25XY4sNf43AFoZ37pfpccaw2bL9Vldyzjps8IfHM
         Rgv4Qb3/pju9LqymC0F8ZhaOD5QHkjWxegu9Gu2T3bnTQC1hhY0AY1mnNTyLAhFRxZQe
         tCosxp73vfU2eWdyDRAW9eUY/01ChLpxTYsebDG1gs/+JkI/LMWotgn04N+1JAynDlmm
         NfCwgUG/cUcdaXEgvWBOx6vLTIPkDhjP97wNgj6WKNR0X0vDscjANxd2HeZ1hBG9rWAu
         UT69F5uSjz92J++H7rnUo16Mg8H5NRgoaU9uvd+LGRny/8Vja///cSwI4yXvLDvXytI6
         rFgw==
X-Forwarded-Encrypted: i=1; AJvYcCVwbJC3RQO3+49k7MqErnWtsF+7HQmCNiEGOAwkn6Ye6yEbdFNz5f74Ethg+An56wbGrAg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwAEErnf9fZOS9u8bY9Wq88zNSQ6jwEsbV9nXhh8HjcZTXkAJMc
	VTaPK4k9aJvgunISOzCKGbawqBXDHChyCJ14Iu0a4lmol1sopUHSarNSCR5LPyV9DhU=
X-Gm-Gg: ASbGncvqvH4VhNkyHKSNYAIGAnfeUD7qQB0uxl5GB+OAy5As1j9pf58leiK8rI5Cjx+
	C/X8LSNPjNV0O6LreCWw6OupanfdGxp6Df3MY3MBLdnEQS7Mh8gs5w0eDO82Za3LtdwrZXJRxLi
	VZIrVWkUb4/PowyvMbSd6kOavGeKls38+vDi7oZCaLaKXSdv4WPKaOQDuNzAp2VW0KENX/ubisg
	0p8sD8XXOdmAIqH+pG5yYUC5eAsc24boEBfkIR+UwDPB1DNwg7sCzRivMt6cg14Or1SS1Yvk3hT
	S24EwH5ZxKO86VyimaJ3nx9dIDCvQU+HNQ6FWdKPZtEYuzp0CsGsXd5mzwgHdTMX1KcLIJvVJLG
	nL77qsZlluFQcgA==
X-Google-Smtp-Source: AGHT+IFCFuw1k7cB6Zq/g8s1AUp4inslPIr/YJO1ohnxm7OL2XrQfxvmgjd2EoXEb/NYEjL5Le3l1Q==
X-Received: by 2002:a05:6a00:1251:b0:73d:fdd9:a55 with SMTP id d2e1a72fcca58-748e6ffabcamr2801322b3a.8.1750239552619;
        Wed, 18 Jun 2025 02:39:12 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.11])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-748900b04e4sm10496615b3a.121.2025.06.18.02.39.09
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 18 Jun 2025 02:39:12 -0700 (PDT)
From: lizhe.67@bytedance.com
To: david@redhat.com
Cc: akpm@linux-foundation.org,
	alex.williamson@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lizhe.67@bytedance.com,
	peterx@redhat.com
Subject: Re: [PATCH v4 3/3] vfio/type1: optimize vfio_unpin_pages_remote() for large folio
Date: Wed, 18 Jun 2025 17:39:06 +0800
Message-ID: <20250618093906.23048-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <58f9d004-918d-4f66-85e7-d090db0af5de@redhat.com>
References: <58f9d004-918d-4f66-85e7-d090db0af5de@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 18 Jun 2025 10:54:38 +0200, david@redhat.com wrote:
 
> On 18.06.25 08:11, lizhe.67@bytedance.com wrote:
> > On Tue, 17 Jun 2025 15:47:09 +0200, david@redhat.com wrote:
> >   
> >>> How do you think of this implementation?
> >>>
> >>> diff --git a/include/linux/mm.h b/include/linux/mm.h
> >>> index 242b05671502..eb91f99ea973 100644
> >>> --- a/include/linux/mm.h
> >>> +++ b/include/linux/mm.h
> >>> @@ -2165,6 +2165,23 @@ static inline long folio_nr_pages(const struct folio *folio)
> >>>           return folio_large_nr_pages(folio);
> >>>    }
> >>>    
> >>> +/*
> >>> + * folio_remaining_pages - Counts the number of pages from a given
> >>> + * start page to the end of the folio.
> >>> + *
> >>> + * @folio: Pointer to folio
> >>> + * @start_page: The starting page from which to begin counting.
> >>> + *
> >>> + * Returned number includes the provided start page.
> >>> + *
> >>> + * The caller must ensure that @start_page belongs to @folio.
> >>> + */
> >>> +static inline unsigned long folio_remaining_pages(struct folio *folio,
> >>> +               struct page *start_page)
> >>> +{
> >>> +       return folio_nr_pages(folio) - folio_page_idx(folio, start_page);
> >>> +}
> >>> +
> >>>    /* Only hugetlbfs can allocate folios larger than MAX_ORDER */
> >>>    #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
> >>>    #define MAX_FOLIO_NR_PAGES     (1UL << PUD_ORDER)
> >>> diff --git a/mm/gup.c b/mm/gup.c
> >>> index 15debead5f5b..14ae2e3088b4 100644
> >>> --- a/mm/gup.c
> >>> +++ b/mm/gup.c
> >>> @@ -242,7 +242,7 @@ static inline struct folio *gup_folio_range_next(struct page *start,
> >>>    
> >>>           if (folio_test_large(folio))
> >>>                   nr = min_t(unsigned int, npages - i,
> >>> -                          folio_nr_pages(folio) - folio_page_idx(folio, next));
> >>> +                          folio_remaining_pages(folio, next));
> >>>    
> >>>           *ntails = nr;
> >>>           return folio;
> >>> diff --git a/mm/page_isolation.c b/mm/page_isolation.c
> >>> index b2fc5266e3d2..34e85258060c 100644
> >>> --- a/mm/page_isolation.c
> >>> +++ b/mm/page_isolation.c
> >>> @@ -96,7 +96,7 @@ static struct page *has_unmovable_pages(unsigned long start_pfn, unsigned long e
> >>>                                   return page;
> >>>                           }
> >>>    
> >>> -                       skip_pages = folio_nr_pages(folio) - folio_page_idx(folio, page);
> >>> +                       skip_pages = folio_remaining_pages(folio, page);
> >>>                           pfn += skip_pages - 1;
> >>>                           continue;
> >>>                   }
> >>> ---
> >>
> >> Guess I would have pulled the "min" in there, but passing something like
> >> ULONG_MAX for the page_isolation case also looks rather ugly.
> > 
> > Yes, the page_isolation case does not require the 'min' logic. Since
> > there are already places in the current kernel code where
> > folio_remaining_pages() is used without needing min, we could simply
> > create a custom wrapper function based on folio_remaining_pages() only
> > in those specific scenarios where min is necessary.
> 
> I would just do something like that, removing gup_folio_range_next() completely.
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 98a606908307b..6c224b1c6c169 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1995,6 +1995,32 @@ static inline long folio_nr_pages(const struct folio *folio)
>   	return folio_large_nr_pages(folio);
>   }
>   
> +/**
> + * folio_remaining_pages - The remaining number of pages in the folio.
> + * @folio: The folio.
> + * @page: The folio page to start the counting.
> + * @max_npages: Limit how far to count.
> + *
> + * The returned number will include the provided page.
> + *
> + * The caller must ensure that @page belongs to @folio. When setting
> + * @max_npages to ULONG_MAX, the parameter is effectively ignored.
> + *
> + * Return: The remaining number of pages, limited by @max_npages.
> + */
> +static inline unsigned long folio_remaining_pages(struct folio *folio,
> +		struct page *page, unsigned long max_npages)
> +{
> +	unsigned long nr;
> +
> +	if (!folio_test_large(folio))
> +		return 1;
> +	nr = folio_large_nr_pages(folio) - folio_page_idx(folio, page);
> +	if (__builtin_constant_p(max_npages) && max_npages == ULONG_MAX)
> +		return nr;
> +	return min_t(unsigned long, nr, max_npages);
> +}
> +
>   /* Only hugetlbfs can allocate folios larger than MAX_ORDER */
>   #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
>   #define MAX_FOLIO_NR_PAGES	(1UL << PUD_ORDER)
> diff --git a/mm/gup.c b/mm/gup.c
> index 6888e871a74a9..3385428d028f6 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -234,21 +234,6 @@ void folio_add_pin(struct folio *folio)
>   	}
>   }
>   
> -static inline struct folio *gup_folio_range_next(struct page *start,
> -		unsigned long npages, unsigned long i, unsigned int *ntails)
> -{
> -	struct page *next = nth_page(start, i);
> -	struct folio *folio = page_folio(next);
> -	unsigned int nr = 1;
> -
> -	if (folio_test_large(folio))
> -		nr = min_t(unsigned int, npages - i,
> -			   folio_nr_pages(folio) - folio_page_idx(folio, next));
> -
> -	*ntails = nr;
> -	return folio;
> -}
> -
>   static inline struct folio *gup_folio_next(struct page **list,
>   		unsigned long npages, unsigned long i, unsigned int *ntails)
>   {
> @@ -356,11 +341,13 @@ void unpin_user_page_range_dirty_lock(struct page *page, unsigned long npages,
>   				      bool make_dirty)
>   {
>   	unsigned long i;
> -	struct folio *folio;
>   	unsigned int nr;
>   
>   	for (i = 0; i < npages; i += nr) {
> -		folio = gup_folio_range_next(page, npages, i, &nr);
> +		struct page *next = nth_page(page, i);
> +		struct folio *folio = page_folio(next);
> +
> +		nr = folio_remaining_pages(folio, next, npages - i);
>   		if (make_dirty && !folio_test_dirty(folio)) {
>   			folio_lock(folio);
>   			folio_mark_dirty(folio);
> diff --git a/mm/page_isolation.c b/mm/page_isolation.c
> index ece3bfc56bcd5..6f75defb38d73 100644
> --- a/mm/page_isolation.c
> +++ b/mm/page_isolation.c
> @@ -96,7 +96,7 @@ static struct page *has_unmovable_pages(unsigned long start_pfn, unsigned long e
>   				return page;
>   			}
>   
> -			skip_pages = folio_nr_pages(folio) - folio_page_idx(folio, page);
> +			skip_pages = folio_remaining_pages(folio, page, ULONG_MAX);
>   			pfn += skip_pages - 1;
>   			continue;
>   		}
> -- 
> 
> 
> But up to you, anything with such a helper function makes the code easier to digest.

Thank you. This implementation looks better. Please allow me to
integrate this patch into my patchset.

Thanks,
Zhe

