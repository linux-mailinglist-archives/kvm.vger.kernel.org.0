Return-Path: <kvm+bounces-64384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 419E1C805EF
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 13:10:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 863703AEEFA
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 12:03:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB2CB3054EB;
	Mon, 24 Nov 2025 11:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="J0x1ECGe"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012029.outbound.protection.outlook.com [40.93.195.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50A6303CBD;
	Mon, 24 Nov 2025 11:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763985592; cv=fail; b=nEcCVPFvQWFM00ZtmTBZ4DSto0T5zH5PClFWG8V5YLA0oxJKlEKxE5fTAQrXm0bKmIsK5qAf5bzT7WhMh+ftzMShuHR8X6Ygna2tSXJ5L5maAijZawxm7vFjRcRRVfs1gTyPsiWEb0doYG7+Lav21WPJJc5+tmlz4A8m6LckV3U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763985592; c=relaxed/simple;
	bh=zDfUpyKQzVLdASLpke6+BoRVUhvItJMfJGYXl5XBPIo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jhpko7GXVX+Q99Pxv1s+o0tSstSHLjqRskZmOZQl+87fCzlpj2ZmiAIsQadgycG/h7/APHoAGdbUgmQ8iqrelqkSt26EqZD/HsMi6FgbHp8iEqAHfUPiiD/U3oiId1AwMal5L8qwQmUVqV4/BQdGZubKOY/IZcUWW2nPtmRDbCI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=J0x1ECGe; arc=fail smtp.client-ip=40.93.195.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iGfNKbRNROWlMVqZljDjqJ1F8XPR0UhQlLqwuR2a8WcHO52BzRhPSos+cDAX6YJTaWKps4OEfpqQK8JqIzamXQK1mPjRR/a5LY/da6fDrFMZU6C4a3u8UORcFQylyz4OXt2dAcdhfqT/rbl5MZTfYYDHWdqs8p7fkB+swp55URRdkpbLLSuKXLumT6Gor3HpJ+OqUNddm6pbYgxDG6NIrrztAJ25mt0xHsceaz9DXudLottHTJyc8mWvnu/awGEQ0M+iPmSOn3SSrcTqwQNhRgYgeKeJfc4HG5Q1vF+WYhMx1D4Wz1QGcFdOZLEepWloQPLilSm49SzTQ4Z1gqZJxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ny3ddmRRQjk2t8UZk7vftuDpDkChe6nFIH5m/4F9Bdk=;
 b=e55GQ62c3FW4qpaPmNartP159tLghU7RXunvSmvcBPdar4p7aIczVO9nAskhwBn6wZH+jmKCDpRs1XJzHzKy8MBMrMCvXcFz/AsHbRypGnf6MSCyKP/wu65dSP05yTDIqMLAQzcIbUikQyK4tB1das0jMtW3KoL39ca3zijFCymVOE2lGo3xSokCQWJ48eUi+Zdm+Cjh/YlkhcBUrkTX2gXY2RhA68QSTqPceE6GEewdcOXe6j7EayhO9U7ti+WfyoSz40iGMg9rEEYwYwEmHvYipYKZtwwLSWHMYmPfipvEI8QBYru0UooXdtz6U8OmD+y5NN5fG9t2Ml/xjv7LHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ny3ddmRRQjk2t8UZk7vftuDpDkChe6nFIH5m/4F9Bdk=;
 b=J0x1ECGe+FUpv26Z2br9M5IFsDhFOOxV2/sy6eJkc8N8zWV5sZNVPwrjejWSF7O2QVQGIHHjdCDB9X56kK4KTt4v4W2su7btvj7Cm8w/oZyLPjg5yuOhcaChonnalfVURx6eJvSivS/F15W6v/nQGQCDZvpX30CwNgZ6Gu/EY5U7MG7GdMDWD8bxf+Dn08rb/yMlmDJ/oeIsP9Peg1Ij2FBdIi5jgBnSYtg+cMyi0d2GViTQY4ip+HqshKKHHpEv8aBjRnLMPbuNuMpVSqGAp23/Ei1cvN5EaOEJG9Zh3CAh474XbZK+Ryd3BgVCRm8n1023T+tBncZrLiY7aEdXUg==
Received: from SJ0PR13CA0053.namprd13.prod.outlook.com (2603:10b6:a03:2c2::28)
 by DM4PR12MB7575.namprd12.prod.outlook.com (2603:10b6:8:10d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 11:59:43 +0000
Received: from SJ5PEPF000001C9.namprd05.prod.outlook.com
 (2603:10b6:a03:2c2:cafe::31) by SJ0PR13CA0053.outlook.office365.com
 (2603:10b6:a03:2c2::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.8 via Frontend Transport; Mon,
 24 Nov 2025 11:59:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ5PEPF000001C9.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Mon, 24 Nov 2025 11:59:43 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 24 Nov
 2025 03:59:32 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 24 Nov 2025 03:59:31 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Mon, 24 Nov 2025 03:59:31 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@ziepe.ca>, <yishaih@nvidia.com>,
	<skolothumtho@nvidia.com>, <kevin.tian@intel.com>, <alex@shazbot.org>,
	<aniketa@nvidia.com>, <vsethi@nvidia.com>, <mochs@nvidia.com>
CC: <Yunxiang.Li@amd.com>, <yi.l.liu@intel.com>,
	<zhangdongdong@eswincomputing.com>, <avihaih@nvidia.com>,
	<bhelgaas@google.com>, <peterx@redhat.com>, <pstanner@redhat.com>,
	<apopple@nvidia.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<cjia@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <danw@nvidia.com>, <dnigam@nvidia.com>, <kjaju@nvidia.com>
Subject: [PATCH v5 7/7] vfio/nvgrace-gpu: wait for the GPU mem to be ready
Date: Mon, 24 Nov 2025 11:59:26 +0000
Message-ID: <20251124115926.119027-8-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251124115926.119027-1-ankita@nvidia.com>
References: <20251124115926.119027-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001C9:EE_|DM4PR12MB7575:EE_
X-MS-Office365-Filtering-Correlation-Id: be93d6d8-c89c-4abd-f6b7-08de2b50f47e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ETVkwsYJXhqPXWWRM0VKnVQpy8UvD07boCPlqnPUot9hkRzwieANiPKawcWF?=
 =?us-ascii?Q?3DTwiGjCA9NHKLA9OhleK5scqqKlGAiG7vioC4/I50SmCib8f4yoE4BRpM3n?=
 =?us-ascii?Q?LrD5hsphmNywcVNShLarUOsF7Ue4J+MSwCs0lsPl8kDPJGI1rsaWGOG48M/2?=
 =?us-ascii?Q?js+F1GDr6sqRe6DId9y/MN3gJRPqY20EIwgcZEs3Q3BBljN+KWbZm/wmINbg?=
 =?us-ascii?Q?hKWESgTwso7gGyRqdc1fKJiI3ZXLfJWSlSuvIZJglkg4wJ47NgEsBXFjsGNj?=
 =?us-ascii?Q?tD3QV7FuhBpdduuYHhq7I5tE+fwY9q8wzwcJz28VZPPFLV06UxntIlknxCAG?=
 =?us-ascii?Q?katWLbyCSgk1yjjd60y/xWxg2wUKckOmUe4FoVeg9vBo0+UxhGHx2tIcb8/X?=
 =?us-ascii?Q?hYwhzurJUXHQVt5F6vbo+AXkGsWCU7P2pTeCZXKPv/ThpJD1XnDTkm4ML8fY?=
 =?us-ascii?Q?rLg/f2AWy4rUTQhpk42vJnXzYOEGkSdytN0Pvrbv/DLpBxOwXHA7O9G5xIzx?=
 =?us-ascii?Q?YvNelhxzLfEdC/t2qN7MYpN8qvKqKtRCPdZqLfHHPAtXetDTNRB38Xau6B0v?=
 =?us-ascii?Q?DZn1vrSjDVHJa46zsdZNng2LvJZt/vGSCyvB1LzSeWMReJFHjhw9ucgx9c4b?=
 =?us-ascii?Q?lQhru3NAZLw7hwVNBjUhTlbUmvXsMGNzVqv7zx2YhhfWLRgPeeUFzhW5JhWV?=
 =?us-ascii?Q?1ORvmkb0IS9X/YzkBVDb+kVQx+bbHiYgsQPeyqcZ4vM7onSaNfqxhj+beT/l?=
 =?us-ascii?Q?sMDcATW2XYSU/3zxa7SNy/xgzlnvq09Hljqmf0g8yenJhaXWpgP98HhdO8cj?=
 =?us-ascii?Q?CGQ6YY0N7RGfyzE/6qasN20SobMS4HXoDbltpHUDG0kPZh5thFz6gSngznfu?=
 =?us-ascii?Q?uDV9HCGXYaLC6LZfnpKFq5AUqsfq9L2/lXOOgum7sn66lMWi9eSQH/5WQDnB?=
 =?us-ascii?Q?ytywjRhMsMpL7030i7NvrFbjg779wjyKw/9MKmnIoTYsAKui53RdS8SLXc3n?=
 =?us-ascii?Q?MMHmH1pGzT6MMej+FOIDEroht54qSiRamLIPkd4OrHEbjNg+AWniK0fLqHYW?=
 =?us-ascii?Q?eS7kZnNKSCi4G68SZLcgdNHTfxL/jmSHf+2QV6XEnEAip+klr0B/35J6CoHM?=
 =?us-ascii?Q?Qduo6N+Z7F2irNHFhYe2b1k7Ih6r17ss245XkIeaZl1b397ct/YMhJlMju8u?=
 =?us-ascii?Q?KTRn1oI/79Shcgkh/NlwlNNvu+XLjrxoFMyRq7HaSEL4MWpl0j27eE/5Klce?=
 =?us-ascii?Q?kl9gmEccwpIRS298MO/eOSbKIqUnQfboJlScnMA6l1aq6OkO0E5ApXbllYxm?=
 =?us-ascii?Q?/n1I3EtGyye1RbMp+eji4oYu6+NcCKqeTg+0dwPq4jB4vxSjO1EqjAC+sRtr?=
 =?us-ascii?Q?hh+Dn7K9Opuf8UJOygjYmlJ8rsHMahMACSOP7aqr0pwi0dAKg1q9EwNBIqFv?=
 =?us-ascii?Q?t2dPFgqWTogZcYb+/AKkZ3xrHMVMbc+wzMx0eWSpFQey5TjXexE5utZKXiWD?=
 =?us-ascii?Q?EHG3HabRjRwZAKryTzJeI+9F1s/Ob9vABxfYfgaMPLu+GxGLX+VZpBiS7CuG?=
 =?us-ascii?Q?j98ORtTI+yYctRvAwp4=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 11:59:43.2281
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: be93d6d8-c89c-4abd-f6b7-08de2b50f47e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001C9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7575

From: Ankit Agrawal <ankita@nvidia.com>

Speculative prefetches from CPU to GPU memory until the GPU is
ready after reset can cause harmless corrected RAS events to
be logged on Grace systems. It is thus preferred that the
mapping not be re-established until the GPU is ready post reset.

The GPU readiness can be checked through BAR0 registers similar
to the checking at the time of device probe.

It can take several seconds for the GPU to be ready. So it is
desirable that the time overlaps as much of the VM startup as
possible to reduce impact on the VM bootup time. The GPU
readiness state is thus checked on the first fault/huge_fault
request or read/write access which amortizes the GPU readiness
time.

The first fault and read/write checks the GPU state when the
reset_done flag - which denotes whether the GPU has just been
reset. The memory_lock is taken across map/access to avoid
races with GPU reset.

cc: Alex Williamson <alex@shazbot.org>
cc: Jason Gunthorpe <jgg@ziepe.ca>
cc: Vikram Sethi <vsethi@nvidia.com>
Suggested-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 79 ++++++++++++++++++++++++++---
 1 file changed, 72 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index bef9f25bf8f3..fbc19fe688ca 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -104,6 +104,17 @@ static int nvgrace_gpu_open_device(struct vfio_device *core_vdev)
 		mutex_init(&nvdev->remap_lock);
 	}
 
+	/*
+	 * GPU readiness is checked by reading the BAR0 registers.
+	 *
+	 * ioremap BAR0 to ensure that the BAR0 mapping is present before
+	 * register reads on first fault before establishing any GPU
+	 * memory mapping.
+	 */
+	ret = vfio_pci_core_setup_barmap(vdev, 0);
+	if (ret)
+		return ret;
+
 	vfio_pci_core_finish_enable(vdev);
 
 	return 0;
@@ -150,6 +161,26 @@ static int nvgrace_gpu_wait_device_ready(void __iomem *io)
 	return ret;
 }
 
+static int
+nvgrace_gpu_check_device_ready(struct nvgrace_gpu_pci_core_device *nvdev)
+{
+	struct vfio_pci_core_device *vdev = &nvdev->core_device;
+	int ret;
+
+	lockdep_assert_held_read(&vdev->memory_lock);
+
+	if (!nvdev->reset_done)
+		return 0;
+
+	ret = nvgrace_gpu_wait_device_ready(vdev->barmap[0]);
+	if (ret)
+		return ret;
+
+	nvdev->reset_done = false;
+
+	return 0;
+}
+
 static vm_fault_t nvgrace_gpu_vfio_pci_huge_fault(struct vm_fault *vmf,
 						  unsigned int order)
 {
@@ -173,8 +204,18 @@ static vm_fault_t nvgrace_gpu_vfio_pci_huge_fault(struct vm_fault *vmf,
 		      pfn & ((1 << order) - 1)))
 		return VM_FAULT_FALLBACK;
 
-	scoped_guard(rwsem_read, &nvdev->core_device.memory_lock)
+	scoped_guard(rwsem_read, &nvdev->core_device.memory_lock) {
+		/*
+		 * If the GPU memory is accessed by the CPU while the GPU is
+		 * not ready after reset, it can cause harmless corrected RAS
+		 * events to be logged. Make sure the GPU is ready before
+		 * establishing the mappings.
+		 */
+		if (nvgrace_gpu_check_device_ready(nvdev))
+			return ret;
+
 		ret = vfio_pci_vmf_insert_pfn(vmf, pfn, order);
+	}
 
 	return ret;
 }
