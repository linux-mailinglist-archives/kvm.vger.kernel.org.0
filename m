Return-Path: <kvm+bounces-62709-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 76015C4B84B
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 06:14:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id EFC3434E577
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 05:14:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2394834A79B;
	Tue, 11 Nov 2025 05:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AisIb9le"
X-Original-To: kvm@vger.kernel.org
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012070.outbound.protection.outlook.com [52.101.53.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399E8325705;
	Tue, 11 Nov 2025 05:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762838018; cv=fail; b=ZMXhkSDAk5PjKhSeK4qt9lS6QV8YhPsY83iMquOyfMpZMSfYU/G42kaDJGHZe5d2jXyumlZA05WbE3XYgGXKkkDMAZ/fxyC2+XuhO43rh6BHGf686EJdVfdbWC3sSO0BEsmDlqD9TzU5yvZwcscuvjNFV/Fwr7YaVv9QUexBcbw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762838018; c=relaxed/simple;
	bh=i1hXrFJEuWeUgYDBwDJ4W1+GBydhmZlELhM1UA0dQTk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ocqXxcIbXIuv6pS7Jg8lFxQ18LoE/FG2Fa8pSSKpnuAQc3YW/puH6Vquwc+2wIraxD/4Xdzs/Wr/9ib5KZ6+dnVue7tPMRwfKS8OgidTcBXiCcy8QhQ/tTZCQKPc4sPDcL4RoxJGIM7OazTqXGgIMuAu+U5tAeMb+KBv7Rfm2Pk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AisIb9le; arc=fail smtp.client-ip=52.101.53.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RfTL0htw4Mv7Rr9m58Tjt0t6iFbhbkwXtF8pfsoTQsVOZfwZZ3pT2ELk5IevSNDj6Xt9t1RnJoH2aD0LToCvGVM4fpuNdk374NP8L13O8m5r0qzJt4lpHoI8TgRRhRE4Kwgx+WEN6VAVzlxH7idKFjRJYQB6q5CT+Z8XBjqGdAtCkdYGsmXaxTwan/WdWjHPWlUM7mMbrsNyy5RGADQ7hHeES4YIz71JfJeuecPx8QHiZLkGoRmn/RwXbW5zmG46mqT0fKSx1nDrArZ2e6m8KmopsW9UMfqB8ERmCGt5IUPCoOv2QcqGSBXhnE4iCCaVMFMXhTSUr3HyW+vMwHEk/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7x/urKveNUI8/T9VVVZQfOwR4ezLjq1GH2b2zMgX+fQ=;
 b=g2oKRp2PVXAJxJ1dssZEB9eecxENQB2FXWbdY+5OpfFsMeoR7KkGM4ouyt5rLdbMMLTYj7egzEXp2q41qhYEfZUkr7CyuOyTVXe01H5vgNGT7pAIrLBHJunflBzREsd4KUUEjFscf+9oL4PuDymTVxilkXszRgVeXg47aAeGIonlMTp7K4n8dwO4WRMqQIbLgZeNtPc6Ddjzn2PI29VIA3GRQsIORxW9T4Uio1ZrXRj89/OXqoHgOG32ALE8LwVMQYpoLwbKJZZWvpQNKpvC3Nf4xVUz6rmR6ORvDF0noSTklBhe8WY8mZp6n5azpY8hkVoLyItAqCxEcxYOKDgyRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=8bytes.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7x/urKveNUI8/T9VVVZQfOwR4ezLjq1GH2b2zMgX+fQ=;
 b=AisIb9le1WyA/zikEzatkjHg4/kR0Qds1kU9OKJ+DcDIMBB0gbSXT5vgUcJgje6oB2CGc1g1sOjo/OKtYv6tYVFdcoVve4y9gkCwuiSdTM4bQSoLe9DOS2mkSn/xa1cnQu1z6iRjyiThSMBfRJib1TCE6sJJ/FNP5Px1yGEcK3C47xA0tWVER8vXE/6f3ZYKrhe/R7yGdL8VSH4ffPBxBkC04yNbLGARGCGS3kEwSJl0gWiZIJrEpTnkDu23xXm2XnX48jJWN7sXHHrUgxyNLohienBkPp6L9KnQ9JRj+hymuK4loEcS16+K313NXuxM31gAOiBdpZW7i8CcJfm/kg==
Received: from SJ0PR03CA0281.namprd03.prod.outlook.com (2603:10b6:a03:39e::16)
 by LV2PR12MB5799.namprd12.prod.outlook.com (2603:10b6:408:179::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Tue, 11 Nov
 2025 05:13:31 +0000
Received: from CO1PEPF000044F7.namprd21.prod.outlook.com
 (2603:10b6:a03:39e:cafe::1e) by SJ0PR03CA0281.outlook.office365.com
 (2603:10b6:a03:39e::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9298.16 via Frontend Transport; Tue,
 11 Nov 2025 05:13:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000044F7.mail.protection.outlook.com (10.167.241.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.0 via Frontend Transport; Tue, 11 Nov 2025 05:13:31 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 10 Nov
 2025 21:13:13 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 10 Nov
 2025 21:13:12 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Mon, 10 Nov 2025 21:13:11 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <joro@8bytes.org>, <afael@kernel.org>, <bhelgaas@google.com>,
	<alex@shazbot.org>, <jgg@nvidia.com>, <kevin.tian@intel.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <lenb@kernel.org>,
	<baolu.lu@linux.intel.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-acpi@vger.kernel.org>, <linux-pci@vger.kernel.org>,
	<kvm@vger.kernel.org>, <patches@lists.linux.dev>, <pjaroszynski@nvidia.com>,
	<vsethi@nvidia.com>, <helgaas@kernel.org>, <etzhao1900@gmail.com>
Subject: [PATCH v5 0/5] Disable ATS via iommu during PCI resets
Date: Mon, 10 Nov 2025 21:12:50 -0800
Message-ID: <cover.1762835355.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F7:EE_|LV2PR12MB5799:EE_
X-MS-Office365-Filtering-Correlation-Id: 987b7696-1736-49f5-b7a8-08de20e10e3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?scVhUp5rcVOIVOe7SD3+hLQxhcUF718X2UBlDLnIL2NLBEpI7xeE+3PzOBJB?=
 =?us-ascii?Q?Wwj/te3ah+Q4hn7wrIAOgKxApSap9rCcts+9O7sMLS39DKlr1kSP8hxC4GbQ?=
 =?us-ascii?Q?FDHp7aY2lSd0Pq2fvKup2b2pdCGosZKFylrDy+fTgmOr/pcq5UUK8uQSyRJZ?=
 =?us-ascii?Q?BpXW314dEV31h5ztJnM4Yf5N7lG9z94AUM72wnwxRx4YJRVvYGbj6P/SQo4X?=
 =?us-ascii?Q?J7GRaG3S1s/ix/1yDq4aO9flIEluAeo1iZD0Dza9lfvLsVMXuabSWw67LBnR?=
 =?us-ascii?Q?9Tgn9lGfjpXtpNIL2K+g/XSOaAbjBKtp/Me7ow4EZtsv/peGN6Z/3LKBxiEG?=
 =?us-ascii?Q?7WUP7Fj2TN0pmSmErr3veHHgdM8y49kKT+ZeWw2gIooPMNy4agFCAgcc0kQL?=
 =?us-ascii?Q?PBoQNJ0V0nOw8BxQxKx2Oxe8eujNE3qyv/GMGscopDp1W2TLiametXvxA3x7?=
 =?us-ascii?Q?XSjNuFnjr753bciMTncVh0Ght/815OV/Yn5JOkKlstwUjDZPs9dyEM6+qFTv?=
 =?us-ascii?Q?/ACCvATXnDMl2rOGMQ4x7wj0c1hrzyD7pw+J/aIwfZ31Jmj5EOUaKR8imdQT?=
 =?us-ascii?Q?OdFycnyKc2QpatDZKWezVi/BHT16Wh0yobxWX0D3agaiFGMwOZqPHI5NxG1i?=
 =?us-ascii?Q?VaXNtzUMOcrBpYaLKe/HYBQv+7X/iMMRHMMVoDb/DMh6ci6l70se7YkMbg8B?=
 =?us-ascii?Q?zCGVtq51ubJwzAAWGz9cg1Jlsae5eHNi6FKU/oL0GPoCPSUBeOvW/lUugU72?=
 =?us-ascii?Q?X2M3CzbyJslk3YhGtZ/7hdbIBfqoDbm9RRty2ppTqpoCVCCnhcdnSBa7IleQ?=
 =?us-ascii?Q?EnAfO2a4p66iIjDr8dS828RHRiSUWA4lmCAJKIEQb/jIp8cbYH/W3Ron1nzI?=
 =?us-ascii?Q?0M/oLvF2vhGGMExblubT3xuLeyYk5JyWKCxSeOf9s8da/DPRvCkoJ6PzMi8n?=
 =?us-ascii?Q?745fogtuaCFseh019TzmPeGr/2w8LbmvWxrQiF9oxwgGXONMNpCi+qI7euN5?=
 =?us-ascii?Q?xljxm90wNMUujt544jCz2swfJcC4fjOLYCrQctdnffha0J56xDuZrblkfTeE?=
 =?us-ascii?Q?LwHop+bfmSfjb8Sswypvts9OZgeLdjVd6hX9aM7/M2O25SnKnysYt34UNofy?=
 =?us-ascii?Q?lhvrO9V148mOVnCdtu6le1vRlvxnNxbq6ep/Oj4DqkGAQn8pd07YBGbAZx/y?=
 =?us-ascii?Q?e+FFVt5mCe5BmIg11wh8wfwqRzzHWgBgxwWkTgDCh0APaVhBvnwHNDXu47MV?=
 =?us-ascii?Q?74hbEt5emw9MiGTS4obMLZFX6QkydrFDO/KPlHX7uQaLcTWH31KNf3xIkumV?=
 =?us-ascii?Q?3wB7IEguBe/vYZDrC2Wh0lRk7X52TViOP3BFVwmdV9Wl/SQPCpVe9VQCbHkr?=
 =?us-ascii?Q?G0PWTXg0AJvRDgKgZg+2GJ64+X+oSSXMWSjhBJXYKHdlKQrpcEd7ZTKPZRra?=
 =?us-ascii?Q?2cBImeFnlXV4HIP5rveE2mIjmYYQy+ay1irWHu5CEfIFe9udLYHNwacjaU5q?=
 =?us-ascii?Q?PfwQJMWNro5uPAs9dASOtWCcoE/b8+zENjhHgL1VV544SQBZ6fSYNbkbb2iV?=
 =?us-ascii?Q?YmgxBuegMG40oUfQ8N8O41kjy7UA+XZ6X2qWDrH5?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2025 05:13:31.0410
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 987b7696-1736-49f5-b7a8-08de20e10e3e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F7.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5799

Hi all,

PCIe permits a device to ignore ATS invalidation TLPs, while processing a
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

Finally, apply these iommu_dev_reset_prepare/done() functions in the PCI
reset functions.

Note this series does not support a shared iommu_group cases. And PF will
be blocked, even though VFs (that are already broken) would not be aware
of the reset.

This is on Github:
https://github.com/nicolinc/iommufd/commits/iommu_dev_reset-v5

Changelog
v5
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
  iommu: Tiny domain for iommu_setup_dma_ops()
  iommu: Add iommu_driver_get_domain_for_dev() helper
  iommu: Introduce iommu_dev_reset_prepare() and iommu_dev_reset_done()
  pci: Suspend iommu function prior to resetting a device

 drivers/iommu/dma-iommu.h                   |   5 +-
 drivers/pci/pci.h                           |   2 +
 include/linux/iommu.h                       |  13 ++
 include/uapi/linux/vfio.h                   |   3 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |   5 +-
 drivers/iommu/dma-iommu.c                   |   4 +-
 drivers/iommu/iommu.c                       | 230 +++++++++++++++++++-
 drivers/pci/pci-acpi.c                      |  12 +-
 drivers/pci/pci.c                           |  68 +++++-
 drivers/pci/quirks.c                        |  18 +-
 10 files changed, 339 insertions(+), 21 deletions(-)

-- 
2.43.0


