Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93C9A1D2FDA
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 14:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgENMdn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 08:33:43 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:5500 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725925AbgENMdm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 08:33:42 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ebd3a5b0000>; Thu, 14 May 2020 05:32:27 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Thu, 14 May 2020 05:33:42 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Thu, 14 May 2020 05:33:42 -0700
Received: from [10.40.103.94] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 14 May
 2020 12:33:33 +0000
Subject: Re: [PATCH Kernel v19 5/8] vfio iommu: Implementation of ioctl for
 dirty pages tracking
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
References: <1589400279-28522-1-git-send-email-kwankhede@nvidia.com>
 <1589400279-28522-6-git-send-email-kwankhede@nvidia.com>
 <20200513230224.195b97e8@x1.home>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <e85c4f71-89e6-1d74-1d6d-f617b3a56db4@nvidia.com>
Date:   Thu, 14 May 2020 18:03:29 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200513230224.195b97e8@x1.home>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1589459547; bh=hXLqQN/hNI+HK7y5v4JF2tzRkEClai5OPNcoypzAew8=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=qroyB9OiYopgps8T+7exeVyIIdZvpz5Hzvl7BVFuXYCTlPTCecMdKT5yN3tKxGra/
         hrM0tJSv0vUCXIEWzr8Aw/0RWscwikLqVbJ3/GP3hvIXwc7JX9kn6K4jIFwGINyJK6
         W6f45oZ/fivSmJhwpihoTNXvzFS2yIklAW2mf7hiSFdtU6rhRssYH6BvXt/E+H+V4J
         proLcJs0TqbRU2OcbOVeoYZQhFiYMrpaEseB1F9TO3P+p3HjC/jdxTw1BaOdwnxjDu
         dCLxY5JCWQ6TkRHHU80KzgGrrXrDNQGNDJE0xuzuUByhYKJ52XoecNXIiukRSIIVXW
         fQ8AczGcS4YwA==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/14/2020 10:32 AM, Alex Williamson wrote:
