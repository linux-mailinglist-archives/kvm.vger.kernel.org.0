Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25A1B6EF434
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 14:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240829AbjDZMYc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 08:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240277AbjDZMYa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 08:24:30 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 99ED72D4D
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 05:24:28 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3CCFD4B3;
        Wed, 26 Apr 2023 05:25:12 -0700 (PDT)
Received: from [10.57.22.9] (unknown [10.57.22.9])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E3A383F5A1;
        Wed, 26 Apr 2023 05:24:26 -0700 (PDT)
Message-ID: <59354284-fd24-6e80-7ce7-87432d016842@arm.com>
Date:   Wed, 26 Apr 2023 13:24:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: RMRR device on non-Intel platform
Content-Language: en-GB
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>
Cc:     Nicolin Chen <nicolinc@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Marc Zyngier <maz@kernel.org>
References: <6cce1c5d-ab50-41c4-6e62-661bc369d860@arm.com>
 <20230420084906.2e4cce42.alex.williamson@redhat.com>
 <fd324213-8d77-cb67-1c52-01cd0997a92c@arm.com>
 <20230420154933.1a79de4e.alex.williamson@redhat.com>
 <ZEJ73s/2M4Rd5r/X@nvidia.com> <0aa4a107-57d0-6e5b-46e5-86dbe5b3087f@arm.com>
 <ZEKFdJ6yXoyFiHY+@nvidia.com> <fe7e20e5-9729-248d-ee03-c8b444a1b7c0@arm.com>
 <ZELOqZliiwbG6l5K@nvidia.com> <a2616348-3517-27a7-17a0-6628b56f6fad@arm.com>
 <ZEf4oef6gMevtl7w@nvidia.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <ZEf4oef6gMevtl7w@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023-04-25 16:58, Jason Gunthorpe wrote:
> On Tue, Apr 25, 2023 at 03:48:11PM +0100, Robin Murphy wrote:
>> On 2023-04-21 18:58, Jason Gunthorpe wrote:
>>> On Fri, Apr 21, 2023 at 06:22:37PM +0100, Robin Murphy wrote:
>>>
>>>> I think a slightly more considered and slightly less wrong version of that
>>>> idea is to mark it as IOMMU_RESV_MSI, and special-case direct-mapping those
>>>> on Arm (I believe it would technically be benign to do on x86 too, but might
>>>> annoy people with its pointlessness). However...
>>>
>>> I'd rather have a IOMMU_RESV_MSI_DIRECT and put the ARM special case
>>> in ARM code..
>>
>> Maybe, but it's still actually broken either way, because how do you get
>> that type into the VM? Firmware can't encode that a particular RMR
>> represents the special magic hack for IOMMUFD, so now the SMMU driver needs
>> to somehow be aware when it's running in a VM offering nested translation
>> and do some more magic to inject the appropriate region, and it's all
>> just... no.
> 
> Er, I figured ARM had sorted this out somehow :(
> 
> Eric, do you know anything about this? Where did you setup the 1:1 map
> in the VM in your series?
> 
> So you are saying, the basic problem statement, is that the ACPI table
> that describes the ITS direct mapping in the VM is supposed to be
> interpreted by the SMMU driver as "memory must be iommu mapped 1:1 at
> all times and is possibly dangerous enough to block userspace access
> to the device, like Intel does" ?

In the case of IORT RMRs, all firmware can describe is regions of memory 
which must be direct-mapped, along with some attributes for *how* they 
are to be mapped. It cannot (and frankly should not) convey any 
additional OS-specific special meaning.

> This isn't end of the world bad, it just means that VFIO will not work
> in ARM guests under this interrupt model. Sad, and something to fix,
> but we can still cover alot of ground..
> 
> Maybe a GICv5 can correct it..

Correct what? If Linux chooses to use the existing GICv3 architecture in 
an arse-backwards manner to opaquely emulate interrupts with other 
interrupts instead of actually virtualising them, I'd say that's hardly 
the architecture's fault. Given how much many of our partners do care 
about virtualisation performance, I'm pretty confident the GIC/SMMU 
architects aren't going to be spending time on future extensions for 
making horribly inefficient interrupt emulation any easier to implement.

The primary purpose of the Interrupt Translation Service is to 
*translate* interrupts. In combination with an SMMU, it allows a VM to 
program a device with a virtualised address and EventID such that when 
the device signals an interrupt by writing that EventID to that address, 
the SMMU translates the address to direct the write to the appropriate 
physical ITS, then the ITS translates the EventID into a physical LPI, 
which may then be handled directly or stuffed back into the VM as the 
appropriate virtual interrupt. The nature of these translations is such 
that the host has no need to mediate access to the device itself.

>>> Frankly, I think something whent wrong with the GICv4 design. A purely
>>> virtualization focused GIC should not have continued to rely on the
>>> hypervisor trapping of the MSI-X writes. The guest should have had a
>>> real data value and a real physical ITS page.

A real *virtual* ITS page (IPA/GPA, not PA) as above, because the Arm 
system architecture does not define a fixed address map thus that is 
free to be virtualised as well, but otherwise, yes, indeed it should, 
and it could, on both GICv3 and AMD/Intel IRQ remapping. Why isn't Linux 
letting VMMs do that?

Fair enough for VFIO, since that existed long before any architectural 
MSI support on Arm, and has crusty PCI/X legacy on x86 to deal with too, 
but IOMMUFD is a new thing for modern use-cases on modern hardware. In 
today's PCIe world why would we choose to focus on banging the 
legacy-shaped peg into the modern-interrupt-remapping-shaped hole with 
our foreheads, then complain that it hurts, rather than design the new 
thing to use the modern functionality as intended, and have something 
that can work really well for what users are actually going to want to do?

>> ...I believe the remaining missing part is a UAPI for the VMM to ask the
>> host kernel to configure a "physical" vLPI for a given device and EventID,
>> at the point when its vITS emulation is handling the guest's configuration
>> command. With that we would no longer have to rewrite the MSI payload
>> either, so can avoid trapping the device's MSI-X capability at all, and the
>> VM could actually have non-terrible interrupt performance.
> 
> Yes.. More broadly I think we'd need to allow the vGIC code to
> understand that it has complete control over a SID, and like we are
> talking about for SMMU a vSID mapping as well.

Marc, any thoughts on how much of this is actually missing from the MSI 
domain infrastructure today? I'm guessing the main thing is needing some 
sort of msi_domain_alloc_virq() API so that the caller can provide the 
predetermined message data to replace the normal compose/write flow - 
beyond that I think I can see a tentative idea of how it could then be 
plumbed through the generic msi_alloc_info and the ITS domain. The x86 
irq_remapping domains scare me, though, so I'll say right now I'm not 
going there :)

Thanks,
Robin.

> This would have to replace the eventfd based hookup we have now.
> 
> I really want to avoid opening this can of worms because it is
> basically iommufd all over again just irq focused :(
> 
>> Except GCC says __builtin_ctzl(0) is undefined, so although I'd concur that
>> the chances of nasal demons at the point of invoking __ffs() are
>> realistically quite low, I don't fancy arguing that with the static checker
>> brigade. So by the time we've appeased them with additional checks,
>> initialisations, etc., we'd have basically the same overhead as running 0
>> iterations of another for loop (the overwhelmingly common case anyway), but
>> in more lines of code, with a more convoluted flow. All of which leads me to
>> conclude that "number of times we walk a usually-empty list in a one-off
>> slow path" is not in fact the most worthwhile thing to optimise for ;)
> 
> Heh, well fair enough, we do have a UBSAN that might trip on this. Lu
> can correct it
> 
> Jason
