Return-Path: <kvm+bounces-56715-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 13FA8B42C9F
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 00:13:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8C33F1BC359B
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 22:13:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7457362095;
	Wed,  3 Sep 2025 22:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Y5MiPDci"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2070.outbound.protection.outlook.com [40.107.223.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36CF52EDD6C
	for <kvm@vger.kernel.org>; Wed,  3 Sep 2025 22:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756937516; cv=fail; b=Fv4bzdIfHYEWFTK/HvIfIljQ+gAm2B4EVF/wjFVt4SVg9h28a6ZH/IBncWELy4vA5k3Lz9Qt3ITXPR5kbgKbce68YHdRaoBSEYSopwDFBzdSaHDOILL2EvP3ufETKP52kn1WvmJ5mjiwumFYS139+FiAECkdhrAi1n6SYPNM5LI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756937516; c=relaxed/simple;
	bh=//H9NLqXePu1whpyNHSgEtdQ71AQIS5l5wJu7LuIL7k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gH4oig7KIdNeoRvGGOm2gRQ4XjBPObVeGKfV912Nmxnmu8bv3FhpZVut+EHqJPhzr9aGAVM7c+VlTiT4/R+gE0AtiZa67FDFEX2dLTg7USKr4DqRHz/jZ4O3PjHMABXWJYRBbkS7GTkQ0/rV/vZZIX9C4k0cYAPo4cLejrWs2OA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Y5MiPDci; arc=fail smtp.client-ip=40.107.223.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wfmczl0QsazK/iV9RMBEH3rrfrVXYeJ3h4x4fCXc6AR3C9aPK1it8BMwtM31HeU70MQfV/YnFeQLMWc3R/6JHeZ6eXNBAdY/wNpRxGHDymr0sicQZY3NOecf0XBAI0FwqSzttJtI50tSMpFOrme761bJWe8Crk7ZtWpSIApprSW4bAf6OJn8/ZojPVWcDLhMzXlvsZ2lx7psTJjOi6vaBW3+EdYF+8PUUcobNFj4l5AOM6asErVtXLNAqQljcl4xuRQGnak9jpXjS3Fo75+aWSBy+47xw9+jBePcYUuuHLKEscyKnsxda7blLHZYz0qutlSN/sSWIJsSwUWV2oFoSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TRw966wQ7XPglbg9w5AFQIhL8wOsWl+G9F0WkXZOftQ=;
 b=uCl5smDmD8S4xK6hTEHetAxt+wRyhGNyr+Z3aKFtX/1+lYJWagHE53TTvXuk0ffOsIuQow1YvB1VjDIJpTeIQDgxWDnEJstzIeJfvmvy5b5BHLjAepVr8vQYILcbyOQ8VKJl16qaEMS5Qqr4hiLQdpr3M316+7lHhVfbhPknn2yZ7aOdfLA6K6PKCnWfKKYyrLZbn0pzEVHBTRZQvpAXYRKAZqKdEgwvbiXlq3ya66SrPPHqjPE3F6H/qVJwRSwSSW32ClBmWGKVQ43u6vhSy9RUhh+0MClQJbO9TN6LbgyBQvKNS0tgigQKdfZyJGlpCMaJQUl72ywYLX4NBNoN5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TRw966wQ7XPglbg9w5AFQIhL8wOsWl+G9F0WkXZOftQ=;
 b=Y5MiPDciTKdHmwn8xClxBnfri5SBkaGqpCvveqrl7nPWD2e3EdjQp2/vnAN9Dur38+fDoBGAjLl62dVksAKUgyc64OpGFp4NLTQVcx5rL7xMH6Opgf3UHpduX5eNvmQmutKEBkHIgJA6kOJ6N4Jhw3rv5BOlx+3n9dNQtlx4yP+aNWWSGBME3/6vplKtd3Y6fiURyneoM2TNyLPDeeVUz33aQb719zCV/zrGrKBPiJx1bqgyOjWWMtkdY2BlotLALxNXoLFgz9zv9iDU9OZegqYzz0gmcX7gYi2A46zlN3FjTQ740wbRbJfz/V2pXeHOvdlOjq963ZxlaJeXGM+sAg==
