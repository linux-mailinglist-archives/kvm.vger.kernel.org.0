Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E79C34EFC94
	for <lists+kvm@lfdr.de>; Sat,  2 Apr 2022 00:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353204AbiDAWJQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 18:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353189AbiDAWJN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 18:09:13 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB261B8FDC
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 15:07:21 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id bx24-20020a17090af49800b001c6872a9e4eso3707989pjb.5
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 15:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mPPInCsBo0G8An74I+xEQEgol6Q2Xxr5RqAtfffNEOY=;
        b=C+Ow4hxGOKncPC0c4Zd7xFnPbrUnb4TIcQJhaIt240MIgMHWqpMkP9DYieRLnsIVsl
         1iK9nZ/XPVg3i1iLQIlBIBbFOVBjXbN2NUfR4fhXKSTFhYcMrf3X61dqH9nXyxHWoszG
         xlb3iPCbhhMcK+WrXv/LUf7Y2di+gKdjVX/4jJm7cgMzoNeLCufY+pXEO0AlsSW5Psen
         AcgcYjEe1bnR6X57Kxy29tQ1wiJz2JESBN5H9pLO4WDlrfVaJl21x3A2y8bXpW77Hhzv
         wkZf1cOurzpUy7uGJBcC1PEdftdn9RPMO36ruhaV2X2H5OqDwzkopWihYdOTX3q6EU5m
         ivgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mPPInCsBo0G8An74I+xEQEgol6Q2Xxr5RqAtfffNEOY=;
        b=McMAjWark2u6BG7l0K1SJ9vALlb2uEzVa+RDTxeU1TwfOuCfYZRL6OZzBu/Hklt/VR
         +EsfQAGxRDZSD/AzpzfROP++r541s5N5YRtCK45mNppBEK2weoxsw2frhOnaszpHUzns
         o0OCfM6HtLS+jvhy6JE3Ksop9HtRcI2HH9iWmRIVNgJSFXT6VJBez7pRcj9uYHCiFOIz
         2N/lw7bkrPrhHV2VFpUY9aL8pxaIlesqBs+9UApM8wZTbm3o5eq3YSOQJn7EqTIfU1PT
         DWPvDJ0fv1GCJzBQGORTz/w1o1ecqEZRJYBmf17Fh7qQQJG+dQZYF9w4Y8dpUL5V4Qd8
         uxiQ==
X-Gm-Message-State: AOAM531HiIzCfAC46IPzi08NqMA1bLD6Q4AcqNucSML8ynPRTuvGCTDa
        Y9j+hx+3OhTY73gs7w41uM6QqA==
X-Google-Smtp-Source: ABdhPJy2t5a+fKT3YEW1ea8g0g5eGYP4MzYbRwHM3m12O96z4nCE6Fmqlkbh7B3gup9l1FTnYRTzig==
X-Received: by 2002:a17:902:d2c8:b0:154:2b02:a499 with SMTP id n8-20020a170902d2c800b001542b02a499mr12382255plc.168.1648850840987;
        Fri, 01 Apr 2022 15:07:20 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f16-20020a056a00229000b004fabe756ba6sm4537090pfe.54.2022.04.01.15.07.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Apr 2022 15:07:20 -0700 (PDT)
Date:   Fri, 1 Apr 2022 22:07:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jon Grimm <Jon.Grimm@amd.com>,
        David Kaplan <David.Kaplan@amd.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Liam Merwick <liam.merwick@oracle.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] KVM: nSVM: Don't forget about L1-injected events
Message-ID: <Ykd3ldZYDTndgxHI@google.com>
References: <cover.1646944472.git.maciej.szmigiero@oracle.com>
 <a28577564a7583c32f0029f2307f63ca8869cf22.1646944472.git.maciej.szmigiero@oracle.com>
 <YkTSul0CbYi/ae0t@google.com>
 <8f9ae64a-dc64-6f46-8cd4-ffd2648a9372@maciej.szmigiero.name>
 <YkTlxCV9wmA3fTlN@google.com>
 <f4cdaf45-c869-f3bb-2ba2-3c0a4da12a6d@maciej.szmigiero.name>
 <YkZCeoDhMg1wOU1f@google.com>
 <8529068e-7d2b-dc54-e259-182ba733105f@maciej.szmigiero.name>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ZgLXG3WJga0Bzibl"
Content-Disposition: inline
In-Reply-To: <8529068e-7d2b-dc54-e259-182ba733105f@maciej.szmigiero.name>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--ZgLXG3WJga0Bzibl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 01, 2022, Maciej S. Szmigiero wrote:
> On 1.04.2022 02:08, Sean Christopherson wrote:
> > where as SVM unconditionally treats #BP and #OF as soft:
> > 
> >    Injecting an exception (TYPE = 3) with vectors 3 or 4 behaves like a trap raised by
> >    INT3 and INTO instructions
> > 
> > Now I'm curious why Intel doesn't do the same...
> 
> Perhaps it's just a result of VMX and SVM being developed independently,
> in parallel.

That definitely factors in, but nothing in VMX is spurious/random, there's always
a reason/motivation behind the architecture, even if that reason isn't obvious.
It bugs me that I can't figure out the "why" :-)

Ugh, but SVM still needs to fix injection for software interrupts, i.e. svm_inject_irq()
is broken.

