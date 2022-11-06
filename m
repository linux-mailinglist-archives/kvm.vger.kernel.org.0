Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55ACA61E506
	for <lists+kvm@lfdr.de>; Sun,  6 Nov 2022 18:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbiKFRrr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Nov 2022 12:47:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbiKFRrg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Nov 2022 12:47:36 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2071.outbound.protection.outlook.com [40.107.92.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8A5645D
        for <kvm@vger.kernel.org>; Sun,  6 Nov 2022 09:47:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jPMjPoJGOiuIg4lBX6uXON/HQRktc72ch/oXHAsEXSXpHp6PP7byr6+JKMa1hWhipKZw39XHR4CHrxfvcCAeRWfFqzdVFuGTIaucs32tBJUl3mJVQsTGmwRioZB/GEGggGM6g4qMQX3X7YLjnjYHeFie0y1hgPc513vB0Oiy2bM3wzoE8s5GFs06lpuz4HsCK0xh/1w0/M2xCNOuRHY9VQhDeF2rjmI+Hb5TKSa5lYL6zXwNor9sgeUwwoHmVkeHZszP8S1dDGb1PHz7CV3nOxiBmCTpwQa1OttWcQ7rC93Hb74Vhxx3kMNngCYbZDq/00VaqV4mhSsfrBnKrxomtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=diXj7f3QuBargLHsZbFMFsSsR9eYFubMtd/+pUWMaA4=;
 b=d2RbAVq2vHmsMTu31otOS0PImn0t+ll/oEqwFEZfefIM99+w3Oe6UYxEX9OPK+Nf1mcxc9EKAkbmOstGfool0iY4l7Dns2VwP4f9KJkr/x2N78tpJ2dXgOidnbJUF9uqfSGGvUEGkYfXG/21eBw/YSE2PcuxHnj9zQ5wEMvymrDt3BnmKKJzfdxnvJTudGiYSwjutRoBOxRQY9plLRvAwPQ/IO1cOnZZcfJCDm0E+8T5EAlQYHq6UlGzYhmxX8nZp4YwJ9fFT2cgXyEMjUWra6kw2dSk9M+cDvxmRxLE2Vi2sDuAt4s93mzFpA9y9INUzlgOJABB/Am3dEL3XjRxBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=diXj7f3QuBargLHsZbFMFsSsR9eYFubMtd/+pUWMaA4=;
 b=rinSljeWpOwUMYZfmku6PreKNSfS9X5D4RdwE2Wg+FBAAEK/enDyhWGzw5SIoD9g+MiYhE1v1WtGyvbVP8TOCxvUgsspyWiPENtiiWxlA9qRDL9tynnv82/Eu9/3quxwTDp5lrV7H6eGPaQDKBygwJqofMPJDBkYrSekELclzmHdzZPxG5luw364nilyKSfILn8RKpUiGItK7uhqi5SPVkOYvXioGeEnS4JmPg/rf2q4ZTUUTRnpzQc+D6/ODOmuR+G6xvwSTfzvNyKhs3xtgHoLxiwcd74mSd8oHwc09d5aWRhPl8uW0DlFClP7sj+JFOauQixq04mPQaRQHmrcgA==
Received: from DM6PR08CA0051.namprd08.prod.outlook.com (2603:10b6:5:1e0::25)
 by SN7PR12MB6790.namprd12.prod.outlook.com (2603:10b6:806:269::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Sun, 6 Nov
 2022 17:47:31 +0000
Received: from DM6NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1e0:cafe::53) by DM6PR08CA0051.outlook.office365.com
 (2603:10b6:5:1e0::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25 via Frontend
 Transport; Sun, 6 Nov 2022 17:47:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM6NAM11FT058.mail.protection.outlook.com (10.13.172.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20 via Frontend Transport; Sun, 6 Nov 2022 17:47:31 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Sun, 6 Nov 2022
 09:47:29 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Sun, 6 Nov 2022 09:47:28 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Sun, 6 Nov 2022 09:47:25 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>
Subject: [PATCH vfio 07/13] vfio/mlx5: Introduce device transitions of PRE_COPY
Date:   Sun, 6 Nov 2022 19:46:24 +0200
Message-ID: <20221106174630.25909-8-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221106174630.25909-1-yishaih@nvidia.com>
References: <20221106174630.25909-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT058:EE_|SN7PR12MB6790:EE_
X-MS-Office365-Filtering-Correlation-Id: 77773e22-c4c6-400a-099f-08dac01efa93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QJ97t508WhjN3QjIaIkCLCz2ONeLBvEeouXennskz7ZSOgm5tVJYaS/PfohMZWr6/GSyEj6oK6M+fws/Jn9B87BwCR4ZVAIxbQeprdW/Px/hDkHwqc1CnnKZrmOxyLGYup/14MfdvYfO1ZRTIHR5HQ2S43o9N++tgxDP9B8X+QpnmC8MiydZytzfKPcLCIfHpj5QTE+VtmsitEgzXg8/S3pWeU/8BrT+TnJx9tdEOrxJpn4GrXJQfnnAor1XiPdI17wyGH5xMERyrD/T15/PYv3FqrJnFPJJSQ/OwioIL9JTPtUCFxpLcFrnDqvwfZmG/8m1DeQDUb3q2HILQcXbqVUwZMjpmDZ6467/gxU0FDfyo6OWUPN6zYAvoysJ6US2zZMRzEIKUb49xjZi0nO2w0yMfzZj6xX97Ic0/YLSCGvtZZck7FaeFEALiX9ddbJvTJMxLc4GfiLP8zPMfmWX9NNL7EjzFhQpAILZXgWWjo7PHYFSNaDgbDe7JxhIbS6PL6skiwlIZH3wMyVzLpWdXzR2CJ7QoD3SSUEsHHcv/hXpnrpRuekcBxgnNudUM8hYGYjVhTsmRK4D71ZxYymPYElV8hKJOmVjFE/YS/ZV2a6+Xe7YYBAadVIBbIeIDNKIIBVE0DWTgp1AmEcejbTYqGo/C74HcMiIvzAm0v2fcpBIR+9w0hI44yDDHFRSnEkl5yFpye1/yPpW6Wb2/cUI5Yo/wfJC6+6s3TK25KHSwH6k6X0sL7rIAEDfxmeDNGSIp0pIebvbrwO2XkZAyeE4ig==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(376002)(346002)(136003)(451199015)(46966006)(36840700001)(40470700004)(8936002)(5660300002)(66899015)(36860700001)(82740400003)(82310400005)(30864003)(41300700001)(83380400001)(7696005)(70586007)(2906002)(70206006)(336012)(47076005)(7636003)(4326008)(426003)(8676002)(356005)(26005)(110136005)(316002)(6636002)(54906003)(36756003)(86362001)(40480700001)(478600001)(40460700003)(2616005)(1076003)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2022 17:47:31.0276
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 77773e22-c4c6-400a-099f-08dac01efa93
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6790
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

In order to support PRE_COPY, mlx5 driver is transferring multiple
states (images) of the device. e.g.: the source VF can save and transfer
multiple states, and the target VF will load them by that order.

The device is saving three kinds of states:
1) Initial state - when the device moves to PRE_COPY state.
2) Middle state - during PRE_COPY phase via VFIO_MIG_GET_PRECOPY_INFO.
   There can be multiple states of this type.
3) Final state - when the device moves to STOP_COPY state.

