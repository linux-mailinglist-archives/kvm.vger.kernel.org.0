Return-Path: <kvm+bounces-31731-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 99E729C6E55
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 12:55:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 535AB281838
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 11:55:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F38B020263C;
	Wed, 13 Nov 2024 11:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hSNJ+cTa"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2068.outbound.protection.outlook.com [40.107.237.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4601B202657
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 11:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731498793; cv=fail; b=Egc8h6Ns2bNoGUFUZtV8se+izOu/9BbGO+MkQbfof3r+Tgme1M+DOjGO8n3QRkEER0JzFc5bmQa9kD3XhSG7m3B6gwnR2vNiEpwdjQFIn4FEX9BCj76jWGvoWjzd448SgfUllKuZlUO3ULLrLvDsBYZNRHZbNwAWO7sAiG/3vpo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731498793; c=relaxed/simple;
	bh=0UvZ+SfETqUM8evMg8qrOMY1/59yOJAFQwWInV2JgdE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T06VNBnlLTv7rDblzlKrOrM2LzjKotdCZ43tTykQZRy8BJ0VsiCtwQNhcRJpzNYIGvIubJriu+iJv8kmEHGhRSUlWuG/QJdHXySHQOWLqxfeE9mJhYKT4cnGa2Gr0DUTXBhCyqiFyqrQVFvLYWZaLN+j/Z8vHkSeSMuBSR4FKKw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hSNJ+cTa; arc=fail smtp.client-ip=40.107.237.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KhLMUMThAJXIh0n4lz2nJ1vvU3yFFCSNamuI4qQjVIoSVP+Uud/aG0zseMY0ve7i/8ZFiwHZ5L3jxvC2YcsM/SDkbAiFZIfsiVcBKU/5UZuCIfQw5sYqHBpQYSoaeccnEgnIQly4JrSoDmKZJAH7U8/9ZWnbUpa46hVsA9/IMI1xZpZALEz0HBr7rAIzfhukSyE+U2tQ7BuYN26BR4DlnxttyKVJGvrHDviJEOwHUCLCbcU+wQqVP8azgUiA0pI0QWbWwC2E7GFAcOzpfmEm35EHiWDwkfkQSKtLecUpkl3QwMWFSXSFlO95chzyrrQlT9bCcLvvayobPG94z1Eiyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FmtJiXU1fa9KsBEp20lkRQC5T0UJXnWKwHLeQei9VfU=;
 b=l/uWcc1KumrI60CQIL50FTgbE1zWjn4HsDOPGHqjaP9BOIlYPhf+Arlf1ZfVgivT3SQrpUOYx+OrBrECys/rhYv6Sy/tdpvcbgAi4gzrs406hrb+hmY9CJhmm1RcQRzbo1PNfqxHeyss1EsXlHE0zy1OLZ1fSgxbQ34AUj4ArORBM0louPzxXkuHqWnyd5eIor8L3Af1l5y/AgxFnheUeMfAQgzNc6I14LrWcIV8tEpqH/wAdISbOtzv9XZilvJo2WD137uy0onG8zyyKE0yalVVhA2FzcRAWBCrbUnjiTT8at90o/V18A+agMhqgA+otLrzZ2EougtXB3iCjmqVAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FmtJiXU1fa9KsBEp20lkRQC5T0UJXnWKwHLeQei9VfU=;
 b=hSNJ+cTauv03v165VT7WCPcbK6pZ4CgBIe7aNQGoAVs/XrRhEgJMbGl/tVzyT5eIgtlawCfJKjE9c653EbYHtS4CY1CqJGMCMBF4G9tgk+TO/4ZcbNGmqSFnWpXsMGXhheB1fuPmgR4C/LuJuaW8YqReDyWgDqzqz8o34v5hYqvs47njrWK7zDt44FJLletHOpwwMyUczVab8GoJt3VPr5M3ehPCiGyGY95vzGO/0np9rraOJ6rQhzZFZIOgicgIpjrj2c7Kj3WOQOFE6i68WWiUXS3pwXKStW+kJQPrDzFKIx4wJomndPctKlVum6mf+RsF+GH2LY2ZAcppJuOQow==
