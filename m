Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0A0E2C3CBC
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 10:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728788AbgKYJmz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 04:42:55 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:57330 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727611AbgKYJl7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Nov 2020 04:41:59 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 9CEF0305D50A;
        Wed, 25 Nov 2020 11:35:46 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 7D9813072784;
        Wed, 25 Nov 2020 11:35:46 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v10 24/81] KVM: x86: export kvm_inject_pending_exception()
Date:   Wed, 25 Nov 2020 11:35:03 +0200
Message-Id: <20201125093600.2766-25-alazar@bitdefender.com>
In-Reply-To: <20201125093600.2766-1-alazar@bitdefender.com>
References: <20201125093600.2766-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nicușor Cîțu <nicu.citu@icloud.com>

This function is needed for the KVMI_VCPU_INJECT_EXCEPTION command.

Signed-off-by: Nicușor Cîțu <nicu.citu@icloud.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 52 +++++++++++++++++++--------------
 2 files changed, 31 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3a06a7799571..7dc1ebac8d91 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1514,6 +1514,7 @@ unsigned long kvm_get_rflags(struct kvm_vcpu *vcpu);
 void kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
 bool kvm_rdpmc(struct kvm_vcpu *vcpu);
 
+bool kvm_inject_pending_exception(struct kvm_vcpu *vcpu);
 void kvm_queue_exception(struct kvm_vcpu *vcpu, unsigned nr);
 void kvm_queue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
 void kvm_queue_exception_p(struct kvm_vcpu *vcpu, unsigned nr, unsigned long payload);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8eda5c3bd244..741505f405b1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8200,6 +8200,35 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu)
 	kvm_x86_ops.update_cr8_intercept(vcpu, tpr, max_irr);
 }
 
+bool kvm_inject_pending_exception(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->arch.exception.pending) {
+		trace_kvm_inj_exception(vcpu->arch.exception.nr,
+					vcpu->arch.exception.has_error_code,
+					vcpu->arch.exception.error_code);
+
+		vcpu->arch.exception.pending = false;
+		vcpu->arch.exception.injected = true;
+
+		if (exception_type(vcpu->arch.exception.nr) == EXCPT_FAULT)
+			__kvm_set_rflags(vcpu, kvm_get_rflags(vcpu) |
+					     X86_EFLAGS_RF);
+
+		if (vcpu->arch.exception.nr == DB_VECTOR) {
+			kvm_deliver_exception_payload(vcpu);
+			if (vcpu->arch.dr7 & DR7_GD) {
+				vcpu->arch.dr7 &= ~DR7_GD;
+				kvm_update_dr7(vcpu);
+			}
+		}
+
+		kvm_x86_ops.queue_exception(vcpu);
+		return true;
+	}
+
+	return false;
+}
+
 static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
 {
 	int r;
@@ -8251,29 +8280,8 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 	}
 
 	/* try to inject new event if pending */
-	if (vcpu->arch.exception.pending) {
-		trace_kvm_inj_exception(vcpu->arch.exception.nr,
-					vcpu->arch.exception.has_error_code,
-					vcpu->arch.exception.error_code);
-
-		vcpu->arch.exception.pending = false;
-		vcpu->arch.exception.injected = true;
-
-		if (exception_type(vcpu->arch.exception.nr) == EXCPT_FAULT)
-			__kvm_set_rflags(vcpu, kvm_get_rflags(vcpu) |
-					     X86_EFLAGS_RF);
-
-		if (vcpu->arch.exception.nr == DB_VECTOR) {
-			kvm_deliver_exception_payload(vcpu);
-			if (vcpu->arch.dr7 & DR7_GD) {
-				vcpu->arch.dr7 &= ~DR7_GD;
-				kvm_update_dr7(vcpu);
-			}
-		}
-
-		kvm_x86_ops.queue_exception(vcpu);
+	if (kvm_inject_pending_exception(vcpu))
 		can_inject = false;
-	}
 
 	/*
 	 * Finally, inject interrupt events.  If an event cannot be injected
