Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7B15637E7F
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 18:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbiKXRlS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 12:41:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiKXRlH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 12:41:07 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2064.outbound.protection.outlook.com [40.107.243.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF6813C707
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 09:41:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VyvBXJ+hlRA5CuGYjNy7jSklgYa9M/X+04T5lS5mZxYhCnd9O9cSchOIarS1NuLNRwQxTEC6IlesVub6qxg+EBnqpylOlp05KzoO5xGpvLmGOKZXn3O3Y2SDXp2mMzbFzht14WifwQ9k8YQIyO2LM5fTnFB1K7F9LMjq/HtsIP8wSo5Wza14enkLR3d2t3Vfoy0ong5tiuBUmg6MNd+PTRFlD0tT4xvPstsj25vxNRdXYF0HdyK01N29weGmu6K8t3s9+2shB0Aqo4YF1unbYvZptQ6/nIbrycCLglVZ6T3kPbHbSunhB2FC+8SwYDe/+Xhzp/3Ger7YzdGIRWLUjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lChmR0EjT2JYvf5s+0aX8se3MpR/4+HS1LVBpOCGRgA=;
 b=VowIu94HDNjjS/5PYSe2EgNaiAblYNZt2uwyreWvppQKUVAJHK0qsZBOy0KFR9oQwo4/VoVnxr2VaodsBPfOT24g2Wf2Vun6ABKHfBUDc0pbjVb2bVIJcICD6G52+NgcfEVWBuuQRyL2WkvPlddpeus3BRAxpOkNke0BfJ2mV+GuVnHQLNTRpyKPyaUSL2ifDdU6riaf0OGw4XFrhpERyOdTvpCn1+XW7cv7gQLgDiuvdOFd6nPF53wkDJjiyYwMZBB5UMWTznAVvTq1DZ7KbbszXiPHlFesiK0pGaVmn8nt+iN4FGYuj5B+FLUBwTJg6Y2uwlrQgkcBmSfo6uXazg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lChmR0EjT2JYvf5s+0aX8se3MpR/4+HS1LVBpOCGRgA=;
 b=Zzd0RWdSshF7tbiaHHWajOGezHhHW7a+kKJpYpmvH//562sBi6RwIQJLEyY4w1glbcw0eh2np3Ax/qWOZCDuntieJNzqP5rp0NJtHJK9SSzXdWwsgjFPHARxdLkgwRSSk0oCxZLoz8bdFS3kK/ZM6r+GGnKyEDGe3clEQ7QRErEyLlBJKgV/8ypNh9XsAgAXL6Xu+KqeAMxby1Rm1g5RSOxBfpNaczHvNfoV2YK2fRrO30kVlUQeLuQA+7IZ0E8yyNMOa6UHxOnLB8RPk6Y2F8jHr5qJqQ6VHrb+ZiQxknfye0cZO1yhdGpMuJlT4r6uGq//qwQqrpQjAH2cZm26Jg==
Received: from MW4PR04CA0243.namprd04.prod.outlook.com (2603:10b6:303:88::8)
 by LV2PR12MB6013.namprd12.prod.outlook.com (2603:10b6:408:171::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Thu, 24 Nov
 2022 17:41:04 +0000
Received: from CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:88:cafe::53) by MW4PR04CA0243.outlook.office365.com
 (2603:10b6:303:88::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19 via Frontend
 Transport; Thu, 24 Nov 2022 17:41:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1NAM11FT058.mail.protection.outlook.com (10.13.174.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.8 via Frontend Transport; Thu, 24 Nov 2022 17:41:03 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 24 Nov
 2022 09:41:03 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 24 Nov 2022 09:41:03 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Thu, 24 Nov 2022 09:40:59 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>
Subject: [PATCH V1 vfio 13/14] vfio/mlx5: Fallback to STOP_COPY upon specific PRE_COPY error
Date:   Thu, 24 Nov 2022 19:39:31 +0200
Message-ID: <20221124173932.194654-14-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221124173932.194654-1-yishaih@nvidia.com>
References: <20221124173932.194654-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT058:EE_|LV2PR12MB6013:EE_
X-MS-Office365-Filtering-Correlation-Id: a7df6397-6ec0-49a5-b047-08dace430f20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o5dpeFOROHjRnnVh5sCgeaOqNoydM75sm1Cb5eUKpFqQlKSisghxaHg80kVYFtZiG5Enj5wEhzNp6iR2Wnr5F9WMJHVnWny2douM/f/dDeghwYeJCEimSAiUVqrR5x8rnZddP8f8fvMuQXgMUmH068datv/69Q1GSaIraEIuULLNDHUY+TkmVEsQYfimyYz+tYMS7hIzBsCCdfN7FkEiICH6TzBj+7CPLJeBDtpkswN2mZavPe0kryyxHcIQZRLU6jO0uqhNwe2G0OT5RQdSmP6zdkkJemgCW2Y6Q2KAVKEsscJgytTgvDhDFS3HLTBWscleofsdjOxtzXUv0+eNlFKwbbTLl5a/VdJwet+g7A2inxNljjKMFnnCNIUByoHsVftZ06gZidWUCWoMSffpqVtxqpnxZ5xHKDLxvLfaT7lvVglEk8c01OULf7OI33Ytdx5PCykFdZe8lfRCDTmn4y9JywZY2MZS0IYgvX5Ijbw4FH7ATUtr0/20dshq2nhG8GUTYYjtOpfDDBnVNCluDTV/QKggxapAWu7AmIYfjha58p+IiNKOHOLAMt+x9c3xb+lxUSl53DwhwAIAzjA/3ApCxx8dStXVh1gDVagCJWCwDUdGkIKEUwX17jHedEnDH1g9vg42s1luAknSEbNJ3whB2zr5VsiCRUDsyt519DuWNzE4HvNmSYRwHHH+FKZtbLqQzhF6T6zx+WHfpp01XA==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(39860400002)(396003)(136003)(451199015)(36840700001)(40470700004)(46966006)(36756003)(36860700001)(86362001)(47076005)(82740400003)(26005)(5660300002)(336012)(40480700001)(2906002)(83380400001)(186003)(426003)(1076003)(40460700003)(356005)(7636003)(2616005)(7696005)(82310400005)(70206006)(8676002)(4326008)(41300700001)(110136005)(6636002)(54906003)(8936002)(478600001)(6666004)(316002)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2022 17:41:03.7340
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a7df6397-6ec0-49a5-b047-08dace430f20
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB6013
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
 drivers/vfio/pci/mlx5/cmd.c  | 26 +++++++++++++++++++++++++-
 drivers/vfio/pci/mlx5/cmd.h  |  2 ++
 drivers/vfio/pci/mlx5/main.c |  6 ++++--
 3 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 49a852a84283..a1dca065b977 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -84,6 +84,18 @@ int mlx5vf_cmd_query_vhca_migration_state(struct mlx5vf_pci_core_device *mvdev,
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
+				return 0;
+			}
+			query_flags &= ~MLX5VF_QUERY_INC;
+		}
 	}
 
 	MLX5_SET(query_vhca_migration_state_in, in, opcode,
@@ -442,7 +454,10 @@ void mlx5vf_mig_file_cleanup_cb(struct work_struct *_work)
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
@@ -511,6 +526,8 @@ static void mlx5vf_save_callback(int status, struct mlx5_async_work *context)
 	 * The error and the cleanup flows can't run from an
 	 * interrupt context
 	 */
+	if (status == -EREMOTEIO)
+		status = MLX5_GET(save_vhca_state_out, async_data->out, status);
 	async_data->status = status;
 	queue_work(migf->mvdev->cb_wq, &async_data->work);
 }
@@ -534,6 +551,13 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
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
index 5ba094cabb2d..11a6e99a0bc9 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -14,6 +14,7 @@
 
 enum mlx5_vf_migf_state {
 	MLX5_MIGF_STATE_ERROR = 1,
+	MLX5_MIGF_STATE_PRE_COPY_ERROR,
 	MLX5_MIGF_STATE_PRE_COPY,
 	MLX5_MIGF_STATE_SAVE_LAST,
 	MLX5_MIGF_STATE_COMPLETE,
@@ -154,6 +155,7 @@ struct mlx5vf_pci_core_device {
 
 enum {
 	MLX5VF_QUERY_INC = (1UL << 0),
+	MLX5VF_QUERY_FINAL = (1UL << 1),
 };
 
 int mlx5vf_cmd_suspend_vhca(struct mlx5vf_pci_core_device *mvdev, u16 op_mod);
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 0caaf4e8e1e9..0976fadf212d 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -222,6 +222,7 @@ static ssize_t mlx5vf_save_read(struct file *filp, char __user *buf, size_t len,
 		if (wait_event_interruptible(migf->poll_wait,
 				!list_empty(&migf->buf_list) ||
 				migf->state == MLX5_MIGF_STATE_ERROR ||
+				migf->state == MLX5_MIGF_STATE_PRE_COPY_ERROR ||
 				migf->state == MLX5_MIGF_STATE_PRE_COPY ||
 				migf->state == MLX5_MIGF_STATE_COMPLETE))
 			return -ERESTARTSYS;
@@ -241,7 +242,8 @@ static ssize_t mlx5vf_save_read(struct file *filp, char __user *buf, size_t len,
 		if (first_loop_call) {
 			first_loop_call = false;
 			/* Temporary end of file as part of PRE_COPY */
-			if (end_of_data && migf->state == MLX5_MIGF_STATE_PRE_COPY) {
+			if (end_of_data && (migf->state == MLX5_MIGF_STATE_PRE_COPY ||
+				migf->state == MLX5_MIGF_STATE_PRE_COPY_ERROR)) {
 				done = -ENOMSG;
 				goto out_unlock;
 			}
@@ -434,7 +436,7 @@ static int mlx5vf_pci_save_device_inc_data(struct mlx5vf_pci_core_device *mvdev)
 		return -ENODEV;
 
 	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev, &length,
-						    MLX5VF_QUERY_INC);
+				MLX5VF_QUERY_INC | MLX5VF_QUERY_FINAL);
 	if (ret)
 		goto err;
 
-- 
2.18.1

