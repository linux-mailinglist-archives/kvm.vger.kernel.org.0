Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3DEB2F9F89
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 13:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391513AbhARM07 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 07:26:59 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:11554 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391480AbhARM0H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jan 2021 07:26:07 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DK9v05GwMzMLhC;
        Mon, 18 Jan 2021 20:23:56 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Mon, 18 Jan 2021 20:25:10 +0800
Subject: Re: [PATCH v2 1/2] vfio/iommu_type1: Populate full dirty when detach
 non-pinned group
To:     Alex Williamson <alex.williamson@redhat.com>
References: <20210115092643.728-1-zhukeqian1@huawei.com>
 <20210115092643.728-2-zhukeqian1@huawei.com>
 <20210115110144.61e3c843@omen.home.shazbot.org>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <iommu@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>, "Marc Zyngier" <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        "Robin Murphy" <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Suzuki K Poulose" <suzuki.poulose@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        <wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>
From:   Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <f8de434c-1993-cfe8-c451-2235be1ceb85@huawei.com>
Date:   Mon, 18 Jan 2021 20:25:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210115110144.61e3c843@omen.home.shazbot.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/1/16 2:01, Alex Williamson wrote:
> On Fri, 15 Jan 2021 17:26:42 +0800
> Keqian Zhu <zhukeqian1@huawei.com> wrote:
> 
>> If a group with non-pinned-page dirty scope is detached with dirty
>> logging enabled, we should fully populate the dirty bitmaps at the
>> time it's removed since we don't know the extent of its previous DMA,
>> nor will the group be present to trigger the full bitmap when the user
>> retrieves the dirty bitmap.
>>
>> Fixes: d6a4c185660c ("vfio iommu: Implementation of ioctl for dirty pages tracking")
>> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 18 +++++++++++++++++-
>>  1 file changed, 17 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 0b4dedaa9128..4e82b9a3440f 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -236,6 +236,19 @@ static void vfio_dma_populate_bitmap(struct vfio_dma *dma, size_t pgsize)
>>  	}
>>  }
>>  
>> +static void vfio_iommu_populate_bitmap_full(struct vfio_iommu *iommu)
>> +{
>> +	struct rb_node *n;
>> +	unsigned long pgshift = __ffs(iommu->pgsize_bitmap);
>> +
>> +	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
>> +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
>> +
>> +		if (dma->iommu_mapped)
>> +			bitmap_set(dma->bitmap, 0, dma->size >> pgshift);
>> +	}
>> +}
>> +
>>  static int vfio_dma_bitmap_alloc_all(struct vfio_iommu *iommu, size_t pgsize)
>>  {
>>  	struct rb_node *n;
>> @@ -2415,8 +2428,11 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
>>  	 * Removal of a group without dirty tracking may allow the iommu scope
>>  	 * to be promoted.
>>  	 */
>> -	if (update_dirty_scope)
>> +	if (update_dirty_scope) {
>>  		update_pinned_page_dirty_scope(iommu);
>> +		if (iommu->dirty_page_tracking)
>> +			vfio_iommu_populate_bitmap_full(iommu);
>> +	}
>>  	mutex_unlock(&iommu->lock);
>>  }
>>  
> 
> This doesn't do the right thing.  This marks the bitmap dirty if:
> 
>  * The detached group dirty scope was not limited to pinned pages
> 
>  AND
> 
>  * Dirty tracking is enabled
> 
>  AND
> 
>  * The vfio_dma is *currently* (ie. after the detach) iommu_mapped
> 
> We need to mark the bitmap dirty based on whether the vfio_dma *was*
> iommu_mapped by the group that is now detached.  Thanks,
> 
> Alex
> 
Hi Alex,

Yes, I missed this point again :-(. The update_dirty_scope means we detached
an iommu backed group, and that means the vfio_dma *was* iommu_mapped by this
group, so we can populate full bitmap unconditionally, right?

Thanks,
Keqian


> .
> 
