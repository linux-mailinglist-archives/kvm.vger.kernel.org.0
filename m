Return-Path: <kvm+bounces-31337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 603309C2A5F
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2024 06:50:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83DF71C2083A
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2024 05:50:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1993313B2A2;
	Sat,  9 Nov 2024 05:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="X0x/5xTN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2069.outbound.protection.outlook.com [40.107.92.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795CC145B03;
	Sat,  9 Nov 2024 05:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731131350; cv=fail; b=HVnsw0bioB5CgPWFa7I1tNFmotV9ASySEKvQc1jKh146nu01bGbxifXRTRWive9ML8cZ7unEMkZ0LzF4FhNEF/2GjTHKHh4fJ0lifTSxwHKOv9NwM9fGlvhVvEZbqXTacY9sEO6VoxNvV6BI6gNsWtfEMGFpX6AlOwxuL3kF2zI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731131350; c=relaxed/simple;
	bh=JwzUwfIt4MrboCmOVnxjFEP5Csdi97KdI5la+oLJxU4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P1LbYvr86o5ur9kAJqN+WJ0blKgKkFGn1jeRSTMVcMv9KqoTNnAX4jlLQrdtv4U40iRSUl9yVvY6Ua2smzOH4NDd1ukvwxy6m0H8VaxESEIz4Lol/kvmXHhud8GP3raPYGnXaBuZcjiHdqMReadMI1D20xQkwpZTbz7Tq/a7ws4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=X0x/5xTN; arc=fail smtp.client-ip=40.107.92.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TwZ0Nz362B6f8I2BTz2R8d7DD4YWW1vleQPJZGSMtlFEWD16V24pxTx1//qhhWEBvczAbGgoW4p76r/gduXFA+2kvYllClqDpsrIAdR4/8t0xNlSEaaig639oJUQ8+YTyalv0ZmpsrtWVru8483ruwQtAvwFNDfVI6yG3IJPgFPekCUIGOvsmlEMw7pcTDpNpYsDjWKo/f9ji2A1ooIaDdzUeoHnDvXtbHqF/8wXp99nu7bPlzCHOPBp/9L4DjASph7fXTIeN0/xvl6WKymChmrYDwj9FFQy93pMCl3UVZGD9h/f6pgb1JDNf4pD1lup1iN4bSYW0BIglsXQ+atnvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ic9WcFlijRl4/3uLjlD1vQwG/b5CUE426R7AuROnUeE=;
 b=FO1WQqKBgY5UWmYr4H24C3pcLyc+czCreWX2uB4RrIDPRIY+GJsKl1HyDvrUTRwca5NlkfQtoaJa4afunihNSbkGNmWooJmkSdPP1aZj0PyPbM62n4NezpOQ0NpzGri9/BHjpOoQ2ASA4lxg8qOsRYZwEa5bkVgrA17RmQPI3b5B/MWpNHcb1khhempugiB27z8rAbwvT2/XmDloJ3WJrB38JXAfUSB5h7vSkUXu4NSv8l5FctD2XjxkkkrR2Rrj2zxDifQS4bV3Euh+ahtrwcHNSCgKIduU7+VUmPkXSaBzb1jpiNsUjxjXqUDVjIUsJf7H238nf4HwT2F+CId9jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ic9WcFlijRl4/3uLjlD1vQwG/b5CUE426R7AuROnUeE=;
 b=X0x/5xTNz0fIXUzi7yfo7tMxrFyAgtatTNG699SMKLHmPqnJ3mNzO5K1QgpBJiGP+LuzjoD0taPr9Yodz/mGPo1QkMfBzruDSh1EwYLl2zJ8Il2eEZqLm9e/ATzWGBkLpVVi/j2Ahj/lizVNdWRpHyQ3DXsp/TFUTj1Z3AwRu1meC8jDMPtvgQMiBDZNaSc//61/vLi7RVbVPmTwAV+kGuWOWepA1zfpWXlRQyzglOzDsuiPXEM4fFI+3l+rif5qcsYI8MruVQkKGuoI0Dqy62ySTBWZv9Y6BJh4kFIS8l+zbNRE5zw64wFirCjMMGAXaoq0vyczO2UPcik/XxtzpQ==
