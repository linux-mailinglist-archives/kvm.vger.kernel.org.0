Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACE992EFA27
	for <lists+kvm@lfdr.de>; Fri,  8 Jan 2021 22:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729679AbhAHVRV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jan 2021 16:17:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47977 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729330AbhAHVRV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 Jan 2021 16:17:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610140553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t/D4vuyOVHb3q+yISryrAJslLzlpYJ85K+7W8UnEhKk=;
        b=D0TcEdXtJqWtOIi3UxA1h1+26QuUQVyUnW1pcg26fNB4wGc38wc0N2Qs+KnxcmgCOYEwDF
        sckMH7nPUkVPOyekXMuBSVw7yW615pEf9X0ZPp9lxc8zS170XPyivAY7XRaKs21I9UYVG+
        J6y46wGGcBrJeRIVYpKY1pEH8pNZbOQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-gGTZSneDN2uQ7DCu6m0xGw-1; Fri, 08 Jan 2021 16:15:51 -0500
X-MC-Unique: gGTZSneDN2uQ7DCu6m0xGw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B389107ACE3;
        Fri,  8 Jan 2021 21:15:50 +0000 (UTC)
Received: from omen.home (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EE5B860D79;
        Fri,  8 Jan 2021 21:15:49 +0000 (UTC)
Date:   Fri, 8 Jan 2021 14:15:49 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH V1 4/5] vfio: VA suspend interface
Message-ID: <20210108141549.071608a4@omen.home>
In-Reply-To: <1609861013-129801-5-git-send-email-steven.sistare@oracle.com>
References: <1609861013-129801-1-git-send-email-steven.sistare@oracle.com>
        <1609861013-129801-5-git-send-email-steven.sistare@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  5 Jan 2021 07:36:52 -0800
Steve Sistare <steven.sistare@oracle.com> wrote:

> Add interfaces that allow the underlying memory object of an iova
> range to be mapped to a new host virtual address in the host process:
> 
>   - VFIO_DMA_UNMAP_FLAG_SUSPEND for VFIO_IOMMU_UNMAP_DMA
>   - VFIO_DMA_MAP_FLAG_RESUME flag for VFIO_IOMMU_MAP_DMA
>   - VFIO_SUSPEND extension for VFIO_CHECK_EXTENSION

Suspend and Resume can imply many things other than what's done here.
Should these be something more akin to INVALIDATE_VADDR and
REPLACE_VADDR?

