Return-Path: <kvm+bounces-66047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B35D1CBFFF5
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 22:44:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CCADD30253E3
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 21:43:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACB502C17B6;
	Mon, 15 Dec 2025 21:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qo2JboDD"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013035.outbound.protection.outlook.com [40.93.201.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82B432C94D;
	Mon, 15 Dec 2025 21:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765834980; cv=fail; b=SGeKQsKVbzzA96Fy6zBbzcuH+2tHvEnV2vdAbXoP7zUbTI+y04esdZyFZ/BhUKC2UzREUWA/wMox1ek032iAbIZCHgOk7UOuDyaDGKimiyat0JUOJ9X7qnCnSIf2cfjqp2Fw3H/xPo8QlR/tKwX3ye9gV3wVzfLzakkYjoigtq0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765834980; c=relaxed/simple;
	bh=m0m6NR6UaQ9DJkdRwSPcvCXwP/14cZyD9lacrehRC/A=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gqOK0Uflu/Q0dJFzaPtDAs3ZTpZNGvQ+9lX5hAucA2g/NruJNFkf/zOdGD6EmJLA3anV+uUWQioE12Qfd8BoJO+FoWq8GfRrw7IOoc7qchyM9RZyyll6n+nTYaEDMohsy7Xb1CoYwNPg8pQD9qOGgtQcd2f2PJOpNywRROBFTRA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qo2JboDD; arc=fail smtp.client-ip=40.93.201.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KIUTtAdlnCXN6UzGG+BTJXvDY5+oCYYyMFcMak5TqY8FysRdq/TgDFWM+2JB9nLzN2+fqSCeFWfQfDhIjEcDlK3QdMgpdyiEV+oW15SkKZ0UcsVjYdZW6xKyFB5skx7rjdoWAzmziqlhf05oFaUeMjyX5wbkSw0TyfgNR6DqR5juSkMqi159Iy0X9M1utAEEn7+U0tVbSg7KKokGTKI03i+SRFoUDgCYZUEIKm2wkRXsux02HAPPCdxtDbaCSSlVYa57ivcUYh1n6mdBGCGHFDP1geSl/zB2pxW5fBx90y2gaBEXXvTI1N9R8H29m5o2H5WH+p2JnNKOMA7xOtCOog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6IW2oZh4BWK7+aKMpy8XGXYilcuC0XOx4rEt6C/xwOc=;
 b=GKD19gA/OSMpNMOGZRwbfzhNTNU3uUJkYvPjTTCWXKYv5zn56JAyxexIFTpZc9FTJH833hbPnNolDpVbFrrJUM3l6FTfSjyvObQfM+KRD57EAlvSmvuPbGYa+eeD56sSLXQJD5GmiDh5brCRzeFCkJASUOMmNwHgRNOley18BFlZmaxONe1WW6huvGzWNyE7KBT0l3um4xiT1gXFeAvQ5JxcYOQytkF3/yYbIq07Bypt5nskm9Z+6Xen5R8GDVoFbTPEqDfOC5JOOHCPKO5zbeIG83RBe76SOiBVnamiGV9i8qqpJRZNd+ai95Wj669yNe/BSXNejH6QlmAm/sEreg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=8bytes.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6IW2oZh4BWK7+aKMpy8XGXYilcuC0XOx4rEt6C/xwOc=;
 b=qo2JboDDFDMTBxDSmjd/wxr8k9Vvcn4mugE0w8+ougqdsh9accdXIVIQ8iZMYFkG1qKZkAXoRuOEhjlPskcuKlviNQhkHZfsy/koLgWP/zhzXUIUb5vZ3JhypMeIscBsfaP9YGsARwZ0QsXifOp+LZEeGVBadnmacVwbkLBnabmDDIkiHXV4Yx6aXfqsLPs9r7+T8+CPpCYsfrYb/aNKWvyW2XYlaB8GAMaR5OL7UrwKhhXhRlAva8C3X/OXyfFbcp3VTSSLg0AFYprPTHe0RWvi7scpXq0PP7lh5ITI5wePmzcVJHO14pz6Kwla9ieR7ccjgwMUKUffbzZiuwE5Vg==