Received: from MN2PR01CA0052.prod.exchangelabs.com (2603:10b6:208:23f::21) by
 SN7PR12MB7936.namprd12.prod.outlook.com (2603:10b6:806:347::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20; Sat, 9 Nov
 2024 05:49:05 +0000
Received: from BL02EPF0001A102.namprd05.prod.outlook.com
 (2603:10b6:208:23f:cafe::19) by MN2PR01CA0052.outlook.office365.com
 (2603:10b6:208:23f::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.21 via Frontend
 Transport; Sat, 9 Nov 2024 05:49:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL02EPF0001A102.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.17 via Frontend Transport; Sat, 9 Nov 2024 05:49:04 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 8 Nov 2024
 21:48:58 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 8 Nov 2024 21:48:58 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 8 Nov 2024 21:48:57 -0800
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
Subject: [PATCH RFCv1 2/7] irqchip/gic-v3-its: Bypass iommu_cookie if desc->msi_iova is preset
Date: Fri, 8 Nov 2024 21:48:47 -0800
Message-ID: <4e675b8ae803a478d10e675407ee1ff5f1f65890.1731130093.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A102:EE_|SN7PR12MB7936:EE_
X-MS-Office365-Filtering-Correlation-Id: 06986a8a-70ad-459e-1c8e-08dd00823862
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1jTsxvCDGd/a+9zyaIoGl2ei6eED4I4AhNSdgS76MOaORRekaXizy6KBOTxn?=
 =?us-ascii?Q?3QMdZ/7X1Dd2gNFje1lbjTPbGF3NUGLbalEk+pjvxMRG+6uVQViukkvsAzn0?=
 =?us-ascii?Q?a8mxSbs2XEVxyEYu9oAGb6r2pEaPJOYgr6jSTU35fg8KYEPNv/zchhXaODHS?=
 =?us-ascii?Q?01I3Sq1RFGHSrKGPYSZ504eU5i2zWY5Fl1PwOqEGFuvejgjeITJJZfwUdVRO?=
 =?us-ascii?Q?Idiv7Bv93jXCKs+DaJFctp8W32uK7k8F6Yr2iOiBj0bHmDfk3gvGuri6EmFl?=
 =?us-ascii?Q?1BWmtDhxeWda/v2gw9V8tJajrFaPseRV1mnUOFVNYbgMKqIKCVYZVzNkYZfW?=
 =?us-ascii?Q?rGcQA716xHrhcb2HwTlQsStkTxaA/SJ7AsPi9xItWBxVZ9x8mIzjUmhxUvaM?=
 =?us-ascii?Q?oufaPvUTib2AcHg1zntP8Fc9FitIp7dlhvWSQDmiHFspCa66xATzuCRWizrf?=
 =?us-ascii?Q?MX0np+8gliL6ofweQLyUtbGfqg1YSlODxopEOVdiSWrTeTLguTjcSe5u9bTW?=
 =?us-ascii?Q?45PxZpC4eU/Sukb2scS+rXHowSrLk9hjYlokoxF+GdFZXgOidHRFoJkvauDy?=
 =?us-ascii?Q?IpCJEEjkwYQN/SOs6sCUr2iclNIF10VMlLnap/dzMYfUgMH9q2IVAQQ3tZTu?=
 =?us-ascii?Q?BrIt9Se8VhnlrbB4h8BeEl/yjUZSphpj18g7l0DL5T789rjuG2Kswvpxj+7i?=
 =?us-ascii?Q?Bb80ZSejQ/5lB2jsjjOFJ+EmuK9Z1AUS1kydJCT+0zvJzUMWzrtz9kW4/Gk9?=
 =?us-ascii?Q?4eF90UqH3OhBBUC0EpueEl70CN4j/8rTRo1IijbBBSQzJxlv8E5tfJYUygS+?=
 =?us-ascii?Q?cmb9OE7IJVjhn+byWJq2eHHB3s3x5mkvLRBI/x8sYQk3EktZCGynkGmrwCcJ?=
 =?us-ascii?Q?koWS0M2wFNTGfv04GXtNBfUDZxmiM/PahMPKgXlSV4He5c31icSH2G3hAqrz?=
 =?us-ascii?Q?oxt1Ekd7x9K9d2PIhTuxQSePcwl8WF05wQeVBooFB4ekVYWB/B2JooryOeLI?=
 =?us-ascii?Q?+LLyPtY0W+lesSv2LkFo59pSn8UzBpI2IvLWew09rSGg7aYY0gKmXNFUdc0f?=
 =?us-ascii?Q?Ccozqc96zZU0cBHFmHpyoiA4HY1ahI/0yrnV0W57ex+ypfxWzBNHjLHSpuFI?=
 =?us-ascii?Q?Kf3VAtaYFteAVWitiRRb4YQXo/NhAIfBUS4YzNwqx12DxeED4aKaYMtIPzdX?=
 =?us-ascii?Q?v2qGSlLYvsvOEPBDywtx+mhjXQNGBuxLn7+Q+zm4DfG6fBNr+/jnMtux+tVu?=
 =?us-ascii?Q?keeTAiiyEYkNAh2IovaA3BaDCv+s7ZInuYM/BFwYkO4OL8n+1vFy2baiZa1T?=
 =?us-ascii?Q?JoA/BrsXh1rOJMkjlhc33J6soGbMPAF5An2l22BP3/6e3uL5Cd10GVaW4/9O?=
 =?us-ascii?Q?3kRYaFTTjBOKvrxtE3J0qvAsBZPAvy174IorYnyRiLAlkzcmjQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2024 05:49:04.6618
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 06986a8a-70ad-459e-1c8e-08dd00823862
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A102.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7936

Now struct msi_desc can carry a preset IOVA for MSI doorbell address. This
is typically preset by user space when engaging a 2-stage translation. So,
use the preset IOVA instead of kernel-level IOVA allocations in dma-iommu.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index ab597e74ba08..bc1768576546 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -1723,6 +1723,8 @@ static u64 its_irq_get_msi_base(struct its_device *its_dev)
 static void its_irq_compose_msi_msg(struct irq_data *d, struct msi_msg *msg)
 {
 	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
+	struct msi_desc *desc = irq_data_get_msi_desc(d);
+	dma_addr_t iova = msi_desc_get_iova(desc);
 	struct its_node *its;
 	u64 addr;
 
@@ -1733,7 +1735,13 @@ static void its_irq_compose_msi_msg(struct irq_data *d, struct msi_msg *msg)
 	msg->address_hi		= upper_32_bits(addr);
 	msg->data		= its_get_event_id(d);
 
-	iommu_dma_compose_msi_msg(irq_data_get_msi_desc(d), msg);
+	/* Bypass iommu_dma_compose_msi_msg if msi_iova is preset */
+	if (iova == PHYS_ADDR_MAX) {
+		iommu_dma_compose_msi_msg(desc, msg);
+	} else {
+		msg->address_lo = lower_32_bits(iova);
+		msg->address_hi = upper_32_bits(iova);
+	}
 }
 
 static int its_irq_set_irqchip_state(struct irq_data *d,
@@ -3570,6 +3578,7 @@ static int its_irq_domain_alloc(struct irq_domain *domain, unsigned int virq,
 {
 	msi_alloc_info_t *info = args;
 	struct its_device *its_dev = info->scratchpad[0].ptr;
+	dma_addr_t iova = msi_desc_get_iova(info->desc);
 	struct its_node *its = its_dev->its;
 	struct irq_data *irqd;
 	irq_hw_number_t hwirq;
@@ -3580,9 +3589,13 @@ static int its_irq_domain_alloc(struct irq_domain *domain, unsigned int virq,
 	if (err)
 		return err;
 
-	err = iommu_dma_prepare_msi(info->desc, its->get_msi_base(its_dev));
-	if (err)
-		return err;
+	/* Bypass iommu_dma_prepare_msi if msi_iova is preset */
+	if (iova == PHYS_ADDR_MAX) {
+		err = iommu_dma_prepare_msi(info->desc,
+					    its->get_msi_base(its_dev));
+		if (err)
+			return err;
+	}
 
 	for (i = 0; i < nr_irqs; i++) {
 		err = its_irq_gic_domain_alloc(domain, virq + i, hwirq + i);
-- 
2.43.0


