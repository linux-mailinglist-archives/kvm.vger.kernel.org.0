Return-Path: <kvm+bounces-56705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47217B42C93
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 00:12:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF6563A9B22
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 22:12:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E2A92EF64E;
	Wed,  3 Sep 2025 22:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="F3dcybmN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2084.outbound.protection.outlook.com [40.107.220.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5862EDD5B
	for <kvm@vger.kernel.org>; Wed,  3 Sep 2025 22:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756937500; cv=fail; b=rkQJc9QNo3mgkUUeVjMjjJeZhRfMK8/aCX7R83dE7mbaHV9Hoo997PXWiF+izTuwUIAld9/mOt36pwTGsAcntbPsHECEsAbODJj+chx/LNKjUROH/RooYt2kBM2a8PqVThGknYU9mFEnl4oohfc8E4bJQkIOU+yvvL/tPcPIP78=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756937500; c=relaxed/simple;
	bh=z/0+2XeZ8SIMjKRuhL8pDcXwowBfJnv3Bju7Er+FW80=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lueXLYvY4VSY/Z5E3p30PFBeIL8ZAfGSVXW3q/lVLWOnuoN87polcLrIi2XPifSX53Py2vTF7aBjAyHU6kmUie1dSmznmu/tUEUBgMxxwG5KEodWQnWP+aFNXW8rWqQwwCO8UiZC4FVXFh01LF1fX1sco6xMVluWaVbx91jDKzY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=F3dcybmN; arc=fail smtp.client-ip=40.107.220.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bQ/B02rDoqnWtxo60lceWKftreAnyGtcfMUoY5HNjIqIg08pkMTSYMZ47h3ybHKOeflLtgdqFX0NzregwmkzMkzSl9SrjXRAw6S3czHAlGg/4zEI1qKcPxlTqtwh/QnLdaNwDUCXeQ+HIpv6mxcWguCrjas/qSuX0UEg+JSzvrFaGnPh7mAJYNy+QsZ9j3x48jFasrvk72/RTumCzSkv9GaOG9fVhyR/dv/7M0N5JugFOAtg+tq6GwjJiTK2t9juF/EVgyksocl+QHIoQnDjYVnw583zh6IUrYjE6x1CJ7Tfi36uxIiFlHUm4yJ3gL9cf15nyG9FG6W1w9oH+5hmUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BAMD489SPLBysDwaoPhOeR3xw50AJHw2x3mtKOLEWh0=;
 b=li5e8gHUNeiqvzpM3mw0K7wyYW6bdn7S/OW7BGZmJzs5eK03TftLOCcv57EOsyeR48zmJP6RFmW03R58LLoIcZBD3jBsazDe2CawLnhbh6lhi8+xKuPaglWsH5VlTc8gcnzABLu5h2xPV76vQ/9v9cp1OefuzrdTlm7ovhx5DjwAThveKiRnQjg/GjM+MEAa+JMceSsEZGNeOlevnhZN6w9nFkMb7UsaWgiwogPq1e+UztFk5Gmjzt6BG2T9yz8TsNKHFi8zI/Yq9Z8x8FvZft7jhtjaM8qlAOhuWuIXvOtfoQGNNoQhiExb7fv0m4G/LiXRMaDRT+XYOGhkBe00YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BAMD489SPLBysDwaoPhOeR3xw50AJHw2x3mtKOLEWh0=;
 b=F3dcybmNUcy+wdgz9SOCMN0WPcKeov+h8LKM3hg8GNUVAY7MCwYoD8PdjCFrYbHVeHE4Uk9FkyCNRN/i9bkwnoMuE1gCV4aqXAAKAaDQuSwdqHKdTvIVyxJTjyfapVuKaBTlMDJzOuUfj+ilqpxsEeeJBtsw868H4Aq42uAYBl1A5pOhCoasJWapHbA5UPDyiD0452J5gWEXQUa2hdMZNFUM066NuW9Aj1cymRdpJWEtyEkFP1ChrxcAcGWawGDGTW7jlG223CAIYS/zGzwm2g0qrU3xlWjB7IprKEMkiR6CiTQBuBiII/gqFTF6VKB7srl0e7hk8B4HE/LC3PQAPA==
