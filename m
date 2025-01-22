Return-Path: <kvm+bounces-36202-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F022BA1893F
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 02:00:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A18563A67B8
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 01:00:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A97C38FA6;
	Wed, 22 Jan 2025 01:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tPUS4XPm"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2067.outbound.protection.outlook.com [40.107.223.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1042837A;
	Wed, 22 Jan 2025 01:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737507645; cv=fail; b=F1T7PqnFlaJsKwmHNYLlr7PK5r3P0dbUZu15OGciKYk+NYC9V3cvYKLyLtamicKfktz0TIbLabM+aPo3FSzAIQY5rJb1HQQaTLsYo9jMTjoc64kDszKVNsq2aj4lc7mQOdyBdmD/IlAPkRwcwVgng/DHNBscUqy9uV1uTqhPlLo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737507645; c=relaxed/simple;
	bh=uXsFTuES+8ingRjtHVEoJ3pUaV+TENZ1V8HMOODdOt8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t9CeSVOuYab2YatdKitszswvB9JqLabJ6g/wAIyu0CMXgetRp08GWLMCzXPDOU0t8n2SenSpdb8w10S6w6zTCVpsaV6/4octFn4hN2fyFhhyycsYohmu211Q0jH67Qe2j1Dvr5lm9edmX/kE/eOuUn3dc650hiB0YWiMnBXqzSE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tPUS4XPm; arc=fail smtp.client-ip=40.107.223.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i+For89ixYXGXAHwvePcVVwSlyIwnSO7Z/rd7dgAI8fgsjUMfKLQXCNDK7C3RWCktgaB1PRzprJLpgoLAxc728aoCh9VDIDUsU5amWHpzaDw3qyzAtw3/QxfclSMmdvojth4tLI82fFDKEeN/ejLMrpVrv80NrZa+dU0yF9Rap7IevWNW9Pn4bxahc4geqVg763mKb986bA//Y03pxz808KgxSv9VzZPPq9Fb5fshlkOAt0LRIu6jAbz/3/w6/lroWmM2CyQJVRDsLUMSId9F7jQ0Zat7L/GjS0cnSHzn1LrL9DyeFcPcwjBIsgL8zeealLItj/wB9nxEd6QNiRJxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ffeobm4egWo4WTBHI/ac6X+oNEaZXhObhnrlY3MAKtk=;
 b=Ir7lHZ0hVVJoz7apQ8sUzvmqEqWgvmecV30jLvv2MlkKCsXB15knDzKTM+qQbJFkARSQfBGv6BlAOsjY2QV0QHhBwuR6Z8vuHnT/qne6mw0RGAqm9kwCjHW6l+deU7WC+Y0AlCu+x/UdRFN+lhcanhek+OM2Fi5TOFw9tRCdBMA55v4JUgN84z/ur8umVrAd7lIxJfwqnhLqFjZW7yjqExw6+Vdi7qVDxVfNZ90NhtE0j2p3I1y5MdB6UiOOcYKDwXd9/DJrh8E6sh9aRFhqhQB/4Lhzcep1jERUyNFmrCBieky4ElX9y88jrUS/qC518BDpBMjF1pT4oLXYFztdSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ffeobm4egWo4WTBHI/ac6X+oNEaZXhObhnrlY3MAKtk=;
 b=tPUS4XPmCOVC36zBOtbqlkaacqqruyw1kHuN8OmVv+Yc3MdUS+JVCBNQXQ9F2iYx1Y5bpBgHHxDzs0OWLLW0s2ziZ8W2AecTihbzea5DbiFYskF9bms2nYfHx+ODfnP/b1JmbPHIeJlRbx3J1+Vg8MrONj/uLXDl0v6GvAZQro8=
