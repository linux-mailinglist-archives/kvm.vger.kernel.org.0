Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC68F1D461A
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 08:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbgEOGrR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 02:47:17 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:10077 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726215AbgEOGrQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 May 2020 02:47:16 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ebe3ae70000>; Thu, 14 May 2020 23:47:03 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Thu, 14 May 2020 23:47:16 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Thu, 14 May 2020 23:47:16 -0700
Received: from [10.40.103.94] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 15 May
 2020 06:47:08 +0000
Subject: Re: [PATCH Kernel v20 6/8] vfio iommu: Update UNMAP_DMA ioctl to get
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
References: <1589488667-9683-1-git-send-email-kwankhede@nvidia.com>
 <1589488667-9683-7-git-send-email-kwankhede@nvidia.com>
 <20200514212706.036a336a@x1.home>
 <5256f488-2d11-eb0f-6980-eea23f4d3019@nvidia.com>
 <20200514234726.03c2e345@x1.home>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <268ec129-a1cb-530a-c9b2-7ec53ddf4d17@nvidia.com>
Date:   Fri, 15 May 2020 12:17:03 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200514234726.03c2e345@x1.home>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1589525223; bh=dBtvBUBNrxeFyFhRMHydE/Wh20dlKhOvn7bNkReQAP0=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=Ae63CYIalxtQCPTMAqrOT9/1Kh9o+awA0IZyAf0LCwP3wq0gVZTXM+HIFuz28244r
         O/9GHCLafiZmuu0kH56MU+gNQv7iPUFNQvJm3+P/9GMaSDUHcsiwAWCtGCkH+e1BcL
         dnZHjZtsEkDPVQptRxwidIqGu9EUZOmzvAJ5ata7oal/BX9hBL8q2k7OV+s9dx/7f7
         ybWugS+1a7HCbeugAcKKo4qbhHNvpIODwePqOcbVWNysSzRPCN0Z672ZFutmd8q3Sl
         WpL2G/LZoJVLUiQ8k3KNF50ChuiRRb8SaNAxKjVK3gw5XNtGkQ8pdqT1alVMivUoNZ
         sDMomRKNiu4JQ==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/15/2020 11:17 AM, Alex Williamson wrote:
