Return-Path: <kvm+bounces-27257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C35C197E1AB
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 14:51:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 449E41F2131D
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 12:51:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0834726AF6;
	Sun, 22 Sep 2024 12:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="urLSNysR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2077.outbound.protection.outlook.com [40.107.243.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863421803A
	for <kvm@vger.kernel.org>; Sun, 22 Sep 2024 12:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727009446; cv=fail; b=mmyK7FzEje1OrBPI8HRF1APP7w2vLNb+K8XVEfMbCpzi/mkRb4sat/2zEOMbB5ZNQFLdW55Ga9DbOll138wZ5EZQAUNzx7l5bFirsJqYf98fU0Mo80wvO5c64yFJkVyKEUxPsrDnaKN6t+ZVZoWBhtZEeIWMdXHVdnh2ppuLyig=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727009446; c=relaxed/simple;
	bh=j6wElKvtIHrhSp3eMA7dRaUbfxRhsAbJBjJI6kyF5nk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S1CiPywuz0xg8PhxgQ4It2xUuXdpRPlaU73o+rAex/1WX28f71PYDATg3Sn8aI7MCigy3ACECsuZgRIdQWTOULYcAGIGr7M1g3luF8L918sBupKBP5pBft5apXh1iGxa1uM0e8zgQyCAebNh/UQEXWUh6Ne4xcbkFrpUAKF7SJk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=urLSNysR; arc=fail smtp.client-ip=40.107.243.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uZ26g37LWJ4P5OnHErB/HYtf8eT+qczoSzwfcG6ynXotbEaOGjLGN1eqsvhiQqb5wfNNmWcYCcJi7S8JkxEseD9RRrcmFfJRIFhzUo2uWCoQ8F18W7BAx7yjttlTU8NEEoRPe+4VHONVEAF69/wuBHqBxMaI1Xwts81yw4qttTK7DnEvFw1TbaUq8+o7h2DUlsIUYar2faOgbfbHYz4QGmPTu9YIbeVhHg9c4IylRjI7IYcuaxTVVZphcDV+MmrE7eLpbFD26aT9MKIer3ad7wNMLVklUmdtQBpzsbGO1EmugDdVxEaBFMM7LkFw8ulDDBrkll3MIOSpzqokP3Q4dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RHIf73+KXgRjudQBx+lRNzy1c61VRJCJpBw6rge7CKI=;
 b=yct0yyqxcLdq8Nr8D5Dhr55coEV9Ij4lGdwlDBDQYI21caKXVJoJmNBUkCW2ZUyjElNS+GtZygWIGoHCjHpsNFbwHUWB4a5BJ1t6eRQeJkoxWhDrcu2ctEek6NlaUSZGegHCYvDvS8Su71bTNYZPA/57ol+mk90kiTv6MSuxdjhi9AwBrNeSZe8Sc4MjoDYcJNTAbguoqKiqhni482a7+9koPN6qrwPKe5D5prp++vFIfaABgkuMUVNhRPrAn2WR1gn1hSLpOgb+pwTqhnGEixzRRKGaWGN/MIOgTzFGCqwgqzYDmH8VpHwBecneJ5f6MknMPYWLLwarKEoIKOFAqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RHIf73+KXgRjudQBx+lRNzy1c61VRJCJpBw6rge7CKI=;
 b=urLSNysRQ1XsJzQy33eJ/eFwH8T2hR7nFJTJx+UMwLwFF6pxMGK/ulvpzj+YbG3bulBRLiIYDAOPv55h71t1qkEzdR1nmS1O91t78Eh0sFmQPyC4SB1J7RdelNs/cV5o4ANbG9/IvPAbzrYn4VIFp5UDx+tG7dRgm9FpCCPJUFWaqw+YnRTunvyquO47ClvuF6MbD3qMnhjemZJB2f54ztdihRAzKXg0W0gK+OXbB+fhukb2ukt5jilTC7kwiKJaZeBIIPHTuykqfh2TTu8l0FjgG79fQXodi/V0dbNO0gXyf9E3OI5Xu0p1zZnUx5chUhsxIV6gS/5t/hjMBu8AIA==
