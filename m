Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2B9FB92F
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 20:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbfKMTwy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 14:52:54 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:2140 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbfKMTwy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 14:52:54 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dcc5f130000>; Wed, 13 Nov 2019 11:52:51 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 13 Nov 2019 11:52:52 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 13 Nov 2019 11:52:52 -0800
Received: from [10.25.73.195] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 13 Nov
 2019 19:52:43 +0000
Subject: Re: [PATCH v9 Kernel 3/5] vfio iommu: Add ioctl defination to unmap
 IOVA and return dirty bitmap
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
References: <1573578220-7530-1-git-send-email-kwankhede@nvidia.com>
 <1573578220-7530-4-git-send-email-kwankhede@nvidia.com>
 <20191112153017.3c792673@x1.home>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <a148c5e2-ad34-6973-de50-eab472ed38fb@nvidia.com>
Date:   Thu, 14 Nov 2019 01:22:39 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191112153017.3c792673@x1.home>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1573674771; bh=UWaMSLJ54TVIqnRVhxNGYnlM25mNj09herGme3Ijlkg=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=g62Cywuc0+9gj05mvs1mtaO6FbJKrGF9GQ2NFY6GdyYA7MIiJ4dd2j48nfJKDFhPA
         KGp6jt4NeOhV04Lw2R4AVfzdQL8Q7YnSJ4iVynt1oTt/z8oIHAPo7eU6VDC9HX1WBL
         0C11RiMOAtwuqZO9j1Ne24+z6MBJwQVTTX85/XWqaeSnLVLdEDbn0G2D4vSaq9aITo
         P+94dNl4Q4qd3m9jrQqb8hK25s3BKSs8LeA4rXHTCx1/SPpdbFXSySdK6ueXJa6kdS
         ytS9zX+ZAlpO4aC7Prng8F8l1ZOK/l0m5ub7r6ezhW+Zer0PLX+klBRnQqTSYd/HUg
         TkAli7pyJmPVg==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/13/2019 4:00 AM, Alex Williamson wrote:
> On Tue, 12 Nov 2019 22:33:38 +0530
> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> 
>> With vIOMMU, during pre-copy phase of migration, while CPUs are still
>> running, IO virtual address unmap can happen while device still keeping
>> reference of guest pfns. Those pages should be reported as dirty before
>> unmap, so that VFIO user space application can copy content of those pages
>> from source to destination.
>>
>> IOCTL defination added here add bitmap pointer, size and flag. If flag
> 
> definition, adds
> 
>> VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP is set and bitmap memory is allocated
>> and bitmap_size of set, then ioctl will create bitmap of pinned pages and
> 
> s/of/is/
> 
>> then unmap those.
>>
>> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
>> Reviewed-by: Neo Jia <cjia@nvidia.com>
>> ---
>>   include/uapi/linux/vfio.h | 33 +++++++++++++++++++++++++++++++++
>>   1 file changed, 33 insertions(+)
>>
>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> index 6fd3822aa610..72fd297baf52 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
>> @@ -925,6 +925,39 @@ struct vfio_iommu_type1_dirty_bitmap {
>>   
>>   #define VFIO_IOMMU_GET_DIRTY_BITMAP             _IO(VFIO_TYPE, VFIO_BASE + 17)
>>   
>> +/**
>> + * VFIO_IOMMU_UNMAP_DMA_GET_BITMAP - _IOWR(VFIO_TYPE, VFIO_BASE + 18,
>> + *				      struct vfio_iommu_type1_dma_unmap_bitmap)
>> + *
>> + * Unmap IO virtual addresses using the provided struct
>> + * vfio_iommu_type1_dma_unmap_bitmap.  Caller sets argsz.
>> + * VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP should be set to get dirty bitmap
>> + * before unmapping IO virtual addresses. If this flag is not set, only IO
>> + * virtual address are unmapped without creating pinned pages bitmap, that
>> + * is, behave same as VFIO_IOMMU_UNMAP_DMA ioctl.
>> + * User should allocate memory to get bitmap and should set size of allocated
>> + * memory in bitmap_size field. One bit in bitmap is used to represent per page
>> + * consecutively starting from iova offset. Bit set indicates page at that
>> + * offset from iova is dirty.
>> + * The actual unmapped size is returned in the size field and bitmap of pages
>> + * in the range of unmapped size is returned in bitmap if flag
>> + * VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP is set.
>> + *
>> + * No guarantee is made to the user that arbitrary unmaps of iova or size
>> + * different from those used in the original mapping call will succeed.
>> + */
>> +struct vfio_iommu_type1_dma_unmap_bitmap {
>> +	__u32        argsz;
>> +	__u32        flags;
>> +#define VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP (1 << 0)
>> +	__u64        iova;                        /* IO virtual address */
>> +	__u64        size;                        /* Size of mapping (bytes) */
>> +	__u64        bitmap_size;                 /* in bytes */
>> +	void __user *bitmap;                      /* one bit per page */
>> +};
>> +
>> +#define VFIO_IOMMU_UNMAP_DMA_GET_BITMAP _IO(VFIO_TYPE, VFIO_BASE + 18)
>> +
> 
> Why not extend VFIO_IOMMU_UNMAP_DMA to support this rather than add an
> ioctl that duplicates the functionality and extends it?? 

We do want old userspace applications to work with new kernel and 
vice-versa, right?

If I try to change existing VFIO_IOMMU_UNMAP_DMA ioctl structure, say if 
add 'bitmap_size' and 'bitmap' after 'size', with below code in old 
kernel, old kernel & new userspace will work.

         minsz = offsetofend(struct vfio_iommu_type1_dma_unmap, size);

         if (copy_from_user(&unmap, (void __user *)arg, minsz))
                 return -EFAULT;

         if (unmap.argsz < minsz || unmap.flags)
                 return -EINVAL;


With new kernel it would change to:
         minsz = offsetofend(struct vfio_iommu_type1_dma_unmap, bitmap);

         if (copy_from_user(&unmap, (void __user *)arg, minsz))
                 return -EFAULT;

         if (unmap.argsz < minsz || unmap.flags)
                 return -EINVAL;

Then old userspace app will fail because unmap.argsz < minsz and might 
be copy_from_user would cause seg fault because userspace sdk doesn't 
contain new member variables.
We can't change the sequence to keep 'size' as last member, because then 
new userspace app on old kernel will interpret it wrong.

> Otherwise
> same comments as previous, in fact it's too bad we can't use this ioctl
> for both, but a DONT_UNMAP flag on the UNMAP_DMA ioctl seems a bit
> absurd.
> 
> I suspect we also want a flags bit in VFIO_IOMMU_GET_INFO to indicate
> these capabilities are supported.
> 

Ok. I'll add that.

> Maybe for both ioctls we also want to define it as the user's
> responsibility to zero the bitmap, requiring the kernel to only set
> bits as necessary. 

Ok. Updating comment.

Thanks,
Kirti

> Thanks,
> 
> Alex
> 
>>   /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
>>   
>>   /*
> 
