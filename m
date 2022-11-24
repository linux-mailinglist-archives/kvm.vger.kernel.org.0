Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23768637E7E
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 18:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiKXRlQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 12:41:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiKXRlG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 12:41:06 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2056.outbound.protection.outlook.com [40.107.101.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 984E61369DD
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 09:41:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iw3DcuiLY7gvnPKiF18U1FmVPcnh9vRM/swpLcY3sakOeFIVkU1Gq5zVRmtq9ABvuuEFU0ItRzZ4rxd990QfYFODTI1V3ElyqfU5mj25neOIDZ9njb6JmGO+01ybooj5A1hBqaLG1B+ehUSgdT/4peMbTRb+UVZAAVw0rktuMc83CsxxTuS8rvZmjgG98f8dGGVlOuFPlOz80fFt4F7KMDd+TCexg3K8da/ZcUdhG2vebnYEu/HCH+IIRvyFrn+jhyv46W32JXjoVHiWRB8qY9smCb0YrovCjCNUbumfozl7BdDV7zrXfWgCxr5ta2ZeyhYXXVfkTKwS+oUFmvwkRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pqoeIdxNP1oofRd8gziL41r0zTyecZeJsZERnxbUXdY=;
 b=XLhEgZKiuA4lsbewLzhafHiQE2XnvG+ournxmyvLGKLOQbYMm9xvVRIfF/XPWRnVSsAds+K/ZnjUhGXFAtyAQqZnby3ACMYeRmWyujFaYgUdulWI4IqUQndJXF1lGIzswQ2ZoTqBlj+KChADbUn4LFWPKh6icTl97WPVHmTw/MkSvf8UU40Q2Y1FBz7SQaz3am0WLzInUUYeLxVlb54PhxuwzBnTzwnbJfcQb9eT1KRtM+ErZGTGODDt9cqRwFclDAGbOPaZqr63Md2rlMkX9GSc5UT3PGnx0xyruFWGo3J26vxBU5ZRS5OJNLZCYBE7z3xJwt7DupUYAryXk6DXUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pqoeIdxNP1oofRd8gziL41r0zTyecZeJsZERnxbUXdY=;
 b=qKRTuoW3D4zYbdbmw1z2AqpCza6qIAMY/uW7cadxHOFNl6aURG5hTL00Fq1jSHBFuFbxray5EgBgpP8pJdiGjnYXZkPnDk+H8TPMO48cObmwlh1b1nBv5Hzedj9aJbbaKWVmg1+5oi4z9WKdTbjoR3oE3mEhfXGZJPjeydsX+YXdLjWGE2HnONQHlOANdFshzRjqICvCqTRktPDbFm76nH7eZupuZHrAlRWzorlf95UKbXDL+pLD1Yg8bms2e7rNoNctgH3H5df5KdfPGdW4bvfRri9aCqg4bqtgCIYK/YMJki5rf/rMnOkTWQgcKtocQwU0UF6XG4tLghwWcTeJ0g==
Received: from DS7PR03CA0232.namprd03.prod.outlook.com (2603:10b6:5:3ba::27)
 by SA0PR12MB4384.namprd12.prod.outlook.com (2603:10b6:806:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.18; Thu, 24 Nov
 2022 17:41:03 +0000
Received: from DM6NAM11FT087.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ba:cafe::e8) by DS7PR03CA0232.outlook.office365.com
 (2603:10b6:5:3ba::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19 via Frontend
 Transport; Thu, 24 Nov 2022 17:41:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM6NAM11FT087.mail.protection.outlook.com (10.13.172.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.8 via Frontend Transport; Thu, 24 Nov 2022 17:41:03 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 24 Nov
 2022 09:40:56 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 24 Nov 2022 09:40:55 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Thu, 24 Nov 2022 09:40:53 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>
Subject: [PATCH V1 vfio 11/14] vfio/mlx5: Consider temporary end of stream as part of PRE_COPY
Date:   Thu, 24 Nov 2022 19:39:29 +0200
Message-ID: <20221124173932.194654-12-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221124173932.194654-1-yishaih@nvidia.com>
References: <20221124173932.194654-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT087:EE_|SA0PR12MB4384:EE_
X-MS-Office365-Filtering-Correlation-Id: 7734db70-b224-4414-8637-08dace430eb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jOs38wlNUHLeJNenfydaQ+UlgREbKbBotXhAES56lWJcvXJlRIQ7giPog1ZL+M25wixybBwbUW9qzPnkLa0gEDayMt2TPi9BWu2ub2G7sNzjGV+0OcYgQbDp4GPKeAmPfDMdi1z9xd3ofPHP0EAGReKZx+65ciOGlLG4133euvolwOu2wcXxXhhQd17V4W49HnPovZUWBYvYbrrdt0/5tB0FbK+nqZGjlUVGfN3ATWvpebl/i50ZmX02SbL1IYzkrBz8GQwZKYBchUxYbpv/8fHeGlRWI3YGTlijoLW3M+WD4O21JkamgkqcrGIg7MeW4zPqKb+qrYTd9z7cb9zFKGaOGeiXiFlpvdpdTC6Zc96F4KmfmcM2B9UZVNU0qF/wV0S1X7BlmwvljqZQ1f2j0+k37M8hRX//YnZKSKScOHSdxGA1rQ6XxLfSYOsd9RtQSaIQOEUzVq0ixBxG42t3yCKIA4bhvRKWmJMC4EKFe6wJ98vN1psjtbKIIg/r6T1AHGssnSwE22QqhuK3cpKje1qrGv2+Qj9zzVZ0iG6Cuf+waWQi5UX7HyH6xmL1Y1gjaMokGNrqAREQjd3dOQo9pkJdst/ArQAfe8sA9DjznZhTIdgPPFyEluF1Hw0CoMlKBgLJFAw+Kpd55zqz1R1Cvsr8quXiF87qX8Hj4Pef9my/FrAOYypggA/AM/SAVgKxUNIVQCfo+phIDaJu2MqZyw==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(346002)(396003)(39860400002)(451199015)(40470700004)(36840700001)(46966006)(2616005)(8676002)(336012)(186003)(70206006)(426003)(1076003)(47076005)(70586007)(5660300002)(36756003)(4326008)(478600001)(83380400001)(7636003)(41300700001)(356005)(40460700003)(86362001)(82740400003)(110136005)(36860700001)(6636002)(40480700001)(316002)(8936002)(54906003)(2906002)(26005)(6666004)(82310400005)(7696005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2022 17:41:03.0110
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7734db70-b224-4414-8637-08dace430eb9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT087.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4384
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

During PRE_COPY the migration data FD may have a temporary "end of
stream" that is reached when the initial_bytes were read and no other
dirty data exists yet.

For instance, this may indicate that the device is idle and not
currently dirtying any internal state. When read() is done on this
temporary end of stream the kernel driver should return ENOMSG from
read(). Userspace can wait for more data or consider moving to
STOP_COPY.

To not block the user upon read() and let it get ENOMSG we add a new
state named MLX5_MIGF_STATE_PRE_COPY on the migration file.

In addition, we add the MLX5_MIGF_STATE_SAVE_LAST state to block the
read() once we call the last SAVE upon moving to STOP_COPY.

Any further error will be marked with MLX5_MIGF_STATE_ERROR and the user
won't be blocked.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  | 7 +++++--
 drivers/vfio/pci/mlx5/cmd.h  | 2 ++
 drivers/vfio/pci/mlx5/main.c | 7 +++++++
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 65764ca1b31a..6ec71bc6be83 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -501,8 +501,8 @@ static void mlx5vf_save_callback(int status, struct mlx5_async_work *context)
 		spin_lock_irqsave(&migf->list_lock, flags);
 		list_add_tail(&async_data->buf->buf_elm, &migf->buf_list);
 		spin_unlock_irqrestore(&migf->list_lock, flags);
-		if (async_data->last_chunk)
-			migf->state = MLX5_MIGF_STATE_COMPLETE;
+		migf->state = async_data->last_chunk ?
+			MLX5_MIGF_STATE_COMPLETE : MLX5_MIGF_STATE_PRE_COPY;
 		wake_up_interruptible(&migf->poll_wait);
 	}
 
@@ -561,6 +561,9 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 		}
 	}
 
