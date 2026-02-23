Return-Path: <kvm+bounces-71479-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SJQTKdx4nGlfIAQAu9opvQ
	(envelope-from <kvm+bounces-71479-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 16:57:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 084551792F2
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 16:57:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E753A30D1582
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 15:56:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 211C530C606;
	Mon, 23 Feb 2026 15:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gMeitxXw"
X-Original-To: kvm@vger.kernel.org
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013051.outbound.protection.outlook.com [40.107.201.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A14922258C;
	Mon, 23 Feb 2026 15:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771862141; cv=fail; b=RK5VW9Vuy+w4PzeGVdAXMZJfH/1N/S2u2FwHsB+/I6Xkpe9uHTMdo3Y2XdydbF+O82dyAFFhw9kX4msVdCmhmB2LrqVi9brILjRAZOe6tpuFdtxAjChGlpbvJ0/oELn1CHfROO4o9somX9twve5om4rMLkqPDcJkGC3UkcIDNxg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771862141; c=relaxed/simple;
	bh=1tRSaDJxDXlWaH50xDQocNfJh2OXlHOu1F/uBJt/28o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I9/qeewztFrDtKMS5gjXqbl6KbPJ6L4h+btpBQvez9ai39w8DbLsJTNVLoe4l3SHc0P7jnZ6c3waZbo2hlRatFp/OZdUtMoZ+jmxPvhS7KaSG7c2e2v2a3cA/x6Z2qDtpyIR8X+2slVNAo9e0S4R2wiFa2v+tzoVYjOhAjphvJs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gMeitxXw; arc=fail smtp.client-ip=40.107.201.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OjmespkPCtRahzZ25IIXmJIjEnd6B1FxAv4/HUvxUU1CL+U3TBH8EaMhFGQHeAGbfmWy/GLi4EbRoR+u0LoMA83gHbsl0XO8ERKXeyi1n3Tbgrc0p1aVrCVmwrP7eGTZEwDG41KHwj7MDBLBI9hsz2cjGz4NR1TUNl7gIlvb9t2ffFchU5ywxmhPUWNLx/R/YwzSq7RpFD2PxOlfGijVil7B0NRnZPYXoRXVzNki5MhGODexbzp1VhOGvljCkFH1o5ML/VOcsGm19kOibnQdvfpocyoNGsq0g9BtAbdD9lW9zPS0S2YRhKdVDvPU9m70pjc4/GEffBWBdfzPF5ox+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cyiZEjCLFK5HCbJXW61JmcWvQfYKyHqfvmPG8ovdSDM=;
 b=GWlrJ0ocVlJIAGIp7EljTc2Ktb94vcA6dHEESnkKpc2Uz7L1K8Syqb8wmq+8Sy8ack5NrjegrQAkMnc3rCrGFbTkqqk8eBfoBkNrkflUegKaYTnapnyZV4qrVUMDTZ8LEJ+JKbolUgYVCgXXFOYpt0hFDVommo7E2lFjJ3/en5eIggMuw4WzqofIpjN/Vi5v0gMdxjxKabuihg1uQEkl5bgss2eX27qU0+1sacs4Ja39KanJdBSQ6BFd7NVuN0deJkhwqDgmVHgkkI4hRyJ0ko7tKB+dj/Rs8ERUY4WNOPj9wO2NgyzBUSNpiM3Sgk1/uZmEIIVZGmKlkfGsH6gEUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cyiZEjCLFK5HCbJXW61JmcWvQfYKyHqfvmPG8ovdSDM=;
 b=gMeitxXw11m+KmbRNsftRhozrE6AUdUgVAzDyGYWW3OLalP3rnAN9knqF7K/hASuR3GiV6yX7eSCZa7voK6DhtBBk2Q/QIavIYlD2NKApKl/Q7Ak4IM8c8VJ3+EuQbKAVboX5feDw9j7wVl6owwnsjgXtGcThLiM2ed2sT7aK8sqC+Lv8PXs0GAhXCQgQ1sCejxV/zC1i50LKeZMEFIDQtPHVR8jmQTO4fitOCz4cPyvv1Ecalgd4d8i1du7oRh5KD3VhIYj4ze5zlLCOJ9iAh0pa372+eUZ+IEN+lyMEsLoVbMXjYWf7GG0iEPl/y2G+xETJrotRsXGs+hgnvjfew==
Received: from DM5PR08CA0030.namprd08.prod.outlook.com (2603:10b6:4:60::19) by
 DS2PR12MB9637.namprd12.prod.outlook.com (2603:10b6:8:27b::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.21; Mon, 23 Feb 2026 15:55:33 +0000
Received: from DS3PEPF0000C381.namprd04.prod.outlook.com
 (2603:10b6:4:60:cafe::1f) by DM5PR08CA0030.outlook.office365.com
 (2603:10b6:4:60::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.21 via Frontend Transport; Mon,
 23 Feb 2026 15:55:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS3PEPF0000C381.mail.protection.outlook.com (10.167.23.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Mon, 23 Feb 2026 15:55:32 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 23 Feb
 2026 07:55:16 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 23 Feb 2026 07:55:15 -0800
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 23 Feb 2026 07:55:15 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <vsethi@nvidia.com>, <jgg@nvidia.com>,
	<mochs@nvidia.com>, <jgg@ziepe.ca>, <skolothumtho@nvidia.com>,
	<alex@shazbot.org>
CC: <cjia@nvidia.com>, <zhiw@nvidia.com>, <kjaju@nvidia.com>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v2 03/15] vfio/nvgrace-gpu: track GPUs associated with the EGM regions
Date: Mon, 23 Feb 2026 15:55:02 +0000
Message-ID: <20260223155514.152435-4-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260223155514.152435-1-ankita@nvidia.com>
References: <20260223155514.152435-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C381:EE_|DS2PR12MB9637:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ab9ce93-9712-467e-8d08-08de72f3fa09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Mruc+PDF8zUQUA86pMoB2etMkflvhFaJqH55eZ+bMfy5/EGb0MIovgvNCHaV?=
 =?us-ascii?Q?qwCYIq24MU2LsG5Zg0GpT9MVDnvoJd+R+2+/RDag2/wJPEZ7x3PuYhlkMJDq?=
 =?us-ascii?Q?SxtkDWmJTN43lKL1en0W4bCfVMB6EksQIEfungBFGOXQFI8pCwPYquNK5zP6?=
 =?us-ascii?Q?FmJDOyk9nkx1z+r50lhxf9wW/GeeTmxDvI9DS0SvWux68RAOX6yVulVDZtLK?=
 =?us-ascii?Q?nHlJOEoIVlzq92Uf9Zp9B2DUc55UZSfQe66bHzSkqT7oyCYawUyucvRLUlrU?=
 =?us-ascii?Q?k6kSxUmCn5QpCGPVnyPPuD/AYEJZPLHePMNKivawFirvn2kocqoLslcj7r5s?=
 =?us-ascii?Q?6u5c/GxFU+DkHVPtCdIplTHqHoBhBR+tVn+wkcvsWO+PUMHEXr/FwDFiSxOj?=
 =?us-ascii?Q?c/EGivsmrFaCuUkA88HvwsQRhFV/zbagm/ngKzQ31d/DOkj7zGkRGJNoDkMl?=
 =?us-ascii?Q?wq4Bzbn2PIfFuYvRzqq3QfA6S1HO0KFL+lJo0VixoXLL2kaOJ6UnBi+74Obd?=
 =?us-ascii?Q?NqHI03DL6ajBErSVMYpAzEpHJMERJTQK3QVEpFBvrFYkrA7Yc5tVUFS4vt3h?=
 =?us-ascii?Q?5XettBejpBvZD401wYqr8v0tDa5EQHsMjYe9xrCgGHbfvkDaxpgT1EhyXkjD?=
 =?us-ascii?Q?82EQeSK/UiyY1xpM6K+6ERZ5117jXftjMuB3Grl3IIntzGG1FhiN0NgWITBK?=
 =?us-ascii?Q?/dNh0PZebiqV9cHCBT0OdtnPfnK4JkpfQT0dv+uFEkathFiPNApb5eV69Pvk?=
 =?us-ascii?Q?8FuVTzU76wm9b2ccmqgCs7nRnMHBggAHjKfONjqLeJL/CUB41zEWx/hGx1DF?=
 =?us-ascii?Q?SF722IX4ShGlUMhXTTebOr5Z8jmREWl3bw5KLK/W+WA9CkkW3s2y9b5XRQoo?=
 =?us-ascii?Q?kry5brRj3cq6yd8ICkwllvsAT8LBmWm4U3j0G4SYLnysi1SsPqA6BUl1rCF5?=
 =?us-ascii?Q?j+a/dqNfWWU5/SxUs78KN22BEXp3qxPEl/pqzq7IAWp++FovsXBT9KxQOhPB?=
 =?us-ascii?Q?8FonljUg/+m0Owj/Jts0jv2ZKE+8zdzsOFHwWlkw3p8KdQxGZRf7WGwcMltR?=
 =?us-ascii?Q?FvBQvRE86XH9y+26pChN4k8i0H7+miaTb8PaxrZDxgjq7OCDbfR0ETgZefbt?=
 =?us-ascii?Q?V+exejbB7kqHQs3tND+XwwZmDWd2J4/Uf17BboQWOKcdu79U2SC0TyWyNjp3?=
 =?us-ascii?Q?Y2nL+fiW5yJ7lNsd7AOdgj4xNY4PPO0LgmZSriub/anHm607qkRDbiAog3aw?=
 =?us-ascii?Q?f4TpE10TlWPM4D/xHEJEAV1bEvnltdDcOxiasZyMliz6C8Zem/JZRu7l53fG?=
 =?us-ascii?Q?wOD8dvYW5SYU0oj/KEZwVKKuGamWi/3vP+QwkcbjqfFQk05NcD2Xjrqiu39v?=
 =?us-ascii?Q?FNXLVqdQyKDIL9NGB5RHUiVasv6D+QtjHsreZYgWhw9uCJ/fzBHC2pVqBLYU?=
 =?us-ascii?Q?U1WYXcW9yg0PW6F7dFOhYzURMV9b6PDa6/sqS4As5s92F4jcdDy7IqpuNsyB?=
 =?us-ascii?Q?Jb7diHvsT+G156ezNemeEVeCKWbbG2JuWNjjAX2xP4241v7NmDAyeaB5gr5Y?=
 =?us-ascii?Q?sCIYITucdNOEpyJB4qHaamkhzOTUKKXhj4p6St5VYgFXm6dxWNLeJpWCqU2+?=
 =?us-ascii?Q?yn7ZwoGsna9/TDhutO/+BSHp8r9Wb2iRxBop7+nEXiL6UC3Sjb1W7W1Pca0v?=
 =?us-ascii?Q?ghj+EQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ibRp+NS+IGJqdeT0IyFhCQ9SfS4bFk58lA8b0H1djHY8U8ROx4GRgit7es29LJuUU4qtxHRp1zbyAVWbqyvdC9udxtCz3USg4G/0eUpt6x7u+qRP3Bg1qdepwnrDCBQHO+aiFbeEUZgZsD2HAEsFmFQ2nQDrBCwLGOrFyRZDhe+iyZcZXosMnKoRAXyFazdWoQxRrwlH2TKRXzuK1c1O0Q2YkeQddvgNgpNPkM56Y9jeSM7ZMbUawCkz+h7Hwpy5UOpFySr4JP0JM+vjmSVum6F/kqaYLHo2rXBfMYrIb97/mBRmjaaGl3aS85LQpDMxMN8mzo0y+3/ScVHLbnIie6Hu7v26ZtSGbI0aHuxsF7oZclprl60sZS6rsOI5llsT7GyXLwyWjULm5dYdRD+yeW3pr1OZYJz0hoHyhiM4GPqJGa/7lZo43uvXVERS6ljo
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 15:55:32.9361
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ab9ce93-9712-467e-8d08-08de72f3fa09
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C381.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9637
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71479-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	FROM_NO_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ankita@nvidia.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: 084551792F2
X-Rspamd-Action: no action

From: Ankit Agrawal <ankita@nvidia.com>

Grace Blackwell systems could have multiple GPUs on a socket and
thus are associated with the corresponding EGM region for that
socket. Track the GPUs as a list.

On the device probe, the device pci_dev struct is added to a
linked list of the appropriate EGM region.

Similarly on device remove, the pci_dev struct for the GPU
is removed from the EGM region.

Since the GPUs on a socket have the same EGM region, they have
the have the same set of EGM region information. Skip the EGM
region information fetch if already done through a differnt
GPU on the same socket.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/egm_dev.c | 29 ++++++++++++++++++++
 drivers/vfio/pci/nvgrace-gpu/egm_dev.h |  4 +++
 drivers/vfio/pci/nvgrace-gpu/main.c    | 37 +++++++++++++++++++++++---
 include/linux/nvgrace-egm.h            |  6 +++++
 4 files changed, 72 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/egm_dev.c b/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
index faf658723f7a..0bf95688a486 100644
--- a/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
+++ b/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
@@ -17,6 +17,33 @@ int nvgrace_gpu_has_egm_property(struct pci_dev *pdev, u64 *pegmpxm)
 					pegmpxm);
 }
 
+int add_gpu(struct nvgrace_egm_dev *egm_dev, struct pci_dev *pdev)
+{
+	struct gpu_node *node;
+
+	node = kzalloc(sizeof(*node), GFP_KERNEL);
+	if (!node)
+		return -ENOMEM;
+
+	node->pdev = pdev;
+
+	list_add_tail(&node->list, &egm_dev->gpus);
+
+	return 0;
+}
+
+void remove_gpu(struct nvgrace_egm_dev *egm_dev, struct pci_dev *pdev)
+{
+	struct gpu_node *node, *tmp;
+
+	list_for_each_entry_safe(node, tmp, &egm_dev->gpus, list) {
+		if (node->pdev == pdev) {
+			list_del(&node->list);
+			kfree(node);
+		}
+	}
+}
+
 static void nvgrace_gpu_release_aux_device(struct device *device)
 {
 	struct auxiliary_device *aux_dev = container_of(device, struct auxiliary_device, dev);
@@ -37,6 +64,8 @@ nvgrace_gpu_create_aux_device(struct pci_dev *pdev, const char *name,
 		goto create_err;
 
 	egm_dev->egmpxm = egmpxm;
+	INIT_LIST_HEAD(&egm_dev->gpus);
+
 	egm_dev->aux_dev.id = egmpxm;
 	egm_dev->aux_dev.name = name;
 	egm_dev->aux_dev.dev.release = nvgrace_gpu_release_aux_device;
diff --git a/drivers/vfio/pci/nvgrace-gpu/egm_dev.h b/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
index c00f5288f4e7..1635753c9e50 100644
--- a/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
+++ b/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
@@ -10,6 +10,10 @@
 
 int nvgrace_gpu_has_egm_property(struct pci_dev *pdev, u64 *pegmpxm);
 
+int add_gpu(struct nvgrace_egm_dev *egm_dev, struct pci_dev *pdev);
+
+void remove_gpu(struct nvgrace_egm_dev *egm_dev, struct pci_dev *pdev);
+
 struct nvgrace_egm_dev *
 nvgrace_gpu_create_aux_device(struct pci_dev *pdev, const char *name,
 			      u64 egmphys);
diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index 23028e6e7192..3dd0c57e5789 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -77,9 +77,10 @@ static struct list_head egm_dev_list;
 
 static int nvgrace_gpu_create_egm_aux_device(struct pci_dev *pdev)
 {
-	struct nvgrace_egm_dev_entry *egm_entry;
+	struct nvgrace_egm_dev_entry *egm_entry = NULL;
 	u64 egmpxm;
 	int ret = 0;
+	bool is_new_region = false;
 
 	/*
 	 * EGM is an optional feature enabled in SBIOS. If disabled, there
@@ -90,6 +91,19 @@ static int nvgrace_gpu_create_egm_aux_device(struct pci_dev *pdev)
 	if (nvgrace_gpu_has_egm_property(pdev, &egmpxm))
 		goto exit;
 
+	list_for_each_entry(egm_entry, &egm_dev_list, list) {
+		/*
+		 * A system could have multiple GPUs associated with an
+		 * EGM region and will have the same set of EGM region
+		 * information. Skip the EGM region information fetch if
+		 * already done through a differnt GPU on the same socket.
+		 */
+		if (egm_entry->egm_dev->egmpxm == egmpxm)
+			goto add_gpu;
+	}
+
+	is_new_region = true;
+
 	egm_entry = kzalloc(sizeof(*egm_entry), GFP_KERNEL);
 	if (!egm_entry)
 		return -ENOMEM;
@@ -98,13 +112,24 @@ static int nvgrace_gpu_create_egm_aux_device(struct pci_dev *pdev)
 		nvgrace_gpu_create_aux_device(pdev, NVGRACE_EGM_DEV_NAME,
 					      egmpxm);
 	if (!egm_entry->egm_dev) {
-		kvfree(egm_entry);
 		ret = -EINVAL;
-		goto exit;
+		goto free_egm_entry;
 	}
 
-	list_add_tail(&egm_entry->list, &egm_dev_list);
+add_gpu:
+	ret = add_gpu(egm_entry->egm_dev, pdev);
+	if (ret)
+		goto free_dev;
 
+	if (is_new_region)
+		list_add_tail(&egm_entry->list, &egm_dev_list);
+	return 0;
+
+free_dev:
+	if (is_new_region)
+		auxiliary_device_destroy(&egm_entry->egm_dev->aux_dev);
+free_egm_entry:
+	kvfree(egm_entry);
 exit:
 	return ret;
 }
@@ -123,6 +148,10 @@ static void nvgrace_gpu_destroy_egm_aux_device(struct pci_dev *pdev)
 		 * device.
 		 */
 		if (egm_entry->egm_dev->egmpxm == egmpxm) {
+			remove_gpu(egm_entry->egm_dev, pdev);
+			if (!list_empty(&egm_entry->egm_dev->gpus))
+				break;
+
 			auxiliary_device_destroy(&egm_entry->egm_dev->aux_dev);
 			list_del(&egm_entry->list);
 			kvfree(egm_entry);
diff --git a/include/linux/nvgrace-egm.h b/include/linux/nvgrace-egm.h
index 9575d4ad4338..e42494a2b1a6 100644
--- a/include/linux/nvgrace-egm.h
+++ b/include/linux/nvgrace-egm.h
@@ -10,9 +10,15 @@
 
 #define NVGRACE_EGM_DEV_NAME "egm"
 
+struct gpu_node {
+	struct list_head list;
+	struct pci_dev *pdev;
+};
+
 struct nvgrace_egm_dev {
 	struct auxiliary_device aux_dev;
 	u64 egmpxm;
+	struct list_head gpus;
 };
 
 struct nvgrace_egm_dev_entry {
-- 
2.34.1


