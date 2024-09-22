Return-Path: <kvm+bounces-27264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3026997E1B2
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 14:52:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B2C2F1F21431
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 12:52:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 198183D966;
	Sun, 22 Sep 2024 12:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Niii5kAE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2055.outbound.protection.outlook.com [40.107.223.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B032D052
	for <kvm@vger.kernel.org>; Sun, 22 Sep 2024 12:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727009453; cv=fail; b=KWnPap/qvdVloM/ioEGCuwR1FXph+SoU/zcmaiQYwSxyDRfGTv5ZjUMwbamYeEUv0AlhazryoIH4SE/NsbAWew4sfTwRqSTzjRU1+3FiWgzjAPhIJ1+2cxP6pV0hRAnnVN4C2M87j/b2M3a3AkC+8pZDgAGkcmj3JFiec9CbT4o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727009453; c=relaxed/simple;
	bh=16nA++vFQUZKnxcPiXgHkPJ3k1gqooZg263zvgvKA1k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Akwt3UStyw3GGITTfTXEtOM5iWOKIW9t4AzU1yUoVh8pI0fMeZJFY+DZMZ7bftJ1memWyMzE3TNEjIa9/CtUDZGGUWhbih3s3b9HX80bFutCv9nUtwWuwfLrieuhm45X0tdzFZVZZiWxxdjh8EDWiW+bCY1eKBS4LROcRbiVFIw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Niii5kAE; arc=fail smtp.client-ip=40.107.223.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gdcFWWbJjmHkTkWToojzyf9cc8+YoA80XGls1cVbTKcAF/AE33JBTWoUsB+3Cz3rZjOecQAYId01DSRLorgHUrIoiCC6+2P8mZGnHoIw1NoM/gArSv1d7GrYpsZHeVueokFFpYZqpvvUFC3ZUlgN2ojSS8dUaFVsGrvkXvdL0ww5yMz/Out5pLgFnUf/oQNcpAhmCifmxOO2Bh3ikBQtDcBkLwSDfBbkW03pe/djLruZdODmAMtm4vpHcYEWvrp1pE/69hfR6Ib+w9ZoZ0acl/94rYG/LCze0Bqt+7vZTrzAvn0oznLeCV6lJo/xlPvSyxwNoDrGxT5rdMgVfobhrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CMa2Jz9AWsMojiEGyYYPttR9zgW+Jcd1tgQ2HKC/MoA=;
 b=V8XHy+5AhX+XIlnql9vOrl3rB/XpP/uFafRS5LsDK6MKlGMrR/PpGNdhBGhKTHxvtitLSjO8ddn9Cd0R0M7OHl0NxgxDv1RgMc2whH0I0Smq/FZS/rh8Bls8aDUoWL8ecnDdLlb5+L5y6lqGS+TRDpty9us6FRiVNUFEyIhn81gYdal8zjVPK8j6/tIR1LEapiFaymg6y5bBz4KEjVm+NRwh+VNty1APNWvdleYT9PdyPbaUOemE6Pex58NIWrJ7KusyqRno3g51JQkk/FtCF6+hVPXJQstHd4dKdcVMcnFJtVIAES4Yfv0M9lAwaHTSVnYLtTpAX1adgFU8sRxIkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CMa2Jz9AWsMojiEGyYYPttR9zgW+Jcd1tgQ2HKC/MoA=;
 b=Niii5kAEkZU0V+0GeI1VEu9Gonc0NZjgO2uyrm+D2ZoboM3B6s2/kyQkbxzN3i9QMDlWtWrqb5O3nnoSKkoxgpJdZz2FYcJt6mM/iD1xKM+ZOkXMu3CFjhGKKzKgnQux36gd1W4J/ggp9Wp+2dtGYsMs3rMmAVya+2KLihRBe03PObvlDa2L+LYb0VTgzO2cMhxlAtP264/Ughm8S4naUZg4TqWwVX9QVIRv4ETy1BXa1EZAk3Yr6SQfIJ0zONyv/S4JmiyPpq7kiM8kLHbrFwtkFluQ4KxC4zi+MLH6/4UKJCzKlX/HEAfdLrewOjK0ZcXY+nPvXuWjyx0bDMmyZw==
Received: from BN8PR04CA0039.namprd04.prod.outlook.com (2603:10b6:408:d4::13)
 by SN7PR12MB7105.namprd12.prod.outlook.com (2603:10b6:806:2a0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.25; Sun, 22 Sep
 2024 12:50:47 +0000
Received: from BL6PEPF00020E5F.namprd04.prod.outlook.com
 (2603:10b6:408:d4:cafe::2f) by BN8PR04CA0039.outlook.office365.com
 (2603:10b6:408:d4::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.30 via Frontend
 Transport; Sun, 22 Sep 2024 12:50:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL6PEPF00020E5F.mail.protection.outlook.com (10.167.249.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Sun, 22 Sep 2024 12:50:47 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 22 Sep
 2024 05:50:31 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Sun, 22 Sep 2024 05:50:30 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Sun, 22 Sep 2024 05:50:30 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>, <nouveau@lists.freedesktop.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <acurrid@nvidia.com>,
	<cjia@nvidia.com>, <smitra@nvidia.com>, <ankita@nvidia.com>,
	<aniketa@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC 17/29] nvkm/vgpu: introduce engine bitmap for vGPU
Date: Sun, 22 Sep 2024 05:49:39 -0700
Message-ID: <20240922124951.1946072-18-zhiw@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E5F:EE_|SN7PR12MB7105:EE_
X-MS-Office365-Filtering-Correlation-Id: 546ad3a8-41ed-40ac-5659-08dcdb052e34
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?79jMkd13FD6qI3iS7R2kvB8IweXP0jXsfFu/zzR3RmPiXIlqbRzSmnZfk2cG?=
 =?us-ascii?Q?60/jsQWgSvpdg67yUIvkNgd3LGEvBqfRqINLaMDr7arIx9FAKkM7wELpLSf0?=
 =?us-ascii?Q?QOQTI4f3d1QCt1PGQNneRDo0HXIt4bthjuE9n6iv5szRebwMcHUZJuxYcUnY?=
 =?us-ascii?Q?eLXQViVQikz4SBJgJzdzpYqwDIupUWnQReAk+TcnZIoOLqVJgbW4AWbhzIwM?=
 =?us-ascii?Q?NbX03Xktz98bNmQPXb55gh9EBPKHD3EYeyhkolL1xLBHbuLWX4uwMk2u0ki2?=
 =?us-ascii?Q?3w64c/tP1g0sxYtqRfuCwcrOAsytMCEUOEtgsVgqOo539oY39PnE6glNbhHM?=
 =?us-ascii?Q?Z4qVaQwaVZ2jDi11rsdKxkJXc1AEfwkTTPoKU36KWSIUjm0TwlxSvZ6tfYry?=
 =?us-ascii?Q?80tD8lvcNJjIMSgOpovlhrgqJfILzrXlhFKblv7E5AI5Gu5dwKUvTTWbrAYz?=
 =?us-ascii?Q?IHgXRZuu79GFOyxmIU1LTPN0efn6Z49+3t8nROxg/GI/86Z/RuXvWhtDF+mr?=
 =?us-ascii?Q?jLCIXyb/S3Dxj9eE91rgW7EwoOTH4p/nYGwe27iN8mkHjPHTe9NdW12qZcSc?=
 =?us-ascii?Q?n8NNxPhiRZ94ESgo5KqjKXXR2x8pFLn8md04/66vwR0mdy6xbFFZ24sx2RRA?=
 =?us-ascii?Q?8fbkDjBhTkWTGeg17NJJLQIVH8eQHu7iHWEd6R5cMwqB84IMrt03q89RxIwk?=
 =?us-ascii?Q?FOf0yBfCfa53wbRYFU00cqFXE16KOyat8ytN1HOpwM7XC/0Ti2YSm51D60Vz?=
 =?us-ascii?Q?RYxZcjSJZxdm2aJuGgPPiui/5aRfXslRYvi89Rhj7C3DzMusqTDns7Qkywh9?=
 =?us-ascii?Q?kGwssuKcTPzEyxFjAF8H2Ow4+oseazrYVTGebjpOVcRFIjzv69X/3DMN1dU8?=
 =?us-ascii?Q?GgosHbxPznxc7tLXS3QkUaq1cUvHxGOKuieZ0R2b/iRJB6HeY7sNnVjQgqjA?=
 =?us-ascii?Q?bp+M4wr0p079XTAsjxxFpGvHEKyXnr9bPkUcYNpc5iCgbBDU2B2mZyGP7QNf?=
 =?us-ascii?Q?GUt6fH93twjFVZXEou+gK1fISgzgSU8Ozzob8ZNYet00t3OIgZ6Nzr3JLJNa?=
 =?us-ascii?Q?Sqj4sAhv98Z2pfY9m4+g/9k+fjvgCxNBvPX8vJ4Ogd/do+q9TyF1EC2gbabp?=
 =?us-ascii?Q?nC7PRmEZWI3Knj0qPQEAsamkSTP80bVZ2Dyb72DSAkPVgokCqzwd8Ji8ANnP?=
 =?us-ascii?Q?DiWugS0x3ZMPRxuY2nq6L2HNBC54vB4NH+PkSKyXpkMeTcZ6iPhihakxaSiW?=
 =?us-ascii?Q?p59TWQcEQ/3LiMG6DeWgCZ640h6aJGhQKO/jtPpYLkdCUj0mFOEzCFhanOml?=
 =?us-ascii?Q?EmztQNDgbHOVNefQdP8WQ6WEig/W1alIi8VdzYUlG3/sJ5y7E8wff3uFbzpM?=
 =?us-ascii?Q?vs8gJcBeY8MbT0p+A6N/bhAYo7MavtYB5YXbJG+NLQTgHJatkTJDFlbbUMC1?=
 =?us-ascii?Q?Cd7l7HnBhvZLNMM8E0PDEQYPJEFQjOZn?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2024 12:50:47.4238
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 546ad3a8-41ed-40ac-5659-08dcdb052e34
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E5F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7105

Activating a new vGPU needs to configure the allocated CHIDs of engines.
Thus, an engine bitmap is required.

Expose the engine bitmap to NVIDIA vGPU VFIO module to activate the new
vGPU.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vfio.c | 15 +++++++++++++++
 include/drm/nvkm_vgpu_mgr_vfio.h             |  1 +
 2 files changed, 16 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vfio.c b/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vfio.c
index 535c2922d3af..84c13d678ffa 100644
--- a/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vfio.c
+++ b/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vfio.c
@@ -3,6 +3,7 @@
 #include <core/device.h>
 #include <engine/chid.h>
 #include <engine/fifo.h>
+#include <engine/fifo/runl.h>
 #include <subdev/bar.h>
 #include <subdev/fb.h>
 #include <subdev/gsp.h>
@@ -248,6 +249,19 @@ static int bar1_map_mem(struct nvidia_vgpu_mem *base)
 	return 0;
 }
 
+static void get_engine_bitmap(void *handle, unsigned long *bitmap)
+{
+	struct nvkm_device *nvkm_dev = handle;
+	struct nvkm_runl *runl;
+	struct nvkm_engn *engn;
+
+	nvkm_runl_foreach(runl, nvkm_dev->fifo) {
+		nvkm_runl_foreach_engn(engn, runl) {
+			__set_bit(engn->id, bitmap);
+		}
+	}
+}
+
 struct nvkm_vgpu_mgr_vfio_ops nvkm_vgpu_mgr_vfio_ops = {
 	.vgpu_mgr_is_enabled = vgpu_mgr_is_enabled,
 	.get_handle = get_handle,
@@ -266,6 +280,7 @@ struct nvkm_vgpu_mgr_vfio_ops nvkm_vgpu_mgr_vfio_ops = {
 	.free_fbmem = free_fbmem,
 	.bar1_map_mem = bar1_map_mem,
 	.bar1_unmap_mem = bar1_unmap_mem,
+	.get_engine_bitmap = get_engine_bitmap,
 };
 
 /**
diff --git a/include/drm/nvkm_vgpu_mgr_vfio.h b/include/drm/nvkm_vgpu_mgr_vfio.h
index 38b4cf5786fa..d9ed2cd202ff 100644
--- a/include/drm/nvkm_vgpu_mgr_vfio.h
+++ b/include/drm/nvkm_vgpu_mgr_vfio.h
@@ -48,6 +48,7 @@ struct nvkm_vgpu_mgr_vfio_ops {
 	void (*free_fbmem)(struct nvidia_vgpu_mem *mem);
 	int (*bar1_map_mem)(struct nvidia_vgpu_mem *mem);
 	void (*bar1_unmap_mem)(struct nvidia_vgpu_mem *mem);
+	void (*get_engine_bitmap)(void *handle, unsigned long *bitmap);
 };
 
 struct nvkm_vgpu_mgr_vfio_ops *nvkm_vgpu_mgr_get_vfio_ops(void *handle);
-- 
2.34.1


