Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0CE61E50B
	for <lists+kvm@lfdr.de>; Sun,  6 Nov 2022 18:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbiKFRsI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Nov 2022 12:48:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbiKFRru (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Nov 2022 12:47:50 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2060.outbound.protection.outlook.com [40.107.100.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 834F86479
        for <kvm@vger.kernel.org>; Sun,  6 Nov 2022 09:47:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dnyiN9v+y+r7PyT/lZGHD+qVjw9vqO7zLTMsiX7a3YHY9pKdBuhsrCG6825zGtTPJ34EF5jqNEkCIHJetyXjnk+ZhtdLb4FlQlxqeCQ6rHLW+RgLfnP7rplnJZOvHhfhry1+iQuXLFVOr2Ebxzzz6qP0kerxHB/eDsdHmsn71aXquNDbYCj/03qW62r2y6PGz0NtignVtVuHQa4VzyhhaHh/7w37xoHk7vkilOmnkZ6bCXDpL57W/ojZRYBdwywTFuAOJxotHGp9tLKhSY74EKvB182fMQOWiVFqcY/bMP4PYjjlGqLILDzQrzS8S8nM6X2R7cffRA7W4DZ3/Gu0gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jHdXOUOBTuHi96GiNfo/fIiJce9WDOz0BmHEeWMgRpQ=;
 b=H5I0B76AiNEL4a3rpAVwIHVlXSyL2VRgsOh6dFqc1rCLL6xD04mBlraFZdOD+gcpQJOevV4oECE57jMug2eamoiBc5JBw9GkGi3qxHy3GncTK2xCIsTnSQT4HZz6BezUtm585IUInMhYrPCSWfmVP7b2x8A5jUOJYgWWEDLsSmravRymYIQtphUFvkXk5shGs2R6GmMymwd76nLmsY6F3IDdpwrF689JDww/6bKB4l5/vgbBopFa72wvrjZidhZRqZG5n1g8xJgtKIbpPoCfTubxT3135qXQS/7vF7rY2x/TEfobbRlh8XxXRTeILbsMjG0Rwan4NGVNCU7+Ya/jZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jHdXOUOBTuHi96GiNfo/fIiJce9WDOz0BmHEeWMgRpQ=;
 b=CUjAW1/R0DzmMdGUjVG+yR4FO62C00aHckrn6Z4hygEgMmUCecY/NdMB14BXOTcWBXBRvB0y89abH2axxU89CnNeyoxqeNHFAfcWA39W9THnWMIJiwk8FNnTdoIw3fAAl64wzFaZpvICkxKHLuVHMvBcx5RRuPplupwQ6GN/xnPTVpDRHd3iyq3zJdqSUHhVCCpl/e+F9I5y0Pb8XWbKlmQ4+ZUdEpPMQjlDXx+iXEhaiVMRsLxLONcXbUUh+kY8tNZKtDXxnE6mE1NAmEA1Qc8JILRxEr8YZbl5sSZdhRZUeVJIKdFgjT3i0jMa186n7iVqFJ84VBNPn/fSn/YOnQ==
Received: from BN0PR07CA0027.namprd07.prod.outlook.com (2603:10b6:408:141::29)
 by DM4PR12MB5261.namprd12.prod.outlook.com (2603:10b6:5:398::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Sun, 6 Nov
 2022 17:47:44 +0000
Received: from BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:141:cafe::67) by BN0PR07CA0027.outlook.office365.com
 (2603:10b6:408:141::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26 via Frontend
 Transport; Sun, 6 Nov 2022 17:47:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN8NAM11FT056.mail.protection.outlook.com (10.13.177.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20 via Frontend Transport; Sun, 6 Nov 2022 17:47:43 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Sun, 6 Nov 2022
 09:47:41 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Sun, 6 Nov 2022 09:47:41 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Sun, 6 Nov 2022 09:47:38 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>
Subject: [PATCH vfio 11/13] vfio/mlx5: Introduce multiple loads
Date:   Sun, 6 Nov 2022 19:46:28 +0200
Message-ID: <20221106174630.25909-12-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221106174630.25909-1-yishaih@nvidia.com>
References: <20221106174630.25909-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT056:EE_|DM4PR12MB5261:EE_
X-MS-Office365-Filtering-Correlation-Id: 7736938b-269b-40a3-206a-08dac01f0200
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hgLaTwnF80bKwXw+pV9byp1YMi85XeZM750cUZkAyBsS1U+A8yWHl0FICyEvlxFo6EkxSBSmFKkBXivZ6ZJR5ATxuM9kHdVaM8ZzN/gsVtNWhUCL/o88LRcZh3QuQlTdFjuNVWmQlt81sbr3myM0hitqu/bnf31idnmts5BEAEi4SqTnDJN7cy0mSSf2FqVOKDRhOKpRug8kYbtuUPvCZXPg1lc7aUAjLD45+OOoM08o1uCJtGzKb5xIn+mBvyBFgSrAqrCS8MTtmQ7JC6j5rTdrSywEj6+fqlioN9wuUu5zUHX2gIs2V2+yZjrUGnmh1JVDWcqJVmiLUJ8WMkLDBHg3INi/EuygDbQC7kmpMmOje64XQWjsW8UtVYN4321pXeQmdiYLG7+G2NiNQ+0iwGWqidpWETjwuQYh8Gvzk/GYXg+pDKCswRD0U7SoPuJUMyweZPFZ5syUJ9cs3PQo31bT+0uBDjBGE6+QL5mC4tGMQAtETveIJ6xYBXS3lboiYaA41KV2w7N/NSuCD3PyC6jqysr0tE/V2YSJuv3drvj0Sbvk4WiuA7C7UqTbjH8qfCLJqfh4Npl1EcUH4VNFYyiQJ7KwCJqIlYTzY+pHIkMpjQi6n7ZKp/Ld3fp4SsHFnrF6xslxeOqg7O5SymA8mZK+zHgbI3kdf0cgfTTnX4UU25rimKfNFDCXvaLjzsiS941BO+lYKzGwUPNgnn8JFt82JNWW8W0oTp9DFQ8gh4+ixaTQlSN43URNs7BudGTFN3H3VKcLZesJq6mnSh2W7Q==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(39860400002)(376002)(346002)(451199015)(46966006)(40470700004)(36840700001)(66899015)(82310400005)(70586007)(41300700001)(4326008)(70206006)(8676002)(6636002)(54906003)(110136005)(7636003)(356005)(83380400001)(40480700001)(8936002)(478600001)(2906002)(316002)(36756003)(5660300002)(26005)(2616005)(336012)(186003)(426003)(47076005)(40460700003)(82740400003)(36860700001)(1076003)(86362001)(6666004)(7696005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2022 17:47:43.4553
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7736938b-269b-40a3-206a-08dac01f0200
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5261
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

In order to support PRE_COPY, mlx5 driver transfers multiple states
(images) of the device. e.g.: the source VF can save and transfer
multiple states, and the target VF will load them by that order.

This patch implements the changes for the target VF to decompose the
header for each state and to write and load multiple states.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  | 12 ++---
 drivers/vfio/pci/mlx5/cmd.h  |  2 +
 drivers/vfio/pci/mlx5/main.c | 98 ++++++++++++++++++++++++++++++------
 3 files changed, 89 insertions(+), 23 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 2d2171191218..a1b17cd688b9 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -420,16 +420,14 @@ int mlx5vf_cmd_load_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	if (mvdev->mdev_detach)
 		return -ENOTCONN;
 
-	mutex_lock(&migf->lock);
-	if (!migf->image_length) {
-		err = -EINVAL;
-		goto end;
-	}
+	lockdep_assert_held(&migf->lock);
+	if (!migf->image_length)
+		return -EINVAL;
 
 	mdev = mvdev->mdev;
 	err = mlx5_core_alloc_pd(mdev, &pdn);
 	if (err)
-		goto end;
+		return err;
 
 	err = dma_map_sgtable(mdev->device, &migf->table.sgt, DMA_TO_DEVICE, 0);
 	if (err)
@@ -454,8 +452,6 @@ int mlx5vf_cmd_load_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	dma_unmap_sgtable(mdev->device, &migf->table.sgt, DMA_TO_DEVICE, 0);
 err_reg:
 	mlx5_core_dealloc_pd(mdev, pdn);
-end:
-	mutex_unlock(&migf->lock);
 	return err;
 }
 
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index 3b0411e4a74e..03f3b5e99879 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -39,6 +39,8 @@ struct mlx5_vf_migration_file {
 	size_t table_start_pos;
 	size_t image_length;
 	size_t allocated_length;
+	size_t expected_length;
+	struct mlx5_vf_migration_header header;
 	size_t sw_headers_bytes_sent;
 	/*
 	 * The device can be moved to stop_copy before the previous state was
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index c0ee121bd5ea..6cdd4fc93818 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -569,12 +569,45 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev, bool track)
 	return ERR_PTR(ret);
 }
 
+static void mlx5vf_recv_sw_header(struct mlx5_vf_migration_file *migf,
+				  loff_t *pos, const char __user **buf,
+				  size_t *len, ssize_t *done)
+{
+	ssize_t header_size = sizeof(migf->header);
+	void *header_buf = &migf->header;
+	size_t size_to_recv;
+
+	size_to_recv = header_size - (migf->sw_headers_bytes_sent % header_size);
+	size_to_recv = min_t(size_t, size_to_recv, *len);
+	header_buf += header_size - size_to_recv;
+	if (copy_from_user(header_buf, *buf, size_to_recv)) {
+		*done = -EFAULT;
+		return;
+	}
+
+	*pos += size_to_recv;
+	*len -= size_to_recv;
+	*done += size_to_recv;
+	*buf += size_to_recv;
+	migf->sw_headers_bytes_sent += size_to_recv;
+	migf->header_read = !(migf->sw_headers_bytes_sent % header_size);
+
+	if (migf->sw_headers_bytes_sent % header_size)
+		return;
+	migf->expected_length = migf->header.image_size;
+}
+
+#define EXPECTED_TABLE_END_POSITION(migf) \
+	(migf->table_start_pos + migf->expected_length + \
+	 migf->sw_headers_bytes_sent)
+
 static ssize_t mlx5vf_resume_write(struct file *filp, const char __user *buf,
 				   size_t len, loff_t *pos)
 {
 	struct mlx5_vf_migration_file *migf = filp->private_data;
 	loff_t requested_length;
 	ssize_t done = 0;
+	int ret = 0;
 
 	if (pos)
 		return -ESPIPE;
@@ -584,33 +617,47 @@ static ssize_t mlx5vf_resume_write(struct file *filp, const char __user *buf,
 	    check_add_overflow((loff_t)len, *pos, &requested_length))
 		return -EINVAL;
 
-	if (requested_length > MAX_MIGRATION_SIZE)
-		return -ENOMEM;
-
+	mutex_lock(&migf->mvdev->state_mutex);
 	mutex_lock(&migf->lock);
+	requested_length -= migf->table_start_pos;
+	if (requested_length > MAX_MIGRATION_SIZE) {
+		ret = -ENOMEM;
+		goto out_unlock;
+	}
+
 	if (migf->disabled) {
-		done = -ENODEV;
+		ret = -ENODEV;
 		goto out_unlock;
 	}
 
+start_over:
 	if (migf->allocated_length < requested_length) {
-		done = mlx5vf_add_migration_pages(
+		ret = mlx5vf_add_migration_pages(
 			migf,
 			DIV_ROUND_UP(requested_length - migf->allocated_length,
 				     PAGE_SIZE), &migf->table);
-		if (done)
+		if (ret)
+			goto out_unlock;
+	}
+
+	if (VFIO_PRE_COPY_SUPP(migf->mvdev)) {
+		if (!migf->header_read)
+			mlx5vf_recv_sw_header(migf, pos, &buf, &len, &done);
+		if (done < 0)
 			goto out_unlock;
 	}
 
 	while (len) {
+		unsigned long offset;
 		size_t page_offset;
 		struct page *page;
 		size_t page_len;
 		u8 *to_buff;
-		int ret;
 
-		page_offset = (*pos) % PAGE_SIZE;
-		page = mlx5vf_get_migration_page(migf, *pos - page_offset,
+		offset = *pos - mlx5vf_get_table_start_pos(migf);
+		page_offset = offset % PAGE_SIZE;
+		offset -= page_offset;
+		page = mlx5vf_get_migration_page(migf, offset,
 						 &migf->table);
 		if (!page) {
 			if (done == 0)
@@ -619,11 +666,15 @@ static ssize_t mlx5vf_resume_write(struct file *filp, const char __user *buf,
 		}
 
 		page_len = min_t(size_t, len, PAGE_SIZE - page_offset);
+		if (VFIO_PRE_COPY_SUPP(migf->mvdev))
+			page_len = min_t(size_t, page_len,
+				 EXPECTED_TABLE_END_POSITION(migf) - *pos);
+
 		to_buff = kmap_local_page(page);
 		ret = copy_from_user(to_buff + page_offset, buf, page_len);
 		kunmap_local(to_buff);
 		if (ret) {
-			done = -EFAULT;
+			ret = -EFAULT;
 			goto out_unlock;
 		}
 		*pos += page_len;
@@ -631,10 +682,22 @@ static ssize_t mlx5vf_resume_write(struct file *filp, const char __user *buf,
 		done += page_len;
 		buf += page_len;
 		migf->image_length += page_len;
+
+		if (*pos == EXPECTED_TABLE_END_POSITION(migf)) {
+			ret = mlx5vf_cmd_load_vhca_state(migf->mvdev, migf);
+			if (ret)
+				goto out_unlock;
+			mlx5vf_prep_next_table(migf);
+			if (len) {
+				requested_length -= migf->expected_length;
+				goto start_over;
+			}
+		}
 	}
 out_unlock:
 	mutex_unlock(&migf->lock);
-	return done;
+	mlx5vf_state_mutex_unlock(migf->mvdev);
+	return ret ? ret : done;
 }
 
 static const struct file_operations mlx5vf_resume_fops = {
@@ -663,6 +726,7 @@ mlx5vf_pci_resume_device_data(struct mlx5vf_pci_core_device *mvdev)
 	}
 	stream_open(migf->filp->f_inode, migf->filp);
 	mutex_init(&migf->lock);
+	migf->mvdev = mvdev;
 	return migf;
 }
 
@@ -754,10 +818,14 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
 	}
 
 	if (cur == VFIO_DEVICE_STATE_RESUMING && new == VFIO_DEVICE_STATE_STOP) {
-		ret = mlx5vf_cmd_load_vhca_state(mvdev,
-						 mvdev->resuming_migf);
-		if (ret)
-			return ERR_PTR(ret);
+		if (!VFIO_PRE_COPY_SUPP(mvdev)) {
+			mutex_lock(&mvdev->resuming_migf->lock);
+			ret = mlx5vf_cmd_load_vhca_state(mvdev,
+							 mvdev->resuming_migf);
+			mutex_unlock(&mvdev->resuming_migf->lock);
+			if (ret)
+				return ERR_PTR(ret);
+		}
 		mlx5vf_disable_fds(mvdev);
 		return NULL;
 	}
-- 
2.18.1

