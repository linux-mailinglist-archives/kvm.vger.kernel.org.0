Return-Path: <kvm+bounces-59907-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EB28BD4DBB
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 18:15:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9D29D4F99C6
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 15:34:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B5A930F7F5;
	Mon, 13 Oct 2025 15:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HTo7fZEw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7B230F55F
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 15:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368866; cv=none; b=p9khzKUmUluAtXu1u/feAZLFS1lImnKGoL2Yn7CYZmP/5Zqm5tDirSxLb7/NoAvoQwXY/pFEwajFszlYpAJbCIi2vete/OxU3Lm10CZCjW4aeI28PZyWp24awk3DXMxZBWKJyz/x/x0/QjogVCNxdne5s2w3xury2VhIKqz9iI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368866; c=relaxed/simple;
	bh=uVIIcfGUtnM0AFmoNWciBQ3Oy6FcGT5tcohKaCO7Fdk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=gr3xIXewARGC5FNQft5JwY6wITmYD7VtaJJvdcDYkilOFZDrj3JEVRn6PDBhRGRsGWZcBs1mPfMo9k0rIv4k+zs/tviyzezQ8zt8u2avokWuCxDv7oauQvIFzv87i2bCXegUurUwlm43MhGOypsemlRic3zJgNtJ7bl336WiERo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HTo7fZEw; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-46eee58d405so25823675e9.1
        for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 08:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760368862; x=1760973662; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YIYoPCNyBFGg9vKc8jF45CxIFXipDwwSdrNJ736RRBY=;
        b=HTo7fZEwmN/AchWolAniP+Y4PdwpMVrwbOAXne7mzNG4myDYJ5qbQ+rJ+V6PTgj/cC
         lqduToxSwIztdVYxE5eNzqwhYLKEhizNJLcl5XjKazvgKlm8WrAyJD7LamHnmz8/Leq0
         7cXMHVYqMlF7ly6QEH5DjrboKM8xp1zdy4Ojl2qGl/YbeAYhKYiOBMZzXbhUw2T2opIW
         KZk8Usj+lTKDMiIb9rVeQXiakJlohU+I8aWeC+IxR1MWe8TQYs0+blaGlQq/HFcq7Em0
         B46d0IFTGtC6l6mEWRniwIljSkUUIba3qrm2zU0pFB5UpdHyHW/yyy/8fCA7PPeC15XI
         k7wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760368862; x=1760973662;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YIYoPCNyBFGg9vKc8jF45CxIFXipDwwSdrNJ736RRBY=;
        b=RHVjVNm+VlKTaNBMzeVw6NPTq9civGgSgejNeOQs2KdRVDw9I10Px3ZWQR9QcPmMpJ
         4t/5SULC7skWQaIWAXDnVB1ulM6EEMve8GO1Ox4IiTKV9A2a5pwMfREWCJbfzE/LJQpL
         n+VpCuQRsXlEsu6tCRiI4rGFGVqmGOirMdAGRnuiUnEBll/sTCtvguJbpyfWbBAzsJor
         e5YLMvNE/+m0kn2QbWGvZWoiOZ+YIBAyJJAd5t11z9aHrv/J+kcMaRio2ai1p4qmg9SK
         YiW+yiJ9lwunjvjcIRh8yPNQ2Evk3e4tIrerocwfysg35vAfS2DRrEGlxUw6pLevH3a6
         jOuw==
X-Forwarded-Encrypted: i=1; AJvYcCUJwLb38M1HNGraLwARhDAG9clzOZHRqPxAhkSG7mLBlw1UgOtMPoqF5HDJvsVc4DeVdXg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyq0TwQPpIUgzzLi1cfmzeQ5neVnXvMwfhLY+GSYHRvONsopkqZ
	VCGtDivmepWUWjdpsddWiWTcuYqAfeGWZhcZ5h0xmI2/m5ba/R1Zzt+J/jtt2CAoT0y2RdCIGv9
	NhWQgdKEZP+0JEQ==
X-Google-Smtp-Source: AGHT+IFVI/ebIiE03xp+IXTAIvzD7VP5Hg6xiJr5X8tY19ifba+QDyv+tPutqETwPbUzyh9TyIvbuut1FWkifw==
X-Received: from wmcq4.prod.google.com ([2002:a05:600c:c104:b0:46f:aa50:d6fc])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b1b:b0:46f:b327:31c4 with SMTP id 5b1f17b1804b1-46fb3273563mr98314565e9.14.1760368862615;
 Mon, 13 Oct 2025 08:21:02 -0700 (PDT)
