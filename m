Return-Path: <kvm+bounces-27263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 856BF97E1B1
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 14:52:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 313D128147F
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 12:52:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B0693D0AD;
	Sun, 22 Sep 2024 12:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CgIHs6xD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2058.outbound.protection.outlook.com [40.107.93.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4812CCC2
	for <kvm@vger.kernel.org>; Sun, 22 Sep 2024 12:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727009453; cv=fail; b=Ad4KOqgGKbvqTk2jpjfCYbcHebTsTD17H182mUZZ+HjUroeGtq2i/ve6HywZjyxMwGKJY4Dwg+Pm+uwKxbcUBfgCEywyvzX41q62SoY1V3BY7Y6Tx4DF1+0kpdZpufRseqm9evAsvDNPOIVrD/GAWG7HaqDtjcsPfswOhH+ZyWo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727009453; c=relaxed/simple;
	bh=aOWt9elKSOoR1bJCvJ5C3PYz1TkBxBXofeR5Yvrl+Ww=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eC3lpIqDWjDiSc4S51bKAWWgixQLSiQSjnKIBvwqDWvL6zXXv48+shodcCjn9w28CLj90udxvnL3iN1e14ymwsqKAdxAggPXiaAZLlDd1YPVykRP43UcrQDfgc1jd4tEDwXU1YPC9Jeu0Z8ysaS9tBj8rHGvoqkGG7svl4PvaW4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CgIHs6xD; arc=fail smtp.client-ip=40.107.93.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YASe/G7rmiAp8cI5yxT2t5UIHRGIpYiClx/ZV2R5wBRqnNYzf8Wh1mHMbNYZpcLn2rH/qEEeAD9ZWMAQ62celTK4OqkRJJjY9IHwPvk2p1+ObjUfJEc5/McL7RyZdOCSYI5AneNZZaIpossySSJqyiR0F0AzTb4VORJ0JjHeP3ma8lm1Mx1boNNtXVpopk0qr1iWuqVcwCpuD1QAdX/Qnb21w3BOjSPuP2932Pt4xAMy1kTjpx4kIggaeF/0hpFPaZ/dqu0u1B2fP761BgrwkxTc9naYe1SKUeqDOCuJcCw9D+g3Wdb81qndNzf6otO7oF7Gd7qDAzPGS6y376PClw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ov5LC7GbiOMPGtzA4WRPVETEec9xsRePWztyrkfU+jo=;
 b=dhe6VlXn2zLRmAVTnFOdTWTu/dfDKgYryqFW8JqM//QtymnRm3ejPQaaLWdxNoWmvjfdLIYg+ssRfvJJJ6Qh6Pz/GkIESdEKo8CN+0/iY1aAeVwe3AEjF4u/fhsfoMS5Bud1t/iE/iW8q+X8Tvk9mRtQIPw1R4R04rAQrOF1OQtB8ZLlKQrYQl4u9JDtgm2snHtxWu1mo+Xgy14Jqnap7VGDzHJ6Bms+VFrwrg6usbSFPKqC6pgHETjeif7DYA08U87QjdllUeEjIJdHKOsvbTjaw+N/Y2mgubLF5HbdnasC71I3zoKdEQu8TTBTzJWcOEWfe+4VJMQ7amEW8M/zuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ov5LC7GbiOMPGtzA4WRPVETEec9xsRePWztyrkfU+jo=;
 b=CgIHs6xDtCix6XNcH4x2RrbxQ/T1oDyfIUg+msy7Ly3BJ91v0VZGkf0mXTnkm1X3H3gl+qyTiSng7ZsGVomrbvbjATbNbzkf+3H/WJAHX+oQcdN2KXxmPID2Oqjqb+1VpgbIWCybby1vxskxg2d/O1p5Og/2jOmyV+Fg/pvPgHQZz55rIOiN9yjQJDA90C0Z7czwS1+TxeYOQvtEF5hJniwV/lOjyRhQD5WGq+d9GTJpjux55szFLaurgRsPxGNILJhAQCIXGmx8LQY0DCvzSuzfax02g15e042FvRFmWuneWQU9tW1m2n7og8s7B9zSV2beu5+/D0Y7SiXcFsFNbQ==
Received: from BY1P220CA0013.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:59d::17)
 by CY5PR12MB6203.namprd12.prod.outlook.com (2603:10b6:930:24::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.25; Sun, 22 Sep
 2024 12:50:46 +0000
Received: from CO1PEPF000075F2.namprd03.prod.outlook.com
 (2603:10b6:a03:59d:cafe::9) by BY1P220CA0013.outlook.office365.com
 (2603:10b6:a03:59d::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.23 via Frontend
 Transport; Sun, 22 Sep 2024 12:50:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1PEPF000075F2.mail.protection.outlook.com (10.167.249.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Sun, 22 Sep 2024 12:50:46 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 22 Sep
 2024 05:50:34 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Sun, 22 Sep 2024 05:50:33 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Sun, 22 Sep 2024 05:50:33 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>, <nouveau@lists.freedesktop.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <acurrid@nvidia.com>,
	<cjia@nvidia.com>, <smitra@nvidia.com>, <ankita@nvidia.com>,
	<aniketa@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC 22/29] vfio/vgpu_mgr: allocate vGPU FB memory when creating vGPUs
Date: Sun, 22 Sep 2024 05:49:44 -0700
Message-ID: <20240922124951.1946072-23-zhiw@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240922124951.1946072-1-zhiw@nvidia.com>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F2:EE_|CY5PR12MB6203:EE_
X-MS-Office365-Filtering-Correlation-Id: 8608cda4-3fce-412e-2d1a-08dcdb052d89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a0RQNUhHbzhYRnFtcityTGV4L3B4andtVmJRcUE1Y2VqN0hVZ2toa0p2SzNi?=
 =?utf-8?B?dk9ZNVJISWxzNlJJRDdFblpXR0R0bk13YnV0ejlkV1F3SnVFRzcrbjMveVhC?=
 =?utf-8?B?eVkxLyswdTRKQVhiQ29wcHVFZ2VQTlFyN2c3S1k3d0wyejkvOXZ4cS9wU3FX?=
 =?utf-8?B?U1BzaVFDVlRrMXlJYlBOVFlxYlBrbmJQOHpVZHlLdllPdlFZeG40SVowdjVl?=
 =?utf-8?B?Uk9mVG1ydGlONkVkUWJEVTJmT2MySFpoS0tBV1RhTysxbDJsdEFEVUdWWFZu?=
 =?utf-8?B?WCtZd0c2dGR6ZXlReVFKSXE0by9vdFVkV2dIeFF4T0tnU2h4Y0hRamZTcXBV?=
 =?utf-8?B?Ny8zS2M2VTB6ZEdFSFFlY1BycTFQVG81OXBVVm5oS0VEcldGczZHK2FsV1ZS?=
 =?utf-8?B?NGF1eHN3OXhSbEdTVkZtWUxKSjVWZ1pXS3o5bHZEa0hzRzh1R3A5R3czNmR5?=
 =?utf-8?B?WVJ1Y3pmRTh1UDkzNUVYY2Vubnl1Mmx2eDV4NytxY2ZkVHNSaWd3ZEtkNFpn?=
 =?utf-8?B?ZGsvZFlSa3dHWFZHSm9ycEdQb2x6Mm5sMGNaaEVvODl2MkhaNUVJRGJ6Mk02?=
 =?utf-8?B?ZUlvRmowcmRhclMxRmU2d0VtR0tLaWdZaTUyVkh3cUVVOHJIQWxpZERGYWRE?=
 =?utf-8?B?YzVjV01CaXVWMWp0TVorazB1d25IeVJzOGpnV3BBSEI0c25qSGVTYVl1RzdJ?=
 =?utf-8?B?cHg0TE9wdlQ1SGFtZ3JmanJXZ0Q5YU1jRVI5MGs0MHovRGQyQ3UyMVJGRk8z?=
 =?utf-8?B?NmJ0cTdJV3BKS1FTQWJTbWdhb24xT29ZNS9qOE5pajUzMHd3cThDOUhLNFdr?=
 =?utf-8?B?MEJuZlBZZFI4enNXYnZyUUhCRlhVYUx6REZVYm5JemJSdGE3ZXQ5MkxTWHpr?=
 =?utf-8?B?MU9XQkpDdVU4dFRrbFYwZ2RvVDVlWnl1eGY0azgrcmViV1pQTmZjT2tEeXIy?=
 =?utf-8?B?dWZwcE0zMHhOL3VSMy9VVUxLT1ptaGQyN3hmdUZxbW5OK1VBc1NWOEFITFp6?=
 =?utf-8?B?bmNRMURSOUpuejhjZDB5VUd3UFhNVGU5QlFDc0NOR1FPSUpoWGE4Z2xzWVJK?=
 =?utf-8?B?bVIwdVlSbm9BeFRPWi8yZlhHQkc4aFFzYkpuM1d1b2FURkJxRVZickZ6dFFM?=
 =?utf-8?B?bHFsaktzTktHazN2WXBXTy9laStBMjh4dXhTeVlmY1NmNS9jNkxqaUpzMmsy?=
 =?utf-8?B?TFgxMlFvZnBjaUxRRzlseERjYzFOdVdXNzRCMmFGb0I4bTZieUVtaXJlTlZa?=
 =?utf-8?B?d2lxRlk0Q1E5eTB5YlVva0FaUlpYeTZqc0NGMEtOdERxbkpUTjdVWEhiWUx6?=
 =?utf-8?B?MjBWemtCaHBWSXZRaDkvZEt6dzJacU9yd3BjYWNiVHdVN0lpMGVQTmdiRmNa?=
 =?utf-8?B?V056UDE3OHliUnpsR2hyRHU2dEJjSzcvb1hWa2w0MHZpMEhpY0lMSjAxWlEx?=
 =?utf-8?B?K2F6TmZUZEVzTTZkSURlTExObHdqY0RTcG9IZ2FiS2w5S0IvVnpxZEJlK09Y?=
 =?utf-8?B?ZU9hLytrenZSQk1nNUM3bTZQTkRHS0NiN3NvQkEvc2hucTJJODltSVhaRXBE?=
 =?utf-8?B?ZjNVTEw1aElFeGRaUjgvVDduTTRsYWlYZzVQamNRUE5QOEdyR1VsNkVrb1lo?=
 =?utf-8?B?WklzaisrK3NGclFxTVRMTlJNcXpLMTY0SHJyQmxaL3NLS0tuWmEzbHJIS0Ja?=
 =?utf-8?B?cDRrbzN6d1AwOEV2K1lkeWZOMklmMHVrSDNlRXordnFGb2tDNVVlOHp2WENm?=
 =?utf-8?B?MXAyNHByVU5KV1V6c0NFZlhBTzJqMFQreFU0b3BZVzlzMmFDMXRVdWQrUGJY?=
 =?utf-8?B?czE3b29hd1JxRVQvYk1yaVFaSkZuVDFNOTVwK3J4b3NzNXZjYndZQkFITG9a?=
 =?utf-8?B?QUhXM010RW8rWVhpNXMzeFZSNlpmb1VSeFZ3bTRmZnRMZGxQeDVVaXNhVTl2?=
 =?utf-8?Q?wmJTTpIXqSZso2bOwSofJzsgXfe35qrz?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2024 12:50:46.4270
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8608cda4-3fce-412e-2d1a-08dcdb052d89
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6203

Creating a vGPU requires allocating a portion of the FB memory from the
NVKM. The size of the FB memory that a vGPU requires is from the vGPU
type.

Acquire the size of the required FB memory from the vGPU type. Allocate
the FB memory from NVKM when creating a vGPU.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 drivers/vfio/pci/nvidia-vgpu/nvkm.h     |  6 ++++
 drivers/vfio/pci/nvidia-vgpu/vgpu.c     | 38 +++++++++++++++++++++++++
 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h |  2 ++
 3 files changed, 46 insertions(+)

diff --git a/drivers/vfio/pci/nvidia-vgpu/nvkm.h b/drivers/vfio/pci/nvidia-vgpu/nvkm.h
index 065bb7aa55f8..d3c77d26c734 100644
--- a/drivers/vfio/pci/nvidia-vgpu/nvkm.h
+++ b/drivers/vfio/pci/nvidia-vgpu/nvkm.h
@@ -64,4 +64,10 @@ static inline int nvidia_vgpu_mgr_get_handle(struct pci_dev *pdev,
 #define nvidia_vgpu_mgr_rm_ctrl_done(m, g, c) \
 	m->handle.ops->rm_ctrl_done(, c)
 
+#define nvidia_vgpu_mgr_alloc_fbmem_heap(m, s) \
+	m->handle.ops->alloc_fbmem(m->handle.pf_drvdata, s, true)
+
+#define nvidia_vgpu_mgr_free_fbmem_heap(m, h) \
+	m->handle.ops->free_fbmem(h)
+
 #endif
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu.c b/drivers/vfio/pci/nvidia-vgpu/vgpu.c
index 34f6adb9dfe4..54e27823820e 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu.c
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu.c
@@ -3,6 +3,11 @@
  * Copyright © 2024 NVIDIA Corporation
  */
 
+#include <linux/kernel.h>
+
+#include <nvrm/nvtypes.h>
+#include <nvrm/common/sdk/nvidia/inc/ctrl/ctrla081.h>
+
 #include "vgpu_mgr.h"
 
 static void unregister_vgpu(struct nvidia_vgpu *vgpu)
@@ -34,6 +39,29 @@ static int register_vgpu(struct nvidia_vgpu *vgpu)
 	return 0;
 }
 
+static void clean_fbmem_heap(struct nvidia_vgpu *vgpu)
+{
+	struct nvidia_vgpu_mgr *vgpu_mgr = vgpu->vgpu_mgr;
+
+	nvidia_vgpu_mgr_free_fbmem_heap(vgpu_mgr, vgpu->fbmem_heap);
+	vgpu->fbmem_heap = NULL;
+}
+
+static int setup_fbmem_heap(struct nvidia_vgpu *vgpu)
+{
+	struct nvidia_vgpu_mgr *vgpu_mgr = vgpu->vgpu_mgr;
+	NVA081_CTRL_VGPU_INFO *info =
+		(NVA081_CTRL_VGPU_INFO *)vgpu->vgpu_type;
+	struct nvidia_vgpu_mem *mem;
+
+	mem = nvidia_vgpu_mgr_alloc_fbmem_heap(vgpu_mgr, info->fbLength);
+	if (IS_ERR(mem))
+		return PTR_ERR(mem);
+
+	vgpu->fbmem_heap = mem;
+	return 0;
+}
+
 /**
  * nvidia_vgpu_mgr_destroy_vgpu - destroy a vGPU instance
  * @vgpu: the vGPU instance going to be destroyed.
@@ -45,6 +73,7 @@ int nvidia_vgpu_mgr_destroy_vgpu(struct nvidia_vgpu *vgpu)
 	if (!atomic_cmpxchg(&vgpu->status, 1, 0))
 		return -ENODEV;
 
+	clean_fbmem_heap(vgpu);
 	unregister_vgpu(vgpu);
 	return 0;
 }
@@ -76,8 +105,17 @@ int nvidia_vgpu_mgr_create_vgpu(struct nvidia_vgpu *vgpu, u8 *vgpu_type)
 	if (ret)
 		return ret;
 
+	ret = setup_fbmem_heap(vgpu);
+	if (ret)
+		goto err_setup_fbmem_heap;
+
 	atomic_set(&vgpu->status, 1);
 
 	return 0;
+
+err_setup_fbmem_heap:
+	unregister_vgpu(vgpu);
+
+	return ret;
 }
 EXPORT_SYMBOL(nvidia_vgpu_mgr_create_vgpu);
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
index eb2df9f0fe07..35312d814996 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
@@ -23,6 +23,8 @@ struct nvidia_vgpu {
 	u8 *vgpu_type;
 	struct nvidia_vgpu_info info;
 	struct nvidia_vgpu_mgr *vgpu_mgr;
+
+	struct nvidia_vgpu_mem *fbmem_heap;
 };
 
 struct nvidia_vgpu_mgr {
-- 
2.34.1


