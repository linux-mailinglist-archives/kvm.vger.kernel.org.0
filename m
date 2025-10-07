Return-Path: <kvm+bounces-59594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C069BC2AE6
	for <lists+kvm@lfdr.de>; Tue, 07 Oct 2025 22:44:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 25A563A492E
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 20:44:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D91DA246783;
	Tue,  7 Oct 2025 20:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NHevOP5Q"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4871D23BD1A
	for <kvm@vger.kernel.org>; Tue,  7 Oct 2025 20:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759869822; cv=none; b=Z7B/oFR3nStfr1nxskyH8HA7TxAn8M8r6thiE99nhmY0e0cx06w0QsN/Bq/9apSZzGOJnu/PoyYWN0ez/9eNa8TmqNk+SDCu0Tx/kpGRSOA1ZRJgvqnNiiYokzm8e5rR7sLaoN1/t1FoyqGW40iJ1Ux/5kbOiSfRTp/blVlx+fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759869822; c=relaxed/simple;
	bh=0/GE8UG1GvkI0APV00a143D2Nf5DngIi8pyOwroXZVw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DGkV5KUCdvV7q1vZwHjPKvtWbfdrJLpS2xtVzXLXJtdvbDmlA39hTEXFziv3YogE5iQi+jxKTxLZ9nHoA2s51m7bS70DBJULOS6tUIftMP2NU5wv1ufuygKTYXswhwowcG0p0PmAD+SRDa+HYJYZeMQ+8Q2cWPSCuAZMHhClrJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NHevOP5Q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759869817;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5Gyd2tSRqsMjb9vSXM5Y5lYTcuEZTqWpCxKzpqaqt5I=;
	b=NHevOP5Qg/x+82kNErqiITr2SumpCYN/UtOvEijS56QKNRq6/VBPwkrbA8vt4bI/6owwvM
	LRh7+KRqu42dE6RPBdIpNhl7cdiZVHDsgvCxSQ5Rink13bYbuFx/1skdO1CNdciqNBwc34
	DHfe4PsyPwSoa/Em2vhHEgdC5UOj/Is=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-321-gUyvmuDyM8eVQ5U-Q_kY6w-1; Tue, 07 Oct 2025 16:43:36 -0400
X-MC-Unique: gUyvmuDyM8eVQ5U-Q_kY6w-1
X-Mimecast-MFC-AGG-ID: gUyvmuDyM8eVQ5U-Q_kY6w_1759869816
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-42f64a75e85so5860445ab.2
        for <kvm@vger.kernel.org>; Tue, 07 Oct 2025 13:43:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759869814; x=1760474614;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5Gyd2tSRqsMjb9vSXM5Y5lYTcuEZTqWpCxKzpqaqt5I=;
        b=eo4F28u9XAo7PnTuYZyfTH/LiPHgFfIgAdhqXIS5kQVKCBtiuo5HhkChnR2Pusz375
         3FLeA8nOGkYp5bPxLYZBtNQIiRaV7hbwBv4o1slFQa8F4wh9KwF9zowye+/rDvcZAB5x
         bUlBFgvcQzWtWzrbkO2QEK2YMLjDmJi5k6W4GB5X1EnSIlyvSBEFHi2TrcZG67maCYzg
         HOkXX8bH7s9L4h5ZGDtvsZxvKdamOZ2poI+hwBp6X8u4Fdz/f4DH3Z1ZaiXtaP+9JU6X
         tjx0tpsvZEHtyVfePKFxCIZGunZYThO0VxhF770UEc0p2dlnHwQMjBLmBopijx7YcOEq
         5Dsg==
X-Forwarded-Encrypted: i=1; AJvYcCXnscoougvOzAohbYO2C5tlukp8VjBI0UAEWwjGMxrX3pgUfQ+vcPxeXPVbH/228sBWNC8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTTpSpJOPWOhHSCTSvbUIynxKkO7CshQIH6F1JBnsToRiIrEZY
	0WEe6sGQqdUqJiF7ovBguw+9q+oLKU/7l4EaEEgJKsTJX0YeVd4ysZA+Iks+OWdHzpZNemJOzac
	ROdan6NQkIZ6NmPxqisRpcCDdYtICHEtBLSfnxKr81MTV/9JOgNgGyPycW8lvqw==