Date: Mon, 13 Oct 2025 15:20:52 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIANMY7WgC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDI1NDA0Nj3SQT3RzDkjTdgtSi5IJSXXNLY0MLw7REUwsLEyWgpoKi1LTMCrC B0bG1tQCGPpaCYAAAAA==
X-Change-Id: 20251013-b4-l1tf-percpu-793181fa5884
X-Mailer: b4 0.14.2
Message-ID: <20251013-b4-l1tf-percpu-v1-1-d65c5366ea1a@google.com>
Subject: [PATCH] KVM: x86: Unify L1TF flushing under per-CPU variable
From: Brendan Jackman <jackmanb@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"

Currently the tracking of the need to flush L1D for L1TF is tracked by
two bits: one per-CPU and one per-vCPU.

The per-vCPU bit is always set when the vCPU shows up on a core, so
there is no interesting state that's truly per-vCPU. Indeed, this is a
requirement, since L1D is a part of the physical CPU.

So simplify this by combining the two bits.

Since this requires a DECLARE_PER_CPU() which belongs in kvm_host.h,
also move the remaining helper definitions there to live next to the
declaration.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/include/asm/hardirq.h  | 26 --------------------------
 arch/x86/include/asm/idtentry.h |  1 +
 arch/x86/include/asm/kvm_host.h | 21 ++++++++++++++++++---
 arch/x86/kvm/mmu/mmu.c          |  2 +-
 arch/x86/kvm/vmx/nested.c       |  2 +-
 arch/x86/kvm/vmx/vmx.c          | 17 +++--------------
 arch/x86/kvm/x86.c              | 12 +++++++++---
 7 files changed, 33 insertions(+), 48 deletions(-)

diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index f00c09ffe6a95f07342bb0c6cea3769d71eecfa9..29d8fa43d4404add3b191821e42c3526b0f2c950 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -5,9 +5,6 @@
 #include <linux/threads.h>
 
 typedef struct {
-#if IS_ENABLED(CONFIG_KVM_INTEL)
-	u8	     kvm_cpu_l1tf_flush_l1d;
-#endif
 	unsigned int __nmi_count;	/* arch dependent */
 #ifdef CONFIG_X86_LOCAL_APIC
 	unsigned int apic_timer_irqs;	/* arch dependent */
@@ -68,27 +65,4 @@ extern u64 arch_irq_stat(void);
 DECLARE_PER_CPU_CACHE_HOT(u16, __softirq_pending);
 #define local_softirq_pending_ref       __softirq_pending
 
-#if IS_ENABLED(CONFIG_KVM_INTEL)
-/*
- * This function is called from noinstr interrupt contexts
- * and must be inlined to not get instrumentation.
- */
-static __always_inline void kvm_set_cpu_l1tf_flush_l1d(void)
-{
-	__this_cpu_write(irq_stat.kvm_cpu_l1tf_flush_l1d, 1);
-}
-
-static __always_inline void kvm_clear_cpu_l1tf_flush_l1d(void)
-{
-	__this_cpu_write(irq_stat.kvm_cpu_l1tf_flush_l1d, 0);
-}
-
-static __always_inline bool kvm_get_cpu_l1tf_flush_l1d(void)
-{
-	return __this_cpu_read(irq_stat.kvm_cpu_l1tf_flush_l1d);
-}
-#else /* !IS_ENABLED(CONFIG_KVM_INTEL) */
-static __always_inline void kvm_set_cpu_l1tf_flush_l1d(void) { }
-#endif /* IS_ENABLED(CONFIG_KVM_INTEL) */
-
 #endif /* _ASM_X86_HARDIRQ_H */
diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
index a4ec27c6798875900cbdbba927918e70b900f63b..67fb1adadbb8ac2bd083ba6245de2e7d58b5b398 100644
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -12,6 +12,7 @@
 #include <linux/hardirq.h>
 
 #include <asm/irq_stack.h>
+#include <asm/kvm_host.h>
 
 typedef void (*idtentry_t)(struct pt_regs *regs);
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 48598d017d6f3f07263a2ffffe670be2658eb9cb..d93c2b9dbfbc9824cce65256f606f32e41c93167 100644
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
 
@@ -2476,4 +2473,22 @@ static inline bool kvm_arch_has_irq_bypass(void)
 	return enable_device_posted_irqs;
 }
 
+#if IS_ENABLED(CONFIG_KVM_INTEL)
+
+DECLARE_PER_CPU(bool, l1tf_flush_l1d);
+
+/*
+ * This function is called from noinstr interrupt contexts
+ * and must be inlined to not get instrumentation.
+ */
+static __always_inline void kvm_set_cpu_l1tf_flush_l1d(void)
+{
+	__this_cpu_write(l1tf_flush_l1d, true);
+}
+
+#else /* !IS_ENABLED(CONFIG_KVM_INTEL) */
+static __always_inline void kvm_set_cpu_l1tf_flush_l1d(void) { }
+#endif /* IS_ENABLED(CONFIG_KVM_INTEL) */
+
+
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 667d66cf76d5e52c22f9517914307244ae868eea..8c0dce401a42d977756ca82d249bb33c858b9c9f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4859,7 +4859,7 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 	 */
 	BUILD_BUG_ON(lower_32_bits(PFERR_SYNTHETIC_MASK));
 
