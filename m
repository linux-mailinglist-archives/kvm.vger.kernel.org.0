Return-Path: <kvm+bounces-49597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 593B3ADAE14
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 13:14:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F1A3617058D
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 11:14:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3E5029DB96;
	Mon, 16 Jun 2025 11:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="TOqDspmi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D8E2BD5B3
	for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 11:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750072442; cv=none; b=NXCdvNkS+mNDvyiDfDURHd2T3sSH0XlEus7uVstkhYB0TmE2+DD68wOta6FGFjxoL2z+NP1Ze9jTKx1LNLKqbjJwGaIom53Ml6sctvKNUECQ8HWfx9pwPBlQyex1H0OkYu6hivBAZ1RLO+OWP0EhLqnM4nw4BlgNxOcp02nhIFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750072442; c=relaxed/simple;
	bh=bs5ACm5q/B0aNeifc4VzhWlruR9JAZlgVSd9tROUm0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=saC/SCZ71TWss/6Suv8RZzq84iUE8E8Kng8kZEM/qviRSed+xA2qdu87DSm+iXn2Sc5supXIj+WAqn2tfFv2dKZjIj1qx2Ao3ehM/7cz0c5Dx+eSUBotuXv0iDYCO+tKvy54m/Avzd9EXeexJd6A6cuASbrJAVbv5TN2JMvUNJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=TOqDspmi; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-747fc77bb2aso3193979b3a.3
        for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 04:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1750072439; x=1750677239; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=al9UD0RtKUpLDkN/iIvII9ZxHlnlE3IOjRU+2H6u4eo=;
        b=TOqDspmi8bBSINqwzdaBJ5PirvqRIo810X4SMgmYkxtE8mN+QVfHSf6l2/XhiCwyGF
         KTalOGPZ+vVWvoE7OzwP5IMIlMS/gO3kLBCRo73uKdSDZ7BfJjGJq6TaHF6PcVKUfFo/
         DcplrGUYodZwknRCMOCgckuRKpYL6clF/53C282qo/SW2Xq751n0aBOW0p9bZn2q/VDg
         5oSBvZVFR6jPhrPQ/ZxMvm9jvcnH+SRMdNssxOZqf+WPHZQ1SRLw7RET1QEjVuTGQCKB
         chDsQTs4Ss2dINKlSxY6tphGnWfDOLhB1RpsMla80pSAmFnBFPxQquKmjTclXuPFIaEd
         Jldg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750072439; x=1750677239;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=al9UD0RtKUpLDkN/iIvII9ZxHlnlE3IOjRU+2H6u4eo=;
        b=QOd9B1BUflDuJH5K6cszwSrtYbMetFm0QQydLBMWNqjCGXu9ZjosNblK+pQa8wYo2T
         JIDCArN8mKIZu0bmtm09shFSe8S76UOAmPNTFBjrremYNWcG6pO1RXmmYm9hM/pCd50R
         2g+sTfHrs1b795Cz4NdqfC5amxKl/mD0k+60YTCeyJYZ/RuwR14Ainiw/mURAgmn9mMH
         Wuy0zsFuz8lKlx7CgS0HnMH8Ye9M/mFJjLDtROrCiqE7qwXJhFzFCqfKWeVRSV1RvFET
         vuNBiKERw8N6uTFOSBUEx/vL+MNkzMeLNeJWSmaK1LbiOCl8LFbiPqwECoOL1f+y3vnu
         gGsQ==
X-Forwarded-Encrypted: i=1; AJvYcCXV1sAL6W9Enp6bYrZrTl5MqfacTEU3ogYBATUP88E5zDx7+RrU5r3xW1r8mQKmSNs3q74=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0h1mEFCvkMhOddYl39sE+mNCFDfWOQBQlTsc3MWX0Cn54vQr9
	vql+LxhMnwhqAKEn3aiH2Jmmy3ftKeNW571PbLn/rNqdkA2ROzCtWSvNCSP3MrI5dOA=
