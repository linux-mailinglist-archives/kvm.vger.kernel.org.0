Return-Path: <kvm+bounces-58104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E113EB878F3
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 03:02:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 967B63B742F
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 01:02:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4EC226D4C6;
	Fri, 19 Sep 2025 01:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JoWB6KFZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3AD263F54
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 01:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758243613; cv=none; b=WUM34qq48P92ekIV94+p+L2j/BA81gu+05xIbn836MJ5YP9Vj1LAsXvZ83CkfHw8UyFtfjg05Sy0v9dGI8IGOEyhU33r5SHj2qgYUwzeOEdUSKG6JzQdxqREdvjJwQ3arHuTQVqizUdWS7LZTm3j1qGQGJeIZLxqPBIdvRdVPYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758243613; c=relaxed/simple;
	bh=EAAcphAPmqx0XNYCWxq3+wsF+A2zq9F9El6fEDAJCPk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=deHlsbK6TOQZ5UhS6jDhtJSdAU0b5EpPvXtAI8isHmLxvKE8QyU4zRRJEkkMC0C6uWG5cBoghqYEEsyZH4XFly55upuYc1TMumV1GL3ShsMUbJ4gv4ft9LNZuMX0pz6Vh1K9umZkp2yk0kvAKZ72UtMFUowhlfAqh8M5waeZCKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JoWB6KFZ; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-77429fb6ce4so1619919b3a.2
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 18:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758243611; x=1758848411; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=nC4lqy1VsaE/VYQOJkDaZdGDXi2NadHlztaUIfGpZG8=;
        b=JoWB6KFZy76/YcxDfSoX6uuPGiib7+tfb8Z01nThshonBR6eveH0GtQcbYipWlBKP5
         vUjbcXiW6FM1j7UOfH3NriKlI7ETrTQqSW0xhgRK8k0tF0dNiRmXnFRAIMpb/Ny/p49b
         mahasYf8aYhH9E8e5MA00AGkEQMHzApHWPHTdLK43SPL3IphGdb8JULigLMSi7lLdzBI
         HyGbzXwtkrPmTOl6zoEoJFbXoGVYxQvVMXOniq3p+qi56b90kS0n8Ilv3Xpi3eLclhy5
         rJhsTG6mNK8KycnhvFUvV5E9Va0ofC6jyf/bqH7titkHJwKbCnOmBAvnXDJzkCoNVvt9
         eqZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758243611; x=1758848411;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nC4lqy1VsaE/VYQOJkDaZdGDXi2NadHlztaUIfGpZG8=;
        b=WtPNTxwCTJuiYHCp1qNkCuR5bQMX4D8IDDNmDQ/o+DwIBQ+Byg3YqRvOrbe+YzorMa
         MnNnIfUXOyGMAPbZqT07l1Pums04ltoguP49AVcD7AKgEmiO7DyN2WmxzKjSyqz4CLkg
         zmhgKwuWa1eH6VQWf+3Sp8dMfJUFtjdGC81OS+l99nYvfz5L9VUR0LPgTXMZ2CfXEXE5
         v6rLvxO9ZQIHbHvazsdxhAzqWYAt8EJkkGNfS15cY+NDViRyy92o5P7XT4k/QThbDWKF
         8BwF7gvvSwsT2qN1jNyN+8JASj50VMMwenW6TQii0psAkWq3B0T22W+WG3pkm64onhwo
         PTxA==
X-Gm-Message-State: AOJu0YxLAQaM6zh8RxWp+RNcN7PLS6F/idvcF0IkBnt5zc9W2/YzA6/1
	kKdUCLThC49bVJ2hFpU2B1LUHuQQZGXbbF4EqW+MjepXQgMVe7MHfpyE4lKlJpulog1LfESEu8L
	RRsNW0g==
X-Google-Smtp-Source: AGHT+IEWT+b51PWDhVROnjj4MNHmNfWEi53pHuIcr7HOX8gmTcp1M+N2doO80KvMuo3RHEvn5affyawMJrw=
X-Received: from pgdy24.prod.google.com ([2002:a65:6418:0:b0:b55:1604:9969])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3287:b0:263:b547:d0a6
 with SMTP id adf61e73a8af0-2926ec18aa0mr2573153637.36.1758243610714; Thu, 18
 Sep 2025 18:00:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 18 Sep 2025 17:59:54 -0700
In-Reply-To: <20250919005955.1366256-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919005955.1366256-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919005955.1366256-9-seanjc@google.com>
Subject: [PATCH 8/9] KVM: nVMX: Remove support for "early" consistency checks
 via hardware
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Remove nested_early_check and all associated code, as it's quite obviously
not being used or tested (it's been broken for 4+ years without a single
bug report).  More importantly, KVM's software-based consistency checks
have matured since the option to do hardware-based checks was added; KVM
appears to be missing only _one_ consistency check, on vTPR.  And even
*more* importantly, that consistency check can't be prevented by an early
hardware check due to L1 being able to modify the virtual APIC at any
time, i.e. there's an inherent TOCTOU flaw that could cause KVM to "miss"
a consistency check VM-Fail, regardless of whether the check is performed
by software or by hardware.

