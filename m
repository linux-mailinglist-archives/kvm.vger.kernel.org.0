Return-Path: <kvm+bounces-30490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FD179BB0F4
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 11:23:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 15DBF1F21AC7
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 10:23:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F0351B2194;
	Mon,  4 Nov 2024 10:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mW9OI928"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2047.outbound.protection.outlook.com [40.107.220.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19AC1B0F19
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 10:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730715810; cv=fail; b=cCkcbA3BiDaKNTt8r5AnQahOu8jKMS3efRHxgF2BCcUgr4qoxSIPDsKTLYWJ1Sw3WwNbQ2jWD9NYfGojybm/CeqNfoBrMyojmrIeZJL35sqMNUWga9uCgwIc8s+v2D/7GB0msLW/Hoxgyc34jCfWN/8ktT32sqbjQjLWA8acvM4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730715810; c=relaxed/simple;
	bh=0IRc4YBBhxR2KOTa9SR+LARqyNgQiRZ3SR4nFGaVv3M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vs0Z93MSaxbcNjkrlcB3dVkDZX/pYPOT8b3vs1PRpvRyEX/w3PtuosVAtk8L15KMrhVMf5DCzERZv/N13UFwJ/ToUbT5ivOOj8u666Vy74+iD6t5u/IIgfo0c3/66SgTGYNnwKSPFoG8xkoIRpdSEH7EsAt9CFDyjVHhSBXFnPU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mW9OI928; arc=fail smtp.client-ip=40.107.220.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eqT0B8msxwc5uQNRe5RkvhYClouKpEc3Kv/7RbccN9UP93JyB4cW0lw4oO9Ac39C2mABqz6+Zj1ZRzPoxynUcxUhtruAXzI/zws2JW2lnaoXPhg5edpDcyZrqE+yLsGFy1HpbnhQ3E1B4mrxF2V+ZDPRFPN5BsbJjRSEujMrYuXz96Qnen41jqOiy0+xceZeiJU8ZICpCrS3fATF3qWSzAWRvr3utYvnMGdsvoHSfAOxZaquThLLacJ7mDD2k7MgDNp/rIJrKXLHqbAwKylqGVkhhNcvzd9pwWK7c8EIZ3bOSoL9riOIalP5flgfMor/njJM5IoGKnxCZ8BXSLOm7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wm8kJeDJW1CXkRZzuISQ1o0G9+9IZ7pZbetpapbJuh8=;
 b=gpthMZpMmw4P52aBnsVxrGAhIh0bM+NSCXIf4bOjUhzZzp0tBPdPXD//+RfWir2lfoIB/qmbwl5rTmJcsRSoJBXZ3N1fC1VAZmGXOUNrIkB45l17AnW++ch7EK/6+r8nCwXg4QOWP39u7PkJiV5Xs60eZANsvasQNEl5NQdZ/FpW+cPY8Om0GJ5AfsTK1ewYhjowdM/SRdjYkYYhRSmrLJEWk8QENWGrN919Ar2r+TlE1lQt4sB0tchW/CgZfgDY8ciLPlpXkCB8oRNpXY3YbwEI6cihKPFjep9RFcm4uZZIw4/S1ZhOkimn2ZcrEgy2IqmbGqYiYw1PwSWRTbjIzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wm8kJeDJW1CXkRZzuISQ1o0G9+9IZ7pZbetpapbJuh8=;
 b=mW9OI928g+uTfTD1METxnAPGwvvnq2v+YbOi+c8xHeCJ1NWLb69j4dpNdFH1WR2/JNvB0nAcXVY/IpMa3lMASSnFqgHTi2SqsoDGi9FwZJG/u+dYGuReUre3EpDUjN33+WaSLGSmKGVRCgJvHp41B5ZOTKwBUN0D2cUHHHGj3gve/noMN9TueZEa75uobkestTrBhbrFXcxzTuOUIxHWfEjIH1eyY9AzyP+As5cP8vql9ouOpJB1nJghskEIA/ZsetCwSYlZcAiPjlyXWmAeuuz50Vzaiax0fP1kT5reJo+6u4qeaw1miMo7vC+HZorZffWvt1kRb+s6qr4FPmRiTA==
