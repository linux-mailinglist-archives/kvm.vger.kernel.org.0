Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 271C365FFA9
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 12:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbjAFLm0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 06:42:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233438AbjAFLmW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 06:42:22 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B0F6C292;
        Fri,  6 Jan 2023 03:42:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673005341; x=1704541341;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=cpn0pFMJ5mLHa6DOVZPoFhfx0tpHVkJmRJ9xxH7VKHo=;
  b=BhPYc9TQTKxQmHtgaeTWkGve9oqkt1XaRNa7uhgkUZm2Yc0bCvAiK1Uy
   iyTRcNimTldtlwa6s71vSGrHGR/hXy0qTwQlgts6GruO1WkuP1a+tyW1/
   LNB0G8CetEcBoYamtf53OCheATWY39uj3UjjRGbWGSSYtFo70TdYv7XKh
   f0/GmraDCQ+shJdNk1jkuImUj1Ps3uHEydurJBOU7uKkN2eCJqll1KJ24
   IgfUt1En5YkZc4dWaRj9X7/3wPjMX+uX47//7uA+LtcjW/IeVSCnH3R5W
   CQLsgq2ofB9Qy5jSlPG8Aq86YT+S6gBrDIcLArxjj9L1K1EUc9vsuQJYi
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="384765697"
X-IronPort-AV: E=Sophos;i="5.96,305,1665471600"; 
   d="scan'208";a="384765697"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 03:42:21 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="605888512"
X-IronPort-AV: E=Sophos;i="5.96,305,1665471600"; 
   d="scan'208";a="605888512"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.254.211.214]) ([10.254.211.214])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 03:42:12 -0800
Message-ID: <1fe05b9a-3d1e-e1b7-8c5e-dd8da0966950@linux.intel.com>
Date:   Fri, 6 Jan 2023 19:42:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH iommufd v3 7/9] iommu/x86: Replace IOMMU_CAP_INTR_REMAP
 with IRQ_DOMAIN_FLAG_ISOLATED_MSI
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>
Cc:     Bharat Bhushan <bharat.bhushan@nxp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tomasz Nowicki <tomasz.nowicki@caviumnetworks.com>,
        Will Deacon <will.deacon@arm.com>
References: <7-v3-3313bb5dd3a3+10f11-secure_msi_jgg@nvidia.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <7-v3-3313bb5dd3a3+10f11-secure_msi_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/6/2023 3:33 AM, Jason Gunthorpe wrote:
> On x86 platforms when the HW can support interrupt remapping the iommu
> driver creates an irq_domain for the IR hardware and creates a child MSI
> irq_domain.
> 
> When the global irq_remapping_enabled is set, the IR MSI domain is
> assigned to the PCI devices (by intel_irq_remap_add_device(), or
> amd_iommu_set_pci_msi_domain()) making those devices have the isolated MSI
> property.
> 
> Due to how interrupt domains work, setting IRQ_DOMAIN_FLAG_ISOLATED_MSI on
> the parent IR domain will cause all struct devices attached to it to
> return true from msi_device_has_isolated_msi(). This replaces the
> IOMMU_CAP_INTR_REMAP flag as all places using IOMMU_CAP_INTR_REMAP also
> call msi_device_has_isolated_msi()
> 
> Set the flag and delete the cap.
> 
> Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/amd/iommu.c           | 5 ++---
>   drivers/iommu/intel/iommu.c         | 2 --
>   drivers/iommu/intel/irq_remapping.c | 3 ++-
>   3 files changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index cbeaab55c0dbcc..321d50e9df5b4a 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -2271,8 +2271,6 @@ static bool amd_iommu_capable(struct device *dev, enum iommu_cap cap)
>   	switch (cap) {
>   	case IOMMU_CAP_CACHE_COHERENCY:
>   		return true;
> -	case IOMMU_CAP_INTR_REMAP:
> -		return (irq_remapping_enabled == 1);
>   	case IOMMU_CAP_NOEXEC:
>   		return false;
>   	case IOMMU_CAP_PRE_BOOT_PROTECTION:
> @@ -3671,7 +3669,8 @@ int amd_iommu_create_irq_domain(struct amd_iommu *iommu)
>   	}
>   
>   	irq_domain_update_bus_token(iommu->ir_domain,  DOMAIN_BUS_AMDVI);
> -	iommu->ir_domain->flags |= IRQ_DOMAIN_FLAG_MSI_PARENT;
> +	iommu->ir_domain->flags |= IRQ_DOMAIN_FLAG_MSI_PARENT |
> +				   IRQ_DOMAIN_FLAG_ISOLATED_MSI;
>   
>   	if (amd_iommu_np_cache)
>   		iommu->ir_domain->msi_parent_ops = &virt_amdvi_msi_parent_ops;
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index 59df7e42fd533c..7cfab5fd5e5964 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -4464,8 +4464,6 @@ static bool intel_iommu_capable(struct device *dev, enum iommu_cap cap)
>   	switch (cap) {
>   	case IOMMU_CAP_CACHE_COHERENCY:
>   		return true;
> -	case IOMMU_CAP_INTR_REMAP:
> -		return irq_remapping_enabled == 1;
>   	case IOMMU_CAP_PRE_BOOT_PROTECTION:
>   		return dmar_platform_optin();
>   	case IOMMU_CAP_ENFORCE_CACHE_COHERENCY:
> diff --git a/drivers/iommu/intel/irq_remapping.c b/drivers/iommu/intel/irq_remapping.c
> index f58f5f57af782b..6d01fa078c36fc 100644
> --- a/drivers/iommu/intel/irq_remapping.c
> +++ b/drivers/iommu/intel/irq_remapping.c
> @@ -573,7 +573,8 @@ static int intel_setup_irq_remapping(struct intel_iommu *iommu)
>   	}
>   
>   	irq_domain_update_bus_token(iommu->ir_domain,  DOMAIN_BUS_DMAR);
> -	iommu->ir_domain->flags |= IRQ_DOMAIN_FLAG_MSI_PARENT;
> +	iommu->ir_domain->flags |= IRQ_DOMAIN_FLAG_MSI_PARENT |
> +				   IRQ_DOMAIN_FLAG_ISOLATED_MSI;
>   
>   	if (cap_caching_mode(iommu->cap))
>   		iommu->ir_domain->msi_parent_ops = &virt_dmar_msi_parent_ops;

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

--
Best regards,
baolu
