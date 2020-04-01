Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B84EC19B50C
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 20:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732262AbgDASFK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Apr 2020 14:05:10 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:11216 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727723AbgDASFK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Apr 2020 14:05:10 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e84d77b0000>; Wed, 01 Apr 2020 11:03:40 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 01 Apr 2020 11:04:29 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 01 Apr 2020 11:04:29 -0700
Received: from [10.40.163.116] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 1 Apr
 2020 18:04:20 +0000
Subject: Re: [PATCH v16 Kernel 5/7] vfio iommu: Update UNMAP_DMA ioctl to get
 dirty bitmap before unmap
To:     Yan Zhao <yan.y.zhao@intel.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Yang, Ziye" <ziye.yang@intel.com>,
        "Liu, Changpeng" <changpeng.liu@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "eskultet@redhat.com" <eskultet@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "jonathan.davies@nutanix.com" <jonathan.davies@nutanix.com>,
        "eauger@redhat.com" <eauger@redhat.com>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "felipe@nutanix.com" <felipe@nutanix.com>,
        "Zhengxiao.zx@Alibaba-inc.com" <Zhengxiao.zx@Alibaba-inc.com>,
        "shuangtai.tst@alibaba-inc.com" <shuangtai.tst@alibaba-inc.com>,
        "Ken.Xue@amd.com" <Ken.Xue@amd.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <1585078359-20124-1-git-send-email-kwankhede@nvidia.com>
 <1585078359-20124-6-git-send-email-kwankhede@nvidia.com>
 <20200325021800.GC20109@joy-OptiPlex-7040>
 <3cabb357-b9c5-f8b3-5d57-1178ec0dde5a@nvidia.com>
 <20200327000426.GA26419@joy-OptiPlex-7040>
 <b6524b4a-e6a0-7328-5003-7286f2fd61a8@nvidia.com>
 <20200330021506.GC30683@joy-OptiPlex-7040>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <ba44bbd6-aefa-9060-8153-b91b4cfd1404@nvidia.com>
Date:   Wed, 1 Apr 2020 23:34:16 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200330021506.GC30683@joy-OptiPlex-7040>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1585764220; bh=MOnuluRkkIp2V7pG78z5TXRgfKzjDonC+wFs8RG+qvg=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=UmExCIHCWboYryVvMIkf8GSstxBWZtIMIoMRT6RBTwvlVh2GXBKeCOcN/IXfHU06j
         byWUI18ueJgJD7LEVWQP/pf5DCNGfZ+ncfB+EwBlY0DQnSyUm/GuZ0XHlQab+1Lw1B
         cGFP0fi4FL/Tl0GMils3+NNi46ZiyZ6De28DLA7ZopWiPeeEsPeDrWS+YtCBuThb8i
         08kp4XaYO83dEP/Uw1k9cDoBY32n3I6U9zrkBukPsqG/eCg0+K2i/5uQhQiUQxyFT4
         lyvtUkbVhwh/Onrgb8tmrbKntAqOTlFQBzAdM9STe2YKxL8Zl7CdysrJzttzgZn0an
         gevKtL9GZPa+A==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/30/2020 7:45 AM, Yan Zhao wrote:
