Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB4963F3EF
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 16:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbiLAPbN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 10:31:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231906AbiLAPaq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 10:30:46 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2084.outbound.protection.outlook.com [40.107.95.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD3FAD30A
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 07:30:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OBSG5jNtge+ua6HuLSpiZZzmvAbtDpPUQUwAFAOsNU5n1v+J1GF4H7uEA0eWFRskAA8jJsFGXfXWqtQ+muYEJ2V5lUhJMLzsfgbcB772chHwsNSHlObCOYH9aOfsBLNQUOfbUEV6j5+9CTWArPO3bvoPwAFKmw6lGmpwL7BRGkAWwMTHx1cXDKSFN2Q1S4yhEaTUvsiQWNyahCbNi3p9cKZE5aJPVFu6OJvKpbZy0Mkp2gXmCmbT/hzRo85OJTtqcaHqHmYCWcTxAQZIyZ0ABSiXfBkD4fBjThQNXi6iAx+9vAPWedMsEV1jwr3VsmMsv1NtIem3GHb4lHhfMLm9HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hx8jq7yvx1Yr/nRbpaDJj045bU9a0MQRrJfvrsHSWTU=;
 b=X51/VRuwCJWh2xnbqBVfrL2WYDUj/COEB2FTGrnPtHL4k5LJdjiRgYCKS/F0iPpIdTo/XTtDsJRTAwp3nWjsihZxUxFeHp4R7cz1Z9YVwPq6SFRuBbvhylwCJEsVS7mF7GHt8qT6JuYXFjqTK/LET9jZjfoFRiKrTfQDYGFiV3DXSgKYEJDQwlsBQxGUOM/Yn2rx3Wzj569JtRV3jjOm/9qvAhRFe21RhzN0Jf/zKybaTp4tfUrzbz8N9AEcanlxgQi0NHmWsFkUQD7UegrnNS/2LPLH0ktZXi7aWLaWfAB9byE4IMSrWfWDneVj8dlSTqWELxeooPTnoqw6o15b6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hx8jq7yvx1Yr/nRbpaDJj045bU9a0MQRrJfvrsHSWTU=;
 b=mU/CtxI+YW5eY3EVsM1pFHHtfWi/kClv08XAIOcNAkGJSOEDoHhlJrnJr6eibUF4aUFQMUSnV6w6fvy2dz46E1ozoe9C3aUWf7CYeQVvYckEgnRReMOGHHFwOEKpNSvfkY8OsxvCXjZOVt+A2dmlHbT1DRBjSvnXAF/YA2hR4KiMyhmgGEqoByTWeaJDGBO8FRetKzyz1aT8kSJK+iMbyZpcKTcjBmXAB8DnA9GmFwUcfOeKANoXVUoth5+zOAQW7r50gLv9sSFYB0WsuimhvfAB9WcMTG8517v6si46RX+rPDLqpUDp33Z6nyheVXzJKNC//cU86gCqcSMvxbu+pg==
Received: from CY5PR15CA0101.namprd15.prod.outlook.com (2603:10b6:930:7::22)
 by DS0PR12MB8247.namprd12.prod.outlook.com (2603:10b6:8:f5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Thu, 1 Dec
 2022 15:30:35 +0000
Received: from CY4PEPF0000C967.namprd02.prod.outlook.com
 (2603:10b6:930:7:cafe::58) by CY5PR15CA0101.outlook.office365.com
 (2603:10b6:930:7::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8 via Frontend
 Transport; Thu, 1 Dec 2022 15:30:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CY4PEPF0000C967.mail.protection.outlook.com (10.167.241.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8 via Frontend Transport; Thu, 1 Dec 2022 15:30:34 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 1 Dec 2022
 07:30:22 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 1 Dec 2022 07:30:21 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Thu, 1 Dec 2022 07:30:18 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>
Subject: [PATCH V2 vfio 07/14] vfio/mlx5: Refactor to use queue based data chunks
Date:   Thu, 1 Dec 2022 17:29:24 +0200
Message-ID: <20221201152931.47913-8-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221201152931.47913-1-yishaih@nvidia.com>
References: <20221201152931.47913-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C967:EE_|DS0PR12MB8247:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fd284ff-c8c8-4f09-2759-08dad3b0fdb2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XZKw89MRjypRV2Hy8Ehb7McM0gj5+/NwzqqQSD65hYgcG8/FUH6/6NflpeitXmCU9p30tkbqBCvZ9bxnmWL6m1Tqr0K6JwCDatzSwur1sS69gcQljulmcz2CwbsL5Wvg/FNZ53wUQx6vzL/wkzDM+CpG5DPFjiTlMugl4T8iStWfOZ7wBT2UrOwPzOyh3LBf/0mH6BI5lsay8YVXtNuDhlj0lC2borC58up3nZ/QsusbZgTof9aMyR4e1SVZKqIF0FJYFiKGXpcYW/6XvGtcMvCN4QoLXgwLUfn4ag/rIiu+HNBVEIMlOkHuNZvzfglVT1yPPwE5954F8/JDM58GBugOJczl7yIV0Y16LSf6CGOv90YtVEAan2NaqapWHYSdzRHk5sI2cTyWHMg5sVHFWQg+PtUULP8OgY/nroqP4Dps0PsjXVv9+PwNbyMXzdIu5b+OUBYiDp6WFdjnbE7j0BYHQBrw7jaQdMl5ptE3WHGf1PMXUjTXS8FphrBBA4DTBojHATDDi4T7JCY7+bvYobe4VEF7lCEgtMNhX/aHRTdRExR04SEFwqszqfKRyH6exTakWyQbw8yf4DdbkZVSFD3dvsqTT1s+Eqxi1ed/T0pNQ+OhubeWEOby+IcTCAoX7/VT7/B3u/uuModaiagqS19L4UMssvqBEJv9nRUmA2nq8MFWiEaP1FgYOfm85rtSZ0g7ndpHLV0NroPrihff4/+1ZG46psc7dUxk2XJw65ZGBH44CZTwdAdxeDmIrbe7
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(39860400002)(346002)(396003)(451199015)(40470700004)(36840700001)(46966006)(40480700001)(36756003)(86362001)(356005)(7636003)(6636002)(40460700003)(54906003)(110136005)(316002)(478600001)(2906002)(5660300002)(70586007)(70206006)(8676002)(4326008)(41300700001)(8936002)(83380400001)(82740400003)(36860700001)(426003)(6666004)(186003)(47076005)(82310400005)(7696005)(26005)(2616005)(336012)(1076003)(66899015);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 15:30:34.9268
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fd284ff-c8c8-4f09-2759-08dad3b0fdb2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C967.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8247
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

