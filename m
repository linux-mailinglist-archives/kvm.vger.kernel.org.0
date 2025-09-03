Return-Path: <kvm+bounces-56704-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9394FB42C92
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 00:12:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C9DC37ADA56
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 22:10:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFC602EE297;
	Wed,  3 Sep 2025 22:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="s+lWP4Xq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2059.outbound.protection.outlook.com [40.107.92.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0EB2EDD47
	for <kvm@vger.kernel.org>; Wed,  3 Sep 2025 22:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756937500; cv=fail; b=knl4MJUg+PI3FIvwRuNHr0LpU+JeyP9V1h2T5NtutzmiqM9MxzqS2Zga+9mo0//UsPFrpUm4U89VvWN4coexIp97Llf0A5GYd8ROHMupA8rIm8nr+TR8gXBpX0uTKru+3J89EVLK22Sy/k5l9RLMc8YP4jelDSOyXWKB9qjVhyQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756937500; c=relaxed/simple;
	bh=b/9Uwao7bK6HM0445ochWM4PQgDqFNsNmm1RuQ9DrMQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=onKWuBVqvCDRRjSAx/S44TGOGGuHUch2gxMsEE7P0yLqeiaBmd1UkEhqGFXSxoEfbRm8AHp/Rx6PNxl4An9aAgGm3ecSOP+WWlDciYxQgzYPqWMC1pql3oiQch2YYZGy14MwawQiKWsczXWzgmMHG7UBwuRfrJm6lSt8c5ShzsA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=s+lWP4Xq; arc=fail smtp.client-ip=40.107.92.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cYN1iUWbO966rmYxpg4by6eYNcjotVA+aWSmtsnOUQDzDwOqugp+IzumNISYOzM1B7vEcxenikBmVRmXapMbemt8/xwwa8qgm/1CFOf3JlzHiwD5AKbAjKOZeQcVx/PdbCdspXfDorJb5j7SXIQzjCPNyvgouLndbCcTpzALeY5zmmZyWr9ZLybt48qF63XvL30Gf4Yu1k53HWFIimNy/ZIHYud6HY3Z4PTXQhuDzKww0Nf8gTpraYr5L9wJN2K3ykrMKVrXvL7jYa56qRGGl1LI72ByTa9qfCOgLsHj+U/kNwiyIaS9wTRWI+mzP4sGLaZhU4/I9tuT70t/MN4Rpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YUMW4qBS0TpRG6gbUQ6z1N4aqI1QqoXd2hVoJkyNI10=;
 b=kp5EO74SgbCgcicFT0doxsK0dm7zPg44dVDy3HExbn5dJ4oP/79GKdbRsQxVWXBWnVXx+NNu/rRgUywzeCL0gmY6bxOFZt/YkISCqW5gZ0fD6WPEenHZNrwEAo2dBceleSSiXiBgIdz0fIGKKL2J3uOPTTzwFIrEIFqAmIEdg0J5r2Nc5l2uvb424x+4RRzHvlRdNLwpAoG4gSDxVueo9ZqyQpObX1ZhIF3w2M9enmgyHHEIx7vCcOQV3i0ExYR9LWRVqI59AD0NfEueVsNAy3T9UlCgA3WRcouzAg1R8rXv+oi5CjLMcmo4G84Wd1wUbGRWM5Zp4DQyCI2Va9wE2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YUMW4qBS0TpRG6gbUQ6z1N4aqI1QqoXd2hVoJkyNI10=;
 b=s+lWP4Xqz3MSn12G8MlXCgNNI3ewN3q/+LxkQhk2PXpGd1S5ib1vKLRKi4AuCtgfs+nZvtbbvpPf09jZ6Jqj13IuWiH0qA3oVGnGrq7mdUK8h8mjrsyNlXMkNVOqxuwUgM7+qS9JFeeKObWI0KKXkx45nYXf//gF+wSYnX59ZlXUob/e3wT6sYjmyP4tSoA/CB5xW/DX8VOuXzsnv9mFOED5RdHXRcd+9yelibhune8UwS750chowy1xibUV5SBe6WsMSX1gg93GxtSBcuh0179163Uh+hQa+ofN6GGT8wMDDFIhRIR7LT+c5sjZFiUb0KjWDDEVc9KJ5kCxuo52ag==
