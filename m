Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3F192D633B
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 18:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392691AbgLJRPS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 12:15:18 -0500
Received: from mail-bn8nam11on2059.outbound.protection.outlook.com ([40.107.236.59]:9021
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392680AbgLJRPQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 12:15:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hx7tY/8HbM3vgHYR96OTDLAu5LuvDcx2GtK7cqRjKgw4R/FXxdHQlAl8Luq4nKI4oPr30sI/MlXcRLP2OvZ5bod4OpUcsvr4kFeg7OJt5Bh61Y6cSqqo+DXTRyYpV6vnSuxXy0WlW5DwmjmM/RjYm1a3FzJtpxJ5wzU7LMS6jnz93N4Ub4GhbH0+z+s4nsrg5VICKbFIsMiZ3mXEMbIBzfTT40Xqvw7vG3SqjPTKUXriQgJ6RjqzNHasPCz6YqtedAVMhPSIH7cdNTkAnyGJKmL+BnEmNvnTeD5N+vJelrPeLYmrV1es7bSSEVojMrlZKKyleSsM5zrtizQQ8COwuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7NiQZOHIGuwczuAxMiapS/aYYGmHfME/twUIKSSchI0=;
 b=hU5vtZjzwT+02yWgJ1i08jGXXVslKQL32XXT5fio9thoNjk7+yPhj5jgce7+cv6+gL3cg4yKYNTGwkU8s6RN4jcJBzRSqDyDB+BbrkjC4jc+wpqgS1GaOEmp6E2ijSPMLK7ruQoUNQK+YsDI7sLg10On6SmhLMuLtpVGNBVwXOoZgcRk+XdTwR15/iNPA4+2VgiobK/NA5kClfeirJFbF5vALydFpcSOjFAIXB7hO9bokL1BCo1jDCwj+o5Po3JRypya7XhLhj3E7Jm2PP7QUFjK4Ck6gAlzMVn5L3nrVuYwG6SdTbAjNuayMovOzx0h2GY023oO7zRSuw8WArTZLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7NiQZOHIGuwczuAxMiapS/aYYGmHfME/twUIKSSchI0=;
 b=AWmOikrmAKVlvonCBEq6i1j0KWN8YFddZLf0IRH36QwqI0u55TmB3PteLnfHAwZMJrxDhgg/xUQZvcCzEc8qv6+ykDv8kbIIwRRqKKug4OL4cnan1RTyPfCWFxtgyIZ19qpEvcxb7R0FJFhoi7Aug9iZ3EQDl7QqY+LTH4qE8S4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR1201MB0149.namprd12.prod.outlook.com (2603:10b6:910:1c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Thu, 10 Dec
 2020 17:13:28 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d%8]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 17:13:28 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v5 21/34] KVM: SVM: Add support for CR0 write traps for an SEV-ES guest
