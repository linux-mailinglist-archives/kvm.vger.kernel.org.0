Return-Path: <kvm+bounces-27271-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 28BA497E1B9
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 14:53:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C2AE1C20B95
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 12:53:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1E1755886;
	Sun, 22 Sep 2024 12:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CYs0LaXs"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2084.outbound.protection.outlook.com [40.107.237.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA714F602
	for <kvm@vger.kernel.org>; Sun, 22 Sep 2024 12:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727009461; cv=fail; b=UgcI6uhHSbaycV0TkvN4Z1n2ybTyTrLS4lOcuAdCsWw7dtjofXFWcMtkasaJCemE9xtKJA9xRCBI55cSBx4hsuteTVKPCGI/gs8EOp9pqbRQvPn4aX2W6BhpFuMzTxbgZZ5MURayHeWegr9l1o7sCEaLggLNFlIO2JSqBp7k9G0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727009461; c=relaxed/simple;
	bh=3ur1qtjgvQW32sthGgO0x9NgsbMm2aQsXjUqPHHaFI0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hiJ8NZYivEjyNPVTTN2v4EX2N8HJ3f/o/DaLW6HANQaXzvez1E4EMxoXcEOTbd/XyBVbw2RElSrnZkv3Obvq8oaYrFmA938NxgETqUBqoAlTl3DylJtEe76+a9LTClGXTktaSYTDji6VRIdVyT3pm/6me725JWDWeqxP69hzzzw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CYs0LaXs; arc=fail smtp.client-ip=40.107.237.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ut/iK5G1+l/oYPVN7NLjhaZ1t8mhQyE++UyhdaU/NeqjxhWcfYD6DaBIeiKtc199NYcAdJr6YmDfgMOkmg+9JCDkdpohKE4rl1kBgeAFHqk4G0hiihUe0+bNvNd4e95pJ1eh/VXJQ8JGdtFk2murSpQcB0+nlN7EOu7ToLq7Styklgu1c9bFJ2IOqMW46bY5ARuFjz4pmlJcYXPSgcCcD7XFRGrSLAOi5mTymmZq6Ai99sPZknI6AGK5o6VXGAXBd6BmD1mVUb1LeP07c636qr+Qs6ktWLpE95MkxDN8+tyRFX/IpAzuaAuHuUOXtq9UG7KwD17vz/QjRyVE8oRDRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OUpmMuBusD75UIZyyB43ONShs/8YwJi0aW34Di9h4lY=;
 b=jf+7Whsm3xz6fVjt6sD8E0NNE5WbdGdj88UXZ7+Et0TEa9nt2CIavCP9ERZTizJtvyp+62DHofhLW3lu1gEOQqp88mbv6K088DdLUvsxTpTHu5I9GMly/+7gZRQ94FbjDwAVZvqIiNMqyt5nqC9Xrc8GMHHz3TES/VE5VLPPUINttzDMf7ZXVbqcHZ0TMy7lZjvQjMHjI2Ewx5p/990lYQG0ezIpTFCATfRVWvfDEz2cnKUFQZCW9etiqrdzTmPM/l/hjekcnWf+zJ+3mJzK7DgakkIBWxBCKiTAqKcXPoMe1yiVowGy49hAkb33evPBx0r4sG4OvZbJx0Hkn18AUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OUpmMuBusD75UIZyyB43ONShs/8YwJi0aW34Di9h4lY=;
 b=CYs0LaXsyqZYlkhZTjD4Q4kLfqkV65Ct66K6qLwFBTu6HM7gX539XTNabj40XtS5XzD3UlVxpO3ZUuE12JCA5z5Js57cW8QDZr+uiH8aBJZbguxWjYDcopvUV52qddI92zKqJvOEWmW4oCXpAIIBpoqXQPAMtTFnra2l18rJBSnwS2yKsq+5/uniFBrwWowkUpBp9i9hsip+xF2US8O5oAw2Y3wdG5Czdi4cVv6cRZoK9TrkXT8+UGI3JPRDRb1R2eHOXyRZf5MHFZN01vVEreYYBGlmRoSg1Dh2synuwuIg5DJ0YCRQ62bu5LronqFfTdm8yCxHB7Na1x7QBSxPhA==
