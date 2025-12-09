Return-Path: <kvm+bounces-65558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 465E4CB0A55
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 17:55:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 39EB130D03E5
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 16:51:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B316B329E48;
	Tue,  9 Dec 2025 16:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TPfq5K47"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010024.outbound.protection.outlook.com [52.101.46.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B46D3002A9;
	Tue,  9 Dec 2025 16:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765299077; cv=fail; b=sdtzpWkG+r4VqY53xzWS2CHEes1Pb6X2gImVqRkxYwVvvz40FBy6ZFpiMY4zOQtB3W31lehDL5xLr4UMLqxgM9eHz88s0j74JAMgH9o/PxskrIXjSTyQple8GXEtq/lj/E2DKepVewnhegPHVpeEvrUfLb1ULOK2VG13L2+XTS0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765299077; c=relaxed/simple;
	bh=AfAzTeu6iNy9tjIDjznwfXD8TNOA2U/q41oPtZjOGb4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=BMdXxBpRS/RvqMWigw3N9DSOiJiJnEkxWzxaCP5hdu4BaamAPTQCQmbvqfJ3Xixi86bmHnGxNeR+JUm/bK2JUak40hT2iJUy/8UTvrsVx568a4xgUjx4YgM1UVfvSPxXtYChNzcLkE/p0qjCpJ2ulhe4QahTGNe3AOC8xvgiHkc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TPfq5K47; arc=fail smtp.client-ip=52.101.46.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hwvBSpGgGJ43eercVcvFI/SLhc7KX3DEt0nbXVzcLiIQkNa59c+Mmm8nSSK/7rJy9ErBKz9GGY+kNXVvF/JVTDWLTqyegsaJZTWEP1h/4iW2iPoYdfoCpYzy4Y4qipI04nFtbM7JQcy4gH33y0sJF5mExjMQC7fpbYwEKdq5kr7d6EP5W3GaK+/b6gk9cb1KAhAlI3ron8/UdSmpsAqq1IOvKhy+05F55w8kL05amLiEOlW3QrxCJse1/u8wL3gvvCsr3YmwXn9vQhRr/widGrq7tsLGJmGnY6OqS6EfXXv7y4iRBodWxXKiW8kFSdnmFDDVarEFMBATyJDar8cbNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Mw1TK5/oMatiaEH/ZlEwqJlS9n3e/6ZoovjG0JuzVU=;
 b=FwbG9shkDoRB2tv6L3hAGzoyJUpNRNFxklUVgqrc7t/dadD1E2KM3bZy1xk9I/rkztoJjicO7szRbYOui+37yNdvn2ml2LVUc4RF2HkcsS3DjIBQNWAlXCpiBLu4uXQYRbbnJZd3JyTcH5uHtD7tR2mvJDNFr2PWeHyxw/W44p9gurwbQOSSpS/u5u+PZhyGzewHcOwzpu8MQPNadAedhh2I7qbLFmRUQzW5EQP/1QrCywpRy/QtYfbLG4DSQaWoJ3pEmt3dAx16Ek2K27/LJHqbvV+bsR6UJN48b03sCXVWPPe3ijAxlBD3+eFS6EMRV9pMqm8Piuc+4/8Rh/7X8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Mw1TK5/oMatiaEH/ZlEwqJlS9n3e/6ZoovjG0JuzVU=;
 b=TPfq5K47cAUpNyMDtDMXnnHrHDP0fNd7korOR0TizDCWu0my/DL5eJqB0oFNpFVF5L1JrZ/BtCdcTsg+LjagyRPnan2q3ST7FvUr+Q4EQLZgnPlweOoq69eMmid8e147URJY9XQixeXaV2ZnI20Ckx1Pn/6OF6fd2TteXevO3OkmYmLFnkPcyyAbXK2jhMjT7lge3ry9H8wJU1CdOrwYvdYucrPikryN6TgStpWHenjqJyf8Bc8Zw6TCVj/+fthkFuC6AJl033FQzjuCGWUTRHdqXvSjIIOcxxqdByKPWTQ40sqtnqABSj4E9j613TBc0WzJuZc2EGJxvSbo/a6AJQ==
