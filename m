Return-Path: <kvm+bounces-7006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 881F783C0B6
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 12:22:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 28AE31F23A59
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 11:22:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7290733CCD;
	Thu, 25 Jan 2024 11:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jOo3a7ho"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23DA032C8C;
	Thu, 25 Jan 2024 11:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.134.136.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706181727; cv=none; b=H2DAHWYBiRCwF38clfbbGLCE1DRNJCychOhx1CcLt1r6toMiccIqzK72fDVICvPSgQukConCgfeqT3nnhHrUHFrqSHBy1+aX5HOESRCzA/JQOyk/ryPolk+N4UttmV070Df3ibRJ+6+ybbeRgBFS3JAqVKTRLAPjXUgx9JTdIno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706181727; c=relaxed/simple;
	bh=6XmL08t5nvQeDJ0ijBle9RmMpOjyA1qD7j3fdFOhR6k=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Yc7yagjQnkyHiZu/oEjNZxcX3tppU2VwcKTnt2MjT3TAflFwmdlkuzCtLPvmqw3RkqtqmKOwi5AlXw/IfgJf7bGFYXi7WhTYNqP0PbUgGlHDQz9l0oFedTEet5aSn+lGbhZ7seiKIaFDvUreTOb06km08rnQuvIqMU0YyHvN8Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jOo3a7ho; arc=none smtp.client-ip=134.134.136.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706181726; x=1737717726;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6XmL08t5nvQeDJ0ijBle9RmMpOjyA1qD7j3fdFOhR6k=;
  b=jOo3a7ho0KLSENJLvBa1snW2YXQWlazrtZzh1p7TosAHhjFJE5lvxbRi
   iiuux1BCwVnxuPr8C3diiEYfzwKKko7Gf286dTF4Svr2F0J8xs7HxiKZO
   P3oqbj/lj8Tay4o9Rjg8gTd5FOzvAbmdAaZeerQlVfjdHaUjHyu+1zsNv
   u7Acn//kEinEpV3oOBa36RRMmSwmKorp2TLeUeXYWjsHdDHD4lDrt8o1n
   kz3e+D6OHYrKI/D+AmYFKJH0gWveEdL56iuGs8hgTgLNXE9YphQdPSfYo
   qtDqgVRwth10wgt5cGaQty++VfpYZ6kkd0F60qSNM31mMRFqq49ntgrr1
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="466414530"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="466414530"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2024 03:22:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="1117919561"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="1117919561"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.254.209.226]) ([10.254.209.226])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2024 03:21:55 -0800
Message-ID: <95ff904c-4731-46e2-ad3b-313811a3c2f2@linux.intel.com>
Date: Thu, 25 Jan 2024 19:21:53 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Nicolin Chen <nicolinc@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
 Jacob Pan <jacob.jun.pan@linux.intel.com>,
 Longfang Liu <liulongfang@huawei.com>, Yan Zhao <yan.y.zhao@intel.com>,
 iommu@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v10 01/16] iommu: Move iommu fault data to linux/iommu.h
Content-Language: en-US
To: Joel Granados <j.granados@samsung.com>
References: <20240122054308.23901-1-baolu.lu@linux.intel.com>
 <20240122054308.23901-2-baolu.lu@linux.intel.com>
 <CGME20240125091737eucas1p2091d853e27e669b3b12cea8ee3bbe34e@eucas1p2.samsung.com>
 <20240125091734.chekvxgof2d5zpcg@localhost>
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20240125091734.chekvxgof2d5zpcg@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024/1/25 17:17, Joel Granados wrote:
> On Mon, Jan 22, 2024 at 01:42:53PM +0800, Lu Baolu wrote:
>> The iommu fault data is currently defined in uapi/linux/iommu.h, but is
>> only used inside the iommu subsystem. Move it to linux/iommu.h, where it
>> will be more accessible to kernel drivers.
>>
>> With this done, uapi/linux/iommu.h becomes empty and can be removed from
>> the tree.
> The reason for removing this [1] is that it is only being used by
> internal code in the kernel. What happens with usespace code that have
> used these definitions? Should we deprecate instead of just removing?

The interfaces to deliver I/O page faults to user space have never been
implemented in the Linux kernel before. Therefore, from a uAPI point of
view, this definition is actually dead code.

Best regards,
baolu

