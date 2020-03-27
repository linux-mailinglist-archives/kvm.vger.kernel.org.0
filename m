Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 850ED19501E
	for <lists+kvm@lfdr.de>; Fri, 27 Mar 2020 05:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbgC0EnF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Mar 2020 00:43:05 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:1530 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbgC0EnE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Mar 2020 00:43:04 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e7d844a0000>; Thu, 26 Mar 2020 21:42:51 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 26 Mar 2020 21:43:04 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 26 Mar 2020 21:43:04 -0700
Received: from [10.40.103.35] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 27 Mar
 2020 04:42:49 +0000
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
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <b6524b4a-e6a0-7328-5003-7286f2fd61a8@nvidia.com>
Date:   Fri, 27 Mar 2020 10:12:43 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200327000426.GA26419@joy-OptiPlex-7040>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1585284171; bh=/eY4Cemp7k65d1UPvele9vg+mEFz5dD6zNLRY1EZk+M=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=bpH+uPvEyUV9/yopyYsw/ETv09Dfm7eNzbeuiHMbX9QJRDDqXS0nJJ/8/vlPKXphk
         QwL/ndoLw0bB/2UePXTELBAsIQ/tg0TqM75KuOfkUo9dlOF8UFk51oRawBGOOiq9jb
         Epy37JFPJW44MZDMU9fi3CUMHbW4oeA3Jz1wVm79syRAkY5AFekpgViL9aGNsyyMjW
         ak10pYyaVtO9EHsphoCHX4PtpbZSGvAIGSCKKNi7tIw+50abG5J4I/j+szCs1t/L5O
         qOwXQLpdzR2cwQ9NTXMaC4kqgfmi+67fcftNG6+PHqgKjlXL8UWrlgT+tvYO4LysxF
         2LEyGwOnrxf1A==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/27/2020 5:34 AM, Yan Zhao wrote:
> On Fri, Mar 27, 2020 at 05:39:44AM +0800, Kirti Wankhede wrote:
>>
>>
>> On 3/25/2020 7:48 AM, Yan Zhao wrote:
>>> On Wed, Mar 25, 2020 at 03:32:37AM +0800, Kirti Wankhede wrote:
>>>> DMA mapped pages, including those pinned by mdev vendor drivers, might
>>>> get unpinned and unmapped while migration is active and device is still
>>>> running. For example, in pre-copy phase while guest driver could access
>>>> those pages, host device or vendor driver can dirty these mapped pages.
>>>> Such pages should be marked dirty so as to maintain memory consistency
>>>> for a user making use of dirty page tracking.
>>>>
>>>> To get bitmap during unmap, user should allocate memory for bitmap, set
>>>> size of allocated memory, set page size to be considered for bitmap and
>>>> set flag VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP.
>>>>
>>>> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
>>>> Reviewed-by: Neo Jia <cjia@nvidia.com>
>>>> ---
>>>>    drivers/vfio/vfio_iommu_type1.c | 54 ++++++++++++++++++++++++++++++++++++++---
>>>>    include/uapi/linux/vfio.h       | 10 ++++++++
>>>>    2 files changed, 60 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>>>> index 27ed069c5053..b98a8d79e13a 100644
>>>> --- a/drivers/vfio/vfio_iommu_type1.c
>>>> +++ b/drivers/vfio/vfio_iommu_type1.c
>>>> @@ -982,7 +982,8 @@ static int verify_bitmap_size(uint64_t npages, uint64_t bitmap_size)
>>>>    }
>>>>    
>>>>    static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>>> -			     struct vfio_iommu_type1_dma_unmap *unmap)
>>>> +			     struct vfio_iommu_type1_dma_unmap *unmap,
>>>> +			     struct vfio_bitmap *bitmap)
>>>>    {
>>>>    	uint64_t mask;
>>>>    	struct vfio_dma *dma, *dma_last = NULL;
>>>> @@ -1033,6 +1034,10 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>>>    	 * will be returned if these conditions are not met.  The v2 interface
>>>>    	 * will only return success and a size of zero if there were no
>>>>    	 * mappings within the range.
>>>> +	 *
>>>> +	 * When VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP flag is set, unmap request
>>>> +	 * must be for single mapping. Multiple mappings with this flag set is
>>>> +	 * not supported.
>>>>    	 */
>>>>    	if (iommu->v2) {
>>>>    		dma = vfio_find_dma(iommu, unmap->iova, 1);
>>>> @@ -1040,6 +1045,13 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>>>    			ret = -EINVAL;
>>>>    			goto unlock;
>>>>    		}
>>>> +
>>>> +		if ((unmap->flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) &&
>>>> +		    (dma->iova != unmap->iova || dma->size != unmap->size)) {
>>> potential NULL pointer!
>>>
>>> And could you address the comments in v14?
>>> How to handle DSI unmaps in vIOMMU
>>> (https://lore.kernel.org/kvm/20200323011041.GB5456@joy-OptiPlex-7040/)
>>>
>>
>> Sorry, I drafted reply to it, but I missed to send, it remained in my drafts
>>
>>   >
>>   > it happens in vIOMMU Domain level invalidation of IOTLB
>>   > (domain-selective invalidation, see vtd_iotlb_domain_invalidate() in
>> qemu).
>>   > common in VTD lazy mode, and NOT just happening once at boot time.
>>   > rather than invalidate page by page, it batches the page invalidation.
>>   > so, when this invalidation takes place, even higher level page tables
>>   > have been invalid and therefore it has to invalidate a bigger
>> combined range.
>>   > That's why we see IOVAs are mapped in 4k pages, but are unmapped in 2M
>>   > pages.
>>   >
>>   > I think those UNMAPs should also have GET_DIRTY_BIMTAP flag on, right?
>>
>>
>> vtd_iotlb_domain_invalidate()
>>     vtd_sync_shadow_page_table()
>>       vtd_sync_shadow_page_table_range(vtd_as, &ce, 0, UINT64_MAX)
>>         vtd_page_walk()
>>           vtd_page_walk_level() - walk over specific level for IOVA range
>>             vtd_page_walk_one()
>>               memory_region_notify_iommu()
>>               ...
>>                 vfio_iommu_map_notify()
>>
>> In the above trace, isn't page walk will take care of creating proper
>> IOTLB entry which should be same as created during mapping for that
>> IOTLB entry?
>>
> No. It does walk the page table, but as it's dsi (delay & batched unmap),
> pages table entry for a whole 2M (the higher level, not last level for 4K)
> range is invalid, so the iotlb->addr_mask what vfio_iommu_map_notify()
> receives is (2M - 1), not the same as the size for map.
> 

When do this happen? during my testing I never hit this case. How can I 
hit this case?

In this case, will adjacent whole vfio_dmas will be clubbed together or 
will there be any intersection of vfio_dmas?

Thanks,
Kirti
