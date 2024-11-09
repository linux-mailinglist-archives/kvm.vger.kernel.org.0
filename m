Return-Path: <kvm+bounces-31341-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 797CB9C2A6B
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2024 06:51:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0A3F41F221E0
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2024 05:51:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7409155326;
	Sat,  9 Nov 2024 05:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Z6bmEvCY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2084.outbound.protection.outlook.com [40.107.94.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7DD14F123;
	Sat,  9 Nov 2024 05:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731131363; cv=fail; b=TYylpRAQPvvGc7nasOF0bPya5keR322nD9UdLnmdHh6J7Ha/kpgx+df2CxQLpQrphDpSHku9snwn+8q1EuFpNwDKMrMZyqyRB4oLNkFOXUju9ysXSBeBYuiAXQOsTbCxusym1Xf3B84/DrjRsV78lvHiQ4pGyXVf649U+iVgNuw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731131363; c=relaxed/simple;
	bh=fWWVhuTgIN+k4aCR4wZtrLhtBFrDVpDURMi9/t/A1cM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J7kO7zkwhxdLI6DZg88Kh+K8J1ZRhTICO8/xtFJIKjUuxzsVT3cnyYx0OZN/Us4apB6bkHwnOVFZWllttuFDH4i8GPa5SrrK2M2CCmr4T5qsGodtcXtjdjHblVL7v1tDKiDgDR0krotQnZCFFKCJzM8AbjJiu46pXiEEAOLJN58=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Z6bmEvCY; arc=fail smtp.client-ip=40.107.94.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DD3rD0o7L7KNV7xADbDvxWZ/kJprdmyOS6nEQKV8HLSGqYxUkS7T7UUwYncORRT3MuT1fze100i9+PzPoSd1vNTY/3ww6QajclZCtfpB7QbwOkKwtsXt3OXho5m/epNXz22fyvpJUOVcGN6YW2CcK0JmtSSFQiiQYUMtoLlZYebrvx92L4aQzxGISW4LwCQGFpfSa5IhresMSokLLRMzD65t5HuBa/dFyfhhX8a1343PFnE63vqB/yDz+oQHpdv4qRWPBRNzyVYkKxXhra0QBp5fSIGCXW0PgSvk5LgmWCt552LUcL0od2OAWgjAK5PQ0q27AWMwWJUvIRIUyDpK3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AtB4Nuk3NENW+kApVPhvU7iI6WEUv4ZRQySPYM2noOs=;
 b=ojRdGwIUVth2XPvrlV83XEcTag6+rxzHMj7GFsEqMj5NWrC+iqU/XOjj3O40DS/7pjDGMqBf3L82QHDVKyN8LAwjGN9QztL6FWONphDzT/JhvGds5sto2bf+eHpMaCDVrQny1rAs+d0I83GRp00fZPC8IUSvH/0I8DF119x5B3zX2NUHDfeppcb8uFSXBxY3bc7QkYAoInjsUOWzaF7AIRUB40P/Hlv5F4dNjwYqfKxpgv2lg9Mgz7AFi77VS/NK3LrqFo0s2KjTMsSqwofx1pc8rnWrKPaoD7ODHLxMCZvqlvpSt2sM4QZUfLH/0HuJeKeWFia+u958eMrtYtIh+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AtB4Nuk3NENW+kApVPhvU7iI6WEUv4ZRQySPYM2noOs=;
 b=Z6bmEvCYADAsWltbQQ6DOkWJluZtJ9s2STKtN43jgQhEKsmRBTrTCFiObVJhQvSVUTjvA/x06nU3vJXWA0EsW25CyNEXPihe+tD46ZTpThPtBDvnV6Z08sS6hII9SbBtGu9CtbFMDbp3brr9VJMKpWJ0oBKJtoJLzx1QDQtYr1beQYCjrvtRPdYaZSQQtwdDGZeuTbSQVg3ahw9O2iff6yDShR4TAcuocRgDhg/JZWWkWdXL1rML4BxiguSmefsAoUD+iyKi2RC9vHGuNF6oKWvE6up5SBR8F/uncI61rzgYmd1w7kgQmP9uQPdPyTayuEjWf5pJi7ou1GuKVWdgkw==
Received: from BN9PR03CA0253.namprd03.prod.outlook.com (2603:10b6:408:ff::18)
 by DM6PR12MB4451.namprd12.prod.outlook.com (2603:10b6:5:2ab::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.21; Sat, 9 Nov
 2024 05:49:16 +0000
Received: from BL02EPF0001A104.namprd05.prod.outlook.com
 (2603:10b6:408:ff:cafe::2e) by BN9PR03CA0253.outlook.office365.com
 (2603:10b6:408:ff::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.21 via Frontend
 Transport; Sat, 9 Nov 2024 05:49:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL02EPF0001A104.mail.protection.outlook.com (10.167.241.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.17 via Frontend Transport; Sat, 9 Nov 2024 05:49:15 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 8 Nov 2024
 21:49:06 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 8 Nov 2024 21:49:05 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 8 Nov 2024 21:49:04 -0800
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
Subject: [PATCH RFCv1 7/7] vfio/pci: Allow preset MSI IOVAs via VFIO_IRQ_SET_ACTION_PREPARE
Date: Fri, 8 Nov 2024 21:48:52 -0800
Message-ID: <07623edc330420376e235607285a0f56b54787f2.1731130093.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1731130093.git.nicolinc@nvidia.com>
References: <cover.1731130093.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A104:EE_|DM6PR12MB4451:EE_
X-MS-Office365-Filtering-Correlation-Id: 898678ff-363d-4644-f709-08dd00823ee2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4RGZzPd0VzgeAZB96EogBoPROCYecdCFNJKjuqpVSdZIWrM21uOMeRDfslRi?=
 =?us-ascii?Q?HxHgaKIDQyhuTpCOfy6lyng/pa3h6lj1fnDdDY+szsz/zqocJx8we8mMTB1G?=
 =?us-ascii?Q?UMS9f3G/iRx6SBQl34QV+lTNkUne/iKNPTzJ8wi44SZSS1UW5ulRe3v5E6LW?=
 =?us-ascii?Q?jgfMmhAVTQ+Yxmj9cZV4xPG6T+GWlS6pu3GgjqQ1HLWPJ+an+cvhnSt5zAv3?=
 =?us-ascii?Q?X44rvYhZJserliTGicLU13mkZS6G6qF9G6uyG5xqnrArXAniW+5nAYirVpq9?=
 =?us-ascii?Q?z5hyvhgN7VkioNevU4GA7UyZTHAUpI9tiCAmkz3KQjx5g0cpEI7z4xOpgaEp?=
 =?us-ascii?Q?YIK61SI8XLHhzy7/hOZflcgpxJcCgiPmLkO6MK59C7Xm83xqsdQWbETlYO27?=
 =?us-ascii?Q?v01Uqw24yz4kgHDHu9nGh0gYQiR6Rc07Dq23qgI4AikTLHpRH5hD6mGwY92I?=
 =?us-ascii?Q?u7SkP8rvEAs/HRPUcf1i63r4zJ1Rhnu2EPJV1tX8rxDrofbdhcpUIyx8xXR+?=
 =?us-ascii?Q?pOAUmK0ulE3QUjOCgtUu3spKxHpb4LtBk9QPwxZk4uDDdGq7Bj98wAxmBcpK?=
 =?us-ascii?Q?sex3FOlO02ZxN7UoUy0NI7vFGZt7V8BVW2X0nzkh2NvGYenqkQgqtd+Q9i1v?=
 =?us-ascii?Q?25hzDOl4neLHZk0NGPipSLQfPz3blqodfGcHnhYyBpgM2IrHnDX3eEeXsO3P?=
 =?us-ascii?Q?RAbEHlNVe8pJmVu3tx3Oi9dFEc0zIPbKRw3xd+gp+wKUeJygnu00sfrWo/ef?=
 =?us-ascii?Q?98jTWMnTmeVIXXB1Yia1XjjS4vi4SkobnS3KHLVYN1BCz3WT9M5SQbjX7KOq?=
 =?us-ascii?Q?Avm/66MeWcptuvNsWtIIOOL6DL14u5dYiSGsk04r1MPJMrNEktTkgTUdUEuh?=
 =?us-ascii?Q?3svwpgJJ3PmEVRVnxowSWt9r3/pJB4JRt7oTCQV5765TWn/qr48lay59LkUq?=
 =?us-ascii?Q?xza2kJvlROc5jglpIAeoG+Wp+svBz0wESY0dM/kSV9MuXpupCxKU1IwWY0WA?=
 =?us-ascii?Q?7AA/s7yC2MuCi+CZ3iVHBFKwO4swZIqODUClajQY4rU3eCoXKbQjV6bC+e3Y?=
 =?us-ascii?Q?z73MT2oFMP3YGkPLbaD4J3AyTv2ycdexADB86Pz2JXB5u4hHpNK8CQ+ZiAfP?=
 =?us-ascii?Q?WEbpwsEIpw+z5M50Ww5tHnEoII+FqLfQX8Ju7MU3Sgpin2yxlmACfljDSZsQ?=
 =?us-ascii?Q?VWNRIk8eCy5wSvMabhk5L8Tix3anxvzw7I9WfCP416JezQrWtXVj0+ZON7g3?=
 =?us-ascii?Q?lz4vJadC5kvH5+v5ybSIlW8i+hM+av2WVy/xtiljdP+L4CF/xHe/9mvOmXCZ?=
 =?us-ascii?Q?wEpe7ubCBarhqE9CQsFYIXw6r5M0jzayiW9iLoZG5fxzve04tTXzH98jYM0+?=
 =?us-ascii?Q?EMq8RbePLR3jT5oKcdJeep6oGZ2rDqf32aZCk7cIpA7HMgqiHQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2024 05:49:15.5882
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 898678ff-363d-4644-f709-08dd00823ee2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A104.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4451

Add a new VFIO_IRQ_SET_ACTION_PREPARE to set VFIO_IRQ_SET_DATA_MSI_IOVA,
giving user space an interface to forward to kernel the stage-1 IOVA (of
a 2-stage translation: IOVA->IPA->PA) for an MSI doorbell address, since
the ITS hardware needs to be programmed with the top level IOVA address,
in order to work with the IOMMU on ARM64.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 include/linux/vfio_pci_core.h     |  1 +
 include/uapi/linux/vfio.h         |  8 ++++--
 drivers/vfio/pci/vfio_pci_intrs.c | 41 ++++++++++++++++++++++++++++++-
 drivers/vfio/vfio_main.c          |  3 +++
 4 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index fbb472dd99b3..08027b8331f0 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -63,6 +63,7 @@ struct vfio_pci_core_device {
 	int			irq_type;
 	int			num_regions;
 	struct vfio_pci_region	*region;
+	dma_addr_t		*msi_iovas;
 	u8			msi_qmax;
 	u8			msix_bar;
 	u16			msix_size;
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 2b68e6cdf190..d6be351abcde 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -590,6 +590,8 @@ struct vfio_irq_set {
 #define VFIO_IRQ_SET_ACTION_MASK	(1 << 3) /* Mask interrupt */
 #define VFIO_IRQ_SET_ACTION_UNMASK	(1 << 4) /* Unmask interrupt */
 #define VFIO_IRQ_SET_ACTION_TRIGGER	(1 << 5) /* Trigger interrupt */
+#define VFIO_IRQ_SET_DATA_MSI_IOVA	(1 << 6) /* Data is MSI IOVA (u64) */
+#define VFIO_IRQ_SET_ACTION_PREPARE	(1 << 7) /* Prepare interrupt */
 	__u32	index;
 	__u32	start;
 	__u32	count;
@@ -599,10 +601,12 @@ struct vfio_irq_set {
 
 #define VFIO_IRQ_SET_DATA_TYPE_MASK	(VFIO_IRQ_SET_DATA_NONE | \
 					 VFIO_IRQ_SET_DATA_BOOL | \
-					 VFIO_IRQ_SET_DATA_EVENTFD)
+					 VFIO_IRQ_SET_DATA_EVENTFD | \
+					 VFIO_IRQ_SET_DATA_MSI_IOVA)
 #define VFIO_IRQ_SET_ACTION_TYPE_MASK	(VFIO_IRQ_SET_ACTION_MASK | \
 					 VFIO_IRQ_SET_ACTION_UNMASK | \
-					 VFIO_IRQ_SET_ACTION_TRIGGER)
+					 VFIO_IRQ_SET_ACTION_TRIGGER | \
+					 VFIO_IRQ_SET_ACTION_PREPARE)
 /**
  * VFIO_DEVICE_RESET - _IO(VFIO_TYPE, VFIO_BASE + 11)
  *
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 8382c5834335..18bcdc5b1ef5 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -383,7 +383,7 @@ static int vfio_msi_enable(struct vfio_pci_core_device *vdev, int nvec, bool msi
 
 	/* return the number of supported vectors if we can't get all: */
 	cmd = vfio_pci_memory_lock_and_enable(vdev);
-	ret = pci_alloc_irq_vectors(pdev, 1, nvec, flag);
+	ret = pci_alloc_irq_vectors_iovas(pdev, 1, nvec, flag, vdev->msi_iovas);
 	if (ret < nvec) {
 		if (ret > 0)
 			pci_free_irq_vectors(pdev);
@@ -685,6 +685,9 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
 
 	if (irq_is(vdev, index) && !count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
 		vfio_msi_disable(vdev, msix);
+		/* FIXME we need a better cleanup routine */
+		kfree(vdev->msi_iovas);
+		vdev->msi_iovas = NULL;
 		return 0;
 	}
 
@@ -728,6 +731,39 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
 	return 0;
 }
 
+static int vfio_pci_set_msi_prepare(struct vfio_pci_core_device *vdev,
+				    unsigned index, unsigned start,
+				    unsigned count, uint32_t flags, void *data)
+{
+	uint64_t *iovas = data;
+	unsigned int i;
+
+	if (!(irq_is(vdev, index) || is_irq_none(vdev)))
+		return -EINVAL;
+
+	if (flags & VFIO_IRQ_SET_DATA_NONE) {
+		if (!count)
+			return -EINVAL;
+		/* FIXME support partial unset */
+		kfree(vdev->msi_iovas);
+		vdev->msi_iovas = NULL;
+		return 0;
+	}
+
+	if (!(flags & VFIO_IRQ_SET_DATA_MSI_IOVA))
+		return -EOPNOTSUPP;
+	if (!IS_ENABLED(CONFIG_IRQ_MSI_IOMMU))
+		return -EOPNOTSUPP;
+	if (!vdev->msi_iovas)
+		vdev->msi_iovas = kcalloc(count, sizeof(dma_addr_t), GFP_KERNEL);
+	if (!vdev->msi_iovas)
+		return -ENOMEM;
+	for (i = 0; i < count; i++)
+		vdev->msi_iovas[i] = iovas[i];
+
+	return 0;
+}
+
 static int vfio_pci_set_ctx_trigger_single(struct eventfd_ctx **ctx,
 					   unsigned int count, uint32_t flags,
 					   void *data)
@@ -837,6 +873,9 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
 		case VFIO_IRQ_SET_ACTION_TRIGGER:
 			func = vfio_pci_set_msi_trigger;
 			break;
+		case VFIO_IRQ_SET_ACTION_PREPARE:
+			func = vfio_pci_set_msi_prepare;
+			break;
 		}
 		break;
 	case VFIO_PCI_ERR_IRQ_INDEX:
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index a5a62d9d963f..61211c082a64 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1554,6 +1554,9 @@ int vfio_set_irqs_validate_and_prepare(struct vfio_irq_set *hdr, int num_irqs,
 	case VFIO_IRQ_SET_DATA_EVENTFD:
 		size = sizeof(int32_t);
 		break;
+	case VFIO_IRQ_SET_DATA_MSI_IOVA:
+		size = sizeof(uint64_t);
+		break;
 	default:
 		return -EINVAL;
 	}
-- 
2.43.0


