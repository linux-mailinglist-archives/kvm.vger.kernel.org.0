Return-Path: <kvm+bounces-62710-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B099EC4B857
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 06:15:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 99AE54E85B6
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 05:15:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DD3D34AB1C;
	Tue, 11 Nov 2025 05:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cmi8f/B4"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010058.outbound.protection.outlook.com [52.101.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8B7330B17;
	Tue, 11 Nov 2025 05:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762838019; cv=fail; b=f4XSmM4Jmf6JtpEMXsEpc5vrlyR4dI0JqhyFLD3mXPucjxnEzAA7ZMM/0RsUzGGQNfW8S6xnLOEY3UpeSooCG/QZ7pSLW2UZ6cxdChGZ87GCoSBMG7gdfa+tsiSocL6y676C9wb0qyf6ysYQyXHKcQpgQUzcghKCkW7E18kfo4A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762838019; c=relaxed/simple;
	bh=ZJX5N1Rr9JdNAM2XRZU7RH3LAPoN9ZKg5Gm0t3INROU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FDO4bd2vayXqvrAhEDtBz+C7xUCBurm/L1huLs70Qq2B0iXxzEfwOIIdGgbsHd9C2q71z3FEuuCa2qMmP48GvVe+GDfiBlu51HgCmVW+eYw+geAtFEIZI/G7lqnXfkvwyY9dbxrO8Lq6oa8f3+6P7/O/K6AlAsS9bgOuLOkvphY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cmi8f/B4; arc=fail smtp.client-ip=52.101.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VQr60TFzL2IfDPlKotau7wm0v0HVS1pa1VfpVIzp60Pmtam1Dq0SeIzZj7rt5x+FnRlMkLWlHexKa/iVIzqNrM0U2TSfsZVxXd2StQcj0U0WFLBrYW/bLqKnfaJKXhS2kD0vSiu91qqPOsNxZpdzG6xk7Q6EsDDNXtOFZgfzkEyAviVmLNFrwzZv3JGT2iuoEbwtcgShou70nxZhFK8UluVSEgeEsHfSkMagkMj6rmmtPSJvxfRSB08vneybPlzKwuCn1JTO4u2NM811T21CTcsQko3SBphQ6EYqgG+728LX8CxrBdVWoUkQwKbzSFUwZUClYjvHAqkcRxj35vrFFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=47SwClVEBmWKhq6f3/c2ek+dy71oJ6NAilDIk9ANSFE=;
 b=NnQLn6G6yK0dZCCbxt0SOXnu2ZW8c3gGdC4QNq/mZMRw9cWNpel+v3ft0peZfzocKZN+98BOtyybj2sJzpSCLQdhI3viTnva6Db4YY5Z57CT8y2TH83W7II8KpPF4T28R4IR/ApECO6qlEXRG/Afxps7YkvflYVDsxBWD7tVLK0ilTRVPs7cWOa6WR4KOsppyoOhyJ4MP92vf90F82J8PB2UoPjItpHV3CQXffXtCZ+yQ3g8BKe0+HDlb/NCQJ65zyDLJ+L2Js4dgaD3C2WGNnsSRJJXmPaloYY9iGC/Gi1X5a9oHcszmFZOXoVVOCgnNvggWVbSJqu2L4d5RdrN8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=8bytes.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=47SwClVEBmWKhq6f3/c2ek+dy71oJ6NAilDIk9ANSFE=;
 b=cmi8f/B4algHRU4lQf93Jyg19q7k04g9s9taue5ChkAJoDQS1c0W0dAyicvE9avYm5b6JQeBVuZKdMNb1rupGVdzicWxLy9kOGs6SusrZf0qo3PPFFfyq3pmjIj6QUqFrVvTzL2n+YhVVlh0II9LmU3lPat/9XEFtaljAz+2mzkfjXQEqWngCu665IKz/Jo2Kbi/Q/mu/SOSIuPj1uMs2VD4vWVI2qcpkalsKYODvAKtEgjQNmBYxxAHjxqEuN1QF5eXzK/LRqkeJt3hGoJgsk24QDOBbvh/GLlEqaZW7PEoni2zS8b3GdCmA2IS2ZrqazaGufWdJnRvv97ScBkXRw==
