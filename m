Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEDE642AB3
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 15:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbiLEOt6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 09:49:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbiLEOt4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 09:49:56 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2082.outbound.protection.outlook.com [40.107.102.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1D11C427
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 06:49:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wox+Ju88bGHnxJh1VHQSwMWzUESmFQK8cxjcHzDQCh/X2rZ2q5KgRZ31OL0pTQh7zuLwX7ibgtiP65OYg5Yu7/kAtpTUV8GxJsPPwRICqlZ/QLV/LkzdKVIcMgx3XCLgYctq2qtw+T5z6pZJM2NJ3gayVBfNWVs1vEb3CcXtGI+LpZd7+KDxOYL+wxFG826HrrocPwW24go6RYY88NIZxpeYMJZdPCH4nSth59fgU0xNqvxpbAe1BIDseSBqAZ6YPM7+trgk/NxfeZBWR9/adUVG4lmY5enB+BNPGvloxZyNnW9TDC4ub25YxDpyOrGBdgBSGMP6c6prq4DwrEm1ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ypaAh5o4CiN2ps+bMYLapf6I6ScbOL8H5+WlOZZuvZA=;
 b=H99ZnLZ1nj5HF9ILrpFPlXOEjqR92hxD1UWGEKgtOe7MCi0HROc5pQceZEHhiK1OwTsHXs+EdXuXxdxcM0smrnxvktuyE0txRl5zAqTRFFm+FVOrIHJhsfN37H4ke7RrQ4aUW+a3ez/QdTIR8yh0A6FeZYShjx9x5432G3QxWswzUZ9zhcpU19Vyg8rttjSjn1awmkOYSiUkde0lS+5rULCEzpq+6z8nY4WFp7LoYe0fkT/U+EDiZG63PayouDQ4GYB3O03a5pZ1lt6EP99YTMEg3GrGKIgbhfuTKkGtvWHYQcn1qeuznLGQYXmyGMfIYqIsV4y8lLeslYt1rJmM0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ypaAh5o4CiN2ps+bMYLapf6I6ScbOL8H5+WlOZZuvZA=;
 b=eJgwBQVhNSaadzFpUUFr3BLvxBua8WNrzLccTr34PToitbI/7GG0usxOxaTrEVYXqMtRbd17/c9AQ6cTW0wofXBInVNAz18NKqYIT/zxv3UkQ8+Apmq0rb1IinI9ANv1PP53wJRUk9GRgAyOQijaqlTHJklUukp9002n4RRSi3Wa87Ua1QFJq2PegUqFe3Ig24x22IlVV+lZYxoE4MH/y7f/EwhWUqdh3vFE2hoFaFDzwk/Ot683/yYmM22i0Nk6ekY/YTTbm5/RLN3IP9Hd7PqtH7F0ZXZCaolhJEBf6fOvwXZeoxYObVc1zbMLwkvlORUoJhKx+Be/Fr+luBViTg==
Received: from MW4PR04CA0040.namprd04.prod.outlook.com (2603:10b6:303:6a::15)
 by CY5PR12MB6431.namprd12.prod.outlook.com (2603:10b6:930:39::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Mon, 5 Dec
 2022 14:49:53 +0000
Received: from CO1NAM11FT092.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::5b) by MW4PR04CA0040.outlook.office365.com
 (2603:10b6:303:6a::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Mon, 5 Dec 2022 14:49:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT092.mail.protection.outlook.com (10.13.175.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14 via Frontend Transport; Mon, 5 Dec 2022 14:49:52 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 5 Dec 2022
 06:49:41 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 5 Dec 2022
 06:49:41 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Mon, 5 Dec
 2022 06:49:38 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V3 vfio 10/14] vfio/mlx5: Introduce vfio precopy ioctl implementation
Date:   Mon, 5 Dec 2022 16:48:34 +0200
Message-ID: <20221205144838.245287-11-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221205144838.245287-1-yishaih@nvidia.com>
References: <20221205144838.245287-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT092:EE_|CY5PR12MB6431:EE_
X-MS-Office365-Filtering-Correlation-Id: 7793b0e5-8c0a-43c2-59bd-08dad6cff7b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gZZlsNoxH/GMEZ/1CLMNNdozpEw9BUo2lrmKaNgyOvqKRRvMjYVidB7fDnkc3mCKBYGOwY/8/nbJCmNsYm/0SDNUEFXadXLAxXu1H6OL9LYup+iSCE9R59hpLcBhIrm/XvDRcX8SHnW8wLxRErpVymet3b/oc/D0n7kUF2uMHLn50Y6PsqsP1HrHuMb8Z2CZHHs5LaWk8vXDfdAOFsqA+odg+gdMXIgMZkuNlTzXKJIGVJRoGPcSUfYHTcSDovk71l6epeGgiUFk8ydH/vxuFo5WVLSAdMoLluUVu8vPp5PY/sVsafZ3FrOUstHd2sDrzMCEaXs8MpO4BZJWNI6KXsGyvibtVXOn7Ako9xueXBrxn+tdEvbSP47eWQL1tC8Zsn8ANR6AWeg1AhlwpZO/a5QL4+y3sHmhWRaY+wWLtrU3rP1uS9xXV8Y1HsGj2dR9ZChcvdTSQ5vWzkeJ8Fcd05mS0JggPRwP2FxPCVes78565nNxkNtS1VkFKiBBWfzAcr97s7FCAs6ozEwOJa/ZqLHGZ/hOfeL3HBjbGKxfTtbe3pqHNOmw/GbmhAktc1QS7l3IVrBiuPMESjPyRRqVYob2DJ3fBRkB9Sl0/7P9mRRqU+dMBl12NTlJh6Wc37xHMt004MWxBFIHUf+2IN9pEFp5vbSMEeM8pC2wZopMzobKeaNxGIFp/UIS/lpQtTM6+B2ECJWK6IfOTZ4JyB8IIA==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(39860400002)(136003)(451199015)(46966006)(40470700004)(36840700001)(47076005)(426003)(7636003)(86362001)(40460700003)(7696005)(356005)(478600001)(40480700001)(36756003)(82740400003)(36860700001)(2616005)(336012)(1076003)(83380400001)(82310400005)(186003)(41300700001)(8936002)(4326008)(5660300002)(8676002)(26005)(6666004)(6636002)(54906003)(316002)(70206006)(70586007)(110136005)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 14:49:52.7775
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7793b0e5-8c0a-43c2-59bd-08dad6cff7b4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT092.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6431
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
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
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
index 9a36e36ec33b..08c7d96e92b7 100644
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

