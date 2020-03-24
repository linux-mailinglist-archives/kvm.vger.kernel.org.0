Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23B23191C37
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 22:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbgCXVsj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 17:48:39 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:6438 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728094AbgCXVsi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 17:48:38 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e7a80270000>; Tue, 24 Mar 2020 14:48:23 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 24 Mar 2020 14:48:37 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 24 Mar 2020 14:48:37 -0700
Received: from [10.40.103.72] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 24 Mar
 2020 21:48:28 +0000
Subject: Re: [PATCH v16 Kernel 4/7] vfio iommu: Implementation of ioctl for
 dirty pages tracking.
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <cjia@nvidia.com>, <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>, <cohuck@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <yan.y.zhao@intel.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
References: <1585078359-20124-1-git-send-email-kwankhede@nvidia.com>
 <1585078359-20124-5-git-send-email-kwankhede@nvidia.com>
 <20200324143716.64cf0cc9@w520.home> <20200324144507.5e11a50d@w520.home>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <983b1069-672d-765e-af55-bad42040fe61@nvidia.com>
Date:   Wed, 25 Mar 2020 03:18:24 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200324144507.5e11a50d@w520.home>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1585086503; bh=Tb7ziKzjnZl41wOQ3/A9qoE7rgyuhIprawayput8U7Q=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=W/vPTv4kxOMETGr1kQrAwcfMUQ7pEXj6jW9DMbw1xZ2wm1SQiO3w/8TpJ0H3YXyzL
         v7mHBvwX4tOS4SIQSKZdArFMfAJX0fsbD2Pr6jIIZUODYDfBmY63EFk3VUM2GjFLAz
         uBY5PYEBdTHk0ngXnctKj81YL4FzoFQCkc6gclI0DZ1HU9RDi1huXYB9qj7SnW27HY
         xF+he49HCOAXCuEywOhz1FIJcEprx0Z9Jfs7ovwXG0JpUVkGSPD+jHHlPRBepOozmC
         UpYh05un+JbvgYhO5anLqn1xk9lomfWz+mIcAZK0es0ktANHs99YFoh8Jw2HUqibWW
         rQQq8d2S0dj+Q==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/25/2020 2:15 AM, Alex Williamson wrote:
