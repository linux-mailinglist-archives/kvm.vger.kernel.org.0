Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD511312457
	for <lists+kvm@lfdr.de>; Sun,  7 Feb 2021 13:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbhBGMmO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Feb 2021 07:42:14 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12145 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbhBGMmM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Feb 2021 07:42:12 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DYTJQ5l8qz164sd;
        Sun,  7 Feb 2021 20:40:06 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Sun, 7 Feb 2021 20:41:20 +0800
Subject: Re: [RFC PATCH 06/11] iommu/arm-smmu-v3: Scan leaf TTD to sync
 hardware dirty log
To:     Robin Murphy <robin.murphy@arm.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <iommu@lists.linux-foundation.org>,
        "Will Deacon" <will@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Marc Zyngier" <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
References: <20210128151742.18840-1-zhukeqian1@huawei.com>
 <20210128151742.18840-7-zhukeqian1@huawei.com>
 <2a731fe7-5879-8d89-7b96-d7385117b869@arm.com>
CC:     Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        <wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>,
        <yuzenghui@huawei.com>, <lushenming@huawei.com>
From:   Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <04b101d2-b9ee-1f3a-3cde-f63717f60b08@huawei.com>
Date:   Sun, 7 Feb 2021 20:41:19 +0800
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

Hi Robin,

On 2021/2/5 3:52, Robin Murphy wrote:
> On 2021-01-28 15:17, Keqian Zhu wrote:
>> From: jiangkunkun <jiangkunkun@huawei.com>
>>
>> During dirty log tracking, user will try to retrieve dirty log from
>> iommu if it supports hardware dirty log. This adds a new interface
>> named sync_dirty_log in iommu layer and arm smmuv3 implements it,
>> which scans leaf TTD and treats it's dirty if it's writable (As we
>> just enable HTTU for stage1, so check AP[2] is not set).
>>
>> Co-developed-by: Keqian Zhu <zhukeqian1@huawei.com>
>> Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
>> ---
>>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 27 +++++++
>>   drivers/iommu/io-pgtable-arm.c              | 90 +++++++++++++++++++++
>>   drivers/iommu/iommu.c                       | 41 ++++++++++
>>   include/linux/io-pgtable.h                  |  4 +
>>   include/linux/iommu.h                       | 17 ++++
>>   5 files changed, 179 insertions(+)
>>
>> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> index 2434519e4bb6..43d0536b429a 100644
>> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> @@ -2548,6 +2548,32 @@ static size_t arm_smmu_merge_page(struct iommu_domain *domain, unsigned long iov
>>       return ops->merge_page(ops, iova, paddr, size, prot);
>>   }
>>   +static int arm_smmu_sync_dirty_log(struct iommu_domain *domain,
>> +                   unsigned long iova, size_t size,
>> +                   unsigned long *bitmap,
>> +                   unsigned long base_iova,
>> +                   unsigned long bitmap_pgshift)
>> +{
>> +    struct io_pgtable_ops *ops = to_smmu_domain(domain)->pgtbl_ops;
>> +    struct arm_smmu_device *smmu = to_smmu_domain(domain)->smmu;
>> +
>> +    if (!(smmu->features & ARM_SMMU_FEAT_HTTU_HD)) {
>> +        dev_err(smmu->dev, "don't support HTTU_HD and sync dirty log\n");
>> +        return -EPERM;
>> +    }
>> +
>> +    if (!ops || !ops->sync_dirty_log) {
>> +        pr_err("don't support sync dirty log\n");
>> +        return -ENODEV;
>> +    }
>> +
>> +    /* To ensure all inflight transactions are completed */
>> +    arm_smmu_flush_iotlb_all(domain);
> 
> What about transactions that arrive between the point that this completes, and the point - potentially much later - that we actually access any given PTE during the walk? I don't see what this is supposed to be synchronising against, even if it were just a CMD_SYNC (I especially don't see why we'd want to knock out the TLBs).
The idea is that pgtable may be updated by HTTU *before* or *after* actual DMA access.

1) For PCI ATS. As SMMU spec (3.13.6.1 Hardware flag update for ATS & PRI) states:

"In addition to the behavior that is described earlier in this section, if hardware-management of Dirty state is enabled
and an ATS request for write access (with NW == 0) is made to a page that is marked Writable Clean, the SMMU
assumes a write will be made to that page and marks the page as Writable Dirty before returning the ATS response
that grants write access. When this happens, the modification to the page data by a device is not visible before
the page state is visible as Writable Dirty."

The problem is that guest memory may be dirtied *after* we actually handle it.

2) For inflight DMA. As SMMU spec (3.13.4 HTTU behavior summary) states:

"In addition, the completion of a TLB invalidation operation makes TTD updates that were caused by
transactions that are themselves completed by the completion of the TLB invalidation visible. Both
broadcast and explicit CMD_TLBI_* invalidations have this property."

The problem is that we should flush all dma transaction after guest stop.



The key to solve these problems is that we should invalidate related TLB.
1) TLBI can flush inflight dma translation (before dirty_log_sync()).
2) If a DMA translation uses ATC and occurs after we have handle dirty memory, then the ATC has been invalidated, so this will remark page as dirty (in dirty_log_clear()).

Thanks,
Keqian

