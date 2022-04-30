Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEAF9515A45
	for <lists+kvm@lfdr.de>; Sat, 30 Apr 2022 06:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240704AbiD3EPT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Apr 2022 00:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239650AbiD3EPR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Apr 2022 00:15:17 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B88742E6AC
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 21:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651291916; x=1682827916;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=M4ApWe30dZrJzIldBGr5eaJaZ5nwJjnAqUCAfnpMWSI=;
  b=VuF/HEL5Z9ogSaiZgPrB8Yk31CLRAvzsnUGjAHJy8TKsNzIMjvQfKo+8
   ABHXSXrRtX/3FavuaoyFqDziP/khCPbJgmCKNaAAPJ464SvFwfL0KS70K
   NogqV4+9M/kRtVfbOJAOCZp+cqXXzfzRl/dEDH8ek9DYaLi+URfZDk6jD
   WLdKkj33/5R5BBjPjOvTorxtNWM7NgU+cnEKH96jHXCh5pyNQaX2vPM41
   UrUIVR4exQSWJz6TniqZQs61nqbF9HJ3Rn/SCSzjBynD3QAqiHX1clTIX
   tccWWiHURfv1zTbLC644rxAh2hdIdnUIVIxOCMZsOOKlIC8i0Wf9D3nb4
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10332"; a="265680253"
X-IronPort-AV: E=Sophos;i="5.91,187,1647327600"; 
   d="scan'208";a="265680253"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 21:11:56 -0700
X-IronPort-AV: E=Sophos;i="5.91,187,1647327600"; 
   d="scan'208";a="582576210"
Received: from aliu1-mobl.ccr.corp.intel.com (HELO [10.255.30.71]) ([10.255.30.71])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 21:11:50 -0700
Message-ID: <d80b318d-278b-2592-8665-e5dec91f70e3@linux.intel.com>
Date:   Sat, 30 Apr 2022 12:11:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH RFC 03/19] iommufd: Dirty tracking data support
Content-Language: en-US
To:     Joao Martins <joao.m.martins@oracle.com>,
        iommu@lists.linux-foundation.org
