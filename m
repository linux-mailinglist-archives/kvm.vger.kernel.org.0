Return-Path: <kvm+bounces-56702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B31EEB42C90
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 00:11:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 75538564A7E
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 22:11:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADB072EDD64;
	Wed,  3 Sep 2025 22:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nYNxdfro"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2076.outbound.protection.outlook.com [40.107.243.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0412ECD14
	for <kvm@vger.kernel.org>; Wed,  3 Sep 2025 22:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756937497; cv=fail; b=af4WbUWKCMyQA1+FKqWqpK1IL1P2I07ehNMeP95Lo11vkkmyTV5Y/NkwSN+E1XZSG2IP9R6eaqcjAwTY2yfJEXcup19AFn8HwmKe1cyh2r10F+g2BszQjV4joFldMqtG8TlzTP4r4J5uThOWIztWXrAjxjEhQJzlqZzLQXbqOPQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756937497; c=relaxed/simple;
	bh=XwNvJRMdFy0VzymlxIv7esqXjZdsYg/U5A9BBYa0aRU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D5rS7lGlUKMqoicQhf9XqLi9u2AoewkjOZ1nqI7MCqchd22xMyx6/xz/9jArimSBqCHpvNkxtILwwYpLtx+WyEiyLzNb6hmv2IVdwiEg5RG2ncItf9MUap5CfhyyAw9QdqN/EwMKtTRL+GSKpkGxi6w9RqLD+dweOQU7H37npBg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nYNxdfro; arc=fail smtp.client-ip=40.107.243.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r8F0vUYlSQ5e5q+H6BLYDbr4Ios0IyLSeyRPCInk3B4hMzJ0tq738h0zz4y+zMhILmZvqU8APpamVWm4Lf+OeRWtqYXlJ97ajnhtdCM8Cho8F6WzdvgSCD1VEZyicYRI0l9q5ody4yU3mKqTIU5/V4CBQfNTXJvpISWUEN2FN02XxJ23THY322LdjHF56WaXHwAu4FBU6Tb6MfQRvUMokqc66o6hOxQ2HvCJbPjp6RbXPgq81r9RXW0PUA/CO5kziI8C0OV0wxjo1Vl7AY4fI/KDbh3A2LWxEi26nlyKsm0fZnPbquu9fepDR8jex6hhEfK6w6K8ya++Y2jwVXZCHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1F2mi8lLOJeo7N8ipk7Ml/TqTNu84nJbVZzbHRYEnhk=;
 b=XAe5QWmNZzPigGz81NfN38Qhrj+kCVdrRHs6RZNf+3ah8iRf1hJWJKGxdv4WbYVGVVHdkLe6UYVGbtYudGqjF5RNHDiLZABselrOZN9RMcVRu6n3aV1WROHC4nRPhyESbcdxHDst9KP4+IA3Atj8fAsLhjLRjcGzXQOd8KnF+yyieoaoWXJ9viINN1eouoXLd5Xy8uOxzDQGl4Onng/YGVXAudvoTD8bAEOQ/Q6YMR7tOo3T1my5yC0ZRtoiGeXO8jiB4SmtFX4lDiGXdVU5D6WY0mcpM/lG4CvoJa32dvwAAnRG+mRS9CA+QZWuxtj/C6VBZUUyy/73eDBoPBQZIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1F2mi8lLOJeo7N8ipk7Ml/TqTNu84nJbVZzbHRYEnhk=;
 b=nYNxdfroBFX/7dO18tSTt8Y+zOKrNTHNj09QhxEmCOF2V5hwGBie8s72JR1HoxmACRSF9PsvjCNwiF3DjgOC0nGBUI96p9ShBvxpHoQO2oJQ1zYAKX0FHHkyUKSf/mVzRhusloVBJhGg1K7GZ+ADmSgpyUxI6bDTgF7A4QRcNvVNF/Tw/HCxrOZ+gvmoqqTB1gqh6IMLXi2kvCoha/Az4ALF4MxJYRlvpJJ2wQlvw6+/eLf3hnFOQGjEbueWNi3+gadIWIPFfNr+oIfU7XYr4zVMQc8dFYfDi4vZ+V4XcJAcntjTe5bmCYdEed662O8POj3bBnWYn+lq5xmq6SpgwQ==