Received: from CH2PR02CA0024.namprd02.prod.outlook.com (2603:10b6:610:4e::34)
 by MN2PR12MB4285.namprd12.prod.outlook.com (2603:10b6:208:1d7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Wed, 3 Sep
 2025 22:11:35 +0000
Received: from CH3PEPF0000000C.namprd04.prod.outlook.com
 (2603:10b6:610:4e:cafe::bd) by CH2PR02CA0024.outlook.office365.com
 (2603:10b6:610:4e::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.28 via Frontend Transport; Wed,
 3 Sep 2025 22:11:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH3PEPF0000000C.mail.protection.outlook.com (10.167.244.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.14 via Frontend Transport; Wed, 3 Sep 2025 22:11:35 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 15:11:21 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 15:11:20 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Wed, 3 Sep 2025 15:11:20 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <dakr@kernel.org>,
	<acurrid@nvidia.com>, <cjia@nvidia.com>, <smitra@nvidia.com>,
	<ankita@nvidia.com>, <aniketa@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC v2 12/14] vfio/nvidia-vgpu: scrub the guest FB memory of a vGPU
Date: Wed, 3 Sep 2025 15:11:09 -0700
Message-ID: <20250903221111.3866249-13-zhiw@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250903221111.3866249-1-zhiw@nvidia.com>
References: <20250903221111.3866249-1-zhiw@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000C:EE_|MN2PR12MB4285:EE_
X-MS-Office365-Filtering-Correlation-Id: 090711c1-cb93-493c-09a4-08ddeb36d8b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cGpzUlNHTm1qc1VMeVlMaDRCWm53T0RXTW1BdTJmS0J1NnFTTjdGRk9sNmRM?=
 =?utf-8?B?TkV2VVQwRVhoZ0VxeVN2VDdNbEE5c3dKWm9aRUovU041ZnRyR05BMWxGaW1P?=
 =?utf-8?B?cVpQWXhGQTNVMTM5cFBjRi9IN0VlWHZqN0diaXpHeHFGajJRdHY1SnhWZG9q?=
 =?utf-8?B?Y1Raci9PSGRKbTk1MG91SWJXVFlybml3Tm1zK3A1Sm9XUGorTDZZeCs1WEZT?=
 =?utf-8?B?ZERWa1hDMmxXMUdQMGlPWWZjbDRFMHNEL1BtampLN3V6WC9UODRlNW1vQVVM?=
 =?utf-8?B?a0ZUTFJOcVN0QVlENk8yVWV4YTFRcDlTQjFNbWh5ZFNTb1pXZ3pwVUxHd3N2?=
 =?utf-8?B?NnNNWkg4VFdRd1NvSUFGeVRQcjhOS3A1NnllQlhYaUdpbXljMmo3S0RPTGNN?=
 =?utf-8?B?YzhXWURPalNIU045Znl1RFd2R3dsR3RXQVl5aDkvS3lyY3lkTjFnak02cGto?=
 =?utf-8?B?L1NRQVAyWWhsbE00c1FDQk5WQWdmNFBEUVdrMlBuWDA3MTNEZjI2Q3JRRHdF?=
 =?utf-8?B?b2VsbityQmdjWTI3dE5TSXd0ZnBEMEdCRmZSK083VDhCUTFXTUs4M0U0bjJ0?=
 =?utf-8?B?T0ZFTTNEclIrVlBWLzJTUEpiZE1CM1FPZGJqZGNiRFdHS3FUUzNnZ21PcXRQ?=
 =?utf-8?B?NGtTdXdWa3UzZTFiWXRFalJGcjZrcXZNSXdqTno0TlZ5U1JTcDllaTgzRnNm?=
 =?utf-8?B?SGt0WkhMUjFWNDVXM1g5QzduVzRaTi9hZUF6MnJnSlRXZU1ZNmFkTkRtVEtv?=
 =?utf-8?B?S0NzZjR4ZXFUM3dZUndYS1VwZ3E1c1Y5a0I4M092eWVGaTltemZmR0NBNHk2?=
 =?utf-8?B?YXR1M1dKVHhHMXR3K2J4dnVaMW8wV3NZa3FlR3hPSUhQUFlrenVvc3RyaG9Q?=
 =?utf-8?B?VEdtanVnN0FLdTk0dWVyYW5STTJzQWZCUzBmc2xUZnhTUE95WGhKWFRZZ0c1?=
 =?utf-8?B?b0lsN0VRMkpERVdKNThHZDUxeHVNQWZkZVUxYUwvYlN4Q0dqbzNSczU2R1ZV?=
 =?utf-8?B?b25SV0dOQ0RIRzYya1pMZnU3NWp1T0ExNDcrYkxBSldoU3dFY3NFVWdhaDZ0?=
 =?utf-8?B?TW52WHZhSy9NNmZBQkJQSWZrdjFwU0hLbTUyamtmeTV2RjRtdFFaSHdROExH?=
 =?utf-8?B?cXhXWndURFJCME84R0xXUXRYWDk3bXFCTGl2R2pCZ01YYkh5b0ZWTWJ5VUww?=
 =?utf-8?B?R2lCQzFMUXh1YW1BSHF1ZFpTdFE4M0YxazkrUUpOb1lVM3JMdTNnVjI2NmVU?=
 =?utf-8?B?ZEpaYURyWWdLY0s0SEw5dHNnekhyU3FWKzBTdGVTZDNqUlc5NzdZMTBkRFhW?=
 =?utf-8?B?TWZKOGFSem9ZZUUzMG45cUYyV1lURVlnZ3pFZ1Y2UDdzcmczb1lEdWZhOGN5?=
 =?utf-8?B?dkV0V1BMbTRNcGNGN2x0M0FtZnNleER2UnFTMHB0WFFPV042WldDTXBrcjR4?=
 =?utf-8?B?cFNWQ2xwUTRWcjIyV2NHdnJIL2JTUWRQd3NLazJCcU50eE9jNXB1elZaVmRJ?=
 =?utf-8?B?OEFzK3dQK25mRmJGamp3Mk1DZWw1TGhkNXBKQVlOSXVoNUlUWTFvbFQ3Znht?=
 =?utf-8?B?OWdxRDAyL21pZUlPZzYvR2RtdEQ1S0U5Z09nMmFGWjE1a0xzWmFyWVZmR1Fi?=
 =?utf-8?B?SXVmUmY0WUpmRTdJdEJhS0RDTG1pTEZMRXNOcFRXSjdOT21kN2EraW1UL2JM?=
 =?utf-8?B?UUFSNEdnZDYxQ0RtMXg3dXFGLzJiV0l3S2VNTWFiWUtuR0F6dHpYdGZsM2VF?=
 =?utf-8?B?dDc3VHA4MjhhbE0wd1NlV3R6TWlhOFRiMEorR2VsWWMxdFk5dG5uZi9zSWw3?=
 =?utf-8?B?SW5VMnpOclR2Vm0yRmNTblFUbjh4Kzc2UU9oWUMxM3NwbkIwT1M2T2VWRjRk?=
 =?utf-8?B?V2F3VnJmWk9pN2NaNFNYWTlvVDBtdDk4TmhaUnE4amkvNU53R1I5RXhzL2RC?=
 =?utf-8?B?aFBpNnRZZ3loamI2N2hTWEUzYU9ORDBsOGhlaGdOK0Vlb2FTWWkreUNmUzZz?=
 =?utf-8?B?MHovaFdHeERESlNZSHpEcTNHenhxZldBSlNOZUFHbDQ5NHhIdTlZZzRMdjNF?=
 =?utf-8?Q?ZXYgDl?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 22:11:35.1486
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 090711c1-cb93-493c-09a4-08ddeb36d8b6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4285

Before reassigning a vGPU to a new guest, its associated FB memory must be
scrubbed to prevent potential information leakage across users.

Residual data left in the FB memory could be visible to the subsequent
guest, posing a significant security risk without the scrubbing.

Scrub the FB memory by issusing copy engine workloads when the user opening
and closing the VFIO device.

Cc: Aniket Agashe <aniketa@nvidia.com>
Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 drivers/vfio/pci/nvidia-vgpu/pf.h       |  23 +++
 drivers/vfio/pci/nvidia-vgpu/vgpu.c     | 218 +++++++++++++++++++++++-
 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c |   6 +
 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h |  24 ++-
 4 files changed, 264 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/pci/nvidia-vgpu/pf.h b/drivers/vfio/pci/nvidia-vgpu/pf.h
index d081d8e718e1..d9daaace7d31 100644
--- a/drivers/vfio/pci/nvidia-vgpu/pf.h
+++ b/drivers/vfio/pci/nvidia-vgpu/pf.h
@@ -119,4 +119,27 @@ static inline int nvidia_vgpu_mgr_init_handle(struct pci_dev *pdev,
 	__m->handle.ops->get_engine_bitmap(__m->handle.pf_drvdata, bitmap); \
 })
 
+#define nvidia_vgpu_mgr_channel_map_mem(m, chan, mem, info) \
+	((m)->handle.ops->channel_map_mem(chan, mem, info))
+
+#define nvidia_vgpu_mgr_channel_unmap_mem(m, mem) \
+	((m)->handle.ops->channel_unmap_mem(mem))
+
+#define nvidia_vgpu_mgr_alloc_ce_channel(m, chid) ({ \
+	typeof(m) __m = (m); \
+	__m->handle.ops->alloc_ce_channel(__m->handle.pf_drvdata, chid); \
+})
+
+#define nvidia_vgpu_mgr_free_ce_channel(m, chan) \
+	((m)->handle.ops->free_ce_channel(chan))
+
+#define nvidia_vgpu_mgr_begin_pushbuf(m, chan, num_dwords) \
+	((m)->handle.ops->begin_pushbuf(chan, num_dwords))
+
+#define nvidia_vgpu_mgr_emit_pushbuf(m, chan, dwords) \
+	((m)->handle.ops->emit_pushbuf(chan, dwords))
+
+#define nvidia_vgpu_mgr_submit_pushbuf(m, chan) \
+	((m)->handle.ops->submit_pushbuf(chan))
+
 #endif
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu.c b/drivers/vfio/pci/nvidia-vgpu/vgpu.c
index 72083d300b8a..52b01efdf133 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu.c
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu.c
@@ -2,7 +2,6 @@
 /*
  * Copyright © 2025 NVIDIA Corporation
  */
