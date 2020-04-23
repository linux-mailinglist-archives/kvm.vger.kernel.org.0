Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1081B57A7
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 11:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbgDWJCK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 05:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726925AbgDWJCJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 05:02:09 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E63E9C03C1AF;
        Thu, 23 Apr 2020 02:02:08 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id 7so3464588pjo.0;
        Thu, 23 Apr 2020 02:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=24Ps2m2mB6ldmYhx86y/bPBe5Ad5kjBj+xvR0CfVcoY=;
        b=PKd6egaFD2EGPL05YwIJiZwRiDArYYOoUkg/BL5g3G/2lfLRbhAdrHvJXS6Rs3W5bb
         CfoN696RCysPjFOUROpFOGOfoDjFsZL7+xxn+/k8eyXtS5fAAy/mrk2r+4mavWbjXLPi
         4Zoegad/E38xsqp5dQMbX4oOMHEW4jHUnPCl4gjkAV3YmSiCe5bhzsS8kjCQ5zx16Shf
         vNplbO4EgAybaiAYHUfxr6WTyLTSwKA8l4q0DWqKFjINYae9l+BA7qyIi2x/nSEoCuDa
         Vtbkz62UXzZbatJRJ2h7UkO6Ro0amYK0PXjOOd+tPfW0HyEg8fIRTeM1M1mM2J1EyrWM
         oJ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=24Ps2m2mB6ldmYhx86y/bPBe5Ad5kjBj+xvR0CfVcoY=;
        b=eI4sq/g+7bq4i1+eSrHscEfRGMHUk05stJuX3SnZwvCbo4pQ9w4F6z/yQHl7YFfTt6
         7c02oaFYDXUwxBVJf2bawWQvDpv/SwAUgV3bXAG85vB3M81Fg1WVYrwGeko4dEdCQ1cV
         SQLN8yo59cSy6dJZlDpIHlAqFDqsbu7xodbQl5A97ldlr2Pe9MpFXuSuP8X4UhMhWDLd
         Qjvel09QI2f0wu6skJK1aGgne2pZp+4eWjWXVzlG+fHjKOTIeUoWPOW/ue/usYDgC8X0
         s+KrMNuJN6Wx7a3cUncR3jGCd2uTmqcIIiL9/LjK0J3DgF7tVAnFsoNYE6G5y/Umx5Cj
         ObBg==
X-Gm-Message-State: AGi0PuZA95QwE5HlHzf8v3QgyvI47l4txX3papVcaUemblf7hDyunXUG
        zD+CJCVluRZZCd3TNqLBH05KTk1S
X-Google-Smtp-Source: APiQypL8as6qEG3rRb5YUelFDgS7MaH4pLJEGcG4l50eTKZ4rAc1pOp8RSxPj2LAqow5rfg1vHj3sQ==
X-Received: by 2002:a17:902:b682:: with SMTP id c2mr2915254pls.144.1587632528311;
        Thu, 23 Apr 2020 02:02:08 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id w28sm1574204pgc.26.2020.04.23.02.02.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Apr 2020 02:02:07 -0700 (PDT)
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
Subject: [PATCH v2 4/5] KVM: X86: TSCDEADLINE MSR emulation fastpath
Date:   Thu, 23 Apr 2020 17:01:46 +0800
Message-Id: <1587632507-18997-5-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1587632507-18997-1-git-send-email-wanpengli@tencent.com>
References: <1587632507-18997-1-git-send-email-wanpengli@tencent.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

This patch implements tscdealine msr emulation fastpath, after wrmsr 
tscdeadline vmexit, handle it as soon as possible and vmentry immediately 
without checking various kvm stuff when possible.

Tested-by: Haiwei Li <lihaiwei@tencent.com>
Cc: Haiwei Li <lihaiwei@tencent.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 47 ++++++++++++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/lapic.h |  1 +
 arch/x86/kvm/x86.c   | 32 ++++++++++++++++++++++++++------
 3 files changed, 71 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 7703142..d652bd9 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1898,6 +1898,8 @@ void kvm_lapic_expired_hv_timer(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_lapic_expired_hv_timer);
 
+static void kvm_inject_apic_timer_irqs_fast(struct kvm_vcpu *vcpu);
+
 void kvm_lapic_switch_to_hv_timer(struct kvm_vcpu *vcpu)
 {
 	restart_apic_timer(vcpu->arch.apic);
@@ -2189,17 +2191,48 @@ u64 kvm_get_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu)
 	return apic->lapic_timer.tscdeadline;
 }
 
-void kvm_set_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu, u64 data)
+static int __kvm_set_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu, u64 data)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
 	if (!lapic_in_kernel(vcpu) || apic_lvtt_oneshot(apic) ||
 			apic_lvtt_period(apic))