Received: from MN2PR20CA0051.namprd20.prod.outlook.com (2603:10b6:208:235::20)
 by DS0PR12MB6485.namprd12.prod.outlook.com (2603:10b6:8:c6::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9073.27; Wed, 3 Sep 2025 22:11:41 +0000
Received: from BL02EPF00021F6D.namprd02.prod.outlook.com
 (2603:10b6:208:235:cafe::40) by MN2PR20CA0051.outlook.office365.com
 (2603:10b6:208:235::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.28 via Frontend Transport; Wed,
 3 Sep 2025 22:11:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF00021F6D.mail.protection.outlook.com (10.167.249.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.14 via Frontend Transport; Wed, 3 Sep 2025 22:11:41 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 15:11:22 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 15:11:21 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Wed, 3 Sep 2025 15:11:21 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <dakr@kernel.org>,
	<acurrid@nvidia.com>, <cjia@nvidia.com>, <smitra@nvidia.com>,
	<ankita@nvidia.com>, <aniketa@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC v2 13/14] vfio/nvidia-vgpu: introduce vGPU logging
Date: Wed, 3 Sep 2025 15:11:10 -0700
Message-ID: <20250903221111.3866249-14-zhiw@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250903221111.3866249-1-zhiw@nvidia.com>
References: <20250903221111.3866249-1-zhiw@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6D:EE_|DS0PR12MB6485:EE_
X-MS-Office365-Filtering-Correlation-Id: 5464016e-59cd-4590-c1d4-08ddeb36dc7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VGNPblpmNDY1aWdOMWNHVkszRHVwbzhhaUVrcWI4bVpNTVh4UFB4QTlLNUI4?=
 =?utf-8?B?Vm5ja0hvRXZuMzZhd1JNTGI1ODBQaVZGQStaY1F2bnljY1plVjlldTk3Unk3?=
 =?utf-8?B?NEF6K0x2M1RScFVxU002YUx1aUFqSmtkdnpGWDNSQUp4WHJ5amJLZWVTQktr?=
 =?utf-8?B?RGtKWmp5dUl6azBuc3lBaGtnakp1M3dyQW03N0ZGL2dZb1RIZlZMSWhJMnRu?=
 =?utf-8?B?cFNzdy9jOFYwbXp3MkJNMHBaeGNoN0tzbXM0SnVCT3Rhb2k2bFRZaWpVZEp1?=
 =?utf-8?B?cDhjd1hmaUlJYU1tMVdJR0k0ZjlaN2FPZzVOeCt4RUdYS1VDTGhQUVI4aUJT?=
 =?utf-8?B?cnBra1FQK3pLU2lFL0d3RTRHaFByeFpxNXNZUVFWTkowL0lMVWlYMXcrZ2Ja?=
 =?utf-8?B?aXhPaDBVSEd0OVdWai9PdVV4VzFkMHVFdk1rUjZiVm5nWlFkdjFwVll0UG11?=
 =?utf-8?B?TzEwcjBLYzJzTUZBc0FkMlZ3R2ZFd04yTE1hT1RCWTBUQ1BpUkFYR085Sko2?=
 =?utf-8?B?WVhvK0tFVStSTlZXRmxSVDBGSVV2NEs4OUdRWkUxVVhBSFo3enhkWHE2YUVB?=
 =?utf-8?B?U1YvdVZ5cERRazhXZCt0d29DUTlmN0FsajQ0MUZlMUlKRDN4SHZkMFhPVXky?=
 =?utf-8?B?UFYwdmE1aHljOXU5R3dKbFdlWTExelhQdUUvaEdpdmZ5OUprYkRKNEkyT2N1?=
 =?utf-8?B?S3l6ODc4Z3krR1BzUmx2ekJPUlFNa2FFZWtNTHlHZjVEdDdjc1R3dUNWemgw?=
 =?utf-8?B?NFFSbnVZVi9Ed2lKRFlyK0FJSTRKMk0zbE1maEY4RGpyd0IzSDJVMWJNNytm?=
 =?utf-8?B?ckFCSWlETzAxcjdHN3RuM2hOdnM4Z1pqckRVM1lrb25iU2FNcmp4ZUJ2L0Jl?=
 =?utf-8?B?KytQNUVNdHErY0k2dzVjUGJCUCt4LzRtbXZOUUtvTlZ6UDR1MVlhdDk4NGh3?=
 =?utf-8?B?OWdlWXJnemtmN0RCS2RMbzNuSGgxUDk1WTNmNkszS1Q4Rkdoc3Q0ZFVwMTNx?=
 =?utf-8?B?WW5lbWlNbWFHYlRKSXhXbE0zeVhDSXpvZTVCMFVnajBKRCtVMkNmTnArK2ZD?=
 =?utf-8?B?RU1jQzJRYUUvQ2J5bHlUclIvdlBUajF3Y3hqbmtsNkV1eG1xVktnT1diQkNp?=
 =?utf-8?B?YkxrWjhXdXQxOTNnOXA4Mm10WmdtZkhybDZEK2JBWTdjWHlIWXBWRzV4NmRu?=
 =?utf-8?B?dTJsTU0rVnBtUUhBSzY5SzJZZHFDV3JjOVN0R0xZdDZSSTFmbFV1MXhGSkRN?=
 =?utf-8?B?N0ZtNnBXNFRKYkh5R1V3K3hlZkQ0UUt0cUNsWEM2UnQ5SDY0a2pPMHF4d0Fn?=
 =?utf-8?B?dkxwSjFlU1dSdWxUL255RklaSm1mMG4xRXcyOWdIK2lieHFwSmdVWjJDRXJn?=
 =?utf-8?B?WCt5ZHNIWWovVW1hc2RDeWx3K1NaQUZ2c2V4WUlUQ3ExN3c0dENFWnluV1VR?=
 =?utf-8?B?VUpNaEhWTEw4NXhBczhieDIyeWhQRU9oMUhLWGtDQUdVU2JyTFZyWTJ0cTRu?=
 =?utf-8?B?ZG9hVWZNUnJqa0lrVW9tdFpIRUxxMTIyWmlpRXZITkpPMHBEZUVhTjVueDVY?=
 =?utf-8?B?d3Myc3Brcm1nSjRJZWZNeGZwaHZabXlTUkNkMTRNbWx1MitqRnZDcDNPM2My?=
 =?utf-8?B?VzNDT0xteGZHOW9COUFEME5nUUVhQmlEWHJZaHJibzhZMVJkTGZxOG5LL0tq?=
 =?utf-8?B?ZDJjV0dKNnFJK2tUVGE0TTNWNkU0T0ErZGttTGxRNHBsVysxY3hvV2dRVnVN?=
 =?utf-8?B?cUtSZHVjUEJyNlBiMkhVYUFXK2FpbHJyVTQvZUNaUkRzYzNJWWFLNnpMcE85?=
 =?utf-8?B?M0drRTY1QUQxWUhlbWIrbGVZNjJQU0hOenp2R1VGcGpRY0dEM2xtTXVSUnNo?=
 =?utf-8?B?Z3RSK0pYZlp1cnRxL1BrWldqT0NjYlFEZWh1elpId1VvREd1c08rU1QyMkYx?=
 =?utf-8?B?LzdrUTlDZEJzYlA2bXhZUjFqRFJiZ0pMa0hLMDc5SDNFMVVpU0VNZ1Y5QTZJ?=
 =?utf-8?B?cTBSeWNWMHNzQXZRUFZZUmxuR0hEQnNDeVUxUm5TWHY1VFVieHNqaEJXRjJC?=
 =?utf-8?Q?HrmBp9?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 22:11:41.4584
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5464016e-59cd-4590-c1d4-08ddeb36dc7c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6485

The GSP firmware provides several per-vGPU logging buffers to help on
debugging bugs.

Export those buffers to userspace. Thus, the user can attach them when
reporting bugs.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 drivers/vfio/pci/nvidia-vgpu/Makefile       |   4 +-
 drivers/vfio/pci/nvidia-vgpu/debugfs.c      |  65 +++++++++++
 drivers/vfio/pci/nvidia-vgpu/vfio.h         |  16 +++
 drivers/vfio/pci/nvidia-vgpu/vfio_debugfs.c | 117 ++++++++++++++++++++
 drivers/vfio/pci/nvidia-vgpu/vfio_main.c    |  44 +++++++-
 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h     |   2 +
 6 files changed, 245 insertions(+), 3 deletions(-)
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/debugfs.c
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/vfio_debugfs.c

diff --git a/drivers/vfio/pci/nvidia-vgpu/Makefile b/drivers/vfio/pci/nvidia-vgpu/Makefile
index 2aba9b4868aa..615712b40128 100644
--- a/drivers/vfio/pci/nvidia-vgpu/Makefile
+++ b/drivers/vfio/pci/nvidia-vgpu/Makefile
@@ -2,5 +2,5 @@
 subdir-ccflags-y += -I$(src)/include
 
 obj-$(CONFIG_NVIDIA_VGPU_VFIO_PCI) += nvidia_vgpu_vfio_pci.o
-nvidia_vgpu_vfio_pci-y := vgpu_mgr.o vgpu.o metadata.o metadata_vgpu_type.o rpc.o \
-			  vfio_main.o vfio_access.o vfio_sysfs.o
+nvidia_vgpu_vfio_pci-y := vgpu_mgr.o vgpu.o metadata.o metadata_vgpu_type.o rpc.o debugfs.o\
+			  vfio_main.o vfio_access.o vfio_sysfs.o vfio_debugfs.o
diff --git a/drivers/vfio/pci/nvidia-vgpu/debugfs.c b/drivers/vfio/pci/nvidia-vgpu/debugfs.c
new file mode 100644
index 000000000000..e6cdf44cd846
--- /dev/null
+++ b/drivers/vfio/pci/nvidia-vgpu/debugfs.c
@@ -0,0 +1,65 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright © 2025 NVIDIA Corporation
+ */
+
+#include <linux/debugfs.h>
+
+#include "vgpu_mgr.h"
+
+struct debugfs_root {
+	/* mutex to protect the debugfs_root */
+	struct mutex mutex;
+	struct kref refcount;
+	struct dentry *root;
+};
+
+struct debugfs_root debugfs_root = {
+	.mutex = __MUTEX_INITIALIZER(debugfs_root.mutex),
+};
+
+struct dentry *nvidia_vgpu_get_debugfs_root(void)
+{
+	struct debugfs_root *root = &debugfs_root;
+	struct dentry *dentry;
+
+	mutex_lock(&root->mutex);
+	if (root->root) {
+		kref_get(&root->refcount);
+		dentry = root->root;
+		goto out_unlock;
+	}
+
+	dentry = debugfs_create_dir("nvidia-vgpu", NULL);
+	if (IS_ERR(dentry))
+		goto out_unlock;
+
+	kref_init(&root->refcount);
+	root->root = dentry;
+
+out_unlock:
+	mutex_unlock(&root->mutex);
+	return dentry;
+}
+
+static void debugfs_root_release(struct kref *kref)
+{
+	struct debugfs_root *root = container_of(kref, struct debugfs_root, refcount);
+
+	debugfs_remove(root->root);
+	root->root = NULL;
+}
+
+void nvidia_vgpu_put_debugfs_root(void)
+{
+	struct debugfs_root *root = &debugfs_root;
+
+	mutex_lock(&root->mutex);
+	if (WARN_ON(!root->root))
+		goto out_unlock;
+
+	kref_put(&root->refcount, debugfs_root_release);
+
+out_unlock:
+	mutex_unlock(&root->mutex);
+}
diff --git a/drivers/vfio/pci/nvidia-vgpu/vfio.h b/drivers/vfio/pci/nvidia-vgpu/vfio.h
index 4c9bf9c80f5c..8edc8cd6c6dc 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vfio.h
+++ b/drivers/vfio/pci/nvidia-vgpu/vfio.h
@@ -6,6 +6,7 @@
 #ifndef _NVIDIA_VGPU_VFIO_H__
 #define _NVIDIA_VGPU_VFIO_H__
 
+#include <linux/debugfs.h>
 #include <linux/vfio_pci_core.h>
 
 #include "vgpu_mgr.h"
@@ -15,6 +16,12 @@
 #define CAP_LIST_NEXT_PTR_MSIX 0x7c
 #define MSIX_CAP_SIZE   0xc
 
+struct nvidia_vgpu_vfio_log {
+	struct debugfs_blob_wrapper blob;
+	void *mem;
+	struct dentry *dentry;
+};
+
 struct nvidia_vgpu_vfio {
 	struct vfio_pci_core_device core_dev;
 	u8 vconfig[PCI_CONFIG_SPACE_LENGTH];
@@ -32,6 +39,12 @@ struct nvidia_vgpu_vfio {
 	struct completion vdev_closing_completion;
 
 	struct nvidia_vgpu_event_listener pf_driver_event_listener;
+	struct nvidia_vgpu_event_listener pf_event_listener;
+
+	/* Logs */
+	struct nvidia_vgpu_vfio_log log_init_task;
+	struct nvidia_vgpu_vfio_log log_vgpu_task;
+	struct nvidia_vgpu_vfio_log log_kernel;
 };
 
 static inline struct nvidia_vgpu_vfio *core_dev_to_nvdev(struct vfio_pci_core_device *core_dev)
@@ -45,5 +58,8 @@ ssize_t nvidia_vgpu_vfio_access(struct nvidia_vgpu_vfio *nvdev, char __user *buf
 
 int nvidia_vgpu_vfio_setup_sysfs(struct nvidia_vgpu_vfio *nvdev);
 void nvidia_vgpu_vfio_clean_sysfs(struct nvidia_vgpu_vfio *nvdev);
+int nvidia_vgpu_vfio_setup_debugfs(struct nvidia_vgpu_vfio *nvdev);
+void nvidia_vgpu_vfio_clean_debugfs(struct nvidia_vgpu_vfio *nvdev);
+void nvidia_vgpu_vfio_update_logs(struct nvidia_vgpu_vfio *nvdev);
 
 #endif /* _NVIDIA_VGPU_VFIO_H__ */
diff --git a/drivers/vfio/pci/nvidia-vgpu/vfio_debugfs.c b/drivers/vfio/pci/nvidia-vgpu/vfio_debugfs.c
new file mode 100644
index 000000000000..52a80928f74f
--- /dev/null
+++ b/drivers/vfio/pci/nvidia-vgpu/vfio_debugfs.c
@@ -0,0 +1,117 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright © 2025 NVIDIA Corporation
+ */
+
+#include <linux/debugfs.h>
+
+#include "vfio.h"
+
+static void free_vgpu_log(struct nvidia_vgpu_vfio_log *log)
+{
+	debugfs_remove(log->dentry);
+	kvfree(log->mem);
+	log->mem = NULL;
+}
+
+static void clean_vgpu_logs(struct nvidia_vgpu_vfio *nvdev)
+{
+	free_vgpu_log(&nvdev->log_init_task);
+	free_vgpu_log(&nvdev->log_vgpu_task);
+	free_vgpu_log(&nvdev->log_kernel);
+}
+
+static int alloc_vgpu_log(struct nvidia_vgpu_vfio_log *log, struct device *dev,
+			  struct dentry *root, const char *name, u64 size)
+{
+	void *path = NULL;
+
+	path = kzalloc(PATH_MAX, GFP_KERNEL);
+	if (!path)
+		return -ENOMEM;
+
+	log->mem = kvzalloc(size, GFP_KERNEL);
+	if (!log->mem) {
+		kfree(log->mem);
+		return -ENOMEM;
+	}
+
+	log->blob.size = size;
+	log->blob.data = log->mem;
+
+	snprintf(path, PATH_MAX, "%s-%s", dev_name(dev), name);
+	log->dentry = debugfs_create_blob(path, 0400, root, &log->blob);
+
+	kfree(path);
+	path = NULL;
+
+	if (IS_ERR(log->dentry)) {
+		kfree(log->mem);
+		return PTR_ERR(log->dentry);
+	}
+	return 0;
+}
+
+static int setup_vgpu_logs(struct nvidia_vgpu_vfio *nvdev, struct dentry *root)
+{
+	struct nvidia_vgpu_mgr *vgpu_mgr = nvdev->vgpu_mgr;
+	struct device *dev = &nvdev->core_dev.pdev->dev;
+	int ret;
+
+	ret = alloc_vgpu_log(&nvdev->log_init_task, dev, root, "init_task_log",
+			     vgpu_mgr->init_task_log_size);
+	if (ret)
+		return ret;
+
+	ret = alloc_vgpu_log(&nvdev->log_vgpu_task, dev, root, "vgpu_task_log",
+			     vgpu_mgr->vgpu_task_log_size);
+	if (ret) {
+		free_vgpu_log(&nvdev->log_init_task);
+		return ret;
+	}
+
+	ret = alloc_vgpu_log(&nvdev->log_kernel, dev, root, "kernel_log",
+			     vgpu_mgr->kernel_log_size);
+	if (ret) {
+		free_vgpu_log(&nvdev->log_init_task);
+		free_vgpu_log(&nvdev->log_vgpu_task);
+		return ret;
+	}
+	return 0;
+}
+
+int nvidia_vgpu_vfio_setup_debugfs(struct nvidia_vgpu_vfio *nvdev)
+{
+	struct dentry *root = nvidia_vgpu_get_debugfs_root();
+	int ret;
+
+	if (IS_ERR(root))
+		return PTR_ERR(root);
+
+	ret = setup_vgpu_logs(nvdev, root);
+	if (ret) {
+		nvidia_vgpu_put_debugfs_root();
+		return ret;
+	}
+
+	return 0;
+}
+
+void nvidia_vgpu_vfio_clean_debugfs(struct nvidia_vgpu_vfio *nvdev)
+{
+	clean_vgpu_logs(nvdev);
+	nvidia_vgpu_put_debugfs_root();
+}
+
+void nvidia_vgpu_vfio_update_logs(struct nvidia_vgpu_vfio *nvdev)
+{
+	struct nvidia_vgpu_vfio_log *logs[] = {
+		&nvdev->log_init_task,
+		&nvdev->log_vgpu_task,
+		&nvdev->log_kernel,
+	};
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(logs); i++)
+		memcpy(logs[i]->mem, logs[i]->blob.data, logs[i]->blob.size);
+}
diff --git a/drivers/vfio/pci/nvidia-vgpu/vfio_main.c b/drivers/vfio/pci/nvidia-vgpu/vfio_main.c
index b557062a4ac2..4a6d939046e0 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vfio_main.c
+++ b/drivers/vfio/pci/nvidia-vgpu/vfio_main.c
@@ -24,10 +24,41 @@ static int pdev_to_gfid(struct pci_dev *pdev)
 	return pci_iov_vf_id(pdev) + 1;
 }
 
+static void disable_vgpu_logs(struct nvidia_vgpu_vfio *nvdev)
+{
+	if (WARN_ON(!nvdev->vgpu))
+		return;
+
+	/* save the latest vGPU logs before disabling */
+	nvidia_vgpu_vfio_update_logs(nvdev);
+
+	nvdev->log_init_task.blob.data = nvdev->log_init_task.mem;
+	nvdev->log_vgpu_task.blob.data = nvdev->log_vgpu_task.mem;
+	nvdev->log_kernel.blob.data = nvdev->log_kernel.mem;
+}
+
+static void enable_vgpu_logs(struct nvidia_vgpu_vfio *nvdev)
+{
+	struct nvidia_vgpu *vgpu = nvdev->vgpu;
+	struct nvidia_vgpu_mgmt *mgmt = &vgpu->mgmt;
+
+	if (WARN_ON(!vgpu))
+		return;
+
+	nvdev->log_init_task.blob.data = mgmt->init_task_log_vaddr;
+	nvdev->log_vgpu_task.blob.data = mgmt->vgpu_task_log_vaddr;
+	nvdev->log_kernel.blob.data = mgmt->kernel_log_vaddr;
+
+	/* get the latest vGPU logs after enabling */
+	nvidia_vgpu_vfio_update_logs(nvdev);
+}
+
 static int destroy_vgpu(struct nvidia_vgpu_vfio *nvdev)
 {
 	int ret;
 
+	disable_vgpu_logs(nvdev);
+
 	ret = nvidia_vgpu_mgr_destroy_vgpu(nvdev->vgpu);
 	if (ret)
 		return ret;
@@ -68,6 +99,8 @@ static int create_vgpu(struct nvidia_vgpu_vfio *nvdev)
 	}
 
 	nvdev->vgpu = vgpu;
+
+	enable_vgpu_logs(nvdev);
 	return 0;
 }
 
@@ -582,11 +615,14 @@ static void unregister_pf_driver_event_listener(struct nvidia_vgpu_vfio *nvdev)
 
 static void clean_nvdev(struct nvidia_vgpu_vfio *nvdev)
 {
-	if (nvdev->driver_is_unbound)
+	if (nvdev->driver_is_unbound) {
+		nvidia_vgpu_vfio_clean_debugfs(nvdev);
 		return;
+	}
 
 	unregister_pf_driver_event_listener(nvdev);
 	nvidia_vgpu_vfio_clean_sysfs(nvdev);
+	nvidia_vgpu_vfio_clean_debugfs(nvdev);
 
 	nvidia_vgpu_mgr_release(nvdev->vgpu_mgr);
 	nvdev->vgpu_mgr = NULL;
@@ -608,6 +644,12 @@ static int setup_nvdev(void *priv, void *data)
 	if (ret)
 		return ret;
 
+	ret = nvidia_vgpu_vfio_setup_debugfs(nvdev);
+	if (ret) {
+		nvidia_vgpu_vfio_clean_sysfs(nvdev);
+		return ret;
+	}
+
 	register_pf_driver_event_listener(nvdev);
 	return 0;
 }
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
index b5bcde555a5d..04fef4f69793 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
@@ -225,5 +225,7 @@ int nvidia_vgpu_rpc_call(struct nvidia_vgpu *vgpu, u32 msg_type,
 void nvidia_vgpu_clean_rpc(struct nvidia_vgpu *vgpu);
 int nvidia_vgpu_setup_rpc(struct nvidia_vgpu *vgpu);
 int nvidia_vgpu_mgr_set_bme(struct nvidia_vgpu *vgpu, bool enable);
+struct dentry *nvidia_vgpu_get_debugfs_root(void);
+void nvidia_vgpu_put_debugfs_root(void);
 
 #endif
-- 
2.34.1


