Return-Path: <kvm+bounces-54265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B4913B1DC19
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 19:00:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2D9621AA71D5
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 17:01:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BC442741C0;
	Thu,  7 Aug 2025 17:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gvubXVZN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2087.outbound.protection.outlook.com [40.107.96.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867312727E3;
	Thu,  7 Aug 2025 17:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754586028; cv=fail; b=faXWq0uy0rshHaqgv1TDXzo5TQyqXbelUWu+WYXLjrETCoi/W809HatmKgannSUMXFoPOO/db/gjucTjLZLu6lqUZPgdR9CTlBjO7p47g3jxeK4f7zxYCS58cm5Ldl2mTjpJKdm+6veElrQ5CpE0mN9eKMuI1yER20paweTm1Ac=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754586028; c=relaxed/simple;
	bh=x0s3A/FH15MhNHp+EGMLOQ7kjxa2BTsakegjFSrV0zE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XcmJAiL9KPWiYhgVs1AACzkpInMuExI9D72N0+CC2i9+tsaX9Dy8U9LQPgKJVqYchtO4ZlfXWbvOYT79a8uiM3kJNnVMl5N4OcJkCRKdjH0OA0XAM+PBnBRvTFCnzw0hV4niERGPorQ0JsLRxzQqQE6hQu7qJDcga3DoSDWIrtE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gvubXVZN; arc=fail smtp.client-ip=40.107.96.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vMLwYtvWlCQlqfzumiKyZ/9zeo94tSHLfBgrcLxx7eFBlO+lK1LuSy3kNCl3q54lTzT9gjPBHd/Xi6G8mIybLJwZ9hLQHl9DmKN9yzGqMcLjNlcsRFv9/CCGqBDMzHY3hfUzjzGfmtIwEjcHLlvpr+xW87AtT45rij7rjPWr4ztAF4HZifFUprcABkx6vs1EpS+MUIEZtX2/EvsF6IB8LYmegFDpvZoJk7ZIxa4+hpocvtrdHDsTbXwy2jYQ6SOIku80jOSYS/vrNxdqrYOcBRypx16ifY+mX01kNk1N9nFgIwYGXQfQuugoXp5DVYBNbhAr2WnfvGt5BFOpSZXOrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cuE/cD4H4ACw9Xpf9xatzdgUzMfk5tz7Md3hGG7oVQ0=;
 b=qdJJg889udrOJ0UskOL3itpCJ864+aWTLnxhiA79THc2LPyulrayEmPwxuDpbkvVTBI9cu5ufDt+V2Z6uOEqN6OQYIQLLRXivRYgWYRvqmRLTQ86lyOORjIoBTpKfmfA5gQNSttTSXNixkHgLmdlARLGcMc0MIRvOvJ+i1ne1xaGXwTLGLHdJ+7stT7Xk9gJePNDsjVNN5oIEjNM34RqdQYeCTNehW1PJLMd5lygZD4IzyphSbit/ws1VV/+pIMFrQCJK9ie48IInsGSOJufDiegmvxS/x3PtTWbzXDAQti6/hhNocudf6dOnkchDNH4EsPLwx+EgdmI3d8o/nNCjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cuE/cD4H4ACw9Xpf9xatzdgUzMfk5tz7Md3hGG7oVQ0=;
 b=gvubXVZNhNTuphse3dK0XmgZ5wfVZBGIZt9crzI3PjOpdVklqzOAFJ/qq2Zpd2rHX4k+m6TrU8iZ9/tfs8VdRiKPyiwgshrBd/cpW14cSvI2GMTqhgvRJDa0O/fCsQiNSgvZ+q13rlssfsz2AyX8etHMWBGj00AakSUPuOGTys4=
Received: from BY3PR05CA0049.namprd05.prod.outlook.com (2603:10b6:a03:39b::24)
 by LV3PR12MB9095.namprd12.prod.outlook.com (2603:10b6:408:1a6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.16; Thu, 7 Aug
 2025 17:00:22 +0000
Received: from CO1PEPF000042AC.namprd03.prod.outlook.com
 (2603:10b6:a03:39b:cafe::3b) by BY3PR05CA0049.outlook.office365.com
 (2603:10b6:a03:39b::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.8 via Frontend Transport; Thu, 7
 Aug 2025 17:00:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000042AC.mail.protection.outlook.com (10.167.243.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9009.8 via Frontend Transport; Thu, 7 Aug 2025 17:00:21 +0000
Received: from dryer.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 7 Aug
 2025 12:00:08 -0500
From: Kim Phillips <kim.phillips@amd.com>
To: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <x86@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>, Dave Hansen
	<dave.hansen@linux.intel.com>, Sean Christopherson <seanjc@google.com>,
	"Paolo Bonzini" <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H.
 Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, K Prateek
 Nayak <kprateek.nayak@amd.com>, "Nikunj A . Dadhania" <nikunj@amd.com>, "Tom
 Lendacky" <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>, Borislav Petkov
	<borislav.petkov@amd.com>, Borislav Petkov <bp@alien8.de>, Nathan Fontenot
	<nathan.fontenot@amd.com>, Dhaval Giani <Dhaval.Giani@amd.com>, "Santosh
 Shukla" <santosh.shukla@amd.com>, Naveen Rao <naveen.rao@amd.com>, "Gautham R
 . Shenoy" <gautham.shenoy@amd.com>, Ananth Narayan <ananth.narayan@amd.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>, David Kaplan <david.kaplan@amd.com>,
	"Jon Grimm" <Jon.Grimm@amd.com>, Kim Phillips <kim.phillips@amd.com>
Subject: [RFC PATCH 1/1] KVM: SEV: Add support for SMT Protection
Date: Thu, 7 Aug 2025 11:59:50 -0500
Message-ID: <20250807165950.14953-2-kim.phillips@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250807165950.14953-1-kim.phillips@amd.com>
References: <20250807165950.14953-1-kim.phillips@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000042AC:EE_|LV3PR12MB9095:EE_
X-MS-Office365-Filtering-Correlation-Id: 92d3953e-807f-41b4-3b52-08ddd5d3e50f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QDgLO+lvVKU+tPIE/VAnWjYMkjqD5rX6DHOjD16FCHkPHHLyZ0Y6NLMgR1Iz?=
 =?us-ascii?Q?fCMTnS+urMOqp0aLXIP8n1NEhCQnIdhV0hDRUZz0DaVJt4XzqqiYmX/XsiQD?=
 =?us-ascii?Q?18j6t546uevG17h//Fcf2YbbcbIu+FEjAQiejA+Le/twWQSWrTsHdM+2oG+8?=
 =?us-ascii?Q?oYvx7pNWdpfwbL25IUVSJangH8hzifeImJCAtI2sBzevAzBGMH+XSUcqxu9k?=
 =?us-ascii?Q?8ftb5GFBZ0U4w2xlU/e30H0MbY+pm+iEsWL/whe+d92bNyMe5T8f11Zz7WKk?=
 =?us-ascii?Q?0ihwE7KzI/aFyXBkJTi78S+z0dNtnNowp80AQbs66++cN8jUWJroKU+J+cdk?=
 =?us-ascii?Q?vhFAS8y1iglJfRHqv9Qqjx+4gbk67TQiK1WXIXGw+8UcsxWeZ2VBNULpC8+/?=
 =?us-ascii?Q?i/VYGjksmgqyDqAD9kyy0raGeVn0l9dLFeq0P73hdiW2DLkxTX6OvT1zvZHd?=
 =?us-ascii?Q?ECaNFdDDwzzUlvQ21/LJvUdlugqIx0PTypUn9OvTLUbkVOU+mjLW3VtTX8M0?=
 =?us-ascii?Q?IWz7NAYqSmrLUhAJVM5CLZJ68LSo1HWMiv6Klus7lPaLSbxnqqtjri6GqaF6?=
 =?us-ascii?Q?NiCxvvb/nwdNgOqKONRpgDRdQB3XqUOD92+NE/qU0hTfYNLx0R6sek+hhlhT?=
 =?us-ascii?Q?rjBAwaknmZrtyv2H+UKEMOojg72EgUcQUYDcVcGm5vIvjzIresBWG6R/nwG5?=
 =?us-ascii?Q?iJ8im0Wk8Y+znH5AObuh8gMyoTSI2hZKUT3PRUqNN5I4e3leUuFZ+DrV/ZsZ?=
 =?us-ascii?Q?Rr+nBZDwCKxV/3s7pa0OeCVnU0xbEiEdz1e658nryJn+EQYzj2aC3h/mKtb2?=
 =?us-ascii?Q?5wYhl29Ru1YUjSS8FJ2XDxC2ZB/EAYj8bGejiDnPg5ej+mkWQpESIZjebs79?=
 =?us-ascii?Q?Njw7kRDnZDtRRmXg2EiUfQ8bpsyXn7Brg8xVqaYTppyz59aCk9T9+lc2qyhe?=
 =?us-ascii?Q?LHzBJ7dmyQBdncHi+XZ2L09JjT4MUSdrZExSU5ECHWtQ8eYoMutFyxsOB0f3?=
 =?us-ascii?Q?frxF8uVcs2GMdTT3ETEhGHUZKTqENTegLi7R4fgqc9O+9gm1+7PsGWgUb01C?=
 =?us-ascii?Q?FYXgikDhq9A0iDItgvdsI+BmrZ6cS6XIB+SccC0dFXz3wGvhmtu8lHa0ql5u?=
 =?us-ascii?Q?Q4c7i1BZr8e69TgzPUfIX9+QgK/F5qH4qBVsOnzX2SeR0mltTe1+fn+E5Ewf?=
 =?us-ascii?Q?M2p1CcK2/njGLCPj3r7TyVaAYZ76peGAFW0SI+1759xIB3t95uUBpX2xOfig?=
 =?us-ascii?Q?B8qc+3GNp8prmZ2Juzn0pIweY1KbFzsRtw/47Cy7O/VYwn32SXF0lLfI9L4X?=
 =?us-ascii?Q?401f6PB6hi6f62Ut/aAxsSS5T4wLnT4z/xXBVE51p7BwMcck7UoWYz4/5XV8?=
 =?us-ascii?Q?rHrE6MhEU4GFVI/t5LY6uSs7tViFbkuBMyjcMVIV3/jjYBqAxnQPoLljbmPX?=
 =?us-ascii?Q?76Q8e348ISIMABtPqaSVQcgKh+9OEC6oYHokHzsaZwsYkXKsRC4VSg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2025 17:00:21.2922
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 92d3953e-807f-41b4-3b52-08ddd5d3e50f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000042AC.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9095

Add the new CPUID bit that indicates available hardware support:
CPUID_Fn8000001F_EAX [AMD Secure Encryption EAX] bit 25.

Indicate support for SEV_FEATURES bit 15 (SmtProtection) to be set by
an SNP guest to enable the feature.

Handle the new "IDLE_REQUIRED" VMRUN exit code case that indicates that
the hardware has detected that the sibling of the vCPU is not in the
idle state.  If the new IDLE_REQUIRED error code is returned, return
to the guest.  Ideally this would be optimized to rendezvous with
sibling idle state transitions.

Program new HLT_WAKEUP_ICR MSRs on all pCPUs with their sibling
ACPI IDs.  This enables hardware/microcode to 'kick' the pCPU running
the vCPU when its sibling needs to process a pending interrupt.

For more information, see "15.36.17 Side-Channel Protection",
"SMT Protection", in:

"AMD64 Architecture Programmer's Manual Volume 2: System Programming Part 2,
Pub. 24593 Rev. 3.42 - March 2024"

available here:

https://bugzilla.kernel.org/attachment.cgi?id=306250

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/msr-index.h   |  1 +
 arch/x86/include/asm/svm.h         |  1 +
 arch/x86/include/uapi/asm/svm.h    |  1 +
 arch/x86/kvm/svm/sev.c             | 17 +++++++++++++++++
 arch/x86/kvm/svm/svm.c             |  3 +++
 6 files changed, 24 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 286d509f9363..4536fe40f5aa 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -448,6 +448,7 @@
 #define X86_FEATURE_DEBUG_SWAP		(19*32+14) /* "debug_swap" SEV-ES full debug state swap support */
 #define X86_FEATURE_RMPREAD		(19*32+21) /* RMPREAD instruction */
 #define X86_FEATURE_SEGMENTED_RMP	(19*32+23) /* Segmented RMP support */
+#define X86_FEATURE_SMT_PROTECTION	(19*32+25) /* SEV-SNP SMT Protection */
 #define X86_FEATURE_ALLOWED_SEV_FEATURES (19*32+27) /* Allowed SEV Features */
 #define X86_FEATURE_SVSM		(19*32+28) /* "svsm" SVSM present */
 #define X86_FEATURE_HV_INUSE_WR_ALLOWED	(19*32+30) /* Allow Write to in-use hypervisor-owned pages */
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index c29127ac626a..a75999a93c3f 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -707,6 +707,7 @@
 #define MSR_AMD64_SEG_RMP_ENABLED_BIT	0
 #define MSR_AMD64_SEG_RMP_ENABLED	BIT_ULL(MSR_AMD64_SEG_RMP_ENABLED_BIT)
 #define MSR_AMD64_RMP_SEGMENT_SHIFT(x)	(((x) & GENMASK_ULL(13, 8)) >> 8)
+#define MSR_AMD64_HLT_WAKEUP_ICR	0xc0010137
 
 #define MSR_SVSM_CAA			0xc001f000
 
diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index ffc27f676243..251cead18681 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -299,6 +299,7 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_
 #define SVM_SEV_FEAT_RESTRICTED_INJECTION		BIT(3)
 #define SVM_SEV_FEAT_ALTERNATE_INJECTION		BIT(4)
 #define SVM_SEV_FEAT_DEBUG_SWAP				BIT(5)
+#define SVM_SEV_FEAT_SMT_PROTECTION			BIT(15)
 
 #define VMCB_ALLOWED_SEV_FEATURES_VALID			BIT_ULL(63)
 
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index 9c640a521a67..7b81ee574c55 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -126,6 +126,7 @@
 	/* SW_EXITINFO1[11:4] */				\
 	((((u64)reason_code) & 0xff) << 4))
 #define SVM_VMGEXIT_UNSUPPORTED_EVENT		0x8000ffff
+#define SVM_VMGEXIT_IDLE_REQUIRED		0xfffffffd
 
 /* Exit code reserved for hypervisor/software use */
 #define SVM_EXIT_SW				0xf0000000
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2fbdebf79fbb..5f2605bd265f 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3082,6 +3082,23 @@ void __init sev_hardware_setup(void)
 	sev_supported_vmsa_features = 0;
 	if (sev_es_debug_swap_enabled)
 		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
+
+	if (sev_snp_enabled && cpu_feature_enabled(X86_FEATURE_SMT_PROTECTION)) {
+		unsigned long long hlt_wakeup_icr;
+		unsigned int cpu, sibling;
+
+		sev_supported_vmsa_features |= SVM_SEV_FEAT_SMT_PROTECTION;
+
+		for_each_online_cpu(cpu) {
+			for_each_cpu(sibling, topology_sibling_cpumask(cpu)) {
+				if (sibling == cpu)
+					continue;
+				hlt_wakeup_icr = LOCAL_TIMER_VECTOR | (unsigned long long)
+						 per_cpu(x86_cpu_to_apicid, sibling) << 32;
+				wrmsrq_safe_on_cpu(cpu, MSR_AMD64_HLT_WAKEUP_ICR, hlt_wakeup_icr);
+			}
+		}
+	}
 }
 
 void sev_hardware_unsetup(void)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d9931c6c4bc6..708c5e939b0d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3502,6 +3502,9 @@ static int svm_handle_invalid_exit(struct kvm_vcpu *vcpu, u64 exit_code)
 
 int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u64 exit_code)
 {
+	if (exit_code == SVM_VMGEXIT_IDLE_REQUIRED)
+		return 1; /* resume guest */
+
 	if (!svm_check_exit_valid(exit_code))
 		return svm_handle_invalid_exit(vcpu, exit_code);
 
-- 
2.43.0


