Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 600EA5907C9
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 23:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236457AbiHKVG3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 17:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236330AbiHKVGO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 17:06:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E711E85A85
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 14:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660251970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z79C7+G0Dxe3w3HmQmbb18UPXL0A3NetxvaU68mky2A=;
        b=iNMVsI2KWKZptJI7m54Qnc1U1aM3rBOMHARoBfMVmdD6qG4vw/hxixTMF52YGX9bw0Z4TZ
        IfLnnCOH+nnl84Ph4hihH16b+fCAP+b7r8e4941iujyXf+R5XxlBPD3xZKlKfrTGO3elg2
        7mcJgQCQaEVW1FZ6qQ2c+IWVe41GfXE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-507-Jf8znDLJNFKbI0vanirJ4Q-1; Thu, 11 Aug 2022 17:06:07 -0400
X-MC-Unique: Jf8znDLJNFKbI0vanirJ4Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 41508943201;
        Thu, 11 Aug 2022 21:06:07 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 16BFE492C3B;
        Thu, 11 Aug 2022 21:06:07 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, mlevitsk@redhat.com, vkuznets@redhat.com
Subject: [PATCH v2 5/9] KVM: remove KVM_REQ_UNHALT
Date:   Thu, 11 Aug 2022 17:06:01 -0400
Message-Id: <20220811210605.402337-6-pbonzini@redhat.com>
In-Reply-To: <20220811210605.402337-1-pbonzini@redhat.com>
References: <20220811210605.402337-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_REQ_UNHALT is now unnecessary because it is replaced by the return
value of kvm_vcpu_block/kvm_vcpu_halt.  Remove it.

No functional change intended.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/vcpu-requests.rst | 28 +-----------------------
 arch/arm64/kvm/arm.c                     |  1 -
 arch/mips/kvm/emulate.c                  |  1 -
 arch/powerpc/kvm/book3s_pr.c             |  1 -
 arch/powerpc/kvm/book3s_pr_papr.c        |  1 -
 arch/powerpc/kvm/booke.c                 |  1 -
 arch/powerpc/kvm/powerpc.c               |  1 -
 arch/riscv/kvm/vcpu_insn.c               |  1 -
 arch/s390/kvm/kvm-s390.c                 |  2 --
 arch/x86/kvm/x86.c                       |  2 --
 arch/x86/kvm/xen.c                       |  1 -
 include/linux/kvm_host.h                 |  3 +--
 virt/kvm/kvm_main.c                      |  5 -----
 13 files changed, 2 insertions(+), 46 deletions(-)

diff --git a/Documentation/virt/kvm/vcpu-requests.rst b/Documentation/virt/kvm/vcpu-requests.rst
index 31f62b64e07b..87f04c1fa53d 100644
--- a/Documentation/virt/kvm/vcpu-requests.rst
+++ b/Documentation/virt/kvm/vcpu-requests.rst
@@ -97,7 +97,7 @@ VCPU requests are simply bit indices of the ``vcpu->requests`` bitmap.
 This means general bitops, like those documented in [atomic-ops]_ could
 also be used, e.g. ::
 
-  clear_bit(KVM_REQ_UNHALT & KVM_REQUEST_MASK, &vcpu->requests);
+  clear_bit(KVM_REQ_UNBLOCK & KVM_REQUEST_MASK, &vcpu->requests);
 
 However, VCPU request users should refrain from doing so, as it would
 break the abstraction.  The first 8 bits are reserved for architecture
@@ -126,17 +126,6 @@ KVM_REQ_UNBLOCK
   or in order to update the interrupt routing and ensure that assigned
   devices will wake up the vCPU.
 
-KVM_REQ_UNHALT
-
-  This request may be made from the KVM common function kvm_vcpu_block(),
-  which is used to emulate an instruction that causes a CPU to halt until
-  one of an architectural specific set of events and/or interrupts is
-  received (determined by checking kvm_arch_vcpu_runnable()).  When that
-  event or interrupt arrives kvm_vcpu_block() makes the request.  This is
-  in contrast to when kvm_vcpu_block() returns due to any other reason,
-  such as a pending signal, which does not indicate the VCPU's halt
-  emulation should stop, and therefore does not make the request.
-
 KVM_REQ_OUTSIDE_GUEST_MODE
 
   This "request" ensures the target vCPU has exited guest mode prior to the
