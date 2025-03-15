Return-Path: <kvm+bounces-41143-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 323CDA62523
	for <lists+kvm@lfdr.de>; Sat, 15 Mar 2025 04:08:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8F6DE7AE614
	for <lists+kvm@lfdr.de>; Sat, 15 Mar 2025 03:07:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57FA3199FC9;
	Sat, 15 Mar 2025 03:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GyccclzN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900E9194C75
	for <kvm@vger.kernel.org>; Sat, 15 Mar 2025 03:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742008002; cv=none; b=DPeVFbEpFgvQKtiviQM4L5rXaoFx5ddHkcZQKZK5WAqc9RQMkuUfUfvVpnjmwT04p2jiQj9sWmNLQJnvIOVUSLxQZvZZhPr7XLja87H79UDt4aF7kcjEpVG3uNYVJ11XA0pQH4ZSMT0p6UV/bFTV0GgiBoXAtQXFD/V6v2hbvVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742008002; c=relaxed/simple;
	bh=Uta9a/3o/kiGmJmq8wNCcF+U80EDf0HSkBBuI1bpzK4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jJif3Nnr4T4h3vr9cc8nP6HbrV329nC5CFTeyQFO8KxbG8Hlc6Z18b1XKgU4yGMd9qY6LdITQZylUwUIjecLsvVvPnnRp1oyfsqH7VsftwMfilGSpCo3zExRG46ZFn2Q5QdQ+iThe+OJ/U7LljH38Oqtga3nmTj8887qwKCPz50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GyccclzN; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff82dd6de0so454763a91.0
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 20:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742007999; x=1742612799; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=eXE4hRNdIiKSnjJQabn9+9Z7l4STEDkxZZthIWAaxQM=;
        b=GyccclzNZKflDwYfwsuNwTREjeT4y5XYdu85Irz+7wHGQgoBvF1CVb0oTBO79nelqj
         vY9ywEWq6u7ugedqR+nkgGzFK+nPh+UWKBa8lMiVzPg3ey7hVDscObqm8+Q81menAr+c
         Fxprb0qardBlT0onT1OHmHNBIxy5WpOEUCp02HLNeZ303Y25olnvxzJqdUkOKa0IX2O/
         ARz0agITwnJNH9/Z07NuC8dU+Q8AcHB5KpQvOUNNt10qxexeVJo3s3w+HZHEGC8M5DZx
         arVTByS4z03GtR+nWUFn2aL2WOYxb3sGp9SHg2skwSiR+ClTQDCf3tusF+2PrSC5ZCg8
         ns5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742007999; x=1742612799;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eXE4hRNdIiKSnjJQabn9+9Z7l4STEDkxZZthIWAaxQM=;
        b=WWFdfH3aVtPTqmTfyWXLSq3n538SgwSvUdslqGlVq2hB9Ki4PclhuB7RG1zR25A1Hv
         42ntvuLqsAO+RmiMUC36ee0J3mYgiIREJA/rkiCjGzgSn3P7bs2GhV+p6BwFKBHycav/
         DlhUmstXGkDZbLx1ASvLKQ/+NizNzFgcUuLO0YAtL1dTiBv2I+H2pAP0fABICE2HplAO
         epZMhEfdOLLQam2ZGOyhgk1rs7mM5NVnxSUL2ctgfmuhXsxYpbXX+ngtRHW0WacsdTa9
         yG/shB6JRdeaeDXNe4bQ56bSUXNP8n/e6Nt+QQglAvktpjeY2t509+EHMpkicEOq4+0g
         ew/w==
X-Forwarded-Encrypted: i=1; AJvYcCU0H+MqECKyqw66oEZwGApOxHYImf/GiD3kdLL6zuahsIxHkYlTVex7iq1XjU3p0A+W09o=@vger.kernel.org
X-Gm-Message-State: AOJu0YwrngVbcOAQRHJHUUQkz5WFPDD0ubxNhCniydWo+nt20gqWJAn3
	mu/Z8AVj1U2LRZ+9we+/X8gMP7c8DooloJAtIkyXJHwx8MAIay7DGq9OlCxziRHxdJw+7+Bdtfi
	Qqw==
X-Google-Smtp-Source: AGHT+IF1o7Gq8dxb5C/i4W3LaVHx9Xt9tEF6sWZDA8tMLg9rmMb0LEnExUDVXCga37ha7MMcuP+qjT1SPsA=
X-Received: from pjbtc11.prod.google.com ([2002:a17:90b:540b:b0:2ff:6e58:8a03])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2690:b0:2ee:af31:a7bd
 with SMTP id 98e67ed59e1d1-30151cb59afmr5565985a91.5.1742007998857; Fri, 14
 Mar 2025 20:06:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Mar 2025 20:06:25 -0700
