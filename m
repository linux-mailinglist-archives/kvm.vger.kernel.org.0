Return-Path: <kvm+bounces-31338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F0849C2A62
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2024 06:50:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A26501F214DB
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2024 05:50:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC5B914A60A;
	Sat,  9 Nov 2024 05:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="c9uet8y9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2055.outbound.protection.outlook.com [40.107.237.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52BBE146017;
	Sat,  9 Nov 2024 05:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731131354; cv=fail; b=GOx3GhLYNNDDeuD1MEl49BYM8648/DZYb1uLwqWZ7iOOQOB2HTEplaEElZxWti29Ziy/ieffCwXOQcG9cO41vzFofv/iTipRcltR4q8FBXu284GzmGIaTafpjmpjwK1afhQOgNhbJI/gFpSA/aeJV/ngkWE/bID7K3pXA8madKY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731131354; c=relaxed/simple;
	bh=VnEMmiaRgkL4C/i+0GkJb+PpJHjLpECLTKZqGdwB7ME=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bs/xymkSlgENk1uAzYw1BXjxS9B/ijdHIPzqdK21RvxxYJbI1sf+BkcFYJF+a23tLXDqTS5TL50TuGtu3+VSdiAweL98W1ce+DjytboKq0QuJ68T5HcofovSlaVcZ0dXKthiYacqBlidzv/bBZSS+DU96khZMkHIUluDHSLoSws=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=c9uet8y9; arc=fail smtp.client-ip=40.107.237.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=US4K42SuNqFEK6PQ32VQN7J7Rr6oqUS+X3rXfswDJhNFpMh4OjZdkJZonTiMRnavJs9Sim81FG27sbiZfZwbCDBAfXvKGv5WFJOtij19hsnM1jJlYV13q2pctU4a1z/BB2MCtKISVuyYHwlfbKQN2VHU+gaEwxTl05G6S6H9Ec8zLfwfRh74HNcSTzIaA+T3SRVDcCKg1pw2JlnzlY8f9Pf+LuZ8oH+DGq5CuSwnoBhf9hPluoeDMSnKCT+Y02V04BCn2/dxIDulYtFQ8turbVv5XlmT2KjBiEwPMErW0NwlLgcM1li/aY1YvXbkyxUzxDWnw2ADw8dprGhr0adXpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ubjJGxVvR0IyR7uOemJ+yodiGotqSCH73iEvc6maiKI=;
 b=GpYSEN0e5xLjAc3ON3BLzYzYfqjQ3TAfJU4/qI2Qu49gonXIfO8LTRo7gvzvTj4leG9R5+sI77Blc08bRRZjGZxKOOIpxM/4v/2vkPC8MYl+zKBRwQ2ZIIVwoblWFzNuXb6m2eW9CCOP8rjqh0uEQYtVVsy0maQTHw1s+hGe0qhs87sA+ep7Y14XwCE5AaGJqUMPTwXaSboQOtcxVv5h9Z8U1di/g3/rfXQbGMAVKwkOjPX8hcvV4UX8o60BJNDDJQGgq0/l/F4rqmnfg8QEVFzqnOCFZ4lmp8ci0ULV4IWxDjYhAEjPQiiB48Dy2tqbR7coI+OJ6jj/Vzvn/mdhgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ubjJGxVvR0IyR7uOemJ+yodiGotqSCH73iEvc6maiKI=;
 b=c9uet8y9QeJI+pWsC+GHvzY7182QoYe6S/musLxj8mwzSJffnMcPKqhPn2X0Y3/xHVxFdKdV2P+8eKfuJi5YwKtUJ65TsVlbJ4zHJsUvsbEwEGx9lD/kcB97fTzNzzcvV7cFbJXIyOiWqcShRX9xTcdD04pJqGOXU2evLrDwXxjk5UNKMNIgutjjJIwzfm+cC4neueGI3IZmsLJZ6/d/NTVO9AEdeUCUyBjpUhRgtbymozgA7CMjbmPRC2YlAIH05im1mRW9MSsvV4iAErnsMvBxf2J472G9qowOgyYmML6N98S2zgDbYuBx/R3c0yNmJZgwhf3Ibh+xooTX2FidYQ==
