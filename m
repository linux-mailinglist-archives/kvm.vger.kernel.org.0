Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90DB7432BAC
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 04:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbhJSCIB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 22:08:01 -0400
Received: from mx316.baidu.com ([180.101.52.236]:12585 "EHLO
        njjs-sys-mailin05.njjs.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230016AbhJSCIA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Oct 2021 22:08:00 -0400
Received: from bjhw-sys-rpm015653cc5.bjhw.baidu.com (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
        by njjs-sys-mailin05.njjs.baidu.com (Postfix) with ESMTP id 96539CF8003F;
        Tue, 19 Oct 2021 10:05:44 +0800 (CST)
Received: from localhost (localhost [127.0.0.1])
        by bjhw-sys-rpm015653cc5.bjhw.baidu.com (Postfix) with ESMTP id 7279ED9932;
        Tue, 19 Oct 2021 10:05:44 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     lirongqing@baidu.com, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org
Subject: [PATCH] KVM: Clear pv eoi pending bit only when it is set
Date:   Tue, 19 Oct 2021 10:05:44 +0800
Message-Id: <1634609144-28952-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

clear pv eoi pending bit only when it is set, to avoid calling
pv_eoi_put_user()

and this can speed pv_eoi_clr_pending about 300 nsec on AMD EPYC
most of the time

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 arch/x86/kvm/lapic.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 76fb009..c434f70 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -694,9 +694,9 @@ static void pv_eoi_set_pending(struct kvm_vcpu *vcpu)
 	__set_bit(KVM_APIC_PV_EOI_PENDING, &vcpu->arch.apic_attention);
 }
 
-static void pv_eoi_clr_pending(struct kvm_vcpu *vcpu)
+static void pv_eoi_clr_pending(struct kvm_vcpu *vcpu, bool pending)
 {
-	if (pv_eoi_put_user(vcpu, KVM_PV_EOI_DISABLED) < 0) {
+	if (pending && pv_eoi_put_user(vcpu, KVM_PV_EOI_DISABLED) < 0) {
 		printk(KERN_WARNING "Can't clear EOI MSR value: 0x%llx\n",
 			   (unsigned long long)vcpu->arch.pv_eoi.msr_val);
 		return;
@@ -2693,7 +2693,8 @@ static void apic_sync_pv_eoi_from_guest(struct kvm_vcpu *vcpu,
 	 * While this might not be ideal from performance point of view,
 	 * this makes sure pv eoi is only enabled when we know it's safe.
 	 */
-	pv_eoi_clr_pending(vcpu);
+	pv_eoi_clr_pending(vcpu, pending);
+
 	if (pending)
 		return;
 	vector = apic_set_eoi(apic);
-- 
1.7.1