> > > We still need L1 -> L2 event injection detection to restore the NextRIP
> > > field when re-injecting an event that uses it.
> > 
> > You lost me on this one.  KVM L0 is only (and always!) responsible for saving the
> > relevant info into vmcb12, why does it need to detect where the vectoring exception
> > came from?
> 
> Look at the description of patch 4 of this patch set - after some
> L2 VMEXITs handled by L0 (in other words, which do *not* result in
> a nested VMEXIT to L1) the VMCB02 NextRIP field will be zero
> (APM 15.7.1 "State Saved on Exit" describes when this happens).
> 
> If we attempt to re-inject some types of events with the NextRIP field
> being zero the return address pushed on stack will also be zero, which
> will obviously do bad things to the L2 when it returns from
> an (exception|interrupt) handler.

Right, but that issue isn't unique to L2 exits handled by L0.  E.g. if KVM is using
shadow paging and a #PF "owned" by KVM occurs while vectoring INT3/INTO, then KVM
needs to restore NextRIP after resolving the #PF.

Argh, but NextRIP being zeroed makes it painful to handle the scenario where the
INT3/INT0 isn't injected, because doesn't have a record of the instruction length.
That's a big fail on SVM's part :-/

Huh, actually, it's not too bad to support.  SVM already has the code to compute
the next RIP via the emulator, it's easy enough to reuse that code to calculate
NextRIP and then unwind RIP.

With your patch 1, your selftest and all KVM unit tests passes[*] with the attached
patch.  I'll split it up and send out a proper series with your other fixes and
selftests.  I apologize for usurping your series, I was sketching up a diff to
show what I had in mind for reinjecting and it ended up being less code than I
expected to actually get it working.

[*] The new SVM KUT tests don't pass, but that's a different mess, and anything
    that uses INVCPID doesn't pass with nrips=0 && npt=0 because KVM's emulator
    doesn't know how to decode INVPCID, but KVM needs to intercept INVPCID when
    using shadow paging.

--ZgLXG3WJga0Bzibl
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-KVM-SVM-Re-inject-soft-interrupts-instead-of-retryin.patch"

From 45c0408ca6738a98a3284837d9383be966e86901 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 1 Apr 2022 10:01:18 -0700
Subject: [PATCH] KVM: SVM: Re-inject soft interrupts instead of retrying
 instruction

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 101 +++++++++++++++++++++++++++++------------
 arch/x86/kvm/svm/svm.h |   4 +-
 2 files changed, 73 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2c86bd9176c6..c534d00ae194 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -370,6 +370,45 @@ static int svm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
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
+	 * retry the instruction, it's the least awful option.
+	 */
+	if (!svm_skip_emulated_instruction(vcpu))
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
+		if (static_cpu_has(X86_FEATURE_NRIPS))
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
@@ -379,21 +418,9 @@ static void svm_queue_exception(struct kvm_vcpu *vcpu)
 
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
-		svm->int3_rip = rip + svm->vmcb->save.cs.base;
-		svm->int3_injected = rip - old_rip;
-	}
+	if (kvm_exception_is_soft(nr) &&
+	    svm_update_soft_interrupt_rip(vcpu))
+		return;
 
 	svm->vmcb->control.event_inj = nr
 		| SVM_EVTINJ_VALID
@@ -3382,14 +3409,24 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
 static void svm_inject_irq(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	u32 type;
 
 	WARN_ON(!gif_set(svm));
 
+	if (vcpu->arch.interrupt.soft) {
+		if (svm_update_soft_interrupt_rip(vcpu))
+			return;
+
+		type = SVM_EVTINJ_TYPE_SOFT;
+	} else {
+		type = SVM_EVTINJ_TYPE_INTR;
+	}
+
 	trace_kvm_inj_virq(vcpu->arch.interrupt.nr);
 	++vcpu->stat.irq_injections;
 
 	svm->vmcb->control.event_inj = vcpu->arch.interrupt.nr |
-		SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_INTR;
+				       SVM_EVTINJ_VALID | type;
 }
 
 void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
@@ -3672,9 +3709,9 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
 	u8 vector;
 	int type;
 	u32 exitintinfo = svm->vmcb->control.exit_int_info;
-	unsigned int3_injected = svm->int3_injected;
+	unsigned soft_int_injected = svm->soft_int_injected;
 
-	svm->int3_injected = 0;
+	svm->soft_int_injected = 0;
 
 	/*
 	 * If we've made progress since setting HF_IRET_MASK, we've
@@ -3694,6 +3731,18 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
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
@@ -3710,18 +3759,6 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
 		if (vector == X86_TRAP_VC)
 			break;
 
-		/*
-		 * In case of software exceptions, do not reinject the vector,
-		 * but re-execute the instruction instead. Rewind RIP first
-		 * if we emulated INT3 before.
-		 */
-		if (kvm_exception_is_soft(vector)) {
-			if (vector == BP_VECTOR && int3_injected &&
-			    kvm_is_linear_rip(vcpu, svm->int3_rip))
-				kvm_rip_write(vcpu,
-					      kvm_rip_read(vcpu) - int3_injected);
-			break;
-		}
 		if (exitintinfo & SVM_EXITINTINFO_VALID_ERR) {
 			u32 err = svm->vmcb->control.exit_int_info_err;
 			kvm_requeue_exception_e(vcpu, vector, err);
@@ -3732,9 +3769,13 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
 	case SVM_EXITINTINFO_TYPE_INTR:
 		kvm_queue_interrupt(vcpu, vector, false);
 		break;
+	case SVM_EXITINTINFO_TYPE_SOFT:
+		kvm_queue_interrupt(vcpu, vector, true);
+		break;
 	default:
 		break;
 	}
+
 }
 
 static void svm_cancel_injection(struct kvm_vcpu *vcpu)
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

base-commit: 26f97f8db06dc08a2b6a48692cdc1d89b288905d
-- 
2.35.1.1094.g7c7d902a7c-goog


--ZgLXG3WJga0Bzibl--