-
 #include <linux/log2.h>
 
 #include "debug.h"
@@ -111,6 +110,209 @@ static int setup_chids(struct nvidia_vgpu *vgpu)
 	return 0;
 }
 
+static void clean_ce_channel(struct nvidia_vgpu *vgpu)
+{
+	struct nvidia_vgpu_mgr *vgpu_mgr = vgpu->vgpu_mgr;
+	struct nvidia_vgpu_ce_channel *channel = &vgpu->ce_channel;
+
+	nvidia_vgpu_event_unregister_listener(&vgpu_mgr->pf_channel_event_chain,
+					      &channel->listener);
+
+	nvidia_vgpu_mgr_channel_unmap_mem(vgpu_mgr, channel->sema_mem);
+	nvidia_vgpu_mgr_bar1_unmap_mem(vgpu_mgr, channel->sema_mem);
+	nvidia_vgpu_mgr_free_fbmem(vgpu_mgr, channel->sema_mem);
+	nvidia_vgpu_mgr_free_ce_channel(vgpu_mgr, channel->chan);
+	channel->chan = NULL;
+	channel->sema_mem = NULL;
+}
+
+static int handle_channel_events(struct nvidia_vgpu_event_listener *self, unsigned int event,
+				 void *data)
+{
+	struct nvidia_vgpu_ce_channel *channel = container_of(self, typeof(*channel), listener);
+	struct nvidia_vgpu *vgpu = container_of(channel, typeof(*vgpu), ce_channel);
+
+	if (data != channel->chan)
+		return 0;
+
+	switch (event) {
+	case NVIDIA_VGPU_PF_CHANNEL_EVENT_FIFO_NONSTALL:
+		vgpu_debug(vgpu, "handle channel event fifo nonstall\n");
+
+		wake_up(&channel->wq);
+		break;
+	}
+	return 0;
+}
+
+static int setup_ce_channel(struct nvidia_vgpu *vgpu)
+{
+	struct nvidia_vgpu_mgr *vgpu_mgr = vgpu->vgpu_mgr;
+	struct nvidia_vgpu_ce_channel *channel = &vgpu->ce_channel;
+	struct nvidia_vgpu_chid *chid = &vgpu->chid;
+	struct nvidia_vgpu_alloc_fbmem_info alloc_info = {0};
+	struct nvidia_vgpu_map_mem_info map_info = {0};
+	struct nvidia_vgpu_chan *chan;
+	struct nvidia_vgpu_mem *mem;
+	int ret;
+
+	chan = nvidia_vgpu_mgr_alloc_ce_channel(vgpu_mgr, chid->chid_offset + chid->num_chid - 1);
+	if (IS_ERR(chan))
+		return PTR_ERR(chan);
+
+	/* Allocate a page for semaphore */
+	alloc_info.size = SZ_4K;
+
+	mem = nvidia_vgpu_mgr_alloc_fbmem(vgpu_mgr, &alloc_info);
+	if (IS_ERR(mem))
+		goto err_alloc_fbmem;
+
+	map_info.map_size = SZ_4K;
+
+	ret = nvidia_vgpu_mgr_channel_map_mem(vgpu_mgr, chan, mem, &map_info);
+	if (ret)
+		goto err_chan_map_mem;
+
+	ret = nvidia_vgpu_mgr_bar1_map_mem(vgpu_mgr, mem, &map_info);
+	if (ret)
+		goto err_bar1_map_mem;
+
+	channel->chan = chan;
+	channel->sema_mem = mem;
+
+	init_waitqueue_head(&channel->wq);
+
+	INIT_LIST_HEAD(&channel->listener.list);
+	channel->listener.func = handle_channel_events;
+
+	nvidia_vgpu_event_register_listener(&vgpu_mgr->pf_channel_event_chain,
+					    &channel->listener);
+
+	return 0;
+
+err_bar1_map_mem:
+	nvidia_vgpu_mgr_channel_unmap_mem(vgpu_mgr, mem);
+err_chan_map_mem:
+	nvidia_vgpu_mgr_free_fbmem(vgpu_mgr, mem);
+err_alloc_fbmem:
+	nvidia_vgpu_mgr_free_ce_channel(vgpu_mgr, chan);
+	return ret;
+}
+
+static bool ce_workload_complete(struct nvidia_vgpu_ce_channel *channel)
+{
+	return !!READ_ONCE(*(u32 *)(channel->sema_mem->bar1_vaddr));
+}
+
+#define VGPU_SCRUBBER_LINE_LENGTH_MAX 0x80000000
+#define FBMEM_SCRUB_TIMEOUT_MS (4000)
+
+static int scrub_fbmem_heap(struct nvidia_vgpu *vgpu)
+{
+	struct nvidia_vgpu_mgr *vgpu_mgr = vgpu->vgpu_mgr;
+	struct nvidia_vgpu_ce_channel *channel;
+	struct nvidia_vgpu_chan *chan;
+	struct nvidia_vgpu_mem *mem = vgpu->fbmem_heap;
+	struct nvidia_vgpu_map_mem_info map_info = {0};
+	u64 line_length = mem->size;
+	u32 line_count = 1;
+	int ret;
+	int i;
+
+	if (WARN_ON(!vgpu_mgr->use_ce_scrub_fbmem))
+		return 0;
+
+	ret = setup_ce_channel(vgpu);
+	if (ret)
+		return ret;
+
+	channel = &vgpu->ce_channel;
+	chan = channel->chan;
+
+	map_info.compressible_disable_plc = true;
+	map_info.huge_page = true;
+	map_info.map_size = mem->size;
+
+	ret = nvidia_vgpu_mgr_channel_map_mem(vgpu_mgr, chan, mem, &map_info);
+	if (ret)
+		goto err_chan_map_mem;
+
+	vgpu_debug(vgpu, "guest FB memory chan vma 0x%llx\n", mem->chan_vma_addr);
+
+	while (line_length > VGPU_SCRUBBER_LINE_LENGTH_MAX) {
+		line_count = line_count << 1;
+		line_length = line_length >> 1;
+	}
+
+	*(u32 *)(channel->sema_mem->bar1_vaddr) = 0;
+
+	vgpu_debug(vgpu, "semaphore seqno before scrubbing 0x%x\n",
+		   *(u32 *)(channel->sema_mem->bar1_vaddr));
+
+	nvidia_vgpu_mgr_begin_pushbuf(vgpu_mgr, chan, 150);
+
+#define EMIT_DWORD(x) \
+	nvidia_vgpu_mgr_emit_pushbuf(vgpu_mgr, chan, x)
+
+	for (i = 0; i < 128; i += 4)
+		EMIT_DWORD(0x0);
+
+	EMIT_DWORD(0x20010000);
+	EMIT_DWORD(chan->ce_object_handle);
+	EMIT_DWORD(0x200181c2);
+	EMIT_DWORD(0x30004);
+
+	EMIT_DWORD(0x200181c0);
+	EMIT_DWORD(0x0);
+
+	EMIT_DWORD(0x20048104);
+	EMIT_DWORD(lower_32_bits(line_length));
+	EMIT_DWORD(lower_32_bits(line_length));
+	EMIT_DWORD(lower_32_bits(line_length >> 2));
+	EMIT_DWORD(line_count);
+
+	EMIT_DWORD(0x20028102);
+	EMIT_DWORD(upper_32_bits(vgpu->fbmem_heap->chan_vma_addr));
+	EMIT_DWORD(lower_32_bits(vgpu->fbmem_heap->chan_vma_addr));
+
+	EMIT_DWORD(0x200180c0);
+	EMIT_DWORD(0x785);
+
+	EMIT_DWORD(0x20038090);
+	EMIT_DWORD(upper_32_bits(vgpu->ce_channel.sema_mem->chan_vma_addr));
+	EMIT_DWORD(lower_32_bits(vgpu->ce_channel.sema_mem->chan_vma_addr));
+	EMIT_DWORD(0xdeadbeef);
+
+	EMIT_DWORD(0x200180c0);
+	EMIT_DWORD(0x5cc);
+
+#undef EMIT_DWORD
+
+	nvidia_vgpu_mgr_submit_pushbuf(vgpu_mgr, chan);
+
+	if (!wait_event_timeout(channel->wq, ce_workload_complete(channel),
+				msecs_to_jiffies(FBMEM_SCRUB_TIMEOUT_MS))) {
+		vgpu_debug(vgpu, "fail to wait for CE workload complete\n");
+
+		ret = -ETIMEDOUT;
+		goto err_pushbuf;
+	}
+
+	vgpu_debug(vgpu, "semaphore seqno after scrubbing 0x%x\n",
+		   *(u32 *)(channel->sema_mem->bar1_vaddr));
+
+	nvidia_vgpu_mgr_channel_unmap_mem(vgpu_mgr, mem);
+	clean_ce_channel(vgpu);
+
+	return 0;
+
+err_pushbuf:
+	nvidia_vgpu_mgr_channel_unmap_mem(vgpu_mgr, mem);
+err_chan_map_mem:
+	clean_ce_channel(vgpu);
+	return ret;
+}
+
 static void clean_fbmem_heap(struct nvidia_vgpu *vgpu)
 {
 	struct nvidia_vgpu_mgr *vgpu_mgr = vgpu->vgpu_mgr;
@@ -118,6 +320,8 @@ static void clean_fbmem_heap(struct nvidia_vgpu *vgpu)
 	vgpu_debug(vgpu, "free guest FB memory, offset 0x%llx size 0x%llx\n",
 		   vgpu->fbmem_heap->addr, vgpu->fbmem_heap->size);
 
+	if (vgpu_mgr->use_ce_scrub_fbmem)
+		WARN_ON(scrub_fbmem_heap(vgpu));
 	nvidia_vgpu_mgr_free_fbmem(vgpu_mgr, vgpu->fbmem_heap);
 	vgpu->fbmem_heap = NULL;
 }
