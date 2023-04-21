Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7BBF6EA926
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 13:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbjDULeq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 07:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231551AbjDULeo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 07:34:44 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 37B87AF1A
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 04:34:42 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CAFE01480;
        Fri, 21 Apr 2023 04:35:25 -0700 (PDT)
Received: from [10.57.23.51] (unknown [10.57.23.51])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 18ADE3F587;
        Fri, 21 Apr 2023 04:34:39 -0700 (PDT)
Message-ID: <b2725362-aede-44dd-76ce-39482511ec94@arm.com>
Date:   Fri, 21 Apr 2023 12:34:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: RMRR device on non-Intel platform
Content-Language: en-GB
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Lu, Baolu" <baolu.lu@intel.com>
References: <BN9PR11MB5276E84229B5BD952D78E9598C639@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230420081539.6bf301ad.alex.williamson@redhat.com>
 <6cce1c5d-ab50-41c4-6e62-661bc369d860@arm.com>
 <20230420084906.2e4cce42.alex.williamson@redhat.com>
 <fd324213-8d77-cb67-1c52-01cd0997a92c@arm.com>
 <20230420154933.1a79de4e.alex.williamson@redhat.com>
 <BN9PR11MB52760FCB2D35D08723BE3F2A8C609@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <BN9PR11MB52760FCB2D35D08723BE3F2A8C609@BN9PR11MB5276.namprd11.prod.outlook.com>
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

On 2023-04-21 05:10, Tian, Kevin wrote:
>> From: Alex Williamson <alex.williamson@redhat.com>
>> Sent: Friday, April 21, 2023 5:50 AM