Received: from BN0PR04CA0138.namprd04.prod.outlook.com (2603:10b6:408:ed::23)
 by DS7PR12MB6285.namprd12.prod.outlook.com (2603:10b6:8:96::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7982.25; Sun, 22 Sep 2024 12:50:55 +0000
Received: from BL6PEPF00020E62.namprd04.prod.outlook.com
 (2603:10b6:408:ed:cafe::55) by BN0PR04CA0138.outlook.office365.com
 (2603:10b6:408:ed::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.27 via Frontend
 Transport; Sun, 22 Sep 2024 12:50:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL6PEPF00020E62.mail.protection.outlook.com (10.167.249.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Sun, 22 Sep 2024 12:50:54 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 22 Sep
 2024 05:50:34 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Sun, 22 Sep 2024 05:50:34 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Sun, 22 Sep 2024 05:50:34 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>, <nouveau@lists.freedesktop.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <acurrid@nvidia.com>,
	<cjia@nvidia.com>, <smitra@nvidia.com>, <ankita@nvidia.com>,
	<aniketa@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC 23/29] vfio/vgpu_mgr: allocate vGPU channels when creating vGPUs
Date: Sun, 22 Sep 2024 05:49:45 -0700
Message-ID: <20240922124951.1946072-24-zhiw@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E62:EE_|DS7PR12MB6285:EE_
X-MS-Office365-Filtering-Correlation-Id: cf5d345e-a600-4fd3-63c7-08dcdb0532a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6PoPsy3NVn0wGMf9Q83167XlrQcMkL2W8JrtoXx0q2sG1PaIF50cmgR3fzQt?=
 =?us-ascii?Q?qXxoPDyvFb7vqZdMIN6Do03IOl9B5rrJXyN4AiTRLg0X7o9jnaivwaXmr5Yf?=
 =?us-ascii?Q?4af4xzeHsPyeCFL6fwRi2kUEOz3XksvMUdQFtOxyrPYEvdMW2G4ugtoDQi0L?=
 =?us-ascii?Q?joZdKISmhzEm4zNRwBvum0b4rymM3ifEhoG/4qqgLLypb7kIh7jBdleUILIL?=
 =?us-ascii?Q?DJYIBspNLzobUI4kU5gqUYAppQrSZjmMtEXg97KqqkcGOQElxA0fJdTxms+F?=
 =?us-ascii?Q?j4nQ6rChKDE3lk3+Th/QNqJeyCTYAvddgQ2/7y8zfjRf4dNtXWRS5jsdF1ai?=
 =?us-ascii?Q?Yii0MruQCJsFIAq+c95dZ1uICeRCUwCT5I+sUQXVIxpbk6ID0/AFc5pvYgBR?=
 =?us-ascii?Q?agAOfyHZhGLHbn2tYXAj5YdUwiWBmvR22ipbLhrAFM6kiuPJrmLEQPxnSHXo?=
 =?us-ascii?Q?Bw0OxL4RxgCWMFS4/9Z2pRkrXLfeSZamTK9ffYW0PCajbTMo7nmq8lLVdvs4?=
 =?us-ascii?Q?PX0IUtvNdo/pu8ecCeL88viNKqd7lFMfw5qSMVOJWM5jvDMreQv/UNWm+Njp?=
 =?us-ascii?Q?VYQZOZkKCYGGhc39mYbbGwjA1n3bKCOryc1Ax3H8B8shiLL77WrLBI/TQtiv?=
 =?us-ascii?Q?sHI5fOgCyWGsEYS3rKpPlj/aJAvR0pcdVEjG/Gz4bjIb9PYbL9lr4mEHxwXs?=
 =?us-ascii?Q?JbMgaTMcpa6ZaYD9MzVEMui6zqFktnVJPfru2J2SH7Qsttl/EsEvJE+eASBx?=
 =?us-ascii?Q?qMrdCkdWUoX40ZktZxVUrI82lfEMvGDDxOHyVZTm9P+al9lUsPXlbkPcTh1A?=
 =?us-ascii?Q?HO17mEmV4zmhjYv9ARqadV05Zg+4amZ8TiXm5T+H1RiICOPIHrQ5PrBlVSJK?=
 =?us-ascii?Q?rMLFoJo7SG0TqM9Uo08mlvi3L9m52yVKC1M2dNp67RGr5Y/wIscXJk0aEl+s?=
 =?us-ascii?Q?UhQSZOWHqLKjCXaCW/Mhu18qCgpr3RUIyIBAGMB/JYTFFjPHoAMAE0XNsxCc?=
 =?us-ascii?Q?ldix9ZSoFJHDPdxrMk5wDtJnIOQIvX98LQNgzi3A7vOvnkurGVs3EfYjh8nL?=
 =?us-ascii?Q?iJ0IJI1Pg3wdPge9cRH4LVNcVYBXup6ysgjHZHps2dRzbZaRB1hero4HHQX0?=
 =?us-ascii?Q?rvgDhWP0oKUZIt3k4wr9mIqs0gRr7EHPM2fNa/aJTqzrS8+ljsmTze0LEHrY?=
 =?us-ascii?Q?iReZfvF3ZlHZpcjao/BvsnQhcIsanSF5eWaodqGg/9KF4bEloQ1ToIiIRY3x?=
 =?us-ascii?Q?4Ztp1Qy1orJ5PMeMjBtIWNF6s5k5Z7TBX2ZOTvE0QxHh9CpuEEWuZPGa2AP1?=
 =?us-ascii?Q?0XipBvZmZkoA2M2u1T0aqm+1kwCts0hYcYnSDVnLRKhmnR4CAXgL2EaByrQo?=
 =?us-ascii?Q?Ggyffm1AU4GSc1fYJ2eUym3S3zeT6WrVqcgPl9bk8+J5H5nR2QJAOtlj1RXr?=
 =?us-ascii?Q?kXv48emuRYf5w1bwSdOGVdh9KrR8UGUk?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2024 12:50:54.9290
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cf5d345e-a600-4fd3-63c7-08dcdb0532a6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E62.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6285

Creating a vGPU requires allocating a portion of the channels from the
reserved channel pool.

Allocate the channels from the reserved channel pool when creating a vGPU.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 drivers/vfio/pci/nvidia-vgpu/nvkm.h     |  6 +++++
 drivers/vfio/pci/nvidia-vgpu/vgpu.c     | 32 +++++++++++++++++++++++++
 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h |  7 ++++++
 3 files changed, 45 insertions(+)

diff --git a/drivers/vfio/pci/nvidia-vgpu/nvkm.h b/drivers/vfio/pci/nvidia-vgpu/nvkm.h
index d3c77d26c734..b95b48edeb03 100644
--- a/drivers/vfio/pci/nvidia-vgpu/nvkm.h
+++ b/drivers/vfio/pci/nvidia-vgpu/nvkm.h
@@ -70,4 +70,10 @@ static inline int nvidia_vgpu_mgr_get_handle(struct pci_dev *pdev,
 #define nvidia_vgpu_mgr_free_fbmem_heap(m, h) \
 	m->handle.ops->free_fbmem(h)
 
+#define nvidia_vgpu_mgr_alloc_chids(m, s) \
+	m->handle.ops->alloc_chids(m->handle.pf_drvdata, s)
+
+#define nvidia_vgpu_mgr_free_chids(m, o, s) \
+	m->handle.ops->free_chids(m->handle.pf_drvdata, o, s)
+
 #endif
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu.c b/drivers/vfio/pci/nvidia-vgpu/vgpu.c
index 54e27823820e..c48c22d8fbb4 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu.c
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu.c
@@ -62,6 +62,31 @@ static int setup_fbmem_heap(struct nvidia_vgpu *vgpu)
 	return 0;
 }
 
+static void clean_chids(struct nvidia_vgpu *vgpu)
+{
+	struct nvidia_vgpu_mgr *vgpu_mgr = vgpu->vgpu_mgr;
+	struct nvidia_vgpu_chid *chid = &vgpu->chid;
+
+	nvidia_vgpu_mgr_free_chids(vgpu_mgr, chid->chid_offset, chid->num_chid);
+}
+
+static int setup_chids(struct nvidia_vgpu *vgpu)
+{
+	struct nvidia_vgpu_mgr *vgpu_mgr = vgpu->vgpu_mgr;
+	struct nvidia_vgpu_chid *chid = &vgpu->chid;
+	int ret;
+
+	ret = nvidia_vgpu_mgr_alloc_chids(vgpu_mgr, 512);
+	if (ret < 0)
+		return ret;
+
+	chid->chid_offset = ret;
+	chid->num_chid = 512;
+	chid->num_plugin_channels = 0;
+
+	return 0;
+}
+
 /**
  * nvidia_vgpu_mgr_destroy_vgpu - destroy a vGPU instance
  * @vgpu: the vGPU instance going to be destroyed.
@@ -73,6 +98,7 @@ int nvidia_vgpu_mgr_destroy_vgpu(struct nvidia_vgpu *vgpu)
 	if (!atomic_cmpxchg(&vgpu->status, 1, 0))
 		return -ENODEV;
 
+	clean_chids(vgpu);
 	clean_fbmem_heap(vgpu);
 	unregister_vgpu(vgpu);
 	return 0;
@@ -109,10 +135,16 @@ int nvidia_vgpu_mgr_create_vgpu(struct nvidia_vgpu *vgpu, u8 *vgpu_type)
 	if (ret)
 		goto err_setup_fbmem_heap;
 
+	ret = setup_chids(vgpu);
+	if (ret)
+		goto err_setup_chids;
+
 	atomic_set(&vgpu->status, 1);
 
 	return 0;
 
+err_setup_chids:
+	clean_fbmem_heap(vgpu);
 err_setup_fbmem_heap:
 	unregister_vgpu(vgpu);
 
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
index 35312d814996..0918823fdde7 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
@@ -15,6 +15,12 @@ struct nvidia_vgpu_info {
 	u32 dbdf;
 };
 
+struct nvidia_vgpu_chid {
+	int chid_offset;
+	int num_chid;
+	int num_plugin_channels;
+};
+
 struct nvidia_vgpu {
 	struct mutex lock;
 	atomic_t status;
@@ -25,6 +31,7 @@ struct nvidia_vgpu {
 	struct nvidia_vgpu_mgr *vgpu_mgr;
 
 	struct nvidia_vgpu_mem *fbmem_heap;
+	struct nvidia_vgpu_chid chid;
 };
 
 struct nvidia_vgpu_mgr {
-- 
2.34.1


