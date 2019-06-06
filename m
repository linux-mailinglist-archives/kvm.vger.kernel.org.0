Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B366136BA6
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 07:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbfFFFbh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 01:31:37 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46411 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726600AbfFFFbh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 01:31:37 -0400
Received: by mail-pf1-f193.google.com with SMTP id y11so745276pfm.13;
        Wed, 05 Jun 2019 22:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wE0Wgr1CQiuql/Q2ninNprxqEmOTvd79VsiHhtBS/ng=;
        b=Dk+D6Nni08el/+xptgFQi+GGXxde8NFGtPJRh0cIHl8Rnde+G9HOoboVptSQ4oWULT
         sVe3Jaqern1RSIOaM7pglRcor0TCOF6Nt6Myb+xVh6xY2wPTfN8AfrHtfKAN+wVpY/c5
         rCp2vnBv0BCNCytIKqy96D7SubK/hcDJ1/7wtrZPcDFByVD5j504dFwIwX+yoq31xosK
         0Pn2E6YEa7NbP2t3YpHAFh6Q/cqUjkNhTWzEgGACBI4yQQUycY8ZUHUMVJcuqaBREMaR
         26/5Tvrp7Ucam5eS17YZbtb7jQcOtzZt5J3Rjr7yV6gBkhVjuu1bN7kM3BPPCMBvSYh+
         r6/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wE0Wgr1CQiuql/Q2ninNprxqEmOTvd79VsiHhtBS/ng=;
        b=LawCJaE8EZaSoCXggwGLECt3Z+i6tcLN1wzXBZwrF+S5dLDK/ObafPXmTgYmDYdOUl
         hFqvbUxOAz3hB1kKgw+PH8/9Fzx6mQTcuyU1M3kVtOq7e+PNROA02+f2IXYi2i4EccOn
         /gq5tfsnbtTbFCV3x07mtKtsmQ7FAUTSYviS4u39MC/umhm8MskOjVB4gpiHTKgOU7gK
         ogBH/gHByzOq2Rj6Ngkgd3VaL29M0mFx77EyeTJ4l93NAiD48QZGHBnUlTkBBbzTKvmg
         SNzN7vNl5jEH5xY9aDUCJ6CU+GOBuyD5bx7IRKEmXmMtYmztWfg1ZK41r+h03pb4IkAu
         CthA==
X-Gm-Message-State: APjAAAWmeT//Ub2FC1VJm5c1CufLshmmHkC/yoF2sT5SA4Cf7P32ofle
        w5SNhtICCaFq2Gj4K7DQqeHUcSFu
X-Google-Smtp-Source: APXvYqxdCXcPCRmpZWq+ZIUWqJO9IglrwRiOb7O1QtLwQhgTxIC2GQ8tUj0ewspv1lcPJRtPHFeRdA==
X-Received: by 2002:a65:5206:: with SMTP id o6mr1727020pgp.248.1559799096138;
        Wed, 05 Jun 2019 22:31:36 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id f11sm721547pjg.1.2019.06.05.22.31.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 05 Jun 2019 22:31:35 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH v2 2/3] KVM: LAPIC: lapic timer interrupt is injected by posted interrupt
Date:   Thu,  6 Jun 2019 13:31:25 +0800
Message-Id: <1559799086-13912-3-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559799086-13912-1-git-send-email-wanpengli@tencent.com>
References: <1559799086-13912-1-git-send-email-wanpengli@tencent.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Dedicated instances are currently disturbed by unnecessary jitter due 
to the emulated lapic timers fire on the same pCPUs which vCPUs resident.
There is no hardware virtual timer on Intel for guest like ARM. Both 
programming timer in guest and the emulated timer fires incur vmexits.
This patch tries to avoid vmexit which is incurred by the emulated 
timer fires in dedicated instance scenario. 

When nohz_full is enabled in dedicated instances scenario, the emulated 
timers can be offload to the nearest busy housekeeping cpus since APICv 
is really common in recent years. The guest timer interrupt is injected 
by posted-interrupt which is delivered by housekeeping cpu once the emulated 
timer fires. 

3%~5% redis performance benefit can be observed on Skylake server.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 32 +++++++++++++++++++++++++-------
 arch/x86/kvm/x86.h   |  5 +++++
 2 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 09b7387..c08e5a8 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -133,6 +133,12 @@ static inline bool posted_interrupt_inject_timer_enabled(struct kvm_vcpu *vcpu)
 		kvm_mwait_in_guest(vcpu->kvm);
 }
 
+static inline bool can_posted_interrupt_inject_timer(struct kvm_vcpu *vcpu)
+{
+	return posted_interrupt_inject_timer_enabled(vcpu) &&
+		!vcpu_halt_in_guest(vcpu);
+}
+
 static inline bool kvm_apic_map_get_logical_dest(struct kvm_apic_map *map,
 		u32 dest_id, struct kvm_lapic ***cluster, u16 *mask) {
 	switch (map->mode) {
@@ -1441,6 +1447,19 @@ static void apic_update_lvtt(struct kvm_lapic *apic)
 	}
 }
 
+static void kvm_apic_inject_pending_timer_irqs(struct kvm_lapic *apic)
+{
+	struct kvm_timer *ktimer = &apic->lapic_timer;
+
+	kvm_apic_local_deliver(apic, APIC_LVTT);
+	if (apic_lvtt_tscdeadline(apic))
+		ktimer->tscdeadline = 0;
+	if (apic_lvtt_oneshot(apic)) {
+		ktimer->tscdeadline = 0;
+		ktimer->target_expiration = 0;
+	}
+}
+
 static void apic_timer_expired(struct kvm_lapic *apic)
 {
 	struct kvm_vcpu *vcpu = apic->vcpu;
@@ -1450,6 +1469,11 @@ static void apic_timer_expired(struct kvm_lapic *apic)
 	if (atomic_read(&apic->lapic_timer.pending))
 		return;
 
+	if (unlikely(can_posted_interrupt_inject_timer(apic->vcpu))) {
+		kvm_apic_inject_pending_timer_irqs(apic);
+		return;
+	}
+
 	atomic_inc(&apic->lapic_timer.pending);
 	kvm_set_pending_timer(vcpu);
 
@@ -2386,13 +2410,7 @@ void kvm_inject_apic_timer_irqs(struct kvm_vcpu *vcpu)
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
 	if (atomic_read(&apic->lapic_timer.pending) > 0) {
-		kvm_apic_local_deliver(apic, APIC_LVTT);
-		if (apic_lvtt_tscdeadline(apic))
-			apic->lapic_timer.tscdeadline = 0;
-		if (apic_lvtt_oneshot(apic)) {
-			apic->lapic_timer.tscdeadline = 0;
-			apic->lapic_timer.target_expiration = 0;
-		}
+		kvm_apic_inject_pending_timer_irqs(apic);
 		atomic_set(&apic->lapic_timer.pending, 0);
 	}
 }
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index aa539d6..74c86cb 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -364,4 +364,9 @@ static inline bool kvm_pat_valid(u64 data)
 void kvm_load_guest_xcr0(struct kvm_vcpu *vcpu);
 void kvm_put_guest_xcr0(struct kvm_vcpu *vcpu);
 
+static inline bool vcpu_halt_in_guest(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.apf.halted;
+}
+
 #endif
-- 
2.7.4

