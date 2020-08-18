Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFCA24898C
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 17:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbgHRPRO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 11:17:14 -0400
Received: from foss.arm.com ([217.140.110.172]:43304 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727103AbgHRPQ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 11:16:57 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0D81E101E;
        Tue, 18 Aug 2020 08:16:55 -0700 (PDT)
Received: from [10.57.40.122] (unknown [10.57.40.122])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B7ADC3F66B;
        Tue, 18 Aug 2020 08:16:49 -0700 (PDT)
Subject: Re: [PATCH V2 1/2] Add new flush_iotlb_range and handle freelists
 when using iommu_unmap_fast
To:     Tom Murphy <murphyt7@tcd.ie>, iommu@lists.linux-foundation.org
Cc:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Clark <robdclark@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-tegra@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
References: <20200818060415.19522-1-murphyt7@tcd.ie>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <7f16dd8b-3de9-e392-b526-796e605b6661@arm.com>
Date:   Tue, 18 Aug 2020 16:16:48 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200818060415.19522-1-murphyt7@tcd.ie>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-08-18 07:04, Tom Murphy wrote:
> Add a flush_iotlb_range to allow flushing of an iova range instead of a
> full flush in the dma-iommu path.
> 
> Allow the iommu_unmap_fast to return newly freed page table pages and
> pass the freelist to queue_iova in the dma-iommu ops path.
> 
> This patch is useful for iommu drivers (in this case the intel iommu
> driver) which need to wait for the ioTLB to be flushed before newly
> free/unmapped page table pages can be freed. This way we can still batch
> ioTLB free operations and handle the freelists.

It sounds like the freelist is something that logically belongs in the 
iommu_iotlb_gather structure. And even if it's not a perfect fit I'd be 
inclined to jam it in there anyway just to avoid this giant argument 
explosion ;)

Why exactly do we need to introduce a new flush_iotlb_range() op? Can't 
the AMD driver simply use the gather mechanism like everyone else?

Robin.

