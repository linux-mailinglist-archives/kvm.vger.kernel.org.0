Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9E78E360
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2019 06:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbfHOEDt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 00:03:49 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42649 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbfHOEDt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 00:03:49 -0400
Received: by mail-pf1-f194.google.com with SMTP id i30so686079pfk.9;
        Wed, 14 Aug 2019 21:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4nUx+PiT1A/UTue4lI0LEVNVOUoj29u0rUjKYH9A9qA=;
        b=q/uCDiqUBuw3t4/EZc02nEuFb8dsKLNA10EeM9XLk1200ynDcNdeWYMbUnyD14zDam
         pkLvWY6Q71ESRSLEXVZS/1BB7wf2K1WHV+VffFCYB3ABzVCvuEJ/6VOr0QcGTbvng8yI
         dqBEwtP1VJvxKWATMe78vViTkdlG9YpiKNFAScAddmzB/8vao8LCU0wRoj4/gHjAHlee
         u1nrEMU+A3qWPSwPeoJaACFMSPpNnSPdlwry9cgpa3xAGhoMznD44XZ+S0A4gAAEbeHn
         A6R3mK2htyZdjppXXFAZ5p8MlLI02T83EdaFSrcZHGjY1dvMDv33r4WLI4ClXk+CSuPj
         1dPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4nUx+PiT1A/UTue4lI0LEVNVOUoj29u0rUjKYH9A9qA=;
        b=A9xgC7mV4X7iNkcZLRGkwYPDANOsw/Tb1toR61A0T8uRcocFuHd81W1r7XsAAZmxOc
         UvDgFfCnYANKeqSqhK1G1QOhsbZbP1jgTvXvJPz/YWqd+w05JvKnMaw+mRcGUSFqnGoo
         iJYoSmObrMEakC60SYuNbjWV4qsCWUUcCPro5e2cqZmlxvPGIrfMLUfnfhgSxBdpH5ji
         f6OEEcmnuIx9/4r65Ci2YsrRzuphwpz2D6ZKMBHx4YI+sWLRb6wWOwK6m46b7dYeoDM/
         IXJeXeVZI2M5USMmMPn8nqQ56LA/fkrFPvmVtg4s4DfFRS057Q8r2f7Xm4RUHASoSqIQ
         G1aQ==
X-Gm-Message-State: APjAAAVuoilazZFyn4sSusYkNvxVkBgNU8oCYei5AwHSP+alxdxrn4hH
        zlZvcF3B31tmgWreRU+pQXP35ktE
X-Google-Smtp-Source: APXvYqy835FwkDxLLTJ8VauChuFS3hewWRet1cBkbwe0sDX7yV1440MiWUfblAwVA1LfS7MhfTNKHA==
X-Received: by 2002:a17:90a:21eb:: with SMTP id q98mr471321pjc.23.1565841827920;
        Wed, 14 Aug 2019 21:03:47 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id w11sm259423pjr.15.2019.08.14.21.03.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 21:03:47 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH v2] KVM: LAPIC: Periodically revaluate to get conservative lapic_timer_advance_ns
Date:   Thu, 15 Aug 2019 12:03:37 +0800
Message-Id: <1565841817-25982-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Even if for realtime CPUs, cache line bounces, frequency scaling, presence 
of higher-priority RT tasks, etc can still cause different response. These 
interferences should be considered and periodically revaluate whether 
or not the lapic_timer_advance_ns value is the best, do nothing if it is,
otherwise recaluate again. Set lapic_timer_advance_ns to the minimal 
conservative value from all the estimated values.

Testing on Skylake server, cat vcpu*/lapic_timer_advance_ns, before patch:
1628
4161
4321
3236
...

Testing on Skylake server, cat vcpu*/lapic_timer_advance_ns, after patch:
1553
1499
1509
1489
...

Testing on Haswell desktop, cat vcpu*/lapic_timer_advance_ns, before patch:
4617
3641
4102
4577
...
Testing on Haswell desktop, cat vcpu*/lapic_timer_advance_ns, after patch:
2775
2892
2764
2775
...

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 34 ++++++++++++++++++++++++++++------
 arch/x86/kvm/lapic.h |  2 ++
 2 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index df5cd07..8487d9c 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -69,6 +69,7 @@
 #define LAPIC_TIMER_ADVANCE_ADJUST_INIT 1000
 /* step-by-step approximation to mitigate fluctuation */
 #define LAPIC_TIMER_ADVANCE_ADJUST_STEP 8
