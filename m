Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E756C2B20AF
	for <lists+kvm@lfdr.de>; Fri, 13 Nov 2020 17:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgKMQo3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Nov 2020 11:44:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42385 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726248AbgKMQo3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Nov 2020 11:44:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605285866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uqhZbVq8cFl7dTSge6GZgDoRr5VLrSDa1e6v6Le4CpY=;
        b=ZUsSM/9enNAv85OEYMHjquxXua694kr7hgyovN+hcc0w2TtGWL+WueUaQNHkH6Sw069iO8
        rAj/antYWcPR+lw7DuMGYx9x3Yx0oIGNw2f0ZR5rvTLjB/vZfLQWi5ORpUdoFzc7bdTuKS
        Zcwhcha8tZCAbY5RVXF6m+v4MXA8Bps=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-383-v4jzLLaTOu667vcNCpidtw-1; Fri, 13 Nov 2020 11:44:22 -0500
X-MC-Unique: v4jzLLaTOu667vcNCpidtw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7ABD1803F6A;
        Fri, 13 Nov 2020 16:44:20 +0000 (UTC)
Received: from w520.home (ovpn-112-213.phx2.redhat.com [10.3.112.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA71F5B4C3;
        Fri, 13 Nov 2020 16:44:19 +0000 (UTC)
Date:   Fri, 13 Nov 2020 09:44:17 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "xuxiaoyang (C)" <xuxiaoyang2@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <kwankhede@nvidia.com>, <wu.wubin@huawei.com>,
        <maoming.maoming@huawei.com>, <xieyingtai@huawei.com>,
        <lizhengui@huawei.com>, <wubinfeng@huawei.com>
Subject: Re: [PATCH] vfio iommu type1: Improve vfio_iommu_type1_pin_pages
 performance
Message-ID: <20201113094417.51d73615@w520.home>
In-Reply-To: <2553f102-de17-b23b-4cd8-fefaf2a04f24@huawei.com>
References: <2553f102-de17-b23b-4cd8-fefaf2a04f24@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 10 Nov 2020 21:42:33 +0800
"xuxiaoyang (C)" <xuxiaoyang2@huawei.com> wrote:

> vfio_iommu_type1_pin_pages is very inefficient because
> it is processed page by page when calling vfio_pin_page_external.
> Added contiguous_vaddr_get_pfn to process continuous pages
> to reduce the number of loops, thereby improving performance.
> 
> Signed-off-by: Xiaoyang Xu <xuxiaoyang2@huawei.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 241 ++++++++++++++++++++++++++++----
>  1 file changed, 214 insertions(+), 27 deletions(-)

Sorry for my previous misunderstanding of the logic here.  Still, this
adds a lot of complexity, can you quantify the performance improvement
you're seeing?  Would it instead be more worthwhile to support an
interface that pins based on an iova and range?  Further comments below.

> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 67e827638995..935f80807527 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -628,6 +628,206 @@ static int vfio_unpin_page_external(struct vfio_dma *dma, dma_addr_t iova,
>  	return unlocked;
>  }
> 
> +static int contiguous_vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
> +				    int prot, long npage, unsigned long *phys_pfn)
> +{
> +	struct page **pages = NULL;
> +	unsigned int flags = 0;
> +	int i, ret;
> +
> +	pages = kvmalloc_array(npage, sizeof(struct page *), GFP_KERNEL);
> +	if (!pages)
> +		return -ENOMEM;
> +
> +	if (prot & IOMMU_WRITE)
> +		flags |= FOLL_WRITE;
> +
> +	mmap_read_lock(mm);
> +	ret = pin_user_pages_remote(mm, vaddr, npage, flags | FOLL_LONGTERM,
> +				    pages, NULL, NULL);

This is essentially the root of the performance improvement claim,
right?  ie. we're pinning a range of pages rather than individually.
Unfortunately it means we also add a dynamic memory allocation even
when npage=1.


> +	mmap_read_unlock(mm);
> +
> +	for (i = 0; i < ret; i++)
> +		*(phys_pfn + i) = page_to_pfn(pages[i]);
> +
> +	kvfree(pages);
> +
> +	return ret;
> +}
> +
> +static int vfio_pin_contiguous_pages_external(struct vfio_iommu *iommu,
> +				    struct vfio_dma *dma,
> +				    unsigned long *user_pfn,
> +				    int npage, unsigned long *phys_pfn,
> +				    bool do_accounting)
> +{
> +	int ret, i, j, lock_acct = 0;
> +	unsigned long remote_vaddr;
> +	dma_addr_t iova;
> +	struct mm_struct *mm;
> +	struct vfio_pfn *vpfn;
> +
> +	mm = get_task_mm(dma->task);
> +	if (!mm)
> +		return -ENODEV;
> +
> +	iova = user_pfn[0] << PAGE_SHIFT;
> +	remote_vaddr = dma->vaddr + iova - dma->iova;
> +	ret = contiguous_vaddr_get_pfn(mm, remote_vaddr, dma->prot,
> +					    npage, phys_pfn);
> +	mmput(mm);
> +	if (ret <= 0)
> +		return ret;
> +
> +	npage = ret;
> +	for (i = 0; i < npage; i++) {
> +		iova = user_pfn[i] << PAGE_SHIFT;
> +		ret = vfio_add_to_pfn_list(dma, iova, phys_pfn[i]);
> +		if (ret)
> +			goto unwind;
> +
> +		if (!is_invalid_reserved_pfn(phys_pfn[i]))
> +			lock_acct++;
> +
> +		if (iommu->dirty_page_tracking) {
> +			unsigned long pgshift = __ffs(iommu->pgsize_bitmap);
> +
> +			/*
> +			 * Bitmap populated with the smallest supported page
> +			 * size
> +			 */
> +			bitmap_set(dma->bitmap,
> +				   (iova - dma->iova) >> pgshift, 1);
> +		}

It doesn't make sense that we wouldn't also optimize this to simply set
npage bits.  There's also no unwind for this.

> +	}
> +
> +	if (do_accounting) {
> +		ret = vfio_lock_acct(dma, lock_acct, true);
> +		if (ret) {
> +			if (ret == -ENOMEM)
> +				pr_warn("%s: Task %s (%d) RLIMIT_MEMLOCK (%ld) exceeded\n",
> +					__func__, dma->task->comm, task_pid_nr(dma->task),
> +					task_rlimit(dma->task, RLIMIT_MEMLOCK));
> +			goto unwind;
> +		}
> +	}

This algorithm allows pinning many more pages in advance of testing
whether we've exceeded the task locked memory limit than the per page
approach.


> +
> +	return i;
> +unwind:
> +	for (j = 0; j < npage; j++) {
> +		put_pfn(phys_pfn[j], dma->prot);
> +		phys_pfn[j] = 0;
> +	}
> +
> +	for (j = 0; j < i; j++) {
> +		iova = user_pfn[j] << PAGE_SHIFT;
> +		vpfn = vfio_find_vpfn(dma, iova);
> +		if (vpfn)

Seems like not finding a vpfn would be an error.

> +			vfio_remove_from_pfn_list(dma, vpfn);

It seems poor form not to use vfio_iova_put_vfio_pfn() here even if we
know we hold the only reference.


> +	}
> +
> +	return ret;
> +}
> +
> +static int vfio_iommu_type1_pin_contiguous_pages(struct vfio_iommu *iommu,
> +					    struct vfio_dma *dma,
> +					    unsigned long *user_pfn,
> +					    int npage, unsigned long *phys_pfn,
> +					    bool do_accounting)
> +{
> +	int ret, i, j;
> +	unsigned long remote_vaddr;
> +	dma_addr_t iova;
> +
> +	ret = vfio_pin_contiguous_pages_external(iommu, dma, user_pfn, npage,
> +				phys_pfn, do_accounting);
> +	if (ret == npage)
> +		return ret;
> +
> +	if (ret < 0)
> +		ret = 0;


I'm lost, why do we need the single page iteration below??

> +	for (i = ret; i < npage; i++) {
> +		iova = user_pfn[i] << PAGE_SHIFT;
> +		remote_vaddr = dma->vaddr + iova - dma->iova;
> +
> +		ret = vfio_pin_page_external(dma, remote_vaddr, &phys_pfn[i],
> +			    do_accounting);
> +		if (ret)
> +			goto pin_unwind;
> +
> +		ret = vfio_add_to_pfn_list(dma, iova, phys_pfn[i]);
> +		if (ret) {
> +			if (put_pfn(phys_pfn[i], dma->prot) && do_accounting)
> +				vfio_lock_acct(dma, -1, true);
> +			goto pin_unwind;
> +		}
> +
> +		if (iommu->dirty_page_tracking) {
> +			unsigned long pgshift = __ffs(iommu->pgsize_bitmap);
> +
> +			/*
> +			 * Bitmap populated with the smallest supported page
> +			 * size
> +			 */
> +			bitmap_set(dma->bitmap,
> +					   (iova - dma->iova) >> pgshift, 1);
> +		}
> +	}
> +
> +	return i;
> +
> +pin_unwind:
> +	phys_pfn[i] = 0;
> +	for (j = 0; j < i; j++) {
> +		dma_addr_t iova;
> +
> +		iova = user_pfn[j] << PAGE_SHIFT;
> +		vfio_unpin_page_external(dma, iova, do_accounting);
> +		phys_pfn[j] = 0;
> +	}
> +
> +	return ret;
> +}
> +
> +static int vfio_iommu_type1_get_contiguous_pages_length(struct vfio_iommu *iommu,
> +				    unsigned long *user_pfn, int npage, int prot)
> +{
> +	struct vfio_dma *dma_base;
> +	int i;
> +	dma_addr_t iova;
> +	struct vfio_pfn *vpfn;
> +
> +	if (npage <= 1)
> +		return npage;
> +
> +	iova = user_pfn[0] << PAGE_SHIFT;
> +	dma_base = vfio_find_dma(iommu, iova, PAGE_SIZE);
> +	if (!dma_base)
> +		return -EINVAL;
> +
> +	if ((dma_base->prot & prot) != prot)
> +		return -EPERM;
> +
> +	for (i = 1; i < npage; i++) {
> +		iova = user_pfn[i] << PAGE_SHIFT;
> +
> +		if (iova >= dma_base->iova + dma_base->size ||
> +				iova + PAGE_SIZE <= dma_base->iova)
> +			break;
> +
> +		vpfn = vfio_iova_get_vfio_pfn(dma_base, iova);
> +		if (vpfn) {
> +			vfio_iova_put_vfio_pfn(dma_base, vpfn);

Why not just use vfio_find_vpfn() rather than get+put?

> +			break;
> +		}
> +
> +		if (user_pfn[i] != user_pfn[0] + i)

Shouldn't this be the first test?

> +			break;
> +	}
> +	return i;
> +}
> +
>  static int vfio_iommu_type1_pin_pages(void *iommu_data,
>  				      struct iommu_group *iommu_group,
>  				      unsigned long *user_pfn,
> @@ -637,9 +837,9 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>  	struct vfio_iommu *iommu = iommu_data;
>  	struct vfio_group *group;
>  	int i, j, ret;
> -	unsigned long remote_vaddr;
>  	struct vfio_dma *dma;
>  	bool do_accounting;
> +	int contiguous_npage;
> 
>  	if (!iommu || !user_pfn || !phys_pfn)
>  		return -EINVAL;
> @@ -663,7 +863,7 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>  	 */
>  	do_accounting = !IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu);
> 
> -	for (i = 0; i < npage; i++) {
> +	for (i = 0; i < npage; i += contiguous_npage) {
>  		dma_addr_t iova;
>  		struct vfio_pfn *vpfn;
> 
> @@ -682,31 +882,18 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>  		vpfn = vfio_iova_get_vfio_pfn(dma, iova);
>  		if (vpfn) {
>  			phys_pfn[i] = vpfn->pfn;
> -			continue;
> -		}
> -
> -		remote_vaddr = dma->vaddr + (iova - dma->iova);
> -		ret = vfio_pin_page_external(dma, remote_vaddr, &phys_pfn[i],
> -					     do_accounting);
> -		if (ret)
> -			goto pin_unwind;
> -
> -		ret = vfio_add_to_pfn_list(dma, iova, phys_pfn[i]);
> -		if (ret) {
> -			if (put_pfn(phys_pfn[i], dma->prot) && do_accounting)
> -				vfio_lock_acct(dma, -1, true);
> -			goto pin_unwind;
> -		}
> -
> -		if (iommu->dirty_page_tracking) {
> -			unsigned long pgshift = __ffs(iommu->pgsize_bitmap);
> -
> -			/*
> -			 * Bitmap populated with the smallest supported page
> -			 * size
> -			 */
> -			bitmap_set(dma->bitmap,
> -				   (iova - dma->iova) >> pgshift, 1);
> +			contiguous_npage = 1;
> +		} else {
> +			ret = vfio_iommu_type1_get_contiguous_pages_length(iommu,
> +					&user_pfn[i], npage - i, prot);


It doesn't make a lot of sense to me that this isn't more integrated
into the base function.  For example, we're passing &user_pfn[i] for
which we've already converted to an iova, found the vfio_dma associated
to that iova, and checked the protection.  This callout does all of
that again on the same.

> +			if (ret < 0)
> +				goto pin_unwind;
> +
> +			ret = vfio_iommu_type1_pin_contiguous_pages(iommu,
> +					dma, &user_pfn[i], ret, &phys_pfn[i], do_accounting);
> +			if (ret < 0)
> +				goto pin_unwind;
> +			contiguous_npage = ret;
>  		}
>  	}
>  	ret = i;


This all seems _way_ more complicated than it needs to be, there are
too many different ways to flow through this code and claims of a
performance improvement are not substantiated with evidence.  The type1
code is already too fragile.  Please simplify and justify.  Thanks,

Alex