-		return;
+		return 0;
 
 	hrtimer_cancel(&apic->lapic_timer.timer);
 	apic->lapic_timer.tscdeadline = data;
-	start_apic_timer(apic);
+
+	return 1;
+}
+
+void kvm_set_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu, u64 data)
+{
+	if (__kvm_set_lapic_tscdeadline_msr(vcpu, data))
+		start_apic_timer(vcpu->arch.apic);
+}
+
+static int tscdeadline_expired_timer_fast(struct kvm_vcpu *vcpu)
+{
+	if (kvm_check_request(KVM_REQ_PENDING_TIMER, vcpu)) {
+		kvm_clear_request(KVM_REQ_PENDING_TIMER, vcpu);
+		kvm_inject_apic_timer_irqs_fast(vcpu);
+		atomic_set(&vcpu->arch.apic->lapic_timer.pending, 0);
+	}
+
+	return 0;
+}
+
+int kvm_set_lapic_tscdeadline_msr_fast(struct kvm_vcpu *vcpu, u64 data)
+{
+	struct kvm_lapic *apic = vcpu->arch.apic;
+
+	if (__kvm_set_lapic_tscdeadline_msr(vcpu, data)) {
+		atomic_set(&apic->lapic_timer.pending, 0);
+		if (start_hv_timer(apic))
+			return tscdeadline_expired_timer_fast(vcpu);
+	}
+
+	return 1;
 }
 
 void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8)
@@ -2492,6 +2525,14 @@ void kvm_inject_apic_timer_irqs(struct kvm_vcpu *vcpu)
 	}
 }
 
+static void kvm_inject_apic_timer_irqs_fast(struct kvm_vcpu *vcpu)
+{
+	struct kvm_lapic *apic = vcpu->arch.apic;
+
+	kvm_apic_local_deliver_fast(apic, APIC_LVTT);
+	apic->lapic_timer.tscdeadline = 0;
+}
+
 int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu)
 {
 	int vector = kvm_apic_has_interrupt(vcpu);
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 7f15f9e..5ef1364 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -251,6 +251,7 @@ void kvm_lapic_expired_hv_timer(struct kvm_vcpu *vcpu);
 bool kvm_lapic_hv_timer_in_use(struct kvm_vcpu *vcpu);
 void kvm_lapic_restart_hv_timer(struct kvm_vcpu *vcpu);
 bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu);
+int kvm_set_lapic_tscdeadline_msr_fast(struct kvm_vcpu *vcpu, u64 data);
 
 static inline enum lapic_mode kvm_apic_mode(u64 apic_base)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4561104..112f1c4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1616,27 +1616,47 @@ static int handle_fastpath_set_x2apic_icr_irqoff(struct kvm_vcpu *vcpu, u64 data
 	return 1;
 }
 
+static int handle_fastpath_set_tscdeadline(struct kvm_vcpu *vcpu, u64 data)
+{
+	if (!kvm_x86_ops.set_hv_timer ||
+		kvm_mwait_in_guest(vcpu->kvm) ||
+		kvm_can_post_timer_interrupt(vcpu))
+		return 1;
+
+	return kvm_set_lapic_tscdeadline_msr_fast(vcpu, data);
+}
+
 enum exit_fastpath_completion handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
 {
 	u32 msr = kvm_rcx_read(vcpu);
 	u64 data;
-	int ret = 0;
+	int ret = EXIT_FASTPATH_NONE;
 
 	switch (msr) {
 	case APIC_BASE_MSR + (APIC_ICR >> 4):
 		data = kvm_read_edx_eax(vcpu);
-		ret = handle_fastpath_set_x2apic_icr_irqoff(vcpu, data);
+		if (!handle_fastpath_set_x2apic_icr_irqoff(vcpu, data))
+			ret = EXIT_FASTPATH_SKIP_EMUL_INS;
+		break;
+	case MSR_IA32_TSCDEADLINE:
+		if (!(kvm_need_cancel_enter_guest(vcpu) ||
+			kvm_event_needs_reinjection(vcpu))) {
+			data = kvm_read_edx_eax(vcpu);
+			if (!handle_fastpath_set_tscdeadline(vcpu, data))
+				ret = EXIT_FASTPATH_CONT_RUN;
+		}
 		break;
 	default:
-		return EXIT_FASTPATH_NONE;
+		ret = EXIT_FASTPATH_NONE;
 	}
 
-	if (!ret) {
+	if (ret != EXIT_FASTPATH_NONE) {
 		trace_kvm_msr_write(msr, data);
-		return EXIT_FASTPATH_SKIP_EMUL_INS;
+		if (ret == EXIT_FASTPATH_CONT_RUN)
+			kvm_skip_emulated_instruction(vcpu);
 	}
 
-	return EXIT_FASTPATH_NONE;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(handle_fastpath_set_msr_irqoff);
 
-- 
2.7.4

