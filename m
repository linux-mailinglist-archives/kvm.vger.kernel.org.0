Return-Path: <kvm+bounces-32618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EBBDB9DAF70
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 23:58:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83A94164A46
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 22:58:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9A74204081;
	Wed, 27 Nov 2024 22:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lPWF/0/Z"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2069.outbound.protection.outlook.com [40.107.101.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A42620371F;
	Wed, 27 Nov 2024 22:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732748325; cv=fail; b=sr7M7xiOn5NEQ12bB/Mit4fcRNUacYIeDm3zpzt66ehgRlWvxI6H0G4ArVutDYtWP48ushu53UyHlR3wY89DY7FL03Os6mm/Fj/dLU8woWtLy1leSRdC7ErvEYcYHYW2hYUt9xYxswa76N50IlbHNVU6uH4HxmbSjrRSw2l8q0s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732748325; c=relaxed/simple;
	bh=k02qQbwB4qeqHAIi8WoCdm30xubS/qPPyzaEMZ3mqco=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LZMmbw3sMu11DZlCybeTHnlaylh/gnFT4PJKYJ5DTDS4foX2GyqCk8Pbln2sWClLDdGhDkEwWp+Y/Y/yeyZW42N0Bf9kaFD8Shdm98bkvVveCix7b6ReaOo6W0keZ5v0I4out4gb/8Kla/IjNyG5FyGabOiQCRwT1G7TbikOIrw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lPWF/0/Z; arc=fail smtp.client-ip=40.107.101.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LSYXZTlgcTCV2YIHtKxXej4e+T5Pm+vBN2fUeX9Y4dQoIOUamthU0vv1BCLpbGyoBCMNxSYtCdukThjqFNUmJnbuop7MFPUK9f8M9X8K+BKZ4DpXD62Ugcz/6kiRxu9BF1qyUp2E1jKrZu+5BK9RNfcyt++/oPTn8YU5HiI0WNRd8LKsCHOWgZPB6P3bF16RBo1em75dH9S2YqseqNRbDYCmoxZ5AHeDZs9CmpymFalL6y8DwHpy4C1jUjre996Gm9DO9UY47fSgYh1eVdVxaHTne617eZg318iWUoJrGGc7qjkgN/GTSqO6w+MTgwuVcILh/eDEyf2yCbTBHHWoAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bgetm8luVMgzUT2SoVPewyHupRCIScJgEk/GjtcktRY=;
 b=iMo2AjvuOkB1ejLVZfIyDJu1S3JagLMQzUijglN57RWSIY8DVULhfIV/mBOQ5MntuBUVpMqXfTueUdtRfIBmFRbH+11rWUhGz0mxCs9GEYS5JKI9XHz8GLcDOsb9kOe6OMG7NPhQov86IBm9XU4qDm1YVQupTPV9gCmqcBvBilLhrsfiXfd7fdL7kJh4B2L2p8LB56ib8aZ/jWx5YVr+/jpieQ45yQL9QZkZNhni5SseH6d4+AuY7ZxtI0TvMld5Dg4FAK9hN5fqOSIUdXThlkWqTyKxwEpw4wbp/zWlzBAznSszxhJ2YA46CB5RzEB7XtxbUgopHHqIxP1hOldgYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bgetm8luVMgzUT2SoVPewyHupRCIScJgEk/GjtcktRY=;
 b=lPWF/0/ZNVppBYK43qxk/9ghY+3YS+gsYmUcqC5+D8TxP9uDUWIYUtfUKalbCrTe7RjhjJrkX8tUO4tSb7upzvOyLWX3hbPXj5cZN0cL/HY91/iH906GKYdGWiOcCZzTeOXWkhi8ZWWua1ffZb2GylBKh62zZ58Ps/BSVy/9OGU=
