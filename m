Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCF65643ECA
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 09:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232099AbiLFIgc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 03:36:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233637AbiLFIgA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 03:36:00 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2047.outbound.protection.outlook.com [40.107.94.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A781BE86
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 00:35:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O3qUytBeSY0L3m67MpZ7WStr44efWETOx528GDRGTLPVSc0yLedPsgqcjHkJ/S0xfr/jfrK+czXiZ+JGUthX60fUH9DIjQRMer6gFrmy5EncU8UvfEuX5q5iHXeRYvPY17eBcP/N2Y/b0ZtxVUYhgPreme0ZTP+CUPOHzHKj2KPyOHA51LnrFcBeHzMbId9uCeySXAs6qhEEnx8l7ddjXW8awKkiFZuh2lFSNPMiPYZqj05SI8Hn5JtE93SRzXMmxpYgIZN70QPz+z6LhI2RH6DNpFBIAUov5H0zRRI9d//Yfz/E62yyvgt+C6TbBwueJfOZ93foAu3tCPfF3xId0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PdEkCmgLeKm3w5mcdoKZQXJXayGVnWJqzv1f+Y6dQHw=;
 b=Of+1MWsDWDWB10NCPvmbhYBAM72OWyiMIg7mEJ7FuvJaCJleNHH3o6hB8HcReUCAxGe4zlMXhxK/HStHtsyYxUZNZw3napidtJPpYAmCkNj+019sqW5ra1ZrQMGOgvFF/j+hcTcVlFQme8OaBsiy4ZLtAwnqjdH150AVhKuDfUvT55EaxXEIzje+6Y26T6jRPmEDPtBAhRwowT8fTMgbsvSEW7be5yC8cuyknUmbnQzGhgOgA2jvbd4o09JJZMgRG7EPgI36nK5VDdAPK4sPBhzH7LGa386qSU0cwoC23FyQ37we00jl9v4W+XBgo+YA+MEiG3zqNEKWanHQMQsKHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PdEkCmgLeKm3w5mcdoKZQXJXayGVnWJqzv1f+Y6dQHw=;
 b=HWDKyJHIAgBDnp7YSWxjtis7kjuycGX+WMvp9IqmEe9s889cZesACJikmI/JwalUx4KmuFiCZJwAXpqd3GFTZJtff6ugQqRJE0mlN1SN4PEGlwTMz5d0CghHDn4DuADR9PUkqMSVtcDAB2Wfd3wqbOXleAQRXcbtmNpOXa0fwdiWQC0/PiLXlo3JtJF9jom6fI+jdTTq0GXPUyPjrUaqz8l2vtlQ8d8FHKO1oyEt0HjLzw6YPvMy2Il8sB6Zh9Z9E5JflgflTCgo/23aKCFvVxChZk8kIMiSWcWJeFUkkQiuR2T2ByrivJvsSfmTPf697aOLZApH+BxXyQTFi+Cj8w==
Received: from DS7PR06CA0017.namprd06.prod.outlook.com (2603:10b6:8:2a::24) by
 CY5PR12MB6060.namprd12.prod.outlook.com (2603:10b6:930:2b::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14; Tue, 6 Dec 2022 08:35:54 +0000
Received: from CY4PEPF0000C97D.namprd02.prod.outlook.com
 (2603:10b6:8:2a:cafe::99) by DS7PR06CA0017.outlook.office365.com
 (2603:10b6:8:2a::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Tue, 6 Dec 2022 08:35:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CY4PEPF0000C97D.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8 via Frontend Transport; Tue, 6 Dec 2022 08:35:54 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 6 Dec 2022
 00:35:39 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 6 Dec 2022 00:35:39 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Tue, 6 Dec 2022 00:35:36 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V4 vfio 08/14] vfio/mlx5: Introduce device transitions of PRE_COPY
Date:   Tue, 6 Dec 2022 10:34:32 +0200
Message-ID: <20221206083438.37807-9-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221206083438.37807-1-yishaih@nvidia.com>
References: <20221206083438.37807-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C97D:EE_|CY5PR12MB6060:EE_
X-MS-Office365-Filtering-Correlation-Id: d180ea82-53fc-4a67-ec59-08dad764e3af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f2WRxbKZJqeZbgGAKWhAllr5Q15Kc2FSQmbItROj3hGNZyN3Iozkrs1nCDspvBpW6vX0QeI4vTyz2Qdm8yY7No1ISEzjiU1NOPktPn8XGyKraJFOJSNUMWmEjfp88cx1dzT1eJ1ayVYE+FbSowywyTaNrk2apwMVkkbhk6hNMgv19wnTAPKdAw8rY51gO/QcGwGHR71eEXDnQXmip8FlqJn+WZDi3nnQ2EIVnpRLW+1GxM8i/44jW6wCC2feW0WJSKHcjhBtwLWTgnZ0g0RF0uZOWqf5ZIFv4hBqsZyiCZ4HCgtNXBNxUv8LoEQPOeTA8t/Kfx/zajCPp2XaRiVyYcEbGJbhMuu2QW+LXkQGgjQVXHJOHq6SXsqAKBBgoMShDwRUP6+vUP9MZ9wKiIoEguBEwqcDqVdsD9LhhaAGNPwrWtO3t93sJPqrceLih7kGkmKAdpm1wixBLOGb5tQsiYcAVb8+OaJw93nMV9uUOJ17VrjUzDlFj0igXg/ho0h2ezA10/eWyq3jumcF1hS4DR6ui8y/6UJQxhosRqZxyeBttNCI2gix7yV9mrsBzFIIiVc8x2Gz9zI81OA5GWwhV+fsifJ59C1+pFRPmPuRqR9ot77kGw3lg4zRZsfHVcmvVx1csjDhRAh16HF9LsPY7dtmbl1rION04ZA0PzRgkCpK6AZP8oJk0xMtrR3ja3WW7dxuoUsHWvNkd1Z007KIDA==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(39860400002)(396003)(376002)(451199015)(40470700004)(36840700001)(46966006)(6666004)(7696005)(478600001)(26005)(40480700001)(54906003)(110136005)(6636002)(70206006)(70586007)(8676002)(316002)(4326008)(47076005)(336012)(5660300002)(7636003)(82740400003)(41300700001)(356005)(8936002)(86362001)(426003)(1076003)(186003)(2616005)(83380400001)(36860700001)(2906002)(36756003)(30864003)(82310400005)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 08:35:54.1911
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d180ea82-53fc-4a67-ec59-08dad764e3af
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C97D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6060
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to support PRE_COPY, mlx5 driver is transferring multiple
states (images) of the device. e.g.: the source VF can save and transfer
multiple states, and the target VF will load them by that order.

The device is saving three kinds of states:
1) Initial state - when the device moves to PRE_COPY state.
2) Middle state - during PRE_COPY phase via VFIO_MIG_GET_PRECOPY_INFO.
   There can be multiple states of this type.
