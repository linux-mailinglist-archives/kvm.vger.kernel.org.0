Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7722D7060
	for <lists+kvm@lfdr.de>; Fri, 11 Dec 2020 07:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436535AbgLKGxG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Dec 2020 01:53:06 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:9867 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436527AbgLKGwk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Dec 2020 01:52:40 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CshJn1TbZz7CXq;
        Fri, 11 Dec 2020 14:51:21 +0800 (CST)
Received: from [10.174.187.37] (10.174.187.37) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Fri, 11 Dec 2020 14:51:48 +0800
Subject: Re: [PATCH 1/7] vfio: iommu_type1: Clear added dirty bit when unwind
 pin
To:     Alex Williamson <alex.williamson@redhat.com>
References: <20201210073425.25960-1-zhukeqian1@huawei.com>
 <20201210073425.25960-2-zhukeqian1@huawei.com>
 <20201210121646.24fb3cd8@omen.home>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <iommu@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, Cornelia Huck <cohuck@redhat.com>,
        "Marc Zyngier" <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        "Suzuki K Poulose" <suzuki.poulose@arm.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        <wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>
From:   zhukeqian <zhukeqian1@huawei.com>
Message-ID: <aaba64dd-a038-2cb7-8874-e7aed19511c3@huawei.com>
Date:   Fri, 11 Dec 2020 14:51:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20201210121646.24fb3cd8@omen.home>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.37]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020/12/11 3:16, Alex Williamson wrote:
> On Thu, 10 Dec 2020 15:34:19 +0800
> Keqian Zhu <zhukeqian1@huawei.com> wrote:
> 
>> Currently we do not clear added dirty bit of bitmap when unwind
>> pin, so if pin failed at halfway, we set unnecessary dirty bit
>> in bitmap. Clearing added dirty bit when unwind pin, userspace
>> will see less dirty page, which can save much time to handle them.
>>
>> Note that we should distinguish the bits added by pin and the bits
>> already set before pin, so introduce bitmap_added to record this.
>>
>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 33 ++++++++++++++++++++++-----------
>>  1 file changed, 22 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 67e827638995..f129d24a6ec3 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -637,7 +637,11 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>>  	struct vfio_iommu *iommu = iommu_data;
>>  	struct vfio_group *group;
>>  	int i, j, ret;
>> +	unsigned long pgshift = __ffs(iommu->pgsize_bitmap);
>>  	unsigned long remote_vaddr;
>> +	unsigned long bitmap_offset;
>> +	unsigned long *bitmap_added;
>> +	dma_addr_t iova;
>>  	struct vfio_dma *dma;
>>  	bool do_accounting;
>>  
>> @@ -650,6 +654,12 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>>  
>>  	mutex_lock(&iommu->lock);
>>  
>> +	bitmap_added = bitmap_zalloc(npage, GFP_KERNEL);
>> +	if (!bitmap_added) {
>> +		ret = -ENOMEM;
>> +		goto pin_done;
>> +	}
> 
> 
> This is allocated regardless of whether dirty tracking is enabled, so
> this adds overhead to the common case in order to reduce user overhead
> (not correctness) in the rare condition that dirty tracking is enabled,
> and the even rarer condition that there's a fault during that case.
> This is not a good trade-off.  Thanks,

Hi Alex,

We can allocate the bitmap when dirty tracking is active, do you accept this?
Or we can set the dirty bitmap after all pins succeed, but this costs cpu time
to locate vfio_dma with iova.

Thanks,
Keqian

> 
> Alex
> 
> 
>> +
>>  	/* Fail if notifier list is empty */
>>  	if (!iommu->notifier.head) {
>>  		ret = -EINVAL;
>> @@ -664,7 +674,6 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>>  	do_accounting = !IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu);
>>  
>>  	for (i = 0; i < npage; i++) {
>> -		dma_addr_t iova;
>>  		struct vfio_pfn *vpfn;
>>  
>>  		iova = user_pfn[i] << PAGE_SHIFT;
>> @@ -699,14 +708,10 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>>  		}
>>  
>>  		if (iommu->dirty_page_tracking) {
>> -			unsigned long pgshift = __ffs(iommu->pgsize_bitmap);
>> -
>> -			/*
>> -			 * Bitmap populated with the smallest supported page
>> -			 * size
>> -			 */
>> -			bitmap_set(dma->bitmap,
>> -				   (iova - dma->iova) >> pgshift, 1);
>> +			/* Populated with the smallest supported page size */
>> +			bitmap_offset = (iova - dma->iova) >> pgshift;
>> +			if (!test_and_set_bit(bitmap_offset, dma->bitmap))
>> +				set_bit(i, bitmap_added);
>>  		}
>>  	}
>>  	ret = i;
>> @@ -722,14 +727,20 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>>  pin_unwind:
>>  	phys_pfn[i] = 0;
>>  	for (j = 0; j < i; j++) {
>> -		dma_addr_t iova;
>> -
>>  		iova = user_pfn[j] << PAGE_SHIFT;
>>  		dma = vfio_find_dma(iommu, iova, PAGE_SIZE);
>>  		vfio_unpin_page_external(dma, iova, do_accounting);
>>  		phys_pfn[j] = 0;
>> +
>> +		if (test_bit(j, bitmap_added)) {
>> +			bitmap_offset = (iova - dma->iova) >> pgshift;
>> +			clear_bit(bitmap_offset, dma->bitmap);
>> +		}
>>  	}
>>  pin_done:
>> +	if (bitmap_added)
>> +		bitmap_free(bitmap_added);
>> +
>>  	mutex_unlock(&iommu->lock);
>>  	return ret;
>>  }
> 
> .
> 
