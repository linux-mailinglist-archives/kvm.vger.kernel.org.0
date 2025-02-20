Return-Path: <kvm+bounces-38637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B0BBA3CF46
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 03:15:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1BE6517B94E
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 02:13:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF33C1CCEE2;
	Thu, 20 Feb 2025 02:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j7R5I+S/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D42110FD;
	Thu, 20 Feb 2025 02:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740017629; cv=none; b=S3yN2e3VZ4w66cw1whuP9tq5A9HE5qAXu3EIZdR8KYNRgoyCmZOITR321e1kXK9VTGG5Kkrdno6ByN0Noj5U/Mb3IafUEMdJecQq+vycQ4ovGiTf/uR4zGbAsK49vwgpnjSBf8AMedpd7FSXI2fC3Elbizy/9eprwwdGIm11nxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740017629; c=relaxed/simple;
	bh=GBvD2bkSH/pQf3oXkciwQpaE+MUdAMS3a6Cb1EoRnIs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YkoDqDGJ7UzIqKteM5XpOilgFvtKvV7vYVaHdJ5szlfGBAVlU8EV3StNW+0sOXS2B2CxiiYPzE9eVviqdIPkXu6LgVD4usC/UxWE/NVJCtSCCQ/d9z7H/NqglV3vq15xf04rY9wPEQNQc2YvUmB8bCdhOP811MUuueoZmP40MiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j7R5I+S/; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740017627; x=1771553627;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GBvD2bkSH/pQf3oXkciwQpaE+MUdAMS3a6Cb1EoRnIs=;
  b=j7R5I+S/FCKANzFmwYXxkvQXIAs/kdy5w2TrnzqkZfgIyGuKIn6H29ET
   lnGWGoPfD90g1sZEBxJx+/O7JNmqdRy07Oows3EmdFi3jx+Abqyzux4bg
   6SKz6oEWUDOa4KkEAwZ1Irj5b8WW3YvduXIiIXwTk3egE177YHWtX6pw+
   AHvZeGNnZCz397/5SPvML0KnKKZ6gUNVwNGQVn8mg8iTunJCSeCmfxM4p
   8Ro4b84g8qZi0A22XforNI1ItAASuEC1p08HrSMU1wAaJUVA13UstZb0o
   tbSkDi0arRemMlT54Qtm4Xm1Mi/rIrqFehrCBru8GIaoWEczq9qDCJS2I
   g==;
X-CSE-ConnectionGUID: mcy2gzEHRGO4XYfTRmeN6Q==
X-CSE-MsgGUID: /ywrsgDQQyOTa+vCXmEuhA==
X-IronPort-AV: E=McAfee;i="6700,10204,11350"; a="51424638"
X-IronPort-AV: E=Sophos;i="6.13,300,1732608000"; 
   d="scan'208";a="51424638"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2025 18:13:47 -0800
X-CSE-ConnectionGUID: dxxRzlLRTLidTKr9odiFmQ==
X-CSE-MsgGUID: 05003GDaRq+1FPxr5vBMHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,300,1732608000"; 
   d="scan'208";a="119995677"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2025 18:13:41 -0800
Message-ID: <7027fb3a-dfb4-40ae-ac9c-5ea1dcd57746@linux.intel.com>
Date: Thu, 20 Feb 2025 10:10:36 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/12] Initial support for SMMUv3 nested translation
To: "Tian, Kevin" <kevin.tian@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
Cc: Zhangfei Gao <zhangfei.gao@linaro.org>,
 "acpica-devel@lists.linux.dev" <acpica-devel@lists.linux.dev>,
 "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
 Joerg Roedel <joro@8bytes.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 Len Brown <lenb@kernel.org>,
 "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 Lorenzo Pieralisi <lpieralisi@kernel.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 "Moore, Robert" <robert.moore@intel.com>, Robin Murphy
 <robin.murphy@arm.com>, Sudeep Holla <sudeep.holla@arm.com>,
 Will Deacon <will@kernel.org>, Alex Williamson <alex.williamson@redhat.com>,
 Donald Dutile <ddutile@redhat.com>, Eric Auger <eric.auger@redhat.com>,
 Hanjun Guo <guohanjun@huawei.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Jerry Snitselaar <jsnitsel@redhat.com>, Moritz Fischer <mdf@kernel.org>,
 Michael Shavit <mshavit@google.com>, Nicolin Chen <nicolinc@nvidia.com>,
 "patches@lists.linux.dev" <patches@lists.linux.dev>,
 "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
 Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
 Mostafa Saleh <smostafa@google.com>
