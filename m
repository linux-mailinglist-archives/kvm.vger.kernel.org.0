Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D48AC30108F
	for <lists+kvm@lfdr.de>; Sat, 23 Jan 2021 00:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729251AbhAVXCd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 18:02:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54200 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729019AbhAVXBV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Jan 2021 18:01:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611356390;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mbzmyHu5WBYgXnqIwORCLP8ohuBfwekPMeaSA9ikw1w=;
        b=erh5hftOibVpcjjznqytaJcrMkCku+B8j33d/Kq2WBMLUV5Rsfvjag+gIQVePQVQj9U3in
        KK/sLg8cld08FS9cAFc5bh6OaeDRCnTlsyenDFL2o1l156sjLXhUzK/F6toDRrLv5eK7Mr
        hhgfnb/nsL8xr1++ac6aBVNDrDYcgIY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-462-ADxk3OV-OROhcYp5dBcM0A-1; Fri, 22 Jan 2021 17:59:49 -0500
X-MC-Unique: ADxk3OV-OROhcYp5dBcM0A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1B8CE3938D;
        Fri, 22 Jan 2021 22:59:48 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD4B75C232;
        Fri, 22 Jan 2021 22:59:47 +0000 (UTC)
Date:   Fri, 22 Jan 2021 15:59:46 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH V2 9/9] vfio/type1: block on invalid vaddr
Message-ID: <20210122155946.3f42dfc9@omen.home.shazbot.org>
In-Reply-To: <1611078509-181959-10-git-send-email-steven.sistare@oracle.com>
References: <1611078509-181959-1-git-send-email-steven.sistare@oracle.com>
        <1611078509-181959-10-git-send-email-steven.sistare@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 19 Jan 2021 09:48:29 -0800
Steve Sistare <steven.sistare@oracle.com> wrote:

> Block translation of host virtual address while an iova range has an
> invalid vaddr.
> 
> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 83 +++++++++++++++++++++++++++++++++++++----
>  1 file changed, 76 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 0167996..c97573a 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -31,6 +31,7 @@
>  #include <linux/rbtree.h>
>  #include <linux/sched/signal.h>
>  #include <linux/sched/mm.h>
> +#include <linux/kthread.h>
>  #include <linux/slab.h>
>  #include <linux/uaccess.h>
>  #include <linux/vfio.h>
> @@ -75,6 +76,7 @@ struct vfio_iommu {
>  	bool			dirty_page_tracking;
>  	bool			pinned_page_dirty_scope;
>  	bool			controlled;
> +	wait_queue_head_t	vaddr_wait;
>  };
>  
>  struct vfio_domain {
> @@ -145,6 +147,8 @@ struct vfio_regions {
>  #define DIRTY_BITMAP_PAGES_MAX	 ((u64)INT_MAX)
>  #define DIRTY_BITMAP_SIZE_MAX	 DIRTY_BITMAP_BYTES(DIRTY_BITMAP_PAGES_MAX)
>  
> +#define WAITED 1
> +
>  static int put_pfn(unsigned long pfn, int prot);
>  
>  static struct vfio_group *vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
> @@ -505,6 +509,52 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
>  }
>  
>  /*
> + * Wait for vaddr of *dma_p to become valid.  iommu lock is dropped if the task
> + * waits, but is re-locked on return.  If the task waits, then return an updated
> + * dma struct in *dma_p.  Return 0 on success with no waiting, 1 on success if

s/1/WAITED/

> + * waited, and -errno on error.
> + */
> +static int vfio_vaddr_wait(struct vfio_iommu *iommu, struct vfio_dma **dma_p)
> +{
> +	struct vfio_dma *dma = *dma_p;
> +	unsigned long iova = dma->iova;
> +	size_t size = dma->size;
> +	int ret = 0;
> +	DEFINE_WAIT(wait);
> +
> +	while (!dma->vaddr_valid) {
> +		ret = WAITED;
> +		prepare_to_wait(&iommu->vaddr_wait, &wait, TASK_KILLABLE);
> +		mutex_unlock(&iommu->lock);
> +		schedule();
> +		mutex_lock(&iommu->lock);
> +		finish_wait(&iommu->vaddr_wait, &wait);
> +		if (kthread_should_stop() || !iommu->controlled ||
> +		    fatal_signal_pending(current)) {
> +			return -EFAULT;
> +		}
> +		*dma_p = dma = vfio_find_dma(iommu, iova, size);
> +		if (!dma)
> +			return -EINVAL;
> +	}
> +	return ret;
> +}
> +
> +/*
> + * Find dma struct and wait for its vaddr to be valid.  iommu lock is dropped
> + * if the task waits, but is re-locked on return.  Return result in *dma_p.
> + * Return 0 on success, 1 on success if waited,  and -errno on error.
> + */
> +static int vfio_find_vaddr(struct vfio_iommu *iommu, dma_addr_t start,
> +			   size_t size, struct vfio_dma **dma_p)

more of a vfio_find_dma_valid()

> +{
> +	*dma_p = vfio_find_dma(iommu, start, size);
> +	if (!*dma_p)
> +		return -EINVAL;
> +	return vfio_vaddr_wait(iommu, dma_p);
> +}
> +
> +/*
>   * Attempt to pin pages.  We really don't want to track all the pfns and
>   * the iommu can only map chunks of consecutive pfns anyway, so get the
>   * first page and all consecutive pages with the same locking.
> @@ -693,11 +743,11 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>  		struct vfio_pfn *vpfn;
>  
>  		iova = user_pfn[i] << PAGE_SHIFT;
> -		dma = vfio_find_dma(iommu, iova, PAGE_SIZE);
> -		if (!dma) {
> -			ret = -EINVAL;
> +		ret = vfio_find_vaddr(iommu, iova, PAGE_SIZE, &dma);
> +		if (ret < 0)
>  			goto pin_unwind;
> -		}
> +		else if (ret == WAITED)
> +			do_accounting = !IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu);

We're iterating through an array of pfns to provide translations, once
we've released the lock it's not just the current one that could be
invalid.  I'm afraid we need to unwind and try again, but I think it's
actually worse than that because if we've marked pages within a
vfio_dma's pfn_list as pinned, then during the locking gap it gets
unmapped, the unmap path will call the unmap notifier chain to release
the page that the vendor driver doesn't have yet.  Yikes!

>  
>  		if ((dma->prot & prot) != prot) {
>  			ret = -EPERM;
> @@ -1496,6 +1546,22 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
>  	unsigned long limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
>  	int ret;
>  
> +	/*
> +	 * Wait for all vaddr to be valid so they can be used in the main loop.
> +	 * If we do wait, the lock was dropped and re-taken, so start over to
> +	 * ensure the dma list is consistent.
> +	 */
> +again:
> +	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
> +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
> +
> +		ret = vfio_vaddr_wait(iommu, &dma);
> +		if (ret < 0)
> +			return ret;
> +		else if (ret == WAITED)
> +			goto again;
> +	}

