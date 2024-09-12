Return-Path: <kvm+bounces-26698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D429E9767A6
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 13:23:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1301A1C21992
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 11:23:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CEEA1BC078;
	Thu, 12 Sep 2024 11:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UsRoai/G"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F4B1BBBDC;
	Thu, 12 Sep 2024 11:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726139826; cv=none; b=B2H+QqHL6JOxObSzi614r84YtnnegOTlBReYtlf1lh8+x2gcYjd1wb7ByXGb9SGloN37PxVv8XvG6o4n0XgAUL+IgTUJo9pKZs45TbK4v96HTY7+I0uVZXLtIzph9WKvp2vuA/Y1H0yHtkpJM+ei6qLTrHE8n1kNFV3icfFckS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726139826; c=relaxed/simple;
	bh=bjk1/BnJ6tUGghkO4rbI4kdxFyJB6hE60cQFrbYFFeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ifc9zP8ol1KcNwtBZ3BBbXUuvjCDZF8TyaLQ/s2dL8SOwIgrnI59I3B1BHI3wpUrovM+o6c2UhEIHhMAf/LnJFWaBMBo7pXykYxcHNIYxkUFoKwAmxoD6Lqm6XkI3zUWWQS4FrXj1tLl6c7HVkaQdgKjNrVwm/Ll1TlDKMsznSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UsRoai/G; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E846BC4CEC3;
	Thu, 12 Sep 2024 11:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726139825;
	bh=bjk1/BnJ6tUGghkO4rbI4kdxFyJB6hE60cQFrbYFFeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UsRoai/Gl1O7Sp/5JxPcgDAMkM6ipvgzmFXZSPfGag9Gk7eyJG+VdfuCd9QQGwabJ
	 pJBnMolBMOdTzs2oBWlCngWlKspt0aKi0IHd0NV1QihXlPw5ge9SnJv5HvlQ9XFtJ2
	 wvSrcUz771/xmw0ldpU61b3KgEsbAG/eWsjbov/ea9Im3sNpjnLMXT3teQeLNuWGlW
	 zII+LQmGfNzh72GCbpz3SCfX2gX6N1CfXTsSY+Ww/DdM41MOuzoB721TYZNr8BqV4f
	 riGijidjEDVmzfKlimoUn1I9Q+v5auRTA9QlQWa335Fob1c5NshgGTh7q6eI8Gv2/D
	 Lza+f4KBMQA/g==
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
Subject: [RFC v2 16/21] vfio/mlx5: Explicitly store page list
Date: Thu, 12 Sep 2024 14:15:51 +0300
Message-ID: <ec473be1e99725c3c40825254066538565f86dbb.1726138681.git.leon@kernel.org>
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

As a preparation to removal scatter-gather table and unifying
receive and send list, explicitly store page list.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c | 29 ++++++++++++-----------------
 drivers/vfio/pci/mlx5/cmd.h |  1 +
 2 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 1832a6c1f35d..34ae3e299a9e 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -422,6 +422,7 @@ void mlx5vf_free_data_buffer(struct mlx5_vhca_data_buffer *buf)
 	for_each_sgtable_page(&buf->table.sgt, &sg_iter, 0)
 		__free_page(sg_page_iter_page(&sg_iter));
 	sg_free_append_table(&buf->table);
+	kvfree(buf->page_list);
 	kfree(buf);
 }
 
@@ -434,39 +435,33 @@ static int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
 	unsigned int to_fill;
 	int ret;
 
-	to_fill = min_t(unsigned int, npages, PAGE_SIZE / sizeof(*page_list));
-	page_list = kvzalloc(to_fill * sizeof(*page_list), GFP_KERNEL_ACCOUNT);
+	to_fill = min_t(unsigned int, npages, PAGE_SIZE / sizeof(*buf->page_list));
+	page_list = kvzalloc(to_fill * sizeof(*buf->page_list), GFP_KERNEL_ACCOUNT);
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
2.46.0


