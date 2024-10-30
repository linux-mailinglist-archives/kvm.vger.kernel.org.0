Return-Path: <kvm+bounces-30047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DAAAA9B6774
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 16:20:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5BB90B21792
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 15:20:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 149E8218941;
	Wed, 30 Oct 2024 15:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YiKlu4D9"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F902185B8;
	Wed, 30 Oct 2024 15:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730301248; cv=none; b=iYV31P2gMCnbJwyPpnNYCzjxbWUfjgcJzbdJ7am1x3Lumr812FCcqh65Wwcd91TeDm7J148vqflLqziE1hL8ZhYWg+VzUuaNR/dHMKd2U5vWqRndYQh7RX4lCUrGAwETkS1tIFIQ/v+RJ6J7qzhfp47g8W6HEInJjaMVCuaOK6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730301248; c=relaxed/simple;
	bh=v8Tw1BMcIKkWkecbyVD2bjlFo11chEXusLhfEENOi8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YOlOZPZja2UtFDkbXvkCrpPCdhTj9pzOcSq4xTtj8lRJaWl1Kt97QHQKCuV17N5kKgARQGkD7TeWGXXyoDBJEqjNSl7bl0h7VxMF0ZcahcKsvrLfNuzIK+CLd+cv3yTPMwjgPi4NzSr2YLPrTEcNJYZ8WuiAQpcysNzkfRSOCRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YiKlu4D9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A444C4CECF;
	Wed, 30 Oct 2024 15:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730301248;
	bh=v8Tw1BMcIKkWkecbyVD2bjlFo11chEXusLhfEENOi8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YiKlu4D9JMFXIyH5CmKlxglMedckpIJ1J4QcbKrlh88l8Zu1/lpOaJ+4iUCQ32VdQ
	 1/w/S5Ll4gaGts1LS/6zNykS3hYIj37SlotuNs/IhO5EgX3KFxe41mBrokI8wyI7ef
	 Gp2Gs1Tzb7aT+be/27/nlttyo0HlPv0As+XQTeqwvrhqhAVeILkoq/Cwoi8TsWZpvI
	 aBmJLDqQ92v/ZE4BX9FujIHUuLZQOX3O5CnOraEuYgV/e6eeIWHRzr4MvlA36P0xgm
	 K2m6ssfopeA4RM+gktE/POocZtuUrG4q4SRR0Dqn+ON1d1X1m2VtsMaoVQg3qJTO5i
	 ESfBwP4gKV70w==
From: Leon Romanovsky <leon@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
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
	Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-pci@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v1 09/17] docs: core-api: document the IOVA-based API
Date: Wed, 30 Oct 2024 17:12:55 +0200
Message-ID: <881ef0bcf9aa971e995fbdd00776c5140a7b5b3d.1730298502.git.leon@kernel.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <cover.1730298502.git.leon@kernel.org>
References: <cover.1730298502.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

Add an explanation of the newly added IOVA-based mapping API.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 Documentation/core-api/dma-api.rst | 70 ++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/Documentation/core-api/dma-api.rst b/Documentation/core-api/dma-api.rst
index 8e3cce3d0a23..6095696a65a7 100644
--- a/Documentation/core-api/dma-api.rst
+++ b/Documentation/core-api/dma-api.rst
@@ -530,6 +530,76 @@ routines, e.g.:::
 		....
 	}
 
+Part Ie - IOVA-based DMA mappings
+---------------------------------
+
+These APIs allow a very efficient mapping when using an IOMMU.  They are an
+optional path that requires extra code and are only recommended for drivers
+where DMA mapping performance, or the space usage for storing the DMA addresses
+matter.  All the consideration from the previous section apply here as well.
+
+::
+
+    bool dma_iova_try_alloc(struct device *dev, struct dma_iova_state *state,
+		phys_addr_t phys, size_t size);
+
+Is used to try to allocate IOVA space for mapping operation.  If it returns
+false this API can't be used for the given device and the normal streaming
+DMA mapping API should be used.  The ``struct dma_iova_state`` is allocated
+by the driver and must be kept around until unmap time.
+
+::
+
+    static inline bool dma_use_iova(struct dma_iova_state *state)
+
+Can be used by the driver to check if the IOVA-based API is used after a
+call to dma_iova_try_alloc.  This can be useful in the unmap path.
+
+::
+
+    int dma_iova_link(struct device *dev, struct dma_iova_state *state,
+		phys_addr_t phys, size_t offset, size_t size,
+		enum dma_data_direction dir, unsigned long attrs);
+
+Is used to link ranges to the IOVA previously allocated.  The start of all
+but the first call to dma_iova_link for a given state must be aligned
+to the DMA merge boundary returned by ``dma_get_merge_boundary())``, and
+the size of all but the last range must be aligned to the DMA merge boundary
+as well.
+
+::
+
+    int dma_iova_sync(struct device *dev, struct dma_iova_state *state,
+		size_t offset, size_t size);
+
+Must be called to sync the IOMMU page tables for IOVA-range mapped by one or
+more calls to ``dma_iova_link()``.
+
+For drivers that use a one-shot mapping, all ranges can be unmapped and the
+IOVA freed by calling:
+
+::
+
+   void dma_iova_destroy(struct device *dev, struct dma_iova_state *state,
+		enum dma_data_direction dir, unsigned long attrs);
+
+Alternatively drivers can dynamically manage the IOVA space by unmapping
+and mapping individual regions.  In that case
+
+::
+
+    void dma_iova_unlink(struct device *dev, struct dma_iova_state *state,
+		size_t offset, size_t size, enum dma_data_direction dir,
+		unsigned long attrs);
+
+is used to unmap a range previous mapped, and
+
+::
+
+   void dma_iova_free(struct device *dev, struct dma_iova_state *state);
+
+is used to free the IOVA space.  All regions must have been unmapped using
+``dma_iova_unlink()`` before calling ``dma_iova_free()``.
 
 Part II - Non-coherent DMA allocations
 --------------------------------------
-- 
2.46.2