After moving to PRE_COPY state, user is holding the saving migf FD and
can use it. For example: user can start transferring data via read()
callback. Also, user can switch from PRE_COPY to STOP_COPY whenever he
sees it fits. This will invoke saving of final state.

This means that mlx5 VFIO device can be switched to STOP_COPY without
transferring any data in PRE_COPY state. Therefore, when the device
moves to STOP_COPY, mlx5 will store the final state on a dedicated data
structure.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  | 56 +++++++++++++++-------
 drivers/vfio/pci/mlx5/cmd.h  | 16 ++++++-
 drivers/vfio/pci/mlx5/main.c | 93 +++++++++++++++++++++++++++++++-----
 3 files changed, 134 insertions(+), 31 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 24c6d2e4c2be..eb684455c2b2 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -14,6 +14,7 @@ _mlx5vf_free_page_tracker_resources(struct mlx5vf_pci_core_device *mvdev);
 
 int mlx5vf_cmd_suspend_vhca(struct mlx5vf_pci_core_device *mvdev, u16 op_mod)
 {
+	struct mlx5_vf_migration_file *migf = mvdev->saving_migf;
 	u32 out[MLX5_ST_SZ_DW(suspend_vhca_out)] = {};
 	u32 in[MLX5_ST_SZ_DW(suspend_vhca_in)] = {};
 
@@ -21,6 +22,14 @@ int mlx5vf_cmd_suspend_vhca(struct mlx5vf_pci_core_device *mvdev, u16 op_mod)
 	if (mvdev->mdev_detach)
 		return -ENOTCONN;
 
+	/*
+	 * In case PRE_COPY is used, saving_migf is exposed while the device is
+	 * running. Make sure to run only once there is no active save command.
+	 * Running both in parallel, might end-up with a failure in the save
+	 * command once it will try to turn on 'tracking' on a suspended device.
+	 */
+	if (migf)
+		wait_event(migf->save_wait, !migf->save_cb_active);
 	MLX5_SET(suspend_vhca_in, in, opcode, MLX5_CMD_OP_SUSPEND_VHCA);
 	MLX5_SET(suspend_vhca_in, in, vhca_id, mvdev->vhca_id);
 	MLX5_SET(suspend_vhca_in, in, op_mod, op_mod);
@@ -45,7 +54,7 @@ int mlx5vf_cmd_resume_vhca(struct mlx5vf_pci_core_device *mvdev, u16 op_mod)
 }
 
 int mlx5vf_cmd_query_vhca_migration_state(struct mlx5vf_pci_core_device *mvdev,
-					  size_t *state_size)
+					  size_t *state_size, u8 query_flags)
 {
 	u32 out[MLX5_ST_SZ_DW(query_vhca_migration_state_out)] = {};
 	u32 in[MLX5_ST_SZ_DW(query_vhca_migration_state_in)] = {};
@@ -59,6 +68,8 @@ int mlx5vf_cmd_query_vhca_migration_state(struct mlx5vf_pci_core_device *mvdev,
 		 MLX5_CMD_OP_QUERY_VHCA_MIGRATION_STATE);
 	MLX5_SET(query_vhca_migration_state_in, in, vhca_id, mvdev->vhca_id);
 	MLX5_SET(query_vhca_migration_state_in, in, op_mod, 0);
+	MLX5_SET(query_vhca_migration_state_in, in, incremental,
+		 query_flags & MLX5VF_QUERY_INC);
 
 	ret = mlx5_cmd_exec_inout(mvdev->mdev, query_vhca_migration_state, in,
 				  out);
@@ -210,11 +221,11 @@ static int mlx5vf_cmd_get_vhca_id(struct mlx5_core_dev *mdev, u16 function_id,
 }
 
 static int _create_mkey(struct mlx5_core_dev *mdev, u32 pdn,
-			struct mlx5_vf_migration_file *migf,
+			struct sg_table *sgt,
 			struct mlx5_vhca_recv_buf *recv_buf,
 			u32 *mkey, size_t length)
 {
-	size_t npages = migf ? DIV_ROUND_UP(length, PAGE_SIZE) :
+	size_t npages = sgt ? DIV_ROUND_UP(length, PAGE_SIZE) :
 				recv_buf->npages;
 	int err = 0, inlen;
 	__be64 *mtt;
@@ -232,10 +243,10 @@ static int _create_mkey(struct mlx5_core_dev *mdev, u32 pdn,
 		 DIV_ROUND_UP(npages, 2));
 	mtt = (__be64 *)MLX5_ADDR_OF(create_mkey_in, in, klm_pas_mtt);
 
-	if (migf) {
+	if (sgt) {
 		struct sg_dma_page_iter dma_iter;
 
-		for_each_sgtable_dma_page(&migf->table.sgt, &dma_iter, 0)
+		for_each_sgtable_dma_page(sgt, &dma_iter, 0)
 			*mtt++ = cpu_to_be64(sg_page_iter_dma_address(&dma_iter));
 	} else {
 		int i;
@@ -255,7 +266,7 @@ static int _create_mkey(struct mlx5_core_dev *mdev, u32 pdn,
 	MLX5_SET(mkc, mkc, qpn, 0xffffff);
 	MLX5_SET(mkc, mkc, log_page_size, PAGE_SHIFT);
 	MLX5_SET(mkc, mkc, translations_octword_size, DIV_ROUND_UP(npages, 2));
-	MLX5_SET64(mkc, mkc, len, migf ? length : (npages * PAGE_SIZE));
+	MLX5_SET64(mkc, mkc, len, sgt ? length : (npages * PAGE_SIZE));
 	err = mlx5_core_create_mkey(mdev, mkey, in, inlen);
 	kvfree(in);
 	return err;
@@ -277,7 +288,7 @@ void mlx5vf_mig_file_cleanup_cb(struct work_struct *_work)
 	mutex_unlock(&migf->lock);
 
 	mlx5_core_destroy_mkey(mdev, async_data->mkey);
-	dma_unmap_sgtable(mdev->device, &migf->table.sgt, DMA_FROM_DEVICE, 0);
+	dma_unmap_sgtable(mdev->device, async_data->sgt, DMA_FROM_DEVICE, 0);
 	mlx5_core_dealloc_pd(mdev, async_data->pdn);
 	kvfree(async_data->out);
 	migf->save_cb_active = false;
@@ -293,9 +304,14 @@ static void mlx5vf_save_callback(int status, struct mlx5_async_work *context)
 			struct mlx5_vf_migration_file, async_data);
 
 	if (!status) {
-		WRITE_ONCE(migf->image_length,
-			   MLX5_GET(save_vhca_state_out, async_data->out,
-				    actual_image_size));
+		size_t len = MLX5_GET(save_vhca_state_out, async_data->out,
+				      actual_image_size);
+
+		if (async_data->sgt == &migf->final_table.sgt)
+			WRITE_ONCE(migf->final_length, len);
+		else
+			WRITE_ONCE(migf->image_length, len);
+
 		wake_up_interruptible(&migf->poll_wait);
 	}
 
@@ -308,7 +324,8 @@ static void mlx5vf_save_callback(int status, struct mlx5_async_work *context)
 }
 
 int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
-			       struct mlx5_vf_migration_file *migf)
+			       struct mlx5_vf_migration_file *migf, bool inc,
+			       bool track)
 {
 	u32 out_size = MLX5_ST_SZ_BYTES(save_vhca_state_out);
 	u32 in[MLX5_ST_SZ_DW(save_vhca_state_in)] = {};
@@ -327,12 +344,15 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	if (err)
 		return err;
 
-	err = dma_map_sgtable(mdev->device, &migf->table.sgt, DMA_FROM_DEVICE,
-			      0);
+	async_data = &migf->async_data;
+	async_data->sgt = (!track && inc) ? &migf->final_table.sgt :
+		&migf->table.sgt;
+	err = dma_map_sgtable(mdev->device, async_data->sgt,
+			      DMA_FROM_DEVICE, 0);
 	if (err)
 		goto err_dma_map;
 
-	err = _create_mkey(mdev, pdn, migf, NULL,
+	err = _create_mkey(mdev, pdn, async_data->sgt, NULL,
 			   &mkey, migf->allocated_length);
 	if (err)
 		goto err_create_mkey;
@@ -343,8 +363,9 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	MLX5_SET(save_vhca_state_in, in, vhca_id, mvdev->vhca_id);
 	MLX5_SET(save_vhca_state_in, in, mkey, mkey);
 	MLX5_SET(save_vhca_state_in, in, size, migf->allocated_length);
+	MLX5_SET(save_vhca_state_in, in, incremental, inc);
+	MLX5_SET(save_vhca_state_in, in, set_track, track);
 
-	async_data = &migf->async_data;
 	async_data->out = kvzalloc(out_size, GFP_KERNEL);
 	if (!async_data->out) {
 		err = -ENOMEM;
@@ -370,7 +391,7 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 err_out:
 	mlx5_core_destroy_mkey(mdev, mkey);
 err_create_mkey:
-	dma_unmap_sgtable(mdev->device, &migf->table.sgt, DMA_FROM_DEVICE, 0);
+	dma_unmap_sgtable(mdev->device, async_data->sgt, DMA_FROM_DEVICE, 0);
 err_dma_map:
 	mlx5_core_dealloc_pd(mdev, pdn);
 	migf->save_cb_active = false;
@@ -405,7 +426,8 @@ int mlx5vf_cmd_load_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	if (err)
 		goto err_reg;
 
-	err = _create_mkey(mdev, pdn, migf, NULL, &mkey, migf->image_length);
+	err = _create_mkey(mdev, pdn, &migf->table.sgt, NULL, &mkey,
+			   migf->image_length);
 	if (err)
 		goto err_mkey;
 
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index b1fa1a0418a5..c12fa81ba53f 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -15,6 +15,7 @@
 struct mlx5vf_async_data {
 	struct mlx5_async_work cb_work;
 	struct work_struct work;
+	struct sg_table *sgt;
 	int status;
 	u32 pdn;
 	u32 mkey;
@@ -31,6 +32,12 @@ struct mlx5_vf_migration_file {
 	struct sg_append_table table;
 	size_t image_length;
 	size_t allocated_length;
+	/*
+	 * The device can be moved to stop_copy before the previous state was
+	 * fully read. Another set of variables is needed to maintain it.
+	 */
+	size_t final_length;
+	struct sg_append_table final_table;
 
 	/* Optimize mlx5vf_get_migration_page() for sequential access */
 	struct scatterlist *last_offset_sg;
@@ -115,17 +122,22 @@ struct mlx5vf_pci_core_device {
 	struct mlx5_core_dev *mdev;
 };
 
+enum {
+	MLX5VF_QUERY_INC = (1UL << 0),
+};
+
 int mlx5vf_cmd_suspend_vhca(struct mlx5vf_pci_core_device *mvdev, u16 op_mod);
 int mlx5vf_cmd_resume_vhca(struct mlx5vf_pci_core_device *mvdev, u16 op_mod);
 int mlx5vf_cmd_query_vhca_migration_state(struct mlx5vf_pci_core_device *mvdev,
-					  size_t *state_size);
+					  size_t *state_size, u8 query_flags);
 void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev,
 			       const struct vfio_migration_ops *mig_ops,
 			       const struct vfio_log_ops *log_ops);
 void mlx5vf_cmd_remove_migratable(struct mlx5vf_pci_core_device *mvdev);
 void mlx5vf_cmd_close_migratable(struct mlx5vf_pci_core_device *mvdev);
 int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
-			       struct mlx5_vf_migration_file *migf);
+			       struct mlx5_vf_migration_file *migf, bool inc,
+			       bool track);
 int mlx5vf_cmd_load_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 			       struct mlx5_vf_migration_file *migf);
 void mlx5vf_state_mutex_unlock(struct mlx5vf_pci_core_device *mvdev);
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 624b1a99dc21..10e073c32ab1 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -64,7 +64,8 @@ mlx5vf_get_migration_page(struct mlx5_vf_migration_file *migf,
 }
 
 static int mlx5vf_add_migration_pages(struct mlx5_vf_migration_file *migf,
-				      unsigned int npages)
+				      unsigned int npages,
+				      struct sg_append_table *table)
 {
 	unsigned int to_alloc = npages;
 	struct page **page_list;
@@ -85,7 +86,7 @@ static int mlx5vf_add_migration_pages(struct mlx5_vf_migration_file *migf,
 		}
 		to_alloc -= filled;
 		ret = sg_alloc_append_table_from_pages(
-			&migf->table, page_list, filled, 0,
+			table, page_list, filled, 0,
 			filled << PAGE_SHIFT, UINT_MAX, SG_MAX_SINGLE_ALLOC,
 			GFP_KERNEL);
 
@@ -118,7 +119,11 @@ static void mlx5vf_disable_fd(struct mlx5_vf_migration_file *migf)
 	migf->disabled = true;
 	migf->image_length = 0;
 	migf->allocated_length = 0;
+	migf->final_length = 0;
 	migf->filp->f_pos = 0;
+	for_each_sgtable_page(&migf->final_table.sgt, &sg_iter, 0)
+		__free_page(sg_page_iter_page(&sg_iter));
+	sg_free_append_table(&migf->final_table);
 	mutex_unlock(&migf->lock);
 }
 
