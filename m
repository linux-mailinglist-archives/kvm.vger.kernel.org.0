Return-Path: <kvm+bounces-21499-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 82F1592F826
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 11:42:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0E4FB1F23DED
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 09:42:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01BF3161320;
	Fri, 12 Jul 2024 09:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="usiOEBqX"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2052.outbound.protection.outlook.com [40.107.220.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B79E814B95A;
	Fri, 12 Jul 2024 09:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720777293; cv=fail; b=BlMs5fPidjr7A63TzFHVHINlWxa+UeeoK1GqWpL9y05dN/B/zQPJDsa2bf3Hnf/w3BRoYWWVgRQ/JRs/x/B0L6agTm1NphbyttzlfMJOLzlPZxuL4R1yhtzllm/iC8KzoErjBpRDBWBhDNVrt7ORux57NnCotLO6CGzi6sNX98M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720777293; c=relaxed/simple;
	bh=5rtVdFPU5cEI4KrUx229jRVQzguTWV25lhXzYyQIT6k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HdYU3gUMKJC4mvTDv4djm1otda5/qwuwxYuA4kOitAPv0DqTQ9K6A1yEwN8/V/VSxtxZcoTTGoBy8l6xdk4vC5zZjNqxI9G+B+NbuwKzEaPcVvqfo4cKDo/0DgGdKRlNJ4k0aXC6TOUcu1XjuKtmmUHSZymnVWCDmjR1MZa0Fnw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=usiOEBqX; arc=fail smtp.client-ip=40.107.220.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kgqm5fJeCEN0jFZW5k8TqpOzrUxkjFqbneBZGKtSJbGDFBbHwpZMjhrfWLkqyGEl9iG9C+pQ373TJnFNO2ebcZlXZCcU318EWHd5eQAxvouqulT9pD5WAdH4FCOP1P0Q3DqlRwveykenuhjolP3TY2va/q3qE7l/SckBzEW8svMBhr8zCg8mKEOoyTa5tYILu4xI8t/bM0eYrmVrbZW/L7/F5GrptNpFQ7A8aVofHEkY8eJ91tuuuF2VOIRZ/iEGkp4qoFMBvTeY0fy4VINNggrF67TAJTW1TOHAH4GL+Kd1hEXhMz/kaa8QbzLWozvtWSPMsJ0Dd+ObSEo3733/dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0FJc+LLEm3A2DN67vA8hUOqchnflGEqrPUfUrqOJaBA=;
 b=yVozrWuYF89DeTFupgDW8dPmUHUClfBR3r9b8QCIRuQJb4t4bN2vguj7IaicJHyEmK7mZBSssNjgp+VUBeFuw2+mJKMV1rQfJgdk6b3Kh2KwbxwwssCr7tWrFIdwEp22R8qf/VRfmwV9SjhaQ6lpsLi/TzkDSU6TbLXRHCZbdmYREXphhPVbDLKcM5Dqd3KBJTSAdhzSNE70V4uEZNQmIplxpbLeaoNR6iklHBjBRA8Y7I9YIZYJjgaLoYej8wnqre2EmK1+E7C18sM1ECpADn3oOn1AoF9hHVprpzMrosKISeMardpQW8rHFfx1SjZWR+a2Pft1nfhotaQK/et9xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0FJc+LLEm3A2DN67vA8hUOqchnflGEqrPUfUrqOJaBA=;
 b=usiOEBqXNs80G4hSmO/ZTZaCuJxd3ddg9czaYrUUKy8XSRJbEwbxShkxsQw3XBTqLjopzoJC1lgf1hIhiTrNuba9BIIwYGbq/2p9YsWTNmkNss9vOaDrfOddSMrbWfRzIXw9sBcW1isaUiIuUGieS/WHVmxaLEn2WC6tjQe2rU8=
Received: from DM6PR14CA0047.namprd14.prod.outlook.com (2603:10b6:5:18f::24)
 by DM6PR12MB4353.namprd12.prod.outlook.com (2603:10b6:5:2a6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.23; Fri, 12 Jul
 2024 09:41:26 +0000
Received: from DS3PEPF0000C37B.namprd04.prod.outlook.com
 (2603:10b6:5:18f:cafe::4) by DM6PR14CA0047.outlook.office365.com
 (2603:10b6:5:18f::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.23 via Frontend
 Transport; Fri, 12 Jul 2024 09:41:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF0000C37B.mail.protection.outlook.com (10.167.23.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7762.17 via Frontend Transport; Fri, 12 Jul 2024 09:41:26 +0000
Received: from BLR-L-RBANGORI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 12 Jul
 2024 04:41:18 -0500
From: Ravi Bangoria <ravi.bangoria@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<thomas.lendacky@amd.com>
CC: <ravi.bangoria@amd.com>, <hpa@zytor.com>, <rmk+kernel@armlinux.org.uk>,
	<peterz@infradead.org>, <james.morse@arm.com>, <lukas.bulwahn@gmail.com>,
	<arjan@linux.intel.com>, <j.granados@samsung.com>, <sibs@chinatelecom.cn>,
	<nik.borisov@suse.com>, <michael.roth@amd.com>, <nikunj.dadhania@amd.com>,
	<babu.moger@amd.com>, <x86@kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <santosh.shukla@amd.com>,
	<ananth.narayan@amd.com>, <sandipan.das@amd.com>, <manali.shukla@amd.com>,
	<jmattson@google.com>
Subject: [PATCH v2 4/4] KVM: SVM: Add Bus Lock Detect support
Date: Fri, 12 Jul 2024 09:39:43 +0000
Message-ID: <20240712093943.1288-5-ravi.bangoria@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240712093943.1288-1-ravi.bangoria@amd.com>
References: <20240712093943.1288-1-ravi.bangoria@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37B:EE_|DM6PR12MB4353:EE_
X-MS-Office365-Filtering-Correlation-Id: 730c80cb-7f36-4dae-a784-08dca256ccdd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Bu4SAJgcpybN0oF42Y/lL+igxBUy9DHyuALgxFHRMa6P3g6ycgd7MC+h/cAz?=
 =?us-ascii?Q?d0FJdhP1qnDfNynFQh3fVsUBQNwifhq9tVBkI3ghG2W3V2XBOEy+Ukvi/F0L?=
 =?us-ascii?Q?u66GtvwdcCsjb9QFeZeHYDLJPMbmSVI6Xrucam/p8l4OI+Ion4W6/+4uMOyY?=
 =?us-ascii?Q?Ji6sPvgEP+K2VKicHTK8t4kf6mxxbMYrpDBbC2OPWbjLhnT3vsDZslejMblM?=
 =?us-ascii?Q?BFje9HY/mHYcmVNgfrnD6+eTHRn1j9RxaR9272vweLyigYfkQN8lPmAr2aq0?=
 =?us-ascii?Q?IliLF0GgnNTlONY2vOloA6wEV0bHvLAIKJGJSLSuqeReEv6XhC+yPLLN65pZ?=
 =?us-ascii?Q?wDcNgZ/DYRJttfk+Sprk3KAhffQ3V23eX9RQ7YwcL51GxkqmaACSvFFdtWUC?=
 =?us-ascii?Q?M6DhAXiV6Se2CVQIlYdCbORWtVW1RI1eOwv/gaQNY5E14NyBZiCBtE6+N0Lj?=
 =?us-ascii?Q?BDH9Y8jPlsj+xlLsTE6xrorCckxLlKWLNQ0ZMmPCCxuMZ+2f5ttAiuTHjZKh?=
 =?us-ascii?Q?MmdnNa98FUxc9NaBUYwdGpiw0CrihZ/yv0CR/bxaW4KnrwE3OikcxruAO9vC?=
 =?us-ascii?Q?jDdZc3vGmKWt9q3Jugqg+jIKh6dk+zjU/Usl4upAAKfN1QmWrZXIQA4Udpio?=
 =?us-ascii?Q?kUcCGwk+iukEJVq2QnNBY/Ks9Skve+39Nguaub5p0OElbJDfTdyiyDlpna03?=
 =?us-ascii?Q?WL5+jq0Nw6yAjkxi4Rhrrb+ExRhImEgHkMu3qMUSKX67SDanR1VIL0z1gOrM?=
 =?us-ascii?Q?xIjuVlWBVj4MIJB9CsqVz2ggzfOdx3Wyb+aMuXRFKXEXgYZ2l4BBO7s6ecgn?=
 =?us-ascii?Q?90Jf4BMCMO7zoXqPsV+R9b+8fnjDwFp3Zp/9OMwkDer44IH0k4byVSN9wdHR?=
 =?us-ascii?Q?HcJ2/73OLvMPWXy4P8Sgpw2oDDNy03EoOKmv2mMRY85IGRjkWxzNVuK6K7Le?=
 =?us-ascii?Q?QVClllbnDWHMtgNGHmWYO+JPrNM/JUGFYBnoUYulDbrqU8O9z579o1aNuWx4?=
 =?us-ascii?Q?ac2PKXcY6Jp4xOALba4zFoMNW4XzwGsaVwVgijOarPO/pv3HPCQwzrJtZ8/l?=
 =?us-ascii?Q?+3nve0FBXBxioMy+Jhl8CaYYHUZ2oYrwy5rpskyZ/Oj1t0aGwqa9jpyucxen?=
 =?us-ascii?Q?Xyb7031hLIY82roy6BuvntE+/NIaXblamt2Z2kf3mR7CcDg8fNB/Eenm0G/+?=
 =?us-ascii?Q?FOdqNWz2GpRl02AMqhNmu6G2aaH3X4H7b9KN0rzxsiGQwDPvXe1SOyaLKmvS?=
 =?us-ascii?Q?2sVBtNW/tClIK51zNiEMCiVhk7b5Ls6X2LkE4w+ZqiBeCXY+/buVKPEuzitL?=
 =?us-ascii?Q?lrbMQ34skq2/fcMFhkAz88806y18RlOpXRvGrU05kBg2T6zXnphiT0aRDmhD?=
 =?us-ascii?Q?cXHYbKvavr/mMAU9S4k7DLIiMaascsXUU83wAtPkVFiphZIpgR2J4e2ehXTX?=
 =?us-ascii?Q?Xbh2+v7e84sLRtaGkeHQZTEFW1hSqmUC?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2024 09:41:26.6170
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 730c80cb-7f36-4dae-a784-08dca256ccdd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4353

Upcoming AMD uarch will support Bus Lock Detect. Add support for it
in KVM. Bus Lock Detect is enabled through MSR_IA32_DEBUGCTLMSR and
MSR_IA32_DEBUGCTLMSR is virtualized only if LBR Virtualization is
enabled. Add this dependency in the KVM.

Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
---
 arch/x86/kvm/svm/nested.c |  3 ++-
 arch/x86/kvm/svm/svm.c    | 17 ++++++++++++++---
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 55b9a6d96bcf..6e93c2d9e7df 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -586,7 +586,8 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 	/* These bits will be set properly on the first execution when new_vmc12 is true */
 	if (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_DR))) {
 		vmcb02->save.dr7 = svm->nested.save.dr7 | DR7_FIXED_1;
-		svm->vcpu.arch.dr6  = svm->nested.save.dr6 | DR6_ACTIVE_LOW;
+		/* DR6_RTM is not supported on AMD as of now. */
+		svm->vcpu.arch.dr6  = svm->nested.save.dr6 | DR6_FIXED_1 | DR6_RTM;
 		vmcb_mark_dirty(vmcb02, VMCB_DR);
 	}
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4a1d0a8478a5..e00e1e2a0b78 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1044,7 +1044,8 @@ void svm_update_lbrv(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	bool current_enable_lbrv = svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK;
-	bool enable_lbrv = (svm_get_lbr_vmcb(svm)->save.dbgctl & DEBUGCTLMSR_LBR) ||
+	u64 dbgctl_buslock_lbr = DEBUGCTLMSR_BUS_LOCK_DETECT | DEBUGCTLMSR_LBR;
+	bool enable_lbrv = (svm_get_lbr_vmcb(svm)->save.dbgctl & dbgctl_buslock_lbr) ||
 			    (is_guest_mode(vcpu) && guest_can_use(vcpu, X86_FEATURE_LBRV) &&
 			    (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK));
 
@@ -3145,6 +3146,10 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		if (data & DEBUGCTL_RESERVED_BITS)
 			return 1;
 
+		if ((data & DEBUGCTLMSR_BUS_LOCK_DETECT) &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_BUS_LOCK_DETECT))
+			return 1;
+
 		svm_get_lbr_vmcb(svm)->save.dbgctl = data;
 		svm_update_lbrv(vcpu);
 		break;
@@ -5212,8 +5217,14 @@ static __init void svm_set_cpu_caps(void)
 	/* CPUID 0x8000001F (SME/SEV features) */
 	sev_set_cpu_caps();
 
-	/* Don't advertise Bus Lock Detect to guest if SVM support is absent */
-	kvm_cpu_cap_clear(X86_FEATURE_BUS_LOCK_DETECT);
+	/*
+	 * LBR Virtualization must be enabled to support BusLockTrap inside the
+	 * guest, since BusLockTrap is enabled through MSR_IA32_DEBUGCTLMSR and
+	 * MSR_IA32_DEBUGCTLMSR is virtualized only if LBR Virtualization is
+	 * enabled.
+	 */
+	if (!lbrv)
+		kvm_cpu_cap_clear(X86_FEATURE_BUS_LOCK_DETECT);
 }
 
 static __init int svm_hardware_setup(void)
-- 
2.34.1


