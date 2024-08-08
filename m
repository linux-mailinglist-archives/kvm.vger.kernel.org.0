Return-Path: <kvm+bounces-23599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 661F294B6C4
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 08:32:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E1AE284759
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 06:32:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75A59188CCD;
	Thu,  8 Aug 2024 06:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="avg5Depd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2050.outbound.protection.outlook.com [40.107.212.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D1318784B;
	Thu,  8 Aug 2024 06:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723098693; cv=fail; b=rJbr8awQFQ4Ed0ATBdKFoY89mdSXnKdG60DInfMzF5b7sCjIQvp9leItCsbSZu+ogEDantCr+nPYunxDekeHzEecu/3iYLn487nEQQv4soYCq2vrWMEQNEBBGzZ0pMbpvshQGVDwVC0VWblBNgTxWUN/7opVaK66rUx62eXGIpc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723098693; c=relaxed/simple;
	bh=+xH53VYWSTPEXzDHcNyUPM+Zty8HhqwcoNvVDGckMZ0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c0fCD70ET99Kw13OC6GPA3rC8CI8muX+krZsI+MQdgrD9RcjpVUWmh8HnP45LuROD19RvnnyPs12sKW12tsYrZ+AELVmt4nSpk2FWZuQq9h7eawABS54K02x891S7d9+9MMC8WLL6hx5kmgrajnWGaHZBvACv2pm3c/xiEegAMI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=avg5Depd; arc=fail smtp.client-ip=40.107.212.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KR2QEdJ7YP67/lUAoOmX+YFWAr/YxwddbAW+edUFpw4egTXD4nj52YFwyvqezsXB4dMI/sBmCBWHb9CPCM6H2YHj4dFyeSmAcDLNNKjlIXeZ4+lLZ57foT5GhYYgh89m1Pi5E4s7PsLPB72AFJkBZ5lbNM/8FivpG3CLRZuXMVi58Fk8L6HBQhKRznXMeCnwRrPFZgkAlHhPqX+io8JO+X3ucCGYFCKyiMtuAR8uahssPkBVOp6au7TEjDO/KTfFZwcChCPcl4NB/HbErrth/mK6x+kzp/u56OzrYHvuLHkgb2AGsc/LhZk6ZreRVbR9TdX4GSUsZJkOwU6mdUS9iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=87cYDsUIkdLNCr9WdH65u17/VXmxFXlopUnfWjWIaqY=;
 b=POcjcmjnManaxh8RzBEl7GNoT2BQxQtDMpMyVhMTM+KMA+3rLN1QI8/sgWAJ8O12nMQPtcu5M/UMF6YrgobxZ99+glbH5YlSk5HI4faUDLCvdNbeIxXPrfAv55evMRgTQdIc/Ap/nJokbNWKIxj8h0tyWbGilGqn12ARvpSfx4yYVhnJ6ey8TmdAxGt67+5960fWQYaVeJz5rTUx3r5y1c40ReSDuFl66okP3dxOt8v8UKxvb9s5OjRy7Kou3r3V0ebTV2B9wiII5JMsAf3QuK8Aq7/fz8pN2uGni8lKs9Djtq06On4Hk08n57vRQKt8wo3kilkxcGFrBsZoq1lb9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=87cYDsUIkdLNCr9WdH65u17/VXmxFXlopUnfWjWIaqY=;
 b=avg5Depd58l0Tjkbc7emwaMO+2syWs6l+O5zS9JEzZLiFiNR85SoalRThWhcDZU/f8RZ06ws3zOIvd7g82kblFkv0eCKXnwKvlImjX/GiT4ML1qRl0pKkfr6+BrnnXz8cVIb8K8GLwyQej9cONbFvytSzeziGOd2jNgAjLCukhM=
