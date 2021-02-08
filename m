Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8603A3128B1
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 02:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhBHBRx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Feb 2021 20:17:53 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12147 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbhBHBRw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Feb 2021 20:17:52 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DYp4L2PQtz16578;
        Mon,  8 Feb 2021 09:15:46 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.498.0; Mon, 8 Feb 2021 09:17:02 +0800
Subject: Re: [RFC PATCH 06/11] iommu/arm-smmu-v3: Scan leaf TTD to sync
 hardware dirty log
To:     Robin Murphy <robin.murphy@arm.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <iommu@lists.linux-foundation.org>
References: <20210128151742.18840-1-zhukeqian1@huawei.com>
 <20210128151742.18840-7-zhukeqian1@huawei.com>
 <2a731fe7-5879-8d89-7b96-d7385117b869@arm.com>
CC:     Will Deacon <will@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Cornelia Huck" <cohuck@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        <wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>,
        <yuzenghui@huawei.com>, <lushenming@huawei.com>
From:   Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <02286125-408e-6f42-18e1-c761033cb9b2@huawei.com>
Date:   Mon, 8 Feb 2021 09:17:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <2a731fe7-5879-8d89-7b96-d7385117b869@arm.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/2/5 3:52, Robin Murphy wrote:
> On 2021-01-28 15:17, Keqian Zhu wrote:
>> From: jiangkunkun <jiangkunkun@huawei.com>
>>
>> During dirty log tracking, user will try to retrieve dirty log from
>> iommu if it supports hardware dirty log. This adds a new interface
[...]