> On Fri, Mar 27, 2020 at 12:42:43PM +0800, Kirti Wankhede wrote:
>>
>>
>> On 3/27/2020 5:34 AM, Yan Zhao wrote:
>>> On Fri, Mar 27, 2020 at 05:39:44AM +0800, Kirti Wankhede wrote:
>>>>
>>>>
>>>> On 3/25/2020 7:48 AM, Yan Zhao wrote:
>>>>> On Wed, Mar 25, 2020 at 03:32:37AM +0800, Kirti Wankhede wrote:
>>>>>> DMA mapped pages, including those pinned by mdev vendor drivers, might
>>>>>> get unpinned and unmapped while migration is active and device is still
>>>>>> running. For example, in pre-copy phase while guest driver could access
>>>>>> those pages, host device or vendor driver can dirty these mapped pages.
>>>>>> Such pages should be marked dirty so as to maintain memory consistency
>>>>>> for a user making use of dirty page tracking.
>>>>>>
>>>>>> To get bitmap during unmap, user should allocate memory for bitmap, set
>>>>>> size of allocated memory, set page size to be considered for bitmap and
>>>>>> set flag VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP.
>>>>>>
>>>>>> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
>>>>>> Reviewed-by: Neo Jia <cjia@nvidia.com>
>>>>>> ---
>>>>>>     drivers/vfio/vfio_iommu_type1.c | 54 ++++++++++++++++++++++++++++++++++++++---
>>>>>>     include/uapi/linux/vfio.h       | 10 ++++++++
>>>>>>     2 files changed, 60 insertions(+), 4 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>>>>>> index 27ed069c5053..b98a8d79e13a 100644
>>>>>> --- a/drivers/vfio/vfio_iommu_type1.c
>>>>>> +++ b/drivers/vfio/vfio_iommu_type1.c
>>>>>> @@ -982,7 +982,8 @@ static int verify_bitmap_size(uint64_t npages, uint64_t bitmap_size)
>>>>>>     }
>>>>>>     
>>>>>>     static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>>>>> -			     struct vfio_iommu_type1_dma_unmap *unmap)
>>>>>> +			     struct vfio_iommu_type1_dma_unmap *unmap,
>>>>>> +			     struct vfio_bitmap *bitmap)
>>>>>>     {
>>>>>>     	uint64_t mask;
>>>>>>     	struct vfio_dma *dma, *dma_last = NULL;
>>>>>> @@ -1033,6 +1034,10 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>>>>>     	 * will be returned if these conditions are not met.  The v2 interface
>>>>>>     	 * will only return success and a size of zero if there were no
>>>>>>     	 * mappings within the range.
>>>>>> +	 *
>>>>>> +	 * When VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP flag is set, unmap request
>>>>>> +	 * must be for single mapping. Multiple mappings with this flag set is
>>>>>> +	 * not supported.
>>>>>>     	 */
>>>>>>     	if (iommu->v2) {
>>>>>>     		dma = vfio_find_dma(iommu, unmap->iova, 1);
>>>>>> @@ -1040,6 +1045,13 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>>>>>     			ret = -EINVAL;
>>>>>>     			goto unlock;
>>>>>>     		}
>>>>>> +
>>>>>> +		if ((unmap->flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) &&
>>>>>> +		    (dma->iova != unmap->iova || dma->size != unmap->size)) {
>>>>> potential NULL pointer!
>>>>>
>>>>> And could you address the comments in v14?
>>>>> How to handle DSI unmaps in vIOMMU
>>>>> (https://lore.kernel.org/kvm/20200323011041.GB5456@joy-OptiPlex-7040/)
>>>>>
>>>>
>>>> Sorry, I drafted reply to it, but I missed to send, it remained in my drafts
>>>>
>>>>    >
>>>>    > it happens in vIOMMU Domain level invalidation of IOTLB
>>>>    > (domain-selective invalidation, see vtd_iotlb_domain_invalidate() in
>>>> qemu).
>>>>    > common in VTD lazy mode, and NOT just happening once at boot time.
>>>>    > rather than invalidate page by page, it batches the page invalidation.
>>>>    > so, when this invalidation takes place, even higher level page tables
>>>>    > have been invalid and therefore it has to invalidate a bigger
>>>> combined range.
>>>>    > That's why we see IOVAs are mapped in 4k pages, but are unmapped in 2M
>>>>    > pages.
>>>>    >
>>>>    > I think those UNMAPs should also have GET_DIRTY_BIMTAP flag on, right?
>>>>
>>>>
>>>> vtd_iotlb_domain_invalidate()
>>>>      vtd_sync_shadow_page_table()
>>>>        vtd_sync_shadow_page_table_range(vtd_as, &ce, 0, UINT64_MAX)
>>>>          vtd_page_walk()
>>>>            vtd_page_walk_level() - walk over specific level for IOVA range
>>>>              vtd_page_walk_one()
>>>>                memory_region_notify_iommu()
>>>>                ...
>>>>                  vfio_iommu_map_notify()
>>>>
>>>> In the above trace, isn't page walk will take care of creating proper
>>>> IOTLB entry which should be same as created during mapping for that
>>>> IOTLB entry?
>>>>
>>> No. It does walk the page table, but as it's dsi (delay & batched unmap),
>>> pages table entry for a whole 2M (the higher level, not last level for 4K)
>>> range is invalid, so the iotlb->addr_mask what vfio_iommu_map_notify()
>>> receives is (2M - 1), not the same as the size for map.
>>>
>>
>> When do this happen? during my testing I never hit this case. How can I
>> hit this case?
> 
> Just common settings to enable vIOMMU:
> Qemu: -device intel-iommu,caching-mode=true
> guest kernel parameter: intel_iommu=on
> 
> (intel_iommu=on turns on lazy mode by default)
> 
> In lazy mode, guest notifies DMA MAP on page level, but notifies DMA UNMAPs
> in batch.
> with a pass-through NVMe, there are 89 DSI unmaps in 1 second for a typical fio.
> With a pass-through GPU, there 22 DSI unmaps in total for benchmark openArena
> (lasting around 55 secs)
>>
>> In this case, will adjacent whole vfio_dmas will be clubbed together or
>> will there be any intersection of vfio_dmas?
>>
> clubbed together.
> 

Even if support for clubbing bitmap together is added, still there will 
be limitation that clubbed vfio_dmas size shouldn't exceed INT_MAX pages.

Thanks,
Kirti
