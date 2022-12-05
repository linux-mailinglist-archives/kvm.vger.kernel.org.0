Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47E68642AAD
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 15:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbiLEOtt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 09:49:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231151AbiLEOtn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 09:49:43 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2078.outbound.protection.outlook.com [40.107.220.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A9B21C105
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 06:49:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f3EUYh7hrOkC61hEC/o3ZjoRYMeywWEVTA4+TOuyBBYzTAo+3dzmO90lCavXOEhWAM5enyTZItmiuDskEiBVV2mzvg8AGKoV3L6Xtx4vhGJ0h5Pjldw6Hn9PzCtw7Ap5VwJdhwdsNl9QPDZymoyutNFYH3Aiem7fv46yDVV9TIVNe69tbq+I7AzBFRtxu4H0U5FcEIvkpSHYha1shg/jcaJJzGFeaZhaat/bJrJy57J09dImD9WqDl0YQ4173tVzgxJYKNglOgnT40ZQ96NKAbRldIOnNjC8zn/5uQ2WmWy6BQDMFme66KrJL8UJiQCkodrTm/sal8ySCu3Q4CLbxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GIV4Ourelq5LgR69e5dtig0n8mGW+SmX+Z8CVOFcIKY=;
 b=nRA9mpjGBkB+fvWGp0RraeaRSN3ljUHYzNcmQKbxjlDs++N+sOgKiov8KsqpdWGqN2cf3IXh+IEElALqB3Oz3n/OLR6+GUbXojjBTC6L73JmxNA5K3bqBEzw0cf56FnUdyGI/j75wiWmnVBaw4pd9DTmSrFH+GRRENu/5gVNerf2Aijgf5lyVxUkg/eyv5aVKjl8d4vHZqvCNbPOEwZWGB7OuZ+gPonjYwSGaUqavQaKFH55s+jsc4vewFxILEk3tW65hLnp9nw1d/ljZSndnTSPzupmj3D051+JZyh2uSjidt6hZLLQOE+OrbKNA8JkpPKKU/5sODu11PF6gy4lRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GIV4Ourelq5LgR69e5dtig0n8mGW+SmX+Z8CVOFcIKY=;
 b=NrAdxjN9Oi3LFr7+vOCq15c0PulqtllzozOrTDZdx66ncOkG5sMuVFM1a7Xt8CA88u3s6PcbpAx8DZTzXx7wfHQyHgUlecJxN94ODCx/2GGCjgfQzicczP/EH2E3GhD/Lnaal7dhQdSQ1Mlk1ZKdFwf7kTZF0u+UrRKoM0YrBcwdMWaN53LwLDlKn864cPqRiVuMelPFgdVs/MSLLfxSeQrdm2bO7gxMzBqGBCT97XWkJnrgR1qR/grWbKjqmVEkTQpe3EFI6J0lK1dz62N3f3qRUQ6oeIy1hMSMtJ8DLrZSl3z38xHn78M5jxYblXsIylUbxQrWcULNdwsAbXdCMg==
Received: from CY5P221CA0019.NAMP221.PROD.OUTLOOK.COM (2603:10b6:930:b::32) by
 SA0PR12MB4574.namprd12.prod.outlook.com (2603:10b6:806:94::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14; Mon, 5 Dec 2022 14:49:40 +0000
Received: from CY4PEPF0000B8EC.namprd05.prod.outlook.com
 (2603:10b6:930:b:cafe::e3) by CY5P221CA0019.outlook.office365.com
 (2603:10b6:930:b::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13 via Frontend
 Transport; Mon, 5 Dec 2022 14:49:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000B8EC.mail.protection.outlook.com (10.167.241.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.11 via Frontend Transport; Mon, 5 Dec 2022 14:49:40 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 5 Dec 2022
 06:49:26 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 5 Dec 2022
 06:49:25 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Mon, 5 Dec
 2022 06:49:22 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V3 vfio 06/14] vfio/mlx5: Refactor migration file state
Date:   Mon, 5 Dec 2022 16:48:30 +0200
Message-ID: <20221205144838.245287-7-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221205144838.245287-1-yishaih@nvidia.com>
References: <20221205144838.245287-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8EC:EE_|SA0PR12MB4574:EE_
X-MS-Office365-Filtering-Correlation-Id: 680094c1-fde9-4613-2d82-08dad6cff04d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N6u+ifb3K3Xjs372abDCFLyWTEQZQDa+okN4g7TbRpBrTOYlr0pYdlZg27r1aUGlgZLCU5UEn4HNN6JsjAdMaRtp+rEwP2FvUQ7k/MxpEMB3aypk/A8TsVKVNgHkbPiWyISp7iJT+vE94Cy+S+pePipST5EEZg3GDhiHflMYhiM64qH1gV+xsjHqY6jPaxhI/aslwU9U/OyZQtDYa889kLzYrf3EFxaQ5zlqpqjTHFvq0EcM/BmHpYL9pCs6MiODdsHVZ93qE07lkwUiCO/5Yvkm4TNPqUT5S+chT7jHnJdFVX9IY98fIFOWKWGFnhoFtYOGxbK6aJHbkFilcUNgkTAB2M1AfzgLfNn+bsmPGv1xTF3t0kkFf2gpjUNiwDLy1FiBcoZW9VuMRNDf8Tl+9mP0mpiNdsDsmrBTKuDkHP+hWpPTJ143o0fW7L2/3Se16YTd0LRPGl2pmZPDT9Qu1IqUH0QTmf4f6ppN5Cyo58XFDaJSIPBFqwPwzxTrZGFtGf3W0Q7qRTrKaw+ifcf/+0ac16BTHqXwfYsy41ydT6Tv06hvOeVxhKw6KRyrTR27Ai8cq+cb0AKlvB5qrURVIuyPXENSOt138uWC3IbnecEZzD+r+g0qN49rAHctJluTZVN7J4XmNiBLJ5XuuJIpahL8wWMaIGDtTrbK/WPSHjUYUHI0knM1W0lKer9II3vtGRgcYwv8FMJbI4oqqT3+Vg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(39860400002)(396003)(376002)(451199015)(46966006)(36840700001)(40470700004)(86362001)(36756003)(40480700001)(40460700003)(1076003)(2616005)(336012)(41300700001)(70586007)(70206006)(4326008)(8676002)(8936002)(5660300002)(47076005)(426003)(7696005)(478600001)(6666004)(316002)(6636002)(54906003)(110136005)(186003)(26005)(7636003)(356005)(82310400005)(82740400003)(83380400001)(2906002)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 14:49:40.3104
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 680094c1-fde9-4613-2d82-08dad6cff04d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8EC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4574
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor migration file state to be an emum which is mutual exclusive.

As of that dropped the 'disabled' state as 'error' is the same from
functional point of view.

Next patches from the series will extend this enum for other relevant
states.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  |  2 +-
 drivers/vfio/pci/mlx5/cmd.h  |  7 +++++--
 drivers/vfio/pci/mlx5/main.c | 11 ++++++-----
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index ed4c472d2eae..fcba12326185 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -351,7 +351,7 @@ void mlx5vf_mig_file_cleanup_cb(struct work_struct *_work)
 
 	mutex_lock(&migf->lock);
 	if (async_data->status) {
-		migf->is_err = true;
+		migf->state = MLX5_MIGF_STATE_ERROR;
 		wake_up_interruptible(&migf->poll_wait);
 	}
 	mutex_unlock(&migf->lock);
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index b0f08dfc8120..14403e654e4e 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -12,6 +12,10 @@
 #include <linux/mlx5/cq.h>
 #include <linux/mlx5/qp.h>
 
+enum mlx5_vf_migf_state {
+	MLX5_MIGF_STATE_ERROR = 1,
+};
+
 struct mlx5_vhca_data_buffer {
 	struct sg_append_table table;
 	loff_t start_pos;
@@ -37,8 +41,7 @@ struct mlx5vf_async_data {
 struct mlx5_vf_migration_file {
 	struct file *filp;
 	struct mutex lock;
-	u8 disabled:1;
-	u8 is_err:1;
+	enum mlx5_vf_migf_state state;
 
 	u32 pdn;
 	struct mlx5_vhca_data_buffer *buf;
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 5f694fce854c..d95646c2f010 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -109,7 +109,7 @@ int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
 static void mlx5vf_disable_fd(struct mlx5_vf_migration_file *migf)
 {
 	mutex_lock(&migf->lock);
-	migf->disabled = true;
+	migf->state = MLX5_MIGF_STATE_ERROR;
 	migf->filp->f_pos = 0;
 	mutex_unlock(&migf->lock);
 }
@@ -137,7 +137,8 @@ static ssize_t mlx5vf_save_read(struct file *filp, char __user *buf, size_t len,
 
 	if (!(filp->f_flags & O_NONBLOCK)) {
 		if (wait_event_interruptible(migf->poll_wait,
-			     READ_ONCE(vhca_buf->length) || migf->is_err))
+			     READ_ONCE(vhca_buf->length) ||
+			     migf->state == MLX5_MIGF_STATE_ERROR))
 			return -ERESTARTSYS;
 	}
 
@@ -150,7 +151,7 @@ static ssize_t mlx5vf_save_read(struct file *filp, char __user *buf, size_t len,
 		done = -EINVAL;
 		goto out_unlock;
 	}
-	if (migf->disabled || migf->is_err) {
+	if (migf->state == MLX5_MIGF_STATE_ERROR) {
 		done = -ENODEV;
 		goto out_unlock;
 	}
@@ -199,7 +200,7 @@ static __poll_t mlx5vf_save_poll(struct file *filp,
 	poll_wait(filp, &migf->poll_wait, wait);
 
 	mutex_lock(&migf->lock);
-	if (migf->disabled || migf->is_err)
+	if (migf->state == MLX5_MIGF_STATE_ERROR)
 		pollflags = EPOLLIN | EPOLLRDNORM | EPOLLRDHUP;
 	else if (READ_ONCE(migf->buf->length))
 		pollflags = EPOLLIN | EPOLLRDNORM;
@@ -298,7 +299,7 @@ static ssize_t mlx5vf_resume_write(struct file *filp, const char __user *buf,
 		return -ENOMEM;
 
 	mutex_lock(&migf->lock);
-	if (migf->disabled) {
+	if (migf->state == MLX5_MIGF_STATE_ERROR) {
 		done = -ENODEV;
 		goto out_unlock;
 	}
-- 
2.18.1

