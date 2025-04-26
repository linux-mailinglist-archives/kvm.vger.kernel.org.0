Return-Path: <kvm+bounces-44387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AEF4A9D6BE
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 02:34:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF56C1C00537
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 00:34:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDC591F462F;
	Sat, 26 Apr 2025 00:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k5REWfbH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E534F5A79B;
	Sat, 26 Apr 2025 00:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745627658; cv=none; b=bjqJ2B/4mXFUKh/cW/5SxZ1A9zpfpStuMzo/8e9t1gRUdHHqVfinMd63kJXRaLNIT3VOyfzD6bgfE6sl7xYeAHmmWRj4EP7N6QnUpmNa54Nm33p1Ds7fF+kWDdJ2QNoS92MH9aeLupshI3/4vur/o9n3arQOP/z4A4PzinA8zBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745627658; c=relaxed/simple;
	bh=gP3gwxgNw7FZrnmpPmzzPgN9aXPBN23+6+4ANBvGC9w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nL9WPsMBiEUb8zb+U0hcS60syRwPEM8INyWxEONzDfPGwyOtL3n78o3HZOJNOoXysBURVbuVOqToqny4utr5GxpAZat2IAgFibXSlyOJJclqtwc3a0u4u0nelAR337NCe865LZxa7RncULWAtsWyKb/hZrYLrK5fdNocClnifo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k5REWfbH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 610E9C4CEE4;
	Sat, 26 Apr 2025 00:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745627657;
	bh=gP3gwxgNw7FZrnmpPmzzPgN9aXPBN23+6+4ANBvGC9w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k5REWfbHKSUvcglP1TpsrQx/rq1FAKn2v2KHy+BXjjaPljIS5n6SQK9pVphFinRnx
	 iiZmWQcYqMCRenOrXGgkymILO6xDnjVdTIYpTwlC3124iJI/lqBnVkjVDeyHa3k2Zi
	 AonqUn2JHmINYqVkRLWYeWOCDjqFjcathYX0Qq+u6FkpKKd0j1WSGxWchvgjaJDyxN
	 2P31MVsu9VM6jv5ZklMDygNJJkrtglm54XJC2zPLQA1Asos5rowVnKiOk52+CPyCFW
	 vYxLICwro5pr/DvALNKeCg7BcMKkO1MMGoCQvVAYmjFgzzR23x5OnOOsuVFqTivGU6
	 Jb/EjtzwtiErw==
Date: Fri, 25 Apr 2025 17:34:14 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>, Jake Edge <jake@lwn.net>,
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
	Matthew Wilcox <willy@infradead.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH v9 02/24] dma-mapping: move the PCI P2PDMA mapping
 helpers to pci-p2pdma.h
Message-ID: <aAwqBvLP3kaZsEdZ@bombadil.infradead.org>
References: <cover.1745394536.git.leon@kernel.org>
 <493a6ab31fdd73e84e16662578858f194e9f87b9.1745394536.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <493a6ab31fdd73e84e16662578858f194e9f87b9.1745394536.git.leon@kernel.org>

On Wed, Apr 23, 2025 at 11:12:53AM +0300, Leon Romanovsky wrote:
> From: Christoph Hellwig <hch@lst.de>
> +enum pci_p2pdma_map_type {
> +	/*
> +	 * PCI_P2PDMA_MAP_UNKNOWN: Used internally for indicating the mapping
> +	 * type hasn't been calculated yet. Functions that return this enum
> +	 * never return this value.
> +	 */

This last sentence is confusing. How about:

* PCI_P2PDMA_MAP_UNKNOWN: Used internally as an initial state before
* the mapping type has been calculated. Exported routines for the API
* will never return this value.

> +	PCI_P2PDMA_MAP_UNKNOWN = 0,
> +
> +	/*
> +	 * Not a PCI P2PDMA transfer.
> +	 */
> +	PCI_P2PDMA_MAP_NONE,
> +
> +	/*
> +	 * PCI_P2PDMA_MAP_NOT_SUPPORTED: Indicates the transaction will
> +	 * traverse the host bridge and the host bridge is not in the
> +	 * allowlist. DMA Mapping routines should return an error when
> +	 * this is returned.
> +	 */
> +	PCI_P2PDMA_MAP_NOT_SUPPORTED,
> +
> +	/*
> +	 * PCI_P2PDMA_BUS_ADDR: Indicates that two devices can talk to

You mean   PCI_P2PDMA_MAP_BUS_ADDR

> + * pci_p2pdma_bus_addr_map - map a PCI_P2PDMA_MAP_BUS_ADDR P2P transfer

Hrm, maybe with a bit more clarity:

Translate a physical address to a bus address for a  PCI_P2PDMA_MAP_BUS_ADDR
transfer.


Other than that.

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis

