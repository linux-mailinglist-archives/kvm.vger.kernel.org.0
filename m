Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 718065539FD
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 21:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352794AbiFUTJ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 15:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243248AbiFUTJ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 15:09:27 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 572A122B1F;
        Tue, 21 Jun 2022 12:09:26 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 423E9165C;
        Tue, 21 Jun 2022 12:09:26 -0700 (PDT)
Received: from [10.57.85.30] (unknown [10.57.85.30])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1B8893F792;
        Tue, 21 Jun 2022 12:09:24 -0700 (PDT)
Message-ID: <4bc34090-249a-c505-3d90-f75a7fe7c17d@arm.com>
Date:   Tue, 21 Jun 2022 20:09:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 1/2] vfio/type1: Simplify bus_type determination
Content-Language: en-GB
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     kvm@vger.kernel.org, cohuck@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        alex.williamson@redhat.com
References: <07c69a27fa5bf9724ea8c9fcfe3ff2e8b68f6bf0.1654697988.git.robin.murphy@arm.com>
 <20220610000343.GD1343366@nvidia.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20220610000343.GD1343366@nvidia.com>
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

On 2022-06-10 01:03, Jason Gunthorpe via iommu wrote:
> On Wed, Jun 08, 2022 at 03:25:49PM +0100, Robin Murphy wrote:
>> Since IOMMU groups are mandatory for drivers to support, it stands to
>> reason that any device which has been successfully be added to a group
>> must be on a bus supported by that IOMMU driver, and therefore a domain
>> viable for any device in the group must be viable for all devices in
>> the group. This already has to be the case for the IOMMU API's internal
>> default domain, for instance. Thus even if the group contains devices
>> on different buses, that can only mean that the IOMMU driver actually
>> supports such an odd topology, and so without loss of generality we can
>> expect the bus type of any arbitrary device in a group to be suitable
>> for IOMMU API calls.
>>
>> Replace vfio_bus_type() with a trivial callback that simply returns any
>> device from which to then derive a usable bus type. This is also a step
>> towards removing the vague bus-based interfaces from the IOMMU API.
>>
>> Furthermore, scrutiny reveals a lack of protection for the bus and/or
>> device being removed while .attach_group is inspecting them; the
>> reference we hold on the iommu_group ensures that data remains valid,
>> but does not prevent the group's membership changing underfoot. Holding
>> the vfio_goup's device_lock should be sufficient to block any relevant
>> device's VFIO driver from unregistering, and thus block unbinding and
>> any further stages of removal for the duration of the attach operation.
> 
> The device_lock only protects devices that are on the device_list from
> concurrent unregistration, the device returned by
> iommu_group_for_each_dev() is not guarented to be the on the device
> list.

Sigh, you're quite right, and now I have a vague feeling that you called 
that out in the previous discussion too, so apologies for forgetting.

>> @@ -760,8 +760,11 @@ static int __vfio_container_attach_groups(struct vfio_container *container,
>>   	int ret = -ENODEV;
>>   
>>   	list_for_each_entry(group, &container->group_list, container_next) {
>> +		/* Prevent devices unregistering during attach */
>> +		mutex_lock(&group->device_lock);
>>   		ret = driver->ops->attach_group(data, group->iommu_group,
>>   						group->type);
>> +		mutex_unlock(&group->device_lock);
> 
> I still prefer the version where we pass in an arbitrary vfio_device
> from the list the group maintains:
> 
>     list_first_entry(group->device_list)
> 
> And don't call iommu_group_for_each_dev(), it is much simpler to
> reason about how it works.

Agreed, trying to figure out which are the VFIO devices from within the 
iommu_group iterator seems beyond the threshold of practicality.

Quick consensus then: does anyone have a particular preference between 
changing the .attach_group signature vs. adding a helper based on 
vfio_group_get_from_iommu() for type1 to call from within its callback? 
They seem about equal (but opposite) in terms of the simplicity vs. 
impact tradeoff to me, so I can't quite decide conclusively...

Thanks,
Robin.
