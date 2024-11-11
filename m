Return-Path: <kvm+bounces-31414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61DF29C39DF
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 09:43:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 22C82280CD0
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 08:43:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC7981714B9;
	Mon, 11 Nov 2024 08:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="P84Ehey4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2056.outbound.protection.outlook.com [40.107.237.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F74D170A15
	for <kvm@vger.kernel.org>; Mon, 11 Nov 2024 08:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731314577; cv=fail; b=Ctr4Po5dOF3VwcBEBt9gH+Unudc6GlPGVnrRsd+BXHzzDYD1t1nnW0CVy63kmFBMa4s+1FtYVwDwHlBatjs/c0F29gN1ipdo2OxpPBOqBI12Kj1eSWHMinMdIdySF/MEIqqRdVMUptlYFzqQnYDcW+VQfDb1n6s7Y6kCd8MSfzY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731314577; c=relaxed/simple;
	bh=pe47dxh73UgEBY28lJctp6TIcjx0lc6PM+qY4LVDV6I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fy27YmLFdOI0g3pF0bizHLZrG2g3tQ1mJE6Y87XReuAWaWtD9n8N1DFMewe7SrgS8/gElj36UyxJ/S8Cj2OcOfysG8O8q/Y99bFX2cNlSqy3m7rLi4mV4XdxJZkG3h/UIGEBvMXN89IwFHhDuAgQrCuGFNk9Q5O1lSjNn9aJR7Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=P84Ehey4; arc=fail smtp.client-ip=40.107.237.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YB3RbPejyOKWGoANCOdp3Xa+8eppSdQm4uv8KXESdZVWWj7x0686NTdGfDTUFXqEF/oAtZKHEMmq82QK/MNFSQ6rW4hwXh/IsTNEZseH50k2ZjxVz82FoFXcIqiA5CrF3jvVX6HEdOcuXR5JI4w2+P759dQedd/4fx740yHsiUuJ6xlXyIMaZfQ7RR3WFRt+GWBhFEzl5if5607YQD2mlFLWjd476ISinrFVRptqRX2v/qmbYOveZTSq+DxzA4r1EdQceDwbbAO3symVgOcGDAii5gRyCm81lRte15NEiOixyaOdvxMymOn5TMLMvxJ7uhyGhAIgLKtOb5HYyS8bsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6UH2a9AejqPu8XRAVzr+yVLeBfNdCRpTJ5IZVd8H4IU=;
 b=OhIC7UhxvLBJKrKAYFFBms6F77rPXPNpizgm/wMXNVsZkIaRvkLmv/8CDlUhgDfu++X8SsZHEW6jBMPNQT9FyW+SPThATK6vxe156Qn8+9G7iOD33nWHHT7gXh5RDm84APkCsTywq8y1kG7Oe3t+zM7rZTxfLShxqt6C53ZHNxwKtS2D14bNn2OIX1w7c8mudiKPXBmBUWhjzR5gejqu1BovoWP8W0kE2Dc4IS3VZD6rOIkBZhLb3alwPwPZAMGUPMkBcyaPDDJ4k421QiCi4dmXcSsy6HWkAPuJt40YOcDUPJhQgKs6CktJ0q49JTlkHZoRCAz+fD+hpbZQab8ejw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6UH2a9AejqPu8XRAVzr+yVLeBfNdCRpTJ5IZVd8H4IU=;
 b=P84Ehey4/j9qdTKP11sKOSfdd9JWH2tRbK0Kg2eLADFD8C+44DL2Mebs0N5vVIEaz0NeiUQn4L7mn2cys/ygSa9QxoKH1NoISYzjBaBDBY30QhkHiLG2pFBTIHGrumFALkNXDYb83A7WT0WlZgYkb9jDXiWa9UZAyh/qu9UmhBUeqUnExW5H/iTIB+ncslHvQrMca2AHjBny2PzOGWGGTIa2PovEcA5VeCcAwXOasOt6OetL331osp3KoMJS2ss0wfKHKxo9Wqwqel/xOkbWI7gZPxJR/7tWoY29qSBK0lPFJBpBbr8DpxUzjokYjI02OcHiPDowltjv9AEehoiqBw==
