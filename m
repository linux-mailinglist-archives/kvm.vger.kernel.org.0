Return-Path: <kvm+bounces-43894-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A16AA982EA
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 10:21:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A6A54425B2
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 08:21:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4571E284689;
	Wed, 23 Apr 2025 08:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qE+s9EHz"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5566B28137B;
	Wed, 23 Apr 2025 08:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745396093; cv=none; b=qv/rDhwOkmXUPCjKEbGguqDbeCbpBltq1++OR5F0fuVFsHL3CeP2OCgEm7FGEU0ulIdbZHubV+5RVpAn2HUHpoZvBlHUwVikTn3ggZ9nXEX/6zI4oBuYiKqtGxhQ1ggzCf0RqgiN5+f7GkO/vrz9x+uVLB3lWL4Njap0c2NppKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745396093; c=relaxed/simple;
	bh=Z+8b4NYee1RUbpzKZ39zN1WZWDjcticSFOudJv0T43g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bZfr+MLZo7CICYD1TzkT+PhqZFa/44CT23r1YInwbeqNa15cZYeS73zv0T1e+XNurxhlmjohvomOTANJ3e1QA7wz1RPee5Urd2B9UoeQp/jYjRwBRIhNJ+BfYnYe0hpST8kErrxobKN+cyf4gAeRnJUh3+Fj47PTPf8DXwws9yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qE+s9EHz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E5CC4CEE2;
	Wed, 23 Apr 2025 08:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745396092;
	bh=Z+8b4NYee1RUbpzKZ39zN1WZWDjcticSFOudJv0T43g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qE+s9EHzPEDuLSGuHtZ28CtFY2uP1N7/71Y4qUuPA1VYvkHQi1X+QIdGvBh1kufix
	 fyFBxbj8RS7eYnjPsDL0TULXuy3CIGPdwZinB3JLbx7zwzwCdkWGBEdJb4rhp/mmlF
	 ZuZQZWT0dUpbmDgvKrxUcQyTBH0c17V53Mc/U4iAdtOHRaot1vxpB8jMvVzxUs7QfG
	 UNkbegqVsrxw8/dJf9Z9OhMKsfazIMs85/DY+x5vhf90LKB8C8VfJHyBOQRu8OfoAk
	 RpgqK8RnCT7JmT1h6krz1xV5dJzRsOL4/Www3v4q0jwuz9VZy6JbpltYmdVtDzX+T5
	 1cx0j+QaWq69A==
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
	Chaitanya Kulkarni <kch@nvidia.com>
Subject: [PATCH v9 14/24] RDMA/umem: Separate implicit ODP initialization from explicit ODP
Date: Wed, 23 Apr 2025 11:13:05 +0300
Message-ID: <c79721bb70988f60fa23fdfb6785e13f6ef806c5.1745394536.git.leon@kernel.org>
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

Create separate functions for the implicit ODP initialization
which is different from the explicit ODP initialization.

Tested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/core/umem_odp.c | 91 +++++++++++++++---------------
 1 file changed, 46 insertions(+), 45 deletions(-)

diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
index 30cd8f353476..51d518989914 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -48,41 +48,44 @@
 
 #include "uverbs.h"
 
