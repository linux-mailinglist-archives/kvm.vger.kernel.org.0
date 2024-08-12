Return-Path: <kvm+bounces-23884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D7E3794F79D
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 21:43:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6958B1F2162F
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 19:43:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2531C1917C9;
	Mon, 12 Aug 2024 19:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uD7kJpmS"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2077.outbound.protection.outlook.com [40.107.237.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D71B191F87;
	Mon, 12 Aug 2024 19:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723491781; cv=fail; b=Lhm0jnk3F36HU6ETip+JdEfV0n2JUU33fE4svi6I80p5LVeMVMYLBwRh4j16HAY7sN3l+9AYDDQObcbamiUMnMouCHXkhQpsOxaGFKRSjUHqN6Lxt/I1Mt1jq3n1QvD61DD4WFHdoHup4geuE8y3OAPGRk+upxI2UUeMWej85Zw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723491781; c=relaxed/simple;
	bh=8hzBBpcsKib8XlsvoqsB6iaEUqueXQuu0VIcQG3c1Ac=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rLwAMAKaElbFicyNAuhV2mjE5A54XsWSg3FV3ENFs1SFmm8CtBGpoj8SnTkau6B0uh5o4wjD65+4RcatuQdLrCsaBGUzanQ8+WHydmtZ49no9VHUV7TIf7rqrQOGz4Aokuc1d8RHsWesKt2GJSl96suR5jKjOkGOH99Zy5ihmRs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uD7kJpmS; arc=fail smtp.client-ip=40.107.237.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GMNSUBIji/DWem5ciOW+DRi5W4vVbG8cqZfAXCXkHEg98Y33QKpG5E8Do34eCTUApl9kC00Nwmt8AyKSijfOgbdmQ2lcK67TssRaJR1mU0NJsoenWfGDbw777bWMdL8nxE0+RSmRUXxgndDEZaQWOZzTiR8eqgd1wZAkTimbBVt1AY+OytoXj1PuVdw9m9KjXPmhERV6+83XpQSOSmRAYZfqH56UVDaU9g2AhF9jl3XqF6SvPcyLac8MpAESFBS2XnmiQcYemjSh+dZZN8zIWIVJmkl2/JHkDSXJxdNTrYLz3SUAkq4TslcVRsIbz39lANGQ0ZmTAZ7gOJuHPriPkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cvUhsD5rDMhC9dzbEnOfdQPnUxiNmTcUaj+pau+k/dY=;
 b=ydSUorlD/3/XxJ/8e4qhh7lBbt49fi2Wz9yjamkdWPg7VobSuds211Ghi6ZcoN55Yz8GC+jltTE3xu+Vs4pklwu2TY/qvU3YXLCg3tDLHbxAjEkqBWxjF/a7EwXscbqXfe40O+EZICpe16MRY5yEZKnEiSkNctT2E0szOlAfpMpxd/Bd50N6nY1IqRNp0mJtv/oC2b18sgH4sKCbcD9vuaRE9BU05gYs/ZUTq2XzZwQcFbHM9AwY4VimHLbumr2qoIlTkDPj3BIrEimoBQGtFmyWa5IbHU/zC3pcQIpuUZ4U524SrlmDvHUYFOumiH+PqX8LCGQaV8Ow2u8GI6eO8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cvUhsD5rDMhC9dzbEnOfdQPnUxiNmTcUaj+pau+k/dY=;
 b=uD7kJpmSf6GSo4MnkgV9psoqBYoQLJncsRf8KOi3u4DIb179Fxq93iMfPcplhuj4j70zrdtlgRqI/N9S3jihH+4cGuTW5qw18tzj0BMKEqlqKDfTuANtnZSsPWZWg/rEd2FgCJ2IojAJflYy1w0M2vOItPXVbq7LshxT2rRl924=