Received: from BN1PR10CA0009.namprd10.prod.outlook.com (2603:10b6:408:e0::14)
 by PH8PR12MB7208.namprd12.prod.outlook.com (2603:10b6:510:224::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.27; Thu, 8 Aug
 2024 06:31:28 +0000
Received: from BN2PEPF0000449F.namprd02.prod.outlook.com
 (2603:10b6:408:e0:cafe::5c) by BN1PR10CA0009.outlook.office365.com
 (2603:10b6:408:e0::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.13 via Frontend
 Transport; Thu, 8 Aug 2024 06:31:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF0000449F.mail.protection.outlook.com (10.167.243.150) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7849.8 via Frontend Transport; Thu, 8 Aug 2024 06:31:27 +0000
Received: from BLR-L-RBANGORI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 8 Aug
 2024 01:31:18 -0500
From: Ravi Bangoria <ravi.bangoria@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<thomas.lendacky@amd.com>, <jmattson@google.com>
CC: <ravi.bangoria@amd.com>, <hpa@zytor.com>, <rmk+kernel@armlinux.org.uk>,
	<peterz@infradead.org>, <james.morse@arm.com>, <lukas.bulwahn@gmail.com>,
	<arjan@linux.intel.com>, <j.granados@samsung.com>, <sibs@chinatelecom.cn>,
	<nik.borisov@suse.com>, <michael.roth@amd.com>, <nikunj.dadhania@amd.com>,
	<babu.moger@amd.com>, <x86@kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <santosh.shukla@amd.com>,
	<ananth.narayan@amd.com>, <sandipan.das@amd.com>, <manali.shukla@amd.com>
Subject: [PATCH v4 4/4] KVM: SVM: Add Bus Lock Detect support
Date: Thu, 8 Aug 2024 06:29:37 +0000
Message-ID: <20240808062937.1149-5-ravi.bangoria@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240808062937.1149-1-ravi.bangoria@amd.com>
References: <20240808062937.1149-1-ravi.bangoria@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF0000449F:EE_|PH8PR12MB7208:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a538387-5f1b-4842-39f1-08dcb773bbae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5bD0jC/3hOoiGRwwEahKANyYXKIsFGKukl3SHFipYojyyZBcq6SUAX5yAbni?=
 =?us-ascii?Q?HQ8mTCHsgojpLVek5sLfmpiW2xPXB3xXJTU4d2utzG3G+AXE2XGgLrs0e+ac?=
 =?us-ascii?Q?C2ndc2oIMsnfH1yYrGmfJsoxjcLK6WY3bFTVFmtt8RK4BQwGAiNq0UqmnQdD?=
 =?us-ascii?Q?CF2HA/w0eSRdhhKsp0Rc40i8vqjDlixqNBisf0pB6wOz3vero6nmdxBpxQLv?=
 =?us-ascii?Q?tdszIozv03TlKn65Nbk2tzPgLoSoTRp7rTEKq4/7SVLgPrTiG2u5El8Df6To?=
 =?us-ascii?Q?+icn615dDajmjb1t1dnXceJiLDhziHmWy3Cn3+HUEnoMIXl4BH7TBjK8vKbs?=
 =?us-ascii?Q?TBJyDW5BzMHgx9QJHr+1J/BizIPX73OWQQ2jeSURMPJ4paUzXuIzSvab8TQL?=
 =?us-ascii?Q?ZLJ8OQuVF+fHq69sJq+XxOF6/8+D4+B5I4eG6dyoYXm1SH6ljvIiVmYBYdqK?=
 =?us-ascii?Q?tKpuyDwV/+8I9cho+hKFv8hIIeUjE0qSd2Jhwxbp664//5r8iCY/JNO7+V+S?=
 =?us-ascii?Q?lBNPmZeFWlAXSIkywaTNiTwCoTht/oPutnH5Nu0SL+d1ulDgyziuEnn9I5tO?=
 =?us-ascii?Q?rGcbx0FTDVYs0Jwk2ud0VY2UxOk1PhFfmaQvGp4PNZqBt5PnOmLHbr8zSLGB?=
 =?us-ascii?Q?NK+WQTZ5AStWOPDDiROA8px02j27nWh6nmBONFpc2dA2oZnXu7MuW4cZQ+pf?=
 =?us-ascii?Q?l4nKKsnz7Ik+/3mhDRtCs9YQWASrwVd5+ZgUuycWJAGev/TbZMfKpnsVFhGX?=
 =?us-ascii?Q?Cr+dunihT2c7pkvbQBvFPOhshvbYBzyVG+i7agC5vvQZcJ8vy1pJ58LBgFI4?=
 =?us-ascii?Q?V3PGdmY8l4B5DAQT85v6vym7rS9RABKP1prx3/Z10Hn6TNSApGW+yu5dQxjt?=
 =?us-ascii?Q?LupC65CwxIJlQBBNKVtvMJ5RWuSQlXyqpeaeQF4M6IEIQE0hO7w+gm9WTcog?=
 =?us-ascii?Q?bcmwKSsRt3gFWgQMQZvDParqCCnTjLsPrwKY12sWLOWhYE/KTuu3UYhCP1+w?=
 =?us-ascii?Q?8LFFQjY017t9QLZD1SxQ0HaslrPajcNE3RSzLddZwholXEr37G0IdtrVuQtN?=
 =?us-ascii?Q?Ihl9ymSSxAxhC1tQb1+h9YnKBuRAidyN9nfJnKAf1zNJqiq9YoAsq7Td0iz/?=
 =?us-ascii?Q?IIJY93xRnsbmiel9TVI6uqgkW5vJ5mdqVKcEudNlL6jSNUz5mynAGNXOk/hy?=
 =?us-ascii?Q?wK4xF08pG3KkBNuwCTTxBJl1pGDK92R+zeJzIZWrAPh/C89bGi0o9jtYPOsF?=
 =?us-ascii?Q?5kVlDs0ImexKuY7koHryGvXaI04jpkRBmZu4kiyRlSD2Vl/ekXzyXaLac6k3?=
 =?us-ascii?Q?4l3lLVEXirWOD05osYrZlKCCrMsopjPJfA3bcH9zExUETiEH4gTqReEG94YI?=
 =?us-ascii?Q?o/8ut0So8OUEw/EbEvNrWFJVgtGiLgRvH9cczBhLOnxsGpmMUaDaGXlwGGdq?=
 =?us-ascii?Q?z2XTNrHBesi3mKqKIFbBn9fz6R11FeoJ?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2024 06:31:27.7022
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a538387-5f1b-4842-39f1-08dcb773bbae
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000449F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7208

Add Bus Lock Detect support in AMD SVM. Bus Lock Detect is enabled through
MSR_IA32_DEBUGCTLMSR and MSR_IA32_DEBUGCTLMSR is virtualized only if LBR
Virtualization is enabled. Add this dependency in the SVM.

Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/nested.c |  3 ++-
 arch/x86/kvm/svm/svm.c    | 17 ++++++++++++++---
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 6f704c1037e5..1df9158c72c1 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -586,7 +586,8 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 	/* These bits will be set properly on the first execution when new_vmc12 is true */
 	if (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_DR))) {
 		vmcb02->save.dr7 = svm->nested.save.dr7 | DR7_FIXED_1;
-		svm->vcpu.arch.dr6  = svm->nested.save.dr6 | DR6_ACTIVE_LOW;
+		/* DR6_RTM is a reserved bit on AMD and as such must be set to 1 */
+		svm->vcpu.arch.dr6  = svm->nested.save.dr6 | DR6_FIXED_1 | DR6_RTM;
 		vmcb_mark_dirty(vmcb02, VMCB_DR);
 	}
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e1b6a16e97c0..9f3d31a5d231 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1047,7 +1047,8 @@ void svm_update_lbrv(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	bool current_enable_lbrv = svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK;
-	bool enable_lbrv = (svm_get_lbr_vmcb(svm)->save.dbgctl & DEBUGCTLMSR_LBR) ||
+	u64 dbgctl_buslock_lbr = DEBUGCTLMSR_BUS_LOCK_DETECT | DEBUGCTLMSR_LBR;
+	bool enable_lbrv = (svm_get_lbr_vmcb(svm)->save.dbgctl & dbgctl_buslock_lbr) ||
 			    (is_guest_mode(vcpu) && guest_can_use(vcpu, X86_FEATURE_LBRV) &&
 			    (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK));
 
@@ -3158,6 +3159,10 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		if (data & DEBUGCTL_RESERVED_BITS)
 			return 1;
 
+		if ((data & DEBUGCTLMSR_BUS_LOCK_DETECT) &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_BUS_LOCK_DETECT))
+			return 1;
+
 		svm_get_lbr_vmcb(svm)->save.dbgctl = data;
 		svm_update_lbrv(vcpu);
 		break;
@@ -5225,8 +5230,14 @@ static __init void svm_set_cpu_caps(void)
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