Received: from BN0PR04CA0130.namprd04.prod.outlook.com (2603:10b6:408:ed::15)
 by MN0PR12MB6320.namprd12.prod.outlook.com (2603:10b6:208:3d3::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.24; Sun, 22 Sep
 2024 12:50:38 +0000
Received: from BL6PEPF00020E62.namprd04.prod.outlook.com
 (2603:10b6:408:ed:cafe::a2) by BN0PR04CA0130.outlook.office365.com
 (2603:10b6:408:ed::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.30 via Frontend
 Transport; Sun, 22 Sep 2024 12:50:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL6PEPF00020E62.mail.protection.outlook.com (10.167.249.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Sun, 22 Sep 2024 12:50:38 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 22 Sep
 2024 05:50:26 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Sun, 22 Sep 2024 05:50:26 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Sun, 22 Sep 2024 05:50:25 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>, <nouveau@lists.freedesktop.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <acurrid@nvidia.com>,
	<cjia@nvidia.com>, <smitra@nvidia.com>, <ankita@nvidia.com>,
	<aniketa@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC 10/29] nvkm/vgpu: introduce interfaces for NVIDIA vGPU VFIO module
Date: Sun, 22 Sep 2024 05:49:32 -0700
Message-ID: <20240922124951.1946072-11-zhiw@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E62:EE_|MN0PR12MB6320:EE_
X-MS-Office365-Filtering-Correlation-Id: ab166165-3f6e-4c6a-da17-08dcdb0528b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eW5WZ0x4WStySk1kNjlqYzBsaWJrRFkwbG1SOVNVL0h1Qjd6YmlLUHpueWJH?=
 =?utf-8?B?bUlNS3YvUmNKU0RrQitLZDdxWWtFZEFHblBrc3VyYmNFR1RqL1JEYjQ2blBm?=
 =?utf-8?B?M0hlUVNLR2VOV0RsMExydmhNUk5oQmQ5WVAreXREZWV2Rm8wZzlmQ3lVd3k3?=
 =?utf-8?B?eDlCa1B3NTFYUHFycm1iZldDS0UzeHg4M2JFM1ByejYrYWJCUmUxQTU0ZEZk?=
 =?utf-8?B?elZ0OTkxYUt6blhFMCtzU1YzaFI0ekh5b1JEZ2l5SFlhOHNNbStrT2FETkZQ?=
 =?utf-8?B?RkFaSTBqVjBXTEpGaXJ4RStHekp6M0FVWGZ6SDJwWHBzVk1ORU5oZUlCcVZm?=
 =?utf-8?B?aENhSkFNNHMyNkRUMW9va3JwdGNHSzN1QlhUZENBZmNuWCt1RWpia0dYajVu?=
 =?utf-8?B?RzRROVA4SlI3U0I5TFJEOE11V2lPWWZMNTNKY0FKYXZ2VjNZV0phUFFKY0ZL?=
 =?utf-8?B?WDl0ZVdNenN5aGx4VkVNck8vTnUzZ1JoSmJVdlVidGltRVczK0lqWUhKUy9P?=
 =?utf-8?B?UFhxdGMvejRyc3FQQVNjSXRPQUpwSkFVYWl6WTZFeWJjY0VnS241YXRwV2NX?=
 =?utf-8?B?S2Qyb2lMOTdzbEtXVmE1Uk1GUlN3MVNTeE5FZW40Nk9sRTRKZzR1SExUMWJx?=
 =?utf-8?B?MWtmRzhDRDBpd2NxTE9JMnJSS3J0UUtCVTMrUVV1Wm82Z2Jhdy9IdlZFaFIx?=
 =?utf-8?B?Wi9rYm5wOVJNWmN0YlBoVU1xMEViNG1rcERqUmpKVXJkNml3dEtpSW9kRURE?=
 =?utf-8?B?S3lwY3QyTjh2NHJwVkFqbjZQb2E4MUttTmxzSUFZM2RXbkROcGlnTGlaTU5p?=
 =?utf-8?B?TUp4QUlaYmdJbFJTTUN1RlB3b0hySVJUK1FYTmMwVUM2RFlaU0pBL3JDQXhX?=
 =?utf-8?B?SWNGaG9NMnFkRE04NzJCMjNjVmJsRVNaMC94Y3B0ZHgvaEZOOWZZbHpBWTJI?=
 =?utf-8?B?aGhobmRiNmliaFpiNmV1RGhsYlFZaElmamZ0cGZZTHBrNFdzWmVUZWNjWlBL?=
 =?utf-8?B?dmNEY3c1QllCemw4VHIwRjQxOWx0UTg1eUtDajI3WDFocWFvSGliVlVkSnhM?=
 =?utf-8?B?WmRuUThPVmxGSDllckxvekc0UWwvdGZYbUxEb3JWMGJwNGR5VEwzMzlDclRs?=
 =?utf-8?B?Vml2aFo5TzkvTzZWNDgwS2Q4Z0kvYU80MGNQV0R6V1JBS0V2eVhZSUJUdTd2?=
 =?utf-8?B?ZjhPNmowNFFpVmM1VWJadzkvWGZHRmQrVkhUT0xCOUM2am55YTM3ZGs5Yy9p?=
 =?utf-8?B?ZHdRYXorK1hkSktjcjhjKzFOa1pQRGxzR0lRYWc4c1FIYUt5cUJtaTlHbkxl?=
 =?utf-8?B?TkVMdHhkR25LWEFVdEJJQ3E0UW1HTGlZdFlNeEMwSW1tQ24yMlo1cnJFNHdk?=
 =?utf-8?B?S29NUk5vQ1ZZMlBzb3JseWU5QVJqN0V3RlVsQzNPZEZsWXh2aHNPeTJvRDRU?=
 =?utf-8?B?dFN3QzU3aVdhbzlwekJ0RUhJWEQ3OTNQNkowTWlQQmFIOC8wWDVEd1psQkl3?=
 =?utf-8?B?RTM1NUwxclhXQlFOQVIzNHlEd1lDSGlPYUpmZjI5TkV2Ti9TK0E3VnJ2T2tH?=
 =?utf-8?B?R0h2dlV1dCt2amtkdHIwTTFIUHgycnk5Q3ViR3NQNlhnVWI0Y2ExU2hMbkYz?=
 =?utf-8?B?WVE0dHVZRlMrNEcvc1UyMlE5TTFzRVE1Yk5qaVRjM0JEWnRLTE9lQjhGRnhj?=
 =?utf-8?B?d2dvakE1cUpFalFHMlF0SXdNTHRKeTA2dVArQkowRys3azBxd29NRS9FNkNZ?=
 =?utf-8?B?UnFEc0JnZFJ6UW5HYy9WZUhEUzBMRnpQekhrV21VWk1DamtBWHA1SFBjTXky?=
 =?utf-8?B?aWRaSDhqN0hJSmZHOGFKT1BONUtKRkY0d0xBcW1XRW5uL3JrR0NKaWNCeGJm?=
 =?utf-8?B?OVhrS0tON3pzb2kzQmtBaTFzN0lmam5CbTFDK3RkMm5DZU9mdWNzN0picjZw?=
 =?utf-8?Q?3TzwZWAF/9brs7QgrnVyZOEUiYfSWo6U?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2024 12:50:38.2415
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ab166165-3f6e-4c6a-da17-08dcdb0528b8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E62.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6320

NVIDIA vGPU VFIO module requires interfaces from the core driver support
to issue GSP RPCs, allocating FBMEM, create/destroy/reset vGPUs...

Implement interfaces to expose the core driver functions to
NVIDIA vGPU VFIO module.

Cc: Neo Jia <cjia@nvidia.com>
Cc: Surath Mitra <smitra@nvidia.com>
Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 .../nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h  |  6 ++
 drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/Kbuild  |  1 +
 drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vfio.c  | 69 +++++++++++++++++++
 .../gpu/drm/nouveau/nvkm/vgpu_mgr/vgpu_mgr.c  |  5 ++
 include/drm/nvkm_vgpu_mgr_vfio.h              | 24 +++++++
 5 files changed, 105 insertions(+)
 create mode 100644 drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vfio.c
 create mode 100644 include/drm/nvkm_vgpu_mgr_vfio.h

diff --git a/drivers/gpu/drm/nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h b/drivers/gpu/drm/nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h
index aaba6d9a88b4..5a856fa905f9 100644
--- a/drivers/gpu/drm/nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h
+++ b/drivers/gpu/drm/nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h
@@ -2,6 +2,8 @@
 #ifndef __NVKM_VGPU_MGR_H__
 #define __NVKM_VGPU_MGR_H__
 
+#include <drm/nvkm_vgpu_mgr_vfio.h>
+
 #define NVIDIA_MAX_VGPUS 2
 
 struct nvkm_vgpu_mgr {
@@ -17,6 +19,9 @@ struct nvkm_vgpu_mgr {
 	struct nvif_device_priv *dev_priv;
 
 	u64 vmmu_segment_size;
+
+	void *vfio_ops;
+	struct nvidia_vgpu_vfio_handle_data vfio_handle_data;
 };
 
 bool nvkm_vgpu_mgr_is_supported(struct nvkm_device *device);
@@ -25,5 +30,6 @@ int nvkm_vgpu_mgr_init(struct nvkm_device *device);
 void nvkm_vgpu_mgr_fini(struct nvkm_device *device);
 void nvkm_vgpu_mgr_populate_gsp_vf_info(struct nvkm_device *device,
 					void *info);
+void nvkm_vgpu_mgr_init_vfio_ops(struct nvkm_vgpu_mgr *vgpu_mgr);
 
 #endif
diff --git a/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/Kbuild b/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/Kbuild
index 244e967d4edc..a62c10cb1446 100644
--- a/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/Kbuild
+++ b/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/Kbuild
@@ -1,2 +1,3 @@
 # SPDX-License-Identifier: MIT
 nvkm-y += nvkm/vgpu_mgr/vgpu_mgr.o
+nvkm-y += nvkm/vgpu_mgr/vfio.o
diff --git a/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vfio.c b/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vfio.c
new file mode 100644
index 000000000000..e98c9e83ee60
--- /dev/null
+++ b/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vfio.c
@@ -0,0 +1,69 @@
+/* SPDX-License-Identifier: MIT */
+
+#include <core/device.h>
+
+#include <vgpu_mgr/vgpu_mgr.h>
+#include <drm/nvkm_vgpu_mgr_vfio.h>
+
+static bool vgpu_mgr_is_enabled(void *handle)
+{
+	struct nvkm_device *device = handle;
+
+	return nvkm_vgpu_mgr_is_enabled(device);
+}
+
+static void get_handle(void *handle,
+		       struct nvidia_vgpu_vfio_handle_data *data)
+{
+	struct nvkm_device *device = handle;
+	struct nvkm_vgpu_mgr *vgpu_mgr = &device->vgpu_mgr;
+
+	if (vgpu_mgr->vfio_handle_data.priv)
+		memcpy(data, &vgpu_mgr->vfio_handle_data, sizeof(*data));
+}
+
+static void detach_handle(void *handle)
+{
+	struct nvkm_device *device = handle;
+	struct nvkm_vgpu_mgr *vgpu_mgr = &device->vgpu_mgr;
+
+	vgpu_mgr->vfio_handle_data.priv = NULL;
+}
+
+static int attach_handle(void *handle,
+			 struct nvidia_vgpu_vfio_handle_data *data)
+{
+	struct nvkm_device *device = handle;
+	struct nvkm_vgpu_mgr *vgpu_mgr = &device->vgpu_mgr;
+
+	if (vgpu_mgr->vfio_handle_data.priv)
+		return -EEXIST;
+
+	memcpy(&vgpu_mgr->vfio_handle_data, data, sizeof(*data));
+	return 0;
+}
+
+struct nvkm_vgpu_mgr_vfio_ops nvkm_vgpu_mgr_vfio_ops = {
+	.vgpu_mgr_is_enabled = vgpu_mgr_is_enabled,
+	.get_handle = get_handle,
+	.attach_handle = attach_handle,
+	.detach_handle = detach_handle,
+};
+
+/**
+ * nvkm_vgpu_mgr_init_vfio_ops - init the callbacks for VFIO
+ * @vgpu_mgr: the nvkm vGPU manager
+ */
+void nvkm_vgpu_mgr_init_vfio_ops(struct nvkm_vgpu_mgr *vgpu_mgr)
+{
+	vgpu_mgr->vfio_ops = &nvkm_vgpu_mgr_vfio_ops;
+}
+
+struct nvkm_vgpu_mgr_vfio_ops *nvkm_vgpu_mgr_get_vfio_ops(void *handle)
+{
+	struct nvkm_device *device = handle;
+	struct nvkm_vgpu_mgr *vgpu_mgr = &device->vgpu_mgr;
+
+	return vgpu_mgr->vfio_ops;
+}
+EXPORT_SYMBOL(nvkm_vgpu_mgr_get_vfio_ops);
diff --git a/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vgpu_mgr.c b/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vgpu_mgr.c
index d2ea5a07cbfc..caeb805cf1c3 100644
--- a/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vgpu_mgr.c
+++ b/drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vgpu_mgr.c
@@ -1,4 +1,7 @@
 /* SPDX-License-Identifier: MIT */
+/*
+ * Copyright © 2024 NVIDIA Corporation
+ */
 #include <core/device.h>
 #include <core/driver.h>
 #include <nvif/driverif.h>
@@ -132,6 +135,8 @@ int nvkm_vgpu_mgr_init(struct nvkm_device *device)
 	if (ret)
 		goto err_get_vmmu_seg_size;
 
+	nvkm_vgpu_mgr_init_vfio_ops(vgpu_mgr);
+
 	vgpu_mgr->enabled = true;
 	pci_info(nvkm_to_pdev(device),
 		 "NVIDIA vGPU mananger support is enabled.\n");
diff --git a/include/drm/nvkm_vgpu_mgr_vfio.h b/include/drm/nvkm_vgpu_mgr_vfio.h
new file mode 100644
index 000000000000..09ecc3dc454f
--- /dev/null
+++ b/include/drm/nvkm_vgpu_mgr_vfio.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Copyright © 2024 NVIDIA Corporation
+ */
+
+#ifndef __NVKM_VGPU_MGR_VFIO_H__
+#define __NVKM_VGPU_MGR_VFIO_H__
+
+struct nvidia_vgpu_vfio_handle_data {
+	void *priv;
+};
+
+struct nvkm_vgpu_mgr_vfio_ops {
+	bool (*vgpu_mgr_is_enabled)(void *handle);
+	void (*get_handle)(void *handle,
+		           struct nvidia_vgpu_vfio_handle_data *data);
+	int (*attach_handle)(void *handle,
+		             struct nvidia_vgpu_vfio_handle_data *data);
+	void (*detach_handle)(void *handle);
+};
+
+struct nvkm_vgpu_mgr_vfio_ops *nvkm_vgpu_mgr_get_vfio_ops(void *handle);
+
+#endif
-- 
2.34.1


