Return-Path: <kvm+bounces-31339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A1C09C2A65
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2024 06:51:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AF8C31F213F8
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2024 05:50:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DA2A14EC73;
	Sat,  9 Nov 2024 05:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Vs4BBe/q"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2057.outbound.protection.outlook.com [40.107.92.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 987FD14BF8F;
	Sat,  9 Nov 2024 05:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731131358; cv=fail; b=SPjnf0PoMGPcPUubHoERUJMTk3CXAnS5UT4WO9OOR3Ma+qb65pbjLKkcO0G+pxw9wvo/rVLpNmr7q5gnHXIC7hZ8SDfsY7xBFWSAKHr2llSxsxFlUK3gpKMyaI9sw237zPU1XUB6MkWCs/10Q1EMvCvjnmM/24uxrBBJSL5RvIY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731131358; c=relaxed/simple;
	bh=bXFYO9rTdO6i2O/H47RIRRSCcdl5k5Z7u1d2cCLTd/Q=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J0oO5EnW7FE4kIlVl1VO7uqWOOQLxKIf+dMjWLYAKHgaArKtQjbrqCDwHrhdlPsSnkOx/EVrwSxd7+Bgzlx3W/za031unrbD6Yi9vRzltb7n0QcBIYAc+VFs4O6+63tWsZmQm4Exgqba+cWac6X+6BFoqkebWWam31fhkR9kbgk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Vs4BBe/q; arc=fail smtp.client-ip=40.107.92.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V19DnOCfd36gGSO+A/Bb93wEjA1lZ0qI8TqhDJi2GhPrq35zNUQ2Gva5CnSuyzJWvmMRPxMnSw/oI+S+Qu/rsrxY3puQ7sq1dLyHmtuSpenzFBT5q7JQZITTJXtFAX2gRAg1eGgvi3g+zYbHWGVhWQ/ytR5JaCoDCQZTGEDVVZavtuNEV/INld4wumkvDEM2JeP6q1U+wCXGQq8VfdEfpy6JPl9ivuO8yAPGYcDKELOojYZU1sr+qLnBmL9ADgiuYPv9hSd8l9ht8NzK3a8xXLzTnLcMqqwtSPgdPhP6qxedJq1mlMz/LkPksMyFrkjJISYbzZYt8zJINZUCQS3xsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+91tI5iywXyBRXTWmayMkejXNh87K1xSpnzg/y9ISXE=;
 b=n1piVh0feFcTSJpbk0p9pcRjqGAXrhFtIRV88HQXNsqjrJwm7XszU2ojSX5d7VnJsqeVr2uyuSYPGsspQtlNZZWtJrIiIBbU1exAPJWeEFkbgZu/+xEPwR1CyfAWDWYsE/TvICZr1p26N35aytq3hfnupgM1m0p6FLDU9Wyd8HQblfpl1OUdtquZSIL+D5TrpleL8jXzGYayJIgXW5MA5bcvcHss0mv1lvC2jyeOACKgWG1ltBQW4miyvEuMi5u5KqspCB98iwln1fGGQ6d49X0COUm9/Hx1YR9iklW3YPc6AhpdcOeZIFBUPS0TUHgrT7QDRrbWH1evH/WaOIJrPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+91tI5iywXyBRXTWmayMkejXNh87K1xSpnzg/y9ISXE=;
 b=Vs4BBe/qpOPBDbc4pg3LEy2v3NPlIyeVfDU9+8ScQ7wu9R58OxCC2hMsAXmJRFtPM9kMfH+GHxM7w/Wp2AJcsnMsUCPm8BWz4TxSv+uL6pDmVzuWIsmMwN1ErVd0nc/CVolcMKUPbcDPfAhsu6x/OyJpDaPJ9kUbqeVsvkQoA1Yjai2TYV2IBAoaXBQiYKv3CaPHqWBv8x6gOUkD5mH0bj6KFqjy2QIhPx5GcRr8yzmngIVLNVGnwDxY9kM9E8AJLqK/rYBRdPtR94JgwgbiOt60+MLxeWbFvSZ6HjnEYcPqbMEKs8jFDu2fYtjGDbQy42463uaBM5Iz3mzczd+ffQ==
