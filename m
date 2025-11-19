Return-Path: <kvm+bounces-63711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CC81AC6EE78
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 14:31:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id 885522E797
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 13:31:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B01D736402E;
	Wed, 19 Nov 2025 13:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CJmkRcmE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646CA35F8D5;
	Wed, 19 Nov 2025 13:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763559006; cv=none; b=OsxAGs2Y6GLMGTc9RE1o86bmKfN9qh7YHNhLXd/zPbBSjqPucs00ELuz01jUGreovu+j7xoMtuhnelfjMF5WQqNj07mw6YNBFvpkReilu/lXxHFTQ/fZddzwzV2qxiu7AmTKfuZMQKNoyxdpZDeT65Zke+Dos2nT7/PSpk7L7pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763559006; c=relaxed/simple;
	bh=T77xD4ouQwJfrrfoYJul3nkxhRgI6f45RqfVLeuXla0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SV2ksn5aIc874Bm0gUUWa5npBeqC0QNTxP9cpad0e8/DxZBpnAMj3tiHW+emQUJZj3FBxzhl+zlWL46XLQ6CLc3jVzGjGuGdLabiYV97B45YWUrQrJ6K94ii4loEvzDMqzVQ8ZLVgy45bllcJDNj7qbLRBgzkXgQUad5jNZW0Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CJmkRcmE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B920DC19425;
	Wed, 19 Nov 2025 13:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763559005;
	bh=T77xD4ouQwJfrrfoYJul3nkxhRgI6f45RqfVLeuXla0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CJmkRcmExDwPt0NuCANFi896HuCFEIGU3LYAoLvhl8S3uU9mfBypEzVSr32GsqZy0
	 9/i6r19RZmZ62wtupphqnAO8hbyri/wPrlx+2egmQAVVAfXzAjAQg9//PYFGan5bni
	 pk0qcg+vRudcykukDUhBBIgqjiqJBtVsRDmSGRqW0pz5Gglk6LGSk41HQnN10/vOll
	 y837YDb/TkXoHX8I8N3jo+MHBgeNPV8Cz170FjUyldCJaY8TGh2bFXWSLULpw+FO6d
	 eb4+355odBMqKRZiIPwYiwF+iwiQXKJMUxv42Leegovr8lnDq2Mv1Ats+WCCrLVsSJ
	 k/AyOs5u/QaIA==
Date: Wed, 19 Nov 2025 15:30:00 +0200
From: Leon Romanovsky <leon@kernel.org>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
	Alex Mastro <amastro@fb.com>, Nicolin Chen <nicolinc@nvidia.com>
Subject: Re: [PATCH v8 06/11] dma-buf: provide phys_vec to scatter-gather
 mapping routine
Message-ID: <20251119133000.GB18335@unreal>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-6-fd9aa5df478f@nvidia.com>
 <BN9PR11MB5276BC3C0BDA85F0259A35058CD7A@BN9PR11MB5276.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276BC3C0BDA85F0259A35058CD7A@BN9PR11MB5276.namprd11.prod.outlook.com>

On Wed, Nov 19, 2025 at 05:54:55AM +0000, Tian, Kevin wrote:
> > From: Leon Romanovsky <leon@kernel.org>
> > Sent: Tuesday, November 11, 2025 5:58 PM
> > +
> > +	if (dma->state && dma_use_iova(dma->state)) {
> > +		WARN_ON_ONCE(mapped_len != size);
> 
> then "goto err_unmap_dma".

It never should happen, there is no need to provide error unwind to
something that you won't get.

> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>

Thanks

