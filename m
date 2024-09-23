Return-Path: <kvm+bounces-27309-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B8A5F97EE57
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 17:39:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6FB911F2260A
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 15:39:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E067819E804;
	Mon, 23 Sep 2024 15:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UAC3yGzL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF2D19D885;
	Mon, 23 Sep 2024 15:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727105937; cv=none; b=CzRikqmf3qKXUCZz1UT4fE8MdcMPRZ64arnmQmKNGubAH55V7IDUq8WL+7RRDaNe1drsbIvmv6aBmPIyrynY8RldgM61Mzd+PGObtCE5yTo+5ayQtw5lNL8zYnBhvWZyyi31b96IyxkDKEawnWo97GH5ctEKOH2jn61bZoYYZX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727105937; c=relaxed/simple;
	bh=XkqFUUa22LnKJV95Jg+ZywFkMFoSj90eBTSL/RBCUbY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dhlccstNllKHn4PqthZsGOd1hEA/H6rnFo8ubQK9NYd9G7ouZjrCl7xjlsfCywihUcU+FbUOWfPqNijvX//t+OWNhVCg41Oyu+pqXE6noamyyTSJKizTDWj90vNiEktpwLVqSY5XPc82y9LwTQSOYSmk/pqqCFhzW2442l9mIyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UAC3yGzL; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727105935; x=1758641935;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XkqFUUa22LnKJV95Jg+ZywFkMFoSj90eBTSL/RBCUbY=;
  b=UAC3yGzLhJNOzvRXFzThhCQqiKrgZsMNxQ00Pt/MRoUIJDncLJzPpvKd
   R2lVg+b49Vm/cFqpDrAqM9Vq8kSYRXcVAnaXZAEbOvAAiDuCKNT7xYNi4
   oHZUNaNfrXgbxacRAZLe8Rs6iXLR+c0ROWpx3PIYWhL0EHgDqVXDeqF8K
   BExt8eqqiFKTIobHkp+2rEb6JhXbwm0a7O3sLaqaVVybMxR4oKsoh8ssQ
   xmEFxoye5htWeT89glLiui5e7rhFjKVvsqU6bTBw9ivLCbUTUR96xykz1
   8jN5ZDMy920XGbWm2BX3SxG3xqRTayb09v1tWZ8Xw3BrhLIQT2DEreTwc
   A==;
X-CSE-ConnectionGUID: 6CWCLRLWQvSNXXJgSvibBg==
X-CSE-MsgGUID: Am2JYYxRQ46VXlHDKk0Yag==
X-IronPort-AV: E=McAfee;i="6700,10204,11204"; a="25577706"
X-IronPort-AV: E=Sophos;i="6.10,251,1719903600"; 
   d="scan'208";a="25577706"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2024 08:38:54 -0700
X-CSE-ConnectionGUID: uQ0BJIXWQB+P8whv2mLrNA==
X-CSE-MsgGUID: EjUtjR34SkeUcNqTJuSWFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,251,1719903600"; 
   d="scan'208";a="76034951"
Received: from tcingleb-desk1.amr.corp.intel.com (HELO [10.125.110.203]) ([10.125.110.203])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2024 08:38:53 -0700
Message-ID: <e43792c3-c4d5-48e0-a4d4-586cebbb49b8@intel.com>
Date: Mon, 23 Sep 2024 08:38:52 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 01/13] cxl: allow a type-2 device not to have memory device
 registers
To: Zhi Wang <zhiw@nvidia.com>, kvm@vger.kernel.org, linux-cxl@vger.kernel.org
Cc: alex.williamson@redhat.com, kevin.tian@intel.com, jgg@nvidia.com,
 alison.schofield@intel.com, dan.j.williams@intel.com, dave@stgolabs.net,
 jonathan.cameron@huawei.com, ira.weiny@intel.com, vishal.l.verma@intel.com,
 alucerop@amd.com, acurrid@nvidia.com, cjia@nvidia.com, smitra@nvidia.com,
 ankita@nvidia.com, aniketa@nvidia.com, kwankhede@nvidia.com,
 targupta@nvidia.com, zhiwang@kernel.org
References: <20240920223446.1908673-1-zhiw@nvidia.com>
 <20240920223446.1908673-2-zhiw@nvidia.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20240920223446.1908673-2-zhiw@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/20/24 3:34 PM, Zhi Wang wrote:
> CXL memory device registers provide additional information about device
> memory and advanced control interface for type-3 device.
> 
> However, it is not mandatory for a type-2 device. A type-2 device can
> have HDMs but not CXL memory device registers.
> 
> Allow a type-2 device not to hanve memory device register when probing
> CXL registers.
> 
> Signed-off-by: Zhi Wang <zhiw@nvidia.com>
> ---
>  drivers/cxl/pci.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> index e00ce7f4d0f9..3fbee31995f1 100644
> --- a/drivers/cxl/pci.c
> +++ b/drivers/cxl/pci.c
> @@ -529,13 +529,13 @@ int cxl_pci_accel_setup_regs(struct pci_dev *pdev, struct cxl_dev_state *cxlds)
>  	int rc;
>  
>  	rc = cxl_pci_setup_regs(pdev, CXL_REGLOC_RBI_MEMDEV, &map,
> -				cxlds->capabilities);
> -	if (rc)
> -		return rc;
> -
> -	rc = cxl_map_device_regs(&map, &cxlds->regs.device_regs);
> -	if (rc)
> -		return rc;
> +			cxlds->capabilities);
> +	if (!rc) {

Given that device registers are mandatory for type3 devices, I don't think we should alter the current behavior where the code attempt to map device registers and fail if that doesn't exist. Maybe need to check against the capabilities that Alejandro introduced.

DJ  

> +		rc = cxl_map_device_regs(&map, &cxlds->regs.device_regs);
> +		if (rc)
> +			dev_dbg(&pdev->dev,
> +				"Failed to map device registers.\n");
> +	}
>  
>  	rc = cxl_pci_setup_regs(pdev, CXL_REGLOC_RBI_COMPONENT,
>  				&cxlds->reg_map, cxlds->capabilities);


