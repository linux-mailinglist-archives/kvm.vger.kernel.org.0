Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9505079D4D1
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 17:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236256AbjILPa6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 11:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233254AbjILPa4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 11:30:56 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2054.outbound.protection.outlook.com [40.107.223.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02FE410DE;
        Tue, 12 Sep 2023 08:30:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dcmb8l0aqU+daqURmnw+fnr6UoK9MB/3yQQIAwBjepLr5gYIPtM378/3Jh8MLjHufloGtADL8vk4k4tEKjz4AGYxIaawjEssiM4oxveC6oShOEorTWEC0RqvHCm6vO2XARmghG6CS2mX+3AYQn5r1hTmiW9h6qN046VDzYGz3PAuC/ipGi049YPqpbTx2jZxFue0W7aSf4IwPqjYPzB9DvBzTYrCCJ6h/njdwby8gUue52kxOpeG+t6KrVOuzGbLMKt8Le8ofcNvDRIgBzQ33zX6m5Sx39QVpgxg6EwU5i1x1OYssw7jOgBID8ljCvYkp23i80+n6LM4wvOj1GGdQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gGyv7S2vtFy4VuoVqCtnRs8ygsRf7HIvQE0ulQnXv/I=;
 b=hw/Q3g6L2fMDfHrDrW67mY04/ESVrkAHmOuYJz6NinFYCFFjclDcCOnvEHMLGrQ335t5/t8u63l7t+pJY+stnekbBV/USwPfctE7W8Da4ghMev7tnbWZ4vdXv5aUdCaTtNcuBDfDziR3ztqfGDDVRGkLONzHTGFioL4HtIT9fIMPVAXlH6yyYR+Px6B8/fGqiWw8Zf9nDq3q7T4X3/yYfjJftpGLog/mbN4wbE7yuR1ZGUHMtE0Qbd/5gzgSJ21qKmzUyOLVaK9KNgWl6kFgH8gR3EpnAuF0a07Ts+2+ExjUhJcv9avq9zIrIfLXInM9Z/lQldMHxsrWHIVpJG6CvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gGyv7S2vtFy4VuoVqCtnRs8ygsRf7HIvQE0ulQnXv/I=;
 b=VD/ApmJ8d4wUjlWG9AaIwFvlpOyQI9T1i3UoNu9ZbrU5sF3oQIEXMRKQTa5ifRU2ZGg9UY63zed5eoIu9I/5HWXLUJPcUtGJigRrUAIvufUfZsE1w/0KFyqHTGNtJ9DPJg2XPTtxTtV3nSuv7yMWL/1R69LRIbIrEHNVcYlxMhTls8sDiOz57kF6HZug/jgMc4x9gGtlJbawnI6S0Vp+ayODSmbwIcmSkEFebjTl/IDDUg7GOeHEEIGwPf5HNNBMQxxkr768VP6mZltTSGiALnJOqFLr/a8X3LgGdI8Woo7ObIek9lUykxZkekEm+RbwQF8VDztjNzURFIcl3/iwnw==
Received: from DS7PR03CA0144.namprd03.prod.outlook.com (2603:10b6:5:3b4::29)
 by BL1PR12MB5852.namprd12.prod.outlook.com (2603:10b6:208:397::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.30; Tue, 12 Sep
 2023 15:30:49 +0000
Received: from DS3PEPF000099DB.namprd04.prod.outlook.com
 (2603:10b6:5:3b4:cafe::8d) by DS7PR03CA0144.outlook.office365.com
 (2603:10b6:5:3b4::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.19 via Frontend
 Transport; Tue, 12 Sep 2023 15:30:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS3PEPF000099DB.mail.protection.outlook.com (10.167.17.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.17 via Frontend Transport; Tue, 12 Sep 2023 15:30:49 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 12 Sep 2023
 08:30:33 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 12 Sep
 2023 08:30:33 -0700
Received: from ankita-dt2.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37 via Frontend
 Transport; Tue, 12 Sep 2023 08:30:32 -0700
From:   <ankita@nvidia.com>
To:     <ankita@nvidia.com>, <jgg@nvidia.com>,
        <alex.williamson@redhat.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>
CC:     <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
        <targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
        <apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
        <anuaggarwal@nvidia.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v9 1/1] vfio/nvgpu: Add vfio pci variant module for grace hopper
Date:   Tue, 12 Sep 2023 08:30:32 -0700
Message-ID: <20230912153032.19935-1-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099DB:EE_|BL1PR12MB5852:EE_
X-MS-Office365-Filtering-Correlation-Id: 7adb62f1-9872-4dec-4891-08dbb3a53dfc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v4u+7vNuv1OBOffVM0Ay0Jc9h348GchIud5oc3nz2rv9o5Wwev85medSyr0msL1rNwS/fscQo2BWNzUwi4zlO4A+w+MN0cMCEycbfaFI2WRqgjXol311zDpw0jD42Q3RCOV9u37sgG3sSoccLwCLbLCMqgGRgKIqA9QTGGU27pV3bzyLojCY+zOEnV9RhZRwMINilGwUFsVQqvH3pplDusgCrR9ZVwl+oCM+xo30Dho1RGAWufSof6nd5Td7MRI4K834+BKpBGWfw1Lu7VOeewPrvopXltCwiakoS6tKsbdVCZZyZBU3vJ9W41M+xYiUSVtVSsp4Fl3dxnXi9SX7Fkco8O8S2ynnVd5gq+UuIyu1BWr+proZamO1W/U9x7RPRDLtJnjwc1fq0UzH9l56W50Lap63Sytl9ie5Tj3kf9zUItLbe0yxEcCfzjrBwq3w/uJ1UkeYXLcuas5+VY+C1rIMZ/RZ9/xDh7OVvsU2X+Lm+qbc74bVru4FplpJYXgTfusKT7zMx7AW99U4kTcuLWb+sviJyUm81+8+UOGgVz3cqD6oPW/sBy9klWwiIqLiRDxZBPsdYAT6UQI6byrjJOOsTTvcNo8C5P3eSZfeAt45saMnOtPXs8YdGHonXJeCvBa7Di3uTcCpA2uxiPvLZGvN0oc7DI0NlVypIKrGixWG6wvw7nUnzCBsiXlEh4OrqAhHHDT/18SGallOQ2M45FF88WSS9peZvMS1HpVuAkiYarG+5qUDbDltrDGuHJIhqj3bO80ldTnAYMOuKwELRA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(396003)(39860400002)(346002)(376002)(186009)(1800799009)(82310400011)(451199024)(46966006)(36840700001)(40470700004)(7696005)(2876002)(83380400001)(966005)(426003)(2906002)(8936002)(478600001)(110136005)(336012)(41300700001)(2616005)(54906003)(70586007)(8676002)(70206006)(316002)(5660300002)(26005)(1076003)(30864003)(36756003)(40460700003)(82740400003)(40480700001)(36860700001)(47076005)(86362001)(7636003)(4326008)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2023 15:30:49.2414
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7adb62f1-9872-4dec-4891-08dbb3a53dfc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS3PEPF000099DB.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5852
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
device may not. A read or write access to the physical address from the
last device PFN up to the next power-of-2 aligned physical address
results in reading ~0 and dropped writes.

This goes along with a qemu series to provides the necessary
implementation of the Grace Hopper Superchip firmware specification so
that the guest operating system can see the correct ACPI modeling for
the coherent GPU device. Verified with the CUDA workload in the VM.
https://www.mail-archive.com/qemu-devel@nongnu.org/msg967557.html

This patch is split from a patch series being pursued separately:
https://lore.kernel.org/lkml/20230405180134.16932-1-ankita@nvidia.com/

Applied and tested over next-20230911.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
Signed-off-by: Aniket Agashe <aniketa@nvidia.com>
---

Link for v8:
https://lore.kernel.org/all/20230825124138.9088-1-ankita@nvidia.com/

v8 -> v9
- Minor code adjustment suggested in v8.

v7 -> v8
- Various field names updated.
- Added a new function to handle VFIO_DEVICE_GET_REGION_INFO ioctl.
- Locking protection for memremap to bar region and other changes
  recommended in v7.
- Added code to fail if the devmem size advertized is 0 in system DSDT.

v6 -> v7
- Handled out-of-bound and overflow conditions at various places to validate
  input offset and length.
- Added code to return EINVAL for offset beyond region size.

v5 -> v6
- Added the code to handle BAR2 read/write using memremap to the device
  memory.

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
 drivers/vfio/pci/nvgrace-gpu/main.c   | 474 ++++++++++++++++++++++++++
 6 files changed, 497 insertions(+)
 create mode 100644 drivers/vfio/pci/nvgrace-gpu/Kconfig
 create mode 100644 drivers/vfio/pci/nvgrace-gpu/Makefile
 create mode 100644 drivers/vfio/pci/nvgrace-gpu/main.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 2833e2da63e0..0578b8774d2a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22638,6 +22638,12 @@ L:	kvm@vger.kernel.org
 S:	Maintained
 F:	drivers/vfio/platform/
 
+VFIO NVIDIA GRACE GPU DRIVER
+M:	Ankit Agrawal <ankita@nvidia.com>
+L:	kvm@vger.kernel.org
+S:	Maintained
+F:	drivers/vfio/pci/nvgrace-gpu/
+
 VGA_SWITCHEROO
 R:	Lukas Wunner <lukas@wunner.de>
 S:	Maintained
diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 8125e5f37832..2456210e85f1 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -65,4 +65,6 @@ source "drivers/vfio/pci/hisilicon/Kconfig"
 
 source "drivers/vfio/pci/pds/Kconfig"
 
+source "drivers/vfio/pci/nvgrace-gpu/Kconfig"
+
 endmenu
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index 45167be462d8..1352c65e568a 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -13,3 +13,5 @@ obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
 obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisilicon/
 
 obj-$(CONFIG_PDS_VFIO_PCI) += pds/
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
index 000000000000..23fe05045d79
--- /dev/null
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -0,0 +1,474 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. All rights reserved
+ */
+
+#include <linux/pci.h>
+#include <linux/vfio_pci_core.h>
+#include <linux/vfio.h>
+
+struct nvgrace_gpu_vfio_pci_core_device {
+	struct vfio_pci_core_device core_device;
+	phys_addr_t memphys;
+	size_t memlength;
+	void *memmap;
+	struct mutex memmap_lock;
+};
+
+static int nvgrace_gpu_vfio_pci_open_device(struct vfio_device *core_vdev)
+{
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
+		core_vdev, struct nvgrace_gpu_vfio_pci_core_device, core_device.vdev);
+	int ret;
+
+	ret = vfio_pci_core_enable(vdev);
+	if (ret)
+		return ret;
+
+	vfio_pci_core_finish_enable(vdev);
+
+	mutex_init(&nvdev->memmap_lock);
+
+	return 0;
+}
+
+static void nvgrace_gpu_vfio_pci_close_device(struct vfio_device *core_vdev)
+{
+	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
+		core_vdev, struct nvgrace_gpu_vfio_pci_core_device, core_device.vdev);
+
+	if (nvdev->memmap) {
+		memunmap(nvdev->memmap);
+		nvdev->memmap = NULL;
+	}
+
+	mutex_destroy(&nvdev->memmap_lock);
+
+	vfio_pci_core_close_device(core_vdev);
+}
+
+static int nvgrace_gpu_vfio_pci_mmap(struct vfio_device *core_vdev,
+				      struct vm_area_struct *vma)
+{
+	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
+		core_vdev, struct nvgrace_gpu_vfio_pci_core_device, core_device.vdev);
+
+	unsigned long start_pfn;
+	unsigned int index;
+	u64 req_len, pgoff, end;
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
+	pgoff = vma->vm_pgoff &
+		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
+
+	if (check_sub_overflow(vma->vm_end, vma->vm_start, &req_len) ||
+		check_add_overflow(PHYS_PFN(nvdev->memphys), pgoff, &start_pfn) ||
+		check_add_overflow(PFN_PHYS(pgoff), req_len, &end))
+		return -EOVERFLOW;
+
+	/*
+	 * Check that the mapping request does not go beyond available device
+	 * memory size
+	 */
+	if (end > nvdev->memlength)
+		return -EINVAL;
+
+	/*
+	 * Perform a PFN map to the memory and back the device BAR by the
+	 * GPU memory.
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
+	ret = remap_pfn_range(vma, vma->vm_start, start_pfn,
+			      req_len, vma->vm_page_prot);
+	if (ret)
+		return ret;
+
+	vma->vm_pgoff = start_pfn;
+
+	return 0;
+}
+
+static long
+nvgrace_gpu_vfio_pci_ioctl_get_region_info(struct vfio_device *core_vdev,
+					    unsigned long arg)
+{
+	unsigned long minsz = offsetofend(struct vfio_region_info, offset);
+	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
+		core_vdev, struct nvgrace_gpu_vfio_pci_core_device, core_device.vdev);
+	struct vfio_region_info info;
+
+	if (copy_from_user(&info, (void __user *)arg, minsz))
+		return -EFAULT;
+
+	if (info.argsz < minsz)
+		return -EINVAL;
+
+	if (info.index == VFIO_PCI_BAR2_REGION_INDEX) {
+		/*
+		 * Request to determine the BAR region information. Send the
+		 * GPU memory information.
+		 */
+		uint32_t size;
+		int ret;
+		struct vfio_region_info_cap_sparse_mmap *sparse;
+		struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
+
+		size = struct_size(sparse, areas, 1);
+
+		/*
+		 * Setup for sparse mapping for the device memory. Only the
+		 * available device memory on the hardware is shown as a
+		 * mappable region.
+		 */
+		sparse = kzalloc(size, GFP_KERNEL);
+		if (!sparse)
+			return -ENOMEM;
+
+		sparse->nr_areas = 1;
+		sparse->areas[0].offset = 0;
+		sparse->areas[0].size = nvdev->memlength;
+		sparse->header.id = VFIO_REGION_INFO_CAP_SPARSE_MMAP;
+		sparse->header.version = 1;
+
+		ret = vfio_info_add_capability(&caps, &sparse->header, size);
+		kfree(sparse);
+		if (ret)
+			return ret;
+
+		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+		/*
+		 * The available GPU memory size may not be power-of-2 aligned.
+		 * Given that the memory is exposed as a BAR and may not be
+		 * aligned, roundup to the next power-of-2.
+		 */
+		info.size = roundup_pow_of_two(nvdev->memlength);
+		info.flags = VFIO_REGION_INFO_FLAG_READ |
+			VFIO_REGION_INFO_FLAG_WRITE |
+			VFIO_REGION_INFO_FLAG_MMAP;
+
+		if (caps.size) {
+			info.flags |= VFIO_REGION_INFO_FLAG_CAPS;
+			if (info.argsz < sizeof(info) + caps.size) {
+				info.argsz = sizeof(info) + caps.size;
+				info.cap_offset = 0;
+			} else {
+				vfio_info_cap_shift(&caps, sizeof(info));
+				if (copy_to_user((void __user *)arg +
+								sizeof(info), caps.buf,
+								caps.size)) {
+					kfree(caps.buf);
+					return -EFAULT;
+				}
+				info.cap_offset = sizeof(info);
+			}
+			kfree(caps.buf);
+		}
+		return copy_to_user((void __user *)arg, &info, minsz) ?
+			       -EFAULT : 0;
+	}
+	return vfio_pci_core_ioctl(core_vdev, VFIO_DEVICE_GET_REGION_INFO, arg);
+}
+
+static long nvgrace_gpu_vfio_pci_ioctl(struct vfio_device *core_vdev,
+					unsigned int cmd, unsigned long arg)
+{
+	if (cmd == VFIO_DEVICE_GET_REGION_INFO)
+		return nvgrace_gpu_vfio_pci_ioctl_get_region_info(core_vdev, arg);
+
+	return vfio_pci_core_ioctl(core_vdev, cmd, arg);
+}
+
+/*
+ * Read count bytes from the device memory at an offset. The actual device
+ * memory size (available) may not be a power-of-2. So the driver fakes
+ * the size to a power-of-2 (reported) when exposing to a user space driver.
+ *
+ * Read request beyond the actual device size is filled with ~0, while
+ * those beyond the actual reported size is skipped.
+ *
+ * A read from a negative or a reported+ offset, a negative count are
+ * considered error conditions and returned with an -EINVAL.
+ */
+ssize_t nvgrace_gpu_read_mem(void __user *buf, size_t count, loff_t *ppos,
+			      struct nvgrace_gpu_vfio_pci_core_device *nvdev)
+{
+	u64 offset = *ppos & VFIO_PCI_OFFSET_MASK;
+	size_t mem_count, i, bar_size = roundup_pow_of_two(nvdev->memlength);
+	u8 val = 0xFF;
+
+	if (offset >= bar_size)
+		return -EINVAL;
+
+	/* Clip short the read request beyond reported BAR size */
+	count = min(count, bar_size - (size_t)offset);
+
+	/*
+	 * Determine how many bytes to be actually read from the device memory.
+	 * Do not read from the offset beyond available size.
+	 */
+	if (offset >= nvdev->memlength)
+		return 0;
+
+	mem_count = min(count, nvdev->memlength - (size_t)offset);
+
+	/*
+	 * Handle read on the BAR2 region. Map to the target device memory
+	 * physical address and copy to the request read buffer.
+	 */
+	if (copy_to_user(buf, (u8 *)nvdev->memmap + offset, mem_count))
+		return -EFAULT;
+
+	/*
+	 * Only the device memory present on the hardware is mapped, which may
+	 * not be power-of-2 aligned. A read to the BAR2 region implies an
+	 * access outside the available device memory on the hardware. Fill
+	 * such read request with ~0.
+	 */
+	for (i = mem_count; i < count; i++)
+		put_user(val, (unsigned char __user *)(buf + i));
+
+	return count;
+}
+
+static ssize_t nvgrace_gpu_vfio_pci_read(struct vfio_device *core_vdev,
+					  char __user *buf, size_t count, loff_t *ppos)
+{
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
+		core_vdev, struct nvgrace_gpu_vfio_pci_core_device, core_device.vdev);
+
+	if (index == VFIO_PCI_BAR2_REGION_INDEX) {
+		mutex_lock(&nvdev->memmap_lock);
+		if (!nvdev->memmap) {
+			nvdev->memmap = memremap(nvdev->memphys, nvdev->memlength, MEMREMAP_WB);
+			if (!nvdev->memmap) {
+				mutex_unlock(&nvdev->memmap_lock);
+				return -ENOMEM;
+			}
+		}
+		mutex_unlock(&nvdev->memmap_lock);
+
+		return nvgrace_gpu_read_mem(buf, count, ppos, nvdev);
+	}
+
+	return vfio_pci_core_read(core_vdev, buf, count, ppos);
+}
+
+/*
+ * Write count bytes to the device memory at a given offset. The actual device
+ * memory size (available) may not be a power-of-2. So the driver fakes the
+ * size to a power-of-2 (reported) when exposing to a user space driver.
+ *
+ * Write request beyond the actual device size are dropped, while those
+ * beyond the actual reported size are skipped entirely.
+ *
+ * A write to a negative or a reported+ offset, a negative count are
+ * considered error conditions and returned with an -EINVAL.
+ */
+ssize_t nvgrace_gpu_write_mem(size_t count, loff_t *ppos, const void __user *buf,
+			       struct nvgrace_gpu_vfio_pci_core_device *nvdev)
+{
+	u64 offset = *ppos & VFIO_PCI_OFFSET_MASK;
+	size_t mem_count, bar_size = roundup_pow_of_two(nvdev->memlength);
+
+	if (offset >= bar_size)
+		return -EINVAL;
+
+	/* Clip short the read request beyond reported BAR size */
+	count = min(count, bar_size - (size_t)offset);
+
+	/*
+	 * Determine how many bytes to be actually written to the device memory.
+	 * Do not write to the offset beyond available size.
+	 */
+	if (offset >= nvdev->memlength)
+		return 0;
+
+	mem_count = min(count, nvdev->memlength - (size_t)offset);
+
+	/*
+	 * Only the device memory present on the hardware is mapped, which may
+	 * not be power-of-2 aligned. A write to the BAR2 region implies an
+	 * access outside the available device memory on the hardware. Drop
+	 * those write requests.
+	 */
+	if (copy_from_user((u8 *)nvdev->memmap + offset, buf, mem_count))
+		return -EFAULT;
+
+	return count;
+}
+
+static ssize_t nvgrace_gpu_vfio_pci_write(struct vfio_device *core_vdev,
+					   const char __user *buf, size_t count, loff_t *ppos)
+{
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
+		core_vdev, struct nvgrace_gpu_vfio_pci_core_device, core_device.vdev);
+
+	if (index == VFIO_PCI_BAR2_REGION_INDEX) {
+		mutex_lock(&nvdev->memmap_lock);
+		if (!nvdev->memmap) {
+			nvdev->memmap = memremap(nvdev->memphys, nvdev->memlength, MEMREMAP_WB);
+			if (!nvdev->memmap) {
+				mutex_unlock(&nvdev->memmap_lock);
+				return -ENOMEM;
+			}
+		}
+		mutex_unlock(&nvdev->memmap_lock);
+
+		return nvgrace_gpu_write_mem(count, ppos, buf, nvdev);
+	}
+
+	return vfio_pci_core_write(core_vdev, buf, count, ppos);
+}
+
+static const struct vfio_device_ops nvgrace_gpu_vfio_pci_ops = {
+	.name = "nvgrace-gpu-vfio-pci",
+	.init = vfio_pci_core_init_dev,
+	.release = vfio_pci_core_release_dev,
+	.open_device = nvgrace_gpu_vfio_pci_open_device,
+	.close_device = nvgrace_gpu_vfio_pci_close_device,
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
+					    struct nvgrace_gpu_vfio_pci_core_device *nvdev)
+{
+	int ret;
+	u64 memphys, memlength;
+
+	/*
+	 * The memory information is present in the system ACPI tables as DSD
+	 * properties nvidia,gpu-mem-base-pa and nvidia,gpu-mem-size.
+	 */
+	ret = device_property_read_u64(&pdev->dev, "nvidia,gpu-mem-base-pa",
+				       &(memphys));
+	if (ret)
+		return ret;
+
+	if (memphys > type_max(phys_addr_t))
+		return -EOVERFLOW;
+
+	nvdev->memphys = memphys;
+
+	ret = device_property_read_u64(&pdev->dev, "nvidia,gpu-mem-size",
+				       &(memlength));
+	if (ret)
+		return ret;
+
+	if (memlength > type_max(size_t))
+		return -EOVERFLOW;
+
+	/*
+	 * If the C2C link is not up due to an error, the coherent device
+	 * memory size is returned as 0. Fail in such case.
+	 */
+	if (memlength == 0)
+		return -ENOMEM;
+
+	nvdev->memlength = memlength;
+
+	return ret;
+}
+
+static int nvgrace_gpu_vfio_pci_probe(struct pci_dev *pdev,
+				       const struct pci_device_id *id)
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

