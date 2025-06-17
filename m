Return-Path: <kvm+bounces-49689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C6FD2ADC61F
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 11:21:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0243218993BB
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 09:22:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02ACD293C7A;
	Tue, 17 Jun 2025 09:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="aVdt8hme"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29404293C5E
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 09:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750152087; cv=none; b=txPFnEt6O7Cw/IJ18QJWe8S9LVbIjabiN1C3e1lfmLh3Xu1FxZOIaao5fcNKercyV9NMK/DPNWOJhQ5NF0ZU01v/BoXx+IdvA/1AjEZLrDagd5mvh9glu3SxL9Y3aqflk7cpFBMiPhsh5ai6g0v6HpvGl1ZcvPic7RdH07i7zI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750152087; c=relaxed/simple;
	bh=Ow3AGhVqlqjnFCJ1JQEH8ceZfT2t+7tTzq/V/n123cs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AbXCFxTsIaIue8YPXRFUkSOkK39mqJ9axEW96hIC7rmhOAtrM0+vnajOfU9GsrezHFqw/LfxOYgp7NsJjDX6LxQb+ILIKNrqJ7VCefLQEtHp/Brt6dI8/ZR+XWixXN8+FT61LJNYS3MUxOUIEX3WR7BMW/XKrb60EEZEuqHBS2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=aVdt8hme; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-313b6625cf1so4111127a91.0
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 02:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1750152084; x=1750756884; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tQhHDdXRASPFShTEMtGhN37rSYP2mIQBC7ckn6Zfygs=;
        b=aVdt8hmecBkj7Y8zeeB8Svdb1CvkJgAF38Fw4OTwoAYojYi6wa7h4zNcGdOyZLHJem
         qvDFzLQI/uGX28zSCatiahp+mW0U2gk9cKAjFTyhhXWd6czaWsmlxfIqrO1gDlXSh1DU
         /4SN/ujhlVA+560kv9/Sx2O8Np5T46j+quzEzKndpwauQDrCuVfHAOdHkkvTLetTzqDv
         qZvGRL3DO+++u/eSRDFalcCoHCrdC81phkUHb9inDB2GJLflLu+Wv2gGkXGKCN1HDcXE
         GSWyw7lupVkmEWdmCKANCLQz6JEOElIFrXOh2sBhs0ufa35vW4tTb3BeYLl6vzqecS3M
         pd7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750152084; x=1750756884;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tQhHDdXRASPFShTEMtGhN37rSYP2mIQBC7ckn6Zfygs=;
        b=Z2qv1CFLQe1hZUxXxS8XnDdMNBx0wuiKz/ik6+o8rLTHYn940Xw7n2mg5uQwz602fo
         8g+Y2cXGvqa1jQVEr7nDALeGHI5509Q7635GKn+1hun6kue6szbNz3uQ2msHyoR4/gZV
         8iCQX7Ba6Lg3EAJvxsQ4Hgm5EnimQnkdvOYhsTZ27ELFhPt+FXjQraNbVr3TNRJbBWNz
         zSwZyWnA+CjpFuRKSs4fXXUl2nxXk/T2IfHgbqnnXpUo5dMzPnNj4fkk6kHE90pdGB0G
         fO5NnJkBTWu/JjL1dbqG8N3DYRyWVCQx+R3K9N5l8obgqEY9cChA2GmaNEjk+pEwEAoV
         pgpQ==
X-Forwarded-Encrypted: i=1; AJvYcCWCrCpyepZOae44QuN8TDv8wqPphp28pkArmOis6o76s+SncRiqRX8aH/sHcFhg5xsk2nM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwigCm/RrR8NRXHR3gvEpb9Jm6nIl1PoiHjNnRLt2LWzDW+GwQ1
	xggU+sVmaxZx+HoUmOmYjIf5MR1/H27FvAbyT/4FF1v4W0avDTPs5MpqfZziYwZtJbg=