> On Tue, 24 Mar 2020 14:37:16 -0600
> Alex Williamson <alex.williamson@redhat.com> wrote:
> 
>> On Wed, 25 Mar 2020 01:02:36 +0530
>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
>>
>>> VFIO_IOMMU_DIRTY_PAGES ioctl performs three operations:
>>> - Start dirty pages tracking while migration is active
>>> - Stop dirty pages tracking.
>>> - Get dirty pages bitmap. Its user space application's responsibility to
>>>    copy content of dirty pages from source to destination during migration.
>>>
>>> To prevent DoS attack, memory for bitmap is allocated per vfio_dma
>>> structure. Bitmap size is calculated considering smallest supported page
>>> size. Bitmap is allocated for all vfio_dmas when dirty logging is enabled
>>>
>>> Bitmap is populated for already pinned pages when bitmap is allocated for
>>> a vfio_dma with the smallest supported page size. Update bitmap from
>>> pinning functions when tracking is enabled. When user application queries
>>> bitmap, check if requested page size is same as page size used to
>>> populated bitmap. If it is equal, copy bitmap, but if not equal, return
>>> error.
>>>
>>> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
>>> Reviewed-by: Neo Jia <cjia@nvidia.com>
>>> ---
>>>   drivers/vfio/vfio_iommu_type1.c | 265 +++++++++++++++++++++++++++++++++++++++-
>>>   1 file changed, 259 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>>> index 70aeab921d0f..27ed069c5053 100644
>>> --- a/drivers/vfio/vfio_iommu_type1.c
>>> +++ b/drivers/vfio/vfio_iommu_type1.c
>>> @@ -71,6 +71,7 @@ struct vfio_iommu {
>>>   	unsigned int		dma_avail;
>>>   	bool			v2;
>>>   	bool			nesting;
>>> +	bool			dirty_page_tracking;
>>>   };
>>>   
>>>   struct vfio_domain {
>>> @@ -91,6 +92,7 @@ struct vfio_dma {
>>>   	bool			lock_cap;	/* capable(CAP_IPC_LOCK) */
>>>   	struct task_struct	*task;
>>>   	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
>>> +	unsigned long		*bitmap;
>>>   };
>>>   
>>>   struct vfio_group {
>>> @@ -125,7 +127,21 @@ struct vfio_regions {
>>>   #define IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)	\
>>>   					(!list_empty(&iommu->domain_list))
>>>   
>>> +#define DIRTY_BITMAP_BYTES(n)	(ALIGN(n, BITS_PER_TYPE(u64)) / BITS_PER_BYTE)
>>> +
>>> +/*
>>> + * Input argument of number of bits to bitmap_set() is unsigned integer, which
>>> + * further casts to signed integer for unaligned multi-bit operation,
>>> + * __bitmap_set().
>>> + * Then maximum bitmap size supported is 2^31 bits divided by 2^3 bits/byte,
>>> + * that is 2^28 (256 MB) which maps to 2^31 * 2^12 = 2^43 (8TB) on 4K page
>>> + * system.
>>> + */
>>> +#define DIRTY_BITMAP_PAGES_MAX	(uint64_t)(INT_MAX - 1)
>>> +#define DIRTY_BITMAP_SIZE_MAX	 DIRTY_BITMAP_BYTES(DIRTY_BITMAP_PAGES_MAX)
>>> +
>>>   static int put_pfn(unsigned long pfn, int prot);
>>> +static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu);
>>>   
>>>   /*
>>>    * This code handles mapping and unmapping of user data buffers
>>> @@ -175,6 +191,77 @@ static void vfio_unlink_dma(struct vfio_iommu *iommu, struct vfio_dma *old)
>>>   	rb_erase(&old->node, &iommu->dma_list);
>>>   }
>>>   
>>> +
>>> +static int vfio_dma_bitmap_alloc(struct vfio_dma *dma, uint64_t pgsize)
>>> +{
>>> +	uint64_t npages = dma->size / pgsize;
>>> +
>>> +	if (npages > DIRTY_BITMAP_PAGES_MAX)
>>> +		return -EINVAL;
>>> +
>>> +	dma->bitmap = kvzalloc(DIRTY_BITMAP_BYTES(npages), GFP_KERNEL);
>>> +	if (!dma->bitmap)
>>> +		return -ENOMEM;
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static void vfio_dma_bitmap_free(struct vfio_dma *dma)
>>> +{
>>> +	kfree(dma->bitmap);
>>> +	dma->bitmap = NULL;
>>> +}
>>> +
>>> +static void vfio_dma_populate_bitmap(struct vfio_dma *dma, uint64_t pgsize)
>>> +{
>>> +	struct rb_node *p;
>>> +
>>> +	if (RB_EMPTY_ROOT(&dma->pfn_list))
>>> +		return;
>>> +
>>> +	for (p = rb_first(&dma->pfn_list); p; p = rb_next(p)) {
>>> +		struct vfio_pfn *vpfn = rb_entry(p, struct vfio_pfn, node);
>>> +
>>> +		bitmap_set(dma->bitmap, (vpfn->iova - dma->iova) / pgsize, 1);
>>> +	}
>>> +}
>>> +
>>> +static int vfio_dma_bitmap_alloc_all(struct vfio_iommu *iommu, uint64_t pgsize)
>>> +{
>>> +	struct rb_node *n = rb_first(&iommu->dma_list);
>>> +
>>> +	for (; n; n = rb_next(n)) {
>>> +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
>>> +		int ret;
>>> +
>>> +		ret = vfio_dma_bitmap_alloc(dma, pgsize);
>>> +		if (ret) {
>>> +			struct rb_node *p = rb_prev(n);
>>> +
>>> +			for (; p; p = rb_prev(p)) {
>>> +				struct vfio_dma *dma = rb_entry(n,
>>> +							struct vfio_dma, node);
>>> +
>>> +				vfio_dma_bitmap_free(dma);
>>> +			}
>>> +			return ret;
>>> +		}
>>> +		vfio_dma_populate_bitmap(dma, pgsize);
>>> +	}
>>> +	return 0;
>>> +}
>>> +
>>> +static void vfio_dma_bitmap_free_all(struct vfio_iommu *iommu)
>>> +{
>>> +	struct rb_node *n = rb_first(&iommu->dma_list);
>>> +
>>> +	for (; n; n = rb_next(n)) {
>>> +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
>>> +
>>> +		vfio_dma_bitmap_free(dma);
>>> +	}
>>> +}
>>> +
>>>   /*
>>>    * Helper Functions for host iova-pfn list
>>>    */
>>> @@ -567,6 +654,18 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>>>   			vfio_unpin_page_external(dma, iova, do_accounting);
>>>   			goto pin_unwind;
>>>   		}
>>> +
>>> +		if (iommu->dirty_page_tracking) {
>>> +			unsigned long pgshift =
>>> +					 __ffs(vfio_pgsize_bitmap(iommu));
>>> +
>>> +			/*
>>> +			 * Bitmap populated with the smallest supported page
>>> +			 * size
>>> +			 */
>>> +			bitmap_set(dma->bitmap,
>>> +				   (vpfn->iova - dma->iova) >> pgshift, 1);
>>> +		}
>>>   	}
>>>   
>>>   	ret = i;
>>> @@ -801,6 +900,7 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
>>>   	vfio_unmap_unpin(iommu, dma, true);
>>>   	vfio_unlink_dma(iommu, dma);
>>>   	put_task_struct(dma->task);
>>> +	vfio_dma_bitmap_free(dma);
>>>   	kfree(dma);
>>>   	iommu->dma_avail++;
>>>   }
>>> @@ -831,6 +931,56 @@ static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu)
>>>   	return bitmap;
>>>   }
>>>   
>>> +static int vfio_iova_dirty_bitmap(struct vfio_iommu *iommu, dma_addr_t iova,
>>> +				  size_t size, uint64_t pgsize,
>>> +				  u64 __user *bitmap)
>>> +{
>>> +	struct vfio_dma *dma;
>>> +	unsigned long pgshift = __ffs(pgsize);
>>> +	unsigned int npages, bitmap_size;
>>> +
>>> +	dma = vfio_find_dma(iommu, iova, 1);
>>> +
>>> +	if (!dma)
>>> +		return -EINVAL;
>>> +
>>> +	if (dma->iova != iova || dma->size != size)
>>> +		return -EINVAL;
>>> +
>>> +	npages = dma->size >> pgshift;
>>> +	bitmap_size = DIRTY_BITMAP_BYTES(npages);
>>> +
>>> +	/* mark all pages dirty if all pages are pinned and mapped. */
>>> +	if (dma->iommu_mapped)
>>> +		bitmap_set(dma->bitmap, 0, npages);
>>> +
>>> +	if (copy_to_user((void __user *)bitmap, dma->bitmap, bitmap_size))
>>> +		return -EFAULT;
>>> +
>>> +	/*
>>> +	 * Re-populate bitmap to include all pinned pages which are considered
>>> +	 * as dirty but exclude pages which are unpinned and pages which are
>>> +	 * marked dirty by vfio_dma_rw()
>>> +	 */
>>> +	vfio_dma_populate_bitmap(dma, pgsize);
>>
>> vfio_dma_populate_bitmap() only sets bits, it doesn't clear them.
>> Shouldn't we do a memset() zero before calling this?  Thanks,
> 
> Or a bitmap_clear() would be better given we use bitmap_set() above.
> Thanks,
> 

Oh, I missed clearing bitmap. Resending only this patch again.

Thanks,
Kirti
