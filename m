Return-Path: <kvm+bounces-27260-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C07BB97E1AE
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 14:52:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 695642814B4
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 12:52:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BF462B9C6;
	Sun, 22 Sep 2024 12:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Toecuze1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2058.outbound.protection.outlook.com [40.107.237.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9942B29CFE
	for <kvm@vger.kernel.org>; Sun, 22 Sep 2024 12:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727009449; cv=fail; b=qnkld6b3dqGWHHMjDFzL+2JMfm9zBDKWvcbRwI+7NzT8yEUugPYQQjL5PcNIpDaiE9K5sRC00fgGneEPJQzQa+nlTTDxyX/KV5l47DCOfFPkvq8BpsRUl7Y68DtTcOCclcDRhXzWAMKaNhSwb1u1N4SMOGc7FIkgJmlWrbLSvVE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727009449; c=relaxed/simple;
	bh=0maYBK1+RdEvZo/xKDMBqteT9pl26EhIsUjVzfHXR38=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ozP0sGjdMq8RBdrmathDHnNX2fb7QYkxk6s4P454pBhS0n0WaFe5mc2kAPTnPVbYQ+U41BXi4Hjahg8S+2d6VNYDGqqpv+VXJUqWbU6r+Ay0ljEWOWq2Xg0IhMRb6YjZVZwodiA+m45N7enN3IA/xEoWfOomdypW53m6fka5fV8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Toecuze1; arc=fail smtp.client-ip=40.107.237.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yvljXu9tt4sT8dQLp1YM0Lc0tJqRfOk79tLL70a5FzBccCbAEveK8YsUXS//l0+H4/pyD6hlo/qTKq8NP+YM9iOopUNubCFZa6dSn3e6lwjRU3LNsOcfLSm+0a4GNzQythlnlMjQXWMPmX7vO/PF0pM4YaKnGhySMJ+i/bhrNFYvQGX9kkx/ctdR/bbkebAu6kPWAonXqC7DvwRFx3Tc6y/2mmnxN2janJ0Z/gewV50Lkq57RPo6RvIdf4INPJdVCKoYmk3TWunlss6sd1wl0FE9TwIjVRe8aBsZTC4A3GJkBnNaG20Zbvuo1vUvtYABq14U84JGu1JMR+/eBJrnmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qXy8Q8t9lms2cFPdSfKW+hYTXiuejIlAVtlqQ8q7Gok=;
 b=yTLnw0W+KeX/YTMkMPCiExj05M+ncjEPUkXt9JqBoMYwI/WIs4Zkw3HIrN7hu2Pc0yltZzreEra1L0njSK7Wt+Yq2lE0GCdyQZAUKzS6XTm+GlTiyNjaw6sJ51w9u3e3Eg20WMXay0MIcF5/eEE00r43RHzVMAb6DC+xlGEV1a27sLbsKrOU93ja3X9jS4l7ofKxSKkYgzdKa+1gnLuiXU+WgLzssGD6AWev4/qpqL6T02+70QJ0il749bDsUurQEwrMr4+knGiYTMexMPS+AR/IgB5ys6cYgf9tOQox+wvF36lgUe4MOE0TWGNAfLwfwdcnE24CWkA7oWaxI3Ci4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qXy8Q8t9lms2cFPdSfKW+hYTXiuejIlAVtlqQ8q7Gok=;
 b=Toecuze1nwCaFF/zFGArmoDgvTjPnVWRlXOY/mFHFhnSxdrA+UbvU6MHLbrGfA/0st21L/JDFvmuOQtZS6T+UhEyECzO/TIuHriyKHC4aRd6hbCHRRiLYE2xIj46DVktWKz02UdGmTADSyopnVTRwTiN7GZsBF6I18F8d0QLtcKE8h5QIUqvmm4ISrvCDLUc/ZW6bl8qtbdFkbe5NbxM6UvEkC3X16dcdrisO1CW+7NDt4Z03iKIoeCttSOcukSJN2FWegaGlud8xD5+H0YgtITy7Mmyc+FIaFJrFKOlSLQ7AD7OLa4TIIaa29p13nUydVqz91mXN28mTZx+iYNfWQ==
Received: from BN9PR03CA0286.namprd03.prod.outlook.com (2603:10b6:408:f5::21)
 by SJ0PR12MB5609.namprd12.prod.outlook.com (2603:10b6:a03:42c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.24; Sun, 22 Sep
 2024 12:50:42 +0000
Received: from BL6PEPF00020E66.namprd04.prod.outlook.com
 (2603:10b6:408:f5:cafe::29) by BN9PR03CA0286.outlook.office365.com
 (2603:10b6:408:f5::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.30 via Frontend
 Transport; Sun, 22 Sep 2024 12:50:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL6PEPF00020E66.mail.protection.outlook.com (10.167.249.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Sun, 22 Sep 2024 12:50:41 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 22 Sep
 2024 05:50:28 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Sun, 22 Sep 2024 05:50:28 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Sun, 22 Sep 2024 05:50:27 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>, <nouveau@lists.freedesktop.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <acurrid@nvidia.com>,
	<cjia@nvidia.com>, <smitra@nvidia.com>, <ankita@nvidia.com>,
	<aniketa@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC 13/29] nvkm: move chid.h to nvkm/engine.
Date: Sun, 22 Sep 2024 05:49:35 -0700
Message-ID: <20240922124951.1946072-14-zhiw@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E66:EE_|SJ0PR12MB5609:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f01aaa1-c603-4710-7b59-08dcdb052acb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?u7hFjxCpjtEJZiBAJh11OegKK6LhG6Y95uafhxeueKKl2J8pBa1+ReYT4FYy?=
 =?us-ascii?Q?fFdQny4zHaFvlGKE3fUL2wVC+jDJCfiJrclrczZ4jGexDQ6tpduh4gmylPjc?=
 =?us-ascii?Q?o7TiJx/X7OZR+YAZE5FCiuezuBHVnX07NUNbANxKo1t6c1stGg6ecNROCWK0?=
 =?us-ascii?Q?t8J10VpDJAs3Ns5zkSPDCIWAav5I2W/7IFAVbMiTVkms+rGAZQBWdlljb8DY?=
 =?us-ascii?Q?4Th02JA1neL/5+OAatc/k2uG2LQ8ZxFJWqXscLtJfsOpGtiQyL1JNv/Gbcan?=
 =?us-ascii?Q?KTie9fKPBD/TlR3X67Y4w+0ZT80hwPUlJmb+ht7hzZOwHZCLHZd6+7FWiS4H?=
 =?us-ascii?Q?kr31dPyNoFd0FrbG5X6NyN3c8bvmMzjsYrYRJWHjhJRCeRGSME/P2vP/NFe5?=
 =?us-ascii?Q?wa8M5W0jQXx7pnzqR06aWLYCxKYHXs+RHRMUPs+GljMZioUxBuV4AXtO72XY?=
 =?us-ascii?Q?MKHIsaP+WuZJxLZtrK4pcrMD82XVFEwOneGUUAcSlrdFkjw2fjfx3b+1h5Jp?=
 =?us-ascii?Q?J/7DTCQxshktg6nBh7h98XucqYw7zPoguLF2X1RPo6NoHmSPNpetPr69VzHI?=
 =?us-ascii?Q?tsyNyewhHGPbMN+JNzjSJ4nqbU8NsGdjDJjzik2hIQqPWkf+ijq/NqNyiPi9?=
 =?us-ascii?Q?aLnQrmuUYtIashQhlDuDUeKUUMj9XAYyRljvAFAQmdSnb0bto2SJXJ8gTahM?=
 =?us-ascii?Q?uKgOqvdMFB6xm15PaeHwmOIQZPM5hR6wYvBKE+6rHUNhRq4whNgROUrtglSt?=
 =?us-ascii?Q?K4iAKbzmMQhXAfGr87l/MoaBGSV9FKXoWSOJUsrC9E/3fKFZdreQKidUoQNa?=
 =?us-ascii?Q?/17IK74yJ4kO8gYE4qYI27EmLkZjXnPY/FeiQ85pHUiNvH6IJMTEd33TUBB5?=
 =?us-ascii?Q?IPQyFkn143Dy6HuvR6V1MnqSMW7l6xqEDBBKYYIqCf257v+9WmjBQ5zt+N/M?=
 =?us-ascii?Q?rOPJ1AanHpxzA81h19uiKTQAUUoA07xwsvSr1FurtFMo0QACFLps+Q8fzoV4?=
 =?us-ascii?Q?HbC491kM0MFqM0VPLORWjfEtf1HavgQ7oXt2QB1KcoBPVJ/v77zvM70uZS0b?=
 =?us-ascii?Q?H+98pegVenO6Njd9iZzDpT+/2Qkwr/IMvZA2YgQ7zeHujYv5wwT0Xl2425pk?=
 =?us-ascii?Q?cG1KumUwkL5KBYd4CnDYq9rxLZGPH0RByo0ctQjsk8vFiXC7mtk+/gbhgNbm?=
 =?us-ascii?Q?YENmwKweo0H8Su7pam6oy3Pv7DhxUWOrhghygseawPsRz+BaWHxiEtvxGwm9?=
 =?us-ascii?Q?RWfM8aUZhZVZ+/b5Dl2+BbFWUSiipXUPUux06MUWGuI9XxthpWRgkmTz1ipx?=
 =?us-ascii?Q?KoGGJ7GMVrfUZ9bfLPeWryOz6sShwtJ/WuB9IPDxrrm+rfc6qdiQGP/hHWMt?=
 =?us-ascii?Q?ojroH9A=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2024 12:50:41.7190
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f01aaa1-c603-4710-7b59-08dcdb052acb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E66.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5609

Move the chid.h to nvkm/engine so that vGPU manager support can expose the
routines of allocating CHIDs from the reserved CHID pool to NVIDIA VFIO
module when creating a vGPU.

No function change is intended.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 .../drm/nouveau/include/nvkm/engine/chid.h    | 29 ++++++++++++++++++
 .../gpu/drm/nouveau/nvkm/engine/fifo/chid.h   | 30 +------------------
 2 files changed, 30 insertions(+), 29 deletions(-)
 create mode 100644 drivers/gpu/drm/nouveau/include/nvkm/engine/chid.h

diff --git a/drivers/gpu/drm/nouveau/include/nvkm/engine/chid.h b/drivers/gpu/drm/nouveau/include/nvkm/engine/chid.h
new file mode 100644
index 000000000000..b9e507af6725
--- /dev/null
+++ b/drivers/gpu/drm/nouveau/include/nvkm/engine/chid.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: MIT */
+#ifndef __NVKM_CHID_H__
+#define __NVKM_CHID_H__
+#include <core/event.h>
+
+struct nvkm_chid {
+	struct kref kref;
+	int nr;
+	u32 mask;
+
+	struct nvkm_event event;
+
+	void **data;
+
+	spinlock_t lock;
+	unsigned long *reserved;
+	unsigned long used[];
+};
+
+int nvkm_chid_new(const struct nvkm_event_func *, struct nvkm_subdev *,
+		  int nr, int first, int count, struct nvkm_chid **pchid);
+struct nvkm_chid *nvkm_chid_ref(struct nvkm_chid *);
+void nvkm_chid_unref(struct nvkm_chid **);
+int nvkm_chid_get(struct nvkm_chid *, void *data);
+void nvkm_chid_put(struct nvkm_chid *, int id, spinlock_t *data_lock);
+int nvkm_chid_reserved_alloc(struct nvkm_chid *chid, int count);
+void nvkm_chid_reserved_free(struct nvkm_chid *chid, int first, int count);
+void nvkm_chid_reserve(struct nvkm_chid *chid, int first, int count);
+#endif
diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/fifo/chid.h b/drivers/gpu/drm/nouveau/nvkm/engine/fifo/chid.h
index b9e507af6725..a9c3e7143165 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/fifo/chid.h
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/fifo/chid.h
@@ -1,29 +1 @@
-/* SPDX-License-Identifier: MIT */
-#ifndef __NVKM_CHID_H__
-#define __NVKM_CHID_H__
-#include <core/event.h>
-
-struct nvkm_chid {
-	struct kref kref;
-	int nr;
-	u32 mask;
-
-	struct nvkm_event event;
-
-	void **data;
-
-	spinlock_t lock;
-	unsigned long *reserved;
-	unsigned long used[];
-};
-
-int nvkm_chid_new(const struct nvkm_event_func *, struct nvkm_subdev *,
-		  int nr, int first, int count, struct nvkm_chid **pchid);
-struct nvkm_chid *nvkm_chid_ref(struct nvkm_chid *);
-void nvkm_chid_unref(struct nvkm_chid **);
-int nvkm_chid_get(struct nvkm_chid *, void *data);
-void nvkm_chid_put(struct nvkm_chid *, int id, spinlock_t *data_lock);
-int nvkm_chid_reserved_alloc(struct nvkm_chid *chid, int count);
-void nvkm_chid_reserved_free(struct nvkm_chid *chid, int first, int count);
-void nvkm_chid_reserve(struct nvkm_chid *chid, int first, int count);
-#endif
+#include <engine/chid.h>
-- 
2.34.1


