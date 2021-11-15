Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82397451C92
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 01:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343640AbhKPAVC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 19:21:02 -0500
Received: from foss.arm.com ([217.140.110.172]:32992 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348335AbhKOVB1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 16:01:27 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0A3896D;
        Mon, 15 Nov 2021 12:58:31 -0800 (PST)
Received: from [10.57.82.45] (unknown [10.57.82.45])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 81A5F3F70D;
        Mon, 15 Nov 2021 12:58:28 -0800 (PST)
Message-ID: <ab3ae3d1-c4d7-251a-fecc-d21f6b9d87a5@arm.com>
Date:   Mon, 15 Nov 2021 20:58:19 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 03/11] PCI: pci_stub: Suppress kernel DMA ownership
 auto-claiming
Content-Language: en-GB
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Ashok Raj <ashok.raj@intel.com>, kvm@vger.kernel.org,
        rafael@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>
References: <20211115020552.2378167-1-baolu.lu@linux.intel.com>
 <20211115020552.2378167-4-baolu.lu@linux.intel.com>
 <YZJe1jquP+osF+Wn@infradead.org> <20211115133107.GB2379906@nvidia.com>
 <495c65e4-bd97-5f29-d39b-43671acfec78@arm.com>
 <20211115161756.GP2105516@nvidia.com>
 <e9db18d3-dea3-187a-d58a-31a913d95211@arm.com>
 <20211115192212.GQ2105516@nvidia.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20211115192212.GQ2105516@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-11-15 19:22, Jason Gunthorpe wrote:
> On Mon, Nov 15, 2021 at 05:54:42PM +0000, Robin Murphy wrote:
>> On 2021-11-15 16:17, Jason Gunthorpe wrote:
>>> On Mon, Nov 15, 2021 at 03:14:49PM +0000, Robin Murphy wrote:
>>>
>>>>> If userspace has control of device A and can cause A to issue DMA to
>>>>> arbitary DMA addresses then there are certain PCI topologies where A
>>>>> can now issue peer to peer DMA and manipulate the MMMIO registers in
>>>>> device B.
>>>>>
>>>>> A kernel driver on device B is thus subjected to concurrent
>>>>> manipulation of the device registers from userspace.
>>>>>
>>>>> So, a 'safe' kernel driver is one that can tolerate this, and an
>>>>> 'unsafe' driver is one where userspace can break kernel integrity.
>>>>
>>>> You mean in the case where the kernel driver is trying to use device B in a
>>>> purely PIO mode, such that userspace might potentially be able to interfere
>>>> with data being transferred in and out of the kernel?
>>>
>>> s/PIO/MMIO, but yes basically. And not just data trasnfer but
>>> userspace can interfere with the device state as well.
>>
>> Sure, but unexpected changes in device state could happen for any number of
>> reasons - uncorrected ECC error, surprise removal, etc. - so if that can
>> affect "kernel integrity" I'm considering it an independent problem.
> 
> There is a big difference in my mind between a device/HW attacking the
> kernel and userspace can attack the kernel. They are both valid cases,
> and I know people are also working on the device/HW attacks the kernel
> problem.
> 
> This series is only about user attacks kernel.

Indeed, I was just commenting that if there's any actual attack surface 
for "user makes device go wrong" then that's really a whole other issue. 
I took "device state" to mean any state *other than* what could be used 
to observe and/or subvert the kernel's normal operation of the device. 
Say it's some kind of storage device with some global state bit that 
could be flipped to disable encryption on blocks being written such that 
the medium could be attacked offline later, that's still firmly in my 
"interfering with data transfer" category.

