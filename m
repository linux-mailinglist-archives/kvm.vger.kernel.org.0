Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E68E050C66B
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 04:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbiDWCR2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 22:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231887AbiDWCRS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 22:17:18 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A23BE21BAC2
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 19:14:23 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id x14-20020aa793ae000000b0050ad3a0b472so5024058pff.6
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 19:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=2vvWQ9/N6TBUtPpS273fWXc6JvToYd+8tR496nicoP4=;
        b=n3TDy7z9cxCWkbe0b3hZSx68GdKDEavEBHm2F/2UnaSWCFQX67C/O/sxgWC3RRbaFY
         6++xptZLz9/3RWcuEGF9mur1xrOgcyh6i+HrlS/1MXF/E3mJIOmOzpPU1weA5QigFL4z
         797WU5CVvsd35eTHEti0NijTeAZG31ROQv/Rz/xW3Ge5a8g9aFGrW5xzrFEZ3ZK5Za50
         P1Vp+q3Cs6DPuwfsppq3GslpW6SszRWquVa1A/CSiv7ztDCU8bO4mlyn6hkCcFGPkyJF
         D8qMb/vxCLkULOfG4AJRNSzj1wsjFsGRZAK7plrVyD9jMKoBpjyQFS4PZX+s8wigC+wu
         JuEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=2vvWQ9/N6TBUtPpS273fWXc6JvToYd+8tR496nicoP4=;
        b=CuAcp5lPvvMiOW0anfdEmDShfVt9mhuGsZ5nmgPZ/tA89mz7hWf5HCd4O9LUNPE6WV
         RH/LRqePdlWQlQK8UZ1BItazxdWzHrf3WIKeAPbZvERUN3YGnqGdxPWQbUmNKtv5C6u6
         JxArjnoloOO9tCvCCKUKnMXRVmyiJZm3oaKnVHT1AV3S2A6F6xVa7/QslxGerH+V1q/L
         Q6+GapYoL5gUYgZPO/tPpYPQWOyOhpUxb254YKsR+gaBS2uD+BHIRJ5uhiXB4NWCBIcq
         AJdeqJQFo9MOnX57d3wjLzyDLG7E2IKPrLFaQFNar0eAuw9cHtTKzs/BTlv5aIVgAytv
         Le4g==
X-Gm-Message-State: AOAM5312CCbYaryBkttmzvql5crQJD3Mg1sFN5LyyAq/iau0/rb2fQpm
        nUnZLqViOGV8t4+CAiB3u2c9IqT1Ol4=
X-Google-Smtp-Source: ABdhPJwkgmq74doJUUfzWDwKUzbCOAwHJhdGFtSbxKNWqKLyDARCy1+spnoY/OA2++CPk27FgQGYWdk2+uU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:9105:b0:1d2:9e98:7e1e with SMTP id
 k5-20020a17090a910500b001d29e987e1emr692797pjo.0.1650680062764; Fri, 22 Apr
 2022 19:14:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Apr 2022 02:14:06 +0000
In-Reply-To: <20220423021411.784383-1-seanjc@google.com>
Message-Id: <20220423021411.784383-7-seanjc@google.com>
Mime-Version: 1.0
References: <20220423021411.784383-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v2 06/11] KVM: SVM: Re-inject INTn instead of retrying the
 insn on "failure"
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
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Re-inject INTn software interrupts instead of retrying the instruction if
the CPU encountered an intercepted exception while vectoring the INTn,
e.g. if KVM intercepted a #PF when utilizing shadow paging.  Retrying the
instruction is architecturally wrong e.g. will result in a spurious #DB
if there's a code breakpoint on the INT3/O, and lack of re-injection also
breaks nested virtualization, e.g. if L1 injects a software interrupt and
vectoring the injected interrupt encounters an exception that is
intercepted by L0 but not L1.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c |  7 +++----
 arch/x86/kvm/svm/svm.c    | 24 +++++++++++++++++++-----
 2 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 0163238aa198..a83e367ade54 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -617,10 +617,9 @@ static inline bool is_evtinj_soft(u32 evtinj)
 	if (!(evtinj & SVM_EVTINJ_VALID))
 		return false;
 
-	/*
-	 * Intentionally return false for SOFT events, SVM doesn't yet support
-	 * re-injecting soft interrupts.
-	 */
+	if (type == SVM_EVTINJ_TYPE_SOFT)
+		return true;
+
 	return type == SVM_EVTINJ_TYPE_EXEPT && kvm_exception_is_soft(vector);
 }
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8321f9ce5e35..b8fb07eeeca5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3430,14 +3430,23 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
 static void svm_inject_irq(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	u32 type;
 
-	WARN_ON(!vcpu->arch.interrupt.soft && !gif_set(svm));
+	if (vcpu->arch.interrupt.soft) {
+		if (svm_update_soft_interrupt_rip(vcpu))
+			return;
+
+		type = SVM_EVTINJ_TYPE_SOFT;
+	} else {
+		WARN_ON(!gif_set(svm));
+		type = SVM_EVTINJ_TYPE_INTR;
+	}
 
 	trace_kvm_inj_virq(vcpu->arch.interrupt.nr);
 	++vcpu->stat.irq_injections;
 
 	svm->vmcb->control.event_inj = vcpu->arch.interrupt.nr |
-		SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_INTR;
+				       SVM_EVTINJ_VALID | type;
 }
 
 void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
@@ -3717,6 +3726,8 @@ static inline void sync_lapic_to_cr8(struct kvm_vcpu *vcpu)
 static void svm_complete_soft_interrupt(struct kvm_vcpu *vcpu, u8 vector,
 					int type)
 {
+	bool is_exception = (type == SVM_EXITINTINFO_TYPE_EXEPT);
+	bool is_soft = (type == SVM_EXITINTINFO_TYPE_SOFT);
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	/*
@@ -3728,8 +3739,7 @@ static void svm_complete_soft_interrupt(struct kvm_vcpu *vcpu, u8 vector,
 	 * the same event, i.e. if the event is a soft exception/interrupt,
 	 * otherwise next_rip is unused on VMRUN.
 	 */
-	if (nrips && type == SVM_EXITINTINFO_TYPE_EXEPT &&
-	    kvm_exception_is_soft(vector) &&
+	if (nrips && (is_soft || (is_exception && kvm_exception_is_soft(vector))) &&
 	    kvm_is_linear_rip(vcpu, svm->soft_int_old_rip + svm->soft_int_csbase))
 		svm->vmcb->control.next_rip = svm->soft_int_next_rip;
 	/*
@@ -3740,7 +3750,7 @@ static void svm_complete_soft_interrupt(struct kvm_vcpu *vcpu, u8 vector,
 	 * hit a #NP in the guest, and the #NP encountered a #PF, the #NP will
 	 * be the reported vectored event, but RIP still needs to be unwound.
 	 */
-	else if (!nrips && type == SVM_EXITINTINFO_TYPE_EXEPT &&
+	else if (!nrips && (is_soft || is_exception) &&
 		 kvm_is_linear_rip(vcpu, svm->soft_int_next_rip + svm->soft_int_csbase))
 		kvm_rip_write(vcpu, svm->soft_int_old_rip);
 }
@@ -3802,9 +3812,13 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
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
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

