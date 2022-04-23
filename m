Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B73550C669
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 04:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbiDWCRZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 22:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231858AbiDWCRR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 22:17:17 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D268621BAC2
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 19:14:21 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id j17-20020a62b611000000b004fa6338bd77so6448910pff.10
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 19:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ba8LIU8FH+mXjQjFWa7QXl2T6SrpEezShnOHFtbNAJA=;
        b=YKen6L2/XEhVKCOOOx5vhV0fOWiOqk0CDUX52xswEpx649D60RMpaAhHVUYl0kw7z+
         E9+jCiEaOKAaB4emBXyvmDwk+Hy0kk2RF1Rjflk+m8MtoXFz/Qov4muZlOiaG/rZZWK0
         d9DByEAq4C0xJgBVT7bZWOEfNz/ToHrj2PsS6GmfUJmQod4vOJPIEnsRgEIASlING3kU
         i41G0I1tsZP1mIaCStwASMdYG4HPZBvIJCWxod85jhyXGv2r4fV1LhokowXx4VVoHNhd
         qKmCWIRRRvWv9WApLbZ3iM3EneCAktASjjNLKffOe7boeO7TCWOQ0WQ8xlO9+8K+eEa+
         jgfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ba8LIU8FH+mXjQjFWa7QXl2T6SrpEezShnOHFtbNAJA=;
        b=oaI6N4eH03ZbmwPRwsbzGkJOwtOSmAs14pmsZDbzMhD98gI1ZSBphk+e7Uam5G0ydT
         U9QXdDCp2Alr/WOY6wEeC1oAr/bClRx867VVMd3I+H9CB48dautbTd5StwgvOCo5e5fg
         X1xuJtIhJ9VRPW0fGdGzUu2L7ucY3m/9snFi9N7sDOf5jyeQAunYXjeW3m0usd1mErfJ
         MnRofgGaQWsuDGadRoGifaf1Y/HzpnOzj5HqmjPC94L+yzWc99bEofSyhkPTfl28Nq4b
         AJvjHcsl/eTzdABGCOB+gGoh/SO6LLnykbRnlPM6aCrkCgejD4dv6s2Rgg8ozfCxVXLH
         kOew==
X-Gm-Message-State: AOAM531wV/Ek1LxqZRJ09wcJJPkvisloU8C/b68vlsVioFefYGb5+5ZA
        FFbiHnoX2HjirO7MzAvtbMPdUJbah0A=
X-Google-Smtp-Source: ABdhPJzA/oVWsF1ZEyGrfuBSthWLekPBZle3O5WeFlKvV6N7TOCOTc7p6BaFAWIeVnhPUhf6yFVPX6cw3r4=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a62:170b:0:b0:50a:6901:b633 with SMTP id
 11-20020a62170b000000b0050a6901b633mr8022175pfx.34.1650680061359; Fri, 22 Apr
 2022 19:14:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Apr 2022 02:14:05 +0000
In-Reply-To: <20220423021411.784383-1-seanjc@google.com>
Message-Id: <20220423021411.784383-6-seanjc@google.com>
Mime-Version: 1.0
References: <20220423021411.784383-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v2 05/11] KVM: SVM: Re-inject INT3/INTO instead of retrying
 the instruction
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Re-inject INT3/INTO instead of retrying the instruction if the CPU
encountered an intercepted exception while vectoring the software
exception, e.g. if vectoring INT3 encounters a #PF and KVM is using
shadow paging.  Retrying the instruction is architecturally wrong, e.g.
will result in a spurious #DB if there's a code breakpoint on the INT3/O,
and lack of re-injection also breaks nested virtualization, e.g. if L1
injects a software exception and vectoring the injected exception
encounters an exception that is intercepted by L0 but not L1.

Due to, ahem, deficiencies in the SVM architecture, acquiring the next
RIP may require flowing through the emulator even if NRIPS is supported,
as the CPU clears next_rip if the VM-Exit is due to an exception other
than "exceptions caused by the INT3, INTO, and BOUND instructions".  To
deal with this, "skip" the instruction to calculate next_rip (if it's
not already known), and then unwind the RIP write and any side effects
(RFLAGS updates).

