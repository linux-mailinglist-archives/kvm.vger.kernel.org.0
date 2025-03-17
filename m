Return-Path: <kvm+bounces-41164-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 306C1A63F8D
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 06:24:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AEF547A6EDD
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 05:23:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80097219314;
	Mon, 17 Mar 2025 05:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PgvSFZEM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2047.outbound.protection.outlook.com [40.107.93.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D39219300
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 05:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189017; cv=fail; b=O00ov4CiRw9TG+n1CgdvGYKc/nz6rCSJisgMfC8X8/EjNvkLKri+h7+5hEk4YrEmBANh0lsUthBqxE4apsQPBu8gKbV8t9bIoWNKPlNCJMmtqiRy7Fo9Jve5827oBUmve3UQWRcoupR1yQTlLNcM9hdbZ9hQRFOzRXyrpOgtz+o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189017; c=relaxed/simple;
	bh=zXutBtyD9KHws3btgvu4qkirKp2/rbfKj1wDaZwZIHI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lNCcXPXJXL+5yPjDPwzpseKiKsioGmT411A9AsYqH5ho5iRUE7cRs+tQJ8vS+b3It6cuE8oMwAViK6Za8RzsAplWvP3KLWyaEJTNvy/6S6N0Xxk2YaqQy5zZq+SlfAucTLdqA6QuyKrIsnTAgmBVn/g35V1v9TEFOYV8gyBU7vk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PgvSFZEM; arc=fail smtp.client-ip=40.107.93.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZG2WOpgC6v4ipFOOu0piC/nsn6C0aymVwrns3yu74zAo0E6NriFgXDZfz2OmxlhZvVd8eSooLvq9w6nXfsOyHE3//dMyZtURbAD/t/KV3wpC0/icuv7ulYClgfzHKFElT1bFkayiX5LneUnqGiD8ay5DQZuCobjt33wJ1q5hIGdHYd/MWzovs+KkcZ00pezL6h8wFKm/z4hzRaZoIj9Kw8KZtPd+9TKWiDKhJlTAAiqcsRGwp36rYSuqCdXaE06iGaANXJTuEUjxwXJIY+g7rqEvnAyEKXzC9ZSAqnrxK/N7+uf5vzpbHP92urJu6lWgbJkJEt3RIYuk5Cq2bjwmIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sn86BFV0XW4qVryGzXmhjyRn7AbQUwDZWnSiXBLKbec=;
 b=u1PSTWPfW+fU8OvXOquriTsXT0hHeA0ATObu6eEBvE6QV3JIrbJGQ+x/WnLAY3UnAISDNnC5KeItmdFG2e8YpUbo+OQd7SGXC+vWCor2CxGIJA18vcc6GHRkj6YuQA6Y+xFFo8iqIbH4NOzIAV66f3603JKNqlfGAyQSgPouZD7pVGOxQYSvcJM9uhEZiuNeYZJCaCuvrc4o8X/XoL6Gw6cwT/1THvbj3moXoBEBp/9xuNOKobHVxXeXxB3LiybHWpFbao7sSv6iThKYqfjGRRljdgDwcu2h5jJuHrAdkI2nUB11I8wO7ieYBDtNfjSzEE5obQMl01OW79wnOoH82w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sn86BFV0XW4qVryGzXmhjyRn7AbQUwDZWnSiXBLKbec=;
 b=PgvSFZEMg2sUkXoXfZAV6KFjBUnLVs3Ecj8kBxgNG6He2YQ0UNRRpmsZVgFU32AQJI6b36jRBZ11ZJg3gi86u/U4e95WeH1HX06Ab11Anj9tr5w005qvKGJDTGEiC90JqmRXUlKOaCau1vDtFnBhatst3bv4ZQDr0yWEdZCpxws=
Received: from MN0PR03CA0006.namprd03.prod.outlook.com (2603:10b6:208:52f::26)
 by SN7PR12MB8025.namprd12.prod.outlook.com (2603:10b6:806:340::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Mon, 17 Mar
 2025 05:23:31 +0000
Received: from BN1PEPF00005FFF.namprd05.prod.outlook.com
 (2603:10b6:208:52f:cafe::3d) by MN0PR03CA0006.outlook.office365.com
 (2603:10b6:208:52f::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.32 via Frontend Transport; Mon,
 17 Mar 2025 05:23:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00005FFF.mail.protection.outlook.com (10.167.243.231) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8534.20 via Frontend Transport; Mon, 17 Mar 2025 05:23:31 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 17 Mar
 2025 00:23:27 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<nikunj@amd.com>, <isaku.yamahata@intel.com>
Subject: [PATCH v5 3/4] KVM: SVM: Add GUEST_TSC_FREQ MSR for Secure TSC enabled guests
Date: Mon, 17 Mar 2025 10:53:07 +0530
Message-ID: <20250317052308.498244-4-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250317052308.498244-1-nikunj@amd.com>
References: <20250317052308.498244-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00005FFF:EE_|SN7PR12MB8025:EE_
X-MS-Office365-Filtering-Correlation-Id: 3984c592-4e50-4293-715b-08dd6513db3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ttg2DQAzFYte8YIdzpH5nosV9DXwr/RnO+qhWsf11EXKSh66MU5liIuyNg5n?=
 =?us-ascii?Q?0EIHfsUFtBzBmq5JnTsQIAPGey4x185eLa+5HLxsWYPNHWusy+L7GfDiCN7Y?=
 =?us-ascii?Q?g6WN6VARXQK+SdZWMcY735ofhIv0bIFyB7zuNe3qNmWRjfJ1ouO2KqIzzFkg?=
 =?us-ascii?Q?mmFJkJPZBDswdFCYhjzkOkgQYXKweb1NM3dyAmLHC/4B8940ZsAzdpLwmGKk?=
 =?us-ascii?Q?2hUp1UEThlElaPgrNi4154Vzi/ZUhays0ps1pfrIEQ2jyRs3yF++pVH+hIJe?=
 =?us-ascii?Q?BxTNOeD3yVME8UlRmHQPi8W4Vr4dHX1D1IISN9cYJAMCgjSqNNE8LR1R0N4i?=
 =?us-ascii?Q?sEr1PsQ02ToYI+PyyO1m5vBfR+GpZqFf8cA2R/3ZH0QT0EYf6s1THH75eHKB?=
 =?us-ascii?Q?siNCpto+5w3XjOc6OikpCbt4THAAYqvHNI/J2wtvBLlXAPU+6gI9Gqg1n6zO?=
 =?us-ascii?Q?cP89O3H8Jm1heiC9VNCr7nRzP5jTLbjgBgA6w/zpo7dj0RuTfwUsUwr3B/ym?=
 =?us-ascii?Q?jUJA7sdwteZTrDjSl3fFT1Kmo8uZQMC8JxT2cITzf7e0RjjOUrWzAoLTz3ts?=
 =?us-ascii?Q?mfzybcpcq/k5B+dAdK3ma1ySQR6ElvWW4E6XGiV8Wy+2pG/hNME7oPUy5zEe?=
 =?us-ascii?Q?SB2+rMtR3hp1P0a5C5coO6TBYPFWtxg8F/nxOkeMlmnB74EohMJ4gZpWh+rg?=
 =?us-ascii?Q?C5hHon2V50Um2cEEv86bPo99M7ytZPQxOpGL1r+QL7QBYZMKuhfalCpgCLsL?=
 =?us-ascii?Q?LMyGgwjpQ7OJApi30iYRRY+Isy/L/urGngOh1HFCmyrOqOSCFRqjRIl5DNG/?=
 =?us-ascii?Q?2MUuY5X7s91SMEMwWwaQqRwukRPTyIDkNAwliJwEsBSopsKnf51Rjkdblwyf?=
 =?us-ascii?Q?dEQrnhQPTbJQGi2/9ZmIxnl7oGzPWsxu7Cn8/WdbUKk18BKRWPZzix/h32OM?=
 =?us-ascii?Q?Vu/OcmjCN7Nj2Du4D+IclVNam0LuFO0+IMxqcnL3wfhZFOhQwtTqeAwYb50+?=
 =?us-ascii?Q?smTLTCoRtlK6wNBFB5j/PG3l3C2kB5JH+Prv23qb3acwTiPDU8KnKGSkRyAx?=
 =?us-ascii?Q?88mLibYRdiUxVJW24VpgFOSxBGcMOOwmFZEOHijzttchIqy3IEVCbICz/DyV?=
 =?us-ascii?Q?DohOObviCElnZW7on0JHff1qrD6IygyWizkFResHcthOLKf90+eztepLUcIp?=
 =?us-ascii?Q?ggxfs6b2HixDTPzSKx8KqCGA1Wm9BJ3+W20q/kMoqNEmBDGrRzpZh574Nfk+?=
 =?us-ascii?Q?xStqh/DXq2WhblUcFpCINPoItcfHrUKrSIuWf6aumn4QZ2Y+ZGBjXPYGYOyA?=
 =?us-ascii?Q?7g7ZKXP/DoSXMS918i2QHIm0I+MCpXH2cSRGqCamecXBVW0TwXUq1kHLL7EU?=
 =?us-ascii?Q?NLwsLBC9+smiSjl9HBT/YIWrI0Rl72RCVIfaLw8mihF9HO8+gDRuWOBbAk5n?=
 =?us-ascii?Q?HxuBhDujYWJuTBAhQBrbNL8r/BZ7rHx4Iu5/Z3GLx5jc2aoEOZjfzWSGH7uO?=
 =?us-ascii?Q?b+xT0OfOBK5ACaA=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2025 05:23:31.3055
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3984c592-4e50-4293-715b-08dd6513db3b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00005FFF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8025

Introduce the read-only MSR GUEST_TSC_FREQ (0xc0010134) that returns
guest's effective frequency in MHZ when Secure TSC is enabled for SNP
guests. Disable interception of this MSR when Secure TSC is enabled. Note
that GUEST_TSC_FREQ MSR is accessible only to the guest and not from the
hypervisor context.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/svm.h |  1 +
 arch/x86/kvm/svm/sev.c     |  3 +++
 arch/x86/kvm/svm/svm.c     |  1 +
 arch/x86/kvm/svm/svm.h     | 11 ++++++++++-
 4 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index e2fac21471f5..a04346068c60 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -289,6 +289,7 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_
 #define SVM_SEV_FEAT_RESTRICTED_INJECTION		BIT(3)
 #define SVM_SEV_FEAT_ALTERNATE_INJECTION		BIT(4)
 #define SVM_SEV_FEAT_DEBUG_SWAP				BIT(5)
+#define SVM_SEV_FEAT_SECURE_TSC				BIT(9)
 
 #define SVM_SEV_FEAT_INT_INJ_MODES		\
 	(SVM_SEV_FEAT_RESTRICTED_INJECTION |	\
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 661108d65ee7..80a80929e6a3 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4555,6 +4555,9 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 	/* Clear intercepts on selected MSRs */
 	set_msr_interception(vcpu, svm->msrpm, MSR_EFER, 1, 1);
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_CR_PAT, 1, 1);
+
+	if (snp_secure_tsc_enabled(vcpu->kvm))
+		set_msr_interception(vcpu, svm->msrpm, MSR_AMD64_GUEST_TSC_FREQ, 1, 1);
 }
 
 void sev_init_vmcb(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e67de787fc71..6e1608f04b85 100644
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
index ea44c1da5a7c..513681604268 100644
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
@@ -379,10 +379,19 @@ static __always_inline bool sev_snp_guest(struct kvm *kvm)
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


