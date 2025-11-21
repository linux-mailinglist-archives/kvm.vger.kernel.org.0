Return-Path: <kvm+bounces-64079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 35C55C77D47
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 09:17:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id EDD4F4E83B8
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 08:13:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11A8B338918;
	Fri, 21 Nov 2025 08:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="htrdJkki"
X-Original-To: kvm@vger.kernel.org
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012051.outbound.protection.outlook.com [40.107.200.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23398331237
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 08:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763712814; cv=fail; b=YO4/kDzgkKy1A37ZhhJm1LEqjdXk5fyMQaVk9UhgMQcIHQ8qUWJXuP93C4VDqWU7eMVhVnAn0kpKw483BTDGKz1mwXactep0JE5/S5E4XEX4k4XDOk0LMw/XHfJY70XYxQY+Z4MRCDIAVZM44I6xZjl9LJ+koVRpJT9CIGBroq4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763712814; c=relaxed/simple;
	bh=rZwFet9VFCCLv6tGP+f5DjpTEiskIXHJBm38Acj9yIU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qmicwW9hue2xPKCwFvSyNKdzt36Vjmq8SrEho+I1bd0+OGnZpUmRHm71CLyqdqtYi6TFzNATKhM5wD5flSYv/bnszYOznz5ar805JVvexVwi+7B6ebF4G56nUktjZsMDdhdXWWsE1SKxQwYY5KgNqeOTmEAiFah+VI12umWPGII=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=htrdJkki; arc=fail smtp.client-ip=40.107.200.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=telgCDbL0HOHzU4ZIHjCBAXDMoMdyx3vnPFdAB6r2Gb+/1ANpCxtvlEnMOFSaj10CA+uwRJZ/JAlBb7lUZtrLRy/uu4fpw8Onv7ZGXGfiqbWe4qUGuHwQr+DR+2K+QvgDueKz8nF0Jm13TpfYijzDMEBrzEUkZ43rH/exmSdBDklkbCjqkEeaAplRCF656fxf/RPnPGu9rgYERDSY58nIVr+x1pS8KYw56yG+jA0zCUj1M2mZ1hZzjz5dI8oCjFHip1VW1tg5cZln7CD7ahCbDDWwg6CwCNY9JTh0hjn+q72P5j9xEHtzKTHoRLkAVNpsCugkA6Ny4ixRANqPmy3cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ueGnjQVRvuGVQazRjZRJ+RM+JrSEa0mk8jQjcSdJuSY=;
 b=MJtKb8ba7uhu8//mPn/+YyVqjsVRXQV0hKT3vg1oAcwIVmJ83IJl5i8s9sCFRqwgHo7PVF7X26h5nC9uFeK9QCHfXuUPU9DOVaFTEKHR3+z+yzHyW0/mZNl3fyQmyItkqw4n8L75dXHGz/WroqCCK9M73Ia5AmQ+KyU15tzp8V7Y4sJHOJOvEaz44/95nGTBRRoZGopUaATbV42RZSWVOG7RkOppzCgbPFI+9/qp7E8yCqXgoVZjFqsEjMdbQh9dYZL3/tqLv0M0MdAth1dpP7AwDz0Zg1GArMXO+AZz8Iw3tAfWytfjM6u9POoYvgv2LmhTDg3U8j9MVieJmFTFBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ueGnjQVRvuGVQazRjZRJ+RM+JrSEa0mk8jQjcSdJuSY=;
 b=htrdJkki7FDX3AZ0b6i+t/ESz6lBayhR4Ln3+g+H+9mhjVox4/8ig0pB4FT4zBAAeQ6pfmNl4HA4Q4B/vikisvY1YsIzWIwoPOqUFopccE4M6s0hav79hGsqpaO48toV0BgWtvamDmIjFSzRm6+J0zXqdEVI40/Lta/rHNOKiCE=
Received: from MW4PR03CA0193.namprd03.prod.outlook.com (2603:10b6:303:b8::18)
 by SJ0PR12MB8166.namprd12.prod.outlook.com (2603:10b6:a03:4e2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Fri, 21 Nov
 2025 08:13:21 +0000
Received: from CO1PEPF000042A7.namprd03.prod.outlook.com
 (2603:10b6:303:b8:cafe::2c) by MW4PR03CA0193.outlook.office365.com
 (2603:10b6:303:b8::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.12 via Frontend Transport; Fri,
 21 Nov 2025 08:13:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CO1PEPF000042A7.mail.protection.outlook.com (10.167.243.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Fri, 21 Nov 2025 08:13:21 +0000
Received: from purico-abeahost.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 21 Nov
 2025 00:13:16 -0800
From: Shivansh Dhiman <shivansh.dhiman@amd.com>
To: <kvm@vger.kernel.org>, <x86@kernel.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>
CC: <yosry.ahmed@linux.dev>, <thomas.lendacky@amd.com>,
	<santosh.shukla@amd.com>, <nikunj.dadhania@amd.com>, <ravi.bangoria@amd.com>,
	<shivansh.dhiman@amd.com>
Subject: [PATCH v2] KVM: SVM: Add Bus Lock Detect support
Date: Fri, 21 Nov 2025 08:12:28 +0000
Message-ID: <20251121081228.426974-1-shivansh.dhiman@amd.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000042A7:EE_|SJ0PR12MB8166:EE_
X-MS-Office365-Filtering-Correlation-Id: 563e10bc-9100-4cbb-8cb7-08de28d5d5dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kmNCvZUJiaF85BKl6PinoVh1pj8Drft3NB5N61XyWBnnitUhRGvq7WpElEHH?=
 =?us-ascii?Q?h389M8wGgX/yLyopQcWZcYgiP0TnEV2YAL6f7UOs7Xn/vJBr9MvdO3/4dDo1?=
 =?us-ascii?Q?4pgby7fJbxvYTjHf4Lh89VfZo5qvTe30PbYcGS5pWRohdEpXFn8okwRgHWcJ?=
 =?us-ascii?Q?QxFStx6IUksDGHwi7gnTH/SPiM6m/zpRy24MXwYJuwKnH5gFapdutW2ZmKp4?=
 =?us-ascii?Q?HafZMaWfpS0zf4coojRRDloN1k2TMyEkvr0XtyoDBja+RE9mISpmPDZm52No?=
 =?us-ascii?Q?xHsrhMnjBfCqW1avGaYWtK7TMkL+fto6U4j5qWXB3ApIK3O9ryfCl/MumFcr?=
 =?us-ascii?Q?mzBUJcu3qc/QLshbjQcZnQM5mQen1MOrtEuN/mca/GWP91lHOlNxuYZxgJwj?=
 =?us-ascii?Q?HX1uxCxTKr0a9hGobcAuKQs9CGZfQXMPKVYsVElF6dydIcAAVbppvFmRNlzn?=
 =?us-ascii?Q?h7ZUYojKhWQXNBsh4ZjoYExDa1BbZXZrXKnj6aMT0stJoK3ntilk9Dgm5nlV?=
 =?us-ascii?Q?Z5GnHkNMrZrLgdK9xcX1BdVE2xYD6QTPLPC/sNHvo9bmD8FGgbAFvE+KF+rN?=
 =?us-ascii?Q?3HlwBHx09XmUqvx4Z+Se/iaQdgtbM1D6+6Q9Y58wMlEhoL8YtvYF3Jg7CZRg?=
 =?us-ascii?Q?vHtHCVJeTwwIKdU6KV3yacDRYksaB4c6sSn9aFJsIS8ha9P9s0H9OICq47v7?=
 =?us-ascii?Q?wB685wncgE0AzvzxA+KOLso8EzNoy6o6idlh37ULRr3qsh+GusCc0WuIieQA?=
 =?us-ascii?Q?Jk297EM9n92FzsXtyp75as85LdTscjkB/Hr0+QS5NfvheWeh7kgV/sQqhBkX?=
 =?us-ascii?Q?R4QnWMuqiQPdHgHVMJOz91R7WiSeubR/HMkjpQ9EmOI9kcmFdj8rOr8t1wFw?=
 =?us-ascii?Q?SnzroMB4/TPWBFxGNi/hkHwguET0e3lrr/JhmCUQUjV8llobMToSFeBIEyuh?=
 =?us-ascii?Q?JCsUjAgAdiTGQwusrln7R+SQxj+GSf/XRjEhVAImjmkwdHtfUiaW54Xiwkte?=
 =?us-ascii?Q?/zWtjQdwnJgYBEP3sEaNlvroijmX0avICdBG4e94ORRPLkrv+wz0SAgVmOk3?=
 =?us-ascii?Q?JnaPdWLtmWnG6D5rgmwJNS7fIdp/6NhFdeRTG85VSCPxfI/1hPxdsD9nDapB?=
 =?us-ascii?Q?LED3NIAg80lFaUEMFnX2GxMZQ01tefpnenhIyveqKumzcJJTcm8oyV34/n1K?=
 =?us-ascii?Q?QePf1H/IXSc59WC8Mp9ol7wl0p3PGn+97j8Uv+0z96h8pNlqgVl0RvHLld2a?=
 =?us-ascii?Q?Krku/mbzF1VAb5zsHC4tN+LCaLixfjHuhYBKuQ46VkViY23B0NU2MWZfUN4E?=
 =?us-ascii?Q?xo8e5uqqFJyZwb6KUUhAggyFaYop54xdG9EZO/+0LA+3GYyC/aRhLobwo0E5?=
 =?us-ascii?Q?YnfaXx0yLNskJAGpgoj/rz+dXtqW43JPP0VUtsvpQOVa95SzgXCuyv3sgYbY?=
 =?us-ascii?Q?u8lknqH/J93Eg/fwpSFQDSLF9baq5Y4QB28XxKGc5/q2QKNCgFJ42p8qfUYp?=
 =?us-ascii?Q?JjgkXeL4rAtttHxeVrlubfczrcqKuxSHb4yBc0PligxhtuoUVEvS/wT1wmAA?=
 =?us-ascii?Q?TOobpRwQoIzO6/EpM00=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 08:13:21.3008
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 563e10bc-9100-4cbb-8cb7-08de28d5d5dc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000042A7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8166

From: Ravi Bangoria <ravi.bangoria@amd.com>

Add Bus Lock Detect support in AMD SVM. Bus Lock Detect is enabled through
MSR_IA32_DEBUGCTLMSR and MSR_IA32_DEBUGCTLMSR is virtualized only if LBR
Virtualization is enabled. Add this dependency in the SVM.

While adding Bus Lock Detect support, also fix DR6 handling in nested
virtualization. Using DR6_FIXED_1 to prevent reset of BLD bit (bit 11)
between VMRUNs. However, it preserves DR6_RTM, which is a reserved bit
on AMD processors. So, DR6_RTM bit must always be set to 1.

Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Co-developed-by: Shivansh Dhiman <shivansh.dhiman@amd.com>
Signed-off-by: Shivansh Dhiman <shivansh.dhiman@amd.com>
---
Changelog:
v1 --> v2
 * Rebased and used guest_cpu_cap_has() instead of guest_cpuid_has().

 v1: https://lore.kernel.org/all/20240808062937.1149-5-ravi.bangoria@amd.com
---
 arch/x86/kvm/svm/nested.c |  3 ++-
 arch/x86/kvm/svm/svm.c    | 17 ++++++++++++++++-
 arch/x86/kvm/svm/svm.h    |  2 +-
 3 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index da6e80b3ac35..5af7fbf5c536 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -665,7 +665,8 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 	/* These bits will be set properly on the first execution when new_vmc12 is true */
 	if (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_DR))) {
 		vmcb02->save.dr7 = svm->nested.save.dr7 | DR7_FIXED_1;
-		svm->vcpu.arch.dr6  = svm->nested.save.dr6 | DR6_ACTIVE_LOW;
+		/* DR6_RTM is a reserved bit on AMD and as such must be set to 1 */
+		svm->vcpu.arch.dr6  = svm->nested.save.dr6 | DR6_FIXED_1 | DR6_RTM;
 		vmcb_mark_dirty(vmcb02, VMCB_DR);
 	}
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 10c21e4c5406..ceef5b697e11 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -831,6 +831,9 @@ void svm_update_lbrv(struct kvm_vcpu *vcpu)
 			    (is_guest_mode(vcpu) && guest_cpu_cap_has(vcpu, X86_FEATURE_LBRV) &&
 			    (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK));
 
+	/* Bus Lock Detect depends on LBR Virtualization */
+	enable_lbrv |= (svm->vmcb->save.dbgctl & DEBUGCTLMSR_BUS_LOCK_DETECT);
+
 	if (enable_lbrv && !current_enable_lbrv)
 		__svm_enable_lbrv(vcpu);
 	else if (!enable_lbrv && current_enable_lbrv)
@@ -2984,6 +2987,10 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 			data &= ~DEBUGCTLMSR_BTF;
 		}
 
+		if ((data & DEBUGCTLMSR_BUS_LOCK_DETECT) &&
+		    !guest_cpu_cap_has(vcpu, X86_FEATURE_BUS_LOCK_DETECT))
+			return 1;
+
 		if (data & DEBUGCTL_RESERVED_BITS)
 			return 1;
 
@@ -5258,8 +5265,16 @@ static __init void svm_set_cpu_caps(void)
 	 * Clear capabilities that are automatically configured by common code,
 	 * but that require explicit SVM support (that isn't yet implemented).
 	 */
-	kvm_cpu_cap_clear(X86_FEATURE_BUS_LOCK_DETECT);
 	kvm_cpu_cap_clear(X86_FEATURE_MSR_IMM);
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
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index c856d8e0f95e..8e8d31788c9c 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -675,7 +675,7 @@ BUILD_SVM_MSR_BITMAP_HELPERS(bool, test, test)
 BUILD_SVM_MSR_BITMAP_HELPERS(void, clear, __clear)
 BUILD_SVM_MSR_BITMAP_HELPERS(void, set, __set)
 
-#define DEBUGCTL_RESERVED_BITS (~DEBUGCTLMSR_LBR)
+#define DEBUGCTL_RESERVED_BITS (~(DEBUGCTLMSR_LBR | DEBUGCTLMSR_BUS_LOCK_DETECT))
 
 /* svm.c */
 extern bool dump_invalid_vmcb;
-- 
2.43.0


