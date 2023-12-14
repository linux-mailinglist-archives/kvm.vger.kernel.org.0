Return-Path: <kvm+bounces-4482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AD833813051
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 13:39:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BB0E01C219E5
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 12:39:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DDAA4D5A1;
	Thu, 14 Dec 2023 12:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nKHKqwmI"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2050.outbound.protection.outlook.com [40.107.244.50])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E459A3
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 04:39:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jCaOK5J3czoBOzrBUOZSI4M965/RDdJ8JCrtghTx9B0Twyv5fV2V+PaZ7zj/ng+u7GCqALsDb6UNzwzVVempRYeseW5nN+V3Ct9rMC+JdlE8D+Mt7MLRPS3uo9mXgCJp2nOZK9+hM1UrurT1kuJTnyf0r3xCKAq0rCA/8NZXglt+MAOzP2VKkXY58WSyt6dM0h4kwlx2uAW9FXPmIpnd5QI6MnCRCTmAkQk4y6fDmsMaRAvCUZhnQRmsbprz7f0eEsc4f7+zL8EvjxVqH/BnF6VKq7LtSNRLsScYaYheLi2qjF7VaFjhhOR5d8gQa2fQKiBMK35LwQSPB2mFuojdag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=szqSpjH8gveSqBHOKS7GHJvcjlJTjHrh3TblVtqYI7o=;
 b=broBgx6xqaZujQXvKZ+4o6JA6qvjAvnxJlet/kkKcbVtBT/CSIg44bQuUJ7wuYfGe6y52QdoxqH9nbLE5izwagodB6Brn7cL9DzSzel315wKogO/OsGa4rE3nuHDhFWZMFGbZfMOXjgmnDoXW8RUu9M+E4KEEKHkQLnCiK52VhTFWW2rSmAgDA4MVzquBEclY5WbCz2cAdcvVAet9MAWH27CKkQZqibJ9Kz0jhPxwOlKCVz0U4IH7xLo1JJE3gPvllE76PkPJNhOdXLj3KtykBq9nTxq0IQ3rEbEZO0VdklS+KU4t6CxCbxIOqytCJKvtPB4YO1cL/kbF36kN+3FcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=szqSpjH8gveSqBHOKS7GHJvcjlJTjHrh3TblVtqYI7o=;
 b=nKHKqwmIU9pfuAtGiVxJ3AhBAQAzfXmfUNa2iFuN2yHSJ+LbqJyN0EPCMrg7tNkHx0NC0Ij1n4SNncm2BbNt12S4MsciqHcLB1jh9Z/woeZPt3ICJ4okHivB+qVzNPjnh7OH98mZdWOxaWppxdH2GW+bJED1qo8na0s4TI3sVvi8la9FMpms1lMCaYUfg0n0YXJs1BWL/xDBh+3wJjLxzAjZvtoJW/3xAsPkYDObscB7RfcB7ADyEn5IJjfm+5bO3u+fJGNOs/AvTLGPyOOfaCpRdiqF75T53AADTMaOxShSZxGUUmpl7ad9Z/G3OGRFTTVjmMPDcTM+pPysyuCrEg==
