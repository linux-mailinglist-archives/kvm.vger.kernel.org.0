Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A78DA63F3F2
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 16:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbiLAPbS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 10:31:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231750AbiLAPas (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 10:30:48 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2060.outbound.protection.outlook.com [40.107.243.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3016AD327
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 07:30:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mpoJ4u+z3fAaI5m2okHaMapg9HZb+6S/EfgeB64+X5Pas52YOOnC6K1NPvU9W3lghtoD7a7EhlK3ml4wzpGDG509qsKyJZU7tJU2TqQRsMpL10w7pAo6d65ug9z4ordmwbEOoukl+7dp16n8kC6QWaifb2J0H+1Duq1lvK0q9fV15qB0c6/cQ8ZtfdMzQE3kHR0RXk2Sk6R590hv8ldx4C3yJGLC9nQ2gksbHRvCRx40KuwrSq3AgD/eFySzkKKaUyDAbCZ5wmSQ78xC2ixh611fHoPKvKo+AW5BEawaPqOqDDZauBg2+XCAUO4km+pbDs+IzHUlFt6Q0uI2jBB1ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UZ7VJ45bPdc2L59UBz4zOx6f+GSAYE9QmGq8LXHsLfg=;
 b=BXlMQPd2+S9ndFbPu2ixJ5rSHhSUk/LiyZyNLgI5rSsrf0gVLxBFFx0jsp4yQFn9S5A5jqQThGGhv+j7QOJZIZQ6+ELxzLzVg3wL4hO3w643+Oaqhf9f3weAxzrDr62xnlV9eCkq304XgW70XsK+HrAgwqLYALsXSkQl56oC62tJtFJ5ynNDqhI64Yqa7e7PsdyUD79uCG/EN8lGqNNpZy/MbKahUemMRxgEhGfDe2mXNF+8SE0n+2tm2hQK9mIutMLR2CJ42ErSlzlnEPLTO5epmBVdkWa5m6gj71pMNCzSI7HIhJgn6sONCzugf9LyzbCELyxSawWgtm6HRuUUqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UZ7VJ45bPdc2L59UBz4zOx6f+GSAYE9QmGq8LXHsLfg=;
 b=Y0xQ75xFxuzUnzzk/vbC15uJNd+eZbRu4F0mnsgZFa8k0x1wqr9nRaOYdoVJpHvM/i5DDueAmSkwUiQwvmJ9ac99Tbb73I4MqjTi4y47VhmDTx2nMn8sedfyBGBa/FXbIlEcjBEMpvZhoWBDxFT9wONwKdQEsnpuSMD8KHdoq1k7KyjhUCkRhurF9RewYXgjgNQ9AT/sQ1rlJN/VZuQRsfFKIeWdT3LnEjbEoyR5g9b+NoimXK63vbxVuA0GDdWHUc4vZv1ypju38kU7CRhwK4hQ6hXHopmoK2AEWeC5kV/oGUpF3kj7omvw7589HSMviF4Qmr/f0Qq4sXxT5ck4DA==
Received: from DM6PR06CA0099.namprd06.prod.outlook.com (2603:10b6:5:336::32)
 by DM6PR12MB4911.namprd12.prod.outlook.com (2603:10b6:5:20e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Thu, 1 Dec
 2022 15:30:45 +0000
Received: from DS1PEPF0000E631.namprd02.prod.outlook.com
 (2603:10b6:5:336:cafe::9e) by DM6PR06CA0099.outlook.office365.com
 (2603:10b6:5:336::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8 via Frontend
 Transport; Thu, 1 Dec 2022 15:30:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS1PEPF0000E631.mail.protection.outlook.com (10.167.17.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8 via Frontend Transport; Thu, 1 Dec 2022 15:30:45 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 1 Dec 2022
 07:30:34 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 1 Dec 2022 07:30:34 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Thu, 1 Dec 2022 07:30:31 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>
Subject: [PATCH V2 vfio 11/14] vfio/mlx5: Consider temporary end of stream as part of PRE_COPY
Date:   Thu, 1 Dec 2022 17:29:28 +0200
Message-ID: <20221201152931.47913-12-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221201152931.47913-1-yishaih@nvidia.com>
References: <20221201152931.47913-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E631:EE_|DM6PR12MB4911:EE_
X-MS-Office365-Filtering-Correlation-Id: 986ca78a-991e-4683-bbba-08dad3b1042c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nUZjiXGpXxbnV0+lfUqQ4bGfiIfkO1dCcCfTZFGXNHNAwNqxzpmPo+HRUUYJ/VSPVOp9W0ILuGoy9/6MQcw0M0T3I/yf5sQVE4CJyoSzSSAEFWrf9wZuMfkT+sEqeNROu/nVuVDvWxyY8p2NmFEfq1Q5YHbL9SJR+MUXrbCEthmZJzdZ9YSmDvJ3PR3SdfNAaCCi1Z755Vbtm9d7ZmhaRSQqTyzeVKPbHYZOw3mwPhFT3uXjfKBupCIzREnx4GSD0rhzmddZtSLf5ZHCEBP6Wep58rijV4BwvpVV/MHY4MiR4TXKM9KJQkUQyVYHX4jp3Ty1CYo/vsP1KYn4sJJ6x9ISrkSX5hkAEJ1U+iSsEnvIEWebp6Zf4t/e20+0Jr6jStqzucXHa4bl2gED0u2IYn3trRDsVirEKCkgeG/jwJD0zSO9pvgyvYX/eTHFNU2pXXAzgYdTlf7bss3DLrBrEm3bRttVtktPHDd8+DB/SeSvs5h1iVUCR8o8mdNXNbwOLdZx0AApvlgjNgaQWcSWugVvnol/8MjgOZ4Yc/vifh+jKUrVnm0oe12Otfui7iWQ/oQFHJ5Omvbg4/wwQVcTCStJPZgVgqP+dt00OhiS6L2ltrttkssoQzJfeb9Ini9UaT6+Q8WmqlI/uTejaByz4mDE+wPdjKZQlOJbVOT7LNgsBTZLA2S4ff/LQVIhkD+57jWmHuMh9pAUdNzZNwtlww==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(136003)(376002)(396003)(451199015)(46966006)(40470700004)(36840700001)(1076003)(2616005)(336012)(40460700003)(6636002)(54906003)(316002)(110136005)(2906002)(40480700001)(36756003)(7636003)(356005)(478600001)(86362001)(6666004)(82740400003)(83380400001)(82310400005)(186003)(26005)(47076005)(426003)(7696005)(5660300002)(8936002)(36860700001)(41300700001)(4326008)(70586007)(8676002)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 15:30:45.7652
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 986ca78a-991e-4683-bbba-08dad3b1042c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E631.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4911
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

