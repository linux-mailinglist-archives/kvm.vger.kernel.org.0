Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B8E1D4C36
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 13:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbgEOLOx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 07:14:53 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:10247 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbgEOLOx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 May 2020 07:14:53 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ebe799f0000>; Fri, 15 May 2020 04:14:39 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 15 May 2020 04:14:51 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 15 May 2020 04:14:51 -0700
Received: from [10.40.103.94] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 15 May
 2020 11:14:42 +0000
Subject: Re: [PATCH Kernel v20 5/8] vfio iommu: Implementation of ioctl for
 dirty pages tracking
To:     Yan Zhao <yan.y.zhao@intel.com>
CC:     <alex.williamson@redhat.com>, <cjia@nvidia.com>,
        <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>, <cohuck@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <qemu-devel@nongnu.org>,
        <kvm@vger.kernel.org>
References: <1589488667-9683-1-git-send-email-kwankhede@nvidia.com>
 <1589488667-9683-6-git-send-email-kwankhede@nvidia.com>
 <20200515100553.GA5559@joy-OptiPlex-7040>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <be9ff834-04b5-56c2-b103-44eff794bd3a@nvidia.com>
Date:   Fri, 15 May 2020 16:44:38 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200515100553.GA5559@joy-OptiPlex-7040>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1589541279; bh=AxLkoD91ThjE1sV9zxJG0WI9ThGxWhCKmyTh0OnEYYY=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=gT7VKSrC/ag2vZBzQWCuoVK9nbql/Yxu+tHtAxvhYZaHG65v9oX/+3vgJl9lGpfQq
         b/K7+XMoqzdtXYx3QSjtbTV4/Tuww9K83hG1+Xffng1kM253BJvkT1rSfJCb25VCYn
         uOow5VxXQCgKA0w7G4GKOJ7BC0mwWdTBzUGre11UzGP9YKB/eFADcZ3V4y73D2CgyA
         TCuG1NiUWTCvAeCBTwOFoVmuSnN2upUG00HWrHEVgL3zU1xHErAcfnAk47OSwZUsht
         OFJgMw38GENpGZUtVnb/VaopIzsP6cUzQ41r0b70CG99tvfSgzuqUAA2KXON7VWJtT
         wxnAr/cAJKFOQ==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/15/2020 3:35 PM, Yan Zhao wrote:
