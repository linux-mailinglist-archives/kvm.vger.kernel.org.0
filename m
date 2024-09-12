Return-Path: <kvm+bounces-26699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DECA9767AB
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 13:24:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4DE3FB2445E
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 11:24:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6EDD1BC089;
	Thu, 12 Sep 2024 11:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kjpRjm1h"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04451BC9F8;
	Thu, 12 Sep 2024 11:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726139830; cv=none; b=LdalVTTN/SkezhSAKz+AFCRw38bSB3y5wriN6r9hfZfmULvPUmJJT/xGFFVnPcAlxk7U2u5kzIpvHVJrimf6G0rEZTjQQQsuQTOH0PEd4xB8LIve8ZWeru9ub0sAp4QuXcz8Q2kOTljJuw2N45X3cu9cXw+DCvR8ZThPpIPDnBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726139830; c=relaxed/simple;
	bh=Dk4iS9NnVthuwT4fk3pwSykLGjgnL3XiLR0Yj7fW2pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J9TJMRWYcn/wOooOVn40h6rFwsAVANyXYcjnWcys362WMAQXXFqkLqN7/y6AAWUGUF7oF2Yhpxk9LiX+o03w7NB74Hm6RUzD09p0vIJUp2XbyF8d5oTQlt0ViafbhL/MTeL1Z9HGSKRx189D9f/BvlwJrK3LnPHXf21jdXL7Pkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kjpRjm1h; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE28CC4CEC3;
	Thu, 12 Sep 2024 11:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726139829;
	bh=Dk4iS9NnVthuwT4fk3pwSykLGjgnL3XiLR0Yj7fW2pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kjpRjm1h2bUvRuIExn5ie51IkI7Jm6dqok5PQoPIBdaKTiScuVj9poh0E5VihqlwL
	 JjaQ3GvVH6eIHFREycnTcfFnR8B5WdUisaTBpXd95amUmnXD6U/VBhBmxrOCXvWbD/
	 6VZ+PGdVF+TBqen+57t389GmQ2RDNqfz8l3I/lRG44jgVUlAaTyuO2vAXzLUl++RsP
	 IaiugOGUZp1xGgxLVQFtR+MfHUzhg/N4H6zHKemVyqeb6wLciiRIG9IIgIwv3tWa++
	 P5dgq3KrKQkx0UkFhXCgHL+QUWnncEyB/uwrBtULY/llel3bfOUIKmAh2lBllYM+3R
	 2ozmZrOHNHgmg==
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
Subject: [RFC v2 17/21] vfio/mlx5: Convert vfio to use DMA link API
Date: Thu, 12 Sep 2024 14:15:52 +0300
Message-ID: <6369f834edd1e1144fbe11fd4b3aed3f63e33ade.1726138681.git.leon@kernel.org>
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

Remove intermediate scatter-gather table as it is not needed
if DMA link API is used. This conversion reduces drastically
the memory used to manage that table.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  | 211 ++++++++++++++++++-----------------
 drivers/vfio/pci/mlx5/cmd.h  |   8 +-
 drivers/vfio/pci/mlx5/main.c |  33 +-----
 3 files changed, 112 insertions(+), 140 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 34ae3e299a9e..aa2f1ec326c0 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -345,25 +345,78 @@ static u32 *alloc_mkey_in(u32 npages, u32 pdn)
 	return in;
 }
 
