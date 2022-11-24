Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34BE1637E7A
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 18:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiKXRlL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 12:41:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbiKXRlE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 12:41:04 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2056.outbound.protection.outlook.com [40.107.244.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1047F146F84
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 09:41:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eJ0f4wo3lF/s7LWQI4jSLx5BWllP7bqeYWmTSs5Qu69O5Kuy5ypVusi7RMQHtxKRhcwZeuCMZhuXJr1KmQv8StSCpNnfMzSTVBKqd0Zkcz8xcbjRsXWq58BtvXRzPtezyNVOXECqMAdrufiEIXqN23jtDbAIc28euvK71YUllmwg8KRmO9nGDbQJkwYAvMggBbd2FHoiSu0H+eRU6XGgqgRK1nh1h28pHJsr0kq7el8baOlRm+sizPGfeAPzB2xJF7/wKE77BBf6C2UWdSOTr285I384bHdN5oa+cSbB7WRvwfoWDhXyElEkzl4kHxbBEEB1n115jFE6NutSJtQVNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tr8u9pn6TG1+o/fEH3tZ+hUdPpAExfBr9OEj77LaxrQ=;
 b=UoQyY138NMEANxhRglECZ9TQWydEJxzUUhi1VYPCwi8hCmKdRG+hAZRX2Fa/BFSwlprI9Foj5nxtF8eOG49LkKmLKUKdVRfBo73rYUawb+X483hjloVVDZlS8s8iSq1iAH3UiVSNfyHX1r8qZcLtVVZEas6a+iO/RhwoK9GnoJlixL/zOPdI5QWUp/mWWK+SOG420ova3QXXFZ+SkpX/rOmkIDsLykLUiLeOQ3cEmP526JaDHymPVBXVitAnmSLyCNEs6aLHeUKjX2KE164D5zUm3oKWhQlHE3IYyrKNwlwtBEt6P6KwkNfRG1tuI3W4DK7QRjT+CqjEaHZ/DrL8dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tr8u9pn6TG1+o/fEH3tZ+hUdPpAExfBr9OEj77LaxrQ=;
 b=lHrKr9c0Gsp8OWyQcRuM0mhVt7ijcrsqURaru5fSuDANcOkx2YXCUATofrEgHA/2in9LdfXRMApN4d7/xxS7DP08VdSTPhY3yHJXkKaFZo37PpUtAHEjIu0ZGHMsmPWWo4c+dIDOcfg6JN9r9oAaC0XyeRThtvcSRj5f7wecPO7vDbYYpn5Xvw+24cAnJG+es23YNwYocWKASQwHufMDY6NFYVhMyNvUBzZs79LSC/4kqLT98N2E6LexLfUAnm8lrH5IHXxBzJrYZOAbuDAXT4RPSAkEpu78zHRcufoxOqflC6QZU+i4eZ75M3I1G3OFcd8TD4BHehbn1q8J3sRsVQ==
Received: from DS7PR03CA0229.namprd03.prod.outlook.com (2603:10b6:5:3ba::24)
 by BL0PR12MB4914.namprd12.prod.outlook.com (2603:10b6:208:1c4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Thu, 24 Nov
 2022 17:41:00 +0000
Received: from DM6NAM11FT087.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ba:cafe::4a) by DS7PR03CA0229.outlook.office365.com
 (2603:10b6:5:3ba::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19 via Frontend
 Transport; Thu, 24 Nov 2022 17:41:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM6NAM11FT087.mail.protection.outlook.com (10.13.172.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.8 via Frontend Transport; Thu, 24 Nov 2022 17:41:00 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 24 Nov
 2022 09:40:49 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 24 Nov 2022 09:40:49 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Thu, 24 Nov 2022 09:40:46 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>
Subject: [PATCH V1 vfio 09/14] vfio/mlx5: Introduce SW headers for migration states
Date:   Thu, 24 Nov 2022 19:39:27 +0200
Message-ID: <20221124173932.194654-10-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221124173932.194654-1-yishaih@nvidia.com>
References: <20221124173932.194654-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT087:EE_|BL0PR12MB4914:EE_
X-MS-Office365-Filtering-Correlation-Id: c25726d2-97eb-42d0-8d11-08dace430d13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lsHZvuVyxE9kJuj01aZeAdL2zaeTsKFS7c0MZaw1mTQGdDx/o5cIQa4YJEvmARZfpJBmJA/jgPFvH9NyW324Qpg9RzNRz7YuWuNhnMZ+OL1+1YtCdt/cYErdZ0OWQ5505yEG3Y1VOb4tKzDlxY2laYzv0Igv4ZDGve8qTQWM3KVKJmnsMF4P29L3WdS37y+pmZVNKs0JA7Hl1mBHEEYFaM6Toz+N6Zdce3R1QH9FHqdzudEJSXl10rsRtPA9v+9lz6CaqciYyCEYCTvabTA+9NihW72NFCof26f6eiJW93Fj6tyHuw0RHpXgb/eqMFqSIB3D65Y+VEw17gI+D33LvezIE7klWsVUSYJq7iaSSMxgsVM/OddE8P9ZOHduT94aXqsa5RSxTZvDSzJjVW6879Tfana3PATWPKhjAEdLLU0YRqe9uRMciDK/sAjoOmbs3s7J9OcoeX6TLSxR1DCYeFaMjjZVZAJUVibvkEbC0S1PT3w0Ki8LvFIKndche2C94lrdxHk33i764N4xfecNE3SB9NktdQaBSmxyxVYYlW340wkpBi+iwJAqre3mEYy3RmX9hkFG5WepsvDpfUamCWWNSWt+k33Ns/fLqKPbTOJ9FzjL2pRQjImHjssTdi8liFILo2zusvT2Z8vdsqLps60k2iIjYfWqKwiXc51egDh1ltrAL85R1R36dfufg9rpRTHPWQPZGUZOZ0vCS+KvcQ==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(346002)(136003)(376002)(451199015)(40470700004)(36840700001)(46966006)(36756003)(83380400001)(1076003)(2616005)(41300700001)(47076005)(5660300002)(426003)(336012)(186003)(8936002)(36860700001)(40480700001)(86362001)(40460700003)(2906002)(82310400005)(82740400003)(6636002)(7696005)(26005)(110136005)(356005)(316002)(7636003)(6666004)(54906003)(4326008)(478600001)(70206006)(70586007)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2022 17:41:00.2456
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c25726d2-97eb-42d0-8d11-08dace430d13
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT087.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4914
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
 drivers/vfio/pci/mlx5/cmd.h  | 10 +++++++
 drivers/vfio/pci/mlx5/main.c |  2 +-
 3 files changed, 64 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 5fcece201d4c..0af1205e6363 100644
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
 
+	if (track || inc) {
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
index 34e61c7aa23d..2b77e2ab9cd2 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -17,11 +17,18 @@ enum mlx5_vf_migf_state {
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
@@ -37,6 +44,7 @@ struct mlx5vf_async_data {
 	struct mlx5_async_work cb_work;
 	struct work_struct work;
 	struct mlx5_vhca_data_buffer *buf;
+	struct mlx5_vhca_data_buffer *header_buf;
 	int status;
 	u8 last_chunk:1;
 	void *out;
@@ -165,6 +173,8 @@ mlx5vf_get_data_buffer(struct mlx5_vf_migration_file *migf,
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

