Return-Path: <kvm+bounces-31334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 340D09C2A56
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2024 06:49:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E65E6281F4F
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2024 05:49:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54C3313D518;
	Sat,  9 Nov 2024 05:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BKHgyjdr"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2080.outbound.protection.outlook.com [40.107.223.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866A428E8;
	Sat,  9 Nov 2024 05:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731131343; cv=fail; b=fDjeGFgeKhM8gtarXEVWplcYEZbFwioZiVx6lz/JWAu4Mvi85JlEIxf0fBASJIvF6yAjYg+JicOOr8e2WKBdM+tJJgvBqlA3Qpz1l17mEjflPqf2uStnEcQGYmfW7oNshYUAbB4sI6LInO/V5iPnTD54uiBsIvgkVLCS0EHsnbw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731131343; c=relaxed/simple;
	bh=+llelvHTcPfatwzG1M8E63xRAqfi3H93qnm+bYp0mVE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fBYSrmgjeygfcFjG5BYRaGdyq3SGfKE4VpBgiZE13umTDz30Rqk0FlZQDPvFBzEedl7XJ9N6AqGST4tRvAFA4iN6h+beHWDfGjS/DtYNi2twaY9dMyWNrgWo1Z9azbPcoxx2GXTdvuBzeNp2TCBhfJ1/chxnvZC6ZJvk3RoCx8w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BKHgyjdr; arc=fail smtp.client-ip=40.107.223.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AUoqsFhPXf1AcgH9c1rwvncF2Tyr9fM6wRo3YDzncs8/hO74sCGvRa7MN+0JNdb30j5kgXQ0jZIifWMkC9Gcaq0pC1+xveBpu8SboULoP/x+N18X/TLFTibLZHWXk+46l/0pdW1qxehOxLtAzbHI7GIspeqCCStWPCgAdGxL4pHAKX/GIE/hDqRvrKq4/hdParpdVATHNkBa7v0esO61BcKEU07QNILSH/jPQwNKfCXkOouZVcapt1tcM4TydbnDmBF+jrHjJMDQgRuyUEQI759bOXzJpCz5/YauOQPM+RwoSTwwLaWXh77vWtQWxk2vbU/CM5oF+V8AdPPYb4hTSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HWXk1M1z0TzoKj4lk2QT2XGDekLoNywF5oy+A6MVFww=;
 b=jgOff6D2ziVORVRABMDnPmHcRyJWu8AY0ONPwibO7nDatqLwVztUbnZVcySn181E3QTzxTLhJ0W2BewC+nt7km3fSg/i2/B4dqupDRCf0euQkSkW3rB7AQT7LiyzIFrIzSQUvoPZstfTyxMc7l+Ltzmvn+t+mjC8vufZLt6IZlgR3noxHniGzjXJYBHUI/mMTPoNPW03oNMqkOcXRsOCSiHL0LcIwoead+uCoORANo0gE8a+qxw62ZVko/uIX7yj0dwT+nMhdjtlrJbhLc6VsCKeFLTkBsBQqEcV0j9ftrPYQwnrjJ9C8DogzNVJa3R8d02cjCm7kczemiPIBb5KeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HWXk1M1z0TzoKj4lk2QT2XGDekLoNywF5oy+A6MVFww=;
 b=BKHgyjdrrzfKlt3rcZ2C2GihO20WOmu5sxP8Wyzp00za9J/o24sbIxjRK6ruC+o2Q71qr9jEDIzFe67m07me7HjBUvqo6lembBJaeLil9xVj9/KMbw1RfhOvyOP5aXDr3G6ApOCvKEKD836aXuu4T6TI4kPSDZgsbJCbi9ib+o7T/GRdO/ItyXV4plQVVnuXPypk8ShoOAsTyT/zkDtkvznJ7zoplnazvMGbDD0mDnZTgvTxkgPs59XElpSKc3H8qyYWCljAYyDBWFXbJd0ILmljJr36nCY+QvWInIL88Y/xRKMJXL3rcOJ81fHNxGSk20c5VwPaO1S2997RGOc18A==
