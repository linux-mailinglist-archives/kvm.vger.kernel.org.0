Return-Path: <kvm+bounces-10943-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 15E20871BE9
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 11:45:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A5181C21194
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 10:45:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F67357308;
	Tue,  5 Mar 2024 10:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tvc5xCxh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2043.outbound.protection.outlook.com [40.107.223.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B9311198
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 10:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709634680; cv=fail; b=CutLE2C9ncYtWsPo4T7fAuRUYC/lh/ixGuE2SHmEMS+0DeqyXptpoDjVK0IOaXJfapLOl+HV2DUpONmCrcsaqm+z7miG8YdNdwEfY+7pfa8lHyd1A4bqIYiOgYZGEoDGBq7Aot/FgNjs0p/sabgissZHBTQNUQreT+NFZVZ87/g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709634680; c=relaxed/simple;
	bh=qN0uDrOPQyxEwNVUx54Z2e975EW6+oCb7c8LNwcAhpM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=iATdvkPGTp/gqNgGcPQGawVZiGfmRDXd4oajx4heWgrTy2tUaOXCAjQE87e/cq2+GPD/v0ItNyNDArpBFvMTic97fajQEIV11ZiBoesv4ZKuxfjEHk0hn6LIFSyFhu5hoyrQYNuf3pYkQ24RKApXqhjzm7JJk0rqYg41B33hjsM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tvc5xCxh; arc=fail smtp.client-ip=40.107.223.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ilvokJBt7g2kfHYkMXXXeRGbkiMoYAF1DGmPgkHfZF8KZR85eMydyAtM4yM7+z+CegTRVsJvOftBAq7Dy+xteTdx7e7OmHNakzd5zXaMwLknkLEYOgBAGB+3pDl6Iomlv5/tdYOuE0LrJMOX7R4oJ40A3plOcHyzjB4USrCMAWFpFU++R6J9ViRgath7MFkwMbmv0nixYh7BE8hobWQxNzbJrnL1NyvLcs8bIGYexhKI/NgyacJ6FPMtyzsc1BvpX9vCFFkk/t/CDYqWQ6Rj2t/GwcG+Ojcz5NwX+mR9Ze7YfdU2zXhbdE9dDclDeE3Dld5js9cNcVZ6K6qzp4eZwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6GFKssrJbTHoshLaD/K8r48LW6H+nEQIubnHQf+aTTU=;
 b=miWLB4Yew2AZWbrTWcQc/BIEeA3uvpctBEZhLNzxDZrdZK5fXBsrZeNuF8p7oneU7ydCdyXUCpSr35SaUBJgxROn7eHk0941g0JWLAl9vm4k6HLtpL6Hsr1vpF2JJoh5yaHTxyENs+FUfbxDrBlGMSKf7FOcXSLjrZSqe+dbgV45xrLadnjWtrDMiXAHqaLcgMRV0T9tI/GatCMiYLkbqvQEri4MIF5h9AGx/h+CzjjmoerKy73A43XG6LLH12WwgXT5YF7Ntte90oWhygMFwj1CCsR+g70hE36HJ/dUHQ+jzmsYp2GJA9WHvJbcN/QDPgds8lWkmYZZZiueXlh8bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6GFKssrJbTHoshLaD/K8r48LW6H+nEQIubnHQf+aTTU=;
 b=tvc5xCxhHqGFdje1Qng0ouAnC1bbU5SZfCcnioicc41WgJP7wnH3zNH8PVRukrg/BzB4NMXtLAlqyPm3337xkLBJ93ShHXbgl9LSbttoFJ5BgVaN/pPhIueLBz3U/GGWj5LigAmloPE4W/QJFXrWNLdMkkKGlG5/O+yIcl/dRMTCmjIgfkAJ6QGTAJOLEBoBBOTFpzPDdQnoq+KJCIVb06N51JKJ/yxq5OpLIicAZakck+F+Xc8lswsSkTnO9E2hDfZ3UytcVez2y2BIx0s6Ge3hBcLgbtEsgJVvtc/hFgPi6sUcR+UJKLoC0I0luGGJ2TNoZyoHWU14ZmSmVQQpkA==
Received: from CYZPR05CA0014.namprd05.prod.outlook.com (2603:10b6:930:89::6)
 by SJ2PR12MB8926.namprd12.prod.outlook.com (2603:10b6:a03:53b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.37; Tue, 5 Mar
 2024 10:31:13 +0000
Received: from CY4PEPF0000EE34.namprd05.prod.outlook.com
 (2603:10b6:930:89:cafe::ba) by CYZPR05CA0014.outlook.office365.com
 (2603:10b6:930:89::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.24 via Frontend
 Transport; Tue, 5 Mar 2024 10:31:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000EE34.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7362.11 via Frontend Transport; Tue, 5 Mar 2024 10:31:13 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 5 Mar 2024
 02:30:59 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Tue, 5 Mar
 2024 02:30:59 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.1258.12 via Frontend Transport; Tue, 5 Mar
 2024 02:30:57 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH vfio] vfio/mlx5: Enforce PRE_COPY support
Date: Tue, 5 Mar 2024 12:30:37 +0200
Message-ID: <20240305103037.61144-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE34:EE_|SJ2PR12MB8926:EE_
X-MS-Office365-Filtering-Correlation-Id: 75351e94-ba79-4fb4-7930-08dc3cff619d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	mYH2ht4F/hjlL0EyVzDsHhqNNAC0ug2NGhaHgSbx6dG85Ufw3ckJChAtuxccTwT5pufN3bwcBKdkNOiExwkWOLuaUM6L91rc+LxHAVrP8ny3gpopHgMTJhRL0zMVkLdLawsqWwVdlG5o5MhxumHcNPn+aTL6IuBoRArO3pjKgpRpmmvVndfRplKkJXGF9fhHkV9u6ApKjZKrpRcUS1kpCjUIcwN9U6NVo6mVTDwhhMnvLAdWU8/Z1P/gxryb5GkZoXAv+YjOSb628ASPjJ/hIartZXLWKCvDykuXlMtc5Sih6JZsKXiXsyrxkqIRg4Zk5xDIDC8fljA50t3CTidL9FjeZj22wk+QCnx2mVhgYUg+w1r/qsM2rgUZWcC6j1ebwKM+ELh8THWEElHDaSDAv5kIFFiFILDKXvlnhh1UddJrhuLqMSYQap3K4yZ5JP2I0q+LBSWfraF0SZudMQdMTuePR9Br8jSWrA5uD68smVMY1s3sSIc2z2UP9vAYa9VYPjZlooHfSG5WTzhEV9MZUxIZoOjjTYB9NkrqusU0LBvRAbgwaxCMs8WuhntRr795gkctsoI+nXKG6jRBbvhPCqxITJB1cKf4zZcoPCV3wwOhDwBMlGl7dJhvZmXnBBiJn25zpoZxlRGk8kRwyNb6urP3/MFD9rLNbiL7p0hk0JnnseVJ8O+SqP/y6eHOrVUl9yMaYGgipcRd29sZlMTp66gE2g4C0OOZ16o2NuleZdTYQODhBIB8LWACP2MA+K8i
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(376005)(36860700004)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2024 10:31:13.0397
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 75351e94-ba79-4fb4-7930-08dc3cff619d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE34.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8926

Enable live migration only once the firmware supports PRE_COPY.

PRE_COPY has been supported by the firmware for a long time already and
is required to achieve a low downtime upon live migration.

This lets us clean up some old code that is not applicable those days
while PRE_COPY is fully supported by the firmware.

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


