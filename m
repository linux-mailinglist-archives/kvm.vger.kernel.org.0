Return-Path: <kvm+bounces-48903-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB616AD4651
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 01:03:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E99E3A7E3E
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 23:02:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BA2C2DFA54;
	Tue, 10 Jun 2025 22:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3ODqkFCJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B382DCC1D
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 22:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749596295; cv=none; b=hwLll+6HT6sQgAIC8lGLkpCcrTZVSdk1IqLdYOIsJM/nEO+9EBYlvcLNT6fFuJuCxH3DhLD59ZXnGNtUcUwDk/RC73ohI86DVd2VdIy5+IoC1tRn6PhUwXheFBMNpzNo0tYCCtueAbi7Q7a3wzxPRObQDAD9LfNhCcl3NvFjzrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749596295; c=relaxed/simple;
	bh=S7VHXpHQvfNQYfaDgLUFSn0xAQvLg98Kt013BPz6oZk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WR88M2d4qNfQphON2ITye1ghl7tHE7zFpTsQF+oVROKQWVqn9ovboM1iSPRtWHKh8m4WGWuPjRSyAOpaePPuiGfUOM1atDjirw4fXKTbR1W5cD2wO8GRjWsBtJLsQne7GSlH/yZB6LOWJn1hBCKtwyqO099vYO284xViohXbBAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3ODqkFCJ; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2354ba59eb6so93831825ad.1
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 15:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749596293; x=1750201093; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=VEGjIN1nEHAhSdqU9D7mGkjJMNWjphFiAtoH3EI9Y/4=;
        b=3ODqkFCJYN40T7gBqf1LiSvbCa8A/7Zj0aOJdfZryZEQXkBexQgaAu+Pu4JFgGIyzs
         5XprbX9QEHeTb67Sq/FUsxiT/82KVY/1m6ifY2oLswyXQ2uJbBmCzMHvStZCPphZ8Wtj
         GVGh9ATI9MbEZpKJN5AFOgWs6LiI9XiTScD+2K1fGXJ2H51/gRIewFl4L0kn6yKE5EOh
         gi3rYLpJfHwcHtinto3KqJQX+1UWZgU5ledl1yq3obBvUx3ng67MSu6/ybOLIgviYw8c
         4wysvweKCEBf4BVhv8fNZsq+kPAahSGYphlwVMCb7ECuTqHdYLULZj2HLiahwC+bo6vT
         E55w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749596293; x=1750201093;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VEGjIN1nEHAhSdqU9D7mGkjJMNWjphFiAtoH3EI9Y/4=;
        b=KrGLHH/KS5kn4q3DsvMiH5muG6DELxeyBXrzvfNsSVG24NVHtP2E2r3cz7C8OOFSPe
         HS/28Nuu9b0gKOuj3oCHhnfg4ph/sp8ca6BtDpPX2WQe2SMDBSAHT/6eoWeXMOYQwfaY
         yys3ENjd4E+L2jdqyMNe6xhI9sxShmGc4q5+6P95NRIwcyd3+E/to6CzCMiYEQadfAkd
         GIsu5g74ugTfB8NzPRNnjgaxU/dIsdKBIjdbUJp61Bfd/OGJPwwj8lzAftdUBEapVSjR
         5xiRpTEtdfFHxcFGDCttTTXbqhtmTJxkiy91XU/FA1wT6AAMjKNMiU02yHHyXtbCkDfS
         EyKw==
X-Gm-Message-State: AOJu0YxCTmeXDmfM4MPpMphbYNu5xqrm5f92WXPZ100HEWe44Dn8it5Z
	0j8Z+cS+3k7MC7/62MWUUrEDFZr/SZjbHEQa/yLP6dfxuXdVRNeGB2z6/zvNHgAChkHsW2E7eGy
	FDyY/mw==
