Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC055B4040
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 21:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbiIITzY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 15:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231907AbiIITzU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 15:55:20 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C35AC9F760
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 12:55:16 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A8691165C;
        Fri,  9 Sep 2022 12:55:22 -0700 (PDT)
Received: from [10.57.15.197] (unknown [10.57.15.197])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 761A23F93E;
        Fri,  9 Sep 2022 12:55:13 -0700 (PDT)
Message-ID: <b753aecb-ee2a-2cd0-1df2-0c3e977b4cb9@arm.com>
Date:   Fri, 9 Sep 2022 20:55:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 4/4] iommu: Fix ordering of iommu_release_device()
Content-Language: en-GB
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Will Deacon <will@kernel.org>, Qian Cai <cai@lca.pw>,
        Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
References: <4-v1-ef00ffecea52+2cb-iommu_group_lifetime_jgg@nvidia.com>
 <87b7041e-bc8d-500c-7167-04190e3795a9@arm.com>
 <ada74e00-77e1-770b-f0b7-a4c43a86c06f@arm.com> <YxpiBEbGHECGGq5Q@nvidia.com>
 <38bac59a-808d-5e91-227a-a3a06633c091@arm.com> <Yxs+1s+MPENLTUpG@nvidia.com>
 <e0ff6dc1-91b3-2e41-212c-c83a2bf2b3a8@arm.com> <YxuGQDCzDsvKV2W8@nvidia.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <YxuGQDCzDsvKV2W8@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-09-09 19:30, Jason Gunthorpe wrote:
> On Fri, Sep 09, 2022 at 06:57:59PM +0100, Robin Murphy wrote:
> 
>>>> That then only leaves the issue that that domain may still become
>>>> invalid at any point after the group mutex has been dropped.
>>>
>>> So that is this race:
>>>
>>>           CPU0                         CPU1
>>>      iommu_release_device(a)
>>>         __iommu_group_remove_device(a)
>>> 			         iommu_device_use_default_domain(b)
>>>                                    iommu_domain_free(domain)
>>>                                    iommu_release_device(b)
>>>                                         ops->release_device(b)
>>>         ops->release_device(a)
>>>           // Boom, a is still attached to domain :(
>>>
>>> I can't think of how to solve this other than holding the group mutex
>>> across release_device. See below.
>>
>> I see a few possibilities:
>>
>> - Backtrack slightly on its removal, and instead repurpose detach_dev
>> into a specialised domain cleanup callback, called before or during
>> iommu_group_remove_device(), with the group mutex held.
> 
> See below for why that is somewhat troublesome..
>   
>> - Drivers that hold any kind of internal per-device references to
>> domains - which is generally the root of this issue in the first place -
>> can implement proper reference counting, so even if a domain is "freed"
>> with a device still attached as above, it doesn't actually go away until
>> release_device(a) cleans up the final dangling reference. I suggested
>> the core doing this generically, but on reflection I think it's actually
>> a lot more straightforward as a driver-internal thing.
> 
> Isn't this every driver though? Like every single driver implementing
> an UNMANAGED/DMA/DMA_FQ domain has a hidden reference to the
> iommu_domain - minimally to point the HW to the IOPTEs it stores.

Um, no? Domain ops get the domain passed in as an argument, which is far 
from hidden, and if any driver implemented them to ignore that argument 
and operate on something else it would be stupid and broken. Note I said 
"per-device reference", meaning things like s390's zpci_dev->s390_domain 
and SMMUv3's dev->iommu->priv->domain. It's only those references that 
are reachable from release_device - outside the normal domain lifecycle 
- which are problematic.

>> - Drivers that basically just keep a list of devices in the domain and
>> need to do a list_del() in release_device, can also list_del_init() any
>> still-attached devices in domain_free, with a simple per-instance or
>> global lock to serialise the two.
> 
> Compared to just locking ops->release_device() these all seem more
> complicated?

Well, yes, but they are still potentially-viable examples of the 
alternative solutions you said you couldn't think of ;)

> IMHO the core code should try to protect the driver from racing
> release with anything else.
> 
> Do you know a reason not to hold the group mutex across
> release_device? I think that is the most straightforward and
> future proof.

Yes, the ones documented in the code and already discussed here. The 
current functional ones aren't particularly *good* reasons, but unless 
and until they can all be cleaned up they are what they are.

> Arguably all the device ops should be serialized under the group
> mutex.

Maybe once groups and default domains are used consistently everywhere. 
And notwithstanding that half the ops have no association with a group, 
are needed before or as part of obtaining a group, or were explicitly 
intended to allow calling back into other APIs that might lock the 
relevant group :P

>> @@ -1022,6 +1030,14 @@ void iommu_group_remove_device(struct device *dev)
>>   	dev_info(dev, "Removing from iommu group %d\n", group->id);
>>   	mutex_lock(&group->mutex);
>> +	if (WARN_ON(group->domain != group->default_domain &&
>> +		    group->domain != group->blocking_domain)) {
> 
> This will false trigger, if there are two VFIO devices then the group
> will remained owned when we unplug one just of them, but the group's domain
> will be a VFIO owned domain.

As opposed to currently, where most drivers' release_device will blindly 
detach/disable the RID in some fashion so the other device would 
suddenly blow up anyway? A warning of the impending disaster might be 
quite informative, I reckon.

> It is why I put the list_empty() protection, as the test only works if
> it is the last device.
> 
>> +		if (group->default_domain)
>> +			__iommu_attach_device(group->default_domain, dev);
>> +		else
>> +			__iommu_detach_device(group->domain, dev);
>> +	}
> 
> This was very appealing, but I rejected it because it is too difficult
> to support multi-device groups that share the RID.
> 
> In that case we expect that the first attach/detach of a device on the
> shared RID will reconfigure the iommu and the attach/deatch of all the
> other devices on the group with the same parameters will be a NOP.
> 
> So in a VFIO configuration where two drivers are bound to a single
> group with shared RID and we unplug one device, this will rebind the
> shared RID and thus the entire group to blocking/default and break the
> still running VFIO on the second device.

As above, I am supremely confident that nobody has ever done that 
because it is already broken on everything that matters.

(It *will* actually work on SMMUv2 because SMMUv2 comprehensively 
handles StreamID-level aliasing beyond what pci_device_group() covers, 
which I remain rather proud of)

> The device centric interface only works if we always apply the
> operation to every device in the group..
> 
> This is why I kept it as ops->release_device() with an implicit detach
> of the current domain inside the driver. release_device() has that
> special meaning of 'detach the domain but do not change a shared RID'

If you want to rely on that notion, you'll need to tell all the major 
drivers about it first, I'm afraid.

> And it misses the logic to WARN_ON if a domain is set and an external
> entity wrongly uses iommu_group_remove_device()..

Huh? An external fake group couldn't have a default domain or blocking 
domain, thus any non-NULL domain will not compare equal to either, so if 
that could happen it will warn, and then most likely crash. I did think 
briefly about trying to make it not crash, but then I remembered that 
fake groups from external callers also aren't backed by IOMMU API 
drivers so have no way to allocate or attach domains either, so in fact 
it cannot happen at all under any circumstances that are worth reasoning 
about.

Yes, some nefarious driver could call iommu_group_remove_device() on 
random devices. It could also call kfree(dev->iommu_group). Or 
kfree(iommu_group_remove_device). Fundamentally-broken kernel code can 
crash the kernel, whoop de do.

Thanks,
Robin.
