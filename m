Return-Path: <kvm+bounces-35760-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ACE4BA14D2C
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 11:11:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB87C168676
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 10:11:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E89821578A;
	Fri, 17 Jan 2025 10:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dPnPlsl4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628F42135BC;
	Fri, 17 Jan 2025 10:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737108302; cv=none; b=PPIewspFaGtJraFnY44evTzvZZwRhG4qCrY95FcTO8lm6v8dGk642gWLoaO16xMnTUCyVYvxRag4QAE6MjxJeqfCUkCUccl8d9tfe8mg4aunTRbuQWsKbuBLwDyqxSw2MRTFg9uOWtIHJjDCeLErsM0G9jMPtPWOwmw6G9kUtsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737108302; c=relaxed/simple;
	bh=NjoF5CkFbjfbiiDh3lbvpEgTINBqFJZ8gAtQ0qoZOsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZRp/oJT5rack7tKBTNcsxhJHpJzFF0cDdV8kFuWL63rh1D0qjr2NR2rIXMOzb9V4wYqWGA7MHDb4q4qJqdevc+B9Abt6YIGMqdVtqNPhY9QE40NDM9bT9j+C5I4hGKEhBCDSUCrRpgjeJx5npr27soHZNYw430F7pE256PKvUu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dPnPlsl4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750C6C4CEDD;
	Fri, 17 Jan 2025 10:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737108302;
	bh=NjoF5CkFbjfbiiDh3lbvpEgTINBqFJZ8gAtQ0qoZOsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dPnPlsl4l3XEbZ6+YufhPOPVz19IDZFEVZFvoB2c4laBaP28NRzb/ZXJ06r4Me1/r
	 ZtZjVoJHCnUfeZFeD4gCzg+vtq91HawcJ5qyJEdu23sfd9OtIUfRVcYghCJJDEurAp
	 glHdtj4q1NaA0Z6Lra2VOeUfxHHriM0Q8hT9DTFrZDnqMncxg2Ra4WEHoYA8QI7+Mr
	 AyV1GlmFAZg0fVxyqWovsMk/wbm3vWsw7G2di4YbfG4lUqsZLKMFUfLunEjTLAkdNb
	 yYu6xI98I+5MpSRovIfbQr5xCjXxzzDgayLWG4w8ylx7iPalO6zWqSy4HYQSzkh58u
	 aJO6ADhEGgmZg==
From: Leon Romanovsky <leon@kernel.org>
To: 
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	"Keith Busch" <kbusch@kernel.org>,
	"Bjorn Helgaas" <bhelgaas@google.com>,
	"Logan Gunthorpe" <logang@deltatee.com>,
	"Yishai Hadas" <yishaih@nvidia.com>,
	"Shameer Kolothum" <shameerali.kolothum.thodi@huawei.com>,
	"Kevin Tian" <kevin.tian@intel.com>,
	"Alex Williamson" <alex.williamson@redhat.com>,
	"Marek Szyprowski" <m.szyprowski@samsung.com>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"Jonathan Corbet" <corbet@lwn.net>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-pci@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-mm@kvack.org,
	"Randy Dunlap" <rdunlap@infradead.org>
Subject: [PATCH v6 15/17] vfio/mlx5: Explicitly use number of pages instead of allocated length
Date: Fri, 17 Jan 2025 12:03:46 +0200
Message-ID: <e26f132eb79ee0217181a9c8d1d2856c8060ff1d.1737106761.git.leon@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1737106761.git.leon@kernel.org>
References: <cover.1737106761.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