Received: from DM6PR01CA0015.prod.exchangelabs.com (2603:10b6:5:296::20) by
 SA1PR12MB6871.namprd12.prod.outlook.com (2603:10b6:806:25f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Tue, 11 Nov
 2025 05:13:31 +0000
Received: from DS3PEPF0000C37A.namprd04.prod.outlook.com
 (2603:10b6:5:296:cafe::2) by DM6PR01CA0015.outlook.office365.com
 (2603:10b6:5:296::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9298.16 via Frontend Transport; Tue,
 11 Nov 2025 05:12:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS3PEPF0000C37A.mail.protection.outlook.com (10.167.23.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Tue, 11 Nov 2025 05:13:31 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 10 Nov
 2025 21:13:22 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 10 Nov
 2025 21:13:21 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Mon, 10 Nov 2025 21:13:20 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <joro@8bytes.org>, <afael@kernel.org>, <bhelgaas@google.com>,
	<alex@shazbot.org>, <jgg@nvidia.com>, <kevin.tian@intel.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <lenb@kernel.org>,
	<baolu.lu@linux.intel.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-acpi@vger.kernel.org>, <linux-pci@vger.kernel.org>,
	<kvm@vger.kernel.org>, <patches@lists.linux.dev>, <pjaroszynski@nvidia.com>,
	<vsethi@nvidia.com>, <helgaas@kernel.org>, <etzhao1900@gmail.com>
Subject: [PATCH v5 5/5] pci: Suspend iommu function prior to resetting a device
Date: Mon, 10 Nov 2025 21:12:55 -0800
Message-ID: <a166b07a254d3becfcb0f86e4911af556acbe2a9.1762835355.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1762835355.git.nicolinc@nvidia.com>
References: <cover.1762835355.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37A:EE_|SA1PR12MB6871:EE_
X-MS-Office365-Filtering-Correlation-Id: 279c5b1d-5a07-4932-4bfa-08de20e10e6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ltn1gNgobxlClyLIZ0DvNvMuqpsc2pi4/eJZrntRrV9/gDurj5coYc5ED+e8?=
 =?us-ascii?Q?fy9XgKJtZPREwWlpooocvLj8zWOmHNqH+2NLvZv1CL82nVIQkF2Xc3jjU39O?=
 =?us-ascii?Q?OoeJm72e42helZ6JZmjhoggU1ISzSSl4oFlC5MzsNUXvYo8XKB0I4LzAqjbX?=
 =?us-ascii?Q?bB3qX+7xAuvMlBXyciXt6WXAE+3pMGrz7zg+Dxu4U6OqqwnLX5Jj4GF/ulnC?=
 =?us-ascii?Q?hd8Ud/G/6jfAj7cTgoQkmj7q3vLbz+luIzPnd6Qk+Cp7/wiuMyQBX7jIPL9C?=
 =?us-ascii?Q?a6BJtl/JLwrIPtwCKNozzM5HFZbhE7JmcVqfXpFFxDowSg8nH+5ogjBgH07Y?=
 =?us-ascii?Q?VgehLVa2N1NEfhfrTRLi8RUoObiqjvDUHMZbCbX/gw+Ns9ymEZrTv9Dxz8hO?=
 =?us-ascii?Q?mQ1DHvumaGJBQVHuaofePjppoCCF5k9FTaJJonZT8GZAeO9LRotiENNgV8Vh?=
 =?us-ascii?Q?feinlQWWOpa7BlpXDOo5c/Ow7jVosBxujVJsbzMNPsT0Aoc1HOpGI2PYmd85?=
 =?us-ascii?Q?VhpQncJjanLVWNBpQOwq87oGOou9lsRoHBt7NxIA6y8kDQwbZA6ZjJky8Fjl?=
 =?us-ascii?Q?JujNWxGJJzals4BLTofsAdRhuhlb0avzxzK4riBiDKTjUOjxiDJcjKvXQAmD?=
 =?us-ascii?Q?WUItOplDoAKFe5QRAURUa6V9M2pwpedeWDFMX+QEiP6/FvBAA5d//Zz5TJb6?=
 =?us-ascii?Q?LeVuOTdVLsL1/BbiNFiVCAtFj3y5zVkanNeBAMVBQUQOzqD8k7nIKVoqxclC?=
 =?us-ascii?Q?E9Q+2ItGDh99q4EQ+NrGbScfBWFzlFxogCL4QyIl+4Ob1RqrlRrrtHtgcHKL?=
 =?us-ascii?Q?S+w4VLrqM896PD0kfHPzk7GtMRd+mf+Qbj5CVDS4yS4wmNIWPswSfn788NkH?=
 =?us-ascii?Q?OcWiHT+GEZ1vPr1btUJNUYW9FR9/Hlynf+Pfj3cW1KlSkyOBwJlKFaHWjJnE?=
 =?us-ascii?Q?yt3ymLkPmGlcHX10BtiRp/qCGEdcRo9lfxpMkC1SNxVDQ213xki0xnYTVLQb?=
 =?us-ascii?Q?RB94GECRkrTq6k1nbylzWcUT3psqBr+ErL14zywwpNiPHXlo0nes6k906Cgw?=
 =?us-ascii?Q?BPsK6yfR1SZf4afB+gXnw9L+rpvSRJcGJEMxIOx5mZ1Sxuap9O3suWRGODpS?=
 =?us-ascii?Q?Db+Oy2IufinYoOrlwT/SOxx5Z6hNS+2eXzc144ZdHznSdjRRQwBkjPOYp1La?=
 =?us-ascii?Q?2fCXCv1zznC4T5NaXzlHpyti3OVePI0V0wmkClpMWFwC2eE6D8fX5B53uWVl?=
 =?us-ascii?Q?Y4KDVClmycSIjBARRf9GBfWH9Jd9SxC3DXCVwwEEeCcEAWJJfgt8x/aa9TIh?=
 =?us-ascii?Q?TA3w3hiKVeqomlg5ih+1RQfZqNP6LJSB4Oo9AgzZYcXnNsRM2h3EIRgnib6c?=
 =?us-ascii?Q?PBq53oomwHfUy4N62+HnA/JnfFhCSqo2VW1tyiMqEuMSk5k5AltqGQw26tjb?=
 =?us-ascii?Q?iwqn8W3P4c/nzOJZU7NQ4Np6N4Ox8T5b6ejc0p+o2pCm2EYB0gXJot4Hegpi?=
 =?us-ascii?Q?YP4fom4upJGBXOPJdDiUAs7sAsVKGwfsv98CjMf4S3UT0el1AWjvI+8awJ6J?=
 =?us-ascii?Q?knqzGkhcBJN3yz7c6Rs=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2025 05:13:31.3237
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 279c5b1d-5a07-4932-4bfa-08de20e10e6d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6871

PCIe permits a device to ignore ATS invalidation TLPs, while processing a
reset. This creates a problem visible to the OS where an ATS invalidation
command will time out: e.g. an SVA domain will have no coordination with a
reset event and can racily issue ATS invalidations to a resetting device.

The PCIe spec in sec 10.3.1 IMPLEMENTATION NOTE recommends to disable and
block ATS before initiating a Function Level Reset. It also mentions that
other reset methods could have the same vulnerability as well.

Now iommu_dev_reset_prepare/done() helpers are introduced for this matter.
Use them in all the existing reset functions, which will attach the device
to an IOMMU_DOMAIN_BLOCKED during a reset, so as to allow IOMMU driver to:
 - invoke pci_disable_ats() and pci_enable_ats(), if necessary
 - wait for all ATS invalidations to complete
 - stop issuing new ATS invalidations
 - fence any incoming ATS queries

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/pci/pci.h      |  2 ++
 drivers/pci/pci-acpi.c | 12 ++++++--
 drivers/pci/pci.c      | 68 ++++++++++++++++++++++++++++++++++++++----
 drivers/pci/quirks.c   | 18 ++++++++++-
 4 files changed, 92 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 4492b809094b5..a29286dfd870c 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -198,6 +198,8 @@ void pci_init_reset_methods(struct pci_dev *dev);
 int pci_bridge_secondary_bus_reset(struct pci_dev *dev);
 int pci_bus_error_reset(struct pci_dev *dev);
 int __pci_reset_bus(struct pci_bus *bus);
+int pci_reset_iommu_prepare(struct pci_dev *dev);
+void pci_reset_iommu_done(struct pci_dev *dev);
 
 struct pci_cap_saved_data {
 	u16		cap_nr;
diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
index 9369377725fa0..60d29b183f2c2 100644
--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -971,6 +971,7 @@ void pci_set_acpi_fwnode(struct pci_dev *dev)
 int pci_dev_acpi_reset(struct pci_dev *dev, bool probe)
 {
 	acpi_handle handle = ACPI_HANDLE(&dev->dev);
+	int ret = 0;
 
 	if (!handle || !acpi_has_method(handle, "_RST"))
 		return -ENOTTY;
@@ -978,12 +979,19 @@ int pci_dev_acpi_reset(struct pci_dev *dev, bool probe)
 	if (probe)
 		return 0;
 
+	ret = pci_reset_iommu_prepare(dev);
+	if (ret) {
+		pci_err(dev, "failed to stop IOMMU\n");
+		return ret;
+	}
+
 	if (ACPI_FAILURE(acpi_evaluate_object(handle, "_RST", NULL, NULL))) {
 		pci_warn(dev, "ACPI _RST failed\n");
-		return -ENOTTY;
+		ret = -ENOTTY;
 	}
 
-	return 0;
+	pci_reset_iommu_done(dev);
+	return ret;
 }
 
 bool acpi_pci_power_manageable(struct pci_dev *dev)
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index b14dd064006cc..52461d952cbf1 100644
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
@@ -95,6 +97,23 @@ bool pci_reset_supported(struct pci_dev *dev)
 	return dev->reset_methods[0] != 0;
 }
 
+/*
+ * Per PCIe r6.3, sec 10.3.1 IMPLEMENTATION NOTE, software disables ATS before
+ * initiating a reset. Notify the iommu driver that enabled ATS.
+ */
+int pci_reset_iommu_prepare(struct pci_dev *dev)
+{
+	if (pci_ats_supported(dev))
+		return iommu_dev_reset_prepare(&dev->dev);
+	return 0;
+}
+
+void pci_reset_iommu_done(struct pci_dev *dev)
+{
+	if (pci_ats_supported(dev))
+		iommu_dev_reset_done(&dev->dev);
+}
+
 #ifdef CONFIG_PCI_DOMAINS
 int pci_domains_supported = 1;
 #endif
@@ -4478,13 +4497,22 @@ EXPORT_SYMBOL(pci_wait_for_pending_transaction);
  */
 int pcie_flr(struct pci_dev *dev)
 {
+	int ret = 0;
+
 	if (!pci_wait_for_pending_transaction(dev))
 		pci_err(dev, "timed out waiting for pending transaction; performing function level reset anyway\n");
 
+	/* Have to call it after waiting for pending DMA transaction */
+	ret = pci_reset_iommu_prepare(dev);
+	if (ret) {
+		pci_err(dev, "failed to stop IOMMU\n");
+		return ret;
+	}
+
 	pcie_capability_set_word(dev, PCI_EXP_DEVCTL, PCI_EXP_DEVCTL_BCR_FLR);
 
 	if (dev->imm_ready)
-		return 0;
+		goto done;
 
 	/*
 	 * Per PCIe r4.0, sec 6.6.2, a device must complete an FLR within
@@ -4493,7 +4521,10 @@ int pcie_flr(struct pci_dev *dev)
 	 */
 	msleep(100);
 
-	return pci_dev_wait(dev, "FLR", PCIE_RESET_READY_POLL_MS);
+	ret = pci_dev_wait(dev, "FLR", PCIE_RESET_READY_POLL_MS);
+done:
+	pci_reset_iommu_done(dev);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(pcie_flr);
 
@@ -4521,6 +4552,7 @@ EXPORT_SYMBOL_GPL(pcie_reset_flr);
 
 static int pci_af_flr(struct pci_dev *dev, bool probe)
 {
+	int ret = 0;
 	int pos;
 	u8 cap;
 
@@ -4547,10 +4579,17 @@ static int pci_af_flr(struct pci_dev *dev, bool probe)
 				 PCI_AF_STATUS_TP << 8))
 		pci_err(dev, "timed out waiting for pending transaction; performing AF function level reset anyway\n");
 
+	/* Have to call it after waiting for pending DMA transaction */
+	ret = pci_reset_iommu_prepare(dev);
+	if (ret) {
+		pci_err(dev, "failed to stop IOMMU\n");
+		return ret;
+	}
+
 	pci_write_config_byte(dev, pos + PCI_AF_CTRL, PCI_AF_CTRL_FLR);
 
 	if (dev->imm_ready)
-		return 0;
+		goto done;
 
 	/*
 	 * Per Advanced Capabilities for Conventional PCI ECN, 13 April 2006,
@@ -4560,7 +4599,10 @@ static int pci_af_flr(struct pci_dev *dev, bool probe)
 	 */
 	msleep(100);
 
-	return pci_dev_wait(dev, "AF_FLR", PCIE_RESET_READY_POLL_MS);
+	ret = pci_dev_wait(dev, "AF_FLR", PCIE_RESET_READY_POLL_MS);
+done:
+	pci_reset_iommu_done(dev);
+	return ret;
 }
 
 /**
@@ -4581,6 +4623,7 @@ static int pci_af_flr(struct pci_dev *dev, bool probe)
 static int pci_pm_reset(struct pci_dev *dev, bool probe)
 {
 	u16 csr;
+	int ret;
 
 	if (!dev->pm_cap || dev->dev_flags & PCI_DEV_FLAGS_NO_PM_RESET)
 		return -ENOTTY;
@@ -4595,6 +4638,12 @@ static int pci_pm_reset(struct pci_dev *dev, bool probe)
 	if (dev->current_state != PCI_D0)
 		return -EINVAL;
 
+	ret = pci_reset_iommu_prepare(dev);
+	if (ret) {
+		pci_err(dev, "failed to stop IOMMU\n");
+		return ret;
+	}
+
 	csr &= ~PCI_PM_CTRL_STATE_MASK;
 	csr |= PCI_D3hot;
 	pci_write_config_word(dev, dev->pm_cap + PCI_PM_CTRL, csr);
@@ -4605,7 +4654,9 @@ static int pci_pm_reset(struct pci_dev *dev, bool probe)
 	pci_write_config_word(dev, dev->pm_cap + PCI_PM_CTRL, csr);
 	pci_dev_d3_sleep(dev);
 
-	return pci_dev_wait(dev, "PM D3hot->D0", PCIE_RESET_READY_POLL_MS);
+	ret = pci_dev_wait(dev, "PM D3hot->D0", PCIE_RESET_READY_POLL_MS);
+	pci_reset_iommu_done(dev);
+	return ret;
 }
 
 /**
@@ -5060,6 +5111,12 @@ static int cxl_reset_bus_function(struct pci_dev *dev, bool probe)
 	if (rc)
 		return -ENOTTY;
 
+	rc = pci_reset_iommu_prepare(dev);
+	if (rc) {
+		pci_err(dev, "failed to stop IOMMU\n");
+		return rc;
+	}
+
 	if (reg & PCI_DVSEC_CXL_PORT_CTL_UNMASK_SBR) {
 		val = reg;
 	} else {
@@ -5074,6 +5131,7 @@ static int cxl_reset_bus_function(struct pci_dev *dev, bool probe)
 		pci_write_config_word(bridge, dvsec + PCI_DVSEC_CXL_PORT_CTL,
 				      reg);
 
+	pci_reset_iommu_done(dev);
 	return rc;
 }
 
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 214ed060ca1b3..891d9e5a97e93 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4226,6 +4226,22 @@ static const struct pci_dev_reset_methods pci_dev_reset_methods[] = {
 	{ 0 }
 };
 
+static int __pci_dev_specific_reset(struct pci_dev *dev, bool probe,
+				    const struct pci_dev_reset_methods *i)
+{
+	int ret;
+
+	ret = pci_reset_iommu_prepare(dev);
+	if (ret) {
+		pci_err(dev, "failed to stop IOMMU\n");
+		return ret;
+	}
+
+	ret = i->reset(dev, probe);
+	pci_reset_iommu_done(dev);
+	return ret;
+}
+
 /*
  * These device-specific reset methods are here rather than in a driver
  * because when a host assigns a device to a guest VM, the host may need
@@ -4240,7 +4256,7 @@ int pci_dev_specific_reset(struct pci_dev *dev, bool probe)
 		     i->vendor == (u16)PCI_ANY_ID) &&
 		    (i->device == dev->device ||
 		     i->device == (u16)PCI_ANY_ID))
-			return i->reset(dev, probe);
+			return __pci_dev_specific_reset(dev, probe, i);
 	}
 
 	return -ENOTTY;
-- 
2.43.0