@@ -172,7 +376,8 @@ static int setup_fbmem_heap(struct nvidia_vgpu *vgpu)
 	vgpu_debug(vgpu, "guest FB memory offset 0x%llx size 0x%llx\n", mem->addr, mem->size);
 
 	vgpu->fbmem_heap = mem;
-	return 0;
+
+	return vgpu_mgr->use_ce_scrub_fbmem ? scrub_fbmem_heap(vgpu) : 0;
 }
 
 static void clean_mgmt_heap(struct nvidia_vgpu *vgpu)
@@ -437,6 +642,7 @@ EXPORT_SYMBOL_GPL(nvidia_vgpu_mgr_create_vgpu);
  */
 int nvidia_vgpu_mgr_reset_vgpu(struct nvidia_vgpu *vgpu)
 {
+	struct nvidia_vgpu_mgr *vgpu_mgr = vgpu->vgpu_mgr;
 	int ret;
 
 	ret = nvidia_vgpu_rpc_call(vgpu, NV_VGPU_CPU_RPC_MSG_RESET, NULL, 0);
@@ -445,6 +651,14 @@ int nvidia_vgpu_mgr_reset_vgpu(struct nvidia_vgpu *vgpu)
 		return ret;
 	}
 
+	if (vgpu_mgr->use_ce_scrub_fbmem) {
+		ret = scrub_fbmem_heap(vgpu);
+		if (ret) {
+			vgpu_error(vgpu, "fail to scrub the fbmem %d\n", ret);
+			return ret;
+		}
+	}
+
 	vgpu_debug(vgpu, "reset done\n");
 	return 0;
 }
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c
index e502a37468e3..79b8d4b917f7 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c
@@ -105,6 +105,7 @@ static struct nvidia_vgpu_mgr *alloc_vgpu_mgr(struct nvidia_vgpu_mgr_handle *han
 	atomic_set(&vgpu_mgr->num_vgpus, 0);
 	mutex_init(&vgpu_mgr->curr_vgpu_type_lock);
 	nvidia_vgpu_event_init_chain(&vgpu_mgr->pf_driver_event_chain);
+	nvidia_vgpu_event_init_chain(&vgpu_mgr->pf_channel_event_chain);
 
 	return vgpu_mgr;
 }
