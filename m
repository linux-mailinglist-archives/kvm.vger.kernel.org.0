Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 097257358A7
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 15:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbjFSNd2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 09:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbjFSNd1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 09:33:27 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ED707E54;
        Mon, 19 Jun 2023 06:33:24 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7A77512FC;
        Mon, 19 Jun 2023 06:34:08 -0700 (PDT)
Received: from [10.1.196.40] (e121345-lin.cambridge.arm.com [10.1.196.40])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5838F3F59C;
        Mon, 19 Jun 2023 06:33:23 -0700 (PDT)
Message-ID: <5d0d6665-93e4-f61f-d700-008c0fcb4a2f@arm.com>
Date:   Mon, 19 Jun 2023 14:33:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 1/2] iommu: Prevent RESV_DIRECT devices from blocking
 domains
Content-Language: en-GB
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kevin Tian <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>
Cc:     iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>
References: <20230607035145.343698-1-baolu.lu@linux.intel.com>
 <20230607035145.343698-2-baolu.lu@linux.intel.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20230607035145.343698-2-baolu.lu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/06/2023 4:51 am, Lu Baolu wrote:
> The IOMMU_RESV_DIRECT flag indicates that a memory region must be mapped
> 1:1 at all times. This means that the region must always be accessible to
> the device, even if the device is attached to a blocking domain. This is
> equal to saying that IOMMU_RESV_DIRECT flag prevents devices from being
> attached to blocking domains.
> 
> This also implies that devices that implement RESV_DIRECT regions will be
> prevented from being assigned to user space since taking the DMA ownership
> immediately switches to a blocking domain.
> 
> The rule of preventing devices with the IOMMU_RESV_DIRECT regions from
> being assigned to user space has existed in the Intel IOMMU driver for
> a long time. Now, this rule is being lifted up to a general core rule,
> as other architectures like AMD and ARM also have RMRR-like reserved
> regions. This has been discussed in the community mailing list and refer
> to below link for more details.
> 
> Other places using unmanaged domains for kernel DMA must follow the
> iommu_get_resv_regions() and setup IOMMU_RESV_DIRECT - we do not restrict
> them in the core code.
> 
> Cc: Robin Murphy <robin.murphy@arm.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Link: https://lore.kernel.org/linux-iommu/BN9PR11MB5276E84229B5BD952D78E9598C639@BN9PR11MB5276.namprd11.prod.outlook.com
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>   include/linux/iommu.h |  2 ++
>   drivers/iommu/iommu.c | 39 +++++++++++++++++++++++++++++----------
>   2 files changed, 31 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index d31642596675..fd18019ac951 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -409,6 +409,7 @@ struct iommu_fault_param {
>    * @priv:	 IOMMU Driver private data
>    * @max_pasids:  number of PASIDs this device can consume
>    * @attach_deferred: the dma domain attachment is deferred
> + * @requires_direct: The driver requested IOMMU_RESV_DIRECT
>    *
>    * TODO: migrate other per device data pointers under iommu_dev_data, e.g.
>    *	struct iommu_group	*iommu_group;
> @@ -422,6 +423,7 @@ struct dev_iommu {
>   	void				*priv;
>   	u32				max_pasids;
>   	u32				attach_deferred:1;
> +	u32				requires_direct:1;
>   };
>   
>   int iommu_device_register(struct iommu_device *iommu,
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 9e0228ef612b..e59de7852067 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -959,12 +959,7 @@ static int iommu_create_device_direct_mappings(struct iommu_domain *domain,
>   	unsigned long pg_size;
>   	int ret = 0;
>   
> -	if (!iommu_is_dma_domain(domain))
> -		return 0;
> -
> -	BUG_ON(!domain->pgsize_bitmap);
> -
> -	pg_size = 1UL << __ffs(domain->pgsize_bitmap);
> +	pg_size = domain->pgsize_bitmap ? 1UL << __ffs(domain->pgsize_bitmap) : 0;
>   	INIT_LIST_HEAD(&mappings);
>   
>   	iommu_get_resv_regions(dev, &mappings);
> @@ -974,13 +969,22 @@ static int iommu_create_device_direct_mappings(struct iommu_domain *domain,
>   		dma_addr_t start, end, addr;
>   		size_t map_size = 0;
>   
> +		if (entry->type == IOMMU_RESV_DIRECT)
> +			dev->iommu->requires_direct = 1;
> +
> +		if ((entry->type != IOMMU_RESV_DIRECT &&
> +		     entry->type != IOMMU_RESV_DIRECT_RELAXABLE) ||
> +		    !iommu_is_dma_domain(domain))
> +			continue;
> +
> +		if (WARN_ON_ONCE(!pg_size)) {
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +
>   		start = ALIGN(entry->start, pg_size);
>   		end   = ALIGN(entry->start + entry->length, pg_size);
>   
> -		if (entry->type != IOMMU_RESV_DIRECT &&
> -		    entry->type != IOMMU_RESV_DIRECT_RELAXABLE)
> -			continue;
> -
>   		for (addr = start; addr <= end; addr += pg_size) {
>   			phys_addr_t phys_addr;
>   
> @@ -2121,6 +2125,21 @@ static int __iommu_device_set_domain(struct iommu_group *group,
>   {
>   	int ret;
>   
> +	/*
> +	 * If the driver has requested IOMMU_RESV_DIRECT then we cannot allow
> +	 * the blocking domain to be attached as it does not contain the
> +	 * required 1:1 mapping. This test effectively exclusive the device from
> +	 * being used with iommu_group_claim_dma_owner() which will block vfio
> +	 * and iommufd as well.
> +	 */
> +	if (dev->iommu->requires_direct &&
> +	    (new_domain->type == IOMMU_DOMAIN_BLOCKED ||

Given the notion elsewhere that we want to use the blocking domain as a 
last resort to handle an attach failure, at face value it looks suspect 
that failing to attach to a blocking domain could also be a thing. I 
guess technically this is failing at a slightly different level so maybe 
it does work out OK, but it's still smelly.

The main thing, though, is that not everything implements the 
IOMMU_DOMAIN_BLOCKED optimisation, so a nominal blocking domain could be 
IOMMU_DOMAIN_UNMANAGED as well. FWIW I'd prefer to make the RESV_DIRECT 
check explicit in __iommu_take_dma_ownership() rather than hide it in an 
implementation detail; that's going to be a lot clearer to reason about 
as time goes on.

Thanks,
Robin.

> +	     new_domain == group->blocking_domain)) {
> +		dev_warn(dev,
> +			 "Firmware has requested this device have a 1:1 IOMMU mapping, rejecting configuring the device without a 1:1 mapping. Contact your platform vendor.\n");
> +		return -EINVAL;
> +	}
> +
>   	if (dev->iommu->attach_deferred) {
>   		if (new_domain == group->default_domain)
>   			return 0;
