Return-Path: <kvm+bounces-63641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id E31A0C6C31B
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 01:57:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5E7E9367546
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 00:54:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41D2D254AFF;
	Wed, 19 Nov 2025 00:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JEWAIaw6"
X-Original-To: kvm@vger.kernel.org
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012009.outbound.protection.outlook.com [52.101.53.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5476D23EA9B;
	Wed, 19 Nov 2025 00:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763513583; cv=fail; b=eE++JTl9M6ya2gpLUMDxlBUh3qTEcKsdBUyVdb1ZtGhBz/3EBHdctCnWIOy0nVaHdCZja+sU90rgnlk0I+Jcd+ITinoazrWqOZJ4ucalM6JKw6gihbedRqfBU3tbvwQbjxW0WzxyW71xgMvGVBGMCBS5J3zDEpPoBp+LPm+WJxc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763513583; c=relaxed/simple;
	bh=L+U4lVVQe6KF3+Hnbia6uQlMUQBelrs0Oq/1GTOlIUg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p6P235c0MgEjZ8J6BIfnvtnvZlr3Dha5Ju1XuOMFwygdiOWKuX+bVaI496v70js28fFC6sKcAWx+aLt1XVke8jWdNxzNGQk06T6MCBsSlbMMOJ3WT1mQYYm8gSdTcoMR64RFlJUu03S5bsXQgmv4MtkTbAM8Jc/WAnbrt2JLde4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JEWAIaw6; arc=fail smtp.client-ip=52.101.53.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pMKngH9fizQB+RKyTzOeIwZHiUqPxPUFpsBtgdDX2x/YqSJyduk5PBEQcKFtqExW8ET2E1q49eIIENhT6WXDNdKBiVsVqdncVghicL9T95boGkChpxYB/Ir+Q+vV9fb3ijln+GNf0+KmKDVvNBGN7oNnVCLC7VOp73QOulYiOSUjf3YV3k0CSTLYP5UUXKFlw/vG2vpEwmV75e/pxLFCtqYgeTbOcYVUUg9vYzDGsoaApEO9nB5YClN8TvTSzdQRg9tVwfYcT5Cgh8uRU8HcLFUIxgVGfcJOziwKikEm35/r32KoziUYqQfv8Q2uAScfWOhXfGldwlpNUBt5vOd9CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WmHxvDjOAd+zb5Gtke0NE0tE7Yn01Uay/iw9FXC3q2c=;
 b=dCkUjCdVupEl9RtNp9Z+4rVEMStdbDb6qE6XvqSOPrFMXjJhF70G2SAp4hvfTfexUo4cCkVMIFxd2XUNi8w9n9KTblcivv6zkCLhRIBcJatjc56kpJRPgaiccNewfPScGhyWc8lDsbxrNF1vyETxDscQtwUA2GHt7f2OxerYLEJ8zs4fn78CVQgcz5e7ZkUj8m3BK9rrGIlpZcYGPm0xCsiqKgER9jyM/MPXeBSjy3SR7Nqkb9aC8VFqBCEtNH3poipQvGRn7/rYlaMF1J4b3pjRk9MMi6T3em49X+WvRHh39H2ldKn8GkngkQbZppHnQx0khBS+1JjG4P/gFHMgHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=arm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WmHxvDjOAd+zb5Gtke0NE0tE7Yn01Uay/iw9FXC3q2c=;
 b=JEWAIaw61nglzGc3hx/VFpSuEGZTk71qGr3bfFtgFWapc3vZUi5eTylCxCNEQj+Ia1pqnyiWOjm0PoTa4AEPY3qiz9rwDIOFoLr0mQRvKsd/ZotUA1KKuIW2IWVkXBSIyirxKnxkRfmTDFvNELRBwY6JXWRrnMstVSI/MGqffkH+Arcz5yEe1g2y7cpp3Ei0rk9OL5uJL51shF1iue2bvHd5RvDttDcq9ulAVPHgO1DwI+FHwvvaO5yVYOky53nRsWQ4XIg8ca7+8EZOnWCyCU2wX48uMBjIBEo6B3+lJv1wIhIcUckRNubT18WMVie8nWxihxGwpDQYfhDTQFy63A==
Received: from MN2PR22CA0002.namprd22.prod.outlook.com (2603:10b6:208:238::7)
 by CYYPR12MB8889.namprd12.prod.outlook.com (2603:10b6:930:cb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Wed, 19 Nov
 2025 00:52:56 +0000
Received: from BL02EPF0001A105.namprd05.prod.outlook.com
 (2603:10b6:208:238:cafe::7e) by MN2PR22CA0002.outlook.office365.com
 (2603:10b6:208:238::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.10 via Frontend Transport; Wed,
 19 Nov 2025 00:52:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF0001A105.mail.protection.outlook.com (10.167.241.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Wed, 19 Nov 2025 00:52:55 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 18 Nov
 2025 16:52:34 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 18 Nov
 2025 16:52:32 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Tue, 18 Nov 2025 16:52:31 -0800
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
Subject: [PATCH v6 5/5] PCI: Suspend iommu function prior to resetting a device
Date: Tue, 18 Nov 2025 16:52:11 -0800
Message-ID: <9f6caaedc278fe057aacb813d94f44a93d8cab3c.1763512374.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1763512374.git.nicolinc@nvidia.com>
References: <cover.1763512374.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A105:EE_|CYYPR12MB8889:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bb7ffb7-0ba6-46c5-e4fb-08de2705fa49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zlajNCqydDphUuU5Auxtd/Z34pkW92cytRJlVRwp15GawrWZe59tcsjBtMlo?=
 =?us-ascii?Q?LpghRXLFL6kOXyC0WOGTSBQhxbDOj8QeF0iGqdLdD/PCoAd9rY6V1leFpLuD?=
 =?us-ascii?Q?T/ggV9j/Idb6L2ZXp84PuB7GkXRV3Y4Rdnou4paiOaloQC9dTP6L79wyTrcH?=
 =?us-ascii?Q?QOX98RKTdgokESQ5fO3x1KHV71Kp5hGV0LQaXCo6O7RRcyjvQp0QPtMyaaaX?=
 =?us-ascii?Q?S4CQxrrUDIJrCUNsch6QmA20AV0REe17Y79Lwl2vcbkdbfGvnEYb/3Fez84S?=
 =?us-ascii?Q?GYdSWvqNRM1r3PkVOw7ALfi9bB3B4ThSt+LLACkCbRa0fdvkboGZOQuT9uqU?=
 =?us-ascii?Q?3w7hId0ag3B9OnAnFIyuNl5sC50cO1iokdZ7puZPHbvAJSAU2+IOZ1Co9AxM?=
 =?us-ascii?Q?4FLydOfz4nSX9PSD+wWGOew3YYGiBKgnvPpv5I74b/OsTdvd30LuQ+DjdMbx?=
 =?us-ascii?Q?+fTeDUTCVHm/jeDz5UkpCstrzNR4YRbJDwQ5BiD863hX5ILSt/jcGi/tMgKs?=
 =?us-ascii?Q?NI/ibwss3sJZl9pNYxMxhj2q8G7QD4Y0+RKM+5dJcxirUKYNZq79HH8vbDVz?=
 =?us-ascii?Q?f7jBJw1gxKvLeuiYBpRxQVCTIX6YXKmr7Jm/O0w3gVi08gylUPdeHrtFO0WP?=
 =?us-ascii?Q?AJ71Y6mybEq+DG0N+gkJOU/zu5KJBct3L2vuZXV8lWd/YMt6LIZkLBH0ozvr?=
 =?us-ascii?Q?fRBGvxl55jlBYGj2FcKobJ9/TqjNHb0ql5gErEc606R4ubyn5jcs7j74amwe?=
 =?us-ascii?Q?tTMronXU8qpmfdgEc82GlqqtwFSNx9eWnZNTMkcATCM27h01g9lWCist13oU?=
 =?us-ascii?Q?6h8TYVWl9NQaOTZG9tMqW3oYwbrIbCkEflrzXFSkg+1gjaSTDC/CW9ukL4o8?=
 =?us-ascii?Q?BXUdeNi7FA+bUtSLpsBxCvQmoeWFSQBCZVGF2DEGqAT8YhTbV8ztyfkw/ON+?=
 =?us-ascii?Q?6F9qcepxHuwpg8cYlZu0QyYclOs00t2uRYx8+0GO1VaYZnbM0MqrlJG4Qy7S?=
 =?us-ascii?Q?53Dt0tWgxo+3uZg/m/PHOCrFx9jle+Vih077GHVTY2XlPbQFi92vApS/ObQX?=
 =?us-ascii?Q?mkZGv4YplthVKjwUEx6Eh+nOEu/dFBOArdqWM6LDLh173t9NYVGcRtRjfj2F?=
 =?us-ascii?Q?FXHPkC9ozpKtspEJVG3uPiaZ16jvcuSrot75kjjFCMYXBggnxOrVnAeWS+eH?=
 =?us-ascii?Q?PtTJVwViAcpAE6pquqWPvHw7hDn1/P2cSFZ3MnwOZxiVEIfIsAFOfe/59357?=
 =?us-ascii?Q?bKNcKBg2X5TWjSx3sPRQc+lR40bDqdk4xcNQxlMBD9GpNbomtylVutwYEIzn?=
 =?us-ascii?Q?tSzaw5WXLA8+Dk6Bf7wt24u7/pLu96VSqyC5+m5ikirAxHOzkIVQRi5gV0fI?=
 =?us-ascii?Q?bTZ6ZU31ykAN83nFJ0bT3ja8Eov+c0F725FnfSfGnMbgPH2WgLlEwMcIdrkX?=
 =?us-ascii?Q?QZPus6PlbMd7roDdZ6APASTR/HUyc3LhqvnAtuug80/XRFM69ZF8FOHpm40d?=
 =?us-ascii?Q?fLFjLOnnGcD8ii1UgIk2WIStKBdiQL9rMuwmdF4cT06tLj1TnBbEiu7+CoLC?=
 =?us-ascii?Q?MJrGb/qUMNGGy5Yzbq0=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 00:52:55.8673
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bb7ffb7-0ba6-46c5-e4fb-08de2705fa49
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A105.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8889

PCIe permits a device to ignore ATS invalidation TLPs while processing a
reset. This creates a problem visible to the OS where an ATS invalidation
command will time out: e.g. an SVA domain will have no coordination with a
reset event and can racily issue ATS invalidations to a resetting device.

The PCIe r6.0, sec 10.3.1 IMPLEMENTATION NOTE recommends SW to disable and
block ATS before initiating a Function Level Reset. It also mentions that
other reset methods could have the same vulnerability as well.

The IOMMU subsystem provides pci_dev_reset_iommu_prepare/done() callback
helpers for this matter. Use them in all the existing reset functions.

This will attach the device to its iommu_group->blocking_domain during the
device reset, so as to allow IOMMU driver to:
 - invoke pci_disable_ats() and pci_enable_ats(), if necessary
 - wait for all ATS invalidations to complete
 - stop issuing new ATS invalidations
 - fence any incoming ATS queries

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/pci/pci-acpi.c | 13 +++++++--
 drivers/pci/pci.c      | 65 +++++++++++++++++++++++++++++++++++++-----
 drivers/pci/quirks.c   | 19 +++++++++++-
 3 files changed, 87 insertions(+), 10 deletions(-)

diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
index 9369377725fa0..651d9b5561fff 100644
--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -9,6 +9,7 @@
 
 #include <linux/delay.h>
 #include <linux/init.h>
+#include <linux/iommu.h>
 #include <linux/irqdomain.h>
 #include <linux/pci.h>
 #include <linux/msi.h>
@@ -971,6 +972,7 @@ void pci_set_acpi_fwnode(struct pci_dev *dev)
 int pci_dev_acpi_reset(struct pci_dev *dev, bool probe)
 {
 	acpi_handle handle = ACPI_HANDLE(&dev->dev);
+	int ret;
 
 	if (!handle || !acpi_has_method(handle, "_RST"))
 		return -ENOTTY;
@@ -978,12 +980,19 @@ int pci_dev_acpi_reset(struct pci_dev *dev, bool probe)
 	if (probe)
 		return 0;
 
+	ret = pci_dev_reset_iommu_prepare(dev);
+	if (ret) {
+		pci_err(dev, "failed to stop IOMMU for a PCI reset: %d\n", ret);
+		return ret;
+	}
+
 	if (ACPI_FAILURE(acpi_evaluate_object(handle, "_RST", NULL, NULL))) {
 		pci_warn(dev, "ACPI _RST failed\n");
-		return -ENOTTY;
+		ret = -ENOTTY;
 	}
 
-	return 0;
+	pci_dev_reset_iommu_done(dev);
+	return ret;
 }
 
 bool acpi_pci_power_manageable(struct pci_dev *dev)
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index b14dd064006cc..da0cf0f041516 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -13,6 +13,7 @@
 #include <linux/delay.h>
 #include <linux/dmi.h>
 #include <linux/init.h>
+#include <linux/iommu.h>
 #include <linux/msi.h>
 #include <linux/of.h>
 #include <linux/pci.h>
@@ -25,6 +26,7 @@
 #include <linux/logic_pio.h>
 #include <linux/device.h>
 #include <linux/pm_runtime.h>
+#include <linux/pci-ats.h>
 #include <linux/pci_hotplug.h>
 #include <linux/vmalloc.h>
 #include <asm/dma.h>
@@ -4478,13 +4480,22 @@ EXPORT_SYMBOL(pci_wait_for_pending_transaction);
  */
 int pcie_flr(struct pci_dev *dev)
 {
+	int ret;
+
 	if (!pci_wait_for_pending_transaction(dev))
 		pci_err(dev, "timed out waiting for pending transaction; performing function level reset anyway\n");
 
+	/* Have to call it after waiting for pending DMA transaction */
+	ret = pci_dev_reset_iommu_prepare(dev);
+	if (ret) {
+		pci_err(dev, "failed to stop IOMMU for a PCI reset: %d\n", ret);
+		return ret;
+	}
+
 	pcie_capability_set_word(dev, PCI_EXP_DEVCTL, PCI_EXP_DEVCTL_BCR_FLR);
 
 	if (dev->imm_ready)
-		return 0;
+		goto done;
 
 	/*
 	 * Per PCIe r4.0, sec 6.6.2, a device must complete an FLR within
@@ -4493,7 +4504,10 @@ int pcie_flr(struct pci_dev *dev)
 	 */
 	msleep(100);
 
-	return pci_dev_wait(dev, "FLR", PCIE_RESET_READY_POLL_MS);
+	ret = pci_dev_wait(dev, "FLR", PCIE_RESET_READY_POLL_MS);
+done:
+	pci_dev_reset_iommu_done(dev);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(pcie_flr);
 
@@ -4521,6 +4535,7 @@ EXPORT_SYMBOL_GPL(pcie_reset_flr);
 
 static int pci_af_flr(struct pci_dev *dev, bool probe)
 {
+	int ret;
 	int pos;
 	u8 cap;
 
@@ -4547,10 +4562,17 @@ static int pci_af_flr(struct pci_dev *dev, bool probe)
 				 PCI_AF_STATUS_TP << 8))
 		pci_err(dev, "timed out waiting for pending transaction; performing AF function level reset anyway\n");
 
+	/* Have to call it after waiting for pending DMA transaction */
+	ret = pci_dev_reset_iommu_prepare(dev);
+	if (ret) {
+		pci_err(dev, "failed to stop IOMMU for a PCI reset: %d\n", ret);
+		return ret;
+	}
+
 	pci_write_config_byte(dev, pos + PCI_AF_CTRL, PCI_AF_CTRL_FLR);
 
 	if (dev->imm_ready)
-		return 0;
+		goto done;
 
 	/*
 	 * Per Advanced Capabilities for Conventional PCI ECN, 13 April 2006,
@@ -4560,7 +4582,10 @@ static int pci_af_flr(struct pci_dev *dev, bool probe)
 	 */
 	msleep(100);
 
-	return pci_dev_wait(dev, "AF_FLR", PCIE_RESET_READY_POLL_MS);
+	ret = pci_dev_wait(dev, "AF_FLR", PCIE_RESET_READY_POLL_MS);
+done:
+	pci_dev_reset_iommu_done(dev);
+	return ret;
 }
 
 /**
@@ -4581,6 +4606,7 @@ static int pci_af_flr(struct pci_dev *dev, bool probe)
 static int pci_pm_reset(struct pci_dev *dev, bool probe)
 {
 	u16 csr;
+	int ret;
 
 	if (!dev->pm_cap || dev->dev_flags & PCI_DEV_FLAGS_NO_PM_RESET)
 		return -ENOTTY;
@@ -4595,6 +4621,12 @@ static int pci_pm_reset(struct pci_dev *dev, bool probe)
 	if (dev->current_state != PCI_D0)
 		return -EINVAL;
 
+	ret = pci_dev_reset_iommu_prepare(dev);
+	if (ret) {
+		pci_err(dev, "failed to stop IOMMU for a PCI reset: %d\n", ret);
+		return ret;
+	}
+
 	csr &= ~PCI_PM_CTRL_STATE_MASK;
 	csr |= PCI_D3hot;
 	pci_write_config_word(dev, dev->pm_cap + PCI_PM_CTRL, csr);
@@ -4605,7 +4637,9 @@ static int pci_pm_reset(struct pci_dev *dev, bool probe)
 	pci_write_config_word(dev, dev->pm_cap + PCI_PM_CTRL, csr);
 	pci_dev_d3_sleep(dev);
 
-	return pci_dev_wait(dev, "PM D3hot->D0", PCIE_RESET_READY_POLL_MS);
+	ret = pci_dev_wait(dev, "PM D3hot->D0", PCIE_RESET_READY_POLL_MS);
+	pci_dev_reset_iommu_done(dev);
+	return ret;
 }
 
 /**
@@ -5033,10 +5067,20 @@ static int pci_reset_bus_function(struct pci_dev *dev, bool probe)
 		return -ENOTTY;
 	}
 
+	rc = pci_dev_reset_iommu_prepare(dev);
+	if (rc) {
+		pci_err(dev, "failed to stop IOMMU for a PCI reset: %d\n", rc);
+		return rc;
+	}
+
 	rc = pci_dev_reset_slot_function(dev, probe);
 	if (rc != -ENOTTY)
-		return rc;
-	return pci_parent_bus_reset(dev, probe);
+		goto done;
+
+	rc = pci_parent_bus_reset(dev, probe);
+done:
+	pci_dev_reset_iommu_done(dev);
+	return rc;
 }
 
 static int cxl_reset_bus_function(struct pci_dev *dev, bool probe)
@@ -5060,6 +5104,12 @@ static int cxl_reset_bus_function(struct pci_dev *dev, bool probe)
 	if (rc)
 		return -ENOTTY;
 
+	rc = pci_dev_reset_iommu_prepare(dev);
+	if (rc) {
+		pci_err(dev, "failed to stop IOMMU for a PCI reset: %d\n", rc);
+		return rc;
+	}
+
 	if (reg & PCI_DVSEC_CXL_PORT_CTL_UNMASK_SBR) {
 		val = reg;
 	} else {
@@ -5074,6 +5124,7 @@ static int cxl_reset_bus_function(struct pci_dev *dev, bool probe)
 		pci_write_config_word(bridge, dvsec + PCI_DVSEC_CXL_PORT_CTL,
 				      reg);
 
+	pci_dev_reset_iommu_done(dev);
 	return rc;
 }
 
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 214ed060ca1b3..75b6786af01b8 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -21,6 +21,7 @@
 #include <linux/pci.h>
 #include <linux/isa-dma.h> /* isa_dma_bridge_buggy */
 #include <linux/init.h>
+#include <linux/iommu.h>
 #include <linux/delay.h>
 #include <linux/acpi.h>
 #include <linux/dmi.h>
@@ -4226,6 +4227,22 @@ static const struct pci_dev_reset_methods pci_dev_reset_methods[] = {
 	{ 0 }
 };
 
+static int __pci_dev_specific_reset(struct pci_dev *dev, bool probe,
+				    const struct pci_dev_reset_methods *i)
+{
+	int ret;
+
+	ret = pci_dev_reset_iommu_prepare(dev);
+	if (ret) {
+		pci_err(dev, "failed to stop IOMMU for a PCI reset: %d\n", ret);
+		return ret;
+	}
+
+	ret = i->reset(dev, probe);
+	pci_dev_reset_iommu_done(dev);
+	return ret;
+}
+
 /*
  * These device-specific reset methods are here rather than in a driver
  * because when a host assigns a device to a guest VM, the host may need
@@ -4240,7 +4257,7 @@ int pci_dev_specific_reset(struct pci_dev *dev, bool probe)
 		     i->vendor == (u16)PCI_ANY_ID) &&
 		    (i->device == dev->device ||
 		     i->device == (u16)PCI_ANY_ID))
-			return i->reset(dev, probe);
+			return __pci_dev_specific_reset(dev, probe, i);
 	}
 
 	return -ENOTTY;
-- 
2.43.0


