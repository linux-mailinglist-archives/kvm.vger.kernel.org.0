Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D87C38B17E
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 16:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243112AbhETOQW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 10:16:22 -0400
Received: from foss.arm.com ([217.140.110.172]:52410 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239668AbhETOPX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 10:15:23 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 65EAF11D4;
        Thu, 20 May 2021 07:14:02 -0700 (PDT)
Received: from [10.57.66.179] (unknown [10.57.66.179])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B9AD23F73B;
        Thu, 20 May 2021 07:14:00 -0700 (PDT)
Subject: Re: [PATCH 3/6] vfio: remove the unused mdev iommu hook
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Will Deacon <will@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
References: <MWHPR11MB18866205125E566FE05867A78C509@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210514133143.GK1096940@ziepe.ca> <YKJf7mphTHZoi7Qr@8bytes.org>
 <20210517123010.GO1096940@ziepe.ca> <YKJnPGonR+d8rbu/@8bytes.org>
 <20210517133500.GP1096940@ziepe.ca> <YKKNLrdQ4QjhLrKX@8bytes.org>
 <131327e3-5066-7a88-5b3c-07013585eb01@arm.com>
 <20210519180635.GT1096940@ziepe.ca>
 <MWHPR11MB1886C64EAEB752DE9E1633358C2B9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210519232459.GV1096940@ziepe.ca>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <1d154445-f762-1147-0b8c-6e244e7c66dc@arm.com>
Date:   Thu, 20 May 2021 15:13:55 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210519232459.GV1096940@ziepe.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-05-20 00:24, Jason Gunthorpe wrote:
> On Wed, May 19, 2021 at 11:12:46PM +0000, Tian, Kevin wrote:
>>> From: Jason Gunthorpe <jgg@ziepe.ca>
>>> Sent: Thursday, May 20, 2021 2:07 AM
>>>
>>> On Wed, May 19, 2021 at 04:23:21PM +0100, Robin Murphy wrote:
>>>> On 2021-05-17 16:35, Joerg Roedel wrote:
>>>>> On Mon, May 17, 2021 at 10:35:00AM -0300, Jason Gunthorpe wrote:
>>>>>> Well, I'm sorry, but there is a huge other thread talking about the
>>>>>> IOASID design in great detail and why this is all needed. Jumping into
>>>>>> this thread without context and basically rejecting all the
>>>>>> conclusions that were reached over the last several weeks is really
>>>>>> not helpful - especially since your objection is not technical.
>>>>>>
>>>>>> I think you should wait for Intel to put together the /dev/ioasid uAPI
>>>>>> proposal and the example use cases it should address then you can give
>>>>>> feedback there, with proper context.
>>>>>
>>>>> Yes, I think the next step is that someone who read the whole thread
>>>>> writes up the conclusions and a rough /dev/ioasid API proposal, also
>>>>> mentioning the use-cases it addresses. Based on that we can discuss the
>>>>> implications this needs to have for IOMMU-API and code.
>>>>>
>>>>>   From the use-cases I know the mdev concept is just fine. But if there is
>>>>> a more generic one we can talk about it.
>>>>
>>>> Just to add another voice here, I have some colleagues working on drivers
>>>> where they want to use SMMU Substream IDs for a single hardware block
>>> to
>>>> operate on multiple iommu_domains managed entirely within the
>>>> kernel.
>>>
>>> If it is entirely within the kernel I'm confused how mdev gets
>>> involved? mdev is only for vfio which is userspace.

By "mdev-like" I mean it's very similar in shape to the general 
SIOV-style mediated device concept - i.e. a physical device with an 
awareness of operating on multiple contexts at once, using a Substream 
ID/PASID for each one - but instead of exposing control of the contexts 
to anyone else, they remain hidden behind the kernel driver which 
already has its own abstracted uAPI, so overall it ends up as more just 
internal housekeeping than any actual mediation. We were looking at the 
mdev code for inspiration, but directly using it was never the plan.

>> Just add some background. aux domain is used to support mdev but they
>> are not tied together.

[ yes, technically my comments are relevant to patch #4, but the 
discussion was here, so... :) ]

>> Literally aux domain just implies that there could be
>> multiple domains attached to a device then when one of them becomes
>> the primary all the remaining are deemed as auxiliary. From this angle it
>> doesn't matter whether the requirement of multiple domains come from
>> user or kernel.
> 
> You can't entirely use aux domain from inside the kernel because you
> can't compose it with the DMA API unless you also attach it to some
> struct device, and where will the struct device come from?

DMA mapping would still be done using the physical device - where this 
model diverges from mdev is that it doesn't need to fake up a struct 
device to represent each context since they aren't exposed to anyone 
else. Assume the driver already has some kind of token to represent each 
client process, so it just allocates an iommu_domain for a client 
context and does an iommu_aux_attach_dev() to hook it up to some PASID 
(which again nobody else ever sees). The driver simply needs to keep 
track of the domains and PASIDs - when a process submits some work, it 
can look up the relevant domain, iommu_map() the user pages to the right 
addresses, dma_map() them for coherency, then poke in the PASID as part 
of scheduling the work on the physical device.

> We already talked about this on the "how to use PASID from the kernel"
> thread.

Do you have a pointer to the right thread so I can catch up? It's not 
the easiest thing to search for on lore amongst all the other 
PASID-related business :(

> If Robin just wants to use a stream ID from a kernel driver then that
> API to make a PASID == RID seems like a better answer for kernel DMA
> than aux domains is.

No, that's not the model - the device has a single Stream ID (RID), and 
it wants multiple Substream IDs (PASIDs) hanging off that for distinct 
client contexts; it can still generate non-PASID traffic for stuff like 
loading its firmware (the regular iommu_domain might be 
explicitly-managed or might be automatic via iommu-dma - it doesn’t 
really matter in this context). Aux domains really were a perfect fit 
conceptually, even if the edges were a bit rough.

Now, much as I’d like a stable upstream solution, I can't argue based on 
this particular driver, since the PASID functionality is still in 
development, and there seems little likelihood of it being upstreamed 
either way (the driver belongs to a product team rather than the OSS 
group I'm part of; I'm just helping them with the SMMU angle). If 
designing something around aux domains is a dead-end then we (Arm) will 
probably just prototype our thing using downstream patches to the SMMU 
driver for now. However given the clear overlap with SIOV mdev in terms 
of implementation at the IOMMU API level and below, it seems a general 
enough use-case that I’m very keen not to lose sight of it in whatever 
replacement we (upstream) do come up with. FWIW my non-SVA view is that 
a PASID is merely an index into a set of iommu_domains, and in that 
context it doesn't even really matter *who* allocates them, only that 
the device driver and IOMMU driver are in sync :)

Thanks,
Robin.
