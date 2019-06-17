Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5524548095
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 13:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728299AbfFQLZO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 07:25:14 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46385 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728238AbfFQLZD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 07:25:03 -0400
Received: by mail-pl1-f194.google.com with SMTP id e5so3958048pls.13;
        Mon, 17 Jun 2019 04:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eZ65YD0TXsz73f/6tJ4mNuZ4ortjaWiCfb0XlT1C3No=;
        b=KFvxApUFU2jdrMZzwG8zwoApYbxhCFl2Mf6kylnwmR52M3nhzDpwBQerTUtwucpC4i
         tw5O/FQa7NacWVi9PtIQJkKDD4hx3Cs7mcBGOA+bskO8poMUZqurksWBWmSOhincrRki
         Qg1v4HbnOjHi46J53/Q61koI8DgRbNm06jWuG3/9bKkByglgnFmTT8tsOmYg4JyTfVkH
         9OhzPQ8SofIZqfQkExyMm0u7gAcI6YymOmLvrK6ySy52FdsmkGcuuzYMIBHcpSlIOz4k
         0aA6bh7dx4R9pp8Pb0dCHgC82VBmm+VQ/9qt1hCWVWx+LffxM6UANrlYhSaxl/iJvk4d
         +POQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eZ65YD0TXsz73f/6tJ4mNuZ4ortjaWiCfb0XlT1C3No=;
        b=E/EgXR3wNbtAo6MFJ6yuU5IwXoVbnR3ANrH6V8YqU2grsN2HnIclpvGRmJOU3L2vLj
         LcVjy2WPv2+fvsXYSbTcKyOg/pq56vSOl1s1BJuMk4TtyE7fARVh4FYAIrMvbxEvll2p
         UqxLyA7a8iAVsfxAcuZty+3vk1J46E8Fd4SuKdxad+USafkWqaoOFvA7sMn/cmStGbJq
         4BnchHfkeM+tr0v//9XO/UkgZsu7mOHEx0SFU2C6mhsQjHuEsvJYIu9uasQEgXQ7M29g
         iDkYXn4BAr5gj/BSVYdx64jn/anwukLKLqmAr1MLp8Gb3L7SltXorous/Mcm7Wppisvb
         3b3g==
X-Gm-Message-State: APjAAAVN/4eDYi2OT+e+fhyFh1qUJ85ibwgjE1GRD2HAmi8sYlk/laCM
        jmsAouQLDJCgZQBObCfRLHSrhGkP
X-Google-Smtp-Source: APXvYqw1hyCZYGABGQ3DwbQGYs4ers0cdgO62nY78GM5/ZbG9L7sIGDqz0je8gFhY2KiAD3s+u4DpQ==
X-Received: by 2002:a17:902:1e6:: with SMTP id b93mr63747850plb.295.1560770702823;
        Mon, 17 Jun 2019 04:25:02 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id d4sm12535751pfc.149.2019.06.17.04.25.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 17 Jun 2019 04:25:02 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v4 5/5] KVM: LAPIC: add advance timer support to pi_inject_timer
Date:   Mon, 17 Jun 2019 19:24:47 +0800
Message-Id: <1560770687-23227-6-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560770687-23227-1-git-send-email-wanpengli@tencent.com>
References: <1560770687-23227-1-git-send-email-wanpengli@tencent.com>
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
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c   | 6 ++++--
 arch/x86/kvm/lapic.h   | 2 +-
 arch/x86/kvm/svm.c     | 2 +-
 arch/x86/kvm/vmx/vmx.c | 2 +-
 4 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 1a31389..1a31ba5 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1462,6 +1462,8 @@ static void apic_timer_expired(struct kvm_lapic *apic, bool can_pi_inject)
 		return;
 
 	if (can_pi_inject && posted_interrupt_inject_timer(apic->vcpu)) {
+		if (apic->lapic_timer.timer_advance_ns)
+			kvm_wait_lapic_expire(vcpu, true);
 		kvm_apic_inject_pending_timer_irqs(apic);
 		return;
 	}
@@ -1553,7 +1555,7 @@ static inline void adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
 	apic->lapic_timer.timer_advance_ns = timer_advance_ns;
 }
 
-void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
+void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu, bool pi_inject)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	u64 guest_tsc, tsc_deadline;
@@ -1561,7 +1563,7 @@ void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
 	if (apic->lapic_timer.expired_tscdeadline == 0)
 		return;
 
-	if (!lapic_timer_int_injected(vcpu))
+	if (!lapic_timer_int_injected(vcpu) && !pi_inject)
 		return;
 
 	tsc_deadline = apic->lapic_timer.expired_tscdeadline;
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index e41936b..3d8a043 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -225,7 +225,7 @@ static inline int kvm_lapic_latched_init(struct kvm_vcpu *vcpu)
 
 bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector);
 
-void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu);
+void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu, bool pi_inject);
 
 bool kvm_intr_is_single_vcpu_fast(struct kvm *kvm, struct kvm_lapic_irq *irq,
 			struct kvm_vcpu **dest_vcpu);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index bbc31f7..7e65de4 100644
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
index f45c51e..718a3ad 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6462,7 +6462,7 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	if (lapic_in_kernel(vcpu) &&
 		vcpu->arch.apic->lapic_timer.timer_advance_ns)
-		kvm_wait_lapic_expire(vcpu);
+		kvm_wait_lapic_expire(vcpu, false);
 
 	/*
 	 * If this vCPU has touched SPEC_CTRL, restore the guest's value if
-- 
2.7.4

