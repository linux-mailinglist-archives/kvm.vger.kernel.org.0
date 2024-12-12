Return-Path: <kvm+bounces-33566-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D1B889EE19F
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 09:43:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E7D8165B93
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 08:43:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3BE720E034;
	Thu, 12 Dec 2024 08:43:39 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E7B20DD5C;
	Thu, 12 Dec 2024 08:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733993019; cv=none; b=Fz6n2doIfYy4L79ZVmWPHzGJbJWDjnsfKjFdubSKyHC8ox8/pFoItweKQ8Zfea+wTsC5EacWj26XI7wACvwmeLz21ezyp9FzQMy5TB1iO+tvCFT+fakwWQNtftCMRulipeBY7HnxsO80Lm1L0zjj5R3N1LCrpNdO1d9hpKpm8LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733993019; c=relaxed/simple;
	bh=8RFl2CwqYMkojD/dZ9pLtIVUQrwduMq474AnTdZJzds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=APOupzgKU7IDVerJO+Rw9rlhlgpNtVOLWkxOyT8wctORRuLkgU0HB7TuhTRZRThlbMNn59VqV+drWS3IuviLPF6kLvePWxPKcKrYztXbc0DquYxP0DDW3J9Ru258g0DPRt6s1RuXTZ3QpjgKmahrE8fiaGcDfkp0RuKV/my8aOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EBD0A68D17; Thu, 12 Dec 2024 09:43:32 +0100 (CET)
Date: Thu, 12 Dec 2024 09:43:32 +0100
From: Christoph Hellwig <hch@lst.de>
To: Leon Romanovsky <leon@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Leon Romanovsky <leonro@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
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
	kvm@vger.kernel.org, linux-mm@kvack.org,
	Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v4 08/18] dma-mapping: Implement link/unlink ranges API
Message-ID: <20241212084332.GD9376@lst.de>
References: <cover.1733398913.git.leon@kernel.org> <50de680233f2947594471d30976565c209bf7864.1733398913.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50de680233f2947594471d30976565c209bf7864.1733398913.git.leon@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

> +static inline int dma_iova_sync(struct device *dev, struct dma_iova_state *state,

Please avoid the overly long line here.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

