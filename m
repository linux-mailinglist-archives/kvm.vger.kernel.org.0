Return-Path: <kvm+bounces-26100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 78875970FDD
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 09:31:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A47D71C20829
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 07:31:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD850171E5A;
	Mon,  9 Sep 2024 07:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oKqZaEra"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937271ACDE0
	for <kvm@vger.kernel.org>; Mon,  9 Sep 2024 07:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725867074; cv=none; b=LKJDuvLVffC1rTuprla9hL/WgWKOKFhOK7cz8ZxyMJ2M+1gcTau3Qa1c3lQt6ku5bDiOP4BJOg29wfNqJNGpgLpqsZkA+lQ0cQt0SLIFkUPzHOtE9QdEbb/6jU9/IoX55OvkRaTCpKuyH+quvwoxEwt4Bs7oOcnxPNqerdN9Epw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725867074; c=relaxed/simple;
	bh=d12C85tHiOp+BSkUk7IbtH2l3ESrzwO75RdL4NubGtc=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=UvFO6jOvkwaJ2Zjj0JeZIR0LdVK+4FtIm4wYMBT38hps4O8y2ELzSCZFUIHYwfFDsrrYFdYBhscQgsNqjYTENCJl21jA4ejJuLQYd69s7aRmrczOgxNOowmx23tHvSCbc7OKp6N+lrLe3a61fdwefKzk0Nqy7DlRzhAEXuIYvlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oKqZaEra; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725867073; x=1757403073;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=d12C85tHiOp+BSkUk7IbtH2l3ESrzwO75RdL4NubGtc=;
  b=oKqZaEraWiV0OMtEDTvGs8I2R+q0mG8hk5TVGR8ARdtnhy2bMSGiVKZn
   JkoFsgdmwLic95LpXtnBB+//+jSpI565RxaTzjbXzIgDedn+sGI15wSWx
   U7r9eE6Dng8xzr2acmIRBfEIYMGR9MY3L3c2Lggse2Y1sb6qiYiodk79a
   zJ7eHb+UzTwh3g72yEa/Z5jY8361mlkBk3xCu7Q8+RiqAqCXQQrHJJGar
   sDw4vk3XLVhF98iUaz4NN7dqKLLEl3LZra2q9uDytu0awuRmXwbfuUi8m
   Uyt7AYZK0K8VHQsHFKMErTFDEvDjQwiDoVMs5V7nnrWzBCXm0GC7bmsoE
   g==;
X-CSE-ConnectionGUID: 219OFCHhT4qKRNYu6XC1rA==
X-CSE-MsgGUID: HPQKx5EuSWGPaBf3GUEQPA==
X-IronPort-AV: E=McAfee;i="6700,10204,11189"; a="42053402"
X-IronPort-AV: E=Sophos;i="6.10,213,1719903600"; 
   d="scan'208";a="42053402"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2024 00:31:12 -0700
X-CSE-ConnectionGUID: Ql9s5fTZQaOzXrpUWqtwHA==
X-CSE-MsgGUID: /doWism6S4yh0PbVXOsQyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,213,1719903600"; 
   d="scan'208";a="66561290"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.125.248.220]) ([10.125.248.220])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2024 00:31:09 -0700
Message-ID: <6ef77f09-5d3f-4add-97c4-684628c32b64@linux.intel.com>
Date: Mon, 9 Sep 2024 15:31:07 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
 iommu@lists.linux.dev
Subject: Re: [PATCH 2/2] iommu: Set iommu_attach_handle->domain in core
To: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, jgg@nvidia.com,
 kevin.tian@intel.com
References: <20240908114256.979518-1-yi.l.liu@intel.com>
 <20240908114256.979518-3-yi.l.liu@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20240908114256.979518-3-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024/9/8 19:42, Yi Liu wrote:
> The IOMMU core sets the iommu_attach_handle->domain for the
> iommu_attach_group_handle() path, while the iommu_replace_group_handle()
> sets it on the caller side. Make the two paths aligned on it.
> 
> Signed-off-by: Yi Liu<yi.l.liu@intel.com>
> ---
>   drivers/iommu/iommu.c         | 1 +
>   drivers/iommu/iommufd/fault.c | 1 -
>   2 files changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

Thanks,
baolu

