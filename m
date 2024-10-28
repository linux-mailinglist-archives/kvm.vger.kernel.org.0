Return-Path: <kvm+bounces-29793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F8E89B2226
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 03:01:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CB9131F2194B
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 02:01:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E136017BEAD;
	Mon, 28 Oct 2024 02:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FEAgzFUH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086C74C6C;
	Mon, 28 Oct 2024 02:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730080872; cv=none; b=EljFwNStEK1a9jF9olcr8EuC2x6PSr9+hoPH/MEYK6RdkMP1HQKCQr30SLPOpqb3IF29dKlLTq4hEJti2K4P0mDrSBoyQwUXvXxpufu4FWzvUOrmZ+z4RBh6L+TbiW1MyByJxtmKA6CMNJJJxSdq4q69NHuV7TGmW9f1MOTmNCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730080872; c=relaxed/simple;
	bh=O3Ovtbf3MrmDzHqqK2oXEfGTFDsY4Dl/uMRNNzQ0jlU=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=NHTFbKDZlCpS/mOegY+6MSe+a2RlkVGVBRLp582Z0qGmss3m7YcE7jLCe6AFgXBRIlOOdIW7fSSzSomjASh7HATQ1XNaKPVlPGVXLlzDJiB/56cQ8vwILwAG3usEE7Evq4cy+/7b/+zDq077HqzxTrp2hzkJB3pyApSHJW1z7uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FEAgzFUH; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730080870; x=1761616870;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=O3Ovtbf3MrmDzHqqK2oXEfGTFDsY4Dl/uMRNNzQ0jlU=;
  b=FEAgzFUHr3EQeuWhjCD3MszQyI86wPqnDx/ufKLi4m/0yXVv62m/0PdX
   Qb34JnriCtA7T64jegh2/b/ygqDorvKBw2ODy6ltR+yqCqlfmerDhpNG1
   DLqJIUQtzk1ueG0x9u1ZglHJWfAjIAgEiQVV7L2ZsCwCXcsn7qmMBN2ib
   caBi6uRteHLVW07jY7GM7ol+1yuZlXtzwshj0qfK7XQB45iur85AwtdZm
   QFnHEdXxT5aINA4SqwEKL2oEeueg/ApaXiXrTga0JvE74MDtu34m/QmM5
   gxaVbagNjoFTDRRaDpL1fsWSi2xAaK40GBg8JHWj7z597sKNXq5ehYJtH
   A==;
X-CSE-ConnectionGUID: GUE7Y+dvRjSSYU6F1TMxbw==
X-CSE-MsgGUID: NYnuvrPVSNiuuMueSjJUfQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11238"; a="32530610"
X-IronPort-AV: E=Sophos;i="6.11,238,1725346800"; 
   d="scan'208";a="32530610"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2024 19:01:09 -0700
X-CSE-ConnectionGUID: qpBwISFYS46tXapmQ++WeA==
X-CSE-MsgGUID: cTaC7appS+WESSNDD4yrMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,238,1725346800"; 
   d="scan'208";a="104792722"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.238.0.51]) ([10.238.0.51])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2024 19:00:28 -0700
Message-ID: <6a9366a5-7c5b-449c-b259-8e2492aae2a1@linux.intel.com>
Date: Mon, 28 Oct 2024 10:00:25 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, Leon Romanovsky <leonro@nvidia.com>,
 Keith Busch <kbusch@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Logan Gunthorpe <logang@deltatee.com>, Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 Kevin Tian <kevin.tian@intel.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
 iommu@lists.linux.dev, linux-nvme@lists.infradead.org,
 linux-pci@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 07/18] dma-mapping: Implement link/unlink ranges API
To: Leon Romanovsky <leon@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Jason Gunthorpe <jgg@ziepe.ca>, Robin Murphy <robin.murphy@arm.com>,
 Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>
References: <cover.1730037276.git.leon@kernel.org>
 <b434f2f6d3c601649c9b6973a2ec3ec2149bba37.1730037276.git.leon@kernel.org>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <b434f2f6d3c601649c9b6973a2ec3ec2149bba37.1730037276.git.leon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024/10/27 22:21, Leon Romanovsky wrote:
> +/**
> + * dma_iova_sync - Sync IOTLB
> + * @dev: DMA device
> + * @state: IOVA state
> + * @offset: offset into the IOVA state to sync
> + * @size: size of the buffer
> + * @ret: return value from the last IOVA operation
> + *
> + * Sync IOTLB for the given IOVA state. This function should be called on
> + * the IOVA-contigous range created by one ore more dma_iova_link() calls
> + * to sync the IOTLB.
> + */
> +int dma_iova_sync(struct device *dev, struct dma_iova_state *state,
> +		size_t offset, size_t size, int ret)
> +{
> +	struct iommu_domain *domain = iommu_get_dma_domain(dev);
> +	struct iommu_dma_cookie *cookie = domain->iova_cookie;
> +	struct iova_domain *iovad = &cookie->iovad;
> +	dma_addr_t addr = state->addr + offset;
> +	size_t iova_start_pad = iova_offset(iovad, addr);
> +
> +	addr -= iova_start_pad;
> +	size = iova_align(iovad, size + iova_start_pad);
> +
> +	if (!ret)
> +		ret = iommu_sync_map(domain, addr, size);
> +	if (ret)
> +		iommu_unmap(domain, addr, size);

It appears strange that mapping is not done in this helper, but
unmapping is added in the failure path. Perhaps I overlooked anything?
To my understanding, it should like below:

	return iommu_sync_map(domain, addr, size);

In the drivers that make use of this interface should do something like
below:

	ret = dma_iova_sync(...);
	if (ret)
		dma_iova_destroy(...)

> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(dma_iova_sync);

Thanks,
baolu

