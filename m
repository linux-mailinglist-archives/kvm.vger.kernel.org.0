Return-Path: <kvm+bounces-45406-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89D3FAA8CCD
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 09:06:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 03FBC16A955
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 07:06:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2931D1DE8B9;
	Mon,  5 May 2025 07:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="udIyTs1j"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D7B1F4C8A;
	Mon,  5 May 2025 07:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746428558; cv=none; b=K9PqOFwzWxOalEnbu6uJK0xhYtjEw6nzYSgSQQwsg7Tgn83ksalhp0NqGFjT/OeVdIrAC27TRBf8KVlPag0qF4PHZVQEG1E7Wnbi76JrwoRaB4I6txG97C3LqVQKOtv81KUB7VBMF4/+9fcERTXMMdySMK6I7cSQPigqk+iPyCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746428558; c=relaxed/simple;
	bh=d1+z79zg+kihe5QDvuiZPuBTqwMqD9eJrziwPARATZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HfvIs/uUAdqD/dz/m/Emmc/NnoUCypT3XeHf6PV3eyA2CULIqoA+PIWlooQO+jM0ZcqPZmlIGAM7qSIDdJ8VkOFvmPOt6hBnBNv6bqPLfHaONCB7BlDw7gDB5U7j1uWWhLzNRHhThUA2PJuJbcci/jgCuDaIQ+5+vVfVZiY2b7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=udIyTs1j; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA5DBC4CEE4;
	Mon,  5 May 2025 07:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746428557;
	bh=d1+z79zg+kihe5QDvuiZPuBTqwMqD9eJrziwPARATZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=udIyTs1jU0xkkPO2JwNPXSUyJHDJzOGOAJqZEBd18QourGwZw+baXEZ9gTe8BJ0EJ
	 DKGtIef9GidDihg430dzb3TV4U9nSk0oH0fWDOqZMUUied876JK1wN1He2oUOPQ9+s
	 4talNO552304u79Njy1LPb0QYEBAPSm4JRnjt0U38ZXHn3uQXTkQ6SLZmvo5VPfcSN
	 4oQb+HpClX6Qepsm/ir1G8Cf48WpHUEF6GV/yNoKGVauQurcR8AKjzjpLESRp4OM8E
	 eFEoy59bj9uf5LIDs5y+12okk38f0cZDP+qoR+lYvzBX1noadVlU3+zY/zH2A2FB5S
	 5rtZiYk4O/uXQ==
From: Leon Romanovsky <leon@kernel.org>
To: 
Cc: Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Jake Edge <jake@lwn.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Zhu Yanjun <zyjzyj2000@gmail.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
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
	linux-mm@kvack.org,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH v11 9/9] docs: core-api: document the IOVA-based API
Date: Mon,  5 May 2025 10:01:46 +0300
Message-ID: <a3a7009a0b75b4087e9edc903f6dc3ed3ff5a0a1.1746424934.git.leon@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1746424934.git.leon@kernel.org>
References: <cover.1746424934.git.leon@kernel.org>
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
Tested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 Documentation/core-api/dma-api.rst | 71 ++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/Documentation/core-api/dma-api.rst b/Documentation/core-api/dma-api.rst
index 8e3cce3d0a23..2ad08517e626 100644
--- a/Documentation/core-api/dma-api.rst
+++ b/Documentation/core-api/dma-api.rst
@@ -530,6 +530,77 @@ routines, e.g.:::
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
+		size_t mapped_len, enum dma_data_direction dir,
+                unsigned long attrs);
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
2.49.0


