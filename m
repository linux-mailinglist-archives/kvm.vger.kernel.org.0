Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6584218D838
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 20:14:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbgCTTOp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 15:14:45 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:16792 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgCTTOp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 15:14:45 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e7515f10000>; Fri, 20 Mar 2020 12:13:53 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 20 Mar 2020 12:14:44 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 20 Mar 2020 12:14:44 -0700
Received: from [10.40.103.10] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 20 Mar
 2020 19:14:36 +0000
Subject: Re: [PATCH v14 Kernel 5/7] vfio iommu: Update UNMAP_DMA ioctl to get
 dirty bitmap before unmap
To:     Alex Williamson <alex.williamson@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>
CC:     "cjia@nvidia.com" <cjia@nvidia.com>,
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
References: <1584560474-19946-1-git-send-email-kwankhede@nvidia.com>
 <1584560474-19946-6-git-send-email-kwankhede@nvidia.com>
 <20200320083529.GA5456@joy-OptiPlex-7040> <20200320094039.4d99408d@w520.home>
 <20200320094727.12aba30e@w520.home>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <aa76ad96-394f-f1fb-2e8d-a453bd69a39b@nvidia.com>
Date:   Sat, 21 Mar 2020 00:44:32 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200320094727.12aba30e@w520.home>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1584731633; bh=528tuGcpedSGkPlvPwNWSbpIROZ1laa2lT/gg/YXaIg=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=aP3qc34b+pO7rkgBTMV6FHVu5yDPXmMsbp0Hw6DjgWEVceR8o5u+AlzuzH8zt0PYn
         qHVAzepjDEbp10zcQ7Uo4EY698C2XsR+9j0NmZNGkrs8fKP75cG6UBFgJWpMvHPPL2
         dUgNJN+pHPRuM6fkbU7HArGI/eJwB+YN2cpO4QSzxWqZ4WAn96X7HL6v9qKYiutpUp
         GEdO8oFhhe2Ml81irlM0T6vVtnzEFyFMB+FQKDuwC2s5SEjcl0ZxHrtrkbfMl2F5IZ
         g5TP76GPTpdm4a1ML5LE7RpS0UjLlgg5U0vGUSVIbnHn029kYdGgHH6QECX3oRtBbm
         ROCG5U1qtpABw==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/20/2020 9:17 PM, Alex Williamson wrote:
> On Fri, 20 Mar 2020 09:40:39 -0600
> Alex Williamson <alex.williamson@redhat.com> wrote:
> 
>> On Fri, 20 Mar 2020 04:35:29 -0400
>> Yan Zhao <yan.y.zhao@intel.com> wrote:
>>
>>> On Thu, Mar 19, 2020 at 03:41:12AM +0800, Kirti Wankhede wrote:
>>>> DMA mapped pages, including those pinned by mdev vendor drivers, might
>>>> get unpinned and unmapped while migration is active and device is still
>>>> running. For example, in pre-copy phase while guest driver could access
>>>> those pages, host device or vendor driver can dirty these mapped pages.
>>>> Such pages should be marked dirty so as to maintain memory consistency
>>>> for a user making use of dirty page tracking.
>>>>
>>>> To get bitmap during unmap, user should set flag
>>>> VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP, bitmap memory should be allocated and
>>>> zeroed by user space application. Bitmap size and page size should be set
>>>> by user application.
>>>>
>>>> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
>>>> Reviewed-by: Neo Jia <cjia@nvidia.com>
>>>> ---
>>>>   drivers/vfio/vfio_iommu_type1.c | 55 ++++++++++++++++++++++++++++++++++++++---
>>>>   include/uapi/linux/vfio.h       | 11 +++++++++
>>>>   2 files changed, 62 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>>>> index d6417fb02174..aa1ac30f7854 100644
>>>> --- a/drivers/vfio/vfio_iommu_type1.c
>>>> +++ b/drivers/vfio/vfio_iommu_type1.c
>>>> @@ -939,7 +939,8 @@ static int verify_bitmap_size(uint64_t npages, uint64_t bitmap_size)
>>>>   }
>>>>   
>>>>   static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>>> -			     struct vfio_iommu_type1_dma_unmap *unmap)
>>>> +			     struct vfio_iommu_type1_dma_unmap *unmap,
>>>> +			     struct vfio_bitmap *bitmap)
>>>>   {
>>>>   	uint64_t mask;
>>>>   	struct vfio_dma *dma, *dma_last = NULL;
>>>> @@ -990,6 +991,10 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>>>   	 * will be returned if these conditions are not met.  The v2 interface
>>>>   	 * will only return success and a size of zero if there were no
>>>>   	 * mappings within the range.
>>>> +	 *
>>>> +	 * When VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP flag is set, unmap request
>>>> +	 * must be for single mapping. Multiple mappings with this flag set is
>>>> +	 * not supported.
>>>>   	 */
>>>>   	if (iommu->v2) {
>>>>   		dma = vfio_find_dma(iommu, unmap->iova, 1);
>>>> @@ -997,6 +1002,13 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>>>   			ret = -EINVAL;
>>>>   			goto unlock;
>>>>   		}
>>>> +
>>>> +		if ((unmap->flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) &&
>>>> +		    (dma->iova != unmap->iova || dma->size != unmap->size)) {
>>> dma is probably NULL here!
>>
>> Yep, I didn't look closely enough there.  This is situated right
>> between the check to make sure we're not bisecting a mapping at the
>> start of the unmap and the check to make sure we're not bisecting a
>> mapping at the end of the unmap.  There's no guarantee that we have a
>> valid pointer here.  The test should be in the while() loop below this
>> code.
> 
> Actually the test could remain here, we can exit here if we can't find
> a dma at the start of the unmap range with the GET_DIRTY_BITMAP flag,
> but we absolutely cannot deref dma without testing it.
> 

In the check above newly added check, if dma is NULL then its an error 
condition, because Unmap requests must fully cover previous mappings, right?

>>> And this restriction on UNMAP would make some UNMAP operations of vIOMMU
>>> fail.
>>>
>>> e.g. below condition indeed happens in reality.
>>> an UNMAP ioctl comes for IOVA range from 0xff800000, of size 0x200000
>>> However, IOVAs in this range are mapped page by page.i.e., dma->size is 0x1000.
>>>
>>> Previous, this UNMAP ioctl could unmap successfully as a whole.
>>
>> What triggers this in the guest?  Note that it's only when using the
>> GET_DIRTY_BITMAP flag that this is restricted.  Does the event you're
>> referring to potentially occur under normal circumstances in that mode?
>> Thanks,
>>

Such unmap would callback vfio_iommu_map_notify() in QEMU. In 
vfio_iommu_map_notify(), unmap is called on same range <iova, 
iotlb->addr_mask + 1> which was used for map. Secondly unmap with bitmap 
will be called only when device state has _SAVING flag set.

Thanks,
Kirti
