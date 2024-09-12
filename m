Return-Path: <kvm+bounces-26692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8104F97677B
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 13:20:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 370EC1F21FFF
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 11:20:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0A331A264E;
	Thu, 12 Sep 2024 11:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MaNgzGuY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F9F1A2631;
	Thu, 12 Sep 2024 11:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726139802; cv=none; b=okIAiniDGX56RdHfmAdwk+nYzcS1+76y8MF8eudPHaw7SkKlPg8sNw0DSWPSsbyN/RodadXqBksqaXBqtxDDdYHtXaw3B7IXAna9R9ETHoTCfyYhTbMe7+2eoPMW7DrgWm/y4HBXguR3mrOXIEN/nqmef6kTv93Xp/upn/tyUTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726139802; c=relaxed/simple;
	bh=cWTZ/vX5KH29DDePm3J0/PIuPOYHHrOmAmy/4Xsjr4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SDMbo4ysxaMpwhYinqfduP+y08og3OZb1QYGli6kY9/vpYy23nQbj9ADmIr9mcYmxoSiglBrKDJulHMvDq2xLzS0MfsqECbofDnkE6QAyLTCkU0KwJBYaZGUwqvqq+uf8NOzuzfaKt3QnO91VNnCwO7//T7MGyuwPb0Kgm9weIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MaNgzGuY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A155AC4CEC3;
	Thu, 12 Sep 2024 11:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726139801;
	bh=cWTZ/vX5KH29DDePm3J0/PIuPOYHHrOmAmy/4Xsjr4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MaNgzGuYutMZ4S+zhyYnCR1nQ7/cVUpL4cqJdHGuAEl1wmik2EzqsRYrKwjzPSgGy
	 sfidRPgO4zHN72I0olnabe+xMFut7ZSLfoMfElMezA5aKgxLkIlLNFrWStvp5nrBQe
	 WIU+RNQrJtth1GJ+9XevvCvmshuuvPMj21JSNCgv1OQQ6sBN2NPFmAViYUr2n9nfgn
	 dbjpF0kXfzUGO92UMShptYWEvda0Nuu3fgD16HzX7heBADacYrIS4+3hYZbE1tbiNB
	 QNt5RqCvZK/+hGQmCeSmU9XwJusDixnsAIA3mt2lH8BGiBECYIR+WZoJ5CVwVtemKh
	 8zM6C899KSD3A==
From: Leon Romanovsky <leon@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"Zeng, Oak" <oak.zeng@intel.com>,
	Chaitanya Kulkarni <kch@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-pci@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC v2 10/21] RDMA/umem: Preallocate and cache IOVA for UMEM ODP
Date: Thu, 12 Sep 2024 14:15:45 +0300
Message-ID: <f3f32e72d5ae48305ae270a27fce09c70cd07dac.1726138681.git.leon@kernel.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1726138681.git.leon@kernel.org>
References: <cover.1726138681.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

As a preparation to provide two step interface to map pages,
preallocate IOVA when UMEM is initialized.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/core/umem_odp.c | 13 ++++++++++++-
 include/rdma/ib_umem_odp.h         |  1 +
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
index e9fa22d31c23..01cbf7f55b3a 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -50,6 +50,7 @@
 static inline int ib_init_umem_odp(struct ib_umem_odp *umem_odp,
 				   const struct mmu_interval_notifier_ops *ops)
 {
+	struct ib_device *dev = umem_odp->umem.ibdev;
 	int ret;
 
 	umem_odp->umem.is_odp = 1;
@@ -87,15 +88,24 @@ static inline int ib_init_umem_odp(struct ib_umem_odp *umem_odp,
 			goto out_pfn_list;
 		}
 
+		dma_init_iova_state(&umem_odp->state, dev->dma_device,
+				    DMA_BIDIRECTIONAL);
+		ret = dma_alloc_iova(&umem_odp->state, end - start);
+		if (ret)
+			goto out_dma_list;
+
+
 		ret = mmu_interval_notifier_insert(&umem_odp->notifier,
 						   umem_odp->umem.owning_mm,
 						   start, end - start, ops);
 		if (ret)
-			goto out_dma_list;
+			goto out_free_iova;
 	}
 
 	return 0;
 
+out_free_iova:
+	dma_free_iova(&umem_odp->state);
 out_dma_list:
 	kvfree(umem_odp->dma_list);
 out_pfn_list:
@@ -274,6 +284,7 @@ void ib_umem_odp_release(struct ib_umem_odp *umem_odp)
 					    ib_umem_end(umem_odp));
 		mutex_unlock(&umem_odp->umem_mutex);
 		mmu_interval_notifier_remove(&umem_odp->notifier);
+		dma_free_iova(&umem_odp->state);
 		kvfree(umem_odp->dma_list);
 		kvfree(umem_odp->pfn_list);
 	}
diff --git a/include/rdma/ib_umem_odp.h b/include/rdma/ib_umem_odp.h
index 0844c1d05ac6..c0c1215925eb 100644
--- a/include/rdma/ib_umem_odp.h
+++ b/include/rdma/ib_umem_odp.h
@@ -23,6 +23,7 @@ struct ib_umem_odp {
 	 * See ODP_READ_ALLOWED_BIT and ODP_WRITE_ALLOWED_BIT.
 	 */
 	dma_addr_t		*dma_list;
+	struct dma_iova_state state;
 	/*
 	 * The umem_mutex protects the page_list and dma_list fields of an ODP
 	 * umem, allowing only a single thread to map/unmap pages. The mutex
-- 
2.46.0


