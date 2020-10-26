Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65E4929921A
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 17:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1775147AbgJZQPX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 12:15:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:59610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1774780AbgJZQPX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Oct 2020 12:15:23 -0400
Received: from localhost.localdomain (unknown [192.30.34.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F7CD22284;
        Mon, 26 Oct 2020 16:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603728922;
        bh=nbBpHbfA4qH/qtIRd76VIwnFW4gaPJYu7Nh39c3s29s=;
        h=From:To:Cc:Subject:Date:From;
        b=epxjmRJIXYZ5egvmm5CwGR1oa9AubDEWpLXol6zfnu8pAQolFoer1vyTqvCNbczE2
         iB9/4vORMo0jDTHM58OyIty1eQ59sQSo2kZdysLRXSzFbYtMK3IHCZKP1iTyWTXleb
         hoegApx41bOmszF9bd5CIuI0Ru+xqOJr4iS5wHKg=
From:   Arnd Bergmann <arnd@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Gleb Natapov <gleb@redhat.com>,
        Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] x86: kvm: avoid -Wshadow warning in header
Date:   Mon, 26 Oct 2020 17:14:39 +0100
Message-Id: <20201026161512.3708919-1-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

There are hundreds of warnings in a W=2 build about a local
variable shadowing the global 'apic' definition:

arch/x86/kvm/lapic.h:149:65: warning: declaration of 'apic' shadows a global declaration [-Wshadow]

Avoid this by renaming the local in the kvm/lapic.h header

Fixes: c48f14966cc4 ("KVM: inline kvm_apic_present() and kvm_lapic_enabled()")
Fixes: c8d46cf06dc2 ("x86: rename 'genapic' to 'apic'")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/x86/kvm/lapic.h | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 4fb86e3a9dd3..12bf60e86f34 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -83,8 +83,8 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value);
 u64 kvm_lapic_get_base(struct kvm_vcpu *vcpu);
 void kvm_recalculate_apic_map(struct kvm *kvm);
 void kvm_apic_set_version(struct kvm_vcpu *vcpu);
-int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val);
-int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
+int kvm_lapic_reg_write(struct kvm_lapic *lapic, u32 reg, u32 val);
+int kvm_lapic_reg_read(struct kvm_lapic *lapic, u32 offset, int len,
 		       void *data);
 bool kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
 			   int shorthand, unsigned int dest, int dest_mode);
@@ -95,12 +95,12 @@ bool kvm_apic_update_irr(struct kvm_vcpu *vcpu, u32 *pir, int *max_irr);
 void kvm_apic_update_ppr(struct kvm_vcpu *vcpu);
 int kvm_apic_set_irq(struct kvm_vcpu *vcpu, struct kvm_lapic_irq *irq,
 		     struct dest_map *dest_map);
-int kvm_apic_local_deliver(struct kvm_lapic *apic, int lvt_type);
+int kvm_apic_local_deliver(struct kvm_lapic *lapic, int lvt_type);
 void kvm_apic_update_apicv(struct kvm_vcpu *vcpu);
 
 bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
 		struct kvm_lapic_irq *irq, int *r, struct dest_map *dest_map);
-void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high);
+void kvm_apic_send_ipi(struct kvm_lapic *lapic, u32 icr_low, u32 icr_high);
 
 u64 kvm_get_apic_base(struct kvm_vcpu *vcpu);
 int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
@@ -147,19 +147,19 @@ static inline void kvm_lapic_set_vector(int vec, void *bitmap)
 	set_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
 }
 
-static inline void kvm_lapic_set_irr(int vec, struct kvm_lapic *apic)
+static inline void kvm_lapic_set_irr(int vec, struct kvm_lapic *lapic)
 {
-	kvm_lapic_set_vector(vec, apic->regs + APIC_IRR);
+	kvm_lapic_set_vector(vec, lapic->regs + APIC_IRR);
 	/*
 	 * irr_pending must be true if any interrupt is pending; set it after
 	 * APIC_IRR to avoid race with apic_clear_irr
 	 */
-	apic->irr_pending = true;
+	lapic->irr_pending = true;
 }
 
-static inline u32 kvm_lapic_get_reg(struct kvm_lapic *apic, int reg_off)
+static inline u32 kvm_lapic_get_reg(struct kvm_lapic *lapic, int reg_off)
 {
-	return *((u32 *) (apic->regs + reg_off));
+	return *((u32 *) (lapic->regs + reg_off));
 }
 
 static inline void __kvm_lapic_set_reg(char *regs, int reg_off, u32 val)
@@ -167,9 +167,9 @@ static inline void __kvm_lapic_set_reg(char *regs, int reg_off, u32 val)
 	*((u32 *) (regs + reg_off)) = val;
 }
 
-static inline void kvm_lapic_set_reg(struct kvm_lapic *apic, int reg_off, u32 val)
+static inline void kvm_lapic_set_reg(struct kvm_lapic *lapic, int reg_off, u32 val)
 {
-	__kvm_lapic_set_reg(apic->regs, reg_off, val);
+	__kvm_lapic_set_reg(lapic->regs, reg_off, val);
 }
 
 extern struct static_key kvm_no_apic_vcpu;
@@ -183,19 +183,19 @@ static inline bool lapic_in_kernel(struct kvm_vcpu *vcpu)
 
 extern struct static_key_deferred apic_hw_disabled;
 
-static inline int kvm_apic_hw_enabled(struct kvm_lapic *apic)
+static inline int kvm_apic_hw_enabled(struct kvm_lapic *lapic)
 {
 	if (static_key_false(&apic_hw_disabled.key))
-		return apic->vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE;
+		return lapic->vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE;
 	return MSR_IA32_APICBASE_ENABLE;
 }
 
 extern struct static_key_deferred apic_sw_disabled;
 
-static inline bool kvm_apic_sw_enabled(struct kvm_lapic *apic)
+static inline bool kvm_apic_sw_enabled(struct kvm_lapic *lapic)
 {
 	if (static_key_false(&apic_sw_disabled.key))
-		return apic->sw_enabled;
+		return lapic->sw_enabled;
 	return true;
 }
 
@@ -209,9 +209,9 @@ static inline int kvm_lapic_enabled(struct kvm_vcpu *vcpu)
 	return kvm_apic_present(vcpu) && kvm_apic_sw_enabled(vcpu->arch.apic);
 }
 
-static inline int apic_x2apic_mode(struct kvm_lapic *apic)
+static inline int apic_x2apic_mode(struct kvm_lapic *lapic)
 {
-	return apic->vcpu->arch.apic_base & X2APIC_ENABLE;
+	return lapic->vcpu->arch.apic_base & X2APIC_ENABLE;
 }
 
 static inline bool kvm_vcpu_apicv_active(struct kvm_vcpu *vcpu)
@@ -258,9 +258,9 @@ static inline enum lapic_mode kvm_apic_mode(u64 apic_base)
 	return apic_base & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE);
 }
 
-static inline u8 kvm_xapic_id(struct kvm_lapic *apic)
+static inline u8 kvm_xapic_id(struct kvm_lapic *lapic)
 {
-	return kvm_lapic_get_reg(apic, APIC_ID) >> 24;
+	return kvm_lapic_get_reg(lapic, APIC_ID) >> 24;
 }
 
 #endif
-- 
2.27.0

