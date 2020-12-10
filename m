Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E79D52D6344
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 18:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404128AbgLJRQd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 12:16:33 -0500
Received: from mail-bn7nam10on2081.outbound.protection.outlook.com ([40.107.92.81]:2432
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404159AbgLJRQX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 12:16:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hvn6pESUUmBNb9yw2yl4c11fleOfQA2X9BiLeVMAjBbowXvYTLbZYHxajRyz2ERs+xGCeONmVY5jw91BNJr4PKP8ngQN4Y0GB0kVfDB2BDzGigDFS+i0e5VQwo02Q3SRIX+S75+4CZR87R5osJQsdBCZpzbV3GbQ7XSMmasDKEN2pD0bdZSzoMC335mRZ25kjUMSfiZQoOPk4Byi1sH2DgEXEn6OCz3yk9Whn+z6X3SZQvqPhjwBxT6YarMENYJsVFoRYA2dZrUErHvZILzTAWfFhPlsU0A/Mta9veD8qk7J/CpSKBdo/jTF7L6dQT3IdNNBZiFMeMPL+DgQ3JBWBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZQqyfhHhncnDjQhZ7BxnrkhjdxuaF4ucYyRVDrwOPuM=;
 b=g7s73Kysmgh8qrXhbzdn6ozQhjZvNdjAIYvbl3WvxqFCFeJLg2lkWkT6eYJ9XJdbp6XuaUeUxQauB/rod+K9S4nNBLf7ZSLXp8Vz7ZFuvWeDqUsiohFLA7fnYvUzL46igNmgqXM8naXSD0vp4PzfGz6Ppw7SZeoa7p2iAgBQB5o6mS6jnMOJlKlQOYxcRXcySn8WJC5fE2YELr2t/hJAfZLJUo9oRD81gsioTKsVGOdt6lXxwP6L1C+tkVCt3DP9hLl6a9rsibuxm+y96DbwcKK+8F8pO+UdSMr905HaC+CkKcvYa0bkRtWa6vq0j0g2jrrPcZGBwyUKQLES9SJzmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZQqyfhHhncnDjQhZ7BxnrkhjdxuaF4ucYyRVDrwOPuM=;
 b=fSku9234FESBIFVkGQ8Nqw5jlSW4aCDnl+mGVjtybFBZUZjIKpHq5w4lgvnTaaXMdoM+nXWJncvQ3NOROcwtu2C2h6cIDZXx6lg8ZEFJ8WfR7JUVcFPVI5Z4bkM49GTTegY/eCzu54a3Baf8HB2pQLRdMDY2hgyw5xeEj5QQH/k=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR12MB1350.namprd12.prod.outlook.com (2603:10b6:903:41::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.20; Thu, 10 Dec
 2020 17:15:15 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d%8]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 17:15:15 +0000
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
Subject: [PATCH v5 33/34] KVM: SVM: Provide an updated VMRUN invocation for SEV-ES guests
Date:   Thu, 10 Dec 2020 11:10:08 -0600
Message-Id: <fb1c66d32f2194e171b95fc1a8affd6d326e10c1.1607620209.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607620209.git.thomas.lendacky@amd.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR05CA0066.namprd05.prod.outlook.com
 (2603:10b6:610:38::43) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by CH2PR05CA0066.namprd05.prod.outlook.com (2603:10b6:610:38::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.5 via Frontend Transport; Thu, 10 Dec 2020 17:15:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 70858637-4614-4b6a-90d2-08d89d2f2953
X-MS-TrafficTypeDiagnostic: CY4PR12MB1350:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB135027076967E49A3030BDAEECCB0@CY4PR12MB1350.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1DC4X2+XOc6nFb7EjTchVLrBI692ml/QQTwoZnNoyerCo7s86O4yywSWjku9txVHx7KUq8rtwKWK98SgyIUXt/sTpVzIYJUXge9ywnEO80Jj+BNZ/nEPuqs5r0Ar4KqRTk7nE4NxFjP9ep0e0fLgDAY8dlLJ2k3glgR0rKDOVOcoCsw1mogKnHLQyC4mb8NQk+UDGlRZJ59UwqVkh1TBReGlM+xvk/QA9EXSCcrzZoDmeAWc7MTVyq+0ltHRTGzLdWQ/i3ER0d0eoN+j5jvSfW0ESlpSYyQqDdH8vuDfvMAItSTw1HSlmdkcVxcD2NmkQUuxCdg0b7o6XLxAchufHnV5ww7C6gMfdqCRiNwi7C3HttnoU681E5R0Q/FCNWew
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(346002)(136003)(6486002)(8936002)(16526019)(2906002)(2616005)(54906003)(508600001)(86362001)(52116002)(66946007)(36756003)(6666004)(8676002)(7696005)(83380400001)(4326008)(34490700003)(956004)(26005)(66556008)(66476007)(15650500001)(7416002)(5660300002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?DN6r20NYZHj/Q2KrA1fvTe6E3yKKa/0yZoyfrgVKZYKuDK+r6IzeLJILVmS/?=
 =?us-ascii?Q?n4KQs1qIKQ6TeAIod+NEkgf5+U4+6H9qXF4Dyd0nZyqYZCpol9VAzALoLzGQ?=
 =?us-ascii?Q?+J08YjnHzxeLdfcIo+ymZoCxb7XBZTSlrrpmeUcHp1Qkpj3Y7vR2MKhdWcH4?=
 =?us-ascii?Q?9ZAmStd7I3ljRioIa4ZEHsPU4Fp1MIzx3r457RVnnMX96u/852LjIxPLu8NT?=
 =?us-ascii?Q?Spq2HjcEo58pPyGhxKrpUQ+cIA48+3AhYJd/YBTnYHTMz6SkbkEudq4eR6ID?=
 =?us-ascii?Q?JHP1kEfoG6VXpFKjf22GbAKCJhb+qBv1T4VOfCu0HItk3jgToXKqoU6efrVT?=
 =?us-ascii?Q?hTcUGcHgwb4R3EL9Uyv9/VycIQZajrQydj4pbv9fWgaI61gRDeXY90/458y3?=
 =?us-ascii?Q?lPKM6dOOz5aiPAWu44He2q5HZk7Q/5cHJBLlPpTL970yuTDrICpaMy1qmI6C?=
 =?us-ascii?Q?yDJzVGylg6Bc1k/OUAX5djBZmc4Bg1zvf2RrepInEEsrOymAXplOBNKPhjUK?=
 =?us-ascii?Q?x6c0vqaq5b/WbS0YEPE2MxcIxZeGzg9f+EyaS4/pMlFpB3v5OO+f6+/aVk9U?=
 =?us-ascii?Q?/AzKTgnMQOccthuP1pw8S7BkDUN0MwoyH+eAmuu+OhaGKxBwfQQNow1TMr28?=
 =?us-ascii?Q?1C+lT6wD29bzZLU7rtOgdchaTjFgAqpIB+4XiH2YeaLpIOql7x+zOn5HYrCY?=
 =?us-ascii?Q?eCbG0NWkd5UmlFERpGAQGkpVN0242H2JD38G2+rqWnDfqi+obCN4LhOdqu26?=
 =?us-ascii?Q?YN3gjB1TDzefrVLUJmxVHlfBmH/FCaVpJ4SCh/5152Ur29GTCFAkMak6BlnJ?=
 =?us-ascii?Q?GsOOSV3OiuhG2fAjMoL4fCurSXDn7GhPDcsmTw/hZRTKv8znodR6dbasQOoK?=
 =?us-ascii?Q?TDaPj3JPt310GhRNQChFc4jquVkX73ai9CcJ7/w94S3bJnY+qlEeoMNiJQ9p?=
 =?us-ascii?Q?tAoTEVjZ1zvgDzy/lHBzBvDRa4eWgxHGg5wkKXplKn/BrUSFqgUIM4krnRpQ?=
 =?us-ascii?Q?fs3V?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 17:15:15.4051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 70858637-4614-4b6a-90d2-08d89d2f2953
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zFrWVtxUEQlqgd1v5nhTG+q0jHr7Q7Fg8fLQpeQ3Kly4t05QeMH1L64wGJP1lJuobUE5qb2TIz7lx8iEC3g2fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1350
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

The run sequence is different for an SEV-ES guest compared to a legacy or
even an SEV guest. The guest vCPU register state of an SEV-ES guest will
be restored on VMRUN and saved on VMEXIT. There is no need to restore the
guest registers directly and through VMLOAD before VMRUN and no need to
save the guest registers directly and through VMSAVE on VMEXIT.

Update the svm_vcpu_run() function to skip register state saving and
restoring and provide an alternative function for running an SEV-ES guest
in vmenter.S

Additionally, certain host state is restored across an SEV-ES VMRUN. As
a result certain register states are not required to be restored upon
VMEXIT (e.g. FS, GS, etc.), so only do that if the guest is not an SEV-ES
guest.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/svm.c     | 25 ++++++++++++-------
 arch/x86/kvm/svm/svm.h     |  5 ++++
 arch/x86/kvm/svm/vmenter.S | 50 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c         |  6 +++++
 4 files changed, 77 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8fcee4cf4a62..e5a4e9032732 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3756,16 +3756,20 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	guest_enter_irqoff();
 	lockdep_hardirqs_on(CALLER_ADDR0);
 
-	__svm_vcpu_run(svm->vmcb_pa, (unsigned long *)&svm->vcpu.arch.regs);
+	if (sev_es_guest(svm->vcpu.kvm)) {
+		__svm_sev_es_vcpu_run(svm->vmcb_pa);
+	} else {
+		__svm_vcpu_run(svm->vmcb_pa, (unsigned long *)&svm->vcpu.arch.regs);
 
 #ifdef CONFIG_X86_64
-	native_wrmsrl(MSR_GS_BASE, svm->host.gs_base);
+		native_wrmsrl(MSR_GS_BASE, svm->host.gs_base);
 #else
-	loadsegment(fs, svm->host.fs);
+		loadsegment(fs, svm->host.fs);
 #ifndef CONFIG_X86_32_LAZY_GS
-	loadsegment(gs, svm->host.gs);
+		loadsegment(gs, svm->host.gs);
 #endif
 #endif
+	}
 
 	/*
 	 * VMEXIT disables interrupts (host state), but tracing and lockdep
@@ -3863,14 +3867,17 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	if (unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))
 		svm->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);
 
-	reload_tss(vcpu);
+	if (!sev_es_guest(svm->vcpu.kvm))
+		reload_tss(vcpu);
 
 	x86_spec_ctrl_restore_host(svm->spec_ctrl, svm->virt_spec_ctrl);
 
-	vcpu->arch.cr2 = svm->vmcb->save.cr2;
-	vcpu->arch.regs[VCPU_REGS_RAX] = svm->vmcb->save.rax;
-	vcpu->arch.regs[VCPU_REGS_RSP] = svm->vmcb->save.rsp;
-	vcpu->arch.regs[VCPU_REGS_RIP] = svm->vmcb->save.rip;
+	if (!sev_es_guest(svm->vcpu.kvm)) {
+		vcpu->arch.cr2 = svm->vmcb->save.cr2;
+		vcpu->arch.regs[VCPU_REGS_RAX] = svm->vmcb->save.rax;
+		vcpu->arch.regs[VCPU_REGS_RSP] = svm->vmcb->save.rsp;
+		vcpu->arch.regs[VCPU_REGS_RIP] = svm->vmcb->save.rip;
+	}
 
 	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
 		kvm_before_interrupt(&svm->vcpu);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 657a4fc0e41f..868d30d7b6bf 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -594,4 +594,9 @@ void sev_es_create_vcpu(struct vcpu_svm *svm);
 void sev_es_vcpu_load(struct vcpu_svm *svm, int cpu);
 void sev_es_vcpu_put(struct vcpu_svm *svm);
 
+/* vmenter.S */
+
+void __svm_sev_es_vcpu_run(unsigned long vmcb_pa);
+void __svm_vcpu_run(unsigned long vmcb_pa, unsigned long *regs);
+
 #endif
diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index 1ec1ac40e328..6feb8c08f45a 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -168,3 +168,53 @@ SYM_FUNC_START(__svm_vcpu_run)
 	pop %_ASM_BP
 	ret
 SYM_FUNC_END(__svm_vcpu_run)
+
+/**
+ * __svm_sev_es_vcpu_run - Run a SEV-ES vCPU via a transition to SVM guest mode
+ * @vmcb_pa:	unsigned long
+ */
+SYM_FUNC_START(__svm_sev_es_vcpu_run)
+	push %_ASM_BP
+#ifdef CONFIG_X86_64
+	push %r15
+	push %r14
+	push %r13
+	push %r12
+#else
+	push %edi
+	push %esi
+#endif
+	push %_ASM_BX
+
+	/* Enter guest mode */
+	mov %_ASM_ARG1, %_ASM_AX
+	sti
+
+1:	vmrun %_ASM_AX
+	jmp 3f
+2:	cmpb $0, kvm_rebooting
+	jne 3f
+	ud2
+	_ASM_EXTABLE(1b, 2b)
+
+3:	cli
+
+#ifdef CONFIG_RETPOLINE
+	/* IMPORTANT: Stuff the RSB immediately after VM-Exit, before RET! */
+	FILL_RETURN_BUFFER %_ASM_AX, RSB_CLEAR_LOOPS, X86_FEATURE_RETPOLINE
+#endif
+
+	pop %_ASM_BX
+
+#ifdef CONFIG_X86_64
+	pop %r12
+	pop %r13
+	pop %r14
+	pop %r15
+#else
+	pop %esi
+	pop %edi
+#endif
+	pop %_ASM_BP
+	ret
+SYM_FUNC_END(__svm_sev_es_vcpu_run)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 47cb63a2d079..7cbdca29e39e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -880,6 +880,9 @@ EXPORT_SYMBOL_GPL(kvm_lmsw);
 
 void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
 {
+	if (vcpu->arch.guest_state_protected)
+		return;
+
 	if (kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE)) {
 
 		if (vcpu->arch.xcr0 != host_xcr0)
@@ -900,6 +903,9 @@ EXPORT_SYMBOL_GPL(kvm_load_guest_xsave_state);
 
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
 {
+	if (vcpu->arch.guest_state_protected)
+		return;
+
 	if (static_cpu_has(X86_FEATURE_PKU) &&
 	    (kvm_read_cr4_bits(vcpu, X86_CR4_PKE) ||
 	     (vcpu->arch.xcr0 & XFEATURE_MASK_PKRU))) {
-- 
2.28.0

