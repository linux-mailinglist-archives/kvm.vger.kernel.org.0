Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A859784B4E
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 22:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbjHVUXX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 16:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbjHVUXW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 16:23:22 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on20603.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::603])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99752CED;
        Tue, 22 Aug 2023 13:23:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GZwdn4XcOPF02ObPGahHb/sjZ72hmszp02q1QNBhEV6J0LR0seERTP4yY/LLXF+HUI1aVPoGFIXwS9V1VIeyIr97/M1o8uqRn7R9NrBgpIas88LZwC9q4QBc5s3lt+RAqA2Bial52n7KmE8Gzya5uleuaXQ81TZHby5Yxr1nP6j/vnAujI/ZE4zOhu+nJW0dDe2NdaD3FY+fUQ/ldZUI2lhw62igdzDq2LrTCmObMfxq/i5sA7IWJQdQOMHTXf1FMvh52tZuaDKFNxr4uGewdCWaYgBEN8draYrC8VfCzDPhcYE7PkUbfpm+tPvs3Q2zQ6xDEenEvosKAPMZvd76nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SyVDluoOkFzanIXZCXxI1T1PBRM2XjhJuxrJVj39l+c=;
 b=UWuckMW9+p6t0X6jEPCPmCDvJvjyaB1cw5vG2+HMrMpxX95zr6Uq3QwrqnAD8lVyxM2Z0izvdhmZwFF6Qib0HT2wY8ty15QBk8hEDZYoMSGeRyUAgtLogy9xU1kKnlZ4jm1Ggu5FeYDEFZsqEUn1+V8RU0tRyoNbGgQ/61hThKrtLp9h71IzbnoZbYSZ0cN796fHfXKrjoEnCisnYJ/LWImt+poxu7jt7Wxey8a2Jv+2shPput2LKhFwS9ncdmzbcKPjBo3MgWN0yI1WF44BAgg44C9obdW5Ty0EoiZEM2bGUMNED11fgr5JH8A3jlg8F5iwysbeKUBdQNNlQY19pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SyVDluoOkFzanIXZCXxI1T1PBRM2XjhJuxrJVj39l+c=;
 b=M94V0QgJ/93s3ACX0BTfd3SFJwqAqYtqhC6tdNIP91DeDtcETWfMV3w5Tvjyo8wKOXY3zQehCT4C+u+8+u8mK6kCJCM/bNkjLgLtlotspRxmpXTcJkdKNz7NNVWjbmRhNMoZAuCYOGu5oQHUPBnsIxH6rYvSjEftDJCbW4TE/tyd6JZi0eLZjOE1rDrv8bt/y6znItymU48MIheyXNRCgTLy+0bb48EjidRGUbKgBz8l+ZElTsmbp1etC1hrmW9SsGumqBPooKiXps7TqomGYHmBXkZZq+9JGWqSZRypXisozgI4rPYJFJ8ZQLxXNaLUKTPTGPJtR0OGTfyiHsA81Q==
