Return-Path: <kvm+bounces-54210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A972FB1D021
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 03:36:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5979B622BFA
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 01:36:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDCAA1A0712;
	Thu,  7 Aug 2025 01:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fSLLijc9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f68.google.com (mail-ej1-f68.google.com [209.85.218.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43531537F8;
	Thu,  7 Aug 2025 01:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754530590; cv=none; b=HIFbyD1WftpiUO7j9cXwxDJJwWHdZ3cHeMUlRFuRdCO22JhldZSILqBdXxnVG+5EdMPqJT9M9YNjo2QJo0FWNVRO0fjQMTl7bGzKbJnMMM0vbpHAr0F1yjXa0KmO3+46x1CR//uePEAJP6OmJr6ySwrgONBIJQp2vb6RGajXHFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754530590; c=relaxed/simple;
	bh=a3Fwgr9HGewiEAduBxs0Dv6nwj8SDOTnY0RCt9EnMRI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j0Uqv+ZUIc+2HqY97x/6ovs9Tsehnfdmkkc277BCE35O+eZxcutSKYoc73Z10o6FxhWUAox8TZNGAqKAYdefuXbS4vmaD/VKbA9WWJ9dAVmC5Ex6qEPkC5XsxcgSZ8LfXGRf/wg/tZLTWfsF13Klm5lNJgY1na3iJDTpT0fgnEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fSLLijc9; arc=none smtp.client-ip=209.85.218.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f68.google.com with SMTP id a640c23a62f3a-af925cbd73aso87179866b.1;
        Wed, 06 Aug 2025 18:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754530586; x=1755135386; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EvZyBa0d9zwF8Krdg127Vc4ZSyy75NCS6IjPrZt0iNc=;
        b=fSLLijc9DlPQhOmxaECRkB+IR0x8AXek30uZV4JZXO8iQEZTpLxApkGOenUBngJ4i8
         dpf2y/E3xr6+VSD8EVd/jUw99FX2gepZqiwO+7ibkS5HHQN+zeUseVSEuAM0rEfQ+dGA
         kpF4AMemneAMMl2J1o5sEmJPC48evIq/Pzfr8+V9yF5KdArwjG09css65FuSt/bab7c8
         Y9pAGJR/uO2i4S1yBVq8axNpsp919HbcEzrqLzl8LGB7udeLmkGuYYRkDgd1o1ptOAE2
         0522L4/jsahwsGvuFrCv8aRwpwY5hGXuHSXMNzCp3AEdp/MfEmBP58rjuLruCuEjV3/7
         T4kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754530586; x=1755135386;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EvZyBa0d9zwF8Krdg127Vc4ZSyy75NCS6IjPrZt0iNc=;
        b=qxAK2H7lh9XY54lnNLXVprpRdWSlRvMpmW0ivSXbBwGw1O7sJ0VS+q9jk51Iz5McqS
         vMMtXe3+N//AQgZsmO1C0ImcLI+efTkn0I0rpUsD+6B1irkFSY0NAzaK0WRIYskoN49U
         uB/oASotrjxzQmmw5Mm6RdCvwjr/bjAOn26p7erBkEwGeiZqLOen15qHSstt2pQ7vs20
         ShwmfuGgKncxBfesHFK4oO5BEtDaKnDQhupoT+G0wMfUoyJW6X/hEJOjupVWhHD6zfR+
         /cP7tv/AwS7P8sL8pplhNk6Fbn1BDB8ZG3W2oM3K0+B93eoOBxqgtdq+Mv5+Ef3k96MS
         +11w==
X-Forwarded-Encrypted: i=1; AJvYcCVN16ofLoJ8BY7ywf+r3A6z1Mn5LuHNnTXfSO0heVQ9pltPlDB6TEZC7gfaP/wV+uvp7Vc=@vger.kernel.org, AJvYcCWA50posPHvEb1nDUereF8VsCyVngCRgHtd2VrI3KtQw+xqRGohr1dsvoo+ZPSPTBoXOpGWP0C64+Nc@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5jPA6MoweoOHCr+wgHBZ2qSE1/WMoJGYGbOsynmFVnRXd+80y
	GkfUQyOTdV7S+4GqoSgj9/ZYhe+1Zez+oG5y+EGKENp7c/PV0JpjPM36
X-Gm-Gg: ASbGncvkss049a8UlAAuo2JWnvf5D8d5vjSw34we0s7YkML0E8SkiAiMYWVk9EVvF4C
	AW4SLF/LJL1NjJRIEjgZL6zwDjp0BKo9dS4ReXBWCr9RSfvcpigm4+FAlObAmHnKq5TCXZ8rgHB
	/X6uOn/+g7rz7Z84dqHOwN4z50hXAzm2VSgDmG6y3uuX11EieQN6RIt7POHeHnhBGX16Ws5oDNk
	mgH3K1J6hb9MarqRjPE5T9fUzO8LOxTx6dvyhC4i4Bt91imwT43SlbPNFte7MaVz4XR0CZ9mERT
	d+2mKHPYGiQV2Zq6vhnKWArVJZyULoVbPYb00Xw3SSv4qKIY37FR4DqyJGkNjuGmYsOtd8iXX4v
	bz5+j01AJGXXw7Ki3kwjPdWPz59yUqlnIcZMyMPHYBvj5+KuldNERWFZlOse7otD4FJF1nTtTF7
	z6oZLNAaCpR+Y1sJ11Xq+DVrOG1K8=
X-Google-Smtp-Source: AGHT+IHtu3Fkk1LgLkO8BsEW8NZyBGoH77/DdhJoytkr88G9xzLy08mBwjZkN1IvATcmUxPs/i4fgg==
X-Received: by 2002:a17:906:6a1f:b0:af9:4fa9:b104 with SMTP id a640c23a62f3a-af99045bbcamr492652366b.45.1754530586329;
        Wed, 06 Aug 2025 18:36:26 -0700 (PDT)
Received: from [26.26.26.1] (95.112.207.35.bc.googleusercontent.com. [35.207.112.95])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a0a3cecsm1201335566b.53.2025.08.06.18.36.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Aug 2025 18:36:25 -0700 (PDT)
Message-ID: <3035b903-66c8-4fbe-8921-562e953143b4@gmail.com>
Date: Thu, 7 Aug 2025 09:36:18 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/16] Fix incorrect iommu_groups with PCIe ACS
To: Baolu Lu <baolu.lu@linux.intel.com>, Jason Gunthorpe <jgg@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
 Alex Williamson <alex.williamson@redhat.com>, galshalom@nvidia.com,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
 tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
References: <0-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
 <a692448d-48b8-4af3-bf88-2cc913a145ca@gmail.com>
 <20250802151816.GC184255@nvidia.com>
 <1684792a-97d6-4383-a0d2-f342e69c91ff@gmail.com>
 <20250805123555.GI184255@nvidia.com>
 <964c8225-d3fc-4b60-9ee5-999e08837988@gmail.com>
 <20250805144301.GO184255@nvidia.com>
 <6ca56de5-01df-4636-9c6a-666ccc10b7ff@gmail.com>
 <3abaf43b-0b81-46e9-a313-0120d30541cc@linux.intel.com>
Content-Language: en-US
From: Ethan Zhao <etzhao1900@gmail.com>
In-Reply-To: <3abaf43b-0b81-46e9-a313-0120d30541cc@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/6/2025 10:41 AM, Baolu Lu wrote:
> On 8/6/25 10:22, Ethan Zhao wrote:
>> On 8/5/2025 10:43 PM, Jason Gunthorpe wrote:
>>> On Tue, Aug 05, 2025 at 10:41:03PM +0800, Ethan Zhao wrote:
>>>
>>>>>> My understanding, iommu has no logic yet to handle the egress control
>>>>>> vector configuration case,
>>>>>
>>>>> We don't support it at all. If some FW leaves it configured then it
>>>>> will work at the PCI level but Linux has no awarness of what it is
>>>>> doing.
>>>>>
>>>>> Arguably Linux should disable it on boot, but we don't..
>>>> linux tool like setpci could access PCIe configuration raw data, so
>>>> does to the ACS control bits. that is boring.
>>>
>>> Any change to ACS after boot is "not supported" - iommu groups are one
>>> time only using boot config only. If someone wants to customize ACS
>>> they need to use the new config_acs kernel parameter.
>> That would leave ACS to boot time configuration only. Linux never
>> limits tools to access(write) hardware directly even it could do that.
>> Would it be better to have interception/configure-able policy for such
>> hardware access behavior in kernel like what hypervisor does to MSR etc ?
> 
> A root user could even clear the BME or MSE bits of a device's PCIe
> configuration space, even if the device is already bound to a driver and
> operating normally. I don't think there's a mechanism to prevent that
pci tools such setpci accesses PCIe device configuration space via sysfs
interface, it has default write/read rights setting to root users, that 
is one point could control the root permission.

PCIe device configuration space was mapped into CPU address space via
ECAM by calling ioremap to setup CPU page table, the PTE has permission
control bits for read/wirte/cache etc. this is another point to control.

Legacy PCI device configuration space was accessed via 0xCF8/0xCFC 
ioport operation, there is point to intercept.

To prevent device from DMA to configuration space, the same IOMMU 
pagetable PTE could be setup to control the access.

> from happening, besides permission enforcement. I believe that the same
> applies to the ACS control.
> 
>>>
>>>>>> The static groups were created according to
>>>>>> FW DRDB tables,
>>>>>
>>>>> ?? iommu_groups have nothing to do with FW tables.
>>>> Sorry, typo, ACPI drhd table.
>>>
>>> Same answer, AFAIK FW tables have no effect on iommu_groups 
>> My understanding, FW tables are part of the description about device 
>> topology and iommu-device relationship. did I really misunderstand
>> something ?
> 
> The ACPI/DMAR table describes the platform's IOMMU topology, not the
> device topology, which is described by the PCI bus. So, the firmware
> table doesn't impact the iommu_group.

I remember drhd table list the iommus and the device belong to them.
but kernel still needs to traverse PCIe topology to make up iommu_groups.


Thanks,
Ethan>
> Thanks,
> baolu