-	vcpu->arch.l1tf_flush_l1d = true;
+	kvm_set_cpu_l1tf_flush_l1d();
 	if (!flags) {
 		trace_kvm_page_fault(vcpu, fault_address, error_code);
 
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 76271962cb7083b475de6d7d24bf9cb918050650..5035cfdc4e55365bfabf08c704b9bff5c06267a1 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3880,7 +3880,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 		goto vmentry_failed;
 
 	/* Hide L1D cache contents from the nested guest.  */
-	vmx->vcpu.arch.l1tf_flush_l1d = true;
+	kvm_set_cpu_l1tf_flush_l1d();
 
 	/*
 	 * Must happen outside of nested_vmx_enter_non_root_mode() as it will
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 546272a5d34da301710df1d89414f41fc9b24a1f..f982f6721dc3e0dfe046881c72732326e16fcfb3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6673,25 +6673,14 @@ static noinstr void vmx_l1d_flush(struct kvm_vcpu *vcpu)
 	 * 'always'
 	 */
 	if (static_branch_likely(&vmx_l1d_flush_cond)) {
-		bool flush_l1d;
-
 		/*
 		 * Clear the per-vcpu flush bit, it gets set again if the vCPU
 		 * is reloaded, i.e. if the vCPU is scheduled out or if KVM
 		 * exits to userspace, or if KVM reaches one of the unsafe
-		 * VMEXIT handlers, e.g. if KVM calls into the emulator.
+		 * VMEXIT handlers, e.g. if KVM calls into the emulator, or from the
+		 * interrupt handlers.
 		 */
-		flush_l1d = vcpu->arch.l1tf_flush_l1d;
-		vcpu->arch.l1tf_flush_l1d = false;
-
-		/*
-		 * Clear the per-cpu flush bit, it gets set again from
-		 * the interrupt handlers.
-		 */
-		flush_l1d |= kvm_get_cpu_l1tf_flush_l1d();
-		kvm_clear_cpu_l1tf_flush_l1d();
-
-		if (!flush_l1d)
+		if (!this_cpu_xchg(l1tf_flush_l1d, false))
 			return;
 	}
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4b8138bd48572fd161eda73d2dbdc1dcd0bcbcac..766d61516602e0f4975930224fc57b5a511281e5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -171,6 +171,12 @@ bool __read_mostly enable_vmware_backdoor = false;
 module_param(enable_vmware_backdoor, bool, 0444);
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(enable_vmware_backdoor);
 
+#if IS_ENABLED(CONFIG_KVM_INTEL)
+/* Flush the L1 Data cache for L1TF mitigation on VMENTER */
+DEFINE_PER_CPU(bool, l1tf_flush_l1d);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(l1tf_flush_l1d);
+#endif
+
 /*
  * Flags to manipulate forced emulation behavior (any non-zero value will
  * enable forced emulation).
@@ -5190,7 +5196,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 
-	vcpu->arch.l1tf_flush_l1d = true;
+	kvm_set_cpu_l1tf_flush_l1d();
 
 	if (vcpu->scheduled_out && pmu->version && pmu->event_count) {
 		pmu->need_cleanup = true;
@@ -8000,7 +8006,7 @@ int kvm_write_guest_virt_system(struct kvm_vcpu *vcpu, gva_t addr, void *val,
 				unsigned int bytes, struct x86_exception *exception)
 {
 	/* kvm_write_guest_virt_system can pull in tons of pages. */
-	vcpu->arch.l1tf_flush_l1d = true;
+	kvm_set_cpu_l1tf_flush_l1d();
 
 	return kvm_write_guest_virt_helper(addr, val, bytes, vcpu,
 					   PFERR_WRITE_MASK, exception);
@@ -9396,7 +9402,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		return handle_emulation_failure(vcpu, emulation_type);
 	}
 
-	vcpu->arch.l1tf_flush_l1d = true;
+	kvm_set_cpu_l1tf_flush_l1d();
 
 	if (!(emulation_type & EMULTYPE_NO_DECODE)) {
 		kvm_clear_exception_queue(vcpu);

---
base-commit: 6b36119b94d0b2bb8cea9d512017efafd461d6ac
change-id: 20251013-b4-l1tf-percpu-793181fa5884

Best regards,
-- 
Brendan Jackman <jackmanb@google.com>