allocated_length is a multiple of page size and number of pages,
so let's change the functions to accept number of pages. It opens
us a venue to combine receive and send paths together with code
readability improvement.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  | 32 ++++++++++-----------
 drivers/vfio/pci/mlx5/cmd.h  | 10 +++----
 drivers/vfio/pci/mlx5/main.c | 56 +++++++++++++++++++++++-------------
 3 files changed, 57 insertions(+), 41 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 7527e277c898..88e76afba606 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -318,8 +318,7 @@ static int _create_mkey(struct mlx5_core_dev *mdev, u32 pdn,
 			struct mlx5_vhca_recv_buf *recv_buf,
 			u32 *mkey)
 {
-	size_t npages = buf ? DIV_ROUND_UP(buf->allocated_length, PAGE_SIZE) :
-				recv_buf->npages;
+	size_t npages = buf ? buf->npages : recv_buf->npages;
 	int err = 0, inlen;
 	__be64 *mtt;
 	void *mkc;
@@ -375,7 +374,7 @@ static int mlx5vf_dma_data_buffer(struct mlx5_vhca_data_buffer *buf)
 	if (mvdev->mdev_detach)
 		return -ENOTCONN;
 
-	if (buf->dmaed || !buf->allocated_length)
+	if (buf->dmaed || !buf->npages)
 		return -EINVAL;
 
 	ret = dma_map_sgtable(mdev->device, &buf->table.sgt, buf->dma_dir, 0);
@@ -445,7 +444,7 @@ static int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
 
 		if (ret)
 			goto err_append;
-		buf->allocated_length += filled * PAGE_SIZE;
+		buf->npages += filled;
 		/* clean input for another bulk allocation */
 		memset(page_list, 0, filled * sizeof(*page_list));
 		to_fill = min_t(unsigned int, to_alloc,
@@ -464,8 +463,7 @@ static int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
 }
 
 struct mlx5_vhca_data_buffer *
-mlx5vf_alloc_data_buffer(struct mlx5_vf_migration_file *migf,
-			 size_t length,
+mlx5vf_alloc_data_buffer(struct mlx5_vf_migration_file *migf, u32 npages,
 			 enum dma_data_direction dma_dir)
 {
 	struct mlx5_vhca_data_buffer *buf;
@@ -477,9 +475,8 @@ mlx5vf_alloc_data_buffer(struct mlx5_vf_migration_file *migf,
 
 	buf->dma_dir = dma_dir;
 	buf->migf = migf;
-	if (length) {
-		ret = mlx5vf_add_migration_pages(buf,
-				DIV_ROUND_UP_ULL(length, PAGE_SIZE));
+	if (npages) {
+		ret = mlx5vf_add_migration_pages(buf, npages);
 		if (ret)
 			goto end;
 
@@ -505,8 +502,8 @@ void mlx5vf_put_data_buffer(struct mlx5_vhca_data_buffer *buf)
 }
 
 struct mlx5_vhca_data_buffer *
-mlx5vf_get_data_buffer(struct mlx5_vf_migration_file *migf,
-		       size_t length, enum dma_data_direction dma_dir)
+mlx5vf_get_data_buffer(struct mlx5_vf_migration_file *migf, u32 npages,
+		       enum dma_data_direction dma_dir)
 {
 	struct mlx5_vhca_data_buffer *buf, *temp_buf;
 	struct list_head free_list;
@@ -521,7 +518,7 @@ mlx5vf_get_data_buffer(struct mlx5_vf_migration_file *migf,
 	list_for_each_entry_safe(buf, temp_buf, &migf->avail_list, buf_elm) {
 		if (buf->dma_dir == dma_dir) {
 			list_del_init(&buf->buf_elm);
-			if (buf->allocated_length >= length) {
+			if (buf->npages >= npages) {
 				spin_unlock_irq(&migf->list_lock);
 				goto found;
 			}
@@ -535,7 +532,7 @@ mlx5vf_get_data_buffer(struct mlx5_vf_migration_file *migf,
 		}
 	}
 	spin_unlock_irq(&migf->list_lock);
-	buf = mlx5vf_alloc_data_buffer(migf, length, dma_dir);
+	buf = mlx5vf_alloc_data_buffer(migf, npages, dma_dir);
 
 found:
 	while ((temp_buf = list_first_entry_or_null(&free_list,
@@ -716,7 +713,7 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	MLX5_SET(save_vhca_state_in, in, op_mod, 0);
 	MLX5_SET(save_vhca_state_in, in, vhca_id, mvdev->vhca_id);
 	MLX5_SET(save_vhca_state_in, in, mkey, buf->mkey);
-	MLX5_SET(save_vhca_state_in, in, size, buf->allocated_length);
+	MLX5_SET(save_vhca_state_in, in, size, buf->npages * PAGE_SIZE);
 	MLX5_SET(save_vhca_state_in, in, incremental, inc);
 	MLX5_SET(save_vhca_state_in, in, set_track, track);
 
@@ -738,8 +735,11 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	}
 
 	if (!header_buf) {
-		header_buf = mlx5vf_get_data_buffer(migf,
-			sizeof(struct mlx5_vf_migration_header), DMA_NONE);
+		header_buf = mlx5vf_get_data_buffer(
+			migf,
+			DIV_ROUND_UP(sizeof(struct mlx5_vf_migration_header),
+				     PAGE_SIZE),
+			DMA_NONE);
 		if (IS_ERR(header_buf)) {
 			err = PTR_ERR(header_buf);
 			goto err_free;
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index df421dc6de04..7d4a833b6900 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -56,7 +56,7 @@ struct mlx5_vhca_data_buffer {
 	struct sg_append_table table;
 	loff_t start_pos;
 	u64 length;
-	u64 allocated_length;
+	u32 npages;
 	u32 mkey;
 	enum dma_data_direction dma_dir;
 	u8 dmaed:1;
@@ -217,12 +217,12 @@ int mlx5vf_cmd_alloc_pd(struct mlx5_vf_migration_file *migf);
 void mlx5vf_cmd_dealloc_pd(struct mlx5_vf_migration_file *migf);
 void mlx5fv_cmd_clean_migf_resources(struct mlx5_vf_migration_file *migf);
 struct mlx5_vhca_data_buffer *
-mlx5vf_alloc_data_buffer(struct mlx5_vf_migration_file *migf,
-			 size_t length, enum dma_data_direction dma_dir);
+mlx5vf_alloc_data_buffer(struct mlx5_vf_migration_file *migf, u32 npages,
+			 enum dma_data_direction dma_dir);
 void mlx5vf_free_data_buffer(struct mlx5_vhca_data_buffer *buf);
 struct mlx5_vhca_data_buffer *
-mlx5vf_get_data_buffer(struct mlx5_vf_migration_file *migf,
-		       size_t length, enum dma_data_direction dma_dir);
+mlx5vf_get_data_buffer(struct mlx5_vf_migration_file *migf, u32 npages,
+		       enum dma_data_direction dma_dir);
 void mlx5vf_put_data_buffer(struct mlx5_vhca_data_buffer *buf);
 struct page *mlx5vf_get_migration_page(struct mlx5_vhca_data_buffer *buf,
 				       unsigned long offset);
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 8833e60d42f5..83247f016441 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -308,6 +308,7 @@ static struct mlx5_vhca_data_buffer *
 mlx5vf_mig_file_get_stop_copy_buf(struct mlx5_vf_migration_file *migf,
 				  u8 index, size_t required_length)
 {
+	u32 npages = DIV_ROUND_UP(required_length, PAGE_SIZE);
 	struct mlx5_vhca_data_buffer *buf = migf->buf[index];
 	u8 chunk_num;
 
@@ -315,12 +316,11 @@ mlx5vf_mig_file_get_stop_copy_buf(struct mlx5_vf_migration_file *migf,
 	chunk_num = buf->stop_copy_chunk_num;
 	buf->migf->buf[index] = NULL;
 	/* Checking whether the pre-allocated buffer can fit */
-	if (buf->allocated_length >= required_length)
+	if (buf->npages >= npages)
 		return buf;
 
 	mlx5vf_put_data_buffer(buf);
-	buf = mlx5vf_get_data_buffer(buf->migf, required_length,
-				     DMA_FROM_DEVICE);
+	buf = mlx5vf_get_data_buffer(buf->migf, npages, DMA_FROM_DEVICE);
 	if (IS_ERR(buf))
 		return buf;
 
@@ -373,7 +373,8 @@ static int mlx5vf_add_stop_copy_header(struct mlx5_vf_migration_file *migf,
 	u8 *to_buff;
 	int ret;
 
-	header_buf = mlx5vf_get_data_buffer(migf, size, DMA_NONE);
+	header_buf = mlx5vf_get_data_buffer(migf, DIV_ROUND_UP(size, PAGE_SIZE),
+					    DMA_NONE);
 	if (IS_ERR(header_buf))
 		return PTR_ERR(header_buf);
 
@@ -388,7 +389,7 @@ static int mlx5vf_add_stop_copy_header(struct mlx5_vf_migration_file *migf,
 	to_buff = kmap_local_page(page);
 	memcpy(to_buff, &header, sizeof(header));
 	header_buf->length = sizeof(header);
-	data.stop_copy_size = cpu_to_le64(migf->buf[0]->allocated_length);
+	data.stop_copy_size = cpu_to_le64(migf->buf[0]->npages * PAGE_SIZE);
 	memcpy(to_buff + sizeof(header), &data, sizeof(data));
 	header_buf->length += sizeof(data);
 	kunmap_local(to_buff);
@@ -437,15 +438,20 @@ static int mlx5vf_prep_stop_copy(struct mlx5vf_pci_core_device *mvdev,
 
 	num_chunks = mvdev->chunk_mode ? MAX_NUM_CHUNKS : 1;
 	for (i = 0; i < num_chunks; i++) {
-		buf = mlx5vf_get_data_buffer(migf, inc_state_size, DMA_FROM_DEVICE);
+		buf = mlx5vf_get_data_buffer(
+			migf, DIV_ROUND_UP(inc_state_size, PAGE_SIZE),
+			DMA_FROM_DEVICE);
 		if (IS_ERR(buf)) {
 			ret = PTR_ERR(buf);
 			goto err;
 		}
 
 		migf->buf[i] = buf;
-		buf = mlx5vf_get_data_buffer(migf,
-				sizeof(struct mlx5_vf_migration_header), DMA_NONE);
+		buf = mlx5vf_get_data_buffer(
+			migf,
+			DIV_ROUND_UP(sizeof(struct mlx5_vf_migration_header),
+				     PAGE_SIZE),
+			DMA_NONE);
 		if (IS_ERR(buf)) {
 			ret = PTR_ERR(buf);
 			goto err;
@@ -553,7 +559,8 @@ static long mlx5vf_precopy_ioctl(struct file *filp, unsigned int cmd,
 	 * We finished transferring the current state and the device has a
 	 * dirty state, save a new state to be ready for.
 	 */
-	buf = mlx5vf_get_data_buffer(migf, inc_length, DMA_FROM_DEVICE);
+	buf = mlx5vf_get_data_buffer(migf, DIV_ROUND_UP(inc_length, PAGE_SIZE),
+				     DMA_FROM_DEVICE);
 	if (IS_ERR(buf)) {
 		ret = PTR_ERR(buf);
 		mlx5vf_mark_err(migf);
@@ -675,8 +682,8 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev, bool track)
 
 	if (track) {
 		/* leave the allocated buffer ready for the stop-copy phase */
-		buf = mlx5vf_alloc_data_buffer(migf,
-			migf->buf[0]->allocated_length, DMA_FROM_DEVICE);
+		buf = mlx5vf_alloc_data_buffer(migf, migf->buf[0]->npages,
+					       DMA_FROM_DEVICE);
 		if (IS_ERR(buf)) {
 			ret = PTR_ERR(buf);
 			goto out_pd;
@@ -917,11 +924,14 @@ static ssize_t mlx5vf_resume_write(struct file *filp, const char __user *buf,
 				goto out_unlock;
 			break;
 		case MLX5_VF_LOAD_STATE_PREP_HEADER_DATA:
-			if (vhca_buf_header->allocated_length < migf->record_size) {
+		{
+			u32 npages = DIV_ROUND_UP(migf->record_size, PAGE_SIZE);
+
+			if (vhca_buf_header->npages < npages) {
 				mlx5vf_free_data_buffer(vhca_buf_header);
 
-				migf->buf_header[0] = mlx5vf_alloc_data_buffer(migf,
-						migf->record_size, DMA_NONE);
+				migf->buf_header[0] = mlx5vf_alloc_data_buffer(
+					migf, npages, DMA_NONE);
 				if (IS_ERR(migf->buf_header[0])) {
 					ret = PTR_ERR(migf->buf_header[0]);
 					migf->buf_header[0] = NULL;
@@ -934,6 +944,7 @@ static ssize_t mlx5vf_resume_write(struct file *filp, const char __user *buf,
 			vhca_buf_header->start_pos = migf->max_pos;
 			migf->load_state = MLX5_VF_LOAD_STATE_READ_HEADER_DATA;
 			break;
+		}
 		case MLX5_VF_LOAD_STATE_READ_HEADER_DATA:
 			ret = mlx5vf_resume_read_header_data(migf, vhca_buf_header,
 							&buf, &len, pos, &done);
@@ -944,12 +955,13 @@ static ssize_t mlx5vf_resume_write(struct file *filp, const char __user *buf,
 		{
 			u64 size = max(migf->record_size,
 				       migf->stop_copy_prep_size);
+			u32 npages = DIV_ROUND_UP(size, PAGE_SIZE);
 
-			if (vhca_buf->allocated_length < size) {
+			if (vhca_buf->npages < npages) {
 				mlx5vf_free_data_buffer(vhca_buf);
 
-				migf->buf[0] = mlx5vf_alloc_data_buffer(migf,
-							size, DMA_TO_DEVICE);
+				migf->buf[0] = mlx5vf_alloc_data_buffer(
+					migf, npages, DMA_TO_DEVICE);
 				if (IS_ERR(migf->buf[0])) {
 					ret = PTR_ERR(migf->buf[0]);
 					migf->buf[0] = NULL;
@@ -1037,8 +1049,11 @@ mlx5vf_pci_resume_device_data(struct mlx5vf_pci_core_device *mvdev)
 	}
 
 	migf->buf[0] = buf;
-	buf = mlx5vf_alloc_data_buffer(migf,
-		sizeof(struct mlx5_vf_migration_header), DMA_NONE);
+	buf = mlx5vf_alloc_data_buffer(
+		migf,
+		DIV_ROUND_UP(sizeof(struct mlx5_vf_migration_header),
+			     PAGE_SIZE),
+		DMA_NONE);
 	if (IS_ERR(buf)) {
 		ret = PTR_ERR(buf);
 		goto out_buf;
@@ -1148,7 +1163,8 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
 					MLX5VF_QUERY_INC | MLX5VF_QUERY_CLEANUP);
 		if (ret)
 			return ERR_PTR(ret);
-		buf = mlx5vf_get_data_buffer(migf, size, DMA_FROM_DEVICE);
+		buf = mlx5vf_get_data_buffer(migf,
+				DIV_ROUND_UP(size, PAGE_SIZE), DMA_FROM_DEVICE);
 		if (IS_ERR(buf))
 			return ERR_CAST(buf);
 		/* pre_copy cleanup */
-- 
2.47.1