X-Google-Smtp-Source: AGHT+IHUHfoKuxPlsPDHezLiK33AMSNM/yUxePZMR8daq/kIDIvYtI5298B5zplSwVgT8OrPc0xnrtN7d6I=
X-Received: from pjyp11.prod.google.com ([2002:a17:90a:e70b:b0:311:ff0f:6962])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ec91:b0:234:bef7:e227
 with SMTP id d9443c01a7336-236426208c7mr6413385ad.18.1749596292809; Tue, 10
 Jun 2025 15:58:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 15:57:24 -0700
In-Reply-To: <20250610225737.156318-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610225737.156318-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610225737.156318-20-seanjc@google.com>
Subject: [PATCH v2 19/32] KVM: SVM: Manually recalc all MSR intercepts on
 userspace MSR filter change
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Francesco Lavra <francescolavra.fl@gmail.com>, 
	Manali Shukla <Manali.Shukla@amd.com>
Content-Type: text/plain; charset="UTF-8"

On a userspace MSR filter change, recalculate all MSR intercepts using the
filter-agnostic logic instead of maintaining a "shadow copy" of KVM's
desired intercepts.  The shadow bitmaps add yet another point of failure,
are confusing (e.g. what does "handled specially" mean!?!?), an eyesore,
and a maintenance burden.

Given that KVM *must* be able to recalculate the correct intercepts at any
given time, and that MSR filter updates are not hot paths, there is zero
benefit to maintaining the shadow bitmaps.

Opportunistically switch from boot_cpu_has() to cpu_feature_enabled() as
appropriate.

Link: https://lore.kernel.org/all/aCdPbZiYmtni4Bjs@google.com
Link: https://lore.kernel.org/all/20241126180253.GAZ0YNTdXH1UGeqsu6@fat_crate.local
Cc: Francesco Lavra <francescolavra.fl@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c |  16 +-
 arch/x86/kvm/svm/svm.c | 373 +++++++++++------------------------------
 arch/x86/kvm/svm/svm.h |  10 +-
 3 files changed, 108 insertions(+), 291 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a020aa755a7e..6282c2930cda 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4347,9 +4347,12 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
 				    count, in);
 }
 
