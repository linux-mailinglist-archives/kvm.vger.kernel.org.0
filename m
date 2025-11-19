Return-Path: <kvm+bounces-63717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 08F30C6F107
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 14:55:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 40ED135AC6F
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 13:46:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BB713624A7;
	Wed, 19 Nov 2025 13:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t75TnyXa"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F26035A151;
	Wed, 19 Nov 2025 13:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763559934; cv=none; b=Dy4EdMDMK+WS6Dmvkm+Kp1J0Swaxt3NZ4NVfPvFv9Jsashw8I/T8+8H9O2fEcmY9QpZF1b73N6kcC6jWmz1SMdUyUBRmjhblf+LRYytDDjGzKM/uX6CNc0qpUwzc9RIDWos2dXUd2ANzn5KztXNZBb7mAoTvBJfpRD9Zy1LcIso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763559934; c=relaxed/simple;
	bh=P3o8RHvDAEnUuERCe1BMnR1YwR+dMea/ZoAi5ZBXv90=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lbf/AEABb3uAI1ThvZVvGpffm8GAltUHtFkwbJeYhI75EkNH+FkF00zu0jSOqtumrX+mZQMa0xMLHZML545DeDIZuZPsAyxPR5/q1rj1S/1lh465h2Trg8FpXZuhVw1I7iuzNtHHy71phLEi6s6njohhT4CcIpOoJLmW1cR7+O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t75TnyXa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD7BBC16AAE;
	Wed, 19 Nov 2025 13:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763559931;
	bh=P3o8RHvDAEnUuERCe1BMnR1YwR+dMea/ZoAi5ZBXv90=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t75TnyXaIaLVKA8TVdFOIbUfmeHo4/btOI2oLFyTwx1lCjsveSchI1EBPOOc8OfEU
	 7QixraT3KFGSPUvnTVnRthbFaGMDxNTZWUo5Tcxjf6aH53rpaqGFLVSFMNLDizUd3A
	 QwSiZmvD//HgnssiilLrKxRM4vZ6cmc99aE4Coipe6CFlk1vQCZdASthF5vaDcQnkL
	 MZ/cNswguYwRmgNRRMqMXz+l4ErdZVCb5X7Kve7bjXyjaAi9nArERygQ5n0D8BaTA5
	 3+fmL+QNcnPUcs4ADrhIjk+gdWlLU2nzJQQ5TGivxfxYWknTlcOCS90Tp/YEkddNL6
	 Jp9XI6WLvWISQ==
Date: Wed, 19 Nov 2025 15:45:26 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "Tian, Kevin" <kevin.tian@intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
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
Message-ID: <20251119134526.GE18335@unreal>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-6-fd9aa5df478f@nvidia.com>
 <BN9PR11MB5276BC3C0BDA85F0259A35058CD7A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20251119133000.GB18335@unreal>
 <20251119133708.GM17968@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251119133708.GM17968@ziepe.ca>

On Wed, Nov 19, 2025 at 09:37:08AM -0400, Jason Gunthorpe wrote:
> On Wed, Nov 19, 2025 at 03:30:00PM +0200, Leon Romanovsky wrote:
> > On Wed, Nov 19, 2025 at 05:54:55AM +0000, Tian, Kevin wrote:
> > > > From: Leon Romanovsky <leon@kernel.org>
> > > > Sent: Tuesday, November 11, 2025 5:58 PM
> > > > +
> > > > +	if (dma->state && dma_use_iova(dma->state)) {
> > > > +		WARN_ON_ONCE(mapped_len != size);
> > > 
> > > then "goto err_unmap_dma".
> > 
> > It never should happen, there is no need to provide error unwind to
> > something that you won't get.
> 
> It is expected that WARN_ON has recovery code, if it is possible and
> not burdensome.

It’s not necessary, but since I’m calculating mapped_len again, it’s natural—and completely
harmless—to double-check the arithmetic.

Thanks

> 
> Jason