3) Final state - when the device moves to STOP_COPY state.

After moving to PRE_COPY state, user is holding the saving migf FD and
can use it. For example: user can start transferring data via read()
callback. Also, user can switch from PRE_COPY to STOP_COPY whenever he
sees it fits. This will invoke saving of final state.

This means that mlx5 VFIO device can be switched to STOP_COPY without
transferring any data in PRE_COPY state. Therefore, when the device
moves to STOP_COPY, mlx5 will store the final state on a dedicated queue
entry on the list.

Co-developed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  | 96 +++++++++++++++++++++++++++++++++---
 drivers/vfio/pci/mlx5/cmd.h  | 16 +++++-
 drivers/vfio/pci/mlx5/main.c | 90 ++++++++++++++++++++++++++++++---
 3 files changed, 184 insertions(+), 18 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 0e36b4c8c816..5fcece201d4c 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -14,18 +14,36 @@ _mlx5vf_free_page_tracker_resources(struct mlx5vf_pci_core_device *mvdev);
 
 int mlx5vf_cmd_suspend_vhca(struct mlx5vf_pci_core_device *mvdev, u16 op_mod)
 {
+	struct mlx5_vf_migration_file *migf = mvdev->saving_migf;
 	u32 out[MLX5_ST_SZ_DW(suspend_vhca_out)] = {};
 	u32 in[MLX5_ST_SZ_DW(suspend_vhca_in)] = {};
+	int err;
 
 	lockdep_assert_held(&mvdev->state_mutex);
 	if (mvdev->mdev_detach)
 		return -ENOTCONN;
 
+	/*
+	 * In case PRE_COPY is used, saving_migf is exposed while the device is
+	 * running. Make sure to run only once there is no active save command.
+	 * Running both in parallel, might end-up with a failure in the save
+	 * command once it will try to turn on 'tracking' on a suspended device.
+	 */
+	if (migf) {
+		err = wait_for_completion_interruptible(&migf->save_comp);
+		if (err)
+			return err;
+	}
+
 	MLX5_SET(suspend_vhca_in, in, opcode, MLX5_CMD_OP_SUSPEND_VHCA);
 	MLX5_SET(suspend_vhca_in, in, vhca_id, mvdev->vhca_id);
 	MLX5_SET(suspend_vhca_in, in, op_mod, op_mod);
 
-	return mlx5_cmd_exec_inout(mvdev->mdev, suspend_vhca, in, out);
+	err = mlx5_cmd_exec_inout(mvdev->mdev, suspend_vhca, in, out);
+	if (migf)
+		complete(&migf->save_comp);
+
+	return err;
 }
 
 int mlx5vf_cmd_resume_vhca(struct mlx5vf_pci_core_device *mvdev, u16 op_mod)
