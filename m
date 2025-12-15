Return-Path: <kvm+bounces-66042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 09BFCCBFFCA
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 22:42:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 75C0B3002E85
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 21:42:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8725132C948;
	Mon, 15 Dec 2025 21:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="F3q70JJ2"
X-Original-To: kvm@vger.kernel.org
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011026.outbound.protection.outlook.com [52.101.62.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E134622068D;
	Mon, 15 Dec 2025 21:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765834971; cv=fail; b=Jp/tARy5QhJFF2x2jIa47oaZlTlribO3v7PQRR+0R781axu3+8/tAzPtKXd7RoiUQ1F+zl6e+6r5M3KjvRAvftwm1zcCATcOCHaVIV2ZiWslK9e3ooAWNC47A0K4dmzEdtrE5kPypbuMYmQD2MqidbBwA6Z3OMIBiLbHBfffM2s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765834971; c=relaxed/simple;
	bh=wA2BfokxgZyEZdh4dPBC9iNCVKA5sSCtolbZ9Jw5YUE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UQEuG8eYdSyLXNxJOHz1b7nCxcoZaQws9sXfdQgjWa+wAX/3Gy9RPxhGFvSsyvdCtqz4+Bhs5KkkBs7ihNVvfnwLnzVCROVQPVhoBFe0V9CLp0Xlafne0SRNshr3FttV1FvuTL05xB9EO/iO+cOFHOPRAP/uAGRHONm+iIrZ/uw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=F3q70JJ2; arc=fail smtp.client-ip=52.101.62.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qlwPD80IHAcnrUsT4YFeZbVV7STyAub1Vmyel3+gRX1tZFy68FZFWj5kduM1VKruByrjZ9FykhXiplSbf0cwUhHOaXC8isXwV2zaOVj2Nroat2tRmh2iwN5oyzv8etBykLtGAIQ8gUnDrwqSnAiKmQ+jzHmBHJ/p4PocOMUg+r3CcfAy3Clf4gUeR8OsWOYcptBHndmK6xtV11PzqvGD1PBJhNiviUhCz74IsKlJBfP/6BtxlE+ShrtOH/pLdr2cviWctuUUhtvXvsT8BYP1/pJYROWjLqP0A95Yj71jbaGJ+2IAfpITVchY5PYi/PBtQ91Mik0iZlymW4gW4GN/Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uAjy8p6VbFULROxO9IIXbaQz2U8xpLf6Y3fUl8Z0Ycs=;
 b=IhafxHFD2hY5A0vBcMvjEd9EpdaOtJQMzxdCCScE8QTiOD3AIM7V0mQ4xjHW0ltGZI0QmPYDraYOOFpwHTj8goFkB7N85UamO8h0tsY2+ReSso96tRpPcinqJ8g1ILJimjD5bDl91nUAB1YxyZQBxhcLZPIEOlJQhyTVGvfABaZbrNV+M/+HyTZi7BS2a3yyy9GJ/6CxAy1eiKb3HQ8PXybdCo3nbcjVzS42qGk5Z18parjB9rebZvWO6/eGk4tEnC6K7UjgK4LN8l5YU6yaJI6vQxlZjx2aY8DfFhCK8O3hh6sOMwk72BagyQarLsfC9aJYgcB8dZsa5Vyolwm3ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=8bytes.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uAjy8p6VbFULROxO9IIXbaQz2U8xpLf6Y3fUl8Z0Ycs=;
 b=F3q70JJ2J4XaK7RrFG+moATWFrBh/GwjaWVvEpAeaM8VNFv+Cj4rggaamQENmF6R6qE4uOGwZOP8ufnd2MK2bKfAxlfcax/4Ib01KATmf61hrQ5gRjADraLU33e67YQsqAuW+CQqTufxuWmDgOVKGVQ55BYE7RHwX2hYwjq+Pj/cyLd/L4lwfHLzx59Vy8QOIo15bWdFzY0qJdvx/33WUp8UdNd7WLRGJjupnn6vg81grafdRi979qv3AR9fagzT7/P4MDkpf6XAeIqmv+7P9A3U4n0PSIXTHJPOV9Of16Tna7ecyR5RtUh9oO7ztDlbZ9uzmjgPPTjGyVOsMQ9flQ==
Received: from CH0PR03CA0377.namprd03.prod.outlook.com (2603:10b6:610:119::31)
 by DS7PR12MB5719.namprd12.prod.outlook.com (2603:10b6:8:72::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 21:42:45 +0000
Received: from CH1PEPF0000AD76.namprd04.prod.outlook.com
 (2603:10b6:610:119:cafe::36) by CH0PR03CA0377.outlook.office365.com
 (2603:10b6:610:119::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.13 via Frontend Transport; Mon,
 15 Dec 2025 21:42:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH1PEPF0000AD76.mail.protection.outlook.com (10.167.244.53) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Mon, 15 Dec 2025 21:42:44 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 15 Dec
 2025 13:42:28 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 15 Dec 2025 13:42:28 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Mon, 15 Dec 2025 13:42:27 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <joro@8bytes.org>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <afael@kernel.org>,
	<lenb@kernel.org>, <bhelgaas@google.com>, <alex@shazbot.org>,
	<jgg@nvidia.com>, <kevin.tian@intel.com>, <baolu.lu@linux.intel.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
	<patches@lists.linux.dev>, <pjaroszynski@nvidia.com>, <vsethi@nvidia.com>,
	<helgaas@kernel.org>, <etzhao1900@gmail.com>
Subject: [PATCH v8 0/5] Disable ATS via iommu during PCI resets
Date: Mon, 15 Dec 2025 13:42:15 -0800
Message-ID: <cover.1765834788.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD76:EE_|DS7PR12MB5719:EE_
X-MS-Office365-Filtering-Correlation-Id: d8a796aa-f821-46e7-1baa-08de3c22e1dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|1800799024|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MrGXWA7L9jLTxZX4oz2MJEdDj+hTClZQ/wl0HoOS6FHQO7P4Ww3y8byrv9MS?=
 =?us-ascii?Q?qj8RwOwV4UucanQGSZlwDtBBQ2kRoGJRSL4ZSSFGaAKmpjpme+C2UbfSpDgG?=
 =?us-ascii?Q?jr3FepVINz9KhrqNhawsWo7Ha5q46yKna4sg/CEtaSmsbry0NZZSE1KStk0h?=
 =?us-ascii?Q?Fqd0oFexXKOIuFTQbNHWOUoZb5pdA/fAqfIaMKOQXpruxUdYsd1tQAQXsAHv?=
 =?us-ascii?Q?LhRf4fVQ6ziq5mHH3Kr9+TzW92rArHVA+p+oOcUI6tBlncNP7oiyHlCiEG6Q?=
 =?us-ascii?Q?ZIhA2D1koJ3G7WiiA/FnUg/qoom+odcAAlVqD7h0TTuRXb0YjjSN0MV/X3Sh?=
 =?us-ascii?Q?BeGAyWAu68ZieBHP3WGXFInfUSDfrZSJFbcg79eV7T+/tPzCVM0/SO4w/R3o?=
 =?us-ascii?Q?J2KF60StjnYFgLE0ZxALnozFn0mhur+7l4fviTHv55ORID05RPZXCeRCi7Lx?=
 =?us-ascii?Q?wsP4JWxARKfYlc9dSTn5jMZwc9L4hReQ5ZxUuEKOSYpt/zukkIKx/M1z5PRU?=
 =?us-ascii?Q?p7DzSYcIMBMd92fxKOcECXAVYsAEZRx4ZL/2W2jsJnr39/N2ZxgQaKL8tM0J?=
 =?us-ascii?Q?FIK7zPIUcx4YRvIZ8dlAOifij65ZN4Pok/SknkuQBQGa3fy080Ry9N70L8pC?=
 =?us-ascii?Q?wK2konohCjHa0Hp+zc/P/91TD/RL+ILlwmxe5hpxpUFQanChyLlefwTCms42?=
 =?us-ascii?Q?06uvDpX1NkZrzaHwgAzNgGXoYCDbzzGcB8WLK/cjdzp18Qao4/D1cVlQ+x2U?=
 =?us-ascii?Q?DUqqPDvxIdkGFe22+v2vevibUsAL7EtURdnDln8GhAsGih0d1BFGc6A5o5yB?=
 =?us-ascii?Q?+qS9YludOt8z4nOMTueIcKNMuIN3JxXBTZGpX1emqhELSzHV3CyPgmYfFxZa?=
 =?us-ascii?Q?MC00niIw414bkC56yFh1o85sdziCUy8JCZ9DdI9MxlELLNeTYxKH84/v7dIY?=
 =?us-ascii?Q?Iq/sF3sWxj/0gFwIHWq8nv4FKU6+9nPxAH+uy5GjfrD6+tPxhDSivsJsNVFu?=
 =?us-ascii?Q?7Uop51YF7LNIzhmX/ee+J5L/jxZphP1//XDA2Ny3HfHixCdztXh6X9F8vOa/?=
 =?us-ascii?Q?Vz1OrLA26cFPuaCuKM+XGObmv/T3PNHifzCXYLljwsl0NQbIwksK+jFqnT/W?=
 =?us-ascii?Q?9HTEEXHOrbHfn6h1SgEZUJw9zwkjHVc79UtO8v40wsC5jqLPYNVy//h5hjlJ?=
 =?us-ascii?Q?Cy5ZzLlLuNAYHaTmN+bT+qwGddS//TnNnBpdEnmAzd87O47/5aCAjSO+QTue?=
 =?us-ascii?Q?dKNzir4f3FBP4ryJ5jjLIJReOD8KI8H8rkfscVcytrCw9JyqgFMeEw1Sh1SW?=
 =?us-ascii?Q?ThrSmHnIX/ucsvH3Am35bLUNePaR/PPtwGkxFI30tT4GWRgPtTLQb1329QMb?=
 =?us-ascii?Q?+gDrEvVai9+fhWx3zq1muI+CMQpGhRDOR9SShtjF9ETN0BOEB07aUwQ4o3hU?=
 =?us-ascii?Q?fKehBdWK7E1Iay2PeEd6D0e35FnkTROUFJtrr87kABpaeUKGBRxsjiQMzdH+?=
 =?us-ascii?Q?NK21bb79DXhgKsrsFNAYSuWvNqPx5W8NHTovFCXISkAl8tfVNq+U7e7nGwlv?=
 =?us-ascii?Q?582Q9JfTEFy930xuHelHArokYLp8NfHKbrbPNnUl?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(1800799024)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 21:42:44.7473
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d8a796aa-f821-46e7-1baa-08de3c22e1dc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD76.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5719

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
https://github.com/nicolinc/iommufd/commits/iommu_dev_reset-v8

Changelog
v8
 * Rebase on v6.19-rc1
 * Add Tested-by from Dheeraj
 * Add Reviewed-by from Jason
 * [pci] Add Acked-by from Bjorn Helgaas
v7
 https://lore.kernel.org/all/cover.1763775108.git.nicolinc@nvidia.com/
 * Rebase on Joerg's next tree
 * Add Reviewed-by from Kevin
 * [iommu] Fix inline functions when !CONFIG_IOMMU_API
v6
 https://lore.kernel.org/all/cover.1763512374.git.nicolinc@nvidia.com/
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


