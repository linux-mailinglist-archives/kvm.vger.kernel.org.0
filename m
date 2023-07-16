Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBF9C755023
	for <lists+kvm@lfdr.de>; Sun, 16 Jul 2023 19:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbjGPRny (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Jul 2023 13:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjGPRnx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Jul 2023 13:43:53 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2077.outbound.protection.outlook.com [40.107.92.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A02FCEB;
        Sun, 16 Jul 2023 10:43:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m7sdvZHa1v1YTskydbxvXSGEUidzMHfWgfO7a0MNcuEYb6XC73pZl2XkUx3+9V1Fv87kIn9CiEhCALc8XNRBBPfxL9FIPUJ/JJWOoTQI73MhbLC8jJGT4PhHpDoNIpDOu4CNubIAs+hSNOioB6hZPlGpozRzZkiBO7IdvoBeA3XtybUTKXR6KLK2YHgEN8BK1Jq6QFgD+5hCABAZALX7ab30qiWQkXvywLq3Su6l5s5lC+qOvpPPO2xdQER9pmWb3dV7BVafsTYWtjOktqoEIN3JXSk6ytVVUTrExrZJlyKeGY24B2FqjEC6moRqfflBgL6pZVyF9xWSjkx/O/zR/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZbuafruCEzZKQlpldWaPWv09BeKfDkOMCq8JSIt4f2A=;
 b=ZdO9hYE1ouinBZcbRk04vgvj+TNy9KuJrHywfvYRTqR/2lBc71NKahMgTnU/yLNDFr3EyOAPGzKEvPYHldfyvvxWhuUZzU88iP+58Y3ekTv8u3g+C7YjRcC5eBrK6EVUHKJXupScBwrVPV6C/Y4XrMpedoTDKG8xtqKaEACsTInavUIS1gVCZjIM8wz5ldqhYNzfz5yIvb3PmIGeXNQ4ALLCT9Ho6UpaXzsKyg321DtQV0j4IE0gRbTaRilFDUVPDRoa+BHqERfvs2zdwXs6tyh8UMnqtHhb2+IOKE6z75NGuRoiQDpYNRb7TVbh2ZFLQ2S3uqtoD5/N2qv6dpiFFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZbuafruCEzZKQlpldWaPWv09BeKfDkOMCq8JSIt4f2A=;
 b=HXtWRLK1eERZt9xdvWKRKlDnOpFVGwRq4MzLfKA3wIoXlYLfDCWGmoxXCEd8kkOpo3R45qz89BdNoKt2eLuN7l9mA7vb4tBscF7a4S23vBkTsClvRlfTfzT1pP5iSQ4whXhNM9JrHupjhSR0UKMuWEs1ZmiCaTmpl9DojTt8aprkkXI54znHzNk2oiqK0YSMXLg8qkMY0Jenw7//i4495l1+56YP8x6LGBa6+2jUUbdPk0ILz9sxPl5cwH+C1ybElDRChQeOJ8XjxOppmwCnF+vHmzMAqIrY07AWP1G2WLoNILbjQBYfEtHQgNUbAKlyoexC2V2tdztrnr3E/nXCDw==
Received: from BN9PR03CA0227.namprd03.prod.outlook.com (2603:10b6:408:f8::22)
 by CH3PR12MB9026.namprd12.prod.outlook.com (2603:10b6:610:125::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.31; Sun, 16 Jul
 2023 17:43:47 +0000
Received: from BN8NAM11FT007.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f8:cafe::a8) by BN9PR03CA0227.outlook.office365.com
 (2603:10b6:408:f8::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.32 via Frontend
 Transport; Sun, 16 Jul 2023 17:43:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN8NAM11FT007.mail.protection.outlook.com (10.13.177.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6588.32 via Frontend Transport; Sun, 16 Jul 2023 17:43:46 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Sun, 16 Jul 2023
 10:43:33 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Sun, 16 Jul 2023 10:43:33 -0700
Received: from localhost.localdomain (10.127.8.14) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37 via Frontend
 Transport; Sun, 16 Jul 2023 10:43:33 -0700
From:   <ankita@nvidia.com>
To:     <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>
CC:     <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
        <targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
        <apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 1/1] vfio/nvgpu: Add vfio pci variant module for grace hopper
Date:   Sun, 16 Jul 2023 10:43:33 -0700
Message-ID: <20230716174333.8221-1-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT007:EE_|CH3PR12MB9026:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a921bad-e98d-4c69-23eb-08db86243524
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iA0Xedm2jSq/cd1/fBthwyazJFmNp9MNbAeSfokLFmqWIT29JxSzbR8VP+sNaoZirPTXVEPK0cNxafJL9kSBfppwCZcY7IDBq92XciaS55c1n/76Q1vroNF3DxUhLLBM996dmVUD/fPvC8YGumlvTCAQ330UrCl/aoK/Wwrkh9/upxS15zLVJfgA0mnj5vzxkQN8a7Ol7O9FrZtyPD19599SwrKzL6wJ6FxLA/fn0zGTDYT5ERm5vCvpp4l4bmW8Slfo+slInz74A+mapbbZ9QxgCbn8q5fynxQmXuCZTb4Fa0MolEn8Wx8KCrPXTsc79idOXQbA8viIOXg0IsVjzBmXBJJPWy5PSWbkTfMHOuJvEhtMTq1T4DugGV6koIilJgYqJxohb94nf9SbzKaobJmA51nOXIhD9bzpd/u/YAsqCHbm4xqrf5Zu3UwGbFq+FArM//ilIQRfw4ERRSoXuY8vcG2yqkZobhLjYZT0e9QwOg/aAb9cYLK09XGGpydkBCxMBPvTOwS5f+GWa2MHrGwv8s5SCB60HjRPAs5dITg8EBOmDS5D4+7PaGy+WbdgTVC8lpCjm/KjJUIWeMoaFP2G1/oc6P4LCY7objonMZZwDXhHOY8/ppk6fznPAhmmd4k7gcjbj58D1eGvfwkcAPFN69SKiUJabbhBaIIyPDFVW/2L2srGngua3RrU108b42eVhnIpkK9OXypkk7EXJ05c4HQ/3L+lzaagR2+j9a1J8rHdHWq+Ek76U2epqCTFtSwa+JPQah4rhfW44v3uuQ==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(136003)(376002)(39860400002)(451199021)(82310400008)(40470700004)(36840700001)(46966006)(40480700001)(40460700003)(54906003)(110136005)(82740400003)(356005)(7636003)(478600001)(41300700001)(8676002)(5660300002)(8936002)(316002)(70206006)(70586007)(4326008)(2616005)(426003)(336012)(36860700001)(186003)(83380400001)(47076005)(966005)(1076003)(26005)(86362001)(36756003)(2876002)(30864003)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2023 17:43:46.9687
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a921bad-e98d-4c69-23eb-08db86243524
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT007.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9026
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ankit Agrawal <ankita@nvidia.com>

NVIDIA's upcoming Grace Hopper Superchip provides a PCI-like device
for the on-chip GPU that is the logical OS representation of the
internal proprietary cache coherent interconnect.

This representation has a number of limitations compared to a real PCI
device, in particular, it does not model the coherent GPU memory
aperture as a PCI config space BAR, and PCI doesn't know anything
about cacheable memory types.

Provide a VFIO PCI variant driver that adapts the unique PCI
representation into a more standard PCI representation facing
userspace. The GPU memory aperture is obtained from ACPI using
device_property_read_u64(), according to the FW specification,
and exported to userspace as a separate VFIO_REGION. Since the device
implements only one 64-bit BAR (BAR0), the GPU memory aperture is mapped
to the next available PCI BAR (BAR2). Qemu will then naturally generate a
PCI device in the VM with two 64-bit BARs (where the cacheable aperture
reported in BAR2).

Since this memory region is actually cache coherent with the CPU, the
VFIO variant driver will mmap it into VMA using a cacheable mapping. The
mapping is done using remap_pfn_range().

PCI BAR are aligned to the power-of-2, but the actual memory on the
device may not. The physical address from the last device PFN up to the
next power-of-2 aligned PA thus is handled by the vfio-pci read/write
device ops which returns an error.

This goes along with a qemu series to provides the necessary
implementation of the Grace Hopper Superchip firmware specification so
that the guest operating system can see the correct ACPI modeling for
the coherent GPU device.
https://www.mail-archive.com/qemu-devel@nongnu.org/msg967557.html

This patch is split from a patch series being pursued separately:
https://lore.kernel.org/lkml/20230405180134.16932-1-ankita@nvidia.com/

Applied over next-20230713.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
Link for v4: https://lore.kernel.org/lkml/20230622030720.19652-1-ankita@nvidia.com/T/

v4 -> v5
- Changed the module name from nvgpu-vfio-pci to nvgrace-gpu-vfio-pci.
- Fixed memory leak and added suggested boundary checks on device memory
  mapping.
- Added code to read all Fs and ignored write on region outside of the
  physical memory.
- Other miscellaneous cleanup suggestions.

v3 -> v4
- Mapping the available device memory using sparse mmap. The region outside
  the device memory is handled by read/write ops.
- Removed the fault handler added in v3.

v2 -> v3
- Added fault handler to map the region outside the physical GPU memory
  up to the next power-of-2 to a dummy PFN.
- Changed to select instead of "depends on" VFIO_PCI_CORE for all the
  vfio-pci variant driver.
- Code cleanup based on feedback comments.
- Code implemented and tested against v6.4-rc4.

v1 -> v2
- Updated the wording of reference to BAR offset and replaced with
  index.
- The GPU memory is exposed at the fixed BAR2_REGION_INDEX.
- Code cleanup based on feedback comments.

 MAINTAINERS                           |   6 +
 drivers/vfio/pci/Kconfig              |   2 +
 drivers/vfio/pci/Makefile             |   2 +
 drivers/vfio/pci/nvgrace-gpu/Kconfig  |  10 +
 drivers/vfio/pci/nvgrace-gpu/Makefile |   3 +
 drivers/vfio/pci/nvgrace-gpu/main.c   | 324 ++++++++++++++++++++++++++
 6 files changed, 347 insertions(+)
 create mode 100644 drivers/vfio/pci/nvgrace-gpu/Kconfig
 create mode 100644 drivers/vfio/pci/nvgrace-gpu/Makefile
 create mode 100644 drivers/vfio/pci/nvgrace-gpu/main.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 139106909db6..aed90d8dec87 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22373,6 +22373,12 @@ L:	kvm@vger.kernel.org
 S:	Maintained
 F:	drivers/vfio/platform/
 
+VFIO NVGRACE GPU PCI DRIVER
+M:	Ankit Agrawal <ankita@nvidia.com>
+L:	kvm@vger.kernel.org
+S:	Maintained
+F:	drivers/vfio/pci/nvgrace-gpu/
+
 VGA_SWITCHEROO
 R:	Lukas Wunner <lukas@wunner.de>
 S:	Maintained
diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 86bb7835cf3c..0dbdacb929ad 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -63,4 +63,6 @@ source "drivers/vfio/pci/mlx5/Kconfig"
 
 source "drivers/vfio/pci/hisilicon/Kconfig"
 
+source "drivers/vfio/pci/nvgrace-gpu/Kconfig"
+
 endmenu
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index 24c524224da5..733f684f320a 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -11,3 +11,5 @@ obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
 obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
 
 obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisilicon/
+
+obj-$(CONFIG_NVGRACE_GPU_VFIO_PCI) += nvgrace-gpu/
diff --git a/drivers/vfio/pci/nvgrace-gpu/Kconfig b/drivers/vfio/pci/nvgrace-gpu/Kconfig
new file mode 100644
index 000000000000..b46f2d97a1d6
--- /dev/null
+++ b/drivers/vfio/pci/nvgrace-gpu/Kconfig
@@ -0,0 +1,10 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config NVGRACE_GPU_VFIO_PCI
+	tristate "VFIO support for the GPU in the NVIDIA Grace Hopper Superchip"
+	depends on ARM64 || (COMPILE_TEST && 64BIT)
+	select VFIO_PCI_CORE
+	help
+	  VFIO support for the GPU in the NVIDIA Grace Hopper Superchip is
+	  required to assign the GPU device to a VM using KVM/qemu/etc.
+
+	  If you don't know what to do here, say N.
diff --git a/drivers/vfio/pci/nvgrace-gpu/Makefile b/drivers/vfio/pci/nvgrace-gpu/Makefile
new file mode 100644
index 000000000000..3ca8c187897a
--- /dev/null
+++ b/drivers/vfio/pci/nvgrace-gpu/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_NVGRACE_GPU_VFIO_PCI) += nvgrace-gpu-vfio-pci.o
+nvgrace-gpu-vfio-pci-y := main.o
diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
new file mode 100644
index 000000000000..4928e5b03b98
--- /dev/null
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -0,0 +1,324 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved
+ */
+
+#include <linux/pci.h>
+#include <linux/vfio_pci_core.h>
+#include <linux/vfio.h>
+
+struct nvgrace_gpu_vfio_pci_core_device {
+	struct vfio_pci_core_device core_device;
+	u64 hpa;
+	u64 mem_length;
+};
+
+static int nvgrace_gpu_vfio_pci_open_device(struct vfio_device *core_vdev)
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
+	return 0;
+}
+
+static int nvgrace_gpu_vfio_pci_mmap(struct vfio_device *core_vdev,
+			struct vm_area_struct *vma)
+{
+	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
+		core_vdev, struct nvgrace_gpu_vfio_pci_core_device, core_device.vdev);
+
+	unsigned long start_pfn;
+	unsigned int index;
+	u64 req_len, pgoff;
+	int ret;
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
+	start_pfn = PHYS_PFN(nvdev->hpa);
+	req_len = vma->vm_end - vma->vm_start;
+	pgoff = vma->vm_pgoff &
+		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
+	if (PFN_PHYS(pgoff) + req_len > nvdev->mem_length)
+		return -EINVAL;
+
+	/*
+	 * Perform a PFN map to the memory. The device BAR is backed by the
+	 * GPU memory now. Check that the mapping does not overflow out of
+	 * the GPU memory size.
+	 *
+	 * The available GPU memory size may not be power-of-2 aligned. Given
+	 * that the memory is exposed as a BAR, the mapping request is of the
+	 * power-of-2 aligned size. Map only up to the size of the GPU memory.
+	 * If the memory access is beyond the actual GPU memory size, it will
+	 * be handled by the vfio_device_ops read/write.
+	 *
+	 * During device reset, the GPU is safely disconnected to the CPU
+	 * and access to the BAR will be immediately returned preventing
+	 * machine check.
+	 */
+	ret = remap_pfn_range(vma, vma->vm_start, start_pfn + pgoff,
+			      req_len, vma->vm_page_prot);
+	if (ret)
+		return ret;
+
+	vma->vm_pgoff = start_pfn + pgoff;
+
+	return 0;
+}
+
+static long nvgrace_gpu_vfio_pci_ioctl(struct vfio_device *core_vdev,
+			unsigned int cmd, unsigned long arg)
+{
+	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
+		core_vdev, struct nvgrace_gpu_vfio_pci_core_device, core_device.vdev);
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
+			uint32_t size;
+			struct vfio_region_info_cap_sparse_mmap *sparse;
+			struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
+
+			size = struct_size(sparse, areas, 1);
+
+			/*
+			 * Setup for sparse mapping for the device memory. Only the
+			 * available device memory on the hardware is shown as a
+			 * mappable region.
+			 */
+			sparse = kzalloc(size, GFP_KERNEL);
+			if (!sparse)
+				return -ENOMEM;
+
+			sparse->nr_areas = 1;
+			sparse->areas[0].offset = 0;
+			sparse->areas[0].size = nvdev->mem_length;
+			sparse->header.id = VFIO_REGION_INFO_CAP_SPARSE_MMAP;
+			sparse->header.version = 1;
+
+			if (vfio_info_add_capability(&caps, &sparse->header, size)) {
+				kfree(sparse);
+				return -EINVAL;
+			}
+
+			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+			/*
+			 * The available GPU memory size may not be power-of-2 aligned.
+			 * Given that the memory is exposed as a BAR and may not be
+			 * aligned, roundup to the next power-of-2.
+			 */
+			info.size = roundup_pow_of_two(nvdev->mem_length);
+			info.flags = VFIO_REGION_INFO_FLAG_READ |
+				VFIO_REGION_INFO_FLAG_WRITE |
+				VFIO_REGION_INFO_FLAG_MMAP;
+
+			if (caps.size) {
+				info.flags |= VFIO_REGION_INFO_FLAG_CAPS;
+				if (info.argsz < sizeof(info) + caps.size) {
+					info.argsz = sizeof(info) + caps.size;
+					info.cap_offset = 0;
+				} else {
+					vfio_info_cap_shift(&caps, sizeof(info));
+					if (copy_to_user((void __user *)arg +
+									sizeof(info), caps.buf,
+									caps.size)) {
+						kfree(caps.buf);
+						kfree(sparse);
+						return -EFAULT;
+					}
+					info.cap_offset = sizeof(info);
+				}
+				kfree(caps.buf);
+			}
+
+			kfree(sparse);
+			return copy_to_user((void __user *)arg, &info, minsz) ?
+				       -EFAULT : 0;
+		}
+	}
+
+	return vfio_pci_core_ioctl(core_vdev, cmd, arg);
+}
+
+static ssize_t nvgrace_gpu_vfio_pci_read(struct vfio_device *core_vdev,
+		char __user *buf, size_t count, loff_t *ppos)
+{
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
+		core_vdev, struct nvgrace_gpu_vfio_pci_core_device, core_device.vdev);
+	u64 offset = *ppos & VFIO_PCI_OFFSET_MASK;
+	u8 val = 0xFF;
+	size_t i;
+
+	/*
+	 * Only the device memory present on the hardware is mapped, which may
+	 * not be power-of-2 aligned. A read to the BAR2 region implies an
+	 * access outside the available device memory on the hardware.
+	 */
+	if ((index == VFIO_PCI_BAR2_REGION_INDEX) &&
+		(offset >= nvdev->mem_length)) {
+		for (i = 0; i < count; i++)
+			if (copy_to_user(buf + i, &val, 1))
+				return -EFAULT;
+		return count;
+	}
+
+	return vfio_pci_core_read(core_vdev, buf, count, ppos);
+
+}
+
+static ssize_t nvgrace_gpu_vfio_pci_write(struct vfio_device *core_vdev,
+		const char __user *buf, size_t count, loff_t *ppos)
+{
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
+		core_vdev, struct nvgrace_gpu_vfio_pci_core_device, core_device.vdev);
+	u64 offset = *ppos & VFIO_PCI_OFFSET_MASK;
+
+	/*
+	 * Only the device memory present on the hardware is mapped, which may
+	 * not be power-of-2 aligned. A write to the BAR2 region implies an
+	 * access outside the available device memory on the hardware.
+	 */
+	if ((index == VFIO_PCI_BAR2_REGION_INDEX) &&
+		(offset >= nvdev->mem_length))
+		return count;
+
+	return vfio_pci_core_write(core_vdev, buf, count, ppos);
+}
+
+static const struct vfio_device_ops nvgrace_gpu_vfio_pci_ops = {
+	.name = "nvgrace-gpu-vfio-pci",
+	.init = vfio_pci_core_init_dev,
+	.release = vfio_pci_core_release_dev,
+	.open_device = nvgrace_gpu_vfio_pci_open_device,
+	.close_device = vfio_pci_core_close_device,
+	.ioctl = nvgrace_gpu_vfio_pci_ioctl,
+	.read = nvgrace_gpu_vfio_pci_read,
+	.write = nvgrace_gpu_vfio_pci_write,
+	.mmap = nvgrace_gpu_vfio_pci_mmap,
+	.request = vfio_pci_core_request,
+	.match = vfio_pci_core_match,
+	.bind_iommufd = vfio_iommufd_physical_bind,
+	.unbind_iommufd = vfio_iommufd_physical_unbind,
+	.attach_ioas = vfio_iommufd_physical_attach_ioas,
+};
+
+static struct
+nvgrace_gpu_vfio_pci_core_device *nvgrace_gpu_drvdata(struct pci_dev *pdev)
+{
+	struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
+
+	return container_of(core_device, struct nvgrace_gpu_vfio_pci_core_device,
+			    core_device);
+}
+
+static int
+nvgrace_gpu_vfio_pci_fetch_memory_property(struct pci_dev *pdev,
+				     struct nvgrace_gpu_vfio_pci_core_device *nvdev)
+{
+	int ret;
+
+	/*
+	 * The memory information is present in the system ACPI tables as DSD
+	 * properties nvidia,gpu-mem-base-pa and nvidia,gpu-mem-size.
+	 */
+	ret = device_property_read_u64(&pdev->dev, "nvidia,gpu-mem-base-pa",
+				       &(nvdev->hpa));
+	if (ret)
+		return ret;
+
+	ret = device_property_read_u64(&pdev->dev, "nvidia,gpu-mem-size",
+				       &(nvdev->mem_length));
+	return ret;
+}
+
+static int nvgrace_gpu_vfio_pci_probe(struct pci_dev *pdev,
+				const struct pci_device_id *id)
+{
+	struct nvgrace_gpu_vfio_pci_core_device *nvdev;
+	int ret;
+
+	nvdev = vfio_alloc_device(nvgrace_gpu_vfio_pci_core_device, core_device.vdev,
+				  &pdev->dev, &nvgrace_gpu_vfio_pci_ops);
+	if (IS_ERR(nvdev))
+		return PTR_ERR(nvdev);
+
+	dev_set_drvdata(&pdev->dev, nvdev);
+
+	ret = nvgrace_gpu_vfio_pci_fetch_memory_property(pdev, nvdev);
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
+static void nvgrace_gpu_vfio_pci_remove(struct pci_dev *pdev)
+{
+	struct nvgrace_gpu_vfio_pci_core_device *nvdev = nvgrace_gpu_drvdata(pdev);
+	struct vfio_pci_core_device *vdev = &nvdev->core_device;
+
+	vfio_pci_core_unregister_device(vdev);
+	vfio_put_device(&vdev->vdev);
+}
+
+static const struct pci_device_id nvgrace_gpu_vfio_pci_table[] = {
+	/* GH200 120GB */
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2342) },
+	/* GH200 480GB */
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2345) },
+	{}
+};
+
+MODULE_DEVICE_TABLE(pci, nvgrace_gpu_vfio_pci_table);
+
+static struct pci_driver nvgrace_gpu_vfio_pci_driver = {
+	.name = KBUILD_MODNAME,
+	.id_table = nvgrace_gpu_vfio_pci_table,
+	.probe = nvgrace_gpu_vfio_pci_probe,
+	.remove = nvgrace_gpu_vfio_pci_remove,
+	.err_handler = &vfio_pci_core_err_handlers,
+	.driver_managed_dma = true,
+};
+
+module_pci_driver(nvgrace_gpu_vfio_pci_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Ankit Agrawal <ankita@nvidia.com>");
+MODULE_AUTHOR("Aniket Agashe <aniketa@nvidia.com>");
+MODULE_DESCRIPTION(
+	"VFIO NVGRACE GPU PF - User Level driver for NVIDIA devices with CPU coherently accessible device memory");
-- 
2.17.1

