Return-Path: <kvm+bounces-27268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7181C97E1B6
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 14:52:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E6F781F20F2D
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 12:52:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5005A4A15;
	Sun, 22 Sep 2024 12:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kHDgVaN9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2047.outbound.protection.outlook.com [40.107.101.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F274A3CF58
	for <kvm@vger.kernel.org>; Sun, 22 Sep 2024 12:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727009455; cv=fail; b=QPI6ShV+pvb1+uWQNobBeaRhmKOgD0VTVIlIqTMlYIhWb1UwmQjPhUczMh3+1czYO5K8ZkMzgcq1yNy0bYlk79HouEmk2vkeyrkshGYkpDwcy3uMscYO8I2UtVEAPmOmxQKVi+2kE9Z1zH98cu31Y95vdtcIGbiSNS+mYcdt694=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727009455; c=relaxed/simple;
	bh=nnLQsphBrO+nZHTUEkfHTBTiEBt5+mV//4sEozTqfYA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=riLeZcnmjr+OOgt33jZxKpejpDQ5f+Q8rb7x5THL28YqnDqUKvBW26qTxyOpiiesV1Tq7/RFRBXWH4OGtp4lI48jPp2vaDBqvMMyhZd1x1l7wGl7eESlp2UjLUCvYRaXlbED1KwJzIopBXtA5EUl3lnkSxFXANU6OTE155LUhos=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kHDgVaN9; arc=fail smtp.client-ip=40.107.101.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W6zJ7lN3pl6fcZQKuCvNsPpElJ9yTGh7uT/+LPhyXi+iHW+Hm9d+ND6jFBMn41TUHL1Ht6sEtyEJ7IeZAX6OHPDClvgJmS65LkTWZxI34qhNn/eo53IkuhwhuEl4nwg7m40HjpmKnab63wTgO6RIv+RTtqAlTzXfPi4Bkx4LDmU+GfwnsIQEhWipamo+JQrn1PFUG3D4VkJ7WEGZuUiDhjN1IIi5ZVxnmc2F+D7bowj+pMNnvZHh0L5WfU254URPTbBx7ftKlDmtdOcbN1ZbqRZS1HufcPVkTkpcmPel+L94Mv2bQrhYt3+4fGJXvrz2eIWbRB7+Hg/VMZGWiAIZUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pwBqXj/y0il+KibBUa14o5qJf0LgGdlyPP0GVh9Vf7I=;
 b=paYm6k3bD6+orh1b+vIKSCbMxLMzIDAaXOjDCoAscz2vJXU7KZeOCthx7Dspr1DmnsaxiJ8Yn3ds23jOlBPf+TWeF1qMCE5pKKtMKXZUR326mwL8ospsDlrSZIblj/o1pLQL0+KmoClyKQM/MQ2WAotXyzOg1WX5om9IjF5CkaMwenGmLHhGElLIO7kNNftJX50ypUXzqoUaUUdgZ9iPvLmDBWgVxhvcUnlOQhgMzEg6YqbCWJshjGLSVN9hyQg/DspJDfaeMP2e6Rm+a5Ntd6r0kYtsyOfTnI1heJ5VUsQoVAL25RCaOMtAtKRGewSJliaV0gud/TMXGrnMO/tDGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pwBqXj/y0il+KibBUa14o5qJf0LgGdlyPP0GVh9Vf7I=;
 b=kHDgVaN9zRN5DxFwyqfG3ppzPzSrwtGw64bKALeh42yw67ixDOhhrWA9HEx/t6M86199ZT8lF8sBKJ/LEQ+mQQKKGB4nM3r5sZPY3UsG2A7W5iuAY+2L+90pSxIoz8rMLQbv4AswaCxNUP8plu3nNZN3jpVNsyEDnXSPpxX9lmqJfwuLOmGdAdUk2yE7O7KMMmAlzV1aRYKK2wL2G5SMBWkABdb8ZtxOu4qDQGBtuvV9SuhLtExUS6D2avZZGUHDG9FwFXF9UHbFa/U6vxtdI5jhIu9C40v3YuYTYgemKQ+w28yaE2Txvd6iuRXHGeXSi9citslXCCVkSkISQe0trQ==
Received: from BY1P220CA0008.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:59d::16)
 by PH8PR12MB7254.namprd12.prod.outlook.com (2603:10b6:510:225::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.24; Sun, 22 Sep
 2024 12:50:49 +0000
Received: from CO1PEPF000075F2.namprd03.prod.outlook.com
 (2603:10b6:a03:59d:cafe::7d) by BY1P220CA0008.outlook.office365.com
 (2603:10b6:a03:59d::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.23 via Frontend
 Transport; Sun, 22 Sep 2024 12:50:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1PEPF000075F2.mail.protection.outlook.com (10.167.249.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Sun, 22 Sep 2024 12:50:48 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 22 Sep
 2024 05:50:36 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Sun, 22 Sep 2024 05:50:35 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Sun, 22 Sep 2024 05:50:35 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>, <nouveau@lists.freedesktop.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <acurrid@nvidia.com>,
	<cjia@nvidia.com>, <smitra@nvidia.com>, <ankita@nvidia.com>,
	<aniketa@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC 25/29] vfio/vgpu_mgr: map mgmt heap when creating a vGPU
Date: Sun, 22 Sep 2024 05:49:47 -0700
Message-ID: <20240922124951.1946072-26-zhiw@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F2:EE_|PH8PR12MB7254:EE_
X-MS-Office365-Filtering-Correlation-Id: 3de9d63a-89bb-4f69-2f0b-08dcdb052f10
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SqD3alNH0UUKDMU+Ot/W+8MNpvkek1BRKG4HzsHH6mS5e4xaFXRg3IfzV9U2?=
 =?us-ascii?Q?ropQo49EHXvCwgVGVL2CEk9KP9wPxIxRPu7eo3F39B4LhxhDv8G1CC+w8aKf?=
 =?us-ascii?Q?2pBYOLtfMop9fwKBKALeDDHNuFqCWzNigQh9pH+cst+pwEsfQvqh4z5BBLoO?=
 =?us-ascii?Q?bTuiAL29p5YQH69+0m4+FXZESM+odnueMrcmvwPmEuUh+LEYmxZigD4dJpih?=
 =?us-ascii?Q?DSZPXxl0Ioe+gLKNZ1JWGlH34LlUfUDQFSillRS66N1DUjqk7ml50ogapMkN?=
 =?us-ascii?Q?nDPOElyZE/Nw++14NS1KtZ8Gt0Ffpc1KEq1XVL9XltOlbhggiy+u8/I66XNc?=
 =?us-ascii?Q?dkLrzchshMZdSo5ltAQwj4IfpdsgYtEs+nSWY9eOCeiRii3K6AhHZa/U3P2Z?=
 =?us-ascii?Q?knTUqb5KQylx2u99cP5arsu4r6pduDJQUM32Q/zBGTreWSB1xyvASAM59y6M?=
 =?us-ascii?Q?2DCtrTo4m6to8zb0TZLad7leU5VY9prgF578q2tzNp6GDUWmqginzYcVCk76?=
 =?us-ascii?Q?Ysc83fY74XKZcf/gQhCY/v2XAAgHlQG3O5FWRVeVuwq902j8d+PwnhsWQSS6?=
 =?us-ascii?Q?XPjEpzapWFw/38eLvdeeUD1zOh/4jN2771JE/hxrUj9sm4+4OoPO6sOe5taO?=
 =?us-ascii?Q?nQxmboO1z39sAetElsvhGO3GtVckNXYTzNyVtY8wYRFWK84Yt7UPQE6VPQlQ?=
 =?us-ascii?Q?R6J6kaQEMOdDZZcvqfd9DYY5s5A/8Ae4/sUr6LdZ+aCBayoxNnxMcMunElbd?=
 =?us-ascii?Q?INadgeXf+xk+NkdbIntuuUVLv/QWJnlY7CVXaaIlNVuh18xFgmoCT1H5pjSE?=
 =?us-ascii?Q?cpw//JP0pHxfFqdsRiA9KRcxaNyRscK3UULHGfZhRN9ImMJi9OJGChfoSlcN?=
 =?us-ascii?Q?dK91wqeTQpUQgl5iBP/Lkis3rJ36K7an8fv/NiQnItYsnu3PCTx70K6Zsnj8?=
 =?us-ascii?Q?5ZT6j1H0NnQh18JTqEVYhVERVoOhlEywqADYa+KwSlRCbWpwK7gQrmPzaGLE?=
 =?us-ascii?Q?jORRVH06pp68j7UCQ6zgbFHCiyKYou/X0PtlOc6/Fvh29N29g4cNGtNSG5Kz?=
 =?us-ascii?Q?71W5OLJlgxTdzmFq/paMBMWCioXdehkpwmzkSNI6jCmkvldCP3lb0n/BQhuu?=
 =?us-ascii?Q?2x+bow3fErEZJ2k2ig9l97Bj9ZhRjDfrhc7f2Xk6JqjQy2y6C2McjgL34YhC?=
 =?us-ascii?Q?xEJwlmXQ1tBL6TJ/6xOxbJgN2Wkd5XlQSFo4Iu9C2aXwUE9hSWpLkBWrkIju?=
 =?us-ascii?Q?ltrVqE/5Dgyivjfcps6eq2x6aNHMOyKtCrfMJ1zZ1R4+SrNsY1Lpk34xtYYN?=
 =?us-ascii?Q?S54m6j3Mxj5CxfvW/8IFZmP658mWiauYTw/MneSCCNErOcye5p/DqDvaqjWk?=
 =?us-ascii?Q?gBCD4DA=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2024 12:50:48.9895
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3de9d63a-89bb-4f69-2f0b-08dcdb052f10
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7254

The mgmt heap is a block of shared FB memory between the GSP firmware
and the vGPU host. It is used for supporting vGPU RPCs, vGPU logging.

To access the data structures of vGPU RPCs and vGPU logging, the mgmt
heap FB memory needs to mapped into BAR1 and the region in the BAR1 is
required to be mapped into CPU vaddr.

Map the mgmt heap FB memory into BAR1 and map the related BAR1 region
into CPU vaddr. Initialize the pointers to the mgmt heap FB memory.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 drivers/vfio/pci/nvidia-vgpu/nvkm.h     |  6 +++++
 drivers/vfio/pci/nvidia-vgpu/vgpu.c     | 29 +++++++++++++++++++++++++
 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h |  4 +++-
 3 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/nvidia-vgpu/nvkm.h b/drivers/vfio/pci/nvidia-vgpu/nvkm.h
index 50b860e7967d..8ad2241f7c5e 100644
--- a/drivers/vfio/pci/nvidia-vgpu/nvkm.h
+++ b/drivers/vfio/pci/nvidia-vgpu/nvkm.h
@@ -82,4 +82,10 @@ static inline int nvidia_vgpu_mgr_get_handle(struct pci_dev *pdev,
 #define nvidia_vgpu_mgr_free_fbmem(m, h) \
 	m->handle.ops->free_fbmem(h)
 
+#define nvidia_vgpu_mgr_bar1_map_mem(m, mem) \
+	m->handle.ops->bar1_map_mem(mem)
+
+#define nvidia_vgpu_mgr_bar1_unmap_mem(m, mem) \
+	m->handle.ops->bar1_unmap_mem(mem)
+
 #endif
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu.c b/drivers/vfio/pci/nvidia-vgpu/vgpu.c
index 4b04b13944d5..de7857fe8af2 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu.c
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu.c
@@ -87,12 +87,29 @@ static int setup_chids(struct nvidia_vgpu *vgpu)
 	return 0;
 }
 
+static inline u64 init_task_log_buff_offset(void)
+{
+	return (3 * SZ_4K) + SZ_2M + SZ_4K;
+}
+
+static inline u64 init_task_log_buff_size(void)
+{
+	return SZ_128K;
+}
+
+static inline u64 vgpu_task_log_buff_size(void)
+{
+	return SZ_128K;
+}
+
 static void clean_mgmt_heap(struct nvidia_vgpu *vgpu)
 {
 	struct nvidia_vgpu_mgr *vgpu_mgr = vgpu->vgpu_mgr;
 	struct nvidia_vgpu_mgmt *mgmt = &vgpu->mgmt;
 
+	nvidia_vgpu_mgr_bar1_unmap_mem(vgpu_mgr, mgmt->heap_mem);
 	nvidia_vgpu_mgr_free_fbmem(vgpu_mgr, mgmt->heap_mem);
+	mgmt->init_task_log_vaddr = mgmt->vgpu_task_log_vaddr = NULL;
 	mgmt->heap_mem = NULL;
 }
 
@@ -103,11 +120,23 @@ static int setup_mgmt_heap(struct nvidia_vgpu *vgpu)
 	NVA081_CTRL_VGPU_INFO *info =
 		(NVA081_CTRL_VGPU_INFO *)vgpu->vgpu_type;
 	struct nvidia_vgpu_mem *mem;
+	int ret;
 
 	mem = nvidia_vgpu_mgr_alloc_fbmem(vgpu_mgr, info->gspHeapSize);
 	if (IS_ERR(mem))
 		return PTR_ERR(mem);
 
+	ret = nvidia_vgpu_mgr_bar1_map_mem(vgpu_mgr, mem);
+	if (ret) {
+		nvidia_vgpu_mgr_free_fbmem(vgpu_mgr, mem);
+		return ret;
+	}
+
+	mgmt->ctrl_vaddr = mem->bar1_vaddr;
+	mgmt->init_task_log_vaddr = mgmt->ctrl_vaddr +
+				    init_task_log_buff_offset();
+	mgmt->vgpu_task_log_vaddr = mgmt->init_task_log_vaddr +
+				    init_task_log_buff_size();
 	mgmt->heap_mem = mem;
 	return 0;
 }
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
index f4ebeadb2b86..404fc67a0c0a 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
@@ -23,7 +23,9 @@ struct nvidia_vgpu_chid {
 
 struct nvidia_vgpu_mgmt {
 	struct nvidia_vgpu_mem *heap_mem;
-	/* more to come */
+	void __iomem *ctrl_vaddr;
+	void __iomem *init_task_log_vaddr;
+	void __iomem *vgpu_task_log_vaddr;
 };
 
 struct nvidia_vgpu {
-- 
2.34.1


