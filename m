Return-Path: <kvm+bounces-36591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A577FA1C020
	for <lists+kvm@lfdr.de>; Sat, 25 Jan 2025 02:18:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 841C218876B0
	for <lists+kvm@lfdr.de>; Sat, 25 Jan 2025 01:18:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A1D61E98F4;
	Sat, 25 Jan 2025 01:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZGpMDFlW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D58710FD
	for <kvm@vger.kernel.org>; Sat, 25 Jan 2025 01:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737767920; cv=none; b=AuI2bd1SktnWXThp+4B5rxCiKciL2vYdS6fHK0WhX6QdPN/yqw1WXfxJafcf8ZANJDw2iWMtOQ6JwpqhM4VVvlLqw1D5soePiwvcOcoBNx5iiMLmdi3Vye89qDtMhKQyRnaFJO36kiXpeh3ZFfHK6BMg11Ty+KUGitf43oNXzfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737767920; c=relaxed/simple;
	bh=kTyZpUOjLb0SObEgbHLmlKy09EyqncEjlPMUuOrAgqw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=NbhJp5yvx4NHKzfaRi1VXHNdPFKNnhZphKsVTJJ/STgbKwXFc7q2/qQM67GH0yTOxFjhjLVEGX+G8NZvrPQCWOo8SWi3mSbR0A0+1JAasSAN0XHdmmbrj/pA5S1XSDYlOwF6ryOgJqtFDLx9QGYisudoXSzZusQvUUGhKkP2+fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZGpMDFlW; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f129f7717fso5446246a91.0
        for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 17:18:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737767918; x=1738372718; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yOr7WnOiI7mRkUyTcSEnbQ/I5tx4nKap+abjP5vrBfs=;
        b=ZGpMDFlWtprdXulD2nAUud6GXiNRO8l+3Uqt1AgDq4naAAcm/jJWVlTLK+9sw+xQC+
         6dL7Ql/NdJkSMSTkkb+hO84Oz3oFdNgoOsNwo0n3CgRIfaKmroaDZVnWDumHb3YGHMGh
         wRyjwaz6vJXytNKv59sqIPvRoP3JZPEarCm2IwBIQCr/k4qG19fMdpWSeV1wU+2dlWbk
         bbeOagDJ7hHh7UJpnShO+GLp5EmsR0ZZ9H3VlkeKIxdAts0BtcvGc+HQavbuMuocuyNV
         rTvDX4njGGFJZJv4WcdUOj19kPZic8Xfl8QHu/ZFm7C77elqVRV/hvtMYUxsaLHcvpIc
         fMdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737767918; x=1738372718;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yOr7WnOiI7mRkUyTcSEnbQ/I5tx4nKap+abjP5vrBfs=;
        b=e3ALg8zw+AxOM7cKXaqpdZGy4erhksyXERTygXIqEfS9omizS+NJfzGsx1UlB+dEYs
         ZRO+8IHXKOpmB8RYeAFShuK9wmcQ/Cv4KlIMBtgg3Amy+AG1yysbu3mvVaLhIclxgr7f
         QvBUSQesp6qW/EPLf4DOJCe9te6j6QBQ8CkLv6aIUl+ohs5MXNH4JiI+Vkbfdm+rssMS
         nYK2kR4AjBZ5UzKF+s3ebeTxZHAHR4v+C4Babk8f5IQaT10uF3hHhPQKmlk0BN+k6u3Q
         k5uJ1ehTdsGFcVDbZGEvqbkD4RDolSTA5gO3Aq/gH4lOWrlyF1mwCeGvy5As3az0VfNR
         alPQ==
X-Gm-Message-State: AOJu0YwwuY27JRDZTjvelgHjep6ZgsWLizgKFZCUKbkLjqBPu4OMzDRu
	pcKiOIJD4YHDK1eJcXBLpvGnlNRAeiwt/yKk5psnTYRNJdxq4y7qmgXD1pyt1pgrCqLiavImJ7r
	hfw==
X-Google-Smtp-Source: AGHT+IEBQ2Fg1OCDOF1ewkMFd3vlU3FegN8kBAnjPHwgssXkhupl08W4VHC/rn9/M/COXBE6hfeFRDsDWoo=
X-Received: from pfbcu10.prod.google.com ([2002:a05:6a00:448a:b0:72d:261f:af23])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:13a0:b0:72d:9ec5:922
 with SMTP id d2e1a72fcca58-72dafbf04f5mr48393311b3a.24.1737767917663; Fri, 24
 Jan 2025 17:18:37 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 24 Jan 2025 17:18:33 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.262.g85cc9f2d1e-goog
