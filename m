Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46C367CEE51
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 05:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbjJSDH6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 23:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231709AbjJSDHz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 23:07:55 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72BFB119
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 20:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697684870; x=1729220870;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SURaZ4QjUSZQbrwcV71NsEev7AjZejWHP2ZfTG57Hv0=;
  b=QzA55KG5Mkyphyt13NMWATK6QnQGDDh+W04DJw9NNZTBVvLqZUROIEZV
   iTTb3QR20lLL9XcYQNU3sfSyBFYItnFm++7Uizi5CGdc0gwuaNnHirWa9
   HBA5njnm60sGjHOM8oUOWnwyzBwTOZYT1UcNTozWwwApP3kdQC7ZF1cei
   j+rSHJ2KId2KlTzA5g4QafgdGXB61QH1zN9nQ+lmKf53NEnPACwln6peI
   okYzkykTobfKL54h8A7NTD0AMC0zJeR+ZHmkH7CWUn2yzMzoEBZ+Tz1/M
   2Z82asKZg6I0xcdiWdx3ZAyZ05FH3TBXe7gfqzgopORL9UhFGyvn0+40b
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10867"; a="452633448"
X-IronPort-AV: E=Sophos;i="6.03,236,1694761200"; 
   d="scan'208";a="452633448"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2023 20:07:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10867"; a="930444871"
X-IronPort-AV: E=Sophos;i="6.03,236,1694761200"; 
   d="scan'208";a="930444871"
Received: from allen-box.sh.intel.com (HELO [10.239.159.127]) ([10.239.159.127])
  by orsmga005.jf.intel.com with ESMTP; 18 Oct 2023 20:07:44 -0700
Message-ID: <fe60a4d5-e134-43fb-bab5-d29341821784@linux.intel.com>
Date:   Thu, 19 Oct 2023 11:04:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc:     baolu.lu@linux.intel.com, Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v4 12/18] iommu/intel: Access/Dirty bit support for SL
 domains
