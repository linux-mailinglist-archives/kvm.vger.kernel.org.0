Return-Path: <kvm+bounces-41864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E7E75A6E572
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 22:18:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E1D3E18979A0
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 21:15:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7144A1D7E2F;
	Mon, 24 Mar 2025 21:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hQFSmaqH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2065.outbound.protection.outlook.com [40.107.243.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA4519007F;
	Mon, 24 Mar 2025 21:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742850923; cv=fail; b=eQpuL1Opr60rpBugPQOhP8qdUSNnWO3kRD6gl/wovteUYzEtvMM9V6VCMe8VI7nejd9S68KfQ3YAF12rseNtcuqVim9+f/8cKXQgL7/1L3Xkv4xrOHOgwPZqIWJWlUvLEyqcbDgV56YcOD5IIXhIJVVyiotJLIEmQ8JEG3hozV8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742850923; c=relaxed/simple;
	bh=2+Gl0E7T4TNASlzyyCu3MCRazEvBzjGW2+VNIxnkrD8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uSegefoqEWQACnhRMQCiw4O00oC0xPnIcsnQNVC+lqO3iu+BEX1J1Eq2573E6Svi3YevxWs4Y1EGuTJ1x5bQkGUfZp+BBEAPlqtiGkgmIywz7UlHFExOlKIWUpzBX7OB9kml+1YTK3uRS42N+SWQYiAIW5yoBj/uGZGYnuSQM2s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hQFSmaqH; arc=fail smtp.client-ip=40.107.243.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iyc2HXyVkkvdGz9CDj61+NroQ5gguOM95cfWv/BOVSeP9n5+6JHgC5BWUaVA+RlHo0O/xpNw5fELFQzOoNtobD9Mc8YSsMKtkBWVcDVeaBvXHYFXJKodMEn/ysE2xoqo96JqZwHsrS8nMYIHVfrODb+HPm7x4uFVkDuwEPeUE/7M254Tqgco5PsTnQJaOEnosVonIH/KAMBuyAJbFtEmz5Go7GDRkAotlt+Bo/I4SU0Ie/0Qb2JUIA6papxgBhc5R4uNIw6Ojxwczn5MGaSC/b5ohn5JWbItjEHdsZXpZecDHKefWiLmHF7QdjwPvLx9a7CImjVcGgsen0TuNLov/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bJbOEd4dBzMu6JORQwK8OBcxVge5eG3OIbRLz/wOSKs=;
 b=xEOBWmNt1eo4+zNU0iEc8KVA+lQ6JDkvZk5UgkcGYfZ+JXUGvRMVZe2qGZWnpLuXzbLpCYRLsh5CKElm0785DinIbcgM1hcSzE3sIPd6IljLgDTXZFC0Bb7XIjtsLEYXy6e2JIzFhMu8y+BMflEYRezG6lzuJriGO6sVRBZ5lXkGGTMq1RAPMWB2pw6/MSSJjHdgzYSEItHM/u9aYWL1tWJLPV2IVtB604+8C4Gknn3WErYkX8Dw1+UfR4/PTVuFaiZVzlOBtG36M67zOmfPUZ6jq7C9HyIYVbGcqK/d2nrNSzqmO0eie5gEXuPneo8+65Fv+Y0gf3I0lpnIEZnOlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bJbOEd4dBzMu6JORQwK8OBcxVge5eG3OIbRLz/wOSKs=;
 b=hQFSmaqHCDMkOTE8blemOaAxqfqbje8Lnzu9ZKj36WOG+TCIg75sZyUFVv2IJS4mnR7breNVsUR9o1EqTWsyqVZzh0NrBX7zb3cRuKSnBE1Ou9vIErjrHHvggOUdvN00yqv5qTVlwgM5VaWvtE3M8nVSteYxyBI+rSxXiIyIJeI=
Received: from SJ0PR05CA0026.namprd05.prod.outlook.com (2603:10b6:a03:33b::31)
 by PH8PR12MB7207.namprd12.prod.outlook.com (2603:10b6:510:225::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.42; Mon, 24 Mar
 2025 21:15:13 +0000
Received: from SJ1PEPF00001CDF.namprd05.prod.outlook.com
 (2603:10b6:a03:33b:cafe::e1) by SJ0PR05CA0026.outlook.office365.com
 (2603:10b6:a03:33b::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.42 via Frontend Transport; Mon,
 24 Mar 2025 21:15:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CDF.mail.protection.outlook.com (10.167.242.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8534.20 via Frontend Transport; Mon, 24 Mar 2025 21:15:12 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 24 Mar
 2025 16:15:11 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <nikunj@amd.com>,
	<ardb@kernel.org>, <kevinloughlin@google.com>, <Neeraj.Upadhyay@amd.com>,
	<aik@amd.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH v7 5/8] crypto: ccp: Register SNP panic notifier only if SNP is enabled
Date: Mon, 24 Mar 2025 21:15:02 +0000
Message-ID: <2010e3129134bcadea58fb79bc71ac35b293e3b6.1742850400.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1742850400.git.ashish.kalra@amd.com>
References: <cover.1742850400.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDF:EE_|PH8PR12MB7207:EE_
X-MS-Office365-Filtering-Correlation-Id: 02c2bb06-1b00-43fa-6c10-08dd6b18f77f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700013|82310400026|1800799024|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pAJX9QtGHKTJIrqPuj0rLjTfXDLjLrc1+PxnfuZj0JNVqxSO/zPjVHrO4ZZ6?=
 =?us-ascii?Q?kLubPZ4B977peylPLK7skKTj7X8aCq40pgS6HVQJ4+Cqv9B4104/K14EEQ3r?=
 =?us-ascii?Q?dFK2vctd5kBm0Ud8FjR66A2IP4HVYytKT+WhZ0sjNCiMwe4RTtma52JngI2L?=
 =?us-ascii?Q?kLI+LX3qL451KZotZhO/SM7DwTeH7pYZ6rvKV4FBWifetbd1Yyu/0LOc2+jc?=
 =?us-ascii?Q?1ls5GKr1kxlLa5tza2uGsUj5efNmXwQouP2G3O+y42UgOLS/uhIxBcnTNKd4?=
 =?us-ascii?Q?iyK4oUo7C6Nxvkyhjwj5mEUjKw9NqIWp7mGsYVAyNqjfc1Y7mJ4cx7KFxDLL?=
 =?us-ascii?Q?jA0j69lc3gqexY16lLVqSupkG9HJGMuViWSip4p6l3gbhCjn2DuiG6B7lDYA?=
 =?us-ascii?Q?URJJXBKVFC2YqDKACQXOpsp//MBthH5BWrPd3JkJha6goHR5soypcy+XcTX5?=
 =?us-ascii?Q?tNWaCy3z2ydOHpkIcNR8KArxnbtaC5ETZMi3UBj1GhT5LLC/IMseMK6UXa/j?=
 =?us-ascii?Q?xqUE1nJYPtxXw9KL9cTGoeM+1FF2H/k1ItNR2pyi/2cO4S6QPEUkSboqUk7R?=
 =?us-ascii?Q?w+axD17esBRsCFvUVooiCJqKC4nT5oqQL/P8AULWg2TzKA81mj83pPHDt46H?=
 =?us-ascii?Q?TWazps6ShL5xyCaeLedAYPje2dgcNV2bgT+wIRgeFn3MUEFwe8LP/ebK+Dnr?=
 =?us-ascii?Q?Q68tPxt31yF+/qZJQPbjciwCL6PDd4JTVxunT/eqUU6CRkuWUjpP7McsDpec?=
 =?us-ascii?Q?xoJ2K81gFqesnJ43Hx/on3E/t8FTPsGBS5yrgtjbtpm+WjeyBz7R6qIpqr8u?=
 =?us-ascii?Q?WjIkKclV3GYf1plLV9ro7vbupJKHNtrJ/0vgTsbrAi7NlaK93wCAI9MxnTxB?=
 =?us-ascii?Q?iXIFrvWTZo32JFMMrDeof/7yw6o0AW/GCTikez/lcmVN6ymNR+ZTIpvYWm45?=
 =?us-ascii?Q?oiwxlvDMVoqP3CCxS2ZtzMqKcfsQXAR9bmK68IWw5eBxkSBsxTQILCp+U5Qh?=
 =?us-ascii?Q?Vqv9YA8mFYkIBcQHqraZuAKouCfTOFGdjbt9XYodhwETbj/z3GApRfIH5aX7?=
 =?us-ascii?Q?N6ZREdt20msQEbGYE/GYAz1xd2jKTFRCHJJNGFLmujKKuEfoDXxC1ODssmoA?=
 =?us-ascii?Q?Et7EWfcAaAlK9oTCutilGPBg26oWrPtqre+PBd1SQBD9oDCpJuT4j4MFY0w/?=
 =?us-ascii?Q?obvrwGCGoKMmpeDqGwakUkEnlJq9+WcwBaEw6ldcBc7U+kBQ9FcU1eAVmtmZ?=
 =?us-ascii?Q?L+iqIjgljBQTU3ise6NvwpgxjPJyG2YaXd0EAANIKdcoBHbz+LyhCf6m24nj?=
 =?us-ascii?Q?18xXk5DYfgX+uTHiroB3c70V9yVzQaaQpvXNt5HdQHYVU3Av9gCvklqMqNA8?=
 =?us-ascii?Q?bkRnTm1q6b6RM6auchznagNuBeCY7EupJ4KoWzKcbR6YxXJqNIGrrHj+Rgyj?=
 =?us-ascii?Q?0wwDFCWPzpe3B9bu3MdcykViXC9w7u3vSlMhiaofyK3FPkHiFNJDWacf3aHd?=
 =?us-ascii?Q?yHpzX2CS3tBo+pDfZcD4M+Ei4qcSG7D6RFiC?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(36860700013)(82310400026)(1800799024)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2025 21:15:12.7657
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 02c2bb06-1b00-43fa-6c10-08dd6b18f77f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7207

From: Ashish Kalra <ashish.kalra@amd.com>

Currently, the SNP panic notifier is registered on module initialization
regardless of whether SNP is being enabled or initialized.

Instead, register the SNP panic notifier only when SNP is actually
initialized and unregister the notifier when SNP is shutdown.

Reviewed-by: Dionna Glaze <dionnaglaze@google.com>
Reviewed-by: Alexey Kardashevskiy <aik@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 08a6160f0072..6fdbb3bf44b5 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -111,6 +111,13 @@ static struct sev_data_range_list *snp_range_list;
 
 static void __sev_firmware_shutdown(struct sev_device *sev, bool panic);
 
+static int snp_shutdown_on_panic(struct notifier_block *nb,
+				 unsigned long reason, void *arg);
+
+static struct notifier_block snp_panic_notifier = {
+	.notifier_call = snp_shutdown_on_panic,
+};
+
 static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
 {
 	struct sev_device *sev = psp_master->sev_data;
@@ -1200,6 +1207,9 @@ static int __sev_snp_init_locked(int *error)
 	dev_info(sev->dev, "SEV-SNP API:%d.%d build:%d\n", sev->api_major,
 		 sev->api_minor, sev->build);
 
+	atomic_notifier_chain_register(&panic_notifier_list,
+				       &snp_panic_notifier);
+
 	sev_es_tmr_size = SNP_TMR_SIZE;
 
 	return 0;
@@ -1778,6 +1788,9 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
 	sev->snp_initialized = false;
 	dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
 
+	atomic_notifier_chain_unregister(&panic_notifier_list,
+					 &snp_panic_notifier);
+
 	/* Reset TMR size back to default */
 	sev_es_tmr_size = SEV_TMR_SIZE;
 
@@ -2489,10 +2502,6 @@ static int snp_shutdown_on_panic(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
-static struct notifier_block snp_panic_notifier = {
-	.notifier_call = snp_shutdown_on_panic,
-};
-
 int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
 				void *data, int *error)
 {
@@ -2538,8 +2547,6 @@ void sev_pci_init(void)
 		dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
 			args.error, rc);
 
-	atomic_notifier_chain_register(&panic_notifier_list,
-				       &snp_panic_notifier);
 	return;
 
 err:
@@ -2556,7 +2563,4 @@ void sev_pci_exit(void)
 		return;
 
 	sev_firmware_shutdown(sev);
-
-	atomic_notifier_chain_unregister(&panic_notifier_list,
-					 &snp_panic_notifier);
 }
-- 
2.34.1


