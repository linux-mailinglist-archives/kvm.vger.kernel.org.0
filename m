Return-Path: <kvm+bounces-43890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B9A09A982D0
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 10:19:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3FDC44427BC
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 08:19:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CF2B27E1B2;
	Wed, 23 Apr 2025 08:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pxwe7iTc"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610AB27CB36;
	Wed, 23 Apr 2025 08:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745396076; cv=none; b=UVw4+Uawx2yiq5O+Px6svS0iCEHPv5iMDSQUny7noiy2DWsdJWfaOmVz3EPJsXo3TmYsGDjypPh05+M0stYOAnYXWF40/TQDa/xwTaNJhchLcTTzoNcMl3Uw73AKtTGQw5/nKS8QfFr98hHp71J9z+md7oHfIuWkmx5t6LBbCPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745396076; c=relaxed/simple;
	bh=d1+z79zg+kihe5QDvuiZPuBTqwMqD9eJrziwPARATZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K2JcvhPi/6woJCsVXdy50zEKYRVn1nk3rH1u87k6fvs6WQJHgPobE+Cav6ApLRlCNJfK4lmrckgR1XNV0qt967wbaPrFUxcp1HeEwYOea5NLNHDNH7whL3PjoDQV9eYKwK81uSfmqVPADSLw0GKlVno5E+R+0/xdBjM72A9jNAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pxwe7iTc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F16CC4CEE2;
	Wed, 23 Apr 2025 08:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745396076;
	bh=d1+z79zg+kihe5QDvuiZPuBTqwMqD9eJrziwPARATZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pxwe7iTcgrDrrJrmcOzX972ifQ9D6JVEhDyjPcwwbwuVl5WBAXYDa/8l4DwaLlO1Y
	 vWsvyN8+xhjntksq9HHQv/U5yDIQ7bXtbs603iaK9U11b3NwRT8KTo7Y16zEYpBwAb
	 tekXO0ynYv4MEb0+spPpvw7nl4VYxfxNCatQQ4wLsfvGxwO1M7Nx+Fq7d37PGV8eWi
	 FEqyUa6I1tPF5wbesUJJBhjietyGAKhO/Ixdu0i9NC9A91a0SuSF5RdIyowf8I/PLc
	 cdrRTsuDCiC9V64kjPfH592VX/vNZGPVXZWQfZlhD2D+uTZMCYmKBCur2EngxrpVBY
	 rnT3jQf4b8oTQ==
From: Leon Romanovsky <leon@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>
Cc: Jake Edge <jake@lwn.net>,
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
Subject: [PATCH v9 09/24] docs: core-api: document the IOVA-based API
Date: Wed, 23 Apr 2025 11:13:00 +0300
Message-ID: <7d5cf410e923a22c519ea60f4f35e3c9f8f845e3.1745394536.git.leon@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1745394536.git.leon@kernel.org>
References: <cover.1745394536.git.leon@kernel.org>
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


