Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B75DB38F2D5
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 20:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233723AbhEXSUL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 14:20:11 -0400
Received: from foss.arm.com ([217.140.110.172]:46308 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232985AbhEXSUJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 14:20:09 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E6FE26D;
        Mon, 24 May 2021 11:18:40 -0700 (PDT)
Received: from [10.57.73.64] (unknown [10.57.73.64])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 45FC53F73B;
        Mon, 24 May 2021 11:18:39 -0700 (PDT)
From:   Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH 3/6] vfio: remove the unused mdev iommu hook
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Will Deacon <will@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
References: <YKJf7mphTHZoi7Qr@8bytes.org> <20210517123010.GO1096940@ziepe.ca>
 <YKJnPGonR+d8rbu/@8bytes.org> <20210517133500.GP1096940@ziepe.ca>
 <YKKNLrdQ4QjhLrKX@8bytes.org> <131327e3-5066-7a88-5b3c-07013585eb01@arm.com>
 <20210519180635.GT1096940@ziepe.ca>
 <MWHPR11MB1886C64EAEB752DE9E1633358C2B9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210519232459.GV1096940@ziepe.ca>
 <1d154445-f762-1147-0b8c-6e244e7c66dc@arm.com>
 <20210520143420.GW1096940@ziepe.ca>
Message-ID: <9d34b473-3a37-5de2-95f8-b508d85e558c@arm.com>
Date:   Mon, 24 May 2021 19:18:33 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210520143420.GW1096940@ziepe.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-05-20 15:34, Jason Gunthorpe wrote:
> On Thu, May 20, 2021 at 03:13:55PM +0100, Robin Murphy wrote:
> 
>> By "mdev-like" I mean it's very similar in shape to the general SIOV-style
>> mediated device concept - i.e. a physical device with an awareness of
>> operating on multiple contexts at once, using a Substream ID/PASID for each
>> one - but instead of exposing control of the contexts to anyone else, they
>> remain hidden behind the kernel driver which already has its own abstracted
>> uAPI, so overall it ends up as more just internal housekeeping than any
>> actual mediation. We were looking at the mdev code for inspiration, but
>> directly using it was never the plan.
> 
> Well:
>   - Who maps memory into the IOASID (ie the specific sub stream id)?

Sorry to nitpick, but I think it's important to get terminology right 
here to avoid unnecessary misunderstanding. You can't map memory into an 
address space ID; it's just a number. Ultimately that identifier ends up 
pointing at some actual address space, and most of the current work is 
focused on the case of that address space being provided by an mm where 
things are mapped implicitly by a userspace process; I care about the 
case of it being provided by an iommu_domain where things are mapped 
explicitly by a kernel driver. I would be extremely wary of creating 
some new third *address space* abstraction.

>   - What memory must be mapped?
>   - Who triggers DMA to this memory?