-static void sev_es_vcpu_after_set_cpuid(struct vcpu_svm *svm)
+void sev_es_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu *vcpu = &svm->vcpu;
+	/* Clear intercepts on MSRs that are context switched by hardware. */
+	svm_disable_intercept_for_msr(vcpu, MSR_AMD64_SEV_ES_GHCB, MSR_TYPE_RW);
+	svm_disable_intercept_for_msr(vcpu, MSR_EFER, MSR_TYPE_RW);
+	svm_disable_intercept_for_msr(vcpu, MSR_IA32_CR_PAT, MSR_TYPE_RW);
 
 	if (boot_cpu_has(X86_FEATURE_V_TSC_AUX))
 		svm_set_intercept_for_msr(vcpu, MSR_TSC_AUX, MSR_TYPE_RW,
@@ -4384,16 +4387,12 @@ void sev_vcpu_after_set_cpuid(struct vcpu_svm *svm)
 	best = kvm_find_cpuid_entry(vcpu, 0x8000001F);
 	if (best)
 		vcpu->arch.reserved_gpa_bits &= ~(1UL << (best->ebx & 0x3f));
-
-	if (sev_es_guest(svm->vcpu.kvm))
-		sev_es_vcpu_after_set_cpuid(svm);
 }
 
 static void sev_es_init_vmcb(struct vcpu_svm *svm)
 {
 	struct kvm_sev_info *sev = to_kvm_sev_info(svm->vcpu.kvm);
 	struct vmcb *vmcb = svm->vmcb01.ptr;
-	struct kvm_vcpu *vcpu = &svm->vcpu;
 
 	svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_SEV_ES_ENABLE;
 
@@ -4447,11 +4446,6 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 
 	/* Can't intercept XSETBV, HV can't modify XCR0 directly */
 	svm_clr_intercept(svm, INTERCEPT_XSETBV);
-
-	/* Clear intercepts on MSRs that are context switched by hardware. */
-	svm_disable_intercept_for_msr(vcpu, MSR_AMD64_SEV_ES_GHCB, MSR_TYPE_RW);
-	svm_disable_intercept_for_msr(vcpu, MSR_EFER, MSR_TYPE_RW);
-	svm_disable_intercept_for_msr(vcpu, MSR_IA32_CR_PAT, MSR_TYPE_RW);
 }
 
 void sev_init_vmcb(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 900a1303e0e7..de3d59c71229 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -71,8 +71,6 @@ MODULE_DEVICE_TABLE(x86cpu, svm_cpu_id);
 
 static bool erratum_383_found __read_mostly;
 
-u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
-
 /*
  * Set osvw_len to higher value when updated Revision Guides
  * are published and we know what the new status bits are
@@ -81,70 +79,6 @@ static uint64_t osvw_len = 4, osvw_status;
 
 static DEFINE_PER_CPU(u64, current_tsc_ratio);
 
-static const u32 direct_access_msrs[] = {
-	MSR_STAR,
-	MSR_IA32_SYSENTER_CS,
-	MSR_IA32_SYSENTER_EIP,
-	MSR_IA32_SYSENTER_ESP,
-#ifdef CONFIG_X86_64
-	MSR_GS_BASE,
-	MSR_FS_BASE,
-	MSR_KERNEL_GS_BASE,
-	MSR_LSTAR,
-	MSR_CSTAR,
-	MSR_SYSCALL_MASK,
-#endif
-	MSR_IA32_SPEC_CTRL,
-	MSR_IA32_PRED_CMD,
-	MSR_IA32_FLUSH_CMD,
-	MSR_IA32_DEBUGCTLMSR,
-	MSR_IA32_LASTBRANCHFROMIP,
-	MSR_IA32_LASTBRANCHTOIP,
-	MSR_IA32_LASTINTFROMIP,
-	MSR_IA32_LASTINTTOIP,
-	MSR_IA32_XSS,
-	MSR_EFER,
-	MSR_IA32_CR_PAT,
-	MSR_AMD64_SEV_ES_GHCB,
-	MSR_TSC_AUX,
-	X2APIC_MSR(APIC_ID),
-	X2APIC_MSR(APIC_LVR),
-	X2APIC_MSR(APIC_TASKPRI),
-	X2APIC_MSR(APIC_ARBPRI),
-	X2APIC_MSR(APIC_PROCPRI),
-	X2APIC_MSR(APIC_EOI),
-	X2APIC_MSR(APIC_RRR),
-	X2APIC_MSR(APIC_LDR),
-	X2APIC_MSR(APIC_DFR),
-	X2APIC_MSR(APIC_SPIV),
-	X2APIC_MSR(APIC_ISR),
-	X2APIC_MSR(APIC_TMR),
-	X2APIC_MSR(APIC_IRR),
-	X2APIC_MSR(APIC_ESR),
-	X2APIC_MSR(APIC_ICR),
-	X2APIC_MSR(APIC_ICR2),
-
-	/*
-	 * Note:
-	 * AMD does not virtualize APIC TSC-deadline timer mode, but it is
-	 * emulated by KVM. When setting APIC LVTT (0x832) register bit 18,
-	 * the AVIC hardware would generate GP fault. Therefore, always
-	 * intercept the MSR 0x832, and do not setup direct_access_msr.
-	 */
-	X2APIC_MSR(APIC_LVTTHMR),
-	X2APIC_MSR(APIC_LVTPC),
-	X2APIC_MSR(APIC_LVT0),
-	X2APIC_MSR(APIC_LVT1),
-	X2APIC_MSR(APIC_LVTERR),
-	X2APIC_MSR(APIC_TMICT),
-	X2APIC_MSR(APIC_TMCCT),
-	X2APIC_MSR(APIC_TDCR),
-};
-
-static_assert(ARRAY_SIZE(direct_access_msrs) ==
-	      MAX_DIRECT_ACCESS_MSRS - 6 * !IS_ENABLED(CONFIG_X86_64));
-#undef MAX_DIRECT_ACCESS_MSRS
-
 /*
  * These 2 parameters are used to config the controls for Pause-Loop Exiting:
  * pause_filter_count: On processors that support Pause filtering(indicated
@@ -757,44 +691,6 @@ static void clr_dr_intercepts(struct vcpu_svm *svm)
 	recalc_intercepts(svm);
 }
 
-static int direct_access_msr_slot(u32 msr)
-{
-	u32 i;
-
-	for (i = 0; i < ARRAY_SIZE(direct_access_msrs); i++) {
-		if (direct_access_msrs[i] == msr)
-			return i;
-	}
-
-	return -ENOENT;
-}
-
-static void set_shadow_msr_intercept(struct kvm_vcpu *vcpu, u32 msr, int read,
-				     int write)
-{
-	struct vcpu_svm *svm = to_svm(vcpu);
-	int slot = direct_access_msr_slot(msr);
-
-	if (slot == -ENOENT)
-		return;
-
-	/* Set the shadow bitmaps to the desired intercept states */
-	if (read)
-		__set_bit(slot, svm->shadow_msr_intercept.read);
-	else
-		__clear_bit(slot, svm->shadow_msr_intercept.read);
-
-	if (write)
-		__set_bit(slot, svm->shadow_msr_intercept.write);
-	else
-		__clear_bit(slot, svm->shadow_msr_intercept.write);
-}
-
-static bool valid_msr_intercept(u32 index)
-{
-	return direct_access_msr_slot(index) != -ENOENT;
-}
-
 static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
 {
 	/*
@@ -812,62 +708,11 @@ static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
 	return svm_test_msr_bitmap_write(msrpm, msr);
 }
 
-static void set_msr_interception_bitmap(struct kvm_vcpu *vcpu, u32 *msrpm,
-					u32 msr, int read, int write)
-{
-	struct vcpu_svm *svm = to_svm(vcpu);
-	u8 bit_read, bit_write;
-	unsigned long tmp;
-	u32 offset;
-
-	/*
-	 * If this warning triggers extend the direct_access_msrs list at the
-	 * beginning of the file
-	 */
-	WARN_ON(!valid_msr_intercept(msr));
-
-	/* Enforce non allowed MSRs to trap */
-	if (read && !kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_READ))
-		read = 0;
-
-	if (write && !kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_WRITE))
-		write = 0;
-
-	offset    = svm_msrpm_offset(msr);
-	if (KVM_BUG_ON(offset == MSR_INVALID, vcpu->kvm))
-		return;
-
-	bit_read  = 2 * (msr & 0x0f);
-	bit_write = 2 * (msr & 0x0f) + 1;
-	tmp       = msrpm[offset];
-
-	read  ? __clear_bit(bit_read,  &tmp) : __set_bit(bit_read,  &tmp);
-	write ? __clear_bit(bit_write, &tmp) : __set_bit(bit_write, &tmp);
-
-	if (read)
-		svm_clear_msr_bitmap_read((void *)msrpm, msr);
-	else
-		svm_set_msr_bitmap_read((void *)msrpm, msr);
-
-	if (write)
-		svm_clear_msr_bitmap_write((void *)msrpm, msr);
-	else
-		svm_set_msr_bitmap_write((void *)msrpm, msr);
-
-	WARN_ON_ONCE(msrpm[offset] != (u32)tmp);
-
-	svm_hv_vmcb_dirty_nested_enlightenments(vcpu);
-	svm->nested.force_msr_bitmap_recalc = true;
-}
-
 void svm_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	void *msrpm = svm->msrpm;
 
