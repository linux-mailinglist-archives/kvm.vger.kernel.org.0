Return-Path: <kvm+bounces-38277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81692A36D27
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 10:56:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 49C5816DAB3
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 09:56:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 618461A5B82;
	Sat, 15 Feb 2025 09:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F8583tce"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C53194A75;
	Sat, 15 Feb 2025 09:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739613377; cv=none; b=jif2DPVLqedGkjYpuuKe7LYLDBHvckMs61S0oJZr9x6KRdpN6Uk45qPr4aPZsaX+WOFCT2QM3JPW+3LmDtI7CNIdHIcFVVczRraz21f4n58+ErufuZ0hfjVzb092cGsG7W5mvIAKB1r1Hj2ZAA7gNyRLqgebe/EwmQFDeuGRmM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739613377; c=relaxed/simple;
	bh=+dFkYXLjCfDflfWogL2OUxXeilHDLF7xrCSgB+RuTlE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jSEHijcZnPEGzjOfhuYDNpO9/fuINkgSVx70wQzxJs+nXoBJYEDPgzuDoYj7jyoFg6d8I7qTP7cwfCWAs+lrN6OICUVa2sDzMeJPEiR+L1l1EqRy3mhY//L+DVEh2KPBlBPOvI7xrrKAoiVutTvxvVLoEY2PBlGzJ2TpDvM1eoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F8583tce; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739613377; x=1771149377;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+dFkYXLjCfDflfWogL2OUxXeilHDLF7xrCSgB+RuTlE=;
  b=F8583tceoBW/2IfB9BicZoqWWNThGFb4lKDSSbM41zmn5kfJ4fV/hJQo
   YJH7UQyXVMFKr4pgJpnjk3PJ+T69lQvFh+swRvn2lkaTsTRYB6oTomBvF
   shWKiSjJIYW1wGuJhP6zDIeLXUn2EhKFhpY7kSh68gIuVYGW9n9VGdrNR
   QFL8sxsT6DJqUp5sSW9/dBFlnA0adT2MGMJj2BmFIqijHYeM3P7wf1Jaj
   qi+67wEgyTEVHc7l8uJLZ7QS5jWlZUzdo4GdFl+HJwn2Zsvbcz+6tu6ee
   1oSRI1zkt2jAuIb9ujOipuqDQefHRrGvNFzu9NvIfamMrl+sh2D39WnkA
   w==;
X-CSE-ConnectionGUID: 9F5dn1khQVCf8h4J/bgeAg==
X-CSE-MsgGUID: DJ41CmmxTzqoI7lIXiGNJg==
X-IronPort-AV: E=McAfee;i="6700,10204,11345"; a="57766105"
X-IronPort-AV: E=Sophos;i="6.13,288,1732608000"; 
   d="scan'208";a="57766105"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2025 01:56:16 -0800
X-CSE-ConnectionGUID: n9GHMeQKRRqXYN2OdW9vnQ==
X-CSE-MsgGUID: KdikE3/JTzS07ehZlmxziA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="117811969"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2025 01:56:10 -0800
Message-ID: <58e7fbee-6688-4a49-8b7a-f0e81e6562db@linux.intel.com>
Date: Sat, 15 Feb 2025 17:53:13 +0800
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
References: <20241113012359.GB35230@nvidia.com>
 <9df3dd17-375a-4327-b2a8-e9f7690d81b1@linux.intel.com>
 <20241113164316.GL35230@nvidia.com>
 <6ed97a10-853f-429e-8506-94b218050ad3@linux.intel.com>
 <20241115175522.GA35230@nvidia.com> <20250122192622.GA965540@nvidia.com>
 <284dd081-8d53-45ef-ae18-78b0388c98ca@linux.intel.com>
 <f7b6c833-b6c1-4154-9b77-13553e501f2b@linux.intel.com>
 <20250213184317.GB3886819@nvidia.com>
 <bc9f4477-7976-4955-85dc-3e05ebe95ead@linux.intel.com>
 <20250214124150.GF3886819@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20250214124150.GF3886819@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 20:41, Jason Gunthorpe wrote:
> On Fri, Feb 14, 2025 at 01:39:52PM +0800, Baolu Lu wrote:
> 
>> When the IOMMU is working in scalable mode, PASID and PRI are supported.
>> ATS will always be enabled, even if the identity domain is attached to
>> the device, because the PASID might use PRI, which depends on ATS
>> functionality. This might not be the best choice, but it is the
>> simplest and functional.
> The arm driver keeps track of things and enables ATS when PASIDs are
> present

I am not aware of any VT-d hardware implementation that supports
scalable mode but not PASID. If there were one, it would be worthwhile
to add an optimization to avoid enabling ATS during probe if PASID is
not supported.

> 
>> If any device does not work with the identity domain and ATS enabled,
>> then we can add a quirk to the driver, as we already have such a
>> mechanism.
> The device should not care, as long as the HW works.. ARM has a weird
> quirk where one of the two ways to configure an identity domain does
> not work with ATS. If you have something like that as well then you
> have to switch ATS off if the IOMMU is in a state where it will not
> respond to it.
> 
> Otherwise, the HW I'm aware of uses ATS pretty selectively and it may
> not make any real difference..
> 
>>> I feel like we should leave "iommu: Move PRI enablement for VF to
>>> iommu driver" out for now, every driver needs this check?  AMD
>>> supports SVA and PRI so it needs it too.
>> Yes, agreed.
> Although, I'm wondering now, that check should be on the SVA paths as
> well as the iommufd path..

That appears to be a fix.

Thanks,
baolu