Message-ID: <20250125011833.3644371-1-seanjc@google.com>
Subject: [PATCH] KVM: x86: Load DR6 with guest value only before entering
 .vcpu_run() loop
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	John Stultz <jstultz@google.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Move the conditional loading of hardware DR6 with the guest's DR6 value
out of the core .vcpu_run() loop to fix a bug where KVM can load hardware
with a stale vcpu->arch.dr6.

When the guest accesses a DR and host userspace isn't debugging the guest,
KVM disables DR interception and loads the guest's values into hardware on
VM-Enter and saves them on VM-Exit.  This allows the guest to access DRs
at will, e.g. so that a sequence of DR accesses to configure a breakpoint
only generates one VM-Exit.

For DR0-DR3, the logic/behavior is identical between VMX and SVM, and also
identical between KVM_DEBUGREG_BP_ENABLED (userspace debugging the guest)
and KVM_DEBUGREG_WONT_EXIT (guest using DRs), and so KVM handles loading
DR0-DR3 in common code, _outside_ of the core kvm_x86_ops.vcpu_run() loop.

But for DR6, the guest's value doesn't need to be loaded into hardware for
KVM_DEBUGREG_BP_ENABLED, and SVM provides a dedicated VMCB field whereas
VMX requires software to manually load the guest value, and so loading the
guest's value into DR6 is handled by {svm,vmx}_vcpu_run(), i.e. is done
_inside_ the core run loop.

Unfortunately, saving the guest values on VM-Exit is initiated by common
x86, again outside of the core run loop.  If the guest modifies DR6 (in
hardware, when DR interception is disabled), and then the next VM-Exit is
a fastpath VM-Exit, KVM will reload hardware DR6 with vcpu->arch.dr6 and
clobber the guest's actual value.

The bug shows up primarily with nested VMX because KVM handles the VMX
preemption timer in the fastpath, and the window between hardware DR6
being modified (in guest context) and DR6 being read by guest software is
orders of magnitude larger in a nested setup.  E.g. in non-nested, the
VMX preemption timer would need to fire precisely between #DB injection
and the #DB handler's read of DR6, whereas with a KVM-on-KVM setup, the
window where hardware DR6 is "dirty" extends all the way from L1 writing
DR6 to VMRESUME (in L1).

    L1's view:
    ==========
    <L1 disables DR interception>
           CPU 0/KVM-7289    [023] d....  2925.640961: kvm_entry: vcpu 0
 A:  L1 Writes DR6
           CPU 0/KVM-7289    [023] d....  2925.640963: <hack>: Set DRs, DR6 = 0xffff0ff1

 B:        CPU 0/KVM-7289    [023] d....  2925.640967: kvm_exit: vcpu 0 reason EXTERNAL_INTERRUPT intr_info 0x800000ec

 D: L1 reads DR6, arch.dr6 = 0
           CPU 0/KVM-7289    [023] d....  2925.640969: <hack>: Sync DRs, DR6 = 0xffff0ff0

           CPU 0/KVM-7289    [023] d....  2925.640976: kvm_entry: vcpu 0
    L2 reads DR6, L1 disables DR interception
           CPU 0/KVM-7289    [023] d....  2925.640980: kvm_exit: vcpu 0 reason DR_ACCESS info1 0x0000000000000216
           CPU 0/KVM-7289    [023] d....  2925.640983: kvm_entry: vcpu 0

           CPU 0/KVM-7289    [023] d....  2925.640983: <hack>: Set DRs, DR6 = 0xffff0ff0

    L2 detects failure
           CPU 0/KVM-7289    [023] d....  2925.640987: kvm_exit: vcpu 0 reason HLT
    L1 reads DR6 (confirms failure)
           CPU 0/KVM-7289    [023] d....  2925.640990: <hack>: Sync DRs, DR6 = 0xffff0ff0

    L0's view:
    ==========
    L2 reads DR6, arch.dr6 = 0
          CPU 23/KVM-5046    [001] d....  3410.005610: kvm_exit: vcpu 23 reason DR_ACCESS info1 0x0000000000000216
          CPU 23/KVM-5046    [001] .....  3410.005610: kvm_nested_vmexit: vcpu 23 reason DR_ACCESS info1 0x0000000000000216

    L2 => L1 nested VM-Exit
          CPU 23/KVM-5046    [001] .....  3410.005610: kvm_nested_vmexit_inject: reason: DR_ACCESS ext_inf1: 0x0000000000000216

          CPU 23/KVM-5046    [001] d....  3410.005610: kvm_entry: vcpu 23
          CPU 23/KVM-5046    [001] d....  3410.005611: kvm_exit: vcpu 23 reason VMREAD
          CPU 23/KVM-5046    [001] d....  3410.005611: kvm_entry: vcpu 23
          CPU 23/KVM-5046    [001] d....  3410.005612: kvm_exit: vcpu 23 reason VMREAD
          CPU 23/KVM-5046    [001] d....  3410.005612: kvm_entry: vcpu 23

    L1 writes DR7, L0 disables DR interception
          CPU 23/KVM-5046    [001] d....  3410.005612: kvm_exit: vcpu 23 reason DR_ACCESS info1 0x0000000000000007
          CPU 23/KVM-5046    [001] d....  3410.005613: kvm_entry: vcpu 23

    L0 writes DR6 = 0 (arch.dr6)
          CPU 23/KVM-5046    [001] d....  3410.005613: <hack>: Set DRs, DR6 = 0xffff0ff0

 A: <L1 writes DR6 = 1, no interception, arch.dr6 is still '0'>

 B:       CPU 23/KVM-5046    [001] d....  3410.005614: kvm_exit: vcpu 23 reason PREEMPTION_TIMER
          CPU 23/KVM-5046    [001] d....  3410.005614: kvm_entry: vcpu 23

 C: L0 writes DR6 = 0 (arch.dr6)
          CPU 23/KVM-5046    [001] d....  3410.005614: <hack>: Set DRs, DR6 = 0xffff0ff0

    L1 => L2 nested VM-Enter
          CPU 23/KVM-5046    [001] d....  3410.005616: kvm_exit: vcpu 23 reason VMRESUME

    L0 reads DR6, arch.dr6 = 0

