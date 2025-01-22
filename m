Return-Path: <kvm+bounces-36295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 359D5A19A08
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 21:55:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 083123ABF16
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 20:55:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF1DA1C4A02;
	Wed, 22 Jan 2025 20:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="z7exzJJU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FB51EB2F
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 20:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737579313; cv=none; b=gVS4hS1ajdG9iBz/EULjGat8DA1X0WdLP1aZUZfaK2ODEMP4xZfeWzY8+Whxj9rv6h/82jBCaOFdaZWWqDaGD9wMHV0/aDYfQFyVHRjUJJaSHZ9a8gvNoR5dQaFkwn/zpZbzcR07aW+8NsrOV442grSt+ePO4rScqZBd1BawB0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737579313; c=relaxed/simple;
	bh=3h3N+thWUz1pkzLzeAz5isHKmM/Ttc+lxkNISO+h4UQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=H35BDEwZMVGIX7/hfZNPDUJuAjVkVYXVORUKFRpcm+ZUL/b1VlwS1CkvDqgbzHdi5NH6gVThT+4xAnriFtl3kzDRoiigvOOQ8nXMc24Asv6X0CnyHzCiL5d/val1Wy56YR1Kb/sKURagE/gKG5M+BOkWvnRAfQCAwOAsL6E4w8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=z7exzJJU; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-21650d4612eso2800915ad.2
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 12:55:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737579311; x=1738184111; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=13Q9L8DMLkADM4nQgbrPccwfoVAD2PZqhe+UEXI0qqo=;
        b=z7exzJJUUkNvFumhsQXnQSjRllRRK2chQ4F6gZ7rxzAwuzxB7Atp5EIah925ntrxVH
         D/WCLvqXCP1YcTQ57H+ZkrV4TEz4ntUvp33fw/wUApDj/H1xXVQzAKyxYdDCPl+oTpRs
         ooeAuWko2tYCSfpbIQ7r+K3pHb+KPOYI2y28q/QXklWF5t7daLVMJavEzq0sHi8w+RYK
         FcoMvgNuQzlqEp9+IuPWsqZBFtxjr6vweITyU+w9r+cOo0vsxaGvjX+qRjO2ncw1WLML
         OlJsXi9sHAtEyV8k1yuo/lS6WoUc+gQNZr0Szja+249blYNQwPIS2jchsnudwxBpqNKH
         XlKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737579311; x=1738184111;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=13Q9L8DMLkADM4nQgbrPccwfoVAD2PZqhe+UEXI0qqo=;
        b=ephw0dOiRqYS9L4VN8t5+d5+rRVF5hfdJDKeFiAaa1WBFYKF4aqtuYK4ofwvNbS+3r
         5UCVNK929BMjWTArYD25BOSH8hVQ4xiK0j31gxen7quiR96505rlE7Nw0tEN9viyckJ5
         q9VoYjebZhpBGij2ehRQ+TYKrbqP9HTfdUiJFmATEhNIUJ4hn8ytYAt9CdUOPeAVZ6I0
         wvRymyI0SYE85q2oSQOadmrukdZTe1R6NLXnUuCyWXwj0dUxsverJs+TI/My+g9IICtz
         +H41uEaC8pgNgYELocx6gVZc/cKsM2gsKDX9gOD8zqv8Yu8g+3Cufp/z5WpZNrRxy2so
         HIUg==
X-Forwarded-Encrypted: i=1; AJvYcCX8bOxnzieTrp/11MYrIKZWA3RbIlWFDYtJMR6hnkdzgXrJRAuQm80WMmL1mwSO0GJKc28=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0moaFICpT2Juw+9p8vUv3DHmYEelVdfNq4W2sdMjLbqFKSyt+
	MgGELGCEeDYZoOXyeU7j9iHnaBD5k6WpPPCvkhM9tb+tnplzIM0ZyJwawDwmQaVRDgobqRsmCq4
	VSQ==
