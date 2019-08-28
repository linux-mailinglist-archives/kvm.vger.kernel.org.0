Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F21F9FCBE
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 10:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbfH1ITL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 04:19:11 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39551 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726292AbfH1ITK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 04:19:10 -0400
Received: by mail-pl1-f194.google.com with SMTP id z3so879175pln.6;
        Wed, 28 Aug 2019 01:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WVoeqiGiZ4nu6Q909wAoBPyYj23gPo7bnXC/Lr1ZM1k=;
        b=khdDOmP7Jlqyxu80lp3fMRc3gx+AZcHSjPWLSQWOuweyruFtZGUWqGD+Oi7u2cyD4G
         zK126fM6COHNKsWF7k8BdP71Tu0GxtvigSzXUFSJpVE2V6ngyV5U5eZTutMXQK3SW6Vk
         vQDb+KJkdzxHLM0K8hgrM75Ormh2UkEu66rzq9KAXJgjduDEGh+D4nHgmjymqrPp8wz1
         mK2ADCyWz/x+Q0OHH6XLoKa8SK39qbq3mzfxxxuK3BgVrDFe5KMd7aOxq8gT+vEOLmPC
         DjhkxIpzHaeFMKO9+5WgM8drqYyCdzl2pArZSzS7eCALIJMudbll1w7f1tRskon328s5
         VjBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WVoeqiGiZ4nu6Q909wAoBPyYj23gPo7bnXC/Lr1ZM1k=;
        b=qikj7v4xS3DP6O3sT9k40Rg0Jv7DbO2CW/vGvX3n0ZwkpoRAHptjraTFBfgRzC592/
         Zxd96aAHgF7IWXgO8MDxXvUeK4ZrrVJt6OWpkGPFCQDHNHlovNBoYaPnogA4t6Z6/oSm
         Dwgz+6ZDmN5C5D+zdma+llGDpjKyINM1TmECKEGNUY1TGMqVO5mYznabMSu74yEtwFAe
         +xZq66lgpj6N4JudgsxIMHFXxz+t7IQH7wSZ+85Ht+xDg1aybdHEeaPUXYCzWA+rbJ7q
         ByddrJKe+7bh25pj/thiehgbImVhrQ4zlyWKuoLWAEQvOqOwfulEqIc9QgTy2LUz5NnS
         Q/SA==
X-Gm-Message-State: APjAAAW0A4nMKCO+fjX5MBF/PNLoeVdQ+KsP/krkD/DbcfZ0A+jUtcaM
        5EAKK1V2pPfyyK58A5DDOXGR2eIF
X-Google-Smtp-Source: APXvYqyRwfX45FcdIsLtQ+sxhz//pG/53RrYP2FeeekbCtG5PezSvfWU4+ViqAuDIuuJwfsyWVOYQg==
X-Received: by 2002:a17:902:e30b:: with SMTP id cg11mr3106476plb.335.1566980349353;
        Wed, 28 Aug 2019 01:19:09 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id g1sm1787263pgg.27.2019.08.28.01.19.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 28 Aug 2019 01:19:08 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH v3 2/2] KVM: LAPIC: Periodically revaluate to get conservative lapic_timer_advance_ns
Date:   Wed, 28 Aug 2019 16:19:02 +0800
Message-Id: <1566980342-22045-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1566980342-22045-1-git-send-email-wanpengli@tencent.com>
References: <1566980342-22045-1-git-send-email-wanpengli@tencent.com>
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
 arch/x86/kvm/lapic.c | 37 ++++++++++++++++++++++++++++++-------
 arch/x86/kvm/lapic.h |  2 ++
 2 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 181537a..4421583 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -70,6 +70,7 @@
 /* step-by-step approximation to mitigate fluctuation */
 #define LAPIC_TIMER_ADVANCE_ADJUST_STEP 8
 #define LAPIC_TIMER_ADVANCE_FILTER 10000
+#define LAPIC_TIMER_ADVANCE_RECALC_PERIOD (600 * HZ)
 
 static inline int apic_test_vector(int vec, void *bitmap)
 {
@@ -1484,13 +1485,24 @@ static inline void __wait_lapic_expire(struct kvm_vcpu *vcpu, u64 guest_cycles)
 static inline void adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
 					      s64 advance_expire_delta)
 {
-	struct kvm_lapic *apic = vcpu->arch.apic;
-	u32 timer_advance_ns = apic->lapic_timer.timer_advance_ns, ns;
+	struct kvm_timer *ktimer = &vcpu->arch.apic->lapic_timer;
+	u32 timer_advance_ns = ktimer->timer_advance_ns, ns;
 
 	if (abs(advance_expire_delta) > LAPIC_TIMER_ADVANCE_FILTER)
 		/* filter out drastic flunctuations */
 		return;
 
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
@@ -1503,17 +1515,24 @@ static inline void adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
 		timer_advance_ns += ns;
 	}
 
-	timer_advance_ns = (apic->lapic_timer.timer_advance_ns *
+	timer_advance_ns = (ktimer->timer_advance_ns *
 		(LAPIC_TIMER_ADVANCE_ADJUST_STEP - 1) + advance_expire_delta) /
 		LAPIC_TIMER_ADVANCE_ADJUST_STEP;
 
 	if (abs(advance_expire_delta) < LAPIC_TIMER_ADVANCE_ADJUST_DONE)
-		apic->lapic_timer.timer_advance_adjust_done = true;
+		ktimer->timer_advance_adjust_done = true;
 	if (unlikely(timer_advance_ns > 5000)) {
 		timer_advance_ns = LAPIC_TIMER_ADVANCE_ADJUST_INIT;
-		apic->lapic_timer.timer_advance_adjust_done = false;
+		ktimer->timer_advance_adjust_done = false;
+	}
+
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
@@ -1532,7 +1551,8 @@ static void __kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
 	if (guest_tsc < tsc_deadline)
 		__wait_lapic_expire(vcpu, tsc_deadline - guest_tsc);
 
-	if (unlikely(!apic->lapic_timer.timer_advance_adjust_done))
+	if (unlikely(!apic->lapic_timer.timer_advance_adjust_done) ||
+		time_before(apic->lapic_timer.recalc_timer_advance_ns, jiffies))
 		adjust_lapic_timer_advance(vcpu, apic->lapic_timer.advance_expire_delta);
 }
 
@@ -2310,9 +2330,12 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
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

