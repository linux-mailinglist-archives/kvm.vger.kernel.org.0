Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C66430C396
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 16:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235374AbhBBPXE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 10:23:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54522 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235487AbhBBPU6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 10:20:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612279171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=g76jh33f4NR+DjXTaiYSmk+NWUD/OnphJvhWM605zNI=;
        b=YdVqbDRj2Y9bpPqlFHxe8rahfPhjUIBFkZIZw0v4bnhKlzzRrBrtbTwJzHh+dLEemtAuCF
        sAn7EWFiJje/J8mdS4z747uL91LZLsu8w/6xP2gm+Eu0CBFUqJP4OrK2+X0Kzc+NMnXXc4
        cBUNWIssjDmgvR46B34Vp5D89anqFY4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-69-YxK_xyFPOwO2BUcWfF-wSw-1; Tue, 02 Feb 2021 10:19:29 -0500
X-MC-Unique: YxK_xyFPOwO2BUcWfF-wSw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C7B3D1020C20;
        Tue,  2 Feb 2021 15:19:27 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 65D6719EF1;
        Tue,  2 Feb 2021 15:19:27 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Cun Li <cun.jia.li@gmail.com>
Subject: [PATCH v2] KVM: Stop using deprecated jump label APIs
Date:   Tue,  2 Feb 2021 10:19:26 -0500
Message-Id: <20210202151926.214916-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Cun Li <cun.jia.li@gmail.com>

The use of 'struct static_key' and 'static_key_false' is
deprecated. Use the new API.

Signed-off-by: Cun Li <cun.jia.li@gmail.com>
Message-Id: <20210111152435.50275-1-cun.jia.li@gmail.com>
[Make it compile.  While at it, rename kvm_no_apic_vcpu to
 kvm_has_noapic_vcpu; the former reads too much like "true if
 no vCPU has an APIC". - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/lapic.c         | 25 +++++++++----------------
 arch/x86/kvm/lapic.h         | 13 ++++++-------
 arch/x86/kvm/mmu/mmu_audit.c |  8 ++++----
 arch/x86/kvm/x86.c           |  9 ++++-----
 4 files changed, 23 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 43cceadd073e..87f6b5a5a272 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -91,8 +91,8 @@ static inline int __apic_test_and_clear_vector(int vec, void *bitmap)
 	return __test_and_clear_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
 }
 
-struct static_key_deferred apic_hw_disabled __read_mostly;
-struct static_key_deferred apic_sw_disabled __read_mostly;
+__read_mostly DEFINE_STATIC_KEY_DEFERRED_FALSE(apic_hw_disabled, HZ);
+__read_mostly DEFINE_STATIC_KEY_DEFERRED_FALSE(apic_sw_disabled, HZ);
 
 static inline int apic_enabled(struct kvm_lapic *apic)
 {
@@ -290,9 +290,9 @@ static inline void apic_set_spiv(struct kvm_lapic *apic, u32 val)
 	if (enabled != apic->sw_enabled) {
 		apic->sw_enabled = enabled;
 		if (enabled)
-			static_key_slow_dec_deferred(&apic_sw_disabled);
+			static_branch_slow_dec_deferred(&apic_sw_disabled);
 		else
-			static_key_slow_inc(&apic_sw_disabled.key);
+			static_branch_inc(&apic_sw_disabled.key);
 
 		atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
 	}
@@ -2175,10 +2175,10 @@ void kvm_free_lapic(struct kvm_vcpu *vcpu)
 	hrtimer_cancel(&apic->lapic_timer.timer);
 
 	if (!(vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE))
-		static_key_slow_dec_deferred(&apic_hw_disabled);
+		static_branch_slow_dec_deferred(&apic_hw_disabled);
 
 	if (!apic->sw_enabled)
-		static_key_slow_dec_deferred(&apic_sw_disabled);
+		static_branch_slow_dec_deferred(&apic_sw_disabled);
 
 	if (apic->regs)
 		free_page((unsigned long)apic->regs);
@@ -2250,9 +2250,9 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 	if ((old_value ^ value) & MSR_IA32_APICBASE_ENABLE) {
 		if (value & MSR_IA32_APICBASE_ENABLE) {
 			kvm_apic_set_xapic_id(apic, vcpu->vcpu_id);
-			static_key_slow_dec_deferred(&apic_hw_disabled);
+			static_branch_slow_dec_deferred(&apic_hw_disabled);
 		} else {
-			static_key_slow_inc(&apic_hw_disabled.key);
+			static_branch_inc(&apic_hw_disabled.key);
 			atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
 		}
 	}
@@ -2449,7 +2449,7 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
 	 * thinking that APIC state has changed.
 	 */
 	vcpu->arch.apic_base = MSR_IA32_APICBASE_ENABLE;
-	static_key_slow_inc(&apic_sw_disabled.key); /* sw disabled at reset */
+	static_branch_inc(&apic_sw_disabled.key); /* sw disabled at reset */
 	kvm_iodevice_init(&apic->dev, &apic_mmio_ops);
 
 	return 0;
@@ -2904,13 +2904,6 @@ void kvm_apic_accept_events(struct kvm_vcpu *vcpu)
 	}
 }
 