[ 2-in-1 reply since I'm lazy... ]

>> On Thu, 20 Apr 2023 17:55:22 +0100
>> Robin Murphy <robin.murphy@arm.com> wrote:
>>
>>> On 20/04/2023 3:49 pm, Alex Williamson wrote:
>>>> On Thu, 20 Apr 2023 15:19:55 +0100
>>>> Robin Murphy <robin.murphy@arm.com> wrote:
>>>>
>>>>> On 2023-04-20 15:15, Alex Williamson wrote:
>>>>>> On Thu, 20 Apr 2023 06:52:01 +0000
>>>>>> "Tian, Kevin" <kevin.tian@intel.com> wrote:
>>>>>>
>>>>>>> Hi, Alex,
>>>>>>>
>>>>>>> Happen to see that we may have inconsistent policy about RMRR
>> devices cross
>>>>>>> different vendors.
>>>>>>>
>>>>>>> Previously only Intel supports RMRR. Now both AMD/ARM have
>> similar thing,
>>>>>>> AMD IVMD and ARM RMR.
>>>>>>
>>>>>> Any similar requirement imposed by system firmware that the
>> operating
>>>>>> system must perpetually maintain a specific IOVA mapping for the
>> device
>>>>>> should impose similar restrictions as we've implemented for VT-d
>>>>>> RMMR[1].  Thanks,
>>>>>
>>>>> Hmm, does that mean that vfio_iommu_resv_exclude() going to the
>> trouble
>>>>> of punching out all the reserved region holes isn't really needed?
>>>>
>>>> While "Reserved Memory Region Reporting", might suggest that the
>> ranges
>>>> are simply excluded, RMRR actually require that specific mappings are
>>>> maintained for ongoing, side-band activity, which is not compatible
>>>> with the ideas that userspace owns the IOVA address space for the
>>>> device or separation of host vs userspace control of the device.  Such
>>>> mappings suggest things like system health monitoring where the
>>>> influence of a user-owned device can easily extend to a system-wide
>>>> scope if the user it able to manipulate the device to deny that
>>>> interaction or report bad data.
>>>>
>>>> If these ARM and AMD tables impose similar requirements, we should
>>>> really be restricting devices encumbered by such requirements from
>>>> userspace access as well.  Thanks,
>>>
>>> Indeed the primary use-case behind Arm's RMRs was certain devices like
>>> big complex RAID controllers which have already been started by UEFI
>>> firmware at boot and have live in-memory data which needs to be
>> preserved.
>>>
>>> However, my point was more that if it's a VFIO policy that any device
>>> with an IOMMU_RESV_DIRECT reservation is not suitable for userspace
>>> assignment, then vfio_iommu_type1_attach_group() already has
>> everything
>>> it would need to robustly enforce that policy itself. It seems silly to
>>> me for it to expect the IOMMU driver to fail the attach, then go ahead
>>> and dutifully punch out direct regions if it happened not to. A couple
>>> of obvious trivial tweaks and there could be no dependency on driver
>>> behaviour at all, other than correctly reporting resv_regions to begin with.
>>>
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

In principle a driver that knew what it was doing could call 
iommu_group_get_resv_regions() and map them into its own domain before 
attaching. Since nothing upstream *is* actually doing that, though, I'd 
have no real objection to restricting this at the API level as the 
safest approach, then coming back to consider exceptional cases if and 
when anybody does really have one.

>> It looks pretty easy to do as well, something like this (untested):
>>
>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>> index 10db680acaed..521f9a731ce9 100644
>> --- a/drivers/iommu/iommu.c
>> +++ b/drivers/iommu/iommu.c
>> @@ -2012,11 +2012,29 @@ static void
>> __iommu_group_set_core_domain(struct iommu_group *group)
>>   static int __iommu_attach_device(struct iommu_domain *domain,
>>   				 struct device *dev)
>>   {
>> -	int ret;
>> +	int ret = 0;
>>
>>   	if (unlikely(domain->ops->attach_dev == NULL))
>>   		return -ENODEV;
>>
>> +	if (domain->type == IOMMU_DOMAIN_UNMANAGED) {
>> +		struct iommu_resv_region *region;
>> +		LIST_HEAD(resv_regions);
>> +
>> +		iommu_get_resv_regions(dev, &resv_regions);
>> +		list_for_each_entry(region, &resv_regions, list) {
>> +			if (region->type == IOMMU_RESV_DIRECT) {
>> +				ret = -EPERM;
>> +				break;
>> +			}
>> +		}
>> +		iommu_put_resv_regions(dev, &resv_regions);
>> +		if (ret) {
>> +			dev_warn(dev, "Device may not be used with an
>> unmanaged IOMMU domain due to reserved direct mapping
>> requirement.\n");
>> +			return ret;
>> +		}
>> +	}
>> +
>>   	ret = domain->ops->attach_dev(domain, dev);
>>   	if (ret)
>>   		return ret;
>>
>> Restrictions in either type1 or iommufd would be pretty trivial as well,
>> but centralizing it in core IOMMU code would do a better job of covering
>> all use cases.

Indeed, I was thinking that either way, since we usually process the 
reserved regions at probe time anyway, it only needs a slight shuffle to 
cache this as a flag that both core code and/or users can easily refer 
to (so VFIO and IOMMUFD could still identify unsuitable devices long 
before having to go as far as the attach failing). Something like:

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 265d34e9cbcb..53d3daef7a7b 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -935,19 +935,20 @@ static int 
iommu_create_device_direct_mappings(struct iommu_group *group,
  {
  	struct iommu_domain *domain = group->default_domain;
  	struct iommu_resv_region *entry;
-	struct list_head mappings;
+	LIST_HEAD(mappings);
  	unsigned long pg_size;
  	int ret = 0;

+	iommu_get_resv_regions(dev, &mappings);
+	list_for_each_entry(entry, &mappings, list)
+		if (entry->type == IOMMU_RESV_DIRECT)
+			dev->iommu->has_resv_direct = true;
+
  	if (!domain || !iommu_is_dma_domain(domain))
-		return 0;
+		goto out;

  	BUG_ON(!domain->pgsize_bitmap);
-
  	pg_size = 1UL << __ffs(domain->pgsize_bitmap);
-	INIT_LIST_HEAD(&mappings);
-
-	iommu_get_resv_regions(dev, &mappings);

  	/* We need to consider overlapping regions for different devices */
  	list_for_each_entry(entry, &mappings, list) {

>>
>> This effectively makes the VT-d code further down the same path
>> redundant, so no new restrictions there.
>>
>> What sort of fall-out should we expect on ARM or AMD?  This was a pretty
>> painful restriction to add on Intel.  Thanks,

I can't speak for AMD, but I wouldn't imagine any noticeable fallout for 
Arm. RMRs are still relatively new, and the devices that I've heard 
about seem highly unlikely to ever want to be assigned to userspace 
directly (they may well provide virtual functions or sub-devices that 
absolutely *would* be used with VFIO, but the "host" device owning the 
RMRs would not be).

>>
> 
> What about device_rmrr_is_relaxable()? Leave it in specific driver or
> consolidate to be generic?

That's where the generic information already comes from, since it 
provides the region type in intel_iommu_get_resv_regions() - the 
existing resv_region abstraction *is* the consolidation. AFAICS it would 
be needlessly painful to start trying to directly process bits of DMAR 
or IRVS outside their respective drivers. It's only 
device_is_rmrr_locked() which would become redundant here.

> intel-iommu sets RELAXABLE for USB and GPU assuming their RMRR region
> is not used post boot.
> 
> Presumably same policy can be applied to AMD too.
> 
> ARM RMR reports an explicit flag (ACPI_IORT_RMR_REMAP_PERMITTED) to
> mark out whether a RMR region is relaxable. I'm not sure whether USB/GPU
> is already covered.

Arm systems have no legacy of needing to offer compatibility with a PC 
BIOS from the 1990s, so PS/2 or VGA emulation is a non-issue for us ;)

Thanks,
Robin.
