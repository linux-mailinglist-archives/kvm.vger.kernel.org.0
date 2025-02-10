Return-Path: <kvm+bounces-37756-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EAAEA2FDD4
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 23:54:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7A8C21884A50
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 22:54:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B2D325A2B6;
	Mon, 10 Feb 2025 22:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="x6Gn30Ek"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2049.outbound.protection.outlook.com [40.107.102.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE381C2DA2;
	Mon, 10 Feb 2025 22:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739228043; cv=fail; b=p1qk2SluHbjTccv8s0ITvXqMS+1mRLxyoAWqPXFZUYiCMHXF/XBtqYJKzrDkH6p7Eiyws7MXHeS5qA8un122U7vn3bfrLXrs1LkQwgn8K4pfhAarl5FLYrmWkMys9YrydDMuHjrUa2ZSwJ/uC0AKTl01ogYytYPkOOshk51rteg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739228043; c=relaxed/simple;
	bh=ag9hFVOs4ELf5qMSb5aQTrktwO+bPMilaDEJ7Sfu0qM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uc2h2Kq/wAQloJPgbuRvYdfRxdfml/zkjAwxo508UPVEGWl4gKN11oRPOOFXfu+ARwDSwPusqOedwHBe+3ZnoIpNkoo9RE49DSi2fvRzMF4s4Csm+FwhEHVvBKuAdFyglCmYsWKYHvLSGnIdSxYc9TD6w8KIljvIEZaj4QFe240=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=x6Gn30Ek; arc=fail smtp.client-ip=40.107.102.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q+epzML2I6ZgfFip8iyXKXtVtalO/auXDD1mW4PM/kkO21zZ9E0H1EvL5OZDBxJoKd4Fm2T/bhLmZVjPkuaxaq5FHN+X/F14uZfeOm/t1QZ9WyMBheq2sT0+4t37fjrnuzSYzr9FGfIlpJM89DZj0PXvF/4rtgfklfaKsAE7eI4bYTlrV06GvOIuutVuSgQYQOND4qcfMboyqeAOX9zu2b8qe02vhT0u0k86ciajMS+Neufk3/yF6QHf4H2f9OoV47yfeSSmEQvtVhDSNKhfLJLaBkKaqjC3+e8Z9kXLpub6+UyYS0KOePIEa5pgK69ze1n44J+LYk3xrdyaPuNHAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gkavCmER79T3NwFcNumsMvu5Ix1y+kVl/Yh2RdfMltE=;
 b=wkcxAOXobNnZLhIihjoHcGmbDQntdmbnjALOCND5TyuGyvLmMirNt6o6CtMy6RKpqDDgi/9oJAsAqCdOg8YRSUcLAWHztGVhH1YYgjIzFlsYAozq6+cwm9pEevVLhgmU0Doyg5BhhCPtIwF2pqTausG347QuSiqsyIFVlqMrbAqlinUbew0A0j9HsKMsFJw8Widf1XJ3QR/yPHZ1ozTfckohu96l6l7q4syVBlcD79ZmvqFzxlMTD4arXieEgFJkzJ6yhy9zxcsP4j2SaBM9sEtUZXv65EtgElNMd/q7Xl5cH+Grups1XkL2/R3BKet/orzyCvnC24qsRiROA10n7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gkavCmER79T3NwFcNumsMvu5Ix1y+kVl/Yh2RdfMltE=;
 b=x6Gn30EkxKl9Mg6pq1h2Fkc+3afBHFp7CW24NSsF3BZLNNHHtHkb/JufePiePaEQP9wcwpn2muLeTRnW34P/7IUaFwLoyXDXfUASute4JQIZJBVEDaowBz/fT5l8s5oi3AEAYUtjMInGkDIcSuelljzs5MXJYIIGpWVPI7NBTJ0=
Received: from BL1PR13CA0151.namprd13.prod.outlook.com (2603:10b6:208:2bd::6)
 by MN0PR12MB5857.namprd12.prod.outlook.com (2603:10b6:208:378::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.18; Mon, 10 Feb
 2025 22:53:57 +0000
Received: from BL6PEPF0001AB52.namprd02.prod.outlook.com
 (2603:10b6:208:2bd:cafe::b1) by BL1PR13CA0151.outlook.office365.com
 (2603:10b6:208:2bd::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8445.10 via Frontend Transport; Mon,
 10 Feb 2025 22:53:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB52.mail.protection.outlook.com (10.167.241.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8445.10 via Frontend Transport; Mon, 10 Feb 2025 22:53:57 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 10 Feb
 2025 16:53:56 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<joro@8bytes.org>, <suravee.suthikulpanit@amd.com>, <will@kernel.org>,
	<robin.murphy@arm.com>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <nikunj@amd.com>,
	<ardb@kernel.org>, <kevinloughlin@google.com>, <Neeraj.Upadhyay@amd.com>,
	<vasant.hegde@amd.com>, <Stable@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <iommu@lists.linux.dev>
Subject: [PATCH v4 1/3] crypto: ccp: Add external API interface for PSP module initialization
Date: Mon, 10 Feb 2025 22:53:47 +0000
Message-ID: <15279ca0cad56a07cf12834ec544310f85ff5edc.1739226950.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1739226950.git.ashish.kalra@amd.com>
References: <cover.1739226950.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB52:EE_|MN0PR12MB5857:EE_
X-MS-Office365-Filtering-Correlation-Id: da467622-6a76-4ab2-ff09-08dd4a25cd6c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|36860700013|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PekXw8Y36j1xbrn9r3VOHL58x+UGBgvfHF4xT91yUNds5OYQanwxgnswbQtf?=
 =?us-ascii?Q?douFhIiFkU5KPdS4RZirFiykVMlINpEyjV1ubtzgUnnP2Wk9ZWnjlZj+33AT?=
 =?us-ascii?Q?eukRbXeZy4iwfTsnB7rRDTMCuFFcdcI9D8/A6RKpSMnZkDqt+uoGFj/36ipJ?=
 =?us-ascii?Q?qOMRLHK5k15wHHuwrLJJBm9yW8s0Eleeb2cde2YNXLRj9H2ZqQxCixqv/ycu?=
 =?us-ascii?Q?pJWsI0BBu2BKPP7HdsGyB0gSuuUmWcL/HoMFj+BglFnzDseiRQANHb2kzpmi?=
 =?us-ascii?Q?d4Ijwix94voSz31g6lSKr6vD+5RRTGpqqigVO1hZBW/qMDDmKAHf7PX+CS4O?=
 =?us-ascii?Q?Zxtd590r906slzwJMoJZ4+5+yZg6LnvM0ykiIhA6300G4ZAwXUYWLABHnod+?=
 =?us-ascii?Q?bBT8TtJZ0dCD2eK75tu57Zpyc9ok0BcB9WJc6F4c+1FaKBouhg2C2DZwlL6L?=
 =?us-ascii?Q?U2KwN5/u+vHwzW3neuzvJNi0WFNGhnn4PBDaw4WeDvmUYrip7lo9kXfqzLmf?=
 =?us-ascii?Q?AMeRMIw4Os5KzhLR7pw6cgxnu7CA+iFKKoqApcQwJAY2+zFVDaIzyKhpTrXa?=
 =?us-ascii?Q?AXVFKMiW8iJrRb5P4BzHEhqkXIHOIC4sxLMkU5O+rTAUGuSBtdI6YNsekHt9?=
 =?us-ascii?Q?RFC2cGm1J5Sy244/fcxm4H1c0GQQ9mPMiZshbLGgGkUUmF3JWjLNh9+3Ks9L?=
 =?us-ascii?Q?f/dOHcl9Zp3DdGFu6mR5RwB4xFalPhIU59KIkJcbBVTu2VfxWscw6HKgxlD0?=
 =?us-ascii?Q?9FIKd52jetio6d7qGpa5GaylZ90M80iBZDcypGWIwH0OJwTVDJZH5CYta8Kz?=
 =?us-ascii?Q?tKIYQgftwkMSC2Bsj8sXx13jvPnoMhMW0M4ZUUtp7nHSAq0IVe8V+9dZWfTy?=
 =?us-ascii?Q?gcSbnpO/Dro/8Wo5ceOQmbUAzOPJI40H8+rmf36AF/Zus3l0cHxf0LgLRzou?=
 =?us-ascii?Q?LIC928PgiYRG5AYqj/JFmuDEY8E0K7TRZdoDOZs99M/jeGR3EMwbxdAysZpo?=
 =?us-ascii?Q?tuT0PG8TKbLPD+M4GoQpwIYLrbetsTlMqWPS5ByzPRoBsSnyy2dEVD8jThXf?=
 =?us-ascii?Q?ow4HWIJ+PafbKdqc7gLc6rOroth9C61Xs7s8O+OqmvRsnNzMYzAk9qvn3vXY?=
 =?us-ascii?Q?p38FPAIdFf6RdIMS+/rycF6iOClzpLdQ7F7xK0HNRAJjCk+f84K7n6gNf9HJ?=
 =?us-ascii?Q?HzyHQYZmObA++ZLsrMumqnw1mMX5AuaDCSLqjRpD5RBCNyb/3AZ+vQtZ/c9k?=
 =?us-ascii?Q?9wMzhGW3C9ofm9kksOCOZp/1osuZvQjyK22ogbfT8XmjMse8vsoZZN8mEwIF?=
 =?us-ascii?Q?In6XKC/TJelOBn8RJx+ggEeXSfsCyH+hyYT5nhwaqJxtRjmeTwsuFLkHyxQS?=
 =?us-ascii?Q?eNuWPaScpmZeKain3wLWfMIHcBGCa+/ynI0e7KDCpbKDEjEhEgEqS0MIDr98?=
 =?us-ascii?Q?QSobtVculTaLA7DdUn+ADGmkCwWZ/7LyTLp5r+CPbOjNyMfVWfloU6sjxMRZ?=
 =?us-ascii?Q?APBRIANYpMsi1ZMAVvo/QoC7nUXoZ1m2ZflF?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(36860700013)(921020)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2025 22:53:57.6571
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: da467622-6a76-4ab2-ff09-08dd4a25cd6c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB52.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5857

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
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
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


