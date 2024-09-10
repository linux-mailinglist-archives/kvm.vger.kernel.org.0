Return-Path: <kvm+bounces-26205-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9054D972941
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 08:06:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E83982879F7
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 06:06:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5B8B17622D;
	Tue, 10 Sep 2024 06:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MDBggCPH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2084.outbound.protection.outlook.com [40.107.243.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F59516BE23;
	Tue, 10 Sep 2024 06:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725948365; cv=fail; b=Nx2jJ4wmgKFdO/jH6a+atwIaLJnjKFB9otR2Wx2qeVfAG2Dp9qBtsRohcaJFjIoW5Dh6frGBJb3jexjUNycbTtAvj8k8heOxK3XRoy/uBinhcVhPiM6avUD/eoc8buVa/9SkaeU3VhDeqhQXDpcNycP2wmhl6fOVFUWaXCYoue4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725948365; c=relaxed/simple;
	bh=70zXwsnB3QtCcer74A8rFuSJb4ncMblcC9Plyu+SNBU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DVE+tvmS9Nfj/lPPvk2wY/s4g0DQp1xNYE4GfoJ/WiywHVXROIY6lrCnCslQodlmsN5RNaH40TLNaagKk1EqlVg16Bzi427jySW9Op5D7ifqF4TkgR3Kg/FvC2fWpEZ+IVfQKG8Rynl8ohTLUyJCgqS+mgASzuOVKLvp5GDNDF4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MDBggCPH; arc=fail smtp.client-ip=40.107.243.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QLkWmzQI/ork0C90BzjWQVMeww3BlPmM6vmLJ5FwZbVbrPXwzICw+EPeMTa1iwOjyBwSuy+jqyGIF9tL9BfPx/qUISzueuhqYea5418hrXWl2ApxMvMqUiWG4+r4B4i7xMqz4/Neqchoj0XwcYRbjM764/IcCaFPxFl+k8jZZjX15KHrSEAPzNFGSAiggtvFv44+KBX6ThU7HhJ4plpckBOIwKOu1M8XkZ3Ih4/KmY8TMfu8W+SMSY/ZG5jrQzPtE3oByYV97HHbN9KXV8Og5/Qsp2QgUgUnR4akj2ByC/hOpJobViYuUjZuv3qnkijzDTNgrbw2RTw2RWEQF6oZhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BoN70gbK2KET3WII/s2tvefJhIeJN066xQyyKOwUROs=;
 b=I7amdkIXzCP9LK+epQ9ejWuZxg37/xFnUq6H9PCcJSWX8NKp4mP6Xc35Z2YUW51tTsyVGtAfo2BxR4UL+CGyefTPe0UaiJQT55fdP4ZFQDtTXRtlVXtdxVsZC3HZeE8GeWeV6EbFiLQ9lmPmph8wzQRYiNid+998+/oYMlv99Vv/KS7hnUUtjq7T+5HyHfgri5pPQuoMyxOJFIHzrolwT8HHrElg2Ci+dj4rY9iBbRJoL/3p6p3b4J6KF3nDC/cXPvLqIndz112xlFLWPLURchTcn18EFZVffhs1J1MajpTSihTVRWco/3e6Ox59dzKTzAtc1XDZ8gAsKRo/ks/w8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BoN70gbK2KET3WII/s2tvefJhIeJN066xQyyKOwUROs=;
 b=MDBggCPHXdaKUqwzIjSLd6C6JnulQMTw9rFeBI6ZZnYvKenbBX4bI4/ZUWGHNzFDG25wpOJuWQ+gx5d71XAZQWUu7ZLdLKBFS6h7rt9+AzxGat10sbSeuh+RVkeKnLYmnqD9tetaPIRmuW4POSXU2RYYLzJ6X95NTIVoTY8K05g=
Received: from SJ0PR03CA0377.namprd03.prod.outlook.com (2603:10b6:a03:3a1::22)
 by MN2PR12MB4422.namprd12.prod.outlook.com (2603:10b6:208:265::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.25; Tue, 10 Sep
 2024 06:06:00 +0000
Received: from CO1PEPF000075F2.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1:cafe::e2) by SJ0PR03CA0377.outlook.office365.com
 (2603:10b6:a03:3a1::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.24 via Frontend
 Transport; Tue, 10 Sep 2024 06:05:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1PEPF000075F2.mail.protection.outlook.com (10.167.249.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7918.13 via Frontend Transport; Tue, 10 Sep 2024 06:05:59 +0000
Received: from ruby-9130host.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Sep
 2024 01:05:57 -0500
From: Melody Wang <huibo.wang@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Tom Lendacky <thomas.lendacky@amd.com>, Ashish Kalra
	<ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>, Melody Wang
	<huibo.wang@amd.com>
Subject: [PATCH v2 6/6] KVM: SVM: Enable restricted injection for an SEV-SNP guest
Date: Tue, 10 Sep 2024 06:03:36 +0000
Message-ID: <82c10ab0083736024a916db479517154f7a01373.1725945912.git.huibo.wang@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1725945912.git.huibo.wang@amd.com>
References: <cover.1725945912.git.huibo.wang@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB03.amd.com
 (10.181.40.144)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F2:EE_|MN2PR12MB4422:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ffd7be6-eaec-45af-abd5-08dcd15ea441
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yAyUvcpV48OabhhCKMv+BmXqr7Z5so/YQIyiBYXKms+0ZypokszVTeEeaTZU?=
 =?us-ascii?Q?fa6zwL/y7sSrkvysfaVokAfPMLabPuhEiXv4MnhudX8yXrbrbuIfsGCcqFPs?=
 =?us-ascii?Q?1pKQcBOIOMHxWY5H8m45HC2PAMpZ5Z21HLKlJl2mE6NHvTsm9xNg6P+ij/Yh?=
 =?us-ascii?Q?SLok8icsIez9AXsWKG1sG9UwDrk2mmxKTetOiBybFtCjX83UydHMN1Bd6+Bm?=
 =?us-ascii?Q?LRd9Acm2sjzkA1RdSOhxsyhRtF5glGO0VxMamNBBYwLV1wLpflv3s6bqy0pr?=
 =?us-ascii?Q?tIhJfn89o+NKGlGivM7QgcmoQgOey7WrmIxnnEBlRh/CnpJ9TnL3ERtW7glZ?=
 =?us-ascii?Q?Pa+y7QEGWLNNImezgRSWeTVcAbWo82dp7FNnkuMSdWtcGZKSve+u7z2Q4/6H?=
 =?us-ascii?Q?jRZuSicYglWO7GzjxarSyADZ/wwhXS9dheXqX4qF7AKM7PFvYLmg0Iunv+tH?=
 =?us-ascii?Q?1FuTWgmO5QGhoOExVA5NhqM+byHFJmRYaYoLCPGb4Ydbm17JIBB1ueFOGZYN?=
 =?us-ascii?Q?6jslTTTcXJNsu33fM1ihPzrb5CTmU7iqfz1yBOv4Dk0+srnJQDtCdr1VjZUM?=
 =?us-ascii?Q?R5QToxubK81UJKyYowF46Kq+93Rf+q8Dz9uDW+JcHvd7SN1Nayyzxbe87HS1?=
 =?us-ascii?Q?9z+RFaJzgEtvPUXHXGKPUWCLm/HGKtxxzTrV8wm5UrJihnVhjP5PWDHAcQFS?=
 =?us-ascii?Q?dYgQqdlTDU4YTwqIf6HIrGf6FQpX+rGw0Y1vQE0iDa7Sm0VPGy1Z7k9CLQYH?=
 =?us-ascii?Q?OULW3LPLWKKwUvbYLya9g4ErVTXlkJw3Ezu7SXu57M6ZfgYQbietKYzuhbwh?=
 =?us-ascii?Q?lvTqBQ4NFbdM5pAlOFCTMDH1El8QJc2iOojzmPPUKHjRjVieSl1M6ookDNlU?=
 =?us-ascii?Q?IiQ+qGIiPVIXe9+3meFp24bt63kN8pWWsahAJOnSm6ZfSeqVZA1w+phaKFmj?=
 =?us-ascii?Q?5NbQxNMML0utZgCyVn7fwyflQKd2yPSO1P7oOm9SCbA2TUFnq867QPE0Jx2k?=
 =?us-ascii?Q?0IHx0lRkpWkgmrSnU2ORO3fx4GTHpqJLUgXj8SdmONtuyXHWbgGEF4tmuFan?=
 =?us-ascii?Q?3whav8fnDx9eKWgi951DeDjmFoW889ss0dggpNScSoX4Lj3EJm45EWtYsN3L?=
 =?us-ascii?Q?Gh2piXm2JVZDwc6XWg1LIcO+t5AbK3d9/5at9P6wzLSAuvWHvZeF3Ieqt8m7?=
 =?us-ascii?Q?1OwH4h20mKvlQrUK9x4zJvwtf/XcjLXhWltJEbC3gKmtOybXWQxzA5pz+kMD?=
 =?us-ascii?Q?enMlskqw8sHAA+zct8oynIebSv/z+gHHCbscP5pxl9RqKMB5pjNnKUgQY2Bd?=
 =?us-ascii?Q?Cai3o/BNKWuKhtSN605wwQe5bMn7oUd6WFXo5OZLeaN7kPRAb1fCL8RegbNn?=
 =?us-ascii?Q?PKO1iLEVRu6TvTAKXW4Hiv1MrLQF+7OB6DvK9Mce8NEz3IzaqrnUH88wdX8m?=
 =?us-ascii?Q?/rxMv4RcgLVt+4HA8vqnqCdmpVKEC5KI?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2024 06:05:59.0791
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ffd7be6-eaec-45af-abd5-08dcd15ea441
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4422

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
index 0b898b16026b..bad50378c898 100644
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
@@ -3079,6 +3085,12 @@ void __init sev_hardware_setup(void)
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
@@ -4556,6 +4568,15 @@ void sev_vcpu_after_set_cpuid(struct vcpu_svm *svm)
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
@@ -4613,6 +4634,9 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
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