X-Gm-Gg: ASbGncv+4ftmxpQkwakFwvB1gWQyNZQBgO8P/uLY0gfO2xXTJAfXWNGcrzkMnHXtcAV
	58LseZDlyg4Cw2lfnvRP9Mv4gm50qXeR4AtPTPvQjmyyUR7jY/gTMvGB9p/uHRZht9HvdnGbMD8
	7orZYuyZuY7iaLBj3C7NlvP+/zzdTgeWt4jkU+Q+vpaUfxLfwenI/+5gl34Sxw6NViOChHOAUbm
	kxBaHgta16vfHRR5K4gv6ql03/pGJMiOxOTOM/Iiq2UMfQJzv7EE5QPNYsP/zFpAcgNl9B30xdL
	LeIj8PQ7gvc9KkpXA+ESBeJ3k9/duLj1vI0POIGCS05TwuJ0dvb1oUoZnTsZWsJhosDREIYkr2V
	9XQquhm4oCAjiMA==
X-Google-Smtp-Source: AGHT+IH4Lc/yHe2dEENhF5nwP1sRWFMN4XZjeIToef7j+ESUprmceHkDq6MxthbKbJpXxCtADv1M3g==
X-Received: by 2002:a17:90b:180b:b0:311:1617:5bc4 with SMTP id 98e67ed59e1d1-31427e9f120mr2815486a91.12.1750152084194;
        Tue, 17 Jun 2025 02:21:24 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.14])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2365d88e554sm75458145ad.16.2025.06.17.02.21.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 17 Jun 2025 02:21:23 -0700 (PDT)
From: lizhe.67@bytedance.com
To: david@redhat.com
Cc: akpm@linux-foundation.org,
	alex.williamson@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lizhe.67@bytedance.com,
	peterx@redhat.com
Subject: Re: [PATCH v4 2/3] gup: introduce unpin_user_folio_dirty_locked()
Date: Tue, 17 Jun 2025 17:21:17 +0800
Message-ID: <20250617092117.10772-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <34560ae6-c598-4474-a094-a657c973156b@redhat.com>
References: <34560ae6-c598-4474-a094-a657c973156b@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 17 Jun 2025 09:43:56 +0200, david@redhat.com wrote:
 
> On 17.06.25 06:18, lizhe.67@bytedance.com wrote:
> > From: Li Zhe <lizhe.67@bytedance.com>
> > 
> > When vfio_unpin_pages_remote() is called with a range of addresses that
> > includes large folios, the function currently performs individual
> > put_pfn() operations for each page. This can lead to significant
> > performance overheads, especially when dealing with large ranges of pages.
> > 
> > This patch optimize this process by batching the put_pfn() operations.
> > 
> > The performance test results, based on v6.15, for completing the 16G VFIO
> > IOMMU DMA unmapping, obtained through unit test[1] with slight
> > modifications[2], are as follows.
> > 
> > Base(v6.15):
> > ./vfio-pci-mem-dma-map 0000:03:00.0 16
> > ------- AVERAGE (MADV_HUGEPAGE) --------
> > VFIO MAP DMA in 0.047 s (338.6 GB/s)
> > VFIO UNMAP DMA in 0.138 s (116.2 GB/s)
> > ------- AVERAGE (MAP_POPULATE) --------
> > VFIO MAP DMA in 0.280 s (57.2 GB/s)
> > VFIO UNMAP DMA in 0.312 s (51.3 GB/s)
> > ------- AVERAGE (HUGETLBFS) --------
> > VFIO MAP DMA in 0.052 s (308.3 GB/s)
> > VFIO UNMAP DMA in 0.139 s (115.1 GB/s)
> > 
> > Map[3] + This patchset:
> > ------- AVERAGE (MADV_HUGEPAGE) --------
> > VFIO MAP DMA in 0.028 s (563.9 GB/s)
> > VFIO UNMAP DMA in 0.049 s (325.1 GB/s)
> > ------- AVERAGE (MAP_POPULATE) --------
> > VFIO MAP DMA in 0.294 s (54.4 GB/s)
> > VFIO UNMAP DMA in 0.296 s (54.1 GB/s)
> > ------- AVERAGE (HUGETLBFS) --------
> > VFIO MAP DMA in 0.033 s (485.1 GB/s)
> > VFIO UNMAP DMA in 0.049 s (324.4 GB/s)
> > 
> > For large folio, we achieve an approximate 64% performance improvement
> > in the VFIO UNMAP DMA item. For small folios, the performance test
> > results appear to show no significant changes.
> > 
> > [1]: https://github.com/awilliam/tests/blob/vfio-pci-mem-dma-map/vfio-pci-mem-dma-map.c
> > [2]: https://lore.kernel.org/all/20250610031013.98556-1-lizhe.67@bytedance.com/
> > [3]: https://lore.kernel.org/all/20250529064947.38433-1-lizhe.67@bytedance.com/
> > 
> > Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> > ---
> >   drivers/vfio/vfio_iommu_type1.c | 35 +++++++++++++++++++++++++++++----
> >   1 file changed, 31 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > index e952bf8bdfab..159ba80082a8 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -806,11 +806,38 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
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
> 
> (I know I can be a pain :) )

