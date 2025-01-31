Return-Path: <kvm+bounces-36956-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AEE5A23880
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 02:11:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A5FC16864C
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 01:11:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7268D1DFE1;
	Fri, 31 Jan 2025 01:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vIVfk7oS"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2078.outbound.protection.outlook.com [40.107.102.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16307EED8;
	Fri, 31 Jan 2025 01:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738285860; cv=fail; b=LVxEvrd0OT2zXoMaaYFgS7vWpkvRoZizqjipKlXgaWjiGzi8f2ugmb5ytx30iI8FiOU22upPYHITTU/o06KhSyQOq5Xwetil8eakwL2w+V33TcekliaAzcHBcmhTtp5HXrUpLsN3pD7x/3uo1ntSD0FaZkoYAbFgGW8mCdBNujA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738285860; c=relaxed/simple;
	bh=IN3j3lG5fHn7z+BQB1kUUA9bCgxBei41bmpthlePhB8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pxNOBOU0X739RnT9dGdgMkBN2mP74VYS+dpetRnuXCYwzlPyeV13G/rLnHihZOR8HZRrCJDOqjTUuXTXU2jdL0hcyHbThIMak6JCAL9+DU1eKGUlkF2FdgxDwmRM35S/VF8MbgUd8EDzVwTngg8FVB6rCTsKTYM3LzbTu75ptTo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vIVfk7oS; arc=fail smtp.client-ip=40.107.102.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VYfT+rvMgdsXg3swH+HbPNQfEjlxfjX4Re7PrLT0mFJsqDVNfwTETY9TOlV23b17P+GIeN6FyFEbi/O8gKrLh1jvji30H/Co78S/E2F0e68faylHymolT7CaIGyUwo6lKERtCegYw+sM30A7DDY4EGdTlpNh3IcrKmbnNHGt8qIcpBLUuaob+atl+9QUYCEeirEcwEk7LOA4HPj+VAtHlLuUNAbPtZ8VhMnWcv131IlsSVKYW+PD4iPCvot1+g9BxV4UPmDw1tQtKqEWG3NpaASKXMK6VZ+LAWJr2d7CWkYMrsYSnz1qXgvRC5FIX2UqQ+n7lm7B1VhaZJPzf5cHPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vWwO4jA2v5JVx6PjIOvO2ESrWhKsgmFmobTwuNzzSV8=;
 b=mA2m9PYw2jjqG+j60lRVb6gl+2o/JmusIkn3xXC4kYyrqcMi9weL9L4aLnL31auwlescivUFYDrD8Jw8i9OM3ziWgR/VuiC/xa1K3mNCPBugPIacHmxFqXZRrgMZu2BUXu4mHMYLAgXxDmK2lfF/VLYy2QsMi5FBs9DTMV15EaYP3J16XJ+iZhCtipbFq6C8x8M2TTe0eM8n67XgDhnOhHZR3v4SOs2PrTzvtn9J80vJPOZnlZKZjoyTYbwnaC07bkOV6r5zuULuMxma/rFH0gWZP6CVmItGb3IDVPZzwni+Ulk0r3/drwA1Ai/byz09ch6qn2Dgzn3PUe3RqTm+FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vWwO4jA2v5JVx6PjIOvO2ESrWhKsgmFmobTwuNzzSV8=;
 b=vIVfk7oSKcBY5LmemOsV6bDcKLc70hQoi2/tpanEwQq+q1/xtKFuUWIrNT4XXd9vHcC/RWnzLWLo2iixVQa8wvFFN7cxbA/CZvvfwsmzXD3zezPfNyT9r/ShhD4rtkDNHgnxBvZ5OiBdTB7QpbBf30qZr+UQUjBA99cbn+ws/m4=