Date:   Thu, 10 Dec 2020 11:09:56 -0600
Message-Id: <182c9baf99df7e40ad9617ff90b84542705ef0d7.1607620209.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607620209.git.thomas.lendacky@amd.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR10CA0020.namprd10.prod.outlook.com
 (2603:10b6:610:4c::30) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by CH2PR10CA0020.namprd10.prod.outlook.com (2603:10b6:610:4c::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 17:13:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e4cf9236-f2f2-4dec-b608-08d89d2ee9bf
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0149:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0149ED087E436C89E404BDF5ECCB0@CY4PR1201MB0149.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k1uZO0YpphLXIAxjqJHO8hm+j3v2hiKCqeW8nhclUBXXQnNEwS70PwmmbGXTOXFLsbsa9bYDsMuUf7jRk3G5vmRJJHW0qbc0Y4VsDbReC7NqaoSlZsaoepv2jHofFyJ9YJtpEYzh5qbjbPULHcu+T8gDfXL/lihEyac5eXa5fnbHHPzP3xHPoHE/ANC8xZQcGId3nLC9J8LqUx5xxb1cz7u2qBa+v1NhDF9iTO2yU70ti+gf4SBbLIK7v4Yexk2nTEdBe8NSMHw+QinUB17tIch5k7u+HpdpTQLyLEhHVJWJ4fOq7T1m26+rHCstSLZohtpBmGBGas9IUXnUowExixNHrdiiDCGal4bMtr+dAgOL9kgPTd0O3DXhcz7/qCun
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(366004)(2906002)(5660300002)(6666004)(26005)(52116002)(186003)(83380400001)(16526019)(54906003)(6486002)(956004)(2616005)(8936002)(7696005)(508600001)(66946007)(66476007)(36756003)(8676002)(86362001)(34490700003)(4326008)(7416002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?tadkcZgujvlKQMtFHDL30XH3wGJcxMYs4ztCBkAPdmMAjmftM1825fiiKMyu?=
 =?us-ascii?Q?bsJPNohC6XEw8KIZr4L7NNPc2RIkhMiE8n90xfeY5Ev2JhgPNEPKlGvWG5ON?=
 =?us-ascii?Q?MJ9QBU84U9AFr9SbxqiX60gxg5QSkxONoyTw6pvYGVeDvrbcMX6XsoEHzgxb?=
 =?us-ascii?Q?yFmTuGe3GoxijXyRJ3AgjToRowR2U2hludoRVHyTV3YO2myEd/2VLYTttEw7?=
 =?us-ascii?Q?GGM9LKP5+q6xTmJHlAKwAWZm2uaO2uVRW9+2HtGRbVZACGNCHW41/2oWPYZe?=
 =?us-ascii?Q?xwdq5Zc2g1ZZoScOeQ1qA5ewu5FrEOPRYIwtjvCNcKKCNG/CX5UD5d+3PMGJ?=
 =?us-ascii?Q?iWH5IN6oxSWOVvjQCDgsfh9Oepksdu6mllbPHuj7WCaJFdtJQFhVD5tc9DiH?=
 =?us-ascii?Q?8zIb9duMTri5KG9UCG2tCJOGbFYbW9vxXl4x3Og+DC6StooikmYQDD9Ykkru?=
 =?us-ascii?Q?rjcYfXUwZTVMo2z7Qs1FBNSNeS3Z3Mv/MBZyFPR6qZEaGORQ9cWKcwa3Lhks?=
 =?us-ascii?Q?dMv08uZ+xGpMZYBMT8NBPrJbh30AziZqr3ltif5fqWwU7A7NmuUn98AmNoLB?=
 =?us-ascii?Q?Teshw/g6Uic1ikdztTlcHuxJRAXCTm5snHKmzFOIgseY4NrfGN00eqpVVq6i?=
 =?us-ascii?Q?1sjap/cDr6Lxj17C6o5ZNpwrsmCenjRU13mr2OVlVEez4fNnQ+mLIcNIOupz?=
 =?us-ascii?Q?ZVTWmQOlXgCDcH/snxPvn39VP27TciujqpM2FD4YEVcwN0LernDgaUaHD7id?=
 =?us-ascii?Q?Szqii+srGlRvu/De/QpQpNSgTyGhPiypYLEShdabwrk8I+gUZwoevhHISsZR?=
 =?us-ascii?Q?+gUPGLVh61yJms29/lvDiLLlXjfyfaGjs1mF4S03NzUWRpLXAC30BIrR+tgN?=
 =?us-ascii?Q?iDzaYraz3/LpKy0Bmn4izrA889DJn0BNiFADL4Elw8C5GbnsI9kL2O55je53?=
 =?us-ascii?Q?KU332kB9Bdzc8Vw8dP4eVu8XjmRM7lBZr4wiNclcRTgTm5nYVe0ApdPal66a?=
 =?us-ascii?Q?A1wF?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 17:13:28.7557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: e4cf9236-f2f2-4dec-b608-08d89d2ee9bf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iy7i2CCy5l4uNfH9RSs8wg/XAK8RYRgpMRpzTOTKkR4jY9Ob2kpXJ0L7mQBKg0kANN50LV0/sFLobZh5cPnQ/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0149
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

For SEV-ES guests, the interception of control register write access
is not recommended. Control register interception occurs prior to the
control register being modified and the hypervisor is unable to modify
the control register itself because the register is located in the
encrypted register state.

SEV-ES support introduces new control register write traps. These traps
provide intercept support of a control register write after the control
register has been modified. The new control register value is provided in
the VMCB EXITINFO1 field, allowing the hypervisor to track the setting
of the guest control registers.

Add support to track the value of the guest CR0 register using the control
register write trap so that the hypervisor understands the guest operating
mode.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/include/uapi/asm/svm.h | 17 +++++++++++++++++
 arch/x86/kvm/svm/svm.c          | 26 ++++++++++++++++++++++++++
 arch/x86/kvm/x86.c              | 33 ++++++++++++++++++++-------------
 4 files changed, 64 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 26f937111226..2714ae0adeab 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1476,6 +1476,7 @@ void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
 		    int reason, bool has_error_code, u32 error_code);
 
+void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned long cr0);
 int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
 int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3);
 int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index 6e3f92e17655..14b0d97b50e2 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -78,6 +78,22 @@
 #define SVM_EXIT_XSETBV        0x08d
 #define SVM_EXIT_RDPRU         0x08e
 #define SVM_EXIT_EFER_WRITE_TRAP		0x08f
+#define SVM_EXIT_CR0_WRITE_TRAP			0x090
+#define SVM_EXIT_CR1_WRITE_TRAP			0x091
+#define SVM_EXIT_CR2_WRITE_TRAP			0x092
+#define SVM_EXIT_CR3_WRITE_TRAP			0x093
+#define SVM_EXIT_CR4_WRITE_TRAP			0x094
+#define SVM_EXIT_CR5_WRITE_TRAP			0x095
+#define SVM_EXIT_CR6_WRITE_TRAP			0x096
+#define SVM_EXIT_CR7_WRITE_TRAP			0x097
+#define SVM_EXIT_CR8_WRITE_TRAP			0x098
+#define SVM_EXIT_CR9_WRITE_TRAP			0x099
+#define SVM_EXIT_CR10_WRITE_TRAP		0x09a
+#define SVM_EXIT_CR11_WRITE_TRAP		0x09b
+#define SVM_EXIT_CR12_WRITE_TRAP		0x09c
+#define SVM_EXIT_CR13_WRITE_TRAP		0x09d
+#define SVM_EXIT_CR14_WRITE_TRAP		0x09e
+#define SVM_EXIT_CR15_WRITE_TRAP		0x09f
 #define SVM_EXIT_INVPCID       0x0a2
 #define SVM_EXIT_NPF           0x400
 #define SVM_EXIT_AVIC_INCOMPLETE_IPI		0x401