@@ -132,6 +133,7 @@ static int call_chain(struct nvidia_vgpu_event_chain *chain, unsigned int event,
 static const char *pf_events_string[NVIDIA_VGPU_PF_EVENT_MAX] = {
 	[NVIDIA_VGPU_PF_DRIVER_EVENT_SRIOV_CONFIGURE] = "SRIOV configure",
 	[NVIDIA_VGPU_PF_DRIVER_EVENT_DRIVER_UNBIND] = "driver unbind",
+	[NVIDIA_VGPU_PF_CHANNEL_EVENT_FIFO_NONSTALL] = "FIFO nonstall",
 };
 
 static int pf_event_notify_fn(void *priv, unsigned int event, void *data)
@@ -148,6 +150,9 @@ static int pf_event_notify_fn(void *priv, unsigned int event, void *data)
 	case NVIDIA_VGPU_PF_DRIVER_EVENT_START...NVIDIA_VGPU_PF_DRIVER_EVENT_END:
 		ret = call_chain(&vgpu_mgr->pf_driver_event_chain, event, data);
 		break;
+	case NVIDIA_VGPU_PF_CHANNEL_EVENT_START...NVIDIA_VGPU_PF_CHANNEL_EVENT_END:
+		ret = call_chain(&vgpu_mgr->pf_channel_event_chain, event, data);
+		break;
 	}
 
 	return ret;