X-Gm-Gg: ASbGncu4GVwuaTgGq/XAir2UZHcumi1dcK0gMZx8n8xm0KO4KSG39yFbQR5iHKgL3hV
	5McFtXM4XPQEybPFgazBPHh5PxtvDMm9uPc8D1H2bXntazmGoM8mLH8uOZMtJA4woqj4vuKeZg1
	Aw/213tFAiAGvCwDWzPkPHmnebdbyY3jKtWGCRg2wspSltapeUYfdYj8A7lO7o7MM1rx1WPFzl+
	trS+VoD4AAqXvKM5WkI/j8dpXsXp3a9/WJZ6goS6gJlIrQtUjTir6ddAPGtBpt6Qn0M8Kz6muZ8
	rFF7QJOvUM1zOAVQi57sO2moXqrfEGKlAdQ317pz1uyPRGVz/fC9OZSiEkHBunBExIQ+Es8ewFt
	QdZwJrruFhTMJ
X-Google-Smtp-Source: AGHT+IG/XkggEyeF9l/LZIp93+z0ZH94K4b8rZBDM2GqXk2C58rjCGjQSo51RjWqg5FESS9+H8eAYA==
X-Received: by 2002:a05:6a21:6d92:b0:21f:86f1:e2dd with SMTP id adf61e73a8af0-21fbd4dd9cdmr11906649637.11.1750072439228;
        Mon, 16 Jun 2025 04:13:59 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7489000604dsm6464687b3a.46.2025.06.16.04.13.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 16 Jun 2025 04:13:58 -0700 (PDT)
From: lizhe.67@bytedance.com
To: david@redhat.com
Cc: alex.williamson@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lizhe.67@bytedance.com,
	peterx@redhat.com
Subject: Re: [PATCH v3 2/2] vfio/type1: optimize vfio_unpin_pages_remote() for large folio
Date: Mon, 16 Jun 2025 19:13:53 +0800
Message-ID: <20250616111353.7964-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <753caff4-58d6-4d23-ae69-4b909a99aa16@redhat.com>
References: <753caff4-58d6-4d23-ae69-4b909a99aa16@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 16 Jun 2025 10:14:23 +0200, david@redhat.com wrote:

