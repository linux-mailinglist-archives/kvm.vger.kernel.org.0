Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 421434B573E
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 17:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356673AbiBNQlq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 11:41:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356709AbiBNQlh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 11:41:37 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DCDF565794;
        Mon, 14 Feb 2022 08:38:49 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 93B7813D5;
        Mon, 14 Feb 2022 08:38:49 -0800 (PST)
Received: from [10.57.70.89] (unknown [10.57.70.89])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1DA383F70D;
        Mon, 14 Feb 2022 08:38:45 -0800 (PST)
Message-ID: <f302e823-ecc3-2aae-e275-85a56e26fb25@arm.com>
Date:   Mon, 14 Feb 2022 16:38:23 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v1 1/8] iommu: Add iommu_group_replace_domain()
Content-Language: en-GB
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     kvm@vger.kernel.org, rafael@kernel.org,
        David Airlie <airlied@linux.ie>, linux-pci@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Will Deacon <will@kernel.org>, Ashok Raj <ashok.raj@intel.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Stuart Yoder <stuyoder@gmail.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, Li Yang <leoyang.li@nxp.com>,
        iommu@lists.linux-foundation.org,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>
References: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
 <20220106022053.2406748-2-baolu.lu@linux.intel.com>
 <43f2fc07-19ea-53a4-af86-a9192a950c96@arm.com>
 <20220214124518.GU4160@nvidia.com>
 <1347f0ef-e046-1332-32f0-07347cc2079c@arm.com>
 <20220214145627.GD4160@nvidia.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20220214145627.GD4160@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-02-14 14:56, Jason Gunthorpe via iommu wrote:
> On Mon, Feb 14, 2022 at 02:10:19PM +0000, Robin Murphy wrote:
>> On 2022-02-14 12:45, Jason Gunthorpe wrote:
>>> On Mon, Feb 14, 2022 at 12:09:36PM +0000, Robin Murphy wrote:
>>>> On 2022-01-06 02:20, Lu Baolu wrote:
>>>>> Expose an interface to replace the domain of an iommu group for frameworks
>>>>> like vfio which claims the ownership of the whole iommu group.
>>>>
>>>> But if the underlying point is the new expectation that
>>>> iommu_{attach,detach}_device() operate on the device's whole group where
>>>> relevant, why should we invent some special mechanism for VFIO to be
>>>> needlessly inconsistent?
>>>>
>>>> I said before that it's trivial for VFIO to resolve a suitable device if it
>>>> needs to; by now I've actually written the patch ;)
>>>>
>>>> https://gitlab.arm.com/linux-arm/linux-rm/-/commit/9f37d8c17c9b606abc96e1f1001c0b97c8b93ed5
>>>
>>> Er, how does locking work there? What keeps busdev from being
>>> concurrently unplugged?
>>
>> Same thing that prevents the bus pointer from suddenly becoming invalid in
>> the current code, I guess :)
> 
> Oooh, yes, that does look broken now too. :(
> 
>>> How can iommu_group_get() be safely called on
>>> this pointer?
>>
>> What matters is being able to call *other* device-based IOMMU API
>> interfaces in the long term.
> 
> Yes, this is what I mean, those are the ones that call
> iommu_group_get().
> 
>>> All of the above only works normally inside a probe/remove context
>>> where the driver core is blocking concurrent unplug and descruction.
>>>
>>> I think I said this last time you brought it up that lifetime was the
>>> challenge with this idea.
>>
>> Indeed, but it's a challenge that needs tackling, because the bus-based
>> interfaces need to go away. So either we figure it out now and let this
>> attach interface rework benefit immediately, or I spend three times as long
> 
> IMHO your path is easier if you let VFIO stay with the group interface
> and use something like:
> 
>     domain = iommu_group_alloc_domain(group)
> 
> Which is what VFIO is trying to accomplish. Since Lu removed the only
> other user of iommu_group_for_each_dev() it means we can de-export
> that interface.
> 
> This works better because the iommu code can hold the internal group
> while it finds the bus/device and then invokes the driver op. We don't
> have a lifetime problem anymore under that lock.

That's certainly one of the cleaner possibilities - per the theme of 
this thread I'm not hugely keen on proliferating special VFIO-specific 
versions of IOMMU APIs, but trying to take the dev->mutex might be a bit 
heavy-handed and risky, and getting at the vfio_group->device_lock a bit 
fiddly, so if I can't come up with anything nicer or more general it 
might be a fair compromise.

> The remaining VFIO use of bus for iommu_capable() is better done
> against the domain or the group object, as appropriate.

Indeed, although half the implementations of .capable are nonsense 
already, so I'm treating that one as a secondary priority for the moment 
(with an aim to come back afterwards and just try to kill it off as far 
as possible). RDMA and VFIO shouldn't be a serious concern for the kind 
of systems with heterogeneous IOMMUs at this point.

> In the bigger picture, VFIO should stop doing
> 'iommu_group_alloc_domain' by moving the domain alloc to
> VFIO_GROUP_GET_DEVICE_FD where we have a struct device to use.
> 
> We've already been experimenting with this for iommufd and the subtle
> difference in the uapi doesn't seem relevant.
> 
>> solving it on my own and end up deleting
>> iommu_group_replace_domain() in about 6 months' time anyway.
> 
> I expect this API to remain until we figure out a solution to the PPC
> problem, and come up with an alternative way to change the attached
> domain on the fly.

I though PPC wasn't using the IOMMU API at all... or is that the problem?

Thanks,
Robin.
