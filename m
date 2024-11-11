Return-Path: <kvm+bounces-31416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1003A9C39E3
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 09:43:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 334BE1C216D5
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 08:43:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB4DA17ADFA;
	Mon, 11 Nov 2024 08:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Om1Ecx2c"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2049.outbound.protection.outlook.com [40.107.236.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25BB01714C8
	for <kvm@vger.kernel.org>; Mon, 11 Nov 2024 08:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731314580; cv=fail; b=c35QyUVHg6GqVpMH8gmk20AgcodbuV7IJjdI4HGMq6rmyfUqFvlSAfzNKCKanNGtMH9gBVSMdVvhzl3FyTFQO8yzVDQphve49FdQSQ45VRBmz/tYjCaFePUBSKOHIElsVjSrS7jANw6/0IZ9ohybxHa+u7ob9tfhKwpo5jh8+Ok=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731314580; c=relaxed/simple;
	bh=0UvZ+SfETqUM8evMg8qrOMY1/59yOJAFQwWInV2JgdE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gG2RKfgRbbZSoy3Ex5h4aJuVCVkh6P66TncptiiOrkmLiaCy3WI9M6eGPHnERH202XC+V4T4fRXQAfIH9VnxSX2HLRIelXPxLwWZbqRQTC6C7I7poQ3Je/EhEKCfGcCzWRNxrB9pVb0tz2hBZIiUJAqoIU+5yWoEW/H8Q9GCBrg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Om1Ecx2c; arc=fail smtp.client-ip=40.107.236.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KE7b7rixYw6NQ9Mv5AXLf/hTgi3w7oHFQFRppsRYwpjRoMpgZvECIRhCu5yjdWhNq5/TrEjS+EFvgptXBva5frTAfdlxMjrLgBVEeH1Or8KTj5e+uTYyuMTN/vhpVyIuobj0xYb1csnvbTqteaFgj9zi/9BJinrz7mnrn2zL4E5FY0zPwcvVsJgvhETsgmecBzBuE8F2ngX+tQGHBTFDy+xlOvdDehT5Jk3NAHFAYzsqnhCWRmO6a6mgdPe4TS2fQoB0jrqWEc80h11GwIUZC2JIouonv+VTq26Kah5HTfYXw+gscSE23zgGcGnbBneiAsOmhP84+B2ru0Nv0KhhWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FmtJiXU1fa9KsBEp20lkRQC5T0UJXnWKwHLeQei9VfU=;
 b=jDL7FX/FRh4c/N0VreTLD9A+BXumvVol+swOIUsCGc9EJTalhFgmmkD/QO+WTmIohRBPyljjQoUN5ylFkIiuob1dvoCjePjGlujz1J/Lb++hYk5ftlUgCC6OfXENbRza1t/ZCGQC6yxiYg7Qeb7ZGKEOOKhtDUPq+QDyms4wWOl0NfDEhbb5QsYA8Cdj4DnYnMLXfsYD9b+5wzQhhnXM6mB1AYlRE6b/SbIKZyMGaRxPSKWa5gK5QQWQp/Lc5rFRHZgJTjeJU4yIUaclfRA/PazS6h/F27W1XevGU4BIthOXHeN9+5exO/ZHbJoqubzgheujH6btfPACPpysi4sIjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FmtJiXU1fa9KsBEp20lkRQC5T0UJXnWKwHLeQei9VfU=;
 b=Om1Ecx2cNjHynLox+7iMUtdPykOm+izIE7jlBoA3knSvXoQhA0WSFEGdz9dWkVSpEDUQUW8M4bmLczE4vb7IaQgDDhLejp5/PqgRfATloo+itnpK3fiAPjsqADp13JYDiTV+Uw2X4tZMr+0EOl8sWIenQsy+RVeb6uEmMkAnOv+KiwKrzlsyPEQqL9w+yOO7+JVOVFkaG4IAQ4smRhz+lxTR0RiOpidmgB0tPJ7xZ3P6ZFy4mnPeSU4bphgPHl7gEYSSYhoyQIdXeGe5SlQm8s5FWSCdvS1vtSrBqNpTAHIbibego5xeqBvg6D9WDXDL5IjMmxHXpW2A+muHNHPkyA==