> 
> The suspend interface blocks vfio translation of host virtual
> addresses in a range, but DMA to already-mapped pages continues.
> The resume interface records the new base VA and resumes translation.
> See comments in uapi/linux/vfio.h for more details.
> 
> This is a partial implementation.  Blocking is added in the next patch.
> 
> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 47 +++++++++++++++++++++++++++++++++++------
>  include/uapi/linux/vfio.h       | 16 ++++++++++++++
>  2 files changed, 57 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 3dc501d..2c164a6 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -92,6 +92,7 @@ struct vfio_dma {
>  	int			prot;		/* IOMMU_READ/WRITE */
>  	bool			iommu_mapped;
>  	bool			lock_cap;	/* capable(CAP_IPC_LOCK) */
> +	bool			suspended;

Is there a value we could use for vfio_dma.vaddr that would always be
considered invalid, ex. ULONG_MAX?  We'd need to decide if we want to
allow users to create mappings (mdev-only) using an initial invalid
vaddr.

>  	struct task_struct	*task;
>  	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
>  	unsigned long		*bitmap;
> @@ -1080,7 +1081,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>  	int ret = 0, retries = 0;
>  	unsigned long pgshift;
>  	dma_addr_t iova;
> -	unsigned long size;
> +	unsigned long size, consumed;

This could be scoped into the branch below.

>  
>  	mutex_lock(&iommu->lock);
>  
> @@ -1169,6 +1170,21 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>  		if (dma->task->mm != current->mm)
>  			break;
>  
> +		if (unmap->flags & VFIO_DMA_UNMAP_FLAG_SUSPEND) {
> +			if (dma->suspended) {
> +				ret = -EINVAL;
> +				goto unlock;
> +			}

This leaves us in a state where we marked some entries but not others.
We should either unwind or... what's the actual harm in skipping these?

> +			dma->suspended = true;
> +			consumed = dma->iova + dma->size - iova;
> +			if (consumed >= size)
> +				break;
> +			iova += consumed;
> +			size -= consumed;
> +			unmapped += dma->size;
> +			continue;
> +		}

This short-cuts the dirty bitmap flag, so we need to decide if it's
legal to call them together or we need to prevent it... Oh, I see
you've excluded them earlier below.

> +
>  		if (!RB_EMPTY_ROOT(&dma->pfn_list)) {
>  			struct vfio_iommu_type1_dma_unmap nb_unmap;
>  
> @@ -1307,6 +1323,7 @@ static bool vfio_iommu_iova_dma_valid(struct vfio_iommu *iommu,
>  static int vfio_dma_do_map(struct vfio_iommu *iommu,
>  			   struct vfio_iommu_type1_dma_map *map)
>  {
> +	bool resume = map->flags & VFIO_DMA_MAP_FLAG_RESUME;
>  	dma_addr_t iova = map->iova;
>  	unsigned long vaddr = map->vaddr;
>  	size_t size = map->size;
> @@ -1324,13 +1341,16 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>  	if (map->flags & VFIO_DMA_MAP_FLAG_READ)
>  		prot |= IOMMU_READ;
>  
> +	if ((prot && resume) || (!prot && !resume))
> +		return -EINVAL;
> +
>  	mutex_lock(&iommu->lock);
>  
>  	pgsize = (size_t)1 << __ffs(iommu->pgsize_bitmap);
>  
>  	WARN_ON((pgsize - 1) & PAGE_MASK);
>  
> -	if (!prot || !size || (size | iova | vaddr) & (pgsize - 1)) {
> +	if (!size || (size | iova | vaddr) & (pgsize - 1)) {
>  		ret = -EINVAL;
>  		goto out_unlock;
>  	}
> @@ -1341,7 +1361,19 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>  		goto out_unlock;
>  	}
>  
> -	if (vfio_find_dma(iommu, iova, size)) {
> +	dma = vfio_find_dma(iommu, iova, size);
> +	if (resume) {
> +		if (!dma) {
> +			ret = -ENOENT;
> +		} else if (!dma->suspended || dma->iova != iova ||
> +			   dma->size != size) {

Why is it necessary that the vfio_dma be suspended before being
resumed?  Couldn't a user simply use this to change the vaddr?  Does
that promote abusive use?

> +			ret = -EINVAL;
> +		} else {
> +			dma->vaddr = vaddr;

Seems like there's a huge opportunity for a user to create coherency
issues here... it's their data though I guess.

> +			dma->suspended = false;
> +		}
> +		goto out_unlock;
> +	} else if (dma) {
>  		ret = -EEXIST;
>  		goto out_unlock;
>  	}
> @@ -2532,6 +2564,7 @@ static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
>  	case VFIO_TYPE1_IOMMU:
>  	case VFIO_TYPE1v2_IOMMU:
>  	case VFIO_TYPE1_NESTING_IOMMU:
> +	case VFIO_SUSPEND:
>  		return 1;
>  	case VFIO_DMA_CC_IOMMU:
>  		if (!iommu)
> @@ -2686,7 +2719,8 @@ static int vfio_iommu_type1_map_dma(struct vfio_iommu *iommu,
>  {
>  	struct vfio_iommu_type1_dma_map map;
>  	unsigned long minsz;
> -	uint32_t mask = VFIO_DMA_MAP_FLAG_READ | VFIO_DMA_MAP_FLAG_WRITE;
> +	uint32_t mask = VFIO_DMA_MAP_FLAG_READ | VFIO_DMA_MAP_FLAG_WRITE |
> +			VFIO_DMA_MAP_FLAG_RESUME;
>  
>  	minsz = offsetofend(struct vfio_iommu_type1_dma_map, size);
>  
> @@ -2704,6 +2738,8 @@ static int vfio_iommu_type1_unmap_dma(struct vfio_iommu *iommu,
>  {
>  	struct vfio_iommu_type1_dma_unmap unmap;
>  	struct vfio_bitmap bitmap = { 0 };
> +	uint32_t mask = VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP |
> +			VFIO_DMA_UNMAP_FLAG_SUSPEND;
>  	unsigned long minsz;
>  	int ret;
>  
> @@ -2712,8 +2748,7 @@ static int vfio_iommu_type1_unmap_dma(struct vfio_iommu *iommu,
>  	if (copy_from_user(&unmap, (void __user *)arg, minsz))
>  		return -EFAULT;
>  
> -	if (unmap.argsz < minsz ||
> -	    unmap.flags & ~VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP)
> +	if (unmap.argsz < minsz || unmap.flags & ~mask || unmap.flags == mask)

Maybe a short comment here to note that dirty-bimap and
suspend/invalidate are mutually exclusive.  Probably should be
mentioned in the uapi too.

>  		return -EINVAL;
>  
>  	if (unmap.flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) {
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 896e527..fcf7b56 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -46,6 +46,9 @@
>   */
>  #define VFIO_NOIOMMU_IOMMU		8
>  
> +/* Supports VFIO DMA suspend and resume */
> +#define VFIO_SUSPEND			9
> +
>  /*
>   * The IOCTL interface is designed for extensibility by embedding the
>   * structure length (argsz) and flags into structures passed between
> @@ -1046,12 +1049,19 @@ struct vfio_iommu_type1_info_cap_migration {
>   *
>   * Map process virtual addresses to IO virtual addresses using the
>   * provided struct vfio_dma_map. Caller sets argsz. READ &/ WRITE required.
> + *
> + * If flags & VFIO_DMA_MAP_FLAG_RESUME, record the new base vaddr for iova, and
> + * resume translation of host virtual addresses in the iova range.  The new
> + * vaddr must point to the same memory object as the old vaddr, but this is not
> + * verified.

It's hard to use "must" terminology here if we're not going to check.
Maybe the phrasing should be something more along the lines of "should
point to the same memory object or the user risks coherency issues
within their virtual address space".

>  iova and size must match those in the original MAP_DMA call.
> + * Protection is not changed, and the READ & WRITE flags must be 0.

This doesn't mention that the entry must be previously
suspended/invalidated (if we choose to keep those semantics).  Thanks,

Alex

>   */
>  struct vfio_iommu_type1_dma_map {
>  	__u32	argsz;
>  	__u32	flags;
>  #define VFIO_DMA_MAP_FLAG_READ (1 << 0)		/* readable from device */
>  #define VFIO_DMA_MAP_FLAG_WRITE (1 << 1)	/* writable from device */
> +#define VFIO_DMA_MAP_FLAG_RESUME (1 << 2)
>  	__u64	vaddr;				/* Process virtual address */
>  	__u64	iova;				/* IO virtual address */
>  	__u64	size;				/* Size of mapping (bytes) */
> @@ -1084,11 +1094,17 @@ struct vfio_bitmap {
>   * indicates that the page at that offset from iova is dirty. A Bitmap of the
>   * pages in the range of unmapped size is returned in the user-provided
>   * vfio_bitmap.data.
> + *
> + * If flags & VFIO_DMA_UNMAP_FLAG_SUSPEND, do not unmap, but suspend vfio
> + * translation of host virtual addresses in the iova range.  During suspension,
> + * kernel threads that attempt to translate will block.  DMA to already-mapped
> + * pages continues.
>   */
>  struct vfio_iommu_type1_dma_unmap {
>  	__u32	argsz;
>  	__u32	flags;
>  #define VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP (1 << 0)
> +#define VFIO_DMA_UNMAP_FLAG_SUSPEND	     (1 << 1)
>  	__u64	iova;				/* IO virtual address */
>  	__u64	size;				/* Size of mapping (bytes) */
>  	__u8    data[];

