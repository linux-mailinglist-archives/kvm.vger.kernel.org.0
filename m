Return-Path: <kvm+bounces-30152-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ECFB19B768D
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 09:35:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6C3D5B219A2
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 08:35:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8C211779A5;
	Thu, 31 Oct 2024 08:34:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38B72AE9A;
	Thu, 31 Oct 2024 08:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730363698; cv=none; b=eSzI/fetwgRQnc52w1LWvM/TDb/2QthXnhbS1SW0PwLuQDOzSl8o3E6INKB82kUtBXXBdLWHvOMYWljR+Z9a8VTkE28bq0j41pOve7Jg80QON3SaDEb1qONMZQk7dYNCB/q+HbSFz4HttziiHXk9UcvlBtCmckpS/JUYB/z0RuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730363698; c=relaxed/simple;
	bh=TXiHR1btkxsfQVvMzcWfM3VgAE9ZcVMqJEOFNo3etFE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nHIQzBfvNlNRfcxNnolczyKuCaEvcFn+tLdwDw5kKOvDiNMq9R9eyujQHiGe8doMo4Y4W6ZFC8nex5vQZXWDWhwkghsdrZnmhxnyoBkOqnvFFMWchm2MMHboKsQcQUeh6qgIU0AzMZroWDUoTY27gtDQC1Hg31xYLbfPZ03kiJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 86DED68AA6; Thu, 31 Oct 2024 09:34:50 +0100 (CET)
Date: Thu, 31 Oct 2024 09:34:50 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v1 00/17] Provide a new two step DMA mapping API
Message-ID: <20241031083450.GA30625@lst.de>
References: <cover.1730298502.git.leon@kernel.org> <3144b6e7-5c80-46d2-8ddc-a71af3c23072@kernel.dk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3144b6e7-5c80-46d2-8ddc-a71af3c23072@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Oct 30, 2024 at 07:44:13PM -0600, Jens Axboe wrote:
> On Christoph's request, I tested this series last week and saw some
> pretty significant performance regressions on my box. I don't know what
> the status is in terms of that, just want to make sure something like
> this doesn't get merged until that is both fully understood and sorted
> out.

Working on it, but I have way too many things going on at once.  Note
that the weird thing about your setup was that we apparently dropped into
the slow path, which still puzzles me.  But I should probably also look
into making that path a little less slow.


