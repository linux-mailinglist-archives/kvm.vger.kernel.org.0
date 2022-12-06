Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F767643EC9
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 09:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbiLFIga (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 03:36:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234122AbiLFIf4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 03:35:56 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2043.outbound.protection.outlook.com [40.107.223.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E716AC74D
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 00:35:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TWEb+1Gq8v/BuC74y6U2XeRokjm7riAIPqhg57E/huXlWwfwy2yLCJ2sfN1WDmQYQZTm3WuzJCot5n34NrOpSDyKYPtOhqCJOFgYgp1EdFUn1pFXJ0h6PLZira6YtzTaFwCXXkqO7JRTSrtTOahUaZZByPbJuUef49agkgQK62FShjz9ocbNiQOFGFyd6TlcS7S40u/uvVXaiS2PnKg1HhsXgdp14hpiq4G3nEYzgdCkycd0Pkj3ySDqUNTe8S5pBAYGMgwyZMr7v6DO9CYSFWg6BgxbkBhmJ8BAUtT4z6r1NO/bG1WxD8jXBTgvq6J5p8MFzNXUD6QipiMYSJ1ISQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mknVYAkYjeaZmtPY2XBE735t1zrTG3dCOphbrPb2urM=;
 b=h3MJx8Z9zPtKjA8PmP1z93+TLLgTQneLaqy7XGJaIlNUSjnitO9stM65zHS0BlEpV8Qzv8U0nnAIq2gZ6A+gy+GVMYcVE18oypta2LzKuYHHFm0UFZFPdaNtgmEDwOs9napuaSDK6TQMUMbWVg9vT6Quesk2kDrhjq90Kw3dUvCL2kEPOFrVMWc2FF7aye2ecLhY7hYe05pDed17OtsSiUOdhFAMjoG2Sgr/eH9bcjIJupnTI7DQPvMb7QYb8kyHl7F+hB9ymeYq6E9XjfZzXex+Xtj/JF+7fDIEoSn8MgxForV1QslQP+7rfr9owfgU0qTkzhJf7QDbbIV/qCo6vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mknVYAkYjeaZmtPY2XBE735t1zrTG3dCOphbrPb2urM=;
 b=SdYgvFf7aznAOy18M1wlPI0Yo91q5Cj4oeM3eiBkPIx+F/0RJC7xI4p0pYW/l5CmuDsxDU9fxNR1/3nO66Bw8ddSAm2Nzkxao8Lekqiegm1FLY7sk7tIs9gjuNSagbi0KJfJAzXtJ1IDwCYCJ/sTS2idC92fC4q4RSGGNDqKO57J+KoNkpqm5QglnKAanGhXPeg9IRc2I3d9+4h5BPV3V6VJjmdtcDG+KmzlEH0PLf9kq752BGFoKT6fUrU/4y6opBRrGZJTBcoeDkoYshlS2hp3HKPWPosycanyBHEx5nJdiMlSkOl90zg4rY6pQfLw+yDY9RIsztdIouknL8Oo6A==
Received: from CY5PR14CA0019.namprd14.prod.outlook.com (2603:10b6:930:2::26)
 by CH2PR12MB4086.namprd12.prod.outlook.com (2603:10b6:610:7c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 08:35:50 +0000
Received: from CY4PEPF0000C976.namprd02.prod.outlook.com
 (2603:10b6:930:2:cafe::e) by CY5PR14CA0019.outlook.office365.com
 (2603:10b6:930:2::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Tue, 6 Dec 2022 08:35:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CY4PEPF0000C976.mail.protection.outlook.com (10.167.241.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8 via Frontend Transport; Tue, 6 Dec 2022 08:35:49 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 6 Dec 2022
 00:35:36 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 6 Dec 2022 00:35:35 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Tue, 6 Dec 2022 00:35:32 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V4 vfio 07/14] vfio/mlx5: Refactor to use queue based data chunks
Date:   Tue, 6 Dec 2022 10:34:31 +0200
Message-ID: <20221206083438.37807-8-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221206083438.37807-1-yishaih@nvidia.com>
References: <20221206083438.37807-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C976:EE_|CH2PR12MB4086:EE_
X-MS-Office365-Filtering-Correlation-Id: 87f4afd9-6a5f-460a-de99-08dad764e127
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WTsROf14nceTf5K6tbHKfLm1BLpYdjVHOIxx3Ly0mybib0b0Naycsdx7HpLcpLUnvjJp2RpVtHmPgFd+IDbRzLQoOJIHH12RUEBvDQQWQ4ISVzvpCnJXd5VzSU9JCwwzHTzJRcSZIrPVqPCMjAKUoq55w5vaCQqM1OcYwul/Y0Bz4W3T6T6xsyR5lOfRk3KbnczhlYyEbSf9b2mB/XqmAHI76C5029YjiD46uPL8+YtPseaPa2EDKkcZfRB2sMqeTvQnBQZZupCg/+DjODBtrv93nY+EIsTl1o4zzzPFzEus5pjuW1hlID4PqcTyJlszJmGwLam2lWXIC6YrHajlSqz6LSNg3tROy5XcONQ0ASSEnQWunu7tejfrRO6v1ECAJJbojcCC/XeTKw33aFIGVf5ZfbpfXQmnmWY45sNPnyzsYEntOnQ6TEJfgM60GU+WFVuj2colarvTpZUVxPPCx5p6gKEYwy43gCHflRJ9fcRnOPKZ+POgKVuiSyc/jTClxXgvoaBC8porhAPAopo2C2oqPcQZSD0OLDKB0nnDD8V4HQUR8dEfkNoeS1iVepyqgc+fRI0SSeAP8PUnKd1eeDUiaUO195r+YgzHLAsyrwKRdZpOacR1LRTbN/Zo0a71GRhOFbfIpeWl2ChSxOdKuZmYhyEugurT01WQr6hCGEwVuUg1u2yv79LmR+wB02AvumfCojAKEtvswd0O3zWLug==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(39860400002)(396003)(346002)(451199015)(46966006)(40470700004)(36840700001)(66899015)(426003)(47076005)(356005)(40460700003)(478600001)(7696005)(40480700001)(36756003)(86362001)(82740400003)(36860700001)(336012)(83380400001)(1076003)(2616005)(7636003)(186003)(5660300002)(41300700001)(26005)(8936002)(82310400005)(316002)(70206006)(6636002)(54906003)(8676002)(4326008)(2906002)(110136005)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 08:35:49.9439
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 87f4afd9-6a5f-460a-de99-08dad764e127
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C976.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4086
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

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
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
index d95646c2f010..ca16425811c4 100644
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
 
@@ -253,6 +327,8 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev)
 	complete(&migf->save_comp);
 	mlx5_cmd_init_async_ctx(mvdev->mdev, &migf->async_ctx);
 	INIT_WORK(&migf->async_data.work, mlx5vf_mig_file_cleanup_cb);
+	INIT_LIST_HEAD(&migf->buf_list);
+	spin_lock_init(&migf->list_lock);
 	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev, &length);
 	if (ret)
 		goto out_pd;
@@ -266,7 +342,6 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev)
 	ret = mlx5vf_cmd_save_vhca_state(mvdev, migf, buf);
 	if (ret)
 		goto out_save;
-	migf->buf = buf;
 	return migf;
 out_save:
 	mlx5vf_free_data_buffer(buf);
@@ -386,6 +461,8 @@ mlx5vf_pci_resume_device_data(struct mlx5vf_pci_core_device *mvdev)
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

