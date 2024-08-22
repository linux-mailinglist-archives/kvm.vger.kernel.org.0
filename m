Return-Path: <kvm+bounces-24857-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 18B3295C0CC
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 00:21:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 82434B232F1
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 22:21:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BC2D1D2795;
	Thu, 22 Aug 2024 22:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SvfsJ9+X"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2052.outbound.protection.outlook.com [40.107.92.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B124E1D2784;
	Thu, 22 Aug 2024 22:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724365220; cv=fail; b=ZXgJLdOa6Hb7KFsvg2C0RWDV8wXErLFvZv7WWb/FzvD46vcxf8xcW7MOd6tyUCgfsBrFE9WYWOwfDXJrCACMFSReWcjP9kkBeWGtNqlf/TTukhqM5gw77nA3o9SHjegikpccyr1k2HYwVwEfXjXvXUOEvs1PM8lGHs/6eyOMmwE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724365220; c=relaxed/simple;
	bh=PA/c2TUO9Z1Mmu7shIya83p5q8q+3imfUSpEaCtuthc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QcTkMSKDL7uTbN/CqdV0vkrkF03BVLnJi9uuzLAlCpJKBFVdcPDYzhRakXycvVrWCGfPeg5ZCQyLR+fkXVXfxFT1gQWo4vOMfVtVZqD1EizJBC1ewCanWTM3O5XyzIphu/R7bpmoz4fmJHYvgtuP1k7hrSk6R4mHnZkKpMUp4MI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SvfsJ9+X; arc=fail smtp.client-ip=40.107.92.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ePw87cf+KOVmX7Ho+IyMs/E9vG1C/NSOlkoMNzDal4/8tNAfBUB9vunVuKo6NEO2Y+PDm+AfJ/jBcYIzzr4yQZqb0Xnmx08HI//aDRqjSb6+ZHiaTUuRqwPosKSSKBRRFwYwZ3ixW7TI9CS0Kac3zniptuSQLinTa/pGeWMjd2bV21x9fbi+6g5P3o9E47+okmTwFRqNdQ8z9bWngRQ/ygnYa5RUHjIf+S6aG/jLsz+lfwkDbsYTjjKSeIW3Hpm+GQ5PFA4DN23ULI+b7Vq2BIl/wUTTNP2B9bwb7A5J5Agl2rPJdRO3yJtoMGwvATCoYHka45kjcoW1TZdhuZ9kyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kLO6O7z7oVyBFhouM4xVUygFzC+PIOphYvYHejPI4BI=;
 b=G93hjOJWf8Mhrhtf7UjJel7gCwiEVqOJ46a18Is+tQ/B5oNXtHFrc+InR6BRqTEH0wKihIZNjP5hPW9gpTTUH/K5CfGgQ3pUV/lYwetaHqnbq2mDIEI6G+mt2ukky2vZ2VlwOsMHtkjhObNBypDMYuaKlIHSnKrTmdrS2ZeMC4Z8QdwVRnd13QLJNW2OIn+qojUzV9gXTj8ZxNa5LnuhPHH52HntNaZUkDXxgxfyZR9/1VeXrzk9Emze4f+XqSaUUiKh6C3mduVVGo0MpjVJ5c9aEug/nwNlWMCQeqVZqp0u7b51BybItTVDsj97VDtfRjZM75Pur5MKoWtYO+LHFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kLO6O7z7oVyBFhouM4xVUygFzC+PIOphYvYHejPI4BI=;
 b=SvfsJ9+XS8/SETopQ+zTNlLt1fuTCZTkrka/CHWdJ7AaeIwgnAd2tsBJYD/Fz3Zktfgr5esh79sW5+Crc6orVElo6OD+7dlUbEuxzMzwa3ebbdEVXX9ri2O5gj9muyAYp3qS/Kly9KcPG7HJjaniGRu9JR9feS+I8mlkyBGJ52o=
