Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BED4D7395B4
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 05:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjFVDHm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 23:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjFVDHj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 23:07:39 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2081.outbound.protection.outlook.com [40.107.93.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F7EE57;
        Wed, 21 Jun 2023 20:07:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=edcZyyD6+t2SRS83IxZmLaOs46gsofroOY4gagDrJExVS9J2ohpTP2TjvLp8BNrLWYGn5oI0MxNgU3DW8126G75zAESNTuObnrswwOv2I8XwMqvDP8xLnYXYS+ohjALi9+PcHZr+GIgsxUYb8uy9I1uHSxmBGkitV29CEf485M9fLjtf8SHEImOtn45sokmsW3B7bF5IsyedLuRHn/tBqZivFheiwqcEQJYfVx60KgIiSbZglHf9vn8UEmoU5u0ATGKoCDL/G4/BAYpSMfy3Gg6LJqZ509UdVDWoHU74RXKZz6RZC2enTrPT/L8EEznSPSU2TFNJ7Fd/WREzMSLB3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nG9VhOBM8evZm6IZeOQ0/E0CPZIuBSeqzGB2TJohjgY=;
 b=bc6OGGLkgY1IHEx/UnWtiTtzr+D5mByVtgcVBOtg5UniG6WL1jFc+jd3fb5TBB5/VZQ9NZHmd/PFbcVrhJq4xPg8rzoJd3UzwuUlG+B0FyvmzxoGEGkov9v3Cn4KGiWGlQwV3irT/niDJ+rl2fG4sqbWeNQwpzr5/S2jdKJLAQoi4z1epQrGY9AMRfOzWhowQBBzUHc8qCenU3yuKDV4NISp7+fAAoFA8+7dqZjmEBwBqOSSaeHKtKGDyzIPlKShb28KN4Bm4advK0JTLzksXfEwjSwpmhsp5FEpAiTONTugZKhZYY1PFhaQBaMed5vjKa9KqJhKtLwL0U30lIHIsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nG9VhOBM8evZm6IZeOQ0/E0CPZIuBSeqzGB2TJohjgY=;
 b=jLHjuT/Y9EFZXOOVebdOM4rwCMlniE5ycnAlKCy7GHG3+Etdr8i4RxxvvIOyB9Pe0C9gl5/kUYhWcCXvboFs4n7F1/AcUhsL5XxJNJzjvLIxQv6D76OlX2qg/5vy12/2IR6JteWOTsm6ey9DS37Uk3qgOIic3Mxw/oVHMDEMBH/dRAbv8zlsuIhc3WwVmGodwHM+n9AqYFSbtRqPhOdY9X48UaHVKRU8Tz2vilzhaYrlNgVsVih/qUYUam1/HWV2kHLMDFRf3npSYkECVK944fzEhUUowssPYKlz/KOx1zy+4vZWNYAhe2XW761WtvOQvHIe2Rrq/0WMMT1BPtsgKw==
Received: from BN8PR03CA0022.namprd03.prod.outlook.com (2603:10b6:408:94::35)
 by MW6PR12MB9018.namprd12.prod.outlook.com (2603:10b6:303:241::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Thu, 22 Jun
 2023 03:07:33 +0000
Received: from BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:94:cafe::1e) by BN8PR03CA0022.outlook.office365.com
 (2603:10b6:408:94::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37 via Frontend
 Transport; Thu, 22 Jun 2023 03:07:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN8NAM11FT052.mail.protection.outlook.com (10.13.177.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.37 via Frontend Transport; Thu, 22 Jun 2023 03:07:32 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 21 Jun 2023
 20:07:21 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Wed, 21 Jun 2023 20:07:20 -0700
Received: from ankita-dt2.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37 via Frontend
 Transport; Wed, 21 Jun 2023 20:07:20 -0700
From:   <ankita@nvidia.com>
To:     <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>
CC:     <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
        <targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
        <apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 1/1] vfio/nvgpu: Add vfio pci variant module for grace hopper
Date:   Wed, 21 Jun 2023 20:07:20 -0700
Message-ID: <20230622030720.19652-1-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT052:EE_|MW6PR12MB9018:EE_
X-MS-Office365-Filtering-Correlation-Id: 048d42cf-e01a-45a2-a42a-08db72cdd283
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nlVEpQFZAKufg+eIpXB/KZ+Ij0vH4KyM3DAvbOw9brcTuD0+ZRu9D+0PbTlmURbp30LIK206egp6JgMTr9Bms+ytYEI1xoxU0heEnefpgb4pm84/0ZqllQJ/DjdFHJyr2h2wwvCjYuHElY94r7kX+PmxCGyaNk3PfIyotIeqA23o/xWsV5qyZtERgJE+vBqSrAelwXyQHt3aNjjMyqVKr7SPEnmpIZseIn8FwA/feQkb3CDtLnZv4BtwVDJAtkEEt+uF/XFftMQNDWKWQGe0LN9nNy/WU3PN8LqtJ8Xj05mszZq44izN5mfCJF/Iirc/JNXEpvvq1/tlKupJ+r+x3LjsjHRcea10EPGxBtsVhHmchbANoG2jeUqLgEktBwQpnXqBgsXHW401Biw56ce9vCF+n8jrT+5FsJ3SO2gvu1Z/jobERVq93vGnMB2a5A09/Fk8zUvl2CdhJBc3SwfKKYj74xUify7V2bvBvenTk6i3EzkOB2l+PASjiCM+hnwF0FAGylFPayYkPN0HP6V8Lfvxk0RaEk6cC7Le/JPdgoCdtxy+ytkGNL7VRCWurv9i4PU9ED4pBzfIryvqtz005s9OhWatR8TzqAyS89T87s4j8ch+Vtm/kzas63wDd4MEMXzj91DrV/6OmKrgGX7kYWYzXpHzdnjN9N8YuziiZLfXl4KzGquBwmynqamA8jKPJFjAUQcjEzW+R02Ycr6f1MwCPTyFZ5xTb6w8iHnHa8Jks5XfcOrPY6iy7qjr68I30HYUBC/rPxUdjmk3p8uQzpYw16E3hNBnxrbtC0x0cI/hoWWtAqIEplPxD6Lf2Xc8
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(346002)(136003)(39860400002)(451199021)(46966006)(36840700001)(40470700004)(70586007)(70206006)(4326008)(316002)(36756003)(5660300002)(30864003)(8676002)(8936002)(40460700003)(2876002)(41300700001)(2906002)(40480700001)(7696005)(47076005)(110136005)(54906003)(86362001)(478600001)(82310400005)(1076003)(26005)(186003)(966005)(36860700001)(336012)(356005)(82740400003)(7636003)(426003)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2023 03:07:32.6730
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 048d42cf-e01a-45a2-a42a-08db72cdd283
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB9018
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
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

Applied and tested over v6.4-rc6.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
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

 MAINTAINERS                        |   6 +
 drivers/vfio/pci/Kconfig           |   2 +
 drivers/vfio/pci/Makefile          |   2 +
 drivers/vfio/pci/hisilicon/Kconfig |   2 +-
 drivers/vfio/pci/mlx5/Kconfig      |   2 +-
 drivers/vfio/pci/nvgpu/Kconfig     |  10 +
 drivers/vfio/pci/nvgpu/Makefile    |   3 +
 drivers/vfio/pci/nvgpu/main.c      | 311 +++++++++++++++++++++++++++++
 8 files changed, 336 insertions(+), 2 deletions(-)
 create mode 100644 drivers/vfio/pci/nvgpu/Kconfig
 create mode 100644 drivers/vfio/pci/nvgpu/Makefile
 create mode 100644 drivers/vfio/pci/nvgpu/main.c

diff --git a/MAINTAINERS b/MAINTAINERS
index f794002a192e..f3b3115fdfed 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22169,6 +22169,12 @@ L:	kvm@vger.kernel.org
 S:	Maintained
 F:	drivers/vfio/platform/
 
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
diff --git a/drivers/vfio/pci/hisilicon/Kconfig b/drivers/vfio/pci/hisilicon/Kconfig
index 5daa0f45d2f9..38e90e05d68a 100644
--- a/drivers/vfio/pci/hisilicon/Kconfig
+++ b/drivers/vfio/pci/hisilicon/Kconfig
@@ -2,12 +2,12 @@
 config HISI_ACC_VFIO_PCI
 	tristate "VFIO PCI support for HiSilicon ACC devices"
 	depends on ARM64 || (COMPILE_TEST && 64BIT)
-	depends on VFIO_PCI_CORE
 	depends on PCI_MSI
 	depends on CRYPTO_DEV_HISI_QM
 	depends on CRYPTO_DEV_HISI_HPRE
 	depends on CRYPTO_DEV_HISI_SEC2
 	depends on CRYPTO_DEV_HISI_ZIP
+	select VFIO_PCI_CORE
 	help
 	  This provides generic PCI support for HiSilicon ACC devices
 	  using the VFIO framework.
diff --git a/drivers/vfio/pci/mlx5/Kconfig b/drivers/vfio/pci/mlx5/Kconfig
index 29ba9c504a75..7088edc4fb28 100644
--- a/drivers/vfio/pci/mlx5/Kconfig
+++ b/drivers/vfio/pci/mlx5/Kconfig
@@ -2,7 +2,7 @@
 config MLX5_VFIO_PCI
 	tristate "VFIO support for MLX5 PCI devices"
 	depends on MLX5_CORE
-	depends on VFIO_PCI_CORE
+	select VFIO_PCI_CORE
 	help
 	  This provides migration support for MLX5 devices using the VFIO
 	  framework.
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
index 000000000000..ff68d0c5f865
--- /dev/null
+++ b/drivers/vfio/pci/nvgpu/main.c
@@ -0,0 +1,311 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved
+ */
+
+#include <linux/pci.h>
+#include <linux/vfio_pci_core.h>
+#include <linux/vfio.h>
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
+	return 0;
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
+			uint32_t size;
+			struct vfio_region_info_cap_sparse_mmap *sparse;
+			struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
+
+			size = sizeof(struct vfio_region_info_cap_sparse_mmap) +
+				(sizeof(struct vfio_region_sparse_mmap_area));
+
+			/*
+			 * Setup for sparse mapping for the device memory. Only the
+			 * available device memory on the hardware is shown as a
+			 * mappable region.
+			 */
+			sparse = kmalloc(size, GFP_KERNEL);
+			if (sparse == NULL)
+				return -ENOMEM;
+
+			sparse->nr_areas = 1;
+			sparse->areas[0].offset = 0;
+			sparse->areas[0].size = nvdev->mem_prop.mem_length;
+			sparse->header.id = VFIO_REGION_INFO_CAP_SPARSE_MMAP;
+			sparse->header.version = 1;
+
+			vfio_info_add_capability(&caps, &sparse->header, size);
+
+			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+			/*
+			 * The available GPU memory size may not be power-of-2 aligned.
+			 * Given that the memory is exposed as a BAR and may not be
+			 * aligned, roundup to the next power-of-2.
+			 */
+			info.size = is_power_of_2(nvdev->mem_prop.mem_length) ?
+				nvdev->mem_prop.mem_length :
+				roundup_pow_of_two(nvdev->mem_prop.mem_length);
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
+						return -EFAULT;
+					}
+					info.cap_offset = sizeof(info);
+				}
+				kfree(caps.buf);
+			}
+
+			return copy_to_user((void __user *)arg, &info, minsz) ?
+				       -EFAULT : 0;
+		}
+	}
+
+	return vfio_pci_core_ioctl(core_vdev, cmd, arg);
+}
+
+static ssize_t nvgpu_vfio_pci_read(struct vfio_device *core_vdev,
+		char __user *buf, size_t count, loff_t *ppos)
+{
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+
+	/*
+	 * Only the device memory present on the hardware is mapped, which may
+	 * not be power-of-2 aligned. A read to the BAR2 region implies an
+	 * access outside the available device memory on the hardware.
+	 */
+	if (index == VFIO_PCI_BAR2_REGION_INDEX)
+		return -EINVAL;
+
+	return vfio_pci_core_read(core_vdev, buf, count, ppos);
+
+}
+
+static ssize_t nvgpu_vfio_pci_write(struct vfio_device *core_vdev,
+		const char __user *buf, size_t count, loff_t *ppos)
+{
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+
+	/*
+	 * Only the device memory present on the hardware is mapped, which may
+	 * not be power-of-2 aligned. A write to the BAR2 region implies an
+	 * access outside the available device memory on the hardware.
+	 */
+	if (index == VFIO_PCI_BAR2_REGION_INDEX)
+		return -EINVAL;
+
+	return vfio_pci_core_write(core_vdev, buf, count, ppos);
+}
+
+static const struct vfio_device_ops nvgpu_vfio_pci_ops = {
+	.name = "nvgpu-vfio-pci",
+	.init = vfio_pci_core_init_dev,
+	.release = vfio_pci_core_release_dev,
+	.open_device = nvgpu_vfio_pci_open_device,
+	.close_device = vfio_pci_core_close_device,
+	.ioctl = nvgpu_vfio_pci_ioctl,
+	.read = nvgpu_vfio_pci_read,
+	.write = nvgpu_vfio_pci_write,
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

