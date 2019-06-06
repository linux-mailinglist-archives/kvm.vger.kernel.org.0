Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96F8D37234
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 12:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbfFFKzk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 06:55:40 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39801 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbfFFKzk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 06:55:40 -0400
Received: by mail-pg1-f195.google.com with SMTP id 196so1148585pgc.6;
        Thu, 06 Jun 2019 03:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u11NQoOcVc3KEqCmRt6p0L2NADGM3isejFoGnzfSN6E=;
        b=CTpIPwBkWIu2kbKtsD3xwmvvC02dqEo8yUPXjFCyPCiFjWT6ZsYSdkZ+PG/g/sHnzG
         K0FStLpYv8QELGLHzuLfljfsgIOfG2+tXg2xXxXGCT5Ef0Ddr3HTXjBABHo+olQBUr6i
         yrAkl7JZ1oDPOYV0awiDLxXbJRZ/opHNKYDGXzRlEKvxEFDU3t82lbRx8kkk9DsdYifg
         gcNFM/9e8MLK7KWachFnFSyZftwWG+TTOJRIwCMHGm0NhsjA6vvuvZ4i8nfuX8lLTWdC
         hxnPC2qH7xNqp1BJoN55t/CADJPg5EnCdSKUEBx1dJAoPGtc2cduOY/TaycxMNz7L+00
         Q83w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u11NQoOcVc3KEqCmRt6p0L2NADGM3isejFoGnzfSN6E=;
        b=eJeHODtCnAj71NEsKkucccCmtZNUxUnFsCyNxpCGcY3Tc2G9MDKKxNw2J+1ucf9inW
         Wk4JVYLTTl1HlwUX95GCSBCmVZ6g0Ely6Z92/2m3xs0OlNdL69R4YyYRNXxqlz+uBLhV
         k2ZBb5AnwpP5d0ZXdmVsGs6LZYacDKar+lFP7hDPSc3oQ7vCfmt1a4XkqDSLNjSZLjyO
         aQ0UmRGg3xnYbFHktUyC9V9673S4hyk+hMsexWvXRGjctKzzL4kSVfVdxNrINs1DwkSj
         NlQgiJQlNICv2TrAkq751akSjzJguO0yPkhYf2LyjNwZXgy2yWx/sHy/AHfhhroFLxtC
         Zx6w==
X-Gm-Message-State: APjAAAXafwRqKNoPMSyEH9h/pBdF6HTZYo8PR9Bf1DIlvoPiPCu/1Sgq
        aeAp/pccH0MeYnFhnybuJJf+7QPn
X-Google-Smtp-Source: APXvYqxaHotpQRxzvgbbRzCQ3B2/0ascc5stHMR6qrAPogQfvs7zpzAUQYHshwy0iPahV5QnhUp2MA==
X-Received: by 2002:a62:b609:: with SMTP id j9mr38392045pff.145.1559818539414;
        Thu, 06 Jun 2019 03:55:39 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id d10sm4340213pgh.43.2019.06.06.03.55.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 06 Jun 2019 03:55:38 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH v2 4/3] KVM: LAPIC: add advance timer support to pi_inject_timer
Date:   Thu,  6 Jun 2019 18:55:33 +0800
Message-Id: <1559818533-20529-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559799086-13912-4-git-send-email-wanpengli@tencent.com>
References: <1559799086-13912-4-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Wait before calling posted-interrupt deliver function directly to add 
advance timer support to pi_inject_timer.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c   | 6 ++++--
 arch/x86/kvm/lapic.h   | 2 +-
 arch/x86/kvm/svm.c     | 2 +-
 arch/x86/kvm/vmx/vmx.c | 2 +-
 4 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index a3e4ca8..9581817 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1470,6 +1470,8 @@ static void apic_timer_expired(struct kvm_lapic *apic)
 		return;
 
 	if (unlikely(can_posted_interrupt_inject_timer(apic->vcpu))) {
+		if (apic->lapic_timer.timer_advance_ns)
+			kvm_wait_lapic_expire(vcpu, true);
 		kvm_apic_inject_pending_timer_irqs(apic);
 		return;
 	}
@@ -1561,7 +1563,7 @@ static inline void adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
 	apic->lapic_timer.timer_advance_ns = timer_advance_ns;
 }
 
-void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
+void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu, bool pi_inject)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	u64 guest_tsc, tsc_deadline;
@@ -1569,7 +1571,7 @@ void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
 	if (apic->lapic_timer.expired_tscdeadline == 0)
 		return;
 
-	if (!lapic_timer_int_injected(vcpu))
+	if (!lapic_timer_int_injected(vcpu) && !pi_inject)
 		return;
 
 	tsc_deadline = apic->lapic_timer.expired_tscdeadline;
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index f974a3d..16f0500 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -220,7 +220,7 @@ static inline int kvm_lapic_latched_init(struct kvm_vcpu *vcpu)
 
 bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector);
 
-void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu);
+void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu, bool pi_inject);
 
 bool kvm_intr_is_single_vcpu_fast(struct kvm *kvm, struct kvm_lapic_irq *irq,
 			struct kvm_vcpu **dest_vcpu);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 302cb40..049ba64 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5648,7 +5648,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	if (lapic_in_kernel(vcpu) &&
 		vcpu->arch.apic->lapic_timer.timer_advance_ns)
-		kvm_wait_lapic_expire(vcpu);
+		kvm_wait_lapic_expire(vcpu, false);
 
 	/*
 	 * If this vCPU has touched SPEC_CTRL, restore the guest's value if
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index da24f18..302bac4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6447,7 +6447,7 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	if (lapic_in_kernel(vcpu) &&
 		vcpu->arch.apic->lapic_timer.timer_advance_ns)
-		kvm_wait_lapic_expire(vcpu);
+		kvm_wait_lapic_expire(vcpu, false);
 
 	/*
 	 * If this vCPU has touched SPEC_CTRL, restore the guest's value if
-- 
2.7.4