Received: from SJ0PR05CA0114.namprd05.prod.outlook.com (2603:10b6:a03:334::29)
 by BY5PR12MB4259.namprd12.prod.outlook.com (2603:10b6:a03:202::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Thu, 22 Aug
 2024 22:20:13 +0000
Received: from SJ1PEPF000023D2.namprd02.prod.outlook.com
 (2603:10b6:a03:334:cafe::3f) by SJ0PR05CA0114.outlook.office365.com
 (2603:10b6:a03:334::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.19 via Frontend
 Transport; Thu, 22 Aug 2024 22:20:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF000023D2.mail.protection.outlook.com (10.167.244.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7897.11 via Frontend Transport; Thu, 22 Aug 2024 22:20:13 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 22 Aug
 2024 17:20:11 -0500
From: Kim Phillips <kim.phillips@amd.com>
To: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth
	<michael.roth@amd.com>, Ashish Kalra <ashish.kalra@amd.com>, "Nikunj A .
 Dadhania" <nikunj@amd.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Sean Christopherson <seanjc@google.com>,
	"Paolo Bonzini" <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H.
 Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Kim
 Phillips <kim.phillips@amd.com>
Subject: [PATCH v2 2/2] KVM: SEV: Configure "ALLOWED_SEV_FEATURES" VMCB Field
Date: Thu, 22 Aug 2024 17:19:38 -0500
Message-ID: <20240822221938.2192109-3-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240822221938.2192109-1-kim.phillips@amd.com>
References: <20240822221938.2192109-1-kim.phillips@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D2:EE_|BY5PR12MB4259:EE_
X-MS-Office365-Filtering-Correlation-Id: e192ebd8-2a6e-4a32-f8b0-08dcc2f897a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5ESogAfz8YlmPAi5FQAs5IsVLWfeh652ZpuXoA1yqLxdnbFS0NVgx/EibQHP?=
 =?us-ascii?Q?fvCW5smkr67rT4S1KRPHCvzKMnYWdj2GK91BxEaWYy6F+FgfPH9Mg7/BlBgG?=
 =?us-ascii?Q?mgHUrYHkkGk5yqtsV8mTFFvGNhyZ6tohAvSoCQle3heqRrhnjLkHPiGGj2wp?=
 =?us-ascii?Q?t/qsmI3Q054CDFosib/f4h0HCdYVKiSkH8zDwSG+Fs9fjY8THJISmVMZtnnJ?=
 =?us-ascii?Q?oM0Kcg+oO36MjyIVInnK84KboJzK37pHXAiDw+f22Im8IBdvSEOyWbSGHEqA?=
 =?us-ascii?Q?R8VP2kIr6FZSrUlW1mk4cHmFtHWzKTCSutwnUaf5qRJqWbw8p3eKLpK2rXdy?=
 =?us-ascii?Q?8YD4JvILR18INtb0KWDQJEQYeyO4M06wcbXeTx1z570jSHr1Xn2fiib2vSfH?=
 =?us-ascii?Q?Apy4rCMI/ix1qmS8FDA71kAuJV1NdPV5EiTJh/OWlDacxlau82s4IBCSuzyU?=
 =?us-ascii?Q?KbghkNEf2zXiv+vitBN8DZ4JKfrHg6f5xqOPRyDQdipWwnQCZOxyjB0bc7GT?=
 =?us-ascii?Q?n08M7JRVxsTHcNB9hCRZPzBGZOfCbWDWMP5YO+GkK5XO9Ir6gVz9LY+eE0R+?=
 =?us-ascii?Q?ffSY7dXE9aCFzZsgyXHIwB99/dcetMkhpGm/FRDAcVnTILMbWjEbnIGyEF0Y?=
 =?us-ascii?Q?mEUfC6/UuaCtP6XNwwWgyn4/qMdMq8MjAAiC+77OLLPXGX0UWiOVSTcDabqP?=
 =?us-ascii?Q?rzLXosv1FEiqKflvWKsB+F3M1RmiWyjurB2IxHKG8eYEDLswKRddTXzS5Hc9?=
 =?us-ascii?Q?FlKDvOpigcDCrTYuMojoWlBHxpLzzI4rC2argoSQqWIV3a2BIpkr62WVACoL?=
 =?us-ascii?Q?zOnhI44MG/ybeJhD0K2JTS0HJBcu/GX8yDLdw8vpbIpM/R7awZ03fI3UBK1I?=
 =?us-ascii?Q?EcOcereD6g59ycO6URGfynBfUndpo3Sy2ewK4dJb91lgtbSDdjUoaqA+P31K?=
 =?us-ascii?Q?yBOrd/41Owk2OMWey0nrSw0pEl73wuAgyXYKJatlWDOH2TvOpqJ3qTBIalOL?=
 =?us-ascii?Q?TFPkiJA9M8A7HoJouZrTEWdP9zIRCskt7QT8v2+TIQ/6uN/M/ysnc4Pg+ka8?=
 =?us-ascii?Q?nbsrZTDHYdM1vyuGZ9YtRi9dv5QvS4t/MRSGWxUQ6sBs7kXjalwu9DEOam2K?=
 =?us-ascii?Q?FmdD+F6M6Mi3yzGk7d0XtiTvm2pRxj30GQPNofDrkA3NEaRbvuAkXJcmPyfX?=
 =?us-ascii?Q?EYqPdu2K+J15RvP2IYu5kKLUr9S1zjFIc8VZhatipz271IqkgvGDLpbQMXD9?=
 =?us-ascii?Q?sik/UWrtfheOP4D7077XHpMGLgD5GRxPNvnvJBB8uAhx0cZiJ66OTp/qPYhy?=
 =?us-ascii?Q?Imvb6JBQernhesawcGLgxfZz5lpUddIxeb6Uo9SgIj4NV5EqxYXINEkllUYG?=
 =?us-ascii?Q?DpoKQnHt1GwT1kjQBQWlCVpmgm81sFoset0fpC3XpwjCSzY3SQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2024 22:20:13.0744
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e192ebd8-2a6e-4a32-f8b0-08dcc2f897a5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4259

AMD EPYC 5th generation processors have introduced a feature that allows
the hypervisor to control the SEV_FEATURES that are set for, or by, a
guest [1].  ALLOWED_SEV_FEATURES can be used by the hypervisor to enforce
that SEV-ES and SEV-SNP guests cannot enable features that the
hypervisor does not want to be enabled.

When ALLOWED_SEV_FEATURES is enabled, a VMRUN will fail if any
non-reserved bits are 1 in SEV_FEATURES but are 0 in
ALLOWED_SEV_FEATURES.

Some SEV_FEATURES (currently PmcVirtualization and SecureAvic according
to Appendix B, Table B-4) require an opt-in via ALLOWED_SEV_FEATURES,
i.e. are off-by-default, whereas all other features are effectively
on-by-default, but still honor ALLOWED_SEV_FEATURES.

[1] Section 15.36.20 "Allowed SEV Features", AMD64 Architecture
    Programmer's Manual, Pub. 24593 Rev. 3.42 - March 2024:
    https://bugzilla.kernel.org/attachment.cgi?id=306250

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Reviewed-by: Nikunj A. Dadhania <nikunj@amd.com>
---
v2:
 - Added some SEV_FEATURES require to be explicitly allowed by
   ALLOWED_SEV_FEATURES wording (Sean).
 - Added Nikunj's Reviewed-by.

v1:
 https://lore.kernel.org/lkml/20240802015732.3192877-3-kim.phillips@amd.com/

 arch/x86/include/asm/svm.h | 6 +++++-
 arch/x86/kvm/svm/sev.c     | 5 +++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index f0dea3750ca9..59516ad2028b 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -158,7 +158,9 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	u64 avic_physical_id;	/* Offset 0xf8 */
 	u8 reserved_7[8];
 	u64 vmsa_pa;		/* Used for an SEV-ES guest */
-	u8 reserved_8[720];
+	u8 reserved_8[40];
+	u64 allowed_sev_features;	/* Offset 0x138 */
+	u8 reserved_9[672];
 	/*
 	 * Offset 0x3e0, 32 bytes reserved
 	 * for use by hypervisor/software.
@@ -294,6 +296,8 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_
 	(SVM_SEV_FEAT_RESTRICTED_INJECTION |	\
 	 SVM_SEV_FEAT_ALTERNATE_INJECTION)
 
+#define VMCB_ALLOWED_SEV_FEATURES_VALID		BIT_ULL(63)
+
 struct vmcb_seg {
 	u16 selector;
 	u16 attrib;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a16c873b3232..d12b4d615b32 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -899,6 +899,7 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
 				    int *error)
 {
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	struct sev_data_launch_update_vmsa vmsa;
 	struct vcpu_svm *svm = to_svm(vcpu);
 	int ret;
@@ -908,6 +909,10 @@ static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
 		return -EINVAL;
 	}
 
+	if (cpu_feature_enabled(X86_FEATURE_ALLOWED_SEV_FEATURES))
+		svm->vmcb->control.allowed_sev_features = VMCB_ALLOWED_SEV_FEATURES_VALID |
+							  sev->vmsa_features;
+
 	/* Perform some pre-encryption checks against the VMSA */
 	ret = sev_es_sync_vmsa(svm);
 	if (ret)
-- 
2.34.1


