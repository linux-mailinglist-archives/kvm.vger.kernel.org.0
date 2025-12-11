Return-Path: <kvm+bounces-65731-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D6EC0CB4F49
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 08:06:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3F1563017869
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 07:06:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7B8B2C2366;
	Thu, 11 Dec 2025 07:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MQcl3Ad+"
X-Original-To: kvm@vger.kernel.org
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010067.outbound.protection.outlook.com [52.101.201.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35ED2C21E8;
	Thu, 11 Dec 2025 07:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765436789; cv=fail; b=Qq8KF0P4r1gZnUNePVTWSSw+5FFK+tjaerN44a5n7U2psawBjVv16PZ2tVlXhgdS6DAA71FcEkoxmGXl9fHdg6X7NfYV/Bwx4RVp9xbOIxrQzyb3apY2669AOdXEi7e4SD3GOVoVf/fLaCffG28kOSE9AJKJOZ2ISTgi/INhdBw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765436789; c=relaxed/simple;
	bh=Q/Nr+EgNkpWkHhj5x4uup+yk9RjAfOdNNzzoJ9D8PH8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GteXWZVBeVeCQhzjCv/POurD571EcAvPqszulmr1c2QNRtpmlUoDaKhNQp4auWtcZM49nxXqnFIdP0UmRZEdmHejt+OYJzo8/ou7W8JpaGX6PYrue7lncaOK4escWDg6lzvilQc4QeUy03IoWLL2wxSOYggiH5RMuoO7al998Do=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MQcl3Ad+; arc=fail smtp.client-ip=52.101.201.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fTCxnTecVk9BBOX+Nk8JmVlj6i7xNXkm3URK0FwJcEtrOyu7OUYpMDl4L1QqLTbLMK1m1qGc05LvlLOoFUj+4QtIEcmdhZ/PtpP/Ihrw0nTB88GQ0+EnpNLSK1Ghh5mQqz1T4aZaEibfGwghRmNGg3LLteQbYkXv+8kehFUySBA8sjXlwFk2Je+fakBF+d9lkiHGu+IBKJA1xh2SWtLvCtUT1+OvbjuDKGkF8HOpKRFVOT1AAkxoCtKkcwevtdDml9qmm3q7KKAWRmuWT8OxPY5v9rZVJ+RBvYYkwUZ9QETm1Tnicx0yXCQbQYJhfGwcCQNtCO/Fh43RAXLu4l/2yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q5YHI6AFwaCUcqJFzuoVIUcmYY3IUXGB+1xa6MXCpOI=;
 b=ICDY4UfP/7uwn/jGgMhoZYx+yT9t1adlPaPreyEv7zhNs8Cw2eFJOIlEgPT3WdWDz4/ZDSvy0aUK/I9y+zyVcqt8SrI3wvG+/FWlWfqcuRUo7KoStb08F02BgJJMaO3JMXn2U2eMS+DXUq1nIzxTkibmdcGmb2NQC5Y45z4l+Y5vfLW4uSCDEKuodjW1CwW85XqXnvUPYg7yi4BKoRDaFEjPJshL1+5KALcHZYrcd9mH75qKyZ5wElEgdDg3v47ibqJSsZJPIXIs2Eh1WQhuSXgQSbHanD4qa8e6/W5G/8ohtq3Lm8TyQCGbmrmNXfpoSjZc/bIPCIcDTqLsLZdsKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q5YHI6AFwaCUcqJFzuoVIUcmYY3IUXGB+1xa6MXCpOI=;
 b=MQcl3Ad+RikandLTfNbG8XanV/1t2ABOTVmAdoyplXbA0ZMjLwMgSVw6ZuJqBhduRd4Uq/97YOgenUhyuCwZsmTTnKTHh65lj4idrywdmI+xG5b8oTnJ9Qepf6Rz/IqJ93sLV05EQ40XdeO51jL1qMmcPba3YZV1GeeoeCDDTN/3R9LMGR7JfWDAy1CzuNsOWZynWRzdnWvBapgbNFfrLs64KtArpoax02MEeswi0I5nVkd+4YXi6EkWh6lMKOmIQT2Je60T7hPGkUIN4YrPRTNay52XyVO+m7gDEKaW5ikSKAaIL8QUcPi/XIG57Eiu7afuuDU9pYYYsok/XPMWpw==
Received: from PH7PR03CA0002.namprd03.prod.outlook.com (2603:10b6:510:339::21)
 by DM4PR12MB6253.namprd12.prod.outlook.com (2603:10b6:8:a6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.9; Thu, 11 Dec
 2025 07:06:23 +0000
Received: from CY4PEPF0000E9D0.namprd03.prod.outlook.com
 (2603:10b6:510:339:cafe::54) by PH7PR03CA0002.outlook.office365.com
 (2603:10b6:510:339::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.15 via Frontend Transport; Thu,
 11 Dec 2025 07:06:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000E9D0.mail.protection.outlook.com (10.167.241.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Thu, 11 Dec 2025 07:06:22 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 10 Dec
 2025 23:06:07 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 10 Dec
 2025 23:06:06 -0800
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 10 Dec 2025 23:06:06 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <vsethi@nvidia.com>, <jgg@nvidia.com>,
	<mochs@nvidia.com>, <jgg@ziepe.ca>, <skolothumtho@nvidia.com>,
	<alex@shazbot.org>, <akpm@linux-foundation.org>, <linmiaohe@huawei.com>,
	<nao.horiguchi@gmail.com>
CC: <cjia@nvidia.com>, <zhiw@nvidia.com>, <kjaju@nvidia.com>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH v1 3/3] vfio/nvgrace-gpu: register device memory for poison handling
Date: Thu, 11 Dec 2025 07:06:03 +0000
Message-ID: <20251211070603.338701-4-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251211070603.338701-1-ankita@nvidia.com>
References: <20251211070603.338701-1-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D0:EE_|DM4PR12MB6253:EE_
X-MS-Office365-Filtering-Correlation-Id: e4dd5f22-1e56-4ceb-f6df-08de3883caeb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013|921020|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?a6CddOKx4comeCdtnmcuHRIwDdnl9XKeAqvwgVmi+YcJPrTGeKjU2+Xwtqxz?=
 =?us-ascii?Q?TBS59bB+J3liK+cXIQS1S6hsdbTMZM04x+1KL1nFBYiAtXj3n2tLuhQY9wYt?=
 =?us-ascii?Q?5EQrvQX5phmT8hZEu9A8BByURzxYCBOWzmjlVvq4S0ccFuvRasjJ4S/k9y5D?=
 =?us-ascii?Q?Wxki7iJx+C6XuPSNJPH/XnMnjI6OkvbhO10lzBKJlkGnZaI9W+NqRAxRF9LK?=
 =?us-ascii?Q?cL/V9QV8hN9u0rbVRGIJmfIrfI7u7cDPDuCyo6cSL3/JAYxpiVfzHq+G3Knu?=
 =?us-ascii?Q?BYa1yses/lmwWHJPd1yiKkH9an/KhVaBFwZiAHiQFuSWgInf/UdUq3lRR+n1?=
 =?us-ascii?Q?/K3GlpaAeS1WZXcTr0owZv1fz0H8LoQrIm+d8GLZkFDotw5DAxd+9MtTKKfU?=
 =?us-ascii?Q?KGjkE20dUnZ2GCe/6ibQldiEPk7kbC8E9ZWwVXg+U9w5AwSBSbKAjL0SkjjF?=
 =?us-ascii?Q?AUmsxSwDAEUnqftOhDRfeRsQtC6kIqx9GxEgfp32r0mqW8bjobFfCHW74q94?=
 =?us-ascii?Q?OWp3qgUSgux3TkbWGJniWz3wFP8Ad5zpbSxiDcxXBvanhzWPf6QYeJ2TAqSi?=
 =?us-ascii?Q?9raYMAbE8guOtviL/jDC0e3JiJxFs0MEfiQyLRopzxDudXdo97ANdOj8IswH?=
 =?us-ascii?Q?uYyS8OtsleRXjGC3aKr2LIJhLnWBFcJYFWO3shYyfu7h3DMExB5qSmUbxu+V?=
 =?us-ascii?Q?NmbD9sUiz0TyGjr1fkms/9HYZtpT0OyBT0p6jBCjUiXVhGxx70iHmob9RI8P?=
 =?us-ascii?Q?BPG4+pTQ2OsNLuFXGHWxHUhOJbojwf8G7HgChAJOJyffZ2PCzRSLW4jqqjeT?=
 =?us-ascii?Q?LVmLpAS0M0p2qGCBB4feVaSkSM1gxiltExfvi6G0YaTIeZRRtg3I+CppKhi6?=
 =?us-ascii?Q?2YRmFizmrLGBoFK/IJkWLwcEP2Yx63l/yjCw42XhQAHs0vthzW3Hc7O9HmfQ?=
 =?us-ascii?Q?DuoqCwnGlGoE7suv5F2ZHfXDkR3QuJEpcl73VKd1T73ygOtcv228vkc5XPTp?=
 =?us-ascii?Q?TDOiqDSJs/Au+bs+xI4heoKtnZU08OGggVtA3x38msjO8vfuhUz+v2rSdNPQ?=
 =?us-ascii?Q?mYyRf9Td/qbwg5VpS6yGSGZbN3L7B4v/WRnh7V4y9PorzsXqBI3t9bWQzx+w?=
 =?us-ascii?Q?znTgJJw/W8pPaMjImf0SLMwoFxG5Zr8CQzRS0WLQHVaE2AChH85Q2sOk0YW1?=
 =?us-ascii?Q?qzw6GJE5yGE1Pa5BtgKsM4gRWwahCNUpijusVm8g95ds28+c/Wy7XUjqjTak?=
 =?us-ascii?Q?21nuD6MJ0r1dZe4C2wHmRJvEuJw/V3KWtTy+/ozoRjEdVe7UJvNIiEv8b/cu?=
 =?us-ascii?Q?A+fZUoKcP59jVG2GHL8Mnk15xGpLyrlBcM+Gjv5bmaLFU5UDFIt1RGaivxAJ?=
 =?us-ascii?Q?dMuGp5ZxGL0OogQPMtPXpJQGX9SC7I3Nv4ajpr7wvdrr6FmbuVKk/PawAMmP?=
 =?us-ascii?Q?p5FYGRdut3/k7/2hK+Ut4QHnNwVfXaQtM26Ym9hECcKCDuV3nRs0kNqEgr7m?=
 =?us-ascii?Q?DHwvYPO7XsJRgkOZxRYWyzz98+Wr3yLktux+QZNJiDMq8sxbQPtowcXBtVZR?=
 =?us-ascii?Q?BBrHvosO20Q899AW2T3xFi42AKvwVaa9c3kc74uz?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013)(921020)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2025 07:06:22.8300
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e4dd5f22-1e56-4ceb-f6df-08de3883caeb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6253

From: Ankit Agrawal <ankita@nvidia.com>

The nvgrace-gpu module [1] maps the device memory to the user VA (Qemu)
without adding the memory to the kernel. The device memory pages are PFNMAP
and not backed by struct page. The module can thus utilize the MM's PFNMAP
memory_failure mechanism that handles ECC/poison on regions with no struct
pages.

The kernel MM code exposes register/unregister APIs allowing modules to
register the device memory for memory_failure handling. Make nvgrace-gpu
register the GPU memory with the MM on open.

The module registers its memory region, the address_space with the
kernel MM for ECC handling and implements a callback function to convert
the PFN to the file page offset. The callback functions checks if the
PFN belongs to the device memory region and is also contained in the
VMA range, an error is returned otherwise.

Link: https://lore.kernel.org/all/20240220115055.23546-1-ankita@nvidia.com/ [1]

Suggested-by: Alex Williamson <alex@shazbot.org>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 116 +++++++++++++++++++++++++++-
 1 file changed, 112 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index 84d142a47ec6..fdfb961a6972 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -9,6 +9,7 @@
 #include <linux/jiffies.h>
 #include <linux/pci-p2pdma.h>
 #include <linux/pm_runtime.h>
+#include <linux/memory-failure.h>
 
 /*
  * The device memory usable to the workloads running in the VM is cached
@@ -49,6 +50,7 @@ struct mem_region {
 		void *memaddr;
 		void __iomem *ioaddr;
 	};                      /* Base virtual address of the region */
+	struct pfn_address_space pfn_address_space;
 };
 
 struct nvgrace_gpu_pci_core_device {
@@ -88,6 +90,83 @@ nvgrace_gpu_memregion(int index,
 	return NULL;
 }
 
+static inline int pfn_memregion_offset(struct nvgrace_gpu_pci_core_device *nvdev,
+				       unsigned int index,
+				       unsigned long pfn,
+				       u64 *pfn_offset_in_region)
+{
+	struct mem_region *region;
+	unsigned long start_pfn, num_pages;
+
+	region = nvgrace_gpu_memregion(index, nvdev);
+	if (!region)
+		return -ENOENT;
+
+	start_pfn = PHYS_PFN(region->memphys);
+	num_pages = region->memlength >> PAGE_SHIFT;
+
+	if (pfn < start_pfn || pfn >= start_pfn + num_pages)
+		return -EINVAL;
+
+	*pfn_offset_in_region = pfn - start_pfn;
+
+	return 0;
+}
+
+static inline struct nvgrace_gpu_pci_core_device *
+vma_to_nvdev(struct vm_area_struct *vma);
+
+static int nvgrace_gpu_pfn_to_vma_pgoff(struct vm_area_struct *vma,
+					unsigned long pfn,
+					pgoff_t *pgoff)
+{
+	struct nvgrace_gpu_pci_core_device *nvdev;
+	unsigned int index =
+		vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
+	u64 vma_offset_in_region = vma->vm_pgoff &
+		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
+	u64 pfn_offset_in_region;
+	int ret;
+
+	nvdev = vma_to_nvdev(vma);
+	if (!nvdev)
+		return -EPERM;
+
+	ret = pfn_memregion_offset(nvdev, index, pfn, &pfn_offset_in_region);
+	if (ret)
+		return ret;
+
+	/* Ensure PFN is not before VMA's start within the region */
+	if (pfn_offset_in_region < vma_offset_in_region)
+		return -EINVAL;
+
+	/* Calculate offset from VMA start */
+	*pgoff = vma->vm_pgoff +
+		 (pfn_offset_in_region - vma_offset_in_region);
+
+	return 0;
+}
+
+static int
+nvgrace_gpu_vfio_pci_register_pfn_range(struct vfio_device *core_vdev,
+					struct mem_region *region)
+{
+	int ret;
+	unsigned long pfn, nr_pages;
+
+	pfn = PHYS_PFN(region->memphys);
+	nr_pages = region->memlength >> PAGE_SHIFT;
+
+	region->pfn_address_space.node.start = pfn;
+	region->pfn_address_space.node.last = pfn + nr_pages - 1;
+	region->pfn_address_space.mapping = core_vdev->inode->i_mapping;
+	region->pfn_address_space.pfn_to_vma_pgoff = nvgrace_gpu_pfn_to_vma_pgoff;
+
+	ret = register_pfn_address_space(&region->pfn_address_space);
+
+	return ret;
+}
+
 static int nvgrace_gpu_open_device(struct vfio_device *core_vdev)
 {
 	struct vfio_pci_core_device *vdev =
@@ -114,14 +193,28 @@ static int nvgrace_gpu_open_device(struct vfio_device *core_vdev)
 	 * memory mapping.
 	 */
 	ret = vfio_pci_core_setup_barmap(vdev, 0);
-	if (ret) {
-		vfio_pci_core_disable(vdev);
-		return ret;
+	if (ret)
+		goto error_exit;
+
+	if (nvdev->resmem.memlength) {
+		ret = nvgrace_gpu_vfio_pci_register_pfn_range(core_vdev, &nvdev->resmem);
+		if (ret && ret != -EOPNOTSUPP)
+			goto error_exit;
 	}
 
-	vfio_pci_core_finish_enable(vdev);
+	ret = nvgrace_gpu_vfio_pci_register_pfn_range(core_vdev, &nvdev->usemem);
+	if (ret && ret != -EOPNOTSUPP)
+		goto register_mem_failed;
 
+	vfio_pci_core_finish_enable(vdev);
 	return 0;
+
+register_mem_failed:
+	if (nvdev->resmem.memlength)
+		unregister_pfn_address_space(&nvdev->resmem.pfn_address_space);
+error_exit:
+	vfio_pci_core_disable(vdev);
+	return ret;
 }
 
 static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
@@ -130,6 +223,11 @@ static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
 		container_of(core_vdev, struct nvgrace_gpu_pci_core_device,
 			     core_device.vdev);
 
+	if (nvdev->resmem.memlength)
+		unregister_pfn_address_space(&nvdev->resmem.pfn_address_space);
+
+	unregister_pfn_address_space(&nvdev->usemem.pfn_address_space);
+
 	/* Unmap the mapping to the device memory cached region */
 	if (nvdev->usemem.memaddr) {
 		memunmap(nvdev->usemem.memaddr);
@@ -247,6 +345,16 @@ static const struct vm_operations_struct nvgrace_gpu_vfio_pci_mmap_ops = {
 #endif
 };
 
+static inline struct nvgrace_gpu_pci_core_device *
+vma_to_nvdev(struct vm_area_struct *vma)
+{
+	/* Check if this VMA belongs to us */
+	if (vma->vm_ops != &nvgrace_gpu_vfio_pci_mmap_ops)
+		return NULL;
+
+	return vma->vm_private_data;
+}
+
 static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
 			    struct vm_area_struct *vma)
 {
-- 
2.34.1