-static inline int ib_init_umem_odp(struct ib_umem_odp *umem_odp,
-				   const struct mmu_interval_notifier_ops *ops)
+static void ib_init_umem_implicit_odp(struct ib_umem_odp *umem_odp)
+{
+	umem_odp->is_implicit_odp = 1;
+	umem_odp->umem.is_odp = 1;
+	mutex_init(&umem_odp->umem_mutex);
+}
+
+static int ib_init_umem_odp(struct ib_umem_odp *umem_odp,
+			    const struct mmu_interval_notifier_ops *ops)
 {
 	struct ib_device *dev = umem_odp->umem.ibdev;
+	size_t page_size = 1UL << umem_odp->page_shift;
+	unsigned long start;
+	unsigned long end;
 	int ret;
 
 	umem_odp->umem.is_odp = 1;
 	mutex_init(&umem_odp->umem_mutex);
 
-	if (!umem_odp->is_implicit_odp) {
-		size_t page_size = 1UL << umem_odp->page_shift;
-		unsigned long start;
-		unsigned long end;
-
-		start = ALIGN_DOWN(umem_odp->umem.address, page_size);
-		if (check_add_overflow(umem_odp->umem.address,
-				       (unsigned long)umem_odp->umem.length,
-				       &end))
-			return -EOVERFLOW;
-		end = ALIGN(end, page_size);
-		if (unlikely(end < page_size))
-			return -EOVERFLOW;
-
-		ret = hmm_dma_map_alloc(dev->dma_device, &umem_odp->map,
-					(end - start) >> PAGE_SHIFT,
-					1 << umem_odp->page_shift);
-		if (ret)
-			return ret;
-
-		ret = mmu_interval_notifier_insert(&umem_odp->notifier,
-						   umem_odp->umem.owning_mm,
-						   start, end - start, ops);
-		if (ret)
-			goto out_free_map;
-	}
+	start = ALIGN_DOWN(umem_odp->umem.address, page_size);
+	if (check_add_overflow(umem_odp->umem.address,
+			       (unsigned long)umem_odp->umem.length, &end))
+		return -EOVERFLOW;
+	end = ALIGN(end, page_size);
+	if (unlikely(end < page_size))
+		return -EOVERFLOW;
+
+	ret = hmm_dma_map_alloc(dev->dma_device, &umem_odp->map,
+				(end - start) >> PAGE_SHIFT,
+				1 << umem_odp->page_shift);
+	if (ret)
+		return ret;
+
+	ret = mmu_interval_notifier_insert(&umem_odp->notifier,
+					   umem_odp->umem.owning_mm, start,
+					   end - start, ops);
+	if (ret)
+		goto out_free_map;
 
 	return 0;
 
@@ -106,7 +109,6 @@ struct ib_umem_odp *ib_umem_odp_alloc_implicit(struct ib_device *device,
 {
 	struct ib_umem *umem;
 	struct ib_umem_odp *umem_odp;
-	int ret;
 
 	if (access & IB_ACCESS_HUGETLB)
 		return ERR_PTR(-EINVAL);
@@ -118,16 +120,10 @@ struct ib_umem_odp *ib_umem_odp_alloc_implicit(struct ib_device *device,
 	umem->ibdev = device;
 	umem->writable = ib_access_writable(access);
 	umem->owning_mm = current->mm;
-	umem_odp->is_implicit_odp = 1;
 	umem_odp->page_shift = PAGE_SHIFT;
 
 	umem_odp->tgid = get_task_pid(current->group_leader, PIDTYPE_PID);
-	ret = ib_init_umem_odp(umem_odp, NULL);
-	if (ret) {
-		put_pid(umem_odp->tgid);
-		kfree(umem_odp);
-		return ERR_PTR(ret);
-	}
+	ib_init_umem_implicit_odp(umem_odp);
 	return umem_odp;
 }
 EXPORT_SYMBOL(ib_umem_odp_alloc_implicit);
@@ -248,7 +244,7 @@ struct ib_umem_odp *ib_umem_odp_get(struct ib_device *device,
 }
 EXPORT_SYMBOL(ib_umem_odp_get);
 
-void ib_umem_odp_release(struct ib_umem_odp *umem_odp)
+static void ib_umem_odp_free(struct ib_umem_odp *umem_odp)
 {
 	struct ib_device *dev = umem_odp->umem.ibdev;
 
@@ -258,14 +254,19 @@ void ib_umem_odp_release(struct ib_umem_odp *umem_odp)
 	 * It is the driver's responsibility to ensure, before calling us,
 	 * that the hardware will not attempt to access the MR any more.
 	 */
-	if (!umem_odp->is_implicit_odp) {
-		mutex_lock(&umem_odp->umem_mutex);
-		ib_umem_odp_unmap_dma_pages(umem_odp, ib_umem_start(umem_odp),
-					    ib_umem_end(umem_odp));
-		mutex_unlock(&umem_odp->umem_mutex);
-		mmu_interval_notifier_remove(&umem_odp->notifier);
-		hmm_dma_map_free(dev->dma_device, &umem_odp->map);
-	}
+	mutex_lock(&umem_odp->umem_mutex);
+	ib_umem_odp_unmap_dma_pages(umem_odp, ib_umem_start(umem_odp),
+				    ib_umem_end(umem_odp));
+	mutex_unlock(&umem_odp->umem_mutex);
+	mmu_interval_notifier_remove(&umem_odp->notifier);
+	hmm_dma_map_free(dev->dma_device, &umem_odp->map);
+}
+
+void ib_umem_odp_release(struct ib_umem_odp *umem_odp)
+{
+	if (!umem_odp->is_implicit_odp)
+		ib_umem_odp_free(umem_odp);
+
 	put_pid(umem_odp->tgid);
 	kfree(umem_odp);
 }
-- 
2.49.0


