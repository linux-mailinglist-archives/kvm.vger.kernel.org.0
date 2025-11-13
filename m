Return-Path: <kvm+bounces-63115-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AC13C5AAB9
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:46:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1475C4E82D2
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:40:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5049D335094;
	Thu, 13 Nov 2025 23:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T6utw3ea"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7C032B99D
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 23:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763077086; cv=none; b=QFEq8uoX0lNhv6L7wgUTZRXZADTIpAmecO+8vUsDAIG0nq8XfPDFIeuztj2ZOTqhZG62zy3zw5sjJYda8P/cKEAyLq1Qu6bWnKY8iHeaume1a03Tb8tpvvKSTxXGaH1kOTw/XhiKSpBnsbZ3ra9ppqDAmdcUlXYP67lLmRLnpgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763077086; c=relaxed/simple;
	bh=B/Y8IL0u/Yf38qiKxxW8J1SjwRx9A+pqtBMgpmG/tKg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RULOSGOmT32br/SQh3jlSCtGMnx+9zrLBK2M1Lj1p88ut9GyuriI2NA/xt+DJatOlbrXd/XzP/5kj304uoDBtAim1ekpI15BYBcXR0Ct1vJNM4FiSQc4aeMoPU7KbMi2dldc9JOOnsjhsSJbnzpYeuxH7gzoWmqKIUAGJHAkI88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T6utw3ea; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7b9090d9f2eso1643716b3a.0
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 15:38:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763077084; x=1763681884; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=KaHHeo0MEFYI+GLNe9ECI/Oiz1Zlq+iHNt9JMoNWhqk=;
        b=T6utw3eaZqI/ohqwyyXLLXM+vWu51dH1JDFdULg7up0h61ln1vmLEzE8dEtblifaKb
         VCTYfF8asBoOJgN41wQmE2SN+Ew9kMu35d3OgY+k69QLrQ1Y/hp59q9jqwyKQcUTZLBs
         fYRO3JUn6EQtLTK9bg6vmxzpHM37gGBKAwo4+o1hPivz0XTI/YDQ5zk3SApmBehkG63S
         30abG8rm2jvuYHdInQ/pApPXmNS1NuhDyv2oFAh4wXe14wkZ0+dTMSNwEb+YA4BIcsO8
         EymLTyA/UV9cnAL43+LXdzV0iv4OgI4VePV+0rpWCoOYPxnmkdMpFuGMfugTKt3vuzkF
         qLrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763077084; x=1763681884;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KaHHeo0MEFYI+GLNe9ECI/Oiz1Zlq+iHNt9JMoNWhqk=;
        b=qtjIKEGdq9FLIEvrnxjkz4MieU9hifwba3jE76WmjAO/MsQbzkpUOiZxatkxyPd/oi
         l+FpSII17rFRxignSLctKwYoWr365GYrfJFYxZjiwBC5bvq5EYEmVM7BLxza6ciy7CdK
         FJqt8ozWwLDrUJTU2t+tK8tq/UBYF2XCQiSkl6vQptgBmInyfWu3bwVAIRSP5ecNkGD5
         qUr4vlGed8rEyHhCwiXSy25cExdzDRPpUNQymeFntJ87j3L3HlftbjRa/PgJnuDn0D5u
         we7dVrE2iSudqU7PPV/C1ps1VFjxNd6VaUg4eaC7O88ssaAbaTs2lmrJKJAV6+mfDkB6
         0hCQ==
X-Gm-Message-State: AOJu0YyAs4YxffPxBooo58YwNsRkxMumjQeOIQlA9A+RDRx947liuzx4
	VSWYUssjFXRr3OZ5QnW+HPdFll8uiks9EKdHL6tX6hGN9FpWq2eskN4Wecmip/Tz+dgqx4CvPxQ
	Yqqysnw==
