Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0CAE4F92A5
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 12:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233852AbiDHKNz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 06:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233149AbiDHKNv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 06:13:51 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8309AAC042
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 03:11:48 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4A7DB11FB;
        Fri,  8 Apr 2022 03:11:48 -0700 (PDT)
Received: from [10.57.41.19] (unknown [10.57.41.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6C6F53F73B;
        Fri,  8 Apr 2022 03:11:46 -0700 (PDT)
Message-ID: <f904979d-35ee-e2b8-5fd3-325d956be0d7@arm.com>
Date:   Fri, 8 Apr 2022 11:11:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 0/4] Make the iommu driver no-snoop block feature
 consistent
Content-Language: en-GB
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>
References: <0-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
 <f5acf507-b4ef-b393-159c-05ca04feb43d@arm.com>
 <20220407174326.GR2120790@nvidia.com>
 <77482321-2e39-fc7c-09b6-e929a851a80f@arm.com>
 <20220407190824.GS2120790@nvidia.com>
 <BN9PR11MB527648540AA714E988AE92608CE99@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <BN9PR11MB527648540AA714E988AE92608CE99@BN9PR11MB5276.namprd11.prod.outlook.com>
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

On 2022-04-08 10:08, Tian, Kevin wrote:
>> From: Jason Gunthorpe <jgg@nvidia.com>
>> Sent: Friday, April 8, 2022 3:08 AM
>> On Thu, Apr 07, 2022 at 07:02:03PM +0100, Robin Murphy wrote:
>>> On 2022-04-07 18:43, Jason Gunthorpe wrote:
>>>> On Thu, Apr 07, 2022 at 06:03:37PM +0100, Robin Murphy wrote:
>>>>> At a glance, this all looks about the right shape to me now, thanks!
>>>>
>>>> Thanks!
>>>>
>>>>> Ideally I'd hope patch #4 could go straight to device_iommu_capable()
>> from
>>>>> my Thunderbolt series, but we can figure that out in a couple of weeks
>> once
>>>>
>>>> Yes, this does helps that because now the only iommu_capable call is
>>>> in a context where a device is available :)
>>>
>>> Derp, of course I have *two* VFIO patches waiting, the other one touching
>>> the iommu_capable() calls (there's still IOMMU_CAP_INTR_REMAP, which,
>> much
>>> as I hate it and would love to boot all that stuff over to
>>> drivers/irqchip,
>>
>> Oh me too...
>>
>>> it's not in my way so I'm leaving it be for now). I'll have to rebase that
>>> anyway, so merging this as-is is absolutely fine!
>>
>> This might help your effort - after this series and this below there
>> are no 'bus' users of iommu_capable left at all.
>>
> 
> Out of curiosity, while iommu_capable is being moved to a per-device
> interface what about irq_domain_check_msi_remap() below (which
> is also a global check)?

I suppose it could if anyone cared enough to make the effort - probably 
a case of resolving specific MSI domains for every device in the group, 
and potentially having to deal with hotplug later as well. 
Realistically, though, I wouldn't expect systems to have mixed 
capabilities in that regard (i.e. where the check would return false 
even though *some* domains support remapping), so there doesn't seem to 
be any pressing need to relax it.

Cheers,
Robin.

>> +static int vfio_iommu_device_ok(void *iommu_data, struct device *device)
>> +{
>> +	bool msi_remap;
>> +
>> +	msi_remap = irq_domain_check_msi_remap() ||
>> +		    iommu_capable(device->bus, IOMMU_CAP_INTR_REMAP);
>> +
> 
