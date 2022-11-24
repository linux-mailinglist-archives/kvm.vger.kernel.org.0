Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 842A2637E7D
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 18:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbiKXRlO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 12:41:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbiKXRlB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 12:41:01 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2068.outbound.protection.outlook.com [40.107.223.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 919B31400C7
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 09:41:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CUzgdLFDCL/pvDoHz+oEaHsWbGu2oWthsOQvX+5RkOZYv/OPIEJYBaVx3aPC7KMG1jZuIc3W022j2hUHcawLIIxGYww97+PVvQzpEIRjU4K+y48nfjpHpx4qWkZtISeBQR3m1cEmBsG9mx8P3zv9+naFLIKXKeK7G32UFato04dmwrodWkNdOac0dlk12mB95R02Bub1jN+/9BI1kSq3eB3i9KLTTP7qv/SUcNtTze1JWSlZg15Cr5vrHnGYVyIyYC7Wj6lV+54iPMyWDVGnL3QlnHpWaloIYTkqJ3O+z8zqK0gk932eJu5nBKwGxkA6hN4/JqrtBXLy3+Isbsp3qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hx8jq7yvx1Yr/nRbpaDJj045bU9a0MQRrJfvrsHSWTU=;
 b=MUWwI+/nPCzIMCiyPFP4SbtwQ//hQPyBwFSGCP7Nb3YzZ2S3nH42xvFscgYuskSeCDrmKPDqa5dMm/ucARTUjJmYuB/siwGNxV6RCFONb5UfB9XpYdpICs1pk4WhgdIKS+EeMd6RtVVXpyHN2MLg0G4/Bd5FSleF+EPnpl9xShpSk4BsFetGKaXXg1atiIHatTt48U6jsfm4A0Ne17gRXWyD+hL9zcKaPkJW3TVUfdFmDMWtLP1TubyZlxaAJ+lz3iPN+FAanWdTJHY4NXH8l3N0WJvNLmiDea8bm/V79Ey4upID1NfP6vgnXO4IoORL9li+kBtU6UETYIqYpUOoQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hx8jq7yvx1Yr/nRbpaDJj045bU9a0MQRrJfvrsHSWTU=;
 b=sx4YLNwlDmgiwFR2JhPfQ40GSz0sqHdocbkRhIgyGl9xBRKYM6B3BkkU+ZXmGI3r8JyBp0mpo3/Sby3WOn8puNx/pUGCwy7ZWSnvLY1DNsDxtbH3vhJNG/gZR/Sq2z24pJOsMwnnZIRCxfR9YYFtsfPvmBhQ0+MzN2ckmiIZ734xN/bh+SMM7YUfNRsR7Nzx5ZOzP98UfaMuq5vNZlCBu6wLKVjpL/sKcTefszocwYsX37dzUzZaO5JfFtyM8udbkPLbXeZ3tCHQOCyZveKhlXk/zwNKtNrWYVPUTPPR8wRylLnlxYxRHSFIVC2XN32+WwsV7mYcB+CL/aKy9dRufg==
Received: from DS7PR03CA0233.namprd03.prod.outlook.com (2603:10b6:5:3ba::28)
 by CH2PR12MB4071.namprd12.prod.outlook.com (2603:10b6:610:7b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Thu, 24 Nov
 2022 17:40:59 +0000
Received: from DM6NAM11FT087.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ba:cafe::75) by DS7PR03CA0233.outlook.office365.com
 (2603:10b6:5:3ba::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19 via Frontend
 Transport; Thu, 24 Nov 2022 17:40:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM6NAM11FT087.mail.protection.outlook.com (10.13.172.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.8 via Frontend Transport; Thu, 24 Nov 2022 17:40:58 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 24 Nov
 2022 09:40:43 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 24 Nov 2022 09:40:42 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Thu, 24 Nov 2022 09:40:40 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>
Subject: [PATCH V1 vfio 07/14] vfio/mlx5: Refactor to use queue based data chunks
Date:   Thu, 24 Nov 2022 19:39:25 +0200
Message-ID: <20221124173932.194654-8-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221124173932.194654-1-yishaih@nvidia.com>
References: <20221124173932.194654-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT087:EE_|CH2PR12MB4071:EE_
X-MS-Office365-Filtering-Correlation-Id: f788286e-434e-4629-e88c-08dace430c48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0Lov+v6Ak+xZU2Re1xa+4JX9+OcF472sWDkN4wqMV/8v7gBWWEI7/8cBA7MVtDJNmbmBrCzddoCm9JJYWt1abv0JDWM+vWMBpV2bA/6eCG4vTN0RLybI1VD5QMTlShCu/HCRk68v3xJb1TzqSlq5Ftc776ziLri19dq5FhR0/+Qex3Lhf34GquqwxA1xeO8+atGyM2CK/L3LTrjCmXrO4AtQzQUm+fATdYT0yyhYuFgeRxkma2U7/Zx6b8PAWgOgIHFVs2ISkGW9FJKPP6wKB8K30cQnishNf7eum+toHlNq+M9kMgCCi9fU6KF2L1ixMXMufJtsOU8vj3SEhxnnHsAEfXNbeKgjN+p9u3ccGsfyiwHYA11a30H5Ich3tmQWR5Uwg2H/tZd+jNdyIVyS/1IwFQa45TdeBw/YZ7glMP90aIScYWVxHiD2HkPcVWLm8x/q34G5GNRKETvseXH41fMWKuLPHokFnFaRCTGSS1fDvkBf0bCPatESTW6xKmX/FZ1d4U6svsXLarnZj0xoLI32wsRYxL1rzmQwSEBjuO44j6orXDD7zvnPDnCKk0U6TL+EtOy4A+yi68VM+Nfjxc1XCowtxWPhH04Z+qrluWK9tieCMRgWAnvlrDgx+QIOtfdwfjtK2HAuLD6aw3WhyUkdjRzL6Q52/IkfPaPkXk01Ha7wyVp5kWJ5Ez24s5au+HPpN3wGyw7nR7Fq0CsjMg==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(39860400002)(376002)(396003)(451199015)(40470700004)(36840700001)(46966006)(66899015)(36860700001)(36756003)(86362001)(82740400003)(5660300002)(40480700001)(2906002)(186003)(2616005)(1076003)(47076005)(426003)(26005)(40460700003)(83380400001)(356005)(336012)(7636003)(7696005)(82310400005)(70206006)(8676002)(4326008)(41300700001)(110136005)(6636002)(54906003)(8936002)(478600001)(6666004)(316002)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2022 17:40:58.9331
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f788286e-434e-4629-e88c-08dace430c48
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT087.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4071
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor to use queue based data chunks on the migration file.

The SAVE command adds a chunk to the tail of the queue while the read()
API finds the required chunk and returns its data.

In case the queue is empty but the state of the migration file is
MLX5_MIGF_STATE_COMPLETE, read() may not be blocked but will return 0 to
indicate end of file.

This is a step towards maintaining multiple images and their meta data
(i.e. headers) on the migration file as part of next patches from the
series.

Note:
At that point, we still use a single chunk on the migration file but
becomes ready to support multiple.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  |  24 +++++-
 drivers/vfio/pci/mlx5/cmd.h  |   5 ++
 drivers/vfio/pci/mlx5/main.c | 145 +++++++++++++++++++++++++++--------
 3 files changed, 136 insertions(+), 38 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index fcba12326185..0e36b4c8c816 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -351,6 +351,7 @@ void mlx5vf_mig_file_cleanup_cb(struct work_struct *_work)
 
 	mutex_lock(&migf->lock);
 	if (async_data->status) {
+		migf->buf = async_data->buf;
 		migf->state = MLX5_MIGF_STATE_ERROR;
 		wake_up_interruptible(&migf->poll_wait);
 	}
@@ -368,9 +369,15 @@ static void mlx5vf_save_callback(int status, struct mlx5_async_work *context)
 			struct mlx5_vf_migration_file, async_data);
 
 	if (!status) {
-		WRITE_ONCE(migf->buf->length,
-			   MLX5_GET(save_vhca_state_out, async_data->out,
-				    actual_image_size));
+		unsigned long flags;
+
+		async_data->buf->length =
+			MLX5_GET(save_vhca_state_out, async_data->out,
+				 actual_image_size);
+		spin_lock_irqsave(&migf->list_lock, flags);
+		list_add_tail(&async_data->buf->buf_elm, &migf->buf_list);
+		spin_unlock_irqrestore(&migf->list_lock, flags);
+		migf->state = MLX5_MIGF_STATE_COMPLETE;
 		wake_up_interruptible(&migf->poll_wait);
 	}
 
@@ -407,6 +414,7 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	MLX5_SET(save_vhca_state_in, in, size, buf->allocated_length);
 
 	async_data = &migf->async_data;
+	async_data->buf = buf;
 	async_data->out = kvzalloc(out_size, GFP_KERNEL);
 	if (!async_data->out) {
 		err = -ENOMEM;
@@ -479,14 +487,22 @@ void mlx5vf_cmd_dealloc_pd(struct mlx5_vf_migration_file *migf)
 
 void mlx5fv_cmd_clean_migf_resources(struct mlx5_vf_migration_file *migf)
 {
-	lockdep_assert_held(&migf->mvdev->state_mutex);
+	struct mlx5_vhca_data_buffer *entry;
 
+	lockdep_assert_held(&migf->mvdev->state_mutex);
 	WARN_ON(migf->mvdev->mdev_detach);
 
 	if (migf->buf) {
 		mlx5vf_free_data_buffer(migf->buf);
 		migf->buf = NULL;
 	}
+
+	while ((entry = list_first_entry_or_null(&migf->buf_list,
+				struct mlx5_vhca_data_buffer, buf_elm))) {
+		list_del(&entry->buf_elm);
+		mlx5vf_free_data_buffer(entry);
+	}
+
 	mlx5vf_cmd_dealloc_pd(migf);
 }
 
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index 14403e654e4e..6e594689566e 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -14,6 +14,7 @@
 
 enum mlx5_vf_migf_state {
 	MLX5_MIGF_STATE_ERROR = 1,
+	MLX5_MIGF_STATE_COMPLETE,
 };
 
 struct mlx5_vhca_data_buffer {
@@ -24,6 +25,7 @@ struct mlx5_vhca_data_buffer {
 	u32 mkey;
 	enum dma_data_direction dma_dir;
 	u8 dmaed:1;
+	struct list_head buf_elm;
 	struct mlx5_vf_migration_file *migf;
 	/* Optimize mlx5vf_get_migration_page() for sequential access */
 	struct scatterlist *last_offset_sg;
@@ -34,6 +36,7 @@ struct mlx5_vhca_data_buffer {
 struct mlx5vf_async_data {
 	struct mlx5_async_work cb_work;
 	struct work_struct work;
+	struct mlx5_vhca_data_buffer *buf;
 	int status;
 	void *out;
 };
@@ -45,6 +48,8 @@ struct mlx5_vf_migration_file {
 
 	u32 pdn;
 	struct mlx5_vhca_data_buffer *buf;
+	spinlock_t list_lock;
+	struct list_head buf_list;
 	struct mlx5vf_pci_core_device *mvdev;
 	wait_queue_head_t poll_wait;
 	struct completion save_comp;
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 0ee8e509116c..facb5ab6021e 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -124,11 +124,90 @@ static int mlx5vf_release_file(struct inode *inode, struct file *filp)
 	return 0;
 }
 
+static struct mlx5_vhca_data_buffer *
+mlx5vf_get_data_buff_from_pos(struct mlx5_vf_migration_file *migf, loff_t pos,
+			      bool *end_of_data)
+{
+	struct mlx5_vhca_data_buffer *buf;
+	bool found = false;
+
+	*end_of_data = false;
+	spin_lock_irq(&migf->list_lock);
+	if (list_empty(&migf->buf_list)) {
+		*end_of_data = true;
+		goto end;
+	}
+
+	buf = list_first_entry(&migf->buf_list, struct mlx5_vhca_data_buffer,
+			       buf_elm);
+	if (pos >= buf->start_pos &&
+	    pos < buf->start_pos + buf->length) {
+		found = true;
+		goto end;
+	}
+
+	/*
+	 * As we use a stream based FD we may expect having the data always
+	 * on first chunk
+	 */
+	migf->state = MLX5_MIGF_STATE_ERROR;
+
+end:
+	spin_unlock_irq(&migf->list_lock);
+	return found ? buf : NULL;
+}
+
+static ssize_t mlx5vf_buf_read(struct mlx5_vhca_data_buffer *vhca_buf,
+			       char __user **buf, size_t *len, loff_t *pos)
+{
+	unsigned long offset;
+	ssize_t done = 0;
+	size_t copy_len;
+
+	copy_len = min_t(size_t,
+			 vhca_buf->start_pos + vhca_buf->length - *pos, *len);
+	while (copy_len) {
+		size_t page_offset;
+		struct page *page;
+		size_t page_len;
+		u8 *from_buff;
+		int ret;
+
+		offset = *pos - vhca_buf->start_pos;
+		page_offset = offset % PAGE_SIZE;
+		offset -= page_offset;
+		page = mlx5vf_get_migration_page(vhca_buf, offset);
+		if (!page)
+			return -EINVAL;
+		page_len = min_t(size_t, copy_len, PAGE_SIZE - page_offset);
+		from_buff = kmap_local_page(page);
+		ret = copy_to_user(*buf, from_buff + page_offset, page_len);
+		kunmap_local(from_buff);
+		if (ret)
+			return -EFAULT;
+		*pos += page_len;
+		*len -= page_len;
+		*buf += page_len;
+		done += page_len;
+		copy_len -= page_len;
+	}
+
+	if (*pos >= vhca_buf->start_pos + vhca_buf->length) {
+		spin_lock_irq(&vhca_buf->migf->list_lock);
+		list_del_init(&vhca_buf->buf_elm);
+		spin_unlock_irq(&vhca_buf->migf->list_lock);
+	}
+
+	return done;
+}
+
 static ssize_t mlx5vf_save_read(struct file *filp, char __user *buf, size_t len,
 			       loff_t *pos)
 {
 	struct mlx5_vf_migration_file *migf = filp->private_data;
-	struct mlx5_vhca_data_buffer *vhca_buf = migf->buf;
+	struct mlx5_vhca_data_buffer *vhca_buf;
+	bool first_loop_call = true;
+	bool end_of_data;
 	ssize_t done = 0;
 
 	if (pos)
@@ -137,53 +216,47 @@ static ssize_t mlx5vf_save_read(struct file *filp, char __user *buf, size_t len,
 
 	if (!(filp->f_flags & O_NONBLOCK)) {
 		if (wait_event_interruptible(migf->poll_wait,
-			     READ_ONCE(vhca_buf->length) ||
-			     migf->state == MLX5_MIGF_STATE_ERROR))
+				!list_empty(&migf->buf_list) ||
+				migf->state == MLX5_MIGF_STATE_ERROR ||
+				migf->state == MLX5_MIGF_STATE_COMPLETE))
 			return -ERESTARTSYS;
 	}
 
 	mutex_lock(&migf->lock);
-	if ((filp->f_flags & O_NONBLOCK) && !READ_ONCE(vhca_buf->length)) {
-		done = -EAGAIN;
-		goto out_unlock;
-	}
-	if (*pos > vhca_buf->length) {
-		done = -EINVAL;
-		goto out_unlock;
-	}
 	if (migf->state == MLX5_MIGF_STATE_ERROR) {
 		done = -ENODEV;
 		goto out_unlock;
 	}
 
-	len = min_t(size_t, vhca_buf->length - *pos, len);
 	while (len) {
-		size_t page_offset;
-		struct page *page;
-		size_t page_len;
-		u8 *from_buff;
-		int ret;
+		ssize_t count;
+
+		vhca_buf = mlx5vf_get_data_buff_from_pos(migf, *pos,
+							 &end_of_data);
+		if (first_loop_call) {
+			first_loop_call = false;
+			if (end_of_data && migf->state != MLX5_MIGF_STATE_COMPLETE) {
+				if (filp->f_flags & O_NONBLOCK) {
+					done = -EAGAIN;
+					goto out_unlock;
+				}
+			}
+		}
 
-		page_offset = (*pos) % PAGE_SIZE;
-		page = mlx5vf_get_migration_page(vhca_buf, *pos - page_offset);
-		if (!page) {
-			if (done == 0)
-				done = -EINVAL;
+		if (end_of_data)
+			goto out_unlock;
+
+		if (!vhca_buf) {
+			done = -EINVAL;
 			goto out_unlock;
 		}
 
-		page_len = min_t(size_t, len, PAGE_SIZE - page_offset);
-		from_buff = kmap_local_page(page);
-		ret = copy_to_user(buf, from_buff + page_offset, page_len);
-		kunmap_local(from_buff);
-		if (ret) {
-			done = -EFAULT;
+		count = mlx5vf_buf_read(vhca_buf, &buf, &len, pos);
+		if (count < 0) {
+			done = count;
 			goto out_unlock;
 		}
-		*pos += page_len;
-		len -= page_len;
-		done += page_len;
-		buf += page_len;
+		done += count;
 	}
 
 out_unlock:
@@ -202,7 +275,8 @@ static __poll_t mlx5vf_save_poll(struct file *filp,
 	mutex_lock(&migf->lock);
 	if (migf->state == MLX5_MIGF_STATE_ERROR)
 		pollflags = EPOLLIN | EPOLLRDNORM | EPOLLRDHUP;
-	else if (READ_ONCE(migf->buf->length))
+	else if (!list_empty(&migf->buf_list) ||
+		 migf->state == MLX5_MIGF_STATE_COMPLETE)
 		pollflags = EPOLLIN | EPOLLRDNORM;
 	mutex_unlock(&migf->lock);
 
@@ -248,6 +322,8 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev)
 	complete(&migf->save_comp);
 	mlx5_cmd_init_async_ctx(mvdev->mdev, &migf->async_ctx);
 	INIT_WORK(&migf->async_data.work, mlx5vf_mig_file_cleanup_cb);
+	INIT_LIST_HEAD(&migf->buf_list);
+	spin_lock_init(&migf->list_lock);
 	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev, &length);
 	if (ret)
 		goto out_pd;
@@ -261,7 +337,6 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev)
 	ret = mlx5vf_cmd_save_vhca_state(mvdev, migf, buf);
 	if (ret)
 		goto out_save;
-	migf->buf = buf;
 	return migf;
 out_save:
 	mlx5vf_free_data_buffer(buf);
@@ -381,6 +456,8 @@ mlx5vf_pci_resume_device_data(struct mlx5vf_pci_core_device *mvdev)
 	migf->buf = buf;
 	stream_open(migf->filp->f_inode, migf->filp);
 	mutex_init(&migf->lock);
+	INIT_LIST_HEAD(&migf->buf_list);
+	spin_lock_init(&migf->list_lock);
 	return migf;
 out_pd:
 	mlx5vf_cmd_dealloc_pd(migf);
-- 
2.18.1

