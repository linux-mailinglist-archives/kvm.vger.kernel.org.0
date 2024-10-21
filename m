Return-Path: <kvm+bounces-29241-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F7B69A5A3A
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 08:18:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 049BB1F21802
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 06:18:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6D84197A99;
	Mon, 21 Oct 2024 06:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hgAgIa1s"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95F217C200
	for <kvm@vger.kernel.org>; Mon, 21 Oct 2024 06:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729491515; cv=none; b=pucpL8ATB0phb8E18duyixssSbGpzE78TAUIoC8kJr/4r5f5iwyt7rKRFWgCl6vs4N+fY1bhRf7hAKUJdT1Zlqqfxv2vQs+3buCjQL6/NsBiTnz2yQUmhomOECA7qXpyvVrbQwmzjYJ2yJ6dzE8IkOF3q6bJ9hbKamKfvvO0agU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729491515; c=relaxed/simple;
	bh=PDw4b0bCIKEWIsvbiNOIT8XR1IkEfJ77qGNQC25vZ2c=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=dvznVcDKxGWZD+71aWpHlgXU1NoJz4x4AT6+FWGO6BLPxCE/oFvs5pZBXRGlK/mTYnKkNlUfKtsyg2sz0/y/xi7M+6OUETJJHRffY5fIEAFjYkVdwOLQCsHUmTXnqIys7z2ypGfI2y3gP0OyxwCOetdnfllV9/BxEyQQfEAQbqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hgAgIa1s; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729491514; x=1761027514;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PDw4b0bCIKEWIsvbiNOIT8XR1IkEfJ77qGNQC25vZ2c=;
  b=hgAgIa1sw4Lhr/2tTSv77qdT0x0KAQqipsFj36u6TSpdVLU4OIPQ3MyE
   B0ZtwccMjqPZguwnkVGEg9MGFJewsUIbHF1abn377mlo4B4wBJLDBfNoX
   Grv2mCt3RzL6F9CemH00FFwXfUWttluMpsu0E04kaH2C/ZzSUtYC8rn+d
   FwVABlwQBhRObXa0H4gGCUOckIEdYPIXbdYOjNkDfXMLcaPbz6xIKjkPW
   ymbmye2k9krSVXjvkXhrdfWlS1gHqIbOza15a5GfgtxtrZ85nz7k76ETz
   CAzx9cPUMcQYZOJHO4tiRV+aIqYvQ4Y+0AfV+QR/dbocthq037bAcwH04
   A==;
X-CSE-ConnectionGUID: SCpheuvUQXCSBOFWJ1dqUw==
X-CSE-MsgGUID: J610X4WlQMui3RbzyBshpg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="40083930"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="40083930"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2024 23:18:33 -0700
X-CSE-ConnectionGUID: ln9pqGsWRByM4FjmD1Dcxw==
X-CSE-MsgGUID: DqCKXbmNRgOEuJ9S0SvT/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,220,1725346800"; 
   d="scan'208";a="79363240"
Received: from unknown (HELO [10.238.0.51]) ([10.238.0.51])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2024 23:18:30 -0700
Message-ID: <e93c0d44-957c-4569-aa33-807b3eada079@linux.intel.com>
Date: Mon, 21 Oct 2024 14:18:27 +0800
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
Subject: Re: [PATCH v3 5/9] iommu/vt-d: Rename prepare_domain_attach_device()
To: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, jgg@nvidia.com,
 kevin.tian@intel.com, will@kernel.org
References: <20241018055402.23277-1-yi.l.liu@intel.com>
 <20241018055402.23277-6-yi.l.liu@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20241018055402.23277-6-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024/10/18 13:53, Yi Liu wrote:
> This helper is to ensure the domain is compatible with the device's iommu,
> so it is more sanity check than preparation. Hence, rename it.
> 
> Suggested-by: Lu Baolu<baolu.lu@linux.intel.com>
> Signed-off-by: Yi Liu<yi.l.liu@intel.com>
> ---
>   drivers/iommu/intel/iommu.c  | 8 ++++----
>   drivers/iommu/intel/iommu.h  | 4 ++--
>   drivers/iommu/intel/nested.c | 2 +-
>   3 files changed, 7 insertions(+), 7 deletions(-)

Yes, this helper calls for a name change. I have already a patch in the
coming v2 of below series:

https://lore.kernel.org/linux-iommu/20241011042722.73930-8-baolu.lu@linux.intel.com/

Just for your information to avoid duplication.

Thanks,
baolu

