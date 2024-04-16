Return-Path: <kvm+bounces-14723-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C51A68A62BB
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 07:04:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1DDDAB229F9
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 05:04:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D768381C4;
	Tue, 16 Apr 2024 05:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="t9/m+Ljz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2068.outbound.protection.outlook.com [40.107.94.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD3A38385;
	Tue, 16 Apr 2024 05:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713243862; cv=fail; b=iNnFn2PmLVd/cm2+YRAv9QsfNsWbe5nWMwITg/7ed2mVIGCgpPGDT+JYo6ML/bgZMeT2hzN73jvIfpVhSQdoLx/LoRDlw+xImR0fkNkTyQ05KVZ+bSFhuGUUxARzZlO2xc+xg+v+zr2jBNa/YPeC/+Tpb2haO2SHzy6bwrghwMs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713243862; c=relaxed/simple;
	bh=mAjrCSiY046xHMc/kf5mFd1kvCrHY/fwwSS6SHHiqg0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=b2KSmtvM8a+iPbZo7kx2ciioQk4L2e9bJ1dOFDooBBI1PSBl5e542GvO2LppjtFiZ3T4aqbRxoeT75Mkdv76SlESXMYbZYPXldnhjsUe1I3hFaAPwnfPbaSpmoxVZsL9dwmr75KXmobrXh6Yb/BXdOaDIVC/uiXzPDuoRthWgQE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=t9/m+Ljz; arc=fail smtp.client-ip=40.107.94.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SOK/p6MXEoYH/x4BuShW/Am1v2tx2DNr6iEWNlr52c55VlZKM6BCtWO0+h7BzHyA/66hoACzeysCdQCV7shntXp0GDqiAhr2LUS5OANhn4GoK+OYtSQ/TzDLVRZ1lm2Ro2mx99u49PgPfx2H+mberGRGGfltSzU4YDI9GidT9EqG1rCl4qjnDtmolNjH8dYriXJskrQGapz9S2Cr8y6pwNtJKSMm2q9FAxeKbYzwOy8nL4jbr/IFsAx6gBHrWiN3YWNx1uoMI4HIlCAIwmOvqvEU1yglB65DidFUByu5F/GroFYsg605XTtLM2UiwljIehPXa0gC9LOj1QJeEJK7Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZE9OG4vP0tkg6JhP6AIkaAD6PN8QpWYdYx7g4Z/dpdQ=;
 b=R4T0zwGRdXExrQ07SM6FQpnXMEAGwstbZ/U1LZIq30kgdDVYaTmIFSh84C1Hx/S2yjvkA07SDhNmdHIRVkbrRZKqEHxUL45ZxdBpSqZ1X3JG2OmlaFqb38wsfRzRujkdRz71IlHgV6NQHmxn/HZCJCFcWQdau106U1z4dXXqHdb8pFZLLl48V4WIUy1VnXAQdTulkX27RhEBvBwUYmH+firyBe43yN0tqAqBNfuvUZEj5+ll3R8krT0LOR89C6hyfDemiK34CQrOQiLA8Lbdlou1+8N6DzrXWr4p6u15mxY+0MFtF2IuHMVDKdgpxTPGMr6aZN1LuNINLCnLFLn0ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZE9OG4vP0tkg6JhP6AIkaAD6PN8QpWYdYx7g4Z/dpdQ=;
 b=t9/m+LjzRSSDHXJ3YVPfvNL1bCNd8PdgpcP6rELosUowQDu78A43IL8BIk1Y9SFHkliJQeojWNKjejx95sDeA0tm6EoMQ1GOZf9VIYKc8aCuNlTrbdfklgqFYMX215AWAeUtJwgyIXA9A6G3mxWnKbp3zLC37NnO6dJRGCYe+8c=
