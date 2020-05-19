Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 357171D90B5
	for <lists+kvm@lfdr.de>; Tue, 19 May 2020 09:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728439AbgESHLq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 03:11:46 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:13074 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726943AbgESHLp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 May 2020 03:11:45 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ec386630000>; Tue, 19 May 2020 00:10:27 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 19 May 2020 00:11:45 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 19 May 2020 00:11:45 -0700
Received: from [10.40.101.17] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 19 May
 2020 07:11:37 +0000
Subject: Re: [PATCH Kernel v22 5/8] vfio iommu: Implementation of ioctl for
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
References: <1589781397-28368-1-git-send-email-kwankhede@nvidia.com>
 <1589781397-28368-6-git-send-email-kwankhede@nvidia.com>
 <20200518155342.4dd7df99@x1.home>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <17511c50-dc59-d9e9-10b6-54b16dec01c4@nvidia.com>
Date:   Tue, 19 May 2020 12:41:32 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200518155342.4dd7df99@x1.home>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1589872227; bh=uKmis0J14radJAZB+skg6Hn0gaJidhg8bebWeaZAg5k=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=PTekhjRYjQ09iPcxT2NxVVpdQuOhJLOMc3526p1A7AuUVOKR9s5K2MOnL04gzxSZD
         ZMlhZtkCgQx7NKEgWRaVJFo9UoKu9KXp9okl6zQbgaT86OX+uPVjvq/LBeym8Zmfjj
         JbsTeNdKcpZ9aXQo6Gbo1CInpKEWXRB6w8rALjaQ8K1GUyHcaG93Uv3pT1nLEU8yD1
         4rIdUP2LY+2kbIyobBooMNa20wKd496akVFXy9LVu1cAEp8A2k3rnmlIBIJhKrHK0e
         K1qMY40h1DOGAu17RUnwFHSg2uk/8Adkee1x/M7LRbTB3GROG3IfIcdmiD//EZKS9m
         /CxtF+2yfCY/w==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/19/2020 3:23 AM, Alex Williamson wrote:
> On Mon, 18 May 2020 11:26:34 +0530
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
>>   drivers/vfio/vfio_iommu_type1.c | 313 +++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 307 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index de17787ffece..bf740fef196f 100644
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
> 
> Curious that the extra 8-bytes are added in the next patch, but they're
> just as necessary here.
>

Yes, moving it in this patch.
While resolving patches, I had to update 6/8 and 8/8 patches also. So 
updating 3 patches.

> We also have the explanation above about why we have the signed int
> size limitation, but we sort of ignore that when adding the bytes here.
> That limitation is derived from __bitmap_set(), whereas we only need
> these extra bits for bitmap_shift_left(), where I can't spot a signed
> int limitation.  Do you come to the same conclusion?  

That's right.

> Maybe worth a
> comment why we think we can exceed DIRTY_BITMAP_PAGES_MAX for that
> extra padding.
> 

ok.

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
> 
> Nit, the previous function above sets the initial value in the for()
> statement, it looks like it would fit in 80 columns here too.  We have
> examples either way in the code, so not a must fix.
> 
>> +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
>> +		int ret;
>> +
>> +		ret = vfio_dma_bitmap_alloc(dma, pgsize);
>> +		if (ret) {
>> +			struct rb_node *p = rb_prev(n);
>> +
>> +			for (; p; p = rb_prev(p)) {
> 
> Same.
> 
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
> 
> And another.
> 
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
>> +				   (iova - dma->iova) >> pgshift, 1);
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
>> @@ -829,6 +924,99 @@ static void vfio_pgsize_bitmap(struct vfio_iommu *iommu)
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
>> +	/* mark all pages dirty if all pages are pinned and mapped. */
>> +	if (dma->iommu_mapped)
>> +		bitmap_set(dma->bitmap, 0, dma->size >> pgshift);
> 
> We already calculated 'dma->size >> pgshift' as nbits above, we should
> use nbits here.  I imagine the compiler will optimize this, so take it
> as a nit.
> 
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
>> +	struct rb_node *n;
>> +	unsigned long pgshift = __ffs(pgsize);
>> +	int ret;
>> +
>> +	/*
>> +	 * GET_BITMAP request must fully cover vfio_dma mappings.  Multiple
>> +	 * vfio_dma mappings may be clubbed by specifying large ranges, but
>> +	 * there must not be any previous mappings bisected by the range.
>> +	 * An error will be returned if these conditions are not met.
>> +	 */
>> +	dma = vfio_find_dma(iommu, iova, 1);
>> +	if (dma && dma->iova != iova)
>> +		return -EINVAL;
>> +
>> +	dma = vfio_find_dma(iommu, iova + size - 1, 0);
>> +	if (dma && dma->iova + dma->size != iova + size)
>> +		return -EINVAL;
>> +
>> +	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
>> +		struct vfio_dma *ldma = rb_entry(n, struct vfio_dma, node);
>> +
>> +		if (ldma->iova >= iova)
>> +			break;
>> +	}
>> +
>> +	dma = n ? rb_entry(n, struct vfio_dma, node) : NULL;
>> +
>> +	while (dma && (dma->iova >= iova) &&
> 
> 'dma->iova >= iova' is necessarily true per the above loop, right?
> We'd have NULL if we never reach an iova within range.
> 
>> +		(dma->iova + dma->size <= iova + size)) {
> 
> I think 'dma->iova < iova + size' is sufficient here, we've already
> tested that there are no dmas overlapping the ends, they're all either
> fully contained or fully outside.
> 
>> +
> 
> The double loop here is a little unnecessary, we could combine them
> into:
> 
> for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
> 	struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
> 
> 	if (dma->iova < iova)
> 		continue;
> 
> 	if (dma->iova > iova + size)
> 		break;
> 
> 	ret = update_user_bitmap(bitmap, dma, iova, pgsize);
> 	if (ret)
> 		return ret;
> 
> 	/*
> 	 * Re-populate bitmap to include all pinned pages which are
> 	 * considered as dirty but exclude pages which are unpinned and
> 	 * pages which are marked dirty by vfio_dma_rw()
> 	 */
> 	bitmap_clear(dma->bitmap, 0, dma->size >> pgshift);
> 	vfio_dma_populate_bitmap(dma, pgsize);
> }
> 
> I think what you have works, but it's a little more complicated than it
> needs to be.  Thanks,
> 

Ok. Chaning it.

Thanks,
Kirti
