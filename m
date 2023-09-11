Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2D5179BEE6
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbjIKUuG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235829AbjIKJkU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 05:40:20 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2062.outbound.protection.outlook.com [40.107.237.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E02102
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 02:40:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jKE61Lq3bpd9TyaTHJIyq/DSfxR/A3kLBUPPSpZ7KkNp2vIRnmVfyMzivbzgk6cEWSkKEtzwfAba5BcWh13uSGX1zvdj9Teo8TPtdeWA8DpBXr5cOHXezlv7d3t2kZrqHpy7/WaKsw2qjW9YttupF5LV9pPB6AFdDtzkhE0jjMSS+p0/aAqGM3l++SijPPKaE8N+neJr8uMf/snoezXm42CsKSRA47JXB72EV61H6pGbhj2QQyREiR4qTVDSlbVhHMqPib9EiRlecprcUclFcrr0huVw9QxgmExTMN1mVbyaflHC7gHHaKmKyWMURFgRLWAv/bgf7jP+iozDwI7x1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GHmBGCOrP0Z6j63WBatUtf0CFalKuo6l8602/I+nNow=;
 b=NIRLl0XgykgjH9th3/2FAifEqlIYm1R/dSqLBHFVkjzvG+oUvPeAzrxdQQAcaHRR8UGvSRAyeoyiMGg8ub1jNxMm+GRwYV7Zn6Il3szc+5n/a4I0d1Jl1Q1LnkKF6n0KKmc0y80wXFBh0IZ9FlwtpVIG/b/qXOKhqVRt/cx2TzsvkuJPdTsujVKVqga2x10PTMWGtd/UDQ/iqhpvMCcMlByIiMKCY3i9PbZxSCYDkBv87yzU7bWLg1krTZexKeRiMiRu0kzjnKmmmZy2Sf7OFlXdtFSydtpflMBd/YCco+KZQASBSzDd6Z/DbIRjUCwN56zoMG3upLs7mUxWDkYeHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GHmBGCOrP0Z6j63WBatUtf0CFalKuo6l8602/I+nNow=;
 b=bnbn0lSn99247NvqvWq4Iip99v7qmIAMdmyiretEIdkXRiXUE1jz8zq5hAxPCXECw0R3L4WXTUBafAzgI3cGosxeBZRTuBtWo7kcO2P5ONI7Fu6m9MfI5Jz645w3EFRikb4JRAT4UizGClLwiCsv5dHW5o+zT3VfPUNIi+OMM/SGr4VLXFUE470XHrlLeRsrGK8cYtiBL6TXUtRl8S7gjzCiA+Qjuruu6mZ+Gxnxkk5oyIZUqKSS4MAhohhP3NaSvdpxLiodDgSNGTddsgOXx1C+8kibdNWyYdTLpNseLIMBYb22brPTbEqGNzlnyeipx3lsQFJmzLwcw2d2KUG48Q==
Received: from BL1PR13CA0227.namprd13.prod.outlook.com (2603:10b6:208:2bf::22)
 by SJ1PR12MB6289.namprd12.prod.outlook.com (2603:10b6:a03:458::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.35; Mon, 11 Sep
 2023 09:40:11 +0000
Received: from BL6PEPF0001AB55.namprd02.prod.outlook.com
 (2603:10b6:208:2bf:cafe::69) by BL1PR13CA0227.outlook.office365.com
 (2603:10b6:208:2bf::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.16 via Frontend
 Transport; Mon, 11 Sep 2023 09:40:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF0001AB55.mail.protection.outlook.com (10.167.241.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.16 via Frontend Transport; Mon, 11 Sep 2023 09:40:10 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 11 Sep 2023
 02:40:01 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 11 Sep
 2023 02:40:00 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Mon, 11 Sep
 2023 02:39:58 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH vfio 7/9] vfio/mlx5: Add support for SAVING in chunk mode
Date:   Mon, 11 Sep 2023 12:38:54 +0300
Message-ID: <20230911093856.81910-8-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20230911093856.81910-1-yishaih@nvidia.com>
References: <20230911093856.81910-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB55:EE_|SJ1PR12MB6289:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f481544-5740-41c2-4fbe-08dbb2ab17c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HHPGOq8yOLNtdTxtgbiNAOjP5m8y0lypkjfbElqPzOVqSx1d6PE94cg9JEEBs2LFAgo/ILDd/BamGpLGogHB1R7E4p3y3IP+/5UysVazoGkOJzEm/dxmD/w6Mz9ayspJLeCBxg9asBdUXbV4P2fTzxL4jiGbHHt3BBcGxTNe1dSWbQx4wefAZ05nQ9y8bT8O1acrF9HpRVlccjStA4Sd+4lk8DJupBCA+3zYVkWMbyv4MeyhOopjlwl+MXJRnBGW/FGGMrmAVkM6Vv+uH1DEeZnQA268K2geSIVVhD39Rsv7n/bAGQXQF+22cO62TCKYqA08sMWU/LxMYrLPgNhHldw93FB1UY8nM/Tqk4lNBiLv3oaXfIx51CtFXI37SS1hmtNXLVFDJwCIt2M+92dOH81tOVVm64Umy5uiwGzzPj/0m2ZNgr3/eWJR8FQAwOILjSHkiAYqcpW7mAizXwC5K6+HKF3tMMvAzGQauLZO/yg1YN3oZS9rfMNlQSWjd+TkObmX3Pj7g4PQHayHmZLsfX6A3HapCvPLHieDjAJQAn7FFpGLOu8it4a7XwPxIo0XDBaGXVXCMuSZGhngJZkr/iVoO9SN9VqNWyhkJJp6GCcD7t+Ri8R99Q68DsBCXQw2jsWFYDr3eQlxxF61MTjFJc49txVkJ7ZihSsN7Kww6EANKhG01Utss+R0yQAfw69xH689abgcf57ILlYo/ynxVJbWgD2OjbjOA3qRqC0b26RH3yHYmgEnXU35o4t36dsT
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(346002)(396003)(39860400002)(136003)(1800799009)(451199024)(82310400011)(186009)(40470700004)(46966006)(36840700001)(5660300002)(54906003)(41300700001)(4326008)(8676002)(8936002)(6636002)(70206006)(316002)(110136005)(70586007)(40460700003)(47076005)(478600001)(36756003)(40480700001)(7696005)(6666004)(2616005)(26005)(107886003)(1076003)(2906002)(336012)(426003)(86362001)(83380400001)(82740400003)(356005)(7636003)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2023 09:40:10.9180
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f481544-5740-41c2-4fbe-08dbb2ab17c8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL6PEPF0001AB55.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6289
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support for SAVING in chunk mode, it includes running a work
that will fill the next chunk from the device.

In case the number of available chunks will reach the MAX_NUM_CHUNKS,
the next chunk SAVING will be delayed till the reader will consume one
chunk.

The next patch from the series will add the reader part of the chunk
mode.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  | 43 +++++++++++++++---
 drivers/vfio/pci/mlx5/cmd.h  | 12 ++++++
 drivers/vfio/pci/mlx5/main.c | 84 +++++++++++++++++++++++++++++++-----
 3 files changed, 122 insertions(+), 17 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index b18735ee5d07..e68bf9ba5300 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -435,6 +435,7 @@ mlx5vf_alloc_data_buffer(struct mlx5_vf_migration_file *migf,
 void mlx5vf_put_data_buffer(struct mlx5_vhca_data_buffer *buf)
 {
 	spin_lock_irq(&buf->migf->list_lock);
+	buf->stop_copy_chunk_num = 0;
 	list_add_tail(&buf->buf_elm, &buf->migf->avail_list);
 	spin_unlock_irq(&buf->migf->list_lock);
 }
@@ -551,6 +552,8 @@ static void mlx5vf_save_callback(int status, struct mlx5_async_work *context)
 			struct mlx5_vf_migration_file, async_data);
 
 	if (!status) {
+		size_t next_required_umem_size = 0;
+		bool stop_copy_last_chunk;
 		size_t image_size;
 		unsigned long flags;
 		bool initial_pre_copy = migf->state != MLX5_MIGF_STATE_PRE_COPY &&
@@ -558,6 +561,11 @@ static void mlx5vf_save_callback(int status, struct mlx5_async_work *context)
 
 		image_size = MLX5_GET(save_vhca_state_out, async_data->out,
 				      actual_image_size);
+		if (async_data->buf->stop_copy_chunk_num)
+			next_required_umem_size = MLX5_GET(save_vhca_state_out,
+					async_data->out, next_required_umem_size);
+		stop_copy_last_chunk = async_data->stop_copy_chunk &&
+				!next_required_umem_size;
 		if (async_data->header_buf) {
 			status = add_buf_header(async_data->header_buf, image_size,
 						initial_pre_copy);
@@ -569,12 +577,28 @@ static void mlx5vf_save_callback(int status, struct mlx5_async_work *context)
 		migf->max_pos += async_data->buf->length;
 		spin_lock_irqsave(&migf->list_lock, flags);
 		list_add_tail(&async_data->buf->buf_elm, &migf->buf_list);
+		if (async_data->buf->stop_copy_chunk_num) {
+			migf->num_ready_chunks++;
+			if (next_required_umem_size &&
+			    migf->num_ready_chunks >= MAX_NUM_CHUNKS) {
+				/* Delay the next SAVE till one chunk be consumed */
+				migf->next_required_umem_size = next_required_umem_size;
+				next_required_umem_size = 0;
+			}
+		}
 		spin_unlock_irqrestore(&migf->list_lock, flags);
-		if (initial_pre_copy)
+		if (initial_pre_copy) {
 			migf->pre_copy_initial_bytes += image_size;
-		migf->state = async_data->stop_copy_chunk ?
-			MLX5_MIGF_STATE_COMPLETE : MLX5_MIGF_STATE_PRE_COPY;
+			migf->state = MLX5_MIGF_STATE_PRE_COPY;
+		}
+		if (stop_copy_last_chunk)
+			migf->state = MLX5_MIGF_STATE_COMPLETE;
 		wake_up_interruptible(&migf->poll_wait);
+		if (next_required_umem_size)
+			mlx5vf_mig_file_set_save_work(migf,
+				/* Picking up the next chunk num */
+				(async_data->buf->stop_copy_chunk_num % MAX_NUM_CHUNKS) + 1,
+				next_required_umem_size);
 		mlx5vf_save_callback_complete(migf, async_data);
 		return;
 	}
@@ -632,10 +656,15 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	}
 
 	if (MLX5VF_PRE_COPY_SUPP(mvdev)) {
-		if (async_data->stop_copy_chunk && migf->buf_header[0]) {
-			header_buf = migf->buf_header[0];
-			migf->buf_header[0] = NULL;
-		} else {
+		if (async_data->stop_copy_chunk) {
+			u8 header_idx = buf->stop_copy_chunk_num ?
+				buf->stop_copy_chunk_num - 1 : 0;
+
+			header_buf = migf->buf_header[header_idx];
+			migf->buf_header[header_idx] = NULL;
+		}
+
+		if (!header_buf) {
 			header_buf = mlx5vf_get_data_buffer(migf,
 				sizeof(struct mlx5_vf_migration_header), DMA_NONE);
 			if (IS_ERR(header_buf)) {
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index 6d8d52804c83..f2c7227fa683 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -83,6 +83,13 @@ struct mlx5vf_async_data {
 	void *out;
 };
 
+struct mlx5vf_save_work_data {
+	struct mlx5_vf_migration_file *migf;
+	size_t next_required_umem_size;
+	struct work_struct work;
+	u8 chunk_num;
+};
+
 #define MAX_NUM_CHUNKS 2
 
 struct mlx5_vf_migration_file {
@@ -97,9 +104,12 @@ struct mlx5_vf_migration_file {
 	u32 record_tag;
 	u64 stop_copy_prep_size;
 	u64 pre_copy_initial_bytes;
+	size_t next_required_umem_size;
+	u8 num_ready_chunks;
 	/* Upon chunk mode preserve another set of buffers for stop_copy phase */
 	struct mlx5_vhca_data_buffer *buf[MAX_NUM_CHUNKS];
 	struct mlx5_vhca_data_buffer *buf_header[MAX_NUM_CHUNKS];
+	struct mlx5vf_save_work_data save_data[MAX_NUM_CHUNKS];
 	spinlock_t list_lock;
 	struct list_head buf_list;
 	struct list_head avail_list;
@@ -223,6 +233,8 @@ struct page *mlx5vf_get_migration_page(struct mlx5_vhca_data_buffer *buf,
 void mlx5vf_state_mutex_unlock(struct mlx5vf_pci_core_device *mvdev);
 void mlx5vf_disable_fds(struct mlx5vf_pci_core_device *mvdev);
 void mlx5vf_mig_file_cleanup_cb(struct work_struct *_work);
+void mlx5vf_mig_file_set_save_work(struct mlx5_vf_migration_file *migf,
+				   u8 chunk_num, size_t next_required_umem_size);
 int mlx5vf_start_page_tracker(struct vfio_device *vdev,
 		struct rb_root_cached *ranges, u32 nnodes, u64 *page_size);
 int mlx5vf_stop_page_tracker(struct vfio_device *vdev);
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 351b61303b72..c80caf55499f 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -306,6 +306,73 @@ static void mlx5vf_mark_err(struct mlx5_vf_migration_file *migf)
 	wake_up_interruptible(&migf->poll_wait);
 }
 
+void mlx5vf_mig_file_set_save_work(struct mlx5_vf_migration_file *migf,
+				   u8 chunk_num, size_t next_required_umem_size)
+{
+	migf->save_data[chunk_num - 1].next_required_umem_size =
+			next_required_umem_size;
+	migf->save_data[chunk_num - 1].migf = migf;
+	get_file(migf->filp);
+	queue_work(migf->mvdev->cb_wq,
+		   &migf->save_data[chunk_num - 1].work);
+}
+
+static struct mlx5_vhca_data_buffer *
+mlx5vf_mig_file_get_stop_copy_buf(struct mlx5_vf_migration_file *migf,
+				  u8 index, size_t required_length)
+{
+	struct mlx5_vhca_data_buffer *buf = migf->buf[index];
+	u8 chunk_num;
+
+	WARN_ON(!buf);
+	chunk_num = buf->stop_copy_chunk_num;
+	buf->migf->buf[index] = NULL;
+	/* Checking whether the pre-allocated buffer can fit */
+	if (buf->allocated_length >= required_length)
+		return buf;
+
+	mlx5vf_put_data_buffer(buf);
+	buf = mlx5vf_get_data_buffer(buf->migf, required_length,
+				     DMA_FROM_DEVICE);
+	if (IS_ERR(buf))
+		return buf;
+
+	buf->stop_copy_chunk_num = chunk_num;
+	return buf;
+}
+
+static void mlx5vf_mig_file_save_work(struct work_struct *_work)
+{
+	struct mlx5vf_save_work_data *save_data = container_of(_work,
+		struct mlx5vf_save_work_data, work);
+	struct mlx5_vf_migration_file *migf = save_data->migf;
+	struct mlx5vf_pci_core_device *mvdev = migf->mvdev;
+	struct mlx5_vhca_data_buffer *buf;
+
+	mutex_lock(&mvdev->state_mutex);
+	if (migf->state == MLX5_MIGF_STATE_ERROR)
+		goto end;
+
+	buf = mlx5vf_mig_file_get_stop_copy_buf(migf,
+				save_data->chunk_num - 1,
+				save_data->next_required_umem_size);
+	if (IS_ERR(buf))
+		goto err;
+
+	if (mlx5vf_cmd_save_vhca_state(mvdev, migf, buf, true, false))
+		goto err_save;
+
+	goto end;
+
+err_save:
+	mlx5vf_put_data_buffer(buf);
+err:
+	mlx5vf_mark_err(migf);
+end:
+	mlx5vf_state_mutex_unlock(mvdev);
+	fput(migf->filp);
+}
+
 static int mlx5vf_add_stop_copy_header(struct mlx5_vf_migration_file *migf,
 				       bool track)
 {
@@ -400,6 +467,9 @@ static int mlx5vf_prep_stop_copy(struct mlx5vf_pci_core_device *mvdev,
 		if (mvdev->chunk_mode) {
 			migf->buf[i]->stop_copy_chunk_num = i + 1;
 			migf->buf_header[i]->stop_copy_chunk_num = i + 1;
+			INIT_WORK(&migf->save_data[i].work,
+				  mlx5vf_mig_file_save_work);
+			migf->save_data[i].chunk_num = i + 1;
 		}
 	}
 
@@ -548,16 +618,10 @@ static int mlx5vf_pci_save_device_inc_data(struct mlx5vf_pci_core_device *mvdev)
 	if (ret)
 		goto err;
 
-	/* Checking whether we have a matching pre-allocated buffer that can fit */
-	if (migf->buf[0]->allocated_length >= length) {
-		buf = migf->buf[0];
-		migf->buf[0] = NULL;
-	} else {
-		buf = mlx5vf_get_data_buffer(migf, length, DMA_FROM_DEVICE);
-		if (IS_ERR(buf)) {
-			ret = PTR_ERR(buf);
-			goto err;
-		}
+	buf = mlx5vf_mig_file_get_stop_copy_buf(migf, 0, length);
+	if (IS_ERR(buf)) {
+		ret = PTR_ERR(buf);
+		goto err;
 	}
 
 	ret = mlx5vf_cmd_save_vhca_state(mvdev, migf, buf, true, false);
-- 
2.18.1