> On Thu, 14 May 2020 01:34:36 +0530
> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> 
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
>>   drivers/vfio/vfio_iommu_type1.c | 274 +++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 268 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 6f09fbabed12..469b09185b83 100644
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
>> @@ -176,6 +191,77 @@ static void vfio_unlink_dma(struct vfio_iommu *iommu, struct vfio_dma *old)
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
>> +	if (RB_EMPTY_ROOT(&dma->pfn_list))
>> +		return;
> 
> I don't think this is optimizing anything:
> 
> #define RB_EMPTY_ROOT(root)  (READ_ONCE((root)->rb_node) == NULL)
> 
> struct rb_node *rb_first(const struct rb_root *root)
> {
>          struct rb_node  *n;
> 
>          n = root->rb_node;
>          if (!n)
>                  return NULL;
> 
> So the loop below won't be entered if the tree is empty.
> 

Removing empty check.

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
>> @@ -568,6 +654,17 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
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
>> @@ -802,6 +899,7 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
>>   	vfio_unmap_unpin(iommu, dma, true);
>>   	vfio_unlink_dma(iommu, dma);
>>   	put_task_struct(dma->task);
>> +	vfio_dma_bitmap_free(dma);
>>   	kfree(dma);
>>   	iommu->dma_avail++;
>>   }
>> @@ -829,6 +927,57 @@ static void vfio_pgsize_bitmap(struct vfio_iommu *iommu)
>>   	}
>>   }
>>   
>> +static int vfio_iova_dirty_bitmap(struct vfio_iommu *iommu, dma_addr_t iova,
>> +				  size_t size, size_t pgsize,
>> +				  u64 __user *bitmap)
>> +{
>> +	struct vfio_dma *dma;
>> +	unsigned long pgshift = __ffs(pgsize);
>> +	unsigned int npages, bitmap_size;
>> +
>> +	dma = vfio_find_dma(iommu, iova, 1);
>> +
>> +	if (!dma)
>> +		return -EINVAL;
>> +
>> +	if (dma->iova != iova || dma->size != size)
>> +		return -EINVAL;
> 
> Minor cleanup:
> 
> 	if (!dma || dma->iova != iova || dma->size != size)
> 		return -EINVAL;
> 
>> +
>> +	npages = dma->size >> pgshift;
>> +	bitmap_size = DIRTY_BITMAP_BYTES(npages);
>> +
>> +	/* mark all pages dirty if all pages are pinned and mapped. */
>> +	if (dma->iommu_mapped)
>> +		bitmap_set(dma->bitmap, 0, npages);
>> +
>> +	if (copy_to_user((void __user *)bitmap, dma->bitmap, bitmap_size))
>> +		return -EFAULT;
>> +
>> +	/*
>> +	 * Re-populate bitmap to include all pinned pages which are considered
>> +	 * as dirty but exclude pages which are unpinned and pages which are
>> +	 * marked dirty by vfio_dma_rw()
>> +	 */
>> +	bitmap_clear(dma->bitmap, 0, npages);
>> +	vfio_dma_populate_bitmap(dma, pgsize);
>> +	return 0;
>> +}
>> +
>> +static int verify_bitmap_size(uint64_t npages, uint64_t bitmap_size)
>> +{
>> +	uint64_t bsize;
>> +
>> +	if (!npages || !bitmap_size || (bitmap_size > DIRTY_BITMAP_SIZE_MAX))
>> +		return -EINVAL;
>> +
>> +	bsize = DIRTY_BITMAP_BYTES(npages);
>> +
>> +	if (bitmap_size < bsize)
>> +		return -EINVAL;
> 
> Another minor cleanup:
> 
> 	if (!npages || !bitmap_size || bitmap_size > DIRTY_BITMAP_SIZE_MAX ||
> 	    bitmap_size < DIRTY_BITMAP_BYTES(npages))
> 		return -EINVAL;
> 
>> +
>> +	return 0;
>> +}
>> +
>>   static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>   			     struct vfio_iommu_type1_dma_unmap *unmap)
>>   {
>> @@ -1046,7 +1195,7 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>>   	unsigned long vaddr = map->vaddr;
>>   	size_t size = map->size;
>>   	int ret = 0, prot = 0;
>> -	uint64_t mask;
>> +	size_t pgsize;
>>   	struct vfio_dma *dma;
>>   
>>   	/* Verify that none of our __u64 fields overflow */
>> @@ -1061,11 +1210,11 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>>   
>>   	mutex_lock(&iommu->lock);
>>   
>> -	mask = ((uint64_t)1 << __ffs(iommu->pgsize_bitmap)) - 1;
>> +	pgsize = (size_t)1 << __ffs(iommu->pgsize_bitmap);
>>   
>> -	WARN_ON(mask & PAGE_MASK);
>> +	WARN_ON((pgsize - 1) & PAGE_MASK);
>>   
>> -	if (!prot || !size || (size | iova | vaddr) & mask) {
>> +	if (!prot || !size || (size | iova | vaddr) & (pgsize - 1)) {
>>   		ret = -EINVAL;
>>   		goto out_unlock;
>>   	}
>> @@ -1142,6 +1291,12 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>>   	else
>>   		ret = vfio_pin_map_dma(iommu, dma, size);
>>   
>> +	if (!ret && iommu->dirty_page_tracking) {
>> +		ret = vfio_dma_bitmap_alloc(dma, pgsize);
>> +		if (ret)
>> +			vfio_remove_dma(iommu, dma);
>> +	}
>> +
>>   out_unlock:
>>   	mutex_unlock(&iommu->lock);
>>   	return ret;
>> @@ -2287,6 +2442,104 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>>   
>>   		return copy_to_user((void __user *)arg, &unmap, minsz) ?
>>   			-EFAULT : 0;
>> +	} else if (cmd == VFIO_IOMMU_DIRTY_PAGES) {
>> +		struct vfio_iommu_type1_dirty_bitmap dirty;
>> +		uint32_t mask = VFIO_IOMMU_DIRTY_PAGES_FLAG_START |
>> +				VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP |
>> +				VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP;
>> +		int ret = 0;
>> +
>> +		if (!iommu->v2)
>> +			return -EACCES;
>> +
>> +		minsz = offsetofend(struct vfio_iommu_type1_dirty_bitmap,
>> +				    flags);
>> +
>> +		if (copy_from_user(&dirty, (void __user *)arg, minsz))
>> +			return -EFAULT;
>> +
>> +		if (dirty.argsz < minsz || dirty.flags & ~mask)
>> +			return -EINVAL;
>> +
>> +		/* only one flag should be set at a time */
>> +		if (__ffs(dirty.flags) != __fls(dirty.flags))
>> +			return -EINVAL;
>> +
>> +		if (dirty.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_START) {
>> +			size_t pgsize;
>> +
>> +			mutex_lock(&iommu->lock);
>> +			pgsize = 1 << __ffs(iommu->pgsize_bitmap);
>> +			if (!iommu->dirty_page_tracking) {
>> +				ret = vfio_dma_bitmap_alloc_all(iommu, pgsize);
>> +				if (!ret)
>> +					iommu->dirty_page_tracking = true;
>> +			}
>> +			mutex_unlock(&iommu->lock);
>> +			return ret;
>> +		} else if (dirty.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP) {
>> +			mutex_lock(&iommu->lock);
>> +			if (iommu->dirty_page_tracking) {
>> +				iommu->dirty_page_tracking = false;
>> +				vfio_dma_bitmap_free_all(iommu);
>> +			}
>> +			mutex_unlock(&iommu->lock);
>> +			return 0;
>> +		} else if (dirty.flags &
>> +				 VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP) {
>> +			struct vfio_iommu_type1_dirty_bitmap_get range;
>> +			unsigned long pgshift;
>> +			size_t data_size = dirty.argsz - minsz;
>> +			size_t iommu_pgsize;
>> +
>> +			if (!data_size || data_size < sizeof(range))
>> +				return -EINVAL;
>> +
>> +			if (copy_from_user(&range, (void __user *)(arg + minsz),
>> +					   sizeof(range)))
>> +				return -EFAULT;
>> +
>> +			if (range.iova + range.size < range.iova)
>> +				return -EINVAL;
>> +			if (!access_ok((void __user *)range.bitmap.data,
>> +				       range.bitmap.size))
>> +				return -EINVAL;
>> +
>> +			pgshift = __ffs(range.bitmap.pgsize);
>> +			ret = verify_bitmap_size(range.size >> pgshift,
>> +						 range.bitmap.size);
>> +			if (ret)
>> +				return ret;
>> +
>> +			mutex_lock(&iommu->lock);
>> +
>> +			iommu_pgsize = (size_t)1 << __ffs(iommu->pgsize_bitmap);
>> +
>> +			/* allow only smallest supported pgsize */
>> +			if (range.bitmap.pgsize != iommu_pgsize) {
>> +				ret = -EINVAL;
>> +				goto out_unlock;
>> +			}
>> +			if (range.iova & (iommu_pgsize - 1)) {
>> +				ret = -EINVAL;
>> +				goto out_unlock;
>> +			}
>> +			if (!range.size || range.size & (iommu_pgsize - 1)) {
>> +				ret = -EINVAL;
>> +				goto out_unlock;
>> +			}
>> +
>> +			if (iommu->dirty_page_tracking)
>> +				ret = vfio_iova_dirty_bitmap(iommu, range.iova,
>> +						range.size, range.bitmap.pgsize,
>> +						range.bitmap.data);
> 
> 
> Why does the unmap with dirty bitmap collection now support ranges
> covering multiple vfio_dmas, but this interface does not?  Thanks,
> 

I tried that in v12 version with get_user()-put_user() combination.
After lots of back and forth and brainstroming we finally reached to the 
conclusion of keeping this interface to cover single vfio_dma. I would 
like to stick to that for now. As optimization we can think of doing it 
in future.

Infact looking at the complication in unmap ioctl, I'm rethinking of 
backing off that change for this patch-set. We can definitely add it 
later, but atleast for now get basic working framework ready.

Thanks,
Kirti

> Alex
> 
> 
>> +			else
>> +				ret = -EINVAL;
>> +out_unlock:
>> +			mutex_unlock(&iommu->lock);
>> +
>> +			return ret;
>> +		}
>>   	}
>>   
>>   	return -ENOTTY;
>> @@ -2354,10 +2607,19 @@ static int vfio_iommu_type1_dma_rw_chunk(struct vfio_iommu *iommu,
>>   
>>   	vaddr = dma->vaddr + offset;
>>   
>> -	if (write)
>> +	if (write) {
>>   		*copied = copy_to_user((void __user *)vaddr, data,
>>   					 count) ? 0 : count;
>> -	else
>> +		if (*copied && iommu->dirty_page_tracking) {
>> +			unsigned long pgshift = __ffs(iommu->pgsize_bitmap);
>> +			/*
>> +			 * Bitmap populated with the smallest supported page
>> +			 * size
>> +			 */
>> +			bitmap_set(dma->bitmap, offset >> pgshift,
>> +				   *copied >> pgshift);
>> +		}
>> +	} else
>>   		*copied = copy_from_user(data, (void __user *)vaddr,
>>   					   count) ? 0 : count;
>>   	if (kthread)
> 
