Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18D7D134C43
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 21:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbgAHUBd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 15:01:33 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:4829 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbgAHUBc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jan 2020 15:01:32 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e1635090001>; Wed, 08 Jan 2020 12:01:13 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 08 Jan 2020 12:01:31 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 08 Jan 2020 12:01:31 -0800
Received: from [10.40.100.122] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 8 Jan
 2020 20:01:21 +0000
Subject: Re: [PATCH v11 Kernel 3/6] vfio iommu: Implementation of ioctl to for
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
References: <1576602651-15430-1-git-send-email-kwankhede@nvidia.com>
 <1576602651-15430-4-git-send-email-kwankhede@nvidia.com>
 <20191217151203.342b686a@x1.home>
 <ebd08133-e258-9f5e-5c8f-f88d7165cd7a@nvidia.com>
 <20200107150223.0dab0a85@w520.home>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <d2faa3fe-d656-5ba7-475a-9646298e3d50@nvidia.com>
Date:   Thu, 9 Jan 2020 01:31:16 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200107150223.0dab0a85@w520.home>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1578513673; bh=rTykfQvHrYyZEKPRHyxOkgPV3jZF1IBbSkNxe8rRI00=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=JRUkTTrODWi0sqv4gM+cKkB8qX5heeiXizMBXjXFl75h3ScFobcdf7MdoI4bo+Fev
         E9//6AJCE3XFe3J/w162chY/fOzEmLIQfHzrGlHqbBxCw1+Gx8s9nunB1MQnGbE3Wf
         GkmFvAjgPlK06PnWKm/mZlbigcKtcr804w443zCnGTneo4xRo4LZSvS3G3HGLaPzDo
         CpixS4FLZnD5Yob0p/DkF9jzdhQzxDV8fl38h1XyyLiJ5Xaa1+rVKdSQyoKZi6zpDH
         kf/dzwa8N9c3FfXMFZMLwXLwS296fd6q0jOZe4cSMce/8sHd3LiTdIMMcQiACeP1Xm
         FcWQNKhiLTMHA==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/8/2020 3:32 AM, Alex Williamson wrote:
> On Wed, 8 Jan 2020 01:37:03 +0530
> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> 

<snip>

>>>> +
>>>> +	unlocked = vfio_iova_put_vfio_pfn(dma, vpfn, dirty_tracking);
>>>>    
>>>>    	if (do_accounting)
>>>>    		vfio_lock_acct(dma, -unlocked, true);
>>>> @@ -571,8 +606,12 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>>>>    
>>>>    		vpfn = vfio_iova_get_vfio_pfn(dma, iova);
>>>>    		if (vpfn) {
>>>> -			phys_pfn[i] = vpfn->pfn;
>>>> -			continue;
>>>> +			if (vpfn->unpinned)
>>>> +				vfio_remove_from_pfn_list(dma, vpfn);
>>>
>>> This seems inefficient, we have an allocated vpfn at the right places
>>> in the list, wouldn't it be better to repin the page?
>>>    
>>
>> vfio_pin_page_external() takes care of pinning and accounting as well.
> 
> Yes, but could we call vfio_pin_page_external() without {unlinking,
> freeing} and {re-allocating, linking} on either side of it since it's
> already in the list?  That's the inefficient part.  Maybe at least a
> TODO comment?
> 

Changing it as below:

                 vpfn = vfio_iova_get_vfio_pfn(dma, iova);
                 if (vpfn) {
-                       phys_pfn[i] = vpfn->pfn;
-                       continue;
+                       if (vpfn->ref_count > 1) {
+                               phys_pfn[i] = vpfn->pfn;
+                               continue;
+                       }
                 }

                 remote_vaddr = dma->vaddr + iova - dma->iova;
                 ret = vfio_pin_page_external(dma, remote_vaddr, 
&phys_pfn[i],
                                              do_accounting);
                 if (ret)
                         goto pin_unwind;
-
-               ret = vfio_add_to_pfn_list(dma, iova, phys_pfn[i]);
-               if (ret) {
-                       vfio_unpin_page_external(dma, iova, do_accounting);
-                       goto pin_unwind;
-               }
+               if (!vpfn) {
+                       ret = vfio_add_to_pfn_list(dma, iova, phys_pfn[i]);
+                       if (ret) {
+                               vfio_unpin_page_external(dma, iova,
+                                                        do_accounting, 
false);
+                               goto pin_unwind;
+                       }
+               } else
+                       vpfn->pfn = phys_pfn[i];
         }




>>>> +			else {
>>>> +				phys_pfn[i] = vpfn->pfn;
>>>> +				continue;
>>>> +			}
>>>>    		}
>>>>    
>>>>    		remote_vaddr = dma->vaddr + iova - dma->iova;
>>>> @@ -583,7 +622,8 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>>>>    
>>>>    		ret = vfio_add_to_pfn_list(dma, iova, phys_pfn[i]);
>>>>    		if (ret) {
>>>> -			vfio_unpin_page_external(dma, iova, do_accounting);
>>>> +			vfio_unpin_page_external(dma, iova, do_accounting,
>>>> +						 false);
>>>>    			goto pin_unwind;
>>>>    		}
>>>>    	}

<snip>

