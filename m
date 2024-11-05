Return-Path: <kvm+bounces-30602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9DF59BC40D
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 04:47:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 41643B2179F
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 03:47:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77F6418A6DD;
	Tue,  5 Nov 2024 03:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ea+9WhaA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE2C17C20F
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 03:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730778434; cv=none; b=cFGjsJSYsStme7ncmbpYnMBv4WOZUMiHBCOiZeK/4RrSm5DhvOJ4P20Z/7F4X8BHhv9zwzkkLgTLD7+ByGA8brfByQJr9h6pZbMZ7zPierlcRACseBPWPxTWgVYCwDe94lCCxCgxzA7a5zS6Eq1eOOJ9o0GQIk/l8pcndPYq5iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730778434; c=relaxed/simple;
	bh=RHGXrPcejarHn4BXmKMIfR2kXDQGalc+Ug9H5UvZ6hk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NCV7yGqkxzOw2ec307Dz68Hc5ld+Bd8l71AFTw2RMg8jIHnyKYkm0132fFv0pXWFqmUo5fmEcVKETmyJO8NWafNwXCIrtDG+AXtBR9VCW/PbeQYNWMwaMjAVpHWRq3E6nCc1QBlkj8o/o6yXZ2OlcOisNkIuvHFMl5Gr/E3J4O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ea+9WhaA; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730778433; x=1762314433;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RHGXrPcejarHn4BXmKMIfR2kXDQGalc+Ug9H5UvZ6hk=;
  b=ea+9WhaA5snl3vs1AjNWwGdarYDXlYvVSZG66RpP+bso3j88Tqk5hSLR
   aLva2ghvq0FZDwUduP5sgaLA/6E6eI756nUr44Y0Eq0SgJD45PcbZxHjX
   k5wwhKztqxdfU+CtGUDHM5RqCWzknuhImJCNg5PiaRGQstRv/i+qtHENb
   2JuCivOSZJT6G13YmoF0bpsG6CCPikHmB2ZJPvtQDPZX47GaQO5NssrRL
   s0CDsRh8gvzc+hoaD4Xo9HwElruQ8R989Z5A2KKSOlnZN8eaeJo50Ek8I
   a2TGJX0TgQXywYXdjaYyN4Bn6PjVRSVUmE8Nu4Z2jMSXGoWES4jL7bbji
   w==;
X-CSE-ConnectionGUID: UwJxOJqPR4ydGP4252YrcA==
X-CSE-MsgGUID: EAALpYUrSnuG4iXDF3BFSA==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="33343503"
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="33343503"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 19:47:12 -0800
X-CSE-ConnectionGUID: 6ey4AUfsSpucwcP1FMPjFg==
X-CSE-MsgGUID: KKXms9fwQxu6mkZAb155HA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="84272162"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 19:47:09 -0800
Message-ID: <557b9c59-1ecb-485a-9e36-c926180a199b@linux.intel.com>
Date: Tue, 5 Nov 2024 11:46:23 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/7] iommu/vt-d: Make the blocked domain support PASID
To: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, jgg@nvidia.com,
 kevin.tian@intel.com
Cc: alex.williamson@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
 kvm@vger.kernel.org, chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
 zhenzhong.duan@intel.com, vasant.hegde@amd.com, will@kernel.org
References: <20241104132033.14027-1-yi.l.liu@intel.com>
 <20241104132033.14027-6-yi.l.liu@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20241104132033.14027-6-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/24 21:20, Yi Liu wrote:
> @@ -4291,15 +4296,18 @@ void domain_remove_dev_pasid(struct iommu_domain *domain,
>   	kfree(dev_pasid);
>   }
>   
> -static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
> -					 struct iommu_domain *domain)
> +static int blocking_domain_set_dev_pasid(struct iommu_domain *domain,
> +					 struct device *dev, ioasid_t pasid,
> +					 struct iommu_domain *old)
>   {
>   	struct device_domain_info *info = dev_iommu_priv_get(dev);
>   	struct intel_iommu *iommu = info->iommu;
>   
>   	intel_pasid_tear_down_entry(iommu, dev, pasid, false);
>   	intel_drain_pasid_prq(dev, pasid);
> -	domain_remove_dev_pasid(domain, dev, pasid);
> +	domain_remove_dev_pasid(old, dev, pasid);
> +
> +	return 0;
>   }
>   
>   struct dev_pasid_info *
> @@ -4664,7 +4672,6 @@ const struct iommu_ops intel_iommu_ops = {
>   	.dev_disable_feat	= intel_iommu_dev_disable_feat,
>   	.is_attach_deferred	= intel_iommu_is_attach_deferred,
>   	.def_domain_type	= device_def_domain_type,
> -	.remove_dev_pasid	= intel_iommu_remove_dev_pasid,

This will cause iommu_attach_device_pasid() to fail due to the check and
failure condition introduced in patch 1/7.

--
baolu