Reported-by: John Stultz <jstultz@google.com>
Closes: https://lkml.kernel.org/r/CANDhNCq5_F3HfFYABqFGCA1bPd_%2BxgNj-iDQhH4tDk%2Bwi8iZZg%40mail.gmail.com
Fixes: 375e28ffc0cf ("KVM: X86: Set host DR6 only on VMX and for KVM_DEBUGREG_WONT_EXIT")
Fixes: d67668e9dd76 ("KVM: x86, SVM: isolate vcpu->arch.dr6 from vmcb->save.dr6")
Cc: stable@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>
Tested-by: John Stultz <jstultz@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/svm/svm.c             | 13 ++++++-------
 arch/x86/kvm/vmx/main.c            |  1 +
 arch/x86/kvm/vmx/vmx.c             | 10 ++++++----
 arch/x86/kvm/vmx/x86_ops.h         |  1 +
 arch/x86/kvm/x86.c                 |  3 +++
 7 files changed, 19 insertions(+), 11 deletions(-)

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
index 7640a84e554a..a713c803a3a3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1991,11 +1991,11 @@ static void new_asid(struct vcpu_svm *svm, struct svm_cpu_data *sd)
 	svm->asid = sd->next_asid++;
 }
 
-static void svm_set_dr6(struct vcpu_svm *svm, unsigned long value)
+static void svm_set_dr6(struct kvm_vcpu *vcpu, unsigned long value)
 {
-	struct vmcb *vmcb = svm->vmcb;
+	struct vmcb *vmcb = to_svm(vcpu)->vmcb;
 
-	if (svm->vcpu.arch.guest_state_protected)
+	if (vcpu->arch.guest_state_protected)
 		return;
 
 	if (unlikely(value != vmcb->save.dr6)) {
@@ -4247,10 +4247,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
 	 * Run with all-zero DR6 unless needed, so that we can get the exact cause
 	 * of a #DB.
 	 */
-	if (unlikely(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT))
-		svm_set_dr6(svm, vcpu->arch.dr6);
-	else
-		svm_set_dr6(svm, DR6_ACTIVE_LOW);
+	if (likely(!(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)))
+		svm_set_dr6(vcpu, DR6_ACTIVE_LOW);
 
 	clgi();
 	kvm_load_guest_xsave_state(vcpu);
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
2.48.1.262.g85cc9f2d1e-goog


