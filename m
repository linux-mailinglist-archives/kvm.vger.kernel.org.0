Return-Path: <kvm+bounces-44633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DB4CA9FF85
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 04:13:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C4CD948125D
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 02:13:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FD9C253F30;
	Tue, 29 Apr 2025 02:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NMPPqWUL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1D9253B55;
	Tue, 29 Apr 2025 02:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745892780; cv=none; b=WaW0c/33T3dvAD7Qc5POaa1Ysnm8wdxxJXqixBBHF/xDEtDjNlPgxOpwb0tF8LPMnGEI37gvIXrumMDGf5DUTHjy2dI6Foaq4y5oOq4MgjWZz7sKlfC/tigT2Bdpdcl9FP03p87N73SCd/EsmuFrGYBR8+6/jrVfX721NmABaNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745892780; c=relaxed/simple;
	bh=zIBZEkzEz0qHWJg5nnrZmToWJe3AlL91ty8mA9UxuEk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GUCwl+r908L/6duPZ08XuhS0Ah7FNCX31rv3Zw4UFygMmF7zMz4B6ODAUSRFnY2EiONegxsh+oac9XXKwjaJigyPqfpRAbqULDvzxgIY/k0wev9SSHZ7/rd/odtHWZeMdEaJnuajrREHAu/f78ghDMpS1aUBsYmAXLzQrcqiWY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NMPPqWUL; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745892779; x=1777428779;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zIBZEkzEz0qHWJg5nnrZmToWJe3AlL91ty8mA9UxuEk=;
  b=NMPPqWULTuiZj5r+11XyLIcFclry8JZ8qz1qfNyFz0fF2MSe/5wfYFvG
   Zkfhda/f38AT3e3F5OcuptLqGsDTGTmAjzpsV7vg00lKwWiyyivu8SQBm
   Ttp5vSkMekVXUrbC1VLaSaYaiIEARKOqXHZ6CrKz5E+ttHkfz8o2CeVIP
   2CcFHDjwEFHqrn4p+C1EQW7T/THSgeddRZ57NV5l01mE7OYrKEPDxvv2F
   ckoXuWV9qkdEhSXSkpB/92XYl/PYmnzBWRbrRvGasdWpSnrlXATn67nHV
   tFTgkAl5HW1PKXPpD0yMu9KR5gB22h/TN3+N+1ux+DsuSe4fS4pZnOkVp
   w==;
X-CSE-ConnectionGUID: oTI2g/51Soe2Glddd+HPAg==
X-CSE-MsgGUID: HZN1SV/EScGO/cdKaCd/wg==
X-IronPort-AV: E=McAfee;i="6700,10204,11417"; a="47641264"
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="47641264"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 19:12:58 -0700
X-CSE-ConnectionGUID: PgtT/sVnTcyJIj7GTIKVrA==
X-CSE-MsgGUID: VBjHGcPQSj2zSMxum7MGbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="137721801"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 19:12:50 -0700
Message-ID: <c0d729e4-1082-486c-9aac-39ae1a2bbd41@linux.intel.com>
Date: Tue, 29 Apr 2025 10:08:36 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 01/24] PCI/P2PDMA: Refactor the p2pdma mapping helpers
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
 <3ad16e0fc3b8f66593a837c9cdcd34bda1e1ab22.1745831017.git.leon@kernel.org>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <3ad16e0fc3b8f66593a837c9cdcd34bda1e1ab22.1745831017.git.leon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/28/25 17:22, Leon Romanovsky wrote:
> From: Christoph Hellwig<hch@lst.de>
> 
> The current scheme with a single helper to determine the P2P status
> and map a scatterlist segment force users to always use the map_sg
> helper to DMA map, which we're trying to get away from because they
> are very cache inefficient.
> 
> Refactor the code so that there is a single helper that checks the P2P
> state for a page, including the result that it is not a P2P page to
> simplify the callers, and a second one to perform the address translation
> for a bus mapped P2P transfer that does not depend on the scatterlist
> structure.
> 
> Signed-off-by: Christoph Hellwig<hch@lst.de>
> Reviewed-by: Logan Gunthorpe<logang@deltatee.com>
> Acked-by: Bjorn Helgaas<bhelgaas@google.com>
> Tested-by: Jens Axboe<axboe@kernel.dk>
> Reviewed-by: Luis Chamberlain<mcgrof@kernel.org>
> Signed-off-by: Leon Romanovsky<leonro@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

