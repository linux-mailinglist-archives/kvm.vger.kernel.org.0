Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2804B63F3ED
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 16:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbiLAPbH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 10:31:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231856AbiLAPaq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 10:30:46 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2074.outbound.protection.outlook.com [40.107.94.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339E2AD314
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 07:30:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e/4q1TG3rFoPjdpnmJcpgcm4MKV56G1xO98/hUxL7iupSaXNU9PHUroAdPk2706cBXH/ib/jiJQjyftFCrJlWbvCUVWpkHYtqORKK0RTk2pjJ9R/LANzUPWGYzTWDKWQ8yZHQ0zapErAGQt1XGC/kPWodi+5zex4qxQNe7iAgR84mTiwmUd0Rm4vbyFpPSP5ynsMC5RQsQwvRs8kLY0W98HfElAQpd/8IUeb5d8vMb0WmUeRx9+W685pfCgBMYVa5HJyVOcDsJtJCdOJaBSMy6gpL8UlfjgF/Mo7z/SGVlmRIul0bb6BvsBDz4g4eTY1iUH8nrqouWt4PJCMD0sF0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MuGw/0NK3SUKhRrV2O5MX15cqjR4EAK7Me0zK/QrVpA=;
 b=aCn/WQRj8jntktMnaSH1IeNCvGt/pXVdtdCZjaSWxT0/8givum0Z1K8ob3WA7FCC1HSamAzbAGGOBSk2RrP+o68sKnFT16ZsHeiF/56gm00eYear701VeysN0PYezCEvXJ/l+nxr1cotoV/s8akg4G0Yoq7/l8eFzk1YW9coXDhHLwLP92Elz+hdkjooYOCR8N12IJA7LtY+A3sTKDpMVmL9w2XSN69Wlc6Uyt2XgDyhOXUyDqFGznL9j7Fx2xRE8/mf1V62FXVitQXSL6EvMdIjn132dkO49Gqrut2WCcvr4E0TRCKEULWhT/KWczZZ7UdLB/01uDEoFKoSExd4+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MuGw/0NK3SUKhRrV2O5MX15cqjR4EAK7Me0zK/QrVpA=;
 b=Mrhrz1sUgoTtm5JyIKsESq7jMJHHrZ3xDFvAMgEs1VmPUP30SiZFXp8f8Fr8N2PMQ+kQyBMvjRjv/428XiOR8kfcFTLSGOvM3Cfudls5n/9U213pjR2cbf2HtrusUGx9pTjRGZ2l2l5wjLyGiojorH+s4VJV+M4hDP9ZDVuopxDEeJatqdaafGNSUSacqgUxzxtTOVUfSw2DnyoaK74+deljWWmStAyGcEH3nGpYfrcrVGt8mRckZoi3Iy+dlnRkJYQSAQuwwcB7HRHMO9b8Akp9Nyjnxgxm3spBM15tA76EWqiDyQ1pYxRApPofYEBsjV+8AcHb5hDcuc2aWHLThw==
Received: from DM6PR06CA0094.namprd06.prod.outlook.com (2603:10b6:5:336::27)
 by MN2PR12MB4254.namprd12.prod.outlook.com (2603:10b6:208:1d0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 15:30:31 +0000
Received: from CY4PEPF0000C964.namprd02.prod.outlook.com
 (2603:10b6:5:336:cafe::33) by DM6PR06CA0094.outlook.office365.com
 (2603:10b6:5:336::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8 via Frontend
 Transport; Thu, 1 Dec 2022 15:30:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CY4PEPF0000C964.mail.protection.outlook.com (10.167.241.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8 via Frontend Transport; Thu, 1 Dec 2022 15:30:31 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 1 Dec 2022
 07:30:19 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 1 Dec 2022 07:30:18 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Thu, 1 Dec 2022 07:30:15 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>
Subject: [PATCH V2 vfio 06/14] vfio/mlx5: Refactor migration file state
Date:   Thu, 1 Dec 2022 17:29:23 +0200
Message-ID: <20221201152931.47913-7-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221201152931.47913-1-yishaih@nvidia.com>
References: <20221201152931.47913-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C964:EE_|MN2PR12MB4254:EE_
X-MS-Office365-Filtering-Correlation-Id: b038b823-b15e-4fa4-18f1-08dad3b0fb62
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GUfTaY7/r4Zx6W738PJqxGEu5oGZs0gU1fturPyAd5Sz9W5Oxy5PrJCA/PX/QEFNJmeRRAbqA3ePZHiMBh9CY5PYoVOs/bphHyJaaVCKXk6oQluCOidwbabGLftKaQIKraTeOLeFVIwmDmBQALH/D0FNzTlRxvQODgwkbevdQiGz8UZZKYjdKvFdPjnmi8+iZY4eFiY4tIlxrqF+tXAcu1OcI7jPPbZHhPrF49r4gqRFTJ6+3RX6PDMMTudGBA63MwPuAXEmT1fkT2XtWQ8K+bKAUr6RFrOg0i5B2M6cO2aLOUXUG3f9vuHNpE4LlFiAcDyXrx7Q108T5dFcvryLTao+RyG7A0EgyNiVpjd7TMhcweDnBNY5kGOAIKmuS+DUZgfBqlhN1OhdmjxyswTuoVjup2rmxM6JtMR1czXM8uVCfo6cLmiYvHdI2Z6oQW9l75CwsJXoKnO0gelbaFgR2TsVnpKOJJ2SLKeHgFlP7d6ign9n+AKiG8B2b44w+cVrnL7eQYuBwHM004YLuhDJLTGSyGMxEKCCc4ll78cNMpxhZicoKdyrPO1MFxIw05GWFDFV/VE2NGinCwxgeeKCLFjIzcqg3SfNoePjkuo1Q6phoZc9g/3dtt6ZencaEgVGKuG2NcyrOsjulXV2fJBEAdNI+HRBQwN0FtXRvECmN1G1uAkLn0rcoYHr8TBE51ACoNTDL4e9bXfzZ35M6rr02A==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(346002)(396003)(136003)(451199015)(36840700001)(46966006)(40470700004)(336012)(426003)(83380400001)(110136005)(7696005)(54906003)(6666004)(41300700001)(36756003)(356005)(86362001)(7636003)(40480700001)(2616005)(82310400005)(186003)(36860700001)(82740400003)(47076005)(40460700003)(26005)(1076003)(316002)(478600001)(70206006)(8936002)(5660300002)(4326008)(6636002)(2906002)(8676002)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 15:30:31.0467
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b038b823-b15e-4fa4-18f1-08dad3b0fb62
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C964.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4254
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
index 38ef8708eca5..0ee8e509116c 100644
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
@@ -293,7 +294,7 @@ static ssize_t mlx5vf_resume_write(struct file *filp, const char __user *buf,
 		return -ENOMEM;
 
 	mutex_lock(&migf->lock);
-	if (migf->disabled) {
+	if (migf->state == MLX5_MIGF_STATE_ERROR) {
 		done = -ENODEV;
 		goto out_unlock;
 	}
-- 
2.18.1