-	/* Note, the shadow intercept bitmaps have inverted polarity. */
-	set_shadow_msr_intercept(vcpu, msr, type & MSR_TYPE_R, type & MSR_TYPE_W);
-
 	/* Don't disable interception for MSRs userspace wants to handle. */
 	if ((type & MSR_TYPE_R) &&
 	    !kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_READ)) {
@@ -896,9 +741,6 @@ void svm_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	void *msrpm = svm->msrpm;
 
-	set_shadow_msr_intercept(vcpu, msr,
-				 !(type & MSR_TYPE_R), !(type & MSR_TYPE_W));
-
 	if (type & MSR_TYPE_R)
 		svm_set_msr_bitmap_read(msrpm, msr);
 
@@ -924,6 +766,19 @@ u32 *svm_vcpu_alloc_msrpm(void)
 	return msrpm;
 }
 
+static void svm_recalc_lbr_msr_intercepts(struct kvm_vcpu *vcpu)
+{
+	bool intercept = !(to_svm(vcpu)->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK);
+
+	svm_set_intercept_for_msr(vcpu, MSR_IA32_LASTBRANCHFROMIP, MSR_TYPE_RW, intercept);
+	svm_set_intercept_for_msr(vcpu, MSR_IA32_LASTBRANCHTOIP, MSR_TYPE_RW, intercept);
+	svm_set_intercept_for_msr(vcpu, MSR_IA32_LASTINTFROMIP, MSR_TYPE_RW, intercept);
+	svm_set_intercept_for_msr(vcpu, MSR_IA32_LASTINTTOIP, MSR_TYPE_RW, intercept);
+
+	if (sev_es_guest(vcpu->kvm))
+		svm_set_intercept_for_msr(vcpu, MSR_IA32_DEBUGCTLMSR, MSR_TYPE_RW, intercept);
+}
+
 static void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu)
 {
 	svm_disable_intercept_for_msr(vcpu, MSR_STAR, MSR_TYPE_RW);
@@ -941,6 +796,38 @@ static void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu)
 
 void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool intercept)
 {
+	static const u32 x2avic_passthrough_msrs[] = {
+		X2APIC_MSR(APIC_ID),
+		X2APIC_MSR(APIC_LVR),
+		X2APIC_MSR(APIC_TASKPRI),
+		X2APIC_MSR(APIC_ARBPRI),
+		X2APIC_MSR(APIC_PROCPRI),
+		X2APIC_MSR(APIC_EOI),
+		X2APIC_MSR(APIC_RRR),
+		X2APIC_MSR(APIC_LDR),
+		X2APIC_MSR(APIC_DFR),
+		X2APIC_MSR(APIC_SPIV),
+		X2APIC_MSR(APIC_ISR),
+		X2APIC_MSR(APIC_TMR),
+		X2APIC_MSR(APIC_IRR),
+		X2APIC_MSR(APIC_ESR),
+		X2APIC_MSR(APIC_ICR),
+		X2APIC_MSR(APIC_ICR2),
+
+		/*
+		 * Note!  Always intercept LVTT, as TSC-deadline timer mode
+		 * isn't virtualized by hardware, and the CPU will generate a
+		 * #GP instead of a #VMEXIT.
+		 */
+		X2APIC_MSR(APIC_LVTTHMR),
+		X2APIC_MSR(APIC_LVTPC),
+		X2APIC_MSR(APIC_LVT0),
+		X2APIC_MSR(APIC_LVT1),
+		X2APIC_MSR(APIC_LVTERR),
+		X2APIC_MSR(APIC_TMICT),
+		X2APIC_MSR(APIC_TMCCT),
+		X2APIC_MSR(APIC_TDCR),
+	};
 	int i;
 
 	if (intercept == svm->x2avic_msrs_intercepted)
@@ -949,15 +836,9 @@ void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool intercept)
 	if (!x2avic_enabled)
 		return;
 