Received: from BN0PR03CA0052.namprd03.prod.outlook.com (2603:10b6:408:e7::27)
 by CY8PR12MB7563.namprd12.prod.outlook.com (2603:10b6:930:96::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Mon, 4 Nov
 2024 10:23:24 +0000
Received: from BL6PEPF0001AB4A.namprd04.prod.outlook.com
 (2603:10b6:408:e7:cafe::3f) by BN0PR03CA0052.outlook.office365.com
 (2603:10b6:408:e7::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30 via Frontend
 Transport; Mon, 4 Nov 2024 10:23:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL6PEPF0001AB4A.mail.protection.outlook.com (10.167.242.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.17 via Frontend Transport; Mon, 4 Nov 2024 10:23:24 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 4 Nov 2024
 02:23:14 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Mon, 4 Nov 2024 02:23:13 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Mon, 4 Nov 2024 02:23:10 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH V1 vfio 3/7] virtio: Manage device and driver capabilities via the admin commands
Date: Mon, 4 Nov 2024 12:21:27 +0200
Message-ID: <20241104102131.184193-4-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4A:EE_|CY8PR12MB7563:EE_
X-MS-Office365-Filtering-Correlation-Id: 311a6d0c-9e54-4115-58e2-08dcfcbab73e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|30052699003|36860700013|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1ZArFkDi3erFsPOhPl0+hEH645ILOhJ78NbQwMBTMFmV8EjNRp+BADc8ROC1?=
 =?us-ascii?Q?hayMMSDoGhyBTvYomZW/w5lYotFtbxxDNnCePhJbYOu5oc5UHLCkIz7j+3UT?=
 =?us-ascii?Q?5jBKHNZxz9pk9w7B7ZuSYVlIMGWh5fccLdfaWY2JTd3Mg2m0f/9RWWFRHfes?=
 =?us-ascii?Q?c63sNJQOtlUL7EXPFdDChhvAKerD/55+1LTvymlwd0fbpaOsEPaRq6BnpuMe?=
 =?us-ascii?Q?kmM8kuq7yry+4HQ9W8Gd1MVlcim1ZVyMS0SkoXsahRl1dUffG6Ckk/qBEuJy?=
 =?us-ascii?Q?dgvERVv7V2a6wJyrKs+QrhpUiHhHgEb2tD+i8vNfvC8qmPItpWkoYqrVC4gk?=
 =?us-ascii?Q?y1PCpaAAMICTkUiUSgaHgn/IfGXZjIvMzKvwQE+V5BIaS/McOMDG6uURQizT?=
 =?us-ascii?Q?eDrlg1PKKEoM+goqTPJ/dULSnjNGm+NTiGs0F2En1825q0hWduJAy+JgsPlD?=
 =?us-ascii?Q?czIWJ9MWnCt0KfXO9fFHXkCx2+/VA2YUMeOwDmG1nfyng0FjG2RK9E18UvAg?=
 =?us-ascii?Q?8MXDe7ZDNVGgF0bxsX27od4+CprA1AiZMVFMtDsASPXvi2qLIln1LR60O8zz?=
 =?us-ascii?Q?MFgoopgLhjI8WqoGOllf/czQNLNo13+oLansRrY2UIewGhzghPBxv+5aSwzb?=
 =?us-ascii?Q?lIKC5d1JsyTde0Wn35R+jJI5W7Qurc+HnEg+7ydcN8QVdI/X+qVhLpi5ccwx?=
 =?us-ascii?Q?2B7Futn4nJK/vc32GhExo4GPnKaVtkQBj+tKEjivD+pp8XiRRJ8Cd9UlOLwW?=
 =?us-ascii?Q?JyFV/ygGL4pF2CrrezR46BLUZUt6K95KuaHvd6SnleqY4562BjoVbSmebpuC?=
 =?us-ascii?Q?70tyDIFQ+D0PjXMUHMHY8WMzhcKZH6t8lcEV8UEKxFBVasoodhswEHFYSZdp?=
 =?us-ascii?Q?OVQNmSeJrfy3LadaHLtyWG/3rvWvffjj23TG1sx38epFbpvOzlpwjVWPH/nQ?=
 =?us-ascii?Q?4b/WkfctCSw6oTn0s0ErULySjq8w+gfD5uOiPsPCP3zShWqedyAofvfXUqX2?=
 =?us-ascii?Q?KvcHXz9XU6rXTDbDSqkzS/41+LkMYK2kkZ+BE0iRpTpgNlcA7oOIvrUgQoiG?=
 =?us-ascii?Q?Vnky0OgKOD/NVAQYnUrn+G3Rs21e8qKK7j47EBE3A3jKt4xby6pqNxPPFdgD?=
 =?us-ascii?Q?WqqjnCTPhnGUglPtrY+qps68McNBw8RWJMGJw/OBs6oix3+jUyxj2YuXWoiG?=
 =?us-ascii?Q?uIb77iy0fXWEKh717qUaJr/x+KXJBSV8ZdEvYcbDlLqqKI42wnS2hg15d2D0?=
 =?us-ascii?Q?2zI8Lbv4CPPFeVeNfYTEdzYUeYszdRKfcsnTebfdjWBUI9bOLkO1ShTb76q2?=
 =?us-ascii?Q?fEpCt7UVoCZreqE4gXuLEkC9jwoplSgSzn3VA8vjUk/CG2osC8OW9Q8Il770?=
 =?us-ascii?Q?L0CiKLC+RZzc1pUSYNuCASjmFRVRA13LP8UaqnSOpaoMJ91VoQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(30052699003)(36860700013)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2024 10:23:24.6638
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 311a6d0c-9e54-4115-58e2-08dcfcbab73e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB4A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7563

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


