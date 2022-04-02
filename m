Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2914EFDA8
	for <lists+kvm@lfdr.de>; Sat,  2 Apr 2022 03:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353633AbiDBBLL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 21:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353616AbiDBBLF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 21:11:05 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36EE38FE73
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 18:09:14 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id j17-20020a62b611000000b004fa6338bd77so2432946pff.10
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 18:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Ol8exfApW6qp8ksY+lqUpF5z/oy5z9y8ZI2QOtFIzaY=;
        b=Mg+HcPSPAzhKgemV6VtSyQw1b+lZxkXiayU8hXXSVt6JO3BCHvxXvdSbAbQOTL7+Yp
         sxvAAyE2cJZIMrQwjYrdwNgEdaYb8oq0BOIfdnWcJ2r0R0lUZCQ0h1egoCn5Lqp8UHLj
         LdBk8g+GujiQY7A4CyhaTKH5gfXr2rXfIVZOpvRuooZYAX/tYWTMesQNuu4QIQIpakaj
         J77gqdAv3XNBVxnt9fwS8wkpo9hVd/eBSeaQmaNCzEHbMKC1zvGEKLyQOBbIJHOCyTvx
         Hs5SIDIKRbhwak/of+DWADUUjZTyKVz+w/bWKJN6FuLavdX//9ckRo5XlZoT8H/HEFKm
         9z3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Ol8exfApW6qp8ksY+lqUpF5z/oy5z9y8ZI2QOtFIzaY=;
        b=ZVH3gm/ylfxmk0SrlGURGtyKD6DXkAc1msSC0GsLPlkQ48/KrnxtLD63aHrPAIOKEC
         oe8N9KW6AOvLvpJ/oNrJpNHdwMVc6SUBHZrP0flsreGa0E1HAPHnUilj++lBAPMmjy9C
         IbzXsk7X2heb4/ujE8BX/AIUSjw0NLE6wq9nsO6sHKxKKe8wP7A26UcPUw7JEMFJSmN8
         Eazx6d7buXU9u2mwuuD1THYyJofSHO09PyjAIr4MqF+KKj9w58Zf6SIdf83o+2Uz7CBD
         0uDENhiECPpLa2z6a6DhIdijm1b4owbxHjk7KAXt2KsvSoqq8cB0th3rxNOAdfC0dWwb
         lVEw==
X-Gm-Message-State: AOAM531awHHkR0JFZSwdU49IKzMXctEaLYBt5ACxvfIrMYhkPmJC+ENc
        cLE4KGZaM4nhfhcdgWywPDkLkilWm5g=
X-Google-Smtp-Source: ABdhPJwh/+tkHKjROpI8f4YVjL3HYSEb25RxtMSK2Di63Mhnl5I5MjZhGP/4LburLgNSPXEAy1Gz5q6Y8DM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:2246:b0:1c6:5781:7193 with SMTP id
 hk6-20020a17090b224600b001c657817193mr14995812pjb.48.1648861753762; Fri, 01
 Apr 2022 18:09:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  2 Apr 2022 01:09:00 +0000
In-Reply-To: <20220402010903.727604-1-seanjc@google.com>
Message-Id: <20220402010903.727604-6-seanjc@google.com>
Mime-Version: 1.0
References: <20220402010903.727604-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH 5/8] KVM: SVM: Re-inject INT3/INTO instead of retrying the instruction
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
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
deal with this, "skip" the instruction to calculate next_ript, and then
unwind the RIP write and any side effects (RFLAGS updates).

Reported-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 111 ++++++++++++++++++++++++++++-------------
 arch/x86/kvm/svm/svm.h |   4 +-
 2 files changed, 79 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 6ea8f16e39ac..ecc828d6921e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -341,9 +341,11 @@ static void svm_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
 
 }
 
