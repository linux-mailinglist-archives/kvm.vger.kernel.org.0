Return-Path: <kvm+bounces-24898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8AF495CDBE
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 15:27:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E1CA11C2290F
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 13:27:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBF67186E40;
	Fri, 23 Aug 2024 13:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mj6tfmao"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2056.outbound.protection.outlook.com [40.107.237.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1683F186601;
	Fri, 23 Aug 2024 13:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724419664; cv=fail; b=CGXShdPEDnGObAzhYPNyKznUnzPeMGzjscYPtr02LUD5QzlCBHRBQCEZE5D8IKwoK1hJAkNj7+8/U6M6obhpHTQ5HUp1DTHZIn/HpOzEZWmsUk1ummza3GnkeUs8EiqU9cU/gK+u6A1XVl+NH+kGTHx97gbfTA8/uR3mtpO598U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724419664; c=relaxed/simple;
	bh=wCZkYK1X19TRNlU0ZD+LtT2+hVDfTkEAFW23mMGdFqU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qyX6W94FHp2wAR+5/nVoCsBA1PcJ2LBzdDjxajWYqmCrVma7nWFG+u78fMVNRyXakic0E22p71Eov38To74EJaxj/tgPLJLyBkfTvVsE7LyPe+bmcEPR+h8GFWYhxGeB3lDQS6x64QvGvTzjrNtKdALvlITBsOOXBCcUc7qmrEA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mj6tfmao; arc=fail smtp.client-ip=40.107.237.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=POp/dYi0PyaNjjOnEr06219QwzePKh+Nr3y4YoY4iNkFvFlWwh/6JqVInIYqOUmtZewFbuUErU8mUSUXOxKEym2pFR2OZHMNmUtQVLJeRlNmknECgzehArdsx+QTxW02qU115N7f4UduFZGpJYwrTCKyRilHb53JTRJdyT1tJvnBCJQnKM8k/bvvn+ugJb31k8TUQBQ3gD/iqPQbiPgbLCJYj5e4vEPA2Qm0S7dqxl+K60MzcXxruLXK/SjjU68bgvHLVVNFZ9cThYjB/65e7IxxOTM1v9muB2S9YOpOhhZR7VQZtSszeUKx8x5IDigSVgvs0DB6M/YpH/05OHN/CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4P/rxNsLNVWWgGnBX7xA8uanIeUgEWEzCHRmWBSt3fg=;
 b=cY7d2wNvurUQmmDgIomD107FEtIy1XGaM/KQA3Y/GpE8BdqhzgCei6mz7+5xODLzn5kM/BajzeY2y6bgT3D8fwmx3yX+xd/NQSyTZKtQ5j5Q5cxiMbVAYT7xa5fl5Xm8x6LL5aUAut50q79emWhqMdB5pl3xMKMHoCKJmXTlDyRG8NfQu+rWg/ZcYqwY21yjx/nlu9UROMwm1CyDtVm4+NQJbFK2l5C/CInF+TJuUbUNhm2vZH9P5VfZrbBLUeAZ7ShQlR+7oobtM635rblrfemVlqpJYaFPpiTiKyeydwSOdRSYhzxIgQ0xvUXKQfj6dQzfZDC3NzGZv6RpbqE/dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4P/rxNsLNVWWgGnBX7xA8uanIeUgEWEzCHRmWBSt3fg=;
 b=mj6tfmaoFTV72DtGI3LUgQbM97KkkjyJWi1KPFNYe/tWu0Z5pupjJyHx6IA8aOqPBwmoCPT8XqQwOXkNSZTFb1Lll18vv4ojIoR05CcMb6hhsqoonCIQd/upPESveUiIpnMpICPcuIg3A2B7YOsQRh80I9cWvUYGtvoDk5DM2ik=
