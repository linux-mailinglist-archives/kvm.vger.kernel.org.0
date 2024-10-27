Return-Path: <kvm+bounces-29759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B9C79B1D1E
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2024 11:09:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB74528184E
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2024 10:09:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A776C142E86;
	Sun, 27 Oct 2024 10:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YOdvs+x/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2046.outbound.protection.outlook.com [40.107.100.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9221531E8
	for <kvm@vger.kernel.org>; Sun, 27 Oct 2024 10:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730023745; cv=fail; b=VuXlJA1MtKf16oWsOpivqveFyKWwHJH50+sJdtvdaTF9foSU917klsJqNJ3NF/nrSDeJ1N8kuq8leLsNztAS6uNJfOxtoMA88SfH4a9Ztm5lJbbrYabEpIYJhi76c1I5BfsCRXkhwP9BFWXPs9EyqPjUl7/5hLXBJGoY/HIglxY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730023745; c=relaxed/simple;
	bh=TRgI9ED9qUI/VWzWuNLdCQVldilr8zgIJ5DffXOYjsk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U+74QcnAtbelKpnRkE8XTcB8SDsyu5nynzBG6Jfyjo9wWDM2AJfhotrY3qvXeUlGUyNGvBq8EtfzOdIbvNKpfmJjYKVwbI2hXF/91gFaiIYoTaKdNjU+EYv1gpDhR1BnPDp4xDMo6kEASkP9RnuyJ3U/5q24SBuxhg+2GaDkuLs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YOdvs+x/; arc=fail smtp.client-ip=40.107.100.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XkT8fPrTDt068cwFX/uQKXMH9GDbluDPwt7Jh2XLujER4k0sd3UuF/uvMj2mLSDjmfGdZnoQWvqiVQDioUw/sbEkGbT46eYjGpypkfJ+xv2Yg1skU154anNkp7+r8BOihE0NJDu6K+n2TD8Ixj23R34RRg8kuY9V4xcfSTLOXWSFe/4Z9ofswLx8ED/u+uAVnzvhAmHMPS+OFx3kwwUEpWGEBgcGJkUrMIEz/OT5er0G5hCRa4BuW0Y/2T++Q8ijAsNp4LMYgagGf0z9Mo6Fa20Vc/Dum6ACYfsHGiv9R3dQmjukA4wnkDZyhOkaOF8PJOJWWaBR1GXYu77s+E5N3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hgze2gGjITDxFolKYv/z4VMpvvVnWOWku6OBK/3kITE=;
 b=ni9pBcCGQyy+lx7W1BUEZyBTdkv46yp1+b7n3oj6NoDdyEkGm3r+5wgPVm9bqx69P0acpzD994oZQLhufGnRXW8O23ee/+04xtU7b/IJYh5AKj5kYYW3xyN5s6XM+fO8YaNvYZm2Cao3HGvsy2xtswcDHuTsZissacpCqUvqnA6SWM0Z6NN2Urwpj/O9poQ3wG375GsKxYeUSa3amNyaPuLVuKYO4b+OxBhBjgahs3qIUjg749gBCd9Ggr422/t7BmB6OnMML01t5ftBP2PJYHrG7qUyNy6FC8lZI/ZlNR2z6JgiAqEz56uctSFbVzOsAuA4E0Bw79B5sAjKiz3orw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hgze2gGjITDxFolKYv/z4VMpvvVnWOWku6OBK/3kITE=;
 b=YOdvs+x/6ID0MGIaUVLbM2nzQP+10F2r2DS5yvA+HZtH1UnlyVat/0WMsKficWkVsPkOw4UrLbhuNcOmyOX4TwTg8zUJqGQiCJ4LSgXRxV3dyim5PzXBxmrq+9xvVFp4QDpGTk+fA3wOATyvM9Qa9aOqaeOfTjxfrLPnQU3RLKbe5UVPzVyLcmWGa/zxeLcMr/A6T/wbs+4ZhrpzLT3rl+u19DWZEw6XoOPFefO7GFdE++I1GizOsce+RaFUeQ/PkS7/YsG0TxvvEyBj4JfSsqbxwp3WfXKsnrqKtom/6tLV7AFjYp6+L9Z3qglu423hEb38AzCnA+AYFpsiulZ68w==
Received: from SA9P223CA0003.NAMP223.PROD.OUTLOOK.COM (2603:10b6:806:26::8) by
 DM4PR12MB8560.namprd12.prod.outlook.com (2603:10b6:8:189::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8093.23; Sun, 27 Oct 2024 10:08:54 +0000
Received: from SN1PEPF0002529E.namprd05.prod.outlook.com
 (2603:10b6:806:26:cafe::ad) by SA9P223CA0003.outlook.office365.com
 (2603:10b6:806:26::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.21 via Frontend
 Transport; Sun, 27 Oct 2024 10:08:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF0002529E.mail.protection.outlook.com (10.167.242.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8093.14 via Frontend Transport; Sun, 27 Oct 2024 10:08:53 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 27 Oct
 2024 03:08:38 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 27 Oct
 2024 03:08:38 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.1544.4 via Frontend Transport; Sun, 27 Oct
 2024 03:08:34 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH vfio 5/7] vfio/virtio: Add support for the basic live migration functionality
Date: Sun, 27 Oct 2024 12:07:49 +0200
Message-ID: <20241027100751.219214-6-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529E:EE_|DM4PR12MB8560:EE_
X-MS-Office365-Filtering-Correlation-Id: c27b9944-f59f-4ffb-7dbd-08dcf66f5cf5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Y1aLy8KDoTryiAhgHLI4Lg6qy6ANfoNR2kGAYC2yZHC6NNvAqURS3Z64zZoR?=
 =?us-ascii?Q?UEicdQOwswS12vysy2a8f9fd+gnvI+YEHNcSY2MA2gE/x3kLziMH5VAid0Mt?=
 =?us-ascii?Q?t13QwCaomC1iqhdYuc2uEjIL+CjeSzoXv7dPlQvV1vJu4vVEDPfoBPHoYG6r?=
 =?us-ascii?Q?412gihGzn/CSOe+rmsbV0Tl/TXFleWyQsGhChzB080jppct9VXiKtqfQ5TL3?=
 =?us-ascii?Q?EeWayu5i9d9QljP6A/LHV4ulTMYDKTf4JeZsBluoKGLVBNHTTT5fdbQ+fdrA?=
 =?us-ascii?Q?OUTpp4EsG7rU+nhHTylfX3sk/rq+XDLKs2VYkNn3NmXfXxbMSTK3heklrGIj?=
 =?us-ascii?Q?v4Cq24ogrjWji0gELWm4ObTzBDZv0BrFff7A6XtroGLfHz7vdTIhx94sUdPX?=
 =?us-ascii?Q?k8sxBNfxS2yjb9gRxDZ8IMw1PqmtaVYIS/OpfC0NiPYNKrqMN9e8aA4Sehes?=
 =?us-ascii?Q?G0QUYN92/Ri1eRxkMyf2/d1DYBaeUze2RLE9S30PKvMMNVzGQzh9gHWu2HFg?=
 =?us-ascii?Q?s1Vaj7/lcdGSmaVEPZBOWzOHhvUKAy1ywSnAehYBB9HZgl2P+MDuEpDQHJu8?=
 =?us-ascii?Q?WJrhsvZcttnI2jc3MZ9l4O6UGy9Vua3bwYPcfdW6bBvj5KTDEa/FScKWN4bH?=
 =?us-ascii?Q?wohDkfUW/91ZZbZshFgyWBnDY7hSku3wJpk3AnxpsfGQ3qD/jtZJG5ICIaEO?=
 =?us-ascii?Q?tapdY406eOkOkJoB4WlK4FoI+w3s8nE8Vni/8GXpxYoR7+41hE5IpnI2ViZx?=
 =?us-ascii?Q?EMzx9HBnqZ351vEEPnoB+IAQEhpZ/IrP4pb9SGptdzis4CB+QaINuL2CYigz?=
 =?us-ascii?Q?c0fXenDYkRZgMGiOW1Ax4z08FUrHmn8mnqLu5tdYO9gkerwzuM6b4AAIicDR?=
 =?us-ascii?Q?VJN6xPuLFVIdJ085JR59yeCwxUm6W11QnP5aaUaa3JGfsjkVqxvLMH3TVNdz?=
 =?us-ascii?Q?PbD2gSDMrE6nilLVSR4YEv18ZoTdtCwAWhe9DZQodTJN3MzS9b3IKhDMMsfU?=
 =?us-ascii?Q?rTzX2WaI+JAVCey9nvkTiiTZiSP+NhSdgY+rBk774KmAFCKpiaWsUmvGI69u?=
 =?us-ascii?Q?PLs8CBK1OXFbfrl2X1fAkQ8ylyNBKWsSNHuU7d+CfYsw9s6GupJnZ5/6+R2z?=
 =?us-ascii?Q?vix+Oy5RGRmfj1w5L5H65LFsvJtWHgSfOP+IWFvrraPOc4QshDnau6duqLDm?=
 =?us-ascii?Q?9399JN5GdO4SccxI0J02KhP6gg2QWYv53DNz943oKx2pHbqbDELDTvhE0MTR?=
 =?us-ascii?Q?sxHS0TataCuofyVmykKj0xRsIaLEvFe82QXGJcolQp5dKIMNbUoDPQCaSy06?=
 =?us-ascii?Q?GTzULbqkOcWa/tdSAoLJal8fEfrrVnsXJ9Fvb9ceMA5Vj4TsLFRsZZWiuLVI?=
 =?us-ascii?Q?d9I+mxFVB9ta5D1TY72aBv4beUqS7mRjO/djKdRLC/5uNygcpA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2024 10:08:53.9756
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c27b9944-f59f-4ffb-7dbd-08dcf66f5cf5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002529E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8560

Add support for basic live migration functionality in VFIO over
virtio-net devices, aligned with the virtio device specification 1.4.

This includes the following VFIO features:
VFIO_MIGRATION_STOP_COPY, VFIO_MIGRATION_P2P.

The implementation registers with the VFIO subsystem using vfio_pci_core
and then incorporates the virtio-specific logic for the migration
process.

The migration follows the definitions in uapi/vfio.h and leverages the
virtio VF-to-PF admin queue command channel for execution device parts
related commands.

Additional Notes:
-----------------
The kernel protocol between the source and target devices contains a
header with metadata, including record size, tag, and flags.

The record size allows the target to recognize and read a complete image
from the source before passing the device part data. This adheres to the
virtio device specification, which mandates that partial device parts
cannot be supplied.

The tag and flags serve as placeholders for future extensions of the
kernel protocol between the source and target, ensuring backward and
forward compatibility.

Both the source and target comply with the virtio device specification
by using a device part object with a unique ID as part of the migration
process. Since this resource is limited to a maximum of 255, its
lifecycle is confined to periods with an active live migration flow.

According to the virtio specification, a device has only two modes:
RUNNING and STOPPED. As a result, certain VFIO transitions (i.e.,
RUNNING_P2P->STOP, STOP->RUNNING_P2P) are treated as no-ops. When
transitioning to RUNNING_P2P, the device state is set to STOP, and it
will remain STOPPED until the transition out of RUNNING_P2P->RUNNING, at
which point it returns to RUNNING.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/virtio/Makefile  |    2 +-
 drivers/vfio/pci/virtio/common.h  |  104 +++
 drivers/vfio/pci/virtio/main.c    |  144 ++--
 drivers/vfio/pci/virtio/migrate.c | 1119 +++++++++++++++++++++++++++++
 4 files changed, 1318 insertions(+), 51 deletions(-)
 create mode 100644 drivers/vfio/pci/virtio/common.h
 create mode 100644 drivers/vfio/pci/virtio/migrate.c

diff --git a/drivers/vfio/pci/virtio/Makefile b/drivers/vfio/pci/virtio/Makefile
index 7171105baf33..bf0ccde6a91a 100644
--- a/drivers/vfio/pci/virtio/Makefile
+++ b/drivers/vfio/pci/virtio/Makefile
@@ -1,3 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_VIRTIO_VFIO_PCI) += virtio-vfio-pci.o
-virtio-vfio-pci-y := main.o
+virtio-vfio-pci-y := main.o migrate.o
diff --git a/drivers/vfio/pci/virtio/common.h b/drivers/vfio/pci/virtio/common.h
new file mode 100644
index 000000000000..3bdfb3ea1174
--- /dev/null
+++ b/drivers/vfio/pci/virtio/common.h
@@ -0,0 +1,104 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef VIRTIO_VFIO_COMMON_H
+#define VIRTIO_VFIO_COMMON_H
+
+#include <linux/kernel.h>
+#include <linux/virtio.h>
+#include <linux/vfio_pci_core.h>
+#include <linux/virtio_pci.h>
+
+enum virtiovf_migf_state {
+	VIRTIOVF_MIGF_STATE_ERROR = 1,
+};
+
+enum virtiovf_load_state {
+	VIRTIOVF_LOAD_STATE_READ_HEADER,
+	VIRTIOVF_LOAD_STATE_PREP_HEADER_DATA,
+	VIRTIOVF_LOAD_STATE_READ_HEADER_DATA,
+	VIRTIOVF_LOAD_STATE_PREP_CHUNK,
+	VIRTIOVF_LOAD_STATE_READ_CHUNK,
+	VIRTIOVF_LOAD_STATE_LOAD_CHUNK,
+};
+
+struct virtiovf_data_buffer {
+	struct sg_append_table table;
+	loff_t start_pos;
+	u64 length;
+	u64 allocated_length;
+	struct list_head buf_elm;
+	u8 include_header_object:1;
+	struct virtiovf_migration_file *migf;
+	/* Optimize virtiovf_get_migration_page() for sequential access */
+	struct scatterlist *last_offset_sg;
+	unsigned int sg_last_entry;
+	unsigned long last_offset;
+};
+
+enum virtiovf_migf_header_flags {
+	VIRTIOVF_MIGF_HEADER_FLAGS_TAG_MANDATORY = 0,
+	VIRTIOVF_MIGF_HEADER_FLAGS_TAG_OPTIONAL = 1 << 0,
+};
+
+enum virtiovf_migf_header_tag {
+	VIRTIOVF_MIGF_HEADER_TAG_DEVICE_DATA = 0,
+};
+
+struct virtiovf_migration_header {
+	__le64 record_size;
+	/* For future use in case we may need to change the kernel protocol */
+	__le32 flags; /* Use virtiovf_migf_header_flags */
+	__le32 tag; /* Use virtiovf_migf_header_tag */
+	__u8 data[]; /* Its size is given in the record_size */
+};
+
+struct virtiovf_migration_file {
+	struct file *filp;
+	/* synchronize access to the file state */
+	struct mutex lock;
+	loff_t max_pos;
+	u64 record_size;
+	u32 record_tag;
+	u8 has_obj_id:1;
+	u32 obj_id;
+	enum virtiovf_migf_state state;
+	enum virtiovf_load_state load_state;
+	/* synchronize access to the lists */
+	spinlock_t list_lock;
+	struct list_head buf_list;
+	struct list_head avail_list;
+	struct virtiovf_data_buffer *buf;
+	struct virtiovf_data_buffer *buf_header;
+	struct virtiovf_pci_core_device *virtvdev;
+};
+
+struct virtiovf_pci_core_device {
+	struct vfio_pci_core_device core_device;
+	u8 *bar0_virtual_buf;
+	/* synchronize access to the virtual buf */
+	struct mutex bar_mutex;
+	void __iomem *notify_addr;
+	u64 notify_offset;
+	__le32 pci_base_addr_0;
+	__le16 pci_cmd;
+	u8 bar0_virtual_buf_size;
+	u8 notify_bar;
+
+	/* LM related */
+	u8 migrate_cap:1;
+	u8 deferred_reset:1;
+	/* protect migration state */
+	struct mutex state_mutex;
+	enum vfio_device_mig_state mig_state;
+	/* protect the reset_done flow */
+	spinlock_t reset_lock;
+	struct virtiovf_migration_file *resuming_migf;
+	struct virtiovf_migration_file *saving_migf;
+};
+
+void virtiovf_set_migratable(struct virtiovf_pci_core_device *virtvdev);
+void virtiovf_open_migration(struct virtiovf_pci_core_device *virtvdev);
+void virtiovf_close_migration(struct virtiovf_pci_core_device *virtvdev);
+void virtiovf_migration_reset_done(struct pci_dev *pdev);
+
+#endif /* VIRTIO_VFIO_COMMON_H */
diff --git a/drivers/vfio/pci/virtio/main.c b/drivers/vfio/pci/virtio/main.c
index b5d3a8c5bbc9..e2cdf2d48200 100644
--- a/drivers/vfio/pci/virtio/main.c
+++ b/drivers/vfio/pci/virtio/main.c
@@ -16,18 +16,9 @@
 #include <linux/virtio_net.h>
 #include <linux/virtio_pci_admin.h>
 
-struct virtiovf_pci_core_device {
-	struct vfio_pci_core_device core_device;
-	u8 *bar0_virtual_buf;
-	/* synchronize access to the virtual buf */
-	struct mutex bar_mutex;
-	void __iomem *notify_addr;
-	u64 notify_offset;
-	__le32 pci_base_addr_0;
-	__le16 pci_cmd;
-	u8 bar0_virtual_buf_size;
-	u8 notify_bar;
-};
+#include "common.h"
+
+static int virtiovf_pci_init_device(struct vfio_device *core_vdev);
 
 static int
 virtiovf_issue_legacy_rw_cmd(struct virtiovf_pci_core_device *virtvdev,
@@ -355,8 +346,8 @@ virtiovf_set_notify_addr(struct virtiovf_pci_core_device *virtvdev)
 
 static int virtiovf_pci_open_device(struct vfio_device *core_vdev)
 {
-	struct virtiovf_pci_core_device *virtvdev = container_of(
-		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
+	struct virtiovf_pci_core_device *virtvdev = container_of(core_vdev,
+			struct virtiovf_pci_core_device, core_device.vdev);
 	struct vfio_pci_core_device *vdev = &virtvdev->core_device;
 	int ret;
 
@@ -377,10 +368,20 @@ static int virtiovf_pci_open_device(struct vfio_device *core_vdev)
 		}
 	}
 
+	virtiovf_open_migration(virtvdev);
 	vfio_pci_core_finish_enable(vdev);
 	return 0;
 }
 
+static void virtiovf_pci_close_device(struct vfio_device *core_vdev)
+{
+	struct virtiovf_pci_core_device *virtvdev = container_of(core_vdev,
+			struct virtiovf_pci_core_device, core_device.vdev);
+
+	virtiovf_close_migration(virtvdev);
+	vfio_pci_core_close_device(core_vdev);
+}
+
 static int virtiovf_get_device_config_size(unsigned short device)
 {
 	/* Network card */
@@ -404,48 +405,40 @@ static int virtiovf_read_notify_info(struct virtiovf_pci_core_device *virtvdev)
 	return 0;
 }
 
-static int virtiovf_pci_init_device(struct vfio_device *core_vdev)
-{
-	struct virtiovf_pci_core_device *virtvdev = container_of(
-		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
-	struct pci_dev *pdev;
-	int ret;
-
-	ret = vfio_pci_core_init_dev(core_vdev);
-	if (ret)
-		return ret;
-
-	pdev = virtvdev->core_device.pdev;
-	ret = virtiovf_read_notify_info(virtvdev);
-	if (ret)
-		return ret;
-
-	virtvdev->bar0_virtual_buf_size = VIRTIO_PCI_CONFIG_OFF(true) +
-				virtiovf_get_device_config_size(pdev->device);
-	BUILD_BUG_ON(!is_power_of_2(virtvdev->bar0_virtual_buf_size));
-	virtvdev->bar0_virtual_buf = kzalloc(virtvdev->bar0_virtual_buf_size,
-					     GFP_KERNEL);
-	if (!virtvdev->bar0_virtual_buf)
-		return -ENOMEM;
-	mutex_init(&virtvdev->bar_mutex);
-	return 0;
-}
-
 static void virtiovf_pci_core_release_dev(struct vfio_device *core_vdev)
 {
-	struct virtiovf_pci_core_device *virtvdev = container_of(
-		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
+	struct virtiovf_pci_core_device *virtvdev = container_of(core_vdev,
+			struct virtiovf_pci_core_device, core_device.vdev);
 
 	kfree(virtvdev->bar0_virtual_buf);
 	vfio_pci_core_release_dev(core_vdev);
 }
 
-static const struct vfio_device_ops virtiovf_vfio_pci_tran_ops = {
-	.name = "virtio-vfio-pci-trans",
+static const struct vfio_device_ops virtiovf_vfio_pci_lm_ops = {
+	.name = "virtio-vfio-pci-lm",
 	.init = virtiovf_pci_init_device,
 	.release = virtiovf_pci_core_release_dev,
 	.open_device = virtiovf_pci_open_device,
-	.close_device = vfio_pci_core_close_device,
+	.close_device = virtiovf_pci_close_device,
+	.ioctl = vfio_pci_core_ioctl,
+	.device_feature = vfio_pci_core_ioctl_feature,
+	.read = vfio_pci_core_read,
+	.write = vfio_pci_core_write,
+	.mmap = vfio_pci_core_mmap,
+	.request = vfio_pci_core_request,
+	.match = vfio_pci_core_match,
+	.bind_iommufd = vfio_iommufd_physical_bind,
+	.unbind_iommufd = vfio_iommufd_physical_unbind,
+	.attach_ioas = vfio_iommufd_physical_attach_ioas,
+	.detach_ioas = vfio_iommufd_physical_detach_ioas,
+};
+
+static const struct vfio_device_ops virtiovf_vfio_pci_tran_lm_ops = {
+	.name = "virtio-vfio-pci-trans-lm",
+	.init = virtiovf_pci_init_device,
+	.release = virtiovf_pci_core_release_dev,
+	.open_device = virtiovf_pci_open_device,
+	.close_device = virtiovf_pci_close_device,
 	.ioctl = virtiovf_vfio_pci_core_ioctl,
 	.device_feature = vfio_pci_core_ioctl_feature,
 	.read = virtiovf_pci_core_read,
@@ -485,16 +478,66 @@ static bool virtiovf_bar0_exists(struct pci_dev *pdev)
 	return res->flags;
 }
 
+static int virtiovf_pci_init_device(struct vfio_device *core_vdev)
+{
+	struct virtiovf_pci_core_device *virtvdev = container_of(core_vdev,
+			struct virtiovf_pci_core_device, core_device.vdev);
+	struct pci_dev *pdev;
+	bool sup_legacy_io;
+	bool sup_lm;
+	int ret;
+
+	ret = vfio_pci_core_init_dev(core_vdev);
+	if (ret)
+		return ret;
+
+	pdev = virtvdev->core_device.pdev;
+	sup_legacy_io = virtio_pci_admin_has_legacy_io(pdev) &&
+				!virtiovf_bar0_exists(pdev);
+	sup_lm = virtio_pci_admin_has_dev_parts(pdev);
+
+	/*
+	 * If the device is not capable to this driver functionality, fallback
+	 * to the default vfio-pci ops
+	 */
+	if (!sup_legacy_io && !sup_lm) {
+		core_vdev->ops = &virtiovf_vfio_pci_ops;
+		return 0;
+	}
+
+	if (sup_legacy_io) {
+		ret = virtiovf_read_notify_info(virtvdev);
+		if (ret)
+			return ret;
+
+		virtvdev->bar0_virtual_buf_size = VIRTIO_PCI_CONFIG_OFF(true) +
+					virtiovf_get_device_config_size(pdev->device);
+		BUILD_BUG_ON(!is_power_of_2(virtvdev->bar0_virtual_buf_size));
+		virtvdev->bar0_virtual_buf = kzalloc(virtvdev->bar0_virtual_buf_size,
+						     GFP_KERNEL);
+		if (!virtvdev->bar0_virtual_buf)
+			return -ENOMEM;
+		mutex_init(&virtvdev->bar_mutex);
+	}
+
+	if (sup_lm)
+		virtiovf_set_migratable(virtvdev);
+
+	if (sup_lm && !sup_legacy_io)
+		core_vdev->ops = &virtiovf_vfio_pci_lm_ops;
+
+	return 0;
+}
+
 static int virtiovf_pci_probe(struct pci_dev *pdev,
 			      const struct pci_device_id *id)
 {
-	const struct vfio_device_ops *ops = &virtiovf_vfio_pci_ops;
 	struct virtiovf_pci_core_device *virtvdev;
+	const struct vfio_device_ops *ops;
 	int ret;
 
-	if (pdev->is_virtfn && virtio_pci_admin_has_legacy_io(pdev) &&
-	    !virtiovf_bar0_exists(pdev))
-		ops = &virtiovf_vfio_pci_tran_ops;
+	ops = (pdev->is_virtfn) ? &virtiovf_vfio_pci_tran_lm_ops :
+				  &virtiovf_vfio_pci_ops;
 
 	virtvdev = vfio_alloc_device(virtiovf_pci_core_device, core_device.vdev,
 				     &pdev->dev, ops);
@@ -532,6 +575,7 @@ static void virtiovf_pci_aer_reset_done(struct pci_dev *pdev)
 	struct virtiovf_pci_core_device *virtvdev = dev_get_drvdata(&pdev->dev);
 
 	virtvdev->pci_cmd = 0;
+	virtiovf_migration_reset_done(pdev);
 }
 
 static const struct pci_error_handlers virtiovf_err_handlers = {
diff --git a/drivers/vfio/pci/virtio/migrate.c b/drivers/vfio/pci/virtio/migrate.c
new file mode 100644
index 000000000000..2a9614c2ef07
--- /dev/null
+++ b/drivers/vfio/pci/virtio/migrate.c
@@ -0,0 +1,1119 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES. All rights reserved
+ */
+
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/pci.h>
+#include <linux/pm_runtime.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+#include <linux/vfio.h>
+#include <linux/vfio_pci_core.h>
+#include <linux/virtio_pci.h>
+#include <linux/virtio_net.h>
+#include <linux/virtio_pci_admin.h>
+#include <linux/anon_inodes.h>
+
+#include "common.h"
+
+/* Device specification max parts size */
+#define MAX_LOAD_SIZE (BIT_ULL(BITS_PER_TYPE \
+	(((struct virtio_admin_cmd_dev_parts_metadata_result *)0)->parts_size.size)) - 1)
+
+/* Initial target buffer size */
+#define VIRTIOVF_TARGET_INITIAL_BUF_SIZE SZ_1M
+
+static struct page *
+virtiovf_get_migration_page(struct virtiovf_data_buffer *buf,
+			    unsigned long offset)
+{
+	unsigned long cur_offset = 0;
+	struct scatterlist *sg;
+	unsigned int i;
+
+	/* All accesses are sequential */
+	if (offset < buf->last_offset || !buf->last_offset_sg) {
+		buf->last_offset = 0;
+		buf->last_offset_sg = buf->table.sgt.sgl;
+		buf->sg_last_entry = 0;
+	}
+
+	cur_offset = buf->last_offset;
+
+	for_each_sg(buf->last_offset_sg, sg,
+		    buf->table.sgt.orig_nents - buf->sg_last_entry, i) {
+		if (offset < sg->length + cur_offset) {
+			buf->last_offset_sg = sg;
+			buf->sg_last_entry += i;
+			buf->last_offset = cur_offset;
+			return nth_page(sg_page(sg),
+					(offset - cur_offset) / PAGE_SIZE);
+		}
+		cur_offset += sg->length;
+	}
+	return NULL;
+}
+
+static int virtiovf_add_migration_pages(struct virtiovf_data_buffer *buf,
+					unsigned int npages)
+{
+	unsigned int to_alloc = npages;
+	struct page **page_list;
+	unsigned long filled;
+	unsigned int to_fill;
+	int ret;
+
+	to_fill = min_t(unsigned int, npages, PAGE_SIZE / sizeof(*page_list));
+	page_list = kvzalloc(to_fill * sizeof(*page_list), GFP_KERNEL_ACCOUNT);
+	if (!page_list)
+		return -ENOMEM;
+
+	do {
+		filled = alloc_pages_bulk_array(GFP_KERNEL_ACCOUNT, to_fill,
+						page_list);
+		if (!filled) {
+			ret = -ENOMEM;
+			goto err;
+		}
+		to_alloc -= filled;
+		ret = sg_alloc_append_table_from_pages(&buf->table, page_list,
+			filled, 0, filled << PAGE_SHIFT, UINT_MAX,
+			SG_MAX_SINGLE_ALLOC, GFP_KERNEL_ACCOUNT);
+
+		if (ret)
+			goto err;
+		buf->allocated_length += filled * PAGE_SIZE;
+		/* clean input for another bulk allocation */
+		memset(page_list, 0, filled * sizeof(*page_list));
+		to_fill = min_t(unsigned int, to_alloc,
+				PAGE_SIZE / sizeof(*page_list));
+	} while (to_alloc > 0);
+
+	kvfree(page_list);
+	return 0;
+
+err:
+	kvfree(page_list);
+	return ret;
+}
+
+static void virtiovf_free_data_buffer(struct virtiovf_data_buffer *buf)
+{
+	struct sg_page_iter sg_iter;
+
+	/* Undo alloc_pages_bulk_array() */
+	for_each_sgtable_page(&buf->table.sgt, &sg_iter, 0)
+		__free_page(sg_page_iter_page(&sg_iter));
+	sg_free_append_table(&buf->table);
+	kfree(buf);
+}
+
+static struct virtiovf_data_buffer *
+virtiovf_alloc_data_buffer(struct virtiovf_migration_file *migf, size_t length)
+{
+	struct virtiovf_data_buffer *buf;
+	int ret;
+
+	buf = kzalloc(sizeof(*buf), GFP_KERNEL_ACCOUNT);
+	if (!buf)
+		return ERR_PTR(-ENOMEM);
+
+	ret = virtiovf_add_migration_pages(buf,
+				DIV_ROUND_UP_ULL(length, PAGE_SIZE));
+	if (ret)
+		goto end;
+
+	buf->migf = migf;
+	return buf;
+end:
+	virtiovf_free_data_buffer(buf);
+	return ERR_PTR(ret);
+}
+
+static void virtiovf_put_data_buffer(struct virtiovf_data_buffer *buf)
+{
+	spin_lock_irq(&buf->migf->list_lock);
+	list_add_tail(&buf->buf_elm, &buf->migf->avail_list);
+	spin_unlock_irq(&buf->migf->list_lock);
+}
+
+static int
+virtiovf_pci_alloc_obj_id(struct virtiovf_pci_core_device *virtvdev, u8 type,
+			  u32 *obj_id)
+{
+	return virtio_pci_admin_obj_create(virtvdev->core_device.pdev,
+					   VIRTIO_RESOURCE_OBJ_DEV_PARTS, type, obj_id);
+}
+
+static void
+virtiovf_pci_free_obj_id(struct virtiovf_pci_core_device *virtvdev, u32 obj_id)
+{
+	virtio_pci_admin_obj_destroy(virtvdev->core_device.pdev,
+			VIRTIO_RESOURCE_OBJ_DEV_PARTS, obj_id);
+}
+
+static void virtiovf_clean_migf_resources(struct virtiovf_migration_file *migf)
+{
+	struct virtiovf_data_buffer *entry;
+
+	if (migf->buf) {
+		virtiovf_free_data_buffer(migf->buf);
+		migf->buf = NULL;
+	}
+
+	if (migf->buf_header) {
+		virtiovf_free_data_buffer(migf->buf_header);
+		migf->buf_header = NULL;
+	}
+
+	list_splice(&migf->avail_list, &migf->buf_list);
+
+	while ((entry = list_first_entry_or_null(&migf->buf_list,
+				struct virtiovf_data_buffer, buf_elm))) {
+		list_del(&entry->buf_elm);
+		virtiovf_free_data_buffer(entry);
+	}
+
+	if (migf->has_obj_id)
+		virtiovf_pci_free_obj_id(migf->virtvdev, migf->obj_id);
+}
+
+static void virtiovf_disable_fd(struct virtiovf_migration_file *migf)
+{
+	mutex_lock(&migf->lock);
+	migf->state = VIRTIOVF_MIGF_STATE_ERROR;
+	migf->filp->f_pos = 0;
+	mutex_unlock(&migf->lock);
+}
+
+static void virtiovf_disable_fds(struct virtiovf_pci_core_device *virtvdev)
+{
+	if (virtvdev->resuming_migf) {
+		virtiovf_disable_fd(virtvdev->resuming_migf);
+		virtiovf_clean_migf_resources(virtvdev->resuming_migf);
+		fput(virtvdev->resuming_migf->filp);
+		virtvdev->resuming_migf = NULL;
+	}
+	if (virtvdev->saving_migf) {
+		virtiovf_disable_fd(virtvdev->saving_migf);
+		virtiovf_clean_migf_resources(virtvdev->saving_migf);
+		fput(virtvdev->saving_migf->filp);
+		virtvdev->saving_migf = NULL;
+	}
+}
+
+/*
+ * This function is called in all state_mutex unlock cases to
+ * handle a 'deferred_reset' if exists.
+ */
+static void virtiovf_state_mutex_unlock(struct virtiovf_pci_core_device *virtvdev)
+{
+again:
+	spin_lock(&virtvdev->reset_lock);
+	if (virtvdev->deferred_reset) {
+		virtvdev->deferred_reset = false;
+		spin_unlock(&virtvdev->reset_lock);
+		virtvdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
+		virtiovf_disable_fds(virtvdev);
+		goto again;
+	}
+	mutex_unlock(&virtvdev->state_mutex);
+	spin_unlock(&virtvdev->reset_lock);
+}
+
+void virtiovf_migration_reset_done(struct pci_dev *pdev)
+{
+	struct virtiovf_pci_core_device *virtvdev = dev_get_drvdata(&pdev->dev);
+
+	if (!virtvdev->migrate_cap)
+		return;
+
+	/*
+	 * As the higher VFIO layers are holding locks across reset and using
+	 * those same locks with the mm_lock we need to prevent ABBA deadlock
+	 * with the state_mutex and mm_lock.
+	 * In case the state_mutex was taken already we defer the cleanup work
+	 * to the unlock flow of the other running context.
+	 */
+	spin_lock(&virtvdev->reset_lock);
+	virtvdev->deferred_reset = true;
+	if (!mutex_trylock(&virtvdev->state_mutex)) {
+		spin_unlock(&virtvdev->reset_lock);
+		return;
+	}
+	spin_unlock(&virtvdev->reset_lock);
+	virtiovf_state_mutex_unlock(virtvdev);
+}
+
+static int virtiovf_release_file(struct inode *inode, struct file *filp)
+{
+	struct virtiovf_migration_file *migf = filp->private_data;
+
+	virtiovf_disable_fd(migf);
+	mutex_destroy(&migf->lock);
+	kfree(migf);
+	return 0;
+}
+
+static struct virtiovf_data_buffer *
+virtiovf_get_data_buff_from_pos(struct virtiovf_migration_file *migf,
+				loff_t pos, bool *end_of_data)
+{
+	struct virtiovf_data_buffer *buf;
+	bool found = false;
+
+	*end_of_data = false;
+	spin_lock_irq(&migf->list_lock);
+	if (list_empty(&migf->buf_list)) {
+		*end_of_data = true;
+		goto end;
+	}
+
+	buf = list_first_entry(&migf->buf_list, struct virtiovf_data_buffer,
+			       buf_elm);
+	if (pos >= buf->start_pos &&
+	    pos < buf->start_pos + buf->length) {
+		found = true;
+		goto end;
+	}
+
+	/*
+	 * As we use a stream based FD we may expect having the data always
+	 * on first chunk
+	 */
+	migf->state = VIRTIOVF_MIGF_STATE_ERROR;
+
+end:
+	spin_unlock_irq(&migf->list_lock);
+	return found ? buf : NULL;
+}
+
+static ssize_t virtiovf_buf_read(struct virtiovf_data_buffer *vhca_buf,
+				 char __user **buf, size_t *len, loff_t *pos)
+{
+	unsigned long offset;
+	ssize_t done = 0;
+	size_t copy_len;
+
+	copy_len = min_t(size_t,
+			 vhca_buf->start_pos + vhca_buf->length - *pos, *len);
+	while (copy_len) {
+		size_t page_offset;
+		struct page *page;
+		size_t page_len;
+		u8 *from_buff;
+		int ret;
+
+		offset = *pos - vhca_buf->start_pos;
+		page_offset = offset % PAGE_SIZE;
+		offset -= page_offset;
+		page = virtiovf_get_migration_page(vhca_buf, offset);
+		if (!page)
+			return -EINVAL;
+		page_len = min_t(size_t, copy_len, PAGE_SIZE - page_offset);
+		from_buff = kmap_local_page(page);
+		ret = copy_to_user(*buf, from_buff + page_offset, page_len);
+		kunmap_local(from_buff);
+		if (ret)
+			return -EFAULT;
+		*pos += page_len;
+		*len -= page_len;
+		*buf += page_len;
+		done += page_len;
+		copy_len -= page_len;
+	}
+
+	if (*pos >= vhca_buf->start_pos + vhca_buf->length) {
+		spin_lock_irq(&vhca_buf->migf->list_lock);
+		list_del_init(&vhca_buf->buf_elm);
+		list_add_tail(&vhca_buf->buf_elm, &vhca_buf->migf->avail_list);
+		spin_unlock_irq(&vhca_buf->migf->list_lock);
+	}
+
+	return done;
+}
+
+static ssize_t virtiovf_save_read(struct file *filp, char __user *buf, size_t len,
+				  loff_t *pos)
+{
+	struct virtiovf_migration_file *migf = filp->private_data;
+	struct virtiovf_data_buffer *vhca_buf;
+	bool end_of_data;
+	ssize_t done = 0;
+
+	if (pos)
+		return -ESPIPE;
+	pos = &filp->f_pos;
+
+	mutex_lock(&migf->lock);
+	if (migf->state == VIRTIOVF_MIGF_STATE_ERROR) {
+		done = -ENODEV;
+		goto out_unlock;
+	}
+
+	while (len) {
+		ssize_t count;
+
+		vhca_buf = virtiovf_get_data_buff_from_pos(migf, *pos, &end_of_data);
+		if (end_of_data)
+			goto out_unlock;
+
+		if (!vhca_buf) {
+			done = -EINVAL;
+			goto out_unlock;
+		}
+
+		count = virtiovf_buf_read(vhca_buf, &buf, &len, pos);
+		if (count < 0) {
+			done = count;
+			goto out_unlock;
+		}
+		done += count;
+	}
+
+out_unlock:
+	mutex_unlock(&migf->lock);
+	return done;
+}
+
+static const struct file_operations virtiovf_save_fops = {
+	.owner = THIS_MODULE,
+	.read = virtiovf_save_read,
+	.release = virtiovf_release_file,
+};
+
+static int
+virtiovf_add_buf_header(struct virtiovf_data_buffer *header_buf,
+			u32 data_size)
+{
+	struct virtiovf_migration_file *migf = header_buf->migf;
+	struct virtiovf_migration_header header = {};
+	struct page *page;
+	u8 *to_buff;
+
+	header.record_size = cpu_to_le64(data_size);
+	header.flags = cpu_to_le32(VIRTIOVF_MIGF_HEADER_FLAGS_TAG_MANDATORY);
+	header.tag = cpu_to_le32(VIRTIOVF_MIGF_HEADER_TAG_DEVICE_DATA);
+	page = virtiovf_get_migration_page(header_buf, 0);
+	if (!page)
+		return -EINVAL;
+	to_buff = kmap_local_page(page);
+	memcpy(to_buff, &header, sizeof(header));
+	kunmap_local(to_buff);
+	header_buf->length = sizeof(header);
+	header_buf->start_pos = header_buf->migf->max_pos;
+	migf->max_pos += header_buf->length;
+	spin_lock_irq(&migf->list_lock);
+	list_add_tail(&header_buf->buf_elm, &migf->buf_list);
+	spin_unlock_irq(&migf->list_lock);
+	return 0;
+}
+
+static int
+virtiovf_read_device_context_chunk(struct virtiovf_migration_file *migf,
+				   u32 ctx_size)
+{
+	struct virtiovf_data_buffer *header_buf;
+	struct virtiovf_data_buffer *buf;
+	bool unmark_end = false;
+	struct scatterlist *sg;
+	unsigned int i;
+	u32 res_size;
+	int nent;
+	int ret;
+
+	buf = virtiovf_alloc_data_buffer(migf, ctx_size);
+	if (IS_ERR(buf))
+		return PTR_ERR(buf);
+
+	/* Find the total count of SG entries which satisfies the size */
+	nent = sg_nents_for_len(buf->table.sgt.sgl, ctx_size);
+	if (nent <= 0) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/*
+	 * Iterate to that SG entry and mark it as last (if it's not already)
+	 * to let underlay layers iterate only till that entry.
+	 */
+	for_each_sg(buf->table.sgt.sgl, sg, nent - 1, i)
+		;
+
+	if (!sg_is_last(sg)) {
+		unmark_end = true;
+		sg_mark_end(sg);
+	}
+
+	ret = virtio_pci_admin_dev_parts_get(migf->virtvdev->core_device.pdev,
+					     VIRTIO_RESOURCE_OBJ_DEV_PARTS,
+					     migf->obj_id,
+					     VIRTIO_ADMIN_CMD_DEV_PARTS_GET_TYPE_ALL,
+					     buf->table.sgt.sgl, &res_size);
+	/* Restore the original SG mark end */
+	if (unmark_end)
+		sg_unmark_end(sg);
+	if (ret)
+		goto out;
+
+	buf->length = res_size;
+	header_buf = virtiovf_alloc_data_buffer(migf,
+				sizeof(struct virtiovf_migration_header));
+	if (IS_ERR(header_buf)) {
+		ret = PTR_ERR(header_buf);
+		goto out;
+	}
+
+	ret = virtiovf_add_buf_header(header_buf, res_size);
+	if (ret)
+		goto out_header;
+
+	buf->start_pos = buf->migf->max_pos;
+	migf->max_pos += buf->length;
+	spin_lock(&migf->list_lock);
+	list_add_tail(&buf->buf_elm, &migf->buf_list);
+	spin_unlock_irq(&migf->list_lock);
+	return 0;
+
+out_header:
+	virtiovf_put_data_buffer(header_buf);
+out:
+	virtiovf_put_data_buffer(buf);
+	return ret;
+}
+
+static struct virtiovf_migration_file *
+virtiovf_pci_save_device_data(struct virtiovf_pci_core_device *virtvdev)
+{
+	struct virtiovf_migration_file *migf;
+	u32 ctx_size;
+	u32 obj_id;
+	int ret;
+
+	migf = kzalloc(sizeof(*migf), GFP_KERNEL_ACCOUNT);
+	if (!migf)
+		return ERR_PTR(-ENOMEM);
+
+	migf->filp = anon_inode_getfile("virtiovf_mig", &virtiovf_save_fops, migf,
+					O_RDONLY);
+	if (IS_ERR(migf->filp)) {
+		ret = PTR_ERR(migf->filp);
+		goto end;
+	}
+
+	stream_open(migf->filp->f_inode, migf->filp);
+	mutex_init(&migf->lock);
+	INIT_LIST_HEAD(&migf->buf_list);
+	INIT_LIST_HEAD(&migf->avail_list);
+	spin_lock_init(&migf->list_lock);
+	migf->virtvdev = virtvdev;
+
+	lockdep_assert_held(&virtvdev->state_mutex);
+	ret = virtiovf_pci_alloc_obj_id(virtvdev, VIRTIO_RESOURCE_OBJ_DEV_PARTS_TYPE_GET,
+					&obj_id);
+	if (ret)
+		goto out;
+
+	migf->obj_id = obj_id;
+	/* Mark as having a valid obj id which can be even 0 */
+	migf->has_obj_id = true;
+	ret = virtio_pci_admin_dev_parts_metadata_get(virtvdev->core_device.pdev,
+				VIRTIO_RESOURCE_OBJ_DEV_PARTS, obj_id,
+				VIRTIO_ADMIN_CMD_DEV_PARTS_METADATA_TYPE_SIZE,
+				&ctx_size);
+	if (ret)
+		goto out_clean;
+
+	if (!ctx_size) {
+		ret = -EINVAL;
+		goto out_clean;
+	}
+
+	ret = virtiovf_read_device_context_chunk(migf, ctx_size);
+	if (ret)
+		goto out_clean;
+
+	return migf;
+
+out_clean:
+	virtiovf_clean_migf_resources(migf);
+out:
+	fput(migf->filp);
+end:
+	kfree(migf);
+	return ERR_PTR(ret);
+}
+
+/*
+ * Set the required object header at the beginning of the buffer.
+ * The actual device parts data will be written post of the header offset.
+ */
+static int virtiovf_set_obj_cmd_header(struct virtiovf_data_buffer *vhca_buf)
+{
+	struct virtio_admin_cmd_resource_obj_cmd_hdr obj_hdr = {};
+	struct page *page;
+	u8 *to_buff;
+
+	obj_hdr.type = cpu_to_le16(VIRTIO_RESOURCE_OBJ_DEV_PARTS);
+	obj_hdr.id = cpu_to_le32(vhca_buf->migf->obj_id);
+	page = virtiovf_get_migration_page(vhca_buf, 0);
+	if (!page)
+		return -EINVAL;
+	to_buff = kmap_local_page(page);
+	memcpy(to_buff, &obj_hdr, sizeof(obj_hdr));
+	kunmap_local(to_buff);
+
+	/* Mark the buffer as including the header object data */
+	vhca_buf->include_header_object = 1;
+	return 0;
+}
+
+static int
+virtiovf_append_page_to_mig_buf(struct virtiovf_data_buffer *vhca_buf,
+				const char __user **buf, size_t *len,
+				loff_t *pos, ssize_t *done)
+{
+	unsigned long offset;
+	size_t page_offset;
+	struct page *page;
+	size_t page_len;
+	u8 *to_buff;
+	int ret;
+
+	offset = *pos - vhca_buf->start_pos;
+
+	if (vhca_buf->include_header_object)
+		/* The buffer holds the object header, update the offest accordingly */
+		offset += sizeof(struct virtio_admin_cmd_resource_obj_cmd_hdr);
+
+	page_offset = offset % PAGE_SIZE;
+
+	page = virtiovf_get_migration_page(vhca_buf, offset - page_offset);
+	if (!page)
+		return -EINVAL;
+
+	page_len = min_t(size_t, *len, PAGE_SIZE - page_offset);
+	to_buff = kmap_local_page(page);
+	ret = copy_from_user(to_buff + page_offset, *buf, page_len);
+	kunmap_local(to_buff);
+	if (ret)
+		return -EFAULT;
+
+	*pos += page_len;
+	*done += page_len;
+	*buf += page_len;
+	*len -= page_len;
+	vhca_buf->length += page_len;
+	return 0;
+}
+
+static ssize_t
+virtiovf_resume_read_chunk(struct virtiovf_migration_file *migf,
+			   struct virtiovf_data_buffer *vhca_buf,
+			   size_t chunk_size, const char __user **buf,
+			   size_t *len, loff_t *pos, ssize_t *done,
+			   bool *has_work)
+{
+	size_t copy_len, to_copy;
+	int ret;
+
+	to_copy = min_t(size_t, *len, chunk_size - vhca_buf->length);
+	copy_len = to_copy;
+	while (to_copy) {
+		ret = virtiovf_append_page_to_mig_buf(vhca_buf, buf, &to_copy,
+						      pos, done);
+		if (ret)
+			return ret;
+	}
+
+	*len -= copy_len;
+	if (vhca_buf->length == chunk_size) {
+		migf->load_state = VIRTIOVF_LOAD_STATE_LOAD_CHUNK;
+		migf->max_pos += chunk_size;
+		*has_work = true;
+	}
+
+	return 0;
+}
+
+static int
+virtiovf_resume_read_header_data(struct virtiovf_migration_file *migf,
+				 struct virtiovf_data_buffer *vhca_buf,
+				 const char __user **buf, size_t *len,
+				 loff_t *pos, ssize_t *done)
+{
+	size_t copy_len, to_copy;
+	size_t required_data;
+	int ret;
+
+	required_data = migf->record_size - vhca_buf->length;
+	to_copy = min_t(size_t, *len, required_data);
+	copy_len = to_copy;
+	while (to_copy) {
+		ret = virtiovf_append_page_to_mig_buf(vhca_buf, buf, &to_copy,
+						      pos, done);
+		if (ret)
+			return ret;
+	}
+
+	*len -= copy_len;
+	if (vhca_buf->length == migf->record_size) {
+		switch (migf->record_tag) {
+		default:
+			/* Optional tag */
+			break;
+		}
+
+		migf->load_state = VIRTIOVF_LOAD_STATE_READ_HEADER;
+		migf->max_pos += migf->record_size;
+		vhca_buf->length = 0;
+	}
+
+	return 0;
+}
+
+static int
+virtiovf_resume_read_header(struct virtiovf_migration_file *migf,
+			    struct virtiovf_data_buffer *vhca_buf,
+			    const char __user **buf,
+			    size_t *len, loff_t *pos,
+			    ssize_t *done, bool *has_work)
+{
+	struct page *page;
+	size_t copy_len;
+	u8 *to_buff;
+	int ret;
+
+	copy_len = min_t(size_t, *len,
+		sizeof(struct virtiovf_migration_header) - vhca_buf->length);
+	page = virtiovf_get_migration_page(vhca_buf, 0);
+	if (!page)
+		return -EINVAL;
+	to_buff = kmap_local_page(page);
+	ret = copy_from_user(to_buff + vhca_buf->length, *buf, copy_len);
+	if (ret) {
+		ret = -EFAULT;
+		goto end;
+	}
+
+	*buf += copy_len;
+	*pos += copy_len;
+	*done += copy_len;
+	*len -= copy_len;
+	vhca_buf->length += copy_len;
+	if (vhca_buf->length == sizeof(struct virtiovf_migration_header)) {
+		u64 record_size;
+		u32 flags;
+
+		record_size = le64_to_cpup((__le64 *)to_buff);
+		if (record_size > MAX_LOAD_SIZE) {
+			ret = -ENOMEM;
+			goto end;
+		}
+
+		migf->record_size = record_size;
+		flags = le32_to_cpup((__le32 *)(to_buff +
+			    offsetof(struct virtiovf_migration_header, flags)));
+		migf->record_tag = le32_to_cpup((__le32 *)(to_buff +
+			    offsetof(struct virtiovf_migration_header, tag)));
+		switch (migf->record_tag) {
+		case VIRTIOVF_MIGF_HEADER_TAG_DEVICE_DATA:
+			migf->load_state = VIRTIOVF_LOAD_STATE_PREP_CHUNK;
+			break;
+		default:
+			if (!(flags & VIRTIOVF_MIGF_HEADER_FLAGS_TAG_OPTIONAL)) {
+				ret = -EOPNOTSUPP;
+				goto end;
+			}
+			/* We may read and skip this optional record data */
+			migf->load_state = VIRTIOVF_LOAD_STATE_PREP_HEADER_DATA;
+		}
+
+		migf->max_pos += vhca_buf->length;
+		vhca_buf->length = 0;
+		*has_work = true;
+	}
+end:
+	kunmap_local(to_buff);
+	return ret;
+}
+
+static ssize_t virtiovf_resume_write(struct file *filp, const char __user *buf,
+				     size_t len, loff_t *pos)
+{
+	struct virtiovf_migration_file *migf = filp->private_data;
+	struct virtiovf_data_buffer *vhca_buf = migf->buf;
+	struct virtiovf_data_buffer *vhca_buf_header = migf->buf_header;
+	unsigned int orig_length;
+	bool has_work = false;
+	ssize_t done = 0;
+	int ret = 0;
+
+	if (pos)
+		return -ESPIPE;
+
+	pos = &filp->f_pos;
+	if (*pos < vhca_buf->start_pos)
+		return -EINVAL;
+
+	mutex_lock(&migf->virtvdev->state_mutex);
+	mutex_lock(&migf->lock);
+	if (migf->state == VIRTIOVF_MIGF_STATE_ERROR) {
+		done = -ENODEV;
+		goto out_unlock;
+	}
+
+	while (len || has_work) {
+		has_work = false;
+		switch (migf->load_state) {
+		case VIRTIOVF_LOAD_STATE_READ_HEADER:
+			ret = virtiovf_resume_read_header(migf, vhca_buf_header, &buf,
+							  &len, pos, &done, &has_work);
+			if (ret)
+				goto out_unlock;
+			break;
+		case VIRTIOVF_LOAD_STATE_PREP_HEADER_DATA:
+			if (vhca_buf_header->allocated_length < migf->record_size) {
+				virtiovf_free_data_buffer(vhca_buf_header);
+
+				migf->buf_header = virtiovf_alloc_data_buffer(migf,
+						migf->record_size);
+				if (IS_ERR(migf->buf_header)) {
+					ret = PTR_ERR(migf->buf_header);
+					migf->buf_header = NULL;
+					goto out_unlock;
+				}
+
+				vhca_buf_header = migf->buf_header;
+			}
+
+			vhca_buf_header->start_pos = migf->max_pos;
+			migf->load_state = VIRTIOVF_LOAD_STATE_READ_HEADER_DATA;
+			break;
+		case VIRTIOVF_LOAD_STATE_READ_HEADER_DATA:
+			ret = virtiovf_resume_read_header_data(migf, vhca_buf_header,
+							       &buf, &len, pos, &done);
+			if (ret)
+				goto out_unlock;
+			break;
+		case VIRTIOVF_LOAD_STATE_PREP_CHUNK:
+		{
+			u32 cmd_size = migf->record_size +
+				sizeof(struct virtio_admin_cmd_resource_obj_cmd_hdr);
+
+			/*
+			 * The DMA map/unmap is managed in virtio layer, we just need to extend
+			 * the SG pages to hold the extra required chunk data.
+			 */
+			if (vhca_buf->allocated_length < cmd_size) {
+				ret = virtiovf_add_migration_pages(vhca_buf,
+					DIV_ROUND_UP_ULL(cmd_size - vhca_buf->allocated_length,
+							 PAGE_SIZE));
+				if (ret)
+					goto out_unlock;
+			}
+
+			vhca_buf->start_pos = migf->max_pos;
+			migf->load_state = VIRTIOVF_LOAD_STATE_READ_CHUNK;
+			break;
+		}
+		case VIRTIOVF_LOAD_STATE_READ_CHUNK:
+			ret = virtiovf_resume_read_chunk(migf, vhca_buf, migf->record_size,
+							 &buf, &len, pos, &done, &has_work);
+			if (ret)
+				goto out_unlock;
+			break;
+		case VIRTIOVF_LOAD_STATE_LOAD_CHUNK:
+			/* Mark the last SG entry and set its length */
+			sg_mark_end(vhca_buf->last_offset_sg);
+			orig_length = vhca_buf->last_offset_sg->length;
+			/* Length should include the resource object command header */
+			vhca_buf->last_offset_sg->length = vhca_buf->length +
+					sizeof(struct virtio_admin_cmd_resource_obj_cmd_hdr) -
+					vhca_buf->last_offset;
+			ret = virtio_pci_admin_dev_parts_set(migf->virtvdev->core_device.pdev,
+							     vhca_buf->table.sgt.sgl);
+			/* Restore the original SG data */
+			vhca_buf->last_offset_sg->length = orig_length;
+			sg_unmark_end(vhca_buf->last_offset_sg);
+			if (ret)
+				goto out_unlock;
+			migf->load_state = VIRTIOVF_LOAD_STATE_READ_HEADER;
+			/* be ready for reading the next chunk */
+			vhca_buf->length = 0;
+			break;
+		default:
+			break;
+		}
+	}
+
+out_unlock:
+	if (ret)
+		migf->state = VIRTIOVF_MIGF_STATE_ERROR;
+	mutex_unlock(&migf->lock);
+	virtiovf_state_mutex_unlock(migf->virtvdev);
+	return ret ? ret : done;
+}
+
+static const struct file_operations virtiovf_resume_fops = {
+	.owner = THIS_MODULE,
+	.write = virtiovf_resume_write,
+	.release = virtiovf_release_file,
+};
+
+static struct virtiovf_migration_file *
+virtiovf_pci_resume_device_data(struct virtiovf_pci_core_device *virtvdev)
+{
+	struct virtiovf_migration_file *migf;
+	struct virtiovf_data_buffer *buf;
+	u32 obj_id;
+	int ret;
+
+	migf = kzalloc(sizeof(*migf), GFP_KERNEL_ACCOUNT);
+	if (!migf)
+		return ERR_PTR(-ENOMEM);
+
+	migf->filp = anon_inode_getfile("virtiovf_mig", &virtiovf_resume_fops, migf,
+					O_WRONLY);
+	if (IS_ERR(migf->filp)) {
+		ret = PTR_ERR(migf->filp);
+		goto end;
+	}
+
+	stream_open(migf->filp->f_inode, migf->filp);
+	mutex_init(&migf->lock);
+	INIT_LIST_HEAD(&migf->buf_list);
+	INIT_LIST_HEAD(&migf->avail_list);
+	spin_lock_init(&migf->list_lock);
+
+	buf = virtiovf_alloc_data_buffer(migf, VIRTIOVF_TARGET_INITIAL_BUF_SIZE);
+	if (IS_ERR(buf)) {
+		ret = PTR_ERR(buf);
+		goto out_free;
+	}
+
+	migf->buf = buf;
+
+	buf = virtiovf_alloc_data_buffer(migf,
+		sizeof(struct virtiovf_migration_header));
+	if (IS_ERR(buf)) {
+		ret = PTR_ERR(buf);
+		goto out_clean;
+	}
+
+	migf->buf_header = buf;
+	migf->load_state = VIRTIOVF_LOAD_STATE_READ_HEADER;
+
+	migf->virtvdev = virtvdev;
+	ret = virtiovf_pci_alloc_obj_id(virtvdev, VIRTIO_RESOURCE_OBJ_DEV_PARTS_TYPE_SET,
+					&obj_id);
+	if (ret)
+		goto out_clean;
+
+	migf->obj_id = obj_id;
+	/* Mark as having a valid obj id which can be even 0 */
+	migf->has_obj_id = true;
+	ret = virtiovf_set_obj_cmd_header(migf->buf);
+	if (ret)
+		goto out_clean;
+
+	return migf;
+
+out_clean:
+	virtiovf_clean_migf_resources(migf);
+out_free:
+	fput(migf->filp);
+end:
+	kfree(migf);
+	return ERR_PTR(ret);
+}
+
+static struct file *
+virtiovf_pci_step_device_state_locked(struct virtiovf_pci_core_device *virtvdev,
+				      u32 new)
+{
+	u32 cur = virtvdev->mig_state;
+	int ret;
+
+	if (cur == VFIO_DEVICE_STATE_RUNNING_P2P && new == VFIO_DEVICE_STATE_STOP) {
+		/* NOP */
+		return NULL;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_STOP && new == VFIO_DEVICE_STATE_RUNNING_P2P) {
+		/* NOP */
+		return NULL;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_RUNNING && new == VFIO_DEVICE_STATE_RUNNING_P2P) {
+		ret = virtio_pci_admin_mode_set(virtvdev->core_device.pdev,
+						BIT(VIRTIO_ADMIN_CMD_DEV_MODE_F_STOPPED));
+		if (ret)
+			return ERR_PTR(ret);
+		return NULL;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_RUNNING_P2P && new == VFIO_DEVICE_STATE_RUNNING) {
+		ret = virtio_pci_admin_mode_set(virtvdev->core_device.pdev, 0);
+		if (ret)
+			return ERR_PTR(ret);
+		return NULL;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_STOP && new == VFIO_DEVICE_STATE_STOP_COPY) {
+		struct virtiovf_migration_file *migf;
+
+		migf = virtiovf_pci_save_device_data(virtvdev);
+		if (IS_ERR(migf))
+			return ERR_CAST(migf);
+		get_file(migf->filp);
+		virtvdev->saving_migf = migf;
+		return migf->filp;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_STOP_COPY && new == VFIO_DEVICE_STATE_STOP) {
+		virtiovf_disable_fds(virtvdev);
+		return NULL;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_STOP && new == VFIO_DEVICE_STATE_RESUMING) {
+		struct virtiovf_migration_file *migf;
+
+		migf = virtiovf_pci_resume_device_data(virtvdev);
+		if (IS_ERR(migf))
+			return ERR_CAST(migf);
+		get_file(migf->filp);
+		virtvdev->resuming_migf = migf;
+		return migf->filp;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_RESUMING && new == VFIO_DEVICE_STATE_STOP) {
+		virtiovf_disable_fds(virtvdev);
+		return NULL;
+	}
+
+	/*
+	 * vfio_mig_get_next_state() does not use arcs other than the above
+	 */
+	WARN_ON(true);
+	return ERR_PTR(-EINVAL);
+}
+
+static struct file *
+virtiovf_pci_set_device_state(struct vfio_device *vdev,
+			      enum vfio_device_mig_state new_state)
+{
+	struct virtiovf_pci_core_device *virtvdev = container_of(
+		vdev, struct virtiovf_pci_core_device, core_device.vdev);
+	enum vfio_device_mig_state next_state;
+	struct file *res = NULL;
+	int ret;
+
+	mutex_lock(&virtvdev->state_mutex);
+	while (new_state != virtvdev->mig_state) {
+		ret = vfio_mig_get_next_state(vdev, virtvdev->mig_state,
+					      new_state, &next_state);
+		if (ret) {
+			res = ERR_PTR(ret);
+			break;
+		}
+		res = virtiovf_pci_step_device_state_locked(virtvdev, next_state);
+		if (IS_ERR(res))
+			break;
+		virtvdev->mig_state = next_state;
+		if (WARN_ON(res && new_state != virtvdev->mig_state)) {
+			fput(res);
+			res = ERR_PTR(-EINVAL);
+			break;
+		}
+	}
+	virtiovf_state_mutex_unlock(virtvdev);
+	return res;
+}
+
+static int virtiovf_pci_get_device_state(struct vfio_device *vdev,
+				       enum vfio_device_mig_state *curr_state)
+{
+	struct virtiovf_pci_core_device *virtvdev = container_of(
+		vdev, struct virtiovf_pci_core_device, core_device.vdev);
+
+	mutex_lock(&virtvdev->state_mutex);
+	*curr_state = virtvdev->mig_state;
+	virtiovf_state_mutex_unlock(virtvdev);
+	return 0;
+}
+
+static int virtiovf_pci_get_data_size(struct vfio_device *vdev,
+				      unsigned long *stop_copy_length)
+{
+	struct virtiovf_pci_core_device *virtvdev = container_of(
+		vdev, struct virtiovf_pci_core_device, core_device.vdev);
+	bool obj_id_exists;
+	u32 res_size;
+	u32 obj_id;
+	int ret;
+
+	mutex_lock(&virtvdev->state_mutex);
+	obj_id_exists = virtvdev->saving_migf && virtvdev->saving_migf->has_obj_id;
+	if (!obj_id_exists) {
+		ret = virtiovf_pci_alloc_obj_id(virtvdev,
+						VIRTIO_RESOURCE_OBJ_DEV_PARTS_TYPE_GET,
+						&obj_id);
+		if (ret)
+			goto end;
+	} else {
+		obj_id = virtvdev->saving_migf->obj_id;
+	}
+
+	ret = virtio_pci_admin_dev_parts_metadata_get(virtvdev->core_device.pdev,
+				VIRTIO_RESOURCE_OBJ_DEV_PARTS, obj_id,
+				VIRTIO_ADMIN_CMD_DEV_PARTS_METADATA_TYPE_SIZE,
+				&res_size);
+	if (!ret)
+		*stop_copy_length = res_size;
+
+	/* We can't leave this obj_id alive if didn't exist before, otherwise, it might
+	 * stay alive, even without an active migration flow (e.g. migration was cancelled)
+	 */
+	if (!obj_id_exists)
+		virtiovf_pci_free_obj_id(virtvdev, obj_id);
+end:
+	virtiovf_state_mutex_unlock(virtvdev);
+	return ret;
+}
+
+static const struct vfio_migration_ops virtvdev_pci_mig_ops = {
+	.migration_set_state = virtiovf_pci_set_device_state,
+	.migration_get_state = virtiovf_pci_get_device_state,
+	.migration_get_data_size = virtiovf_pci_get_data_size,
+};
+
+void virtiovf_set_migratable(struct virtiovf_pci_core_device *virtvdev)
+{
+	virtvdev->migrate_cap = 1;
+	mutex_init(&virtvdev->state_mutex);
+	spin_lock_init(&virtvdev->reset_lock);
+	virtvdev->core_device.vdev.migration_flags =
+		VFIO_MIGRATION_STOP_COPY |
+		VFIO_MIGRATION_P2P;
+	virtvdev->core_device.vdev.mig_ops = &virtvdev_pci_mig_ops;
+}
+
+void virtiovf_open_migration(struct virtiovf_pci_core_device *virtvdev)
+{
+	if (!virtvdev->migrate_cap)
+		return;
+
+	virtvdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
+}
+
+void virtiovf_close_migration(struct virtiovf_pci_core_device *virtvdev)
+{
+	if (!virtvdev->migrate_cap)
+		return;
+
+	virtiovf_disable_fds(virtvdev);
+}
-- 
2.27.0


