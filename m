Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5276A367E54
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 12:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235791AbhDVKGK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 06:06:10 -0400
Received: from mga04.intel.com ([192.55.52.120]:61845 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230365AbhDVKGJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 06:06:09 -0400
IronPort-SDR: VvMu5CbAufhnLyv3hxz1KQcjVo+xOpkeURYeOKsk+FlR7W+gPzMESTyMb7mWGgcrlAiMOH51LX
 AS7PG/uaByAA==
X-IronPort-AV: E=McAfee;i="6200,9189,9961"; a="193741597"
X-IronPort-AV: E=Sophos;i="5.82,242,1613462400"; 
   d="scan'208";a="193741597"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2021 03:05:35 -0700
IronPort-SDR: m7FSfCWbY7aAmdrEGFvu6YqLb0eIFs3MyrpXJ72YML7MhVeQ/6Q2Zq8MN7lPSjFqjCHU8ltPN9
 Af1w+eK5NzUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,242,1613462400"; 
   d="scan'208";a="421317148"
Received: from icx-2s.bj.intel.com ([10.240.192.119])
  by fmsmga008.fm.intel.com with ESMTP; 22 Apr 2021 03:05:34 -0700
From:   Yang Zhong <yang.zhong@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, yang.zhong@intel.com
Subject: [PATCH 2/2] KVM: SVM: Keep registers read/write consistent with definition
Date:   Thu, 22 Apr 2021 17:34:36 +0800
Message-Id: <20210422093436.78683-3-yang.zhong@intel.com>
X-Mailer: git-send-email 2.29.2.334.gfaefdd61ec
In-Reply-To: <20210422093436.78683-1-yang.zhong@intel.com>
References: <20210422093436.78683-1-yang.zhong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The kvm_cache_regs.h file has defined inline functions for those general
purpose registers and pointer register read/write operations, we need keep
those related registers operations consistent with header file definition
in the SVM side.

Signed-off-by: Yang Zhong <yang.zhong@intel.com>
---
 arch/x86/kvm/svm/nested.c |  2 +-
 arch/x86/kvm/svm/sev.c    | 65 ++++++++++++++++++++-------------------
 arch/x86/kvm/svm/svm.c    | 20 ++++++------
 3 files changed, 44 insertions(+), 43 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index fb204eaa8bb3..e16b96de1688 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -805,7 +805,7 @@ static int nested_svm_exit_handled_msr(struct vcpu_svm *svm)
 	if (!(vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_MSR_PROT)))
 		return NESTED_EXIT_HOST;
 
-	msr    = svm->vcpu.arch.regs[VCPU_REGS_RCX];
+	msr    = kvm_rcx_read(&svm->vcpu);
 	offset = svm_msrpm_offset(msr);
 	write  = svm->vmcb->control.exit_info_1 & 1;
 	mask   = 1 << ((2 * (msr & 0xf)) + write);
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 874ea309279f..adc111dc209f 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -524,25 +524,25 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 		return -EINVAL;
 
 	/* Sync registgers */
-	save->rax = svm->vcpu.arch.regs[VCPU_REGS_RAX];
-	save->rbx = svm->vcpu.arch.regs[VCPU_REGS_RBX];
-	save->rcx = svm->vcpu.arch.regs[VCPU_REGS_RCX];
-	save->rdx = svm->vcpu.arch.regs[VCPU_REGS_RDX];
-	save->rsp = svm->vcpu.arch.regs[VCPU_REGS_RSP];
-	save->rbp = svm->vcpu.arch.regs[VCPU_REGS_RBP];
-	save->rsi = svm->vcpu.arch.regs[VCPU_REGS_RSI];
-	save->rdi = svm->vcpu.arch.regs[VCPU_REGS_RDI];
+	save->rax = kvm_rax_read(&svm->vcpu);
+	save->rbx = kvm_rbx_read(&svm->vcpu);
+	save->rcx = kvm_rcx_read(&svm->vcpu);
+	save->rdx = kvm_rdx_read(&svm->vcpu);
+	save->rsp = kvm_rsp_read(&svm->vcpu);
+	save->rbp = kvm_rbp_read(&svm->vcpu);
+	save->rsi = kvm_rsi_read(&svm->vcpu);
+	save->rdi = kvm_rdi_read(&svm->vcpu);
 #ifdef CONFIG_X86_64