Cc:     Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Yi Liu <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <20220428210933.3583-4-joao.m.martins@oracle.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20220428210933.3583-4-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/4/29 05:09, Joao Martins wrote:
> Add an IO pagetable API iopt_read_and_clear_dirty_data() that
> performs the reading of dirty IOPTEs for a given IOVA range and
> then copying back to userspace from each area-internal bitmap.
> 
> Underneath it uses the IOMMU equivalent API which will read the
> dirty bits, as well as atomically clearing the IOPTE dirty bit
> and flushing the IOTLB at the end. The dirty bitmaps pass an
> iotlb_gather to allow batching the dirty-bit updates.
> 
> Most of the complexity, though, is in the handling of the user
> bitmaps to avoid copies back and forth. The bitmap user addresses
> need to be iterated through, pinned and then passing the pages
> into iommu core. The amount of bitmap data passed at a time for a
> read_and_clear_dirty() is 1 page worth of pinned base page
> pointers. That equates to 16M bits, or rather 64G of data that
> can be returned as 'dirtied'. The flush the IOTLB at the end of
> the whole scanned IOVA range, to defer as much as possible the
> potential DMA performance penalty.
> 
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>   drivers/iommu/iommufd/io_pagetable.c    | 169 ++++++++++++++++++++++++
>   drivers/iommu/iommufd/iommufd_private.h |  44 ++++++
>   2 files changed, 213 insertions(+)
> 
> diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
> index f4609ef369e0..835b5040fce9 100644
> --- a/drivers/iommu/iommufd/io_pagetable.c
> +++ b/drivers/iommu/iommufd/io_pagetable.c
> @@ -14,6 +14,7 @@
>   #include <linux/err.h>
>   #include <linux/slab.h>
>   #include <linux/errno.h>
> +#include <uapi/linux/iommufd.h>
>   
>   #include "io_pagetable.h"
>   
> @@ -347,6 +348,174 @@ int iopt_set_dirty_tracking(struct io_pagetable *iopt,
>   	return ret;
>   }
>   
> +int iommufd_dirty_iter_init(struct iommufd_dirty_iter *iter,
> +			    struct iommufd_dirty_data *bitmap)
> +{
> +	struct iommu_dirty_bitmap *dirty = &iter->dirty;
> +	unsigned long bitmap_len;
> +
> +	bitmap_len = dirty_bitmap_bytes(bitmap->length >> dirty->pgshift);
> +
> +	import_single_range(WRITE, bitmap->data, bitmap_len,
> +			    &iter->bitmap_iov, &iter->bitmap_iter);
> +	iter->iova = bitmap->iova;
> +
> +	/* Can record up to 64G at a time */
> +	dirty->pages = (struct page **) __get_free_page(GFP_KERNEL);
> +
> +	return !dirty->pages ? -ENOMEM : 0;
> +}
> +
> +void iommufd_dirty_iter_free(struct iommufd_dirty_iter *iter)
> +{
> +	struct iommu_dirty_bitmap *dirty = &iter->dirty;
> +
> +	if (dirty->pages) {
> +		free_page((unsigned long) dirty->pages);
> +		dirty->pages = NULL;
> +	}
> +}
> +
> +bool iommufd_dirty_iter_done(struct iommufd_dirty_iter *iter)
> +{
> +	return iov_iter_count(&iter->bitmap_iter) > 0;
> +}
> +
> +static inline unsigned long iommufd_dirty_iter_bytes(struct iommufd_dirty_iter *iter)
> +{
> +	unsigned long left = iter->bitmap_iter.count - iter->bitmap_iter.iov_offset;
> +
> +	left = min_t(unsigned long, left, (iter->dirty.npages << PAGE_SHIFT));
> +
> +	return left;
> +}
> +
> +unsigned long iommufd_dirty_iova_length(struct iommufd_dirty_iter *iter)
> +{
> +	unsigned long left = iommufd_dirty_iter_bytes(iter);
> +
> +	return ((BITS_PER_BYTE * left) << iter->dirty.pgshift);
> +}
> +
> +unsigned long iommufd_dirty_iova(struct iommufd_dirty_iter *iter)
> +{
> +	unsigned long skip = iter->bitmap_iter.iov_offset;
> +
> +	return iter->iova + ((BITS_PER_BYTE * skip) << iter->dirty.pgshift);
> +}
> +
> +void iommufd_dirty_iter_advance(struct iommufd_dirty_iter *iter)
> +{
> +	iov_iter_advance(&iter->bitmap_iter, iommufd_dirty_iter_bytes(iter));
> +}
> +
> +void iommufd_dirty_iter_put(struct iommufd_dirty_iter *iter)
> +{
> +	struct iommu_dirty_bitmap *dirty = &iter->dirty;
> +
> +	if (dirty->npages)
> +		unpin_user_pages(dirty->pages, dirty->npages);
> +}
> +
> +int iommufd_dirty_iter_get(struct iommufd_dirty_iter *iter)
> +{
> +	struct iommu_dirty_bitmap *dirty = &iter->dirty;
> +	unsigned long npages;
> +	unsigned long ret;
> +	void *addr;
> +
> +	addr = iter->bitmap_iov.iov_base + iter->bitmap_iter.iov_offset;
> +	npages = iov_iter_npages(&iter->bitmap_iter,
> +				 PAGE_SIZE / sizeof(struct page *));
> +
> +	ret = pin_user_pages_fast((unsigned long) addr, npages,
> +				  FOLL_WRITE, dirty->pages);
> +	if (ret <= 0)
> +		return -EINVAL;
> +
> +	dirty->npages = ret;
> +	dirty->iova = iommufd_dirty_iova(iter);
> +	dirty->start_offset = offset_in_page(addr);
> +	return 0;
> +}
> +
> +static int iommu_read_and_clear_dirty(struct iommu_domain *domain,
> +				      struct iommufd_dirty_data *bitmap)

This looks more like a helper in the iommu core. How about

	iommufd_read_clear_domain_dirty()?

