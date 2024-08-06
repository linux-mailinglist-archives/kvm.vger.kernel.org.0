Return-Path: <kvm+bounces-23364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DE5C948FBA
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 14:56:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A14461C211DA
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 12:56:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C7CB1C7B90;
	Tue,  6 Aug 2024 12:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="doPODls3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2076.outbound.protection.outlook.com [40.107.223.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0055F1C68B6;
	Tue,  6 Aug 2024 12:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722948939; cv=fail; b=fZgmA1e3X37tn3WivLAC7MOuXwKFijwqwJjPfP6MtCHkK/lYzdHd+X+0ZHC1gfcTzX11mMnzSqU3pXRqubllKUuyRYFGI13n1jbqCpRBUfYu5bYR4lcP95mOtgiWYTwuf1zQUWtTS18XwsZyNIIIdOLRxOwfdrMjmjGSh4Hz5I4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722948939; c=relaxed/simple;
	bh=sV2VioKNB6dprKJTpwHGT8OvuLFTHa50tCsHqogZuNw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eInuivxpBgPcB0xjlK7Fe7Vqn/g8KhI2iXuNxvXSIv7DpFOzi5uFaMylYWQgzG22VCbNyMN+Nv7lJKBiJcbppfeDckPNW/ebL9xQaQVhNl+0lz3tr+0ZHbsPWF5eIQSLMnBGEz/ZHVLyK0zbbDJaXj4d5/uWs8R/BfJ4SGh2LuA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=doPODls3; arc=fail smtp.client-ip=40.107.223.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NoU41E/2G3ky/6NexX4s6U4gBr22tQgLjwfTHocX3OFptU3x71OSzH6VslRhUwpgpZRBnL3ty2hawH+L+XtzuUOs9IRBOg2g/5K95CYaHCZx+VAgJW4zfN7sNJ6RCjJrqzEFWSmJARAOMn2LqGmuSCjGtua7g8XmbO4Z2m/sJhBdee64j5QyKmHck+DCoMpQpL+qbAX3d+HSGETIfcPPWw7x6GMh82X3BThPRZlFms3ARpajmYxj0VjIT95i6wzkzxrMWISgWYKEnnDQwYWZcKoO+X/kJZYfVNuFvFZXr5LMjROLsRkjKY2tevJzHXdCzi2LSfLcPqQWPQGv4v4rBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Xeld/lWBLWwjoCwAmVZ7ll51Ew+vowqsGsVy1JLH30=;
 b=GGp/4W4O9upUny2FQNBbeBvZYGLsrHHz9sIjT+lZ5W5KYzCGyZWuKSUqeNPFvWzyOSeaHJTtyAWn0QFlwnroMOacAx6aI1XxMCDnUZnuLPk48uy5utpysWL4F7wbnwsvCeyDTpmM0x40S7noEUtEhtvk79GzdJx98L7tL7c7yiH+X1+7epuBqkpApUDCr4uycHhhC5LILGsBt1ShTLmier/wG4kSH3J/E2tc9Unyeil1WX4L9vLL38IBJPT6Ox8UjE8OBtBAAnLD33+DcbJC2SsnFLtk9b3JvPopnRKKfAjX2nw9j8Nu7tj8QA4B7n7fFZ0RAqmb7oJIokTlRj4o7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Xeld/lWBLWwjoCwAmVZ7ll51Ew+vowqsGsVy1JLH30=;
 b=doPODls3OVWtgqPAaXrTKylK3U43vIQJ47PJaAq8zyVT6QbjnCFurl0V2s0xQXaLD50PxVo1akCkZvOE+Hzzyf9BSviLUA6zTR3lUXJjFMNLHjRM+0ACLS7S4wYN1sPLNS0itsyZV1t63lBZ+6z4BoBmSPoGiPamooTkfH8G++I=
