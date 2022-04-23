Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7A5350C672
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 04:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232014AbiDWCRk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 22:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232029AbiDWCR3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 22:17:29 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57EB822404D
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 19:14:32 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id k2-20020a170902ba8200b0015613b12004so5719947pls.22
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 19:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=wdag41y9OAVtS7teqp0JXkEIzXyC8dZApV/tVU+ozDA=;
        b=GB79v8TM62ZWtiJrKgnl7W1jl715WI0N878ZZ/dJDU6dmO3fB2jM6kqb74x5jYLV8a
         sy0B9lRDRzI2TVjy/irDRLApw/aX2i+RYq4uPlUxfuyPUp3xmN0fweaIRHGlHKEOkJOu
         04LpgZ8tQ4auviJH26kQLv5/l4Z0mMiHPFIipsDxamZ2KZtenzTcnF3WtXgypUqTyDzO
         lYl1HDUEOxGMgrwEUZR+KtEaQ/Qem30E6LIxvCO0MSPdwV5poDPDe4QwHbfOF18m7LGF
         poMzDybCLr5R/W2TzdjAhmQdeJX8ycowK2dROYn6M8eEHoHgRwbo7/rpSPx2nwziO7OV
         MPlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=wdag41y9OAVtS7teqp0JXkEIzXyC8dZApV/tVU+ozDA=;
        b=NiZ5TOdkZCfqDQF9SIxxWqA1oUsD6hf68Pf3LgqwqgyADph3S3FC6GpEksB33vmjW9
         8obqLG2EMDts4syw1oJvxplZAf/DRDjlnqYgMlsxcTUxxjCXCBNBCXa26QHtTe7xuHz4
         avEnNjzkB2RMVNlmIU4/erAugKUGYps0kzk2kGc3BXlLLc177cJMi546RKVirmcxupKk
         Zo0E2GNKojTVJtGWIId3BTfIjgt5HzFGpdXazQzN5KyvWoBz55mo/MmyzKZ5O8j6a4rD
         eibcrb5uquBI5j3+ojZZeTCM19cqaTElEPd5i4T65IQXeOmSU/mVIN/Q0GTqtPESju28
         IbVw==
X-Gm-Message-State: AOAM531RCKmMMJZQiyBxvzxnJZcBy7V9J1ZGvGYE9lucI4y/C1Z1cSQz
        ubx8DnAQcdOsNWzluCm2dcyfGZpknWo=
X-Google-Smtp-Source: ABdhPJwoAt5wYJQnjpSWq2Cdj4a85+ur/HPU9Dgo9kkad+up8vSwBKg2bsvtPB+V7n+62n885+y4lUtvyYY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:2384:b0:1cb:5223:9dc4 with SMTP id
 mr4-20020a17090b238400b001cb52239dc4mr693294pjb.1.1650680071424; Fri, 22 Apr
 2022 19:14:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Apr 2022 02:14:11 +0000
In-Reply-To: <20220423021411.784383-1-seanjc@google.com>
Message-Id: <20220423021411.784383-12-seanjc@google.com>
Mime-Version: 1.0
References: <20220423021411.784383-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v2 11/11] KVM: SVM: Drop support for CPUs without NRIPS
 (NextRIP Save) support
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

Drop support for CPUs without NRIPS along with the associated module
param.  Requiring NRIPS simplifies a handful of paths in KVM, especially
paths where KVM has to do silly things when nrips=false but supported in
hardware as there is no way to tell the CPU _not_ to use NRIPS.

NRIPS was introduced in 2009, i.e. every AMD-based CPU released in the
last decade should support NRIPS.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Not-signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c                     |  9 +--
 arch/x86/kvm/svm/svm.c                        | 77 +++++++------------
 .../kvm/x86_64/svm_nested_soft_inject_test.c  |  6 +-
 3 files changed, 32 insertions(+), 60 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index a83e367ade54..f39c958c77f5 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -681,14 +681,13 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	/*
 	 * next_rip is consumed on VMRUN as the return address pushed on the
 	 * stack for injected soft exceptions/interrupts.  If nrips is exposed
-	 * to L1, take it verbatim from vmcb12.  If nrips is supported in
-	 * hardware but not exposed to L1, stuff the actual L2 RIP to emulate
-	 * what a nrips=0 CPU would do (L1 is responsible for advancing RIP
-	 * prior to injecting the event).
+	 * to L1, take it verbatim from vmcb12.  If nrips is not exposed to L1,
+	 * stuff the actual L2 RIP to emulate what an nrips=0 CPU would do (L1
+	 * is responsible for advancing RIP prior to injecting the event).
 	 */
 	if (svm->nrips_enabled)
 		vmcb02->control.next_rip    = svm->nested.ctl.next_rip;
