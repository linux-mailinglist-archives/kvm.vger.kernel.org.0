Return-Path: <kvm+bounces-29240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16B079A5A34
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 08:13:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 53F26B215A6
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 06:13:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC4971946A8;
	Mon, 21 Oct 2024 06:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JICetIet"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE0122315
	for <kvm@vger.kernel.org>; Mon, 21 Oct 2024 06:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729491212; cv=none; b=HoTzJN9Qyo0swSTWagv3UACGlFyuh/oZwpHvexLrXlXnBSGevBnAii2VgsM1k+Qhhz+B2OzNJcPUCJ3/dulS0Mimn28RlIoldXi56pT3NhwkRQi6BfOPf8gd7zrfDqpye29aOjhE38+ivN50Dvs2C08rRX5AJyhcnVZhNS6g4Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729491212; c=relaxed/simple;
	bh=kE4s4ia/ePvu7tqGe6brV3A8wvm6kR6MH1H5dOa2Fvc=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=F3Z/6JZbzRftJUkZ8U+m9WAVyrVvm4YdS/YtpxwLKeUl3M0p7GYttwK+007qgy/fp7Dt2vIf2sMZFe01D5eN8ANDpp+V4Uqmwf86Wl8h0H8Dq5Yfaeb6CViWMtlaWT2KJTjh/+PT1SOJBnS0RG4jeout2zMxQwwfeS6CYGb53Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JICetIet; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729491212; x=1761027212;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=kE4s4ia/ePvu7tqGe6brV3A8wvm6kR6MH1H5dOa2Fvc=;
  b=JICetIetbdXVNN5LgYjQPayj+QWjDH39SUNP2PxYSE793adrR910o1dM
   QANMKHmmF1mSNwApUClihdJ/ggiRckaZURd9JXBEKnd85c/06ryzN66wP
   NSu1f37kxFcM8IqoxEjN8+vPST3ibzUOfOBhDYfJz3xi74QbdK1m0HhyI
   4hXrmz61OwUW3OG1fV8S/Sjx59HSsxO72L1g4lvdsh4eulXh8oLXMmSBd
   ZYRUYYbcLDUz/qVYx+MdFPGw4CBGeCIGxUEj970uqEFDJ3+G36LFXeVlc
   5q8nSBH0ZIGPTBvbvSC64A1OCEn7KMaA5Ph58bOxIlzNtswgT9dImX9+5
   w==;
X-CSE-ConnectionGUID: DI0cv3jRRcy/lIrz1qdBhg==
X-CSE-MsgGUID: HSRG9gtHQ3SuKd+VzmQ/8g==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="29129875"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="29129875"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2024 23:13:31 -0700
X-CSE-ConnectionGUID: o1gXP6s7Ta6XWnvjYbw7sA==
X-CSE-MsgGUID: MFmqKEB2SYy8DPW4iKpkbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,220,1725346800"; 
   d="scan'208";a="84018999"
Received: from unknown (HELO [10.238.0.51]) ([10.238.0.51])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2024 23:13:27 -0700
Message-ID: <e5cd1de4-37f7-4d55-aa28-f37d49d46ac6@linux.intel.com>
Date: Mon, 21 Oct 2024 14:13:25 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, alex.williamson@redhat.com,
 eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
 chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
 zhenzhong.duan@intel.com, vasant.hegde@amd.com
Subject: Re: [PATCH v3 3/9] iommu/vt-d: Let intel_pasid_tear_down_entry()
 return pasid entry
To: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, jgg@nvidia.com,
 kevin.tian@intel.com, will@kernel.org
References: <20241018055402.23277-1-yi.l.liu@intel.com>
 <20241018055402.23277-4-yi.l.liu@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20241018055402.23277-4-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024/10/18 13:53, Yi Liu wrote:
> intel_pasid_tear_down_entry() finds the pasid entry and tears it down.
> There are paths that need to get the pasid entry, tear it down and
> re-configure it. Letting intel_pasid_tear_down_entry() return the pasid
> entry can avoid duplicate codes to get the pasid entry. No functional
> change is intended.
> 
> Signed-off-by: Yi Liu<yi.l.liu@intel.com>
> ---
>   drivers/iommu/intel/pasid.c | 11 ++++++++---
>   drivers/iommu/intel/pasid.h |  5 +++--
>   2 files changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
> index 2898e7af2cf4..336f9425214c 100644
> --- a/drivers/iommu/intel/pasid.c
> +++ b/drivers/iommu/intel/pasid.c
> @@ -239,9 +239,12 @@ devtlb_invalidation_with_pasid(struct intel_iommu *iommu,
>   /*
>    * Caller can request to drain PRQ in this helper if it hasn't done so,
>    * e.g. in a path which doesn't follow remove_dev_pasid().
> + * Return the pasid entry pointer if the entry is found or NULL if no
> + * entry found.
>    */
> -void intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct device *dev,
> -				 u32 pasid, u32 flags)
> +struct pasid_entry *
> +intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct device *dev,
> +			    u32 pasid, u32 flags)
>   {
>   	struct pasid_entry *pte;
>   	u16 did, pgtt;
> @@ -250,7 +253,7 @@ void intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct device *dev,
>   	pte = intel_pasid_get_entry(dev, pasid);
>   	if (WARN_ON(!pte) || !pasid_pte_is_present(pte)) {
>   		spin_unlock(&iommu->lock);
> -		return;
> +		goto out;

The pasid table entry is protected by iommu->lock. It's  not reasonable
to return the pte pointer which is beyond the lock protected range.

Thanks,
baolu

