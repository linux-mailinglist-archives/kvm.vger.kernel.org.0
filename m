Return-Path: <kvm+bounces-38956-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DA13A40609
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 08:16:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E91A16EF9E
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 07:16:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67E6C20126C;
	Sat, 22 Feb 2025 07:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ShIdCDXL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8BC31E990D;
	Sat, 22 Feb 2025 07:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740208605; cv=none; b=uhG+YoegmaBitFII4gCdWoIMmFLp7ZSEYB4ScRMK7rYuErUwJqxOMW7J8wnu3PkS6BtgYfRFa+J+PFnyIcouezT+2raHRorjWwZqB3bM0wz1mUMrLSUb1frH/XrT4zUeBuirBvDQ4rCP6jpZmhZFOLjB5fZ4H4tFo60m1J+SbsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740208605; c=relaxed/simple;
	bh=ZM7H4zpo4oPld8ul0n31itvGzUfHuxoBESuSPa+QMS4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cplEmyHej7aY9ppaffed6AErZIw+eSFTeAuvKLJAMwx1I8beBDMmR+DkCAfPLXlsobJckUK5EB7XD0lqbCq8JSmMcICPPz1FGd9IUfSOsVdJJtA4AVikYdmmHo2NvkCidScJpYR9hIVZpY2hVD6Aa+0aFelLTbSSZv0GC5m9Jos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ShIdCDXL; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740208604; x=1771744604;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZM7H4zpo4oPld8ul0n31itvGzUfHuxoBESuSPa+QMS4=;
  b=ShIdCDXLumsPrkUHvHUJmEqZ8YpD06pAcG39q+NwyJ3Rd4ZJKaSX1t7p
   a1FZkZ5ulsng2hIBDyGazrD1csLmr34V51yCao3n1H4BVMPvfG2yB8r+G
   1AKUYHa9U0b+3T92RfhAj/jHM38rTCj+otuMJT5pu9uuJvvgq9UYXj36K
   zNxYr6u00r8EJoCDC2GM8ePomkZq9jv2jD+K+N5cgY9rYjRhCHPlO6uaw
   /SFLgx5kqqxtX0tpy/kM7ShvXa7ACkzD4NI31kzysYkoloFoEFdeBA8j+
   /MVrRVgBQilbtNJxi7E6my9pucA5iKq/UitZ9JkCbcgNSB486VOV4rEPv
   w==;
X-CSE-ConnectionGUID: DPcvpXcySd2efdVa3QeJvw==
X-CSE-MsgGUID: +tZdqhHbSvq278ITgCCquQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11352"; a="44941338"
X-IronPort-AV: E=Sophos;i="6.13,307,1732608000"; 
   d="scan'208";a="44941338"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 23:16:43 -0800
X-CSE-ConnectionGUID: /ptGdvWFQeWGeHLVxpGlKg==
X-CSE-MsgGUID: iQrwTD+nRputVAuyNG/vJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,307,1732608000"; 
   d="scan'208";a="146417233"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 23:16:37 -0800
Message-ID: <ff5ecf47-75ce-4c8b-a8f5-94ea8ec7ad87@linux.intel.com>
Date: Sat, 22 Feb 2025 15:13:28 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/12] Initial support for SMMUv3 nested translation
To: Jason Gunthorpe <jgg@nvidia.com>, "Tian, Kevin" <kevin.tian@intel.com>
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
References: <bc9f4477-7976-4955-85dc-3e05ebe95ead@linux.intel.com>
 <20250214124150.GF3886819@nvidia.com>
 <58e7fbee-6688-4a49-8b7a-f0e81e6562db@linux.intel.com>
 <20250218130333.GA4099685@nvidia.com>
 <f7e30bd8-ae1f-42fe-a8a6-2b448a474044@linux.intel.com>
 <BN9PR11MB5276EAD07C3B32517D339DF28CC52@BN9PR11MB5276.namprd11.prod.outlook.com>
 <7027fb3a-dfb4-40ae-ac9c-5ea1dcd57746@linux.intel.com>
 <BN9PR11MB52764E131435DF44370653CD8CC42@BN9PR11MB5276.namprd11.prod.outlook.com>
 <c57977e2-d109-4a38-903e-8af6a7567a60@linux.intel.com>
 <BN9PR11MB527644D4478318D4DE0E027A8CC72@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20250221130457.GI50639@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20250221130457.GI50639@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/21/25 21:04, Jason Gunthorpe wrote:
> On Fri, Feb 21, 2025 at 04:28:50AM +0000, Tian, Kevin wrote:
>>> With PASID support, multiple domains can be attached to the device, and
>>> each domain may have different ATS requirements.  Therefore, we cannot
>>> simply determine the ATS status in the RID domain attach/detach paths. A
>>> better solution is to use the reference count, as mentioned above.
>>>
>> Okay, that helps connect the dots and makes sense to me. Thanks!
> I also have this general feeling that using ATS or not should be some
> user policy (ie with sysfs or something) not just always automatic..

Agreed. ATS is inherently insecure because it allows a device to
directly access system memory using translated requests. A malicious
device could exploit this to compromise the system. Currently, Linux
prevents ATS from being enabled on devices with pci_dev->untrusted set.
But this seems insufficient, as only devices connected to external-
facing ports are currently marked as untrusted. It would be preferable
to allow the user to determine which devices are trusted and, therefore,
permitted to use ATS.

Some IOMMU architectures have introduced new features to enhance the
security of ATS, such as the host permission table in VT-d v5.0. This
could be an interesting topic when considering its implementation in the
Linux kernel.

> Right now on our devices there is a firmware config that hides the ATS
> support from PCI config space and the general guidance is to only turn
> it on in very specific situations.

Thanks,
baolu

