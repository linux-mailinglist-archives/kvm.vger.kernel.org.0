Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8C3F723097
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 22:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236195AbjFEUB1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 16:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbjFEUBY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 16:01:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64B57F4;
        Mon,  5 Jun 2023 13:01:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E66E862A36;
        Mon,  5 Jun 2023 20:01:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD78AC4339B;
        Mon,  5 Jun 2023 20:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685995282;
        bh=Rop4hq74GRwWhsXb0QXS+k7/UPpghpcfqR8C8dfnc6Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I99t1p6D0VYx+REdn09N1xV+RxvI0o0rKvobOgl7DE2JomrnYcMoh24rgvFFv1bVs
         jElDBjnECkFCkjwTN6aHm+tsF5kBQxzMAAWZRTzBQHFVUIYrxrKsBfDUXcx99Jr2Yt
         eFH8+5Ih+TYVZCr9Ygs6vERKIm2nfha67Fyl5CYtBSLeAJXvSvaGGgVxxyfwUvALLY
         fztWaP2/3hTmkccbWqLT3qMG5f/ltCoqpwc88uiHEX6AgdBgcL9MO5iTWToWCxZlFw
         5tS7uc8s6XN7TEJiR36zlRfmdfsLudGF1p+lD1lQGgOX0/tBYy4oqORdGbMtRD+PJj
         7aMjBSE7V25xw==
Date:   Mon, 5 Jun 2023 13:01:19 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jon Kohler <jon@nutanix.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        "kvm @ vger . kernel . org" <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: VMX: remove LFENCE in vmx_spec_ctrl_restore_host()
Message-ID: <20230605200119.pepmnpvoej4tfdky@treble>
References: <F4BEBCAF-CBFC-4C3E-8B01-2ED84CF2E13A@nutanix.com>
 <20230601004202.63yulqs73kuh3ep6@treble>
 <846dd0c5-d431-e20e-fdb3-a4a26b6a22ca@citrix.com>
 <20230601012323.36te7hfv366danpf@desk>
 <20230601042345.52s5337uz62p6aow@treble>
 <21D1D290-7DE9-4864-A05B-A36779D9DC26@nutanix.com>
 <20230605163552.hi5kvh5wijegmus6@treble>
 <E704D6D6-3B03-40FA-8CDB-5FB58871BABC@nutanix.com>
 <20230605173101.iflfly3bt6ydvvyk@desk>
 <ZH4qBjLi0egsuC1D@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZH4qBjLi0egsuC1D@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 05, 2023 at 11:31:34AM -0700, Sean Christopherson wrote:
> Is there an actual bug here, or are we just micro-optimizing something that may or
> may not need additional optimization?  Unless there's a bug to be fixed, moving
> code into ASM and increasing complexity doesn't seem worthwhile.

I can't really argue with that.  FWIW, here's the (completely untested)
patch.

---8<---

From: Josh Poimboeuf <jpoimboe@kernel.org>
Subject: [PATCH] KVM: VMX: Convert vmx_spec_ctrl_restore_host() to assembly

Convert vmx_spec_ctrl_restore_host() to assembly.  This allows the
removal of a redundant LFENCE.  It also "feels" safer as it doesn't
allow the compiler to insert any surprises.  And it's more symmetrical
with the pre-vmentry SPEC_CTRL handling, which is also done in assembly.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/kvm/vmx/vmenter.S | 71 ++++++++++++++++++++++++++++++++------
 arch/x86/kvm/vmx/vmx.c     | 25 --------------
 arch/x86/kvm/vmx/vmx.h     |  1 -
 3 files changed, 61 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 631fd7da2bc3..977f3487469c 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -108,7 +108,7 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	lea (%_ASM_SP), %_ASM_ARG2
 	call vmx_update_host_rsp
 