Received: from BYAPR06CA0014.namprd06.prod.outlook.com (2603:10b6:a03:d4::27)
 by SN7PR12MB6689.namprd12.prod.outlook.com (2603:10b6:806:273::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.23; Tue, 6 Aug
 2024 12:55:35 +0000
Received: from SJ5PEPF000001CF.namprd05.prod.outlook.com
 (2603:10b6:a03:d4:cafe::32) by BYAPR06CA0014.outlook.office365.com
 (2603:10b6:a03:d4::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.27 via Frontend
 Transport; Tue, 6 Aug 2024 12:55:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001CF.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7849.8 via Frontend Transport; Tue, 6 Aug 2024 12:55:34 +0000
Received: from BLR-L-RBANGORI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 6 Aug
 2024 07:55:26 -0500
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
Subject: [PATCH v3 4/4] KVM: SVM: Add Bus Lock Detect support
Date: Tue, 6 Aug 2024 12:54:42 +0000
Message-ID: <20240806125442.1603-5-ravi.bangoria@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240806125442.1603-1-ravi.bangoria@amd.com>
References: <20240806125442.1603-1-ravi.bangoria@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CF:EE_|SN7PR12MB6689:EE_
X-MS-Office365-Filtering-Correlation-Id: b545426b-d1ab-41a9-0d48-08dcb6171000
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OeZBD/sB+2+4sGiHEECtZHuqLmkUzlRHjDVAn/AxxJGRkujxNMslX8RD3zLd?=
 =?us-ascii?Q?uw5CnjhiXrj8UzCxooVjcqRDkhBRBnwsvWG3oTIZmpg9R1M0z0YtSJM7EYV8?=
 =?us-ascii?Q?EoEQuXqw3tDCw3feNQ8w6fnmiCgox1olrrI7dWJyQqhDpwkR9ip6z6aQfT6b?=
 =?us-ascii?Q?HbFrMkmDasWwpH12VgJEmc2/VUhkvreDPLbr1fIy+MmBn8Ia6tc1bOpgEkXE?=
 =?us-ascii?Q?F8MgEM3gHObbRrfEiaPCbluHthnuQlv+6z+hHEgSI6grJTiHRdCv9rqiYs2s?=
 =?us-ascii?Q?A1s9iiJitNOV2g+UWQoWuQ64+pFHqMKEDjj5W6fHT2A5nkfzgsb5FWwR31/d?=
 =?us-ascii?Q?cmDqP29AuGJwJij3Q3CnGVpdHJDmhXaGFxeW+i6C7YmAFU4XNPlscS6YejpS?=
 =?us-ascii?Q?xcnIKrxBNzKUSt7rhVtJsuzskDdowLH+3tqAbOqZzmrEq8j05J2t6O+adIyd?=
 =?us-ascii?Q?KJ389xSd6SO+G9L2DI/x6nanjxjAzJPT127wtyDGBD5gAlY1tRJvrkZex59E?=
 =?us-ascii?Q?lXbZPzQeMhaAwqowX6wQCz/xDMx0wsPlGLas9i8uywqQzgZQFg46ZwhCEHuO?=
 =?us-ascii?Q?scQARsRSvPxsFAra2NSxEBv3YyAgplUGNTI+hdxxR+ThTcqGnIBmGRXTu380?=
 =?us-ascii?Q?UbyPA0BhTIyI23/KwrcpV3HnjPAAxFcoBIpj+gK06eIfHTYL+gpEs8gzY0Io?=
 =?us-ascii?Q?ph7KzRSzit8gzl0dZ7Ovhlsqe4xp1nXvgfmbgyGRrWQxuo1S/Q2e0kKZsHpf?=
 =?us-ascii?Q?GBd5GXDcdaraSfS9lEsVGQdr4lkZLbXiUCEURLHUpslgagiOwZdGK7pdvZrc?=
 =?us-ascii?Q?WpfhDlqPZ1noxibS542Zpprq29AkfhNbwGRGhEGeunw1TYmOPmUJN1b8j4pM?=
 =?us-ascii?Q?ZwKRjkq/SZroX9tpSvdBnDl0sK9/E7Aucz7RT1lu2ubJ+KjTHuAoR8Ooc6Xo?=
 =?us-ascii?Q?XJyJkL7HVXCmRMn1MScxb6wRujblTVLP0+oZILHLb2KHRZcSwKJsxMWZvQUI?=
 =?us-ascii?Q?8Lctz6/24iVt6E4RDivlQUl1HB1v8qnVbAcpN8OkxlYXKCc7yquK/kjdlsfJ?=
 =?us-ascii?Q?ybVIVUNmmibjKhK/8z5fnbgdRMrLkbgYtoXeLKFsSVbmvZOBM48+aOk01Hyx?=
 =?us-ascii?Q?ZIhu6Khp7gdHxaSThuDs2SR+MT8fMBFF3JMvRmpVmWHVjx2c2EK5UiGDtG40?=
 =?us-ascii?Q?faVW3qYPkKDy5taxwrTeQEsWficLb5ZVAQN1PtPb2NiVgpqF71eIMDP5T565?=
 =?us-ascii?Q?fMrzTNBCbvcNzEwDvzr+H2yWQcX9ub8JoOKxvHPQooEtgACpfxD+/QNiQelw?=
 =?us-ascii?Q?SEum+AVD8bW/wPGLLOfamQ4ixaLMaWGFWUnGMfYg3/CaWPvK69SsMDlHAagT?=
 =?us-ascii?Q?rjskbir6Z1c6iFHU6c1Zgfjtyd9d6VPUxFeXzpU/HKg8UC1rKVfu3ktxOOgz?=
 =?us-ascii?Q?9FvcpB9fTZ1Gi6R6pYYiQJ0E1/LVfKsc?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 12:55:34.4959
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b545426b-d1ab-41a9-0d48-08dcb6171000
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6689

Add Bus Lock Detect support in AMD SVM. Bus Lock Detect is enabled through
MSR_IA32_DEBUGCTLMSR and MSR_IA32_DEBUGCTLMSR is virtualized only if LBR
Virtualization is enabled. Add this dependency in the SVM.

Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
---
 arch/x86/kvm/svm/nested.c |  3 ++-
 arch/x86/kvm/svm/svm.c    | 17 ++++++++++++++---
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 6f704c1037e5..97caf940815b 100644
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
index 85631112c872..68ef5bff7fc7 100644
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
@@ -5224,8 +5229,14 @@ static __init void svm_set_cpu_caps(void)
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


