Return-Path: <kvm+bounces-1800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 96B4E7EBE5E
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 09:08:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2293B1F24D25
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 08:08:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46BDC46B5;
	Wed, 15 Nov 2023 08:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QTJTCOU5"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDF9441A
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 08:08:15 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2067.outbound.protection.outlook.com [40.107.93.67])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28658DF;
	Wed, 15 Nov 2023 00:08:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fXsnfvq4/KWZyGr0Vscyc9MVjADJWIlq7KaGlJk0r39KMrKVXtu56hKCZmRd5rWeA7gm3DsYpTMpgR2ZlmPb4X39bbvGDzkaY1r8O97+cMQ6Jwb3E7HSE/UGK8bBVeQS8m7/bRkdg0GnG9acZ6Eyef4nd+hFYSOd/E+qJPfd10EEpL0qVxuB7qC7g+3uJ3U7Puxx6dpuozkCHYCSTr7oyiHkN8zDcTPgZ0Mhx9wQBx+9WtebS7wrjMTlB/3BnMow+kCeS9xzm9164+nL/Yvr29IU5BLR5ABl9KRnMAOwQkav8RmHdR38nCFYIm+ADZF7JqpHhh4yGe1Dv0FiukOGjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VRVUQYlDjFXGv7IXDS/8Ffq+fEHFgsHcRhWfUlKDV9c=;
 b=eqo2ec71fLEPto6R+vdZM7FKBct/tzHwUzSNCe6DasTa0XAkX/GRQWYly5HPGXL7PiITkF5bzpoCLJv0EDJssxFdYvWiaFvxLlYxMwGOYR5TT5OID1p/VyDvFdZCTA2TV9ie50RdiQuD2+QdnhTRVR1zPHgA+hOdMaDXf4TcpS/Pop2haSTLIBc2JBmKZDRomUsAmss7aq7VmYTsRgZy/JJy9yHqa1YmitmO5hL6dMIAQRJ5mr0eg0EykEU0/CjvPvSnfElbA6yCrlO5LmISzl0lznvqYZuJXPwdpqlKKpbyHT0ovNQCAle3h2AbgB3l9jOoYkYfybVsucD3lWCSkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VRVUQYlDjFXGv7IXDS/8Ffq+fEHFgsHcRhWfUlKDV9c=;
 b=QTJTCOU56btsx3OnDMKZUP1+AmLiD22m/sCL74FSAKKddGbzpIzs3sVh4yYT7kvj/rpAiqsic5w7vZ5YA/+3N+1x0vrIoSvhBJyWAzCUZqoYrtybjxuFnzgQyq+oSvAeBdchAn4hSKAKHvXA5GjbpHEQuVanY1SbOv/hSEbB9fIMWjWLw/R6yof9o6HU8oDHC6O7gr/YgCUftq0SHieEeHMZ3IqYqjBjhex+Bz5bv+sHq5IBhuxUpCU7fW72L+ebrGxy1O1udjKNBsI6v0uTdJrhFgfhUrM5JsXKiP44WGsBW5/13OzkfjFEO395Yy63oEVvmE2NXb+OUOhfgRrLRA==
