Return-Path: <kvm+bounces-47414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F55EAC15A7
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 22:52:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 39A4916590D
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 20:52:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF83D24C097;
	Thu, 22 May 2025 20:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E6BEGq+f"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2C224BC1D
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 20:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747947137; cv=none; b=BdOqOMiDiEQUmmYon5ioBzuSaVbkB+CDMyAkG/bDBamv0LvwXAVOZwRbFYXXT8fz4/MpeKqduep4eteIIi0GmTuEBUyf4OGbSl+95CwrAcKxLeVMshIDIPiIGvj7rC0vvCN7781+V62wZM8GTUJTQ6Cxi/oLs/AHhVo4wY9xSmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747947137; c=relaxed/simple;
	bh=fTyOrHsaj9R+TJydwhIoSj0lr/PnJ4ql3kdA0+P9sT0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q7AwDHfVwi9gN2j7Yci+oOUafW9paLXeMgwJGyR/amk82JFPmQfgt8DorD5V+5BOh6gdoqwXJAXzP/3487k+eQ6XPI/Ms6Jkl3rrWZv0wDHibJ4nEm4Dg8DphpyVBSQzv1CHTZMewfhDrSc7cAxOxoGPadn6vRD1uGPOiQOn/m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E6BEGq+f; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747947133;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EGTLhJpx3F9M/hH1CASqtNzMI3BHbenDsF+z7qqWDjM=;
	b=E6BEGq+fN+33znvRF0qjSiHvVJKTWSyb7XDqykqXORjYXE4PDVBONxelqqV3X5I9DAJKny
	6LV/jeF6fU41PU5Yxbd3jo1bkhjhFY4YKrUZEL6zxQ8blt/30CtDfIlrC2tcyHwCA+owRi
	0O0cXArpWpnnszSIntXwToKTaWIVgoA=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-681-J9Wlw_rZP6KeExW2BhWV6g-1; Thu, 22 May 2025 16:52:12 -0400
X-MC-Unique: J9Wlw_rZP6KeExW2BhWV6g-1
X-Mimecast-MFC-AGG-ID: J9Wlw_rZP6KeExW2BhWV6g_1747947132
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-85b45e94b08so120158939f.0
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 13:52:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747947131; x=1748551931;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EGTLhJpx3F9M/hH1CASqtNzMI3BHbenDsF+z7qqWDjM=;
        b=otCK0qgfficO1EfrwwxYlo8IKrXkbo0N2NxMRaRIkMFpCB9BVf6pjay21EC9InJDaP
         kqjAQ0i7mxpbBQPKWgJA9RWM0t7JOAyBJ9/eQYId6WNcBuU39EsRXU5c1Rjt1mgAy22R
         qcYizhcnTcJ1XFGHYGfxH4AXLyZveK8+AwA1e9UQvmoUG9Pm8AW4ACmrZwqa6Of7kpSF
         VUYRTu1a0ltFIpPHSRkm8DblKMSkQ/jg9f9aIc2EH6jp3A9IZgEa+vNSaRLqCrqDH0fm
         3Acf9dKJAGkW/NHW345YfxMlzr4SCcbLI6KH2Jz4ToDBe1sxcr/ijnIbuj00rI34EUap
         XX/g==
X-Forwarded-Encrypted: i=1; AJvYcCUibP/DF761z4faKZphW0r3qyGLK6MXnGbLbj8cJKJ6CsLXYojWW+PFBZqsAqaL92fB5FY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwuIGvStLsVEeODvu1OhFF1GCZynrMgbtDP5fXZAh781YaQmJIH
	/zhSbXjhz+d3kMoPwHsqEzTwK/v+5+9YxRMGd/3s0cmrI6jNx/P6KVlV6I5oXAYicH4Ehsvqtsh
	7nXvc2kJ2LskutdytDic2Ou7gvf4Q+PxI8Az7CCwE0vWkta96eABqQA==
