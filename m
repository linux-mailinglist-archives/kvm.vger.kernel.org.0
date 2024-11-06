Return-Path: <kvm+bounces-30878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B53B9BE152
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 09:52:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8C4371C22262
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 08:52:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F7F31D5ABD;
	Wed,  6 Nov 2024 08:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PxmF/GTE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1003B1925B6
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 08:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730883146; cv=none; b=XM5PQgpnw391aYjSRQ76fEAOR+46LEMdGrDnNm0W2CPvMGwUO+US+Ps2DDaAayoUVpY63FYFgOKvw2OmBN5iwldO70lZccVOAC7iMXhK8m1Cy7YQkWWueEfYHM4r8qmkYt29WdOTQ/uyMaCFMmo4SSXTSLx95Q95M9fzLVNKzN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730883146; c=relaxed/simple;
	bh=SAgahWnG2DeFpF6l8Do2xzl9AhovY4+m0h44ByCgbd8=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=tQb1ZTqNd/d+RllocE616N1DThjh+SjZCsK+8OxBuwwCDTK4p8fladEcAnMiGGK4cNwo5gWtIp2qe8aDaWXAAY4Ht+zTCwGaLUJf4Ud9A+UiB7sWMdEleykU0Wwyscwn5shPqs2Ds6D/lTW0Rz3rzho7RswMwTs7+KnKzjHeMjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PxmF/GTE; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730883145; x=1762419145;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SAgahWnG2DeFpF6l8Do2xzl9AhovY4+m0h44ByCgbd8=;
  b=PxmF/GTEvFfBrP6+ZO7/ZV92J5PKgVuGpG95MPANSxC00mwzPVOaISKW
   fNW5k1UgbYg0tk6Q/AbSLWcPZQvNWjsq4rw1ER+JPN6qckBTwVUM3XSOF
   zTqVyWjrhev7zyrqM4sINfg+5+Qu/nc82hOuvSTfiRZpWYKdVgwXS0onp
   4ZpzDSObtXGEulC40SdLFU4mFolfTwgpf0/gMNCy2N17wGBDjbhvxptHz
   L1nOoXnu5gYqzeY/ZjOVBl64FH/+xz36J3JFu5wqe/JiMiKZufFlkSnBv
   alP4aOedzindYKXu0BGynabTziYZMk2nZhnYuHsfykx8BdOObBGCxgJ/v
   Q==;
X-CSE-ConnectionGUID: BcSY+ez3Tvat3QzTquBTjQ==
X-CSE-MsgGUID: I6gxvefDR1yrVn3pHVZXEg==
X-IronPort-AV: E=McAfee;i="6700,10204,11247"; a="30553919"
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="30553919"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 00:52:24 -0800
X-CSE-ConnectionGUID: zVemqJI8SXK3F3FHGKp/Kw==
X-CSE-MsgGUID: OW0B5Ob+SDS7hqqX6pSzxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="89554212"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.124.240.228]) ([10.124.240.228])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 00:52:21 -0800
Message-ID: <42e0a0ad-e653-4007-b38e-66db452cea33@linux.intel.com>
Date: Wed, 6 Nov 2024 16:52:18 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, joro@8bytes.org, kevin.tian@intel.com,
 alex.williamson@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
 kvm@vger.kernel.org, chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
 zhenzhong.duan@intel.com, vasant.hegde@amd.com
Subject: Re: [PATCH v5 01/12] iommu: Introduce a replace API for device pasid
To: Jason Gunthorpe <jgg@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
References: <20241104132513.15890-1-yi.l.liu@intel.com>
 <20241104132513.15890-2-yi.l.liu@intel.com>
 <9846d58f-c6c8-41e8-b9fc-aa782ea8b585@linux.intel.com>
 <4f33b93c-6e86-428d-a942-09cd959a2f08@intel.com>
 <6e395258-96a1-44a5-a98f-41667e4ef715@linux.intel.com>
 <64f4e0ea-fb0f-41d1-84a1-353d18d5d516@intel.com>
 <20241105151042.GC458827@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20241105151042.GC458827@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024/11/5 23:10, Jason Gunthorpe wrote:
> On Tue, Nov 05, 2024 at 04:10:59PM +0800, Yi Liu wrote:
> 
>>>> not quite get why this handle is related to iommu driver flushing PRs.
>>>> Before __iommu_set_group_pasid(), the pasid is still attached with the
>>>> old domain, so is the hw configuration.
>>> I meant that in the path of __iommu_set_group_pasid(), the iommu drivers
>>> have the opportunity to flush the PRs pending in the hardware queue. If
>>> the attach_handle is switched (by calling xa_store()) before
>>> __iommu_set_group_pasid(), the pending PRs will be routed to iopf
>>> handler of the new domain, which is not desirable.
>> I see. You mean the handling of PRQs. I was interpreting you are talking
>> about PRQ draining.
> I don't think we need to worry about this race, and certainly you
> shouldn't be making the domain replacement path non-hitless just to
> fence the page requests.
> 
> If a page request comes in during the race window of domain change
> there are only three outcomes:
> 
>    1) The old domain handles it and it translates on the old domain
>    2) The new domain handles it and it translates on the new domain
>    3) The old domain handles it and it translates on the new domain.
>       a) The page request is ack'd and the device retries and loads the
>         new domain - OK - at best it will use the new translation, at
>         worst it will retry.
>       b) the page request fails and the device sees the failure. This
>          is the same as #1 - OK
> 
> All are correct. We don't need to do more here than just let the race
> resolve itself.
> 
> Once the domains are switched in HW we do have to flush everything
> queued due to the fault path locking scheme on the domain.

Agreed. To my understanding, the worst case is that the device retries
the transaction which might result in another page fault, which will set
up the translation in the new domain.

--
baolu

