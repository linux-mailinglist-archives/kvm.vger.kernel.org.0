Return-Path: <kvm+bounces-53914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 888EEB1A2B2
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 15:05:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC62A3A7442
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 13:04:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F754272E63;
	Mon,  4 Aug 2025 13:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U6NzdtAJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE5827145F;
	Mon,  4 Aug 2025 13:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754312488; cv=none; b=jYKE+fL0xQ742m3diHvLuAuTd0nyadYe0hB3xMcK1Lyuc+y9YHj2vsdXHcNi6vfmAq/DhYGXbh3lpVDKszXxbcrhRLYhtiXL9U2d3JdGO4Fq7mwJRor7/lCK7JPj4hFIF5sQpSh8OFjnEMk89tbw/goq3IaX3AVpwr4dfE4m4bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754312488; c=relaxed/simple;
	bh=WJztkfF0BW2A+ySSaoquKg9YWNFPhQS7np0spIG94dM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfPUYq4Dfv8ft90ZzB1yPzgq6CE7SXgBiO1YVaVXCh7NN9C0v1ONMrF2udIZMorJMalVC+MlBa3jzk8eDbJzLO9qiwzefXPHNsIXrDE9tBPH5i89fe/EnQXgbFZKr/DFjtpHAMFLqz6JMfDH0wj37FQeBIw26WKed2iwj4WEag4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U6NzdtAJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7276EC4CEE7;
	Mon,  4 Aug 2025 13:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754312487;
	bh=WJztkfF0BW2A+ySSaoquKg9YWNFPhQS7np0spIG94dM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U6NzdtAJjvKqDoK99gNW74qBu86eRI6rmFzBpM7IVvzJUQY7rqGAQN18dEvkubRN+
	 Y+m2Fo7Oc72hbCrN1FXqElv4W8T7JunoHZHZdBliXv/iTcRC1rPep8PUQrlubuEuZr
	 cFwuGmfnVgmrhV2o9d1afCl0k/XMtlNsC9nLQmxEP2s24dFZ8n2RnfdUPpO2rn7dOB
	 MoocxgPp8LpCToe04kCbNp1Hzh4v8k8j5zfoFKNLnSjxSqf3tAvHQoqcLLzkSvxwBO
	 AgExQp/Jj/LmCw9WJJmASCHqMVlKFvPl6JCk9IDacM3Sbg4LjdbUwhrCzOddAfA3am
	 cOY6O/a9VKDKg==
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Christoph Hellwig <hch@lst.de>,
	dri-devel@lists.freedesktop.org,
	iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>,
	kvm@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v1 06/10] types: move phys_vec definition to common header
Date: Mon,  4 Aug 2025 16:00:41 +0300
Message-ID: <b78237112cbc8cd4c52cc5f606f325da768ae8fa.1754311439.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1754311439.git.leon@kernel.org>
References: <cover.1754311439.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

Move the struct phys_vec definition from block/blk-mq-dma.c to
include/linux/types.h to make it available for use across the kernel.

The phys_vec structure represents a physical address range with a
length, which is used by the new physical address-based DMA mapping
API. This structure is already used by the block layer and will be
needed by upcoming VFIO patches for dma-buf operations.

Moving this definition to types.h provides a centralized location
for this common data structure and eliminates code duplication
across subsystems that need to work with physical address ranges.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 block/blk-mq-dma.c    | 5 -----
 include/linux/types.h | 5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/block/blk-mq-dma.c b/block/blk-mq-dma.c
index 430e51ec494a6..8d2646ab27953 100644
--- a/block/blk-mq-dma.c
+++ b/block/blk-mq-dma.c
@@ -5,11 +5,6 @@
 #include <linux/blk-mq-dma.h>
 #include "blk.h"
 
-struct phys_vec {
-	phys_addr_t	paddr;
-	u32		len;
-};
-
 static bool blk_map_iter_next(struct request *req, struct req_iterator *iter,
 			      struct phys_vec *vec)
 {
diff --git a/include/linux/types.h b/include/linux/types.h
index 6dfdb8e8e4c35..2bc56681b2e62 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -170,6 +170,11 @@ typedef u64 phys_addr_t;
 typedef u32 phys_addr_t;
 #endif
 
+struct phys_vec {
+	phys_addr_t	paddr;
+	u32		len;
+};
+
 typedef phys_addr_t resource_size_t;
 
 /*
-- 
2.50.1