-	save->r8  = svm->vcpu.arch.regs[VCPU_REGS_R8];
-	save->r9  = svm->vcpu.arch.regs[VCPU_REGS_R9];
-	save->r10 = svm->vcpu.arch.regs[VCPU_REGS_R10];
-	save->r11 = svm->vcpu.arch.regs[VCPU_REGS_R11];
-	save->r12 = svm->vcpu.arch.regs[VCPU_REGS_R12];
-	save->r13 = svm->vcpu.arch.regs[VCPU_REGS_R13];
-	save->r14 = svm->vcpu.arch.regs[VCPU_REGS_R14];
-	save->r15 = svm->vcpu.arch.regs[VCPU_REGS_R15];
+	save->r8 = kvm_r8_read(&svm->vcpu);
+	save->r9 = kvm_r9_read(&svm->vcpu);
+	save->r10 = kvm_r10_read(&svm->vcpu);
+	save->r11 = kvm_r11_read(&svm->vcpu);
+	save->r12 = kvm_r12_read(&svm->vcpu);
+	save->r13 = kvm_r13_read(&svm->vcpu);
+	save->r14 = kvm_r14_read(&svm->vcpu);
+	save->r15 = kvm_r15_read(&svm->vcpu);
 #endif
-	save->rip = svm->vcpu.arch.regs[VCPU_REGS_RIP];
+	save->rip = kvm_rip_read(&svm->vcpu);
 
 	/* Sync some non-GPR registers before encrypting */
 	save->xcr0 = svm->vcpu.arch.xcr0;
@@ -1493,10 +1493,10 @@ static void sev_es_sync_to_ghcb(struct vcpu_svm *svm)
 	 * Copy their values, even if they may not have been written during the
 	 * VM-Exit.  It's the guest's responsibility to not consume random data.
 	 */
-	ghcb_set_rax(ghcb, vcpu->arch.regs[VCPU_REGS_RAX]);
-	ghcb_set_rbx(ghcb, vcpu->arch.regs[VCPU_REGS_RBX]);
-	ghcb_set_rcx(ghcb, vcpu->arch.regs[VCPU_REGS_RCX]);
-	ghcb_set_rdx(ghcb, vcpu->arch.regs[VCPU_REGS_RDX]);
+	ghcb_set_rax(ghcb, kvm_rax_read(vcpu));
+	ghcb_set_rbx(ghcb, kvm_rbx_read(vcpu));
+	ghcb_set_rcx(ghcb, kvm_rcx_read(vcpu));
+	ghcb_set_rdx(ghcb, kvm_rdx_read(vcpu));
 }
 
 static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
@@ -1520,11 +1520,11 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
 	 */
 	memset(vcpu->arch.regs, 0, sizeof(vcpu->arch.regs));
 
-	vcpu->arch.regs[VCPU_REGS_RAX] = ghcb_get_rax_if_valid(ghcb);
-	vcpu->arch.regs[VCPU_REGS_RBX] = ghcb_get_rbx_if_valid(ghcb);
-	vcpu->arch.regs[VCPU_REGS_RCX] = ghcb_get_rcx_if_valid(ghcb);
-	vcpu->arch.regs[VCPU_REGS_RDX] = ghcb_get_rdx_if_valid(ghcb);
-	vcpu->arch.regs[VCPU_REGS_RSI] = ghcb_get_rsi_if_valid(ghcb);
+	kvm_rax_write(vcpu, ghcb_get_rax_if_valid(ghcb));
+	kvm_rbx_write(vcpu, ghcb_get_rbx_if_valid(ghcb));
+	kvm_rcx_write(vcpu, ghcb_get_rcx_if_valid(ghcb));
+	kvm_rdx_write(vcpu, ghcb_get_rdx_if_valid(ghcb));
+	kvm_rsi_write(vcpu, ghcb_get_rsi_if_valid(ghcb));
 
 	svm->vmcb->save.cpl = ghcb_get_cpl_if_valid(ghcb);
 
@@ -1846,8 +1846,9 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 					     GHCB_MSR_CPUID_FUNC_POS);
 
 		/* Initialize the registers needed by the CPUID intercept */