No, not at all! I really appreciate you taking the time to review my
patch.

> But the long comment indicates that this is confusing.
> 
> 
> That is essentially the logic in gup_folio_range_next().
> 
> What about factoring that out into a helper like
> 
> /*
>   * TODO, returned number includes the provided current page.
>   */
> unsigned long folio_remaining_pages(struct folio *folio,
> 	struct pages *pages, unsigned long max_pages)
> {
> 	if (!folio_test_large(folio))
> 		return 1;
> 	return min_t(unsigned long, max_pages,
> 		     folio_nr_pages(folio) - folio_page_idx(folio, page));
> }
> 
> 
> Then here you would do
> 
> if (!is_invalid_reserved_pfn(pfn)) {
> 	struct page *page = pfn_to_page(pfn);
> 	struct folio *folio = page_folio(page);
> 
> 	/* We can batch-process pages belonging to the same folio. */
> 	nr_pages = folio_remaining_pages(folio, page, npage);
> 
> 	unpin_user_folio_dirty_locked(folio, nr_pages,
> 				      dma->prot & IOMMU_WRITE);
> 	unlocked += nr_pages;
> }

Yes, this indeed makes the code much more comprehensible. Do you think
the implementation of the patch as follows look viable to you? I have
added some brief comments on top of your work to explain why we can
batch-process pages belonging to the same folio. This was suggested by
Alex[1].

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index e952bf8bdfab..d7653f4c10d5 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -801,16 +801,43 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
        return pinned;
 }
 
+/* Returned number includes the provided current page. */
+static inline unsigned long folio_remaining_pages(struct folio *folio,
+               struct page *page, unsigned long max_pages)
+{
+       if (!folio_test_large(folio))
+               return 1;
+       return min_t(unsigned long, max_pages,
+                    folio_nr_pages(folio) - folio_page_idx(folio, page));
+}
+
 static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
                                    unsigned long pfn, unsigned long npage,
                                    bool do_accounting)
 {
        long unlocked = 0, locked = vpfn_pages(dma, iova, npage);
-       long i;
 
-       for (i = 0; i < npage; i++)
-               if (put_pfn(pfn++, dma->prot))
-                       unlocked++;
+       while (npage) {
+               unsigned long nr_pages = 1;
+
+               if (!is_invalid_reserved_pfn(pfn)) {
+                       struct page *page = pfn_to_page(pfn);
+                       struct folio *folio = page_folio(page);
+
+                       /*
+                        * We can batch-process pages belonging to the same
+                        * folio because all pages within a folio share the
+                        * same invalid/reserved state.
+                        * */
+                       nr_pages = folio_remaining_pages(folio, page, npage);
+                       unpin_user_folio_dirty_locked(folio, nr_pages,
+                                       dma->prot & IOMMU_WRITE);
+                       unlocked += nr_pages;
+               }
+
+               pfn += nr_pages;
+               npage -= nr_pages;
+       }
 
        if (do_accounting)
		vfio_lock_acct(dma, locked - unlocked, true);
---

Thanks,
Zhe

[1]: https://lore.kernel.org/all/20250613113818.584bec0a.alex.williamson@redhat.com/

