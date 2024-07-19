Return-Path: <kvm+bounces-21976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 74BDD937E13
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 01:44:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D86ABB2170E
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 23:44:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A5DB149E06;
	Fri, 19 Jul 2024 23:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WWB0WDFu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D811149C60
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 23:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721432636; cv=none; b=STdLXUT7LLmeRilHmDSVpLRzel7Ik3pM6ZIQfbdgU6WLzIb35F7dJOQXteqCuyjoSBKq2jlBh1rLkzKbqvrrIeJqIaHl30L6CgI3Os6yCpw3n8W3nrZh9O46LeJr+cKNnnI51kLCoBIvOPrpptiOxNXCdHGatqkD29XawYyrvKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721432636; c=relaxed/simple;
	bh=r48XGddCN80zIaPaynZ1yaj/hfmpfp63eVWhm7RV+0o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bgg4bLAu03C/pLOUt+cKInDtIWkZgS1UGoghlNYAPwe/veZpUFhcP1DR9lUgCZFocBVCHI+nO/gFKkSh2pupvOGNw4fJgC8qoqF1eEmHNqpmbMOOYzgzx8kVmF3q0NA1RE5J1xg7TUET6DQtRgUzg9z6cgK3Z3riXj5JkOU7bJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WWB0WDFu; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fc6db23c74so16877425ad.0
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 16:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721432634; x=1722037434; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=x8igdTZgEeKKRURdE5Y+BIgiNYRFx6FmETZmL9mL1H0=;
        b=WWB0WDFu/9NtJG3zC2CirGtv825hVJZS0vzaQUEyJSO12S2N9LzwuBaJpSO61fxnxD
         3f7q1NZkLo99LUsyXFe5Ph5ZewJx/9EaAI24BKCA2V7KfUXMdGJDY6HYpQc1pgCwPmXr
         J6rMAycphwPWV7hkbu04bSgT7L4bXjsigiPFZ+oEwn2jBpplBOj0dwthLMHnp6bVLXwq
         9wLCYDGKSmd11PnDTEMw7NMPI7gtJDj58Xe+Pnc65X9RA4EA7jFqfyfMWLH4u7w0Cw7B
         iEG4D1eaMx+WPgrH9s5q+4NWlCKRAZ9Gu/SA3RxGXmeXoTCc1gyF4z0EiHwKdssA+ZP2
         nepA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721432634; x=1722037434;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x8igdTZgEeKKRURdE5Y+BIgiNYRFx6FmETZmL9mL1H0=;
        b=DANyHavNjwp/o/wJ+Yx2gm0w9/sLrptudYB1QmzuhwJp3COSDgiEmuuZXhW6TLu03H
         BGYU/uoLUkhFhjisA3VsdV/Z56ddENIKZNta2YiZsp2IPSApAiIeYh4+fCTDzbP0xR3k
         viirUB37ycg+ImPS2aBWKWWG8giONo2LUfssIMFKn5H1fiKDGwcFpJBzyKp+uevBybCg
         9fqXpiGUZS7hGhtKn1c2VCR6iySP4Dst0ON+K5a7ngMlSf6LSJtTCQS99vCiixdBiz11
         PZiXW/EShs/JT1TXLBUs/288wVXx5n1Tb9uTPOcXsWQ6gi5JNApchtUGyhIPz0b24Om0
         3AgQ==
X-Gm-Message-State: AOJu0YxdVOwncPP/8jtwdac0cONEiuhbNW0sMG1rms9Mz3nGJEP1AXHT
	VOYjyagRZtGOgr8s6eKRB1Niu+HnZxfvawdSZBAIXxVto5tEZGb5N8rkrznYOGFx6aOskADBeyf
	ScA==
X-Google-Smtp-Source: AGHT+IGaaLuLfDMyX2Ck/Rh10pNVbyLR+y67SoJ0fL3JQMAp89Fz1Hzg3nnGOd+xkFsesKHNd/kOpG2I7nY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c404:b0:1fb:56c8:f273 with SMTP id
 d9443c01a7336-1fd74534000mr872005ad.1.1721432634374; Fri, 19 Jul 2024
 16:43:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Jul 2024 16:43:40 -0700
In-Reply-To: <20240719234346.3020464-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240719234346.3020464-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.1089.g2a221341d9-goog
Message-ID: <20240719234346.3020464-4-seanjc@google.com>
Subject: [PATCH 3/8] KVM: x86: Re-split x2APIC ICR into ICR+ICR2 for AMD (x2AVIC)
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"

Re-introduce the "split" x2APIC ICR storage that KVM used prior to Intel's
IPI virtualization support, but only for AMD.  While not stated anywhere
in the APM, despite stating the ICR is a single 64-bit register, AMD CPUs
store the 64-bit ICR as two separate 32-bit values in ICR and ICR2.  When
IPI virtualization (IPIv on Intel, all AVIC flavors on AMD) is enabled,
KVM needs to match CPU behavior as some ICR ICR writes will be handled by
the CPU, not by KVM.

Add a kvm_x86_ops knob to control the underlying format used by the CPU to
store the x2APIC ICR, and tune it to AMD vs. Intel regardless of whether
or not x2AVIC is enabled.  If KVM is handling all ICR writes, the storage
format for x2APIC mode doesn't matter, and having the behavior follow AMD
versus Intel will provide better test coverage and ease debugging.