Received: from CH2PR02CA0006.namprd02.prod.outlook.com (2603:10b6:610:4e::16)
 by SA3PR12MB8804.namprd12.prod.outlook.com (2603:10b6:806:31f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Wed, 3 Sep
 2025 22:11:32 +0000
Received: from CH3PEPF0000000C.namprd04.prod.outlook.com
 (2603:10b6:610:4e:cafe::83) by CH2PR02CA0006.outlook.office365.com
 (2603:10b6:610:4e::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.16 via Frontend Transport; Wed,
 3 Sep 2025 22:11:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH3PEPF0000000C.mail.protection.outlook.com (10.167.244.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.14 via Frontend Transport; Wed, 3 Sep 2025 22:11:32 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 15:11:18 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 15:11:17 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Wed, 3 Sep 2025 15:11:17 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <dakr@kernel.org>,
	<acurrid@nvidia.com>, <cjia@nvidia.com>, <smitra@nvidia.com>,
	<ankita@nvidia.com>, <aniketa@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC v2 07/14] vfio/nvidia-vgpu: map mgmt heap when creating a vGPU
Date: Wed, 3 Sep 2025 15:11:04 -0700
Message-ID: <20250903221111.3866249-8-zhiw@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000C:EE_|SA3PR12MB8804:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c924e4c-f7c6-4818-61b5-08ddeb36d6ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MkuiE3KnkfssMMPVdviqjDgWtYyTSuCH3gH8wCCFU3Efba0DqlqIPLlOSmY4?=
 =?us-ascii?Q?GH2YTRXoeig4eTUzJJg6zzsyE7XbEeq8s+6Qxn6XFJ5KSUlaYMgSG4AOQqUf?=
 =?us-ascii?Q?nmRMzJ3b3asc2/VvxHCwuVtpUbfRlEShOk6RUl2O04Rx7UZEbQw1eOIyQTuM?=
 =?us-ascii?Q?q8EdZqEzS58UE3X60oryGkIPp64kuVA0SXNUVaVXN9uSjCKzEWvtf8EY2GeZ?=
 =?us-ascii?Q?W915mMUN/QhEQ6q53+M5x1wPV0VUN5sFMw78FVZp67EZNuSoCtuxPgcpI3pT?=
 =?us-ascii?Q?HmIiYAd4EmS9wIas1Hf1paKEnHG2Ue4atCTDnlVjJkcYX/c5yJ3CbEGz7szM?=
 =?us-ascii?Q?88E2vGvAe+pg4zuO4OZAlbd9NOsvLluDHef3LI8U04PpG09SEZWgmoHr9nGw?=
 =?us-ascii?Q?7udP2Def7KlX0i5FG6h1CvwpfeceCcJYT2o2Ac6iwmHnAoyZLup9yvsELuEw?=
 =?us-ascii?Q?2odctPMPe0ZiRETJz1Im0KqdjoIdDdAYtU3W/FUVen/s9O1vAO9A1L24bpb8?=
 =?us-ascii?Q?OM3WvzPzYIE2Tt287GIwxvvpvTFVaNix/uyGyUfX8C0yLQLCsBZiW5OrFgRc?=
 =?us-ascii?Q?ZCLNXE4g+BRDULTZZqMBihgkaElH8duccZS2cx3b+659IqkhjtOEdDwlIbgK?=
 =?us-ascii?Q?2oDN0YYwNmcYZh6nQNelURpxpYkOWRJpndBvfBDT/Qps7+l6PCGNcb3F2aH9?=
 =?us-ascii?Q?ZMK3LRkuRn2xTgCOeJNU5f5nfOqBU//i6cyKdZRM2pqmUHsB5gr3ara2H1OP?=
 =?us-ascii?Q?0VaWqXyjeZ96XDp4Uda9bcnw8Aqa1+rdHukclqJsvIQDbYHrtE9zBbidQi9t?=
 =?us-ascii?Q?MPc3UW2giA5fCbLVX1JWfNYELjzh8v4q++hel3sR0TI8VsP9IHnogRlKt5LA?=
 =?us-ascii?Q?J0uLY0wPIZcG9H6aKUBKjm84VS8aJhT5Do2iQ+gWy3aZ08K9EcEqvSho6vOa?=
 =?us-ascii?Q?Xro5w1rCRqixs4QL5Du5c8cfIGe/0B5AJZogiY+XsSvpadMOkachWaVSjLY0?=
 =?us-ascii?Q?B4WorwzCLvNCuI66phLygG5kkIoxDmZkqtuPkThC4cyFquYuEqJrR1wdNdGT?=
 =?us-ascii?Q?kz0IbO1dZEg5okFt1hx00xPMJgpAA+E/Z2J9CQo1s4q27x0ZVsoBYrLxMH7S?=
 =?us-ascii?Q?hulBexEEZOdWlhR32Z6LRGluYrrIenvOJSsJcjTxsh5FostajgqhUd3Axyg1?=
 =?us-ascii?Q?99WMKCc09lpTN5Vy3fp81EPzN9KiI1PRwjSZbeAI3YEFqrx4n8uCJotqKT3O?=
 =?us-ascii?Q?bS1HD9ukE4zXsntKp10w+8A29CGH7uvddha9qhvtgCzeYaXqvofSSMoh3Lpb?=
 =?us-ascii?Q?az5j1kSBmy5NFjyHKltDTWurshY9890/eY9KPTQVnwcDo6WbTv6cjTrcVk8V?=
 =?us-ascii?Q?15ba6qaes9F0a1BM2ZF1fa06OqpGEuZWEP0IyX7BknrGWVdR3UM2y9RUQbq4?=
 =?us-ascii?Q?GPzrWd3/gpKg1CXuLuszVkSyIw6k2PimMsJibKdRt+WlDHrTZW+hQjnwig25?=
 =?us-ascii?Q?MUVUIUaIYzoHC8JSmsBSWEXdP3n0I7FNziEZ?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 22:11:32.2700
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c924e4c-f7c6-4818-61b5-08ddeb36d6ff
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8804

The mgmt heap is a block of shared FB memory between the GSP firmware
and the vGPU host. It is used for supporting vGPU RPCs, vGPU logging.

To access the data structures of vGPU RPCs and vGPU logging, the mgmt
heap FB memory needs to mapped into BAR1 and the region in the BAR1 is
required to be mapped into CPU vaddr.

Map the mgmt heap FB memory into BAR1 and map the related BAR1 region
into CPU vaddr. Initialize the pointers to the mgmt heap FB memory.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 drivers/vfio/pci/nvidia-vgpu/pf.h       |  6 ++++++
 drivers/vfio/pci/nvidia-vgpu/vgpu.c     | 23 ++++++++++++++++++++++
 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c | 26 +++++++++++++++++++++++++
 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h | 17 +++++++++++++++-
 4 files changed, 71 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/nvidia-vgpu/pf.h b/drivers/vfio/pci/nvidia-vgpu/pf.h
index ce2728ce969b..167296ba7e3d 100644
--- a/drivers/vfio/pci/nvidia-vgpu/pf.h
+++ b/drivers/vfio/pci/nvidia-vgpu/pf.h
@@ -103,4 +103,10 @@ static inline int nvidia_vgpu_mgr_init_handle(struct pci_dev *pdev,
 #define nvidia_vgpu_mgr_free_fbmem(m, h) \
 	((m)->handle.ops->free_fbmem(h))
 
+#define nvidia_vgpu_mgr_bar1_map_mem(m, mem, info) \
+	((m)->handle.ops->bar1_map_mem(mem, info))
+
+#define nvidia_vgpu_mgr_bar1_unmap_mem(m, mem) \
+	((m)->handle.ops->bar1_unmap_mem(mem))
+
 #endif
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu.c b/drivers/vfio/pci/nvidia-vgpu/vgpu.c
index 53c2da0645b3..4c106a9803f6 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu.c
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu.c
@@ -177,10 +177,14 @@ static void clean_mgmt_heap(struct nvidia_vgpu *vgpu)
 	struct nvidia_vgpu_mgr *vgpu_mgr = vgpu->vgpu_mgr;
 	struct nvidia_vgpu_mgmt *mgmt = &vgpu->mgmt;
 
+	nvidia_vgpu_mgr_bar1_unmap_mem(vgpu_mgr, mgmt->heap_mem);
+
 	vgpu_debug(vgpu, "free mgmt heap, offset 0x%llx size 0x%llx\n", mgmt->heap_mem->addr,
 		   mgmt->heap_mem->size);
 
 	nvidia_vgpu_mgr_free_fbmem(vgpu_mgr, mgmt->heap_mem);
+	mgmt->init_task_log_vaddr = mgmt->vgpu_task_log_vaddr = NULL;
+	mgmt->ctrl_vaddr = mgmt->kernel_log_vaddr = NULL;
 	mgmt->heap_mem = NULL;
 }
 
@@ -191,7 +195,9 @@ static int setup_mgmt_heap(struct nvidia_vgpu *vgpu)
 	struct nvidia_vgpu_info *info = &vgpu->info;
 	struct nvidia_vgpu_type *vgpu_type = info->vgpu_type;
 	struct nvidia_vgpu_alloc_fbmem_info alloc_info = {0};
+	struct nvidia_vgpu_map_mem_info map_info = {0};
 	struct nvidia_vgpu_mem *mem;
+	int ret;
 
 	alloc_info.size = vgpu_type->gsp_heap_size;
 
@@ -203,6 +209,23 @@ static int setup_mgmt_heap(struct nvidia_vgpu *vgpu)
 
 	vgpu_debug(vgpu, "mgmt heap offset 0x%llx size 0x%llx\n", mem->addr, mem->size);
 
+	map_info.map_size = vgpu_mgr->comm_buff_size;
+
+	ret = nvidia_vgpu_mgr_bar1_map_mem(vgpu_mgr, mem, &map_info);
+	if (ret) {
+		nvidia_vgpu_mgr_free_fbmem(vgpu_mgr, mem);
+		return ret;
+	}
+
+	vgpu_debug(vgpu, "mgmt heap mapped\n");
+
+	mgmt->ctrl_vaddr = mem->bar1_vaddr;
+	mgmt->init_task_log_vaddr = mgmt->ctrl_vaddr +
+				    vgpu_mgr->init_task_log_offset;
+	mgmt->vgpu_task_log_vaddr = mgmt->init_task_log_vaddr +
+				    vgpu_mgr->init_task_log_size;
+	mgmt->kernel_log_vaddr = mgmt->vgpu_task_log_vaddr +
+				 vgpu_mgr->vgpu_task_log_size;
 	mgmt->heap_mem = mem;
 	return 0;
 }
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c
index e8b670308b21..cf5dd9a8e258 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c
@@ -154,6 +154,30 @@ static int setup_chid_alloc_bitmap(struct nvidia_vgpu_mgr *vgpu_mgr)
 	return 0;
 }
 