> +{
> +	const struct iommu_domain_ops *ops = domain->ops;
> +	struct iommu_iotlb_gather gather;
> +	struct iommufd_dirty_iter iter;
> +	int ret = 0;
> +
> +	if (!ops || !ops->read_and_clear_dirty)
> +		return -EOPNOTSUPP;
> +
> +	iommu_dirty_bitmap_init(&iter.dirty, bitmap->iova,
> +				__ffs(bitmap->page_size), &gather);
> +	ret = iommufd_dirty_iter_init(&iter, bitmap);
> +	if (ret)
> +		return -ENOMEM;
> +
> +	for (; iommufd_dirty_iter_done(&iter);
> +	     iommufd_dirty_iter_advance(&iter)) {
> +		ret = iommufd_dirty_iter_get(&iter);
> +		if (ret)
> +			break;
> +
> +		ret = ops->read_and_clear_dirty(domain,
> +			iommufd_dirty_iova(&iter),
> +			iommufd_dirty_iova_length(&iter), &iter.dirty);
> +
> +		iommufd_dirty_iter_put(&iter);
> +
> +		if (ret)
> +			break;
> +	}
> +
> +	iommu_iotlb_sync(domain, &gather);
> +	iommufd_dirty_iter_free(&iter);
> +
> +	return ret;
> +}
> +
> +int iopt_read_and_clear_dirty_data(struct io_pagetable *iopt,
> +				   struct iommu_domain *domain,
> +				   struct iommufd_dirty_data *bitmap)
> +{
> +	unsigned long iova, length, iova_end;
> +	struct iommu_domain *dom;
> +	struct iopt_area *area;
> +	unsigned long index;
> +	int ret = -EOPNOTSUPP;
> +
> +	iova = bitmap->iova;
> +	length = bitmap->length - 1;
> +	if (check_add_overflow(iova, length, &iova_end))
> +		return -EOVERFLOW;
> +
> +	down_read(&iopt->iova_rwsem);
> +	area = iopt_find_exact_area(iopt, iova, iova_end);
> +	if (!area) {
> +		up_read(&iopt->iova_rwsem);
> +		return -ENOENT;
> +	}
> +
> +	if (!domain) {
> +		down_read(&iopt->domains_rwsem);
> +		xa_for_each(&iopt->domains, index, dom) {
> +			ret = iommu_read_and_clear_dirty(dom, bitmap);

Perhaps use @domain directly, hence no need the @dom?

	xa_for_each(&iopt->domains, index, domain) {
		ret = iommu_read_and_clear_dirty(domain, bitmap);

> +			if (ret)
> +				break;
> +		}
> +		up_read(&iopt->domains_rwsem);
> +	} else {
> +		ret = iommu_read_and_clear_dirty(domain, bitmap);
> +	}
> +
> +	up_read(&iopt->iova_rwsem);
> +	return ret;
> +}
> +
>   struct iopt_pages *iopt_get_pages(struct io_pagetable *iopt, unsigned long iova,
>   				  unsigned long *start_byte,
>   				  unsigned long length)
> diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
> index d00ef3b785c5..4c12b4a8f1a6 100644
> --- a/drivers/iommu/iommufd/iommufd_private.h
> +++ b/drivers/iommu/iommufd/iommufd_private.h
> @@ -8,6 +8,8 @@
>   #include <linux/xarray.h>
>   #include <linux/refcount.h>
>   #include <linux/uaccess.h>
> +#include <linux/iommu.h>
> +#include <linux/uio.h>
>   
>   struct iommu_domain;
>   struct iommu_group;
> @@ -49,8 +51,50 @@ int iopt_unmap_iova(struct io_pagetable *iopt, unsigned long iova,
>   		    unsigned long length);
>   int iopt_unmap_all(struct io_pagetable *iopt);
>   
> +struct iommufd_dirty_data {
> +	unsigned long iova;
> +	unsigned long length;
> +	unsigned long page_size;
> +	unsigned long *data;
> +};

How about adding some comments around this struct? Any alingment
requirement for iova/length? What does the @data stand for?

> +
>   int iopt_set_dirty_tracking(struct io_pagetable *iopt,
>   			    struct iommu_domain *domain, bool enable);
> +int iopt_read_and_clear_dirty_data(struct io_pagetable *iopt,
> +				   struct iommu_domain *domain,
> +				   struct iommufd_dirty_data *bitmap);
> +
> +struct iommufd_dirty_iter {
> +	struct iommu_dirty_bitmap dirty;
> +	struct iovec bitmap_iov;
> +	struct iov_iter bitmap_iter;
> +	unsigned long iova;
> +};

Same here.

> +
> +void iommufd_dirty_iter_put(struct iommufd_dirty_iter *iter);
> +int iommufd_dirty_iter_get(struct iommufd_dirty_iter *iter);
> +int iommufd_dirty_iter_init(struct iommufd_dirty_iter *iter,
> +			    struct iommufd_dirty_data *bitmap);
> +void iommufd_dirty_iter_free(struct iommufd_dirty_iter *iter);
> +bool iommufd_dirty_iter_done(struct iommufd_dirty_iter *iter);
> +void iommufd_dirty_iter_advance(struct iommufd_dirty_iter *iter);
> +unsigned long iommufd_dirty_iova_length(struct iommufd_dirty_iter *iter);
> +unsigned long iommufd_dirty_iova(struct iommufd_dirty_iter *iter);
> +static inline unsigned long dirty_bitmap_bytes(unsigned long nr_pages)
> +{
> +	return (ALIGN(nr_pages, BITS_PER_TYPE(u64)) / BITS_PER_BYTE);
> +}
> +
> +/*
> + * Input argument of number of bits to bitmap_set() is unsigned integer, which
> + * further casts to signed integer for unaligned multi-bit operation,
> + * __bitmap_set().
> + * Then maximum bitmap size supported is 2^31 bits divided by 2^3 bits/byte,
> + * that is 2^28 (256 MB) which maps to 2^31 * 2^12 = 2^43 (8TB) on 4K page
> + * system.
> + */
> +#define DIRTY_BITMAP_PAGES_MAX  ((u64)INT_MAX)
> +#define DIRTY_BITMAP_SIZE_MAX   dirty_bitmap_bytes(DIRTY_BITMAP_PAGES_MAX)
>   
>   int iopt_access_pages(struct io_pagetable *iopt, unsigned long iova,
>   		      unsigned long npages, struct page **out_pages, bool write);

Best regards,
baolu
