Return-Path: <kvm+bounces-27060-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 53BD397B488
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 22:17:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 183EE2841BA
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 20:17:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FFFC179967;
	Tue, 17 Sep 2024 20:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="T7yRrceT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2054.outbound.protection.outlook.com [40.107.94.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC92718D642;
	Tue, 17 Sep 2024 20:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726604217; cv=fail; b=Ar/fFzwC9sLH2rgZpZhLZwzcAdbET4JrmCCgs3zdMsbsdwwU3A2j9H1NdPWfVp6PJtlo5wtcr4SXW+54mN52LYSJ6q5TswNqnDbG5g+GWH9ecMIKWOH1y6bXLPC+C3YIGwKM+EmOHPyzE+X1rXsA2Z+4vReBLKME6YCKmymz73g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726604217; c=relaxed/simple;
	bh=97OMTkc6nh0RADY0jBiLNbirHC+FcUyE/dxwD9QQPlM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qRrEcIgyaXEA7+uxjrMSIBKJCv+jBGf7q/ehwuOBqUVBLQ85lxubzoeY5Z1Amf6AMt6rZu45LUELHWAaAwWPVFcvLIVcTI6Ac3yyWBkBsuINO5zFVkGzzgNSBYeKc0a03J8JRdGonsxDfGGnAf6k9/AeZ9u+VFXU0QTwJfcNd84=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=T7yRrceT; arc=fail smtp.client-ip=40.107.94.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gt7Tbdkm9N8glQO5/df8sjql3KlaUQfC6xdmwxj6Dnm43fR8w5OHY6NsX8kAwvxSrzpw2I25jEO4rVpcBddbgHrBAMjEqlPClzz6aBXrxgVKJOKaBc0bmPsgMp46FGmxRheYD9QZ2WWHhVexa0iE5PXWa9rc0kCxYBrpbQr/3/wXFzpaAl6iwhG+XDnmVndbpiG10W4F+iWBJPW/ltt05yU6kmBKIMC26FWhT0MKTPmH44Naq92J3pipTWQpDAuVKUiDfZaJmIxVBS2S9FCEfdM14aADdSeTCTybPJ2f1k1l+x8+TlfpoxayfZXzbRkVtxiY3Pa2wKzJyfts+itzwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UNUmalYNDqqMh/2kEaKAXyS4RTGZo0MdYwcH+kyPJEw=;
 b=YkLKSDgsNUiSOHhcqMQhCefgVLOFp3K1Iy0NL1BTak6lZbPzMYQ/Yg9lfuBmUoo8L50QFDHOKY+4/snt4HI0hpkzLjLgWzJWfKNDlaog2SmH5KMAdZNsGHB9ud8jzxD9FCnz2k/+N6gazOwXolqJePXFt5lAHThus8RpMTACMJI6tPjnllwB/KNliWGB2o9s3ECXYbrP/mfoyMKRtw2S2QbEdc21gbVtmXH74MLkzX9ps/SiiIjqKhrS0XYT0rQyb4D77N2Uf5emQQwy8HXF9bkYWkoW0AGsSXG0zWQD63sXOSyf5LgvMM2RXRGOEhBU+BswFUXSAu7o670Le4lPqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UNUmalYNDqqMh/2kEaKAXyS4RTGZo0MdYwcH+kyPJEw=;
 b=T7yRrceTLweYe4AsrLOBrYBWmIlWbsfvryjp67xeKOPOFiUOAb/DnTsxAHUNu9uggU/4nLWCrqXxogspypwCZ4aN/nFOdolOppNxe8V9zkqpM1jrvKoeuYOsHrPMc8eLRn4XfPGghld78U+C0yLoFko5uQvBaRkbmvjf7jxKStw=