X-Google-Smtp-Source: AGHT+IHoxUm5c5aOSnhlh2JD+dtJQYSiny6sYBZ9IAFs1e6x0Wk2ddV1DIgg2UrM59K/k/RY5iGrIhxLCQI=
X-Received: from pfbbv12.prod.google.com ([2002:a05:6a00:414c:b0:724:f17d:ebd7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7f8c:b0:1e3:da8c:1e07
 with SMTP id adf61e73a8af0-1eb2147417emr39938801637.7.1737579310767; Wed, 22
 Jan 2025 12:55:10 -0800 (PST)
Date: Wed, 22 Jan 2025 12:55:09 -0800
In-Reply-To: <CANDhNCq5_F3HfFYABqFGCA1bPd_+xgNj-iDQhH4tDk+wi8iZZg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CANDhNCq5_F3HfFYABqFGCA1bPd_+xgNj-iDQhH4tDk+wi8iZZg@mail.gmail.com>
Message-ID: <Z5FVfe9RwVNr2PGI@google.com>
Subject: Re: BUG: Occasional unexpected DR6 value seen with nested
 virtualization on x86
From: Sean Christopherson <seanjc@google.com>
To: John Stultz <jstultz@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Peter Zijlstra <peterz@infradead.org>, Frederic Weisbecker <fweisbec@gmail.com>, 
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Jim Mattson <jmattson@google.com>, 
	"Alex =?utf-8?Q?Benn=C3=A9e?=" <alex.bennee@linaro.org>, Will Deacon <will@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	LKML <linux-kernel@vger.kernel.org>, kernel-team@android.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Jan 21, 2025, John Stultz wrote:
> For awhile now, when testing Android in our virtualized x86
> environment (cuttlefish), we've seen flakey failures ~1% or less in
> testing with the bionic sys_ptrace.watchpoint_stress test:
> https://android.googlesource.com/platform/bionic/+/refs/heads/main/tests/sys_ptrace_test.cpp#221
> 
> The failure looks like:
> bionic/tests/sys_ptrace_test.cpp:(194) Failure in test
> sys_ptrace.watchpoint_stress
> Expected equality of these values:
>   4
>   siginfo.si_code
>     Which is: 1
> sys_ptrace.watchpoint_stress exited with exitcode 1.
> 
> Basically we expect to get a SIGTRAP with si_code: TRAP_HWBKPT, but
> occasionally we get an si_code of TRAP_BRKPT.

...

> Now, here's where it is odd. I could *not* reproduce the problem on
> bare metal hardware, *nor* could I reproduce the problem in a virtual
> environment.  I can *only* reproduce the problem with nested
> virtualization (running the VM inside a VM).
> 
> I have reproduced this on my intel i12 NUC using the same v6.12 kernel
> on metal + virt + nested environments.  It also reproduced on the NUC
> with v5.15 (metal) + v6.1 (virt) + v6.1(nested).

Huh.  This isn't actually a nested virtualization bug.  It's a flaw in KVM's
fastpath handling.  But hitting it in a non-nested setup is practically impossible
because it requires the "kernel" running the test to have interrupts enabled
(rules out the ptrace test), a source of interrupts (rules out KVM-Unit-Test),
window of a handful of instructions (or a weird guest).

If KVM has disabled DR interception, which occurs when the guest accesses a DR
and host userspace isn't debuggin the guest, KVM loads the guest's DR's before
VM-Enter, and then saves the guest's DRs on VM-Exit (and restores the intercept).

For DR0-DR3, the behavior is identical between VMX and SVM, and also identical
between KVM_DEBUGREG_BP_ENABLED (userspace debugging the guest) and KVM_DEBUGREG_WONT_EXIT
(guest using DRs), and so KVM handles loading DR0-DR3 in common code, _outside_
of the core kvm_x86_ops.vcpu_run() loop.

But for DR6, the guest's value doesn't need to be loaded into hardware for
KVM_DEBUGREG_BP_ENABLED, and SVM provides a dedicated VMCB field, and so on VMX
loading the guest's value into DR6 is handled by vmx_vcpu_run(), i.e. is done
_inside_ the core run loop.

Unfortunately, saving the guest values on VM-Exit is initiated by common x86,
again outside of the core run loop.  If the guest modifies DR6 (in hardware),
and then the next VM-Exit is a fastpath VM-Exit, KVM will reload hardware DR6
with vcpu->arch.dr6 and clobber the guest's actual value.

The bug shows up with nested because KVM handles the VMX preemption timer in the
fastpath.  The sequence (omitting a pile of entry/exits that aren't directly
relevant to the bug) being hit is effectively:

                                       Hardware DR6 Value

KVM:  arch.dr6 = 0xffff0ff0
KVM:  mov arch.dr6, dr6                0xffff0ff0
vCPU: mov 0xffff0ff1, dr6  # VM-Exit
KVM:  disable DR interception
vCPU: mov 0xffff0ff1, dr6              0xffff0ff1
      VMX Preemption Timer # VM-Exit
KVM:  mov arch.dr6, dr6                0xffff0ff0
vCPU: mov dr6, <reg>
  

Amusingly, SVM has the bug even though there's a dedicated VMCB field.  But
because SVM doesn't handle any asynchronous exits that are handled in the fastpath,
hitting the issue would require the vCPU to send an IPI between hardware DR6
being modified (either by software or a #DB) and software reading DR6.

A hack-a-fix hammer would be to orce KVM down the slow path if DR interception
is disabled:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b2d9a16fd4d3..354b50a5838c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10995,7 +10995,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
                if (kvm_lapic_enabled(vcpu))
                        kvm_x86_call(sync_pir_to_irr)(vcpu);
 
-               if (unlikely(kvm_vcpu_exit_request(vcpu))) {
+               if (unlikely(kvm_vcpu_exit_request(vcpu)) ||
+                   (vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)) {
                        exit_fastpath = EXIT_FASTPATH_EXIT_HANDLED;
                        break;
                }


But I'm leaning toward going straight for a more complete fix.  My only hesitation
is adding a dedicated .set_dr6() hook, as there's probably more code in VMX and
SVM that can (should?) be moved out of .vcpu_run(), i.e. we could probably add a
.pre_vcpu_run() hook to handle everything.   However, even if we added a pre-run
hook, I think I'd still prefer to keep the KVM_DEBUGREG_WONT_EXIT logic in one
place (modulo the SVM behavior :-/).

---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/svm/svm.c             |  5 ++---
 arch/x86/kvm/vmx/main.c            |  1 +
 arch/x86/kvm/vmx/vmx.c             | 10 ++++++----
 arch/x86/kvm/vmx/x86_ops.h         |  1 +
 arch/x86/kvm/x86.c                 |  3 +++
 7 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 7b4536ff3834..5459bc48cfd1 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -48,6 +48,7 @@ KVM_X86_OP(set_idt)
 KVM_X86_OP(get_gdt)
 KVM_X86_OP(set_gdt)
 KVM_X86_OP(sync_dirty_debug_regs)
+KVM_X86_OP(set_dr6)
 KVM_X86_OP(set_dr7)
 KVM_X86_OP(cache_reg)
 KVM_X86_OP(get_rflags)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5193c3dfbce1..21d247176858 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1685,6 +1685,7 @@ struct kvm_x86_ops {
 	void (*get_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	void (*set_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	void (*sync_dirty_debug_regs)(struct kvm_vcpu *vcpu);
+	void (*set_dr6)(struct kvm_vcpu *vcpu, unsigned long value);
 	void (*set_dr7)(struct kvm_vcpu *vcpu, unsigned long value);
 	void (*cache_reg)(struct kvm_vcpu *vcpu, enum kvm_reg reg);
 	unsigned long (*get_rflags)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7640a84e554a..9d2033d64cfb 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4247,9 +4247,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
 	 * Run with all-zero DR6 unless needed, so that we can get the exact cause
 	 * of a #DB.
 	 */
-	if (unlikely(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT))
-		svm_set_dr6(svm, vcpu->arch.dr6);
-	else
+	if (likely(!(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)))
 		svm_set_dr6(svm, DR6_ACTIVE_LOW);
 
 	clgi();
@@ -5043,6 +5041,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.set_idt = svm_set_idt,
 	.get_gdt = svm_get_gdt,
 	.set_gdt = svm_set_gdt,
+	.set_dr6 = svm_set_dr6,
 	.set_dr7 = svm_set_dr7,
 	.sync_dirty_debug_regs = svm_sync_dirty_debug_regs,
 	.cache_reg = svm_cache_reg,
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 2427f918e763..43ee9ed11291 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -61,6 +61,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.set_idt = vmx_set_idt,
 	.get_gdt = vmx_get_gdt,
 	.set_gdt = vmx_set_gdt,
+	.set_dr6 = vmx_set_dr6,
 	.set_dr7 = vmx_set_dr7,
 	.sync_dirty_debug_regs = vmx_sync_dirty_debug_regs,
 	.cache_reg = vmx_cache_reg,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f72835e85b6d..6c56d5235f0f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5648,6 +5648,12 @@ void vmx_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
 	set_debugreg(DR6_RESERVED, 6);
 }
 
+void vmx_set_dr6(struct kvm_vcpu *vcpu, unsigned long val)
+{
+	lockdep_assert_irqs_disabled();
+	set_debugreg(vcpu->arch.dr6, 6);
+}
+
 void vmx_set_dr7(struct kvm_vcpu *vcpu, unsigned long val)
 {
 	vmcs_writel(GUEST_DR7, val);
@@ -7417,10 +7423,6 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 		vmx->loaded_vmcs->host_state.cr4 = cr4;
 	}
 
-	/* When KVM_DEBUGREG_WONT_EXIT, dr6 is accessible in guest. */
-	if (unlikely(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT))
-		set_debugreg(vcpu->arch.dr6, 6);
-
 	/* When single-stepping over STI and MOV SS, we must clear the
 	 * corresponding interruptibility bits in the guest state. Otherwise
 	 * vmentry fails as it then expects bit 14 (BS) in pending debug
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index ce3295a67c04..430773a5ef8e 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -73,6 +73,7 @@ void vmx_get_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 void vmx_set_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 void vmx_get_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 void vmx_set_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
+void vmx_set_dr6(struct kvm_vcpu *vcpu, unsigned long val);
 void vmx_set_dr7(struct kvm_vcpu *vcpu, unsigned long val);
 void vmx_sync_dirty_debug_regs(struct kvm_vcpu *vcpu);
 void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b2d9a16fd4d3..9d5d267b4e14 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10971,6 +10971,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		set_debugreg(vcpu->arch.eff_db[1], 1);
 		set_debugreg(vcpu->arch.eff_db[2], 2);
 		set_debugreg(vcpu->arch.eff_db[3], 3);
+		/* When KVM_DEBUGREG_WONT_EXIT, dr6 is accessible in guest. */
+		if (unlikely(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT))
+			kvm_x86_call(set_dr6)(vcpu, vcpu->arch.dr6);
 	} else if (unlikely(hw_breakpoint_active())) {
 		set_debugreg(0, 7);
 	}

base-commit: eb723766b1030a23c38adf2348b7c3d1409d11f0
-- 