X-Gm-Gg: ASbGncuR31T9pqPUvMJUJhKKvk60qKvRnHBtfgYIWFOdqAemnEd6txiylEJ0o/D0ZoW
	zRNdejrP89o4azbvY4lJRRSU71HldV22mxdBs7n/7HNYQ+CDsLmwnSXHLc+46bJ08zpKemd5WKK
	KdZt6x4kH4prBEzDQIRjwHGKFpO5hpRNB1s+EF8ah54KQGhjIMclu5mJOoNk8FONVcgnaC/moVh
	CQRBGIZPjvTN2NIw3Yvq/ioCuYMKUPvR0c5ySgRxK6jnCg6EGTM4c5X0Xgs/AiodmLjdiilYAN7
	2/b6LOPoKvSDebE=
X-Received: by 2002:a05:6602:160d:b0:867:ddd:bc54 with SMTP id ca18e2360f4ac-86a232cc36cmr868073039f.5.1747947131502;
        Thu, 22 May 2025 13:52:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFtqLwL4EEjWZoWfka1PUDhJ6Av3HiQxMuLS5exKoiu8NhmzKLHGUSY5WGyjCe+HoDAstPLNg==
X-Received: by 2002:a05:6602:160d:b0:867:ddd:bc54 with SMTP id ca18e2360f4ac-86a232cc36cmr868072039f.5.1747947131065;
        Thu, 22 May 2025 13:52:11 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc48c897sm3331713173.98.2025.05.22.13.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 May 2025 13:52:10 -0700 (PDT)
Date: Thu, 22 May 2025 14:52:07 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: lizhe.67@bytedance.com
Cc: david@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 muchun.song@linux.dev, peterx@redhat.com
Subject: Re: [PATCH v4] vfio/type1: optimize vfio_pin_pages_remote() for
 large folio
Message-ID: <20250522145207.01734386.alex.williamson@redhat.com>
In-Reply-To: <20250522082524.75076-1-lizhe.67@bytedance.com>
References: <81d73c4c-28c4-4fa0-bc71-aef6429e2c31@redhat.com>
	<20250522082524.75076-1-lizhe.67@bytedance.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 22 May 2025 16:25:24 +0800
lizhe.67@bytedance.com wrote:

