Return-Path: <kvm+bounces-31728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D8E479C6E47
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 12:54:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6B5671F23B98
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 11:54:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05741201261;
	Wed, 13 Nov 2024 11:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EFHxs/cT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2062.outbound.protection.outlook.com [40.107.243.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C36201036
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 11:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731498780; cv=fail; b=pFZAU0/yWoZrSLx8VfRadkm0LJVZwP4PG7vsDQ6NmLrwqHaKJeUOSeiek1ZMJ88OesL52uEo7VnyYNQKC+M4hucdX42yTgJm2coAAiuDAp1caDwgJGjPpKB3TsscPuYAoC3sHZ8iWWEa8mX9OdTBlXLppO6QuLUFIuYynLXi7ks=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731498780; c=relaxed/simple;
	bh=pe47dxh73UgEBY28lJctp6TIcjx0lc6PM+qY4LVDV6I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xcby4ZD8LFOrifLskDZnbYyQxJDixLBsOY6XXxduCQLhEujyqFG1ytNmsFZKVD8sMdIjd7ua+xTSOe9WZyrrEADrqoI+gRyAvaibaoBWq6adhg6xKjuzfl1tF2QPer2cXocm4vM0Bbkykj1q5mBSCwbHBqqLU/m+E6skJCCS1nk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EFHxs/cT; arc=fail smtp.client-ip=40.107.243.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WkiIlo9YydNZDpXPkmMuRDo/eCjCJq6amTpU74V9LDYiIdfcIol+x4FO95k7eoUd8Do4372kTpAfFqfJYS3iiUHR17AKKc3aWMlYSDIuzH+AqYN9JCsFwRAAHLBUqbA7YX0RAAbeNEqLFoCLqFkDNId0pEZCZ3QIMIpnJVSdoZflR1tICHOqsRxDyY2SYok1089IfEu4Zz/QpzS8OD8AYKOHucSfo8qpl6tcEUjmmRIdHpKfgi6pNZOp+nhdV4CFhKjg5BCRgJmwuByj4So5wnK1oEZHlS116zrDihlv9TO9jE1a6/MHfB3+81Y7JwmKUMgSR4CJG+ROUPcHRDyjDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6UH2a9AejqPu8XRAVzr+yVLeBfNdCRpTJ5IZVd8H4IU=;
 b=rJLe5QDqFVhKUjkYcqSTVShGNGJXBVyXOqoioEr6sjyC6Mo451fHJI1cfQ2gfJpZ2ET8YVvZypwqhwTEFGcvswgXTa2Eng6f+96sLWP4u4gUoNK2M4FVqq+QpSsp5PIrT7XogSyqgYEL22Eoinmlp9Z/YAJF2/ZFMzxVuRIxVkH++pMm+Z2D+BMlElE8/1q85RpbFjbycn+p5cUOKnw5SIK3vRtDsGghK+dwfoPPejGSZvn7HGGGmdt/x+Z892Bd2KaK9p7lMWNOWz2lH8FlFWzEhzuVaon3NWrmkFVn3ljPfyr3ywinGdC6tkzYDKLNAV0Ok3vLYg0ySPj3zzQz1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6UH2a9AejqPu8XRAVzr+yVLeBfNdCRpTJ5IZVd8H4IU=;
 b=EFHxs/cTq5FHA4hepVJO+uw09ZjRtrpLztMAgtbF2QNkcSB5wgYfVw6i3klKDdwV3FVupCyx/Uqs7YI4+vkyTdO0ZVpNG9YdNzZ1ekKWFybPy/guGcUyZC55AfU+Iyz2lVgqyzXxf+CwwI8B/2zzAG8SCH7VeiwZlY/F1r6hmKPZA82/Iz5fIIynf+N4AAbzyRvQp+Q5TA0EzK0+d+Xl/UQ3GSmxfjqo6lDiqLo6PZOWCJa+Yv1tswBFUcuQtK9w9y+BWnDUbjpEYP81IAcTHAhgqh1kdthLgpFLsUeBJmYhxS8Zt/bNtZf39vTWAUYbfH31tUgUBsGveApntRPp4A==
Received: from PH7PR17CA0071.namprd17.prod.outlook.com (2603:10b6:510:325::28)
 by LV3PR12MB9438.namprd12.prod.outlook.com (2603:10b6:408:212::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20; Wed, 13 Nov
 2024 11:52:55 +0000
Received: from SA2PEPF000015C8.namprd03.prod.outlook.com
 (2603:10b6:510:325:cafe::98) by PH7PR17CA0071.outlook.office365.com
 (2603:10b6:510:325::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.16 via Frontend
 Transport; Wed, 13 Nov 2024 11:52:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF000015C8.mail.protection.outlook.com (10.167.241.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.14 via Frontend Transport; Wed, 13 Nov 2024 11:52:54 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 13 Nov
 2024 03:52:43 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 13 Nov
 2024 03:52:43 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.1544.4 via Frontend Transport; Wed, 13 Nov
 2024 03:52:40 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH V4 vfio 1/7] virtio_pci: Introduce device parts access commands
Date: Wed, 13 Nov 2024 13:51:54 +0200
Message-ID: <20241113115200.209269-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20241113115200.209269-1-yishaih@nvidia.com>
References: <20241113115200.209269-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF000015C8:EE_|LV3PR12MB9438:EE_
X-MS-Office365-Filtering-Correlation-Id: 3eb5c45a-a56c-469b-43d9-08dd03d9b5d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hH4GosGVHBF2cq8VSrp98ziJmbFyjhrzYSl2JEbktRmZE2kzNdqMrUMbtm8j?=
 =?us-ascii?Q?93i6/g9RNBRc9l0FLHSf21U8Pp9caVo5MwSOzs3/0lDqppw9BDdy/OQ0zoTy?=
 =?us-ascii?Q?aDOryCpWF/QycWzekJQwgU1IwMOUDhZjaeFQCKfqvpHRwtNV27GAecuLxsLX?=
 =?us-ascii?Q?GB1lTF8e3ZJKxW2ZouJrRxaLFRilpyBGTBRBt8x6lx8s/PVrSrzNl2dZcjA1?=
 =?us-ascii?Q?QXvgEwdIzcuU7vaQ/AUzp06ERJNLnBrHpZGgXpmcxVtGL9QvZO27K4V5lEH4?=
 =?us-ascii?Q?mTdPaDOTfPPtH/GBuD6twCFapuhQKWjXrpa6eQqqmdTWkpcJq87PaiXQe4nM?=
 =?us-ascii?Q?MAMTVfkXuvKuYPjaOFp9hqoj6ynuX9lz/QOZxJ/3fb+/gJ9VLAujMhvjjg4b?=
 =?us-ascii?Q?NjDMJXgOxfC3FkLBQjhRYzVpByUXWRmIljNUyXB5dZ2Zbo/tOGLWmJA10OQc?=
 =?us-ascii?Q?Y2euowQwbiVTbKlgEmbbMmIv6ou+MVp2xO7ZShIBf9PdRlPE04dUlzKcCon5?=
 =?us-ascii?Q?vN6JP2RswjEPzadjBdD6J5/nlq7JwQJia4LspZZKm5JlfKeP7ZM/lgpj9+uL?=
 =?us-ascii?Q?Z1X8ket3GPp8k5IkEmcIeuB1wopYzsIW3meJM7fBz66iUlWBvMqUjYxVmm7p?=
 =?us-ascii?Q?zwmmN1g7uYBrp0oDKg473tkyaY/iHPabA/Gh3GmOYtmmantVQMAvt3UL6Olq?=
 =?us-ascii?Q?agLyQ09CJqA0JHWjcxf7F/2lvkA8+gIL2zzVjenrloqccJXr+YXkjnlOl0LR?=
 =?us-ascii?Q?QHikt5zw43OSC9KK+SKcd1wO4TOxSU8YuAXasB0z9d22Xw6W+cd0usGu/kj2?=
 =?us-ascii?Q?MT5rmDcYrifcylQQTIEKjfow0f4jhncdb5OEGgE8eRTdNb4MIS3MH0tosGZM?=
 =?us-ascii?Q?9UNMPUcd1PZsSfShXMu+ul7tod6P8Xef7kaJpwyYZX0E0vJQ3jOT0yDnukwj?=
 =?us-ascii?Q?w2LzPsQcV1B1NElGWWEQKQFKG7J3UjSSodx4sia6duvCGDcW5RuRFp11bnCW?=
 =?us-ascii?Q?lK5K4EXNmqT1DGV3R4MmD3qR2mecC/f5pjUwLDfRUT/IB5EgR6cxD/uL14NQ?=
 =?us-ascii?Q?DQnl2XhFIUYMHdyihgXWC322omfJomE89HOTxfiwVIvzOSITdqjpS/SeAcLM?=
 =?us-ascii?Q?rvrpIwMDXMhyYhGwU0fbPEbKHbOQ2p+zg+vFMhU6PZhb+EkAS3ZVwLerdDzB?=
 =?us-ascii?Q?CJZ8wXiDATpv0MnLF6nGSUWLW/f+6ePQrlHd5jN+dVkGk2Yk5V1jyC3IOO9L?=
 =?us-ascii?Q?PaGlG4gWtSfnb6nZheXQYSqGAVim5Ab3J/7TmYZtKZwAjJGO1VDQ8IQQIH+/?=
 =?us-ascii?Q?vkKxpRFst2Ld7OMPWUrXQMLXDhYTN/XtmwwKPYVQZ+pqx+bieBb/kLvywyet?=
 =?us-ascii?Q?0qlvd3FCdmW3nHOrPLSMrlFxV6fMGg87Y+sG2atxh5jpABumyA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2024 11:52:54.8929
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3eb5c45a-a56c-469b-43d9-08dd03d9b5d9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015C8.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9438

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


