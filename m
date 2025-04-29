Return-Path: <kvm+bounces-44634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54FDAA9FF8A
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 04:13:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C0BB921D06
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 02:13:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31D3C253F1E;
	Tue, 29 Apr 2025 02:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="INvP6gVu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A522F202F92;
	Tue, 29 Apr 2025 02:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745892809; cv=none; b=k1I3rbkyyaaCdrE8JneJBSxD6TrSTMfzTcY1unetGmL96/NVbba+6FPUnydH7QPDnx5UNUhBAVgvHK/oeLddF6EoaQf2Cw+/K4db6OeGywOdH4Q9V1Ad67Cm1zIcXnCte0uE5RcoBPLsIeQ1Nw9xbIKCXM2psA7Yn97qq0zPz60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745892809; c=relaxed/simple;
	bh=cl37MECxv3M+3URhi+36RMhj2hMQV9W9XGD1Q2/sh04=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EGc60M2ZkVInieYY12tCksFmF+OdnQeh6r71fNpUaRy0/TjqAMGMbI6p8Xt9TLjZP6e2iLcZloH+/DEhwNWKix4ndFuCsXXeLcnbvjVOU9uYnMsFZtEsvqN7aFrsTuUsE+Yk8gmLlpVaFRppASbqs7GSqvf5J6i2QZM12OEAdXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=INvP6gVu; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745892808; x=1777428808;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=cl37MECxv3M+3URhi+36RMhj2hMQV9W9XGD1Q2/sh04=;
  b=INvP6gVufKO91G4YEFb5LDAGQLB2ZOoBqaNVTEZ++6ZTyT4ccdg+ciHG
   3M7tIfx6pJfsOZHUJbEnSdQB8I22mSJtdQ5G6GkALEEMAyIv9zYSJoXMZ
   jEXU2fvxmk8WP1qy8THSJMfzTF4w5J0mnbbR85xhufBrsrzeWG2+x0ig0
   ipUA5rj2AsTNYjeUotJZmyDbvH2w+PNvXgz4O09Nh0v5Y36aI8K+dVKDv
   x6ZMUTkoRsbOf8WyCXv58f+SbvMIhYagrcXDNjQMt7frLSV83RozorSlG
   i4cmi7E1ah/xfiYaKEQaK7SJD2tNZQWyoVK3L0yRVwmww/cLTLRSy9Vny
   Q==;
X-CSE-ConnectionGUID: 27iqQTDZRUe0QlmqofO6jA==
X-CSE-MsgGUID: aB13QRVEQ8+4Vmc9wwBDrw==
X-IronPort-AV: E=McAfee;i="6700,10204,11417"; a="47641300"
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="47641300"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 19:13:27 -0700
X-CSE-ConnectionGUID: vTMeR4UxT2GBmzm6ilMYHw==
X-CSE-MsgGUID: qu1jwlhkTHumLQTjOKxa+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="137721865"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 19:13:19 -0700
Message-ID: <abbb616e-9ca2-4811-8721-9aa746a4d600@linux.intel.com>
Date: Tue, 29 Apr 2025 10:09:07 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 02/24] dma-mapping: move the PCI P2PDMA mapping
 helpers to pci-p2pdma.h
To: Leon Romanovsky <leon@kernel.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>
Cc: Jake Edge <jake@lwn.net>, Jonathan Corbet <corbet@lwn.net>,
 Jason Gunthorpe <jgg@ziepe.ca>, Zhu Yanjun <zyjzyj2000@gmail.com>,
 Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
 Bjorn Helgaas <bhelgaas@google.com>, Logan Gunthorpe <logang@deltatee.com>,
 Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 Kevin Tian <kevin.tian@intel.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
 linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
 kvm@vger.kernel.org, linux-mm@kvack.org,
 Niklas Schnelle <schnelle@linux.ibm.com>,
 Chuck Lever <chuck.lever@oracle.com>, Luis Chamberlain <mcgrof@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Dan Williams
 <dan.j.williams@intel.com>, Kanchan Joshi <joshi.k@samsung.com>,
 Chaitanya Kulkarni <kch@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>
References: <cover.1745831017.git.leon@kernel.org>
 <1c9f2a2e97f77d6eebb5e19651723c0459e0dc29.1745831017.git.leon@kernel.org>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <1c9f2a2e97f77d6eebb5e19651723c0459e0dc29.1745831017.git.leon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/28/25 17:22, Leon Romanovsky wrote:
> From: Christoph Hellwig<hch@lst.de>
> 
> To support the upcoming non-scatterlist mapping helpers, we need to go
> back to have them called outside of the DMA API.  Thus move them out of
> dma-map-ops.h, which is only for DMA API implementations to pci-p2pdma.h,
> which is for driver use.
> 
> Note that the core helper is still not exported as the mapping is
> expected to be done only by very highlevel subsystem code at least for
> now.
> 
> Signed-off-by: Christoph Hellwig<hch@lst.de>
> Reviewed-by: Logan Gunthorpe<logang@deltatee.com>
> Acked-by: Bjorn Helgaas<bhelgaas@google.com>
> Tested-by: Jens Axboe<axboe@kernel.dk>
> Reviewed-by: Luis Chamberlain<mcgrof@kernel.org>
> Signed-off-by: Leon Romanovsky<leonro@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

