Return-Path: <kvm+bounces-53919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E839CB1A470
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 16:19:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B75EE180E8A
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 14:18:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C182526D4DA;
	Mon,  4 Aug 2025 14:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rcZdA0LS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C097925D53C;
	Mon,  4 Aug 2025 14:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754317096; cv=none; b=H8EdoLc21fnpid/EC49m9GblMO+o5PItr6/2Wvh9RNUq+jVsItYxhAQ9Teks9jUqK6p++C3jcT1s3jZDXe2BAJ+lJ5IoNF1cGmfma6CWl+LTSDRV0JPHGF8m0EVHXwQtV/fRnfj52cwKeN2IcRXsrhhgwma1/rgFYRWiVXfltUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754317096; c=relaxed/simple;
	bh=Zr3kPkorN9J0wHoU77coJxVhd5vO47zAf6WxVna9oFs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gyrxtZuXxgRb42kUXyLdOtiiBWzSG+RnWxPzAVKbqCjoNJuVxrHubbvQ5q8dbsX6P6lWGs89IGQ7sQGS8yYhmBv9T4F5e+Y6TA7cdAOZuN3gkCZQhrlOr1iG7FewD5yO5onKZdD46LxYyft8a639xyPtgHWH188LQfWDZsrYVKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rcZdA0LS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ED16C4CEE7;
	Mon,  4 Aug 2025 14:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754317096;
	bh=Zr3kPkorN9J0wHoU77coJxVhd5vO47zAf6WxVna9oFs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rcZdA0LSgVnIJ/ja+rzujOZjYxEuQpnBSSJNlhmM+uIS36PMWIvxGnxJBKVGS0y/k
	 vBjKAwytVDKvxwg3o4C9JLt2cc5Xf3Ulyggy/L7MyOHzWrqYM35ShQ8xJDtl2YOAB7
	 3wGRmkXADNX6dFnB5tDVmYtUzfYrZkmqh/fAJX007BI21XLotatJs14FAYy7dz2Pqv
	 Eb7LFQAA4+jV/XnEzEvrRUpolhq+I8mzh+IQZcnXLb5j7+5cmwoKzIv7/4Y2lgrdRR
	 b8oxjcA0vaYNH78RQuyAh19r+u1Tc+UWreSga05cOcSy8fmAwfSkJk+8HgQjXZFhcc
	 /nh+mNJsc6Ehw==
Date: Mon, 4 Aug 2025 17:18:11 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Christoph Hellwig <hch@lst.de>, dri-devel@lists.freedesktop.org,
	iommu@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v1 00/10] vfio/pci: Allow MMIO regions to be exported
 through dma-buf
Message-ID: <20250804141811.GT402218@unreal>
References: <cover.1754311439.git.leon@kernel.org>
 <20250804141032.GA30056@kvack.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250804141032.GA30056@kvack.org>

On Mon, Aug 04, 2025 at 10:10:32AM -0400, Benjamin LaHaise wrote:
> FYI: this entire patch series was rejected as spam by large numbers of
> linux-mm subscribers using @gmail.com email addresses.

Thanks for the heads-up. Are you aware of any issues from my side?
I'm sending patches with git-send-email through mail.kernel.org SMTP.

Thanks

> 
> 		-ben (owner-linux-mm)

