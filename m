Return-Path: <kvm+bounces-29758-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 598539B1D1C
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2024 11:09:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 788741C20939
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2024 10:09:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5515C13D601;
	Sun, 27 Oct 2024 10:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KJCJcwuB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2040.outbound.protection.outlook.com [40.107.244.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF9F13C3F6
	for <kvm@vger.kernel.org>; Sun, 27 Oct 2024 10:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730023739; cv=fail; b=roZ8P9czHb8HYaHevVmh/lTPgMuTtJ31fMID1tqLAwRBRZ9Z81ze73OoUDYn2LUlrDF/0flGq8yYHpE5UI2oyUPTqYAWk4/9FoOQeNY/EYcPY8nJ0EN6bo0fX3qy14Q+qOy2aIyg8fAeeOFYMtLBB/ZidYwQymqPmNz2puf+6lc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730023739; c=relaxed/simple;
	bh=xXnK4wyCLW6B4zYg5zKgVVrYbGU0mGsraqtFSD+bG/M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DOE+iqw4uK97Jwg+cZbBhOYUYQCgsW2sfc2/8T8VK8a3V6aZqn1GB4R6AEqEeRCmPjUEddUwzwEXpuhuAKsfQh6VjQlVenuGM3zlVLfMyhrJ8mplVAgyKIorkSfRp8ghzjtwMWinvC1Aa/roYI1TT5ypZAF+M9mkf8WeKKDK+SU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KJCJcwuB; arc=fail smtp.client-ip=40.107.244.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ho5eAU3r/74LFwJAzIQHy6JwZVBBpxYRio8vbGC3xoumRF6L9QY/JpCPsw9lMhyUeP9M1CmdpKSfA1dfYGErYn39mTcHwDynjQH8vD7wfz3ubS0mHpi1cKinr1bSvjXSjBXImIXEs3zot38APFpRdhKVKvWBGQArkqerOnAlwApWrh/uMd8uJNOw9rFRUWf0cWhCcBhSAKnKN+yGYgeAhrzU7gnVVdlo3G7dYsi5C9GktvgST5oTovOkytEf3K8e9Q2maqazy6cT6n4GJSuBY8ytqhwrBg8zcrLT/BjAl830rVSYMVg309le1CsW13tAOCvydVxnybCI3tgHSr9dCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c/eEMc1yTmqCQTj29SdIE5Wes+ibDm4IGTy2jmryYNA=;
 b=gNzPnjIjlbGisQMHr7N3jh08CxvviPXldZAVnoB6PKnL6AbXb0AmKnqdN1Ec9qFeCT7e+11fF3DnYR6Pp8GDW8FdRYDpF0Odq65Nkzv0R0rNDjzKQaXHPw5tcYGHbMpfIusGc0I8DqoeXQGQh1oqgITQjIxmvZeHzsUj1Hg1sFRJ5KpErEdOK2FSa2wwCSZZ8VHuqiWDQy2nltE8RX9k4gbhSzDpyagGI3wkTyd9sS6nnMXhpa1MflLbWyqcNmo9Y8kWXPgHZWv3q3ruAmbRBKtX1i1ZbjNm04MpNkTy+L9KcDDx4rNxHG0FpiGErq/3URO2wNpfmhBEbT4e6zyHQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c/eEMc1yTmqCQTj29SdIE5Wes+ibDm4IGTy2jmryYNA=;
 b=KJCJcwuBxgm8wX1uPGsCllZRddlg4gptoT2LiyVCQJ4CBNuUmC07VoBZ/lfLivJ8xbc2yrMQI0LVhkzEMzkGbpmROXY4EJ8IMYxMHta+/823qzdw2ITx8gIIyv9HfsZnj1dQQpoHARYEgvT+ZQNUPdpAnb9sqU9u4DlLTtKtsNsSvrNP/pfNyoue28F+pj8QtrP/OixCKahqjALpLdgDlZf29HbFDnORwcj5HTECyF5B85X78pttEvpW2TsWsmn+JZ3o6/U9phJ0K6onhhKtiAqyzj9PjGiK/RuJfjxoOdknNS5+XfkLgGfgocgQimXYQBrcay1fkGGZnBua5NgcEA==
Received: from BN8PR07CA0005.namprd07.prod.outlook.com (2603:10b6:408:ac::18)
 by DM4PR12MB6447.namprd12.prod.outlook.com (2603:10b6:8:bf::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.25; Sun, 27 Oct
 2024 10:08:51 +0000
Received: from BN2PEPF000055E1.namprd21.prod.outlook.com
 (2603:10b6:408:ac:cafe::9b) by BN8PR07CA0005.outlook.office365.com
 (2603:10b6:408:ac::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.23 via Frontend
 Transport; Sun, 27 Oct 2024 10:08:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF000055E1.mail.protection.outlook.com (10.167.245.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.0 via Frontend Transport; Sun, 27 Oct 2024 10:08:50 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 27 Oct
 2024 03:08:35 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 27 Oct
 2024 03:08:34 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.1544.4 via Frontend Transport; Sun, 27 Oct
 2024 03:08:31 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH vfio 4/7] virtio-pci: Introduce APIs to execute device parts admin commands
Date: Sun, 27 Oct 2024 12:07:48 +0200
Message-ID: <20241027100751.219214-5-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20241027100751.219214-1-yishaih@nvidia.com>
References: <20241027100751.219214-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000055E1:EE_|DM4PR12MB6447:EE_
X-MS-Office365-Filtering-Correlation-Id: 25644de2-8671-4107-bade-08dcf66f5b1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uaax1Ry3Sr8QIyOPV8/W5NYp8+nEjsCMsOS/H4/onWEuYJtzW3mqFMdHLlaX?=
 =?us-ascii?Q?VyCLXMTUrdPy6SerfJaH5tdsItmvM3R3t3kRLe1F9V5SNCB/zCMTnAENluSV?=
 =?us-ascii?Q?sL4J2XtA1KQcdc8TfgcwySJ379Pm6jmHllDCLENPt5zPGr0YNrmC4bfGQ+jg?=
 =?us-ascii?Q?cz5iqlmKiRtasEEVTXnP4H8X02pu9SqAbPjt39rIzUCT3OkTPp78ha6dXur1?=
 =?us-ascii?Q?DSp+jEQRjk9KQMdosb5DcNzXAsTYkgQvOvITvdGXqS5nDqqVEyBfYU29QG46?=
 =?us-ascii?Q?NpmNP2MPutN4ovsXmMugYCzVA7Nx5CrfIHY36ORKLZNn0gZJ/zpJ2MYwWAbz?=
 =?us-ascii?Q?htJzzsZThqD3XkBYQT+IEbbyu9lEMvEuG5NFniI3i7NlSLJqELQ7fEvh7THd?=
 =?us-ascii?Q?SMT/Q9B6fCUZxXI4ZjeVTXVlqUJcKxJVnt7MS/0xi1Zuh1xVXzJ4dqmIKYVI?=
 =?us-ascii?Q?LrX0PmKfv6zgb+0maHkgxg2iKfXCK4/cUjzHJKefd1Eic1RW87EfxP6QP5bc?=
 =?us-ascii?Q?4IiaH4A87tWdAmjOyY60pqLhsnObmIxLWAEm6IaC+7sAcTda3ZSLpDZebh2O?=
 =?us-ascii?Q?3E9OeYShp1zO6fnGsVvRY/lecxPO6T4nlQ1qtYRLCWcJntnTQMsFrlboDIyA?=
 =?us-ascii?Q?0aTkOGCYXlexZqXA3Vqi3OmsNA8OdgGIR6SmL5+Tc4lB+vaYLhiMmtkcQ6nd?=
 =?us-ascii?Q?haSUiKtaP1f/9R0S7UeB2dhL9OpXtD2vGHaU3CQNbLiqhoA7tWQZsQcA9N/I?=
 =?us-ascii?Q?e35p6RA1clSpoGZIui5+010XXvcoaNXQPHGnIaEXYTksWjGw7Voi5jXi0Yrz?=
 =?us-ascii?Q?82/kAOZifxjBv+dFENqeZYBGpK+GalvlSji0DggaIwKkDjbHb2HqlEHERTI0?=
 =?us-ascii?Q?P7LOUPFCWMazPlUc1pVA8xegAj3HeL/gXdtNNwBfE0vBNXYaS4nhQDRin4Rq?=
 =?us-ascii?Q?VsR8AXJsSjEUK+YwuVLnQB3SUfLvX3aipCuTQBL2BHqXBtJDyOP268GSHQ0u?=
 =?us-ascii?Q?dopCCcFd6rh431Uio6aCvWU4WM82v/wQPfWGXz4702fd5eYRgZVO66m6o3vJ?=
 =?us-ascii?Q?WWHl42I61BqbJaLc0xcZFplDDSOGCg3omX+kfXTXTR58T1/GawhrCBBcaHhe?=
 =?us-ascii?Q?wutiyMxbhBtKUih+qux6CnE7k0RZ6bF9H4yfOU3swUHqbFd0F2u3xbweeCYV?=
 =?us-ascii?Q?ZLJngqJPEaILScHk5jYRtqj50rB94AhkO5umcAvIDpJEaekN2C6EvPuJlZfp?=
 =?us-ascii?Q?2kBLdx7JTKVhD/JqwikHpnLiENXekDy27BW+0WA3mJKVK/TZ7Ri1JZpi8oha?=
 =?us-ascii?Q?3QPwgfU0gWYad1dcASdomRo/xiOhbNf4wpTiQK5urJ5rAfUDkP6Amkl/lt4L?=
 =?us-ascii?Q?qGhXTVMqkMAdj+wXezGQjlapXIhLIDKC4clT/tTWdZriL4rmNg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2024 10:08:50.7861
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 25644de2-8671-4107-bade-08dcf66f5b1a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055E1.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6447

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


