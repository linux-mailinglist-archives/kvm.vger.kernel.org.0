Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9D572357F
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 04:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233821AbjFFCxm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 22:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbjFFCxl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 22:53:41 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2040.outbound.protection.outlook.com [40.107.223.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C36ACD;
        Mon,  5 Jun 2023 19:53:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eBkbXz/jUmGJJ1OSgj89Wh4Q0OSUpYWHz5AE8j8txNwbPhvo0Iu1oQN2Iy8VAnFArN7+mUh1Ns0FxyIEINbeJBU89LWccDqlb5xxJxKDV93VSwPgf660zQRVOVWPxI0Ro8QuUr3sp4hdCPCHzq0azvLsogZrNs1ONbzUmALSKIiNzkNy0xiN7QlhfNCxGXwMrguhkDw84ycF6Ywur/oGtustknPc4PA44Ibk+UfC3wMcKCBNxlzYfVzi4UqeeSDVShejAdfY9SsTkEIRCyyzFq4e8lbfA8R+p7yKMqVXEYJEt4Kn8CAPXf6vjasyTAMNQeGawOHFPzD8iuhpix0knw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QbTmS6TiXmyO3sXSxUe3c7s9ZFxqIe0h2GCp93vPC7k=;
 b=VJJFksILzvFj3lsNJG8buEngZG+XbyFNEUW/qE58Gzkof4yypnSeoA4hL4s5SkujF1v9MTDn00ORja2198BWLWik+8Ani3FIuxXPqhwNYbJvtTKMfyOQmWB6tgbvD5CyzFwxMVZIucc5n1XcQ9Gu6rAw8+4siZmYmQsJGh5fdWcP4b3TuVWbBR5S/moT3nzXz+X+U+iTaUo44LP+VABI36sLhCDkcQBTYNGJCm8XkzsdZLyMwuziDu9XUle9k0gtxqyN51LTwUMzRgq0PA8IM6v0o1RvWurATLBNDJWZL6n+nmY+Lg/0PFHW9W0pJgvaFP4Jz8+aJ4wpOpGKlz7qPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QbTmS6TiXmyO3sXSxUe3c7s9ZFxqIe0h2GCp93vPC7k=;
 b=Wd1ZYO0dFsXHTYLpRmnNbQF5I6s+L8z5crDCXLrreHsaN52dq/6/e4fhrKUdxZobJ5wKzv7jBZlNBc3eZ9qcPnSPVfz1xroUL4eEYahjLTe9nuv5H5J5up/WzimHcAwwcYsf2WsZIOFTXvWR5e2gBhvllt0bgiNP4xqjlDTeTC8XvFl1TYGc0kRc0UZe3ucNQ1/GXH16HN8lHzZF+0cjKXET2dK5iywwQV6C9q9a6jafGS3+3x6D5jQp6P8YkgKt8hov9AqmNq3E1OghPovmxWL0HQQbQtwvH+5/WCqyakm6bX8aOmC55RrmwnY3s0qd3Af8tgbhNLRjVavCzmsTuA==
Received: from MW4PR03CA0337.namprd03.prod.outlook.com (2603:10b6:303:dc::12)
 by CH2PR12MB4875.namprd12.prod.outlook.com (2603:10b6:610:35::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 02:53:36 +0000
Received: from CO1NAM11FT115.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dc:cafe::e5) by MW4PR03CA0337.outlook.office365.com
 (2603:10b6:303:dc::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33 via Frontend
 Transport; Tue, 6 Jun 2023 02:53:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT115.mail.protection.outlook.com (10.13.174.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.33 via Frontend Transport; Tue, 6 Jun 2023 02:53:35 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 5 Jun 2023
 19:53:21 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 5 Jun 2023
 19:53:20 -0700
Received: from ankita-dt2.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37 via Frontend
 Transport; Mon, 5 Jun 2023 19:53:20 -0700
From:   <ankita@nvidia.com>
To:     <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>
CC:     <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
        <targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
        <apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 1/1] vfio/nvgpu: Add vfio pci variant module for grace hopper
Date:   Mon, 5 Jun 2023 19:53:20 -0700
Message-ID: <20230606025320.22647-1-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT115:EE_|CH2PR12MB4875:EE_
X-MS-Office365-Filtering-Correlation-Id: 14cf7389-e44b-4a63-9553-08db66393919
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: evWzPc5XOggE+vUq0CiJRf1jvKVUBrg0q0RRkicDBbWbknzBEKY7d1VGzitf3ZlfFUXKFXgah3821HQGTEJAEXy4+4c3tISn0p/qg1T1lwcw7KWPWT3CRqtl5wcRIEiQbr1faNDsuqc6yI3wj0fNihMYA0sEVYcWmAAQ29MKvX80+tmTZNuOV1bQ2MDwPuYljle2PXHAfBoy8p0o7eCDYw48XCZVAiX3IGxvWyPw95VW9Ut9c34n4QreOzc6qoU452j+M7TWFU40IlhJ7lBn5Mh+hTWAKtaHGryj4camfIhJ220Ov9GjPRrT/rywhhdRp/RX+XwaGp25VmwtDPWMdYob2x4CUuheIympHSsMSkyfumAVNJ9uB7YAXRytsvETmi/HZhIO20mYHBY5uki9Ol1Yiw5CGyvL6odooO4E0XgM60edIOMpPQPv9CpednWQuDCBaw+JyZeouMUMPXM9Y/JPxeSn+kkS3aTB229wEksdIdQjahi6KWrS4hH6a+KGGh8KEoPU/lBq4s6d8WPdmdCoWLiOnwaXBiRumA0CGQDPZ8MlJHogTDTp3Sm1wL25jZca3kmJLr8iRPNcZGkaNNNI7hepyiAHa4uqXvdb7qkMBUHT1MV/KMq5Tkn7X88JxqsW6Qs+pc31vrBfRRyRhk5kxrVVP6etZPDW/jG5R75UFLEG2aXZJTcN51pIMLI2L6sn+BvFzKxTuFqfWBJY7Bt46cqzMY8hBaGAgBUkcElaUIGzXolKlvvPCeHj3/H9Bvk8pHICH1fM+fUb3nUAOqYlPB3guZicvz8QdAuNyyo=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(346002)(396003)(136003)(451199021)(46966006)(36840700001)(40470700004)(1076003)(2616005)(41300700001)(336012)(426003)(7696005)(47076005)(26005)(36860700001)(186003)(83380400001)(966005)(40460700003)(478600001)(40480700001)(110136005)(54906003)(4326008)(82310400005)(70586007)(7636003)(356005)(316002)(82740400003)(70206006)(8676002)(5660300002)(8936002)(2906002)(30864003)(86362001)(2876002)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 02:53:35.9266
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 14cf7389-e44b-4a63-9553-08db66393919
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT115.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4875
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
next power-of-2 aligned PA thus is mapped to a dummy PFN through
vm_operations fault.

This goes along with a qemu series to provides the necessary
implementation of the Grace Hopper Superchip firmware specification so
that the guest operating system can see the correct ACPI modeling for
the coherent GPU device.
https://www.mail-archive.com/qemu-devel@nongnu.org/msg967557.html

This patch is split from a patch series being pursued separately:
https://lore.kernel.org/lkml/20230405180134.16932-1-ankita@nvidia.com/

Applied and tested over v6.4-rc4.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---

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
 drivers/vfio/pci/nvgpu/Kconfig     |  10 ++
 drivers/vfio/pci/nvgpu/Makefile    |   3 +
 drivers/vfio/pci/nvgpu/main.c      | 257 +++++++++++++++++++++++++++++
 8 files changed, 282 insertions(+), 2 deletions(-)
 create mode 100644 drivers/vfio/pci/nvgpu/Kconfig
 create mode 100644 drivers/vfio/pci/nvgpu/Makefile
 create mode 100644 drivers/vfio/pci/nvgpu/main.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 250518fc70ff..51e364b8f00b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22150,6 +22150,12 @@ L:	kvm@vger.kernel.org
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
index 000000000000..9a838fe52a78
--- /dev/null
+++ b/drivers/vfio/pci/nvgpu/main.c
@@ -0,0 +1,257 @@
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
+};
+
+struct nvgpu_vfio_pci_core_device {
+	struct vfio_pci_core_device core_device;
+	struct dev_mem_properties mem_prop;
+};
+
+static vm_fault_t nvgpu_vfio_pci_fault(struct vm_fault *vmf)
+{
+	unsigned long mem_offset = vmf->pgoff - vmf->vma->vm_pgoff;
+	struct nvgpu_vfio_pci_core_device *nvdev = container_of(
+		vmf->vma->vm_file->private_data,
+		struct nvgpu_vfio_pci_core_device, core_device.vdev);
+	int ret;
+
+	/*
+	 * We come here only if the access is to a memory region that is
+	 * beyond physical GPU memory. Map such request to a dummy PFN.
+	 */
+	ret = remap_pfn_range(vmf->vma,
+			vmf->vma->vm_start + (mem_offset << PAGE_SHIFT),
+			DUMMY_PFN, PAGE_SIZE,
+			vmf->vma->vm_page_prot);
+	if (ret)
+		return VM_FAULT_ERROR;
+
+	return VM_FAULT_NOPAGE;
+}
+
+static const struct vm_operations_struct nvgpu_vfio_pci_mmap_ops = {
+	.fault = nvgpu_vfio_pci_fault,
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
+	 * be handled by the VMA ops fault through mapping to a dummy PFN.
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
+	vma->vm_ops = &nvgpu_vfio_pci_mmap_ops;
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

