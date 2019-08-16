Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 663918FFFA
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2019 12:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbfHPKX7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Aug 2019 06:23:59 -0400
Received: from foss.arm.com ([217.140.110.172]:54680 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726839AbfHPKX7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Aug 2019 06:23:59 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B72A928;
        Fri, 16 Aug 2019 03:23:57 -0700 (PDT)
Received: from [10.1.196.133] (e112269-lin.cambridge.arm.com [10.1.196.133])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 621223F706;
        Fri, 16 Aug 2019 03:23:56 -0700 (PDT)
Subject: Re: [UNVERIFIED SENDER] Re: [PATCH 0/9] arm64: Stolen time support
To:     Alexander Graf <graf@amazon.com>, Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        linux-doc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
References: <20190802145017.42543-1-steven.price@arm.com>
 <20190803190522.5fec8f7d@why> <6789f477-8ab5-cc54-1ad2-8627917b07c9@arm.com>
 <8ca5c106-7c12-4c6e-6d81-a90f281a9894@amazon.com>
 <8636i3omnd.wl-maz@kernel.org>
 <bda4e0f7-e5f4-32af-e998-00b6240b5260@amazon.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <4e811196-fa57-f523-8df6-0243886fb83a@arm.com>
Date:   Fri, 16 Aug 2019 11:23:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <bda4e0f7-e5f4-32af-e998-00b6240b5260@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/08/2019 15:52, Alexander Graf wrote:
> 
> 
> On 14.08.19 16:19, Marc Zyngier wrote:
>> On Wed, 14 Aug 2019 14:02:25 +0100,
>> Alexander Graf <graf@amazon.com> wrote:
>>>
>>>
>>>
>>> On 05.08.19 15:06, Steven Price wrote:
>>>> On 03/08/2019 19:05, Marc Zyngier wrote:
>>>>> On Fri,  2 Aug 2019 15:50:08 +0100
>>>>> Steven Price <steven.price@arm.com> wrote:
>>>>>
>>>>> Hi Steven,
>>>>>
>>>>>> This series add support for paravirtualized time for arm64 guests and
>>>>>> KVM hosts following the specification in Arm's document DEN 0057A:
>>>>>>
>>>>>> https://developer.arm.com/docs/den0057/a
>>>>>>
>>>>>> It implements support for stolen time, allowing the guest to
>>>>>> identify time when it is forcibly not executing.
>>>>>>
>>>>>> It doesn't implement support for Live Physical Time (LPT) as there
>>>>>> are
>>>>>> some concerns about the overheads and approach in the above
>>>>>> specification, and I expect an updated version of the
>>>>>> specification to
>>>>>> be released soon with just the stolen time parts.
>>>>>
>>>>> Thanks for posting this.
>>>>>
>>>>> My current concern with this series is around the fact that we
>>>>> allocate
>>>>> memory from the kernel on behalf of the guest. It is the first example
>>>>> of such thing in the ARM port, and I can't really say I'm fond of it.
>>>>>
>>>>> x86 seems to get away with it by having the memory allocated from
>>>>> userspace, why I tend to like more. Yes, put_user is more
>>>>> expensive than a straight store, but this isn't done too often either.
>>>>>
>>>>> What is the rational for your current approach?
>>>>
>>>> As I see it there are 3 approaches that can be taken here:
>>>>
>>>> 1. Hypervisor allocates memory and adds it to the virtual machine. This
>>>> means that everything to do with the 'device' is encapsulated behind
>>>> the
>>>> KVM_CREATE_DEVICE / KVM_[GS]ET_DEVICE_ATTR ioctls. But since we want
>>>> the
>>>> stolen time structure to be fast it cannot be a trapping region and has
>>>> to be backed by real memory - in this case allocated by the host
>>>> kernel.
>>>>
>>>> 2. Host user space allocates memory. Similar to above, but this time
>>>> user space needs to manage the memory region as well as the usual
>>>> KVM_CREATE_DEVICE dance. I've no objection to this, but it means
>>>> kvmtool/QEMU needs to be much more aware of what is going on (e.g. how
>>>> to size the memory region).
>>>
>>> You ideally want to get the host overhead for a VM to as little as you
>>> can. I'm not terribly fond of the idea of reserving a full page just
>>> because we're too afraid of having the guest donate memory.
>>
>> Well, reduce the amount of memory you give to the guest by one page,
>> and allocate that page to the stolen time device. Problem solved!
>>
>> Seriously, if you're worried about the allocation of a single page,
>> you should first look at how many holes we have in the vcpu structure,
>> for example (even better, with the 8.4 NV patches applied). Just
>> fixing that would give you that page back *per vcpu*.
> 
> I'm worried about additional memory slots, about fragmenting the
> cachable guest memory regions, about avoidable HV taxes.
> 
> I think we need to distinguish here between the KVM implementation and
> the hypervisor/guest interface. Just because in KVM we can save overhead
> today doesn't mean that the HV interface should be built around the
> assumption that "memory is free".

The HV interface just requires that the host provides some memory for
the structures to live in. The memory can be adjacent (or even within)
the normal memory of the guest. The only requirement is that the guest
isn't told to use this memory for normal allocations (i.e. it should
either be explicitly reserved or just not contained within the normal
memory block).

