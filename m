Return-Path: <kvm+bounces-13417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A55148962C9
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 05:10:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 435331F23175
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 03:10:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3B4D1C68A;
	Wed,  3 Apr 2024 03:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MoksaYsA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB93A3C6A4
	for <kvm@vger.kernel.org>; Wed,  3 Apr 2024 03:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712113783; cv=none; b=NnjDaRvtixoebZtEEm7ko3mAAX9CwzsPpJH+0F4UY3W1+STH9q7/mSh+jp/MU/yCK3LuPM+06UjcbT5kOSvu3WbZ4EbsMMTV2bKsKYmQ5bRneEXUiJB4+3fDzrnlgfkfqGB1WsK3FwG9Npj0hMj+Ukqa1JJuS+p1hL9PhuOegPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712113783; c=relaxed/simple;
	bh=uiYDlfzFuvJ7hv9mF8sSX8yy2GvQU90BheENGiFJ5Xc=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=gVGqhsC26kujXcr2Oq2XP7BnndDZSlKFQm1BbrHIMjuGXO47QhInq3bpVnLqNSVWqD50BpkmOFjHDJR/TCW3AXodtgKFGrPzL7KhCaINp9G7vqnnXGe9fU6e1IYysH1oXTlCVZN1jxVThiEifDRtiTqOf75OW5JkW3L8nzavxIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MoksaYsA; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712113781; x=1743649781;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=uiYDlfzFuvJ7hv9mF8sSX8yy2GvQU90BheENGiFJ5Xc=;
  b=MoksaYsAFkrCijgdrarO1vJejqSqSzy9Zj5goefMO7pBbFRZYGB97+V5
   LyPh0mhlTag+oVsNn+x6l+X5WmOuM082BXFgvaKCL6ojmmPIxDMgEPued
   N03vpfxE9bBaiYhjoBJRgS8/2yGmph6jphzaF1OC9IAuES8Aun6cB8tOf
   nOLSAhjGlTwEQY1FNWGAAaliDaEDtIeeCLxPgMrPxNC/Y22keGGmsjuyv
   98Md9MJ6ScxTn5ipJPVro1BxZOniXnE7/gid5eIRz9KBilobbXhOHqw19
   pgRMUHRDgIe3g2nc0C50XxG74dCoH8jh/UmcziTOzaQ3EcNTODCGWvXFb
   A==;
X-CSE-ConnectionGUID: T/6iDJUpQ8WcpMSB+DcAaQ==
X-CSE-MsgGUID: vhoS1ZK4QqGvyAhu2rZaXg==
X-IronPort-AV: E=McAfee;i="6600,9927,11032"; a="24779666"
X-IronPort-AV: E=Sophos;i="6.07,176,1708416000"; 
   d="scan'208";a="24779666"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2024 20:09:41 -0700
X-CSE-ConnectionGUID: hiegvYEwQti7scdPsX5fdw==
X-CSE-MsgGUID: foI05s5OQH22FRdr42RCwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,176,1708416000"; 
   d="scan'208";a="18711090"
Received: from allen-box.sh.intel.com (HELO [10.239.159.127]) ([10.239.159.127])
  by orviesa007.jf.intel.com with ESMTP; 02 Apr 2024 20:09:38 -0700
Message-ID: <03a8e382-5fe0-4420-ace1-10a7107e5768@linux.intel.com>
Date: Wed, 3 Apr 2024 11:08:37 +0800
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
Subject: Re: [PATCH v2 1/2] iommu: Undo pasid attachment only for the devices
 that have succeeded
To: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, jgg@nvidia.com,
 kevin.tian@intel.com
References: <20240328122958.83332-1-yi.l.liu@intel.com>
 <20240328122958.83332-2-yi.l.liu@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20240328122958.83332-2-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/28/24 8:29 PM, Yi Liu wrote:
> There is no error handling now in __iommu_set_group_pasid(), it relies on
> its caller to loop all the devices to undo the pasid attachment. This is
> not self-contained and has drawbacks. It would result in unnecessary
> remove_dev_pasid() calls on the devices that have not been attached to the
> new domain. But the remove_dev_pasid() callback would get the new domain
> from the group->pasid_array. So for such devices, the iommu driver won't
> find the attachment under the domain, hence unable to do cleanup. This may
> not be a real problem today. But it depends on the implementation of the
> underlying iommu driver. e.g. the intel iommu driver would warn for such
> devices. Such warnings are unnecessary.
> 
> To solve the above problem, it is necessary to handle the error within
> __iommu_set_group_pasid(). It only loops the devices that have attached
> to the new domain, and undo it.
> 
> Fixes: 16603704559c ("iommu: Add attach/detach_dev_pasid iommu interfaces")
> Suggested-by: Jason Gunthorpe<jgg@nvidia.com>
> Reviewed-by: Jason Gunthorpe<jgg@nvidia.com>
> Reviewed-by: Kevin Tian<kevin.tian@intel.com>
> Signed-off-by: Yi Liu<yi.l.liu@intel.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

Best regards,
baolu