>>   static void arm_lpae_restrict_pgsizes(struct io_pgtable_cfg *cfg)
>>   {
>>       unsigned long granule, page_sizes;
>> @@ -957,6 +1046,7 @@ arm_lpae_alloc_pgtable(struct io_pgtable_cfg *cfg)
>>           .iova_to_phys    = arm_lpae_iova_to_phys,
>>           .split_block    = arm_lpae_split_block,
>>           .merge_page    = arm_lpae_merge_page,
>> +        .sync_dirty_log    = arm_lpae_sync_dirty_log,
>>       };
>>         return data;
>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>> index f1261da11ea8..69f268069282 100644
>> --- a/drivers/iommu/iommu.c
>> +++ b/drivers/iommu/iommu.c
>> @@ -2822,6 +2822,47 @@ size_t iommu_merge_page(struct iommu_domain *domain, unsigned long iova,
>>   }
>>   EXPORT_SYMBOL_GPL(iommu_merge_page);
>>   +int iommu_sync_dirty_log(struct iommu_domain *domain, unsigned long iova,
>> +             size_t size, unsigned long *bitmap,
>> +             unsigned long base_iova, unsigned long bitmap_pgshift)
>> +{
>> +    const struct iommu_ops *ops = domain->ops;
>> +    unsigned int min_pagesz;
>> +    size_t pgsize;
>> +    int ret;
>> +
>> +    min_pagesz = 1 << __ffs(domain->pgsize_bitmap);
>> +
>> +    if (!IS_ALIGNED(iova | size, min_pagesz)) {
>> +        pr_err("unaligned: iova 0x%lx size 0x%zx min_pagesz 0x%x\n",
>> +               iova, size, min_pagesz);
>> +        return -EINVAL;
>> +    }
>> +
>> +    if (!ops || !ops->sync_dirty_log) {
>> +        pr_err("don't support sync dirty log\n");
>> +        return -ENODEV;
>> +    }
>> +
>> +    while (size) {
>> +        pgsize = iommu_pgsize(domain, iova, size);
>> +
>> +        ret = ops->sync_dirty_log(domain, iova, pgsize,
>> +                      bitmap, base_iova, bitmap_pgshift);
> 
> Once again, we have a worst-of-both-worlds iteration that doesn't make much sense. iommu_pgsize() essentially tells you the best supported size that an IOVA range *can* be mapped with, but we're iterating a range that's already mapped, so we don't know if it's relevant, and either way it may not bear any relation to the granularity of the bitmap, which is presumably what actually matters.
> 
> Logically, either we should iterate at the bitmap granularity here, and the driver just says whether the given iova chunk contains any dirty pages or not, or we just pass everything through to the driver and let it do the whole job itself. Doing a little bit of both is just an overcomplicated mess.
> 
> I'm skimming patch #7 and pretty much the same comments apply, so I can't be bothered to repeat them there...
> 
> Robin.
Sorry that I missed these comments...

As I clarified in #4, due to unsuitable variable name, the @pgsize actually is the max size that meets alignment acquirement and fits into the pgsize_bitmap.

All iommu interfaces acquire the @size fits into pgsize_bitmap to simplify their implementation. And the logic is very similar to "unmap" here.

Thanks,
Keqian

> 
>> +        if (ret)
>> +            break;
>> +
>> +        pr_debug("dirty_log_sync: iova 0x%lx pagesz 0x%zx\n", iova,
>> +             pgsize);
>> +
>> +        iova += pgsize;
>> +        size -= pgsize;
>> +    }
>> +
>> +    return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(iommu_sync_dirty_log);
>> +
>>   void iommu_get_resv_regions(struct device *dev, struct list_head *list)
>>   {
>>       const struct iommu_ops *ops = dev->bus->iommu_ops;
>> diff --git a/include/linux/io-pgtable.h b/include/linux/io-pgtable.h
>> index 754b62a1bbaf..f44551e4a454 100644
>> --- a/include/linux/io-pgtable.h
>> +++ b/include/linux/io-pgtable.h
>> @@ -166,6 +166,10 @@ struct io_pgtable_ops {
>>                     size_t size);
>>       size_t (*merge_page)(struct io_pgtable_ops *ops, unsigned long iova,
>>                    phys_addr_t phys, size_t size, int prot);
>> +    int (*sync_dirty_log)(struct io_pgtable_ops *ops,
>> +                  unsigned long iova, size_t size,
>> +                  unsigned long *bitmap, unsigned long base_iova,
>> +                  unsigned long bitmap_pgshift);
>>   };
>>     /**
>> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
>> index ac2b0b1bce0f..8069c8375e63 100644
>> --- a/include/linux/iommu.h
>> +++ b/include/linux/iommu.h
>> @@ -262,6 +262,10 @@ struct iommu_ops {
>>                     size_t size);
>>       size_t (*merge_page)(struct iommu_domain *domain, unsigned long iova,
>>                    phys_addr_t phys, size_t size, int prot);
>> +    int (*sync_dirty_log)(struct iommu_domain *domain,
>> +                  unsigned long iova, size_t size,
>> +                  unsigned long *bitmap, unsigned long base_iova,
>> +                  unsigned long bitmap_pgshift);
>>         /* Request/Free a list of reserved regions for a device */
>>       void (*get_resv_regions)(struct device *dev, struct list_head *list);
>> @@ -517,6 +521,10 @@ extern size_t iommu_split_block(struct iommu_domain *domain, unsigned long iova,
>>                   size_t size);
>>   extern size_t iommu_merge_page(struct iommu_domain *domain, unsigned long iova,
>>                      size_t size, int prot);
>> +extern int iommu_sync_dirty_log(struct iommu_domain *domain, unsigned long iova,
>> +                size_t size, unsigned long *bitmap,
>> +                unsigned long base_iova,
>> +                unsigned long bitmap_pgshift);
>>     /* Window handling function prototypes */
>>   extern int iommu_domain_window_enable(struct iommu_domain *domain, u32 wnd_nr,
>> @@ -923,6 +931,15 @@ static inline size_t iommu_merge_page(struct iommu_domain *domain,
>>       return -EINVAL;
>>   }
>>   +static inline int iommu_sync_dirty_log(struct iommu_domain *domain,
>> +                       unsigned long iova, size_t size,
>> +                       unsigned long *bitmap,
>> +                       unsigned long base_iova,
>> +                       unsigned long pgshift)
>> +{
>> +    return -EINVAL;
>> +}
>> +
>>   static inline int  iommu_device_register(struct iommu_device *iommu)
>>   {
>>       return -ENODEV;
>>
> .
> 