@@ -297,21 +286,6 @@ architecture dependent.  kvm_vcpu_block() calls kvm_arch_vcpu_runnable()
 to check if it should awaken.  One reason to do so is to provide
 architectures a function where requests may be checked if necessary.
 
-Clearing Requests
------------------
-
-Generally it only makes sense for the receiving VCPU thread to clear a
-request.  However, in some circumstances, such as when the requesting
-thread and the receiving VCPU thread are executed serially, such as when
-they are the same thread, or when they are using some form of concurrency
-control to temporarily execute synchronously, then it's possible to know
-that the request may be cleared immediately, rather than waiting for the
-receiving VCPU thread to handle the request in VCPU RUN.  The only current
-examples of this are kvm_vcpu_block() calls made by VCPUs to block
-themselves.  A possible side-effect of that call is to make the
-KVM_REQ_UNHALT request, which may then be cleared immediately when the
-VCPU returns from the call.
-
 References
 ==========
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 986cee6fbc7f..0bbd1ce601a5 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -666,7 +666,6 @@ void kvm_vcpu_wfi(struct kvm_vcpu *vcpu)
 
 	kvm_vcpu_halt(vcpu);
 	vcpu_clear_flag(vcpu, IN_WFIT);
-	kvm_clear_request(KVM_REQ_UNHALT, vcpu);
 
 	preempt_disable();
 	vgic_v4_load(vcpu);
diff --git a/arch/mips/kvm/emulate.c b/arch/mips/kvm/emulate.c
index 77d760d45c48..c11143586765 100644
--- a/arch/mips/kvm/emulate.c
+++ b/arch/mips/kvm/emulate.c
@@ -959,7 +959,6 @@ enum emulation_result kvm_mips_emul_wait(struct kvm_vcpu *vcpu)
 		 * We we are runnable, then definitely go off to user space to
 		 * check if any I/O interrupts are pending.
 		 */
-		kvm_clear_request(KVM_REQ_UNHALT, vcpu);
 		if (r > 0)
 			vcpu->run->exit_reason = KVM_EXIT_IRQ_WINDOW_OPEN;
 	}
diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index d6abed6e51e6..9fc4dd8f66eb 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -499,7 +499,6 @@ static void kvmppc_set_msr_pr(struct kvm_vcpu *vcpu, u64 msr)
 	if (msr & MSR_POW) {
 		if (!vcpu->arch.pending_exceptions) {
 			kvm_vcpu_halt(vcpu);
-			kvm_clear_request(KVM_REQ_UNHALT, vcpu);
 			vcpu->stat.generic.halt_wakeup++;
 
 			/* Unset POW bit after we woke up */
diff --git a/arch/powerpc/kvm/book3s_pr_papr.c b/arch/powerpc/kvm/book3s_pr_papr.c
index a1f2978b2a86..b2c89e850d7a 100644
--- a/arch/powerpc/kvm/book3s_pr_papr.c
+++ b/arch/powerpc/kvm/book3s_pr_papr.c
@@ -393,7 +393,6 @@ int kvmppc_h_pr(struct kvm_vcpu *vcpu, unsigned long cmd)
 	case H_CEDE:
 		kvmppc_set_msr_fast(vcpu, kvmppc_get_msr(vcpu) | MSR_EE);
 		kvm_vcpu_halt(vcpu);
-		kvm_clear_request(KVM_REQ_UNHALT, vcpu);
 		vcpu->stat.generic.halt_wakeup++;
 		return EMULATE_DONE;
 	case H_LOGICAL_CI_LOAD:
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index 06c5830a93f9..7b4920e9fd26 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -719,7 +719,6 @@ int kvmppc_core_prepare_to_enter(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.shared->msr & MSR_WE) {
 		local_irq_enable();
 		kvm_vcpu_halt(vcpu);
-		kvm_clear_request(KVM_REQ_UNHALT, vcpu);
 		hard_irq_disable();
 
 		kvmppc_set_exit_type(vcpu, EMULATED_MTMSRWE_EXITS);
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 191992fcb2c2..3c384ed1d9fc 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -238,7 +238,6 @@ int kvmppc_kvm_pv(struct kvm_vcpu *vcpu)
 	case EV_HCALL_TOKEN(EV_IDLE):
 		r = EV_SUCCESS;
 		kvm_vcpu_halt(vcpu);
-		kvm_clear_request(KVM_REQ_UNHALT, vcpu);
 		break;
 	default:
 		r = EV_UNIMPLEMENTED;
diff --git a/arch/riscv/kvm/vcpu_insn.c b/arch/riscv/kvm/vcpu_insn.c
index 7eb90a47b571..0bb52761a3f7 100644
--- a/arch/riscv/kvm/vcpu_insn.c
+++ b/arch/riscv/kvm/vcpu_insn.c
@@ -191,7 +191,6 @@ void kvm_riscv_vcpu_wfi(struct kvm_vcpu *vcpu)
 		kvm_vcpu_srcu_read_unlock(vcpu);
 		kvm_vcpu_halt(vcpu);
 		kvm_vcpu_srcu_read_lock(vcpu);
-		kvm_clear_request(KVM_REQ_UNHALT, vcpu);
 	}
 }
 
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index edfd4bbd0cba..aa39ea4582bd 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4343,8 +4343,6 @@ static int kvm_s390_handle_requests(struct kvm_vcpu *vcpu)
 		goto retry;
 	}
 
