Return-Path: <kvm+bounces-29786-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E6979B1E9A
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2024 15:30:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 39BBFB217D3
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2024 14:30:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BAC21D9664;
	Sun, 27 Oct 2024 14:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pd0BzzZL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183361D934C;
	Sun, 27 Oct 2024 14:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730038977; cv=none; b=RQZnPnI9o0/cWLes2GZRH2qVPqptnAdzeh4KbTy9+eu08Rzv7Zn0NAFCxx8o05IB9y8MAzgu+JtrJApoAm1XJcB/NFVeE+amqe95kX8AYWVwCyseRoZ8aWLdRA1RWXgtLhh4MtTXYhRFRW36tgzWRFZJmvYBaPEMON8LJM8i9wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730038977; c=relaxed/simple;
	bh=BINE0bzsOqI+RjXMn339mOpninDICNxaXannsg5oEKA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VNcP98z33W0M2UOVBE5QA1HYivxo1gDI0oeLoIQZ4Pr892adB0iLYzzbZksOTxIy36HFNvtEzC2HO1Cw6eToAr16sInR7//QZaUFlBK3FajrHMCspMndX3w3Sxr0yG0LK4o9xSKPtAh8JmEleLWRZdEfeAU8y9km2+SuvDWj3Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pd0BzzZL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319FEC4CEC3;
	Sun, 27 Oct 2024 14:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730038977;
	bh=BINE0bzsOqI+RjXMn339mOpninDICNxaXannsg5oEKA=;
	h=From:To:Cc:Subject:Date:From;
	b=pd0BzzZLKEzBqB8FWM9UZHam4tYNjsnnks0WcWuSmuuGlWxovKjdQAiI80MVb2wGZ
	 MTG3Xte9Jh0NPOVe8g5i1zq0pO5fVaNHNx2Y5e677UAgwYHjtDxNvA9Zat2wJBBXiz
	 R9aUDLrTH2666bqNkqWn8CjaFttj2+pvGYC79+kM2RvXqapBiYUhaEBxX04LxMqBA5
	 nEFd2n+xRDKhnirU2/wPoC5KGRP0XTSFPNger8/n0w6gzVIWEHU+Kx5hRf7z0+eAnI
	 hxdNIMaJRWkRkHkRXtlZgB+O6cM86XADyzKCTloRhKNu3+iYzVgS1Hqy8Wx0zQnauc
	 6bI4K5B/nVNRA==
From: Leon Romanovsky <leon@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>,
	Jens Axboe <axboe@kernel.dk>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>
Cc: Keith Busch <kbusch@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-pci@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 0/7] Block and NMMe PCI use of new DMA mapping API
Date: Sun, 27 Oct 2024 16:21:53 +0200
Message-ID: <cover.1730037261.git.leon@kernel.org>
X-Mailer: git-send-email 2.46.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is complimentary patchset to the series which adds new DMA mapping API [1].

In this series, Christoph converts existing nvme-pci driver to use new API, which
is wrapped by relevant blk-mq helpers, so future blk drivers can reuse them in
block layer specific structures.

This is posted as RFC as it is under heavy testing now, and presented
here to get feedback from the community and show another advanced use
case of the new API.

Thanks

[1] https://lore.kernel.org/all/cover.1730037276.git.leon@kernel.org

Christoph Hellwig (7):
  block: share more code for bio addition helpers
  block: don't merge different kinds of P2P transfers in a single bio
  blk-mq: add a dma mapping iterator
  blk-mq: add scatterlist-less DMA mapping helpers
  nvme-pci: remove struct nvme_descriptor
  nvme-pci: use a better encoding for small prp pool allocations
  nvme-pci: convert to blk_rq_dma_map

 block/bio.c                | 148 ++++++------
 block/blk-map.c            |  32 ++-
 block/blk-merge.c          | 313 +++++++++++++++++-------
 drivers/nvme/host/pci.c    | 470 +++++++++++++++++++------------------
 include/linux/blk-mq-dma.h |  64 +++++
 include/linux/blk_types.h  |   2 +
 6 files changed, 636 insertions(+), 393 deletions(-)
 create mode 100644 include/linux/blk-mq-dma.h

-- 
2.46.2


