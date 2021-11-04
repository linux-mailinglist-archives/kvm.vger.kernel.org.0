Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92347445291
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 12:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbhKDL65 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Nov 2021 07:58:57 -0400
Received: from mx417.baidu.com ([124.64.200.157]:1797 "EHLO mx421.baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229505AbhKDL6z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Nov 2021 07:58:55 -0400
Received: from bjhw-sys-rpm015653cc5.bjhw.baidu.com (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
        by mx421.baidu.com (Postfix) with ESMTP id 106452F0055D;
        Thu,  4 Nov 2021 19:56:15 +0800 (CST)
Received: from localhost (localhost [127.0.0.1])
        by bjhw-sys-rpm015653cc5.bjhw.baidu.com (Postfix) with ESMTP id EAB83D9933;
        Thu,  4 Nov 2021 19:56:14 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, lirongqing@baidu.com, stable@kernel.org
Subject: [v4][PATCH 2/2] KVM: Clear pv eoi pending bit only when it is set
Date:   Thu,  4 Nov 2021 19:56:14 +0800
Message-Id: <1636026974-50555-2-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1636026974-50555-1-git-send-email-lirongqing@baidu.com>
References: <1636026974-50555-1-git-send-email-lirongqing@baidu.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

merge pv_eoi_get_pending and pv_eoi_clr_pending into a single
function pv_eoi_test_and_clear_pending, which returns and clear
the value of the pending bit.

and clear pv eoi pending bit only when it is set, to avoid calling
pv_eoi_put_user(), this can speed about 300 nsec on AMD EPYC most
of the time

Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
diff v2: merge as pv_eoi_test_and_clear_pending
diff v3: remove printk in a new patch
diff v4: fix comments place
 arch/x86/kvm/lapic.c |   40 +++++++++++++++++++---------------------
 1 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 752c48e..b1de23e 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -673,15 +673,6 @@ static inline bool pv_eoi_enabled(struct kvm_vcpu *vcpu)
 	return vcpu->arch.pv_eoi.msr_val & KVM_MSR_ENABLED;
 }
 
-static bool pv_eoi_get_pending(struct kvm_vcpu *vcpu)
-{
-	u8 val;
-	if (pv_eoi_get_user(vcpu, &val) < 0)
-		return false;
-
-	return val & KVM_PV_EOI_ENABLED;
-}
-
 static void pv_eoi_set_pending(struct kvm_vcpu *vcpu)
 {
 	if (pv_eoi_put_user(vcpu, KVM_PV_EOI_ENABLED) < 0)
@@ -690,12 +681,26 @@ static void pv_eoi_set_pending(struct kvm_vcpu *vcpu)
 	__set_bit(KVM_APIC_PV_EOI_PENDING, &vcpu->arch.apic_attention);
 }
 
-static void pv_eoi_clr_pending(struct kvm_vcpu *vcpu)
+static bool pv_eoi_test_and_clr_pending(struct kvm_vcpu *vcpu)
 {
-	if (pv_eoi_put_user(vcpu, KVM_PV_EOI_DISABLED) < 0)
-		return;
+	u8 val;
+
+	if (pv_eoi_get_user(vcpu, &val) < 0)
+		return false;
+
+	val &= KVM_PV_EOI_ENABLED;
+
+	if (val && pv_eoi_put_user(vcpu, KVM_PV_EOI_DISABLED) < 0)
+		return false;
 
+	/*
+	 * Clear pending bit in any case: it will be set again on vmentry.
+	 * While this might not be ideal from performance point of view,
+	 * this makes sure pv eoi is only enabled when we know it's safe.
+	 */
 	__clear_bit(KVM_APIC_PV_EOI_PENDING, &vcpu->arch.apic_attention);
+
+	return val;
 }
 
 static int apic_has_interrupt_for_ppr(struct kvm_lapic *apic, u32 ppr)
@@ -2671,7 +2676,6 @@ void __kvm_migrate_apic_timer(struct kvm_vcpu *vcpu)
 static void apic_sync_pv_eoi_from_guest(struct kvm_vcpu *vcpu,
 					struct kvm_lapic *apic)
 {
-	bool pending;
 	int vector;
 	/*
 	 * PV EOI state is derived from KVM_APIC_PV_EOI_PENDING in host
@@ -2685,14 +2689,8 @@ static void apic_sync_pv_eoi_from_guest(struct kvm_vcpu *vcpu,
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

