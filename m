Return-Path: <kvm+bounces-31335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BB2E9C2A5A
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2024 06:49:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 30D8128231D
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2024 05:49:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1820145B22;
	Sat,  9 Nov 2024 05:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OSWkJMtx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2061.outbound.protection.outlook.com [40.107.92.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D37B1422A2;
	Sat,  9 Nov 2024 05:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731131347; cv=fail; b=grjAtl5E2v5P3gTG5Mo8RDi+x2VsdBpkVIpJZlqP9cKu+7FN3HYj+Fhd/qvYWPdTpVFD8HFhq8Z0x5MRBFKo+NPIZ85qKKyJf2RZZWxM+pkhlU8vLnPM0Y4dGdgKLBVFo18dGftYtBswBi5mKbtvSJp+gm5e3sxUbBLons3r/f4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731131347; c=relaxed/simple;
	bh=5BumytWSkFhG3+elXDqyCD+enOUCf/4J5M0Cis4hV8s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sarq4zAAa6GIw+qwiphWKyNkEkMv1oqwj1jU8sUVnLePG9qpQ/Z8lGj7Pz7iorVop3LottwqTMH9UHiiEFq11GoWtgopaPMi2uSuPAplQzWykZklSJtqKp46ah354ksj7IYnsplZd2UV4Hear+telXloPHaof6fESfk0G5GbcMs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OSWkJMtx; arc=fail smtp.client-ip=40.107.92.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XTupTSBhp99HnwYx/mD6r5Z3dpDYxGldo6jHq75avYgdU8/56hX5QNIBRJUqY560/1sUq3r0M8VhR7GzF9sU1i7rsVeHRdmC0AEU6JCJtQ4qokdo6zYmkxd8obN/Uw5e0XMxyOnwMqe42ASZt/FpflfY0VZntEInjkS7qiZlCazaAHLRgSsu1cJk7OrJbulcAm/yZ4UK1JJUcp4qhv0dqGsWQWYlWWiIGFrQ7YFqyXVBJoPCJicZwgKOksq+j6yDGzzNq7zi/Lj0/rG9KLLpSy6/+VLEAJK1ZEZg64dWffHn6SZM73ReYAE1VOojwej40jqniCYBWWn2iP6lS58ffw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ruRAryFycAyiD/dpV5N9aeYNczxwUmEkz1V3M3BrpVc=;
 b=CnKw0BK63Vbugn4nLCwK7XXjlulQrjYWYNbjxL6gpufZ6mrZpCGfm8MfbBpQEllUddFyWdQdQl6u/JamMcJ4ztmk39NbAZtvsOgfxs7BQDoU/k8AbAaWbw0lbSm1CFv+19faKuO9n5sUGsVNT26VtawTfW7yL4TLINzmxoyGqCv4BPbWmAGLjsi1tzUz2/6jk6RBJHdLxlHRzLzaTAv9VtRp5lywWJZaUWuWUdMxzb4YxCKR7SerH9pWM3zss7+vGUj+EqVK/PUHssgOLRFxMUU+OH0WlrNXSTEEZxJxJfL8+DIsD58A3Wh6eg2Ff/xi1txrGW86wtewiDl4TPodwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ruRAryFycAyiD/dpV5N9aeYNczxwUmEkz1V3M3BrpVc=;
 b=OSWkJMtxk9X6Q3uyxjDS972ylr2ymka91VRSXH0LzTYpCcV3vgDxIDYMLL9RBymlwIxkcG13rZDWPswvrRjkMR5B+FuiKLFlBGvoL2bbM2R/SOs9UC0nTWO3YeKYiSJmXMH+r7mAbwZTIKqXO2OgX2+A/dcG2yKvc0Hlz8g8TWyMG2rM9aKcI9dO62OKP50TRhMRn4A/k5tXbFfLvetDVv5oHOmRQJpHGg0H5d1tviwKDgpjrYEDn3RRshiib3xrBkHEKkUwMg+KARKbnrVu9wOv6pwF8XCxC8LHjVaAiYdIH3MWzeTYCemxDlGE7/qonHfvWsWHIacvDh5tKNox5Q==
Received: from MN2PR01CA0044.prod.exchangelabs.com (2603:10b6:208:23f::13) by
 BL3PR12MB6475.namprd12.prod.outlook.com (2603:10b6:208:3bb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.22; Sat, 9 Nov
 2024 05:49:00 +0000
Received: from BL02EPF0001A102.namprd05.prod.outlook.com
 (2603:10b6:208:23f:cafe::e0) by MN2PR01CA0044.outlook.office365.com
 (2603:10b6:208:23f::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.21 via Frontend
 Transport; Sat, 9 Nov 2024 05:49:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL02EPF0001A102.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.17 via Frontend Transport; Sat, 9 Nov 2024 05:49:00 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 8 Nov 2024
 21:48:57 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 8 Nov 2024 21:48:56 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 8 Nov 2024 21:48:55 -0800
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
Subject: [PATCH RFCv1 1/7] genirq/msi: Allow preset IOVA in struct msi_desc for MSI doorbell address
Date: Fri, 8 Nov 2024 21:48:46 -0800
Message-ID: <b164a69649f3cfc72c54d4f0dbdc00c9b825ddaf.1731130093.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A102:EE_|BL3PR12MB6475:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f5d5392-9d74-41d5-4c0a-08dd008235ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?t/S9K0XP4NZ0tg1+bxB+qfMa9SC0pV7WHw1QHoPygbgdTHgg3p7RzN5Pa6M1?=
 =?us-ascii?Q?YqXoRwFRlyAYZ85gPdxplb1oQmzoeydmoPbInJWXEPUOYgKiG7KEC8C6OjUm?=
 =?us-ascii?Q?dGEgrD5MT77Rsslxks782kTRGitx1vv0JxjNDYu4lytP9guzv6yC1g9LUIPR?=
 =?us-ascii?Q?0shtj9d3HmUGKKaOJhinu3AKwZn48J++zDxjh6+L58Sgl1JWtvV4QBy9m3bM?=
 =?us-ascii?Q?RUZYhnqawjUyiIMXNJk15gMyl43wVBgWNyuJhCz+tTmqpyqo/idCGQSBJwSW?=
 =?us-ascii?Q?wFKAvXFDjL+P33YSBxXDYBKpbg+lWdfxF6MHFCOSvznpM1GkMz+neEq2fnlO?=
 =?us-ascii?Q?Mep+0wUqELkWY5P9OsvFCSemDzm2Ujx7J6GSNOrbJJTsAtNhA/xHxtHxPmNk?=
 =?us-ascii?Q?sa0NLUhyBbAHppRf5Qjmqg7m/D1wAHfZ7uUvSwqKQuAxC0E4JQi9q+evY9un?=
 =?us-ascii?Q?S7otiEDiAm7VKeFXAAd2mzeyNeUh0zmxFQplTpWXQMc2fGdkAYagkd7D3j7B?=
 =?us-ascii?Q?dnyqhoTX6SJodapG998cI9PVzhEsyAHp0zxoW4Jk3X0aBM5LeJKWPRguHniM?=
 =?us-ascii?Q?nw8wySpWSd0hBH0LD1eUVLn4onJhok5w6boAvH4GTwN8BZ5qe9ueypTD8RDz?=
 =?us-ascii?Q?/a9jIms44gw0nQNKAXYtjhs5fzbRTo5ySer4+M74F/WCWkBaZsQQEB0UV9xN?=
 =?us-ascii?Q?ixH+BLt9cB1UqxklH2VLWIZiB6htP0RCDLex02zilyJv6kuFw3LnXEPMCuxf?=
 =?us-ascii?Q?2HFudNbEM04g/+XgHD4wKCmHl3kkjkS2HcKLfkME60EiVaKQzQKxZNkVzahd?=
 =?us-ascii?Q?19R5DSOSe9L2x7sfAPR6wNNU8ZAYGiPxY7e4NjvM8i4Lezp+yA05Yg0fbpNo?=
 =?us-ascii?Q?F0CS2AWmk+czNM4ywOBa2RsR0alV26f+dMU7XsnFrArwajyjC7n5vdbds4w/?=
 =?us-ascii?Q?e7OJp45TOjLbFI6axyqRAn0GVS1IEeY82hsxX28PuF2eM+xeV82TI2Ytm8Et?=
 =?us-ascii?Q?gBEhh9ePMzsYcp1Wh2WpA8X38AQqoSX9MBg2SXMcVEZ30l9t2daTP8hSVX0Y?=
 =?us-ascii?Q?VVV19XZMrHwgunky/Y5KB8Ptbj0Qnzukieh1iNc/fT9oS7zQY483Q/to69Tz?=
 =?us-ascii?Q?4rkHNzQvhSJ76RKeixaxgloPzMBWCg0E7vR6AmWjNMQMBQg0KILfVqCaRWT2?=
 =?us-ascii?Q?YlWT2S1XuXZm50rfD2Dm53bCXm2VSQtNlrQm6q07fmsslwyT4Ot3iJPv5H0t?=
 =?us-ascii?Q?ws+47sAVcMfFbaLEU2+zN8EA8Njy39xyR+TuwHOG/M8O5ynxgjU2cjNIgkaV?=
 =?us-ascii?Q?IyDVnNlN2cSiPXVBFA2AwydoMJkzrY0wcGIO7tpyDtzNzaATWz4/CQqjNS8a?=
 =?us-ascii?Q?7Bcchh+EBsY4mHC2ewxWjjDT15rYmvoeqHdtic0lVSBGZS9pzA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2024 05:49:00.4743
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f5d5392-9d74-41d5-4c0a-08dd008235ea
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A102.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6475

Currently, the IOVA and its mapping (to physical doorbell address) is done
by the dma-iommu via the iommu_cookie in the struct msi_desc, which is the
structure used by three parties: genirq, irqchip and dma-iommu.

However, when dealing with a nested translation on ARM64, the MSI doorbell
address is behind the SMMU (IOMMU on ARM64), thus HW needs to be programed
with the stage-1 IOVA, i.e. guest-level IOVA, rather than asking dma-iommu
to allocate one.

To support a guest-programmable pathway, first we need to make sure struct
msi_desc will allow a preset IOVA v.s. using iommu_cookie. Add an msi_iova
to the structure and init its value to PHYS_ADDR_MAX. And provide a helper
for drivers to get the msi_iova out of an msi_desc object.

A following patch will change msi_setup_msi_descs and msix_setup_msi_descs
to call msi_domain_insert_msi_desc and finish the actual value forwarding.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 include/linux/msi.h | 11 +++++++++++
 kernel/irq/msi.c    |  6 ++++++
 2 files changed, 17 insertions(+)

diff --git a/include/linux/msi.h b/include/linux/msi.h
index b10093c4d00e..873094743065 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -185,6 +185,7 @@ struct msi_desc {
 	struct irq_affinity_desc	*affinity;
 #ifdef CONFIG_IRQ_MSI_IOMMU
 	const void			*iommu_cookie;
+	dma_addr_t			msi_iova;
 #endif
 #ifdef CONFIG_SYSFS
 	struct device_attribute		*sysfs_attrs;
@@ -296,6 +297,11 @@ static inline void msi_desc_set_iommu_cookie(struct msi_desc *desc,
 {
 	desc->iommu_cookie = iommu_cookie;
 }
+
+static inline dma_addr_t msi_desc_get_iova(struct msi_desc *desc)
+{
+	return desc->msi_iova;
+}
 #else
 static inline const void *msi_desc_get_iommu_cookie(struct msi_desc *desc)
 {
@@ -306,6 +312,11 @@ static inline void msi_desc_set_iommu_cookie(struct msi_desc *desc,
 					     const void *iommu_cookie)
 {
 }
+
+static inline dma_addr_t msi_desc_get_iova(struct msi_desc *desc)
+{
+	return PHYS_ADDR_MAX;
+}
 #endif
 
 int msi_domain_insert_msi_desc(struct device *dev, unsigned int domid,
diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index 3a24d6b5f559..f3159ec0f036 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -81,6 +81,9 @@ static struct msi_desc *msi_alloc_desc(struct device *dev, int nvec,
 
 	desc->dev = dev;
 	desc->nvec_used = nvec;
+#ifdef CONFIG_IRQ_MSI_IOMMU
+	desc->msi_iova = PHYS_ADDR_MAX;
+#endif
 	if (affinity) {
 		desc->affinity = kmemdup_array(affinity, nvec, sizeof(*desc->affinity), GFP_KERNEL);
 		if (!desc->affinity) {
@@ -158,6 +161,9 @@ int msi_domain_insert_msi_desc(struct device *dev, unsigned int domid,
 
 	/* Copy type specific data to the new descriptor. */
 	desc->pci = init_desc->pci;
+#ifdef CONFIG_IRQ_MSI_IOMMU
+	desc->msi_iova = init_desc->msi_iova;
+#endif
 
 	return msi_insert_desc(dev, desc, domid, init_desc->msi_index);
 }
-- 
2.43.0


