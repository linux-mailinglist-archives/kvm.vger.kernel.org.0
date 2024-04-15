Return-Path: <kvm+bounces-14619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 64B738A47C0
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 08:05:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 20BA3282A3D
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 06:05:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFB754C61;
	Mon, 15 Apr 2024 06:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RM2wsx/y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9812E5672
	for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 06:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713161134; cv=none; b=td6WEwsCkvTJyMQIyqDDT07g730SPPS0L06Ze8f9u/oFHgq02ZMuosST5/nKOF7l0fHS5c4DRF82Sf77K51/0Y3ErTscsDIBKn0DuUlkbgaqtduJxZEYA0J9/hy5moTZuhThEkxNwbEa6C9zJBcrgr+kq0zetFld40StcaBEzmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713161134; c=relaxed/simple;
	bh=cqHUrYPHspZVeh76z29wMRdjAzrkLIg2GCBnqPZh6m0=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=rZy8rS0m0D/lmbwhDMkiGmbbMh8p0g8QBJlOqSErUpFtUcfH8Yh+jrAooKCG4cMVcBuByH0SrPRs0o62+bTAKhRhiCMzW/gpFgmrFiVHQ1jw0nPnV+DPBEQ0/zBxnQCcsMGsenammS2GIwSts57oErF7/zo62JYr1/jCTO55oCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RM2wsx/y; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713161133; x=1744697133;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=cqHUrYPHspZVeh76z29wMRdjAzrkLIg2GCBnqPZh6m0=;
  b=RM2wsx/yf8u1PWHfv6cVmQwInqm8lpiov4kIwr47ltw7ijP4refU9BWR
   Xw/FPOj++cgMcZRHgK/555QZLlXFnDuXGkmx8psb9tus6s75fB7uF3k6S
   LIFfCYg2kAqdRqU4imS77lWK6L2J9CQUPkxfPgEjAH9+Wvhf4NEH5yhw5
   LZZ+Ey+5NgHYbXUw24fW8gznC9MZJaDfr6etV/G+bVpu12BNmbmE+eQjA
   MHWvNZcrFpHLGWWR42xWlv7DgarjDSIu0WW+FKdZfVOfz7+JZkZBrewxm
   yvBqa9ZdZa/rKIfC4MVwSt5v8MQSfuqZk5OXx/2tyFRoZpj79GCIA6+xg
   Q==;
X-CSE-ConnectionGUID: tdbAjH1cRIaHGyFWV3Q6SA==
X-CSE-MsgGUID: mdqvfORuQheEZ6zp+oPCdg==
X-IronPort-AV: E=McAfee;i="6600,9927,11044"; a="8389588"
X-IronPort-AV: E=Sophos;i="6.07,202,1708416000"; 
   d="scan'208";a="8389588"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2024 23:05:32 -0700
X-CSE-ConnectionGUID: 43HpJUBwQAKwMnwEWI+4zA==
X-CSE-MsgGUID: yOTsCGgMSE+gYPY7N/OoGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,202,1708416000"; 
   d="scan'208";a="26608120"
Received: from unknown (HELO [10.239.159.127]) ([10.239.159.127])
  by orviesa004.jf.intel.com with ESMTP; 14 Apr 2024 23:05:28 -0700
Message-ID: <ed73dfc1-a6a2-4a19-b716-7c1f245db75b@linux.intel.com>
Date: Mon, 15 Apr 2024 14:04:15 +0800
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
Subject: Re: [PATCH v2 10/12] iommu/vt-d: Return if no dev_pasid is found in
 domain
To: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, jgg@nvidia.com,
 kevin.tian@intel.com
References: <20240412081516.31168-1-yi.l.liu@intel.com>
 <20240412081516.31168-11-yi.l.liu@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20240412081516.31168-11-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/12/24 4:15 PM, Yi Liu wrote:
> If no dev_pasid is found, it should be a problem of caller. So a WARN_ON
> is fine, but no need to go further as nothing to be cleanup and also it
> may hit unknown issue.

If "... it should be a problem of caller ...", then the check and WARN()
should be added in the caller instead of individual drivers.

> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>   drivers/iommu/intel/iommu.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index df49aed3df5e..fff7dea012a7 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -4614,8 +4614,9 @@ static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
>   			break;
>   		}
>   	}
> -	WARN_ON_ONCE(!dev_pasid);
>   	spin_unlock_irqrestore(&dmar_domain->lock, flags);
> +	if (WARN_ON_ONCE(!dev_pasid))
> +		return;

The iommu core calls remove_dev_pasid op to tear down the translation on
a pasid and park it in a BLOCKED state. Since this is a must-be-
successful callback, it makes no sense to return before tearing down the
pasid table entry.

 From the Intel iommu driver's perspective, the pasid devices have
already been tracked in the core, hence the dev_pasid is a duplicate and
will be removed later, so don't use it for other purposes.

In the end, perhaps we just need to remove the WARN_ON() from the code.

>   
>   	domain_detach_iommu(dmar_domain, iommu);
>   	intel_iommu_debugfs_remove_dev_pasid(dev_pasid);

Best regards,
baolu

