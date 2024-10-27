Return-Path: <kvm+bounces-29757-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 07D679B1D17
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2024 11:09:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6C18DB2118B
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2024 10:09:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DE4F145B14;
	Sun, 27 Oct 2024 10:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="anoCDkQH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2053.outbound.protection.outlook.com [40.107.92.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4729D136327
	for <kvm@vger.kernel.org>; Sun, 27 Oct 2024 10:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730023729; cv=fail; b=qUKCsA+116HvDbUpKJG0aKC8xKaGCuuB7zDRCHsewTgXqg4Ziax9OJhCq8e8rM3+BTjuSEhzkc/E5lc4GGLVF9kw64eIp4UWwhvvAM7T5BubZ1/nK7d0B3DK2KfzawblAOiEF6kwvqGYmlcVDg6Xan7yEDndF8xUsfAjqRjR5cM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730023729; c=relaxed/simple;
	bh=0IRc4YBBhxR2KOTa9SR+LARqyNgQiRZ3SR4nFGaVv3M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LYGHDU5CdrjftjEHHVXRwf7mXBotlG5AIO/pIn866UgGz9Tjfk6+SszQY4pz5g1irzUZXjCjigGGxDPfGuU8NJ6hF/MaFxG+1KNrCE79m//LlgGsqOF695+EgY6RRSDVg7ndW5greiIlAOHeQ+TnfUYXifjQPQeVAARgNAv5msE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=anoCDkQH; arc=fail smtp.client-ip=40.107.92.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O8JcRnUK3b0/vb+TCZBqY0tM0ESXQiXyW8Ht/RtVojQ/zbGa/Zl+Z1zlSDm4+X1uZJ7sIrafbYCRdcMBc8dB//tm0MzOqvvcRCVsNykpznnEoTHeIXZ9uEgBWrrUovgQn/Rtlbwt8OqPi6JCLYpfXaMQFmWOj36/EQ4/Tq84tiMPavX368MJSxhNZ7a0kn62cFd9HTAGjPR5TeNw0AGKJBFErAtQN+QIVlTphBs6BKVN4B021kooHv8/Kg6Jt38CG86Sl0Aj1A3LH5VxNCakf9UaY9vp/Zsqc3RNHwUH5sH+y40BACReqGgENbIGmFl2ykpNkngeeXE9mX/61qdzxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wm8kJeDJW1CXkRZzuISQ1o0G9+9IZ7pZbetpapbJuh8=;
 b=bG7LrLifnRLomXJ0K4GvG82bql86xAf4WgOA3Gu8tPM8AFRPf4zpnS/nBqzMSRi2iyF3sceU2vP6egh9nfa075MkFPXolZtfid0RGiUPJnvriRHgd2iCtXpXA9n3Axu2ZYlNHvETZjS0YeIJIi6wi9lDD34xOmHJ7dsCwv0A9pUxiVwUSg01aPKneDzQ9QiCBsIHH97b4M4bk+Kw/7RM6iVDf6YqT2/V78VbTLik7oREbP0eBkBh6kGsts3BPa8lwOfcs4W9KoeKL3lcIzZt8O2QcJmtaQaBMIm5RO3j9j+Sqp8j+Mo8uK6MGsS0CDo2M00WlqW0vUoS+UzJeTbkvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wm8kJeDJW1CXkRZzuISQ1o0G9+9IZ7pZbetpapbJuh8=;
 b=anoCDkQH31FqVTkZjfhFW2lROm6NLp7d3uHjpWUIJaSUgW6RuPlWYbNpKb+/Th56BeCP7QSMcp7D7nJwK+sM2RIlAkqoGgvYuPBDNGGf59qIz4G9vOMzE/rqY5nt0HPVJ3BRDNIgPZZhoFuqevb9FGQXiaG1ikJVsKBq4CMk/gq0z495aYQDNr9uwI/9rJGndQ7ROYnbIuwfe+vpOmjtKwm3IMhBmU8BX04j/ZG+/iZBfcBK9TflGZfFjtI+L3vdUcQ9FoxU0wBuSpp4gQzf0LEX8d+nIJq4rL9tL0VqEtfGMNJvlMJ0O1T1MXAOyOshhWzAOHEQ/9ccnWVtXwI1lg==