> >   drivers/vfio/vfio_iommu_type1.c | 55 +++++++++++++++++++++++++++------
> >   1 file changed, 46 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > index e952bf8bdfab..09ecc546ece8 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -469,17 +469,28 @@ static bool is_invalid_reserved_pfn(unsigned long pfn)
> >   	return true;
> >   }
> >   
> > -static int put_pfn(unsigned long pfn, int prot)
> > +static inline void _put_pfns(struct page *page, int npages, int prot)
> >   {
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
> >   	}
> >   	return 0;
> >   }
> >   
> > +static inline int put_pfn(unsigned long pfn, int prot)
> > +{
> > +	return put_pfns(pfn, 1, prot);
> > +}
> > +
> >   #define VFIO_BATCH_MAX_CAPACITY (PAGE_SIZE / sizeof(struct page *))
> >   
> >   static void __vfio_batch_init(struct vfio_batch *batch, bool single)
> > @@ -806,11 +817,37 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
> >   				    bool do_accounting)
> >   {
> >   	long unlocked = 0, locked = vpfn_pages(dma, iova, npage);
> > -	long i;
> >   
> > -	for (i = 0; i < npage; i++)
> > -		if (put_pfn(pfn++, dma->prot))
> > -			unlocked++;
> > +	while (npage) {
> > +		long nr_pages = 1;
> > +
> > +		if (!is_invalid_reserved_pfn(pfn)) {
> > +			struct page *page = pfn_to_page(pfn);
> > +			struct folio *folio = page_folio(page);
> > +			long folio_pages_num = folio_nr_pages(folio);
> > +
> > +			/*
> > +			 * For a folio, it represents a physically
> > +			 * contiguous set of bytes, and all of its pages
> > +			 * share the same invalid/reserved state.
> > +			 *
> > +			 * Here, our PFNs are contiguous. Therefore, if we
> > +			 * detect that the current PFN belongs to a large
> > +			 * folio, we can batch the operations for the next
> > +			 * nr_pages PFNs.
> > +			 */
> > +			if (folio_pages_num > 1)
> > +				nr_pages = min_t(long, npage,
> > +					folio_pages_num -
> > +					folio_page_idx(folio, page));
> > +
> > +			_put_pfns(page, nr_pages, dma->prot);
> 
> 
> This is sneaky. You interpret the page pointer a an actual page array, 
> assuming that it would give you the right values when advancing nr_pages 
> in that array.
> 
> This is mostly true, but with !CONFIG_SPARSEMEM_VMEMMAP it is not 
> universally true for very large folios (e.g., in a 1 GiB hugetlb folio 
> when we cross the 128 MiB mark on x86).
> 
> Not sure if that could already trigger here, but it is subtle.

As previously mentioned in the email, the code here functions
correctly.

> > +			unlocked += nr_pages;
> 
> We could do slightly better here, as we already have the folio. We would 
> add a unpin_user_folio_dirty_locked() similar to unpin_user_folio().
> 
> Instead of _put_pfns, we would be calling
> 
> unpin_user_folio_dirty_locked(folio, nr_pages, dma->prot & IOMMU_WRITE);

Thank you so much for your suggestion. Does this implementation of
unpin_user_folio_dirty_locked() look viable to you?

diff --git a/include/linux/mm.h b/include/linux/mm.h
index fdda6b16263b..567c9dae9088 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1689,6 +1689,8 @@ void unpin_user_page_range_dirty_lock(struct page *page, unsigned long npages,
 				      bool make_dirty);
 void unpin_user_pages(struct page **pages, unsigned long npages);
 void unpin_user_folio(struct folio *folio, unsigned long npages);
+void unpin_user_folio_dirty_locked(struct folio *folio,
+		unsigned long npages, bool make_dirty);
 void unpin_folios(struct folio **folios, unsigned long nfolios);
 
 static inline bool is_cow_mapping(vm_flags_t flags)
diff --git a/mm/gup.c b/mm/gup.c
index 84461d384ae2..2f1e14a79463 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -360,11 +360,8 @@ void unpin_user_page_range_dirty_lock(struct page *page, unsigned long npages,
 
 	for (i = 0; i < npages; i += nr) {
 		folio = gup_folio_range_next(page, npages, i, &nr);
-		if (make_dirty && !folio_test_dirty(folio)) {
-			folio_lock(folio);
-			folio_mark_dirty(folio);
-			folio_unlock(folio);
-		}
+		if (make_dirty && !folio_test_dirty(folio))
+			folio_mark_dirty_lock(folio);
 		gup_put_folio(folio, nr, FOLL_PIN);
 	}
 }
@@ -435,6 +432,26 @@ void unpin_user_folio(struct folio *folio, unsigned long npages)
 }
 EXPORT_SYMBOL(unpin_user_folio);
 
+/**
+ * unpin_user_folio_dirty_locked() - release pages of a folio and
+ * optionally dirty
+ *
+ * @folio:  pointer to folio to be released
+ * @npages: number of pages of same folio
+ * @make_dirty: whether to mark the folio dirty
+ *
+ * Mark the folio as being modified if @make_dirty is true. Then
+ * release npages of the folio.
+ */
+void unpin_user_folio_dirty_locked(struct folio *folio,
+		unsigned long npages, bool make_dirty)
+{
+	if (make_dirty && !folio_test_dirty(folio))
+		folio_mark_dirty_lock(folio);
+	gup_put_folio(folio, npages, FOLL_PIN);
+}
+EXPORT_SYMBOL(unpin_user_folio_dirty_locked);
+
 /**
  * unpin_folios() - release an array of gup-pinned folios.
  * @folios:  array of folios to be marked dirty and released.

--

Thanks,
Zhe