-	for (i = 0; i < ARRAY_SIZE(direct_access_msrs); i++) {
-		int index = direct_access_msrs[i];
-
-		if ((index < APIC_BASE_MSR) ||
-		    (index > APIC_BASE_MSR + 0xff))
-			continue;
-
-		svm_set_intercept_for_msr(&svm->vcpu, index, MSR_TYPE_RW, intercept);
-	}
+	for (i = 0; i < ARRAY_SIZE(x2avic_passthrough_msrs); i++)
+		svm_set_intercept_for_msr(&svm->vcpu, x2avic_passthrough_msrs[i],
+					  MSR_TYPE_RW, intercept);
 
 	svm->x2avic_msrs_intercepted = intercept;
 }
@@ -967,65 +848,57 @@ void svm_vcpu_free_msrpm(u32 *msrpm)
 	__free_pages(virt_to_page(msrpm), get_order(MSRPM_SIZE));
 }
 
+static void svm_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	svm_vcpu_init_msrpm(vcpu);
+
+	if (lbrv)
+		svm_recalc_lbr_msr_intercepts(vcpu);
+
+	if (cpu_feature_enabled(X86_FEATURE_IBPB))
+		svm_set_intercept_for_msr(vcpu, MSR_IA32_PRED_CMD, MSR_TYPE_W,
+					  !guest_has_pred_cmd_msr(vcpu));
+
+	if (cpu_feature_enabled(X86_FEATURE_FLUSH_L1D))
+		svm_set_intercept_for_msr(vcpu, MSR_IA32_FLUSH_CMD, MSR_TYPE_W,
+					  !guest_cpu_cap_has(vcpu, X86_FEATURE_FLUSH_L1D));
+
+	/*
+	 * Disable interception of SPEC_CTRL if KVM doesn't need to manually
+	 * context switch the MSR (SPEC_CTRL is virtualized by the CPU), or if
+	 * the guest has a non-zero SPEC_CTRL value, i.e. is likely actively
+	 * using SPEC_CTRL.
+	 */
+	if (cpu_feature_enabled(X86_FEATURE_V_SPEC_CTRL))
+		svm_set_intercept_for_msr(vcpu, MSR_IA32_SPEC_CTRL, MSR_TYPE_RW,
+					  !guest_has_spec_ctrl_msr(vcpu));
+	else
+		svm_set_intercept_for_msr(vcpu, MSR_IA32_SPEC_CTRL, MSR_TYPE_RW,
+					  !svm->spec_ctrl);
+
+	/*
+	 * Intercept SYSENTER_EIP and SYSENTER_ESP when emulating an Intel CPU,
+	 * as AMD hardware only store 32 bits, whereas Intel CPUs track 64 bits.
+	 */
+	svm_set_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW,
+				  guest_cpuid_is_intel_compatible(vcpu));
+	svm_set_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW,
+				  guest_cpuid_is_intel_compatible(vcpu));
+
+	if (sev_es_guest(vcpu->kvm))
+		sev_es_recalc_msr_intercepts(vcpu);
+
+	/*
+	 * x2APIC intercepts are modified on-demand and cannot be filtered by
+	 * userspace.
+	 */
+}
+
 static void svm_msr_filter_changed(struct kvm_vcpu *vcpu)
 {
-	struct vcpu_svm *svm = to_svm(vcpu);
-	u32 i;
-
-	/*
-	 * Set intercept permissions for all direct access MSRs again. They
-	 * will automatically get filtered through the MSR filter, so we are
-	 * back in sync after this.
-	 */
-	for (i = 0; i < ARRAY_SIZE(direct_access_msrs); i++) {
-		u32 msr = direct_access_msrs[i];
-		u32 read = test_bit(i, svm->shadow_msr_intercept.read);
-		u32 write = test_bit(i, svm->shadow_msr_intercept.write);
-
-		set_msr_interception_bitmap(vcpu, svm->msrpm, msr, read, write);
-	}
-}
-
-static __init int add_msr_offset(u32 offset)
-{
-	int i;
-
-	for (i = 0; i < MSRPM_OFFSETS; ++i) {
-
-		/* Offset already in list? */
-		if (msrpm_offsets[i] == offset)
-			return 0;
-
-		/* Slot used by another offset? */
-		if (msrpm_offsets[i] != MSR_INVALID)
-			continue;
-
-		/* Add offset to list */
-		msrpm_offsets[i] = offset;
-
-		return 0;
-	}
-
-	return -ENOSPC;
-}
-
-static __init int init_msrpm_offsets(void)
-{
-	int i;
-
-	memset(msrpm_offsets, 0xff, sizeof(msrpm_offsets));
-
-	for (i = 0; i < ARRAY_SIZE(direct_access_msrs); i++) {
-		u32 offset;
-
-		offset = svm_msrpm_offset(direct_access_msrs[i]);
-		if (WARN_ON(offset == MSR_INVALID))
-			return -EIO;
-
-		if (WARN_ON_ONCE(add_msr_offset(offset)))
-			return -EIO;
-	}
-	return 0;
+	svm_recalc_msr_intercepts(vcpu);
 }
 
 void svm_copy_lbrs(struct vmcb *to_vmcb, struct vmcb *from_vmcb)
