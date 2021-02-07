Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4F50312270
	for <lists+kvm@lfdr.de>; Sun,  7 Feb 2021 09:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbhBGITz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Feb 2021 03:19:55 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:12471 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbhBGITw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Feb 2021 03:19:52 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DYMTk1cfMzjKdW;
        Sun,  7 Feb 2021 16:17:46 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Sun, 7 Feb 2021 16:18:59 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [RFC PATCH 04/11] iommu/arm-smmu-v3: Split block descriptor to a
 span of page
To:     Robin Murphy <robin.murphy@arm.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <iommu@lists.linux-foundation.org>,
        "Will Deacon" <will@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Marc Zyngier" <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
References: <20210128151742.18840-1-zhukeqian1@huawei.com>
 <20210128151742.18840-5-zhukeqian1@huawei.com>
 <b7f45b39-59c4-3707-13eb-937d161e72f0@arm.com>
CC:     Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        <wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>,
        <yuzenghui@huawei.com>, <lushenming@huawei.com>
Message-ID: <a2387bdd-97b6-1b66-43bc-927bf3e93456@huawei.com>
Date:   Sun, 7 Feb 2021 16:18:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <b7f45b39-59c4-3707-13eb-937d161e72f0@arm.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Robin,

On 2021/2/5 3:51, Robin Murphy wrote:
> On 2021-01-28 15:17, Keqian Zhu wrote:
>> From: jiangkunkun <jiangkunkun@huawei.com>
>>
>> Block descriptor is not a proper granule for dirty log tracking. This
>> adds a new interface named split_block in iommu layer and arm smmuv3
>> implements it, which splits block descriptor to an equivalent span of
>> page descriptors.
>>
>> During spliting block, other interfaces are not expected to be working,
>> so race condition does not exist. And we flush all iotlbs after the split
>> procedure is completed to ease the pressure of iommu, as we will split a
>> huge range of block mappings in general.
> 
> "Not expected to be" is not the same thing as "can not". Presumably the whole point of dirty log tracking is that it can be run speculatively in the background, so is there any actual guarantee that the guest can't, say, issue a hotplug event that would cause some memory to be released back to the host and unmapped while a scan might be in progress? Saying effectively "there is no race condition as long as you assume there is no race condition" isn't all that reassuring...
Sorry for my inaccuracy expression. "Not expected to be" is inappropriate here, the actual meaning is "can not".

As the only user of these newly added interfaces is vfio_iommu_type1 for now, and vfio_iommu_type1 always acquires "iommu->lock" before invoke them.

> 
> That said, it's not very clear why patches #4 and #5 are here at all, given that patches #6 and #7 appear quite happy to handle block entries.
Split block into page is very important for dirty page tracking. Page mapping can greatly reduce the amount of dirty memory handling. The KVM mmu stage2 side also has this logic.

Yes, #6 (log_sync) and #7 (log_clear) is designed to be applied for both block and page mapping. As the "split" operation may fail (e.g, without BBML1/2 or ENOMEM), but we can still track dirty at block granule, which is still a much better choice compared to the full dirty policy.

