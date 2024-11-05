Return-Path: <kvm+bounces-30595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A84E59BC384
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 04:02:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6609D281D15
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 03:02:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0ED25674D;
	Tue,  5 Nov 2024 03:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UdTaG4G1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 591BB225A8
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 03:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730775731; cv=none; b=Ujf9m+nSK9TJuv1G3wTrKbaDSE/NP2vfwRE8JwwtjGNW38NrS5PjUU1t8OosgC+Q/ips5+yHREga8d62gw5+3M3I4fVXcfD48/Y80SzIUUYgGl19j6GNdl3ozdSPzZILQ6cZVtww2LBHdhjvBc+lrZSPiqI/WY+2RD8VT0+H5nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730775731; c=relaxed/simple;
	bh=xOyHRk6dZ370hSDPEJqFXnvrXVt9qVejZl6TH92mHgQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tCY01pAzbOa3UWKXtLxONUFd3Z+ET6io2y9EayaTUe+fmkCUmY4pqQpr3Uxhop9LI3ULalOhe4kRsu5Edi54CMiZAMjwUR3NRuO7N3Oss4aYsXeHAkuqMeK5W78V5ic0ZRKBGdRreYyw3ZsWibPN1WHtXV3LVQ8lWBw0Ovuo3/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UdTaG4G1; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730775728; x=1762311728;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xOyHRk6dZ370hSDPEJqFXnvrXVt9qVejZl6TH92mHgQ=;
  b=UdTaG4G1mkWonQInF05l6546sZSRDeYm5XP+os+Err5S9cd+N0ctPIPL
   V1OrvjdFSFWK30qJe8MN9/QznpKMPISqLnBufklX2nq4Jxh3fHupOCS/a
   ZwxZ2GncM0N1z3OCoi8aJH1xv3Fx6JIbX7NkH/YSXaRd+Cr8H45O2S+tE
   O27SRbN2GqwGBVnYxGu2kZgTJXEH3y3SbSQCt8+OvP5l7YXeFsZWk7e7x
   kKU/pp9bKYRKu/B7qI/z9GK6Y1a3wmblxXPlB7jVcC8YvZMqFQIFhsYjI
   BUgfKiF7tKYiV4rfaCH4ZPKO3qhby7zB7Q74TMbvjSxWbhJ8BDtjrbRRN
   Q==;
X-CSE-ConnectionGUID: hnriVW0OTIC9VFBdyjVl5A==
X-CSE-MsgGUID: xN+vFoK/RmSfeGlfrSotmg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41608565"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41608565"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 19:02:07 -0800
X-CSE-ConnectionGUID: yE2RGwAFRe6jSTePUNMYZg==
X-CSE-MsgGUID: gTkP07R1QtCyUgp6Rr62Vg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,258,1725346800"; 
   d="scan'208";a="83739207"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 19:00:10 -0800
Message-ID: <f82a51fa-ae70-435c-a633-a5423819335d@linux.intel.com>
Date: Tue, 5 Nov 2024 10:59:23 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/13] iommu/vt-d: Make intel_iommu_set_dev_pasid() to
 handle domain replacement
To: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, jgg@nvidia.com,
 kevin.tian@intel.com
Cc: alex.williamson@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
 kvm@vger.kernel.org, chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
 zhenzhong.duan@intel.com, vasant.hegde@amd.com, will@kernel.org
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-7-yi.l.liu@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20241104131842.13303-7-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/24 21:18, Yi Liu wrote:
> Let intel_iommu_set_dev_pasid() call the pasid replace helpers hence be
> able to do domain replacement.
> 
> Signed-off-by: Yi Liu<yi.l.liu@intel.com>
> ---
>   drivers/iommu/intel/iommu.c | 17 +++++++++++------
>   drivers/iommu/intel/pasid.h | 11 +++++++++++
>   2 files changed, 22 insertions(+), 6 deletions(-)

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

