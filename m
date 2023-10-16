Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C39B07C9D58
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 04:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbjJPCLE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Oct 2023 22:11:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbjJPCLD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Oct 2023 22:11:03 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE1BFAB
        for <kvm@vger.kernel.org>; Sun, 15 Oct 2023 19:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697422261; x=1728958261;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=wPsnnrZpLtCpjRrtyf6lW/jTyCZ+BEZgbzpRy35IyMc=;
  b=HuJ1WZyB/TUnpiIll2ofv2Jnxt9JsDtX0SktyVCvy2TNA/LQ/7nEjnyp
   HXrK99NVvVj2Vg04kOG9VF/15/e/CjeTOA/5TZYSxzN4fSr/yvQkjb6uN
   VHkuuCTjLD70NWnszD5Y2PK0ajzCEnkgjgKkaJDdByXZOspZGk0/6KRRG
   ZcvlopruIFAS2IufQQcZv8RROHe6+BxGRMIh4dEhTRNVcXZ0Zrv2P2E70
   kSsfqgiv9tBD76qgBUjDk09grnmoq1TKH3fBLZg4AbAib/GbZsJsIaZiG
   IPHt4GGogmvKX72fna2x9MxJwnh4espQr36H5HT4z9xGlnyZbQq9vfOEt
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10863"; a="384306972"
X-IronPort-AV: E=Sophos;i="6.03,228,1694761200"; 
   d="scan'208";a="384306972"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2023 19:11:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10863"; a="790651418"
X-IronPort-AV: E=Sophos;i="6.03,228,1694761200"; 
   d="scan'208";a="790651418"
Received: from allen-box.sh.intel.com (HELO [10.239.159.127]) ([10.239.159.127])
  by orsmga001.jf.intel.com with ESMTP; 15 Oct 2023 19:10:57 -0700
Message-ID: <d8553024-b880-42db-9f1f-8d2d3591469c@linux.intel.com>
Date:   Mon, 16 Oct 2023 10:07:20 +0800
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
> +static int intel_iommu_read_and_clear_dirty(struct iommu_domain *domain,
> +					    unsigned long iova, size_t size,
> +					    unsigned long flags,
> +					    struct iommu_dirty_bitmap *dirty)
> +{
> +	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
> +	unsigned long end = iova + size - 1;
> +	unsigned long pgsize;
> +	bool ad_enabled;
> +
> +	spin_lock(&dmar_domain->lock);
> +	ad_enabled = dmar_domain->dirty_tracking;
> +	spin_unlock(&dmar_domain->lock);

The spin lock is to protect the RID and PASID device tracking list. No
need to use it here.

> +
> +	if (!ad_enabled && dirty->bitmap)
> +		return -EINVAL;

I don't understand above check of "dirty->bitmap". Isn't it always
invalid to call this if dirty tracking is not enabled on the domain?

The iommu_dirty_bitmap is defined in iommu core. The iommu driver has no
need to understand it and check its member anyway.

Or, I overlooked anything?

> +
> +	rcu_read_lock();

Do we really need a rcu lock here? This operation is protected by
iopt->iova_rwsem. Is it reasonable to remove it? If not, how about put
some comments around it?

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
> +		/* It is writable, set the bitmap */
> +		if (((flags & IOMMU_DIRTY_NO_CLEAR) &&
> +				dma_sl_pte_dirty(pte)) ||
> +		    dma_sl_pte_test_and_clear_dirty(pte))
> +			iommu_dirty_bitmap_record(dirty, iova, pgsize);
> +		iova += pgsize;
> +	} while (iova < end);
> +	rcu_read_unlock();
> +
> +	return 0;
> +}

Best regards,
baolu
