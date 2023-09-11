Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F17D79BAB5
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234195AbjIKUsL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235825AbjIKJkO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 05:40:14 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2040.outbound.protection.outlook.com [40.107.92.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B21C4102
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 02:40:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CNdXLqkS041dVwei9umjpaSuWXdofTTD+XHCZxxW4Zpr7pev6CFM+g/Ksm73jgeK6BaFTHjeltjJzWpGkeYu9iy44NOmy91JCk7unZTGUINycVJay3Memk10BS4dnTgJ2eTuPu/jTjRnMhFUb0qx4lkaF8ixf22KLeNzvOXqYXwdT8WyxedcsHDuIfEjYeoB35sYNpi+aonDkL+Ft6Ah8HKDEz96Gbf0BQCSGdb9q3PJyaE3tgMYLhmkiW9z/cbEjZUA2dp/OS7OPNx7hj1FDgmCPCd0D33EWubUoLm9PVZnBhC+ibA7AvsuBnLiKmx5NvCqkq/ifU58kIuh2wtNdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=deGklXlN+fwpeCbOCXB2ZqYdV9aBMnOKi1+NHZNKq0Q=;
 b=ml6FuqJBQYNtbn68ba1LHNlmShV9dp482W9YP7Vj5zcxPYEZTvk7HkpfeEm8hQn6U9duPvVffRDUoV3xDmnyrUg0hS4XRgjxyApve7zwKBU20GxEDuOBGlUdjFgUvPO9QLuaAmx6sZAbsyZiDk+YUTf00cHWvYj26uoEuDUjapT0NZh6VEAVrG7YIX0WdFc+xpEfKyc1oHza8vrhcIVqHw3nS8YCnHo+viHMIi6JhnCfRAmq7htGsvZ6d+fzZNbjiDtRIbxjyDBbhswMxvvpJHpDOiCUqGGMl2inuTWciQbmUVi2KqGPTnMYt97JziV6LWtmawy8V6IxUVacLSNIRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=deGklXlN+fwpeCbOCXB2ZqYdV9aBMnOKi1+NHZNKq0Q=;
 b=O4OVHZohaPdcoZAT1YgZzR0Rlbo8Qra+5W/jf1ZvbZvPHMB4Mvq9EuzXY4VvPrJz/FxS0w9R+MtzdKn/D2M4YhfFK2h/wJ+JScP89sBb/5O2ACMHD7hi/KtkJrRhadTDTg+Tekab3wEktxpwIzlqGBaBKuq+wc+LzY3zt/7VSrvpYes0+k8ws7/PP8tpZtHBZ0K+JNeCFBhYDQnLox48y7dq+Y26zOgYJ/nZwlXeKv+W8pccIOnnPGgsDt5wsqudIsbPF2coDkclylPv0KcnGnDmAunSu/QPda693IetWdoJi3qSpWM0+JHKu1PGsJJ9oIDraZWwqXF9ybsHh+Jf/g==
Received: from BL0PR02CA0119.namprd02.prod.outlook.com (2603:10b6:208:35::24)
 by MN0PR12MB6198.namprd12.prod.outlook.com (2603:10b6:208:3c5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.36; Mon, 11 Sep
 2023 09:40:07 +0000
Received: from BL6PEPF0001AB54.namprd02.prod.outlook.com
 (2603:10b6:208:35:cafe::a9) by BL0PR02CA0119.outlook.office365.com
 (2603:10b6:208:35::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.31 via Frontend
 Transport; Mon, 11 Sep 2023 09:40:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF0001AB54.mail.protection.outlook.com (10.167.241.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.17 via Frontend Transport; Mon, 11 Sep 2023 09:40:07 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 11 Sep 2023
 02:39:55 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 11 Sep
 2023 02:39:55 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Mon, 11 Sep
 2023 02:39:53 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH vfio 5/9] vfio/mlx5: Rename some stuff to match chunk mode
Date:   Mon, 11 Sep 2023 12:38:52 +0300
Message-ID: <20230911093856.81910-6-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20230911093856.81910-1-yishaih@nvidia.com>
References: <20230911093856.81910-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB54:EE_|MN0PR12MB6198:EE_
X-MS-Office365-Filtering-Correlation-Id: 053710fe-ef01-478f-83a8-08dbb2ab15d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OTtfD2IiIOewIQI1l3JFPoH48ZrzBodM5FPrLmCgSqfc9MytGvBSyfcIFNGrhRNEs2iYtzfQGziUpyb8sD2f/7HrEwTYQq6Uzw9kn7lcrFKcKU1Zf8eGEmZPRwVZ1zGbz/ynDzRytFXicusLo6q7ABMswoeq1s6QuSR5p8ygZf1d/W/bfnjuygewT8xayAAIFoMn65jeQe0PTsthH9AYAr1cnzSKwMoqYiDRfeXFkbUQ62hLiK+smgrDCD8vx3luxdfg8oUYHf8s7/DMxJA4TUpRmX/2ZtfetGC05cXAP8vdzK7JBBv6p+FnrX0BI9hMq2WCIIuPdFbYP7Lt9slXZeRH0KQGupnzXjCZVgi4NWLEBOulLxcl/fgkd2PWJt4s1a6tomTRnVuWCplUxdouDdeTaLSv4oJbCJQ1l46x2QUh7g2o+v1fn74XlU/2GpyBBGUiLXWLycuatpIBQKxKRYx+yyYDJdtCY2kXGbRqRXPCDdqGz3TxuHCLZehQCdh4y0O5laHoEpkpqiq3iPUyhWXiPPKxIeZGvQpip0uuJQl9ZU9JcAFH54/2/IwNFFb+q6KWmSjlxVfEfRSlb8FPjj90LOR/97D8ZzU09JajBZRzki0ZVvPWKnt4hjdfcjRhyLib/UTvmOVLOlQZeYLyAE9no6loiqfTAjeEMkapCUXfBMT0X0Rv74CGzXDtKj0elFqBNe5VhskR+zBhqGSJoJkAFbpPamfhK7RzfkW2RRITPdDBDJtJYZ0VOjc0yE/p
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(346002)(376002)(136003)(396003)(186009)(82310400011)(451199024)(1800799009)(40470700004)(46966006)(36840700001)(7636003)(82740400003)(356005)(36756003)(40480700001)(86362001)(40460700003)(478600001)(110136005)(2906002)(70586007)(7696005)(4326008)(8676002)(8936002)(5660300002)(6636002)(54906003)(316002)(41300700001)(47076005)(36860700001)(83380400001)(2616005)(107886003)(336012)(70206006)(1076003)(426003)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2023 09:40:07.6426
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 053710fe-ef01-478f-83a8-08dbb2ab15d4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL6PEPF0001AB54.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6198
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Upon chunk mode there may be multiple images that will be read from the
device upon STOP_COPY.

This patch is some preparation for that mode by replacing the relevant
stuff to a better matching name.

As part of that, be stricter to recognize PRE_COPY error only when it
didn't occur on a STOP_COPY chunk.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c | 15 ++++++++-------
 drivers/vfio/pci/mlx5/cmd.h |  4 ++--
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index e70d84bf2043..7b48a9b80bc6 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -503,7 +503,8 @@ void mlx5vf_mig_file_cleanup_cb(struct work_struct *_work)
 		mlx5vf_put_data_buffer(async_data->buf);
 		if (async_data->header_buf)
 			mlx5vf_put_data_buffer(async_data->header_buf);
-		if (async_data->status == MLX5_CMD_STAT_BAD_RES_STATE_ERR)
+		if (!async_data->stop_copy_chunk &&
+		    async_data->status == MLX5_CMD_STAT_BAD_RES_STATE_ERR)
 			migf->state = MLX5_MIGF_STATE_PRE_COPY_ERROR;
 		else
 			migf->state = MLX5_MIGF_STATE_ERROR;
@@ -553,7 +554,7 @@ static void mlx5vf_save_callback(int status, struct mlx5_async_work *context)
 		size_t image_size;
 		unsigned long flags;
 		bool initial_pre_copy = migf->state != MLX5_MIGF_STATE_PRE_COPY &&
-				!async_data->last_chunk;
+				!async_data->stop_copy_chunk;
 
 		image_size = MLX5_GET(save_vhca_state_out, async_data->out,
 				      actual_image_size);
@@ -571,7 +572,7 @@ static void mlx5vf_save_callback(int status, struct mlx5_async_work *context)
 		spin_unlock_irqrestore(&migf->list_lock, flags);
 		if (initial_pre_copy)
 			migf->pre_copy_initial_bytes += image_size;
-		migf->state = async_data->last_chunk ?
+		migf->state = async_data->stop_copy_chunk ?
 			MLX5_MIGF_STATE_COMPLETE : MLX5_MIGF_STATE_PRE_COPY;
 		wake_up_interruptible(&migf->poll_wait);
 		mlx5vf_save_callback_complete(migf, async_data);
@@ -623,7 +624,7 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 
 	async_data = &migf->async_data;
 	async_data->buf = buf;
-	async_data->last_chunk = !track;
+	async_data->stop_copy_chunk = !track;
 	async_data->out = kvzalloc(out_size, GFP_KERNEL);
 	if (!async_data->out) {
 		err = -ENOMEM;
@@ -631,7 +632,7 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	}
 
 	if (MLX5VF_PRE_COPY_SUPP(mvdev)) {
-		if (async_data->last_chunk && migf->buf_header) {
+		if (async_data->stop_copy_chunk && migf->buf_header) {
 			header_buf = migf->buf_header;
 			migf->buf_header = NULL;
 		} else {
@@ -644,8 +645,8 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 		}
 	}
 
-	if (async_data->last_chunk)
-		migf->state = MLX5_MIGF_STATE_SAVE_LAST;
+	if (async_data->stop_copy_chunk)
+		migf->state = MLX5_MIGF_STATE_SAVE_STOP_COPY_CHUNK;
 
 	async_data->header_buf = header_buf;
 	get_file(migf->filp);
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index 4fb37598c8e5..ac5dca5fe6b1 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -20,7 +20,7 @@ enum mlx5_vf_migf_state {
 	MLX5_MIGF_STATE_ERROR = 1,
 	MLX5_MIGF_STATE_PRE_COPY_ERROR,
 	MLX5_MIGF_STATE_PRE_COPY,
-	MLX5_MIGF_STATE_SAVE_LAST,
+	MLX5_MIGF_STATE_SAVE_STOP_COPY_CHUNK,
 	MLX5_MIGF_STATE_COMPLETE,
 };
 
@@ -78,7 +78,7 @@ struct mlx5vf_async_data {
 	struct mlx5_vhca_data_buffer *buf;
 	struct mlx5_vhca_data_buffer *header_buf;
 	int status;
-	u8 last_chunk:1;
+	u8 stop_copy_chunk:1;
 	void *out;
 };
 
-- 
2.18.1

