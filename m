Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCC0307BD2
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 18:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbhA1RJQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 12:09:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60028 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232727AbhA1RIn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 12:08:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611853636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NFzrDLYKgnUywI7I3cXrKOjYk52IQWOzTPnnmON6qPI=;
        b=GJ7Cry4DchA744Rl0RhK65XNOZtzYZ3b5AOlQ9WgTz8Ya1uAAcbTxxBO9w9Uu0615Yz06f
        iR3vuhI85aCtaqniuvOTb4DIT8CFdr1LLE5iZR2uSKWa1odv033knI4NebJs+yDpMrKmSB
        2G1HySeY9lxPXvdYV8Z81XdB7shxRow=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-nPSfyMx2MJiiIaGL044xLg-1; Thu, 28 Jan 2021 12:07:12 -0500
X-MC-Unique: nPSfyMx2MJiiIaGL044xLg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3AF161005D5A;
        Thu, 28 Jan 2021 17:07:10 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 99A121007637;
        Thu, 28 Jan 2021 17:07:09 +0000 (UTC)
Date:   Thu, 28 Jan 2021 10:07:09 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Steven Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH V2 9/9] vfio/type1: block on invalid vaddr
Message-ID: <20210128100709.5e4e7bed@omen.home.shazbot.org>
In-Reply-To: <20210127170325.0967e16c@omen.home.shazbot.org>
References: <1611078509-181959-1-git-send-email-steven.sistare@oracle.com>
        <1611078509-181959-10-git-send-email-steven.sistare@oracle.com>
        <20210122155946.3f42dfc9@omen.home.shazbot.org>
        <2df4d9b2-e668-788d-7c2c-8c27199a0818@oracle.com>
        <20210127170325.0967e16c@omen.home.shazbot.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 27 Jan 2021 17:03:25 -0700
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Wed, 27 Jan 2021 18:25:13 -0500
> Steven Sistare <steven.sistare@oracle.com> wrote:
> 
> > On 1/22/2021 5:59 PM, Alex Williamson wrote:  
> > > On Tue, 19 Jan 2021 09:48:29 -0800
> > > Steve Sistare <steven.sistare@oracle.com> wrote:
> > >     
> > >> Block translation of host virtual address while an iova range has an
> > >> invalid vaddr.
> > >>
> > >> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> > >> ---
> > >>  drivers/vfio/vfio_iommu_type1.c | 83 +++++++++++++++++++++++++++++++++++++----
> > >>  1 file changed, 76 insertions(+), 7 deletions(-)
> > >>
> > >> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > >> index 0167996..c97573a 100644
> > >> --- a/drivers/vfio/vfio_iommu_type1.c
> > >> +++ b/drivers/vfio/vfio_iommu_type1.c
> > >> @@ -31,6 +31,7 @@
> > >>  #include <linux/rbtree.h>
> > >>  #include <linux/sched/signal.h>
> > >>  #include <linux/sched/mm.h>
> > >> +#include <linux/kthread.h>
> > >>  #include <linux/slab.h>
> > >>  #include <linux/uaccess.h>
> > >>  #include <linux/vfio.h>
> > >> @@ -75,6 +76,7 @@ struct vfio_iommu {
> > >>  	bool			dirty_page_tracking;
> > >>  	bool			pinned_page_dirty_scope;
> > >>  	bool			controlled;
> > >> +	wait_queue_head_t	vaddr_wait;
> > >>  };
> > >>  
> > >>  struct vfio_domain {
> > >> @@ -145,6 +147,8 @@ struct vfio_regions {
> > >>  #define DIRTY_BITMAP_PAGES_MAX	 ((u64)INT_MAX)
> > >>  #define DIRTY_BITMAP_SIZE_MAX	 DIRTY_BITMAP_BYTES(DIRTY_BITMAP_PAGES_MAX)
> > >>  
> > >> +#define WAITED 1
> > >> +
> > >>  static int put_pfn(unsigned long pfn, int prot);
> > >>  
> > >>  static struct vfio_group *vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
> > >> @@ -505,6 +509,52 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
> > >>  }
> > >>  
> > >>  /*
> > >> + * Wait for vaddr of *dma_p to become valid.  iommu lock is dropped if the task
> > >> + * waits, but is re-locked on return.  If the task waits, then return an updated
> > >> + * dma struct in *dma_p.  Return 0 on success with no waiting, 1 on success if    
> > > 
> > > s/1/WAITED/    
> > 
> > OK, but the WAITED state will not need to be returned in the new scheme below.
> >   
> > >> + * waited, and -errno on error.
> > >> + */
> > >> +static int vfio_vaddr_wait(struct vfio_iommu *iommu, struct vfio_dma **dma_p)
> > >> +{
> > >> +	struct vfio_dma *dma = *dma_p;
> > >> +	unsigned long iova = dma->iova;
> > >> +	size_t size = dma->size;
> > >> +	int ret = 0;
> > >> +	DEFINE_WAIT(wait);
> > >> +
> > >> +	while (!dma->vaddr_valid) {
> > >> +		ret = WAITED;
> > >> +		prepare_to_wait(&iommu->vaddr_wait, &wait, TASK_KILLABLE);
> > >> +		mutex_unlock(&iommu->lock);
> > >> +		schedule();
> > >> +		mutex_lock(&iommu->lock);
> > >> +		finish_wait(&iommu->vaddr_wait, &wait);
> > >> +		if (kthread_should_stop() || !iommu->controlled ||
> > >> +		    fatal_signal_pending(current)) {
> > >> +			return -EFAULT;
> > >> +		}
> > >> +		*dma_p = dma = vfio_find_dma(iommu, iova, size);
> > >> +		if (!dma)
> > >> +			return -EINVAL;
> > >> +	}
> > >> +	return ret;
> > >> +}
> > >> +
> > >> +/*
> > >> + * Find dma struct and wait for its vaddr to be valid.  iommu lock is dropped
> > >> + * if the task waits, but is re-locked on return.  Return result in *dma_p.
> > >> + * Return 0 on success, 1 on success if waited,  and -errno on error.
> > >> + */
> > >> +static int vfio_find_vaddr(struct vfio_iommu *iommu, dma_addr_t start,
> > >> +			   size_t size, struct vfio_dma **dma_p)    
> > > 
> > > more of a vfio_find_dma_valid()    
> > 
> > I will slightly modify and rename this with the new scheme I describe below.
> >   
> > >> +{
> > >> +	*dma_p = vfio_find_dma(iommu, start, size);
> > >> +	if (!*dma_p)
> > >> +		return -EINVAL;
> > >> +	return vfio_vaddr_wait(iommu, dma_p);
> > >> +}
> > >> +
> > >> +/*
> > >>   * Attempt to pin pages.  We really don't want to track all the pfns and
> > >>   * the iommu can only map chunks of consecutive pfns anyway, so get the
> > >>   * first page and all consecutive pages with the same locking.
> > >> @@ -693,11 +743,11 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
> > >>  		struct vfio_pfn *vpfn;
> > >>  
> > >>  		iova = user_pfn[i] << PAGE_SHIFT;
> > >> -		dma = vfio_find_dma(iommu, iova, PAGE_SIZE);
> > >> -		if (!dma) {
> > >> -			ret = -EINVAL;
> > >> +		ret = vfio_find_vaddr(iommu, iova, PAGE_SIZE, &dma);
> > >> +		if (ret < 0)
> > >>  			goto pin_unwind;
> > >> -		}
> > >> +		else if (ret == WAITED)
> > >> +			do_accounting = !IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu);    
> > > 
> > > We're iterating through an array of pfns to provide translations, once
> > > we've released the lock it's not just the current one that could be
> > > invalid.  I'm afraid we need to unwind and try again, but I think it's
> > > actually worse than that because if we've marked pages within a
> > > vfio_dma's pfn_list as pinned, then during the locking gap it gets
> > > unmapped, the unmap path will call the unmap notifier chain to release
> > > the page that the vendor driver doesn't have yet.  Yikes!    
> > 
> > Yikes indeed.  The fix is easy, though.  I will maintain a count in vfio_iommu of 
> > vfio_dma objects with invalid vaddr's, modified and tested while holding the lock, 
> > provide a function to wait for the count to become 0, and call that function at the 
> > start of vfio_iommu_type1_pin_pages and vfio_iommu_replay.  I will use iommu->vaddr_wait 
> > for wait and wake.  
> 
> I prefer the overhead of this, but the resulting behavior seems pretty
> non-intuitive.  Any invalidated vaddr blocks all vaddr use cases, which
> almost suggests the unmap _VADDR flag should only be allowed with the
> _ALL flag, but then the map _VADDR flag can only be per mapping, which
> would make accounting and recovering from _VADDR + _ALL pretty
> complicated.  Thanks,

I wonder if there's a hybrid approach, a counter on the vfio_iommu
which when non-zero causes pin pages to pre-test vaddr on all required
vfio_dma objects, waiting and being woken on counter decrement to check
again.  Thanks,

Alex

> > >>  		if ((dma->prot & prot) != prot) {
> > >>  			ret = -EPERM;
> > >> @@ -1496,6 +1546,22 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
> > >>  	unsigned long limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
> > >>  	int ret;
> > >>  
> > >> +	/*
> > >> +	 * Wait for all vaddr to be valid so they can be used in the main loop.
> > >> +	 * If we do wait, the lock was dropped and re-taken, so start over to
> > >> +	 * ensure the dma list is consistent.
> > >> +	 */
> > >> +again:
> > >> +	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
> > >> +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
> > >> +
> > >> +		ret = vfio_vaddr_wait(iommu, &dma);
> > >> +		if (ret < 0)
> > >> +			return ret;
> > >> +		else if (ret == WAITED)
> > >> +			goto again;
> > >> +	}    
> > > 
> > > This "do nothing until all the vaddrs are valid" approach could work
> > > above too, but gosh is that a lot of cache unfriendly work for a rare
> > > invalidation.  Thanks,    
> > 
> > The new wait function described above is fast in the common case, just a check that
> > the invalid vaddr count is 0.
> > 
> > - Steve
> >   
> > >> +
> > >>  	/* Arbitrarily pick the first domain in the list for lookups */
> > >>  	if (!list_empty(&iommu->domain_list))
> > >>  		d = list_first_entry(&iommu->domain_list,
> > >> @@ -2522,6 +2588,7 @@ static void *vfio_iommu_type1_open(unsigned long arg)
> > >>  	iommu->controlled = true;
> > >>  	mutex_init(&iommu->lock);
> > >>  	BLOCKING_INIT_NOTIFIER_HEAD(&iommu->notifier);
> > >> +	init_waitqueue_head(&iommu->vaddr_wait);
> > >>  
> > >>  	return iommu;
> > >>  }
> > >> @@ -2972,12 +3039,13 @@ static int vfio_iommu_type1_dma_rw_chunk(struct vfio_iommu *iommu,
> > >>  	struct vfio_dma *dma;
> > >>  	bool kthread = current->mm == NULL;
> > >>  	size_t offset;
> > >> +	int ret;
> > >>  
> > >>  	*copied = 0;
> > >>  
> > >> -	dma = vfio_find_dma(iommu, user_iova, 1);
> > >> -	if (!dma)
> > >> -		return -EINVAL;
> > >> +	ret = vfio_find_vaddr(iommu, user_iova, 1, &dma);
> > >> +	if (ret < 0)
> > >> +		return ret;
> > >>  
> > >>  	if ((write && !(dma->prot & IOMMU_WRITE)) ||
> > >>  			!(dma->prot & IOMMU_READ))
> > >> @@ -3055,6 +3123,7 @@ static void vfio_iommu_type1_notify(void *iommu_data, unsigned int event,
> > >>  	mutex_lock(&iommu->lock);
> > >>  	iommu->controlled = false;
> > >>  	mutex_unlock(&iommu->lock);
> > >> +	wake_up_all(&iommu->vaddr_wait);
> > >>  }
> > >>  
> > >>  static const struct vfio_iommu_driver_ops vfio_iommu_driver_ops_type1 = {    
> > >     
> >   
> 

