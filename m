Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 520EB24D0F
	for <lists+kvm@lfdr.de>; Tue, 21 May 2019 12:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbfEUKof (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 May 2019 06:44:35 -0400
Received: from mga05.intel.com ([192.55.52.43]:45533 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726296AbfEUKof (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 May 2019 06:44:35 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 May 2019 03:44:35 -0700
X-ExtLoop1: 1
Received: from skl-s2.bj.intel.com ([10.240.192.109])
  by orsmga006.jf.intel.com with ESMTP; 21 May 2019 03:44:32 -0700
From:   Luwei Kang <luwei.kang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org,
        Luwei Kang <luwei.kang@intel.com>
Subject: [PATCH] KVM: LAPIC: Do not mask the local interrupts when LAPIC is sw disabled
Date:   Tue, 21 May 2019 18:44:15 +0800
Message-Id: <1558435455-233679-1-git-send-email-luwei.kang@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The current code will mask all the local interrupts in the local
vector table when the LAPIC is disabled by SVR (Spurious-Interrupt
Vector Register) "APIC Software Enable/Disable" flag (bit8).
This may block local interrupt be delivered to target vCPU
even if LAPIC is enabled by set SVR (bit8 == 1) after.

For example, reset vCPU will mask all the local interrupts and
set the SVR to default value FFH (LAPIC is disabled because
SVR[bit8] == 0). Guest may try to enable some local interrupts
(e.g. LVTPC) by clear bit16 of LVT entry before enable LAPIC.
But bit16 can't be cleared when LAPIC is "software disabled"
and this local interrupt still disabled after LAPIC "software
enabled".

This patch will not mask the local interrupts when LAPIC
is "software disabled" and add LAPIC "software enabled" checking
before deliver local interrupt.

Signed-off-by: Luwei Kang <luwei.kang@intel.com>
---
 arch/x86/kvm/lapic.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index fcf42a3..a199f47 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1892,15 +1892,6 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 			mask |= APIC_SPIV_DIRECTED_EOI;
 		apic_set_spiv(apic, val & mask);
 		if (!(val & APIC_SPIV_APIC_ENABLED)) {
-			int i;
-			u32 lvt_val;
-
-			for (i = 0; i < KVM_APIC_LVT_NUM; i++) {
-				lvt_val = kvm_lapic_get_reg(apic,
-						       APIC_LVTT + 0x10 * i);
-				kvm_lapic_set_reg(apic, APIC_LVTT + 0x10 * i,
-					     lvt_val | APIC_LVT_MASKED);
-			}
 			apic_update_lvtt(apic);
 			atomic_set(&apic->lapic_timer.pending, 0);
 
@@ -1926,18 +1917,12 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 	case APIC_LVTPC:
 	case APIC_LVT1:
 	case APIC_LVTERR:
-		/* TODO: Check vector */
-		if (!kvm_apic_sw_enabled(apic))
-			val |= APIC_LVT_MASKED;
-
 		val &= apic_lvt_mask[(reg - APIC_LVTT) >> 4];
 		kvm_lapic_set_reg(apic, reg, val);
 
 		break;
 
 	case APIC_LVTT:
-		if (!kvm_apic_sw_enabled(apic))
-			val |= APIC_LVT_MASKED;
 		val &= (apic_lvt_mask[0] | apic->lapic_timer.timer_mode_mask);
 		kvm_lapic_set_reg(apic, APIC_LVTT, val);
 		apic_update_lvtt(apic);
@@ -2260,7 +2245,7 @@ int kvm_apic_local_deliver(struct kvm_lapic *apic, int lvt_type)
 	u32 reg = kvm_lapic_get_reg(apic, lvt_type);
 	int vector, mode, trig_mode;
 
-	if (kvm_apic_hw_enabled(apic) && !(reg & APIC_LVT_MASKED)) {
+	if (apic_enabled(apic) && !(reg & APIC_LVT_MASKED)) {
 		vector = reg & APIC_VECTOR_MASK;
 		mode = reg & APIC_MODE_MASK;
 		trig_mode = reg & APIC_LVT_LEVEL_TRIGGER;
@@ -2363,7 +2348,7 @@ int kvm_apic_accept_pic_intr(struct kvm_vcpu *vcpu)
 	u32 lvt0 = kvm_lapic_get_reg(vcpu->arch.apic, APIC_LVT0);
 	int r = 0;
 
-	if (!kvm_apic_hw_enabled(vcpu->arch.apic))
+	if (!apic_enabled(vcpu->arch.apic))
 		r = 1;
 	if ((lvt0 & APIC_LVT_MASKED) == 0 &&
 	    GET_APIC_DELIVERY_MODE(lvt0) == APIC_MODE_EXTINT)
-- 
1.8.3.1

