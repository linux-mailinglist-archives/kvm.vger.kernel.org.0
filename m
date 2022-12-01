Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2458763F3EE
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 16:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbiLAPbK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 10:31:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231859AbiLAPaq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 10:30:46 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB51AD315
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 07:30:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HYVtBplBa1a5rut5yxWl+0S0a1X4bx36P1UI4VICAcwBMuwXzUrzx5GGRrxTXosVK47G5FlB+1tmTUbM5mBlX49GHdYZpp5FnSabQfZfhyHHTLclGWNzEm8YWx01A4JCC2xe/cfq8zVASwHk8I7GvvsyZcDIWQ9wAPFvr3QHNswuSQ3W918UcwMmSWgoKtTs5SN6KoKaIkIIvxvENR7mOXZ3GeKprGMghThrdH78jvN3xGsLMB986WgyRdZQZw0iobmSQAEDskMZRHx6gcmzgLqOtW0Gz4Wh7hnOF7z087rKtmznz9SZfiWiECww1KH+BIAG4rTPCWIFc17ms8eaQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YwSoQN+MGNgpLMPbT48xpFnp9P3NPEFx1TSUutlBWf8=;
 b=Xdh3eK2ZOQNRerWMXtixrZ0028HzSVtMVi35HRr4hh9h4InBaz5Qls5E8fATieX4iUUxZb0Ot69vcNepZCHNgRWcj27Y5PEJzPzv950IVdFzSwU+uMAiSrB7iryEwpqNUBV8AUxw8U68kYS/oO0mtTviC1JpwHnVgEon0b8D+IVMuDoEjE0TBNZoYJQXBLmoRw/Ff+E8VMjacDePkeGT+w3xoyzVKSjnPqf1vHS9GJvfxmqdEbsfGvot9P4hU7FDy1+2VkC2S1NJc/icA/p+oySZ1Gn2+rdA1ZLjSEsdbV2CiXVuky9ldjl3z+BI6FDX2uleEQ2hFx1IB3n/2Av8rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YwSoQN+MGNgpLMPbT48xpFnp9P3NPEFx1TSUutlBWf8=;
 b=tkipxM3Qhi4K3Ztl31LNm8bDkdwhlEt4S/jRrjdCJaavUUSRwNKAsknCDggsrV6AezVad4r0Q9tpd4AMfTVf0DvgN1/JXoXSmj3UvsaP9vezgwSGkxxQAOU8d5jJsH3Tvk61sR/jsxXr4/pdO+ebzEQECapP5xBWZKj6feGbG6NKRki5YloD43qbSDqV3dwdly2quZZh+u+cFVwEMGL7jleKsBEcl4zd+Tibw2YJjocZhcRD/Uswv6O8ELFdS8ckrBEfO4pRYUrFW9hzVpT/9OwZO6hJ9SWPanKXKPQ69PvNO7ityoFlGpWdfsvvR6Rvd/j8+Wuq4Qs+5YYRUD1+kA==
Received: from DM6PR06CA0075.namprd06.prod.outlook.com (2603:10b6:5:336::8) by
 DM4PR12MB7575.namprd12.prod.outlook.com (2603:10b6:8:10d::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8; Thu, 1 Dec 2022 15:30:34 +0000
Received: from DS1PEPF0000E631.namprd02.prod.outlook.com
 (2603:10b6:5:336:cafe::f7) by DM6PR06CA0075.outlook.office365.com
 (2603:10b6:5:336::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8 via Frontend
 Transport; Thu, 1 Dec 2022 15:30:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS1PEPF0000E631.mail.protection.outlook.com (10.167.17.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8 via Frontend Transport; Thu, 1 Dec 2022 15:30:33 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 1 Dec 2022
 07:30:25 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 1 Dec 2022 07:30:24 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Thu, 1 Dec 2022 07:30:22 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>
Subject: [PATCH V2 vfio 08/14] vfio/mlx5: Introduce device transitions of PRE_COPY
Date:   Thu, 1 Dec 2022 17:29:25 +0200
Message-ID: <20221201152931.47913-9-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221201152931.47913-1-yishaih@nvidia.com>
References: <20221201152931.47913-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E631:EE_|DM4PR12MB7575:EE_
X-MS-Office365-Filtering-Correlation-Id: 5563d280-61d3-4718-132c-08dad3b0fd27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gTxrkgQ1xp2wuKVbW+wLf9h9swgk2tLkLrHXqQNkvpeejXM4aCU7tfRq1Qj5I1f3ZjbZJcGUHoBHqDoFufGmgRgsucfvSud3dIOWPjBbNrpzMIIU2ULSfUq1AQmlQvUbed0mLn9yodii3EQ1SfmafLRRQrphpxVk5akYtJVPn4NCcQ1NditHqwVpshybOFugpJwJmgVZpgVROOKEWyakHtN31jVWQ8GLaq9huWV2bc0YSKIZnxUG1HQ94LhxTh2OCnNKL4kQwj0Mu/7wVHVhJQIlJWA1g6cCVtqyV0QmG8ct4x0p/fhhPkQqLXO6PuGXziLmTUrU9o157maVsNkVSho/wmkvUc/e/qvxncNJADeCpJveJdKarohm3IhUBgvYVH52Ab81+gIHdsCae9SzfkqpKupLFrR3UkdlbzMLwVxurnj6IRfcrmuAJu4hx3qOem87g/sMVyQJgflMjQtlgX3wY9b9e8qABN4mE9p3bfPUuTtc+CSOwN/GadougEnnJcPFE6KaY7PkaiLkrmecwYFc8arJYdoF2mh5//wjOtnB5snZmWlBdowzk+D3A4/nmX+4+h0kCjUF69nPiFX4ZO70elLr4vWgFkHVKam/UaLLXf3IllABbvGCCxbYaFmrooiKglFUzX6a2dsqexN4sw3/Q0iqWJKKVSQqMBt7qFcZq71xBcGGOIsEj1PxzsKyBedgPG5wRHJEXnf92oawaA==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(396003)(39860400002)(136003)(451199015)(40470700004)(36840700001)(46966006)(356005)(40480700001)(7636003)(36756003)(86362001)(40460700003)(82310400005)(478600001)(6636002)(54906003)(316002)(110136005)(2906002)(8936002)(4326008)(8676002)(70206006)(70586007)(30864003)(5660300002)(41300700001)(82740400003)(36860700001)(26005)(83380400001)(7696005)(336012)(186003)(426003)(2616005)(1076003)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 15:30:33.9841
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5563d280-61d3-4718-132c-08dad3b0fd27
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E631.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7575
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
index facb5ab6021e..e86489d5dd6e 100644
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
@@ -323,8 +368,9 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev)
 	mlx5_cmd_init_async_ctx(mvdev->mdev, &migf->async_ctx);
 	INIT_WORK(&migf->async_data.work, mlx5vf_mig_file_cleanup_cb);
 	INIT_LIST_HEAD(&migf->buf_list);
+	INIT_LIST_HEAD(&migf->avail_list);
 	spin_lock_init(&migf->list_lock);
-	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev, &length);
+	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev, &length, 0);
 	if (ret)
 		goto out_pd;
 
