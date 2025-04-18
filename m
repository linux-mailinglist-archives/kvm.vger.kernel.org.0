Return-Path: <kvm+bounces-43613-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A2839A93253
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 08:49:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7F48919E86CF
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 06:49:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C451126B945;
	Fri, 18 Apr 2025 06:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uenu4moj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59BD26A1C2;
	Fri, 18 Apr 2025 06:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744958897; cv=none; b=jt3BvAi1bHHzUvtjqJKMKHTUn0yZ7JUWvpKIP+iI4xRSNQOpa5QlWU7tywzOjF/sk4rre/LKRNH4bFg2MslH1biJKib82btjY4HU52AmosRZoVM1Ak0ClpPEpgU8qUi8yfsLnlw3WNhUIRCyXxpoTDw9CXZldDt7YS082kqmS6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744958897; c=relaxed/simple;
	bh=nlY3wEh3C1IEo+kSRhyetcCIxn/sZk9XJjHYh0zo1y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=romb7d7bVpMBGOUl3XsullsQUe+Wqg/r2G5aAxW+nQSLIV6sj6ZJZUzRV/Whg+eQSvkbWruoNOXQTJJ1VzUU0psmTs7A+dy5h+j5R/84wDLNe/6m+Gy2vL3voZs173fGgJMIy4Z8OhIQOA5+lzaPsNjFlAxvS/BMD7ANr5U3GMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uenu4moj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C09C4CEED;
	Fri, 18 Apr 2025 06:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744958896;
	bh=nlY3wEh3C1IEo+kSRhyetcCIxn/sZk9XJjHYh0zo1y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uenu4mojsxkgpDo5apIoPvdB5TZ7+KyME7dRrsezlKFIzSNrqK0G6xnaj1lMmhtJg
	 wJTNctFgkZizdGl1TqzRmL09k1+xz0tnpmPMjexc9xpeJvfDeuLQ4LYsQzlawKBCxB
	 1FZSP+CYslGLH9ayoD3ssQITRF4htPUkTw5R53V9MCsdAvWQAR+/usSZ7pXgH6Lk5d
	 W6xt4cIXK16YUHoDSnZz+oSOqofM0WxvxEn9hm90qSpgE11qKEQVdipq46JN12PNH3
	 nvjN6kF40fxtXoDpCYfD1q6bh0Tb77gPByXyKgBr6e7PdcO1PZbRnLgjigChGvLqWP
	 QFyBahGLt7GdQ==
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
Subject: [PATCH v8 04/24] iommu: add kernel-doc for iommu_unmap and iommu_unmap_fast
Date: Fri, 18 Apr 2025 09:47:34 +0300
Message-ID: <d3ad1e84d896aea97ebbd01c414fb1f07dc791d3.1744825142.git.leon@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1744825142.git.leon@kernel.org>
References: <cover.1744825142.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

Add kernel-doc section for iommu_unmap and iommu_unmap_fast to document
existing limitation of underlying functions which can't split individual
ranges.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Will Deacon <will@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/iommu/iommu.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 3dc47f62d9ff..66b0bf6418ef 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2618,6 +2618,25 @@ size_t iommu_unmap(struct iommu_domain *domain,
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


