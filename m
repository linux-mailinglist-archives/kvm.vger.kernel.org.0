Return-Path: <kvm+bounces-67664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 045F5D0E990
	for <lists+kvm@lfdr.de>; Sun, 11 Jan 2026 11:37:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B1FAA3014AE4
	for <lists+kvm@lfdr.de>; Sun, 11 Jan 2026 10:37:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D71093358BD;
	Sun, 11 Jan 2026 10:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GJfxDiwS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C11623C50A;
	Sun, 11 Jan 2026 10:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768127840; cv=none; b=EIaLDSzEYtm1uc0Y0jf/jYdHmgov8UVDPeqdzUQZ1eYOj0ugzt9lzbEN1AxJAsA4d/TzY4v9GVCRh+5dnjeR7XRj54fBpWH/OCZpTH/2Y5mqj54Afzecwq/JRClf6nMRjuSdIVW66tdbw/lgildUj1Cd5RYmfViAQr9Ot6THTcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768127840; c=relaxed/simple;
	bh=XZA4z75ZOHA3aBBuy9XF0n0lJ74IuJtROdjB9F6LTwg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KS8lQ61jmYzeWuycm3QNv161eCsSmr30pjyfZuGY2uKWYMeE8qWjUbBr7fl9SsdMGRQTA2pmDAqjFmST9jVv0C7pRlxKtXdbTnsPc4yLEADponHelLf9PBJCYMzDJC83UVOTv5EowMC4W6t5XEJT1Vs+hql0qPB0l6NfB3S0aVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GJfxDiwS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E15DC4CEF7;
	Sun, 11 Jan 2026 10:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768127839;
	bh=XZA4z75ZOHA3aBBuy9XF0n0lJ74IuJtROdjB9F6LTwg=;
	h=From:To:Cc:Subject:Date:From;
	b=GJfxDiwSgzusKIQpJZPvotpXqneRfIW4Aw0aoP73c8C0uMUG2kZo2uFwS4W+jq8Z/
	 ScyO11QB8QX+9Wp0ZPkxN5mbCMu8rBJk+2uz0yb2ZME/2iwTVCKsF6124sJPF8Y58m
	 nCjdl0+oRyz1N224ttGKmOFL8AElqtrQei4VQRO8+UEBiVJxjxr9rLvjYvfGd243co
	 pAQ96WtNcurKnh+UHt2hfeCfpNOmGe6+mOI9/4GVuhENuJItjyZHEsqeJTvzBNm9kh
	 Z4bM3XW0wzDb6a7RZldoMydvWeT6tErDqQScE1ckUiHKNtOMHLhvXEJ2yjzPH32R97
	 102Te8QiEqXTg==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Williamson <alex@shazbot.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	kvm@vger.kernel.org,
	iommu@lists.linux.dev
Subject: [PATCH 0/4] dma-buf: add revoke mechanism to invalidate shared buffers
Date: Sun, 11 Jan 2026 12:37:07 +0200
Message-ID: <20260111-dmabuf-revoke-v1-0-fb4bcc8c259b@nvidia.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20251221-dmabuf-revoke-b90ef16e4236
X-Mailer: b4 0.15-dev-a6db3
Content-Transfer-Encoding: 8bit

This series implements a dma-buf “revoke” mechanism: to allow a dma-buf
exporter to explicitly invalidate (“kill”) a shared buffer after it has
been distributed to importers, so that further CPU and device access is
prevented and importers reliably observe failure.

Today, dma-buf effectively provides “if you have the fd, you can keep using
the memory indefinitely.” That assumption breaks down when an exporter must
reclaim, reset, evict, or otherwise retire backing memory after it has been
shared. Concrete cases include GPU reset and recovery where old allocations
become unsafe to access, memory eviction/overcommit where backing storage
must be withdrawn, and security or isolation situations where continued access
must be prevented. While drivers can sometimes approximate this with
exporter-specific fencing and policy, there is no core dma-buf state transition
that communicates “this buffer is no longer valid; fail access” across all
access paths.

The change in this series is to introduce a core “revoked” state on the dma-buf
object and a corresponding exporter-triggered revoke operation. Once a dma-buf
is revoked, new access paths are blocked so that attempts to DMA-map, vmap, or
mmap the buffer fail in a consistent way.

In addition, the series aims to invalidate existing access as much as the kernel
allows: device mappings are torn down where possible so devices and IOMMUs cannot
continue DMA.

The semantics are intentionally simple: revoke is a one-way, permanent transition
for the lifetime of that dma-buf instance.

From a compatibility perspective, users that never invoke revoke are unaffected,
and exporters that adopt it gain a core-supported enforcement mechanism rather
than relying on ad hoc driver behavior. The intent is to keep the interface
minimal and avoid imposing policy; the series provides the mechanism to terminate
access, with policy remaining in the exporter and higher-level components.

BTW, see this megathread [1] for additional context.  
Ironically, it was posted exactly one year ago.

[1] https://lore.kernel.org/all/20250107142719.179636-2-yilun.xu@linux.intel.com/

Thanks

Cc: linux-rdma@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org
Cc: kvm@vger.kernel.org
Cc: iommu@lists.linux.dev
To: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>
To: Sumit Semwal <sumit.semwal@linaro.org>
To: Christian König <christian.koenig@amd.com>
To: Alex Williamson <alex@shazbot.org>
To: Kevin Tian <kevin.tian@intel.com>
To: Joerg Roedel <joro@8bytes.org>
To: Will Deacon <will@kernel.org>
To: Robin Murphy <robin.murphy@arm.com>

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
Leon Romanovsky (4):
      dma-buf: Introduce revoke semantics
      vfio: Use dma-buf revoke semantics
      iommufd: Require DMABUF revoke semantics
      iommufd/selftest: Reuse dma-buf revoke semantics

 drivers/dma-buf/dma-buf.c          | 36 ++++++++++++++++++++++++++++++++----
 drivers/iommu/iommufd/pages.c      |  2 +-
 drivers/iommu/iommufd/selftest.c   | 12 ++++--------
 drivers/vfio/pci/vfio_pci_dmabuf.c | 27 ++++++---------------------
 include/linux/dma-buf.h            | 31 +++++++++++++++++++++++++++++++
 5 files changed, 74 insertions(+), 34 deletions(-)
---
base-commit: 9ace4753a5202b02191d54e9fdf7f9e3d02b85eb
change-id: 20251221-dmabuf-revoke-b90ef16e4236

Best regards,
--  
Leon Romanovsky <leonro@nvidia.com>


