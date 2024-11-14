Return-Path: <kvm+bounces-31847-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 035649C8682
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 10:54:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7045283B79
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 09:54:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B4581F76D5;
	Thu, 14 Nov 2024 09:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qb50Polp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2047.outbound.protection.outlook.com [40.107.243.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC44E1F7080
	for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 09:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731578045; cv=fail; b=KnOITaoX+97/DB0NaCdTvUHPfiw6QlUDQBprEk40VSD57vMz9vp/U4xsO8dCMG9IGXjG+PzUHLbECKd04HYKrmpcavhbHdnoM7ew+rqbxqUA2QKjvwLn6cPeLP4/mN5trCLKUm/OP1hlhBTDf1S+JLoyCOq9Ms9QsflEkIr4NeU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731578045; c=relaxed/simple;
	bh=Mz1rHsu8mGxj6DfEywOUg64QQMXTVU0MxVky75l2vJI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dXVbDN7HcS/beIfC9CnIywJ57r1s2h7XElILgCndDbPJAmA5gJSLAg1ls2GPr/8kqewKGbJG0hda+f26ntsI80RHvcaI3SN9cO2+Gu2OMGdIumOwtXwrZVQF3D7jZyxy6DggB9ufZ3JZKBmi+6RfwRuW5dpnepNxmV0445H0b8o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qb50Polp; arc=fail smtp.client-ip=40.107.243.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B4OP7at/h4VnPmJ0w+6zViexolvTw5t1bem/KsAK6/1rQUfD8k22CFRhV15J+1FAV82KCh1XPzR5RgXiLtreJqiGTjG5yQ7xSH4vgIl8EmyK/je33AnCMtqZSqtJ2bsaeZqLS7/Y/af+SaojgWSF5S0+tJi2VNkWsyRzwXeW5cabX1vbTlbJrvqUN/vmxhr7XyY4foT2VA2Ez+hGq1J06dvDVHzWSeIKcTMm2i/NvPPZ63XV8aiCRTMxl2uB351SKjtbEhonsiqWh5CFFRNKb3fnSQPjApuRgKIHWNBl2BR27nD/a3BpYVd4yTrq33n1+EHmak66xHjHUgQqu89GGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z5/v2JhPgEc+gqWV3fJdB87HeEodXTSK8SyklD8kNh4=;
 b=MiN8+uT8p/8xVA8VLPJY1wFkZOztg0yzw04K1vnaHJl8UTuzT4PIXJqGv41XpqCuMC7TPsXYArisUlvVs/ZFFQMtP+2AG6mKj8HRN/vDI062+PrNW4DJ0y+TK3tL5NJe/K4vRKpky0HoRqRrrJoo3uf0Cp0Ad53tcNu/XEjohJB5pGY7DkRfFpzLmFskemuAXUabnmXMxtvjCZwCfDL9p3DLnMw6f05eIZ0f835Af/4gA5zT3dtO6LcmYrO1ASzgTf/iwK7MQ2yZbr6ChYXWz7ZpTG5rCw71n7I0FEgil+QHe6YKoX5BSwtS0RyRrxnxS8mxRMIA+z/yuiYwvBERbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z5/v2JhPgEc+gqWV3fJdB87HeEodXTSK8SyklD8kNh4=;
 b=qb50PolpiUuXorlLYesk110X1wQnTpfcg8BSNzUnVEYFJYUxb9vc03Xu87dpZMGpjjXYQabvJUkoy4u2NShl4BISKKPIRoluAYLzoRzUF6c47OUNI0YJJg6cs37Qfo7xAmEZh9YdD47o0rxgiNPB8sKGf2MZNnv0qCUNtOTqjQYTbAuLRWgeoBcoeaMZE8t1r82aUTTaKPKJIq4/SBgcevDRX/j2AHJn+MvMnEitlZHJEDXJOjXQBMs3+8r4LhqaMkl9F2/LtI0dUxhR3QEvATxx6KhCCL0VFr2UWPk+pZ7jc0sZ7GiahthVt+HFufakhMSS3NO2xvNGAds3/eSwQQ==
Received: from CH2PR17CA0025.namprd17.prod.outlook.com (2603:10b6:610:53::35)
 by DM6PR12MB4315.namprd12.prod.outlook.com (2603:10b6:5:223::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.19; Thu, 14 Nov
 2024 09:54:00 +0000
Received: from DS2PEPF0000343C.namprd02.prod.outlook.com
 (2603:10b6:610:53:cafe::50) by CH2PR17CA0025.outlook.office365.com
 (2603:10b6:610:53::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17 via Frontend
 Transport; Thu, 14 Nov 2024 09:54:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS2PEPF0000343C.mail.protection.outlook.com (10.167.18.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.14 via Frontend Transport; Thu, 14 Nov 2024 09:53:59 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 14 Nov
 2024 01:53:53 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Thu, 14 Nov 2024 01:53:53 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Thu, 14 Nov 2024 01:53:51 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH vfio 2/2] vfio/mlx5: Fix unwind flows in mlx5vf_pci_save/resume_device_data()
Date: Thu, 14 Nov 2024 11:53:18 +0200
Message-ID: <20241114095318.16556-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20241114095318.16556-1-yishaih@nvidia.com>
References: <20241114095318.16556-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343C:EE_|DM6PR12MB4315:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b1abcf8-89b4-48bc-cc3a-08dd0492437b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZG+I+i7f7DMLmCsTvYpAElRpRXWSvgWluC8TETTrkHshNea45zT6mP+EGf10?=
 =?us-ascii?Q?cqlYwijhbA4AaxQPSZsrSfmxdM0AwMZZp1rjzaidYtU9rZTZ0+XsaKoB/bRS?=
 =?us-ascii?Q?e6f5ZqMbKQstD7gRE/z9bGYJDu04YYMUa/Yea3wyyeoj1kFKTymMC5XQkDpP?=
 =?us-ascii?Q?BWWOcLMKbYfHuzGjCYJOOYI8GV0ptdoLBQHpFp1gOl6yTRSk+5/xl99ZsBH8?=
 =?us-ascii?Q?A6QyImzt2yLwC7TXKdGttV8MzFDRaiEUbkPgcpFMoBgxs+jh7sftIRq36RA/?=
 =?us-ascii?Q?dwdRLQsSmqyNcPbkKBFAr86dJdew5hquGw8LlIVpyAhBZ3fA5Z8nNMDLmlwe?=
 =?us-ascii?Q?TFR1rLzxgnp21OzddPbaEflB/zW2wnhZfMkT/GGf6dlGQ/zOtp7sN0FWIw2/?=
 =?us-ascii?Q?PBO13MwtrGnpp8Td+TXa56D7WgboGI6Qpym9Ne1swp7KzL+FdduigiYk/qho?=
 =?us-ascii?Q?JLRQbkXqD69JDzXQUczMJ2y3vKa8tDjtAfWgGJRjx+8Ba0HVEaTfqjaku3HW?=
 =?us-ascii?Q?59sHH+X7tyuRx1/Jyj8m9SiCIvK3g2zi3pY+iYTq6r8CQJxLwzvHPO8y3Hy5?=
 =?us-ascii?Q?cSkgvyFf+/JS74HsxrXIghtmoWZu0lslxPuAt23NID+4ey9ZGWCEbQLclW7s?=
 =?us-ascii?Q?Lu+w+O9+YVHeWUVpiDzaFUWskOkc8zxFsHlkzGrUO6x8FP3vLHan5jYTLSd5?=
 =?us-ascii?Q?AjEPILX3QSXuw9X9Jt+tc5Oa2ni/GFvj5Asl+qIiFZNgJj4JeuyMEi/0r/WH?=
 =?us-ascii?Q?ulfoJFS7nCxjnLJiWE3za21MDqE4kFMCG2yv8r2kb723ByNqxfBAvEU8kD91?=
 =?us-ascii?Q?rD9E7bO9r/f9XjzUhKLgtJrJxFJJFI5XD7sWH+wrGFWBhb/bRZZHmM0lgORJ?=
 =?us-ascii?Q?cZQahyiGO+4R9+s/N6z8ayey6rY7n3BplIwBvjH+ujS2NiMTAcD6zNqEeQX6?=
 =?us-ascii?Q?LQsUQ+KN63P1SZxEtGu7vjyaxj2qhr3Fg2ELvI42H1SFbE7ntjC+VR9XvE96?=
 =?us-ascii?Q?lddaboftIdRrHQBHZRiokEcYbNehrQ9ajuG0on3dflPoD2470w254vMjv4Xs?=
 =?us-ascii?Q?oPaWhJoDPwycaDMrYY9kuGEefK4hXkkGsQeRKGBNHm2wkhFUCePCyvTxo5jW?=
 =?us-ascii?Q?pvIpUJ7ZtR9mL368pBUjOftfl3Xtht2wWd4P6xYCVOhdFmNnRFy9TGYT8vN3?=
 =?us-ascii?Q?k46p6GGN474ffW15RJx+vhJrunpEoc6WEzN71Z1mxxs5fQ34g/72J3cgXc3i?=
 =?us-ascii?Q?tFw9wZFwzky53wLL9V06wseEFhQ5SzK9yVUbHMTcafbp+kk5uFM1nehR/B4+?=
 =?us-ascii?Q?8tqptA4YLGNHgWZvmp24IqWFPnCHvcLyhd+LJaPetAFTAf06qtjl+PYyY84P?=
 =?us-ascii?Q?Jxvaf2suzrmM3/4FlCErHvvM/9D7Eo9zZSXLwTyq1k+J2zPu9w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2024 09:53:59.8838
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b1abcf8-89b4-48bc-cc3a-08dd0492437b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4315

Fix unwind flows in mlx5vf_pci_save_device_data() and
mlx5vf_pci_resume_device_data() to avoid freeing the migf pointer at the
'end' label, as this will be handled by fput(migf->filp) through
mlx5vf_release_file().

To ensure mlx5vf_release_file() functions correctly, move the
initialization of migf fields (such as migf->lock) to occur before any
potential unwind flow, as these fields may be accessed within
mlx5vf_release_file().

Fixes: 9945a67ea4b3 ("vfio/mlx5: Refactor PD usage")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/main.c | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 242c23eef452..8833e60d42f5 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -640,14 +640,11 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev, bool track)
 					O_RDONLY);
 	if (IS_ERR(migf->filp)) {
 		ret = PTR_ERR(migf->filp);
-		goto end;
+		kfree(migf);
+		return ERR_PTR(ret);
 	}
 
 	migf->mvdev = mvdev;
-	ret = mlx5vf_cmd_alloc_pd(migf);
-	if (ret)
-		goto out_free;
-
 	stream_open(migf->filp->f_inode, migf->filp);
 	mutex_init(&migf->lock);
 	init_waitqueue_head(&migf->poll_wait);
@@ -663,6 +660,11 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev, bool track)
 	INIT_LIST_HEAD(&migf->buf_list);
 	INIT_LIST_HEAD(&migf->avail_list);
 	spin_lock_init(&migf->list_lock);
