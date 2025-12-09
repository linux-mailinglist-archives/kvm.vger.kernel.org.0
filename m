Return-Path: <kvm+bounces-65573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B0944CB0A49
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 17:54:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AA600300722D
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 16:54:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA590330316;
	Tue,  9 Dec 2025 16:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qqPwZrrc"
X-Original-To: kvm@vger.kernel.org
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012008.outbound.protection.outlook.com [40.107.200.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE26732AAAD;
	Tue,  9 Dec 2025 16:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765299193; cv=fail; b=cJwGF8CmUT9/GOpeU9w6VGMqelpigv5Gdlj9kF9tqau0x7jWmTjcKd4/XPHDKb3lN3yJMjslhK/gORgwiCwUlhBssiRTwb15GOAaC4dA/4fo73MDHd2TA/rb5Tir96l8O5xyFArueDz+NhbVEuZ/+XFsR5ablomJo41enM9wwZw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765299193; c=relaxed/simple;
	bh=wPgvua/53TuIIz46ZN4ARi8jhA4VaiO+Re1mLw/zlq0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QQPg8nAFV2fU7UzRQo2Q3HEPy9+dQ41KJAxaq9W5h4VdIiBY+4f+y/LYunMHJeIMi5fyu7p7QiionJI4dZEOxDJ30TLHUDIeRhPnQIs61905D3x4SFw9/aXmSfsxWuImC6J69FnAed41w6M2Hgy87Yg94S4sBNInk6Qz+Y9Cwvw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qqPwZrrc; arc=fail smtp.client-ip=40.107.200.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ievxCybQJrg3lOQdaedW4y7P7bs6Tq22zWr12ra4StbbuevrEYDe1RIoB6Bt3b5ipNZfhN/Ay6DJpyZoa9GfXMplk+7AQMgzJH2Jnkp2rWmk0f4QPXt0HZelBjngt3Syyt7NdNubu6fgmSFwI2uSGheV4MD2u5V9Oid9YnnLQqVcfwKo+VNtfU4ijgMBtxc5rooFa2oRIDISv1+bGNBeDTCg4SnmwU1V6L9kp/0peX+NaTD8E17gaEoDNEFu7RO/tBJScmi4W2CIvBRY2IEHEtqseoxTJUr2Ysl550397S8NUxSFvGp32QKu9bNbwGUtXOHe3dc48HEyD/QMAqxgLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NefEiDMnn+AYgYqg3KznnZhXKJ03HqLn7MNFz1hKNjA=;
 b=ajxj9ff+o/+RMuPX9zPQcOY7LQSN7wupIi6jB5RTwEEJ8UCveu4hs7nWvoWDYNu2UtQhDx2ZQO+WVA93fXpwiM9cX3uMLry9A8EHRC0CVTqn95M3Z1rXbNU3eglEw9RyHsQcfHeF+vzXMDP5C17fd6vCMWM2pa2yQik1FU5mAr2GjR2iY0zgiam2ZEnTKHBpZV+DrR1TSUrafB3ldK/V5L0tNy8iyE9l08c405uKZXlg2rJ9kSneRoGjgm00m4B/2bHPIRTud9AB0IPlzc+ZwRXjc1+nMNhu9fTV0OEJNPs7yIJxneTY1r7SWx7HlhYw2dtE2EReMr4X6tMbDB6xhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NefEiDMnn+AYgYqg3KznnZhXKJ03HqLn7MNFz1hKNjA=;
 b=qqPwZrrcJsOJQjMsawD41ljmM7j7KMwyemHFuCtS2iZOzyvuzWJtdR2cG5Hik2+de26Hn7gQDct39AcqzKSdIik4BiHwIQflkaE1xveEioZ2Hbs3A2I+33VKg51gzolLpuUKita7G6b9nTunJXe/nWEcPQHXMUbBbN/2RXOlvO+EBqIBbVGUVdesMGM3MI8DXqC4IY9rOkl4+fR7xQ8a3HKJTYkRYi8sEUsL3X6ST8N3oEhWD0Cf/s8TQMU2KMG5U0ociVrSWWPHbcsBdagBIy+/ncPlqaAFLeBO4FkctoFreAzg3RraRjwk6L05SLMw+JLGEDSHoOZIU4zKHv364w==
Received: from SJ0PR03CA0264.namprd03.prod.outlook.com (2603:10b6:a03:3a0::29)
 by SJ2PR12MB8883.namprd12.prod.outlook.com (2603:10b6:a03:538::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Tue, 9 Dec
 2025 16:53:01 +0000
Received: from SJ1PEPF00002316.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0:cafe::f5) by SJ0PR03CA0264.outlook.office365.com
 (2603:10b6:a03:3a0::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.14 via Frontend Transport; Tue,
 9 Dec 2025 16:52:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF00002316.mail.protection.outlook.com (10.167.242.170) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Tue, 9 Dec 2025 16:52:58 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 9 Dec
 2025 08:52:35 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 9 Dec
 2025 08:52:35 -0800
Received: from nvidia-4028GR-scsim.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 9 Dec 2025 08:52:28 -0800
From: <mhonap@nvidia.com>
To: <aniketa@nvidia.com>, <ankita@nvidia.com>, <alwilliamson@nvidia.com>,
	<vsethi@nvidia.com>, <jgg@nvidia.com>, <mochs@nvidia.com>,
	<skolothumtho@nvidia.com>, <alejandro.lucero-palau@amd.com>,
	<dave@stgolabs.net>, <jonathan.cameron@huawei.com>, <dave.jiang@intel.com>,
	<alison.schofield@intel.com>, <vishal.l.verma@intel.com>,
	<ira.weiny@intel.com>, <dan.j.williams@intel.com>, <jgg@ziepe.ca>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>
CC: <cjia@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <kjaju@nvidia.com>, <linux-kernel@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <kvm@vger.kernel.org>, <mhonap@nvidia.com>
Subject: [RFC v2 14/15] vfio/cxl: VFIO variant driver for QEMU CXL accel device
Date: Tue, 9 Dec 2025 22:20:18 +0530
Message-ID: <20251209165019.2643142-15-mhonap@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251209165019.2643142-1-mhonap@nvidia.com>
References: <20251209165019.2643142-1-mhonap@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002316:EE_|SJ2PR12MB8883:EE_
X-MS-Office365-Filtering-Correlation-Id: f5c4d4bd-326d-4d57-7ebe-08de3743687c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|1800799024|376014|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ptSsO52z3LXpC162LgwFm/dHA93CN4QLZplYyReGW26UiA2JcYFZi/o1jRIk?=
 =?us-ascii?Q?d8pmQOcvZyx3/O8qVLyZzD2HP2KFbfMi8z03lvlQyodD8Fsk4lXKTbkoIxVQ?=
 =?us-ascii?Q?4fsgMW2ApD+yAuctllxXTr81ccfyqHsTpEXV4bwLnMxLtJcaavkIipRJxhpr?=
 =?us-ascii?Q?q9bBbebIaJpsHWn7W1WiVUuXzuT2wfLpAmeZH9LReefQF+/zNQKpg8cOgPq6?=
 =?us-ascii?Q?3+Gi6pBXIpae520PRnt6jxsG6owvTi8EX13B0ZEBYyOiTQE3EgSVnLTlQMfY?=
 =?us-ascii?Q?pqOaj3nghl058Xg4fwjyg53XKEgeyPcBo1qAr5Mq+nzy/vBQShnir9oe7etM?=
 =?us-ascii?Q?9aW2qwgxEgiCOlW8nA6GnsHSMmSLoQdKfmoH4vjUMwUpQpzey2ghFj9+1tui?=
 =?us-ascii?Q?Xuy1uOHJnXLAAD6p08+YSWC/cnGRQg2rnuCYPnHR8exwfrP2kQWFR4f0TVoj?=
 =?us-ascii?Q?YsAa0a1NouwbTdMdnSSl6858VVN3bl8nlnVRMAYkVDnI5wth+Y73mZdUo0ZK?=
 =?us-ascii?Q?p626ygMimix8WwUPtZXFqX7LLUUW+LltpGK+GlmIyVAyz0aT6bcGqFuOdqbQ?=
 =?us-ascii?Q?ONImQFaSA8UllmWTcMmKuZAS1TSmjyQbUFUV2O5W9IPp6T0fdU27iEjJ6VcJ?=
 =?us-ascii?Q?RPPERDp9MDGyMpwrdYDfkAkL3XwmfetDfJ2Iy3y3X2Ur841w1ZFexOSD4tH/?=
 =?us-ascii?Q?IlzPaR9YYnVRK5fCkUKVH+yoledk+yw1JFdCbshIQSCeRfeYYoeBtDHD3g09?=
 =?us-ascii?Q?dlW+vE2Cd4/1zVtnH8fS1gEuZ0g0LZ3bPecW9GUOZKZNxTNKdM6TU8ofHbFM?=
 =?us-ascii?Q?BxQn/ylR+w54sUJ/bMb4wEURRbwqFywBPjj3fRUgt0rsfdHeuV8KQxqxb1WX?=
 =?us-ascii?Q?Hggowbem/1XUeGfwUOlHJdAC4jsCtkl246dJXJCB/Siui80ms8w8Jl9GQPLX?=
 =?us-ascii?Q?1VzRFkdFp51d1YaDHTUgr9M8A/EFdrIvwIOnUbfkzjjesRpNMkVT34VkiHDb?=
 =?us-ascii?Q?SBTFEhc9DCTYzNvdWJUdJp10UMErrUxAH7bvGBVaiL5210jgTTtBHLy6ShfS?=
 =?us-ascii?Q?U4dmtsVspS99cmpUYHeOqT+iETE86CGQUKMwrBaChiPgPh6mHWA/7I9Pkaua?=
 =?us-ascii?Q?p0P/xk2/E/lTvQ5rnt3RZxCHAWeYZAkudNE6UEkl3IT7ZHvwcjYLwSV2vzpH?=
 =?us-ascii?Q?SmD2dv8QHMfsHtXyQVli0RObHn4XXGVBwair86IQbm5D5O1RGuRXiLuR8DEH?=
 =?us-ascii?Q?yqo5fCEiDWfj8JivSfuWAlbW/Va+YTv3mTrtH6NJHflEeIXwASt5JVMSt6kF?=
 =?us-ascii?Q?8rfIGcerWc9SaLm5j/9xXUEC9KZRbUfglzwc9vJ5fnxGxN9/06RRBch2oeZr?=
 =?us-ascii?Q?J5A6jeIbqL4yEZXeXCBUZ5FiJXKRVQ3PIY1K5iR+VUj0YZljec+0hhlWS5rE?=
 =?us-ascii?Q?E95KGkx7sKgHTyQH7GwVrnD9XAccyxfFi+nbYN1dh8P2XyP+TFtEXkNO5lQw?=
 =?us-ascii?Q?XUZkcRHVMOdp52kSQu+zBLwgfVAeyfmWnLsv+ePwL3+3H+uyAcE4I7n+/ib4?=
 =?us-ascii?Q?+mbBfSoRG3AZjNtZtFUQ22sCZnd9Mw4d3ohZjNFK?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(1800799024)(376014)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 16:52:58.7247
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f5c4d4bd-326d-4d57-7ebe-08de3743687c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002316.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8883

From: Manish Honap <mhonap@nvidia.com>

To demonstrate the VFIO CXL core, a VFIO variant driver for QEMU CXL
accel device is introduced, so that people to test can try the patches.

This patch is not meant to be merged.

Co-developed-by: Zhi Wang <zhiw@nvidia.com>
Signed-off-by: Zhi Wang <zhiw@nvidia.com>
Signed-off-by: Manish Honap <mhonap@nvidia.com>
---
 drivers/vfio/pci/Kconfig            |   2 +
 drivers/vfio/pci/Makefile           |   2 +
 drivers/vfio/pci/cxl-accel/Kconfig  |   9 ++
 drivers/vfio/pci/cxl-accel/Makefile |   4 +
 drivers/vfio/pci/cxl-accel/main.c   | 143 ++++++++++++++++++++++++++++
 5 files changed, 160 insertions(+)
 create mode 100644 drivers/vfio/pci/cxl-accel/Kconfig
 create mode 100644 drivers/vfio/pci/cxl-accel/Makefile
 create mode 100644 drivers/vfio/pci/cxl-accel/main.c

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 2f441d118f1c..441ded7ea035 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -77,4 +77,6 @@ source "drivers/vfio/pci/nvgrace-gpu/Kconfig"
 
 source "drivers/vfio/pci/qat/Kconfig"
 
+source "drivers/vfio/pci/cxl-accel/Kconfig"
+
 endmenu
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index 452b7387f9fb..1b81d75b8ef7 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -22,3 +22,5 @@ obj-$(CONFIG_VIRTIO_VFIO_PCI) += virtio/
 obj-$(CONFIG_NVGRACE_GPU_VFIO_PCI) += nvgrace-gpu/
 
 obj-$(CONFIG_QAT_VFIO_PCI) += qat/
+
+obj-$(CONFIG_CXL_ACCEL_VFIO_PCI) += cxl-accel/
diff --git a/drivers/vfio/pci/cxl-accel/Kconfig b/drivers/vfio/pci/cxl-accel/Kconfig
new file mode 100644
index 000000000000..9a8884ded049
--- /dev/null
+++ b/drivers/vfio/pci/cxl-accel/Kconfig
@@ -0,0 +1,9 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config CXL_ACCEL_VFIO_PCI
+	tristate "VFIO support for the QEMU CXL accel device"
+	select VFIO_CXL_CORE
+	help
+	  VFIO support for the CXL devices is needed for assigning the CXL
+	  devices to userspace using KVM/qemu/etc.
+
+	  If you don't know what to do here, say N.
diff --git a/drivers/vfio/pci/cxl-accel/Makefile b/drivers/vfio/pci/cxl-accel/Makefile
new file mode 100644
index 000000000000..8d0e076f405f
--- /dev/null
+++ b/drivers/vfio/pci/cxl-accel/Makefile
@@ -0,0 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+obj-$(CONFIG_CXL_ACCEL_VFIO_PCI) += cxl-accel-vfio-pci.o
+cxl-accel-vfio-pci-y := main.o
diff --git a/drivers/vfio/pci/cxl-accel/main.c b/drivers/vfio/pci/cxl-accel/main.c
new file mode 100644
index 000000000000..3e5001ed5e2a
--- /dev/null
+++ b/drivers/vfio/pci/cxl-accel/main.c
@@ -0,0 +1,143 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2025, NVIDIA CORPORATION & AFFILIATES. All rights reserved
+ */
+
+#include <linux/sizes.h>
+#include <linux/vfio_pci_core.h>
+
+struct cxl_device {
+	struct vfio_pci_core_device core_device;
+};
+
+static int cxl_open_device(struct vfio_device *vdev)
+{
+	struct vfio_cxl_core_device *cxl =
+		container_of(vdev, struct vfio_cxl_core_device, pci_core.vdev);
+	struct vfio_cxl *cxl_core = cxl->cxl_core;
+	struct vfio_cxl_dev_info info = {0};
+	int ret;
+
+	/* Driver reports the device DPA and RAM size */
+	info.dpa_res = DEFINE_RES_MEM(0, SZ_256M);
+	info.ram_res = DEFINE_RES_MEM_NAMED(0, SZ_256M, "ram");
+
+	/* Initialize the CXL device and enable the vfio-pci-core */
+	ret = vfio_cxl_core_enable(cxl, &info);
+	if (ret)
+		return ret;
+
+	vfio_cxl_core_finish_enable(cxl);
+
+	cxl_core = cxl->cxl_core;
+
+	/* No precommitted region, create one. */
+	if (!cxl_core->region.region) {
+		/*
+		 * Driver can choose to create cxl region at a certain time
+		 * E.g. at driver initialization or later
+		 */
+		ret = vfio_cxl_core_create_cxl_region(cxl, SZ_256M);
+		if (ret)
+			goto fail_create_cxl_region;
+	}
+
+	ret = vfio_cxl_core_register_cxl_region(cxl);
+	if (ret)
+		goto fail_register_cxl_region;
+
+	return 0;
+
+fail_register_cxl_region:
+	if (cxl_core->region.region)
+		vfio_cxl_core_destroy_cxl_region(cxl);
+fail_create_cxl_region:
+	vfio_cxl_core_disable(cxl);
+	return ret;
+}
+
+static void cxl_close_device(struct vfio_device *vdev)
+{
+	struct vfio_cxl_core_device *cxl =
+		container_of(vdev, struct vfio_cxl_core_device, pci_core.vdev);
+
+	vfio_cxl_core_unregister_cxl_region(cxl);
+	vfio_cxl_core_destroy_cxl_region(cxl);
+	vfio_cxl_core_close_device(vdev);
+}
+
+static const struct vfio_device_ops cxl_core_ops = {
+	.name             = "cxl-vfio-pci",
+	.init             = vfio_pci_core_init_dev,
+	.release          = vfio_pci_core_release_dev,
+	.open_device      = cxl_open_device,
+	.close_device     = cxl_close_device,
+	.ioctl            = vfio_cxl_core_ioctl,
+	.device_feature   = vfio_pci_core_ioctl_feature,
+	.read             = vfio_cxl_core_read,
+	.write            = vfio_cxl_core_write,
+	.mmap             = vfio_pci_core_mmap,
+	.request          = vfio_pci_core_request,
+	.match            = vfio_pci_core_match,
+	.match_token_uuid = vfio_pci_core_match_token_uuid,
+	.bind_iommufd     = vfio_iommufd_physical_bind,
+	.unbind_iommufd   = vfio_iommufd_physical_unbind,
+	.attach_ioas      = vfio_iommufd_physical_attach_ioas,
+	.detach_ioas      = vfio_iommufd_physical_detach_ioas,
+};
+
+static int cxl_probe(struct pci_dev *pdev,
+		     const struct pci_device_id *id)
+{
+	const struct vfio_device_ops *ops = &cxl_core_ops;
+	struct vfio_cxl_core_device *cxl_device;
+	int ret;
+
+	cxl_device = vfio_alloc_device(vfio_cxl_core_device, pci_core.vdev,
+				       &pdev->dev, ops);
+	if (IS_ERR(cxl_device))
+		return PTR_ERR(cxl_device);
+
+	dev_set_drvdata(&pdev->dev, &cxl_device->pci_core);
+
+	ret = vfio_pci_core_register_device(&cxl_device->pci_core);
+	if (ret)
+		goto out_put_vdev;
+
+	return ret;
+
+out_put_vdev:
+	vfio_put_device(&cxl_device->pci_core.vdev);
+	return ret;
+}
+
+static void cxl_remove(struct pci_dev *pdev)
+{
+	struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
+
+	vfio_pci_core_unregister_device(core_device);
+	vfio_put_device(&core_device->vdev);
+}
+
+static const struct pci_device_id cxl_vfio_pci_table[] = {
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_INTEL, 0xd94) },
+	{}
+};
+
+MODULE_DEVICE_TABLE(pci, cxl_vfio_pci_table);
+
+static struct pci_driver cxl_vfio_pci_driver = {
+	.name = KBUILD_MODNAME,
+	.id_table = cxl_vfio_pci_table,
+	.probe = cxl_probe,
+	.remove = cxl_remove,
+	.err_handler = &vfio_pci_core_err_handlers,
+	.driver_managed_dma = true,
+};
+
+module_pci_driver(cxl_vfio_pci_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Zhi Wang <zhiw@nvidia.com>");
+MODULE_DESCRIPTION("VFIO variant driver for QEMU CXL accel device");
+MODULE_IMPORT_NS("CXL");
-- 
2.25.1


