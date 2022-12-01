Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D53963F3F3
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 16:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbiLAPbV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 10:31:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231912AbiLAPas (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 10:30:48 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2059.outbound.protection.outlook.com [40.107.244.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175D8AD31C
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 07:30:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IKNz+ruWjumQTLyaZZ3A891Kxda/mV9rxBIG7g8+7/7sPEdxO/M2HOPuvuxZOfkZppVaUBG7hw5w6kBE8bySwPfDo8TQRemoh3GbsP9coF1NQmLBdFLGkrcT71FHNXzPve1Sbwl4fi+Tlq8K94CEH4CKS//KlxjsmvWqZM9+X6Spmvm3/AGz/1QUp0KxZr+JsusCIpO/HosGYiix9JCDt535lYtfFOhAEcI4qk6TQky3GqztJHFPUcNTI9tni8s6b6xdZ1erya4eNxEWEoN9PYPIlEj7yiHOmaFrNAaM0fzMi8IRdUbECxRpkG45WsU+iv4lxASCZzKlCY/ELxctNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qpCO2lqnQ/bui4dRqCMXJ32lsml4SyJZ8XfV6yJgnl4=;
 b=aYyqh1cT6sLKTRLfetoF5uJYfFbDB3lwSIN4iRu1h53dUasntBzikzz8V1blg6yslxZfknb+gfU0/ZDVTLqOjfzD3pEKOHpdksTQ2BRjGpuQYxPY99fd9d1x8XaD2a4+36Z+kTs5y9QCKjnap/ToDuNs35ASvEt0sCwd6zNCj8YKVnsqDr+iNg9TR5p0ll4V/IKfeTaa1ERrQYSlTeXSJA1/kjSghVLb25KsDRBeeWedbwTgfhCS8os7Xqqm8ySlvVWducI7NJzztkIOweEoEmkwPCk3lp6zLiGcjiNkvCVqWFEMx+5mkP9jf0jC3d7W+J4xPLaoOIAqy3RuM2j2AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qpCO2lqnQ/bui4dRqCMXJ32lsml4SyJZ8XfV6yJgnl4=;
 b=UEA8DWsQtWqvzGIMzyplg6c3EmXOCCAmC3qBh3SqNOcKH2r+yFgeabRLuf9TM/f2NWOUUpRHUp8La1ZtdEobMhZJIrnXovVzBvUMILPcf20OAz/KGuhk+/nNk4iy6H8RJ4guKZsB+451P+RNeM51B4aSZCXBYT6nrObARgCtxRsWiBq/X+h3snHREdGvbtf2pOn09BqQFgH0pVL6BZ+vjGWlr/INTwqdjnPQdBJol3hKzkkRD89bGeV+KDPbSpkUB7Kb1UsM9v1oLtL/wPG8cgjBAAK4JolHv5aGhXlvb5fUhxkwlNPZ47ZtnlGz8WFKP5eIFdbRjlqzEcsnF1DEIA==
Received: from DM6PR06CA0099.namprd06.prod.outlook.com (2603:10b6:5:336::32)
 by DM4PR12MB5167.namprd12.prod.outlook.com (2603:10b6:5:396::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Thu, 1 Dec
 2022 15:30:42 +0000
Received: from DS1PEPF0000E631.namprd02.prod.outlook.com
 (2603:10b6:5:336:cafe::9e) by DM6PR06CA0099.outlook.office365.com
 (2603:10b6:5:336::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8 via Frontend
 Transport; Thu, 1 Dec 2022 15:30:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS1PEPF0000E631.mail.protection.outlook.com (10.167.17.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8 via Frontend Transport; Thu, 1 Dec 2022 15:30:42 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 1 Dec 2022
 07:30:31 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 1 Dec 2022 07:30:31 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Thu, 1 Dec 2022 07:30:28 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>
Subject: [PATCH V2 vfio 10/14] vfio/mlx5: Introduce vfio precopy ioctl implementation
Date:   Thu, 1 Dec 2022 17:29:27 +0200
Message-ID: <20221201152931.47913-11-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221201152931.47913-1-yishaih@nvidia.com>
References: <20221201152931.47913-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E631:EE_|DM4PR12MB5167:EE_
X-MS-Office365-Filtering-Correlation-Id: cc707408-c640-44af-e7e0-08dad3b10230
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kX3NCsAR2YtTVfFky5tF/lUU3dF4pfp4RpOCMMuVl+lXP47Zfp8KMlvdkDyY1yEQIKOBjjOTx+azWTfJiCEBIYTwD3ePi1oU+/aOJ2uZsh2685cb98RF7TZdZhYay/rWhoFhip0u9xlfPiATlBa56pe7Oa2THkH0Qw6ay0d2fi8rd2RFqco5XZc/ehznNvTpjsQElH+H18DD9ZFAL01SymCwv+jGZ/BCgbyMNC0dOjf2ud9CPLyn1p/E4+ua1xNQfW0AwaenUoAr2xSO2Q6OIgmePbQj4UieZczPaeTXeJc0LZ0GgBlkyqDKhrL8jn6q8MFoaK3ENcMXPxkRC8JIu+JwOAf7FB44wSP6CqaoxltOhuV5u8frnuNPDtH06bZlWiUfJpI+qTSn+oVCDckgero00P79SEz2U9ybXqfL+Ci/mp4yqFqjlt4ndmemOSGkND0oDV5nS9XyrQpGgX6LwNX1rFCHY9ZaTUkImQxfh/Ltlg5ROPH2T83DqrtzIxACLZf60to7qN05pnLyM1KPs+tgXuGsJljpGEyLVg1+lQucFUzfEklxIZdbQIXnssMwdvDawwyBAFJYkBU8j9MpCZGC1RoGLmySZJbPFhxZPYJ83eFq13EZ1wWjYDWKKP14ZTl/WUhZLJzfxPkoJqLS+GwH3uVPgP829G77FlMAJoFE+CqsdMA2k9M6i3YFPzPRcVbFVo+xpCqbfy5wzCDP3g==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(376002)(396003)(39860400002)(451199015)(40470700004)(46966006)(36840700001)(36756003)(82740400003)(2906002)(356005)(7636003)(4326008)(5660300002)(41300700001)(40460700003)(36860700001)(83380400001)(86362001)(1076003)(6636002)(110136005)(2616005)(478600001)(70586007)(70206006)(316002)(8676002)(54906003)(40480700001)(82310400005)(186003)(426003)(336012)(47076005)(26005)(7696005)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 15:30:42.4371
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cc707408-c640-44af-e7e0-08dad3b10230
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E631.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5167
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vfio precopy ioctl returns an estimation of data available for
transferring from the device.

Whenever a user is using VFIO_MIG_GET_PRECOPY_INFO, track the current
state of the device, and if needed, append the dirty data to the
transfer FD data. This is done by saving a middle state.

As mlx5 runs the SAVE command asynchronously, make sure to query for
incremental data only once there is no active save command.
Running both in parallel, might end-up with a failure in the incremental
query command on un-tracked vhca.

Also, a middle state will be saved only after the previous state has
finished its SAVE command and has been fully transferred, this prevents
endless use resources.

Co-developed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  |  16 +++++
 drivers/vfio/pci/mlx5/main.c | 111 +++++++++++++++++++++++++++++++++++
 2 files changed, 127 insertions(+)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 160fa38fc78d..12e74ecebe64 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -67,12 +67,25 @@ int mlx5vf_cmd_query_vhca_migration_state(struct mlx5vf_pci_core_device *mvdev,
 {
 	u32 out[MLX5_ST_SZ_DW(query_vhca_migration_state_out)] = {};
 	u32 in[MLX5_ST_SZ_DW(query_vhca_migration_state_in)] = {};
+	bool inc = query_flags & MLX5VF_QUERY_INC;
 	int ret;
 
 	lockdep_assert_held(&mvdev->state_mutex);
 	if (mvdev->mdev_detach)
 		return -ENOTCONN;
 
+	/*
+	 * In case PRE_COPY is used, saving_migf is exposed while device is
+	 * running. Make sure to run only once there is no active save command.
+	 * Running both in parallel, might end-up with a failure in the
+	 * incremental query command on un-tracked vhca.
+	 */
+	if (inc) {
+		ret = wait_for_completion_interruptible(&mvdev->saving_migf->save_comp);
+		if (ret)
+			return ret;
+	}
+
 	MLX5_SET(query_vhca_migration_state_in, in, opcode,
 		 MLX5_CMD_OP_QUERY_VHCA_MIGRATION_STATE);
 	MLX5_SET(query_vhca_migration_state_in, in, vhca_id, mvdev->vhca_id);
@@ -82,6 +95,9 @@ int mlx5vf_cmd_query_vhca_migration_state(struct mlx5vf_pci_core_device *mvdev,
 
 	ret = mlx5_cmd_exec_inout(mvdev->mdev, query_vhca_migration_state, in,
 				  out);
+	if (inc)
+		complete(&mvdev->saving_migf->save_comp);
+
 	if (ret)
 		return ret;
 
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index ec52c8c4533a..2f5f83f2b2a4 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -294,10 +294,121 @@ static void mlx5vf_mark_err(struct mlx5_vf_migration_file *migf)
 	wake_up_interruptible(&migf->poll_wait);
 }
 
+static ssize_t mlx5vf_precopy_ioctl(struct file *filp, unsigned int cmd,
+				    unsigned long arg)
+{
+	struct mlx5_vf_migration_file *migf = filp->private_data;
+	struct mlx5vf_pci_core_device *mvdev = migf->mvdev;
+	struct mlx5_vhca_data_buffer *buf;
+	struct vfio_precopy_info info = {};
+	loff_t *pos = &filp->f_pos;
+	unsigned long minsz;
+	size_t inc_length = 0;
+	bool end_of_data;
+	int ret;
+
+	if (cmd != VFIO_MIG_GET_PRECOPY_INFO)
+		return -ENOTTY;
+
+	minsz = offsetofend(struct vfio_precopy_info, dirty_bytes);
+
+	if (copy_from_user(&info, (void __user *)arg, minsz))
+		return -EFAULT;
+
+	if (info.argsz < minsz)
+		return -EINVAL;
+
+	mutex_lock(&mvdev->state_mutex);
+	if (mvdev->mig_state != VFIO_DEVICE_STATE_PRE_COPY &&
+	    mvdev->mig_state != VFIO_DEVICE_STATE_PRE_COPY_P2P) {
+		ret = -EINVAL;
+		goto err_state_unlock;
+	}
+
+	/*
+	 * We can't issue a SAVE command when the device is suspended, so as
+	 * part of VFIO_DEVICE_STATE_PRE_COPY_P2P no reason to query for extra
+	 * bytes that can't be read.
+	 */
+	if (mvdev->mig_state == VFIO_DEVICE_STATE_PRE_COPY) {
+		/*
+		 * Once the query returns it's guaranteed that there is no
+		 * active SAVE command.
+		 * As so, the other code below is safe with the proper locks.
+		 */
+		ret = mlx5vf_cmd_query_vhca_migration_state(mvdev, &inc_length,
+							    MLX5VF_QUERY_INC);
+		if (ret)
+			goto err_state_unlock;
+	}
+
+	mutex_lock(&migf->lock);
+	if (migf->state == MLX5_MIGF_STATE_ERROR) {
+		ret = -ENODEV;
+		goto err_migf_unlock;
+	}
+
+	buf = mlx5vf_get_data_buff_from_pos(migf, *pos, &end_of_data);
+	if (buf) {
+		if (buf->start_pos == 0) {
+			info.initial_bytes = buf->header_image_size - *pos;
+		} else if (buf->start_pos ==
+				sizeof(struct mlx5_vf_migration_header)) {
+			/* First data buffer following the header */
+			info.initial_bytes = buf->start_pos +
+						buf->length - *pos;
+		} else {
+			info.dirty_bytes = buf->start_pos + buf->length - *pos;
+		}
+	} else {
+		if (!end_of_data) {
+			ret = -EINVAL;
+			goto err_migf_unlock;
+		}
+
+		info.dirty_bytes = inc_length;
+	}
+
+	if (!end_of_data || !inc_length) {
+		mutex_unlock(&migf->lock);
+		goto done;
+	}
+
+	mutex_unlock(&migf->lock);
+	/*
+	 * We finished transferring the current state and the device has a
+	 * dirty state, save a new state to be ready for.
+	 */
+	buf = mlx5vf_get_data_buffer(migf, inc_length, DMA_FROM_DEVICE);
+	if (IS_ERR(buf)) {
+		ret = PTR_ERR(buf);
+		mlx5vf_mark_err(migf);
+		goto err_state_unlock;
+	}
+
+	ret = mlx5vf_cmd_save_vhca_state(mvdev, migf, buf, true, true);
+	if (ret) {
+		mlx5vf_mark_err(migf);
+		mlx5vf_put_data_buffer(buf);
+		goto err_state_unlock;
+	}
+
+done:
+	mlx5vf_state_mutex_unlock(mvdev);
+	return copy_to_user((void __user *)arg, &info, minsz);
+err_migf_unlock:
+	mutex_unlock(&migf->lock);
+err_state_unlock:
+	mlx5vf_state_mutex_unlock(mvdev);
+	return ret;
+}
+
 static const struct file_operations mlx5vf_save_fops = {
 	.owner = THIS_MODULE,
 	.read = mlx5vf_save_read,
 	.poll = mlx5vf_save_poll,
+	.unlocked_ioctl = mlx5vf_precopy_ioctl,
+	.compat_ioctl = compat_ptr_ioctl,
 	.release = mlx5vf_release_file,
 	.llseek = no_llseek,
 };
-- 
2.18.1

