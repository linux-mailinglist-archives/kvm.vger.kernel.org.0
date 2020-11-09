Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8742AC89D
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 23:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731400AbgKIWad (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 17:30:33 -0500
Received: from mail-bn8nam12on2074.outbound.protection.outlook.com ([40.107.237.74]:54528
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732556AbgKIWad (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 17:30:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LwGJ+bFG8LIH+OPnmTcbxbW8aCKeFQ4o1scVkQmtRyhtPUWYZhmYyDmpN1/AWrQo1lOBX8lySXFETlUPblHaMFdj/DHob5u5NPgKIHjuUh0LkNSohiKmOoKC4M6QkAyGxt1QyAGxkSXqjrJ/UCYLfUzPl0uQnd4Kw6J1ODnrcQrhO4Y7mu1YDRmkSC2YWijk03ffW5xt6shyVpcnjD6Nz74Wjp7wgcRflh7IfqbKVasTXBUT27uTwaEQFMWd4/IqO3abeDg0+9im8woqrhsW3hGn8Hd6z0wAu2pq7nzm7YvlzR+Je9MeGIkpq0XHbHo8UjOZbVsXrDINYuJekQa5yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=twdu+7A1PXcgyFBvb/ivXPArmtFG5x6zqxQic9g+MTw=;
 b=KrVTM7WMuRVhatJtG6t8JChdQYLiVfnNbeY1Ue8Ecrhnq49iJN8/qIOJ7jCj2RBkQb0StQNsp3w+8YjIOFbdxN/s/OF+sIx7RDLK9FVyLvb24VwHZf3N4WWchITwDXijJU4U6d04HH7UiDYDUgltbI0sDM7hAbtJQVw7XzbPYBaAWnbKt/LhQLs71OWJ6hjGTE63CIBv4e72LDfLlGmsn1e6H7TEuyTDSvmDA51lD4dcdG+3E2Hy/aMtZsNDfoZY9ftVr2uP7LOA/FvEd07VAnz73QruCTBpT8TqOYIBLqUH89mHsmVeNVseTprxLIM4F2dZ7BU7faSgN+atd+zp3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=twdu+7A1PXcgyFBvb/ivXPArmtFG5x6zqxQic9g+MTw=;
 b=CVBTv7DKyGgDMcTCXbhOTCvRRR61vVZo57gWqw8PRqgUOvhofVPN42zXVvx1acs8JXKE38UxeP0xDhDNJOslIQyJwJHCFFsW0/aEEZBmpJxq37SS7gvH71ANzhv6RMoFOmqtEGz8W+EPUu3FfUJK9gIpNfckO1zt8DhV9AN6i60=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4058.namprd12.prod.outlook.com (2603:10b6:5:21d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.21; Mon, 9 Nov 2020 22:30:29 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba%6]) with mapi id 15.20.3499.032; Mon, 9 Nov 2020
 22:30:29 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v3 33/34] KVM: SVM: Provide an updated VMRUN invocation for SEV-ES guests
Date:   Mon,  9 Nov 2020 16:25:59 -0600
Message-Id: <31129ae3514accac0eed361363a40651fd8e3450.1604960760.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1604960760.git.thomas.lendacky@amd.com>
References: <cover.1604960760.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM6PR07CA0057.namprd07.prod.outlook.com
 (2603:10b6:5:74::34) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM6PR07CA0057.namprd07.prod.outlook.com (2603:10b6:5:74::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 22:30:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6ffd78f3-2d6e-4c85-bc94-08d884ff0ff5
X-MS-TrafficTypeDiagnostic: DM6PR12MB4058:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4058A195724CAF924B3116C2ECEA0@DM6PR12MB4058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x8tSranLqzbQrRLbxz+IICD9DCWlj/v6c7XBI8p4+a73Xh4c4iuJQIGYi64f1yW9X5ipFKfU2Y1Uc/XiN31rv05FYKn+e/LpIZyLwohwUIFR/PQAOYZxMOVQ4u9XpbWcSuyZX9ZDqbyqFXUhTktfm7AwseEUMi4z65ofhNa97gRKnRMDJ6iz6RpoDVCdYsLIOLKfK2nEoa0vmNU/Tw+768zGzC41e6e+Wcy1y3lFz2gQKU0EZaTQPPdxExt4KFDkcLb7zuCBbi2X010x5tdW2cV4ut3ep1lz8EfSCRTj0GJFBuT3RSqNeLXthhhgjLt/2vY8vg12khWBQ9e8vlRD9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(2616005)(956004)(8676002)(16526019)(54906003)(316002)(86362001)(4326008)(26005)(8936002)(7416002)(15650500001)(36756003)(5660300002)(52116002)(6666004)(7696005)(66556008)(66476007)(66946007)(6486002)(478600001)(83380400001)(2906002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: NnDxSt9Sg/NO56f+oTUol9UFNvmeu+MsNXqBr1WvVkFJl6BvsFAP1Bbee1bOQtpwjlrKbwiJqIjK1U6cO8j/HvnCHrCSuAjNo4OvPvVpEzXimJRi3H/EJbFN57qL4Usvpim8I1s6Rq7ctVRTSiYfCOq61zZOHDr8qqd8cvsM8L3KFdDiMfSla6IoefQLcovjiiPQfkxinCjsW+rPp+MOR7OIJk1enx3s0YUHLXiZF8tk/+NO6zZclsbSQr9/bpNzHuIoPORz7WI0El+XtN9Z4Z79Nsj7Kq8JbGs6wpBst3d4/c2FfN95xKppkl2heKSLQb6tLClhP6cAN7SfG1Yg2gjOczA4hc7pKlAMCHWkPi7j8vnjTSMob4l+1Ht8GyUTUVaIM3b6yJG6TT3pMbGbbXf3MRDgONkINQKzkrW9VUP0X9wxmEQlXAIEIsM5pA6bfwD4UrAEg1LpMDWIO0h/QIAj3SaXPJu4llSrsd2p2w2iW1BcT/xSqJhCs1jxbmCbxkCnBOje2QZAkEGUeMfU3uKC/u16jUVS5Ueb7Rc8OG0zBp8PqzZ2RuwKvOx9aPop/3qS2b677TpsBq5APDmIZNInTffW3zHHK+wDCojjOM98PebfP4jbE8lfRe/hze46YxB4KWok/OWYdBkaw/nWsQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ffd78f3-2d6e-4c85-bc94-08d884ff0ff5
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 22:30:29.3704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oFUL0a9+ssPAlVE9LTvRvFfpdYWYqLvZ2T1yqFdnn19Q4Zmnxv+8IRAG+1swADRU49KfOTpewDwTHyR5/fan+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4058
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
index f55ea683299b..7b3cfbe8f7e3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3748,16 +3748,20 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu,
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
@@ -3851,14 +3855,17 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
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
index 5229c5763a30..e93421d59a1b 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -593,4 +593,9 @@ void sev_es_create_vcpu(struct vcpu_svm *svm);
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
index ac90a7c11193..4097d028c3ab 100644
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