Received: from SJ0PR03CA0350.namprd03.prod.outlook.com (2603:10b6:a03:39c::25)
 by DM3PR12MB9413.namprd12.prod.outlook.com (2603:10b6:8:1af::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20; Sat, 9 Nov
 2024 05:49:06 +0000
Received: from SJ1PEPF00001CE8.namprd03.prod.outlook.com
 (2603:10b6:a03:39c:cafe::2f) by SJ0PR03CA0350.outlook.office365.com
 (2603:10b6:a03:39c::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.21 via Frontend
 Transport; Sat, 9 Nov 2024 05:49:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF00001CE8.mail.protection.outlook.com (10.167.242.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.17 via Frontend Transport; Sat, 9 Nov 2024 05:49:05 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 8 Nov 2024
 21:49:04 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 8 Nov 2024 21:49:04 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 8 Nov 2024 21:49:03 -0800
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
Subject: [PATCH RFCv1 6/7] PCI/MSI: Add pci_alloc_irq_vectors_iovas helper
Date: Fri, 8 Nov 2024 21:48:51 -0800
Message-ID: <e9399426b08b16efbdf7224c0122f5bf80f6d0ea.1731130093.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE8:EE_|DM3PR12MB9413:EE_
X-MS-Office365-Filtering-Correlation-Id: 81d2d01d-8d46-48b0-deda-08dd008238d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0E/YFO/Kzn+RYX+eaPQLSEKCnx1s9jeJBxXoYYNmiyuqg7tRRaQ1SxhzYdqW?=
 =?us-ascii?Q?RLS0TfFFAOMtJsvBFSOirKWOPIkwJDNNHY23eTD5Xf257Yd+gmMOKrmXa6YD?=
 =?us-ascii?Q?9eC/bfSNwRBSw7VJ0rnVWA42Nx21fYNicaq4sx3jQoEdB6ikNAcr+kywv7sv?=
 =?us-ascii?Q?9G1q8uqpe8mMb4+N4v1tnQ+HcJ/iL7iJRPCclAMbX5qwN8qkjT8OqbY7e13f?=
 =?us-ascii?Q?vpXJT3ayraDXY/aUl7I0dz/Eax8tCLFVu+qV+lpoMSKGUJBT5DtxRk3uKQ+b?=
 =?us-ascii?Q?K1H6XiVNdeXmrTrTcvLvPJPfqC6X5AJRE181B6n41rsxIxcKmQ6/Ou341VdS?=
 =?us-ascii?Q?Z7Bah3/nAGJ8pPUaGO8/bbGYkriNCHXSlhr3vDbrt0Sm5oJ8osh4dULKj0O8?=
 =?us-ascii?Q?ihJLsjjytf7W0wTPMPGQEWM2L2ncKP4L/KhB7O/+JU6+9U5oI5277liOBr8e?=
 =?us-ascii?Q?1fxW+75zhFpqzNyc89RAMepQirVqxNV2P+LDmy/3N4VUq9NjX7/pYqQt4xGw?=
 =?us-ascii?Q?KrOYK/TI8QsYkqyl3nJDtWR9laAw77rUTb8qKWCn8foi0lYcrI8hgoUOY9pj?=
 =?us-ascii?Q?CwWOtOQVLuCbeKfmsxm7SCAk50JzRSFXChz/mlWHTaS2RGLKFprHole98yfG?=
 =?us-ascii?Q?hZpK62JHPlZU4B0X8Lfbeh/NFNNHorTZojmIpK0HnL6wHYqstOvTgUe+3Rul?=
 =?us-ascii?Q?4pZeh19a/hFElRtrJgzLZT3oRapDF7TnqDcxmjA+aqbJdIMqrn+HzaamecgZ?=
 =?us-ascii?Q?4eZ49LBaXRc3vNUDIV9UPTFuCndrDHxs1KOmvIS1xXgn0bNwBCRVGOVQSjPd?=
 =?us-ascii?Q?gBf20QAOC0Z8RsIrgYqs5M69kmc6XqbbpoahdDOZBbb0lpbt3Oe0RSbNtOIc?=
 =?us-ascii?Q?j3kOs3q6S/z0FBkBPPVAN1Q13IiwsFeU0SGvS7dsudDnPj/71bXtGpTFizCl?=
 =?us-ascii?Q?gXnMwChSbB/9d5HYrG6rVBrob0bR5AueuT8DkfttiOBu2FfOf38qFhhnSSkJ?=
 =?us-ascii?Q?SZuGGxGHp+U1otWv/ON+LxNltQ+GMd1+jn2oKVeIEnifXJ9jB75ny8XYtzfY?=
 =?us-ascii?Q?PaYuutcNeZX4djWID6IfewETTgjFfvTmtGUhwIn3JrsqilTp3GmZ6DJpHjW+?=
 =?us-ascii?Q?PuG+KaAcHDSdGoU+Cc3DuJ4+T8fERPwsmomcILBeL+6g0dvWqaxTtMFOW4J6?=
 =?us-ascii?Q?o7aWJb9ciQDd9jYZWt+g3xKvyWIdZk+1WQ+PMumVZeIjEuU/ZEJ9//z1Jots?=
 =?us-ascii?Q?MmshwFPL91PnzpKfK5C448I20gEg1uyq/swpe/0Cgi9Zex4c6RzzHaVtR3RO?=
 =?us-ascii?Q?Mq3boFLRgFd4dRCm1mHVuyCRRzjMECUzDrsdOATl8+OuwTRyEkS2oamjUyhg?=
 =?us-ascii?Q?hZvi11GLYy6tuZl+rJU7Q8kfBeclx/mr0hDkpR/xfnYaiVsMxw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2024 05:49:05.5258
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 81d2d01d-8d46-48b0-deda-08dd008238d2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE8.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9413

Now, the common __pci_alloc_irq_vectors() accepts an array of msi_iovas,
which is a list of preset IOVAs for MSI doorbell addresses.

Add a helper that would pass in a list. A following patch will call this
to forward msi_iovas from user space.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 include/linux/pci.h   | 17 +++++++++++++++++
 drivers/pci/msi/api.c | 21 +++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 68ebb9d42f7f..6423bee3b207 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1678,6 +1678,9 @@ int pci_alloc_irq_vectors(struct pci_dev *dev, unsigned int min_vecs,
 int pci_alloc_irq_vectors_affinity(struct pci_dev *dev, unsigned int min_vecs,
 				   unsigned int max_vecs, unsigned int flags,
 				   struct irq_affinity *affd);
+int pci_alloc_irq_vectors_iovas(struct pci_dev *dev, unsigned int min_vecs,
+				unsigned int max_vecs, unsigned int flags,
+				dma_addr_t *msi_iovas);
 
 bool pci_msix_can_alloc_dyn(struct pci_dev *dev);
 struct msi_map pci_msix_alloc_irq_at(struct pci_dev *dev, unsigned int index,
@@ -1714,6 +1717,13 @@ pci_alloc_irq_vectors_affinity(struct pci_dev *dev, unsigned int min_vecs,
 	return -ENOSPC;
 }
 static inline int
+pci_alloc_irq_vectors_iovas(struct pci_dev *dev, unsigned int min_vecs,
+			    unsigned int max_vecs, unsigned int flags,
+			    dma_addr_t *msi_iovas)
+
+	return -ENOSPC; /* No support if !CONFIG_PCI_MSI */
+}
+static inline int
 pci_alloc_irq_vectors(struct pci_dev *dev, unsigned int min_vecs,
 		      unsigned int max_vecs, unsigned int flags)
 {
@@ -2068,6 +2078,13 @@ pci_alloc_irq_vectors_affinity(struct pci_dev *dev, unsigned int min_vecs,
 	return -ENOSPC;
 }
 static inline int
+pci_alloc_irq_vectors_iovas(struct pci_dev *dev, unsigned int min_vecs,
+			    unsigned int max_vecs, unsigned int flags,
+			    dma_addr_t *msi_iovas)
+{
+	return -ENOSPC;
+}
+static inline int
 pci_alloc_irq_vectors(struct pci_dev *dev, unsigned int min_vecs,
 		      unsigned int max_vecs, unsigned int flags)
 {
diff --git a/drivers/pci/msi/api.c b/drivers/pci/msi/api.c
index dff3d7350b38..4e90ef8f571c 100644
--- a/drivers/pci/msi/api.c
+++ b/drivers/pci/msi/api.c
@@ -327,6 +327,27 @@ int pci_alloc_irq_vectors_affinity(struct pci_dev *dev, unsigned int min_vecs,
 }
 EXPORT_SYMBOL(pci_alloc_irq_vectors_affinity);
 
+/**
+ * pci_alloc_irq_vectors_iovas() - Allocate multiple device interrupt
+ *                                 vectors with preset msi_iovas
+ * @dev:       the PCI device to operate on
+ * @min_vecs:  minimum required number of vectors (must be >= 1)
+ * @max_vecs:  maximum desired number of vectors
+ * @flags:     allocation flags, as in pci_alloc_irq_vectors()
+ * @msi_iovas: list of IOVAs for MSI between [min_vecs, max_vecs]
+ *
+ * Same as pci_alloc_irq_vectors(), but with the extra @msi_iovas parameter.
+ * Check that function docs, and &struct irq_affinity, for more details.
+ */
+int pci_alloc_irq_vectors_iovas(struct pci_dev *dev, unsigned int min_vecs,
+				unsigned int max_vecs, unsigned int flags,
+				dma_addr_t *msi_iovas)
+{
+	return __pci_alloc_irq_vectors(dev, min_vecs, max_vecs,
+				       flags, NULL, msi_iovas);
+}
+EXPORT_SYMBOL(pci_alloc_irq_vectors_iovas);
+
 /**
  * pci_irq_vector() - Get Linux IRQ number of a device interrupt vector
  * @dev: the PCI device to operate on
-- 
2.43.0