Received: from BN0PR04CA0135.namprd04.prod.outlook.com (2603:10b6:408:ed::20)
 by DS0PR12MB8574.namprd12.prod.outlook.com (2603:10b6:8:166::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Wed, 3 Sep
 2025 22:11:35 +0000
Received: from BL02EPF00021F6E.namprd02.prod.outlook.com
 (2603:10b6:408:ed:cafe::76) by BN0PR04CA0135.outlook.office365.com
 (2603:10b6:408:ed::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.27 via Frontend Transport; Wed,
 3 Sep 2025 22:11:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF00021F6E.mail.protection.outlook.com (10.167.249.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.14 via Frontend Transport; Wed, 3 Sep 2025 22:11:34 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 15:11:14 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 15:11:14 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Wed, 3 Sep 2025 15:11:13 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <dakr@kernel.org>,
	<acurrid@nvidia.com>, <cjia@nvidia.com>, <smitra@nvidia.com>,
	<ankita@nvidia.com>, <aniketa@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC v2 02/14] vfio/nvidia-vgpu: allocate GSP RM client for NVIDIA vGPU manager
Date: Wed, 3 Sep 2025 15:10:59 -0700
Message-ID: <20250903221111.3866249-3-zhiw@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6E:EE_|DS0PR12MB8574:EE_
X-MS-Office365-Filtering-Correlation-Id: a6bb50e2-7a5b-4eaa-a201-08ddeb36d830
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kQDYw4JGDxuEYJEfzQORG7/oOSu6eWMb0NKrVJ5cj1zJ/yQNOF2ixnWWvpf2?=
 =?us-ascii?Q?YVgJgeKGRHzHZmwbZzKbfEvBYaTl3AnC/XUCvXMpXdXYQYTlfcOZQOF7Fe1i?=
 =?us-ascii?Q?G847UD2I2u9EQQ0vo4/PJWj5DRFOidmOgjXfe3WabRuuLHjFAo0/hN7DrLgr?=
 =?us-ascii?Q?nvy05LCfrKm44vaBSpogHOV4KdvLGTVWve70mo9mhTZwEQqVVV+YxgaGWGDN?=
 =?us-ascii?Q?XSlXCnAsu3RSC7+uB/L3X81iHeJxBq4hAdCm/+Em1YFwzqDKf5sGK+uebNps?=
 =?us-ascii?Q?oelFDgGLPgzyOezJFhmNy8yHzwXeyHSm8inX15DdQB6NcktKmFjeZyuvtLgj?=
 =?us-ascii?Q?vWdYJMKJblAOxNpqr+JTQYGNF8Fv0r1G1jsjXDFqGzY+2PDg3nH0iSPt4Kht?=
 =?us-ascii?Q?LAJvXTIDGEJAmpmK/xeze3dznnIM4hzCX13ep9WpU1Tg4LiNP3RT5U6sZzjb?=
 =?us-ascii?Q?NBnpf+zXrCdkrm5CRjCa5w6JVOVNKmW4mhKz/CD9WeFH038V542m+4TH2ufm?=
 =?us-ascii?Q?hoJZqiTHyhocxNBIbinxY7wZi3Rf4UcjZelhp3nFN9Zc23jXhjkvZnAeDsoP?=
 =?us-ascii?Q?jQTqwht+Awn7ndjhoLdVsuoRfV2XTUoen5f8HoM28Q+OO4yLJ6kSS7LKXl3m?=
 =?us-ascii?Q?PYGLCd7BA6DnCBpk3KxAVgds5NOirDMkhSkySnVbRSoIG2EWA9H6IDTcws+6?=
 =?us-ascii?Q?DHkygt3kv80D9pMNWCT3HA36PozlTjpx8gFkTNjgipiE5hUfstpCDVuW5PQE?=
 =?us-ascii?Q?HlvPyNSVCdGDVNa23MdJyeSwjwB2R9HTJKXX5prQ8UdDksC9PBSKsQE2p1AU?=
 =?us-ascii?Q?Q7CRlB0OD3t/uhrCXmmaZivnOzqXE6ArQh4CyuSG/Z8qZCWoMvMO2pqzRgUO?=
 =?us-ascii?Q?s/N2tA9CqWvSIbMmL/S6U7Wj++yRt8u/vEyXlUXZuQnGpqbn1ikl/Op3AFmf?=
 =?us-ascii?Q?CalAFLURwO8SmT6DYAGopvStPC+VBJi1Am673bdpb1YIb0/UjjFPY1qQPtS2?=
 =?us-ascii?Q?kEd2eeq5AYrAhNfcTnRtRQSpm37UKo07KPybpTSRBnu+pDxpRoLLdAAf/cwO?=
 =?us-ascii?Q?3B6oyY7UeCiA3mJdUD/wHnTSkCBWGtyPkIPtMlmxKnIrW+thgL9QS867Hahz?=
 =?us-ascii?Q?Hv8wk7MBSXk7+s3XhLfdI6pO6SrnHA0PBuaHUQ2JxgGiuGWkbIFdomaUJjtY?=
 =?us-ascii?Q?j0pbq8xJmmRj6bhHomSWkELNgt1MJzjxHjXM9+gHcjAFEfIZwgeotrO5boPB?=
 =?us-ascii?Q?4/SAf4yd53RUUFJEqraHUNqc8amsmXoX6wkFMCMBlNgIFgPxIwwwhnAXunWb?=
 =?us-ascii?Q?S/a7HRjNLtHiDxvIZbPOxhVEcs4AlNXcO9B9Y+vY+svMgKDzE/F5o6NKTnYY?=
 =?us-ascii?Q?wYLeCsTSVBFWhY4KAyVMWQr2poWvisH8id2y4Rwunf4PDjzvGlInH1qBqbHh?=
 =?us-ascii?Q?SKzyfsqCJEb3jIH0atmVD+p/wJskaobZpXyQohR5vjUQaXJTKyv3dtFZEive?=
 =?us-ascii?Q?neQ7ZdNn8OmvMQK8Dle31S0CWFaVwqE0hTNw?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 22:11:34.2508
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a6bb50e2-7a5b-4eaa-a201-08ddeb36d830
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8574

A GSP RM client is required when talking to the GSP firmware via GSP RM
controls.

In order to create vGPUs, NVIDIA vGPU manager requires a GSP RM client
to acquire necessary information from GSP, upload vGPU types to GSP...

Allocate a dedicated GSP RM client for NVIDIA vGPU manager.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 drivers/vfio/pci/nvidia-vgpu/pf.h       | 11 +++++++++++
 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c |  8 ++++++++
 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h |  3 +++
 3 files changed, 22 insertions(+)

diff --git a/drivers/vfio/pci/nvidia-vgpu/pf.h b/drivers/vfio/pci/nvidia-vgpu/pf.h
index e8a11dd29427..044bc3aef5a6 100644
--- a/drivers/vfio/pci/nvidia-vgpu/pf.h
+++ b/drivers/vfio/pci/nvidia-vgpu/pf.h
@@ -62,4 +62,15 @@ static inline int nvidia_vgpu_mgr_init_handle(struct pci_dev *pdev,
 	__m->handle.ops->get_total_fbmem_size(__m->handle.pf_drvdata); \
 })
 
+#define nvidia_vgpu_mgr_alloc_gsp_client(m, c) ({ \
+	typeof(m) __m = (m); \
+	__m->handle.ops->alloc_gsp_client(__m->handle.pf_drvdata, c); \
+})
+
+#define nvidia_vgpu_mgr_free_gsp_client(m, c) \
+	((m)->handle.ops->free_gsp_client(c))
+
+#define nvidia_vgpu_mgr_get_gsp_client_handle(m, c) \
+	((m)->handle.ops->get_gsp_client_handle(c))
+
 #endif
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c
index 3ef81b89c748..1455ca51eca1 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c
@@ -16,6 +16,7 @@ static void vgpu_mgr_release(struct kref *kref)
 	if (WARN_ON(atomic_read(&vgpu_mgr->num_vgpus)))
 		return;
 
