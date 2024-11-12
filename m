Return-Path: <kvm+bounces-31591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96E099C50F4
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 09:41:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5736D284142
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 08:41:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0F1220C492;
	Tue, 12 Nov 2024 08:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sxqOZWoL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2064.outbound.protection.outlook.com [40.107.94.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F59320C009
	for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 08:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731400724; cv=fail; b=YFDeBJYyjR6gz4KQ5kcCS7a7UkhGngMl0EUPDTUeHSyOEbEVk6FFz4Mk8YH9P0xG7voAeFNthgvUgBnLdJ9evQIVCcq8Qtr27fczyLcWv4lkGfLDoST0MFfGBGCWRFz14cCGcYlk7RdJItYewnsouvXF4iFf0UKDwUt/0pyq8M8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731400724; c=relaxed/simple;
	bh=pe47dxh73UgEBY28lJctp6TIcjx0lc6PM+qY4LVDV6I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hk6j+bUOg5ps3MbWJcgfu8jniRh0vx2DGTGda1w8p1kSyz1CHXRZ7rxdcfgfNAlmGAld/hxxXgdwuc6U5OyZGHKRX8wcYLnaL0iU56ARUu06OmfPipfBeJnv3268iaPQYnC2sTfzTxiZJMJXLuBt5Zqu+wARjmoKximyvXdRH8I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sxqOZWoL; arc=fail smtp.client-ip=40.107.94.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aUX0v5smseYIAmNVfDsB/dJbflSTELgpEim84w+8TipXBUvdL7k7J0eoGzNjf67M02B9HLrdcHkKqpcUeSN6dEyzgHg26mQkIqfMTDFnHSN3PuW/Ypc5amoKjNSPMwKw4vpI/oxHJ/LSm2fj0vtfT58KvYpRGs71rlCCsGYB7Z11y1/meS6Y+w139MpDRjUvtZ73Iq/LdZhfKiYb4tqpuyzHgE5F84NvxPQc0Rqkn5T8EYc8c/7v1AYwVeI9ZHaN2Y3sajRmB7CXCldZPI+PT3A/PZWxbPBVTySM/uG875lXKAeBTjmtIDZeG/wBVDUMH+vbxIz6GDsJiYzc1xLc7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6UH2a9AejqPu8XRAVzr+yVLeBfNdCRpTJ5IZVd8H4IU=;
 b=cLhIgw9Z+FETEqlOJphhTY/6jLn2auMpxIXX8Abzyny/fszJybpLEOXBDwbjda8MhVTi671GYoEmTe7HxAT/GyPel8iKKYxIgeTGiXS7IWMjrK/ntyRFx/aI0odbj8mNqyxEayCh/7UnDiQUc/zXL9QbXsvwQhgI7+C+GGHmrdbwvJeXOIdi9oLUk2twHwBOqeLc4cN0WUgytTwxRZn5Ue22blKuh8jvJmMuHUlZSCQQuyrRdcLISnJ61CLOwN0F8DS6ed/kmXalj7xss+Sm1OkUk1+FL2TmLY0YjStjniGqAtWT0xB0QdlQmdtYXV9hecIooTBXWawOR3Uu89Znlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6UH2a9AejqPu8XRAVzr+yVLeBfNdCRpTJ5IZVd8H4IU=;
 b=sxqOZWoLqXdXvdCvfQXo84X+Cs+rP17pJ8CRASRVPiRWsZixLfUJ79UFrBF25jPFrMH/xtnHaNJcrl8aMwsn4um/p48oQaMawSHl0Dws9j2v7DCzu9sX1XD2SM1NOLq+ouVCA3qdwQAiWp9y/kX1ctDMMsIJ7qi4q0s5aIPI4BpKppp8EgvlHQZFUec5lBuxptIuZpE7W8v2ZHt7/k/Q2djy8Hdq/+VzLik4MVsRDosUlXnKotAy923hLPO0cgXF69aPLJ7Ru5VTcHskJ+602i0GF/NYTWLKaYCviSrwdAiaGZ8tMw+dWA6+wMBSGzPziVMR/wNv8D2835O/bSfj2w==
Received: from DS7PR03CA0249.namprd03.prod.outlook.com (2603:10b6:5:3b3::14)
 by SJ0PR12MB6829.namprd12.prod.outlook.com (2603:10b6:a03:47b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.27; Tue, 12 Nov
 2024 08:38:35 +0000
Received: from DS1PEPF0001708E.namprd03.prod.outlook.com
 (2603:10b6:5:3b3:cafe::51) by DS7PR03CA0249.outlook.office365.com
 (2603:10b6:5:3b3::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.16 via Frontend
 Transport; Tue, 12 Nov 2024 08:38:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0001708E.mail.protection.outlook.com (10.167.17.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.14 via Frontend Transport; Tue, 12 Nov 2024 08:38:34 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 12 Nov
 2024 00:38:21 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 12 Nov
 2024 00:38:20 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.1544.4 via Frontend Transport; Tue, 12 Nov
 2024 00:38:17 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH V3 vfio 1/7] virtio_pci: Introduce device parts access commands
Date: Tue, 12 Nov 2024 10:37:23 +0200
Message-ID: <20241112083729.145005-2-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF0001708E:EE_|SJ0PR12MB6829:EE_
X-MS-Office365-Filtering-Correlation-Id: 691ea1d8-dceb-4ce3-4428-08dd02f5656f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GT4njXUKuonumrAKmXkwBusqUMt4lbd7flTQvLJWFCjSf4MknGMYUvK/fXCB?=
 =?us-ascii?Q?/fHZmgboQkr7xHDAQJZrb+KSu4PiZ/f2kfUQcTvbjup4afjSVBvNwn/VFn2S?=
 =?us-ascii?Q?w5GDbScvf/QgYcbwdPqR9b9quMyOA9rMT8+H6nTcdj8E1UD6MeFgeFFEjAmt?=
 =?us-ascii?Q?A0iHlCKuPqg93rNdVTz3AX2sOM+MFlkOf9eG0My+K7vaJX0lxjLw5/RTQ0z0?=
 =?us-ascii?Q?++aFLCa3dtlt5rmV1k6QXm6av/Q872GLivq3YtAjmVjwT49XFZ9GxVJnAp/Q?=
 =?us-ascii?Q?U8hEVM+QsBfxIWF+Mu07XN50rIEnkUs1jF6vMQ+kj9fnr9k36eDk8U2BClUV?=
 =?us-ascii?Q?ywamCm2Eb6ihHtqb8JT7WyNaGU2Ef4Op+K5oDa+BqRCelNGkHJGOnLyDVJ/9?=
 =?us-ascii?Q?iifNJo3z0yq2/aK1JYoq1eu8d6U+0N+zh6lGlZDc87ZZYxVT3bxOPNpFIXTN?=
 =?us-ascii?Q?pWfNroIIIwtyAZrMSfXzesOYGN9xZd/buUlYugIPvCTNiINtOjWyI0zsmtN9?=
 =?us-ascii?Q?Ggzk02QBhmnjbSalNnXHn4WI+cNz4XwHB/H4pW0sDcxoOHdEUgwIdG82rm8X?=
 =?us-ascii?Q?gQX3zf7TLCvVvWmvJvfotxQbsxiEQ11QrlRgNG8FcI1jJbc+c44/mZ74ov3Y?=
 =?us-ascii?Q?aVgUix8CK7isUi5NX16CPfF4Gy8XkHFWKl5quCRQVGneqVsfrjTSy6PJ+DxR?=
 =?us-ascii?Q?0TzUZRSOFa5dfykEkjsbQE11Qv6umDPbqYEJckOl9OiadM0Eq8KCN6418UYG?=
 =?us-ascii?Q?sCMseUy8haemGggbbAjLyQLRDK6NMoJ1z7zRVPxFgshnxiimQKhw8i23r0gq?=
 =?us-ascii?Q?6qVzvOgDHFuAhAyHGnv6GbczuePytKZck/b3i6p2+kAaGjkiEZUHEriN5TWw?=
 =?us-ascii?Q?E0EibYTZNFGWLEuTLJyr8LnfG+yjKCKim9RXR3+K3dsZFaqUJqUnEWp4fB9j?=
 =?us-ascii?Q?OOrbxVy2L8veMy3Bp2dVg4MnVlqIObGKJx2HYBZ9+6CCRwhnMm6ZwYmrYybs?=
 =?us-ascii?Q?sfW0tNOAJQoBdVCdc0DYlTilDgrL7X+zfdvEar2r7RseQP4HMZDCJKAtyCZy?=
 =?us-ascii?Q?H8C9pdojU5FcSkxl8jL7h45KAdiOEzY5m58MsQEqXToRHVqCqpkpe+0nGjnF?=
 =?us-ascii?Q?7MEgcPYaG1TJRP4ZCIt3YQpluwR1Yf+aRZZJfFJprjXKrmK2CIUarATCJNaB?=
 =?us-ascii?Q?3X20SCruRm12z8ilJycztyc0szllhSLZa4DjT0SOoRFFtVXOTvJpvFv4KTrq?=
 =?us-ascii?Q?hFQtz2aBDLCfQgf8nrlv758c7haUfgXc0LukZ2+meoFevnb/aYZBIAGRDn0U?=
 =?us-ascii?Q?cwziTFmhc7/Hql552csfgIjoNixIAFn4KIvuTBr56l6eDj2j8xlF3i5Pvf21?=
 =?us-ascii?Q?/X6XDCOUUio49hfLGASvWyXRLNBjc8yZMGcKlFCw3I9JxNHugQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 08:38:34.6949
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 691ea1d8-dceb-4ce3-4428-08dd02f5656f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF0001708E.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6829

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