> On Fri, 15 May 2020 09:46:43 +0530
> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> 
>> On 5/15/2020 8:57 AM, Alex Williamson wrote:
>>> On Fri, 15 May 2020 02:07:45 +0530
>>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
>>>    
>>>> DMA mapped pages, including those pinned by mdev vendor drivers, might
>>>> get unpinned and unmapped while migration is active and device is still
>>>> running. For example, in pre-copy phase while guest driver could access
>>>> those pages, host device or vendor driver can dirty these mapped pages.
>>>> Such pages should be marked dirty so as to maintain memory consistency
>>>> for a user making use of dirty page tracking.
>>>>
>>>> To get bitmap during unmap, user should allocate memory for bitmap, set
>>>> it all zeros, set size of allocated memory, set page size to be
>>>> considered for bitmap and set flag VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP.
>>>>
>>>> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
>>>> Reviewed-by: Neo Jia <cjia@nvidia.com>
>>>> ---
>>>>    drivers/vfio/vfio_iommu_type1.c | 77 ++++++++++++++++++++++++++++++++++-------
>>>>    include/uapi/linux/vfio.h       | 10 ++++++
>>>>    2 files changed, 75 insertions(+), 12 deletions(-)
>>>>
>>>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>>>> index b76d3b14abfd..a1dc57bcece5 100644
>>>> --- a/drivers/vfio/vfio_iommu_type1.c
>>>> +++ b/drivers/vfio/vfio_iommu_type1.c
>>>> @@ -195,11 +195,15 @@ static void vfio_unlink_dma(struct vfio_iommu *iommu, struct vfio_dma *old)
>>>>    static int vfio_dma_bitmap_alloc(struct vfio_dma *dma, size_t pgsize)
>>>>    {
>>>>    	uint64_t npages = dma->size / pgsize;
>>>> +	size_t bitmap_size;
>>>>    
>>>>    	if (npages > DIRTY_BITMAP_PAGES_MAX)
>>>>    		return -EINVAL;
>>>>    
>>>> -	dma->bitmap = kvzalloc(DIRTY_BITMAP_BYTES(npages), GFP_KERNEL);
>>>> +	/* Allocate extra 64 bits which are used for bitmap manipulation */
>>>> +	bitmap_size = DIRTY_BITMAP_BYTES(npages) + sizeof(u64);
>>>> +
>>>> +	dma->bitmap = kvzalloc(bitmap_size, GFP_KERNEL);
>>>>    	if (!dma->bitmap)
>>>>    		return -ENOMEM;
>>>>    
>>>> @@ -999,23 +1003,25 @@ static int verify_bitmap_size(uint64_t npages, uint64_t bitmap_size)
>>>>    }
>>>>    
>>>>    static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>>> -			     struct vfio_iommu_type1_dma_unmap *unmap)
>>>> +			     struct vfio_iommu_type1_dma_unmap *unmap,
>>>> +			     struct vfio_bitmap *bitmap)
>>>>    {
>>>> -	uint64_t mask;
>>>>    	struct vfio_dma *dma, *dma_last = NULL;
>>>> -	size_t unmapped = 0;
>>>> +	size_t unmapped = 0, pgsize;
>>>>    	int ret = 0, retries = 0;
>>>> +	unsigned long pgshift;
>>>>    
>>>>    	mutex_lock(&iommu->lock);
>>>>    
>>>> -	mask = ((uint64_t)1 << __ffs(iommu->pgsize_bitmap)) - 1;
>>>> +	pgshift = __ffs(iommu->pgsize_bitmap);
>>>> +	pgsize = (size_t)1 << pgshift;
>>>>    
>>>> -	if (unmap->iova & mask) {
>>>> +	if (unmap->iova & (pgsize - 1)) {
>>>>    		ret = -EINVAL;
>>>>    		goto unlock;
>>>>    	}
>>>>    
>>>> -	if (!unmap->size || unmap->size & mask) {
>>>> +	if (!unmap->size || unmap->size & (pgsize - 1)) {
>>>>    		ret = -EINVAL;
>>>>    		goto unlock;
>>>>    	}
>>>> @@ -1026,9 +1032,15 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>>>    		goto unlock;
>>>>    	}
>>>>    
>>>> -	WARN_ON(mask & PAGE_MASK);
>>>> -again:
>>>> +	/* When dirty tracking is enabled, allow only min supported pgsize */
>>>> +	if ((unmap->flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) &&
>>>> +	    (!iommu->dirty_page_tracking || (bitmap->pgsize != pgsize))) {
>>>> +		ret = -EINVAL;
>>>> +		goto unlock;
>>>> +	}
>>>>    
>>>> +	WARN_ON((pgsize - 1) & PAGE_MASK);
>>>> +again:
>>>>    	/*
>>>>    	 * vfio-iommu-type1 (v1) - User mappings were coalesced together to
>>>>    	 * avoid tracking individual mappings.  This means that the granularity
>>>> @@ -1066,6 +1078,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>>>    			ret = -EINVAL;
>>>>    			goto unlock;
>>>>    		}
>>>> +
>>>>    		dma = vfio_find_dma(iommu, unmap->iova + unmap->size - 1, 0);
>>>>    		if (dma && dma->iova + dma->size != unmap->iova + unmap->size) {
>>>>    			ret = -EINVAL;
>>>> @@ -1083,6 +1096,23 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>>>    		if (dma->task->mm != current->mm)
>>>>    			break;
>>>>    
>>>> +		if ((unmap->flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) &&
>>>> +		    (dma_last != dma)) {
>>>> +
>>>> +			/*
>>>> +			 * mark all pages dirty if all pages are pinned and
>>>> +			 * mapped
>>>> +			 */
>>>> +			if (dma->iommu_mapped)
>>>> +				bitmap_set(dma->bitmap, 0,
>>>> +					   dma->size >> pgshift);
>>>
>>> Nit, all the callers of update_user_bitmap() precede the call with this
>>> identical operation, we should probably push it into the function to do
>>> it.
>>>    
>>>> +
>>>> +			ret = update_user_bitmap(bitmap->data, dma,
>>>> +						 unmap->iova, pgsize);
>>>> +			if (ret)
>>>> +				break;
>>>> +		}
>>>> +
>>>
>>> As noted last time, the above is just busy work if pfn_list is not
>>> already empty.  The entire code block above should be moved to after
>>> the block below.  Thanks,
>>>    
>>
>> pfn_list will be empty for IOMMU backed devices where all pages are
>> pinned and mapped,
> 
> Unless we're making use of the selective dirtying introduced in patch
> 8/8 or the container is shared with non-IOMMU backed mdevs.
> 
>> but those should be reported as dirty.
> 
> I'm confused how that justifies or requires this ordering.
> 

1. non IOMMU mdev device:
- vendor driver pins pages
- pfn_list is not empty
- device dma or write to pinned pages

2. IOMMU backed mdev device or vfio device, but smart driver which pins 
required pages
- vendor driver pins pages
- pfn_list is not empty
- device dma or write to pinned pages

3. IOMMU backed mdev device or vfio device, driver is not smart
- pages are pinned and mapped during attach
- pfn_list is empty
- device dma or write to any of pinned pages

For case 3, here this function does bitmap_set(dma->bitmap), that is 
mark all pages dirty and then accordingly copy bitmap to user buffer.
Copying dma->bitmap logic remains same.

>> So moved it
>> back above empty pfn_list check.
> 
> Sorry, it still doesn't make any sense to me, and with no discussion I
> can't differentiate ignored comments from discarded comments.
> 
> Pages in the pfn_list contribute to the dirty bitmap when they're
> pinned, we don't depend on pfn_list when reporting the dirty bitmap
> except for re-populating pfn_list dirtied pages after the bitmap has
> been cleared.  We're unmapping the dma, so that's not the case here.
> Also since update_user_bitmap() shifts the bitmap in place now, any
> repetitive calls will give us incorrect results.

Right, but this is unmapping and freeing vfio_dma

>  Therefore, as I see
> it, we _can_ take the branch below and when we do any work we've done
> above is not only wasted but may lead to incorrect data copied to
> the user if we shift dma->bitmap in place more than once.  Please
> explain in more detail if you believe this is still correct.  Thanks,
> 

In this case also bitmap copy to user happens once, (dma_last != dma) 
takes care of making sure that its called only once.

Thanks,
Kirti

> Alex
> 
>>>    
>>>>    		if (!RB_EMPTY_ROOT(&dma->pfn_list)) {
>>>>    			struct vfio_iommu_type1_dma_unmap nb_unmap;
>>>>    
>>>> @@ -2447,17 +2477,40 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>>>>    
>>>>    	} else if (cmd == VFIO_IOMMU_UNMAP_DMA) {
>>>>    		struct vfio_iommu_type1_dma_unmap unmap;
>>>> -		long ret;
>>>> +		struct vfio_bitmap bitmap = { 0 };
>>>> +		int ret;
>>>>    
>>>>    		minsz = offsetofend(struct vfio_iommu_type1_dma_unmap, size);
>>>>    
>>>>    		if (copy_from_user(&unmap, (void __user *)arg, minsz))
>>>>    			return -EFAULT;
>>>>    
>>>> -		if (unmap.argsz < minsz || unmap.flags)
>>>> +		if (unmap.argsz < minsz ||
>>>> +		    unmap.flags & ~VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP)
>>>>    			return -EINVAL;
>>>>    
>>>> -		ret = vfio_dma_do_unmap(iommu, &unmap);
>>>> +		if (unmap.flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) {
>>>> +			unsigned long pgshift;
>>>> +
>>>> +			if (unmap.argsz < (minsz + sizeof(bitmap)))
>>>> +				return -EINVAL;
>>>> +
>>>> +			if (copy_from_user(&bitmap,
>>>> +					   (void __user *)(arg + minsz),
>>>> +					   sizeof(bitmap)))
>>>> +				return -EFAULT;
>>>> +
>>>> +			if (!access_ok((void __user *)bitmap.data, bitmap.size))
>>>> +				return -EINVAL;
>>>> +
>>>> +			pgshift = __ffs(bitmap.pgsize);
>>>> +			ret = verify_bitmap_size(unmap.size >> pgshift,
>>>> +						 bitmap.size);
>>>> +			if (ret)
>>>> +				return ret;
>>>> +		}
>>>> +
>>>> +		ret = vfio_dma_do_unmap(iommu, &unmap, &bitmap);
>>>>    		if (ret)
>>>>    			return ret;
>>>>    
>>>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>>>> index 123de3bc2dce..0a0c7315ddd6 100644
>>>> --- a/include/uapi/linux/vfio.h
>>>> +++ b/include/uapi/linux/vfio.h
>>>> @@ -1048,12 +1048,22 @@ struct vfio_bitmap {
>>>>     * field.  No guarantee is made to the user that arbitrary unmaps of iova
>>>>     * or size different from those used in the original mapping call will
>>>>     * succeed.
>>>> + * VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP should be set to get dirty bitmap
>>>> + * before unmapping IO virtual addresses. When this flag is set, user must
>>>> + * provide data[] as structure vfio_bitmap. User must allocate memory to get
>>>> + * bitmap, zero the bitmap memory and must set size of allocated memory in
>>>> + * vfio_bitmap.size field. A bit in bitmap represents one page of user provided
>>>> + * page size in 'pgsize', consecutively starting from iova offset. Bit set
>>>> + * indicates page at that offset from iova is dirty. Bitmap of pages in the
>>>> + * range of unmapped size is returned in vfio_bitmap.data
>>>>     */
>>>>    struct vfio_iommu_type1_dma_unmap {
>>>>    	__u32	argsz;
>>>>    	__u32	flags;
>>>> +#define VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP (1 << 0)
>>>>    	__u64	iova;				/* IO virtual address */
>>>>    	__u64	size;				/* Size of mapping (bytes) */
>>>> +	__u8    data[];
>>>>    };
>>>>    
>>>>    #define VFIO_IOMMU_UNMAP_DMA _IO(VFIO_TYPE, VFIO_BASE + 14)
>>>    
>>
> 
