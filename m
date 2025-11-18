Return-Path: <kvm+bounces-63488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A928C679B7
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 06:45:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9E0FD364B86
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 05:43:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 789BE2BE033;
	Tue, 18 Nov 2025 05:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eCi2ciKB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CA12C375A;
	Tue, 18 Nov 2025 05:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763444582; cv=none; b=nBf6bQNSr3Rs9hbJiYzLMac+PoU1UMSzJ6+eJ29290gR106vpp5T3YKFbf3YS48Srv6NaQuDXbVVIJ0trppYXNYKNS9FDuZtAyQA5zN+ywIYs6pL3QflgSU5fo1EwB9yOUiKdSOSO0slCpG3v7guzPUEbljUnIIOEfu4vKZUHuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763444582; c=relaxed/simple;
	bh=VbFlU1LcdUBsBT5iUvR+tT4oc46fne2Q1MslnRGjrXM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d9Ok7MiFJfUvtFkb4rVNuYnf3YhMBc+wGIhYQKs/HPp1ILRP7MDlKdRz7CRxYFfSCrsGTZieGQtLzmvoBOo9ewWTWqVj4OTF5ItupvxZzvKgoPC110q7+GqWOGAYfDw76Bxal6Ydm2W64y/yzc2Hr6oeOLWG1CQS7Jw4VmgHQrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eCi2ciKB; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763444580; x=1794980580;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VbFlU1LcdUBsBT5iUvR+tT4oc46fne2Q1MslnRGjrXM=;
  b=eCi2ciKB9b7KgkNk1jfw9VcYsjglAW0ZAh3w2F7Cnm+PkwaBC8qO4byX
   00Z6auwQU2PTfrauR3L72Z/IdBuVfxM43i8lW2IKYiATSjLy2iwoYwu7G
   jugPt9oFB1ERW3+Z/EQig/YYYUGj/3AL+/KH7m5T9I2cHIvvf+u65UzZL
   gr1FLVj5jQeXSaFnFL+vlIsohr7Bmt8cU/QFiKY3t4HaJSbeEYaCX2jxr
   Zq3coVSrCKkQLgsBBs2UPd+ix8nWYeTPz5CvH3yUWn/3jKhxCtFroaEpy
   emql+5rSXtx43LYaN/tQKgRpZ3diBE92+M6enYd8z2e9KePLz2Mj5EABw
   A==;
X-CSE-ConnectionGUID: bslzijx8T1qhH02II5RoCA==
X-CSE-MsgGUID: jRi3erMBSuykmaoUU46cQg==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="53028423"
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="53028423"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 21:42:59 -0800
X-CSE-ConnectionGUID: g55xazAASY6gp1sqPcfseQ==
X-CSE-MsgGUID: 9IDYRVS6RdmXV8k/XcCKXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="189924294"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 21:42:54 -0800
Message-ID: <4eeda61a-c71d-4ad1-8ac7-a14942f7a864@linux.intel.com>
Date: Tue, 18 Nov 2025 13:38:40 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 5/5] pci: Suspend iommu function prior to resetting a
 device
To: Nicolin Chen <nicolinc@nvidia.com>, "Tian, Kevin" <kevin.tian@intel.com>
Cc: "joro@8bytes.org" <joro@8bytes.org>, "afael@kernel.org"
 <afael@kernel.org>, "bhelgaas@google.com" <bhelgaas@google.com>,
 "alex@shazbot.org" <alex@shazbot.org>, "jgg@nvidia.com" <jgg@nvidia.com>,
 "will@kernel.org" <will@kernel.org>,
 "robin.murphy@arm.com" <robin.murphy@arm.com>,
 "lenb@kernel.org" <lenb@kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
 "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "patches@lists.linux.dev" <patches@lists.linux.dev>,
 "Jaroszynski, Piotr" <pjaroszynski@nvidia.com>,
 "Sethi, Vikram" <vsethi@nvidia.com>, "helgaas@kernel.org"
 <helgaas@kernel.org>, "etzhao1900@gmail.com" <etzhao1900@gmail.com>
