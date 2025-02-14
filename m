Return-Path: <kvm+bounces-38140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CD903A3567D
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 06:43:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E167188F9F2
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 05:43:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FE6A18B460;
	Fri, 14 Feb 2025 05:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hZTWzL+R"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D5838DD8;
	Fri, 14 Feb 2025 05:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739511776; cv=none; b=tMcKU0v4zX/+dtt0r1yN7M7oTuP9UXg+d2OBD2QceCN64TyZkGpi1oidKwRma0Je8+k2nk02metJ68qyrJkQLFuEZ/LgWLW/oTFSoy1SNLpQntYaOvvoWcDLhJWovs+z5DrRrMmW9XDW9Fnz//q5aru8fuUK1FQXtmC+mwF2vDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739511776; c=relaxed/simple;
	bh=h6p7Y22j2hIaMSGgYnBcUas0+FeWCyvYHlZZIhCytkM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g8o3uJ8lHoIxSp2n4pAUe9+0v8701EpF9/QfNQUnOANtnUtfeJISCFyx6+G+SqFRU26VIjvgw3yLU9F7yQOLYfsQMDGoa86H+rXfAKvLFj0lkpVSGQgv6uu0rt0x5xBhS8TbTNCnitrslwGV0k5k7jTCiJ++c25lR9zNLK7ebYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hZTWzL+R; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739511774; x=1771047774;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=h6p7Y22j2hIaMSGgYnBcUas0+FeWCyvYHlZZIhCytkM=;
  b=hZTWzL+RAv+XZmiZrV5fw47VQDy/Ohj+5ukcULnwOic2Zd02c/1c2E72
   XW3lEnHM3FSdY0cL76767L/PtMR44X7rdebn27/tKpu5iA8+ffWygFxN6
   8s3bjo0I7Dswm6fYg1ENtEMBxQM0DMqNZmijOr0yU0mSVHNRyHvpPbCcs
   Qt8rxfcrnFVXz9o2jLv/HvrOYQ6uf4kyj+gkOtrUnqI2B7J7i5s4lBgKg
   kYth46ptZ/BXtRaBovIm4OQobMYDNYPRW7rMKo6YdzEsN2quCEt7cDz6c
   rBUgpPxzJ3v5w16tbMnTa51sDjpy9QouBPyq+rVRkzeUkWXtKe0zpDnEo
   w==;
X-CSE-ConnectionGUID: i/xpQpCrTFOJQImq+pr6Ew==
X-CSE-MsgGUID: GPBikHTeSs2WjPVE2mczpQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="51680988"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="51680988"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2025 21:42:54 -0800
X-CSE-ConnectionGUID: HFEGjSazTHyw5Tz92aIw/w==
X-CSE-MsgGUID: RMkJwxJhQSmPkE76rQWIFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="118573799"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2025 21:42:47 -0800
Message-ID: <bc9f4477-7976-4955-85dc-3e05ebe95ead@linux.intel.com>
Date: Fri, 14 Feb 2025 13:39:52 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/12] Initial support for SMMUv3 nested translation
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Zhangfei Gao <zhangfei.gao@linaro.org>, acpica-devel@lists.linux.dev,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
 Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 Lorenzo Pieralisi <lpieralisi@kernel.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Robert Moore <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>,
 Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Donald Dutile <ddutile@redhat.com>, Eric Auger <eric.auger@redhat.com>,
 Hanjun Guo <guohanjun@huawei.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Jerry Snitselaar <jsnitsel@redhat.com>, Moritz Fischer <mdf@kernel.org>,
 Michael Shavit <mshavit@google.com>, Nicolin Chen <nicolinc@nvidia.com>,
 patches@lists.linux.dev, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
 Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
 Mostafa Saleh <smostafa@google.com>