@@ -1044,13 +917,7 @@ void svm_enable_lbrv(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	svm->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
-	svm_disable_intercept_for_msr(vcpu, MSR_IA32_LASTBRANCHFROMIP, MSR_TYPE_RW);
-	svm_disable_intercept_for_msr(vcpu, MSR_IA32_LASTBRANCHTOIP, MSR_TYPE_RW);
-	svm_disable_intercept_for_msr(vcpu, MSR_IA32_LASTINTFROMIP, MSR_TYPE_RW);
-	svm_disable_intercept_for_msr(vcpu, MSR_IA32_LASTINTTOIP, MSR_TYPE_RW);
-
-	if (sev_es_guest(vcpu->kvm))
-		svm_disable_intercept_for_msr(vcpu, MSR_IA32_DEBUGCTLMSR, MSR_TYPE_RW);
+	svm_recalc_lbr_msr_intercepts(vcpu);
 
 	/* Move the LBR msrs to the vmcb02 so that the guest can see them. */
 	if (is_guest_mode(vcpu))
@@ -1064,10 +931,7 @@ static void svm_disable_lbrv(struct kvm_vcpu *vcpu)
 	KVM_BUG_ON(sev_es_guest(vcpu->kvm), vcpu->kvm);
 
 	svm->vmcb->control.virt_ext &= ~LBR_CTL_ENABLE_MASK;
-	svm_enable_intercept_for_msr(vcpu, MSR_IA32_LASTBRANCHFROMIP, MSR_TYPE_RW);
-	svm_enable_intercept_for_msr(vcpu, MSR_IA32_LASTBRANCHTOIP, MSR_TYPE_RW);
-	svm_enable_intercept_for_msr(vcpu, MSR_IA32_LASTINTFROMIP, MSR_TYPE_RW);
-	svm_enable_intercept_for_msr(vcpu, MSR_IA32_LASTINTTOIP, MSR_TYPE_RW);
+	svm_recalc_lbr_msr_intercepts(vcpu);
 
 	/*
 	 * Move the LBR msrs back to the vmcb01 to avoid copying them
@@ -1250,17 +1114,9 @@ static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	if (guest_cpuid_is_intel_compatible(vcpu)) {
-		/*
-		 * We must intercept SYSENTER_EIP and SYSENTER_ESP
-		 * accesses because the processor only stores 32 bits.
-		 * For the same reason we cannot use virtual VMLOAD/VMSAVE.
-		 */
 		svm_set_intercept(svm, INTERCEPT_VMLOAD);
 		svm_set_intercept(svm, INTERCEPT_VMSAVE);
 		svm->vmcb->control.virt_ext &= ~VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
-
-		svm_enable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW);
-		svm_enable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW);
 	} else {
 		/*
 		 * If hardware supports Virtual VMLOAD VMSAVE then enable it
@@ -1271,10 +1127,9 @@ static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
 			svm_clr_intercept(svm, INTERCEPT_VMSAVE);
 			svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
 		}
-		/* No need to intercept these MSRs */
-		svm_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW);
-		svm_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW);
 	}