Received: from SJ0PR05CA0099.namprd05.prod.outlook.com (2603:10b6:a03:334::14)
 by DM6PR12MB4042.namprd12.prod.outlook.com (2603:10b6:5:215::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.22; Wed, 22 Jan
 2025 01:00:35 +0000
Received: from SJ5PEPF000001F2.namprd05.prod.outlook.com
 (2603:10b6:a03:334:cafe::1a) by SJ0PR05CA0099.outlook.office365.com
 (2603:10b6:a03:334::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.13 via Frontend Transport; Wed,
 22 Jan 2025 01:00:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001F2.mail.protection.outlook.com (10.167.242.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8377.8 via Frontend Transport; Wed, 22 Jan 2025 01:00:35 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 21 Jan
 2025 19:00:33 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<joro@8bytes.org>, <suravee.suthikulpanit@amd.com>, <will@kernel.org>,
	<robin.murphy@arm.com>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <vasant.hegde@amd.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<iommu@lists.linux.dev>
Subject: [PATCH 2/4] crypto: ccp: Add external API interface for PSP module initialization
Date: Wed, 22 Jan 2025 01:00:22 +0000
Message-ID: <2a2c2b55c2b137b777ef5beab8e2a814f0c268a7.1737505394.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1737505394.git.ashish.kalra@amd.com>
References: <cover.1737505394.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F2:EE_|DM6PR12MB4042:EE_
X-MS-Office365-Filtering-Correlation-Id: 784859f2-81b1-4eac-a3f5-08dd3a802dd3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|7416014|376014|7053199007|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?c8t+iIh3ruOG1+u4rQiYUvps8GspKg24fEHwuCqm1hYcIdFaGS7T4PuKbxi1?=
 =?us-ascii?Q?ktwDRl++v3mg3UKYpRIP+n06qH59ZYUM19M6p1qODYqtCE7aTCKDjyqMSlRG?=
 =?us-ascii?Q?n8kD9rweVpZifo1t/uWbdSt6v7J32bgGcDoW+F1vYAe6oWatGcuX5aPZ2rRh?=
 =?us-ascii?Q?9xBHlN6Q+5MCDZqqVZTp9fgaKvJzIVVX8BGN4ZcXEDJyep66whZPodXc8DRY?=
 =?us-ascii?Q?AjEkTym2TJBbvWJaCqONXFY4OopDfcK0aXrlzVRmV5vjB7ON+Br42tvAQHCI?=
 =?us-ascii?Q?/wQHImny/iMxNpRTXWNR4NDJAfryvaFnEC6eXMsyh4T1/JPwtiTv1F2gZ2cy?=
 =?us-ascii?Q?/Yk+sr+KDTNafALNnZ/e2/e6o/KHK23bmax6EgxCIuJ7YdCBBe6pL0Dl+q61?=
 =?us-ascii?Q?1fusg31wQwr1FKowgFwzdtvwkWh7hgsH6yjEbKi2m25lSqiVE4q1LY10xG12?=
 =?us-ascii?Q?IHxf3UET0Rz9OSsgLLkN6P8mMiUOCyrZC0bg+OYrnM96V3onNancCHB8Zno/?=
 =?us-ascii?Q?7b8M7R6tb0tEdkB+mRBEp9tWo0Z8bgQb6/E8D0kN7F8SWC+Y3+253SkJ19lv?=
 =?us-ascii?Q?f3kiIPxmr5TbfLyhqiWTS6GueFfBvA/NvXcmBx+ILdT1yyTQEUXA4SA0x4M5?=
 =?us-ascii?Q?FV6dhEs1uJEtmctBJt7PJ3dDZxvQs211cr6yjchFp/Kj751eeqOlqRafxWuU?=
 =?us-ascii?Q?7rJUJqsxAvB+bdJSy6cbqbP7ZIeSye7kZvqnr/KC18kTfaEWfIkCdhkubRpV?=
 =?us-ascii?Q?o0+K37DIGtgBynVpeyrKe/+JNyWOhEGbIUtrZmKUEriPh8o2MbAi6bcoPuBT?=
 =?us-ascii?Q?H5NKCEaeGCo6+qfenpUysGJ8QVwFIOslscgnYGvFBU/2+x8stHaWmAPwiR1l?=
 =?us-ascii?Q?nWOxXX4lKCLl5P9D0frI5JtKAmEgqVyPcmwl/EzfsbRXP36XAYgcs1ReQg04?=
 =?us-ascii?Q?jGs8PYVo9h1IkBLDDHtXkbBc917/uhR59P5Ajgbqjwa3lWuaNx/jjxw4yBV/?=
 =?us-ascii?Q?KoFzCtLyeZyg9m82qI2txe0l4CMQQzF+qpuu4zyowDVUQS8uGW5gyDRfcI/o?=
 =?us-ascii?Q?QPr5TmXz2/AClIBPtoC4qffDAXiEqfkK5aEP/BzkEWcyZ4E1iacq/eqUEFh7?=
 =?us-ascii?Q?anGa/0iRgwpoLif4JSjDWocGtX6bVgp8cWokjW2dxjGlDxPzglGJgvNyuAoq?=
 =?us-ascii?Q?ZIRPjNGPNIKoRpnT2mlOnApwq8q0XmIZ1R1oGMYhP8jtSBcxiVBk0cWvVdTd?=
 =?us-ascii?Q?2gkfe29dqziZd94MAmrLffqaYJ2I8MAvuX855mSzJfKEydYYaDYwz0ZjFOWT?=
 =?us-ascii?Q?7qt8GTTyOFJwK3HYASFqlCwCmUyUMgWTEdY2ECfBGE3LJJJTqCyJID15Kl5O?=
 =?us-ascii?Q?0xurpMA4oyybXAt4tastVJJLeP0fGaYQMoF1lhki6cn/ikCiKXiBklXszgKW?=
 =?us-ascii?Q?pJuESEHiR77HMJdUIADh2cdM9IW6vf28D+6tXiW3kQlI2EILYPfQHEis1o/h?=
 =?us-ascii?Q?JLqErT+DxUO8X1I=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(7416014)(376014)(7053199007)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2025 01:00:35.3829
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 784859f2-81b1-4eac-a3f5-08dd3a802dd3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4042

From: Sean Christopherson <seanjc@google.com>

Add a new external API interface for PSP module initialization which
allows PSP SEV driver to be initialized explicitly before proceeding
with SEV/SNP initialization with KVM if KVM is built-in as the
dependency between modules is not supported/handled by the initcall
infrastructure and the dependent PSP module is not implicitly loaded
before KVM module if KVM module is built-in.

Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/crypto/ccp/sp-dev.c | 12 ++++++++++++
 drivers/crypto/ccp/sp-dev.h |  1 +
 include/linux/psp-sev.h     | 11 +++++++++++
 3 files changed, 24 insertions(+)

diff --git a/drivers/crypto/ccp/sp-dev.c b/drivers/crypto/ccp/sp-dev.c
index 7eb3e4668286..a0cdc03984cb 100644
--- a/drivers/crypto/ccp/sp-dev.c
+++ b/drivers/crypto/ccp/sp-dev.c
@@ -253,8 +253,12 @@ struct sp_device *sp_get_psp_master_device(void)
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
@@ -263,6 +267,7 @@ static int __init sp_mod_init(void)
 	psp_pci_init();
 #endif
 
+	initialized = true;
 	return 0;
 #endif
 
@@ -279,6 +284,13 @@ static int __init sp_mod_init(void)
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
diff --git a/drivers/crypto/ccp/sp-dev.h b/drivers/crypto/ccp/sp-dev.h
index 6f9d7063257d..3f5f7491bec1 100644
--- a/drivers/crypto/ccp/sp-dev.h
+++ b/drivers/crypto/ccp/sp-dev.h
@@ -148,6 +148,7 @@ int sp_request_psp_irq(struct sp_device *sp, irq_handler_t handler,
 		       const char *name, void *data);
 void sp_free_psp_irq(struct sp_device *sp, void *data);
 struct sp_device *sp_get_psp_master_device(void);
+int __init sev_module_init(void);
 
 #ifdef CONFIG_CRYPTO_DEV_SP_CCP
 
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 903ddfea8585..1cf197fca93d 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -814,6 +814,15 @@ struct sev_data_snp_commit {
 
 #ifdef CONFIG_CRYPTO_DEV_SP_PSP
 
+/**
+ * sev_module_init - perform PSP module initialization
+ *
+ * Returns:
+ * 0 if the PSP module is successfully initialized
+ * -%ENODEV    if the PSP module initialization fails
+ */
+int __init sev_module_init(void);
+
 /**
  * sev_platform_init - perform SEV INIT command
  *
@@ -948,6 +957,8 @@ void snp_free_firmware_page(void *addr);
 
 #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
 
+static inline int __init sev_module_init(void) { return -ENODEV }
+
 static inline int
 sev_platform_status(struct sev_user_data_status *status, int *error) { return -ENODEV; }
 
-- 
2.34.1