Received: from BN9PR03CA0441.namprd03.prod.outlook.com (2603:10b6:408:113::26)
 by DM6PR12MB4057.namprd12.prod.outlook.com (2603:10b6:5:213::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.12; Wed, 27 Nov
 2024 22:58:39 +0000
Received: from BN2PEPF000055E0.namprd21.prod.outlook.com
 (2603:10b6:408:113:cafe::e) by BN9PR03CA0441.outlook.office365.com
 (2603:10b6:408:113::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.13 via Frontend Transport; Wed,
 27 Nov 2024 22:58:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000055E0.mail.protection.outlook.com (10.167.245.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8230.0 via Frontend Transport; Wed, 27 Nov 2024 22:58:38 +0000
Received: from ruby-9130host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 27 Nov
 2024 16:58:37 -0600
From: Melody Wang <huibo.wang@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Tom Lendacky <thomas.lendacky@amd.com>, "Neeraj
 Upadhyay" <neeraj.upadhyay@amd.com>, Ashish Kalra <ashish.kalra@amd.com>,
	Michael Roth <michael.roth@amd.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
	Melody Wang <huibo.wang@amd.com>
Subject: [PATCH v3 7/7] KVM: SVM: Enable restricted injection for an SEV-SNP guest
Date: Wed, 27 Nov 2024 22:55:39 +0000
Message-ID: <20241127225539.5567-8-huibo.wang@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241127225539.5567-1-huibo.wang@amd.com>
References: <20241127225539.5567-1-huibo.wang@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000055E0:EE_|DM6PR12MB4057:EE_
X-MS-Office365-Filtering-Correlation-Id: b9ef6a4a-082b-4e2b-2003-08dd0f3707f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kTAO/x/IZVjoqP/GqQU4gqNLNjsGvnRgOfZxPYdEsdnNH7T+w8Ahb1/nyvV+?=
 =?us-ascii?Q?4RFT7yOcMUS1iuUrQ1lE+Xi98Z2AkvfJMEB3DvRnj72/OuehfPWkQiBgCkoE?=
 =?us-ascii?Q?pL9IJyA2Ba4YBquSa7VaCjylrpQIyCcXMO5oha0FwRSZtBqtVMqK+enEXuCP?=
 =?us-ascii?Q?p0Y/HtA+HJpgIbyGLP4mJE85reuqSWtGJWwzcTs5jXvuOhZvozv31teQ2kNw?=
 =?us-ascii?Q?H1OkEUdhN9tGRT3V1jz4NNtX1KxHJTVZNiqnBKOg9lkTXJLdTOz/ERc3PLvs?=
 =?us-ascii?Q?SCzFOKOd8NZIG8wWVRj5lW5Rmw0oFHUq5XrscQ7va+baMp2fxED0kyRhx0Vc?=
 =?us-ascii?Q?PUaAbyjEmgwq++wYok4/4r9lwOEKe/1p/Swn/+aisqKMutzMyd2HvtGRP5js?=
 =?us-ascii?Q?f+g4AwQgSCg/8kDHsF87lRcGzwnBKlytSHfHw874TEx3iOC8WqFIi9F4FD0G?=
 =?us-ascii?Q?TdpQP0oz+XE4oyaCxba4NZ2//m6eBQK5Ma0Iey1KlyBE2lv4vyprA1CaFhK4?=
 =?us-ascii?Q?ULhhBJXsuc3Tl6pVPRaF10ziNxor4O7TEMZmvVyNqWlbAl2wsuJqbYZlj56I?=
 =?us-ascii?Q?gj7SMA4+4NQl9gL7VhZOsfWvlrwNZyBdFUOFejp7u7Mb4SQt501K1KrwkX7e?=
 =?us-ascii?Q?NUyPtgLHuPVbPexYhBkYAPddoJzfHyduhUN8pnD1Z7toz/CoMsCTg6C7BT+X?=
 =?us-ascii?Q?BT/w3kzniSAGSQiwxaof8ensFMW3Dvh7LllyGwbXq/d0J8iZmh7+wBDBf9DY?=
 =?us-ascii?Q?v69AZOyf1dZgL6BmA1fY5FJsUq2+Hj84NbE3GKJAtoECGSlUXf0jVMQxhQFD?=
 =?us-ascii?Q?JDuTEEbsU2xJdcovSS4EE1KPsuPtn/wvU5KVXhOCKz/TKZcZHAUQUIJhDf0e?=
 =?us-ascii?Q?9rIRAEMqEUElxT8nbwPOO0Df9S59bprhLIjw5CgLu1JuxiXTQfexG5YVWOe8?=
 =?us-ascii?Q?5JI6amqhKKqdmC+rkqYmLQQAfn8ZOsNpwE4ECNKW2HXhv2n5SF1fKSPF73sc?=
 =?us-ascii?Q?2UCc9KMFzAaKQOWDSLAaA5NwWN8u2Ro0K/KXiHiBKAx8HO5ioNj5nn9PvgC9?=
 =?us-ascii?Q?T2rVWGkb8xHupjzdE7tbC/b084BeNBUwjVEHqCQ415uiKx9j45xQaVyfFGCY?=
 =?us-ascii?Q?7vYjohfJCqBSuqqnNi5kXRp336x9Wgk/l/NKt0A5CCMHu7ded4/YsQ4E9uRU?=
 =?us-ascii?Q?Ggm/daw4PElMaQKBavp6l/vu0mlOILoRPqgXKASa6JVjjHSTFvCjoCVsfqC6?=
 =?us-ascii?Q?D6yMEuc791A7ghvKLW0iXn+i67skKBwu31xkvr/vGuPOmYy5Bs2FoeXKsIdj?=
 =?us-ascii?Q?k8nSbfcjHJFFoT02sLdoxFbEUBqrThIPkPghA52e5UQMx5Q/2w6632zfDLGW?=
 =?us-ascii?Q?lTObmTqOF3aoRSDocn9XFUrsWWnTKpOB1APVmdLJcGB0XyeAWa98Odqn6OXJ?=
 =?us-ascii?Q?hgKNCwuPMBr9SZkEKfsJ3js2BrEseh+f?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2024 22:58:38.6779
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b9ef6a4a-082b-4e2b-2003-08dd0f3707f2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055E0.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4057

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
index d96277dceabf..c0a409ac1ea3 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -450,6 +450,7 @@
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
index 5e8fc8cf2d0d..d2a1b4304e41 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -40,7 +40,9 @@
 #define GHCB_VERSION_DEFAULT	2ULL
 #define GHCB_VERSION_MIN	1ULL
 
-#define GHCB_HV_FT_SUPPORTED	(GHCB_HV_FT_SNP | GHCB_HV_FT_SNP_AP_CREATION)
+#define GHCB_HV_FT_SUPPORTED	(GHCB_HV_FT_SNP |		\
+				 GHCB_HV_FT_SNP_AP_CREATION |	\
+				 GHCB_HV_FT_SNP_RINJ)
 
 /* enable/disable SEV support */
 static bool sev_enabled = true;
@@ -57,6 +59,10 @@ module_param_named(sev_snp, sev_snp_enabled, bool, 0444);
 /* enable/disable SEV-ES DebugSwap support */
 static bool sev_es_debug_swap_enabled = true;
 module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
+
+/* enable/disable SEV-SNP Restricted Injection support */
+static bool sev_snp_restricted_injection_enabled = true;
+module_param_named(restricted_injection, sev_snp_restricted_injection_enabled, bool, 0444);
 static u64 sev_supported_vmsa_features;
 
 #define AP_RESET_HOLD_NONE		0
@@ -3083,6 +3089,12 @@ void __init sev_hardware_setup(void)
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
@@ -4589,6 +4601,15 @@ void sev_vcpu_after_set_cpuid(struct vcpu_svm *svm)
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
@@ -4646,6 +4667,9 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
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


