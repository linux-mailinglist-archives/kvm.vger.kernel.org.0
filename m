Return-Path: <kvm+bounces-31594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C7509C50F9
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 09:42:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0CD112839B2
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 08:42:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F01220E305;
	Tue, 12 Nov 2024 08:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="C9wM2+75"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2067.outbound.protection.outlook.com [40.107.223.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E9920DD40
	for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 08:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731400732; cv=fail; b=uzwGw3tRB1Qf/noBMauKiMefz3Va9YllMl2NqJ/b5kTcd6Qs5zbRrcrL9VOH9DCy7PJ5zmxxEEhB7rFu9cl21Ezl1cmX3DnMWyyhFxDf6wn+DLe7OKVNBXJDKeUcUa58JewQKKnVZVXyYZ9zzFqQ4/Tx7mGT+jFHCwkGfsuvrDQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731400732; c=relaxed/simple;
	bh=QYGMKAMl8mTsCS6jHu129ITEZw1xUMTxBUAweAW3Gqs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hFjVee5TenDWiKPOU1yxAdm2TNGhoAfxRHY5BzRpyzbKU4XFK9FpqD9wy9zjTYuexSvf+wDH5dt7KmeIwFrzXbRJs2rn9UsRT1gN0ZP9BWAY9oMN5y3cpTvvVW1cchJu5mUtTrzAvQa60+FTttDQ2znSpOVab7PWFuHOfE6Gkic=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=C9wM2+75; arc=fail smtp.client-ip=40.107.223.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t0s9TzNnFt8K505mA6aBD/Rs0qFlUWODKXe5CEufq8oTCZkzrC6LzgY8cV11snGXsub1LmAoFGJ0JtLap5f78CocimKntOMEJ5Rsp6J25jr+PLag+8gm3dAvMzVQ1AUOn1DMgfKqsFrn05niIAbilvlWvnRl/+9L3GFM/ixtpLdUTP+SnDg6Mm2V3U8A3dhilEgrq0CsAdZjAZ67Avhb2ANgVPYmGIa1ooLHQEqCgenAHEtlneQoMDUYXIiwOCgf8QQzdCFYaz8ic2IgSgvNl3bcPRva4rIkgpQF0P+KCIJ9nbYJ7ED1RT17dTsNw0088INnq+eg95FnkTr3wKot5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AnmjS5Ws8pOTnu3tw1SCuin/i2X1p8HKm4b/6Fk3VPM=;
 b=e6OUr6eYBq9mhfKXDyGg3a/aBr4XFORu8aIaFnz1sC179fSg5JB849+cq9Mtm4Kj1nAM1FUE32IROHmFhuXYIXpIJ9Ruoqh/h2wlnU/MauXlNiRJeTnNFK+nPJaFWR+U/MGhKid6dWff9c8mEhaG4bW/IZnq/5iINJCoftxWJmBaEO5dEV8HsFOLyCiLk/Dz4DXPqywUtslD+iOTM30tMyHtru/Z4yx0oMlHe9Ddnu6A1lm73gXKJRZ1uuNIpJAvoYciJ8fjR7aYPYNojHemt5y1RRhq9tTfR8J/rZ/Np8ZXcu7WJs2h1s4pprB+5oBFceZwoLGhI4sK1SGJUx7AsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AnmjS5Ws8pOTnu3tw1SCuin/i2X1p8HKm4b/6Fk3VPM=;
 b=C9wM2+75Mr0HBouy5dKZqLstll71qBTAu9p7zIL8Ar75m5HRdBBh8M+lv5Ra6ONrwmojlbvHdRy4MxafDLPUc/QFo1QZIryrKkCl9+l7eVQjL6/XH4niQD5DRiBXQRAH0SX3ui4uTkK7KIP0o4b5jP1Fqzo6J0bkPd2PN2x+AqrOJdLuBuGzS8Kf1xO4faBn6sliBx0NRl+2G0aADR5qq+jbBWWeAgY5vZOnxIr9W+2PDvLRyiAjNLcobcs7fWHNOWxFnmNElZPgcgpkz44SDh3AGakzGF3oui8LqK/GhoHeaApyxlr0vZz1bGHM6WQyVnYSkWA2RhLnvVuklGmxgQ==
Received: from DM6PR06CA0060.namprd06.prod.outlook.com (2603:10b6:5:54::37) by
 SJ2PR12MB7963.namprd12.prod.outlook.com (2603:10b6:a03:4c1::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.30; Tue, 12 Nov 2024 08:38:47 +0000
Received: from DS1PEPF00017095.namprd03.prod.outlook.com
 (2603:10b6:5:54:cafe::a1) by DM6PR06CA0060.outlook.office365.com
 (2603:10b6:5:54::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28 via Frontend
 Transport; Tue, 12 Nov 2024 08:38:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF00017095.mail.protection.outlook.com (10.167.17.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.14 via Frontend Transport; Tue, 12 Nov 2024 08:38:46 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 12 Nov
 2024 00:38:32 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 12 Nov
 2024 00:38:32 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.1544.4 via Frontend Transport; Tue, 12 Nov
 2024 00:38:28 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH V3 vfio 4/7] virtio-pci: Introduce APIs to execute device parts admin commands
Date: Tue, 12 Nov 2024 10:37:26 +0200
Message-ID: <20241112083729.145005-5-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017095:EE_|SJ2PR12MB7963:EE_
X-MS-Office365-Filtering-Correlation-Id: bd287d4a-dd3e-499c-6040-08dd02f56c73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sITf8lErUIQqSgt0UKe+FBt6AlEM67Jha8h8BOwc1bk21rExQNbwel+L0O0E?=
 =?us-ascii?Q?vK3p92EIOFVG0JtnpSqc28l2smdPiAOzkhDJSkkCHMpDFT3QUm5DYnw+WdZd?=
 =?us-ascii?Q?kwrW/fpph6M9kVU31SerZ3tCqPuHdQyfLusJBbCzyglsiZo0v4NR2hsxcWgx?=
 =?us-ascii?Q?FpFFQf2urVODNUIIfCtHB7W/I75YdsTfLviZKybqybKruUwbGouDGZFAQUv+?=
 =?us-ascii?Q?6W0bt+Y2pmO/eBba5dKRDS/kCDh/UC0bhIv7GOGazDORJ9gqp+LejMXLdq6P?=
 =?us-ascii?Q?kSgIzBkT1jDpWQujLGPZqh7bwMy+DuOrHTkxOSD9QnL2EXM+4zRBarFg7Vhq?=
 =?us-ascii?Q?soI6JUM27LFE7izyF4ppEb+bzMXnASrFM+n6tP4yFb8WwasQJC6DvoCm51fT?=
 =?us-ascii?Q?hs7JDdzdzixVaRRKZETGKrNItsuC7R95YEv+eNl2UTDq4CNFNJcPsweqBr7h?=
 =?us-ascii?Q?UV2y3ZvW/XBcGRqmwlvJ5/gRPYWbTNOoMmNHXxZHTMbjZelDqEzy55zGRrkO?=
 =?us-ascii?Q?UOBr56VqgneGbdQwlqFq14on3TvuAvcNytvi1A1M/XCeKLDwmF0OUxpr4AKB?=
 =?us-ascii?Q?DwZvUDBDUX+QkNX5paV2GQ9MxNhK6cA4tKqOjZmfpe/+1P74qY3fCZM3DvUE?=
 =?us-ascii?Q?2HRd9bnRV80qu7JFWDuXV/SR8Ewnw9hEFym7JmxqHYXsAIio+/7vrL9OGmKU?=
 =?us-ascii?Q?QBhDhA+z0skLiNRJWvEv3ruaHA35N77YQoeX1SOySAakyW2mmmGnlomid4kJ?=
 =?us-ascii?Q?UqClaVBQyiLGCpGkby9GusAHcdM5cpTkhNr566Jh+XLAnwq3hlFyYF5ULC5W?=
 =?us-ascii?Q?AeL7MFsqt411rA/rxZI9WtaAtJcg0iw239/fFu5jctSmmr9XX79FvIG5tJ1h?=
 =?us-ascii?Q?mccbrwnscsasIvp1eAaIyp5nlHH2j7Lbiw54L6HMs4hF4ESTNArKJQg/Pb40?=
 =?us-ascii?Q?5gMrLB5S4uZL5+hTw4xgHLNP0+E7Vo8tkx30G0jcHUBowT+yKIqHJu+RYFzZ?=
 =?us-ascii?Q?/OfvmT+ZUDYhlugDeC8OGQbu08tVSvzv0Gn99zGQKbVmVonTFvS8dol5mwaV?=
 =?us-ascii?Q?v3X+tN1usdq0Hnm1Hqg4v5sVEwk8FlhdtyOnXZBhlgI3OxbwBeyhXR1NJFUU?=
 =?us-ascii?Q?7EKJW0FFdo5CIsfVAu36RiKDMevZiWw8w29ziS+VJryxwowTwFjRLHdCcstH?=
 =?us-ascii?Q?Y2lAstaQBksaMu7n9LiYZ3qrevJSW/yVVwiIw5PTyD1lONQS11GzQS2WhOlb?=
 =?us-ascii?Q?1PumO9SjXoOCJdv3GSd2+jsOvJDh0Uzpa9AMMtklX6/P0v7tN87qrC39GoNc?=
 =?us-ascii?Q?pv9Dumwi5ziX6w9jWfkxTK1VbvFDmcvFl67UhEKN0vmgTB2sqtHlehjvi4Cl?=
 =?us-ascii?Q?M+WdEv3ksZxE/XaYv9LmfgUmR5zH9Xcf6QfDtmW0ZVchVgVTxQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 08:38:46.4659
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bd287d4a-dd3e-499c-6040-08dd02f56c73
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017095.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7963

Introduce APIs to handle the execution of device parts admin commands.

These APIs cover functionalities such as mode setting, object creation
and destruction, and operations like parts get/set and metadata
retrieval.

These APIs will be utilized in upcoming patches within this series.

Acked-by: Michael S. Tsirkin <mst@redhat.com>
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


