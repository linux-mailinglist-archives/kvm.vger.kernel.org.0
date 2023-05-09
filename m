Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF2A6FBE1B
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 06:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234836AbjEIEJf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 00:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234695AbjEIEJL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 00:09:11 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2055.outbound.protection.outlook.com [40.107.94.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D4EDA5DC;
        Mon,  8 May 2023 21:07:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TwlWhWwrfj3Ww+aCex4IvjfqX5w9u3Gz+p9doJD0o/lnXiaTQadg+EcN13YxPQSJhkU1RsjTshN9O0osEiat6QqnpwWH3gPHYWrfFxLyqINVEfQoJt0H2Q5pDMGyr+Y6MGp3nYAu7BFQffKJphPVVtaBOCPKD1mAD/ekYl0R5c9RKw55mrCBEUtBOuNX9Tt1Qj/587ZkNIHjCRpce4995t/BvAJhT6gR5PP3XmWz2NDqHmBmgIBYjgc7XoEV0S5qln32sr2klYoW6YOH5PaSu/9coXwYZiC2ONdkNqZdFSPtFpXA6Kn5bm0PanTDZ4LxaALCJSJ/p98JgVK1XUbUXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BfV5kC42qM+dHWxj3NihvO9228ai82/TFd4KGyHKAQ8=;
 b=mewBJVCTr2nsd5zHIaQ6khOA4tEQJGEVvSKZRwCCHR9h+xm92BSabiiK+M81c/ni0RaX6Ti2tc8gaLmOiyjPkJeUTnjQ6AGBRs+JFUcD7JCPAy9VpmlwaAioEeW2+dlIEqy8U8ocWHPfqWEsvNHhBym1tEuo3eGGm+jhar6+9nBvyi9DtqqIzb7oAp/DXvVXdgyUPy9Hjqqf9KivDpuKTpYYbIKAVB0JE0n8/Y6r6F0ygttCs8lLOHDF+rtBylabevF8DV5WJbglOel7VFGd8WGy88VGxhSysVx0m4dk7b9Y4zdPKhG9MP0kv2Ak3Ng5IcOAcnElk4qWokJtfkOhmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BfV5kC42qM+dHWxj3NihvO9228ai82/TFd4KGyHKAQ8=;
 b=n0FafFnGEEUZ9561ilkABQ+qL99bEzEgwPSuw5WHE9jlKwsUoerER3B8JjFVJLlrCEuX/Rp7Vlj+b8QqzjB/oBkG32LQJARe32zt7zp6LCDW4UQ8KUms6upt9wZA2rr9mucoJb8cWqyl6sN1dOa7iKlhBgTgKhKlABIf56zZCLgJpZTGOpO21EA7RZBntS7Rr1hlBtU8+l6VKND1PO8ythS2q43Rstw8/H6B4I2/YsbAPyzumH5ukyoYYw9j+gKZNwoUbtAwaJ7AtbNNweZBqGu31R/SwrZehiIL/p/M5yoRrE8MkdxwqczA4ytI54laYONl9XmJY6nvEjOxHlN5ZQ==
Received: from BN9PR03CA0683.namprd03.prod.outlook.com (2603:10b6:408:10e::28)
 by CH0PR12MB8488.namprd12.prod.outlook.com (2603:10b6:610:18d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Tue, 9 May
 2023 04:07:46 +0000
Received: from BL02EPF000145B9.namprd05.prod.outlook.com
 (2603:10b6:408:10e:cafe::e4) by BN9PR03CA0683.outlook.office365.com
 (2603:10b6:408:10e::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33 via Frontend
 Transport; Tue, 9 May 2023 04:07:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL02EPF000145B9.mail.protection.outlook.com (10.167.241.209) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.18 via Frontend Transport; Tue, 9 May 2023 04:07:46 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 8 May 2023
 21:07:35 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Mon, 8 May 2023 21:07:34 -0700
Received: from localhost.localdomain (10.127.8.14) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37 via Frontend
 Transport; Mon, 8 May 2023 21:07:34 -0700
From:   <ankita@nvidia.com>
To:     <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>
CC:     <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
        <targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
        <apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/1] vfio/nvgpu: Add vfio pci variant module for grace hopper
Date:   Mon, 8 May 2023 21:07:34 -0700
Message-ID: <20230509040734.24392-1-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000145B9:EE_|CH0PR12MB8488:EE_
X-MS-Office365-Filtering-Correlation-Id: 27d2f517-2163-4f26-4267-08db5042f212
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CDv/8er2f5vLBExhCQmEZyZK+j0GvI8+qZNCxRJontXCL7NEmn+19+8mQSxbb1wEmv5pfbXGUSlccDk+uhIn2Z2Kwx17S2yTPDSNe+FNsql6Lgpddtz7rwq4ct1wLHditfKJ+wd1znsDWScQ1b1ZIJvKxZobk2zPybNYeOiVhY+jPw9EFX9Lkg0RmzfiLjHTrgKKRu6XicTOuPvuuJjo0ylnyRk8wa/LU9JSgYg4CqMxBkVtAIPbNn5Q59p4/ku3J4UOhuU+CvbJQOrA0eUFbSkB9yQaTu+iXSjY10X5pDN4jFXlmcvsRw+MI/EDiivsLD8aDfDlC12zeOp5/CPFeYmp7GU6abwftBinTESGGVe03hNlhBKzlonbuSEr/Q5RiJ2L9PZJ7Eudis1/hPQlfRtVaNQRrgDfXBPyjLim4cL8P/nC/fEHjFtZaz9D94kattqLSAWISKlHkOn362GMfGJGf4xHXi/YEdEzc0kU3CKkgUp9zMs5SVDYEIy0rrxd/ZGs19isePHwzXxSVNJAhUwQWg+a/OpYCFfZmHi1grbSXelw0/0aAbrZSc6ovGLlY2y4f1jZr+vyrSg92wSGfiqNBLYRi+9PT97oHr7MDeyBLJKaicXk/ezC4h2aBlboKEFrhsA9BAS0BB4iCEzKlE6DbUg664W01ULfWGCCOAlrV8SL8Lvi4cU8VDDojPV7S1pef70uQrIa66KL9Ed0rVzQqYFszr8uDgDCVXBncDv1jasH1kuQx3nsTSzR3ook2jlchz7Vt5YmbJ0sV1V9Mi4OZpoal20J3OvRAV8W3A0=
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(136003)(376002)(39860400002)(451199021)(46966006)(36840700001)(40470700004)(36860700001)(336012)(83380400001)(316002)(70586007)(4326008)(426003)(478600001)(70206006)(47076005)(186003)(2616005)(966005)(1076003)(26005)(54906003)(110136005)(30864003)(2906002)(2876002)(86362001)(40480700001)(36756003)(40460700003)(82740400003)(82310400005)(41300700001)(7636003)(356005)(5660300002)(8676002)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2023 04:07:46.0528
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 27d2f517-2163-4f26-4267-08db5042f212
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000145B9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8488
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
https://lore.kernel.org/lkml/20230405180134.16932-1-ankita@nvidia.com/

Applied and tested over v6.3-rc7.

v1 -> v2
- Updated the wording of reference to BAR offset and replaced with
  index.
- The GPU memory is exposed at the fixed BAR2_REGION_INDEX.
- Code cleanup based on feedback comments.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 MAINTAINERS                     |   6 +
 drivers/vfio/pci/Kconfig        |   2 +
 drivers/vfio/pci/Makefile       |   2 +
 drivers/vfio/pci/nvgpu/Kconfig  |  10 ++
 drivers/vfio/pci/nvgpu/Makefile |   3 +
 drivers/vfio/pci/nvgpu/main.c   | 217 ++++++++++++++++++++++++++++++++
 6 files changed, 240 insertions(+)
 create mode 100644 drivers/vfio/pci/nvgpu/Kconfig
 create mode 100644 drivers/vfio/pci/nvgpu/Makefile
 create mode 100644 drivers/vfio/pci/nvgpu/main.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 0e64787aace8..6b55861bbfbe 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -21949,6 +21949,12 @@ L:	kvm@vger.kernel.org
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
index 000000000000..bb09dada9907
--- /dev/null
+++ b/drivers/vfio/pci/nvgpu/main.c
@@ -0,0 +1,217 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved
+ */
+
+#include <linux/pci.h>
+#include <linux/vfio_pci_core.h>
+
+struct dev_mem_properties {
+	uint64_t hpa;
+	uint64_t mem_length;
+};
+
+struct nvgpu_vfio_pci_core_device {
+	struct vfio_pci_core_device core_device;
+	struct dev_mem_properties mem_prop;
+};
+
+static int nvgpu_vfio_pci_open_device(struct vfio_device *core_vdev)
+{
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
+	if (index != VFIO_PCI_BAR2_REGION_INDEX)
+		return vfio_pci_core_mmap(core_vdev, vma);
+
+	/*
+	 * Request to mmap the BAR. Map to the CPU accessible memory on the
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
+	 * Perform a PFN map to the memory. The device BAR is backed by the
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
+	if (cmd == VFIO_DEVICE_GET_REGION_INFO) {
+		if (copy_from_user(&info, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (info.argsz < minsz)
+			return -EINVAL;
+
+		if (info.index == VFIO_PCI_BAR2_REGION_INDEX) {
+			/*
+			 * Request to determine the BAR region information. Send the
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
+	}
+
+	return vfio_pci_core_ioctl(core_vdev, cmd, arg);
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
+	int ret;
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