Save the computed next_rip and use it to re-stuff next_rip if injection
doesn't complete.  This allows KVM to do the right thing if next_rip was
known prior to injection, e.g. if L1 injects a soft event into L2, and
there is no backing INTn instruction, e.g. if L1 is injecting an
arbitrary event.

Note, it's impossible to guarantee architectural correctness given SVM's
architectural flaws.  E.g. if the guest executes INTn (no KVM injection),
an exit occurs while vectoring the INTn, and the guest modifies the code
stream while the exit is being handled, KVM will compute the incorrect
next_rip due to "skipping" the wrong instruction.  A future enhancement
to make this less awful would be for KVM to detect that the decoded
instruction is not the correct INTn and drop the to-be-injected soft
event (retrying is a lesser evil compared to shoving the wrong RIP on the
exception stack).

Reported-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c |  28 +++++++-
 arch/x86/kvm/svm/svm.c    | 140 +++++++++++++++++++++++++++-----------
 arch/x86/kvm/svm/svm.h    |   6 +-
 3 files changed, 130 insertions(+), 44 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 461c5f247801..0163238aa198 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -609,6 +609,21 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 	}
 }
 
+static inline bool is_evtinj_soft(u32 evtinj)
+{
+	u32 type = evtinj & SVM_EVTINJ_TYPE_MASK;
+	u8 vector = evtinj & SVM_EVTINJ_VEC_MASK;
+
+	if (!(evtinj & SVM_EVTINJ_VALID))
+		return false;
+
+	/*
+	 * Intentionally return false for SOFT events, SVM doesn't yet support
+	 * re-injecting soft interrupts.
+	 */
+	return type == SVM_EVTINJ_TYPE_EXEPT && kvm_exception_is_soft(vector);
+}
+
 static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 					  unsigned long vmcb12_rip)
 {
@@ -677,6 +692,16 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	else if (boot_cpu_has(X86_FEATURE_NRIPS))
 		vmcb02->control.next_rip    = vmcb12_rip;
 
+	if (is_evtinj_soft(vmcb02->control.event_inj)) {
+		svm->soft_int_injected = true;
+		svm->soft_int_csbase = svm->vmcb->save.cs.base;
+		svm->soft_int_old_rip = vmcb12_rip;
+		if (svm->nrips_enabled)
+			svm->soft_int_next_rip = svm->nested.ctl.next_rip;
+		else
+			svm->soft_int_next_rip = vmcb12_rip;
+	}
+
 	vmcb02->control.virt_ext            = vmcb01->control.virt_ext &
 					      LBR_CTL_ENABLE_MASK;
 	if (svm->lbrv_enabled)
@@ -849,6 +874,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 
 out_exit_err:
 	svm->nested.nested_run_pending = 0;
+	svm->soft_int_injected = false;
 
 	svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
 	svm->vmcb->control.exit_code_hi = 0;
@@ -1618,7 +1644,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	nested_copy_vmcb_control_to_cache(svm, ctl);
 
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
-	nested_vmcb02_prepare_control(svm, save->rip);
+	nested_vmcb02_prepare_control(svm, svm->vmcb->save.rip);
 
 	/*
 	 * While the nested guest CR3 is already checked and set by
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 14bc4e87437b..8321f9ce5e35 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -342,9 +342,11 @@ static void svm_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
 
 }
 
-static int svm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
+static int __svm_skip_emulated_instruction(struct kvm_vcpu *vcpu,
+					   bool commit_side_effects)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	unsigned long old_rflags;
 
 	/*
 	 * SEV-ES does not expose the next RIP. The RIP update is controlled by
@@ -359,18 +361,75 @@ static int svm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	}
 
 	if (!svm->next_rip) {
+		if (unlikely(!commit_side_effects))
+			old_rflags = svm->vmcb->save.rflags;
+
 		if (!kvm_emulate_instruction(vcpu, EMULTYPE_SKIP))
 			return 0;
+
+		if (unlikely(!commit_side_effects))
+			svm->vmcb->save.rflags = old_rflags;
 	} else {
 		kvm_rip_write(vcpu, svm->next_rip);
 	}
 
 done:
-	svm_set_interrupt_shadow(vcpu, 0);
+	if (likely(commit_side_effects))
+		svm_set_interrupt_shadow(vcpu, 0);
 
 	return 1;
 }
 
+static int svm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
+{
+	return __svm_skip_emulated_instruction(vcpu, true);
+}
+
+static int svm_update_soft_interrupt_rip(struct kvm_vcpu *vcpu)
+{
+	unsigned long rip, old_rip = kvm_rip_read(vcpu);
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	/*
+	 * Due to architectural shortcomings, the CPU doesn't always provide
+	 * NextRIP, e.g. if KVM intercepted an exception that occurred while
+	 * the CPU was vectoring an INTO/INT3 in the guest.  Temporarily skip
+	 * the instruction even if NextRIP is supported to acquire the next
+	 * RIP so that it can be shoved into the NextRIP field, otherwise
+	 * hardware will fail to advance guest RIP during event injection.
+	 * Drop the exception/interrupt if emulation fails and effectively
+	 * retry the instruction, it's the least awful option.  If NRIPS is
+	 * in use, the skip must not commit any side effects such as clearing
+	 * the interrupt shadow or RFLAGS.RF.
+	 */
+	if (!__svm_skip_emulated_instruction(vcpu, !nrips))
+		return -EIO;
+
+	rip = kvm_rip_read(vcpu);
+
+	/*
+	 * Save the injection information, even when using next_rip, as the
+	 * VMCB's next_rip will be lost (cleared on VM-Exit) if the injection
+	 * doesn't complete due to a VM-Exit occurring while the CPU is
+	 * vectoring the event.   Decoding the instruction isn't guaranteed to
+	 * work as there may be no backing instruction, e.g. if the event is
+	 * being injected by L1 for L2, or if the guest is patching INT3 into
+	 * a different instruction.
+	 */
+	svm->soft_int_injected = true;
+	svm->soft_int_csbase = svm->vmcb->save.cs.base;
+	svm->soft_int_old_rip = old_rip;
+	svm->soft_int_next_rip = rip;
+
+	if (nrips)
+		kvm_rip_write(vcpu, old_rip);
+
+	if (static_cpu_has(X86_FEATURE_NRIPS))
+		svm->vmcb->control.next_rip = rip;
+
+	return 0;
+}
+
 static void svm_queue_exception(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -380,25 +439,9 @@ static void svm_queue_exception(struct kvm_vcpu *vcpu)
 
 	kvm_deliver_exception_payload(vcpu);
 
-	if (nr == BP_VECTOR && !nrips) {
-		unsigned long rip, old_rip = kvm_rip_read(vcpu);
-
-		/*
-		 * For guest debugging where we have to reinject #BP if some
-		 * INT3 is guest-owned:
-		 * Emulate nRIP by moving RIP forward. Will fail if injection
-		 * raises a fault that is not intercepted. Still better than
-		 * failing in all cases.
-		 */
-		(void)svm_skip_emulated_instruction(vcpu);
-		rip = kvm_rip_read(vcpu);
-
-		if (boot_cpu_has(X86_FEATURE_NRIPS))
-			svm->vmcb->control.next_rip = rip;
-
-		svm->int3_rip = rip + svm->vmcb->save.cs.base;
-		svm->int3_injected = rip - old_rip;
-	}
+	if (kvm_exception_is_soft(nr) &&
+	    svm_update_soft_interrupt_rip(vcpu))
+		return;
 
 	svm->vmcb->control.event_inj = nr
 		| SVM_EVTINJ_VALID
@@ -3671,15 +3714,46 @@ static inline void sync_lapic_to_cr8(struct kvm_vcpu *vcpu)
 	svm->vmcb->control.int_ctl |= cr8 & V_TPR_MASK;
 }
 