It's a pretty typical DMA flow, as far as I understand. Userspace 
allocates some buffers (in this case, via the kernel driver, but in 
general I'm not sure it makes much difference), puts data in the 
buffers, issues an ioctl to say "process this data", and polls for 
completion; the kernel driver makes sure the buffers are mapped in the 
device address space (at allocation time in this case, but in general I 
assume it could equally be done at request time for user pages), and 
deals with scheduling requests onto the hardware. I understand this 
interface is already deployed in a driver stack which supports a single 
client process at once; extending the internals to allow requests from 
multiple processes to run in parallel using Substream IDs for isolation 
is the future goal. The interface itself shouldn't change, only some 
internal arbitration details.

>> The driver simply needs to keep track of the domains and PASIDs -
>> when a process submits some work, it can look up the relevant
>> domain, iommu_map() the user pages to the right addresses, dma_map()
>> them for coherency, then poke in the PASID as part of scheduling the
>> work on the physical device.
> 
> If you are doing stuff like this then the /dev/ioasid is what you
> actually want. The userprocess can create its own IOASID, program the
> io page tables for that IOASID to point to pages as it wants and then
> just hand over a fully instantiated io page table to the device
> driver.

No. In our case, the device does not need to operate on userspace 
addresses, in fact quite the opposite. There may need to be additional 
things mapped into the device address space which are not, and should 
not be, visible to userspace. There are also some quite weird criteria 
for optimal address space layout which frankly are best left hidden 
inside the kernel driver. Said driver is already explicitly managing its 
own iommu_domain in the same manner as various DRM drivers and others, 
so growing that to multiple parallel domains really isn't a big leap. 
Moving any of this responsibility into userspace would be unwanted and 
unnecessary upheaval.

> What you are describing is the literal use case of /dev/ioasid - a
> clean seperation of managing the IOMMU related parts through
> /dev/ioasid and the device driver itself is only concerned with
> generating device DMA that has the proper PASID/substream tag.
> 
> The entire point is to not duplicate all the iommu code you are
> describing having written into every driver that just wants an IOASID.
> 
> In particular, you are talking about having a substream capable device
> and driver but your driver's uAPI is so limited it can't address the
> full range of substream configurations:
> 
>   - A substream pointing at a SVA
>   - A substream pointing a IO page table nested under another
>   - A substream pointing at an IOMMU page table shared by many users
> 
> And more. Which is bad.

None of which make much if any sense for the way this device and the 
rest of its software stack are designed to work, though. Anyway, the 
actual uAPI in question is essentially just chucking buffer fds about in 
a very abstract manner, so I don't see that it has any relevance here. 
We're talking about a kernel driver *internally* managing how it chooses 
to expose the buffers backing those fds to the hardware. SVA has no 
meaning in that context (there's nothing to share), and I don't even 
understand your second case, but attaching multiple SSIDs to a single 
domain is absolutely something which _could_ be done, there's just zero 
point in a single driver doing that privately when it could simply run 
the relevant jobs under the same SSID instead.

>>> We already talked about this on the "how to use PASID from the kernel"
>>> thread.
>>
>> Do you have a pointer to the right thread so I can catch up? It's not the
>> easiest thing to search for on lore amongst all the other PASID-related
>> business :(
> 
> Somewhere in here:
> 
> http://lore.kernel.org/r/20210517143758.GP1002214@nvidia.com

Thanks, along with our discussion here that kind of confirms my concern. 
Assuming IOASID can wrap up a whole encapsulated thing which is either 
SVA or IOMMU_DOMAIN_DMA is too much of an overabstraction. There 
definitely *are* uses for IOMMU_DOMAIN_DMA - say you want to put some 
SIOV ADIs to work for the host kernel using their regular 
non-IOMMU-aware driver - but there will also be cases for 
IOMMU_DOMAIN_UNMANAGED, although I do mostly expect those to be SoC 
devices whose drivers are already IOMMU-aware and just want to be so at 
a finer-grained level, not PCI devices. Even IOMMU_DOMAIN_PASSTHROUGH 
for IOASIDs _could_ be doable if a sufficiently compelling reason came 
along. I agree that SVA on init_mm is pretty bonkers, but don't get too 
hung up on the DMA API angle which is really orthogonal - passthrough 
domains with dma-direct ops have been working fine for years.

>> FWIW my non-SVA view is that a PASID is merely an index into a set of
>> iommu_domains, and in that context it doesn't even really matter *who*
>> allocates them, only that the device driver and IOMMU driver are in sync :)
> 
> Right, this is where /dev/ioasid is going.
> 
> However it gets worked out at the kAPI level in the iommu layer the
> things you asked for are intended to be solved, and lots more.

Great! It feels like one of the major things will be that, at least 
without major surgery to the DMA API, most of the use-cases will likely 
still need a struct device wrapped around the IOASID. I think the 
particular one I want to solve is actually the odd one out in that it 
doesn't really care, and could be made to work either way.

Thanks,
Robin.
