Return-Path: <kvm+bounces-43885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EDCDA982A0
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 10:16:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A99D3AB890
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 08:15:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9F8D26F464;
	Wed, 23 Apr 2025 08:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hP6N1Vhy"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060B5268FC9;
	Wed, 23 Apr 2025 08:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745396058; cv=none; b=LkbPIGoDdDYkwY45Hv/sB/9o1jz1H6SFFg7UgKm6S+yDQOEVVtxCofKVUtFAlt3N1BLbkK2z0iLlT4mn0WXlfmtUi7ryl30FH1dv8TLGINvQIjQUPPL9GZ/SmYgSgLIQjJ/hLdOacLcAX1VO3Lma6uHNDZTyTxAsrodvxcqwMw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745396058; c=relaxed/simple;
	bh=sRUAUa2FfsysV34AMHv+Y5ryWrHjFOp/80CXFLLJ59o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EKB7E4k+5a33sANksJV9fA45M28eJQKmNKe5BROdPL5V07Js02M4gyjv+il+nfB7G/zef5nJmj7w7tnIOHq1Sw7vtDy5hPQZnDmq1k6Ojqr6RqBHgPfh+1YwE43t224EZN7rFyAzLBvn6zcoOwR/j/2yjZxjK0FjePy4/kbAUBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hP6N1Vhy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 455BAC4CEEC;
	Wed, 23 Apr 2025 08:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745396054;
	bh=sRUAUa2FfsysV34AMHv+Y5ryWrHjFOp/80CXFLLJ59o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hP6N1Vhyd1ah35bzidBTakhVw6zm6GUH0WtuMqFq6WQiqV5ZhLmBpfTdWlSZTuacn
	 nYqeakbMEQ8lHXQeYvjADrxrKC3Cj0GzKzZ2TD/3nYQnu4F5Y+DGZu0WcFluCmQTgh
	 lz3785fzm2fh9sOq2k1STupzDBiuIJY/f/S7+WECacUUQh7pcYqhaQ4FS04qvPfNQi
	 Lu7lLrFLb6Wo5yHNfnYr4Z3e6iAYtra0r7x2Nnk5ECOE7j+bnuAkOyRdHALT7zjx6v
	 fqFRx+tMaPS4b4vl06ryR2JfTAgyIELxslbrwTOldYQDgs3EE8a/as6VvK7W2qVCFc
	 eJ0uVlnoN4wCw==
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
Subject: [PATCH v9 04/24] iommu: add kernel-doc for iommu_unmap_fast
Date: Wed, 23 Apr 2025 11:12:55 +0300
Message-ID: <9becc0989ed0a6770e4e320580d1152b716acd0d.1745394536.git.leon@kernel.org>
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

From: Leon Romanovsky <leonro@nvidia.com>

Add kernel-doc section for iommu_unmap_fast to document existing
limitation of underlying functions which can't split individual ranges.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Will Deacon <will@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Jens Axboe <axboe@kernel.dk>
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