+
+	ret = mlx5vf_cmd_alloc_pd(migf);
+	if (ret)
+		goto out;
+
 	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev, &length, &full_size, 0);
 	if (ret)
 		goto out_pd;
@@ -692,10 +694,8 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev, bool track)
 	mlx5vf_free_data_buffer(buf);
 out_pd:
 	mlx5fv_cmd_clean_migf_resources(migf);
-out_free:
+out:
 	fput(migf->filp);
-end:
-	kfree(migf);
 	return ERR_PTR(ret);
 }
 
@@ -1016,13 +1016,19 @@ mlx5vf_pci_resume_device_data(struct mlx5vf_pci_core_device *mvdev)
 					O_WRONLY);
 	if (IS_ERR(migf->filp)) {
 		ret = PTR_ERR(migf->filp);
-		goto end;
+		kfree(migf);
+		return ERR_PTR(ret);
 	}
 
+	stream_open(migf->filp->f_inode, migf->filp);
+	mutex_init(&migf->lock);
+	INIT_LIST_HEAD(&migf->buf_list);
+	INIT_LIST_HEAD(&migf->avail_list);
+	spin_lock_init(&migf->list_lock);
 	migf->mvdev = mvdev;
 	ret = mlx5vf_cmd_alloc_pd(migf);
 	if (ret)
-		goto out_free;
+		goto out;
 
 	buf = mlx5vf_alloc_data_buffer(migf, 0, DMA_TO_DEVICE);
 	if (IS_ERR(buf)) {
@@ -1041,20 +1047,13 @@ mlx5vf_pci_resume_device_data(struct mlx5vf_pci_core_device *mvdev)
 	migf->buf_header[0] = buf;
 	migf->load_state = MLX5_VF_LOAD_STATE_READ_HEADER;
 
-	stream_open(migf->filp->f_inode, migf->filp);
-	mutex_init(&migf->lock);
-	INIT_LIST_HEAD(&migf->buf_list);
-	INIT_LIST_HEAD(&migf->avail_list);
-	spin_lock_init(&migf->list_lock);
 	return migf;
 out_buf:
 	mlx5vf_free_data_buffer(migf->buf[0]);
 out_pd:
 	mlx5vf_cmd_dealloc_pd(migf);
-out_free:
+out:
 	fput(migf->filp);
-end:
-	kfree(migf);
 	return ERR_PTR(ret);
 }
 
-- 
2.18.1


