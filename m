Return-Path: <kvm+bounces-37163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F20BA26635
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 22:57:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B8789164D73
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 21:56:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7136C211292;
	Mon,  3 Feb 2025 21:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="EMFNsL3c"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2066.outbound.protection.outlook.com [40.107.243.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA7320F07C;
	Mon,  3 Feb 2025 21:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738619799; cv=fail; b=eYBRLK8v/IpgXEiPOURdmZrvYY/1WqBg+FOYiDjDIDDmtmIagfo+oQocXEIHbKkKu4tQMokMCWTre/sCuq6UbQjmlCm2kbOLZv97aqgB2noEjGrsVg+vAJeXpSbg3Hx21Ib6V1BHIaP1PejtifN03se/raqvNbt2XPkGrVzlWII=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738619799; c=relaxed/simple;
	bh=IN3j3lG5fHn7z+BQB1kUUA9bCgxBei41bmpthlePhB8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JFUkLQ8U2YpNCNwFJRRXXdCAYtrDIxSHvQ/uZt1e2s0fE1sCw8K0+MZurL8A9rFTARYFG1i8uGn/8+bswcmz0QDrbWQxDqLJCX1x+dJNQP67/mZhKxLdqXZZapwtofBUwsbIdgC+a+t1/qZ4G9W3b0YUMscLbka+kYYXOFs9+gY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=EMFNsL3c; arc=fail smtp.client-ip=40.107.243.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BGdaGm1QtJSN/Ckva0r4fIQf0amDceejx88+50Nqw9E0gf7A8xh2vGCUgTmh/yj4UbowfWHzdJHuuv5BCkF/9Ce2/q0cJ4zFH/etj4Zf7pO/fZy+Mn4yySTyVqvjTbLwIgDxHSXFmm2/dwo5aRTZW5AI/l9LkLNR1drgrAIBJapohFVnZSlhIctcYdLuZCIOIp2px8SVcqAcEUgX0mlvWJ8R+C8FTVMKMhrkkeLSgXp51IttuujL7Ky4yfvy/zSJypYcv225d4IjqKu/a2LD0BqGhw7orovW9VfgzxY6ohlB8W41AlAjhThd/c2LoYIwpd2VIOlO8UJ/Xy6rXTqV+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vWwO4jA2v5JVx6PjIOvO2ESrWhKsgmFmobTwuNzzSV8=;
 b=hczZWAMfiA7Jnvx5YBzng9mATOelo1+XCRACSvVRmN9V3BOmjp2aBz3unk9AdGPtlPciX9/rEveFm6yN1ihyYXKwrEaRnsZPWEdZ5ockDZWgCsQsNv4nKU90jChjmvccVmRjcY7OujQmUMTrZuYl8JAdLYhECElywJ5Pz5hN6AKBv452hcwaaH9r73S4fWHQYd4mwXxzm3UNYOZWzP2ZFnxxpbUMRxRGsmqhTyVJnIAxliI7YKhEuO8u9cJ+V1Ho8lLcZ3o4/WmHdVAO1ZfWvn/JXPFR+RNUZvQ9vkj8Af9tsVbht1ihrdasi/Cr6Zl7LI8hTchCkWL47oAZqkK4Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vWwO4jA2v5JVx6PjIOvO2ESrWhKsgmFmobTwuNzzSV8=;
 b=EMFNsL3cOhL4gwSukH2jfG2V4u3831Th4fsTgKhr6CIRyaxBbhBAM+yNwFuVCI4xCx87FHlI40DDu01YFC2jULWE4nTDl7IpatNsIOSuijMT6aELkEoxoDHSa2rUt4aZLEqXWrn2BgIUFlRRks3be5y/Yxnqo5IaIF4/qXIlCrk=
Received: from SA0PR11CA0139.namprd11.prod.outlook.com (2603:10b6:806:131::24)
 by IA0PR12MB8894.namprd12.prod.outlook.com (2603:10b6:208:483::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.24; Mon, 3 Feb
 2025 21:56:33 +0000
Received: from SN1PEPF0002BA52.namprd03.prod.outlook.com
 (2603:10b6:806:131:cafe::87) by SA0PR11CA0139.outlook.office365.com
 (2603:10b6:806:131::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.25 via Frontend Transport; Mon,
 3 Feb 2025 21:56:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA52.mail.protection.outlook.com (10.167.242.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8398.14 via Frontend Transport; Mon, 3 Feb 2025 21:56:33 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 3 Feb
 2025 15:56:32 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<joro@8bytes.org>, <suravee.suthikulpanit@amd.com>, <will@kernel.org>,
	<robin.murphy@arm.com>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <nikunj@amd.com>,
	<ardb@kernel.org>, <kevinloughlin@google.com>, <Neeraj.Upadhyay@amd.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<iommu@lists.linux.dev>
Subject: [PATCH v3 1/3] crypto: ccp: Add external API interface for PSP module initialization
Date: Mon, 3 Feb 2025 21:56:23 +0000
Message-ID: <02f6935e6156df959d0542899c5e1a12d65d2b61.1738618801.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1738618801.git.ashish.kalra@amd.com>
References: <cover.1738618801.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA52:EE_|IA0PR12MB8894:EE_
X-MS-Office365-Filtering-Correlation-Id: 990fb8df-d3ef-4ba4-0f02-08dd449d9fa1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026|7416014|7053199007|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+GyKD4jUQ8ZIhjMW22uV2JBHZkBJ0L3gSqYeoUym2KGR5rT13qYerAU03nM0?=
 =?us-ascii?Q?OTi3XkeuR8El51U2e8c5nddEnOUmY6Z2JxVptX8w8y8lHJZShmio3lQR2pkj?=
 =?us-ascii?Q?NVESn1D3EmhpnDdSY8eEwOYLcs3b2LMmQ8e0RUpwBvyQTe6btzDRfNLqf0WS?=
 =?us-ascii?Q?BtY6PAqaHKr4shixyOpWXdd1b6/E0YLjHO+zhF3V82zAEGPh23T6HLh1Zla2?=
 =?us-ascii?Q?GcAX8lDb40Yo3amKZg52wKkjC534aat0y4DgwkyYFjPFXEBA9twDfRflQAds?=
 =?us-ascii?Q?OhBgSJYPeS8PXkspr8ChrIu+ZWXF/x2F3zCMhYiak4laQFA+Z/aOYTwu/Ixq?=
 =?us-ascii?Q?j7Z+E9vzkZ/LUAgjNL3kKn9ndAuvUNIkwJDlTq95VpUvVQAF+0AS9nzn+2Eb?=
 =?us-ascii?Q?BB7Qu/MLOTtABuCHFNsCONyagRMEJCQ75BPIQlmDtHaCxsjbjhBEaw+IaI8J?=
 =?us-ascii?Q?QYDQnk7ACcFbUQhpnknt9LCa3NTmtA9Fkcn+ysxWChnDjJsvlHHCm9R53ccQ?=
 =?us-ascii?Q?doFink5hv2KiPGfIaFJ/627EseV48cmt1tdTyVplgElIP1LmvwvwktuAzK99?=
 =?us-ascii?Q?y+AFlw2hecRF1pIzARPMvZXQI8L5f0gAe+x6Mk7+8KaWBb2sJHVu915rioQV?=
 =?us-ascii?Q?K1bJSinNSw+GFWanloRcPcx/276BrNBnR+q63rKQzKW8MWFui8TTsmkxW9cV?=
 =?us-ascii?Q?Q43bPEUY9o7ACseKC2bILQIB89haEqI8FHCT1PVVvnLVkngmZ6i9AMEnnnCm?=
 =?us-ascii?Q?3IQDExKXFZurJxqKf+hLQ5iGdjwe6JTaWAB5udxtMmRoGj6iOE61ZZ3IyR5U?=
 =?us-ascii?Q?PWSpNHqP/A91y2unSsNe8phSpdPy34kFx/1qeec7arCdW8Fn5XB4NAQC6M/0?=
 =?us-ascii?Q?LUr1kBj7iWBEcGJ/2oSFiaze5bpw27iKXHwWFzUlJPdFjiQ70ZXIHtgsubQs?=
 =?us-ascii?Q?p+F3Fl+POhE2Wk35iJ111QiPnSNrntE5J7fTWM0zsy5WfUYFMgFtsigGlnES?=
 =?us-ascii?Q?1jXSm75PIg21ZF8o+QsnSgROYIylzXRcI5iub+1dbMNakg9kVyKxnPvtECZG?=
 =?us-ascii?Q?V4KRkN1py9KnPijducHZ0OuvgiaeT2bDrg2tOzOXI1XgKUlPdtTMI+PRwl1F?=
 =?us-ascii?Q?j3edohI0AZe8ZBJBEgJAvCHiYwoLlQqnJtVMiv37o+WdicP+ZS4Vrovn56Cl?=
 =?us-ascii?Q?4urWX7kmjAMS1E4nr5TflTELgWqv7Wfg2w/qlIcZbIUHBRzS98J99hyBp06m?=
 =?us-ascii?Q?00z689efGuCUsjPtNXSCSI6f1lu/VmIMZ+Xa07yKpi59lZpesD+UcTT2wxov?=
 =?us-ascii?Q?x+eC1quR9W/d2HG4zp4Z2pC0GLMYY9fX4/6Eer6RJAiQxVfcnXnwHXXSSJGx?=
 =?us-ascii?Q?61DA+IGxjkCpaWfhXJwWH1YkTr8o83ZTqjpk0y0ZfQucKqPnKdKTEG6V0oRW?=
 =?us-ascii?Q?TOZYZyOXaIbJfefBfMOXRyfDcLqIaZFZa3NmNHPCPEjYgwXRIo1J1px1gOEw?=
 =?us-ascii?Q?iEJ935rtS+TKWD5xbMXlYZ9tvSUYosgQH7QP?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026)(7416014)(7053199007)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2025 21:56:33.4383
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 990fb8df-d3ef-4ba4-0f02-08dd449d9fa1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA52.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8894

From: Sean Christopherson <seanjc@google.com>

KVM is dependent on the PSP SEV driver and PSP SEV driver needs to be
loaded before KVM module. In case of module loading any dependent
modules are automatically loaded but in case of built-in modules there
is no inherent mechanism available to specify dependencies between
modules and ensure that any dependent modules are loaded implicitly.

Add a new external API interface for PSP module initialization which
allows PSP SEV driver to be loaded explicitly if KVM is built-in.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sp-dev.c | 14 ++++++++++++++
 include/linux/psp-sev.h     |  9 +++++++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/crypto/ccp/sp-dev.c b/drivers/crypto/ccp/sp-dev.c
index 7eb3e4668286..3467f6db4f50 100644
--- a/drivers/crypto/ccp/sp-dev.c
+++ b/drivers/crypto/ccp/sp-dev.c
@@ -19,6 +19,7 @@
 #include <linux/types.h>
 #include <linux/ccp.h>
 
+#include "sev-dev.h"
 #include "ccp-dev.h"
 #include "sp-dev.h"
 
@@ -253,8 +254,12 @@ struct sp_device *sp_get_psp_master_device(void)
 static int __init sp_mod_init(void)
 {
 #ifdef CONFIG_X86
+	static bool initialized;
 	int ret;
 
+	if (initialized)
+		return 0;
+
 	ret = sp_pci_init();
 	if (ret)
 		return ret;
@@ -263,6 +268,8 @@ static int __init sp_mod_init(void)
 	psp_pci_init();
 #endif
 
+	initialized = true;
+
 	return 0;
 #endif
 
@@ -279,6 +286,13 @@ static int __init sp_mod_init(void)
 	return -ENODEV;
 }
 
+#if IS_BUILTIN(CONFIG_KVM_AMD) && IS_ENABLED(CONFIG_KVM_AMD_SEV)
+int __init sev_module_init(void)
+{
+	return sp_mod_init();
+}
+#endif
+
 static void __exit sp_mod_exit(void)
 {
 #ifdef CONFIG_X86
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 903ddfea8585..f3cad182d4ef 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -814,6 +814,15 @@ struct sev_data_snp_commit {
 
 #ifdef CONFIG_CRYPTO_DEV_SP_PSP
 
+/**
+ * sev_module_init - perform PSP SEV module initialization
+ *
+ * Returns:
+ * 0 if the PSP module is successfully initialized
+ * negative value if the PSP module initialization fails
+ */
+int sev_module_init(void);
+
 /**
  * sev_platform_init - perform SEV INIT command
  *
-- 
2.34.1