Content-Language: en-US
To:     Joao Martins <joao.m.martins@oracle.com>, iommu@lists.linux.dev
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-13-joao.m.martins@oracle.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20231018202715.69734-13-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/19/23 4:27 AM, Joao Martins wrote:
> IOMMU advertises Access/Dirty bits for second-stage page table if the
> extended capability DMAR register reports it (ECAP, mnemonic ECAP.SSADS).
> The first stage table is compatible with CPU page table thus A/D bits are
> implicitly supported. Relevant Intel IOMMU SDM ref for first stage table
> "3.6.2 Accessed, Extended Accessed, and Dirty Flags" and second stage table
> "3.7.2 Accessed and Dirty Flags".
> 
> First stage page table is enabled by default so it's allowed to set dirty
> tracking and no control bits needed, it just returns 0. To use SSADS, set
> bit 9 (SSADE) in the scalable-mode PASID table entry and flush the IOTLB
> via pasid_flush_caches() following the manual. Relevant SDM refs:
> 
> "3.7.2 Accessed and Dirty Flags"
> "6.5.3.3 Guidance to Software for Invalidations,
>   Table 23. Guidance to Software for Invalidations"
> 
> PTE dirty bit is located in bit 9 and it's cached in the IOTLB so flush
> IOTLB to make sure IOMMU attempts to set the dirty bit again. Note that
> iommu_dirty_bitmap_record() will add the IOVA to iotlb_gather and thus the
> caller of the iommu op will flush the IOTLB. Relevant manuals over the
> hardware translation is chapter 6 with some special mention to:
> 
> "6.2.3.1 Scalable-Mode PASID-Table Entry Programming Considerations"
> "6.2.4 IOTLB"
> 
> Select IOMMUFD_DRIVER only if IOMMUFD is enabled, given that IOMMU dirty
> tracking requires IOMMUFD.
> 
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>   drivers/iommu/intel/Kconfig |   1 +
>   drivers/iommu/intel/iommu.c | 104 +++++++++++++++++++++++++++++++++-
>   drivers/iommu/intel/iommu.h |  17 ++++++
>   drivers/iommu/intel/pasid.c | 109 ++++++++++++++++++++++++++++++++++++
>   drivers/iommu/intel/pasid.h |   4 ++
>   5 files changed, 234 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/intel/Kconfig b/drivers/iommu/intel/Kconfig
> index 2e56bd79f589..f5348b80652b 100644
> --- a/drivers/iommu/intel/Kconfig
> +++ b/drivers/iommu/intel/Kconfig
> @@ -15,6 +15,7 @@ config INTEL_IOMMU
>   	select DMA_OPS
>   	select IOMMU_API
>   	select IOMMU_IOVA
> +	select IOMMUFD_DRIVER if IOMMUFD
>   	select NEED_DMA_MAP_STATE
>   	select DMAR_TABLE
>   	select SWIOTLB
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index 017aed5813d8..405b459416d5 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -300,6 +300,7 @@ static int iommu_skip_te_disable;
>   #define IDENTMAP_AZALIA		4
>   
>   const struct iommu_ops intel_iommu_ops;
> +const struct iommu_dirty_ops intel_dirty_ops;
>   
>   static bool translation_pre_enabled(struct intel_iommu *iommu)
>   {
> @@ -4077,10 +4078,12 @@ static struct iommu_domain *intel_iommu_domain_alloc(unsigned type)
>   static struct iommu_domain *
>   intel_iommu_domain_alloc_user(struct device *dev, u32 flags)
>   {
> +	bool enforce_dirty = (flags & IOMMU_HWPT_ALLOC_ENFORCE_DIRTY);
>   	struct iommu_domain *domain;
>   	struct intel_iommu *iommu;
>   
> -	if (flags & (~IOMMU_HWPT_ALLOC_NEST_PARENT))
> +	if (flags & (~(IOMMU_HWPT_ALLOC_NEST_PARENT|
> +		       IOMMU_HWPT_ALLOC_ENFORCE_DIRTY)))
>   		return ERR_PTR(-EOPNOTSUPP);
>   
>   	iommu = device_to_iommu(dev, NULL, NULL);
> @@ -4090,6 +4093,9 @@ intel_iommu_domain_alloc_user(struct device *dev, u32 flags)
>   	if ((flags & IOMMU_HWPT_ALLOC_NEST_PARENT) && !ecap_nest(iommu->ecap))
>   		return ERR_PTR(-EOPNOTSUPP);
>   
> +	if (enforce_dirty && !slads_supported(iommu))
> +		return ERR_PTR(-EOPNOTSUPP);
> +
>   	/*
>   	 * domain_alloc_user op needs to fully initialize a domain
>   	 * before return, so uses iommu_domain_alloc() here for
> @@ -4098,6 +4104,15 @@ intel_iommu_domain_alloc_user(struct device *dev, u32 flags)
>   	domain = iommu_domain_alloc(dev->bus);
>   	if (!domain)
>   		domain = ERR_PTR(-ENOMEM);
> +
> +	if (!IS_ERR(domain) && enforce_dirty) {
> +		if (to_dmar_domain(domain)->use_first_level) {
> +			iommu_domain_free(domain);
> +			return ERR_PTR(-EOPNOTSUPP);
> +		}
> +		domain->dirty_ops = &intel_dirty_ops;
> +	}
> +
>   	return domain;
>   }
>   
> @@ -4121,6 +4136,9 @@ static int prepare_domain_attach_device(struct iommu_domain *domain,
>   	if (dmar_domain->force_snooping && !ecap_sc_support(iommu->ecap))
>   		return -EINVAL;
>   
> +	if (domain->dirty_ops && !slads_supported(iommu))
> +		return -EINVAL;
> +
>   	/* check if this iommu agaw is sufficient for max mapped address */
>   	addr_width = agaw_to_width(iommu->agaw);
>   	if (addr_width > cap_mgaw(iommu->cap))
> @@ -4375,6 +4393,8 @@ static bool intel_iommu_capable(struct device *dev, enum iommu_cap cap)
>   		return dmar_platform_optin();
>   	case IOMMU_CAP_ENFORCE_CACHE_COHERENCY:
>   		return ecap_sc_support(info->iommu->ecap);
> +	case IOMMU_CAP_DIRTY:
> +		return slads_supported(info->iommu);
>   	default:
>   		return false;
>   	}
> @@ -4772,6 +4792,9 @@ static int intel_iommu_set_dev_pasid(struct iommu_domain *domain,
>   	if (!pasid_supported(iommu) || dev_is_real_dma_subdevice(dev))
>   		return -EOPNOTSUPP;
>   
> +	if (domain->dirty_ops)
> +		return -EINVAL;
> +
>   	if (context_copied(iommu, info->bus, info->devfn))
>   		return -EBUSY;
>   
> @@ -4830,6 +4853,85 @@ static void *intel_iommu_hw_info(struct device *dev, u32 *length, u32 *type)
>   	return vtd;
>   }
>   
> +static int intel_iommu_set_dirty_tracking(struct iommu_domain *domain,
> +					  bool enable)
> +{
> +	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
> +	struct device_domain_info *info;
> +	int ret = -EINVAL;
> +
> +	spin_lock(&dmar_domain->lock);
> +	if (dmar_domain->dirty_tracking == enable)
> +		goto out_unlock;
> +
> +	list_for_each_entry(info, &dmar_domain->devices, link) {
> +		ret = intel_pasid_setup_dirty_tracking(info->iommu, info->domain,
> +						     info->dev, IOMMU_NO_PASID,
> +						     enable);
> +		if (ret)
> +			goto err_unwind;
> +
> +	}
> +
> +	if (!ret)
> +		dmar_domain->dirty_tracking = enable;

We should also support setting dirty tracking even if the domain has not
been attached to any device?

To achieve this, we can remove ret initialization and remove the above
check. Make the default path a successful one.

	int ret;

	[...]

	dmar_domain->dirty_tracking = enable;

> +out_unlock:
> +	spin_unlock(&dmar_domain->lock);
> +
> +	return 0;
> +
> +err_unwind:
> +	list_for_each_entry(info, &dmar_domain->devices, link)
> +		intel_pasid_setup_dirty_tracking(info->iommu, dmar_domain,
> +					  info->dev, IOMMU_NO_PASID,
> +					  dmar_domain->dirty_tracking);
> +	spin_unlock(&dmar_domain->lock);
> +	return ret;
> +}
> +
> +static int intel_iommu_read_and_clear_dirty(struct iommu_domain *domain,
> +					    unsigned long iova, size_t size,
> +					    unsigned long flags,
> +					    struct iommu_dirty_bitmap *dirty)
> +{
> +	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
> +	unsigned long end = iova + size - 1;
> +	unsigned long pgsize;
> +
> +	/*
> +	 * IOMMUFD core calls into a dirty tracking disabled domain without an
> +	 * IOVA bitmap set in order to clean dirty bits in all PTEs that might
> +	 * have occurred when we stopped dirty tracking. This ensures that we
> +	 * never inherit dirtied bits from a previous cycle.
> +	 */
> +	if (!dmar_domain->dirty_tracking && dirty->bitmap)
> +		return -EINVAL;
> +
> +	do {
> +		struct dma_pte *pte;
> +		int lvl = 0;
> +
> +		pte = pfn_to_dma_pte(dmar_domain, iova >> VTD_PAGE_SHIFT, &lvl,
> +				     GFP_ATOMIC);
> +		pgsize = level_size(lvl) << VTD_PAGE_SHIFT;
> +		if (!pte || !dma_pte_present(pte)) {
> +			iova += pgsize;
> +			continue;
> +		}
> +
> +		if (dma_sl_pte_test_and_clear_dirty(pte, flags))
> +			iommu_dirty_bitmap_record(dirty, iova, pgsize);
> +		iova += pgsize;
> +	} while (iova < end);
> +
> +	return 0;
> +}
> +
> +const struct iommu_dirty_ops intel_dirty_ops = {
> +	.set_dirty_tracking	= intel_iommu_set_dirty_tracking,
> +	.read_and_clear_dirty   = intel_iommu_read_and_clear_dirty,
> +};
> +
>   const struct iommu_ops intel_iommu_ops = {
>   	.capable		= intel_iommu_capable,
>   	.hw_info		= intel_iommu_hw_info,
> diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
> index c18fb699c87a..27bcfd3bacdd 100644
> --- a/drivers/iommu/intel/iommu.h
> +++ b/drivers/iommu/intel/iommu.h
> @@ -48,6 +48,9 @@
>   #define DMA_FL_PTE_DIRTY	BIT_ULL(6)
>   #define DMA_FL_PTE_XD		BIT_ULL(63)
>   
> +#define DMA_SL_PTE_DIRTY_BIT	9
> +#define DMA_SL_PTE_DIRTY	BIT_ULL(DMA_SL_PTE_DIRTY_BIT)
> +
>   #define ADDR_WIDTH_5LEVEL	(57)
>   #define ADDR_WIDTH_4LEVEL	(48)
>   
> @@ -539,6 +542,9 @@ enum {
>   #define sm_supported(iommu)	(intel_iommu_sm && ecap_smts((iommu)->ecap))
>   #define pasid_supported(iommu)	(sm_supported(iommu) &&			\
>   				 ecap_pasid((iommu)->ecap))
> +#define slads_supported(iommu) (sm_supported(iommu) &&                 \
> +				ecap_slads((iommu)->ecap))
> +
>   
>   struct pasid_entry;
>   struct pasid_state_entry;
> @@ -592,6 +598,7 @@ struct dmar_domain {
>   					 * otherwise, goes through the second
>   					 * level.
>   					 */
> +	u8 dirty_tracking:1;		/* Dirty tracking is enabled */
>   
>   	spinlock_t lock;		/* Protect device tracking lists */
>   	struct list_head devices;	/* all devices' list */
> @@ -781,6 +788,16 @@ static inline bool dma_pte_present(struct dma_pte *pte)
>   	return (pte->val & 3) != 0;
>   }
>   
> +static inline bool dma_sl_pte_test_and_clear_dirty(struct dma_pte *pte,
> +						   unsigned long flags)
> +{
> +	if (flags & IOMMU_DIRTY_NO_CLEAR)
> +		return (pte->val & DMA_SL_PTE_DIRTY) != 0;
> +
> +	return test_and_clear_bit(DMA_SL_PTE_DIRTY_BIT,
> +				  (unsigned long *)&pte->val);
> +}
> +
>   static inline bool dma_pte_superpage(struct dma_pte *pte)
>   {
>   	return (pte->val & DMA_PTE_LARGE_PAGE);
> diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
> index 8f92b92f3d2a..785384a59d55 100644
> --- a/drivers/iommu/intel/pasid.c
> +++ b/drivers/iommu/intel/pasid.c
> @@ -277,6 +277,11 @@ static inline void pasid_set_bits(u64 *ptr, u64 mask, u64 bits)
>   	WRITE_ONCE(*ptr, (old & ~mask) | bits);
>   }
>   
> +static inline u64 pasid_get_bits(u64 *ptr)
> +{
> +	return READ_ONCE(*ptr);
> +}
> +
>   /*
>    * Setup the DID(Domain Identifier) field (Bit 64~79) of scalable mode
>    * PASID entry.
> @@ -335,6 +340,36 @@ static inline void pasid_set_fault_enable(struct pasid_entry *pe)
>   	pasid_set_bits(&pe->val[0], 1 << 1, 0);
>   }
>   
> +/*
> + * Enable second level A/D bits by setting the SLADE (Second Level
> + * Access Dirty Enable) field (Bit 9) of a scalable mode PASID
> + * entry.
> + */
> +static inline void pasid_set_ssade(struct pasid_entry *pe)
> +{
> +	pasid_set_bits(&pe->val[0], 1 << 9, 1 << 9);
> +}
> +
> +/*
> + * Enable second level A/D bits by setting the SLADE (Second Level

nit: Disable second level ....

> + * Access Dirty Enable) field (Bit 9) of a scalable mode PASID
> + * entry.
> + */
> +static inline void pasid_clear_ssade(struct pasid_entry *pe)
> +{
> +	pasid_set_bits(&pe->val[0], 1 << 9, 0);
> +}
> +
> +/*
> + * Checks if second level A/D bits by setting the SLADE (Second Level
> + * Access Dirty Enable) field (Bit 9) of a scalable mode PASID
> + * entry is enabled.
> + */
> +static inline bool pasid_get_ssade(struct pasid_entry *pe)
> +{
> +	return pasid_get_bits(&pe->val[0]) & (1 << 9);
> +}
> +
>   /*
>    * Setup the WPE(Write Protect Enable) field (Bit 132) of a
>    * scalable mode PASID entry.
> @@ -627,6 +662,8 @@ int intel_pasid_setup_second_level(struct intel_iommu *iommu,
>   	pasid_set_translation_type(pte, PASID_ENTRY_PGTT_SL_ONLY);
>   	pasid_set_fault_enable(pte);
>   	pasid_set_page_snoop(pte, !!ecap_smpwc(iommu->ecap));
> +	if (domain->dirty_tracking)
> +		pasid_set_ssade(pte);
>   
>   	pasid_set_present(pte);
>   	spin_unlock(&iommu->lock);
> @@ -636,6 +673,78 @@ int intel_pasid_setup_second_level(struct intel_iommu *iommu,
>   	return 0;
>   }
>   
> +/*
> + * Set up dirty tracking on a second only translation type.

nit: ... on a second only or nested translation type.

> + */
> +int intel_pasid_setup_dirty_tracking(struct intel_iommu *iommu,
> +				     struct dmar_domain *domain,
> +				     struct device *dev, u32 pasid,
> +				     bool enabled)
> +{
> +	struct pasid_entry *pte;
> +	u16 did, pgtt;
> +
> +	spin_lock(&iommu->lock);
> +
> +	pte = intel_pasid_get_entry(dev, pasid);
> +	if (!pte) {
> +		spin_unlock(&iommu->lock);
> +		dev_err_ratelimited(dev,
> +				    "Failed to get pasid entry of PASID %d\n",
> +				    pasid);
> +		return -ENODEV;
> +	}
> +
> +	did = domain_id_iommu(domain, iommu);
> +	pgtt = pasid_pte_get_pgtt(pte);
> +	if (pgtt != PASID_ENTRY_PGTT_SL_ONLY && pgtt != PASID_ENTRY_PGTT_NESTED) {
> +		spin_unlock(&iommu->lock);
> +		dev_err_ratelimited(dev,
> +				    "Dirty tracking not supported on translation type %d\n",
> +				    pgtt);
> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (pasid_get_ssade(pte) == enabled) {
> +		spin_unlock(&iommu->lock);
> +		return 0;
> +	}
> +
> +	if (enabled)
> +		pasid_set_ssade(pte);
> +	else
> +		pasid_clear_ssade(pte);
> +	spin_unlock(&iommu->lock);
> +
> +	if (!ecap_coherent(iommu->ecap))
> +		clflush_cache_range(pte, sizeof(*pte));
> +
> +	/*
> +	 * From VT-d spec table 25 "Guidance to Software for Invalidations":
> +	 *
> +	 * - PASID-selective-within-Domain PASID-cache invalidation
> +	 *   If (PGTT=SS or Nested)
> +	 *    - Domain-selective IOTLB invalidation
> +	 *   Else
> +	 *    - PASID-selective PASID-based IOTLB invalidation
> +	 * - If (pasid is RID_PASID)
> +	 *    - Global Device-TLB invalidation to affected functions
> +	 *   Else
> +	 *    - PASID-based Device-TLB invalidation (with S=1 and
> +	 *      Addr[63:12]=0x7FFFFFFF_FFFFF) to affected functions
> +	 */
> +	pasid_cache_invalidation_with_pasid(iommu, did, pasid);
> +
> +	if (pgtt == PASID_ENTRY_PGTT_SL_ONLY || pgtt == PASID_ENTRY_PGTT_NESTED)

Above check is unnecessary.

> +		iommu->flush.flush_iotlb(iommu, did, 0, 0, DMA_TLB_DSI_FLUSH);
> +
> +	/* Device IOTLB doesn't need to be flushed in caching mode. */
> +	if (!cap_caching_mode(iommu->cap))
> +		devtlb_invalidation_with_pasid(iommu, dev, pasid);
> +
> +	return 0;
> +}
> +
>   /*
>    * Set up the scalable mode pasid entry for passthrough translation type.
>    */
> diff --git a/drivers/iommu/intel/pasid.h b/drivers/iommu/intel/pasid.h
> index 4e9e68c3c388..958050b093aa 100644
> --- a/drivers/iommu/intel/pasid.h
> +++ b/drivers/iommu/intel/pasid.h
> @@ -106,6 +106,10 @@ int intel_pasid_setup_first_level(struct intel_iommu *iommu,
>   int intel_pasid_setup_second_level(struct intel_iommu *iommu,
>   				   struct dmar_domain *domain,
>   				   struct device *dev, u32 pasid);
> +int intel_pasid_setup_dirty_tracking(struct intel_iommu *iommu,
> +				     struct dmar_domain *domain,
> +				     struct device *dev, u32 pasid,
> +				     bool enabled);
>   int intel_pasid_setup_pass_through(struct intel_iommu *iommu,
>   				   struct dmar_domain *domain,
>   				   struct device *dev, u32 pasid);

Others look good to me. Thank you very much!

With above addressed,

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

Best regards,
baolu
