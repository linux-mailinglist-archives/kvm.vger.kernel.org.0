Return-Path: <kvm+bounces-2342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 46F067F556D
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 01:36:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F15CF2816D5
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 00:36:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 472271FA2;
	Thu, 23 Nov 2023 00:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dodHc9g8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2065.outbound.protection.outlook.com [40.107.93.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22DA210C2;
	Wed, 22 Nov 2023 16:36:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vk0nS4lhCb4avwE//vY090AL8tzSJ/L52+ub88jSUzAFtyGgIdWxECReJHuElFR+eWnpRM8f3VJfcTBNWlKKjR2nUfHPa9wd/cBUl/kUBq1H3mzwHo08DQINyomXQOkIlv07gac4k+EDAd+7FPagu0y5J44HgvOhVcQcWwVcnPl5QpJ1K3jAG+TUVdBt0Wqax2+gbUu15oYnSjzc7qLfiOMFduVen1qUiOs1fjERUqHDcdhwzTylLz0Pa2wnbv/ngaUnAspuWektvaH4BbFMVUHClhkq3ANHLUIzAR8ohRy18omA+9LLHTPatsWgUxXAQNlQYojeJ0GK7rjMUVbWPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f/EoQPH49J/9G1oOSriQvHmV2OtoEDGKOUjky2Jz6OA=;
 b=d5F3A7iY2i/CfCmc1AjRnFbvResTlNAFIv550voLOtGypQyqkUDR4K/NKwcT94Clf5TXceeWVpf7MkXkS6qU26hppN/Wn7esycQ0GWofUpp/wNjk3ptmS84bvdfroZyOqaEHW+rbuMCHwda2v5Cor8W5OUj3gVYviLKNFT03GDaII3lh7UtCVfvjoNhucz1qVotHZnqQ1pKkYC5mdDcpR3EIMT28JjHkk2KhIatmnNLGMv3EcGXG/PTpL07bwrX6dhl720Xvf6pNnA8+/lAsnGGIcC1D+SNdGOAXRgg4ptCxz6UVntzkC194FLBvTQUq++pQNYJ1jpZIfv1tFJO3Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kvack.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f/EoQPH49J/9G1oOSriQvHmV2OtoEDGKOUjky2Jz6OA=;
 b=dodHc9g8iMBA4NyK01TcJQMuV/FCTe8ladSci+YBKihra1ZxqB9wTYmIhi/0+XtN9JFmEr8IA5Tdxko2d0IZBa+IpeqrMCy9rmkJFphfhnyyB8fxcKAhMKd58fMwB2h9O20ikzpxLedMQ0620pJTcAATnZlYFvVP5dnwbKG7usCeZoV8PoHIVUfZn8xKDGwIDLeaCelrUG6NLK8KscgwzVjbrGYu/C65G1M7GjtEIImQpnQK9Qgdf574loEopIrFhqjzjmo4latkeW8oJoHnJGZCU00DL5dLC1R9TqWpM4dKIRSAwDRDlbheJgSNcvWO/8YxuC1b3hQmivQ/XmN+yw==
Received: from DM6PR02CA0077.namprd02.prod.outlook.com (2603:10b6:5:1f4::18)
 by CH3PR12MB8709.namprd12.prod.outlook.com (2603:10b6:610:17c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.19; Thu, 23 Nov
 2023 00:36:17 +0000
Received: from DS3PEPF000099D5.namprd04.prod.outlook.com
 (2603:10b6:5:1f4:cafe::7e) by DM6PR02CA0077.outlook.office365.com
 (2603:10b6:5:1f4::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.27 via Frontend
 Transport; Thu, 23 Nov 2023 00:36:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS3PEPF000099D5.mail.protection.outlook.com (10.167.17.6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7025.12 via Frontend Transport; Thu, 23 Nov 2023 00:36:17 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 22 Nov
 2023 16:36:03 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 22 Nov
 2023 16:36:03 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41 via Frontend
 Transport; Wed, 22 Nov 2023 16:35:54 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<naoya.horiguchi@nec.com>, <akpm@linux-foundation.org>,
	<tony.luck@intel.com>, <bp@alien8.de>, <linmiaohe@huawei.com>,
	<rafael@kernel.org>, <lenb@kernel.org>, <james.morse@arm.com>,
	<shiju.jose@huawei.com>, <bhelgaas@google.com>, <pabeni@redhat.com>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <anuaggarwal@nvidia.com>, <jhubbard@nvidia.com>,
	<danw@nvidia.com>, <mochs@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mm@kvack.org>, <linux-edac@vger.kernel.org>,
	<linux-acpi@vger.kernel.org>
Subject: [PATCH v2 4/4] vfio/nvgpu: register device memory for poison handling
Date: Thu, 23 Nov 2023 06:05:12 +0530
Message-ID: <20231123003513.24292-5-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231123003513.24292-1-ankita@nvidia.com>
References: <20231123003513.24292-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D5:EE_|CH3PR12MB8709:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d625f86-f225-4845-0fa2-08dbebbc34fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	vE8GSyABOaBpIoM5iPGqh/fsbLwNrscJOgVJaLiGwhos9NX0eFBy5ZoFvTKcQ/tZQQiUsWXXc2uh5k1w3UOidjBSi2l2enZa2OZ0lkaq4NICCUy562d79X6fSHD9LyGem5ZKY8xP7npf5WyD3MICZrUo6QECeVvsez7cFieV7oeaj1d1wcDGAxBgBGOySXuGlRyyySCkbDMC5tZgl7XQ8imESTp1v7L3n3aXz/X99QJ0+H1gcG5BnbB+agy2C7P9rCBNvopyn4CHoZHZSAZRm1jhGCMn7HJtEHVUwDRZWjH60LBi3ggQt/pga9cXKWfcE42AV7/RIN/MR1r/jpVXW3II71uI6vYGepOBxMLRqXHCWejLc2g1hVS1i9Bapq3lkV1vjcuROWU6A2nlC6rNAfuTi/nJEWjyOco0N/T5vFGciSDZ42MrP9A7Nhi5w18E+wRGezbMw3OYkgMrhc8aheeqMNyTM/7RSsqlBN7Iu5H/2yKmlfL+szbWnrw/NT1MBa9BYjASlU4gQUv+fdXFuy5zxH+ejbu+mLiyWC75AOQeUTmLylNjbH5cGiWr2RwsSN5brzjP0+hTDHferd6xLVIWwUZvj5jtDAa81G4cDWPtL0XHVPqdkCLdZZlp8Mw9mVjiZ2E1y5/r63m5ykHtcMvC9V8znZ1OAtwuxOJH08Lzhx/VnCYlKmVHERWSXCydqeZCCirpSrKVDfb7qOGexPNn3kRrAoBwFIO7qPkcYwwH0WUDDG+v3haNkBGtmcyP4OsmGbnQXIOf+zgdxotkx+KwO1MZMmz/Qqo/Z7WCw78=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(376002)(346002)(136003)(396003)(230922051799003)(451199024)(64100799003)(1800799012)(82310400011)(186009)(40470700004)(46966006)(36840700001)(40460700003)(1076003)(336012)(426003)(7696005)(6666004)(2616005)(47076005)(83380400001)(36860700001)(4326008)(5660300002)(8936002)(8676002)(41300700001)(478600001)(7416002)(2876002)(966005)(2906002)(316002)(26005)(356005)(110136005)(70206006)(54906003)(70586007)(86362001)(36756003)(82740400003)(7636003)(921008)(40480700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2023 00:36:17.6742
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d625f86-f225-4845-0fa2-08dbebbc34fb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8709

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

The module track poisoned PFN using a hastable. The PFN is communicated
by the kernel MM to the module through the failure function, which push
the appropriate memory offset to the hashtable.

The module also defines a VMA fault ops for the module. It returns
VM_FAULT_HWPOISON in case the memory offset is found in the hashtable.

[1] https://lore.kernel.org/all/20231114081611.30550-1-ankita@nvidia.com/

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 123 +++++++++++++++++++++++++++-
 drivers/vfio/vfio_main.c            |   3 +-
 2 files changed, 124 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index b8634974e5cc..5a567375bd14 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -6,6 +6,16 @@
 #include <linux/pci.h>
 #include <linux/vfio_pci_core.h>
 #include <linux/vfio.h>
+#ifdef CONFIG_MEMORY_FAILURE
+#include <linux/bitmap.h>
+#include <linux/memory-failure.h>
+#include <linux/hashtable.h>
+#endif
+
+struct h_node {
+	unsigned long mem_offset;
+	struct hlist_node node;
+};
 
 struct nvgrace_gpu_vfio_pci_core_device {
 	struct vfio_pci_core_device core_device;
@@ -13,8 +23,96 @@ struct nvgrace_gpu_vfio_pci_core_device {
 	size_t memlength;
 	void *memmap;
 	struct mutex memmap_lock;
+#ifdef CONFIG_MEMORY_FAILURE
+	struct pfn_address_space pfn_address_space;
+	DECLARE_HASHTABLE(htbl, 8);
+#endif
+};
+
+#ifdef CONFIG_MEMORY_FAILURE
+static void
+nvgrace_gpu_vfio_pci_pfn_memory_failure(struct pfn_address_space *pfn_space,
+		unsigned long pfn)
+{
+	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
+		pfn_space, struct nvgrace_gpu_vfio_pci_core_device, pfn_address_space);
+	unsigned long mem_offset = pfn - pfn_space->node.start;
+	struct h_node *ecc;
+
+	if (mem_offset >= (nvdev->memlength >> PAGE_SHIFT))
+		return;
+
+	/*
+	 * MM has called to notify a poisoned page. Track that in the hastable.
+	 */
+	ecc = (struct h_node *)(vzalloc(sizeof(struct h_node)));
+	ecc->mem_offset = mem_offset;
+	hash_add(nvdev->htbl, &(ecc->node), ecc->mem_offset);
+}
+
+struct pfn_address_space_ops nvgrace_gpu_vfio_pci_pas_ops = {
+	.failure = nvgrace_gpu_vfio_pci_pfn_memory_failure,
 };
 
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
+extern struct vfio_device *vfio_device_from_file(struct file *file);
+
+static vm_fault_t nvgrace_gpu_vfio_pci_fault(struct vm_fault *vmf)
+{
+	unsigned long mem_offset = vmf->pgoff - vmf->vma->vm_pgoff;
+	struct vfio_device *core_vdev;
+	struct nvgrace_gpu_vfio_pci_core_device *nvdev;
+	bool found = false;
+	struct h_node *cur;
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
+	if (mem_offset < (nvdev->memlength >> PAGE_SHIFT)) {
+		/*
+		 * Check if the page is poisoned.
+		 */
+		hash_for_each_possible(nvdev->htbl, cur, node, mem_offset) {
+			if (cur->mem_offset == mem_offset)
+				return VM_FAULT_HWPOISON;
+		}
+	}
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
@@ -46,6 +144,9 @@ static void nvgrace_gpu_vfio_pci_close_device(struct vfio_device *core_vdev)
 
 	mutex_destroy(&nvdev->memmap_lock);
 
+#ifdef CONFIG_MEMORY_FAILURE
+	unregister_pfn_address_space(&(nvdev->pfn_address_space));
+#endif
 	vfio_pci_core_close_device(core_vdev);
 }
 
@@ -103,8 +204,12 @@ static int nvgrace_gpu_vfio_pci_mmap(struct vfio_device *core_vdev,
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
@@ -413,6 +518,12 @@ nvgrace_gpu_vfio_pci_fetch_memory_property(struct pci_dev *pdev,
 
 	nvdev->memlength = memlength;
 
+#ifdef CONFIG_MEMORY_FAILURE
+	/*
+	 * Initialize the hashtable tracking the poisoned pages.
+	 */
+	hash_init(nvdev->htbl);
+#endif
 	return ret;
 }
 
@@ -448,6 +559,16 @@ static void nvgrace_gpu_vfio_pci_remove(struct pci_dev *pdev)
 {
 	struct nvgrace_gpu_vfio_pci_core_device *nvdev = nvgrace_gpu_drvdata(pdev);
 	struct vfio_pci_core_device *vdev = &nvdev->core_device;
+#ifdef CONFIG_MEMORY_FAILURE
+	struct h_node *cur;
+	unsigned long bkt;
+	struct hlist_node *tmp_node;
+
+	hash_for_each_safe(nvdev->htbl, bkt, tmp_node, cur, node) {
+		hash_del(&cur->node);
+		vfree(cur);
+	}
+#endif
 
 	vfio_pci_core_unregister_device(vdev);
 	vfio_put_device(&vdev->vdev);
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 8d4995ada74a..290431ac2e00 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1319,7 +1319,7 @@ const struct file_operations vfio_device_fops = {
 	.mmap		= vfio_device_fops_mmap,
 };
 
-static struct vfio_device *vfio_device_from_file(struct file *file)
+struct vfio_device *vfio_device_from_file(struct file *file)
 {
 	struct vfio_device_file *df = file->private_data;
 
@@ -1327,6 +1327,7 @@ static struct vfio_device *vfio_device_from_file(struct file *file)
 		return NULL;
 	return df->device;
 }
+EXPORT_SYMBOL_GPL(vfio_device_from_file);
 
 /**
  * vfio_file_is_valid - True if the file is valid vfio file
-- 
2.17.1


