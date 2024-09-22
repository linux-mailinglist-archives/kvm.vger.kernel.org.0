Return-Path: <kvm+bounces-27254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A929B97E1A8
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 14:51:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1D0631F213B6
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 12:51:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B6FFFBF0;
	Sun, 22 Sep 2024 12:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jKHfch9x"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2049.outbound.protection.outlook.com [40.107.94.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF70BBA38
	for <kvm@vger.kernel.org>; Sun, 22 Sep 2024 12:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727009441; cv=fail; b=V8Q9nlw1q1la+sw+/mTDOD8N0AY3NggEsz0McYQg/hSAIOKW51Sozr5V2YSsoExNU7FhGXFqtvjAVtgmMpqBiCVIaaI2NfSFjhz9bWiSYBE/fyXryKZF0vw3XuNuSW3ZXAHHAsYwpuWWNR0wF8KQrdbNswnndTynPTnlGgsJVXI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727009441; c=relaxed/simple;
	bh=6QvQS+dGPwC+NX5O8iwmPDS1q2pt3ur9kRWyTE5utOE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gbYntLtiHmVGlToBV3txKrg0JneEOY1za3DaAxVWUdmLCPqH0jsBS02+r3dZ5fMgzRLMPZaZ/SwPH6GPMRbWs9Y5bDpQPUy4XbLIflZ17bWP3s1GCa2HGGQbu7J8omrn98hMGKT2pmiDY9yDpEwUngQA+1nPvb1s0KXWwtN7VSA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jKHfch9x; arc=fail smtp.client-ip=40.107.94.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uNMdM773AKB2Hh5H4FQ2Y0Kb7FxAQg0964rTTArQPWxs6Yd3K80xY8Wgq41mFd0sufyHm0qE36zZZr/G71aQw39+6Gh1vdxYsnDDIWaltFmQtitGOz+BNFNlAmU1smPJHO3J56xHmkwCVCjgKsc2cspsyhcAD/CMPfrDkRWGqtR3iS9SOn2NlRN+ZGEU2AZTIPcecWMwN2ulGTzxcOGMOEo5gbOkosUeaZg0O+XLH77ZvH8yYwBZEsQIVs5ThHIK8dEiY78UpOGU5uyuUtSaxLpxpFxAj3UY+wtgjDkIy9V51d8tYmaSn/5rPMb9Sy5PuWu1xhTduehWgSSp1OcggA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YZusEDF1qzJX69Q76nZVilAAz+yoqKvuL8KWAZlvxXk=;
 b=CGhOcpLeoibFX+HTHd0kxKmKETc36S+fNzFGpsZ3Rcgt/tgtCCV8M+jD1wR4uLYTBTA9rKP3tsVW6lmcJqCb2q9ogetKctylG0piABE/EuC4Wj1m/bLfhSu0z7BTrfG2t+G8/FbHkGc/GiP/gJc59qwcDWrb7Pkaxk7BIKxBxVNSw1eXIuABz1R/XqE9KBz3Ow/A866dPm5p+0SDRyOXP7kI9tGLIh5JLIHWghQYlBNOzPJeH+Ng+ASMnoEV6j9ibCFbVQ7eQHGiNZeIxw50HzPv38a8BsZjpOlJzh1aOg3ju12YElwb/yr7a7yPVG6H4wyVRhGm+tiLeCeI5fYMRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YZusEDF1qzJX69Q76nZVilAAz+yoqKvuL8KWAZlvxXk=;
 b=jKHfch9xGvBMXXvQ0VGHF4DwyvyLVgarzo8HIIxAcTrEWBBFRWN2MT959BuM/yW/Ys547Dn3FjAq6GRZ9p0AJl9cYy7xaRnjGMhjpI5qp+lEGyLZFTbN+9vWveUfRP+HoesF9Hsf0mLEyrGBPO29W7vRgrezxmJj7Dhfcab5ew6ZW9gJvraJbH1zRd3U7+LPXF4yVFr5gxOzGBEvtR2royVqxcloVcb6xczn+EndJJ+L3Kr+hIGKvBfExtAc6TUbPI6x3yC7abWUg5CnCLpmrklaA3wG7hnpDHiottN17nYoA6TNfItOnW4ya18R5E9BTmfNeZqB2opgOeI89ysmnw==