X-Gm-Gg: ASbGncuvds/PERQk8e9NsFvpkoLGlnPr+dgjg7DkoV1m46P5gwMEMboighX6AgG0F0A
	DgAiGjnRyRvoUU7WuGPestgohV7f+cxZxQCVbItkT4c9I+EmgIYjHa6ZfxSl+u0qj5AMT7ef6he
	tucmMOlAXoOAU3TpodJaaMUgJKdkPX/6BhuIyZ8ksbOX0G+hoaYITZgzW8xqoZOt3eAGX8Zuwlr
	4bQj6SPqXgcK5t1oGn7JW91MQ3W9Xjyfrg7Xpmzha4NlA4OStjSDjc1r4HiWK9RZ5kbrR+8lAOz
	MZclDTVUikgfpompCkxGYbKglH35mT97gDPp7KgWf9OOoKG4
X-Received: by 2002:a05:6e02:1fca:b0:425:4a14:812e with SMTP id e9e14a558f8ab-42f8741030fmr2732045ab.7.1759869814353;
        Tue, 07 Oct 2025 13:43:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFEXz88lqbA7H5/fblEcQci97VP9+1bRQ9c31YrtcoYijDWLkvqedHIjFKGGKcIwRDafuJErw==
X-Received: by 2002:a05:6e02:1fca:b0:425:4a14:812e with SMTP id e9e14a558f8ab-42f8741030fmr2731925ab.7.1759869813787;
        Tue, 07 Oct 2025 13:43:33 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-42d8b1f3474sm68730825ab.9.2025.10.07.13.43.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Oct 2025 13:43:32 -0700 (PDT)
Date: Tue, 7 Oct 2025 14:43:28 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Alex Mastro <amastro@fb.com>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, Jason Gunthorpe
 <jgg@ziepe.ca>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfio: fix VFIO_IOMMU_UNMAP_DMA when end of range would
 overflow u64
Message-ID: <20251007144328.186fc0d2.alex.williamson@redhat.com>
In-Reply-To: <aOSWA46X1XsH7pwP@devgpu015.cco6.facebook.com>
References: <20251005-fix-unmap-v1-1-6687732ed44e@fb.com>
	<20251006121618.GA3365647@ziepe.ca>
	<aOPuU0O6PlOjd/Xs@devgpu015.cco6.facebook.com>
	<20251006225039.GA3441843@ziepe.ca>
	<aORhMMOU5p3j69ld@devgpu015.cco6.facebook.com>
	<68e18f2c-79ad-45ec-99b9-99ff68ba5438@oracle.com>
	<aOSWA46X1XsH7pwP@devgpu015.cco6.facebook.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 6 Oct 2025 21:24:35 -0700
Alex Mastro <amastro@fb.com> wrote:
> 
> I do like the explicitness of the check_* functions over the older style wrap
> checks.
> 
> Below is my partially validated attempt at a more comprehensive fix if we were
> to try and make end of address space mappings work, rather than blanking out
> the last page.

I prefer this approach, thanks for tackling it.  Consider splitting
into a few patches for easier review, ex. discrete input sanitizing with
proper overflow checking, refactoring the fast/slow handlers to
increment iova in the caller, remainder to tie it all together.  A few
comments inline below. 

> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 08242d8ce2ca..66a25de35446 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -28,6 +28,7 @@
>  #include <linux/iommu.h>
>  #include <linux/module.h>
>  #include <linux/mm.h>
> +#include <linux/overflow.h>
>  #include <linux/kthread.h>
>  #include <linux/rbtree.h>
>  #include <linux/sched/signal.h>
> @@ -165,12 +166,14 @@ static struct vfio_dma *vfio_find_dma(struct vfio_iommu *iommu,
>  {
>  	struct rb_node *node = iommu->dma_list.rb_node;
>  
> +	BUG_ON(size == 0);
> +
>  	while (node) {
>  		struct vfio_dma *dma = rb_entry(node, struct vfio_dma, node);
>  
> -		if (start + size <= dma->iova)
> +		if (start + size - 1 < dma->iova)
>  			node = node->rb_left;
> -		else if (start >= dma->iova + dma->size)
> +		else if (start > dma->iova + dma->size - 1)
>  			node = node->rb_right;
>  		else
>  			return dma;
> @@ -186,10 +189,12 @@ static struct rb_node *vfio_find_dma_first_node(struct vfio_iommu *iommu,
>  	struct rb_node *node = iommu->dma_list.rb_node;
>  	struct vfio_dma *dma_res = NULL;
>  
> +	BUG_ON(size == 0);
> +
>  	while (node) {
>  		struct vfio_dma *dma = rb_entry(node, struct vfio_dma, node);
>  
> -		if (start < dma->iova + dma->size) {
> +		if (start <= dma->iova + dma->size - 1) {
>  			res = node;
>  			dma_res = dma;
>  			if (start >= dma->iova)
> @@ -199,7 +204,7 @@ static struct rb_node *vfio_find_dma_first_node(struct vfio_iommu *iommu,
>  			node = node->rb_right;
>  		}
>  	}
> -	if (res && size && dma_res->iova > start + size - 1)
> +	if (res && dma_res->iova > start + size - 1)
>  		res = NULL;
>  	return res;
>  }
> @@ -213,7 +218,7 @@ static void vfio_link_dma(struct vfio_iommu *iommu, struct vfio_dma *new)
>  		parent = *link;
>  		dma = rb_entry(parent, struct vfio_dma, node);
>  
> -		if (new->iova + new->size <= dma->iova)
> +		if (new->iova + new->size - 1 < dma->iova)
>  			link = &(*link)->rb_left;
>  		else
>  			link = &(*link)->rb_right;
> @@ -825,14 +830,24 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>  	unsigned long remote_vaddr;
>  	struct vfio_dma *dma;
>  	bool do_accounting;
> +	u64 end, to_pin;

end looks like a dma_addr_t and to_pin ought to be a size_t, right?
Maybe iova_end and iova_size?

>  
> -	if (!iommu || !pages)
> +	if (!iommu || !pages || npage < 0)
>  		return -EINVAL;
>  
>  	/* Supported for v2 version only */
>  	if (!iommu->v2)
>  		return -EACCES;
>  
> +	if (npage == 0)
> +		return 0;
> +
> +	if (check_mul_overflow(npage, PAGE_SIZE, &to_pin))
> +		return -EINVAL;
> +
> +	if (check_add_overflow(user_iova, to_pin - 1, &end))
> +		return -EINVAL;
> +

Why not the same checks on vfio_iommu_type1_unpin_pages()?

>  	mutex_lock(&iommu->lock);
>  
>  	if (WARN_ONCE(iommu->vaddr_invalid_count,
> @@ -997,7 +1012,7 @@ static long vfio_sync_unpin(struct vfio_dma *dma, struct vfio_domain *domain,
>  #define VFIO_IOMMU_TLB_SYNC_MAX		512
>  
>  static size_t unmap_unpin_fast(struct vfio_domain *domain,
> -			       struct vfio_dma *dma, dma_addr_t *iova,
> +			       struct vfio_dma *dma, dma_addr_t iova,
>  			       size_t len, phys_addr_t phys, long *unlocked,
>  			       struct list_head *unmapped_list,
>  			       int *unmapped_cnt,
> @@ -1007,18 +1022,16 @@ static size_t unmap_unpin_fast(struct vfio_domain *domain,
>  	struct vfio_regions *entry = kzalloc(sizeof(*entry), GFP_KERNEL);
>  
>  	if (entry) {
> -		unmapped = iommu_unmap_fast(domain->domain, *iova, len,
> +		unmapped = iommu_unmap_fast(domain->domain, iova, len,
>  					    iotlb_gather);
>  
>  		if (!unmapped) {
>  			kfree(entry);
>  		} else {
> -			entry->iova = *iova;
> +			entry->iova = iova;
>  			entry->phys = phys;
>  			entry->len  = unmapped;
>  			list_add_tail(&entry->list, unmapped_list);
> -
> -			*iova += unmapped;
>  			(*unmapped_cnt)++;
>  		}
>  	}
> @@ -1037,18 +1050,17 @@ static size_t unmap_unpin_fast(struct vfio_domain *domain,
>  }
>  
>  static size_t unmap_unpin_slow(struct vfio_domain *domain,
> -			       struct vfio_dma *dma, dma_addr_t *iova,
> +			       struct vfio_dma *dma, dma_addr_t iova,
>  			       size_t len, phys_addr_t phys,
>  			       long *unlocked)
>  {
> -	size_t unmapped = iommu_unmap(domain->domain, *iova, len);
> +	size_t unmapped = iommu_unmap(domain->domain, iova, len);
>  
>  	if (unmapped) {
> -		*unlocked += vfio_unpin_pages_remote(dma, *iova,
> +		*unlocked += vfio_unpin_pages_remote(dma, iova,
>  						     phys >> PAGE_SHIFT,
>  						     unmapped >> PAGE_SHIFT,
>  						     false);
> -		*iova += unmapped;
>  		cond_resched();
>  	}
>  	return unmapped;
> @@ -1057,12 +1069,12 @@ static size_t unmap_unpin_slow(struct vfio_domain *domain,
>  static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
>  			     bool do_accounting)
>  {
> -	dma_addr_t iova = dma->iova, end = dma->iova + dma->size;
>  	struct vfio_domain *domain, *d;
>  	LIST_HEAD(unmapped_region_list);
>  	struct iommu_iotlb_gather iotlb_gather;
>  	int unmapped_region_cnt = 0;
>  	long unlocked = 0;
> +	size_t pos = 0;
>  
>  	if (!dma->size)
>  		return 0;
> @@ -1086,13 +1098,14 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
>  	}
>  
>  	iommu_iotlb_gather_init(&iotlb_gather);
> -	while (iova < end) {
> +	while (pos < dma->size) {
>  		size_t unmapped, len;
>  		phys_addr_t phys, next;
> +		dma_addr_t iova = dma->iova + pos;
>  
>  		phys = iommu_iova_to_phys(domain->domain, iova);
>  		if (WARN_ON(!phys)) {
> -			iova += PAGE_SIZE;
> +			pos += PAGE_SIZE;
>  			continue;
>  		}
>  
> @@ -1101,7 +1114,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
>  		 * may require hardware cache flushing, try to find the
>  		 * largest contiguous physical memory chunk to unmap.
>  		 */
> -		for (len = PAGE_SIZE; iova + len < end; len += PAGE_SIZE) {
> +		for (len = PAGE_SIZE; len + pos < dma->size; len += PAGE_SIZE) {
>  			next = iommu_iova_to_phys(domain->domain, iova + len);
>  			if (next != phys + len)
>  				break;
> @@ -1111,16 +1124,18 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
>  		 * First, try to use fast unmap/unpin. In case of failure,
>  		 * switch to slow unmap/unpin path.
>  		 */
> -		unmapped = unmap_unpin_fast(domain, dma, &iova, len, phys,
> +		unmapped = unmap_unpin_fast(domain, dma, iova, len, phys,
>  					    &unlocked, &unmapped_region_list,
>  					    &unmapped_region_cnt,
>  					    &iotlb_gather);
>  		if (!unmapped) {
> -			unmapped = unmap_unpin_slow(domain, dma, &iova, len,
> +			unmapped = unmap_unpin_slow(domain, dma, iova, len,
>  						    phys, &unlocked);
>  			if (WARN_ON(!unmapped))
>  				break;
>  		}
> +
> +		pos += unmapped;
>  	}
>  
>  	dma->iommu_mapped = false;
> @@ -1212,7 +1227,7 @@ static int update_user_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
>  }
>  
>  static int vfio_iova_dirty_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
> -				  dma_addr_t iova, size_t size, size_t pgsize)
> +				  dma_addr_t iova, u64 end, size_t pgsize)
>  {
>  	struct vfio_dma *dma;
>  	struct rb_node *n;
> @@ -1229,8 +1244,8 @@ static int vfio_iova_dirty_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
>  	if (dma && dma->iova != iova)
>  		return -EINVAL;
>  
> -	dma = vfio_find_dma(iommu, iova + size - 1, 0);
> -	if (dma && dma->iova + dma->size != iova + size)
> +	dma = vfio_find_dma(iommu, end, 1);
> +	if (dma && dma->iova + dma->size - 1 != end)
>  		return -EINVAL;
>  
>  	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
> @@ -1239,7 +1254,7 @@ static int vfio_iova_dirty_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
>  		if (dma->iova < iova)
>  			continue;
>  
> -		if (dma->iova > iova + size - 1)
> +		if (dma->iova > end)
>  			break;
>  
>  		ret = update_user_bitmap(bitmap, iommu, dma, iova, pgsize);
> @@ -1305,6 +1320,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>  	unsigned long pgshift;
>  	dma_addr_t iova = unmap->iova;
>  	u64 size = unmap->size;
> +	u64 unmap_end;
>  	bool unmap_all = unmap->flags & VFIO_DMA_UNMAP_FLAG_ALL;
>  	bool invalidate_vaddr = unmap->flags & VFIO_DMA_UNMAP_FLAG_VADDR;
>  	struct rb_node *n, *first_n;
> @@ -1327,11 +1343,13 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>  		if (iova || size)
>  			goto unlock;
>  		size = U64_MAX;
> -	} else if (!size || size & (pgsize - 1) ||
> -		   iova + size - 1 < iova || size > SIZE_MAX) {
> +	} else if (!size || size & (pgsize - 1) || size > SIZE_MAX) {
>  		goto unlock;
>  	}
>  
> +	if (check_add_overflow(iova, size - 1, &unmap_end))
> +		goto unlock;
> +
>  	/* When dirty tracking is enabled, allow only min supported pgsize */
>  	if ((unmap->flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) &&
>  	    (!iommu->dirty_page_tracking || (bitmap->pgsize != pgsize))) {
> @@ -1376,8 +1394,8 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>  		if (dma && dma->iova != iova)
>  			goto unlock;
>  
> -		dma = vfio_find_dma(iommu, iova + size - 1, 0);
> -		if (dma && dma->iova + dma->size != iova + size)
> +		dma = vfio_find_dma(iommu, unmap_end, 1);
> +		if (dma && dma->iova + dma->size - 1 != unmap_end)
>  			goto unlock;
>  	}
>  
> @@ -1386,7 +1404,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>  
>  	while (n) {
>  		dma = rb_entry(n, struct vfio_dma, node);
> -		if (dma->iova > iova + size - 1)
> +		if (dma->iova > unmap_end)
>  			break;
>  
>  		if (!iommu->v2 && iova > dma->iova)
> @@ -1713,12 +1731,12 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
>  
>  	for (; n; n = rb_next(n)) {
>  		struct vfio_dma *dma;
> -		dma_addr_t iova;
> +		size_t pos = 0;
>  
>  		dma = rb_entry(n, struct vfio_dma, node);
> -		iova = dma->iova;
>  
> -		while (iova < dma->iova + dma->size) {
> +		while (pos < dma->size) {
> +			dma_addr_t iova = dma->iova + pos;
>  			phys_addr_t phys;
>  			size_t size;
>  
> @@ -1734,14 +1752,15 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
>  				phys = iommu_iova_to_phys(d->domain, iova);
>  
>  				if (WARN_ON(!phys)) {
> -					iova += PAGE_SIZE;
> +					pos += PAGE_SIZE;
>  					continue;
>  				}
>  
> +

Extra white space

>  				size = PAGE_SIZE;
>  				p = phys + size;
>  				i = iova + size;
> -				while (i < dma->iova + dma->size &&
> +				while (size + pos < dma->size &&
>  				       p == iommu_iova_to_phys(d->domain, i)) {
>  					size += PAGE_SIZE;
>  					p += PAGE_SIZE;

I think the else branch after this has some use cases too, (iova -
dma->iova) just becomes 'pos' in calculating vaddr, 'n' should be
calculated as (dma->size - pos).

> @@ -1782,7 +1801,7 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
>  				goto unwind;
>  			}
>  
> -			iova += size;
> +			pos += size;
>  		}
>  	}
>  
> @@ -1799,29 +1818,29 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
>  unwind:
>  	for (; n; n = rb_prev(n)) {
>  		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
> -		dma_addr_t iova;
> +		size_t pos = 0;
>  
>  		if (dma->iommu_mapped) {
>  			iommu_unmap(domain->domain, dma->iova, dma->size);
>  			continue;
>  		}
>  
> -		iova = dma->iova;
> -		while (iova < dma->iova + dma->size) {
> +		while (pos < dma->size) {
> +			dma_addr_t iova = dma->iova + pos;
>  			phys_addr_t phys, p;
>  			size_t size;
>  			dma_addr_t i;
>  
>  			phys = iommu_iova_to_phys(domain->domain, iova);
>  			if (!phys) {
> -				iova += PAGE_SIZE;
> +				pos += PAGE_SIZE;
>  				continue;
>  			}
>  
>  			size = PAGE_SIZE;
>  			p = phys + size;
>  			i = iova + size;
> -			while (i < dma->iova + dma->size &&
> +			while (pos + size < dma->size &&
>  			       p == iommu_iova_to_phys(domain->domain, i)) {
>  				size += PAGE_SIZE;
>  				p += PAGE_SIZE;
> @@ -2908,6 +2927,7 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
>  		unsigned long pgshift;
>  		size_t data_size = dirty.argsz - minsz;
>  		size_t iommu_pgsize;
> +		u64 end;

Seems like a dma_addr_t.  range_end?  Thanks,

Alex

>  
>  		if (!data_size || data_size < sizeof(range))
>  			return -EINVAL;
> @@ -2916,8 +2936,12 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
>  				   sizeof(range)))
>  			return -EFAULT;
>  
> -		if (range.iova + range.size < range.iova)
> +		if (range.size == 0)
> +			return 0;
> +
> +		if (check_add_overflow(range.iova, range.size - 1, &end))
>  			return -EINVAL;
> +
>  		if (!access_ok((void __user *)range.bitmap.data,
>  			       range.bitmap.size))
>  			return -EINVAL;
> @@ -2949,7 +2973,7 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
>  		if (iommu->dirty_page_tracking)
>  			ret = vfio_iova_dirty_bitmap(range.bitmap.data,
>  						     iommu, range.iova,
> -						     range.size,
> +						     end,
>  						     range.bitmap.pgsize);
>  		else
>  			ret = -EINVAL;
> 


