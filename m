Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A61A445292
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 12:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbhKDL66 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Nov 2021 07:58:58 -0400
Received: from mx411.baidu.com ([124.64.200.154]:32229 "EHLO mx423.baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229705AbhKDL6z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Nov 2021 07:58:55 -0400
Received: from bjhw-sys-rpm015653cc5.bjhw.baidu.com (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
        by mx423.baidu.com (Postfix) with ESMTP id EFB4516E00629;
        Thu,  4 Nov 2021 19:56:14 +0800 (CST)
Received: from localhost (localhost [127.0.0.1])
        by bjhw-sys-rpm015653cc5.bjhw.baidu.com (Postfix) with ESMTP id 584C4D9932;
        Thu,  4 Nov 2021 19:56:14 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, lirongqing@baidu.com, stable@kernel.org
Subject: [v4][PATCH 1/2] KVM: x86: don't print when fail to read/write pv eoi memory
Date:   Thu,  4 Nov 2021 19:56:13 +0800
Message-Id: <1636026974-50555-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If guest gives MSR_KVM_PV_EOI_EN a wrong value, this printk() will
be trigged, and kernel log is spammed with the useless message

Fixes: 0d88800d5472 ("kvm: x86: ioapic and apic debug macros cleanup")
Reported-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Cc: stable@kernel.org
---
 arch/x86/kvm/lapic.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index d6ac32f..752c48e 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -676,31 +676,25 @@ static inline bool pv_eoi_enabled(struct kvm_vcpu *vcpu)
 static bool pv_eoi_get_pending(struct kvm_vcpu *vcpu)
 {
 	u8 val;
-	if (pv_eoi_get_user(vcpu, &val) < 0) {
-		printk(KERN_WARNING "Can't read EOI MSR value: 0x%llx\n",
-			   (unsigned long long)vcpu->arch.pv_eoi.msr_val);
+	if (pv_eoi_get_user(vcpu, &val) < 0)
 		return false;
-	}
+
 	return val & KVM_PV_EOI_ENABLED;
 }
 
 static void pv_eoi_set_pending(struct kvm_vcpu *vcpu)
 {
-	if (pv_eoi_put_user(vcpu, KVM_PV_EOI_ENABLED) < 0) {
-		printk(KERN_WARNING "Can't set EOI MSR value: 0x%llx\n",
-			   (unsigned long long)vcpu->arch.pv_eoi.msr_val);
+	if (pv_eoi_put_user(vcpu, KVM_PV_EOI_ENABLED) < 0)
 		return;
-	}
+
 	__set_bit(KVM_APIC_PV_EOI_PENDING, &vcpu->arch.apic_attention);
 }
 
 static void pv_eoi_clr_pending(struct kvm_vcpu *vcpu)
 {
-	if (pv_eoi_put_user(vcpu, KVM_PV_EOI_DISABLED) < 0) {
-		printk(KERN_WARNING "Can't clear EOI MSR value: 0x%llx\n",
-			   (unsigned long long)vcpu->arch.pv_eoi.msr_val);
+	if (pv_eoi_put_user(vcpu, KVM_PV_EOI_DISABLED) < 0)
 		return;
-	}
+
 	__clear_bit(KVM_APIC_PV_EOI_PENDING, &vcpu->arch.apic_attention);
 }
 
-- 
1.7.1

