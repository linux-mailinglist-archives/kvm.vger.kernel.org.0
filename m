Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFFFD1872B5
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 19:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732357AbgCPStX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 14:49:23 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:7014 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732349AbgCPStX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Mar 2020 14:49:23 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e6fca000000>; Mon, 16 Mar 2020 11:48:32 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Mon, 16 Mar 2020 11:49:20 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Mon, 16 Mar 2020 11:49:20 -0700
Received: from [10.40.102.44] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 16 Mar
 2020 18:49:10 +0000
Subject: Re: [PATCH v13 Kernel 4/7] vfio iommu: Implementation of ioctl to for
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
References: <1584035607-23166-1-git-send-email-kwankhede@nvidia.com>
 <1584035607-23166-5-git-send-email-kwankhede@nvidia.com>
 <20200313121312.1b3ce4b9@x1.home>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <83177634-1ad7-b106-ad76-57289f92fcf6@nvidia.com>
Date:   Tue, 17 Mar 2020 00:19:05 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200313121312.1b3ce4b9@x1.home>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
	t=1584384512; bh=doVOeLJvCHlyBrT5oFIdrSU0nDjHXrwn0mWTtTMPgy4=;
	h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
	 Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
	 X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
	 Content-Transfer-Encoding;
	b=YBSt0RPo6EJ1dn6dm0dbNWZwnjiLLq9AOO6JOSOpq8DPlN0Rg4XNfilwq7e9s39B0
	 0CZyR9qnUO20Hx0WsJmP9YijZDiNeaV8C17VFED1mq+jxEKYBya4KUT9AROMvJ7kaj
	 EMMKbzAgMWBPBlc+g/LyAbE8/yh9BHw0FYFwRM1mMMTtLCAK9EGDA+WmVXI0tEN1vv
	 huuL80B3FikXs8xtoDBf6qTllgspVTxuya44ps2P+FjQJO6Kc9TLfaSU40jxdA7J+1
	 BD+ODhHtLPSyzQZ7Q11Zsx9HAECnBLtrGgoVxV6kO4IMuSOJvGFYQ4JVrr9+kT3ES6
	 Dj3GPxmCUt2yw==


On 3/13/2020 11:43 PM, Alex Williamson wrote:
> On Thu, 12 Mar 2020 23:23:24 +0530
> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> 
> Subject: s/to //
> 
>> VFIO_IOMMU_DIRTY_PAGES ioctl performs three operations:
>> - Start pinned and unpinned pages tracking while migration is active
>> - Stop pinned and unpinned dirty pages tracking. This is also used to
>>    stop dirty pages tracking if migration failed or cancelled.
> 
> I'm not sure why we need to specify "pinned and unpinned" above, it
> works for iommu mapped pages too, and we expect it to later work other
> dirtying mechanisms, like Yan's dma_rw interface.
> 

iommu mapped pages are also pinned.
When there are CPU writes, like Yan's dma_rw, then KVM core takes care 
of marking those pages dirty, then we don't need to track those pages 
again here, right?


