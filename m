Return-Path: <kvm+bounces-27262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C96797E1B0
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 14:52:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A00D31C20A17
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 12:52:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7782336AF8;
	Sun, 22 Sep 2024 12:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="giKiWKdO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2061.outbound.protection.outlook.com [40.107.92.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34E12B9B4
	for <kvm@vger.kernel.org>; Sun, 22 Sep 2024 12:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727009451; cv=fail; b=G3pjNm4YjA1365sEmuKeH+TxHyUy13crju+TgpeMJtwKmNTQiWsE61T4Gid7pLK5vFDcQvYBdxnQmzwD7OoKZLKgH2KI3J9AncVzKGzw00X2KC2ooCP1CmvCeIY4PMI2yhZHeJbQDebyFhlBZQMaPKBfNd+KAnwKpyeyqDO1bSM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727009451; c=relaxed/simple;
	bh=Ps5eoVdtyCaKVvzSntQcnhA1Drhy/P2k6iIMfHY9LBQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=APbIcYLb9NMyQw1IYhb5aSPARcMLFja65FJEHGDhBZKR7sK2X9RepF44SoJNhLg5rQOXQGUA0Hl2E1FINTpjMVcqeW81tN/q36BeGQNpZky3QCk3ApgZbYmXwuGN9WO3vtlZhgT6sDURNCDdtDXKiN3JogvxeUmhOVjogbjV+FA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=giKiWKdO; arc=fail smtp.client-ip=40.107.92.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CA3PC9roIOUGYoxpMBF7E46W30OUWnaapG3+b4tcqHk7vmT1FHEm5rbRmxbQu+f4R9MKkOMGzcVurD9nz6M7Wbm0FGH1aYNrE/JdzhcT8g86iNMePHNoHu1paelY56aayQ93m9MLXTVNXLS09Y1EquCl+Zyp60NB3g2b2lw5cRDTWtkN3bA7nGjI8/3tt1/QwNSnLnw/S2KgPSVNMGWImzZMyYbNQh+sXOt2JrRnfkptXWD6hk5gI4qeT+TUp9gYYnx4Dj4yBqqDB/BMF/T4/0SuByV3uS1b+r98q3Iz4/RM4jZHegk+T7w8kpbyXw4rIppeJHwxy1YMBI4qciqXWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rh4IiVDFgJAG1o4yb1ZHyq6rwEl0kAOJyiNfdUMFfX4=;
 b=cgLBwrzTPjT/TpYTeVKNJ8kCvJqcC/XlHPAN4LK+m7qY5Zw6NFpQG3qq9uSOfzrTlM1oTGezh7enRFF/XSTkrPf/tpd+M+ajEf6PT+C3H1fCzlapHNo9fUW3buIzyimpPnKumdNPUKiTQ6OsTgWNZKed3DGu20JAG02OmK3KcC/KhsjtFpWjPFjW2C6D7MLplxbNNoBZUSNRaVRKT8kslOUcRXjkTKBmmUhMcCi2SQ4aWaW3j4DICKLYb/dZ6BaRKh3t47Xn1UgbuV0Dhlqkw7+CDRVI4MTaHd3KLiFGgq9UTlxsEScb4Y7vYqpn0Lu7uJrAbdSjL6sOWiuaqVs/tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rh4IiVDFgJAG1o4yb1ZHyq6rwEl0kAOJyiNfdUMFfX4=;
 b=giKiWKdOAgkZKYsBa+L5RlVnQn4LDlw/aP94OqnK2Zf/93JLQFbU7qitGty+GiC0W5c/RIIpNQZ6zynIg/yCFsboLdDWIU9YQVhiic5sw0nEIsGmPYoR/jUXUErqK0K/Z9ntO6nb0S0KXKzCb/oTko64LYtvx/eej+B92Sh+S20bg6ZNXmox3uHvWv6JVfkJKDx5UCIoZ4VgNc4L/CGvRIlXeWyNT/Ukbg36Qjreo1S5ZNqJsmz569ByR8bGdfy3hjxBSMFY99eYlfO29SefjsH6TpciGdH8t4pWZpJxkhEKA9b5J0MavULSjIf9yk1p0i1KbY4QG9HZmpdN8LgC5Q==
