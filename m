Return-Path: <kvm+bounces-61630-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EED66C22CA3
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 01:33:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 878D23ACC62
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 00:32:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 560231DF258;
	Fri, 31 Oct 2025 00:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TZpi9qhF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BF323184A
	for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 00:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761870662; cv=none; b=QBYx57N5+GiOu32MMT0u3LhRzdk9/BU06C7QSQemWGzuoJ9hD/mK1Vaf57r70JyqAZnIRcP7aDst7Pe8Crf7kbCL4s5NVBVKu/TPNIg0dJF1ypZzoWnJP28ijHZBv7dJB2bxm5E57Iumb1gAVxo4N35Yp9M8C+0hAsMCFSopE/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761870662; c=relaxed/simple;
	bh=RT/sHTj0KzhQejEjxZna5Y25pQzofKvau2oAC0XFLaw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YApKlL5QsjWMLsZhMSxWHwA2xG/vhhPzRE8Fy1LjcWzDAn/jC6VRRw0KydeJW/FaLG15PVyf16R7lwi4MGSz4iZw55SqghE2aH8Bb7dhRN3PMeSmV6B1mEnuRbEwkzgWKG7F/rbM31pI2Hv8wREHS5O5FwKxqOjSKqy7bID3xLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TZpi9qhF; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33bc5d7c289so3040577a91.0
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 17:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761870660; x=1762475460; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=LbTsWO94j2FTsRt3NBHviHWz1y0m9u2EeuxD0YgFUA4=;
        b=TZpi9qhFK+2O1C3GQijopQgJMlMLtGga7+AqwSHkJvMxQPN724rnyE+PlzRQ+NsVBf
         adB0KdVoHD8ANTKbvCMcKcBmFNApJPZFt7VDoWS49c3CBGzS3rqRf12tAV53FDafb+85
         E6XL1/gKN31qy4p9gcPqR49nWCiwoXFXpziH0Zq+uIK8dUmtbz9RSi3z5LE7xpG01CWl
         LbgpG2v420R/EWNpw+VCT73hfxKYG+XI+tkskoPH5/tzSXwesSECLsR/HfTsN0AEzmMk
         +AviEr025TIbazYPS4ZJmVpV3QwbwVK8DiOHGp0awOZy093QHWlSBCQILceFKbjo95hq
         jtKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761870660; x=1762475460;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LbTsWO94j2FTsRt3NBHviHWz1y0m9u2EeuxD0YgFUA4=;
        b=cCpKhvoFBX/j164stXw7OagP/3UpXrhhi5ZKGR17Eas1c5JwhizMTnopJYT3A/GWAm
         o4EvgNuhHn8D1wia2ZBr+UAlJkzhBBwL+5QBuTwYYFY4iv9yi6q2Ai+67rRBz/aee/hI
         SNYn1c8slOlg5FGX3OGFqv9fV0EMPtAFE0mPZyUEA1yG7I2PZIP+1KAzOqGBtBDVUPQc
         D1rkMbzdPq65uGJsOBvvfR/UpP1pbhoL2CxrqmPq3Oxch3Px6nE0L9ihhOhxTU3vzYtT
         WOk7TCB9SAup2xzBNXlxDmFSn2PucA5BdLmn4wF9Fm2v85DB9+8OVxFhAvnFgSwrkWvE
         1RUg==
X-Gm-Message-State: AOJu0YwX82gI4hPo8DVXLCc4JG0ZzttiMIgX+ywzoJGtucJOzKW3weDc
	3liqq3mrFPPTg0fe5CqvanmNqWBVZfiEo7frGhnF3urUapEcG8F4E2PQv64z42apipHoel5YFUK
	wgEAn7A==
X-Google-Smtp-Source: AGHT+IG9niXeqcQKc5xfb5DpFxjBvH7jNOuHlLCtg8NMqPQ9wNkIMDEwIxItwd+jCVHQRiKCwCLg7bs2U5Y=
X-Received: from plblq15.prod.google.com ([2002:a17:903:144f:b0:268:11e:8271])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ea0e:b0:292:39b4:e785
 with SMTP id d9443c01a7336-2951a3e696fmr21856645ad.26.1761870660376; Thu, 30
 Oct 2025 17:31:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Oct 2025 17:30:40 -0700
In-Reply-To: <20251031003040.3491385-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251031003040.3491385-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251031003040.3491385-9-seanjc@google.com>
Subject: [PATCH v4 8/8] KVM: x86: Unify L1TF flushing under per-CPU variable
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
index 48598d017d6f..fcdc65ab13d8 100644
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
index 18d69d48bc55..4e016582adc7 100644
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
index b0cd745518b4..6f2f969d19f9 100644
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
index 1b5540105e4b..f87af1836ea1 100644
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
index b4b5d2d09634..851f078cd5ca 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5189,7 +5189,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 
-	vcpu->arch.l1tf_flush_l1d = true;
+	kvm_request_l1tf_flush_l1d();
 
 	if (vcpu->scheduled_out && pmu->version && pmu->event_count) {
 		pmu->need_cleanup = true;
@@ -7999,7 +7999,7 @@ int kvm_write_guest_virt_system(struct kvm_vcpu *vcpu, gva_t addr, void *val,
 				unsigned int bytes, struct x86_exception *exception)
 {
 	/* kvm_write_guest_virt_system can pull in tons of pages. */
-	vcpu->arch.l1tf_flush_l1d = true;
+	kvm_request_l1tf_flush_l1d();
 
 	return kvm_write_guest_virt_helper(addr, val, bytes, vcpu,
 					   PFERR_WRITE_MASK, exception);
@@ -9395,7 +9395,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		return handle_emulation_failure(vcpu, emulation_type);
 	}
 
-	vcpu->arch.l1tf_flush_l1d = true;
+	kvm_request_l1tf_flush_l1d();
 
 	if (!(emulation_type & EMULTYPE_NO_DECODE)) {
 		kvm_clear_exception_queue(vcpu);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index f3dc77f006f9..cd67ccbb747f 100644
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
2.51.1.930.gacf6e81ea2-goog


