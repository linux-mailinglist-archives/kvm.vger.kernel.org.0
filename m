Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5F7A643ECF
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 09:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234350AbiLFIgp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 03:36:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234135AbiLFIgQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 03:36:16 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on20630.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6AE81D66A
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 00:36:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LlG8KQW+lRzEuJnqFAzujGHZnDnqr8pU3ugtYKPCf6u8ySouVhfRjgHGfO4YC+AQ2NUWj662E1yXg+tre+6jK7z8x7+co6ta5fIqfR+d5dmjIfzE3NkbGAWHTd4VErY8GCkRQm5jaNghHFjQkctVw0d1g8vfEpQXPwa+zurTkZnkHyIsBZRGq1bMlMCmCyg36W6HCsFCa2DXCzPrdfhCwUd/25zl1T6YiIG0SLOnl+gMCo0K0ysktpoYbJJnKtujTT6Vqq9D7xe5NN3LHMg1BPxS5FV+9k/PVzuRJpyn+2tn5EZFlQjrj2Nvo64vpTq4jIIl9NItxXC/XhssvYZdOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bXx9Fzjy+38LviNvrDFNjQ5sBeK7huvH6hzkO24dtT4=;
 b=dvtRKWDgSSbXEwThtsSAxqD6JNasxmkdaJFolHtrI+yywep4t7/OQQ6kP0/l2a4Z+nf01qJxV2lJnk2JvfAbEOrs11TfDJhoypTsSxHZhV92ky7ftUL1KoonPf7cepLPrxqDMjqDOwajsl10e74dPzSOLeO8/GiBna8CTnMEp7oLZfyqbTs7cKJsMVO1Rc7Fa1x4nlXMEac7RAjfEb12EQBTa5cQPTr9DmaXpwyFmwgcDrBRj8Aan/Qc+OygT4Xj6eqZx0Xlf9h/B7IoLtxltwZFMWwl7L6jlWAo2kQNuGacj4Q0RQXpaegl97mfA10SA5arLKUc1/g22bs7Zb7QIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bXx9Fzjy+38LviNvrDFNjQ5sBeK7huvH6hzkO24dtT4=;
 b=fznNjzFCD8uMVbDa4FgVOQSHzMsAJe04ykZ685z1BHh+bw7t6SYFWmS6tO4me65aPAaFDQN5au9jtq1sYJ1PHq9qs51ilx+RbkkGFMQso6Xj+D142x4wqGJrLxj2xyi1BdxC+OqB0dH8pA4EWk+uYHZFPPPbwv4pZ3OdUaRvanhe+6jl1iajT3TOKm5c/fGJucNnMQbwHTtFmZIWDT5cE3ehSyaEQ6AXzhKXZ5txbZ0McsnAJBJsForm8sg+oOZxFm27/kWi0X30lZoyFJJ+vZD0TANwpeyNaAhKXjI6hj+kLcqlrgTZSkIOw3Am9uCn3keNlDkFmmPe6bAK+uxB1A==
Received: from DS7PR06CA0017.namprd06.prod.outlook.com (2603:10b6:8:2a::24) by
 IA1PR12MB6602.namprd12.prod.outlook.com (2603:10b6:208:3a2::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14; Tue, 6 Dec 2022 08:36:03 +0000
Received: from CY4PEPF0000C97D.namprd02.prod.outlook.com
 (2603:10b6:8:2a:cafe::99) by DS7PR06CA0017.outlook.office365.com
 (2603:10b6:8:2a::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Tue, 6 Dec 2022 08:36:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CY4PEPF0000C97D.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8 via Frontend Transport; Tue, 6 Dec 2022 08:36:02 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 6 Dec 2022
 00:35:50 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 6 Dec 2022 00:35:49 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Tue, 6 Dec 2022 00:35:47 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V4 vfio 11/14] vfio/mlx5: Consider temporary end of stream as part of PRE_COPY
Date:   Tue, 6 Dec 2022 10:34:35 +0200
Message-ID: <20221206083438.37807-12-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221206083438.37807-1-yishaih@nvidia.com>
References: <20221206083438.37807-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C97D:EE_|IA1PR12MB6602:EE_
X-MS-Office365-Filtering-Correlation-Id: d96ca169-b4a3-46b7-84ff-08dad764e8dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gbqjFumFqz49N2+Vxn4s+vgdB1ImqEr1h/oZOppEz/qyhlvl+Gi9usAmz4O+qizdW6bCOHoUbA2uUvTDW0/+NQAvaiB0E+6373RjTnMnFcBRsqteaEUB8Ga1C4NHxboZXgJ2JnvKNUkLkoryb1x/MVVOC30omMpb3gi8/EzSqFXu1g+QHrQy4VSKL9zziEZ8xZ+CwfOyeivMA3F0SMHSjpoVPIf4bPQ74DNXeKIwMouYx+fLoMegCf7iWGSDEhh2flB5+CW/vlqHlufs+lITXHBZBnhNv5Vs60gP+U3AHnzB7VAVX7QkiK3FBGgVv7VsLyOqb/2a88QwMzC8StMGdvBuOgIitd/CpeaFfpw/HPFISL4w/7YQdJ2iCnWoQtWNgEiBY9JsCVMmUUnEQILWd9HTZoEsU2eCsvY9k6BfAXr02k+rQGanU3ZBCZsXCVM2VrFQC9hXHpIqLP01HtKGStZaGMFCvSM8AlkEG50b/9z9EC9q1oiWn5pWcwDzQnBwiMnnthpYc2susWnbxeJ89hUAp9LbhRyampsZL3Y0ThJVAmf5W7AjPTIcTrO4pJnW0Mi9M+bwPZsnUmeCVorWJ5cEWPdpUl38oE/PjEi5pLyT2G3SbgjivwZ9mfH6ChMc8CGw56EBV94bwVDzLjeld+AaV48sRlYMxWkpYjJvrg6Izi+DhB6uJrtZfVq40UG70aUOeMNXzvN/RIRkDk5j2w==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(396003)(39860400002)(451199015)(40470700004)(36840700001)(46966006)(8936002)(426003)(5660300002)(356005)(7636003)(336012)(47076005)(82740400003)(82310400005)(54906003)(478600001)(316002)(6666004)(83380400001)(2906002)(6636002)(70586007)(70206006)(26005)(8676002)(36756003)(86362001)(4326008)(41300700001)(110136005)(2616005)(1076003)(7696005)(40460700003)(36860700001)(186003)(40480700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 08:36:02.8785
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d96ca169-b4a3-46b7-84ff-08dad764e8dd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C97D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6602
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  | 7 +++++--
 drivers/vfio/pci/mlx5/cmd.h  | 2 ++
 drivers/vfio/pci/mlx5/main.c | 7 +++++++
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 12e74ecebe64..f6293da033cc 100644
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
index 3e36ccca820a..d048f23977dd 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -17,6 +17,8 @@
 
 enum mlx5_vf_migf_state {
 	MLX5_MIGF_STATE_ERROR = 1,
+	MLX5_MIGF_STATE_PRE_COPY,
+	MLX5_MIGF_STATE_SAVE_LAST,
 	MLX5_MIGF_STATE_COMPLETE,
 };
 
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 2c8ac763057c..44b1543c751c 100644
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

