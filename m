Return-Path: <kvm+bounces-10932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E9D5871B96
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 11:38:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 482A1282E8D
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 10:38:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 015207350F;
	Tue,  5 Mar 2024 10:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uf0bag2d"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14CBA54FA7;
	Tue,  5 Mar 2024 10:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709634176; cv=none; b=sgwT2ILJ5hk2Vwpk0ZCFd8UP58dqWp4vlVDW2+mFltIYU5p1lq0C5E6ssXW4mBnkYpzZn1sRrgfJ6nOTwwHJgTW42UKnhJh97jInZFvMlcxpOX/OuceXG7A5S7th54OM6l0ESslxQoOD4kRnCgfmxQoYDWhkl5DOyRt1xAaBiuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709634176; c=relaxed/simple;
	bh=E8ahaIx2eHfPJk0G81HhbupoEvLGKO0ealmbIxFQ2TY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQgzXcGL8uR0+cxymPMEm1ZMHWHPZS/d6laWq6X3q+svA2FQpRXEYQ0o1fbZ21bJjYFuvkskmG/lSHh1bpiFo5FgDzv5JYduZlq9JtgsZDlBwEW8w3nj1il8VTHX9G2E8b3ZhG1u5VhokIBCmsaWfdGk7Ih2dAuBuRqe5KmIuqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uf0bag2d; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE75C433F1;
	Tue,  5 Mar 2024 10:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709634175;
	bh=E8ahaIx2eHfPJk0G81HhbupoEvLGKO0ealmbIxFQ2TY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uf0bag2dpmDC8WdvfUXP0lkuZiQqs9DSJTSOiPPopdM6nI4sfZIJ0gQomOcvskrGu
	 MOxNhWnWeQzF8psuVrHloTQHZ3y5OfUMLvGmZVJ8bj12nFrsThqO2Nf/u2Scfc7Ic6
	 WOdHTd6fO8gOxhkZWpdeLx4+Ll731HcWVEMEZoqag+JGLFnnevqGqgpxU1OH8SxFJO
	 erdae4KD42Zn0tQ0EmfXiUntVaXwk1IPMov8zjBLwxhVOaPYEQhdr5c03QiCskzsio
	 KvRmPU99U3M92DNV9W6cdaFD2MMSN60bxyY4tmOPu4V7bove1OSlwQrZQqn+Q8uvZe
	 8d0Ve/1K0suEw==
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
Subject: [RFC 07/16] RDMA/umem: Preallocate and cache IOVA for UMEM ODP
Date: Tue,  5 Mar 2024 12:22:08 +0200
Message-ID: <47cc27fbaf9f4bd19edbcaac380bdd9684c5d12f.1709631413.git.leon@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1709631800.git.leon@kernel.org>
References: <cover.1709631800.git.leon@kernel.org>
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


