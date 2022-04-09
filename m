Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D74284FA7C8
	for <lists+kvm@lfdr.de>; Sat,  9 Apr 2022 14:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241735AbiDIMyA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Apr 2022 08:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiDIMx7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Apr 2022 08:53:59 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F146338
        for <kvm@vger.kernel.org>; Sat,  9 Apr 2022 05:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649508712; x=1681044712;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vKNsP9CYTAGaS5HpajXxFaZPForOvjGpm7RZm16QYGI=;
  b=RtpkU+SLjf/V3VCFD5uEfMtgXELsgFAUeZTTtI2eR9THzLUrtp6C547J
   eHd6hD99DQNMv76sa7tn9dFCiH9DrziG3WGjjY05vChT5BMriiDZqIQLe
   e2Kxv1afhcwbe/RoTELCS118CqX/gc00h7IhoghPUd2C89td2z1H8xUmB
   /byiwNZjn2hli7e3U2DQqyg2fCl7JiAcKFa5b85KtZpUxUFYcbW8bKa2u
   W31ARtCbMFPDRspM7tU17IOwc9ZNbX5rP2EkHFozpONdbdupISCb7P64Y
   U9UEl9H14/iQneWyAg7w7MoK9g+QK+y92Pk0l5MzU0dyTvErAPvTC3A8Q
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10311"; a="242392609"
X-IronPort-AV: E=Sophos;i="5.90,247,1643702400"; 
   d="scan'208";a="242392609"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2022 05:51:52 -0700
X-IronPort-AV: E=Sophos;i="5.90,247,1643702400"; 
   d="scan'208";a="698639274"
Received: from blu2-mobl3.ccr.corp.intel.com (HELO [10.254.214.211]) ([10.254.214.211])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2022 05:51:49 -0700
Message-ID: <a97bb5f5-3899-5ad7-7316-a612e8fde788@linux.intel.com>
Date:   Sat, 9 Apr 2022 20:51:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Cc:     baolu.lu@linux.intel.com, Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v2 3/4] iommu: Redefine IOMMU_CAP_CACHE_COHERENCY as the
 cap flag for IOMMU_CACHE
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        iommu@lists.linux-foundation.org, Joerg Roedel <joro@8bytes.org>,
        kvm@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>
References: <3-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
In-Reply-To: <3-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/4/7 23:23, Jason Gunthorpe wrote:
> While the comment was correct that this flag was intended to convey the
> block no-snoop support in the IOMMU, it has become widely implemented and
> used to mean the IOMMU supports IOMMU_CACHE as a map flag. Only the Intel
> driver was different.
> 
> Now that the Intel driver is using enforce_cache_coherency() update the
> comment to make it clear that IOMMU_CAP_CACHE_COHERENCY is only about
> IOMMU_CACHE.  Fix the Intel driver to return true since IOMMU_CACHE always
> works.
> 
> The two places that test this flag, usnic and vdpa, are both assigning
> userspace pages to a driver controlled iommu_domain and require
> IOMMU_CACHE behavior as they offer no way for userspace to synchronize
> caches.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/intel/iommu.c | 2 +-
>   include/linux/iommu.h       | 3 +--
>   2 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index 8f3674e997df06..14ba185175e9ec 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -4556,7 +4556,7 @@ static bool intel_iommu_enforce_cache_coherency(struct iommu_domain *domain)
>   static bool intel_iommu_capable(enum iommu_cap cap)
>   {
>   	if (cap == IOMMU_CAP_CACHE_COHERENCY)
> -		return domain_update_iommu_snooping(NULL);
> +		return true;
>   	if (cap == IOMMU_CAP_INTR_REMAP)
>   		return irq_remapping_enabled == 1;
>   
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index fe4f24c469c373..fd58f7adc52796 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -103,8 +103,7 @@ static inline bool iommu_is_dma_domain(struct iommu_domain *domain)
>   }
>   
>   enum iommu_cap {
> -	IOMMU_CAP_CACHE_COHERENCY,	/* IOMMU can enforce cache coherent DMA
> -					   transactions */
> +	IOMMU_CAP_CACHE_COHERENCY,	/* IOMMU_CACHE is supported */
>   	IOMMU_CAP_INTR_REMAP,		/* IOMMU supports interrupt isolation */
>   	IOMMU_CAP_NOEXEC,		/* IOMMU_NOEXEC flag */
>   };

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

Best regards,
baolu