@@ -593,9 +634,21 @@ nvgrace_gpu_read_mem(struct nvgrace_gpu_pci_core_device *nvdev,
 	else
 		mem_count = min(count, memregion->memlength - (size_t)offset);
 
-	ret = nvgrace_gpu_map_and_read(nvdev, buf, mem_count, ppos);
-	if (ret)
-		return ret;
+	scoped_guard(rwsem_read, &nvdev->core_device.memory_lock) {
+		/*
+		 * If the GPU memory is accessed by the CPU while the GPU is
+		 * not ready after reset, it can cause harmless corrected RAS
+		 * events to be logged. Make sure the GPU is ready before
+		 * establishing the mappings.
+		 */
+		ret = nvgrace_gpu_check_device_ready(nvdev);
+		if (ret)
+			return ret;
+
+		ret = nvgrace_gpu_map_and_read(nvdev, buf, mem_count, ppos);
+		if (ret)
+			return ret;
+	}
 
 	/*
 	 * Only the device memory present on the hardware is mapped, which may
@@ -713,9 +766,21 @@ nvgrace_gpu_write_mem(struct nvgrace_gpu_pci_core_device *nvdev,
 	 */
 	mem_count = min(count, memregion->memlength - (size_t)offset);
 
-	ret = nvgrace_gpu_map_and_write(nvdev, buf, mem_count, ppos);
-	if (ret)
-		return ret;
+	scoped_guard(rwsem_read, &nvdev->core_device.memory_lock) {
+		/*
+		 * If the GPU memory is accessed by the CPU while the GPU is
+		 * not ready after reset, it can cause harmless corrected RAS
+		 * events to be logged. Make sure the GPU is ready before
+		 * establishing the mappings.
+		 */
+		ret = nvgrace_gpu_check_device_ready(nvdev);
+		if (ret)
+			return ret;
+
+		ret = nvgrace_gpu_map_and_write(nvdev, buf, mem_count, ppos);
+		if (ret)
+			return ret;
+	}
 
 exitfn:
 	*ppos += count;
-- 
2.34.1


