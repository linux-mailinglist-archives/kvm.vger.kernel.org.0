Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9861B579E
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 11:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgDWJCB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 05:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgDWJCA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 05:02:00 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C27C03C1AF;
        Thu, 23 Apr 2020 02:02:00 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id t4so2094883plq.12;
        Thu, 23 Apr 2020 02:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ESURTorcFnpn5TvjjZllV4zzCIxjIoPMUCqGGCximXw=;
        b=kJGDKGA9Tu+m8vwFrYBIORtoWH+KfW08OJdXIr9vnUypoQpeoQ8zh/NXBjgpVUsr7o
         sgAai14b5R5ctAO1ImEHpkKmgUc7O7Lvchan2szxDWe2jh58+l8hL2k4yUcN1p1kCWK6
         EmFQuidd9/4QSox+waZl6OKMFeas539fQnOt1dTx1x/Qw1aM8WOMOL314AtlclBQVTF8
         RHWBByOSzwaj0VXHEUvi/luyDkvQ5XpLwDKCQXhYy+WagQXPPR6FfkllT+ZWWsIPp/s+
         m0Jh8D0CZAnbklPxSc7w4MmOKlamkoMj1IaI6yTGfIHWZCm7b1GvGNCsrLK3CFI2076R
         pusg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ESURTorcFnpn5TvjjZllV4zzCIxjIoPMUCqGGCximXw=;
        b=CdBbf/ilAgqJquttKFk2Cpqc8R/pgE6qCiiDlFjSs0Ss/cJL14qCWRvLEEYcRqu6eV
         rQhik/DWVfDTGKJ/cDXlj7TDumtzZW2RX7FATBKBuaBuEurBfRWRK+xlbxqx4qHFk29l
         Q/GS1Vi8SYYGLTamMbfWDMlBfXPtcvUX8SrAe1TgZUSyC0ghLS30rg1IZtkPCnIk9fTK
         0Dw4Yoe1Zllg0pemW7MNfM8otGbXHByo3KQ5EKkr8BDsxq8vFd3DED3iH+dQCXTdIitM
         X+EeutYmbbJ92fFN0UcQKz0iM5J2psU37t9Y1K9iLFrYW93jyVE7rVaGgjhmCmWKcxu8
         DEMA==
X-Gm-Message-State: AGi0PuZCU84wNKeXJfWFfk/I20yYj/6ftuS3/TP/sC3oE68fk7ADG6x8
        blUOzFEeOvCvFzincbcEg3U6cVK/
X-Google-Smtp-Source: APiQypKfBaqbDg+Yz2gbo5NHqSf75C7jaaiMFf3mS5+J+ZuxM8zZTyGtNmKVLqgJPvDaJbhwfqoU2Q==
X-Received: by 2002:a17:902:ed13:: with SMTP id b19mr2908841pld.254.1587632520035;
        Thu, 23 Apr 2020 02:02:00 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id w28sm1574204pgc.26.2020.04.23.02.01.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Apr 2020 02:01:59 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Subject: [PATCH v2 1/5] KVM: LAPIC: Introduce interrupt delivery fastpath
Date:   Thu, 23 Apr 2020 17:01:43 +0800
Message-Id: <1587632507-18997-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1587632507-18997-1-git-send-email-wanpengli@tencent.com>
References: <1587632507-18997-1-git-send-email-wanpengli@tencent.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Introduce interrupt delivery fastpath, I observe kvm_x86_ops.deliver_posted_interrupt() 
has more latency then vmx_sync_pir_to_irr in my case, since it needs to wait 
vmentry, after that it can handle external interrupt, ack the notification 
vector, read posted-interrupt desciptor etc, it is slower than evaluate and 
delivery during vmentry method. For non-APICv, inject directly since we will 
not go though inject_pending_event().

Tested-by: Haiwei Li <lihaiwei@tencent.com>
Cc: Haiwei Li <lihaiwei@tencent.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/lapic.c            | 32 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/avic.c         |  5 +++++
 arch/x86/kvm/svm/svm.c          |  1 +
 arch/x86/kvm/svm/svm.h          |  1 +
 arch/x86/kvm/vmx/vmx.c          | 23 +++++++++++++++++------
 6 files changed, 57 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f26df2c..f809763 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1157,6 +1157,7 @@ struct kvm_x86_ops {
 	void (*set_apic_access_page_addr)(struct kvm_vcpu *vcpu);
 	int (*deliver_posted_interrupt)(struct kvm_vcpu *vcpu, int vector);
 	int (*sync_pir_to_irr)(struct kvm_vcpu *vcpu);
+	bool (*pi_test_and_set_pir_on)(struct kvm_vcpu *vcpu, int vector);
 	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
 	int (*set_identity_map_addr)(struct kvm *kvm, u64 ident_addr);
 	int (*get_tdp_level)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 38f7dc9..7703142 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1259,6 +1259,30 @@ void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high)
 	kvm_irq_delivery_to_apic(apic->vcpu->kvm, apic, &irq, NULL);
 }
 
