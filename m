Return-Path: <kvm+bounces-37292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D18D2A282F4
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 04:45:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B6DC1653EC
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 03:45:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3DBD2139CB;
	Wed,  5 Feb 2025 03:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ks7Pitsw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DCE1EB3E;
	Wed,  5 Feb 2025 03:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738727128; cv=none; b=Set6nNJ46/gpH2ikDhZPp5pBc2fv1wq6lBGmF5YEWH7qG7nCGvY+ZoJrHhtX+GnWjsbLG8hHNxzC/mP8FXSZs2+ND2gLHNn9qn0bZ+rMjWTGFXFKT+PipFl1EhlGavuDGhi/h55VN/ZJQaj0XZ8G+MnTE5qRaCfddP6VxtNllGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738727128; c=relaxed/simple;
	bh=MLaFTGCPEcg9NYXwrgf9SMfKqQ9G+0WJl/NqM7xYYn8=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=WMqNd43zSyZSAkYLZnh6w0hykn9hdxzacekF81BCezmQjrNMcZ2uDkb/ZkbcqBt3csp0LAPrnFAQNCzLcshk/1uQM0bFFkbdnDJrdvY/VACfYJtGItfaZkeujNVutnUQL+Tw4MtcbyJ2uDBanybxkUAbtky/RsMpZXU7+HXN0Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ks7Pitsw; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738727125; x=1770263125;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MLaFTGCPEcg9NYXwrgf9SMfKqQ9G+0WJl/NqM7xYYn8=;
  b=ks7Pitsw8DQYqLAPWG2p8sHcmQGGzieIkiMBtZsUAR3VCrhIY39PP/0e
   9HbgWGg+LBZOzs+0/DWRJWjeNJQ2btNXfMjcdUy5e8wXUPyc4x/H53vQr
   DypmzCHWAbs3bRTLNM48DRddBLaJ7dUmvab1nYkCp3RMBP1yuHD9Eqf3/
   E4H77rBAEohkS+Ch/+LkL2evqK8usU3vKn2/pWcq24KH4Aa/DYy8kRvWn
   1pPFiTOOkpYLWtJxSObD97tEyAbzzQPkfSSLkD8jdRyvglszAB/TnrH23
   Tu4n6GMNZwdttR2H1lFt/3rxmYGaJsBAZMOcUp0xzg7d8NApQlL/HMips
   g==;
X-CSE-ConnectionGUID: EWUCJWFyQZyEWvDZSq+mUw==
X-CSE-MsgGUID: +m3zM5n1RNOuFW+pTAp/gQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11336"; a="39165402"
X-IronPort-AV: E=Sophos;i="6.13,260,1732608000"; 
   d="scan'208";a="39165402"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2025 19:45:25 -0800
X-CSE-ConnectionGUID: WpR9JSfURxSI/IIjqWagHg==
X-CSE-MsgGUID: qbIxOqA5Tj+fNgVN36xa1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,260,1732608000"; 
   d="scan'208";a="141642470"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.124.242.149]) ([10.124.242.149])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2025 19:45:18 -0800
Message-ID: <284dd081-8d53-45ef-ae18-78b0388c98ca@linux.intel.com>
Date: Wed, 5 Feb 2025 11:45:15 +0800
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
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20250122192622.GA965540@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025/1/23 3:26, Jason Gunthorpe wrote:
> On Fri, Nov 15, 2024 at 01:55:22PM -0400, Jason Gunthorpe wrote:
>>>> I need your help to remove IOMMU_DEV_FEAT_IOPF from the intel
>>>> driver. I have a patch series that eliminates it from all the other
>>>> drivers, and I wrote a patch to remove FEAT_SVA from intel..
>>> Yes, sure. Let's make this happen in the next cycle.
>>>
>>> FEAT_IOPF could be removed. IOPF manipulation can be handled in the
>>> domain attachment path. A per-device refcount can be implemented. This
>>> count increments with each iopf-capable domain attachment and decrements
>>> with each detachment. PCI PRI is enabled for the first iopf-capable
>>> domain and disabled when the last one is removed. Probably we can also
>>> solve the PF/VF sharing PRI issue.
>> Here is what I have so far, if you send me a patch for vt-d to move
>> FEAT_IOPF into attach as you describe above (see what I did to arm for
>> example), then I can send it next cycle
>>
>> https://github.com/jgunthorpe/linux/commits/iommu_no_feat/
> Hey Baolu, a reminder on this, lets try for it next cycle?

Oh, I forgot this. Thanks for the reminding. Sure, let's try to make it
in the next cycle.

---
baolu

