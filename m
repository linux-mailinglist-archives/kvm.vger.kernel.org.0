Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AAD479AF22
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 01:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233316AbjIKUsl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235820AbjIKJkJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 05:40:09 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2087.outbound.protection.outlook.com [40.107.95.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD0C102
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 02:40:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KmwD/RD7aQ+Zqojl7/ixxGI+Dv9ikQ8QB8hBKSMRuYpcxhrPrJmIwuPrzwpBXuEJksDZIEzNOUAwETWjuSwhChV3bZ4yUE62cn0sI1Irzi6MjFBS3AK6IE2HE+HhuyV8jDEG9LoQXm9bW8O0PKV0cetw+XKBzi4LD6mJrEX77mDh2fxC01xry2URo7pzzATNfDXDLVqVUa5cCA+8/gEqGcpNZ1lAv7fNwlnnvUWzYkTc0g0z+TU8CTxu3bTDeLuj0KbwIPO1Kw6UX9vbqzEvymSF3IpDVtulmUkG1UvutunPbTWk+7Dke+E2QmOB/f9yueJW5l37KD1OC+i0di690A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LhKeaUloY5oz02n1EtBk7hyaU84CbVF3Vn8FTPBg9D8=;
 b=IurXSu0AOFMJJxsedZkCwFHSRaLuJOEHYSfo1DY/xRaIjVLrHjowd+xZWCBWQP+bQvDAH+W2luLm79MR/qrNdbkN1YxVWX+m33XjmxWAg9g5+DVkdxGjk5IN1Xw7DGcIi+j6esBWmoVUiAmg2PZ6ip0zEUOK7NQBn/MXraGGgDIUiKdjaNTBEm+kjvDLKR2vVQJLLw4AN3ZPlD4/ynFqYNqKLLwAJudcjILNjK2Y8FvXK624uuwNgWXBi7m8D72A5OEr7DvhNf60elZF6JD875FAKHqsZFeBBb7g30ErYJgdarXFlakmV8Yfiny6m2Q7ooB8F3f0DBToY2w8EtyWIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LhKeaUloY5oz02n1EtBk7hyaU84CbVF3Vn8FTPBg9D8=;
 b=BYwkIBJAuoKIeLrKacbxh/5IMBOUQhSTXCC0K7h7F0vj/vWp1Es4UcpYcs0S7VQwaX7uHlCwi3W0aar0znDyYJ+4mSc4vDPojzhYWUmzmJM1c0E9JQl7KwkgLTQxIgjvZpuBULO79d5VeWnAcjE74TA2WDY1faASMgaNXbxJCpnUI+9Jqx3mibS4WHtuHB90AyyO5nnRxByGEJat9w0gcJbsms3z/Ws+8CwAyy5d3fEvVMlXZTiUpNgEL+IuKqIfnfnzyZBU1dMts1JcxW55fQhC6NDBj8vR1lyD7xJj9Uan8tG70CpotRDCJ19T1uRF28ASkfeAuJMCAYdNyr0AOQ==
Received: from CY5PR03CA0021.namprd03.prod.outlook.com (2603:10b6:930:8::36)
 by DS0PR12MB7607.namprd12.prod.outlook.com (2603:10b6:8:13f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.30; Mon, 11 Sep
 2023 09:40:02 +0000
Received: from CY4PEPF0000FCC2.namprd03.prod.outlook.com
 (2603:10b6:930:8:cafe::36) by CY5PR03CA0021.outlook.office365.com
 (2603:10b6:930:8::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.34 via Frontend
 Transport; Mon, 11 Sep 2023 09:40:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000FCC2.mail.protection.outlook.com (10.167.242.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.17 via Frontend Transport; Mon, 11 Sep 2023 09:40:01 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 11 Sep 2023
 02:39:53 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 11 Sep
 2023 02:39:52 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Mon, 11 Sep
 2023 02:39:50 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH vfio 4/9] vfio/mlx5: Enable querying state size which is > 4GB
Date:   Mon, 11 Sep 2023 12:38:51 +0300
Message-ID: <20230911093856.81910-5-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20230911093856.81910-1-yishaih@nvidia.com>
References: <20230911093856.81910-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC2:EE_|DS0PR12MB7607:EE_
X-MS-Office365-Filtering-Correlation-Id: 1315794d-7828-4b43-8bff-08dbb2ab125f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dsJlGKEoCCK/EI8p1+tZ4SXsVHsqb0na0fFiYiWeKiRfhhLfdU1rPUIkn7bjvk+iW+KBWCie9SZ7BLo/PzFuh1lvi7uj9ZQb+JvKruL0qmQ+FHn7Zh4HeavcDkifcR4wyye50ykOtrD8JXAURyLonL9kQqe58Dfiy5Unw5QWlwF+dxTMqR5IVwxn1i2CMRZEDH5MPPgjIm/3CWZt4ikcC0iFd6vQkwlCYWhZRfEtSkztnwXwB2bAvxa3PmLfGP1hkRU+dOTdMWYOj/hcOgfZwzi0gFNhqVC9oho3KoT0aRaOzW1mro4L+SKataAeLm01mHKvwObDumdvYsshTkxCaxlQbwhOcYlGj2sAsXuVf2c7EwzeT2LsBacbxD3pbGm4Qj4Nwd77d3PpOmGE78hVBqQx+oZTFaPxCI3xrOxcpFIMRJnLallJ5l4Bp538FQfAgygeXxP98XlmfnZeyUzv9RGcyuuUgiGg2NxP1jYIA+HypoYUOViCGkVo2IljtKBGW2yQSF3556/ZQVNN84zh4WYtO1dxIi4ophvWTzbZmXGLlBDGWI/45YQiBiW+VnGLOMGd34H8JVFHLrf6S5NIvbgLDKBA20Ff73pK+UEYiLfjX2ZToPl5OpC+IwQrxw6q1kBt7zkUDSzYfEIiXpF639CxEaSmOVU9MdUQH9jNWlbt10WA+sduRSNOLJp9XLxjp6lhhAWIWiCywD3Fcjo4n/ooj4fxXSvcviRpypPf6HuYAibIVSsjf4mviyE0I+eU
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(136003)(396003)(39860400002)(376002)(82310400011)(186009)(451199024)(1800799009)(46966006)(36840700001)(40470700004)(40460700003)(356005)(2906002)(86362001)(426003)(2616005)(1076003)(336012)(107886003)(26005)(478600001)(7696005)(36860700001)(36756003)(83380400001)(82740400003)(7636003)(47076005)(40480700001)(8936002)(41300700001)(4326008)(8676002)(70586007)(70206006)(5660300002)(54906003)(6636002)(316002)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2023 09:40:01.9054
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1315794d-7828-4b43-8bff-08dbb2ab125f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000FCC2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7607
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Once the device supports 'chunk mode' the driver can support state size
which is larger than 4GB.

In that case the device has the capability to split a single image to
multiple chunks as long as the software provides a buffer in the minimum
size reported by the device.

The driver should query for the minimum buffer size required using
QUERY_VHCA_MIGRATION_STATE command with the 'chunk' bit set in its
input, in that case, the output will include both the minimum buffer
size (i.e.  required_umem_size) and also the remaining total size to be
reported/used where that it will be applicable.

At that point in the series the 'chunk' bit is off, the last patch will
activate the feature once all pieces will be ready.

Note:
Before this change we were limited to 4GB state size as of 4 bytes max
value based on the device specification for the query/save/load
commands.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  |  9 ++++++++-
 drivers/vfio/pci/mlx5/cmd.h  |  4 +++-
 drivers/vfio/pci/mlx5/main.c | 13 +++++++------
 3 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 18d9d1768066..e70d84bf2043 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -86,7 +86,8 @@ int mlx5vf_cmd_resume_vhca(struct mlx5vf_pci_core_device *mvdev, u16 op_mod)
 }
 
 int mlx5vf_cmd_query_vhca_migration_state(struct mlx5vf_pci_core_device *mvdev,
-					  size_t *state_size, u8 query_flags)
+					  size_t *state_size, u64 *total_size,
+					  u8 query_flags)
 {
 	u32 out[MLX5_ST_SZ_DW(query_vhca_migration_state_out)] = {};
 	u32 in[MLX5_ST_SZ_DW(query_vhca_migration_state_in)] = {};
@@ -128,6 +129,7 @@ int mlx5vf_cmd_query_vhca_migration_state(struct mlx5vf_pci_core_device *mvdev,
 	MLX5_SET(query_vhca_migration_state_in, in, op_mod, 0);
 	MLX5_SET(query_vhca_migration_state_in, in, incremental,
 		 query_flags & MLX5VF_QUERY_INC);
+	MLX5_SET(query_vhca_migration_state_in, in, chunk, mvdev->chunk_mode);
 
 	ret = mlx5_cmd_exec_inout(mvdev->mdev, query_vhca_migration_state, in,
 				  out);
@@ -139,6 +141,11 @@ int mlx5vf_cmd_query_vhca_migration_state(struct mlx5vf_pci_core_device *mvdev,
 
 	*state_size = MLX5_GET(query_vhca_migration_state_out, out,
 			       required_umem_size);
+	if (total_size)
+		*total_size = mvdev->chunk_mode ?
+			MLX5_GET64(query_vhca_migration_state_out, out,
+				   remaining_total_size) : *state_size;
+
 	return 0;
 }
 
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index aec4c69dd6c1..4fb37598c8e5 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -164,6 +164,7 @@ struct mlx5vf_pci_core_device {
 	u8 deferred_reset:1;
 	u8 mdev_detach:1;
 	u8 log_active:1;
+	u8 chunk_mode:1;
 	struct completion tracker_comp;
 	/* protect migration state */
 	struct mutex state_mutex;
@@ -186,7 +187,8 @@ enum {
 int mlx5vf_cmd_suspend_vhca(struct mlx5vf_pci_core_device *mvdev, u16 op_mod);
 int mlx5vf_cmd_resume_vhca(struct mlx5vf_pci_core_device *mvdev, u16 op_mod);
 int mlx5vf_cmd_query_vhca_migration_state(struct mlx5vf_pci_core_device *mvdev,
-					  size_t *state_size, u8 query_flags);
+					  size_t *state_size, u64 *total_size,
+					  u8 query_flags);
 void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev,
 			       const struct vfio_migration_ops *mig_ops,
 			       const struct vfio_log_ops *log_ops);
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 2556d5455692..90cb36fee6c0 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -428,7 +428,7 @@ static long mlx5vf_precopy_ioctl(struct file *filp, unsigned int cmd,
 		 * As so, the other code below is safe with the proper locks.
 		 */
 		ret = mlx5vf_cmd_query_vhca_migration_state(mvdev, &inc_length,
-							    MLX5VF_QUERY_INC);
+							    NULL, MLX5VF_QUERY_INC);
 		if (ret)
 			goto err_state_unlock;
 	}
@@ -505,7 +505,7 @@ static int mlx5vf_pci_save_device_inc_data(struct mlx5vf_pci_core_device *mvdev)
 	if (migf->state == MLX5_MIGF_STATE_ERROR)
 		return -ENODEV;
 
-	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev, &length,
+	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev, &length, NULL,
 				MLX5VF_QUERY_INC | MLX5VF_QUERY_FINAL);
 	if (ret)
 		goto err;
@@ -574,7 +574,7 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev, bool track)
 	INIT_LIST_HEAD(&migf->buf_list);
 	INIT_LIST_HEAD(&migf->avail_list);
 	spin_lock_init(&migf->list_lock);
-	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev, &length, 0);
+	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev, &length, NULL, 0);
 	if (ret)
 		goto out_pd;
 
@@ -1195,13 +1195,14 @@ static int mlx5vf_pci_get_data_size(struct vfio_device *vdev,
 	struct mlx5vf_pci_core_device *mvdev = container_of(
 		vdev, struct mlx5vf_pci_core_device, core_device.vdev);
 	size_t state_size;
+	u64 total_size;
 	int ret;
 
 	mutex_lock(&mvdev->state_mutex);
-	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev,
-						    &state_size, 0);
+	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev, &state_size,
+						    &total_size, 0);
 	if (!ret)
-		*stop_copy_length = state_size;
+		*stop_copy_length = total_size;
 	mlx5vf_state_mutex_unlock(mvdev);
 	return ret;
 }
-- 
2.18.1