-static int create_mkey(struct mlx5_core_dev *mdev, u32 npages,
-		       struct mlx5_vhca_data_buffer *buf, u32 *mkey_in,
+static int create_mkey(struct mlx5_core_dev *mdev, u32 npages, u32 *mkey_in,
 		       u32 *mkey)
 {
+	int inlen = MLX5_ST_SZ_BYTES(create_mkey_in) +
+		sizeof(__be64) * round_up(npages, 2);
+
+	return mlx5_core_create_mkey(mdev, mkey, mkey_in, inlen);
+}
+
+static void unregister_dma_pages(struct mlx5_core_dev *mdev, u32 npages,
+				 u32 *mkey_in, struct dma_iova_state *state)
+{
+	dma_addr_t addr;
 	__be64 *mtt;
-	int inlen;
+	int i;
 
-	mtt = (__be64 *)MLX5_ADDR_OF(create_mkey_in, mkey_in, klm_pas_mtt);
-	if (buf) {
-		struct sg_dma_page_iter dma_iter;
+	WARN_ON_ONCE(state->dir == DMA_NONE);
 
-		for_each_sgtable_dma_page(&buf->table.sgt, &dma_iter, 0)
-			*mtt++ = cpu_to_be64(sg_page_iter_dma_address(&dma_iter));
+	if (state->use_iova) {
+		dma_unlink_range(state);
+	} else {
+		mtt = (__be64 *)MLX5_ADDR_OF(create_mkey_in, mkey_in,
+					     klm_pas_mtt);
+		for (i = npages - 1; i >= 0; i--) {
+			addr = be64_to_cpu(mtt[i]);
+			dma_unmap_page(state->dev, addr, PAGE_SIZE, state->dir);
+		}
 	}
+	dma_free_iova(state);
+}
 
-	inlen = MLX5_ST_SZ_BYTES(create_mkey_in) +
-		sizeof(__be64) * round_up(npages, 2);
+static int register_dma_pages(struct mlx5_core_dev *mdev, u32 npages,
+			      struct page **page_list, u32 *mkey_in,
+			      struct dma_iova_state *state)
+{
+	dma_addr_t addr;
+	__be64 *mtt;
+	int i, err;
 
-	return mlx5_core_create_mkey(mdev, mkey, mkey_in, inlen);
+	WARN_ON_ONCE(state->dir == DMA_NONE);
+
+	err = dma_alloc_iova(state, npages * PAGE_SIZE);
+	if (err)
+		return err;
+
+	dma_set_iova_state(state, page_list[0], PAGE_SIZE);
+
+	mtt = (__be64 *)MLX5_ADDR_OF(create_mkey_in, mkey_in, klm_pas_mtt);
+	err = dma_start_range(state);
+	if (err) {
+		dma_free_iova(state);
+		return err;
+	}
+	for (i = 0; i < npages; i++) {
+		if (state->use_iova)
+			addr = dma_link_range(state, page_to_phys(page_list[i]),
+					      PAGE_SIZE);
+		else
+			addr = dma_map_page(mdev->device, page_list[i], 0,
+					    PAGE_SIZE, state->dir);
+		err = dma_mapping_error(mdev->device, addr);
+		if (err)
+			goto error;
+		*mtt++ = cpu_to_be64(addr);
+	}
+	dma_end_range(state);
+
+	return 0;
+
+error:
+	unregister_dma_pages(mdev, i, mkey_in, state);
+	return err;
 }
 
 static int mlx5vf_dma_data_buffer(struct mlx5_vhca_data_buffer *buf)
@@ -379,50 +432,56 @@ static int mlx5vf_dma_data_buffer(struct mlx5_vhca_data_buffer *buf)
 	if (buf->mkey_in || !buf->npages)
 		return -EINVAL;
 
-	ret = dma_map_sgtable(mdev->device, &buf->table.sgt, buf->dma_dir, 0);
-	if (ret)
-		return ret;
-
 	buf->mkey_in = alloc_mkey_in(buf->npages, buf->migf->pdn);
-	if (!buf->mkey_in) {
-		ret = -ENOMEM;
-		goto err;
-	}
+	if (!buf->mkey_in)
+		return -ENOMEM;
 
-	ret = create_mkey(mdev, buf->npages, buf, buf->mkey_in, &buf->mkey);
+	ret = register_dma_pages(mdev, buf->npages, buf->page_list,
+				 buf->mkey_in, &buf->state);
+	if (ret)
+		goto err_register_dma;
+
+	ret = create_mkey(mdev, buf->npages, buf->mkey_in, &buf->mkey);
 	if (ret)
 		goto err_create_mkey;
 
 	return 0;
 
 err_create_mkey:
+	unregister_dma_pages(mdev, buf->npages, buf->mkey_in, &buf->state);
+err_register_dma:
 	kvfree(buf->mkey_in);
 	buf->mkey_in = NULL;
-err:
-	dma_unmap_sgtable(mdev->device, &buf->table.sgt, buf->dma_dir, 0);
 	return ret;
 }
 
+static void free_page_list(u32 npages, struct page **page_list)
+{
+	int i;
+
+	/* Undo alloc_pages_bulk_array() */
+	for (i = npages - 1; i >= 0; i--)
+		__free_page(page_list[i]);
+
+	kvfree(page_list);
+}
+
 void mlx5vf_free_data_buffer(struct mlx5_vhca_data_buffer *buf)
 {
-	struct mlx5_vf_migration_file *migf = buf->migf;
-	struct sg_page_iter sg_iter;
+	struct mlx5vf_pci_core_device *mvdev = buf->migf->mvdev;
+	struct mlx5_core_dev *mdev = mvdev->mdev;
 
-	lockdep_assert_held(&migf->mvdev->state_mutex);
-	WARN_ON(migf->mvdev->mdev_detach);
+	lockdep_assert_held(&mvdev->state_mutex);
+	WARN_ON(mvdev->mdev_detach);
 
 	if (buf->mkey_in) {
-		mlx5_core_destroy_mkey(migf->mvdev->mdev, buf->mkey);
+		mlx5_core_destroy_mkey(mdev, buf->mkey);
+		unregister_dma_pages(mdev, buf->npages, buf->mkey_in,
+				     &buf->state);
 		kvfree(buf->mkey_in);
-		dma_unmap_sgtable(migf->mvdev->mdev->device, &buf->table.sgt,
-				  buf->dma_dir, 0);
 	}
 
-	/* Undo alloc_pages_bulk_array() */
-	for_each_sgtable_page(&buf->table.sgt, &sg_iter, 0)
-		__free_page(sg_page_iter_page(&sg_iter));
-	sg_free_append_table(&buf->table);
-	kvfree(buf->page_list);
+	free_page_list(buf->npages, buf->page_list);
 	kfree(buf);
 }
 
@@ -433,7 +492,6 @@ static int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
 	struct page **page_list;
 	unsigned long filled;
 	unsigned int to_fill;
-	int ret;
 
 	to_fill = min_t(unsigned int, npages, PAGE_SIZE / sizeof(*buf->page_list));
 	page_list = kvzalloc(to_fill * sizeof(*buf->page_list), GFP_KERNEL_ACCOUNT);
@@ -443,22 +501,13 @@ static int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
 	buf->page_list = page_list;
 
 	do {
-		filled = alloc_pages_bulk_array(GFP_KERNEL_ACCOUNT, to_fill,
-				buf->page_list + buf->npages);
+		filled = alloc_pages_bulk_array(GFP_KERNEL_ACCOUNT, to_alloc,
+						buf->page_list + buf->npages);
 		if (!filled)
 			return -ENOMEM;
 
 		to_alloc -= filled;
-		ret = sg_alloc_append_table_from_pages(
-			&buf->table, buf->page_list + buf->npages, filled, 0,
-			filled << PAGE_SHIFT, UINT_MAX, SG_MAX_SINGLE_ALLOC,
-			GFP_KERNEL_ACCOUNT);
-
-		if (ret)
-			return ret;
 		buf->npages += filled;
-		to_fill = min_t(unsigned int, to_alloc,
-				PAGE_SIZE / sizeof(*buf->page_list));
 	} while (to_alloc > 0);
 
 	return 0;
@@ -468,6 +517,7 @@ struct mlx5_vhca_data_buffer *
 mlx5vf_alloc_data_buffer(struct mlx5_vf_migration_file *migf, u32 npages,
 			 enum dma_data_direction dma_dir)
 {
+	struct mlx5_core_dev *mdev = migf->mvdev->mdev;
 	struct mlx5_vhca_data_buffer *buf;
 	int ret;
 
@@ -475,7 +525,7 @@ mlx5vf_alloc_data_buffer(struct mlx5_vf_migration_file *migf, u32 npages,
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
 
-	buf->dma_dir = dma_dir;
+	dma_init_iova_state(&buf->state, mdev->device, dma_dir);
 	buf->migf = migf;
 	if (npages) {
 		ret = mlx5vf_add_migration_pages(buf, npages);
@@ -518,7 +568,7 @@ mlx5vf_get_data_buffer(struct mlx5_vf_migration_file *migf, u32 npages,
 
 	spin_lock_irq(&migf->list_lock);
 	list_for_each_entry_safe(buf, temp_buf, &migf->avail_list, buf_elm) {
-		if (buf->dma_dir == dma_dir) {
+		if (buf->state.dir == dma_dir) {
 			list_del_init(&buf->buf_elm);
 			if (buf->npages >= npages) {
 				spin_unlock_irq(&migf->list_lock);
@@ -1340,17 +1390,6 @@ static void mlx5vf_destroy_qp(struct mlx5_core_dev *mdev,
 	kfree(qp);
 }
 
-static void free_recv_pages(struct mlx5_vhca_recv_buf *recv_buf)
-{
-	int i;
-
-	/* Undo alloc_pages_bulk_array() */
-	for (i = 0; i < recv_buf->npages; i++)
-		__free_page(recv_buf->page_list[i]);
-
-	kvfree(recv_buf->page_list);
-}
-
 static int alloc_recv_pages(struct mlx5_vhca_recv_buf *recv_buf,
 			    unsigned int npages)
 {
@@ -1386,45 +1425,6 @@ static int alloc_recv_pages(struct mlx5_vhca_recv_buf *recv_buf,
 	kvfree(recv_buf->page_list);
 	return -ENOMEM;
 }
-static void unregister_dma_pages(struct mlx5_core_dev *mdev, u32 npages,
-				 u32 *mkey_in)
-{
-	dma_addr_t addr;
-	__be64 *mtt;
-	int i;
-
-	mtt = (__be64 *)MLX5_ADDR_OF(create_mkey_in, mkey_in, klm_pas_mtt);
-	for (i = npages - 1; i >= 0; i--) {
-		addr = be64_to_cpu(mtt[i]);
-		dma_unmap_single(mdev->device, addr, PAGE_SIZE,
-				DMA_FROM_DEVICE);
-	}
-}
-
-static int register_dma_pages(struct mlx5_core_dev *mdev, u32 npages,
-			      struct page **page_list, u32 *mkey_in)
-{
-	dma_addr_t addr;
-	__be64 *mtt;
-	int i;
-
-	mtt = (__be64 *)MLX5_ADDR_OF(create_mkey_in, mkey_in, klm_pas_mtt);
-
-	for (i = 0; i < npages; i++) {
-		addr = dma_map_page(mdev->device, page_list[i], 0, PAGE_SIZE,
-				    DMA_FROM_DEVICE);
-		if (dma_mapping_error(mdev->device, addr))
-			goto error;
-
-		*mtt++ = cpu_to_be64(addr);
-	}
-
-	return 0;
-
-error:
-	unregister_dma_pages(mdev, i, mkey_in);
-	return -ENOMEM;
-}
 
 static void mlx5vf_free_qp_recv_resources(struct mlx5_core_dev *mdev,
 					  struct mlx5_vhca_qp *qp)
@@ -1432,9 +1432,10 @@ static void mlx5vf_free_qp_recv_resources(struct mlx5_core_dev *mdev,
 	struct mlx5_vhca_recv_buf *recv_buf = &qp->recv_buf;
 
 	mlx5_core_destroy_mkey(mdev, recv_buf->mkey);
-	unregister_dma_pages(mdev, recv_buf->npages, recv_buf->mkey_in);
+	unregister_dma_pages(mdev, recv_buf->npages, recv_buf->mkey_in,
+			     &recv_buf->state);
 	kvfree(recv_buf->mkey_in);
-	free_recv_pages(&qp->recv_buf);
+	free_page_list(recv_buf->npages, recv_buf->page_list);
 }
 
 static int mlx5vf_alloc_qp_recv_resources(struct mlx5_core_dev *mdev,
@@ -1455,25 +1456,25 @@ static int mlx5vf_alloc_qp_recv_resources(struct mlx5_core_dev *mdev,
 		goto end;
 	}
 
+	recv_buf->state.dir = DMA_FROM_DEVICE;
 	err = register_dma_pages(mdev, npages, recv_buf->page_list,
-				 recv_buf->mkey_in);
+				 recv_buf->mkey_in, &recv_buf->state);
 	if (err)
 		goto err_register_dma;
 
-	err = create_mkey(mdev, npages, NULL, recv_buf->mkey_in,
-			  &recv_buf->mkey);
+	err = create_mkey(mdev, npages, recv_buf->mkey_in, &recv_buf->mkey);
 	if (err)
 		goto err_create_mkey;
 
 	return 0;
 
 err_create_mkey:
-	unregister_dma_pages(mdev, npages, recv_buf->mkey_in);
+	unregister_dma_pages(mdev, npages, recv_buf->mkey_in, &recv_buf->state);
 err_register_dma:
 	kvfree(recv_buf->mkey_in);
 	recv_buf->mkey_in = NULL;
 end:
-	free_recv_pages(recv_buf);
+	free_page_list(npages, recv_buf->page_list);
 	return err;
 }
 
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index 5b764199db53..8b0cd0ee11a0 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -54,20 +54,15 @@ struct mlx5_vf_migration_header {
 
 struct mlx5_vhca_data_buffer {
 	struct page **page_list;
-	struct sg_append_table table;
+	struct dma_iova_state state;
 	loff_t start_pos;
 	u64 length;
 	u32 npages;
 	u32 mkey;
 	u32 *mkey_in;
-	enum dma_data_direction dma_dir;
 	u8 stop_copy_chunk_num;
 	struct list_head buf_elm;
 	struct mlx5_vf_migration_file *migf;
-	/* Optimize mlx5vf_get_migration_page() for sequential access */
-	struct scatterlist *last_offset_sg;
-	unsigned int sg_last_entry;
-	unsigned long last_offset;
 };
 
 struct mlx5vf_async_data {
@@ -134,6 +129,7 @@ struct mlx5_vhca_cq {
 struct mlx5_vhca_recv_buf {
 	u32 npages;
 	struct page **page_list;
+	struct dma_iova_state state;
 	u32 next_rq_offset;
 	u32 *mkey_in;
 	u32 mkey;
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index d899cd499e27..f395b526e0ef 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -34,35 +34,10 @@ static struct mlx5vf_pci_core_device *mlx5vf_drvdata(struct pci_dev *pdev)
 			    core_device);
 }
 
-struct page *
-mlx5vf_get_migration_page(struct mlx5_vhca_data_buffer *buf,
-			  unsigned long offset)
+struct page *mlx5vf_get_migration_page(struct mlx5_vhca_data_buffer *buf,
+				       unsigned long offset)
 {
-	unsigned long cur_offset = 0;
-	struct scatterlist *sg;
-	unsigned int i;
-
-	/* All accesses are sequential */
-	if (offset < buf->last_offset || !buf->last_offset_sg) {
-		buf->last_offset = 0;
-		buf->last_offset_sg = buf->table.sgt.sgl;
-		buf->sg_last_entry = 0;
-	}
-
-	cur_offset = buf->last_offset;
-
-	for_each_sg(buf->last_offset_sg, sg,
-			buf->table.sgt.orig_nents - buf->sg_last_entry, i) {
-		if (offset < sg->length + cur_offset) {
-			buf->last_offset_sg = sg;
-			buf->sg_last_entry += i;
-			buf->last_offset = cur_offset;
-			return nth_page(sg_page(sg),
-					(offset - cur_offset) / PAGE_SIZE);
-		}
-		cur_offset += sg->length;
-	}
-	return NULL;
+	return buf->page_list[offset / PAGE_SIZE];
 }
 
 static void mlx5vf_disable_fd(struct mlx5_vf_migration_file *migf)
@@ -121,7 +96,7 @@ static void mlx5vf_buf_read_done(struct mlx5_vhca_data_buffer *vhca_buf)
 	struct mlx5_vf_migration_file *migf = vhca_buf->migf;
 
 	if (vhca_buf->stop_copy_chunk_num) {
-		bool is_header = vhca_buf->dma_dir == DMA_NONE;
+		bool is_header = vhca_buf->state.dir == DMA_NONE;
 		u8 chunk_num = vhca_buf->stop_copy_chunk_num;
 		size_t next_required_umem_size = 0;
 
-- 
2.46.0


