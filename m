Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4568130FDE4
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 21:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239717AbhBDTzH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 14:55:07 -0500
Received: from foss.arm.com ([217.140.110.172]:36632 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239516AbhBDTwv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 14:52:51 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3AE28143B;
        Thu,  4 Feb 2021 11:52:04 -0800 (PST)
Received: from [10.57.49.26] (unknown [10.57.49.26])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 668693F73B;
        Thu,  4 Feb 2021 11:52:01 -0800 (PST)
Subject: Re: [RFC PATCH 05/11] iommu/arm-smmu-v3: Merge a span of page to
 block descriptor
To:     Keqian Zhu <zhukeqian1@huawei.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        Will Deacon <will@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        wanghaibin.wang@huawei.com, jiangkunkun@huawei.com,
        yuzenghui@huawei.com, lushenming@huawei.com
References: <20210128151742.18840-1-zhukeqian1@huawei.com>
 <20210128151742.18840-6-zhukeqian1@huawei.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <af03aa13-9fd1-d7d1-6e55-fd59ff9d0688@arm.com>
Date:   Thu, 4 Feb 2021 19:52:00 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210128151742.18840-6-zhukeqian1@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-01-28 15:17, Keqian Zhu wrote:
> From: jiangkunkun <jiangkunkun@huawei.com>
> 
> When stop dirty log tracking, we need to recover all block descriptors
> which are splited when start dirty log tracking. This adds a new
> interface named merge_page in iommu layer and arm smmuv3 implements it,
> which reinstall block mappings and unmap the span of page mappings.
> 
> It's caller's duty to find contiuous physical memory.
> 
> During merging page, other interfaces are not expected to be working,
> so race condition does not exist. And we flush all iotlbs after the merge
> procedure is completed to ease the pressure of iommu, as we will merge a
> huge range of page mappings in general.

Again, I think we need better reasoning than "race conditions don't 
exist because we don't expect them to exist".

> Co-developed-by: Keqian Zhu <zhukeqian1@huawei.com>
> Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
> ---
>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 20 ++++++
>   drivers/iommu/io-pgtable-arm.c              | 78 +++++++++++++++++++++
>   drivers/iommu/iommu.c                       | 75 ++++++++++++++++++++
>   include/linux/io-pgtable.h                  |  2 +
>   include/linux/iommu.h                       | 10 +++
>   5 files changed, 185 insertions(+)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 5469f4fca820..2434519e4bb6 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -2529,6 +2529,25 @@ static size_t arm_smmu_split_block(struct iommu_domain *domain,
>   	return ops->split_block(ops, iova, size);
>   }
>   
> +static size_t arm_smmu_merge_page(struct iommu_domain *domain, unsigned long iova,
> +				  phys_addr_t paddr, size_t size, int prot)
> +{
> +	struct io_pgtable_ops *ops = to_smmu_domain(domain)->pgtbl_ops;
> +	struct arm_smmu_device *smmu = to_smmu_domain(domain)->smmu;
> +
> +	if (!(smmu->features & (ARM_SMMU_FEAT_BBML1 | ARM_SMMU_FEAT_BBML2))) {
> +		dev_err(smmu->dev, "don't support BBML1/2 and merge page\n");
> +		return 0;
> +	}
> +
> +	if (!ops || !ops->merge_page) {
> +		pr_err("don't support merge page\n");
> +		return 0;
> +	}
> +
> +	return ops->merge_page(ops, iova, paddr, size, prot);
> +}
> +
>   static int arm_smmu_of_xlate(struct device *dev, struct of_phandle_args *args)
>   {
>   	return iommu_fwspec_add_ids(dev, args->args, 1);
> @@ -2629,6 +2648,7 @@ static struct iommu_ops arm_smmu_ops = {
>   	.domain_get_attr	= arm_smmu_domain_get_attr,
>   	.domain_set_attr	= arm_smmu_domain_set_attr,
>   	.split_block		= arm_smmu_split_block,
> +	.merge_page		= arm_smmu_merge_page,
>   	.of_xlate		= arm_smmu_of_xlate,
>   	.get_resv_regions	= arm_smmu_get_resv_regions,
>   	.put_resv_regions	= generic_iommu_put_resv_regions,
> diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
> index f3b7f7115e38..17390f258eb1 100644
> --- a/drivers/iommu/io-pgtable-arm.c
> +++ b/drivers/iommu/io-pgtable-arm.c
> @@ -800,6 +800,83 @@ static size_t arm_lpae_split_block(struct io_pgtable_ops *ops,
>   	return __arm_lpae_split_block(data, iova, size, lvl, ptep);
>   }
>   
> +static size_t __arm_lpae_merge_page(struct arm_lpae_io_pgtable *data,
> +				    unsigned long iova, phys_addr_t paddr,
> +				    size_t size, int lvl, arm_lpae_iopte *ptep,
> +				    arm_lpae_iopte prot)
> +{
> +	arm_lpae_iopte pte, *tablep;
> +	struct io_pgtable *iop = &data->iop;
> +	struct io_pgtable_cfg *cfg = &data->iop.cfg;
> +
> +	if (WARN_ON(lvl == ARM_LPAE_MAX_LEVELS))
> +		return 0;
> +
> +	ptep += ARM_LPAE_LVL_IDX(iova, lvl, data);
> +	pte = READ_ONCE(*ptep);
> +	if (WARN_ON(!pte))
> +		return 0;
> +
> +	if (size == ARM_LPAE_BLOCK_SIZE(lvl, data)) {
> +		if (iopte_leaf(pte, lvl, iop->fmt))
> +			return size;
> +
> +		/* Race does not exist */
> +		if (cfg->bbml == 1) {
> +			prot |= ARM_LPAE_PTE_NT;
> +			__arm_lpae_init_pte(data, paddr, prot, lvl, ptep);
> +			io_pgtable_tlb_flush_walk(iop, iova, size,
> +						  ARM_LPAE_GRANULE(data));
> +
> +			prot &= ~(ARM_LPAE_PTE_NT);
> +			__arm_lpae_init_pte(data, paddr, prot, lvl, ptep);
> +		} else {
> +			__arm_lpae_init_pte(data, paddr, prot, lvl, ptep);
> +		}
> +
> +		tablep = iopte_deref(pte, data);
> +		__arm_lpae_free_pgtable(data, lvl + 1, tablep);
> +		return size;
> +	} else if (iopte_leaf(pte, lvl, iop->fmt)) {
> +		/* The size is too small, already merged */
> +		return size;
> +	}
> +
> +	/* Keep on walkin */
> +	ptep = iopte_deref(pte, data);
> +	return __arm_lpae_merge_page(data, iova, paddr, size, lvl + 1, ptep, prot);
> +}
> +
> +static size_t arm_lpae_merge_page(struct io_pgtable_ops *ops, unsigned long iova,
> +				  phys_addr_t paddr, size_t size, int iommu_prot)
> +{
> +	struct arm_lpae_io_pgtable *data = io_pgtable_ops_to_data(ops);
> +	struct io_pgtable_cfg *cfg = &data->iop.cfg;
> +	arm_lpae_iopte *ptep = data->pgd;
> +	int lvl = data->start_level;
> +	arm_lpae_iopte prot;
> +	long iaext = (s64)iova >> cfg->ias;
> +
> +	/* If no access, then nothing to do */
> +	if (!(iommu_prot & (IOMMU_READ | IOMMU_WRITE)))
> +		return size;
> +
> +	if (WARN_ON(!size || (size & cfg->pgsize_bitmap) != size))
> +		return 0;
> +
> +	if (cfg->quirks & IO_PGTABLE_QUIRK_ARM_TTBR1)
> +		iaext = ~iaext;
> +	if (WARN_ON(iaext || paddr >> cfg->oas))
> +		return 0;
> +
> +	/* If it is smallest granule, then nothing to do */
> +	if (size == ARM_LPAE_BLOCK_SIZE(ARM_LPAE_MAX_LEVELS - 1, data))
> +		return size;
> +
> +	prot = arm_lpae_prot_to_pte(data, iommu_prot);
> +	return __arm_lpae_merge_page(data, iova, paddr, size, lvl, ptep, prot);
> +}
> +
>   static void arm_lpae_restrict_pgsizes(struct io_pgtable_cfg *cfg)
>   {
>   	unsigned long granule, page_sizes;
> @@ -879,6 +956,7 @@ arm_lpae_alloc_pgtable(struct io_pgtable_cfg *cfg)
>   		.unmap		= arm_lpae_unmap,
>   		.iova_to_phys	= arm_lpae_iova_to_phys,
>   		.split_block	= arm_lpae_split_block,
> +		.merge_page	= arm_lpae_merge_page,
>   	};
>   
>   	return data;
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 7dc0850448c3..f1261da11ea8 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -2747,6 +2747,81 @@ size_t iommu_split_block(struct iommu_domain *domain, unsigned long iova,
>   }
>   EXPORT_SYMBOL_GPL(iommu_split_block);
>   
> +static size_t __iommu_merge_page(struct iommu_domain *domain, unsigned long iova,
> +				 phys_addr_t paddr, size_t size, int prot)
> +{
> +	const struct iommu_ops *ops = domain->ops;
> +	unsigned int min_pagesz;
> +	size_t pgsize, merged_size;
> +	size_t merged = 0;
> +
> +	min_pagesz = 1 << __ffs(domain->pgsize_bitmap);
> +
> +	if (!IS_ALIGNED(iova | paddr | size, min_pagesz)) {
> +		pr_err("unaligned: iova 0x%lx pa %pa size 0x%zx min_pagesz 0x%x\n",
> +			iova, &paddr, size, min_pagesz);
> +		return 0;
> +	}
> +
> +	if (!ops || !ops->merge_page) {
> +		pr_err("don't support merge page\n");
> +		return 0;
> +	}
> +
> +	while (size) {
> +		pgsize = iommu_pgsize(domain, iova | paddr, size);
> +
> +		merged_size = ops->merge_page(domain, iova, paddr, pgsize, prot);
> +
> +		pr_debug("merged: iova 0x%lx pa %pa size 0x%zx\n", iova, &paddr,
> +			 merged_size);
> +		iova += merged_size;
> +		paddr += merged_size;
> +		size -= merged_size;
> +		merged += merged_size;
> +
> +		if (merged_size != pgsize)
> +			break;
> +	}
> +
> +	return merged;
> +}
> +
> +size_t iommu_merge_page(struct iommu_domain *domain, unsigned long iova,
> +			size_t size, int prot)
> +{
> +	phys_addr_t phys;
> +	dma_addr_t p, i;
> +	size_t cont_size, merged_size;
> +	size_t merged = 0;
> +
> +	while (size) {
> +		phys = iommu_iova_to_phys(domain, iova);
> +		cont_size = PAGE_SIZE;
> +		p = phys + cont_size;
> +		i = iova + cont_size;
> +
> +		while (cont_size < size && p == iommu_iova_to_phys(domain, i)) {
> +			p += PAGE_SIZE;
> +			i += PAGE_SIZE;
> +			cont_size += PAGE_SIZE;
> +		}
> +
> +		merged_size = __iommu_merge_page(domain, iova, phys, cont_size,
> +				prot);

This is incredibly silly. The amount of time you'll spend just on 
walking the tables in all those iova_to_phys() calls is probably 
significantly more than it would take the low-level pagetable code to do 
the entire operation for itself. At this level, any knowledge of how 
mappings are actually constructed is lost once __iommu_map() returns, so 
we just don't know, and for this operation in particular there seems 
little point in trying to guess - the driver backend still has to figure 
out whether something we *think* might me mergeable actually is, so it's 
better off doing the entire operation in a single pass by itself.

There's especially little point in starting all this work *before* 
checking that it's even possible...

Robin.

> +		iova += merged_size;
> +		size -= merged_size;
> +		merged += merged_size;
> +
> +		if (merged_size != cont_size)
> +			break;
> +	}
> +	iommu_flush_iotlb_all(domain);
> +
> +	return merged;
> +}
> +EXPORT_SYMBOL_GPL(iommu_merge_page);
> +
>   void iommu_get_resv_regions(struct device *dev, struct list_head *list)
>   {
>   	const struct iommu_ops *ops = dev->bus->iommu_ops;
> diff --git a/include/linux/io-pgtable.h b/include/linux/io-pgtable.h
> index b87c6f4ecaa2..754b62a1bbaf 100644
> --- a/include/linux/io-pgtable.h
> +++ b/include/linux/io-pgtable.h
> @@ -164,6 +164,8 @@ struct io_pgtable_ops {
>   				    unsigned long iova);
>   	size_t (*split_block)(struct io_pgtable_ops *ops, unsigned long iova,
>   			      size_t size);
> +	size_t (*merge_page)(struct io_pgtable_ops *ops, unsigned long iova,
> +			     phys_addr_t phys, size_t size, int prot);
>   };
>   
>   /**
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index abeb811098a5..ac2b0b1bce0f 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -260,6 +260,8 @@ struct iommu_ops {
>   			       enum iommu_attr attr, void *data);
>   	size_t (*split_block)(struct iommu_domain *domain, unsigned long iova,
>   			      size_t size);
> +	size_t (*merge_page)(struct iommu_domain *domain, unsigned long iova,
> +			     phys_addr_t phys, size_t size, int prot);
>   
>   	/* Request/Free a list of reserved regions for a device */
>   	void (*get_resv_regions)(struct device *dev, struct list_head *list);
> @@ -513,6 +515,8 @@ extern int iommu_domain_set_attr(struct iommu_domain *domain, enum iommu_attr,
>   				 void *data);
>   extern size_t iommu_split_block(struct iommu_domain *domain, unsigned long iova,
>   				size_t size);
> +extern size_t iommu_merge_page(struct iommu_domain *domain, unsigned long iova,
> +			       size_t size, int prot);
>   
>   /* Window handling function prototypes */
>   extern int iommu_domain_window_enable(struct iommu_domain *domain, u32 wnd_nr,
> @@ -913,6 +917,12 @@ static inline size_t iommu_split_block(struct iommu_domain *domain,
>   	return 0;
>   }
>   
> +static inline size_t iommu_merge_page(struct iommu_domain *domain,
> +				      unsigned long iova, size_t size, int prot)
> +{
> +	return -EINVAL;
> +}
> +
>   static inline int  iommu_device_register(struct iommu_device *iommu)
>   {
>   	return -ENODEV;
> 
