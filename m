Return-Path: <kvm+bounces-38542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BDA70A3AF5E
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 03:13:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 593EB7A5FD6
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 02:12:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F3B215CD52;
	Wed, 19 Feb 2025 02:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j90eyoDB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D591386DA;
	Wed, 19 Feb 2025 02:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739931170; cv=none; b=NGSKgv4GmtgMHkTdSUJzZpTukbikcG4a4yeDQ8lx59683YyXcOHBIu5LxIM6QCt6KuF5QUpAquFZcrXJZZJNZO7ARKO/e43f8jHeUxrLihcbH7Oyiv3pUJg6Wl2ZAZE25NG9ysyE1NC2qbHRMHQvAzSzDUzau7CO/znZpnucKH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739931170; c=relaxed/simple;
	bh=L4dOu00QBkrvIlSABtaObxkMy1PBjMvwydaerJNjvtQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XmLyHM88Z/sGqmzG1wtqQ7Q35o8d38NbwXg0f0G+ItIKbnfwi82as2FdVTxSHYU3VAwqGOwLZLN3+NXFzjZleT9ipMt5dJUqJTsNRltwH3I8w4S7oQnWyoKWTBUPnDxR3YXEmr5Q3ARouPiJENn1UXzmyTN2t01LY0hsAuVUODg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j90eyoDB; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739931170; x=1771467170;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=L4dOu00QBkrvIlSABtaObxkMy1PBjMvwydaerJNjvtQ=;
  b=j90eyoDBC2Q7f1SecgsLlTAFjT0apoBfbNq6zFyXhptefxifO2VgPO2C
   hl97PiOlyeXz6+OwP8YIAgj77w59AdsvUxkliRMAeFvJBQiSTNCbYIxUj
   LfIkRekaKg1o5FcJddRMe9Ova5ugdjJkOxNnwjiWy+Hp5mW5AnRIfNt52
   zZK/bymJetvUtSMbysnB3knNDZjCeZyJ8JOaPc4kqSIGwWDX/tPNXJG6C
   gdFBUYmNEpi/tuiftsxxjORm3HyurEkNQhWJqD8RiJoluZawaAX8E2vsU
   bNB9j0GKOY6jPMwuxewtZLSMNwvsgKsHGgtlNLAi7TVWPmBgtI2Sv7Fgo
   w==;
X-CSE-ConnectionGUID: d9vXloPxReK7X7hVEnGBdw==
X-CSE-MsgGUID: /+5YwgbxSMC5oyoH1y4IhQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11348"; a="40780151"
X-IronPort-AV: E=Sophos;i="6.13,296,1732608000"; 
   d="scan'208";a="40780151"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 18:12:49 -0800
X-CSE-ConnectionGUID: wdkQ11ldTpOd1cV+PafJ1g==
X-CSE-MsgGUID: LjO0SyJ3SR+0TUso89+tqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,296,1732608000"; 
   d="scan'208";a="115096578"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 18:12:42 -0800
Message-ID: <f7e30bd8-ae1f-42fe-a8a6-2b448a474044@linux.intel.com>
Date: Wed, 19 Feb 2025 10:09:39 +0800
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
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20250218130333.GA4099685@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/18/25 21:03, Jason Gunthorpe wrote:
> On Sat, Feb 15, 2025 at 05:53:13PM +0800, Baolu Lu wrote:
>> On 2/14/25 20:41, Jason Gunthorpe wrote:
>>> On Fri, Feb 14, 2025 at 01:39:52PM +0800, Baolu Lu wrote:
>>>
>>>> When the IOMMU is working in scalable mode, PASID and PRI are supported.
>>>> ATS will always be enabled, even if the identity domain is attached to
>>>> the device, because the PASID might use PRI, which depends on ATS
>>>> functionality. This might not be the best choice, but it is the
>>>> simplest and functional.
>>> The arm driver keeps track of things and enables ATS when PASIDs are
>>> present
>> I am not aware of any VT-d hardware implementation that supports
>> scalable mode but not PASID. If there were one, it would be worthwhile
>> to add an optimization to avoid enabling ATS during probe if PASID is
>> not supported.
> I mean domains attached to PASIDs that need PRI/ATS/etc

Yeah, that's a better solution. The PCI PRI/ATS features are only
enabled when a domain that requires them is attached to it. I will
consider it in the Intel driver later.

>>> Although, I'm wondering now, that check should be on the SVA paths as
>>> well as the iommufd path..
>> That appears to be a fix.
> Does SVA have the same issue?

One case I can think of is SVA on SR-IOV VFs. Without the in-progress
iopf refcount patch series, enabling and disabling iopf could be
problematic, because all PRI enablement is switched in the PF, it's
possible that enable and disable operations won't be paired correctly.

Another issue is that a failure or invalid page group response may halt
the PRI interface, which would cause SVA on other VFs to stop working.

So, we should probably disable SVA on VFs for now and re-enable it after
all these issues are resolved.

Thanks,
baolu

