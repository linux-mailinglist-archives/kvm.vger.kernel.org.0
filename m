Return-Path: <kvm+bounces-7490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CD617842A62
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 18:04:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 37C78B28D4A
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 17:04:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 550AD12BEAF;
	Tue, 30 Jan 2024 17:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PkABVf/6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2050.outbound.protection.outlook.com [40.107.223.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C791272C7
	for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 17:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706634216; cv=fail; b=QEWlTxjC0zP0soQmMNqKkMssGlYaazqKpxJKNSNJnJTFOrpXBGYRbFKLkh4YyFO9n8Qy3LK/gPTJb4kIRgkgVyEI9XjAffREhF9PPlLBZCMWNB2iqJ7sWHkiWqvWf4qr+EK7KKuNqQSIBOqoLqaMofUwiUXkAhAFsa0mlh2bKRM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706634216; c=relaxed/simple;
	bh=y9EwWf5kgR/4yLBXOZZRAdIv2xsgii7/PgIRfHPc9Fw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CQ1emDdtQiKUM9CoeVVEE1AcGvopLo95jrOm216N0NFaRGHDDfSgQqWQlaqD5OvE+277FwqkUdNfbaYzd/dCbONxFRmeVcleJZFEFct3PkiTZ0R+uMGQ/nj1wEfaCMNhIgi+8rMtCoxSpebySrGthjPAmTQN2iJrGtaaLdniZhM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PkABVf/6; arc=fail smtp.client-ip=40.107.223.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Byh7hEQfA5Qp+Z+JVKQiEcvl8N2zbzPWxf5EkzOgl3z39iUHlDob8O1bHqg8FR9k0YC5favtTjv8RyqvPsq9ESO8vbeiMgmuV+laCRINWiS9ERp+LSyjMcYZ9dZYcxAGPRQFO9rWP0PHuDc0qEHzgPGNQA5Iq5gLxVJhIfUWuZ+2V+DoLE7eIy0IGeqDfNN3vW34aprgdUGGZfi+tebsOg+1O2oi7YL3g4ql+AVjGuvXhtRCZwma/I1fx/7v44PoSZlQ0up0O5b2IlLVVrZOI44pO42j/VA0peh2o+wpeKxeqaCPhaoxOW6wdASlJC6LesSX/drRVaKD3Skm8rxBLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZadIp9AFi7chsGWgnW+qi8pMW4y58mfD5nYvUiS5fM8=;
 b=MMF6HRtQ5ceZ+RVAsb3hktN6vmgExtIpqG57184cDvLb6y30r4Tm4gASblmcjJ7voeuZ2OFJ7ZnaKlFZq8XJo8ZIlzgIhjT/1mmRYHwcXOOHre0sPwv5JUSrsqj3Gk2QQN3g7tL0f9JeuvWI8MF3UkzExshRnH41Z4onU5juEaFpIklLoOPe1qeSqvpMmN1wsep1NCJLwf0JrBIZ0/kOUrB+4j8pCUP9rIuRZVwIQf5y00N++knOCWasPwdeN4OxLhiHSXM4NoXjW9jqHQw5cUeh3+rUjpNAA5KiTxwuiBjbvVlN/yhdmyk8zQnYmRp6h3vZpywmbnlYPe0CEKrKgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZadIp9AFi7chsGWgnW+qi8pMW4y58mfD5nYvUiS5fM8=;
 b=PkABVf/6P/2fO8F8M5lVRavAGNvZqSc8e6NDZEYUfJJspa51lWsHwOjfZzXH28n6leA8BCsc/kzWUIPwinL3rmIGFo2uTrwmB+/6UIUgVl0xv7HV26otJLCnJlIQ0LxzfZoROc96GMxstBbWFBtnzJtdJet0w0o5szTCCygG5ZKrDfUdsDtcaC0bA6sCdL6JYWzZah2ScCOvMpPOay9gDFZ115vV0LIGdFI7DdxYE4OB50AGzDvVZl3Vd/q+qKQLaqLHmrBUxf+r1T0ppQhZTKHumjV/VMbUulvtNJI38uPiIbesR6U65R49heqVRmtcz4vyqzLfjLXJVcLdNIOdaw==
Received: from DS7P222CA0016.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::8) by
 SJ1PR12MB6124.namprd12.prod.outlook.com (2603:10b6:a03:459::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.34; Tue, 30 Jan
 2024 17:03:27 +0000
Received: from DS3PEPF000099D4.namprd04.prod.outlook.com
 (2603:10b6:8:2e:cafe::f3) by DS7P222CA0016.outlook.office365.com
 (2603:10b6:8:2e::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.34 via Frontend
 Transport; Tue, 30 Jan 2024 17:03:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DS3PEPF000099D4.mail.protection.outlook.com (10.167.17.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7249.19 via Frontend Transport; Tue, 30 Jan 2024 17:03:27 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 30 Jan
 2024 09:03:17 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Tue, 30 Jan 2024 09:03:16 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.41 via Frontend
 Transport; Tue, 30 Jan 2024 09:03:14 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH vfio 5/5] vfio/mlx5: Let firmware knows upon leaving PRE_COPY back to RUNNING
Date: Tue, 30 Jan 2024 19:02:27 +0200
Message-ID: <20240130170227.153464-6-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20240130170227.153464-1-yishaih@nvidia.com>
References: <20240130170227.153464-1-yishaih@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D4:EE_|SJ1PR12MB6124:EE_
X-MS-Office365-Filtering-Correlation-Id: ba234ce5-118d-47ec-2f93-08dc21b560e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	N4IaV6PxjzfdTh55xW7HmzxtCAcxrGXifhzFxy/x+rmNG+//yHA8tatfWMbA9SPP6cg9uZ6+ePSi0Z5N3nYCMA0nuejQyM/R6sZ/XhOQU/A8hyN/QIjqUGHAvFOx3AryZ6VmqEE733CrZeclMhMLaJUUcCwqmRZFbLJAf+MuIIRv4TJicOJbCDG9Y72w/v610bnl+8E7H54G0MIr62mNbD0HOmlNHxL2NJrQbOoERxdhDDeooCJrlFjW4/ET3e/TcC9eQukTdtI7/+06PcJGYQ4yzmM4Tak6BGGJdBVz3f+3DSAS0+JgrcpE36mOSSeVjgk8EMgjhI+d+5b2pXikEReUGp+HrFUCI0cx3PyhY3B+bTeVt6JcXKPSfJAjes6A4hXLUSikqmah3Mm8+lbxukjZzJ097G3kwiIpSj4cxGq1tY+HMYQZjL4WyrO8W11IktUGr9IEG4M1bL4AOKtaGHdGSZCKZDZ3vuqJWZElIh8040lkf79hZrdcGCqzTvsJSC0AwtnPtL3oG6steYve2mqF633ifOPO9aLmcAnOFg5c7qX0iqa+hgsHP4AesZetQ/DXR4znqjf2yV/8XHn1EN089sF4bjkxigMKwuG4iRCPJwZXvhvQNhF999UJqyRTF34r/X0CVXpLSlU9wenpbds9vSdsE1IDogHAhJrHcESN9rMeR8sZIsidIHgaF+ikeDLSjFSluvuWrVpKtSJcNkWc5JDV9C9M0JvXHjO6D7F91S3fy+StgA05NJxdcBJU
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(396003)(39860400002)(376002)(136003)(230922051799003)(451199024)(64100799003)(1800799012)(186009)(82310400011)(36840700001)(40470700004)(46966006)(316002)(6666004)(7696005)(83380400001)(7636003)(1076003)(107886003)(2616005)(5660300002)(8676002)(426003)(6636002)(336012)(54906003)(8936002)(26005)(70206006)(70586007)(356005)(110136005)(86362001)(478600001)(36860700001)(82740400003)(4326008)(47076005)(41300700001)(36756003)(40460700003)(40480700001)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2024 17:03:27.6569
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ba234ce5-118d-47ec-2f93-08dc21b560e4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D4.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6124

Let firmware knows upon leaving PRE_COPY back to RUNNING as of some
error in the target/migration cancellation.

This will let firmware cleaning its internal resources that were turned
on upon PRE_COPY.

The flow is based on the device specification in this area.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  | 14 +++++++++----
 drivers/vfio/pci/mlx5/cmd.h  |  4 +++-
 drivers/vfio/pci/mlx5/main.c | 39 +++++++++++++++++++++++++++++-------
 3 files changed, 45 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 65135c614b5e..320751dac377 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -108,8 +108,9 @@ int mlx5vf_cmd_query_vhca_migration_state(struct mlx5vf_pci_core_device *mvdev,
 		ret = wait_for_completion_interruptible(&mvdev->saving_migf->save_comp);
 		if (ret)
 			return ret;
-		if (mvdev->saving_migf->state ==
-		    MLX5_MIGF_STATE_PRE_COPY_ERROR) {
+		/* Upon cleanup, ignore previous pre_copy error state */
+		if (mvdev->saving_migf->state == MLX5_MIGF_STATE_PRE_COPY_ERROR &&
+		    !(query_flags & MLX5VF_QUERY_CLEANUP)) {
 			/*
 			 * In case we had a PRE_COPY error, only query full
 			 * image for final image
@@ -200,7 +201,7 @@ void mlx5vf_cmd_close_migratable(struct mlx5vf_pci_core_device *mvdev)
 	/* Must be done outside the lock to let it progress */
 	set_tracker_error(mvdev);
 	mutex_lock(&mvdev->state_mutex);
-	mlx5vf_disable_fds(mvdev);
+	mlx5vf_disable_fds(mvdev, NULL);
 	_mlx5vf_free_page_tracker_resources(mvdev);
 	mlx5vf_state_mutex_unlock(mvdev);
 }
@@ -639,6 +640,7 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	u32 in[MLX5_ST_SZ_DW(save_vhca_state_in)] = {};
 	struct mlx5_vhca_data_buffer *header_buf = NULL;
 	struct mlx5vf_async_data *async_data;
+	bool pre_copy_cleanup = false;
 	int err;
 
 	lockdep_assert_held(&mvdev->state_mutex);
@@ -649,6 +651,10 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	if (err)
 		return err;
 
+	if ((migf->state == MLX5_MIGF_STATE_PRE_COPY ||
+	     migf->state == MLX5_MIGF_STATE_PRE_COPY_ERROR) && !track && !inc)
+		pre_copy_cleanup = true;
+
 	if (migf->state == MLX5_MIGF_STATE_PRE_COPY_ERROR)
 		/*
 		 * In case we had a PRE_COPY error, SAVE is triggered only for
@@ -667,7 +673,7 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 
 	async_data = &migf->async_data;
 	async_data->buf = buf;
-	async_data->stop_copy_chunk = !track;
+	async_data->stop_copy_chunk = (!track && !pre_copy_cleanup);
 	async_data->out = kvzalloc(out_size, GFP_KERNEL);
 	if (!async_data->out) {
 		err = -ENOMEM;
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index 09d0ed6e2345..116ed9326421 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -197,6 +197,7 @@ struct mlx5vf_pci_core_device {
 enum {
 	MLX5VF_QUERY_INC = (1UL << 0),
 	MLX5VF_QUERY_FINAL = (1UL << 1),
+	MLX5VF_QUERY_CLEANUP = (1UL << 2),
 };
 
 int mlx5vf_cmd_suspend_vhca(struct mlx5vf_pci_core_device *mvdev, u16 op_mod);
@@ -232,7 +233,8 @@ int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
 struct page *mlx5vf_get_migration_page(struct mlx5_vhca_data_buffer *buf,
 				       unsigned long offset);
 void mlx5vf_state_mutex_unlock(struct mlx5vf_pci_core_device *mvdev);
-void mlx5vf_disable_fds(struct mlx5vf_pci_core_device *mvdev);
+void mlx5vf_disable_fds(struct mlx5vf_pci_core_device *mvdev,
+			enum mlx5_vf_migf_state *last_save_state);
 void mlx5vf_mig_file_cleanup_cb(struct work_struct *_work);
 void mlx5vf_mig_file_set_save_work(struct mlx5_vf_migration_file *migf,
 				   u8 chunk_num, size_t next_required_umem_size);
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index fe09a8c8af95..3982fcf60cf2 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -1146,7 +1146,8 @@ mlx5vf_pci_resume_device_data(struct mlx5vf_pci_core_device *mvdev)
 	return ERR_PTR(ret);
 }
 
-void mlx5vf_disable_fds(struct mlx5vf_pci_core_device *mvdev)
+void mlx5vf_disable_fds(struct mlx5vf_pci_core_device *mvdev,
+			enum mlx5_vf_migf_state *last_save_state)
 {
 	if (mvdev->resuming_migf) {
 		mlx5vf_disable_fd(mvdev->resuming_migf);
@@ -1157,6 +1158,8 @@ void mlx5vf_disable_fds(struct mlx5vf_pci_core_device *mvdev)
 	if (mvdev->saving_migf) {
 		mlx5_cmd_cleanup_async_ctx(&mvdev->saving_migf->async_ctx);
 		cancel_work_sync(&mvdev->saving_migf->async_data.work);
+		if (last_save_state)
+			*last_save_state = mvdev->saving_migf->state;
 		mlx5vf_disable_fd(mvdev->saving_migf);
 		wake_up_interruptible(&mvdev->saving_migf->poll_wait);
 		mlx5fv_cmd_clean_migf_resources(mvdev->saving_migf);
@@ -1217,12 +1220,34 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
 		return migf->filp;
 	}
 
-	if ((cur == VFIO_DEVICE_STATE_STOP_COPY && new == VFIO_DEVICE_STATE_STOP) ||
-	    (cur == VFIO_DEVICE_STATE_PRE_COPY && new == VFIO_DEVICE_STATE_RUNNING) ||
+	if (cur == VFIO_DEVICE_STATE_STOP_COPY && new == VFIO_DEVICE_STATE_STOP) {
+		mlx5vf_disable_fds(mvdev, NULL);
+		return NULL;
+	}
+
+	if ((cur == VFIO_DEVICE_STATE_PRE_COPY && new == VFIO_DEVICE_STATE_RUNNING) ||
 	    (cur == VFIO_DEVICE_STATE_PRE_COPY_P2P &&
 	     new == VFIO_DEVICE_STATE_RUNNING_P2P)) {
-		mlx5vf_disable_fds(mvdev);
-		return NULL;
+		struct mlx5_vf_migration_file *migf = mvdev->saving_migf;
+		struct mlx5_vhca_data_buffer *buf;
+		enum mlx5_vf_migf_state state;
+		size_t size;
+
+		ret = mlx5vf_cmd_query_vhca_migration_state(mvdev, &size, NULL,
+					MLX5VF_QUERY_INC | MLX5VF_QUERY_CLEANUP);
+		if (ret)
+			return ERR_PTR(ret);
+		buf = mlx5vf_get_data_buffer(migf, size, DMA_FROM_DEVICE);
+		if (IS_ERR(buf))
+			return ERR_CAST(buf);
+		/* pre_copy cleanup */
+		ret = mlx5vf_cmd_save_vhca_state(mvdev, migf, buf, false, false);
+		if (ret) {
+			mlx5vf_put_data_buffer(buf);
+			return ERR_PTR(ret);
+		}
+		mlx5vf_disable_fds(mvdev, &state);
+		return (state != MLX5_MIGF_STATE_ERROR) ? NULL : ERR_PTR(-EIO);
 	}
 
 	if (cur == VFIO_DEVICE_STATE_STOP && new == VFIO_DEVICE_STATE_RESUMING) {
@@ -1244,7 +1269,7 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
 			if (ret)
 				return ERR_PTR(ret);
 		}
-		mlx5vf_disable_fds(mvdev);
+		mlx5vf_disable_fds(mvdev, NULL);
 		return NULL;
 	}
 
@@ -1289,7 +1314,7 @@ void mlx5vf_state_mutex_unlock(struct mlx5vf_pci_core_device *mvdev)
 		mvdev->deferred_reset = false;
 		spin_unlock(&mvdev->reset_lock);
 		mvdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
-		mlx5vf_disable_fds(mvdev);
+		mlx5vf_disable_fds(mvdev, NULL);
 		goto again;
 	}
 	mutex_unlock(&mvdev->state_mutex);
-- 
2.18.1


