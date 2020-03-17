Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7640188D1F
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 19:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgCQS2p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 14:28:45 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:18684 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbgCQS2p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 14:28:45 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e71167b0000>; Tue, 17 Mar 2020 11:27:07 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 17 Mar 2020 11:28:43 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 17 Mar 2020 11:28:43 -0700
Received: from [10.40.102.54] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 17 Mar
 2020 18:28:35 +0000
Subject: Re: [PATCH v13 Kernel 5/7] vfio iommu: Update UNMAP_DMA ioctl to get
 dirty bitmap before unmap
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
References: <1584035607-23166-1-git-send-email-kwankhede@nvidia.com>
 <1584035607-23166-6-git-send-email-kwankhede@nvidia.com>
 <20200313124529.402e01c3@x1.home>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <b6618d95-507c-a96e-c6b0-62e1a1d86e59@nvidia.com>
Date:   Tue, 17 Mar 2020 23:58:31 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200313124529.402e01c3@x1.home>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1584469627; bh=HREQZr6FyeV/Qwt/xRIYsi7cDMQLuJFhTQG07dd+dz8=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=LIaGkFKR7GZitM/8r6Hnvrq2fRu3r+Tcwmu80XVW8xJciHt7S7FzJyjtpgFnLLggI
         nV4WFEk6ACsn3CsdIF7f5BRdFl1N5LhggW0ip8g5g2jftSIwxkKLxEVTCj/1gp+/Uo
         Z3oq2WEocb5EZcGPTV7o78qRDhh98/YySRqnCrZ1yJ7fDDu1DU0gBO2/dtUf3TaSzM
         qtVa5/WiJWveA52J37vtqhcgmxRBC4q3+PAA7iUMBOX5QiaFIUjL5Pr6L6L9tFIg6f
         70un9NJE5p2XH0FE5v+8oIA12ClbDRLKXe0dtnp1ndI4rIjY2wtscEcjsNX4FDMkWg
         9tcJWZwM0Y28g==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/14/2020 12:15 AM, Alex Williamson wrote:
> On Thu, 12 Mar 2020 23:23:25 +0530
> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> 
>> Pages, pinned by external interface for requested IO virtual address
>> range,  might get unpinned  and unmapped while migration is active and
> 
> "DMA mapped pages, including those pinned by mdev vendor drivers, might
> get..."
> 
>> device is still running, that is, in pre-copy phase while guest driver
> 
> "...running.  For example, in pre-copy..."
> 
>> still could access those pages. Host device can write to these pages while
>> those were mapped.
> 
> "...those pages, host device or vendor driver can dirty these mapped
> pages."
> 
>> Such pages should be marked dirty so that after
>> migration guest driver should still be able to complete the operation.
> 
> Complete what operation?  

For whatever operation guest driver was using that memory for.

> We need to report these dirty pages in order
> to maintain memory consistency for a user making use of dirty page
> tracking.
> 
>> To get bitmap during unmap, user should set flag
>> VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP, bitmap memory should be allocated and
>> zeroed by user space application. Bitmap size and page size should be set
>> by user application.
> 
> It seems like zeroed pages are no longer strictly necessary now that we
> require requests to match existing mappings, right?
> 

Right.

>> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
>> Reviewed-by: Neo Jia <cjia@nvidia.com>
>> ---
>>   drivers/vfio/vfio_iommu_type1.c | 63 +++++++++++++++++++++++++++++++++++++----
>>   include/uapi/linux/vfio.h       | 12 ++++++++
>>   2 files changed, 70 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 435e84269a28..4037b82c6db0 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -976,7 +976,8 @@ static int verify_bitmap_size(unsigned long npages, unsigned long bitmap_size)
>>   }
>>   
>>   static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>> -			     struct vfio_iommu_type1_dma_unmap *unmap)
>> +			     struct vfio_iommu_type1_dma_unmap *unmap,
>> +			     unsigned long *bitmap)
>>   {
>>   	uint64_t mask;
>>   	struct vfio_dma *dma, *dma_last = NULL;
>> @@ -1027,6 +1028,10 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>   	 * will be returned if these conditions are not met.  The v2 interface
>>   	 * will only return success and a size of zero if there were no
>>   	 * mappings within the range.
>> +	 *
>> +	 * When VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP flag is set, unmap request
>> +	 * must be for single mapping. Multiple mappings with this flag set is
>> +	 * not supported.
>>   	 */
>>   	if (iommu->v2) {
>>   		dma = vfio_find_dma(iommu, unmap->iova, 1);
>> @@ -1034,6 +1039,13 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>   			ret = -EINVAL;
>>   			goto unlock;
>>   		}
>> +
>> +		if ((unmap->flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) &&
>> +		    (dma->iova != unmap->iova || dma->size != unmap->size)) {
>> +			ret = -EINVAL;
>> +			goto unlock;
>> +		}
>> +
>>   		dma = vfio_find_dma(iommu, unmap->iova + unmap->size - 1, 0);
>>   		if (dma && dma->iova + dma->size != unmap->iova + unmap->size) {
>>   			ret = -EINVAL;
>> @@ -1051,6 +1063,11 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>   		if (dma->task->mm != current->mm)
>>   			break;
>>   
>> +		if (unmap->flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP)
>> +			vfio_iova_dirty_bitmap(iommu, dma->iova, dma->size,
>> +					       unmap->bitmap_pgsize,
>> +					      (unsigned char __user *) bitmap);
>> +
>>   		if (!RB_EMPTY_ROOT(&dma->pfn_list)) {
>>   			struct vfio_iommu_type1_dma_unmap nb_unmap;
>>   
>> @@ -1076,6 +1093,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>   						    &nb_unmap);
>>   			goto again;
>>   		}
>> +
>>   		unmapped += dma->size;
>>   		vfio_remove_dma(iommu, dma);
>>   	}
> 
> Spurious white space.
> 
>> @@ -2406,22 +2424,57 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>>   
>>   	} else if (cmd == VFIO_IOMMU_UNMAP_DMA) {
>>   		struct vfio_iommu_type1_dma_unmap unmap;
>> -		long ret;
>> +		unsigned long *bitmap = NULL;
> 
> Shouldn't this have a __user attribute?  Also long doesn't seem the
> right type. void would be ok here.
> 

Removed this with the use of vfio_bitmap structure.

>> +		long ret, bsize;
>>   
>>   		minsz = offsetofend(struct vfio_iommu_type1_dma_unmap, size);
>>   
>>   		if (copy_from_user(&unmap, (void __user *)arg, minsz))
>>   			return -EFAULT;
>>   
>> -		if (unmap.argsz < minsz || unmap.flags)
>> +		if (unmap.argsz < minsz ||
>> +		    unmap.flags & ~VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP)
>>   			return -EINVAL;
>>   
>> -		ret = vfio_dma_do_unmap(iommu, &unmap);
>> +		if (unmap.flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) {
>> +			unsigned long pgshift;
>> +			uint64_t iommu_pgsizes = vfio_pgsize_bitmap(iommu);
>> +			uint64_t iommu_pgmask =
>> +				 ((uint64_t)1 << __ffs(iommu_pgsizes)) - 1;
>> +
> 
> Need to test that unmap.argsz includes this.
> 

Added.

>> +			if (copy_from_user(&unmap, (void __user *)arg,
>> +					   sizeof(unmap)))
>> +				return -EFAULT;
>> +
>> +			pgshift = __ffs(unmap.bitmap_pgsize);
>> +
>> +			if (((unmap.bitmap_pgsize - 1) & iommu_pgmask) !=
>> +			     (unmap.bitmap_pgsize - 1))
>> +				return -EINVAL;
>> +
>> +			if ((unmap.bitmap_pgsize & iommu_pgsizes) !=
>> +			     unmap.bitmap_pgsize)
>> +				return -EINVAL;
>> +			if (unmap.iova + unmap.size < unmap.iova)
>> +				return -EINVAL;
>> +			if (!access_ok((void __user *)unmap.bitmap,
>> +				       unmap.bitmap_size))
>> +				return -EINVAL;
> 
> These tests should be identical to the previous patch.
>

Updating tests here. Removing redundant tests which are already in 
vfio_dma_do_unmap()

>> +
>> +			bsize = verify_bitmap_size(unmap.size >> pgshift,
>> +						   unmap.bitmap_size);
>> +			if (bsize < 0)
>> +				return bsize;
>> +			bitmap = unmap.bitmap;
>> +		}
>> +
>> +		ret = vfio_dma_do_unmap(iommu, &unmap, bitmap);
>>   		if (ret)
>>   			return ret;
>>   
>> -		return copy_to_user((void __user *)arg, &unmap, minsz) ?
>> +		ret = copy_to_user((void __user *)arg, &unmap, minsz) ?
>>   			-EFAULT : 0;
>> +		return ret;
> 
> Why?  Leftover debugging?
> 

Yeah, keeping the original one.


>>   	} else if (cmd == VFIO_IOMMU_DIRTY_PAGES) {
>>   		struct vfio_iommu_type1_dirty_bitmap dirty;
>>   		uint32_t mask = VFIO_IOMMU_DIRTY_PAGES_FLAG_START |
>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> index 02d555cc7036..12b2094f887e 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
>> @@ -1004,12 +1004,24 @@ struct vfio_iommu_type1_dma_map {
>>    * field.  No guarantee is made to the user that arbitrary unmaps of iova
>>    * or size different from those used in the original mapping call will
>>    * succeed.
>> + * VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP should be set to get dirty bitmap
>> + * before unmapping IO virtual addresses. When this flag is set, user should
>> + * allocate memory to get bitmap, clear the bitmap memory by setting zero and
>> + * should set size of allocated memory in bitmap_size field. One bit in bitmap
>> + * represents per page , page of user provided page size in 'bitmap_pgsize',
>> + * consecutively starting from iova offset. Bit set indicates page at that
>> + * offset from iova is dirty. Bitmap of pages in the range of unmapped size is
>> + * returned in bitmap.
>>    */
>>   struct vfio_iommu_type1_dma_unmap {
>>   	__u32	argsz;
>>   	__u32	flags;
>> +#define VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP (1 << 0)
>>   	__u64	iova;				/* IO virtual address */
>>   	__u64	size;				/* Size of mapping (bytes) */
>> +	__u64        bitmap_pgsize;		/* page size for bitmap */
>> +	__u64        bitmap_size;               /* in bytes */
>> +	void __user *bitmap;                    /* one bit per page */
> 
> This suggests to me that we should further split struct
> vfio_iommu_type1_dirty_bitmap_get so that we can use the same
> sub-structure here.  For example:
> 
> struct vfio_bitmap {
> 	__u64 pgsize;
> 	__u64 size;
> 	__u64 __user *data;
> };
> 
> Note we still have a void* rather than __u64* in original above.
> 
> Also, why wouldn't we take the same data[] approach as the previous
> patch, defining this as the data when the GET_DIRTY_BITMAP flag is set?
> 
> Previous patch would be updated to something like:
> 
> struct vfio_iommu_type1_dirty_bitmap_get {
> 	__u64 iova;
> 	__u64 size;
> 	struct vfio_bitmap bitmap;
> };
> 
>>   };
>>   
>>   #define VFIO_IOMMU_UNMAP_DMA _IO(VFIO_TYPE, VFIO_BASE + 14)
> 

Ok. Updating.

Thanks,
Kirti