Received: from BYAPR07CA0053.namprd07.prod.outlook.com (2603:10b6:a03:60::30)
 by DM4PR12MB7502.namprd12.prod.outlook.com (2603:10b6:8:112::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.32; Wed, 15 Nov
 2023 08:08:09 +0000
Received: from MWH0EPF000989EC.namprd02.prod.outlook.com
 (2603:10b6:a03:60:cafe::50) by BYAPR07CA0053.outlook.office365.com
 (2603:10b6:a03:60::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.17 via Frontend
 Transport; Wed, 15 Nov 2023 08:08:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 MWH0EPF000989EC.mail.protection.outlook.com (10.167.241.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7002.20 via Frontend Transport; Wed, 15 Nov 2023 08:08:09 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 15 Nov
 2023 00:07:59 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Wed, 15 Nov 2023 00:07:58 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41 via Frontend
 Transport; Wed, 15 Nov 2023 00:07:53 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v1 1/1] vfio/nvgrace-gpu: carve out non cached reserved region from device memory
Date: Wed, 15 Nov 2023 13:37:51 +0530
Message-ID: <20231115080751.4558-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000989EC:EE_|DM4PR12MB7502:EE_
X-MS-Office365-Filtering-Correlation-Id: a1198178-8f20-4434-2fb1-08dbe5b20162
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	3NZFZ+txQQFb49J5sbPqz0JN715KUMVUkNy3+2Dshzz5F6K7AZDo4s0Dx+edsXFEPsjGDbwKp+VEIpQH8h19PU6z6uI7OsyC+l6spMniL/cusMWWY0lHkMP7zF91lKEFOUAWOXyRi9tuh6OQEx8fxMRaNZv02isdx/N6CMSctC4Gtv+33yPw2c/JOjaU7v6KEPBly/5+tN/PJyvQi7JmHQTivnLYFraoUDG7OoLFLHiUDjnKjMfkJzpEx/3Srma/Aq5O0Tn+mgtflZzTg0avRX/4DkGAb6OJp6WOkZVOjc7gbzxeQwntRO6ZyS6BaV9TT24S2nHtZp7L68Vu1G8t4ihhEHy+app6se2yo+U8WCKJ78cy+2gfmy8PdWXA9LF5OenYJlFDLYnAtAOX43XDCVS9gKlYH38tG5RFqERPGVf8r9xDV5oAKExx8floChKaw3e5VJwIziKQsqEG6qSKc3VybT85RPtt8tawLVt0JDtmoyd+/tSOncU3Kv/3SiecXtuaVPOmKi9sngvDq0tpw18Sm2xgLG/uz+gAjbhr1B3EyQZ7bQTZ5calo8yQGRgfZ5LAkvnjYfuM8yFE7sLcnw01hq7YCa46p7DwyUZsG8KnJuEo8mrnLU0oJVK8WDCxDNq4oNnjQE+dqJlCJsSDNm5VEvIZRiLWdFuPFlCHu2+7kjYiz4rfc5qFtWKyVC64RVwCe4F4kUlGm/4UgL2SipHwIAfHULrHYX7P0BfyQ+MzCSYTBNz7nEPhc7IG24qvQjYs7zFOb42i3ncK1oDNsbxmpwmsrZ7kvi+cm0GGX8rpIFade7UCAfcksyz8Jhlr
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(376002)(346002)(39860400002)(136003)(230922051799003)(64100799003)(186009)(1800799009)(82310400011)(451199024)(46966006)(36840700001)(40470700004)(84970400001)(40480700001)(426003)(40460700003)(70206006)(70586007)(110136005)(54906003)(86362001)(82740400003)(7636003)(356005)(36756003)(478600001)(47076005)(30864003)(83380400001)(336012)(26005)(1076003)(2616005)(7696005)(41300700001)(2876002)(2906002)(316002)(966005)(4326008)(5660300002)(8936002)(8676002)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2023 08:08:09.2270
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1198178-8f20-4434-2fb1-08dbe5b20162
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000989EC.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7502

From: Ankit Agrawal <ankita@nvidia.com>

The NVIDIA's upcoming Grace Hopper Superchip GPU device driver has a
requirement of a reserved 1G uncached RAM-like region to support the
Multi-Instance GPU (MIG) feature [1]. Carve out the region from the device
memory.

Based on [2], the requisite properties (uncached, unaligned access) can be
achieved through a VM mapping (S1) of NORMAL_NC and host (S2) mapping
with MemAttr[2:0]=0b101. Currently there is no provision in KVM for a S2
mapping with MemAttr[2:0]=0b101, but there is an ongoing effort to provide
the same [3].

This patch change goes on top of the VFIO PCI variant driver proposed for
the Grace Hopper devices in [4], which facilitates the entire device memory
to be mapped as NORMAL in S2. To provide a different non-cached property to
the reserved 1G region, it needs to be carved out from the device memory and
mapped as a separate region in Qemu VMA with pgprot_writecombine().
pgprot_writecombine() sets the Qemu VMA page properties (pgprot) as
NORMAL_NC. Using the proposed changes in [5] and [3], KVM marks the region
with MemAttr[2:0]=0b101 in S2.

The new region (represented as resmem in the patch) is carved out from
the tail end of the device memory host physical address range and exposed
as a 64b BAR (comprising of region 2 and 3) to the VM.

The remaining device memory (termed as usable memory and represented
using usemem) continues to be NORMAL cacheable and is exposed as 64b BAR
with region 4 and 5. This memory is added by the VM Nvidia device driver [6]
to the VM kernel as memblocks. Hence make the usable memory size memblock
aligned.

The memory layout on the host looks like the following:
               devmem (memlength)
|--------------------------------------------------|
|-------------cached------------------------|--NC--|
|                                           |
usemem.phys/memphys                         resmem.phys

[1] https://www.nvidia.com/en-in/technologies/multi-instance-gpu/
[2] section D8.5.5 of DDI0487_I_a_a-profile_architecture_reference_manual.pdf
[3] https://lore.kernel.org/all/20230907181459.18145-3-ankita@nvidia.com/
[4] https://lore.kernel.org/all/20231114081611.30550-1-ankita@nvidia.com/
[5] https://lore.kernel.org/all/20230907181459.18145-2-ankita@nvidia.com/
[6] https://github.com/NVIDIA/open-gpu-kernel-modules

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 236 +++++++++++++++++++++-------
 1 file changed, 178 insertions(+), 58 deletions(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index a3dbee6b87de..87afbda39939 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -7,24 +7,62 @@
 #include <linux/vfio_pci_core.h>
 #include <linux/vfio.h>
 
+/* Memory size expected as non cached and reserved by the VM driver */
+#define RESMEM_SIZE 0x40000000
+#define MEMBLK_SIZE 0x20000000
+
+struct mem_region {
+	phys_addr_t memphys; /* Base address of the region */
+	size_t memlength;    /* Region size */
+	u32 bar_regs[2];     /* Emulated BAR offset registers */
+	void *memmap;        /* Memremap pointer to the region */
+};
+
 struct nvgrace_gpu_vfio_pci_core_device {
 	struct vfio_pci_core_device core_device;
-	phys_addr_t memphys;
-	size_t memlength;
-	u32 bar_regs[2];
-	void *memmap;
+	/* Cached and usable memory for the VM. */
+	struct mem_region usemem;
+	/* Non cached memory carved out from the end of device memory */
+	struct mem_region resmem;
 	struct mutex memmap_lock;
 };
 
+/* Choose the structure corresponding to the BAR under question. */
+static int nvgrace_gpu_vfio_pci_get_mem_region(int index,
+		struct nvgrace_gpu_vfio_pci_core_device *nvdev,
+		struct mem_region *region)
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
+static bool nvgrace_gpu_vfio_pci_is_fake_bar(int index)
+{
+	if (index == VFIO_PCI_BAR2_REGION_INDEX ||
+	    index == VFIO_PCI_BAR4_REGION_INDEX)
+		return true;
+
+	return false;
+}
+
 static void init_fake_bar_emu_regs(struct vfio_device *core_vdev)
 {
 	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
 		core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
 		core_device.vdev);
 
-	nvdev->bar_regs[0] = PCI_BASE_ADDRESS_MEM_TYPE_64 |
-			     PCI_BASE_ADDRESS_MEM_PREFETCH;
-	nvdev->bar_regs[1] = 0;
+	nvdev->resmem.bar_regs[0] = PCI_BASE_ADDRESS_MEM_TYPE_64 |
+				    PCI_BASE_ADDRESS_MEM_PREFETCH;
+	nvdev->resmem.bar_regs[1] = 0;
+	nvdev->usemem.bar_regs[0] = PCI_BASE_ADDRESS_MEM_TYPE_64 |
+				    PCI_BASE_ADDRESS_MEM_PREFETCH;
+	nvdev->usemem.bar_regs[1] = 0;
 }
 
 static bool is_fake_bar_pcicfg_emu_reg_access(loff_t pos)
@@ -33,7 +71,7 @@ static bool is_fake_bar_pcicfg_emu_reg_access(loff_t pos)
 	u64 offset = pos & VFIO_PCI_OFFSET_MASK;
 
 	if ((index == VFIO_PCI_CONFIG_REGION_INDEX) &&
-	    (offset == PCI_BASE_ADDRESS_2 || offset == PCI_BASE_ADDRESS_3))
+	    (offset >= PCI_BASE_ADDRESS_2 && offset <= PCI_BASE_ADDRESS_5))
 		return true;
 
 	return false;
@@ -67,9 +105,9 @@ static void nvgrace_gpu_vfio_pci_close_device(struct vfio_device *core_vdev)
 		core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
 		core_device.vdev);
 
