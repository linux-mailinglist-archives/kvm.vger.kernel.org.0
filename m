Return-Path: <kvm+bounces-53893-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31F87B19FCB
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 12:38:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E20343B95A6
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 10:38:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BCAE24BD00;
	Mon,  4 Aug 2025 10:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="oNdaZNxi"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2061.outbound.protection.outlook.com [40.107.220.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F4617CA1B
	for <kvm@vger.kernel.org>; Mon,  4 Aug 2025 10:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754303913; cv=fail; b=V0KOo8+I4J6RBAnbIa4umpos+aUPyXfD54+RMAmcmEUXNDxTjMdXXSbTMXgsDwmjItfi2Y9XwTzaNRXugzkRFaZVOo8ShmuK0wB95IbPPzxjV7WI92/b/PXGD4HMpz7c6c139PTQvjSShJ5m37X7VpJzcjKm28b0L5uQfzdmpO4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754303913; c=relaxed/simple;
	bh=2GQrrMMFrSgf35seUYil+as0mS/SVlhzXlFeAbOZJA8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NUmaMlAy0ZDjWZOsyJI74wxsMcMxAyb2iIyGcMUm6Ttz8vya+yhphg7S10t/QWsAD6kuxjqfhKNeR9BGwlwVEkUObNJ1i+bziAo6n+kW7Ui4D9VrjTkWUnaXe7DawhSwJTzVKrDhX/8YInv8FqPH2bv/B7boxdNwSKvR0afWs9k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=oNdaZNxi; arc=fail smtp.client-ip=40.107.220.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e19uDgU9MSZ0jNwofCizku7PX19xsVR2Pgp/5bTvZ7XfxCYdOrDkXALWKnDR3wHtClTAiSV02GpCRpsaB6x1NZ2jx1qE9QsAQiNCFsheKgfujG7y9ZIsnyMSxmGj+ycQCzovBg7Q81LihenU2bQ+7yaMSXy+vmLPc+7ek9SMIdg74HykkR2SDs/L/6d97xWbQqYIrmPO57IRd4pmfSS6pxEEAHocXFlkTIPFFSz4Wo0RBymD2XVssG6QxULfO1vdQhmRukNzghpHJqR/tBdo1Teij8QutVXz/DGlZB/exU5ognVAoJFGS5BaqgnkO96gbr7LaVtqmsHaraj5vT8yfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rgoCaVZDNaDezV8ibtEbn9wO2+if1jUnj3eCygrLy/c=;
 b=V4aLFyZjsDMKQ+LTVXMxQQid9zT9nPb2pn1m4Tbn7jYRjoHfeKoBE2zwFaJN288qlXaLiaq2NrWVB3yHgzQA44/2ckGZ2JdeGaOAkKBYKSknaPDimekI6554j4KMLyBYEMAVPiHJ1LuxqXJ9u96qW3YbM5DaZRg+Tuu/TOyBljLCeG3rN/7T2rj9QA1CSmnzT7TLz2ao6i7XzgqWWfYatBkM5NMqzUKkBMhv+JMyxCQl1tZ8LxY2+jduvwYHDzJGnjceQfGullewYMyLY3eou9lXkT1YrbLLzc/MJspbl0heritlEAOzYZ2YQVuycRS6Mt12twf8GyiVnuc5jBqrEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rgoCaVZDNaDezV8ibtEbn9wO2+if1jUnj3eCygrLy/c=;
 b=oNdaZNxixoHN3i18rTe4uhMQ/JtbvRyzjoKSz03chXnVZi6hzzkC32pKoDR+DvtZNQCm/a+yQTeS4UhTS5T5shVsNQa7NJ4eww3ROY+w326q0WSAvDw6gQ/tO6bUX9Bnq+iZD3S7UcIfMVMwgiZJM7bF9zMm3GMf7M7UVDRW5x8=
Received: from BN9PR03CA0604.namprd03.prod.outlook.com (2603:10b6:408:106::9)
 by SJ0PR12MB6781.namprd12.prod.outlook.com (2603:10b6:a03:44b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.18; Mon, 4 Aug
 2025 10:38:26 +0000
Received: from BL6PEPF0002256E.namprd02.prod.outlook.com
 (2603:10b6:408:106:cafe::b1) by BN9PR03CA0604.outlook.office365.com
 (2603:10b6:408:106::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8989.21 via Frontend Transport; Mon,
 4 Aug 2025 10:38:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0002256E.mail.protection.outlook.com (10.167.249.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9009.8 via Frontend Transport; Mon, 4 Aug 2025 10:38:26 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 4 Aug
 2025 05:38:22 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<nikunj@amd.com>, <isaku.yamahata@intel.com>, <vaishali.thakkar@suse.com>,
	<kai.huang@intel.com>
Subject: [PATCH v10 2/2] KVM: SVM: Enable Secure TSC for SNP guests
Date: Mon, 4 Aug 2025 16:07:51 +0530
Message-ID: <20250804103751.7760-3-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250804103751.7760-1-nikunj@amd.com>
References: <20250804103751.7760-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0002256E:EE_|SJ0PR12MB6781:EE_
X-MS-Office365-Filtering-Correlation-Id: ddd94789-790d-4509-6227-08ddd3430b4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GkqnefD1mVrY06Ngmz+kHh6QnCHqZpjFPOcLoCMidC9tFN3mj7ehqNflh8YL?=
 =?us-ascii?Q?Y2a2nXmT4h8kDpK8hXcd+Qsfj7F0J/GmoLoZvhkW9uZzIWIOhH+NZCqp8nLg?=
 =?us-ascii?Q?OkBVBfpx102pl2l4mwWr3/IFknFUz8SVIctLRPCZOKHtgDLdVSyQBnN0yWhM?=
 =?us-ascii?Q?pFN3zXRPyYOL90uMc7ovicBDhP0BrB/15tz2huXO/ozBDcedXJkKb929C/8w?=
 =?us-ascii?Q?+HqV36Y+wHjt5AUzh2yFxiypsOj38NzMmszaHOZndCMLrCYBhSPlPJdp7uwW?=
 =?us-ascii?Q?+e9C8eNDRZZxzba3Yzj9xKoML2WW+1+Fkt/QCAbOxpo8KyUZRozM6m6xcgxo?=
 =?us-ascii?Q?fA8jR10M/VDCl94uE/4Bzx/qzWbJEL9W+sdRA2cQFLp6y6WIoutuTzTDV8Cv?=
 =?us-ascii?Q?RWGgBSijoPqsEpXp23d+6J73rO86mtRxuBzmXqXh55RFvlSCaA/GoBvy1Nel?=
 =?us-ascii?Q?aWo02v02roGhfckKscuOWQsYifwZLipXtPOmo0w6ftHZFSSnxo3blAXpxSF9?=
 =?us-ascii?Q?9WBD3B2YwdqN7iZuN2BLZndzymUOObcaDT5HsU6E5HDMc6k0N+mWw/nXoTnA?=
 =?us-ascii?Q?RwF6HpPHsb+Sn4FBnnqHvmsuVsE1pJ04DY2ciiTknN2RA9Vi0dNyHf161QrP?=
 =?us-ascii?Q?duVm3li9eYo+nqYy1ri3d+bRzFawylqufNjn5FnC0ZPiSdOqN7TiRB4Mqx0F?=
 =?us-ascii?Q?KVP7v9Y7hy0OnCfeMsEmEkXe95PR+HvQgBbFtzUVu6NjV1ZZqs0In/JAXBma?=
 =?us-ascii?Q?30oHwxxUYjk9glH7ecHw6RuqyfE+2crbR2cMr83cJvI6dqRRBwnpFTZ8WqPs?=
 =?us-ascii?Q?foCz79avzkg82hBVnKsUg4VdizFWJKDQRHVEyb1CY4cURl5eMooBWcUxwJQ5?=
 =?us-ascii?Q?FH789E0juP+IBau83Z6S0jqZji8gdMgGBqDebRAu3toQ4gj95G2vY4hpB4va?=
 =?us-ascii?Q?HTNlGsliMXDpz+oupR7l8I38lckTlbsl2XQHMKQ0dmnwUdiRidvcV8+oTMcM?=
 =?us-ascii?Q?1y5hQ+XVKKqWuoOEVJ2iYMW77TBP2cXGxyzYE5spskw6RbvssUvc8bCaP/CY?=
 =?us-ascii?Q?Idt4jfjCZIaYoOZE9yElP0reuHsmlKtRixujlY1xLgGxgLK4r85kSOpH5m5j?=
 =?us-ascii?Q?AvU/FnXXWzoe93kblH8ijlSq/K4ToCRTRe2KshVq42E92Qkk0kAwyaf/njzi?=
 =?us-ascii?Q?w/SugDFSsM5Ifn7B+oAV2PTHcorGoiLi1jjKmWGj7oldMWPJuUjOc5dLqg8u?=
 =?us-ascii?Q?8yOdQZv4PB/btb7rK2PoOvnizq8TgForcIEgmjiKreCJSkfBLxpar5fr1xQp?=
 =?us-ascii?Q?2h8MzHdtiwOHIerP+i4OwWYJN8nLwRPpvPxOU8wdV3q4HFNcmPe+gFV5w3Mg?=
 =?us-ascii?Q?nn3DTHMeehl732ATxgUVr0cmGA317+vBrfI/QKOiqqBfNDncbSr6+62pKwrB?=
 =?us-ascii?Q?T3RGIJieNKXFa43FceWtm8d26yynQjeJIR4E073XKKrPdvlzX6l6PzqdgXLj?=
 =?us-ascii?Q?dPyWsNddFBwPaK7SCQ1EYdDMzWjSLT+UBkHS?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2025 10:38:26.2061
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ddd94789-790d-4509-6227-08ddd3430b4f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0002256E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6781

Add support for Secure TSC, allowing userspace to configure the Secure TSC
feature for SNP guests. Use the SNP specification's desired TSC frequency
parameter during the SNP_LAUNCH_START command to set the mean TSC
frequency in KHz for Secure TSC enabled guests.

Always use kvm->arch.arch.default_tsc_khz as the TSC frequency that is
passed to SNP guests in the SNP_LAUNCH_START command.  The default value
is the host TSC frequency.  The userspace can optionally change the TSC
frequency via the KVM_SET_TSC_KHZ ioctl before calling the
SNP_LAUNCH_START ioctl.

Introduce the read-only MSR GUEST_TSC_FREQ (0xc0010134) that returns
guest's effective frequency in MHZ when Secure TSC is enabled for SNP
guests. Disable interception of this MSR when Secure TSC is enabled. Note
that GUEST_TSC_FREQ MSR is accessible only to the guest and not from the
hypervisor context.

Co-developed-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
Signed-off-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/svm.h |  1 +
 arch/x86/kvm/svm/sev.c     | 27 +++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c     |  2 ++
 arch/x86/kvm/svm/svm.h     |  2 ++
 4 files changed, 32 insertions(+)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index ffc27f676243..17f6c3fedeee 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -299,6 +299,7 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_
 #define SVM_SEV_FEAT_RESTRICTED_INJECTION		BIT(3)
 #define SVM_SEV_FEAT_ALTERNATE_INJECTION		BIT(4)
 #define SVM_SEV_FEAT_DEBUG_SWAP				BIT(5)
+#define SVM_SEV_FEAT_SECURE_TSC				BIT(9)
 
 #define VMCB_ALLOWED_SEV_FEATURES_VALID			BIT_ULL(63)
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index e88dce598785..f9ab9ecc213f 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -146,6 +146,14 @@ static bool sev_vcpu_has_debug_swap(struct vcpu_svm *svm)
 	return sev->vmsa_features & SVM_SEV_FEAT_DEBUG_SWAP;
 }
 
+bool snp_secure_tsc_enabled(struct kvm *kvm)
+{
+	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
+
+	return (sev->vmsa_features & SVM_SEV_FEAT_SECURE_TSC) &&
+		!WARN_ON_ONCE(!sev_snp_guest(kvm));
+}
+
 /* Must be called with the sev_bitmap_lock held */
 static bool __sev_recycle_asids(unsigned int min_asid, unsigned int max_asid)
 {
@@ -415,6 +423,9 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	if (data->flags)
 		return -EINVAL;
 
+	if (!snp_active)
+		valid_vmsa_features &= ~SVM_SEV_FEAT_SECURE_TSC;
+
 	if (data->vmsa_features & ~valid_vmsa_features)
 		return -EINVAL;
 
@@ -2195,6 +2206,16 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	start.gctx_paddr = __psp_pa(sev->snp_context);
 	start.policy = params.policy;
+
+	if (snp_secure_tsc_enabled(kvm)) {
+		if (WARN_ON(!kvm->arch.default_tsc_khz)) {
+			rc = -EINVAL;
+			goto e_free_context;
+		}
+
+		start.desired_tsc_khz = kvm->arch.default_tsc_khz;
+	}
+
 	memcpy(start.gosvw, params.gosvw, sizeof(params.gosvw));
 	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_START, &start, &argp->error);
 	if (rc) {
@@ -3085,6 +3106,9 @@ void __init sev_hardware_setup(void)
 	sev_supported_vmsa_features = 0;
 	if (sev_es_debug_swap_enabled)
 		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
+
+	if (sev_snp_enabled && tsc_khz && cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
+		sev_supported_vmsa_features |= SVM_SEV_FEAT_SECURE_TSC;
 }
 
 void sev_hardware_unsetup(void)
@@ -4455,6 +4479,9 @@ void sev_es_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 					  !guest_cpu_cap_has(vcpu, X86_FEATURE_RDTSCP) &&
 					  !guest_cpu_cap_has(vcpu, X86_FEATURE_RDPID));
 
+	if (snp_secure_tsc_enabled(vcpu->kvm))
+		svm_disable_intercept_for_msr(vcpu, MSR_AMD64_GUEST_TSC_FREQ, MSR_TYPE_R);
+
 	/*
 	 * For SEV-ES, accesses to MSR_IA32_XSS should not be intercepted if
 	 * the host/guest supports its use.
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d9931c6c4bc6..a81bf83ccb52 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1317,6 +1317,8 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 
 	svm->guest_state_loaded = false;
 
+	vcpu->arch.guest_tsc_protected = snp_secure_tsc_enabled(vcpu->kvm);
+
 	return 0;
 
 error_free_vmsa_page:
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 58b9d168e0c8..acb00e0fd564 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -869,6 +869,7 @@ void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
 int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
 struct vmcb_save_area *sev_decrypt_vmsa(struct kvm_vcpu *vcpu);
 void sev_free_decrypted_vmsa(struct kvm_vcpu *vcpu, struct vmcb_save_area *vmsa);
+bool snp_secure_tsc_enabled(struct kvm *kvm);
 #else
 static inline struct page *snp_safe_alloc_page_node(int node, gfp_t gfp)
 {
@@ -905,6 +906,7 @@ static inline struct vmcb_save_area *sev_decrypt_vmsa(struct kvm_vcpu *vcpu)
 	return NULL;
 }
 static inline void sev_free_decrypted_vmsa(struct kvm_vcpu *vcpu, struct vmcb_save_area *vmsa) {}
+static inline bool snp_secure_tsc_enabled(struct kvm *kvm) { return false; }
 #endif
 
 /* vmenter.S */
-- 
2.43.0


