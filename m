Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74095642AB6
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 15:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbiLEOug (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 09:50:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231909AbiLEOu2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 09:50:28 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2049.outbound.protection.outlook.com [40.107.223.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFCB61C421
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 06:50:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XJoFAh6Phml/nmTHKB8KJ0x5VnX4loP7qATlJprvTivKM6uB3PLlbTXCIiJQ+xkCE1yzf9yXADuu5k385xwu1/ZsizMPso4xstwNk4nvQHnHLEl9qsXc9/z6gDdwnOa+GuFUbG489KBAz96kIsCUe7w04um39BB/75fW/WA2DsfXsbRLKRc7OzD/sywh3PW0snf+87CCgqzZyjPgZqNslLNS/8KogH90eJA+fzlwoyF+RvjkF5Fvnpy9uCDLuVCMCcXF7QaH9pU0Wy2zfY0uo12bR2ZsgpntGnLVihMsXk+toEfPoOSNb2GptjXxWJxPQG/iatqAzUty4zi2EeADbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fOTvfA4xju10qzMIaregSF5Vk0iYMrpnX+eQOxYRLQ0=;
 b=RDfr8aGU+0NruIY7ANGVvAYzHX++bgq3NoHWkDWWdsfAAITDZ3iaYDw9GJ4kEcZEYQkaDtqxeIw2ERUTnu/fLTWjiUxQsgXcYbMoOnh9SlW68zzktW+dLIa04yryObunCiiXHxXBwawALcpLg90Ik+oMu5IU46H9Slcm8No7WEUBPqL0bNWJQY9FdPejL3bZdv+ymUmRDIAHWGxh468cEH1G7TKPF+oCuJZAsv34ysiUEQvmEE8ymB8NNuslEh3U3VHoYqLr5h+5yK8eKg7esaXWROFEx3qOfgyVGNTRuAlV8LBElPpOfn4F7p/TAMz5ufgMu8k32pUkyI4GxOi3EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fOTvfA4xju10qzMIaregSF5Vk0iYMrpnX+eQOxYRLQ0=;
 b=S4vKZyTP4s/msZ9IemjfsvYPdvx62dfrlPSqkmsTed7FmF8+moTM1x4uDItlsWC1F1cIZrLIXhC8PfeELzvafbq+DDgJ1ogpZRvuhfojSsuw9hRgcewkITkqdkvLVQVQQ/ZiGoxMbHRpZ75D1IhipW/wBEe4LlRjrhIVHBfo6IPetNAIpCyJguL8xbu2+l9Ii6dU5PcGXkbXyrF5/iePYyQ6z0CzhjJjOB+dIsv5M93zgYGG8anlkGKxp3tqHFYIis/mfujoeVxoDmAVhDfagstUTS2PLM4TZK7Cf1xiLN+NtzzdH5Ot7X4FgHS5mZZDJJScNmxO6vDTusx6i8HlkA==
Received: from BN9PR03CA0498.namprd03.prod.outlook.com (2603:10b6:408:130::23)
 by PH8PR12MB7327.namprd12.prod.outlook.com (2603:10b6:510:215::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Mon, 5 Dec
 2022 14:50:09 +0000
Received: from BL02EPF00010207.namprd05.prod.outlook.com
 (2603:10b6:408:130:cafe::3e) by BN9PR03CA0498.outlook.office365.com
 (2603:10b6:408:130::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Mon, 5 Dec 2022 14:50:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF00010207.mail.protection.outlook.com (10.167.241.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8 via Frontend Transport; Mon, 5 Dec 2022 14:50:09 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 5 Dec 2022
 06:49:53 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 5 Dec 2022
 06:49:52 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Mon, 5 Dec
 2022 06:49:49 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V3 vfio 13/14] vfio/mlx5: Fallback to STOP_COPY upon specific PRE_COPY error
Date:   Mon, 5 Dec 2022 16:48:37 +0200
Message-ID: <20221205144838.245287-14-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221205144838.245287-1-yishaih@nvidia.com>
References: <20221205144838.245287-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00010207:EE_|PH8PR12MB7327:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a313639-8632-4d12-52b4-08dad6d001b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: todedplQchktTFsFAO5WYDdZTLweZBwViHHYf6vX8rHcywZ8b/zSRsJhBKIytvCLPF+cLwI/MvblskBesN0Qm71kLuts688wx+I9VsDtmOs6zpOmictr26CvGWpl3JR9GSqSpyt8VTvAuMsa5ysHvXidzttF6cLKSzolqxyTZMlaX+zfrNE7mAh1Q0+vhyAhpGnTYfLYTBv1VsJeVfXPgvrB5KIvL4hU1ZzEW/XqQlJlNLYYHnRp0tFnBiYXuAZrIY2MCEiyhbE/Q6H+VFNqM/eBxp2s6cWTDupgbJTngjTdpWYHLCsPp1nJOzE1RohPcFWvyhs4ODVep9hM8unMKesZQw4Eh+cwhMuvb8Bq1oIMDpDGLDk4pfxlVgpKnrYco217zBLZlQFUA8O1DGYOmXOse1B1OJuLbC9b3/54G9b4I6Y1UOk5D92iuTVWy78uZ/+yk1KjEgDBGQrsgyxAdzwPU4qNLNVrtOfF/vQBxIh+qkYMevRxzsicFdD556NCHUbpekdvvJSwu8Kg3DGHKfof9Dw+7EeKAmja+DmWuNWl9YzgrNwpyOmJqOwqffyj02NvrmCWq+GB1GOVKejQmaUvBAzAO6CXRwY/usAhJzFIejxoMtFRzRG5t0p+CqnUt/EWgOSwk8odkzLL/2pBm//Z2pgZJF2iMY3hzbr31xEwIXEfOQ+ea+g9vs1T08IDktCz5wyPF4b0VInFL65reg==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(39860400002)(396003)(136003)(451199015)(36840700001)(46966006)(40470700004)(36756003)(70206006)(8676002)(4326008)(70586007)(8936002)(110136005)(40460700003)(54906003)(7636003)(6636002)(2906002)(316002)(82310400005)(47076005)(2616005)(336012)(82740400003)(1076003)(426003)(83380400001)(186003)(36860700001)(40480700001)(86362001)(356005)(478600001)(7696005)(26005)(6666004)(41300700001)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 14:50:09.4452
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a313639-8632-4d12-52b4-08dad6d001b4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF00010207.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7327
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
index 30365b52e530..88f36793f841 100644
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

