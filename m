Return-Path: <kvm+bounces-29247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F09B29A5A4E
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 08:28:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B1A2528183B
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 06:27:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F33CD1D04B9;
	Mon, 21 Oct 2024 06:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Nc2xdKSX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D32194AEC
	for <kvm@vger.kernel.org>; Mon, 21 Oct 2024 06:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729492063; cv=none; b=kcq0E56aSSztGMLhPwgJ2fJoso3L+Mt5KHDXNrQ8vkoEc606hLFdzKF9toKsc7qsYZ5O+2kiYslJ32ghwFo3PKwkbIyLaEpI5m72B1lpWDk+gBZBFGUQuaWW2It1h583JbH0xOGLWtg3mr0yRLyqmM/l59b8Eix0Fa80i6GSxo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729492063; c=relaxed/simple;
	bh=KqQV1jBJ1R+LBKBk0CySepX7kupWCVvNeVB8OkPWJI4=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=LSaSOdv6CxBhvtBuYTUrkbxaoP8wK/uiKaVLERhwHgr1ESw+86sQCHKDnCflv/OuMEfZmdSj37PQP6V4Hg/1hvThx1pZ5TrO9IFHAADkbkco7v9tK8mjBHf5jeR/QubKmHa8YE+zPOhBDwwQQ2htdQYcHtHv8DqU1jcuWn1JWCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Nc2xdKSX; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729492061; x=1761028061;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=KqQV1jBJ1R+LBKBk0CySepX7kupWCVvNeVB8OkPWJI4=;
  b=Nc2xdKSXu0jiNZEFtkEWKmSMa9Xw3AkqlArbG9VKiuEpMZXchUMF79Iy
   p2FTHwxFb3vGagZF3CklR+v3mivwGJzwNgrLOi8CWDjNslAdijdaR25xS
   a14ISAMwDESILt6GqkVsnFMnduNuInsbv/1el4q4eiYb7xy2bZtnvhcWC
   RmA/1R4HlE98xh13MGBvY1i5t5Aa+DxxbnoK5Jzi6n++WjK7fD3Zzus2X
   68WNvIxBde5d+IKU7ccQa5DD5a6ue0301sGIZwyj8dtRmXCrg/EcLh5Sf
   6+HR2CsxdF3shZxlxBemou0YzcS9xk0Mg8OmSn7TDpsk13a1WgEwrdN8x
   A==;
X-CSE-ConnectionGUID: P9Y17LYuQwup4D1ixw7oAQ==
X-CSE-MsgGUID: bio1J6MtSvauJQjYeYB+DQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="40084565"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="40084565"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2024 23:27:40 -0700
X-CSE-ConnectionGUID: 3x7FizEYT7qxA1+28A7rqA==
X-CSE-MsgGUID: 4fDg2/ShTvm6UccG3oNyXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,220,1725346800"; 
   d="scan'208";a="79363857"
Received: from unknown (HELO [10.238.0.51]) ([10.238.0.51])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2024 23:27:36 -0700
Message-ID: <17513727-c2db-4aea-a60a-d9bb8b8ac71c@linux.intel.com>
Date: Mon, 21 Oct 2024 14:27:32 +0800
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
Subject: Re: [PATCH v3 9/9] iommu: Make set_dev_pasid op support domain
 replacement
To: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, jgg@nvidia.com,
 kevin.tian@intel.com, will@kernel.org
References: <20241018055402.23277-1-yi.l.liu@intel.com>
 <20241018055402.23277-10-yi.l.liu@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20241018055402.23277-10-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024/10/18 13:54, Yi Liu wrote:
> The iommu core is going to support domain replacement for pasid, it needs
> to make the set_dev_pasid op support replacing domain and keep the old
> domain config in the failure case.
> 
> AMD iommu driver does not support domain replacement for pasid yet, so it
> would fail the set_dev_pasid op to keep the old config if the input @old
> is non-NULL.
> 
> Suggested-by: Jason Gunthorpe<jgg@nvidia.com>
> Reviewed-by: Jason Gunthorpe<jgg@nvidia.com>
> Reviewed-by: Kevin Tian<kevin.tian@intel.com>
> Signed-off-by: Yi Liu<yi.l.liu@intel.com>
> ---
>   drivers/iommu/amd/pasid.c | 3 +++
>   include/linux/iommu.h     | 3 ++-
>   2 files changed, 5 insertions(+), 1 deletion(-)

I would suggest merging this patch with patch 1/9.

Thanks,
baolu