>> - Get dirty pages bitmap. This ioctl returns bitmap of dirty pages, its
>>    user space application responsibility to copy content of dirty pages
>>    from source to destination during migration.
>>
>> To prevent DoS attack, memory for bitmap is allocated per vfio_dma
>> structure. Bitmap size is calculated considering smallest supported page
>> size. Bitmap is allocated when dirty logging is enabled for those
>> vfio_dmas whose vpfn list is not empty or whole range is mapped, in
>> case of pass-through device.
>>
>> Bitmap is populated for already pinned pages when bitmap is allocated for
>> a vfio_dma with the smallest supported page size. Update bitmap from
>> pinning and unpinning functions. When user application queries bitmap,
>> check if requested page size is same as page size used to populated
>> bitmap. If it is equal, copy bitmap, but if not equal, return error.
>>
>> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
>> Reviewed-by: Neo Jia <cjia@nvidia.com>
>> ---
>>   drivers/vfio/vfio_iommu_type1.c | 243 +++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 237 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index d386461e5d11..435e84269a28 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -70,6 +70,7 @@ struct vfio_iommu {
>>   	unsigned int		dma_avail;
>>   	bool			v2;
>>   	bool			nesting;
>> +	bool			dirty_page_tracking;
>>   };
>>   
>>   struct vfio_domain {
>> @@ -90,6 +91,7 @@ struct vfio_dma {
>>   	bool			lock_cap;	/* capable(CAP_IPC_LOCK) */
>>   	struct task_struct	*task;
>>   	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
>> +	unsigned long		*bitmap;
>>   };
>>   
>>   struct vfio_group {
>> @@ -125,6 +127,7 @@ struct vfio_regions {
>>   					(!list_empty(&iommu->domain_list))
>>   
>>   static int put_pfn(unsigned long pfn, int prot);
>> +static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu);
>>   
>>   /*
>>    * This code handles mapping and unmapping of user data buffers
>> @@ -174,6 +177,76 @@ static void vfio_unlink_dma(struct vfio_iommu *iommu, struct vfio_dma *old)
>>   	rb_erase(&old->node, &iommu->dma_list);
>>   }
>>   
>> +static inline unsigned long dirty_bitmap_bytes(unsigned int npages)
>> +{
>> +	if (!npages)
>> +		return 0;
>> +
>> +	return ALIGN(npages, BITS_PER_LONG) / sizeof(unsigned long);
> 
> Yes, but no.  The math works out here on LP64 systems because
> sizeof(unsigned long) == BITS_PER_BYTE, but sizeof(unsigned long) is
> irrelevant, we wants BITS_PER_BYTE.  Also, the UAPI defines the bitmap
> as an array of __u64, so rather than BITS_PER_LONG I think we want
> BITS_PER_TYPE(u64).
> 

Changing it to macro:

#define DIRTY_BITMAP_BYTES(n)   (ALIGN(n, BITS_PER_TYPE(u64)) / 
BITS_PER_BYTE)


>> +}
>> +
>> +static int vfio_dma_bitmap_alloc(struct vfio_dma *dma, unsigned long pgsize)
>> +{
>> +	if (!RB_EMPTY_ROOT(&dma->pfn_list) || dma->iommu_mapped) {
> 
> Yan's patch series allows vendor drivers to dirty pages regardless of
> either of these.  I think we should do away with this an
> unconditionally allocate a bitmap per vfio_dma.
>

Same as above - CPU writes are tracked by KVM core.

>> +		unsigned long npages = dma->size / pgsize;
>> +
>> +		dma->bitmap = kvzalloc(dirty_bitmap_bytes(npages), GFP_KERNEL);
>> +		if (!dma->bitmap)
>> +			return -ENOMEM;
>> +	}
>> +	return 0;
>> +}
>> +
>> +static int vfio_dma_all_bitmap_alloc(struct vfio_iommu *iommu,
>> +				     unsigned long pgsize)
>> +{
>> +	struct rb_node *n = rb_first(&iommu->dma_list);
>> +	int ret;
>> +
>> +	for (; n; n = rb_next(n)) {
>> +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
>> +		struct rb_node *n;
>> +
>> +		ret = vfio_dma_bitmap_alloc(dma, pgsize);
>> +		if (ret) {
>> +			struct rb_node *p = rb_prev(n);
>> +
>> +			for (; p; p = rb_prev(p)) {
>> +				struct vfio_dma *dma = rb_entry(n,
>> +							struct vfio_dma, node);
>> +
>> +				kfree(dma->bitmap);
>> +				dma->bitmap = NULL;
>> +			}
>> +			return ret;
>> +		}
>> +
>> +		if (!dma->bitmap)
>> +			continue;
>> +
>> +		for (n = rb_first(&dma->pfn_list); n; n = rb_next(n)) {
>> +			struct vfio_pfn *vpfn = rb_entry(n, struct vfio_pfn,
>> +							 node);
>> +
>> +			bitmap_set(dma->bitmap,
>> +				   (vpfn->iova - dma->iova) / pgsize, 1);
>> +		}
>> +	}
>> +	return 0;
>> +}
>> +
>> +static void vfio_dma_all_bitmap_free(struct vfio_iommu *iommu)
>> +{
>> +	struct rb_node *n = rb_first(&iommu->dma_list);
>> +
>> +	for (; n; n = rb_next(n)) {
>> +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
>> +
>> +		kfree(dma->bitmap);
>> +		dma->bitmap = NULL;
>> +	}
>> +}
>> +
>>   /*
>>    * Helper Functions for host iova-pfn list
>>    */
>> @@ -254,12 +327,16 @@ static struct vfio_pfn *vfio_iova_get_vfio_pfn(struct vfio_dma *dma,
>>   	return vpfn;
>>   }
>>   
>> -static int vfio_iova_put_vfio_pfn(struct vfio_dma *dma, struct vfio_pfn *vpfn)
>> +static int vfio_iova_put_vfio_pfn(struct vfio_dma *dma, struct vfio_pfn *vpfn,
>> +				  bool do_tracking, unsigned long pgsize)
>>   {
>>   	int ret = 0;
>>   
>>   	vpfn->ref_count--;
>>   	if (!vpfn->ref_count) {
>> +		if (do_tracking && dma->bitmap)
>> +			bitmap_set(dma->bitmap,
>> +				   (vpfn->iova - dma->iova) / pgsize, 1);
> 
> This seems wrong, or at best redundant.  The dirty bitmap should always
> reflect all outstanding pinned pages.  When ref_count drops to zero we
> can stop tracking it, but it should already be set in the bitmap and we
> shouldn't need to do anything here.
> 

Yes, this is redundant. Removing it.

>>   		ret = put_pfn(vpfn->pfn, dma->prot);
>>   		vfio_remove_from_pfn_list(dma, vpfn);
>>   	}
>> @@ -484,7 +561,8 @@ static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
>>   }
>>   
>>   static int vfio_unpin_page_external(struct vfio_dma *dma, dma_addr_t iova,
>> -				    bool do_accounting)
>> +				    bool do_accounting, bool do_tracking,
>> +				    unsigned long pgsize)
>>   {
>>   	int unlocked;
>>   	struct vfio_pfn *vpfn = vfio_find_vpfn(dma, iova);
>> @@ -492,7 +570,7 @@ static int vfio_unpin_page_external(struct vfio_dma *dma, dma_addr_t iova,
>>   	if (!vpfn)
>>   		return 0;
>>   
>> -	unlocked = vfio_iova_put_vfio_pfn(dma, vpfn);
>> +	unlocked = vfio_iova_put_vfio_pfn(dma, vpfn, do_tracking, pgsize);
> 
> This is the only use of do_tracking, which as discussed above shouldn't
> need to be done in this function, thus we shouldn't need to pass pgsize
> either.
> 

Right changing all calls to vfio_iova_put_vfio_pfn()

>>   
>>   	if (do_accounting)
>>   		vfio_lock_acct(dma, -unlocked, true);
>> @@ -563,9 +641,26 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>>   
>>   		ret = vfio_add_to_pfn_list(dma, iova, phys_pfn[i]);
>>   		if (ret) {
>> -			vfio_unpin_page_external(dma, iova, do_accounting);
>> +			vfio_unpin_page_external(dma, iova, do_accounting,
>> +						 false, 0);
> 
> I might use PAGE_SIZE here rather than 0 just for sanity, but as above
> we don't need these extra args.
> 
>>   			goto pin_unwind;
>>   		}
>> +
>> +		if (iommu->dirty_page_tracking) {
> 
> If we unconditionally allocated the bitmap, we could just test
> dma->bitmap here and get rid of the allocation branch below (we'll need
> to allocate the bitmap with the vfio_dma if new mappings are created
> while dirty tracking is enabled though).
> 
>> +			unsigned long pgshift =
>> +					 __ffs(vfio_pgsize_bitmap(iommu));
> 
> Maybe a follow-up patch could cache this, it can only potentially
> change as each new group is added.  We'd probably want to deny adding a
> group if the minimum pagesize changed while dirty tracking is enabled.
> 
>> +
>> +			if (!dma->bitmap) {
>> +				ret = vfio_dma_bitmap_alloc(dma, 1 << pgshift);
>> +				if (ret) {
>> +					vfio_unpin_page_external(dma, iova,
>> +						 do_accounting, false, 0);
>> +					goto pin_unwind;
>> +				}
>> +			}
>> +			bitmap_set(dma->bitmap,
>> +				   (vpfn->iova - dma->iova) >> pgshift, 1);
>> +		}
>>   	}
>>   
>>   	ret = i;
>> @@ -578,7 +673,7 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>>   
>>   		iova = user_pfn[j] << PAGE_SHIFT;
>>   		dma = vfio_find_dma(iommu, iova, PAGE_SIZE);
>> -		vfio_unpin_page_external(dma, iova, do_accounting);
>> +		vfio_unpin_page_external(dma, iova, do_accounting, false, 0);
> 
> Unneeded.
> 
>>   		phys_pfn[j] = 0;
>>   	}
>>   pin_done:
>> @@ -612,7 +707,8 @@ static int vfio_iommu_type1_unpin_pages(void *iommu_data,
>>   		dma = vfio_find_dma(iommu, iova, PAGE_SIZE);
>>   		if (!dma)
>>   			goto unpin_exit;
>> -		vfio_unpin_page_external(dma, iova, do_accounting);
>> +		vfio_unpin_page_external(dma, iova, do_accounting,
>> +					 iommu->dirty_page_tracking, PAGE_SIZE);
> 
> Same.
> 
>>   	}
>>   
>>   unpin_exit:
>> @@ -800,6 +896,7 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
>>   	vfio_unmap_unpin(iommu, dma, true);
>>   	vfio_unlink_dma(iommu, dma);
>>   	put_task_struct(dma->task);
>> +	kfree(dma->bitmap);
>>   	kfree(dma);
>>   	iommu->dma_avail++;
>>   }
>> @@ -830,6 +927,54 @@ static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu)
>>   	return bitmap;
>>   }
>>   
>> +static int vfio_iova_dirty_bitmap(struct vfio_iommu *iommu, dma_addr_t iova,
>> +				  size_t size, uint64_t pgsize,
>> +				  unsigned char __user *bitmap)
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
>> +
>> +	npages = dma->size >> pgshift;
>> +	bitmap_size = dirty_bitmap_bytes(npages);
>> +
>> +	/* mark all pages dirty if all pages are pinned and mapped. */
>> +	if (dma->iommu_mapped)
>> +		bitmap_set(dma->bitmap, 0, npages);
> 
> Oops, we only test if dma->bitmap exists below.  Always allocating the
> bitmap would resolve this too.
> 
>> +
>> +	if (dma->bitmap) {
>> +		if (copy_to_user((void __user *)bitmap, dma->bitmap,
>> +				 bitmap_size))
>> +			return -EFAULT;
>> +
>> +		memset(dma->bitmap, 0, bitmap_size);
> 
> Nope, we need to reprocess the bitmap to set all pinned pages as dirty
> again.  Those need to be reported _every_ time the user asks for the
> bitmap overlapping them.  We consider them to be continuously dirtied.
> 
>> +	}
>> +	return 0;
>> +}
>> +
>> +static int verify_bitmap_size(unsigned long npages, unsigned long bitmap_size)
>> +{
>> +	long bsize;
>> +
>> +	if (!bitmap_size || bitmap_size > SIZE_MAX)
>> +		return -EINVAL;
> 
> bitmap_size should be a size_t if we're going to compare it to
> SIZE_MAX.  bsize and the return of dirty_bitmap_bytes() should probably
> also be a size_t.
> 

changing all parameters to uint64_t to be consistent with uapi and 
compare with UINT_MAX.

>> +
>> +	bsize = dirty_bitmap_bytes(npages);
>> +
>> +	if (bitmap_size < bsize)
>> +		return -EINVAL;
>> +
>> +	return 0;
>> +}
>> +
>>   static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>   			     struct vfio_iommu_type1_dma_unmap *unmap)
>>   {
>> @@ -2277,6 +2422,92 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>>   
>>   		return copy_to_user((void __user *)arg, &unmap, minsz) ?
>>   			-EFAULT : 0;
>> +	} else if (cmd == VFIO_IOMMU_DIRTY_PAGES) {
>> +		struct vfio_iommu_type1_dirty_bitmap dirty;
>> +		uint32_t mask = VFIO_IOMMU_DIRTY_PAGES_FLAG_START |
>> +				VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP |
>> +				VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP;
>> +		int ret;
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
>> +			unsigned long iommu_pgsize =
>> +					1 << __ffs(vfio_pgsize_bitmap(iommu));
>> +
>> +			mutex_lock(&iommu->lock);
>> +			ret = vfio_dma_all_bitmap_alloc(iommu, iommu_pgsize);
>> +			if (!ret)
>> +				iommu->dirty_page_tracking = true;
>> +			mutex_unlock(&iommu->lock);
>> +			return ret;
> 
> If a user called this more than once we'd re-allocate all the bitmaps
> and leak the previous ones.  Let's avoid that by testing
> dirty_page_tracking before we actually take any action.  Do we want to
> return error or success though if dirty tracking is already enabled?
> I'm inclined to say success because we've provided no means for the
> user to check the status.

Success seems better.

Thanks,
Kirti

> 
>> +		} else if (dirty.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP) {
>> +			mutex_lock(&iommu->lock);
>> +			if (iommu->dirty_page_tracking) {
>> +				iommu->dirty_page_tracking = false;
>> +				vfio_dma_all_bitmap_free(iommu);
>> +			}
>> +			mutex_unlock(&iommu->lock);
>> +			return 0;
> 
> This one essentially does what I'm suggesting above already.  Repeated
> calls take no additional action and don't return an error.
> 
>> +		} else if (dirty.flags &
>> +				 VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP) {
>> +			struct vfio_iommu_type1_dirty_bitmap_get range;
>> +			unsigned long pgshift;
>> +			size_t data_size = dirty.argsz - minsz;
>> +			uint64_t iommu_pgsize =
>> +					 1 << __ffs(vfio_pgsize_bitmap(iommu));
>> +
>> +			if (!data_size || data_size < sizeof(range))
>> +				return -EINVAL;
>> +
>> +			if (copy_from_user(&range, (void __user *)(arg + minsz),
>> +					   sizeof(range)))
>> +				return -EFAULT;
>> +
>> +			// allow only min supported pgsize
> 
> Proper comment style please.
> 
>> +			if (range.pgsize != iommu_pgsize)
>> +				return -EINVAL;
>> +			if (range.iova & (iommu_pgsize - 1))
>> +				return -EINVAL;
>> +			if (!range.size || range.size & (iommu_pgsize - 1))
>> +				return -EINVAL;
>> +			if (range.iova + range.size < range.iova)
>> +				return -EINVAL;
>> +			if (!access_ok((void __user *)range.bitmap,
>> +				       range.bitmap_size))
>> +				return -EINVAL;
>> +
>> +			pgshift = __ffs(range.pgsize);
>> +			ret = verify_bitmap_size(range.size >> pgshift,
>> +						 range.bitmap_size);
>> +			if (ret)
>> +				return ret;
>> +
>> +			mutex_lock(&iommu->lock);
>> +			if (iommu->dirty_page_tracking)
>> +				ret = vfio_iova_dirty_bitmap(iommu, range.iova,
>> +					 range.size, range.pgsize,
>> +					 (unsigned char __user *)range.bitmap);
>> +			else
>> +				ret = -EINVAL;
>> +			mutex_unlock(&iommu->lock);
>> +
>> +			return ret;
>> +		}
>>   	}
>>   
>>   	return -ENOTTY;
> 
