Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65FF84275EA
	for <lists+kvm@lfdr.de>; Sat,  9 Oct 2021 04:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244471AbhJICPg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 22:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244417AbhJICPZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 22:15:25 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AADB8C061769
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 19:13:14 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id q17-20020a25b591000000b005a07d27bbdaso15037495ybj.3
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 19:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=gXcvFWXleSZxSOfPAu6atVok3ViHGsYXflXljBl2EOI=;
        b=stBqg1rr2I2utoqSNX2LEP3iyTVBUro4ubeGjwsiSo81BhwmnwzZ+rP+ImHNzDXdU0
         0GsmysDklnAh5QdpufF5N3P/1Q+jvq5OzQYXDVd+ezOU4vM7vXi2dPFn9VQB5a5RPKN3
         GJ8qZVMo78JW8hn4B++mMH/aaCT96LaoHx/ZAYf2l6LTMtmT3HDoPy8c2omKfFdZNzKf
         qJag8XeFypF9RPIwrr3QlzYTo7nR4+ul0S8YvFke+aY6sn7ZgSVWpt/F6DPCz9wdL5kT
         Sq0qdDh6yu71GsZNp2fTit8steSRP8dojn4nrekliwFMQnKDdEB75e7oRN5pp+aK2V3R
         ySCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=gXcvFWXleSZxSOfPAu6atVok3ViHGsYXflXljBl2EOI=;
        b=756Yf44vX5XRyH0rHYDvnRqdgQmBxzkXXy8u2VNk1Fuka/uVKyKU0r+Ttly2azYwGQ
         pzSwELcTnx0/QeTSk3lmeNnozapj0SGn5bvtAMmMru91V9X10/Te7qIQO6JH+peRK9z4
         4umU7w3Ybx89S7mjcnZw465A6GCes8y9NvWJLUvv90pBssk/XgMvUXc8dnus/eeSm7Ai
         izckrLEqhumbUZHDDM+4B6xi0iHRTOOwt8hGTB3xUwTjuIGy20+brEvw9DQa7yeYrHr5
         KVjcoomr16uB+1d8WJEVb2fR0TwKc8srzCcob4JWBR22VNyXHIwKlH7q0ElB4hRKcQdr
         qCtw==
X-Gm-Message-State: AOAM531/tE6f3zJl8bL1Xv07UtSCsk2C+j5jsrK+QpnW8yVdElcnWQQ1
        f5nd0tjJF80naSXhHUA3f1+a7UfATb4=
X-Google-Smtp-Source: ABdhPJw5EfssiGvay5ERoaLRfVi/BUTBhAT50+SU1X4+rTN6WB5F6WVsn1eT3W/lozQwGqf7g24fzyXp6UI=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a25:6586:: with SMTP id z128mr7343816ybb.242.1633745593891;
 Fri, 08 Oct 2021 19:13:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  8 Oct 2021 19:12:06 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-14-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 13/43] KVM: Rename kvm_vcpu_block() => kvm_vcpu_halt()
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename kvm_vcpu_block() to kvm_vcpu_halt() in preparation for splitting
the actual "block" sequences into a separate helper (to be named
kvm_vcpu_block()).  x86 will use the standalone block-only path to handle
non-halt cases where the vCPU is not runnable.

Rename block_ns to halt_ns to match the new function name.

No functional change intended.

Reviewed-by: David Matlack <dmatlack@google.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/arch_timer.c       |  2 +-
 arch/arm64/kvm/arm.c              |  2 +-
 arch/arm64/kvm/handle_exit.c      |  2 +-
 arch/arm64/kvm/psci.c             |  2 +-
 arch/mips/kvm/emulate.c           |  2 +-
 arch/powerpc/kvm/book3s_pr.c      |  2 +-
 arch/powerpc/kvm/book3s_pr_papr.c |  2 +-
 arch/powerpc/kvm/booke.c          |  2 +-
 arch/powerpc/kvm/powerpc.c        |  2 +-
 arch/riscv/kvm/vcpu_exit.c        |  2 +-
 arch/s390/kvm/interrupt.c         |  2 +-
 arch/x86/kvm/x86.c                | 11 +++++++++--
 include/linux/kvm_host.h          |  2 +-
 virt/kvm/kvm_main.c               | 20 +++++++++-----------
 14 files changed, 30 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 3df67c127489..7e8396f74010 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -467,7 +467,7 @@ static void timer_save_state(struct arch_timer_context *ctx)
 }
 
 /*
- * Schedule the background timer before calling kvm_vcpu_block, so that this
+ * Schedule the background timer before calling kvm_vcpu_halt, so that this
  * thread is removed from its waitqueue and made runnable when there's a timer
  * interrupt to handle.
  */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 1346f81b34df..268b1e7bf700 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -672,7 +672,7 @@ void kvm_vcpu_wfi(struct kvm_vcpu *vcpu)
 	vgic_v4_put(vcpu, true);
 	preempt_enable();
 
