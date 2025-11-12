Return-Path: <kvm+bounces-62829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 34E85C505DF
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 03:52:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 01CD44E3AEF
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 02:52:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52EF92D2384;
	Wed, 12 Nov 2025 02:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cj8UfccO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E5E2BDC0A;
	Wed, 12 Nov 2025 02:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762915908; cv=none; b=hL+E/FoM8L1JpmVdO8IEzLfCzP3zUQhAggtukoNZk7V8fWT8eU7G2ROxgXZ+4AY10FXfF+QKnmHLSEwWn3GO6AMDwEbRJMRsYlc699jUSoFFzIT5Wt/G50JmJP/pQZ6g+b46yKl5hv0EO4RHUJtcwuyV0OgD0NyBAP/sJFCS/nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762915908; c=relaxed/simple;
	bh=FnjXGdhmi9cjf/H5GCn36qDisNiZcHAbPNAmtaAypr4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uiB9Dorv5oUxIHSswBbY/RxNBieCOqI1YBJWEh0yrmUR5DdyS0BKq1BiyLjj3SpWLA9MdpUSmPB8R4nzCR80/fd/5uR2pqrnh8DSzv0R5sYiEWiy2Ak+unRjnBwgwjQILIRRBLw+fJYAtTBiD60ArVM1Y7T9jiozvJXtzCFVXB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cj8UfccO; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762915907; x=1794451907;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FnjXGdhmi9cjf/H5GCn36qDisNiZcHAbPNAmtaAypr4=;
  b=cj8UfccOQkts/ePUxPAylk/f5d6dilwOQiZWQ8cvUPb97Af3lSesVwSo
   t35lZn4emoq7VoVuC+YPv6qBZgSknWSAmRqR+H7kfKnCU3QLcXq2Y04vx
   YxfNfDNZVdAnAQcJpYvQIjkCaSoglLE8dT4m+DmZhErn1zvwQRNiIvZeh
   dGRr+xKBGuqptU4QNuST5BhUpGmt2WwZ/Nj5ktkwOPrdK9mA8ezZzthU7
   T2RIG9KQ0+AW1EXVvBz6SCK/r2jj3xsEA0HatDZe46hnymhpVJ+SCaFNG
   sDohsybFrJ3TuJSoU2UU0qnzGuLtzrd4hS080zP18WnzuNExGpmJYmAF+
   A==;
X-CSE-ConnectionGUID: NNdxwlJ8ST6bm3XZWNNd3Q==
X-CSE-MsgGUID: 8Bbjev3MTy2mTNd7B6djlQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11610"; a="87605763"
X-IronPort-AV: E=Sophos;i="6.19,298,1754982000"; 
   d="scan'208";a="87605763"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2025 18:51:46 -0800
X-CSE-ConnectionGUID: Z7I0266wRPKqUZSzlavn7g==
X-CSE-MsgGUID: ezqtxvUdTBKU2eF/psZZfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,298,1754982000"; 
   d="scan'208";a="189830912"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2025 18:51:41 -0800
Message-ID: <b556b673-300f-486e-8891-809519b98797@linux.intel.com>
Date: Wed, 12 Nov 2025 10:47:38 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/5] iommu: Lock group->mutex in
 iommu_deferred_attach()
To: Nicolin Chen <nicolinc@nvidia.com>, joro@8bytes.org, afael@kernel.org,
 bhelgaas@google.com, alex@shazbot.org, jgg@nvidia.com, kevin.tian@intel.com
Cc: will@kernel.org, robin.murphy@arm.com, lenb@kernel.org,
 linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
 linux-pci@vger.kernel.org, kvm@vger.kernel.org, patches@lists.linux.dev,
 pjaroszynski@nvidia.com, vsethi@nvidia.com, helgaas@kernel.org,
 etzhao1900@gmail.com
References: <cover.1762835355.git.nicolinc@nvidia.com>
 <11b3ab833d717feb41ce23ae6ebdc3af13ea55a7.1762835355.git.nicolinc@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <11b3ab833d717feb41ce23ae6ebdc3af13ea55a7.1762835355.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/11/25 13:12, Nicolin Chen wrote:
> The iommu_deferred_attach() function invokes __iommu_attach_device(), but
> doesn't hold the group->mutex like other __iommu_attach_device() callers.
> 
> Though there is no pratical bug being triggered so far, it would be better
> to apply the same locking to this __iommu_attach_device(), since the IOMMU
> drivers nowaday are more aware of the group->mutex -- some of them use the
> iommu_group_mutex_assert() function that could be potentially in the path
> of an attach_dev callback function invoked by the __iommu_attach_device().
> 
> Worth mentioning that the iommu_deferred_attach() will soon need to check
> group->resetting_domain that must be locked also.
> 
> Thus, grab the mutex to guard __iommu_attach_device() like other callers.
> 
> Reviewed-by: Jason Gunthorpe<jgg@nvidia.com>
> Reviewed-by: Kevin Tian<kevin.tian@intel.com>
> Signed-off-by: Nicolin Chen<nicolinc@nvidia.com>
> ---
>   drivers/iommu/iommu.c | 13 ++++++++++---
>   1 file changed, 10 insertions(+), 3 deletions(-)

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

