Return-Path: <kvm+bounces-20894-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A2B1925B18
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 13:05:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 158C429C13F
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 11:04:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66A67180A8A;
	Wed,  3 Jul 2024 10:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nYd4RQLP"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB9717E8EE;
	Wed,  3 Jul 2024 10:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003978; cv=none; b=YOFF6x3j98aXgJyBC4HChTdc6evgc8WhOvRQvU0db/P30oRMVqi096cBcm9ulaW/bnxL5jdp7RFlbgopCe0eK0IWQa14ImB+pRu+TVv2GnfL+n6X5XQFGHfA3LtP/Ng2xJZ/XF6ShlHi8Ths8pwxfQEN9JKXEXOdFdYt5huy/Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003978; c=relaxed/simple;
	bh=pPz+aKLXZOghQ7VtjQHusi+fj+NpFq4VHkcVX8X3bH8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Olzs6C01dW/uyLIQV4DMxyTT65UVUaSAuBCPjmND+aZomXLHdK94+hCxwYIXM99Yw0R4Qz+NnZKoTGZ5NQxAhAgeedsVEDSEKiZ8eAp2XgRnLKPZqDnCS55f/vFlpcPNX6XR4KUQ3tMKdhbw9PBrFRMCDsLP0dT9y0j3qfLuxY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nYd4RQLP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836CAC4AF0B;
	Wed,  3 Jul 2024 10:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720003978;
	bh=pPz+aKLXZOghQ7VtjQHusi+fj+NpFq4VHkcVX8X3bH8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nYd4RQLPNWY78pIbNAILafDzME2V0q1JxD04RIMzYEVRTvt89jlLKvJriZcMCuH2T
	 w96uRRv/Q4LrMA7qbS+tVVzGZ8TbYD4a7uxMEPOOXtyhfAZjqiLtWvl7qwC+YZD5Ba
	 v6Hluy8LaijXySSMoswEpGvrCLN3gkwpFP2bG31B2uIuuhMWFdHvJ6hmi9njK5bywp
	 geNwo4OuHZBuA495qG+lQBMrzBgxPLYgn8KinCmvDBq9hmAZenc9g0C6DeVOsibSX2
	 IVVgir3Al85xqpIrwp6ua76xZvzC0FWDuHMKCBDh5k2QhOV31v4/Nqa/LhITpDNtHG
	 1wsaj+G6o4oiw==
Date: Wed, 3 Jul 2024 13:52:53 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Keith Busch <kbusch@kernel.org>,
	"Zeng, Oak" <oak.zeng@intel.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v1 00/18] Provide a new two step DMA API mapping API
Message-ID: <20240703105253.GA95824@unreal>
References: <cover.1719909395.git.leon@kernel.org>
 <20240703054238.GA25366@lst.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703054238.GA25366@lst.de>

On Wed, Jul 03, 2024 at 07:42:38AM +0200, Christoph Hellwig wrote:
> I just tried to boot this on my usual qemu test setup with emulated
> nvme devices, and it dead-loops with messages like this fairly late
> in the boot cycle:
> 
> [   43.826627] iommu: unaligned: iova 0xfff7e000 pa 0x000000010be33650 size 0x1000 min_pagesz 0x1000
> [   43.826982] dma_mapping_error -12
> 
> passing intel_iommu=off instead of intel_iommu=on (expectedly) makes
> it go away.

Can you please share your kernel command line and qemu?
On my and Chaitanya setups it works fine.

Thanks

