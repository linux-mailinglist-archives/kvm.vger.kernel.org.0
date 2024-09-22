Return-Path: <kvm+bounces-27272-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BF2597E1BA
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 14:53:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 921B81F212F6
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 12:53:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45417558B6;
	Sun, 22 Sep 2024 12:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nkJ+Sr1L"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2067.outbound.protection.outlook.com [40.107.212.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A724C627
	for <kvm@vger.kernel.org>; Sun, 22 Sep 2024 12:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727009461; cv=fail; b=rCyRm7aWqWPdqmnvagZy/gyHQ+HghyQNMC6/L0sI+KVVKu7622AJWc77FQxoDaPd3cOvZ8rxu0JylDJ5gozof9UQvCwrMGlFZ5dYyJuhAhoqvZYYYUNsCMBhfQFXsS9qyMpPRfQ9eRTH5ymt7d+4jmgwYpb9w8rFKizQb+7QuFw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727009461; c=relaxed/simple;
	bh=NujKwmUego+xcu3y+yRH1s36MrLeJMCUOAp9gCyg7xc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BulwM0via2HPaL3gGe6xejBfVHu4mjwCCgtgQk6VBJZWHsTd83EpSIcEu8uWLyBXJswt03VLoIA5NPubgoTwvXJd1UcP/hdP6IWlCWI4Ro5kqPwXD48Y2eENFA530JdzJ8lT8wlx3kBOEPmazoFm7ONiCT84cNFYwbZONt/LKDk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nkJ+Sr1L; arc=fail smtp.client-ip=40.107.212.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c3NRnIJVVi6fZbngUZNx7uoBQY//fpG8X7TlmLL59O+ylxihUmulJiBjOR19VLKG7CjvSySNHr/GKTlTcqXaj6lA4jBWQiR5TEXqe4rF+jZCNekc7rQ9AukoeX6wveAIW+Wt+p22x1F6Gi0l7d08RhnIJsxBr2HUzlDqbbbWZ2z+B5j9GV7wM5IgUF1VMprCz9JmFzweXn4E6550Dp7QVqsfRDQ7kFcy95Sa30dIe4r3QzndZct2XsfmD+pefW7ZjEJGBiARu7vcBZ5vyFlYzFTmsL+8q8nvxgMIjY+yxzOG0fP8VjVJDFuwuRQaFHM4RfCdZfIMJ+eaDNmqK9OZ5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4zFR+jTfKH04tmYtUSihJrOSgRvqGnHfZmRY6KjZvHs=;
 b=cC0YVFkyjdAOaWeuHQ3p+b8Q7kxO9grvYzpYSqnIklijCz++Eb48+BGnnUuWt4RvB1833GLSQDH57l9ig3DPuRVrNoGpVSJqqvA7fTNzuhaeMjlSM3BOj/7I5a6VQQdW9Ol5/Zid9BNgC6LVQQLPdufbfWOyMhndJ4srBC7DTRAz54GYrbhfnKHOzY9VtzJk1v9z5MjWmV3lRZWjztl+UCJFp3+UvwBlwG6N068p/TTfiWPyiq9ndgdLy5VMBLbcCSjB3SULAISnN5PJYqbrcpnXiyp939mq/whkCVRx+BgFvo1hXpZz5Ah84q25qzXfp+J280jcmSEXWeuFM0k9kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4zFR+jTfKH04tmYtUSihJrOSgRvqGnHfZmRY6KjZvHs=;
 b=nkJ+Sr1Lem+yCUI35KG20hSdXkbqAegxIkWFzQAVyOzFBEVEw4Kkdoqtw1kkpytFO/qoX+acErmizfcNCsl6IcTm5P6m7eIsKAdwfcFssGpPPp/EsBKR29+Q3AP0blfJc5+w50V73f73QwLzW7g5AZzlQVhq9KvWT5zL+eFt+kq3cZIrh29XHcZkEuRarfT7yXnsyYKGEDjQbxUeC782mM6Cx31+leD0sGpzGe9l22Eye827+R7dTgJrfjCnXZQovsEdTdTiin+dguNDvzJSna2IQIvpE6vB14KvX/v8BaDGfv8x7GHdii043zWZl6fGbeQCS+uwcoplj+mmXKoDBg==
