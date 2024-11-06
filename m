Return-Path: <kvm+bounces-31038-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ED1699BF851
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 22:05:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ABC3C28303C
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 21:05:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1699520C49C;
	Wed,  6 Nov 2024 21:05:36 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E38E81D6DB7;
	Wed,  6 Nov 2024 21:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730927135; cv=none; b=D26NCiTnBPZdTnOK6IYJQIwu1QMNi7YUiQs2/rRDR+tMXLauLhav3/LZdXXKTr5VpmYdu7dPCC0xSuwV7eceRvYJzSq5njue8c5dPtosKst3eGihHex9OmtcKhMxTNVVBnSyXRneG5DTvzOD6sIf1Yoyzqajj964lDtIGaCbnJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730927135; c=relaxed/simple;
	bh=V5zGA+7TTCtQX65iL5fAXX3VQZwwLwuD0wSMEpDbyLo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QbZ5sYhnTk7WL3Hum6h7sGSpdAI1iD1zxvecBlIxArfhzhAAnvoP4fd66hgPZqPCe4tyVWwzgBas5A85g5YqkMpCq6o8x1QuYevZ5zr+oGkK9c4DkXPbnJxyg36V4YIDBM62NkNsRBxQ4nVfnyWjTrbrdyzrFYGyCje/NFNuYLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C19D7497;
	Wed,  6 Nov 2024 13:06:01 -0800 (PST)
Received: from [10.57.90.5] (unknown [10.57.90.5])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 920813F66E;
	Wed,  6 Nov 2024 13:05:27 -0800 (PST)
Message-ID: <2a0e69e3-63ba-475b-a5a9-0863ad0f2bf8@arm.com>
Date: Wed, 6 Nov 2024 21:05:26 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/12] iommu/arm-smmu-v3: Support IOMMU_GET_HW_INFO via
 struct arm_smmu_hw_info
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Will Deacon <will@kernel.org>, acpica-devel@lists.linux.dev,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
 Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 Lorenzo Pieralisi <lpieralisi@kernel.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Robert Moore <robert.moore@intel.com>, Sudeep Holla <sudeep.holla@arm.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Donald Dutile <ddutile@redhat.com>, Eric Auger <eric.auger@redhat.com>,
 Hanjun Guo <guohanjun@huawei.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Jerry Snitselaar <jsnitsel@redhat.com>, Moritz Fischer <mdf@kernel.org>,
 Michael Shavit <mshavit@google.com>, Nicolin Chen <nicolinc@nvidia.com>,
 patches@lists.linux.dev, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
 Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
 Mostafa Saleh <smostafa@google.com>
References: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
 <5-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
 <20241104114723.GA11511@willie-the-truck> <20241104124102.GX10193@nvidia.com>
 <8a5940b0-08f3-48b1-9498-f09f0527a964@arm.com>
 <20241106180531.GA520535@nvidia.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <20241106180531.GA520535@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024-11-06 6:05 pm, Jason Gunthorpe wrote:
> On Wed, Nov 06, 2024 at 04:37:53PM +0000, Robin Murphy wrote:
>> On 2024-11-04 12:41 pm, Jason Gunthorpe wrote:
>>> On Mon, Nov 04, 2024 at 11:47:24AM +0000, Will Deacon wrote:
>>>>> +/**
>>>>> + * struct iommu_hw_info_arm_smmuv3 - ARM SMMUv3 hardware information
>>>>> + *                                   (IOMMU_HW_INFO_TYPE_ARM_SMMUV3)
>>>>> + *
>>>>> + * @flags: Must be set to 0
>>>>> + * @__reserved: Must be 0
>>>>> + * @idr: Implemented features for ARM SMMU Non-secure programming interface
>>>>> + * @iidr: Information about the implementation and implementer of ARM SMMU,
>>>>> + *        and architecture version supported
>>>>> + * @aidr: ARM SMMU architecture version
>>>>> + *
>>>>> + * For the details of @idr, @iidr and @aidr, please refer to the chapters
>>>>> + * from 6.3.1 to 6.3.6 in the SMMUv3 Spec.
>>>>> + *
>>>>> + * User space should read the underlying ARM SMMUv3 hardware information for
>>>>> + * the list of supported features.
>>>>> + *
>>>>> + * Note that these values reflect the raw HW capability, without any insight if
>>>>> + * any required kernel driver support is present. Bits may be set indicating the
>>>>> + * HW has functionality that is lacking kernel software support, such as BTM. If
>>>>> + * a VMM is using this information to construct emulated copies of these
>>>>> + * registers it should only forward bits that it knows it can support.
>>
>> But how *is* a VMM supposed to know what it can support?
> 
> I answered a related question to Mostafa with an example:
> 
> https://lore.kernel.org/linux-iommu/20240903235532.GJ3773488@nvidia.com/
> 
> "global" capabilities that are enabled directly from the CD entry
> would follow the pattern.
> 
>> Are they all expected to grovel the host devicetree/ACPI tables and
>> maintain their own knowledge of implementation errata to understand
>> what's actually usable?
> 
> No, VMMs are expected to only implement base line features we have
> working today and not blindly add new features based only HW registers
> reported here.
> 
> Each future capability we want to enable at the VMM needs an analysis:
> 
>   1) Does it require kernel SW changes, ie like BTM? Then it needs a
>      kernel_capabilities bit to say the kernel SW exists
>   2) Does it require data from ACPI/DT/etc? Then it needs a
>      kernel_capabilities bit
>   3) Does it need to be "turned on" per VM, ie with a VMS enablement?
>      Then it needs a new request flag in ALLOC_VIOMMU
>   4) Otherwise it can be read directly from the idr[] array
> 
> This is why the comment above is so stern that the VMM "should only
> forward bits that it knows it can support".

So... you're saying this patch is in fact broken, or at least uselessly 
incomplete, since VMMs aren't allowed to emulate a vSMMU at all without 
first consulting some other interface which does not exist? Great.

>> S2 tables it its own business. AFAICS, unless the VMM wants to do some
>> fiddly CD shadowing, it's going to be kinda hard to prevent the SMMU seeing
>> a guest CD with CD.HA and/or CD.HD set if the guest expects S1 HTTU to work.
> 
> If the VMM wrongly indicates HTTU support to the VM, because it
> wrongly inspected those bits in the idr report, then it is just
> broken.

What do you mean? We could have a system right now where the hardware is 
configured with SMMU_IDR0.HTTU=2, but it turned out that atomics were 
broken in the interconnect so firmware sets the IORT "HTTU override" 
field is set to 0. We know about that in the kernel, but all a VMM sees 
is iommu_hw_info_arm_smmuv3.idr[0] indicating HTTU=2. If it is "broken" 
to take the only information available at face value, assume HTTU is 
available, and reflect that in a vSMMU interface, then what is the 
correct thing to do, other than to not dare emulate a vSMMU at all, in 
fear of a sternly worded comment?

>> I would say it does. Advertising a feature when we already know it's not
>> usable at all puts a non-trivial and unnecessary burden on the VMM and VM to
>> then have to somehow derive that information from other sources, at the risk
>> of being confused by unexpected behaviour if they don't.
> 
> That is not the purpose here, the register report is not to be used as
> "advertising features". It describes details of the raw HW that the
> VMM may need to use *some* of the fields.
> 
> There are quite a few fields that fit #4 today: OAS, VAX, GRAN, BBML,
> CD2L, etc.
> 
> Basically we will pass most of the bits and mask a few. If we get the
> masking wrong and pass something we shouldn't, then we've improved
> nothing compared to this proposal. I think we are likely to get the
> masking wrong :)

Seriously? A simple inverse of the feature detection the kernel driver 
already does for its own needs, implemented once in the same place, is hard?

Compared to maintaining the exact same information within the driver but 
in some new different form, and also maintaining it in the UAPI, and 
having every VMM ever all do the same work to put the two together, and 
always be up to date with the right UAPI, and never ever let any field 
slip through as-is, especially not all the ones which were RES0 at time 
of writing, enforced by a sternly worded comment? Why yes, of course I 
can see how that's trivially easy and carries no risk whatsoever.

>> We sanitise CPU ID registers for userspace and KVM, so I see no compelling
>> reason for SMMU ID registers to be different.
> 
> We discussed this already:
> 
> https://lore.kernel.org/linux-iommu/20240904120103.GB3915968@nvidia.com
> 
> It is a false comparison, for KVM the kernel is responsible to control
> the CPU ID registers. Reporting the registers the VM sees to the VMM
> makes alot of sense. For SMMU the VMM exclusively controls the VM's ID
> registers.

Pointing out that two things are different is a false comparison because 
they are different, by virtue of your choice to make them different? 
Please try making sense.

Your tautology still does not offer any reasoning against doing the 
logical thing and following the same basic pattern: the kernel uses the 
ID register mechanism itself to advertise the set of features it's 
able/willing to support, by sanitising the values it offers to the VMM, 
combining the notions of hardware and kernel support where the 
distinction is irrelevant anyway. The VMM is then still free to take 
those values and hide more features, or potentially add any that it is 
capable of emulating without the kernel's help, and advertise that final 
set to the VM. Obviously there are significant *implementation* 
differences, most notably that the latter VMM->VM part doesn't need to 
involve IOMMUFD at all since MMIO register emulation can stay entirely 
in userspace, whereas for CPU system registers the final VM-visible 
values need to be plugged back in to KVM for it to handle the traps.

We are all asking you to explain why you think doing the kernel->VMM 
advertisement naturally and intuitively is somehow bad, and forcing VMMs 
to instead rely on a more complex, fragile, and crucially non-existent 
additional interface is better. You should take "We discussed this 
already" as more of a clue to yourself than to me - if 4 different 
people have all said the exact same thing in so many words, perhaps 
there's something in it...

And in case I need to spell it out with less sarcasm, "we'll get masking 
wrong in the kernel" only implies "we'll get kernel_capabilities wrong 
in the kernel (and elsewhere)", so it's clearly not a useful argument to 
keep repeating. Besides, as KVM + sysfs + MRS emulation shows, we're 
pretty experienced at masking ID registers in the kernel. It's not hard 
to do it right in a robust manner, where particularly with the nature of 
SMMU features, the only real risk might be forgetting to expose 
something new once we do actually support it.

> If you still feel strongly about this please let me know by Friday and
> I will drop the idr[] array from this cycle. We can continue to
> discuss a solution for the next cycle.

It already can't work as-is, I don't see how making it even more broken 
would help. IMO it doesn't seem like a good idea to be merging UAPI at 
all while it's still clearly incomplete and by its own definition unusable.

Thanks,
Robin.