+static void svm_complete_soft_interrupt(struct kvm_vcpu *vcpu, u8 vector,
+					int type)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	/*
+	 * If NRIPS is enabled, KVM must snapshot the pre-VMRUN next_rip that's
+	 * associated with the original soft exception/interrupt.  next_rip is
+	 * cleared on all exits that can occur while vectoring an event, so KVM
+	 * needs to manually set next_rip for re-injection.  Unlike the !nrips
+	 * case below, this needs to be done if and only if KVM is re-injecting
+	 * the same event, i.e. if the event is a soft exception/interrupt,
+	 * otherwise next_rip is unused on VMRUN.
+	 */
+	if (nrips && type == SVM_EXITINTINFO_TYPE_EXEPT &&
+	    kvm_exception_is_soft(vector) &&
+	    kvm_is_linear_rip(vcpu, svm->soft_int_old_rip + svm->soft_int_csbase))
+		svm->vmcb->control.next_rip = svm->soft_int_next_rip;
+	/*
+	 * If NRIPS isn't enabled, KVM must manually advance RIP prior to
+	 * injecting the soft exception/interrupt.  That advancement needs to
+	 * be unwound if vectoring didn't complete.  Note, the new event may
+	 * not be the injected event, e.g. if KVM injected an INTn, the INTn
+	 * hit a #NP in the guest, and the #NP encountered a #PF, the #NP will
+	 * be the reported vectored event, but RIP still needs to be unwound.
+	 */
+	else if (!nrips && type == SVM_EXITINTINFO_TYPE_EXEPT &&
+		 kvm_is_linear_rip(vcpu, svm->soft_int_next_rip + svm->soft_int_csbase))
+		kvm_rip_write(vcpu, svm->soft_int_old_rip);
+}
+
 static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u8 vector;
 	int type;
 	u32 exitintinfo = svm->vmcb->control.exit_int_info;
