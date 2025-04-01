Return-Path: <kvm+bounces-42374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C16D9A780C0
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 18:44:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 58AD23A5301
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 16:44:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A7D121420C;
	Tue,  1 Apr 2025 16:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XDct9ytc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0E220FA9C
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 16:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743525802; cv=none; b=aw3XqLTud9TlEwIsR+IP1oFd4yflmeHrMmUhJ3Z5de/zF60l+5gyGCbrItPauCFVxRAC+f3Teabm087J0JzNcF9tia+/K8A1+12GTMR/pCrmavfGXgE2kGOm59zDq68oAtM3X4luX5mvUT2xGKrHW1pxzxr8CY9NPW1nZ+R1YCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743525802; c=relaxed/simple;
	bh=/GjbkA6Kd7hsHZq/P/3sF3zT4FudF94Hv2Bxy1AVK8U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ATt4WbkohnM1/L8SA/fq5JcStIroDvZVrwRkBUUdBBjxgL9QZPFdnP4NcFo+EWtJifYoctyz4kMiAK7v6QtBlETldk+5EcYEBD2x42QxBvzdYP6C+NyqROMvMUeadX1QdPBtwcqYNqw4lVTLuBGM0lZNselsoqYNy2iX2kAjTok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XDct9ytc; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2265a09dbfcso7595965ad.0
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 09:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743525800; x=1744130600; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Zwrym7xxEAtgq4x4qvWpfuf9S76CNXdDvpgAdSnAM4Y=;
        b=XDct9ytcdGerG8zJTTQxiKoEpO8dmphUu3EL8CFqbq15SUkZCDb8YTza4FcCi5VICZ
         PfM7nJn7bHWVkj4NPA4WxIQ5Dqwoejd2H1q6gAjs0O4iqOF7uHWeSu5gH68xII52PX9t
         MMNz1U/R4VSgAt2mDP2vOEuwDN3A1/IMnP+cq8wfAc5JxHqbh9Ttm2CVks7J3Ge92+o3
         Ly/R5mjckJCXdqS2GBi/D+7nMfrUf8F201xsK7Ladn/UMb4MByif9r5TMnx90cx4wBUt
         5Uu1qWYirvbdNLjJdx4mnesAOxIZ2N4BBEDWnzj1NFGi8kr+zJxEs24nuh1MJWlGz/56
         NLkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743525800; x=1744130600;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zwrym7xxEAtgq4x4qvWpfuf9S76CNXdDvpgAdSnAM4Y=;
        b=xFSOzWfP9iiCCrgbjkRI9IInB/qZh+dgF63lzlywFgUby11jOVfYJfQ/KiPpdvJdNq
         rIWTPKEL/6rb0JmJ1P5OY8e5Igt5n+OX75I5zVekMi45UtCBpzj4KduS/kUFdAYX6JUw
         nLL7uWF4fmE1DoKNquK0WJFjzr7VcHAHL/lml1br+MM/MP8cqRFX/87err6RftOwWPrO
         W8dbmo1Ib/2Xl8drSPoOV2HZrJT6qzYLVG3Oz7QU0exB4y8plNGla8EzNJWDgl3w9PH5
         CZsn5UCxfzAN4djaWX6kK/26Ep7Tk98w5B87zPivfucH/XlzcDSj0iRXRK+DKIoD/qwE
         ELJA==
X-Forwarded-Encrypted: i=1; AJvYcCUvNR10PTzCaQDYmk3TYdgqYw+61/gNO8a7lkd01CGwmcOulrcAq/DnEAkHN8pupZcqc68=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/8qV/HRqVeYUW65Z14ut4Cak+3ujvmClqzpqbvUeSgtKMjvH2
	GoGJQzvsajXH1rtNAlEpxrHntdpSUrWL6pR3e9k/zktFpd0orJVGWRT//Mk2ZXX89lUndNHfxZO
	vQg==
X-Google-Smtp-Source: AGHT+IFbVo2sDfRTB5QdrlauwzOsHEHDj5i2PQ/L+ccHkR2b9gPNztMxgVK194+kKMnHLMvn4E7liI+Holc=
X-Received: from pfbln19.prod.google.com ([2002:a05:6a00:3cd3:b0:736:a1eb:1520])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e74e:b0:220:f59b:6e6
 with SMTP id d9443c01a7336-2292f9494e1mr156226415ad.8.1743525800423; Tue, 01
 Apr 2025 09:43:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  1 Apr 2025 09:34:43 -0700
In-Reply-To: <20250401163447.846608-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250401163447.846608-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.472.ge94155a9ec-goog
Message-ID: <20250401163447.846608-5-seanjc@google.com>
Subject: [PATCH v2 4/8] x86/irq: KVM: Track PIR bitmap as an "unsigned long" array
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>
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
index 5d732ff357ef..3753a8acd009 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -407,12 +407,12 @@ void intel_posted_msi_init(void)
  * instead of:
  *		read, xchg, read, xchg, read, xchg, read, xchg
  */
-static __always_inline bool handle_pending_pir(u64 *pir, struct pt_regs *regs)
+static __always_inline bool handle_pending_pir(unsigned long *pir, struct pt_regs *regs)
 {
-	unsigned long pir_copy[4], pending = 0;
+	unsigned long pir_copy[NR_PIR_WORDS], pending = 0;
 	int i, vec = FIRST_EXTERNAL_VECTOR;
 
-	for (i = 0; i < 4; i++) {
+	for (i = 0; i < NR_PIR_WORDS; i++) {
 		pir_copy[i] = READ_ONCE(pir[i]);
 		pending |= pir_copy[i];
 	}
@@ -420,7 +420,7 @@ static __always_inline bool handle_pending_pir(u64 *pir, struct pt_regs *regs)
 	if (!pending)
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
2.49.0.472.ge94155a9ec-goog


