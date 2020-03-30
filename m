Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFAE919792D
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729271AbgC3KWE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:22:04 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:43786 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729241AbgC3KTy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:19:54 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 5CE69307489E;
        Mon, 30 Mar 2020 13:12:53 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 3EE5C305B7A1;
        Mon, 30 Mar 2020 13:12:53 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v8 30/81] KVM: x86: export kvm_inject_pending_exception()
Date:   Mon, 30 Mar 2020 13:12:17 +0300
Message-Id: <20200330101308.21702-31-alazar@bitdefender.com>
In-Reply-To: <20200330101308.21702-1-alazar@bitdefender.com>
References: <20200330101308.21702-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nicușor Cîțu <ncitu@bitdefender.com>

This function is needed for the KVMI_VCPU_INJECT_EXCEPTION command.

Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 71 ++++++++++++++++++---------------
 2 files changed, 39 insertions(+), 33 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 85d3c9c2983f..9772e07f8253 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1473,6 +1473,7 @@ unsigned long kvm_get_rflags(struct kvm_vcpu *vcpu);
 void kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
 bool kvm_rdpmc(struct kvm_vcpu *vcpu);
 
+void kvm_inject_pending_exception(struct kvm_vcpu *vcpu);
 void kvm_queue_exception(struct kvm_vcpu *vcpu, unsigned nr);
 void kvm_queue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
 void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned nr);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ed6eb1241cf1..328d6b8429a2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7636,6 +7636,43 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu)
 	kvm_x86_ops->update_cr8_intercept(vcpu, tpr, max_irr);
 }
 
+void kvm_inject_pending_exception(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->arch.exception.pending) {
+		trace_kvm_inj_exception(vcpu->arch.exception.nr,
+					vcpu->arch.exception.has_error_code,
+					vcpu->arch.exception.error_code);
+
+		WARN_ON_ONCE(vcpu->arch.exception.injected);
+		vcpu->arch.exception.pending = false;
+		vcpu->arch.exception.injected = true;
+
+		if (exception_type(vcpu->arch.exception.nr) == EXCPT_FAULT)
+			__kvm_set_rflags(vcpu, kvm_get_rflags(vcpu) |
+					     X86_EFLAGS_RF);
+
+		if (vcpu->arch.exception.nr == DB_VECTOR) {
+			/*
+			 * This code assumes that nSVM doesn't use
+			 * check_nested_events(). If it does, the
+			 * DR6/DR7 changes should happen before L1
+			 * gets a #VMEXIT for an intercepted #DB in
+			 * L2.  (Under VMX, on the other hand, the
+			 * DR6/DR7 changes should not happen in the
+			 * event of a VM-exit to L1 for an intercepted
+			 * #DB in L2.)
+			 */
+			kvm_deliver_exception_payload(vcpu);
+			if (vcpu->arch.dr7 & DR7_GD) {
+				vcpu->arch.dr7 &= ~DR7_GD;
+				kvm_update_dr7(vcpu);
+			}
+		}
+
+		kvm_x86_ops->queue_exception(vcpu);
+	}
+}
+
 static int inject_pending_event(struct kvm_vcpu *vcpu, bool req_int_win)
 {
 	int r;
@@ -7678,39 +7715,7 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool req_int_win)
 	}
 
 	/* try to inject new event if pending */
-	if (vcpu->arch.exception.pending) {
-		trace_kvm_inj_exception(vcpu->arch.exception.nr,
-					vcpu->arch.exception.has_error_code,
-					vcpu->arch.exception.error_code);
-
-		WARN_ON_ONCE(vcpu->arch.exception.injected);
-		vcpu->arch.exception.pending = false;
-		vcpu->arch.exception.injected = true;
-
-		if (exception_type(vcpu->arch.exception.nr) == EXCPT_FAULT)
-			__kvm_set_rflags(vcpu, kvm_get_rflags(vcpu) |
-					     X86_EFLAGS_RF);
-
-		if (vcpu->arch.exception.nr == DB_VECTOR) {
-			/*
-			 * This code assumes that nSVM doesn't use
-			 * check_nested_events(). If it does, the
-			 * DR6/DR7 changes should happen before L1
-			 * gets a #VMEXIT for an intercepted #DB in
-			 * L2.  (Under VMX, on the other hand, the
-			 * DR6/DR7 changes should not happen in the
-			 * event of a VM-exit to L1 for an intercepted
-			 * #DB in L2.)
-			 */
-			kvm_deliver_exception_payload(vcpu);
-			if (vcpu->arch.dr7 & DR7_GD) {
-				vcpu->arch.dr7 &= ~DR7_GD;
-				kvm_update_dr7(vcpu);
-			}
-		}
-
-		kvm_x86_ops->queue_exception(vcpu);
-	}
+	kvm_inject_pending_exception(vcpu);
 
 	/* Don't consider new event if we re-injected an event */
 	if (kvm_event_needs_reinjection(vcpu))
