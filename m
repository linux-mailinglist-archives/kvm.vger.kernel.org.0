Return-Path: <kvm+bounces-43914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E2EADA986B3
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 12:03:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 57CE07A3CDC
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 10:02:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4158C26A095;
	Wed, 23 Apr 2025 10:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hZVOvTXy"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E501BEF77;
	Wed, 23 Apr 2025 10:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745402601; cv=none; b=WQzHX7rf8FlrPyWhI0SOUn/BYL97et3s4MrZgI6PqrXmc5GV8QPe1gwEeIcvSUnr+BK4IVf6ESpYjEub1ksaWEBPcU+2uwt/RLvXymPYGuSto/V8pu5DYhPx5jjlu3gTKo2rfO3TYuJFmXFrYjzeV+t0sL8+upWRYFDN9Fd4NZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745402601; c=relaxed/simple;
	bh=ngFXadZZHp3LPPaxf54ODFSjNSzh1Ht+VnoqS5cPk+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kgDvXq+Alenvy7HgrJYkF5Yx1SpVYfLjGMykW3nCnFBb3wNdbmR7gRPddJkqojOnGl4Dr3Me6dsBWo+fLDClsTSs46Att6xStpJvvxNXvmYHr4oTkki+5v7j5nWW8ssPI70td0XN/CSrRbrfMtczEE4qc5QlfqJCsMDeaYJDM/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hZVOvTXy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306B7C4CEF0;
	Wed, 23 Apr 2025 10:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745402599;
	bh=ngFXadZZHp3LPPaxf54ODFSjNSzh1Ht+VnoqS5cPk+c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hZVOvTXyIaWu4bWId/pgxHxX3JrlaR2NClh5I234YwqF4+sVvvroq/dIj+b8OjPW3
	 8orSr5dvocbOlvIf0eFunxzGREOoUPlzqIip2kuqN0MhBpEz0dNLFk9675T/YjxGz+
	 RpafWcy0eGJ6cWbhqqpSjQkJNob79JzSWhPiR9jAtFbZN6VWaYovYldutOlXgPlHkY
	 DDy7D7JXKoau0CdAa1x6kIMY8EFuRXqN0o+H/pshkFrr5423vPoezWmpzPSxrwuAnP
	 GDNBoXhQDCW3daIwdE2ndGPPWwR835rpe3Wze8PBHYJYp2ZHjHNeCXv2uyCrCUPv4I
	 aEpVIWzBnV4Aw==
Date: Wed, 23 Apr 2025 13:03:14 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>, Jake Edge <jake@lwn.net>,
	Jonathan Corbet <corbet@lwn.net>, Jason Gunthorpe <jgg@ziepe.ca>,
	Zhu Yanjun <zyjzyj2000@gmail.com>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Nitesh Shetty <nj.shetty@samsung.com>
Subject: Re: [PATCH v9 23/24] nvme-pci: convert to blk_rq_dma_map
Message-ID: <20250423100314.GH48485@unreal>
References: <cover.1745394536.git.leon@kernel.org>
 <7c5c5267cba2c03f6650444d4879ba0d13004584.1745394536.git.leon@kernel.org>
 <20250423092437.GA1895@lst.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250423092437.GA1895@lst.de>

On Wed, Apr 23, 2025 at 11:24:37AM +0200, Christoph Hellwig wrote:
> I don't think the meta SGL handling is quite right yet, and the
> single segment data handling also regressed.  Totally untested
> patch below, I'll try to allocate some testing time later today.

Christoph,

Can we please progress with the DMA patches and leave NVMe for later?
NVMe is one the users for new DMA API, let's merge API first.

Thanks

