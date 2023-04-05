Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D762F6D858D
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 20:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbjDESDV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 14:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233074AbjDESDO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 14:03:14 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2077.outbound.protection.outlook.com [40.107.93.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C6C5251;
        Wed,  5 Apr 2023 11:02:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k/LJWdS4RjzCTH/KoVH5nAkrW9pmx8WQDAWwRyOlx5jL5rLyFuklY07scJXyN/smnmXkDolzQYNQI7ZpDEmWMploHFUa1Iwcqd8FOD955pS1zhCMPwp2ugTps1qPCKtYeEXId3ObePRsA9Eu19adT7Ne8Ff5pDyPUEIK9PT613szNHM8bOY0IZWDcjbnxnA8OXlC3pCjcggMpy4hlKsxX/5PfdKj2u1BcWpxIXpENKuE9ct/WX7TP4qBr6uP9yheLT7euFQQZZHqtdFR8X4yJsiS9nL8yJaJKVzpPmNNIffaca8YOBmHU8LUtYv8XJYzA8BGxlgHpfy/zSs4MlXJeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vdzN4GTXlcXcoY0qTILPkK5gTwxyEEnt0xYFTZZrQps=;
 b=N7eZrdrYc3HXGPDuae21yBPy9z+1wKud2/2U0RYXzfP5ZC8Tjp/+Gfwi30Q4JhBPZqLiFtHnVdjAPmxDddSFxk2IKtyalHjyM7FQ5lcRYdKgYPKId8gQblBxF6EClhkRQhStR1ukWfDMlxAEyDIARgrIuI3OZ7y7L9ajd1p5vjBeQ2Dh6238hCvzGvPyi0Id8ZFoaMDrRI049mJLFDUoKfAtnMnm7V7EiMPxkoJdDyLp9cvAUJZnVlBpm4d40thGV9r0z//j8GLfcoXgQRLHDrbVSlWRqGuXnpeNdewBXVcuOVTZtwtws0aySw2LD/k5CZ+56dY0ACZ09AzEPZPyCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vdzN4GTXlcXcoY0qTILPkK5gTwxyEEnt0xYFTZZrQps=;
 b=ubW5dCoKjzw5cTfA5hKqxz5SjfyJGVBAh2LK12BVTyNFAupHBGFm8n4F8WiEydoE20mjLwetNf/fJIfb5dHmBjZpe9HRp8fBFOERCK7d8RlSr5aX2HrFWu/Ql1ctzmBo/2ANJdRFEZYoBqk5yIp9y36+2TaKItA88pZ7zaqZCMn5cWv2rVSe5Afl1hyqk9MqRS21cf0rUhde/eroMoPvOND1OCQsMCfKShg1FSdR+bPD8OABfslRhtUyp13wDNJ10Z+bRAz610Ss9RcO/3QboXplbfXUWiBQbLDGxxAKW9Bi2l1CvemOjH69ivcvd7GBY5+DWILkOBEHDvkGlv+rBQ==
Received: from DM6PR17CA0005.namprd17.prod.outlook.com (2603:10b6:5:1b3::18)
 by SJ0PR12MB6901.namprd12.prod.outlook.com (2603:10b6:a03:47e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Wed, 5 Apr
 2023 18:02:14 +0000
Received: from DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b3:cafe::41) by DM6PR17CA0005.outlook.office365.com
 (2603:10b6:5:1b3::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.44 via Frontend
 Transport; Wed, 5 Apr 2023 18:02:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM6NAM11FT049.mail.protection.outlook.com (10.13.172.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6277.28 via Frontend Transport; Wed, 5 Apr 2023 18:02:13 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 5 Apr 2023
 11:01:36 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Wed, 5 Apr 2023 11:01:36 -0700
Received: from localhost.localdomain (10.127.8.14) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37 via Frontend
 Transport; Wed, 5 Apr 2023 11:01:36 -0700
From:   <ankita@nvidia.com>
To:     <ankita@nvidia.com>, <jgg@nvidia.com>,
        <alex.williamson@redhat.com>, <naoya.horiguchi@nec.com>,
        <maz@kernel.org>, <oliver.upton@linux.dev>
CC:     <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
        <targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
        <apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>
Subject: [PATCH v3 6/6] vfio/nvgpu: register device memory for poison handling
Date:   Wed, 5 Apr 2023 11:01:34 -0700
Message-ID: <20230405180134.16932-7-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230405180134.16932-1-ankita@nvidia.com>
References: <20230405180134.16932-1-ankita@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT049:EE_|SJ0PR12MB6901:EE_
X-MS-Office365-Filtering-Correlation-Id: 23ea251e-83ae-480e-4f9e-08db35ffe2bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1ThF1QE+sshigyAroD389Se81EL2sgk1Xm6rlSoq83A0oALJZTJp74i4qj1tB+lvSecnvy3symPZUJPA683YkRpwfqEzE0iNv8Rhwa6roJbppfXN3Kpq5foiebR5Q5i+XMnxpGHCETBRYrLTivrseacxvifN3v1+IyKuFIYkyxGpOp6vbnbTK0rWgAGTXcJqiG8XKoTZX069dHRWQH9JRHv5baJL0+oFzLrvtx72a/nvtWqaO2cvIPe4smtQXhk77aKFnE0CHMbhaxXscipevEztXpyso9+rxnM4a+pIQthJiTXJ95eMVD5rmuzWKc3SsgKwfes90Wyl8rXIr533IfADKe4xiy30IJqmeHkEPObHsNQtWqzS4wAJc1DzX6CaUgNwJovEz9k3BF19ZVMjEDZrmUWkrv12rUb22aMF0d12+UhXUfOaKwauj3NYO6oQwxCLCPyJK9lpOpp8Uhm9bjhNAwTyZ/j7BZz5UUZhoa3oG6kFYd08QWCGp32rJ3vs82OgAOfDB3BBkE8WyOtsLpgAJAqheSg1ufP153djRht4poeiLtWBgook0s0X3nSMoqS7tLD5ZnNZhOSV2FUNvb/d1nIcuxC5JcEpHsZq5LiULW0Zk5T0K0EWAwHVNpPXb7YXP/WEe2Y0A7G16hVslGMY08U8pDw5tbqVu9TWJidtbJ1ZA1Zlb1g+tBCWQEcZfez/HmDzUCZ18FxqiHAzCuND9PDuRI+qXFCUyhw/5vJhu7v74HTUe1H8yy030JiC
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(346002)(136003)(39860400002)(451199021)(46966006)(40470700004)(36840700001)(186003)(336012)(426003)(40460700003)(41300700001)(40480700001)(2616005)(4326008)(70586007)(8676002)(36860700001)(70206006)(2876002)(36756003)(2906002)(356005)(86362001)(7636003)(82740400003)(82310400005)(83380400001)(5660300002)(110136005)(8936002)(316002)(54906003)(478600001)(47076005)(1076003)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 18:02:13.8510
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 23ea251e-83ae-480e-4f9e-08db35ffe2bb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6901
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

The nvgpu-vfio-pci module maps QEMU VMA to device memory through
remap_pfn_range(). The new mechanism to handle poison on memory not backed
by struct page is leveraged here.

nvgpu-vfio-pci defines a function pfn_memory_failure() to get the ECC PFN
from the MM. The function is registered with kernel MM along with the
address space and PFN range through register_pfn_address_space().

Track poisoned PFN in the nvgpu-vfio-pci module as bitmap with a bit per
PFN. The PFN is communicated by the kernel MM to the module through the
failure function, which sets the appropriate bit in the bitmap.

Register a VMA fault ops for the module. It returns VM_FAULT_HWPOISON
in case the bit for the PFN is set in the bitmap.

Clear bitmap on reset to reflect the clean state of the device memory
after reset.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgpu/main.c | 116 ++++++++++++++++++++++++++++++++--
 1 file changed, 110 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/pci/nvgpu/main.c b/drivers/vfio/pci/nvgpu/main.c
index 2dd8cc6e0145..8ccd3fe33a0f 100644
--- a/drivers/vfio/pci/nvgpu/main.c
+++ b/drivers/vfio/pci/nvgpu/main.c
@@ -5,6 +5,8 @@
 
 #include <linux/pci.h>
 #include <linux/vfio_pci_core.h>
+#include <linux/bitmap.h>
+#include <linux/memory-failure.h>
 
 #define DUMMY_PFN \
 	(((nvdev->mem_prop.hpa + nvdev->mem_prop.mem_length) >> PAGE_SHIFT) - 1)
@@ -12,12 +14,78 @@
 struct dev_mem_properties {
 	uint64_t hpa;
 	uint64_t mem_length;
+	unsigned long *pfn_bitmap;
 	int bar1_start_offset;
 };
 
 struct nvgpu_vfio_pci_core_device {
 	struct vfio_pci_core_device core_device;
 	struct dev_mem_properties mem_prop;
+	struct pfn_address_space pfn_address_space;
+};
+
+void nvgpu_vfio_pci_pfn_memory_failure(struct pfn_address_space *pfn_space,
+				       unsigned long pfn)
+{
+	struct nvgpu_vfio_pci_core_device *nvdev = container_of(
+		pfn_space, struct nvgpu_vfio_pci_core_device, pfn_address_space);
+
+	/*
+	 * MM has called to notify a poisoned page. Track that in the bitmap.
+	 */
+	__set_bit(pfn - (pfn_space->node.start), nvdev->mem_prop.pfn_bitmap);
+}
+
+struct pfn_address_space_ops nvgpu_vfio_pci_pas_ops = {
+	.failure = nvgpu_vfio_pci_pfn_memory_failure,
+};
+
+static int
+nvgpu_vfio_pci_register_pfn_range(struct nvgpu_vfio_pci_core_device *nvdev,
+				  struct vm_area_struct *vma)
+{
+	unsigned long nr_pages;
+	int ret = 0;
+
+	nr_pages = nvdev->mem_prop.mem_length >> PAGE_SHIFT;
+
+	nvdev->pfn_address_space.node.start = vma->vm_pgoff;
+	nvdev->pfn_address_space.node.last = vma->vm_pgoff + nr_pages - 1;
+	nvdev->pfn_address_space.ops = &nvgpu_vfio_pci_pas_ops;
+	nvdev->pfn_address_space.mapping = vma->vm_file->f_mapping;
+
+	ret = register_pfn_address_space(&(nvdev->pfn_address_space));
+
+	return ret;
+}
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
+	 * Check if the page is poisoned.
+	 */
+	if (mem_offset < (nvdev->mem_prop.mem_length >> PAGE_SHIFT) &&
+		test_bit(mem_offset, nvdev->mem_prop.pfn_bitmap))
+		return VM_FAULT_HWPOISON;
+
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
 };
 
 static int vfio_get_bar1_start_offset(struct vfio_pci_core_device *vdev)
@@ -26,8 +94,9 @@ static int vfio_get_bar1_start_offset(struct vfio_pci_core_device *vdev)
 
 	pci_read_config_byte(vdev->pdev, 0x10, &val);
 	/*
-	 * The BAR1 start offset in the PCI config space depends on the BAR0size.
-	 * Check if the BAR0 is 64b and return the approproiate BAR1 offset.
+	 * The BAR1 start offset in the PCI config space depends on the BAR0
+	 * size. Check if the BAR0 is 64b and return the approproiate BAR1
+	 * offset.
 	 */
 	if (val & PCI_BASE_ADDRESS_MEM_TYPE_64)
 		return VFIO_PCI_BAR2_REGION_INDEX;
@@ -54,6 +123,16 @@ static int nvgpu_vfio_pci_open_device(struct vfio_device *core_vdev)
 	return ret;
 }
 
+void nvgpu_vfio_pci_close_device(struct vfio_device *core_vdev)
+{
+	struct nvgpu_vfio_pci_core_device *nvdev = container_of(
+		core_vdev, struct nvgpu_vfio_pci_core_device, core_device.vdev);
+
+	unregister_pfn_address_space(&(nvdev->pfn_address_space));
+
+	vfio_pci_core_close_device(core_vdev);
+}
+
 int nvgpu_vfio_pci_mmap(struct vfio_device *core_vdev,
 			struct vm_area_struct *vma)
 {
@@ -93,8 +172,11 @@ int nvgpu_vfio_pci_mmap(struct vfio_device *core_vdev,
 		return ret;
 
 	vma->vm_pgoff = start_pfn + pgoff;
+	vma->vm_ops = &nvgpu_vfio_pci_mmap_ops;
 
-	return 0;
+	ret = nvgpu_vfio_pci_register_pfn_range(nvdev, vma);
+
+	return ret;
 }
 
 long nvgpu_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
@@ -140,7 +222,14 @@ long nvgpu_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 		}
 
 		return vfio_pci_core_ioctl(core_vdev, cmd, arg);
-
+	case VFIO_DEVICE_RESET:
+		/*
+		 * Resetting the GPU clears up the poisoned page. Reset the
+		 * poisoned page bitmap.
+		 */
+		memset(nvdev->mem_prop.pfn_bitmap, 0,
+		       nvdev->mem_prop.mem_length >> (PAGE_SHIFT + 3));
+		return vfio_pci_core_ioctl(core_vdev, cmd, arg);
 	default:
 		return vfio_pci_core_ioctl(core_vdev, cmd, arg);
 	}
