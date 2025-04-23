Return-Path: <kvm+bounces-43945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F56DA98F39
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 17:06:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 068583AA523
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 14:59:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 232DA284B2F;
	Wed, 23 Apr 2025 14:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rNAIeayX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E20A280CDC;
	Wed, 23 Apr 2025 14:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420337; cv=none; b=Lmc+CaM2y3DwbxypYB691e08zoYtfXjty05T63sHmWKhNJvac0VayM6P4kk5SfDKeAnoXDFW9BYQn1Raxr4bZd6zQdW4h+OFBVF6S+S0G4Skm+99q38xU4u0QAj/feFeBmEXamvvPr4CozcBn7lqrJZfkIsLYov44grkQZ2cGlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420337; c=relaxed/simple;
	bh=Cq/9ebClxlVbVqFqG5/6zORZ18/N3r0Ih3h4rsgmibY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YtCMF+BiR1J/6Jc7ehBZPb26tR8eHPSTNzLZEl0fiUi7VGTTgr66eblCnp3tmSIaMfwRGEmLeyU7/VQnlmoTLqBhpKTWP6C+ErRhlnsBYe6/tYBMvczrNjv7R7PHOC7q+8I5ai1dPk+W3Y0rpwsugEQWGYq5AL+5Du7Ozn0dRu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rNAIeayX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E6EEC4CEE3;
	Wed, 23 Apr 2025 14:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745420336;
	bh=Cq/9ebClxlVbVqFqG5/6zORZ18/N3r0Ih3h4rsgmibY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rNAIeayXStayTh+kdSzMXaruBcLJXQoaQdrPfgYfteRcWk5W3bpzX/9lOPNmTRawT
	 3Js8n/jzA0KcrggLtIDYykZlPj6Dez+Yrx3Z9APc1t4hhfKysBTJkG0duPuNwBnGks
	 0sGpxPSNXrScaZ1ZIlrdsqsiEWDsoZMPg15dosv1MW/ySTAaOgCmQLtKdBwGsHiVTZ
	 1SBYhdxbfYY3VuqejbFMedI1znQqqlAc4ideI8ClyIhmPZGcJE6eB6IQ4iR3ICvNqX
	 aQmYnghFpNOVpmT0E+j6DR29WFQtH/r3ajJ27yThOcM7hr5AG84maPgUId3dJkxSan
	 aVj53L0H7Llpg==
Date: Wed, 23 Apr 2025 08:58:51 -0600
From: Keith Busch <kbusch@kernel.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Jake Edge <jake@lwn.net>, Jonathan Corbet <corbet@lwn.net>,
	Jason Gunthorpe <jgg@ziepe.ca>, Zhu Yanjun <zyjzyj2000@gmail.com>,
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
	Nitesh Shetty <nj.shetty@samsung.com>,
	Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH v9 23/24] nvme-pci: convert to blk_rq_dma_map
Message-ID: <aAkAKyr4fbd5sLCH@kbusch-mbp.dhcp.thefacebook.com>
References: <cover.1745394536.git.leon@kernel.org>
 <7c5c5267cba2c03f6650444d4879ba0d13004584.1745394536.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c5c5267cba2c03f6650444d4879ba0d13004584.1745394536.git.leon@kernel.org>

On Wed, Apr 23, 2025 at 11:13:14AM +0300, Leon Romanovsky wrote:
> +static bool nvme_try_setup_sgl_simple(struct nvme_dev *dev, struct request *req,
> +				      struct nvme_rw_command *cmnd,
> +				      struct blk_dma_iter *iter)
> +{
> +	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
> +	struct bio_vec bv = req_bvec(req);
> +
> +	if (IS_ENABLED(CONFIG_PCI_P2PDMA) && (req->cmd_flags & REQ_P2PDMA))
> +		return false;
> +
> +	if ((bv.bv_offset & (NVME_CTRL_PAGE_SIZE - 1)) + bv.bv_len >
> +			NVME_CTRL_PAGE_SIZE * 2)
> +		return false;

We don't need this check for SGLs. If we have a single segment, we can
put it in a single SG element no matter how large it is.

