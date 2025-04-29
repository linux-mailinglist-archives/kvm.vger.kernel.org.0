Return-Path: <kvm+bounces-44638-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2579AA000C
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 04:42:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0744E7A5C2D
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 02:41:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 433AE29DB77;
	Tue, 29 Apr 2025 02:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q8QhjQYS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28EA221DAE;
	Tue, 29 Apr 2025 02:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745894533; cv=none; b=biTI8FdNhF+b6cbTWcIXQ/76JnRH2iQesHMEOGSsEQmhE0VRe0LmeVHZ6IudWUpMIuHXw//pL7b1kg4QMwq7nzA+aA5ElM3nRDkbvCO00DCb7DXwoqM7Ct95qd7gQDUZlKhk7V3+/kslBpM/hJ5HdIACZFWc/bm1n6ZDwYjyzA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745894533; c=relaxed/simple;
	bh=JEB13Q6qCJ3b8dvOA+ykH/XIbk5dBywfURD7c4iY0Ts=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JV676utP/05rf96U8eaJwMyJj/Y09KiwrOWMn34urByEs9GsRCskO71w9yejDz7PllKh46jhOH2bb48rr0ez+ib0ZIqGZA9HKAsjJk80i1ArwPZMChT6+Xs4CyB1Y6yZdOAjDY+dyr2ohMeUXbTzXi8RbrBuJcwMaDYVnnuAnTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q8QhjQYS; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745894532; x=1777430532;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JEB13Q6qCJ3b8dvOA+ykH/XIbk5dBywfURD7c4iY0Ts=;
  b=Q8QhjQYS24waaN/SWgpvOP0bm6SkSh6m9QIOTyXOwxAQkSGvaaUNhlE2
   xIc2K0zbFWQxC9e89+wglhnGRCLjOvftQjBzZnn+CSXhK0WagBOyjdkF7
   9iByWTKjuTeahNIZjEl5u7SBlXW4IyQ0Bfr3YzM6tz7oha6GA+tso3Kyd
   4pwc359bRKvoTOpG7QiYLnzZ7+5knPWlYrZaSoByyZDqYOTIVfrwVW+Mp
   oIIjfiopIKBUGtRqaSkc+o82ZsVJh9UzPfVujcwv5dS9zjEb0k0OYysbv
   kUJ+oinmQWgpgOtkxMi9X2SSJ3Ug1ngND9aJxCYFfwGjQCSqubNqcOzgz
   Q==;
X-CSE-ConnectionGUID: qQW6BDQsQmOKHlwQN4Sovg==
X-CSE-MsgGUID: RakiDtEjTd23kC1p+81D6A==
X-IronPort-AV: E=McAfee;i="6700,10204,11417"; a="58492526"
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="58492526"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 19:42:11 -0700
X-CSE-ConnectionGUID: cHWLk+ReRtiizI2k9hpzsQ==
X-CSE-MsgGUID: QL4CnKgYSfSVf8FrilpuPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="134208058"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 19:42:03 -0700
Message-ID: <73184520-4853-49cb-a3e2-8bb7311c91e1@linux.intel.com>
Date: Tue, 29 Apr 2025 10:37:50 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 04/24] iommu: add kernel-doc for iommu_unmap_fast
To: Leon Romanovsky <leon@kernel.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>
Cc: Leon Romanovsky <leonro@nvidia.com>, Jake Edge <jake@lwn.net>,
 Jonathan Corbet <corbet@lwn.net>, Jason Gunthorpe <jgg@ziepe.ca>,
 Zhu Yanjun <zyjzyj2000@gmail.com>, Robin Murphy <robin.murphy@arm.com>,
 Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, Bjorn Helgaas <bhelgaas@google.com>,
 Logan Gunthorpe <logang@deltatee.com>, Yishai Hadas <yishaih@nvidia.com>,
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
 Chaitanya Kulkarni <kch@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>
References: <cover.1745831017.git.leon@kernel.org>
 <6c4bbb539bec7b827b9e9cc24779c9e9c43fc3ed.1745831017.git.leon@kernel.org>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <6c4bbb539bec7b827b9e9cc24779c9e9c43fc3ed.1745831017.git.leon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/28/25 17:22, Leon Romanovsky wrote:
> From: Leon Romanovsky<leonro@nvidia.com>
> 
> Add kernel-doc section for iommu_unmap_fast to document existing
> limitation of underlying functions which can't split individual ranges.
> 
> Suggested-by: Jason Gunthorpe<jgg@nvidia.com>
> Acked-by: Will Deacon<will@kernel.org>
> Reviewed-by: Christoph Hellwig<hch@lst.de>
> Tested-by: Jens Axboe<axboe@kernel.dk>
> Reviewed-by: Jason Gunthorpe<jgg@nvidia.com>
> Reviewed-by: Luis Chamberlain<mcgrof@kernel.org>
> Signed-off-by: Leon Romanovsky<leonro@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

