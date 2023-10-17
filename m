Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 863A57CC3A6
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 14:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234760AbjJQMuJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 08:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234544AbjJQMuI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 08:50:08 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B1F1DB
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 05:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697547006; x=1729083006;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=rCYipY6by1RxlRi5NR03UHjm72t/xN2/Z+rpPJNJHik=;
  b=kduwgWXHCyq81QUhMvJlYD1CNBui0ySvH4/wA5Gwh4N/G6Wt7RN2encr
   hW1VGSFOT6gksrfHvWJT4g9VLx0VGgyvdabA6lzsrBVBB/bcHDJ0N8icx
   gJ//tAHrW3KY2PX/mW31qdkSmftebGoGdDFGxsNeo5oHzkxDNAnGymYmv
   qTvKfxu4MLoMQu/S6ppyg/rnRdiks7TP94MKEwF/y/xR0EZJG3zhLhYGh
   aNSnLXKuETTmCM79G5XtSYYQcJN5t3askMuYPcggjAXybvPDKHLHlYmo8
   VC7VkhbH+wwzmBaVWUFdzRZ7xrz8QErQ35Ezwhl4dDLVB1rFEeBo6Zd/9
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10866"; a="366033201"
X-IronPort-AV: E=Sophos;i="6.03,232,1694761200"; 
   d="scan'208";a="366033201"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 05:50:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="826427850"
X-IronPort-AV: E=Sophos;i="6.03,232,1694761200"; 
   d="scan'208";a="826427850"
Received: from wangxue2-mobl.ccr.corp.intel.com (HELO [10.254.212.22]) ([10.254.212.22])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 05:50:02 -0700
Message-ID: <4b5cd75a-c0cd-c9bd-0d08-8c889861d48f@linux.intel.com>
Date:   Tue, 17 Oct 2023 20:49:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
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
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 19/19] iommu/intel: Access/Dirty bit support for SL
 domains
Content-Language: en-US
To:     Joao Martins <joao.m.martins@oracle.com>, iommu@lists.linux.dev
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-20-joao.m.martins@oracle.com>
 <d8553024-b880-42db-9f1f-8d2d3591469c@linux.intel.com>
 <83f9e278-8249-4f10-8542-031260d43c4c@oracle.com>
 <10bb7484-baaf-4d32-b40d-790f56267489@oracle.com>
 <a83cb9a7-88de-41af-8ef0-1e739eab12c2@linux.intel.com>
 <e797b35b-6a17-4114-a886-95e6402ad03c@oracle.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <e797b35b-6a17-4114-a886-95e6402ad03c@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/10/17 19:22, Joao Martins wrote:
> On 17/10/2023 03:08, Baolu Lu wrote:
>> On 10/17/23 12:00 AM, Joao Martins wrote:
>>>>> The iommu_dirty_bitmap is defined in iommu core. The iommu driver has no
>>>>> need to understand it and check its member anyway.
>>>>>
>>>> (...) The iommu driver has no need to understand it. iommu_dirty_bitmap_record()
>>>> already makes those checks in case there's no iova_bitmap to set bits to.
>>>>
>>> This is all true but the reason I am checking iommu_dirty_bitmap::bitmap is to
>>> essentially not record anything in the iova bitmap and just clear the dirty bits
>>> from the IOPTEs, all when dirty tracking is technically disabled. This is done
>>> internally only when starting dirty tracking, and thus to ensure that we cleanup
>>> all dirty bits before we enable dirty tracking to have a consistent snapshot as
>>> opposed to inheriting dirties from the past.
>>
>> It's okay since it serves a functional purpose. Can you please add some
>> comments around the code to explain the rationale.
>>
> 
> I added this comment below:
> 
> +       /*
> +        * IOMMUFD core calls into a dirty tracking disabled domain without an
> +        * IOVA bitmap set in order to clean dirty bits in all PTEs that might
> +        * have occured when we stopped dirty tracking. This ensures that we
> +        * never inherit dirtied bits from a previous cycle.
> +        */
> 

