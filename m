Return-Path: <kvm+bounces-4228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 081C280F5A6
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 19:47:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 89666B20F13
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 18:46:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C9557F54E;
	Tue, 12 Dec 2023 18:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pyhu/570"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2088.outbound.protection.outlook.com [40.107.237.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9811ECE;
	Tue, 12 Dec 2023 10:46:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GdwKY5y4cQYot3vZRPWGU4oNlub/oblsE6B6uNavLkjZLlv3mlG8WAdZHWLX6S1qsk4EvXbSopbpygdi1zxHkav+VkO400dnVGN83NbCTACNxckYgplIMx+dXgDYHB/qk3tgMcBj4fdt53g1WCuINocCQmrHIyMiNKyKr1DiCdM67xdcmDpQ2tUcnye6mBFiKHJpREq9ds9hobyWH2VBAlxY3n+bJ1NTNR/M9q6RXQtJ1J87F2eIThBhI0H9tsMbSeNNRy2XRdxbvDYc0Oz4O+H8nr03M6v3R9c9JAHz2DH7tOZM0LKsmI4WrQUS3k/RssGNb/8PIxxwwZHv5DsiXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fp7nnc1budNk09/y6/Dff32+1IyDhfunldWKs0GDtSw=;
 b=G0kpA2cGY4yjvJopmyirpXa81GIHmdRZsE77agBuay8A7px93okLm9CcooToYhiyVQsXRRcrIGgzms2z6ul1Pn411a82ho4RpUad0zbqGk16mi12NG3r5DM4zkNjtn9HbUG0IkUYA+I+mxSl8AXG/ViwqN0KOj7Oo/TvC3F7t6nTaDhbHc6RmEPTZueA8jfM6SFv5CWWyHQppaC57ZQS1SboK7y5viDzB0YwCkjVL5GsD5WRMseZXACIQm+MERbAju/rkrR6hkQUuw/kgObHemiLHcWaH4ug4rfXBWFNUqUm4JG6mEqwFSV5MUuedmnhSrG9DvetKzBFt2/ys7o52g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fp7nnc1budNk09/y6/Dff32+1IyDhfunldWKs0GDtSw=;
 b=pyhu/570nUN6vjRncs0P3nwBeI+J6jmLPHlR61GmgWpiEgxl3/roZQyWrSMPBNLSINH/Ht2YaStG7Y21bUOHMD4HrUGmtrCFt8lSnJz2jNxEiLrXWXGWuqPVTqywTnfkiRlaDnLMQ+Q5px+o0pf2lZ7YelfgB78zxzI7XDUIsW6d8as6uZ9g0IxJXceKnq6chzufmv/Jnzweyz718MLl1onyE58P6OqtYGp8kg79KjHK9li9n79HsLdX6R9F4pKmGnM3H/D4bdgLWxnOHKv/DvtjsxptqQVxhJtCsa/7F1jqcj4tPkohYItsNRujv6ngZrqS8KFgMOFKE2rTAm479g==