References: <cover.1762835355.git.nicolinc@nvidia.com>
 <a166b07a254d3becfcb0f86e4911af556acbe2a9.1762835355.git.nicolinc@nvidia.com>
 <BN9PR11MB52762516D6259BBD8C3740518CCAA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <aRduRi8zBHdUe4KO@Asurada-Nvidia>
 <BN9PR11MB52761B6B1751BF64AEAA3F948CC9A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <aRt2/0rcdjcGk1Z1@Asurada-Nvidia>
 <BN9PR11MB527649AD7D251EAAFDFB753A8CD6A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <aRvO9KWjWC5rk/Vx@Asurada-Nvidia>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <aRvO9KWjWC5rk/Vx@Asurada-Nvidia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/25 09:42, Nicolin Chen wrote:
> On Tue, Nov 18, 2025 at 12:29:43AM +0000, Tian, Kevin wrote:
>>> From: Nicolin Chen<nicolinc@nvidia.com>
>>> Sent: Tuesday, November 18, 2025 3:27 AM
>>>
>>> On Mon, Nov 17, 2025 at 04:52:05AM +0000, Tian, Kevin wrote:
>>>>> From: Nicolin Chen<nicolinc@nvidia.com>
>>>>> Sent: Saturday, November 15, 2025 2:01 AM
>>>>>
>>>>> On Fri, Nov 14, 2025 at 09:45:31AM +0000, Tian, Kevin wrote:
>>>>>>> From: Nicolin Chen<nicolinc@nvidia.com>
>>>>>>> Sent: Tuesday, November 11, 2025 1:13 PM
>>>>>>>
>>>>>>> +/*
>>>>>>> + * Per PCIe r6.3, sec 10.3.1 IMPLEMENTATION NOTE, software
>>> disables
>>>>> ATS
>>>>>>> before
>>>>>>> + * initiating a reset. Notify the iommu driver that enabled ATS.
>>>>>>> + */
>>>>>>> +int pci_reset_iommu_prepare(struct pci_dev *dev)
>>>>>>> +{
>>>>>>> +	if (pci_ats_supported(dev))
>>>>>>> +		return iommu_dev_reset_prepare(&dev->dev);
>>>>>>> +	return 0;
>>>>>>> +}
>>>>>> the comment says "driver that enabled ATS", but the code checks
>>>>>> whether ATS is supported.
>>>>>>
>>>>>> which one is desired?
>>>>> The comments says "the iommu driver that enabled ATS". It doesn't
>>>>> conflict with what the PCI core checks here?
>>>> actually this is sent to all IOMMU drivers. there is no check on whether
>>>> a specific driver has enabled ATS in this path.
>>> But the comment doesn't say "check"..
>>>
>>> How about "Notify the iommu driver that enables/disables ATS"?
>>>
>>> The point is that pci_enable_ats() is called in iommu drivers.
>>>
>> but in current way even an iommu driver which doesn't call
>> pci_enable_ats() will also be notified then I didn't see the
>> point of adding an attribute to "the iommu driver".
> Hmm, that's a fair point.
> 
> Having looked closely, I see only AMD and ARM call that to enable
> ATs. How others (e.g. Intel) enable it?

The VT-d driver enables ATS in the iommu probe_finalize() path (for
scalable mode).

static void intel_iommu_probe_finalize(struct device *dev)
{

[...]
         if (sm_supported(iommu) && !dev_is_real_dma_subdevice(dev)) {
                 iommu_enable_pci_ats(info);
                 /* Assign a DEVTLB cache tag to the default domain. */
                 if (info->ats_enabled && info->domain) {
                         u16 did = domain_id_iommu(info->domain, iommu);

                         if (cache_tag_assign(info->domain, did, dev,
                                              IOMMU_NO_PASID, 
CACHE_TAG_DEVTLB))
                                 iommu_disable_pci_ats(info);
                 }
         }

[...]
}

iommu_enable_pci_ats() will eventually call pci_enable_ats() after some
necessary checks.

Thanks,
baolu

