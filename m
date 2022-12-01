Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2116463F3F4
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 16:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbiLAPbX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 10:31:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231795AbiLAPax (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 10:30:53 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2075.outbound.protection.outlook.com [40.107.220.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95972AD328
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 07:30:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VmVAFLu64RGWM/i+IM1AhQbox6+Py4w5kqa02TsTj0cDFMO7IeCRgfGwuYu82OYFcsU/V3Dz4ppofOTABInDr7LAjwI6CCryMWfIIfGXdWlIEAi8FfLn417e5gmZH5Lw6/J1T5Mq4aBzLBDDJaWIO6Ot+448N3QjJ3Hf4XBkfVhCw8byn7ocNILi0yALzQlsdAK/14M9hfNG/W3vC5XzS6So6dGuhy3582EmmQjrhXlUAPmFIoonCWPpSFBXpLK1C5AK8uWVewtCgvf3hGeslnTupEs/YXDchAXFiemPSI3PDhShpqDPiE7E8BTVKhN0NAt7+1pCfVlOnodOiAnysA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vW65VijTtTaifiJKYSq9rJCoqh45qGsF35hEllCOxao=;
 b=KPn1p+1pB2ruHQH22AHf/tUJqSFrB5wT0jWwTpDEpJHvtuYGE5wKjPpMyCrTcGmMyoatEj6dRa00pYTedRe/di2rOdLMaVEyyxxaNwpvt8o8u15JRVR27bn2UyP8dpsk57DHkSIYcVmIzjawxxhwquX8xGgjRPaA8pIqILyMxU2gm2El9EmWmG6uJsnGxYudeM8qNZNtvzsO3Js5gqq7GuSLrUU3hPBO+qqv6GdovFbegC8DX/KbyKoYo0WFU0EW1TMPzrzHog7RdquadOrFAKA57wMKZfdykBlgPWG7rjFvhHseUzy+4DbAudFMkJcVf0GV6+tma+uJYyN1vT8taQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vW65VijTtTaifiJKYSq9rJCoqh45qGsF35hEllCOxao=;
 b=H0+RqoYobC0YfomriF6Eay4G4W/jtQ8umB2GSlJEhMrx0jaPwohZomUzkxxqT/JdEzy3mx/TnGymb7woFdPvOUa04CY1mrwOLWlVevyqAG3UFh63V4DhHL+5jv28PZMnvaT4tMb7PgPCT04VlFIzcd4o0DujGTMDM7a106EEyoVBFT2tK0G/hSIp6oBNej1KAec2x7WA2+0z+x5D6vfICH10EBasGZVc3KhDEB0Jru0XSz7pwTqk47UDeItu6bhk6VBc+cBH4WbU1wt4OVOIZNSJtBg+2Exxm44m4C7RN2ocF2NCPAeGDG7E03cD31MuwrpSO8Ef010F7swa3mPm5w==
Received: from DM6PR06CA0075.namprd06.prod.outlook.com (2603:10b6:5:336::8) by
 IA1PR12MB7661.namprd12.prod.outlook.com (2603:10b6:208:426::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 15:30:48 +0000
Received: from DS1PEPF0000E631.namprd02.prod.outlook.com
 (2603:10b6:5:336:cafe::b7) by DM6PR06CA0075.outlook.office365.com
 (2603:10b6:5:336::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8 via Frontend
 Transport; Thu, 1 Dec 2022 15:30:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS1PEPF0000E631.mail.protection.outlook.com (10.167.17.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8 via Frontend Transport; Thu, 1 Dec 2022 15:30:48 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 1 Dec 2022
 07:30:37 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 1 Dec 2022 07:30:37 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Thu, 1 Dec 2022 07:30:34 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>
Subject: [PATCH V2 vfio 12/14] vfio/mlx5: Introduce multiple loads
Date:   Thu, 1 Dec 2022 17:29:29 +0200
Message-ID: <20221201152931.47913-13-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221201152931.47913-1-yishaih@nvidia.com>
References: <20221201152931.47913-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E631:EE_|IA1PR12MB7661:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f4eba38-11e2-49f5-6e56-08dad3b105a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 44yg0h75M2CkhgzGA0j1qhfGeSDCzKndPNPtK3rL3xJnSk4ZxwfDrrziINqpV2FBdPqATkvHmxjSSp7cMbwrb902kUUclUMA3cFVGxQo9I1m8jgGWP4Df2yVCZplALdbjbonnQIzuk6zxTIbe+DJ9jBUqXpGEfyGK9yVtcYE5Tw8yzj0j/SowbBE9XC3VFhLpt94nk2d3uWYyutvbXcyoe+rLB7DoxLtUNUJCvn3LSY6ollKc+DhwNHBQjmBN12DUpV5z/CuV64A4fyUQCi7ci/ai+AiIwaQ22vY33xltdmKCw6BdoUxVAnj+HnlnQ/9tNkxPI12JbuUe9BjSxrEVyqwjKLy9i7NFrdaop/D5i+vKVXjAcD07QvhEcL2fEowY59u8tL4ec30VIHz0thaBZzFTlAuMiaO21HKXVyuz8tVORpJhzLBky3u+EjFuK9UuHW8zXeO0Zad8UloCQLhtww/NUXnCWtE67DxYvCmc+1lmc01y0TgemAbBwVnP678NftJKe21PCyNjy5jDqAskwMnTaX8JlehBp/62p+HsBcYBuStBk2M27dH9mbLid/UJ7wPRsqNALoQQ43h+26RAaFql4jyak9YZOie49hPDalTxx3vg8xEP6LynmQmS2nekryHLkN0XiC9QfZvohIAuyR+ygDuukDqte2lCwGb5imqKQXKFs6KnXruUAjtpXDAl7VBLEdUmJrayrNBNFysFg==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(396003)(136003)(376002)(451199015)(46966006)(36840700001)(40470700004)(5660300002)(316002)(40460700003)(54906003)(110136005)(26005)(6636002)(7696005)(82310400005)(1076003)(8676002)(70206006)(2616005)(41300700001)(4326008)(70586007)(83380400001)(8936002)(36756003)(186003)(336012)(47076005)(40480700001)(36860700001)(6666004)(2906002)(478600001)(426003)(66899015)(30864003)(82740400003)(356005)(86362001)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 15:30:48.2340
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f4eba38-11e2-49f5-6e56-08dad3b105a5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E631.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7661
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
index 28185085008f..b8662cfd3a59 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -513,13 +513,162 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev, bool track)
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
@@ -529,56 +678,83 @@ static ssize_t mlx5vf_resume_write(struct file *filp, const char __user *buf,
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
@@ -618,12 +794,29 @@ mlx5vf_pci_resume_device_data(struct mlx5vf_pci_core_device *mvdev)
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
@@ -723,11 +916,13 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
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

