Return-Path: <kvm+bounces-10960-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 141A9871D63
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 12:22:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 36B041C218D5
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 11:22:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFBA95CDC9;
	Tue,  5 Mar 2024 11:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="caYziKGN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B4157308;
	Tue,  5 Mar 2024 11:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709637563; cv=none; b=T/LcYuKaCDToooEoiq4b3qqGGwkexnZlp68JYLJEvHdtd86biJRU8FF4/GI9yrQNguatGALSutzdYhqV8a3xp0nNoDJXjGVoHSXVIkLbUbbsnJsC5krhCSR8wF193yHLD5HPAMTGPMA4KGlSyHXbcDoeW+baQkdl6eGzLx/f2PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709637563; c=relaxed/simple;
	bh=E8ahaIx2eHfPJk0G81HhbupoEvLGKO0ealmbIxFQ2TY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gq5u7H2qAj1A3zfeVkXXLRbRwZdL91E0AdU87VAUj2qQH3UAN9a4bTdvziFgyP0KgnbBoGWXqo+aw9+HV3B2HkYdlqBfkPAFcsgicR4SkvzQPUg5ZwINPGKUc7kS21vxIDCm+PqoV783mgxvCyMXvF32fX8joZD3LPafDTEgAYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=caYziKGN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFF43C433F1;
	Tue,  5 Mar 2024 11:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709637562;
	bh=E8ahaIx2eHfPJk0G81HhbupoEvLGKO0ealmbIxFQ2TY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=caYziKGN4nQ6kN+9eq9OdBuTlgubm0Pb0jxPUg1nvKbDYZ7pFGIzeYrAmlE6IxeVv
	 746C+LqlVHPQ4dDcVQlVgnA2EHmFaCDoMqB8C5Q3zAXCesOehVRaHHoJvjmHc8io+k
	 obH2BT5XHaaCbjd0RRi0CnpJ0GsTLZmOM8Vs7UUadTlXpFB9Su+dS65MTkhFtRA1TV
	 uwDMsDHNaOVKiuMmBctORC3dngSDNkvdEz9cizg0F/CI1eZqzIjMskfyTBmd3Z/pDN
	 Z1OLKXLVUURP5juEVvIRb6GwritonO9eAzr+ppm65LjXs9YffyvBUxqeu9hjdFCa+0
	 wMe/HvMTuqPEQ==
From: Leon Romanovsky <leon@kernel.org>
To: Christoph Hellwig <hch@lst.de>,
	Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
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
	kvm@vger.kernel.org,
	linux-mm@kvack.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Amir Goldstein <amir73il@gmail.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"daniel@iogearbox.net" <daniel@iogearbox.net>,
	Dan Williams <dan.j.williams@intel.com>,
	"jack@suse.com" <jack@suse.com>,
	Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: [RFC RESEND 07/16] RDMA/umem: Preallocate and cache IOVA for UMEM ODP
Date: Tue,  5 Mar 2024 13:18:38 +0200
Message-ID: <47cc27fbaf9f4bd19edbcaac380bdd9684c5d12f.1709635535.git.leon@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1709635535.git.leon@kernel.org>
References: <cover.1709635535.git.leon@kernel.org>
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
 drivers/infiniband/core/umem_odp.c | 16 +++++++++++++++-
 include/rdma/ib_umem_odp.h         |  1 +
 include/rdma/ib_verbs.h            | 18 ++++++++++++++++++
 3 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
index e9fa22d31c23..f69d1233dc82 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -50,6 +50,7 @@
 static inline int ib_init_umem_odp(struct ib_umem_odp *umem_odp,
 				   const struct mmu_interval_notifier_ops *ops)
 {
+	struct ib_device *dev = umem_odp->umem.ibdev;
 	int ret;
 
 	umem_odp->umem.is_odp = 1;
@@ -87,15 +88,25 @@ static inline int ib_init_umem_odp(struct ib_umem_odp *umem_odp,
 			goto out_pfn_list;
 		}
 
+		umem_odp->iova.dev = dev->dma_device;
+		umem_odp->iova.size = end - start;
+		umem_odp->iova.dir = DMA_BIDIRECTIONAL;
+		ret = ib_dma_alloc_iova(dev, &umem_odp->iova);
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
+	ib_dma_free_iova(dev, &umem_odp->iova);
 out_dma_list:
 	kvfree(umem_odp->dma_list);
 out_pfn_list:
@@ -262,6 +273,8 @@ EXPORT_SYMBOL(ib_umem_odp_get);
 
 void ib_umem_odp_release(struct ib_umem_odp *umem_odp)
 {
+	struct ib_device *dev = umem_odp->umem.ibdev;
+
 	/*
 	 * Ensure that no more pages are mapped in the umem.
 	 *
@@ -274,6 +287,7 @@ void ib_umem_odp_release(struct ib_umem_odp *umem_odp)
 					    ib_umem_end(umem_odp));
 		mutex_unlock(&umem_odp->umem_mutex);
 		mmu_interval_notifier_remove(&umem_odp->notifier);
+		ib_dma_free_iova(dev, &umem_odp->iova);
 		kvfree(umem_odp->dma_list);
 		kvfree(umem_odp->pfn_list);
 	}
diff --git a/include/rdma/ib_umem_odp.h b/include/rdma/ib_umem_odp.h
index 0844c1d05ac6..bb2d7f2a5b04 100644
--- a/include/rdma/ib_umem_odp.h
+++ b/include/rdma/ib_umem_odp.h
@@ -23,6 +23,7 @@ struct ib_umem_odp {
 	 * See ODP_READ_ALLOWED_BIT and ODP_WRITE_ALLOWED_BIT.
 	 */
 	dma_addr_t		*dma_list;
+	struct dma_iova_attrs iova;
 	/*
 	 * The umem_mutex protects the page_list and dma_list fields of an ODP
 	 * umem, allowing only a single thread to map/unmap pages. The mutex
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index b7b6b58dd348..e71fa19187cc 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -4077,6 +4077,24 @@ static inline int ib_dma_mapping_error(struct ib_device *dev, u64 dma_addr)
 	return dma_mapping_error(dev->dma_device, dma_addr);
 }
 
+static inline int ib_dma_alloc_iova(struct ib_device *dev,
+				    struct dma_iova_attrs *iova)
+{
+	if (ib_uses_virt_dma(dev))
+		return 0;
+
+	return dma_alloc_iova(iova);
+}
+
+static inline void ib_dma_free_iova(struct ib_device *dev,
+				    struct dma_iova_attrs *iova)
+{
+	if (ib_uses_virt_dma(dev))
+		return;
+
+	dma_free_iova(iova);
+}
+
 /**
  * ib_dma_map_single - Map a kernel virtual address to DMA address
  * @dev: The device for which the dma_addr is to be created
-- 
2.44.0