+static void init_gsp_rm_constraints(struct nvidia_vgpu_mgr *vgpu_mgr)
+{
+	vgpu_mgr->comm_buff_size = (3 * SZ_4K) + SZ_2M + SZ_4K + SZ_128K + SZ_256K + SZ_64K;
+	vgpu_mgr->init_task_log_offset = (3 * SZ_4K) + SZ_2M + SZ_4K;
+	vgpu_mgr->init_task_log_size = SZ_128K;
+	vgpu_mgr->vgpu_task_log_size = SZ_256K;
+	vgpu_mgr->kernel_log_size = SZ_64K;
+
+	vgpu_mgr_debug(vgpu_mgr, "[GSP RM constraint] comm_buff_size 0x%llx\n",
+		       vgpu_mgr->comm_buff_size);
+
+	vgpu_mgr_debug(vgpu_mgr, "[GSP RM constraint] init_task_log_offset 0x%llx\n",
+		       vgpu_mgr->init_task_log_offset);
+
+	vgpu_mgr_debug(vgpu_mgr, "[GSP RM constraint] init_task_log size 0x%llx\n",
+		       vgpu_mgr->init_task_log_size);
+
+	vgpu_mgr_debug(vgpu_mgr, "[GSP RM constraint] vgpu_task_log size 0x%llx\n",
+		       vgpu_mgr->vgpu_task_log_size);
+
+	vgpu_mgr_debug(vgpu_mgr, "[GSP RM constraint] kernel_log size 0x%llx\n",
+		       vgpu_mgr->kernel_log_size);
+}
+
 static int init_vgpu_mgr(struct nvidia_vgpu_mgr *vgpu_mgr)
 {
 	int ret;
@@ -178,6 +202,8 @@ static int init_vgpu_mgr(struct nvidia_vgpu_mgr *vgpu_mgr)
 	vgpu_mgr_debug(vgpu_mgr, "[core driver] total fbmem size 0x%llx\n",
 		       vgpu_mgr->total_fbmem_size);
 
+	init_gsp_rm_constraints(vgpu_mgr);
+
 	return vgpu_mgr->use_chid_alloc_bitmap ? setup_chid_alloc_bitmap(vgpu_mgr) : 0;
 }
 
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
index facecd060856..9a3af35e5eee 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
@@ -51,7 +51,10 @@ struct nvidia_vgpu_chid {
 
 struct nvidia_vgpu_mgmt {
 	struct nvidia_vgpu_mem *heap_mem;
-	/* more to come */
+	void __iomem *ctrl_vaddr;
+	void __iomem *init_task_log_vaddr;
+	void __iomem *vgpu_task_log_vaddr;
+	void __iomem *kernel_log_vaddr;
 };
 
 /**
@@ -91,6 +94,11 @@ struct nvidia_vgpu {
  * @total_fbmem_size: total FB memory size
  * @vmmu_segment_size: VMMU segment size
  * @ecc_enabled: ECC is enabled in the GPU
+ * @comm_buff_size: communication buffer size of mgmt heap
+ * @init_task_log_offset: offset of init task log in mgmt heap
+ * @init_task_log_size: size of init task size in mgmt heap
+ * @vgpu_task_log_size: size of vgpu task log size in mgmt heap
+ * @kernel_log_size: size of kernel log size in mgmt heap
  * @vgpu_major: vGPU major version
  * @vgpu_minor: vGPU minor version
  * @vgpu_list_lock: lock to protect vGPU list
@@ -114,6 +122,13 @@ struct nvidia_vgpu_mgr {
 	u64 vmmu_segment_size;
 	bool ecc_enabled;
 
+	/* GSP RM constraints */
+	u64 comm_buff_size;
+	u64 init_task_log_offset;
+	u64 init_task_log_size;
+	u64 vgpu_task_log_size;
+	u64 kernel_log_size;
+
 	u64 vgpu_major;
 	u64 vgpu_minor;
 
-- 
2.34.1


