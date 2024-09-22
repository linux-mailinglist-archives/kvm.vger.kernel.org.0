Return-Path: <kvm+bounces-27261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A910897E1AF
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 14:52:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6ADE7281497
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 12:52:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0F6A2F2D;
	Sun, 22 Sep 2024 12:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DI61n69/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2081.outbound.protection.outlook.com [40.107.95.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812931803A
	for <kvm@vger.kernel.org>; Sun, 22 Sep 2024 12:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727009450; cv=fail; b=f0ZJQkJaySNwlRoTlJf0TqKlbmJvbVS4kWqIIjWPiIsfXQ74bB9NmlGPZmWd9NujHcn5+TQqXqpzjBQLSpR2Xk9G3aatdIH222CmynpvA+Xh0GBzEPclg8Pgw9xKnoreb9AF7k4lC8l3yYFfmSA9ofcsirJBz6CFkUoktql7E1k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727009450; c=relaxed/simple;
	bh=mvaErpb73mjTNY/zd1F0CvK3v2ZX4b/VVqTY/1RnjF8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q2IgYkhbW+yAOXLZPpq5Pymd5IlLO+8B26zEY80kv+rd/M67IhOfyJOvOZxSsNGs+57kvFcKW25wRVT8NxFxZk5Ubv5t5e+/9h1VS6YuYcVSTCUXdfZBo4GY9XfpsSP6fhRBzJECgtIu6uSM810dhQ1SkcOcziwumLTPzl2vjUY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DI61n69/; arc=fail smtp.client-ip=40.107.95.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EJtJ3oQwuCXyFZ90UWpUXxN+Q46L4nsU7egHncUSr+DVXrMMOaB3foR1rWJrQLBoU8jBLcVleQ9/Lu6/kHcFLwBOswajZTCFcdAD9O4LeEU1YQqvDkRdI2nPNIi/piaNaFBTLpoZbL1Ijqu0ZyAzpLopcJDuU9oBsOAXSM1ZpUQHfr/ehL8e+rC2GRHHg+fDaSixvwOcgyiKzZmD8+f7zizQLjVtsAi/S1wK8Rfhzd0XtM7oQ7uUrCEvGGPws3dfAjSDpbeSVQu12moD+eTB/xCTKpgQHgTAKJrs9mYj3QrP/j/bYSkmYTL0oTHJJ/WWA3vm+VnI0i5bvuGrsaCtyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NYE+Aay3FUrAyLLloByMaZmI4Qgq2DLngBI4ghqmorM=;
 b=H88FGj0oZiWuCfMhIayNWG5nDxYq+6TkQQXAW3WuweVwpHi0S3NVY9+nr18joo4DwotdosSGJmrDJ0gUGBcjGAom8zaBCHyDmWd9lBJy+Sk/elh9aieWnL0fmdLsIgS+MKkRkGYTHPmmjvYwd2FKNiNotf5xvWCRk5zi02OcwOW07gpTso1QeqZuSLqAVfBHgVsRGcTQti9xlp4Pl6hmeiqLCGmDooCHQUpgJgLQaLRtWdluti4wP7zE0k/p5OQlUVFMM6HVJ5BsPQMfL/K7HhuVqBtbV5SMM0GEawDuL34LmbFKsQ/lucIgpXCSOCY1Pjg8ElxtwKbYpxpFvnarQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NYE+Aay3FUrAyLLloByMaZmI4Qgq2DLngBI4ghqmorM=;
 b=DI61n69/aCIqCw+K9H8QaObnZItW5wSTWWlIquV1czxXgAS0ADswyLBjt1wZQS2OrqWwDC3dQNpySkT0Y9o5MiurpdeLBuhYgR7EFhn/jBi9OWCCThS1lkh14/ytmcTCkLhiT8k2cODPkuUMWPApSDrkiItW+t8VBU2Ryx3WYoby7gIUGDNVOpU43OyyC82AzVqatvGtSV+olX3BuEnFjGX5pWV1nJw8TAKMqjooJ2nuRr0VbETneIJz+ZTX3SvtQL/CEuI4RfBXOreGxV02WdDm969GE7wvIdccEUfpEWZuEPqmt4qknYbfv9+ibXYZXVbR+EzUCFmwN/qbQqIw+A==
Received: from BN8PR04CA0055.namprd04.prod.outlook.com (2603:10b6:408:d4::29)
 by DM6PR12MB4219.namprd12.prod.outlook.com (2603:10b6:5:217::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.25; Sun, 22 Sep
 2024 12:50:44 +0000
Received: from BL6PEPF00020E5F.namprd04.prod.outlook.com
 (2603:10b6:408:d4:cafe::f0) by BN8PR04CA0055.outlook.office365.com
 (2603:10b6:408:d4::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.30 via Frontend
 Transport; Sun, 22 Sep 2024 12:50:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL6PEPF00020E5F.mail.protection.outlook.com (10.167.249.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Sun, 22 Sep 2024 12:50:44 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 22 Sep
 2024 05:50:29 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
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
Subject: [RFC 15/29] nvkm/vgpu: introduce FB memory allocation for vGPU
Date: Sun, 22 Sep 2024 05:49:37 -0700
Message-ID: <20240922124951.1946072-16-zhiw@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E5F:EE_|DM6PR12MB4219:EE_
X-MS-Office365-Filtering-Correlation-Id: ff7c44cf-83fd-42c8-e533-08dcdb052c3a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WNrmRG1cBUBub4DPI1yKf8osMEQrxqxEmLezW0L/X1JThSyI2gsRMvtfiCsx?=
 =?us-ascii?Q?rIBYeMdd655BY8h63BMONU0tBxx3quoURE3754YbNWnTDnDXeFLD+AuRYbul?=
 =?us-ascii?Q?XQ4djTzov2XOaUq6djOXNfaCke2Rxtaq4T+Nwlm6xteV1WjtLioADR4Tk1fj?=
 =?us-ascii?Q?vIL28v2y91G1pKJzJpXyG5GFCsGxF1bQ0aayi396NpNk0oJ37ukbAtm7H0uQ?=
 =?us-ascii?Q?5ftSAMW/J3LlJIsmrt1Ngg6eGXrS63d6U1ZpVCOndPrlVhZUDdZ9kW5c2fly?=
 =?us-ascii?Q?++BxawFCVJbOFiqRc9XHdJvKPWwg2OP7pvy9DVVgy6qlxhidUe7JTAyvMcrU?=
 =?us-ascii?Q?VMO8srwUfcAp/+xJV5ODM8Xb8rXHkBAP8k38RvI3h7ToV5+nL+uASjgzKugy?=
 =?us-ascii?Q?1jMR5ucMiTkBn9lUH7SnE9K08BazoIEZsoMAfnOD8RbRPUy46wedrIA0aSJo?=
 =?us-ascii?Q?zrGQjLP1XGVGuaDdDzK3vQOVTDxOuuIdZ6jaXJOSF2D1DcSlRy1d26aCsCx/?=
 =?us-ascii?Q?y4UY5OPkV11hNYq5el9lDiKxtER1fvkBzXFJ626/a2FXx5ufl5nxVHAcTqWH?=
 =?us-ascii?Q?DU0MHZT5nTImaLVsbQBfEh98Vj59saORqNXvobq4oT8xXTLpPhUvwJsGYTUa?=
 =?us-ascii?Q?W24AWfEC3zFLx3tkGwCPB0t8M+mEXaiHq5kqKsN37fZT0nEGesbOW9RBl8Ty?=
 =?us-ascii?Q?ST16TVqZLAl76gqE+BpTTXyfLyeSo40Ejpp6reGcvrwGuAaWoYnC66V/sojN?=
 =?us-ascii?Q?0zlwoPZ3mL02Y2rWyj9yrvADCo1wZTheA12wfSk98cRW6zcCDtNOsi1tjH7g?=
 =?us-ascii?Q?67EHcfVg8N8k81VldBdw/ATydTzuyVi97M2euxks9t3PFPyrIhR8hmh317J9?=
 =?us-ascii?Q?viWNZY9uCptPlZHI/HiS+7o/aBdOpEg9msJrbBRMlgCaktTpNL6W6djQjd69?=
 =?us-ascii?Q?jqwAi9JpdsEJnGH4sNuD1TluQ5VDgqHP9KOkpDatcSzqX/vpq/ZvLHmTcz2B?=
 =?us-ascii?Q?jJ0TIJ4pJSB+aduLCgODRJ4uVas4fKCkgz8tlKT5RfiB9vJ9zFsFh38LQxQ9?=
 =?us-ascii?Q?PTUyy8Dr9PT8WYXYcnsmJEmoAgDWtuhLNkiMe7wf70DmJGiHNe3XTWGlr7yM?=
 =?us-ascii?Q?ojK/uWzxgga/gXKSTnsvQTStsuoFeXQTA56J+cwrtTto8kwDqCi3ZgpPmDjg?=
 =?us-ascii?Q?0IbNQk8d8B2wIfL3oBuKTZsj9lwEQiyKBgOeLLghyDRH/zaJSeytHaYuJDWS?=
 =?us-ascii?Q?pNUdqSqQy5oS1leI8WjPRBbEHu+sMAZMZzkVma3feiNCJ//HXRIfLZrf5u65?=
 =?us-ascii?Q?4CvmZ7FoidGuW+B/RxcPw3ynjvFXH7/dCu5rLyw24Y/ABjWW2cVOm/ruDHhf?=
 =?us-ascii?Q?rqHI128aBBPEp2nqeETs0+gSb/XJvXecvTIe5TrWYkgbocruELZUeZCnHrYy?=
 =?us-ascii?Q?AdiYElzmAXi4mHUwoR8Niji8GCLzZsdb?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2024 12:50:44.1113
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ff7c44cf-83fd-42c8-e533-08dcdb052c3a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E5F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4219

Creating a vGPU requires allocating a mgmt heap from the FB memory. The
size of the mgmt heap that a vGPU requires is from the vGPU type.

Expose the FB memory allocation to NVIDIA vGPU VFIO module to allocate the
mgmt heap when creating a vGPU.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 .../nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h  |  6 +++
 drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vfio.c  | 51 +++++++++++++++++++
 include/drm/nvkm_vgpu_mgr_vfio.h              |  8 +++
 3 files changed, 65 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h b/drivers/gpu/drm/nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h
index a351e8bfc772..b6e0321a53ad 100644
--- a/drivers/gpu/drm/nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h
+++ b/drivers/gpu/drm/nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h
@@ -6,6 +6,12 @@
 
 #define NVIDIA_MAX_VGPUS 2
 
+struct nvkm_vgpu_mem {
+	struct nvidia_vgpu_mem base;
+	struct nvkm_memory *mem;
+	struct nvkm_vgpu_mgr *vgpu_mgr;
+};
+
 struct nvkm_vgpu_mgr {
 	bool enabled;
 	struct nvkm_device *nvkm_dev;
diff --git a/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vfio.c b/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vfio.c
index 44d901a0474d..2aabb2c5f142 100644
--- a/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vfio.c
+++ b/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vfio.c
@@ -3,6 +3,7 @@
 #include <core/device.h>
 #include <engine/chid.h>
 #include <engine/fifo.h>
+#include <subdev/bar.h>
 #include <subdev/fb.h>
 #include <subdev/gsp.h>
 
@@ -154,6 +155,54 @@ static int alloc_chids(void *handle, int count)
 	return ret;
 }
 
+static void free_fbmem(struct nvidia_vgpu_mem *base)
+{
+	struct nvkm_vgpu_mem *mem =
+		container_of(base, struct nvkm_vgpu_mem, base);
+	struct nvkm_vgpu_mgr *vgpu_mgr = mem->vgpu_mgr;
+	struct nvkm_device *device = vgpu_mgr->nvkm_dev;
+
+	nvdev_debug(device, "free fb mem: addr %llx size %llx\n",
+		    base->addr, base->size);
+
+	nvkm_memory_unref(&mem->mem);
+	kfree(mem);
+}
+
+static struct nvidia_vgpu_mem *alloc_fbmem(void *handle, u64 size,
+					   bool vmmu_aligned)
+{
+	struct nvkm_device *device = handle;
+	struct nvkm_vgpu_mgr *vgpu_mgr = &device->vgpu_mgr;
+	struct nvidia_vgpu_mem *base;
+	struct nvkm_vgpu_mem *mem;
+	u32 shift = vmmu_aligned ? ilog2(vgpu_mgr->vmmu_segment_size) :
+		    NVKM_RAM_MM_SHIFT;
+	int ret;
+
+	mem = kzalloc(sizeof(*mem), GFP_KERNEL);
+	if (!mem)
+		return ERR_PTR(-ENOMEM);
+
+	base = &mem->base;
+
+	ret = nvkm_ram_get(device, NVKM_RAM_MM_NORMAL, 0x1, shift, size,
+			   true, true, &mem->mem);
+	if (ret) {
+		kfree(mem);
+		return ERR_PTR(ret);
+	}
+
+	mem->vgpu_mgr = vgpu_mgr;
+	base->addr = mem->mem->func->addr(mem->mem);
+	base->size = mem->mem->func->size(mem->mem);
+
+	nvdev_debug(device, "alloc fb mem: addr %llx size %llx\n",
+		    base->addr, base->size);
+
+	return base;
+}
+
 struct nvkm_vgpu_mgr_vfio_ops nvkm_vgpu_mgr_vfio_ops = {
 	.vgpu_mgr_is_enabled = vgpu_mgr_is_enabled,
 	.get_handle = get_handle,
@@ -168,6 +217,8 @@ struct nvkm_vgpu_mgr_vfio_ops nvkm_vgpu_mgr_vfio_ops = {
 	.rm_ctrl_done = rm_ctrl_done,
 	.alloc_chids = alloc_chids,
 	.free_chids = free_chids,
+	.alloc_fbmem = alloc_fbmem,
+	.free_fbmem = free_fbmem,
 };
 
 /**
diff --git a/include/drm/nvkm_vgpu_mgr_vfio.h b/include/drm/nvkm_vgpu_mgr_vfio.h
index 001306fb0b5b..4841e9cf0d40 100644
--- a/include/drm/nvkm_vgpu_mgr_vfio.h
+++ b/include/drm/nvkm_vgpu_mgr_vfio.h
@@ -16,6 +16,11 @@ struct nvidia_vgpu_gsp_client {
 	void *gsp_device;
 };
 
+struct nvidia_vgpu_mem {
+	u64 addr;
+	u64 size;
+};
+
 struct nvkm_vgpu_mgr_vfio_ops {
 	bool (*vgpu_mgr_is_enabled)(void *handle);
 	void (*get_handle)(void *handle,
@@ -37,6 +42,9 @@ struct nvkm_vgpu_mgr_vfio_ops {
 			     void *ctrl);
 	int (*alloc_chids)(void *handle, int count);
 	void (*free_chids)(void *handle, int offset, int count);
+	struct nvidia_vgpu_mem *(*alloc_fbmem)(void *handle, u64 size,
+					       bool vmmu_aligned);
+	void (*free_fbmem)(struct nvidia_vgpu_mem *mem);
 };
 
 struct nvkm_vgpu_mgr_vfio_ops *nvkm_vgpu_mgr_get_vfio_ops(void *handle);
-- 
2.34.1