References: <20241113164316.GL35230@nvidia.com>
 <6ed97a10-853f-429e-8506-94b218050ad3@linux.intel.com>
 <20241115175522.GA35230@nvidia.com> <20250122192622.GA965540@nvidia.com>
 <284dd081-8d53-45ef-ae18-78b0388c98ca@linux.intel.com>
 <f7b6c833-b6c1-4154-9b77-13553e501f2b@linux.intel.com>
 <20250213184317.GB3886819@nvidia.com>
 <bc9f4477-7976-4955-85dc-3e05ebe95ead@linux.intel.com>
 <20250214124150.GF3886819@nvidia.com>
 <58e7fbee-6688-4a49-8b7a-f0e81e6562db@linux.intel.com>
 <20250218130333.GA4099685@nvidia.com>
 <f7e30bd8-ae1f-42fe-a8a6-2b448a474044@linux.intel.com>
 <BN9PR11MB5276EAD07C3B32517D339DF28CC52@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB5276EAD07C3B32517D339DF28CC52@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/19/25 16:34, Tian, Kevin wrote:
>> From: Baolu Lu <baolu.lu@linux.intel.com>
>> Sent: Wednesday, February 19, 2025 10:10 AM
>>
>> On 2/18/25 21:03, Jason Gunthorpe wrote:
>>> On Sat, Feb 15, 2025 at 05:53:13PM +0800, Baolu Lu wrote:
>>>> On 2/14/25 20:41, Jason Gunthorpe wrote:
>>>>> On Fri, Feb 14, 2025 at 01:39:52PM +0800, Baolu Lu wrote:
>>>>>
>>>>>> When the IOMMU is working in scalable mode, PASID and PRI are
>> supported.
>>>>>> ATS will always be enabled, even if the identity domain is attached to
>>>>>> the device, because the PASID might use PRI, which depends on ATS
>>>>>> functionality. This might not be the best choice, but it is the
>>>>>> simplest and functional.
>>>>> The arm driver keeps track of things and enables ATS when PASIDs are
>>>>> present
>>>> I am not aware of any VT-d hardware implementation that supports
>>>> scalable mode but not PASID. If there were one, it would be worthwhile
>>>> to add an optimization to avoid enabling ATS during probe if PASID is
>>>> not supported.
>>> I mean domains attached to PASIDs that need PRI/ATS/etc
>>
>> Yeah, that's a better solution. The PCI PRI/ATS features are only
>> enabled when a domain that requires them is attached to it. I will
>> consider it in the Intel driver later.
>>
> 
> I didn't get the connection here. ATS can run w/o PASID per PCIe
> spec. Why do we want to add a dependency on PASID here?

It's due to PRI, which depends on ATS. The original topic is: when an
identity domain is attached to the device and the device has no PASID
support, then ATS might be disabled because ATS isn't supposed to
provide much benefit in this case. Otherwise, ATS should be enabled
because:

- It benefits performance when the domain is a paging domain.
- A domain attached to a PASID might use PRI, thus requiring ATS to be
   on.

The proposed solution is to use a reference count for ATS enablement,
similar to how we handle iopf in another series. ATS is enabled as long
as any domain requires it and disabled if no domain requires it.

Hope it explains.

Thanks,
baolu

