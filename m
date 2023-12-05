Return-Path: <kvm+bounces-3612-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B63C805B14
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 18:23:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A01471F214E4
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 17:23:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42FB265ED0;
	Tue,  5 Dec 2023 17:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UjUNN82s"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B351BF
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 09:23:29 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1d03cf821e3so26919995ad.3
        for <kvm@vger.kernel.org>; Tue, 05 Dec 2023 09:23:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701797009; x=1702401809; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0r47D2c2y8Tg83sdqrbpGyqwkKhzZ9o4qmO0OQnotyI=;
        b=UjUNN82sA/x8F9vibpGbjrVGT9o1AQy/XIMFuVfVgU79uBOOMBtEb644OJhqZNYa74
         CIN1j7e8j8TxEPcWYIKkkvFJZpd8MjQ8uJYApayQVIthfXafM0zHv11e57tPo9uyeBzE
         yUduTagETGMvKw6KQpuMgtzHVlU+DdShuFYmoUcACjhhU6dYWA9Xe+ZKabFWmlbfZFxV
         Or32YT9Amw1u7KxnDe1ruAeKbFpuiTmYunFUKg02Cg1m5tD6H1/53sOlppPXz9qM7NAR
         4VOqV6ezF0+Dm4j0LYzrcmhgpGiz0hHU4bLuWEBvrikfD93n8M0PFC1g14md5AB4dv3J
         /LRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701797009; x=1702401809;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0r47D2c2y8Tg83sdqrbpGyqwkKhzZ9o4qmO0OQnotyI=;
        b=w0iqHAgZA7PPEeQ+iU9scXQrNs3Iz5ff8mY8cS+jgqrFVbGdugORy5T2fjfTt5lZ51
         GT66hTJaJVhALmwwM0m0V9Tr+LH/FMiyGDwSeuH/THdSwldbIC6eQdI9IxyRkP4II8nl
         G3zTsGBNLArecHBXIX5uVbupXVa2AuCHxI4lGhPc1CvmydShtBd33plcvf1dFqVcZmFd
         MucU+PN6rKus1cqQyv+vLTYT3Q+U8AiO4fXeLzKc0xthcjzmtnh55m6aIvyrWkRSL97l
         crDOrbOb8itZEYTRYuOiyagDcIaaERORScTxr6Rvwyd72AWiJHVM15v7hssIA0kGj269
         PeNQ==
X-Gm-Message-State: AOJu0YygsqqQmcvPMop1F6a31Yx1RHgEvoUsQ/O2n+kBOsx1j5PStwUZ
	zpQu8wHV4AfURgxHJDKkUq39Z0ECTxI=
X-Google-Smtp-Source: AGHT+IE+nvpbUMXf/y+eX7L6sAOeoBonoQ4Z9N3/gKckoZHTzFOdcmRsn7LJkenkRkxi8g+Fv/Zgezbqvg8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:efc5:b0:1d0:b595:4ea4 with SMTP id
 ja5-20020a170902efc500b001d0b5954ea4mr55321plb.4.1701797008835; Tue, 05 Dec
 2023 09:23:28 -0800 (PST)
Date: Tue, 5 Dec 2023 09:23:26 -0800
In-Reply-To: <20231205103745.506724-2-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231205103745.506724-1-mlevitsk@redhat.com> <20231205103745.506724-2-mlevitsk@redhat.com>
Message-ID: <ZW9cjuWbICTw8rCy@google.com>
Subject: Re: [PATCH v4 1/4] KVM: x86: refactor req_immediate_exit logic
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, 
	Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, 
	"H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Dec 05, 2023, Maxim Levitsky wrote:
> - move req_immediate_exit variable from arch specific to common code.
> - remove arch specific callback .request_immediate_exit and move the code
>   down to the arch's vcpu_run's code.
> 
> No functional change is intended.

Ooh, but there is a very subtle change here that could impact functionality.  This
moves the sending of the self-IPI much closer to VM-Enter.  In practice that is
extremely unlikely to matter, but in theory it ever so slightly increases the
danger of the IRQ not being pended before VM-Enter.  I am not saying we can't do
the move, but it should be done in a fairly isolated patch.

And I am strongly opposed to moving req_immediate_exit into kvm_vcpu_arch.  The
flag in vcpu_vmx is bad enough, but at least that one is decently well guarded
in the sense that's its unconditionally cleared in vmx_prepare_switch_to_guest().
I would much rather go in the opposite direction and turn req_immediate_exit into
a local variable that is passed down the stack as needed.

Somewhat of a side topic, I think we should name the variable that's passed down
the stack "force_immediate_exit".  I suspect the "request" verbiage came from the
fact that the immediate exit is triggered in order to service a request.  But as
far as the the vendor's .vcpu_run() is concerned, an immediate exit isn't being
requested, it's being forced.