>>
>>>> 3. Guest kernel "donates" the memory to the hypervisor for the
>>>> structure. As far as I'm aware this is what x86 does. The problems I
>>>> see
>>>> this approach are:
>>>>
>>>>    a) kexec becomes much more tricky - there needs to be a disabling
>>>> mechanism for the guest to stop the hypervisor scribbling on memory
>>>> before starting the new kernel.
>>>
>>> I wouldn't call "quiesce a device" much more tricky. We have to do
>>> that for other devices as well today.
>>
>> And since there is no standard way of doing it, we keep inventing
>> weird and wonderful ways of doing so -- cue the terrible GICv3 LPI
>> situation, and all the various hacks to keep existing IOMMU mappings
>> around across firmware/kernel handovers as well as kexec.
> 
> Well, the good news here is that we don't have to keep it around ;).
> 
>>
>>>
>>>>    b) If there is more than one entity that is interested in the
>>>> information (e.g. firmware and kernel) then this requires some form of
>>>> arbitration in the guest because the hypervisor doesn't want to have to
>>>> track an arbitrary number of regions to update.
>>>
>>> Why would FW care?
>>
>> Exactly. It doesn't care. Not caring means it doesn't know about the
>> page the guest has allocated for stolen time, and starts using it for
>> its own purposes. Hello, memory corruption. Same thing goes if you
>> reboot into a non stolen time aware kernel.
> 
> If you reboot, you go via the vcpu reset path which clears the map, no?
> Same goes for FW entry. If you enter firmware that does not set up the
> map, you never see it.

Doing this per-vcpu implies you are probably going to have to allocate
an entire page per vcpu. Because it's entirely possible for a guest to
reset an individual vcpu. Or at the least there's some messy reference
counting going on here.

Having a region of memory provided by the host means the structures can
be packed and there's nothing to be done in the reset path.

>>
>>>
>>>>    c) Performance can suffer if the host kernel doesn't have a suitably
>>>> aligned/sized area to use. As you say - put_user() is more expensive.
>>>
>>> Just define the interface to always require natural alignment when
>>> donating a memory location?
>>>
>>>> The structure is updated on every return to the VM.
>>>
>>> If you really do suffer from put_user(), there are alternatives. You
>>> could just map the page on the registration hcall and then leave it
>>> pinned until the vcpu gets destroyed again.
>>
>> put_user() should be cheap enough. It is one of the things we tend to
>> optimise anyway. And yes, worse case, we pin the page.
>>
>>>
>>>> Of course x86 does prove the third approach can work, but I'm not sure
>>>> which is actually better. Avoid the kexec cancellation requirements was
>>>> the main driver of the current approach. Although many of the
>>>
>>> I really don't understand the problem with kexec cancellation. Worst
>>> case, let guest FW set it up for you and propagate only the address
>>> down via ACPI/DT. That way you can mark the respective memory as
>>> reserved too.
>>
>> We already went down that road with the LPI hack. I'm not going there
>> again if we can avoid it. And it turn out that we can. Just allocate
>> the stolen time page as a separate memblock, give it to KVM for that
>> purpose.
>>
>> Your suggestion of letting the guest firmware set something up only
>> works if whatever you're booting after that understands it. If it
>> doesn't, you're screwed.
> 
> Why? For UEFI, mark the region as reserved in the memory map. For DT,
> just mark it straight on reserved.
> 
> That said, I'm not advocating for doing it in the FW. I think this can
> be solved really easily with a simple guest driver to enable and a vcpu
> reset hook to disable the map.
> 
>>
>>> But even with a Linux only mechanism, just take a look at
>>> arch/x86/kernel/kvmclock.c. All they do to remove the map is to hook
>>> into machine_crash_shutdown() and machine_shutdown().
>>
>> I'm not going to take something that is Linux specific. It has to work
>> for all guests, at all times, whether they know about the hypervisor
>> service or not.
> 
> If they don't know about the HV service, they don't register the writer,
> so they don't see corruption.
> 
> If they know about the HV service and they don't support kexec, they
> don't have to worry because a vcpu reset should also clear the map.
> 
> If they do support kexec, they already have a mechanism to quiesce devices.
> 
> So I don't understand how this is Linux specific? The question was Linux
> specific, so I answered with precedence to show that disabling on kexec
> is not all that hard :).

My concern is more around a something like Jailhouse as a
guest-hypervisor. There Linux gives up CPUs to run another OS. This
hand-off of a CPU is much easier if there's just a structure in memory
somewhere which doesn't move.

The kexec case like you say can be handled as a device to quiesce.

I don't think either scheme is unworkable, but I do think getting the
host to provide the memory is easier for both guest and host. Marc had a
good point that getting user space to allocate the memory is probably
preferable to getting the host kernel to do so, so I'm reworking the
code to do that.

Steve