@@ -334,7 +380,7 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev)
 		goto out_pd;
 	}
 
-	ret = mlx5vf_cmd_save_vhca_state(mvdev, migf, buf);
+	ret = mlx5vf_cmd_save_vhca_state(mvdev, migf, buf, false, track);
 	if (ret)
 		goto out_save;
 	return migf;
@@ -457,6 +503,7 @@ mlx5vf_pci_resume_device_data(struct mlx5vf_pci_core_device *mvdev)
 	stream_open(migf->filp->f_inode, migf->filp);
 	mutex_init(&migf->lock);
 	INIT_LIST_HEAD(&migf->buf_list);
+	INIT_LIST_HEAD(&migf->avail_list);
 	spin_lock_init(&migf->list_lock);
 	return migf;
 out_pd:
@@ -509,7 +556,8 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
 		return NULL;
 	}
 
-	if (cur == VFIO_DEVICE_STATE_RUNNING && new == VFIO_DEVICE_STATE_RUNNING_P2P) {
+	if ((cur == VFIO_DEVICE_STATE_RUNNING && new == VFIO_DEVICE_STATE_RUNNING_P2P) ||
+	    (cur == VFIO_DEVICE_STATE_PRE_COPY && new == VFIO_DEVICE_STATE_PRE_COPY_P2P)) {
 		ret = mlx5vf_cmd_suspend_vhca(mvdev,
 			MLX5_SUSPEND_VHCA_IN_OP_MOD_SUSPEND_INITIATOR);
 		if (ret)
@@ -517,7 +565,8 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
 		return NULL;
 	}
 
-	if (cur == VFIO_DEVICE_STATE_RUNNING_P2P && new == VFIO_DEVICE_STATE_RUNNING) {
+	if ((cur == VFIO_DEVICE_STATE_RUNNING_P2P && new == VFIO_DEVICE_STATE_RUNNING) ||
+	    (cur == VFIO_DEVICE_STATE_PRE_COPY_P2P && new == VFIO_DEVICE_STATE_PRE_COPY)) {
 		ret = mlx5vf_cmd_resume_vhca(mvdev,
 			MLX5_RESUME_VHCA_IN_OP_MOD_RESUME_INITIATOR);
 		if (ret)
@@ -528,7 +577,7 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
 	if (cur == VFIO_DEVICE_STATE_STOP && new == VFIO_DEVICE_STATE_STOP_COPY) {
 		struct mlx5_vf_migration_file *migf;
 
-		migf = mlx5vf_pci_save_device_data(mvdev);
+		migf = mlx5vf_pci_save_device_data(mvdev, false);
 		if (IS_ERR(migf))
 			return ERR_CAST(migf);
 		get_file(migf->filp);
@@ -536,7 +585,10 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
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
@@ -562,6 +614,28 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
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
@@ -630,7 +704,7 @@ static int mlx5vf_pci_get_data_size(struct vfio_device *vdev,
 
 	mutex_lock(&mvdev->state_mutex);
 	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev,
-						    &state_size);
+						    &state_size, 0);
 	if (!ret)
 		*stop_copy_length = state_size;
 	mlx5vf_state_mutex_unlock(mvdev);
-- 
2.18.1

