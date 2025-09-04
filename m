Return-Path: <kvm+bounces-56727-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E83A8B430D6
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 06:09:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E1F77C0EA0
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 04:09:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6364924C077;
	Thu,  4 Sep 2025 04:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SE1VK2nR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2056.outbound.protection.outlook.com [40.107.223.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA25239581;
	Thu,  4 Sep 2025 04:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756958923; cv=fail; b=uJligAboYcRN8D8vva5DOJiTZ52f7wYnYxOUcct86t3tKeF/djMKsTGK7K7v6GeAMSna2WnRmt+1CCQUn1CiZYFEeGbdcUkfG/N5rGf92yC9h5QUiOTW3/TnygPi6k47nUZ36DIWsmJVyEXu1iYaSX47/wX5GjxUxeS1GXz/0OQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756958923; c=relaxed/simple;
	bh=ysV5ybT/1AWol/nFCUbNJNxibO16gNpf4s8q8lgO/So=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IBEDe3Nc8w1tjbLvak5CgbtRiwJbFFK1/1J7sm73cOZp0qEvuJu8ofjTb7cNuaucyeWGbvpHOu8PaR/WjdTw8eKpokwRcs7edioeswWuT9lcOZBEZ3bse6AXdxHig7hBvBgPe0/k0Tor/8FwkTG378Tb0QrNWpdoPN86X67uB6k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SE1VK2nR; arc=fail smtp.client-ip=40.107.223.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jbVDZfGcpFrBVYk/PCGUvLzrdXpvPuqDGqha55HSmkpfxbQZf93lt6xtSRDnZlt2QGqOkyQv78/kXyqszQPXt84/3Oh+S3YLITDWWUxFwtp/FvOPu4DdupDt8o7mDwLvPdzQmJRa4JUG1UrgWYnRXxxmns1Qlh7N0KH5SEHBX3927t0NBTs15A2aE2KmnPozg2BonqkKoPDckMCg++YLJS53Ix1ht/ApbhQ0LI3n/2WY806ZZZYd9fBmPT4O7np9IQhvT78RYPp11hS4f4Cjgcuoj1RqRzNqI+SWAjjkGCtiU9yL25zN/hZNFloOfl7BOtIScXtw0R8IIkhJYFsIcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o0MxRJ/98ZtJsBvBcruUvEwBhh8pH/DfOIE+XeP51Nk=;
 b=QFONrBHwtZVe2VXDwhzK1Kv8ZzpOrdjsQduTQjzQlpweeOE26HZ70B9duou7CytyuuDaaaPQJnFmZVdE9EN/fkzDFsin3th8aIms56LH6LL0yyWdrFLHDv5FaNV3p4kArwf2xIEgyDcqdVTk/UTF0yFcw0rDFG/zTChoyV/lIjQEHoSAtSpkKeVzHVzT95h/CmsLfERhGeB9FEEg+X9yAbqavuLIABYLSS1nFB3WoI8yRh7S0wF5WrnVB6JIUQwbITC3nREHCjzOdiL1bWJ9ui9T02b+w/mwSXEZw+q7fgYHvFnQ/BvD4ygZwbyE9qD54GgxIjV/LAIXcRo99NxC+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o0MxRJ/98ZtJsBvBcruUvEwBhh8pH/DfOIE+XeP51Nk=;
 b=SE1VK2nRlUxU8BZKYJ/lS0NTSbs09QZLmKDKsLsjbWfU2W/NxLT9gmI6xUIXYirSNtyr6kW7GuhdeULpor0EnbedMTA5rILC5kfwkZDaQXd1IYK6y6+kbnq2W54gGRraiRJ/6z+1j1EoqBO5sPwQVvqUI1voIuqOAvfbyiYiOyeo0ATrRW8l9M/D9EyURLDx9Yrbe9jhP2S/Fh4ylrP+LnzNDhZZpAp0TW/mxX8AG8xMFPYUKG9FYWzLrwPVle65Eub7+Jnb5rII7LbbClbF4cm8x/2DnT6jGoCGNqPuUsuctqHRvVpQHDEjmck29CQSRa4RkSxTvad7l3fRKWW3Sw==
Received: from SA1PR03CA0005.namprd03.prod.outlook.com (2603:10b6:806:2d3::6)
 by BN3PR12MB9570.namprd12.prod.outlook.com (2603:10b6:408:2ca::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Thu, 4 Sep
 2025 04:08:37 +0000
Received: from SN1PEPF000252A2.namprd05.prod.outlook.com
 (2603:10b6:806:2d3:cafe::25) by SA1PR03CA0005.outlook.office365.com
 (2603:10b6:806:2d3::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.19 via Frontend Transport; Thu,
 4 Sep 2025 04:08:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SN1PEPF000252A2.mail.protection.outlook.com (10.167.242.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.14 via Frontend Transport; Thu, 4 Sep 2025 04:08:36 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 21:08:30 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 3 Sep 2025 21:08:30 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 3 Sep 2025 21:08:30 -0700
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <skolothumtho@nvidia.com>, <kevin.tian@intel.com>,
	<yi.l.liu@intel.com>, <zhiw@nvidia.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kjaju@nvidia.com>,
	<dnigam@nvidia.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC 03/14] vfio/nvgrace-gpu: track GPUs associated with the EGM regions
Date: Thu, 4 Sep 2025 04:08:17 +0000
Message-ID: <20250904040828.319452-4-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250904040828.319452-1-ankita@nvidia.com>
References: <20250904040828.319452-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A2:EE_|BN3PR12MB9570:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d4083bd-9667-40f4-7a49-08ddeb68b90a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XLbVvOLcwQRarCBD84s7BJOelvjtL9ayeB/r26B+LtLmiADBOcW886cJV/Un?=
 =?us-ascii?Q?bdDUV+kHJfrvxJR3y5LQXTY6Pm9WtZwauSDDRR7CKj6rryA0WJZz52Kd1EJd?=
 =?us-ascii?Q?C+13jhoHU8lLIHMqt/71EC13M7LFkEBUOjreJuwiaH3SjH2WnqrZQMcsZxHX?=
 =?us-ascii?Q?r4pJMWAACXgNWmJ6vLwnsj6ZD7ojYb5DJ5F5MgN3ohAOYzm9TLQn8XpGfHRI?=
 =?us-ascii?Q?QeYnsqdAzQ6tehdL57WPNlGz5J4fmWj2XioCEa+xQHSrvUF0TD9RcHc0R4wR?=
 =?us-ascii?Q?EXJvJR2a8fB+w+Ik7UOZIKUW0ajDU8X1nnXlRs0i5A9bGbQoHRBfi/7IzvUB?=
 =?us-ascii?Q?Svy3a8TWCv4MtaZx7IX2V7XSfOw6f2j1exv+Ol3VVDEqlTZxklyvtXhCnR7a?=
 =?us-ascii?Q?LjU0wD9/Hac+4uYR0jPQwLp8/ONb8WRinhOBd4mgVV7z9G6wugJiOUu/exJJ?=
 =?us-ascii?Q?A3VBVDtXMtzHXqaSCIqhwg7zUwNvAY0Pi/VHMNGE3t2sudqWlxsSBihDuXwp?=
 =?us-ascii?Q?5DgWZra+4BMaRL97Htz1i8pvrYpQKtuFbxiwVGYDj16Ladb1EtW+FRbc6q3V?=
 =?us-ascii?Q?ztb2q8zN3fkwEPGQO4uU51IE4uLiBjXvMWppUmnx3J0Qa93NOWg/RVYxkkQM?=
 =?us-ascii?Q?K97P8y5a3qtDRGb6KeVChEhAKW5Gqht0ZnBr8FHyNiYfQMt6wPnaBDFcfcBN?=
 =?us-ascii?Q?W1/ie7opPrUWiFBOZii1N73GYmYn+TuulH1qgvhE1G0/YJY5M21AT01vv2IZ?=
 =?us-ascii?Q?IJkfDJPDFSPfWC1zZaHofp0ljkEjlAjuf/Rw0drhB12HOOBDg0LuV0XyY32R?=
 =?us-ascii?Q?/nORhkB/ws3BNFNGWZPmMd2hjBdgzpDrFPpxpHe6Cly6JX6WgSFX4NqBUig1?=
 =?us-ascii?Q?yC8NGe3V5QxWXwwZAzATR62k7R9UCvnR7PsCk2D6jE5+gNBakSCmGF0Sfq4w?=
 =?us-ascii?Q?QIUBrxcb+t9t9G3NaYRTgtgEBH45N4rDC33Lr3+YxRWH2hvHMJkPFqmPWIA1?=
 =?us-ascii?Q?ElPkP9WdZpkh0GaomVk4HgvVs4j4fCrK+v9R7DCJALBOTioqdft+NzM/WgFt?=
 =?us-ascii?Q?TaoFZm/lMjaEtW/0+HggrrVUaiDEuTL1dnDAv7qWJfz4TeWtSJidNg9I/cUO?=
 =?us-ascii?Q?02pHLH+FIveACojgm5L8VEtJCjO9+sDsQ+Hqi+vLon2zNciM4KN6k3Qm75eF?=
 =?us-ascii?Q?jfeUqMkZE8jywV6OJe3FB/65CqNK7ukzqXgJsQhyGE2RdMJV3tfeQ/dF9hR7?=
 =?us-ascii?Q?/jNWKP87o/tS06hLaWJA42ueHQbeC5Rcc5YZClVPuov6WnKiKeOTeFe2/gAN?=
 =?us-ascii?Q?pkpQjtTKCunrab8PNzla1evwCcx6Pf4TeMwLL/emxwGzB61VCxJ7y7MgPE3G?=
 =?us-ascii?Q?snUVxGNH66sCwk3nVuFPH5/hyqyso+yrJaQXCanekp2bQSZ9ljMci87CGckq?=
 =?us-ascii?Q?8b0hfZyQ8MfDHC4Ly65dTfhHPmzlHkRoyqIaSkT+qeJJBcn1DVm887trpQRV?=
 =?us-ascii?Q?h3cbetfeA20T5qW4p4+lKEeKWaN9IUzPw4xN?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 04:08:36.8805
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d4083bd-9667-40f4-7a49-08ddeb68b90a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000252A2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR12MB9570

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
 drivers/vfio/pci/nvgrace-gpu/egm_dev.c | 29 ++++++++++++++++++++++
 drivers/vfio/pci/nvgrace-gpu/egm_dev.h |  4 +++
 drivers/vfio/pci/nvgrace-gpu/main.c    | 34 +++++++++++++++++++++++---
 include/linux/nvgrace-egm.h            |  6 +++++
 4 files changed, 70 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/egm_dev.c b/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
index f4e27dadf1ef..28cfd29eda56 100644
--- a/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
+++ b/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
@@ -17,6 +17,33 @@ int nvgrace_gpu_has_egm_property(struct pci_dev *pdev, u64 *pegmpxm)
 					pegmpxm);
 }
 
+int add_gpu(struct nvgrace_egm_dev *egm_dev, struct pci_dev *pdev)
+{
+	struct gpu_node *node;
+
+	node = kvzalloc(sizeof(*node), GFP_KERNEL);
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
+			kvfree(node);
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
index 2cf851492990..436f0ac17332 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -66,9 +66,10 @@ static struct list_head egm_dev_list;
 
 static int nvgrace_gpu_create_egm_aux_device(struct pci_dev *pdev)
 {
-	struct nvgrace_egm_dev_entry *egm_entry;
+	struct nvgrace_egm_dev_entry *egm_entry = NULL;
 	u64 egmpxm;
 	int ret = 0;
+	bool is_new_region = false;
 
 	/*
 	 * EGM is an optional feature enabled in SBIOS. If disabled, there
@@ -79,6 +80,19 @@ static int nvgrace_gpu_create_egm_aux_device(struct pci_dev *pdev)
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
 	egm_entry = kvzalloc(sizeof(*egm_entry), GFP_KERNEL);
 	if (!egm_entry)
 		return -ENOMEM;
@@ -87,13 +101,23 @@ static int nvgrace_gpu_create_egm_aux_device(struct pci_dev *pdev)
 		nvgrace_gpu_create_aux_device(pdev, NVGRACE_EGM_DEV_NAME,
 					      egmpxm);
 	if (!egm_entry->egm_dev) {
-		kvfree(egm_entry);
 		ret = -EINVAL;
+		goto free_egm_entry;
+	}
+
+add_gpu:
+	ret = add_gpu(egm_entry->egm_dev, pdev);
+	if (!ret) {
+		if (is_new_region)
+			list_add_tail(&egm_entry->list, &egm_dev_list);
 		goto exit;
 	}
 
-	list_add_tail(&egm_entry->list, &egm_dev_list);
+	if (is_new_region)
+		auxiliary_device_destroy(&egm_entry->egm_dev->aux_dev);
 
+free_egm_entry:
+	kvfree(egm_entry);
 exit:
 	return ret;
 }
@@ -112,6 +136,10 @@ static void nvgrace_gpu_destroy_egm_aux_device(struct pci_dev *pdev)
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