In-Reply-To: <20250315030630.2371712-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250315030630.2371712-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250315030630.2371712-5-seanjc@google.com>
Subject: [PATCH 4/8] x86/irq: KVM: Track PIR bitmap as an "unsigned long" array
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Jacob Pan <jacob.jun.pan@linux.intel.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Track the PIR bitmap in posted interrupt descriptor structures as an array
of unsigned longs instead of using unionized arrays for KVM (u32s) versus
IRQ management (u64s).  In practice, because the non-KVM usage is (sanely)
restricted to 64-bit kernels, all existing usage of the u64 variant is
already working with unsigned longs.

Using "unsigned long" for the array will allow reworking KVM's processing
of the bitmap to read/write in 64-bit chunks on 64-bit kernels, i.e. will
allow optimizing KVM by reducing the number of atomic accesses to PIR.

Opportunstically replace the open coded literals in the posted MSIs code
with the appropriate macro.  Deliberately don't use ARRAY_SIZE() in the
for-loops, even though it would be cleaner from a certain perspective, in
anticipation of decoupling the processing from the array declaration.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/posted_intr.h | 14 +++++++-------
 arch/x86/kernel/irq.c              | 12 ++++++------
 arch/x86/kvm/lapic.c               |  9 +++++----
 arch/x86/kvm/lapic.h               |  4 ++--
 arch/x86/kvm/vmx/posted_intr.h     |  2 +-
 5 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/posted_intr.h b/arch/x86/include/asm/posted_intr.h
index de788b400fba..c3e6e4221a5b 100644
--- a/arch/x86/include/asm/posted_intr.h
+++ b/arch/x86/include/asm/posted_intr.h
@@ -8,12 +8,12 @@
 
 #define PID_TABLE_ENTRY_VALID 1
 
