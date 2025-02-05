Return-Path: <kvm+bounces-37345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B7BA8A29125
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 15:45:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A9C33A38F8
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 14:45:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE62718A6A8;
	Wed,  5 Feb 2025 14:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G7y6FNpG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6091189BB1;
	Wed,  5 Feb 2025 14:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766494; cv=none; b=ThBJyEhnd0rlIE4mk/64z37aeg5Hq2HqqgqjXvd3RRRoiZHeicT3HRb8Poc7auhrSOIX3DMoMFLQmjyiqcErfhMbj6JL3lVVDo31tEUmjjJN1rudtZtxADYZRAAPh5XvCcDil7lonTlifaE4NXoQeuWoq55mlZopT4TCHhc8Y10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766494; c=relaxed/simple;
	bh=bwt/yttc57skms9Ne++frz0MugkbreUIXAgb1ccLqXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rj5Nk+Dqvdy7wuMtSTMFO6uGUJDGkPofuTFVCvffEe4pXuu4fa7pfRHynYebzlmbmMiHo0abvQtVgIfy7CVpdH01boJilQze3Pq0cF0DT+ibarjxGKuFkSTCbsTHOQWO8z5lazdsmhVA53/9N1NstpgilFaNHPz+IwNywauXFTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G7y6FNpG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75406C4CEE2;
	Wed,  5 Feb 2025 14:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738766494;
	bh=bwt/yttc57skms9Ne++frz0MugkbreUIXAgb1ccLqXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G7y6FNpGumoGrA+jV3Y8fmODmJJ7PYXSr0PbcK43L3T3pldBjHH5k+mxWah92Ei0r
	 s0NR5oe5OqAX7KCtL0D5BdnkgIx0cZFUARawFKJAZy2n1/mkwDYzYVLLJMOWBVW8nX
	 JNGxLhON8Ukz3k0pT39ARqaLs9kOA2jwslCT4NUOY8ZPo5EYbm0UOJD2BGGoYh+tJS
	 p6v9FAc27I6tmAoMyKhiOH0t8rhKWk0Cfs17Uwd4iJa2RHOZ6XcTk+gTVqVU0ythyC
	 34qrycHhfu1HNKHYq9+r7Z3G9HhUInj6L90FxWP8OkRQKfkpJVrSBY3moIVL7/ctyc
	 6WCrLd3BZ5jIw==
From: Leon Romanovsky <leon@kernel.org>
To: Christoph Hellwig <hch@lst.de>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>
Cc: Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
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
	linux-mm@kvack.org,
	Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH v7 09/17] docs: core-api: document the IOVA-based API
Date: Wed,  5 Feb 2025 16:40:29 +0200
Message-ID: <b8f89a9f97b2b1ff3d04049f608a00c55e8dd65d.1738765879.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1738765879.git.leonro@nvidia.com>
References: <cover.1738765879.git.leonro@nvidia.com>
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
index 8e3cce3d0a23..61d6f4fe3d88 100644
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
+matter.  All the considerations from the previous section apply here as well.
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
+is used to unmap a range previously mapped, and
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
2.48.1