+
+	svm_recalc_msr_intercepts(vcpu);
 }
 
 static void init_vmcb(struct kvm_vcpu *vcpu)
@@ -1401,15 +1256,6 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 
 	svm_recalc_instruction_intercepts(vcpu, svm);
 
-	/*
-	 * If the CPU virtualizes MSR_IA32_SPEC_CTRL, i.e. KVM doesn't need to
-	 * manually context switch the MSR, immediately configure interception
-	 * of SPEC_CTRL, without waiting for the guest to access the MSR.
-	 */
-	if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
-		svm_set_intercept_for_msr(vcpu, MSR_IA32_SPEC_CTRL, MSR_TYPE_RW,
-					  !guest_has_spec_ctrl_msr(vcpu));
-
 	if (kvm_vcpu_apicv_active(vcpu))
 		avic_init_vmcb(svm, vmcb);
 
@@ -1440,8 +1286,6 @@ static void __svm_vcpu_reset(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	svm_vcpu_init_msrpm(vcpu);
-
 	svm_init_osvw(vcpu);
 
 	if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_STUFF_FEATURE_MSRS))
@@ -3241,8 +3085,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 
 		/*
 		 * TSC_AUX is usually changed only during boot and never read
-		 * directly.  Intercept TSC_AUX instead of exposing it to the
-		 * guest via direct_access_msrs, and switch it via user return.
+		 * directly.  Intercept TSC_AUX and switch it via user return.
 		 */
 		preempt_disable();
 		ret = kvm_set_user_return_msr(tsc_aux_uret_slot, data, -1ull);
