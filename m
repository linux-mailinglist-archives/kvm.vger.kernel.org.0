Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB3127C9D61
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 04:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbjJPCZ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Oct 2023 22:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjJPCZ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Oct 2023 22:25:26 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17571AB
        for <kvm@vger.kernel.org>; Sun, 15 Oct 2023 19:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697423123; x=1728959123;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=kqObKHVKDXZxUOrFR8Ow5sVbkniBlMyVsc2Q+Z/Wwbw=;
  b=RIu8HYsbJUCdoTjBAnpJQOLxf7zq+jk2hH2PWpkKxPaCGRjfoN/KNHQ1
   x4Me9vA3YSI3g7XBbXsPLvLLBXHlnYybj7WHNgv2lScqSfQv7+5H1wpzc
   yuCUUNrcRIIKqzaCQ2QEI7AARMB1YtSNsMG0HvqW9lkWb1k8ZurAcpJi2
   +4YOymLHV/aqxt5/7DwqU1Dbj+syGpwT06gsWjTohI9uKAdVIkwtskrsL
   96zkDzWtJMVMl0WLSCHADVKyFCZdweB+E53eriFJkKXsU8wWBpbAZlWzR
   ZoUE2mZeIh6hO6cGNWEqTl/869LV/TfbyhTa5BYapgcM32xRznLsk0mHo
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10863"; a="385270839"
X-IronPort-AV: E=Sophos;i="6.03,228,1694761200"; 
   d="scan'208";a="385270839"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2023 19:25:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10863"; a="705430736"
X-IronPort-AV: E=Sophos;i="6.03,228,1694761200"; 
   d="scan'208";a="705430736"
Received: from allen-box.sh.intel.com (HELO [10.239.159.127]) ([10.239.159.127])
  by orsmga003.jf.intel.com with ESMTP; 15 Oct 2023 19:25:17 -0700
Message-ID: <6859c129-7366-423c-9348-96c5fff0d3a0@linux.intel.com>
Date:   Mon, 16 Oct 2023 10:21:40 +0800
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
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 19/19] iommu/intel: Access/Dirty bit support for SL
 domains
Content-Language: en-US
To:     Joao Martins <joao.m.martins@oracle.com>, iommu@lists.linux.dev
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-20-joao.m.martins@oracle.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20230923012511.10379-20-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/23/23 9:25 AM, Joao Martins wrote:
[...]
> +/*
> + * Set up dirty tracking on a second only translation type.

Set up dirty tracking on a second only or nested translation type.

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
> +	did = domain_id_iommu(domain, iommu);
> +	pte = intel_pasid_get_entry(dev, pasid);
> +	if (!pte) {
> +		spin_unlock(&iommu->lock);
> +		dev_err(dev, "Failed to get pasid entry of PASID %d\n", pasid);

Use dev_err_ratelimited() to avoid user DOS attack.

> +		return -ENODEV;
> +	}

Can we add a check to limit this interface to second-only and nested
translation types? These are the only valid use cases currently and for
the foreseeable future.

And, return directly if the pasid bit matches the target state.

[...]
         spin_lock(&iommu->lock);
         pte = intel_pasid_get_entry(dev, pasid);
         if (!pte) {
                 spin_unlock(&iommu->lock);
                 dev_err_ratelimited(dev, "Failed to get pasid entry of 
PASID %d\n", pasid);
                 return -ENODEV;
         }

         did = domain_id_iommu(domain, iommu);
         pgtt = pasid_pte_get_pgtt(pte);

         if (pgtt != PASID_ENTRY_PGTT_SL_ONLY && pgtt != 
PASID_ENTRY_PGTT_NESTED) {
                 spin_unlock(&iommu->lock);
                 dev_err_ratelimited(dev,
                                     "Dirty tracking not supported on 
translation type %d\n",
                                     pgtt);
                 return -EOPNOTSUPP;
         }

         if (pasid_get_ssade(pte) == enabled) {
                 spin_unlock(&iommu->lock);
                 return 0;
         }

         if (enabled)
                 pasid_set_ssade(pte);
         else
                 pasid_clear_ssade(pte);
         spin_unlock(&iommu->lock);
[...]

> +
> +	pgtt = pasid_pte_get_pgtt(pte);
> +
> +	if (enabled)
> +		pasid_set_ssade(pte);
> +	else
> +		pasid_clear_ssade(pte);
> +	spin_unlock(&iommu->lock);


Add below here:

         if (!ecap_coherent(iommu->ecap))
                 clflush_cache_range(pte, sizeof(*pte));

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
> +		iommu->flush.flush_iotlb(iommu, did, 0, 0, DMA_TLB_DSI_FLUSH);
> +	else
> +		qi_flush_piotlb(iommu, did, pasid, 0, -1, 0);

Only "Domain-selective IOTLB invalidation" is needed here.

> +
> +	/* Device IOTLB doesn't need to be flushed in caching mode. */
> +	if (!cap_caching_mode(iommu->cap))
> +		devtlb_invalidation_with_pasid(iommu, dev, pasid);

For the device IOTLB invalidation, need to follow what spec requires.

   If (pasid is RID_PASID)
    - Global Device-TLB invalidation to affected functions
   Else
    - PASID-based Device-TLB invalidation (with S=1 and
      Addr[63:12]=0x7FFFFFFF_FFFFF) to affected functions

> +
> +	return 0;
> +}
> +

Best regards,
baolu