>>>> Perhaps it's not so clear to put that under a notion of "DMA
>>>> ownership", since device B's DMA is irrelevant and it's really much
>>>> more equivalent to /dev/mem access or mmaping BARs to userspace
>>>> while a driver is bound.
>>>
>>> It is DMA ownership because device A's DMA is what is relevant
>>> here. device A's DMA compromises device B. So device A asserts it has
>>> USER ownership for DMA.
>>>
>>> Any device in a group with USER ownership is incompatible with a
>>> kernel driver.
>>
>> I can see the argument from that angle, but you can equally look at it
>> another way and say that a device with kernel ownership is incompatible with
>> a kernel driver, if userspace can call write() on "/sys/devices/B/resource0"
>> such that device A's kernel driver DMAs all over it. Maybe that particular
>> example lands firmly under "just don't do that", but I'd like to figure out
>> where exactly we should draw the line between "DMA" and "ability to mess
>> with a device".
> 
> The above scenarios are already blocked by the kernel with
> LOCKDOWN_DEV_MEM - yes there are historical ways to violate kernel
> integrity, and these days they almost all have mitigation. I would
> consider any kernel integrity violation to be a bug today if
> LOCKDOWN_INTEGRITY_MAX is enabled.
> 
> I don't know why you bring this up?

Because as soon as anyone brings up "security" I'm not going to blindly 
accept the implicit assumption that VFIO is the only possible way to get 
one device to mess with another. That was just a silly example in the 
most basic terms, and obviously I don't expect well-worn generic sysfs 
interfaces to be a genuine threat, but how confident are you that no 
other subsystem- or driver-level interfaces past present and future can 
ever be tricked into p2p DMA?

>>> That has a nice symmetry with iommu_attach_device() already requiring
>>> that the group has a single device. For a driver to use these APIs it
>>> must ensure security, one way or another.
>>
>> iommu_attach_device() is supposed to be deprecated and eventually going
>> away; I wouldn't look at it too much.
> 
> What is the preference then? This is the only working API today,
> right?

I believe the intent was that everyone should move to 
iommu_group_get()/iommu_attach_group() - precisely *because* 
iommu_attach_device() can't work sensibly for multi-device groups.

>> Indeed I wasn't imagining it changing any ownership, just preventing a group
>> from being attached to a non-default domain if it contains devices bound to
>> different incompatible drivers.
> 
> So this could solve just the domain/DMA API problem, but it leaves the
> MMIO peer-to-peer issue unsolved, and it gives no tools to solve it in
> a layered way.
> 
> This seems like half an idea, do you have a solution for the rest?

Tell me how the p2p DMA issue can manifest if device A is prohibited 
from attaching to VFIO's unmanaged domain while device B still has a 
driver bound, and thus would fail to be assigned to userspace in the 
first place. And conversely if non-VFIO drivers are still prevented from 
binding to device B while device A remains attached to the VFIO domain.

(Bonus: if so, also tell me how that wouldn't disprove your initial 
argument anyway)

> The concept of DMA USER is important here, and it is more than just
> which domain is attached.

Tell me how a device would be assigned to userspace while its group is 
still attached to a kernel-managed default domain.

As soon as anyone calls iommu_attach_group() - or indeed 
iommu_attach_device() if more devices may end up hotplugged into the 
same group later - *that's* when the door opens for potential subversion 
of any kind, without ever having to leave kernel space.

>> Basically just taking the existing check that VFIO tries to enforce
>> and formalising it into the core API. It's not too far off what we
>> already have around changing the default domain type, so there seems
>> to be room for it to all fit together quite nicely.
> 
> VFIO also has logic related to the file

Yes, because unsurprisingly VFIO code is tailored for the specific case 
of VFIO usage rather than anything more general.

>> Tying it in to userspace and FDs just muddies the water far more
>> than necessary.
> 
> It isn't muddying the water, it is providing common security code that
> is easy to undertand.
> 
> *Which* userspace FD/process owns the iommu_group is important
> security information because we can't have process A do DMA attacks on
> some other process B.

Tell me how a single group could be attached to two domains representing 
two different process address spaces at once.

In case this concept wasn't as clear as I thought, which seems to be so:

                  | dev->iommu_group->domain | dev->driver
------------------------------------------------------------
DMA_OWNER_NONE   |          default         |   unbound
DMA_OWNER_KERNEL |          default         |    bound
DMA_OWNER_USER   |        non-default       |    bound

It's literally that simple. The information's already there. And in a 
more robust form to boot, given that, as before, "user" ownership may 
still exist entirely within kernel space.

Thanks,
Robin.
