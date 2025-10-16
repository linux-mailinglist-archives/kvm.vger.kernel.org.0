Return-Path: <kvm+bounces-60224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 48E4ABE5506
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 22:05:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 96BD719C77AC
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 20:05:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 988182E3B06;
	Thu, 16 Oct 2025 20:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zrqw8pOF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B252E11D5
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 20:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760645069; cv=none; b=E/tSVo2y729ttNsqaK+DJUFkCod0sb8GaiVVH6al0ECFHG88A7OC2KoaOqKMZs0DNcsvtr2z9qs3IIbCaANnt+DKGDLnxbEuy8cRJjcbDGs2qQCQ9yTvFSZ3E4x83CQ9dMkjcmYUdRg/qqP0NFY8WwGRw6Jj6/Lc3SiNjmD7OHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760645069; c=relaxed/simple;
	bh=SNE+nRiwqlE038YuWxnWn7j7iJTACVTLDjxXYnTjtWg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tGtiKK7gJ4ftQNUlZ6Ou+TazzuNTmXpzsSz4kmNqGSel0XrtJ95FVt+pmUHNofyR0phA8GrqL0QgOawXRaIM5OAqN9Guo0P94OfYhufIQLveEc8I+t+18DrCq8QTRtz3iGxq5rtaxhiylxnms1/11e0B1QPAbUrAINFOKFchxrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zrqw8pOF; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33baef12edaso1067603a91.0
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 13:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760645067; x=1761249867; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=8iJumIyoa7Jv1Ta1I07laKkWSuZSFDfZ4MoevL3qjrU=;
        b=zrqw8pOFo3pEeVjTnQoxMEYdTfWiLOpZ/1K7fAo9llED2PdDSbZE9wBESp9U2tPDOE
         Ial4OmVODB3+alwPHRgD9rEV8JQsjzw9N1Vym6O5QTFlCZfYhB1zoAp2LNSGxglxRriU
         aq3pXs8IvYTPpf9oFyKfyYt+B+ziDbs+aU5FJX8bgG/KMHJo21ZonyiGt8g66wagIGpG
         qBxqQKvvzxWZLHJnxatZme6ZIiZKdqz14ACWMB/xxQnpoWTkq7mSlbXQFOQtIvl8cpk7
         VgVeO8XXSWglQ+yFN+tX2Zdu00FDxpyhKmsESei3AQlxCy9nxNwDG4sjsNwf7xGbVzIZ
         rKIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760645067; x=1761249867;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8iJumIyoa7Jv1Ta1I07laKkWSuZSFDfZ4MoevL3qjrU=;
        b=SqLOK19TMcVMP1nptZV2G5+pGSQRoIRLpLmXY7ZJ0NLg0Q2uVwAAjSoyWcBCcENsxE
         k2Buv6ODHnMHOOnbybhjQ65D5nXhXCNs7BaAmlSWabm3NusmzcG7DhZjBz1TAHbyEksO
         lmJl+DH3jIAM7ZxWEi6LsiAkXAmYka35F2pxTWRYhWrecTB3qp5P88o5774a86wXuHAD
         GpNKgUTUNh2eTrykS2Bnsgv4uPGkd7WzGwWK81R5I9+Vfx5tgxGtrwbXzkGi86xjUch2
         oj60u7dcQrOERGnlFELutmkyovEj88St34W5fBv0ms48DfY5NItSfgXGarH9gmgizHo3
         wptg==
X-Gm-Message-State: AOJu0YyBsXbtIMegTR32YprSwqxvDrPuyej6lmxpLNjLpyF1VJ/O7+fe
	pfxFqmCa7R2IC3XWbwGFEDg+ov54GdhiB/OXfP2vDqc5+SwVndKKiGqiHdgccfYidewKMKsW8iW
	gAvQY0A==
X-Google-Smtp-Source: AGHT+IGOG6A5Ijw3KLuRGlwFU7ZiWO+4sv+3A/3GnT2Oqt8U2ps3rXOjLFbWGQRyn9sJEkzA80a7CZbegDY=
X-Received: from pjkm1.prod.google.com ([2002:a17:90a:7301:b0:339:ee20:f620])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3fcc:b0:31e:d4e3:4002
 with SMTP id 98e67ed59e1d1-33bcf85ad9amr1009215a91.2.1760645067487; Thu, 16
 Oct 2025 13:04:27 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 13:04:17 -0700
In-Reply-To: <20251016200417.97003-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251016200417.97003-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251016200417.97003-5-seanjc@google.com>
Subject: [PATCH v3 4/4] KVM: x86: Unify L1TF flushing under per-CPU variable
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
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
index 3fca63a261f5..468a013d9ef3 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3880,7 +3880,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 		goto vmentry_failed;
 
 	/* Hide L1D cache contents from the nested guest.  */
-	vcpu->arch.l1tf_flush_l1d = true;
+	kvm_request_l1tf_flush_l1d();
 
 	/*
 	 * Must happen outside of nested_vmx_enter_non_root_mode() as it will
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e91d99211efe..0347d321a86e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -395,26 +395,16 @@ static noinstr bool vmx_l1d_flush(struct kvm_vcpu *vcpu)
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
-			return false;
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
2.51.0.858.gf9c4a03a3a-goog


