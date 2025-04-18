Return-Path: <kvm+bounces-43635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AD0DA932F1
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 08:59:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ABEE819E3512
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 06:57:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A98B2BCF5F;
	Fri, 18 Apr 2025 06:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bE6L/Qd6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C0429E045;
	Fri, 18 Apr 2025 06:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744958957; cv=none; b=AZdNKj29Dvf3yltUh84/mxXvw4A3ZzEEoIpUqBdG3nFeLxybaB0F/p83WYqqQrva7XPhzfaUT2+3SvEb0qhR9/3mHh0kikpfRHilNihgqGhswP6obGI54uRpUuV/yAnyn2oatrhm6TT4YE5h8dnCFG2O3lSnfRMRQN9lHCDIWzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744958957; c=relaxed/simple;
	bh=HJgtnQV3Z7DFJkA8N1J2fCnjnYx/yOhVpqXPhKdps7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tW8giSMKdkfmDkjUCX7lBzmOejp7CuOvgn0NqCSQ1i8Cqnj28WolbZ2PSB821TjLrnVD3wGP8uNiVKzSflz9T/QOTtqCv1BobOfDh5JHrCbLi69nnNKQeMNWGtl7SuJGjYZsDa79Yr/eCWV53nzJIt6Mik2J0nwddpbX1xyfQwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bE6L/Qd6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51403C4CEEF;
	Fri, 18 Apr 2025 06:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744958957;
	bh=HJgtnQV3Z7DFJkA8N1J2fCnjnYx/yOhVpqXPhKdps7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bE6L/Qd68wK1XzGQQ6QTBRVtW3f72knMy+clvpiH+Z3unEPxwNd0vDdGLK1x5m7R+
	 gbQk/OEa/pcuc85ygSuXnO1FfURrA1RJ4xrzMh2I9N0nW+mrCUxRWBgYv6IzWZwvGL
	 SyZgCJv1KGggfAPZuhYEw0vRY6f+J5eenL96WJmBywGR7HmM+78MQeEFMSPScqteL8
	 O7mXTBa48Pf1MgAB9JB6P/rp+HoLZpkKYCPoJhkfjIJsDxUyqA9bi1kRGETwC9ZgSy
	 PAgfxQsegr0NJXuarGXT3uXQS2P6pFgKBIgcAnScOax+ga9v+a7Qv2lDyJKOVQs9EZ
	 +po8hY5jFLecg==
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
Subject: [PATCH v8 16/24] vfio/mlx5: Rewrite create mkey flow to allow better code reuse
Date: Fri, 18 Apr 2025 09:47:46 +0300
Message-ID: <ec8fd8ad7c072b8091df9628cc3850e86242cffb.1744825142.git.leon@kernel.org>
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

Change the creation of mkey to be performed in multiple steps:
data allocation, DMA setup and actual call to HW to create that mkey.

In this new flow, the whole input to MKEY command is saved to eliminate
the need to keep array of pointers for DMA addresses for receive list
and in the future patches for send list too.

In addition to memory size reduce and elimination of unnecessary data
movements to set MKEY input, the code is prepared for future reuse.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c | 157 ++++++++++++++++++++----------------
 drivers/vfio/pci/mlx5/cmd.h |   4 +-
 2 files changed, 91 insertions(+), 70 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 377dee7765fb..84dc3bc128c6 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -313,39 +313,21 @@ static int mlx5vf_cmd_get_vhca_id(struct mlx5_core_dev *mdev, u16 function_id,
 	return ret;
 }
 
