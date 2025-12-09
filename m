Return-Path: <kvm+bounces-65567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 80C86CB0A3D
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 17:53:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id CF443302C6CD
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 16:53:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2724F32B988;
	Tue,  9 Dec 2025 16:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="J2Y/dg/g"
X-Original-To: kvm@vger.kernel.org
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013006.outbound.protection.outlook.com [40.107.201.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7990732ABC5;
	Tue,  9 Dec 2025 16:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765299152; cv=fail; b=PYIHrsQHakRcRCb/lvYYJZp1dFFQT+K6lNeRRfZdDaaqUa+PGE4JMaODeGtRKvM1JX/02VlLqJlx3lbtFTgDpjbZ/oYiEDxApoIyazrzonm9ifmTTjzd3/HK5v3C/NCzLftWTVzfCu2aGu5Tpi5l0xFwYd/wo+DSu4zjSJ9pg8E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765299152; c=relaxed/simple;
	bh=UeyPhrM/WF8/9yddaW0mNMJ87bCij1eS154BdW4Knhc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f6Cn+SdzbeFCmZbohd3gdft/3YGAdX5j/+xE+9RvrZwCc+I+vX1GeikKtJoKXOMdyjm/akjerFfhlPtBvZrfSGTzBVWq7wnQ1X9jcQERUzNWOlsOTlRnj6/SVgbghKbTKQxHmx/xTGV4gWPNjwYbOHj9MLTGK53mgKD0XK1cOgY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=J2Y/dg/g; arc=fail smtp.client-ip=40.107.201.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qvp5cR6PbXi9p/NirNNdmCBNsgEM4bbcwDdArRH+4UNpBbVbn28J2PhtSIhEg0Swe5NYBlZmAVnR/hqpja08xUnNwmQ5dFS2BcVqpccfGcyRUIDjNfqJq+PZB0Ld5eTeBEV26eBOxp7Q4+VmIXbY/fnO8UR5g33sGCg7pVb99g1Uud1bjELaMdr4hUpmsTM7kaHozLdbq/J/KaYFIY9f+irLA2uEDwPoEfttBwJF24zamhmS3DGZdyHLck2ifFJCdmbKp3X0Nu0UpplR67LCmr7/dN9kvgT/oBgEDU+tG8vxRTIs+exDM1N7cuDtDMsYZ0Qyrl6DHPPiPeOzKu6u4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dDNiUao1tvoiy9Me5dv49zj7AHCAFB8aSpXfsP2yHXY=;
 b=UFfbNLlkO3Bw+Gw5BU9D7Gi7PA8uPPmWkBPgGhhCXN97wJ3JI86uVxlNtmdCVciMNIT0g9WOINEBb9cUSB0h8IWFnVglAziMXAO7dkQghdEfTJnf3S3bC8myaxJubIK1Q1wSJC55WRVSZqREbN+yBL3aFrREGW331ln7jVB6xEn2la54mJyeIBdB50X/qpPbadRiyosjsjj7EEjoTGVjCLCkqU2IvtM/nfpH+P+YrBOi+7bDrZ5gZIJeNj5i2N8FKvFdsjze74OZGCkC9foJlyUy9NEXEkJsEhZFGfqq6/SqBzoRgU6VZ+s4SBfl0sInyVKp83sxzurC3DUTLFaLkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dDNiUao1tvoiy9Me5dv49zj7AHCAFB8aSpXfsP2yHXY=;
 b=J2Y/dg/g+Qwjk5dysv3Pvg+66CuK80i9wTE9JomjyVbJSDo+GjPM6hSdsR3qmdl38tc4ctuwzD7n3jJJUFnL8WWUdbPg5gg6Pwtub0feGr/5VZzoGp1f5esn+sIRGkhXFUT7EzwCvgaIKnG91Z4UJYmXjhVI36LAXZZGDOFbvEpL193pn4s8WUWPXq8XG+12z7BKAUoRbvdkx9UnSgjDSUEYgjClXV0qhmblpQ8HQDoVIyENZqmDPkU24jDitjapNnwuvR+ecAMkQn7ADV0s6zFIUGA9u+LFFR2p9J4m8LufieX21rti/zpTEKc7aIFf3ByKITfFrXfV/j7Eyf8x7w==
Received: from BY5PR03CA0019.namprd03.prod.outlook.com (2603:10b6:a03:1e0::29)
 by IA1PR12MB6306.namprd12.prod.outlook.com (2603:10b6:208:3e6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Tue, 9 Dec
 2025 16:52:25 +0000
Received: from SJ1PEPF00002312.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0:cafe::4f) by BY5PR03CA0019.outlook.office365.com
 (2603:10b6:a03:1e0::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.14 via Frontend Transport; Tue,
 9 Dec 2025 16:52:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF00002312.mail.protection.outlook.com (10.167.242.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Tue, 9 Dec 2025 16:52:24 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 9 Dec
 2025 08:51:57 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 9 Dec
 2025 08:51:57 -0800
Received: from nvidia-4028GR-scsim.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 9 Dec 2025 08:51:50 -0800
From: <mhonap@nvidia.com>
To: <aniketa@nvidia.com>, <ankita@nvidia.com>, <alwilliamson@nvidia.com>,
	<vsethi@nvidia.com>, <jgg@nvidia.com>, <mochs@nvidia.com>,
	<skolothumtho@nvidia.com>, <alejandro.lucero-palau@amd.com>,
	<dave@stgolabs.net>, <jonathan.cameron@huawei.com>, <dave.jiang@intel.com>,
	<alison.schofield@intel.com>, <vishal.l.verma@intel.com>,
	<ira.weiny@intel.com>, <dan.j.williams@intel.com>, <jgg@ziepe.ca>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>
CC: <cjia@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <kjaju@nvidia.com>, <linux-kernel@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <kvm@vger.kernel.org>, <mhonap@nvidia.com>
Subject: [RFC v2 09/15] vfio/cxl: introduce vfio_cxl_core_{read, write}()
Date: Tue, 9 Dec 2025 22:20:13 +0530
Message-ID: <20251209165019.2643142-10-mhonap@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251209165019.2643142-1-mhonap@nvidia.com>
References: <20251209165019.2643142-1-mhonap@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002312:EE_|IA1PR12MB6306:EE_
X-MS-Office365-Filtering-Correlation-Id: 62efd164-6433-407f-3f3b-08de37435441
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tPU5Xd8IzMSnBAtzl5xkTn61hxAEfzlHPRmPhEKvCx/NoikzBnXdTlcCN9r8?=
 =?us-ascii?Q?ABgmxbSyXxqe9Y6Tab/5cUzw4LFm8MasdfdvmBGrQkbfVWZd4CWRfrzXLZne?=
 =?us-ascii?Q?sueXIsUmWlQjbBt9/cyExMFDdQV2tG8IVT6vbL2POgetQZwn5SByqJ4O7w8y?=
 =?us-ascii?Q?eyQWasKpPpzKBdzRwsmkJknWGR8oCcfIYuusWVHwcl37xsA3ByHSlOeqIhKg?=
 =?us-ascii?Q?ruOSymlNIWYy1JZV9R8gjHdK/X3XlnxpQbMK/AE4nZdowU+FZUKwyHHHRKzZ?=
 =?us-ascii?Q?ffVRiVLgoaJ9yhAKP3StoXJzKPeGR1KL9nXmGLWIU/p9E11kGKZd1zMNYQVv?=
 =?us-ascii?Q?lPcpDZh8t/V+G2R1P9u1YwwqbH4BV+u41XtiVz/iGc8b8OHLzvc3nzNRFhqj?=
 =?us-ascii?Q?m0jZC4ZMnfUDNMnFVmpDLFw3LLJ7XlRpXuCC2DULfzQIvJduCor9Rq831FZc?=
 =?us-ascii?Q?gZNlZRHoJa8UiTN5taXaUzcIjIHPEvqvpq6ikRXyW7WLIqAFx4JtRyoVMoAb?=
 =?us-ascii?Q?fT7cd4Ua2v3PKdvh8ieVF7H+2RUp6Z0zvRDQc6lk0+nMoJPPUmy80lZBKA99?=
 =?us-ascii?Q?6HhLqBoQ+Qw4ZCCvcMnD4cd/76lG+7PMErYh0xVrZi7OxZ2jUckEYgxr3keS?=
 =?us-ascii?Q?AXgr1g+qstVG5u+tZy+AnpaV5GXHlgGibJDZjdxoMj826EYoc29hr0E2sbmW?=
 =?us-ascii?Q?pwEYbEEau6k42P418e/pQJcR6LRUWJiAVD2xK8CzlIHV13PXeYyV4pRiC3VZ?=
 =?us-ascii?Q?egHuZ16goQJY/CjxwZ7UukH8mH8lTG/CIiEZY0CqGVklB+a6ipkZRBMRI2gk?=
 =?us-ascii?Q?QA5TGbp3WQXTkJAC2qoNLOQb34w+Hv3bow2NfYxOdBIZbt1d+Ub7N467vLlb?=
 =?us-ascii?Q?brUeK3QbBZGnGcLiF0FyqPNwihhMhGVLIFfJwSsjpC3VHNpYaMGbdEQOyfNn?=
 =?us-ascii?Q?ZdKebOGlu4mfDtl9B1p2AMlZrcKWFsZUs7BM4zTox+dIOenA9QUF3B5iqGtM?=
 =?us-ascii?Q?cJEMPPz+a1PehWfApVlb6CvrzuRCnkwTuL93ql6B/9/rDo+AEOLoX68O+5Cz?=
 =?us-ascii?Q?J2dOBZGJyvI8IGecbrEvgTodhaFfp/gMigaYZ6qha9EEqaou2SBLXYWpfaAV?=
 =?us-ascii?Q?kiCAys18ZmCpbIf8izdjJTsRTEcNqoJoG8Vwbysg/0d4L/wXghPL912GL9e7?=
 =?us-ascii?Q?V6+f7mSMSSZcBb1KX67cFbbCxHmw31hJ1t9DsqtIXo09ctWrYo4Qieew/Ja8?=
 =?us-ascii?Q?rrHCRPqTD/aqQ0hjwEIGWBcItquGeshCFX7wJHoJ52v4TZjUvauDAmLqT/nS?=
 =?us-ascii?Q?pesgZvXvVTZ4xgjonZak7BqF3fWGtC9jgU12/JdyD57Azo2a6xc7EoCzxnBs?=
 =?us-ascii?Q?f8/JUgvG+x1q8mC9LUL2RqNeoyYnzX3Oa7ycTz8bb9J73iBd0+WKOJaOpzIN?=
 =?us-ascii?Q?N0+cJ+w3v7YSJR1Uc5OeMGiBJ3eK96/TjUL7fSPUW6H0jYe4TojULHlyADs9?=
 =?us-ascii?Q?i6+gik9y0RQftw8v1al9vgzd0Xn42NbjrutqDqcDVAzS+c18wK+8l9gzT97E?=
 =?us-ascii?Q?E7xpuNAcYueDIAOiag7mSUiPeT5Fh9PWQgjZuVZY?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 16:52:24.7805
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 62efd164-6433-407f-3f3b-08de37435441
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002312.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6306

From: Zhi Wang <zhiw@nvidia.com>

The read/write callbacks in vfio_device_ops is for accessing the device
when mmap is not support. It is also used for VFIO variant driver to
emulate the device registers.

CXL spec illusrates the standard programming interface, part of them
are MMIO registers sit in a PCI BAR. Some of them are emulated when
passing the CXL type-2 device to the VM. E.g. HDM decoder registers are
emulated.

Introduce vfio_cxl_core_{read, write}() in the vfio-cxl-core to prepare
for emulating the CXL MMIO registers in the PCI BAR.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
Signed-off-by: Manish Honap <mhonap@nvidia.com>
---
 drivers/vfio/pci/vfio_cxl_core.c | 20 ++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_core.c |  5 +++--
 include/linux/vfio_pci_core.h    |  6 ++++++
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_cxl_core.c b/drivers/vfio/pci/vfio_cxl_core.c
index 099d35866a39..460f1ee910af 100644
--- a/drivers/vfio/pci/vfio_cxl_core.c
+++ b/drivers/vfio/pci/vfio_cxl_core.c
@@ -378,6 +378,26 @@ void vfio_cxl_core_unregister_cxl_region(struct vfio_cxl_core_device *cxl)
 }
 EXPORT_SYMBOL_GPL(vfio_cxl_core_unregister_cxl_region);
 
+ssize_t vfio_cxl_core_read(struct vfio_device *core_vdev, char __user *buf,
+			   size_t count, loff_t *ppos)
+{
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+
+	return vfio_pci_rw(vdev, buf, count, ppos, false);
+}
+EXPORT_SYMBOL_GPL(vfio_cxl_core_read);
+
+ssize_t vfio_cxl_core_write(struct vfio_device *core_vdev, const char __user *buf,
+			    size_t count, loff_t *ppos)
+{
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+
+	return vfio_pci_rw(vdev, (char __user *)buf, count, ppos, true);
+}
+EXPORT_SYMBOL_GPL(vfio_cxl_core_write);
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index c0695b5db66d..502880e927fc 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1520,8 +1520,8 @@ int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_ioctl_feature);
 
-static ssize_t vfio_pci_rw(struct vfio_pci_core_device *vdev, char __user *buf,
-			   size_t count, loff_t *ppos, bool iswrite)
+ssize_t vfio_pci_rw(struct vfio_pci_core_device *vdev, char __user *buf,
+		    size_t count, loff_t *ppos, bool iswrite)
 {
 	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
 	int ret;
@@ -1566,6 +1566,7 @@ static ssize_t vfio_pci_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 	pm_runtime_put(&vdev->pdev->dev);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_rw);
 
 ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
 		size_t count, loff_t *ppos)
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 7237fcaecbb6..a6885b48f26f 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -153,6 +153,8 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 		unsigned long arg);
 int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
 				void __user *arg, size_t argsz);
+ssize_t vfio_pci_rw(struct vfio_pci_core_device *vdev, char __user *buf,
+		    size_t count, loff_t *ppos, bool iswrite);
 ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
 		size_t count, loff_t *ppos);
 ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *buf,
@@ -216,5 +218,9 @@ int vfio_cxl_core_create_cxl_region(struct vfio_cxl_core_device *cxl, u64 size);
 void vfio_cxl_core_destroy_cxl_region(struct vfio_cxl_core_device *cxl);
 int vfio_cxl_core_register_cxl_region(struct vfio_cxl_core_device *cxl);
 void vfio_cxl_core_unregister_cxl_region(struct vfio_cxl_core_device *cxl);
+ssize_t vfio_cxl_core_read(struct vfio_device *core_vdev, char __user *buf,
+			   size_t count, loff_t *ppos);
+ssize_t vfio_cxl_core_write(struct vfio_device *core_vdev, const char __user *buf,
+			    size_t count, loff_t *ppos);
 
 #endif /* VFIO_PCI_CORE_H */
-- 
2.25.1


