Return-Path: <kvm+bounces-11123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC958873522
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 11:57:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9365C28AF74
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 10:57:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2421E74297;
	Wed,  6 Mar 2024 10:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tkAMeNwU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2062.outbound.protection.outlook.com [40.107.237.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E91F60DD3
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 10:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709722630; cv=fail; b=AMitw1gE7wl19ueXI1Q1MORuzM6SVw0hpPh+YkHcQ1sO0AXqicnkQrW+9sBw58XHZbW64kZK7QOo6f79W1c+BVa2v+NNz0sspb4YxBd7ehCCJpnb/WwGMaaUjXKCiruvbADZRRT3aECd261hw6p46IqRl4v9hxITbEBg8b7eo+Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709722630; c=relaxed/simple;
	bh=fycHg5nuYH9uq/PZraQWyglQUP0kJyiKZjugrl/wH9M=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=R7l74lpMt4YVVa2rAq//vEcxLSPzhdCNO4Ont9r9/lECHjcb+/8Xbb+3lqQasngis9vn9fGWSrZ5N09Oi9tbNMcFeniVoPRe24DFtLS9e45gvUPdQLPJMAgea/9dtmKMJSmI8jVNA5SpGHkW5fOj2sbjzqF2KFwrK5yzERgO6Qc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tkAMeNwU; arc=fail smtp.client-ip=40.107.237.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ml+QuFM5GTffJdVJ9yGfd8XUsAhQiXY+qsO5Hgfz8V7X0rbQB8fNpd5kYbhDutEgHB9xf0woXhppOZxJB826co5f6EZC1DUJephjgfMRYGDG6W9oQh6/0jUQssfUb1hlQGu9NGCbcBzMYC0tpV31hcomQsJzB3oABN1R5QdG7MulpL/TOAiOuy/+eCL/1/C634XGloa4ODgzdeYC1Volevmcpbq+rOfMWlcPGC18fQ1FUZrnO12kplHLsKAwt/38MB+PnkMSjRocEvkVkDJLzhMs1TkiXB96LbQCHsZfHa7jmXx6i7eJOTupy2I0zZNQMvH6udBH8FYm/EDR3NMxcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GBcF6kG8O1jk2x/c6O5rClk1F4OVbNL8t5AYe9slkUo=;
 b=aebhXWBCAft8QqkBjQUEj+KkMXRmlDl7Q9nzkUPsrCC0lj/pQE0rR/JwOO2fAeJu1Xqf3BMZ7QG5YA4Z1HxlSwm6gMVG4BRccxDelU++RkpHDr96u9qyhj8RO5obpdHhXPFdFYLD9/h8WG63ZsyYj6x3YxdFF8EQgqncbZ8bj1nliuLrjRc05QXy6USt3LUVC4slYyUgN0/thgMFe7SftuRUTtuqiKpO0T18OAh1sTGv2qAaZfEAPxsKvs2lQGT2nCe9eb9WAmiAL/xNmTGPle7wXyOoiTVanqq9JVHPP/tLzxcv9qOiR9qmyIJFu8NWq1t7MZw5k/5u11avHH7NOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GBcF6kG8O1jk2x/c6O5rClk1F4OVbNL8t5AYe9slkUo=;
 b=tkAMeNwU4ZBstlhrKslWg7Pg0lKm0Jj2wyXnJtxVV7oQ6Y2dO3Km+8JPhM+AIR+XYlBsdqOIdn2TPwngbSN1MlJ2BmgncjHsTxugXz4YCgKsaV2kRh57tSuPz1qKu9om1nXkEMdcOJ7eNczGPRoKRPI27guLbetOo4g0vQX57AIzdwGltxE2LZuBQpjayjzYxZgdGyqR0cn7ZHG+AV1KBbfH7ihI7SSjW+INsOPsIFOhaOQLKH7xB1b06iEMOqj3tUXIrRaz5/6MxCasS7C+VkCpHe/Sg9IoEmGw9ha4O4e+QW5Yqqij+ebiThJ8r0hSMq1S1lX0NeXLk4BI1DoQZQ==
Received: from SA0PR12CA0013.namprd12.prod.outlook.com (2603:10b6:806:6f::18)
 by IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.36; Wed, 6 Mar
 2024 10:57:05 +0000
Received: from SN1PEPF000252A0.namprd05.prod.outlook.com
 (2603:10b6:806:6f:cafe::e1) by SA0PR12CA0013.outlook.office365.com
 (2603:10b6:806:6f::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.24 via Frontend
 Transport; Wed, 6 Mar 2024 10:57:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF000252A0.mail.protection.outlook.com (10.167.242.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7362.11 via Frontend Transport; Wed, 6 Mar 2024 10:57:04 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 6 Mar 2024
 02:56:39 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Wed, 6 Mar
 2024 02:56:39 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.1258.12 via Frontend Transport; Wed, 6 Mar
 2024 02:56:36 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH V1 vfio] vfio/mlx5: Enforce PRE_COPY support
Date: Wed, 6 Mar 2024 12:56:24 +0200
Message-ID: <20240306105624.114830-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A0:EE_|IA0PR12MB8374:EE_
X-MS-Office365-Filtering-Correlation-Id: 895df82b-dc6d-49ab-88e6-08dc3dcc28d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	AV5tL1drPa8eBDbqKxVFti8vhgOMRqQweyoeRk5OyHsAh3kuFRQ4yqiMNu+L59QDUXjeDY7+HEzrqLZlhc3JSpYqO7/tzQapi3g6u8mkG6tqUfnOh6vgx//BDlGBzsUBePaY5fxIEZiNBwZi4xkJT3GHnOnberT9MSVZ5Ot11LVR2eglX5KcvvDUBhYWjWbsTBLjK0hXfHY/v9OI6Nnw/AHMEESxNsyoJdqJahd4W6rclWrTl4cMG6Xra59aDtWeCvVfldQsnDlWwGi/ifL8y+cZawN3ACbWzr6j4Cjs0luJitw0f3j9C4vPZ2VnIET0VmpJuGrzWatnBv5zRpIgmNi/0zMbwxz5rhAD0YV12jTp/8BB7CMVMLLe3lX9dqTIxlKKk/7osxM4SpwomFx7XD8sdc7qC0GOgDuIAak3zziw2S18TmOMFeXUGAVWzBPmBAQtjvhGZKEeN7IDdbAoI8hALs4zo5jy3yn/l99hfJiLJwxHP0IFplT2a6LOGP36KSyHlZc6IlyYlwDmwQLzPAwbXyHg3Yd6Kc/0erliwEDRCJaJMXfHBbwB78S/ebV7Wn0EjpI52U99Lh9sxG/HlB1KAevmcdGCiYlQyoW9iJxiSiMuBc7nB//1q1gs6QoZ9v86+KClZRiaeIQJa+yXcJhUhzJkQnIlcuR+2gaWoVhprtEmyMdup4cpnkcjN2JexAvCX4I0yzx8SzOfSzoiGXwa3HldYbRWnXUWFzyWzSD4GC4P492d5mxhNitUb9BB
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(376005)(36860700004)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2024 10:57:04.6067
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 895df82b-dc6d-49ab-88e6-08dc3dcc28d5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000252A0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8374

Enable live migration only once the firmware supports PRE_COPY.

PRE_COPY has been supported by the firmware for a long time already [1]
and is required to achieve a low downtime upon live migration.

This lets us clean up some old code that is not applicable those days
while PRE_COPY is fully supported by the firmware.

[1] The minimum firmware version that supports PRE_COPY is 28.36.1010,
it was released on January 23.

No firmware without PRE_COPY support ever available to users.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  |  83 +++++++++++++++++++-------
 drivers/vfio/pci/mlx5/cmd.h  |   6 --
 drivers/vfio/pci/mlx5/main.c | 109 +++--------------------------------
 3 files changed, 71 insertions(+), 127 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index c54bcd5d0917..41a4b0cf4297 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -233,6 +233,10 @@ void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev,
 	if (!MLX5_CAP_GEN(mvdev->mdev, migration))
 		goto end;
 
+	if (!(MLX5_CAP_GEN_2(mvdev->mdev, migration_multi_load) &&
+	      MLX5_CAP_GEN_2(mvdev->mdev, migration_tracking_state)))
+		goto end;
+
 	mvdev->vf_id = pci_iov_vf_id(pdev);
 	if (mvdev->vf_id < 0)
 		goto end;
@@ -262,17 +266,14 @@ void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev,
 	mvdev->migrate_cap = 1;
 	mvdev->core_device.vdev.migration_flags =
 		VFIO_MIGRATION_STOP_COPY |
-		VFIO_MIGRATION_P2P;
+		VFIO_MIGRATION_P2P |
+		VFIO_MIGRATION_PRE_COPY;
+
 	mvdev->core_device.vdev.mig_ops = mig_ops;
 	init_completion(&mvdev->tracker_comp);
 	if (MLX5_CAP_GEN(mvdev->mdev, adv_virtualization))
 		mvdev->core_device.vdev.log_ops = log_ops;
 
-	if (MLX5_CAP_GEN_2(mvdev->mdev, migration_multi_load) &&
-	    MLX5_CAP_GEN_2(mvdev->mdev, migration_tracking_state))
-		mvdev->core_device.vdev.migration_flags |=
-			VFIO_MIGRATION_PRE_COPY;
-
 	if (MLX5_CAP_GEN_2(mvdev->mdev, migration_in_chunks))
 		mvdev->chunk_mode = 1;
 
@@ -414,6 +415,50 @@ void mlx5vf_free_data_buffer(struct mlx5_vhca_data_buffer *buf)
 	kfree(buf);
 }
 
+static int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
+				      unsigned int npages)
+{
+	unsigned int to_alloc = npages;
+	struct page **page_list;
+	unsigned long filled;
+	unsigned int to_fill;
+	int ret;
+
+	to_fill = min_t(unsigned int, npages, PAGE_SIZE / sizeof(*page_list));
+	page_list = kvzalloc(to_fill * sizeof(*page_list), GFP_KERNEL_ACCOUNT);
+	if (!page_list)
+		return -ENOMEM;
+
+	do {
+		filled = alloc_pages_bulk_array(GFP_KERNEL_ACCOUNT, to_fill,
+						page_list);
+		if (!filled) {
+			ret = -ENOMEM;
+			goto err;
+		}
+		to_alloc -= filled;
+		ret = sg_alloc_append_table_from_pages(
+			&buf->table, page_list, filled, 0,
+			filled << PAGE_SHIFT, UINT_MAX, SG_MAX_SINGLE_ALLOC,
+			GFP_KERNEL_ACCOUNT);
+
+		if (ret)
+			goto err;
+		buf->allocated_length += filled * PAGE_SIZE;
+		/* clean input for another bulk allocation */
+		memset(page_list, 0, filled * sizeof(*page_list));
+		to_fill = min_t(unsigned int, to_alloc,
+				PAGE_SIZE / sizeof(*page_list));
+	} while (to_alloc > 0);
+
+	kvfree(page_list);
+	return 0;
+
+err:
+	kvfree(page_list);
+	return ret;
+}
+
 struct mlx5_vhca_data_buffer *
 mlx5vf_alloc_data_buffer(struct mlx5_vf_migration_file *migf,
 			 size_t length,
@@ -680,22 +725,20 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 		goto err_out;
 	}
 
