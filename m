Return-Path: <kvm+bounces-13415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 688778962BC
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 04:58:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23449288500
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 02:58:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A8D01BDCF;
	Wed,  3 Apr 2024 02:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d3uhIcyf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D231BC3C
	for <kvm@vger.kernel.org>; Wed,  3 Apr 2024 02:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712113063; cv=none; b=PtMyvjtVOAt3jNpBPcWEdI4udT6i/Stg3ZdFOS0l+MC3wIaS+RwdrrlhftYWk2lbwrNzQRcEXDKLY5s1xX3n71k8iZ+/KmO5saWd4uOFEIePyOnpXcZOqew508B3MORao/E/DRiLtFIxxSuHGIR4lqIi2lvc/N28ukL8CA9ZQew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712113063; c=relaxed/simple;
	bh=EZG5B5nQA7tIQjM2mjKjMtuTZET9KVGrMdjZG712+CI=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=nKwqGyRm/rlHZBlDpgpZ4WLLWqpFbTRTk6TXpI9w4u4OBJXqRB9RhzH8OOtU8h2B21qF5joAYSvnRjlSBo7F4CGrpYVkz5MCxx16rJp+Xsnrs+pg4h9ADpLWQIbU21PbZznMocr/5KnNeu3aO5EqL7fMrKFu0JjYvNWKnCJfEnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d3uhIcyf; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712113062; x=1743649062;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=EZG5B5nQA7tIQjM2mjKjMtuTZET9KVGrMdjZG712+CI=;
  b=d3uhIcyf+ET3wT8fSM71sr9GdBB2CNTCcqq3ehk8iC46lj2ozUsYSLqp
   AFUrm9u/7aovpHqSwFolkkPD3QkC6xu1u0DWaolrDLy/nDYO+D7NgxQzE
   AXmiy0fme7ZsT0BB6u/eZ+Jk91B+YkNoThTje5rVmXy/U+3DaTcsUHSVZ
   +e8ZxR2St+vMTVcYFLmCbF0ZIRu2tuN/yJ4Bpy6osE4CUJCjAHWmI4cga
   vCtGlLZBuTyFjQ04aU/n32ccA11iCcPzrAEQxQI3lujXx/qMF5WibFAkj
   bvfll41ehWdaPhL4avkexRP9C9MLC5CbzKxjpXfb84QgAC5o+rsHmg/jl
   Q==;
X-CSE-ConnectionGUID: wdV0H+ElR3yt23MhjdcReg==
X-CSE-MsgGUID: iJqGNXZwT8+9UeFRelXzuA==
X-IronPort-AV: E=McAfee;i="6600,9927,11032"; a="10292039"
X-IronPort-AV: E=Sophos;i="6.07,176,1708416000"; 
   d="scan'208";a="10292039"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2024 19:57:41 -0700
X-CSE-ConnectionGUID: VuTP63v/QsaOd/tQxDxVzw==
X-CSE-MsgGUID: ip8kNLhtRVm33HlrdTUQ2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,176,1708416000"; 
   d="scan'208";a="18866882"
Received: from allen-box.sh.intel.com (HELO [10.239.159.127]) ([10.239.159.127])
  by orviesa008.jf.intel.com with ESMTP; 02 Apr 2024 19:57:38 -0700
Message-ID: <a1766e58-eef6-482d-a401-7fbfe6063023@linux.intel.com>
Date: Wed, 3 Apr 2024 10:56:38 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com,
 "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
 "robin.murphy@arm.com" <robin.murphy@arm.com>,
 "eric.auger@redhat.com" <eric.auger@redhat.com>,
 "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
 "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
 "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: Re: [PATCH v2 0/2] Two enhancements to
 iommu_at[de]tach_device_pasid()
To: "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
 "Liu, Yi L" <yi.l.liu@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
 "jgg@nvidia.com" <jgg@nvidia.com>, "Tian, Kevin" <kevin.tian@intel.com>
References: <20240328122958.83332-1-yi.l.liu@intel.com>
 <SJ0PR11MB674441C2652047C02276FC25923A2@SJ0PR11MB6744.namprd11.prod.outlook.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <SJ0PR11MB674441C2652047C02276FC25923A2@SJ0PR11MB6744.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/29/24 10:12 AM, Duan, Zhenzhong wrote:
> 
>> -----Original Message-----
>> From: Liu, Yi L<yi.l.liu@intel.com>
>> Subject: [PATCH v2 0/2] Two enhancements to
>> iommu_at[de]tach_device_pasid()
>>
>> There are minor mistakes in the iommu set_dev_pasid() and
>> remove_dev_pasid()
>> paths. The set_dev_pasid() path updates the group->pasid_array first, and
>> then call into remove_dev_pasid() in error handling when there are devices
>> within the group that failed to set_dev_pasid.
> Not related to this patch, just curious in which cases some of the devices
> In same group failed to set_dev_pasid while others succeed?

The failure cases could be checked in the set_dev_pasid implementation
of the individual iommu driver. For x86 platforms, which are PCI fabric-
based, there's no such case as PCI/PASID requires a singleton iommu
group.

Best regards,
baolu