-void kvm_lapic_init(void)
-{
-	/* do not patch jump label more than once per second */
-	jump_label_rate_limit(&apic_hw_disabled, HZ);
-	jump_label_rate_limit(&apic_sw_disabled, HZ);
-}
-
 void kvm_lapic_exit(void)
 {
 	static_key_deferred_flush(&apic_hw_disabled);
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 4fb86e3a9dd3..ff4a7cc7d694 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -131,7 +131,6 @@ static inline bool kvm_hv_vapic_assist_page_enabled(struct kvm_vcpu *vcpu)
 }
 
 int kvm_lapic_enable_pv_eoi(struct kvm_vcpu *vcpu, u64 data, unsigned long len);
-void kvm_lapic_init(void);
 void kvm_lapic_exit(void);
 
 #define VEC_POS(v) ((v) & (32 - 1))
@@ -172,29 +171,29 @@ static inline void kvm_lapic_set_reg(struct kvm_lapic *apic, int reg_off, u32 va
 	__kvm_lapic_set_reg(apic->regs, reg_off, val);
 }
 
-extern struct static_key kvm_no_apic_vcpu;
+DECLARE_STATIC_KEY_FALSE(kvm_has_noapic_vcpu);
 
 static inline bool lapic_in_kernel(struct kvm_vcpu *vcpu)
 {
-	if (static_key_false(&kvm_no_apic_vcpu))
+	if (static_branch_unlikely(&kvm_has_noapic_vcpu))
 		return vcpu->arch.apic;
 	return true;
 }
 
-extern struct static_key_deferred apic_hw_disabled;
+extern struct static_key_false_deferred apic_hw_disabled;
 
 static inline int kvm_apic_hw_enabled(struct kvm_lapic *apic)
 {
-	if (static_key_false(&apic_hw_disabled.key))
+	if (static_branch_unlikely(&apic_hw_disabled.key))
 		return apic->vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE;
 	return MSR_IA32_APICBASE_ENABLE;
 }
 
-extern struct static_key_deferred apic_sw_disabled;
+extern struct static_key_false_deferred apic_sw_disabled;
 
 static inline bool kvm_apic_sw_enabled(struct kvm_lapic *apic)
 {
-	if (static_key_false(&apic_sw_disabled.key))
+	if (static_branch_unlikely(&apic_sw_disabled.key))
 		return apic->sw_enabled;
 	return true;
 }
diff --git a/arch/x86/kvm/mmu/mmu_audit.c b/arch/x86/kvm/mmu/mmu_audit.c
index c8d51a37e2ce..ced15fd58fde 100644
--- a/arch/x86/kvm/mmu/mmu_audit.c
+++ b/arch/x86/kvm/mmu/mmu_audit.c
@@ -234,7 +234,7 @@ static void audit_vcpu_spte(struct kvm_vcpu *vcpu)
 }
 
 static bool mmu_audit;
-static struct static_key mmu_audit_key;
+static DEFINE_STATIC_KEY_FALSE(mmu_audit_key);
 
 static void __kvm_mmu_audit(struct kvm_vcpu *vcpu, int point)
 {
@@ -250,7 +250,7 @@ static void __kvm_mmu_audit(struct kvm_vcpu *vcpu, int point)
 
 static inline void kvm_mmu_audit(struct kvm_vcpu *vcpu, int point)
 {
-	if (static_key_false((&mmu_audit_key)))
+	if (static_branch_unlikely((&mmu_audit_key)))
 		__kvm_mmu_audit(vcpu, point);
 }
 
@@ -259,7 +259,7 @@ static void mmu_audit_enable(void)
 	if (mmu_audit)
 		return;
 
-	static_key_slow_inc(&mmu_audit_key);
+	static_branch_inc(&mmu_audit_key);
 	mmu_audit = true;
 }
 
@@ -268,7 +268,7 @@ static void mmu_audit_disable(void)
 	if (!mmu_audit)
 		return;
 
-	static_key_slow_dec(&mmu_audit_key);
+	static_branch_dec(&mmu_audit_key);
 	mmu_audit = false;
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d8fa41a541a6..83b012bba4ef 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7970,7 +7970,6 @@ int kvm_arch_init(void *opaque)
 		supported_xcr0 = host_xcr0 & KVM_SUPPORTED_XCR0;
 	}
 
-	kvm_lapic_init();
 	if (pi_inject_timer == -1)
 		pi_inject_timer = housekeeping_enabled(HK_FLAG_TIMER);
 #ifdef CONFIG_X86_64
@@ -9992,7 +9991,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 		if (kvm_apicv_activated(vcpu->kvm))
 			vcpu->arch.apicv_active = true;
 	} else
-		static_key_slow_inc(&kvm_no_apic_vcpu);
+		static_branch_inc(&kvm_has_noapic_vcpu);
 
 	r = -ENOMEM;
 
@@ -10121,7 +10120,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	free_page((unsigned long)vcpu->arch.pio_data);
 	kvfree(vcpu->arch.cpuid_entries);
 	if (!lapic_in_kernel(vcpu))
-		static_key_slow_dec(&kvm_no_apic_vcpu);
+		static_branch_dec(&kvm_has_noapic_vcpu);
 }
 
 void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
@@ -10376,8 +10375,8 @@ bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu)
 	return (vcpu->arch.apic_base & MSR_IA32_APICBASE_BSP) != 0;
 }
 
-struct static_key kvm_no_apic_vcpu __read_mostly;
-EXPORT_SYMBOL_GPL(kvm_no_apic_vcpu);
+__read_mostly DEFINE_STATIC_KEY_FALSE(kvm_has_noapic_vcpu);
+EXPORT_SYMBOL_GPL(kvm_has_noapic_vcpu);
 
 void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
 {
-- 
2.26.2

