Return-Path: <kvm+bounces-8386-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 158B184EEE6
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 03:40:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C45671F23CF1
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 02:40:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B03B184F;
	Fri,  9 Feb 2024 02:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FvoDm9ho"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DFE15CB;
	Fri,  9 Feb 2024 02:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.88
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707446394; cv=none; b=mtOtSczup1MY9lv/nQeLVPIP9o+ptEps2YOiQ/YKmSnd076xMioMrkVjW8bsNYWBqMsv2ImLd1zu8P8Ql1ELwBy9A6WGPjqFFudGckC23O92LxNSVl28oDaIeWTJ2LlPcpjmbdldJX0hkAqh9oq5ZushJFmT7ZDgzfcjjBHpxwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707446394; c=relaxed/simple;
	bh=3Ee/2aKrjQDTU3Kmj/mgQyTJpUZanAxmwCxR4/tJSOo=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=Toni9lM1rYuTOdkv3jBb3B0eCfydR9kj6dktl8wyHR7hjTVuJ3jjBnftasalgBVeOyIyucRPr+QuNWXgB+rEsyKjPl4EIblZzth/0QZ/uzMk34cA8fHHRoD6t5VviNhStInXIZvJc8pQbzBkKP+erEEHPW373eQD4pMlSa66jLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FvoDm9ho; arc=none smtp.client-ip=192.55.52.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707446392; x=1738982392;
  h=message-id:date:mime-version:from:subject:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=3Ee/2aKrjQDTU3Kmj/mgQyTJpUZanAxmwCxR4/tJSOo=;
  b=FvoDm9hoBXCgCnvwzEFt4EXhGJtgWx3tXx9Zs9bMyK8nhYnnMeFTdHrS
   0aqHgUeZDGRREgsz1BSOs+y+Jn+vNn+MvnWDfySKnYu7P+mMZBdi1nDYn
   H99UyHcUOo3+OCvz6DgqDEkMFdYQg6yopJlwEYiM+4gaBvw+iFFLinoHb
   Nwn28gdmMdMl6x1VyhOMuRmJRIbwsU95LgGxobhuSTzZmerV3TCBuwKO1
   BlyFCK5qNP4+vm59DS4GcSvpzjcuM4+7ySsGaRsrjVgtrNb/oj7wM/eCL
   JWfJD0TCoU34NvllYmkA+vlRNUS6pCEKW1QnavXCk9OLj9Z5B1rrNAYr5
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10978"; a="436494520"
X-IronPort-AV: E=Sophos;i="6.05,255,1701158400"; 
   d="scan'208";a="436494520"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2024 18:39:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,255,1701158400"; 
   d="scan'208";a="6488628"
Received: from lshui-mobl1.ccr.corp.intel.com (HELO [10.249.170.42]) ([10.249.170.42])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2024 18:39:47 -0800
Message-ID: <c918825d-ad74-4b1d-abcc-31c3f3ea4620@linux.intel.com>
Date: Fri, 9 Feb 2024 10:39:44 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Baolu Lu <baolu.lu@linux.intel.com>
Subject: Re: [PATCH v12 00/16] iommu: Prepare to deliver page faults to user
 space
To: Zhangfei Gao <zhangfei.gao@linaro.org>
Cc: baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Nicolin Chen <nicolinc@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
 Jacob Pan <jacob.jun.pan@linux.intel.com>,
 Longfang Liu <liulongfang@huawei.com>, Yan Zhao <yan.y.zhao@intel.com>,
 Joel Granados <j.granados@samsung.com>, iommu@lists.linux.dev,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240207013325.95182-1-baolu.lu@linux.intel.com>
 <CABQgh9H02z+uHg_hYnoVZURz7PLeYW_41MwxciE6W+kPRgEHsw@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CABQgh9H02z+uHg_hYnoVZURz7PLeYW_41MwxciE6W+kPRgEHsw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2024/2/8 17:03, Zhangfei Gao wrote:
> Hi, Baolu
> 
> On Wed, 7 Feb 2024 at 09:39, Lu Baolu <baolu.lu@linux.intel.com 
> <mailto:baolu.lu@linux.intel.com>> wrote:
> 
>     When a user-managed page table is attached to an IOMMU, it is necessary
>     to deliver IO page faults to user space so that they can be handled
>     appropriately. One use case for this is nested translation, which is
>     currently being discussed in the mailing list.
> 
>     I have posted a RFC series [1] that describes the implementation of
>     delivering page faults to user space through IOMMUFD. This series has
>     received several comments on the IOMMU refactoring, which I am trying to
>     address in this series.
> 
>     The major refactoring includes:
> 
>     - [PATCH 01 ~ 04] Move include/uapi/linux/iommu.h to
>        include/linux/iommu.h. Remove the unrecoverable fault data
>     definition.
>     - [PATCH 05 ~ 06] Remove iommu_[un]register_device_fault_handler().
>     - [PATCH 07 ~ 10] Separate SVA and IOPF. Make IOPF a generic page fault
>        handling framework.
>     - [PATCH 11 ~ 16] Improve iopf framework.
> 
>     This is also available at github [2].
> 
>     [1]
>     https://lore.kernel.org/linux-iommu/20230530053724.232765-1-baolu.lu@linux.intel.com/ <https://lore.kernel.org/linux-iommu/20230530053724.232765-1-baolu.lu@linux.intel.com/>
>     [2]
>     https://github.com/LuBaolu/intel-iommu/commits/preparatory-io-pgfault-delivery-v12 <https://github.com/LuBaolu/intel-iommu/commits/preparatory-io-pgfault-delivery-v12>
> 
> 
> Wandering are these patches dropped now,
> 
> [PATCH v2 2/6] iommufd: Add iommu page fault uapi data
> https://lore.kernel.org/lkml/20231026024930.382898-3-baolu.lu@linux.intel.com/raw <https://lore.kernel.org/lkml/20231026024930.382898-3-baolu.lu@linux.intel.com/raw>
> 
> [PATCH v2 4/6] iommufd: Deliver fault messages to user space
> https://lore.kernel.org/lkml/20231026024930.382898-5-baolu.lu@linux.intel.com/ <https://lore.kernel.org/lkml/20231026024930.382898-5-baolu.lu@linux.intel.com/>

Above patches are part of another series named "IOMMUFD: Deliver IO page
faults to user space", which is now updated to v3.

https://lore.kernel.org/linux-iommu/20240122073903.24406-1-baolu.lu@linux.intel.com/

> And does iouring still be used in user space?

iouring is not related to this series. For uapi of iommufd, it's still
recommended to use iouring to speed up the handling of faults.

Best regards,
baolu

