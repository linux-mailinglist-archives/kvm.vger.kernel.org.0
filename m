Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEA4E679C85
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 15:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235051AbjAXOu5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 09:50:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235055AbjAXOuy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 09:50:54 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2064.outbound.protection.outlook.com [40.107.237.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154AE48A14
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 06:50:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nLNSml0ese8Nt2zYGmxHZ/Qwzm2x1IW0ZpR7lFNl92/gH7pCP2l5o0ZYqOvOw7O+rOMtR6tMw1Ej/+Nl3IDgpvZl+t1EBKlk6jN4Y+tCDEpsyDb3axC+AmypTImgFK6+KiVY1L3zpgXuC2ltnTpvwXoqgcYd6op/np9u7vw/xoNT4PbovuqogE3pFo2F127HlfVOGu42wuGn40kkH0JM7MLhXltQGM1Lb5GY1jdF7zWMZOhe2eOjfOe/fLEc9L0nEJFyiekxQEwZNteSBt0i4oEyswhUAPOPEX+KaHmBeWVZh75xlv1F43nCWo67xmLYBYT2lWb0+MjlNg5HluXX0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y60vF2FkZgMusFErBGcbyUthK33mMyvI8r+o/SbeU2I=;
 b=RlciPHmhBXI0Gi1SXJ58TWnaEkuu3yEFTbQ30RPgz7QhbbH7rJ9paFfnJmhngVlPdJW0ozOwHDaGeXW57rTBgtIlz1xF33+PnFMJwP8aDCg4aJ6/FamD5XvAd6pu1NBPdj5OeWV3v4pifgQurx6RHhs+VQiuc/KJw8gxAl0aOdB+55D76/fK+UuWwW6XrLsJi8Mw7HapCIVzz5vDrSqo35NpF7fWDONr4ZHdwpCFZAOZ+yvBZhTtU5e1+O90WzbUcsBqLY8yAfNrH3HsOM92Dfd9z8y4KpxBeGIGWZcEJad4aX1VzLeHGNda06uSXZLuq9rANQfnzNPEFEuDWuU9mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y60vF2FkZgMusFErBGcbyUthK33mMyvI8r+o/SbeU2I=;
 b=D9O6zYkANH9y/YB6iEUj20bFi5ukzZpi1C6ghRHfvh9TSXOVx5nAyPVG/rjka5njq3S6taveTtRK0WZwg8MosRCXByripKhPOM8bfeaorC8m6eWpCZsTJ3z8kCAADGHupX44C28Uvj+s61YEI/kQafFWLpxbST8cZWh+Zs9E2BwGOmxEwPY6RgegXE5/rM9hXaP6VArsZ0lW+Gr3y1swSkWtGHZLnRwOQZ8kUGOYn3+8eL5wp0uA0C5OozPKP3Ba0rZLxvXEyxJ09i/5TV9ExEo6j1s8pnJEJRADa6K8S403DA7OG1WQ7O6SJBbdeJESbmZHCd0I52fopA+r7IR0UQ==
Received: from BN9PR03CA0634.namprd03.prod.outlook.com (2603:10b6:408:13b::9)
 by MN2PR12MB4271.namprd12.prod.outlook.com (2603:10b6:208:1d7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 14:50:47 +0000
Received: from BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13b:cafe::4a) by BN9PR03CA0634.outlook.office365.com
 (2603:10b6:408:13b::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Tue, 24 Jan 2023 14:50:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT026.mail.protection.outlook.com (10.13.177.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.17 via Frontend Transport; Tue, 24 Jan 2023 14:50:46 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 24 Jan
 2023 06:50:26 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 24 Jan
 2023 06:50:26 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Tue, 24 Jan
 2023 06:50:23 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>
Subject: [PATCH vfio 2/3] vfio/mlx5: Improve the source side flow upon pre_copy
Date:   Tue, 24 Jan 2023 16:49:54 +0200
Message-ID: <20230124144955.139901-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20230124144955.139901-1-yishaih@nvidia.com>
References: <20230124144955.139901-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT026:EE_|MN2PR12MB4271:EE_
X-MS-Office365-Filtering-Correlation-Id: badfa05e-1feb-4596-7189-08dafe1a60a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: My1ZQ6RXok7jm28s5ckveLoxRYQUShitop15PGcj9djxNHAZBqf8yyv4zdF9+oK8jXUgA4tDBmn81dtEsGyhDsrj8OaMiP4AyL2ic590wo00vnp0x8nlUY9pB6oTRFgwrIXPizf/a2vCdQLrPDZDo5oNcBW15mkljtlTix0TsO2NZL6d5rd9wtVD0RsR76MmJ5hBqGjxIiVgl84wZ37+wCq9iSiSJBFI67zpDvmGc8mgmJguGIIyEWHWHieP1tyRPOCgjlNt3q3qUeHiFInheVt7UAyYC3FvlnaB8XolbtOgyWs14s8dXS/UG1/Sx70lrN4AIhOUGcC7L2UL/p8jnPaOQZtkt8k/th7sh+XSY5KQjuZC6QBlfmZle2KtElizF8YflGFncCAH6OuQHpcghmu/gd7iIwNpWfpHBQotUibH6gIRtqMh0IbSMVyUkiYzCQI+l/M3bLwZGhwZD1o6JTzIxu4wEUqB0MU1ham5iFPDQpdLSRs0b0hViFJ/vsSGUs5/CUTNFqh2SzBUfqgpJZl/74j1SJZBW/J5vv8jeUO8AoJvri6IVwkmMJTMP/oYW+oXIIpFx75v6f+EeFgpXyOUuwSEUgAEYE/53BIB4lZC1E30Wnf1Z/KMHtz/Vzr5RhCMRNoBeZE3o6GOrN0e18UF+Cfh4Lf5eASBEFbD5Ek=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(376002)(396003)(39860400002)(451199015)(46966006)(36840700001)(66899015)(36756003)(41300700001)(86362001)(356005)(7636003)(82740400003)(8936002)(5660300002)(4326008)(30864003)(2906002)(82310400005)(83380400001)(36860700001)(110136005)(478600001)(7696005)(26005)(186003)(8676002)(40480700001)(316002)(70206006)(70586007)(54906003)(2616005)(1076003)(6636002)(107886003)(6666004)(336012)(426003)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 14:50:46.8047
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: badfa05e-1feb-4596-7189-08dafe1a60a0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4271
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Improve the source side flow upon pre_copy as of below.

- Prepare the stop_copy buffers as part of moving to pre_copy.
- Send to the target a record that includes the expected
  stop_copy size to let it optimize its stop_copy flow as well.

As for sending the target this new record type (i.e.
MLX5_MIGF_HEADER_TAG_STOP_COPY_SIZE) we split the current 64 header
flags bits into 32 flags bits and another 32 tag bits, each record may
have a tag and a flag whether it's optional or mandatory. Optional
records will be ignored in the target.

The above reduces the downtime upon stop_copy as the relevant data stuff
is prepared ahead as part of pre_copy.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  |  31 +++++---
 drivers/vfio/pci/mlx5/cmd.h  |  21 +++++-
 drivers/vfio/pci/mlx5/main.c | 133 +++++++++++++++++++++++++++++------
 3 files changed, 151 insertions(+), 34 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index e956e79626b7..5161d845c478 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -500,7 +500,7 @@ void mlx5vf_mig_file_cleanup_cb(struct work_struct *_work)
 }
 
 static int add_buf_header(struct mlx5_vhca_data_buffer *header_buf,
-			  size_t image_size)
+			  size_t image_size, bool initial_pre_copy)
 {
 	struct mlx5_vf_migration_file *migf = header_buf->migf;
 	struct mlx5_vf_migration_header header = {};
@@ -508,7 +508,9 @@ static int add_buf_header(struct mlx5_vhca_data_buffer *header_buf,
 	struct page *page;
 	u8 *to_buff;
 
-	header.image_size = cpu_to_le64(image_size);
+	header.record_size = cpu_to_le64(image_size);
+	header.flags = cpu_to_le32(MLX5_MIGF_HEADER_FLAGS_TAG_MANDATORY);
+	header.tag = cpu_to_le32(MLX5_MIGF_HEADER_TAG_FW_DATA);
 	page = mlx5vf_get_migration_page(header_buf, 0);
 	if (!page)
 		return -EINVAL;
@@ -516,12 +518,13 @@ static int add_buf_header(struct mlx5_vhca_data_buffer *header_buf,
 	memcpy(to_buff, &header, sizeof(header));
 	kunmap_local(to_buff);
 	header_buf->length = sizeof(header);
-	header_buf->header_image_size = image_size;
 	header_buf->start_pos = header_buf->migf->max_pos;
 	migf->max_pos += header_buf->length;
 	spin_lock_irqsave(&migf->list_lock, flags);
 	list_add_tail(&header_buf->buf_elm, &migf->buf_list);
 	spin_unlock_irqrestore(&migf->list_lock, flags);
+	if (initial_pre_copy)
+		migf->pre_copy_initial_bytes += sizeof(header);
 	return 0;
 }
 
@@ -535,11 +538,14 @@ static void mlx5vf_save_callback(int status, struct mlx5_async_work *context)
 	if (!status) {
 		size_t image_size;
 		unsigned long flags;
+		bool initial_pre_copy = migf->state != MLX5_MIGF_STATE_PRE_COPY &&
+				!async_data->last_chunk;
 
 		image_size = MLX5_GET(save_vhca_state_out, async_data->out,
 				      actual_image_size);
 		if (async_data->header_buf) {
-			status = add_buf_header(async_data->header_buf, image_size);
+			status = add_buf_header(async_data->header_buf, image_size,
+						initial_pre_copy);
 			if (status)
 				goto err;
 		}
@@ -549,6 +555,8 @@ static void mlx5vf_save_callback(int status, struct mlx5_async_work *context)
 		spin_lock_irqsave(&migf->list_lock, flags);
 		list_add_tail(&async_data->buf->buf_elm, &migf->buf_list);
 		spin_unlock_irqrestore(&migf->list_lock, flags);
+		if (initial_pre_copy)
+			migf->pre_copy_initial_bytes += image_size;
 		migf->state = async_data->last_chunk ?
 			MLX5_MIGF_STATE_COMPLETE : MLX5_MIGF_STATE_PRE_COPY;
 		wake_up_interruptible(&migf->poll_wait);
@@ -610,11 +618,16 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	}
 
 	if (MLX5VF_PRE_COPY_SUPP(mvdev)) {
-		header_buf = mlx5vf_get_data_buffer(migf,
-			sizeof(struct mlx5_vf_migration_header), DMA_NONE);
-		if (IS_ERR(header_buf)) {
-			err = PTR_ERR(header_buf);
-			goto err_free;
+		if (async_data->last_chunk && migf->buf_header) {
+			header_buf = migf->buf_header;
+			migf->buf_header = NULL;
+		} else {
+			header_buf = mlx5vf_get_data_buffer(migf,
+				sizeof(struct mlx5_vf_migration_header), DMA_NONE);
+			if (IS_ERR(header_buf)) {
+				err = PTR_ERR(header_buf);
+				goto err_free;
+			}
 		}
 	}
 
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index 657d94affe2b..8f1bef580028 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -32,10 +32,26 @@ enum mlx5_vf_load_state {
 	MLX5_VF_LOAD_STATE_LOAD_IMAGE,
 };
 
+struct mlx5_vf_migration_tag_stop_copy_data {
+	__le64 stop_copy_size;
+};
+
+enum mlx5_vf_migf_header_flags {
+	MLX5_MIGF_HEADER_FLAGS_TAG_MANDATORY = 0,
+	MLX5_MIGF_HEADER_FLAGS_TAG_OPTIONAL = 1 << 0,
+};
+
+enum mlx5_vf_migf_header_tag {
+	MLX5_MIGF_HEADER_TAG_FW_DATA = 0,
+	MLX5_MIGF_HEADER_TAG_STOP_COPY_SIZE = 1 << 0,
+};
+
 struct mlx5_vf_migration_header {
-	__le64 image_size;
+	__le64 record_size;
 	/* For future use in case we may need to change the kernel protocol */
-	__le64 flags;
+	__le32 flags; /* Use mlx5_vf_migf_header_flags */
+	__le32 tag; /* Use mlx5_vf_migf_header_tag */
+	__u8 data[]; /* Its size is given in the record_size */
 };
 
 struct mlx5_vhca_data_buffer {
@@ -73,6 +89,7 @@ struct mlx5_vf_migration_file {
 	enum mlx5_vf_load_state load_state;
 	u32 pdn;
 	loff_t max_pos;
+	u64 pre_copy_initial_bytes;
 	struct mlx5_vhca_data_buffer *buf;
 	struct mlx5_vhca_data_buffer *buf_header;
 	spinlock_t list_lock;
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 7ba127d8889a..6856e7b97533 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -304,6 +304,87 @@ static void mlx5vf_mark_err(struct mlx5_vf_migration_file *migf)
 	wake_up_interruptible(&migf->poll_wait);
 }
 
+static int mlx5vf_add_stop_copy_header(struct mlx5_vf_migration_file *migf)
+{
+	size_t size = sizeof(struct mlx5_vf_migration_header) +
+		sizeof(struct mlx5_vf_migration_tag_stop_copy_data);
+	struct mlx5_vf_migration_tag_stop_copy_data data = {};
+	struct mlx5_vhca_data_buffer *header_buf = NULL;
+	struct mlx5_vf_migration_header header = {};
+	unsigned long flags;
+	struct page *page;
+	u8 *to_buff;
+	int ret;
+
+	header_buf = mlx5vf_get_data_buffer(migf, size, DMA_NONE);
+	if (IS_ERR(header_buf))
+		return PTR_ERR(header_buf);
+
+	header.record_size = cpu_to_le64(sizeof(data));
+	header.flags = cpu_to_le32(MLX5_MIGF_HEADER_FLAGS_TAG_OPTIONAL);
+	header.tag = cpu_to_le32(MLX5_MIGF_HEADER_TAG_STOP_COPY_SIZE);
+	page = mlx5vf_get_migration_page(header_buf, 0);
+	if (!page) {
+		ret = -EINVAL;
+		goto err;
+	}
+	to_buff = kmap_local_page(page);
+	memcpy(to_buff, &header, sizeof(header));
+	header_buf->length = sizeof(header);
+	data.stop_copy_size = cpu_to_le64(migf->buf->allocated_length);
+	memcpy(to_buff + sizeof(header), &data, sizeof(data));
+	header_buf->length += sizeof(data);
+	kunmap_local(to_buff);
+	header_buf->start_pos = header_buf->migf->max_pos;
+	migf->max_pos += header_buf->length;
+	spin_lock_irqsave(&migf->list_lock, flags);
+	list_add_tail(&header_buf->buf_elm, &migf->buf_list);
+	spin_unlock_irqrestore(&migf->list_lock, flags);
+	migf->pre_copy_initial_bytes = size;
+	return 0;
+err:
+	mlx5vf_put_data_buffer(header_buf);
+	return ret;
+}
+
+static int mlx5vf_prep_stop_copy(struct mlx5_vf_migration_file *migf,
+				 size_t state_size)
+{
+	struct mlx5_vhca_data_buffer *buf;
+	size_t inc_state_size;
+	int ret;
+
+	/* let's be ready for stop_copy size that might grow by 10 percents */
+	if (check_add_overflow(state_size, state_size / 10, &inc_state_size))
+		inc_state_size = state_size;
+
+	buf = mlx5vf_get_data_buffer(migf, inc_state_size, DMA_FROM_DEVICE);
+	if (IS_ERR(buf))
+		return PTR_ERR(buf);
+
+	migf->buf = buf;
+	buf = mlx5vf_get_data_buffer(migf,
+			sizeof(struct mlx5_vf_migration_header), DMA_NONE);
+	if (IS_ERR(buf)) {
+		ret = PTR_ERR(buf);
+		goto err;
+	}
+
+	migf->buf_header = buf;
+	ret = mlx5vf_add_stop_copy_header(migf);
+	if (ret)
+		goto err_header;
+	return 0;
+
+err_header:
+	mlx5vf_put_data_buffer(migf->buf_header);
+	migf->buf_header = NULL;
+err:
+	mlx5vf_put_data_buffer(migf->buf);
+	migf->buf = NULL;
+	return ret;
+}
+
 static long mlx5vf_precopy_ioctl(struct file *filp, unsigned int cmd,
 				 unsigned long arg)
 {
@@ -314,7 +395,7 @@ static long mlx5vf_precopy_ioctl(struct file *filp, unsigned int cmd,
 	loff_t *pos = &filp->f_pos;
 	unsigned long minsz;
 	size_t inc_length = 0;
-	bool end_of_data;
+	bool end_of_data = false;
 	int ret;
 
 	if (cmd != VFIO_MIG_GET_PRECOPY_INFO)
@@ -358,25 +439,19 @@ static long mlx5vf_precopy_ioctl(struct file *filp, unsigned int cmd,
 		goto err_migf_unlock;
 	}
 
-	buf = mlx5vf_get_data_buff_from_pos(migf, *pos, &end_of_data);
-	if (buf) {
-		if (buf->start_pos == 0) {
-			info.initial_bytes = buf->header_image_size - *pos;
-		} else if (buf->start_pos ==
-				sizeof(struct mlx5_vf_migration_header)) {
-			/* First data buffer following the header */
-			info.initial_bytes = buf->start_pos +
-						buf->length - *pos;
-		} else {
-			info.dirty_bytes = buf->start_pos + buf->length - *pos;
-		}
+	if (migf->pre_copy_initial_bytes > *pos) {
+		info.initial_bytes = migf->pre_copy_initial_bytes - *pos;
 	} else {
-		if (!end_of_data) {
-			ret = -EINVAL;
-			goto err_migf_unlock;
+		buf = mlx5vf_get_data_buff_from_pos(migf, *pos, &end_of_data);
+		if (buf) {
+			info.dirty_bytes = buf->start_pos + buf->length - *pos;
+		} else {
+			if (!end_of_data) {
+				ret = -EINVAL;
+				goto err_migf_unlock;
+			}
+			info.dirty_bytes = inc_length;
 		}
-
-		info.dirty_bytes = inc_length;
 	}
 
 	if (!end_of_data || !inc_length) {
@@ -441,10 +516,16 @@ static int mlx5vf_pci_save_device_inc_data(struct mlx5vf_pci_core_device *mvdev)
 	if (ret)
 		goto err;
 
-	buf = mlx5vf_get_data_buffer(migf, length, DMA_FROM_DEVICE);
-	if (IS_ERR(buf)) {
-		ret = PTR_ERR(buf);
-		goto err;
+	/* Checking whether we have a matching pre-allocated buffer that can fit */
+	if (migf->buf && migf->buf->allocated_length >= length) {
+		buf = migf->buf;
+		migf->buf = NULL;
+	} else {
+		buf = mlx5vf_get_data_buffer(migf, length, DMA_FROM_DEVICE);
+		if (IS_ERR(buf)) {
+			ret = PTR_ERR(buf);
+			goto err;
+		}
 	}
 
 	ret = mlx5vf_cmd_save_vhca_state(mvdev, migf, buf, true, false);
@@ -503,6 +584,12 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev, bool track)
 	if (ret)
 		goto out_pd;
 
+	if (track) {
+		ret = mlx5vf_prep_stop_copy(migf, length);
+		if (ret)
+			goto out_pd;
+	}
+
 	buf = mlx5vf_alloc_data_buffer(migf, length, DMA_FROM_DEVICE);
 	if (IS_ERR(buf)) {
 		ret = PTR_ERR(buf);
@@ -516,7 +603,7 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev, bool track)
 out_save:
 	mlx5vf_free_data_buffer(buf);
 out_pd:
-	mlx5vf_cmd_dealloc_pd(migf);
+	mlx5fv_cmd_clean_migf_resources(migf);
 out_free:
 	fput(migf->filp);
 end:
-- 
2.18.1

