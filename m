Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFF8F6EAA60
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 14:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbjDUM35 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 08:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjDUM3z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 08:29:55 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5FF92A5E4
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 05:29:54 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0414E1480;
        Fri, 21 Apr 2023 05:30:38 -0700 (PDT)
Received: from [10.57.23.51] (unknown [10.57.23.51])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4CE8C3F587;
        Fri, 21 Apr 2023 05:29:53 -0700 (PDT)
Message-ID: <0aa4a107-57d0-6e5b-46e5-86dbe5b3087f@arm.com>
Date:   Fri, 21 Apr 2023 13:29:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: RMRR device on non-Intel platform
Content-Language: en-GB
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
References: <BN9PR11MB5276E84229B5BD952D78E9598C639@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230420081539.6bf301ad.alex.williamson@redhat.com>
 <6cce1c5d-ab50-41c4-6e62-661bc369d860@arm.com>
 <20230420084906.2e4cce42.alex.williamson@redhat.com>
 <fd324213-8d77-cb67-1c52-01cd0997a92c@arm.com>
 <20230420154933.1a79de4e.alex.williamson@redhat.com>
 <ZEJ73s/2M4Rd5r/X@nvidia.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <ZEJ73s/2M4Rd5r/X@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023-04-21 13:04, Jason Gunthorpe wrote:
> On Thu, Apr 20, 2023 at 03:49:33PM -0600, Alex Williamson wrote:
>>> If we think this policy deserves to go beyond VFIO and userspace, and
>>> it's reasonable that such devices should never be allowed to attach to
>>> any other kind of kernel-owned unmanaged domain either, then we can
>>> still trivially enforce that in core IOMMU code. I really see no need
>>> for it to be in drivers at all.
>>
>> It seems like a reasonable choice to me that any mixing of unmanaged
>> domains with IOMMU_RESV_DIRECT could be restricted globally.  Do we
>> even have infrastructure for a driver to honor the necessary mapping
>> requirements?
> 
> What we discussed about the definition of IOMMU_RESV_DIRECT was that
> an identity map needs to be present at all times. This is what is
> documented at least:
> 
> 	/* Memory regions which must be mapped 1:1 at all times */
> 	IOMMU_RESV_DIRECT,
> 
> Notably, this also means the device can never be attached to a
> blocking domain. I would also think that drivers asking for this
> should ideally implement the "atomic replace" we discussed already to
> change between identity and unmanaged without disturbing the FW doing
> DMA to these addresses..
> 
> I was looking at this when we talked about it earlier and we don't
> follow that guideline today for vfio/iommufd.
> 
> Since taking ownership immediately switches to a blocking domain
> restricting the use of blocking also restricts ownership thus vfio and
> iommufd will be prevented.
> 
> Other places using unmanaged domains must follow the
> iommu_get_resv_regions() and setup IOMMU_RESV_DIRECT - we should not
> restrict them in the core code.
> 
> It also slightly changes my prior remarks to Robin about error domain
> attach handling, since blocking domains are not available for these
> devices the "error state" for such a device should be the identity
> domain to preserve FW access.
> 
> Also, we have a functional gap, ARM would really like a
> IOMMU_RESV_DIRECT_RELAXABLE_SAFE which would have iommufd/vfio install
> the 1:1 map and allow the device to be used. This is necessary for the
> GIC ITS page hack to support MSI since we should enable VFIO inside a
> VM. It is always safe for hostile VFIO userspace to DMA to the ITS
> page.

Can you clarify why something other than IOMMU_RESV_SW_MSI would be 
needed? MSI regions already represent "safe" direct mappings, either as 
an inherent property of the hardware, or with an actual mapping 
maintained by software. Also RELAXABLE is meant to imply that it is only 
needed until a driver takes over the device, which at face value doesn't 
make much sense for interrupts.

> So, after my domain error handling series, the core fix is pretty
> simple and universal. We should also remove all the redundant code in
> drivers - drivers should report the regions each devices needs
> properly and leave enforcement to the core code.. Lu/Kevin do you want
> to take this?
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 19f8d28ff1323c..c15eb5e0ba761d 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -1059,6 +1059,9 @@ static int iommu_create_device_direct_mappings(struct iommu_domain *domain,
>   		    entry->type != IOMMU_RESV_DIRECT_RELAXABLE)
>   			continue;
>   
> +		if (entry->type == IOMMU_RESV_DIRECT)
> +			dev->iommu->requires_direct = 1;

We'll still need to set this when the default domain type is identity 
too - see the diff I posted (the other parts below I merely implied).

Thanks,
Robin.

> +
>   		for (addr = start; addr <= end; addr += pg_size) {
>   			phys_addr_t phys_addr;
>   
> @@ -2210,6 +2213,22 @@ static int __iommu_device_set_domain(struct iommu_group *group,
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
> +	     new_domain == group->blocking_domain)) {
> +		dev_warn(
> +			dev,
> +			"Firmware has requested this device have a 1:1 IOMMU mapping, rejecting configuring the device without a 1:1 mapping. Contact your platform vendor.");
> +		return -EINVAL;
> +	}
> +
>   	if (dev->iommu->attach_deferred) {
>   		if (new_domain == group->default_domain)
>   			return 0;
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 3ad14437487638..7729a07923faa6 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -407,6 +407,7 @@ struct iommu_fault_param {
>    * @priv:	 IOMMU Driver private data
>    * @max_pasids:  number of PASIDs this device can consume
>    * @attach_deferred: the dma domain attachment is deferred
> + * @requires_direct: The driver requested IOMMU_RESV_DIRECT
>    *
>    * TODO: migrate other per device data pointers under iommu_dev_data, e.g.
>    *	struct iommu_group	*iommu_group;
> @@ -420,6 +421,7 @@ struct dev_iommu {
>   	void				*priv;
>   	u32				max_pasids;
>   	u32				attach_deferred:1;
> +	u32				requires_direct:1;
>   };
>   
>   int iommu_device_register(struct iommu_device *iommu,