Received: from CH2PR04CA0021.namprd04.prod.outlook.com (2603:10b6:610:52::31)
 by DS7PR12MB8290.namprd12.prod.outlook.com (2603:10b6:8:d8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.19; Fri, 23 Aug
 2024 13:27:36 +0000
Received: from DS2PEPF00003440.namprd02.prod.outlook.com
 (2603:10b6:610:52:cafe::2e) by CH2PR04CA0021.outlook.office365.com
 (2603:10b6:610:52::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.19 via Frontend
 Transport; Fri, 23 Aug 2024 13:27:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF00003440.mail.protection.outlook.com (10.167.18.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7897.11 via Frontend Transport; Fri, 23 Aug 2024 13:27:36 +0000
Received: from aiemdee.2.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 23 Aug
 2024 08:27:31 -0500
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
Subject: [RFC PATCH 01/21] tsm-report: Rename module to reflect what it does
Date: Fri, 23 Aug 2024 23:21:15 +1000
Message-ID: <20240823132137.336874-2-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF00003440:EE_|DS7PR12MB8290:EE_
X-MS-Office365-Filtering-Correlation-Id: e5335895-cab8-4326-8316-08dcc3775a64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HW5CBVnQ9P2lJcbahRnlqMlALXmWW5YV4oUoNLbyRbVty2JWbilOuD8zkP3x?=
 =?us-ascii?Q?46fHeMkMjlGL8jXyvaxJLXsYA0jJ5b0D+TBkCbdt85OjG/WPzC/ChqZhSA61?=
 =?us-ascii?Q?OFLrpvnZerZ9oQd4G2i7YLRl+6PHs2HFw2qn4KJPYbfpngr81DjE384C9xso?=
 =?us-ascii?Q?OENuMgx4kyg0+QX4F1vOrGqJScBsvOTOSV6/DYAIAhX9AL9sHdHXnwxaaPYa?=
 =?us-ascii?Q?MXkgrKi/60zksdWhKRuOZ3I3LlRS1JTKjHF6cX6wBe5KqMVjAFYMVjox1mlf?=
 =?us-ascii?Q?kJYHr6T7OSVLGjQsC7vs8b8GExjJdT4mU/FP2Q18KvloK5jtHAFZxy+WCPDO?=
 =?us-ascii?Q?+orkMsKDbjxjfHDx/0FwpM7wCZdQZIrHEUH6dho5kXe/z+8/rn/n7osObdbo?=
 =?us-ascii?Q?Nc6SzJ2SCvG25Yo9m89dYiq+I6PciWZ/RUZXKIkxM+sX/NakAjR9WN3jhyNZ?=
 =?us-ascii?Q?/vfDaOByuB5Uu0n4nE7jfU22PfCQn+HcS39OtaQNBT/hC+57wnxK0G1a27G5?=
 =?us-ascii?Q?CVnyHNiGfM2MfCygSPI/VYPygxQquayyP55o9tn4QUA14H2LdcInxqF3MNMn?=
 =?us-ascii?Q?RWrJFXhzz/useuGOdjg4+T/x0iUNmDmWRS49GHbLY1MGle8NyswbgNpKM+e1?=
 =?us-ascii?Q?JReeVocKqveEDkx9wo/uKgERHIp3cISIdmWOSQqA6Ql+9Tf96rJ6bSO8OMnZ?=
 =?us-ascii?Q?bq9BDoEej/lGgOxIivRTWyMcafKQ6rSAC2w6z8seePQ/33EhVTOJpuxeT2eo?=
 =?us-ascii?Q?QDNShamaHOrim2yHpqVEn7FaPC8VIj2DLWxohGMtJhtLKcrirP8Q1kbk1eW6?=
 =?us-ascii?Q?ALp+j0fAWv0RQiBCEUFS9LPcXgGiTmGQNZ8UhdGPfq9bFAhwUAW2dG0zVCvl?=
 =?us-ascii?Q?UwyfdfdSUtWohX8WmKUkieT78Sahz+zb39sNZc9J2SFpN0VkvkW4GyviHrDj?=
 =?us-ascii?Q?YdJmQB5HuQu+wF5qGvs7xN7e5Xyw8K4JZQnONYy5Xn16PVCpwrHluAObLy5v?=
 =?us-ascii?Q?0WZCH84ITzcnfjoQDf/z1MciDHkzbeSgC2mtKMbJi3UIYFpAIQ9Cdw3KfDbv?=
 =?us-ascii?Q?S59paOt9dyEJbQYdKEjaZHcT9Sh4dvDhiJ+jrXwBbBTA62bKpWQJYHlXBkSC?=
 =?us-ascii?Q?JafLik28HwSlg0C1/bNmrPgvuK7Y86hVwe37cuPNTLsvKSOQ+ggnFC5VnSae?=
 =?us-ascii?Q?PKid40wG/CpCDBK4a3KCjDiDEuHSq/xDRDo+gDsvDdPGPGkMwCJdB30auaDV?=
 =?us-ascii?Q?pwiU5Hs+WLGRBdKgsgqgjhQ5Twv1YS9DtWYY5Aw8UuO6ejnxUKlBd/NvKY2e?=
 =?us-ascii?Q?Em/jwZqJr1JYozywd5FmuvbWs+cE1tphhubEPQUa2A5F1bI8TQwz+HBd//eq?=
 =?us-ascii?Q?zFQWyV4tNnk1u2vACDSVL3iR4RPsuU7dgf3Gp+mzSyQP3Nif29namcE9RG38?=
 =?us-ascii?Q?C5Yw4ZvZwOMnno6fIa/r0NcRCfmkhf1e?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2024 13:27:36.3735
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e5335895-cab8-4326-8316-08dcc3775a64
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003440.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8290

And release the name for TSM to be used for TDISP-associated code.

Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 drivers/virt/coco/Makefile                |  2 +-
 include/linux/{tsm.h => tsm-report.h}     | 15 ++++++++-------
 drivers/virt/coco/sev-guest/sev-guest.c   | 10 +++++-----
 drivers/virt/coco/tdx-guest/tdx-guest.c   |  8 ++++----
 drivers/virt/coco/{tsm.c => tsm-report.c} | 12 ++++++------
 MAINTAINERS                               |  4 ++--
 6 files changed, 26 insertions(+), 25 deletions(-)

diff --git a/drivers/virt/coco/Makefile b/drivers/virt/coco/Makefile
index 18c1aba5edb7..75defec514f8 100644
--- a/drivers/virt/coco/Makefile
+++ b/drivers/virt/coco/Makefile
@@ -2,7 +2,7 @@
 #
 # Confidential computing related collateral
 #
-obj-$(CONFIG_TSM_REPORTS)	+= tsm.o
+obj-$(CONFIG_TSM_REPORTS)	+= tsm-report.o
 obj-$(CONFIG_EFI_SECRET)	+= efi_secret/
 obj-$(CONFIG_SEV_GUEST)		+= sev-guest/
 obj-$(CONFIG_INTEL_TDX_GUEST)	+= tdx-guest/
diff --git a/include/linux/tsm.h b/include/linux/tsm-report.h
similarity index 92%
rename from include/linux/tsm.h
rename to include/linux/tsm-report.h
index 11b0c525be30..4d815358790b 100644
--- a/include/linux/tsm.h
+++ b/include/linux/tsm-report.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __TSM_H
-#define __TSM_H
+#ifndef __TSM_REPORT_H
+#define __TSM_REPORT_H
 
 #include <linux/sizes.h>
 #include <linux/types.h>
@@ -88,7 +88,7 @@ enum tsm_bin_attr_index {
 };
 
 /**
- * struct tsm_ops - attributes and operations for tsm instances
+ * struct tsm_report_ops - attributes and operations for tsm instances
  * @name: tsm id reflected in /sys/kernel/config/tsm/report/$report/provider
  * @privlevel_floor: convey base privlevel for nested scenarios
  * @report_new: Populate @report with the report blob and auxblob
@@ -99,7 +99,7 @@ enum tsm_bin_attr_index {
  * Implementation specific ops, only one is expected to be registered at
  * a time i.e. only one of "sev-guest", "tdx-guest", etc.
  */
-struct tsm_ops {
+struct tsm_report_ops {
 	const char *name;
 	unsigned int privlevel_floor;
 	int (*report_new)(struct tsm_report *report, void *data);
@@ -107,6 +107,7 @@ struct tsm_ops {
 	bool (*report_bin_attr_visible)(int n);
 };
 
-int tsm_register(const struct tsm_ops *ops, void *priv);
-int tsm_unregister(const struct tsm_ops *ops);
-#endif /* __TSM_H */
+int tsm_register(const struct tsm_report_ops *ops, void *priv);
+int tsm_unregister(const struct tsm_report_ops *ops);
+#endif /* __TSM_REPORT_H */
+
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 6fc7884ea0a1..ecc6176633be 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -16,7 +16,7 @@
 #include <linux/miscdevice.h>
 #include <linux/set_memory.h>
 #include <linux/fs.h>
-#include <linux/tsm.h>
+#include <linux/tsm-report.h>
 #include <crypto/aead.h>
 #include <linux/scatterlist.h>
 #include <linux/psp-sev.h>
@@ -1068,7 +1068,7 @@ static bool sev_report_bin_attr_visible(int n)
 	return false;
 }
 
-static struct tsm_ops sev_tsm_ops = {
+static struct tsm_report_ops sev_tsm_report_ops = {
 	.name = KBUILD_MODNAME,
 	.report_new = sev_report_new,
 	.report_attr_visible = sev_report_attr_visible,
@@ -1077,7 +1077,7 @@ static struct tsm_ops sev_tsm_ops = {
 
 static void unregister_sev_tsm(void *data)
 {
-	tsm_unregister(&sev_tsm_ops);
+	tsm_unregister(&sev_tsm_report_ops);
 }
 
 static int __init sev_guest_probe(struct platform_device *pdev)
@@ -1158,9 +1158,9 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	snp_dev->input.data_gpa = __pa(snp_dev->certs_data);
 
 	/* Set the privlevel_floor attribute based on the vmpck_id */
-	sev_tsm_ops.privlevel_floor = vmpck_id;
+	sev_tsm_report_ops.privlevel_floor = vmpck_id;
 
-	ret = tsm_register(&sev_tsm_ops, snp_dev);
+	ret = tsm_register(&sev_tsm_report_ops, snp_dev);
 	if (ret)
 		goto e_free_cert_data;
 
diff --git a/drivers/virt/coco/tdx-guest/tdx-guest.c b/drivers/virt/coco/tdx-guest/tdx-guest.c
index 2acba56ad42e..221d8b074301 100644
--- a/drivers/virt/coco/tdx-guest/tdx-guest.c
+++ b/drivers/virt/coco/tdx-guest/tdx-guest.c
@@ -15,7 +15,7 @@
 #include <linux/set_memory.h>
 #include <linux/io.h>
 #include <linux/delay.h>
-#include <linux/tsm.h>
+#include <linux/tsm-report.h>
 #include <linux/sizes.h>
 
 #include <uapi/linux/tdx-guest.h>
@@ -300,7 +300,7 @@ static const struct x86_cpu_id tdx_guest_ids[] = {
 };
 MODULE_DEVICE_TABLE(x86cpu, tdx_guest_ids);
 
-static const struct tsm_ops tdx_tsm_ops = {
+static const struct tsm_report_ops tdx_tsm_report_ops = {
 	.name = KBUILD_MODNAME,
 	.report_new = tdx_report_new,
 	.report_attr_visible = tdx_report_attr_visible,
@@ -325,7 +325,7 @@ static int __init tdx_guest_init(void)
 		goto free_misc;
 	}
 
-	ret = tsm_register(&tdx_tsm_ops, NULL);
+	ret = tsm_register(&tdx_tsm_report_ops, NULL);
 	if (ret)
 		goto free_quote;
 
@@ -342,7 +342,7 @@ module_init(tdx_guest_init);
 
 static void __exit tdx_guest_exit(void)
 {
-	tsm_unregister(&tdx_tsm_ops);
+	tsm_unregister(&tdx_tsm_report_ops);
 	free_quote_buf(quote_data);
 	misc_deregister(&tdx_misc_dev);
 }
diff --git a/drivers/virt/coco/tsm.c b/drivers/virt/coco/tsm-report.c
similarity index 98%
rename from drivers/virt/coco/tsm.c
rename to drivers/virt/coco/tsm-report.c
index 9432d4e303f1..753ba2477f52 100644
--- a/drivers/virt/coco/tsm.c
+++ b/drivers/virt/coco/tsm-report.c
@@ -3,7 +3,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <linux/tsm.h>
+#include <linux/tsm-report.h>
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/rwsem.h>
@@ -13,7 +13,7 @@
 #include <linux/configfs.h>
 
 static struct tsm_provider {
-	const struct tsm_ops *ops;
+	const struct tsm_report_ops *ops;
 	void *data;
 } provider;
 static DECLARE_RWSEM(tsm_rwsem);
@@ -272,7 +272,7 @@ static ssize_t tsm_report_read(struct tsm_report *report, void *buf,
 			       size_t count, enum tsm_data_select select)
 {
 	struct tsm_report_state *state = to_state(report);
-	const struct tsm_ops *ops;
+	const struct tsm_report_ops *ops;
 	ssize_t rc;
 
 	/* try to read from the existing report if present and valid... */
@@ -448,9 +448,9 @@ static struct configfs_subsystem tsm_configfs = {
 	.su_mutex = __MUTEX_INITIALIZER(tsm_configfs.su_mutex),
 };
 
-int tsm_register(const struct tsm_ops *ops, void *priv)
+int tsm_register(const struct tsm_report_ops *ops, void *priv)
 {
-	const struct tsm_ops *conflict;
+	const struct tsm_report_ops *conflict;
 
 	guard(rwsem_write)(&tsm_rwsem);
 	conflict = provider.ops;
@@ -465,7 +465,7 @@ int tsm_register(const struct tsm_ops *ops, void *priv)
 }
 EXPORT_SYMBOL_GPL(tsm_register);
 
-int tsm_unregister(const struct tsm_ops *ops)
+int tsm_unregister(const struct tsm_report_ops *ops)
 {
 	guard(rwsem_write)(&tsm_rwsem);
 	if (ops != provider.ops)
diff --git a/MAINTAINERS b/MAINTAINERS
index fcd91e4c5665..5169b13b2e55 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -23256,8 +23256,8 @@ M:	Dan Williams <dan.j.williams@intel.com>
 L:	linux-coco@lists.linux.dev
 S:	Maintained
 F:	Documentation/ABI/testing/configfs-tsm
-F:	drivers/virt/coco/tsm.c
-F:	include/linux/tsm.h
+F:	drivers/virt/coco/tsm-report.c
+F:	include/linux/tsm-report.h
 
 TRUSTED SERVICES TEE DRIVER
 M:	Balint Dobszay <balint.dobszay@arm.com>
-- 
2.45.2