Received: from CH0PR03CA0192.namprd03.prod.outlook.com (2603:10b6:610:e4::17)
 by IA0PR12MB7579.namprd12.prod.outlook.com (2603:10b6:208:43c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.27; Mon, 11 Nov
 2024 08:42:54 +0000
Received: from CH2PEPF00000141.namprd02.prod.outlook.com
 (2603:10b6:610:e4:cafe::37) by CH0PR03CA0192.outlook.office365.com
 (2603:10b6:610:e4::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28 via Frontend
 Transport; Mon, 11 Nov 2024 08:42:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH2PEPF00000141.mail.protection.outlook.com (10.167.244.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.14 via Frontend Transport; Mon, 11 Nov 2024 08:42:54 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 11 Nov
 2024 00:42:42 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 11 Nov
 2024 00:42:42 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.1544.4 via Frontend Transport; Mon, 11 Nov
 2024 00:42:39 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH V2 vfio 3/7] virtio: Manage device and driver capabilities via the admin commands
Date: Mon, 11 Nov 2024 10:41:53 +0200
Message-ID: <20241111084157.88044-4-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF00000141:EE_|IA0PR12MB7579:EE_
X-MS-Office365-Filtering-Correlation-Id: 87a9593c-f31c-481a-cf8f-08dd022cd5d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024|30052699003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jNbdLn98cacf0O5qz1WZHK+s88AB3BQnvcFARyL4pnwVd2BPEq5YZC5zKEi2?=
 =?us-ascii?Q?QqJ/+z/JcuGfjnaGX4aKGAq3sWASBYFaWS9RyPBxBLFdR9QjnPm7kPr5xNeq?=
 =?us-ascii?Q?OSE7ZZk6v3XAIKgr+U5wHi8zrLh7Io68Z7WjD6uT4kOq40fk8jvePKd0ua+A?=
 =?us-ascii?Q?qolqQM6xbUtB2UgO1QZYtWi0i9U8GXbv27pJlp/CcEf9ksQ7zs4wHjs8z+B3?=
 =?us-ascii?Q?XomKcjG7tCthB2dUBDG3JvT7kjLsnsNIX7PSs4gsqZWsQk1YK21QaU4RE1HK?=
 =?us-ascii?Q?NXPctXC6BGYr8MPggTWvE1dDTv+FWgPgQEa/fViVS8aAonHTiTt4FeQwU+8I?=
 =?us-ascii?Q?EiDfnar0dt9SdJbkwZN8pVYyT+elUgTuPeS7Cnc7HGmNzgIWHeQhifpOYmdy?=
 =?us-ascii?Q?VyzUTjDqxslWpE5SAISj5OtVZrPFU9Jb6RlI4N15x4HfHE9znGWXh0wzlrsU?=
 =?us-ascii?Q?DsPoMB3nPF6SDfz01/WHDmv4teB7hI/JqbC59YF/DVDnV367q4vTQ1fCINu8?=
 =?us-ascii?Q?VDqwjsXU8tQFtsnRoJxtMkFoeFrgQwrcx2cmEhzNow/05DpiIWoDeHrH6gOq?=
 =?us-ascii?Q?vfrGBlbeICs+AYjBQl1P+aSV4q64WA1cknuTXI4ov//b0+U5Q0ha/TV4dKba?=
 =?us-ascii?Q?pBqsMnDWqLuVmtlHPzKTEjr+uWi8biJp1EDRUuhTarFpgmPbdayfxCyJPBTI?=
 =?us-ascii?Q?tjmF3rPMOO/HE9O75ZRyMXjqqMd/4LN2EqC3elDRfvGV3kiRmv/FpMc/CdQq?=
 =?us-ascii?Q?h8ak8bIBwNbJBOAwdte4rhIiDLhkU9bfQRYPTzexenmHILPuecgvd/N7bdoc?=
 =?us-ascii?Q?MWqepxGG9bShAWaixOqNxBZa/XHPGSPCteI29Yzb0BE3NdyB877NGScLF4L0?=
 =?us-ascii?Q?ofmL5BAukgbR2voToTj3zFdQMC7H8mCQ+2QfkhvgdJEQbBLWiQEsavWFvD+a?=
 =?us-ascii?Q?y8q/wYUF8W/0cygeyY6CXciwVK0elO8gN+azxvEHcyv8krbXNhOR0006XP1i?=
 =?us-ascii?Q?qJQPqz1Hf5Y9SU85NYdYy+qW0t1wpJlYFRAjELBO8gmI87qmCA6P+dvmKuPU?=
 =?us-ascii?Q?Kl5yGdRaWL7tDbnDwjIie9djDdLSTiGl/HCBWZ1WwvfPUzeDMyjlFrFn0PCs?=
 =?us-ascii?Q?FyT8vlS3n+kzQGBBsjcS1dOLswFygMCrcc9ANXvTAIiCpycIq7ijH3VOi7l+?=
 =?us-ascii?Q?zaxif0jIDooxwuKkcKhWB5vk8NTeEAyFhA/u0pKCIS9zWWLxsmcIhrxhN56i?=
 =?us-ascii?Q?OOBkGZykFF7Bus5wAbDGdqpKogYyxs3Favi8ulC+nSdUcLp0rto9ybEcQ+He?=
 =?us-ascii?Q?MU/sEo4DbMeHfegAeYoz1iuIZ34G8W6M724pC1J09gVP2pd5n+K8PySNN5A3?=
 =?us-ascii?Q?MGIpuH93TpV5c/pbu5kLDu2Y1qli40SfIDs6uj0SISTPPD91jw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024)(30052699003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2024 08:42:54.3873
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 87a9593c-f31c-481a-cf8f-08dd022cd5d1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000141.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7579

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