+#define LAPIC_TIMER_ADVANCE_RECALC_PERIOD (600 * HZ)
 
 static inline int apic_test_vector(int vec, void *bitmap)
 {
@@ -1480,10 +1481,21 @@ static inline void __wait_lapic_expire(struct kvm_vcpu *vcpu, u64 guest_cycles)
 static inline void adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
 					      s64 advance_expire_delta)
 {
-	struct kvm_lapic *apic = vcpu->arch.apic;
-	u32 timer_advance_ns = apic->lapic_timer.timer_advance_ns;
+	struct kvm_timer *ktimer = &vcpu->arch.apic->lapic_timer;
+	u32 timer_advance_ns = ktimer->timer_advance_ns;
 	u64 ns;
 
+	/* periodic revaluate */
+	if (unlikely(ktimer->timer_advance_adjust_done)) {
+		ktimer->recalc_timer_advance_ns = jiffies +
+			LAPIC_TIMER_ADVANCE_RECALC_PERIOD;
+		if (abs(advance_expire_delta) > LAPIC_TIMER_ADVANCE_ADJUST_DONE) {
+			timer_advance_ns = LAPIC_TIMER_ADVANCE_ADJUST_INIT;
+			ktimer->timer_advance_adjust_done = false;
+		} else
+			return;
+	}
+
 	/* too early */
 	if (advance_expire_delta < 0) {
 		ns = -advance_expire_delta * 1000000ULL;
@@ -1499,12 +1511,18 @@ static inline void adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
 	}
 
 	if (abs(advance_expire_delta) < LAPIC_TIMER_ADVANCE_ADJUST_DONE)
-		apic->lapic_timer.timer_advance_adjust_done = true;
+		ktimer->timer_advance_adjust_done = true;
 	if (unlikely(timer_advance_ns > 5000)) {
 		timer_advance_ns = LAPIC_TIMER_ADVANCE_ADJUST_INIT;
-		apic->lapic_timer.timer_advance_adjust_done = false;
+		ktimer->timer_advance_adjust_done = false;
+	}
+	ktimer->timer_advance_ns = timer_advance_ns;
+
+	if (ktimer->timer_advance_adjust_done) {
+		if (ktimer->min_timer_advance_ns > timer_advance_ns)
+			ktimer->min_timer_advance_ns = timer_advance_ns;
+		ktimer->timer_advance_ns = ktimer->min_timer_advance_ns;
 	}
-	apic->lapic_timer.timer_advance_ns = timer_advance_ns;
 }
 
 static void __kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
@@ -1523,7 +1541,8 @@ static void __kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
 	if (guest_tsc < tsc_deadline)
 		__wait_lapic_expire(vcpu, tsc_deadline - guest_tsc);
 
-	if (unlikely(!apic->lapic_timer.timer_advance_adjust_done))
+	if (unlikely(!apic->lapic_timer.timer_advance_adjust_done) ||
+		time_before(apic->lapic_timer.recalc_timer_advance_ns, jiffies))
 		adjust_lapic_timer_advance(vcpu, apic->lapic_timer.advance_expire_delta);
 }
 
@@ -2301,9 +2320,12 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
 	if (timer_advance_ns == -1) {
 		apic->lapic_timer.timer_advance_ns = LAPIC_TIMER_ADVANCE_ADJUST_INIT;
 		apic->lapic_timer.timer_advance_adjust_done = false;
+		apic->lapic_timer.recalc_timer_advance_ns = jiffies;
+		apic->lapic_timer.min_timer_advance_ns = UINT_MAX;
 	} else {
 		apic->lapic_timer.timer_advance_ns = timer_advance_ns;
 		apic->lapic_timer.timer_advance_adjust_done = true;
+		apic->lapic_timer.recalc_timer_advance_ns = MAX_JIFFY_OFFSET;
 	}
 
 
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 50053d2..56a05eb 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -31,6 +31,8 @@ struct kvm_timer {
 	u32 timer_mode_mask;
 	u64 tscdeadline;
 	u64 expired_tscdeadline;
+	unsigned long recalc_timer_advance_ns;
+	u32 min_timer_advance_ns;
 	u32 timer_advance_ns;
 	s64 advance_expire_delta;
 	atomic_t pending;			/* accumulated triggered timers */
-- 
2.7.4

