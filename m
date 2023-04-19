Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42DA96E8513
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 00:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233598AbjDSWkh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 18:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbjDSWkf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 18:40:35 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2071.outbound.protection.outlook.com [40.107.93.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD9F423A;
        Wed, 19 Apr 2023 15:39:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NRTECn4+HGLfMjEG+eORwYcd0KsMSGz4qJJge9gXI0q2k82iULzmh6RuRPTxe7Al14bKEE/g/QzfipKOlUi8TrIiE5wIYfs35ia1Aruju1EPLcLGG+cx4NthCmynyA6UU9JGuWACmX4iDjwAghg2R+r207Ox0zjW0RigU5MTF33Qk/rv8ACf+xIiPUB6F1v9kFDTgiDfZi2Trvrii9qJoauQp7ct8fsHW7TvPkzUFAr9rB2tY0NGRi8T0WK4joVzdunYVoIble7xJqYSvbR3Vo+pVoNsWAM0HguD2ISviutQAQhhhwXCH/YEtS4B+uGTh4kCDgY6XvWy96p1yZ5N8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VU8hcn5/0xN5NA4M0udTwR/bQprSN04fulXi6wktK4U=;
 b=FeUxnMmFYojOEuHCRS7RDQga7mVm0qJOFaS5bFpiG9Og0FpaqjCrY6UwdXwS3/yZD7RCZejwSvhmgFsjVtIZCTRC70s+6AgShvL5ZfLCYdS2lkpDdSpQ9/MuxdLftBYRqbTlvJk0P0AivVQSX+V27YD3FsHqc5XFxCWkGHdtSBUzL7zCeAEHzPsIMUvKvibtNGb4UEFx2hM2ND38Os4y3SfOCflysKgBj8K7EX5rGmYyVb0EJobrFrF03qjMeXGsBt5mvusfyHCXG3jiiBCWFqPpOjfbSdclLwS8EmE6Zm3S59FFzriRBH0d0zcuv3Ib8oPEzwwnbI6kWnGK2SaLNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VU8hcn5/0xN5NA4M0udTwR/bQprSN04fulXi6wktK4U=;
 b=XWiPkdeJr3E1E6n07kQmWp/7V/jhV4MOAD9RHcFk1vHiGgsc5TszWnvftUxT5yiacSLfL95Igg/cgNKdkNHVh5S1GFSC0H4Aw90R7htrxn3m5Pjq1YPAPvqWTAuRao97+N6xin6OssW5hAoTAVbk63zYJUSUtGtuG+wiZ/rNrhyPFHmsfpmvt77uXkHf/2J6lUXcgvJdhEKienobJJ6VweF1p/aI2M8/RYusOMjDrfaWfdbHehQBhW+FnD672+36QgVBrsyzqDWnFEbYKykjzKry3CGgpYKTCThcAhj30NM70n/Kjxe/s9gmkMXoXsbGWKGB8oIW2+t4h+yRNoYeyg==
Received: from DS7PR05CA0064.namprd05.prod.outlook.com (2603:10b6:8:57::26) by
 CO6PR12MB5490.namprd12.prod.outlook.com (2603:10b6:303:13d::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.20; Wed, 19 Apr 2023 22:28:51 +0000
Received: from DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:57:cafe::84) by DS7PR05CA0064.outlook.office365.com
 (2603:10b6:8:57::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.9 via Frontend
 Transport; Wed, 19 Apr 2023 22:28:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT048.mail.protection.outlook.com (10.13.173.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.23 via Frontend Transport; Wed, 19 Apr 2023 22:28:51 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 19 Apr 2023
 15:28:36 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Wed, 19 Apr
 2023 15:28:36 -0700
Received: from ankita-dt2.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37 via Frontend
 Transport; Wed, 19 Apr 2023 15:28:36 -0700
From:   <ankita@nvidia.com>
To:     <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>
CC:     <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
        <targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v1 1/1] vfio/nvgpu: Add vfio pci variant module for grace hopper device
Date:   Wed, 19 Apr 2023 15:28:36 -0700
Message-ID: <20230419222836.24714-1-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT048:EE_|CO6PR12MB5490:EE_
X-MS-Office365-Filtering-Correlation-Id: 82126e5d-0a8c-423d-eb5b-08db412573d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 48VcgYqjec5Cx+uKswY1Gxx2wFbv4GIjKWI+qJqKL5zaeXjZoo8l3USRxoKkYCF5WPHYaPFm3RkE/G8ZPOpH1roaPjpsyWdf7pkl1OkTqMzcSaNoSXkmLJVvwG5MuHr3Qs3QFeAb/6qZWmNFDcB33893PVw7ALInukzcTVAScvEJxrUkW+GECGgNlqsutNuyphr452wO6Gqb/gCg8r//YCxPpgfRj5Fpx/NGwbmhS7UZC2AvdYhxRdJZBPvCKw3v2kdCl2IH5r/DConN14z69eLCPz03wsBQkl/pEKRNg7/GftXWlKARthiAXO71K73tSX0/3AKAvNbDBbIc+WpVC94JUzbHboAsVjUK/8FtviHI9AJ1bnk65Xk94EliOgnM/KRXy3Ui1ALkRfzIZAGLnJT9bUy3SAGCQPkj69C5ohn6AJ1byHa14KdMWXvzO40ZKOQTMg6NMG7CoeQcSBUftEJREPULBN425v8Vn5EWXdNvYk0D9llwnbjnqjExgKHRdE1D4H/TStyEtVql6sAeJ/W5kKSubPgayzxbX9yy5WFQnpXiwCjknd6XXyLe7yf/+RiZ563W8bcc97NsQ+MZEoyFZBmJVocms4TcBAUAKJSOF2AGOKdrXZ6mnqyjLcjBfh+iRDo5DV7KLaFZ54wud3GRqCBX961agjUY7T6Nglc0/EVU3qdSIOST+NcZwoW4vDx4L2CFmzz32MjCsloGxOBFQx3K+cXW6C8hzc0aO6TLtar5pbfpsbEQEFdCYaWco9959K2PlBPX6KLV/fj+7PzUgs1pnkssqoza/NiBUWEq+B9c7iIQCR69P347JEOpUtE5N1y8EK//waXtwbvOopb18rhd+vfQGzLkmvF1rBQ=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(39860400002)(346002)(136003)(451199021)(46966006)(36840700001)(40470700004)(7696005)(966005)(478600001)(110136005)(86362001)(34020700004)(36860700001)(47076005)(36756003)(2616005)(426003)(83380400001)(336012)(40480700001)(186003)(40460700003)(82740400003)(26005)(1076003)(82310400005)(316002)(7636003)(356005)(70206006)(30864003)(2876002)(2906002)(70586007)(5660300002)(8936002)(8676002)(41300700001)(4326008)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 22:28:51.4554
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 82126e5d-0a8c-423d-eb5b-08db412573d6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5490
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ankit Agrawal <ankita@nvidia.com>

NVIDIA's upcoming Grace Hopper Superchip provides a PCI-like device
for the on-chip GPU that is the logical OS representation of the
internal propritary cache coherent interconnect.

This representation has a number of limitations compared to a real PCI
device, in particular, it does not model the coherent GPU memory
aperture as a PCI config space BAR, and PCI doesn't know anything
about cacheable memory types.

Provide a VFIO PCI variant driver that adapts the unique PCI
representation into a more standard PCI representation facing
userspace. The GPU memory aperture is obtained from ACPI using
device_property_read_u64(), according to the FW specification,
and exported to userspace as the VFIO_REGION that covers the first
PCI BAR. qemu will naturally generate a PCI device in the VM where the
cacheable aperture is reported in BAR1.

Since this memory region is actually cache coherent with the CPU, the
VFIO variant driver will mmap it into VMA using a cacheable mapping. The
mapping is done using remap_pfn_range().

This goes along with a qemu series to provides the necessary
implementation of the Grace Hopper Superchip firmware specification so
that the guest operating system can see the correct ACPI modeling for
the coherent GPU device.
https://github.com/qemu/qemu/compare/master...ankita-nv:qemu:dev-ankit/cohmem-0330

This patch is split from a patch series being pursued separately:
https://lore.kernel.org/lkml/20230405180134.16932-2-ankita@nvidia.com/

Applied and tested over v6.3-rc4.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 MAINTAINERS                     |   6 +
 drivers/vfio/pci/Kconfig        |   2 +
 drivers/vfio/pci/Makefile       |   2 +
 drivers/vfio/pci/nvgpu/Kconfig  |  10 ++
 drivers/vfio/pci/nvgpu/Makefile |   3 +
 drivers/vfio/pci/nvgpu/main.c   | 255 ++++++++++++++++++++++++++++++++
 6 files changed, 278 insertions(+)
 create mode 100644 drivers/vfio/pci/nvgpu/Kconfig
 create mode 100644 drivers/vfio/pci/nvgpu/Makefile
 create mode 100644 drivers/vfio/pci/nvgpu/main.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 1dc8bd26b6cf..6b48756c30d3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -21954,6 +21954,12 @@ L:	kvm@vger.kernel.org
 S:	Maintained
 F:	drivers/vfio/pci/mlx5/
 
+VFIO NVIDIA PCI DRIVER
+M:	Ankit Agrawal <ankita@nvidia.com>
+L:	kvm@vger.kernel.org
+S:	Maintained
+F:	drivers/vfio/pci/nvgpu/
+
 VGA_SWITCHEROO
 R:	Lukas Wunner <lukas@wunner.de>
 S:	Maintained
diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index f9d0c908e738..ade18b0ffb7b 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -59,4 +59,6 @@ source "drivers/vfio/pci/mlx5/Kconfig"
 
 source "drivers/vfio/pci/hisilicon/Kconfig"
 
+source "drivers/vfio/pci/nvgpu/Kconfig"
+
 endif
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index 24c524224da5..0c93d452d0da 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -11,3 +11,5 @@ obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
 obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
 
 obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisilicon/
+
+obj-$(CONFIG_NVGPU_VFIO_PCI) += nvgpu/
diff --git a/drivers/vfio/pci/nvgpu/Kconfig b/drivers/vfio/pci/nvgpu/Kconfig
new file mode 100644
index 000000000000..066f764f7c5f
--- /dev/null
+++ b/drivers/vfio/pci/nvgpu/Kconfig
@@ -0,0 +1,10 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config NVGPU_VFIO_PCI
+	tristate "VFIO support for the GPU in the NVIDIA Grace Hopper Superchip"
+	depends on ARM64 || (COMPILE_TEST && 64BIT)
+	select VFIO_PCI_CORE
+	help
+	  VFIO support for the GPU in the NVIDIA Grace Hopper Superchip is
+	  required to assign the GPU device to a VM using KVM/qemu/etc.
+
+	  If you don't know what to do here, say N.
diff --git a/drivers/vfio/pci/nvgpu/Makefile b/drivers/vfio/pci/nvgpu/Makefile
new file mode 100644
index 000000000000..00fd3a078218
--- /dev/null
+++ b/drivers/vfio/pci/nvgpu/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_NVGPU_VFIO_PCI) += nvgpu-vfio-pci.o
+nvgpu-vfio-pci-y := main.o
diff --git a/drivers/vfio/pci/nvgpu/main.c b/drivers/vfio/pci/nvgpu/main.c
new file mode 100644
index 000000000000..9e08e8cf4606
--- /dev/null
+++ b/drivers/vfio/pci/nvgpu/main.c
@@ -0,0 +1,255 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved
+ */
+
+#include <linux/pci.h>
+#include <linux/vfio_pci_core.h>
+
+#define DUMMY_PFN \
+	(((nvdev->mem_prop.hpa + nvdev->mem_prop.mem_length) >> PAGE_SHIFT) - 1)
+
+struct dev_mem_properties {
+	uint64_t hpa;
+	uint64_t mem_length;
+	int bar1_start_offset;
+};
+
+struct nvgpu_vfio_pci_core_device {
+	struct vfio_pci_core_device core_device;
+	struct dev_mem_properties mem_prop;
+};
+
+static int vfio_get_bar1_start_offset(struct vfio_pci_core_device *vdev)
+{
+	u8 val = 0;
+
+	pci_read_config_byte(vdev->pdev, 0x10, &val);
+	/*
+	 * The BAR1 start offset in the PCI config space depends on the BAR0size.
+	 * Check if the BAR0 is 64b and return the approproiate BAR1 offset.
+	 */
+	if (val & PCI_BASE_ADDRESS_MEM_TYPE_64)
+		return VFIO_PCI_BAR2_REGION_INDEX;
+
+	return VFIO_PCI_BAR1_REGION_INDEX;
+}
+
+static int nvgpu_vfio_pci_open_device(struct vfio_device *core_vdev)
+{
+	struct nvgpu_vfio_pci_core_device *nvdev = container_of(
+		core_vdev, struct nvgpu_vfio_pci_core_device, core_device.vdev);
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+	int ret;
+
+	ret = vfio_pci_core_enable(vdev);
+	if (ret)
+		return ret;
+
+	vfio_pci_core_finish_enable(vdev);
+
+	nvdev->mem_prop.bar1_start_offset = vfio_get_bar1_start_offset(vdev);
+
+	return ret;
+}
+
+static int nvgpu_vfio_pci_mmap(struct vfio_device *core_vdev,
+			struct vm_area_struct *vma)
+{
+	struct nvgpu_vfio_pci_core_device *nvdev = container_of(
+		core_vdev, struct nvgpu_vfio_pci_core_device, core_device.vdev);
+
+	unsigned long start_pfn;
+	unsigned int index;
+	u64 req_len, pgoff;
+	int ret = 0;
+
+	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
+	if (index != nvdev->mem_prop.bar1_start_offset)
+		return vfio_pci_core_mmap(core_vdev, vma);
+
+	/*
+	 * Request to mmap the BAR1. Map to the CPU accessible memory on the
+	 * GPU using the memory information gathered from the system ACPI
+	 * tables.
+	 */
+	start_pfn = nvdev->mem_prop.hpa >> PAGE_SHIFT;
+	req_len = vma->vm_end - vma->vm_start;
+	pgoff = vma->vm_pgoff &
+		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
+	if (pgoff >= (nvdev->mem_prop.mem_length >> PAGE_SHIFT))
+		return -EINVAL;
+
+	/*
+	 * Perform a PFN map to the memory. The device BAR1 is backed by the
+	 * GPU memory now. Check that the mapping does not overflow out of
+	 * the GPU memory size.
+	 */
+	ret = remap_pfn_range(vma, vma->vm_start, start_pfn + pgoff,
+			      min(req_len, nvdev->mem_prop.mem_length - pgoff),
+			      vma->vm_page_prot);
+	if (ret)
+		return ret;
+
+	vma->vm_pgoff = start_pfn + pgoff;
+
+	return 0;
+}
+
+static long nvgpu_vfio_pci_ioctl(struct vfio_device *core_vdev,
+			unsigned int cmd, unsigned long arg)
+{
+	struct nvgpu_vfio_pci_core_device *nvdev = container_of(
+		core_vdev, struct nvgpu_vfio_pci_core_device, core_device.vdev);
+
+	unsigned long minsz = offsetofend(struct vfio_region_info, offset);
+	struct vfio_region_info info;
+
+	switch (cmd) {
+	case VFIO_DEVICE_GET_REGION_INFO:
+		if (copy_from_user(&info, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (info.argsz < minsz)
+			return -EINVAL;
+
+		if (info.index == nvdev->mem_prop.bar1_start_offset) {
+			/*
+			 * Request to determine the BAR1 region information. Send the
+			 * GPU memory information.
+			 */
+			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+			info.size = nvdev->mem_prop.mem_length;
+			info.flags = VFIO_REGION_INFO_FLAG_READ |
+				     VFIO_REGION_INFO_FLAG_WRITE |
+				     VFIO_REGION_INFO_FLAG_MMAP;
+			return copy_to_user((void __user *)arg, &info, minsz) ?
+				       -EFAULT : 0;
+		}
+
+		if (info.index == nvdev->mem_prop.bar1_start_offset + 1) {
+			/*
+			 * The BAR1 region is 64b. Ignore this access.
+			 */
+			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+			info.size = 0;
+			info.flags = 0;
+			return copy_to_user((void __user *)arg, &info, minsz) ?
+				-EFAULT : 0;
+		}
+
+		return vfio_pci_core_ioctl(core_vdev, cmd, arg);
+
+	default:
+		return vfio_pci_core_ioctl(core_vdev, cmd, arg);
+	}
+}
+
+static const struct vfio_device_ops nvgpu_vfio_pci_ops = {
+	.name = "nvgpu-vfio-pci",
+	.init = vfio_pci_core_init_dev,
+	.release = vfio_pci_core_release_dev,
+	.open_device = nvgpu_vfio_pci_open_device,
+	.close_device = vfio_pci_core_close_device,
+	.ioctl = nvgpu_vfio_pci_ioctl,
+	.read = vfio_pci_core_read,
+	.write = vfio_pci_core_write,
+	.mmap = nvgpu_vfio_pci_mmap,
+	.request = vfio_pci_core_request,
+	.match = vfio_pci_core_match,
+	.bind_iommufd = vfio_iommufd_physical_bind,
+	.unbind_iommufd = vfio_iommufd_physical_unbind,
+	.attach_ioas = vfio_iommufd_physical_attach_ioas,
+};
+
+static struct nvgpu_vfio_pci_core_device *nvgpu_drvdata(struct pci_dev *pdev)
+{
+	struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
+
+	return container_of(core_device, struct nvgpu_vfio_pci_core_device,
+			    core_device);
+}
+
+static int
+nvgpu_vfio_pci_fetch_memory_property(struct pci_dev *pdev,
+				     struct nvgpu_vfio_pci_core_device *nvdev)
+{
+	int ret = 0;
+
+	/*
+	 * The memory information is present in the system ACPI tables as DSD
+	 * properties nvidia,gpu-mem-base-pa and nvidia,gpu-mem-size.
+	 */
+	ret = device_property_read_u64(&(pdev->dev), "nvidia,gpu-mem-base-pa",
+				       &(nvdev->mem_prop.hpa));
+	if (ret)
+		return ret;
+
+	ret = device_property_read_u64(&(pdev->dev), "nvidia,gpu-mem-size",
+				       &(nvdev->mem_prop.mem_length));
+	return ret;
+}
+
+static int nvgpu_vfio_pci_probe(struct pci_dev *pdev,
+				const struct pci_device_id *id)
+{
+	struct nvgpu_vfio_pci_core_device *nvdev;
+	int ret;
+
+	nvdev = vfio_alloc_device(nvgpu_vfio_pci_core_device, core_device.vdev,
+				  &pdev->dev, &nvgpu_vfio_pci_ops);
+	if (IS_ERR(nvdev))
+		return PTR_ERR(nvdev);
+
+	dev_set_drvdata(&pdev->dev, nvdev);
+
+	ret = nvgpu_vfio_pci_fetch_memory_property(pdev, nvdev);
+	if (ret)
+		goto out_put_vdev;
+
+	ret = vfio_pci_core_register_device(&nvdev->core_device);
+	if (ret)
+		goto out_put_vdev;
+
+	return ret;
+
+out_put_vdev:
+	vfio_put_device(&nvdev->core_device.vdev);
+	return ret;
+}
+
+static void nvgpu_vfio_pci_remove(struct pci_dev *pdev)
+{
+	struct nvgpu_vfio_pci_core_device *nvdev = nvgpu_drvdata(pdev);
+	struct vfio_pci_core_device *vdev = &nvdev->core_device;
+
+	vfio_pci_core_unregister_device(vdev);
+	vfio_put_device(&vdev->vdev);
+}
+
+static const struct pci_device_id nvgpu_vfio_pci_table[] = {
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2342) },
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2343) },
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2345) },
+	{}
+};
+
+MODULE_DEVICE_TABLE(pci, nvgpu_vfio_pci_table);
+
+static struct pci_driver nvgpu_vfio_pci_driver = {
+	.name = KBUILD_MODNAME,
+	.id_table = nvgpu_vfio_pci_table,
+	.probe = nvgpu_vfio_pci_probe,
+	.remove = nvgpu_vfio_pci_remove,
+	.err_handler = &vfio_pci_core_err_handlers,
+	.driver_managed_dma = true,
+};
+
+module_pci_driver(nvgpu_vfio_pci_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Ankit Agrawal <ankita@nvidia.com>");
+MODULE_AUTHOR("Aniket Agashe <aniketa@nvidia.com>");
+MODULE_DESCRIPTION(
+	"VFIO NVGPU PF - User Level driver for NVIDIA devices with CPU coherently accessible device memory");
-- 
2.17.1