Received: from DM6PR06CA0021.namprd06.prod.outlook.com (2603:10b6:5:120::34)
 by PH0PR12MB5500.namprd12.prod.outlook.com (2603:10b6:510:ef::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.24; Tue, 22 Aug
 2023 20:23:12 +0000
Received: from CY4PEPF0000EDD1.namprd03.prod.outlook.com
 (2603:10b6:5:120:cafe::e2) by DM6PR06CA0021.outlook.office365.com
 (2603:10b6:5:120::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.20 via Frontend
 Transport; Tue, 22 Aug 2023 20:23:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CY4PEPF0000EDD1.mail.protection.outlook.com (10.167.241.205) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6699.15 via Frontend Transport; Tue, 22 Aug 2023 20:23:12 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 22 Aug 2023
 13:23:04 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Tue, 22 Aug 2023 13:23:03 -0700
Received: from ankita-dt2.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37 via Frontend
 Transport; Tue, 22 Aug 2023 13:23:03 -0700
From:   <ankita@nvidia.com>
To:     <ankita@nvidia.com>, <jgg@nvidia.com>,
        <alex.williamson@redhat.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>
CC:     <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
        <targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
        <apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v7 1/1] vfio/nvgpu: Add vfio pci variant module for grace hopper
Date:   Tue, 22 Aug 2023 13:23:03 -0700
Message-ID: <20230822202303.19661-1-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD1:EE_|PH0PR12MB5500:EE_
X-MS-Office365-Filtering-Correlation-Id: 10f27a17-e64e-4777-0e40-08dba34d9b97
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hq7bUTgVw/0WjNzA78BvbaOoEwOnvpocS5+ry0p1fuqTpZ+Jr6XxRIIU6LMaYPKxGOUQA/gMgvJltL4nNq8NBjpnJ9cBXwvFc7n1xcCsv1++5OspLw9ywYYSlqilk/2eFLhyIsYygvVMjPsUFHGY2JnbQuse2niN4IGm4zyvKcprd7aiy040K4lRSM2EmZtRskw3jFS/LzV72/OUJxBIhdjTeh+js+4Vz8hBIuT+OBpBkSYknrPdFGUPR9GwuOKgQGPfDTU+S5sY7aSTRxGO6tsm2nQVN/ZP6qiK55E9/TzV5oS0W35PmNZ8p2D7VUO7DyoxztAECjAnJhlL9U4Z6KTU1owDXOFtCl6Xpa2ptQLbvciCcvpohG/UCGCCLFx21GJNUFChpy2MQbrhaBy4Rnshf9umuf76d0bc5XgHtWrgNu6bRUgBWHgZojxwcF+pKf+7TlB13x5Iwi4pkuI9wkVOXn2RuCXv7F5wL4Z89TNeeDq/51tdxVSVQ4CU7MZ+Hlp9sjbXEtutENjYwaqfkh62tybq3tAvRro/yb2rEuUpqWGaMCZUeeNvIMX5KPLHo/+MtGfUYrX3UoQPDxDHGFYpyrqZ1/M5GWrlSSKdOudVj2ALfSDsTK/YnNzv0q+QhQorCwa3M/IWh0lpZZXAYNyQuWsmYGsDpJSyuS4UHHGDlsqSqEn4Xb6ZzwpxhrT+RIe2/OhwlLdF46HBVfubSCNIq/K8IDELRuymuuHsCp3yHg8IsMLDiiQHcWOUfO+SnwIPtJU4A8/1SH+kqtvGcQ==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(136003)(39860400002)(376002)(346002)(186009)(1800799009)(82310400011)(451199024)(36840700001)(40470700004)(46966006)(54906003)(70586007)(316002)(70206006)(110136005)(8676002)(8936002)(2616005)(4326008)(966005)(7636003)(36756003)(40460700003)(41300700001)(1076003)(356005)(82740400003)(478600001)(40480700001)(83380400001)(30864003)(2906002)(47076005)(2876002)(7696005)(36860700001)(86362001)(426003)(336012)(5660300002)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2023 20:23:12.0297
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 10f27a17-e64e-4777-0e40-08dba34d9b97
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000EDD1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5500
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
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
device may not. A read or write access to the physical address from the
last device PFN up to the next power-of-2 aligned physical address
results in reading ~1 and dropped writes.

This goes along with a qemu series to provides the necessary
implementation of the Grace Hopper Superchip firmware specification so
that the guest operating system can see the correct ACPI modeling for
the coherent GPU device. Verified with the CUDA workload in the VM.
https://www.mail-archive.com/qemu-devel@nongnu.org/msg967557.html

This patch is split from a patch series being pursued separately:
https://lore.kernel.org/lkml/20230405180134.16932-1-ankita@nvidia.com/

Applied and tested over next-20230821.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---

Link for v6: https://lore.kernel.org/all/20230801130714.8221-1-ankita@nvidia.com/

v6 -> v7
- Handled out-of-bound and overflow conditions at various places to validate
  input offset and length.
- Added code to return EINVAL for offset beyond region size.
- Memremap the device memory region and cached in the nvdev object until
  the device is closed

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
 drivers/vfio/pci/nvgrace-gpu/main.c   | 444 ++++++++++++++++++++++++++
 6 files changed, 467 insertions(+)
 create mode 100644 drivers/vfio/pci/nvgrace-gpu/Kconfig
 create mode 100644 drivers/vfio/pci/nvgrace-gpu/Makefile
 create mode 100644 drivers/vfio/pci/nvgrace-gpu/main.c

diff --git a/MAINTAINERS b/MAINTAINERS
index d590ce31aa72..3398dba35b48 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22347,6 +22347,12 @@ L:	kvm@vger.kernel.org
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
index 000000000000..161a6b19e31c
--- /dev/null
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -0,0 +1,444 @@
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
+	u64 hpa;
+	u64 mem_length;
+	void *opregion;
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
+static void nvgrace_gpu_vfio_pci_close_device(struct vfio_device *core_vdev)
+{
+	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
+		core_vdev, struct nvgrace_gpu_vfio_pci_core_device, core_device.vdev);
+
+	if (nvdev->opregion) {
+		memunmap(nvdev->opregion);
+		nvdev->opregion = NULL;
+	}
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
+		check_add_overflow(PHYS_PFN(nvdev->hpa), pgoff, &start_pfn) ||
+		check_add_overflow(PFN_PHYS(pgoff), req_len, &end))
+		return -EOVERFLOW;
+
+	if (end > nvdev->mem_length)
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
+static long nvgrace_gpu_vfio_pci_ioctl(struct vfio_device *core_vdev,
+					unsigned int cmd, unsigned long arg)
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
+/*
+ * Read count bytes from the device memory at an offset. The actual device
+ * memory size (available) may not be a power-of-2. So the driver fakes
+ * the size to a power-of-2 (reported) when exposing to a user space driver.
+ *
+ * Read request beyond the actual device size is filled with ~1, while
+ * those beyond the actual reported size is skipped.
+ *
+ * A read from a reported+ offset is considered error conditions and
+ * returned with an -EINVAL. Overflow conditions are also handled.
+ */
+ssize_t nvgrace_gpu_read_mem(void __user *buf, size_t count, loff_t *ppos,
+			      const void *addr, size_t available, size_t reported)
+{
+	u64 offset = *ppos & VFIO_PCI_OFFSET_MASK;
+	u64 end;
+	size_t read_count, i;
+	u8 val = 0xFF;
+
+	if (offset >= reported)
+		return -EINVAL;
+
+	if (check_add_overflow(offset, count, &end))
+		return -EOVERFLOW;
+
+	/* Clip short the read request beyond reported BAR size */
+	if (end >= reported)
+		count = reported - offset;
+
+	/*
+	 * Determine how many bytes to be actually read from the device memory.
+	 * Do not read from the offset beyond available size.
+	 */
+	if (offset >= available)
+		read_count = 0;
+	else
+		read_count = min(count, available - (size_t)offset);
+
+	/*
+	 * Handle read on the BAR2 region. Map to the target device memory
+	 * physical address and copy to the request read buffer.
+	 */
+	if (copy_to_user(buf, (u8 *)addr + offset, read_count))
+		return -EFAULT;
+
+	/*
+	 * Only the device memory present on the hardware is mapped, which may
+	 * not be power-of-2 aligned. A read to the BAR2 region implies an
+	 * access outside the available device memory on the hardware. Fill
+	 * such read request with ~1.
+	 */
+	for (i = 0; i < count - read_count; i++)
+		if (copy_to_user(buf + read_count + i, &val, 1))
+			return -EFAULT;
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
+		if (!nvdev->opregion) {
+			nvdev->opregion = memremap(nvdev->hpa, nvdev->mem_length, MEMREMAP_WB);
+			if (!nvdev->opregion)
+				return -ENOMEM;
+		}
+
+		return nvgrace_gpu_read_mem(buf, count, ppos, nvdev->opregion,
+				nvdev->mem_length, roundup_pow_of_two(nvdev->mem_length));
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
+ * A write to a reported+ offset is considered error conditions and
+ * returned with an -EINVAL. Overflow conditions are also handled.
+ */
+ssize_t nvgrace_gpu_write_mem(const void *addr, size_t count, loff_t *ppos,
+			       const void __user *buf, size_t available, size_t reported)
+{
+	u64 offset = *ppos & VFIO_PCI_OFFSET_MASK;
+	u64 end;
+	size_t write_count;
+
+	if (offset >= reported)
+		return -EINVAL;
+
+	if (check_add_overflow(offset, count, &end))
+		return -EOVERFLOW;
+
+	/* Clip short the read request beyond reported BAR size */
+	if (end >= reported)
+		count = reported - offset;
+
+	/*
+	 * Determine how many bytes to be actually written to the device memory.
+	 * Do not write to the offset beyond available size.
+	 */
+	if (offset >= available)
+		write_count = 0;
+	else
+		write_count = min(count, available - (size_t)offset);
+
+	/*
+	 * Only the device memory present on the hardware is mapped, which may
+	 * not be power-of-2 aligned. A write to the BAR2 region implies an
+	 * access outside the available device memory on the hardware. Drop
+	 * those write requests.
+	 */
+	if (copy_from_user((u8 *)addr + offset, buf, write_count))
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
+		if (!nvdev->opregion) {
+			nvdev->opregion = memremap(nvdev->hpa, nvdev->mem_length, MEMREMAP_WB);
+			if (!nvdev->opregion)
+				return -ENOMEM;
+		}
+
+		return nvgrace_gpu_write_mem(nvdev->opregion, count, ppos, buf,
+				nvdev->mem_length, roundup_pow_of_two(nvdev->mem_length));
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