Received: from SJ0PR05CA0101.namprd05.prod.outlook.com (2603:10b6:a03:334::16)
 by PH7PR12MB6420.namprd12.prod.outlook.com (2603:10b6:510:1fc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.20; Fri, 31 Jan
 2025 01:10:54 +0000
Received: from SJ5PEPF000001CD.namprd05.prod.outlook.com
 (2603:10b6:a03:334:cafe::e8) by SJ0PR05CA0101.outlook.office365.com
 (2603:10b6:a03:334::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.13 via Frontend Transport; Fri,
 31 Jan 2025 01:10:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001CD.mail.protection.outlook.com (10.167.242.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8398.14 via Frontend Transport; Fri, 31 Jan 2025 01:10:54 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 30 Jan
 2025 19:10:53 -0600
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
Subject: [PATCH v2 1/4] crypto: ccp: Add external API interface for PSP module initialization
Date: Fri, 31 Jan 2025 01:10:44 +0000
Message-ID: <5f412ea77cb1940a185176b171d6eb6f9c2ac6ed.1738274758.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1738274758.git.ashish.kalra@amd.com>
References: <cover.1738274758.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CD:EE_|PH7PR12MB6420:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c92f20f-a7e1-4152-4534-08dd41941c93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|82310400026|1800799024|7053199007|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MuOhxkIYYPYfydrur3OiOgF5DaHCOSdQJ4hEDQ6CqII/p0bU4YC6EMTvJn2E?=
 =?us-ascii?Q?4zVGyU2y76hJZVRahlOaJInX0QP4s29ai1FQjC2RwjAeh6r+XbtUAG8XPPx9?=
 =?us-ascii?Q?U3r7sIteHG1kEL3Jb2xoicNQJAObYNGooYRMhttwoU+x3861tyzprKNlgX6m?=
 =?us-ascii?Q?MwnWiGVHsj6ctmQG7OA+9cNOAN/ELlD7e2LnkAiEAFrb1f1vWo+0Hw+DBJvU?=
 =?us-ascii?Q?kp+2Nrsx/SH1hYxfETDujEeHxCBDUF34IJe1OYJLonlCB0+Pn32LR7lJZA/o?=
 =?us-ascii?Q?WURfATZn53F5dt5HlOcBZsVyKZ7iFpsqP1mSdsyVp1bkkkkdupAG/e/mJxzn?=
 =?us-ascii?Q?2iyFieAwiekRBWOsv6D8QgiEjRMJ3uE1ZWqfzTYyXDhC8ND0xeY6XgQBBHhb?=
 =?us-ascii?Q?IIF3nClgzhEIVbg7uI0M5anxd4M+1irbhhujSEKpFgXzVMMnNJrBfVOc1YKr?=
 =?us-ascii?Q?PJvJtiERW/W1COPFXRDi9hcQfWXi4Ubu1gBEO7Ke1PJD6TC0uPUfBDnCsWJK?=
 =?us-ascii?Q?6NDNNFEPgeT/XiIpQv+b6uzD620tkXga0TTfMFMuGcFeW6f7SAY+inHW7XkS?=
 =?us-ascii?Q?ufgu7bUMMbppl/Wu8n3QBNcZx6KL2joYSyKJk7euIWO4rq4n1FopcvxAqAhZ?=
 =?us-ascii?Q?bGfOn+FxsK3XgVQrRsJs8Ljx0zIgfOS0dcaigWBhQEKaWmm41f0Ay0xa35LD?=
 =?us-ascii?Q?pnI7HYpCGaK5VJExjmUF1bl7nKvWmZAgB3wg1aaDQj7sPk/FtQse6W62EmFu?=
 =?us-ascii?Q?HaauTkIn4UJHYyFBmbvmAJZVQplcUBiGuVLBHJQ3O5OuNVGDbEx2tSV66zLz?=
 =?us-ascii?Q?Nh+5kZfY0ua6IqRiHnnC+lZy6Scv9ar1mVOXnsTxehBgNIzGelo39surdRw2?=
 =?us-ascii?Q?hp52yrWp9b7vsxXWVkn0zKBPJduL/2AUYwvC17P3x5jFFj22STmashUMtX66?=
 =?us-ascii?Q?e80/GYUm41TNItYiOZOc6rOPWrtCPrn3wgnhUrKRCmT1bvHX7edzBGmjGZUQ?=
 =?us-ascii?Q?lVUWmz0oQi+bucSBOrrPV6inlysyt6n+RaRRRYUCchXVqg3sJh0xH/Nw7FZF?=
 =?us-ascii?Q?WNDwrfnr5e5gRz+i8PwM8sMLT0Txt9m+v6BjuFRqZeF4eRqUe406PG/EGIeR?=
 =?us-ascii?Q?71eJXamtfCXScj/j0RxDJMIbpGDKjNYL+/QAxvxmbVchYBNBm8tm1DAZtoD8?=
 =?us-ascii?Q?JI5lfEm2E9WrJKhd/u0VDZf9A87CMBRLdsTWiyIzZZp2YS7akMOuNPPgS9ea?=
 =?us-ascii?Q?SgECUpzsRnWAeZI48kWUF8DJtv+y/2hrPoNhNC0vrBsrRutSk0E5vE4ZTOO2?=
 =?us-ascii?Q?B0B5/3YccQZeErKCDckK5fcb8+BzUKYSlVWooYMstUtQO8y48hPnyUAgNKuJ?=
 =?us-ascii?Q?0vcqm6qZd2PdxfJpcnmpcCcpDXATX7YzYJLhHicTwRcGqPUI23PvIO53QWfd?=
 =?us-ascii?Q?zAA8SDWNNH3632GjZxPcdTDsglpeBMbwsrCwmDUZMZJUNoR9Mxd1/QwOTjjw?=
 =?us-ascii?Q?pzslut3Kx2Sq+W8=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(82310400026)(1800799024)(7053199007)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2025 01:10:54.5294
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c92f20f-a7e1-4152-4534-08dd41941c93
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CD.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6420

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