@@ -186,6 +202,7 @@
 	{ SVM_EXIT_MWAIT,       "mwait" }, \
 	{ SVM_EXIT_XSETBV,      "xsetbv" }, \
 	{ SVM_EXIT_EFER_WRITE_TRAP,	"write_efer_trap" }, \
+	{ SVM_EXIT_CR0_WRITE_TRAP,	"write_cr0_trap" }, \
 	{ SVM_EXIT_INVPCID,     "invpcid" }, \
 	{ SVM_EXIT_NPF,         "npf" }, \
 	{ SVM_EXIT_AVIC_INCOMPLETE_IPI,		"avic_incomplete_ipi" }, \
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3b61cc088b31..e35050eafe3a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2470,6 +2470,31 @@ static int cr_interception(struct vcpu_svm *svm)
 	return kvm_complete_insn_gp(&svm->vcpu, err);
 }
 
+static int cr_trap(struct vcpu_svm *svm)
+{
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	unsigned long old_value, new_value;
+	unsigned int cr;
+
+	new_value = (unsigned long)svm->vmcb->control.exit_info_1;
+
+	cr = svm->vmcb->control.exit_code - SVM_EXIT_CR0_WRITE_TRAP;
+	switch (cr) {
+	case 0:
+		old_value = kvm_read_cr0(vcpu);
+		svm_set_cr0(vcpu, new_value);
+
+		kvm_post_set_cr0(vcpu, old_value, new_value);
+		break;
+	default:
+		WARN(1, "unhandled CR%d write trap", cr);
+		kvm_queue_exception(vcpu, UD_VECTOR);
+		return 1;
+	}
+
+	return kvm_complete_insn_gp(vcpu, 0);
+}
+
 static int dr_interception(struct vcpu_svm *svm)
 {
 	int reg, dr;
@@ -3051,6 +3076,7 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_XSETBV]			= xsetbv_interception,
 	[SVM_EXIT_RDPRU]			= rdpru_interception,
 	[SVM_EXIT_EFER_WRITE_TRAP]		= efer_trap,
+	[SVM_EXIT_CR0_WRITE_TRAP]		= cr_trap,
 	[SVM_EXIT_INVPCID]                      = invpcid_interception,
 	[SVM_EXIT_NPF]				= npf_interception,
 	[SVM_EXIT_RSM]                          = rsm_interception,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fcd862f5a2b4..1b3f1f326e9c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -804,11 +804,29 @@ bool pdptrs_changed(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(pdptrs_changed);
 
+void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned long cr0)
+{
+	unsigned long update_bits = X86_CR0_PG | X86_CR0_WP;
+
+	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
+		kvm_clear_async_pf_completion_queue(vcpu);
+		kvm_async_pf_hash_reset(vcpu);
+	}
+
+	if ((cr0 ^ old_cr0) & update_bits)
+		kvm_mmu_reset_context(vcpu);
+
+	if (((cr0 ^ old_cr0) & X86_CR0_CD) &&
+	    kvm_arch_has_noncoherent_dma(vcpu->kvm) &&
+	    !kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
+		kvm_zap_gfn_range(vcpu->kvm, 0, ~0ULL);
+}
+EXPORT_SYMBOL_GPL(kvm_post_set_cr0);
+
 int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
 	unsigned long old_cr0 = kvm_read_cr0(vcpu);
 	unsigned long pdptr_bits = X86_CR0_CD | X86_CR0_NW | X86_CR0_PG;
-	unsigned long update_bits = X86_CR0_PG | X86_CR0_WP;
 
 	cr0 |= X86_CR0_ET;
 
@@ -847,18 +865,7 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 
 	kvm_x86_ops.set_cr0(vcpu, cr0);
 
-	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
-		kvm_clear_async_pf_completion_queue(vcpu);
-		kvm_async_pf_hash_reset(vcpu);
-	}
-
-	if ((cr0 ^ old_cr0) & update_bits)
-		kvm_mmu_reset_context(vcpu);
-
-	if (((cr0 ^ old_cr0) & X86_CR0_CD) &&
-	    kvm_arch_has_noncoherent_dma(vcpu->kvm) &&
-	    !kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
-		kvm_zap_gfn_range(vcpu->kvm, 0, ~0ULL);
+	kvm_post_set_cr0(vcpu, old_cr0, cr0);
 
 	return 0;
 }
-- 
2.28.0