Received: from MN2PR01CA0042.prod.exchangelabs.com (2603:10b6:208:23f::11) by
 CY8PR12MB7266.namprd12.prod.outlook.com (2603:10b6:930:56::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.25; Sat, 9 Nov 2024 05:48:57 +0000
Received: from BL02EPF0001A102.namprd05.prod.outlook.com
 (2603:10b6:208:23f:cafe::9c) by MN2PR01CA0042.outlook.office365.com
 (2603:10b6:208:23f::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.21 via Frontend
 Transport; Sat, 9 Nov 2024 05:48:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL02EPF0001A102.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.17 via Frontend Transport; Sat, 9 Nov 2024 05:48:56 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 8 Nov 2024
 21:48:55 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 8 Nov 2024 21:48:55 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 8 Nov 2024 21:48:54 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <maz@kernel.org>, <tglx@linutronix.de>, <bhelgaas@google.com>,
	<alex.williamson@redhat.com>
CC: <jgg@nvidia.com>, <leonro@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <robin.murphy@arm.com>,
	<dlemoal@kernel.org>, <kevin.tian@intel.com>, <smostafa@google.com>,
	<andriy.shevchenko@linux.intel.com>, <reinette.chatre@intel.com>,
	<eric.auger@redhat.com>, <ddutile@redhat.com>, <yebin10@huawei.com>,
	<brauner@kernel.org>, <apatel@ventanamicro.com>,
	<shivamurthy.shastri@linutronix.de>, <anna-maria@linutronix.de>,
	<nipun.gupta@amd.com>, <marek.vasut+renesas@mailbox.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: [PATCH RFCv1 0/7] vfio: Allow userspace to specify the address for each MSI vector
Date: Fri, 8 Nov 2024 21:48:45 -0800
Message-ID: <cover.1731130093.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A102:EE_|CY8PR12MB7266:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ba6b15a-ba80-42ea-b40b-08dd008233ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oIN0azHKlwa9RlQAupKIzxjMdWjY9zGt79W24TA2Hbyjxaw62f9VDbgTL34H?=
 =?us-ascii?Q?Yqtb5/1GT5+O/Vz5faHM04ndjcczvozgrMwYCzWsOs6TfPYPY2T6iFPedFk4?=
 =?us-ascii?Q?F52BeWVPvM/37vYruQTNPUgJPdbIeiw3KsEa2jwKllMr97YNadf6lv8UY5rm?=
 =?us-ascii?Q?w+B4wd+Qka0ifwq7TWtUB0bNGIZDeWH+xoJfdQnVibfG5wb6tjToVel8ICz6?=
 =?us-ascii?Q?RwZKRnW02IczKR0KPDxipwS7mCluD+pDqM5Drg/rl7e1iE26hSeNqSTtLXm0?=
 =?us-ascii?Q?qbhpZKE2zYHLs3PbIDMUrqlL35JzAd/h+tzmHf+W3YTeM6PsxDS0+zOBZKFL?=
 =?us-ascii?Q?XzvY4NagpVxxVlxwkPoo5ywY3jE0COiYCT7H5FI2ybk6YFgiAfohYVSMOW6F?=
 =?us-ascii?Q?7A2YPJfR4fy2AxFrrf/csdp4WELjMDyB3zeHQ6f+aEvCX6zvhQJVKe4vFGjB?=
 =?us-ascii?Q?hyCuzLcsJq7tKlMMf+TU/d7PmbyRvsxApoELDnZ27a231NEGGuDEgDmJiI8w?=
 =?us-ascii?Q?gCF1FtYRzXb+Vm+/f+eiJe7pUT8AwlQr4S0b2nQm7Jn5uZPHpjFa+0J6Pe+L?=
 =?us-ascii?Q?fUcxXHnSoyXqhG3PQVDbYAB8bP6yz9EDouk3Lq7MmKnhzEUM/+PjB4ZA/K4Y?=
 =?us-ascii?Q?cyZBJ07XgqNQVjuFaNDUGnATiG+zxx4Dj1iY3xXqJZY3IN8GH04CA3mjLsP4?=
 =?us-ascii?Q?mIJICw8soP8kfVSyRsF4udwIK+AmNvstnVZtvR4Vs00FANrIfBgBcRawd8fa?=
 =?us-ascii?Q?vn5rUe5mrz8VZjoxXR5rAkcCg+7ZbkM3lz+I67J3NRMUzHUQJ1rG1Vy9McwH?=
 =?us-ascii?Q?iUoGsT5SLpzJKBvsViGyYw0zPd6gA4YZnVG36KtuP8wPnkj6QBEb1zlQwki9?=
 =?us-ascii?Q?1pimeqYnP3bcqbI09uUjIqHWr2SWHa/bafTFCmQ2ATyMoC0e6VbJZ1f3WXqE?=
 =?us-ascii?Q?Awsm2B4s73Q4TunABO1Zl6n8ycaUNYnKMaPkaIJfx0ibx487JCKugvB+ktK2?=
 =?us-ascii?Q?5wH+ZBQo9szCHUxg57/xRDXwp+U2OTGeQt9gD6aVzmwhkuBGUudFaxzN/67e?=
 =?us-ascii?Q?xl2QyXfivZRqPl9aiafA5g0a2Q5G5rxWEeBDVYjj6Ca/WX7K5ynwNtgY9Dcz?=
 =?us-ascii?Q?UDAIZnjPwWH9e9a5PDD8bqnrJl+v6nL6qjTZRGAWlh5+LL6dZpKPEZ2EXRow?=
 =?us-ascii?Q?KqkS52g6DT8V+FTJ0CjrFeQ28PZiAcpQl/LFjconWfb+yjYVd+6pMtgHCE5d?=
 =?us-ascii?Q?mzBkXrmFX9mzVht822eoOiDpXa9evqu14L9PAAmCPOig4hm4m8imgNAeIz5J?=
 =?us-ascii?Q?kW1eNgltsho26nLOGKWeUcdNKLdskK0jwjwMXhTByOmA3n3NNe//K3KKvE3B?=
 =?us-ascii?Q?MEcUfyVSAW/JzP64p6E2hOnynzlyIDdyboEbTGGvYUFPQfKCqA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2024 05:48:56.6930
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ba6b15a-ba80-42ea-b40b-08dd008233ab
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A102.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7266

On ARM GIC systems and others, the target address of the MSI is translated
by the IOMMU. For GIC, the MSI address page is called "ITS" page. When the
IOMMU is disabled, the MSI address is programmed to the physical location
of the GIC ITS page (e.g. 0x20200000). When the IOMMU is enabled, the ITS
page is behind the IOMMU, so the MSI address is programmed to an allocated
IO virtual address (a.k.a IOVA), e.g. 0xFFFF0000, which must be mapped to
the physical ITS page: IOVA (0xFFFF0000) ===> PA (0x20200000).
When a 2-stage translation is enabled, IOVA will be still used to program
the MSI address, though the mappings will be in two stages:
  IOVA (0xFFFF0000) ===> IPA (e.g. 0x80900000) ===> 0x20200000
(IPA stands for Intermediate Physical Address).

If the device that generates MSI is attached to an IOMMU_DOMAIN_DMA, the
IOVA is dynamically allocated from the top of the IOVA space. If attached
to an IOMMU_DOMAIN_UNMANAGED (e.g. a VFIO passthrough device), the IOVA is
fixed to an MSI window reported by the IOMMU driver via IOMMU_RESV_SW_MSI,
which is hardwired to MSI_IOVA_BASE (IOVA==0x8000000) for ARM IOMMUs.

So far, this IOMMU_RESV_SW_MSI works well as kernel is entirely in charge
of the IOMMU translation (1-stage translation), since the IOVA for the ITS
page is fixed and known by kernel. However, with virtual machine enabling
a nested IOMMU translation (2-stage), a guest kernel directly controls the
stage-1 translation with an IOMMU_DOMAIN_DMA, mapping a vITS page (at an
IPA 0x80900000) onto its own IOVA space (e.g. 0xEEEE0000). Then, the host
kernel can't know that guest-level IOVA to program the MSI address.

To solve this problem the VMM should capture the MSI IOVA allocated by the
guest kernel and relay it to the GIC driver in the host kernel, to program
the correct MSI IOVA. And this requires a new ioctl via VFIO.

Extend the VFIO path to allow an MSI target IOVA to be forwarded into the
kernel and pushed down to the GIC driver.

Add VFIO ioctl VFIO_IRQ_SET_ACTION_PREPARE with VFIO_IRQ_SET_DATA_MSI_IOVA
to carry the data.

The downstream calltrace is quite long from the VFIO to the ITS driver. So
in order to carry the MSI IOVA from the top to its_irq_domain_alloc(), add
patches in a leaf-to-root order:

  vfio_pci_core_ioctl:
    vfio_pci_set_irqs_ioctl:
      vfio_pci_set_msi_prepare:                           // PATCH-7
        pci_alloc_irq_vectors_iovas:                      // PATCH-6
          __pci_alloc_irq_vectors:                        // PATCH-5
            __pci_enable_msi/msix_range:                  // PATCH-4
              msi/msix_capability_init:                   // PATCH-3
                msi/msix_setup_msi_descs:
                  msi_insert_msi_desc();                  // PATCH-1
                pci_msi_setup_msi_irqs:
                  msi_domain_alloc_irqs_all_locked:
                    __msi_domain_alloc_locked:
                      __msi_domain_alloc_irqs:
                        __irq_domain_alloc_irqs:
                          irq_domain_alloc_irqs_locked:
                            irq_domain_alloc_irqs_hierarchy:
                              msi_domain_alloc:
                                irq_domain_alloc_irqs_parent:
                                  its_irq_domain_alloc(); // PATCH-2

Note that this series solves half the problem, since it only allows kernel
to set the physical PCI MSI/MSI-X on the device with the correct head IOVA
of a 2-stage translation, where the guest kernel does the stage-1 mapping
that MSI IOVA (0xEEEE0000) to its own vITS page (0x80900000) while missing
the stage-2 mapping from that IPA to the physical ITS page:
  0xEEEE0000 ===> 0x80900000 =x=> 0x20200000
A followup series should fill that gap, doing the stage-2 mapping from the
vITS page 0x80900000 to the physical ITS page (0x20200000), likely via new
IOMMUFD ioctl. Once VMM sets up this stage-2 mapping, VM will act the same
as bare metal relying on a running kernel to handle the stage-1 mapping:
  0xEEEE0000 ===> 0x80900000 ===> 0x20200000

This series (prototype) is on Github:
https://github.com/nicolinc/iommufd/commits/vfio_msi_giova-rfcv1/
It's tested by hacking the host kernel to hard-code a stage-2 mapping.

Thanks!
Nicolin

Nicolin Chen (7):
  genirq/msi: Allow preset IOVA in struct msi_desc for MSI doorbell
    address
  irqchip/gic-v3-its: Bypass iommu_cookie if desc->msi_iova is preset
  PCI/MSI: Pass in msi_iova to msi_domain_insert_msi_desc
  PCI/MSI: Allow __pci_enable_msi_range to pass in iova
  PCI/MSI: Extract a common __pci_alloc_irq_vectors function
  PCI/MSI: Add pci_alloc_irq_vectors_iovas helper
  vfio/pci: Allow preset MSI IOVAs via VFIO_IRQ_SET_ACTION_PREPARE

 drivers/pci/msi/msi.h             |   3 +-
 include/linux/msi.h               |  11 +++
 include/linux/pci.h               |  18 ++++
 include/linux/vfio_pci_core.h     |   1 +
 include/uapi/linux/vfio.h         |   8 +-
 drivers/irqchip/irq-gic-v3-its.c  |  21 ++++-
 drivers/pci/msi/api.c             | 136 ++++++++++++++++++++----------
 drivers/pci/msi/msi.c             |  20 +++--
 drivers/vfio/pci/vfio_pci_intrs.c |  41 ++++++++-
 drivers/vfio/vfio_main.c          |   3 +
 kernel/irq/msi.c                  |   6 ++
 11 files changed, 212 insertions(+), 56 deletions(-)

-- 
2.43.0


