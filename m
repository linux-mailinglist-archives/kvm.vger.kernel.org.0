Return-Path: <kvm+bounces-56707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D218B42C95
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 00:12:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52B2D3A8C48
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 22:12:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D0742EFDAB;
	Wed,  3 Sep 2025 22:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tJmRTYfJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2085.outbound.protection.outlook.com [40.107.220.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F592ECE82
	for <kvm@vger.kernel.org>; Wed,  3 Sep 2025 22:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756937501; cv=fail; b=ovRNGjH0p+x3Dna8x9X5j4q5vR6bmUkdHo4uTA1uOZuuhesXv7VJVP4u7d8bHjNE/Q26wiLHefsiixjypT6yUIlt6xlFvhNWNMZxOh8ZIL7Zpq+ceYkBrsYUfraHpdOQMW0GdW01V+qnxUmOQld19pLiw4MmWPDeNNo+3FME7Ik=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756937501; c=relaxed/simple;
	bh=s8z9YVkWDCUdCAXCxc3RZzV8W0lCBHr6FjSmUZ80K9U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k6UmRuGuOU0zjKGbxl9/SOBLoy5CPl35xbY35B2J3cDZ4Jlo1k0XC9KI7AwzWlKlCL1k198UuOd8aBXHWI1QYYke1hutBP/wcUAMDDGGZA4zaI4dx6cS8yuNdjtScTpqz/QDboQP8uVxa/YE761ahFalSUU/4BZqZyI2GiEPoPM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tJmRTYfJ; arc=fail smtp.client-ip=40.107.220.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j6jcvDMQwDugrt9Sltpbeg009qwWfXC7zfrTmXFfufVBct2R/tP2gD0XbAV+qgzOVa3yqkfLaKxd3iSUdCnVZEY0UWe70R8fe6pG0/N+2LekHkjqUUunIAjEzuLdN91ihaHy8r1256DEsNjxbvHZmVL2IOBf9sAWejUNtqob4gUh7JQqqHZHgRr3c4q0vPyWap2fWkDIBEBRk4p2ennKx490Mn5rStFaG7ztSzX1me5JV9d65n7EKGv07Y4jvbnZjYFqaojEGe9UNj4UjagIR1rV9Tm6ajfrvpEPklRODVO6WK7PbhrvNLBUcI99Lav0EhuX1pUAiqczMkVAG0pE0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZrqtfhjdJA+aW9MVVcrlV7XEAaIKcB/RWLGKGx7GmgU=;
 b=htKAL1BqCQpBnZ8iSdXxqW0WA69FMGoCIdHDKVnlCI6Ug6vVyb5AeN9cY7o3o+vAgMZXGcAJ/CljTrRY/5DMolzHYiMPMSM/aus8aTj7IkuOdfV7EKNuHxQOURg2eBlxHHo9GZQPif+CGUVMVCOgXzXs6hY8Nv/5aBbVbPH8JCCC82scV/FGQOJfWtGOqadee2nMbRVHyH4dHulgKqcWjf+Ruid8H+dXHEvHryGUAvPYQfH/Hkn/mHnhv4E825Ga8frphX8svd8XDSFpCXTIW1f8LmeainZcE9CyOAqfMRc5QtpOVOLlehWOxhYWIAd70KRORMT0rlGkK/H17BF9qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZrqtfhjdJA+aW9MVVcrlV7XEAaIKcB/RWLGKGx7GmgU=;
 b=tJmRTYfJ5l7JTf8XhJj2oyDP4HIpNhKNPSJMTZSHDQ3rVHp5Qw6O3SLJxgzPh+vU1/6ZRTnG7egXAkqrbslG5yMVZLOFmVQz4uxbUvSdhIjvBPOqMJqDMM5Y//YLaPphQ6C2/9z+zq72gBuPOU8EtgYUq7CDg9rCG5Coao2yR055VbhcCcmi3wotCOBwztNg7HLAwf1SUwiiUEcYeuvICOhHUyC/e7kP6xfHRi1SsX53mQPyPjNuBWeKewMvtsCKoEYIerpDrc0iJifFAt5jfsw7j0BUHuqX+QCw0Gy/E4Vj0ADsthEx2bvLfB2OE6l7GHqETTr5KbIZb4Hhfu/BSQ==
Received: from MN2PR20CA0064.namprd20.prod.outlook.com (2603:10b6:208:235::33)
 by BL4PR12MB9535.namprd12.prod.outlook.com (2603:10b6:208:591::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Wed, 3 Sep
 2025 22:11:37 +0000
Received: from BL02EPF00021F6D.namprd02.prod.outlook.com
 (2603:10b6:208:235:cafe::c) by MN2PR20CA0064.outlook.office365.com
 (2603:10b6:208:235::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.28 via Frontend Transport; Wed,
 3 Sep 2025 22:11:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF00021F6D.mail.protection.outlook.com (10.167.249.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.14 via Frontend Transport; Wed, 3 Sep 2025 22:11:37 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 15:11:17 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 15:11:16 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Wed, 3 Sep 2025 15:11:16 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <dakr@kernel.org>,
	<acurrid@nvidia.com>, <cjia@nvidia.com>, <smitra@nvidia.com>,
	<ankita@nvidia.com>, <aniketa@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC v2 06/14] vfio/nvidia-vgpu: allocate mgmt heap when creating vGPUs
Date: Wed, 3 Sep 2025 15:11:03 -0700
Message-ID: <20250903221111.3866249-7-zhiw@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250903221111.3866249-1-zhiw@nvidia.com>
References: <20250903221111.3866249-1-zhiw@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6D:EE_|BL4PR12MB9535:EE_
X-MS-Office365-Filtering-Correlation-Id: d299da8e-6310-4f84-1822-08ddeb36d9d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZiyacbkpjSXGM2KqU28Zn9QbawNACLh7ODNClmiVyvDEhohesNrDAIGnKKMj?=
 =?us-ascii?Q?C2e4lEtb1KBqzBUIoMzH2Y4N4OVgIffq0m7tOuTiK1X+g71iA+HEUnWdIhQp?=
 =?us-ascii?Q?MEOJOp0Q0an78pQ333SolD1EO3fAMFqdhJmMiMYZWdYuBhZIkMyJwwMK9Bhn?=
 =?us-ascii?Q?0cDLQRVrdUuAum2AhoJ3m5ZIleGmHJIbbo55KrqR4SM00AljbfzdnC9VF5zg?=
 =?us-ascii?Q?BTi38w9rjmZkilbiqOkdloWJl7W3zxn4OCVk2dhiQv4/LCnaO0rOsJ2jLWSC?=
 =?us-ascii?Q?nda2uiu3uRGgWKOZ1vKnHQ0hP/fAOG9neyu+b877lZPtAxRhU/r+ZMIOAtt6?=
 =?us-ascii?Q?sNX8TDhBGVuWHw9mkWMsh4wo/CMFC2LoqgE8ejSCCUlX6yVxcMJ/HjwMTroV?=
 =?us-ascii?Q?xEU5QX/gwlgvKIMnxyeoNvgktiUpt3TakFpBPWwZqMdpqwLxDy2l21OxrMuC?=
 =?us-ascii?Q?8M5sofHSgk9j9h1SHKObInjr1D+ZClg6mde7nxhfUyGD/LY/wqr5X5FXSywV?=
 =?us-ascii?Q?NDzvJR25ADY1QFDvzvhT0cGXlAoCbo2Fjni7AZWi3MCZVuXvqOenRxOKqfkg?=
 =?us-ascii?Q?zrYOLxPjj1zDMwP5cerP30usCR1LYFyrBlJtnHsrp+GAYYHEexG5dd+zzwQc?=
 =?us-ascii?Q?pZr4IO1K0UoeU5s+XHZnBs+GK9pfWJ0lIwebXUWXjMnUzDlEs8cwd5JvXsoU?=
 =?us-ascii?Q?Cbp8iM4TGxEsLm62uY/Gm+ZQy2hQ5ZoTohAcOwrQ3fvJ/bTdQBEtTY1KrNin?=
 =?us-ascii?Q?aSrZ5Tro4fD/IJ4P5eVKYx5X8Qw1DlybYgq/YMOti9hjJzCBR7fhlhApipTr?=
 =?us-ascii?Q?C08aQlIF1DFhAuRgNW0jR8wESkb/DDY0eB/JDZqWvbL0INOvxKJb54HlLESS?=
 =?us-ascii?Q?cXoUnzYOwN+l/7RaoeXITUvlVRYU4Vr8wh/r2AyuEY5aFhMk+sPr4kKtInyT?=
 =?us-ascii?Q?nMyGYuXeMOmyuboU/Ly+k9h47K3KND+9b65rSTMEtsIRlHwlA6mGy4KfkAeY?=
 =?us-ascii?Q?t2kr1ThFdcmQK/YHDhfSyqIC0Y42zJfKXg4Wi9s9zdogDem2O/egefPp1rwx?=
 =?us-ascii?Q?Zm93/8DsgWguf78lkrSkoTCvYkKrTNRyIlLRiXPgo3/NqE8O42SZOQwF8/+9?=
 =?us-ascii?Q?RMOWQkTzgNCDmvAwVzIb6bFfKTIzWUBBgkKgtbcXiJUYXqDQXihot3ra9ub8?=
 =?us-ascii?Q?uiHWJV3VaJGLmHLZ9Cx2SGIFLsmDDv9p8f87sZ6CI0oOnZzdSnfMkjRy5Gum?=
 =?us-ascii?Q?qms7Vx7ZFf+ZW0OI79plAa5i5TeHeiplM/lSEg80tu7DS8qnvwwBEiHWnKFf?=
 =?us-ascii?Q?kLSq9OZg+qisTwgPuJ9dCjcY4JhOfNShXQJMex57Fwy9VviT/wctQzxGyaDQ?=
 =?us-ascii?Q?GOwwkfJVpGklYdFfCIzIwA8PKBWdMM4hK1zdz8ocXpx69MKxlg5/gYGu58gF?=
 =?us-ascii?Q?xzLfxOTeVQjz9SkNaVopzgpherrBlYVzuvySh4nWUa5RDhqx9HWcr4pPf+G7?=
 =?us-ascii?Q?SJJjUxiBVzIGSywLcSc1WP+ATgOLqHh1PIVS?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 22:11:37.0051
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d299da8e-6310-4f84-1822-08ddeb36d9d5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9535

The mgmt heap is a block of shared FBMEM between the GSP firmware and
the vGPU host. It is used for supporting vGPU RPCs, vGPU logging.

Creating a vGPU requires allocating a mgmt heap from the FBMEM. The size
of the mgmt heap that a vGPU requires is from the vGPU type.

Acquire the size of mgmt heap from the vGPU type. Allocate the mgmt
heap from nvkm when creating a vGPU.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 drivers/vfio/pci/nvidia-vgpu/vgpu.c     | 42 +++++++++++++++++++++++++
 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h |  7 +++++
 2 files changed, 49 insertions(+)

diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu.c b/drivers/vfio/pci/nvidia-vgpu/vgpu.c
index 7025c7e2b9ac..53c2da0645b3 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu.c
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu.c
@@ -172,6 +172,41 @@ static int setup_fbmem_heap(struct nvidia_vgpu *vgpu)
 	return 0;
 }
 
+static void clean_mgmt_heap(struct nvidia_vgpu *vgpu)
+{
+	struct nvidia_vgpu_mgr *vgpu_mgr = vgpu->vgpu_mgr;
+	struct nvidia_vgpu_mgmt *mgmt = &vgpu->mgmt;
+
+	vgpu_debug(vgpu, "free mgmt heap, offset 0x%llx size 0x%llx\n", mgmt->heap_mem->addr,
+		   mgmt->heap_mem->size);
+
+	nvidia_vgpu_mgr_free_fbmem(vgpu_mgr, mgmt->heap_mem);
+	mgmt->heap_mem = NULL;
+}
+
+static int setup_mgmt_heap(struct nvidia_vgpu *vgpu)
+{
+	struct nvidia_vgpu_mgr *vgpu_mgr = vgpu->vgpu_mgr;
+	struct nvidia_vgpu_mgmt *mgmt = &vgpu->mgmt;
+	struct nvidia_vgpu_info *info = &vgpu->info;
+	struct nvidia_vgpu_type *vgpu_type = info->vgpu_type;
+	struct nvidia_vgpu_alloc_fbmem_info alloc_info = {0};
+	struct nvidia_vgpu_mem *mem;
+
+	alloc_info.size = vgpu_type->gsp_heap_size;
+
+	vgpu_debug(vgpu, "alloc mgmt heap, size 0x%llx\n", alloc_info.size);
+
+	mem = nvidia_vgpu_mgr_alloc_fbmem(vgpu_mgr, &alloc_info);
+	if (IS_ERR(mem))
+		return PTR_ERR(mem);
+
+	vgpu_debug(vgpu, "mgmt heap offset 0x%llx size 0x%llx\n", mem->addr, mem->size);
+
+	mgmt->heap_mem = mem;
+	return 0;
+}
+
 /**
  * nvidia_vgpu_mgr_destroy_vgpu - destroy a vGPU instance
  * @vgpu: the vGPU instance going to be destroyed.
@@ -183,6 +218,7 @@ int nvidia_vgpu_mgr_destroy_vgpu(struct nvidia_vgpu *vgpu)
 	if (!atomic_cmpxchg(&vgpu->status, 1, 0))
 		return -ENODEV;
 
+	clean_mgmt_heap(vgpu);
 	clean_fbmem_heap(vgpu);
 	clean_chids(vgpu);
 	unregister_vgpu(vgpu);
@@ -232,12 +268,18 @@ int nvidia_vgpu_mgr_create_vgpu(struct nvidia_vgpu *vgpu)
 	if (ret)
 		goto err_setup_fbmem_heap;
 
+	ret = setup_mgmt_heap(vgpu);
+	if (ret)
+		goto err_setup_mgmt_heap;
+
 	atomic_set(&vgpu->status, 1);
 
 	vgpu_debug(vgpu, "created\n");
 
 	return 0;
 
+err_setup_mgmt_heap:
+	clean_fbmem_heap(vgpu);
 err_setup_fbmem_heap:
 	clean_chids(vgpu);
 err_setup_chids:
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
index 356779404cc2..facecd060856 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
@@ -49,6 +49,11 @@ struct nvidia_vgpu_chid {
 	u32 num_plugin_channels;
 };
 
+struct nvidia_vgpu_mgmt {
+	struct nvidia_vgpu_mem *heap_mem;
+	/* more to come */
+};
+
 /**
  * struct nvidia_vgpu - per-vGPU state
  *
@@ -60,6 +65,7 @@ struct nvidia_vgpu_chid {
  * @vgpu_mgr: pointer to vGPU manager
  * @chid: vGPU channel IDs
  * @fbmem_heap: allocated FB memory for the vGPU
+ * @mgmt: vGPU mgmt heap
  */
 struct nvidia_vgpu {
 	/* Per-vGPU lock */
@@ -73,6 +79,7 @@ struct nvidia_vgpu {
 
 	struct nvidia_vgpu_chid chid;
 	struct nvidia_vgpu_mem *fbmem_heap;
+	struct nvidia_vgpu_mgmt mgmt;
 };
 
 /**
-- 
2.34.1


