Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE1C2DAA34
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 10:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgLOJiO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 04:38:14 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:9890 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727879AbgLOJiL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 04:38:11 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CwCnn3xk5z6tw7;
        Tue, 15 Dec 2020 17:36:45 +0800 (CST)
Received: from [10.174.187.37] (10.174.187.37) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Tue, 15 Dec 2020 17:37:12 +0800
Subject: Re: [PATCH 4/7] vfio: iommu_type1: Fix missing dirty page when
 promote pinned_scope
To:     Alex Williamson <alex.williamson@redhat.com>
References: <20201210073425.25960-1-zhukeqian1@huawei.com>
 <20201210073425.25960-5-zhukeqian1@huawei.com>
 <20201214170459.50cb8729@omen.home>
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
Message-ID: <d2073c05-b6c9-04b4-782c-b89680834633@huawei.com>
Date:   Tue, 15 Dec 2020 17:37:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20201214170459.50cb8729@omen.home>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.37]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 2020/12/15 8:04, Alex Williamson wrote:
> On Thu, 10 Dec 2020 15:34:22 +0800
> Keqian Zhu <zhukeqian1@huawei.com> wrote:
> 
>> When we pin or detach a group which is not dirty tracking capable,
>> we will try to promote pinned_scope of vfio_iommu.
>>
>> If we succeed to do so, vfio only report pinned_scope as dirty to
>> userspace next time, but these memory written before pin or detach
>> is missed.
>>
>> The solution is that we must populate all dma range as dirty before
>> promoting pinned_scope of vfio_iommu.
> 
> Please don't bury fixes patches into a series with other optimizations
> and semantic changes.  Send it separately.
> 
OK, I will.

>>
>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 18 ++++++++++++++++++
>>  1 file changed, 18 insertions(+)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index bd9a94590ebc..00684597b098 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -1633,6 +1633,20 @@ static struct vfio_group *vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
>>  	return group;
>>  }
>>  
>> +static void vfio_populate_bitmap_all(struct vfio_iommu *iommu)
>> +{
>> +	struct rb_node *n;
>> +	unsigned long pgshift = __ffs(iommu->pgsize_bitmap);
>> +
>> +	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
>> +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
>> +		unsigned long nbits = dma->size >> pgshift;
>> +
>> +		if (dma->iommu_mapped)
>> +			bitmap_set(dma->bitmap, 0, nbits);
>> +	}
>> +}
> 
> 
> If we detach a group which results in only non-IOMMU backed mdevs,
> don't we also clear dma->iommu_mapped as part of vfio_unmap_unpin()
> such that this test is invalid?  Thanks,

Good spot :-). The code will skip bitmap_set under this situation.

We should set the bitmap unconditionally when vfio_iommu is promoted,
as we must have IOMMU backed domain before promoting the vfio_iommu.

Besides, I think we should also mark dirty in vfio_remove_dma if dirty
tracking is active. Right?

Thanks,
Keqian

> 
> Alex
> 
>> +
>>  static void promote_pinned_page_dirty_scope(struct vfio_iommu *iommu)
>>  {
>>  	struct vfio_domain *domain;
>> @@ -1657,6 +1671,10 @@ static void promote_pinned_page_dirty_scope(struct vfio_iommu *iommu)
>>  	}
>>  
>>  	iommu->pinned_page_dirty_scope = true;
>> +
>> +	/* Set all bitmap to avoid missing dirty page */
>> +	if (iommu->dirty_page_tracking)
>> +		vfio_populate_bitmap_all(iommu);
>>  }
>>  
>>  static bool vfio_iommu_has_sw_msi(struct list_head *group_resv_regions,
> 
> .
> 
