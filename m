Return-Path: <kvm+bounces-27269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F6E697E1B7
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 14:53:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2CB7B1F21484
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 12:53:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39FC64F20E;
	Sun, 22 Sep 2024 12:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Fwsc9/HE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2074.outbound.protection.outlook.com [40.107.92.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C674F4D5BD
	for <kvm@vger.kernel.org>; Sun, 22 Sep 2024 12:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727009458; cv=fail; b=A5yMBlIA5F7ZZc1lzDCTZVB8Mk8PkIard9ddlWXFX+AB1SuAT6njf1SSId+EyUPX0oBZBYYhIbMw9MrWW30BVo53slnp/ibhgPITWATtq4jd5bhbqvVP2a3YbsrduPovmWuV94uIV3t2SVa/C43u9iY8O52m8RqPcQUshKaV9yY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727009458; c=relaxed/simple;
	bh=ff1xskTw26AfajV1se3vpJDotZgOnYUB9qLw8974YNo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k/ypkl3ue9ok0Mu0LtHRzxeurZx0uumS0C7xwg3w3N6aNnnrXOE/PyAPdJWpwkhEPdUYx9vWyxvWg2FJfp9w7i0pFF5v+qDQB6LRwdbd5Rz+kF6oa7OkJEWPAMl3DPMkM+yAoXYG50XmGXn3l8w1/N5wXGjK1jUdtiBDflPVYac=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Fwsc9/HE; arc=fail smtp.client-ip=40.107.92.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UY+7sb0Ht54/LdFdP4h4Kt1N4LOkJrrNCbJnhhYwOonSwzA7IRcNyzPzo5I69bsYAsOsJ2uep8dI7hIrPQMKVo1nwVX+PpzVlGlf3awxu1UCNcqt/v40ASMVOuEopNhJ/5eVvDnfayCJC56OMycdGWL1T5d5rJhUPkC9AnbIeUZ3tDQfTdCdyr1omMqyMlUODWMmFqblhL5/UK5puzThq2l6MaoWnTGyeIpAVF3FojpiIaFUEoZt0k0FtNTAs12FycWCp5l8bAvEErwtRUF3XEcw6LKOUmWh054zb6IIt8AWbU7H6E+SwY93W/ENPs8q1GVlG5slPi5iMbleE+cm3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NuMxwSlxxwMBgJ7m0PiWCabGj7yS2OaIHe1FmdY3dpc=;
 b=aQ0+aUZbIdaSi/j9y1sudRO6LoGgKvNlwwQOQH6vGfS1z8i/h3kdXgOt7/7JUv8G8X3nMOo4YVAQcRCh6JWYhri2BJh+dkajv8J8kzRrppriiUREvmVbhSGPD5xwphe5xlew7G+sncotxYjOlyFEZjLkY5Of8tTexLXIsQm3sMeK13ar7sqQSTqoiXuzgx4xDSEVUiiiNCGY+d2+BiPnKfS2k396dfAmCJHFUBSpZSdiI/bbszZ0S9T+JFRJXsuTXHGNXiUYEProsLmgfCq5OTyiMawtT8CqD3UN8prXOcOCsf2h1CGfz1Q8LW+KK3IHAz9LdCBDfbWRCdHhhmwCEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NuMxwSlxxwMBgJ7m0PiWCabGj7yS2OaIHe1FmdY3dpc=;
 b=Fwsc9/HE0fgHRUlDj2SEmmZRDI+EWzc/OPQqEYgID15u6OXYcwWJwwGhjnJbBLeiXhVPPV/47a7KYF+u55vM4GfROxvmW76XfSyKM7ujd1/UKho97kpQn/nM28ryn31heupS33uTady9WQXk6nGdO1anXS78ouiywDRUvtNUSXF74818VqLnIabfwXP6NyYZ8Ikt0ylQy10Vjf4WiLfiTCCDQiRJq3UcFsbyhTt5gdkES4rwSvU5pC4UTo41bQgtqkz2vJiCbYxMbRlOFvxcRblANQfPA7RrUP+3qLsE4m7Gi0eG+x1oxxG9lUmuQLXjKevQ1xyEkHl14Jy/jGYkcQ==
Received: from MN2PR11CA0018.namprd11.prod.outlook.com (2603:10b6:208:23b::23)
 by BY1PR12MB8445.namprd12.prod.outlook.com (2603:10b6:a03:523::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.24; Sun, 22 Sep
 2024 12:50:52 +0000
Received: from BL6PEPF00020E63.namprd04.prod.outlook.com
 (2603:10b6:208:23b:cafe::b8) by MN2PR11CA0018.outlook.office365.com
 (2603:10b6:208:23b::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.29 via Frontend
 Transport; Sun, 22 Sep 2024 12:50:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL6PEPF00020E63.mail.protection.outlook.com (10.167.249.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Sun, 22 Sep 2024 12:50:51 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 22 Sep
 2024 05:50:33 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Sun, 22 Sep 2024 05:50:32 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Sun, 22 Sep 2024 05:50:32 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>, <nouveau@lists.freedesktop.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <acurrid@nvidia.com>,
	<cjia@nvidia.com>, <smitra@nvidia.com>, <ankita@nvidia.com>,
	<aniketa@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC 20/29] vfio/vgpu_mgr: allocate GSP RM client for NVIDIA vGPU manager
Date: Sun, 22 Sep 2024 05:49:42 -0700
Message-ID: <20240922124951.1946072-21-zhiw@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E63:EE_|BY1PR12MB8445:EE_
X-MS-Office365-Filtering-Correlation-Id: ff35fbd3-cca5-4f16-a581-08dcdb0530dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Hw541q24QC7q0/OoUxcFai8D0goWfDFqeMJyGwBIU0CgzSl6gdO+hOkZqpGO?=
 =?us-ascii?Q?unoSONgfiCEDePsXQH3aA3n3n6cKS65Iy7KJREIs+it9GdIwL3UJQY8DAMKO?=
 =?us-ascii?Q?Ej5xkPb1Z3RCvgq9nQMl9Mqmfql5MAAZGeW72gCEIn1cmtbpSx1dWKg1HBqS?=
 =?us-ascii?Q?SS1ME5Ja8TKZbHVXm/Lxyh0QgL+m/5umkW/pCMQDI19Cht06b6B44wkmAwJc?=
 =?us-ascii?Q?Qv7IbvcT1SraRE4QAFPJUqm78s8d+rRxr54AaZke/gJ5Mjo9UMi7D3ANlwzq?=
 =?us-ascii?Q?HsV5+ULGrdCHNeA9D1zWaafpbdYVUwHuUoVigSA4gOtqQ58673HO9v026ikW?=
 =?us-ascii?Q?4TiOBFBHNWpblFT+cgN9jkHmxcnrJZsfk9yODtBbZL+thHInAU33G3asE5aF?=
 =?us-ascii?Q?ZxJupS3UdbFeOJUR9fRAmcDBDq5ipCt/QGXNAjHvZgnleE/rffCfZ+N8ZlKw?=
 =?us-ascii?Q?AJJmkizcXsjwrxGzRznBb0al6v+F+34UU07XiH0r1Djhtmv1HbQP6JcbvD3C?=
 =?us-ascii?Q?aiLIjJ39Ca2/YL8AdEOEpWzZ4hOihpHk6Uh5nOpob5bJQ+9nEoI0eFrqwzqB?=
 =?us-ascii?Q?Kidn19GLYBgEwzbfFFb3+t+yfVUBLN7QMLy8yKqfExUj6dLRZsMEXX62xA2p?=
 =?us-ascii?Q?Tabh3KTdRRkeCZTJv+1FecrNgJ0dTFsakVNTYW7+ev5ayfZSC1J/lrPVtM/d?=
 =?us-ascii?Q?lcFB7zPF5oHVdpN9pczwH4wtiZEiKGFIEbcrkw5pHinjizVXG/b7vNjPOObf?=
 =?us-ascii?Q?NFH/tR2yjLD7FF7dw10+6AAttN8NdkUZ+GpQe8Lg/uva31nJehrxX2OxFrKm?=
 =?us-ascii?Q?+2PLNWvFRizbRNT4E9uFDo9dnoxYGnRyD8/vT8ZtF2SQFE4oeW9ct47ZFkcQ?=
 =?us-ascii?Q?cF+mjs1cNgU98EHJNKIzNnestZ8q9PEw9Th5UuY714tTffgs+xZFfg+vOvSe?=
 =?us-ascii?Q?EnQfd+ikAhyDh1sAtuX+k/cDlSDNXKVHQ7iQx7vDY4XUaBgccjQBVKEpUM7g?=
 =?us-ascii?Q?fJZTNU1o7pJDtXZxIQ82ReFsm5BiXzE/gKPtWmCznVE/V+rH0XyHTND9B7dH?=
 =?us-ascii?Q?YogtHQpmRe1hPGF7wCR7iQMJX9El2MdT3HII8wFMTpQQC3icSC/Pb+1Sbthy?=
 =?us-ascii?Q?sLiK2i8bROxfPz1JaqKD1358ZA6tui+FUYD7SNFE8Q/QQPcq5XNhTYMRMN2D?=
 =?us-ascii?Q?rItlKZoAYfvFFTNoiFFuCXi4YPIG+WCmqyw43/sxK6sd8zDXhkqPQKJ4G663?=
 =?us-ascii?Q?1WSlxrwYEOTg3Dhm2Qu/jwpN/YNFnfMT9M7w4lbo0D+gq/vbBWlZPLd/Qzg+?=
 =?us-ascii?Q?n35zGkvaNs+E9xLy+Fibl7HOwTnpSLUA7HbR27XzPQrTgoaXFxDCv2m+01dC?=
 =?us-ascii?Q?yQKHQKx8R7YfrvCUf8v2Lj9N2BAuF09dMBgTrG5wF9l8uVpoLVAx3gpRw6nQ?=
 =?us-ascii?Q?WEsBbOxRPOQNz3MUM6bPEF2/v6rCZLT5?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2024 12:50:51.9044
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ff35fbd3-cca5-4f16-a581-08dcdb0530dd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E63.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR12MB8445

A GSP RM client is required when talking to the GSP firmware via GSP RM
controls.

In order to create vGPUs, NVIDIA vGPU manager requires a GSP RM client to
upload vGPU types to GSP.

Allocate a dedicated GSP RM client for NVIDIA vGPU manager.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 drivers/vfio/pci/nvidia-vgpu/nvkm.h     | 9 +++++++++
 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c | 8 ++++++++
 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h | 2 ++
 3 files changed, 19 insertions(+)

diff --git a/drivers/vfio/pci/nvidia-vgpu/nvkm.h b/drivers/vfio/pci/nvidia-vgpu/nvkm.h
index 4c75431ee1f6..939f3b420bb3 100644
--- a/drivers/vfio/pci/nvidia-vgpu/nvkm.h
+++ b/drivers/vfio/pci/nvidia-vgpu/nvkm.h
@@ -43,4 +43,13 @@ static inline int nvidia_vgpu_mgr_get_handle(struct pci_dev *pdev,
 #define nvidia_vgpu_mgr_detach_handle(h) \
 	(h)->ops->detach_handle((h)->pf_drvdata)
 
+#define nvidia_vgpu_mgr_alloc_gsp_client(m, c) \
+	m->handle.ops->alloc_gsp_client(m->handle.pf_drvdata, c)
+
+#define nvidia_vgpu_mgr_free_gsp_client(m, c) \
+	m->handle.ops->free_gsp_client(c)
+
+#define nvidia_vgpu_mgr_get_gsp_client_handle(m, c) \
+	m->handle.ops->get_gsp_client_handle(c)
+
 #endif
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c
index dc2a73f95650..812b7be00bee 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c
@@ -12,6 +12,7 @@ static void vgpu_mgr_release(struct kref *kref)
 	struct nvidia_vgpu_mgr *vgpu_mgr =
 		container_of(kref, struct nvidia_vgpu_mgr, refcount);
 
+	nvidia_vgpu_mgr_free_gsp_client(vgpu_mgr, &vgpu_mgr->gsp_client);
 	nvidia_vgpu_mgr_detach_handle(&vgpu_mgr->handle);
 	kvfree(vgpu_mgr);
 }
@@ -82,9 +83,16 @@ struct nvidia_vgpu_mgr *nvidia_vgpu_mgr_get(struct pci_dev *dev)
 	kref_init(&vgpu_mgr->refcount);
 	mutex_init(&vgpu_mgr->vgpu_id_lock);
 
+	ret = nvidia_vgpu_mgr_alloc_gsp_client(vgpu_mgr,
+					       &vgpu_mgr->gsp_client);
+	if (ret)
+		goto fail_alloc_gsp_client;
+
 	mutex_unlock(&vgpu_mgr_attach_lock);
 	return vgpu_mgr;
 
+fail_alloc_gsp_client:
+	nvidia_vgpu_mgr_detach_handle(&vgpu_mgr->handle);
 fail_attach_handle:
 	kvfree(vgpu_mgr);
 fail_alloc_vgpu_mgr:
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
index 2efd96644098..f4416e6ed8f9 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
@@ -32,6 +32,8 @@ struct nvidia_vgpu_mgr {
 	struct mutex vgpu_id_lock;
 	struct nvidia_vgpu *vgpus[NVIDIA_MAX_VGPUS];
 	atomic_t num_vgpus;
+
+	struct nvidia_vgpu_gsp_client gsp_client;
 };
 
 struct nvidia_vgpu_mgr *nvidia_vgpu_mgr_get(struct pci_dev *dev);
-- 
2.34.1


