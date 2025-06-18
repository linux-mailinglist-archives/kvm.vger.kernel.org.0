Return-Path: <kvm+bounces-49822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F996ADE473
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 09:22:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BEB1E1671DC
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 07:22:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6336B27E7F9;
	Wed, 18 Jun 2025 07:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="Zh+qr4gD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09CDEACD
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 07:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750231342; cv=none; b=tUUgDpGZQ0nVdF6JkPQzKVBHN/2/m9YE9B7nVfDTZ5E9KQ7/IW01+O4CrslMMbFkKn+pd7iuzrqkewWD5t0tP6bkyg4npUmbj/iz6H2uFKsSAoQb8OD9Twql6BQwJdS92plBmxFtrdNqFLnielebTtpwKyDtT2ZGPw6tjtE/AIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750231342; c=relaxed/simple;
	bh=FlYIp1GSWXgA47DrwMIkay6HroV1XLb7hc3gExSwoE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fSGzaraGPnLSGvhQIFZaHNDPX6dRISpbPJPVkspWJO8XcxESeAia03KBsPd/xoKqk7RNh85dXytjSkuYdlFexK9vvuxtvAWXigfO/1dh+CQ20tYbe/HxODNcIACR/++LfL52eNRTa5/4+k2EYpF5dAL14o7zpVhPt0rOXpAAHcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=Zh+qr4gD; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-af51596da56so5944503a12.0
        for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 00:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1750231338; x=1750836138; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g90eoEwOIpMaTkn+dJ7Xpv9ylWdjlRNbMVrS8tF+CzE=;
        b=Zh+qr4gDieiiDIq+0sFz5aljgNoxhu28li3qFs8ishAvrRVrzZmM7f/ebQlsHhvKe7
         f1CEtJkOHnPqn0rAo6uc3Owqar2bIBBaWQb/IjKfN7W0YzuvIxGFp8JaP25g2e2kyziE
         vzA4AkKjFFuKarY0aTbxjkcbmqNM/B7qEhxKAmzsTkJazARznFZhqObcObN6W4DvRwyC
         jRfOZHavXYB5k3Jqeyumc4bqho+nk8t41Ynh5olFHzZTXmrbPeoi5UwxP5wpggHCZgyo
         kj7TGsE3zXOy/cIxolHYug8FvhpurEvBgczf5V3gXh/ZQKJG5VzzdCi9WeWo80jkDDSI
         bZCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750231338; x=1750836138;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g90eoEwOIpMaTkn+dJ7Xpv9ylWdjlRNbMVrS8tF+CzE=;
        b=Iz3ThNkywUmsI/tqRyosPqAvUxARCyKisIvMK/cXWD732e3bcDFn68ylh8lxza2TQw
         ILHu2B3SjOhLj+By/CuSMi9RBwwAu9SDLXE8fxSZBDJN2WRM656bdQ+8t35xvRfBjdWg
         UeM+sBnyew/URdDQ9rmzxjnR0Hxc3iwVKbgQozK6VWv9awlKdVq4dOqxuG2doZCLLpDG
         KLlR2WTs3lwEKrK+1Cg2FqxyX7QGJFm98YhMfqCgeQK2cChs7Yq98uVIC4RpyEV/e97j
         4peRm9ddpRrUXcDX6u+dohopKYbSADlSiwtUYFJ5c2nJDXdmdsDaaWD9nQ4XrucF1fk9
         1qvw==
X-Forwarded-Encrypted: i=1; AJvYcCUHjYvE5zfYkbRd2QmrvA47PrtpdgE4Sv4GrgayRQZ7s2uQ9IpvRHTrGBh0qe8+DpYMbyk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzzrOTSUE1PoZo9z7/xEPNiojrT25A4Vs8xmHwhxYT88i7AFyZx
	+0uymbD4k/Ev5zugPAbylw09bCUAp6C5Qrxlv2kfVsoyDQN6GVt3m3NGiOTFjFOCi6g=
X-Gm-Gg: ASbGnctuX6qeCUiZmnrCyLjYLfY2apYXnd3233x3d38lAePHt4srjNRzRsMy5VruG/Y
	7tRc6o0BYhKXTuc5q7hFh1gXmxApaGzvxd6VRwkXhhhqOHm0FXv5JMV0PZKigLjPZl/1F6KO48k
	m2aq6js69z8lw+ac/zekhOad58kQdK3NgGJ/tsJE8M1lKH+H/tVaF1HhiFtK6LThOpm8YmVTH3O
	vBk2Vtq5c0X5DqEka6CkVwhZ5RiL4q7+60CJcKbQkeucrYc4til1iQQl2Qzk3UwUrGJN9p2zC9H
	qtg5dDWnSX5RFbnQUkiiqxt03Ak49961IjhfPPOmHDPnwRPsk5qjkDU41s23WEUW67eE/i5vv7C
	8A5h4QEn9xm56gA==
