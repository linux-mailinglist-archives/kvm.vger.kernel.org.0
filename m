Return-Path: <kvm+bounces-31593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8B299C50F7
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 09:42:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 751EC28304C
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 08:42:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC67820CCE9;
	Tue, 12 Nov 2024 08:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DK3pjwr/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2065.outbound.protection.outlook.com [40.107.244.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555BB20C03B
	for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 08:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731400729; cv=fail; b=ZcoP9Hqw8aZSTUQAFXcgLJAnY5mHdOQbnp9DHUGe1vCVf219n7w7ZBVlbelyOLBVVqCESUmBPaIpPvz+su179jNlFucyR6EZuiCd2bI10QCxE6aXDPMHbci8q4zlQqwyMYUyYzWDP6BhF5pfu0jDC65OItnWo3/DTcv0J6/x0I0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731400729; c=relaxed/simple;
	bh=0UvZ+SfETqUM8evMg8qrOMY1/59yOJAFQwWInV2JgdE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eaTFE2r1aB+69Q7hIGkTF21QzVcdi511bJ6xG/Lrcj/OjZOZYszeyPGEUyEnLJClB9PedKnR27jeN5Ch8Z9hDwZz/fFlMcVERwjh7X8Auv5ntYLrf4HQp2yxFOgOj3CbMOUYM8lhJQeX+MkE5BC+JdGeHjP9Jc9tzlyLDnLQfUM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DK3pjwr/; arc=fail smtp.client-ip=40.107.244.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sd0Sg05KxYN4OVYGiSm8cJX+WoIMt//DPrQlmRGpM+ZXrmCHEIjClRGlp2+ihMPoUcP82oAkSdCUVpDsOadDzkvpCvB7fA62FcSa5abvxCUeVFhjmF7QNWMfDPLd/rkBR9RA8HeA1d2002qsblzneOW1MBZXwLLXoGTJGAYdeCA7gdrPD+zBt9buoZhJQvwbRX+fMcq5+YTrW6qYOrMLDu8jPgkvz3FTlwo7ZHFJNMkm+BNuIELpZ0luZub2fOsU5ZN5Rqi+LTEXG0epiJriYgYjdFwnTwOgtTdlho43ZjUTIu8c1Wmy2HVSSlbWDwFUxNN/WtQn2sCFzXyiTdHzVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FmtJiXU1fa9KsBEp20lkRQC5T0UJXnWKwHLeQei9VfU=;
 b=pinkCz/kJTrwvi/DcHZLteEiHvLg78MBDH4jGTLlnC2Jv4Lpdxt4JRrklFWmbHl3T1IsrD3e0nIos0PubrmeXyZZekplQII7/LrE0ZMb/QzcDDBvYhago7BLCM8YZCiO266D1I7Xb2T5IFUihbuJpXwsNqQEncv4+5vZzGZpmRZ9FvLPXTAY339EWDJ/T7Hq2xD9lYQiCluEJad5QHjJ/DYXliXhALZ8hD9Z6Lfs+XqJXNsl+uGKvmFayqTKVpML+N0KJqwKgcBqrEo4MlGV6hzN7P3wV2NDnucQ3vANB2FJupxTSlEYwRdI8kbU7fYkLRh8HOeWVv6LWLIJuPl54Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FmtJiXU1fa9KsBEp20lkRQC5T0UJXnWKwHLeQei9VfU=;
 b=DK3pjwr/e9fAyVqri7kBxxSG/qsSFXuVqxMHCMHKPrV3vEl/tY/9+b1Gd5TDi9ndHnlnMl4wjfM9jcW0q58LEie5z+AEIzHY+vTzcOh7catUSHTHAbv7Podvd/HFvXwTQzS0AP4UTT8ttEoZJ2JkPfHceQ212W+DXW502xy+f4UdcS5SNm62YCV8jkUXrNr5DeSkfudKLwV7kjJspSxnWmDrN5tK8wY0OsaqbRWcjKvSvYQ+qSx4jdrqVWzAhMIXXPEQDmRmZ/drwFa9qwefz3/V8+k0RFSRBZ4TDvz5/ZFGVpKSdsEJ4Zt24lZ4plqVF+wu6nle/Byfl6qThdT2Bw==
Received: from BN9PR03CA0106.namprd03.prod.outlook.com (2603:10b6:408:fd::21)
 by PH7PR12MB5807.namprd12.prod.outlook.com (2603:10b6:510:1d3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.16; Tue, 12 Nov
 2024 08:38:44 +0000
Received: from MN1PEPF0000F0E5.namprd04.prod.outlook.com
 (2603:10b6:408:fd:cafe::d5) by BN9PR03CA0106.outlook.office365.com
 (2603:10b6:408:fd::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28 via Frontend
 Transport; Tue, 12 Nov 2024 08:38:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MN1PEPF0000F0E5.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.14 via Frontend Transport; Tue, 12 Nov 2024 08:38:43 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 12 Nov
 2024 00:38:28 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 12 Nov
 2024 00:38:28 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.1544.4 via Frontend Transport; Tue, 12 Nov
 2024 00:38:25 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH V3 vfio 3/7] virtio: Manage device and driver capabilities via the admin commands
Date: Tue, 12 Nov 2024 10:37:25 +0200
Message-ID: <20241112083729.145005-4-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20241112083729.145005-1-yishaih@nvidia.com>
References: <20241112083729.145005-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E5:EE_|PH7PR12MB5807:EE_
X-MS-Office365-Filtering-Correlation-Id: f2c7ced4-dc9d-4d55-df41-08dd02f56af7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gFxTB/Sm+xB6J0dS7AQaJZ9y50TfcOzIyisqZFIFA8GYEBnJq85QH4lTFtHs?=
 =?us-ascii?Q?8CE0kXMAKyG9N723bll7JrtrjtFKNyl1uvRiWgQou9NTO/Zh2Y96kS7hfnZU?=
 =?us-ascii?Q?kvL2idX3ifeJjYWF7zN/SuLWVkM/ACMIkT2yPYbG1fmfc8Z6OEZhiTszUZ8B?=
 =?us-ascii?Q?Of+p+QtDy6VqNtEq2GPXG76HLxGcCjxwMgMgF4xtfjM5yQz0aESQ9xjIDDaN?=
 =?us-ascii?Q?Cbsokg/kGYcxBafPnb/pOB1UDQMGl5XKMZPe4WqSsRGURs4m/znNIvSmcpAI?=
 =?us-ascii?Q?1aEswHz+ZTN/WTPWu2ZY75desh1shu/p9aVjDKyMRJIyQ1Bn6gavvBHGb9a8?=
 =?us-ascii?Q?JD6F4Gwex4dm6ZR9KgtT0466a8k5B93+PKM6XqKSPq5k1r5jj71b6LoV1zN1?=
 =?us-ascii?Q?R2FD8iRLNbY/Fsun7IHbPXu5B9ZSygdbtki4eBUWCpp5rokeSpplCHqpd9Bs?=
 =?us-ascii?Q?39/erBD0zbl0Lvqm9L3HjZkV32m1AAcPVdEbeYq+D1iLpcxQNMZOjFrmF3h1?=
 =?us-ascii?Q?4J8UYLvZ/ZOIPxNkxtuOmZjbRa8Kp27z6TxVk+sq2mIg71lt2DRYT7Y8q7aD?=
 =?us-ascii?Q?EPO/5bsk+19gIIVS8P9P1CU7N4iIK3BFBuph0zoqV2M3AWESFARngVL+0i/h?=
 =?us-ascii?Q?dKerBO7fHEgNAb3P8cgYTiccvYACHYhTHp7WKcF1usLLQBIMo/NrmXDBNi7V?=
 =?us-ascii?Q?xd8OQ/jxtSF4azzBirDeR7s0eCGCukDtqU9sS1ETZGNZX3OsHbevn52VLhKY?=
 =?us-ascii?Q?5dYJP5E66wbSxpzdQGeeDSqvQ+2JOjtXklOmQpKuym0h+XqvSl7P+fVn+ZHC?=
 =?us-ascii?Q?p1nO+bvYdiksZFp5M5Edr6pMfGGFc6HPPAY9N3+5L1yILKSOXVGiEJK7EGI+?=
 =?us-ascii?Q?UTSS5GI7VEp3rFVyWJ2Q/F05vnVRTUrsiQy0cZT1nrWnl9DWoersnDFUiXh1?=
 =?us-ascii?Q?ue9Sr5BHCv2dRPDt5aPnQG6vTODkHR+CZ8lsnVOBnIoX2f0JdL8iLJvxtNic?=
 =?us-ascii?Q?57qiGnjxLJz+acMahLKQFgtrz7ILHW/FC/9Mve4C5AUX7Yoi83sLPPaWSF4U?=
 =?us-ascii?Q?v+VpEeghRyqfCRqEhrmUEnJQ74PK55hlbUs12a2Q2Jsn5AmjaBKAGVMqf/yS?=
 =?us-ascii?Q?UD9dnZvnYFcg4HwIEiiJug/J+7f+jBO5NyfJ6dpFzgU2nKb/SLYp3x6gNFEW?=
 =?us-ascii?Q?zuQOHoJ2SRZH+K22Ocku69CZHR7qMngo91Y7ZeOtwdhYhvjwjzVlk25zI5DY?=
 =?us-ascii?Q?h2B8QewPASFGrMNRUHxz831fYcAv0O+Y+7MHlvsXsnB7KKPgr5glTtlTTTrw?=
 =?us-ascii?Q?pcjNSR7p/v/wP2Ane1058fALLH2M+l+6KkGkegGZ2VQWdwEs4c62c29i/sVi?=
 =?us-ascii?Q?Dpd5BxVflKErlP0fEI/y3vZcFxOqmYjHquUXxdIyMWraTr/ayg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 08:38:43.9163
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f2c7ced4-dc9d-4d55-df41-08dd02f56af7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5807

Manage device and driver capabilities via the admin commands.

The device exposes its supported features and resource object limits via
an administrative command called VIRTIO_ADMIN_CMD_CAP_ID_LIST_QUERY,
using the 'self group type.'

Each capability is identified by a unique ID, and the driver
communicates the functionality and resource limits it plans to utilize.

The capability VIRTIO_DEV_PARTS_CAP specifically represents the device's
parts resource object limit.

Manage the device's parts resource object ID using a common IDA for both
get and set operations.

Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/virtio/virtio_pci_common.h |  13 +++-
 drivers/virtio/virtio_pci_modern.c | 105 +++++++++++++++++++++++++++++
 2 files changed, 116 insertions(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
index 1d9c49947f52..04b1d17663b3 100644
--- a/drivers/virtio/virtio_pci_common.h
+++ b/drivers/virtio/virtio_pci_common.h
@@ -48,6 +48,9 @@ struct virtio_pci_admin_vq {
 	/* Protects virtqueue access. */
 	spinlock_t lock;
 	u64 supported_cmds;
+	u64 supported_caps;
+	u8 max_dev_parts_objects;
+	struct ida dev_parts_ida;
 	/* Name of the admin queue: avq.$vq_index. */
 	char name[10];
 	u16 vq_index;
@@ -167,15 +170,21 @@ struct virtio_device *virtio_pci_vf_get_pf_dev(struct pci_dev *pdev);
 	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ) | \
 	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO))
 
+#define VIRTIO_DEV_PARTS_ADMIN_CMD_BITMAP \
+	(BIT_ULL(VIRTIO_ADMIN_CMD_CAP_ID_LIST_QUERY) | \
+	 BIT_ULL(VIRTIO_ADMIN_CMD_DRIVER_CAP_SET) | \
+	 BIT_ULL(VIRTIO_ADMIN_CMD_DEVICE_CAP_GET))
+
 /* Unlike modern drivers which support hardware virtio devices, legacy drivers
  * assume software-based devices: e.g. they don't use proper memory barriers
  * on ARM, use big endian on PPC, etc. X86 drivers are mostly ok though, more
  * or less by chance. For now, only support legacy IO on X86.
  */
 #ifdef CONFIG_VIRTIO_PCI_ADMIN_LEGACY
-#define VIRTIO_ADMIN_CMD_BITMAP VIRTIO_LEGACY_ADMIN_CMD_BITMAP
+#define VIRTIO_ADMIN_CMD_BITMAP (VIRTIO_LEGACY_ADMIN_CMD_BITMAP | \
+				 VIRTIO_DEV_PARTS_ADMIN_CMD_BITMAP)
 #else