-static int _create_mkey(struct mlx5_core_dev *mdev, u32 pdn,
-			struct mlx5_vhca_data_buffer *buf,
-			struct mlx5_vhca_recv_buf *recv_buf,
-			u32 *mkey)
+static u32 *alloc_mkey_in(u32 npages, u32 pdn)
 {
-	size_t npages = buf ? buf->npages : recv_buf->npages;
-	int err = 0, inlen;
-	__be64 *mtt;
+	int inlen;
 	void *mkc;
 	u32 *in;
 
 	inlen = MLX5_ST_SZ_BYTES(create_mkey_in) +
-		sizeof(*mtt) * round_up(npages, 2);
+		sizeof(__be64) * round_up(npages, 2);
 
-	in = kvzalloc(inlen, GFP_KERNEL);
+	in = kvzalloc(inlen, GFP_KERNEL_ACCOUNT);
 	if (!in)
-		return -ENOMEM;
+		return NULL;
 
 	MLX5_SET(create_mkey_in, in, translations_octword_actual_size,
 		 DIV_ROUND_UP(npages, 2));
-	mtt = (__be64 *)MLX5_ADDR_OF(create_mkey_in, in, klm_pas_mtt);
-
-	if (buf) {
-		struct sg_dma_page_iter dma_iter;
-
-		for_each_sgtable_dma_page(&buf->table.sgt, &dma_iter, 0)
-			*mtt++ = cpu_to_be64(sg_page_iter_dma_address(&dma_iter));
-	} else {
-		int i;
-
-		for (i = 0; i < npages; i++)
-			*mtt++ = cpu_to_be64(recv_buf->dma_addrs[i]);
-	}
 
 	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
 	MLX5_SET(mkc, mkc, access_mode_1_0, MLX5_MKC_ACCESS_MODE_MTT);
@@ -359,9 +341,30 @@ static int _create_mkey(struct mlx5_core_dev *mdev, u32 pdn,
 	MLX5_SET(mkc, mkc, log_page_size, PAGE_SHIFT);
 	MLX5_SET(mkc, mkc, translations_octword_size, DIV_ROUND_UP(npages, 2));
 	MLX5_SET64(mkc, mkc, len, npages * PAGE_SIZE);
-	err = mlx5_core_create_mkey(mdev, mkey, in, inlen);
-	kvfree(in);
-	return err;
+
+	return in;
+}
+
+static int create_mkey(struct mlx5_core_dev *mdev, u32 npages,
+		       struct mlx5_vhca_data_buffer *buf, u32 *mkey_in,
+		       u32 *mkey)
+{
+	__be64 *mtt;
+	int inlen;
+
+	mtt = (__be64 *)MLX5_ADDR_OF(create_mkey_in, mkey_in, klm_pas_mtt);
+	if (buf) {
+		struct sg_dma_page_iter dma_iter;
+
+		for_each_sgtable_dma_page(&buf->table.sgt, &dma_iter, 0)
+			*mtt++ = cpu_to_be64(
+				sg_page_iter_dma_address(&dma_iter));
+	}
+
+	inlen = MLX5_ST_SZ_BYTES(create_mkey_in) +
+		sizeof(__be64) * round_up(npages, 2);
+
+	return mlx5_core_create_mkey(mdev, mkey, mkey_in, inlen);
 }
 
 static int mlx5vf_dma_data_buffer(struct mlx5_vhca_data_buffer *buf)
@@ -374,20 +377,28 @@ static int mlx5vf_dma_data_buffer(struct mlx5_vhca_data_buffer *buf)
 	if (mvdev->mdev_detach)
 		return -ENOTCONN;
 
-	if (buf->dmaed || !buf->npages)
+	if (buf->mkey_in || !buf->npages)
 		return -EINVAL;
 
 	ret = dma_map_sgtable(mdev->device, &buf->table.sgt, buf->dma_dir, 0);
 	if (ret)
 		return ret;
 
-	ret = _create_mkey(mdev, buf->migf->pdn, buf, NULL, &buf->mkey);
-	if (ret)
+	buf->mkey_in = alloc_mkey_in(buf->npages, buf->migf->pdn);
+	if (!buf->mkey_in) {
+		ret = -ENOMEM;
 		goto err;
+	}
 
-	buf->dmaed = true;
+	ret = create_mkey(mdev, buf->npages, buf, buf->mkey_in, &buf->mkey);
+	if (ret)
+		goto err_create_mkey;
 
 	return 0;
+
+err_create_mkey:
+	kvfree(buf->mkey_in);
+	buf->mkey_in = NULL;
 err:
 	dma_unmap_sgtable(mdev->device, &buf->table.sgt, buf->dma_dir, 0);
 	return ret;
@@ -401,8 +412,9 @@ void mlx5vf_free_data_buffer(struct mlx5_vhca_data_buffer *buf)
 	lockdep_assert_held(&migf->mvdev->state_mutex);
 	WARN_ON(migf->mvdev->mdev_detach);
 
-	if (buf->dmaed) {
+	if (buf->mkey_in) {
 		mlx5_core_destroy_mkey(migf->mvdev->mdev, buf->mkey);
+		kvfree(buf->mkey_in);
 		dma_unmap_sgtable(migf->mvdev->mdev->device, &buf->table.sgt,
 				  buf->dma_dir, 0);
 	}
@@ -783,7 +795,7 @@ int mlx5vf_cmd_load_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	if (mvdev->mdev_detach)
 		return -ENOTCONN;
 
-	if (!buf->dmaed) {
+	if (!buf->mkey_in) {
 		err = mlx5vf_dma_data_buffer(buf);
 		if (err)
 			return err;
@@ -1384,56 +1396,54 @@ static int alloc_recv_pages(struct mlx5_vhca_recv_buf *recv_buf,
 	kvfree(recv_buf->page_list);
 	return -ENOMEM;
 }
+static void unregister_dma_pages(struct mlx5_core_dev *mdev, u32 npages,
+				 u32 *mkey_in)
+{
+	dma_addr_t addr;
+	__be64 *mtt;
+	int i;
+
+	mtt = (__be64 *)MLX5_ADDR_OF(create_mkey_in, mkey_in, klm_pas_mtt);
+	for (i = npages - 1; i >= 0; i--) {
+		addr = be64_to_cpu(mtt[i]);
+		dma_unmap_single(mdev->device, addr, PAGE_SIZE,
+				DMA_FROM_DEVICE);
+	}
+}
 
-static int register_dma_recv_pages(struct mlx5_core_dev *mdev,
-				   struct mlx5_vhca_recv_buf *recv_buf)
+static int register_dma_pages(struct mlx5_core_dev *mdev, u32 npages,
+			      struct page **page_list, u32 *mkey_in)
 {
-	int i, j;
+	dma_addr_t addr;
+	__be64 *mtt;
+	int i;
 
-	recv_buf->dma_addrs = kvcalloc(recv_buf->npages,
-				       sizeof(*recv_buf->dma_addrs),
-				       GFP_KERNEL_ACCOUNT);
-	if (!recv_buf->dma_addrs)
-		return -ENOMEM;
+	mtt = (__be64 *)MLX5_ADDR_OF(create_mkey_in, mkey_in, klm_pas_mtt);
 
-	for (i = 0; i < recv_buf->npages; i++) {
-		recv_buf->dma_addrs[i] = dma_map_page(mdev->device,
-						      recv_buf->page_list[i],
-						      0, PAGE_SIZE,
-						      DMA_FROM_DEVICE);
-		if (dma_mapping_error(mdev->device, recv_buf->dma_addrs[i]))
+	for (i = 0; i < npages; i++) {
+		addr = dma_map_page(mdev->device, page_list[i], 0, PAGE_SIZE,
+				    DMA_FROM_DEVICE);
+		if (dma_mapping_error(mdev->device, addr))
 			goto error;
+
+		*mtt++ = cpu_to_be64(addr);
 	}
+
 	return 0;
 
 error:
-	for (j = 0; j < i; j++)
-		dma_unmap_single(mdev->device, recv_buf->dma_addrs[j],
-				 PAGE_SIZE, DMA_FROM_DEVICE);
-
-	kvfree(recv_buf->dma_addrs);
+	unregister_dma_pages(mdev, i, mkey_in);
 	return -ENOMEM;
 }
 
-static void unregister_dma_recv_pages(struct mlx5_core_dev *mdev,
-				      struct mlx5_vhca_recv_buf *recv_buf)
-{
-	int i;
-
-	for (i = 0; i < recv_buf->npages; i++)
-		dma_unmap_single(mdev->device, recv_buf->dma_addrs[i],
-				 PAGE_SIZE, DMA_FROM_DEVICE);
-
-	kvfree(recv_buf->dma_addrs);
-}
-
 static void mlx5vf_free_qp_recv_resources(struct mlx5_core_dev *mdev,
 					  struct mlx5_vhca_qp *qp)
 {
 	struct mlx5_vhca_recv_buf *recv_buf = &qp->recv_buf;
 
 	mlx5_core_destroy_mkey(mdev, recv_buf->mkey);
-	unregister_dma_recv_pages(mdev, recv_buf);
+	unregister_dma_pages(mdev, recv_buf->npages, recv_buf->mkey_in);
+	kvfree(recv_buf->mkey_in);
 	free_recv_pages(&qp->recv_buf);
 }
 
@@ -1449,18 +1459,29 @@ static int mlx5vf_alloc_qp_recv_resources(struct mlx5_core_dev *mdev,
 	if (err < 0)
 		return err;
 
-	err = register_dma_recv_pages(mdev, recv_buf);
-	if (err)
+	recv_buf->mkey_in = alloc_mkey_in(npages, pdn);
+	if (!recv_buf->mkey_in) {
+		err = -ENOMEM;
 		goto end;
+	}
+
+	err = register_dma_pages(mdev, npages, recv_buf->page_list,
+				 recv_buf->mkey_in);
+	if (err)
+		goto err_register_dma;
 
-	err = _create_mkey(mdev, pdn, NULL, recv_buf, &recv_buf->mkey);
+	err = create_mkey(mdev, npages, NULL, recv_buf->mkey_in,
+			  &recv_buf->mkey);
 	if (err)
 		goto err_create_mkey;
 
 	return 0;
 
 err_create_mkey:
-	unregister_dma_recv_pages(mdev, recv_buf);
+	unregister_dma_pages(mdev, npages, recv_buf->mkey_in);
+err_register_dma:
+	kvfree(recv_buf->mkey_in);
+	recv_buf->mkey_in = NULL;
 end:
 	free_recv_pages(recv_buf);
 	return err;
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index 7d4a833b6900..25dd6ff54591 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -58,8 +58,8 @@ struct mlx5_vhca_data_buffer {
 	u64 length;
 	u32 npages;
 	u32 mkey;
+	u32 *mkey_in;
 	enum dma_data_direction dma_dir;
-	u8 dmaed:1;
 	u8 stop_copy_chunk_num;
 	struct list_head buf_elm;
 	struct mlx5_vf_migration_file *migf;
@@ -133,8 +133,8 @@ struct mlx5_vhca_cq {
 struct mlx5_vhca_recv_buf {
 	u32 npages;
 	struct page **page_list;
-	dma_addr_t *dma_addrs;
 	u32 next_rq_offset;
+	u32 *mkey_in;
 	u32 mkey;
 };
 
-- 
2.49.0


