Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA8D21B527A
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 04:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbgDWC0y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 22:26:54 -0400
Received: from mga06.intel.com ([134.134.136.31]:33065 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726541AbgDWCZ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 22:25:56 -0400
IronPort-SDR: 4pefOQtHnSjUXkk6rEKj5Z2PuGaHLh0pZSCrCDfVy0pe1ZoS/PsE9iSDVij3lynAdEZ3hiTnmZ
 0NGBFI1RvJkw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2020 19:25:55 -0700
IronPort-SDR: UjKYGvDlp6USocJXccboeEzgMSiDuFUu03zbK1ScOPedwGhoa2Uc+X5D2L4fy9uMoFKq5Nm4+3
 rmyc3bUVzv3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,305,1583222400"; 
   d="scan'208";a="259273967"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 22 Apr 2020 19:25:54 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Subject: [PATCH 12/13] KVM: x86: Replace late check_nested_events() hack with more precise fix
Date:   Wed, 22 Apr 2020 19:25:49 -0700
Message-Id: <20200423022550.15113-13-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200423022550.15113-1-sean.j.christopherson@intel.com>
References: <20200423022550.15113-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a separate hook for checking if interrupt injection is blocked and
use the hook to handle the case where an interrupt arrives between
check_nested_events() and the injection logic.  Drop the retry of
check_nested_events() that hack-a-fixed the same condition.

Blocking injection is also a bit of a hack, e.g. KVM should do exiting
and non-exiting interrupt processing in a single pass, but it's a more
precise hack.  The old comment is also misleading, e.g. KVM_REQ_EVENT is
purely an optimization, setting it on every run loop (which KVM doesn't
do) should not affect functionality, only performance.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm/svm.c          |  1 +
 arch/x86/kvm/vmx/vmx.c          | 13 +++++++++++++
 arch/x86/kvm/x86.c              | 22 ++++------------------
 4 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 787636acd648..16fdeddb4a65 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1140,6 +1140,7 @@ struct kvm_x86_ops {
 	void (*queue_exception)(struct kvm_vcpu *vcpu);
 	void (*cancel_injection)(struct kvm_vcpu *vcpu);
 	bool (*interrupt_allowed)(struct kvm_vcpu *vcpu);
+	bool (*interrupt_injection_allowed)(struct kvm_vcpu *vcpu);
 	bool (*nmi_allowed)(struct kvm_vcpu *vcpu);
 	bool (*get_nmi_mask)(struct kvm_vcpu *vcpu);
 	void (*set_nmi_mask)(struct kvm_vcpu *vcpu, bool masked);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f21f734861dd..6d3ccbfc9e6a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3993,6 +3993,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.queue_exception = svm_queue_exception,
 	.cancel_injection = svm_cancel_injection,
 	.interrupt_allowed = svm_interrupt_allowed,
+	.interrupt_injection_allowed = svm_interrupt_allowed,
 	.nmi_allowed = svm_nmi_allowed,
 	.get_nmi_mask = svm_get_nmi_mask,
 	.set_nmi_mask = svm_set_nmi_mask,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2f8cacb3aa9b..68b3748b5383 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4550,6 +4550,18 @@ static bool vmx_interrupt_allowed(struct kvm_vcpu *vcpu)
 	return !vmx_interrupt_blocked(vcpu);
 }
 
+static bool vmx_interrupt_injection_allowed(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * An IRQ must not be injected into L2 if it's supposed to VM-Exit,
+	 * e.g. if the IRQ arrived asynchronously after checking nested events.
+	 */
+	if (is_guest_mode(vcpu) && nested_exit_on_intr(vcpu))
+		return false;
+
+	return vmx_interrupt_allowed(vcpu);
+}
+
 static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr)
 {
 	int ret;
@@ -7823,6 +7835,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.queue_exception = vmx_queue_exception,
 	.cancel_injection = vmx_cancel_injection,
 	.interrupt_allowed = vmx_interrupt_allowed,
+	.interrupt_injection_allowed = vmx_interrupt_injection_allowed,
 	.nmi_allowed = vmx_nmi_allowed,
 	.get_nmi_mask = vmx_get_nmi_mask,
 	.set_nmi_mask = vmx_set_nmi_mask,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7c49a7dc601f..d9d6028a77e0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7755,24 +7755,10 @@ static int inject_pending_event(struct kvm_vcpu *vcpu)
 		--vcpu->arch.nmi_pending;
 		vcpu->arch.nmi_injected = true;
 		kvm_x86_ops.set_nmi(vcpu);
-	} else if (kvm_cpu_has_injectable_intr(vcpu)) {
-		/*
-		 * Because interrupts can be injected asynchronously, we are
-		 * calling check_nested_events again here to avoid a race condition.
-		 * See https://lkml.org/lkml/2014/7/2/60 for discussion about this
-		 * proposal and current concerns.  Perhaps we should be setting
-		 * KVM_REQ_EVENT only on certain events and not unconditionally?
-		 */
-		if (is_guest_mode(vcpu) && kvm_x86_ops.check_nested_events) {
-			r = kvm_x86_ops.check_nested_events(vcpu);
-			if (r != 0)
-				return r;
-		}
-		if (kvm_x86_ops.interrupt_allowed(vcpu)) {
-			kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu),
-					    false);
-			kvm_x86_ops.set_irq(vcpu);
-		}
+	} else if (kvm_cpu_has_injectable_intr(vcpu) &&
+		   kvm_x86_ops.interrupt_injection_allowed(vcpu)) {
+		kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu), false);
+		kvm_x86_ops.set_irq(vcpu);
 	}
 
 	return 0;
-- 
2.26.0