-		vcpu->arch.regs[VCPU_REGS_RAX] = cpuid_fn;
-		vcpu->arch.regs[VCPU_REGS_RCX] = 0;
+		kvm_rax_write(vcpu, cpuid_fn);
+		kvm_rcx_write(vcpu, 0);
+
 
 		ret = svm_invoke_exit_handler(svm, SVM_EXIT_CPUID);
 		if (!ret) {
@@ -1859,13 +1860,13 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 					      GHCB_MSR_CPUID_REG_MASK,
 					      GHCB_MSR_CPUID_REG_POS);
 		if (cpuid_reg == 0)
-			cpuid_value = vcpu->arch.regs[VCPU_REGS_RAX];
+			cpuid_value = kvm_rax_read(vcpu);
 		else if (cpuid_reg == 1)
-			cpuid_value = vcpu->arch.regs[VCPU_REGS_RBX];
+			cpuid_value = kvm_rbx_read(vcpu);
 		else if (cpuid_reg == 2)
-			cpuid_value = vcpu->arch.regs[VCPU_REGS_RCX];
+			cpuid_value = kvm_rcx_read(vcpu);
 		else
-			cpuid_value = vcpu->arch.regs[VCPU_REGS_RDX];
+			cpuid_value = kvm_rdx_read(vcpu);
 
 		set_ghcb_msr_bits(svm, cpuid_value,
 				  GHCB_MSR_CPUID_VALUE_MASK,
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 58a45bb139f8..19f0fcb74c26 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1206,7 +1206,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 	save->dr6 = 0xffff0ff0;
 	kvm_set_rflags(&svm->vcpu, X86_EFLAGS_FIXED);
 	save->rip = 0x0000fff0;
-	svm->vcpu.arch.regs[VCPU_REGS_RIP] = save->rip;
+	kvm_rip_write(&svm->vcpu, save->rip);
 
 	/*
 	 * svm_set_cr0() sets PG and WP and clears NW and CD on save->cr0.
@@ -3825,9 +3825,9 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	trace_kvm_entry(vcpu);
 
-	svm->vmcb->save.rax = vcpu->arch.regs[VCPU_REGS_RAX];
-	svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];
-	svm->vmcb->save.rip = vcpu->arch.regs[VCPU_REGS_RIP];
+	svm->vmcb->save.rax = kvm_rax_read(vcpu);
+	svm->vmcb->save.rsp = kvm_rsp_read(vcpu);
+	svm->vmcb->save.rip = kvm_rip_read(vcpu);
 
 	/*
 	 * Disable singlestep if we're injecting an interrupt/exception.
@@ -3904,9 +3904,9 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	if (!sev_es_guest(svm->vcpu.kvm)) {
 		vcpu->arch.cr2 = svm->vmcb->save.cr2;
-		vcpu->arch.regs[VCPU_REGS_RAX] = svm->vmcb->save.rax;
-		vcpu->arch.regs[VCPU_REGS_RSP] = svm->vmcb->save.rsp;
-		vcpu->arch.regs[VCPU_REGS_RIP] = svm->vmcb->save.rip;
+		kvm_rax_write(vcpu, svm->vmcb->save.rax);
+		kvm_rsp_write(vcpu, svm->vmcb->save.rsp);
+		kvm_rip_write(vcpu, svm->vmcb->save.rip);
 	}
 
 	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
@@ -4320,9 +4320,9 @@ static int svm_pre_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
 		/* FEE0h - SVM Guest VMCB Physical Address */
 		put_smstate(u64, smstate, 0x7ee0, svm->nested.vmcb12_gpa);
 
-		svm->vmcb->save.rax = vcpu->arch.regs[VCPU_REGS_RAX];
-		svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];
-		svm->vmcb->save.rip = vcpu->arch.regs[VCPU_REGS_RIP];
+		svm->vmcb->save.rax = kvm_rax_read(vcpu);
+		svm->vmcb->save.rsp = kvm_rsp_read(vcpu);
+		svm->vmcb->save.rip = kvm_rip_read(vcpu);
 
 		ret = nested_svm_vmexit(svm);
 		if (ret)
-- 
2.29.2.334.gfaefdd61ec

