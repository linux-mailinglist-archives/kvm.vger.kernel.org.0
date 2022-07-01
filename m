Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A838563176
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 12:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235697AbiGAKeb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 06:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233394AbiGAKe3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 06:34:29 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6C7496F350;
        Fri,  1 Jul 2022 03:34:28 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5297F113E;
        Fri,  1 Jul 2022 03:34:28 -0700 (PDT)
Received: from [10.57.85.162] (unknown [10.57.85.162])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7C0A03F66F;
        Fri,  1 Jul 2022 03:34:26 -0700 (PDT)
Message-ID: <31d6e625-b89d-c183-0b38-0ab8ec202e47@arm.com>
Date:   Fri, 1 Jul 2022 11:34:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC PATCH kernel] vfio: Skip checking for
 IOMMU_CAP_CACHE_COHERENCY on POWER and more
Content-Language: en-GB
To:     Alexey Kardashevskiy <aik@ozlabs.ru>, kvm@vger.kernel.org
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Joerg Roedel <jroedel@suse.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm-ppc@vger.kernel.org
References: <20220701061751.1955857-1-aik@ozlabs.ru>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20220701061751.1955857-1-aik@ozlabs.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-07-01 07:17, Alexey Kardashevskiy wrote:
> VFIO on POWER does not implement iommu_ops and therefore iommu_capable()
> always returns false and __iommu_group_alloc_blocking_domain() always
> fails.
> 
> iommu_group_claim_dma_owner() in setting container fails for the same
> reason - it cannot allocate a domain.
> 
> This skips the check for platforms supporting VFIO without implementing
> iommu_ops which to my best knowledge is POWER only.
> 
> This also allows setting container in absence of iommu_ops.
> 
> Fixes: 70693f470848 ("vfio: Set DMA ownership for VFIO devices")
> Fixes: e8ae0e140c05 ("vfio: Require that devices support DMA cache coherence")
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> ---
> 
> Not quite sure what the proper small fix is and implementing iommu_ops
> on POWER is not going to happen any time soon or ever :-/

FWIW I did wonder about this when writing [1]. Is it appropriate to have 
any IOMMU API specifics outside the type1 code, or should these bits be 
abstracted behind vfio_iommu_driver_ops methods?

Robin.

[1] 
https://lore.kernel.org/linux-iommu/4ea5eb64246f1ee188d1a61c3e93b37756932eb7.1656092606.git.robin.murphy@arm.com/

> 
> ---
>   drivers/vfio/vfio.c | 13 +++++++------
>   1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 61e71c1154be..71408ab26cd0 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -605,7 +605,8 @@ int vfio_register_group_dev(struct vfio_device *device)
>   	 * VFIO always sets IOMMU_CACHE because we offer no way for userspace to
>   	 * restore cache coherency.
>   	 */
> -	if (!iommu_capable(device->dev->bus, IOMMU_CAP_CACHE_COHERENCY))
> +	if (device->dev->bus->iommu_ops &&
> +	    !iommu_capable(device->dev->bus, IOMMU_CAP_CACHE_COHERENCY))
>   		return -EINVAL;
>   
>   	return __vfio_register_dev(device,
> @@ -934,7 +935,7 @@ static void __vfio_group_unset_container(struct vfio_group *group)
>   		driver->ops->detach_group(container->iommu_data,
>   					  group->iommu_group);
>   
> -	if (group->type == VFIO_IOMMU)
> +	if (group->type == VFIO_IOMMU && iommu_group_dma_owner_claimed(group->iommu_group))
>   		iommu_group_release_dma_owner(group->iommu_group);
>   
>   	group->container = NULL;
> @@ -1010,9 +1011,8 @@ static int vfio_group_set_container(struct vfio_group *group, int container_fd)
>   	}
>   
>   	if (group->type == VFIO_IOMMU) {
> -		ret = iommu_group_claim_dma_owner(group->iommu_group, f.file);
> -		if (ret)
> -			goto unlock_out;
> +		if (iommu_group_claim_dma_owner(group->iommu_group, f.file))
> +			pr_warn("Failed to claim DMA owner");
>   	}
>   
>   	driver = container->iommu_driver;
> @@ -1021,7 +1021,8 @@ static int vfio_group_set_container(struct vfio_group *group, int container_fd)
>   						group->iommu_group,
>   						group->type);
>   		if (ret) {
> -			if (group->type == VFIO_IOMMU)
> +			if (group->type == VFIO_IOMMU &&
> +			    iommu_group_dma_owner_claimed(group->iommu_group))
>   				iommu_group_release_dma_owner(
>   					group->iommu_group);
>   			goto unlock_out;
