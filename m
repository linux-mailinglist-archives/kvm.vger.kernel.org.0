Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8450F2818CF
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 19:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388587AbgJBRHo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 13:07:44 -0400
Received: from mail-eopbgr770085.outbound.protection.outlook.com ([40.107.77.85]:24199
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388213AbgJBRHo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Oct 2020 13:07:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jS9gezb6+5FMz+1opddkbDe7wC6HOF1aPKcXKdDxXGRjWcSmQ+L13XO0Vkm1upwbcpYmxJ9jTSKzOQdtCfZQ4VBqfAHPaVRz+O1BeMm7dwMBpOqSUTX0tX38/qh4eF8OpL6fcDhJRc7tuI6EP9XrbiI57A5e6Ol+QTCpY3DJPh5/4HbamdCDWHXb2alYWXTfGCftuMy0xrpxZbXv3aUoROe6VxQa2aEVZgvAOPsdmq9F6e3ozg2uaJK1k2oj8ca53SEqIb0yOWGXIyisUjHIwoXe/R7NNCScu7WlHYfwjS4SBiParim0OhLfEVU6NDuPWGZl59oqM5e8vv09LS1vRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cT1g4geeGEo/khIIs3d9GtMnIE5wFM7APl17ylG7a6E=;
 b=bJ0P+Z/ECvqTporobeRm1jxri1LA+7KH81tQFxLvn1plHNcMMVNRJJEPg2KR/Qc4/pKl/YrE+3uB7+YOIXJMb1bwVzes+tyIiDJSrqNu6fQHpRHYgJlMMDG8oPHAh7VfGgexBx6I4Nz2U7mKubkwAn4WGbiZost56Kzj81fw4V4xpj0/qVaMPfQtj3bvE4hBOIWL1CvuHBhZhfRDRu2wQjf/z3iGIyC73ObWmb9yygzXNVhSmwl6SxJfsimgnjb/a0dZXyvl94ty+KbVXJ9BksqYYFBGSIQ77mwmd6GTnkmecFOjOi7i5FZe/xic71252aeYm9HORRWnp2tfbZ26lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cT1g4geeGEo/khIIs3d9GtMnIE5wFM7APl17ylG7a6E=;
 b=YtpFjgihQni0Iw2c+UYjmQAHPi8Aw+dEWVaGfupcf/vQZriN3V/f/fHWTTqaM972lb4JdDmV3Ohu4PkMSKfBSSVA17RLFmRzI8QCKnEzGKD385L6zskCezFrORUgO5NuRR/KuX2rDKUBH1gjzykYxBVPgm+RF5lzXAA8b6N1pj0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4218.namprd12.prod.outlook.com (2603:10b6:5:21b::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.35; Fri, 2 Oct 2020 17:07:38 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348%2]) with mapi id 15.20.3433.039; Fri, 2 Oct 2020
 17:07:38 +0000
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
Subject: [RFC PATCH v2 32/33] KVM: SVM: Provide an updated VMRUN invocation for SEV-ES guests
Date:   Fri,  2 Oct 2020 12:02:56 -0500
Message-Id: <1c1d390946c47b7c8c209c0d1412bb9bd6fad289.1601658176.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1601658176.git.thomas.lendacky@amd.com>
References: <cover.1601658176.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR20CA0008.namprd20.prod.outlook.com
 (2603:10b6:3:93::18) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR20CA0008.namprd20.prod.outlook.com (2603:10b6:3:93::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.34 via Frontend Transport; Fri, 2 Oct 2020 17:07:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 81fb1333-ff06-4066-840f-08d866f5aa4f
X-MS-TrafficTypeDiagnostic: DM6PR12MB4218:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4218348AFD5B0E102B1B809CEC310@DM6PR12MB4218.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S/eK1eqe9jRXlnxvsbBWe9HdOSL2TXxD4snISq7Zuk1TvG4ZsZZIiOfHKWZ/e1vfD31K2z7gTJztPJ3P7keGzgekmJdLahI4GexvKOthWnwEWpAGt13nVjUYrxDDtEofzcUNXGzr+TS+2YLL5xTNCYGGdoS7xF/Y1wSqdvfJxlHWCEYRJkdo9WtLP0Pinhp4TUcarBD7/FjVf48h3M/eQr3iUfqS5RSv5mGRYngirLbCU7yeOUQD4mz7biG2KmQj8zTda8zbODLQYmQTvJX2fPUrt8WSVcm6PoSOWNdbnfepOAUpYlsjBzalwfC6Vuytl67yABTKwmLos449XcjR6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(6666004)(8676002)(83380400001)(6486002)(2616005)(66556008)(956004)(66476007)(66946007)(52116002)(7696005)(4326008)(36756003)(5660300002)(8936002)(16526019)(186003)(2906002)(54906003)(316002)(26005)(7416002)(15650500001)(478600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: jNxvRE0Sx2zCbv7V2td0iRjLLhjeUVSADq9FJu4N4M48kValh8IxKDMTB0dLNaxjY13kiv3ZOFQTD/C16EVrj5b8S/k7+ZZif4LOJGq8+q04BZ2OcK/4u8aJQaBmW8hUohSPE9HlQtg2wa2fZ/6QibCunx+ekYo3EUddrqtw1Kj7qkkTMKNV5MiWt7yonj9sCOBLsw0MyUVhtCo8OQRrZkrG0+phDo4LY/3j0QcG35IhM/Aod5hDMT/OOKXm3ah4oEMqZauGTL0v3TE5uY6sGqwKDMfr0HmwA6sYVZBPkd9wxAL+nDFEQLOCma4hhsKld+L13jPZ65Ol+Qlf1vhhIrdjNAX2nPf5uOt2CvNgsctd4BDsWCjldxXXp5N46eut6D4nfafE+w2AqUa3/Ype/cAzhdnTzwm++ONdLFe1UmWy2L2rqVO6K3RjfZLUDByzWZfphz/cyto1Q+8DeIj3UBB0AFxOhuvKIzS0Mb6VVjxzazYlxLdqepVjY5sHQ0gZXIRgNP5poYm7i+CnnYYiu4xFl4ehlKrOWMTDAH1Dw123k/eYmaOUqemrALTGfDTxxBB+/Wu4GuRU7PDrphShqhYNDWbuBDf2UHomH/qV9vDGSMf5hmzWBqIqAMGL73ogR1QVIb1BMOnJgNtArsmexQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81fb1333-ff06-4066-840f-08d866f5aa4f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 17:07:38.5462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0wY/jffpq7lnCTqhVQZMGKvB+rb+bZOi+2wM5bO5PNVsUfXfuXbxmMLzbscUCLJmrCAlZzW9dU2Kl9QBGXpKmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4218
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
index 35d6f27ef288..90843131cc92 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3760,16 +3760,20 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu,
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
@@ -3864,14 +3868,17 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
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
index acbff817559b..a826e7de1663 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -584,4 +584,9 @@ void sev_es_create_vcpu(struct vcpu_svm *svm);
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
index 9decf963bb59..381dbd6a6038 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -881,6 +881,9 @@ EXPORT_SYMBOL_GPL(kvm_lmsw);
 
 void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
 {
+	if (vcpu->arch.guest_state_protected)
+		return;
+
 	if (kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE)) {
 
 		if (vcpu->arch.xcr0 != host_xcr0)
@@ -901,6 +904,9 @@ EXPORT_SYMBOL_GPL(kvm_load_guest_xsave_state);
 
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

