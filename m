Return-Path: <kvm+bounces-29157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 84B6E9A3922
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 10:52:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 21B122848E0
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 08:52:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46AED18FC79;
	Fri, 18 Oct 2024 08:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0OD/jL7f"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2089.outbound.protection.outlook.com [40.107.92.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D7318E744;
	Fri, 18 Oct 2024 08:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729241556; cv=fail; b=n1XHWF0kGAJiLejVD1ZHBarxhPIK3e6rHKM6HpYxXs9UM/v8UUYEdIOijH44Y9GZ12I+zFk7PHazGL8I/vJ3opTanVMwJr0IVqWWwL01bh1qg/FG3qh/c0vSSmA4wF+1zLaSxBZnHlCOVDbBR2pGaIZSWRhLSE6oGovjcNv0gy8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729241556; c=relaxed/simple;
	bh=CsMi36V0VhL/+T8jXhGFDYIl9V9J/LMYchiVlNn7qGw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hZhtcfev+J1ARFOU/v1lXFVLRrojifrovco2Kh/M2LAtkdQdyN0nWRuj1PqqOE4hAcEbgJsMc15CtbslCXOgR3TX5KyK5Sa5+rQou+4gydWL0swNxFdNNS+jvsuZmp63BSGyejpk4TfQacwT85zJukaSkTZAYeDiYxP3C/4/ovg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0OD/jL7f; arc=fail smtp.client-ip=40.107.92.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UJ9zxhGe9siGFgt89R2lpsHGJsHsXYCLV8MFGWK4G6Pku/aOgu6jntX1cCshza+HXPyNRB2t/pzDMTmAWLz/18U0jahIoy3UxUr89oiPV88LkXLwOm2pGd8uO7tzfZ4XlPXmfC3VqA3uXjxAI/hZaAWEF0YVQHmkyltROEHwoX35+Kenui2CH0k3/UHUAR2f009v0art9S01G0pXU+7CwRi+5MeWZYxLx2LvSHtspfPQgq58DzZaIaOv12+iOTHstt8el/9XMeBg7j6y7UpGZq/G3qHZEf8ArEL3tiIJkLNPu2k7C3Wq6U+x4AlywBfEtdq6Bq3H3w5++OFef6Jf1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KQbsVaszZ0Box5GznutiBe0zkzLQePszSHzff2S+4HI=;
 b=gMl+pSrxOtyfFxjZV6QW4t8ySxZAWgffM4ImwbTLxIiNx8pAHiwXxMUfsyVKLP+qb6Uv9TLzq3Mjf+kRSypBPjKsu22MIqVWv5s45AWwS3CWybhOrNHmlyY44Y5YbLsAmOUpkAiLgXDxWRzQwAZokgO+pchrLAhRxxNhfjZ8fgd5xWdj957ssXhNA9U4MOOtZqCMbzrrH3XHTTrv3Z8UAMiz7vEwbsZmqXGoTYYjcIHYu3iDTbBDBRVyZ5jRraaUDm0YUvXtZjRYYjKwE5UzDubY4NtfD85edk9c4veG0iL7qIKPTBglxoqOFmNyBSIxts74Le/T1sClSZTeBgIefg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KQbsVaszZ0Box5GznutiBe0zkzLQePszSHzff2S+4HI=;
 b=0OD/jL7fpSUN4drOPdwty+CakFCPbX04ChDgOGfVPx5Ig4N+9enPzqmWd57eLYsWVPFdVcFpoG1A7L5bjbB5It9n3f376VtIiseH/lACU6SVqd57bbF89k/VcBK5X0wogEHPs2GFtdv2Dh9Tb5COIZhvuA4nFloe0HlrBkouPvs=