-#define VIRTIO_ADMIN_CMD_BITMAP 0
+#define VIRTIO_ADMIN_CMD_BITMAP VIRTIO_DEV_PARTS_ADMIN_CMD_BITMAP
 #endif
 
 void vp_modern_avq_done(struct virtqueue *vq);
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index 487d04610ecb..8ddac2829bc8 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -230,12 +230,117 @@ static void virtio_pci_admin_cmd_list_init(struct virtio_device *virtio_dev)
 	kfree(data);
 }
 
+static void
+virtio_pci_admin_cmd_dev_parts_objects_enable(struct virtio_device *virtio_dev)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(virtio_dev);
+	struct virtio_admin_cmd_cap_get_data *get_data;
+	struct virtio_admin_cmd_cap_set_data *set_data;
+	struct virtio_dev_parts_cap *result;
+	struct virtio_admin_cmd cmd = {};
+	struct scatterlist result_sg;
+	struct scatterlist data_sg;
+	u8 resource_objects_limit;
+	u16 set_data_size;
+	int ret;
+
+	get_data = kzalloc(sizeof(*get_data), GFP_KERNEL);
+	if (!get_data)
+		return;
+
+	result = kzalloc(sizeof(*result), GFP_KERNEL);
+	if (!result)
+		goto end;
+
+	get_data->id = cpu_to_le16(VIRTIO_DEV_PARTS_CAP);
+	sg_init_one(&data_sg, get_data, sizeof(*get_data));
+	sg_init_one(&result_sg, result, sizeof(*result));
+	cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_DEVICE_CAP_GET);
+	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
+	cmd.data_sg = &data_sg;
+	cmd.result_sg = &result_sg;
+	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
+	if (ret)
+		goto err_get;
+
+	set_data_size = sizeof(*set_data) + sizeof(*result);
+	set_data = kzalloc(set_data_size, GFP_KERNEL);
+	if (!set_data)
+		goto err_get;
+
+	set_data->id = cpu_to_le16(VIRTIO_DEV_PARTS_CAP);
+
+	/* Set the limit to the minimum value between the GET and SET values
+	 * supported by the device. Since the obj_id for VIRTIO_DEV_PARTS_CAP
+	 * is a globally unique value per PF, there is no possibility of
+	 * overlap between GET and SET operations.
+	 */
+	resource_objects_limit = min(result->get_parts_resource_objects_limit,
+				     result->set_parts_resource_objects_limit);
+	result->get_parts_resource_objects_limit = resource_objects_limit;
+	result->set_parts_resource_objects_limit = resource_objects_limit;
+	memcpy(set_data->cap_specific_data, result, sizeof(*result));
+	sg_init_one(&data_sg, set_data, set_data_size);
+	cmd.data_sg = &data_sg;
+	cmd.result_sg = NULL;
+	cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_DRIVER_CAP_SET);
+	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
+	if (ret)
+		goto err_set;
+
+	/* Allocate IDR to manage the dev caps objects */
+	ida_init(&vp_dev->admin_vq.dev_parts_ida);
+	vp_dev->admin_vq.max_dev_parts_objects = resource_objects_limit;
+
+err_set:
+	kfree(set_data);
+err_get:
+	kfree(result);
+end:
+	kfree(get_data);
+}
+
+static void virtio_pci_admin_cmd_cap_init(struct virtio_device *virtio_dev)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(virtio_dev);
+	struct virtio_admin_cmd_query_cap_id_result *data;
+	struct virtio_admin_cmd cmd = {};
+	struct scatterlist result_sg;
+	int ret;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return;
+
+	sg_init_one(&result_sg, data, sizeof(*data));
+	cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_CAP_ID_LIST_QUERY);
+	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
+	cmd.result_sg = &result_sg;
+
+	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
+	if (ret)
+		goto end;
+
+	/* Max number of caps fits into a single u64 */
+	BUILD_BUG_ON(sizeof(data->supported_caps) > sizeof(u64));
+
+	vp_dev->admin_vq.supported_caps = le64_to_cpu(data->supported_caps[0]);
+
+	if (!(vp_dev->admin_vq.supported_caps & (1 << VIRTIO_DEV_PARTS_CAP)))
+		goto end;
+
+	virtio_pci_admin_cmd_dev_parts_objects_enable(virtio_dev);
+end:
+	kfree(data);
+}
+
 static void vp_modern_avq_activate(struct virtio_device *vdev)
 {
 	if (!virtio_has_feature(vdev, VIRTIO_F_ADMIN_VQ))
 		return;
 
 	virtio_pci_admin_cmd_list_init(vdev);
+	virtio_pci_admin_cmd_cap_init(vdev);
 }
 
 static void vp_modern_avq_cleanup(struct virtio_device *vdev)
-- 
2.27.0


