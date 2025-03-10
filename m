Return-Path: <kvm+bounces-40702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 159A4A5A49B
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 21:17:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A3FAE3A2D26
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 20:17:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 915D81DE88D;
	Mon, 10 Mar 2025 20:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xjxBpnyW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2087.outbound.protection.outlook.com [40.107.212.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB921DE3DF;
	Mon, 10 Mar 2025 20:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741637810; cv=fail; b=Cx6fHqJ5BeVYBsCSK+htYtaL8dadl8XMSESBW14KD7KHyfjZk4ChLlvDDyq849o4RbVxQ7cBsH9rmpcCojlTF9q4gyH6CsqBVHAo9cKBREGSCguNlhNOTWQBSQE4T2IBbx8kkCWuLzbrw1181xWYAaBdd5KdmfaIr2+qOntmC0g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741637810; c=relaxed/simple;
	bh=aInZDTNxUqlgn7k4ej2ewwvEQ98YxwwzGS6F7ejLDVw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=txmWFh6KuqvKY/WEixrH9HHmK5OMCY33iU8Qk242LKkA11ahM4AY3wSiPm44haKEE019fk3bS1WeJ6vkgCKF/YWFxtIb4gNXpVc1WQc9AWq6+mbw72so4s4jbSseRDT3gpIoIUNv2SQRMLADAXz3oSZQX1jwKs06PZOWPhgSa1w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xjxBpnyW; arc=fail smtp.client-ip=40.107.212.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t/zckCp3w/E7qkYayhPHntAgVtearpkdc0olQBoaQG9+fOe0RPjQdZVvymMJIRtQfNIYHLjtqmStBSDLdMzNxhfs/zgcVkvTC/prRiYRbUGTeyJGICf8xKzUm1pA8Yp/aMt2M5Iyl0DhH1VgcX7GhN+sPG3Npb9n2dgORzsz1HVy3HuJvJ6QsBGqssX4ovu2oG7rINsMO61nmQYhjkBMne4B+xIAMcN8Bz20hrF4y9JUX7Zhrp3BDzcAd5VKzoZUstnQaVFv/6uR25tJOOx41Usxbtid5NvfV0AqQfxP1pj5mG4KkdF4+WWDd9haU0uOTdFbVWl2tcBvraOYpBSkQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sOCJnVgnKswO2yh9nLDr05lx4KcdCz2+eOfPJTDkydA=;
 b=OeOZ6iSHntzSer/4ydRDbZQsr7tUJgJYRFItIQsa9qETaX3jPFI9slobHKz/XxNjSkm3PIRZbK/DMjBPkPn4F07p2tiXDSXIS+9VA64YoYpUN+dg8MJ4hrrejXqhJipTNZ+t5kCdIXyiVLKA7EsQ7RVrmPssHDExO9OZNzT8RqQZZF3/4Q0AO/dyfDXboMIU0yC8KCumrb3Dp8tthv5eoSTcV2CyjImpHpn1BkX0VBqwRG4U1oFk+Vvj4k4Kb4X2VmYyTtYe8rjgHRTDgx/idqV3m51wFb1yS3VwcfHXvrrsrVTmeYoSE1U2dvR/IpOqyw5zUyTz6eKshzqZFeokLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sOCJnVgnKswO2yh9nLDr05lx4KcdCz2+eOfPJTDkydA=;
 b=xjxBpnyWTbmiGgTtgK+u916RaPHSCtuvLzRI1O0vP7iHjYKul045QPR6/djDxtAWSC5bJaxGlUH9JS6C12zxsLqCH6jeiHpgK4K09ypsYyPqKQMZ7u6faDhMTp9Tkf0FftdHYMVzcRn9pJQRbX116koBQ7k3qMaZXaTljnrelIw=
Received: from MN0P223CA0024.NAMP223.PROD.OUTLOOK.COM (2603:10b6:208:52b::31)
 by SA0PR12MB4496.namprd12.prod.outlook.com (2603:10b6:806:9b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.25; Mon, 10 Mar
 2025 20:16:45 +0000
Received: from BL6PEPF00020E63.namprd04.prod.outlook.com
 (2603:10b6:208:52b:cafe::61) by MN0P223CA0024.outlook.office365.com
 (2603:10b6:208:52b::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.26 via Frontend Transport; Mon,
 10 Mar 2025 20:16:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF00020E63.mail.protection.outlook.com (10.167.249.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8534.20 via Frontend Transport; Mon, 10 Mar 2025 20:16:45 +0000
Received: from zweier.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 10 Mar
 2025 15:16:44 -0500
From: Kim Phillips <kim.phillips@amd.com>
To: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
CC: Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth
	<michael.roth@amd.com>, Ashish Kalra <ashish.kalra@amd.com>, "Nikunj A .
 Dadhania" <nikunj@amd.com>, Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
	"Naveen N Rao" <naveen@kernel.org>, Alexey Kardashevskiy <aik@amd.com>,
	"Borislav Petkov" <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	"Sean Christopherson" <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, "Ingo Molnar" <mingo@redhat.com>, "H. Peter Anvin"
	<hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v5 2/2] KVM: SEV: Configure "ALLOWED_SEV_FEATURES" VMCB Field
Date: Mon, 10 Mar 2025 15:16:03 -0500
Message-ID: <20250310201603.1217954-3-kim.phillips@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250310201603.1217954-1-kim.phillips@amd.com>
References: <20250310201603.1217954-1-kim.phillips@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E63:EE_|SA0PR12MB4496:EE_
X-MS-Office365-Filtering-Correlation-Id: 2bd8057a-5384-4e4a-1373-08dd60107ae8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kTDWTajjJVdBEEWQMxOSXUoSWghPEgVurmaFUObKERN9kw5N8EZN3LiGKcXO?=
 =?us-ascii?Q?OZoBikgpEnhgFiRT7705iGHHxT5PwkbsCFN9bB5wJJXqjlmpzMn22KO+jhfn?=
 =?us-ascii?Q?jjVvpJEzB5adPOU/TBpientUBPLOwPl9CRIOA553b6EmDZtxAEHleOGj0Kgx?=
 =?us-ascii?Q?OM/ncN8DafjruKQWzq/dqbpStdl5SvE3SPaXCEkBi7BN9KuI/YBH6mqtkD0Y?=
 =?us-ascii?Q?/J7GDP0Gc++JwW7/AQ77qS3LxdY+cZvV1UyQ2E3Xzxb+Mu79AMjc/GXX9rGW?=
 =?us-ascii?Q?E5bSHfBhnu35mY7lkAiGcIj9sc+ka4T8tOmzhYvrFgFTcPa4ftogYszIZa6V?=
 =?us-ascii?Q?scPYeUkHC00hJY3Y4H/QBCmWT1loL0VloUoLp+qke3QdjbQqSqtDe6jzEwHn?=
 =?us-ascii?Q?euNRUG/JehsbvV1VPKLodDY47kvFBYAieukl1mtH7BH1sSXIrGU/j8Rbp6vG?=
 =?us-ascii?Q?xfHb88OeLmXYDKsMuIKVquNAQh9dLxClsKzCO3CElIXguM7NSP3Tq1uk3Xoh?=
 =?us-ascii?Q?otOOrq9TFf3CiJq+d6GMjtKRmbqCuBBcte38UB+zQrQ7Xl7C3nSSd5VrC2Rq?=
 =?us-ascii?Q?zn0LgqHK5ynfq5812UOqjscqvJ1gAIksY9w68JbnQSIdX9pTIeBuxT6pkLr/?=
 =?us-ascii?Q?hgkxxP3r3B2JHZSIEgRJwkvTvy2YRSo3H5mVV3tDUZmXF4X+xIjw/Bh8kx1D?=
 =?us-ascii?Q?LgRPLRa+26c9khWiTVT8PK82La9tl4QdATwN8P//hS6oJsOxKboGwKu+Ufh4?=
 =?us-ascii?Q?OR0lIL2XeD0UaZNXZF6AHRR9w4Spfw+0vwU0X9lHPg9g0oh77R3Co835rtpS?=
 =?us-ascii?Q?zYpNlS++vCMsWPfrPKpuFpZfMhx8lI2ejqiOxocXNbpk436oYBWNaxaT1rXt?=
 =?us-ascii?Q?G1TAS1CHC6/7jGNS2C2Klf+Boux0ydlTZVHQFJAE7zvDcYV3nSjolalS0kKP?=
 =?us-ascii?Q?7bxiwe1nz5JRIwdcN8CGKTVgr/0GwGHfcNnkl9gS1QpQ7de+9qOTjdrmnicf?=
 =?us-ascii?Q?MjU44DLIIMUnAMJiNqCUEf9wmDt63SqL42dfgdKGJ3gVlLXYq6rd7KeyXj7B?=
 =?us-ascii?Q?VonQM5pJr6qbEYkW3kXcKg699LnJxf8VjUQUbPl1sepAnq7xP1U1mC2Mjbjh?=
 =?us-ascii?Q?0XQaAUw2lx7QuMtus5cKWlLhOKBRTxMWItHw1kmqwQOHvopyNdkSv93ucdgi?=
 =?us-ascii?Q?pL4fZCQKkfkP5BESugu/SCqZvgtYInMmSh7vGo6VUGdXX+JTWOgUUAlXNbqJ?=
 =?us-ascii?Q?e4J60xf3jnWFZTLsnAJCbTuHEV57UgKilPXl9OtM4y6Z8oO7BnMdO5y6aWMY?=
 =?us-ascii?Q?FdzzP+mH+zUUna/VIxwpfY3QeFr9bL4NbCp/EwfybvsQVO+XxB6ZdnHekdRx?=
 =?us-ascii?Q?viF9VRSWvqrJNRhXlU95Yh9ZzbMMpgHVDOclZJ6c6i6h6I4XO+4C4HokroXD?=
 =?us-ascii?Q?kD1cr/+DJL8=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2025 20:16:45.3938
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bd8057a-5384-4e4a-1373-08dd60107ae8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E63.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4496

AMD EPYC 5th generation processors have introduced a feature that allows
the hypervisor to control the SEV_FEATURES that are set for, or by, a
guest [1].  ALLOWED_SEV_FEATURES can be used by the hypervisor to enforce
that SEV-ES and SEV-SNP guests cannot enable features that the
hypervisor does not want to be enabled.

Always enable ALLOWED_SEV_FEATURES.  A VMRUN will fail if any
non-reserved bits are 1 in SEV_FEATURES but are 0 in
ALLOWED_SEV_FEATURES.

Some SEV_FEATURES - currently PmcVirtualization and SecureAvic
(see Appendix B, Table B-4) - require an opt-in via ALLOWED_SEV_FEATURES,
i.e. are off-by-default, whereas all other features are effectively
on-by-default, but still honor ALLOWED_SEV_FEATURES.

[1] Section 15.36.20 "Allowed SEV Features", AMD64 Architecture
    Programmer's Manual, Pub. 24593 Rev. 3.42 - March 2024:
    https://bugzilla.kernel.org/attachment.cgi?id=306250

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/include/asm/svm.h | 7 ++++++-
 arch/x86/kvm/svm/sev.c     | 5 +++++
 arch/x86/kvm/svm/svm.c     | 2 ++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 9b7fa99ae951..b382fd251e5b 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -159,7 +159,10 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	u64 avic_physical_id;	/* Offset 0xf8 */
 	u8 reserved_7[8];
 	u64 vmsa_pa;		/* Used for an SEV-ES guest */
-	u8 reserved_8[720];
+	u8 reserved_8[40];
+	u64 allowed_sev_features;	/* Offset 0x138 */
+	u64 guest_sev_features;		/* Offset 0x140 */
+	u8 reserved_9[664];
 	/*
 	 * Offset 0x3e0, 32 bytes reserved
 	 * for use by hypervisor/software.
@@ -291,6 +294,8 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_
 #define SVM_SEV_FEAT_ALTERNATE_INJECTION		BIT(4)
 #define SVM_SEV_FEAT_DEBUG_SWAP				BIT(5)
 
+#define VMCB_ALLOWED_SEV_FEATURES_VALID			BIT_ULL(63)
+
 struct vmcb_seg {
 	u16 selector;
 	u16 attrib;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0bc708ee2788..f9ec139901ef 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4449,6 +4449,7 @@ void sev_vcpu_after_set_cpuid(struct vcpu_svm *svm)
 
 static void sev_es_init_vmcb(struct vcpu_svm *svm)
 {
+	struct kvm_sev_info *sev = to_kvm_sev_info(svm->vcpu.kvm);
 	struct vmcb *vmcb = svm->vmcb01.ptr;
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 
@@ -4464,6 +4465,10 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 	if (svm->sev_es.vmsa && !svm->sev_es.snp_has_guest_vmsa)
 		svm->vmcb->control.vmsa_pa = __pa(svm->sev_es.vmsa);
 
+	if (cpu_feature_enabled(X86_FEATURE_ALLOWED_SEV_FEATURES))
+		svm->vmcb->control.allowed_sev_features = sev->vmsa_features |
+							  VMCB_ALLOWED_SEV_FEATURES_VALID;
+
 	/* Can't intercept CR register access, HV can't modify CR registers */
 	svm_clr_intercept(svm, INTERCEPT_CR0_READ);
 	svm_clr_intercept(svm, INTERCEPT_CR4_READ);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8abeab91d329..bff6e9c34586 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3435,6 +3435,8 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	pr_err("%-20s%016llx\n", "avic_logical_id:", control->avic_logical_id);
 	pr_err("%-20s%016llx\n", "avic_physical_id:", control->avic_physical_id);
 	pr_err("%-20s%016llx\n", "vmsa_pa:", control->vmsa_pa);
+	pr_err("%-20s%016llx\n", "allowed_sev_features:", control->allowed_sev_features);
+	pr_err("%-20s%016llx\n", "guest_sev_features:", control->guest_sev_features);
 	pr_err("VMCB State Save Area:\n");
 	pr_err("%-5s s: %04x a: %04x l: %08x b: %016llx\n",
 	       "es:",
-- 
2.43.0