In other words, KVM _must_ be able to unwind from a late VM-Fail (which
was a big motivation for doing early checks).  I.e. now that KVM provides
(almost) all necessary consistency checks, what's really needed is a way
to detect missing checks in KVM, not a way to avoid having to unwind from
a late VM-Fail.  And that can be done much more simply, e.g. by an simple
module param to guard a WARN (which, sadly, must be off-by-default to
avoid splats due to the aforementioned TOCTOU issue).

For all intents and purposes, this reverts commit 52017608da33 ("KVM:
nVMX: add option to perform early consistency checks via H/W").

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 130 ++++----------------------------------
 1 file changed, 12 insertions(+), 118 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index e3a94bf6d269..a1ffaccf317d 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -23,9 +23,6 @@
 static bool __read_mostly enable_shadow_vmcs = 1;
 module_param_named(enable_shadow_vmcs, enable_shadow_vmcs, bool, S_IRUGO);
 
-static bool __read_mostly nested_early_check = 0;
-module_param(nested_early_check, bool, S_IRUGO);
-
 #define CC KVM_NESTED_VMENTER_CONSISTENCY_CHECK
 
 /*
@@ -2280,13 +2277,6 @@ static void prepare_vmcs02_constant_state(struct vcpu_vmx *vmx)
 		return;
 	vmx->nested.vmcs02_initialized = true;
 
-	/*
-	 * If early consistency checks are enabled, stuff the EPT Pointer with
-	 * a dummy *legal* value to avoid false positives on bad control state.
-	 */
-	if (enable_ept && nested_early_check)
-		vmcs_write64(EPT_POINTER, VMX_EPTP_MT_WB | VMX_EPTP_PWL_4);
-
 	if (vmx->ve_info)
 		vmcs_write64(VE_INFORMATION_ADDRESS, __pa(vmx->ve_info));
 
@@ -2352,13 +2342,6 @@ static void prepare_vmcs02_early_rare(struct vcpu_vmx *vmx,
 		else
 			vmcs_write16(VIRTUAL_PROCESSOR_ID, vmx->vpid);
 	}
-
-	if (kvm_caps.has_tsc_control && nested_early_check) {
-		if (nested_cpu_has2(vmcs12, SECONDARY_EXEC_TSC_SCALING))
-			vmcs_write64(TSC_MULTIPLIER, vmcs12->tsc_multiplier);
-		else
-			vmcs_write64(TSC_MULTIPLIER, 1);
-	}
 }
 
 static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs01,