-static int svm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
+static int __svm_skip_emulated_instruction(struct kvm_vcpu *vcpu,
+					   bool commit_side_effects)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	unsigned long old_rflags;
 
 	/*
 	 * SEV-ES does not expose the next RIP. The RIP update is controlled by
@@ -358,18 +360,71 @@ static int svm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
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
+	 * If NextRIP is supported, rewind RIP and update NextRip.  If NextRip
+	 * isn't supported, keep the result of the skip as the CPU obviously
+	 * won't advance RIP, but stash away the injection information so that
+	 * RIP can be unwound if injection fails.
+	 */
+	if (nrips) {
+		kvm_rip_write(vcpu, old_rip);
+		svm->vmcb->control.next_rip = rip;
+	} else {
+		if (boot_cpu_has(X86_FEATURE_NRIPS))
+			svm->vmcb->control.next_rip = rip;
+
+		svm->soft_int_linear_rip = rip + svm->vmcb->save.cs.base;
+		svm->soft_int_injected = rip - old_rip;
+	}
+	return 0;
+}
+
 static void svm_queue_exception(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -379,25 +434,9 @@ static void svm_queue_exception(struct kvm_vcpu *vcpu)
 
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
@@ -3676,9 +3715,9 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
 	u8 vector;
 	int type;
 	u32 exitintinfo = svm->vmcb->control.exit_int_info;
-	unsigned int3_injected = svm->int3_injected;
+	unsigned soft_int_injected = svm->soft_int_injected;
 
-	svm->int3_injected = 0;
+	svm->soft_int_injected = 0;
 
 	/*
 	 * If we've made progress since setting HF_IRET_MASK, we've
@@ -3698,6 +3737,18 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
 	if (!(exitintinfo & SVM_EXITINTINFO_VALID))
 		return;
 
+	/*
+	 * If NextRIP isn't enabled, KVM must manually advance RIP prior to
+	 * injecting the soft exception/interrupt.  That advancement needs to
+	 * be unwound if vectoring didn't complete.  Note, the _new_ event may
+	 * not be the injected event, e.g. if KVM injected an INTn, the INTn
+	 * hit a #NP in the guest, and the #NP encountered a #PF, the #NP will
+	 * be the reported vectored event, but RIP still needs to be unwound.
+	 */
+	if (soft_int_injected &&
+	    kvm_is_linear_rip(vcpu, to_svm(vcpu)->soft_int_linear_rip))
+		kvm_rip_write(vcpu, kvm_rip_read(vcpu) - soft_int_injected);
+
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 
 	vector = exitintinfo & SVM_EXITINTINFO_VEC_MASK;
@@ -3711,9 +3762,9 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
 	 * hit a #NP in the guest, and the #NP encountered a #PF, the #NP will
 	 * be the reported vectored event, but RIP still needs to be unwound.
 	 */
-	if (int3_injected && type == SVM_EXITINTINFO_TYPE_EXEPT &&
-	   kvm_is_linear_rip(vcpu, svm->int3_rip))
-		kvm_rip_write(vcpu, kvm_rip_read(vcpu) - int3_injected);
+	if (soft_int_injected && type == SVM_EXITINTINFO_TYPE_EXEPT &&
+	   kvm_is_linear_rip(vcpu, svm->soft_int_linear_rip))
+		kvm_rip_write(vcpu, kvm_rip_read(vcpu) - soft_int_injected);
 
 	switch (type) {
 	case SVM_EXITINTINFO_TYPE_NMI:
@@ -3726,14 +3777,6 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
 		if (vector == X86_TRAP_VC)
 			break;
 
-		/*
-		 * In case of software exceptions, do not reinject the vector,
-		 * but re-execute the instruction instead. Rewind RIP first
-		 * if we emulated INT3 before.
-		 */
-		if (kvm_exception_is_soft(vector))
-			break;
-
 		if (exitintinfo & SVM_EXITINTINFO_VALID_ERR) {
 			u32 err = svm->vmcb->control.exit_int_info_err;
 			kvm_requeue_exception_e(vcpu, vector, err);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 47e7427d0395..a770a1c7ddd2 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -230,8 +230,8 @@ struct vcpu_svm {
 	bool nmi_singlestep;
 	u64 nmi_singlestep_guest_rflags;
 
-	unsigned int3_injected;
-	unsigned long int3_rip;
+	unsigned soft_int_injected;
+	unsigned long soft_int_linear_rip;
 
 	/* optional nested SVM features that are enabled for this guest  */
 	bool nrips_enabled                : 1;
-- 
2.35.1.1094.g7c7d902a7c-goog

