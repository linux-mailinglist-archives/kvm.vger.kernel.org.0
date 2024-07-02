Return-Path: <kvm+bounces-20842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C19CD92398B
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 11:17:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 857D6282E6D
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 09:17:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65DB317A93B;
	Tue,  2 Jul 2024 09:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NhTi/KqE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B51117921D;
	Tue,  2 Jul 2024 09:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719911474; cv=none; b=GpsrGfUc2uRNFAIpuLTPye5+SD4J5FVI3VbR/KDnk2CR8QKLlAj1856nyqPPiVkWuDsO85w83BK8Cr4BXFy3UOm0yjobtqKInN8K/FyriouhA5LYHvyEl2NKLQk1Ydsu5qeE+mt+7NWyLYORc8A5A/pMAHJSbKMKeF2I6IUgRZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719911474; c=relaxed/simple;
	bh=PIW7uecyqbo8l+/QQ3xYJoQlnbA8PPRXn3HjOM7nqAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MkcUIjIURRssCtolkeW+KDZIeygp/ExJD0LbhtbIb2IdojJPR1TP04La5+a1WG/kKZ7/AmPyoMbLVoVLCxl6i90YO8JPtODycepuMrJb+zJWp/BOYHbB8psQ02WpyZf/HDpbGmtMqQkIbe/eqtZR3v1IGwRj2pv2vpFDyoJgsS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NhTi/KqE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CABDC116B1;
	Tue,  2 Jul 2024 09:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719911474;
	bh=PIW7uecyqbo8l+/QQ3xYJoQlnbA8PPRXn3HjOM7nqAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NhTi/KqELO0ntEOXqd97jqF285urhVtp0ovXZbMP4lcmZaDwcgPg/5W9aGAWMevzM
	 GDilwAbddqGsrw6Zr4IKwgEv/nWRXIl2ieuB+HDrivIcEW+HlwLJRNlmEiKZLN2rHp
	 0muXrcmfjl0zBQ2vUDmhRG8u6kxF++q1H1AnwZx2MUDaHup1Eyt+Cx95IXnEJ7sI4X
	 am+hv9pcwPTPSt+yJK71cxH2vUFES69TrTtxJVdEaMHZrLleT2dLw+rgqcyKXSgXqu
	 Hh1xdmh+LLCL2umU4Gf1ef/Cnv3MoUC9ltluYS0I8qeptgpVu09+wfyU+0sTdQu4iU
	 nF6+LSv5nDujA==
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
Subject: [RFC PATCH v1 15/18] vfio/mlx5: Explicitly store page list
Date: Tue,  2 Jul 2024 12:09:45 +0300
Message-ID: <2691374c551bc276ec135ea58207a440e34f7be4.1719909395.git.leon@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1719909395.git.leon@kernel.org>
References: <cover.1719909395.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

As a preparation to removal scatter-gather table and unifying
receive and send list, explicitly store page list.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c | 33 ++++++++++++++++-----------------
 drivers/vfio/pci/mlx5/cmd.h |  1 +
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index adf57104555a..cb23f03d58f4 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -421,6 +421,7 @@ void mlx5vf_free_data_buffer(struct mlx5_vhca_data_buffer *buf)
 	for_each_sgtable_page(&buf->table.sgt, &sg_iter, 0)
 		__free_page(sg_page_iter_page(&sg_iter));
 	sg_free_append_table(&buf->table);
+	kvfree(buf->page_list);
 	kfree(buf);
 }
 
@@ -428,44 +429,42 @@ static int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
 				      unsigned int npages)
 {
 	unsigned int to_alloc = npages;
+	size_t old_size, new_size;
 	struct page **page_list;
 	unsigned long filled;
 	unsigned int to_fill;
 	int ret;
 
-	to_fill = min_t(unsigned int, npages, PAGE_SIZE / sizeof(*page_list));
-	page_list = kvzalloc(to_fill * sizeof(*page_list), GFP_KERNEL_ACCOUNT);
+	to_fill = min_t(unsigned int, npages, PAGE_SIZE / sizeof(*buf->page_list));
+	old_size = buf->npages * sizeof(*buf->page_list);
+	new_size = old_size + to_alloc * sizeof(*buf->page_list);
+	page_list = kvrealloc(buf->page_list, old_size, new_size,
+			GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	if (!page_list)
 		return -ENOMEM;
 
+	buf->page_list = page_list;
+
 	do {
 		filled = alloc_pages_bulk_array(GFP_KERNEL_ACCOUNT, to_fill,
-						page_list);
-		if (!filled) {
-			ret = -ENOMEM;
-			goto err;
-		}
+				buf->page_list + buf->npages);
+		if (!filled)
+			return -ENOMEM;
+
 		to_alloc -= filled;
 		ret = sg_alloc_append_table_from_pages(
-			&buf->table, page_list, filled, 0,
+			&buf->table, buf->page_list + buf->npages, filled, 0,
 			filled << PAGE_SHIFT, UINT_MAX, SG_MAX_SINGLE_ALLOC,
 			GFP_KERNEL_ACCOUNT);
 
 		if (ret)
-			goto err;
+			return ret;
 		buf->npages += filled;
-		/* clean input for another bulk allocation */
-		memset(page_list, 0, filled * sizeof(*page_list));
 		to_fill = min_t(unsigned int, to_alloc,
-				PAGE_SIZE / sizeof(*page_list));
+				PAGE_SIZE / sizeof(*buf->page_list));
 	} while (to_alloc > 0);
 
-	kvfree(page_list);
 	return 0;
-
-err:
-	kvfree(page_list);
-	return ret;
 }
 
 struct mlx5_vhca_data_buffer *
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index 25dd6ff54591..5b764199db53 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -53,6 +53,7 @@ struct mlx5_vf_migration_header {
 };
 
 struct mlx5_vhca_data_buffer {
+	struct page **page_list;
 	struct sg_append_table table;
 	loff_t start_pos;
 	u64 length;
-- 
2.45.2


