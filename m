Return-Path: <kvm+bounces-1642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43E7C7EAB6A
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 09:16:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E12D1C209C7
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 08:16:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 381371401C;
	Tue, 14 Nov 2023 08:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eBXWP7Ry"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D5A13ACD
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 08:16:43 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2042.outbound.protection.outlook.com [40.107.220.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B522E1A6;
	Tue, 14 Nov 2023 00:16:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lYiqLC/IeaPINTV1sWlHzY7zSvmR/YF7L5V/rVJfDS4jwVNsrhIaV3U3WpoRX53GGQoe8butDrEWdEVMWJ94D8jDJ8us5i7KW97nq7Q4zjkSyY1ZbuGLlxNJfV9/B6Ijwl3XWym0M6aEdxRdaG8VpdFNx9XuHF2zCwMs7dJ6uva+5k0rjLBJVAjuvuEVPxazOR6MT/LnrI8fW7sY9MTIrdRs3/Vub28og1pDMg5JhzoUXUv9fNCLSjFAoNHKLcCnrqMtTiUO3gyscJMXO8eXH6TIoXIet8lx8wkvH8agRdMSV4O06iIntn8+MPSysZ3bMocblrQ0WHCMFlCZJULBGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Bz8nl9bkEbPQDfn3DCZClxkRNnbMIUaIF1iwQS9y9s=;
 b=Dgv6jevwpq61T1reEDQBhFSLawbpdgeOkCgX34RaxE1rQ2miWno7sDnUCo+LjNhUYscqOrq3AufYEsSH8KXL+RQecr6ZVGa7e08RnVj4qGpcImiiuoOPT58oGLIWB7BHpXbWTUycA8bpc7HdrOR+n/xEKTyMBPBfZ8RYKGZhIZwV2D7oKVcnJwqTn3xmRQre7DlsEiozjWi33Y8yu69mZnj825KWAyVxHKhq1SA2emNI7MrRphBVGWGjNcID8R/esES1o1R9uxU1fcs6NkxtaA96qY7Ko5VrTl3rMG71xTor74V3rd0VsT1/L1Qatc3Ln3Y8nUzFdRgRaFJ4keqRuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Bz8nl9bkEbPQDfn3DCZClxkRNnbMIUaIF1iwQS9y9s=;
 b=eBXWP7RyT8kZYedC5T9i9DX5g2At3SiLSlVWISm/bH35sviA4m8cGlbzk5K4a9EU7Zl5LPy5ULmIkkSvY+1k7KhZgEaGWI/I/49OOs1j9MGV6WbCExIDib3f6iZ4TU9hvQCGR7e6wRXkv/YCMkSfhb518JA7dYkAl861Smdkb9l2mcNRxBCJMDpOT9lfkmkA1UMISOnlcCsxCviHbynYxo7OM04egA0Ano4QFNrtCT6g0bSYz9uMVDjruE0wturzsPEZiybM8A8fe4obnlNUT82ZXDT9JJe6Y9ZIT8a7wpYpqesKmi1f8TK5AlUxskuuYAE2MLn9U1Zbcz9K95gkDg==
Received: from MN2PR22CA0027.namprd22.prod.outlook.com (2603:10b6:208:238::32)
 by LV3PR12MB9438.namprd12.prod.outlook.com (2603:10b6:408:212::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.28; Tue, 14 Nov
 2023 08:16:33 +0000
Received: from BL6PEPF0001AB4C.namprd04.prod.outlook.com
 (2603:10b6:208:238:cafe::d6) by MN2PR22CA0027.outlook.office365.com
 (2603:10b6:208:238::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31 via Frontend
 Transport; Tue, 14 Nov 2023 08:16:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF0001AB4C.mail.protection.outlook.com (10.167.242.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7002.14 via Frontend Transport; Tue, 14 Nov 2023 08:16:33 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 14 Nov
 2023 00:16:19 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 14 Nov
 2023 00:16:18 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41 via Frontend
 Transport; Tue, 14 Nov 2023 00:16:13 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v13 1/1] vfio/nvgpu: Add vfio pci variant module for grace hopper
Date: Tue, 14 Nov 2023 13:46:11 +0530
Message-ID: <20231114081611.30550-1-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4C:EE_|LV3PR12MB9438:EE_
X-MS-Office365-Filtering-Correlation-Id: a04b9f58-737e-4ee0-7f7f-08dbe4ea0355
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	zkvQmJLBWbMgRH9zp8m8wr7lbeB+91geE26ovTcN6RKHX3kdclJ/X1Y8DMN8pPe/jVY5bhmLBi9OFdxKzpIM3flr/6UK4S3/3jDHBnx7dlm3v9llBhhusqmUKPsZlFV2pOdVUF7AC6RE8adgNc64HjvEIc6eR4eieZ6Y1GbGBxftaumLEwp7kJ1s2iRl1GDWvkHg/Fc81CS6if3jsFaEw4znkFBW/hxZEHqDzqSAvR8qJCv7Ls6cpk2s0ob8mK9YH6S98yTCdazLB5KCtTfFm4wJ2rNtjqZrPvB0tRPZdxhQZ4g7Evbw0nVRc9v7xNMjLoOAdfn84k8YCzIuAxJqJM7YF2IR7UqXULaQDswNuYRuQsNg5PPCpcEnFft21s1wCePFddzYbAgQ4O7WreG36cY8ofesiPy7y0fl6qT+hcneuiQo73LR5UI42r/xBUZpM7phxrevwKwVTUHXg1DuM5MAg9ZEVkJR9suKyT9t+rfeEZJ0AIKnPufHj6HsZeelOZmjBH5Ehk5QvuTrmb1k/fxmLRTl6qXyzKhCM7d8uiAM9hMpB5ba4XGnwVEBUT79647Uw8/Qcj0RY9QC/DCs62++9lo2tw8RE1iPGhPqDJZoHTMeQ+dE/94UCSL1uAeCNGfgWIiE2iSHb0WaDqlsbYLt1LZnKrxKW8f/qRf3kuRMrf9Powfuk2Xs2H2Lyt5tfgqKXb+S00WZEGlndWgqcAYZYgHXyyqEH6bUNshvVtSYCaPHCXgZD1ToNdacJxqAlb5DavOIInMtYUAt3a+nWY7bKGTa1DmjA5kKvafz7FhsEvDU1TjIfYxxgvdm2vpE
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(39860400002)(376002)(396003)(346002)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(82310400011)(46966006)(36840700001)(40470700004)(2876002)(36860700001)(2906002)(1076003)(30864003)(40460700003)(2616005)(86362001)(5660300002)(41300700001)(426003)(26005)(336012)(47076005)(110136005)(82740400003)(54906003)(70206006)(316002)(70586007)(83380400001)(966005)(36756003)(478600001)(7696005)(7636003)(356005)(8676002)(4326008)(8936002)(40480700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2023 08:16:33.0440
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a04b9f58-737e-4ee0-7f7f-08dbe4ea0355
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB4C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9438

From: Ankit Agrawal <ankita@nvidia.com>

NVIDIA's upcoming Grace Hopper Superchip provides a PCI-like device
for the on-chip GPU that is the logical OS representation of the
internal proprietary chip-to-chip cache coherent interconnect.

The device is peculiar compared to a real PCI device in that whilst
there is a real 64b PCI BAR1 (comprising region 2 & region 3) on the device,
it is not used to access device memory once the faster chip-to-chip
interconnect is initialized (occurs at the time of host system boot).
The device memory is accessed instead using the chip-to-chip interconnect
that is exposed as a contiguous physically addressable region on the host.

Provide a VFIO PCI variant driver that adapts the unique device memory
representation into a more standard PCI representation facing userspace.

The device memory aperture is obtained from ACPI using
device_property_read_u64(), according to the FW specification, and exported
to userspace as a separate VFIO BAR region. Since the device implements
64-bit BAR0, the VFIO PCI variant driver maps the GPU memory aperture
to the next available PCI BAR (BAR2). Qemu will then naturally generate a
PCI device in the VM with the cacheable aperture reported in BAR2 region. The
variant driver also provides emulation for this fake BAR's PCI config space
offset registers.

Since this memory region is actually cache coherent with the CPU, the
VFIO variant driver will mmap it into VMA using a cacheable mapping. The
mapping is done using remap_pfn_range().

PCI BAR are aligned to the power-of-2, but the actual memory on the
device may not. A read or write access to the physical address from the
last device PFN up to the next power-of-2 aligned physical address
results in reading ~0 and dropped writes. Note that the GPU device
driver [1] is capable of knowing the exact device memory size through
separate means. The device memory size is primarily kept in the system
ACPI tables for use by the VFIO PCI variant module.

This goes along with a qemu series to provides the necessary
implementation of the Grace Hopper Superchip firmware specification so
that the guest operating system can see the correct ACPI modeling for
the coherent GPU device. Verified with the CUDA workload in the VM.
https://lore.kernel.org/all/20231107190039.19434-1-ankita@nvidia.com/

This patch is split from a patch series being pursued separately:
https://lore.kernel.org/lkml/20230405180134.16932-1-ankita@nvidia.com/

Applied over next-20231113.

[1] https://github.com/NVIDIA/open-gpu-kernel-modules

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
Signed-off-by: Aniket Agashe <aniketa@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---

Link for v12:
https://lore.kernel.org/all/20231015163047.20391-1-ankita@nvidia.com/

v12 -> v13
- Added emulation for the PCI config space BAR offset register for
the fake BAR.
- commit message updated with more details on the BAR offset emulation.

v11 -> v12
- More details in commit message on device memory size

v10 -> v11
- Removed sysfs attribute to expose the CPU coherent memory feature
- Addressed review comments

v9 -> v10
- Add new sysfs attribute to expose the CPU coherent memory feature.

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
---
---
 MAINTAINERS                           |   6 +
 drivers/vfio/pci/Kconfig              |   2 +
 drivers/vfio/pci/Makefile             |   2 +
 drivers/vfio/pci/nvgrace-gpu/Kconfig  |  10 +
 drivers/vfio/pci/nvgrace-gpu/Makefile |   3 +
 drivers/vfio/pci/nvgrace-gpu/main.c   | 586 ++++++++++++++++++++++++++
 6 files changed, 609 insertions(+)
 create mode 100644 drivers/vfio/pci/nvgrace-gpu/Kconfig
 create mode 100644 drivers/vfio/pci/nvgrace-gpu/Makefile
 create mode 100644 drivers/vfio/pci/nvgrace-gpu/main.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 1466699fbaaf..c1b43eb35cea 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22891,6 +22891,12 @@ L:	kvm@vger.kernel.org
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
index 000000000000..936e88d8d41d
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
+	  required to assign the GPU device using KVM/qemu/etc.
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
index 000000000000..a3dbee6b87de
--- /dev/null
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -0,0 +1,586 @@
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
+	u32 bar_regs[2];
+	void *memmap;
+	struct mutex memmap_lock;
+};
+
+static void init_fake_bar_emu_regs(struct vfio_device *core_vdev)
+{
+	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
+		core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
+		core_device.vdev);
+
+	nvdev->bar_regs[0] = PCI_BASE_ADDRESS_MEM_TYPE_64 |
+			     PCI_BASE_ADDRESS_MEM_PREFETCH;
+	nvdev->bar_regs[1] = 0;
+}
+
+static bool is_fake_bar_pcicfg_emu_reg_access(loff_t pos)
+{
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(pos);
+	u64 offset = pos & VFIO_PCI_OFFSET_MASK;
+
+	if ((index == VFIO_PCI_CONFIG_REGION_INDEX) &&
+	    (offset == PCI_BASE_ADDRESS_2 || offset == PCI_BASE_ADDRESS_3))
+		return true;
+
+	return false;
+}
+
+static int nvgrace_gpu_vfio_pci_open_device(struct vfio_device *core_vdev)
+{
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
+		core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
+		core_device.vdev);
+	int ret;
+
+	ret = vfio_pci_core_enable(vdev);
+	if (ret)
+		return ret;
+
+	vfio_pci_core_finish_enable(vdev);
+
+	init_fake_bar_emu_regs(core_vdev);
+
+	mutex_init(&nvdev->memmap_lock);
+
+	return 0;
+}
+
+static void nvgrace_gpu_vfio_pci_close_device(struct vfio_device *core_vdev)
+{
+	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
+		core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
+		core_device.vdev);
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
+	 * The available GPU memory size may not be power-of-2 aligned. Map up
+	 * to the size of the device memory. If the memory access is beyond the
+	 * actual GPU memory size, it will be handled by the vfio_device_ops
+	 * read/write.
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
+	if (cmd == VFIO_DEVICE_RESET)
+		init_fake_bar_emu_regs(core_vdev);
+
+	return vfio_pci_core_ioctl(core_vdev, cmd, arg);
+}
+
+static int nvgrace_gpu_memmap(struct nvgrace_gpu_vfio_pci_core_device *nvdev)
+{
+	mutex_lock(&nvdev->memmap_lock);
+	if (!nvdev->memmap) {
+		nvdev->memmap = memremap(nvdev->memphys, nvdev->memlength, MEMREMAP_WB);
+		if (!nvdev->memmap) {
+			mutex_unlock(&nvdev->memmap_lock);
+			return -ENOMEM;
+		}
+	}
+	mutex_unlock(&nvdev->memmap_lock);
+
+	return 0;
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
+ * A read from a negative or an offset greater than reported size, a negative
+ * count are considered error conditions and returned with an -EINVAL.
+ */
+static ssize_t
+nvgrace_gpu_read_mem(void __user *buf, size_t count, loff_t *ppos,
+		     struct nvgrace_gpu_vfio_pci_core_device *nvdev)
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
+	 * Read request beyond the actual device memory size is filled with ~0,
+	 * while those beyond the actual reported size is skipped.
+	 */
+	if (offset >= nvdev->memlength)
+		mem_count = 0;
+	else
+		mem_count = min(count, nvdev->memlength - (size_t)offset);
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
+	 * not be power-of-2 aligned. A read to an offset beyond the device memory
+	 * size is filled with ~0.
+	 */
+	for (i = mem_count; i < count; i++)
+		put_user(val, (unsigned char __user *)(buf + i));
+
+	*ppos += count;
+	return count;
+}
+
+static ssize_t pcibar_read_emu(struct nvgrace_gpu_vfio_pci_core_device *nvdev,
+				char __user *buf, size_t count, loff_t *ppos)
+{
+	u64 pos = *ppos & VFIO_PCI_OFFSET_MASK;
+	u32 val;
+
+	if (!IS_ALIGNED(pos, 4) || !(is_fake_bar_pcicfg_emu_reg_access(*ppos)))
+		return -EINVAL;
+
+	switch (pos) {
+	case PCI_BASE_ADDRESS_2:
+		val = nvdev->bar_regs[0];
+		break;
+	case PCI_BASE_ADDRESS_3:
+		val = nvdev->bar_regs[1];
+		break;
+	}
+
+	if (copy_to_user(buf, &val, count))
+		return -EFAULT;
+
+	*ppos += count;
+	return count;
+}
+
+static ssize_t nvgrace_gpu_vfio_pci_read(struct vfio_device *core_vdev,
+					  char __user *buf, size_t count, loff_t *ppos)
+{
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
+		core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
+		core_device.vdev);
+	int ret;
+
+	if (index == VFIO_PCI_BAR2_REGION_INDEX) {
+		ret = nvgrace_gpu_memmap(nvdev);
+		if (ret)
+			return ret;
+
+		return nvgrace_gpu_read_mem(buf, count, ppos, nvdev);
+	}
+
+	if (is_fake_bar_pcicfg_emu_reg_access(*ppos))
+		return pcibar_read_emu(nvdev, buf, count, ppos);
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
+ * A write to a negative or an offset greater than the reported size, a
+ * negative count are considered error conditions and returned with an -EINVAL.
+ */
+static ssize_t
+nvgrace_gpu_write_mem(size_t count, loff_t *ppos, const void __user *buf,
+		      struct nvgrace_gpu_vfio_pci_core_device *nvdev)
+{
+	u64 offset = *ppos & VFIO_PCI_OFFSET_MASK;
+	size_t mem_count, bar_size = roundup_pow_of_two(nvdev->memlength);
+
+	if (offset >= bar_size)
+		return -EINVAL;
+
+	/* Clip short the write request beyond reported BAR size */
+	count = min(count, bar_size - (size_t)offset);
+
+	/*
+	 * Determine how many bytes to be actually written to the device memory.
+	 * Do not write to the offset beyond available size.
+	 */
+	if (offset >= nvdev->memlength)
+		goto exitfn;
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
+exitfn:
+	*ppos += count;
+	return count;
+}
+
+static ssize_t pcibar_write_emu(struct nvgrace_gpu_vfio_pci_core_device *nvdev,
+				 const char __user *buf, size_t count, loff_t *ppos)
+{
+	u64 pos = *ppos & VFIO_PCI_OFFSET_MASK;
+	u64 size;
+	u32 val;
+
+	if (!IS_ALIGNED(pos, 4) || !(is_fake_bar_pcicfg_emu_reg_access(*ppos)))
+		return -EINVAL;
+
+	if (copy_from_user(&val, buf, count))
+		return -EFAULT;
+
+	size = ~(roundup_pow_of_two(nvdev->memlength) - 1);
+
+	if (val == 0xffffffff) {
+		switch (pos) {
+		case PCI_BASE_ADDRESS_2:
+			nvdev->bar_regs[0] = (size & GENMASK(31, 4)) |
+				(nvdev->bar_regs[0] & GENMASK(3, 0));
+			break;
+		case PCI_BASE_ADDRESS_3:
+			nvdev->bar_regs[1] = size >> 32;
+			break;
+		}
+	} else {
+		switch (pos) {
+		case PCI_BASE_ADDRESS_2:
+			nvdev->bar_regs[0] = val;
+			break;
+		case PCI_BASE_ADDRESS_3:
+			nvdev->bar_regs[1] = val;
+			break;
+		}
+	}
+
+	*ppos += count;
+	return count;
+}
+
+static ssize_t nvgrace_gpu_vfio_pci_write(struct vfio_device *core_vdev,
+					   const char __user *buf, size_t count, loff_t *ppos)
+{
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
+		core_vdev, struct nvgrace_gpu_vfio_pci_core_device, core_device.vdev);
+	int ret;
+
+	if (index == VFIO_PCI_BAR2_REGION_INDEX) {
+		ret = nvgrace_gpu_memmap(nvdev);
+		if (ret)
+			return ret;
+
+		return nvgrace_gpu_write_mem(count, ppos, buf, nvdev);
+	}
+
+	if (is_fake_bar_pcicfg_emu_reg_access(*ppos))
+		return pcibar_write_emu(nvdev, buf, count, ppos);
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


