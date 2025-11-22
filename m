Return-Path: <kvm+bounces-64271-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93066C7C216
	for <lists+kvm@lfdr.de>; Sat, 22 Nov 2025 02:58:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 361D63A67BA
	for <lists+kvm@lfdr.de>; Sat, 22 Nov 2025 01:58:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7D542D3EF2;
	Sat, 22 Nov 2025 01:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rrkFMxgJ"
X-Original-To: kvm@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010006.outbound.protection.outlook.com [52.101.61.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195492135AD;
	Sat, 22 Nov 2025 01:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763776680; cv=fail; b=R4JC/c/gZ1888IhVuHM0rAOTJLoH90h/2PwDgTgS0odSIlJ3/fWneunRDvZPjMH5tJyKyBdMqBj54jm3Q0EDtYZZ/4j6V34UPGnsWJlMGM2W30vHI3fD7L11lR/XnrVHp9xRkO9Jp5dHSlassDlcdQ2fDVIvKePKo5jfjjAv82w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763776680; c=relaxed/simple;
	bh=v6du74aMpXNI+KRb3hqxAEgl3i6vKtUG/1di+49tf2A=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=CkxSCKOYhin14eWGcj+i0zt3uNvqy1nH5iRKckl5sPUlAbz+mJxLgXn+ho6XoPgGMwF+fyO6oKXAXsAmRLy1fYzeeYXWYdC2ze6q8QVQ4w77genImtFkQyBZk1qEhAl0iJAlWDOrRtZtoeUoSEa2zkvb6WkTLiMKd5TM6ZyiTgY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rrkFMxgJ; arc=fail smtp.client-ip=52.101.61.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mjNkUKVT1Ldoqd6AQsuUMH70JJmoeRS3wi0jm7F9uY3MbTXVSY+GDwln8vgl1zsQKlVpcxhRwykjQFYc0P3VJImLQOxMrHXflypFSj8y7kGWqsjvIo/h5467csYDWb2uXayChTd6/ekbVhIVX2mDzZEoD+XjnIuF/9F3N3f3oRlpMlJWhrAx8TuLa3SmNGICFFYolwox1NEgFZrbLfgsNUrQpqOJXFeVftqU5Tke06eMlqyVCw8fbIDRBzF9VEOnCmKmXmcfvfXUCajOSee0vYYRb8CY+/U0BJ0TPJJ4u8eUdigEI4QTiIsptufX05rtcNfWr97dgbrB6ADgbPGCxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n7yqXyiIMKS9dSPsMxC3Gx+P0t0PDyRVoLHnTDP8yBQ=;
 b=xabzO+28JWSs3iOHTc57NPV3Op73NPk9RyXyCBu30lLZ2a5QYDWtB1v+rDgKdpiHAb/qPFi6Sy4m6lLFIMv2WOHpKkKovCQzgfsCjs2zL4qzL99LqcySrixYFD6Z+O1o6WYAyE36QLzqxp0fKRGO6A+CFnIDVLdrnaVbIoRABfxeOh1PcBzAjkElBERFpPn/YKoN1Cfzt3WVrhCUIGTa2cDcuTPd09mMHEY3BfdTafCKEk2rTEgeQT9kgjjM47wHo74rhPr/x5r0FGEktsvZaTuo6SbcYFuTlivezOlu51x9j8RIk5DkBQ/HHWeU6VsISyZT9BMGjwQmWyel86iOjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=8bytes.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n7yqXyiIMKS9dSPsMxC3Gx+P0t0PDyRVoLHnTDP8yBQ=;
 b=rrkFMxgJMdJKaDGZTw79kra4ajrJ3IjSKO3ECdvVLAIYwsvicLzBg5YAHATb/QfMXNDzENlucBJjlLdZ0SBLbPAbmPHrLzAK1Wz5rVvsuh6NAKWrtYhVKpFWdKmbTEXqT9IAfl29Oi9NatcbHibc2Tijct6o+HC/opq3yAMENI0yszmj3CWTY5LY/k7RxQmtfKRz1wSPsC7mZfjAZHYPO8O53utRSxLbJjqRFt4xomKkdyrp/0Of7THxLkLVrGsYp1OlPcvOCNIDGE5oo6awLJVqdp6uK/gBDnYbOEoXAf6Wv4PmaepwsSJxHaqdYbJLudTwSQ8/BtesfHiL9r6muw==
Received: from BN0PR04CA0103.namprd04.prod.outlook.com (2603:10b6:408:ec::18)
 by BY5PR12MB4291.namprd12.prod.outlook.com (2603:10b6:a03:20c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.14; Sat, 22 Nov
 2025 01:57:54 +0000
Received: from BN1PEPF00005FFD.namprd05.prod.outlook.com
 (2603:10b6:408:ec:cafe::ba) by BN0PR04CA0103.outlook.office365.com
 (2603:10b6:408:ec::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.14 via Frontend Transport; Sat,
 22 Nov 2025 01:57:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN1PEPF00005FFD.mail.protection.outlook.com (10.167.243.229) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Sat, 22 Nov 2025 01:57:53 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 21 Nov
 2025 17:57:44 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Fri, 21 Nov 2025 17:57:44 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Fri, 21 Nov 2025 17:57:43 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <joro@8bytes.org>, <afael@kernel.org>, <bhelgaas@google.com>,
	<alex@shazbot.org>, <jgg@nvidia.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <lenb@kernel.org>,
	<kevin.tian@intel.com>, <baolu.lu@linux.intel.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
	<patches@lists.linux.dev>, <pjaroszynski@nvidia.com>, <vsethi@nvidia.com>,
	<helgaas@kernel.org>, <etzhao1900@gmail.com>
Subject: [PATCH v7 0/5] Disable ATS via iommu during PCI resets
Date: Fri, 21 Nov 2025 17:57:27 -0800
Message-ID: <cover.1763775108.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00005FFD:EE_|BY5PR12MB4291:EE_
X-MS-Office365-Filtering-Correlation-Id: 74ee9566-6302-41dd-b947-08de296a8ccc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|7416014|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MUqWfvRzJHgsrCk8/H3RDa8wZrOeD5mTYdiobqzcDie8FHrtGkbUGhgFoFr8?=
 =?us-ascii?Q?4xZAgUPiQ5sIv28dhsDMVbkHWldwi0Mqk4ffrTJekDgqYD7QDXhEc319DptI?=
 =?us-ascii?Q?gsnBUXKGUU1wDn6PqN0jDHQ2PfrC3C69hqIElTyvVHhrjpKA1ZZdcRplgMs4?=
 =?us-ascii?Q?xd0sTzCotihysSXuFPl9oEgHDlBy7G/QtB5GKOp7EdP4jVS20YNBbGPDXgx0?=
 =?us-ascii?Q?nihtk/qeROLO7mYw37u/T7u3W9XBRdDOgVdySF64eaycE5gqKSAiVFIjcNiq?=
 =?us-ascii?Q?+JXR5NZpuQ/P1i984yYvdWH6ut/Y9hreakmGeyG5yA8xnCRo5frwH07juy9n?=
 =?us-ascii?Q?SMUCIFRzNVeAqn6fZDVGRk8vnXEpkydAMf3ONSnflf4lcWFoMjMEhXXHjPfS?=
 =?us-ascii?Q?LgdOTuX3V+rAS+Meh6GWEhSLiOld0a706glm/6+NLVQc12k0UDJ9D0sv1s5a?=
 =?us-ascii?Q?adJcHhAt4OFRFflCD+fQBeyqQNgR+No483PQqJpsxqroDt3fZJP96ap7USBz?=
 =?us-ascii?Q?oh16Bl94gHPqNWqAK/RAZ+gG/NJ+IJlJnjRcnpE7dYDPU5sk7ugkbMXgtAKM?=
 =?us-ascii?Q?+gUIq4MjlNo1NKsCyz0/4lgHkzex6+g6HyfktrBRkZRUOHzaCTAVMnIm1nQB?=
 =?us-ascii?Q?JNCdHbdHkdeQDFmCLXTJdJNfOFKnHaKVciQjBDE1WgxRLHqUoU91CqQx4iIW?=
 =?us-ascii?Q?FBFRF8vGPj3wf3KA2Wcm9z5wwd6rNCf8PFbvHUWk1eVGtDhb3iSdC14Mj7DD?=
 =?us-ascii?Q?MWMHTEjb1LGDH8J4Jh25uwf1zfw8fyLagOQ9saBmXZvHDMXiVXfFFZgP94zL?=
 =?us-ascii?Q?HxHBTJRIRBbWv6kiMjIeo2CMtSftLz2soN1/i/tTuEISzSzSMs+qGc3G74ml?=
 =?us-ascii?Q?9RosnryEl/pLD6QKKSfIwWWmm/RRPtUoxzumnlBQgg5+MyK+2drQyw+VN7WL?=
 =?us-ascii?Q?i8oKczjm9UqUxnDTucG+U55027hHRR7nxSLT9RO7rrmPrnGbSJmU0kxeteUE?=
 =?us-ascii?Q?vNYteL7LgAhw3xhZY7/d5mjpxE0kbDhKRuxy4gqv/uFkvR7Xp7jD67/iVtX7?=
 =?us-ascii?Q?b6LCGaUNTXNi0+JkIvRmSNPVlHevBbBbFzr84KqZ6phId8PXMw1h0VNhjrJn?=
 =?us-ascii?Q?5mnKPNpCdhWKI83d7RjhZEEnXKBtytlhsnJ8jXGaWUAI9b6pVoKNQBzODcHG?=
 =?us-ascii?Q?oFqFxNdRwpUfhdxqFqc4aAmVpRJJSbpNAr0XeF9qrvExR8r5TTydvEXfEr0l?=
 =?us-ascii?Q?4md4GyMYEIJa3lvGeyoTVlk5I5W57pfv0CZbKVXZA/r/fHyL8/evmvDRr3mg?=
 =?us-ascii?Q?QqNmlvzONpKr+ZZE7STuxK4UuLa8SEczqXiC/hpNRPretqgRpCsg+Ag1M7FT?=
 =?us-ascii?Q?R7y20LKL7y2RbEToH5yh9haRjxqbFlAJt9Zn4X205Mhrtrt7hYWLYhPUKKY9?=
 =?us-ascii?Q?n/rDHFJGjPQYQfB5TBuPQ+FBWCvJaqrGuGvJDt/I4iYtFcLgiP5PxXZ2YrdU?=
 =?us-ascii?Q?/36DXCOmE3LoMxWRcBdZWMUbbZzWc4IasP6tKNSWRj05kVUWX+KQFWoqtGVG?=
 =?us-ascii?Q?a7k05mZDJNqaM83Be0atQSb7pdyWQyixWYIvXu1j?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(7416014)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2025 01:57:53.6952
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 74ee9566-6302-41dd-b947-08de296a8ccc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00005FFD.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4291

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
https://github.com/nicolinc/iommufd/commits/iommu_dev_reset-v7

Changelog
v7
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