+	if (async_data->last_chunk)
+		migf->state = MLX5_MIGF_STATE_SAVE_LAST;
+
 	async_data->header_buf = header_buf;
 	get_file(migf->filp);
 	err = mlx5_cmd_exec_cb(&migf->async_ctx, in, sizeof(in),
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index 2b77e2ab9cd2..67bc77605bc5 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -14,6 +14,8 @@
 
 enum mlx5_vf_migf_state {
 	MLX5_MIGF_STATE_ERROR = 1,
+	MLX5_MIGF_STATE_PRE_COPY,
+	MLX5_MIGF_STATE_SAVE_LAST,
 	MLX5_MIGF_STATE_COMPLETE,
 };
 
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 2f5f83f2b2a4..28185085008f 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -219,6 +219,7 @@ static ssize_t mlx5vf_save_read(struct file *filp, char __user *buf, size_t len,
 		if (wait_event_interruptible(migf->poll_wait,
 				!list_empty(&migf->buf_list) ||
 				migf->state == MLX5_MIGF_STATE_ERROR ||
+				migf->state == MLX5_MIGF_STATE_PRE_COPY ||
 				migf->state == MLX5_MIGF_STATE_COMPLETE))
 			return -ERESTARTSYS;
 	}
@@ -236,6 +237,12 @@ static ssize_t mlx5vf_save_read(struct file *filp, char __user *buf, size_t len,
 							 &end_of_data);
 		if (first_loop_call) {
 			first_loop_call = false;
+			/* Temporary end of file as part of PRE_COPY */
+			if (end_of_data && migf->state == MLX5_MIGF_STATE_PRE_COPY) {
+				done = -ENOMSG;
+				goto out_unlock;
+			}
+
 			if (end_of_data && migf->state != MLX5_MIGF_STATE_COMPLETE) {
 				if (filp->f_flags & O_NONBLOCK) {
 					done = -EAGAIN;
-- 
2.18.1