The VMX preemption timer code in particular can benefit from related cleanups, as
the fastpath vs. slowpath code is super confusing (the slowpath _looks_ redundant,
but it's subtly necessary to handle exits from L2).  With ~5 patches of cleanup,
the VMX code can be made to look like this, i.e. can eliminate the vcpu_vmx flag
and also handle forced exits from L2 in the fastpath.

static fastpath_t handle_fastpath_preemption_timer(struct kvm_vcpu *vcpu,
						   bool force_immediate_exit)
{
	struct vcpu_vmx *vmx = to_vmx(vcpu);

	/*
	 * In the *extremely* unlikely scenario that this is a spurious VM-Exit
	 * due to the timer expiring while it was "soft" disabled, just eat the
	 * exit and re-enter the guest.
	 */
	if (unlikely(vmx->loaded_vmcs->hv_timer_soft_disabled))
		return EXIT_FASTPATH_REENTER_GUEST;

	/*
	 * If the timer expired because KVM used it to force an immediate exit,
	 * then mission accomplished.
	 */
	if (force_immediate_exit)
		return EXIT_FASTPATH_EXIT_HANDLED;

	/*
	 * If L2 is active, go down the slow path as emulating the guest timer
	 * expiration likely requires synthesizing a nested VM-Exit.
	 */
	if (is_guest_mode(vcpu))
		return EXIT_FASTPATH_NONE;

	kvm_lapic_expired_hv_timer(vcpu);
	return EXIT_FASTPATH_REENTER_GUEST;
}

static int handle_preemption_timer(struct kvm_vcpu *vcpu)
{
	/*
	 * This non-fastpath handler is reached if and only if the preemption
	 * timer was being used to emulate a guest timer while L2 is active.
	 * All other scenarios are supposed to be handled in the fastpath.
	 */
	WARN_ON_ONCE(!is_guest_mode(vcpu));
	kvm_lapic_expired_hv_timer(vcpu);
	return 1;
}

For this series, the minimal change is to plumb the flag into track_kvm_entry()
in a standalone patch.  The below is compile tested only.

Holler if you want me to post an RFC for the full series I have in mind, e.g. if
it's hard to see how the below leads to a sane end result.  I have the code written
and compile tested, but I'm going to be buried in non-upstream stuff for a few
days and probably won't get around to fully testing and writing changelogs until
later this week.

---
 arch/x86/include/asm/kvm_host.h | 3 ++-
 arch/x86/kvm/svm/svm.c          | 5 +++--
 arch/x86/kvm/trace.h            | 9 ++++++---
 arch/x86/kvm/vmx/vmx.c          | 4 ++--
 arch/x86/kvm/x86.c              | 2 +-
 5 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c8c7e2475a18..aee423e6c6f0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1652,7 +1652,8 @@ struct kvm_x86_ops {
 	void (*flush_tlb_guest)(struct kvm_vcpu *vcpu);
 
 	int (*vcpu_pre_run)(struct kvm_vcpu *vcpu);
-	enum exit_fastpath_completion (*vcpu_run)(struct kvm_vcpu *vcpu);
+	enum exit_fastpath_completion (*vcpu_run)(struct kvm_vcpu *vcpu,
+						  bool force_immediate_exit);
 	int (*handle_exit)(struct kvm_vcpu *vcpu,
 		enum exit_fastpath_completion exit_fastpath);
 	int (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c46f07b28230..33f3db2058fd 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4112,12 +4112,13 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_in
 	guest_state_exit_irqoff();
 }
 
-static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
+static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
+					  bool force_immediate_exit)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	bool spec_ctrl_intercepted = msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL);
 
-	trace_kvm_entry(vcpu);
+	trace_kvm_entry(vcpu, force_immediate_exit);
 
 	svm->vmcb->save.rax = vcpu->arch.regs[VCPU_REGS_RAX];
 	svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 83843379813e..88659de4d2a7 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -15,20 +15,23 @@
  * Tracepoint for guest mode entry.
  */
 TRACE_EVENT(kvm_entry,
-	TP_PROTO(struct kvm_vcpu *vcpu),
-	TP_ARGS(vcpu),
+	TP_PROTO(struct kvm_vcpu *vcpu, bool force_immediate_exit),
+	TP_ARGS(vcpu, force_immediate_exit),
 
 	TP_STRUCT__entry(
 		__field(	unsigned int,	vcpu_id		)
 		__field(	unsigned long,	rip		)
+		__field(	bool,		immediate_exit	)
 	),
 
 	TP_fast_assign(
 		__entry->vcpu_id        = vcpu->vcpu_id;
 		__entry->rip		= kvm_rip_read(vcpu);
+		__entry->immediate_exit	= force_immediate_exit;
 	),
 
-	TP_printk("vcpu %u, rip 0x%lx", __entry->vcpu_id, __entry->rip)
+	TP_printk("vcpu %u, rip 0x%lx%s", __entry->vcpu_id, __entry->rip,
+		  __entry->immediate_exit ? "[immediate exit]" : "")
 );
 
 /*
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d30df9b3fe3e..dc0d986e35c3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7270,7 +7270,7 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	guest_state_exit_irqoff();
 }
 
-static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
+static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long cr3, cr4;
@@ -7297,7 +7297,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 		return EXIT_FASTPATH_NONE;
 	}
 
-	trace_kvm_entry(vcpu);
+	trace_kvm_entry(vcpu, force_immediate_exit);
 
 	if (vmx->ple_window_dirty) {
 		vmx->ple_window_dirty = false;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1983947b8965..f1d9828abeba 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10916,7 +10916,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		WARN_ON_ONCE((kvm_vcpu_apicv_activated(vcpu) != kvm_vcpu_apicv_active(vcpu)) &&
 			     (kvm_get_apic_mode(vcpu) != LAPIC_MODE_DISABLED));
 
-		exit_fastpath = static_call(kvm_x86_vcpu_run)(vcpu);
+		exit_fastpath = static_call(kvm_x86_vcpu_run)(vcpu, req_immediate_exit);
 		if (likely(exit_fastpath != EXIT_FASTPATH_REENTER_GUEST))
 			break;
 

base-commit: 1ab097653e4dd8d23272d028a61352c23486fd4a
-- 


