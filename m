Return-Path: <kvm+bounces-21054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 598DD929153
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2024 08:26:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E1F9AB20DC3
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2024 06:26:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DC9A1CAA1;
	Sat,  6 Jul 2024 06:26:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1E118E06;
	Sat,  6 Jul 2024 06:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720247171; cv=none; b=itD6WTkqIdURCgSMKiXfelltqhEzbQ6HQpTsxZLuQ4jbS1y4rovX/JQNgvh3uQ+kyZtRx5ncNWfphHp8a1E2Kko2FSuKnhqXQo4H7RMAajBCq/VRrXWAJE5bhL3mfUMobWeVc4zduzZdEN8H8MJ0QK/s4u3yHBNKs4SYezxFOLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720247171; c=relaxed/simple;
	bh=qSS2aQCHFsEoF8vnLdLxeJXMBQprUWrDR4lqJIC0dEA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EPDf9mezaClkhyD0erbPXGbhv5Gb8FOEQay96HG1axJt85dddyqZFLtWzB2Y/OVgUkgIftFxZBIsEKxHl2665JUqJsijnwh+GmOFYnT6YcwP4CBO6kbMPoRs/hKDH4A3eBNJGLcHD0RpCwvkwwURAlyLo417REBWz0z91sfw48g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AA8AA68D0E; Sat,  6 Jul 2024 08:26:04 +0200 (CEST)
Date: Sat, 6 Jul 2024 08:26:04 +0200
From: Christoph Hellwig <hch@lst.de>
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>, Leon Romanovsky <leon@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Keith Busch <kbusch@kernel.org>,
	"Zeng, Oak" <oak.zeng@intel.com>, Sagi Grimberg <sagi@grimberg.me>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [RFC PATCH v1 00/18] Provide a new two step DMA API mapping API
Message-ID: <20240706062604.GA13874@lst.de>
References: <cover.1719909395.git.leon@kernel.org> <20240703054238.GA25366@lst.de> <20240703105253.GA95824@unreal> <20240703143530.GA30857@lst.de> <a7f1c69a-bbaf-4263-b2c2-3c92d65522c2@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7f1c69a-bbaf-4263-b2c2-3c92d65522c2@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jul 05, 2024 at 10:53:06PM +0000, Chaitanya Kulkarni wrote:
> I tried to reproduce this issue somehow it is not reproducible.
> 
> I'll try again on Leon's setup on my Saturday night, to fix that
> case.

It is passthrough I/O from userspace.  The address is not page aligned
as seen in the printk.  Forcing bounce buffering of all passthrough
I/O makes it go away.

The problem is the first mapped segment does not have to be aligned
and we're missing the code to places it at the aligned offset into
the IOVA space.


