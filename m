Return-Path: <kvm+bounces-38022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D272A33E8F
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 12:58:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A0DC53A3160
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 11:58:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 828C421D3FA;
	Thu, 13 Feb 2025 11:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OlIO4VkI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456FD207679;
	Thu, 13 Feb 2025 11:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739447883; cv=none; b=rYkUMrZyIcNEyeCwmEAQFKgdhMfujVBiBScuDq1x0I4JgsIDCqiGLznQNEEbjqL/+BdxPTg4F4fa6UMhcd7FQp/CeojANnir5h6SWW6YzetLcmGDBbJCTK40D1UJhvcUKcqwLwj4KM5s4/IfMd+ZVpYL2Yu2WsLverf5joiQMLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739447883; c=relaxed/simple;
	bh=AK+FKyMd7dfZt0G7tPDijdfr9CalJ0oWmocbmIdcgPo=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=OGJ843Vwd3vn+F+N7v8Kp4R05umIWijccLJ6HDi+YLMTFawSy1/5dExdJWynvF+VZmMVsUo8/iRcf+BBf2+v4SH+e6ZcKNoIFngJgi+bylwqFsrHGxzm3dGCiQkkpqqULFL78zKnPEOqlqz/B4hS3xam528kv3kLqxpEIk/F0Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OlIO4VkI; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739447883; x=1770983883;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=AK+FKyMd7dfZt0G7tPDijdfr9CalJ0oWmocbmIdcgPo=;
  b=OlIO4VkI+p5xONu2FQ0KpNRC/otp0aTLDqKnBtD+q8L1F1RkZZ14pXZv
   11I5DQ5atYrkcyqiZZ5stzS3gaVUGMEEI/jcdnv8W2ehe1P7uZXE+j0h9
   9aBUdnTE9dRyE9uvHG9j32LAJRtnRhsuhl5I7kJwUXdWHKllmREfYHrGP
   2PNLCUPWU/ziRs6yWkgOiS1wCAMcEaXGcL0jCkdUH5i4PYoXtZNRdHMj6
   9qUApA8e77moX0T6O25mYHCFwzavJmtAbRtrWTGz5LRx3PYwKxoadQWms
   XJl2D1WOsJe1ihuJtZhYKR8SpBKyNoDZ1aC9jSTcH/GnLGfyY5XkFcOHs
   g==;
X-CSE-ConnectionGUID: ab7wKM7kS8+aPDzjwNi9rA==
X-CSE-MsgGUID: +7volaKKQ86YpXibIAqFFQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="40261274"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="40261274"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2025 03:58:02 -0800
X-CSE-ConnectionGUID: sqjDCNoHTtaIhPm2Z1Mc8A==
X-CSE-MsgGUID: 62i6si6lRmG0UymwlyBHRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="118060259"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.124.242.149]) ([10.124.242.149])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2025 03:57:56 -0800
Message-ID: <f7b6c833-b6c1-4154-9b77-13553e501f2b@linux.intel.com>
Date: Thu, 13 Feb 2025 19:57:51 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, Zhangfei Gao <zhangfei.gao@linaro.org>,
 acpica-devel@lists.linux.dev, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, Len Brown <lenb@kernel.org>,
 linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
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
Subject: Re: [PATCH v4 00/12] Initial support for SMMUv3 nested translation
To: Jason Gunthorpe <jgg@nvidia.com>
References: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
 <20241112182938.GA172989@nvidia.com>
 <CABQgh9HOHzeRF7JfrXrRAcGB53o29HkW9rnVTf4JefeVWDvzyQ@mail.gmail.com>
 <20241113012359.GB35230@nvidia.com>
 <9df3dd17-375a-4327-b2a8-e9f7690d81b1@linux.intel.com>
 <20241113164316.GL35230@nvidia.com>
 <6ed97a10-853f-429e-8506-94b218050ad3@linux.intel.com>
 <20241115175522.GA35230@nvidia.com> <20250122192622.GA965540@nvidia.com>
 <284dd081-8d53-45ef-ae18-78b0388c98ca@linux.intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <284dd081-8d53-45ef-ae18-78b0388c98ca@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025/2/5 11:45, Baolu Lu wrote:
> On 2025/1/23 3:26, Jason Gunthorpe wrote:
>> On Fri, Nov 15, 2024 at 01:55:22PM -0400, Jason Gunthorpe wrote:
>>>>> I need your help to remove IOMMU_DEV_FEAT_IOPF from the intel
>>>>> driver. I have a patch series that eliminates it from all the other
>>>>> drivers, and I wrote a patch to remove FEAT_SVA from intel..
>>>> Yes, sure. Let's make this happen in the next cycle.
>>>>
>>>> FEAT_IOPF could be removed. IOPF manipulation can be handled in the
>>>> domain attachment path. A per-device refcount can be implemented. This
>>>> count increments with each iopf-capable domain attachment and 
>>>> decrements
>>>> with each detachment. PCI PRI is enabled for the first iopf-capable
>>>> domain and disabled when the last one is removed. Probably we can also
>>>> solve the PF/VF sharing PRI issue.
>>> Here is what I have so far, if you send me a patch for vt-d to move
>>> FEAT_IOPF into attach as you describe above (see what I did to arm for
>>> example), then I can send it next cycle
>>>
>>> https://github.com/jgunthorpe/linux/commits/iommu_no_feat/
>> Hey Baolu, a reminder on this, lets try for it next cycle?
> 
> Oh, I forgot this. Thanks for the reminding. Sure, let's try to make it
> in the next cycle.

Hi Jason,

I've worked through the entire series. The patches are available here:

https://github.com/LuBaolu/intel-iommu/commits/iommu-no-feat-v6.14-rc2

Please check if this is the right direction.

Thanks,
baolu

