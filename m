Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2AED61E50C
	for <lists+kvm@lfdr.de>; Sun,  6 Nov 2022 18:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbiKFRsJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Nov 2022 12:48:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231200AbiKFRr5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Nov 2022 12:47:57 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2086.outbound.protection.outlook.com [40.107.92.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB34364C6
        for <kvm@vger.kernel.org>; Sun,  6 Nov 2022 09:47:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WpFAQalyLxF2AFp5sBayXjZOI3Lw2xRF0amHWFENCNIce33aLdprtVeyWkNlZ44kSc8kMfsfr2Pkmx1louz/sAFWFX0MKd9BvBijEu+otWZqpt9EGYS0QquYPAiLrXUfs40bDoc+PqzGhQ1aloPOeiRnxJUrEsa+sBQMGtJbWuVDXhZDe6A111IhuejTd655iYq80F0iPZGf49BdnhY25caDO8VLzmHxB3TzSQPFqkaSrpdvcp5270/bm7nPzuyqWJmaGx85MjVhMU9dlWLcWJ8VMXiyZXElKorffJ0BGYV0dACZJ0xt3LMtYnDNu3AYiGwc2w7iBtvMdhBNeAv9eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UCqDW9PzqugI2zfH/SPXxiR9pQahanoteTIeDWiYOuM=;
 b=XoJNC6fDISH3kijaJ0qN9eEBfvUNwehtOIW4DGLqAqZzMr7MQLlEscdnU6vI7+79WWFLTXZVr0kxMLfq7o61GKfhg7AaKAMU0a7JeIpprhRnXq3nSl4vY0i9iQ7eD5+NKftvshnlq2lmEQ5aDJKWQGyBduqrsE7xffeYzSjE/0m3N7V69x0w2cxoZOuXy+fF59Hq+8+dFjNbq8pUfuL2cX//nrgDcxJOjubbfrMlJqpU/CIJoSbN1BWCar22wcyAk1tGWTGM5RtFBMtEomEdJrt3WBXnvD0iiNblDrow8bvkJUggk3M/4MHF/fOHhA9yNi1sIBHd1RvfefEeuT0G9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UCqDW9PzqugI2zfH/SPXxiR9pQahanoteTIeDWiYOuM=;
 b=M+2/HG69C0FsRDsSUxwR4BK5mwrid0cCgrqxZrtdj1BiU9spSljPXoCERt3qvtREnH5xu2Ti9b3j26P5U/TPipOOJBIFFmqbeaMQXLtPgzfsCemNweyex5LwZ1fGzhSAl0wRSqZSVqCLQPYjYvZE2P6Haoy1wWLtx1bEvs6J8m9iUmiciby9oGvmn1uHaC5pS+kbyx5Nkqwj6itgwcHMxBcafey6aeiBp7BwW8db14U0XyTvCi+Hv3sND5AJplb9nAR9AJVa0W3HS9IWkepWIDOwmkrRUC9BTBv+dqdPQ24ml0p0svmIQzl0kAW6UI5Btl03RW9X60pOiwRLJQufvg==
Received: from BN0PR04CA0197.namprd04.prod.outlook.com (2603:10b6:408:e9::22)
 by PH7PR12MB5950.namprd12.prod.outlook.com (2603:10b6:510:1d9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Sun, 6 Nov
 2022 17:47:46 +0000
Received: from BN8NAM11FT083.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e9:cafe::48) by BN0PR04CA0197.outlook.office365.com
 (2603:10b6:408:e9::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25 via Frontend
 Transport; Sun, 6 Nov 2022 17:47:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN8NAM11FT083.mail.protection.outlook.com (10.13.177.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20 via Frontend Transport; Sun, 6 Nov 2022 17:47:45 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Sun, 6 Nov 2022
 09:47:44 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Sun, 6 Nov 2022 09:47:44 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Sun, 6 Nov 2022 09:47:41 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>
Subject: [PATCH vfio 12/13] vfio/mlx5: Fallback to STOP_COPY upon specific PRE_COPY error
Date:   Sun, 6 Nov 2022 19:46:29 +0200
Message-ID: <20221106174630.25909-13-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221106174630.25909-1-yishaih@nvidia.com>
References: <20221106174630.25909-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT083:EE_|PH7PR12MB5950:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fda320d-e281-40ae-517c-08dac01f034c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bcZmRZFL87Rav4a1R2KW9Gyw8q2drJ6HeqdiZ4jN/1SLZ4Z4A8ujQ8NXzooJLhG7naGB6SYAOX++UtVnmJOMcfiTmAJEnrNo4PpjnTwLRk+fzt3Z104wgM2c5BWiTMX/juu3+8jmsg1kfRs8154wB4l4DiZs462+SuW+H1LXwaLWaJhcCG6/tcH1xubxhBSNa3YfvpEE/cZqOa6wyUO/UrcOfjrnp66W+bLKRslLZiKu7ZaF19/AaIVjBPLPEsn8KrZft2W3CBWAFGkhqZFrh8zhYjPoGmayHpm3pWxHWxXS48kkpckbea+wkbwjKSSTLVyfNfVLb6pMQpo/9ZcMUM3JKrjbj8yIPXqhMYO0OIPEuN6g0G897vG9rqGvN7Uq5EpJbmFXu7DUH+Pd9TNBpj0NvNCXd3qYM2GaUxygyTrtMZft9DpcLw4KIhQVo1RtU6X96biaX0nA3IRpipxi6sZsvimCBg81bdp7fUVcGWiCUMcgtxbii3b1SYChJsVpYS7bcs/kje14GxY7dnq8Oyf7if7r2gHzkXR/r/3ALFuIBReAvTACZSwj1JQmtgZV3CGnUM+rpUEQw9i80nW3L2qbP9AXhQQdabb8H3cEIV2nJsPsH71UcS2RmEq2SiKPpdmoUlpEEzwvaSAkiI7vrLz4DmvnjeHXpN+MP1p3iloP87g1QrKwahwd6U+Mc4HVpP7gO72wr5ALC3JJrp9C2ahED5marR1mXMHF9cBw0/CBln9tBNHj+djVDkGABxTVEPZMyt3NelRrZu5sqZCJbg==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(376002)(346002)(136003)(451199015)(40470700004)(46966006)(36840700001)(40460700003)(86362001)(356005)(6666004)(316002)(82740400003)(7696005)(82310400005)(36756003)(70206006)(8676002)(41300700001)(70586007)(4326008)(6636002)(54906003)(36860700001)(26005)(7636003)(186003)(2616005)(336012)(478600001)(1076003)(40480700001)(5660300002)(2906002)(83380400001)(110136005)(47076005)(8936002)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2022 17:47:45.6167
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fda320d-e281-40ae-517c-08dac01f034c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT083.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5950
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

Before a SAVE command is issued, a QUERY command is issued in order to
know the device data size.
In case PRE_COPY is used, the above commands are issued while the device
is running. Thus, it is possible that between the QUERY and the SAVE
commands the state of the device will be changed significantly and thus
the SAVE will fail.

Currently, if a SAVE command is failing, the driver will fail the
migration. In the above case, don't fail the migration, but don't allow
for new SAVEs to be executed while the device is in a RUNNING state.
Once the device will be moved to STOP_COPY, SAVE can be executed again
and the full device state will be read.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  | 30 ++++++++++++++++++++++++++++--
 drivers/vfio/pci/mlx5/cmd.h  |  2 ++
 drivers/vfio/pci/mlx5/main.c |  7 ++++---
 3 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index a1b17cd688b9..ef1c141dc5e0 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -70,9 +70,18 @@ int mlx5vf_cmd_query_vhca_migration_state(struct mlx5vf_pci_core_device *mvdev,
 	 * Running both in parallel, might end-up with a failure in the
 	 * incremental query command on un-tracked vhca.
 	 */
-	if (query_flags & MLX5VF_QUERY_INC)
+	if (query_flags & MLX5VF_QUERY_INC) {
 		wait_event(mvdev->saving_migf->save_wait,
 			   !mvdev->saving_migf->save_cb_active);
+		if (mvdev->saving_migf->precopy_err) {
+			/* In case we had a PRE_COPY error, only query full image for final image */
+			if (!(query_flags & MLX5VF_QUERY_FINAL)) {
+				*state_size = 0;
+				return 0;
+			}
+			query_flags &= ~MLX5VF_QUERY_INC;
+		}
+	}
 	MLX5_SET(query_vhca_migration_state_in, in, opcode,
 		 MLX5_CMD_OP_QUERY_VHCA_MIGRATION_STATE);
 	MLX5_SET(query_vhca_migration_state_in, in, vhca_id, mvdev->vhca_id);
@@ -291,7 +300,10 @@ void mlx5vf_mig_file_cleanup_cb(struct work_struct *_work)
 
 	mutex_lock(&migf->lock);
 	if (async_data->status) {
-		migf->is_err = true;
+		if (async_data->status == MLX5_CMD_STAT_BAD_RES_STATE_ERR)
+			migf->precopy_err = true;
+		else
+			migf->is_err = true;
 		wake_up_interruptible(&migf->poll_wait);
 	}
 	mutex_unlock(&migf->lock);
@@ -328,6 +340,8 @@ static void mlx5vf_save_callback(int status, struct mlx5_async_work *context)
 	 * The error and the cleanup flows can't run from an
 	 * interrupt context
 	 */
+	if (status == -EREMOTEIO)
+		status = MLX5_GET(save_vhca_state_out, async_data->out, status);
 	async_data->status = status;
 	queue_work(migf->mvdev->cb_wq, &async_data->work);
 }
@@ -356,6 +370,18 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	async_data = &migf->async_data;
 	async_data->sgt = (!track && inc) ? &migf->final_table.sgt :
 		&migf->table.sgt;
+	if (migf->precopy_err) {
+		/*
+		 * In case we had a PRE_COPY error, SAVE is triggered only for
+		 * the final image, read device full image.
+		 */
+		inc = false;
+		/*
+		 * Turn off precopy_err to let reader proceed only once this
+		 * SAVE call is completed, otherwise final state might be lost.
+		 */
+		migf->precopy_err = false;
+	}
 	err = dma_map_sgtable(mdev->device, async_data->sgt,
 			      DMA_FROM_DEVICE, 0);
 	if (err)
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index 03f3b5e99879..784670848a7c 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -32,6 +32,7 @@ struct mlx5_vf_migration_file {
 	struct mutex lock;
 	u8 disabled:1;
 	u8 is_err:1;
+	u8 precopy_err:1;
 	u8 save_cb_active:1;
 	u8 header_read:1;
 
@@ -134,6 +135,7 @@ struct mlx5vf_pci_core_device {
 
 enum {
 	MLX5VF_QUERY_INC = (1UL << 0),
+	MLX5VF_QUERY_FINAL = (1UL << 1),
 };
 
 int mlx5vf_cmd_suspend_vhca(struct mlx5vf_pci_core_device *mvdev, u16 op_mod);
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 6cdd4fc93818..db2d0166a0f5 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -243,7 +243,8 @@ static ssize_t mlx5vf_save_read(struct file *filp, char __user *buf, size_t len,
 
 	if (!(filp->f_flags & O_NONBLOCK)) {
 		if (wait_event_interruptible(migf->poll_wait,
-			     (MIGF_HAS_DATA(migf) || migf->is_err)))
+			     (MIGF_HAS_DATA(migf) || migf->is_err ||
+			      migf->precopy_err)))
 			return -ERESTARTSYS;
 	}
 
@@ -351,7 +352,7 @@ static __poll_t mlx5vf_save_poll(struct file *filp,
 	mutex_lock(&migf->lock);
 	if (migf->disabled || migf->is_err)
 		pollflags = EPOLLIN | EPOLLRDNORM | EPOLLRDHUP;
-	else if (MIGF_HAS_DATA(migf))
+	else if (MIGF_HAS_DATA(migf) || migf->precopy_err)
 		pollflags = EPOLLIN | EPOLLRDNORM;
 	mutex_unlock(&migf->lock);
 
@@ -490,7 +491,7 @@ static int mlx5vf_pci_save_device_inc_data(struct mlx5vf_pci_core_device *mvdev)
 	int ret;
 
 	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev, &length,
-						    MLX5VF_QUERY_INC);
+					MLX5VF_QUERY_INC | MLX5VF_QUERY_FINAL);
 	if (ret)
 		return ret;
 
-- 
2.18.1

