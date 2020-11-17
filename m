Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 715CE2B6B69
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 18:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728807AbgKQRMf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 12:12:35 -0500
Received: from mail-dm6nam12on2059.outbound.protection.outlook.com ([40.107.243.59]:34273
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728533AbgKQRMd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 12:12:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RmxzFqJoCOZ5fvlnORuHb05+HwNGJs5iGgjWlwgYyZ/twUzYod20vAEPBPEHahQ5dtpywqsk3QGgDH92qoS2XVKJ2e1CQtTL/WLTeuirHr4v8zQ6YXcQghepjRzheZWXuQe1Wzf5kRZxUzPSKBT9/ZeAlaWmJjVTSDzjN4TG9bJ5LxHZh2wy4Ia6wvjLFIwx3DO+CuYcibM+BE4oVJXYtRcLkNDDOfUDOiTpPECbm4AbyAC8wDW08sKH3qOzhrQ5HUsNezL8uWhDhmrN71/GHZp2qezVcwALF8D7vfut34ww27a8i9zcFd2v39027w7TlKro98/bNLwgo1iIp7Vp5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ETNEw6agXMIQrVax5xUgVAxxPp8nNJmijgm9Gkm+3k=;
 b=GBjG8cmcR40ceFBLiHilaBQzlY9zSLrpCS9Y72i6AOnQJA5Eo+8Rf6rPpJ+kbeZVLABGbMfkauRw+9ReR/698PE1sSpYoTxNTtR5Som/pI6IUPxDKTqJYeXMhSZdXy0zutvK+lkX3LICzb+njp0wAl06c1JP/JMQQzE5pd3lYiUltucsW7OILfcyT9EqoerpZW0zoCBHTx02qlt6MwmhLedDUClOxc18mrrwDKEBf5Q97UwfK4SiUN1T21PidVwYivud4ZIMIro2cOH+ig3Pb2+/2p/1da4oJ//b2QQZqBHMYX449V0sMkDPDbQliOwqQ3g6bgASDBmUH60mYdqSIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ETNEw6agXMIQrVax5xUgVAxxPp8nNJmijgm9Gkm+3k=;
 b=xWR1kYzN+KXHxDKPKVRJucgbU1L8oNs8DuInVaaC8iYMU0lfb5rt2b5gf6RrGcd01X9fg/iuHqSoTV5gYJozwI53Hi0sbOjfWLt+0M4Hw1S1jHyk7fisRl6Le191nDU4/3gI0G9O1ot9rcdf+XBxqVjyCrPSYAtT7CgXuesW+qo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1772.namprd12.prod.outlook.com (2603:10b6:3:107::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.25; Tue, 17 Nov 2020 17:12:28 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe%12]) with mapi id 15.20.3564.028; Tue, 17 Nov
 2020 17:12:28 +0000
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
Subject: [PATCH v4 33/34] KVM: SVM: Provide an updated VMRUN invocation for SEV-ES guests
Date:   Tue, 17 Nov 2020 11:07:36 -0600
Message-Id: <227e126f0082c0abb16db0dd9ea7ba067e40332b.1605632857.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1605632857.git.thomas.lendacky@amd.com>
References: <cover.1605632857.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0121.namprd05.prod.outlook.com
 (2603:10b6:803:42::38) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN4PR0501CA0121.namprd05.prod.outlook.com (2603:10b6:803:42::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.15 via Frontend Transport; Tue, 17 Nov 2020 17:12:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f2a54583-92c4-46f4-d616-08d88b1bf5c5
X-MS-TrafficTypeDiagnostic: DM5PR12MB1772:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1772062C1424BBBDADAF735EECE20@DM5PR12MB1772.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xXofH6OwOv9QM7iYtyb8IKJ4HWHNMhRSu4NS41VDi+5wY40bDK1kCqN+vt1+xyIIu5a/ZHl5Rsf0flrK+BBkBuNFCV9xWMXeBY0HCnx2/z6tnzs5ujNTvle1QPg75XAufqH9COdTKT7EDOAJu9gGCzCWWEaYqbcEe6yneAOrUksP/D20ITvJpFxWd5whLLSq4cdB+Tuyx/z/UcbRpfirAbLh654jF+5tFNkxeQQmDJ7+yDTrn0z9oNhCQdN2niqBAUB2E+f2zZPuQd7M/2Nh5A2pw9Qu9tDiWrc7jVaObGbUnIuSBHWVK9MtNAy+viZ2xxnDP6UVyrE8tTgX2C3WdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(6486002)(66476007)(66946007)(8936002)(83380400001)(5660300002)(26005)(478600001)(66556008)(16526019)(6666004)(186003)(36756003)(86362001)(15650500001)(8676002)(316002)(956004)(52116002)(4326008)(54906003)(7696005)(7416002)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: lMdzy8BuvzBWFAbgPS/WV091QuzBmeMbEyGSI672VFjauTFygWiep/qRLfv9M8qKS96kR/VKIH5ufkUyuUYxpQgJ0c4eiwXEHWSgniIdS8pA0xDCKWSRHfHm+NRLns1ZQ0h84Ot1ehpm3siMq6TMWvtkZs97kuP5hgDgi6n2e+bG12vxtVxDgnIX1jsEMA9BUUjSqb0xbMrYyztBerPrp2ix1Y9ssobJdSlcnMMVg1loukrY5h3eDnsVT8uCn8dxBl0drzvq3tEXx+Shu2uu8PkNVG2NYpHvCLz9jpBnEy8sPz6itLNNcQj7n8eixyvQKCN26nvg8vlaeO8cdkixUX9J9LWoBy96iE7KjS+ET9aITIaMq/NEbCjfLCY8ITzadm5rIbNw/lM5frbDrML3Dl98AY6fkvHn6u+5Mt5KjGM25ZxNgqrNLW9LvBRQ4hwEpKKpxej/P35C+4mdTDMT2qacB1iNSXZmSaBhEJ+qCLuaechYrYFWyxc/VJoXfxXJ4ViuEVboqZ/Xt8iVPfKTQ/Y25PDtqYRjd+Z+WenM/HuAQS/TIauxbHg/8A63/yJCQPsyAEq4TcWKJhm7FvVCNmD5Zep0nniWgVZ1HpvnaHqO8ckdgVkJ5xcpzDQXoWKbaA/tUT1QGDhKR4dBnh660A==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2a54583-92c4-46f4-d616-08d88b1bf5c5
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 17:12:27.9645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w24y8YOB5GMx5sGHrRxQS7pOXjIEJ5AZWmzVAAgMgbEbn5OnMUhVcn1+HvLVHA765cV7cv+J5nKYG4OjvfuLxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1772
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
index b9c4d8b28423..c4b53e7386a0 100644
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
index 6e0599ae517f..8695e5bc78c0 100644
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