Received: from MW4PR03CA0121.namprd03.prod.outlook.com (2603:10b6:303:8c::6)
 by SA3PR12MB7782.namprd12.prod.outlook.com (2603:10b6:806:31c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.26; Mon, 11 Nov
 2024 08:42:51 +0000
Received: from MWH0EPF000971E8.namprd02.prod.outlook.com
 (2603:10b6:303:8c:cafe::60) by MW4PR03CA0121.outlook.office365.com
 (2603:10b6:303:8c::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28 via Frontend
 Transport; Mon, 11 Nov 2024 08:42:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MWH0EPF000971E8.mail.protection.outlook.com (10.167.243.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.14 via Frontend Transport; Mon, 11 Nov 2024 08:42:51 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 11 Nov
 2024 00:42:35 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 11 Nov
 2024 00:42:35 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.1544.4 via Frontend Transport; Mon, 11 Nov
 2024 00:42:31 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH V2 vfio 1/7] virtio_pci: Introduce device parts access commands
Date: Mon, 11 Nov 2024 10:41:51 +0200
Message-ID: <20241111084157.88044-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20241111084157.88044-1-yishaih@nvidia.com>
References: <20241111084157.88044-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E8:EE_|SA3PR12MB7782:EE_
X-MS-Office365-Filtering-Correlation-Id: c43081b5-7f5f-40fa-9dff-08dd022cd3e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cjVPSk2rrqrtDdK+3w2JwVY/lp0CUO+H/DyobGqAwk4MeejZJidoDCKMCFH9?=
 =?us-ascii?Q?cvDQSSMidTgmiaHsSoG4ozguK0mXVDwwmMWRzY3BQMc/2qoWhI43B8lo/cy+?=
 =?us-ascii?Q?z0ZVn13E2KcY3qwlIaWqVNNWgEzkzvLCR0wXqgi0wKI0nHot+CEH0VsIQo4s?=
 =?us-ascii?Q?xk8GY9r572hpp1cpcmPV+smVstkv67+mKva3UbdPQoe5Ifba9R8OcLu05s9B?=
 =?us-ascii?Q?PEvbNuG2cQt3MMUPdWiF24vzkbyDmNnD2XadFuwlr3ca6dBI0xWPoFZaSgK5?=
 =?us-ascii?Q?AjV8ypMmcSCTpmfqQz8AHh6YQDfm0MZiVxF79kqxj9ibaP5ozgzuL/hsGtnB?=
 =?us-ascii?Q?9qauX2teTrvptTiqHm3ptjs1CWmDSvVbDeONCZiWPyqX1y2b91RdaVn57d6Q?=
 =?us-ascii?Q?oZFzylBKWJJXV8ujB6GESaB25AgByOwAeaObyD+CHsk2jRL4QOQfEN1jRA01?=
 =?us-ascii?Q?IJGc4e4IBa4mDf0l/Ziy/PIAQ2iXEhyyXEIsoE1mhQoDYEU+h3WMiLIPz/qG?=
 =?us-ascii?Q?yCnCL4bE6wI2K6YraUx3YPoGdY8vB2SRrmD2xPeLkLFgpMMkxVTO74UCgPkv?=
 =?us-ascii?Q?5sUefJK+vtoLeWuGDBUQtinu9Snqfl8hp8eXMwn61eLDBuCjW7QB8d24TwM5?=
 =?us-ascii?Q?ZhQsOYJps4aKQwlYRMEXxsXlHqY9sVj+I83NPie82RFt2ezit09v3w5DgxVR?=
 =?us-ascii?Q?04S7dGnWITL8Z7uEQHuz3aNRFVOyz64FH1m+zDpdHy53V08LbGIe8ehNOM2V?=
 =?us-ascii?Q?rwkDEV4yTxdRcEITtxtBCKapQN7wUGB3kJ5J0GTwIVQxckPuA078GfmRxSKW?=
 =?us-ascii?Q?750KZ6RRsP1aL9M4D1jsCQJ0MrIUXnVSzCkXiv+D1BorzGdrxv+GO5IbtKIH?=
 =?us-ascii?Q?7/YL4dUa1hK5jzUqZbkwpVtKm0hkzcvK5yny7rpEfJffQPdOe7UdQR/XY2Cs?=
 =?us-ascii?Q?eaBQFrJu80ueaEAe6GlLLLOKvtx9LXZbs2mbVmPTQ11a5lJTOnujp1lhJl6v?=
 =?us-ascii?Q?JrOmhpV/sKR6UjusJL5WCvR4u3KXS8jIHhZDG3m9i2ZLNlMTbU140XP+VpMz?=
 =?us-ascii?Q?xjWBIcbQrpK0AUpBDMBXYPD9/Qz9kDBJIXb+1UCtuEbRizYmtHBIiMkKtjpd?=
 =?us-ascii?Q?3wA9B5rJMdpQF2nwI+q9A62eb4dWo7e+oyAD4F24uT5Qq03TaEdPJAwiw4t9?=
 =?us-ascii?Q?vXYERzIKNCvsh1sF4VEACHleEe9NGAHYjfOInCWg5qOvr8XalGucAA77mdLA?=
 =?us-ascii?Q?K28K9B+w5luJeaWmr+caDqKSbLtnCItydB8zaynECs39K1uFk293BS4/5Ga/?=
 =?us-ascii?Q?mMIkdskoZJFJLnNMsj1204xePBfuxAI8Irapzd52FZqJdZ1lX5w+hzW1pEh7?=
 =?us-ascii?Q?WA7lYyn/KuBroIdFrAznSOeh6iEhBazmgklFfZBKgDs/nnt4Ig=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2024 08:42:51.1969
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c43081b5-7f5f-40fa-9dff-08dd022cd3e8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E8.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7782

Introduce device parts access commands via the admin queue.

These commands and their structure adhere to the Virtio 1.4
specification.

Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 include/uapi/linux/virtio_pci.h | 131 ++++++++++++++++++++++++++++++++
 1 file changed, 131 insertions(+)

diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
index a8208492e822..1beb317df1b9 100644
--- a/include/uapi/linux/virtio_pci.h
+++ b/include/uapi/linux/virtio_pci.h
@@ -40,6 +40,7 @@
 #define _LINUX_VIRTIO_PCI_H
 
 #include <linux/types.h>
+#include <linux/kernel.h>
 
 #ifndef VIRTIO_PCI_NO_LEGACY
 
@@ -240,6 +241,17 @@ struct virtio_pci_cfg_cap {
 #define VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ		0x5
 #define VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO		0x6
 
+/* Device parts access commands. */
+#define VIRTIO_ADMIN_CMD_CAP_ID_LIST_QUERY		0x7
+#define VIRTIO_ADMIN_CMD_DEVICE_CAP_GET			0x8
+#define VIRTIO_ADMIN_CMD_DRIVER_CAP_SET			0x9
+#define VIRTIO_ADMIN_CMD_RESOURCE_OBJ_CREATE		0xa
+#define VIRTIO_ADMIN_CMD_RESOURCE_OBJ_DESTROY		0xd
+#define VIRTIO_ADMIN_CMD_DEV_PARTS_METADATA_GET		0xe
+#define VIRTIO_ADMIN_CMD_DEV_PARTS_GET			0xf
+#define VIRTIO_ADMIN_CMD_DEV_PARTS_SET			0x10
+#define VIRTIO_ADMIN_CMD_DEV_MODE_SET			0x11
+
 struct virtio_admin_cmd_hdr {
 	__le16 opcode;
 	/*
@@ -286,4 +298,123 @@ struct virtio_admin_cmd_notify_info_result {
 	struct virtio_admin_cmd_notify_info_data entries[VIRTIO_ADMIN_CMD_MAX_NOTIFY_INFO];
 };
 
+#define VIRTIO_DEV_PARTS_CAP 0x0000
+
+struct virtio_dev_parts_cap {
+	__u8 get_parts_resource_objects_limit;
+	__u8 set_parts_resource_objects_limit;
+};
+
+#define MAX_CAP_ID __KERNEL_DIV_ROUND_UP(VIRTIO_DEV_PARTS_CAP + 1, 64)
+
+struct virtio_admin_cmd_query_cap_id_result {
+	__le64 supported_caps[MAX_CAP_ID];
+};
+
+struct virtio_admin_cmd_cap_get_data {
+	__le16 id;
+	__u8 reserved[6];
+};
+
+struct virtio_admin_cmd_cap_set_data {
+	__le16 id;
+	__u8 reserved[6];
+	__u8 cap_specific_data[];
+};
+
+struct virtio_admin_cmd_resource_obj_cmd_hdr {
+	__le16 type;
+	__u8 reserved[2];
+	__le32 id; /* Indicates unique resource object id per resource object type */
+};
+
+struct virtio_admin_cmd_resource_obj_create_data {
+	struct virtio_admin_cmd_resource_obj_cmd_hdr hdr;
+	__le64 flags;
+	__u8 resource_obj_specific_data[];
+};
+
+#define VIRTIO_RESOURCE_OBJ_DEV_PARTS 0
+
+#define VIRTIO_RESOURCE_OBJ_DEV_PARTS_TYPE_GET 0
+#define VIRTIO_RESOURCE_OBJ_DEV_PARTS_TYPE_SET 1
+
+struct virtio_resource_obj_dev_parts {
+	__u8 type;
+	__u8 reserved[7];
+};
+
+#define VIRTIO_ADMIN_CMD_DEV_PARTS_METADATA_TYPE_SIZE 0
+#define VIRTIO_ADMIN_CMD_DEV_PARTS_METADATA_TYPE_COUNT 1
+#define VIRTIO_ADMIN_CMD_DEV_PARTS_METADATA_TYPE_LIST 2
+
+struct virtio_admin_cmd_dev_parts_metadata_data {
+	struct virtio_admin_cmd_resource_obj_cmd_hdr hdr;
+	__u8 type;
+	__u8 reserved[7];
+};
+
+#define VIRTIO_DEV_PART_F_OPTIONAL 0
+
+struct virtio_dev_part_hdr {
+	__le16 part_type;
+	__u8 flags;
+	__u8 reserved;
+	union {
+		struct {
+			__le32 offset;
+			__le32 reserved;
+		} pci_common_cfg;
+		struct {
+			__le16 index;
+			__u8 reserved[6];
+		} vq_index;
+	} selector;
+	__le32 length;
+};
+
+struct virtio_dev_part {
+	struct virtio_dev_part_hdr hdr;
+	__u8 value[];
+};
+
+struct virtio_admin_cmd_dev_parts_metadata_result {
+	union {
+		struct {
+			__le32 size;
+			__le32 reserved;
+		} parts_size;
+		struct {
+			__le32 count;
+			__le32 reserved;
+		} hdr_list_count;
+		struct {
+			__le32 count;
+			__le32 reserved;
+			struct virtio_dev_part_hdr hdrs[];
+		} hdr_list;
+	};
+};
+
+#define VIRTIO_ADMIN_CMD_DEV_PARTS_GET_TYPE_SELECTED 0
+#define VIRTIO_ADMIN_CMD_DEV_PARTS_GET_TYPE_ALL 1
+
+struct virtio_admin_cmd_dev_parts_get_data {
+	struct virtio_admin_cmd_resource_obj_cmd_hdr hdr;
+	__u8 type;
+	__u8 reserved[7];
+	struct virtio_dev_part_hdr hdr_list[];
+};
+
+struct virtio_admin_cmd_dev_parts_set_data {
+	struct virtio_admin_cmd_resource_obj_cmd_hdr hdr;
+	struct virtio_dev_part parts[];
+};
+
+#define VIRTIO_ADMIN_CMD_DEV_MODE_F_STOPPED 0
+
+struct virtio_admin_cmd_dev_mode_set_data {
+	__u8 flags;
+};
+
 #endif
-- 
2.27.0


