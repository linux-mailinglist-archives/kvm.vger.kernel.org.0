Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8FB6D8584
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 20:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232099AbjDESCo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 14:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbjDESCm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 14:02:42 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2086.outbound.protection.outlook.com [40.107.244.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8043E72BC;
        Wed,  5 Apr 2023 11:02:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VLTu+o0ehF/5rWCm6ZElBfQHG27Lbl3t2cb3Gwft/z3v7C8YLBWMwZkdPXZJRah3w1qVkk0F3gNErZW5QnPy7Ig/SMqqui/OCu7AdUUnLJivd6w6p9NKH/3ti53BEt4bUhFGlVcy+Rt0zwt5SdZWhrzRYZi0p4VXYwU4unHZ6gQ5JPtWcNQET3QAH+o5kHQP+Q5kStGFCPEPetTLCXVppPU4EPlHHLk6U9TcOA0G15OWPFgWK3iLlKwIdv8JcZQ89ELuHA4pGqg7BHigodQ78oTIbybeiyYZR5GPLyoLcbIc0JZ0mr0Yq5kU+LDt/F+haOlX3LUpY1GuK5Pta2cHCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1rpV84bedB/SLY9kiz3nuV5S5K+BBy2AxYHvceEx63c=;
 b=WkzRXFzuyW2JOCeD9lmFg228tlh3g0mJmz8FFAV3E4WtYpoPAoSBHLO2QW3b8djsHQ0By44hda33MNWVa4Qpx5tHfaNky3ecX4Xepq8XuZ8YqOjvcnmLFIRjRZeZ+JEd7J4lPOSHsAfZGyawePNhJhQ4vx86MdrOkrxxyM11StPMruzxBeocszp0LpA9uzfwCiHvVmncfDGKakCd6CkL0nkcCT93/P0qnxLE4yfxes18kdLlCkpr+owSXuSePgqfhIlT/yJwxFR1Tt/n3XzXJXWAI6FCOP1tHq4W7Cb5RhRcOJw7lkB7W1kqH5LzXqd65z0/WArrV4OwkTRIuCvM/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1rpV84bedB/SLY9kiz3nuV5S5K+BBy2AxYHvceEx63c=;
 b=WHK1HL9pCY9VSpgicLim/6WWnpBhG1Zyh6ZpOCD32ld8EXgqG51l0Xv5hwH9m5MGyfUqSGEC4a7BDrfEEF0dKXrQJeCz7uf24MhaLpJX8aZWdEOKaAn7Meg+ETURFL8YWK2z/yvNtQ+7EqbvrJilw33CPp28L0JHOKfk46WK++cAFnzVJ3yA8JDFkSi94zy+kAgo6eS6rASMbmcBHLWQX7NocWAJveH8RRDcPI26hJiJYNU1JzL+Q04bLhLIc5RtWNrmUAN8UVi8PSgMSgotAa51RIx6RTsmiPu6y3oqlCQSPpfKl604u59Bg8VK56VVlcEVREMyCSZ54keDZXyRXQ==
Received: from DM6PR17CA0023.namprd17.prod.outlook.com (2603:10b6:5:1b3::36)
 by MN0PR12MB5929.namprd12.prod.outlook.com (2603:10b6:208:37c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 18:02:10 +0000
Received: from DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b3:cafe::33) by DM6PR17CA0023.outlook.office365.com
 (2603:10b6:5:1b3::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22 via Frontend
 Transport; Wed, 5 Apr 2023 18:02:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM6NAM11FT049.mail.protection.outlook.com (10.13.172.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6277.28 via Frontend Transport; Wed, 5 Apr 2023 18:02:09 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 5 Apr 2023
 11:01:35 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Wed, 5 Apr 2023 11:01:35 -0700
Received: from localhost.localdomain (10.127.8.14) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37 via Frontend
 Transport; Wed, 5 Apr 2023 11:01:35 -0700
From:   <ankita@nvidia.com>
To:     <ankita@nvidia.com>, <jgg@nvidia.com>,
        <alex.williamson@redhat.com>, <naoya.horiguchi@nec.com>,
        <maz@kernel.org>, <oliver.upton@linux.dev>
CC:     <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
        <targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
        <apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>
Subject: [PATCH v3 2/6] vfio/nvgpu: expose GPU device memory as BAR1
Date:   Wed, 5 Apr 2023 11:01:30 -0700
Message-ID: <20230405180134.16932-3-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230405180134.16932-1-ankita@nvidia.com>
References: <20230405180134.16932-1-ankita@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT049:EE_|MN0PR12MB5929:EE_
X-MS-Office365-Filtering-Correlation-Id: 68feaf94-b7bb-431a-26b2-08db35ffe060
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 31IPSctlLXlk6/oJbDUTpNFrgGkYnQxIic6BXdjpLqKLO9VAwFMlgIXY4rnzaaxRUdSLlMxVRph0SbLz2mXRKdH3GfcykEcR3tJB8X3NN4BJ0pialKYPyHqSoWdI5erIWM6wyWCEgQD1zpCc3Vz7HkmBb0/392brL/dGt7sKZty0N+9V9nZmYqDAQGL+touu8Gmiu1/etdwVM7RV/8nkyT+f7C3c6+tMyjrJBpXwSKVHi5gcLMFAzksjxiASg6drNndgXw1NAfLC81fbdkiovQkCMnNycCc8ohaxg69DVKZL2NkKFJFZavZJ/OnB0MY/1v8n6QUJCRySbeiCCu/uAhTAJ5DX27xiext5p8dfBU2u6jIfqVyQfa4u608LQJmpnrN2WwOzbnBCYzjJRS86o22RBSFBGr6xD8ZJHuNhiTn53sayJo3dUXyjU68XHzYXEyRC1AucKdG1YRoZaJcsw54ZfaNfa0/NrjLwSeTEGaxwckbUyNLo7QdtFB0wJ2e/ttCuCIW6XkzyafHQuh4U9i/lPAMBoWArWGRmFZ91rS1eyMtV2Ewejgsz/A360xr3bvUZwgEyq43GPKuIF7tSA0evecBsm9xraa6iow8nrguBGGQU0dK5Ih4LPlQu8rZGWozSjiVTnIKwRphtwpwYZxpVmgSZbfEcnyQqlAj9GvSTDAwnwWOsgnpeILX9KtVDM3ohyFlSYMZFA+/pQsNJOlMu+xBui7hruxQ2B9L8j0iTlVezL4xDoLl0iHqy8ttz
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(396003)(376002)(39860400002)(451199021)(36840700001)(46966006)(40470700004)(40480700001)(186003)(6666004)(82310400005)(26005)(8936002)(336012)(5660300002)(2906002)(86362001)(2876002)(30864003)(36860700001)(316002)(4326008)(70586007)(47076005)(1076003)(83380400001)(426003)(70206006)(41300700001)(356005)(82740400003)(110136005)(40460700003)(2616005)(8676002)(54906003)(36756003)(7636003)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 18:02:09.8981
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 68feaf94-b7bb-431a-26b2-08db35ffe060
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5929
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ankit Agrawal <ankita@nvidia.com>

The NVIDIA Grace Hopper superchip does not model the coherent GPU memory
aperture as a PCI config space BAR.

Introduce an in-tree VFIO PCI variant module (nvgpu-vfio-pci) to expose
the GPU memory as BAR1 to the userspace. The GPU memory size and physical
address are obtained from ACPI using device_property_read_u64() and
exported to userspace as the VFIO_REGION. QEMU will naturally generate a
PCI device in the VM where the cachable aperture is reported in BAR1.

QEMU can fetch the region information and perform mapping on it. The
subsequent mmap call is handled by mmap() function pointer for the
nvgpu-vfio-pci module and mapping to the GPU memory is established
using the remap_pfn_range() API.

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
index 000000000000..2dd8cc6e0145
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
+int nvgpu_vfio_pci_mmap(struct vfio_device *core_vdev,
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
+long nvgpu_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
+			  unsigned long arg)
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

