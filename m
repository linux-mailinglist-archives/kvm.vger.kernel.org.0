Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3C251415A3
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2020 03:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730624AbgARCsk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jan 2020 21:48:40 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9650 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727033AbgARCsk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jan 2020 21:48:40 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 5BAB225DD03BC25FCAAC;
        Sat, 18 Jan 2020 10:48:37 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Sat, 18 Jan 2020
 10:48:29 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH] KVM: apic: short-circuit kvm_apic_accept_pic_intr() when pic intr is accepted
Date:   Sat, 18 Jan 2020 10:50:37 +0800
Message-ID: <1579315837-15994-1-git-send-email-linmiaohe@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.105.18]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

Short-circuit kvm_apic_accept_pic_intr() when pic intr is accepted, there
is no need to proceed further. Also remove unnecessary var r.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 arch/x86/kvm/lapic.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 679692b55f6d..502c7b0d8fdb 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2370,14 +2370,13 @@ int kvm_apic_has_interrupt(struct kvm_vcpu *vcpu)
 int kvm_apic_accept_pic_intr(struct kvm_vcpu *vcpu)
 {
 	u32 lvt0 = kvm_lapic_get_reg(vcpu->arch.apic, APIC_LVT0);
-	int r = 0;
 
 	if (!kvm_apic_hw_enabled(vcpu->arch.apic))
-		r = 1;
+		return 1;
 	if ((lvt0 & APIC_LVT_MASKED) == 0 &&
 	    GET_APIC_DELIVERY_MODE(lvt0) == APIC_MODE_EXTINT)
-		r = 1;
-	return r;
+		return 1;
+	return 0;
 }
 
 void kvm_inject_apic_timer_irqs(struct kvm_vcpu *vcpu)
-- 
2.19.1

