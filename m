Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D734E61E508
	for <lists+kvm@lfdr.de>; Sun,  6 Nov 2022 18:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbiKFRsA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Nov 2022 12:48:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbiKFRrp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Nov 2022 12:47:45 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2050.outbound.protection.outlook.com [40.107.220.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F4A6571
        for <kvm@vger.kernel.org>; Sun,  6 Nov 2022 09:47:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bkyU1EpMTJ4+d5E9rn951Gvj05kqCn10a932Q9N1CKcQGy9RHxhbB78GhFILuTX0ZPPVjnkbh75nMAvelCjwuICcavbl1/u0FkrskDNrnmU80QnawW3D5yt1V4RKNgrwVsiT1qF/chzm5lbYI/HENOMQ7EWXk1ON4oSEmlkLHC6nhrvUqEIqvScVdiAINp8sa7LmC1LfzZYm4FpMXh+nszZTGaMHi7bBMJlbmYk+SvN6sz42Ag9uXGTVpMWWLsyIcuhIRN+eOj4R+VYIUynhL09oYJPvsRSlahL0iprKDQYo+ImZqvzFdYhCve741VDlcnFPFBF4FHlx5DQ2iIsvhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JcmuycdpkEmt2Q1yqZWh0X9ViiwkmDSrVhQQomAWY6E=;
 b=FHnb6rWJkRz2hmfH1yoGBhT0br624sHMlkb3eBwna/ejvnrTmxNjs4WSHQXbJBlxN8Zf5BO0+V7mNhZhW6yJy3Z4hXfz+yOgKcbptduT8opjl+IGFKTmlm/VBEz48MwzJXGurVeItSSBBDVlp7mTXZVwWmuVqkgLNJv8EyIfU78wEV3qKUbmya2Aw6WyleuMerX6W1ncXyCF23VbMGnfjuqwOSFGg64Dx8qeH/ciL8A3VLuCHT8H2WgFC4THBUOjt/XE09pp8YAMubCKo9zysXPCjcFXTAajSoMOs66nC78wysdMwBdED8ViwcQVDeQBW4rE5yYnmoG3wvf6nwAqcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JcmuycdpkEmt2Q1yqZWh0X9ViiwkmDSrVhQQomAWY6E=;
 b=kxoJPYb5noh6p+IkR2B2twQ26Bh4hvhCTDW0NXJlEulCiTRmF5DiLI72fG3W04IqFm/QWP2hucyHHYZIJjnrQP6nA0cgGUPsM/BG4bkbRKgEFMIeYZgJcH8jS8k5UrEsMvTLxu+1lBl3nniT1tjxrHRHn3py8ogU+9uTTqqEM9uJLw7ZYDQM66hqHArW4lj9WHDmp1uNZbswNxN3GTfAzL61/JezBxl3RCgdoJ7rwhs3ZaJqg01vVZyy48t9JpNDsNEjO/G+2ctHqggOvyzr+O6nB9hb9L2z+0byGw2s3ZZ9TeexEcKAwbpt6+mRh0h6Y3ZBd+/FDSCXzqDPTok6cw==
Received: from DM6PR08CA0048.namprd08.prod.outlook.com (2603:10b6:5:1e0::22)
 by DM4PR12MB5216.namprd12.prod.outlook.com (2603:10b6:5:398::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19; Sun, 6 Nov
 2022 17:47:34 +0000
Received: from DM6NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1e0:cafe::cf) by DM6PR08CA0048.outlook.office365.com
 (2603:10b6:5:1e0::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25 via Frontend
 Transport; Sun, 6 Nov 2022 17:47:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM6NAM11FT058.mail.protection.outlook.com (10.13.172.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20 via Frontend Transport; Sun, 6 Nov 2022 17:47:34 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Sun, 6 Nov 2022
 09:47:32 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Sun, 6 Nov 2022 09:47:31 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Sun, 6 Nov 2022 09:47:29 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>
Subject: [PATCH vfio 08/13] vfio/mlx5: Introduce vfio precopy ioctl implementation
Date:   Sun, 6 Nov 2022 19:46:25 +0200
Message-ID: <20221106174630.25909-9-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221106174630.25909-1-yishaih@nvidia.com>
References: <20221106174630.25909-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT058:EE_|DM4PR12MB5216:EE_
X-MS-Office365-Filtering-Correlation-Id: 00f5d856-63df-43fc-71e4-08dac01efc8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LTpSQLhX7+Ttt+Zk8g3Q1JupD3OwRHPPxj9XBfJ+A2+bjkRvsCCDAFAoiEy5FJklJV1NXDSsErtSh/kJNzF9xUT+7diTsuZ2gjWLiII7f24UAijzu7SBoiLWoKJuyTOdtaeV4le7hbrElz+yOh/jhnRXxHwhYi4aG+6pbXwigUOhm4RrxwR6mjAdbwLKxS8DQoLbMRC5gTzdBfI+A+Eq8zaPuQnInE5ardutp0LCuX4dGi+4CZ0Y0A1eyHbHBZk/9UrL7p+aELvfnj64e4qVXATPkJ8Jo1HuD8OqlC3exu9vnjcvgXPLiwm04l1FAvis/JJUL7OS5R9V4+aO2/ECQmFVK+87oIjo9od+mNjDRpdOgyCOjL/4kIpIM1x3p8e5kcokH8/yZ1xN4H67bFoyD+78Zm9+1Bq/vA9AeAX5Awa95uTfWoKVOfkIIrhBZW+XHmL44rqN/dWjxGRgof9iQ/9wc0l015+U/J9ldXinMFj1lWLpk3/wFI3HP1wLg3kDzk0qVIkH3J8g18lSmGAekMlO4oq+KCaXPocAPJWp3GbU+cQeRKiFjDn8vbmgHzEjXi/VujhKz9pp38hF3jgJ36ewRCQOI98LkPMhcTH0UWcsClVzKiaY+Xw+KZur97s0L01bfF2tJ9t8kOmr1+EObSBc+JqEZ/2gWnAjtdB224KzhT1ZGuocWS8SEu9SHm4NDey/yazkBVgvcCrFqmHy54pCvmsiGSDgrdBajNkREUZfPqyNHwCx0FAQNBoJBnW7i4i6YZNb3XkGGw7Tu2avVw==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(376002)(346002)(451199015)(46966006)(40470700004)(36840700001)(186003)(1076003)(426003)(83380400001)(2616005)(336012)(2906002)(6666004)(36756003)(8936002)(41300700001)(316002)(7696005)(36860700001)(82310400005)(47076005)(26005)(478600001)(5660300002)(40480700001)(86362001)(70206006)(4326008)(110136005)(356005)(8676002)(6636002)(40460700003)(7636003)(82740400003)(70586007)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2022 17:47:34.3398
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 00f5d856-63df-43fc-71e4-08dac01efc8c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5216
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

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
finished its SAVE command and has been fully transferred, this enables
to re-use the resources.

In order to map between FD position and the new saved state data, store
the current FD position.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  |   9 +++
 drivers/vfio/pci/mlx5/cmd.h  |   1 +
 drivers/vfio/pci/mlx5/main.c | 131 +++++++++++++++++++++++++++++++++++
 3 files changed, 141 insertions(+)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index eb684455c2b2..2d2171191218 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -64,6 +64,15 @@ int mlx5vf_cmd_query_vhca_migration_state(struct mlx5vf_pci_core_device *mvdev,
 	if (mvdev->mdev_detach)
 		return -ENOTCONN;
 
+	/*
+	 * In case PRE_COPY is used, saving_migf is exposed while device is
+	 * running. Make sure to run only once there is no active save command.
+	 * Running both in parallel, might end-up with a failure in the
+	 * incremental query command on un-tracked vhca.
+	 */
+	if (query_flags & MLX5VF_QUERY_INC)
+		wait_event(mvdev->saving_migf->save_wait,
+			   !mvdev->saving_migf->save_cb_active);
 	MLX5_SET(query_vhca_migration_state_in, in, opcode,
 		 MLX5_CMD_OP_QUERY_VHCA_MIGRATION_STATE);
 	MLX5_SET(query_vhca_migration_state_in, in, vhca_id, mvdev->vhca_id);
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index c12fa81ba53f..07a2fc54c9d8 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -30,6 +30,7 @@ struct mlx5_vf_migration_file {
 	u8 save_cb_active:1;
 
 	struct sg_append_table table;
+	size_t table_start_pos;
 	size_t image_length;
 	size_t allocated_length;
 	/*
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 10e073c32ab1..266626066fed 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -107,6 +107,22 @@ static int mlx5vf_add_migration_pages(struct mlx5_vf_migration_file *migf,
 	return ret;
 }
 
+static void mlx5vf_prep_next_table(struct mlx5_vf_migration_file *migf)
+{
+	struct sg_page_iter sg_iter;
+
+	lockdep_assert_held(&migf->lock);
+	migf->table_start_pos += migf->image_length;
+	/* clear sgtable, all data has been transferred */
+	for_each_sgtable_page(&migf->table.sgt, &sg_iter, 0)
+		__free_page(sg_page_iter_page(&sg_iter));
+	sg_free_append_table(&migf->table);
+	memset(&migf->table, 0, sizeof(migf->table));
+	migf->image_length = 0;
+	migf->allocated_length = 0;
+	migf->last_offset_sg = NULL;
+}
+
 static void mlx5vf_disable_fd(struct mlx5_vf_migration_file *migf)
 {
 	struct sg_page_iter sg_iter;
@@ -120,6 +136,7 @@ static void mlx5vf_disable_fd(struct mlx5_vf_migration_file *migf)
 	migf->image_length = 0;
 	migf->allocated_length = 0;
 	migf->final_length = 0;
+	migf->table_start_pos = 0;
 	migf->filp->f_pos = 0;
 	for_each_sgtable_page(&migf->final_table.sgt, &sg_iter, 0)
 		__free_page(sg_page_iter_page(&sg_iter));
@@ -137,6 +154,13 @@ static int mlx5vf_release_file(struct inode *inode, struct file *filp)
 	return 0;
 }
 
+#define MIGF_TOTAL_DATA(migf) \
+	(migf->table_start_pos + migf->image_length + migf->final_length)
+
+#define VFIO_MIG_STATE_PRE_COPY(mvdev) \
+	(mvdev->mig_state == VFIO_DEVICE_STATE_PRE_COPY || \
+	 mvdev->mig_state == VFIO_DEVICE_STATE_PRE_COPY_P2P)
+
 static ssize_t mlx5vf_save_read(struct file *filp, char __user *buf, size_t len,
 			       loff_t *pos)
 {
@@ -230,10 +254,117 @@ static void mlx5vf_mark_err(struct mlx5_vf_migration_file *migf)
 	wake_up_interruptible(&migf->poll_wait);
 }
 
+static ssize_t mlx5vf_precopy_ioctl(struct file *filp, unsigned int cmd,
+				    unsigned long arg)
+{
+	struct mlx5_vf_migration_file *migf = filp->private_data;
+	struct mlx5vf_pci_core_device *mvdev = migf->mvdev;
+	bool first_state, state_finish_transfer;
+	struct vfio_precopy_info info;
+	loff_t *pos = &filp->f_pos;
+	unsigned long minsz;
+	size_t inc_length;
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
+	if (!VFIO_MIG_STATE_PRE_COPY(migf->mvdev)) {
+		ret = -EINVAL;
+		goto err_state_unlock;
+	}
+
+	/*
+	 * We can't issue a SAVE command when the device is suspended, so as
+	 * part of VFIO_DEVICE_STATE_PRE_COPY_P2P no reason to query for extra
+	 * bytes that can't be read.
+	 */
+	if (mvdev->mig_state != VFIO_DEVICE_STATE_PRE_COPY_P2P) {
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
+	if (*pos > MIGF_TOTAL_DATA(migf)) {
+		ret = -EINVAL;
+		goto err_migf_unlock;
+	}
+
+	if (migf->disabled || migf->is_err) {
+		ret = -ENODEV;
+		goto err_migf_unlock;
+	}
+
+	first_state = migf->table_start_pos == 0;
+	if (first_state) {
+		info.initial_bytes = MIGF_TOTAL_DATA(migf) - *pos;
+		info.dirty_bytes = 0;
+	} else {
+		info.initial_bytes = 0;
+		info.dirty_bytes = MIGF_TOTAL_DATA(migf) - *pos;
+	}
+	state_finish_transfer = *pos == MIGF_TOTAL_DATA(migf);
+	if (!(state_finish_transfer && inc_length &&
+	      mvdev->mig_state == VFIO_DEVICE_STATE_PRE_COPY)) {
+		mutex_unlock(&migf->lock);
+		goto done;
+	}
+
+	/*
+	 * We finished transferring the current state and the device has a
+	 * dirty state, save a new state to be ready for.
+	 */
+	mlx5vf_prep_next_table(migf);
+	ret = mlx5vf_add_migration_pages(migf,
+					 DIV_ROUND_UP_ULL(inc_length, PAGE_SIZE),
+					 &migf->table);
+	mutex_unlock(&migf->lock);
+	if (ret) {
+		mlx5vf_mark_err(migf);
+		goto err_state_unlock;
+	}
+
+	ret = mlx5vf_cmd_save_vhca_state(mvdev, migf, true, true);
+	if (ret) {
+		mlx5vf_mark_err(migf);
+		goto err_state_unlock;
+	}
+
+	info.dirty_bytes += inc_length;
+
+done:
+	mlx5vf_state_mutex_unlock(mvdev);
+	return copy_to_user((void __user *)arg, &info, minsz);
+
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

