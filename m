Return-Path: <kvm+bounces-42896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BC25A7F9C7
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 11:37:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BAA4E171C0F
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 09:36:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA0D4267F45;
	Tue,  8 Apr 2025 09:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="nFoJ8+x9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2042.outbound.protection.outlook.com [40.107.237.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C8F26773C
	for <kvm@vger.kernel.org>; Tue,  8 Apr 2025 09:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744104769; cv=fail; b=ubpj+QZg7pqhjWRugMW6gCVX3icidTxlpyuRSb4yOkvYR97LGS6xjxLfuInSnCffn5NaS/w4pZoOujt/wPRBCrilGR3ZHdbz6rgQEFPwQZNKlqCfSrs1mLI71xPW+ISZHoDjaa/obirtuIKV4K3A0YlizJ8Wbek9O6RK5SKvFjQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744104769; c=relaxed/simple;
	bh=ivO57DsrV4PlXxT4GtBS1ELfk7FGsxT1JVBdm2lug/s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ntPcbT52XzGwwpv78xp7uQYG+txVeOuabvJHBOAU1osvNcv3zYFBYELjZ7e/A+d45ftOqwF0JtIKaw7I41bRq2Z3JGfs52dLiW8Z3YmvmS9k4bh8GBfqHS2iGRRoQEH0vkbuCcIVS+4/JbopOMH+5Na58vU/Rqfp+Xi2ijDllNA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=nFoJ8+x9; arc=fail smtp.client-ip=40.107.237.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=crdaE/10KT5CppLPbJB4IGJ9E7bm+e2k9FJRDwNvr1RHOimW/rfq3+DPCa+LUAsKN2qa+7mqL/jNr/2Vzz7+VDth6a8rnte5ToFkxcwNC0UPh0gfvXG+G4RfDlCREjJwrjRwPFb3S3aXecmZq/DZbsdvn6XNLV4y58G3s2e7fdd+YYwixA/zszrPKu4Rv3CPSNgLJyNpwI8GefbDMngncrHj6CIsfB+IUhlUi7uUybfYDHS6Dw5plXSP9hoItbIt+1RslpggVRpmyEpy3tRNoLkO958WwBSOLKYRQSzwTCI/M7teRxWm5OgY7fA6lEn/i5XJC2q9KgL0BcbxjojBQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B6KP3Eq310VoFURFu6Os7zLd2LrmorcF/dLSgiDjGNs=;
 b=DN1nVMe2cmnxecAcnvYqqx8MfZ+wUBXJFtUVKFxDMpcZiQ6cQHL2IddmUL5s5swoe7fC3hIy03zRXLuVU59D5YyNA7WMRzl7qksq/vJ6CFA8+ffmWw4FYzvPTwmZXhK7QbtnQI5lRbFT46epRK8KAoTVB1dax0k4tkkx4av30qHIIwQq/9VZ87YJK3JyrQmu53leA6SszfWjxyAnwjK6vqOKp7DOerOiovTDEywmifjd+/fdI/eSD4ZDXkBoaP7gX5wB/MpFwulKdYI5AzrOSfLIs9tVmNuQuYtawD1IVPEF/jD6wYwHwtQbsPXfUV5tNqmmNDWNUBL48AAl9xQgBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B6KP3Eq310VoFURFu6Os7zLd2LrmorcF/dLSgiDjGNs=;
 b=nFoJ8+x9yzgBYA26BtzrsDyWvq3/Z+Q1ZW4oNkH/7gbGEFdoV63gIOXRttfaCPjT8tc/HUZ3Wkf1ubMMUYwwkdgxs74eorvBLpjtn9N/rmPfB1ckwYnxvCBg0m3UiX6o1qWG0u5V5Hp6etba0KtWEvsQnKjzaPwsLy9ZJVl8VPA=
