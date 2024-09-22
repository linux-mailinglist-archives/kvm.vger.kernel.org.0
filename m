Return-Path: <kvm+bounces-27247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A80B797E1A1
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 14:50:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 336F61F21307
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 12:50:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0E664A21;
	Sun, 22 Sep 2024 12:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KM4xXN97"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2071.outbound.protection.outlook.com [40.107.223.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4466B28FF
	for <kvm@vger.kernel.org>; Sun, 22 Sep 2024 12:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727009437; cv=fail; b=WSXCAhjE7WeAscYSiu40x3zvH+huBpRYrTHRRDInTy1IrktHElxI9hVQm/iap8P81c3yaUrSfFgruWj3X7v7SZTKfpk5FdlSGwEwHpzCU/kKbnlk6022nDk/RFYRKxRL485cv1Y2hccZrYYMTj20hFWV5Sf9oh+HicAUhdkZsxk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727009437; c=relaxed/simple;
	bh=H2k5GFO7e4iPzatK17kbyHShCdsLpjuoKiV321Xv/64=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZjC7GcKkZifsFWt3QezVA3uTZ9q/70p2m5ZrRGDhBri21rcteC4NBsRcjPX3ulHpziF1icXXrGDpdaWugdgSJwOZqbjgA7F3AaXVYMXACNHi/2266WftSJKXfPPP7NfJSYngC1oaSfd7SICxtDOgkCFwin5bBsWQDrOBfG35PGg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KM4xXN97; arc=fail smtp.client-ip=40.107.223.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lpmKufB0CQOnTrjz0hs/IvlOFOYOhbxTQUL/niP1k50m//LjWoR+fHOS6hKYEZoM8/gk2ACwu4KQGnZW2xR7EFmG+prVlv56xhLYHJQAXGvPNC+zz+KdJsYCJvpQCR3K4POLlM33OqQpaDBlEh586bcNboQd6JtI9mpT6nal0Gs5Gbu4duJWrXebQ1S8gaIYOoUzpCb9oblL45xgKls3BahS+Tjui1Xsu+3+JKNExM2ycyfSbLa25ULRvFcPugK7VEsko8RyHXZabN2sI8hnYkMM5teMk6GuAK4ukRpt0swGzxb2GQKza8ll85eJhP4CxjK8nvr15z9n6WYHuKzI7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JhYlEorIr6rz6xDIW90zTcFP3NMnHIUCs/fKt3Piago=;
 b=iKrFe/VI116bzdwfaWCTHMU1fvaH2GRqBMqXmUTxUc8SwGu4ApwpoblfmcMdFy+Z2GQnutvcfQhahvKMkRAwTed3GYbtZndRJXNPgO+SmYlSxXVdrcVl8roX23dLIIP1XnUairkA9IUlNzD097RAUscmlK0MTC5joYZIhCArhQa+mmPuY3L9NOcpKeEeI0QJmi3XvMnVdWKahesUbJXlRracFOZEe8CYpV6s+zeHTe224DcKVzqkinIQDtbtNTjH+0lnmEmDecbtP2xTfLYe36sR7Mf2nF1dzLLWVY/V7g9bPhGk8udSK4dWOjkyjxPNoasdsZZzAHkA/17OXxQubQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JhYlEorIr6rz6xDIW90zTcFP3NMnHIUCs/fKt3Piago=;
 b=KM4xXN97SaPJKFUJg6n/FLyL4pcDoTGT3tiZjLffK4NCkj7KBsd5J/0IQ/xDSOZBy7H7gbE3ZKFkwM+Md6HIU0/0Jw69pwT2PS9W1nNrOI78bppHfiEW9BMGlhZfkyUibxsvJMzjWt8V6PTSpqGfsoVoywnmWoZ0dBC3sNcq3ggoE29/z8Jwfg+danRtRv7ydOCLr4m91vV30O7/9z6crPptNCzB7IVooAXID7J1F+rLjH5ejbF5bVYewld52IxMPr7P0pKBb5j4I8iJs6gA+2uzilGiHSVHo1ZNY3gpfEtZUgjGQ8Sf+csRJ6RpnyptLc8YjrT+kmTEy0gL37ufZw==
