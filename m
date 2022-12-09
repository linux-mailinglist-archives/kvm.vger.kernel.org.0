Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2DF6486AE
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 17:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiLIQoS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 11:44:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiLIQoQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 11:44:16 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 021922E6B3;
        Fri,  9 Dec 2022 08:44:15 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 67C9423A;
        Fri,  9 Dec 2022 08:44:21 -0800 (PST)
Received: from [10.57.87.116] (unknown [10.57.87.116])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 005AD3F73D;
        Fri,  9 Dec 2022 08:44:09 -0800 (PST)
Message-ID: <5e7dbc83-a853-dc45-5016-c53f1be8aaf8@arm.com>
Date:   Fri, 9 Dec 2022 16:44:06 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH iommufd 4/9] iommufd: Convert to
 msi_device_has_secure_msi()
Content-Language: en-GB
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alexander Gordeev <agordeev@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>,
        Bharat Bhushan <bharat.bhushan@nxp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tomasz Nowicki <tomasz.nowicki@caviumnetworks.com>,
        Will Deacon <will.deacon@arm.com>
References: <0-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
 <4-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
 <BN9PR11MB5276522F9FA4D4A486C5F60A8C1C9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y5NKlf4btF9xUXXZ@nvidia.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <Y5NKlf4btF9xUXXZ@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-12-09 14:47, Jason Gunthorpe wrote:
> On Fri, Dec 09, 2022 at 06:01:14AM +0000, Tian, Kevin wrote:
>>> From: Jason Gunthorpe <jgg@nvidia.com>
>>> Sent: Friday, December 9, 2022 4:27 AM
>>>
>>> @@ -170,7 +170,7 @@ static int iommufd_device_setup_msi(struct
>>> iommufd_device *idev,
>>>   	 * interrupt outside this iommufd context.
>>>   	 */
>>>   	if (!device_iommu_capable(idev->dev, IOMMU_CAP_INTR_REMAP)
>>> &&
>>> -	    !irq_domain_check_msi_remap()) {
>>> +	    !msi_device_has_secure_msi(idev->dev)) {
>>>   		if (!allow_unsafe_interrupts)
>>>   			return -EPERM;
>>>
>>
>> this is where iommufd and vfio diverge.
>>
>> vfio has a check to ensure all devices in the group has secure_msi.
>>
>> but iommufd only imposes the check per device.
> 
> Ah, that is an interesting, though pedantic point.
> 
> So, let us do this and address the other point about vfio as well:
> 
> +++ b/drivers/iommu/iommu.c
> @@ -941,6 +941,28 @@ static bool iommu_is_attach_deferred(struct device *dev)
>          return false;
>   }
>   
> +static int iommu_group_add_device_list(struct iommu_group *group,
> +                                      struct group_device *group_dev)
> +{
> +       struct group_device *existing;
> +
> +       lockdep_assert_held(&group->mutex);
> +
> +       existing = list_first_entry_or_null(&group->devices,
> +                                           struct group_device, list);
> +
> +       /*
> +        * It is a driver bug to create groups with different irq_domain
> +        * properties.
> +        */
> +       if (existing && msi_device_has_isolated_msi(existing->dev) !=
> +                               msi_device_has_isolated_msi(group_dev->dev))
> +               return -EINVAL;

Isn't the problem with this that it's super-early, and a device's MSI 
domain may not actually be resolved until someone starts requesting MSIs 
for it? Maybe Thomas' ongoing per-device stuff changes that, but I'm not 
sure :/

Furthermore, even if the system does have a topology with multiple 
heterogeneous MSI controllers reachable by devices behind the same 
IOMMU, and the IRQ layer decides to choose each device's MSI parent at 
random, that's hardly the IOMMU layer's problem, and shouldn't prevent 
the devices being usable by kernel drivers for whom MSI isolation 
doesn't matter.

Thanks,
Robin.

> +
> +       list_add_tail(&group_dev->list, &group->devices);
> +       return 0;
> +}
> +
>   /**
>    * iommu_group_add_device - add a device to an iommu group
>    * @group: the group into which to add the device (reference should be held)
> @@ -992,7 +1014,7 @@ int iommu_group_add_device(struct iommu_group *group, struct device *dev)
>          dev->iommu_group = group;
>   
>          mutex_lock(&group->mutex);
> -       list_add_tail(&device->list, &group->devices);
> +       iommu_group_add_device_list(group, device);
>          if (group->domain  && !iommu_is_attach_deferred(dev))
>                  ret = __iommu_attach_device(group->domain, dev);
>          mutex_unlock(&group->mutex);