Received: from MW4PR04CA0288.namprd04.prod.outlook.com (2603:10b6:303:89::23)
 by MW4PR12MB6852.namprd12.prod.outlook.com (2603:10b6:303:20b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.33; Tue, 12 Dec
 2023 18:46:38 +0000
Received: from CO1PEPF000044F2.namprd05.prod.outlook.com
 (2603:10b6:303:89:cafe::5c) by MW4PR04CA0288.outlook.office365.com
 (2603:10b6:303:89::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.26 via Frontend
 Transport; Tue, 12 Dec 2023 18:46:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000044F2.mail.protection.outlook.com (10.167.241.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7091.26 via Frontend Transport; Tue, 12 Dec 2023 18:46:38 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 12 Dec
 2023 10:46:22 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 12 Dec
 2023 10:46:21 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41 via Frontend
 Transport; Tue, 12 Dec 2023 10:46:16 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>, <eric.auger@redhat.com>, <brett.creeley@amd.com>,
	<horms@kernel.org>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v14 1/1] vfio/nvgrace-gpu: Add vfio pci variant module for grace hopper
Date: Wed, 13 Dec 2023 00:16:13 +0530
Message-ID: <20231212184613.3237-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F2:EE_|MW4PR12MB6852:EE_
X-MS-Office365-Filtering-Correlation-Id: 04b96e9e-6c8e-4158-d20c-08dbfb42ac67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	1oNgTOU50e+qV4SDbLQC50a9pB605pm1p5B5QhPwA3bMfUOISeM2bDFPgPicG2FKncArvkTPXMGC+VbVFJn0mmXHdoksgYRYjfFL7AzD+iFxlnrr4Kc5+sdIobOt/FNXYI9PmsVhg8ZADgO4mbqrwMBA6+ZJBwdQX5Xra4TyPeIrquPHbXdpW6OmL3PxyEeNofMYUP2F/ojihsEyl6rcsi4+4RVaAp9L1JFrOdXluV5aoUdwRQZsOU3Z1QVvKBqri8LlkWY4dm2of0mJwa44BjDhWcu+Uv/EqKAiIibP8Oyq5fyxs9L9n9itIGFBg8aCTicVFso2Re67/0A5J1PqFZjsCrWbWm3gvMfvGnHWX5AU6uk8TcK57tU+QZHLP4kNxzQQCuuZ/kVp9gsoe431F8XGAKc8rfS5/PKxaJlMnnXfJ28v1rOQIj5ezzttld/XKJ0pTS7W2lSRPQjf/yOc6VBVsHspfWiKRC34k49Ert9M8klT69WlhFOaFbDsKZKV7oMOS260ypn5OR5YB+nQZULVed1OJJ9/1z6QpOBDJv4RIUDAS4ZHql7TlSRJLLgMDPU7y3GAxDy8c/XdezLq1cYtClkA4GSKfO3Zaa26khyMUBg7s4tSC4cPizwEg3NtfQLG55NoR1MkwmCyBeerl3iH+WT1MwnYVUgjbW1Hlc/XzQSALEtkgrYJ/RXEIVc80F2bYfomxMVdzD7o/NCZrajBuW2QY5NRQDgzjWrDUx7GpdCgkOOqZB2em3VQhX4ldPhKxVEutQlUeIEHSy38J+QfoVpwHlTwI6IvPN5kUleHW0PK4/cGqc3dw8ft4mdw
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(376002)(346002)(396003)(136003)(230922051799003)(1800799012)(451199024)(82310400011)(186009)(64100799003)(36840700001)(40470700004)(46966006)(41300700001)(30864003)(5660300002)(2876002)(2906002)(1076003)(2616005)(6666004)(36756003)(966005)(478600001)(7696005)(36860700001)(47076005)(82740400003)(426003)(26005)(336012)(83380400001)(84970400001)(40480700001)(356005)(8936002)(7636003)(86362001)(4326008)(40460700003)(54906003)(316002)(110136005)(8676002)(70586007)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2023 18:46:38.0549
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 04b96e9e-6c8e-4158-d20c-08dbfb42ac67
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6852

From: Ankit Agrawal <ankita@nvidia.com>

NVIDIA's upcoming Grace Hopper Superchip provides a PCI-like device
for the on-chip GPU that is the logical OS representation of the
internal proprietary chip-to-chip cache coherent interconnect.

The device is peculiar compared to a real PCI device in that whilst
there is a real 64b PCI BAR1 (comprising region 2 & region 3) on the
device, it is not used to access device memory once the faster
chip-to-chip interconnect is initialized (occurs at the time of host
system boot). The device memory is accessed instead using the chip-to-chip
interconnect that is exposed as a contiguous physically addressable
region on the host. This device memory aperture can be obtained from host
ACPI table using device_property_read_u64(), according to the FW
specification. Since the device memory is cache coherent with the CPU,
it can be mmap into the user VMA with a cacheable mapping using
remap_pfn_range() and used like a regular RAM. The device memory
is not added to the host kernel, but mapped directly as this reduces
memory wastage due to struct pages.

There is also a requirement of a reserved 1G uncached region (termed as
resmem) to support the Multi-Instance GPU (MIG) feature [1]. Based on [2],
the requisite properties (uncached, unaligned access) can be achieved
through a VM mapping (S1) of NORMAL_NC and host (S2) mapping with
MemAttr[2:0]=0b101. To provide a different non-cached property to the
reserved 1G region, it needs to be carved out from the device memory and
mapped as a separate region in Qemu VMA with pgprot_writecombine().
pgprot_writecombine() sets the Qemu VMA page properties (pgprot) as
NORMAL_NC.

Provide a VFIO PCI variant driver that adapts the unique device memory
representation into a more standard PCI representation facing userspace.

The variant driver exposes these two regions - the non-cached reserved
(resmem) and the cached rest of the device memory (termed as usemem) as
separate VFIO 64b BAR regions. Since the device implements 64-bit BAR0,
the VFIO PCI variant driver maps the cached device memory aperture to
the next available PCI BAR (i.e. comprising of region 2 and 3). The
uncached carved out region is assigned BAR region 4 and 5. Qemu will
then naturally generate a PCI device in the VM with the cacheable aperture
reported as BAR2 region, the uncached as BAR4. The variant driver also
provides emulation for these fake BARs' PCI config space offset registers.

The memory layout on the host looks like the following:
               devmem (memlength)
|--------------------------------------------------|
|-------------cached------------------------|--NC--|
|                                           |
usemem.phys/memphys                         resmem.phys

PCI BARs need to be aligned to the power-of-2, but the actual memory on the
device may not. A read or write access to the physical address from the
last device PFN up to the next power-of-2 aligned physical address
results in reading ~0 and dropped writes. Note that the GPU device
driver [6] is capable of knowing the exact device memory size through
separate means. The device memory size is primarily kept in the system
ACPI tables for use by the VFIO PCI variant module.

Note that the usemem memory is added by the VM Nvidia device driver [5]
to the VM kernel as memblocks. Hence make the usable memory size memblock
aligned.

Currently there is no provision in KVM for a S2 mapping with
MemAttr[2:0]=0b101, but there is an ongoing effort to provide the same [3].
As previously mentioned, resmem is mapped pgprot_writecombine(), that
sets the Qemu VMA page properties (pgprot) as NORMAL_NC. Using the
proposed changes in [4] and [3], KVM marks the region with
MemAttr[2:0]=0b101 in S2.

This goes along with a qemu series [6] to provides the necessary
implementation of the Grace Hopper Superchip firmware specification so
that the guest operating system can see the correct ACPI modeling for
the coherent GPU device. Verified with the CUDA workload in the VM.

[1] https://www.nvidia.com/en-in/technologies/multi-instance-gpu/
[2] section D8.5.5 of https://developer.arm.com/documentation/ddi0487/latest/
[3] https://lore.kernel.org/all/20231205033015.10044-1-ankita@nvidia.com/
[4] https://lore.kernel.org/all/20230907181459.18145-2-ankita@nvidia.com/
[5] https://github.com/NVIDIA/open-gpu-kernel-modules
[6] https://lore.kernel.org/all/20231203060245.31593-1-ankita@nvidia.com/

Applied over next-20231211.
---
Link for variant driver v13:
https://lore.kernel.org/all/20231114081611.30550-1-ankita@nvidia.com/
Link for new carve-out region v1:
https://lore.kernel.org/all/20231115080751.4558-1-ankita@nvidia.com/

v13 -> v14
- Merged the changes for second BAR implementation for MIG support
  on the device driver.
  https://lore.kernel.org/all/20231115080751.4558-1-ankita@nvidia.com/
- Added the missing implementation of sub-word access to fake BARs'
  PCI config access. Implemented access algorithm suggested by
  Alex Williamson in the comments (Thanks!)
- Added support to BAR accesses on the reserved memory with
  Qemu device param x-no-mmap=on.
- Handled endian-ness in the PCI config space access.
- Git commit message change

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

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
Signed-off-by: Aniket Agashe <aniketa@nvidia.com>
Tested-by: Ankit Agrawal <ankita@nvidia.com>
---
 MAINTAINERS                           |   6 +
 drivers/vfio/pci/Kconfig              |   2 +
 drivers/vfio/pci/Makefile             |   2 +
 drivers/vfio/pci/nvgrace-gpu/Kconfig  |  10 +
 drivers/vfio/pci/nvgrace-gpu/Makefile |   3 +
 drivers/vfio/pci/nvgrace-gpu/main.c   | 947 ++++++++++++++++++++++++++
 6 files changed, 970 insertions(+)
 create mode 100644 drivers/vfio/pci/nvgrace-gpu/Kconfig
 create mode 100644 drivers/vfio/pci/nvgrace-gpu/Makefile
 create mode 100644 drivers/vfio/pci/nvgrace-gpu/main.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 98f7dd0499f1..6f8f3a6daa43 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22877,6 +22877,12 @@ L:	kvm@vger.kernel.org
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
index 000000000000..b86897da0ab0
--- /dev/null
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -0,0 +1,947 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. All rights reserved
+ */
+
+#include <linux/pci.h>
+#include <linux/vfio_pci_core.h>
+#include <linux/vfio.h>
+
+/* Memory size expected as non cached and reserved by the VM driver */
+#define RESMEM_SIZE 0x40000000
+#define MEMBLK_SIZE 0x20000000
+
+/*
+ * The device memory usable to the workloads running in the VM is cached
+ * and showcased as a 64b device BAR to the VM (represented as usemem).
+ * Moreover, the VM GPU device driver needs a non-cacheable region to
+ * support the MIG feature. This region is also exposed as a 64b BAR and
+ * represented as resmem.
+ *
+ * Each of these regions' state is saves as struct mem_region.
+ */
+struct mem_region {
+	phys_addr_t memphys; /* Base physical address of the region */
+	size_t memlength;    /* Region size */
+	union {
+		u32 u32_reg[2];
+		u64 u64_reg;
+	} bar_reg;           /* Emulated BAR offset registers */
+	union {
+		void *memaddr;
+		void __iomem *ioaddr;
+	} bar_remap;         /* Base virtual address of the region */
+};
+
+struct nvgrace_gpu_vfio_pci_core_device {
+	struct vfio_pci_core_device core_device;
+	/* Cached and usable memory for the VM. */
+	struct mem_region usemem;
+	/* Non cached memory carved out from the end of device memory */
+	struct mem_region resmem;
+	struct mutex remap_lock;
+};
+
+static bool nvgrace_gpu_vfio_pci_is_fake_bar(int index)
+{
+	if (index == VFIO_PCI_BAR2_REGION_INDEX ||
+	    index == VFIO_PCI_BAR4_REGION_INDEX)
+		return true;
+
+	return false;
+}
+
+static void nvgrace_gpu_init_fake_bar_emu_regs(struct vfio_device *core_vdev)
+{
+	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
+		core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
+		core_device.vdev);
+
+	nvdev->resmem.bar_reg.u64_reg = 0;
+	nvdev->usemem.bar_reg.u64_reg = 0;
+}
+
+/* Choose the structure corresponding to the BAR with index. */
+static int
+nvgrace_gpu_vfio_pci_get_mem_region(int index,
+			struct nvgrace_gpu_vfio_pci_core_device *nvdev,
+			struct mem_region *region)
+{
+	if (index == VFIO_PCI_BAR4_REGION_INDEX)
+		*region = nvdev->usemem;
+	else if (index == VFIO_PCI_BAR2_REGION_INDEX)
+		*region = nvdev->resmem;
+	else
+		return -EINVAL;
+
+	return 0;
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
+	nvgrace_gpu_init_fake_bar_emu_regs(core_vdev);
+
+	mutex_init(&nvdev->remap_lock);
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
+	/* Unmap the mapping to the device memory cached region */
+	if (nvdev->usemem.bar_remap.memaddr) {
+		memunmap(nvdev->usemem.bar_remap.memaddr);
+		nvdev->usemem.bar_remap.memaddr = NULL;
+	}
+
+	/* Unmap the mapping to the device memory non-cached region */
+	if (nvdev->resmem.bar_remap.ioaddr) {
+		iounmap(nvdev->resmem.bar_remap.ioaddr);
+		nvdev->resmem.bar_remap.ioaddr = NULL;
+	}
+
+	mutex_destroy(&nvdev->remap_lock);
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
+	struct mem_region memregion;
+
+	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
+
+	if (!nvgrace_gpu_vfio_pci_is_fake_bar(index))
+		return vfio_pci_core_mmap(core_vdev, vma);
+
+	ret = nvgrace_gpu_vfio_pci_get_mem_region(index, nvdev, &memregion);
+	if (ret)
+		return ret;
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
+		check_add_overflow(PHYS_PFN(memregion.memphys), pgoff, &start_pfn) ||
+		check_add_overflow(PFN_PHYS(pgoff), req_len, &end))
+		return -EOVERFLOW;
+
+	/*
+	 * Check that the mapping request does not go beyond available device
+	 * memory size
+	 */
+	if (end > memregion.memlength)
+		return -EINVAL;
+
+	/*
+	 * The carved out region of the device memory needs the NORMAL_NC
+	 * property. Communicate as such to the hypervisor.
+	 */
+	if (index == VFIO_PCI_BAR2_REGION_INDEX)
+		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
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
+	struct vfio_region_info_cap_sparse_mmap *sparse;
+	struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
+	struct vfio_region_info info;
+	struct mem_region memregion;
+	uint32_t size;
+	int ret;
+
+	if (copy_from_user(&info, (void __user *)arg, minsz))
+		return -EFAULT;
+
+	if (info.argsz < minsz)
+		return -EINVAL;
+
+	if (nvgrace_gpu_vfio_pci_is_fake_bar(info.index)) {
+		ret = nvgrace_gpu_vfio_pci_get_mem_region(info.index, nvdev, &memregion);
+		if (ret)
+			return ret;
+		/*
+		 * Request to determine the BAR region information. Send the
+		 * GPU memory information.
+		 */
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
+		sparse->areas[0].size = memregion.memlength;
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
+		 * The region memory size may not be power-of-2 aligned.
+		 * Given that the memory  as a BAR and may not be
+		 * aligned, roundup to the next power-of-2.
+		 */
+		info.size = roundup_pow_of_two(memregion.memlength);
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
+						 sizeof(info), caps.buf,
+						 caps.size)) {
+					kfree(caps.buf);
+					return -EFAULT;
+				}
+				info.cap_offset = sizeof(info);
+			}
+			kfree(caps.buf);
+		}
+		return copy_to_user((void __user *)arg, &info, minsz) ?
+				    -EFAULT : 0;
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
+		nvgrace_gpu_init_fake_bar_emu_regs(core_vdev);
+
+	return vfio_pci_core_ioctl(core_vdev, cmd, arg);
+}
+
+/*
+ * Check whether the given range of offset is within the expected
+ * boundary.
+ */
+static bool
+range_within_boundary(loff_t boundary_start, loff_t boundary_end,
+		       loff_t range_start, loff_t range_end)
+{
+	if (boundary_start <= range_start &&
+	    boundary_end >= range_end) {
+		return true;
+	}
+	return false;
+}
+
+/*
+ * Both the usable (usemem) and the reserved (resmem) device memory region
+ * are exposed as a 64b fake BARs in the VM. These fake BARs must respond
+ * to the accesses on their respective PCI config space offsets.
+ *
+ * resmem BAR owns PCI_BASE_ADDRESS_2 & PCI_BASE_ADDRESS_3.
+ * usemem BAR owns PCI_BASE_ADDRESS_4 & PCI_BASE_ADDRESS_5.
+ */
+
+/*
+ * Return the pointer to the desired location within the appropriate
+ * emulated register.
+ *
+ * First find the emulated register based on the accessed PCI config
+ * offset. Then traverse to the appropriate location within the
+ * register (applicable for sub-word size access).
+ */
+static u8 *
+register_ref(struct nvgrace_gpu_vfio_pci_core_device *nvdev, u64 start, u64 end)
+{
+	u8 *reg_ref = NULL;
+
+	if (range_within_boundary(PCI_BASE_ADDRESS_5,
+				PCI_CARDBUS_CIS, start, end)) {
+		reg_ref = (u8 *) &(nvdev->usemem.bar_reg.u32_reg[1]);
+		reg_ref += start - PCI_BASE_ADDRESS_5;
+	} else if (range_within_boundary(PCI_BASE_ADDRESS_4,
+				PCI_BASE_ADDRESS_5, start, end)) {
+		reg_ref = (u8 *) &(nvdev->usemem.bar_reg.u32_reg[0]);
+		reg_ref += start - PCI_BASE_ADDRESS_4;
+	} else if (range_within_boundary(PCI_BASE_ADDRESS_3,
+				PCI_BASE_ADDRESS_4, start, end)) {
+		reg_ref = (u8 *) &(nvdev->resmem.bar_reg.u32_reg[1]);
+		reg_ref += start - PCI_BASE_ADDRESS_3;
+	} else if (range_within_boundary(PCI_BASE_ADDRESS_2,
+				PCI_BASE_ADDRESS_3, start, end)) {
+		reg_ref = (u8 *) &(nvdev->resmem.bar_reg.u32_reg[0]);
+		reg_ref += start - PCI_BASE_ADDRESS_2;
+	}
+
+	return reg_ref;
+}
+
+static ssize_t
+nvgrace_gpu_read_config_emu(struct nvgrace_gpu_vfio_pci_core_device *nvdev,
+			     char __user *buf, size_t count, loff_t *ppos)
+{
+	u64 pos = *ppos & VFIO_PCI_OFFSET_MASK;
+	__le32 val32;
+	u8 *reg_ref;
+	u32 tmp_val;
+	size_t bar_size;
+
+	if (!IS_ALIGNED(pos, count))
+		return -EINVAL;
+
+	if (range_within_boundary(PCI_BASE_ADDRESS_2,
+				PCI_BASE_ADDRESS_4, pos, pos + count)) {
+		bar_size = roundup_pow_of_two(nvdev->resmem.memlength);
+		nvdev->resmem.bar_reg.u64_reg &= ~(bar_size - 1);
+		nvdev->resmem.bar_reg.u64_reg |= PCI_BASE_ADDRESS_MEM_TYPE_64 |
+						PCI_BASE_ADDRESS_MEM_PREFETCH;
+	} else {
+		bar_size = roundup_pow_of_two(nvdev->usemem.memlength);
+		nvdev->usemem.bar_reg.u64_reg &= ~(bar_size - 1);
+		nvdev->usemem.bar_reg.u64_reg |= PCI_BASE_ADDRESS_MEM_TYPE_64 |
+						PCI_BASE_ADDRESS_MEM_PREFETCH;
+	}
+
+	reg_ref = register_ref(nvdev, pos, pos + count);
+	if (!reg_ref)
+		return -EINVAL;
+
+	switch (count) {
+	case 1:
+		tmp_val = *reg_ref;
+		break;
+	case 2:
+		tmp_val = *((u16 *) reg_ref);
+		break;
+	case 4:
+		tmp_val = *((u32 *) reg_ref);
+		break;
+	}
+
+	val32 = cpu_to_le32(tmp_val);
+
+	if (copy_to_user(buf, &val32, count))
+		return -EFAULT;
+
+	*ppos += count;
+
+	return count;
+}
+
+static ssize_t
+nvgrace_gpu_write_config_emu(struct nvgrace_gpu_vfio_pci_core_device *nvdev,
+			      const char __user *buf, size_t count, loff_t *ppos)
+{
+	u64 pos = *ppos & VFIO_PCI_OFFSET_MASK;
+	u8 *reg_ref;
+	__le32 val;
+	u32 tmp_val;
+
+	if (!IS_ALIGNED(pos, count))
+		return -EINVAL;
+
+	if (copy_from_user(&val, buf, count))
+		return -EFAULT;
+
+	reg_ref = register_ref(nvdev, pos, pos + count);
+	if (!reg_ref)
+		return -EINVAL;
+
+	tmp_val = le32_to_cpu(val);
+
+	switch (count) {
+	case 1:
+		*reg_ref = tmp_val;
+		break;
+	case 2:
+		*((u16 *) reg_ref) = tmp_val;
+		break;
+	case 4:
+		*((u32 *) reg_ref) = tmp_val;
+		break;
+	}
+
+	*ppos += count;
+	return count;
+}
+
+/*
+ * Ad hoc map the device memory in the module kernel VA space. Primarily needed
+ * to support Qemu's device x-no-mmap=on option.
+ *
+ * The usemem region is cacheable memory and hence is memremaped.
+ * The resmem region is non-cached and is mapped using ioremap_wc (NORMAL_NC).
+ */
+static int
+nvgrace_gpu_map_device_mem(struct nvgrace_gpu_vfio_pci_core_device *nvdev,
+			    int index)
+{
+	mutex_lock(&nvdev->remap_lock);
+	if (index == VFIO_PCI_BAR4_REGION_INDEX &&
+		!nvdev->usemem.bar_remap.memaddr) {
+		nvdev->usemem.bar_remap.memaddr
+			= memremap(nvdev->usemem.memphys, nvdev->usemem.memlength, MEMREMAP_WB);
+		if (!nvdev->usemem.bar_remap.memaddr) {
+			mutex_unlock(&nvdev->remap_lock);
+			return -ENOMEM;
+		}
+	} else if (index == VFIO_PCI_BAR2_REGION_INDEX &&
+		!nvdev->resmem.bar_remap.ioaddr) {
+		nvdev->resmem.bar_remap.ioaddr
+			= ioremap_wc(nvdev->resmem.memphys, nvdev->resmem.memlength);
+		if (!nvdev->resmem.bar_remap.ioaddr) {
+			mutex_unlock(&nvdev->remap_lock);
+			return -ENOMEM;
+		}
+	}
+	mutex_unlock(&nvdev->remap_lock);
+
+	return 0;
+}
+
+static ssize_t
+nvgrace_gpu_read_mmio(struct mem_region *region,
+		       char __user *buf, size_t count,
+		       loff_t offset)
+{
+	unsigned int read = 0;
+
+	while (count) {
+		size_t filled;
+
+		if (count >= 4 && !(offset % 4)) {
+			u32 val;
+
+			val = ioread32(region->bar_remap.ioaddr + offset);
+			if (copy_to_user(buf, &val, 4))
+				goto read_mmio_exit;
+
+			filled = 4;
+		} else if (count >= 2 && !(offset % 2)) {
+			u16 val;
+
+			val = ioread16(region->bar_remap.ioaddr + offset);
+			if (copy_to_user(buf, &val, 2))
+				goto read_mmio_exit;
+
+			filled = 2;
+		} else {
+			u8 val;
+
+			val = ioread8(region->bar_remap.ioaddr + offset);
+			if (copy_to_user(buf, &val, 1))
+				goto read_mmio_exit;
+
+			filled = 1;
+		}
+
+		count -= filled;
+		read += filled;
+		offset += filled;
+		buf += filled;
+	}
+	return read;
+
+read_mmio_exit:
+	return -EFAULT;
+}
+
+/*
+ * Read the data from the device memory (mapped either through ioremap
+ * or memremap) into the user buffer.
+ */
+static int
+nvgrace_gpu_map_and_read(struct nvgrace_gpu_vfio_pci_core_device *nvdev,
+			  void __user *buf, size_t mem_count, loff_t *ppos)
+{
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+	u64 offset = *ppos & VFIO_PCI_OFFSET_MASK;
+	int ret = 0;
+
+	/*
+	 * Handle read on the BAR regions. Map to the target device memory
+	 * physical address and copy to the request read buffer.
+	 */
+	ret = nvgrace_gpu_map_device_mem(nvdev, index);
+	if (ret)
+		goto read_exit;
+
+	if (index == VFIO_PCI_BAR4_REGION_INDEX) {
+		if (copy_to_user(buf, (u8 *)nvdev->usemem.bar_remap.memaddr + offset, mem_count))
+			ret = -EFAULT;
+	} else
+		return nvgrace_gpu_read_mmio(&(nvdev->resmem), buf, mem_count, offset);
+
+read_exit:
+	return ret;
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
+nvgrace_gpu_read_mem(struct nvgrace_gpu_vfio_pci_core_device *nvdev,
+		      void __user *buf, size_t count, loff_t *ppos)
+{
+	u64 offset = *ppos & VFIO_PCI_OFFSET_MASK;
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+	struct mem_region memregion;
+	size_t mem_count, i, bar_size;
+	u8 val = 0xFF;
+	int ret;
+
+	ret = nvgrace_gpu_vfio_pci_get_mem_region(index, nvdev, &memregion);
+	if (ret)
+		return ret;
+
+	bar_size = roundup_pow_of_two(memregion.memlength);
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
+	if (offset >= memregion.memlength)
+		mem_count = 0;
+	else
+		mem_count = min(count, memregion.memlength - (size_t)offset);
+
+	ret = nvgrace_gpu_map_and_read(nvdev, buf, mem_count, ppos);
+	if (ret)
+		return ret;
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
+static ssize_t
+nvgrace_gpu_vfio_pci_read(struct vfio_device *core_vdev,
+			   char __user *buf, size_t count, loff_t *ppos)
+{
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+	u64 pos = *ppos & VFIO_PCI_OFFSET_MASK;
+	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
+		core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
+		core_device.vdev);
+
+	if (nvgrace_gpu_vfio_pci_is_fake_bar(index))
+		return nvgrace_gpu_read_mem(nvdev, buf, count, ppos);
+
+	if ((index == VFIO_PCI_CONFIG_REGION_INDEX) &&
+		(range_within_boundary(PCI_BASE_ADDRESS_2,
+		PCI_CARDBUS_CIS, pos, pos + count))) {
+		return nvgrace_gpu_read_config_emu(nvdev, buf, count, ppos);
+	}
+
+	return vfio_pci_core_read(core_vdev, buf, count, ppos);
+}
+
+static ssize_t
+nvgrace_gpu_write_mmio(struct mem_region *region,
+			const char __user *buf, size_t count,
+			loff_t offset)
+{
+	unsigned int write = 0;
+
+	while (count) {
+		size_t filled;
+
+		if (count >= 4 && !(offset % 4)) {
+			u32 val;
+
+			if (copy_from_user(&val, buf, 4))
+				goto write_mmio_exit;
+			iowrite32(val, region->bar_remap.ioaddr + offset);
+
+			filled = 4;
+		} else if (count >= 2 && !(offset % 2)) {
+			u16 val;
+
+			if (copy_from_user(&val, buf, 2))
+				goto write_mmio_exit;
+			iowrite16(val, region->bar_remap.ioaddr + offset);
+
+			filled = 2;
+		} else {
+			u8 val;
+
+			if (copy_from_user(&val, buf, 1))
+				goto write_mmio_exit;
+			iowrite8(val, region->bar_remap.ioaddr + offset);
+
+			filled = 1;
+		}
+
+		count -= filled;
+		write += filled;
+		offset += filled;
+		buf += filled;
+	}
+
+	return write;
+
+write_mmio_exit:
+	return -EFAULT;
+}
+
+/*
+ * Write the data to the device memory (mapped either through ioremap
+ * or memremap) from the user buffer.
+ */
+static int
+nvgrace_gpu_map_and_write(struct nvgrace_gpu_vfio_pci_core_device *nvdev,
+			   const void __user *buf, size_t mem_count, loff_t *ppos)
+{
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+	u64 offset = *ppos & VFIO_PCI_OFFSET_MASK;
+	int ret = 0;
+
+	ret = nvgrace_gpu_map_device_mem(nvdev, index);
+	if (ret)
+		goto write_exit;
+
+	if (index == VFIO_PCI_BAR4_REGION_INDEX) {
+		if (copy_from_user((u8 *)nvdev->usemem.bar_remap.memaddr + offset, buf, mem_count))
+			return -EFAULT;
+	} else
+		return nvgrace_gpu_write_mmio(&(nvdev->resmem), buf, mem_count, offset);
+
+write_exit:
+	return ret;
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
+nvgrace_gpu_write_mem(struct nvgrace_gpu_vfio_pci_core_device *nvdev,
+		       size_t count, loff_t *ppos, const void __user *buf)
+{
+	u64 offset = *ppos & VFIO_PCI_OFFSET_MASK;
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+	struct mem_region memregion;
+	size_t mem_count, bar_size;
+	int ret = 0;
+
+	ret = nvgrace_gpu_vfio_pci_get_mem_region(index, nvdev, &memregion);
+	if (ret)
+		return ret;
+
+	bar_size = roundup_pow_of_two(memregion.memlength);
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
+	if (offset >= memregion.memlength)
+		goto exitfn;
+
+	/*
+	 * Only the device memory present on the hardware is mapped, which may
+	 * not be power-of-2 aligned. Drop access outside the available device
+	 * memory on the hardware.
+	 */
+	mem_count = min(count, memregion.memlength - (size_t)offset);
+
+	ret = nvgrace_gpu_map_and_write(nvdev, buf, mem_count, ppos);
+	if (ret)
+		return ret;
+
+exitfn:
+	*ppos += count;
+	return count;
+}
+
+static ssize_t
+nvgrace_gpu_vfio_pci_write(struct vfio_device *core_vdev,
+			    const char __user *buf, size_t count, loff_t *ppos)
+{
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+	u64 pos = *ppos & VFIO_PCI_OFFSET_MASK;
+	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
+		core_vdev, struct nvgrace_gpu_vfio_pci_core_device, core_device.vdev);
+
+	if (nvgrace_gpu_vfio_pci_is_fake_bar(index))
+		return nvgrace_gpu_write_mem(nvdev, count, ppos, buf);
+
+	if ((index == VFIO_PCI_CONFIG_REGION_INDEX) &&
+		(range_within_boundary(PCI_BASE_ADDRESS_2,
+		PCI_CARDBUS_CIS, pos, pos + count))) {
+		return nvgrace_gpu_write_config_emu(nvdev, buf, count, ppos);
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
+	.detach_ioas = vfio_iommufd_physical_detach_ioas,
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
+	/*
+	 * The VM GPU device driver needs a non-cacheable region to support
+	 * the MIG feature. Since the device memory is mapped as NORMAL cached,
+	 * carve out a region from the end with a different NORMAL_NC
+	 * property (called as reserved memory and represented as resmem). This
+	 * region then is exposed as a 64b BAR (region 2 and 3) to the VM, while
+	 * exposing the rest (termed as usable memory and represented using usemem)
+	 * as cacheable 64b BAR (region 4 and 5).
+	 *
+	 *               devmem (memlength)
+	 * |-------------------------------------------------|
+	 * |                                           |
+	 * usemem.phys/memphys                         resmem.phys
+	 */
+	nvdev->usemem.memphys = memphys;
+
+	/*
+	 * The device memory exposed to the VM is added to the kernel by the
+	 * VM driver module in chunks of memory block size. Only the usable
+	 * memory (usemem) is added to the kernel for usage by the VM
+	 * workloads. Make the usable memory size memblock aligned.
+	 */
+	if (check_sub_overflow(memlength, RESMEM_SIZE,
+			       &nvdev->usemem.memlength)) {
+		ret = -EOVERFLOW;
+		goto done;
+	}
+	nvdev->usemem.memlength = round_down(nvdev->usemem.memlength,
+					     MEMBLK_SIZE);
+	if ((check_add_overflow(nvdev->usemem.memphys,
+	     nvdev->usemem.memlength, &nvdev->resmem.memphys)) ||
+	    (check_sub_overflow(memlength, nvdev->usemem.memlength,
+	     &nvdev->resmem.memlength))) {
+		ret = -EOVERFLOW;
+		goto done;
+	}
+
+done:
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


