Return-Path: <kvm+bounces-49372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 765A7AD833C
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 08:29:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E96A33B8703
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 06:29:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8B352580E2;
	Fri, 13 Jun 2025 06:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="IlzI+bdj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0CEC256C9E
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 06:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749796180; cv=none; b=rOMn0eIs5O7xG1gUGcnlI1dRXGTPj3JWajnhmA4picCqaGGYB9X4WWSsY0SJPyYAPkgsTi2EM0jFpB2vxbPh3GnsxPDVy6unHseAB1QTXHYA7giI0wSTNSePJoIG7c7rZSKF9P5aQL4T8/Z9VuM8CZxv7RJxOeiD8Tn5+gJka28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749796180; c=relaxed/simple;
	bh=hpBAPh5JrtDcw5DH9vUg4Brgfk2XcfBXqJ816m6FCn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y1EcanzNoRuRIugy+sPW7Mzc2aJ7/KPBbcORyfx7gOeBMe486yFiRuYoxxNM7dKQue89l5bzOR9UMC2/ozZ6oD8Plym//vdp9FYrnn8OQ5LOCUhff2zAWi0A7qCfqhxymrP3aMpY1juqEPWKKRev8WAleyDe9YUIkVdb+LG38Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=IlzI+bdj; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-7fd35b301bdso2052938a12.2
        for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 23:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1749796178; x=1750400978; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u1+QRKcj6rI23A9Rlu3VEpnhYmVrq68wb1ydMH1UcTM=;
        b=IlzI+bdjmJmEka1FXBRjpoPfX4Yotqx8HDUq3SCdgUB+h4ySv8iqsDuPP7XL/DRwnT
         TLRdjLWNM0jxRmlerPETzJxlyBLsyHTe6V+JN2LJH7Q9uEvhHmBoYGCxUM58WOz5XX6E
         Cd98yP9YmkhiBlJ2d4PK2fWsH8PWjca1d29ziP5HrVCTs4U5pQR1NwY0Yp0f+hf0Fqst
         Q7TZrIf8WEyaTyx94auGTPYWA18AknZaQDA7yehBRLcM9dE0TzxowhWvrFBCmzJB4czi
         jIJNuSRfbbf9rm8wXy1QqbmurvESlYdhGrlSQnXUz1Wg5KB76ARzPMFVG6MDl722pXIj
         amtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749796178; x=1750400978;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u1+QRKcj6rI23A9Rlu3VEpnhYmVrq68wb1ydMH1UcTM=;
        b=u/udzzDjLMxAxwF+Ez18ePlU0nhXgJBBkg+JsDwCAAeX2Nexzf3YlcsNdCwBNLhwZq
         PI/UW+adqB43eyg+oXP8sDDAMsJCWZRR4SoWze8LtFjIPOZRNBYIb0jCiwJpYYL29woq
         jeoOlpTL5SiKPWxEnz4xS79qAB8yYnCqKdwe5qVWCPu+Ol6Ighau4/EW3Mibm6yMgtgf
         Q7zBm6ST0kncZ4u9yuMHERfpfgRSL+CWAL/PN1XazOxyIK0vE3dLRNhziUVOazY8oAgi
         Uxz9tWEZTUx+ZXYk+g7eseiaiAQmgkcFe3bUWqB68e4UTdg3mTkyXcms+uiZ3+iJKc45
         60dQ==
X-Forwarded-Encrypted: i=1; AJvYcCWvfeT6FvaTfCVdM+sQmHTpqa85s3BPL8H9v8ZRRLBJzbYwcet2JvNkwrchsgYZml7S868=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKyKE4VDS9VJAiDMM5tVXj/BJOzg1rADGt25fKLWv0J6hfG/sQ
	cMqx2ugCV/l0Al+Db8If7Y63rUm+e0LjvqSb/9WDyAWHZ/sckn2SW8W7nIcEjsb1fOQdFlhaLtw
	XZRrq
