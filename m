Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04632516892
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 00:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378386AbiEAWM3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 May 2022 18:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378175AbiEAWMR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 May 2022 18:12:17 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B725D252B0;
        Sun,  1 May 2022 15:08:36 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1nlHjx-0008P0-VB; Mon, 02 May 2022 00:08:30 +0200
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 09/12] KVM: x86: Differentiate Soft vs. Hard IRQs vs. reinjected in tracepoint
Date:   Mon,  2 May 2022 00:07:33 +0200
Message-Id: <9664d49b3bd21e227caa501cff77b0569bebffe2.1651440202.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1651440202.git.maciej.szmigiero@oracle.com>
References: <cover.1651440202.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

In the IRQ injection tracepoint, differentiate between Hard IRQs and Soft
"IRQs", i.e. interrupts that are reinjected after incomplete delivery of
a software interrupt from an INTn instruction.  Tag reinjected interrupts
as such, even though the information is usually redundant since soft
interrupts are only ever reinjected by KVM.  Though rare in practice, a
hard IRQ can be reinjected.

Signed-off-by: Sean Christopherson <seanjc@google.com>
[MSS: change "kvm_inj_virq" event "reinjected" field type to bool]
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
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
index a1158fc25c4c..f946161520f6 100644
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
@@ -3441,7 +3441,8 @@ static void svm_inject_irq(struct kvm_vcpu *vcpu)
 		type = SVM_EVTINJ_TYPE_INTR;
 	}
 
-	trace_kvm_inj_virq(vcpu->arch.interrupt.nr);
+	trace_kvm_inj_virq(vcpu->arch.interrupt.nr,
+			   vcpu->arch.interrupt.soft, reinjected);
 	++vcpu->stat.irq_injections;
 
 	svm->vmcb->control.event_inj = vcpu->arch.interrupt.nr |
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 385436d12024..fd28dd40b813 100644
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
+		__field(	bool,		reinjected	)
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
index a41d616ad943..d2d118498437 100644
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