-	ALTERNATIVE "jmp .Lspec_ctrl_done", "", X86_FEATURE_MSR_SPEC_CTRL
+	ALTERNATIVE "jmp .Lguest_spec_ctrl_done", "", X86_FEATURE_MSR_SPEC_CTRL
 
 	/*
 	 * SPEC_CTRL handling: if the guest's SPEC_CTRL value differs from the
@@ -122,13 +122,13 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	movl VMX_spec_ctrl(%_ASM_DI), %edi
 	movl PER_CPU_VAR(x86_spec_ctrl_current), %esi
 	cmp %edi, %esi
-	je .Lspec_ctrl_done
+	je .Lguest_spec_ctrl_done
 	mov $MSR_IA32_SPEC_CTRL, %ecx
 	xor %edx, %edx
 	mov %edi, %eax
 	wrmsr
 
-.Lspec_ctrl_done:
+.Lguest_spec_ctrl_done:
 
 	/*
 	 * Since vmentry is serializing on affected CPUs, there's no need for
@@ -253,9 +253,65 @@ SYM_INNER_LABEL(vmx_vmexit, SYM_L_GLOBAL)
 #endif
 
 	/*
-	 * IMPORTANT: RSB filling and SPEC_CTRL handling must be done before
-	 * the first unbalanced RET after vmexit!
+	 * IMPORTANT: The below SPEC_CTRL handling and RSB filling must be done
+	 * before the first RET after vmexit!
+	 */
+
+	ALTERNATIVE "jmp .Lhost_spec_ctrl_done", "", X86_FEATURE_MSR_SPEC_CTRL
+
+	pop %_ASM_SI	/* @flags */
+	pop %_ASM_DI	/* @vmx */
+
+	/*
+	 * if (flags & VMX_RUN_SAVE_SPEC_CTRL)
+	 *	vmx->spec_ctrl = __rdmsr(MSR_IA32_SPEC_CTRL);
+	 */
+	test $VMX_RUN_SAVE_SPEC_CTRL, %_ASM_SI
+	jz .Lhost_spec_ctrl_check
+
+	mov $MSR_IA32_SPEC_CTRL, %ecx
+	rdmsr
+	mov %eax, VMX_spec_ctrl(%_ASM_DI)
+
+.Lhost_spec_ctrl_check:
+	/*
+	 * If the guest/host SPEC_CTRL values differ, restore the host value.
 	 *
+	 * For legacy IBRS, the IBRS bit always needs to be written after
+	 * transitioning from a less privileged predictor mode, regardless of
+	 * whether the guest/host values differ.
+	 *
+	 * if (cpu_feature_enabled(X86_FEATURE_KERNEL_IBRS) ||
+	 *     vmx->spec_ctrl != this_cpu_read(x86_spec_ctrl_current))
+	 *	native_wrmsrl(MSR_IA32_SPEC_CTRL, hostval);
+	 */
+	ALTERNATIVE "", "jmp .Lhost_spec_ctrl_write", X86_FEATURE_KERNEL_IBRS
+	movl VMX_spec_ctrl(%_ASM_DI), %edi
+	movl PER_CPU_VAR(x86_spec_ctrl_current), %esi
+	cmp %edi, %esi
+	je .Lhost_spec_ctrl_done_lfence
+
+.Lhost_spec_ctrl_write:
+	mov $MSR_IA32_SPEC_CTRL, %ecx
+	xor %edx, %edx
+	mov %esi, %eax
+	wrmsr
+
+.Lhost_spec_ctrl_done_lfence:
+	/*
+	 * This ensures that speculative execution doesn't incorrectly bypass
+	 * the above SPEC_CTRL wrmsr by mispredicting the 'je'.
+	 *
+	 * It's only needed if the below FILL_RETURN_BUFFER doesn't do an
+	 * LFENCE.  Thus the X86_FEATURE_RSB_VMEXIT{_LITE} alternatives.
+	 */
+	ALTERNATIVE_2 "lfence", \
+		      "", X86_FEATURE_RSB_VMEXIT, \
+		      "", X86_FEATURE_RSB_VMEXIT_LITE
+
+.Lhost_spec_ctrl_done:
+
+	/*
 	 * For retpoline or IBRS, RSB filling is needed to prevent poisoned RSB
 	 * entries and (in some cases) RSB underflow.
 	 *
@@ -267,11 +323,6 @@ SYM_INNER_LABEL(vmx_vmexit, SYM_L_GLOBAL)
 	FILL_RETURN_BUFFER %_ASM_CX, RSB_CLEAR_LOOPS, X86_FEATURE_RSB_VMEXIT,\
 			   X86_FEATURE_RSB_VMEXIT_LITE
 
-	pop %_ASM_ARG2	/* @flags */
-	pop %_ASM_ARG1	/* @vmx */
-
-	call vmx_spec_ctrl_restore_host
-
 	/* Put return value in AX */
 	mov %_ASM_BX, %_ASM_AX
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 44fb619803b8..d353b0e23918 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7109,31 +7109,6 @@ void noinstr vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
 	}
 }
 
-void noinstr vmx_spec_ctrl_restore_host(struct vcpu_vmx *vmx,
-					unsigned int flags)
-{
-	u64 hostval = this_cpu_read(x86_spec_ctrl_current);
-
-	if (!cpu_feature_enabled(X86_FEATURE_MSR_SPEC_CTRL))
-		return;
-
-	if (flags & VMX_RUN_SAVE_SPEC_CTRL)
-		vmx->spec_ctrl = __rdmsr(MSR_IA32_SPEC_CTRL);
-
-	/*
-	 * If the guest/host SPEC_CTRL values differ, restore the host value.
-	 *
-	 * For legacy IBRS, the IBRS bit always needs to be written after
-	 * transitioning from a less privileged predictor mode, regardless of
-	 * whether the guest/host values differ.
-	 */
-	if (cpu_feature_enabled(X86_FEATURE_KERNEL_IBRS) ||
-	    vmx->spec_ctrl != hostval)
-		native_wrmsrl(MSR_IA32_SPEC_CTRL, hostval);
-
-	barrier_nospec();
-}
-
 static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 {
 	switch (to_vmx(vcpu)->exit_reason.basic) {
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 9e66531861cf..f9fab33f4d76 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -420,7 +420,6 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
 struct vmx_uret_msr *vmx_find_uret_msr(struct vcpu_vmx *vmx, u32 msr);
 void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu);
 void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
-void vmx_spec_ctrl_restore_host(struct vcpu_vmx *vmx, unsigned int flags);
 unsigned int __vmx_vcpu_run_flags(struct vcpu_vmx *vmx);
 bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs,
 		    unsigned int flags);
-- 
2.40.1