-	else if (boot_cpu_has(X86_FEATURE_NRIPS))
+	else
 		vmcb02->control.next_rip    = vmcb12_rip;
 
 	if (is_evtinj_soft(vmcb02->control.event_inj)) {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4a912623b961..6e6530c01e34 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -162,10 +162,6 @@ module_param_named(npt, npt_enabled, bool, 0444);
 static int nested = true;
 module_param(nested, int, S_IRUGO);
 
-/* enable/disable Next RIP Save */
-static int nrips = true;
-module_param(nrips, int, 0444);
-
 /* enable/disable Virtual VMLOAD VMSAVE */
 static int vls = true;
 module_param(vls, int, 0444);
@@ -355,10 +351,8 @@ static int __svm_skip_emulated_instruction(struct kvm_vcpu *vcpu,
 	if (sev_es_guest(vcpu->kvm))
 		goto done;
 
-	if (nrips && svm->vmcb->control.next_rip != 0) {
-		WARN_ON_ONCE(!static_cpu_has(X86_FEATURE_NRIPS));
+	if (svm->vmcb->control.next_rip != 0)
 		svm->next_rip = svm->vmcb->control.next_rip;
-	}
 
 	if (!svm->next_rip) {
 		if (unlikely(!commit_side_effects))
@@ -394,15 +388,14 @@ static int svm_update_soft_interrupt_rip(struct kvm_vcpu *vcpu)
 	 * Due to architectural shortcomings, the CPU doesn't always provide
 	 * NextRIP, e.g. if KVM intercepted an exception that occurred while
 	 * the CPU was vectoring an INTO/INT3 in the guest.  Temporarily skip
-	 * the instruction even if NextRIP is supported to acquire the next
-	 * RIP so that it can be shoved into the NextRIP field, otherwise
-	 * hardware will fail to advance guest RIP during event injection.
-	 * Drop the exception/interrupt if emulation fails and effectively
-	 * retry the instruction, it's the least awful option.  If NRIPS is
-	 * in use, the skip must not commit any side effects such as clearing
-	 * the interrupt shadow or RFLAGS.RF.
+	 * the instruction to acquire the next RIP so that it can be shoved
+	 * into the NextRIP field, otherwise hardware will fail to advance
+	 * guest RIP during event injection.  Drop the exception/interrupt if
+	 * emulation fails and effectively retry the instruction, it's the
+	 * least awful option.  The skip must not commit any side effects such
+	 * as clearing the interrupt shadow or RFLAGS.RF.
 	 */
-	if (!__svm_skip_emulated_instruction(vcpu, !nrips))
+	if (!__svm_skip_emulated_instruction(vcpu, false))
 		return -EIO;
 
 	rip = kvm_rip_read(vcpu);
@@ -421,11 +414,9 @@ static int svm_update_soft_interrupt_rip(struct kvm_vcpu *vcpu)
 	svm->soft_int_old_rip = old_rip;
 	svm->soft_int_next_rip = rip;
 
-	if (nrips)
-		kvm_rip_write(vcpu, old_rip);
+	kvm_rip_write(vcpu, old_rip);
 
-	if (static_cpu_has(X86_FEATURE_NRIPS))
-		svm->vmcb->control.next_rip = rip;
+	svm->vmcb->control.next_rip = rip;
 
 	return 0;
 }
@@ -3732,28 +3723,16 @@ static void svm_complete_soft_interrupt(struct kvm_vcpu *vcpu, u8 vector,
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	/*
-	 * If NRIPS is enabled, KVM must snapshot the pre-VMRUN next_rip that's
-	 * associated with the original soft exception/interrupt.  next_rip is
-	 * cleared on all exits that can occur while vectoring an event, so KVM
-	 * needs to manually set next_rip for re-injection.  Unlike the !nrips
-	 * case below, this needs to be done if and only if KVM is re-injecting
-	 * the same event, i.e. if the event is a soft exception/interrupt,
-	 * otherwise next_rip is unused on VMRUN.
+	 * KVM must snapshot the pre-VMRUN next_rip that's associated with the
+	 * original soft exception/interrupt.  next_rip is cleared on all exits
+	 * that can occur while vectoring an event, so KVM needs to manually
+	 * set next_rip for re-injection.  This needs to be done if and only if
+	 * KVM is re-injecting the same event, i.e. if the event is a soft
+	 * exception/interrupt, otherwise next_rip is unused on VMRUN.
 	 */
-	if (nrips && (is_soft || (is_exception && kvm_exception_is_soft(vector))) &&
+	if ((is_soft || (is_exception && kvm_exception_is_soft(vector))) &&
 	    kvm_is_linear_rip(vcpu, svm->soft_int_old_rip + svm->soft_int_csbase))
 		svm->vmcb->control.next_rip = svm->soft_int_next_rip;
-	/*
-	 * If NRIPS isn't enabled, KVM must manually advance RIP prior to
-	 * injecting the soft exception/interrupt.  That advancement needs to
-	 * be unwound if vectoring didn't complete.  Note, the new event may
-	 * not be the injected event, e.g. if KVM injected an INTn, the INTn
-	 * hit a #NP in the guest, and the #NP encountered a #PF, the #NP will
-	 * be the reported vectored event, but RIP still needs to be unwound.
-	 */
-	else if (!nrips && (is_soft || is_exception) &&
-		 kvm_is_linear_rip(vcpu, svm->soft_int_next_rip + svm->soft_int_csbase))
-		kvm_rip_write(vcpu, svm->soft_int_old_rip);
 }
 
 static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
@@ -4112,8 +4091,7 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 				    boot_cpu_has(X86_FEATURE_XSAVES);
 
 	/* Update nrips enabled cache */
-	svm->nrips_enabled = kvm_cpu_cap_has(X86_FEATURE_NRIPS) &&
-			     guest_cpuid_has(vcpu, X86_FEATURE_NRIPS);
+	svm->nrips_enabled = guest_cpuid_has(vcpu, X86_FEATURE_NRIPS);
 
 	svm->tsc_scaling_enabled = tsc_scaling && guest_cpuid_has(vcpu, X86_FEATURE_TSCRATEMSR);
 	svm->lbrv_enabled = lbrv && guest_cpuid_has(vcpu, X86_FEATURE_LBRV);
@@ -4324,9 +4302,7 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
 		break;
 	}
 
-	/* TODO: Advertise NRIPS to guest hypervisor unconditionally */
-	if (static_cpu_has(X86_FEATURE_NRIPS))
-		vmcb->control.next_rip  = info->next_rip;
+	vmcb->control.next_rip  = info->next_rip;
 	vmcb->control.exit_code = icpt_info.exit_code;
 	vmexit = nested_svm_exit_handled(svm);
 
@@ -4859,9 +4835,7 @@ static __init void svm_set_cpu_caps(void)
 	if (nested) {
 		kvm_cpu_cap_set(X86_FEATURE_SVM);
 		kvm_cpu_cap_set(X86_FEATURE_VMCBCLEAN);
-
-		if (nrips)
-			kvm_cpu_cap_set(X86_FEATURE_NRIPS);
+		kvm_cpu_cap_set(X86_FEATURE_NRIPS);
 
 		if (npt_enabled)
 			kvm_cpu_cap_set(X86_FEATURE_NPT);
@@ -4908,6 +4882,12 @@ static __init int svm_hardware_setup(void)
 	int r;
 	unsigned int order = get_order(IOPM_SIZE);
 
+	/* KVM no longer supports CPUs without NextRIP Save support. */
+	if (!boot_cpu_has(X86_FEATURE_NRIPS)) {
+		pr_err_ratelimited("NRIPS (NextRIP Save) not supported\n");
+		return -EOPNOTSUPP;
+	}
+
 	/*
 	 * NX is required for shadow paging and for NPT if the NX huge pages
 	 * mitigation is enabled.
@@ -4989,11 +4969,6 @@ static __init int svm_hardware_setup(void)
 			goto err;
 	}
 
-	if (nrips) {
-		if (!boot_cpu_has(X86_FEATURE_NRIPS))
-			nrips = false;
-	}
-
 	enable_apicv = avic = avic && npt_enabled && (boot_cpu_has(X86_FEATURE_AVIC) || force_avic);
 
 	if (enable_apicv) {
diff --git a/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c b/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
index 257aa2280b5c..39a6569715fd 100644
--- a/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
+++ b/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
@@ -106,10 +106,8 @@ int main(int argc, char *argv[])
 	nested_svm_check_supported();
 
 	cpuid = kvm_get_supported_cpuid_entry(0x8000000a);
-	if (!(cpuid->edx & X86_FEATURE_NRIPS)) {
-		print_skip("nRIP Save unavailable");
-		exit(KSFT_SKIP);
-	}
+	TEST_ASSERT(cpuid->edx & X86_FEATURE_NRIPS,
+		    "KVM is supposed to unconditionally advertise nRIP Save\n");
 
 	vm = vm_create_default(VCPU_ID, 0, (void *) l1_guest_code);
 
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