X-Google-Smtp-Source: AGHT+IEIlF9MTo6BXhNVepXYf6WgSUfQhwoHcEgxpRuHCE9CuMWp3AFMHSQtgSDSihKLhGjH6gjAVQ==
X-Received: by 2002:a17:90b:350c:b0:312:f0d0:bb0 with SMTP id 98e67ed59e1d1-313f1ca0fbfmr30726786a91.12.1750231338007;
        Wed, 18 Jun 2025 00:22:18 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.12])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2365dfc6990sm92909995ad.224.2025.06.18.00.22.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 18 Jun 2025 00:22:17 -0700 (PDT)
From: lizhe.67@bytedance.com
To: david@redhat.com
Cc: akpm@linux-foundation.org,
	alex.williamson@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	peterx@redhat.com,
	lizhe.67@bytedance.com
Subject: Re: [PATCH v4 3/3] vfio/type1: optimize vfio_unpin_pages_remote() for large folio
Date: Wed, 18 Jun 2025 15:22:11 +0800
Message-ID: <20250618072211.12867-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250618061143.6470-1-lizhe.67@bytedance.com>
References: <20250618061143.6470-1-lizhe.67@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 18 Jun 2025 14:11:43 +0800, lizhe.67@bytedance.com wrote:
 
> > > How do you think of this implementation?
> > > 
> > > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > > index 242b05671502..eb91f99ea973 100644
> > > --- a/include/linux/mm.h
> > > +++ b/include/linux/mm.h
> > > @@ -2165,6 +2165,23 @@ static inline long folio_nr_pages(const struct folio *folio)
> > >          return folio_large_nr_pages(folio);
> > >   }
> > >   
> > > +/*
> > > + * folio_remaining_pages - Counts the number of pages from a given
> > > + * start page to the end of the folio.
> > > + *
> > > + * @folio: Pointer to folio
> > > + * @start_page: The starting page from which to begin counting.
> > > + *
> > > + * Returned number includes the provided start page.
> > > + *
> > > + * The caller must ensure that @start_page belongs to @folio.
> > > + */
> > > +static inline unsigned long folio_remaining_pages(struct folio *folio,
> > > +               struct page *start_page)
> > > +{
> > > +       return folio_nr_pages(folio) - folio_page_idx(folio, start_page);
> > > +}
> > > +
> > >   /* Only hugetlbfs can allocate folios larger than MAX_ORDER */
> > >   #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
> > >   #define MAX_FOLIO_NR_PAGES     (1UL << PUD_ORDER)
> > > diff --git a/mm/gup.c b/mm/gup.c
> > > index 15debead5f5b..14ae2e3088b4 100644
> > > --- a/mm/gup.c
> > > +++ b/mm/gup.c
> > > @@ -242,7 +242,7 @@ static inline struct folio *gup_folio_range_next(struct page *start,
> > >   
> > >          if (folio_test_large(folio))
> > >                  nr = min_t(unsigned int, npages - i,
> > > -                          folio_nr_pages(folio) - folio_page_idx(folio, next));
> > > +                          folio_remaining_pages(folio, next));
> > >   
> > >          *ntails = nr;
> > >          return folio;
> > > diff --git a/mm/page_isolation.c b/mm/page_isolation.c
> > > index b2fc5266e3d2..34e85258060c 100644
> > > --- a/mm/page_isolation.c
> > > +++ b/mm/page_isolation.c
> > > @@ -96,7 +96,7 @@ static struct page *has_unmovable_pages(unsigned long start_pfn, unsigned long e
> > >                                  return page;
> > >                          }
> > >   
> > > -                       skip_pages = folio_nr_pages(folio) - folio_page_idx(folio, page);
> > > +                       skip_pages = folio_remaining_pages(folio, page);
> > >                          pfn += skip_pages - 1;
> > >                          continue;
> > >                  }
> > > ---
> > 
> > Guess I would have pulled the "min" in there, but passing something like 
> > ULONG_MAX for the page_isolation case also looks rather ugly.
> 
> Yes, the page_isolation case does not require the 'min' logic. Since
> there are already places in the current kernel code where
> folio_remaining_pages() is used without needing min, we could simply
> create a custom wrapper function based on folio_remaining_pages() only
> in those specific scenarios where min is necessary.
> 
> Following this line of thinking, the wrapper function in vfio would
> look something like this.
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -801,16 +801,40 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
>         return pinned;
>  }
>  
> +static inline unsigned long vfio_folio_remaining_pages(
> +               struct folio *folio, struct page *start_page,
> +               unsigned long max_pages)
> +{
> +       if (!folio_test_large(folio))
> +               return 1;

The above two lines may no longer be necessary.

> +       return min(max_pages,
> +                  folio_remaining_pages(folio, start_page));
> +}

Thanks,
Zhe

