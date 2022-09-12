Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C25D5B5910
	for <lists+kvm@lfdr.de>; Mon, 12 Sep 2022 13:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbiILLNh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Sep 2022 07:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbiILLNg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Sep 2022 07:13:36 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 90A1E386AE
        for <kvm@vger.kernel.org>; Mon, 12 Sep 2022 04:13:34 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 92C29113E;
        Mon, 12 Sep 2022 04:13:40 -0700 (PDT)
Received: from [10.57.15.197] (unknown [10.57.15.197])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 723523F71A;
        Mon, 12 Sep 2022 04:13:30 -0700 (PDT)
Message-ID: <2c66a30e-f96f-f11c-bb05-a5f4a756ab30@arm.com>
Date:   Mon, 12 Sep 2022 12:13:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 4/4] iommu: Fix ordering of iommu_release_device()
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
 <b753aecb-ee2a-2cd0-1df2-0c3e977b4cb9@arm.com> <YxvQNTD1U4bs5TZD@nvidia.com>
Content-Language: en-GB
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <YxvQNTD1U4bs5TZD@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-09-10 00:45, Jason Gunthorpe wrote:
> On Fri, Sep 09, 2022 at 08:55:07PM +0100, Robin Murphy wrote:
> 
>>> Isn't this every driver though? Like every single driver implementing
>>> an UNMANAGED/DMA/DMA_FQ domain has a hidden reference to the
>>> iommu_domain - minimally to point the HW to the IOPTEs it stores.
>>
>> Um, no? Domain ops get the domain passed in as an argument, which is far
>> from hidden, and if any driver implemented them to ignore that argument and
>> operate on something else it would be stupid and broken. Note I said
>> "per-device reference", meaning things like s390's zpci_dev->s390_domain and
>> SMMUv3's dev->iommu->priv->domain. It's only those references that are
>> reachable from release_device - outside the normal domain lifecycle - which
>> are problematic.
> 
> If the plan is to make the domain refcounted and then allow a 'put' on
> it before we reach release_device() then it means every driver needs
> to hold a 'get' on the domain while it is programmed into the HW.
> 
> Because the hw will still be touching memory that could be freed by an
> iommu_domain_free(). By "hidden" reference I mean the HW walkers are
> touching memory that would be freed - ie kasn won't see it.

As far as I'm concerned we're dealing purely with the case where 
release_device races with attaching back to the default domain *and* the 
driver has some reason for release_device to poke at what it thinks the 
currently-attached domain is. Anyone who frees a domain while it's still 
actually live deserves whatever they get; it would be thoroughly 
impractical to attempt to mitigate for that kind of silliness.

>>> Do you know a reason not to hold the group mutex across
>>> release_device? I think that is the most straightforward and
>>> future proof.
>>
>> Yes, the ones documented in the code and already discussed here. The current
>> functional ones aren't particularly *good* reasons, but unless and until
>> they can all be cleaned up they are what they are.
> 
> Uh, I feel like I missed part of the conversation - I don't know what
> this list is..

s390 (remember how we got here?) calls iommu_get_domain_for_dev(). 
ipmmu-vmsa calls arm_iommu_detach_device() (mtk_v1 doesn't, but perhaps 
technically should), to undo the corresponding attach from 
probe_finalize - apologies for misremembering which way round the 
comments were.

>>>> @@ -1022,6 +1030,14 @@ void iommu_group_remove_device(struct device *dev)
>>>>    	dev_info(dev, "Removing from iommu group %d\n", group->id);
>>>>    	mutex_lock(&group->mutex);
>>>> +	if (WARN_ON(group->domain != group->default_domain &&
>>>> +		    group->domain != group->blocking_domain)) {
>>>
>>> This will false trigger, if there are two VFIO devices then the group
>>> will remained owned when we unplug one just of them, but the group's domain
>>> will be a VFIO owned domain.
>>
>> As opposed to currently, where most drivers' release_device will blindly
>> detach/disable the RID in some fashion so the other device would suddenly
>> blow up anyway?
> 
> Er, I think it is OK today, in the non-shared case. If the RID isn't
> shared then each device in the group is independent, so most drivers,
> most of the time, should only effect the RID release_device() is
> called on, while this warning will always trigger for any multi-device
> group.

Oh, apparently I managed to misinterpret this as the two *aliasing* 
devices case, sorry. Indeed it is overly conservative for that. I think 
the robust way to detect bad usage is actually not via the group at all, 
but for iommu_device_{un}use_default_domain() to also maintain a 
per-device ownership flag, then we warn if a device is released with 
that still set.

>> (It *will* actually work on SMMUv2 because SMMUv2 comprehensively handles
>> StreamID-level aliasing beyond what pci_device_group() covers, which I
>> remain rather proud of)
> 
> This is why I prefered not to explicitly change the domain, because at
> least if someone did write a non-buggy driver it doesn't get wrecked -
> and making a non-buggy driver is at least allowed by the API.

Detaching back to the default domain still seems like it's *always* the 
right thing to do at this point, even when it should not be warned about 
as above. As I say it *does* work on non-buggy drivers, and making this 
whole domain use-after-free race a fundamental non-issue is attractive.

>>> And it misses the logic to WARN_ON if a domain is set and an external
>>> entity wrongly uses iommu_group_remove_device()..
>>
>> Huh? An external fake group couldn't have a default domain or blocking
>> domain, thus any non-NULL domain will not compare equal to either, so if
>> that could happen it will warn, and then most likely crash. I did think
>> briefly about trying to make it not crash, but then I remembered that fake
>> groups from external callers also aren't backed by IOMMU API drivers so have
>> no way to allocate or attach domains either, so in fact it cannot happen at
>> all under any circumstances that are worth reasoning about.
> 
> I mean specificaly thing like FSL is doing where it is a real driver
> calling this API and the test of 'group->domain == NULL' is the more
> robust precondition.

Having looked a bit closer, I think I get what PAMU is doing - kind of 
impedance-matching between pci_device_group() and its own non-ACS form 
of isolation, and possibly also a rather roundabout way of propagating 
DT data from the PCI controller node up into the PCI hierarchy. Both 
could quite likely be done in a more straightforward manner these days 
(and TBH I'm not convinced it works at all since it doesn't appear to 
match the actual DT binding), but either way I'm fairly confident we 
needn't worry about it.

Thanks,
Robin.