@@ -4678,14 +4521,6 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	svm_recalc_instruction_intercepts(vcpu, svm);
 
-	if (boot_cpu_has(X86_FEATURE_IBPB))
-		svm_set_intercept_for_msr(vcpu, MSR_IA32_PRED_CMD, MSR_TYPE_W,
-					  !guest_has_pred_cmd_msr(vcpu));
-
-	if (boot_cpu_has(X86_FEATURE_FLUSH_L1D))
-		svm_set_intercept_for_msr(vcpu, MSR_IA32_FLUSH_CMD, MSR_TYPE_W,
-					  !guest_cpu_cap_has(vcpu, X86_FEATURE_FLUSH_L1D));
-
 	if (sev_guest(vcpu->kvm))
 		sev_vcpu_after_set_cpuid(svm);
 
@@ -5544,10 +5379,6 @@ static __init int svm_hardware_setup(void)
 	}
 	kvm_enable_efer_bits(EFER_NX);
 
-	r = init_msrpm_offsets();
-	if (r)
-		return r;
-
 	kvm_caps.supported_xcr0 &= ~(XFEATURE_MASK_BNDREGS |
 				     XFEATURE_MASK_BNDCSR);
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 5d5805ab59a7..91c4eb2232e0 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -44,9 +44,6 @@ static inline struct page *__sme_pa_to_page(unsigned long pa)
 #define	IOPM_SIZE PAGE_SIZE * 3
 #define	MSRPM_SIZE PAGE_SIZE * 2
 
-#define MAX_DIRECT_ACCESS_MSRS	47
-#define MSRPM_OFFSETS	32
-extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
 extern int nrips;
 extern int vgif;
@@ -318,12 +315,6 @@ struct vcpu_svm {
 	struct list_head ir_list;
 	spinlock_t ir_list_lock;
 
-	/* Save desired MSR intercept (read: pass-through) state */
-	struct {
-		DECLARE_BITMAP(read, MAX_DIRECT_ACCESS_MSRS);
-		DECLARE_BITMAP(write, MAX_DIRECT_ACCESS_MSRS);
-	} shadow_msr_intercept;
-
 	struct vcpu_sev_es_state sev_es;
 
 	bool guest_state_loaded;
@@ -820,6 +811,7 @@ void sev_init_vmcb(struct vcpu_svm *svm);
 void sev_vcpu_after_set_cpuid(struct vcpu_svm *svm);
 int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
 void sev_es_vcpu_reset(struct vcpu_svm *svm);
+void sev_es_recalc_msr_intercepts(struct kvm_vcpu *vcpu);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_save_area *hostsa);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
-- 
2.50.0.rc0.642.g800a2b2222-goog


