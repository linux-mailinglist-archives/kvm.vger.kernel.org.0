Return-Path: <kvm+bounces-10913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A24F7871AE9
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 11:25:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1943AB2285A
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 10:25:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 623F360884;
	Tue,  5 Mar 2024 10:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L2QU2W8h"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B46B604DD;
	Tue,  5 Mar 2024 10:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709633779; cv=none; b=uSiHnTIJuy6D2CjwPrDq/Sfzhwl8D+orpVWu7Q5xKOcHwdad+3B+y4ovuw3FmByeKI12gFLBpFms3EGVHw9jXhuLvnMaQeysfksnlu5ndWhO79lt47lr8TEk3e5TayLKcqzO8jjqQkK3XJYhiUUS1qz5kC8Sv6Ad1ZGnlnXAYPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709633779; c=relaxed/simple;
	bh=utZ3KdFtdsQAESX2EpyzMrGiuaExMhARHy+JfNBKyD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gaa0E8D7Q52mHYennzZXIJn1CP28aEIxfqLxXhW2GZz18bcr4QMnUF190Jg78nye98YaqBELxHIvbL98V25PpQPAeprBPvPWwJo/G7Nrf2IFaqIgYNY1aSu77NsBn2460LVCh6qgAWLBUiJxSVAkSI1tZxv3bj0JJJ0m7h1aZNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L2QU2W8h; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AE5DC433C7;
	Tue,  5 Mar 2024 10:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709633779;
	bh=utZ3KdFtdsQAESX2EpyzMrGiuaExMhARHy+JfNBKyD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L2QU2W8hopktnjqtLh1dUA+1NmamN3jO2hagY+NwOntBW3lcniRVvhjZhygSySvOU
	 zmT1qrJchWcoqJ2R8mvRPMDLWCJ3zSLtuMGhw4NQgQMYE8T+IPVf6ITidiC1VwGRir
	 gtTb1oFKQVhxzVAOxoUh7eF6aVHsgij8QiaxeWlZYGmhQGHOcBXawhmIlI8lY89hFI
	 r3LrJVTUJ9WGUE1lZOaEerkHmLwDIG0ZpwWAZk8UiAYs18llZFSY7SCbVioinjMAVf
	 lBBpzlWMXaUIBxBZqwoyXLVY13am2lZaFJpc9bCZSCgoFvDIi5G4lUMLgNXKm0lxt6
	 HypLpEtFTk/XQ==
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
Subject: [RFC 11/16] vfio/mlx5: Explicitly use number of pages instead of allocated length
Date: Tue,  5 Mar 2024 12:15:21 +0200
Message-ID: <01606f62be051034035ef1501b7c721b8a319dcc.1709631413.git.leon@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <a77609c9c9a09214e38b04133e44eee67fe50ab0.1709631413.git.leon@kernel.org>
References: <a77609c9c9a09214e38b04133e44eee67fe50ab0.1709631413.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

allocated_length is a multiple of page size and number of pages, so let's
change the functions to accept number of pages. It opens us a venue to
combine receive and send paths together with code readability
improvement.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  | 31 ++++++++---------
 drivers/vfio/pci/mlx5/cmd.h  | 10 +++---
 drivers/vfio/pci/mlx5/main.c | 65 +++++++++++++++++++++++-------------
 3 files changed, 62 insertions(+), 44 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index efd1d252cdc9..45104e47b7b2 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -305,8 +305,7 @@ static int _create_mkey(struct mlx5_core_dev *mdev, u32 pdn,
 			struct mlx5_vhca_recv_buf *recv_buf,
 			u32 *mkey)
 {
-	size_t npages = buf ? DIV_ROUND_UP(buf->allocated_length, PAGE_SIZE) :
-				recv_buf->npages;
+	size_t npages = buf ? buf->npages : recv_buf->npages;
 	int err = 0, inlen;
 	__be64 *mtt;
 	void *mkc;
@@ -362,7 +361,7 @@ static int mlx5vf_dma_data_buffer(struct mlx5_vhca_data_buffer *buf)
 	if (mvdev->mdev_detach)
 		return -ENOTCONN;
 
-	if (buf->dmaed || !buf->allocated_length)
+	if (buf->dmaed || !buf->npages)
 		return -EINVAL;
 
 	ret = dma_map_sgtable(mdev->device, &buf->table.sgt, buf->dma_dir, 0);
@@ -403,8 +402,7 @@ void mlx5vf_free_data_buffer(struct mlx5_vhca_data_buffer *buf)
 }
 
 struct mlx5_vhca_data_buffer *