Received: from CH5P223CA0010.NAMP223.PROD.OUTLOOK.COM (2603:10b6:610:1f3::11)
 by SN7PR12MB6887.namprd12.prod.outlook.com (2603:10b6:806:261::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.18; Fri, 18 Oct
 2024 08:52:30 +0000
Received: from CH2PEPF00000146.namprd02.prod.outlook.com
 (2603:10b6:610:1f3:cafe::73) by CH5P223CA0010.outlook.office365.com
 (2603:10b6:610:1f3::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.21 via Frontend
 Transport; Fri, 18 Oct 2024 08:52:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF00000146.mail.protection.outlook.com (10.167.244.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8069.17 via Frontend Transport; Fri, 18 Oct 2024 08:52:30 +0000
Received: from volcano-62e7host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 18 Oct
 2024 03:52:22 -0500
From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <joao.m.martins@oracle.com>,
	<david.kaplan@amd.com>, <jon.grimm@amd.com>, <santosh.shukla@amd.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v2] KVM: SVM: Inhibit AVIC on SNP-enabled system without HvInUseWrAllowed feature
Date: Fri, 18 Oct 2024 08:50:37 +0000
Message-ID: <20241018085037.14131-1-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000146:EE_|SN7PR12MB6887:EE_
X-MS-Office365-Filtering-Correlation-Id: d06a3d77-a0cd-4a4c-93b8-08dcef523322
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SktLcHdSajl1Ri9OYVZqdUJmaUlOckd1TWJpb3RDdnpuUUFld29IY1NvaFd2?=
 =?utf-8?B?Y2xTTTlLZVR6K2dONzRmeGFLVFBlSEdrczE2UzFQOW5CZ28ydjdjelpBVjBZ?=
 =?utf-8?B?TFk3NmJ5UXZHTUJsc0t4V25XMFIwM1pnUEhmVjBNSTZsdDZwRHpZcHk1QnlB?=
 =?utf-8?B?QXExMHM4UTB1b2xHV0lud1JVTEtua0JmK1NYUFp3ajladlExYmJEelllemhT?=
 =?utf-8?B?RVdrV1dURFdKa0Vpc1JPVW13QnhxZ2lvR2JUYVVkTDFRdWs3aUZoV1VsVkFL?=
 =?utf-8?B?MGhNUmF5elp2bExyYndCZURXOHI0MzFOMnBIWGxQUkp3ZVlETG5pS0pycnZJ?=
 =?utf-8?B?clN1ZHNuSTZQL3hjZ0YzZVNOYXNoekdwY1A0dmNoc2dqNWEwZWwrcmVJZjYz?=
 =?utf-8?B?UENhUjFlc1lxZDlNQ2k2K3YzaW5DaktsQXlDbGUzdmc5aVExV25WTFBlcHpX?=
 =?utf-8?B?L0RvRVVFb3FWbWlBYUE5anhzS1ZUdW9sWXg4d3N3eXJpWXBwL2g3MWFxWncy?=
 =?utf-8?B?QjFlb0srZmFkRHRQNU1wdDFLdDFIWTArWGJDY1RJcDYwb1lmL3BlVHRDVEc1?=
 =?utf-8?B?dXRHeWZkQ1F3V3p1SjIwWDlmSTVXRkk4Rkt2SWprcTVncXVXYmJUNWlxdnVT?=
 =?utf-8?B?L1NabTQ1Wi9jM3BZWXdPZDBTbjJYYmxZTTVhNWF0aVpQUVEwL3ZjWkE2WUVK?=
 =?utf-8?B?eVhlN0xDZVozWElSSUl5VlpDbE5XbllqNVpLejEzSWt1WHBmZ1RJcld5ZnAy?=
 =?utf-8?B?czMzYzhUc1dzSlNKUVRLUmMzVTQvZ05xNjlTZXk5LzdRcmxuaHlsUHliV0hy?=
 =?utf-8?B?RTRrWU9VSmI4eVFGYW44VHFSVU4zN2xoZ3lqT0lndkQ2QTFDL3lKRGx4VlFu?=
 =?utf-8?B?U0g0K0hXNXZjYU82RnZETzVST0pHM1haVWVsNkw3ZVJ6UG9aZVprNjFKVVh6?=
 =?utf-8?B?bHU3ZnpHbkR1aENrcTNBQ0gvS0ErVzhUQU45VE9La3luemRlV0RBOGRVU3RC?=
 =?utf-8?B?RDE2RXhIM1hPY1JocXFhVmlQbzJUbFNQRlJuVTFqcHlYY3N4bHZRL21iTkZZ?=
 =?utf-8?B?RTdWMlBQTm9jZ2Q0czdzQ3VaQ2lzdWI4Z3AvN21SZlhxc3ZnTGl6aVY4VDV5?=
 =?utf-8?B?QndjL3BYNTAvcXBNdVFLNlM0SFlYVEhweDlyaENsajJGMVB1VTRTbUYxVTd0?=
 =?utf-8?B?ZXNZZzNaVWRQallTaHVuVGxuNkxCelJjSFE4VFd4dmQ5V2x6b1dTaFJ1MWNO?=
 =?utf-8?B?NzdlUDFFTVZ5UlpnVVV5VlErS0MzWnpjUkErTUt3bHRYYlAzZnVaVlg3bHpW?=
 =?utf-8?B?SGYrN0pJNy9takZvYjYyM3A0OXdCa2VnaDlETUxlVmp4emxHWDlSTFJpTVdQ?=
 =?utf-8?B?bXkwcnV6UUYzaXJDQTMxR25iL2tQZ0JjZVNlQ1VhcExkYUI1TmRSazhPZlYx?=
 =?utf-8?B?VEYwOWNiYk4wcnhEU3ZHVWJHSjQxemFsQkJ6M1hHQWQ1T05aMHk4QXROU1Rk?=
 =?utf-8?B?djBDZDEyOEVJaUVES3ZQNnYrcVFKZVRiYlVLU1plaENrQVRYNHV2R1l3OUVH?=
 =?utf-8?B?RFRKSlk1eDgzSkVnM2hIdEF2TkdkUC9ZckFIcmJLZ213YnVOWjFaSlpCcFg3?=
 =?utf-8?B?QXV0SlBMWGNQN0pZT3RoMVVmbFBJVXR3dlp1QnZmTm5LKzMzaENZS2sxeEI0?=
 =?utf-8?B?VDlsWUVxbENlRFJrVmVnSEJnV0I0VUNxdUl6NG4yM01MT1hreWtIZGZNMHkv?=
 =?utf-8?B?RGZGQ3NkdGNhWlB3YWloMXM5R2pZWFFYZ09OcmhaK2Z4K0xtZmtOenJXZ1pz?=
 =?utf-8?B?QWRZZUVFcXNReVV0cE9INFFtUkpaVXpEZElsbGp3bmluYXB3NmpKZVhhTUJh?=
 =?utf-8?B?bWZzQUZEWWVLR2NSWGlaVUQwQndXenpBeTY5YURPeXNNdkE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2024 08:52:30.3247
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d06a3d77-a0cd-4a4c-93b8-08dcef523322
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000146.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6887

On SNP-enabled system, VMRUN marks AVIC Backing Page as in-use while
the guest is running for both secure and non-secure guest. Any hypervisor
write to the in-use vCPU's AVIC backing page (e.g. to inject an interrupt)
will generate unexpected #PF in the host.

Currently, attempt to run AVIC guest would result in the following error:

    BUG: unable to handle page fault for address: ff3a442e549cc270
    #PF: supervisor write access in kernel mode
    #PF: error_code(0x80000003) - RMP violation
    PGD b6ee01067 P4D b6ee02067 PUD 10096d063 PMD 11c540063 PTE 80000001149cc163
    SEV-SNP: PFN 0x1149cc unassigned, dumping non-zero entries in 2M PFN region: [0x114800 - 0x114a00]
    ...

Newer AMD system is enhanced to allow hypervisor to modify the backing page
for non-secure guest on SNP-enabled system. This enhancement is available
when the CPUID Fn8000_001F_EAX bit 30 is set (HvInUseWrAllowed).

This table describes AVIC support matrix w.r.t. SNP enablement:

               | Non-SNP system |     SNP system
-----------------------------------------------------
 Non-SNP guest |  AVIC Activate | AVIC Activate iff
               |                | HvInuseWrAllowed=1
-----------------------------------------------------
     SNP guest |      N/A       |    Secure AVIC
               |                |    x2APIC only

Introduce APICV_INHIBIT_REASON_HVINUSEWR_NOT_ALLOWED to deactivate AVIC
when the feature is not available on SNP-enabled system.

See the AMD64 Architecture Programmer’s Manual (APM) Volume 2 for detail.
(https://www.amd.com/content/dam/amd/en/documents/processor-tech-docs/
programmer-references/40332.pdf)

Fixes: 216d106c7ff7 ("x86/sev: Add SEV-SNP host initialization support")
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---

Change log v2:
 * Use APICv inhibit bit instead of disabling AVIC in driver.

 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/include/asm/kvm_host.h    | 9 ++++++++-
 arch/x86/kvm/svm/avic.c            | 6 ++++++
 arch/x86/kvm/svm/svm.h             | 3 ++-
 4 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index dd4682857c12..921b6de80e24 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -448,6 +448,7 @@
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* AMD hardware-enforced cache coherency */
 #define X86_FEATURE_DEBUG_SWAP		(19*32+14) /* "debug_swap" AMD SEV-ES full debug state swap support */
 #define X86_FEATURE_SVSM		(19*32+28) /* "svsm" SVSM present */
+#define X86_FEATURE_HV_INUSE_WR_ALLOWED	(19*32+30) /* Write to in-use hypervisor-owned pages allowed */
 
 /* AMD-defined Extended Feature 2 EAX, CPUID level 0x80000021 (EAX), word 20 */
 #define X86_FEATURE_NO_NESTED_DATA_BP	(20*32+ 0) /* No Nested Data Breakpoints */
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4a68cb3eba78..1fef50025512 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1276,6 +1276,12 @@ enum kvm_apicv_inhibit {
 	 */
 	APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED,
 
+	/*
+	 * Non-SNP guest cannot activate AVIC on SNP-enabled system w/o
+	 * CPUID HvInUseWrAllowed feature.
+	 */
+	APICV_INHIBIT_REASON_HVINUSEWR_NOT_ALLOWED,
+
 	NR_APICV_INHIBIT_REASONS,
 };
 
@@ -1294,7 +1300,8 @@ enum kvm_apicv_inhibit {
 	__APICV_INHIBIT_REASON(IRQWIN),			\
 	__APICV_INHIBIT_REASON(PIT_REINJ),		\
 	__APICV_INHIBIT_REASON(SEV),			\
-	__APICV_INHIBIT_REASON(LOGICAL_ID_ALIASED)
+	__APICV_INHIBIT_REASON(LOGICAL_ID_ALIASED),	\
+	__APICV_INHIBIT_REASON(HVINUSEWR_NOT_ALLOWED)
 
 struct kvm_arch {
 	unsigned long n_used_mmu_pages;
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 4b74ea91f4e6..cc4f0c00334a 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -202,6 +202,12 @@ int avic_vm_init(struct kvm *kvm)
 	if (!enable_apicv)
 		return 0;
 
+	if (cc_platform_has(CC_ATTR_HOST_SEV_SNP) &&
+	    !boot_cpu_has(X86_FEATURE_HV_INUSE_WR_ALLOWED)) {
+		pr_debug("APICv Inhibit due to Missing HvInUseWrAllowed.\n");
+		kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_HVINUSEWR_NOT_ALLOWED);
+	}
+
 	/* Allocating physical APIC ID table (4KB) */
 	p_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	if (!p_page)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 76107c7d0595..13046bad2d6e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -682,7 +682,8 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
 	BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) |	\
 	BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |	\
 	BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED) |	\
-	BIT(APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED)	\
+	BIT(APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED) |	\
+	BIT(APICV_INHIBIT_REASON_HVINUSEWR_NOT_ALLOWED)	\
 )
 
 bool avic_hardware_setup(void);
-- 
2.34.1


