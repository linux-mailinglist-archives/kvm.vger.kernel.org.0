Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33B334C195F
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 18:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243174AbiBWRGH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 12:06:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243172AbiBWRF7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 12:05:59 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0B3FB53704;
        Wed, 23 Feb 2022 09:05:31 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6C15A106F;
        Wed, 23 Feb 2022 09:05:31 -0800 (PST)
Received: from [10.57.40.147] (unknown [10.57.40.147])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 04CE33F5A1;
        Wed, 23 Feb 2022 09:05:26 -0800 (PST)
Message-ID: <78d2dd11-db30-39c8-6df4-d20f0dfbfce2@arm.com>
Date:   Wed, 23 Feb 2022 17:05:23 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v6 02/11] driver core: Add dma_cleanup callback in
 bus_type
Content-Language: en-GB
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Christoph Hellwig <hch@infradead.org>,
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
References: <1acb8748-8d44-688d-2380-f39ec820776f@arm.com>
 <20220222151632.GB10061@nvidia.com>
 <3d4c3bf1-fed6-f640-dc20-36d667de7461@arm.com>
 <20220222235353.GF10061@nvidia.com>
 <171bec90-5ea6-b35b-f027-1b5e961f5ddf@linux.intel.com>
 <880a269d-d39d-bab3-8d19-b493e874ec99@arm.com>
 <20220223134627.GO10061@nvidia.com> <YhY/a9wTjmYXsuwt@kroah.com>
 <20220223140901.GP10061@nvidia.com> <20220223143011.GQ10061@nvidia.com>
 <YhZa3D5Xwv5oZm7L@kroah.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <YhZa3D5Xwv5oZm7L@kroah.com>
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

On 2022-02-23 16:03, Greg Kroah-Hartman wrote:
> On Wed, Feb 23, 2022 at 10:30:11AM -0400, Jason Gunthorpe wrote:
>> On Wed, Feb 23, 2022 at 10:09:01AM -0400, Jason Gunthorpe wrote:
>>> On Wed, Feb 23, 2022 at 03:06:35PM +0100, Greg Kroah-Hartman wrote:
>>>> On Wed, Feb 23, 2022 at 09:46:27AM -0400, Jason Gunthorpe wrote:
>>>>> On Wed, Feb 23, 2022 at 01:04:00PM +0000, Robin Murphy wrote:
>>>>>
>>>>>> 1 - tmp->driver is non-NULL because tmp is already bound.
>>>>>>    1.a - If tmp->driver->driver_managed_dma == 0, the group must currently be
>>>>>> DMA-API-owned as a whole. Regardless of what driver dev has unbound from,
>>>>>> its removal does not release someone else's DMA API (co-)ownership.
>>>>>
>>>>> This is an uncommon locking pattern, but it does work. It relies on
>>>>> the mutex being an effective synchronization barrier for an unlocked
>>>>> store:
>>>>>
>>>>> 				      WRITE_ONCE(dev->driver, NULL)
>>>>
>>>> Only the driver core should be messing with the dev->driver pointer as
>>>> when it does so, it already has the proper locks held.  Do I need to
>>>> move that to a "private" location so that nothing outside of the driver
>>>> core can mess with it?
>>>
>>> It would be nice, I've seen a abuse and mislocking of it in drivers
>>
>> Though to be clear, what Robin is describing is still keeping the
>> dev->driver stores in dd.c, just reading it in a lockless way from
>> other modules.
> 
> "other modules" should never care if a device has a driver bound to it
> because instantly after the check happens, it can change so what ever
> logic it wanted to do with that knowledge is gone.
> 
> Unless the bus lock is held that the device is on, but that should be
> only accessable from within the driver core as it controls that type of
> stuff, not any random other part of the kernel.
> 
> And in looking at this, ick, there are loads of places in the kernel
> that are thinking that this pointer being set to something actually
> means something.  Sometimes it does, but lots of places, it doesn't as
> it can change.

That's fine. In this case we're only talking about the low-level IOMMU 
code which has to be in cahoots with the driver core to some degree (via 
these new callbacks) anyway, but if you're uncomfortable about relying 
on dev->driver even there, I can live with that. There are several 
potential places to capture the relevant information in IOMMU API 
private data, from the point in really_probe() where it *is* stable, and 
then never look at dev->driver ever again - even from .dma_cleanup() or 
future equivalent, which is the aspect from whence this whole 
proof-of-concept tangent span out.

Cheers,
Robin.
