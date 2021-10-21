Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37439435AD6
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 08:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbhJUG1g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 02:27:36 -0400
Received: from [119.249.100.165] ([119.249.100.165]:58004 "EHLO
        mx425.baidu.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229765AbhJUG1f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 02:27:35 -0400
Received: from bjhw-sys-rpm015653cc5.bjhw.baidu.com (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
        by mx425.baidu.com (Postfix) with ESMTP id 30E5212581B8A;
        Thu, 21 Oct 2021 14:25:13 +0800 (CST)
Received: from localhost (localhost [127.0.0.1])
        by bjhw-sys-rpm015653cc5.bjhw.baidu.com (Postfix) with ESMTP id 24D7AD9932;
        Thu, 21 Oct 2021 14:25:13 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     lirongqing@baidu.com, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org
Subject: [PATCH][v2] KVM: Clear pv eoi pending bit only when it is set
Date:   Thu, 21 Oct 2021 14:25:13 +0800
Message-Id: <1634797513-11005-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

merge pv_eoi_get_pending and pv_eoi_clr_pending into a single
function pv_eoi_test_and_clear_pending, which returns and clear
the value of the pending bit.

and clear pv eoi pending bit only when it is set, to avoid calling
pv_eoi_put_user(), this can speed about 300 nsec on AMD EPYC most
of the time

and make pv_eoi_set_pending as inline as there is only one user

Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
diff with v1:
 merge as pv_eoi_test_and_clear_pending
 add inline for pv_eoi_set_pending

 arch/x86/kvm/lapic.c |   47 +++++++++++++++++++++++------------------------
 1 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 76fb009..4da5db8 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -673,18 +673,7 @@ static inline bool pv_eoi_enabled(struct kvm_vcpu *vcpu)
 	return vcpu->arch.pv_eoi.msr_val & KVM_MSR_ENABLED;
 }
 
-static bool pv_eoi_get_pending(struct kvm_vcpu *vcpu)
-{
-	u8 val;
-	if (pv_eoi_get_user(vcpu, &val) < 0) {
-		printk(KERN_WARNING "Can't read EOI MSR value: 0x%llx\n",
-			   (unsigned long long)vcpu->arch.pv_eoi.msr_val);
-		return false;
-	}
-	return val & KVM_PV_EOI_ENABLED;
-}
-
-static void pv_eoi_set_pending(struct kvm_vcpu *vcpu)
+static inline void pv_eoi_set_pending(struct kvm_vcpu *vcpu)
 {
 	if (pv_eoi_put_user(vcpu, KVM_PV_EOI_ENABLED) < 0) {
 		printk(KERN_WARNING "Can't set EOI MSR value: 0x%llx\n",
@@ -694,14 +683,31 @@ static void pv_eoi_set_pending(struct kvm_vcpu *vcpu)
 	__set_bit(KVM_APIC_PV_EOI_PENDING, &vcpu->arch.apic_attention);
 }
 
-static void pv_eoi_clr_pending(struct kvm_vcpu *vcpu)
+static inline bool pv_eoi_test_and_clr_pending(struct kvm_vcpu *vcpu)
 {
-	if (pv_eoi_put_user(vcpu, KVM_PV_EOI_DISABLED) < 0) {
+	u8 val;
+
+	if (pv_eoi_get_user(vcpu, &val) < 0) {
+		printk(KERN_WARNING "Can't read EOI MSR value: 0x%llx\n",
+			   (unsigned long long)vcpu->arch.pv_eoi.msr_val);
+		return false;
+	}
+
+	val &= KVM_PV_EOI_ENABLED;
+
+	/*
+	 * Clear pending bit in any case: it will be set again on vmentry.
+	 * While this might not be ideal from performance point of view,
+	 * this makes sure pv eoi is only enabled when we know it's safe.
+	 */
+	if (val && pv_eoi_put_user(vcpu, KVM_PV_EOI_DISABLED) < 0) {
 		printk(KERN_WARNING "Can't clear EOI MSR value: 0x%llx\n",
 			   (unsigned long long)vcpu->arch.pv_eoi.msr_val);
-		return;
+		return false;
 	}
 	__clear_bit(KVM_APIC_PV_EOI_PENDING, &vcpu->arch.apic_attention);
+
+	return !!val;
 }
 
 static int apic_has_interrupt_for_ppr(struct kvm_lapic *apic, u32 ppr)
@@ -2673,7 +2679,6 @@ void __kvm_migrate_apic_timer(struct kvm_vcpu *vcpu)
 static void apic_sync_pv_eoi_from_guest(struct kvm_vcpu *vcpu,
 					struct kvm_lapic *apic)
 {
-	bool pending;
 	int vector;
 	/*
 	 * PV EOI state is derived from KVM_APIC_PV_EOI_PENDING in host
@@ -2687,14 +2692,8 @@ static void apic_sync_pv_eoi_from_guest(struct kvm_vcpu *vcpu,
 	 * 	-> host enabled PV EOI, guest executed EOI.
 	 */
 	BUG_ON(!pv_eoi_enabled(vcpu));
-	pending = pv_eoi_get_pending(vcpu);
-	/*
-	 * Clear pending bit in any case: it will be set again on vmentry.
-	 * While this might not be ideal from performance point of view,
-	 * this makes sure pv eoi is only enabled when we know it's safe.
-	 */
-	pv_eoi_clr_pending(vcpu);
-	if (pending)
+
+	if (pv_eoi_test_and_clr_pending(vcpu))
 		return;
 	vector = apic_set_eoi(apic);
 	trace_kvm_pv_eoi(apic, vector);
-- 
1.7.1

