Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9215963F3F1
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 16:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbiLAPbQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 10:31:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbiLAPar (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 10:30:47 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2053.outbound.protection.outlook.com [40.107.243.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D123EAD313
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 07:30:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nIOeDpc2w3gD2QGqszp/qKn6ZfcfB/RLrAhEZDRYFghfwp2BCPEE43JKPm6YoOWDXe4L8Ke1RPbBzKneO1P8VZA6V5fosk/VPjoqPkr/fJe3EKjgdQLEn/lG8FjbpOv0r6WdcdqUKDUKI3/R9hpeJu7COmeMQwv5S/C0X5xKV4l5pvI5PPN8MwM4yO7EoLJLqrLx6X4zFKvsGoOVnx8lv49uvovjzjc+7Seu24/tCZrGLXhI7LvI7u66yEedHklyH7JRv9NeVf5SyO+ju/l+tenuf2jPbx2U7hR7OIRkOr7nTJWMv/lA3S2wMZblm2mPDIVTNNYwLQb+FMn/ug7NkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g5TLczUFmlLLixONMcQSrg0JykLJ1N4RPFpW3f4DBoA=;
 b=gcMD3AwynF0MOL2npOOVEJMXu+q1aES1iL8MVVQ/66xk+NR62IEjjux/lja98uoElChAEaSsEDYT2sOk2z5lnQY6Hecxk1ow2OpxkaIEBZ2bJUDmoQafyTWxSUBZ2pG0PcjoJOQxuwPlbzWYKpLpvPv9WA5D8drhqIWRBXvgGvlwjGuj9p0pCAR03ahK0vsvw86keEwAxUd2fd5GBJWqA8clD4bXOoG1UYVaFfSbnkr8i7psl+Ov4uijlnZqANWd/IuBj7L0k39g2GMDwHTsO953xueDhytc4mrnRq+wI7emg5ATf0P99LQCjjRXO10G8aAFlLGhpK+kLEwgpV8r5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g5TLczUFmlLLixONMcQSrg0JykLJ1N4RPFpW3f4DBoA=;
 b=QrziHxtWPAn7chaL4ccUJeYHY2pxgmJgWI7DFRHu1PSJervXloLohyjWuShUg+xw0Q4O23fdulrZjTU86zdpHwaBr4uWyxvraQHBYI19rESWAw+6N407526GbY0JIvzWyRfsxv/dqyVGvu7wXi8rZD/BKds/KcdKZQvhgKW0rbp6l7sKkIzm256fANBgim3MfljjQ9Rjgy6WzpkrFqFHwGy5uYGM1GUVNj8B5fi0Nsj/Wb90Y/ooatx6P14z3Lhz6OiKR2cLOK68rvKQNewLZDYfAArY+otsGCkaGlRR/Z5Ah5Qf/oJmlcQluMtpyqU4WMvepU8WIq5f/tU+PMTfZQ==
Received: from DM6PR06CA0065.namprd06.prod.outlook.com (2603:10b6:5:54::42) by
 DM6PR12MB4124.namprd12.prod.outlook.com (2603:10b6:5:221::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8; Thu, 1 Dec 2022 15:30:38 +0000
Received: from DS1PEPF0000E62F.namprd02.prod.outlook.com
 (2603:10b6:5:54:cafe::20) by DM6PR06CA0065.outlook.office365.com
 (2603:10b6:5:54::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8 via Frontend
 Transport; Thu, 1 Dec 2022 15:30:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS1PEPF0000E62F.mail.protection.outlook.com (10.167.17.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.17 via Frontend Transport; Thu, 1 Dec 2022 15:30:38 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 1 Dec 2022
 07:30:28 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 1 Dec 2022 07:30:27 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Thu, 1 Dec 2022 07:30:25 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>
Subject: [PATCH V2 vfio 09/14] vfio/mlx5: Introduce SW headers for migration states
Date:   Thu, 1 Dec 2022 17:29:26 +0200
Message-ID: <20221201152931.47913-10-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221201152931.47913-1-yishaih@nvidia.com>
References: <20221201152931.47913-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E62F:EE_|DM6PR12MB4124:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a5c1a1c-4dee-44b6-0f0d-08dad3b0ffc3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZkoGUIhXZdRtFMEcE9DOtXUnG8WXeFvA9+J7f67QN62N3Zp6MUiccI6tM/vCuxFB4T1XyHBw/vyIgEuAw68h9qgeLdZYP/P/aWKFAoe6EZ+COtdUIHv81eeiqQik4dvkuA7tueqGP27804x8G3/Z3iccoSasDMaxdU6kg387KD12AfgYNhBeEzTzaP/JnY8hBwUOe+86U6o5jEMOBDrEDhuQ+L+/h0rUgK732JDm4dHF2yDN6UtoH0SYoc52GlwQOIqmhq/MAWM7P1UAVjeMv2UXnelJDkt5tmnBiiRMFhRBC0pnTKy6WBzatR21SKFz56zlg0Rcq8gUkoCNYWO6Eld+CnFEPcMQyK15HLWL5XJs/jSM4rJZk3AoDpMGBOyfJF8fBFwfjknYNJNdTAL+kFs23ar5VrtouZzfcEjU+37NJ8vwsFdYU9fe5ATxMJOP6jiGt5xuV8Djz7GT9qOtJVgg4m4/X/ekATP7Hq1r8SlMV1H7Qx7aFZ+XR8dXbYaTDkF0k9B7yowkaXfbTcXIrIPfVUPHvqYd5iz8UT8Myz9YvsvEEfE/ebrQWOhsPVueFyM7OV6wGEvmy5JEtHhPcGBV8n8mHHF+oOyt6m5sI1VQCqb6op3+ZnralOby+moqX2T6HQS53iDN1r8p7bw0CW9/bdl6YE0Z0OnDCGH8/J1jcu7bgeAlvYleLjXN7f8PWcawVqW+rwxJxZyZ+KCFWA==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(396003)(39860400002)(376002)(451199015)(46966006)(40470700004)(36840700001)(86362001)(40460700003)(1076003)(36756003)(40480700001)(70206006)(70586007)(186003)(2616005)(336012)(41300700001)(47076005)(8676002)(4326008)(8936002)(5660300002)(426003)(7696005)(478600001)(316002)(54906003)(110136005)(26005)(7636003)(82740400003)(356005)(6636002)(82310400005)(2906002)(36860700001)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 15:30:38.3618
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a5c1a1c-4dee-44b6-0f0d-08dad3b0ffc3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E62F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4124
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As mentioned in the previous patches, mlx5 is transferring multiple
states when the PRE_COPY protocol is used. This states mechanism
requires the target VM to know the states' size in order to execute
multiple loads.  Therefore, add SW header, with the needed information,
for each saved state the source VM is transferring to the target VM.

This patch implements the source VM handling of the headers, following
patch will implement the target VM handling of the headers.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  | 56 ++++++++++++++++++++++++++++++++++--
 drivers/vfio/pci/mlx5/cmd.h  | 13 +++++++++
 drivers/vfio/pci/mlx5/main.c |  2 +-
 3 files changed, 67 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 5fcece201d4c..160fa38fc78d 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -351,9 +351,11 @@ mlx5vf_alloc_data_buffer(struct mlx5_vf_migration_file *migf,
 		if (ret)
 			goto end;
 
-		ret = mlx5vf_dma_data_buffer(buf);
-		if (ret)
-			goto end;
+		if (dma_dir != DMA_NONE) {
+			ret = mlx5vf_dma_data_buffer(buf);
+			if (ret)
+				goto end;
+		}
 	}
 
 	return buf;
@@ -422,6 +424,8 @@ void mlx5vf_mig_file_cleanup_cb(struct work_struct *_work)
 	mutex_lock(&migf->lock);
 	if (async_data->status) {
 		mlx5vf_put_data_buffer(async_data->buf);
+		if (async_data->header_buf)
+			mlx5vf_put_data_buffer(async_data->header_buf);
 		migf->state = MLX5_MIGF_STATE_ERROR;
 		wake_up_interruptible(&migf->poll_wait);
 	}
@@ -431,6 +435,32 @@ void mlx5vf_mig_file_cleanup_cb(struct work_struct *_work)
 	fput(migf->filp);
 }
 
+static int add_buf_header(struct mlx5_vhca_data_buffer *header_buf,
+			  size_t image_size)
+{
+	struct mlx5_vf_migration_file *migf = header_buf->migf;
+	struct mlx5_vf_migration_header header = {};
+	unsigned long flags;
+	struct page *page;
+	u8 *to_buff;
+
+	header.image_size = cpu_to_le64(image_size);
+	page = mlx5vf_get_migration_page(header_buf, 0);
+	if (!page)
+		return -EINVAL;
+	to_buff = kmap_local_page(page);
+	memcpy(to_buff, &header, sizeof(header));
+	kunmap_local(to_buff);
+	header_buf->length = sizeof(header);
+	header_buf->header_image_size = image_size;
+	header_buf->start_pos = header_buf->migf->max_pos;
+	migf->max_pos += header_buf->length;
+	spin_lock_irqsave(&migf->list_lock, flags);
+	list_add_tail(&header_buf->buf_elm, &migf->buf_list);
+	spin_unlock_irqrestore(&migf->list_lock, flags);
+	return 0;
+}
+
 static void mlx5vf_save_callback(int status, struct mlx5_async_work *context)
 {
 	struct mlx5vf_async_data *async_data = container_of(context,
@@ -444,6 +474,11 @@ static void mlx5vf_save_callback(int status, struct mlx5_async_work *context)
 
 		image_size = MLX5_GET(save_vhca_state_out, async_data->out,
 				      actual_image_size);
+		if (async_data->header_buf) {
+			status = add_buf_header(async_data->header_buf, image_size);
+			if (status)
+				goto err;
+		}
 		async_data->buf->length = image_size;
 		async_data->buf->start_pos = migf->max_pos;
 		migf->max_pos += async_data->buf->length;
@@ -455,6 +490,7 @@ static void mlx5vf_save_callback(int status, struct mlx5_async_work *context)
 		wake_up_interruptible(&migf->poll_wait);
 	}
 
+err:
 	/*
 	 * The error and the cleanup flows can't run from an
 	 * interrupt context
@@ -470,6 +506,7 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 {
 	u32 out_size = MLX5_ST_SZ_BYTES(save_vhca_state_out);
 	u32 in[MLX5_ST_SZ_DW(save_vhca_state_in)] = {};
+	struct mlx5_vhca_data_buffer *header_buf = NULL;
 	struct mlx5vf_async_data *async_data;
 	int err;
 
@@ -499,6 +536,16 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 		goto err_out;
 	}
 
+	if (MLX5VF_PRE_COPY_SUPP(mvdev)) {
+		header_buf = mlx5vf_get_data_buffer(migf,
+			sizeof(struct mlx5_vf_migration_header), DMA_NONE);
+		if (IS_ERR(header_buf)) {
+			err = PTR_ERR(header_buf);
+			goto err_free;
+		}
+	}
+
+	async_data->header_buf = header_buf;
 	get_file(migf->filp);
 	err = mlx5_cmd_exec_cb(&migf->async_ctx, in, sizeof(in),
 			       async_data->out,
@@ -510,7 +557,10 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	return 0;
 
 err_exec:
+	if (header_buf)
+		mlx5vf_put_data_buffer(header_buf);
 	fput(migf->filp);
+err_free:
 	kvfree(async_data->out);
 err_out:
 	complete(&migf->save_comp);
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index 34e61c7aa23d..3e36ccca820a 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -12,16 +12,26 @@
 #include <linux/mlx5/cq.h>
 #include <linux/mlx5/qp.h>
 
+#define MLX5VF_PRE_COPY_SUPP(mvdev) \
+	((mvdev)->core_device.vdev.migration_flags & VFIO_MIGRATION_PRE_COPY)
+
 enum mlx5_vf_migf_state {
 	MLX5_MIGF_STATE_ERROR = 1,
 	MLX5_MIGF_STATE_COMPLETE,
 };
 
+struct mlx5_vf_migration_header {
+	__le64 image_size;
+	/* For future use in case we may need to change the kernel protocol */
+	__le64 flags;
+};
+
 struct mlx5_vhca_data_buffer {
 	struct sg_append_table table;
 	loff_t start_pos;
 	u64 length;
 	u64 allocated_length;
+	u64 header_image_size;
 	u32 mkey;
 	enum dma_data_direction dma_dir;
 	u8 dmaed:1;
@@ -37,6 +47,7 @@ struct mlx5vf_async_data {
 	struct mlx5_async_work cb_work;
 	struct work_struct work;
 	struct mlx5_vhca_data_buffer *buf;
+	struct mlx5_vhca_data_buffer *header_buf;
 	int status;
 	u8 last_chunk:1;
 	void *out;
@@ -165,6 +176,8 @@ mlx5vf_get_data_buffer(struct mlx5_vf_migration_file *migf,
 void mlx5vf_put_data_buffer(struct mlx5_vhca_data_buffer *buf);
 int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
 			       unsigned int npages);
+struct page *mlx5vf_get_migration_page(struct mlx5_vhca_data_buffer *buf,
+				       unsigned long offset);
 void mlx5vf_state_mutex_unlock(struct mlx5vf_pci_core_device *mvdev);
 void mlx5vf_disable_fds(struct mlx5vf_pci_core_device *mvdev);
 void mlx5vf_mig_file_cleanup_cb(struct work_struct *_work);
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index e86489d5dd6e..ec52c8c4533a 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -32,7 +32,7 @@ static struct mlx5vf_pci_core_device *mlx5vf_drvdata(struct pci_dev *pdev)
 			    core_device);
 }
 
-static struct page *
+struct page *
 mlx5vf_get_migration_page(struct mlx5_vhca_data_buffer *buf,
 			  unsigned long offset)
 {
-- 
2.18.1