@@ -300,6 +305,7 @@ static int setup_pf_driver_caps(struct nvidia_vgpu_mgr *vgpu_mgr, unsigned long
 	test_bit(NVIDIA_VGPU_PF_DRIVER_CAP_HAS_##cap, caps)
 
 	vgpu_mgr->use_chid_alloc_bitmap = !HAS_CAP(CHID_ALLOC);
+	vgpu_mgr->use_ce_scrub_fbmem = HAS_CAP(CE_CHAN_ALLOC) | HAS_CAP(PUSHBUF_SUBMIT);
 
 #undef HAS_CAP
 	return 0;
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
index dc782f825f2b..b5bcde555a5d 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
@@ -69,6 +69,18 @@ struct nvidia_vgpu_rpc {
 	void __iomem *error_buf;
 };
 
+struct nvidia_vgpu_event_listener {
+	int (*func)(struct nvidia_vgpu_event_listener *self, unsigned int event, void *data);
+	struct list_head list;
+};
+
+struct nvidia_vgpu_ce_channel {
+	struct nvidia_vgpu_chan *chan;
+	struct nvidia_vgpu_mem *sema_mem;
+	struct nvidia_vgpu_event_listener listener;
+	struct wait_queue_head wq;
+};
+
 /**
  * struct nvidia_vgpu - per-vGPU state
  *
@@ -83,6 +95,7 @@ struct nvidia_vgpu_rpc {
  * @fbmem_heap: allocated FB memory for the vGPU
  * @mgmt: vGPU mgmt heap
  * @rpc: vGPU host RPC
+ * @ce_channel: copy engine channel
  */
 struct nvidia_vgpu {
 	/* Per-vGPU lock */
@@ -99,11 +112,7 @@ struct nvidia_vgpu {
 	struct nvidia_vgpu_mem *fbmem_heap;
 	struct nvidia_vgpu_mgmt mgmt;
 	struct nvidia_vgpu_rpc rpc;
-};
-
-struct nvidia_vgpu_event_listener {
-	int (*func)(struct nvidia_vgpu_event_listener *self, unsigned int event, void *data);
-	struct list_head list;
+	struct nvidia_vgpu_ce_channel ce_channel;
 };
 
 struct nvidia_vgpu_event_chain {
@@ -140,8 +149,10 @@ struct nvidia_vgpu_event_chain {
  * @curr_vgpu_type: type of current created vgpu in homogeneous mode
  * @num_instances: number of created vGPU with curr_vgpu_type in homogeneous mode
  * @pf_driver_event_chain: PF driver event chain
+ * @pf_channel_event_chain: PF channel event chain
  * @pdev: the PCI device pointer
  * @bar0_vaddr: the virtual address of BAR0
+ * @use_ce_scrub_fbmem: scrub the FB memory if the PF driver supports.
  */
 struct nvidia_vgpu_mgr {
 	struct kref refcount;
@@ -184,9 +195,12 @@ struct nvidia_vgpu_mgr {
 	unsigned int num_instances;
 
 	struct nvidia_vgpu_event_chain pf_driver_event_chain;
+	struct nvidia_vgpu_event_chain pf_channel_event_chain;
 
 	struct pci_dev *pdev;
 	void __iomem *bar0_vaddr;
+
+	bool use_ce_scrub_fbmem;
 };
 
 #define nvidia_vgpu_mgr_for_each_vgpu(vgpu, vgpu_mgr) \
-- 
2.34.1