-	unsigned int3_injected = svm->int3_injected;
+	bool soft_int_injected = svm->soft_int_injected;
 
-	svm->int3_injected = 0;
+	svm->soft_int_injected = false;
 
 	/*
 	 * If we've made progress since setting HF_IRET_MASK, we've
@@ -3704,17 +3778,8 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
 	vector = exitintinfo & SVM_EXITINTINFO_VEC_MASK;
 	type = exitintinfo & SVM_EXITINTINFO_TYPE_MASK;
 
-	/*
-	 * If NextRIP isn't enabled, KVM must manually advance RIP prior to
-	 * injecting the soft exception/interrupt.  That advancement needs to
-	 * be unwound if vectoring didn't complete.  Note, the new event may
-	 * not be the injected event, e.g. if KVM injected an INTn, the INTn
-	 * hit a #NP in the guest, and the #NP encountered a #PF, the #NP will
-	 * be the reported vectored event, but RIP still needs to be unwound.
-	 */
-	if (int3_injected && type == SVM_EXITINTINFO_TYPE_EXEPT &&
-	   kvm_is_linear_rip(vcpu, svm->int3_rip))
-		kvm_rip_write(vcpu, kvm_rip_read(vcpu) - int3_injected);
+	if (soft_int_injected)
+		svm_complete_soft_interrupt(vcpu, vector, type);
 
 	switch (type) {
 	case SVM_EXITINTINFO_TYPE_NMI:
@@ -3727,13 +3792,6 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
 		if (vector == X86_TRAP_VC)
 			break;
 
-		/*
-		 * In case of software exceptions, do not reinject the vector,
-		 * but re-execute the instruction instead.
-		 */
-		if (kvm_exception_is_soft(vector))
-			break;
-
 		if (exitintinfo & SVM_EXITINTINFO_VALID_ERR) {
 			u32 err = svm->vmcb->control.exit_int_info_err;
 			kvm_requeue_exception_e(vcpu, vector, err);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 7d97e4d18c8b..6acb494e3598 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -230,8 +230,10 @@ struct vcpu_svm {
 	bool nmi_singlestep;
 	u64 nmi_singlestep_guest_rflags;
 
-	unsigned int3_injected;
-	unsigned long int3_rip;
+	unsigned long soft_int_csbase;
+	unsigned long soft_int_old_rip;
+	unsigned long soft_int_next_rip;
+	bool soft_int_injected;
 
 	/* optional nested SVM features that are enabled for this guest  */
 	bool nrips_enabled                : 1;
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