Received: from SJ0PR05CA0155.namprd05.prod.outlook.com (2603:10b6:a03:339::10)
 by DM4PR12MB5248.namprd12.prod.outlook.com (2603:10b6:5:39c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.28; Thu, 14 Dec
 2023 12:39:00 +0000
Received: from DS3PEPF000099D4.namprd04.prod.outlook.com
 (2603:10b6:a03:339:cafe::9a) by SJ0PR05CA0155.outlook.office365.com
 (2603:10b6:a03:339::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.26 via Frontend
 Transport; Thu, 14 Dec 2023 12:38:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS3PEPF000099D4.mail.protection.outlook.com (10.167.17.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7091.26 via Frontend Transport; Thu, 14 Dec 2023 12:38:59 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 14 Dec
 2023 04:38:46 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 14 Dec
 2023 04:38:46 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Thu, 14 Dec
 2023 04:38:42 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V8 vfio 4/9] virtio-pci: Introduce admin commands
Date: Thu, 14 Dec 2023 14:38:03 +0200
Message-ID: <20231214123808.76664-5-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231214123808.76664-1-yishaih@nvidia.com>
References: <20231214123808.76664-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D4:EE_|DM4PR12MB5248:EE_
X-MS-Office365-Filtering-Correlation-Id: f73eeafb-9e13-47f7-ba14-08dbfca1a55b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	doAdS/VjECMwCAbf9BxMRUbc49evjJCt1H4Y7ydoxmQFEvfuWLRS10XfUcsLkKRu1LheEeJRMD4bHrYdz1ayhxjo7sLQtTTT1YV0tWJkcJwmpAGMy2wCwjcjbtw1ZBqlqhrPGRvQTmbTjgRCXi8RPE2kpe9Uu2ghzJ6xNgs6Oaeck4kO23k+albYBOcoQRDH/JOTluUsSi+g9bBDatowbVItn1pNQ+GI96JEo2X/8BWN0iOw4UYmiUUQVRJycuwHqpHr7CbA3ThfP6Ia29I2PLYHmJI7j561Vxj6DpQ1VPGTKpP0Z68QRy9UsetbNtjldaJs54/qjTbQmkxvxW/+/8aGSKlyf/gKQcgIqwlJp5pt8biC2CJeeTwKSpo+fDAAIS6jDgMQXmXKbT2imgubRMaO+AunuW7r9dEXjTMKDQPZG1MdyRP2hVojYGSq7aU5H0SHcasncAxEHOyEb+fYK5r9qq65LeWDRD4k+KHdT0P8LLzU3jiDcvU8axXo51hp0lXcwsSZ+DhmbudRX9kKDh7wwEX9FE4bEniy+IT/X/S9HQ+ZbIpkeRlctK0/dbj01sWpuODpfJ7i/172mUXaZfuwW1QJ8/IdmoByqUqtTCd3m1TFQ7oGGPh9bDipAkn6o1OzCPtlV1fg8ihOdLGuFiYuQAQko6ZD5KmnnOUb1DnH9tL47377EP8efiWnZUjuIqnW3FdPXKkv7dWqY7mJh8Tl78cpkJRXbqaFgf7/3a8PpMe7b2UWeGds1yrSLqpe
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(136003)(396003)(39860400002)(376002)(230922051799003)(186009)(64100799003)(451199024)(82310400011)(1800799012)(40470700004)(36840700001)(46966006)(82740400003)(40460700003)(83380400001)(426003)(36860700001)(2616005)(107886003)(7636003)(1076003)(336012)(26005)(8676002)(8936002)(4326008)(110136005)(316002)(2906002)(47076005)(5660300002)(478600001)(6666004)(7696005)(6636002)(54906003)(70206006)(70586007)(41300700001)(356005)(36756003)(86362001)(40480700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2023 12:38:59.5680
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f73eeafb-9e13-47f7-ba14-08dbfca1a55b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D4.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5248

From: Feng Liu <feliu@nvidia.com>

Introduces admin commands, as follow:

The "list query" command can be used by the driver to query the
set of admin commands supported by the virtio device.
The "list use" command is used to inform the virtio device which
admin commands the driver will use.
The "legacy common cfg rd/wr" commands are used to read from/write
into the legacy common configuration structure.
The "legacy dev cfg rd/wr" commands are used to read from/write
into the legacy device configuration structure.
The "notify info" command is used to query the notification region
information.

Signed-off-by: Feng Liu <feliu@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 include/uapi/linux/virtio_pci.h | 41 +++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
index 187fd9e34a30..ef3810dee7ef 100644
--- a/include/uapi/linux/virtio_pci.h
+++ b/include/uapi/linux/virtio_pci.h
@@ -226,6 +226,20 @@ struct virtio_pci_cfg_cap {
 /* Admin command status. */
 #define VIRTIO_ADMIN_STATUS_OK		0
 
+/* Admin command opcode. */
+#define VIRTIO_ADMIN_CMD_LIST_QUERY	0x0
+#define VIRTIO_ADMIN_CMD_LIST_USE	0x1
+
+/* Admin command group type. */
+#define VIRTIO_ADMIN_GROUP_TYPE_SRIOV	0x1
+
+/* Transitional device admin command. */
+#define VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_WRITE	0x2
+#define VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_READ		0x3
+#define VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_WRITE		0x4
+#define VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ		0x5
+#define VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO		0x6
+
 struct __packed virtio_admin_cmd_hdr {
 	__le16 opcode;
 	/*
@@ -245,4 +259,31 @@ struct __packed virtio_admin_cmd_status {
 	__u8 reserved2[4];
 };
 
+struct __packed virtio_admin_cmd_legacy_wr_data {
+	__u8 offset; /* Starting offset of the register(s) to write. */
+	__u8 reserved[7];
+	__u8 registers[];
+};
+
+struct __packed virtio_admin_cmd_legacy_rd_data {
+	__u8 offset; /* Starting offset of the register(s) to read. */
+};
+
+#define VIRTIO_ADMIN_CMD_NOTIFY_INFO_FLAGS_END 0
+#define VIRTIO_ADMIN_CMD_NOTIFY_INFO_FLAGS_OWNER_DEV 0x1
+#define VIRTIO_ADMIN_CMD_NOTIFY_INFO_FLAGS_OWNER_MEM 0x2
+
+#define VIRTIO_ADMIN_CMD_MAX_NOTIFY_INFO 4
+
+struct __packed virtio_admin_cmd_notify_info_data {
+	__u8 flags; /* 0 = end of list, 1 = owner device, 2 = member device */
+	__u8 bar; /* BAR of the member or the owner device */
+	__u8 padding[6];
+	__le64 offset; /* Offset within bar. */
+};
+
+struct virtio_admin_cmd_notify_info_result {
+	struct virtio_admin_cmd_notify_info_data entries[VIRTIO_ADMIN_CMD_MAX_NOTIFY_INFO];
+};
+
 #endif
-- 
2.27.0