> On Thu, 22 May 2025 09:22:50 +0200, david@redhat.com wrote:
> 
> >On 22.05.25 05:49, lizhe.67@bytedance.com wrote:  
> >> On Wed, 21 May 2025 13:17:11 -0600, alex.williamson@redhat.com wrote:
> >>   
> >>>> From: Li Zhe <lizhe.67@bytedance.com>
> >>>>
> >>>> When vfio_pin_pages_remote() is called with a range of addresses that
> >>>> includes large folios, the function currently performs individual
> >>>> statistics counting operations for each page. This can lead to significant
> >>>> performance overheads, especially when dealing with large ranges of pages.
> >>>>
> >>>> This patch optimize this process by batching the statistics counting
> >>>> operations.
> >>>>
> >>>> The performance test results for completing the 8G VFIO IOMMU DMA mapping,
> >>>> obtained through trace-cmd, are as follows. In this case, the 8G virtual
> >>>> address space has been mapped to physical memory using hugetlbfs with
> >>>> pagesize=2M.
> >>>>
> >>>> Before this patch:
> >>>> funcgraph_entry:      # 33813.703 us |  vfio_pin_map_dma();
> >>>>
> >>>> After this patch:
> >>>> funcgraph_entry:      # 16071.378 us |  vfio_pin_map_dma();
> >>>>
> >>>> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> >>>> Co-developed-by: Alex Williamson <alex.williamson@redhat.com>
> >>>> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> >>>> ---  
> >>>
> >>> Given the discussion on v3, this is currently a Nak.  Follow-up in that
> >>> thread if there are further ideas how to salvage this.  Thanks,  
> >> 
> >> How about considering the solution David mentioned to check whether the
> >> pages or PFNs are actually consecutive?
> >> 
> >> I have conducted a preliminary attempt, and the performance testing
> >> revealed that the time consumption is approximately 18,000 microseconds.
> >> Compared to the previous 33,000 microseconds, this also represents a
> >> significant improvement.
> >> 
> >> The modification is quite straightforward. The code below reflects the
> >> changes I have made based on this patch.
> >> 
> >> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> >> index bd46ed9361fe..1cc1f76d4020 100644
> >> --- a/drivers/vfio/vfio_iommu_type1.c
> >> +++ b/drivers/vfio/vfio_iommu_type1.c
> >> @@ -627,6 +627,19 @@ static long vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
> >>          return ret;
> >>   }
> >>   
> >> +static inline long continuous_page_num(struct vfio_batch *batch, long npage)
> >> +{
> >> +       long i;
> >> +       unsigned long next_pfn = page_to_pfn(batch->pages[batch->offset]) + 1;
> >> +
> >> +       for (i = 1; i < npage; ++i) {
> >> +               if (page_to_pfn(batch->pages[batch->offset + i]) != next_pfn)
> >> +                       break;
> >> +               next_pfn++;
> >> +       }
> >> +       return i;
> >> +}  
> >
> >
> >What might be faster is obtaining the folio, and then calculating the 
> >next expected page pointer, comparing whether the page pointers match.
> >
> >Essentially, using folio_page() to calculate the expected next page.
> >
> >nth_page() is a simple pointer arithmetic with CONFIG_SPARSEMEM_VMEMMAP, 
> >so that might be rather fast.
> >
> >
> >So we'd obtain
> >
> >start_idx = folio_idx(folio, batch->pages[batch->offset]);  
> 
> Do you mean using folio_page_idx()?
> 
> >and then check for
> >
> >batch->pages[batch->offset + i] == folio_page(folio, start_idx + i)  
> 
> Thank you for your reminder. This is indeed a better solution.
> The updated code might look like this:
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index bd46ed9361fe..f9a11b1d8433 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -627,6 +627,20 @@ static long vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
>         return ret;
>  }
>  
> +static inline long continuous_pages_num(struct folio *folio,
> +               struct vfio_batch *batch, long npage)

Note this becomes long enough that we should just let the compiler
decide whether to inline or not.

> +{
> +       long i;
> +       unsigned long start_idx =
> +                       folio_page_idx(folio, batch->pages[batch->offset]);
> +
> +       for (i = 1; i < npage; ++i)
> +               if (batch->pages[batch->offset + i] !=
> +                               folio_page(folio, start_idx + i))
> +                       break;
> +       return i;
> +}
> +
>  /*
>   * Attempt to pin pages.  We really don't want to track all the pfns and
>   * the iommu can only map chunks of consecutive pfns anyway, so get the
> @@ -708,8 +722,12 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
>                          */
>                         nr_pages = min_t(long, batch->size, folio_nr_pages(folio) -
>                                                 folio_page_idx(folio, batch->pages[batch->offset]));
> -                       if (nr_pages > 1 && vfio_find_vpfn_range(dma, iova, nr_pages))
> -                               nr_pages = 1;
> +                       if (nr_pages > 1) {
> +                               if (vfio_find_vpfn_range(dma, iova, nr_pages))
> +                                       nr_pages = 1;
> +                               else
> +                                       nr_pages = continuous_pages_num(folio, batch, nr_pages);
> +                       }


I think we can refactor this a bit better and maybe if we're going to
the trouble of comparing pages we can be a bit more resilient to pages
already accounted as vpfns.  I took a shot at it, compile tested only,
is there still a worthwhile gain?

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 0ac56072af9f..e8bba32148f7 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -319,7 +319,13 @@ static void vfio_dma_bitmap_free_all(struct vfio_iommu *iommu)
 /*
  * Helper Functions for host iova-pfn list
  */