-mlx5vf_alloc_data_buffer(struct mlx5_vf_migration_file *migf,
-			 size_t length,
+mlx5vf_alloc_data_buffer(struct mlx5_vf_migration_file *migf, u32 npages,
 			 enum dma_data_direction dma_dir)
 {
 	struct mlx5_vhca_data_buffer *buf;
@@ -416,9 +414,8 @@ mlx5vf_alloc_data_buffer(struct mlx5_vf_migration_file *migf,
 
 	buf->dma_dir = dma_dir;
 	buf->migf = migf;
-	if (length) {
-		ret = mlx5vf_add_migration_pages(buf,
-				DIV_ROUND_UP_ULL(length, PAGE_SIZE));
+	if (npages) {
+		ret = mlx5vf_add_migration_pages(buf, npages);
 		if (ret)
 			goto end;
 
@@ -444,8 +441,8 @@ void mlx5vf_put_data_buffer(struct mlx5_vhca_data_buffer *buf)
 }
 
 struct mlx5_vhca_data_buffer *
-mlx5vf_get_data_buffer(struct mlx5_vf_migration_file *migf,
-		       size_t length, enum dma_data_direction dma_dir)
+mlx5vf_get_data_buffer(struct mlx5_vf_migration_file *migf, u32 npages,
+		       enum dma_data_direction dma_dir)
 {
 	struct mlx5_vhca_data_buffer *buf, *temp_buf;
 	struct list_head free_list;
@@ -460,7 +457,7 @@ mlx5vf_get_data_buffer(struct mlx5_vf_migration_file *migf,
 	list_for_each_entry_safe(buf, temp_buf, &migf->avail_list, buf_elm) {
 		if (buf->dma_dir == dma_dir) {
 			list_del_init(&buf->buf_elm);
-			if (buf->allocated_length >= length) {
+			if (buf->npages >= npages) {
 				spin_unlock_irq(&migf->list_lock);
 				goto found;
 			}
@@ -474,7 +471,7 @@ mlx5vf_get_data_buffer(struct mlx5_vf_migration_file *migf,
 		}
 	}
 	spin_unlock_irq(&migf->list_lock);
-	buf = mlx5vf_alloc_data_buffer(migf, length, dma_dir);
+	buf = mlx5vf_alloc_data_buffer(migf, npages, dma_dir);
 
 found:
 	while ((temp_buf = list_first_entry_or_null(&free_list,
@@ -645,7 +642,7 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	MLX5_SET(save_vhca_state_in, in, op_mod, 0);
 	MLX5_SET(save_vhca_state_in, in, vhca_id, mvdev->vhca_id);
 	MLX5_SET(save_vhca_state_in, in, mkey, buf->mkey);
-	MLX5_SET(save_vhca_state_in, in, size, buf->allocated_length);
+	MLX5_SET(save_vhca_state_in, in, size, buf->npages * PAGE_SIZE);
 	MLX5_SET(save_vhca_state_in, in, incremental, inc);
 	MLX5_SET(save_vhca_state_in, in, set_track, track);
 
@@ -668,8 +665,12 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 		}
 
 		if (!header_buf) {
-			header_buf = mlx5vf_get_data_buffer(migf,
-				sizeof(struct mlx5_vf_migration_header), DMA_NONE);
+			u32 npages = DIV_ROUND_UP(
+				sizeof(struct mlx5_vf_migration_header),
+				PAGE_SIZE);
+
+			header_buf =
+				mlx5vf_get_data_buffer(migf, npages, DMA_NONE);
 			if (IS_ERR(header_buf)) {
 				err = PTR_ERR(header_buf);
 				goto err_free;
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index f2c7227fa683..887267ebbd8a 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -60,7 +60,7 @@ struct mlx5_vhca_data_buffer {
 	struct sg_append_table table;
 	loff_t start_pos;
 	u64 length;
-	u64 allocated_length;
+	u32 npages;
 	u32 mkey;
 	enum dma_data_direction dma_dir;
 	u8 dmaed:1;
@@ -219,12 +219,12 @@ int mlx5vf_cmd_alloc_pd(struct mlx5_vf_migration_file *migf);
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
 int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
 			       unsigned int npages);
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index fe09a8c8af95..b11b1c27d284 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -94,7 +94,7 @@ int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
 
 		if (ret)
 			goto err;
-		buf->allocated_length += filled * PAGE_SIZE;
+		buf->npages += filled;
 		/* clean input for another bulk allocation */
 		memset(page_list, 0, filled * sizeof(*page_list));
 		to_fill = min_t(unsigned int, to_alloc,
@@ -352,6 +352,7 @@ static struct mlx5_vhca_data_buffer *
 mlx5vf_mig_file_get_stop_copy_buf(struct mlx5_vf_migration_file *migf,
 				  u8 index, size_t required_length)
 {
+	u32 npages = DIV_ROUND_UP(required_length, PAGE_SIZE);
 	struct mlx5_vhca_data_buffer *buf = migf->buf[index];
 	u8 chunk_num;
 
@@ -359,12 +360,11 @@ mlx5vf_mig_file_get_stop_copy_buf(struct mlx5_vf_migration_file *migf,
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
 
@@ -417,7 +417,9 @@ static int mlx5vf_add_stop_copy_header(struct mlx5_vf_migration_file *migf,
 	u8 *to_buff;
 	int ret;
 
-	header_buf = mlx5vf_get_data_buffer(migf, size, DMA_NONE);
+	BUILD_BUG_ON(size > PAGE_SIZE);
+	header_buf = mlx5vf_get_data_buffer(migf, DIV_ROUND_UP(size, PAGE_SIZE),
+					    DMA_NONE);
 	if (IS_ERR(header_buf))
 		return PTR_ERR(header_buf);
 
@@ -432,7 +434,7 @@ static int mlx5vf_add_stop_copy_header(struct mlx5_vf_migration_file *migf,
 	to_buff = kmap_local_page(page);
 	memcpy(to_buff, &header, sizeof(header));
 	header_buf->length = sizeof(header);
-	data.stop_copy_size = cpu_to_le64(migf->buf[0]->allocated_length);
+	data.stop_copy_size = cpu_to_le64(migf->buf[0]->npages * PAGE_SIZE);
 	memcpy(to_buff + sizeof(header), &data, sizeof(data));
 	header_buf->length += sizeof(data);
 	kunmap_local(to_buff);
@@ -481,15 +483,22 @@ static int mlx5vf_prep_stop_copy(struct mlx5vf_pci_core_device *mvdev,
 
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
 
+		BUILD_BUG_ON(sizeof(struct mlx5_vf_migration_header) >
+			     PAGE_SIZE);
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
@@ -597,7 +606,8 @@ static long mlx5vf_precopy_ioctl(struct file *filp, unsigned int cmd,
 	 * We finished transferring the current state and the device has a
 	 * dirty state, save a new state to be ready for.
 	 */
-	buf = mlx5vf_get_data_buffer(migf, inc_length, DMA_FROM_DEVICE);
+	buf = mlx5vf_get_data_buffer(migf, DIV_ROUND_UP(inc_length, PAGE_SIZE),
+				     DMA_FROM_DEVICE);
 	if (IS_ERR(buf)) {
 		ret = PTR_ERR(buf);
 		mlx5vf_mark_err(migf);
@@ -718,8 +728,8 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev, bool track)
 
 	if (track) {
 		/* leave the allocated buffer ready for the stop-copy phase */
-		buf = mlx5vf_alloc_data_buffer(migf,
-			migf->buf[0]->allocated_length, DMA_FROM_DEVICE);
+		buf = mlx5vf_alloc_data_buffer(migf, migf->buf[0]->npages,
+					       DMA_FROM_DEVICE);
 		if (IS_ERR(buf)) {
 			ret = PTR_ERR(buf);
 			goto out_pd;
@@ -783,16 +793,15 @@ mlx5vf_resume_read_image_no_header(struct mlx5_vhca_data_buffer *vhca_buf,
 				   const char __user **buf, size_t *len,
 				   loff_t *pos, ssize_t *done)
 {
+	u32 npages = DIV_ROUND_UP(requested_length, PAGE_SIZE);
 	int ret;
 
 	if (requested_length > MAX_LOAD_SIZE)
 		return -ENOMEM;
 
-	if (vhca_buf->allocated_length < requested_length) {
-		ret = mlx5vf_add_migration_pages(
-			vhca_buf,
-			DIV_ROUND_UP(requested_length - vhca_buf->allocated_length,
-				     PAGE_SIZE));
+	if (vhca_buf->npages < npages) {
+		ret = mlx5vf_add_migration_pages(vhca_buf,
+						 npages - vhca_buf->npages);
 		if (ret)
 			return ret;
 	}
@@ -992,11 +1001,14 @@ static ssize_t mlx5vf_resume_write(struct file *filp, const char __user *buf,
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
@@ -1009,6 +1021,7 @@ static ssize_t mlx5vf_resume_write(struct file *filp, const char __user *buf,
 			vhca_buf_header->start_pos = migf->max_pos;
 			migf->load_state = MLX5_VF_LOAD_STATE_READ_HEADER_DATA;
 			break;
+		}
 		case MLX5_VF_LOAD_STATE_READ_HEADER_DATA:
 			ret = mlx5vf_resume_read_header_data(migf, vhca_buf_header,
 							&buf, &len, pos, &done);
@@ -1019,12 +1032,13 @@ static ssize_t mlx5vf_resume_write(struct file *filp, const char __user *buf,
 		{
 			u64 size = max(migf->record_size,
 				       migf->stop_copy_prep_size);
+			u32 npages = DIV_ROUND_UP(size, PAGE_SIZE);
 
-			if (vhca_buf->allocated_length < size) {
+			if (vhca_buf->npages < npages) {
 				mlx5vf_free_data_buffer(vhca_buf);
 
 				migf->buf[0] = mlx5vf_alloc_data_buffer(migf,
-							size, DMA_TO_DEVICE);
+							npages, DMA_TO_DEVICE);
 				if (IS_ERR(migf->buf[0])) {
 					ret = PTR_ERR(migf->buf[0]);
 					migf->buf[0] = NULL;
@@ -1115,8 +1129,11 @@ mlx5vf_pci_resume_device_data(struct mlx5vf_pci_core_device *mvdev)
 
 	migf->buf[0] = buf;
 	if (MLX5VF_PRE_COPY_SUPP(mvdev)) {
-		buf = mlx5vf_alloc_data_buffer(migf,
-			sizeof(struct mlx5_vf_migration_header), DMA_NONE);
+		buf = mlx5vf_alloc_data_buffer(
+			migf,
+			DIV_ROUND_UP(sizeof(struct mlx5_vf_migration_header),
+				     PAGE_SIZE),
+			DMA_NONE);
 		if (IS_ERR(buf)) {
 			ret = PTR_ERR(buf);
 			goto out_buf;
-- 
2.44.0