References: <20241112182938.GA172989@nvidia.com>
 <CABQgh9HOHzeRF7JfrXrRAcGB53o29HkW9rnVTf4JefeVWDvzyQ@mail.gmail.com>
 <20241113012359.GB35230@nvidia.com>
 <9df3dd17-375a-4327-b2a8-e9f7690d81b1@linux.intel.com>
 <20241113164316.GL35230@nvidia.com>
 <6ed97a10-853f-429e-8506-94b218050ad3@linux.intel.com>
 <20241115175522.GA35230@nvidia.com> <20250122192622.GA965540@nvidia.com>
 <284dd081-8d53-45ef-ae18-78b0388c98ca@linux.intel.com>
 <f7b6c833-b6c1-4154-9b77-13553e501f2b@linux.intel.com>
 <20250213184317.GB3886819@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20250213184317.GB3886819@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 02:43, Jason Gunthorpe wrote:
> On Thu, Feb 13, 2025 at 07:57:51PM +0800, Baolu Lu wrote:
>> On 2025/2/5 11:45, Baolu Lu wrote:
>>> On 2025/1/23 3:26, Jason Gunthorpe wrote:
>>>> On Fri, Nov 15, 2024 at 01:55:22PM -0400, Jason Gunthorpe wrote:
>>>>>>> I need your help to remove IOMMU_DEV_FEAT_IOPF from the intel
>>>>>>> driver. I have a patch series that eliminates it from all the other
>>>>>>> drivers, and I wrote a patch to remove FEAT_SVA from intel..
>>>>>> Yes, sure. Let's make this happen in the next cycle.
>>>>>>
>>>>>> FEAT_IOPF could be removed. IOPF manipulation can be handled in the
>>>>>> domain attachment path. A per-device refcount can be implemented. This
>>>>>> count increments with each iopf-capable domain attachment
>>>>>> and decrements
>>>>>> with each detachment. PCI PRI is enabled for the first iopf-capable
>>>>>> domain and disabled when the last one is removed. Probably we can also
>>>>>> solve the PF/VF sharing PRI issue.
>>>>> Here is what I have so far, if you send me a patch for vt-d to move
>>>>> FEAT_IOPF into attach as you describe above (see what I did to arm for
>>>>> example), then I can send it next cycle
>>>>>
>>>>> https://github.com/jgunthorpe/linux/commits/iommu_no_feat/
>>>> Hey Baolu, a reminder on this, lets try for it next cycle?
>>>
>>> Oh, I forgot this. Thanks for the reminding. Sure, let's try to make it
>>> in the next cycle.
>>
>> Hi Jason,
>>
>> I've worked through the entire series. The patches are available here:
>>
>> https://github.com/LuBaolu/intel-iommu/commits/iommu-no-feat-v6.14-rc2
>>
>> Please check if this is the right direction.
> 
> Looks great, and you did all the cleanup stuff too!
> 
> The vt-d flow is a little more complicated than the ARM logic because
> the driver flow is structed differently.
> 
> Do we really want ATS turned on if the only thing attached is an
> IDENTITY domain? That will unnecessarily slow down ATS capable HW.. It
> is functionally OK though.

It depends. The Intel driver uses a simple approach.

When the IOMMU is working in legacy mode, PASID and PRI are not
supported. In this case, ATS will not be enabled if the identity domain
is attached to the device.

When the IOMMU is working in scalable mode, PASID and PRI are supported.
ATS will always be enabled, even if the identity domain is attached to
the device, because the PASID might use PRI, which depends on ATS
functionality. This might not be the best choice, but it is the
simplest and functional.

If any device does not work with the identity domain and ATS enabled,
then we can add a quirk to the driver, as we already have such a
mechanism.

> 
> Also, are there enough ATC flushes around any domain type change? I
> didn't check..

The VT-d specification defines guidance for software to manage caches,
both the IOTLB in the IOMMU and the ATC on the device (Table 28,
Guidance to Software for Invalidations). The driver was written
according to that guidance.

> I feel like we should leave "iommu: Move PRI enablement for VF to
> iommu driver" out for now, every driver needs this check?  AMD
> supports SVA and PRI so it needs it too.

Yes, agreed.

> 
> Do you want to squash those fixup patches and post it?

Yes, sure. Let me post it for further review.

> Thanks,
> Jason

Thanks,
baolu