@@ -45,7 +63,7 @@ int mlx5vf_cmd_resume_vhca(struct mlx5vf_pci_core_device *mvdev, u16 op_mod)
 }
 
 int mlx5vf_cmd_query_vhca_migration_state(struct mlx5vf_pci_core_device *mvdev,
-					  size_t *state_size)
+					  size_t *state_size, u8 query_flags)
 {
 	u32 out[MLX5_ST_SZ_DW(query_vhca_migration_state_out)] = {};
 	u32 in[MLX5_ST_SZ_DW(query_vhca_migration_state_in)] = {};
@@ -59,6 +77,8 @@ int mlx5vf_cmd_query_vhca_migration_state(struct mlx5vf_pci_core_device *mvdev,
 		 MLX5_CMD_OP_QUERY_VHCA_MIGRATION_STATE);
 	MLX5_SET(query_vhca_migration_state_in, in, vhca_id, mvdev->vhca_id);
 	MLX5_SET(query_vhca_migration_state_in, in, op_mod, 0);
+	MLX5_SET(query_vhca_migration_state_in, in, incremental,
+		 query_flags & MLX5VF_QUERY_INC);
 
 	ret = mlx5_cmd_exec_inout(mvdev->mdev, query_vhca_migration_state, in,
 				  out);
@@ -342,6 +362,56 @@ mlx5vf_alloc_data_buffer(struct mlx5_vf_migration_file *migf,
 	return ERR_PTR(ret);
 }
 
+void mlx5vf_put_data_buffer(struct mlx5_vhca_data_buffer *buf)
+{
+	spin_lock_irq(&buf->migf->list_lock);
+	list_add_tail(&buf->buf_elm, &buf->migf->avail_list);
+	spin_unlock_irq(&buf->migf->list_lock);
+}
+
+struct mlx5_vhca_data_buffer *
+mlx5vf_get_data_buffer(struct mlx5_vf_migration_file *migf,
+		       size_t length, enum dma_data_direction dma_dir)
+{
+	struct mlx5_vhca_data_buffer *buf, *temp_buf;
+	struct list_head free_list;
+
+	lockdep_assert_held(&migf->mvdev->state_mutex);
+	if (migf->mvdev->mdev_detach)
+		return ERR_PTR(-ENOTCONN);
+
+	INIT_LIST_HEAD(&free_list);
+
+	spin_lock_irq(&migf->list_lock);
+	list_for_each_entry_safe(buf, temp_buf, &migf->avail_list, buf_elm) {
+		if (buf->dma_dir == dma_dir) {
+			list_del_init(&buf->buf_elm);
+			if (buf->allocated_length >= length) {
+				spin_unlock_irq(&migf->list_lock);
+				goto found;
+			}
+			/*
+			 * Prevent holding redundant buffers. Put in a free
+			 * list and call at the end not under the spin lock
+			 * (&migf->list_lock) to mlx5vf_free_data_buffer which
+			 * might sleep.
+			 */
+			list_add(&buf->buf_elm, &free_list);
+		}
+	}
+	spin_unlock_irq(&migf->list_lock);
+	buf = mlx5vf_alloc_data_buffer(migf, length, dma_dir);
+
+found:
+	while ((temp_buf = list_first_entry_or_null(&free_list,
+				struct mlx5_vhca_data_buffer, buf_elm))) {
+		list_del(&temp_buf->buf_elm);
+		mlx5vf_free_data_buffer(temp_buf);
+	}
+
+	return buf;
+}
+
 void mlx5vf_mig_file_cleanup_cb(struct work_struct *_work)
 {
 	struct mlx5vf_async_data *async_data = container_of(_work,
@@ -351,7 +421,7 @@ void mlx5vf_mig_file_cleanup_cb(struct work_struct *_work)
 
 	mutex_lock(&migf->lock);
 	if (async_data->status) {
-		migf->buf = async_data->buf;
+		mlx5vf_put_data_buffer(async_data->buf);
 		migf->state = MLX5_MIGF_STATE_ERROR;
 		wake_up_interruptible(&migf->poll_wait);
 	}
@@ -369,15 +439,19 @@ static void mlx5vf_save_callback(int status, struct mlx5_async_work *context)
 			struct mlx5_vf_migration_file, async_data);
 
 	if (!status) {
+		size_t image_size;
 		unsigned long flags;
 
-		async_data->buf->length =
-			MLX5_GET(save_vhca_state_out, async_data->out,
-				 actual_image_size);
+		image_size = MLX5_GET(save_vhca_state_out, async_data->out,
+				      actual_image_size);
+		async_data->buf->length = image_size;
+		async_data->buf->start_pos = migf->max_pos;
+		migf->max_pos += async_data->buf->length;
 		spin_lock_irqsave(&migf->list_lock, flags);
 		list_add_tail(&async_data->buf->buf_elm, &migf->buf_list);
 		spin_unlock_irqrestore(&migf->list_lock, flags);
-		migf->state = MLX5_MIGF_STATE_COMPLETE;
+		if (async_data->last_chunk)
+			migf->state = MLX5_MIGF_STATE_COMPLETE;
 		wake_up_interruptible(&migf->poll_wait);
 	}
 
@@ -391,7 +465,8 @@ static void mlx5vf_save_callback(int status, struct mlx5_async_work *context)
 
 int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 			       struct mlx5_vf_migration_file *migf,
-			       struct mlx5_vhca_data_buffer *buf)
+			       struct mlx5_vhca_data_buffer *buf, bool inc,
+			       bool track)
 {
 	u32 out_size = MLX5_ST_SZ_BYTES(save_vhca_state_out);
 	u32 in[MLX5_ST_SZ_DW(save_vhca_state_in)] = {};
@@ -412,9 +487,12 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	MLX5_SET(save_vhca_state_in, in, vhca_id, mvdev->vhca_id);
 	MLX5_SET(save_vhca_state_in, in, mkey, buf->mkey);
 	MLX5_SET(save_vhca_state_in, in, size, buf->allocated_length);
+	MLX5_SET(save_vhca_state_in, in, incremental, inc);
+	MLX5_SET(save_vhca_state_in, in, set_track, track);
 
 	async_data = &migf->async_data;
 	async_data->buf = buf;
+	async_data->last_chunk = !track;
 	async_data->out = kvzalloc(out_size, GFP_KERNEL);
 	if (!async_data->out) {
 		err = -ENOMEM;
@@ -497,6 +575,8 @@ void mlx5fv_cmd_clean_migf_resources(struct mlx5_vf_migration_file *migf)
 		migf->buf = NULL;
 	}
 
+	list_splice(&migf->avail_list, &migf->buf_list);
+
 	while ((entry = list_first_entry_or_null(&migf->buf_list,
 				struct mlx5_vhca_data_buffer, buf_elm))) {
 		list_del(&entry->buf_elm);
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index 6e594689566e..34e61c7aa23d 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -38,6 +38,7 @@ struct mlx5vf_async_data {
 	struct work_struct work;
 	struct mlx5_vhca_data_buffer *buf;
 	int status;
+	u8 last_chunk:1;
 	void *out;
 };
 
@@ -47,9 +48,11 @@ struct mlx5_vf_migration_file {
 	enum mlx5_vf_migf_state state;
 
 	u32 pdn;
+	loff_t max_pos;
 	struct mlx5_vhca_data_buffer *buf;
 	spinlock_t list_lock;
 	struct list_head buf_list;
+	struct list_head avail_list;
 	struct mlx5vf_pci_core_device *mvdev;
 	wait_queue_head_t poll_wait;
 	struct completion save_comp;
@@ -129,10 +132,14 @@ struct mlx5vf_pci_core_device {
 	struct mlx5_core_dev *mdev;
 };
 
+enum {
+	MLX5VF_QUERY_INC = (1UL << 0),
+};
+
 int mlx5vf_cmd_suspend_vhca(struct mlx5vf_pci_core_device *mvdev, u16 op_mod);
 int mlx5vf_cmd_resume_vhca(struct mlx5vf_pci_core_device *mvdev, u16 op_mod);
 int mlx5vf_cmd_query_vhca_migration_state(struct mlx5vf_pci_core_device *mvdev,
-					  size_t *state_size);
+					  size_t *state_size, u8 query_flags);
 void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev,
 			       const struct vfio_migration_ops *mig_ops,
 			       const struct vfio_log_ops *log_ops);
@@ -140,7 +147,8 @@ void mlx5vf_cmd_remove_migratable(struct mlx5vf_pci_core_device *mvdev);
 void mlx5vf_cmd_close_migratable(struct mlx5vf_pci_core_device *mvdev);
 int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 			       struct mlx5_vf_migration_file *migf,
-			       struct mlx5_vhca_data_buffer *buf);
+			       struct mlx5_vhca_data_buffer *buf, bool inc,
+			       bool track);
 int mlx5vf_cmd_load_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 			       struct mlx5_vf_migration_file *migf,
 			       struct mlx5_vhca_data_buffer *buf);