> Change-log:
> V2:
> -fix missing parameter in mtk_iommu_v1.c
> 
> Signed-off-by: Tom Murphy <murphyt7@tcd.ie>
> ---
>   drivers/iommu/amd/iommu.c       | 14 ++++++++-
>   drivers/iommu/arm-smmu-v3.c     |  3 +-
>   drivers/iommu/arm-smmu.c        |  3 +-
>   drivers/iommu/dma-iommu.c       | 45 ++++++++++++++++++++-------
>   drivers/iommu/exynos-iommu.c    |  3 +-
>   drivers/iommu/intel/iommu.c     | 54 +++++++++++++++++++++------------
>   drivers/iommu/iommu.c           | 25 +++++++++++----
>   drivers/iommu/ipmmu-vmsa.c      |  3 +-
>   drivers/iommu/msm_iommu.c       |  3 +-
>   drivers/iommu/mtk_iommu.c       |  3 +-
>   drivers/iommu/mtk_iommu_v1.c    |  3 +-
>   drivers/iommu/omap-iommu.c      |  3 +-
>   drivers/iommu/qcom_iommu.c      |  3 +-
>   drivers/iommu/rockchip-iommu.c  |  3 +-
>   drivers/iommu/s390-iommu.c      |  3 +-
>   drivers/iommu/sun50i-iommu.c    |  3 +-
>   drivers/iommu/tegra-gart.c      |  3 +-
>   drivers/iommu/tegra-smmu.c      |  3 +-
>   drivers/iommu/virtio-iommu.c    |  3 +-
>   drivers/vfio/vfio_iommu_type1.c |  2 +-
>   include/linux/iommu.h           | 21 +++++++++++--
>   21 files changed, 150 insertions(+), 56 deletions(-)
> 
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index 2f22326ee4df..25fbacab23c3 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -2513,7 +2513,8 @@ static int amd_iommu_map(struct iommu_domain *dom, unsigned long iova,
>   
>   static size_t amd_iommu_unmap(struct iommu_domain *dom, unsigned long iova,
>   			      size_t page_size,
> -			      struct iommu_iotlb_gather *gather)
> +			      struct iommu_iotlb_gather *gather,
> +			      struct page **freelist)
>   {
>   	struct protection_domain *domain = to_pdomain(dom);
>   	struct domain_pgtable pgtable;
> @@ -2636,6 +2637,16 @@ static void amd_iommu_flush_iotlb_all(struct iommu_domain *domain)
>   	spin_unlock_irqrestore(&dom->lock, flags);
>   }
>   
> +static void amd_iommu_flush_iotlb_range(struct iommu_domain *domain,
> +					unsigned long iova, size_t size,
> +					struct page *freelist)
> +{
> +	struct protection_domain *dom = to_pdomain(domain);
> +
> +	domain_flush_pages(dom, iova, size);
> +	domain_flush_complete(dom);
> +}
> +
>   static void amd_iommu_iotlb_sync(struct iommu_domain *domain,
>   				 struct iommu_iotlb_gather *gather)
>   {
> @@ -2675,6 +2686,7 @@ const struct iommu_ops amd_iommu_ops = {
>   	.is_attach_deferred = amd_iommu_is_attach_deferred,
>   	.pgsize_bitmap	= AMD_IOMMU_PGSIZES,
>   	.flush_iotlb_all = amd_iommu_flush_iotlb_all,
> +	.flush_iotlb_range = amd_iommu_flush_iotlb_range,
>   	.iotlb_sync = amd_iommu_iotlb_sync,
>   	.def_domain_type = amd_iommu_def_domain_type,
>   };
> diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
> index f578677a5c41..8d328dc25326 100644
> --- a/drivers/iommu/arm-smmu-v3.c
> +++ b/drivers/iommu/arm-smmu-v3.c
> @@ -2854,7 +2854,8 @@ static int arm_smmu_map(struct iommu_domain *domain, unsigned long iova,
>   }
>   
>   static size_t arm_smmu_unmap(struct iommu_domain *domain, unsigned long iova,
> -			     size_t size, struct iommu_iotlb_gather *gather)
> +			     size_t size, struct iommu_iotlb_gather *gather,
> +			     struct page **freelist)
>   {
>   	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
>   	struct io_pgtable_ops *ops = smmu_domain->pgtbl_ops;
> diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
> index 243bc4cb2705..0cd0dfc89875 100644
> --- a/drivers/iommu/arm-smmu.c
> +++ b/drivers/iommu/arm-smmu.c
> @@ -1234,7 +1234,8 @@ static int arm_smmu_map(struct iommu_domain *domain, unsigned long iova,
>   }
>   
>   static size_t arm_smmu_unmap(struct iommu_domain *domain, unsigned long iova,
> -			     size_t size, struct iommu_iotlb_gather *gather)
> +			     size_t size, struct iommu_iotlb_gather *gather,
> +			     struct page **freelist)
>   {
>   	struct io_pgtable_ops *ops = to_smmu_domain(domain)->pgtbl_ops;
>   	struct arm_smmu_device *smmu = to_smmu_domain(domain)->smmu;
> diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
> index 4959f5df21bd..7433f74d921a 100644
> --- a/drivers/iommu/dma-iommu.c
> +++ b/drivers/iommu/dma-iommu.c
> @@ -50,6 +50,19 @@ struct iommu_dma_cookie {
>   	struct iommu_domain		*fq_domain;
>   };
>   
> +
> +static void iommu_dma_entry_dtor(unsigned long data)
> +{
> +	struct page *freelist = (struct page *)data;
> +
> +	while (freelist != NULL) {
> +		unsigned long p = (unsigned long)page_address(freelist);
> +
> +		freelist = freelist->freelist;
> +		free_page(p);
> +	}
> +}
> +
>   static inline size_t cookie_msi_granule(struct iommu_dma_cookie *cookie)
>   {
>   	if (cookie->type == IOMMU_DMA_IOVA_COOKIE)
> @@ -344,7 +357,8 @@ static int iommu_dma_init_domain(struct iommu_domain *domain, dma_addr_t base,
>   	if (!cookie->fq_domain && !iommu_domain_get_attr(domain,
>   			DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE, &attr) && attr) {
>   		cookie->fq_domain = domain;
> -		init_iova_flush_queue(iovad, iommu_dma_flush_iotlb_all, NULL);
> +		init_iova_flush_queue(iovad, iommu_dma_flush_iotlb_all,
> +				iommu_dma_entry_dtor);
>   	}
>   
>   	if (!dev)
> @@ -438,7 +452,7 @@ static dma_addr_t iommu_dma_alloc_iova(struct iommu_domain *domain,
>   }
>   
>   static void iommu_dma_free_iova(struct iommu_dma_cookie *cookie,
> -		dma_addr_t iova, size_t size)
> +		dma_addr_t iova, size_t size, struct page *freelist)
>   {
>   	struct iova_domain *iovad = &cookie->iovad;
>   
> @@ -447,7 +461,8 @@ static void iommu_dma_free_iova(struct iommu_dma_cookie *cookie,
>   		cookie->msi_iova -= size;
>   	else if (cookie->fq_domain)	/* non-strict mode */
>   		queue_iova(iovad, iova_pfn(iovad, iova),
> -				size >> iova_shift(iovad), 0);
> +				size >> iova_shift(iovad),
> +				(unsigned long) freelist);
>   	else
>   		free_iova_fast(iovad, iova_pfn(iovad, iova),
>   				size >> iova_shift(iovad));
> @@ -461,18 +476,26 @@ static void __iommu_dma_unmap(struct device *dev, dma_addr_t dma_addr,
>   	struct iova_domain *iovad = &cookie->iovad;
>   	size_t iova_off = iova_offset(iovad, dma_addr);
>   	struct iommu_iotlb_gather iotlb_gather;
> +	struct page *freelist = NULL;
>   	size_t unmapped;
>   
>   	dma_addr -= iova_off;
>   	size = iova_align(iovad, size + iova_off);
>   	iommu_iotlb_gather_init(&iotlb_gather);
>   
> -	unmapped = iommu_unmap_fast(domain, dma_addr, size, &iotlb_gather);
> +	unmapped = iommu_unmap_fast(domain, dma_addr, size, &iotlb_gather,
> +			&freelist);
>   	WARN_ON(unmapped != size);
>   
> -	if (!cookie->fq_domain)
> -		iommu_tlb_sync(domain, &iotlb_gather);
> -	iommu_dma_free_iova(cookie, dma_addr, size);
> +	if (!cookie->fq_domain) {
> +		if (domain->ops->flush_iotlb_range)
> +			domain->ops->flush_iotlb_range(domain, dma_addr, size,
> +					freelist);
> +		else
> +			iommu_tlb_sync(domain, &iotlb_gather);
> +	}
> +
> +	iommu_dma_free_iova(cookie, dma_addr, size, freelist);
>   }
>   
>   static dma_addr_t __iommu_dma_map(struct device *dev, phys_addr_t phys,
> @@ -494,7 +517,7 @@ static dma_addr_t __iommu_dma_map(struct device *dev, phys_addr_t phys,
>   		return DMA_MAPPING_ERROR;
>   
>   	if (iommu_map_atomic(domain, iova, phys - iova_off, size, prot)) {
> -		iommu_dma_free_iova(cookie, iova, size);
> +		iommu_dma_free_iova(cookie, iova, size, NULL);
>   		return DMA_MAPPING_ERROR;
>   	}
>   	return iova + iova_off;
> @@ -649,7 +672,7 @@ static void *iommu_dma_alloc_remap(struct device *dev, size_t size,
>   out_free_sg:
>   	sg_free_table(&sgt);
>   out_free_iova:
> -	iommu_dma_free_iova(cookie, iova, size);
> +	iommu_dma_free_iova(cookie, iova, size, NULL);
>   out_free_pages:
>   	__iommu_dma_free_pages(pages, count);
>   	return NULL;
> @@ -900,7 +923,7 @@ static int iommu_dma_map_sg(struct device *dev, struct scatterlist *sg,
>   	return __finalise_sg(dev, sg, nents, iova);
>   
>   out_free_iova:
> -	iommu_dma_free_iova(cookie, iova, iova_len);
> +	iommu_dma_free_iova(cookie, iova, iova_len, NULL);
>   out_restore_sg:
>   	__invalidate_sg(sg, nents);
>   	return 0;
> @@ -1194,7 +1217,7 @@ static struct iommu_dma_msi_page *iommu_dma_get_msi_page(struct device *dev,
>   	return msi_page;
>   
>   out_free_iova:
> -	iommu_dma_free_iova(cookie, iova, size);
> +	iommu_dma_free_iova(cookie, iova, size, NULL);
>   out_free_page:
>   	kfree(msi_page);
>   	return NULL;
> diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> index 60c8a56e4a3f..5d98985e60a2 100644
> --- a/drivers/iommu/exynos-iommu.c
> +++ b/drivers/iommu/exynos-iommu.c
> @@ -1129,7 +1129,8 @@ static void exynos_iommu_tlb_invalidate_entry(struct exynos_iommu_domain *domain
>   
>   static size_t exynos_iommu_unmap(struct iommu_domain *iommu_domain,
>   				 unsigned long l_iova, size_t size,
> -				 struct iommu_iotlb_gather *gather)
> +				 struct iommu_iotlb_gather *gather,
> +				 struct page **freelist)
>   {
>   	struct exynos_iommu_domain *domain = to_exynos_domain(iommu_domain);
>   	sysmmu_iova_t iova = (sysmmu_iova_t)l_iova;
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index 237a470e1e9c..878178fe48f8 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -1160,17 +1160,17 @@ static struct page *dma_pte_clear_level(struct dmar_domain *domain, int level,
>      pages can only be freed after the IOTLB flush has been done. */
>   static struct page *domain_unmap(struct dmar_domain *domain,
>   				 unsigned long start_pfn,
> -				 unsigned long last_pfn)
> +				 unsigned long last_pfn,
> +				 struct page *freelist)
>   {
> -	struct page *freelist;
> -
>   	BUG_ON(!domain_pfn_supported(domain, start_pfn));
>   	BUG_ON(!domain_pfn_supported(domain, last_pfn));
>   	BUG_ON(start_pfn > last_pfn);
>   
>   	/* we don't need lock here; nobody else touches the iova range */
>   	freelist = dma_pte_clear_level(domain, agaw_to_level(domain->agaw),
> -				       domain->pgd, 0, start_pfn, last_pfn, NULL);
> +				       domain->pgd, 0, start_pfn, last_pfn,
> +				       freelist);
>   
>   	/* free pgd */
>   	if (start_pfn == 0 && last_pfn == DOMAIN_MAX_PFN(domain->gaw)) {
> @@ -1924,7 +1924,8 @@ static void domain_exit(struct dmar_domain *domain)
>   	if (domain->pgd) {
>   		struct page *freelist;
>   
> -		freelist = domain_unmap(domain, 0, DOMAIN_MAX_PFN(domain->gaw));
> +		freelist = domain_unmap(domain, 0, DOMAIN_MAX_PFN(domain->gaw),
> +				NULL);
>   		dma_free_pagelist(freelist);
>   	}
>   
> @@ -3480,7 +3481,7 @@ static void intel_unmap(struct device *dev, dma_addr_t dev_addr, size_t size)
>   	if (dev_is_pci(dev))
>   		pdev = to_pci_dev(dev);
>   
> -	freelist = domain_unmap(domain, start_pfn, last_pfn);
> +	freelist = domain_unmap(domain, start_pfn, last_pfn, NULL);
>   	if (intel_iommu_strict || (pdev && pdev->untrusted) ||
>   			!has_iova_flush_queue(&domain->iovad)) {
>   		iommu_flush_iotlb_psi(iommu, domain, start_pfn,
> @@ -4575,7 +4576,8 @@ static int intel_iommu_memory_notifier(struct notifier_block *nb,
>   			struct page *freelist;
>   
>   			freelist = domain_unmap(si_domain,
> -						start_vpfn, last_vpfn);
> +						start_vpfn, last_vpfn,
> +						NULL);
>   
>   			rcu_read_lock();
>   			for_each_active_iommu(iommu, drhd)
> @@ -5540,13 +5542,12 @@ static int intel_iommu_map(struct iommu_domain *domain,
>   
>   static size_t intel_iommu_unmap(struct iommu_domain *domain,
>   				unsigned long iova, size_t size,
> -				struct iommu_iotlb_gather *gather)
> +				struct iommu_iotlb_gather *gather,
> +				struct page **freelist)
>   {
>   	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
> -	struct page *freelist = NULL;
>   	unsigned long start_pfn, last_pfn;
> -	unsigned int npages;
> -	int iommu_id, level = 0;
> +	int level = 0;
>   
>   	/* Cope with horrid API which requires us to unmap more than the
>   	   size argument if it happens to be a large-page mapping. */
> @@ -5558,22 +5559,36 @@ static size_t intel_iommu_unmap(struct iommu_domain *domain,
>   	start_pfn = iova >> VTD_PAGE_SHIFT;
>   	last_pfn = (iova + size - 1) >> VTD_PAGE_SHIFT;
>   
> -	freelist = domain_unmap(dmar_domain, start_pfn, last_pfn);
> +	*freelist = domain_unmap(dmar_domain, start_pfn, last_pfn, *freelist);
> +
> +	if (dmar_domain->max_addr == iova + size)
> +		dmar_domain->max_addr = iova;
>   
> -	npages = last_pfn - start_pfn + 1;
> +	return size;
> +}
> +
> +static void intel_iommu_flush_iotlb_range(struct iommu_domain *domain, unsigned
> +		long iova, size_t size,
> +		struct page *freelist)
> +{
> +	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
> +	unsigned long start_pfn, last_pfn;
> +	unsigned long iova_pfn = IOVA_PFN(iova);
> +	unsigned long nrpages;
> +	int iommu_id;
> +
> +	nrpages = aligned_nrpages(iova, size);
> +	start_pfn = mm_to_dma_pfn(iova_pfn);
> +	last_pfn = start_pfn + nrpages - 1;
>   
>   	for_each_domain_iommu(iommu_id, dmar_domain)
>   		iommu_flush_iotlb_psi(g_iommus[iommu_id], dmar_domain,
> -				      start_pfn, npages, !freelist, 0);
> +				      start_pfn, nrpages, !freelist, 0);
>   
>   	dma_free_pagelist(freelist);
> -
> -	if (dmar_domain->max_addr == iova + size)
> -		dmar_domain->max_addr = iova;
> -
> -	return size;
>   }
>   
> +
>   static phys_addr_t intel_iommu_iova_to_phys(struct iommu_domain *domain,
>   					    dma_addr_t iova)
>   {
> @@ -6058,6 +6073,7 @@ const struct iommu_ops intel_iommu_ops = {
>   	.aux_get_pasid		= intel_iommu_aux_get_pasid,
>   	.map			= intel_iommu_map,
>   	.unmap			= intel_iommu_unmap,
> +	.flush_iotlb_range	= intel_iommu_flush_iotlb_range,
>   	.iova_to_phys		= intel_iommu_iova_to_phys,
>   	.probe_device		= intel_iommu_probe_device,
>   	.probe_finalize		= intel_iommu_probe_finalize,
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index b6858adc4f17..9065127d7e9c 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -2245,11 +2245,13 @@ EXPORT_SYMBOL_GPL(iommu_map_atomic);
>   
>   static size_t __iommu_unmap(struct iommu_domain *domain,
>   			    unsigned long iova, size_t size,
> -			    struct iommu_iotlb_gather *iotlb_gather)
> +			    struct iommu_iotlb_gather *iotlb_gather,
> +			    struct page **freelist)
>   {
>   	const struct iommu_ops *ops = domain->ops;
>   	size_t unmapped_page, unmapped = 0;
>   	unsigned long orig_iova = iova;
> +	struct page *freelist_head = NULL;
>   	unsigned int min_pagesz;
>   
>   	if (unlikely(ops->unmap == NULL ||
> @@ -2282,7 +2284,8 @@ static size_t __iommu_unmap(struct iommu_domain *domain,
>   	while (unmapped < size) {
>   		size_t pgsize = iommu_pgsize(domain, iova, size - unmapped);
>   
> -		unmapped_page = ops->unmap(domain, iova, pgsize, iotlb_gather);
> +		unmapped_page = ops->unmap(domain, iova, pgsize, iotlb_gather,
> +				&freelist_head);
>   		if (!unmapped_page)
>   			break;
>   
> @@ -2293,6 +2296,9 @@ static size_t __iommu_unmap(struct iommu_domain *domain,
>   		unmapped += unmapped_page;
>   	}
>   
> +	if (freelist)
> +		*freelist = freelist_head;
> +
>   	trace_unmap(orig_iova, size, unmapped);
>   	return unmapped;
>   }
> @@ -2300,12 +2306,18 @@ static size_t __iommu_unmap(struct iommu_domain *domain,
>   size_t iommu_unmap(struct iommu_domain *domain,
>   		   unsigned long iova, size_t size)
>   {
> +	const struct iommu_ops *ops = domain->ops;
>   	struct iommu_iotlb_gather iotlb_gather;
> +	struct page *freelist;
>   	size_t ret;
>   
>   	iommu_iotlb_gather_init(&iotlb_gather);
> -	ret = __iommu_unmap(domain, iova, size, &iotlb_gather);
> -	iommu_tlb_sync(domain, &iotlb_gather);
> +	ret = __iommu_unmap(domain, iova, size, &iotlb_gather, &freelist);
> +
> +	if (ops->flush_iotlb_range)
> +		ops->flush_iotlb_range(domain, iova, ret, freelist);
> +	else
> +		iommu_tlb_sync(domain, &iotlb_gather);
>   
>   	return ret;
>   }
> @@ -2313,9 +2325,10 @@ EXPORT_SYMBOL_GPL(iommu_unmap);
>   
>   size_t iommu_unmap_fast(struct iommu_domain *domain,
>   			unsigned long iova, size_t size,
> -			struct iommu_iotlb_gather *iotlb_gather)
> +			struct iommu_iotlb_gather *iotlb_gather,
> +			struct page **freelist)
>   {
> -	return __iommu_unmap(domain, iova, size, iotlb_gather);
> +	return __iommu_unmap(domain, iova, size, iotlb_gather, freelist);
>   }
>   EXPORT_SYMBOL_GPL(iommu_unmap_fast);
>   
> diff --git a/drivers/iommu/ipmmu-vmsa.c b/drivers/iommu/ipmmu-vmsa.c
> index 6de86e73dfc3..08c39e95e387 100644
> --- a/drivers/iommu/ipmmu-vmsa.c
> +++ b/drivers/iommu/ipmmu-vmsa.c
> @@ -690,7 +690,8 @@ static int ipmmu_map(struct iommu_domain *io_domain, unsigned long iova,
>   }
>   
>   static size_t ipmmu_unmap(struct iommu_domain *io_domain, unsigned long iova,
> -			  size_t size, struct iommu_iotlb_gather *gather)
> +			  size_t size, struct iommu_iotlb_gather *gather,
> +			  struct page **freelist)
>   {
>   	struct ipmmu_vmsa_domain *domain = to_vmsa_domain(io_domain);
>   
> diff --git a/drivers/iommu/msm_iommu.c b/drivers/iommu/msm_iommu.c
> index 3d8a63555c25..8a987067771c 100644
> --- a/drivers/iommu/msm_iommu.c
> +++ b/drivers/iommu/msm_iommu.c
> @@ -498,7 +498,8 @@ static int msm_iommu_map(struct iommu_domain *domain, unsigned long iova,
>   }
>   
>   static size_t msm_iommu_unmap(struct iommu_domain *domain, unsigned long iova,
> -			      size_t len, struct iommu_iotlb_gather *gather)
> +			      size_t len, struct iommu_iotlb_gather *gather,
> +			      struct page **freelist)
>   {
>   	struct msm_priv *priv = to_msm_priv(domain);
>   	unsigned long flags;
> diff --git a/drivers/iommu/mtk_iommu.c b/drivers/iommu/mtk_iommu.c
> index 2be96f1cdbd2..b97d35a7d817 100644
> --- a/drivers/iommu/mtk_iommu.c
> +++ b/drivers/iommu/mtk_iommu.c
> @@ -402,7 +402,8 @@ static int mtk_iommu_map(struct iommu_domain *domain, unsigned long iova,
>   
>   static size_t mtk_iommu_unmap(struct iommu_domain *domain,
>   			      unsigned long iova, size_t size,
> -			      struct iommu_iotlb_gather *gather)
> +			      struct iommu_iotlb_gather *gather,
> +			      struct page **freelist)
>   {
>   	struct mtk_iommu_domain *dom = to_mtk_domain(domain);
>   
> diff --git a/drivers/iommu/mtk_iommu_v1.c b/drivers/iommu/mtk_iommu_v1.c
> index c9d79cff4d17..ac44498183b7 100644
> --- a/drivers/iommu/mtk_iommu_v1.c
> +++ b/drivers/iommu/mtk_iommu_v1.c
> @@ -325,7 +325,8 @@ static int mtk_iommu_map(struct iommu_domain *domain, unsigned long iova,
>   
>   static size_t mtk_iommu_unmap(struct iommu_domain *domain,
>   			      unsigned long iova, size_t size,
> -			      struct iommu_iotlb_gather *gather)
> +			      struct iommu_iotlb_gather *gather,
> +			      struct page **freelist)
>   {
>   	struct mtk_iommu_domain *dom = to_mtk_domain(domain);
>   	unsigned long flags;
> diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
> index c8282cc212cb..17d3cfcb8cd3 100644
> --- a/drivers/iommu/omap-iommu.c
> +++ b/drivers/iommu/omap-iommu.c
> @@ -1367,7 +1367,8 @@ static int omap_iommu_map(struct iommu_domain *domain, unsigned long da,
>   }
>   
>   static size_t omap_iommu_unmap(struct iommu_domain *domain, unsigned long da,
> -			       size_t size, struct iommu_iotlb_gather *gather)
> +			       size_t size, struct iommu_iotlb_gather *gather,
> +			       struct page **freelist)
>   {
>   	struct omap_iommu_domain *omap_domain = to_omap_domain(domain);
>   	struct device *dev = omap_domain->dev;
> diff --git a/drivers/iommu/qcom_iommu.c b/drivers/iommu/qcom_iommu.c
> index d176df569af8..9c66261ce59e 100644
> --- a/drivers/iommu/qcom_iommu.c
> +++ b/drivers/iommu/qcom_iommu.c
> @@ -444,7 +444,8 @@ static int qcom_iommu_map(struct iommu_domain *domain, unsigned long iova,
>   }
>   
>   static size_t qcom_iommu_unmap(struct iommu_domain *domain, unsigned long iova,
> -			       size_t size, struct iommu_iotlb_gather *gather)
> +			       size_t size, struct iommu_iotlb_gather *gather,
> +			       struct page **freelist)
>   {
>   	size_t ret;
>   	unsigned long flags;
> diff --git a/drivers/iommu/rockchip-iommu.c b/drivers/iommu/rockchip-iommu.c
> index d25c2486ca07..d508c037081a 100644
> --- a/drivers/iommu/rockchip-iommu.c
> +++ b/drivers/iommu/rockchip-iommu.c
> @@ -795,7 +795,8 @@ static int rk_iommu_map(struct iommu_domain *domain, unsigned long _iova,
>   }
>   
>   static size_t rk_iommu_unmap(struct iommu_domain *domain, unsigned long _iova,
> -			     size_t size, struct iommu_iotlb_gather *gather)
> +			     size_t size, struct iommu_iotlb_gather *gather,
> +			     struct page **freelist)
>   {
>   	struct rk_iommu_domain *rk_domain = to_rk_domain(domain);
>   	unsigned long flags;
> diff --git a/drivers/iommu/s390-iommu.c b/drivers/iommu/s390-iommu.c
> index 8895dbb705eb..8c96659acbe2 100644
> --- a/drivers/iommu/s390-iommu.c
> +++ b/drivers/iommu/s390-iommu.c
> @@ -305,7 +305,8 @@ static phys_addr_t s390_iommu_iova_to_phys(struct iommu_domain *domain,
>   
>   static size_t s390_iommu_unmap(struct iommu_domain *domain,
>   			       unsigned long iova, size_t size,
> -			       struct iommu_iotlb_gather *gather)
> +			       struct iommu_iotlb_gather *gather,
> +			       struct page **freelist)
>   {
>   	struct s390_domain *s390_domain = to_s390_domain(domain);
>   	int flags = ZPCI_PTE_INVALID;
> diff --git a/drivers/iommu/sun50i-iommu.c b/drivers/iommu/sun50i-iommu.c
> index 3b1bf2fb94f5..fb0558b82dfa 100644
> --- a/drivers/iommu/sun50i-iommu.c
> +++ b/drivers/iommu/sun50i-iommu.c
> @@ -552,7 +552,8 @@ static int sun50i_iommu_map(struct iommu_domain *domain, unsigned long iova,
>   }
>   
>   static size_t sun50i_iommu_unmap(struct iommu_domain *domain, unsigned long iova,
> -				 size_t size, struct iommu_iotlb_gather *gather)
> +				 size_t size, struct iommu_iotlb_gather *gather,
> +				 struct page **freelist)
>   {
>   	struct sun50i_iommu_domain *sun50i_domain = to_sun50i_domain(domain);
>   	phys_addr_t pt_phys;
> diff --git a/drivers/iommu/tegra-gart.c b/drivers/iommu/tegra-gart.c
> index 5fbdff6ff41a..22168376c429 100644
> --- a/drivers/iommu/tegra-gart.c
> +++ b/drivers/iommu/tegra-gart.c
> @@ -207,7 +207,8 @@ static inline int __gart_iommu_unmap(struct gart_device *gart,
>   }
>   
>   static size_t gart_iommu_unmap(struct iommu_domain *domain, unsigned long iova,
> -			       size_t bytes, struct iommu_iotlb_gather *gather)
> +			       size_t bytes, struct iommu_iotlb_gather *gather,
> +			       struct page **freelist)
>   {
>   	struct gart_device *gart = gart_handle;
>   	int err;
> diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
> index 7426b7666e2b..1ac2ac851cfe 100644
> --- a/drivers/iommu/tegra-smmu.c
> +++ b/drivers/iommu/tegra-smmu.c
> @@ -686,7 +686,8 @@ static int tegra_smmu_map(struct iommu_domain *domain, unsigned long iova,
>   }
>   
>   static size_t tegra_smmu_unmap(struct iommu_domain *domain, unsigned long iova,
> -			       size_t size, struct iommu_iotlb_gather *gather)
> +			       size_t size, struct iommu_iotlb_gather *gather,
> +			       struct page **freelist)
>   {
>   	struct tegra_smmu_as *as = to_smmu_as(domain);
>   	dma_addr_t pte_dma;
> diff --git a/drivers/iommu/virtio-iommu.c b/drivers/iommu/virtio-iommu.c
> index f6f07489a9aa..ea4d527b5e64 100644
> --- a/drivers/iommu/virtio-iommu.c
> +++ b/drivers/iommu/virtio-iommu.c
> @@ -762,7 +762,8 @@ static int viommu_map(struct iommu_domain *domain, unsigned long iova,
>   }
>   
>   static size_t viommu_unmap(struct iommu_domain *domain, unsigned long iova,
> -			   size_t size, struct iommu_iotlb_gather *gather)
> +			   size_t size, struct iommu_iotlb_gather *gather,
> +			   struct page **freelist)
>   {
>   	int ret = 0;
>   	size_t unmapped;
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 5e556ac9102a..570ebf878fea 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -812,7 +812,7 @@ static size_t unmap_unpin_fast(struct vfio_domain *domain,
>   
>   	if (entry) {
>   		unmapped = iommu_unmap_fast(domain->domain, *iova, len,
> -					    iotlb_gather);
> +					    iotlb_gather, NULL);
>   
>   		if (!unmapped) {
>   			kfree(entry);
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 5f0b7859d2eb..77e773d03f22 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -198,6 +198,7 @@ struct iommu_iotlb_gather {
>    * @map: map a physically contiguous memory region to an iommu domain
>    * @unmap: unmap a physically contiguous memory region from an iommu domain
>    * @flush_iotlb_all: Synchronously flush all hardware TLBs for this domain
> + * @flush_iotlb_range: Flush given iova range of hardware TLBs for this domain
>    * @iotlb_sync_map: Sync mappings created recently using @map to the hardware
>    * @iotlb_sync: Flush all queued ranges from the hardware TLBs and empty flush
>    *            queue
> @@ -248,8 +249,12 @@ struct iommu_ops {
>   	int (*map)(struct iommu_domain *domain, unsigned long iova,
>   		   phys_addr_t paddr, size_t size, int prot, gfp_t gfp);
>   	size_t (*unmap)(struct iommu_domain *domain, unsigned long iova,
> -		     size_t size, struct iommu_iotlb_gather *iotlb_gather);
> +		     size_t size, struct iommu_iotlb_gather *iotlb_gather,
> +		     struct page **freelist);
>   	void (*flush_iotlb_all)(struct iommu_domain *domain);
> +	void (*flush_iotlb_range)(struct iommu_domain *domain,
> +				  unsigned long iova, size_t size,
> +				  struct page *freelist);
>   	void (*iotlb_sync_map)(struct iommu_domain *domain);
>   	void (*iotlb_sync)(struct iommu_domain *domain,
>   			   struct iommu_iotlb_gather *iotlb_gather);
> @@ -447,7 +452,8 @@ extern size_t iommu_unmap(struct iommu_domain *domain, unsigned long iova,
>   			  size_t size);
>   extern size_t iommu_unmap_fast(struct iommu_domain *domain,
>   			       unsigned long iova, size_t size,
> -			       struct iommu_iotlb_gather *iotlb_gather);
> +			       struct iommu_iotlb_gather *iotlb_gather,
> +			       struct page **freelist);
>   extern size_t iommu_map_sg(struct iommu_domain *domain, unsigned long iova,
>   			   struct scatterlist *sg,unsigned int nents, int prot);
>   extern size_t iommu_map_sg_atomic(struct iommu_domain *domain,
> @@ -542,6 +548,14 @@ static inline void iommu_flush_tlb_all(struct iommu_domain *domain)
>   		domain->ops->flush_iotlb_all(domain);
>   }
>   
> +static inline void flush_iotlb_range(struct iommu_domain *domain,
> +				     unsigned long iova, size_t size,
> +				     struct page *freelist)
> +{
> +	if (domain->ops->flush_iotlb_range)
> +		domain->ops->flush_iotlb_range(domain, iova, size, freelist);
> +}
> +
>   static inline void iommu_tlb_sync(struct iommu_domain *domain,
>   				  struct iommu_iotlb_gather *iotlb_gather)
>   {
> @@ -728,7 +742,8 @@ static inline size_t iommu_unmap(struct iommu_domain *domain,
>   
>   static inline size_t iommu_unmap_fast(struct iommu_domain *domain,
>   				      unsigned long iova, int gfp_order,
> -				      struct iommu_iotlb_gather *iotlb_gather)
> +				      struct iommu_iotlb_gather *iotlb_gather,
> +				      struct page **freelist)
>   {
>   	return 0;
>   }
> 
