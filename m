Return-Path: <kvm+bounces-30491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9001D9BB0F5
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 11:23:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 502ED281817
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 10:23:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99F7A1B219C;
	Mon,  4 Nov 2024 10:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="okLvkr6q"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2045.outbound.protection.outlook.com [40.107.93.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17751B2191
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 10:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730715812; cv=fail; b=QK7d7ACCNQgn8F+5LntWxKgT9+zX1TcoaCsmxaYHmwDnHJOe5esXpJaZhK/WPCRzA97nF3Yrp7ikHL0NW9lk9dAKpWWBYLOyBBrvmpjjzhk/gvc3syt28u8DhVqSGIh8eqOnCif8/wacJs4wjOMX8TT6hXx/QbRS6xAcRg1RyoU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730715812; c=relaxed/simple;
	bh=xXnK4wyCLW6B4zYg5zKgVVrYbGU0mGsraqtFSD+bG/M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RUvV2FUdb3EYqvlAM+ZumtYXdpeNAkqLjvd6rPE52fr/FHIfEo2V3f0mGir/i348zxDA+2LvgmnWFidJzjD6riZH6QhX9wYp7ky6I77HEJ8dYUn8SBa0Mvd9W7Wk7Wcs+CHOSuScHDEKPgKtXDHkZXjw1Pq94v4vymggKSwB19o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=okLvkr6q; arc=fail smtp.client-ip=40.107.93.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rgO1ldc/919G7JCFlo0GioJH6pe7dEmH0466kQ7cN5LXTQ3+9Bosmdrh7Q1EROYpUQ+dtyQQxqne1iG4qd74DzG2OJW03HCvgSTrZkdr8Gn35wh5IwhsiM3P3WVv/s9wXrE68XsOlEjw1HOy4zVoBKSj9rrpNcXziZ57aT/rkN888Yzq/x6eKDfjdehovGUB7V0jciSNm6RcdkutEt+nLTJgg7H4yULBxgtrPLdgdKMCDUvkRlZACGc/SJT5VeL3g83fNP9BwEvXZsP/2bjBfE9OQOm9tpLnv/S/GuTo62YDeK+rvVwlb/+z44WPA3uWr58eSNEhJ+Eqf0NFvDexRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c/eEMc1yTmqCQTj29SdIE5Wes+ibDm4IGTy2jmryYNA=;
 b=GyFVa3Rvtr2nJKAK0roEYf4jEkpHewDIELfLqwbqz2A3xJ2lokbOLfJo4ZKukqWsQ5ryW8Ips24Nz9n0AJBiJCTPNfltsikSS2j0q57fqcgNmOLwtN6/a+NyMURfjp5ldSW7JfZPj4194k2bj/MEi4iPSXUveM/tdMfD26+Ye0QcZ++PcaAbggSJM4mufMmqrP2VEjbFJWlmybpt5No4YZiz9GhgzEIIqyrpw/o3OpYWkeb5/u3pfgbo34mVXBJwelmBNz+PfV5sUfR8faNE8+otAw2f1osGOMym9aqwKTXyGCRkhKKqz8J1nTDppJ0JD2Oph9pVKyXbGo6Z0ILmog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c/eEMc1yTmqCQTj29SdIE5Wes+ibDm4IGTy2jmryYNA=;
 b=okLvkr6q4G5pPPWTKQZQ1JxSL3oR0xZdnqHoRTaAXlISNWaKYXL4wa504K7lxT7psHnZyfpqkaQyIhn8NyWkHrsqvxb98rAjV/LsM1pcgjlHmfh0CKM1yy8WwMOuzcKpmQOr+thY6Ij3hy29wU8JVGWdIv+zR79nKO5V+g9peHmyoiMXi/xpGFak23VY3+/u0bxeNSXzJGdLWpQ2nTUtoWxRtUqhEijRspCw/yWx/7LHHIlUoW0iaKo0eItwmffdVpjoAefcW+IVwbbyk1NUHsKk+bdE2G6QhPiHo7mAFYBol5W663dDClc8DScFgTJrCMDr5UtcgfzQMGqFV7w5Ug==
Received: from BN9PR03CA0766.namprd03.prod.outlook.com (2603:10b6:408:13a::21)
 by PH8PR12MB7136.namprd12.prod.outlook.com (2603:10b6:510:22b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Mon, 4 Nov
 2024 10:23:25 +0000
Received: from BN1PEPF0000468D.namprd05.prod.outlook.com
 (2603:10b6:408:13a:cafe::73) by BN9PR03CA0766.outlook.office365.com
 (2603:10b6:408:13a::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30 via Frontend
 Transport; Mon, 4 Nov 2024 10:23:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN1PEPF0000468D.mail.protection.outlook.com (10.167.243.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.17 via Frontend Transport; Mon, 4 Nov 2024 10:23:24 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 4 Nov 2024
 02:23:17 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Mon, 4 Nov 2024 02:23:17 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Mon, 4 Nov 2024 02:23:14 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH V1 vfio 4/7] virtio-pci: Introduce APIs to execute device parts admin commands
Date: Mon, 4 Nov 2024 12:21:28 +0200
Message-ID: <20241104102131.184193-5-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20241104102131.184193-1-yishaih@nvidia.com>
References: <20241104102131.184193-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468D:EE_|PH8PR12MB7136:EE_
X-MS-Office365-Filtering-Correlation-Id: 182f003a-4264-4246-4b89-08dcfcbab770
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9o1j1iINQXILFiwUU33WuajFaaPsVYXKJc2H3QWzmWs3XiZ0OCKWy0+YZ4kO?=
 =?us-ascii?Q?fLO9Ji+ZsuhtWiH/AC5nF9LHxRrOG3PXQFB/wOFIjYAAnzFhyQ10AakuZREs?=
 =?us-ascii?Q?F8M4TE3geCNVCDcxqMABopg3PhBwNxuIGmfNYzAQ+nJFhzU40ZVMy8Qsw6Or?=
 =?us-ascii?Q?QyyIM2uOmTkUrawZq52VJjLg3iQoHcIEzLvpkrV++TAdvmBL/8spFlkyT6mt?=
 =?us-ascii?Q?Rw9lIT3MNB226Qu9wjEF4j0mzQGtjCMRsF2awV2aOv/X1RmAyYXQMBJeditu?=
 =?us-ascii?Q?UbB98+G/6HpfABx/BJq31TWh6JdW6zqSHKUexPWmmBE4xESh/GBBK8uhW4GY?=
 =?us-ascii?Q?zF0Y+tJYMgxQiJEzTX8G/bWrBtFqSQ0P1BwlpQzTjGzDsBqc5k4PqIwdchLp?=
 =?us-ascii?Q?4J2YEKmi1Oe90uOtKBH8qwGs2cph8f/4wDJlOJx8aDgTFqZ5xScb/+mqqxrM?=
 =?us-ascii?Q?GcD/vl3KWvAyIpERcJt8ESAT245nksAXLlh9HFIqwZXCjMDoAi2emK8GiOP7?=
 =?us-ascii?Q?CeQkUXcQDSPRo7199nu9kOJIm5+tQnlTLTwQsefPjPxfbb1UB127jc7Z75E8?=
 =?us-ascii?Q?YcOWS/zhXh1zFYj4TtFZzBB7P0bKpOL6AhUva45VnEdU+2vx8M6NuPWfttwT?=
 =?us-ascii?Q?rGQ9BYoELHlFsD5WBCYduMunI979HXLThlFNDC3auivc5uSiFQfNpY4edhhg?=
 =?us-ascii?Q?eXpydsDyQruTzyu7zuYu9d+9qev5ZJWdHDkWaL5IcTudx88EjMwDT0SWr2oB?=
 =?us-ascii?Q?WhVyylqazrIz890IiSdjjbcUNadi7GK2OF2zKr0cnP4Q86UMsSnIhUGETJ26?=
 =?us-ascii?Q?gAXRFCjt1IRQHb3EJ+r/LGn9g38hHXVqt9RlhKznTs/FxwgnhEdL+ZUZ9xn1?=
 =?us-ascii?Q?X8Ro9dfbHKV3nWxPdB5Ws/xA0qvNiHozlbY2mwAqp9/zxGvEwDKJk9+LRU6H?=
 =?us-ascii?Q?48Z2nx9wQ9FyWUy8m8tRaImmQjtbvvSjGlYi21z9QOJbBGbAvCJ4qUFNUyvj?=
 =?us-ascii?Q?VptH8gQ7LfZ2rT+ctApZWqOr3L6VSav/uLS37wLX03TAv1wcsrpo//sRdo7d?=
 =?us-ascii?Q?3ARlFKxBU9ShQpgRTI90mTlyni1x69gsq924IVbEIORO5R9RPqJr/2Llks+a?=
 =?us-ascii?Q?/Ve9gIA7+gUwE8sc2KdTl3KgazLH8VD500MYaamsr008T35vUaoqP/f64rQ4?=
 =?us-ascii?Q?72DKvQ7lC50TDBVuY4fyLonXI3UdbD12+X2W4kV+8pdePj2kq5dbQQkmx5Lq?=
 =?us-ascii?Q?x3LBokPbb2AHi3T9HKkQalN0agmUzCKGSdPTkWofm8VSVH9UmHTlqWB4k8ck?=
 =?us-ascii?Q?O9ioU0WujWEXGj0fBQdHyBwM359F4MVS0fvrcO/h+AzqfaaQRkwv5nsnbzKP?=
 =?us-ascii?Q?n4o1E6lF6Xqb601tLkWoKfN8cpP3HTvxirt2tgp9k7RrrmiolA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2024 10:23:24.9599
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 182f003a-4264-4246-4b89-08dcfcbab770
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000468D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7136

Introduce APIs to handle the execution of device parts admin commands.

These APIs cover functionalities such as mode setting, object creation
and destruction, and operations like parts get/set and metadata
retrieval.

These APIs will be utilized in upcoming patches within this series.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/virtio/virtio_pci_common.h |   8 +-
 drivers/virtio/virtio_pci_modern.c | 348 +++++++++++++++++++++++++++++
 include/linux/virtio_pci_admin.h   |  11 +
 3 files changed, 366 insertions(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
index 04b1d17663b3..0d00740cca07 100644
--- a/drivers/virtio/virtio_pci_common.h
+++ b/drivers/virtio/virtio_pci_common.h
@@ -173,7 +173,13 @@ struct virtio_device *virtio_pci_vf_get_pf_dev(struct pci_dev *pdev);
 #define VIRTIO_DEV_PARTS_ADMIN_CMD_BITMAP \
 	(BIT_ULL(VIRTIO_ADMIN_CMD_CAP_ID_LIST_QUERY) | \
 	 BIT_ULL(VIRTIO_ADMIN_CMD_DRIVER_CAP_SET) | \
-	 BIT_ULL(VIRTIO_ADMIN_CMD_DEVICE_CAP_GET))
+	 BIT_ULL(VIRTIO_ADMIN_CMD_DEVICE_CAP_GET) | \
+	 BIT_ULL(VIRTIO_ADMIN_CMD_RESOURCE_OBJ_CREATE) | \
+	 BIT_ULL(VIRTIO_ADMIN_CMD_RESOURCE_OBJ_DESTROY) | \
+	 BIT_ULL(VIRTIO_ADMIN_CMD_DEV_PARTS_METADATA_GET) | \
+	 BIT_ULL(VIRTIO_ADMIN_CMD_DEV_PARTS_GET) | \
+	 BIT_ULL(VIRTIO_ADMIN_CMD_DEV_PARTS_SET) | \
+	 BIT_ULL(VIRTIO_ADMIN_CMD_DEV_MODE_SET))
 
 /* Unlike modern drivers which support hardware virtio devices, legacy drivers
  * assume software-based devices: e.g. they don't use proper memory barriers
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index 8ddac2829bc8..3f5aba71cfde 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/delay.h>
+#include <linux/virtio_pci_admin.h>
 #define VIRTIO_PCI_NO_LEGACY
 #define VIRTIO_RING_NO_LEGACY
 #include "virtio_pci_common.h"
@@ -875,6 +876,353 @@ static bool vp_get_shm_region(struct virtio_device *vdev,
 	return true;
 }
 
+/*
+ * virtio_pci_admin_has_dev_parts - Checks whether the device parts
+ * functionality is supported
+ * @pdev: VF pci_dev
+ *
+ * Returns true on success.
+ */
+bool virtio_pci_admin_has_dev_parts(struct pci_dev *pdev)
+{
+	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
+	struct virtio_pci_device *vp_dev;
+
+	if (!virtio_dev)
+		return false;
+
+	if (!virtio_has_feature(virtio_dev, VIRTIO_F_ADMIN_VQ))
+		return false;
+
+	vp_dev = to_vp_device(virtio_dev);
+
+	if (!((vp_dev->admin_vq.supported_cmds & VIRTIO_DEV_PARTS_ADMIN_CMD_BITMAP) ==
+		VIRTIO_DEV_PARTS_ADMIN_CMD_BITMAP))
+		return false;
+
+	return vp_dev->admin_vq.max_dev_parts_objects;
+}
+EXPORT_SYMBOL_GPL(virtio_pci_admin_has_dev_parts);
+
+/*
+ * virtio_pci_admin_mode_set - Sets the mode of a member device
+ * @pdev: VF pci_dev
+ * @flags: device mode's flags
+ *
+ * Note: caller must serialize access for the given device.
+ * Returns 0 on success, or negative on failure.
+ */
+int virtio_pci_admin_mode_set(struct pci_dev *pdev, u8 flags)
+{
+	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
+	struct virtio_admin_cmd_dev_mode_set_data *data;
+	struct virtio_admin_cmd cmd = {};
+	struct scatterlist data_sg;
+	int vf_id;
+	int ret;
+
+	if (!virtio_dev)
+		return -ENODEV;
+
+	vf_id = pci_iov_vf_id(pdev);
+	if (vf_id < 0)
+		return vf_id;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	data->flags = flags;
+	sg_init_one(&data_sg, data, sizeof(*data));
+	cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_DEV_MODE_SET);
+	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
+	cmd.group_member_id = cpu_to_le64(vf_id + 1);
+	cmd.data_sg = &data_sg;
+	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
+
+	kfree(data);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(virtio_pci_admin_mode_set);
+
+/*
+ * virtio_pci_admin_obj_create - Creates an object for a given type and operation,
+ * following the max objects that can be created for that request.
+ * @pdev: VF pci_dev
+ * @obj_type: Object type
+ * @operation_type: Operation type
+ * @obj_id: Output unique object id
+ *
+ * Note: caller must serialize access for the given device.
+ * Returns 0 on success, or negative on failure.
+ */
+int virtio_pci_admin_obj_create(struct pci_dev *pdev, u16 obj_type, u8 operation_type,
+				u32 *obj_id)
+{
+	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
+	u16 data_size = sizeof(struct virtio_admin_cmd_resource_obj_create_data);
+	struct virtio_admin_cmd_resource_obj_create_data *obj_create_data;
+	struct virtio_resource_obj_dev_parts obj_dev_parts = {};
+	struct virtio_pci_admin_vq *avq;
+	struct virtio_admin_cmd cmd = {};
+	struct scatterlist data_sg;
+	void *data;
+	int id = -1;
+	int vf_id;
+	int ret;
+
+	if (!virtio_dev)
+		return -ENODEV;
+
+	vf_id = pci_iov_vf_id(pdev);
+	if (vf_id < 0)
+		return vf_id;
+
+	if (obj_type != VIRTIO_RESOURCE_OBJ_DEV_PARTS)
+		return -EOPNOTSUPP;
+
+	if (operation_type != VIRTIO_RESOURCE_OBJ_DEV_PARTS_TYPE_GET &&
+	    operation_type != VIRTIO_RESOURCE_OBJ_DEV_PARTS_TYPE_SET)
+		return -EINVAL;
+
+	avq = &to_vp_device(virtio_dev)->admin_vq;
+	if (!avq->max_dev_parts_objects)
+		return -EOPNOTSUPP;
+
+	id = ida_alloc_range(&avq->dev_parts_ida, 0,
+			     avq->max_dev_parts_objects - 1, GFP_KERNEL);
+	if (id < 0)
+		return id;
+
+	*obj_id = id;
+	data_size += sizeof(obj_dev_parts);
+	data = kzalloc(data_size, GFP_KERNEL);
+	if (!data) {
+		ret = -ENOMEM;
+		goto end;
+	}
+
+	obj_create_data = data;
+	obj_create_data->hdr.type = cpu_to_le16(obj_type);
+	obj_create_data->hdr.id = cpu_to_le32(*obj_id);
+	obj_dev_parts.type = operation_type;
+	memcpy(obj_create_data->resource_obj_specific_data, &obj_dev_parts,
+	       sizeof(obj_dev_parts));
+	sg_init_one(&data_sg, data, data_size);
+	cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_RESOURCE_OBJ_CREATE);
+	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
+	cmd.group_member_id = cpu_to_le64(vf_id + 1);
+	cmd.data_sg = &data_sg;
+	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
+
+	kfree(data);
+end:
+	if (ret)
+		ida_free(&avq->dev_parts_ida, id);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(virtio_pci_admin_obj_create);
+
+/*
+ * virtio_pci_admin_obj_destroy - Destroys an object of a given type and id
+ * @pdev: VF pci_dev
+ * @obj_type: Object type
+ * @id: Object id
+ *
+ * Note: caller must serialize access for the given device.
+ * Returns 0 on success, or negative on failure.
+ */
+int virtio_pci_admin_obj_destroy(struct pci_dev *pdev, u16 obj_type, u32 id)
+{
+	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
+	struct virtio_admin_cmd_resource_obj_cmd_hdr *data;
+	struct virtio_pci_device *vp_dev;
+	struct virtio_admin_cmd cmd = {};
+	struct scatterlist data_sg;
+	int vf_id;
+	int ret;
+
+	if (!virtio_dev)
+		return -ENODEV;
+
+	vf_id = pci_iov_vf_id(pdev);
+	if (vf_id < 0)
+		return vf_id;
+
+	if (obj_type != VIRTIO_RESOURCE_OBJ_DEV_PARTS)
+		return -EINVAL;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	data->type = cpu_to_le16(obj_type);
+	data->id = cpu_to_le32(id);
+	sg_init_one(&data_sg, data, sizeof(*data));
+	cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_RESOURCE_OBJ_DESTROY);
+	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
+	cmd.group_member_id = cpu_to_le64(vf_id + 1);
+	cmd.data_sg = &data_sg;
+	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
+	if (!ret) {
+		vp_dev = to_vp_device(virtio_dev);
+		ida_free(&vp_dev->admin_vq.dev_parts_ida, id);
+	}
+
+	kfree(data);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(virtio_pci_admin_obj_destroy);
+
+/*
+ * virtio_pci_admin_dev_parts_metadata_get - Gets the metadata of the device parts
+ * identified by the below attributes.
+ * @pdev: VF pci_dev
+ * @obj_type: Object type
+ * @id: Object id
+ * @metadata_type: Metadata type
+ * @out: Upon success holds the output for 'metadata type size'
+ *
+ * Note: caller must serialize access for the given device.
+ * Returns 0 on success, or negative on failure.
+ */
+int virtio_pci_admin_dev_parts_metadata_get(struct pci_dev *pdev, u16 obj_type,
+					    u32 id, u8 metadata_type, u32 *out)
+{
+	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
+	struct virtio_admin_cmd_dev_parts_metadata_result *result;
+	struct virtio_admin_cmd_dev_parts_metadata_data *data;
+	struct scatterlist data_sg, result_sg;
+	struct virtio_admin_cmd cmd = {};
+	int vf_id;
+	int ret;
+
+	if (!virtio_dev)
+		return -ENODEV;
+
+	if (metadata_type != VIRTIO_ADMIN_CMD_DEV_PARTS_METADATA_TYPE_SIZE)
+		return -EOPNOTSUPP;
+
+	vf_id = pci_iov_vf_id(pdev);
+	if (vf_id < 0)
+		return vf_id;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	result = kzalloc(sizeof(*result), GFP_KERNEL);
+	if (!result) {
+		ret = -ENOMEM;
+		goto end;
+	}
+
+	data->hdr.type = cpu_to_le16(obj_type);
+	data->hdr.id = cpu_to_le32(id);
+	data->type = metadata_type;
+	sg_init_one(&data_sg, data, sizeof(*data));
+	sg_init_one(&result_sg, result, sizeof(*result));
+	cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_DEV_PARTS_METADATA_GET);
+	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
+	cmd.group_member_id = cpu_to_le64(vf_id + 1);
+	cmd.data_sg = &data_sg;
+	cmd.result_sg = &result_sg;
+	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
+	if (!ret)
+		*out = le32_to_cpu(result->parts_size.size);
+
+	kfree(result);
+end:
+	kfree(data);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(virtio_pci_admin_dev_parts_metadata_get);
+
+/*
+ * virtio_pci_admin_dev_parts_get - Gets the device parts identified by the below attributes.
+ * @pdev: VF pci_dev
+ * @obj_type: Object type
+ * @id: Object id
+ * @get_type: Get type
+ * @res_sg: Upon success holds the output result data
+ * @res_size: Upon success holds the output result size
+ *
+ * Note: caller must serialize access for the given device.
+ * Returns 0 on success, or negative on failure.
+ */
+int virtio_pci_admin_dev_parts_get(struct pci_dev *pdev, u16 obj_type, u32 id,
+				   u8 get_type, struct scatterlist *res_sg,
+				   u32 *res_size)
+{
+	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
+	struct virtio_admin_cmd_dev_parts_get_data *data;
+	struct scatterlist data_sg;
+	struct virtio_admin_cmd cmd = {};
+	int vf_id;
+	int ret;
+
+	if (!virtio_dev)
+		return -ENODEV;
+
+	if (get_type != VIRTIO_ADMIN_CMD_DEV_PARTS_GET_TYPE_ALL)
+		return -EOPNOTSUPP;
+
+	vf_id = pci_iov_vf_id(pdev);
+	if (vf_id < 0)
+		return vf_id;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	data->hdr.type = cpu_to_le16(obj_type);
+	data->hdr.id = cpu_to_le32(id);
+	data->type = get_type;
+	sg_init_one(&data_sg, data, sizeof(*data));
+	cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_DEV_PARTS_GET);
+	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
+	cmd.group_member_id = cpu_to_le64(vf_id + 1);
+	cmd.data_sg = &data_sg;
+	cmd.result_sg = res_sg;
+	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
+	if (!ret)
+		*res_size = cmd.result_sg_size;
+
+	kfree(data);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(virtio_pci_admin_dev_parts_get);
+
+/*
+ * virtio_pci_admin_dev_parts_set - Sets the device parts identified by the below attributes.
+ * @pdev: VF pci_dev
+ * @data_sg: The device parts data, its layout follows struct virtio_admin_cmd_dev_parts_set_data
+ *
+ * Note: caller must serialize access for the given device.
+ * Returns 0 on success, or negative on failure.
+ */
+int virtio_pci_admin_dev_parts_set(struct pci_dev *pdev, struct scatterlist *data_sg)
+{
+	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
+	struct virtio_admin_cmd cmd = {};
+	int vf_id;
+
+	if (!virtio_dev)
+		return -ENODEV;
+
+	vf_id = pci_iov_vf_id(pdev);
+	if (vf_id < 0)
+		return vf_id;
+
+	cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_DEV_PARTS_SET);
+	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
+	cmd.group_member_id = cpu_to_le64(vf_id + 1);
+	cmd.data_sg = data_sg;
+	return vp_modern_admin_cmd_exec(virtio_dev, &cmd);
+}
+EXPORT_SYMBOL_GPL(virtio_pci_admin_dev_parts_set);
+
 static const struct virtio_config_ops virtio_pci_config_nodev_ops = {
 	.get		= NULL,
 	.set		= NULL,
diff --git a/include/linux/virtio_pci_admin.h b/include/linux/virtio_pci_admin.h
index f4a100a0fe2e..dffc92c17ad2 100644
--- a/include/linux/virtio_pci_admin.h
+++ b/include/linux/virtio_pci_admin.h
@@ -20,4 +20,15 @@ int virtio_pci_admin_legacy_io_notify_info(struct pci_dev *pdev,
 					   u64 *bar_offset);
 #endif
 
+bool virtio_pci_admin_has_dev_parts(struct pci_dev *pdev);
+int virtio_pci_admin_mode_set(struct pci_dev *pdev, u8 mode);
+int virtio_pci_admin_obj_create(struct pci_dev *pdev, u16 obj_type, u8 operation_type,
+				u32 *obj_id);
+int virtio_pci_admin_obj_destroy(struct pci_dev *pdev, u16 obj_type, u32 id);
+int virtio_pci_admin_dev_parts_metadata_get(struct pci_dev *pdev, u16 obj_type,
+					    u32 id, u8 metadata_type, u32 *out);
+int virtio_pci_admin_dev_parts_get(struct pci_dev *pdev, u16 obj_type, u32 id,
+				   u8 get_type, struct scatterlist *res_sg, u32 *res_size);
+int virtio_pci_admin_dev_parts_set(struct pci_dev *pdev, struct scatterlist *data_sg);
+
 #endif /* _LINUX_VIRTIO_PCI_ADMIN_H */
-- 
2.27.0


