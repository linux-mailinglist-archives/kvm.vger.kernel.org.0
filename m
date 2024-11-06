Return-Path: <kvm+bounces-31003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 372BA9BF35C
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 17:38:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5AAC41C20B1C
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 16:38:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8520E20513F;
	Wed,  6 Nov 2024 16:38:01 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3183C18FC8C;
	Wed,  6 Nov 2024 16:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730911081; cv=none; b=XQx2vwb8sPMK2XiXgn5OgOTVc5JH8pzXepKhyo1NOVQvvsVyEpEkfzIDedb6IfpruxOSUFdrRES9GTeWvJbOQQW7Mn0ggbUO/2Bdd2O7YgOvDcIOOwCm1jR5Mpg7efEc/rdntQUGIbdPoT/91HmPwwLSoaiUrYFSMDTUu05Mhec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730911081; c=relaxed/simple;
	bh=NoUPWQGZ3FMIWDA+UGAU977oicgCj2D+ncc6vpw6caU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WNaHgcETXkzfeWBCmb5aQYYblnVrC7qwdtLlQW0Oc9EEgxYc+xSpwxdZqi4BdRcKxIBL0OYiLfHGuvYLWLeV4Ln4K4V8jZvcc4yrLZw6OXqVy4xFs5JAXFNHhXl8sf8RPpjJEzlvnDgdIhwMOuH0IXTdI8lRAwOH9c9p68IDkB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 118FC497;
	Wed,  6 Nov 2024 08:38:28 -0800 (PST)
Received: from [10.57.90.5] (unknown [10.57.90.5])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6850B3F528;
	Wed,  6 Nov 2024 08:37:54 -0800 (PST)
Message-ID: <8a5940b0-08f3-48b1-9498-f09f0527a964@arm.com>
Date: Wed, 6 Nov 2024 16:37:53 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/12] iommu/arm-smmu-v3: Support IOMMU_GET_HW_INFO via
 struct arm_smmu_hw_info
To: Jason Gunthorpe <jgg@nvidia.com>, Will Deacon <will@kernel.org>
Cc: acpica-devel@lists.linux.dev, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, Len Brown <lenb@kernel.org>,
 linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
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
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <20241104124102.GX10193@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024-11-04 12:41 pm, Jason Gunthorpe wrote:
> On Mon, Nov 04, 2024 at 11:47:24AM +0000, Will Deacon wrote:
>>> +/**
>>> + * struct iommu_hw_info_arm_smmuv3 - ARM SMMUv3 hardware information
>>> + *                                   (IOMMU_HW_INFO_TYPE_ARM_SMMUV3)
>>> + *
>>> + * @flags: Must be set to 0
>>> + * @__reserved: Must be 0
>>> + * @idr: Implemented features for ARM SMMU Non-secure programming interface
>>> + * @iidr: Information about the implementation and implementer of ARM SMMU,
>>> + *        and architecture version supported
>>> + * @aidr: ARM SMMU architecture version
>>> + *
>>> + * For the details of @idr, @iidr and @aidr, please refer to the chapters
>>> + * from 6.3.1 to 6.3.6 in the SMMUv3 Spec.
>>> + *
>>> + * User space should read the underlying ARM SMMUv3 hardware information for
>>> + * the list of supported features.
>>> + *
>>> + * Note that these values reflect the raw HW capability, without any insight if
>>> + * any required kernel driver support is present. Bits may be set indicating the
>>> + * HW has functionality that is lacking kernel software support, such as BTM. If
>>> + * a VMM is using this information to construct emulated copies of these
>>> + * registers it should only forward bits that it knows it can support.

But how *is* a VMM supposed to know what it can support? Are they all 
expected to grovel the host devicetree/ACPI tables and maintain their 
own knowledge of implementation errata to understand what's actually usable?

>>> + *
>>> + * In future, presence of required kernel support will be indicated in flags.
>>
>> What about the case where we _know_ that some functionality is broken in
>> the hardware? For example, we nobble BTM support on MMU 700 thanks to
>> erratum #2812531 yet we'll still cheerfully advertise it in IDR0 here.
>> Similarly, HTTU can be overridden by IORT, so should we update the view
>> that we advertise for that as well?
> 
> My knee jerk answer is no, these struct fields should just report the
> raw HW register. A VMM should not copy these fields directly into a
> VM. The principle purpose is to give the VMM the same details about the
> HW as the kernel so it can apply erratas/etc.
> 
> For instance, if we hide these fields how will the VMM/VM know to
> apply the various flushing errata? With vCMDQ/etc the VM is directly
> pushing flushes to HW, it must know the errata.

That doesn't seem like a valid argument. We obviously can't abstract 
SMMU_IIDR, that would indeed be an invitation for trouble, but 
otherwise, if an erratum affects S1 operation under conditions dependent 
on an optional feature, then not advertising that feature would make the 
workaround irrelevant anyway, since as far as the VM is concerned it 
would be wrong to expect a non-existent feature to work in the first place.

> For BTM/HTTU/etc - those all require kernel SW support and per-device
> permission in the kernel to turn on. For instance requesting a nested
> vSTE that needs BTM will fail today during attach. Turning on HTTU on
> the S2 already has an API that will fail if the IORT blocks it.

What does S2 HTTU have to do with the VM? How the host wants to maintain 
its S2 tables it its own business. AFAICS, unless the VMM wants to do 
some fiddly CD shadowing, it's going to be kinda hard to prevent the 
SMMU seeing a guest CD with CD.HA and/or CD.HD set if the guest expects 
S1 HTTU to work.

I'm not sure what "vSTE that needs BTM" means. Even if the system does 
support BTM, the only control is the global SMMU_CR2.PTM, and a vSMMU 
can't usefully emulate changing that either way. Either the host set 
PTM=0 before enabling the SMMU, so BTM can be advertised and expected to 
work, or it didn't, in which case there can be no BTM, full stop.

> Incrementally dealing with expanding the support is part of the
> "required kernel support will be indicated in flags."
> 
> Basically, exposing the information as-is doesn't do any harm.

I would say it does. Advertising a feature when we already know it's not 
usable at all puts a non-trivial and unnecessary burden on the VMM and 
VM to then have to somehow derive that information from other sources, 
at the risk of being confused by unexpected behaviour if they don't.

We sanitise CPU ID registers for userspace and KVM, so I see no 
compelling reason for SMMU ID registers to be different.

Thanks,
Robin.