-	if (nvdev->memmap) {
-		memunmap(nvdev->memmap);
-		nvdev->memmap = NULL;
+	if (nvdev->usemem.memmap) {
+		memunmap(nvdev->usemem.memmap);
+		nvdev->usemem.memmap = NULL;
 	}
 
 	mutex_destroy(&nvdev->memmap_lock);
@@ -78,7 +116,7 @@ static void nvgrace_gpu_vfio_pci_close_device(struct vfio_device *core_vdev)
 }
 
 static int nvgrace_gpu_vfio_pci_mmap(struct vfio_device *core_vdev,
-				      struct vm_area_struct *vma)
+				     struct vm_area_struct *vma)
 {
 	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
 		core_vdev, struct nvgrace_gpu_vfio_pci_core_device, core_device.vdev);
@@ -87,11 +125,17 @@ static int nvgrace_gpu_vfio_pci_mmap(struct vfio_device *core_vdev,
 	unsigned int index;
 	u64 req_len, pgoff, end;
 	int ret = 0;
+	struct mem_region memregion;
 
 	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
-	if (index != VFIO_PCI_BAR2_REGION_INDEX)
+
+	if (!nvgrace_gpu_vfio_pci_is_fake_bar(index))
 		return vfio_pci_core_mmap(core_vdev, vma);
 
+	ret = nvgrace_gpu_vfio_pci_get_mem_region(index, nvdev, &memregion);
+	if (ret)
+		return ret;
+
 	/*
 	 * Request to mmap the BAR. Map to the CPU accessible memory on the
 	 * GPU using the memory information gathered from the system ACPI
@@ -101,7 +145,7 @@ static int nvgrace_gpu_vfio_pci_mmap(struct vfio_device *core_vdev,
 		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
 
 	if (check_sub_overflow(vma->vm_end, vma->vm_start, &req_len) ||
-		check_add_overflow(PHYS_PFN(nvdev->memphys), pgoff, &start_pfn) ||
+		check_add_overflow(PHYS_PFN(memregion.memphys), pgoff, &start_pfn) ||
 		check_add_overflow(PFN_PHYS(pgoff), req_len, &end))
 		return -EOVERFLOW;
 
@@ -109,9 +153,16 @@ static int nvgrace_gpu_vfio_pci_mmap(struct vfio_device *core_vdev,
 	 * Check that the mapping request does not go beyond available device
 	 * memory size
 	 */
-	if (end > nvdev->memlength)
+	if (end > memregion.memlength)
 		return -EINVAL;
 
+	/*
+	 * The carved out region of the device memory needs the NORMAL_NC
+	 * property. Communicate as such to the hypervisor.
+	 */
+	if (index == VFIO_PCI_BAR2_REGION_INDEX)
+		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
+
 	/*
 	 * Perform a PFN map to the memory and back the device BAR by the
 	 * GPU memory.
@@ -142,7 +193,12 @@ nvgrace_gpu_vfio_pci_ioctl_get_region_info(struct vfio_device *core_vdev,
 	unsigned long minsz = offsetofend(struct vfio_region_info, offset);
 	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
 		core_vdev, struct nvgrace_gpu_vfio_pci_core_device, core_device.vdev);
+	struct vfio_region_info_cap_sparse_mmap *sparse;
+	struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
 	struct vfio_region_info info;
+	struct mem_region memregion;
+	uint32_t size;
+	int ret;
 
 	if (copy_from_user(&info, (void __user *)arg, minsz))
 		return -EFAULT;
@@ -150,16 +206,14 @@ nvgrace_gpu_vfio_pci_ioctl_get_region_info(struct vfio_device *core_vdev,
 	if (info.argsz < minsz)
 		return -EINVAL;
 
-	if (info.index == VFIO_PCI_BAR2_REGION_INDEX) {
+	if (nvgrace_gpu_vfio_pci_is_fake_bar(info.index)) {
+		ret = nvgrace_gpu_vfio_pci_get_mem_region(info.index, nvdev, &memregion);
+		if (ret)
+			return ret;
 		/*
 		 * Request to determine the BAR region information. Send the
 		 * GPU memory information.
 		 */
-		uint32_t size;
-		int ret;
-		struct vfio_region_info_cap_sparse_mmap *sparse;
-		struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
-
 		size = struct_size(sparse, areas, 1);
 
 		/*
@@ -173,7 +227,7 @@ nvgrace_gpu_vfio_pci_ioctl_get_region_info(struct vfio_device *core_vdev,
 
 		sparse->nr_areas = 1;
 		sparse->areas[0].offset = 0;
-		sparse->areas[0].size = nvdev->memlength;
+		sparse->areas[0].size = memregion.memlength;
 		sparse->header.id = VFIO_REGION_INFO_CAP_SPARSE_MMAP;
 		sparse->header.version = 1;
 
@@ -188,7 +242,7 @@ nvgrace_gpu_vfio_pci_ioctl_get_region_info(struct vfio_device *core_vdev,
 		 * Given that the memory is exposed as a BAR and may not be
 		 * aligned, roundup to the next power-of-2.
 		 */
-		info.size = roundup_pow_of_two(nvdev->memlength);
+		info.size = roundup_pow_of_two(memregion.memlength);
 		info.flags = VFIO_REGION_INFO_FLAG_READ |
 			VFIO_REGION_INFO_FLAG_WRITE |
 			VFIO_REGION_INFO_FLAG_MMAP;
@@ -201,8 +255,8 @@ nvgrace_gpu_vfio_pci_ioctl_get_region_info(struct vfio_device *core_vdev,
 			} else {
 				vfio_info_cap_shift(&caps, sizeof(info));
 				if (copy_to_user((void __user *)arg +
-								sizeof(info), caps.buf,
-								caps.size)) {
+						 sizeof(info), caps.buf,
+						 caps.size)) {
 					kfree(caps.buf);
 					return -EFAULT;
 				}
@@ -211,7 +265,7 @@ nvgrace_gpu_vfio_pci_ioctl_get_region_info(struct vfio_device *core_vdev,
 			kfree(caps.buf);
 		}
 		return copy_to_user((void __user *)arg, &info, minsz) ?
-			       -EFAULT : 0;
+				    -EFAULT : 0;
 	}
 	return vfio_pci_core_ioctl(core_vdev, VFIO_DEVICE_GET_REGION_INFO, arg);
 }
