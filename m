Return-Path: <kvm+bounces-16138-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 853388B50FF
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 08:08:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 163BD1F22F12
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 06:08:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87EE411C94;
	Mon, 29 Apr 2024 06:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LTBubW4O"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2084.outbound.protection.outlook.com [40.107.223.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC3FF516;
	Mon, 29 Apr 2024 06:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714370860; cv=fail; b=vARt3mQtynO2MOhyBTG1vpRCuUfPj7tqQaQvMNb7LnsoKG1CbYbnq51RL6DAnJlN95k+YpT1K4CaqPA7XJgDs/jvVbgO9IFwyXi6/h24a7T09xDRbEtcowYk7Yen+UQzGmDaH9rTMjG8cHXkuMqq8MlI0axemPRspmadmhzbfUk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714370860; c=relaxed/simple;
	bh=4GTBc++k2m1XYiFM32SwGZHESot6HGtdnGTDCbjdcyY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kzOdVWiHePlbnVUAnhqmsYQTUwUrg3PNf8G5wAP96hMd+k5qOipEvS0ULguhWwP7fKRi8ERvkgeEc+DVvdQWsU2TTTTbgJJ8/1GwtZFzOaGcNyQY3d85SdR+jLN2vTp1WFDOTXEG0aeyBKxOujtYF4eOvzElJPc3kcyebL2ySTE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LTBubW4O; arc=fail smtp.client-ip=40.107.223.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dv6OrrtaUJXu3JVpy3hR2vYtOTgK8h0PMN16i/5mG7vxS+AAWF0uxGbIxfgEhlV6UTnULnLXBAAvIhvoRYK/pisaGWt8B7zrJ1yewle/8QWji6w8Wq0vUGcyP9wzPgcJqx3R9uvdL4xMmnDV8K/29Hn3bVH9yK9IHvHxGEJm3u3Dt71a6Tx3aBOP9KOaogHqzRPwv71jC/6Q9ThXqXbcqIOWVNX9n+WXW7C03r5MhIBsZ9fUZZvRCLB9TAuFPpsMmAb+LRMHW5RF7O9ofttoGmexOejrXzBEzvy3yMc99C2FBdBN7U1gj2j7s5e/zK0BNXgU4hVTpNqjeASD/Sb6tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2XmpS2cjGKvUPZ8u7fu3URtVwMyJcRwfEpuYWePsRHw=;
 b=YXnCcGm+RX/oliAMTofa501upEeIhZiyDWKgZwjgNES3jRvDCpxFYOrpxVfxhL+EBOMo2ajE+WNeGUXbp+MMOS6C2HGWMfLdtATds5fhI3ZG2lSVyWGtJ7WgH1aXuRWyZwdUPjyLHKN4JDzs2JAFPTud3vvo1Y/wV7i6/v5EbHnZ977LrgfV0iWrZK5Qrqbm8cbZX4hYg5hvEdzaoyl9SmPHhDHM7LY5KN4EOGaleUQgBBYcrwWax4oZgZyvKn3S8oakwm8KeedPddawWIl75m4pPbLHlDDKYWfyvqM2ik+I+Wk0WJcAG3quTyik2WNLVdxS5dV5v06KmnMoXpQm0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2XmpS2cjGKvUPZ8u7fu3URtVwMyJcRwfEpuYWePsRHw=;
 b=LTBubW4O1Z69vM67HiiEFTVBFB3iD3Ce22uSSLB/lASiJcGi9VGjn2ebVHXVsdIEQd7dtK2clfwv9FJ4rOjcOs/B8A3nU06aCSTjfa2OSANp9JJKTwmrTVtxgA4e82Fm72Z8swARPE6KbslpWp8/k/EStqPJ0DPFTLhKYEvPQ0U=