Received: from CH0PR03CA0083.namprd03.prod.outlook.com (2603:10b6:610:cc::28)
 by SJ2PR12MB9085.namprd12.prod.outlook.com (2603:10b6:a03:564::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Tue, 16 Apr
 2024 05:04:18 +0000
Received: from CH1PEPF0000A346.namprd04.prod.outlook.com
 (2603:10b6:610:cc:cafe::3f) by CH0PR03CA0083.outlook.office365.com
 (2603:10b6:610:cc::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.33 via Frontend
 Transport; Tue, 16 Apr 2024 05:04:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000A346.mail.protection.outlook.com (10.167.244.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Tue, 16 Apr 2024 05:04:18 +0000
Received: from BLR-5CG113396H.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 16 Apr
 2024 00:04:08 -0500
From: Ravi Bangoria <ravi.bangoria@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <thomas.lendacky@amd.com>
CC: <ravi.bangoria@amd.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <michael.roth@amd.com>, <nikunj.dadhania@amd.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<santosh.shukla@amd.com>
Subject: [PATCH v2] KVM: SEV-ES: Don't intercept MSR_IA32_DEBUGCTLMSR for SEV-ES guests
Date: Tue, 16 Apr 2024 10:33:38 +0530
Message-ID: <20240416050338.517-1-ravi.bangoria@amd.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A346:EE_|SJ2PR12MB9085:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e186ff6-13d3-4519-ed83-08dc5dd2aba6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	P/jGnDag38mCq/YqpsTQBn7ktrgwVdWTDW1VU//K6a8DeS/Jm6l97jE733W9Vruedodidt2gKtrHd3d33+gZM6Eb8Qr78KuKq2NLF/RPeO6IANio2QkVeBTT2/ZIArXGvOUCQrOhMGHiL3TCiZr7uJ6uTocCTZHjDEniQemayeHUmoKY3EliyLXaEEODQzHq6Fy3Vxt5fIy7KJkG7ldq+HFNY4x4nebkublmzkHuVAmoAaGVnesXmFJUJmX3P/dXSN+2rsXR4yp0pCDrkXoea/ITM0c4sf0LBdkPK7NVL9GqXGSxhbt9BqJTYzz0LcLIgJq5dA5PcJ06Yn8g1kTvOtIG5AF3OiybNMkAhu1ykpcj14ZuXPVusM4QmjhmqEJSE38lbQtxOXwbkqAqrSFZ3nn9ZbFh0cmU+pSg21EFgdJv7KERl4xwXCgggYN5Z6D4HkU3Cp6Non159eZVVOLd5nQ+Sa2qbnOg2YNf6IAM27YxlC8jiK4u1U3CUA+9qgGZJXzlAKRSpIlkoHMKLKr6oxnV9FapRAZiU5/Jv1JKbeEJdMX+nqxlMLqYDCIqlBl9w9xkhy9j7XcIl1an+ZugtpynkmvDr9BTrctOVUAclVyO1BUpH9+9cQ+ySk59X8c2pNUxIqqhmoPOmB+RDdAIDcLHM2oO0wR6ni9S9MBjl0i4DRCCE5iF73cXucGwHNFr8QSAuz0nmBwYwJBtrSWFNCs0yVklOJzwRSj+pCqB9rIDvedDAeN/g7KvEleSF92K
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(376005)(1800799015)(7416005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 05:04:18.3501
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e186ff6-13d3-4519-ed83-08dc5dd2aba6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A346.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9085

Currently, LBR Virtualization is dynamically enabled and disabled for
a vcpu by intercepting writes to MSR_IA32_DEBUGCTLMSR. This helps by
avoiding unnecessary save/restore of LBR MSRs when nobody is using it
in the guest. However, SEV-ES guest mandates LBR Virtualization to be
_always_ ON[1] and thus this dynamic toggling doesn't work for SEV-ES
guest, in fact it results into fatal error:

SEV-ES guest on Zen3, kvm-amd.ko loaded with lbrv=1

  [guest ~]# wrmsr 0x1d9 0x4
  KVM: entry failed, hardware error 0xffffffff
  EAX=00000004 EBX=00000000 ECX=000001d9 EDX=00000000
  ...

Fix this by never intercepting MSR_IA32_DEBUGCTLMSR for SEV-ES guests.
No additional save/restore logic is required since MSR_IA32_DEBUGCTLMSR
is of swap type A.

[1]: AMD64 Architecture Programmer's Manual Pub. 40332, Rev. 4.07 - June
     2023, Vol 2, 15.35.2 Enabling SEV-ES.
     https://bugzilla.kernel.org/attachment.cgi?id=304653

Fixes: 376c6d285017 ("KVM: SVM: Provide support for SEV-ES vCPU creation/loading")
Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
v1: https://lore.kernel.org/r/20240326081143.715-1-ravi.bangoria@amd.com
v1->v2:
  - Add MSR swap type detail in the patch description. No code changes.

 arch/x86/kvm/svm/sev.c | 1 +
 arch/x86/kvm/svm/svm.c | 1 +
 arch/x86/kvm/svm/svm.h | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a8ce5226b3b5..ef932a7ff9bd 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3073,6 +3073,7 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 	/* Clear intercepts on selected MSRs */
 	set_msr_interception(vcpu, svm->msrpm, MSR_EFER, 1, 1);
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_CR_PAT, 1, 1);
+	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_DEBUGCTLMSR, 1, 1);
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHFROMIP, 1, 1);
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHTOIP, 1, 1);
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTFROMIP, 1, 1);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e90b429c84f1..5a82135ae84e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -99,6 +99,7 @@ static const struct svm_direct_access_msrs {
 	{ .index = MSR_IA32_SPEC_CTRL,			.always = false },
 	{ .index = MSR_IA32_PRED_CMD,			.always = false },
 	{ .index = MSR_IA32_FLUSH_CMD,			.always = false },
+	{ .index = MSR_IA32_DEBUGCTLMSR,		.always = false },
 	{ .index = MSR_IA32_LASTBRANCHFROMIP,		.always = false },
 	{ .index = MSR_IA32_LASTBRANCHTOIP,		.always = false },
 	{ .index = MSR_IA32_LASTINTFROMIP,		.always = false },
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 8ef95139cd24..7a1b60bcebff 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -30,7 +30,7 @@
 #define	IOPM_SIZE PAGE_SIZE * 3
 #define	MSRPM_SIZE PAGE_SIZE * 2
 
-#define MAX_DIRECT_ACCESS_MSRS	47
+#define MAX_DIRECT_ACCESS_MSRS	48
 #define MSRPM_OFFSETS	32
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
-- 
2.44.0


