Return-Path: <kvm+bounces-1574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD00E7E973C
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 09:03:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 77A5E280C58
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 08:03:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 476B5171D8;
	Mon, 13 Nov 2023 08:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rmy3rkuf"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851BC15AF6
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 08:03:30 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2053.outbound.protection.outlook.com [40.107.223.53])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F14210F1
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 00:03:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kGoBWjxe0UbWZ3NSeIto8SkjwD+iKkBQO94X90ndgESopf0xQuPS5l7qQROQwUGjq+3607ZpLuNzNiRnUttEIWyOtF9zC7XGJqY1jtG3kCEqw6IY8dPUgFsyqHWxEfsD/07cYvaHBdrlfMnUnQ/1cWoLClcda56jVz6bvkPbZ6HX9ybEuXjZQgCCSj69q4eQMyf46Z0qsNHjsan5yIqZDuYBxjOI2iT+OWaPESD1wxxDIvi2nLGFaoKNcz5nDEhTEYv3Cs7W+ZJ58F0MB7bK38Rn9ZdbGlfJ8IAG38006t0xSK7aLMKtBpTZp8jnht9JYyFs0LVxisM7jM2Q4Ijbtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NVd3QTSNc8vsyVjcBY8dwbqL2bQjTL7Jm6gjNqazre4=;
 b=HQFDsYVq5xdZt0ACxxVDas1w/t7D/DAXVA/0VlsoCG6OriXW5RQXnMp04qESkD0q1FT8hXIy9CINEuPgf26xlaO4W09gRUUwte/4aii7U6WZbSrsyeUZ2nglv4G5gA9r72IpzmAN46b/rrBI2WLDr4URgtlck6ZlNTVViBdtDUpbyl3zBbmLw2OXCPRICC7KQQTalmubLcrgxLaaGJHRopauX9Yl0xq48sc+NVp1J11HkSdX8HuQK53z7JO1IrnazwFFWgelzHwcZ/lSaDf8GZM7ELXcCTx+cwIp4rW+Jc3pUC5CTUIl5QDbGTt/fTnEwTCFO0J5tkLIozv2veKL4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NVd3QTSNc8vsyVjcBY8dwbqL2bQjTL7Jm6gjNqazre4=;
 b=rmy3rkufas7rGzJ1F4untfeKBN0p8aJkynxLhH5bj7OJH/BdViZTs3KhP/LJqzQMEPFPOmkillUPYZBnDZC3BUph7VgtY26+NNEs432MX/BlCq3alYcamE4NwEWN+8QD+O5nP43KhpXClzzpKygKJDSnmp+po/x9ecVmhOWyPb80Tdv8zFCRIC0WWIHfHDL4OgDp0trlSYi2UikVWZ9747tOQX3vQFvnLsPWAuD214KuoOiTsD6Mxc0oUqY1iZ3UZuB5I/xnwqZe/OBFaKdC4hld8eCDrD7aqe9o9dday+7uv1KQ23KXrV4emPB7FT8vstt2oyg3EJPEn7ujbF+CFA==
Received: from BL1PR13CA0296.namprd13.prod.outlook.com (2603:10b6:208:2bc::31)
 by SA1PR12MB7293.namprd12.prod.outlook.com (2603:10b6:806:2b9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.29; Mon, 13 Nov
 2023 08:03:23 +0000
Received: from BL02EPF0001A103.namprd05.prod.outlook.com
 (2603:10b6:208:2bc:cafe::17) by BL1PR13CA0296.outlook.office365.com
 (2603:10b6:208:2bc::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.14 via Frontend
 Transport; Mon, 13 Nov 2023 08:03:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL02EPF0001A103.mail.protection.outlook.com (10.167.241.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7002.13 via Frontend Transport; Mon, 13 Nov 2023 08:03:23 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 13 Nov
 2023 00:03:12 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Mon, 13 Nov 2023 00:03:12 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.41 via Frontend
 Transport; Mon, 13 Nov 2023 00:03:08 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V3 vfio 4/9] virtio-pci: Introduce admin commands
Date: Mon, 13 Nov 2023 10:02:17 +0200
Message-ID: <20231113080222.91795-5-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231113080222.91795-1-yishaih@nvidia.com>
References: <20231113080222.91795-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A103:EE_|SA1PR12MB7293:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e6d0604-1bfb-4833-eb76-08dbe41f0232
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	g7zmk5rjSfOJepEb1Io854BpfvFEyRzJpV0Ho+yswmAv/c/9yPNmlm4O6gAK7XlPz99eoGITgHI95H/FdobqX9mDb2wEwyVzTHhb3E5tx1Vh32pDii5LzU1KUvhXg1Jagh4lua3knr+dKozL/rJ43CLK7IjplrEDx40MSS175Jkrwvc4Z7MP6via07NkteXsMSX40PXbNKezKgdivUNBylSEhpHWMUTfAcNFD4q6YjXCljv1Tvde+7TNco48Jd14xV/thFwEeQib6wm0LAdxqmyoToefzbqbzEOFskfSkuXUeA5wqQdFemvspYsQJKUEYyQ5fNFclOaZZHaiXADwRCTSdsVcJgfyHvDKgcleLTA4o3nwJrRdb8/rbapV7LxVdX1vZSqW3WshN5yUQ8x2nlP7G7j+8uV9O6+5r51d8VfygLb3z0SoQtDHFpcbvSVOZbvT4MNI4QxDYGUWcB0ZQFWG7xbrHupGDB2uDAg9P9uAMVrBW1PRjO1wirkMzVfUvw2cKl5TdzHyIrCXcaLjfRNR+WZcj63IdxHfv0sGt53egyQM9w94KaPr+aggkRhVRH4mbsnKThrLTmeodeFYr2nJfsKNxGTa+W0JBlhqR4mr7CcnIifv+eRoD+5WRuEM2ugyfkCs8hFWr5+1PtvtttGyCQLMXQu+V0NoSb/3ZyPSncwD9un7U599tIZxVNJzNMO0Cdrt8v4t0lwdXK0V88YW7yxIeG4z4CsJIatx+B6djqgA6nvF771EOj96E1C3
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(39860400002)(136003)(346002)(376002)(230922051799003)(82310400011)(64100799003)(451199024)(186009)(1800799009)(36840700001)(46966006)(40470700004)(40460700003)(4326008)(8676002)(8936002)(36860700001)(1076003)(26005)(2906002)(5660300002)(2616005)(86362001)(82740400003)(107886003)(7696005)(356005)(426003)(336012)(47076005)(7636003)(6666004)(36756003)(478600001)(41300700001)(83380400001)(40480700001)(316002)(6636002)(70586007)(70206006)(54906003)(110136005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2023 08:03:23.3036
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e6d0604-1bfb-4833-eb76-08dbe41f0232
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A103.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7293

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
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 include/uapi/linux/virtio_pci.h | 44 +++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
index 5ef12a877d6a..c6215df9b1ea 100644
--- a/include/uapi/linux/virtio_pci.h
+++ b/include/uapi/linux/virtio_pci.h
@@ -212,6 +212,23 @@ struct virtio_pci_cfg_cap {
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
+/* Increment MAX_OPCODE to next value when new opcode is added */
+#define VIRTIO_ADMIN_MAX_CMD_OPCODE			0x6
+
 struct __packed virtio_admin_cmd_hdr {
 	__le16 opcode;
 	/*
@@ -231,4 +248,31 @@ struct __packed virtio_admin_cmd_status {
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