@@ -151,6 +159,10 @@ struct mlx5_vhca_data_buffer *
 mlx5vf_alloc_data_buffer(struct mlx5_vf_migration_file *migf,
 			 size_t length, enum dma_data_direction dma_dir);
 void mlx5vf_free_data_buffer(struct mlx5_vhca_data_buffer *buf);
+struct mlx5_vhca_data_buffer *
+mlx5vf_get_data_buffer(struct mlx5_vf_migration_file *migf,
+		       size_t length, enum dma_data_direction dma_dir);
+void mlx5vf_put_data_buffer(struct mlx5_vhca_data_buffer *buf);
 int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
 			       unsigned int npages);
 void mlx5vf_state_mutex_unlock(struct mlx5vf_pci_core_device *mvdev);
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index ca16425811c4..9cabba456044 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -195,6 +195,7 @@ static ssize_t mlx5vf_buf_read(struct mlx5_vhca_data_buffer *vhca_buf,
 	if (*pos >= vhca_buf->start_pos + vhca_buf->length) {
 		spin_lock_irq(&vhca_buf->migf->list_lock);
 		list_del_init(&vhca_buf->buf_elm);
+		list_add_tail(&vhca_buf->buf_elm, &vhca_buf->migf->avail_list);
 		spin_unlock_irq(&vhca_buf->migf->list_lock);
 	}
 
@@ -283,6 +284,16 @@ static __poll_t mlx5vf_save_poll(struct file *filp,
 	return pollflags;
 }
 
+/*
+ * FD is exposed and user can use it after receiving an error.
+ * Mark migf in error, and wake the user.
+ */
+static void mlx5vf_mark_err(struct mlx5_vf_migration_file *migf)
+{
+	migf->state = MLX5_MIGF_STATE_ERROR;
+	wake_up_interruptible(&migf->poll_wait);
+}
+
 static const struct file_operations mlx5vf_save_fops = {
 	.owner = THIS_MODULE,
 	.read = mlx5vf_save_read,
@@ -291,8 +302,42 @@ static const struct file_operations mlx5vf_save_fops = {
 	.llseek = no_llseek,
 };
 
+static int mlx5vf_pci_save_device_inc_data(struct mlx5vf_pci_core_device *mvdev)
+{
+	struct mlx5_vf_migration_file *migf = mvdev->saving_migf;
+	struct mlx5_vhca_data_buffer *buf;
+	size_t length;
+	int ret;
+
+	if (migf->state == MLX5_MIGF_STATE_ERROR)
+		return -ENODEV;
+
+	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev, &length,
+						    MLX5VF_QUERY_INC);
+	if (ret)
+		goto err;
+
+	buf = mlx5vf_get_data_buffer(migf, length, DMA_FROM_DEVICE);
+	if (IS_ERR(buf)) {
+		ret = PTR_ERR(buf);
+		goto err;
+	}
+
+	ret = mlx5vf_cmd_save_vhca_state(mvdev, migf, buf, true, false);
+	if (ret)
+		goto err_save;
+
+	return 0;
+
+err_save:
+	mlx5vf_put_data_buffer(buf);
+err:
+	mlx5vf_mark_err(migf);
+	return ret;
+}
+
 static struct mlx5_vf_migration_file *
-mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev)
+mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev, bool track)
 {
 	struct mlx5_vf_migration_file *migf;
 	struct mlx5_vhca_data_buffer *buf;
@@ -328,8 +373,9 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev)
 	mlx5_cmd_init_async_ctx(mvdev->mdev, &migf->async_ctx);
 	INIT_WORK(&migf->async_data.work, mlx5vf_mig_file_cleanup_cb);
 	INIT_LIST_HEAD(&migf->buf_list);
