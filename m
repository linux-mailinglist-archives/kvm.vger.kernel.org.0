Return-Path: <kvm+bounces-7987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 98882849929
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 12:47:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 01B4C28A37C
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 11:47:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A953C199A1;
	Mon,  5 Feb 2024 11:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P8kq9JFG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6709118EAF;
	Mon,  5 Feb 2024 11:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707133614; cv=none; b=E8lWAkkibUmIx6oCxJ4gSYgdiMbOk1+8oU++hVizYs4GvGGdi+/M+4bTm1Z81CrxapzNOMVvJNL4sIiSU2jXSNTOv4kLBeanD062+vcvnO/d2xMrSYD+EUMtEMcJeFyF04AdFSsD+FVkmnNQxTWGv6aljrsIr6JyLIvStn/vQ/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707133614; c=relaxed/simple;
	bh=HFCq9wu6W08QNaLCx54DPS2en/X1Oy8pyJpYJABA99U=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=iTI6rKHWdwP7g1qFLyLfIkW3Hgvg62QMYi4wS8wjabEET1RHMqnyXpLSbdFMsRW1CnvhGc0ug9JDE7TUEa3PfPGx1D+uk4IyxpkLOKDYg8EZYObCwH62VtstkAbh6EktXzQWogM6oUo1pKD7j2udATsr1HPnkwI2e/hjVf454m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P8kq9JFG; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707133613; x=1738669613;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HFCq9wu6W08QNaLCx54DPS2en/X1Oy8pyJpYJABA99U=;
  b=P8kq9JFG1NV2tkTWFZAScWzZmLigJbHRoZ7WUiS+Jprdv0lip5b4reJh
   d3Gb3c/9fgft+DodLnBGLe5CPkMUAW1isxg78cI3q9ycFQK6Aqnd5fzBz
   hvgfBeyTAUORAzUiPW3uqMvbXZwwPK1fJmDLDMvrtzKSmHCwMnb8asnJn
   58HTmL2WVHA8NDHjsYNO7HiDTdsZ22YcltSxdyootacyHbQstQAARNa3G
   lYfne//bEl1NyD2NMY3lp8PyP3eijT2/PZ6ETHQzvM+n+JACddbylKpGD
   Wv1TcOmx5kPlBJZx5P+sErnj+IPODnxlPcNCoQ5w37mnOXG1uuqUQNWxo
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10974"; a="18030066"
X-IronPort-AV: E=Sophos;i="6.05,245,1701158400"; 
   d="scan'208";a="18030066"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2024 03:46:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,245,1701158400"; 
   d="scan'208";a="706293"
Received: from bixichen-mobl.ccr.corp.intel.com (HELO [10.254.215.64]) ([10.254.215.64])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2024 03:46:49 -0800
Message-ID: <e41bbed5-fb22-43c3-9354-d797a2c7aaaa@linux.intel.com>
Date: Mon, 5 Feb 2024 19:46:46 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, "Liu, Yi L" <yi.l.liu@intel.com>,
 Jacob Pan <jacob.jun.pan@linux.intel.com>,
 Longfang Liu <liulongfang@huawei.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
 Joel Granados <j.granados@samsung.com>,
 "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v11 12/16] iommu: Use refcount for fault data access
To: "Tian, Kevin" <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Nicolin Chen <nicolinc@nvidia.com>
References: <20240130080835.58921-1-baolu.lu@linux.intel.com>
 <20240130080835.58921-13-baolu.lu@linux.intel.com>
 <BN9PR11MB52764927C3C56127F4B9B9DE8C472@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB52764927C3C56127F4B9B9DE8C472@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024/2/5 16:37, Tian, Kevin wrote:
>> From: Lu Baolu <baolu.lu@linux.intel.com>
>> Sent: Tuesday, January 30, 2024 4:09 PM
>>
>> The per-device fault data structure stores information about faults
>> occurring on a device. Its lifetime spans from IOPF enablement to
>> disablement. Multiple paths, including IOPF reporting, handling, and
>> responding, may access it concurrently.
>>
>> Previously, a mutex protected the fault data from use after free. But
>> this is not performance friendly due to the critical nature of IOPF
>> handling paths.
>>
>> Refine this with a refcount-based approach. The fault data pointer is
>> obtained within an RCU read region with a refcount. The fault data
>> pointer is returned for usage only when the pointer is valid and a
>> refcount is successfully obtained. The fault data is freed with
>> kfree_rcu(), ensuring data is only freed after all RCU critical regions
>> complete.
>>
>> An iopf handling work starts once an iopf group is created. The handling
>> work continues until iommu_page_response() is called to respond to the
>> iopf and the iopf group is freed. During this time, the device fault
>> parameter should always be available. Add a pointer to the device fault
>> parameter in the iopf_group structure and hold the reference until the
>> iopf_group is freed.
>>
>> Make iommu_page_response() static as it is only used in io-pgfault.c.
>>
>> Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
>> Tested-by: Yan Zhao <yan.y.zhao@intel.com>
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> 
>>    * struct iommu_fault_param - per-device IOMMU fault data
>>    * @lock: protect pending faults list
>> + * @users: user counter to manage the lifetime of the data
>> + * @ruc: rcu head for kfree_rcu()
> 
> s/ruc/rcu

Fixed. Thank you!

Best regards,
baolu

