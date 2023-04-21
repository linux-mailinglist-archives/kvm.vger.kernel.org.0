Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 379ED6EB080
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 19:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233239AbjDURXF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 13:23:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233384AbjDURWs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 13:22:48 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 82BCC14450
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 10:22:45 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2259212FC;
        Fri, 21 Apr 2023 10:23:29 -0700 (PDT)
Received: from [10.57.23.51] (unknown [10.57.23.51])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 67B723F6C4;
        Fri, 21 Apr 2023 10:22:44 -0700 (PDT)
Message-ID: <fe7e20e5-9729-248d-ee03-c8b444a1b7c0@arm.com>
Date:   Fri, 21 Apr 2023 18:22:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: RMRR device on non-Intel platform
Content-Language: en-GB
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
References: <BN9PR11MB5276E84229B5BD952D78E9598C639@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230420081539.6bf301ad.alex.williamson@redhat.com>
 <6cce1c5d-ab50-41c4-6e62-661bc369d860@arm.com>
 <20230420084906.2e4cce42.alex.williamson@redhat.com>
 <fd324213-8d77-cb67-1c52-01cd0997a92c@arm.com>
 <20230420154933.1a79de4e.alex.williamson@redhat.com>
 <ZEJ73s/2M4Rd5r/X@nvidia.com> <0aa4a107-57d0-6e5b-46e5-86dbe5b3087f@arm.com>
 <ZEKFdJ6yXoyFiHY+@nvidia.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <ZEKFdJ6yXoyFiHY+@nvidia.com>
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

On 2023-04-21 13:45, Jason Gunthorpe wrote:
> On Fri, Apr 21, 2023 at 01:29:46PM +0100, Robin Murphy wrote:
> 
>> Can you clarify why something other than IOMMU_RESV_SW_MSI would be
>> needed?
> 
> We need iommufd to setup a 1:1 map for the reserved space.
> 
> So, of the reserved spaces we have these:
> 
> 	/* Memory regions which must be mapped 1:1 at all times */
> 	IOMMU_RESV_DIRECT,
> 
>             Block iommufd
> 
> 	/*
> 	 * Memory regions which are advertised to be 1:1 but are
> 	 * commonly considered relaxable in some conditions,
> 	 * for instance in device assignment use case (USB, Graphics)
> 	 */
> 	IOMMU_RESV_DIRECT_RELAXABLE,
> 
>             iommufd ignores this one
> 
> 	/* Arbitrary "never map this or give it to a device" address ranges */
> 	IOMMU_RESV_RESERVED,
> 
> 	   iommufd prevents using this IOVA range
> 
> 	/* Hardware MSI region (untranslated) */
> 	IOMMU_RESV_MSI,
> 
> 	   iommufd treats this the same as IOMMU_RESV_RESERVED
> 
> 	/* Software-managed MSI translation window */
> 	IOMMU_RESV_SW_MSI,
> 
> 	   iommufd treats this the same as IOMMU_RESV_RESERVED, also
> 	   it passes the start to iommu_get_msi_cookie() which
> 	   eventually maps something, but not 1:1.
> 
> I don't think it is a compatible change for IOMMU_RESV_SW_MSI to also
> mean 1:1 map?

Bleh, my bad, the nested MSI stuff is right on the limit of the amount 
of horribleness I can hold in my head at once even at the best of times, 
let alone when my head is still half-full of PMUs.

I think a slightly more considered and slightly less wrong version of 
that idea is to mark it as IOMMU_RESV_MSI, and special-case 
direct-mapping those on Arm (I believe it would technically be benign to 
do on x86 too, but might annoy people with its pointlessness). However...

> On baremetal we have no idea what the platform put under that
> hardcoded address?
> 
> On VM we don't use the iommu_get_msi_cookie() flow because the GIC in
> the VM pretends it doesn't have an ITS page?  (did I get that right?)

No, that can't be right - PCIe devices have to support MSI or MSI-X, and 
many of them won't support INTx at all, so if the guest wants to use 
interrupts in general it must surely need to believe it has some kind of 
MSI controller, which for practical purposes in this context means an 
ITS. That was the next thing I started wondering after the above - if 
the aim is to direct-map the host's SW_MSI region to effectively pass 
through the S2 MSI cookie, but you have the same Linux SMMU driver in 
the guest, isn't that guest driver still going to add a conflicting 
SW_MSI region for the same IOVA and confuse things?

Ideally for nesting, the VMM would just tell us the IPA of where it's 
going to claim the given device's associated MSI doorbell is, we map 
that to the real underlying address at S2, then the guest can use its S1 
cookie as normal if it wants to, and the host doesn't have to rewrite 
addresses either way. The set_dev_data thing starts to look tempting for 
this too... Given that the nesting usage model inherently constrains the 
VMM's options for emulating the IOMMU, would it be unreasonable to make 
our lives a lot easier with some similar constraints around interrupts, 
and just not attempt to support the full gamut of "emulate any kind of 
IRQ with any other kind of IRQ" irqfd hilarity?

>> MSI regions already represent "safe" direct mappings, either as an inherent
>> property of the hardware, or with an actual mapping maintained by software.
>> Also RELAXABLE is meant to imply that it is only needed until a driver takes
>> over the device, which at face value doesn't make much sense for interrupts.
> 
> I used "relxable" to suggest it is safe for userspace.

I know, but the subtlety is the reason *why* it's safe for userspace. 
Namely that a VFIO driver has bound and reset (or at least taken control 
of) the device, and thus it is assumed to no longer be doing whatever 
the boot firmware left it doing, therefore the reserved region is 
assumed to no longer be relevant, and from then on the requirement to 
preserve it can be relaxed.

>> We'll still need to set this when the default domain type is identity too -
>> see the diff I posted (the other parts below I merely implied).
> 
> Right, I missed that!
> 
> I suggest like this to avoid the double loop:
> 
> @@ -1037,9 +1037,6 @@ static int iommu_create_device_direct_mappings(struct iom>
>          unsigned long pg_size;
>          int ret = 0;
>   
> -       if (!iommu_is_dma_domain(domain))
> -               return 0;
> -
>          BUG_ON(!domain->pgsize_bitmap);
>   
>          pg_size = 1UL << __ffs(domain->pgsize_bitmap);

But then you realise that you also need to juggle this around since 
identity domains aren't required to have a valid pgsize_bitmap either, 
give up on the idea and go straight to writing a dedicated loop as the 
clearer and tidier option because hey this is hardly a fast path anyway. 
At least, you do if you're me :)

Cheers,
Robin.

> @@ -1052,13 +1049,18 @@ static int iommu_create_device_direct_mappings(struct i>
>                  dma_addr_t start, end, addr;
>                  size_t map_size = 0;
>   
> -               start = ALIGN(entry->start, pg_size);
> -               end   = ALIGN(entry->start + entry->length, pg_size);
> -
>                  if (entry->type != IOMMU_RESV_DIRECT &&
>                      entry->type != IOMMU_RESV_DIRECT_RELAXABLE)
>                          continue;
>   
> +               if (entry->type == IOMMU_RESV_DIRECT)
> +                       dev->iommu->requires_direct = 1;
> +
> +               if (!iommu_is_dma_domain(domain))
> +                       continue;
> +
> +               start = ALIGN(entry->start, pg_size);
> +               end   = ALIGN(entry->start + entry->length, pg_size);
>                  for (addr = start; addr <= end; addr += pg_size) {
>                          phys_addr_t phys_addr;
> 
> Jason