Received: from BN9PR03CA0252.namprd03.prod.outlook.com (2603:10b6:408:ff::17)
 by DS7PR12MB8372.namprd12.prod.outlook.com (2603:10b6:8:eb::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.22; Sat, 9 Nov 2024 05:49:09 +0000
Received: from BL02EPF0001A104.namprd05.prod.outlook.com
 (2603:10b6:408:ff:cafe::3c) by BN9PR03CA0252.outlook.office365.com
 (2603:10b6:408:ff::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20 via Frontend
 Transport; Sat, 9 Nov 2024 05:49:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL02EPF0001A104.mail.protection.outlook.com (10.167.241.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.17 via Frontend Transport; Sat, 9 Nov 2024 05:49:08 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 8 Nov 2024
 21:49:01 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 8 Nov 2024 21:49:01 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 8 Nov 2024 21:49:00 -0800
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
Subject: [PATCH RFCv1 4/7] PCI/MSI: Allow __pci_enable_msi_range to pass in iova
Date: Fri, 8 Nov 2024 21:48:49 -0800
Message-ID: <7406707cbcf225fe8f6ec3ce497bdcfc51f27afb.1731130093.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A104:EE_|DS7PR12MB8372:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a22acb9-c352-4df2-63ca-08dd00823ac0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+BxGLQyfguj1Hwk2IQFxNgNS/8XzZOQ0d+YklEHOPj3HusDo+AS++Y5mFjwO?=
 =?us-ascii?Q?pyLLdRrae+JaLcyXACFQ6iskc/sRbSAdyk/m/Due9m5ohc2RuFDlqKX+pcEE?=
 =?us-ascii?Q?DlCertcX+HZGQIWh5jjFmZzufR9OsscyWRyLCXKacHSrwENe1ckFg0rvYLpc?=
 =?us-ascii?Q?83H2VHL94/Eeyku7WfQjif0rMmzOxKIiAzvHid9MwX8BUj8yhiqWM77XO+g8?=
 =?us-ascii?Q?5okVLHe+lekTzXAHjS55p/1OdxFH6sa2TOGoUfAJa/gMWBP/w8M8JhfmPnUf?=
 =?us-ascii?Q?59LPAFnxNGnOCw3HhMwOowyjfs298jbIJH/cNV8AEF9iLyFUow0d9HQxLXqN?=
 =?us-ascii?Q?1ecZjESTpvcHf5qQQ6mMNAOsk7rLYT1kHMcBWruvtr4QEM4flgSYYCk65KlX?=
 =?us-ascii?Q?8/Ri5R3KpoFFOrQQVdhGao5ktboGbOljvG+vvwgiACL/NxREwNrX7CnsjPb5?=
 =?us-ascii?Q?ddGR9l8vY8DHMn4jr3dQZ+KJU1YWs2ttZYs/3/NuU7Bhsj97ShziyaHlWjaH?=
 =?us-ascii?Q?TBtV+bZ0upYeO7kieYAI+YsFoAAqyR9ZNeU5c4jxOYpKzBsGYXSwb+QdC+Br?=
 =?us-ascii?Q?ReodGVJURiYqX6Qxj0L7e9c2PtLwtzexJRHlw2/j+CSfZKI7flGg4sBg96Hw?=
 =?us-ascii?Q?LsYIKZkkNdVjI64IuruIt0D2Eln3UhvdWunAzVamzXvf8bBdcm9hnavshGoz?=
 =?us-ascii?Q?+CeReF6R5Vb8iR8bWjxgJl5lcGj7CeNIj3BVPmr7rG7VP+JhF0Jz0LkVFqy+?=
 =?us-ascii?Q?DLUG2wzXyXNdqPJw0T6eAz1R089QYfzXXEtHR2JdC3NKzAj0Nsaqfo3FropJ?=
 =?us-ascii?Q?x3yPQW0aUWEMTVHV+sWc1sYsa6lWMve2LbBgjVG8OnvzPVqU25M9Wpgj4aNH?=
 =?us-ascii?Q?7BNx11onfur+vErH515y6IoS0QBXHj6GQglpnrWFbV6n6HuQZiulQyERShX+?=
 =?us-ascii?Q?EFYKVFqhWm0x8fDJRHRKCLMXIv6HUWRJUpUMOCPlUqDzbe2+PB/X7C/ULIZk?=
 =?us-ascii?Q?QmEE42iNcQ6GU1X0CbhQ6pvxcj1BHtcgRsMPSxqno497m+ku82cz6v5EFucZ?=
 =?us-ascii?Q?lfy0bsPu9FnTzt4Tivka7A9fcvHVdnRRdl+1+W5+YnjUkBUGwfJP0IN46gmf?=
 =?us-ascii?Q?oCRDDIwU60uGg6/4Pi3bC6b87yBRLUqhERR6lNMibgBtTzhi8GkXM5G1vTWh?=
 =?us-ascii?Q?gRTJMFir1t0RNl8++8nYuXUAWEibuUh/V6FRIyrZy45axEgvxR3y+M4FFAN+?=
 =?us-ascii?Q?7crVnVnZjhq/6E/U4VasL+NOEMIw5l0VMclHvRH9xYjZOHdSid9PiAMwlFIE?=
 =?us-ascii?Q?b99aYH5/zvmykFMBwTTdRa9TVJPO04WztyF4+367bcOhk78+TvNKJcAf6i1E?=
 =?us-ascii?Q?H8OWm8OR5iGy1y5+Ys2Eal1jEMDdkgNYWBsP8hYayV/nf/lZvw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2024 05:49:08.6351
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a22acb9-c352-4df2-63ca-08dd00823ac0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A104.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8372

The previous patch passes in the msi_iova to msi_capability_init, so this
allows its caller to do the same.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/pci/msi/msi.h | 3 ++-
 drivers/pci/msi/api.c | 6 ++++--
 drivers/pci/msi/msi.c | 4 ++--
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/msi/msi.h b/drivers/pci/msi/msi.h
index ee53cf079f4e..8009d69bf9a5 100644
--- a/drivers/pci/msi/msi.h
+++ b/drivers/pci/msi/msi.h
@@ -93,7 +93,8 @@ extern int pci_msi_enable;
 void pci_msi_shutdown(struct pci_dev *dev);
 void pci_msix_shutdown(struct pci_dev *dev);
 void pci_free_msi_irqs(struct pci_dev *dev);
-int __pci_enable_msi_range(struct pci_dev *dev, int minvec, int maxvec, struct irq_affinity *affd);
+int __pci_enable_msi_range(struct pci_dev *dev, int minvec, int maxvec,
+			   struct irq_affinity *affd, dma_addr_t iova);
 int __pci_enable_msix_range(struct pci_dev *dev, struct msix_entry *entries, int minvec,
 			    int maxvec,  struct irq_affinity *affd, int flags);
 void __pci_restore_msi_state(struct pci_dev *dev);
diff --git a/drivers/pci/msi/api.c b/drivers/pci/msi/api.c
index b956ce591f96..99ade7f69cd4 100644
--- a/drivers/pci/msi/api.c
+++ b/drivers/pci/msi/api.c
@@ -29,7 +29,8 @@
  */
 int pci_enable_msi(struct pci_dev *dev)
 {
-	int rc = __pci_enable_msi_range(dev, 1, 1, NULL);
+	int rc = __pci_enable_msi_range(dev, 1, 1, NULL,
+					PHYS_ADDR_MAX);
 	if (rc < 0)
 		return rc;
 	return 0;
@@ -274,7 +275,8 @@ int pci_alloc_irq_vectors_affinity(struct pci_dev *dev, unsigned int min_vecs,
 	}
 
 	if (flags & PCI_IRQ_MSI) {
-		nvecs = __pci_enable_msi_range(dev, min_vecs, max_vecs, affd);
+		nvecs = __pci_enable_msi_range(dev, min_vecs, max_vecs,
+					       affd, PHYS_ADDR_MAX);
 		if (nvecs > 0)
 			return nvecs;
 	}
diff --git a/drivers/pci/msi/msi.c b/drivers/pci/msi/msi.c
index 95caa81d3421..25da0435c674 100644
--- a/drivers/pci/msi/msi.c
+++ b/drivers/pci/msi/msi.c
@@ -417,7 +417,7 @@ static int msi_capability_init(struct pci_dev *dev, int nvec,
 }
 
 int __pci_enable_msi_range(struct pci_dev *dev, int minvec, int maxvec,
-			   struct irq_affinity *affd)
+			   struct irq_affinity *affd, dma_addr_t iova)
 {
 	int nvec;
 	int rc;
@@ -460,7 +460,7 @@ int __pci_enable_msi_range(struct pci_dev *dev, int minvec, int maxvec,
 				return -ENOSPC;
 		}
 
-		rc = msi_capability_init(dev, nvec, affd, PHYS_ADDR_MAX);
+		rc = msi_capability_init(dev, nvec, affd, iova);
 		if (rc == 0)
 			return nvec;
 
-- 
2.43.0


