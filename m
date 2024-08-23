Return-Path: <kvm+bounces-24901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AFC7895CDC6
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 15:28:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D58331C228E6
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 13:28:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33794186E47;
	Fri, 23 Aug 2024 13:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dEMgDd8/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2083.outbound.protection.outlook.com [40.107.94.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83FDF186E20;
	Fri, 23 Aug 2024 13:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724419716; cv=fail; b=ANV8Aqgr+0ab6AB7Hcm7n47EPH/xaVik1fh0metPrSIkE+D2pY4dqRMv9vLfpKHKJ30wOawMk95nDfBRVDeS9HzEY8gwzN/wwZ1lMLA46n4qHrOa4NIUcqzmz2s8Kls4/4iOZKQ7UxGvxMKxfu9FUDZV7me9rXd1v/185dTbAfc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724419716; c=relaxed/simple;
	bh=sIluQ+z5vKzS0Ve+e4WeU+O8hyHzDhEs0Qq6MGBwPuk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nEtGvQx7xu3q7o4KvEpEDvSr/KpryH0xCjY/1yuVoD8ry5JKRe4/Ia9Sd7eDsDLtiAUkh8pgE+EcA5iDAjOXPi1Y4cM++wFk99OdleVHM8bTBm69MeY3oRHw7j9NR/hWKaxykVgy7qzmSXIVUTEUpq43KY7jEuQsBktEa89TsV0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dEMgDd8/; arc=fail smtp.client-ip=40.107.94.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D5CIOKXV7kvo2j++xcwgFzXg+lxOVT+kmwgGfoVbYGYSI8IC8eVCZDIOU7gm/vrblHKV7nN6Kmbsi0j8U8NsiUgS82uoFazYtXE118YusI6kbuhTQX836EODz5zDREqm4gAV+TZ3Ucdcv8qg+AspVTm4YJ3VK2rtRXZqE4olHGYve7p+IqCpPkWZwBXylVybTzIEKRpHKxOZDdyh5aIvjUzdoeQ6JcLQBkog1QYiFWGDk2A6z0Dmynh9vqhsPRG32eT8K5RVwHRuea3aG/TrRwtZec67O1mfaxsBxly0CuF92mm/B8NoTe5iJyPNAZuXNvPP33QMcYa+kta3mpoDMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BvVGjfo12NbKcGRS65leXwnl7ZQxoXw+RxLqiYxXAsk=;
 b=fKymEDZo6UChkmhl0odPaCsslTA/BfgLiwgugKgzahyjo9FAEBA9WHDDlr5KxrljDP6EsrImAlPDpjueUV94Spycvb00jj0RA2nnni6XPaqGvYXF9NCmwgwmJxQ2gaqQ8TNe7/YUyncVF0qmC2wIrLZ3LPQw28ve+J4b4nrSd7z8qTWfGGWr185VPtKrid96PEEAm2Dc5he5wl88EIJ+UHoaCPPNuqD85isGTU9ZeDuuZ4dGYmnIGtb12y/i1p9usfOMxY+bPRv9Xho5V446MuVpMkw3oZ0Q+X0sunN/Rogj9052F5E2wRSFtZgtgso18MMyihRo5kzqA5m2GQiMjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BvVGjfo12NbKcGRS65leXwnl7ZQxoXw+RxLqiYxXAsk=;
 b=dEMgDd8/qeRoD6d3y7OWdqEilmIQv4AQ1/Pc3VvAYupHjODM2TRdsyGMcBMzlk9MXb/Q2YpGhQB0grEgmcxhHVcD1cmD+2vO3T4WfQLSg72mTKUe+IA/di8+sDvo74gYNmJ4WkKo0yw6C7yGaGBUyW0/jrzrXa1ubXW7QulnkxA=
Received: from CH2PR18CA0012.namprd18.prod.outlook.com (2603:10b6:610:4f::22)
 by SA3PR12MB9158.namprd12.prod.outlook.com (2603:10b6:806:380::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.19; Fri, 23 Aug
 2024 13:28:29 +0000
Received: from DS2PEPF0000343A.namprd02.prod.outlook.com
 (2603:10b6:610:4f:cafe::d8) by CH2PR18CA0012.outlook.office365.com
 (2603:10b6:610:4f::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21 via Frontend
 Transport; Fri, 23 Aug 2024 13:28:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343A.mail.protection.outlook.com (10.167.18.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7897.11 via Frontend Transport; Fri, 23 Aug 2024 13:28:29 +0000
Received: from aiemdee.2.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 23 Aug
 2024 08:28:23 -0500
From: Alexey Kardashevskiy <aik@amd.com>
To: <kvm@vger.kernel.org>
CC: <iommu@lists.linux.dev>, <linux-coco@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, Dan Williams <dan.j.williams@intel.com>,
	<pratikrajesh.sampat@amd.com>, <michael.day@amd.com>, <david.kaplan@amd.com>,
	<dhaval.giani@amd.com>, Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>, Alexey Kardashevskiy
	<aik@amd.com>
Subject: [RFC PATCH 04/21] PCI/IDE: Define Integrity and Data Encryption (IDE) extended capability
Date: Fri, 23 Aug 2024 23:21:18 +1000
Message-ID: <20240823132137.336874-5-aik@amd.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240823132137.336874-1-aik@amd.com>
References: <20240823132137.336874-1-aik@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343A:EE_|SA3PR12MB9158:EE_
X-MS-Office365-Filtering-Correlation-Id: b084fa8d-c49d-4f77-6839-08dcc3777a0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nC9Ej5toNdaXLeAFTMbTTsOQiHEL3Iux0zP1We6/5hucULsAEK/YYIVh2wBv?=
 =?us-ascii?Q?oLSd/HGzAUEax28MV0M7z8CqwoJTj4n3FB8GzLShUd0rz80ZUFcZxcdTisVe?=
 =?us-ascii?Q?K33jLVyGTm9apVstDLWeImqQxS/T8b0kUjXVf8L7eRX6bFMkkjo+sVecR1S3?=
 =?us-ascii?Q?ulf4+iBljg9GFmza8t1WK1w6al3gVcP07MFtIMgo3sO/SnU3n4d95SMhx+vG?=
 =?us-ascii?Q?1a5bMzOilOjaBN816XFy/4uq4AoyfDw+/zSVrulBewrjWyzCtkJHPXv2KkZJ?=
 =?us-ascii?Q?zYfOiDzaDLl86vuypR/O68aEKHIRfZHOmHwLhExjJQNaJJve3cbvMYDFOlvq?=
 =?us-ascii?Q?1haj7igBmRsoI/Re3jzvOxHDU4aJpLKC6WRhIK+aG8OqIpNM3rQb+vdH+P4p?=
 =?us-ascii?Q?5eaGmUEillRZ8kF3MqIzGATlLhL6G6XGk8P0P51uXyq/tjuBMr4shpWC6LQX?=
 =?us-ascii?Q?Qc0S4c14DLJAVsDsctzxP7SPaOIDvH3IbE+VLX97icS153GbBki0kl75yr6L?=
 =?us-ascii?Q?RkNhYO2y8SNIUrb9VlCrFkMpHLwcVOyk4BWOeaOpsF4lSdYQkmy8nUXPKjZ2?=
 =?us-ascii?Q?CqIDTDhPze8FnZiBIlGDO3UVIKrC3WOqo7d/ZT1CJo6K/8W3715ZVCVWKsE5?=
 =?us-ascii?Q?ZlI7Q/PJ6jyAo9Ml+EhPvQmWdCAHuoP1b7VNRFO/8yo9d4846Te0IpBwi8AG?=
 =?us-ascii?Q?IJyivby0AXpzHsjlsJQnIhp2zKVLTFC1Vggq9WHnuTvPEwC20zwp3Wluf/iF?=
 =?us-ascii?Q?s00qSx+hKyyegZrebyyU0tiD+FpHNAFEhBuUs7hCz/RoMTlcPZvEnpccmAAg?=
 =?us-ascii?Q?36sxnJ3+uwCawFSOpHgaR5T55O2bZhgUPcPFs5ZIhb5/LTJxQc++6gihnfTW?=
 =?us-ascii?Q?YmP0LwxV73RJzosvFrGeWm92/gTALxnJyaexHdc9W+/txMgy8K7HGARvDqEv?=
 =?us-ascii?Q?4P53cKbKl7Akoe4TBTm0oyDdVQRpAekA29ql2D2edgWaGIvDcE5xbAIyupKR?=
 =?us-ascii?Q?bChyuqueSjCNWL85z5JQRiwJ1oVNYyivR0elkBHq7d9H0FNzPWh9y5942RNR?=
 =?us-ascii?Q?H9cEN24KdNL33TwZOztK7dBj3l9jNc0//Sc/fLQe5VkyOKy0zpnhgERGVpk+?=
 =?us-ascii?Q?pZEfCAB+rdSBbQJvmolgnlFWaZ35plRcGDueW4D18sPhhXO2QBo9chJxmqV6?=
 =?us-ascii?Q?d2HP4Prizh4n5vp6b5ToQRQphWPZB4RapVBBWkWltHgQGtypaLEwUhIvidV/?=
 =?us-ascii?Q?iKmfV/hYZjBZ0MKC8xPl3PClfWi5A/Kb8VQBcmsfi5H2qTH6i16FnQ9+hRhX?=
 =?us-ascii?Q?3oReyPpBOJnRHYKb6XixmP9RQRKVVWv6gxzWKZMsy7Q7CU1yYWn6pkT9tsvn?=
 =?us-ascii?Q?wZOOkRccS2xEr6Yjf7/OD4A6oMtnSVVp67FTTVyGoflUtNpwPMEK0rJlApf5?=
 =?us-ascii?Q?TonS4f6p2cB8T5ufuf1ryUOg8vhr6UzC?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2024 13:28:29.4832
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b084fa8d-c49d-4f77-6839-08dcc3777a0c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9158

PCIe 6.0 introduces the "Integrity & Data Encryption (IDE)" feature which
adds a new capability with id=0x30.

Add the new id to the list of capabilities. Add new flags from pciutils.
Add a module with a helper to control selective IDE capability.

TODO: get rid of lots of magic numbers. It is one annoying flexible
capability to deal with.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 drivers/pci/Makefile          |   1 +
 include/linux/pci-ide.h       |  18 ++
 include/uapi/linux/pci_regs.h |  76 +++++++-
 drivers/pci/ide.c             | 186 ++++++++++++++++++++
 drivers/pci/Kconfig           |   4 +
 5 files changed, 284 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index 1452e4ba7f00..034f17f9297a 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -34,6 +34,7 @@ obj-$(CONFIG_PCI_P2PDMA)	+= p2pdma.o
 obj-$(CONFIG_XEN_PCIDEV_FRONTEND) += xen-pcifront.o
 obj-$(CONFIG_VGA_ARB)		+= vgaarb.o
 obj-$(CONFIG_PCI_DOE)		+= doe.o
+obj-$(CONFIG_PCI_IDE)		+= ide.o
 obj-$(CONFIG_PCI_DYNAMIC_OF_NODES) += of_property.o
 
 obj-$(CONFIG_PCI_CMA)		+= cma.o cma.asn1.o
diff --git a/include/linux/pci-ide.h b/include/linux/pci-ide.h
new file mode 100644
index 000000000000..983a8daf1199
--- /dev/null
+++ b/include/linux/pci-ide.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Integrity & Data Encryption (IDE)
+ *	PCIe r6.0, sec 6.33 DOE
+ */
+
+#ifndef LINUX_PCI_IDE_H
+#define LINUX_PCI_IDE_H
+
+int pci_ide_set_sel(struct pci_dev *pdev, unsigned int sel_index, unsigned int streamid,
+		    bool enable, bool def, bool tee_limited, bool ide_cfg);
+int pci_ide_set_sel_rid_assoc(struct pci_dev *pdev, unsigned int sel_index,
+			      bool valid, u8 seg_base, u16 rid_base, u16 rid_limit);
+int pci_ide_set_sel_addr_assoc(struct pci_dev *pdev, unsigned int sel_index, unsigned int blocknum,
+			       bool valid, u64 base, u64 limit);
+int pci_ide_get_sel_sta(struct pci_dev *pdev, unsigned int sel_index, u32 *status);
+
+#endif
diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
index 0011a301b8c5..80962b07719a 100644
--- a/include/uapi/linux/pci_regs.h
+++ b/include/uapi/linux/pci_regs.h
@@ -743,7 +743,8 @@
 #define PCI_EXT_CAP_ID_PL_16GT	0x26	/* Physical Layer 16.0 GT/s */
 #define PCI_EXT_CAP_ID_PL_32GT  0x2A    /* Physical Layer 32.0 GT/s */
 #define PCI_EXT_CAP_ID_DOE	0x2E	/* Data Object Exchange */
-#define PCI_EXT_CAP_ID_MAX	PCI_EXT_CAP_ID_DOE
+#define PCI_EXT_CAP_ID_IDE	0x30	/* Integrity and Data Encryption (IDE) */
+#define PCI_EXT_CAP_ID_MAX	PCI_EXT_CAP_ID_IDE
 
 #define PCI_EXT_CAP_DSN_SIZEOF	12
 #define PCI_EXT_CAP_MCAST_ENDPOINT_SIZEOF 40
@@ -1150,9 +1151,82 @@
 #define PCI_DOE_DATA_OBJECT_DISC_RSP_3_PROTOCOL		0x00ff0000
 #define PCI_DOE_DATA_OBJECT_DISC_RSP_3_NEXT_INDEX	0xff000000
 
+
 /* Compute Express Link (CXL r3.1, sec 8.1.5) */
 #define PCI_DVSEC_CXL_PORT				3
 #define PCI_DVSEC_CXL_PORT_CTL				0x0c
 #define PCI_DVSEC_CXL_PORT_CTL_UNMASK_SBR		0x00000001
 
+/* Integrity and Data Encryption Extended Capability */
+#define PCI_IDE_CAP		0x4
+#define  PCI_IDE_CAP_LINK_IDE_SUPP	0x1	/* Link IDE Stream Supported */
+#define  PCI_IDE_CAP_SELECTIVE_IDE_SUPP 0x2	/* Selective IDE Streams Supported */
+#define  PCI_IDE_CAP_FLOWTHROUGH_IDE_SUPP 0x4	/* Flow-Through IDE Stream Supported */
+#define  PCI_IDE_CAP_PARTIAL_HEADER_ENC_SUPP 0x8 /* Partial Header Encryption Supported */
+#define  PCI_IDE_CAP_AGGREGATION_SUPP	0x10	/* Aggregation Supported */
+#define  PCI_IDE_CAP_PCRC_SUPP		0x20	/* PCRC Supported */
+#define  PCI_IDE_CAP_IDE_KM_SUPP	0x40	/* IDE_KM Protocol Supported */
+#define  PCI_IDE_CAP_ALG(x)	(((x) >> 8) & 0x1f) /* Supported Algorithms */
+#define  PCI_IDE_CAP_ALG_AES_GCM_256	0	/* AES-GCM 256 key size, 96b MAC */
+#define  PCI_IDE_CAP_LINK_TC_NUM(x)		(((x) >> 13) & 0x7) /* Link IDE TCs */
+#define  PCI_IDE_CAP_SELECTIVE_STREAMS_NUM(x)	(((x) >> 16) & 0xff) /* Selective IDE Streams */
+#define  PCI_IDE_CAP_TEE_LIMITED_SUPP   0x1000000 /* TEE-Limited Stream Supported */
+#define PCI_IDE_CTL		0x8
+#define  PCI_IDE_CTL_FLOWTHROUGH_IDE	0x4	/* Flow-Through IDE Stream Enabled */
+#define PCI_IDE_LINK_STREAM		0xC
+/* Link IDE Stream block, up to PCI_IDE_CAP_LINK_TC_NUM */
+/* Link IDE Stream Control Register */
+#define  PCI_IDE_LINK_CTL_EN		0x1	/* Link IDE Stream Enable */
+#define  PCI_IDE_LINK_CTL_TX_AGGR_NPR(x)(((x) >> 2) & 0x3) /* Tx Aggregation Mode NPR */
+#define  PCI_IDE_LINK_CTL_TX_AGGR_PR(x)	(((x) >> 4) & 0x3) /* Tx Aggregation Mode PR */
+#define  PCI_IDE_LINK_CTL_TX_AGGR_CPL(x)(((x) >> 6) & 0x3) /* Tx Aggregation Mode CPL */
+#define  PCI_IDE_LINK_CTL_PCRC_EN	0x100	/* PCRC Enable */
+#define  PCI_IDE_LINK_CTL_PART_ENC(x)	(((x) >> 10) & 0xf)  /* Partial Header Encryption Mode */
+#define  PCI_IDE_LINK_CTL_ALG(x)	(((x) >> 14) & 0x1f) /* Selected Algorithm */
+#define  PCI_IDE_LINK_CTL_TC(x)		(((x) >> 19) & 0x7)  /* Traffic Class */
+#define  PCI_IDE_LINK_CTL_ID(x)		(((x) >> 24) & 0xff) /* Stream ID */
+#define  PCI_IDE_LINK_CTL_ID_MASK	0xff000000
+
+/* Link IDE Stream Status Register */
+#define  PCI_IDE_LINK_STS_STATUS(x)	((x) & 0xf) /* Link IDE Stream State */
+#define  PCI_IDE_LINK_STS_RECVD_INTEGRITY_CHECK	0x80000000 /* Received Integrity Check Fail Msg */
+/* Selective IDE Stream block, up to PCI_IDE_CAP_SELECTIVE_STREAMS_NUM */
+/* Selective IDE Stream Capability Register */
+#define  PCI_IDE_SEL_CAP_BLOCKS_NUM(x)	((x) & 0xf) /*Address Association Register Blocks Number */
+/* Selective IDE Stream Control Register */
+#define  PCI_IDE_SEL_CTL_EN		0x1	/* Selective IDE Stream Enable */
+#define  PCI_IDE_SEL_CTL_TX_AGGR_NPR(x)	(((x) >> 2) & 0x3) /* Tx Aggregation Mode NPR */
+#define  PCI_IDE_SEL_CTL_TX_AGGR_PR(x)	(((x) >> 4) & 0x3) /* Tx Aggregation Mode PR */
+#define  PCI_IDE_SEL_CTL_TX_AGGR_CPL(x)	(((x) >> 6) & 0x3) /* Tx Aggregation Mode CPL */
+#define  PCI_IDE_SEL_CTL_PCRC_EN	0x100	/* PCRC Enable */
+#define  PCI_IDE_SEL_CTL_CFG_EN		0x200	/* Selective IDE for Configuration Requests */
+#define  PCI_IDE_SEL_CTL_PART_ENC(x)	(((x) >> 10) & 0xf)  /* Partial Header Encryption Mode */
+#define  PCI_IDE_SEL_CTL_ALG(x)		(((x) >> 14) & 0x1f) /* Selected Algorithm */
+#define  PCI_IDE_SEL_CTL_TC(x)		(((x) >> 19) & 0x7)  /* Traffic Class */
+#define  PCI_IDE_SEL_CTL_DEFAULT	0x400000 /* Default Stream */
+#define  PCI_IDE_SEL_CTL_TEE_LIMITED	(1 << 23) /* TEE-Limited Stream */
+#define  PCI_IDE_SEL_CTL_ID(x)		(((x) >> 24) & 0xff) /* Stream ID */
+/* Selective IDE Stream Status Register */
+#define  PCI_IDE_SEL_STS_STATUS(x)	((x) & 0xf) /* Selective IDE Stream State */
+#define  PCI_IDE_SEL_STS_RECVD_INTEGRITY_CHECK	0x80000000 /* Received Integrity Check Fail Msg */
+/* IDE RID Association Register 1 */
+#define  PCI_IDE_SEL_RID_1_LIMIT(x)	(((x) >> 8) & 0xffff) /* RID Limit */
+#define  PCI_IDE_SEL_RID_1(rid_limit)	(((rid_limit) & 0xffff) << 8)
+/* IDE RID Association Register 2 */
+#define  PCI_IDE_SEL_RID_2_VALID	0x1	/* Valid */
+#define  PCI_IDE_SEL_RID_2_BASE(x)	(((x) >> 8) & 0xffff) /* RID Base */
+#define  PCI_IDE_SEL_RID_2_SEG_BASE(x)	(((x) >> 24) & 0xff) /* Segmeng Base */
+#define  PCI_IDE_SEL_RID_2(v, rid_base, seg_base) ((((seg_base) & 0xff) << 24) | \
+						   (((rid_base) & 0xffff) << 8) | ((v) ? 1 : 0))
+/* Selective IDE Address Association Register Block, up to PCI_IDE_SEL_CAP_BLOCKS_NUM */
+#define  PCI_IDE_SEL_ADDR_1_VALID	0x1	/* Valid */
+#define  PCI_IDE_SEL_ADDR_1_BASE_LOW(x)	(((x) >> 8) & 0xfff) /* Memory Base Lower */
+#define  PCI_IDE_SEL_ADDR_1_LIMIT_LOW(x)(((x) >> 20) & 0xfff) /* Memory Limit Lower */
+/* IDE Address Association Register 2 is "Memory Limit Upper" */
+/* IDE Address Association Register 3 is "Memory Base Upper" */
+#define  PCI_IDE_SEL_ADDR_1(v, base, limit) ((FIELD_GET(0xfff00000, (limit))  << 20) | \
+					     (FIELD_GET(0xfff00000, (base)) << 8) | ((v) ? 1 : 0))
+#define  PCI_IDE_SEL_ADDR_2(limit)	((limit) >> 32)
+#define  PCI_IDE_SEL_ADDR_3(base)	((base) >> 32)
+
 #endif /* LINUX_PCI_REGS_H */
diff --git a/drivers/pci/ide.c b/drivers/pci/ide.c
new file mode 100644
index 000000000000..dc0632e836e7
--- /dev/null
+++ b/drivers/pci/ide.c
@@ -0,0 +1,186 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Integrity & Data Encryption (IDE)
+ *	PCIe r6.0, sec 6.33 DOE
+ */
+
+#define dev_fmt(fmt) "IDE: " fmt
+
+#include <linux/pci.h>
+#include <linux/pci-ide.h>
+#include <linux/bitfield.h>
+#include <linux/module.h>
+
+#define DRIVER_VERSION	"0.1"
+#define DRIVER_AUTHOR	"aik@amd.com"
+#define DRIVER_DESC	"Integrity and Data Encryption driver"
+
+/* Returns an offset of the specific IDE stream block */
+static u16 sel_off(struct pci_dev *pdev, unsigned int sel_index)
+{
+	u16 offset = pci_find_next_ext_capability(pdev, 0, PCI_EXT_CAP_ID_IDE);
+	unsigned int linknum = 0, selnum = 0, i;
+	u16 seloff;
+	u32 cap = 0;
+
+	if (!offset)
+		return 0;
+
+	pci_read_config_dword(pdev, offset + PCI_IDE_CAP, &cap);
+	if (cap & PCI_IDE_CAP_SELECTIVE_IDE_SUPP)
+		selnum = PCI_IDE_CAP_SELECTIVE_STREAMS_NUM(cap) + 1;
+
+	if (!selnum || sel_index >= selnum)
+		return 0;
+
+	if (cap & PCI_IDE_CAP_LINK_IDE_SUPP)
+		linknum = PCI_IDE_CAP_LINK_TC_NUM(cap) + 1;
+
+	seloff = offset + PCI_IDE_LINK_STREAM + linknum * 2 * 4;
+	for (i = 0; i < sel_index; ++i) {
+		u32 selcap = 0;
+
+		pci_read_config_dword(pdev, seloff, &selcap);
+
+		/* Selective Cap+Ctrl+Sta + Addr#*8 */
+		seloff += 3 * 4 + PCI_IDE_SEL_CAP_BLOCKS_NUM(selcap) * 2 * 4;
+	}
+
+	return seloff;
+}
+
+static u16 sel_off_addr_block(struct pci_dev *pdev, u16 offset, unsigned int blocknum)
+{
+	unsigned int blocks;
+	u32 selcap = 0;
+
+	pci_read_config_dword(pdev, offset, &selcap);
+
+	blocks = PCI_IDE_SEL_CAP_BLOCKS_NUM(selcap);
+	if (!blocks)
+		return 0;
+
+	return offset + 3 * 4 + // Skip Cap, Ctl, Sta
+		2 * 4 + // RID Association Register 1 and 2
+		blocknum * 3 * 4; // Each block is Address Association Register 1, 2, 3
+}
+
+static int set_sel(struct pci_dev *pdev, unsigned int sel_index, u32 value)
+{
+	u16 offset = sel_off(pdev, sel_index);
+	u32 status = 0;
+
+	if (!offset)
+		return -EINVAL;
+
+	pci_read_config_dword(pdev, offset + 8, &status);
+	if (status & PCI_IDE_SEL_STS_RECVD_INTEGRITY_CHECK) {
+		pci_warn(pdev, "[%x] Clearing \"Received integrity check\"\n", offset + 4);
+		pci_write_config_dword(pdev, offset + 8,
+				       status & ~PCI_IDE_SEL_STS_RECVD_INTEGRITY_CHECK);
+	}
+
+	/* Selective IDE Stream Control Register */
+	pci_write_config_dword(pdev, offset + 4, value);
+	return 0;
+}
+
+int pci_ide_set_sel(struct pci_dev *pdev, unsigned int sel_index, unsigned int streamid,
+		    bool enable, bool def, bool tee_limited, bool ide_cfg)
+{
+	return set_sel(pdev, sel_index,
+		       FIELD_PREP(PCI_IDE_LINK_CTL_ID_MASK, streamid) |
+		       (def ? PCI_IDE_SEL_CTL_DEFAULT : 0) |
+		       (enable ? PCI_IDE_SEL_CTL_EN : 0) |
+		       (tee_limited ? PCI_IDE_SEL_CTL_TEE_LIMITED : 0) |
+		       (ide_cfg ? PCI_IDE_SEL_CTL_CFG_EN : 0)
+		      );
+}
+EXPORT_SYMBOL_GPL(pci_ide_set_sel);
+
+int pci_ide_set_sel_rid_assoc(struct pci_dev *pdev, unsigned int sel_index,
+			      bool valid, u8 seg_base, u16 rid_base, u16 rid_limit)
+{
+	u16 offset = sel_off(pdev, sel_index);
+	u32 rid1 = PCI_IDE_SEL_RID_1(rid_limit);
+	u32 rid2 = PCI_IDE_SEL_RID_2(valid, rid_base, seg_base);
+	u32 ctl = 0;
+
+	if (!offset)
+		return -EINVAL;
+
+	pci_read_config_dword(pdev, offset + 4, &ctl);
+	if (ctl & PCI_IDE_SEL_CTL_EN)
+		pci_warn(pdev, "Setting RID when En=off triggers Integrity Check Fail Message");
+
+	/* IDE RID Association Register 1 */
+	pci_write_config_dword(pdev, offset + 0xC, rid1);
+	/* IDE RID Association Register 2 */
+	pci_write_config_dword(pdev, offset + 0x10, rid2);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pci_ide_set_sel_rid_assoc);
+
+int pci_ide_set_sel_addr_assoc(struct pci_dev *pdev, unsigned int sel_index, unsigned int blocknum,
+			       bool valid, u64 base, u64 limit)
+{
+	u16 offset = sel_off(pdev, sel_index), offset_ab;
+	u32 a1 = PCI_IDE_SEL_ADDR_1(1, base, limit);
+	u32 a2 = PCI_IDE_SEL_ADDR_2(limit);
+	u32 a3 = PCI_IDE_SEL_ADDR_3(base);
+
+	if (!offset)
+		return -EINVAL;
+
+	offset_ab = sel_off_addr_block(pdev, offset, blocknum);
+	if (!offset_ab || offset_ab <= offset)
+		return -EINVAL;
+
+	/* IDE Address Association Register 1 */
+	pci_write_config_dword(pdev, offset_ab, a1);
+	/* IDE Address Association Register 2 */
+	pci_write_config_dword(pdev, offset_ab + 4, a2);
+	/* IDE Address Association Register 1 */
+	pci_write_config_dword(pdev, offset_ab + 8, a3);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pci_ide_set_sel_addr_assoc);
+
+int pci_ide_get_sel_sta(struct pci_dev *pdev, unsigned int sel_index, u32 *status)
+{
+	u16 offset = sel_off(pdev, sel_index);
+	u32 s = 0;
+	int ret;
+
+	if (!offset)
+		return -EINVAL;
+
+
+	ret = pci_read_config_dword(pdev, offset + 8, &s);
+	if (ret)
+		return ret;
+
+	*status = s;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pci_ide_get_sel_sta);
+
+static int __init ide_init(void)
+{
+	int ret = 0;
+
+	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
+	return ret;
+}
+
+static void __exit ide_cleanup(void)
+{
+}
+
+module_init(ide_init);
+module_exit(ide_cleanup);
+
+MODULE_VERSION(DRIVER_VERSION);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index b0b14468ba5d..8e908d684c77 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -137,6 +137,10 @@ config PCI_CMA
 config PCI_DOE
 	bool
 
+config PCI_IDE
+	tristate
+	default m
+
 config PCI_ECAM
 	bool
 
-- 
2.45.2


