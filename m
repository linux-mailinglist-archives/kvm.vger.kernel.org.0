Return-Path: <kvm+bounces-44534-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E01D4A9EBCF
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 11:24:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 57202189D9C6
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 09:24:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACD7725F7AE;
	Mon, 28 Apr 2025 09:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AOOf6Y0m"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA15B25F7AC;
	Mon, 28 Apr 2025 09:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745832178; cv=none; b=Gk3QjsoEyBYTn+sp1MslZ+QLK5Mcfd2tSPhVXguJag4PbOtjk9oRyURpF9Gu6sW4MZbbhr+brgmgfHjPJTI1TfEmojqOeugOl/Dns19ptVYPIpsz+heHLFEilGndZlRfNdNF0qkx/DPZsX9Hm3N3ukIc7RnZ6WU0zWMganvLtJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745832178; c=relaxed/simple;
	bh=qAutkCz37Tu8LslKD8JBH5oib5UnssVkdsFDkEx7ZAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tE27ItbwDYuRCXigwSUpb1io8uWgkx8fILo6Gc+ZQSUriYL5q2FPsSXvprMmAiTKmk3Fjg4g93+KrSzcoGcnScCJXzz0QYaZ6k54VOHw7H6UrRH3TXKDmU9VB/avu10BcPLnMgsY7fXBoS9CzjDjwC7URjqsZVZpHbD4ndSN3bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AOOf6Y0m; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D89BCC4CEE9;
	Mon, 28 Apr 2025 09:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745832178;
	bh=qAutkCz37Tu8LslKD8JBH5oib5UnssVkdsFDkEx7ZAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AOOf6Y0mFh8eaLlqUYaStweSkz4DuWDmM5g52GCOkAPYc1JLbqg3lvf3YSZedB5hq
	 I7YPao5jZ7PVdb5yLDFgUlyfFUAdsvYrD2O+N1GQL1ugH3GyJMizhP+2zRdTDutTtm
	 6Arc5CR8SWcEOS618cLmUutubaOWsAUZ5S4w8pnYyGc8EOww19gd9qY57pmnTY3446
	 rDQDtBCTbwMHdkeWYFbIL0Q2+lz4lvUQC5JkKCvPRuSzjFCPq/I4yB/O49lx3fBh5+
	 nC3MNGBucQEWuM+Rb3Ho6G75E6IdHFTfEgvjbUMPUx4zAeeNoTPV8AE+YhZUqvYG++
	 2+GCFe1W9EuRw==
From: Leon Romanovsky <leon@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>
Cc: Leon Romanovsky <leonro@nvidia.com>,
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
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v10 04/24] iommu: add kernel-doc for iommu_unmap_fast
Date: Mon, 28 Apr 2025 12:22:10 +0300
Message-ID: <6c4bbb539bec7b827b9e9cc24779c9e9c43fc3ed.1745831017.git.leon@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1745831017.git.leon@kernel.org>
References: <cover.1745831017.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

Add kernel-doc section for iommu_unmap_fast to document existing
limitation of underlying functions which can't split individual ranges.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Will Deacon <will@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/iommu/iommu.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 02960585b8d4..8619c355ef9c 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2621,6 +2621,25 @@ size_t iommu_unmap(struct iommu_domain *domain,
 }
 EXPORT_SYMBOL_GPL(iommu_unmap);
 
+/**
+ * iommu_unmap_fast() - Remove mappings from a range of IOVA without IOTLB sync
+ * @domain: Domain to manipulate
+ * @iova: IO virtual address to start
+ * @size: Length of the range starting from @iova
+ * @iotlb_gather: range information for a pending IOTLB flush
+ *
+ * iommu_unmap_fast() will remove a translation created by iommu_map().
+ * It can't subdivide a mapping created by iommu_map(), so it should be
+ * called with IOVA ranges that match what was passed to iommu_map(). The
+ * range can aggregate contiguous iommu_map() calls so long as no individual
+ * range is split.
+ *
+ * Basically iommu_unmap_fast() is the same as iommu_unmap() but for callers
+ * which manage the IOTLB flushing externally to perform a batched sync.
+ *
+ * Returns: Number of bytes of IOVA unmapped. iova + res will be the point
+ * unmapping stopped.
+ */
 size_t iommu_unmap_fast(struct iommu_domain *domain,
 			unsigned long iova, size_t size,
 			struct iommu_iotlb_gather *iotlb_gather)
-- 
2.49.0