Received: from BYAPR04CA0026.namprd04.prod.outlook.com (2603:10b6:a03:40::39)
 by CY8PR12MB7145.namprd12.prod.outlook.com (2603:10b6:930:5f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.24; Tue, 17 Sep
 2024 20:16:53 +0000
Received: from SJ5PEPF00000209.namprd05.prod.outlook.com
 (2603:10b6:a03:40:cafe::b2) by BYAPR04CA0026.outlook.office365.com
 (2603:10b6:a03:40::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.30 via Frontend
 Transport; Tue, 17 Sep 2024 20:16:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF00000209.mail.protection.outlook.com (10.167.244.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7918.13 via Frontend Transport; Tue, 17 Sep 2024 20:16:52 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 17 Sep
 2024 15:16:50 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <herbert@gondor.apana.org.au>
CC: <x86@kernel.org>, <john.allen@amd.com>, <davem@davemloft.net>,
	<thomas.lendacky@amd.com>, <michael.roth@amd.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>
Subject: [PATCH v2 3/3] x86/sev: Add SEV-SNP CipherTextHiding support
Date: Tue, 17 Sep 2024 20:16:41 +0000
Message-ID: <f2b12d3c76b4e40a85da021ee2b7eaeda1dd69f0.1726602374.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1726602374.git.ashish.kalra@amd.com>
References: <cover.1726602374.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000209:EE_|CY8PR12MB7145:EE_
X-MS-Office365-Filtering-Correlation-Id: d76cd972-049d-4605-22a0-08dcd755ab82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hSab+bTztaVz5nfTA1Dgj6D92bRHYcqxUJXcxZ2YcWMM94NeujGsRDkPZwXT?=
 =?us-ascii?Q?SBsNtCwXeg5bAva1bNk3qm6cCCsKMvAunHCkGhN42hkM0bAkSYSkFttw7MPu?=
 =?us-ascii?Q?LF3f0ltqYisGD6qxu0WFdk8PV6Q6twoO0lRhV8biMX2fHMntW5TkzYwtMqhs?=
 =?us-ascii?Q?CWIyBbqr3xkoXdzEZktwHsPfDSFCPN5yV2IVnlGjw3TPsLRg89PCZXSvGBzx?=
 =?us-ascii?Q?Mf+YDE1/EP6axDKCezr/3VsSemA65GTqTWON+ea7ih0Y8dGQ0FSMgrnfiZbs?=
 =?us-ascii?Q?QXIg5mJMmN60NUvcL93n+sc0C6H+AclhlEEA4cgX6ta0tsruBbQcMCQfH0eZ?=
 =?us-ascii?Q?zf6DEbfN8HYy7xrz53nkgVslbeGiOp2XZXBaP/xsEztTNKXN4vyli27qjoEX?=
 =?us-ascii?Q?WwPLnxN5k/bGzXAIFInnn+KHQ4QNCO95spzZQVqCBMYWtLcXCiweJhnADPYN?=
 =?us-ascii?Q?CpGSyRHkaEj/+f7z0o2RNNAo8GmWLc9cgof0bJM0y+t9ektJaJzSze7qYzti?=
 =?us-ascii?Q?bHyQo5NQMwzh0MIHOwWFrk7scfkDDtcHvgEW1TWLp6BduTrKBEF+tjMArcZp?=
 =?us-ascii?Q?ci3ZOS7ARS3tiImWr8oHAXl1s/BPvvk5sBEirMZnw0B0DMXgEO8S3FHWY3Ev?=
 =?us-ascii?Q?zGHKeKJqEoPw4xz1yLY056jDDTO2z6YFh71AUaf/1n4b5+hB7AyyyXJUXS7l?=
 =?us-ascii?Q?gnDY9Tp1c6IRCSDTi5GrnNFib+a4VUPKlmJueEXpf7qCwBgk9/Q67/2cfxyu?=
 =?us-ascii?Q?5PJjwbutKCwigLw4VX/0Cl8N7wtB6Fe2n99fHlti1e+e4Fy7AybOY6l3zXGT?=
 =?us-ascii?Q?QE5OL2Rxc2kyFN4bSpLYY+PCGBCorFhWOIvTcttzYKSewYcmEdrB+02o/Luf?=
 =?us-ascii?Q?I1llUo7bwarxNlODoKbjHeTgv+IySlQQTuVtZnV9zVW9h8+asABdp9ekw/NU?=
 =?us-ascii?Q?PmcfoZqQPPeKHIvnOr5Vtalr/DzH3qfUx+keCoo3CULf6EbYRJbM3B6Sm5gf?=
 =?us-ascii?Q?diSto8N/WeDrZ2r2yfk0k2iEa0TKvB3Gr3hzI4CsBzWkbe02AP5PzNvTfbJI?=
 =?us-ascii?Q?lmtfuObe8uxjiZ2n83e3XGf+H+L/MijMzU1PIMoX/uoT8CSoVpAL7BuUl/UY?=
 =?us-ascii?Q?wFU9dYemESPdr75RLqj+sBfuNVKZDIGGokjvcElllwuZegKYgc85aiTWJbXK?=
 =?us-ascii?Q?O8P3Q6BCYZEdPMaPCNKSTt5/lxE3kseP2dV6kHJIxF6aaWuxjdG3TtIzz8Mc?=
 =?us-ascii?Q?BvLd2Tih7k/MMg1nNuAe1ruIAYKUp5rOZEcCxoIq/cbrGUUBYiRhs/JGZpWW?=
 =?us-ascii?Q?bUhBk+OqodREVU4hpLS5n1HJjMuE+0DW5Fi2GGy4KPSmKMT4MbF+QVr7jeCu?=
 =?us-ascii?Q?tnh+S+sT78m/lIHh7h8t+Z3a5FvoE7xHFJ6WcsDGA0Z/xtVMkzpeYYfQiSL+?=
 =?us-ascii?Q?OhQy9RxlKuYyucA1gSJ935Q7Hvi5l26U?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2024 20:16:52.8298
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d76cd972-049d-4605-22a0-08dcd755ab82
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000209.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7145

From: Ashish Kalra <ashish.kalra@amd.com>

Ciphertext hiding prevents host accesses from reading the ciphertext of
SNP guest private memory. Instead of reading ciphertext, the host reads
will see constant default values (0xff).

Ciphertext hiding separates the ASID space into SNP guest ASIDs and host
ASIDs. All SNP active guests must have an ASID less than or equal to
MAX_SNP_ASID provided to the SNP_INIT_EX command. All SEV-legacy guests
(SEV and SEV-ES) must be greater than MAX_SNP_ASID.

This patch-set adds a new module parameter to the CCP driver defined as
max_snp_asid which is a user configurable MAX_SNP_ASID to define the
system-wide maximum SNP ASID value. If this value is not set, then the
ASID space is equally divided between SEV-SNP and SEV-ES guests.

Ciphertext hiding needs to be enabled on SNP_INIT_EX and therefore this
new module parameter has to added to the CCP driver.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kvm/svm/sev.c       | 26 ++++++++++++++----
 drivers/crypto/ccp/sev-dev.c | 52 ++++++++++++++++++++++++++++++++++++
 include/linux/psp-sev.h      | 12 +++++++--
 3 files changed, 83 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0b851ef937f2..a345b4111ad6 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -171,7 +171,7 @@ static void sev_misc_cg_uncharge(struct kvm_sev_info *sev)
 	misc_cg_uncharge(type, sev->misc_cg, 1);
 }
 
-static int sev_asid_new(struct kvm_sev_info *sev)
+static int sev_asid_new(struct kvm_sev_info *sev, unsigned long vm_type)
 {
 	/*
 	 * SEV-enabled guests must use asid from min_sev_asid to max_sev_asid.
@@ -199,6 +199,18 @@ static int sev_asid_new(struct kvm_sev_info *sev)
 
 	mutex_lock(&sev_bitmap_lock);
 
+	/*
+	 * When CipherTextHiding is enabled, all SNP guests must have an
+	 * ASID less than or equal to MAX_SNP_ASID provided on the
+	 * SNP_INIT_EX command and all the SEV-ES guests must have
+	 * an ASID greater than MAX_SNP_ASID.
+	 */
+	if (snp_cipher_text_hiding && sev->es_active) {
+		if (vm_type == KVM_X86_SNP_VM)
+			max_asid = snp_max_snp_asid;
+		else
+			min_asid = snp_max_snp_asid + 1;
+	}
 again:
 	asid = find_next_zero_bit(sev_asid_bitmap, max_asid + 1, min_asid);
 	if (asid > max_asid) {
@@ -440,7 +452,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	if (vm_type == KVM_X86_SNP_VM)
 		sev->vmsa_features |= SVM_SEV_FEAT_SNP_ACTIVE;
 
-	ret = sev_asid_new(sev);
+	ret = sev_asid_new(sev, vm_type);
 	if (ret)
 		goto e_no_asid;
 
@@ -3059,14 +3071,18 @@ void __init sev_hardware_setup(void)
 								       "unusable" :
 								       "disabled",
 			min_sev_asid, max_sev_asid);
-	if (boot_cpu_has(X86_FEATURE_SEV_ES))
+	if (boot_cpu_has(X86_FEATURE_SEV_ES)) {
+		if (snp_max_snp_asid >= (min_sev_asid - 1))
+			sev_es_supported = false;
 		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
 			sev_es_supported ? "enabled" : "disabled",
-			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
+			min_sev_asid > 1 ? snp_max_snp_asid ? snp_max_snp_asid + 1 : 1 :
+							      0, min_sev_asid - 1);
+	}
 	if (boot_cpu_has(X86_FEATURE_SEV_SNP))
 		pr_info("SEV-SNP %s (ASIDs %u - %u)\n",
 			sev_snp_supported ? "enabled" : "disabled",
-			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
+			min_sev_asid > 1 ? 1 : 0, snp_max_snp_asid ? : min_sev_asid - 1);
 
 	sev_enabled = sev_supported;
 	sev_es_enabled = sev_es_supported;
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 564daf748293..77900abb1b46 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -73,11 +73,27 @@ static bool psp_init_on_probe = true;
 module_param(psp_init_on_probe, bool, 0444);
 MODULE_PARM_DESC(psp_init_on_probe, "  if true, the PSP will be initialized on module init. Else the PSP will be initialized on the first command requiring it");
 
+static bool cipher_text_hiding = true;
+module_param(cipher_text_hiding, bool, 0444);
+MODULE_PARM_DESC(cipher_text_hiding, "  if true, the PSP will enable Cipher Text Hiding");
+
+static int max_snp_asid;
+module_param(max_snp_asid, int, 0444);
+MODULE_PARM_DESC(max_snp_asid, "  override MAX_SNP_ASID for Cipher Text Hiding");
+
 MODULE_FIRMWARE("amd/amd_sev_fam17h_model0xh.sbin"); /* 1st gen EPYC */
 MODULE_FIRMWARE("amd/amd_sev_fam17h_model3xh.sbin"); /* 2nd gen EPYC */
 MODULE_FIRMWARE("amd/amd_sev_fam19h_model0xh.sbin"); /* 3rd gen EPYC */
 MODULE_FIRMWARE("amd/amd_sev_fam19h_model1xh.sbin"); /* 4th gen EPYC */
 
+/* Cipher Text Hiding Enabled */
+bool snp_cipher_text_hiding;
+EXPORT_SYMBOL(snp_cipher_text_hiding);
+
+/* MAX_SNP_ASID */
+unsigned int snp_max_snp_asid;
+EXPORT_SYMBOL(snp_max_snp_asid);
+
 static bool psp_dead;
 static int psp_timeout;
 
@@ -1064,6 +1080,38 @@ static void snp_set_hsave_pa(void *arg)
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
+	if ((sev->feat_info.ecx & SNP_CIPHER_TEXT_HIDING_SUPPORTED) &&
+	    sev->snp_plat_status.ciphertext_hiding_cap) {
+		/* Retrieve SEV CPUID information */
+		edx = cpuid_edx(0x8000001f);
+		/* Do sanity checks on user-defined MAX_SNP_ASID */
+		if (max_snp_asid >= edx) {
+			dev_info(sev->dev, "max_snp_asid module parameter is not valid, limiting to %d\n",
+				 edx - 1);
+			max_snp_asid = edx - 1;
+		}
+		snp_max_snp_asid = max_snp_asid ? : (edx - 1) / 2;
+
+		snp_cipher_text_hiding = 1;
+		data->ciphertext_hiding_en = 1;
+		data->max_snp_asid = snp_max_snp_asid;
+
+		dev_dbg(sev->dev, "SEV-SNP CipherTextHiding feature support enabled\n");
+	}
+}
+
 static void snp_get_platform_data(void)
 {
 	struct sev_device *sev = psp_master->sev_data;
@@ -1199,6 +1247,10 @@ static int __sev_snp_init_locked(int *error)
 		}
 
 		memset(&data, 0, sizeof(data));
+
+		if (cipher_text_hiding)
+			sev_snp_enable_ciphertext_hiding(&data, error);
+
 		data.init_rmp = 1;
 		data.list_paddr_en = 1;
 		data.list_paddr = __psp_pa(snp_range_list);
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 6068a89839e1..2102248bd436 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -27,6 +27,9 @@ enum sev_state {
 	SEV_STATE_MAX
 };
 
+extern bool snp_cipher_text_hiding;
+extern unsigned int snp_max_snp_asid;
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
@@ -841,6 +847,8 @@ struct snp_feature_info {
 	u32 edx;
 } __packed;
 
+#define SNP_CIPHER_TEXT_HIDING_SUPPORTED	BIT(3)
+
 #ifdef CONFIG_CRYPTO_DEV_SP_PSP
 
 /**
-- 
2.34.1