Yes. It's clear. Thank you!

> Also fixed an issue where I could theoretically clear the bit with
> IOMMU_NO_CLEAR. Essentially passed the read_and_clear_dirty flags and let
> dma_sl_pte_test_and_clear_dirty() to test and test-and-clear, similar to AMD:
> 
> @@ -781,6 +788,16 @@ static inline bool dma_pte_present(struct dma_pte *pte)
>          return (pte->val & 3) != 0;
>   }
> 
> +static inline bool dma_sl_pte_test_and_clear_dirty(struct dma_pte *pte,
> +                                                  unsigned long flags)
> +{
> +       if (flags & IOMMU_DIRTY_NO_CLEAR)
> +               return (pte->val & DMA_SL_PTE_DIRTY) != 0;
> +
> +       return test_and_clear_bit(DMA_SL_PTE_DIRTY_BIT,
> +                                 (unsigned long *)&pte->val);
> +}
> +

Yes. Sure.

> Anyhow, see below the full diff compared to this patch. Some things are in tree
> that is different to submitted from this patch.

[...]

> @@ -4113,7 +4123,7 @@ static void intel_iommu_domain_free(struct iommu_domain
> *domain)
>   }
> 
>   static int prepare_domain_attach_device(struct iommu_domain *domain,
> -					struct device *dev)
> +					struct device *dev, ioasid_t pasid)

How about blocking pasid attaching in intel_iommu_set_dev_pasid().