> 
>> Co-developed-by: Keqian Zhu <zhukeqian1@huawei.com>
>> Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
>> ---
>>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  20 ++++
>>   drivers/iommu/io-pgtable-arm.c              | 122 ++++++++++++++++++++
>>   drivers/iommu/iommu.c                       |  40 +++++++
>>   include/linux/io-pgtable.h                  |   2 +
>>   include/linux/iommu.h                       |  10 ++
>>   5 files changed, 194 insertions(+)
>>
>> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> index 9208881a571c..5469f4fca820 100644
>> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> @@ -2510,6 +2510,25 @@ static int arm_smmu_domain_set_attr(struct iommu_domain *domain,
>>       return ret;
>>   }
>>   +static size_t arm_smmu_split_block(struct iommu_domain *domain,
>> +                   unsigned long iova, size_t size)
>> +{
>> +    struct arm_smmu_device *smmu = to_smmu_domain(domain)->smmu;
>> +    struct io_pgtable_ops *ops = to_smmu_domain(domain)->pgtbl_ops;
>> +
>> +    if (!(smmu->features & (ARM_SMMU_FEAT_BBML1 | ARM_SMMU_FEAT_BBML2))) {
>> +        dev_err(smmu->dev, "don't support BBML1/2 and split block\n");
>> +        return 0;
>> +    }
>> +
>> +    if (!ops || !ops->split_block) {
>> +        pr_err("don't support split block\n");
>> +        return 0;
>> +    }
>> +
>> +    return ops->split_block(ops, iova, size);
>> +}
>> +
>>   static int arm_smmu_of_xlate(struct device *dev, struct of_phandle_args *args)
>>   {
>>       return iommu_fwspec_add_ids(dev, args->args, 1);
>> @@ -2609,6 +2628,7 @@ static struct iommu_ops arm_smmu_ops = {
>>       .device_group        = arm_smmu_device_group,
>>       .domain_get_attr    = arm_smmu_domain_get_attr,
>>       .domain_set_attr    = arm_smmu_domain_set_attr,
>> +    .split_block        = arm_smmu_split_block,
>>       .of_xlate        = arm_smmu_of_xlate,
>>       .get_resv_regions    = arm_smmu_get_resv_regions,
>>       .put_resv_regions    = generic_iommu_put_resv_regions,
>> diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
>> index e299a44808ae..f3b7f7115e38 100644
>> --- a/drivers/iommu/io-pgtable-arm.c
>> +++ b/drivers/iommu/io-pgtable-arm.c
>> @@ -79,6 +79,8 @@
>>   #define ARM_LPAE_PTE_SH_IS        (((arm_lpae_iopte)3) << 8)
>>   #define ARM_LPAE_PTE_NS            (((arm_lpae_iopte)1) << 5)
>>   #define ARM_LPAE_PTE_VALID        (((arm_lpae_iopte)1) << 0)
>> +/* Block descriptor bits */
>> +#define ARM_LPAE_PTE_NT            (((arm_lpae_iopte)1) << 16)
>>     #define ARM_LPAE_PTE_ATTR_LO_MASK    (((arm_lpae_iopte)0x3ff) << 2)
>>   /* Ignore the contiguous bit for block splitting */
>> @@ -679,6 +681,125 @@ static phys_addr_t arm_lpae_iova_to_phys(struct io_pgtable_ops *ops,
>>       return iopte_to_paddr(pte, data) | iova;
>>   }
>>   +static size_t __arm_lpae_split_block(struct arm_lpae_io_pgtable *data,
>> +                     unsigned long iova, size_t size, int lvl,
>> +                     arm_lpae_iopte *ptep);
>> +
>> +static size_t arm_lpae_do_split_blk(struct arm_lpae_io_pgtable *data,
>> +                    unsigned long iova, size_t size,
>> +                    arm_lpae_iopte blk_pte, int lvl,
>> +                    arm_lpae_iopte *ptep)
>> +{
>> +    struct io_pgtable_cfg *cfg = &data->iop.cfg;
>> +    arm_lpae_iopte pte, *tablep;
>> +    phys_addr_t blk_paddr;
>> +    size_t tablesz = ARM_LPAE_GRANULE(data);
>> +    size_t split_sz = ARM_LPAE_BLOCK_SIZE(lvl, data);
>> +    int i;
>> +
>> +    if (WARN_ON(lvl == ARM_LPAE_MAX_LEVELS))
>> +        return 0;
>> +
>> +    tablep = __arm_lpae_alloc_pages(tablesz, GFP_ATOMIC, cfg);
>> +    if (!tablep)
>> +        return 0;
>> +
>> +    blk_paddr = iopte_to_paddr(blk_pte, data);
>> +    pte = iopte_prot(blk_pte);
>> +    for (i = 0; i < tablesz / sizeof(pte); i++, blk_paddr += split_sz)
>> +        __arm_lpae_init_pte(data, blk_paddr, pte, lvl, &tablep[i]);
>> +
>> +    if (cfg->bbml == 1) {
>> +        /* Race does not exist */
>> +        blk_pte |= ARM_LPAE_PTE_NT;
>> +        __arm_lpae_set_pte(ptep, blk_pte, cfg);
>> +        io_pgtable_tlb_flush_walk(&data->iop, iova, size, size);
>> +    }
>> +    /* Race does not exist */
>> +    pte = arm_lpae_install_table(tablep, ptep, blk_pte, cfg);
>> +
>> +    /* Have splited it into page? */
>> +    if (lvl == (ARM_LPAE_MAX_LEVELS - 1))
>> +        return size;
>> +
>> +    /* Go back to lvl - 1 */
>> +    ptep -= ARM_LPAE_LVL_IDX(iova, lvl - 1, data);
>> +    return __arm_lpae_split_block(data, iova, size, lvl - 1, ptep);
> 
> If there is a good enough justification for actually using this, recursive splitting is a horrible way to do it. The theoretical split_blk_unmap case does it for the sake of simplicity and mitigating races wherein multiple parts of the same block may be unmapped, but if were were using this in anger then we'd need it to be fast - and a race does not exist, right? - so building the entire sub-table first then swizzling a single PTE would make far more sense.
The main reason for recursive splitting is simplicity too, and simplicity means more reliable.

I take a skeptical attitude to that recursive splitting introduces much extra trade-off compared to straight splitting.
The recursive splitting takes a two step that firstly fills next-level table with block TTD and then *replaces* block TTD with next-next-level table address.
The straight splitting can fill next-level table with next-next-level table address, thus omit the *replace* procedure.

Take 1G block splitting as an example, I think the extra trade-off is 512 times of replacement, which should has little impact on total procedure.


> 
>> +}
>> +
>> +static size_t __arm_lpae_split_block(struct arm_lpae_io_pgtable *data,
>> +                     unsigned long iova, size_t size, int lvl,
>> +                     arm_lpae_iopte *ptep)
>> +{
>> +    arm_lpae_iopte pte;
>> +    struct io_pgtable *iop = &data->iop;
>> +    size_t base, next_size, total_size;
>> +
>> +    if (WARN_ON(lvl == ARM_LPAE_MAX_LEVELS))
>> +        return 0;
>> +
>> +    ptep += ARM_LPAE_LVL_IDX(iova, lvl, data);
>> +    pte = READ_ONCE(*ptep);
>> +    if (WARN_ON(!pte))
>> +        return 0;
>> +
>> +    if (size == ARM_LPAE_BLOCK_SIZE(lvl, data)) {
>> +        if (iopte_leaf(pte, lvl, iop->fmt)) {
>> +            if (lvl == (ARM_LPAE_MAX_LEVELS - 1) ||
>> +                (pte & ARM_LPAE_PTE_AP_RDONLY))
>> +                return size;
>> +
>> +            /* We find a writable block, split it. */
>> +            return arm_lpae_do_split_blk(data, iova, size, pte,
>> +                    lvl + 1, ptep);
>> +        } else {
>> +            /* If it is the last table level, then nothing to do */
>> +            if (lvl == (ARM_LPAE_MAX_LEVELS - 2))
>> +                return size;
>> +
>> +            total_size = 0;
>> +            next_size = ARM_LPAE_BLOCK_SIZE(lvl + 1, data);
>> +            ptep = iopte_deref(pte, data);
>> +            for (base = 0; base < size; base += next_size)
>> +                total_size += __arm_lpae_split_block(data,
>> +                        iova + base, next_size, lvl + 1,
>> +                        ptep);
>> +            return total_size;
>> +        }
>> +    } else if (iopte_leaf(pte, lvl, iop->fmt)) {
>> +        WARN(1, "Can't split behind a block.\n");
>> +        return 0;
>> +    }
>> +
>> +    /* Keep on walkin */
>> +    ptep = iopte_deref(pte, data);
>> +    return __arm_lpae_split_block(data, iova, size, lvl + 1, ptep);
>> +}
>> +
>> +static size_t arm_lpae_split_block(struct io_pgtable_ops *ops,
>> +                   unsigned long iova, size_t size)
>> +{
>> +    struct arm_lpae_io_pgtable *data = io_pgtable_ops_to_data(ops);
>> +    arm_lpae_iopte *ptep = data->pgd;
>> +    struct io_pgtable_cfg *cfg = &data->iop.cfg;
>> +    int lvl = data->start_level;
>> +    long iaext = (s64)iova >> cfg->ias;
>> +
>> +    if (WARN_ON(!size || (size & cfg->pgsize_bitmap) != size))
>> +        return 0;
>> +
>> +    if (cfg->quirks & IO_PGTABLE_QUIRK_ARM_TTBR1)
>> +        iaext = ~iaext;
>> +    if (WARN_ON(iaext))
>> +        return 0;
>> +
>> +    /* If it is smallest granule, then nothing to do */
>> +    if (size == ARM_LPAE_BLOCK_SIZE(ARM_LPAE_MAX_LEVELS - 1, data))
>> +        return size;
>> +
>> +    return __arm_lpae_split_block(data, iova, size, lvl, ptep);
>> +}
>> +
>>   static void arm_lpae_restrict_pgsizes(struct io_pgtable_cfg *cfg)
>>   {
>>       unsigned long granule, page_sizes;
>> @@ -757,6 +878,7 @@ arm_lpae_alloc_pgtable(struct io_pgtable_cfg *cfg)
>>           .map        = arm_lpae_map,
>>           .unmap        = arm_lpae_unmap,
>>           .iova_to_phys    = arm_lpae_iova_to_phys,
>> +        .split_block    = arm_lpae_split_block,
>>       };
>>         return data;
>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>> index ffeebda8d6de..7dc0850448c3 100644
>> --- a/drivers/iommu/iommu.c
>> +++ b/drivers/iommu/iommu.c
>> @@ -2707,6 +2707,46 @@ int iommu_domain_set_attr(struct iommu_domain *domain,
>>   }
>>   EXPORT_SYMBOL_GPL(iommu_domain_set_attr);
>>   +size_t iommu_split_block(struct iommu_domain *domain, unsigned long iova,
>> +             size_t size)
>> +{
>> +    const struct iommu_ops *ops = domain->ops;
>> +    unsigned int min_pagesz;
>> +    size_t pgsize, splited_size;
>> +    size_t splited = 0;
>> +
>> +    min_pagesz = 1 << __ffs(domain->pgsize_bitmap);
>> +
>> +    if (!IS_ALIGNED(iova | size, min_pagesz)) {
>> +        pr_err("unaligned: iova 0x%lx size 0x%zx min_pagesz 0x%x\n",
>> +               iova, size, min_pagesz);
>> +        return 0;
>> +    }
>> +
>> +    if (!ops || !ops->split_block) {
>> +        pr_err("don't support split block\n");
>> +        return 0;
>> +    }
>> +
>> +    while (size) {
>> +        pgsize = iommu_pgsize(domain, iova, size);
> 
> If the whole point of this operation is to split a mapping down to a specific granularity, why bother recalculating that granularity over and over again?
Sorry for the unsuitable expression again. The computed pgsize is not our destined granularity, it's the max splitting size that meets alignment acquirement and fits into the pgsize_bitmap.

The "split" interface assumes the @size fits into pgsize_bitmap to simplify its implementation. This assumption is same for "map" and "unmap", and the logic of "split" is very similar to "unmap".

> 
>> +
>> +        splited_size = ops->split_block(domain, iova, pgsize);
>> +
>> +        pr_debug("splited: iova 0x%lx size 0x%zx\n", iova, splited_size);
>> +        iova += splited_size;
>> +        size -= splited_size;
>> +        splited += splited_size;
>> +
>> +        if (splited_size != pgsize)
>> +            break;
>> +    }
>> +    iommu_flush_iotlb_all(domain);
>> +
>> +    return splited;
> 
> Language tangent: note that "split" is one of those delightful irregular verbs, in that its past tense is also "split". This isn't the best operation for clear, unambigous naming :)
Ouch, we ought to use another word here. ;-)

> 
> Don't let these idle nitpicks distract from the bigger concerns above, though. FWIW if the caller knows from the start that they want to keep track of things at page granularity, they always have the option of just stripping the larger sizes out of domain->pgsize_bitmap before mapping anything.
Before dirty tracking, we use block mapping for best performance, and when dirty tracking start, we will split block mapping into page mapping for least dirty handling.
I think we should not sacrifice DMA performance to omit splitting, as we test, splitting 1G block mapping to 4K mapping just takes about 2ms.

Thanks,
Keqian

> 
> Robin.
> 
>> +}
>> +EXPORT_SYMBOL_GPL(iommu_split_block);
>> +
>>   void iommu_get_resv_regions(struct device *dev, struct list_head *list)
>>   {
>>       const struct iommu_ops *ops = dev->bus->iommu_ops;
>> diff --git a/include/linux/io-pgtable.h b/include/linux/io-pgtable.h
>> index 26583beeb5d9..b87c6f4ecaa2 100644
>> --- a/include/linux/io-pgtable.h
>> +++ b/include/linux/io-pgtable.h
>> @@ -162,6 +162,8 @@ struct io_pgtable_ops {
>>               size_t size, struct iommu_iotlb_gather *gather);
>>       phys_addr_t (*iova_to_phys)(struct io_pgtable_ops *ops,
>>                       unsigned long iova);
>> +    size_t (*split_block)(struct io_pgtable_ops *ops, unsigned long iova,
>> +                  size_t size);
>>   };
>>     /**
>> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
>> index b3f0e2018c62..abeb811098a5 100644
>> --- a/include/linux/iommu.h
>> +++ b/include/linux/iommu.h
>> @@ -258,6 +258,8 @@ struct iommu_ops {
>>                      enum iommu_attr attr, void *data);
>>       int (*domain_set_attr)(struct iommu_domain *domain,
>>                      enum iommu_attr attr, void *data);
>> +    size_t (*split_block)(struct iommu_domain *domain, unsigned long iova,
>> +                  size_t size);
>>         /* Request/Free a list of reserved regions for a device */
>>       void (*get_resv_regions)(struct device *dev, struct list_head *list);
>> @@ -509,6 +511,8 @@ extern int iommu_domain_get_attr(struct iommu_domain *domain, enum iommu_attr,
>>                    void *data);
>>   extern int iommu_domain_set_attr(struct iommu_domain *domain, enum iommu_attr,
>>                    void *data);
>> +extern size_t iommu_split_block(struct iommu_domain *domain, unsigned long iova,
>> +                size_t size);
>>     /* Window handling function prototypes */
>>   extern int iommu_domain_window_enable(struct iommu_domain *domain, u32 wnd_nr,
>> @@ -903,6 +907,12 @@ static inline int iommu_domain_set_attr(struct iommu_domain *domain,
>>       return -EINVAL;
>>   }
>>   +static inline size_t iommu_split_block(struct iommu_domain *domain,
>> +                       unsigned long iova, size_t size)
>> +{
>> +    return 0;
>> +}
>> +
>>   static inline int  iommu_device_register(struct iommu_device *iommu)
>>   {
>>       return -ENODEV;
>>
> .
> 
