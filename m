Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA87364A75
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 18:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbfGJQHg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 12:07:36 -0400
Received: from mga12.intel.com ([192.55.52.136]:2784 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726617AbfGJQHg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 12:07:36 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jul 2019 09:07:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,475,1557212400"; 
   d="scan'208";a="341114424"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.165])
  by orsmga005.jf.intel.com with ESMTP; 10 Jul 2019 09:07:35 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Joerg Roedel <joro@8bytes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, Wei Yang <w90p710@gmail.com>
Subject: [PATCH] KVM: x86: Unconditionally enable irqs in guest context
Date:   Wed, 10 Jul 2019 09:07:34 -0700
Message-Id: <20190710160734.4559-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On VMX, KVM currently does not re-enable irqs until after it has exited
the guest context.  As a result, a tick that fires in the window between
VM-Exit and guest_exit_irqoff() will be accounted as system time.  While
said window is relatively small, it's large enough to be problematic in
some configurations, e.g. if VM-Exits are consistently occurring a hair
earlier than the tick irq.

Intentionally toggle irqs back off so that guest_exit_irqoff() can be
used in lieu of guest_exit() in order to avoid the save/restore of flags
in guest_exit().  On my Haswell system, "nop; cli; sti" is ~6 cycles,
versus ~28 cycles for "pushf; pop <reg>; cli; push <reg>; popf".

Fixes: f2485b3e0c6c0 ("KVM: x86: use guest_exit_irqoff")
Reported-by: Wei Yang <w90p710@gmail.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/svm.c | 10 +---------
 arch/x86/kvm/x86.c | 11 +++++++++++
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 5270711e787f..98b848fcf3e3 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6184,15 +6184,7 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
 
 static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 {
-	kvm_before_interrupt(vcpu);
-	local_irq_enable();
-	/*
-	 * We must have an instruction with interrupts enabled, so
-	 * the timer interrupt isn't delayed by the interrupt shadow.
-	 */
-	asm("nop");
-	local_irq_disable();
-	kvm_after_interrupt(vcpu);
+
 }
 
 static void svm_sched_in(struct kvm_vcpu *vcpu, int cpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2e302e977dac..32561032f7e6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8042,7 +8042,18 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	kvm_x86_ops->handle_exit_irqoff(vcpu);
 
+	/*
+	 * Consume any pending interrupts, including the possible source of
+	 * VM-Exit on SVM and any ticks that occur between VM-Exit and now.
+	 * An instruction is required after local_irq_enable() to fully unblock
+	 * interrupts on processors that implement an interrupt shadow, the
+	 * stat.exits increment will do nicely.
+	 */
+	kvm_before_interrupt(vcpu);
+	local_irq_enable();
 	++vcpu->stat.exits;
+	local_irq_disable();
+	kvm_after_interrupt(vcpu);
 
 	guest_exit_irqoff();
 	if (lapic_in_kernel(vcpu)) {
-- 
2.22.0

