Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B52A7A8612
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 16:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236407AbjITODM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 10:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236438AbjITODI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 10:03:08 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2080.outbound.protection.outlook.com [40.107.100.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4596CE5;
        Wed, 20 Sep 2023 07:03:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oXiUqxxcr+Z8eeSiVfmYXNG2dOYBPxEM+VSqzu54fVP1aVVaJq+TPSSmmKItPwITuoyFm/AKtQu/bkrIQdd8jpaJDTiTHDeebjH2P031TC1uNP6VxlCHjtievjpmP13CpCnY0tPu/BFOCDv2lpFpMfT6gu3kqzogLuXcEF9nEYG7sJ9AVRLN1GWGIt5lbJ+72lESeFqNdRG+VWbpkGvOnIBHzEFXCCfw0luDJytqMm0tgYIw4uIaUGsCRrNspuxb/13xOgEgkUU1anKCW4tP6V7stOdFoBRYgfeLfiNE2mwfj0vCB6WmfaOw+M8AL8Pt5vRWzlTkKM1KIxEVi+v8Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DPKCo1tinmHhjn1Xd/DXhRSf51vYCpNLutWbS38L36k=;
 b=WIZroxPY/LMkz9O/sUlx8Aijp9yMeG3ZOadq5ydwZWxksPbh7MLBwLWKfPRawArVRydEWv+gtX4qaFXwaqP2+W6MaRipCbauNMLJhelIZtWjsy8OhCWvLetGwOnYDgjL9yee2xxkaxwgp5EJ2MLdXFkBUc7kmh0EbKhn/XRpkymDJz0Ew6E8qPYVMHuAGBMRKWeRQF4WbHTKCgyICM6W3y53LMuOBWrYL8UshbuWysVf2rY/eKmUoih/22WKlltxEpgM8vi6YHwf/UpP0jybHY0Ql5ZPdGR26IBhGZudHcZRDtORP7yqFC1xDEjllgboxfbM3Hi70Q2Ohh3tEDhhLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kvack.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DPKCo1tinmHhjn1Xd/DXhRSf51vYCpNLutWbS38L36k=;
 b=YK4+TSkEDcC0AeBRGAdH2P1pgY8uzei5cZ1ERCiNBO0KJhDHLEmWvs5/8xogcqnZoBHZkRY8awB4p3uIhWcjzmgv8krRxUMypbzZ8TzDhAN3gLslGlts0SleA3Mzw0CnMcsoGxmDfYD/uMz65MBAVO9VxXxXhvcBEM9TeZOtKOOLBc8BN8DAmkCqLFI4ASL6/eEdk2j06oBUTWSPo+g0wPGMcAi5d5+FUWK/mQ9O6QYGB1wTB3lHnoLbYCR9y1uGoadbiT6qBIclE5MGJDS/P0bWgA9I7ZZBzGmtrUc6GoweB9jH9VbwKRs8OwhLYvCrewnhOI8dZcCoJm+AtqNu5g==
Received: from DM6PR06CA0062.namprd06.prod.outlook.com (2603:10b6:5:54::39) by
 IA0PR12MB9045.namprd12.prod.outlook.com (2603:10b6:208:406::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.27; Wed, 20 Sep
 2023 14:02:54 +0000
Received: from DS1PEPF0001708F.namprd03.prod.outlook.com
 (2603:10b6:5:54:cafe::2) by DM6PR06CA0062.outlook.office365.com
 (2603:10b6:5:54::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.30 via Frontend
 Transport; Wed, 20 Sep 2023 14:02:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF0001708F.mail.protection.outlook.com (10.167.17.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.20 via Frontend Transport; Wed, 20 Sep 2023 14:02:54 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 20 Sep
 2023 07:02:42 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 20 Sep
 2023 07:02:42 -0700
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41 via Frontend
 Transport; Wed, 20 Sep 2023 07:02:36 -0700
From:   <ankita@nvidia.com>
To:     <ankita@nvidia.com>, <jgg@nvidia.com>,
        <alex.williamson@redhat.com>, <akpm@linux-foundation.org>,
        <tony.luck@intel.com>, <bp@alien8.de>, <naoya.horiguchi@nec.com>,
        <linmiaohe@huawei.com>
CC:     <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
        <targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
        <anuaggarwal@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-edac@vger.kernel.org>,
        <kvm@vger.kernel.org>
Subject: [PATCH v1 4/4] vfio/nvgpu: register device memory for poison handling
Date:   Wed, 20 Sep 2023 19:32:10 +0530
Message-ID: <20230920140210.12663-5-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230920140210.12663-1-ankita@nvidia.com>
References: <20230920140210.12663-1-ankita@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0001708F:EE_|IA0PR12MB9045:EE_
X-MS-Office365-Filtering-Correlation-Id: f3e04218-c33f-439b-a2f3-08dbb9e24913
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2QGWyN9V69NSR3EDKUzCDxuoAZtMSk2eSWy4dr8k9MxQY0hYxNp/kH7e2XkOKy/uKDj7MxFc9tD8Os0A1MQjFKADkNZ9rO40EH7Qon6sxsbNNA+SHsjEkeVBUnQC4fwy1fA7VdHf0PzYweq5YRtTV9Xy5XDH7VR+OofFc8CfOtopEJprdiB7ptWclcY9PuhzwgOahMsRtcShMnt3qyHH8qRB2csfjjNWjLAAS5CzLo8g3ofRVJdnp+SteaVN5W/2kMjkZDjn72GjHlIgpHcMVdXIteyeW015yZkpPWlm8ZaGRtstz4K1WLZLhHjb5nA7vBTqMgcNJs+pcSr3HqitLV9eeOceWAHNob2o6LMWsGqOIo7+5qA8mPCxxHV8FO0R0cgsmGqKgJNT65zLY+U/4CGrQ05PgnDiCO61FVEbVhebGW7gl3l9eQudnQQpe7eJjMOhOJ2eVtn9wrhF8h3Jx8uDdRtlGuQrnjX1f1G35avs5W/5uS1he/b1qlkhv+rXvnefLNZlLWQh/cHgRUZbsysMEod6y0S9cX5bZ6u1etw0J2u4pA5cp5N8HVc+Qf+MfB2RxSYGpBXqz9kXcuf9w6NUYBT3t2DeAOklQ1747fyhCkEukrJuCL0n5ymY1fe2naOaD8WJRDt89uhA3ebirD9/68i8Bf+bkiC/l5HjXBblmNyvp6yqhtfLv7mlhTmRlXsk5YHLgmnU8EBMs2mltYfIVlL8yC3JcNfhRCJqKT4DMHB1a8S971H6BU5lmADBwq2M6Qw3wqKBinrNQfwKnLWpZCdJETmZjtdytFZvdrqoyEssYXzMQNe3ySBIgwyT
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(39860400002)(376002)(346002)(136003)(451199024)(1800799009)(82310400011)(186009)(40470700004)(36840700001)(46966006)(70586007)(54906003)(70206006)(966005)(110136005)(40480700001)(316002)(41300700001)(478600001)(7696005)(6666004)(8936002)(8676002)(4326008)(40460700003)(1076003)(2616005)(26005)(5660300002)(47076005)(82740400003)(36756003)(7636003)(36860700001)(356005)(336012)(426003)(83380400001)(2906002)(7416002)(86362001)(2876002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2023 14:02:54.1421
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f3e04218-c33f-439b-a2f3-08dbb9e24913
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0001708F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB9045
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ankit Agrawal <ankita@nvidia.com>

The nvgrace-gpu-vfio-pci module [1] maps the device memory to the user VA
(Qemu) using remap_pfn_range() without adding the memory to the kernel.
The device memory pages are not backed by struct page. Patches 1-3
implements the mechanism to handle ECC/poison on memory page without
struct page and expose a registration function. This new mechanism is
leveraged here.
 
The module registers its memory region with the kernel MM for ECC handling
using the register_pfn_address_space() registration API exposed by the
kernel. It also defines a failure callback function pfn_memory_failure()
to get the poisoned PFN from the MM.
 
The module track poisoned PFN as a bitmap with a bit per PFN. The PFN is
communicated by the kernel MM to the module through the failure function,
which sets the appropriate bit in the bitmap.
 
The module also defines a VMA fault ops for the module. It returns
VM_FAULT_HWPOISON in case the bit for the PFN is set in the bitmap.

[1] https://lore.kernel.org/all/20230915025415.6762-1-ankita@nvidia.com/

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 107 +++++++++++++++++++++++++++-
 drivers/vfio/vfio.h                 |  11 ---
 drivers/vfio/vfio_main.c            |   3 +-
 include/linux/vfio.h                |  15 ++++
 4 files changed, 123 insertions(+), 13 deletions(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index ba323f2d8ea1..1c89ce0cc1cc 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -6,6 +6,10 @@
 #include <linux/pci.h>
 #include <linux/vfio_pci_core.h>
 #include <linux/vfio.h>
+#ifdef CONFIG_MEMORY_FAILURE
+#include <linux/bitmap.h>
+#include <linux/memory-failure.h>
+#endif
 
 struct nvgrace_gpu_vfio_pci_core_device {
 	struct vfio_pci_core_device core_device;
@@ -13,8 +17,85 @@ struct nvgrace_gpu_vfio_pci_core_device {
 	size_t memlength;
 	void *memmap;
 	struct mutex memmap_lock;
+#ifdef CONFIG_MEMORY_FAILURE
+	struct pfn_address_space pfn_address_space;
+	unsigned long *pfn_bitmap;
+#endif
 };
 
+#ifdef CONFIG_MEMORY_FAILURE
+void nvgrace_gpu_vfio_pci_pfn_memory_failure(struct pfn_address_space *pfn_space,
+		unsigned long pfn)
+{
+	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
+		pfn_space, struct nvgrace_gpu_vfio_pci_core_device, pfn_address_space);
+	unsigned long mem_offset = pfn - pfn_space->node.start;
+
+	if (mem_offset >= nvdev->memlength)
+		return;
+
+	/*
+	 * MM has called to notify a poisoned page. Track that in the bitmap.
+	 */
+	__set_bit(mem_offset, nvdev->pfn_bitmap);
+}
+
+struct pfn_address_space_ops nvgrace_gpu_vfio_pci_pas_ops = {
+	.failure = nvgrace_gpu_vfio_pci_pfn_memory_failure,
+};
+
+static int
+nvgrace_gpu_vfio_pci_register_pfn_range(struct nvgrace_gpu_vfio_pci_core_device *nvdev,
+					struct vm_area_struct *vma)
+{
+	unsigned long nr_pages;
+	int ret = 0;
+
+	nr_pages = nvdev->memlength >> PAGE_SHIFT;
+
+	nvdev->pfn_address_space.node.start = vma->vm_pgoff;
+	nvdev->pfn_address_space.node.last = vma->vm_pgoff + nr_pages - 1;
+	nvdev->pfn_address_space.ops = &nvgrace_gpu_vfio_pci_pas_ops;
+	nvdev->pfn_address_space.mapping = vma->vm_file->f_mapping;
+
+	ret = register_pfn_address_space(&(nvdev->pfn_address_space));
+
+	return ret;
+}
+
+static vm_fault_t nvgrace_gpu_vfio_pci_fault(struct vm_fault *vmf)
+{
+	unsigned long mem_offset = vmf->pgoff - vmf->vma->vm_pgoff;
+	struct vfio_device *core_vdev;
+	struct nvgrace_gpu_vfio_pci_core_device *nvdev;
+
+	if (!(vmf->vma->vm_file))
+		goto error_exit;
+
+	core_vdev = vfio_device_from_file(vmf->vma->vm_file);
+
+	if (!core_vdev)
+		goto error_exit;
+
+	nvdev = container_of(core_vdev,
+			struct nvgrace_gpu_vfio_pci_core_device, core_device.vdev);
+
+	/*
+	 * Check if the page is poisoned.
+	 */
+	if (mem_offset < (nvdev->memlength >> PAGE_SHIFT) &&
+		test_bit(mem_offset, nvdev->pfn_bitmap))
+		return VM_FAULT_HWPOISON;
+
+error_exit:
+	return VM_FAULT_ERROR;
+}
+
+static const struct vm_operations_struct nvgrace_gpu_vfio_pci_mmap_ops = {
+	.fault = nvgrace_gpu_vfio_pci_fault,
+};
+#endif
+
 static int nvgrace_gpu_vfio_pci_open_device(struct vfio_device *core_vdev)
 {
 	struct vfio_pci_core_device *vdev =
@@ -46,6 +127,9 @@ static void nvgrace_gpu_vfio_pci_close_device(struct vfio_device *core_vdev)
 
 	mutex_destroy(&nvdev->memmap_lock);
 
+#ifdef CONFIG_MEMORY_FAILURE
+	unregister_pfn_address_space(&(nvdev->pfn_address_space));
+#endif
 	vfio_pci_core_close_device(core_vdev);
 }
 
@@ -104,8 +188,12 @@ static int nvgrace_gpu_vfio_pci_mmap(struct vfio_device *core_vdev,
 		return ret;
 
 	vma->vm_pgoff = start_pfn;
+#ifdef CONFIG_MEMORY_FAILURE
+	vma->vm_ops = &nvgrace_gpu_vfio_pci_mmap_ops;
 
-	return 0;
+	ret = nvgrace_gpu_vfio_pci_register_pfn_range(nvdev, vma);
+#endif
+	return ret;
 }
 
 static long
@@ -406,6 +494,19 @@ nvgrace_gpu_vfio_pci_fetch_memory_property(struct pci_dev *pdev,
 
 	nvdev->memlength = memlength;
 
+#ifdef CONFIG_MEMORY_FAILURE
+	/*
+	 * A bitmap is maintained to track the pages that are poisoned. Each
+	 * page is represented by a bit. Allocation size in bytes is
+	 * determined by shifting the device memory size by PAGE_SHIFT to
+	 * determine the number of pages; and further shifted by 3 as each
+	 * byte could track 8 pages.
+	 */
+	nvdev->pfn_bitmap
+		= vzalloc((nvdev->memlength >> PAGE_SHIFT)/BITS_PER_TYPE(char));
+	if (!nvdev->pfn_bitmap)
+		ret = -ENOMEM;
+#endif
 	return ret;
 }
 
@@ -442,6 +543,10 @@ static void nvgrace_gpu_vfio_pci_remove(struct pci_dev *pdev)
 	struct nvgrace_gpu_vfio_pci_core_device *nvdev = nvgrace_gpu_drvdata(pdev);
 	struct vfio_pci_core_device *vdev = &nvdev->core_device;
 
+#ifdef CONFIG_MEMORY_FAILURE
+	vfree(nvdev->pfn_bitmap);
+#endif
+
 	vfio_pci_core_unregister_device(vdev);
 	vfio_put_device(&vdev->vdev);
 }
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 307e3f29b527..747094503909 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -16,17 +16,6 @@ struct iommufd_ctx;
 struct iommu_group;
 struct vfio_container;
 
-struct vfio_device_file {
-	struct vfio_device *device;
-	struct vfio_group *group;
-
-	u8 access_granted;
-	u32 devid; /* only valid when iommufd is valid */
-	spinlock_t kvm_ref_lock; /* protect kvm field */
-	struct kvm *kvm;
-	struct iommufd_ctx *iommufd; /* protected by struct vfio_device_set::lock */
-};
-
 void vfio_device_put_registration(struct vfio_device *device);
 bool vfio_device_try_get_registration(struct vfio_device *device);
 int vfio_df_open(struct vfio_device_file *df);
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 40732e8ed4c6..a7dafd7c64a6 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1309,7 +1309,7 @@ const struct file_operations vfio_device_fops = {
 	.mmap		= vfio_device_fops_mmap,
 };
 
-static struct vfio_device *vfio_device_from_file(struct file *file)
+struct vfio_device *vfio_device_from_file(struct file *file)
 {
 	struct vfio_device_file *df = file->private_data;
 
@@ -1317,6 +1317,7 @@ static struct vfio_device *vfio_device_from_file(struct file *file)
 		return NULL;
 	return df->device;
 }
+EXPORT_SYMBOL_GPL(vfio_device_from_file);
 
 /**
  * vfio_file_is_valid - True if the file is valid vfio file
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 454e9295970c..d88af251e931 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -361,4 +361,19 @@ int vfio_virqfd_enable(void *opaque, int (*handler)(void *, void *),
 		       struct virqfd **pvirqfd, int fd);
 void vfio_virqfd_disable(struct virqfd **pvirqfd);
 
+/*
+ * VFIO device file.
+ */
+struct vfio_device_file {
+	struct vfio_device *device;
+	struct vfio_group *group;
+	u8 access_granted;
+	u32 devid; /* only valid when iommufd is valid */
+	spinlock_t kvm_ref_lock; /* protect kvm field */
+	struct kvm *kvm;
+	struct iommufd_ctx *iommufd; /* protected by struct vfio_device_set::lock */
+};
+
+struct vfio_device *vfio_device_from_file(struct file *file);
+
 #endif /* VFIO_H */
-- 
2.17.1