-	kvm_vcpu_block(vcpu);
+	kvm_vcpu_halt(vcpu);
 	kvm_clear_request(KVM_REQ_UNHALT, vcpu);
 
 	preempt_disable();
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 4794563a506b..6d0baf71aa67 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -82,7 +82,7 @@ static int handle_no_fpsimd(struct kvm_vcpu *vcpu)
  *
  * WFE: Yield the CPU and come back to this vcpu when the scheduler
  * decides to.
- * WFI: Simply call kvm_vcpu_block(), which will halt execution of
+ * WFI: Simply call kvm_vcpu_halt(), which will halt execution of
  * world-switches and schedule other host processes until there is an
  * incoming IRQ or FIQ to the VM.
  */
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 74c47d420253..e275b2ca08b9 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -46,7 +46,7 @@ static unsigned long kvm_psci_vcpu_suspend(struct kvm_vcpu *vcpu)
 	 * specification (ARM DEN 0022A). This means all suspend states
 	 * for KVM will preserve the register state.
 	 */
-	kvm_vcpu_block(vcpu);
+	kvm_vcpu_halt(vcpu);
 	kvm_clear_request(KVM_REQ_UNHALT, vcpu);
 
 	return PSCI_RET_SUCCESS;
diff --git a/arch/mips/kvm/emulate.c b/arch/mips/kvm/emulate.c
index 22e745e49b0a..b494d8d39290 100644
--- a/arch/mips/kvm/emulate.c
+++ b/arch/mips/kvm/emulate.c
@@ -952,7 +952,7 @@ enum emulation_result kvm_mips_emul_wait(struct kvm_vcpu *vcpu)
 	if (!vcpu->arch.pending_exceptions) {
 		kvm_vz_lose_htimer(vcpu);
 		vcpu->arch.wait = 1;
-		kvm_vcpu_block(vcpu);
+		kvm_vcpu_halt(vcpu);
 
 		/*
 		 * We we are runnable, then definitely go off to user space to
diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index 6bc9425acb32..0ced1b16f0e5 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -492,7 +492,7 @@ static void kvmppc_set_msr_pr(struct kvm_vcpu *vcpu, u64 msr)
 
 	if (msr & MSR_POW) {
 		if (!vcpu->arch.pending_exceptions) {
-			kvm_vcpu_block(vcpu);
+			kvm_vcpu_halt(vcpu);
 			kvm_clear_request(KVM_REQ_UNHALT, vcpu);
 			vcpu->stat.generic.halt_wakeup++;
 
diff --git a/arch/powerpc/kvm/book3s_pr_papr.c b/arch/powerpc/kvm/book3s_pr_papr.c
index ac14239f3424..1f10e7dfcdd0 100644
--- a/arch/powerpc/kvm/book3s_pr_papr.c
+++ b/arch/powerpc/kvm/book3s_pr_papr.c
@@ -376,7 +376,7 @@ int kvmppc_h_pr(struct kvm_vcpu *vcpu, unsigned long cmd)
 		return kvmppc_h_pr_stuff_tce(vcpu);
 	case H_CEDE:
 		kvmppc_set_msr_fast(vcpu, kvmppc_get_msr(vcpu) | MSR_EE);
-		kvm_vcpu_block(vcpu);
+		kvm_vcpu_halt(vcpu);
 		kvm_clear_request(KVM_REQ_UNHALT, vcpu);
 		vcpu->stat.generic.halt_wakeup++;
 		return EMULATE_DONE;
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index 977801c83aff..12abffa40cd9 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -718,7 +718,7 @@ int kvmppc_core_prepare_to_enter(struct kvm_vcpu *vcpu)
 
 	if (vcpu->arch.shared->msr & MSR_WE) {
 		local_irq_enable();
-		kvm_vcpu_block(vcpu);
+		kvm_vcpu_halt(vcpu);
 		kvm_clear_request(KVM_REQ_UNHALT, vcpu);
 		hard_irq_disable();
 
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index be22da157569..6a94545b99fc 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -236,7 +236,7 @@ int kvmppc_kvm_pv(struct kvm_vcpu *vcpu)
 		break;
 	case EV_HCALL_TOKEN(EV_IDLE):
 		r = EV_SUCCESS;
-		kvm_vcpu_block(vcpu);
+		kvm_vcpu_halt(vcpu);
 		kvm_clear_request(KVM_REQ_UNHALT, vcpu);
 		break;
 	default:
diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index 13bbc3f73713..949bb9828aa5 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -146,7 +146,7 @@ static int system_opcode_insn(struct kvm_vcpu *vcpu,
 		vcpu->stat.wfi_exit_stat++;
 		if (!kvm_arch_vcpu_runnable(vcpu)) {
 			srcu_read_unlock(&vcpu->kvm->srcu, vcpu->arch.srcu_idx);
-			kvm_vcpu_block(vcpu);
+			kvm_vcpu_halt(vcpu);
 			vcpu->arch.srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
 			kvm_clear_request(KVM_REQ_UNHALT, vcpu);
 		}
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 520450a7956f..10bd648170b7 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -1335,7 +1335,7 @@ int kvm_s390_handle_wait(struct kvm_vcpu *vcpu)
 	VCPU_EVENT(vcpu, 4, "enabled wait: %llu ns", sltime);
 no_timer:
 	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
-	kvm_vcpu_block(vcpu);
+	kvm_vcpu_halt(vcpu);
 	vcpu->valid_wakeup = false;
 	__unset_cpu_idle(vcpu);
 	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9c23ae1d483d..e6c17bbed25c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8651,6 +8651,13 @@ void kvm_arch_exit(void)
 
 static int __kvm_emulate_halt(struct kvm_vcpu *vcpu, int state, int reason)
 {
+	/*
+	 * The vCPU has halted, e.g. executed HLT.  Update the run state if the
+	 * local APIC is in-kernel, the run loop will detect the non-runnable
+	 * state and halt the vCPU.  Exit to userspace if the local APIC is
+	 * managed by userspace, in which case userspace is responsible for
+	 * handling wake events.
+	 */
 	++vcpu->stat.halt_exits;
 	if (lapic_in_kernel(vcpu)) {
 		vcpu->arch.mp_state = state;
@@ -9892,7 +9899,7 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
 	if (!kvm_arch_vcpu_runnable(vcpu) &&
 	    (!kvm_x86_ops.pre_block || static_call(kvm_x86_pre_block)(vcpu) == 0)) {
 		srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
-		kvm_vcpu_block(vcpu);
+		kvm_vcpu_halt(vcpu);
 		vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
 
 		if (kvm_x86_ops.post_block)
@@ -10126,7 +10133,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 			r = -EINTR;
 			goto out;
 		}
-		kvm_vcpu_block(vcpu);
+		kvm_vcpu_halt(vcpu);
 		if (kvm_apic_accept_events(vcpu) < 0) {
 			r = 0;
 			goto out;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1ced2914d9ca..c2ea4004553a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -967,7 +967,7 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn);
 void kvm_sigset_activate(struct kvm_vcpu *vcpu);
 void kvm_sigset_deactivate(struct kvm_vcpu *vcpu);
 
-void kvm_vcpu_block(struct kvm_vcpu *vcpu);
+void kvm_vcpu_halt(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu);
 bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 227f6bbe0716..c13bf3367fda 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3223,17 +3223,14 @@ static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
 	}
 }
 