>   {
>   	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
>   	struct intel_iommu *iommu;
> @@ -4126,7 +4136,8 @@ static int prepare_domain_attach_device(struct
> iommu_domain *domain,
>   	if (dmar_domain->force_snooping && !ecap_sc_support(iommu->ecap))
>   		return -EINVAL;
> 
> -	if (domain->dirty_ops && !intel_iommu_slads_supported(iommu))
> +	if (domain->dirty_ops &&
> +	    (!slads_supported(iommu) || pasid != IOMMU_NO_PASID))
>   		return -EINVAL;
> 
>   	/* check if this iommu agaw is sufficient for max mapped address */

[...]

> 
> @@ -4886,14 +4897,16 @@ static int intel_iommu_read_and_clear_dirty(struct
> iommu_domain *domain,
>   	unsigned long pgsize;
>   	bool ad_enabled;
> 
> -	spin_lock(&dmar_domain->lock);
> +	/*
> +	 * IOMMUFD core calls into a dirty tracking disabled domain without an
> +	 * IOVA bitmap set in order to clean dirty bits in all PTEs that might
> +	 * have occured when we stopped dirty tracking. This ensures that we
> +	 * never inherit dirtied bits from a previous cycle.
> +	 */
>   	ad_enabled = dmar_domain->dirty_tracking;
> -	spin_unlock(&dmar_domain->lock);
> -
>   	if (!ad_enabled && dirty->bitmap)

How about
	if (!dmar_domain->dirty_tracking && dirty->bitmap)
		return -EINVAL;
?

>   		return -EINVAL;
> 
> -	rcu_read_lock();
>   	do {
>   		struct dma_pte *pte;
>   		int lvl = 0;
> @@ -4906,14 +4919,10 @@ static int intel_iommu_read_and_clear_dirty(struct
> iommu_domain *domain,
>   			continue;
>   		}
> 
> -		/* It is writable, set the bitmap */
> -		if (((flags & IOMMU_DIRTY_NO_CLEAR) &&
> -				dma_sl_pte_dirty(pte)) ||
> -		    dma_sl_pte_test_and_clear_dirty(pte))
> +		if (dma_sl_pte_test_and_clear_dirty(pte, flags))
>   			iommu_dirty_bitmap_record(dirty, iova, pgsize);
>   		iova += pgsize;
>   	} while (iova < end);
> -	rcu_read_unlock();
> 
>   	return 0;
>   }
> diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
> index bccd44db3316..0b390d9e669b 100644
> --- a/drivers/iommu/intel/iommu.h
> +++ b/drivers/iommu/intel/iommu.h
> @@ -542,6 +542,9 @@ enum {
>   #define sm_supported(iommu)	(intel_iommu_sm && ecap_smts((iommu)->ecap))
>   #define pasid_supported(iommu)	(sm_supported(iommu) &&			\
>   				 ecap_pasid((iommu)->ecap))
> +#define slads_supported(iommu) (sm_supported(iommu) &&                 \
> +                                ecap_slads((iommu)->ecap))
> +
> 
>   struct pasid_entry;
>   struct pasid_state_entry;
> @@ -785,13 +788,12 @@ static inline bool dma_pte_present(struct dma_pte *pte)
>   	return (pte->val & 3) != 0;
>   }
> 
> -static inline bool dma_sl_pte_dirty(struct dma_pte *pte)
> +static inline bool dma_sl_pte_test_and_clear_dirty(struct dma_pte *pte,
> +						   unsigned long flags)
>   {
> -	return (pte->val & DMA_SL_PTE_DIRTY) != 0;
> -}
> +	if (flags & IOMMU_DIRTY_NO_CLEAR)
> +		return (pte->val & DMA_SL_PTE_DIRTY) != 0;
> 
> -static inline bool dma_sl_pte_test_and_clear_dirty(struct dma_pte *pte)
> -{
>   	return test_and_clear_bit(DMA_SL_PTE_DIRTY_BIT,
>   				  (unsigned long *)&pte->val);
>   }
> diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
> index 03814942d59c..785384a59d55 100644
> --- a/drivers/iommu/intel/pasid.c
> +++ b/drivers/iommu/intel/pasid.c
> @@ -686,15 +686,29 @@ int intel_pasid_setup_dirty_tracking(struct intel_iommu
> *iommu,
> 
>   	spin_lock(&iommu->lock);
> 
> -	did = domain_id_iommu(domain, iommu);
>   	pte = intel_pasid_get_entry(dev, pasid);
>   	if (!pte) {
>   		spin_unlock(&iommu->lock);
> -		dev_err(dev, "Failed to get pasid entry of PASID %d\n", pasid);
> +		dev_err_ratelimited(dev,
> +				    "Failed to get pasid entry of PASID %d\n",
> +				    pasid);
>   		return -ENODEV;
>   	}
> 
> +	did = domain_id_iommu(domain, iommu);
>   	pgtt = pasid_pte_get_pgtt(pte);
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
> 
>   	if (enabled)
>   		pasid_set_ssade(pte);
> @@ -702,6 +716,9 @@ int intel_pasid_setup_dirty_tracking(struct intel_iommu *iommu,
>   		pasid_clear_ssade(pte);
>   	spin_unlock(&iommu->lock);
> 
> +	if (!ecap_coherent(iommu->ecap))
> +		clflush_cache_range(pte, sizeof(*pte));
> +
>   	/*
>   	 * From VT-d spec table 25 "Guidance to Software for Invalidations":
>   	 *
> @@ -720,8 +737,6 @@ int intel_pasid_setup_dirty_tracking(struct intel_iommu *iommu,
> 
>   	if (pgtt == PASID_ENTRY_PGTT_SL_ONLY || pgtt == PASID_ENTRY_PGTT_NESTED)
>   		iommu->flush.flush_iotlb(iommu, did, 0, 0, DMA_TLB_DSI_FLUSH);
> -	else
> -		qi_flush_piotlb(iommu, did, pasid, 0, -1, 0);
> 
>   	/* Device IOTLB doesn't need to be flushed in caching mode. */
>   	if (!cap_caching_mode(iommu->cap))

Others look good to me. Thanks a lot.

Best regards,
baolu