@@ -215,6 +220,16 @@ static __poll_t mlx5vf_save_poll(struct file *filp,
 	return pollflags;
 }
 
+/*
+ * FD is exposed and user can use it after receiving an error.
+ * Mark migf in error, and wake the user.
+ */
+static void mlx5vf_mark_err(struct mlx5_vf_migration_file *migf)
+{
+	migf->is_err = true;
+	wake_up_interruptible(&migf->poll_wait);
+}
+
 static const struct file_operations mlx5vf_save_fops = {
 	.owner = THIS_MODULE,
 	.read = mlx5vf_save_read,
@@ -223,8 +238,35 @@ static const struct file_operations mlx5vf_save_fops = {
 	.llseek = no_llseek,
 };
 
+static int mlx5vf_pci_save_device_inc_data(struct mlx5vf_pci_core_device *mvdev)
+{
+	struct mlx5_vf_migration_file *migf = mvdev->saving_migf;
+	size_t length;
+	int ret;
+
+	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev, &length,
+						    MLX5VF_QUERY_INC);
+	if (ret)
+		return ret;
+
+	if (migf->is_err)
+		return -ENODEV;
+
+	ret = mlx5vf_add_migration_pages(
+		migf, DIV_ROUND_UP_ULL(length, PAGE_SIZE), &migf->final_table);
+	if (ret) {
+		mlx5vf_mark_err(migf);
+		return ret;
+	}
+
+	ret = mlx5vf_cmd_save_vhca_state(mvdev, migf, true, false);
+	if (ret)
+		mlx5vf_mark_err(migf);
+	return ret;
+}
+
 static struct mlx5_vf_migration_file *
-mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev)
+mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev, bool track)
 {
 	struct mlx5_vf_migration_file *migf;
 	size_t length;
@@ -249,17 +291,17 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev)
 	init_waitqueue_head(&migf->save_wait);
 	mlx5_cmd_init_async_ctx(mvdev->mdev, &migf->async_ctx);
 	INIT_WORK(&migf->async_data.work, mlx5vf_mig_file_cleanup_cb);
-	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev, &length);
+	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev, &length, 0);
 	if (ret)
 		goto out_free;
 
 	ret = mlx5vf_add_migration_pages(
-		migf, DIV_ROUND_UP_ULL(length, PAGE_SIZE));
+		migf, DIV_ROUND_UP_ULL(length, PAGE_SIZE), &migf->table);
 	if (ret)
 		goto out_free;
 
 	migf->mvdev = mvdev;
-	ret = mlx5vf_cmd_save_vhca_state(mvdev, migf);
+	ret = mlx5vf_cmd_save_vhca_state(mvdev, migf, false, track);
 	if (ret)
 		goto out_free;
 	return migf;
@@ -296,7 +338,7 @@ static ssize_t mlx5vf_resume_write(struct file *filp, const char __user *buf,
 		done = mlx5vf_add_migration_pages(
 			migf,
 			DIV_ROUND_UP(requested_length - migf->allocated_length,
-				     PAGE_SIZE));
+				     PAGE_SIZE), &migf->table);
 		if (done)
 			goto out_unlock;
 	}
