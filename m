Return-Path: <kvm+bounces-63637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D092C6C2E6
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 01:55:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 218D0346108
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 00:53:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90D76221271;
	Wed, 19 Nov 2025 00:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fNXI6iD3"
X-Original-To: kvm@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012040.outbound.protection.outlook.com [52.101.48.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9BCF1DE3DC;
	Wed, 19 Nov 2025 00:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763513570; cv=fail; b=siiCoksuxksRHdrBvmmmR0Llc/1FiR9r/f94NljeHOXI8ioJOiMQn8Di+mKNM4jRXBxN4/yg5c9brhLw1kWps4H4GGZBS2azkUTg6DizJ6Z5yju1VjP8IZFzPoDl+ewrf+bE9nbHAjrlvh8MzN+4+dz4qVxVGGOtg4P+eGWWuSI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763513570; c=relaxed/simple;
	bh=/FvVC7Vf6hQuS025kXIPqgGxu4EfbOPBlJgLzKJEf8I=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=o0kohnGZbDM2mfCuz/zxnSRlaS2qRTJ6OzmRGX6xZEpoXD+NxLDbo6jNKRYV5Q+DwP8Vq8stySzIjQ5nGy9Krapxfl1Fn5bVNDmvgl6T66zWkY9ljzYZ/NjJUHWwZ8x4rsOLByCt/eiwu9fImlnL3dLCA4HWIGubS+fIXY1x0i8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fNXI6iD3; arc=fail smtp.client-ip=52.101.48.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NJrwM96sg8XvCAlkMFMygIcL/37T8cK+gpA6v/Bsz0kOQZ+KfDfyo+ml9r4rckRLg0uS2vDqAh8ymYYbrUn5l+eLr7JHHoGZ8TWuAVxU25xObLa2CkphsLp0+2CQb3oAl9WMQl8iUN4+n/OyHnzzbeNGbCAOO9YaTHFnDurt7XySEcJmL2rFcfrl+5Y67sOaCdAzvnT+FD5yJ3BimHfFrrDv0nwnMjtWbeHE8+Y9g3O5HqRreqajvp5D2DBiMifT5XwPtUWi6kTbEHEdKSBHhh3l5/kpJebAjh67DySy7+8HoYfV0M1NKvNYNUpC1603CsZsHO76z6+zshsqHYBDrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bmqxKt06O9ia8hBgJK9BTztsNumdOBbuz1eTI+u1+C4=;
 b=VtOgGp8y2XYRhwQ9jfZ9Md8HTuKWhyv++7JdN9vZ6XCaxL+liFVfpMeoi2iJffEbSCc5ETBgzk4ulnxF9eIWCzjKq/alKJc/mduZ9EyBcphi/khhf/k6wUEVv0ZWV2D4AaUGWPp5DxCOvmmM2OzY4LjowlVk41rIUiVehJraM6SOyA1tvApBKHTZ0B2bDr7ZWHZ7slGBuRyARIlQYkCjGFlJzFDSV2Zmhd12vV1+kTKeumEMRciB964w2mP1+HC4rhhalDpoxCudQJXhMsxWiTSqfp7nQuZk6aMoxzrJTYsNTsaMMNnm9Vq0rTK7PMuy59kAkD379W+WwreHNWHZdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=arm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bmqxKt06O9ia8hBgJK9BTztsNumdOBbuz1eTI+u1+C4=;
 b=fNXI6iD3ZFgGnYxrcYyQ9AnxCHvhTSLRU7F4JvUPCy+eYg9ANmxpEa2sEdiGh6bjiRS2LFiWPrnAYY9KZfuc5ymM5GprMUcwAVL/6lBEBBgpSteOmAUvitE8TL9VjofydS4C7QacWHyledJWW6mSqN3aYFJIUk+4/93ohWpaU31fQb8QIg55k/+ZUSYmqp6MORqH3DsP/BJTps/BsvhNCLB3NmGtrutruW+gXEyT7wlPmWANUvaEm8VwsdPvUGSNXXaSyaoF8Jb8Tx5HhojppnvnqvYUGOPUVZvE/C+xiRSJbGb1492TRCPHkOs//QJ3MXYTZLxDgklNp1x7EolWuQ==
Received: from BL1P223CA0037.NAMP223.PROD.OUTLOOK.COM (2603:10b6:208:5b6::14)
 by MN6PR12MB8470.namprd12.prod.outlook.com (2603:10b6:208:46d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.19; Wed, 19 Nov
 2025 00:52:41 +0000
Received: from BL02EPF0001A107.namprd05.prod.outlook.com
 (2603:10b6:208:5b6:cafe::56) by BL1P223CA0037.outlook.office365.com
 (2603:10b6:208:5b6::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.10 via Frontend Transport; Wed,
 19 Nov 2025 00:52:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF0001A107.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Wed, 19 Nov 2025 00:52:41 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 18 Nov
 2025 16:52:24 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 18 Nov
 2025 16:52:24 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Tue, 18 Nov 2025 16:52:22 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <robin.murphy@arm.com>, <joro@8bytes.org>, <afael@kernel.org>,
	<bhelgaas@google.com>, <alex@shazbot.org>, <jgg@nvidia.com>,
	<kevin.tian@intel.com>
CC: <will@kernel.org>, <lenb@kernel.org>, <baolu.lu@linux.intel.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
	<patches@lists.linux.dev>, <pjaroszynski@nvidia.com>, <vsethi@nvidia.com>,
	<helgaas@kernel.org>, <etzhao1900@gmail.com>
Subject: [PATCH v6 0/5] Disable ATS via iommu during PCI resets
Date: Tue, 18 Nov 2025 16:52:06 -0800
Message-ID: <cover.1763512374.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A107:EE_|MN6PR12MB8470:EE_
X-MS-Office365-Filtering-Correlation-Id: 33dd3948-9742-495d-0426-08de2705f187
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|82310400026|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cUxzC8WFjZsTs1eySwxPri1/+2k5tFvDnFLV5t8z1zHFFpiw4xHEJ1F8iCVM?=
 =?us-ascii?Q?DzmgAbsxtnEJt64NcoFiOOMHDuJEGx7rR0xljelr1gy7wrkW0BDj7iSBrWRB?=
 =?us-ascii?Q?4RGg8WdKV7k7ZJdHMXCPox0IrYRvxpwMpKeW9iunw8XQYkekYLOApQM2NkoX?=
 =?us-ascii?Q?Wv6K7sDy3KkRnym1TPdtaeeqPqjH8eFZB1JZ6qq0mvefM+SEfm0226kpEKMl?=
 =?us-ascii?Q?tqX+PVT8hcQkl21x8RrbklI2LEE70oLJUTYKwxkWYkqosluCCZxQXF9xStg7?=
 =?us-ascii?Q?wtdm3IxQ2PUO5nVyXhDh9+9pn00WmIkxjoQnqUFb/ZdaEiUMazSwLB5vM1D2?=
 =?us-ascii?Q?zensLoRzvAabXaCZD1JreSZf1vtDQsnIV212xdO7/HSpxmCnOibNYNKkN+f2?=
 =?us-ascii?Q?VkTnaXOaj11C4BE/kc9THoisDl3epjFvqN1FuOnGg1lnOvPt8kaJyfrnN5uL?=
 =?us-ascii?Q?/1I6CBzIWvGDQ7kYKRZYhPiKrHVWnhTPXpzeNqAsVrXMV+Mc1itGc2kVev6p?=
 =?us-ascii?Q?qvSVURvvSB6nSEwsfbyQhqnBIPfWRMcNGuz9FC3pvZfZETt89g5sQEMu5BcR?=
 =?us-ascii?Q?e0a0BDaMyiXUsZzu9q0o+O+nuzVnXVKWkLx2EOTRCmKPgtO/VLqkEuwNP+qK?=
 =?us-ascii?Q?fyYuvbHu9iuksSuHPyCUfBYp6NlQeLPo9LQX6X+59GAa/Md2SL9rZFBeDv2P?=
 =?us-ascii?Q?iaZYFAEgnfJnSQXcOADba/OjpNyj7+mcyjAJeKH3aP2E42jFQc2i/PuULOZ+?=
 =?us-ascii?Q?9Sa80wChyB2hYlKA+7uxtSaFRVLBaQDp1PUqOEGKGktYjrlA2xrGClb8FGS6?=
 =?us-ascii?Q?7qi/q8DcgGafbhGoQOsR7ZJnLA7VOu0jEKHMxaGv/V+qgltZjXw5aGEC90kG?=
 =?us-ascii?Q?q2uAzunfP4IJHYghY9ms1u3p0IjNIs8fq9Xw2DXKUMAR/5ojw8WLrBJxRunU?=
 =?us-ascii?Q?oBzfWlbkopd5b3Lx9Ujej3ZUhAy39VGNP7xNSM68yjPansOZmvCho1ch/xg9?=
 =?us-ascii?Q?9SY1p8PUh+XPaZCPDS2xw0f+x0SRvfoeKvUhn0zuXehx9fGMBddm0yrlBp8M?=
 =?us-ascii?Q?R7AMrut9IJaLShIbNRyKQ5kh9AB8Rgi8UabdzYMdzyMCNsUfwIx02xDxbhO9?=
 =?us-ascii?Q?QM5IWaCdft3ygNMcU9K0sCihD1AbrKo86PQ2Odjy+oNZb4+qSy4Q0bCuPswx?=
 =?us-ascii?Q?nuuITX9jGShXgC82zumpAa7KZTT4fxQQdyblw9oPxhlt4Q7lQm71DdSTLSr/?=
 =?us-ascii?Q?Fmst/aHYc3DHouSBFLX2+YSKQ1b0GNUFIRHCkfq3FU6X5lTZoe/6KWRS9p8V?=
 =?us-ascii?Q?K+NYwiLjzAkL0CIid5uAISs7WmJcLEsoGZ7aSgLPueabHF/GhDlrDcZC5KAs?=
 =?us-ascii?Q?BmI3f3BvkdC1WuE7WioWz7y7QRFkKY8X5KG1qritHoN8ohl+uyCUwPNL3gzb?=
 =?us-ascii?Q?C2piMHEWCfILwqyiximh73AEU/S/jtE+pkt8ESciDjh0JZdK84wyfkF6zBue?=
 =?us-ascii?Q?Je5YbFsIqWmLm2sZ4q+CA38ury4M9O50uBxXZg1gMt3NC2mLZ/5NauE9lx9B?=
 =?us-ascii?Q?G1o1EXiwXBzyK+58ERWqZBFssDjT7xqUCSsiaET0?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(82310400026)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 00:52:41.1560
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 33dd3948-9742-495d-0426-08de2705f187
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A107.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8470

Hi all,

PCIe permits a device to ignore ATS invalidation TLPs while processing a
reset. This creates a problem visible to the OS where an ATS invalidation
command will time out: e.g. an SVA domain will have no coordination with a
reset event and can racily issue ATS invalidations to a resetting device.

The OS should do something to mitigate this as we do not want production
systems to be reporting critical ATS failures, especially in a hypervisor
environment. Broadly, OS could arrange to ignore the timeouts, block page
table mutations to prevent invalidations, or disable and block ATS.

The PCIe spec in sec 10.3.1 IMPLEMENTATION NOTE recommends to disable and
block ATS before initiating a Function Level Reset. It also mentions that
other reset methods could have the same vulnerability as well.

Provide a callback from the PCI subsystem that will enclose the reset and
have the iommu core temporarily change domains to group->blocking_domain,
so IOMMU drivers would fence any incoming ATS queries, synchronously stop
issuing new ATS invalidations, and wait for existing ATS invalidations to
complete. Doing this can avoid any ATS invaliation timeouts.

When a device is resetting, any new domain attachment has to be rejected,
until the reset is finished, to prevent ATS activity from being activated
between the two callback functions. Introduce a new resetting_domain, and
reject a concurrent __iommu_attach_device/set_group_pasid().

Finally, call these pci_dev_reset_iommu/done() functions in the PCI reset
functions.

This is on Github:
https://github.com/nicolinc/iommufd/commits/iommu_dev_reset-v6

Changelog
v6
 * Add Reviewed-by from Baolu and Kevin
 * Revise inline comments, kdocs, commit messages, uAPI
 * [iommu] s/iommu_dev_reset/pci_dev_reset_iommu/g for PCI exclusively
 * [iommu] Disallow iommu group sibling devices to attach concurrently
 * [pci] Drop unnecessary initializations to "ret" and "rc"
 * [pci] Improve pci_err message unpon a prepare() failure
 * [pci] Move pci_ats_supported() check inside the IOMMU callbacks
 * [pci] Apply callbacks to pci_reset_bus_function() that was missed
v5
 https://lore.kernel.org/all/cover.1762835355.git.nicolinc@nvidia.com/
 * Rebase on Joerg's next tree
 * [iommu] Skip in shared iommu_group cases
 * [iommu] Pass in default_domain to iommu_setup_dma_ops
 * [iommu] Add kdocs to iommu_get_domain_for_dev_locked()
 * [iommu] s/get_domain_for_dev_locked/driver_get_domain_for_dev
 * [iommu] Replace per-gdev pending_reset with per-group resetting_domain
v4
 https://lore.kernel.org/all/cover.1756682135.git.nicolinc@nvidia.com/
 * Add Reviewed-by from Baolu
 * [iommu] Use guard(mutex)
 * [iommu] Update kdocs for typos and revisings
 * [iommu] Skip two corner cases (alias and SRIOV)
 * [iommu] Rework attach_dev to pass in old domain pointer
 * [iommu] Reject concurrent attach_dev/set_dev_pasid for compatibility
           concern
 * [smmuv3] Drop the old_domain depedency in its release_dev callback
 * [pci] Add pci_reset_iommu_prepare/_done() wrappers checking ATS cap
v3
 https://lore.kernel.org/all/cover.1754952762.git.nicolinc@nvidia.com/
 * Add Reviewed-by from Jason
 * [iommu] Add a fast return in iommu_deferred_attach()
 * [iommu] Update kdocs, inline comments, and commit logs
 * [iommu] Use group->blocking_domain v.s. ops->blocked_domain
 * [iommu] Drop require_direct, iommu_group_get(), and xa_lock()
 * [iommu] Set the pending_reset flag after RID/PASID domain setups
 * [iommu] Do not bypass PASID domains when RID domain is already the
           blocking_domain
 * [iommu] Add iommu_get_domain_for_dev_locked to correctly return the
           blocking_domain
v2
 https://lore.kernel.org/all/cover.1751096303.git.nicolinc@nvidia.com/
 * [iommu] Update kdocs, inline comments, and commit logs
 * [iommu] Replace long-holding group->mutex with a pending_reset flag
 * [pci] Abort reset routines if iommu_dev_reset_prepare() fails
 * [pci] Apply the same vulnerability fix to other reset functions
v1
 https://lore.kernel.org/all/cover.1749494161.git.nicolinc@nvidia.com/

Thanks
Nicolin

Nicolin Chen (5):
  iommu: Lock group->mutex in iommu_deferred_attach()
  iommu: Tidy domain for iommu_setup_dma_ops()
  iommu: Add iommu_driver_get_domain_for_dev() helper
  iommu: Introduce pci_dev_reset_iommu_prepare/done()
  PCI: Suspend iommu function prior to resetting a device

 drivers/iommu/dma-iommu.h                   |   5 +-
 include/linux/iommu.h                       |  14 ++
 include/uapi/linux/vfio.h                   |   4 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |   5 +-
 drivers/iommu/dma-iommu.c                   |   4 +-
 drivers/iommu/iommu.c                       | 220 +++++++++++++++++++-
 drivers/pci/pci-acpi.c                      |  13 +-
 drivers/pci/pci.c                           |  65 +++++-
 drivers/pci/quirks.c                        |  19 +-
 9 files changed, 326 insertions(+), 23 deletions(-)

-- 
2.43.0


