Return-Path: <kvm+bounces-67728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C1F2D1281B
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 13:20:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C6C703052471
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 12:20:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C6003570C8;
	Mon, 12 Jan 2026 12:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iL2K02pv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8931B2C21F3;
	Mon, 12 Jan 2026 12:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768220402; cv=none; b=DfDQFN0rrTo8HwD2+WwOHtKI+KamQp/DShjRLe/a0k9K9P7fwNg7tknpLwTgGFl94UUUT2ZGGxyqJmcoR3ZhWVjKw4v73Ur4WqNDs9oNPISiIQtJTczF7An+dGPVkjP56Zd0n2U+jPMdr3sj1Rxw7DY24V0gikIUUEiZWeYdKC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768220402; c=relaxed/simple;
	bh=+Nliq3Hq9k4ThIYArW3/W+oRJeWgrnz/ZUwpOJtv0cM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K+688+kJTHQ4HLSVF02wSH16ASWCT6732uP2dJVY9/JJZJV0HdLex233haeowDxr5N3qMXQz5pXw1/sqO2fU3X0YkyhT4tPVEi/bXLV1k8R8nyRan59TwBT/nWtNLLI23sxvA80wwe967TxkX5fTxPqBQi36YscFOyAUjVJvBEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iL2K02pv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 233D1C16AAE;
	Mon, 12 Jan 2026 12:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768220402;
	bh=+Nliq3Hq9k4ThIYArW3/W+oRJeWgrnz/ZUwpOJtv0cM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iL2K02pvk6E1DsvDlqWboBCtpQHXaKUBrL1wltPlg05hlgRoVPE9d6yCnJgpfHU3K
	 5wnwkxG9AmFATvFjjgHmhJmW/kYdcxNn5zEl7CCQGsXozborPGix1NS3B6tfKluFUp
	 4+jaQq6nlsWR88DToo/mPKJ87brhQnhnntP/R+nXtW3dhiXFicBW1f3BpAsty+mLjZ
	 99FE2FBFc/kRsz2G+ht2VEMhhnQ2twEqyml4iPXDcjXNFCp0ahYY66D1dhde+2mS0q
	 8Y77nf0bPjNjJG2JcBS0x7Evxif8Ub6tPWPTIo5nqywmPi5aJOLKCeAsDSKhiNLd77
	 0aouxLftPfDUw==
Date: Mon, 12 Jan 2026 14:19:56 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Sumit Semwal <sumit.semwal@linaro.org>,
	Alex Williamson <alex@shazbot.org>,
	Kevin Tian <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
	iommu@lists.linux.dev
Subject: Re: [PATCH 0/4] dma-buf: add revoke mechanism to invalidate shared
 buffers
Message-ID: <20260112121956.GE14378@unreal>
References: <20260111-dmabuf-revoke-v1-0-fb4bcc8c259b@nvidia.com>
 <eed9fd4c-ca36-4f6a-af10-56d6e0997d8c@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <eed9fd4c-ca36-4f6a-af10-56d6e0997d8c@amd.com>

On Mon, Jan 12, 2026 at 11:04:38AM +0100, Christian König wrote:
> On 1/11/26 11:37, Leon Romanovsky wrote:
> > This series implements a dma-buf “revoke” mechanism: to allow a dma-buf
> > exporter to explicitly invalidate (“kill”) a shared buffer after it has
> > been distributed to importers, so that further CPU and device access is
> > prevented and importers reliably observe failure.
> 
> We already have that. This is what the move_notify is all about.
> 
> > Today, dma-buf effectively provides “if you have the fd, you can keep using
> > the memory indefinitely.” That assumption breaks down when an exporter must
> > reclaim, reset, evict, or otherwise retire backing memory after it has been
> > shared. Concrete cases include GPU reset and recovery where old allocations
> > become unsafe to access, memory eviction/overcommit where backing storage
> > must be withdrawn, and security or isolation situations where continued access
> > must be prevented. While drivers can sometimes approximate this with
> > exporter-specific fencing and policy, there is no core dma-buf state transition
> > that communicates “this buffer is no longer valid; fail access” across all
> > access paths.
> 
> It's not correct that there is no DMA-buf handling for this use case.
> 
> > The change in this series is to introduce a core “revoked” state on the dma-buf
> > object and a corresponding exporter-triggered revoke operation. Once a dma-buf
> > is revoked, new access paths are blocked so that attempts to DMA-map, vmap, or
> > mmap the buffer fail in a consistent way.
> > 
> > In addition, the series aims to invalidate existing access as much as the kernel
> > allows: device mappings are torn down where possible so devices and IOMMUs cannot
> > continue DMA.
> > 
> > The semantics are intentionally simple: revoke is a one-way, permanent transition
> > for the lifetime of that dma-buf instance.
> > 
> > From a compatibility perspective, users that never invoke revoke are unaffected,
> > and exporters that adopt it gain a core-supported enforcement mechanism rather
> > than relying on ad hoc driver behavior. The intent is to keep the interface
> > minimal and avoid imposing policy; the series provides the mechanism to terminate
> > access, with policy remaining in the exporter and higher-level components.
> 
> As far as I can see that patch set is completely superfluous.
> 
> The move_notify mechanism has been implemented exactly to cover this use case and is in use for a couple of years now.
> 
> What exactly is missing?

