Return-Path: <kvm+bounces-54079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AB4EB1BEB9
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 04:23:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 40FA81836AD
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 02:23:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 618AA19E975;
	Wed,  6 Aug 2025 02:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W9KjP5eE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f66.google.com (mail-ed1-f66.google.com [209.85.208.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07DAF23CE;
	Wed,  6 Aug 2025 02:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754446987; cv=none; b=hKWNoVQOPKZnKEw1OqFGJTdE6Z6VCsXjubRG8GPwfXwlKnlX9q8vfZd0KHSnS9Knk7HLgzbRSsadxR2Dn3VH3uQunJ1m1DeFPI/ABL2Io12+RTfGh0oNNNjDcBlHHdLHhzowgnjEfooXivspZBEzyF7MWkd2eKC0Yftbm/3pU0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754446987; c=relaxed/simple;
	bh=fj4IR7+zswA7sqkD0tTyy/4FI+cv+hYYunOLbsBKvbw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BQxI/yB8SVBvajjY55/eqCTYOt3rg4RvXPohGETOURO//LG8mh1/zzfpWj/zDsDA8wc9pg9zfimf6IpEuBaP8zG5vUjSfoi0UHHmjKG3fFETOR1xrBKwF55VDHuSSwCl0nRM40s9DK76q1wKSzYRweld+77pj4ct/Lq9M4y0SZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W9KjP5eE; arc=none smtp.client-ip=209.85.208.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f66.google.com with SMTP id 4fb4d7f45d1cf-61553a028dfso6473402a12.0;
        Tue, 05 Aug 2025 19:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754446984; x=1755051784; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WV3i2vsHD5Tto+kS9SXpnp5IN5CWgKxnV0XYONltTEI=;
        b=W9KjP5eEixsmn03cL4GE7L51FzybiAaYCPaUsFfhvt0RREvMUqaEV13oX337diU4lv
         FDXE7gBETfl4C3/sSc7qsfPsfp+vXmLwBfxW47f5RR7ucxu4s0yh7OPBpW47FehFeyI5
         QIX+lJfUj2A/NRg7Uit7QX3bWgQmeT2wGzH9oJ3eJCe0ODo+86sa9Q8a8ngKRWXd58wy
         5CKG9Lc7HGTGRrsrvgkWsqNz23VOqRo8cytBSWifiJJjn04xsTMihl2mL08DyaCB/vjr
         Yqx7TPO2G82tpNSeAPJBHZmUi2LjKzcePSMhM+VqUli5L4KqzQitS5qyVPvs1k9sUxHC
         f2eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754446984; x=1755051784;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WV3i2vsHD5Tto+kS9SXpnp5IN5CWgKxnV0XYONltTEI=;
        b=TgoLQPC5xZ1OVIHiCullxetPF0Y6h0pZOssZtM1cbO5MikA6qhjRrt8Dm0ak1PEq3X
         9CSl7ih40CbvdniN3zs/0Nsb3YSuVGZTOFBVDPOF0LX+H4lcOm7sSrZvuIe3nvDJKP5Y
         YYiP81NzY6LXz9GKMSAkUODtHHfnnM/IksvujeHe0MK8doGgR/0Qysy3pbvfmn6mLfdk
         4fU6RHFR8LdxgDCsasWATsMf2o+DQBA8U3miXkb6xYeHk/kPJZWoEIQQSIkZfVZxDyTA
         fDPhorwiPlso4iZZC1fqN8ezUk83OX4rKzyN1U4wEkrk+br9LIBDE62kN0E0B6RSCHjA
         7+qw==
X-Forwarded-Encrypted: i=1; AJvYcCWBn0DDDfommPlh3qQ2+pcF8tWuXF29knKyezTTt9zzH5cRg7NZqfCDidLfISlzv6idJLY=@vger.kernel.org, AJvYcCXd0RGRM+45otdMbWXpVMYPvc1aYx8tqBi5KrPWkqPyb2rnTN6/I1mk1Z5oBkh9KLCzBbr/OfBi9pS5@vger.kernel.org
X-Gm-Message-State: AOJu0YxbywZOUgy5pJjDb7pFHN/QI2VKiCCIAGldOaLZ2DGouIMb/KW+
	2dfM9wtV2tVcRdExT5jkQdPtauYw5WRiiiBfQxiGWBEOC9wxSaLK+O2Y
X-Gm-Gg: ASbGncuV5P4O9HUzV4B/GKJliOK/gqyQfo+eFgaxnPR3Sc+ZXQKM/fYKxXPd2L04dA2
	+OXxSGhydQ74NyKywwjE57HTBo1dBRhoo7eQyAwK6VxdlsGqgleuaMI+hzlgVW9QiD2Y6u/9YwE
	lVUZpQ828G+RRYEF9y3FhrQ7LUE4437oq7m6HinAiZMlG1A+hL6iSQSROCzd1fbqpJBXnvqdlZI
	lJ4Zidyh6HFAp03di/+/miTxp6bJ2hlHnylduJWzXUOX5eDbdPE4VdIF+9fvQFfWfrYcFAi5Wxn
	/Md5Il3Yp6RHRi2qTLKmIBLgQYDgZVmDb1rBF2/SBWhNVJdpfnfOZ3AruSKJWztNua1IAw6YvL4
	Q1eFlu4VOK6+EWkVt/x7p5KR0G1EoFM7f7QtX1G7Nh0GdIkor6xmvzxKz+MZrleDnnnavQfbXTD
	hkvYixqZc1BL3tb5D1rHcCoENGM0U=
X-Google-Smtp-Source: AGHT+IHZJL3Gcs1UE3cxSDIkmf9wQXNttiL49vH8U6oL/UasUEDh5LoNJkxUN1wHF0UudVM2Mn4IhQ==
X-Received: by 2002:a17:907:6096:b0:af4:148:e51f with SMTP id a640c23a62f3a-af992a37d1fmr59140566b.2.1754446984286;
        Tue, 05 Aug 2025 19:23:04 -0700 (PDT)
Received: from [26.26.26.1] (95.112.207.35.bc.googleusercontent.com. [35.207.112.95])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a2437desm1012205966b.127.2025.08.05.19.22.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 19:23:03 -0700 (PDT)
Message-ID: <6ca56de5-01df-4636-9c6a-666ccc10b7ff@gmail.com>
Date: Wed, 6 Aug 2025 10:22:58 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/16] Fix incorrect iommu_groups with PCIe ACS
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
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
Content-Language: en-US
From: Ethan Zhao <etzhao1900@gmail.com>
In-Reply-To: <20250805144301.GO184255@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/5/2025 10:43 PM, Jason Gunthorpe wrote:
> On Tue, Aug 05, 2025 at 10:41:03PM +0800, Ethan Zhao wrote:
> 
>>>> My understanding, iommu has no logic yet to handle the egress control
>>>> vector configuration case,
>>>
>>> We don't support it at all. If some FW leaves it configured then it
>>> will work at the PCI level but Linux has no awarness of what it is
>>> doing.
>>>
>>> Arguably Linux should disable it on boot, but we don't..
>> linux tool like setpci could access PCIe configuration raw data, so
>> does to the ACS control bits. that is boring.
> 
> Any change to ACS after boot is "not supported" - iommu groups are one
> time only using boot config only. If someone wants to customize ACS
> they need to use the new config_acs kernel parameter.
That would leave ACS to boot time configuration only. Linux never
limits tools to access(write) hardware directly even it could do that.
Would it be better to have interception/configure-able policy for such
hardware access behavior in kernel like what hypervisor does to MSR etc ?
> 
>>>> The static groups were created according to
>>>> FW DRDB tables,
>>>
>>> ?? iommu_groups have nothing to do with FW tables.
>> Sorry, typo, ACPI drhd table.
> 
> Same answer, AFAIK FW tables have no effect on iommu_groups 
My understanding, FW tables are part of the description about device 
topology and iommu-device relationship. did I really misunderstand
something ?

Thanks,
Ethan >
> Jason