> On Fri, May 15, 2020 at 02:07:44AM +0530, Kirti Wankhede wrote:
>> VFIO_IOMMU_DIRTY_PAGES ioctl performs three operations:
>> - Start dirty pages tracking while migration is active
>> - Stop dirty pages tracking.
>> - Get dirty pages bitmap. Its user space application's responsibility to
>>    copy content of dirty pages from source to destination during migration.
>>
>> To prevent DoS attack, memory for bitmap is allocated per vfio_dma
>> structure. Bitmap size is calculated considering smallest supported page
>> size. Bitmap is allocated for all vfio_dmas when dirty logging is enabled
>>
>> Bitmap is populated for already pinned pages when bitmap is allocated for
>> a vfio_dma with the smallest supported page size. Update bitmap from
>> pinning functions when tracking is enabled. When user application queries
>> bitmap, check if requested page size is same as page size used to
>> populated bitmap. If it is equal, copy bitmap, but if not equal, return
>> error.
>>
>> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
>> Reviewed-by: Neo Jia <cjia@nvidia.com>
>>
>> Fixed error reported by build bot by changing pgsize type from uint64_t
>> to size_t.
>> Reported-by: kbuild test robot <lkp@intel.com>
>> ---
>>   drivers/vfio/vfio_iommu_type1.c | 294 +++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 288 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index de17787ffece..b76d3b14abfd 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -72,6 +72,7 @@ struct vfio_iommu {
>>   	uint64_t		pgsize_bitmap;
>>   	bool			v2;
>>   	bool			nesting;
>> +	bool			dirty_page_tracking;
>>   };
>>   
>>   struct vfio_domain {
>> @@ -92,6 +93,7 @@ struct vfio_dma {
>>   	bool			lock_cap;	/* capable(CAP_IPC_LOCK) */
>>   	struct task_struct	*task;
>>   	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
>> +	unsigned long		*bitmap;
>>   };
>>   
>>   struct vfio_group {
>> @@ -126,6 +128,19 @@ struct vfio_regions {
>>   #define IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)	\
>>   					(!list_empty(&iommu->domain_list))
>>   
>> +#define DIRTY_BITMAP_BYTES(n)	(ALIGN(n, BITS_PER_TYPE(u64)) / BITS_PER_BYTE)
>> +
>> +/*
>> + * Input argument of number of bits to bitmap_set() is unsigned integer, which
>> + * further casts to signed integer for unaligned multi-bit operation,
>> + * __bitmap_set().
>> + * Then maximum bitmap size supported is 2^31 bits divided by 2^3 bits/byte,
>> + * that is 2^28 (256 MB) which maps to 2^31 * 2^12 = 2^43 (8TB) on 4K page
>> + * system.
>> + */
>> +#define DIRTY_BITMAP_PAGES_MAX	 ((u64)INT_MAX)
>> +#define DIRTY_BITMAP_SIZE_MAX	 DIRTY_BITMAP_BYTES(DIRTY_BITMAP_PAGES_MAX)
>> +
>>   static int put_pfn(unsigned long pfn, int prot);
>>   
>>   /*
>> @@ -176,6 +191,74 @@ static void vfio_unlink_dma(struct vfio_iommu *iommu, struct vfio_dma *old)
>>   	rb_erase(&old->node, &iommu->dma_list);
>>   }
>>   
>> +
>> +static int vfio_dma_bitmap_alloc(struct vfio_dma *dma, size_t pgsize)
>> +{
>> +	uint64_t npages = dma->size / pgsize;
>> +
>> +	if (npages > DIRTY_BITMAP_PAGES_MAX)
>> +		return -EINVAL;
>> +
>> +	dma->bitmap = kvzalloc(DIRTY_BITMAP_BYTES(npages), GFP_KERNEL);
>> +	if (!dma->bitmap)
>> +		return -ENOMEM;
>> +
>> +	return 0;
>> +}
>> +
>> +static void vfio_dma_bitmap_free(struct vfio_dma *dma)
>> +{
>> +	kfree(dma->bitmap);
>> +	dma->bitmap = NULL;
>> +}
>> +
>> +static void vfio_dma_populate_bitmap(struct vfio_dma *dma, size_t pgsize)
>> +{
>> +	struct rb_node *p;
>> +
>> +	for (p = rb_first(&dma->pfn_list); p; p = rb_next(p)) {
>> +		struct vfio_pfn *vpfn = rb_entry(p, struct vfio_pfn, node);
>> +
>> +		bitmap_set(dma->bitmap, (vpfn->iova - dma->iova) / pgsize, 1);
>> +	}
>> +}
>> +
>> +static int vfio_dma_bitmap_alloc_all(struct vfio_iommu *iommu, size_t pgsize)
>> +{
>> +	struct rb_node *n = rb_first(&iommu->dma_list);
>> +
>> +	for (; n; n = rb_next(n)) {
>> +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
>> +		int ret;
>> +
>> +		ret = vfio_dma_bitmap_alloc(dma, pgsize);
>> +		if (ret) {
>> +			struct rb_node *p = rb_prev(n);
>> +
>> +			for (; p; p = rb_prev(p)) {
>> +				struct vfio_dma *dma = rb_entry(n,
>> +							struct vfio_dma, node);
>> +
>> +				vfio_dma_bitmap_free(dma);
>> +			}
>> +			return ret;
>> +		}
>> +		vfio_dma_populate_bitmap(dma, pgsize);
>> +	}
>> +	return 0;
>> +}
>> +
>> +static void vfio_dma_bitmap_free_all(struct vfio_iommu *iommu)
>> +{
>> +	struct rb_node *n = rb_first(&iommu->dma_list);
>> +
>> +	for (; n; n = rb_next(n)) {
>> +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
>> +
>> +		vfio_dma_bitmap_free(dma);
>> +	}
>> +}
>> +
>>   /*
>>    * Helper Functions for host iova-pfn list
>>    */
>> @@ -568,6 +651,17 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>>   			vfio_unpin_page_external(dma, iova, do_accounting);
>>   			goto pin_unwind;
>>   		}
>> +
>> +		if (iommu->dirty_page_tracking) {
>> +			unsigned long pgshift = __ffs(iommu->pgsize_bitmap);
>> +
>> +			/*
>> +			 * Bitmap populated with the smallest supported page
>> +			 * size
>> +			 */
>> +			bitmap_set(dma->bitmap,
>> +				   (vpfn->iova - dma->iova) >> pgshift, 1);
>> +		}
>>   	}
>>   
>>   	ret = i;
>> @@ -802,6 +896,7 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
>>   	vfio_unmap_unpin(iommu, dma, true);
>>   	vfio_unlink_dma(iommu, dma);
>>   	put_task_struct(dma->task);
>> +	vfio_dma_bitmap_free(dma);
>>   	kfree(dma);
>>   	iommu->dma_avail++;
>>   }
>> @@ -829,6 +924,80 @@ static void vfio_pgsize_bitmap(struct vfio_iommu *iommu)
>>   	}
>>   }
>>   
>> +static int update_user_bitmap(u64 __user *bitmap, struct vfio_dma *dma,
>> +			      dma_addr_t base_iova, size_t pgsize)
>> +{
>> +	unsigned long pgshift = __ffs(pgsize);
>> +	unsigned long nbits = dma->size >> pgshift;
>> +	unsigned long bit_offset = (dma->iova - base_iova) >> pgshift;
>> +	unsigned long copy_offset = bit_offset / BITS_PER_LONG;
>> +	unsigned long shift = bit_offset % BITS_PER_LONG;
>> +	unsigned long leftover;
>> +
>> +	if (shift) {
>> +		bitmap_shift_left(dma->bitmap, dma->bitmap, shift,
>> +				  nbits + shift);
>> +
>> +		if (copy_from_user(&leftover, (u64 *)bitmap + copy_offset,
>> +				   sizeof(leftover)))
>> +			return -EFAULT;
>> +
>> +		bitmap_or(dma->bitmap, dma->bitmap, &leftover, shift);
>> +	}
>> +
>> +	if (copy_to_user((u64 *)bitmap + copy_offset, dma->bitmap,
>> +			 DIRTY_BITMAP_BYTES(nbits + shift)))
>> +		return -EFAULT;
>> +
>> +	return 0;
>> +}
>> +
>> +static int vfio_iova_dirty_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
>> +				  dma_addr_t iova, size_t size, size_t pgsize)
>> +{
>> +	struct vfio_dma *dma;
>> +	dma_addr_t i = iova, limit = iova + size;
>> +	unsigned long pgshift = __ffs(pgsize);
>> +	size_t sz = size;
>> +	int ret;
>> +
>> +	while ((dma = vfio_find_dma(iommu, i, sz))) {
> not quite get the logic here.
> if (i, i + size) is intersecting with (dma->iova, dma->iova + dma->size),
> and a dma is found here, why the whole bitmap is cleared and copied?
> 

This works with multiple but full vfio_dma, not intersects of vfio_dma, 
similar to unmap ioctl.

Thanks,
Kirti


> Thanks
> Yan