X-Gm-Gg: ASbGnctpdUpxucN9smELsul68fLT89Udute+9cvYOFXkP8gRLNkXK/TSyUAJ+LkKGHX
	25lq2yImWAGdCcBrhGi0wDuVk188Fi6iy3oQWnuesSXoIrig8MouBHF4zZDLjXrj7cMLO65v86R
	AQlQCGdxTr+DAKM3Ic+Z4Zx0nk98VjW9462e0cDVKjVZFJyDJu2qR3m78INwCpNR5+WtX8d3baA
	wfOd/u+VwLAXLZ8tbQf/5G9tgcxL28WKQ9phjDO85GyKC/0N6BjePot7g6LPgO3w8KtlsA0wp6j
	VH96xpOkstdUYpakG+zv/Ih0W1ZVcPfly83WwYM4gFYxZKhQFB04mSuH0CLv1RZFe0gC2ZzZ+j+
	/hm48RkBnWJ7uTw==
X-Google-Smtp-Source: AGHT+IH/s0L50AHayUiaVSPNdZ6ImVsS/IPc2tWxkuH28TWza5WeEt/U2UcFAGC7XjyMQcJnM17Dag==
X-Received: by 2002:a17:902:d50b:b0:234:d778:13fa with SMTP id d9443c01a7336-2365da07996mr25220095ad.26.1749796167203;
        Thu, 12 Jun 2025 23:29:27 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.13])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2365d8a1847sm7433425ad.67.2025.06.12.23.29.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Jun 2025 23:29:26 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com
Cc: david@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lizhe.67@bytedance.com,
	peterx@redhat.com
Subject: Re: [RFC v2] vfio/type1: optimize vfio_unpin_pages_remote() for large folio
Date: Fri, 13 Jun 2025 14:29:20 +0800
Message-ID: <20250613062920.68801-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250612163239.5e45afc6.alex.williamson@redhat.com>
References: <20250612163239.5e45afc6.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 12 Jun 2025 16:32:39 -0600, alex.williamson@redhat.com wrote:

