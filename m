Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 393552FA20F
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 14:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392448AbhARNs7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 08:48:59 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:11557 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392151AbhARNsw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jan 2021 08:48:52 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DKCkZ544QzMLhC;
        Mon, 18 Jan 2021 21:46:46 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Mon, 18 Jan 2021 21:48:03 +0800
Subject: Re: [PATCH 6/6] vfio/iommu_type1: Drop parameter "pgsize" of
 update_user_bitmap
To:     Alex Williamson <alex.williamson@redhat.com>
References: <20210107044401.19828-1-zhukeqian1@huawei.com>
 <20210107044401.19828-7-zhukeqian1@huawei.com>
 <20210115164409.3e7ddb28@omen.home.shazbot.org>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <iommu@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, Cornelia Huck <cohuck@redhat.com>,
        "Will Deacon" <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        <wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>
From:   Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <279c11d9-e79b-2057-3e0c-ac12ab6d917e@huawei.com>
Date:   Mon, 18 Jan 2021 21:48:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210115164409.3e7ddb28@omen.home.shazbot.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/1/16 7:44, Alex Williamson wrote:
> On Thu, 7 Jan 2021 12:44:01 +0800
> Keqian Zhu <zhukeqian1@huawei.com> wrote:
> 
>> We always use the smallest supported page size of vfio_iommu as
>> pgsize. Drop parameter "pgsize" of update_user_bitmap.
>>
>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 9 ++++-----
>>  1 file changed, 4 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 82649a040148..bceda5e8baaa 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -978,10 +978,9 @@ static void vfio_update_pgsize_bitmap(struct vfio_iommu *iommu)
>>  }
>>  
>>  static int update_user_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
>> -			      struct vfio_dma *dma, dma_addr_t base_iova,
>> -			      size_t pgsize)
>> +			      struct vfio_dma *dma, dma_addr_t base_iova)
>>  {
>> -	unsigned long pgshift = __ffs(pgsize);
>> +	unsigned long pgshift = __ffs(iommu->pgsize_bitmap);
>>  	unsigned long nbits = dma->size >> pgshift;
>>  	unsigned long bit_offset = (dma->iova - base_iova) >> pgshift;
>>  	unsigned long copy_offset = bit_offset / BITS_PER_LONG;
>> @@ -1046,7 +1045,7 @@ static int vfio_iova_dirty_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
>>  		if (dma->iova > iova + size - 1)
>>  			break;
>>  
>> -		ret = update_user_bitmap(bitmap, iommu, dma, iova, pgsize);
>> +		ret = update_user_bitmap(bitmap, iommu, dma, iova);
>>  		if (ret)
>>  			return ret;
>>  
>> @@ -1192,7 +1191,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>  
>>  		if (unmap->flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) {
>>  			ret = update_user_bitmap(bitmap->data, iommu, dma,
>> -						 unmap->iova, pgsize);
>> +						 unmap->iova);
>>  			if (ret)
>>  				break;
>>  		}
> 
> Same as the previous, both call sites already have both pgsize and
> pgshift, pass both rather than recalculate.  Thanks,
> 
My idea is that the "pgsize" parameter goes here and there, disturbs our sight when read code.
To be frankly, the recalculate is negligible. Or we can add new fields in vfio_iommu, which are
updated in vfio_update_pgsize_bitmap().

Thanks,
Keqian



> Alex
> 
> .
> 
