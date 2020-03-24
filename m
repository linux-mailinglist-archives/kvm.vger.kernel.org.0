Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1C2A191B46
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 21:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbgCXUpa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 16:45:30 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:34225 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727969AbgCXUp3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 16:45:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585082726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QkUK7ALJQH7LmlBExejAFxKUpSojd9B3auWcg0AJiHE=;
        b=J5lq17o1X7FqDFTTs2jL3eSTLdSQg268dvoyL+TqmJFL7E0O0MEcJAvkp+psgU3yyVMu2U
        JkRi85oy/8K47KMdl5KnBFTPg0ftX06NugByH+Qj5JRkQBpPq/b1AwM/bBiDDAl5HZEt6z
        ywdM2RXwcqkVDUvYrGqYEqv1KlW3WGM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-XYhadAsHMFiGs7CQQh7OMw-1; Tue, 24 Mar 2020 16:45:22 -0400
X-MC-Unique: XYhadAsHMFiGs7CQQh7OMw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 04204A1361;
        Tue, 24 Mar 2020 20:45:17 +0000 (UTC)
Received: from w520.home (ovpn-112-162.phx2.redhat.com [10.3.112.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9274F5DA87;
        Tue, 24 Mar 2020 20:45:07 +0000 (UTC)
Date:   Tue, 24 Mar 2020 14:45:07 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     <cjia@nvidia.com>, <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>, <cohuck@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <yan.y.zhao@intel.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v16 Kernel 4/7] vfio iommu: Implementation of ioctl for
 dirty pages tracking.
Message-ID: <20200324144507.5e11a50d@w520.home>
In-Reply-To: <20200324143716.64cf0cc9@w520.home>
References: <1585078359-20124-1-git-send-email-kwankhede@nvidia.com>
        <1585078359-20124-5-git-send-email-kwankhede@nvidia.com>
        <20200324143716.64cf0cc9@w520.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 24 Mar 2020 14:37:16 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Wed, 25 Mar 2020 01:02:36 +0530
> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> 
> > VFIO_IOMMU_DIRTY_PAGES ioctl performs three operations:
> > - Start dirty pages tracking while migration is active
> > - Stop dirty pages tracking.
> > - Get dirty pages bitmap. Its user space application's responsibility to
> >   copy content of dirty pages from source to destination during migration.
> > 
> > To prevent DoS attack, memory for bitmap is allocated per vfio_dma
> > structure. Bitmap size is calculated considering smallest supported page
> > size. Bitmap is allocated for all vfio_dmas when dirty logging is enabled
> > 
> > Bitmap is populated for already pinned pages when bitmap is allocated for
> > a vfio_dma with the smallest supported page size. Update bitmap from
> > pinning functions when tracking is enabled. When user application queries
> > bitmap, check if requested page size is same as page size used to
> > populated bitmap. If it is equal, copy bitmap, but if not equal, return
> > error.
> > 
> > Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> > Reviewed-by: Neo Jia <cjia@nvidia.com>
> > ---
> >  drivers/vfio/vfio_iommu_type1.c | 265 +++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 259 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > index 70aeab921d0f..27ed069c5053 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -71,6 +71,7 @@ struct vfio_iommu {
> >  	unsigned int		dma_avail;
> >  	bool			v2;
> >  	bool			nesting;
> > +	bool			dirty_page_tracking;
> >  };
> >  
> >  struct vfio_domain {
> > @@ -91,6 +92,7 @@ struct vfio_dma {
> >  	bool			lock_cap;	/* capable(CAP_IPC_LOCK) */
> >  	struct task_struct	*task;
> >  	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
> > +	unsigned long		*bitmap;
> >  };
> >  
> >  struct vfio_group {
> > @@ -125,7 +127,21 @@ struct vfio_regions {
> >  #define IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)	\
> >  					(!list_empty(&iommu->domain_list))
> >  
> > +#define DIRTY_BITMAP_BYTES(n)	(ALIGN(n, BITS_PER_TYPE(u64)) / BITS_PER_BYTE)
> > +
> > +/*
> > + * Input argument of number of bits to bitmap_set() is unsigned integer, which
> > + * further casts to signed integer for unaligned multi-bit operation,
> > + * __bitmap_set().
> > + * Then maximum bitmap size supported is 2^31 bits divided by 2^3 bits/byte,
> > + * that is 2^28 (256 MB) which maps to 2^31 * 2^12 = 2^43 (8TB) on 4K page
> > + * system.
> > + */
> > +#define DIRTY_BITMAP_PAGES_MAX	(uint64_t)(INT_MAX - 1)
> > +#define DIRTY_BITMAP_SIZE_MAX	 DIRTY_BITMAP_BYTES(DIRTY_BITMAP_PAGES_MAX)
> > +
> >  static int put_pfn(unsigned long pfn, int prot);
> > +static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu);
> >  
> >  /*
> >   * This code handles mapping and unmapping of user data buffers
> > @@ -175,6 +191,77 @@ static void vfio_unlink_dma(struct vfio_iommu *iommu, struct vfio_dma *old)
> >  	rb_erase(&old->node, &iommu->dma_list);
> >  }
> >  
> > +
> > +static int vfio_dma_bitmap_alloc(struct vfio_dma *dma, uint64_t pgsize)
> > +{
> > +	uint64_t npages = dma->size / pgsize;
> > +
> > +	if (npages > DIRTY_BITMAP_PAGES_MAX)
> > +		return -EINVAL;
> > +
> > +	dma->bitmap = kvzalloc(DIRTY_BITMAP_BYTES(npages), GFP_KERNEL);
> > +	if (!dma->bitmap)
> > +		return -ENOMEM;
> > +
> > +	return 0;
> > +}
> > +
> > +static void vfio_dma_bitmap_free(struct vfio_dma *dma)
> > +{
> > +	kfree(dma->bitmap);
> > +	dma->bitmap = NULL;
> > +}
> > +
> > +static void vfio_dma_populate_bitmap(struct vfio_dma *dma, uint64_t pgsize)
> > +{
> > +	struct rb_node *p;
> > +
> > +	if (RB_EMPTY_ROOT(&dma->pfn_list))
> > +		return;
> > +
> > +	for (p = rb_first(&dma->pfn_list); p; p = rb_next(p)) {
> > +		struct vfio_pfn *vpfn = rb_entry(p, struct vfio_pfn, node);
> > +
> > +		bitmap_set(dma->bitmap, (vpfn->iova - dma->iova) / pgsize, 1);
> > +	}
> > +}
> > +
> > +static int vfio_dma_bitmap_alloc_all(struct vfio_iommu *iommu, uint64_t pgsize)
> > +{
> > +	struct rb_node *n = rb_first(&iommu->dma_list);
> > +
> > +	for (; n; n = rb_next(n)) {
> > +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
> > +		int ret;
> > +
> > +		ret = vfio_dma_bitmap_alloc(dma, pgsize);
> > +		if (ret) {
> > +			struct rb_node *p = rb_prev(n);
> > +
> > +			for (; p; p = rb_prev(p)) {
> > +				struct vfio_dma *dma = rb_entry(n,
> > +							struct vfio_dma, node);
> > +
> > +				vfio_dma_bitmap_free(dma);
> > +			}
> > +			return ret;
> > +		}
> > +		vfio_dma_populate_bitmap(dma, pgsize);
> > +	}
> > +	return 0;
> > +}
> > +
> > +static void vfio_dma_bitmap_free_all(struct vfio_iommu *iommu)
> > +{
> > +	struct rb_node *n = rb_first(&iommu->dma_list);
> > +
> > +	for (; n; n = rb_next(n)) {
> > +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
> > +
> > +		vfio_dma_bitmap_free(dma);
> > +	}
> > +}
> > +
> >  /*
> >   * Helper Functions for host iova-pfn list
> >   */
> > @@ -567,6 +654,18 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
> >  			vfio_unpin_page_external(dma, iova, do_accounting);
> >  			goto pin_unwind;
> >  		}
> > +
> > +		if (iommu->dirty_page_tracking) {
> > +			unsigned long pgshift =
> > +					 __ffs(vfio_pgsize_bitmap(iommu));
> > +
> > +			/*
> > +			 * Bitmap populated with the smallest supported page
> > +			 * size
> > +			 */
> > +			bitmap_set(dma->bitmap,
> > +				   (vpfn->iova - dma->iova) >> pgshift, 1);
> > +		}
> >  	}
> >  
> >  	ret = i;
> > @@ -801,6 +900,7 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
> >  	vfio_unmap_unpin(iommu, dma, true);
> >  	vfio_unlink_dma(iommu, dma);
> >  	put_task_struct(dma->task);
> > +	vfio_dma_bitmap_free(dma);
> >  	kfree(dma);
> >  	iommu->dma_avail++;
> >  }
> > @@ -831,6 +931,56 @@ static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu)
> >  	return bitmap;
> >  }
> >  
> > +static int vfio_iova_dirty_bitmap(struct vfio_iommu *iommu, dma_addr_t iova,
> > +				  size_t size, uint64_t pgsize,
> > +				  u64 __user *bitmap)
> > +{
> > +	struct vfio_dma *dma;
> > +	unsigned long pgshift = __ffs(pgsize);
> > +	unsigned int npages, bitmap_size;
> > +
> > +	dma = vfio_find_dma(iommu, iova, 1);
> > +
> > +	if (!dma)
> > +		return -EINVAL;
> > +
> > +	if (dma->iova != iova || dma->size != size)
> > +		return -EINVAL;
> > +
> > +	npages = dma->size >> pgshift;
> > +	bitmap_size = DIRTY_BITMAP_BYTES(npages);
> > +
> > +	/* mark all pages dirty if all pages are pinned and mapped. */
> > +	if (dma->iommu_mapped)
> > +		bitmap_set(dma->bitmap, 0, npages);
> > +
> > +	if (copy_to_user((void __user *)bitmap, dma->bitmap, bitmap_size))
> > +		return -EFAULT;
> > +
> > +	/*
> > +	 * Re-populate bitmap to include all pinned pages which are considered
> > +	 * as dirty but exclude pages which are unpinned and pages which are
> > +	 * marked dirty by vfio_dma_rw()
> > +	 */
> > +	vfio_dma_populate_bitmap(dma, pgsize);  
> 
> vfio_dma_populate_bitmap() only sets bits, it doesn't clear them.
> Shouldn't we do a memset() zero before calling this?  Thanks,

Or a bitmap_clear() would be better given we use bitmap_set() above.
Thanks,

Alex