Received: from SJ0PR03CA0259.namprd03.prod.outlook.com (2603:10b6:a03:3a0::24)
 by MW6PR12MB8957.namprd12.prod.outlook.com (2603:10b6:303:23a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Tue, 9 Dec
 2025 16:51:10 +0000
Received: from SJ1PEPF00002316.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0:cafe::ff) by SJ0PR03CA0259.outlook.office365.com
 (2603:10b6:a03:3a0::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.14 via Frontend Transport; Tue,
 9 Dec 2025 16:51:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF00002316.mail.protection.outlook.com (10.167.242.170) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Tue, 9 Dec 2025 16:51:09 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 9 Dec
 2025 08:50:49 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 9 Dec
 2025 08:50:48 -0800
Received: from nvidia-4028GR-scsim.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 9 Dec 2025 08:50:41 -0800
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
Subject: [RFC v2 00/15] vfio: introduce vfio-cxl to support CXL type-2 accelerator passthrough                                                                                                                                                                                                                                                                                                                                        Hello all,
Date: Tue, 9 Dec 2025 22:20:04 +0530
Message-ID: <20251209165019.2643142-1-mhonap@nvidia.com>
X-Mailer: git-send-email 2.25.1
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002316:EE_|MW6PR12MB8957:EE_
X-MS-Office365-Filtering-Correlation-Id: 54d5ed00-dfc1-44b1-9336-08de37432794
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|7416014|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ImVqiqwEQNei2LO4jQMthtz7BEtDB641XEhGIeaPWs/RotRmc85e6h3mtT1m?=
 =?us-ascii?Q?T7vGI9X7/m7gKKBZHZtVQnhOshfPBjHpBACJDxxkWlxrDAbIVRk/I2l7DsjI?=
 =?us-ascii?Q?sdVchhU7vGJtN5Nnys/hv8NJkmWpbhIjn5XYF6FkZfLksgTMr0M6pzGmzLOR?=
 =?us-ascii?Q?9aWKv8eU6d4F6PMvSkeZerl04z2LDjyn/aUtkKIvX3tukZixGr+su470S4K/?=
 =?us-ascii?Q?0qPjw7AEszOXtaOkyEVZnlDYAX22tY6BGSRXirAcBOd0FQ2LG1mWgQDlSP37?=
 =?us-ascii?Q?8yqh/3oRc4QueW6s3bWpwy5+OhfRsAcitq3OwJgFS3HsXh9/4BaLhMmcpxY3?=
 =?us-ascii?Q?lBm/1CY0VJbwelv5xrBuU8IADGG30Te+2HJ9+Kj+LxVSfv603ded4o8HyW/g?=
 =?us-ascii?Q?q/hNQwQGfIh4GCYOASAV12yRxBD5ncJsgeudleBLmSbeKpg7TtnAOszQZyj+?=
 =?us-ascii?Q?6yUIRuS3CUV5zXw1MeUug+U6KwyppVH5/c9iXeTXL9yE0kUiZvLx2aQv3gIw?=
 =?us-ascii?Q?qR5vfOMYQX2qX6CJYotazYlfZ4kAacZL/TuhB8qsTvU7e/PTOtAWswBcqjbQ?=
 =?us-ascii?Q?f8yKwjktMdQzMilXDNIuonyQ7q1utXKiBS4FGpqIAB56IWYbFsAcuDyfcULL?=
 =?us-ascii?Q?IfPifNSzW9KBYJen/LY2DUSjnIP2b3wOUZQCwG/1MAeKABwHKXNfx5IxujjF?=
 =?us-ascii?Q?7DaIhjMrl/k++lrfOv+C+jDW5t7U1sB5MTE9+Uaqlt5ZYzFr9et8/pXzfIUJ?=
 =?us-ascii?Q?oaMTebteq3VoO+ueecgLt1lrVgeCNNsapDjv9RG2Vb6OtMxS8RJDI+pUkmtB?=
 =?us-ascii?Q?LKCZ5ctHiWrMFmlrjCWZBWmoK2GnqJQ5if7KuZr3SyxFHwTONQ8YQ1ZukapW?=
 =?us-ascii?Q?uhUPp18FjLdRV29WL/9KDRa/1ak0VSNjFOxAYAzUSNNqZhvLTHu5iQu88ozC?=
 =?us-ascii?Q?p00NlHNtjB2RYyqxnBTokukiLnHM6ODzC5lQLNTnRGbCUG4QL2MsmZ5Jj7HD?=
 =?us-ascii?Q?8UGZd03tEUbLunD4fgIpxUOR1f9Qrtx31xWDRzs91Tz+MoXpJ3Qkyx/dS/aU?=
 =?us-ascii?Q?5CeVhKnFU8B5eRaTks4GQcmmNVECQYSVWffPXQKM4SiXFUDQHCz3NDmZkigs?=
 =?us-ascii?Q?omLtb6EWkfAmbW1oWpcALwEDOD4r51ORyaWQA3/EHknSCKKTN+M5QyveJFaF?=
 =?us-ascii?Q?PWuVVHZQ1uLuAiQdSJY7Y1vfQvWx/xmLnFSuwwAr0sY5bwk3PoMayi/XF4LQ?=
 =?us-ascii?Q?a3S8yCOspIPpLv7Vp2gh6aPJL5YJjBWHOFdcs5XROtPKMzI7jWHk8P0NI0ZQ?=
 =?us-ascii?Q?JBQKF3pVxwGg5hyc1+kURkIwu8uZJ0rAj3EE0VwRuyvX1xBfzMoNxKcw8mPP?=
 =?us-ascii?Q?yR3JlaYooe7/YYVt1EhM7SlUzLogPwY83AliFWXeL2hvX6yJKE3Pd0/dbSDw?=
 =?us-ascii?Q?C85BfjHb1ijyBAHMlkIVbDNC8J4OEzp83McbWuk3/24gdxzR2f6yQK817LeW?=
 =?us-ascii?Q?k9tfvxXsApwIyFF8VoNjAhURUvPmFfUPfnzudaetjT1D5KMFsLm4OFdROTLW?=
 =?us-ascii?Q?YIdkBekGRzw4CjWJ0Cf3g5KBXOmVGr3bWdBHhmsp?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(7416014)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 16:51:09.9291
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 54d5ed00-dfc1-44b1-9336-08de37432794
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002316.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8957

From: Manish Honap <mhonap@nvidia.com>

This is the re-spin of VFIO-CXL patches which Zhi had sent earlier[1] and
rebased to Alejandro's patch series[3] v20 for "CXL type-2 device support".

Current patchset only modifies the RFC V1 sent by Zhi in accordance
with the CXL type-2 device support currently in upstream review. In
the next version, I will reorganize the patch series to first create
VFIO variant driver for QEMU CXL accelerator emulated device and
incrementally implement the features for ease of review.
This will create a logical separation between code which is required
in VFIO-CXL-CORE, CXL-CORE and in variant driver. This will also help
for review to understand the delta between CXL specific initialization
as compared to standard PCI.

V2 changes:
===========

- Address all the comments from Alex on RFC V1.

- Besides addressing Alex comments, this series also solves the leftovers:
	- Introduce an emulation framework.
	- Proper CXL DVSEC configuration emulation.
	- Proper CXL MMIO BAR emmulation.
	- Re-use PCI mmap ops in vfio-pci for CXL region.
	- Introduce sparse map for CXL MMIO BAR.
	- Big-little endian considerations.
	- Correct teardown path. (which is missing due to the previous CXL
	  type 2 patches doesn't have it.)

- Refine the APIs and architecture of VFIO CXL.
	- Configurable params for HW.
	- Pre-commited CXL region.
	- PCI DOE registers passthrough. (For CDAT)
	- Media ready support. (SFC doesn't need this)

- Introduce new changes for the CXL core.
	- Teardown path of CXL memdev.
	- Committed regions.
	- Media ready for CXL type-2 device.

- Update the sample driver with latest VFIO-CXL APIs.

Patchwise description:
=====================

PATCH 1-5: Expose the necessary routines required by vfio-cxl.

PATCH 6: Introduce the preludes of vfio-cxl, including CXL device
initialization, CXL region creation as directed in patch v20 for vfio
type-2 device initialization.

PATCH 7: Expose the CXL region to the userspace.

PATCH 8: Add logic to discover precommitted CXL region.

PATCH 9: Introduce vfio-cxl read/write routines.

PATCH 10: Prepare to emulate the HDM decoder registers.

PATCH 11: Emulate the HDM decoder registers.

PATCH 12: Emulate CXL configuration space.

PATCH 13: Tweak vfio-cxl to be aware of working on a CXL device.

PATCH 14: An example variant driver to demonstrate the usage of
vfio-cxl-core from the perspective of the VFIO variant driver.

PATCH 15: NULL pointer dereference fixes found out during testing.

Background:
===========

Compute Express Link (CXL) is an open standard interconnect built upon
industrial PCI layers to enhance the performance and efficiency of data
centers by enabling high-speed, low-latency communication between CPUs
and various types of devices such as accelerators, memory.

It supports three key protocols: CXL.io as the control protocol, CXL.cache
as the cache-coherent host-device data transfer protocol, and CXL.mem as
memory expansion protocol. CXL Type 2 devices leverage the three protocols
to seamlessly integrate with host CPUs, providing a unified and efficient
interface for high-speed data transfer and memory sharing. This integration
is crucial for heterogeneous computing environments where accelerators,
such as GPUs, and other specialized processors, are used to handle
intensive workloads.

Goal:
=====

Although CXL is built upon the PCI layers, passing a CXL type-2 device can
be different than PCI devices according to CXL specification[4]:

- CXL type-2 device initialization. CXL type-2 device requires an
additional initialization sequence besides the PCI device initialization.
CXL type-2 device initialization can be pretty complicated due to its
hierarchy of register interfaces. Thus, a standard CXL type-2 driver
initialization sequence provided by the kernel CXL core is used.

- Create a CXL region and map it to the VM. A mapping between HPA and DPA
(Device PA) needs to be created to access the device memory directly. HDM
decoders in the CXL topology need to be configured level by level to
manage the mapping. After the region is created, it needs to be mapped to
GPA in the virtual HDM decoders configured by the VM.

- CXL reset. The CXL device reset is different from the PCI device reset.
A CXL reset sequence is introduced by the CXL spec.

- Emulating CXL DVSECs. CXL spec defines a set of DVSECs registers in the
configuration for device enumeration and device control. (E.g. if a device
is capable of CXL.mem CXL.cache, enable/disable capability) They are owned
by the kernel CXL core, and the VM can not modify them.

- Emulate CXL MMIO registers. CXL spec defines a set of CXL MMIO registers
that can sit in a PCI BAR. The location of register groups sit in the PCI
BAR is indicated by the register locator in the CXL DVSECs. They are also
owned by the kernel CXL core. Some of them need to be emulated.

Design:
=======

To achieve the purpose above, the vfio-cxl-core is introduced to host the
common routines that variant driver requires for device passthrough.
Similar with the vfio-pci-core, the vfio-cxl-core provides common
routines of vfio_device_ops for the variant driver to hook and perform the
CXL routines behind it.

Besides, several extra APIs are introduced for the variant driver to
provide the necessary information the kernel CXL core to initialize
the CXL device. E.g., Device DPA.

CXL is built upon the PCI layers but with differences. Thus, the
vfio-pci-core is aimed to be re-used as much as possible with the
awareness of operating on a CXL device.

A new VFIO device region is introduced to expose the CXL region to the
userspace. A new CXL VFIO device cap has also been introduced to convey
the necessary CXL device information to the userspace.

Test:
=====

To test the patches and hack around, a virtual passthrough with nested
virtualization approach is used.

The host QEMU[5] emulates a CXL type-2 accel device based on Ira's patches
with the changes to emulate HDM decoders.

While running the vfio-cxl in the L1 guest, an example VFIO variant
driver is used to attach with the QEMU CXL access device.

The L2 guest can be booted via the QEMU with the vfio-cxl support in the
VFIOStub.

In the L2 guest, a dummy CXL device driver is provided to attach to the
virtual pass-through device.

The dummy CXL type-2 device driver can successfully be loaded with the
kernel cxl core type2 support, create CXL region by requesting the CXL
core to allocate HPA and DPA and configure the HDM decoders.

To make sure everyone can test the patches, the kernel config of L1 and
L2 are provided in the repos, the required kernel command params and
qemu command line can be found from the demonstration video[6]

Repos:
======

QEMU host:
https://github.com/zhiwang-nvidia/qemu/tree/zhi/vfio-cxl-qemu-host
L1 Kernel:
https://github.com/mhonap-nvidia/vfio-cxl-l1-kernel-rfc-v2/tree/vfio-cxl-l1-kernel-rfc-v2
L1 QEMU:
https://github.com/zhiwang-nvidia/qemu/tree/zhi/vfio-cxl-qemu-l1-rfc
L2 Kernel:
https://github.com/zhiwang-nvidia/linux/tree/zhi/vfio-cxl-l2


Feedback expected:
==================

- Architecture level between vfio-pci-core and vfio-cxl-core.
- Variant driver requirements from more hardware vendors.
- vfio-cxl-core UABI to QEMU.

Applying patches:
=================

This patchset should be applied on the tree with base commit v6.18-rc2
along with patches from [2] and [3].

[1] https://lore.kernel.org/all/20240920223446.1908673-1-zhiw@nvidia.com/
[2] https://patchew.org/QEMU/20230517-rfc-type2-dev-v1-0-6eb2e470981b@intel.com/
[3] https://lore.kernel.org/linux-cxl/20251110153657.2706192-1-alejandro.lucero-palau@amd.com/
[4] https://computeexpresslink.org/cxl-specification/
[5] https://lore.kernel.org/linux-cxl/20251104170305.4163840-1-terry.bowman@amd.com/
[6] https://youtu.be/zlk_ecX9bxs?si=hc8P58AdhGXff3Q7

Manish Honap (15):
  cxl: factor out cxl_await_range_active() and cxl_media_ready()
  cxl: introduce cxl_get_hdm_reg_info()
  cxl: introduce cxl_find_comp_reglock_offset()
  cxl: introduce devm_cxl_del_memdev()
  cxl: introduce cxl_get_committed_regions()
  vfio/cxl: introduce vfio-cxl core preludes
  vfio/cxl: expose CXL region to the userspace via a new VFIO device
    region
  vfio/cxl: discover precommitted CXL region
  vfio/cxl: introduce vfio_cxl_core_{read, write}()
  vfio/cxl: introduce the register emulation framework
  vfio/cxl: introduce the emulation of HDM registers
  vfio/cxl: introduce the emulation of CXL configuration space
  vfio/pci: introduce CXL device awareness
  vfio/cxl: VFIO variant driver for QEMU CXL accel device
  cxl: NULL checks for CXL memory devices

 drivers/cxl/core/memdev.c             |   8 +-
 drivers/cxl/core/pci.c                |  46 +-
 drivers/cxl/core/pci_drv.c            |   3 +-
 drivers/cxl/core/region.c             |  73 +++
 drivers/cxl/core/regs.c               |  22 +
 drivers/cxl/cxlmem.h                  |   3 +-
 drivers/cxl/mem.c                     |   3 +
 drivers/vfio/pci/Kconfig              |  13 +
 drivers/vfio/pci/Makefile             |   5 +
 drivers/vfio/pci/cxl-accel/Kconfig    |   9 +
 drivers/vfio/pci/cxl-accel/Makefile   |   4 +
 drivers/vfio/pci/cxl-accel/main.c     | 143 +++++
 drivers/vfio/pci/vfio_cxl_core.c      | 695 +++++++++++++++++++++++
 drivers/vfio/pci/vfio_cxl_core_emu.c  | 778 ++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_cxl_core_priv.h |  17 +
 drivers/vfio/pci/vfio_pci_core.c      |  41 +-
 drivers/vfio/pci/vfio_pci_rdwr.c      |  11 +-
 include/cxl/cxl.h                     |   9 +
 include/linux/vfio_pci_core.h         |  96 ++++
 include/uapi/linux/vfio.h             |  14 +
 tools/testing/cxl/Kbuild              |   3 +-
 tools/testing/cxl/test/mock.c         |  21 +-
 22 files changed, 1992 insertions(+), 25 deletions(-)
 create mode 100644 drivers/vfio/pci/cxl-accel/Kconfig
 create mode 100644 drivers/vfio/pci/cxl-accel/Makefile
 create mode 100644 drivers/vfio/pci/cxl-accel/main.c
 create mode 100644 drivers/vfio/pci/vfio_cxl_core.c
 create mode 100644 drivers/vfio/pci/vfio_cxl_core_emu.c
 create mode 100644 drivers/vfio/pci/vfio_cxl_core_priv.h

--
2.25.1


