Return-Path: <kvm+bounces-54315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A5ECB1E3F0
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 09:56:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3782F189CF36
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 07:56:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F940252287;
	Fri,  8 Aug 2025 07:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k0v2z2qK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com [209.85.128.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079CD23B62C;
	Fri,  8 Aug 2025 07:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754639784; cv=none; b=iSSY1D27U4P5RnUsEzzvroS7btdO4VfEZihK6VWOK+w6Meyk80DoJtS41f/U4BHp5l62+ihND2PXccBmm2R08HE4au9DHlC+fWnxC2Oxuw4QTZF9l9fQ2nVTTVa64rwKqrYLgMatBBJRsnfHEBqGoslT6MhYLXRy1GWRjwgow6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754639784; c=relaxed/simple;
	bh=eH0NyDPZql4wCTz3i6PHT+N8D4o8WobMpqdwAmhOD8o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rw+dSYtK0OEs71GShE757r3v2yZ44kzMC6+Uj+ErpphlA2BXNwOsxGx2wjpkLIpc2L4mBAsWf+XAOECp0c3JS4EQDJTzvp7vQO3oyXaXwS+Y25dRxe42hV5XeCbWYhK4W/3skSmyKJZBmH9dNgt8Abfr8Ohs9cuBLcMSe/MeVyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k0v2z2qK; arc=none smtp.client-ip=209.85.128.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f66.google.com with SMTP id 5b1f17b1804b1-459e20ec1d9so17561155e9.3;
        Fri, 08 Aug 2025 00:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754639781; x=1755244581; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g47/JQMYnoJFt8X2Gyr00t3GiLF5ts7OyvZLVgHeWbk=;
        b=k0v2z2qKxJa82vs3scsaXhdrU5tkWHRqHcBAT6dsQirZC+5a4Ufugqc0TIAkt6wgIh
         Jo/5MUj4zgMYcQRqJXwZFT3a2HLBhcXx4Pkojiv5Pvlwv5WEMPwePI+WhfkZB+FyLH6e
         jFCCy6oHh3gTozlZFhlBwR1/0RsKkbk/7qujOqIL91o1ACgdkbikuozZkWz1qSDwUm9v
         1vUcohrhM58k0bfSFF9YLv6xohfU5RFBRG6daGPg09iYcvKY/0Pq9J/1q/8Gdo5UyNX6
         EM6lN84L1wueJWsjorDO1rjNbVtUnT8OIo8Jby29gSk7ROHjxsi42FqRhTPsGayxvLpA
         //0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754639781; x=1755244581;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g47/JQMYnoJFt8X2Gyr00t3GiLF5ts7OyvZLVgHeWbk=;
        b=H6LTqelYESNNNXJqNCpoUv5td39S6ebuCLfEyeF8tkHhqDl2c0VMem7j84regP0JgM
         q4OOdS50tXNQTtuEvArjVrC0OkfK7nlvQs8Gca6f3+1cWFD0tMKXiqW/wysHEZNp7cy5
         o3R6uSbHVlXciSMNY2aOXUnj75DKS3NLwcJOxg483X6MIbViib0uFM+5Ma+MSZHXNkIb
         w6STTeNdiKlVkSXx1TYCFTrkU3tBGhFAywdjRHaLbQxcJQBtcEuV+JqHXacI1lXP6e5o
         1O/clMejcsWdFZU+SIpNAD1SX39fGErrYS8BWoNKWqeZUrBN2TMfCsk3OuKRiYq6TUyx
         dUOA==
X-Forwarded-Encrypted: i=1; AJvYcCVnxh2Hs1IXUplOUBQAOruSULNiKTYp6sgFDtqmYA232qKuZtI9b3/JYSPrWCf0D057Khg=@vger.kernel.org, AJvYcCXQ0zs7rEgeDrEeocFt37+MVLVaSqdcefOOnK8DhBnzA9/PX9DDz6UzWa4P7yez7++sOdUjRR+9RWb2@vger.kernel.org
X-Gm-Message-State: AOJu0YzY6JFE1fFHP6krCN2EMj5lwFLqAzIT/SKokknben1DrA61+xum
	OVGga8R13NVTGElGt+XO+uJdT9sTbM3tKzBJCezcjUNppl4PTXE0mC/6
X-Gm-Gg: ASbGncvl4rLeabpIScizFRvEHwHXlpAuk0e4OOQ5vxfwBV8dVulutyEuzzHIwzzTnYB
	GURUYM9kGAT7ZZnjZX4dMseJw7HMfrSZjuqAtbgbT3naCNby4KZ85piRcMbQ2wBEAT3ysy2q75s
	33mDFI59A5IrED4TArtW5RSDSvbP/wOym/7DtvACZf68Xnt/8prxp5U7/J+tn/4/EPPB88oVTG1
	gMViXKGKwKt59P6k98uwiPubhrvx39qOI/z29NusKNRFCpgOcMMq12OsTFFLEP7C9jSN9PNskMv
	mQTF4rL8/9Nwi7bAHyTSkN2IwPg2XGyRorkM0J1e9NnC7qeZokHTdXVuaC5WZiBci2TsYVeX02H
	z6bYBJK9Wg1Pvd5VBd/bPgvKd13qpNB0hP/Yd8rYmOAt8dt0Y6Y8Ss+k0C30ZkWv7zBgHhpB+6G
	rAmT384mUv+rc2QhePN9nULM496jZL7owIpw==
X-Google-Smtp-Source: AGHT+IEBs27Uy9PNJpjOLnJbY5yuC13GxO0mFq67O2Xv2B5Lc++fQpKDmSg1kZHFuBQVQnQHeW4qhw==
X-Received: by 2002:a05:600c:524a:b0:456:1204:e7e6 with SMTP id 5b1f17b1804b1-459f4f517dbmr14242675e9.11.1754639781007;
        Fri, 08 Aug 2025 00:56:21 -0700 (PDT)
Received: from [26.26.26.1] (ec2-3-72-134-22.eu-central-1.compute.amazonaws.com. [3.72.134.22])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3bf956sm30081041f8f.24.2025.08.08.00.56.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Aug 2025 00:56:20 -0700 (PDT)
Message-ID: <c6b5067e-8ae4-44f6-83de-f098761608ba@gmail.com>
Date: Fri, 8 Aug 2025 15:56:13 +0800
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
There is kernel lockdown lsm works via kernel parameter lockdown=
{integrity | confidentiality},

"If set to integrity, kernel features that allow userland to modify the 
running kernel are disabled. If set to confidentiality, kernel features 
that allow userland to extract confidential information from the kernel
are also disabled. "

It also works for PCIe configuration space directly access from 
userland, but the levels of configuration granularity is coarse, can't 
configure kernel to only prevent PCI device from accessing from userland.

The design and implementation is structured and the granularity is fine-
grained, it is easy to extended and add new kernel parameter to only
lockdown PCI device configuration space access.

[LOCKDOWN_PCI_ACCESS] = "direct PCI access"

Thanks,
Ethan



> 
> Thanks,
> baolu