Received: from CH0PR03CA0277.namprd03.prod.outlook.com (2603:10b6:610:e6::12)
 by SA0PR12MB4479.namprd12.prod.outlook.com (2603:10b6:806:95::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 21:42:53 +0000
Received: from CH1PEPF0000AD7B.namprd04.prod.outlook.com (2603:10b6:610:e6::4)
 by CH0PR03CA0277.outlook.office365.com (2603:10b6:610:e6::12) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.13
 via Frontend Transport; Mon, 15 Dec 2025 21:42:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH1PEPF0000AD7B.mail.protection.outlook.com (10.167.244.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Mon, 15 Dec 2025 21:42:53 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 15 Dec
 2025 13:42:34 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 15 Dec 2025 13:42:34 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Mon, 15 Dec 2025 13:42:33 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <joro@8bytes.org>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <afael@kernel.org>,
	<lenb@kernel.org>, <bhelgaas@google.com>, <alex@shazbot.org>,
	<jgg@nvidia.com>, <kevin.tian@intel.com>, <baolu.lu@linux.intel.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
	<patches@lists.linux.dev>, <pjaroszynski@nvidia.com>, <vsethi@nvidia.com>,
	<helgaas@kernel.org>, <etzhao1900@gmail.com>
Subject: [PATCH v8 5/5] PCI: Suspend iommu function prior to resetting a device
Date: Mon, 15 Dec 2025 13:42:20 -0800
Message-ID: <348c50ab6e95b5ec6d48ee3fa05d529a784a34c3.1765834788.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1765834788.git.nicolinc@nvidia.com>
References: <cover.1765834788.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7B:EE_|SA0PR12MB4479:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c7259a3-290b-4544-5679-08de3c22e700
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|1800799024|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rtfvOZ5Hmv/useHYXgvnhtwbjGHAEAsVXAzBK5tnhSRTHMB0sPaWl+szqacj?=
 =?us-ascii?Q?SOCc0dHqj2Pc706g2EecdZ5jcwvJs2+o4L1Ws+y+AQ+UIF3iUKejjMbAZ1dK?=
 =?us-ascii?Q?h/+cND66zUjINKJF4E6kJKKg651W5IMPLQPvs1iZbjK7oYZhmA5MQBRnYmTz?=
 =?us-ascii?Q?7/2ZbF8FE1oj/v2NvTg5W6/xd5+o2T9zOHEtJmhG6/0KJfg+S/ZO07QU4k0W?=
 =?us-ascii?Q?OA1zzQIGSHOcb6WimhSqrLJ6Vx6Wz2/X/0o/1Llf1ROdOYqTHS9J1JFPwDTa?=
 =?us-ascii?Q?SV8k5WiQnzQ7M4/c2eo4BOFUQTRCrsi74PsE1L6rJBiMmNH5k3+qNJPKpNJr?=
 =?us-ascii?Q?hyKQMiJFBNnsWNsRtK6SWaZ5Oa30R2FvedeTlt0fD211VRxtXeXc1PhwO6KN?=
 =?us-ascii?Q?L0q7Kd08EpymJBQ0UCyl0KxkcTfZkzY+cs8l7nOBVdqRvI6HnvZWZ+n8wkWG?=
 =?us-ascii?Q?LUegXyq2544MvCMc/O2tRh18u/Tkmfkg6RBiqLdA03TS5ssnSP3Z2gvJ1aub?=
 =?us-ascii?Q?Wpjc87X8TNoHkb/UXoZUiUaBzN9ZYPmlNAHLLp8nPwPF0PGY8Z9UicWNbB7M?=
 =?us-ascii?Q?nzocMPtqhsmJtlRpWYe57vzJhij1LQel/n5A3o5Go03s7GZnNvNwyqm+kpoJ?=
 =?us-ascii?Q?rsZXaaTBbgTQWw9xIxQ7hg33mksgyNn4YW0iv87fNhNjmvD2q3XddWL/Fsd9?=
 =?us-ascii?Q?/pF2bba048jW/h+rDG3gf7ViseTQLnw/AsRjDZKj+8pVDiV7vLtAOmxDCk21?=
 =?us-ascii?Q?M1t4DFa7kUyq0wM+0AI9uis9TwcYcj8Kyb2fGIS4WbzwkarqJVWKOubRzYwa?=
 =?us-ascii?Q?2dzJ6qYIXL5oW7e2lF8nrZ8Ysy6X4m9TwOkqF1a7/yXqYynfqjhGMIZLBP5/?=
 =?us-ascii?Q?F2OQ847QTy3tmw5PiKeIMb+oteen1g5uPuzy9jhQka3+H201YPCtgZ46SroO?=
 =?us-ascii?Q?KpyALHSUpo2sdtgcZnk6BF7hoDG4g8dk7tuVdAwdNJiKV9ff+qJFfZlrbdB2?=
 =?us-ascii?Q?DOhOhVeC1iCTRbUdVkMO3I/CFaXbf53EFC+WPdnuubB+4VzZq7FrD6M6YaX+?=
 =?us-ascii?Q?frU5Eeale1d00O8TgtxA9H9skTggTXus/a5R8EHXTbFrxlbbW+m2+/VZ61DA?=
 =?us-ascii?Q?obf9qQwmhcmj1N8ihVXR5HhhjrgPC8iChmCOco118nRXi/AeeaVd6ZQBtDBj?=
 =?us-ascii?Q?g+UM83sP8VI30lbPZkem7F3HYUFGiKpRQF3NRHnMZtg43cV2V8NIWAM5kB5B?=
 =?us-ascii?Q?Gd/cKBGPCd0QigV7ZArIfNwFGtUCuGq4Z/KLb66LOQ4EGocixAqk0mWxq/s/?=
 =?us-ascii?Q?HDLmYtU4Vm6JQMEoaP7UWrhmWyTcadOFu1TrC0Ph1w8J/5HA5v1pZdrIxzA3?=
 =?us-ascii?Q?eqQmY+iJ5dBit/4+1WJgnkq2BKYiDwzSTXI2Aml7o+vw7+x29Ry33SC8UHt2?=
 =?us-ascii?Q?THL7PGYYK3MeTjMehEI+otzz6/VBoYmLw0jXrJbqwfBXz/y+Owa64Gw0W5TZ?=
 =?us-ascii?Q?6zkOebvf1VocdTuZv873CvXkOp3lUn7FhTWIWaDm1jFNSDErUqUdgz27zkfn?=
 =?us-ascii?Q?6H1yDV6cCR45R7EZxx4=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(1800799024)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 21:42:53.3897
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c7259a3-290b-4544-5679-08de3c22e700
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4479

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
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/pci/pci-acpi.c | 13 +++++++--
 drivers/pci/pci.c      | 65 +++++++++++++++++++++++++++++++++++++-----
 drivers/pci/quirks.c   | 19 +++++++++++-
 3 files changed, 87 insertions(+), 10 deletions(-)

diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
index 9369377725fa..651d9b5561ff 100644
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
index 13dbb405dc31..a0ba42ae7ee0 100644
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
@@ -4330,13 +4332,22 @@ EXPORT_SYMBOL(pci_wait_for_pending_transaction);
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
@@ -4345,7 +4356,10 @@ int pcie_flr(struct pci_dev *dev)
 	 */
 	msleep(100);
 
-	return pci_dev_wait(dev, "FLR", PCIE_RESET_READY_POLL_MS);
+	ret = pci_dev_wait(dev, "FLR", PCIE_RESET_READY_POLL_MS);
+done:
+	pci_dev_reset_iommu_done(dev);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(pcie_flr);
 
@@ -4373,6 +4387,7 @@ EXPORT_SYMBOL_GPL(pcie_reset_flr);
 
 static int pci_af_flr(struct pci_dev *dev, bool probe)
 {
+	int ret;
 	int pos;
 	u8 cap;
 
@@ -4399,10 +4414,17 @@ static int pci_af_flr(struct pci_dev *dev, bool probe)
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
@@ -4412,7 +4434,10 @@ static int pci_af_flr(struct pci_dev *dev, bool probe)
 	 */
 	msleep(100);
 
-	return pci_dev_wait(dev, "AF_FLR", PCIE_RESET_READY_POLL_MS);
+	ret = pci_dev_wait(dev, "AF_FLR", PCIE_RESET_READY_POLL_MS);
+done:
+	pci_dev_reset_iommu_done(dev);
+	return ret;
 }
 
 /**
@@ -4433,6 +4458,7 @@ static int pci_af_flr(struct pci_dev *dev, bool probe)
 static int pci_pm_reset(struct pci_dev *dev, bool probe)
 {
 	u16 csr;
+	int ret;
 
 	if (!dev->pm_cap || dev->dev_flags & PCI_DEV_FLAGS_NO_PM_RESET)
 		return -ENOTTY;
@@ -4447,6 +4473,12 @@ static int pci_pm_reset(struct pci_dev *dev, bool probe)
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
@@ -4457,7 +4489,9 @@ static int pci_pm_reset(struct pci_dev *dev, bool probe)
 	pci_write_config_word(dev, dev->pm_cap + PCI_PM_CTRL, csr);
 	pci_dev_d3_sleep(dev);
 
-	return pci_dev_wait(dev, "PM D3hot->D0", PCIE_RESET_READY_POLL_MS);
+	ret = pci_dev_wait(dev, "PM D3hot->D0", PCIE_RESET_READY_POLL_MS);
+	pci_dev_reset_iommu_done(dev);
+	return ret;
 }
 
 /**
@@ -4885,10 +4919,20 @@ static int pci_reset_bus_function(struct pci_dev *dev, bool probe)
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
@@ -4912,6 +4956,12 @@ static int cxl_reset_bus_function(struct pci_dev *dev, bool probe)
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
@@ -4926,6 +4976,7 @@ static int cxl_reset_bus_function(struct pci_dev *dev, bool probe)
 		pci_write_config_word(bridge, dvsec + PCI_DVSEC_CXL_PORT_CTL,
 				      reg);
 
+	pci_dev_reset_iommu_done(dev);
 	return rc;
 }
 
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index b9c252aa6fe0..c6b999045c70 100644
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


