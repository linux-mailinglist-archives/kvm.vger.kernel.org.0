Return-Path: <kvm+bounces-64275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B518FC7C255
	for <lists+kvm@lfdr.de>; Sat, 22 Nov 2025 03:00:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 0474034AB20
	for <lists+kvm@lfdr.de>; Sat, 22 Nov 2025 02:00:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 650262E0B5B;
	Sat, 22 Nov 2025 01:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nI34Tqv5"
X-Original-To: kvm@vger.kernel.org
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013014.outbound.protection.outlook.com [40.107.201.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C462DF153;
	Sat, 22 Nov 2025 01:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763776690; cv=fail; b=I4acrSAtKeFzLqiNKcflvavdC/a6bS4frSLlvz8jezXmWYtZGhU+dVTGX5hn40h7A3o/h2vUMVHwUIw9uKXQuaayfe6pG7MrGybirXHOzS0XyNCl+iB1lOgqcD9iG4tUe23XhmKYuaYGr5o82fB/0lfD47juhUgTdRewHpoyoPQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763776690; c=relaxed/simple;
	bh=qfEnrOiB6r3j6FK/VY9BO68j2aHsvbNRzWIwbH8dgHM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oIlVjzsiybLJPH39+NEvk6AHHXw6xMbaXqH1bqcQRIAhwa0LKuYeAYL02HJQens8SuoADciY5R0iBXP/PJ2lO+pLaymfv4jqGzm76cf8Aw3SstW5d2e1LU6ZVJjxaqK2gSVWnPy3QPSjVdboHexCzxikN+x0DMtf7yGURRD6/MA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nI34Tqv5; arc=fail smtp.client-ip=40.107.201.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cpojL8RrOd7/f3eILu95iTF4T3Tuxxgov5O2HDh1A37SKUUK1aZlC3XAOIXXbi2W35zCqpk5L0d/c9sV6cK5gQDiCxq0Pm/3uw/jfzOVwcVSldC8WQFPsz+7YyAx7PFVE5JgmQiYqwk08dkdWHg670shUb/o+oUkyQkW/bDo+KCe3XNvlNEG3fygLCPBM2FRcCIPJ0J7TsxX280470kcwNF+Rqe6WlN4WxV8gQSv1B5HcbL3BN0zE41lPjKvvUk8tXsb+BJKdjdTyhrOSpkBv+6bAoCTt70BfUXgZhy2B9R/oTW/6LDv2sbt6FMLkjXY+m+vUkV8tAfHDsTSxwlmgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DJyjdT9VsQxFprMzMoOoel6GSBU3MHSRF2/5TFDvkJ0=;
 b=rcQ/k0pRIUDt1NkQz/HR+Jqsc37rhKaD55U4BWXcvTSbap4t3FQ6R5b2nxnAAMzmn//KUWf8PcdhffRblFFzu2UfeWUsZ5MQoSTOLi6igzsIVRU3XDIxkDHvNslvc9ctY1vJrRlphmfMUMJIZNRX4HhD+mMdLDNkMqINqzsQnq93pVgfl6A7EH7aQ1OSfKEPitzRINT+0OD4iG0CcdJCZwX9k9lJ86ZfFFRUt2WvU+AKDA2jbhLos3q+76ig7X5oxUNuM5YE6+ihZ9k7k9pEXfQi41tCY1o063+AzWFipSXv5gYzESfLuCaKEKjpLc3IWy42x/Vb9ZmqDiMjkGoW9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=8bytes.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DJyjdT9VsQxFprMzMoOoel6GSBU3MHSRF2/5TFDvkJ0=;
 b=nI34Tqv51JyBqIoHD4N5s98YkPyTCxyw/2PQtxjVJLf4WLi8dP/AFWfYmZyXHgPAIeOG0fVcLhRm0mFMwXHZ11cczAJx6qgBFwxJAHXE6UadIBtzJJeqwVBYnE6c6tAOWk0MkXCse5ObnCOFeJsPRT3lClXrbyRmCwbNJ4Pfil19IayRGTL0/mmHRmzt+6JLyu++/jnMwJw0839wz62I6uXzzO96w7a0pYuJ3lhOEorqmyE2QPTvKg9YAb9OSVQrjuM6fqJ5/gYgeIXnikAjuwpBNqxLJgOnw9ofAr8dHDBRDqMeZlYUFXqobhl8ub2DMNmoy6EwsjbwyEytrJgIeg==
Received: from BN0PR04CA0091.namprd04.prod.outlook.com (2603:10b6:408:ec::6)
 by PH7PR12MB6609.namprd12.prod.outlook.com (2603:10b6:510:213::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.11; Sat, 22 Nov
 2025 01:58:02 +0000
Received: from BN1PEPF00005FFD.namprd05.prod.outlook.com
 (2603:10b6:408:ec:cafe::ae) by BN0PR04CA0091.outlook.office365.com
 (2603:10b6:408:ec::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.14 via Frontend Transport; Sat,
 22 Nov 2025 01:58:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN1PEPF00005FFD.mail.protection.outlook.com (10.167.243.229) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Sat, 22 Nov 2025 01:58:01 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 21 Nov
 2025 17:57:50 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Fri, 21 Nov 2025 17:57:50 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Fri, 21 Nov 2025 17:57:49 -0800
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
Subject: [PATCH v7 5/5] PCI: Suspend iommu function prior to resetting a device
Date: Fri, 21 Nov 2025 17:57:32 -0800
Message-ID: <4d2444cc52cf3885bfd5c8d86d5eeea8a5f67df8.1763775108.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1763775108.git.nicolinc@nvidia.com>
References: <cover.1763775108.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00005FFD:EE_|PH7PR12MB6609:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f2f76b7-61ed-4db0-941e-08de296a9147
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eERL8pFHXoxkPmJLmyrdTyxpeQHh4GAo2MVdWWbWAwvhCCe5ocOvNkF1xeWI?=
 =?us-ascii?Q?+fOqXKa/FKqN0ZHPNCS+5eWJLppPMe2rP9txPdBsnConZhoe71c04TNubaFl?=
 =?us-ascii?Q?bxzaK39Sf7wjun9sLfz7dRKxHn1mC70Uk4CvImAAt0YYVnasHJQtbMK6iHS1?=
 =?us-ascii?Q?HMHvs/eT9erP2FnysaPWK3zO53vLyFGTWN0Y+OgbJdDyIqNpSkqNP1dKa/Tc?=
 =?us-ascii?Q?+8hrwjsOEocvJDeAf47RpqUsUPVmFYIKBzU1P0UYBfN/HmwolG6Xa4iIc6Ek?=
 =?us-ascii?Q?US72enk05AWcjo9f1K04KcmYVjvk+5VRPupK1qupx9YPWK7Knrd8/N+8BQ+d?=
 =?us-ascii?Q?9Gi4cAPVeKuA6+G74ZqtmtAs2CsNJ5N5Pv31dB2uAI/VPN039mGVQCCtxAwH?=
 =?us-ascii?Q?v0S6vfyE5FnlIPY+PVyq3ivZqQPtUKp8Jc3gZV9Lcwjt/+n/UzAF594rYWdE?=
 =?us-ascii?Q?H0iJjFyaikVXoLL5jIqJQ/8o7bi/hu6fPR0w/QYZHivlknBH2dnw0d9BWVdz?=
 =?us-ascii?Q?bqnYhyc8nvJ1LvFROFArAlMqqKf2lHpvZ9vjVC4RLWy/CDJhHlM5JUJqYx32?=
 =?us-ascii?Q?K+z2wDoiTWgdwc/VQjmVUanBAC6g00NsfvcMta/0lK6v9DFJ1avWneCxZur4?=
 =?us-ascii?Q?Pd00SSbNFV6QZ/+Af1nwOo30OnU0vgUg+KvCd1Dd0RteiTMUcnetMoyHAu25?=
 =?us-ascii?Q?2ZYDkXHQsk7uk7cowYdSliqPEUAOdazovLKOuu+mrHPIVBVJHZC3CBgkDlox?=
 =?us-ascii?Q?NMSqvASQcEqz3QF+laKgJGVtU0ZGtIGEapVbToJPo3n3F4qQ7tT30BnZCyvB?=
 =?us-ascii?Q?0+GOQDT/LEr0Xf1KVuclgMh+8mFTIAGGxn2rWhD47GlUDP1vsTQdTpTpIYzw?=
 =?us-ascii?Q?tUbQKuaMeYKDfruenmp8NDZAFC/eTub14JXLqvr8sodE0ugqJfkTV2cUuzjy?=
 =?us-ascii?Q?SQGODGLbtXuVvtdZStmLHMzLEnVzDCJUaQyENsnc5YRa8hR0U5EpDrPJCBOD?=
 =?us-ascii?Q?BLJdG5m/pHFO4ShDGEI/XtHIyUyfcCDN/M+/+QvxesHdzFzq0IPDz1PXrupp?=
 =?us-ascii?Q?v86IoM3j0uAN9dvKF8BLktcG2DP0OTERp/tgLkghPU9HEeACNWRVyjiNGzxZ?=
 =?us-ascii?Q?86pbba/+bkYg1fLxPClDPgZP+kbAWmzOs3C+f8vOdJjmepV8F2Q/2LCS2ZlG?=
 =?us-ascii?Q?909+zYznUSLYL7y1FwddVMP0jOe1nCxeBNJZMx2HQ0nESP1LRdiw7XMbAYG9?=
 =?us-ascii?Q?APOu6h/S3byhcUHiCibTjdM+8V85/IqPvkUt5CWtPzWZ+1QLYSVVCgtKNhhz?=
 =?us-ascii?Q?TWYbYMY0pVQ5b4KdsECO1yOw1UD3VJOgPZheRf5uC3RY4w7k4XbhKU4k/jIm?=
 =?us-ascii?Q?Y5ROeFM3LDq+GgQIsfZ+2I7HLBx7D5X++sUQEGqpBtXKUO7fcNuONbSceo4E?=
 =?us-ascii?Q?nsYKeLMePq6+6TI7v0+R2QJ1Y6PLoRN+J304NDXyMHSU0yurDw0R4Mx/mrbY?=
 =?us-ascii?Q?u4NSIfTsIJsHwQyKuGRu/s/Dm+DnfibG86mp7SFRPKej3H82J/+dlIhUc4xo?=
 =?us-ascii?Q?UJ/abEZ5SQq444ldDlU=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2025 01:58:01.1263
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f2f76b7-61ed-4db0-941e-08de296a9147
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00005FFD.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6609

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

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
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
index b9c252aa6fe08..c6b999045c70a 100644
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
@@ -4228,6 +4229,22 @@ static const struct pci_dev_reset_methods pci_dev_reset_methods[] = {
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
@@ -4242,7 +4259,7 @@ int pci_dev_specific_reset(struct pci_dev *dev, bool probe)
 		     i->vendor == (u16)PCI_ANY_ID) &&
 		    (i->device == dev->device ||
 		     i->device == (u16)PCI_ANY_ID))
-			return i->reset(dev, probe);
+			return __pci_dev_specific_reset(dev, probe, i);
 	}
 
 	return -ENOTTY;
-- 
2.43.0