Received: from BN8PR04CA0057.namprd04.prod.outlook.com (2603:10b6:408:d4::31)
 by SJ2PR12MB7798.namprd12.prod.outlook.com (2603:10b6:a03:4c0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.24; Sun, 22 Sep
 2024 12:50:46 +0000
Received: from BL6PEPF00020E5F.namprd04.prod.outlook.com
 (2603:10b6:408:d4:cafe::c1) by BN8PR04CA0057.outlook.office365.com
 (2603:10b6:408:d4::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.30 via Frontend
 Transport; Sun, 22 Sep 2024 12:50:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL6PEPF00020E5F.mail.protection.outlook.com (10.167.249.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Sun, 22 Sep 2024 12:50:45 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 22 Sep
 2024 05:50:30 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Sun, 22 Sep 2024 05:50:29 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Sun, 22 Sep 2024 05:50:29 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>, <nouveau@lists.freedesktop.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <acurrid@nvidia.com>,
	<cjia@nvidia.com>, <smitra@nvidia.com>, <ankita@nvidia.com>,
	<aniketa@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC 16/29] nvkm/vgpu: introduce BAR1 map routines for vGPUs
Date: Sun, 22 Sep 2024 05:49:38 -0700
Message-ID: <20240922124951.1946072-17-zhiw@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240922124951.1946072-1-zhiw@nvidia.com>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E5F:EE_|SJ2PR12MB7798:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d676868-f146-4d67-63b9-08dcdb052d1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lOKslr13TJQV5Cspl/jRJkjCv0bFy72G5Ir9VEtHjQxB2gLC1/87urjQ766H?=
 =?us-ascii?Q?BZd0uKkE1BI10LyHzdo56boJqYaVJ5zts/rLqBdVX1RYEgirE/d8dNa109w4?=
 =?us-ascii?Q?9NVCn7JhngOYxdBY14i3LQe9Zupwpl0nHdq5zTP7UR6xkX3ak7XuvEnAAcSY?=
 =?us-ascii?Q?6Rz0dq94no7QmPXNkpFwNUjPQOox/Vh3CPYtluX+9fsqGYmsDHO6sTSJrxzZ?=
 =?us-ascii?Q?H1wheJfb1nbgehPRbXfOFERKdELsxuNNoXz7tPCfEMSdn/daCkyQDxK0ZpS5?=
 =?us-ascii?Q?Hbd1UwtIVAtIeY13aMmsudtg2qib15sp0Kxx8QT/b72DCLfFtQDgBeh+XOh7?=
 =?us-ascii?Q?Jf3j3l0O8ihDRWhgjE8FtmxOYUAx+Mmtem12OW0jDpaTtus0OFll6NlZm/V8?=
 =?us-ascii?Q?u1WZmJb8Boe0pCuFw36GPEe/sAaW/aHslAt/hYD0+cl6MsxDACU21/nEk3yp?=
 =?us-ascii?Q?JkIK9GmP2DnJPaIH+b/I9ERkiWW6pWOfRhJyYgUz27TvYjitBbbIWxAkvJkQ?=
 =?us-ascii?Q?TvEwUXw5EaJ6XEMYxCfUOJTbrmSizsJB/BeTkcE2+kynSA272T+S24deAZ2e?=
 =?us-ascii?Q?8hHmytSu/u0Q0Mf3/we7Cyl7lc0d2pH/OFMMOasdJ+NghN6YCCtSPBpHiDrS?=
 =?us-ascii?Q?fsgiaYt3BzTpuWKlQrq44wdWr7nwberznNKdgCnVAGik26dpxhCnS/DnklMK?=
 =?us-ascii?Q?O9el5B2CWyLrKuFTWgtZ8DS3iU7hWcnSOR2GHuMKJhRfF3lwIawJwfoNulet?=
 =?us-ascii?Q?9QeCnE3+1iSmKszv1wnHT9R33dzE/7vC6/QgVo0za/TaVtAqyAFAeE+7xF2X?=
 =?us-ascii?Q?18dbcQ/QQ47/c6Z1nDanf4YBblcZmBJlBOm/GqYD4zz3uMrqjfCCCLCFNJl1?=
 =?us-ascii?Q?mguG5xObYleDHpAeq5SvjIKASFqlkEYgKg4LM3Rv9DBEs472wfpAMv5txsjx?=
 =?us-ascii?Q?A0m428WT29ZbAYr5ZfVvevDDNFa+o5RMQqp4U0ajja7U9sg3Jrl1uBXTJx66?=
 =?us-ascii?Q?UMFoseQdubkHyb1pqgVhP96cYB4MaOl1qV7ntulSF+8Ra4caUNAQDkPmJ17M?=
 =?us-ascii?Q?+klZNl8GROfdpfH8dJrZ78yXKngZCFvObjpGTKvcUnhrdHsXhdkFBdhv746O?=
 =?us-ascii?Q?9IE1VWQcAadcB5lzRKx4/vpfnVl2J0wh5rfrUMK5cF9zuSSbQh9XU/65KNgY?=
 =?us-ascii?Q?nm/et+ORcCJMCr7a13GQk4etiGbBBw69AWvb8Pf3ffW7m885dxVa0e/b9iOi?=
 =?us-ascii?Q?1M5CtEUo3bQhhX1oJpld/PiOEsYi8EPZbDiYtVIVH1G2pR3gFiOxxG9FxIxT?=
 =?us-ascii?Q?jw3m6kaAohjJ4/G5YQTbVS6ktmmopL1MKCfL+jBZt6qvmllvCVyM49fRxcj2?=
 =?us-ascii?Q?NojPFs2SQ5a1nV5pRUndgBRvG9iSr+9SKjMgBuFiBW2psgsd7IjqEkxbpmHe?=
 =?us-ascii?Q?XdDMGV4+vtjwjzrwB91G0trllWRyf4cZ?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2024 12:50:45.6113
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d676868-f146-4d67-63b9-08dcdb052d1d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E5F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7798

The mgmt heap is a block of shared FBMEM between the GSP firmware and
the vGPU manager. It is used for supporting vGPU RPCs, vGPU logging.

To access the data structures of vGPU RPCs and vGPU logging, the mgmt
heap FBMEM needs to mapped into BAR1 and the region in the BAR1 is
required to be mapped into CPU vaddr.

Expose the BAR1 map routines to NVIDIA vGPU VFIO module to map the mgmt
heap.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 .../nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h  |  1 +
 drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vfio.c  | 47 +++++++++++++++++++
 include/drm/nvkm_vgpu_mgr_vfio.h              |  3 ++
 3 files changed, 51 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h b/drivers/gpu/drm/nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h
index b6e0321a53ad..882965fd25ce 100644
--- a/drivers/gpu/drm/nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h
+++ b/drivers/gpu/drm/nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h
@@ -10,6 +10,7 @@ struct nvkm_vgpu_mem {
 	struct nvidia_vgpu_mem base;
 	struct nvkm_memory *mem;
 	struct nvkm_vgpu_mgr *vgpu_mgr;
+	struct nvkm_vma *bar1_vma;
 };
 
 struct nvkm_vgpu_mgr {
diff --git a/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vfio.c b/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vfio.c
index 2aabb2c5f142..535c2922d3af 100644
--- a/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vfio.c
+++ b/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vfio.c
@@ -6,6 +6,7 @@
 #include <subdev/bar.h>
 #include <subdev/fb.h>
 #include <subdev/gsp.h>
+#include <subdev/mmu.h>
 
 #include <vgpu_mgr/vgpu_mgr.h>
 #include <drm/nvkm_vgpu_mgr_vfio.h>
@@ -203,6 +204,50 @@ static struct nvidia_vgpu_mem *alloc_fbmem(void *handle, u64 size,
 	return base;
 }
 
+static void bar1_unmap_mem(struct nvidia_vgpu_mem *base)
+{
+	struct nvkm_vgpu_mem *mem =
+		container_of(base, struct nvkm_vgpu_mem, base);
+	struct nvkm_vgpu_mgr *vgpu_mgr = mem->vgpu_mgr;
+	struct nvkm_device *device = vgpu_mgr->nvkm_dev;
+	struct nvkm_vmm *vmm = nvkm_bar_bar1_vmm(device);
+
+	iounmap(base->bar1_vaddr);
+	base->bar1_vaddr = NULL;
+	nvkm_vmm_put(vmm, &mem->bar1_vma);
+	mem->bar1_vma = NULL;
+}
+
+static int bar1_map_mem(struct nvidia_vgpu_mem *base)
+{
+	struct nvkm_vgpu_mem *mem =
+		container_of(base, struct nvkm_vgpu_mem, base);
+	struct nvkm_vgpu_mgr *vgpu_mgr = mem->vgpu_mgr;
+	struct nvkm_device *device = vgpu_mgr->nvkm_dev;
+	struct nvkm_vmm *vmm = nvkm_bar_bar1_vmm(device);
+	unsigned long paddr;
+	int ret;
+
+	if (WARN_ON(base->bar1_vaddr || mem->bar1_vma))
+		return -EEXIST;
+
+	ret = nvkm_vmm_get(vmm, 12, base->size, &mem->bar1_vma);
+	if (ret)
+		return ret;
+
+	ret = nvkm_memory_map(mem->mem, 0, vmm, mem->bar1_vma, NULL, 0);
+	if (ret) {
+		nvkm_vmm_put(vmm, &mem->bar1_vma);
+		return ret;
+	}
+
+	paddr = device->func->resource_addr(device, 1) +
+		mem->bar1_vma->addr;
+
+	base->bar1_vaddr = ioremap(paddr, base->size);
+	return 0;
+}
+
 struct nvkm_vgpu_mgr_vfio_ops nvkm_vgpu_mgr_vfio_ops = {
 	.vgpu_mgr_is_enabled = vgpu_mgr_is_enabled,
 	.get_handle = get_handle,
@@ -219,6 +264,8 @@ struct nvkm_vgpu_mgr_vfio_ops nvkm_vgpu_mgr_vfio_ops = {
 	.free_chids = free_chids,
 	.alloc_fbmem = alloc_fbmem,
 	.free_fbmem = free_fbmem,
+	.bar1_map_mem = bar1_map_mem,
+	.bar1_unmap_mem = bar1_unmap_mem,
 };
 
 /**
diff --git a/include/drm/nvkm_vgpu_mgr_vfio.h b/include/drm/nvkm_vgpu_mgr_vfio.h
index 4841e9cf0d40..38b4cf5786fa 100644
--- a/include/drm/nvkm_vgpu_mgr_vfio.h
+++ b/include/drm/nvkm_vgpu_mgr_vfio.h
@@ -19,6 +19,7 @@ struct nvidia_vgpu_gsp_client {
 struct nvidia_vgpu_mem {
 	u64 addr;
 	u64 size;
+	void * __iomem bar1_vaddr;
 };
 
 struct nvkm_vgpu_mgr_vfio_ops {
@@ -45,6 +46,8 @@ struct nvkm_vgpu_mgr_vfio_ops {
 	struct nvidia_vgpu_mem *(*alloc_fbmem)(void *handle, u64 size,
 					       bool vmmu_aligned);
 	void (*free_fbmem)(struct nvidia_vgpu_mem *mem);
+	int (*bar1_map_mem)(struct nvidia_vgpu_mem *mem);
+	void (*bar1_unmap_mem)(struct nvidia_vgpu_mem *mem);
 };
 
 struct nvkm_vgpu_mgr_vfio_ops *nvkm_vgpu_mgr_get_vfio_ops(void *handle);
-- 
2.34.1