+static void fast_deliver_interrupt(struct kvm_lapic *apic, int vector)
+{
+	struct kvm_vcpu *vcpu = apic->vcpu;
+
+	kvm_lapic_clear_vector(vector, apic->regs + APIC_TMR);
+
+	if (vcpu->arch.apicv_active) {
+		if (kvm_x86_ops.pi_test_and_set_pir_on(vcpu, vector))
+			return;
+
+		kvm_x86_ops.sync_pir_to_irr(vcpu);
+	} else {
+		kvm_lapic_set_irr(vector, apic);
+		if (kvm_cpu_has_injectable_intr(vcpu)) {
+			if (kvm_x86_ops.interrupt_allowed(vcpu)) {
+				kvm_queue_interrupt(vcpu,
+					kvm_cpu_get_interrupt(vcpu), false);
+				kvm_x86_ops.set_irq(vcpu);
+			} else
+				kvm_x86_ops.enable_irq_window(vcpu);
+		}
+	}
+}
+
 static u32 apic_get_tmcct(struct kvm_lapic *apic)
 {
 	ktime_t remaining, now;
@@ -2351,6 +2375,14 @@ int kvm_apic_local_deliver(struct kvm_lapic *apic, int lvt_type)
 	return 0;
 }
 
+static void kvm_apic_local_deliver_fast(struct kvm_lapic *apic, int lvt_type)
+{
+	u32 reg = kvm_lapic_get_reg(apic, lvt_type);
+
+	if (kvm_apic_hw_enabled(apic) && !(reg & APIC_LVT_MASKED))
+		fast_deliver_interrupt(apic, reg & APIC_VECTOR_MASK);
+}
+
 void kvm_apic_nmi_wd_deliver(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index e80daa9..ab9e0fd 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -905,6 +905,11 @@ int svm_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
 	return ret;
 }
 
+bool svm_pi_test_and_set_pir_on(struct kvm_vcpu *vcpu, int vector)
+{
+	return false;
+}
+
 bool svm_check_apicv_inhibit_reasons(ulong bit)
 {
 	ulong supported = BIT(APICV_INHIBIT_REASON_DISABLE) |
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index eb95283..fd0cab3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4035,6 +4035,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.deliver_posted_interrupt = svm_deliver_avic_intr,
 	.dy_apicv_has_pending_interrupt = svm_dy_apicv_has_pending_interrupt,
 	.update_pi_irte = svm_update_pi_irte,
+	.pi_test_and_set_pir_on = svm_pi_test_and_set_pir_on,
 	.setup_mce = svm_setup_mce,
 
 	.smi_allowed = svm_smi_allowed,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index ca95204..8a62a8b 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -457,6 +457,7 @@ int svm_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
 		       uint32_t guest_irq, bool set);
 void svm_vcpu_blocking(struct kvm_vcpu *vcpu);
 void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
+bool svm_pi_test_and_set_pir_on(struct kvm_vcpu *vcpu, int vector);
 
 /* sev.c */
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 766303b..fd20cb3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3883,6 +3883,21 @@ static int vmx_deliver_nested_posted_interrupt(struct kvm_vcpu *vcpu,
 	}
 	return -1;
 }
+
+static bool vmx_pi_test_and_set_pir_on(struct kvm_vcpu *vcpu, int vector)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	if (pi_test_and_set_pir(vector, &vmx->pi_desc))
+		return true;
+
+	/* If a previous notification has sent the IPI, nothing to do.  */
+	if (pi_test_and_set_on(&vmx->pi_desc))
+		return true;
+
+	return false;
+}
+
 /*
  * Send interrupt to vcpu via posted interrupt way.
  * 1. If target vcpu is running(non-root mode), send posted interrupt
@@ -3892,7 +3907,6 @@ static int vmx_deliver_nested_posted_interrupt(struct kvm_vcpu *vcpu,
  */
 static int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
 {
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	int r;
 
 	r = vmx_deliver_nested_posted_interrupt(vcpu, vector);
@@ -3902,11 +3916,7 @@ static int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
 	if (!vcpu->arch.apicv_active)
 		return -1;
 
-	if (pi_test_and_set_pir(vector, &vmx->pi_desc))
-		return 0;
-
-	/* If a previous notification has sent the IPI, nothing to do.  */
-	if (pi_test_and_set_on(&vmx->pi_desc))
+	if (vmx_pi_test_and_set_pir_on(vcpu, vector))
 		return 0;
 
 	if (!kvm_vcpu_trigger_posted_interrupt(vcpu, false))
@@ -7826,6 +7836,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.hwapic_isr_update = vmx_hwapic_isr_update,
 	.guest_apic_has_interrupt = vmx_guest_apic_has_interrupt,
 	.sync_pir_to_irr = vmx_sync_pir_to_irr,
+	.pi_test_and_set_pir_on = vmx_pi_test_and_set_pir_on,
 	.deliver_posted_interrupt = vmx_deliver_posted_interrupt,
 	.dy_apicv_has_pending_interrupt = vmx_dy_apicv_has_pending_interrupt,
 
-- 
2.7.4