-static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
+
+/*
+ * Find the first vfio_pfn that overlapping the range
+ * [iova_start, iova_end) in rb tree.
+ */
+static struct vfio_pfn *vfio_find_vpfn_range(struct vfio_dma *dma,
+		dma_addr_t iova_start, dma_addr_t iova_end)
 {
 	struct vfio_pfn *vpfn;
 	struct rb_node *node = dma->pfn_list.rb_node;
@@ -327,9 +333,9 @@ static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
 	while (node) {
 		vpfn = rb_entry(node, struct vfio_pfn, node);
 
-		if (iova < vpfn->iova)
+		if (iova_end <= vpfn->iova)
 			node = node->rb_left;
-		else if (iova > vpfn->iova)
+		else if (iova_start > vpfn->iova)
 			node = node->rb_right;
 		else
 			return vpfn;
@@ -337,6 +343,11 @@ static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
 	return NULL;
 }
 
+static inline struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
+{
+	return vfio_find_vpfn_range(dma, iova, iova + PAGE_SIZE);
+}
+
 static void vfio_link_pfn(struct vfio_dma *dma,
 			  struct vfio_pfn *new)
 {
@@ -615,6 +626,43 @@ static long vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
 	return ret;
 }
 
+static long contig_pages(struct vfio_dma *dma,
+			 struct vfio_batch *batch, dma_addr_t iova)
+{
+	struct page *page = batch->pages[batch->offset];
+	struct folio *folio = page_folio(page);
+	long idx = folio_page_idx(folio, page);
+	long max = min_t(long, batch->size, folio_nr_pages(folio) - idx);
+	long nr_pages;
+
+	for (nr_pages = 1; nr_pages < max; nr_pages++) {
+		if (batch->pages[batch->offset + nr_pages] !=
+		    folio_page(folio, idx + nr_pages))
+			break;
+	}
+
+	return nr_pages;
+}
+
+static long vpfn_pages(struct vfio_dma *dma,
+		       dma_addr_t iova_start, long nr_pages)
+{
+	dma_addr_t iova_end = iova_start + (nr_pages << PAGE_SHIFT);
+	struct vfio_pfn *vpfn;
+	long count = 0;
+
+	do {
+		vpfn = vfio_find_vpfn_range(dma, iova_start, iova_end);
+		if (likely(!vpfn))
+			break;
+
+		count++;
+		iova_start = vpfn->iova + PAGE_SIZE;
+	} while (iova_start < iova_end);
+
+	return count;
+}
+
 /*
  * Attempt to pin pages.  We really don't want to track all the pfns and
  * the iommu can only map chunks of consecutive pfns anyway, so get the
@@ -681,32 +729,40 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 		 * and rsvd here, and therefore continues to use the batch.
 		 */
 		while (true) {
+			long nr_pages, acct_pages = 0;
+
 			if (pfn != *pfn_base + pinned ||
 			    rsvd != is_invalid_reserved_pfn(pfn))
 				goto out;
 
+			nr_pages = contig_pages(dma, batch, iova);
+			if (!rsvd) {
+				acct_pages = nr_pages;
+				acct_pages -= vpfn_pages(dma, iova, nr_pages);
+			}
+
 			/*
 			 * Reserved pages aren't counted against the user,
 			 * externally pinned pages are already counted against
 			 * the user.
 			 */
-			if (!rsvd && !vfio_find_vpfn(dma, iova)) {
+			if (acct_pages) {
 				if (!dma->lock_cap &&
-				    mm->locked_vm + lock_acct + 1 > limit) {
+				    mm->locked_vm + lock_acct + acct_pages > limit) {
 					pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
 						__func__, limit << PAGE_SHIFT);
 					ret = -ENOMEM;
 					goto unpin_out;
 				}
-				lock_acct++;
+				lock_acct += acct_pages;
 			}
 
-			pinned++;
-			npage--;
-			vaddr += PAGE_SIZE;
-			iova += PAGE_SIZE;
-			batch->offset++;
-			batch->size--;
+			pinned += nr_pages;
+			npage -= nr_pages;
+			vaddr += PAGE_SIZE * nr_pages;
+			iova += PAGE_SIZE * nr_pages;
+			batch->offset += nr_pages;
+			batch->size -= nr_pages;
 
 			if (!batch->size)
 				break;