Received: from BY1P220CA0012.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:59d::8)
 by IA0PR12MB8975.namprd12.prod.outlook.com (2603:10b6:208:48f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.24; Sun, 22 Sep
 2024 12:50:52 +0000
Received: from CO1PEPF000075F2.namprd03.prod.outlook.com
 (2603:10b6:a03:59d:cafe::c1) by BY1P220CA0012.outlook.office365.com
 (2603:10b6:a03:59d::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.23 via Frontend
 Transport; Sun, 22 Sep 2024 12:50:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1PEPF000075F2.mail.protection.outlook.com (10.167.249.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Sun, 22 Sep 2024 12:50:51 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 22 Sep
 2024 05:50:37 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Sun, 22 Sep 2024 05:50:36 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Sun, 22 Sep 2024 05:50:36 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>, <nouveau@lists.freedesktop.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <acurrid@nvidia.com>,
	<cjia@nvidia.com>, <smitra@nvidia.com>, <ankita@nvidia.com>,
	<aniketa@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC 26/29] vfio/vgpu_mgr: allocate GSP RM client when creating vGPUs
Date: Sun, 22 Sep 2024 05:49:48 -0700
Message-ID: <20240922124951.1946072-27-zhiw@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F2:EE_|IA0PR12MB8975:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a803d22-b54c-43e9-7f01-08dcdb0530a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DbNXr8eqeciymHsUMlQYBKVt5253IOhKBCEWcdHR7BreYzd1WA1sQmmHMs8/?=
 =?us-ascii?Q?XQH8KaKVmtyv55XM+pddsvBjHboFtjLsKdjJrGIQQa1kaWRooDT2LbkWs2y9?=
 =?us-ascii?Q?eZQb3wO5J4+4FQF7OXpvRygLTYH+5o0GiXR3rshvUVm1JZDpCyNhaOnA9m+e?=
 =?us-ascii?Q?w3dU22Hm315KAW+URdiO9Ix3uc/fvqGscBdBi9cEIJ0uZ9wUBwF2i3ITceEc?=
 =?us-ascii?Q?SnnqgY+SwmeuafxmRW0pa3KoR924K2qQH8qtiC46H7NSm/GIAGrP5wxVq129?=
 =?us-ascii?Q?v9WsSrFncv6uA9HORgpzD/Tq7mhCYoGuQo4KqCMFwpn0JTtntr7lNTaAczT0?=
 =?us-ascii?Q?Q+8rZe9IF8tx3mUsWro4qIAOn2wb1YAaDHgLMW3QkzWXl7vEb7Zss3yE0LMQ?=
 =?us-ascii?Q?DheBUii6GEogZxcFDnfzSk2xEl0MtbOXMV64J5D+45+IAsc4UceyRcwQWyLf?=
 =?us-ascii?Q?QIYfz5ssZALXwqVoG9TpBF9bVrkyJ0hgGCMSekfZaOgW6+Dqqs/yrIWglPR8?=
 =?us-ascii?Q?xXHge1l8B5pjVh/zURygftiGUOzraTroJgHPB0nVbeWzfCVR5hRTJop/W79F?=
 =?us-ascii?Q?lRErI/9gbgLtWmvYlOt1iukeyUwulwbftK6GBIF1hFBa7eWPlWAV34d6eLs+?=
 =?us-ascii?Q?OOJFAmZeIVIY1DibC9HaJQxmWZTe8YEWcsTgkCGL7PajGgijCclZ75qdfyGU?=
 =?us-ascii?Q?hubveE9HEMoiwstJP3SOXV+XI5PcVGPJHjgeVOlX3zVIDW38INo1OO+Rq1NJ?=
 =?us-ascii?Q?fRvHNPoxXAPnCTMm09eDuNNMk+gJC58Ugh42XiljOcNHrHvJ6eEHS9NemSXC?=
 =?us-ascii?Q?4ZKtVlW+wwXeVqULL+JOZdYNRrRMRQi69EsTqt7tilJNLZ6rKdxw1DfYsvWR?=
 =?us-ascii?Q?BTuRioomEqb7r4rkx8LumfKxW010uSW4lG/R9nyTzGqtdNCIgscHEbTi+BZX?=
 =?us-ascii?Q?MSK/oVp+tdvPMqIMMhc+zYK99J1mC3CDhetDZ8aa2hMc/EHVtOO7FDW6jY/k?=
 =?us-ascii?Q?VqXNSRXzxAqqHqYJVm97FStK7Vt/zrJHQoWbz9WoDAfb85GnJ74d6ukWzI7O?=
 =?us-ascii?Q?u0LfLZHgQIyBiVhAYuJ/kAmh0vNua4wabAuz2m/nlFnY6GoqMfyVla13lOvj?=
 =?us-ascii?Q?eLsX4LgE1Ez6bY77aPyg9Kwo3M/DEyCJCswqGcb1rynrT/TMQ+BtfYlNhWn2?=
 =?us-ascii?Q?RDlbzEQBtzkyoXsJXmsVCDn8NXTopjutHQ82yevNTNmj8QdK6K6r8c36EkR4?=
 =?us-ascii?Q?CZqkWoDg28wOZFWRjqb88KJ2hHFLqSUHDxCKKPlqcIuYQa82eKwYU0JvhKeS?=
 =?us-ascii?Q?rpsbhoS6n4XAjj/6U8pyRm94pkXG3M9zaExt0bLHeCWJ6Qdf756PsIhfXnmV?=
 =?us-ascii?Q?Fm3N6P/6BS+h7kQva9Ig3TqlMXgX?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2024 12:50:51.6458
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a803d22-b54c-43e9-7f01-08dcdb0530a5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8975

A GSP RM client is required when talking to the GSP firmware via GSP RM
controls.

So far, all the vGPU GSP RPCs are sent via the GSP RM client allocated
for vGPU manager and some vGPU GSP RPCs needs a per-vGPU GSP RM client.

Allocate a dedicated GSP RM client for each vGPU.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 drivers/vfio/pci/nvidia-vgpu/vgpu.c     | 11 +++++++++++
 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h |  1 +
 2 files changed, 12 insertions(+)

diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu.c b/drivers/vfio/pci/nvidia-vgpu/vgpu.c
index de7857fe8af2..124a1a4593ae 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu.c
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu.c
@@ -149,9 +149,12 @@ static int setup_mgmt_heap(struct nvidia_vgpu *vgpu)
  */
 int nvidia_vgpu_mgr_destroy_vgpu(struct nvidia_vgpu *vgpu)
 {
+	struct nvidia_vgpu_mgr *vgpu_mgr = vgpu->vgpu_mgr;
+
 	if (!atomic_cmpxchg(&vgpu->status, 1, 0))
 		return -ENODEV;
 
+	nvidia_vgpu_mgr_free_gsp_client(vgpu_mgr, &vgpu->gsp_client);
 	clean_mgmt_heap(vgpu);
 	clean_chids(vgpu);
 	clean_fbmem_heap(vgpu);
@@ -171,6 +174,7 @@ EXPORT_SYMBOL(nvidia_vgpu_mgr_destroy_vgpu);
  */
 int nvidia_vgpu_mgr_create_vgpu(struct nvidia_vgpu *vgpu, u8 *vgpu_type)
 {
+	struct nvidia_vgpu_mgr *vgpu_mgr = vgpu->vgpu_mgr;
 	int ret;
 
 	if (WARN_ON(vgpu->info.id >= NVIDIA_MAX_VGPUS))
@@ -198,10 +202,17 @@ int nvidia_vgpu_mgr_create_vgpu(struct nvidia_vgpu *vgpu, u8 *vgpu_type)
 	if (ret)
 		goto err_setup_mgmt_heap;
 
+	ret = nvidia_vgpu_mgr_alloc_gsp_client(vgpu_mgr,
+			&vgpu->gsp_client);
+	if (ret)
+		goto err_alloc_gsp_client;
+
 	atomic_set(&vgpu->status, 1);
 
 	return 0;
 
+err_alloc_gsp_client:
+	clean_mgmt_heap(vgpu);
 err_setup_mgmt_heap:
 	clean_chids(vgpu);
 err_setup_chids:
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
index 404fc67a0c0a..6f05b285484c 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
@@ -36,6 +36,7 @@ struct nvidia_vgpu {
 	u8 *vgpu_type;
 	struct nvidia_vgpu_info info;
 	struct nvidia_vgpu_mgr *vgpu_mgr;
+	struct nvidia_vgpu_gsp_client gsp_client;
 
 	struct nvidia_vgpu_mem *fbmem_heap;
 	struct nvidia_vgpu_chid chid;
-- 
2.34.1