@@ -151,7 +240,7 @@ static const struct vfio_device_ops nvgpu_vfio_pci_ops = {
 	.init = vfio_pci_core_init_dev,
 	.release = vfio_pci_core_release_dev,
 	.open_device = nvgpu_vfio_pci_open_device,
-	.close_device = vfio_pci_core_close_device,
+	.close_device = nvgpu_vfio_pci_close_device,
 	.ioctl = nvgpu_vfio_pci_ioctl,
 	.read = vfio_pci_core_read,
 	.write = vfio_pci_core_write,
@@ -188,7 +277,20 @@ nvgpu_vfio_pci_fetch_memory_property(struct pci_dev *pdev,
 
 	ret = device_property_read_u64(&(pdev->dev), "nvidia,gpu-mem-size",
 				       &(nvdev->mem_prop.mem_length));
-	return ret;
+	if (ret)
+		return ret;
+
+	/*
+	 * A bitmap is maintained to teack the pages that are poisoned. Each
+	 * page is represented by a bit. Allocation size in bytes is
+	 * determined by shifting the device memory size by PAGE_SHIFT to
+	 * determine the number of pages; and further shifted by 3 as each
+	 * byte could track 8 pages.
+	 */
+	nvdev->mem_prop.pfn_bitmap
+		= vzalloc(nvdev->mem_prop.mem_length >> (PAGE_SHIFT + 3));
+
+	return 0;
 }
 
 static int nvgpu_vfio_pci_probe(struct pci_dev *pdev,
@@ -224,6 +326,8 @@ static void nvgpu_vfio_pci_remove(struct pci_dev *pdev)
 	struct nvgpu_vfio_pci_core_device *nvdev = nvgpu_drvdata(pdev);
 	struct vfio_pci_core_device *vdev = &nvdev->core_device;
 
+	vfree(nvdev->mem_prop.pfn_bitmap);
+
 	vfio_pci_core_unregister_device(vdev);
 	vfio_put_device(&vdev->vdev);
 }
-- 
2.17.1

