Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 925B8637E77
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 18:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbiKXRlB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 12:41:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbiKXRk4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 12:40:56 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2041.outbound.protection.outlook.com [40.107.94.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 340C213E073
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 09:40:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ABDe+HLaKzUJurHCNQdyxOFZSZF8i7Hh6aMc//WEtF6TqkBQuSvCbeHgpL2ojtMOdykz8nqv5+b582ggtIOWJyd5nIOnrdSlS5SuTvVQcpMjtMzI7S2NPSu1iX3bNGY4fA4dkwIcVtHeKGYjhdwboj/nDOvyL4INzB8UL/MdIYBJZbJR9C5lcfUk/Kfk1s1AKZqFl8mSvwhxZbHtSeiKsfHTHrTvqQO2EYJXLEvUe6nnfjo/7RxnWghWOrqw75i+6OoMHRUvUTo2uD9lw1GSKcnnMRNUEbdaCjwcxtpyDOvN/oG3hEMQ1W1gRMQOFOiwy0to4yR7FTzBtlnWZCUvyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MuGw/0NK3SUKhRrV2O5MX15cqjR4EAK7Me0zK/QrVpA=;
 b=b1wGDI6Xo+xY9sV6gSzNlJtiHeefUrU5JWk8wSrtWICvGfoOpESUy2eZQHL2gnBvyq45m2W+zWaoYopQpu5eWdroHasPG6hJMn4+qlvGlSReAyNXv/mxDUnqRJ7Nq24TuUCBU73t8lX9mY97BlawWZdQWydwTEW8IqGJBgTKDIdDyivEEkYWn4XM28RgyLwyStGgt43bNuN5cZS5JHGN8baUoau1DZeOTWM7czwOMoBkO1M7DFXpgaVdC+0mb8WqEXU1d5ETWGSp53m9TBGN92XoAsphwtOlGnspljuDq7kRBj3dkOpdinSs/lK3CfqzqA1aYpDRzQNMHJfzngQy9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MuGw/0NK3SUKhRrV2O5MX15cqjR4EAK7Me0zK/QrVpA=;
 b=mZRV6m45kaV8t80zy/jiOHfnQ866ss6MGON5JWpoIaYIwhDOv5fMGHq5rK4ANSdFLDc61fZOSD3wL3yW2fqbsLtAVSv+Ilz+H4t032cTv7lWxJ4YAMXAqBHEH0ez8gg6/tCi7bFy/o876lRTowi4re5vf4rTLLu/gZXOLDIiOzUZdE1wzpMQvb7ZnvTlbz2zMYqVLk2eLqSbS9RhGrGYjymu8wBtCc3TC1k8dY+rm78me5Q7qOSxhJkaziz8+k5HREaSb9iAfk3or62Pc+mN/g6aLogZnakkN+gYrO1bgGt8qiTw4dS2ZRtJJN5bXl22I6WRclKVA3whrF8vQ9oicw==
Received: from MW4P221CA0013.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::18)
 by MN2PR12MB4437.namprd12.prod.outlook.com (2603:10b6:208:26f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Thu, 24 Nov
 2022 17:40:51 +0000
Received: from CO1NAM11FT105.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8b:cafe::50) by MW4P221CA0013.outlook.office365.com
 (2603:10b6:303:8b::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19 via Frontend
 Transport; Thu, 24 Nov 2022 17:40:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1NAM11FT105.mail.protection.outlook.com (10.13.175.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.19 via Frontend Transport; Thu, 24 Nov 2022 17:40:51 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 24 Nov
 2022 09:40:40 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 24 Nov 2022 09:40:39 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Thu, 24 Nov 2022 09:40:36 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>
Subject: [PATCH V1 vfio 06/14] vfio/mlx5: Refactor migration file state
Date:   Thu, 24 Nov 2022 19:39:24 +0200
Message-ID: <20221124173932.194654-7-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221124173932.194654-1-yishaih@nvidia.com>
References: <20221124173932.194654-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT105:EE_|MN2PR12MB4437:EE_
X-MS-Office365-Filtering-Correlation-Id: 09600e8f-aba7-4fe2-18ee-08dace4307ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fwVBsBgtVlgPVV0Nx7nQTSyHA38iWjzfFc+kn6dX/LMdTjC9DLlOdc78oNZ8VdTvSnuH9KlHkmIkKpjA6uo7c5M3DfSHkViur2lNE2Sc1Oy7Gg31zJ0n5vuEz8Fn2CylH+KaX3GmMc2jgbJessGyT7PT8qm2JcyD/kSBY8Bx5AZ01Xwtdf7AdyBVg0cNqg9ZJXmIhbLpJeWDoKsKM8hsGEa0KDleYsT+dZqIY2lmefwxlpYYi2VZ2qHnO5oMdMRPpCq9OqVZFQJxLq+aC1dMw0ZCBcuP+nfDJ+axhWRrKv+B10jyRfYBS3qPYAnG59L+BEO83tPTQz0UkBU6MceGc2FxeRwRy86D+7bY5dXh2MAeiOXJ6TQ73YcZUfgp29VNoX4kV21PvvpjeUykOTuZSd2G2vl5xLy9DsgNfXDBaDchpCLhti9DKvGF1hIfWY4JHv6IoyYsyzeLIO5DtmOYxmP7uRBAZ1Z1Co7D4a3l9/CeDVO0CL0Xh6SpFVvdjfK2GykJCe1G7+aB6N8H1UImWIgF8ATlLATiYdwo0ytowCNzuo3ag1r0iv+NzMcB+Wf5O0hHFm+F4orRNheX/s040Qsdj3IbB8Veiq+QhOQ8ch6nPtguk8VbCyTL2gNKHHy5l9ttdoaGdxSpZoI7PLtfNRDxnbv3X6ve9+8mNHcQ/QS+xwaODMa7mAHq4OSUZwb4GKFECHjKJA59zC1qIAXbZQ==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(346002)(136003)(396003)(451199015)(46966006)(40470700004)(36840700001)(186003)(2616005)(1076003)(426003)(336012)(47076005)(82310400005)(36756003)(5660300002)(41300700001)(6666004)(7696005)(8936002)(26005)(86362001)(316002)(54906003)(110136005)(6636002)(8676002)(4326008)(40460700003)(478600001)(70586007)(36860700001)(70206006)(2906002)(82740400003)(40480700001)(356005)(7636003)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2022 17:40:51.1946
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 09600e8f-aba7-4fe2-18ee-08dace4307ac
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT105.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4437
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