> 
>> +
>> +    return ops->sync_dirty_log(ops, iova, size, bitmap,
>> +            base_iova, bitmap_pgshift);
>> +}
>> +
>>   static int arm_smmu_of_xlate(struct device *dev, struct of_phandle_args *args)
>>   {
>>       return iommu_fwspec_add_ids(dev, args->args, 1);
>> @@ -2649,6 +2675,7 @@ static struct iommu_ops arm_smmu_ops = {
>>       .domain_set_attr    = arm_smmu_domain_set_attr,
>>       .split_block        = arm_smmu_split_block,
>>       .merge_page        = arm_smmu_merge_page,
>> +    .sync_dirty_log        = arm_smmu_sync_dirty_log,
>>       .of_xlate        = arm_smmu_of_xlate,
>>       .get_resv_regions    = arm_smmu_get_resv_regions,
>>       .put_resv_regions    = generic_iommu_put_resv_regions,
>> diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
>> index 17390f258eb1..6cfe1ef3fedd 100644
>> --- a/drivers/iommu/io-pgtable-arm.c
>> +++ b/drivers/iommu/io-pgtable-arm.c
>> @@ -877,6 +877,95 @@ static size_t arm_lpae_merge_page(struct io_pgtable_ops *ops, unsigned long iova
>>       return __arm_lpae_merge_page(data, iova, paddr, size, lvl, ptep, prot);
>>   }
>>   +static int __arm_lpae_sync_dirty_log(struct arm_lpae_io_pgtable *data,
>> +                     unsigned long iova, size_t size,
>> +                     int lvl, arm_lpae_iopte *ptep,
>> +                     unsigned long *bitmap,
>> +                     unsigned long base_iova,
>> +                     unsigned long bitmap_pgshift)
>> +{
>> +    arm_lpae_iopte pte;
>> +    struct io_pgtable *iop = &data->iop;
>> +    size_t base, next_size;
>> +    unsigned long offset;
>> +    int nbits, ret;
>> +
>> +    if (WARN_ON(lvl == ARM_LPAE_MAX_LEVELS))
>> +        return -EINVAL;
>> +
>> +    ptep += ARM_LPAE_LVL_IDX(iova, lvl, data);
>> +    pte = READ_ONCE(*ptep);
>> +    if (WARN_ON(!pte))
>> +        return -EINVAL;
>> +
>> +    if (size == ARM_LPAE_BLOCK_SIZE(lvl, data)) {
>> +        if (iopte_leaf(pte, lvl, iop->fmt)) {
>> +            if (pte & ARM_LPAE_PTE_AP_RDONLY)
>> +                return 0;
>> +
>> +            /* It is writable, set the bitmap */
>> +            nbits = size >> bitmap_pgshift;
>> +            offset = (iova - base_iova) >> bitmap_pgshift;
>> +            bitmap_set(bitmap, offset, nbits);
>> +            return 0;
>> +        } else {
>> +            /* To traverse next level */
>> +            next_size = ARM_LPAE_BLOCK_SIZE(lvl + 1, data);
>> +            ptep = iopte_deref(pte, data);
>> +            for (base = 0; base < size; base += next_size) {
>> +                ret = __arm_lpae_sync_dirty_log(data,
>> +                        iova + base, next_size, lvl + 1,
>> +                        ptep, bitmap, base_iova, bitmap_pgshift);
>> +                if (ret)
>> +                    return ret;
>> +            }
>> +            return 0;
>> +        }
>> +    } else if (iopte_leaf(pte, lvl, iop->fmt)) {
>> +        if (pte & ARM_LPAE_PTE_AP_RDONLY)
>> +            return 0;
>> +
>> +        /* Though the size is too small, also set bitmap */
>> +        nbits = size >> bitmap_pgshift;
>> +        offset = (iova - base_iova) >> bitmap_pgshift;
>> +        bitmap_set(bitmap, offset, nbits);
>> +        return 0;
>> +    }
>> +
>> +    /* Keep on walkin */
>> +    ptep = iopte_deref(pte, data);
>> +    return __arm_lpae_sync_dirty_log(data, iova, size, lvl + 1, ptep,
>> +            bitmap, base_iova, bitmap_pgshift);
>> +}
>> +
>> +static int arm_lpae_sync_dirty_log(struct io_pgtable_ops *ops,
>> +                   unsigned long iova, size_t size,
>> +                   unsigned long *bitmap,
>> +                   unsigned long base_iova,
>> +                   unsigned long bitmap_pgshift)
>> +{
>> +    struct arm_lpae_io_pgtable *data = io_pgtable_ops_to_data(ops);
>> +    arm_lpae_iopte *ptep = data->pgd;
>> +    int lvl = data->start_level;
>> +    struct io_pgtable_cfg *cfg = &data->iop.cfg;
>> +    long iaext = (s64)iova >> cfg->ias;
>> +
>> +    if (WARN_ON(!size || (size & cfg->pgsize_bitmap) != size))
>> +        return -EINVAL;
>> +
>> +    if (cfg->quirks & IO_PGTABLE_QUIRK_ARM_TTBR1)
>> +        iaext = ~iaext;
>> +    if (WARN_ON(iaext))
>> +        return -EINVAL;
>> +
>> +    if (data->iop.fmt != ARM_64_LPAE_S1 &&
>> +        data->iop.fmt != ARM_32_LPAE_S1)
>> +        return -EINVAL;
>> +
>> +    return __arm_lpae_sync_dirty_log(data, iova, size, lvl, ptep,
>> +                     bitmap, base_iova, bitmap_pgshift);
>> +}
>> +
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
