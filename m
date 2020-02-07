Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25B4A155D7B
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgBGSQl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:16:41 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40562 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726988AbgBGSQk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:40 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id B853B305D489;
        Fri,  7 Feb 2020 20:16:38 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 7B5B63052067;
        Fri,  7 Feb 2020 20:16:38 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 04/78] KVM: add kvm_vcpu_kick_and_wait()
Date:   Fri,  7 Feb 2020 20:15:22 +0200
Message-Id: <20200207181636.1065-5-alazar@bitdefender.com>
In-Reply-To: <20200207181636.1065-1-alazar@bitdefender.com>
References: <20200207181636.1065-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This function is needed for the KVMI_VCPU_PAUSE command. There are
cases when it is easier for the introspection tool if it knows that
the vCPU doesn't run guest code when the command completed, without
the need to wait for the KVMI_EVENT_PAUSE_VCPU event.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7ed1e2f8641e..2fb276655cc2 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -799,6 +799,7 @@ void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu);
 bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu);
 void kvm_vcpu_kick(struct kvm_vcpu *vcpu);
+void kvm_vcpu_kick_and_wait(struct kvm_vcpu *vcpu);
 int kvm_vcpu_yield_to(struct kvm_vcpu *target);
 void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool usermode_vcpu_not_eligible);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 00268290dcbd..ab66d5a08581 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2498,6 +2498,16 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 EXPORT_SYMBOL_GPL(kvm_vcpu_kick);
 #endif /* !CONFIG_S390 */
 
+void kvm_vcpu_kick_and_wait(struct kvm_vcpu *vcpu)
+{
+	if (kvm_vcpu_wake_up(vcpu))
+		return;
+
+	if (kvm_request_needs_ipi(vcpu, KVM_REQUEST_WAIT))
+		smp_call_function_single(vcpu->cpu, ack_flush, NULL, 1);
+}
+EXPORT_SYMBOL_GPL(kvm_vcpu_kick_and_wait);
+
 int kvm_vcpu_yield_to(struct kvm_vcpu *target)
 {
 	struct pid *pid;