>>
>>>> +		if (range.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_START) {
>>>> +			iommu->dirty_page_tracking = true;
>>>> +			return 0;
>>>> +		} else if (range.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP) {
>>>> +			iommu->dirty_page_tracking = false;
>>>> +
>>>> +			mutex_lock(&iommu->lock);
>>>> +			vfio_remove_unpinned_from_dma_list(iommu);
>>>> +			mutex_unlock(&iommu->lock);
>>>> +			return 0;
>>>> +
>>>> +		} else if (range.flags &
>>>> +				 VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP) {
>>>> +			uint64_t iommu_pgmask;
>>>> +			unsigned long pgshift = __ffs(range.pgsize);
>>>> +			unsigned long *bitmap;
>>>> +			long bsize;
>>>> +
>>>> +			iommu_pgmask =
>>>> +			 ((uint64_t)1 << __ffs(vfio_pgsize_bitmap(iommu))) - 1;
>>>> +
>>>> +			if (((range.pgsize - 1) & iommu_pgmask) !=
>>>> +			    (range.pgsize - 1))
>>>> +				return -EINVAL;
>>>> +
>>>> +			if (range.iova & iommu_pgmask)
>>>> +				return -EINVAL;
>>>> +			if (!range.size || range.size > SIZE_MAX)
>>>> +				return -EINVAL;
>>>> +			if (range.iova + range.size < range.iova)
>>>> +				return -EINVAL;
>>>> +
>>>> +			bsize = verify_bitmap_size(range.size >> pgshift,
>>>> +						   range.bitmap_size);
>>>> +			if (bsize < 0)
>>>> +				return ret;
>>>> +
>>>> +			bitmap = kmalloc(bsize, GFP_KERNEL);
>>>
>>> I think I remember mentioning previously that we cannot allocate an
>>> arbitrary buffer on behalf of the user, it's far too easy for them to
>>> kill the kernel that way.  kmalloc is also limited in what it can
>>> alloc.
>>
>> That's the reason added verify_bitmap_size(), so that size is verified
> 
> That's only a consistency test, it only verifies that the user claims
> to provide a bitmap sized sufficiently for the range they're trying to
> request.  range.size is limited to SIZE_MAX, so 2^64, divided by page
> size for 2^52 bits, 8bits per byte for 2^49 bytes of bitmap that we'd
> try to kmalloc (512TB).  kmalloc is good for a couple MB AIUI.
> Meanwhile the user doesn't actually need to allocate that bitmap in
> order to crash the kernel.
> 
>>> Can't we use the user buffer directly or only work on a part of
>>> it at a time?
>>>    
>>
>> without copy_from_user(), how?
> 
> For starters, what's the benefit of copying the bitmap from the user
> in the first place?  We presume the data is zero'd and if it's not,
> that's the user's bug to sort out (we just need to define the API to
> specify that).  Therefore the copy_from_user() is unnecessary anyway and
> we really just need to copy_to_user() for any places we're setting
> bits.  We could just walk through the range with an unsigned long
> bitmap buffer, writing it out to userspace any time we reach the end
> with bits set, zeroing it and shifting it as a window to the user
> buffer.  We could improve batching by allocating a larger buffer in the
> kernel, with a kernel defined maximum size and performing the same
> windowing scheme.
> 

Ok removing copy_from_user().
But AFAIK, calling copy_to_user() multiple times is not efficient in 
terms of performance.

Checked code in virt/kvm/kvm_main.c: __kvm_set_memory_region() where 
dirty_bitmap is allocated, that has generic checks, user space address 
check, memory overflow check and KVM_MEM_MAX_NR_PAGES as below. I'll add 
access_ok check. I already added overflow check.

         /* General sanity checks */
         if (mem->memory_size & (PAGE_SIZE - 1))
                 goto out;

        !access_ok((void __user *)(unsigned long)mem->userspace_addr,
                         mem->memory_size)))

         if (mem->guest_phys_addr + mem->memory_size < mem->guest_phys_addr)
                 goto out;

         if (npages > KVM_MEM_MAX_NR_PAGES)
                 goto out;


Where KVM_MEM_MAX_NR_PAGES is:

/*
  * Some of the bitops functions do not support too long bitmaps.
  * This number must be determined not to exceed such limits.
  */
#define KVM_MEM_MAX_NR_PAGES ((1UL << 31) - 1)

But we can't use KVM specific KVM_MEM_MAX_NR_PAGES check in vfio module.
Should we define similar limit in vfio module instead of SIZE_MAX?

> I don't know if there's a way to directly map the user buffer rather
> than copy_to_user(), but I thought I'd ask in case there's some obvious
> efficiency improvement to be had there.
> 
>>>> +			if (!bitmap)
>>>> +				return -ENOMEM;
>>>> +
>>>> +			ret = copy_from_user(bitmap,
>>>> +			     (void __user *)range.bitmap, bsize) ? -EFAULT : 0;
>>>> +			if (ret)
>>>> +				goto bitmap_exit;
>>>> +
>>>> +			iommu->dirty_page_tracking = false;
>>>
>>> a) This is done outside of the mutex and susceptible to races,
>>
>> moving inside lock
>>
>>> b) why is this done?
>> once bitmap is read, dirty_page_tracking should be stopped. Right?
> 
> Absolutely not.  Dirty bit page tracking should remain enabled until
> the user turns it off, doing otherwise precludes both iterative and
> partial dirty page collection from userspace.  I think both of those
> are fundamentally required of this interface.  Thanks,
> 

OK.

Thanks,
Kirti