+#define NR_PIR_VECTORS	256
+#define NR_PIR_WORDS	(NR_PIR_VECTORS / BITS_PER_LONG)
+
 /* Posted-Interrupt Descriptor */
 struct pi_desc {
-	union {
-		u32 pir[8];     /* Posted interrupt requested */
-		u64 pir64[4];
-	};
+	unsigned long pir[NR_PIR_WORDS];     /* Posted interrupt requested */
 	union {
 		struct {
 			u16	notifications; /* Suppress and outstanding bits */
@@ -43,12 +43,12 @@ static inline bool pi_test_and_clear_sn(struct pi_desc *pi_desc)
 
 static inline bool pi_test_and_set_pir(int vector, struct pi_desc *pi_desc)
 {
-	return test_and_set_bit(vector, (unsigned long *)pi_desc->pir);
+	return test_and_set_bit(vector, pi_desc->pir);
 }
 
 static inline bool pi_is_pir_empty(struct pi_desc *pi_desc)
 {
-	return bitmap_empty((unsigned long *)pi_desc->pir, NR_VECTORS);
+	return bitmap_empty(pi_desc->pir, NR_VECTORS);
 }
 
 static inline void pi_set_sn(struct pi_desc *pi_desc)
@@ -105,7 +105,7 @@ static inline bool pi_pending_this_cpu(unsigned int vector)
 	if (WARN_ON_ONCE(vector > NR_VECTORS || vector < FIRST_EXTERNAL_VECTOR))
 		return false;
 
-	return test_bit(vector, (unsigned long *)pid->pir);
+	return test_bit(vector, pid->pir);
 }
 
 extern void intel_posted_msi_init(void);
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 3f95b00ccd7f..704c104ff7a4 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -405,13 +405,13 @@ void intel_posted_msi_init(void)
  * instead of:
  *		read, xchg, read, xchg, read, xchg, read, xchg
  */
-static __always_inline bool handle_pending_pir(u64 *pir, struct pt_regs *regs)
+static __always_inline bool handle_pending_pir(unsigned long *pir, struct pt_regs *regs)
 {
 	int i, vec = FIRST_EXTERNAL_VECTOR;
-	unsigned long pir_copy[4];
+	unsigned long pir_copy[NR_PIR_WORDS];
 	bool found_irq = false;
 
-	for (i = 0; i < 4; i++) {
+	for (i = 0; i < NR_PIR_WORDS; i++) {
 		pir_copy[i] = READ_ONCE(pir[i]);
 		if (pir_copy[i])
 			found_irq = true;
@@ -420,7 +420,7 @@ static __always_inline bool handle_pending_pir(u64 *pir, struct pt_regs *regs)
 	if (!found_irq)
 		return false;
 
-	for (i = 0; i < 4; i++) {
+	for (i = 0; i < NR_PIR_WORDS; i++) {
 		if (!pir_copy[i])
 			continue;
 
@@ -460,7 +460,7 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_posted_msi_notification)
 	 * MAX_POSTED_MSI_COALESCING_LOOP - 1 loops are executed here.
 	 */
 	while (++i < MAX_POSTED_MSI_COALESCING_LOOP) {
-		if (!handle_pending_pir(pid->pir64, regs))
+		if (!handle_pending_pir(pid->pir, regs))
 			break;
 	}
 
@@ -475,7 +475,7 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_posted_msi_notification)
 	 * process PIR bits one last time such that handling the new interrupts
 	 * are not delayed until the next IRQ.
 	 */
-	handle_pending_pir(pid->pir64, regs);
+	handle_pending_pir(pid->pir, regs);
 
 	apic_eoi();
 	irq_exit();
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index cb4aeab914eb..893e7d06e0e6 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -655,8 +655,9 @@ static u8 count_vectors(void *bitmap)
 	return count;
 }
 
-bool __kvm_apic_update_irr(u32 *pir, void *regs, int *max_irr)
+bool __kvm_apic_update_irr(unsigned long *pir, void *regs, int *max_irr)
 {
+	u32 *__pir = (void *)pir;
 	u32 i, vec;
 	u32 pir_val, irr_val, prev_irr_val;
 	int max_updated_irr;
@@ -668,10 +669,10 @@ bool __kvm_apic_update_irr(u32 *pir, void *regs, int *max_irr)
 		u32 *p_irr = (u32 *)(regs + APIC_IRR + i * 0x10);
 
 		irr_val = READ_ONCE(*p_irr);
-		pir_val = READ_ONCE(pir[i]);
+		pir_val = READ_ONCE(__pir[i]);
 
 		if (pir_val) {
-			pir_val = xchg(&pir[i], 0);
+			pir_val = xchg(&__pir[i], 0);
 
 			prev_irr_val = irr_val;
 			do {
@@ -691,7 +692,7 @@ bool __kvm_apic_update_irr(u32 *pir, void *regs, int *max_irr)
 }
 EXPORT_SYMBOL_GPL(__kvm_apic_update_irr);
 
-bool kvm_apic_update_irr(struct kvm_vcpu *vcpu, u32 *pir, int *max_irr)
+bool kvm_apic_update_irr(struct kvm_vcpu *vcpu, unsigned long *pir, int *max_irr)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	bool irr_updated = __kvm_apic_update_irr(pir, apic->regs, max_irr);
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 1a8553ebdb42..0d41780852e4 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -101,8 +101,8 @@ bool kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
 			   int shorthand, unsigned int dest, int dest_mode);
 int kvm_apic_compare_prio(struct kvm_vcpu *vcpu1, struct kvm_vcpu *vcpu2);
 void kvm_apic_clear_irr(struct kvm_vcpu *vcpu, int vec);
-bool __kvm_apic_update_irr(u32 *pir, void *regs, int *max_irr);
-bool kvm_apic_update_irr(struct kvm_vcpu *vcpu, u32 *pir, int *max_irr);
+bool __kvm_apic_update_irr(unsigned long *pir, void *regs, int *max_irr);
+bool kvm_apic_update_irr(struct kvm_vcpu *vcpu, unsigned long *pir, int *max_irr);
 void kvm_apic_update_ppr(struct kvm_vcpu *vcpu);
 int kvm_apic_set_irq(struct kvm_vcpu *vcpu, struct kvm_lapic_irq *irq,
 		     struct dest_map *dest_map);
diff --git a/arch/x86/kvm/vmx/posted_intr.h b/arch/x86/kvm/vmx/posted_intr.h
index ad9116a99bcc..4ff9d720dec0 100644
--- a/arch/x86/kvm/vmx/posted_intr.h
+++ b/arch/x86/kvm/vmx/posted_intr.h
@@ -18,7 +18,7 @@ static inline int pi_find_highest_vector(struct pi_desc *pi_desc)
 {
 	int vec;
 
-	vec = find_last_bit((unsigned long *)pi_desc->pir, 256);
+	vec = find_last_bit(pi_desc->pir, 256);
 	return vec < 256 ? vec : -1;
 }
 
-- 
2.49.0.rc1.451.g8f38331e32-goog


