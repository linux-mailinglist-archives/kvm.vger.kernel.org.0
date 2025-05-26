Return-Path: <kvm+bounces-47714-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A8BD3AC3F1A
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 14:11:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4A003189772A
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 12:11:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77B8C1FF1B3;
	Mon, 26 May 2025 12:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="QzVzaho+"
X-Original-To: kvm@vger.kernel.org
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D561FC7D2;
	Mon, 26 May 2025 12:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748261477; cv=none; b=reCcH+R40eLXtyxq4cqHP/gklugxmRbJvdOjgNYupbUYLUgZ668eFiZMB39eAIXG5rf3+qsc8NXg0xe2cP98QvLDss2iYMNNkfd8qsVbDjT9GoTYjZ2dgWqxzD/0wvHTq79aJT9ev9fKIQK6s/Tm0x9OwkhU1Z2rpUJGYl14o8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748261477; c=relaxed/simple;
	bh=hrWZ8l1cZmzGb0rBjRlN4YTI9FJ+eVKg64HEKHwbNCc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=rMF/XH3x5Wa9aFjS9afXYU1e/oZfE1fB9gUbxZGFmE1iDpyfdAyyQFpdAyPpx2XyJeJ8oFAEOrvruA9W/25J3HxD1ny7jozp7R5vA2xx2VOiy3+plPa39phaUCn2bQwkBYwuDfbdE5xFgciBRijyGtdFiAW870KJt4XdF2nBoeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=QzVzaho+; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20250526121112euoutp020939f6f970e100a8dc72a890f537db4f~DEovd-X3V0823508235euoutp02J;
	Mon, 26 May 2025 12:11:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20250526121112euoutp020939f6f970e100a8dc72a890f537db4f~DEovd-X3V0823508235euoutp02J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1748261472;
	bh=oEQfyNRCcF96rAB00+i4LTDnH6eyExMGUimV2Hx1YDM=;
	h=From:To:Cc:Subject:Date:References:From;
	b=QzVzaho+gT//bWlkOTURTWXtnc4hEIbMGV8JGp+3YxyiCKTP2iSsBUjdf1+HZQ4kU
	 KfdrZt6CeW5/LJ23tYHTuLXJ3kJbiO3M7rL7lK/fpNvKAIkHIo4/mt7rD+GA9hvsRQ
	 YvWT05wESqHMdmy9XXFENm1m1Kn4J6FrqN3/kJzQ=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20250526121111eucas1p277b74b79fe4ae4323fc687a06039044d~DEovH6I0i1358313583eucas1p2X;
	Mon, 26 May 2025 12:11:11 +0000 (GMT)
Received: from AMDC4653.digital.local (unknown [106.120.51.32]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250526121110eusmtip1782073e50a70b6e2a3e0c1a2ca4e7eda~DEotgHSUL0843308433eusmtip13;
	Mon, 26 May 2025 12:11:10 +0000 (GMT)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux.dev, Marek Szyprowski
	<m.szyprowski@samsung.com>, Leon Romanovsky <leon@kernel.org>, Jens Axboe
	<axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Keith Busch
	<kbusch@kernel.org>, Jake Edge <jake@lwn.net>, Jonathan Corbet
	<corbet@lwn.net>, Jason Gunthorpe <jgg@ziepe.ca>, Zhu Yanjun
	<zyjzyj2000@gmail.com>, Robin Murphy <robin.murphy@arm.com>, Joerg Roedel
	<joro@8bytes.org>, Will Deacon <will@kernel.org>, Sagi Grimberg
	<sagi@grimberg.me>, Bjorn Helgaas <bhelgaas@google.com>, Logan Gunthorpe
	<logang@deltatee.com>, Yishai Hadas <yishaih@nvidia.com>, Shameer Kolothum
	<shameerali.kolothum.thodi@huawei.com>, Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, linux-doc@vger.kernel.org,
	linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, linux-mm@kvack.org, Niklas Schnelle
	<schnelle@linux.ibm.com>, Chuck Lever <chuck.lever@oracle.com>, Luis
	Chamberlain <mcgrof@kernel.org>, Matthew Wilcox <willy@infradead.org>, Dan
	Williams <dan.j.williams@intel.com>, Kanchan Joshi <joshi.k@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>
Subject: [GIT PULL] dma-mapping update for Linux 6.16
Date: Mon, 26 May 2025 14:11:05 +0200
Message-Id: <20250526121105.434835-1-m.szyprowski@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250526121111eucas1p277b74b79fe4ae4323fc687a06039044d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20250526121111eucas1p277b74b79fe4ae4323fc687a06039044d
X-EPHeader: CA
X-CMS-RootMailID: 20250526121111eucas1p277b74b79fe4ae4323fc687a06039044d
References: <CGME20250526121111eucas1p277b74b79fe4ae4323fc687a06039044d@eucas1p2.samsung.com>

The following changes since commit 0af2f6be1b4281385b618cb86ad946eded089ac8:

  Linux 6.15-rc1 (2025-04-06 13:11:33 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mszyprowski/linux.git tags/dma-mapping-6.16-2025-05-26

for you to fetch changes up to 3ee7d9496342246f4353716f6bbf64c945ff6e2d:

  docs: core-api: document the IOVA-based API (2025-05-06 08:36:54 +0200)

----------------------------------------------------------------
dma-mapping updates for Linux 6.16:

- new two step DMA mapping API, which is is a first step to a long path
  to provide alternatives to scatterlist and to remove hacks, abuses and
  design mistakes related to scatterlists; this new approach optimizes
  some calls to DMA-IOMMU layer and cache maintenance by batching them,
  reduces memory usage as it is no need to store mapped DMA addresses to
  unmap them, and reduces some function call overhead; it is a combination
  effort of many people, lead and developed by Christoph Hellwig and Leon
  Romanovsky

----------------------------------------------------------------
Christoph Hellwig (6):
      PCI/P2PDMA: Refactor the p2pdma mapping helpers
      dma-mapping: move the PCI P2PDMA mapping helpers to pci-p2pdma.h
      iommu: generalize the batched sync after map interface
      iommu/dma: Factor out a iommu_dma_map_swiotlb helper
      dma-mapping: add a dma_need_unmap helper
      docs: core-api: document the IOVA-based API

Leon Romanovsky (3):
      iommu: add kernel-doc for iommu_unmap_fast
      dma-mapping: Provide an interface to allow allocate IOVA
      dma-mapping: Implement link/unlink ranges API

 Documentation/core-api/dma-api.rst |  71 ++++++
 drivers/iommu/dma-iommu.c          | 482 ++++++++++++++++++++++++++++++++-----
 drivers/iommu/iommu.c              |  84 ++++---
 drivers/pci/p2pdma.c               |  38 +--
 include/linux/dma-map-ops.h        |  54 -----
 include/linux/dma-mapping.h        |  85 +++++++
 include/linux/iommu.h              |   4 +
 include/linux/pci-p2pdma.h         |  85 +++++++
 kernel/dma/direct.c                |  44 ++--
 kernel/dma/mapping.c               |  18 ++
 10 files changed, 764 insertions(+), 201 deletions(-)
----------------------------------------------------------------

Thanks!

Best regards
Marek Szyprowski, PhD
Samsung R&D Institute Poland

