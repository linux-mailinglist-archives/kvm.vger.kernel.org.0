Return-Path: <kvm+bounces-31595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79D7D9C50FB
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 09:42:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 34808282A86
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 08:42:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECAFF20C009;
	Tue, 12 Nov 2024 08:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jJZKJkMO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2042.outbound.protection.outlook.com [40.107.237.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDC220B7FC
	for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 08:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731400740; cv=fail; b=sfpQHgRRmIschDbQUGyHnERIwuuapYCWElLb8M2DaPN/5nvcSJl5SbG8V6qRIEGHM+SGxiAe9r2ZxoGP47zLhd0hpeJ/diq7Y2ZhYlqbKtubh80PrKUpDmuWHHOJrWtyrXCwZizWRTWpRNaelGkEumZIGoCxro7T6dWPteDaxOM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731400740; c=relaxed/simple;
	bh=cekZlI8AnETTnU/lbaDgI6a9W2I1H6c+IzcTkv+MYto=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mIpaht/4ROGQAiTSFFduxTN8qv+WsMk3/VGB+fUuG+Y4AzK3MsLzg+FBmRMeNM4aex4oUYqxHV/KMrEEg4QiL/Lr98AZOqbSscELdYukmN76sWQJlWkRNbPIy/RR4wfD7HfeUc0Y7QYI/+kLhaylvm3Vvck/+N1liYQRxYcGYBs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jJZKJkMO; arc=fail smtp.client-ip=40.107.237.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LeZvWLpJZoXFITB2iSS5DAJRcJUSOYyBBJLPenYZ6ysTsL+m0ySbtsa09M0uEthhtpEVaC7wgMiW7w7SZSMTEsQkYmhbH17le56wL0QUKlIaug4xzDghqSNcUpzyYWhhsakQe5/rzjJvpebp52jXNMuvfIXw4e9WmadCa8s3f0QljV4/V+/tZkpE4u0wnqtdPDpfmvyKblHclaFmg28X5to2GCcTovyaYJFQ4fbzEPHVF96o9VdrQyfgoU3nQefgM/5eFypy8mnsxeEE1nWwPZ998oGq341S0gcpGbyWFi9Im5rqyE6qH0tnrIgFzkf4PnWkSmDUkX8tBR0LjJIbOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6w6pQyCB9/4/EDNabHO1rfoHnVpx/taWYIbnIvQNUOE=;
 b=gxR0chpqb+45fZNrJZxa0gR15Pejg6Q667RjXoCEJXSGZWfFzJ3gkZXV9nK71dyOW/FYG73Mud+RaTFTN1m2LqnNqKUpvPMw5E1polZR/pbgrtNbhbJJnK95zGFeyeUrjMXDOxVvW3sKgHJbiBSmewTTJb2ccto71EeDRcsDV/NtdNqkWOzi9KTr2gdLNyw2rctUF4r5d3wjlXEQGt7MWzlEF9/ySsInSCe7pCZI7W8tlbrpoazHuOp+xYJqP6+KlY/ocWUoBJnMdW8nHMggs+w/XSguMhSbN5HeDx8E77afURw7eRbKSef8EzWpkkwwTqdeVkiOUDmYrR69cbvucg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6w6pQyCB9/4/EDNabHO1rfoHnVpx/taWYIbnIvQNUOE=;
 b=jJZKJkMOuQ4Cx/18jgzGJQWsXDkyeYxkzz1IiOX4K2w9pv/A5ulMxSHd2SsRAjcFXRGA80mTAXfW6JSuKEFEAKiKYaIXHy8/WNa07MLhsEEeuuTFFIAhWKMLbYruNTYK8cDPTcOA+PCeIT7NUX9TIrNazvurf9RqBlDzjHsluv5DlfmZkx0HnP+Rxqlg7XVcN/9uJbb3IxWANrc22FyJrfX0S2JaDYDmPVq1nbQpLAkNqgXiPgeul0tGEOshD1GsD9o0S00oTglwrGIZGwN6t4n6Vyi8GyhLwLdKj7N8CDowlz46gDKiXdVVEjLmHDxF66nbLV8dE3qcQFOvKC/hvA==
Received: from DS7PR05CA0060.namprd05.prod.outlook.com (2603:10b6:8:2f::13) by
 BY5PR12MB4306.namprd12.prod.outlook.com (2603:10b6:a03:206::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Tue, 12 Nov
 2024 08:38:51 +0000
Received: from DS1PEPF00017093.namprd03.prod.outlook.com
 (2603:10b6:8:2f:cafe::a3) by DS7PR05CA0060.outlook.office365.com
 (2603:10b6:8:2f::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.15 via Frontend
 Transport; Tue, 12 Nov 2024 08:38:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF00017093.mail.protection.outlook.com (10.167.17.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.14 via Frontend Transport; Tue, 12 Nov 2024 08:38:50 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 12 Nov
 2024 00:38:36 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 12 Nov
 2024 00:38:35 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.1544.4 via Frontend Transport; Tue, 12 Nov
 2024 00:38:32 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH V3 vfio 5/7] vfio/virtio: Add support for the basic live migration functionality
Date: Tue, 12 Nov 2024 10:37:27 +0200
Message-ID: <20241112083729.145005-6-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017093:EE_|BY5PR12MB4306:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d0f6e0b-9a27-48bb-05cc-08dd02f56f1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tUswExgxVck+/wB+pdrlyKcKRMa4ezWS8rD1YKdDoVBtDl7YsiOzo8ifSYRY?=
 =?us-ascii?Q?i22gxOQ18j9Qb2V2JSB9Gbl3hNhvd/RoSZ0d67+milrR8NUCBmyvDPgAQv2w?=
 =?us-ascii?Q?miXcSsT6+Ne+NYrdsGjM+zUYYGJrcFzGQ9EyRW6kFDVxpnDYmUS+kQVBQKvi?=
 =?us-ascii?Q?fAI7GM7M+wvbHTzE/UbM/M2dUTTmtMG8CcBsTLqyfeBQz4w+CVt4GzX7xGgZ?=
 =?us-ascii?Q?RnjepGGKAbKnv46NAov97H1N1KRwS49SvrV2sCgbii854mf9zkAfV7YX6Y1z?=
 =?us-ascii?Q?1z+EP68H51baOt43iD2lr4TBaXhWCCdkanaAxiHYNUP0i47Y2Hrg+5hGxHXd?=
 =?us-ascii?Q?vCEZbJ0ueQykOuOQwINOlIS9S3JmMJ9tKcT70Eyg5bKkT+3feei52UF5hffe?=
 =?us-ascii?Q?0IKEBQh2rD3olXtaAhQ3AK/uw/Kx1JTQz7leid3OTLP1JjVxKeYZBAp50tGE?=
 =?us-ascii?Q?fyQZqAtSDi0I+AeUG8OXvgPHRHYEegesGkBup6qRXFCinaucvunIAX4GxtEm?=
 =?us-ascii?Q?osDN05cNisLxeX1iHTkFR5Ljo5PP7Cg1Z3KGSTcutI6rB2kXiQuKBEEaDh87?=
 =?us-ascii?Q?9Ov1pqSstztxHs3V+AJj0L0TvWYKgf0RyeO/ZpXfq+kDFeLX6M8qaa6b9/Q1?=
 =?us-ascii?Q?q0LuFcIaTPHECpN4FzxQKO6nwRSzU+EpfeTdAK+PGI1Xi8q6LHms0J3ardFZ?=
 =?us-ascii?Q?Yi8IPJOnbsXpTrvRi3JSYkgaXTUiiHsS1UO0hWOdE4ry2Wqub6DNG5He/Bto?=
 =?us-ascii?Q?Qn7mzVJuXYFPgnX4yTWA5AdAokzzLcMRFpurlmJgTwYZA45Jp469MAeiq1TC?=
 =?us-ascii?Q?GCnBYqAW9ol1UTBqiYrV0pIYkM6gdY06cVXM4zA2rito0wap5kjbohulUIjN?=
 =?us-ascii?Q?FQQpP4bBf6dWCsTZ1LXacQOnPisA2t/gUXtVXtczUr7FNnx6ApXibKTZMaks?=
 =?us-ascii?Q?cF706x+URG/YExn41T9N6d59/B861vjVKZkxD62dC8uPXl7S5TeWC/iYfluN?=
 =?us-ascii?Q?3HDzpNaQFJ7+YxgclhvZZ6qyfrVR+/728czkVSACkTnd72UQljGHx+1eF9nw?=
 =?us-ascii?Q?XNEA7SpfIA4ybYKMaKXXfodIC7GDqs/LxoyT84HpXJNinW9FOwCZPBhd0x1k?=
 =?us-ascii?Q?4zTCbH56JXzijGGktOv5IgS7swM3aEodqHXY0kBHjbCb7UiNgKh8FKaSf6zW?=
 =?us-ascii?Q?HAv562g+xjehYkQfKXtcLfJV6FkGl1+fMjGtb8+erELBTJDpULTalXKOXCfO?=
 =?us-ascii?Q?FNjzl2cs90C/RFqKtKOczaVCMtn9y0HPnGpRYYIJ958B79RqGMfIIsoJ5X9A?=
 =?us-ascii?Q?vJgBmjMZEqpKrOsByn7TInaWfQzJ18VlhTaLBpzFWeL71DU3/hhjS0NV3pP6?=
 =?us-ascii?Q?zYpeOulTO9H1JdKW6x/8tFIvLA+aNZuPP9UF3OuMHMW4pQ67Lw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 08:38:50.9200
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d0f6e0b-9a27-48bb-05cc-08dd02f56f1b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017093.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4306

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
which point it returns to RUNNING. During transition to STOP, the virtio
device only stops initiating outgoing requests(e.g. DMA, MSIx, etc.) but
still must accept incoming operations.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/virtio/Makefile  |    2 +-
 drivers/vfio/pci/virtio/common.h  |  104 +++
 drivers/vfio/pci/virtio/main.c    |   82 ++-
 drivers/vfio/pci/virtio/migrate.c | 1120 +++++++++++++++++++++++++++++
 4 files changed, 1283 insertions(+), 25 deletions(-)
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
index b5d3a8c5bbc9..e9ae17209026 100644
--- a/drivers/vfio/pci/virtio/main.c
+++ b/drivers/vfio/pci/virtio/main.c
@@ -16,18 +16,7 @@
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
 
 static int
 virtiovf_issue_legacy_rw_cmd(struct virtiovf_pci_core_device *virtvdev,
@@ -355,8 +344,8 @@ virtiovf_set_notify_addr(struct virtiovf_pci_core_device *virtvdev)
 
 static int virtiovf_pci_open_device(struct vfio_device *core_vdev)
 {
-	struct virtiovf_pci_core_device *virtvdev = container_of(
-		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
+	struct virtiovf_pci_core_device *virtvdev = container_of(core_vdev,
+			struct virtiovf_pci_core_device, core_device.vdev);
 	struct vfio_pci_core_device *vdev = &virtvdev->core_device;
 	int ret;
 
@@ -377,10 +366,20 @@ static int virtiovf_pci_open_device(struct vfio_device *core_vdev)
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
@@ -406,8 +405,8 @@ static int virtiovf_read_notify_info(struct virtiovf_pci_core_device *virtvdev)
 
 static int virtiovf_pci_init_device(struct vfio_device *core_vdev)
 {
-	struct virtiovf_pci_core_device *virtvdev = container_of(
-		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
+	struct virtiovf_pci_core_device *virtvdev = container_of(core_vdev,
+			struct virtiovf_pci_core_device, core_device.vdev);
 	struct pci_dev *pdev;
 	int ret;
 
@@ -416,6 +415,10 @@ static int virtiovf_pci_init_device(struct vfio_device *core_vdev)
 		return ret;
 
 	pdev = virtvdev->core_device.pdev;
+	/*
+	 * The vfio_device_ops.init() callback is set to virtiovf_pci_init_device()
+	 * only when legacy I/O is supported. Now, let's initialize it.
+	 */
 	ret = virtiovf_read_notify_info(virtvdev);
 	if (ret)
 		return ret;
@@ -433,19 +436,38 @@ static int virtiovf_pci_init_device(struct vfio_device *core_vdev)
 
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
+	.init = vfio_pci_core_init_dev,
+	.release = virtiovf_pci_core_release_dev,
+	.open_device = virtiovf_pci_open_device,
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
 	.init = virtiovf_pci_init_device,
 	.release = virtiovf_pci_core_release_dev,
 	.open_device = virtiovf_pci_open_device,
-	.close_device = vfio_pci_core_close_device,
+	.close_device = virtiovf_pci_close_device,
 	.ioctl = virtiovf_vfio_pci_core_ioctl,
 	.device_feature = vfio_pci_core_ioctl_feature,
 	.read = virtiovf_pci_core_read,
@@ -490,17 +512,28 @@ static int virtiovf_pci_probe(struct pci_dev *pdev,
 {
 	const struct vfio_device_ops *ops = &virtiovf_vfio_pci_ops;
 	struct virtiovf_pci_core_device *virtvdev;
+	bool sup_legacy_io = false;
+	bool sup_lm = false;
 	int ret;
 
-	if (pdev->is_virtfn && virtio_pci_admin_has_legacy_io(pdev) &&
-	    !virtiovf_bar0_exists(pdev))
-		ops = &virtiovf_vfio_pci_tran_ops;
+	if (pdev->is_virtfn) {
+		sup_legacy_io = virtio_pci_admin_has_legacy_io(pdev) &&
+				!virtiovf_bar0_exists(pdev);
+		sup_lm = virtio_pci_admin_has_dev_parts(pdev);
+		if (sup_legacy_io)
+			ops = &virtiovf_vfio_pci_tran_lm_ops;
+		else if (sup_lm)
+			ops = &virtiovf_vfio_pci_lm_ops;
+	}
 
 	virtvdev = vfio_alloc_device(virtiovf_pci_core_device, core_device.vdev,
 				     &pdev->dev, ops);
 	if (IS_ERR(virtvdev))
 		return PTR_ERR(virtvdev);
 
+	if (sup_lm)
+		virtiovf_set_migratable(virtvdev);
+
 	dev_set_drvdata(&pdev->dev, &virtvdev->core_device);
 	ret = vfio_pci_core_register_device(&virtvdev->core_device);
 	if (ret)
@@ -532,6 +565,7 @@ static void virtiovf_pci_aer_reset_done(struct pci_dev *pdev)
 	struct virtiovf_pci_core_device *virtvdev = dev_get_drvdata(&pdev->dev);
 
 	virtvdev->pci_cmd = 0;
+	virtiovf_migration_reset_done(pdev);
 }
 
 static const struct pci_error_handlers virtiovf_err_handlers = {
diff --git a/drivers/vfio/pci/virtio/migrate.c b/drivers/vfio/pci/virtio/migrate.c
new file mode 100644
index 000000000000..3d5eaa1cbcdb
--- /dev/null
+++ b/drivers/vfio/pci/virtio/migrate.c
@@ -0,0 +1,1120 @@
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
+		/* The buffer holds the object header, update the offset accordingly */
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
+	/*
+	 * We can't leave this obj_id alive if didn't exist before, otherwise, it might
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


