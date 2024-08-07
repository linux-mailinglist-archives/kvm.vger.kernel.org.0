Return-Path: <kvm+bounces-23468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D929949D3A
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 03:05:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EF4721F2436A
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 01:05:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A83131E864;
	Wed,  7 Aug 2024 01:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bgPn9vbC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2060.outbound.protection.outlook.com [40.107.237.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD8EB667;
	Wed,  7 Aug 2024 01:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722992729; cv=fail; b=u31azeuonC9HiZ1hRoBAePw4CyWUVGJ9tB0RRBoNOMnvY0DkKPl+BwZ+U1FmZL1JCLG60pKH0MzSblalMfcijW+7epY8qD4dpY71mWGwe1tv3YaqxHwQzVAQbItbURIRP5S8zenFJxBweNSpwWEdivHjUWI1iydbJtjizx73QhM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722992729; c=relaxed/simple;
	bh=Q3i4qMlsIafdSHibX4DmAeKBlkUBD+b13ihfJQbpONw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i9OYNQbpEBqzDxTsCMC0ciqdJucLMkvmDcfjEx6/m4nU1nDYpwpZLaWgGg4DfLUNcfSiM8byBa3RWi/aC5eykQlmFBUTUsEmXslnruNaoyHXVB78DknapV73Gp4bVhEX/bxFEt6VdTYKxxa+/TCfNjoiMOe2ooExKo9+pmE0Vjk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bgPn9vbC; arc=fail smtp.client-ip=40.107.237.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FP32xyV1K3wQqTJc0c0qSwLVlhV5twMZv0HBi2q2nKWe3StY8nJ8lgFk9jaewb0Ui5x3vsE7QsuioY8hE62H8W3wPJXywp64COtwxuJzKDT2/1hTY6UGFL/SdxcenxGH5GuPsVZ/vxVzAzooFKlwXGBT88I7hhLfXgn6MqAgoIKtOmn24xYMfUYHSsDxpTedged4dkIi4f2oY2NgSXbPq7uxOz71P8uviLTqgJhukLfm6F7Mpef6LhnJ1hCgEeZJyej7Enzg/l/t/gxEq6tU6dAbhA5syDoCvvs1a3ZKeTkUfR1b7BiyeePQKo3V/8ulBYRVjljYdKBU0rrYzxDdig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yM1Qs+PZyTpMrKMeh6iKCXJ0H7UzgkrVcJ5975ymaOk=;
 b=bR555yOm8uOqFOBq0zWtVYZYY6QncURJY2IrpsMuMk4JuOUVKG88weNZ4xAUavK89vcSdyGpjqoe5Eeijn4VX4VfU4TBtL8EFT+EpsDDA0m0RE0kGDGpCIE1C0RkDT/XCkIOMXJYXrUE/u+Naas7PI9nrAwktGgohCEvRmItF5ln96JIeqfl/uWOCmpvartdo7qNrymca2kcm1SEWodtWIXIHeZENVut7+L6CA97F+8zYywevIe/P6BLi752jO6Y7nAVe59lqlhSWV1nfL11TcCq4uTDdSUTFlcVcWaTm5a5mdgmzKOgTDwgwJYDAcJODYkBOsT+oO/GQdf21hwHjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yM1Qs+PZyTpMrKMeh6iKCXJ0H7UzgkrVcJ5975ymaOk=;
 b=bgPn9vbCN3SNM3b4aTW45E53T6L9jYOf2wuNX3SUSpTmccof8XUqPxbH/lT/oRYAlbjmoZj8bIM1iUoluy+kKcH+SxxVA3Ahi3g+K/22LNSKxdrUEE2Pqt/HudmdIKZzVSPnipiNNUx1KMf09HcTa4YuAGZ0dxPt/djInRoNVOM=
Received: from SA1P222CA0083.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:35e::21)
 by DM4PR12MB7576.namprd12.prod.outlook.com (2603:10b6:8:10c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.26; Wed, 7 Aug
 2024 01:05:24 +0000
Received: from SA2PEPF00003AE6.namprd02.prod.outlook.com
 (2603:10b6:806:35e:cafe::e6) by SA1P222CA0083.outlook.office365.com
 (2603:10b6:806:35e::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.23 via Frontend
 Transport; Wed, 7 Aug 2024 01:05:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00003AE6.mail.protection.outlook.com (10.167.248.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7828.19 via Frontend Transport; Wed, 7 Aug 2024 01:05:23 +0000
Received: from ruby-9130host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 6 Aug
 2024 20:05:22 -0500
From: Melody Wang <huibo.wang@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Tom Lendacky <thomas.lendacky@amd.com>,
	"Ashish Kalra" <ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>,
	"Melody Wang" <huibo.wang@amd.com>
Subject: [PATCH 6/6] KVM: SVM: Enable restricted injection for an SEV-SNP guest
Date: Wed, 7 Aug 2024 01:00:48 +0000
Message-ID: <a3bab644689202150df01442bed43dad45b6852e.1722989996.git.huibo.wang@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1722989996.git.huibo.wang@amd.com>
References: <cover.1722989996.git.huibo.wang@amd.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003AE6:EE_|DM4PR12MB7576:EE_
X-MS-Office365-Filtering-Correlation-Id: 37815e17-41ac-4a37-d053-08dcb67d0453
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OB5lNmEWGJ2Dq8D/icq3ApnWZqdFA1dTVztV+CBHKJQNyzseuq9sqad1nPXB?=
 =?us-ascii?Q?C1nTarqsmRUvMCoP2Ual0DjyhloeOvG+U5aqj+4iQoUFuDJVnnBtsFdz/VoP?=
 =?us-ascii?Q?ytKDf+9psux3W5YpVBCFU23SbWr7tmKctmu8seItfC/owaH7b3LsdGWXgtHX?=
 =?us-ascii?Q?RT7jTLhrnRPKb0+4RhhJDV5JGR3s6oXSTTzeBmKczfU6G3tha1iVWuv3xntS?=
 =?us-ascii?Q?022g+7nIQk0AmP9hzEe9am3S2htnP+zBr9+Cm8jnV79XR2+e3/Mglwns5qav?=
 =?us-ascii?Q?I5fac/Xcdgx7Lf6PqZPQuweu1wzrQsnd2VdJMRcfCISf+h9fzGLDB2W8KOj/?=
 =?us-ascii?Q?PEjZcSy+9k18bd8aIJTJ63gvUB9xWIB3Ic9R1EGLElLtCeGQskm6hBSnCAjb?=
 =?us-ascii?Q?uNtmO4LBanacnovhEW2Fo/xF5TLZ22njqXkLHWulddJMVBAdNO27fJD6JOhJ?=
 =?us-ascii?Q?VdNRTYpvxvB7E4fNkwz++qcFAsCgSV/ti2ra+MoJw66aXqQwO9D4M8w5yZIV?=
 =?us-ascii?Q?y/RwtpvHU+in0tJKbuiXyIWPRo+lXmnBsb5G1ZzWIuq+n2MvO06j23zgCBma?=
 =?us-ascii?Q?cBDI0VmAi02/Gsz3Ebb6EgL/XkTkDhJM/Yht7q2Ofv2gZMBvbEM831jj8nn1?=
 =?us-ascii?Q?kgv9jlDGhVvSgo9YSsGa5M4Y82BLFULk0gSzzL1zCF3JqY6drBMliFD7oYma?=
 =?us-ascii?Q?9obQdnXijF+i5r6pSgDT73c8nM4tg9KKNXTAdzFehrpWkAL0JGK81aGLIyWb?=
 =?us-ascii?Q?di2219PuBNBXvTuoCpVPmwhEvZbAgfV+D+xtZfYzhL2QsHvsrwpYt8jD7Qxn?=
 =?us-ascii?Q?HttZkDQpmdeit7l6G9QAMUauMX+MssL37a/QyIcK/cl/RyxwxpH7IhgrzC1h?=
 =?us-ascii?Q?ydRypEh5ls50GN0dLgxSyHJzR3g57OdOg4NLm/WnfCc2rt5OdtmG78mTm027?=
 =?us-ascii?Q?PKr0NXcf68Hfchmp0LS5cbQzWAO5MPa0JV5s3o64/zxGAfH3usMAzGkewI2y?=
 =?us-ascii?Q?xFDXVVcLjpCrka1Tjf1d8iwlKPkKW9H0hsYNaGbugQEPsJdLNc0+NhNf+i/9?=
 =?us-ascii?Q?px1flYF+g19Va1ZjqDin0lN8BBwFvEZyNwc4Hj//SzssZ/0rgxbrPWvz/8xH?=
 =?us-ascii?Q?pB6m/YBlBBWIPAq5k9tY56HcpfOZU45rsS5HPwwblW1RyA15jfxZAUQC3pX8?=
 =?us-ascii?Q?7xNZCAGzU+83OXL4o7tGCfQjwfblSUntDYyMvpS6AQnjSnIv/bjQDlfG+zrn?=
 =?us-ascii?Q?Av6J1qxYrLv+UAFyWQ5xhLw26uQGafgvN6KCnGBDHD61xeeStswEqE0n/bzX?=
 =?us-ascii?Q?sN4vHFFczJHufpLZJ+e8QsmWxpAGO0n6S7El1d7i531mLDfEEp1sIOvXtREA?=
 =?us-ascii?Q?OSjAS05ydIdidRPAStvjS2kxzpKkaqkLkb+Vz7TMH8i7RYIKNlJBQ+e1REb2?=
 =?us-ascii?Q?rkjhTHyJPQ5PnM3FvJDyV4d0f9fmFiUe?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2024 01:05:23.8599
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 37815e17-41ac-4a37-d053-08dcb67d0453
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003AE6.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7576

Enable the restricted injection in an SEV-SNP guest by setting the restricted
injection bit in the VMSA SEV features field (SEV_FEATURES[3]) from QEMU.

Add the restricted injection supporting the hypervisor advertised features.

Co-developed-by: Thomas Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Thomas Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Melody Wang <huibo.wang@amd.com>
---
 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/sev-common.h  |  1 +
 arch/x86/kvm/svm/sev.c             | 26 +++++++++++++++++++++++++-
 3 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index dd4682857c12..ff8466405409 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -446,6 +446,7 @@
 #define X86_FEATURE_SEV_SNP		(19*32+ 4) /* "sev_snp" AMD Secure Encrypted Virtualization - Secure Nested Paging */
 #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* Virtual TSC_AUX */
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* AMD hardware-enforced cache coherency */
+#define X86_FEATURE_RESTRICTED_INJECTION	(19*32+12) /* AMD SEV Restricted Injection */
 #define X86_FEATURE_DEBUG_SWAP		(19*32+14) /* "debug_swap" AMD SEV-ES full debug state swap support */
 #define X86_FEATURE_SVSM		(19*32+28) /* "svsm" SVSM present */
 
diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 98726c2b04f8..f409893ad1a5 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -136,6 +136,7 @@ enum psc_op {
 
 #define GHCB_HV_FT_SNP			BIT_ULL(0)
 #define GHCB_HV_FT_SNP_AP_CREATION	BIT_ULL(1)
+#define GHCB_HV_FT_SNP_RINJ		(BIT_ULL(2) | GHCB_HV_FT_SNP_AP_CREATION)
 #define GHCB_HV_FT_SNP_MULTI_VMPL	BIT_ULL(5)
 
 /*
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 87c493bad93a..038a1c8a5ad7 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -39,7 +39,9 @@
 #define GHCB_VERSION_DEFAULT	2ULL
 #define GHCB_VERSION_MIN	1ULL
 
-#define GHCB_HV_FT_SUPPORTED	(GHCB_HV_FT_SNP | GHCB_HV_FT_SNP_AP_CREATION)
+#define GHCB_HV_FT_SUPPORTED	(GHCB_HV_FT_SNP |		\
+				 GHCB_HV_FT_SNP_AP_CREATION |	\
+				 GHCB_HV_FT_SNP_RINJ)
 
 /* enable/disable SEV support */
 static bool sev_enabled = true;
@@ -56,6 +58,10 @@ module_param_named(sev_snp, sev_snp_enabled, bool, 0444);
 /* enable/disable SEV-ES DebugSwap support */
 static bool sev_es_debug_swap_enabled = true;
 module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
+
+/* enable/disable SEV-SNP Restricted Injection support */
+static bool sev_snp_restricted_injection_enabled = true;
+module_param_named(restricted_injection, sev_snp_restricted_injection_enabled, bool, 0444);
 static u64 sev_supported_vmsa_features;
 
 #define AP_RESET_HOLD_NONE		0
@@ -3078,6 +3084,12 @@ void __init sev_hardware_setup(void)
 	sev_supported_vmsa_features = 0;
 	if (sev_es_debug_swap_enabled)
 		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
+
+	if (!sev_snp_enabled || !cpu_feature_enabled(X86_FEATURE_RESTRICTED_INJECTION))
+		sev_snp_restricted_injection_enabled = false;
+
+	if (sev_snp_restricted_injection_enabled)
+		sev_supported_vmsa_features |= SVM_SEV_FEAT_RESTRICTED_INJECTION;
 }
 
 void sev_hardware_unsetup(void)
@@ -4555,6 +4567,15 @@ void sev_vcpu_after_set_cpuid(struct vcpu_svm *svm)
 		sev_es_vcpu_after_set_cpuid(svm);
 }
 
+static void sev_snp_init_vmcb(struct vcpu_svm *svm)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(svm->vcpu.kvm)->sev_info;
+
+	/* V_NMI is not supported when Restricted Injection is enabled */
+	if (sev->vmsa_features & SVM_SEV_FEAT_RESTRICTED_INJECTION)
+		svm->vmcb->control.int_ctl &= ~V_NMI_ENABLE_MASK;
+}
+
 static void sev_es_init_vmcb(struct vcpu_svm *svm)
 {
 	struct vmcb *vmcb = svm->vmcb01.ptr;
@@ -4612,6 +4633,9 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 	/* Clear intercepts on selected MSRs */
 	set_msr_interception(vcpu, svm->msrpm, MSR_EFER, 1, 1);
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_CR_PAT, 1, 1);
+
+	if (sev_snp_guest(vcpu->kvm))
+		sev_snp_init_vmcb(svm);
 }
 
 void sev_init_vmcb(struct vcpu_svm *svm)
-- 
2.34.1