Fixes: 4d1d7942e36a ("KVM: SVM: Introduce logic to (de)activate x2AVIC mode")
Cc: stable@vger.kernel.org
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/lapic.c            | 42 +++++++++++++++++++++++----------
 arch/x86/kvm/svm/svm.c          |  2 ++
 arch/x86/kvm/vmx/main.c         |  2 ++
 4 files changed, 36 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 950a03e0181e..edc235521434 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1726,6 +1726,8 @@ struct kvm_x86_ops {
 	void (*enable_nmi_window)(struct kvm_vcpu *vcpu);
 	void (*enable_irq_window)(struct kvm_vcpu *vcpu);
 	void (*update_cr8_intercept)(struct kvm_vcpu *vcpu, int tpr, int irr);
+
+	const bool x2apic_icr_is_split;
 	const unsigned long required_apicv_inhibits;
 	bool allow_apicv_in_x2apic_without_x2apic_virtualization;
 	void (*refresh_apicv_exec_ctrl)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index d14ef485b0bd..cc0a1008fae4 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2473,11 +2473,25 @@ int kvm_x2apic_icr_write(struct kvm_lapic *apic, u64 data)
 	data &= ~APIC_ICR_BUSY;
 
 	kvm_apic_send_ipi(apic, (u32)data, (u32)(data >> 32));
-	kvm_lapic_set_reg64(apic, APIC_ICR, data);
+	if (kvm_x86_ops.x2apic_icr_is_split) {
+		kvm_lapic_set_reg(apic, APIC_ICR, data);
+		kvm_lapic_set_reg(apic, APIC_ICR2, data >> 32);
+	} else {
+		kvm_lapic_set_reg64(apic, APIC_ICR, data);
+	}
 	trace_kvm_apic_write(APIC_ICR, data);
 	return 0;
 }
 
+static u64 kvm_x2apic_icr_read(struct kvm_lapic *apic)
+{
+	if (kvm_x86_ops.x2apic_icr_is_split)
+		return (u64)kvm_lapic_get_reg(apic, APIC_ICR) |
+		       (u64)kvm_lapic_get_reg(apic, APIC_ICR2) << 32;
+
+	return kvm_lapic_get_reg64(apic, APIC_ICR);
+}
+
 /* emulate APIC access in a trap manner */
 void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
 {
@@ -2495,7 +2509,7 @@ void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
 	 * maybe-unecessary write, and both are in the noise anyways.
 	 */
 	if (apic_x2apic_mode(apic) && offset == APIC_ICR)
-		WARN_ON_ONCE(kvm_x2apic_icr_write(apic, kvm_lapic_get_reg64(apic, APIC_ICR)));
+		WARN_ON_ONCE(kvm_x2apic_icr_write(apic, kvm_x2apic_icr_read(apic)));
 	else
 		kvm_lapic_reg_write(apic, offset, kvm_lapic_get_reg(apic, offset));
 }
@@ -3005,18 +3019,22 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
 
 		/*
 		 * In x2APIC mode, the LDR is fixed and based on the id.  And
-		 * ICR is internally a single 64-bit register, but needs to be
-		 * split to ICR+ICR2 in userspace for backwards compatibility.
+		 * if the ICR is _not_ split, ICR is internally a single 64-bit
+		 * register, but needs to be split to ICR+ICR2 in userspace for
+		 * backwards compatibility.
 		 */
-		if (set) {
+		if (set)
 			*ldr = kvm_apic_calc_x2apic_ldr(*id);
 
-			icr = __kvm_lapic_get_reg(s->regs, APIC_ICR) |
-			      (u64)__kvm_lapic_get_reg(s->regs, APIC_ICR2) << 32;
-			__kvm_lapic_set_reg64(s->regs, APIC_ICR, icr);
-		} else {
-			icr = __kvm_lapic_get_reg64(s->regs, APIC_ICR);
-			__kvm_lapic_set_reg(s->regs, APIC_ICR2, icr >> 32);
+		if (!kvm_x86_ops.x2apic_icr_is_split) {
+			if (set) {
+				icr = __kvm_lapic_get_reg(s->regs, APIC_ICR) |
+				      (u64)__kvm_lapic_get_reg(s->regs, APIC_ICR2) << 32;
+				__kvm_lapic_set_reg64(s->regs, APIC_ICR, icr);
+			} else {
+				icr = __kvm_lapic_get_reg64(s->regs, APIC_ICR);
+				__kvm_lapic_set_reg(s->regs, APIC_ICR2, icr >> 32);
+			}
 		}
 	}
 
@@ -3214,7 +3232,7 @@ static int kvm_lapic_msr_read(struct kvm_lapic *apic, u32 reg, u64 *data)
 	u32 low;
 
 	if (reg == APIC_ICR) {
-		*data = kvm_lapic_get_reg64(apic, APIC_ICR);
+		*data = kvm_x2apic_icr_read(apic);
 		return 0;
 	}
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c115d26844f7..04c113386de6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5049,6 +5049,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.enable_nmi_window = svm_enable_nmi_window,
 	.enable_irq_window = svm_enable_irq_window,
 	.update_cr8_intercept = svm_update_cr8_intercept,
+
+	.x2apic_icr_is_split = true,
 	.set_virtual_apic_mode = avic_refresh_virtual_apic_mode,
 	.refresh_apicv_exec_ctrl = avic_refresh_apicv_exec_ctrl,
 	.apicv_post_state_restore = avic_apicv_post_state_restore,
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 0bf35ebe8a1b..a70699665e11 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -89,6 +89,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.enable_nmi_window = vmx_enable_nmi_window,
 	.enable_irq_window = vmx_enable_irq_window,
 	.update_cr8_intercept = vmx_update_cr8_intercept,
+
+	.x2apic_icr_is_split = false,
 	.set_virtual_apic_mode = vmx_set_virtual_apic_mode,
 	.set_apic_access_page_addr = vmx_set_apic_access_page_addr,
 	.refresh_apicv_exec_ctrl = vmx_refresh_apicv_exec_ctrl,
-- 
2.45.2.1089.g2a221341d9-goog