Received: from MN2PR01CA0033.prod.exchangelabs.com (2603:10b6:208:10c::46) by
 LV3PR12MB9266.namprd12.prod.outlook.com (2603:10b6:408:21b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.24; Sun, 27 Oct
 2024 10:08:43 +0000
Received: from BN2PEPF000055E0.namprd21.prod.outlook.com
 (2603:10b6:208:10c:cafe::2f) by MN2PR01CA0033.outlook.office365.com
 (2603:10b6:208:10c::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.25 via Frontend
 Transport; Sun, 27 Oct 2024 10:08:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF000055E0.mail.protection.outlook.com (10.167.245.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.0 via Frontend Transport; Sun, 27 Oct 2024 10:08:42 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 27 Oct
 2024 03:08:30 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 27 Oct
 2024 03:08:30 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.1544.4 via Frontend Transport; Sun, 27 Oct
 2024 03:08:27 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH vfio 3/7] virtio: Manage device and driver capabilities via the admin commands
Date: Sun, 27 Oct 2024 12:07:47 +0200
Message-ID: <20241027100751.219214-4-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000055E0:EE_|LV3PR12MB9266:EE_
X-MS-Office365-Filtering-Correlation-Id: 9502ec14-d2f4-4cd2-ebaf-08dcf66f564e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|30052699003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2FV/uXvbmRLegPeJ7m0llgW0pgZ8jut26xCU6xgPVqenWDJkZEdfxXtp15El?=
 =?us-ascii?Q?VcN/MmgBn+iMZdMZwHmzmZ+w7xxxK7Jr7zV1aFtSXdS7lg+PuI9BrOGvQCog?=
 =?us-ascii?Q?b3/rltretVLsmL4DwCGM4OsUGef6i6fZj/Y+J95K3JnSZWhVnMfg5RFyZAir?=
 =?us-ascii?Q?KiRt3yE6CZqwYc7VPVmSDMuH5yFg3nFlYiFwUoDqvYSWBYQsCHcN59+cc0Y8?=
 =?us-ascii?Q?Mvo+WrUsckeJ8sczCQOn11ZbcabeYgjIDshW8ElIOvrK8xUgTGc8/AZRUNAf?=
 =?us-ascii?Q?ExtjfbvhcVD2u8lTkm6R7RgtFSoN/AGzyTCfMrPe3cITd05xAXFzUJ44hwh+?=
 =?us-ascii?Q?05pviL+ZdmzgQ7pd3Xsa4LDnyx5eemY2vtlLI5FyEYv/PUvTiGTJNcsSy3Yw?=
 =?us-ascii?Q?5wFWZ4LyDp3JnCfSLiLABcBhDv6tSI10G90XkIFxQXB1R5a6LtlRs7tChKjt?=
 =?us-ascii?Q?CAogbFCRjYLlA/FAlTnRO4AiBIJ06EkQAfZ3EAx+0f6By08/JgCNE4IPHTSu?=
 =?us-ascii?Q?BuOG+HgPltodVf2YNTdo5vRA9WSrrAJ+MJ5K/MokCkUdUw3Sn5M4pMeaiQb0?=
 =?us-ascii?Q?h7OB1qRjhZ6IR2Lok372UoNEhGxVcPowut5Sc5AgOMYNjqI12bzNXKpL2kK4?=
 =?us-ascii?Q?Tm64k3sDRbq9LdLkMQQPZe1bB6Pd3yt0liLav3pw6TUtTo922oHiBhuyrLlI?=
 =?us-ascii?Q?YjtuZK7sNhUeEu8SrdFmGO4gxA5mrmFZrKwUYgb7FLPW6zsjMNa8U/U49aQs?=
 =?us-ascii?Q?71jsB/ePZ+04fjE+CpopNPyrd5DcTQ0bmQF9vtO4hE1OB38Rm7c5G2n9VUZF?=
 =?us-ascii?Q?hcdimbhiW3zJjoab76DLAjgzVnnEWCzysmj6ZyUdsGNNb7wcLs2wbkaGR0rq?=
 =?us-ascii?Q?6zWVdNSgceBS4uF/CRiM9k+vXwOysMEHl3Xd0ApC/aXjWCDUACrBacOjFieM?=
 =?us-ascii?Q?UtmhsrrQWm6jezOrtSpJDwhsEeF6cLoaZ6WdC/XE+ePlw7Hx0gNqXu1/o1a4?=
 =?us-ascii?Q?3E4yH6FGh471DGP81rQ2cA0R6Ch/NKiWom/nx055NTd60fC6b+EM/4s9rDo6?=
 =?us-ascii?Q?2SyHTl9NqgnNCvDc55OMIq8gVzRETGsxpV6iC/8lLs6gFWi1BaqZRB1xMSwm?=
 =?us-ascii?Q?/D6no644hDzImpHZxzd68sPdhjgRZCiOJL8uj+xiEH2IFmjmtNP4yxPrkSiE?=
 =?us-ascii?Q?eA49RnOOWxRZ24iaD1wS4tMbt7DulTcV2NaA5gIUCxIbR6v+IGA+JNyv9X3Y?=
 =?us-ascii?Q?8xiIgifysTqUjvluTGOY+fKxxKvGoHQosUKJrkG6MsN0zD12/TSZzkn+xm0y?=
 =?us-ascii?Q?N5hKBwx/1aFDfkFchCr/S4ceW+/Xj75FuAAIVcHIhkhvu2RigsPgLc8lE57v?=
 =?us-ascii?Q?dIj4qPuvaSGh1BUpjiO5gVQ6/DGM6VfCVesJ/9NujdU6HmxAVg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(30052699003)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2024 10:08:42.7552
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9502ec14-d2f4-4cd2-ebaf-08dcf66f564e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055E0.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9266

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