-	if (MLX5VF_PRE_COPY_SUPP(mvdev)) {
-		if (async_data->stop_copy_chunk) {
-			u8 header_idx = buf->stop_copy_chunk_num ?
-				buf->stop_copy_chunk_num - 1 : 0;
+	if (async_data->stop_copy_chunk) {
+		u8 header_idx = buf->stop_copy_chunk_num ?
+			buf->stop_copy_chunk_num - 1 : 0;
 
-			header_buf = migf->buf_header[header_idx];
-			migf->buf_header[header_idx] = NULL;
-		}
+		header_buf = migf->buf_header[header_idx];
+		migf->buf_header[header_idx] = NULL;
+	}
 
-		if (!header_buf) {
-			header_buf = mlx5vf_get_data_buffer(migf,
-				sizeof(struct mlx5_vf_migration_header), DMA_NONE);
-			if (IS_ERR(header_buf)) {
-				err = PTR_ERR(header_buf);
-				goto err_free;
-			}
+	if (!header_buf) {
+		header_buf = mlx5vf_get_data_buffer(migf,
+			sizeof(struct mlx5_vf_migration_header), DMA_NONE);
+		if (IS_ERR(header_buf)) {
+			err = PTR_ERR(header_buf);
+			goto err_free;
 		}
 	}
 
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index 707393df36c4..df421dc6de04 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -13,9 +13,6 @@
 #include <linux/mlx5/cq.h>
 #include <linux/mlx5/qp.h>
 
-#define MLX5VF_PRE_COPY_SUPP(mvdev) \
-	((mvdev)->core_device.vdev.migration_flags & VFIO_MIGRATION_PRE_COPY)
-
 enum mlx5_vf_migf_state {
 	MLX5_MIGF_STATE_ERROR = 1,
 	MLX5_MIGF_STATE_PRE_COPY_ERROR,
@@ -25,7 +22,6 @@ enum mlx5_vf_migf_state {
 };
 
 enum mlx5_vf_load_state {
-	MLX5_VF_LOAD_STATE_READ_IMAGE_NO_HEADER,
 	MLX5_VF_LOAD_STATE_READ_HEADER,
 	MLX5_VF_LOAD_STATE_PREP_HEADER_DATA,
 	MLX5_VF_LOAD_STATE_READ_HEADER_DATA,
@@ -228,8 +224,6 @@ struct mlx5_vhca_data_buffer *
 mlx5vf_get_data_buffer(struct mlx5_vf_migration_file *migf,
 		       size_t length, enum dma_data_direction dma_dir);
 void mlx5vf_put_data_buffer(struct mlx5_vhca_data_buffer *buf);
-int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
-			       unsigned int npages);
 struct page *mlx5vf_get_migration_page(struct mlx5_vhca_data_buffer *buf,
 				       unsigned long offset);
 void mlx5vf_state_mutex_unlock(struct mlx5vf_pci_core_device *mvdev);
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 3982fcf60cf2..61d9b0f9146d 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -65,50 +65,6 @@ mlx5vf_get_migration_page(struct mlx5_vhca_data_buffer *buf,
 	return NULL;
 }
 
-int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
-			       unsigned int npages)
-{
-	unsigned int to_alloc = npages;
-	struct page **page_list;
-	unsigned long filled;
-	unsigned int to_fill;
-	int ret;
-
-	to_fill = min_t(unsigned int, npages, PAGE_SIZE / sizeof(*page_list));
-	page_list = kvzalloc(to_fill * sizeof(*page_list), GFP_KERNEL_ACCOUNT);
-	if (!page_list)
-		return -ENOMEM;
-
-	do {
-		filled = alloc_pages_bulk_array(GFP_KERNEL_ACCOUNT, to_fill,
-						page_list);
-		if (!filled) {
-			ret = -ENOMEM;
-			goto err;
-		}
-		to_alloc -= filled;
-		ret = sg_alloc_append_table_from_pages(
-			&buf->table, page_list, filled, 0,
-			filled << PAGE_SHIFT, UINT_MAX, SG_MAX_SINGLE_ALLOC,
-			GFP_KERNEL_ACCOUNT);
-
-		if (ret)
-			goto err;
-		buf->allocated_length += filled * PAGE_SIZE;
-		/* clean input for another bulk allocation */
-		memset(page_list, 0, filled * sizeof(*page_list));
-		to_fill = min_t(unsigned int, to_alloc,
-				PAGE_SIZE / sizeof(*page_list));
-	} while (to_alloc > 0);
-
-	kvfree(page_list);
-	return 0;
-
-err:
-	kvfree(page_list);
-	return ret;
-}
-
 static void mlx5vf_disable_fd(struct mlx5_vf_migration_file *migf)
 {
 	mutex_lock(&migf->lock);
@@ -777,36 +733,6 @@ mlx5vf_append_page_to_mig_buf(struct mlx5_vhca_data_buffer *vhca_buf,
 	return 0;
 }
 
-static int
-mlx5vf_resume_read_image_no_header(struct mlx5_vhca_data_buffer *vhca_buf,
-				   loff_t requested_length,
-				   const char __user **buf, size_t *len,
-				   loff_t *pos, ssize_t *done)
-{
-	int ret;
-
-	if (requested_length > MAX_LOAD_SIZE)
-		return -ENOMEM;
-
-	if (vhca_buf->allocated_length < requested_length) {
-		ret = mlx5vf_add_migration_pages(
-			vhca_buf,
-			DIV_ROUND_UP(requested_length - vhca_buf->allocated_length,
-				     PAGE_SIZE));
-		if (ret)
-			return ret;
-	}
-
-	while (*len) {
-		ret = mlx5vf_append_page_to_mig_buf(vhca_buf, buf, len, pos,
-						    done);
-		if (ret)
-			return ret;
-	}
-
-	return 0;
-}
-
 static ssize_t
 mlx5vf_resume_read_image(struct mlx5_vf_migration_file *migf,
 			 struct mlx5_vhca_data_buffer *vhca_buf,
@@ -1038,13 +964,6 @@ static ssize_t mlx5vf_resume_write(struct file *filp, const char __user *buf,
 			migf->load_state = MLX5_VF_LOAD_STATE_READ_IMAGE;
 			break;
 		}
-		case MLX5_VF_LOAD_STATE_READ_IMAGE_NO_HEADER:
-			ret = mlx5vf_resume_read_image_no_header(vhca_buf,
-						requested_length,
-						&buf, &len, pos, &done);
-			if (ret)
-				goto out_unlock;
-			break;
 		case MLX5_VF_LOAD_STATE_READ_IMAGE:
 			ret = mlx5vf_resume_read_image(migf, vhca_buf,
 						migf->record_size,
@@ -1114,21 +1033,16 @@ mlx5vf_pci_resume_device_data(struct mlx5vf_pci_core_device *mvdev)
 	}
 
 	migf->buf[0] = buf;
-	if (MLX5VF_PRE_COPY_SUPP(mvdev)) {
-		buf = mlx5vf_alloc_data_buffer(migf,
-			sizeof(struct mlx5_vf_migration_header), DMA_NONE);
-		if (IS_ERR(buf)) {
-			ret = PTR_ERR(buf);
-			goto out_buf;
-		}
-
-		migf->buf_header[0] = buf;
-		migf->load_state = MLX5_VF_LOAD_STATE_READ_HEADER;
-	} else {
-		/* Initial state will be to read the image */
-		migf->load_state = MLX5_VF_LOAD_STATE_READ_IMAGE_NO_HEADER;
+	buf = mlx5vf_alloc_data_buffer(migf,
+		sizeof(struct mlx5_vf_migration_header), DMA_NONE);
+	if (IS_ERR(buf)) {
+		ret = PTR_ERR(buf);
+		goto out_buf;
 	}
 
+	migf->buf_header[0] = buf;
+	migf->load_state = MLX5_VF_LOAD_STATE_READ_HEADER;
+
 	stream_open(migf->filp->f_inode, migf->filp);
 	mutex_init(&migf->lock);
 	INIT_LIST_HEAD(&migf->buf_list);
@@ -1262,13 +1176,6 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
 	}
 
 	if (cur == VFIO_DEVICE_STATE_RESUMING && new == VFIO_DEVICE_STATE_STOP) {
-		if (!MLX5VF_PRE_COPY_SUPP(mvdev)) {
-			ret = mlx5vf_cmd_load_vhca_state(mvdev,
-							 mvdev->resuming_migf,
-							 mvdev->resuming_migf->buf[0]);
-			if (ret)
-				return ERR_PTR(ret);
-		}
 		mlx5vf_disable_fds(mvdev, NULL);
 		return NULL;
 	}
-- 
2.18.1


