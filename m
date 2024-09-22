Return-Path: <kvm+bounces-27255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6589B97E1A9
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 14:51:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C3BE5B210EB
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 12:51:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA2811A28D;
	Sun, 22 Sep 2024 12:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Qkc2tjEG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2066.outbound.protection.outlook.com [40.107.244.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7346111C83
	for <kvm@vger.kernel.org>; Sun, 22 Sep 2024 12:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727009444; cv=fail; b=aHyfgHbduR1ym7mxavBGPMS2sbvi5FOL7F9aKaCJ4bqo6xScRY3InUgjWLcT43g7N5E2uVXfMxbl4wp87oPhYzdHMw+Tpxky1LxPVat9jXuaM9m0YuWpMJJrXMTSRdlUPFAQyzNbJPcZU6zmiVaYFm+bkq5/CvLJDQr550qEICA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727009444; c=relaxed/simple;
	bh=Qc/AnBRxZy3jRHJcQjPNk7fWk8ULQqZHo1LMo1YVgXw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=if63rNjJy56LKJUTMb3Zgoy8vZLUrTEH0AHEFA48wAjCzcbKJzJrjfCF0aB1qjxyzgkZcQ7RLjVVX0E4aCMYqfPZcfdh1WfVLdiEBdv4g5+x5UHx4qkBmNP18t51hoK98YBdYEqp4RT0J4+/t26/EbkPCFz1uqVkR+erRrdgCZA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Qkc2tjEG; arc=fail smtp.client-ip=40.107.244.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nvs7OFzYaSQk9o6n7nYhRP2zP70HaxvtXOCgHpKjUYazRmNaCozvgW8/YaHXoSuEWYCiAwVubMOgzpWSt4ZWl01c4Ew9Nivg2/cru7Udv5Z56MHd4l4/bUl/TEgfZGtFSYXVi6nJJi0qy1rhCLdFjGlZ/xlBTIoXAHDiXNCpRqaAmB67m0UqQHs00QOxYBhV6BAEa0WVATKXcRJU0h+5DzMsG+RDRIzYstYMCsublWrAxOzJ/GHRHkceUuj9Bkpi8Of8/SFlNsAGRSpu/uwSNOuckLG2S1Pf2oWXwCSko2DyeSiKU9+BtlYylu7sAtzMyTtZ+De4l0Y5pziCK8T4qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2vAXGW5UV/Bo3oTah6m0M6cPCsVTL0kinpOCmvs4hZw=;
 b=rrSpznPubRPYxq7Vj7aV6sVRwGbKZ+6Xw9031jWDxhNQ9+p9cCo+5OBCw0cUPaBUlEhDUmoHwcolvue9uc9xo4v6aMs5SmiJmpfp+spvP3aavMSCT1I5sDC5bTTR7l5x7eBfUyKk3JFmtGN7vO7K/STVb8suIfXTU1kzzRcG0LPKV4pbKu0U3JEgzNOAqbPse1O8znZ6mJ+oIm1XFC9J8riYRt2kVaVpvAdfEzqKzHVv9JdfGJ47RtmiFw2fEWXO4gdBoQEdrbjIxfddx2dXcGB6uR7rB14BEdixfQ6RXvCtdrPcJR/wNDh41na1l4tZ8L1A+o+fHPYkSdvQW76cbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2vAXGW5UV/Bo3oTah6m0M6cPCsVTL0kinpOCmvs4hZw=;
 b=Qkc2tjEGMW/OZw5AQ91yvUq0fikkIourXM4LCFqKQ+eHaneUhdpMfg3JhzniL5vgWfctycCx0lu9ve09l+mnpUTb6KgovqYMbbQu0BPAV4HPyGV5VshFCg7l2s4yXoOBhQ2EiqOIVypYtyZgEkFZJxHJTNVQ3qZLXZUai/4uwVrhSNgO3sQsPUGGGj4fJer/8kDg9jT+zk+tPGf0ENILdxn778ptxCxsuao02Yioum6SqaD4luhpyZ/jQu9UZJdSM1XKWG5usuUK+T8L6RYaWgk9IBWNZmLpSIm+RmFdtYnB2C7RY+WqFxhgyrB9JuPGxXoIBNd1qYA+f4sgk8wrBA==
Received: from MW4PR04CA0329.namprd04.prod.outlook.com (2603:10b6:303:82::34)
 by MN0PR12MB6176.namprd12.prod.outlook.com (2603:10b6:208:3c3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.23; Sun, 22 Sep
 2024 12:50:36 +0000
Received: from CO1PEPF000075ED.namprd03.prod.outlook.com
 (2603:10b6:303:82:cafe::d3) by MW4PR04CA0329.outlook.office365.com
 (2603:10b6:303:82::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.30 via Frontend
 Transport; Sun, 22 Sep 2024 12:50:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1PEPF000075ED.mail.protection.outlook.com (10.167.249.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Sun, 22 Sep 2024 12:50:35 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 22 Sep
 2024 05:50:25 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Sun, 22 Sep 2024 05:50:25 -0700
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
Subject: [RFC 09/29] nvkm/vgpu: introduce the reserved channel allocator
Date: Sun, 22 Sep 2024 05:49:31 -0700
Message-ID: <20240922124951.1946072-10-zhiw@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000075ED:EE_|MN0PR12MB6176:EE_
X-MS-Office365-Filtering-Correlation-Id: bd1abda6-538a-47f4-d76b-08dcdb052721
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8QGZz4p4dzFDlKIaQ2ZQBOwhpbhVdRY//wzAgCz+jxDR8LFVhre/HbHQ6RLO?=
 =?us-ascii?Q?dhfE0QcQwjCH78LrPFlbb/pgQh+P1vtO/fuOYiLUfeNNRSAi2y1J/qNhydDi?=
 =?us-ascii?Q?dbiOHkgWuyKou85VdpLaRyYIERDh9OcLRy4zoXrt5xfvjGP1X91osoUmxzEg?=
 =?us-ascii?Q?1YlYVynaPnlT/xSRy1UQqTA2NyL/r5UEWRwcGgox9PTJVuDLm3nNq+6jIX3x?=
 =?us-ascii?Q?nQgLDMXXWMnuEl6hLBtCHVBkkmO9AKA4OGhildlpZozfSzKBPTGI6fBmW8T3?=
 =?us-ascii?Q?F+LFF2CYNMDEU8XofddJVXHQzTgezNmFxpoqssM59B/2zoQQqGlXtE+yYVXF?=
 =?us-ascii?Q?A9nRs0QhBvVcN9s0TtQ+Skb3A6wB+s8SU4PsvqGxIyjiDiTSVeNX2moATaX2?=
 =?us-ascii?Q?SOkF0E1sxKmih3b/ZQ0M9xDI5GRRbwahuBscLu10PAZFZnlCMVFURF+EfCMA?=
 =?us-ascii?Q?6wnm3DctX7ghiDeb8E7tobxGwZYUlZsTE++jJoMhVWq1IFdaAzNbbgc6EzUi?=
 =?us-ascii?Q?lz9CR/9xlr8446tQWv7TBoSJTD1vEX898XRJjVJr0jJ2QPBHevWNz0kl50md?=
 =?us-ascii?Q?zzSbm4HNM7jvMJhU6Rm1E9Mo/a4XyaXmCfwk+2JkAV0FkePNArdjCuG2vQLR?=
 =?us-ascii?Q?pdEMVylUkPqXMtd6UIYhS6oc4CEnbtqheTF2rG6GZLh2Y73LCVECdtPw7FQs?=
 =?us-ascii?Q?LQmM9ajYYmL8aZxMzZN481Iw62nz2qot0O6urdKh96ko3CKYMGwz+30rMiyX?=
 =?us-ascii?Q?J+HcjzWgZZCRi5CW+hpiqmINDirSJswIRKrvMgb7HCKL+KpmLGdzQwSZGp+1?=
 =?us-ascii?Q?k0+15xOKQzKM1b+gj6obdueW3hJ3HKHSX0fpUYwZpoPmapJQ23NTsFp82M3G?=
 =?us-ascii?Q?dmgGYbIfw2XS3cssJmasBQBfXKd4xpQ5Q4Eww81sTGgs48a/uOC0wJz733O7?=
 =?us-ascii?Q?ZFRgj+ih2Y8sBnB6Q0x0LJEsGhjZAOhScJNw5oY4CHSy9SXPp+eB/LT0QjUJ?=
 =?us-ascii?Q?MHDUuKMV3wUi5al7uNcBrj9Ej74STx2vTI+beiq9WTPO2YXaaGRykxH+lYTI?=
 =?us-ascii?Q?kHjFsapQjQaSxYDOBvjX8PRBB7O0L43xi8ysEUa4Wf2yZx3fBlhNFTC6VZ+a?=
 =?us-ascii?Q?qMecjF0ZoUCp4HnKRdzgBcXyUq5pZpHl7yimAi4PM0fdRCO58swFUMjrd10l?=
 =?us-ascii?Q?kvLM/SBI5A5eQNw418W5htIz6er6ruKjWwjrHElbDAW7B/TALHDbl/OuwBJX?=
 =?us-ascii?Q?/EpB+GlYYYtxJwLZKM8oL2S4pp4oENn2+ZphtyQW3HoMlfYl2rTOjI0v7JKH?=
 =?us-ascii?Q?x6MmTLbbjzLVL6sOONhqEobQSRJ8VpIN9r64ZVpUadfqF6YPORgLxwhZflHW?=
 =?us-ascii?Q?QrXRY2Vh1ZRCgpH6PHy2owZlpOJ6MLn3XzOnXhPk2yQdHF2GXqjJh/FKvu2i?=
 =?us-ascii?Q?wjHpIKcRAElaLuc9V0d6JcGDYbrYt8N8?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2024 12:50:35.6835
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bd1abda6-538a-47f4-d76b-08dcdb052721
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075ED.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6176

Creating a vGPU requires a dedicated portion of the channels.

As nvkm manages all the channels, the vGPU host needs to reserve the
channels from nvkm when vGPU is enabled, and allocate the reserved
channels from the reserved channel pool when creating vGPUs.

Introduce a simple reserved channel allocator. Reserve 1536 channels for
vGPUs from nvkm and leave 512 CHIDs for nvkm when vGPU is enabled.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 .../gpu/drm/nouveau/nvkm/engine/fifo/chid.c   | 49 ++++++++++++++++++-
 .../gpu/drm/nouveau/nvkm/engine/fifo/chid.h   |  4 ++
 .../gpu/drm/nouveau/nvkm/engine/fifo/r535.c   |  3 ++
 3 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/fifo/chid.c b/drivers/gpu/drm/nouveau/nvkm/engine/fifo/chid.c
index 23944d95efd5..0328ee9386d4 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/fifo/chid.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/fifo/chid.c
@@ -89,13 +89,14 @@ nvkm_chid_new(const struct nvkm_event_func *func, struct nvkm_subdev *subdev,
 	struct nvkm_chid *chid;
 	int id;
 
-	if (!(chid = *pchid = kzalloc(struct_size(chid, used, nr), GFP_KERNEL)))
+	if (!(chid = *pchid = kzalloc(struct_size(chid, used, 2 * nr), GFP_KERNEL)))
 		return -ENOMEM;
 
 	kref_init(&chid->kref);
 	chid->nr = nr;
 	chid->mask = chid->nr - 1;
 	spin_lock_init(&chid->lock);
+	chid->reserved = chid->used + nr;
 
 	if (!(chid->data = kvzalloc(sizeof(*chid->data) * nr, GFP_KERNEL))) {
 		nvkm_chid_unref(pchid);
@@ -109,3 +110,49 @@ nvkm_chid_new(const struct nvkm_event_func *func, struct nvkm_subdev *subdev,
 
 	return nvkm_event_init(func, subdev, 1, nr, &chid->event);
 }
+
+void
+nvkm_chid_reserved_free(struct nvkm_chid *chid, int first, int count)
+{
+	int id;
+
+	for (id = first; id < count; id++)
+		__clear_bit(id, chid->reserved);
+}
+
+int
+nvkm_chid_reserved_alloc(struct nvkm_chid *chid, int count)
+{
+	int id, start, end;
+
+	start = end = 0;
+
+	while (start != chid->nr) {
+		start = find_next_zero_bit(chid->reserved, chid->nr, end);
+		end = find_next_bit(chid->reserved, chid->nr, start);
+
+		if (end - start >= count) {
+			for (id = start; id < start + count; id++)
+				__set_bit(id, chid->reserved);
+			return start;
+		}
+	}
+
+	return -1;
+}
+
+void
+nvkm_chid_reserve(struct nvkm_chid *chid, int first, int count)
+{
+	int id;
+
+	if (WARN_ON(first + count - 1 >= chid->nr))
+		return;
+
+	for (id = 0; id < first; id++)
+		__set_bit(id, chid->reserved);
+	for (id = first + count; id < chid->nr; id++)
+		__set_bit(id, chid->reserved);
+	for (id = first; id < count; id++)
+		__set_bit(id, chid->used);
+}
diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/fifo/chid.h b/drivers/gpu/drm/nouveau/nvkm/engine/fifo/chid.h
index 2a42efb18401..b9e507af6725 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/fifo/chid.h
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/fifo/chid.h
@@ -13,6 +13,7 @@ struct nvkm_chid {
 	void **data;
 
 	spinlock_t lock;
+	unsigned long *reserved;
 	unsigned long used[];
 };
 
@@ -22,4 +23,7 @@ struct nvkm_chid *nvkm_chid_ref(struct nvkm_chid *);
 void nvkm_chid_unref(struct nvkm_chid **);
 int nvkm_chid_get(struct nvkm_chid *, void *data);
 void nvkm_chid_put(struct nvkm_chid *, int id, spinlock_t *data_lock);
+int nvkm_chid_reserved_alloc(struct nvkm_chid *chid, int count);
+void nvkm_chid_reserved_free(struct nvkm_chid *chid, int first, int count);
+void nvkm_chid_reserve(struct nvkm_chid *chid, int first, int count);
 #endif
diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/fifo/r535.c b/drivers/gpu/drm/nouveau/nvkm/engine/fifo/r535.c
index 3454c7d29502..4c18dc1060fc 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/fifo/r535.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/fifo/r535.c
@@ -548,6 +548,9 @@ r535_fifo_runl_ctor(struct nvkm_fifo *fifo)
 	    (ret = nvkm_chid_new(&nvkm_chan_event, subdev, chids, 0, chids, &fifo->chid)))
 		return ret;
 
+	if (nvkm_vgpu_mgr_is_supported(subdev->device))
+		nvkm_chid_reserve(fifo->chid, 512, 1536);
+
 	ctrl = nvkm_gsp_rm_ctrl_rd(&gsp->internal.device.subdevice,
 				   NV2080_CTRL_CMD_FIFO_GET_DEVICE_INFO_TABLE, sizeof(*ctrl));
 	if (WARN_ON(IS_ERR(ctrl)))
-- 
2.34.1


