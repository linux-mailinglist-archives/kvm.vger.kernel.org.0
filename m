Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E00350C679
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 04:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbiDWCSb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 22:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231962AbiDWCR2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 22:17:28 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB538223C5B
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 19:14:28 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id z18-20020a631912000000b003a392265b64so5980117pgl.2
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 19:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=YP3aW6zH/fPatigZ4/X2xyENnpxrIf5NXRWAQXh1KLg=;
        b=rpke6V8tq81cNiJq2YbH/e/SKEreh+ccqI6cvAcxsFxbZzVRTwQBkT2K5IOGGNpyTN
         MMuqFixY9wazTtMwAPYIiiGJw+nln9T28cLoEEUeVw9SqanV79u1LJyrDFDKgDqM6uTZ
         vTje6rQXKM/H9sY9rS0xXC/TTEZ/rgYIBX++3JfGU/cHxcBePPr86shcjIhBkGd9GtDq
         aRMPPAMPdaE1k+5PrQJWUWiMkg/4ccEbBCTQPNtAGPI+DF/BfSBtwJFs1fgNP/UY+21x
         6pz9pIYewZSt1A2Px7+30nUzMeF0gm6zzika0ZhX1EhsfoUyEJMpkQ3kfy34jfmuD5qk
         zBuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=YP3aW6zH/fPatigZ4/X2xyENnpxrIf5NXRWAQXh1KLg=;
        b=ogLXmUBAUxOH+16MrlNdxLkC5E1wjWoVwrNOhy0G2BLaeF2IGM+mgNFzqVDeMV6zOX
         W3dy8f4ZSf4v2V8kOUY/NL9IOP/B4U714ut6y60Xg9DADjygHVIK6lfMuNlu0hVRZvO5
         MgU36dHkKMg2bgUFiR2xUJaCcIX7vT6q/bZNmj+HdmbXvrUBi3gPjYZJVCYWvbuZI/d1
         UJu1BgrZ4J1j99txzThvEbF28XJjmeyrRak9QnXV/jiyNaA7n+Ksj/QBm1SODFrABkss
         WBQ4AU83ZO1PHNviGBUi86Uc3Og0Uds+eR5PwXPUPTtgvc3z/v34Cvz+bEtNMmmsDitT
         hkEg==
X-Gm-Message-State: AOAM5319zp6aQGQpvqqiZUgPdaWpj1lYwaeqILoA6bVqV1nu9SWsT4C7
        aMYS2trAIuDAx6XpigiuhIS+UMDPbio=
X-Google-Smtp-Source: ABdhPJzBvVLBVOJkFuVNdSGeoj3Ci9BrrzKHIL3X4LWZX/7nIkrKwJyzT9JIpsHPvrHoD2c6LWWya7UkcAQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:ccc9:b0:15b:c265:b7a0 with SMTP id
 z9-20020a170902ccc900b0015bc265b7a0mr6812946ple.107.1650680068213; Fri, 22
 Apr 2022 19:14:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Apr 2022 02:14:09 +0000
In-Reply-To: <20220423021411.784383-1-seanjc@google.com>
Message-Id: <20220423021411.784383-10-seanjc@google.com>
Mime-Version: 1.0
References: <20220423021411.784383-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v2 09/11] KVM: x86: Differentiate Soft vs. Hard IRQs vs.
 reinjected in tracepoint
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

In the IRQ injection tracepoint, differentiate between Hard IRQs and Soft
"IRQs", i.e. interrupts that are reinjected after incomplete delivery of
a software interrupt from an INTn instruction.  Tag reinjected interrupts
as such, even though the information is usually redundant since soft
interrupts are only ever reinjected by KVM.  Though rare in practice, a
hard IRQ can be reinjected.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/svm/svm.c          |  5 +++--
 arch/x86/kvm/trace.h            | 16 +++++++++++-----
 arch/x86/kvm/vmx/vmx.c          |  4 ++--
 arch/x86/kvm/x86.c              |  4 ++--
 5 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f164c6c1514a..ae088c6fb287 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1400,7 +1400,7 @@ struct kvm_x86_ops {
 	u32 (*get_interrupt_shadow)(struct kvm_vcpu *vcpu);
 	void (*patch_hypercall)(struct kvm_vcpu *vcpu,
 				unsigned char *hypercall_addr);
-	void (*inject_irq)(struct kvm_vcpu *vcpu);
+	void (*inject_irq)(struct kvm_vcpu *vcpu, bool reinjected);
 	void (*inject_nmi)(struct kvm_vcpu *vcpu);
 	void (*queue_exception)(struct kvm_vcpu *vcpu);
 	void (*cancel_injection)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b8fb07eeeca5..4a912623b961 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3427,7 +3427,7 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
 	++vcpu->stat.nmi_injections;
 }
 