+	INIT_LIST_HEAD(&migf->avail_list);
 	spin_lock_init(&migf->list_lock);
-	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev, &length);
+	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev, &length, 0);
 	if (ret)
 		goto out_pd;
 
@@ -339,7 +385,7 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev)
 		goto out_pd;
 	}
 
-	ret = mlx5vf_cmd_save_vhca_state(mvdev, migf, buf);
+	ret = mlx5vf_cmd_save_vhca_state(mvdev, migf, buf, false, track);
 	if (ret)
 		goto out_save;
 	return migf;
@@ -462,6 +508,7 @@ mlx5vf_pci_resume_device_data(struct mlx5vf_pci_core_device *mvdev)
 	stream_open(migf->filp->f_inode, migf->filp);
 	mutex_init(&migf->lock);
 	INIT_LIST_HEAD(&migf->buf_list);
+	INIT_LIST_HEAD(&migf->avail_list);
 	spin_lock_init(&migf->list_lock);
 	return migf;
 out_pd:
@@ -514,7 +561,8 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
 		return NULL;
 	}
 
-	if (cur == VFIO_DEVICE_STATE_RUNNING && new == VFIO_DEVICE_STATE_RUNNING_P2P) {
+	if ((cur == VFIO_DEVICE_STATE_RUNNING && new == VFIO_DEVICE_STATE_RUNNING_P2P) ||
+	    (cur == VFIO_DEVICE_STATE_PRE_COPY && new == VFIO_DEVICE_STATE_PRE_COPY_P2P)) {
 		ret = mlx5vf_cmd_suspend_vhca(mvdev,
 			MLX5_SUSPEND_VHCA_IN_OP_MOD_SUSPEND_INITIATOR);
 		if (ret)
@@ -522,7 +570,8 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
 		return NULL;
 	}
 
-	if (cur == VFIO_DEVICE_STATE_RUNNING_P2P && new == VFIO_DEVICE_STATE_RUNNING) {
+	if ((cur == VFIO_DEVICE_STATE_RUNNING_P2P && new == VFIO_DEVICE_STATE_RUNNING) ||
+	    (cur == VFIO_DEVICE_STATE_PRE_COPY_P2P && new == VFIO_DEVICE_STATE_PRE_COPY)) {
 		ret = mlx5vf_cmd_resume_vhca(mvdev,
 			MLX5_RESUME_VHCA_IN_OP_MOD_RESUME_INITIATOR);
 		if (ret)
@@ -533,7 +582,7 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
 	if (cur == VFIO_DEVICE_STATE_STOP && new == VFIO_DEVICE_STATE_STOP_COPY) {
 		struct mlx5_vf_migration_file *migf;
 
-		migf = mlx5vf_pci_save_device_data(mvdev);
+		migf = mlx5vf_pci_save_device_data(mvdev, false);
 		if (IS_ERR(migf))
 			return ERR_CAST(migf);
 		get_file(migf->filp);
@@ -541,7 +590,10 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
 		return migf->filp;
 	}
 
-	if ((cur == VFIO_DEVICE_STATE_STOP_COPY && new == VFIO_DEVICE_STATE_STOP)) {
+	if ((cur == VFIO_DEVICE_STATE_STOP_COPY && new == VFIO_DEVICE_STATE_STOP) ||
+	    (cur == VFIO_DEVICE_STATE_PRE_COPY && new == VFIO_DEVICE_STATE_RUNNING) ||
+	    (cur == VFIO_DEVICE_STATE_PRE_COPY_P2P &&
+	     new == VFIO_DEVICE_STATE_RUNNING_P2P)) {
 		mlx5vf_disable_fds(mvdev);
 		return NULL;
 	}
@@ -567,6 +619,28 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
 		return NULL;
 	}
 
+	if ((cur == VFIO_DEVICE_STATE_RUNNING && new == VFIO_DEVICE_STATE_PRE_COPY) ||
+	    (cur == VFIO_DEVICE_STATE_RUNNING_P2P &&
+	     new == VFIO_DEVICE_STATE_PRE_COPY_P2P)) {
+		struct mlx5_vf_migration_file *migf;
+
+		migf = mlx5vf_pci_save_device_data(mvdev, true);
+		if (IS_ERR(migf))
+			return ERR_CAST(migf);
+		get_file(migf->filp);
+		mvdev->saving_migf = migf;
+		return migf->filp;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_PRE_COPY_P2P && new == VFIO_DEVICE_STATE_STOP_COPY) {
+		ret = mlx5vf_cmd_suspend_vhca(mvdev,
+			MLX5_SUSPEND_VHCA_IN_OP_MOD_SUSPEND_RESPONDER);
+		if (ret)
+			return ERR_PTR(ret);
+		ret = mlx5vf_pci_save_device_inc_data(mvdev);
+		return ret ? ERR_PTR(ret) : NULL;
+	}
+
 	/*
 	 * vfio_mig_get_next_state() does not use arcs other than the above
 	 */
@@ -635,7 +709,7 @@ static int mlx5vf_pci_get_data_size(struct vfio_device *vdev,
 
 	mutex_lock(&mvdev->state_mutex);
 	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev,
-						    &state_size);
+						    &state_size, 0);
 	if (!ret)
 		*stop_copy_length = state_size;
 	mlx5vf_state_mutex_unlock(mvdev);
-- 
2.18.1

