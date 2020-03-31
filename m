Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5913E199E54
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 20:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727708AbgCaSq2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 14:46:28 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:8046 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726209AbgCaSq1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 14:46:27 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e838fa20000>; Tue, 31 Mar 2020 11:44:50 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 31 Mar 2020 11:46:27 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 31 Mar 2020 11:46:27 -0700
Received: from [10.40.162.111] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 31 Mar
 2020 18:46:18 +0000
Subject: Re: [PATCH v17 Kernel 5/7] vfio iommu: Update UNMAP_DMA ioctl to get
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
References: <1585587044-2408-1-git-send-email-kwankhede@nvidia.com>
 <1585587044-2408-6-git-send-email-kwankhede@nvidia.com>
 <20200330153421.6246c2c6@w520.home>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <66af06b5-4e87-9f7a-be85-08a68d6ab982@nvidia.com>
Date:   Wed, 1 Apr 2020 00:16:13 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200330153421.6246c2c6@w520.home>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1585680290; bh=iWzduZHbPfAp/fpaS0jcEjAbJwVc7RSEbxv51ssxb+4=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=GAe7CXCcFLpbdEe0Z6rQS9Aw3uM2cOnGPiTMJuU9K4g8ym+NSf/4D3/Knjzaah3qI
         Mbff020O6MmoXnpMhBzgjIYWbJm7uX61roLebl5dXcYkIoahYJD+wgPtY2K2iFTTOI
         PLAls7X/ja/eatyNTXqMKEQ61EyK6IuK4zTucztDvAfFYiXrorx/eNff+KKsO1KnVy
         d2z+77/dbdOzlxLxiNEgpFvSVUcsXPur2M3/c+8c+450+2bSL8atpkTfXHI1l8oJro
         toOFZ6J2YzftnHLrGw7pyZfnHqH6UnhtkT+5kvaFFnytoCx3BpmncQz2nWbEklpq8g
         OIxLNqGRUVJPA==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/31/2020 3:04 AM, Alex Williamson wrote:
> On Mon, 30 Mar 2020 22:20:42 +0530
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
>> size of allocated memory, set page size to be considered for bitmap and
>> set flag VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP.
>>
>> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
>> Reviewed-by: Neo Jia <cjia@nvidia.com>
>> ---
>>   drivers/vfio/vfio_iommu_type1.c | 55 ++++++++++++++++++++++++++++++++++++++---
>>   include/uapi/linux/vfio.h       | 10 ++++++++
>>   2 files changed, 61 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 5efebc2b60e1..266550bd7307 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -983,7 +983,8 @@ static int verify_bitmap_size(uint64_t npages, uint64_t bitmap_size)
>>   }
>>   
>>   static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>> -			     struct vfio_iommu_type1_dma_unmap *unmap)
>> +			     struct vfio_iommu_type1_dma_unmap *unmap,
>> +			     struct vfio_bitmap *bitmap)
>>   {
>>   	uint64_t mask;
>>   	struct vfio_dma *dma, *dma_last = NULL;
>> @@ -1034,6 +1035,10 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>   	 * will be returned if these conditions are not met.  The v2 interface
>>   	 * will only return success and a size of zero if there were no
>>   	 * mappings within the range.
>> +	 *
>> +	 * When VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP flag is set, unmap request
>> +	 * must be for single mapping. Multiple mappings with this flag set is
>> +	 * not supported.
>>   	 */
>>   	if (iommu->v2) {
>>   		dma = vfio_find_dma(iommu, unmap->iova, 1);
>> @@ -1041,6 +1046,14 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>   			ret = -EINVAL;
>>   			goto unlock;
>>   		}
>> +
>> +		if ((unmap->flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) &&
>> +		    dma &&
>> +		    (dma->iova != unmap->iova || dma->size != unmap->size)) {
> 
> 
> I think your intention was to return error if the user asked for the
> dirty bitmap and the requested unmap range doesn't exactly match the
> vfio_dma.  Not finding a vfio_dma should therefore also be an error.
> For example, if we had a single mapping at {0x1000-0x1fff} and the user
> unmapped with dirty bitmap {0x0-0x2fff}, that should return an error,
> but it's not caught by the above because there is no vfio_dma @0x0.
> Therefore I think you want:
> 
> ((unmap->flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) &&
>   (!dma || dma->iova != unmap->iova || dma->size != unmap->size))
> 
> Right?  Thanks,
> 


Yes, updating check.

Is !dma here also error case when VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP 
flag is not set?
DMA_UNMAP ioctl returns how much was unmapped, from user space 
perspective this would be from start of range (unmap->iova), right?

Thanks,
Kirti