> >  drivers/vfio/vfio_iommu_type1.c | 53 +++++++++++++++++++++++++--------
> >  1 file changed, 41 insertions(+), 12 deletions(-)
> > 
> > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > index 28ee4b8d39ae..2f6c0074d7b3 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -469,17 +469,28 @@ static bool is_invalid_reserved_pfn(unsigned long pfn)
> >  	return true;
> >  }
> >  
> > -static int put_pfn(unsigned long pfn, int prot)
> > +static inline void _put_pfns(struct page *page, int npages, int prot)
> >  {
> > -	if (!is_invalid_reserved_pfn(pfn)) {
> > -		struct page *page = pfn_to_page(pfn);
> > +	unpin_user_page_range_dirty_lock(page, npages, prot & IOMMU_WRITE);
> > +}
> >  
> > -		unpin_user_pages_dirty_lock(&page, 1, prot & IOMMU_WRITE);
> > -		return 1;
> > +/*
> > + * The caller must ensure that these npages PFNs belong to the same folio.
> > + */
> > +static inline int put_pfns(unsigned long pfn, int npages, int prot)
> > +{
> > +	if (!is_invalid_reserved_pfn(pfn)) {
> > +		_put_pfns(pfn_to_page(pfn), npages, prot);
> > +		return npages;
> >  	}
> >  	return 0;
> >  }
> >  
> > +static inline int put_pfn(unsigned long pfn, int prot)
> > +{
> > +	return put_pfns(pfn, 1, prot);
> > +}
> > +
> >  #define VFIO_BATCH_MAX_CAPACITY (PAGE_SIZE / sizeof(struct page *))
> >  
> >  static void __vfio_batch_init(struct vfio_batch *batch, bool single)
> > @@ -805,15 +816,33 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
> >  				    unsigned long pfn, unsigned long npage,
> >  				    bool do_accounting)
> >  {
> > -	long unlocked = 0, locked = 0;
> > -	long i;
> > +	long unlocked = 0, locked = vpfn_pages(dma, iova, npage);
> >  
> > -	for (i = 0; i < npage; i++, iova += PAGE_SIZE) {
> > -		if (put_pfn(pfn++, dma->prot)) {
> > -			unlocked++;
> > -			if (vfio_find_vpfn(dma, iova))
> > -				locked++;
> > +	while (npage) {
> > +		struct folio *folio;
> > +		struct page *page;
> > +		long step = 1;
> > +
> > +		if (is_invalid_reserved_pfn(pfn))
> > +			goto next;
> > +
> > +		page = pfn_to_page(pfn);
> > +		folio = page_folio(page);
> > +
> > +		if (!folio_test_large(folio)) {
> > +			_put_pfns(page, 1, dma->prot);
> > +		} else {
> > +			step = min_t(long, npage,
> > +				folio_nr_pages(folio) -
> > +				folio_page_idx(folio, page));
> > +			_put_pfns(page, step, dma->prot);
> >  		}
> > +
> > +		unlocked += step;
> > +next:
> 
> Usage of @step is inconsistent, goto isn't really necessary either, how
> about:
> 
> 	while (npage) {
> 		unsigned long step = 1;
> 
> 		if (!is_invalid_reserved_pfn(pfn)) {
> 			struct page *page = pfn_to_page(pfn);
> 			struct folio *folio = page_folio(page);
> 			long nr_pages = folio_nr_pages(folio);
> 
> 			if (nr_pages > 1)
> 				step = min_t(long, npage,
> 					nr_pages -
> 					folio_page_idx(folio, page));
> 
> 			_put_pfns(page, step, dma->prot);
> 			unlocked += step;
> 		}
> 

That's great. This implementation is much better.

I'm a bit uncertain about the best type to use for the 'step'
variable here. I've been trying to keep things consistent with the
put_pfn() function, so I set the type of the second parameter in
_put_pfns() to 'int'(we pass 'step' as the second argument to
_put_pfns()).

Using unsigned long for 'step' should definitely work here, as the
number of pages in a large folio currently falls within the range
that can be represented by an int. However, there is still a
potential risk of truncation that we need to be mindful of.

> > +		pfn += step;
> > +		iova += PAGE_SIZE * step;
> > +		npage -= step;
> >  	}
> >  
> >  	if (do_accounting)
> 
> AIUI, the idea is that we know we have npage contiguous pfns and we
> currently test invalid/reserved, call pfn_to_page(), call
> unpin_user_pages_dirty_lock(), and test vpfn for each individually.
>
> This instead wants to batch the vpfn accounted pfns using the range
> helper added for the mapping patch,

Yes. We use vpfn_pages() just to track the locked pages.

> infer that continuous pfns have the
> same invalid/reserved state, the pages are sequential, and that we can
> use the end of the folio to mark any inflections in those assumptions
> otherwise.  Do I have that correct?

Yes. I think we're definitely on the same page here.

> I think this could be split into two patches, one simply batching the
> vpfn accounting and the next introducing the folio dependency.  The
> contributions of each to the overall performance improvement would be
> interesting.

I've made an initial attempt, and here are the two patches after
splitting them up.

1. batch-vpfn-accounting-patch:

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 28ee4b8d39ae..c8ddcee5aa68 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -805,16 +805,12 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
 				    unsigned long pfn, unsigned long npage,
 				    bool do_accounting)
 {
-	long unlocked = 0, locked = 0;
+	long unlocked = 0, locked = vpfn_pages(dma, iova, npage);
 	long i;
 
-	for (i = 0; i < npage; i++, iova += PAGE_SIZE) {
-		if (put_pfn(pfn++, dma->prot)) {
+	for (i = 0; i < npage; i++, iova += PAGE_SIZE)
+		if (put_pfn(pfn++, dma->prot))
 			unlocked++;
-			if (vfio_find_vpfn(dma, iova))
-				locked++;
-		}
-	}
 
 	if (do_accounting)
 		vfio_lock_acct(dma, locked - unlocked, true);
-----------------

2. large-folio-optimization-patch:

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index c8ddcee5aa68..48c2ba4ba4eb 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -469,17 +469,28 @@ static bool is_invalid_reserved_pfn(unsigned long pfn)
 	return true;
 }
 
-static int put_pfn(unsigned long pfn, int prot)
+static inline void _put_pfns(struct page *page, int npages, int prot)
 {
-	if (!is_invalid_reserved_pfn(pfn)) {
-		struct page *page = pfn_to_page(pfn);
+	unpin_user_page_range_dirty_lock(page, npages, prot & IOMMU_WRITE);
+}
 
-		unpin_user_pages_dirty_lock(&page, 1, prot & IOMMU_WRITE);
-		return 1;
+/*
+ * The caller must ensure that these npages PFNs belong to the same folio.
+ */
+static inline int put_pfns(unsigned long pfn, int npages, int prot)
+{
+	if (!is_invalid_reserved_pfn(pfn)) {
+		_put_pfns(pfn_to_page(pfn), npages, prot);
+		return npages;
 	}
 	return 0;
 }
 
+static inline int put_pfn(unsigned long pfn, int prot)
+{
+	return put_pfns(pfn, 1, prot);
+}
+
 #define VFIO_BATCH_MAX_CAPACITY (PAGE_SIZE / sizeof(struct page *))
 
 static void __vfio_batch_init(struct vfio_batch *batch, bool single)
@@ -806,11 +817,28 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
 				    bool do_accounting)
 {
 	long unlocked = 0, locked = vpfn_pages(dma, iova, npage);
-	long i;
 
-	for (i = 0; i < npage; i++, iova += PAGE_SIZE)
-		if (put_pfn(pfn++, dma->prot))
-			unlocked++;
+	while (npage) {
+		long step = 1;
+
+		if (!is_invalid_reserved_pfn(pfn)) {
+			struct page *page = pfn_to_page(pfn);
+			struct folio *folio = page_folio(page);
+			long nr_pages = folio_nr_pages(folio);
+
+			if (nr_pages > 1)
+				step = min_t(long, npage,
+					nr_pages -
+					folio_page_idx(folio, page));
+
+			_put_pfns(page, step, dma->prot);
+			unlocked += step;
+		}
+
+		pfn += step;
+		iova += PAGE_SIZE * step;
+		npage -= step;
+	}
 
 	if (do_accounting)
 		vfio_lock_acct(dma, locked - unlocked, true);
-----------------

Here are the results of the performance tests.

Base(v6.15):
./vfio-pci-mem-dma-map 0000:03:00.0 16
------- AVERAGE (MADV_HUGEPAGE) --------
VFIO MAP DMA in 0.048 s (333.5 GB/s)
VFIO UNMAP DMA in 0.139 s (115.1 GB/s)
------- AVERAGE (MAP_POPULATE) --------
VFIO MAP DMA in 0.273 s (58.6 GB/s)
VFIO UNMAP DMA in 0.302 s (52.9 GB/s)
------- AVERAGE (HUGETLBFS) --------
VFIO MAP DMA in 0.052 s (305.3 GB/s)
VFIO UNMAP DMA in 0.141 s (113.8 GB/s)

Base + Map + batch-vpfn-accounting-patch:
------- AVERAGE (MADV_HUGEPAGE) --------
VFIO MAP DMA in 0.027 s (591.1 GB/s)
VFIO UNMAP DMA in 0.138 s (115.7 GB/s)
------- AVERAGE (MAP_POPULATE) --------
VFIO MAP DMA in 0.292 s (54.8 GB/s)
VFIO UNMAP DMA in 0.308 s (52.0 GB/s)
------- AVERAGE (HUGETLBFS) --------
VFIO MAP DMA in 0.032 s (505.5 GB/s)
VFIO UNMAP DMA in 0.140 s (114.1 GB/s)

Base + Map + batch-vpfn-accounting-patch + large-folio-optimization-patch:
------- AVERAGE (MADV_HUGEPAGE) --------
VFIO MAP DMA in 0.027 s (591.2 GB/s)
VFIO UNMAP DMA in 0.049 s (327.6 GB/s)
------- AVERAGE (MAP_POPULATE) --------
VFIO MAP DMA in 0.291 s (55.0 GB/s)
VFIO UNMAP DMA in 0.306 s (52.3 GB/s)
------- AVERAGE (HUGETLBFS) --------
VFIO MAP DMA in 0.032 s (498.3 GB/s)
VFIO UNMAP DMA in 0.049 s (326.2 GB/s)

It seems that batching the vpfn accounting doesn't seem to have much
of an impact in my environment. Perhaps this is because the rbtree
for vfpn is empty, allowing vfio_find_vpfn to execute quickly?

Thanks,
Zhe