Received: from BN9PR03CA0282.namprd03.prod.outlook.com (2603:10b6:408:f5::17)
 by DM4PR12MB8452.namprd12.prod.outlook.com (2603:10b6:8:184::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.24; Sun, 22 Sep
 2024 12:50:30 +0000
Received: from BL6PEPF00020E66.namprd04.prod.outlook.com
 (2603:10b6:408:f5:cafe::c3) by BN9PR03CA0282.outlook.office365.com
 (2603:10b6:408:f5::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.30 via Frontend
 Transport; Sun, 22 Sep 2024 12:50:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL6PEPF00020E66.mail.protection.outlook.com (10.167.249.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Sun, 22 Sep 2024 12:50:29 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 22 Sep
 2024 05:50:20 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Sun, 22 Sep 2024 05:50:20 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Sun, 22 Sep 2024 05:50:19 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>, <nouveau@lists.freedesktop.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <acurrid@nvidia.com>,
	<cjia@nvidia.com>, <smitra@nvidia.com>, <ankita@nvidia.com>,
	<aniketa@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC 02/29] nvkm/vgpu: attach to nvkm as a nvkm client
Date: Sun, 22 Sep 2024 05:49:24 -0700
Message-ID: <20240922124951.1946072-3-zhiw@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E66:EE_|DM4PR12MB8452:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ad602e5-8376-4bd2-a7e3-08dcdb0523be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SGuQKOkJWk0IR9E3xg2q7oiN3LF8iuk0fk6AesU2nZxXKzLlz86cdFH9Uy+1?=
 =?us-ascii?Q?XlP3ohXtyCyTXq9DOvoWL/qdYAw53k+UvQazvO+pyhE7uBowTSDpDNdcQP6c?=
 =?us-ascii?Q?fk7LveoEab1syX8v8SZNSLTtTbZkycZ+RtZe3UJEHJWUoaLtXk4pVPkahYp8?=
 =?us-ascii?Q?Py64olorlkNEJwfLbLZNsdwLY0rN17/B/o6rc2aMnCMmJ+IdMLSt6+j6fMWw?=
 =?us-ascii?Q?fx6kSSDeOIaLMvXpJe3+A0HuCgofiuhWJ0SAeRbLoimhWxCdu454JZAlJD97?=
 =?us-ascii?Q?hJb9VJY35tiFHB6OjfkuRnf0kpXcXKljTzS519ANqPMAXUY6vpCHTh1C7wGJ?=
 =?us-ascii?Q?Pl01PoenInboxAoSYo2RrjeBgCAWQYJFAdKiIE1qDJP3G/T4Ah/bifJXg7VY?=
 =?us-ascii?Q?jSGZ3sF0vBX6Fl0Ig8c7ujCx5wfXdzg4BvmTNtjN610gq9oCyjkp9xpjcq1O?=
 =?us-ascii?Q?xbw4Q4cQ1cIjyGUn+0TzDfmapE1WovRttn56JQE8rHtNoMrwaX1S6zTmW3+R?=
 =?us-ascii?Q?fHpHwzQjU2NZhJ22UM+/emztBnftyaUfLINzGuD7XsYE4lwZDcAJA4zENea5?=
 =?us-ascii?Q?KuTA/bjxCFXOec70IZzxq9XgryX1l4JvMV/Kb2kcvvOZPvvi6eHPCpU+len5?=
 =?us-ascii?Q?K9k7hpcKcXvhTJTS1V3PUO+KRdB0xj51OyhuSSZQmAOw5OeO2Qxg/Ena2/F2?=
 =?us-ascii?Q?RLrRzm0KKI4B3P4mmX0zb0sshOsrDONLq/Vz7NsqCydDeMh90VGukmSEB2IO?=
 =?us-ascii?Q?uVFsULWa8COMqETjknvv4Jh77SVPTYr6uxrOIsKCzKhpDzYwholCst79os10?=
 =?us-ascii?Q?5uY6BiMidhAhTLp/tjzqY1NmpWcg2itjA4Wxt8PrmJKgbL+h26SIx98yl3T2?=
 =?us-ascii?Q?OT8yIVEDD/Vm4Li+0OjGNdjUmrBHW0sGjrtAeTXSWBf2s7Pc6X1MWpc/cdzo?=
 =?us-ascii?Q?ss/918noNYiS6Fq0+pcf0g1RMprDhIWS0FXf2BPuFV0JmISwEJEiv71+BO5G?=
 =?us-ascii?Q?z451aTgovVEvkxJuuXUEuOntp5uJ2Gh9eEpxNr5qKGG4ZsemLHyGfaCFv0ZO?=
 =?us-ascii?Q?lGFCGzuMOghkEx+llgH07HcHEZLp1r5bFYOl2Q54Fj145k7mC+iH7nlkv4dC?=
 =?us-ascii?Q?l2HXLNaqIil3DPJKIDe7Ux+og//MDzpavdvDlnrnz4nUoUHScxKUXreGdVWy?=
 =?us-ascii?Q?h732nVw7wK9cBE8cFSyG+RE/9OPHvSzyMjYaKNe5yVzARJ2tV0fC3lY+f8zL?=
 =?us-ascii?Q?mLGF8CI+Dm9DCgcxZ+hAhKFtPxrbr6g1mJYyBJjgeYk9L7PxrVXJ4//QJyhV?=
 =?us-ascii?Q?9BrvSvrUHJUqOfDWK48zGDi7dFjcM917pUOBqUJ8OU02v5D51aVwXPjnJalT?=
 =?us-ascii?Q?gjo4LTA=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2024 12:50:29.8753
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ad602e5-8376-4bd2-a7e3-08dcdb0523be
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E66.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8452

nvkm is a HW abstraction layer(HAL) that initializes the HW and
allows its clients to manipulate the GPU functions regardless of the
generations of GPU HW. On the top layer, it provides generic APIs for a
client to connect to NVKM, enumerate the GPU functions, and manipulate
the GPU HW.

To reach nvkm, the client needs to connect to NVKM layer by layer: driver
layer, client layer, and eventually, the device layer, which provides all
the access routines to GPU functions. After a client attaches to NVKM,
it initializes the HW and is able to serve the clients.

Attach to nvkm as a nvkm client.

Cc: Neo Jia <cjia@nvidia.com>
Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 .../nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h  |  8 ++++
 .../gpu/drm/nouveau/nvkm/vgpu_mgr/vgpu_mgr.c  | 48 ++++++++++++++++++-
 2 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h b/drivers/gpu/drm/nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h
index 3163fff1085b..9e10e18306b0 100644
--- a/drivers/gpu/drm/nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h
+++ b/drivers/gpu/drm/nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h
@@ -7,6 +7,14 @@
 struct nvkm_vgpu_mgr {
 	bool enabled;
 	struct nvkm_device *nvkm_dev;
+
+	const struct nvif_driver *driver;
+
+	const struct nvif_client_impl *cli_impl;
+	struct nvif_client_priv *cli_priv;
+
+	const struct nvif_device_impl *dev_impl;
+	struct nvif_device_priv *dev_priv;
 };
 
 bool nvkm_vgpu_mgr_is_supported(struct nvkm_device *device);
diff --git a/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vgpu_mgr.c b/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vgpu_mgr.c
index a506414e5ba2..0639596f8a96 100644
--- a/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vgpu_mgr.c
+++ b/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vgpu_mgr.c
@@ -1,5 +1,7 @@
 /* SPDX-License-Identifier: MIT */
 #include <core/device.h>
+#include <core/driver.h>
+#include <nvif/driverif.h>
 #include <core/pci.h>
 #include <vgpu_mgr/vgpu_mgr.h>
 
@@ -42,6 +44,44 @@ bool nvkm_vgpu_mgr_is_enabled(struct nvkm_device *device)
 	return device->vgpu_mgr.enabled;
 }
 
+static void detach_nvkm(struct nvkm_vgpu_mgr *vgpu_mgr)
+{
+	if (vgpu_mgr->dev_impl) {
+		vgpu_mgr->dev_impl->del(vgpu_mgr->dev_priv);
+		vgpu_mgr->dev_impl = NULL;
+	}
+
+	if (vgpu_mgr->cli_impl) {
+		vgpu_mgr->cli_impl->del(vgpu_mgr->cli_priv);
+		vgpu_mgr->cli_impl = NULL;
+	}
+}
+
+static int attach_nvkm(struct nvkm_vgpu_mgr *vgpu_mgr)
+{
+	struct nvkm_device *device = vgpu_mgr->nvkm_dev;
+	int ret;
+
+	ret = nvkm_driver_ctor(device, &vgpu_mgr->driver,
+			       &vgpu_mgr->cli_impl, &vgpu_mgr->cli_priv);
+	if (ret)
+		return ret;
+
+	ret = vgpu_mgr->cli_impl->device.new(vgpu_mgr->cli_priv,
+					     &vgpu_mgr->dev_impl,
+					     &vgpu_mgr->dev_priv);
+	if (ret)
+		goto fail_device_new;
+
+	return 0;
+
+fail_device_new:
+	vgpu_mgr->cli_impl->del(vgpu_mgr->cli_priv);
+	vgpu_mgr->cli_impl = NULL;
+
+	return ret;
+}
+
 /**
  * nvkm_vgpu_mgr_init - Initialize the vGPU manager support
  * @device: the nvkm_device pointer
@@ -51,13 +91,18 @@ bool nvkm_vgpu_mgr_is_enabled(struct nvkm_device *device)
 int nvkm_vgpu_mgr_init(struct nvkm_device *device)
 {
 	struct nvkm_vgpu_mgr *vgpu_mgr = &device->vgpu_mgr;
+	int ret;
 
 	if (!nvkm_vgpu_mgr_is_supported(device))
 		return -ENODEV;
 
 	vgpu_mgr->nvkm_dev = device;
-	vgpu_mgr->enabled = true;
 
+	ret = attach_nvkm(vgpu_mgr);
+	if (ret)
+		return ret;
+
+	vgpu_mgr->enabled = true;
 	pci_info(nvkm_to_pdev(device),
 		 "NVIDIA vGPU mananger support is enabled.\n");
 
@@ -72,5 +117,6 @@ void nvkm_vgpu_mgr_fini(struct nvkm_device *device)
 {
 	struct nvkm_vgpu_mgr *vgpu_mgr = &device->vgpu_mgr;
 
+	detach_nvkm(vgpu_mgr);
 	vgpu_mgr->enabled = false;
 }
-- 
2.34.1