From what I can tell, the missing piece is what happens after .move_notify()
is called. According to the documentation, the exporter remains valid, and
the importer is expected to recreate all mappings.

include/linux/dma-buf.h:
  471          * Mappings stay valid and are not directly affected by this callback.
  472          * But the DMA-buf can now be in a different physical location, so all
  473          * mappings should be destroyed and re-created as soon as possible.
  474          *
  475          * New mappings can be created after this callback returns, and will
  476          * point to the new location of the DMA-buf.

Call to dma_buf_move_notify() does not prevent new attachments to that
exporter, while "revoke" does. In the current code, the importer is not aware
that the exporter no longer exists and will continue calling
dma_buf_map_attachment().

In summary, the current implementation allows a single .attach() check but
permits multiple .map_dma_buf() calls. With "revoke", we gain the ability to
block any subsequent .map_dma_buf() operations.

Main use case is VFIO as exporter and IOMMUFD as importer.

Thanks

> 
> Regards,
> Christian.
> 
> > 
> > BTW, see this megathread [1] for additional context.  
> > Ironically, it was posted exactly one year ago.
> > 
> > [1] https://lore.kernel.org/all/20250107142719.179636-2-yilun.xu@linux.intel.com/
> > 
> > Thanks
> > 
> > Cc: linux-rdma@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Cc: linux-media@vger.kernel.org
> > Cc: dri-devel@lists.freedesktop.org
> > Cc: linaro-mm-sig@lists.linaro.org
> > Cc: kvm@vger.kernel.org
> > Cc: iommu@lists.linux.dev
> > To: Jason Gunthorpe <jgg@ziepe.ca>
> > To: Leon Romanovsky <leon@kernel.org>
> > To: Sumit Semwal <sumit.semwal@linaro.org>
> > To: Christian König <christian.koenig@amd.com>
> > To: Alex Williamson <alex@shazbot.org>
> > To: Kevin Tian <kevin.tian@intel.com>
> > To: Joerg Roedel <joro@8bytes.org>
> > To: Will Deacon <will@kernel.org>
> > To: Robin Murphy <robin.murphy@arm.com>
> > 
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> > Leon Romanovsky (4):
> >       dma-buf: Introduce revoke semantics
> >       vfio: Use dma-buf revoke semantics
> >       iommufd: Require DMABUF revoke semantics
> >       iommufd/selftest: Reuse dma-buf revoke semantics
> > 
> >  drivers/dma-buf/dma-buf.c          | 36 ++++++++++++++++++++++++++++++++----
> >  drivers/iommu/iommufd/pages.c      |  2 +-
> >  drivers/iommu/iommufd/selftest.c   | 12 ++++--------
> >  drivers/vfio/pci/vfio_pci_dmabuf.c | 27 ++++++---------------------
> >  include/linux/dma-buf.h            | 31 +++++++++++++++++++++++++++++++
> >  5 files changed, 74 insertions(+), 34 deletions(-)
> > ---
> > base-commit: 9ace4753a5202b02191d54e9fdf7f9e3d02b85eb
> > change-id: 20251221-dmabuf-revoke-b90ef16e4236
> > 
> > Best regards,
> > --  
> > Leon Romanovsky <leonro@nvidia.com>
> > 
> 
> 

