Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4EF4C1386
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 14:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240620AbiBWNEi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 08:04:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236296AbiBWNEg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 08:04:36 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2C5899319C;
        Wed, 23 Feb 2022 05:04:09 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D5EEAED1;
        Wed, 23 Feb 2022 05:04:08 -0800 (PST)
Received: from [10.57.40.147] (unknown [10.57.40.147])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ACA053F70D;
        Wed, 23 Feb 2022 05:04:04 -0800 (PST)
Message-ID: <880a269d-d39d-bab3-8d19-b493e874ec99@arm.com>
Date:   Wed, 23 Feb 2022 13:04:00 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v6 02/11] driver core: Add dma_cleanup callback in
 bus_type
Content-Language: en-GB
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, kvm@vger.kernel.org,
        rafael@kernel.org, David Airlie <airlied@linux.ie>,
        linux-pci@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Will Deacon <will@kernel.org>,
        Stuart Yoder <stuyoder@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, Li Yang <leoyang.li@nxp.com>,
        iommu@lists.linux-foundation.org,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>
References: <20220218005521.172832-1-baolu.lu@linux.intel.com>
 <20220218005521.172832-3-baolu.lu@linux.intel.com>
 <YhCdEmC2lYStmUSL@infradead.org>
 <1d8004d3-1887-4fc7-08d2-0e2ee6b5fdcb@arm.com>
 <20220221234837.GA10061@nvidia.com>
 <1acb8748-8d44-688d-2380-f39ec820776f@arm.com>
 <20220222151632.GB10061@nvidia.com>
 <3d4c3bf1-fed6-f640-dc20-36d667de7461@arm.com>
 <20220222235353.GF10061@nvidia.com>
 <171bec90-5ea6-b35b-f027-1b5e961f5ddf@linux.intel.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <171bec90-5ea6-b35b-f027-1b5e961f5ddf@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-02-23 05:01, Lu Baolu wrote:
> On 2/23/22 7:53 AM, Jason Gunthorpe wrote:
>>> To spell it out, the scheme I'm proposing looks like this:
>> Well, I already got this, it is what is in driver_or_DMA_API_token()
>> that matters
>>
>> I think you are suggesting to do something like:
>>
>>     if (!READ_ONCE(dev->driver) ||  ???)
>>         return NULL;
>>     return group;  // A DMA_API 'token'
>>
>> Which is locklessly reading dev->driver, and why you are talking about
>> races, I guess.
>>
> 
> I am afraid that we are not able to implement a race-free
> driver_or_DMA_API_token() helper. The lock problem between the IOMMU
> core and driver core always exists.

It's not race-free. My point is that the races aren't harmful because 
what we might infer from the "wrong" information still leads to the 
right action. dev->driver is obviously always valid and constant for 
*claiming* ownership, since that either happens for the DMA API in the 
middle of really_probe() binding driver to dev, or while driver is 
actively using dev and calling iommu_group_claim_dma_owner(). The races 
exist during remove, but both probe and remove are serialised on the 
group mutex after respectively setting/clearing dev->driver, there are 
only 4 possibilities for the state of any other group sibling "tmp" 
during the time that dev holds that mutex in its remove path:

1 - tmp->driver is non-NULL because tmp is already bound.
   1.a - If tmp->driver->driver_managed_dma == 0, the group must 
currently be DMA-API-owned as a whole. Regardless of what driver dev has 
unbound from, its removal does not release someone else's DMA API 
(co-)ownership.
   1.b - If tmp->driver->driver_managed_dma == 1 and tmp->driver == 
group->owner, then dev must have unbound from the same driver, but 
either way that driver has not yet released ownership so dev's removal 
does not change anything.
   1.c - If tmp->driver->driver_managed_dma == 1 and tmp->driver != 
group->owner, it doesn't matter. Even if tmp->driver is currently 
waiting to attempt to claim ownership it can't do so until we release 
the mutex.

2 - tmp->driver is non-NULL because tmp is in the process of binding.
   2.a - If tmp->driver->driver_managed_dma == 0, tmp can be assumed to 
be waiting on the group mutex to claim DMA API ownership.
     2.a.i - If the group is DMA API owned, this race is simply a 
short-cut to case 1.a - dev's ownership is effectively handed off 
directly to tmp, rather than potentially being released and immediately 
reclaimed. Once tmp gets its turn, it finds the group already 
DMA-API-owned as it wanted and all is well. This may be "unfair" if an 
explicit claim was also waiting, but not incorrect.
     2.a.ii - If the group is driver-owned, it doesn't matter. Removing 
dev does not change the current ownership, and tmp's probe will 
eventually get its turn and find whatever it finds at that point in future.
   2.b - If tmp->driver->driver_managed_dma == 1, it doesn't matter. 
Either that driver already owns the group, or it might try to claim it 
after we've resolved dev's removal and released the mutex, in which case 
it will find whatever it finds.

3 - tmp->driver is NULL because tmp is unbound. Obviously no impact.

4 - tmp->driver is NULL because tmp is in the process of unbinding.
   4.a - If the group is DMA-API-owned, either way tmp has no further 
influence.
     4.a.i - If tmp has unbound from a driver_managed_dma=0 driver, it 
must be waiting to release its DMA API ownership, thus if tmp would 
otherwise be the only remaining DMA API owner, the race is that dev's 
removal releases ownership on behalf of both devices. When tmp's own 
removal subsequently gets the mutex, it will either see that the group 
is already unowned, or maybe that someone else has re-claimed it in the 
interim, and either way do nothing, which is fine.
     4.a.ii - If tmp has unbound from a driver_managed_dma=1 driver, it 
doesn't matter, as in case 1.c.
   4.b - If the group is driver-owned, it doesn't matter. That ownership 
can only change if that driver releases it, which isn't happening while 
we hold the mutex.

As I said yesterday, I'm really just airing out an idea here; I might 
write up some proper patches as part of the bus ops work, and we can 
give it proper scrutiny then.

> For example, when we implemented iommu_group_store_type() to change the
> default domain type of a device through sysfs, we could only comprised
> and limited this functionality to singleton groups to avoid the lock
> issue.

Indeed, but once the probe and remove paths for grouped devices have to 
serialise on the group mutex, as we're introducing here, the story 
changes and we gain a lot more power. In fact that's a good point I 
hadn't considered yet - that sysfs constraint is functionally equivalent 
to the one in iommu_attach_device(), so once we land this ownership 
concept we should be free to relax it from "singleton" to "unowned" in 
much the same way as your other series is doing for attach.

> Unfortunately, that compromise cannot simply applied to the problem to
> be solved by this series, because the iommu core cannot abort the driver
> binding when the conflict is detected in the bus notifier.

No, I've never proposed that probe-time DMA ownership can be claimed 
from a notifier, we all know why that doesn't work. It's only the 
dma_cleanup() step that *could* be punted back to iommu_bus_notifier vs. 
the driver core having to know about it. Either way we're still 
serialising remove/failure against probe/remove of other devices in a 
group, and that's the critical aspect.

Thanks,
Robin.
