Return-Path: <kvm+bounces-30488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 296A29BB0F0
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 11:23:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4D9C01C21509
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 10:23:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 495C71B0F3F;
	Mon,  4 Nov 2024 10:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZI/EQ7HE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2082.outbound.protection.outlook.com [40.107.92.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CCC1B0F19
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 10:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730715806; cv=fail; b=dHoHeZAAvr6cz2/Swo2ixdBw7jTkz+ZAW+LVVu/DGOJd/2TJAVpbeYp7I3gGCGbX9WG3kquZboI3UwppzQSrUM3a4oP89oI4ljLEHw1TwlrU5S93cHJgl/AHddu7Rrn75Dfxocv/CO2A5hOVdncioQUx9tFCFJzMOSPmBiZzEy4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730715806; c=relaxed/simple;
	bh=Z00MDmVaqTi2OzhRfcZop0Ey0nZrpyT/x4fxPU7iF1I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mAiT5POpkflGIMBn70zBEgJ5I/xx2lVJeIwPlfZDOx8VEBDBgAaMd/OXDUBEz2X/H6Ux20kDkp2wyAEyJE/Ry92n6TYDB4wk2KCwqThReIw6UaWZwEOvFrb08Oowfv7ZycsH157tcL+b/L5TGNyCSRsMVy7E0Qe5F3P5EboDhsE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZI/EQ7HE; arc=fail smtp.client-ip=40.107.92.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jVdxkPN0AR5SfcplcQ4dlF+WRd0L88TxY/G1PxMev/6T63MFDn9mXRjbx0gSI18l+OJLG5lx2ugQKfft2o9b4+1GBje3dlXXhmbhpY0Ipt8eBC2jQRjZs0HBKA3WRO4RQ8cSpn6PnHkLRoaGt4X6vODm1lkSmAwQm9La47GziqceC+9zEP7gizvnwrnwjm21fVt/HI8STDkRSSdT61IB8WwZStkKvgw+0XqJpNgygiVt/sGeeKxrlbZ3jT29Uhof5WcWNSmddtZE92aWBXHIzARcnvi9cC5nQdeRqWMbGDyovyUae+QaaVVQHAYRbwcvPzM145KEpcPnc87BF/vosA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ccDi+wpllzviuvG5W+7cqTQb5e7mgtQRCZn/uBydfcU=;
 b=iZWWkicCZgO7VA2gOJCny5oP0UKTjW+RQxcgF4wv8t6fpHGCUajHAEvVP/dVLRbG7VfbdWQGxGHUtahKii7vnaITbvJEsL8TkC6Il2sxyBgmVQqMsSQmuzIHcYzwHmNrbj3Rb0xEe6wHZDd7bZzusc5jMONc/uKOgpnCBJC2BJpZgVjE0YohCbc67nu0GjzaVyqlAjYnFsnSLseM1gnSsZXQkDNazTsBTpapuzJ36J2v64aQBG/7G/5BENgTEM6MzgEPrsiHN/OBj09g6RUyi3MOwkagq0Ja1XLnNE7ikVpHe/0+Dkuy5J+IzbeuFU5sjx/H9kOKM0fi6ZQFCTt0Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ccDi+wpllzviuvG5W+7cqTQb5e7mgtQRCZn/uBydfcU=;
 b=ZI/EQ7HEUMajMkF+DrG38SAqA8GJ2dNAt4oOcjve5RbrGJea70AXSc9VSXteSUkJPmNjJCgCvQmPAIIVFPuUQ/KE+UbIq0k9Jd+GpeFvuui6Y47lgcWww2c0UkzbEF3jmNqBKZrf4gVnuJJlRSzlND19LiCQ1hxy38Ya4llgEut72RQgNuNR7IE8gcYYDo19SLLs69vemxaisBB7xdrjEoLsnUCiCLDB2ueoS0NK1k9gXRohj1qTTy+iUeF8GENEuvDZaCiQgi9cwzkDforQXfX11X/WkgC7dTy2KRweumnMjxwDjlcNJD8m3Z3aApHKfZJB4Oqzn8pzoaKrts3mcw==
Received: from BN0PR03CA0044.namprd03.prod.outlook.com (2603:10b6:408:e7::19)
 by SA1PR12MB8842.namprd12.prod.outlook.com (2603:10b6:806:378::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Mon, 4 Nov
 2024 10:23:20 +0000
Received: from BL6PEPF0001AB4A.namprd04.prod.outlook.com
 (2603:10b6:408:e7:cafe::e4) by BN0PR03CA0044.outlook.office365.com
 (2603:10b6:408:e7::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30 via Frontend
 Transport; Mon, 4 Nov 2024 10:23:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL6PEPF0001AB4A.mail.protection.outlook.com (10.167.242.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.17 via Frontend Transport; Mon, 4 Nov 2024 10:23:20 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 4 Nov 2024
 02:23:06 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Mon, 4 Nov 2024 02:23:06 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Mon, 4 Nov 2024 02:23:03 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH V1 vfio 1/7] virtio_pci: Introduce device parts access commands
Date: Mon, 4 Nov 2024 12:21:25 +0200
Message-ID: <20241104102131.184193-2-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4A:EE_|SA1PR12MB8842:EE_
X-MS-Office365-Filtering-Correlation-Id: b942002c-ac2d-4c1b-7414-08dcfcbab4d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4ddNzKaLigpOfmO3w96pqLVoMZHHfT9iylGYZ8f7FBa59Dnah8QNAEu1u++P?=
 =?us-ascii?Q?XhgAPXJsP2+63R2Y2c55MEHr2VBn1kxkgitxRg8YHs8zQFfsocxFq8LoDoUu?=
 =?us-ascii?Q?X1QcsEkl2NQEOU62pHoiU0xoTxyKXDTvntZkKVmG8zIIox9yyVqG2rqr1M5e?=
 =?us-ascii?Q?rBt/Ro6+ZFkxujnD9UQ8c36quTRCN4BMdTsUlykD5b38/Rab19XSWy3641le?=
 =?us-ascii?Q?bZ9XeEy8NyORyKZnslQP020sq7fiJEVqnj9CBK1f1o/2qod1zUWUj5U1QhAV?=
 =?us-ascii?Q?We+JZJus37IBunW0ceymAkkTXnOQUJkiKV2+7fsnI5eSyCHr7AP5wxVpVwG0?=
 =?us-ascii?Q?FHp4pLJ8A8HY3exa4gveFw9bpZEDolqJkvTA3Yd7VA8nm5JUxpJNq8u9A7A5?=
 =?us-ascii?Q?RVmTdTbv2KJTNrwauhwEUuRHCqXE+Ph3e2eVu1AkBPB5HR24h5pEXz0bpTD2?=
 =?us-ascii?Q?YryK+YX+Ty/UH2egWTsXs73tKrHnBlY9GeCqwdhfiHVVQoY3sxU9DfDVUtCa?=
 =?us-ascii?Q?/Bp3N6c8Hx6iWiOOX52yhxltAIP244cNqNxqGfUJwh6yoPia7ZpTGrweDOVy?=
 =?us-ascii?Q?nVA8e3DsBNZPsiOpanvAHyYTauPbIRpFNTIv4MBIl6bn78vmYDhx2xl9AV28?=
 =?us-ascii?Q?n9nEa4GZpVqVv2ReMWgKUVBVcEjR8invDHdVpAFg1qAW/HWA8IrMMyOwdKiU?=
 =?us-ascii?Q?nsk/o7fTGEIbfiMYbVLJ9ay1DkAJiR1gc68kr70tCZsOge/P582QNet/QHzg?=
 =?us-ascii?Q?hmTfIY+fzmbCC317kHfju0iuJ5B+yuoUyEjjaqP9IVuchb0as1I+0JCULa2A?=
 =?us-ascii?Q?aYpzKP6hRCjjAVn0KwJy+sybOUw2Xaeswbn2RsVJOQkKQD9ODXJlAnBr0rgO?=
 =?us-ascii?Q?nOVNRnEDdXxxg6LGfpjw6TPjK+69/KzARV6i6xbDI9AEcHkywWbSY2xP1Ce9?=
 =?us-ascii?Q?c1QyrnSFasTpstIpBwi0mzL0tQFmmbejKrlTFO7r5aVZ8peTL5WJNqSkypjM?=
 =?us-ascii?Q?oNrOFj839hXdxzNPL6fqjFhv8+4NEuANs2llezfHlu7cldAY+5Xr9eSMehwa?=
 =?us-ascii?Q?gQ5bGLPVioeKRcwEZ34OlIMcwAyYN17NBfiKUeSLmzuqO7xzDkH0ihN21PEm?=
 =?us-ascii?Q?xsDnPLiB77t9B5gWsCwjCeoPt3sDgSDyQszYOR2uiJudOcGw/Ee4LQjpIMfq?=
 =?us-ascii?Q?WJirSYcKO7r/eEFZlv88BRoGj3cm0LEl4dYuKpGggJHb/kC7F1inDIvP5wjq?=
 =?us-ascii?Q?bEvSiiym7C3wJDDphoIBH+gs3iHMFjyjCWUOxqYJOHgp6uBz8J1K0qjNcxyj?=
 =?us-ascii?Q?QQWFYhXweunAg7FhD0JMQ0c01c5LrZAJsKOol2lNE74BNth9uiPwNNl2RJq5?=
 =?us-ascii?Q?O2JSy4X1y8l8prqIm4a9YiyHrpK8gJGHiWL0u8diu7skTJKbwg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2024 10:23:20.5700
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b942002c-ac2d-4c1b-7414-08dcfcbab4d2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB4A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8842

Introduce device parts access commands via the admin queue.

These commands and their structure adhere to the Virtio 1.4
specification.

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


