Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4C9643ED1
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 09:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234364AbiLFIgv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 03:36:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234271AbiLFIgU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 03:36:20 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2054.outbound.protection.outlook.com [40.107.244.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA791DDF9
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 00:36:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KNta6iEqAb/PCpGTjR+f5rJBB1eZ2hZbLKByl0C+NXx5JUF9QVikBZIK+JMadzlcxIq8LShcElh1oaLOXHM3LY5ucSIOgfNS40doCvTbQTh/IX7abiEm0MAUzxfpWzD/fBpGrbAurcEDepQYAOwbxDpfH+dFlTFyO3Y522Urhq8v9Y0jf4zgY+/fQOM5YRYkXZ5vuk1jLpaXEPxPIRXJobZ7WJTLz14uJSh9M49RL8bKY1dRfq1uLh2rpT2L4g93v5093tQ2MI85yey1/N1km+/9ECXcHk2kqOPJpbWCL5iWgKxvD1ssyuLoBGDT77BEIBwTPxGEN/Kdp17OhcBq+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0oOcNxrT1tW1cZ0Xa8Xot4lfp6aDs7AsQfBGvo1ppWg=;
 b=KVZNnJn9/kh/QFi6Y4mWWbcbbxaKrCmK9HRcAkBeI/rgwGJfcw+9hY1eB9/1WisB0Z2WIv71WA3Y2BTBF4B54QfxOURf0s2khnsREFWf0ChXuEyn+d99mI9pEWIpvu+SZas5oIh3Oxdzzgts6WsUVFHLXmus7vEuyH4uTgjWE38Z16G4+NFCbD2uCK+NO0Ha6zGlO9CEra73Ackc2Lgphx9TiKb1+VhDtKZiYdsKdzt+AQEop1EpkIHTkOQ/d0Ebv1eheNKsOBNiHPU/QNf15iTTQets8KyM7qo7vwEYF+3mwtMwmslTQzfwNpydeCrtwODRvQkeqnOF6LClTfFdBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0oOcNxrT1tW1cZ0Xa8Xot4lfp6aDs7AsQfBGvo1ppWg=;
 b=DwohK2ACiyiyeN5qVJQwErWiWpl3+BW46Pa8QGQFOyxndOXTwgg+c1Bk3x4Vehj5uvLib/VxrLU0nPq3kXlPSmtePHfg1fg8clKiN5PyZ2swkWFceQkyIyvE/ONA9SLksvwJYgoe6heRFxtQ0Zwi/ot1fgcXc8QjcgJdBsM+LKm8hvNz8hlW7wQT8m0j3ij6HYltC5W9QWrcAi5GnctIqf+7njo6cKir+FCbEhInFaDvwvKKlN9K+5Um/z3WWzPGIc5Kd4ZX3HilXJIbMRnbkTQ++mS3Iqh3G35w9vIbpYsDNUeARHZo9FMgNzdPk6bF/MFddYMrRiwY471gh5F1mw==
Received: from MN2PR02CA0019.namprd02.prod.outlook.com (2603:10b6:208:fc::32)
 by DM6PR12MB4139.namprd12.prod.outlook.com (2603:10b6:5:214::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 08:36:08 +0000
Received: from BL02EPF00010209.namprd05.prod.outlook.com
 (2603:10b6:208:fc:cafe::91) by MN2PR02CA0019.outlook.office365.com
 (2603:10b6:208:fc::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Tue, 6 Dec 2022 08:36:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL02EPF00010209.mail.protection.outlook.com (10.167.241.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8 via Frontend Transport; Tue, 6 Dec 2022 08:36:08 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 6 Dec 2022
 00:35:57 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 6 Dec 2022 00:35:56 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Tue, 6 Dec 2022 00:35:54 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V4 vfio 13/14] vfio/mlx5: Fallback to STOP_COPY upon specific PRE_COPY error
Date:   Tue, 6 Dec 2022 10:34:37 +0200
Message-ID: <20221206083438.37807-14-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221206083438.37807-1-yishaih@nvidia.com>
References: <20221206083438.37807-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00010209:EE_|DM6PR12MB4139:EE_
X-MS-Office365-Filtering-Correlation-Id: 4094f2a4-326a-42a8-caa3-08dad764ec62
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zvEAgguj/M3ebV9aI9a6O+zq1Ti0+5cU8YjRX+qr+JAsnXcofWgd0sTetPcnpM+3Ya3ymFb4J5X7DLwqcj266aYX7/zjTpA64rVXgUTzhxWKrbUCS1T2d75fLL0Xaqhgv6GGyJv8zmO9++sTrDhVgCM86F4WJOQbV6bHZbSu5YQXZYQ9jrxAYrRR6jDTuD/UDxJHdNdn6GpJoPVrHuf9DKbMOK2x+S8pl4g8tSHr6f0Ebg6o9QQj6OzcIGbCy7whJfepz3q9Jv9z2bJBUQ8zmQ39Y6ZUfbo41Vh4qEiURDllr36pQP+EwmV+zHAtmJxDIBX8xcE250FQGy3Zl+Y2X6kIX3szTr0f4taQY4KvefWpKmJNSgNFCtC7fUlavFn+C6L9nlXlPXQmjvGERvHL3GiEdt3b0C4gqMmyB4S3xaN4glYSG1F6QQ7jlht+mGMzkVu9iyJHmi8Gr0XDO8aAYgy72VXML5RYebGGkqyswHGaeZmrn4i+9SiAHrT6qtQSS0BK+V/JfxinQsimKBFviMHZBZG2qT2aioR2QIAcGexhma746HxJG3ihDTkPuJPH45K73Waoq+En6gykpPZEnFj/v6faC0geEeTnSRR2S51cOyuO8SpnFxkMNnjuuzDhHRIO26eC6AqofkjJvxt5cF9aRZP/Gb8kVoBKQM0ur2jt1VIBP3eVAZuU5slrhc5iu9ViA/11n62JpnH7qVBXeQ==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(346002)(136003)(376002)(451199015)(40470700004)(36840700001)(46966006)(40480700001)(356005)(7636003)(6666004)(82740400003)(36756003)(426003)(86362001)(40460700003)(316002)(54906003)(478600001)(6636002)(2906002)(5660300002)(8676002)(41300700001)(70586007)(8936002)(4326008)(36860700001)(70206006)(83380400001)(82310400005)(2616005)(26005)(47076005)(7696005)(110136005)(186003)(1076003)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 08:36:08.7070
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4094f2a4-326a-42a8-caa3-08dad764ec62
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF00010209.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4139
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
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
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
index 5a669b73994a..cd90eb86128c 100644
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