Received: from SJ0PR13CA0170.namprd13.prod.outlook.com (2603:10b6:a03:2c7::25)
 by BL1PR12MB5755.namprd12.prod.outlook.com (2603:10b6:208:392::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.25; Wed, 13 Nov
 2024 11:53:04 +0000
Received: from SJ5PEPF00000208.namprd05.prod.outlook.com
 (2603:10b6:a03:2c7:cafe::e9) by SJ0PR13CA0170.outlook.office365.com
 (2603:10b6:a03:2c7::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.16 via Frontend
 Transport; Wed, 13 Nov 2024 11:53:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF00000208.mail.protection.outlook.com (10.167.244.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.14 via Frontend Transport; Wed, 13 Nov 2024 11:53:04 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 13 Nov
 2024 03:52:51 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 13 Nov
 2024 03:52:50 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.1544.4 via Frontend Transport; Wed, 13 Nov
 2024 03:52:47 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH V4 vfio 3/7] virtio: Manage device and driver capabilities via the admin commands
Date: Wed, 13 Nov 2024 13:51:56 +0200
Message-ID: <20241113115200.209269-4-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000208:EE_|BL1PR12MB5755:EE_
X-MS-Office365-Filtering-Correlation-Id: cedf699e-594a-4b17-922b-08dd03d9bb56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013|30052699003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5MEAet2hUates5/VmnNHARvlVV9Kp8lAjv+tKDGCMfcw2wNT0NqLKnkjB0ZQ?=
 =?us-ascii?Q?/LuXU3wMi2ABozzGxefY6+4GJAI/nWouwtEkOkvS9Lya26c2NAQQtHa8NBsG?=
 =?us-ascii?Q?BZaHSFWSfbJDtBSWB3bslFgzNhXf2u5PR8O2bPtgtj7wduBlri6Agm0wHJUy?=
 =?us-ascii?Q?JbhxFIoyqCxB5KrNHqe4F9fhXUfnvz6eRELQwdgNqkqZ2w0QSBbnYia24A+t?=
 =?us-ascii?Q?fbxYyWBWbHPjeBYgZftigZLfq/VOwCShtDPWoKzc40H2dkzPRjWk2z4vIWsT?=
 =?us-ascii?Q?+piD2vKhVrtIDW9wlw1q9HMlxRIkk+jX6YA4fP7se+xhljHSbMntCS+Rev2e?=
 =?us-ascii?Q?xiNKIjUj5yTMak+EEAanPzeRI2NVPH7tcbIuC67oGmppRIS5y09MOo+KcKo0?=
 =?us-ascii?Q?06/XxG9uDeMtkX+cR3ycOGSHVa5KFy45/q3G+erU0Ze+I+t1jAXPeKFOJs6W?=
 =?us-ascii?Q?IQ/2wH1be8irqdrnTHvF35B9jmcMMFHDNdaewINDHITlCzC+a27YqzlW0Og8?=
 =?us-ascii?Q?1PBgJp/ojTx62Qbj+JPa0Q/HuDLkha0rQ2rK6sginPUQajfrjWGmWbT/igx2?=
 =?us-ascii?Q?0rN5HVKpHHXdQlQcRsWEN2pJ8PQcKfSbutQeY+37ubZdQo1c1NW/ifvNWouR?=
 =?us-ascii?Q?L/lk8Z5Pe+Cm4cAGWQ10L5zTqEmyrWQWOdTArgb/nfCBYUOOFKqBmgav9qQb?=
 =?us-ascii?Q?SaTx98TCZmyDB7GDWGWPd1INBIUTAInPn2iFY7ojvNW8Gav+CFyKzwacNGoL?=
 =?us-ascii?Q?E4Us5IZ3orkYbJhtxIA3rYyME/PrhUTeZYb0g0vS7Wb0nOkrUTWcWS8MMc+/?=
 =?us-ascii?Q?LKqjNHaIPqnK7fdcJP85SGjcVzrCD+WAFNuIc7z9H6y+fGbOzB4XU5AjlDgD?=
 =?us-ascii?Q?tVFYq7Wui1I6XsgB6xXRCUFvUDEnKlbaGdjzcJHiYfP/IerHiH+e2x4Wkc0j?=
 =?us-ascii?Q?ZXkSH8EOPHwlyFghAbS4tPHPSgm2HMwQ7MdruHH7oopbqOfXPvisiA95yWN4?=
 =?us-ascii?Q?S9qEJM5kUiRRbYKpSYycriizRmZtbtR9e8zij9xGXuVxc0AGEYHLnO+k5sBL?=
 =?us-ascii?Q?+h0uJN4UO+bF2qZ8pvTb8GM8/Gg1j4U1N7H4T64fzrm8pjJmD7y+iggD7c6Z?=
 =?us-ascii?Q?dvauxsWA7KAtz9Wopqgsv4iNwZJjf7TYqvCQrN+iIFPh0TD8EZHwGbRW4zmO?=
 =?us-ascii?Q?uG7/GEMRynoXJ9NDC3AsDIWnDt9sDS8y8mjXsvHkaSyHCc5TpDkDyb97mI4+?=
 =?us-ascii?Q?Sh4EDW9+YQF1Nc/hhk49LrkqmNjpKVWWW+qzvb2/Nyw7r1BCSjNFLhRp2xlM?=
 =?us-ascii?Q?Ua5EXYN0hHSHtKDSs5YO6hp3jS2i7EtEOXld4jXbPgsl9znnG7INxf5TTBXJ?=
 =?us-ascii?Q?R/eyMeHJRIg78iANmkPtPci6dT7bpU3bUcY3z6Rok09hs+Bm4Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013)(30052699003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2024 11:53:04.1027
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cedf699e-594a-4b17-922b-08dd03d9bb56
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000208.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5755

Manage device and driver capabilities via the admin commands.

The device exposes its supported features and resource object limits via
an administrative command called VIRTIO_ADMIN_CMD_CAP_ID_LIST_QUERY,
using the 'self group type.'

Each capability is identified by a unique ID, and the driver
communicates the functionality and resource limits it plans to utilize.

The capability VIRTIO_DEV_PARTS_CAP specifically represents the device's
parts resource object limit.

Manage the device's parts resource object ID using a common IDA for both
get and set operations.

Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/virtio/virtio_pci_common.h |  13 +++-
 drivers/virtio/virtio_pci_modern.c | 105 +++++++++++++++++++++++++++++
 2 files changed, 116 insertions(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
index 1d9c49947f52..04b1d17663b3 100644
--- a/drivers/virtio/virtio_pci_common.h
+++ b/drivers/virtio/virtio_pci_common.h
@@ -48,6 +48,9 @@ struct virtio_pci_admin_vq {
 	/* Protects virtqueue access. */
 	spinlock_t lock;
 	u64 supported_cmds;
+	u64 supported_caps;
+	u8 max_dev_parts_objects;
+	struct ida dev_parts_ida;
 	/* Name of the admin queue: avq.$vq_index. */
 	char name[10];
 	u16 vq_index;
@@ -167,15 +170,21 @@ struct virtio_device *virtio_pci_vf_get_pf_dev(struct pci_dev *pdev);
 	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ) | \
 	 BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO))
 
+#define VIRTIO_DEV_PARTS_ADMIN_CMD_BITMAP \
+	(BIT_ULL(VIRTIO_ADMIN_CMD_CAP_ID_LIST_QUERY) | \
+	 BIT_ULL(VIRTIO_ADMIN_CMD_DRIVER_CAP_SET) | \
+	 BIT_ULL(VIRTIO_ADMIN_CMD_DEVICE_CAP_GET))
+
 /* Unlike modern drivers which support hardware virtio devices, legacy drivers
  * assume software-based devices: e.g. they don't use proper memory barriers
  * on ARM, use big endian on PPC, etc. X86 drivers are mostly ok though, more
  * or less by chance. For now, only support legacy IO on X86.
  */
 #ifdef CONFIG_VIRTIO_PCI_ADMIN_LEGACY
-#define VIRTIO_ADMIN_CMD_BITMAP VIRTIO_LEGACY_ADMIN_CMD_BITMAP
+#define VIRTIO_ADMIN_CMD_BITMAP (VIRTIO_LEGACY_ADMIN_CMD_BITMAP | \
+				 VIRTIO_DEV_PARTS_ADMIN_CMD_BITMAP)
 #else