-/*
- * The vCPU has executed a HLT instruction with in-kernel mode enabled.
- */
-void kvm_vcpu_block(struct kvm_vcpu *vcpu)
+void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
 {
 	struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
 	bool halt_poll_allowed = !kvm_arch_no_poll(vcpu);
 	bool do_halt_poll = halt_poll_allowed && vcpu->halt_poll_ns;
 	ktime_t start, cur, poll_end;
 	bool waited = false;
-	u64 block_ns;
+	u64 halt_ns;
 
 	start = cur = poll_end = ktime_get();
 	if (do_halt_poll) {
@@ -3275,7 +3272,8 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 				ktime_to_ns(cur) - ktime_to_ns(poll_end));
 	}
 out:
-	block_ns = ktime_to_ns(cur) - ktime_to_ns(start);
+	/* The total time the vCPU was "halted", including polling time. */
+	halt_ns = ktime_to_ns(cur) - ktime_to_ns(start);
 
 	/*
 	 * Note, halt-polling is considered successful so long as the vCPU was
@@ -3289,24 +3287,24 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 		if (!vcpu_valid_wakeup(vcpu)) {
 			shrink_halt_poll_ns(vcpu);
 		} else if (vcpu->kvm->max_halt_poll_ns) {
-			if (block_ns <= vcpu->halt_poll_ns)
+			if (halt_ns <= vcpu->halt_poll_ns)
 				;
 			/* we had a long block, shrink polling */
 			else if (vcpu->halt_poll_ns &&
-					block_ns > vcpu->kvm->max_halt_poll_ns)
+				 halt_ns > vcpu->kvm->max_halt_poll_ns)
 				shrink_halt_poll_ns(vcpu);
 			/* we had a short halt and our poll time is too small */
 			else if (vcpu->halt_poll_ns < vcpu->kvm->max_halt_poll_ns &&
-					block_ns < vcpu->kvm->max_halt_poll_ns)
+				 halt_ns < vcpu->kvm->max_halt_poll_ns)
 				grow_halt_poll_ns(vcpu);
 		} else {
 			vcpu->halt_poll_ns = 0;
 		}
 	}
 
-	trace_kvm_vcpu_wakeup(block_ns, waited, vcpu_valid_wakeup(vcpu));
+	trace_kvm_vcpu_wakeup(halt_ns, waited, vcpu_valid_wakeup(vcpu));
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_block);
+EXPORT_SYMBOL_GPL(kvm_vcpu_halt);
 
 bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu)
 {
-- 
2.33.0.882.g93a45727a2-goog