Received: from SJ0PR03CA0096.namprd03.prod.outlook.com (2603:10b6:a03:333::11)
 by PH7PR12MB8053.namprd12.prod.outlook.com (2603:10b6:510:279::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.27; Tue, 8 Apr
 2025 09:32:44 +0000
Received: from MWH0EPF000971E2.namprd02.prod.outlook.com
 (2603:10b6:a03:333:cafe::ca) by SJ0PR03CA0096.outlook.office365.com
 (2603:10b6:a03:333::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8606.33 via Frontend Transport; Tue,
 8 Apr 2025 09:32:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000971E2.mail.protection.outlook.com (10.167.243.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8606.22 via Frontend Transport; Tue, 8 Apr 2025 09:32:44 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 8 Apr
 2025 04:32:40 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<nikunj@amd.com>, <isaku.yamahata@intel.com>, <vaishali.thakkar@suse.com>
Subject: [PATCH v6 3/4] KVM: SVM: Add GUEST_TSC_FREQ MSR for Secure TSC enabled guests
Date: Tue, 8 Apr 2025 15:02:12 +0530
Message-ID: <20250408093213.57962-4-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250408093213.57962-1-nikunj@amd.com>
References: <20250408093213.57962-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E2:EE_|PH7PR12MB8053:EE_
X-MS-Office365-Filtering-Correlation-Id: bc3c8862-fd49-48eb-fda2-08dd768050f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JxoM4swtyBr5MDkh61ZgwJFf8n0OiNM3y+HHntoSdJxFri02vr1BuL2KI5Tb?=
 =?us-ascii?Q?jVyxB3wZLYLQgg5Bf14Fz9S1KCa0/O1z7BAaFUT0tj/8bnmvvH3Q41KOnNay?=
 =?us-ascii?Q?mRPomQC5SyoKf0zjl82kcNlMSxSOO/xN5dq8o4lSP9B41YbhZoQevcPjY0Hd?=
 =?us-ascii?Q?aYReUUMhw/QPnBSYp7dNIjAbT+iwj2TEfJzLllYgltSX4lfsrdSPG0ovsOSB?=
 =?us-ascii?Q?zAmydDBn/7MVhY1kFuyIMv8Bp+TIyIGIT0wrmqMK01/oBHMzY5UaFhbg3Jno?=
 =?us-ascii?Q?gf8oCL2Mrh2uObjCfcKiCnoRewucJicpBn+s0mKRlFCQ1z2rKyjhPh0Itmdi?=
 =?us-ascii?Q?fXdrqW0UZrHtpXAuEVinr/tEM52P4R7kRwBgGeYkr2yC96hY7LWfjeeci9hw?=
 =?us-ascii?Q?FNnAthjdp1cZIXBHy1c9+q3Zsz/dZYgMbu1bsj6W7PwyetUyjBU7IQvBtUFz?=
 =?us-ascii?Q?NlAXFSbABZkRF/fErmXvwl2vrYRmkoV4dOJzH8UZojGIow7AFVHU8YBXSr5e?=
 =?us-ascii?Q?hZscC+942tj0Q/lAavZYHiCVU6if2cmn0H5G5kQWWr+iWuqrJB9jZtd1Px4n?=
 =?us-ascii?Q?h1jFRWjGlBFswwtLlY1HOGEqA3cUDHvTrgnAtcnCNSghj/IdbxOJUaZiQFQJ?=
 =?us-ascii?Q?M9dMSufW6rVMcKtmsOx51/AvKnlxPHiDHLDyaqD2UfirmXerKw6KU+lHzDj3?=
 =?us-ascii?Q?3W/LQloMGvtn7yRz8sgQMU9quiPKBTgOgevRWED7s9uifMuOHW5/dLGcUmRh?=
 =?us-ascii?Q?VtjMdaOh7S03Vq8XacAg8+nz0J9PQGUdACosUHlGtTauAXVtAca20H56HoeQ?=
 =?us-ascii?Q?yNyAFa8x4McLAyQNznKz1oL2TRbvG8Xoi+nJYmyX7kHcu9L2Qr3C+AuYT4iZ?=
 =?us-ascii?Q?0WSsbSbmjuZquIaNOOvAMZjB8Vzkh6Xce7E9eqGo92/dmYKt7s4BnF8NIJsi?=
 =?us-ascii?Q?nuZDul4PcDAgUr4qWg+0FUIUFQ2LL+4gQ6anylPVLAytKwIcp7Gf0q0Rv8jF?=
 =?us-ascii?Q?jM8g221kuW0u7FW5zyMhnCeko77Yo4WNQUBcMpQSTJ/XiRQjhWBfP2KlWVr4?=
 =?us-ascii?Q?1YyawGbly6hOSmS/XmvGscB4bJ4mxhQVEAwF9TDIyCz6jrR9nigQFWupVUw4?=
 =?us-ascii?Q?DiWVsGjFZx5Gr5x9qJQ0U1xVJBpr6pvdVYeCGJTll8zSrPQiSypEEQogtQ5F?=
 =?us-ascii?Q?VnXaF6Os2CLVbihSJwHD238K45XzsdvkFw1YfSjk0/2euTn14zaatY2s2rEX?=
 =?us-ascii?Q?22I5LqbSnRqV3tslSp0zn7i1KuybyDlsRme190T27z9QsYEwwfR0Yaquu1Uv?=
 =?us-ascii?Q?EewvIyOuusLQz29h6ycfg7Be9Yif7G0UQNNYgNwDN3aqcA9gUVL+Bk9SVOtb?=
 =?us-ascii?Q?iAzWE/fFm0N0pt940W8O9tPhLPLplNspziDwgbNhsZiRHkFIDUZQ+AnTmBNQ?=
 =?us-ascii?Q?zM5/H8tueMsTjJLUTmoC+pRFAqHns8rQMI5P05nVXkIwKSEr3hzIp5E1g1s1?=
 =?us-ascii?Q?DG3m2FylqbWyEiM=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2025 09:32:44.1105
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bc3c8862-fd49-48eb-fda2-08dd768050f5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8053

Introduce the read-only MSR GUEST_TSC_FREQ (0xc0010134) that returns
guest's effective frequency in MHZ when Secure TSC is enabled for SNP
guests. Disable interception of this MSR when Secure TSC is enabled. Note
that GUEST_TSC_FREQ MSR is accessible only to the guest and not from the
hypervisor context.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Tested-by: Vaishali Thakkar <vaishali.thakkar@suse.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/svm.h |  1 +
 arch/x86/kvm/svm/sev.c     |  3 +++
 arch/x86/kvm/svm/svm.c     |  1 +
 arch/x86/kvm/svm/svm.h     | 11 ++++++++++-
 4 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 9b7fa99ae951..6ab66b80e751 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -290,6 +290,7 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_
 #define SVM_SEV_FEAT_RESTRICTED_INJECTION		BIT(3)
 #define SVM_SEV_FEAT_ALTERNATE_INJECTION		BIT(4)
 #define SVM_SEV_FEAT_DEBUG_SWAP				BIT(5)
+#define SVM_SEV_FEAT_SECURE_TSC				BIT(9)
 
 struct vmcb_seg {
 	u16 selector;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0bc708ee2788..50263b473f95 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4504,6 +4504,9 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 	/* Clear intercepts on selected MSRs */
 	set_msr_interception(vcpu, svm->msrpm, MSR_EFER, 1, 1);
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_CR_PAT, 1, 1);
+
+	if (snp_secure_tsc_enabled(vcpu->kvm))
+		set_msr_interception(vcpu, svm->msrpm, MSR_AMD64_GUEST_TSC_FREQ, 1, 1);
 }
 
 void sev_init_vmcb(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8abeab91d329..e65721db1f81 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -143,6 +143,7 @@ static const struct svm_direct_access_msrs {
 	{ .index = X2APIC_MSR(APIC_TMICT),		.always = false },
 	{ .index = X2APIC_MSR(APIC_TMCCT),		.always = false },
 	{ .index = X2APIC_MSR(APIC_TDCR),		.always = false },
+	{ .index = MSR_AMD64_GUEST_TSC_FREQ,		.always = false },
 	{ .index = MSR_INVALID,				.always = false },
 };
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index d4490eaed55d..711e21b7a3d0 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -44,7 +44,7 @@ static inline struct page *__sme_pa_to_page(unsigned long pa)
 #define	IOPM_SIZE PAGE_SIZE * 3
 #define	MSRPM_SIZE PAGE_SIZE * 2
 
-#define MAX_DIRECT_ACCESS_MSRS	48
+#define MAX_DIRECT_ACCESS_MSRS	49
 #define MSRPM_OFFSETS	32
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
@@ -377,10 +377,19 @@ static __always_inline bool sev_snp_guest(struct kvm *kvm)
 	return (sev->vmsa_features & SVM_SEV_FEAT_SNP_ACTIVE) &&
 	       !WARN_ON_ONCE(!sev_es_guest(kvm));
 }
+
+static inline bool snp_secure_tsc_enabled(struct kvm *kvm)
+{
+	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
+
+	return (sev->vmsa_features & SVM_SEV_FEAT_SECURE_TSC) &&
+		!WARN_ON_ONCE(!sev_snp_guest(kvm));
+}
 #else
 #define sev_guest(kvm) false
 #define sev_es_guest(kvm) false
 #define sev_snp_guest(kvm) false
+#define snp_secure_tsc_enabled(kvm) false
 #endif
 
 static inline bool ghcb_gpa_is_registered(struct vcpu_svm *svm, u64 val)
-- 
2.43.0