-#define VIRTIO_ADMIN_CMD_BITMAP 0
+#define VIRTIO_ADMIN_CMD_BITMAP VIRTIO_DEV_PARTS_ADMIN_CMD_BITMAP
 #endif
 
 void vp_modern_avq_done(struct virtqueue *vq);
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index 487d04610ecb..8ddac2829bc8 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -230,12 +230,117 @@ static void virtio_pci_admin_cmd_list_init(struct virtio_device *virtio_dev)
 	kfree(data);
 }
 
+static void
+virtio_pci_admin_cmd_dev_parts_objects_enable(struct virtio_device *virtio_dev)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(virtio_dev);
+	struct virtio_admin_cmd_cap_get_data *get_data;
+	struct virtio_admin_cmd_cap_set_data *set_data;
+	struct virtio_dev_parts_cap *result;
+	struct virtio_admin_cmd cmd = {};
+	struct scatterlist result_sg;
+	struct scatterlist data_sg;
+	u8 resource_objects_limit;
+	u16 set_data_size;
+	int ret;
+
+	get_data = kzalloc(sizeof(*get_data), GFP_KERNEL);
+	if (!get_data)
+		return;
+
+	result = kzalloc(sizeof(*result), GFP_KERNEL);
+	if (!result)
+		goto end;
+
+	get_data->id = cpu_to_le16(VIRTIO_DEV_PARTS_CAP);
+	sg_init_one(&data_sg, get_data, sizeof(*get_data));
+	sg_init_one(&result_sg, result, sizeof(*result));
+	cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_DEVICE_CAP_GET);
+	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
+	cmd.data_sg = &data_sg;
+	cmd.result_sg = &result_sg;
+	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
+	if (ret)
+		goto err_get;
+
+	set_data_size = sizeof(*set_data) + sizeof(*result);
+	set_data = kzalloc(set_data_size, GFP_KERNEL);
+	if (!set_data)
+		goto err_get;
+
+	set_data->id = cpu_to_le16(VIRTIO_DEV_PARTS_CAP);
+
+	/* Set the limit to the minimum value between the GET and SET values
+	 * supported by the device. Since the obj_id for VIRTIO_DEV_PARTS_CAP
+	 * is a globally unique value per PF, there is no possibility of
+	 * overlap between GET and SET operations.
+	 */
+	resource_objects_limit = min(result->get_parts_resource_objects_limit,
+				     result->set_parts_resource_objects_limit);
+	result->get_parts_resource_objects_limit = resource_objects_limit;
+	result->set_parts_resource_objects_limit = resource_objects_limit;
+	memcpy(set_data->cap_specific_data, result, sizeof(*result));
+	sg_init_one(&data_sg, set_data, set_data_size);
+	cmd.data_sg = &data_sg;
+	cmd.result_sg = NULL;
+	cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_DRIVER_CAP_SET);
+	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
+	if (ret)
+		goto err_set;
+
+	/* Allocate IDR to manage the dev caps objects */
+	ida_init(&vp_dev->admin_vq.dev_parts_ida);
+	vp_dev->admin_vq.max_dev_parts_objects = resource_objects_limit;
+
+err_set:
+	kfree(set_data);
+err_get:
+	kfree(result);
+end:
+	kfree(get_data);
+}
+
+static void virtio_pci_admin_cmd_cap_init(struct virtio_device *virtio_dev)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(virtio_dev);
+	struct virtio_admin_cmd_query_cap_id_result *data;
+	struct virtio_admin_cmd cmd = {};
+	struct scatterlist result_sg;
+	int ret;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return;
+
+	sg_init_one(&result_sg, data, sizeof(*data));
+	cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_CAP_ID_LIST_QUERY);
+	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
+	cmd.result_sg = &result_sg;
+
+	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
+	if (ret)
+		goto end;
+
+	/* Max number of caps fits into a single u64 */
+	BUILD_BUG_ON(sizeof(data->supported_caps) > sizeof(u64));
+
+	vp_dev->admin_vq.supported_caps = le64_to_cpu(data->supported_caps[0]);
+
+	if (!(vp_dev->admin_vq.supported_caps & (1 << VIRTIO_DEV_PARTS_CAP)))
+		goto end;
+
+	virtio_pci_admin_cmd_dev_parts_objects_enable(virtio_dev);
+end:
+	kfree(data);
+}
+
 static void vp_modern_avq_activate(struct virtio_device *vdev)
 {
 	if (!virtio_has_feature(vdev, VIRTIO_F_ADMIN_VQ))
 		return;
 
 	virtio_pci_admin_cmd_list_init(vdev);
+	virtio_pci_admin_cmd_cap_init(vdev);
 }
 
 static void vp_modern_avq_cleanup(struct virtio_device *vdev)
-- 
2.27.0


