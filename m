Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C377362695
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2019 18:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732123AbfGHQr7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jul 2019 12:47:59 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:36564 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726318AbfGHQr7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Jul 2019 12:47:59 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=wei.yang1@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0TWPHB0h_1562604471;
Received: from localhost(mailfrom:wei.yang1@linux.alibaba.com fp:SMTPD_---0TWPHB0h_1562604471)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 09 Jul 2019 00:47:51 +0800
From:   Wei Yang <w90p710@gmail.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH] KVM: x86: Fix guest time accounting with VIRT_CPU_ACCOUNTING_GEN
Date:   Tue,  9 Jul 2019 00:47:51 +0800
Message-Id: <20190708164751.88385-1-w90p710@gmail.com>
X-Mailer: git-send-email 2.14.1.40.g8e62ba1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

move guest_exit() after local_irq_eanbled() so that the timer interrupt
hits we account that tick as spent in the guest.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Wei Yang <w90p710@gmail.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2e302e977dac..04a2913f9226 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8044,7 +8044,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	++vcpu->stat.exits;
 
-	guest_exit_irqoff();
 	if (lapic_in_kernel(vcpu)) {
 		s64 delta = vcpu->arch.apic->lapic_timer.advance_expire_delta;
 		if (delta != S64_MIN) {
@@ -8054,6 +8053,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	}
 
 	local_irq_enable();
+	guest_exit();
 	preempt_enable();
 
 	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
-- 
2.14.1.40.g8e62ba1