-	/* nothing to do, just clear the request */
-	kvm_clear_request(KVM_REQ_UNHALT, vcpu);
 	/* we left the vsie handler, nothing to do, just clear the request */
 	kvm_clear_request(KVM_REQ_VSIE_RESTART, vcpu);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 416df0fc7fda..7f084613fac8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10635,7 +10635,6 @@ static inline int vcpu_block(struct kvm_vcpu *vcpu)
 		if (hv_timer)
 			kvm_lapic_switch_to_hv_timer(vcpu);
 
-		kvm_clear_request(KVM_REQ_UNHALT, vcpu);
 		if (r <= 0)
 			return 1;
 	}
@@ -10842,7 +10841,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 			r = 0;
 			goto out;
 		}
-		kvm_clear_request(KVM_REQ_UNHALT, vcpu);
 		r = -EAGAIN;
 		if (signal_pending(current)) {
 			r = -EINTR;
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 280cb5dc7341..93c628d3e3a9 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -1065,7 +1065,6 @@ static bool kvm_xen_schedop_poll(struct kvm_vcpu *vcpu, bool longmode,
 			del_timer(&vcpu->arch.xen.poll_timer);
 
 		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
-		kvm_clear_request(KVM_REQ_UNHALT, vcpu);
 	}
 
 	vcpu->arch.xen.poll_evtchn = 0;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index cbd9577e5447..cfe46830783f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -151,12 +151,11 @@ static inline bool is_error_page(struct page *page)
 #define KVM_REQUEST_NO_ACTION      BIT(10)
 /*
  * Architecture-independent vcpu->requests bit members
- * Bits 4-7 are reserved for more arch-independent bits.
+ * Bits 3-7 are reserved for more arch-independent bits.
  */
 #define KVM_REQ_TLB_FLUSH         (0 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_VM_DEAD           (1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_UNBLOCK           2
-#define KVM_REQ_UNHALT            3
 #define KVM_REQUEST_ARCH_BASE     8
 
 /*
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e827805b7b28..18292f028536 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3414,7 +3414,6 @@ static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
 	int idx = srcu_read_lock(&vcpu->kvm->srcu);
 
 	if (kvm_arch_vcpu_runnable(vcpu)) {
-		kvm_make_request(KVM_REQ_UNHALT, vcpu);
 		ret = 1;
 		goto out;
 	}
@@ -3508,10 +3507,6 @@ int kvm_vcpu_halt(struct kvm_vcpu *vcpu)
 	stop = do_halt_poll ? start : ktime_add_ns(start, vcpu->halt_poll_ns);
 
 	do {
-		/*
-		 * This sets KVM_REQ_UNHALT if an interrupt
-		 * arrives.
-		 */
 		r = kvm_vcpu_check_block(vcpu);
 		if (r != 0)
 			goto out;
-- 
2.31.1


