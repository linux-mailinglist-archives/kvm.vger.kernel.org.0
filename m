Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 714E6643ECE
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 09:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234377AbiLFIgo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 03:36:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234226AbiLFIgB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 03:36:01 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2047.outbound.protection.outlook.com [40.107.223.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCEA213E0C
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 00:35:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TeyQTEqobqPsy1IjrWfgScfaOzO6eNrYRr1drouszCgkBkPtFOUh/t5FTuPMp2Y2jLkxHzTmJc4MFrqUKqBRQYdpzmaMjio5qH/lJuHwTgfmvAzAbElLvupI/ynBrTGHqulLbHHMkbHL66Z7kI50CtFEgzNl9KxIoCq9x29ADOc/vyacT2WxLNdicf+olzy97/VA4qZgmTGbycywa+oMjpjUt6d6tAzr/gJkTk6K+TFAYUa4lG5cZLPTBp4E+Gl/m/HIXHAxXFuZabMq0sWBoSUG9lYsa8DLX5C4di7Wx5DahyeMrMgo+KZVRlM1WbPRWfZAIqS8JLho6kPAzp1W3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xVLLUiGm3pJ0C/ogqpSrd7wWgZdnm/OfIMrta7QZNkk=;
 b=ngkbTkmYutCBL7tffAYps9hrBa6JkPjheYOI47o8aUrjePPALOYNl7SNW7pddiE/BAZ+KDWmDnaKhQj7DdUX5lMUdI7DxacWLO2xU5MeQU6eQfnlZOYVrg6C1M9BCu4D6e3qguUIE3NVbtn/oECrZw9nVAOA3E6ljaS9Kqg1hflLbw8IkqwaWQyz/rIHI+AvldclFLEZFwlO4fbFjVev5qDDmtVx5QZrtTR6jkpstjl3aWIWkYb9/wZiPlXV+mIVpCXZAVeROOi1R/N2+3EBPYDYX2GTi9mKtEnZBCnqLb79UHGMLQX1sokhlHMOEkfcxF22VGxgcq2nYNcTIGKENA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xVLLUiGm3pJ0C/ogqpSrd7wWgZdnm/OfIMrta7QZNkk=;
 b=AhCIroKVuy2H1PXOGcPM76U7GMbQz4CXk2ArP5Kol8q1MEjuR8w3B2eCDBh/21hYYVgAzIHAZ9M8kLx86qkEXAhS0SOMq2xgevFW8CaYTnf/1pppLuNyVrvQbXbKYrlzjykZCdG/ks/dEXgyONxF1xzvZN77CQPQm/XFEvYM9w0L9bbUocISjawnRzFui3eGs089mB26uKpkIl5GZCj22T8RPHnZMsc1I4klu9E33x+uvaEwVxNVLwjCS/b+BDknAGhr8CAslB5yXKM2hif8KH4n93DMX6Pwo7tM3LjKFVFrF2qfOTNMUs6aOtH8Sz96HdlXsbbzRmIHaGcrFiJSzg==
Received: from DS7PR06CA0005.namprd06.prod.outlook.com (2603:10b6:8:2a::20) by
 PH8PR12MB7206.namprd12.prod.outlook.com (2603:10b6:510:226::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14; Tue, 6 Dec 2022 08:35:58 +0000
Received: from CY4PEPF0000C97D.namprd02.prod.outlook.com
 (2603:10b6:8:2a:cafe::11) by DS7PR06CA0005.outlook.office365.com
 (2603:10b6:8:2a::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Tue, 6 Dec 2022 08:35:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CY4PEPF0000C97D.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8 via Frontend Transport; Tue, 6 Dec 2022 08:35:57 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 6 Dec 2022
 00:35:46 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 6 Dec 2022 00:35:46 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Tue, 6 Dec 2022 00:35:43 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V4 vfio 10/14] vfio/mlx5: Introduce vfio precopy ioctl implementation
Date:   Tue, 6 Dec 2022 10:34:34 +0200
Message-ID: <20221206083438.37807-11-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221206083438.37807-1-yishaih@nvidia.com>
References: <20221206083438.37807-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C97D:EE_|PH8PR12MB7206:EE_
X-MS-Office365-Filtering-Correlation-Id: 194a2b2b-8078-45bf-850a-08dad764e5b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VVqcn12Q9MbVvQloZBQrlRx4d5HGzGZ4GQSIStvuyyVhUSP7L+0ADuBSYnguD5ltJcUPs887N17e5mpTdQv5Nb01bH9jdvizsGjeqBlR7pbkWueI0nOr9YU3zRc5Xx3SLd8Ktrg6qcklDVnD/uH1fAvZDCY6OTTN6RdSZY0UcApFRKugTll2cq8SsAEc2jaEhVz8kqGawkghTSxcD3gHYx3f8V/DaQ3Zac28DClJtT/a+WriO0lufy7QsdnGuDJMGcmpT8vuMtdBPhzYDDtHFDo5uktM6Mb6qA6P0K9S/+bOa5GvS6kNWtFlpVZ62uLK/3My6v32UyPiZH03ral0p7sZDcR63X8BgHn7DO3wy3Z7P28b35KWzixZ+gF8l06T2MD/BLosEEZi7wtyuOLbvn4oPJjNNVRoves10z7sGwa49uYFHRaCDSXMNnyiXJecCoGuUFD0/5WmFKeBOeY2xV83NnFyHVI86c4v/SyZ6gWQaSxmdEy+x+frF9fbhRU/jiXPATxPY4gQFDg0Sdp4f/F4pdWU6wYxKkyp5FfTWEJm2831rd3JEo9uLiQctzHIfRaCh2guvlh4DkUjYGGx48ZvGw3e6zpdfgKVZa7wTCr5h5aLGCjd2NSa/XFVgzDmppvq2/NuxIMV3D7dA3rW8H2iKIvIzjEfWd8InnDxY4dL5z8BtK7Y8YYtwnIInIviKG5baMNJg/txMKBGWQxRjA==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(346002)(136003)(451199015)(46966006)(40470700004)(36840700001)(36860700001)(83380400001)(86362001)(41300700001)(8936002)(356005)(82740400003)(7636003)(5660300002)(2906002)(40460700003)(4326008)(8676002)(82310400005)(40480700001)(186003)(26005)(7696005)(336012)(6666004)(1076003)(47076005)(426003)(2616005)(110136005)(6636002)(70586007)(478600001)(316002)(70206006)(54906003)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 08:35:57.5661
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 194a2b2b-8078-45bf-850a-08dad764e5b0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C97D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7206
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
index 9a36e36ec33b..2c8ac763057c 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -294,10 +294,121 @@ static void mlx5vf_mark_err(struct mlx5_vf_migration_file *migf)
 	wake_up_interruptible(&migf->poll_wait);
 }
 
+static long mlx5vf_precopy_ioctl(struct file *filp, unsigned int cmd,
+				 unsigned long arg)
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