@@ -403,7 +445,8 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
 		return NULL;
 	}
 
-	if (cur == VFIO_DEVICE_STATE_RUNNING && new == VFIO_DEVICE_STATE_RUNNING_P2P) {
+	if ((cur == VFIO_DEVICE_STATE_RUNNING && new == VFIO_DEVICE_STATE_RUNNING_P2P) ||
+	    (cur == VFIO_DEVICE_STATE_PRE_COPY && new == VFIO_DEVICE_STATE_PRE_COPY_P2P)) {
 		ret = mlx5vf_cmd_suspend_vhca(mvdev,
 			MLX5_SUSPEND_VHCA_IN_OP_MOD_SUSPEND_INITIATOR);
 		if (ret)
@@ -411,7 +454,8 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
 		return NULL;
 	}
 
-	if (cur == VFIO_DEVICE_STATE_RUNNING_P2P && new == VFIO_DEVICE_STATE_RUNNING) {
+	if ((cur == VFIO_DEVICE_STATE_RUNNING_P2P && new == VFIO_DEVICE_STATE_RUNNING) ||
+	    (cur == VFIO_DEVICE_STATE_PRE_COPY_P2P && new == VFIO_DEVICE_STATE_PRE_COPY)) {
 		ret = mlx5vf_cmd_resume_vhca(mvdev,
 			MLX5_RESUME_VHCA_IN_OP_MOD_RESUME_INITIATOR);
 		if (ret)
@@ -422,7 +466,7 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
 	if (cur == VFIO_DEVICE_STATE_STOP && new == VFIO_DEVICE_STATE_STOP_COPY) {
 		struct mlx5_vf_migration_file *migf;
 
-		migf = mlx5vf_pci_save_device_data(mvdev);
+		migf = mlx5vf_pci_save_device_data(mvdev, false);
 		if (IS_ERR(migf))
 			return ERR_CAST(migf);
 		get_file(migf->filp);
@@ -430,7 +474,10 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
 		return migf->filp;
 	}
 
-	if ((cur == VFIO_DEVICE_STATE_STOP_COPY && new == VFIO_DEVICE_STATE_STOP)) {
+	if ((cur == VFIO_DEVICE_STATE_STOP_COPY && new == VFIO_DEVICE_STATE_STOP) ||
+	    (cur == VFIO_DEVICE_STATE_PRE_COPY && new == VFIO_DEVICE_STATE_RUNNING) ||
+	    (cur == VFIO_DEVICE_STATE_PRE_COPY_P2P &&
+	     new == VFIO_DEVICE_STATE_RUNNING_P2P)) {
 		mlx5vf_disable_fds(mvdev);
 		return NULL;
 	}
@@ -455,6 +502,28 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
 		return NULL;
 	}
 
+	if ((cur == VFIO_DEVICE_STATE_RUNNING && new == VFIO_DEVICE_STATE_PRE_COPY) ||
+	    (cur == VFIO_DEVICE_STATE_RUNNING_P2P &&
+	     new == VFIO_DEVICE_STATE_PRE_COPY_P2P)) {
+		struct mlx5_vf_migration_file *migf;
+
+		migf = mlx5vf_pci_save_device_data(mvdev, true);
+		if (IS_ERR(migf))
+			return ERR_CAST(migf);
+		get_file(migf->filp);
+		mvdev->saving_migf = migf;
+		return migf->filp;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_PRE_COPY_P2P && new == VFIO_DEVICE_STATE_STOP_COPY) {
+		ret = mlx5vf_cmd_suspend_vhca(mvdev,
+			MLX5_SUSPEND_VHCA_IN_OP_MOD_SUSPEND_RESPONDER);
+		if (ret)
+			return ERR_PTR(ret);
+		ret = mlx5vf_pci_save_device_inc_data(mvdev);
+		return ret ? ERR_PTR(ret) : NULL;
+	}
+
 	/*
 	 * vfio_mig_get_next_state() does not use arcs other than the above
 	 */
@@ -523,7 +592,7 @@ static int mlx5vf_pci_get_data_size(struct vfio_device *vdev,
 
 	mutex_lock(&mvdev->state_mutex);
 	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev,
-						    &state_size);
+						    &state_size, 0);
 	if (!ret)
 		*stop_copy_length = state_size;
 	mlx5vf_state_mutex_unlock(mvdev);
-- 
2.18.1

