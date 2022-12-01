Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A70F863F3F5
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 16:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbiLAPbY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 10:31:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231799AbiLAPay (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 10:30:54 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2051.outbound.protection.outlook.com [40.107.101.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43281B0A09
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 07:30:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XlaYGoLmwsxPPUq4Hu3/Tn/0UhMgJUhYxFdrvRdJb6m98+BZgii6/yZgr9N3EQuTZAVvU0Tp+VREEVNXLZoV2+3u8LIv3P6w33Q9knL6SJJDEOviL0GbNEnq0yPmziG3F0xceAno+AMTaNlZ/9QROdgYiGBOBbmgIGEBVX6105GUbWV2k0QF/ZaTEgw9QXGG0otIzbEuPUf9M3DW724Jq66GSOTmezvZIsFictNTUvqgr/PHzL66ig4zJlFpx1qa5e0icsKldg40YVLAuEv5PkNpfM3EaTsFfJMaUNLJJpdYnLRaY2Bi5VuU0lVIcJHr+v9+cO6bb7TWp26NbyAnfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+pHFejagnoAAjcYtSii2j8nU/3LHJlIsK/U8BhWjwgI=;
 b=by+NiJYqAjt7nuHfiirNEb4CayDf+FEPvOos+X0gLYPSOnSNxgo320SpJckq5dRCTAyOiLcBtXoNF+OwcCdD+qpBuKL0JMA7ywIfC1DpaLTfshNLb3ECaGKG+s0hrO5YmF9Hp3mB+cvnKXOv40WtJcdFpPvo2oDOA7ndrEWD1sL1eWIyH/dq5E9N1yHwlgdVpe8hagqrjBPQ16HZzUNcRLZoYjLzd/BLvshaSV8/HYFv/cs3Lh9U4xVifeysEi3YmxptwGTv0Lqk/XmEjWA6wGZ6uvQO1XCjtNN0MbCEBP1tVco027r9dknndNg8j8sn/o4cRP4Q0kK53fztdwXB7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+pHFejagnoAAjcYtSii2j8nU/3LHJlIsK/U8BhWjwgI=;
 b=Cw+VMOiKW+y12K8ByjSulfY0fvg0uaaD1pKrxPfI1rYWRPaTWeVgNZCGNSNbOYR6G89znEXnecHN9kRs0El/kp/tmNK4TUwssv2e71djBwAsLMZuv16GD0K8npvBEtAH2NyZo+h4J1cAJ2dTXQDAAJzmVhg+zW+TjK2Eoruy3qTDYvvrnv/XgYZuCz6afDMl2ST6TTfsMFAYL5nOiflpVVo7Q86QGcjpmzyi3rfdQ7M4RNswBQy/211b5Yyytsiea/76Wm0rYaSxHIgD98hayO/CeqD5AjJ81damvFOjRC7Q8x6t9ELN/Zy0nHtQEwJeejd+zZRwzBwIlvtHXrPUNA==
Received: from DM6PR06CA0037.namprd06.prod.outlook.com (2603:10b6:5:54::14) by
 BN9PR12MB5146.namprd12.prod.outlook.com (2603:10b6:408:137::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 15:30:51 +0000
Received: from DS1PEPF0000E62F.namprd02.prod.outlook.com
 (2603:10b6:5:54:cafe::51) by DM6PR06CA0037.outlook.office365.com
 (2603:10b6:5:54::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8 via Frontend
 Transport; Thu, 1 Dec 2022 15:30:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS1PEPF0000E62F.mail.protection.outlook.com (10.167.17.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.17 via Frontend Transport; Thu, 1 Dec 2022 15:30:51 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 1 Dec 2022
 07:30:41 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 1 Dec 2022 07:30:40 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Thu, 1 Dec 2022 07:30:38 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>
Subject: [PATCH V2 vfio 13/14] vfio/mlx5: Fallback to STOP_COPY upon specific PRE_COPY error
Date:   Thu, 1 Dec 2022 17:29:30 +0200
Message-ID: <20221201152931.47913-14-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221201152931.47913-1-yishaih@nvidia.com>
References: <20221201152931.47913-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E62F:EE_|BN9PR12MB5146:EE_
X-MS-Office365-Filtering-Correlation-Id: b05abe61-a3e3-476e-2861-08dad3b10798
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b7khBwkt2y1YDnTYvajZcdJEzkf54KqjR3s8ds5WEExhQ7oiYr5ez9Kxw6SFAUwC90IqKTeDZk4Dwnb5b8KdmXxGnqVUpDJHDKa4VB20SzFKV+583W1i6ISbbUFtCvr7se1M/Jokc4Wv+W73DENvN55+3VLkKG+0chZCKzXl9KYY/MIPnXwPCj4bu0rKpFdsXSVYkKl/dSskOCc4w1+vriBJeENNpkcv0lXz71htNEwJ0SY7WPjD9O140HRTvPIScvZyOiKANifMz3yMD5w2vAf1pxzMWV6fj5X/kzjV5r0KGNcQ9SUQNOmZp88uJ3z3LSxgVdVSnbwSgHUo9wmJkr14y/NJJ8NJI4aroIoRXT4KeXeAnG2Ua5wC2RA08i9zYfGXyOoniyZKPiIWYj294cmOsOJiCM4f1IAl4kD2UnlF69S1aa8q4He0u0mwu6WON9rSWmDemSWtZu8qRlPHhcSPjyCJvOZtWFJhScWg1fJy9YWAGdzAJlxawFOn8QjQ/HqG/Nd1W61FplwQ9GC8+yw2Qmrn9i89MYKYGzhdmeYTPmtyDRfQYTq3v7mbhiLU6+vShPCv6qbU4B3tNyWFTGyewLBNajIOme8sMRqxa1wEmMdJhH6vjzJG3jWY/SW5KHCiyehDuUxmzELaWjXTm6luBpxWYzcr4/FcqSXgUImCtg8D4kKaL8LhTKbo4IYC9oZCUeGmqvPbMxmlGQIxew==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(136003)(39860400002)(376002)(451199015)(40470700004)(46966006)(36840700001)(36756003)(110136005)(83380400001)(40460700003)(7696005)(8676002)(41300700001)(82740400003)(86362001)(478600001)(8936002)(36860700001)(54906003)(316002)(186003)(2906002)(4326008)(7636003)(356005)(426003)(70586007)(82310400005)(1076003)(70206006)(40480700001)(26005)(2616005)(5660300002)(6636002)(336012)(6666004)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 15:30:51.5024
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b05abe61-a3e3-476e-2861-08dad3b10798
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E62F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5146
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

Before a SAVE command is issued, a QUERY command is issued in order to
know the device data size.
In case PRE_COPY is used, the above commands are issued while the device
is running. Thus, it is possible that between the QUERY and the SAVE
commands the state of the device will be changed significantly and thus
the SAVE will fail.

Currently, if a SAVE command is failing, the driver will fail the
migration. In the above case, don't fail the migration, but don't allow
for new SAVEs to be executed while the device is in a RUNNING state.
Once the device will be moved to STOP_COPY, SAVE can be executed again
and the full device state will be read.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  | 27 ++++++++++++++++++++++++++-
 drivers/vfio/pci/mlx5/cmd.h  |  2 ++
 drivers/vfio/pci/mlx5/main.c |  6 ++++--
 3 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 993749818d90..01ef695e9441 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -84,6 +84,19 @@ int mlx5vf_cmd_query_vhca_migration_state(struct mlx5vf_pci_core_device *mvdev,
 		ret = wait_for_completion_interruptible(&mvdev->saving_migf->save_comp);
 		if (ret)
 			return ret;
+		if (mvdev->saving_migf->state ==
+		    MLX5_MIGF_STATE_PRE_COPY_ERROR) {
+			/*
+			 * In case we had a PRE_COPY error, only query full
+			 * image for final image
+			 */
+			if (!(query_flags & MLX5VF_QUERY_FINAL)) {
+				*state_size = 0;
+				complete(&mvdev->saving_migf->save_comp);
+				return 0;
+			}
+			query_flags &= ~MLX5VF_QUERY_INC;
+		}
 	}
 
 	MLX5_SET(query_vhca_migration_state_in, in, opcode,
@@ -442,7 +455,10 @@ void mlx5vf_mig_file_cleanup_cb(struct work_struct *_work)
 		mlx5vf_put_data_buffer(async_data->buf);
 		if (async_data->header_buf)
 			mlx5vf_put_data_buffer(async_data->header_buf);
-		migf->state = MLX5_MIGF_STATE_ERROR;
+		if (async_data->status == MLX5_CMD_STAT_BAD_RES_STATE_ERR)
+			migf->state = MLX5_MIGF_STATE_PRE_COPY_ERROR;
+		else
+			migf->state = MLX5_MIGF_STATE_ERROR;
 		wake_up_interruptible(&migf->poll_wait);
 	}
 	mutex_unlock(&migf->lock);
@@ -511,6 +527,8 @@ static void mlx5vf_save_callback(int status, struct mlx5_async_work *context)
 	 * The error and the cleanup flows can't run from an
 	 * interrupt context
 	 */
+	if (status == -EREMOTEIO)
+		status = MLX5_GET(save_vhca_state_out, async_data->out, status);
 	async_data->status = status;
 	queue_work(migf->mvdev->cb_wq, &async_data->work);
 }
@@ -534,6 +552,13 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	if (err)
 		return err;
 
+	if (migf->state == MLX5_MIGF_STATE_PRE_COPY_ERROR)
+		/*
+		 * In case we had a PRE_COPY error, SAVE is triggered only for
+		 * the final image, read device full image.
+		 */
+		inc = false;
+
 	MLX5_SET(save_vhca_state_in, in, opcode,
 		 MLX5_CMD_OP_SAVE_VHCA_STATE);
 	MLX5_SET(save_vhca_state_in, in, op_mod, 0);
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index 7729eac8c78c..5483171d57ad 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -17,6 +17,7 @@
 
 enum mlx5_vf_migf_state {
 	MLX5_MIGF_STATE_ERROR = 1,
+	MLX5_MIGF_STATE_PRE_COPY_ERROR,
 	MLX5_MIGF_STATE_PRE_COPY,
 	MLX5_MIGF_STATE_SAVE_LAST,
 	MLX5_MIGF_STATE_COMPLETE,
@@ -157,6 +158,7 @@ struct mlx5vf_pci_core_device {
 
 enum {
 	MLX5VF_QUERY_INC = (1UL << 0),
+	MLX5VF_QUERY_FINAL = (1UL << 1),
 };
 
 int mlx5vf_cmd_suspend_vhca(struct mlx5vf_pci_core_device *mvdev, u16 op_mod);
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index b8662cfd3a59..8c3ccd29e01a 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -219,6 +219,7 @@ static ssize_t mlx5vf_save_read(struct file *filp, char __user *buf, size_t len,
 		if (wait_event_interruptible(migf->poll_wait,
 				!list_empty(&migf->buf_list) ||
 				migf->state == MLX5_MIGF_STATE_ERROR ||
+				migf->state == MLX5_MIGF_STATE_PRE_COPY_ERROR ||
 				migf->state == MLX5_MIGF_STATE_PRE_COPY ||
 				migf->state == MLX5_MIGF_STATE_COMPLETE))
 			return -ERESTARTSYS;
@@ -238,7 +239,8 @@ static ssize_t mlx5vf_save_read(struct file *filp, char __user *buf, size_t len,
 		if (first_loop_call) {
 			first_loop_call = false;
 			/* Temporary end of file as part of PRE_COPY */
-			if (end_of_data && migf->state == MLX5_MIGF_STATE_PRE_COPY) {
+			if (end_of_data && (migf->state == MLX5_MIGF_STATE_PRE_COPY ||
+				migf->state == MLX5_MIGF_STATE_PRE_COPY_ERROR)) {
 				done = -ENOMSG;
 				goto out_unlock;
 			}
@@ -431,7 +433,7 @@ static int mlx5vf_pci_save_device_inc_data(struct mlx5vf_pci_core_device *mvdev)
 		return -ENODEV;
 
 	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev, &length,
-						    MLX5VF_QUERY_INC);
+				MLX5VF_QUERY_INC | MLX5VF_QUERY_FINAL);
 	if (ret)
 		goto err;
 
-- 
2.18.1