Received: from BN9P222CA0012.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::17)
 by DM3PR12MB9434.namprd12.prod.outlook.com (2603:10b6:0:4b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.22; Mon, 12 Aug
 2024 19:42:55 +0000
Received: from BL02EPF0001A0FC.namprd03.prod.outlook.com
 (2603:10b6:408:10c:cafe::be) by BN9P222CA0012.outlook.office365.com
 (2603:10b6:408:10c::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.22 via Frontend
 Transport; Mon, 12 Aug 2024 19:42:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0001A0FC.mail.protection.outlook.com (10.167.242.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7828.19 via Frontend Transport; Mon, 12 Aug 2024 19:42:55 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 12 Aug
 2024 14:42:53 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>
CC: <x86@kernel.org>, <john.allen@amd.com>, <davem@davemloft.net>,
	<michael.roth@amd.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>
Subject: [PATCH 3/3] x86/sev: Add SEV-SNP CipherTextHiding support
Date: Mon, 12 Aug 2024 19:42:44 +0000
Message-ID: <b05c6de0c3cd47f804fd77be60ca2d90a6d28f8d.1723490152.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1723490152.git.ashish.kalra@amd.com>
References: <cover.1723490152.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FC:EE_|DM3PR12MB9434:EE_
X-MS-Office365-Filtering-Correlation-Id: 52977baf-6829-4a0e-0827-08dcbb06f625
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oiL62vhFoXGOqb2lt80deVNcDs2h6EymWymF52EAknwTiNpbp5XyJQTeblbr?=
 =?us-ascii?Q?E8oOE2U9d6oj6BklAR4zYqfqGzm+tBUQ8DU8gMFwcP4kzT6e9vxyc3PEC6vi?=
 =?us-ascii?Q?OCZaY1kMX50K5I1POA8Z06ErLjVY36/PyZNWQn0KpKG+17OyVq+Wt8rQKV8D?=
 =?us-ascii?Q?dsB9lfSm88P+TTJC+JMJz4UEGWaL74LnH9/LBzjsPoHEOCWb2dR3vLkXQF6z?=
 =?us-ascii?Q?ASGS3zryw4Ldyea+F9Fo/qR8x1hvRwuzzCWrA9AP7lWDyUmp+j7DGWzVIAO1?=
 =?us-ascii?Q?M2T3MfgobXaCY8Zej/lDzOctpZu0aQQun6zsla5xuf34nU8rn69GAaPqIkf1?=
 =?us-ascii?Q?Nm7LlYW/Y4mO8xGjtftIsy4o8f43mjb3gy1SM50wt4Ac77gDCa4cvKAkHOYF?=
 =?us-ascii?Q?eWwiVy19EF3w64pT03R9HE+vKOwJgP5abMWUyx4wnYOH1e8oRNMrQ1Rv+cyw?=
 =?us-ascii?Q?bZxz0sWARnkWB1vGB9p9MqCXsAjAs63vIgEzKh8SsmhZNhq6OPDZY6iGQCo2?=
 =?us-ascii?Q?630Gezhcms58PYYD57KpoyzaFJeLs4CTyvsDAkjHF38N3jvpnnTrUFHG+gpL?=
 =?us-ascii?Q?K91nyP7Hso0VFffBknPHNQgZzkQyc7CrEr5ap6Y7KLARh0njRmpPdZN7Y2K/?=
 =?us-ascii?Q?G+hzexWbuQnJ5Wt9FKh2LDsyKjUGd+ts3V2KGPaznHgQ63OhsAawWpGbFb7U?=
 =?us-ascii?Q?Abw9eNLG6pG8AUcP/jxTyzxFld4NxoHVa9I+dJ2iO+yE1IRwAhhZfEUh6nsm?=
 =?us-ascii?Q?yZIuu6vZ2Rg24kHhtqa6TgJUKX4Z8E8y6RNC+X+wcQ7SGsWZyRoLkeQ0rTGF?=
 =?us-ascii?Q?KOXz1/2cNRE3+QRWrRGzRWemFI1jjUTQAwueGtR2WtlGjqFApg2WPjVctO39?=
 =?us-ascii?Q?FqDvyNmN2vKuw3b7US+XZeRxcouwXRz2nYQ8bGwOXqq/RRxz99Pvj4rob9Kj?=
 =?us-ascii?Q?y4feWJPoPepCsMLn+3Kie4it2BfzpqS5apUzyQrP4zl7wVLHLEeeOlpXNauh?=
 =?us-ascii?Q?qFeg63hOKR2DnI25qqp5rM+IDjmN8UKuZ3J+/VR4xQ4BZT+PJNz8vVK9mily?=
 =?us-ascii?Q?a9gamyeork5Xe9E6DB9xbV0YfxfCS4d5E2l4gohxO6VdENiPLgN/e31zv9PG?=
 =?us-ascii?Q?qRKgIxyveh/3Mcv2YtJqC2X4zKCCN5AjX3YBCA85ooTcOnRhDlLrH3r1Vp04?=
 =?us-ascii?Q?1u4rWXsNeRfiEk6b+zWklLggvh8KA1lVzc2hIGiWKbK8DSKRWB/kBN/95Vz+?=
 =?us-ascii?Q?Pe+a4Tv0uYaG/iTUwJk0xLZiRyzqCNOGgwUONIbDnj9swkp/53CxFTNlcEsg?=
 =?us-ascii?Q?jrRUZEApCC/pmDke8p2M4WmApq61CVJoCNG002XxZCnWOtKMjRwMB09HBfYb?=
 =?us-ascii?Q?ONdQBfYLEvTfx8PXWYnzCF9Te1jLHHez5jgVgGP4tskISyZA9lyPqBuqESpK?=
 =?us-ascii?Q?lXL8xOoWuEXapW+TNys9Pks0Woy+35ip?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2024 19:42:55.2962
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 52977baf-6829-4a0e-0827-08dcbb06f625
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FC.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9434

From: Ashish Kalra <ashish.kalra@amd.com>

Ciphertext hiding prevents host accesses from reading the ciphertext of
SNP guest private memory. Instead of reading ciphertext, the host reads
will see constant default values (0xff).

Ciphertext hiding separates the ASID space into SNP guest ASIDs and host
ASIDs. All SNP active guests must have an ASID less than or equal to
MAX_SNP_ASID provided to the SNP_INIT_EX command. All SEV-legacy guests
(SEV and SEV-ES) must be greater than MAX_SNP_ASID.

This patch-set adds a new module parameter to the CCP driver defined as
psp_max_snp_asid which is a user configurable MAX_SNP_ASID to define the
system-wide maximum SNP ASID value. If this value is not set, then the
ASID space is equally divided between SEV-SNP and SEV-ES guests.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kvm/svm/sev.c       | 24 ++++++++++++++---
 drivers/crypto/ccp/sev-dev.c | 50 ++++++++++++++++++++++++++++++++++++
 include/linux/psp-sev.h      | 10 ++++++--
 3 files changed, 79 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 532df12b43c5..954ef99a1aa8 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -173,6 +173,9 @@ static void sev_misc_cg_uncharge(struct kvm_sev_info *sev)
 
 static int sev_asid_new(struct kvm_sev_info *sev)
 {
+	struct kvm_svm *svm = container_of(sev, struct kvm_svm, sev_info);
+	struct kvm *kvm = &svm->kvm;
+
 	/*
 	 * SEV-enabled guests must use asid from min_sev_asid to max_sev_asid.
 	 * SEV-ES-enabled guest can use from 1 to min_sev_asid - 1.
@@ -199,6 +202,18 @@ static int sev_asid_new(struct kvm_sev_info *sev)
 
 	mutex_lock(&sev_bitmap_lock);
 
+	/*
+	 * When CipherTextHiding is enabled, all SNP guests must have an
+	 * ASID less than or equal to MAX_SNP_ASID provided on the
+	 * SNP_INIT_EX command and all the SEV-ES guests must have
+	 * an ASID greater than MAX_SNP_ASID.
+	 */
+	if (snp_cipher_text_hiding_en && sev->es_active) {
+		if (kvm->arch.vm_type == KVM_X86_SNP_VM)
+			max_asid = max_snp_asid;
+		else
+			min_asid = max_snp_asid + 1;
+	}
 again:
 	asid = find_next_zero_bit(sev_asid_bitmap, max_asid + 1, min_asid);
 	if (asid > max_asid) {
@@ -3058,14 +3073,17 @@ void __init sev_hardware_setup(void)
 								       "unusable" :
 								       "disabled",
 			min_sev_asid, max_sev_asid);
-	if (boot_cpu_has(X86_FEATURE_SEV_ES))
+	if (boot_cpu_has(X86_FEATURE_SEV_ES)) {
+		if (max_snp_asid >= (min_sev_asid - 1))
+			sev_es_supported = false;
 		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
 			sev_es_supported ? "enabled" : "disabled",
-			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
+			min_sev_asid > 1 ? max_snp_asid ? max_snp_asid + 1 : 1 : 0, min_sev_asid - 1);
+	}
 	if (boot_cpu_has(X86_FEATURE_SEV_SNP))
 		pr_info("SEV-SNP %s (ASIDs %u - %u)\n",
 			sev_snp_supported ? "enabled" : "disabled",
-			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
+			min_sev_asid > 1 ? 1 : 0, max_snp_asid ? : min_sev_asid - 1);
 
 	sev_enabled = sev_supported;
 	sev_es_enabled = sev_es_supported;
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index eefb481db5af..9ee81a6defc5 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -73,11 +73,27 @@ static bool psp_init_on_probe = true;
 module_param(psp_init_on_probe, bool, 0444);
 MODULE_PARM_DESC(psp_init_on_probe, "  if true, the PSP will be initialized on module init. Else the PSP will be initialized on the first command requiring it");
 
+static bool psp_cth_enabled = true;
+module_param(psp_cth_enabled, bool, 0444);
+MODULE_PARM_DESC(psp_cth_enabled, "  if true, the PSP will enable Cipher Text Hiding");
+
+static int psp_max_snp_asid;
+module_param(psp_max_snp_asid, int, 0444);
+MODULE_PARM_DESC(psp_max_snp_asid, "  override MAX_SNP_ASID for Cipher Text Hiding");
+
 MODULE_FIRMWARE("amd/amd_sev_fam17h_model0xh.sbin"); /* 1st gen EPYC */
 MODULE_FIRMWARE("amd/amd_sev_fam17h_model3xh.sbin"); /* 2nd gen EPYC */
 MODULE_FIRMWARE("amd/amd_sev_fam19h_model0xh.sbin"); /* 3rd gen EPYC */
 MODULE_FIRMWARE("amd/amd_sev_fam19h_model1xh.sbin"); /* 4th gen EPYC */
 
+/* Cipher Text Hiding Enabled */
+bool snp_cipher_text_hiding_en;
+EXPORT_SYMBOL(snp_cipher_text_hiding_en);
+
+/* MAX_SNP_ASID */
+unsigned int max_snp_asid;
+EXPORT_SYMBOL(max_snp_asid);
+
 static bool psp_dead;
 static int psp_timeout;
 
@@ -1053,6 +1069,36 @@ static void snp_set_hsave_pa(void *arg)
 	wrmsrl(MSR_VM_HSAVE_PA, 0);
 }
 
+static void sev_snp_enable_ciphertext_hiding(struct sev_data_snp_init_ex *data, int *error)
+{
+	struct psp_device *psp = psp_master;
+	struct sev_device *sev;
+	unsigned int edx;
+
+	sev = psp->sev_data;
+
+	/*
+	 * Check if CipherTextHiding feature is supported and enabled
+	 * in the Platform/BIOS.
+	 */
+	if (sev->feat_info.ecx & FEAT_CIPHERTEXTHIDING_SUPPORTED &&
+	    sev->snp_plat_status.ciphertext_hiding_cap) {
+		/* Retrieve SEV CPUID information */
+		edx = cpuid_edx(0x8000001f);
+		/* Do sanity checks on user-defined MAX_SNP_ASID */
+		if (psp_max_snp_asid > (edx - 1)) {
+			dev_info(sev->dev, "user-defined MAX_SNP_ASID invalid, limiting to %d\n",
+				 edx - 1);
+			psp_max_snp_asid = edx - 1;
+		}
+		max_snp_asid = psp_max_snp_asid ? : (edx - 1) / 2;
+		snp_cipher_text_hiding_en = 1;
+		data->ciphertext_hiding_en = 1;
+		data->max_snp_asid = max_snp_asid;
+		dev_dbg(sev->dev, "SEV-SNP CipherTextHiding feature support enabled\n");
+	}
+}
+
 static void sev_cache_snp_platform_status_and_discover_features(void)
 {
 	struct sev_device *sev = psp_master->sev_data;
@@ -1181,6 +1227,10 @@ static int __sev_snp_init_locked(int *error)
 		}
 
 		memset(&data, 0, sizeof(data));
+
+		if (psp_cth_enabled)
+			sev_snp_enable_ciphertext_hiding(&data, error);
+
 		data.init_rmp = 1;
 		data.list_paddr_en = 1;
 		data.list_paddr = __psp_pa(snp_range_list);
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index d46d73911a76..a26b43c2eab9 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -27,6 +27,9 @@ enum sev_state {
 	SEV_STATE_MAX
 };
 
+extern bool snp_cipher_text_hiding_en;
+extern unsigned int max_snp_asid;
+
 /**
  * SEV platform and guest management commands
  */
@@ -746,10 +749,13 @@ struct sev_data_snp_guest_request {
 struct sev_data_snp_init_ex {
 	u32 init_rmp:1;
 	u32 list_paddr_en:1;
-	u32 rsvd:30;
+	u32 rapl_dis:1;
+	u32 ciphertext_hiding_en:1;
+	u32 rsvd:28;
 	u32 rsvd1;
 	u64 list_paddr;
-	u8  rsvd2[48];
+	u16 max_snp_asid;
+	u8  rsvd2[46];
 } __packed;
 
 /**
-- 
2.34.1