Received: from BN9PR03CA0297.namprd03.prod.outlook.com (2603:10b6:408:f5::32)
 by CY8PR12MB7514.namprd12.prod.outlook.com (2603:10b6:930:92::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.24; Sun, 22 Sep
 2024 12:50:36 +0000
Received: from BL6PEPF00020E66.namprd04.prod.outlook.com
 (2603:10b6:408:f5:cafe::1d) by BN9PR03CA0297.outlook.office365.com
 (2603:10b6:408:f5::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.26 via Frontend
 Transport; Sun, 22 Sep 2024 12:50:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL6PEPF00020E66.mail.protection.outlook.com (10.167.249.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Sun, 22 Sep 2024 12:50:36 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 22 Sep
 2024 05:50:24 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Sun, 22 Sep 2024 05:50:23 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Sun, 22 Sep 2024 05:50:22 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>, <nouveau@lists.freedesktop.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <acurrid@nvidia.com>,
	<cjia@nvidia.com>, <smitra@nvidia.com>, <ankita@nvidia.com>,
	<aniketa@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC 06/29] nvkm/vgpu: set RMSetSriovMode when NVIDIA vGPU is enabled
Date: Sun, 22 Sep 2024 05:49:28 -0700
Message-ID: <20240922124951.1946072-7-zhiw@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E66:EE_|CY8PR12MB7514:EE_
X-MS-Office365-Filtering-Correlation-Id: f19cb38a-ff1d-4f0d-8f60-08dcdb052773
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5JSFFEzvKkQypFQpN5c43RPq8H5gUx+1VHdlEXmvkISXGGcEoSoeJuc7EFkQ?=
 =?us-ascii?Q?9yJssI7oxmXTcXUzwXYOJ1gYfiNAkQAIgw35gYmxlzkEICFW8/YBQVC+pia5?=
 =?us-ascii?Q?46VQlo1lUN+wkSqAS+3I4INqTE/glZQ6IMWP8k8Y64F5crKzAmhVgq1R5SZO?=
 =?us-ascii?Q?ZixE+oMpOepS2axnD7Isb9L35Ln7v2iQTy6WNl0dnBZBVfk5aIXAemwE77gX?=
 =?us-ascii?Q?FNeKHK1oZHo+fNUABufTEgC73qKxwigbjdKQRfxNxMUFjQpntgn/R3oqf9iW?=
 =?us-ascii?Q?zE74Y6FGFyy/Pl3kd3dTrUwUIfy+z7Whb86zFVlyrWjooIRsaF6SdBizeegG?=
 =?us-ascii?Q?TxjiCwZzSzlkw3DCuWjXd6aWv3jo26qW9UrhoAzA5LyLsb864ZskSAoHjYfj?=
 =?us-ascii?Q?kf+AOMLsrqhu2SXr6HoO//WrOUFamWnQHBCDbe7pdq766KKkg490VpzbLUQj?=
 =?us-ascii?Q?4Kg8ZCxQK0JMTfuzVH7MBATTbPpFPOJRrY52Bj2dtRCi98ohXi8Uxto2TXEA?=
 =?us-ascii?Q?mUssTtlcm+ok7qDr3ZMk0XFIyd6NGyemuPkFAbg46w6tFjIeFUGjozOd72IU?=
 =?us-ascii?Q?r6knG2uEqVEzkwkVDvQ5swZR/R/xsz2uvojGAZjbKX241wmo/fXIqUFHfAJ8?=
 =?us-ascii?Q?KciSqC7oUxOpLEFgAarIDhTOnUWltsMCbkmFlAObZdGUvhgdCad0Bsd3oaPB?=
 =?us-ascii?Q?quK8LZPhQUokhf+BtQB4eRV5X5c57erzA/jZpy+N+pq5y4snpdQ6cw21E57v?=
 =?us-ascii?Q?YrKt30/TpQCextE0P6XN0S2fQ6afsVY/jgYUpuRSUhjQuc6IpxZnnvTTXMU8?=
 =?us-ascii?Q?WGWxJweeUFHNxswhoSKyQj/XjbyiZzN13/KCyAKBiX7PDMBaGTKXZpJC3VXS?=
 =?us-ascii?Q?PERKk3rb5oByHmjJHZqgBcNNWdsf1rKJsYZGWwqXXcJUJvT/XTyf2nSuFmy+?=
 =?us-ascii?Q?9Mk92uEFvAPNEltEG9oPCdhLWpfXQ528Yo0LSXe75ILx+xwQLb+yLlS+pv6j?=
 =?us-ascii?Q?YS/LIYiN3Gg+xKGTd68JuiP5CimmctloAa97fQOX6wLtp6uYj3uVZ1X/mpzJ?=
 =?us-ascii?Q?JevJK4R1JGPVzdyPICEmDmAAHiF4zKgvcZrTFmzMpJqDsrzd5rhBqy55WXc2?=
 =?us-ascii?Q?IgGFCJsbRWxeMZDd7fUclL3b8aGDHPq7pDYtynuGTOZPUnvcMEb8+CSKkM73?=
 =?us-ascii?Q?Y2ZpRi+ZFnaBISOVgGuwZK9GwsMuZP+XAXtEjgtvIOq2Wbav0Y0JwaVl2TzU?=
 =?us-ascii?Q?Mnz45UfKTfGS61Wl1RD3k6j5L3C6qszrxDJ8VjkCD5odN14lI7hIHP8l39cT?=
 =?us-ascii?Q?ylFkHhwaHUKcPJ48CwPPDr06lUuKmoNQrPBizL2eyQpC4jrHPoDhlabut3k9?=
 =?us-ascii?Q?xCxFsc83fhBTDKK94eDZejvVpOpw?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2024 12:50:36.1097
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f19cb38a-ff1d-4f0d-8f60-08dcdb052773
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E66.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7514

The registry object "RMSetSriovMode" is required to be set when vGPU is
enabled.

Set "RMSetSriovMode" to 1 when nvkm is loading the GSP firmware and
initialize the GSP registry objects, if vGPU is enabled.

Cc: Neo Jia <cjia@nvidia.com>
Cc: Surath Mitra <smitra@nvidia.com>
Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
index 49552d7df88f..a7db2a7880dd 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
@@ -1500,6 +1500,9 @@ r535_gsp_rpc_set_registry(struct nvkm_gsp *gsp)
 		kfree(p);
 	}
 
+	if (nvkm_vgpu_mgr_is_supported(gsp->subdev.device))
+		add_registry_num(gsp, "RMSetSriovMode", 1);
+
 	rpc = nvkm_gsp_rpc_get(gsp, NV_VGPU_MSG_FUNCTION_SET_REGISTRY, gsp->registry_rpc_size);
 	if (IS_ERR(rpc)) {
 		ret = PTR_ERR(rpc);
-- 
2.34.1


