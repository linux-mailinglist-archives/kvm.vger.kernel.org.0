Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9421E4F9679
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 15:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236092AbiDHNOP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 09:14:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236554AbiDHNNs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 09:13:48 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 60F26B98
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 06:11:19 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0C28D113E;
        Fri,  8 Apr 2022 06:11:19 -0700 (PDT)
Received: from [10.57.41.19] (unknown [10.57.41.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5A1613F5A1;
        Fri,  8 Apr 2022 06:11:16 -0700 (PDT)
Message-ID: <4f93d16d-9606-bd1c-a82b-e4b00ae2364f@arm.com>
Date:   Fri, 8 Apr 2022 14:11:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 0/4] Make the iommu driver no-snoop block feature
 consistent
Content-Language: en-GB
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        iommu@lists.linux-foundation.org, Joerg Roedel <joro@8bytes.org>,
        kvm@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>
References: <0-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
 <f5acf507-b4ef-b393-159c-05ca04feb43d@arm.com>
 <20220407174326.GR2120790@nvidia.com>
 <77482321-2e39-fc7c-09b6-e929a851a80f@arm.com>
 <20220407190824.GS2120790@nvidia.com>
 <4cc084a5-7d25-8e81-bdc1-1501c3346a0c@arm.com>
 <20220408121845.GT2120790@nvidia.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20220408121845.GT2120790@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.7 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-04-08 13:18, Jason Gunthorpe wrote:
> On Thu, Apr 07, 2022 at 08:27:05PM +0100, Robin Murphy wrote:
>> On 2022-04-07 20:08, Jason Gunthorpe wrote:
>>> On Thu, Apr 07, 2022 at 07:02:03PM +0100, Robin Murphy wrote:
>>>> On 2022-04-07 18:43, Jason Gunthorpe wrote:
>>>>> On Thu, Apr 07, 2022 at 06:03:37PM +0100, Robin Murphy wrote:
>>>>>> At a glance, this all looks about the right shape to me now, thanks!
>>>>>
>>>>> Thanks!
>>>>>
>>>>>> Ideally I'd hope patch #4 could go straight to device_iommu_capable() from
>>>>>> my Thunderbolt series, but we can figure that out in a couple of weeks once
>>>>>
>>>>> Yes, this does helps that because now the only iommu_capable call is
>>>>> in a context where a device is available :)
>>>>
>>>> Derp, of course I have *two* VFIO patches waiting, the other one touching
>>>> the iommu_capable() calls (there's still IOMMU_CAP_INTR_REMAP, which, much
>>>> as I hate it and would love to boot all that stuff over to
>>>> drivers/irqchip,
>>>
>>> Oh me too...
>>>
>>>> it's not in my way so I'm leaving it be for now). I'll have to rebase that
>>>> anyway, so merging this as-is is absolutely fine!
>>>
>>> This might help your effort - after this series and this below there
>>> are no 'bus' users of iommu_capable left at all.
>>
>> Thanks, but I still need a device for the iommu_domain_alloc() as well, so
>> at that point the interrupt check is OK to stay where it is.
> 
> It is a simple enough change that could avoid introducing the
> device_iommu_capable() at all perhaps.
> 
>> I figured out a locking strategy per my original idea that seems
>> pretty clean, it just needs vfio_group_viable() to go away first:
> 
> I think this should be more like:
> 
>    	        struct vfio_device *vdev;
> 
> 		mutex_lock(&group->device_lock);
> 		vdev = list_first_entry(group->device_list, struct vfio_device, group_next);
> 		ret = driver->ops->attach_group(data, group->iommu_group,
> 						group->type,
> 						vdev->dev);
> 		mutex_unlock(&group->device_lock);
> 
> Then don't do the iommu_group_for_each_dev() at all.
> 
> The problem with iommu_group_for_each_dev() is that it may select a
> struct device that does not have a vfio_device bound to it, so we
> would be using a random struct device that is not protected by any
> VFIO device_driver.

Yeah, I was just looking at the final puzzle piece of making sure to nab 
the actual VFIO device rather than some unbound device that's just along 
for the ride... If I can't come up with anything more self-contained 
I'll take this suggestion, thanks.

> However, this creates an oddball situation where the vfio_device and
> it's struct device could become unplugged from the system while the
> domain that the struct device spawned continues to exist and remains
> attached to other devices in the same group. ie the iommu driver has
> to be careful not to retain the struct device input..

Oh, I rather assumed that VFIO might automatically tear down the 
container/domain when the last real user disappears. I don't see there 
being an obvious problem if the domain does hang around with residual 
non-VFIO devices attached until userspace explicitly closes all the 
relevant handles, as long as we take care not to release DMA ownership 
until that point also. As you say, it just looks a bit funny.

> I suppose that is inevitable to have sharing of domains across
> devices, so the iommu drivers will have to accommodate this.

I think domain lifecycle management is already entirely up to the users 
and not something that IOMMU drivers need to worry about. Drivers should 
only need to look at per-device data in attach/detach (and, once I've 
finished, alloc) from the device argument which can be assumed to be 
valid at that point. Otherwise, all the relevant internal data for 
domain ops should belong to the domain already.

Cheers,
Robin.
