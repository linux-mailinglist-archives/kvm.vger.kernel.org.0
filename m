Return-Path: <kvm+bounces-14618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FD2B8A47A8
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 07:42:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F13621F21527
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 05:42:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B21B26112;
	Mon, 15 Apr 2024 05:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="idegHLTM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE48513ACC
	for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 05:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713159769; cv=none; b=KaykgvyYE62X38SGGP3Vg5LBoNl+Zr3VLDIW6o3Yd3tOM4Mk3HDQv/+tFDX9jwa61KQXMiQan8ZneiEY8aGYhLh6zsZkvj6/YwpyITLf2d306s+hBoH8ocrMJA3zf8hM6XQ4vHjiBd0VF8pKEtRimoYbviPU7DIN8yVnIZIT4No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713159769; c=relaxed/simple;
	bh=g5Jwzx+Dn1GMv0Q7npxV2EEHHFQik6iAi5DAXG8vk0w=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=nJJXva+qmon9BQquVzj6CB//lEa69ZL/iMtiD7l3phWsW3LQwqfV4c337OnXbbuVPnkLzob+mttXv89NE9O382Kto/4UE8JQpZl1GQ/kTjruerDNrBGsKLqGcuchmPoZudrNQ9cU0VqmuKJFn2/uUodTXnWZDaz654OkeH91nUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=idegHLTM; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713159769; x=1744695769;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=g5Jwzx+Dn1GMv0Q7npxV2EEHHFQik6iAi5DAXG8vk0w=;
  b=idegHLTMWczO2GGRTvyJj1iNk0y5rHnSUyWDeA4V8fGEJ3ldzNigIMvq
   ewyqBgmXl9hdIKLKzaFSL3nfNI0K4Tdu3txJ7cNGLAUFpfGFlCf0R4mxG
   se0i6j73McUaGgWbnkuShkajOAbvE3jGlVfpeoslLw+AzWcO4vuES/czV
   rNkKfwk2TFj7Eei6xro3Yyyw5jf9F7hZGoB385ZmG4AFY+Le0vhdLiFfp
   GG4SBBgDuctMIlQKxZ5sKH54haUBX3pVq8GqLn8jz7GDPco2jRtiVt6Yn
   BmrkkfGJCrua9SQZNY/XFDdYgmEwP8WBhZZo10Lk4bp/JlYd9kqctuWJg
   w==;
X-CSE-ConnectionGUID: zWCk4A9xRnKd9z40DvSBHA==
X-CSE-MsgGUID: Pp9DpRJ1T7WsvL3bI+bkeg==
X-IronPort-AV: E=McAfee;i="6600,9927,11044"; a="19677435"
X-IronPort-AV: E=Sophos;i="6.07,202,1708416000"; 
   d="scan'208";a="19677435"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2024 22:42:49 -0700
X-CSE-ConnectionGUID: Ggu9fiY5R3K00aE/E5KEQA==
X-CSE-MsgGUID: Cx8KC/HXS3+Bt2qNGHJVHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,202,1708416000"; 
   d="scan'208";a="22377388"
Received: from unknown (HELO [10.239.159.127]) ([10.239.159.127])
  by orviesa008.jf.intel.com with ESMTP; 14 Apr 2024 22:42:45 -0700
Message-ID: <ef76c9bc-cafb-43a8-9b1c-f832043b8330@linux.intel.com>
Date: Mon, 15 Apr 2024 13:41:32 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, alex.williamson@redhat.com,
 robin.murphy@arm.com, eric.auger@redhat.com, nicolinc@nvidia.com,
 kvm@vger.kernel.org, chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
 zhenzhong.duan@intel.com, jacob.jun.pan@intel.com
Subject: Re: [PATCH v2 05/12] iommu: Allow iommu driver to populate the
 max_pasids
To: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, jgg@nvidia.com,
 kevin.tian@intel.com
References: <20240412081516.31168-1-yi.l.liu@intel.com>
 <20240412081516.31168-6-yi.l.liu@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20240412081516.31168-6-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/12/24 4:15 PM, Yi Liu wrote:
> Today, the iommu layer gets the max_pasids by pci_max_pasids() or reading
> the "pasid-num-bits" property. This requires the non-PCI devices to have a
> "pasid-num-bits" property. Like the mock device used in iommufd selftest,
> otherwise the max_pasids check would fail in iommu layer.
> 
> While there is an alternative, the iommu layer can allow the iommu driver
> to set the max_pasids in its probe_device() callback and populate it. This
> is simpler and has no impact on the existing cases.
> 
> Suggested-by: Jason Gunthorpe<jgg@nvidia.com>
> Signed-off-by: Yi Liu<yi.l.liu@intel.com>
> ---
>   drivers/iommu/iommu.c | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)

The code does not appear to match the commit message here.

The code in change is a refactoring by folding the max_pasid assignment
into its helper. However, the commit message suggests a desire to expose
some kind of kAPI for device drivers.

Best regards,
baolu

