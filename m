Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6CAD61E505
	for <lists+kvm@lfdr.de>; Sun,  6 Nov 2022 18:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbiKFRrh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Nov 2022 12:47:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230473AbiKFRrb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Nov 2022 12:47:31 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2085.outbound.protection.outlook.com [40.107.223.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85382645B
        for <kvm@vger.kernel.org>; Sun,  6 Nov 2022 09:47:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y1G6jZouTet0M71+FIDvpP+SeEEumqTqprzmrkxoW/lnuuoMhWHGI2Jx0aVvn1cimu8TNyQgKfxb5Ct1kgDDkVps4KltONdd9YhcpVsQoCmOyIDDY3gCCg5nkwhBou8Gxjd8/Hot2ar1FphWdj5NqIXEa6sFl0atLYAk/10u6+ZTPqpe0+z3QZOJzaIULbumQe3jkf9JgeGGN9auj51BEWFURlHvh1cU01u37QLh6UC5Vz824f9WqJjNA3FSo+tKNHRZPD4AAKXkid9+h8MjRApSkoj88LUBBJ58uVZ55RPGKFRO9UlbvCVVK4YQK3OMtrwYXQEChmSA6gKyF7fNOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YpnCO5YTassfq8N1pFKeu7XxPZuoZDSG3fe6y3LnAjw=;
 b=W2kpDOSCz8SiYWWokLjL28k6nOXbcuZwmV/3cV9jlYjPYpIs0SbbfabmB4xoJQrF1XMNiVDCwmpgvAyWaFs3hPox/bTVTmN+7cQbfLx14gaN7KZ+aYT9Z/9Ky7UGfc/EtGYJLkcgP79won1X5X5tkGZ3kOKWCR69BcfM5W8PAnEu/VEkTkIJil+OivG50bphrRhrptcD5ijCd4w7H7ghftMuIGCwSXUtWr3iPJA8IbaW1ftuZ07K8+iP1EV4AbOUiRy0SfxPoV+eBKFTsGHWr7BTKIeGnO4xVbXjoUczva+avkqimuwJfYkXfgYHE6vY480edjrx+Xz0J0Ebax57KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YpnCO5YTassfq8N1pFKeu7XxPZuoZDSG3fe6y3LnAjw=;
 b=cqlawIfLUXJ/YDBwu879H5mwFQAlZPj5jO79yfzZSGA6JSQcR153B66oJ+B8KcZd4N38HRRyGFRM0yxnLNywdaT6wi4fr4kKTzgAHB/TYSXQMu+5MNdsaAZ+yGJYwqDCxPoIL8s0tyZoB0EblrcmdJPE3yONHhmAsdsMR4B52QacmkOv72Yky++X73lEAPwvnsjS7KJnl/YvZCCaRal9gLKT1cwEgrJ0XSUx5nivrdYM0Fd1agvN/C4iz0iG+JKOYLI3ZAfV3eGdwZ1RVLBGL/lV3vG46YUNFfMcH/GZ1xLywFcw08gFNz0bbilRz25i1zzoGzo7+hhO+6Jm6BBUZQ==
Received: from BN9PR03CA0648.namprd03.prod.outlook.com (2603:10b6:408:13b::23)
 by SN7PR12MB6789.namprd12.prod.outlook.com (2603:10b6:806:26b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Sun, 6 Nov
 2022 17:47:27 +0000
Received: from BN8NAM11FT085.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13b:cafe::c6) by BN9PR03CA0648.outlook.office365.com
 (2603:10b6:408:13b::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25 via Frontend
 Transport; Sun, 6 Nov 2022 17:47:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN8NAM11FT085.mail.protection.outlook.com (10.13.176.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20 via Frontend Transport; Sun, 6 Nov 2022 17:47:26 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Sun, 6 Nov 2022
 09:47:25 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Sun, 6 Nov 2022 09:47:25 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Sun, 6 Nov 2022 09:47:22 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>
Subject: [PATCH vfio 06/13] vfio/mlx5: Refactor total_length name and usage
Date:   Sun, 6 Nov 2022 19:46:23 +0200
Message-ID: <20221106174630.25909-7-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221106174630.25909-1-yishaih@nvidia.com>
References: <20221106174630.25909-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT085:EE_|SN7PR12MB6789:EE_
X-MS-Office365-Filtering-Correlation-Id: ef7192a0-30c0-408f-4551-08dac01ef80a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MHZdI9mlsz314s7YgReOg1zh5O93Num5gHYaoaMzneCGEfCupdUOaevOXl0tcVGqGMDEWZZ9trlX+vMlDpO0bRNDTrolS75SysmvCZ+2YX0bF67VIrfCziBz4Xw9pCEQaDkzGhdJzWVB1345qQbbU9onrHzpMUWVGMgBY1GPGWdvlNqaiOM3uY2f5ouPVAHIazUFxLMW1PD3wNkXHjZ1ycq7Znbm9MyPyAmTYxHTA/k0Kv0X25I8gMCYLlkNMPvfppCcZubenoVBb/NucW74GI8r3NxB8mSjTx5ALv63rM9ia7LdELgGB1KnLE9sqbIFG7X/8CkqG18YSr0BB2lhut+G8+gsDBK3SR3ii5K8CIC5K8rKP8jRNO9jsZvoGLC+n0eN+EKzaio9lxjftasYB5cMao0DLFTmv7IDXKu25sKcbaIj0S6xOZlAoeazbe9/VkizjnQB8AQzNCx6W6a9eJ3v2k9Qh3kDMXRybiXgCvi/wVjwf0HSODJv2i6ZdobbS2vTWhA3kb4EqvCWzQh+PDALmP2hOn81OzaSGcHJql4WL3Tz03JBrfqg9X/kauwZHIyakjTubb/da5bMfdLiYYyjAi/gy3mL3bCEutlFvm+3dktC7F26QubzX8u0lQVLLI3DSKAMTebbgPcymsFUKgGfRQlm4Dr1l9+v4HvRxtwbzmeU7eeP41zw2NErWEd3QNG87YB4XIPox6qsNVhvH3uS5VQJgYzcwe0lgOKxEow2VtwxFmcyaQT93Ovot4lJ1cEqUR+nqjIvCZF75j/aWg==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(136003)(376002)(39860400002)(451199015)(40470700004)(36840700001)(46966006)(82310400005)(36756003)(110136005)(54906003)(6636002)(316002)(5660300002)(40480700001)(83380400001)(2906002)(7636003)(356005)(478600001)(70586007)(41300700001)(70206006)(4326008)(8676002)(8936002)(82740400003)(2616005)(186003)(1076003)(40460700003)(336012)(426003)(47076005)(26005)(36860700001)(86362001)(7696005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2022 17:47:26.7289
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ef7192a0-30c0-408f-4551-08dac01ef80a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT085.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6789
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

On the source side flow, change the usage of total_length to keep only
the size of the image as returned from the FW and rename it to
image_length. This is eliminating the usage of total_length inside the
SAVE command.

This is a preparation step for the next patches from the series where
more than one image could be managed on the migration file.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  | 24 +++++++++++-------------
 drivers/vfio/pci/mlx5/cmd.h  |  2 +-
 drivers/vfio/pci/mlx5/main.c | 20 ++++++++++----------
 3 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index b9ed2f1c8689..24c6d2e4c2be 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -212,9 +212,9 @@ static int mlx5vf_cmd_get_vhca_id(struct mlx5_core_dev *mdev, u16 function_id,
 static int _create_mkey(struct mlx5_core_dev *mdev, u32 pdn,
 			struct mlx5_vf_migration_file *migf,
 			struct mlx5_vhca_recv_buf *recv_buf,
-			u32 *mkey)
+			u32 *mkey, size_t length)
 {
-	size_t npages = migf ? DIV_ROUND_UP(migf->total_length, PAGE_SIZE) :
+	size_t npages = migf ? DIV_ROUND_UP(length, PAGE_SIZE) :
 				recv_buf->npages;
 	int err = 0, inlen;
 	__be64 *mtt;
@@ -255,8 +255,7 @@ static int _create_mkey(struct mlx5_core_dev *mdev, u32 pdn,
 	MLX5_SET(mkc, mkc, qpn, 0xffffff);
 	MLX5_SET(mkc, mkc, log_page_size, PAGE_SHIFT);
 	MLX5_SET(mkc, mkc, translations_octword_size, DIV_ROUND_UP(npages, 2));
-	MLX5_SET64(mkc, mkc, len,
-		   migf ? migf->total_length : (npages * PAGE_SIZE));
+	MLX5_SET64(mkc, mkc, len, migf ? length : (npages * PAGE_SIZE));
 	err = mlx5_core_create_mkey(mdev, mkey, in, inlen);
 	kvfree(in);
 	return err;
@@ -294,7 +293,7 @@ static void mlx5vf_save_callback(int status, struct mlx5_async_work *context)
 			struct mlx5_vf_migration_file, async_data);
 
 	if (!status) {
-		WRITE_ONCE(migf->total_length,
+		WRITE_ONCE(migf->image_length,
 			   MLX5_GET(save_vhca_state_out, async_data->out,
 				    actual_image_size));
 		wake_up_interruptible(&migf->poll_wait);
@@ -333,7 +332,8 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	if (err)
 		goto err_dma_map;
 
-	err = _create_mkey(mdev, pdn, migf, NULL, &mkey);
+	err = _create_mkey(mdev, pdn, migf, NULL,
+			   &mkey, migf->allocated_length);
 	if (err)
 		goto err_create_mkey;
 
@@ -342,7 +342,7 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	MLX5_SET(save_vhca_state_in, in, op_mod, 0);
 	MLX5_SET(save_vhca_state_in, in, vhca_id, mvdev->vhca_id);
 	MLX5_SET(save_vhca_state_in, in, mkey, mkey);
-	MLX5_SET(save_vhca_state_in, in, size, migf->total_length);
+	MLX5_SET(save_vhca_state_in, in, size, migf->allocated_length);
 
 	async_data = &migf->async_data;
 	async_data->out = kvzalloc(out_size, GFP_KERNEL);
@@ -351,8 +351,6 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 		goto err_out;
 	}
 
-	/* no data exists till the callback comes back */
-	migf->total_length = 0;
 	get_file(migf->filp);
 	async_data->mkey = mkey;
 	async_data->pdn = pdn;
@@ -393,7 +391,7 @@ int mlx5vf_cmd_load_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 		return -ENOTCONN;
 
 	mutex_lock(&migf->lock);
-	if (!migf->total_length) {
+	if (!migf->image_length) {
 		err = -EINVAL;
 		goto end;
 	}
@@ -407,7 +405,7 @@ int mlx5vf_cmd_load_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	if (err)
 		goto err_reg;
 
-	err = _create_mkey(mdev, pdn, migf, NULL, &mkey);
+	err = _create_mkey(mdev, pdn, migf, NULL, &mkey, migf->image_length);
 	if (err)
 		goto err_mkey;
 
@@ -416,7 +414,7 @@ int mlx5vf_cmd_load_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	MLX5_SET(load_vhca_state_in, in, op_mod, 0);
 	MLX5_SET(load_vhca_state_in, in, vhca_id, mvdev->vhca_id);
 	MLX5_SET(load_vhca_state_in, in, mkey, mkey);
-	MLX5_SET(load_vhca_state_in, in, size, migf->total_length);
+	MLX5_SET(load_vhca_state_in, in, size, migf->image_length);
 
 	err = mlx5_cmd_exec_inout(mdev, load_vhca_state, in, out);
 
@@ -1047,7 +1045,7 @@ static int mlx5vf_alloc_qp_recv_resources(struct mlx5_core_dev *mdev,
 	if (err)
 		goto end;
 
-	err = _create_mkey(mdev, pdn, NULL, recv_buf, &recv_buf->mkey);
+	err = _create_mkey(mdev, pdn, NULL, recv_buf, &recv_buf->mkey, 0);
 	if (err)
 		goto err_create_mkey;
 
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index b1c5dd2ff144..b1fa1a0418a5 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -29,7 +29,7 @@ struct mlx5_vf_migration_file {
 	u8 save_cb_active:1;
 
 	struct sg_append_table table;
-	size_t total_length;
+	size_t image_length;
 	size_t allocated_length;
 
 	/* Optimize mlx5vf_get_migration_page() for sequential access */
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 5da278f3c31c..624b1a99dc21 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -116,7 +116,7 @@ static void mlx5vf_disable_fd(struct mlx5_vf_migration_file *migf)
 		__free_page(sg_page_iter_page(&sg_iter));
 	sg_free_append_table(&migf->table);
 	migf->disabled = true;
-	migf->total_length = 0;
+	migf->image_length = 0;
 	migf->allocated_length = 0;
 	migf->filp->f_pos = 0;
 	mutex_unlock(&migf->lock);
@@ -144,16 +144,16 @@ static ssize_t mlx5vf_save_read(struct file *filp, char __user *buf, size_t len,
 
 	if (!(filp->f_flags & O_NONBLOCK)) {
 		if (wait_event_interruptible(migf->poll_wait,
-			     READ_ONCE(migf->total_length) || migf->is_err))
+			     READ_ONCE(migf->image_length) || migf->is_err))
 			return -ERESTARTSYS;
 	}
 
 	mutex_lock(&migf->lock);
-	if ((filp->f_flags & O_NONBLOCK) && !READ_ONCE(migf->total_length)) {
+	if ((filp->f_flags & O_NONBLOCK) && !READ_ONCE(migf->image_length)) {
 		done = -EAGAIN;
 		goto out_unlock;
 	}
-	if (*pos > migf->total_length) {
+	if (*pos > migf->image_length) {
 		done = -EINVAL;
 		goto out_unlock;
 	}
@@ -162,7 +162,7 @@ static ssize_t mlx5vf_save_read(struct file *filp, char __user *buf, size_t len,
 		goto out_unlock;
 	}
 
-	len = min_t(size_t, migf->total_length - *pos, len);
+	len = min_t(size_t, migf->image_length - *pos, len);
 	while (len) {
 		size_t page_offset;
 		struct page *page;
@@ -208,7 +208,7 @@ static __poll_t mlx5vf_save_poll(struct file *filp,
 	mutex_lock(&migf->lock);
 	if (migf->disabled || migf->is_err)
 		pollflags = EPOLLIN | EPOLLRDNORM | EPOLLRDHUP;
-	else if (READ_ONCE(migf->total_length))
+	else if (READ_ONCE(migf->image_length))
 		pollflags = EPOLLIN | EPOLLRDNORM;
 	mutex_unlock(&migf->lock);
 
@@ -227,6 +227,7 @@ static struct mlx5_vf_migration_file *
 mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev)
 {
 	struct mlx5_vf_migration_file *migf;
+	size_t length;
 	int ret;
 
 	migf = kzalloc(sizeof(*migf), GFP_KERNEL);
@@ -248,13 +249,12 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev)
 	init_waitqueue_head(&migf->save_wait);
 	mlx5_cmd_init_async_ctx(mvdev->mdev, &migf->async_ctx);
 	INIT_WORK(&migf->async_data.work, mlx5vf_mig_file_cleanup_cb);
-	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev,
-						    &migf->total_length);
+	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev, &length);
 	if (ret)
 		goto out_free;
 
 	ret = mlx5vf_add_migration_pages(
-		migf, DIV_ROUND_UP_ULL(migf->total_length, PAGE_SIZE));
+		migf, DIV_ROUND_UP_ULL(length, PAGE_SIZE));
 	if (ret)
 		goto out_free;
 
@@ -328,7 +328,7 @@ static ssize_t mlx5vf_resume_write(struct file *filp, const char __user *buf,
 		len -= page_len;
 		done += page_len;
 		buf += page_len;
-		migf->total_length += page_len;
+		migf->image_length += page_len;
 	}
 out_unlock:
 	mutex_unlock(&migf->lock);
-- 
2.18.1

