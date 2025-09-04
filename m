Return-Path: <kvm+bounces-56724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4144FB430CF
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 06:08:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BE3101BC4A18
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 04:09:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 685DF23908B;
	Thu,  4 Sep 2025 04:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ChbufghB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2048.outbound.protection.outlook.com [40.107.92.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6515235362;
	Thu,  4 Sep 2025 04:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756958921; cv=fail; b=n668kWm2ud4aaN/I6GHyfeZM5mDBr6VfiPTgr/MtnoMG0jLUpqffQa7JDtXhexMC0Az7o0RTHaPXCmmQKcZlvRTt9xn2g1QLQdwlJECwQP6oeXWG3j0sgeKktTuci7VqnNFiBI8q2mCLnai7d6fKytjc1GGTVGV8f0mmjxM7nUc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756958921; c=relaxed/simple;
	bh=JzCzaRhMilnODFUvMFxVySIyizUlTrWXE7Z0O0O/taM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MHwbomMKB9qcTnne0d2imfEu4cUHF14mytu78QJoI1rujgTQjJb3TPBm896jBekyfFyWoD4BeOfqPjDgkVDIA4NFsuYFhl+YTLlYUkcT2AXElA0+6S3DI4nrGkwMK59XDIsDd8+uJst9WGGLEleMNEO/Mv/SrpZZtYYd2lGsQag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ChbufghB; arc=fail smtp.client-ip=40.107.92.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S9UrqmRxrtpxTLxuOOSk2GPb2CySfRWeJe3mpWfCEqOXDF+5JSPmQ1v0whs6hG7xqzBLbh4/1Dqa0m2ZtbOqgQZsZxAx4ybw7Jyt6xg22RBrgPfY2c2NrSUxye2UDEc/iSUmA3btbfX+4q6ZUvo7FIIHXa0azNCMbFcD092AUs1wRDrFYo16bV/Sc3ozStUuapXOphKFJ4c8QtavzWYgarWbZBqB+Wb8RCVmfSWKFmpb8bfN7Q1iDKm5ErhBMkrSya71tWRGnUn75ixK2tItCnVjR8O/Ooi9oOY6/6NI61MTwIjNljgC3rSmiDY9V3TxUtwZbtIyFyYczHgp11/MXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=76AfKMDPTgdkAye1Ymq3yZKN+ZuGL3hPPg5jvLbGQ/A=;
 b=arlmeJ9iY9DTvWaMIHp0x39kgO4SeVoLBy6zCf5Chxul3kq5QRmNm7LMbYMKq2nIolQXJBc72niF/oNo7eqNsKUVcCk1lLqeQe+mL6aF/rOBI4BbMJa21fgGFdahyoiVsb8U45/Km3nr/LxSSh9C03mDaubZLrwxtyPdQE7c+ps/n5LO0URgF1a+/qjcuYSVedOkQ5czhAyDzzTP9zmWcbd6qb9CTv+UB9X624nvh0C3fQqBQVLc9JZc8slAjuhtwsk2Ib9Gu/Cbz/u3uTA0iWxzzCrzOcJ3yqPvb2AwFLnzn0PZgApdEixcyMdP/m9SZyBYCwGBsCNp/DXuqfYGCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=76AfKMDPTgdkAye1Ymq3yZKN+ZuGL3hPPg5jvLbGQ/A=;
 b=ChbufghBfwWlzrvj5kxRd1g+rslZNxDfbZnAxNV/3zC4zqO49WBz6pTtrlFjOO+qXm7ylH/P8miC/rQ2ntfK7YfoMPbxrVxHBkCfIz7i9ShlEYyHnk3vQJr++FJzpwP8f3lVe2ZL2WK2RHraID5iiWIDxbuhpEwqMpXwKs1eAP12MCcH/26o46PC+vTwI4xz6MaB41zzjmGU6dtdZLl/XqQhh4dacrp09kyKODVV+WIVFsenItTBKP0jvaigSsXudeZEGv0HtqhmAVQ7k5lUSp7Vyd+eCLIZuKOk4fo3Pb2+0BHXzhIBc1tsJGUcY2LW3fP24Mj9qtl+cuODj1Yunw==
Received: from SA1PR03CA0023.namprd03.prod.outlook.com (2603:10b6:806:2d3::28)
 by DM4PR12MB6062.namprd12.prod.outlook.com (2603:10b6:8:b2::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9073.27; Thu, 4 Sep 2025 04:08:35 +0000
Received: from SN1PEPF000252A2.namprd05.prod.outlook.com
 (2603:10b6:806:2d3:cafe::68) by SA1PR03CA0023.outlook.office365.com
 (2603:10b6:806:2d3::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.17 via Frontend Transport; Thu,
 4 Sep 2025 04:08:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SN1PEPF000252A2.mail.protection.outlook.com (10.167.242.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.14 via Frontend Transport; Thu, 4 Sep 2025 04:08:34 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 21:08:29 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 3 Sep 2025 21:08:28 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 3 Sep 2025 21:08:28 -0700
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <skolothumtho@nvidia.com>, <kevin.tian@intel.com>,
	<yi.l.liu@intel.com>, <zhiw@nvidia.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kjaju@nvidia.com>,
	<dnigam@nvidia.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC 00/14] cover-letter: Add virtualization support for EGM
Date: Thu, 4 Sep 2025 04:08:14 +0000
Message-ID: <20250904040828.319452-1-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A2:EE_|DM4PR12MB6062:EE_
X-MS-Office365-Filtering-Correlation-Id: aaf15e63-53b2-4149-00e4-08ddeb68b7b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jzOODujYJYq1Z4+vBODBsEVuiZ9srwjp0Xv8OqIhFQIK1WiqVutYvGHPq7oe?=
 =?us-ascii?Q?tzVepjFqaoqXsn5EdT0FSLZtO1EGoOS3hSLmk7zW+tRFX6eITVo2zoDv2PSV?=
 =?us-ascii?Q?6bJfmho4OzWC2CIcFOMR1TCMzIRT0GWc/jQ2ByQ8/tAxoEX+lw78pT0EpFJA?=
 =?us-ascii?Q?e2NVKohf5ulIXIcYTCcmEzVvBVO0yxSDdpCsoueiRB43VlFJpB1IFv7t++/k?=
 =?us-ascii?Q?MaFKrOXybLHgjQWewI2ogGMevrkR3ZF4B9TQdiXjUvm5TR9DNjHfqTar5f7U?=
 =?us-ascii?Q?2kVXDHS9ndf+H/DJOUn6FBj9W9pZD8XxylHApvingDWv4NmRsxS7/Ia4wzef?=
 =?us-ascii?Q?Yog2GIaNlxwdwjjrHrK2EPRnwFNjmuSedXav09c88sY/JJko+S7/jc4oyxIT?=
 =?us-ascii?Q?DtDBFkLCRLIi624v1TdDxgLH5aetmUyTl/bgfXBdAXvJu4xkFc1fb7GZoxXB?=
 =?us-ascii?Q?4HWDy6a2cBVUeZyBTIGUCRvVXCi+86dy1Wq3+8zL59sW+nEA6oPzSFUXjGJh?=
 =?us-ascii?Q?nR/EuIqz7X2EIDeTktS66nakASLW3oXWzhm7+UGaXjSnMDn6W+sTG+Ds5g2X?=
 =?us-ascii?Q?xLgcbk8m+Zf16gKP0IA/jVMo3MiX7QvnY5kgyyem5LdwKOTNRvFWL9lk6rbH?=
 =?us-ascii?Q?XrudPq3yOsb+17afu+j9J7lfI6N9PcyRLYuxAwlPNILfwUUifJZE9k04iEFr?=
 =?us-ascii?Q?u3y3BLH433RkiqIfMlQBa1DnTaLXXI+sWYYIY38LOaPBt+KRg/Mt0Uhnppzc?=
 =?us-ascii?Q?Vwn13/66PBOtM8052Wnl31RQKTHhBSLIQpV/TMMpjko/lwWYuFHjAgZvLMBY?=
 =?us-ascii?Q?xVwlSBJOC97JWeNuqdj1M+C/CZ9Bb59inft1zjGFStBzMyI3n3Zqc7Aqoocg?=
 =?us-ascii?Q?/KqP5ZHKwBWbNPrzH8t5w3NcOQTQhx1Kj5qUgJMD9bXwakLSAXrr2639PKLn?=
 =?us-ascii?Q?zhd/XryDvMMFkYg0ij8DmL5p4qpBjcIG+vaNASXP8WchOfeLop2W/PZZWYMr?=
 =?us-ascii?Q?Li6EMQ6wcvAA6kzKYypp3zDBGBc0dA/7xn65FvR5RNlp++Ht9rhQiCUsKvDI?=
 =?us-ascii?Q?t9zBD6GJINmy+M4B05kV2CzdyCvaEp7+IZu/DiqphNZic8oA7JjdEnGPDox9?=
 =?us-ascii?Q?gCxf9ClQQhR46qinph6doZvPAQI+/dxl/UCZxc2tqb0NETdudF8qj3RfARuM?=
 =?us-ascii?Q?P/FM1wEhJ037tgUlPKXu8b4eSfnH/9GBHTPjDsTkf+2p5Qgy13glcHNyH2br?=
 =?us-ascii?Q?NyF3WHKThuYKK9OkbiVUlahTFTZhFKObpooKftc5BziNudHre1rO6wJD4lkE?=
 =?us-ascii?Q?VSKqS5GCxfLvIv/UOzFBtdjFr/eX2hx+Qp2fwxqOdktxEPEDwqJwpWKcNgxj?=
 =?us-ascii?Q?8xxP3PvTUR4gYww50EDZ8/a2cwOhW7FaCY0xuFY+HvdhV2iDS2D1RAoWQdPI?=
 =?us-ascii?Q?ouMoQtsLj1BaoVoh8nIikMRXK/fo+nmhO31qWBYGE1BQOGqh6FW/AQrdJuMz?=
 =?us-ascii?Q?v8B8Tz0cP88l9l0HWfyElwLETVFesiVWVbmdMeovCaODFk3taONRn5UBLw?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 04:08:34.6276
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aaf15e63-53b2-4149-00e4-08ddeb68b7b2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000252A2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6062

From: Ankit Agrawal <ankita@nvidia.com>

Background
----------
Grace Hopper/Blackwell systems support the Extended GPU Memory (EGM)
feature that enable the GPU to access the system memory allocations
within and across nodes through high bandwidth path. This access path
goes as: GPU <--> NVswitch <--> GPU <--> CPU. The GPU can utilize the
system memory located on the same socket or from a different socket
or even on a different node in a multi-node system [1]. This feature is
being extended to virtualization.


Design Details
--------------
EGM when enabled in the virtualization stack, the host memory
is partitioned into 2 parts: One partition for the Host OS usage
called Hypervisor region, and a second Hypervisor-Invisible (HI) region
for the VM. Only the hypervisor region is part of the host EFI map
and is thus visible to the host OS on bootup. Since the entire VM
sysmem is eligible for EGM allocations within the VM, the HI partition
is interchangeably called as EGM region in the series. This HI/EGM region
range base SPA and size is exposed through the ACPI DSDT properties.

Whilst the EGM region is accessible on the host, it is not added to
the kernel. The HI region is assigned to a VM by mapping the QEMU VMA
to the SPA using remap_pfn_range().

The following figure shows the memory map in the virtualization
environment.

|---- Sysmem ----|                  |--- GPU mem ---|  VM Memory
|                |                  |               |
|IPA <-> SPA map |                  |IPA <-> SPA map|
|                |                  |               |
|--- HI / EGM ---|-- Host Mem --|   |--- GPU mem ---|  Host Memory

The patch series introduce a new nvgrace-egm auxiliary driver module
to manage and map the HI/EGM region in the Grace Blackwell systems.
This binds to the auxiliary device created by the parent
nvgrace-gpu (in-tree module for device assignment) / nvidia-vgpu-vfio
(out-of-tree open source module for SRIOV vGPU) to manage the
EGM region for the VM. Note that there is a unique EGM region per
socket and the auxiliary device gets created for every region. The
parent module fetches the EGM region information from the ACPI
tables and populate to the data structures shared with the auxiliary
nvgrace-egm module.

nvgrace-egm module handles the following:
1. Fetch the EGM memory properties (base HPA, length, proximity domain)
from the parent device shared EGM region structure.
2. Create a char device that can be used as memory-backend-file by Qemu
for the VM and implement file operations. The char device is /dev/egmX,
where X is the PXM node ID of the EGM being mapped fetched in 1.
3. Zero the EGM memory on first device open().
4. Map the QEMU VMA to the EGM region using remap_pfn_range.
5. Cleaning up state and destroying the chardev on device unbind.
6. Handle presence of retired ECC pages on the EGM region.

Since nvgrace-egm is an auxiliary module to the nvgrace-gpu, it is kept
in the same directory.


Implementation
--------------
Patch 1-4 makes changes to the nvgrace-gpu module to fetch the
EGM information, create auxiliary device and save the EGM region
information in the shared structures.
Path 5-10 introduce the new nvgrace-egm module to manage the EGM
region. The module implements a char device to expose the EGM to
usermode apps such as QEMU. The module does the mapping of the
QEMU VMA to the EGM SPA using remap_pfn range.
Patch 11-12 fetches the list of pages on EGM with known ECC errors.
Patch 13-14 expose the EGM topology and size through sysfs.


Enablement
----------
The EGM mode is enabled through a flag in the SBIOS. The size of
the Hypervisor region is modifiable through a second parameter in
the SBIOS. All the remaining system memory on the host will be
invisible to the Hypervisor.


Verification
------------
Applied over v6.17-rc4 and using qemu repository [3]. Tested on the
Grace Blackwell platform by booting up VM, loading NVIDIA module [2] and
running nvidia-smi in the VM to check for the presence of EGM capability.

To run CUDA workloads, there is a dependency on the Nested Page Table
patches being worked on separately by Shameer Kolothum
(skolothumtho@nvidia.com).


Recognitions
------------
Many thanks to Jason Gunthorpe, Vikram Sethi, Aniket Agashe for design
suggestions and Matt Ochs, Andy Currid, Neo Jia, Kirti Wankhede among
others for the review feedbacks.


Links
-----
Link: https://developer.nvidia.com/blog/nvidia-grace-hopper-superchip-architecture-in-depth/#extended_gpu_memory [1]
Link: https://github.com/NVIDIA/open-gpu-kernel-modules [2]
Link: https://github.com/ankita-nv/nicolinc-qemu/tree/iommufd_veventq-v9-egm-0903 [3]

Ankit Agrawal (14):
  vfio/nvgrace-gpu: Expand module_pci_driver to allow custom module init
  vfio/nvgrace-gpu: Create auxiliary device for EGM
  vfio/nvgrace-gpu: track GPUs associated with the EGM regions
  vfio/nvgrace-gpu: Introduce functions to fetch and save EGM info
  vfio/nvgrace-egm: Introduce module to manage EGM
  vfio/nvgrace-egm: Introduce egm class and register char device numbers
  vfio/nvgrace-egm: Register auxiliary driver ops
  vfio/nvgrace-egm: Expose EGM region as char device
  vfio/nvgrace-egm: Add chardev ops for EGM management
  vfio/nvgrace-egm: Clear Memory before handing out to VM
  vfio/nvgrace-egm: Fetch EGM region retired pages list
  vfio/nvgrace-egm: Introduce ioctl to share retired pages
  vfio/nvgrace-egm: expose the egm size through sysfs
  vfio/nvgrace-gpu: Add link from pci to EGM

 MAINTAINERS                            |  12 +-
 drivers/vfio/pci/nvgrace-gpu/Kconfig   |  11 +
 drivers/vfio/pci/nvgrace-gpu/Makefile  |   5 +-
 drivers/vfio/pci/nvgrace-gpu/egm.c     | 418 +++++++++++++++++++++++++
 drivers/vfio/pci/nvgrace-gpu/egm_dev.c | 174 ++++++++++
 drivers/vfio/pci/nvgrace-gpu/egm_dev.h |  24 ++
 drivers/vfio/pci/nvgrace-gpu/main.c    | 117 ++++++-
 include/linux/nvgrace-egm.h            |  33 ++
 include/uapi/linux/egm.h               |  26 ++
 9 files changed, 816 insertions(+), 4 deletions(-)
 create mode 100644 drivers/vfio/pci/nvgrace-gpu/egm.c
 create mode 100644 drivers/vfio/pci/nvgrace-gpu/egm_dev.c
 create mode 100644 drivers/vfio/pci/nvgrace-gpu/egm_dev.h
 create mode 100644 include/linux/nvgrace-egm.h
 create mode 100644 include/uapi/linux/egm.h

-- 
2.34.1