@@ -228,12 +282,13 @@ static long nvgrace_gpu_vfio_pci_ioctl(struct vfio_device *core_vdev,
 	return vfio_pci_core_ioctl(core_vdev, cmd, arg);
 }
 
-static int nvgrace_gpu_memmap(struct nvgrace_gpu_vfio_pci_core_device *nvdev)
+static int nvgrace_gpu_memmap(struct nvgrace_gpu_vfio_pci_core_device *nvdev,
+			      struct mem_region *memregion)
 {
 	mutex_lock(&nvdev->memmap_lock);
-	if (!nvdev->memmap) {
-		nvdev->memmap = memremap(nvdev->memphys, nvdev->memlength, MEMREMAP_WB);
-		if (!nvdev->memmap) {
+	if (!memregion->memmap) {
+		memregion->memmap = memremap(memregion->memphys, memregion->memlength, MEMREMAP_WB);
+		if (!memregion->memmap) {
 			mutex_unlock(&nvdev->memmap_lock);
 			return -ENOMEM;
 		}
@@ -256,10 +311,10 @@ static int nvgrace_gpu_memmap(struct nvgrace_gpu_vfio_pci_core_device *nvdev)
  */
 static ssize_t
 nvgrace_gpu_read_mem(void __user *buf, size_t count, loff_t *ppos,
-		     struct nvgrace_gpu_vfio_pci_core_device *nvdev)
+		     struct mem_region memregion)
 {
 	u64 offset = *ppos & VFIO_PCI_OFFSET_MASK;
-	size_t mem_count, i, bar_size = roundup_pow_of_two(nvdev->memlength);
+	size_t mem_count, i, bar_size = roundup_pow_of_two(memregion.memlength);
 	u8 val = 0xFF;
 
 	if (offset >= bar_size)
@@ -273,16 +328,16 @@ nvgrace_gpu_read_mem(void __user *buf, size_t count, loff_t *ppos,
 	 * Read request beyond the actual device memory size is filled with ~0,
 	 * while those beyond the actual reported size is skipped.
 	 */
-	if (offset >= nvdev->memlength)
+	if (offset >= memregion.memlength)
 		mem_count = 0;
 	else
-		mem_count = min(count, nvdev->memlength - (size_t)offset);
+		mem_count = min(count, memregion.memlength - (size_t)offset);
 
 	/*
 	 * Handle read on the BAR2 region. Map to the target device memory
 	 * physical address and copy to the request read buffer.
 	 */
-	if (copy_to_user(buf, (u8 *)nvdev->memmap + offset, mem_count))
+	if (copy_to_user(buf, (u8 *)memregion.memmap + offset, mem_count))
 		return -EFAULT;
 
 	/*
@@ -308,10 +363,16 @@ static ssize_t pcibar_read_emu(struct nvgrace_gpu_vfio_pci_core_device *nvdev,
 
 	switch (pos) {
 	case PCI_BASE_ADDRESS_2:
-		val = nvdev->bar_regs[0];
+		val = nvdev->resmem.bar_regs[0];
 		break;
 	case PCI_BASE_ADDRESS_3:
-		val = nvdev->bar_regs[1];
+		val = nvdev->resmem.bar_regs[1];
+		break;
+	case PCI_BASE_ADDRESS_4:
+		val = nvdev->usemem.bar_regs[0];
+		break;
+	case PCI_BASE_ADDRESS_5:
+		val = nvdev->usemem.bar_regs[1];
 		break;
 	}
 
@@ -329,14 +390,19 @@ static ssize_t nvgrace_gpu_vfio_pci_read(struct vfio_device *core_vdev,
 	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
 		core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
 		core_device.vdev);
+	struct mem_region memregion;
 	int ret;
 
-	if (index == VFIO_PCI_BAR2_REGION_INDEX) {
-		ret = nvgrace_gpu_memmap(nvdev);
+	if (nvgrace_gpu_vfio_pci_is_fake_bar(index)) {
+		ret = nvgrace_gpu_vfio_pci_get_mem_region(index, nvdev, &memregion);
+		if (ret)
+			return ret;
+
+		ret = nvgrace_gpu_memmap(nvdev, &memregion);
 		if (ret)
 			return ret;
 
-		return nvgrace_gpu_read_mem(buf, count, ppos, nvdev);
+		return nvgrace_gpu_read_mem(buf, count, ppos, memregion);
 	}
 
 	if (is_fake_bar_pcicfg_emu_reg_access(*ppos))
@@ -358,10 +424,10 @@ static ssize_t nvgrace_gpu_vfio_pci_read(struct vfio_device *core_vdev,
  */
 static ssize_t
 nvgrace_gpu_write_mem(size_t count, loff_t *ppos, const void __user *buf,
-		      struct nvgrace_gpu_vfio_pci_core_device *nvdev)
+		      struct mem_region memregion)
 {
 	u64 offset = *ppos & VFIO_PCI_OFFSET_MASK;
-	size_t mem_count, bar_size = roundup_pow_of_two(nvdev->memlength);
+	size_t mem_count, bar_size = roundup_pow_of_two(memregion.memlength);
 
 	if (offset >= bar_size)
 		return -EINVAL;
@@ -373,10 +439,10 @@ nvgrace_gpu_write_mem(size_t count, loff_t *ppos, const void __user *buf,
 	 * Determine how many bytes to be actually written to the device memory.
 	 * Do not write to the offset beyond available size.
 	 */
-	if (offset >= nvdev->memlength)
+	if (offset >= memregion.memlength)
 		goto exitfn;
 
-	mem_count = min(count, nvdev->memlength - (size_t)offset);
+	mem_count = min(count, memregion.memlength - (size_t)offset);
 
 	/*
 	 * Only the device memory present on the hardware is mapped, which may
@@ -384,7 +450,7 @@ nvgrace_gpu_write_mem(size_t count, loff_t *ppos, const void __user *buf,
 	 * access outside the available device memory on the hardware. Drop
 	 * those write requests.
 	 */
-	if (copy_from_user((u8 *)nvdev->memmap + offset, buf, mem_count))
+	if (copy_from_user((u8 *)memregion.memmap + offset, buf, mem_count))
 		return -EFAULT;
 
 exitfn:
@@ -405,25 +471,40 @@ static ssize_t pcibar_write_emu(struct nvgrace_gpu_vfio_pci_core_device *nvdev,
 	if (copy_from_user(&val, buf, count))
 		return -EFAULT;
 
-	size = ~(roundup_pow_of_two(nvdev->memlength) - 1);
-
 	if (val == 0xffffffff) {
 		switch (pos) {
 		case PCI_BASE_ADDRESS_2:
-			nvdev->bar_regs[0] = (size & GENMASK(31, 4)) |
-				(nvdev->bar_regs[0] & GENMASK(3, 0));
+			size = ~(roundup_pow_of_two(nvdev->resmem.memlength) - 1);
+			nvdev->resmem.bar_regs[0] = (size & GENMASK(31, 4)) |
+				(nvdev->resmem.bar_regs[0] & GENMASK(3, 0));
 			break;
 		case PCI_BASE_ADDRESS_3:
-			nvdev->bar_regs[1] = size >> 32;
+			size = ~(roundup_pow_of_two(nvdev->resmem.memlength) - 1);
+			nvdev->resmem.bar_regs[1] = size >> 32;
+			break;
+		case PCI_BASE_ADDRESS_4:
+			size = ~(roundup_pow_of_two(nvdev->usemem.memlength) - 1);
+			nvdev->usemem.bar_regs[0] = (size & GENMASK(31, 4)) |
+				(nvdev->usemem.bar_regs[0] & GENMASK(3, 0));
+			break;
+		case PCI_BASE_ADDRESS_5:
+			size = ~(roundup_pow_of_two(nvdev->usemem.memlength) - 1);
+			nvdev->usemem.bar_regs[1] = size >> 32;
 			break;
 		}
 	} else {
 		switch (pos) {
 		case PCI_BASE_ADDRESS_2:
-			nvdev->bar_regs[0] = val;
+			nvdev->resmem.bar_regs[0] = val;
 			break;
 		case PCI_BASE_ADDRESS_3:
-			nvdev->bar_regs[1] = val;
+			nvdev->resmem.bar_regs[1] = val;
+			break;
+		case PCI_BASE_ADDRESS_4:
+			nvdev->usemem.bar_regs[0] = val;
+			break;
+		case PCI_BASE_ADDRESS_5:
+			nvdev->usemem.bar_regs[1] = val;
 			break;
 		}
 	}
@@ -438,14 +519,19 @@ static ssize_t nvgrace_gpu_vfio_pci_write(struct vfio_device *core_vdev,
 	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
 	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
 		core_vdev, struct nvgrace_gpu_vfio_pci_core_device, core_device.vdev);
+	struct mem_region memregion;
 	int ret;
 
-	if (index == VFIO_PCI_BAR2_REGION_INDEX) {
-		ret = nvgrace_gpu_memmap(nvdev);
+	if (nvgrace_gpu_vfio_pci_is_fake_bar(index)) {
+		ret = nvgrace_gpu_vfio_pci_get_mem_region(index, nvdev, &memregion);
 		if (ret)
 			return ret;
 
-		return nvgrace_gpu_write_mem(count, ppos, buf, nvdev);
+		ret = nvgrace_gpu_memmap(nvdev, &memregion);
+		if (ret)
+			return ret;
+
+		return nvgrace_gpu_write_mem(count, ppos, buf, memregion);
 	}
 
 	if (is_fake_bar_pcicfg_emu_reg_access(*ppos))
@@ -499,8 +585,6 @@ nvgrace_gpu_vfio_pci_fetch_memory_property(struct pci_dev *pdev,
 	if (memphys > type_max(phys_addr_t))
 		return -EOVERFLOW;
 
-	nvdev->memphys = memphys;
-
 	ret = device_property_read_u64(&pdev->dev, "nvidia,gpu-mem-size",
 				       &(memlength));
 	if (ret)
@@ -516,8 +600,44 @@ nvgrace_gpu_vfio_pci_fetch_memory_property(struct pci_dev *pdev,
 	if (memlength == 0)
 		return -ENOMEM;
 
-	nvdev->memlength = memlength;
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
 
+done:
 	return ret;
 }
 
-- 
2.17.1


