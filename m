Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BCE91DB7E9
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 17:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbgETPQx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 11:16:53 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:12828 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbgETPQx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 11:16:53 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ec549960000>; Wed, 20 May 2020 08:15:34 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 20 May 2020 08:16:53 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 20 May 2020 08:16:53 -0700
Received: from [10.40.103.233] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 20 May
 2020 15:16:44 +0000
Subject: Re: [PATCH Kernel v22 6/8] vfio iommu: Update UNMAP_DMA ioctl to get
 dirty bitmap before unmap
To:     Cornelia Huck <cohuck@redhat.com>
CC:     <alex.williamson@redhat.com>, <cjia@nvidia.com>,
        <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <yan.y.zhao@intel.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
References: <1589781397-28368-7-git-send-email-kwankhede@nvidia.com>
 <1589871253-10650-1-git-send-email-kwankhede@nvidia.com>
 <20200520122738.351985a3.cohuck@redhat.com>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <fedde2aa-5a07-aa17-19ee-c8593b9aa730@nvidia.com>
Date:   Wed, 20 May 2020 20:46:39 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200520122738.351985a3.cohuck@redhat.com>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1589987734; bh=UJ9vV+YnL/NN4PI8KUO0yTGEg1V53ovlglfGsOtXyH4=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=EhYqs4zpl3mrgJKrTx0fOzycSqqfA200Z86tgfVl3Fbn5IiPRa1FmaoSucFOYfk8Y
         f+jXnpxcXrwX8DvQbzOfak/noS0xJYNLq6RQ9BZxFuoqGo23PVx7lowlMBpEJFvf+G
         Eitb3aBJt6nfnsJxo+bTVcGCPq7yvfp7sVwQ5yMvwzyKJ9BugiPNbjt7ZHBje6FTwR
         uS7kfAq/DOR4IXldqgnxJCtoNp+IEmU+IOFyMq2LlxkIinb0G53aVl8AWo3rxeuT2D
         8NxKy9nEHoylkAEqPrUIvNXGVLnbx0WCZsXUArGWmTx8TijzBCzeE8XU4SKmElNjbT
         TdsS50pXWFLKA==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/20/2020 3:57 PM, Cornelia Huck wrote:
> On Tue, 19 May 2020 12:24:13 +0530
> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> 
>> DMA mapped pages, including those pinned by mdev vendor drivers, might
>> get unpinned and unmapped while migration is active and device is still
>> running. For example, in pre-copy phase while guest driver could access
>> those pages, host device or vendor driver can dirty these mapped pages.
>> Such pages should be marked dirty so as to maintain memory consistency
>> for a user making use of dirty page tracking.
>>
>> To get bitmap during unmap, user should allocate memory for bitmap, set
>> it all zeros, set size of allocated memory, set page size to be
>> considered for bitmap and set flag VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP.
>>
>> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
>> Reviewed-by: Neo Jia <cjia@nvidia.com>
>> ---
>>   drivers/vfio/vfio_iommu_type1.c | 62 +++++++++++++++++++++++++++++++++--------
>>   include/uapi/linux/vfio.h       | 10 +++++++
>>   2 files changed, 61 insertions(+), 11 deletions(-)
> 
> (...)
> 
>> @@ -1085,6 +1093,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>   			ret = -EINVAL;
>>   			goto unlock;
>>   		}
>> +
> 
> Nit: unrelated whitespace change.
> 
>>   		dma = vfio_find_dma(iommu, unmap->iova + unmap->size - 1, 0);
>>   		if (dma && dma->iova + dma->size != unmap->iova + unmap->size) {
>>   			ret = -EINVAL;
> 
> (...)
> 
>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> index 4850c1fef1f8..a1dd2150971e 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
>> @@ -1048,12 +1048,22 @@ struct vfio_bitmap {
>>    * field.  No guarantee is made to the user that arbitrary unmaps of iova
>>    * or size different from those used in the original mapping call will
>>    * succeed.
>> + * VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP should be set to get dirty bitmap
> 
> s/dirty bitmap/the dirty bitmap/
> 
>> + * before unmapping IO virtual addresses. When this flag is set, user must
> 
> s/user/the user/
> 
>> + * provide data[] as structure vfio_bitmap. User must allocate memory to get
> 
> "provide a struct vfio_bitmap in data[]" ?
> 
> 
>> + * bitmap, zero the bitmap memory and must set size of allocated memory in
>> + * vfio_bitmap.size field.
> 
> "The user must provide zero-allocated memory via vfio_bitmap.data and
> its size in the vfio_bitmap.size field." ?
> 
> 
>> A bit in bitmap represents one page of user provided
> 
> s/bitmap/the bitmap/
> 
>> + * page size in 'pgsize', consecutively starting from iova offset. Bit set
> 
> s/Bit set/A set bit/
> 
>> + * indicates page at that offset from iova is dirty. Bitmap of pages in the
> 
> s/indicates page/indicates that the page/
> 
>> + * range of unmapped size is returned in vfio_bitmap.data
> 
> "A bitmap of the pages in the range of the unmapped size is returned in
> the user-provided vfio_bitmap.data." ?
> 
>>    */
>>   struct vfio_iommu_type1_dma_unmap {
>>   	__u32	argsz;
>>   	__u32	flags;
>> +#define VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP (1 << 0)
>>   	__u64	iova;				/* IO virtual address */
>>   	__u64	size;				/* Size of mapping (bytes) */
>> +	__u8    data[];
>>   };
>>   
>>   #define VFIO_IOMMU_UNMAP_DMA _IO(VFIO_TYPE, VFIO_BASE + 14)
> 
> With the nits addressed,

Done.

> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> 

Thanks.

Kirti