X-Google-Smtp-Source: AGHT+IFA8/ID3yDfg8RK0jOw1iuj/Ls2AuCdSB9aT9rjOost0RLXhPoKOAPIKzNF+CYaofznnWFFajEs85s=
X-Received: from pgbee13.prod.google.com ([2002:a05:6a02:458d:b0:bac:6acd:818b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3382:b0:304:313a:4bcd
 with SMTP id adf61e73a8af0-35ba19a0b46mr1460781637.30.1763077083720; Thu, 13
 Nov 2025 15:38:03 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 15:37:46 -0800
In-Reply-To: <20251113233746.1703361-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113233746.1703361-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251113233746.1703361-10-seanjc@google.com>
Subject: [PATCH v5 9/9] KVM: x86: Unify L1TF flushing under per-CPU variable
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Brendan Jackman <jackmanb@google.com>

Currently the tracking of the need to flush L1D for L1TF is tracked by
two bits: one per-CPU and one per-vCPU.

The per-vCPU bit is always set when the vCPU shows up on a core, so
there is no interesting state that's truly per-vCPU. Indeed, this is a
requirement, since L1D is a part of the physical CPU.

So simplify this by combining the two bits.

The vCPU bit was being written from preemption-enabled regions.  To play
nice with those cases, wrap all calls from KVM and use a raw write so that
request a flush with preemption enabled doesn't trigger what would
effectively be DEBUG_PREEMPT false positives.  Preemption doesn't need to
be disabled, as kvm_arch_vcpu_load() will mark the new CPU as needing a
flush if the vCPU task is migrated, or if userspace runs the vCPU on a
different task.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
[sean: put raw write in KVM instead of in a hardirq.h variant]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ---
 arch/x86/kvm/mmu/mmu.c          |  2 +-
 arch/x86/kvm/vmx/nested.c       |  2 +-
 arch/x86/kvm/vmx/vmx.c          | 20 +++++---------------
 arch/x86/kvm/x86.c              |  6 +++---
 arch/x86/kvm/x86.h              | 14 ++++++++++++++
 6 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1a8ea5dc6699..9f9839bbce13 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1055,9 +1055,6 @@ struct kvm_vcpu_arch {
 	/* be preempted when it's in kernel-mode(cpl=0) */
 	bool preempted_in_kernel;
 
-	/* Flush the L1 Data cache for L1TF mitigation on VMENTER */
-	bool l1tf_flush_l1d;
-
 	/* Host CPU on which VM-entry was most recently attempted */
 	int last_vmentry_cpu;
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3cfabfbdd843..02c450686b4a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4859,7 +4859,7 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 	 */
 	BUILD_BUG_ON(lower_32_bits(PFERR_SYNTHETIC_MASK));
 
-	vcpu->arch.l1tf_flush_l1d = true;
+	kvm_request_l1tf_flush_l1d();
 	if (!flags) {
 		trace_kvm_page_fault(vcpu, fault_address, error_code);
 
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 564f5af5ae86..40777278eabb 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3828,7 +3828,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 		goto vmentry_failed;
 
 	/* Hide L1D cache contents from the nested guest.  */
-	vcpu->arch.l1tf_flush_l1d = true;
+	kvm_request_l1tf_flush_l1d();
 
 	/*
 	 * Must happen outside of nested_vmx_enter_non_root_mode() as it will
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ae6b102b1570..df4cfcc6591a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -395,26 +395,16 @@ static noinstr void vmx_l1d_flush(struct kvm_vcpu *vcpu)
 	 * 'always'
 	 */
 	if (static_branch_likely(&vmx_l1d_flush_cond)) {
-		bool flush_l1d;
-
 		/*
-		 * Clear the per-vcpu flush bit, it gets set again if the vCPU
+		 * Clear the per-cpu flush bit, it gets set again if the vCPU
 		 * is reloaded, i.e. if the vCPU is scheduled out or if KVM
 		 * exits to userspace, or if KVM reaches one of the unsafe
-		 * VMEXIT handlers, e.g. if KVM calls into the emulator.
+		 * VMEXIT handlers, e.g. if KVM calls into the emulator,
+		 * or from the interrupt handlers.
 		 */
-		flush_l1d = vcpu->arch.l1tf_flush_l1d;
-		vcpu->arch.l1tf_flush_l1d = false;
-
-		/*
-		 * Clear the per-cpu flush bit, it gets set again from
-		 * the interrupt handlers.
-		 */
-		flush_l1d |= kvm_get_cpu_l1tf_flush_l1d();
+		if (!kvm_get_cpu_l1tf_flush_l1d())
+			return;
 		kvm_clear_cpu_l1tf_flush_l1d();
-
-		if (!flush_l1d)
-			return;
 	}
 
 	vcpu->stat.l1d_flush++;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9c2e28028c2b..ae774519b701 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5209,7 +5209,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 
-	vcpu->arch.l1tf_flush_l1d = true;
+	kvm_request_l1tf_flush_l1d();
 
 	if (vcpu->scheduled_out && pmu->version && pmu->event_count) {
 		pmu->need_cleanup = true;
@@ -8032,7 +8032,7 @@ int kvm_write_guest_virt_system(struct kvm_vcpu *vcpu, gva_t addr, void *val,
 				unsigned int bytes, struct x86_exception *exception)
 {
 	/* kvm_write_guest_virt_system can pull in tons of pages. */
-	vcpu->arch.l1tf_flush_l1d = true;
+	kvm_request_l1tf_flush_l1d();
 
 	return kvm_write_guest_virt_helper(addr, val, bytes, vcpu,
 					   PFERR_WRITE_MASK, exception);
@@ -9440,7 +9440,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		return handle_emulation_failure(vcpu, emulation_type);
 	}
 
-	vcpu->arch.l1tf_flush_l1d = true;
+	kvm_request_l1tf_flush_l1d();
 
 	if (!(emulation_type & EMULTYPE_NO_DECODE)) {
 		kvm_clear_exception_queue(vcpu);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 24c754b0db2e..fdab0ad49098 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -420,6 +420,20 @@ static inline bool kvm_check_has_quirk(struct kvm *kvm, u64 quirk)
 	return !(kvm->arch.disabled_quirks & quirk);
 }
 
+static __always_inline void kvm_request_l1tf_flush_l1d(void)
+{
+#if IS_ENABLED(CONFIG_CPU_MITIGATIONS) && IS_ENABLED(CONFIG_KVM_INTEL)
+	/*
+	 * Use a raw write to set the per-CPU flag, as KVM will ensure a flush
+	 * even if preemption is currently enabled..  If the current vCPU task
+	 * is migrated to a different CPU (or userspace runs the vCPU on a
+	 * different task) before the next VM-Entry, then kvm_arch_vcpu_load()
+	 * will request a flush on the new CPU.
+	 */
+	raw_cpu_write(irq_stat.kvm_cpu_l1tf_flush_l1d, 1);
+#endif
+}
+
 void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip);
 
 u64 get_kvmclock_ns(struct kvm *kvm);
-- 
2.52.0.rc1.455.g30608eb744-goog