This "do nothing until all the vaddrs are valid" approach could work
above too, but gosh is that a lot of cache unfriendly work for a rare
invalidation.  Thanks,

Alex

> +
>  	/* Arbitrarily pick the first domain in the list for lookups */
>  	if (!list_empty(&iommu->domain_list))
>  		d = list_first_entry(&iommu->domain_list,
> @@ -2522,6 +2588,7 @@ static void *vfio_iommu_type1_open(unsigned long arg)
>  	iommu->controlled = true;
>  	mutex_init(&iommu->lock);
>  	BLOCKING_INIT_NOTIFIER_HEAD(&iommu->notifier);
> +	init_waitqueue_head(&iommu->vaddr_wait);
>  
>  	return iommu;
>  }
> @@ -2972,12 +3039,13 @@ static int vfio_iommu_type1_dma_rw_chunk(struct vfio_iommu *iommu,
>  	struct vfio_dma *dma;
>  	bool kthread = current->mm == NULL;
>  	size_t offset;
> +	int ret;
>  
>  	*copied = 0;
>  
> -	dma = vfio_find_dma(iommu, user_iova, 1);
> -	if (!dma)
> -		return -EINVAL;
> +	ret = vfio_find_vaddr(iommu, user_iova, 1, &dma);
> +	if (ret < 0)
> +		return ret;
>  
>  	if ((write && !(dma->prot & IOMMU_WRITE)) ||
>  			!(dma->prot & IOMMU_READ))
> @@ -3055,6 +3123,7 @@ static void vfio_iommu_type1_notify(void *iommu_data, unsigned int event,
>  	mutex_lock(&iommu->lock);
>  	iommu->controlled = false;
>  	mutex_unlock(&iommu->lock);
> +	wake_up_all(&iommu->vaddr_wait);
>  }
>  
>  static const struct vfio_iommu_driver_ops vfio_iommu_driver_ops_type1 = {

