Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 201FF26966B
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 22:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbgINUZE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 16:25:04 -0400
Received: from mail-dm6nam11on2069.outbound.protection.outlook.com ([40.107.223.69]:56449
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726009AbgINUWh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 16:22:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ea2KsbsG7G88uAV3yQnGCIm9ePSzGBVACV9WlLffvI02+mJJ4+Aof0bFzwgPM2anbwyV/63DooGC2QchAjbcPEMMYObNA2p7tjkjgvX4uNN+x7Vkfcg9XEHi2JY2V/bhrSD/UGXR6WjMzRO8eFzIVNMAj4GhFVk2ER4NzDEkXIzT9y6d7Nu3xPH7BdBT0X+rIEt00K6pniuind9O4nhB7UYgQpmalT2SDP9ZEoiaOLvq8ikelkr39tWwqTPFcIA6u2rgLp81sGfpA21KNzbAw2nJgxOE2xb4S0QwxamNS4iA+VGYdb4uswxEzG+9YUey/2OiCZEiU2MWTrITlvsR/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2loTHIadKXv4rgJr2xkrZTTID9rTWCYJhpqu92TmBzM=;
 b=a6BlBHZZKjdm5Gk+ZFDXGyYidzFU8m4neYSZ0GQmd9tlNPPjxCrgBthDSM15SpW2JYrxvhR6bwMxB8aSr/EIOfrRdjyEP1VJ1eSZE8W9VHwsWW6qdy87Pzi1jieQj8sPLxAwKoYHm1QuyXyAn7whAou9Ie25Ff42NoPwEPSWHfy03svut08V6TWrZjL/BgsmfOH+UFalFLSRtfW7o3qomtquEG2LXCfhhIbBzR6ymViJzdJ9/8ooT2dKep+smpii1CyX00kZixosv5ChLv5dz9raPEzixLJdGU28wqgnkUAfaqWcsbmD902GxGnq7AFMIyKE0gP0G5kzni/pDGYnyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2loTHIadKXv4rgJr2xkrZTTID9rTWCYJhpqu92TmBzM=;
 b=sY68hCGu+hkZZjB/iEZosvBi+N6CNkSPnNnLZnD6fYffmTbO3xLLJuYgBI0Qdx71ohvmRX7JZaO7/vMCKhMVJCAVIAPqrHzK6tWJNN6xvnDL7O6Pb2Qxdgd4AdbpigyeF6DOq19p59aOiJS4MAOpNuHndfd+KkBvGv3qtwho24c=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB2988.namprd12.prod.outlook.com (2603:10b6:5:3d::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Mon, 14 Sep 2020 20:20:32 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 20:20:32 +0000
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
Subject: [RFC PATCH 34/35] KVM: SVM: Provide an updated VMRUN invocation for SEV-ES guests
Date:   Mon, 14 Sep 2020 15:15:48 -0500
Message-Id: <b0835af5e16a54f7d36259f684f53f070201b253.1600114548.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1600114548.git.thomas.lendacky@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR04CA0071.namprd04.prod.outlook.com
 (2603:10b6:3:ef::33) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR04CA0071.namprd04.prod.outlook.com (2603:10b6:3:ef::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Mon, 14 Sep 2020 20:20:31 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c3269fe6-638c-4e4d-6263-08d858eba158
X-MS-TrafficTypeDiagnostic: DM6PR12MB2988:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB29886D872D97AAF1A72EE253EC230@DM6PR12MB2988.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tZN1fonH/GEaQntUqP5qPI6PZdnMZal26clPLjYnkOi3p3ZSjCtmXZL6uE15e66ZL8n8nq02g6uZiNe439K3xn2USz2YioPax3KwE57DhknC6MklbKPuCseUe7qi0kVh/Isg3WUzT0wBVj8n9P415dWpSrqAelX3uww4IlGJ6l/uSfWEr2ZKZWCZrnpHJ61AwHz2A3FjMTdpM4NzSUHnutUAzG6/Xq8xoT+VrTs5eBxgsshHm+ByHb2gbrXPvo040IE09CV2PJlCOzMJAxwuN96T9+PX3UsbUGcX5/Z0j1kJI5clHXghUmgYcOcRdF9J
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(396003)(136003)(366004)(8936002)(36756003)(316002)(478600001)(5660300002)(2616005)(956004)(66556008)(66946007)(186003)(4326008)(26005)(54906003)(2906002)(16526019)(66476007)(6666004)(8676002)(83380400001)(86362001)(52116002)(7696005)(7416002)(15650500001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: sHyYQxtXk26BDUa7Cfc/plXv8KUQIQjBU8gUZt20nXwD39rQjav3BlaPF63UHYsB3BgqvoKuMb6pVacDoT5KjqJlrei9Z489YWFznTwB2u2uzJFRSCJ8gxlmsJUUc1o7VlAOdXxPScPsKs/qMZiSYDWdn3CLxx8Ediho06njcrtH0lXn38y3oyf5/2ajgHPNMa1aXwby/5UEzRrbjk6nMv+9/9Qt1kjBVqLYA4XII4fjJJPFakuR3IBuSidhBL9EQU6t+3nmOWfmILW4f+6XWQpNdo+9MfpgZyHy/gvnYgAz1/ql3kp0G39IIjQ5r0v9FK/TFoOHaX5EFKesujdDrq0pxJ3eQVfd8x6+o9g0Z5n1nYHJZtWB3DNbnJH+N0dLMJJoE12VQl8/6c+azRHxn2Va77LZOkX+Ytd3++OHoCugiKTSkhooc11qsm2Nly3FQLREyGm4uBds1xkpDwtzuozUyKVeC5t36zQU5F68wbG+Mo6/OFtwSKiOEs35U/+dqaBkpvUTlqRFfLAlkuYJ9jyEBQ3TOpo/Un9veK2e32s+ssOKWzbLJcuLgLQJSZmfqJzQUNy/gwRybMDqHapklRRSpWHyEop3FwupxILgzmSleWP3+tMBjprIBUWD499zB0TqoKBFqLqWbbwgsS5Wjw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3269fe6-638c-4e4d-6263-08d858eba158
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 20:20:32.2237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6bxPEzT2lYWnrUNmQ53jP98/Z1m6vx7LPksiC8I03XIoKcXhkexzdpWSI5bQ4FdcKDsjLUhQO1l7J8N6Hbp3Xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2988
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

The guest vCPU register state of an SEV-ES guest will be restored on VMRUN
and save saved on VMEXIT. Therefore, there is no need to restore the guest
registers directly and through VMLOAD before VMRUN and no need to save the
guest registers directly and through VMSAVE on VMEXIT.

Update the svm_vcpu_run() function to skip register state saving and
restoring and provide an alternative function for running an SEV-ES guest
in vmenter.S

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/svm.c     | 36 +++++++++++++++++----------
 arch/x86/kvm/svm/svm.h     |  5 ++++
 arch/x86/kvm/svm/vmenter.S | 50 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 78 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index efefe8ba9759..5e5f67dd293a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3640,16 +3640,20 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu,
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
@@ -3676,9 +3680,11 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	fastpath_t exit_fastpath;
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	svm_rax_write(svm, vcpu->arch.regs[VCPU_REGS_RAX]);
-	svm_rsp_write(svm, vcpu->arch.regs[VCPU_REGS_RSP]);
-	svm_rip_write(svm, vcpu->arch.regs[VCPU_REGS_RIP]);
+	if (!sev_es_guest(svm->vcpu.kvm)) {
+		svm_rax_write(svm, vcpu->arch.regs[VCPU_REGS_RAX]);
+		svm_rsp_write(svm, vcpu->arch.regs[VCPU_REGS_RSP]);
+		svm_rip_write(svm, vcpu->arch.regs[VCPU_REGS_RIP]);
+	}
 
 	/*
 	 * Disable singlestep if we're injecting an interrupt/exception.
@@ -3700,7 +3706,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	sync_lapic_to_cr8(vcpu);
 
-	svm_cr2_write(svm, vcpu->arch.cr2);
+	if (!sev_es_guest(svm->vcpu.kvm))
+		svm_cr2_write(svm, vcpu->arch.cr2);
 
 	/*
 	 * Run with all-zero DR6 unless needed, so that we can get the exact cause
@@ -3748,14 +3755,17 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	if (unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))
 		svm->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);
 
-	reload_tss(vcpu);
+	if (!sev_es_guest(svm->vcpu.kvm))
+		reload_tss(vcpu);
 
 	x86_spec_ctrl_restore_host(svm->spec_ctrl, svm->virt_spec_ctrl);
 
-	vcpu->arch.cr2 = svm_cr2_read(svm);
-	vcpu->arch.regs[VCPU_REGS_RAX] = svm_rax_read(svm);
-	vcpu->arch.regs[VCPU_REGS_RSP] = svm_rsp_read(svm);
-	vcpu->arch.regs[VCPU_REGS_RIP] = svm_rip_read(svm);
+	if (!sev_es_guest(svm->vcpu.kvm)) {
+		vcpu->arch.cr2 = svm_cr2_read(svm);
+		vcpu->arch.regs[VCPU_REGS_RAX] = svm_rax_read(svm);
+		vcpu->arch.regs[VCPU_REGS_RSP] = svm_rsp_read(svm);
+		vcpu->arch.regs[VCPU_REGS_RIP] = svm_rip_read(svm);
+	}
 
 	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
 		kvm_before_interrupt(&svm->vcpu);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 0812d70085d7..1405ea3549b8 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -584,6 +584,11 @@ void sev_es_create_vcpu(struct vcpu_svm *svm);
 void sev_es_vcpu_load(struct vcpu_svm *svm, int cpu);
 void sev_es_vcpu_put(struct vcpu_svm *svm);
 
+/* vmenter.S */
+
+void __svm_sev_es_vcpu_run(unsigned long vmcb_pa);
+void __svm_vcpu_run(unsigned long vmcb_pa, unsigned long *regs);
+
 /* VMSA Accessor functions */
 
 static inline struct vmcb_save_area *get_vmsa(struct vcpu_svm *svm)
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
-- 
2.28.0

