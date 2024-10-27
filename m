Return-Path: <kvm+bounces-29755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FF7F9B1D12
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2024 11:08:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7E6E11C20B95
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2024 10:08:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAE9613CFAD;
	Sun, 27 Oct 2024 10:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Pbr6oPK5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2064.outbound.protection.outlook.com [40.107.101.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0A37346D
	for <kvm@vger.kernel.org>; Sun, 27 Oct 2024 10:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730023721; cv=fail; b=qm1aJ3PneyGH9K2Og4n3F9dhTntMTenJP8t4bGFQKfcg3xudpNlGLU016OE2BFl1G7Q6axhPFTJy63Am31F34mRA+j7fxdFmKM3s3XW0XE1Zk96um2om8zmpwJGve0BRZEvuQ7UvBcc4QPvQUZK8bBvE2oR+58vhPHjdhBA7Z0w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730023721; c=relaxed/simple;
	bh=Z00MDmVaqTi2OzhRfcZop0Ey0nZrpyT/x4fxPU7iF1I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UGVnNDFxWQ+IDOlVGEyiQOHbwNZTenIcfAnijF18Jr96V16EQSczoOwbu9oBjE+bB5EhfMeiMUO9cADzvRbxEXLxmwjwA8a5vZ8Ofa2KQeew9d7D01qZEH+SNYVJvjiMxmczGwXLoLDENc8ZXDTWCz+CHAwAUKNYOMdoHh0RVLc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Pbr6oPK5; arc=fail smtp.client-ip=40.107.101.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BcQs+XAYnczMGPgT0hv1nnRV7i6BZVvZm5IOYERW8QYNZl98iJ8jTyXFpBPj1EY4+nVbyKW00BK0t5y1yYpa+iTAwqhJgEV42/s3Hj2g4x0+yyTzpGO2xFvC+zz5S7tLFFh2O5bXbBZTvVZ9/ayN7MeA7AJw2oE4y90fBbyyqIRSDxca/Tz9eqkb8kZJcZ/g4HMIFsv53ANEMc23QqE7fzrv2dYBrOtatnCqUh91sAJgwuiuDwODCc+eEKqqozQflgZsEW/+8PgWUZLqL2hUnWpSq8M2uM/7gtNxqpBAu3mf0fNZ1wSwcYAxj2gkRqdArZ9InXpgE6Rv6BjRjSk35w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ccDi+wpllzviuvG5W+7cqTQb5e7mgtQRCZn/uBydfcU=;
 b=HdOqQTfrGU90owJ52KttDE7vv49b9YyyK/wo1V6oAuFDIjxk/BH7UZGpQN5ed+0DCqObyWS7/LQePxw/bCyg7khgIYbeKZ50rYKgbTHcVu92dLqKJlF9pqdfCjyg2CUqtLKogC7fd+MUGBoGZcTU6sUcKxcBJBT1cIaoVs8SoxE4pePy58V0gm86q9Qu24wMjuxds63NJFiq9krWXwzXNA4JJ3QrUQ0fNGKb4jFcpKkVY3JN3i3B6HFrmD88cX2+501sQ4XFwP6CTjMrhjVLN3SNjK+sAYqCLyzyUVa43+/0iqojS7aJGNFoUnOIKtPfvIIAud29eTe/aN38aNQpMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ccDi+wpllzviuvG5W+7cqTQb5e7mgtQRCZn/uBydfcU=;
 b=Pbr6oPK5MvcXIXG9Op9aRiDW0kaXnjRD3jQkv6M/sRk0oRyI1CF98WTIc8pA/iiDzXEq0EmDKUOCrdA/NF/KCD8eJ0aeSXAdIwbQgILkIvviKiV6ElHMnaaPdeD6ZiHF2PydEC05dBuf0P9Uxw90+9iCbxy4IzABd3m3EiT5wBkpAOpjzec5wJ0RPM9+UUWRxA48jZ9LwKawRuybY1FY5rfyUtkD995tqBQR+0w4sofwWLOHxNoe28BnZ52teYHS17JEZDHvDFKOhCytq9spBDYpJ0azypDeIcyePvu4cp9hPjlF3OWP9DBgwpcubMjwLvO2iXtoDva3Os0wqAmuxw==
Received: from SA9P223CA0029.NAMP223.PROD.OUTLOOK.COM (2603:10b6:806:26::34)
 by PH7PR12MB7257.namprd12.prod.outlook.com (2603:10b6:510:205::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.24; Sun, 27 Oct
 2024 10:08:36 +0000
Received: from SN1PEPF0002529E.namprd05.prod.outlook.com
 (2603:10b6:806:26:cafe::39) by SA9P223CA0029.outlook.office365.com
 (2603:10b6:806:26::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.25 via Frontend
 Transport; Sun, 27 Oct 2024 10:08:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF0002529E.mail.protection.outlook.com (10.167.242.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8093.14 via Frontend Transport; Sun, 27 Oct 2024 10:08:35 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 27 Oct
 2024 03:08:23 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 27 Oct
 2024 03:08:22 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.1544.4 via Frontend Transport; Sun, 27 Oct
 2024 03:08:19 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH vfio 1/7] virtio_pci: Introduce device parts access commands
Date: Sun, 27 Oct 2024 12:07:45 +0200
Message-ID: <20241027100751.219214-2-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529E:EE_|PH7PR12MB7257:EE_
X-MS-Office365-Filtering-Correlation-Id: acbbacf8-7354-4856-cbbb-08dcf66f5214
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HGip9vZfVVfyPNL7aTQbQ198Rxty71VSHBl0YcAVsT8Dnft106Wx72Sbheev?=
 =?us-ascii?Q?kKMDEktiEqrMAWANPM6BIngx2KpunQF7WWrYWadzX4iqNADND8n6rQHrcTi1?=
 =?us-ascii?Q?BYJgWCV3J0wcijLstlVRsFPyzpeKR7dyvckt+PSgnoKR4yFRK4lyOyUCy8Ul?=
 =?us-ascii?Q?Ld77j8HclD+8Nah6ccaOzgzD1BzdgpZuvaUcC5R1gOPdp9/zJks6t2WlUskA?=
 =?us-ascii?Q?uNyigUj+FwxVjyQpQfcNXC7+vOBy+xNZRGjlehBSVL0ZvxZiUF7yUzPwJ4Ft?=
 =?us-ascii?Q?sncD4O8n5YnT3ncPGecyK6nbXHpo/dsmPmQXd7drENLk/3ySrb+oj8u2lQQ5?=
 =?us-ascii?Q?zRIh1kVKiW8xFOFeZ9VbhAE5b4aZJ4pav35GoMcaDG0etQBwpo5z/fh40Uqs?=
 =?us-ascii?Q?KxSfDyDEdfUemCIpG+N3JbAWJOdzzUULNCH7kpcvQjM4wwo9tcDr9AGhaL62?=
 =?us-ascii?Q?uFphx+v38mfx8VNfHFtni67M+ZhQoWZf/60Ia3wXVSWu+VWK0ilL/Ee4x+Sm?=
 =?us-ascii?Q?JJfh82fcgnXd7TKWIV4F44sPp7pLiagW89XfNkcI/jCeoCBGrVr3gAPRt7yl?=
 =?us-ascii?Q?Uil1Yfi0ZsIiwaeSzKMFrXVzayAyV4OrerjEEfxHV0ynOLaZPdal+UUpU/H+?=
 =?us-ascii?Q?+i5majtJWfzNOPJvavlOmL2JH8zlHQmN1n7/WvQEs6xsjjANt6gJLuFJ2Bq4?=
 =?us-ascii?Q?VdGGohRU0Ugu15DIVGYJXeGRg9vVxwoAHtCAc0Ycue9zKdt0eKt6X2A08Pg3?=
 =?us-ascii?Q?xh6qGjJyQqiPJ7QzlPaj5poM5kAyhgiZUKPUlNb5q7/fNoJEwKksSpVE/crT?=
 =?us-ascii?Q?zEHcqBinx7mT6POupUvZfU39xplsYztX2OdhnXVN5hT3/0R4Xy32Vlu4BKRb?=
 =?us-ascii?Q?o8JYxiinG0sJO8gVVF4QjndLkj5S0+Zt79w3k+fwBxGFWEwoaKeljYTov18X?=
 =?us-ascii?Q?PetEYsraPe7WdkcBlYSgtmEsWffryuHqGxW8jXHxN1V4T2f+0MRjxURcnMU3?=
 =?us-ascii?Q?b2kcoVFZlQFluQOjGSQN8yJZcqNkSnDZdTT+CLzbYBeXtvT9yMheG4A/mTmd?=
 =?us-ascii?Q?kP68+J0nRNBP8NQfoa8eoNDEGyeEtVanoqrUnM6djHx3FzedlMtKVwNDzceN?=
 =?us-ascii?Q?VI4PL8jzgBSSiXl2XoQjPSraOZu5nkGbg0seeFDIKJ2DOuReCKjMGNHMDgF8?=
 =?us-ascii?Q?MCdWz7r/eyctp1AUs+LwwmAN8n8h7PQsuhB1JEQr6/hBOVWisIhp4xIJQ0Vp?=
 =?us-ascii?Q?2rr/qyzD8PWB0DrA4fxoUrGjds6wK+Q+Vx5dsjJJsXQIy6Oaz3yN3pMI/OvQ?=
 =?us-ascii?Q?Q/ML0sUegEQdmmUANnHslGQXONYHCaQILQ8iKjIjqO0d3h5LC5lx1a77kPgb?=
 =?us-ascii?Q?jtatwqZ4WP5tGU2zK2P/iADGP3iBYYh74BaKcoF04JLZ3m7vhQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2024 10:08:35.7258
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: acbbacf8-7354-4856-cbbb-08dcf66f5214
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002529E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7257

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