+	nvidia_vgpu_mgr_free_gsp_client(vgpu_mgr, &vgpu_mgr->gsp_client);
 	kvfree(vgpu_mgr);
 }
 
@@ -140,6 +141,11 @@ static int pf_attach_handle_fn(void *handle, struct nvidia_vgpu_vfio_handle_data
 	if (ret)
 		goto fail_setup_pf_driver_caps;
 
+	ret = nvidia_vgpu_mgr_alloc_gsp_client(vgpu_mgr,
+					       &vgpu_mgr->gsp_client);
+	if (ret)
+		goto fail_alloc_gsp_client;
+
 	ret = init_vgpu_mgr(vgpu_mgr);
 	if (ret)
 		goto fail_init_vgpu_mgr;
@@ -157,6 +163,8 @@ static int pf_attach_handle_fn(void *handle, struct nvidia_vgpu_vfio_handle_data
 fail_init_fn:
 	detach_vgpu_mgr(handle_data);
 fail_init_vgpu_mgr:
+	nvidia_vgpu_mgr_free_gsp_client(vgpu_mgr, &vgpu_mgr->gsp_client);
+fail_alloc_gsp_client:
 fail_setup_pf_driver_caps:
 	kvfree(vgpu_mgr);
 	return ret;
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
index 9fe25b2d8ec1..98dcbb682b92 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
@@ -51,6 +51,7 @@ struct nvidia_vgpu {
  * @vgpu_list_lock: lock to protect vGPU list
  * @vgpu_list_head: list head of vGPU list
  * @num_vgpus: number of vGPUs in the vGPU list
+ * @gsp_client: the GSP client
  */
 struct nvidia_vgpu_mgr {
 	struct kref refcount;
@@ -64,6 +65,8 @@ struct nvidia_vgpu_mgr {
 	struct mutex vgpu_list_lock;
 	struct list_head vgpu_list_head;
 	atomic_t num_vgpus;
+
+	struct nvidia_vgpu_gsp_client gsp_client;
 };
 
 #define nvidia_vgpu_mgr_for_each_vgpu(vgpu, vgpu_mgr) \
-- 
2.34.1


