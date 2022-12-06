Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB6A4643ED0
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 09:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234323AbiLFIgt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 03:36:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234347AbiLFIgT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 03:36:19 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2070.outbound.protection.outlook.com [40.107.220.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7549E11C22
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 00:36:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fI0fv7SyBm5GVKGdcq7nIQnsI/JhiI1URdXxICPkUUfWQtYMiejuub5J4Pgd5S2rTUAbld+nu2g32vsNCix/xUYHyusCP+hUDjlieMzmAFrzA/zLPhBB/v/r/IYSga557AlisGLfhv3zutGTysENbs/4DQ8jEgJ1TRsW1viZ2o70ZL6bX7uSuNQE0RngZ975RBepOwF3PYurXf94YMmZfYjrdYXnyDxlw+mhlAH1CJlGwMLvtSB3wg0SWX8bnBPtTty5P4oNznRRTHVtdXAiCEaF/Vr+uddEeu8ymUVCpmSkU2qSShngwq8dNwCuVnFTvggJOUrMgH/n+aXMjHIqNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1kjWSL/NvcwnX0VkBPJd1Ah1drM5Q4vbENWvmq2LPzo=;
 b=iAhk5g2L/wQ6xmqImsETGU7fcI0P3IdY/BkizGfH+y+DiXDf/JXQZNNzlzugGUfOT6urvSTxeik7Uqa0D+NHRXjBUCZRyxi/zyK4RAm1OyRCXsJ0Uq1jNsMnUILjL10eohmGtaAKLkVGhcQzJ1fMs9a3e6kUOg4WmXMvQAjcoszE0rx8gzFkKdnTfrFXfgACm1pO5GU8kCShDVDVwTv9N3vYPh1CDJRrtvlT2qbHoidtejeFnEKSsZCdhNW3ZsmmP7/QceXG7/vkHtA5ME0zibisYIWE9hYGS44SA2KVHvet0vfWTYkAMLX10siOx5fAVAraH5X4KMB1OBw6Vkix0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1kjWSL/NvcwnX0VkBPJd1Ah1drM5Q4vbENWvmq2LPzo=;
 b=aEs/j1CqTQp6Ne8KvpJ7+6E8ViO3AGgLLm07PQnzINYQvNY9wU0c6CIsYvDI8wianSGak9Uma/0QGjFVZbmIDFocwaJt0A3s909AHT4+R2nGVPNKNLB6vUi5o/tzkPi0z50SGC2jLrb8blUpMVP81xwN9kk0Zv53oeFSoLnfSTAIZScqDwdcm4+a5mYNFMnvd2NUkcs7n47Qru41n/h4ZVBzy15fLTboG97CyVtmQ6XYvPpJkP6cdHY0spfJccSb16aX6EdTKQiOBdkfknmNFSTB3A1gPEMEU0Xmqx3VeyRjKyBi0AONtT3jVEqYLP8wlduGdgrUbfZl2HE0Qs86kA==
Received: from DM6PR12CA0009.namprd12.prod.outlook.com (2603:10b6:5:1c0::22)
 by CH2PR12MB4908.namprd12.prod.outlook.com (2603:10b6:610:6b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 08:36:05 +0000
Received: from DS1PEPF0000E653.namprd02.prod.outlook.com
 (2603:10b6:5:1c0:cafe::7a) by DM6PR12CA0009.outlook.office365.com
 (2603:10b6:5:1c0::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Tue, 6 Dec 2022 08:36:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS1PEPF0000E653.mail.protection.outlook.com (10.167.18.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8 via Frontend Transport; Tue, 6 Dec 2022 08:36:05 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 6 Dec 2022
 00:35:53 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 6 Dec 2022 00:35:53 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Tue, 6 Dec 2022 00:35:50 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V4 vfio 12/14] vfio/mlx5: Introduce multiple loads
Date:   Tue, 6 Dec 2022 10:34:36 +0200
Message-ID: <20221206083438.37807-13-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221206083438.37807-1-yishaih@nvidia.com>
References: <20221206083438.37807-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E653:EE_|CH2PR12MB4908:EE_
X-MS-Office365-Filtering-Correlation-Id: 71d942a4-0ed1-471d-328f-08dad764ea5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PvD6hlMKn2qhanJXTZf+ZqDIPNH274ssJWvluQhiuEQN74YQOjHaCT82/PQy1FzoBY0Dr9KefI6R3kpmEd6Hd4g9QWzMj+SK78Yr674CmkTleN+yckai/fA7Ryvx5Mc3bfx7P6QTErJBFNvaKqJkrbtF4pZeluMZyjMaeRcqtftV9qINDnB1X1oVay1fmOznFDwTZB+r/DkjpDB5LhBESqBGxuFP7F+hWMDDihOq3/5wBJKy5bYq+M3g3ayNEmMltGmdiAKvBYczd3Ri4GuP521bS43NiBmQGa87YFD0v9q02LC+HSzlvgfzFUkbapxvwXDYsd8c6kbjDYRjuJe29hNpzDC31yu7WKmRpkhetKWoV91D02OcBm1kQu+t26hwiD9zyVinFXv3Pc8x+fXKXMpNp83cHUru6vy5MQ+hMmTUlS9eNVepV7Qm8hJLvgZ51DMtTpVqqi5HAATA0yXsuBqJP6JsHiCesFP+fyMgsdfRq8Kekbwgs+q2xgVMfa68w4inwzmlHVHxEF690fmHV5kLcHkDfOE0x3eF0Scat7yQ82OD6hdYkh3LzOrcYNcxPgt1Jp+6JdHkvr0+PiFrbfZxnzxHvqU3xYEwZIVMCablheJHXaTH+ylLBGgFTI+/6GPYKFIgTMICUTwqVKMY9WT/VQy4s1GbgVQxVcbpEPF54fV7UfqTLnYCzOgI/ZnkBHyyNqF6QDUOrO19GuJj+g==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(136003)(39860400002)(451199015)(36840700001)(40470700004)(46966006)(66899015)(36756003)(356005)(82740400003)(86362001)(7636003)(5660300002)(8936002)(41300700001)(2906002)(4326008)(40460700003)(30864003)(36860700001)(83380400001)(478600001)(70586007)(70206006)(316002)(6636002)(110136005)(54906003)(2616005)(40480700001)(8676002)(82310400005)(426003)(47076005)(336012)(6666004)(26005)(186003)(7696005)(1076003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 08:36:05.3618
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 71d942a4-0ed1-471d-328f-08dad764ea5d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E653.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4908
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to support PRE_COPY, mlx5 driver transfers multiple states
(images) of the device. e.g.: the source VF can save and transfer
multiple states, and the target VF will load them by that order.

This patch implements the changes for the target VF to decompose the
header for each state and to write and load multiple states.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  |  13 +-
 drivers/vfio/pci/mlx5/cmd.h  |  10 ++
 drivers/vfio/pci/mlx5/main.c | 279 +++++++++++++++++++++++++++++------
 3 files changed, 257 insertions(+), 45 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index f6293da033cc..993749818d90 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -598,9 +598,11 @@ int mlx5vf_cmd_load_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	if (mvdev->mdev_detach)
 		return -ENOTCONN;
 
-	err = mlx5vf_dma_data_buffer(buf);
-	if (err)
-		return err;
+	if (!buf->dmaed) {
+		err = mlx5vf_dma_data_buffer(buf);
+		if (err)
+			return err;
+	}
 
 	MLX5_SET(load_vhca_state_in, in, opcode,
 		 MLX5_CMD_OP_LOAD_VHCA_STATE);
@@ -644,6 +646,11 @@ void mlx5fv_cmd_clean_migf_resources(struct mlx5_vf_migration_file *migf)
 		migf->buf = NULL;
 	}
 
+	if (migf->buf_header) {
+		mlx5vf_free_data_buffer(migf->buf_header);
+		migf->buf_header = NULL;
+	}
+
 	list_splice(&migf->avail_list, &migf->buf_list);
 
 	while ((entry = list_first_entry_or_null(&migf->buf_list,
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index d048f23977dd..7729eac8c78c 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -22,6 +22,14 @@ enum mlx5_vf_migf_state {
 	MLX5_MIGF_STATE_COMPLETE,
 };
 
+enum mlx5_vf_load_state {
+	MLX5_VF_LOAD_STATE_READ_IMAGE_NO_HEADER,
+	MLX5_VF_LOAD_STATE_READ_HEADER,
+	MLX5_VF_LOAD_STATE_PREP_IMAGE,
+	MLX5_VF_LOAD_STATE_READ_IMAGE,
+	MLX5_VF_LOAD_STATE_LOAD_IMAGE,
+};
+
 struct mlx5_vf_migration_header {
 	__le64 image_size;
 	/* For future use in case we may need to change the kernel protocol */
@@ -60,9 +68,11 @@ struct mlx5_vf_migration_file {
 	struct mutex lock;
 	enum mlx5_vf_migf_state state;
 
+	enum mlx5_vf_load_state load_state;
 	u32 pdn;
 	loff_t max_pos;
 	struct mlx5_vhca_data_buffer *buf;
+	struct mlx5_vhca_data_buffer *buf_header;
 	spinlock_t list_lock;
 	struct list_head buf_list;
 	struct list_head avail_list;
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 44b1543c751c..5a669b73994a 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -518,13 +518,162 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev, bool track)
 	return ERR_PTR(ret);
 }
 
+static int
+mlx5vf_append_page_to_mig_buf(struct mlx5_vhca_data_buffer *vhca_buf,
+			      const char __user **buf, size_t *len,
+			      loff_t *pos, ssize_t *done)
+{
+	unsigned long offset;
+	size_t page_offset;
+	struct page *page;
+	size_t page_len;
+	u8 *to_buff;
+	int ret;
+
+	offset = *pos - vhca_buf->start_pos;
+	page_offset = offset % PAGE_SIZE;
+
+	page = mlx5vf_get_migration_page(vhca_buf, offset - page_offset);
+	if (!page)
+		return -EINVAL;
+	page_len = min_t(size_t, *len, PAGE_SIZE - page_offset);
+	to_buff = kmap_local_page(page);
+	ret = copy_from_user(to_buff + page_offset, *buf, page_len);
+	kunmap_local(to_buff);
+	if (ret)
+		return -EFAULT;
+
+	*pos += page_len;
+	*done += page_len;
+	*buf += page_len;
+	*len -= page_len;
+	vhca_buf->length += page_len;
+	return 0;
+}
+
+static int
+mlx5vf_resume_read_image_no_header(struct mlx5_vhca_data_buffer *vhca_buf,
+				   loff_t requested_length,
+				   const char __user **buf, size_t *len,
+				   loff_t *pos, ssize_t *done)
+{
+	int ret;
+
+	if (requested_length > MAX_MIGRATION_SIZE)
+		return -ENOMEM;
+
+	if (vhca_buf->allocated_length < requested_length) {
+		ret = mlx5vf_add_migration_pages(
+			vhca_buf,
+			DIV_ROUND_UP(requested_length - vhca_buf->allocated_length,
+				     PAGE_SIZE));
+		if (ret)
+			return ret;
+	}
+
+	while (*len) {
+		ret = mlx5vf_append_page_to_mig_buf(vhca_buf, buf, len, pos,
+						    done);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static ssize_t
+mlx5vf_resume_read_image(struct mlx5_vf_migration_file *migf,
+			 struct mlx5_vhca_data_buffer *vhca_buf,
+			 size_t image_size, const char __user **buf,
+			 size_t *len, loff_t *pos, ssize_t *done,
+			 bool *has_work)
+{
+	size_t copy_len, to_copy;
+	int ret;
+
+	to_copy = min_t(size_t, *len, image_size - vhca_buf->length);
+	copy_len = to_copy;
+	while (to_copy) {
+		ret = mlx5vf_append_page_to_mig_buf(vhca_buf, buf, &to_copy, pos,
+						    done);
+		if (ret)
+			return ret;
+	}
+
+	*len -= copy_len;
+	if (vhca_buf->length == image_size) {
+		migf->load_state = MLX5_VF_LOAD_STATE_LOAD_IMAGE;
+		migf->max_pos += image_size;
+		*has_work = true;
+	}
+
+	return 0;
+}
+
+static int
+mlx5vf_resume_read_header(struct mlx5_vf_migration_file *migf,
+			  struct mlx5_vhca_data_buffer *vhca_buf,
+			  const char __user **buf,
+			  size_t *len, loff_t *pos,
+			  ssize_t *done, bool *has_work)
+{
+	struct page *page;
+	size_t copy_len;
+	u8 *to_buff;
+	int ret;
+
+	copy_len = min_t(size_t, *len,
+		sizeof(struct mlx5_vf_migration_header) - vhca_buf->length);
+	page = mlx5vf_get_migration_page(vhca_buf, 0);
+	if (!page)
+		return -EINVAL;
+	to_buff = kmap_local_page(page);
+	ret = copy_from_user(to_buff + vhca_buf->length, *buf, copy_len);
+	if (ret) {
+		ret = -EFAULT;
+		goto end;
+	}
+
+	*buf += copy_len;
+	*pos += copy_len;
+	*done += copy_len;
+	*len -= copy_len;
+	vhca_buf->length += copy_len;
+	if (vhca_buf->length == sizeof(struct mlx5_vf_migration_header)) {
+		u64 flags;
+
+		vhca_buf->header_image_size = le64_to_cpup((__le64 *)to_buff);
+		if (vhca_buf->header_image_size > MAX_MIGRATION_SIZE) {
+			ret = -ENOMEM;
+			goto end;
+		}
+
+		flags = le64_to_cpup((__le64 *)(to_buff +
+			    offsetof(struct mlx5_vf_migration_header, flags)));
+		if (flags) {
+			ret = -EOPNOTSUPP;
+			goto end;
+		}
+
+		migf->load_state = MLX5_VF_LOAD_STATE_PREP_IMAGE;
+		migf->max_pos += vhca_buf->length;
+		*has_work = true;
+	}
+end:
+	kunmap_local(to_buff);
+	return ret;
+}
+
 static ssize_t mlx5vf_resume_write(struct file *filp, const char __user *buf,
 				   size_t len, loff_t *pos)
 {
 	struct mlx5_vf_migration_file *migf = filp->private_data;
 	struct mlx5_vhca_data_buffer *vhca_buf = migf->buf;
+	struct mlx5_vhca_data_buffer *vhca_buf_header = migf->buf_header;
 	loff_t requested_length;
+	bool has_work = false;
 	ssize_t done = 0;
+	int ret = 0;
 
 	if (pos)
 		return -ESPIPE;
@@ -534,56 +683,83 @@ static ssize_t mlx5vf_resume_write(struct file *filp, const char __user *buf,
 	    check_add_overflow((loff_t)len, *pos, &requested_length))
 		return -EINVAL;
 
-	if (requested_length > MAX_MIGRATION_SIZE)
-		return -ENOMEM;
-
+	mutex_lock(&migf->mvdev->state_mutex);
 	mutex_lock(&migf->lock);
 	if (migf->state == MLX5_MIGF_STATE_ERROR) {
-		done = -ENODEV;
+		ret = -ENODEV;
 		goto out_unlock;
 	}
 
-	if (vhca_buf->allocated_length < requested_length) {
-		done = mlx5vf_add_migration_pages(
-			vhca_buf,
-			DIV_ROUND_UP(requested_length - vhca_buf->allocated_length,
-				     PAGE_SIZE));
-		if (done)
-			goto out_unlock;
-	}
+	while (len || has_work) {
+		has_work = false;
+		switch (migf->load_state) {
+		case MLX5_VF_LOAD_STATE_READ_HEADER:
+			ret = mlx5vf_resume_read_header(migf, vhca_buf_header,
+							&buf, &len, pos,
+							&done, &has_work);
+			if (ret)
+				goto out_unlock;
+			break;
+		case MLX5_VF_LOAD_STATE_PREP_IMAGE:
+		{
+			u64 size = vhca_buf_header->header_image_size;
+
+			if (vhca_buf->allocated_length < size) {
+				mlx5vf_free_data_buffer(vhca_buf);
+
+				migf->buf = mlx5vf_alloc_data_buffer(migf,
+							size, DMA_TO_DEVICE);
+				if (IS_ERR(migf->buf)) {
+					ret = PTR_ERR(migf->buf);
+					migf->buf = NULL;
+					goto out_unlock;
+				}
 
-	while (len) {
-		size_t page_offset;
-		struct page *page;
-		size_t page_len;
-		u8 *to_buff;
-		int ret;
+				vhca_buf = migf->buf;
+			}
 
-		page_offset = (*pos) % PAGE_SIZE;
-		page = mlx5vf_get_migration_page(vhca_buf, *pos - page_offset);
-		if (!page) {
-			if (done == 0)
-				done = -EINVAL;
-			goto out_unlock;
+			vhca_buf->start_pos = migf->max_pos;
+			migf->load_state = MLX5_VF_LOAD_STATE_READ_IMAGE;
+			break;
 		}
+		case MLX5_VF_LOAD_STATE_READ_IMAGE_NO_HEADER:
+			ret = mlx5vf_resume_read_image_no_header(vhca_buf,
+						requested_length,
+						&buf, &len, pos, &done);
+			if (ret)
+				goto out_unlock;
+			break;
+		case MLX5_VF_LOAD_STATE_READ_IMAGE:
+			ret = mlx5vf_resume_read_image(migf, vhca_buf,
+						vhca_buf_header->header_image_size,
+						&buf, &len, pos, &done, &has_work);
+			if (ret)
+				goto out_unlock;
+			break;
+		case MLX5_VF_LOAD_STATE_LOAD_IMAGE:
+			ret = mlx5vf_cmd_load_vhca_state(migf->mvdev, migf, vhca_buf);
+			if (ret)
+				goto out_unlock;
+			migf->load_state = MLX5_VF_LOAD_STATE_READ_HEADER;
 
-		page_len = min_t(size_t, len, PAGE_SIZE - page_offset);
-		to_buff = kmap_local_page(page);
-		ret = copy_from_user(to_buff + page_offset, buf, page_len);
-		kunmap_local(to_buff);
-		if (ret) {
-			done = -EFAULT;
-			goto out_unlock;
+			/* prep header buf for next image */
+			vhca_buf_header->length = 0;
+			vhca_buf_header->header_image_size = 0;
+			/* prep data buf for next image */
+			vhca_buf->length = 0;
+
+			break;
+		default:
+			break;
 		}
-		*pos += page_len;
-		len -= page_len;
-		done += page_len;
-		buf += page_len;
-		vhca_buf->length += page_len;
 	}
+
 out_unlock:
+	if (ret)
+		migf->state = MLX5_MIGF_STATE_ERROR;
 	mutex_unlock(&migf->lock);
-	return done;
+	mlx5vf_state_mutex_unlock(migf->mvdev);
+	return ret ? ret : done;
 }
 
 static const struct file_operations mlx5vf_resume_fops = {
@@ -623,12 +799,29 @@ mlx5vf_pci_resume_device_data(struct mlx5vf_pci_core_device *mvdev)
 	}
 
 	migf->buf = buf;
+	if (MLX5VF_PRE_COPY_SUPP(mvdev)) {
+		buf = mlx5vf_alloc_data_buffer(migf,
+			sizeof(struct mlx5_vf_migration_header), DMA_NONE);
+		if (IS_ERR(buf)) {
+			ret = PTR_ERR(buf);
+			goto out_buf;
+		}
+
+		migf->buf_header = buf;
+		migf->load_state = MLX5_VF_LOAD_STATE_READ_HEADER;
+	} else {
+		/* Initial state will be to read the image */
+		migf->load_state = MLX5_VF_LOAD_STATE_READ_IMAGE_NO_HEADER;
+	}
+
 	stream_open(migf->filp->f_inode, migf->filp);
 	mutex_init(&migf->lock);
 	INIT_LIST_HEAD(&migf->buf_list);
 	INIT_LIST_HEAD(&migf->avail_list);
 	spin_lock_init(&migf->list_lock);
 	return migf;
+out_buf:
+	mlx5vf_free_data_buffer(buf);
 out_pd:
 	mlx5vf_cmd_dealloc_pd(migf);
 out_free:
@@ -728,11 +921,13 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
 	}
 
 	if (cur == VFIO_DEVICE_STATE_RESUMING && new == VFIO_DEVICE_STATE_STOP) {
-		ret = mlx5vf_cmd_load_vhca_state(mvdev,
-						 mvdev->resuming_migf,
-						 mvdev->resuming_migf->buf);
-		if (ret)
-			return ERR_PTR(ret);
+		if (!MLX5VF_PRE_COPY_SUPP(mvdev)) {
+			ret = mlx5vf_cmd_load_vhca_state(mvdev,
+							 mvdev->resuming_migf,
+							 mvdev->resuming_migf->buf);
+			if (ret)
+				return ERR_PTR(ret);
+		}
 		mlx5vf_disable_fds(mvdev);
 		return NULL;
 	}
-- 
2.18.1

