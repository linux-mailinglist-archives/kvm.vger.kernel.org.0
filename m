Return-Path: <kvm+bounces-3675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B986F8069E9
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 09:40:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 647CC281BD9
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 08:40:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E58811CAE;
	Wed,  6 Dec 2023 08:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aufEpRqt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2057.outbound.protection.outlook.com [40.107.93.57])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E321BD
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 00:40:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BC2BTr6RPhrWNFOdGWdiB4p7sychmzO09+ZPODtB1L7pelMvkdDiPUq+VvRa6Y3YZvyIL8NKkXTHY5PqEuEyk0UeCeIb2N/QmzDjzN5pJv24vMYqQos9gwSFj8yXXjnBAYy0cRrE74Huc+Xwjob1T9OQLHtk9uxcfODE+7aFaLzEX4liY8PuEccGornAxnjgYtFkxjRwIsudniKt6t2uYVzpzGfXwhL/wASsOWdNGdRkd1VNkJvYG0SBrZgDVL8ZTYxJ+J4dOuzMI9kFLWlFJraxVhJ2vRl0zqQKxADWkyEtAUZRX9GqsgNKRMAgqmgoGQBZ1wCUyygjf2y3hxH/LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=szqSpjH8gveSqBHOKS7GHJvcjlJTjHrh3TblVtqYI7o=;
 b=hIWCLQGGEAE3dV5OF4cgzzZjz/5GiL3CAFN7qXphj4WyNNAU3J+0cJVujo/DVbOPa9O/ABLlXl1Lj1LHZi1NXFktINgyUBwnWPMQOflb8AaX40fNqdCmzZlf5FQz7vWCWuqXIjzUKk33gqtGtCd2AQxs3InTBX3p8fMppr+245gU7WSjC/mAI/j3XC6x3S2DqMMBxcByXrCPBRGsLl0s46MVBcA5xlAITEDbU31YYqBbU3oxIN+fyzwVw39nWn+PXU5fxOQzxKAnznPodUFPmVKO/fy7pdY4R272LAVQyQOOdYZcHUgZEvhzaECFzg3nuRWf56yEQlajyY/J1n11jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=szqSpjH8gveSqBHOKS7GHJvcjlJTjHrh3TblVtqYI7o=;
 b=aufEpRqtE3oRAHQB19my9F6k+TjWWmSSxyxQaGVAwgJYJqO4ueHO0pKJ2jqdwQpwwyclpRwzLXaZlx0/JlgIcJDbp5x/r88YCUNvTF4FeBwDF3ShiwTYRQHoU0ONtTxmqzFfQrZC7ocaOOtMW0v0oB7QXWYqyAV3wi9ROLc6A7mczFXctUxFIM7sXmvELV0InPXOjk8NLitfauFQ3siOYHfB6lHTZrwSsIkV+Xnlw1QOGWdPBsPuY0Rxq50q8lmUNzccTDMqUXxrGHgQbKbXVrEQax4YaWfkICp/srahmoOg/nltXWsTkaJAuOTf+TFcg2wAcaysYt2n3DWRmNxqaA==
Received: from CH5PR04CA0020.namprd04.prod.outlook.com (2603:10b6:610:1f4::21)
 by MN0PR12MB5762.namprd12.prod.outlook.com (2603:10b6:208:375::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Wed, 6 Dec
 2023 08:40:09 +0000
Received: from SN1PEPF0002BA4E.namprd03.prod.outlook.com
 (2603:10b6:610:1f4:cafe::50) by CH5PR04CA0020.outlook.office365.com
 (2603:10b6:610:1f4::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34 via Frontend
 Transport; Wed, 6 Dec 2023 08:40:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF0002BA4E.mail.protection.outlook.com (10.167.242.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7068.20 via Frontend Transport; Wed, 6 Dec 2023 08:40:09 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 6 Dec 2023
 00:39:55 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 6 Dec 2023
 00:39:55 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Wed, 6 Dec
 2023 00:39:51 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V6 vfio 4/9] virtio-pci: Introduce admin commands
Date: Wed, 6 Dec 2023 10:38:52 +0200
Message-ID: <20231206083857.241946-5-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231206083857.241946-1-yishaih@nvidia.com>
References: <20231206083857.241946-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4E:EE_|MN0PR12MB5762:EE_
X-MS-Office365-Filtering-Correlation-Id: 71bea0c6-b9d3-4fa9-a7cf-08dbf636f46f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	tJAbXUWXLhTJWqL4Qqp0qp7U8LhS2HL8AZJhGyBSDyBPqGdK5mr/JgspXPeMxOIawU6BPxVF05LnTVAdQ2pSH7c2KNgPUj7LGwq//jxpyRaBInK7QiqufHJ2IZ6VFxymmTdZae5fYy0EA2DTNRB93VKVpyG4qL2qFRnO8dGOCgD4bGkUYxN7eA3LncqgdsvH1xF5F2XlMWTYgRRDrMIAKsiT8LUljIjQo9ZQ9SP9EFbhnmyKlTB4FXUYoB2nyr76EJsFw7Y/XlW5S8Ncc6eyvezpgPqWaA0oVEtChDFEgKcCtCZeVoch1aLQtUHsmfYapzZdpal+tfavXI0BZTDle6XHggq/UiYKYYO2EtHgz3bt6VV7W6GkHWZrdKA3UzO/ipYoXgi0P8ycSjI/KuGwyfgAUNmhz/PhfQFD7FU4LND3pWr7g1kF1sRz3FmA352IHqaJDVdbFKRq6TAXZhqKFyhqri3moI9sdCnidAMb2LjEmplGqYbjx3ABND/wKJkeIvwS8Wm1YMoxQZvA8iP/84t87eAKZIabu+LeTQr1Ib9nB0VhkCY8P7/7tnuCXHy1dgm03n8xYRtOI+c5R60LKRus8UetXOGRB8c8/a53perGYTVWZkeCN09Vm5Su8OqqbWTmOxeTpA8QcLgI4tYML1+O6xNvf04onKO9s6SaOdxw+2P8zXty3fRLp+oHZGy04hDW+hFDy7udfLg+qEpfSAsi6TueDJ4SXIvDtI/7geNfNZqvThLXjesKSiiAk3/J
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(346002)(376002)(136003)(396003)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(82310400011)(36840700001)(40470700004)(46966006)(41300700001)(36756003)(2906002)(40460700003)(5660300002)(86362001)(336012)(107886003)(40480700001)(2616005)(7696005)(1076003)(82740400003)(83380400001)(26005)(426003)(478600001)(7636003)(47076005)(356005)(36860700001)(8676002)(4326008)(8936002)(110136005)(316002)(6636002)(70206006)(70586007)(54906003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 08:40:09.1432
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 71bea0c6-b9d3-4fa9-a7cf-08dbf636f46f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4E.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5762

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