@@ -3229,84 +3212,6 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	unsigned long cr3, cr4;
-	bool vm_fail;
-
-	if (!nested_early_check)
-		return 0;
-
-	if (vmx->msr_autoload.host.nr)
-		vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, 0);
-	if (vmx->msr_autoload.guest.nr)
-		vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, 0);
-
-	preempt_disable();
-
-	vmx_prepare_switch_to_guest(vcpu);
-
-	/*
-	 * Induce a consistency check VMExit by clearing bit 1 in GUEST_RFLAGS,
-	 * which is reserved to '1' by hardware.  GUEST_RFLAGS is guaranteed to
-	 * be written (by prepare_vmcs02()) before the "real" VMEnter, i.e.
-	 * there is no need to preserve other bits or save/restore the field.
-	 */
-	vmcs_writel(GUEST_RFLAGS, 0);
-
-	cr3 = __get_current_cr3_fast();
-	if (unlikely(cr3 != vmx->loaded_vmcs->host_state.cr3)) {
-		vmcs_writel(HOST_CR3, cr3);
-		vmx->loaded_vmcs->host_state.cr3 = cr3;
-	}
-
-	cr4 = cr4_read_shadow();
-	if (unlikely(cr4 != vmx->loaded_vmcs->host_state.cr4)) {
-		vmcs_writel(HOST_CR4, cr4);
-		vmx->loaded_vmcs->host_state.cr4 = cr4;
-	}
-
-	vm_fail = __vmx_vcpu_run(vmx, (unsigned long *)&vcpu->arch.regs,
-				 __vmx_vcpu_run_flags(vmx));
-
-	if (vmx->msr_autoload.host.nr)
-		vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
-	if (vmx->msr_autoload.guest.nr)
-		vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr);
-
-	if (vm_fail) {
-		u32 error = vmcs_read32(VM_INSTRUCTION_ERROR);
-
-		preempt_enable();
-
-		trace_kvm_nested_vmenter_failed(
-			"early hardware check VM-instruction error: ", error);
-		WARN_ON_ONCE(error != VMXERR_ENTRY_INVALID_CONTROL_FIELD);
-		return 1;
-	}
-
-	/*
-	 * VMExit clears RFLAGS.IF and DR7, even on a consistency check.
-	 */
-	if (hw_breakpoint_active())
-		set_debugreg(__this_cpu_read(cpu_dr7), 7);
-	local_irq_enable();
-	preempt_enable();
-
-	/*
-	 * A non-failing VMEntry means we somehow entered guest mode with
-	 * an illegal RIP, and that's just the tip of the iceberg.  There
-	 * is no telling what memory has been modified or what state has
-	 * been exposed to unknown code.  Hitting this all but guarantees
-	 * a (very critical) hardware issue.
-	 */
-	WARN_ON(!(vmcs_read32(VM_EXIT_REASON) &
-		VMX_EXIT_REASONS_FAILED_VMENTRY));
-
-	return 0;
-}
-
 #ifdef CONFIG_KVM_HYPERV
 static bool nested_get_evmcs_page(struct kvm_vcpu *vcpu)
 {
@@ -3557,22 +3462,18 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 		vmx->nested.pre_vmenter_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
 
 	/*
-	 * Overwrite vmcs01.GUEST_CR3 with L1's CR3 if EPT is disabled *and*
-	 * nested early checks are disabled.  In the event of a "late" VM-Fail,
-	 * i.e. a VM-Fail detected by hardware but not KVM, KVM must unwind its
-	 * software model to the pre-VMEntry host state.  When EPT is disabled,
-	 * GUEST_CR3 holds KVM's shadow CR3, not L1's "real" CR3, which causes
-	 * nested_vmx_restore_host_state() to corrupt vcpu->arch.cr3.  Stuffing
-	 * vmcs01.GUEST_CR3 results in the unwind naturally setting arch.cr3 to
-	 * the correct value.  Smashing vmcs01.GUEST_CR3 is safe because nested
-	 * VM-Exits, and the unwind, reset KVM's MMU, i.e. vmcs01.GUEST_CR3 is
-	 * guaranteed to be overwritten with a shadow CR3 prior to re-entering
-	 * L1.  Don't stuff vmcs01.GUEST_CR3 when using nested early checks as
-	 * KVM modifies vcpu->arch.cr3 if and only if the early hardware checks
-	 * pass, and early VM-Fails do not reset KVM's MMU, i.e. the VM-Fail
-	 * path would need to manually save/restore vmcs01.GUEST_CR3.
+	 * Overwrite vmcs01.GUEST_CR3 with L1's CR3 if EPT is disabled.  In the
+	 * event of a "late" VM-Fail, i.e. a VM-Fail detected by hardware but
+	 * not KVM, KVM must unwind its software model to the pre-VM-Entry host
+	 * state.  When EPT is disabled, GUEST_CR3 holds KVM's shadow CR3, not
+	 * L1's "real" CR3, which causes nested_vmx_restore_host_state() to
+	 * corrupt vcpu->arch.cr3.  Stuffing vmcs01.GUEST_CR3 results in the
+	 * unwind naturally setting arch.cr3 to the correct value.  Smashing
+	 * vmcs01.GUEST_CR3 is safe because nested VM-Exits, and the unwind,
+	 * reset KVM's MMU, i.e. vmcs01.GUEST_CR3 is guaranteed to be
+	 * overwritten with a shadow CR3 prior to re-entering L1.
 	 */
-	if (!enable_ept && !nested_early_check)
+	if (!enable_ept)
 		vmcs_writel(GUEST_CR3, vcpu->arch.cr3);
 
 	vmx_switch_vmcs(vcpu, &vmx->nested.vmcs02);
@@ -3585,11 +3486,6 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 			return NVMX_VMENTRY_KVM_INTERNAL_ERROR;
 		}
 
-		if (nested_vmx_check_vmentry_hw(vcpu)) {
-			vmx_switch_vmcs(vcpu, &vmx->vmcs01);
-			return NVMX_VMENTRY_VMFAIL;
-		}
-
 		if (nested_vmx_check_guest_state(vcpu, vmcs12,
 						 &entry_failure_code)) {
 			exit_reason.basic = EXIT_REASON_INVALID_STATE;
@@ -5038,12 +4934,10 @@ void __nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 		/*
 		 * The only expected VM-instruction error is "VM entry with
 		 * invalid control field(s)." Anything else indicates a
-		 * problem with L0.  And we should never get here with a
-		 * VMFail of any type if early consistency checks are enabled.
+		 * problem with L0.
 		 */
 		WARN_ON_ONCE(vmcs_read32(VM_INSTRUCTION_ERROR) !=
 			     VMXERR_ENTRY_INVALID_CONTROL_FIELD);
-		WARN_ON_ONCE(nested_early_check);
 	}
 
 	/*
-- 
2.51.0.470.ga7dc726c21-goog