Received: from CH0PR04CA0118.namprd04.prod.outlook.com (2603:10b6:610:75::33)
 by PH8PR12MB6915.namprd12.prod.outlook.com (2603:10b6:510:1bc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Mon, 29 Apr
 2024 06:07:36 +0000
Received: from CH2PEPF00000147.namprd02.prod.outlook.com
 (2603:10b6:610:75:cafe::4f) by CH0PR04CA0118.outlook.office365.com
 (2603:10b6:610:75::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.35 via Frontend
 Transport; Mon, 29 Apr 2024 06:07:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF00000147.mail.protection.outlook.com (10.167.244.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Mon, 29 Apr 2024 06:07:35 +0000
Received: from BLR-5CG113396H.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 29 Apr
 2024 01:07:26 -0500
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
	<ananth.narayan@amd.com>, <sandipan.das@amd.com>
Subject: [PATCH 3/3] KVM SVM: Add Bus Lock Detect support
Date: Mon, 29 Apr 2024 11:36:43 +0530
Message-ID: <20240429060643.211-4-ravi.bangoria@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240429060643.211-1-ravi.bangoria@amd.com>
References: <20240429060643.211-1-ravi.bangoria@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF00000147:EE_|PH8PR12MB6915:EE_
X-MS-Office365-Filtering-Correlation-Id: 454b48fd-9cb8-4fb5-9341-08dc6812aa7a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|7416005|1800799015|82310400014|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uH/9SplJFFNqlTWRWDC3aV3xOAENrUtClnibOYyzXybl0vXm06woaLINNC55?=
 =?us-ascii?Q?Q2znFcoLyaXhWpxFuXTfd5Yp++HXNcn6GiUN3hd6ex7xlbwkKBAdOvI6TTfh?=
 =?us-ascii?Q?VuSWY1LZdEh90G35EE1itOGaTeOHOv4Qf99Gp2JBFmCQSIWBBk4lDmap47K1?=
 =?us-ascii?Q?b8q7T0pXas49QC9U5Rj5h2CVQePMBoIwPevDoiiR03ZprxQxcSl2BMXlcmxl?=
 =?us-ascii?Q?PS191bsMv52CV/kDV8qzLn+6czNP/lQ8E46DESfwJhSs3qmuOt9yn7iceuYG?=
 =?us-ascii?Q?dHBDUKM9gvKKlWDKy7iHIGgHKUU2xAFIRpdIHtPBjIqx2cQirhjHVV+lPNm6?=
 =?us-ascii?Q?b5QljqIEELNlCgu2/KWfK0OkZBuIIUlfZJH2WTPQkjeJk+06H4k6FkXtU+2e?=
 =?us-ascii?Q?bUdD3yfzcVCW5MQutIy8hP0X6QCnj1yg+oHRjq+TuQLHs7hv/C48vAFsVQnO?=
 =?us-ascii?Q?3BUiI/amGvHSDIH4Isn3qMrVt3eukZ7iLCmqxRFkTP+fv6bwE5pE/kR993Lz?=
 =?us-ascii?Q?ypFzK49oPLVOQLyTLd6peUJ5jnwJCPAmoJZOjfVtdvKVqJ2bh4n0AmGq2jgd?=
 =?us-ascii?Q?f9FJwSdJ11JjcGcP1GPNWs3KG3GVRa4/y+/HDFjFQ61Jgq62xoBpjqtIUr9d?=
 =?us-ascii?Q?QeclBKFvXO8gyzn3o5koX/KeKCexQOt6EuW9omNU+qOYwHFNMfiuX+6J5jeR?=
 =?us-ascii?Q?jP9tlFJsZEDDmO4xpoZF3unPfeADImc/9kCjB+GXCEbulaoMZ1+WgPV/+FHf?=
 =?us-ascii?Q?eiozHo0aTYw370HCiLfkQ9Zn5rYmGR1Y4JwVPo4W4EPkkNTHwgwps6KYq3g3?=
 =?us-ascii?Q?X1RAAtD0a8X5OtUKBb1izRKpoymfbjhZv56t+irnX4vIPsSPWh1BrtfVUzCE?=
 =?us-ascii?Q?RmlIwW0V8FeB2g+tlQHODjiXuwaecUisO6JSq2WttrrrLl73NJouFdGZ+IGD?=
 =?us-ascii?Q?eCkXjXghPLNCJFKJhIPBMF79i//HS51v7uwy/Iqo4rzIx+FpqgBqpoDnjNRz?=
 =?us-ascii?Q?5qVSB+Vz84YrGfqrrTit0d/2S0245sVtYkbO4m4ZB1//a1+2MXeg89eHTrZ9?=
 =?us-ascii?Q?xmMUnA8mgV/bVg8RsXwr25quTtOEeiKchctgBdeI8vS/W7WD44Y3EPOTYR3f?=
 =?us-ascii?Q?m1GmQqyv2WvOHpRuMpzL+Ez5TB2Ln4ksAPOmABSW6GXZCpmTocGOIT6AcFLo?=
 =?us-ascii?Q?FfPEzGamoGxgU0ApFytjcjYlMDCPmSZNM7ysqh0UYOTBqopGFPhwx6fOozMa?=
 =?us-ascii?Q?SLjutZMzuomgDVRugzbaeOBNaw1PJf+ONS00ECUOlnmkh1yE8ZhS+5PHaB2o?=
 =?us-ascii?Q?t7FkgRvgmn1CaXtkpWd2yRY64ugvgtzGokCqmUmANNojzs7Z+60nuOKVWyLn?=
 =?us-ascii?Q?wH567Wg=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(82310400014)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2024 06:07:35.8002
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 454b48fd-9cb8-4fb5-9341-08dc6812aa7a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000147.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6915

Upcoming AMD uarch will support Bus Lock Detect. Add support for it
in KVM. Bus Lock Detect is enabled through MSR_IA32_DEBUGCTLMSR and
MSR_IA32_DEBUGCTLMSR is virtualized only if LBR Virtualization is
enabled. Add this dependency in the KVM.

Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
---
 arch/x86/kvm/svm/nested.c |  3 ++-
 arch/x86/kvm/svm/svm.c    | 16 +++++++++++++++-
 2 files changed, 17 insertions(+), 2 deletions(-)

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
index d1a9f9951635..60f3af9bdacb 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1038,7 +1038,8 @@ void svm_update_lbrv(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	bool current_enable_lbrv = svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK;
-	bool enable_lbrv = (svm_get_lbr_vmcb(svm)->save.dbgctl & DEBUGCTLMSR_LBR) ||
+	u64 dbgctl_buslock_lbr = DEBUGCTLMSR_BUS_LOCK_DETECT | DEBUGCTLMSR_LBR;
+	bool enable_lbrv = (svm_get_lbr_vmcb(svm)->save.dbgctl & dbgctl_buslock_lbr) ||
 			    (is_guest_mode(vcpu) && guest_can_use(vcpu, X86_FEATURE_LBRV) &&
 			    (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK));
 
@@ -3119,6 +3120,10 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		if (data & DEBUGCTL_RESERVED_BITS)
 			return 1;
 
+		if ((data & DEBUGCTLMSR_BUS_LOCK_DETECT) &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_BUS_LOCK_DETECT))
+			return 1;
+
 		svm_get_lbr_vmcb(svm)->save.dbgctl = data;
 		svm_update_lbrv(vcpu);
 		break;
@@ -5157,6 +5162,15 @@ static __init void svm_set_cpu_caps(void)
 
 	/* CPUID 0x8000001F (SME/SEV features) */
 	sev_set_cpu_caps();
+
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
2.44.0