-static void svm_inject_irq(struct kvm_vcpu *vcpu)
+static void svm_inject_irq(struct kvm_vcpu *vcpu, bool reinjected)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u32 type;
@@ -3442,7 +3442,8 @@ static void svm_inject_irq(struct kvm_vcpu *vcpu)
 		type = SVM_EVTINJ_TYPE_INTR;
 	}
 
-	trace_kvm_inj_virq(vcpu->arch.interrupt.nr);
+	trace_kvm_inj_virq(vcpu->arch.interrupt.nr,
+			   vcpu->arch.interrupt.soft, reinjected);
 	++vcpu->stat.irq_injections;
 
 	svm->vmcb->control.event_inj = vcpu->arch.interrupt.nr |
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 385436d12024..e1b089285c55 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -333,18 +333,24 @@ TRACE_EVENT_KVM_EXIT(kvm_exit);
  * Tracepoint for kvm interrupt injection:
  */
 TRACE_EVENT(kvm_inj_virq,
-	TP_PROTO(unsigned int irq),
-	TP_ARGS(irq),
+	TP_PROTO(unsigned int vector, bool soft, bool reinjected),
+	TP_ARGS(vector, soft, reinjected),
 
 	TP_STRUCT__entry(
-		__field(	unsigned int,	irq		)
+		__field(	unsigned int,	vector		)
+		__field(	bool,		soft		)
+		__field(	unsigned int,	reinjected	)
 	),
 
 	TP_fast_assign(
-		__entry->irq		= irq;
+		__entry->vector		= vector;
+		__entry->soft		= soft;
+		__entry->reinjected	= reinjected;
 	),
 
-	TP_printk("irq %u", __entry->irq)
+	TP_printk("%s 0x%x%s",
+		  __entry->soft ? "Soft/INTn" : "IRQ", __entry->vector,
+		  __entry->reinjected ? " [reinjected]" : "")
 );
 
 #define EXS(x) { x##_VECTOR, "#" #x }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cf8581978bce..a0083464682d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4566,13 +4566,13 @@ static void vmx_enable_nmi_window(struct kvm_vcpu *vcpu)
 	exec_controls_setbit(to_vmx(vcpu), CPU_BASED_NMI_WINDOW_EXITING);
 }
 
-static void vmx_inject_irq(struct kvm_vcpu *vcpu)
+static void vmx_inject_irq(struct kvm_vcpu *vcpu, bool reinjected)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	uint32_t intr;
 	int irq = vcpu->arch.interrupt.nr;
 
-	trace_kvm_inj_virq(irq);
+	trace_kvm_inj_virq(irq, vcpu->arch.interrupt.soft, reinjected);
 
 	++vcpu->stat.irq_injections;
 	if (vmx->rmode.vm86_active) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c3ee8dc00d3a..0a154b54b8aa 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9433,7 +9433,7 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
 			static_call(kvm_x86_inject_nmi)(vcpu);
 			can_inject = false;
 		} else if (vcpu->arch.interrupt.injected) {
-			static_call(kvm_x86_inject_irq)(vcpu);
+			static_call(kvm_x86_inject_irq)(vcpu, true);
 			can_inject = false;
 		}
 	}
@@ -9524,7 +9524,7 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
 			goto out;
 		if (r) {
 			kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu), false);
-			static_call(kvm_x86_inject_irq)(vcpu);
+			static_call(kvm_x86_inject_irq)(vcpu, false);
 			WARN_ON(static_call(kvm_x86_interrupt_allowed)(vcpu, true) < 0);
 		}
 		if (kvm_cpu_has_injectable_intr(vcpu))
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

