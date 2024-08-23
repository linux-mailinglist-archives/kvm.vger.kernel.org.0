Return-Path: <kvm+bounces-24905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DE4A795CDD0
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 15:29:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E252CB251F4
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 13:29:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEB43186E42;
	Fri, 23 Aug 2024 13:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="aL0gAV6C"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2084.outbound.protection.outlook.com [40.107.243.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1551865EE;
	Fri, 23 Aug 2024 13:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724419775; cv=fail; b=Yg+32dTHRJFdl1gtsLnZHYMgx6HbuFGEBrtua/AXkyH1hbMlE6kJUsvjlKU7QaA0cT+SzGlNUElrqCyAprmcqzanl4Iq3ZH1Pu1b9hAX+eYtEg7J2KoZkJzctIPOlZqaBWyoQc5TUulity/bwZ7WEZuM+Ou3i3QoVTYjGfoQB6k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724419775; c=relaxed/simple;
	bh=P401G9wcb7stnaBnb1hE3fU43ReXY9/eq/VFQhN8n/A=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YWKVQeOUTs7Pco2OxoIV1S0Lsxt/sRxKK5NJ8vyurkojPdfMFSb4A2dElnPncg1hltxq4M7VZaW48FI1+KTRtoMqxmYhYUiyD8/5EMRKwGXpprjZMDrPySFbIceyj79a3FBQzPMA9m0aE3gIGyH1OHT0oCUQb91PadUFL7L2cEk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=aL0gAV6C; arc=fail smtp.client-ip=40.107.243.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YsgXjliLqAYSPSP5FNd38H8zH+J3qDRk2JivvCQYvACXtxgEJ2moKsUbuZ7R6B3+lbuqCbgLTBOPwH27+pBrdgWSlXL9j4bp02nGsuwI1GAo+YUAAyry5hebhO3WQiUepUpp2vW2YHkKrh4GeMmiwCaSOzc6+BNqKzSec7W/trDEsGdKvz7ijrx9vn7oQS/0XG1vLnXGJNmUOMcbAXjfeidUDdqmtwlfN8rfDMr8w1SGguv/+UmrBtVdRMbWBJqkCvc2drqFbTeO8nUoT/DAh6EWie4O1SE4sl4vGh5dI5Dp7+xk4LQyq1TxtqG2vf8IkXl+vMu2K7a+3zOV8Er85w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RUnn2Yl1uEUsaGe+LFNnRmy3soYEJEoqFXjNQS1tL8k=;
 b=eucAc2xFQvh4oiXg6oEPdOjYHoPPMKx4PIWLdqh2id0ykj61LSeslXbsqYof1+mh4jTyK8IHT6PSS5XUWTTBtokDifKY2ZP+iNsdTfhXF+yjp6LnaXX/l67lowX53MCBcAowKnhBun4gtRlaThWn3/SOEEW3L479bdXKnmLspSO8L7duiU3aS8rhJqul8AYvkkUzbQQT8luQoCJ8E+5f+A2DeVDhEn13Rb3JbIUKFFX/Qrt4PV1jSCRTwzX+vUfENDx59o63C7V3JdA16lYmyPipjQBM4w2j1LIprgNSt874lSWwepMWbWsw40rqDgMaFGcYLgnZUhUoAFKP5je23Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RUnn2Yl1uEUsaGe+LFNnRmy3soYEJEoqFXjNQS1tL8k=;
 b=aL0gAV6CQVs4KE8E4gnyRpsb/zeLFmvBJRYGvN062HWyKMoZYtNykfluwamAwitMSgoMJ/EvcYKr+OWkmERzH3aZtfwR0HvAv7+7vQznVECLVPwR6/s3ua90e73FlTU3hphbmOCbsMKv5ByWiix5yDbRR/y4sNV4ii0+0twNcGQ=
Received: from DS7PR06CA0019.namprd06.prod.outlook.com (2603:10b6:8:2a::18) by
 SA0PR12MB4446.namprd12.prod.outlook.com (2603:10b6:806:71::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7897.19; Fri, 23 Aug 2024 13:29:23 +0000
Received: from DS2PEPF00003440.namprd02.prod.outlook.com
 (2603:10b6:8:2a:cafe::d7) by DS7PR06CA0019.outlook.office365.com
 (2603:10b6:8:2a::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.25 via Frontend
 Transport; Fri, 23 Aug 2024 13:29:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF00003440.mail.protection.outlook.com (10.167.18.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7897.11 via Frontend Transport; Fri, 23 Aug 2024 13:29:23 +0000
Received: from aiemdee.2.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 23 Aug
 2024 08:29:17 -0500
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
Subject: [RFC PATCH 07/21] pci/tdisp: Introduce tsm module
Date: Fri, 23 Aug 2024 23:21:21 +1000
Message-ID: <20240823132137.336874-8-aik@amd.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240823132137.336874-1-aik@amd.com>
References: <20240823132137.336874-1-aik@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003440:EE_|SA0PR12MB4446:EE_
X-MS-Office365-Filtering-Correlation-Id: 76ee3513-94fd-400b-6d70-08dcc37799f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MVFRZy9wV1h0MStQS3NiQ0pMOW1sVmFYbTJvU0pjemhQTFZaaUp4bHJOZnQ3?=
 =?utf-8?B?Vi8wd2VqbUNrOFRWV0JZaTI0czh4aHpaQUd0amhwRnJ2YTk2M3hEbVluc0Vz?=
 =?utf-8?B?S3JuSXRia2FGcWhtaHdmbHAxb0ZsTVl6M0s1MUl3UjRGbjk3VTRLR0xUZm9h?=
 =?utf-8?B?VTZqclN6MHFReDE1QVc4SXpxNkJZMTFBbE9GWG1CRzY4ZTFHTFhTY0dVdERD?=
 =?utf-8?B?S0p3SzZ2dHlnN1ZFeW9ydnZaQ3NLOENGZ0JjMm9IdVVCM3RFRXRVdjFjcmNm?=
 =?utf-8?B?b3FWaWJGcGpKUEdlY0Via2MwZlZEOWl3Y1FGYVYxeTZ5Y05wdGRnMm1OS05U?=
 =?utf-8?B?ZUVsVFpJdSsvb2RQdTVmcHVqdEJaUUhsYWVvYUhNRW9yWmxJbVR2VzRaMlpD?=
 =?utf-8?B?SDd5ZWFIWFptNnRXTFBPZndBUEJQYmo0eEI2RlFBazdUWHFXQStDNXZBaStt?=
 =?utf-8?B?N05YQ2lVeUE4VmFpVjhzNFFqQ292Z3dFR3dUYU9TZmhIWFdtMklKVVRNbVg0?=
 =?utf-8?B?WER4Nm9ianIzbmM2ZWtIdVhDN1VNVXB5MmZrVUdkUlpNdlc4eDNkZmhadjc2?=
 =?utf-8?B?VnZETDhNbjVhRVdiM2lEdFBrMXErdXpXTWZtajJraVZFVnBmM1pjKy9BRTUv?=
 =?utf-8?B?UDJlYWZBY3BUS2Fodk1JUEJ0SGNrd1VDSWNicy9ncFJUdVBmQnBraVlPMWJa?=
 =?utf-8?B?Q0REUkJjT0JHNmNrMnV2aG04bGgzN2htM2o2S2YvanNoM0dIU3BTZ2tBUGdn?=
 =?utf-8?B?bGc3dVpwWFNNWHovN2RGcStJa0hzenNhUis3UFFTSkVNQ2ZiMklHY0FBL0tm?=
 =?utf-8?B?VzlvM0lqTFM4TFlzeUZ5WSt4bEsxbEhORkpjSUtiTEpwbWlkTU1URlBxQVB5?=
 =?utf-8?B?SXJxUldZaVorSzgzb1R2Wk4xSXcxeWhrRGE2ekxueGhUZEUvTkxucTBob2Fi?=
 =?utf-8?B?MDVsTmlmYlBIZXpaVWN0bVd4TmJDV0dDNDBjWHU5YXc5dmxuSmx2dFdESVo4?=
 =?utf-8?B?am8xeE5MRmNvZG1hQS8reEJVNDM1MnVaSnIyQnRyc21lUFJDTGVweVBSeSs0?=
 =?utf-8?B?d0lRelc3S0gxS1ZPWUUzeDNwMlhPZFlQbGJ3QlNackY1b3VVUkpRazk0WXg3?=
 =?utf-8?B?anliNWI1NnNRTWdCNlN5TTlxZlZyWE9qTXB5M3k4MmxpTDlSam4rTk9HcVIv?=
 =?utf-8?B?YzlVd2Jndzc5RXl6SGk5emZIZlI5cXJFaHAzU0VJbjZmUGhFdHRtc0FNSHZp?=
 =?utf-8?B?NS96MmRIWFZ0YStWVmVqbFQwcFVBSFNtcTY3ZG5EbVRWcDBRM1U0L1ZXMWsw?=
 =?utf-8?B?dGZZSGU2TWxWMjRpakt2NS8rd0RCQllwTWNSNkVZQnRBSGE0QWdRRFc3NGdW?=
 =?utf-8?B?aXRtQUFlNi8wS1ZtT2lIVVdHSU42MXNsT1UxT0FiRDlHbjFNM1dJR2dVbVdH?=
 =?utf-8?B?ajVsWVNxOTl5cE9jYTNMeGRPbXQwYkl3NXhtS2pnNHUvNFJkdk02d0dmdjlq?=
 =?utf-8?B?eXVpL0E5akFDNU1SU3JZWE14WnlFb2NQNzlxdG5OL3F0d2lONGduY3RRdk02?=
 =?utf-8?B?cm9CYjZmVTRERmxOaTlJc3ZDb2FOL251ZEFjcTk2S0ZXRG1TK2Z1NVMyOC9r?=
 =?utf-8?B?bzJDdlFRdUsrM3l3T29BTHJWem5Wc0Q4UWMyNGZjd1ZqMlQ5KzQwcjY5cTZs?=
 =?utf-8?B?ZDNIWFBBTEtQVEFxbkgvV09EVWJiRkRlQVM5QjhLZlVlZGJUbUlOb0g5dUYv?=
 =?utf-8?B?cWtTVDdGUjdLb3JKUzI4UnpoQnJMQU9kdFpnNy8rS2VkRmtsVFU1TmdoOHdL?=
 =?utf-8?B?bkQ3c1JYZHhHbWRGTkdncmdKYm13NWU4YmFJSUN1WmVxMkVVLzlqbUl4bmN2?=
 =?utf-8?B?My93WFNJdXNMTllXYVhVTVh1Mk43eHZzOFNKVDdLUHQ3cUE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2024 13:29:23.0459
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 76ee3513-94fd-400b-6d70-08dcc37799f9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003440.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4446

The module responsibilities are:
1. detect TEE support in a device and create nodes in the device's sysfs
entry;
2. allow binding a PCI device to a VM for passing it through in a trusted
manner;
3. store measurements/certificates/reports and provide access to those for
the userspace via sysfs.

This relies on the platform to register a set of callbacks,
for both host and guest.

And tdi_enabled in the device struct.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 drivers/virt/coco/Makefile      |    1 +
 include/linux/device.h          |    5 +
 include/linux/tsm.h             |  263 ++++
 drivers/virt/coco/tsm.c         | 1336 ++++++++++++++++++++
 Documentation/virt/coco/tsm.rst |   62 +
 drivers/virt/coco/Kconfig       |   11 +
 6 files changed, 1678 insertions(+)

diff --git a/drivers/virt/coco/Makefile b/drivers/virt/coco/Makefile
index 75defec514f8..5d1aefb62714 100644
--- a/drivers/virt/coco/Makefile
+++ b/drivers/virt/coco/Makefile
@@ -3,6 +3,7 @@
 # Confidential computing related collateral
 #
 obj-$(CONFIG_TSM_REPORTS)	+= tsm-report.o
+obj-$(CONFIG_TSM)		+= tsm.o
 obj-$(CONFIG_EFI_SECRET)	+= efi_secret/
 obj-$(CONFIG_SEV_GUEST)		+= sev-guest/
 obj-$(CONFIG_INTEL_TDX_GUEST)	+= tdx-guest/
diff --git a/include/linux/device.h b/include/linux/device.h
index 34eb20f5966f..bb58ed1fb8da 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -45,6 +45,7 @@ struct fwnode_handle;
 struct iommu_group;
 struct dev_pin_info;
 struct dev_iommu;
+struct tsm_tdi;
 struct msi_device_data;
 
 /**
@@ -801,6 +802,7 @@ struct device {
 	void	(*release)(struct device *dev);
 	struct iommu_group	*iommu_group;
 	struct dev_iommu	*iommu;
+	struct tsm_tdi		*tdi;
 
 	struct device_physical_location *physical_location;
 
@@ -822,6 +824,9 @@ struct device {
 #ifdef CONFIG_DMA_NEED_SYNC
 	bool			dma_skip_sync:1;
 #endif
+#if defined(CONFIG_TSM) || defined(CONFIG_TSM_MODULE)
+	bool			tdi_enabled:1;
+#endif
 };
 
 /**
diff --git a/include/linux/tsm.h b/include/linux/tsm.h
new file mode 100644
index 000000000000..d48eceaf5bc0
--- /dev/null
+++ b/include/linux/tsm.h
@@ -0,0 +1,263 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef LINUX_TSM_H
+#define LINUX_TSM_H
+
+#include <linux/cdev.h>
+
+/* SPDM control structure for DOE */
+struct tsm_spdm {
+	unsigned long req_len;
+	void *req;
+	unsigned long rsp_len;
+	void *rsp;
+
+	struct pci_doe_mb *doe_mb;
+	struct pci_doe_mb *doe_mb_secured;
+};
+
+/* Data object for measurements/certificates/attestationreport */
+struct tsm_blob {
+	void *data;
+	size_t len;
+	struct kref kref;
+	void (*release)(struct tsm_blob *b);
+};
+
+struct tsm_blob *tsm_blob_new(void *data, size_t len, void (*release)(struct tsm_blob *b));
+struct tsm_blob *tsm_blob_get(struct tsm_blob *b);
+void tsm_blob_put(struct tsm_blob *b);
+
+/**
+ * struct tdisp_interface_id - TDISP INTERFACE_ID Definition
+ *
+ * @function_id: Identifies the function of the device hosting the TDI
+ * 15:0: @rid: Requester ID
+ * 23:16: @rseg: Requester Segment (Reserved if Requester Segment Valid is Clear)
+ * 24: @rseg_valid: Requester Segment Valid
+ * 31:25 – Reserved
+ * 8B - Reserved
+ */
+struct tdisp_interface_id {
+	union {
+		struct {
+			u32 function_id;
+			u8 reserved[8];
+		};
+		struct {
+			u16 rid;
+			u8 rseg;
+			u8 rseg_valid:1;
+		};
+	};
+} __packed;
+
+/*
+ * Measurement block as defined in SPDM DSP0274.
+ */
+struct spdm_measurement_block_header {
+	u8 index;
+	u8 spec; /* MeasurementSpecification */
+	u16 size;
+} __packed;
+
+struct dmtf_measurement_block_header {
+	u8 type;  /* DMTFSpecMeasurementValueType */
+	u16 size; /* DMTFSpecMeasurementValueSize */
+} __packed;
+
+struct dmtf_measurement_block_device_mode {
+	u32 opmode_cap;	 /* OperationalModeCapabilties */
+	u32 opmode_sta;  /* OperationalModeState */
+	u32 devmode_cap; /* DeviceModeCapabilties */
+	u32 devmode_sta; /* DeviceModeState */
+} __packed;
+
+struct spdm_certchain_block_header {
+	u16 length;
+	u16 reserved;
+} __packed;
+
+/*
+ * TDI Report Structure as defined in TDISP.
+ */
+struct tdi_report_header {
+	union {
+		u16 interface_info;
+		struct {
+			u16 no_fw_update:1; /* fw updates not permitted in CONFIG_LOCKED or RUN */
+			u16 dma_no_pasid:1; /* TDI generates DMA requests without PASID */
+			u16 dma_pasid:1; /* TDI generates DMA requests with PASID */
+			u16 ats:1; /*  ATS supported and enabled for the TDI */
+			u16 prs:1; /*  PRS supported and enabled for the TDI */
+			u16 reserved1:11;
+		};
+	};
+	u16 reserved2;
+	u16 msi_x_message_control;
+	u16 lnr_control;
+	u32 tph_control;
+	u32 mmio_range_count;
+} __packed;
+
+/*
+ * Each MMIO Range of the TDI is reported with the MMIO reporting offset added.
+ * Base and size in units of 4K pages
+ */
+struct tdi_report_mmio_range {
+	u64 first_page; /* First 4K page with offset added */
+	u32 num; 	/* Number of 4K pages in this range */
+	union {
+		u32 range_attributes;
+		struct {
+			u32 msix_table:1;
+			u32 msix_pba:1;
+			u32 is_non_tee_mem:1;
+			u32 is_mem_attr_updatable:1;
+			u32 reserved:12;
+			u32 range_id:16;
+		};
+	};
+} __packed;
+
+struct tdi_report_footer {
+	u32 device_specific_info_len;
+	u8 device_specific_info[];
+} __packed;
+
+#define TDI_REPORT_HDR(rep)		((struct tdi_report_header *) ((rep)->data))
+#define TDI_REPORT_MR_NUM(rep)		(TDI_REPORT_HDR(rep)->mmio_range_count)
+#define TDI_REPORT_MR_OFF(rep)		((struct tdi_report_mmio_range *) (TDI_REPORT_HDR(rep) + 1))
+#define TDI_REPORT_MR(rep, rangeid)	TDI_REPORT_MR_OFF(rep)[rangeid]
+#define TDI_REPORT_FTR(rep)		((struct tdi_report_footer *) &TDI_REPORT_MR((rep), \
+					TDI_REPORT_MR_NUM(rep)))
+
+/* Physical device descriptor responsible for IDE/TDISP setup */
+struct tsm_dev {
+	struct kref kref;
+	const struct attribute_group *ag;
+	struct pci_dev *pdev; /* Physical PCI function #0 */
+	struct tsm_spdm spdm;
+	struct mutex spdm_mutex;
+
+	u8 tc_mask;
+	u8 cert_slot;
+	u8 connected;
+	struct {
+		u8 enabled:1;
+		u8 enable:1;
+		u8 def:1;
+		u8 dev_ide_cfg:1;
+		u8 dev_tee_limited:1;
+		u8 rootport_ide_cfg:1;
+		u8 rootport_tee_limited:1;
+		u8 id;
+	} selective_ide[256];
+	bool ide_pre;
+
+	struct tsm_blob *meas;
+	struct tsm_blob *certs;
+
+	void *data; /* Platform specific data */
+};
+
+/* PCI function for passing through, can be the same as tsm_dev::pdev */
+struct tsm_tdi {
+	const struct attribute_group *ag;
+	struct pci_dev *pdev;
+	struct tsm_dev *tdev;
+
+	u8 rseg;
+	u8 rseg_valid;
+	bool validated;
+
+	struct tsm_blob *report;
+
+	void *data; /* Platform specific data */
+
+	u64 vmid;
+	u32 asid;
+	u16 guest_rid; /* BDFn of PCI Fn in the VM */
+};
+
+struct tsm_dev_status {
+	u8 ctx_state;
+	u8 tc_mask;
+	u8 certs_slot;
+	u16 device_id;
+	u16 segment_id;
+	u8 no_fw_update;
+	u16 ide_stream_id[8];
+};
+
+enum tsm_spdm_algos {
+	TSM_TDI_SPDM_ALGOS_DHE_SECP256R1,
+	TSM_TDI_SPDM_ALGOS_DHE_SECP384R1,
+	TSM_TDI_SPDM_ALGOS_AEAD_AES_128_GCM,
+	TSM_TDI_SPDM_ALGOS_AEAD_AES_256_GCM,
+	TSM_TDI_SPDM_ALGOS_ASYM_TPM_ALG_RSASSA_3072,
+	TSM_TDI_SPDM_ALGOS_ASYM_TPM_ALG_ECDSA_ECC_NIST_P256,
+	TSM_TDI_SPDM_ALGOS_ASYM_TPM_ALG_ECDSA_ECC_NIST_P384,
+	TSM_TDI_SPDM_ALGOS_HASH_TPM_ALG_SHA_256,
+	TSM_TDI_SPDM_ALGOS_HASH_TPM_ALG_SHA_384,
+	TSM_TDI_SPDM_ALGOS_KEY_SCHED_SPDM_KEY_SCHEDULE,
+};
+
+enum tsm_tdisp_state {
+	TDISP_STATE_UNAVAIL,
+	TDISP_STATE_CONFIG_UNLOCKED,
+	TDISP_STATE_CONFIG_LOCKED,
+	TDISP_STATE_RUN,
+	TDISP_STATE_ERROR,
+};
+
+struct tsm_tdi_status {
+	bool valid;
+	u8 meas_digest_fresh:1;
+	u8 meas_digest_valid:1;
+	u8 all_request_redirect:1;
+	u8 bind_p2p:1;
+	u8 lock_msix:1;
+	u8 no_fw_update:1;
+	u16 cache_line_size;
+	u64 spdm_algos; /* Bitmask of tsm_spdm_algos */
+	u8 certs_digest[48];
+	u8 meas_digest[48];
+	u8 interface_report_digest[48];
+
+	/* HV only */
+	struct tdisp_interface_id id;
+	u8 guest_report_id[16];
+	enum tsm_tdisp_state state;
+};
+
+struct tsm_ops {
+	/* HV hooks */
+	int (*dev_connect)(struct tsm_dev *tdev, void *private_data);
+	int (*dev_reclaim)(struct tsm_dev *tdev, void *private_data);
+	int (*dev_status)(struct tsm_dev *tdev, void *private_data, struct tsm_dev_status *s);
+	int (*ide_refresh)(struct tsm_dev *tdev, void *private_data);
+	int (*tdi_bind)(struct tsm_tdi *tdi, u32 bdfn, u64 vmid, u32 asid, void *private_data);
+	int (*tdi_reclaim)(struct tsm_tdi *tdi, void *private_data);
+
+	int (*guest_request)(struct tsm_tdi *tdi, u32 guest_rid, u64 vmid, void *req_data,
+			     enum tsm_tdisp_state *state, void *private_data);
+
+	/* VM hooks */
+	int (*tdi_validate)(struct tsm_tdi *tdi, bool invalidate, void *private_data);
+
+	/* HV and VM hooks */
+	int (*tdi_status)(struct tsm_tdi *tdi, void *private_data, struct tsm_tdi_status *ts);
+};
+
+void tsm_set_ops(struct tsm_ops *ops, void *private_data);
+struct tsm_tdi *tsm_tdi_get(struct device *dev);
+int tsm_tdi_bind(struct tsm_tdi *tdi, u32 guest_rid, u64 vmid, u32 asid);
+void tsm_tdi_unbind(struct tsm_tdi *tdi);
+int tsm_guest_request(struct tsm_tdi *tdi, enum tsm_tdisp_state *state, void *req_data);
+struct tsm_tdi *tsm_tdi_find(u32 guest_rid, u64 vmid);
+
+int pci_dev_tdi_validate(struct pci_dev *pdev);
+ssize_t tsm_report_gen(struct tsm_blob *report, char *b, size_t len);
+
+#endif /* LINUX_TSM_H */
diff --git a/drivers/virt/coco/tsm.c b/drivers/virt/coco/tsm.c
new file mode 100644
index 000000000000..e90455a0267f
--- /dev/null
+++ b/drivers/virt/coco/tsm.c
@@ -0,0 +1,1336 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/pci-doe.h>
+#include <linux/pci-ide.h>
+#include <linux/file.h>
+#include <linux/fdtable.h>
+#include <linux/tsm.h>
+#include <linux/kvm_host.h>
+
+#define DRIVER_VERSION	"0.1"
+#define DRIVER_AUTHOR	"aik@amd.com"
+#define DRIVER_DESC	"TSM TDISP driver"
+
+static struct {
+	struct tsm_ops *ops;
+	void *private_data;
+
+	uint tc_mask;
+	uint cert_slot;
+	bool physfn;
+} tsm;
+
+module_param_named(tc_mask, tsm.tc_mask, uint, 0644);
+MODULE_PARM_DESC(tc_mask, "Mask of traffic classes enabled in the device");
+
+module_param_named(cert_slot, tsm.cert_slot, uint, 0644);
+MODULE_PARM_DESC(cert_slot, "Slot number of the certificate requested for constructing the SPDM session");
+
+module_param_named(physfn, tsm.physfn, bool, 0644);
+MODULE_PARM_DESC(physfn, "Allow TDI on SR IOV of a physical function");
+
+struct tsm_blob *tsm_blob_new(void *data, size_t len, void (*release)(struct tsm_blob *b))
+{
+	struct tsm_blob *b;
+
+	if (!len || !data)
+		return NULL;
+
+	b = kzalloc(sizeof(*b) + len, GFP_KERNEL);
+	if (!b)
+		return NULL;
+
+	b->data = (void *)b + sizeof(*b);
+	b->len = len;
+	b->release = release;
+	memcpy(b->data, data, len);
+	kref_init(&b->kref);
+
+	return b;
+}
+EXPORT_SYMBOL_GPL(tsm_blob_new);
+
+static void tsm_blob_release(struct kref *kref)
+{
+	struct tsm_blob *b = container_of(kref, struct tsm_blob, kref);
+
+	b->release(b);
+	kfree(b);
+}
+
+struct tsm_blob *tsm_blob_get(struct tsm_blob *b)
+{
+	if (!b)
+		return NULL;
+
+	if (!kref_get_unless_zero(&b->kref))
+		return NULL;
+
+	return b;
+}
+EXPORT_SYMBOL_GPL(tsm_blob_get);
+
+void tsm_blob_put(struct tsm_blob *b)
+{
+	if (!b)
+		return;
+
+	kref_put(&b->kref, tsm_blob_release);
+}
+EXPORT_SYMBOL_GPL(tsm_blob_put);
+
+static struct tsm_dev *tsm_dev_get(struct device *dev)
+{
+	struct tsm_tdi *tdi = dev->tdi;
+
+	if (!tdi || !tdi->tdev || !kref_get_unless_zero(&tdi->tdev->kref))
+		return NULL;
+
+	return tdi->tdev;
+}
+
+static void tsm_dev_free(struct kref *kref);
+static void tsm_dev_put(struct tsm_dev *tdev)
+{
+	kref_put(&tdev->kref, tsm_dev_free);
+}
+
+struct tsm_tdi *tsm_tdi_get(struct device *dev)
+{
+	struct tsm_tdi *tdi = dev->tdi;
+
+	return tdi;
+}
+EXPORT_SYMBOL_GPL(tsm_tdi_get);
+
+static int spdm_forward(struct tsm_spdm *spdm, u8 type)
+{
+	struct pci_doe_mb *doe_mb;
+	int rc;
+
+	if (type == PCI_DOE_PROTOCOL_SECURED_CMA_SPDM)
+		doe_mb = spdm->doe_mb_secured;
+	else if (type == PCI_DOE_PROTOCOL_CMA_SPDM)
+		doe_mb = spdm->doe_mb;
+	else
+		return -EINVAL;
+
+	if (!doe_mb)
+		return -EFAULT;
+
+	rc = pci_doe(doe_mb, PCI_VENDOR_ID_PCI_SIG, type,
+		     spdm->req, spdm->req_len, spdm->rsp, spdm->rsp_len);
+	if (rc >= 0)
+		spdm->rsp_len = rc;
+
+	return rc;
+}
+
+/*
+ * Enables IDE between the RC and the device.
+ * TEE Limited, IDE Cfg space and other bits are hardcoded
+ * as this is a sketch.
+ */
+static int tsm_set_sel_ide(struct tsm_dev *tdev)
+{
+	struct pci_dev *rootport;
+	bool printed = false;
+	unsigned int i;
+	int ret = 0;
+
+	rootport = tdev->pdev->bus->self;
+	for (i = 0; i < ARRAY_SIZE(tdev->selective_ide); ++i) {
+		if (!tdev->selective_ide[i].enable)
+			continue;
+
+		if (!printed) {
+			pci_info(rootport, "Configuring IDE with %s\n",
+				 pci_name(tdev->pdev));
+			printed = true;
+		}
+		WARN_ON_ONCE(tdev->selective_ide[i].enabled);
+
+		ret = pci_ide_set_sel_rid_assoc(tdev->pdev, i, true, 0, 0, 0xFFFF);
+		if (ret)
+			pci_warn(tdev->pdev,
+				 "Failed configuring SelectiveIDE#%d rid1 with %d\n",
+				 i, ret);
+		ret = pci_ide_set_sel_addr_assoc(tdev->pdev, i, 0/* RID# */, true,
+						 0, 0xFFFFFFFFFFF00000ULL);
+		if (ret)
+			pci_warn(tdev->pdev,
+				 "Failed configuring SelectiveIDE#%d RID#0 with %d\n",
+				 i, ret);
+
+		ret = pci_ide_set_sel(tdev->pdev, i,
+				      tdev->selective_ide[i].id,
+				      tdev->selective_ide[i].enable,
+				      tdev->selective_ide[i].def,
+				      tdev->selective_ide[i].dev_tee_limited,
+				      tdev->selective_ide[i].dev_ide_cfg);
+		if (ret) {
+			pci_warn(tdev->pdev,
+				 "Failed configuring SelectiveIDE#%d with %d\n",
+				 i, ret);
+			break;
+		}
+
+		ret = pci_ide_set_sel_rid_assoc(rootport, i, true, 0, 0, 0xFFFF);
+		if (ret)
+			pci_warn(rootport,
+				 "Failed configuring SelectiveIDE#%d rid1 with %d\n",
+				 i, ret);
+
+		ret = pci_ide_set_sel(rootport, i,
+				      tdev->selective_ide[i].id,
+				      tdev->selective_ide[i].enable,
+				      tdev->selective_ide[i].def,
+				      tdev->selective_ide[i].rootport_tee_limited,
+				      tdev->selective_ide[i].rootport_ide_cfg);
+		if (ret)
+			pci_warn(rootport,
+				 "Failed configuring SelectiveIDE#%d with %d\n",
+				 i, ret);
+
+		tdev->selective_ide[i].enabled = 1;
+	}
+
+	return ret;
+}
+
+static void tsm_unset_sel_ide(struct tsm_dev *tdev)
+{
+	struct pci_dev *rootport = tdev->pdev->bus->self;
+	bool printed = false;
+
+	for (unsigned int i = 0; i < ARRAY_SIZE(tdev->selective_ide); ++i) {
+		if (!tdev->selective_ide[i].enabled)
+			continue;
+
+		if (!printed) {
+			pci_info(rootport, "Deconfiguring IDE with %s\n", pci_name(tdev->pdev));
+			printed = true;
+		}
+
+		pci_ide_set_sel(rootport, i, 0, 0, 0, false, false);
+		pci_ide_set_sel(tdev->pdev, i, 0, 0, 0, false, false);
+		tdev->selective_ide[i].enabled = 0;
+	}
+}
+
+static int tsm_dev_connect(struct tsm_dev *tdev, void *private_data, unsigned int val)
+{
+	int ret;
+
+	if (WARN_ON(!tsm.ops->dev_connect))
+		return -EPERM;
+
+	tdev->ide_pre = val == 2;
+	if (tdev->ide_pre)
+		tsm_set_sel_ide(tdev);
+
+	mutex_lock(&tdev->spdm_mutex);
+	while (1) {
+		ret = tsm.ops->dev_connect(tdev, tsm.private_data);
+		if (ret <= 0)
+			break;
+
+		ret = spdm_forward(&tdev->spdm, ret);
+		if (ret < 0)
+			break;
+	}
+	mutex_unlock(&tdev->spdm_mutex);
+
+	if (!tdev->ide_pre)
+		ret = tsm_set_sel_ide(tdev);
+
+	tdev->connected = (ret == 0);
+
+	return ret;
+}
+
+static int tsm_dev_reclaim(struct tsm_dev *tdev, void *private_data)
+{
+	struct pci_dev *pdev = NULL;
+	int ret;
+
+	if (WARN_ON(!tsm.ops->dev_reclaim))
+		return -EPERM;
+
+	/* Do not disconnect with active TDIs */
+	for_each_pci_dev(pdev) {
+		struct tsm_tdi *tdi = tsm_tdi_get(&pdev->dev);
+
+		if (tdi && tdi->tdev == tdev && tdi->data)
+			return -EBUSY;
+	}
+
+	if (!tdev->ide_pre)
+		tsm_unset_sel_ide(tdev);
+
+	mutex_lock(&tdev->spdm_mutex);
+	while (1) {
+		ret = tsm.ops->dev_reclaim(tdev, private_data);
+		if (ret <= 0)
+			break;
+
+		ret = spdm_forward(&tdev->spdm, ret);
+		if (ret < 0)
+			break;
+	}
+	mutex_unlock(&tdev->spdm_mutex);
+
+	if (tdev->ide_pre)
+		tsm_unset_sel_ide(tdev);
+
+	if (!ret)
+		tdev->connected = false;
+
+	return ret;
+}
+
+static int tsm_dev_status(struct tsm_dev *tdev, void *private_data, struct tsm_dev_status *s)
+{
+	if (WARN_ON(!tsm.ops->dev_status))
+		return -EPERM;
+
+	return tsm.ops->dev_status(tdev, private_data, s);
+}
+
+static int tsm_ide_refresh(struct tsm_dev *tdev, void *private_data)
+{
+	int ret;
+
+	if (!tsm.ops->ide_refresh)
+		return -EPERM;
+
+	mutex_lock(&tdev->spdm_mutex);
+	while (1) {
+		ret = tsm.ops->ide_refresh(tdev, private_data);
+		if (ret <= 0)
+			break;
+
+		ret = spdm_forward(&tdev->spdm, ret);
+		if (ret < 0)
+			break;
+	}
+	mutex_unlock(&tdev->spdm_mutex);
+
+	return ret;
+}
+
+static void tsm_tdi_reclaim(struct tsm_tdi *tdi, void *private_data)
+{
+	int ret;
+
+	if (WARN_ON(!tsm.ops->tdi_reclaim))
+		return;
+
+	mutex_lock(&tdi->tdev->spdm_mutex);
+	while (1) {
+		ret = tsm.ops->tdi_reclaim(tdi, private_data);
+		if (ret <= 0)
+			break;
+
+		ret = spdm_forward(&tdi->tdev->spdm, ret);
+		if (ret < 0)
+			break;
+	}
+	mutex_unlock(&tdi->tdev->spdm_mutex);
+}
+
+static int tsm_tdi_validate(struct tsm_tdi *tdi, bool invalidate, void *private_data)
+{
+	int ret;
+
+	if (!tdi || !tsm.ops->tdi_validate)
+		return -EPERM;
+
+	ret = tsm.ops->tdi_validate(tdi, invalidate, private_data);
+	if (ret) {
+		pci_err(tdi->pdev, "Validation failed, ret=%d", ret);
+		tdi->pdev->dev.tdi_enabled = false;
+	}
+
+	return ret;
+}
+
+/* In case BUS_NOTIFY_PCI_BUS_MASTER is no good, a driver can call pci_dev_tdi_validate() */
+int pci_dev_tdi_validate(struct pci_dev *pdev)
+{
+	struct tsm_tdi *tdi = tsm_tdi_get(&pdev->dev);
+
+	return tsm_tdi_validate(tdi, false, tsm.private_data);
+}
+EXPORT_SYMBOL_GPL(pci_dev_tdi_validate);
+
+static int tsm_tdi_status(struct tsm_tdi *tdi, void *private_data, struct tsm_tdi_status *ts)
+{
+	struct tsm_tdi_status tstmp = { 0 };
+	int ret;
+
+	if (WARN_ON(!tsm.ops->tdi_status))
+		return -EPERM;
+
+	mutex_lock(&tdi->tdev->spdm_mutex);
+	while (1) {
+		ret = tsm.ops->tdi_status(tdi, private_data, &tstmp);
+		if (ret <= 0)
+			break;
+
+		ret = spdm_forward(&tdi->tdev->spdm, ret);
+		if (ret < 0)
+			break;
+	}
+	mutex_unlock(&tdi->tdev->spdm_mutex);
+
+	*ts = tstmp;
+
+	return ret;
+}
+
+static ssize_t tsm_cert_slot_store(struct device *dev, struct device_attribute *attr,
+				   const char *buf, size_t count)
+{
+	struct tsm_dev *tdev = tsm_dev_get(dev);
+	ssize_t ret = count;
+	unsigned long val;
+
+	if (kstrtoul(buf, 0, &val) < 0)
+		ret = -EINVAL;
+	else
+		tdev->cert_slot = val;
+
+	tsm_dev_put(tdev);
+
+	return ret;
+}
+
+static ssize_t tsm_cert_slot_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct tsm_dev *tdev = tsm_dev_get(dev);
+	ssize_t ret = sysfs_emit(buf, "%u\n", tdev->cert_slot);
+
+	tsm_dev_put(tdev);
+	return ret;
+}
+
+static DEVICE_ATTR_RW(tsm_cert_slot);
+
+static ssize_t tsm_tc_mask_store(struct device *dev, struct device_attribute *attr,
+				 const char *buf, size_t count)
+{
+	struct tsm_dev *tdev = tsm_dev_get(dev);
+	ssize_t ret = count;
+	unsigned long val;
+
+	if (kstrtoul(buf, 0, &val) < 0)
+		ret = -EINVAL;
+	else
+		tdev->tc_mask = val;
+	tsm_dev_put(tdev);
+
+	return ret;
+}
+
+static ssize_t tsm_tc_mask_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct tsm_dev *tdev = tsm_dev_get(dev);
+	ssize_t ret = sysfs_emit(buf, "%#x\n", tdev->tc_mask);
+
+	tsm_dev_put(tdev);
+	return ret;
+}
+
+static DEVICE_ATTR_RW(tsm_tc_mask);
+
+static ssize_t tsm_dev_connect_store(struct device *dev, struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	struct tsm_dev *tdev = tsm_dev_get(dev);
+	unsigned long val;
+	ssize_t ret = -EIO;
+
+	if (kstrtoul(buf, 0, &val) < 0)
+		ret = -EINVAL;
+	else if (val && !tdev->connected)
+		ret = tsm_dev_connect(tdev, tsm.private_data, val);
+	else if (!val && tdev->connected)
+		ret = tsm_dev_reclaim(tdev, tsm.private_data);
+
+	if (!ret)
+		ret = count;
+
+	tsm_dev_put(tdev);
+
+	return ret;
+}
+
+static ssize_t tsm_dev_connect_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct tsm_dev *tdev = tsm_dev_get(dev);
+	ssize_t ret = sysfs_emit(buf, "%u\n", tdev->connected);
+
+	tsm_dev_put(tdev);
+	return ret;
+}
+
+static DEVICE_ATTR_RW(tsm_dev_connect);
+
+static ssize_t tsm_sel_stream_store(struct device *dev, struct device_attribute *attr,
+				    const char *buf, size_t count)
+{
+	unsigned int ide_dev = false, tee_dev = true, ide_rp = true, tee_rp = false;
+	unsigned int sel_index, id, def, en;
+	struct tsm_dev *tdev;
+
+	if (sscanf(buf, "%u %u %u %u %u %u %u %u", &sel_index, &id, &def, &en,
+		   &ide_dev, &tee_dev, &ide_rp, &tee_rp) != 8) {
+		if (sscanf(buf, "%u %u %u %u", &sel_index, &id, &def, &en) != 4)
+			return -EINVAL;
+	}
+
+	if (sel_index >= ARRAY_SIZE(tdev->selective_ide) || id > 0x100)
+		return -EINVAL;
+
+	tdev = tsm_dev_get(dev);
+	if (en) {
+		tdev->selective_ide[sel_index].id = id;
+		tdev->selective_ide[sel_index].def = def;
+		tdev->selective_ide[sel_index].enable = 1;
+		tdev->selective_ide[sel_index].enabled = 0;
+		tdev->selective_ide[sel_index].dev_ide_cfg = ide_dev;
+		tdev->selective_ide[sel_index].dev_tee_limited = tee_dev;
+		tdev->selective_ide[sel_index].rootport_ide_cfg = ide_rp;
+		tdev->selective_ide[sel_index].rootport_tee_limited = tee_rp;
+	} else {
+		memset(&tdev->selective_ide[sel_index], 0, sizeof(tdev->selective_ide[0]));
+	}
+
+	tsm_dev_put(tdev);
+	return count;
+}
+
+static ssize_t tsm_sel_stream_show(struct device *dev, struct device_attribute *attr,
+				   char *buf)
+{
+	struct tsm_dev *tdev = tsm_dev_get(dev);
+	struct pci_dev *rootport = tdev->pdev->bus->self;
+	unsigned int i;
+	char *buf1;
+	ssize_t ret = 0, sz = PAGE_SIZE;
+
+	buf1 = kmalloc(sz, GFP_KERNEL);
+	if (!buf1)
+		return -ENOMEM;
+
+	buf1[0] = 0;
+	for (i = 0; i < ARRAY_SIZE(tdev->selective_ide); ++i) {
+		if (!tdev->selective_ide[i].enable)
+			continue;
+
+		ret += snprintf(buf1 + ret, sz - ret - 1, "%u: %d%s",
+				i,
+				tdev->selective_ide[i].id,
+				tdev->selective_ide[i].def ? " DEF" : "");
+		if (tdev->selective_ide[i].enabled) {
+			u32 devst = 0, rcst = 0;
+
+			pci_ide_get_sel_sta(tdev->pdev, i, &devst);
+			pci_ide_get_sel_sta(rootport, i, &rcst);
+			ret += snprintf(buf1 + ret, sz - ret - 1,
+				" %x%s %s%s<-> %x%s %s%s rootport:%s",
+				devst,
+				PCI_IDE_SEL_STS_STATUS(devst) == 2 ? "=SECURE" : "",
+				tdev->selective_ide[i].dev_ide_cfg ? "IDECfg " : "",
+				tdev->selective_ide[i].dev_tee_limited ? "TeeLim " : "",
+				rcst,
+				PCI_IDE_SEL_STS_STATUS(rcst) == 2 ? "=SECURE" : "",
+				tdev->selective_ide[i].rootport_ide_cfg ? "IDECfg " : "",
+				tdev->selective_ide[i].rootport_tee_limited ? "TeeLim " : "",
+				pci_name(rootport)
+			       );
+		}
+		ret += snprintf(buf1 + ret, sz - ret - 1, "\n");
+	}
+	tsm_dev_put(tdev);
+
+	ret = sysfs_emit(buf, buf1);
+	kfree(buf1);
+
+	return ret;
+}
+
+static DEVICE_ATTR_RW(tsm_sel_stream);
+
+static ssize_t tsm_ide_refresh_store(struct device *dev, struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	struct tsm_dev *tdev = tsm_dev_get(dev);
+	int ret;
+
+	ret = tsm_ide_refresh(tdev, tsm.private_data);
+	tsm_dev_put(tdev);
+	if (ret)
+		return ret;
+
+	return count;
+}
+
+static DEVICE_ATTR_WO(tsm_ide_refresh);
+
+static ssize_t blob_show(struct tsm_blob *blob, char *buf)
+{
+	unsigned int n, m;
+
+	if (!blob)
+		return sysfs_emit(buf, "none\n");
+
+	n = snprintf(buf, PAGE_SIZE, "%lu %u\n", blob->len,
+		     kref_read(&blob->kref));
+	m = hex_dump_to_buffer(blob->data, blob->len, 32, 1,
+			       buf + n, PAGE_SIZE - n, false);
+	n += min(PAGE_SIZE - n, m);
+	n += snprintf(buf + n, PAGE_SIZE - n, "...\n");
+	return n;
+}
+
+static ssize_t tsm_certs_gen(struct tsm_blob *certs, char *buf, size_t len)
+{
+	struct spdm_certchain_block_header *h;
+	unsigned int n = 0, m, i, off, o2;
+	u8 *p;
+
+	for (i = 0, off = 0; off < certs->len; ++i) {
+		h = (struct spdm_certchain_block_header *) ((u8 *)certs->data + off);
+		if (WARN_ON_ONCE(h->length > certs->len - off))
+			return 0;
+
+		n += snprintf(buf + n, len - n, "[%d] len=%d:\n", i, h->length);
+
+		for (o2 = 0, p = (u8 *)&h[1]; o2 < h->length; o2 += 32) {
+			m = hex_dump_to_buffer(p + o2, h->length - o2, 32, 1,
+					       buf + n, len - n, true);
+			n += min(len - n, m);
+			n += snprintf(buf + n, len - n, "\n");
+		}
+
+		off += h->length; /* Includes the header */
+	}
+
+	return n;
+}
+
+static ssize_t tsm_certs_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct tsm_dev *tdev = tsm_dev_get(dev);
+	ssize_t n = 0;
+
+	if (!tdev->certs) {
+		n = sysfs_emit(buf, "none\n");
+	} else {
+		n = tsm_certs_gen(tdev->certs, buf, PAGE_SIZE);
+		if (!n)
+			n = blob_show(tdev->certs, buf);
+	}
+
+	tsm_dev_put(tdev);
+	return n;
+}
+
+static DEVICE_ATTR_RO(tsm_certs);
+
+static ssize_t tsm_meas_gen(struct tsm_blob *meas, char *buf, size_t len)
+{
+	static const char * const whats[] = {
+		"ImmuROM", "MutFW", "HWCfg", "FWCfg",
+		"MeasMft", "DevDbg", "MutFWVer", "MutFWVerSec"
+	};
+	struct dmtf_measurement_block_device_mode *dm;
+	struct spdm_measurement_block_header *mb;
+	struct dmtf_measurement_block_header *h;
+	unsigned int n = 0, m, off, what;
+	bool dmtf;
+
+	for (off = 0; off < meas->len; ) {
+		mb = (struct spdm_measurement_block_header *)(((u8 *) meas->data) + off);
+		dmtf = mb->spec & 1;
+
+		n += snprintf(buf + n, len - n, "#%d (%d) ", mb->index, mb->size);
+		if (dmtf) {
+			h = (void *) &mb[1];
+
+			if (WARN_ON_ONCE(mb->size != (sizeof(*h) + h->size)))
+				return -EINVAL;
+
+			what = h->type & 0x7F;
+			n += snprintf(buf + n, len - n, "%x=[%s %s]: ",
+				h->type,
+				h->type & 0x80 ? "digest" : "raw",
+				what < ARRAY_SIZE(whats) ? whats[what] : "reserved");
+
+			if (what == 5) {
+				dm = (struct dmtf_measurement_block_device_mode *) &h[1];
+				n += snprintf(buf + n, len - n, " %x %x %x %x",
+					      dm->opmode_cap, dm->opmode_sta,
+					      dm->devmode_cap, dm->devmode_sta);
+			} else {
+				m = hex_dump_to_buffer(&h[1], h->size, 32, 1,
+						       buf + n, len - n, false);
+				n += min(PAGE_SIZE - n, m);
+			}
+		} else {
+			n += snprintf(buf + n, len - n, "spec=%x: ", mb->spec);
+			m = hex_dump_to_buffer(&mb[1], min(len - off, mb->size),
+					       32, 1, buf + n, len - n, false);
+			n += min(PAGE_SIZE - n, m);
+		}
+
+		off += sizeof(*mb) + mb->size;
+		n += snprintf(buf + n, PAGE_SIZE - n, "...\n");
+	}
+
+	return n;
+}
+
+static ssize_t tsm_meas_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct tsm_dev *tdev = tsm_dev_get(dev);
+	ssize_t n = 0;
+
+	if (!tdev->meas) {
+		n = sysfs_emit(buf, "none\n");
+	} else {
+		if (!n)
+			n = tsm_meas_gen(tdev->meas, buf, PAGE_SIZE);
+		if (!n)
+			n = blob_show(tdev->meas, buf);
+	}
+
+	tsm_dev_put(tdev);
+	return n;
+}
+
+static DEVICE_ATTR_RO(tsm_meas);
+
+static ssize_t tsm_dev_status_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct tsm_dev *tdev = tsm_dev_get(dev);
+	struct tsm_dev_status s = { 0 };
+	int ret = tsm_dev_status(tdev, tsm.private_data, &s);
+	ssize_t ret1;
+
+	ret1 = sysfs_emit(buf, "ret=%d\n"
+			  "ctx_state=%x\n"
+			  "tc_mask=%x\n"
+			  "certs_slot=%x\n"
+			  "device_id=%x\n"
+			  "segment_id=%x\n"
+			  "no_fw_update=%x\n",
+			  ret,
+			  s.ctx_state,
+			  s.tc_mask,
+			  s.certs_slot,
+			  s.device_id,
+			  s.segment_id,
+			  s.no_fw_update);
+
+	tsm_dev_put(tdev);
+	return ret1;
+}
+
+static DEVICE_ATTR_RO(tsm_dev_status);
+
+static struct attribute *host_dev_attrs[] = {
+	&dev_attr_tsm_cert_slot.attr,
+	&dev_attr_tsm_tc_mask.attr,
+	&dev_attr_tsm_dev_connect.attr,
+	&dev_attr_tsm_sel_stream.attr,
+	&dev_attr_tsm_ide_refresh.attr,
+	&dev_attr_tsm_certs.attr,
+	&dev_attr_tsm_meas.attr,
+	&dev_attr_tsm_dev_status.attr,
+	NULL,
+};
+static const struct attribute_group host_dev_group = {
+	.attrs = host_dev_attrs,
+};
+
+static struct attribute *guest_dev_attrs[] = {
+	&dev_attr_tsm_certs.attr,
+	&dev_attr_tsm_meas.attr,
+	NULL,
+};
+static const struct attribute_group guest_dev_group = {
+	.attrs = guest_dev_attrs,
+};
+
+static ssize_t tsm_tdi_bind_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct tsm_tdi *tdi = tsm_tdi_get(dev);
+
+	if (!tdi->vmid)
+		return sysfs_emit(buf, "not bound\n");
+
+	return sysfs_emit(buf, "VM=%#llx ASID=%d BDFn=%x:%x.%d\n",
+			  tdi->vmid, tdi->asid,
+			  PCI_BUS_NUM(tdi->guest_rid), PCI_SLOT(tdi->guest_rid),
+			  PCI_FUNC(tdi->guest_rid));
+}
+
+static DEVICE_ATTR_RO(tsm_tdi_bind);
+
+static ssize_t tsm_tdi_validate_store(struct device *dev, struct device_attribute *attr,
+				      const char *buf, size_t count)
+{
+	struct tsm_tdi *tdi = tsm_tdi_get(dev);
+	unsigned long val;
+	ssize_t ret;
+
+	if (kstrtoul(buf, 0, &val) < 0)
+		return -EINVAL;
+
+	if (val) {
+		ret = tsm_tdi_validate(tdi, false, tsm.private_data);
+		if (ret)
+			return ret;
+	} else {
+		tsm_tdi_validate(tdi, true, tsm.private_data);
+	}
+
+	tdi->validated = val;
+
+	return count;
+}
+
+static ssize_t tsm_tdi_validate_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct tsm_tdi *tdi = tsm_tdi_get(dev);
+
+	return sysfs_emit(buf, "%u\n", tdi->validated);
+}
+
+static DEVICE_ATTR_RW(tsm_tdi_validate);
+
+ssize_t tsm_report_gen(struct tsm_blob *report, char *buf, size_t len)
+{
+	struct tdi_report_header *h = TDI_REPORT_HDR(report);
+	struct tdi_report_mmio_range *mr = TDI_REPORT_MR_OFF(report);
+	struct tdi_report_footer *f = TDI_REPORT_FTR(report);
+	unsigned int n, m, i;
+
+	n = snprintf(buf, len,
+		     "no_fw_update=%u\ndma_no_pasid=%u\ndma_pasid=%u\nats=%u\nprs=%u\n",
+		     h->no_fw_update, h->dma_no_pasid, h->dma_pasid, h->ats, h->prs);
+	n += snprintf(buf + n, len - n,
+		      "msi_x_message_control=%#04x\nlnr_control=%#04x\n",
+		      h->msi_x_message_control, h->lnr_control);
+	n += snprintf(buf + n, len - n, "tph_control=%#08x\n", h->tph_control);
+
+	for (i = 0; i < h->mmio_range_count; ++i) {
+		n += snprintf(buf + n, len - n,
+			      "[%i] #%u %#016llx +%#lx MSIX%c PBA%c NonTEE%c Upd%c\n",
+			      i, mr[i].range_id, mr[i].first_page << PAGE_SHIFT,
+			      (unsigned long) mr[i].num << PAGE_SHIFT,
+			      mr[i].msix_table ? '+':'-',
+			      mr[i].msix_pba ? '+':'-',
+			      mr[i].is_non_tee_mem ? '+':'-',
+			      mr[i].is_mem_attr_updatable ? '+':'-');
+		if (mr[i].reserved)
+			n += snprintf(buf + n, len - n,
+			      "[%i] WARN: reserved=%#x\n", i, mr[i].range_attributes);
+	}
+
+	if (f->device_specific_info_len) {
+		unsigned int num = report->len - ((u8 *)f->device_specific_info - (u8 *)h);
+
+		num = min(num, f->device_specific_info_len);
+		n += snprintf(buf + n, len - n, "DevSp len=%d%s",
+			f->device_specific_info_len, num ? ": " : "");
+		m = hex_dump_to_buffer(f->device_specific_info, num, 32, 1,
+				       buf + n, len - n, false);
+		n += min(len - n, m);
+		n += snprintf(buf + n, len - n, m ? "\n" : "...\n");
+	}
+
+	return n;
+}
+EXPORT_SYMBOL_GPL(tsm_report_gen);
+
+static ssize_t tsm_report_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct tsm_tdi *tdi = tsm_tdi_get(dev);
+	ssize_t n = 0;
+
+	if (!tdi->report) {
+		n = sysfs_emit(buf, "none\n");
+	} else {
+		if (!n)
+			n = tsm_report_gen(tdi->report, buf, PAGE_SIZE);
+		if (!n)
+			n = blob_show(tdi->report, buf);
+	}
+
+	return n;
+}
+
+static DEVICE_ATTR_RO(tsm_report);
+
+static char *spdm_algos_to_str(u64 algos, char *buf, size_t len)
+{
+	size_t n = 0;
+
+	buf[0] = 0;
+#define __ALGO(x) do {								\
+		if ((n < len) && (algos & (1ULL << (TSM_TDI_SPDM_ALGOS_##x))))	\
+			n += snprintf(buf + n, len - n, #x" ");			\
+	} while (0)
+
+	__ALGO(DHE_SECP256R1);
+	__ALGO(DHE_SECP384R1);
+	__ALGO(AEAD_AES_128_GCM);
+	__ALGO(AEAD_AES_256_GCM);
+	__ALGO(ASYM_TPM_ALG_RSASSA_3072);
+	__ALGO(ASYM_TPM_ALG_ECDSA_ECC_NIST_P256);
+	__ALGO(ASYM_TPM_ALG_ECDSA_ECC_NIST_P384);
+	__ALGO(HASH_TPM_ALG_SHA_256);
+	__ALGO(HASH_TPM_ALG_SHA_384);
+	__ALGO(KEY_SCHED_SPDM_KEY_SCHEDULE);
+#undef __ALGO
+	return buf;
+}
+
+static const char *tdisp_state_to_str(enum tsm_tdisp_state state)
+{
+	switch (state) {
+#define __ST(x) case TDISP_STATE_##x: return #x
+	case TDISP_STATE_UNAVAIL: return "TDISP state unavailable";
+	__ST(CONFIG_UNLOCKED);
+	__ST(CONFIG_LOCKED);
+	__ST(RUN);
+	__ST(ERROR);
+#undef __ST
+	default: return "unknown";
+	}
+}
+
+static ssize_t tsm_tdi_status_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct tsm_tdi *tdi = tsm_tdi_get(dev);
+	struct tsm_tdi_status ts = { 0 };
+	char algos[256] = "";
+	unsigned int n, m;
+	int ret;
+
+	ret = tsm_tdi_status(tdi, tsm.private_data, &ts);
+	if (ret < 0)
+		return sysfs_emit(buf, "ret=%d\n\n", ret);
+
+	if (!ts.valid)
+		return sysfs_emit(buf, "ret=%d\nstate=%d:%s\n",
+				  ret, ts.state, tdisp_state_to_str(ts.state));
+
+	n = snprintf(buf, PAGE_SIZE,
+		     "ret=%d\n"
+		     "state=%d:%s\n"
+		     "meas_digest_fresh=%x\n"
+		     "meas_digest_valid=%x\n"
+		     "all_request_redirect=%x\n"
+		     "bind_p2p=%x\n"
+		     "lock_msix=%x\n"
+		     "no_fw_update=%x\n"
+		     "cache_line_size=%d\n"
+		     "algos=%#llx:%s\n"
+		     ,
+		     ret,
+		     ts.state, tdisp_state_to_str(ts.state),
+		     ts.meas_digest_fresh,
+		     ts.meas_digest_valid,
+		     ts.all_request_redirect,
+		     ts.bind_p2p,
+		     ts.lock_msix,
+		     ts.no_fw_update,
+		     ts.cache_line_size,
+		     ts.spdm_algos, spdm_algos_to_str(ts.spdm_algos, algos, sizeof(algos) - 1));
+
+	n += snprintf(buf + n, PAGE_SIZE - n, "Certs digest: ");
+	m = hex_dump_to_buffer(ts.certs_digest, sizeof(ts.certs_digest), 32, 1,
+			       buf + n, PAGE_SIZE - n, false);
+	n += min(PAGE_SIZE - n, m);
+	n += snprintf(buf + n, PAGE_SIZE - n, "...\nMeasurements digest: ");
+	m = hex_dump_to_buffer(ts.meas_digest, sizeof(ts.meas_digest), 32, 1,
+			       buf + n, PAGE_SIZE - n, false);
+	n += min(PAGE_SIZE - n, m);
+	n += snprintf(buf + n, PAGE_SIZE - n, "...\nInterface report digest: ");
+	m = hex_dump_to_buffer(ts.interface_report_digest, sizeof(ts.interface_report_digest),
+			       32, 1, buf + n, PAGE_SIZE - n, false);
+	n += min(PAGE_SIZE - n, m);
+	n += snprintf(buf + n, PAGE_SIZE - n, "...\n");
+
+	return n;
+}
+
+static DEVICE_ATTR_RO(tsm_tdi_status);
+
+static struct attribute *host_tdi_attrs[] = {
+	&dev_attr_tsm_tdi_bind.attr,
+	&dev_attr_tsm_report.attr,
+	&dev_attr_tsm_tdi_status.attr,
+	NULL,
+};
+
+static const struct attribute_group host_tdi_group = {
+	.attrs = host_tdi_attrs,
+};
+
+static struct attribute *guest_tdi_attrs[] = {
+	&dev_attr_tsm_tdi_validate.attr,
+	&dev_attr_tsm_report.attr,
+	&dev_attr_tsm_tdi_status.attr,
+	NULL,
+};
+
+static const struct attribute_group guest_tdi_group = {
+	.attrs = guest_tdi_attrs,
+};
+
+static int tsm_tdi_init(struct tsm_dev *tdev, struct pci_dev *pdev)
+{
+	struct tsm_tdi *tdi;
+	int ret = 0;
+
+	dev_info(&pdev->dev, "Initializing tdi\n");
+	if (!tdev)
+		return -ENODEV;
+
+	tdi = kzalloc(sizeof(*tdi), GFP_KERNEL);
+	if (!tdi)
+		return -ENOMEM;
+
+	/* tsm_dev_get() requires pdev->dev.tdi which is set later */
+	if (!kref_get_unless_zero(&tdev->kref)) {
+		ret = -EPERM;
+		goto free_exit;
+	}
+
+	if (tsm.ops->dev_connect)
+		tdi->ag = &host_tdi_group;
+	else
+		tdi->ag = &guest_tdi_group;
+
+	ret = sysfs_create_link(&pdev->dev.kobj, &tdev->pdev->dev.kobj, "tsm_dev");
+	if (ret)
+		goto free_exit;
+
+	ret = device_add_group(&pdev->dev, tdi->ag);
+	if (ret)
+		goto sysfs_unlink_exit;
+
+	tdi->tdev = tdev;
+	tdi->pdev = pci_dev_get(pdev);
+
+	pdev->dev.tdi_enabled = !pdev->is_physfn || tsm.physfn;
+	pdev->dev.tdi = tdi;
+	pci_info(pdev, "TDI enabled=%d\n", pdev->dev.tdi_enabled);
+
+	return 0;
+
+sysfs_unlink_exit:
+	sysfs_remove_link(&pdev->dev.kobj, "tsm_dev");
+free_exit:
+	kfree(tdi);
+
+	return ret;
+}
+
+static void tsm_tdi_free(struct tsm_tdi *tdi)
+{
+	tsm_dev_put(tdi->tdev);
+
+	pci_dev_put(tdi->pdev);
+
+	device_remove_group(&tdi->pdev->dev, tdi->ag);
+	sysfs_remove_link(&tdi->pdev->dev.kobj, "tsm_dev");
+	tdi->pdev->dev.tdi = NULL;
+	tdi->pdev->dev.tdi_enabled = false;
+	kfree(tdi);
+}
+
+static int tsm_dev_init(struct pci_dev *pdev, struct tsm_dev **ptdev)
+{
+	struct tsm_dev *tdev;
+	int ret = 0;
+
+	dev_info(&pdev->dev, "Initializing tdev\n");
+	tdev = kzalloc(sizeof(*tdev), GFP_KERNEL);
+	if (!tdev)
+		return -ENOMEM;
+
+	kref_init(&tdev->kref);
+	tdev->tc_mask = tsm.tc_mask;
+	tdev->cert_slot = tsm.cert_slot;
+	tdev->pdev = pci_dev_get(pdev);
+	mutex_init(&tdev->spdm_mutex);
+
+	if (tsm.ops->dev_connect)
+		tdev->ag = &host_dev_group;
+	else
+		tdev->ag = &guest_dev_group;
+
+	ret = device_add_group(&pdev->dev, tdev->ag);
+	if (ret)
+		goto free_exit;
+
+	if (tsm.ops->dev_connect) {
+		ret = -EPERM;
+		tdev->pdev = pci_dev_get(pdev);
+		tdev->spdm.doe_mb = pci_find_doe_mailbox(tdev->pdev,
+							 PCI_VENDOR_ID_PCI_SIG,
+							 PCI_DOE_PROTOCOL_CMA_SPDM);
+		if (!tdev->spdm.doe_mb)
+			goto pci_dev_put_exit;
+
+		tdev->spdm.doe_mb_secured = pci_find_doe_mailbox(tdev->pdev,
+								 PCI_VENDOR_ID_PCI_SIG,
+								 PCI_DOE_PROTOCOL_SECURED_CMA_SPDM);
+		if (!tdev->spdm.doe_mb_secured)
+			goto pci_dev_put_exit;
+	}
+
+	*ptdev = tdev;
+	return 0;
+
+pci_dev_put_exit:
+	pci_dev_put(pdev);
+free_exit:
+	kfree(tdev);
+
+	return ret;
+}
+
+static void tsm_dev_free(struct kref *kref)
+{
+	struct tsm_dev *tdev = container_of(kref, struct tsm_dev, kref);
+
+	device_remove_group(&tdev->pdev->dev, tdev->ag);
+
+	if (tdev->connected)
+		tsm_dev_reclaim(tdev, tsm.private_data);
+
+	dev_info(&tdev->pdev->dev, "Freeing TDEV\n");
+	pci_dev_put(tdev->pdev);
+	kfree(tdev);
+}
+
+static int tsm_alloc_device(struct pci_dev *pdev)
+{
+	int ret = 0;
+
+	/* It is guest VM == TVM */
+	if (!tsm.ops->dev_connect) {
+		if (pdev->devcap & PCI_EXP_DEVCAP_TEE_IO) {
+			struct tsm_dev *tdev = NULL;
+
+			ret = tsm_dev_init(pdev, &tdev);
+			if (ret)
+				return ret;
+
+			ret = tsm_tdi_init(tdev, pdev);
+			tsm_dev_put(tdev);
+			return ret;
+		}
+		return 0;
+	}
+
+	if (pdev->is_physfn && (PCI_FUNC(pdev->devfn) == 0) &&
+	    (pdev->devcap & PCI_EXP_DEVCAP_TEE_IO)) {
+		struct tsm_dev *tdev = NULL;
+
+
+		ret = tsm_dev_init(pdev, &tdev);
+		if (ret)
+			return ret;
+
+		ret = tsm_tdi_init(tdev, pdev);
+		tsm_dev_put(tdev);
+		return ret;
+	}
+
+	if (pdev->is_virtfn) {
+		struct pci_dev *pf0 = pci_get_slot(pdev->physfn->bus,
+						   pdev->physfn->devfn & ~7);
+
+		if (pf0 && (pf0->devcap & PCI_EXP_DEVCAP_TEE_IO)) {
+			struct tsm_dev *tdev = tsm_dev_get(&pf0->dev);
+
+			ret = tsm_tdi_init(tdev, pdev);
+			tsm_dev_put(tdev);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static void tsm_dev_freeice(struct device *dev)
+{
+	struct tsm_tdi *tdi = tsm_tdi_get(dev);
+
+	if (!tdi)
+		return;
+
+	tsm_tdi_free(tdi);
+}
+
+static int tsm_pci_bus_notifier(struct notifier_block *nb, unsigned long action, void *data)
+{
+	switch (action) {
+	case BUS_NOTIFY_ADD_DEVICE:
+		tsm_alloc_device(to_pci_dev(data));
+		break;
+	case BUS_NOTIFY_DEL_DEVICE:
+		tsm_dev_freeice(data);
+		break;
+	case BUS_NOTIFY_UNBOUND_DRIVER:
+		tsm_tdi_validate(tsm_tdi_get(data), true, tsm.private_data);
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block tsm_pci_bus_nb = {
+	.notifier_call = tsm_pci_bus_notifier,
+};
+
+static int __init tsm_init(void)
+{
+	int ret = 0;
+
+	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
+	return ret;
+}
+
+static void __exit tsm_cleanup(void)
+{
+}
+
+void tsm_set_ops(struct tsm_ops *ops, void *private_data)
+{
+	struct pci_dev *pdev = NULL;
+	int ret;
+
+	if (!tsm.ops && ops) {
+		tsm.ops = ops;
+		tsm.private_data = private_data;
+
+		for_each_pci_dev(pdev) {
+			ret = tsm_alloc_device(pdev);
+			if (ret)
+				break;
+		}
+		bus_register_notifier(&pci_bus_type, &tsm_pci_bus_nb);
+	} else {
+		bus_unregister_notifier(&pci_bus_type, &tsm_pci_bus_nb);
+		for_each_pci_dev(pdev)
+			tsm_dev_freeice(&pdev->dev);
+		tsm.ops = ops;
+	}
+}
+EXPORT_SYMBOL_GPL(tsm_set_ops);
+
+int tsm_tdi_bind(struct tsm_tdi *tdi, u32 guest_rid, u64 vmid, u32 asid)
+{
+	int ret;
+
+	if (WARN_ON(!tsm.ops->tdi_bind))
+		return -EPERM;
+
+	tdi->guest_rid = guest_rid;
+	tdi->vmid = vmid;
+	tdi->asid = asid;
+
+	mutex_lock(&tdi->tdev->spdm_mutex);
+	while (1) {
+		ret = tsm.ops->tdi_bind(tdi, guest_rid, vmid, asid, tsm.private_data);
+		if (ret < 0)
+			break;
+
+		if (!ret)
+			break;
+
+		ret = spdm_forward(&tdi->tdev->spdm, ret);
+		if (ret < 0)
+			break;
+	}
+	mutex_unlock(&tdi->tdev->spdm_mutex);
+
+	if (ret) {
+		tsm_tdi_unbind(tdi);
+		return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(tsm_tdi_bind);
+
+void tsm_tdi_unbind(struct tsm_tdi *tdi)
+{
+	tsm_tdi_reclaim(tdi, tsm.private_data);
+	tdi->vmid = 0;
+	tdi->asid = 0;
+	tdi->guest_rid = 0;
+}
+EXPORT_SYMBOL_GPL(tsm_tdi_unbind);
+
+int tsm_guest_request(struct tsm_tdi *tdi, enum tsm_tdisp_state *state, void *req_data)
+{
+	int ret;
+
+	if (!tsm.ops->guest_request)
+		return -EPERM;
+
+	mutex_lock(&tdi->tdev->spdm_mutex);
+	while (1) {
+		ret = tsm.ops->guest_request(tdi, tdi->guest_rid, tdi->vmid, req_data,
+					     state, tsm.private_data);
+		if (ret <= 0)
+			break;
+
+		ret = spdm_forward(&tdi->tdev->spdm, ret);
+		if (ret < 0)
+			break;
+	}
+	mutex_unlock(&tdi->tdev->spdm_mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tsm_guest_request);
+
+struct tsm_tdi *tsm_tdi_find(u32 guest_rid, u64 vmid)
+{
+	struct pci_dev *pdev = NULL;
+	struct tsm_tdi *tdi;
+
+	for_each_pci_dev(pdev) {
+		tdi = tsm_tdi_get(&pdev->dev);
+		if (!tdi)
+			continue;
+
+		if (tdi->vmid == vmid && tdi->guest_rid == guest_rid)
+			return tdi;
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(tsm_tdi_find);
+
+module_init(tsm_init);
+module_exit(tsm_cleanup);
+
+MODULE_VERSION(DRIVER_VERSION);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
diff --git a/Documentation/virt/coco/tsm.rst b/Documentation/virt/coco/tsm.rst
new file mode 100644
index 000000000000..3be6e8491e42
--- /dev/null
+++ b/Documentation/virt/coco/tsm.rst
@@ -0,0 +1,62 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+What it is
+==========
+
+This is for PCI passthrough in confidential computing (CoCo: SEV-SNP, TDX, CoVE).
+Currently passing through PCI devices to a CoCo VM uses SWIOTLB to pre-shared
+memory buffers.
+
+PCIe IDE (Integrity and Data Encryption) and TDISP (TEE Device Interface Security
+Protocol) are protocols to enable encryption over PCIe link and DMA to encrypted
+memory. This doc is focused to DMAing to encrypted VM, the encrypted host memory is
+out of scope.
+
+
+Protocols
+=========
+
+PCIe r6 DOE is a mailbox protocol to read/write object from/to device.
+Objects are of plain SPDM or secure SPDM type. SPDM is responsible for authenticating
+devices, creating a secure link between a device and TSM.
+IDE_KM manages PCIe link encryption keys, it works on top of secure SPDM.
+TDISP manages a passed through PCI function state, also works on top on secure SPDM.
+Additionally, PCIe defines IDE capability which provides the host OS a way
+to enable streams on the PCIe link.
+
+
+TSM module
+==========
+
+This is common place to trigger device authentication and keys management.
+It exposes certificates/measurenets/reports/status via sysfs and provides control
+over the link (limited though by the TSM capabilities).
+A platform is expected to register a specific set of hooks. The same module works
+in host and guest OS, the set of requires platform hooks is quite different.
+
+
+Flow
+====
+
+At the boot time the tsm.ko scans the PCI bus to find and setup TDISP-cabable
+devices; it also listens to hotplug events. If setup was successful, tsm-prefixed
+nodes will appear in sysfs.
+
+Then, the user enables IDE by writing to /sys/bus/pci/devices/0000:e1:00.0/tsm_dev_connect
+and this is how PCIe encryption is enabled.
+
+To pass the device through, a modifined VMM is required.
+
+In the VM, the same tsm.ko loads. In addition to the host's setup, the VM wants
+to receive the report and enable secure DMA or/and secure MMIO, via some VM<->HV
+protocol (such as AMD GHCB). Once this is done, a VM can access validated MMIO
+with the Cbit set and the device can DMA to encrypted memory.
+
+
+References
+==========
+
+[1] TEE Device Interface Security Protocol - TDISP - v2022-07-27
+https://members.pcisig.com/wg/PCI-SIG/document/18268?downloadRevision=21500
+[2] Security Protocol and Data Model (SPDM)
+https://www.dmtf.org/sites/default/files/standards/documents/DSP0274_1.2.1.pdf
diff --git a/drivers/virt/coco/Kconfig b/drivers/virt/coco/Kconfig
index 87d142c1f932..67a9c9daf96d 100644
--- a/drivers/virt/coco/Kconfig
+++ b/drivers/virt/coco/Kconfig
@@ -7,6 +7,17 @@ config TSM_REPORTS
 	select CONFIGFS_FS
 	tristate
 
+config TSM
+	tristate "Platform support for TEE Device Interface Security Protocol (TDISP)"
+	default m
+	depends on AMD_MEM_ENCRYPT
+	select PCI_DOE
+	select PCI_IDE
+	help
+	  Add a common place for user visible platform support for PCIe TDISP.
+	  TEE Device Interface Security Protocol (TDISP) from PCI-SIG,
+	  https://pcisig.com/tee-device-interface-security-protocol-tdisp
+
 source "drivers/virt/coco/efi_secret/Kconfig"
 
 source "drivers/virt/coco/sev-guest/Kconfig"
-- 
2.45.2


