Return-Path: <kvm+bounces-20664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 14AA791BBE7
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 11:52:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B3C921F21EE4
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 09:52:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 088CD15443B;
	Fri, 28 Jun 2024 09:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iMxdY2S2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A050815382F
	for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 09:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719568335; cv=none; b=kOCCn0q3TlSIbGwaHc7c12pqaxsWDThXb3x1NhqioiVi/XggjBY4rHqxyPxwB+C+qZBGZF572GK44Rf33eWTV5JTyiA6xdmZKdPy1XOgGv5iitq/Du75xi7Ww4G7XfkQe+NxlAeOo4iuCX5GRIeSGCQnsHx9Ss6RX96Ee5vYpVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719568335; c=relaxed/simple;
	bh=bHCsNfwADDIPZKA9xOh9MpedbmFnGolru6X2sK0qgEo=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=PHYYM/SCc0TPhbaSwl0fuQZ10f3Fz8GRSmS2wlu4bDyFa9XM3ES2SyITYHREAzk79De2pTUP6nY9Ery/us3B6/cQsUFjlpqWc/ieD+BZT9/gRBToyWlHpQwSBDiPCPoIinq2NY8ygjAsUzEsTRgSc0Nkw86dSndPkKnlWH94Jxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iMxdY2S2; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719568332; x=1751104332;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bHCsNfwADDIPZKA9xOh9MpedbmFnGolru6X2sK0qgEo=;
  b=iMxdY2S2TucPlvky/LNBEMAI88J6ukuxoMDvniGQVV5/D4dFHKfVNXfo
   Z81rmuiU+J6R/7qkoAo5U4Ijf63FScgn8rcgYHug8J8qTFeeAVFpg12E6
   yF+q0ftxd7paixn3w3mkUU8OecrY3506uXPZXrHTH094ypie5Jm1UMmm4
   3z9QBHeVQHg1qsk5hz0yTqvXbFRt9lzV+tqc1aptq/mrLKQuSLZOJRZjH
   DtzczffNWKGfeAhM2EQQHWp9v6zAReg/AOJ5rHGQlUKMW2H8rp7KCv2Qt
   X1ywr22gQtzlnP7UhF3PSZWiikrrNGCg4PiDp5h/EM1fwCLU/VpHPQ/5n
   Q==;
X-CSE-ConnectionGUID: TdEVg9a0RPSBLem0CPdSlg==
X-CSE-MsgGUID: WuRL7AWQQ9yjqQd5AVg4XA==
X-IronPort-AV: E=McAfee;i="6700,10204,11116"; a="20617195"
X-IronPort-AV: E=Sophos;i="6.09,168,1716274800"; 
   d="scan'208";a="20617195"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2024 02:52:12 -0700
X-CSE-ConnectionGUID: bGWW7UWTRHSmsbPjZGmFdQ==
X-CSE-MsgGUID: ZfN95a0LTAqFpPrf5jq7Rg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,168,1716274800"; 
   d="scan'208";a="49868937"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.125.248.220]) ([10.125.248.220])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2024 02:52:09 -0700
Message-ID: <d4601f60-a2b9-4660-9b10-d05391e87e77@linux.intel.com>
Date: Fri, 28 Jun 2024 17:52:06 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, alex.williamson@redhat.com,
 robin.murphy@arm.com, eric.auger@redhat.com, nicolinc@nvidia.com,
 kvm@vger.kernel.org, chao.p.peng@linux.intel.com, iommu@lists.linux.dev
Subject: Re: [PATCH 3/6] iommu/vt-d: Make helpers support modifying present
 pasid entry
To: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, jgg@nvidia.com,
 kevin.tian@intel.com
References: <20240628085538.47049-1-yi.l.liu@intel.com>
 <20240628085538.47049-4-yi.l.liu@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20240628085538.47049-4-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024/6/28 16:55, Yi Liu wrote:
> To handle domain replacement, set_dev_pasid op needs to modify a present
> pasid entry. One way is sharing the most logics of remove_dev_pasid() in
> the beginning of set_dev_pasid() to remove the old config. But this means
> the set_dev_pasid path needs to rollback to the old config if it fails to
> set up the new pasid entry. This needs to invoke the set_dev_pasid op of
> the old domain. It breaks the iommu layering a bit. Another way is
> implementing the set_dev_pasid() without rollback to old hardware config.
> This can be achieved by implementing it in the order of preparing the
> dev_pasid info for the new domain, modify the pasid entry, then undo the
> dev_pasid info of the old domain, and if failed, undo the dev_pasid info
> of the new domain. This would keep the old domain unchanged.
> 
> Following the second way, needs to make the pasid entry set up helpers
> support modifying present pasid entry.
> 
> Signed-off-by: Yi Liu<yi.l.liu@intel.com>
> ---
>   drivers/iommu/intel/pasid.c | 37 ++++++++++++-------------------------
>   1 file changed, 12 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
> index b18eebb479de..5d3a12b081a2 100644
> --- a/drivers/iommu/intel/pasid.c
> +++ b/drivers/iommu/intel/pasid.c
> @@ -314,6 +314,9 @@ int intel_pasid_setup_first_level(struct intel_iommu *iommu,
>   		return -EINVAL;
>   	}
>   
> +	/* Clear the old configuration if it already exists */
> +	intel_pasid_tear_down_entry(iommu, dev, pasid, false, true);
> +
>   	spin_lock(&iommu->lock);
>   	pte = intel_pasid_get_entry(dev, pasid);
>   	if (!pte) {
> @@ -321,13 +324,6 @@ int intel_pasid_setup_first_level(struct intel_iommu *iommu,
>   		return -ENODEV;
>   	}
>   
> -	if (pasid_pte_is_present(pte)) {
> -		spin_unlock(&iommu->lock);
> -		return -EBUSY;
> -	}
> -
> -	pasid_clear_entry(pte);
> -
>   	/* Setup the first level page table pointer: */
>   	pasid_set_flptr(pte, (u64)__pa(pgd));

The above changes the previous assumption that when a new page table is
about to be set up on a PASID, there should be no existing one still in
place.

Is this a requirement for the replace functionality?

Best regards,
baolu

