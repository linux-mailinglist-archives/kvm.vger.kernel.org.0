Return-Path: <kvm+bounces-27270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F98997E1B8
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 14:53:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2108BB20F6A
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 12:53:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44F29524C;
	Sun, 22 Sep 2024 12:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Jw399xWt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2048.outbound.protection.outlook.com [40.107.244.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94444A07
	for <kvm@vger.kernel.org>; Sun, 22 Sep 2024 12:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727009459; cv=fail; b=UzLsDYmivvP9NR8Mk0LuxYtA3IBh40XCIBg7p7FhkpQxDbhxZv29fqvJ0aJc8xLoQWeuA4xoWx5b3GfJvQQJTLCX4AevKPKEavqjaXnSHZ8NWIMdnlmXP4dGgoTGA/VZPVxdTixKrulAs/D9rsI7L6nrGAZBQzenZK4kydtGTV4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727009459; c=relaxed/simple;
	bh=77oTDYRhoAy9U4DjYei5+MOsWNcRBKHlByO/DbkoXIg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l8rRxqo42hibFcrhDRlBmFH5B5e0liEFu7wHd0gWYZdHzCaeu5vd6ArFH2qOo9yi6caEJp+g5HOs4ZkUV0O0rSITaxe2p4VG76+mMrfSblYpudPQK+0bcEbMRJNV8Pv9qMley4KMKrRRl4aZFto4p4qVf25Q1gWRSyIsF/nciuM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Jw399xWt; arc=fail smtp.client-ip=40.107.244.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fvt6IdhQjtekmKUtGBGc3Hv2bSWTw0XCC2TRcPS0jAWHqjeJ+B8vjioH3PAMX0Koc/K2GL8eXXm9dIJtQ9Fiut9mylReqS8NDEkTk2Nt6vNZRY7+xwQ1rdnzXSMhRVAJowEew4fWb6gjg530Kfk4gSojHSVcWpxVtjKI8ceO7clDM5ozIAzwoA47UiV377KvpqHpaJKMyijZFaOxL8SoiAsZDaavK18ktbaOYVLSsghjevYpmmRj37eyjwJOa8fCQ0E48wb4VheSJ5M+mhnpQv1i8vlVOlghun3ga1cfum8rdehRVzbnMnSVEpJw3+8nixOX2LtHbFiNpYVEduBwjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PSPcodUi+g62DqoRwDS0XVeRMjRuWBo0CZPEqrjeZS0=;
 b=hcfVc/NSqIvls+JsYhLqw5Vb+XP1CGq51GIJSUjXr8uG46HZF4brIQdWXARDFVigMTX802wBvSH4K6hEQvuyO297Ni64gnHvUh3s43dVYfJ77kDXnmdeAVJVttCE1oF8XphK6Qm38cmHVcYM5pmIiAYn1q38ofFrUSYa8xC+W1ZAto0X5fp2HfnuVAma2AQJvbhZyP8YfEhGILKnR2Q37NVh6EaCKlFfkfYvQOJmB+0BE3/M7rRAU6qR0hhlTicHIaZjwElWHuy7NtZx/9KXkmwI7kD1E2Cf28ySzQP4HCoXM/STKC4hcbzvyCULS16ekXzIUq2ZAtW85k+OwuGzMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PSPcodUi+g62DqoRwDS0XVeRMjRuWBo0CZPEqrjeZS0=;
 b=Jw399xWtPyFTPh9cSSMoUmiRXzVcETRXeeMnnJ8Kb7Wsq0/mr59g2+guFttwxoJZBUCZFMda8V9cx1W9332HSXvo9hGAyrFExli72E/6LjaqZxkWmzGl+UzemnkXv9mpvZT/F/MpqefpdnJOCs5PCR8Ni9jgiqADu28OPNfxd9OSc6KC4zEj6j0z1dUSQqpemrxWv290iLa6J2yqIcA20nk3o004nbZZRGR2CnCKbUGacjA+OPdl/x1tk6EyDbZwYGbrjRYSz1Q/0Un5wEr59JzkcNalPGOaZpZnSu0GXz1poTPS5e/KldZlrsa+5W0ksQzhlNRyfy0tBMlKxUA+Nw==
Received: from BN8PR04CA0051.namprd04.prod.outlook.com (2603:10b6:408:d4::25)
 by IA1PR12MB6257.namprd12.prod.outlook.com (2603:10b6:208:3e7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.24; Sun, 22 Sep
 2024 12:50:49 +0000
Received: from BL6PEPF00020E5F.namprd04.prod.outlook.com
 (2603:10b6:408:d4:cafe::25) by BN8PR04CA0051.outlook.office365.com
 (2603:10b6:408:d4::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.23 via Frontend
 Transport; Sun, 22 Sep 2024 12:50:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL6PEPF00020E5F.mail.protection.outlook.com (10.167.249.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Sun, 22 Sep 2024 12:50:49 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 22 Sep
 2024 05:50:31 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Sun, 22 Sep 2024 05:50:31 -0700
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
Subject: [RFC 18/29] nvkm/vgpu: introduce pci_driver.sriov_configure() in nvkm
Date: Sun, 22 Sep 2024 05:49:40 -0700
Message-ID: <20240922124951.1946072-19-zhiw@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E5F:EE_|IA1PR12MB6257:EE_
X-MS-Office365-Filtering-Correlation-Id: ceaad478-48e2-4446-e525-08dcdb052f67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1pOCnV5vQNf2++SlGwS9z1Vrf1VTKVdo6f5DzXx5tBXKYTT7MBA1Xu6nF0S5?=
 =?us-ascii?Q?DAUQUO6tZP3/im7iDNmW93DYF28qHIsfhMo81yg90gZ7fFIT28Aq03Xogj29?=
 =?us-ascii?Q?wiTJsu+dLYkEp7k1ittXda3Tfi0LCuYHPMgjE5P8Zz/nXaCQ/1fmQJQdvKSg?=
 =?us-ascii?Q?IA5Zn6vQGfckZGqUgoVyReqTo5l7UWKs8aG7OMCB1yBOWv8FB5V0M2bJ2QU1?=
 =?us-ascii?Q?SHn01IKhkZJpsY5e70Bil8ZB//5e2hSRVtc8+PQ43DbdbBvNgV05wIzP+vGW?=
 =?us-ascii?Q?8jM3NTQ1t5Ci4j9xhiL4dkcT/PGFX0eBhbKWL1fo2LUZaLfuBvXJRBFRZbRM?=
 =?us-ascii?Q?pHFwErpqV1fz+rZ6MTJSpnaj6gi6La3PRU1Pi8uqjBUGgIpaTa8no9KjmLbk?=
 =?us-ascii?Q?whyuOXDDu1VgYJyhHBDVyXuBdaAnilLLjiuPvpMLsGlOm5/h+0rm5vV/jNNS?=
 =?us-ascii?Q?Gw2nlutSmCl9y91zzQJ9SrtDBpiKZtw4CwQXMq6iEcfoHjmArVUzpQqGJNiO?=
 =?us-ascii?Q?SRMQj3/vl2RkiVukMKe2fe6P89/wckZfB+2cPiezwb+ETrPk+XceSLenwN1S?=
 =?us-ascii?Q?7TDN/DuKpATxWF3ffCubFD1Py3kPTtLKUZ9knTZZJWVL1G20gdvnTbe7mw6G?=
 =?us-ascii?Q?HEp1bUwHvzg3ZnN4gSIgVjlElIpVUMsFS4M3zeFVVX4lQG5pZL4er8ldWWXA?=
 =?us-ascii?Q?hHvlysjGhzKxBCdwB9Ti7X1B2/WWZtBYU9ZWC3rjCmHXQWno/U+DJflNaMLb?=
 =?us-ascii?Q?nk8sxIw5AJO8rkezSiMSVq2DaehVx7KLEfT5acjjK2jTVw+QmAsWebNf4Up+?=
 =?us-ascii?Q?qKOjBPRQfO0dBv46ePGippjvmauX1T6GwrvZ1b18TN/coM/TXzDvx2T1pUzB?=
 =?us-ascii?Q?uaRVxUds/lLRFNgahIK9E1L9Y/ECTrW276m7/2aer9pQvWWeHBttf4iBKILS?=
 =?us-ascii?Q?sRa3BcFS5jVT0dlR+egjss+0+5nHWLCs4Drp65Mdux+I4rL7+nFlggW+yXK/?=
 =?us-ascii?Q?XMKEi6Dj/i2P09SbqOOs5ryT8YdpLjbahKyXa8/xKSYkwThMntupWu5xxRAo?=
 =?us-ascii?Q?R6chfXIpbDqFSfg0j1nIMZvX53cnIV6M7Kf5NJy8t8RNaWAx/KK2Vk/T3bmr?=
 =?us-ascii?Q?ZkN10TGOuUxUIN55FOTWMZB3tOvBLhxgJUwPmQX1ZPxZoIWh2Bzp9BmFNFzJ?=
 =?us-ascii?Q?jy5w0vHmhwN38AS9lbfbe3JmvkHutonrG+1yOHdvAhyeR9pRAti/w8kdq5sV?=
 =?us-ascii?Q?pyljaLaDndeKDuxE4J8Bm+IM+LN/VEkaR1AdgJis+jif18MePCKAR2TP67S8?=
 =?us-ascii?Q?sfOpeKT3lRiCmmYjRGGCdU1+9xdUIMoHeWEsm1LYJlh4zE9TiK4bvNK0z0wu?=
 =?us-ascii?Q?5ULPSC8=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2024 12:50:49.4550
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ceaad478-48e2-4446-e525-08dcdb052f67
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E5F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6257

The kernel PCI core provides a sysfs UAPI for the user to specify
number of VFs to be enabled.

To support the UAPI, the driver is required to implement
pci_driver.sriov_configure(). The num of VFs are only able to be
changed where there is no active vGPUs.

Implement the pci_driver.sriov_configure() in nvkm. Introduce a
blocking call chain to let NVIDIA vGPU manager handle this event.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 .../nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h  |  1 +
 drivers/gpu/drm/nouveau/nvkm/device/pci.c     | 14 +++++++++++
 .../gpu/drm/nouveau/nvkm/vgpu_mgr/vgpu_mgr.c  | 25 +++++++++++++++++++
 include/drm/nvkm_vgpu_mgr_vfio.h              |  5 ++++
 4 files changed, 45 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h b/drivers/gpu/drm/nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h
index 882965fd25ce..388758fa7ce8 100644
--- a/drivers/gpu/drm/nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h
+++ b/drivers/gpu/drm/nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h
@@ -40,5 +40,6 @@ void nvkm_vgpu_mgr_fini(struct nvkm_device *device);
 void nvkm_vgpu_mgr_populate_gsp_vf_info(struct nvkm_device *device,
 					void *info);
 void nvkm_vgpu_mgr_init_vfio_ops(struct nvkm_vgpu_mgr *vgpu_mgr);
+int nvkm_vgpu_mgr_pci_sriov_configure(struct nvkm_device *device, int num_vfs);
 
 #endif
diff --git a/drivers/gpu/drm/nouveau/nvkm/device/pci.c b/drivers/gpu/drm/nouveau/nvkm/device/pci.c
index 1543902b20e9..f39d2727d653 100644
--- a/drivers/gpu/drm/nouveau/nvkm/device/pci.c
+++ b/drivers/gpu/drm/nouveau/nvkm/device/pci.c
@@ -1766,6 +1766,9 @@ nvkm_device_pci_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 	struct nvkm_device *device;
 	int ret, bits;
 
+	if (pci_dev->is_virtfn)
+		return -EINVAL;
+
 	if (vga_switcheroo_client_probe_defer(pci_dev))
 		return -EPROBE_DEFER;
 
@@ -1867,6 +1870,16 @@ nvkm_device_pci_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 	return ret;
 }
 
+static int nvkm_device_pci_sriov_configure(struct pci_dev *dev, int num_vfs)
+{
+	struct nvkm_device *device = pci_get_drvdata(dev);
+
+	if (!nvkm_vgpu_mgr_is_enabled(device))
+		return -ENODEV;
+
+	return nvkm_vgpu_mgr_pci_sriov_configure(device, num_vfs);
+}
+
 static struct pci_device_id
 nvkm_device_pci_id_table[] = {
 	{
@@ -1889,6 +1902,7 @@ nvkm_device_pci_driver = {
 	.probe = nvkm_device_pci_probe,
 	.remove = nvkm_device_pci_remove,
 	.driver.pm = &nvkm_device_pci_pm,
+	.sriov_configure = nvkm_device_pci_sriov_configure,
 };
 
 MODULE_DEVICE_TABLE(pci, nvkm_device_pci_id_table);
diff --git a/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vgpu_mgr.c b/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vgpu_mgr.c
index 3654bd43b68a..47c459f93950 100644
--- a/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vgpu_mgr.c
+++ b/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vgpu_mgr.c
@@ -207,3 +207,28 @@ void nvkm_vgpu_mgr_populate_gsp_vf_info(struct nvkm_device *device,
 	v = nvkm_rd32(device, 0x88000 + 0xbfc);
 	vf_info->b64bitBar2 = IS_BAR_64(v);
 }
+
+/**
+ * nvkm_vgpu_mgr_pci_sriov_configure - Configure SRIOV VFs
+ * @device: the nvkm_device pointer
+ * @num_vfs: Number of VFs
+ *
+ * Returns: 0 on success, negative on failure.
+ */
+int nvkm_vgpu_mgr_pci_sriov_configure(struct nvkm_device *device, int num_vfs)
+{
+	struct nvkm_vgpu_mgr *vgpu_mgr = &device->vgpu_mgr;
+	struct nvidia_vgpu_vfio_handle_data *vfio = &vgpu_mgr->vfio_handle_data;
+	struct pci_dev *pdev = nvkm_to_pdev(device);
+	int ret;
+
+	if (vfio->priv)
+		return -EBUSY;
+
+	if (num_vfs)
+		ret = pci_enable_sriov(pdev, num_vfs);
+	else
+		pci_disable_sriov(pdev);
+
+	return ret ? ret : num_vfs;
+}
diff --git a/include/drm/nvkm_vgpu_mgr_vfio.h b/include/drm/nvkm_vgpu_mgr_vfio.h
index d9ed2cd202ff..5c2c650c2df9 100644
--- a/include/drm/nvkm_vgpu_mgr_vfio.h
+++ b/include/drm/nvkm_vgpu_mgr_vfio.h
@@ -6,8 +6,13 @@
 #ifndef __NVKM_VGPU_MGR_VFIO_H__
 #define __NVKM_VGPU_MGR_VFIO_H__
 
+enum {
+	NVIDIA_VGPU_EVENT_PCI_SRIOV_CONFIGURE = 0,
+};
+
 struct nvidia_vgpu_vfio_handle_data {
 	void *priv;
+	struct notifier_block notifier;
 };
 
 /* A combo of handles of RmClient and RmDevice */
-- 
2.34.1


