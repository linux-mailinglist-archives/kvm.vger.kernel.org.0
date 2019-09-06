Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5598CAB024
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 03:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391922AbfIFBaU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Sep 2019 21:30:20 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37330 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391913AbfIFBaS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Sep 2019 21:30:18 -0400
Received: by mail-pf1-f196.google.com with SMTP id y5so427057pfo.4;
        Thu, 05 Sep 2019 18:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TGB4uJiUeL5Fo2JfDzEml4xHl1KEyJtx9FM84cwKunw=;
        b=dstsaqxCZRcfN6gGH6ctFsOO7xhq5phOxmqAm/OB1NMyIBTc0QTP8lK8u29elsTd6T
         JnzSPMr3Uu0gU6diT7nvgY1fbXUwy88aPlQTtNVWDIWJuwMYlK7YaXNWPQxKyK1b+xj2
         fQmL2Yv9U/7++ML6zUAtFHJqTjnY5v1rLmcNTHMWonaTkoTdyIxzbxDHZctYHNpq2suy
         Ftj36gQRIaZX2cxdTi/d4MwgOvDroDzu+6jCOd5ycHHFfR9jaGcI+8ypcTMOELJfSIC0
         iCUDVKSUY6p4tdxQ9LL/DieyvZ0gERKPGv8yD3tcy5v57qPfk1niukCxM+khJfJdPJn7
         X/kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TGB4uJiUeL5Fo2JfDzEml4xHl1KEyJtx9FM84cwKunw=;
        b=OU6F5xjKVn0zA2GEpbiOayp6Ear6bBS4m1bHu/vp7BVmb/DDNvgzorfiYgvPaeDGkN
         AoQZYgHcbUmjbQRFS6Wow2esStxS3n/T5Z/qxmJ+8fExosOUFMtZsPEgczG0YDUEVvwI
         3EFkIHxZaXOH26bqOKjPtliN9hAxxUT4SkfJruNN5V3Sh6tJdRqOw2fIz9aAmvno2ssM
         2N9g7WpyRhtULQgWyWS46llWLsvP3n4vi7jv4qsgRU5svt0ZBzNtkKtWlyM34752J7if
         YViSP/nXGFVM2Xesmabpe2gjQjoVL7hdSGMUIksSGHZSSbx4gg4HHsoMZ/xHCGl6z6XN
         veYg==
X-Gm-Message-State: APjAAAUspCAIMOsiKT0puvLtYae0LbX/aSYRX/g7ZC0/Hq45wvaJmnnj
        KqtO5bQuqOOQTFwswdM9Q4mFWJ53
X-Google-Smtp-Source: APXvYqwkT90touvJ1jKr02oZ3a3Vt6s2FTsqRJSY6OLRK0rLVNyYttyEO3FHF6pjnBUTXKcMWLsP6g==
X-Received: by 2002:a17:90a:b118:: with SMTP id z24mr7107999pjq.79.1567733417905;
        Thu, 05 Sep 2019 18:30:17 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id g11sm3332294pgu.11.2019.09.05.18.30.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 05 Sep 2019 18:30:17 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH RESEND v3 2/5] KVM: LAPIC: Periodically revaluate to get conservative lapic_timer_advance_ns
Date:   Fri,  6 Sep 2019 09:30:01 +0800
Message-Id: <1567733404-7759-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1567733404-7759-1-git-send-email-wanpengli@tencent.com>
References: <1567733404-7759-1-git-send-email-wanpengli@tencent.com>
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
index 2f4a48a..12ade70 100644
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
 		/* filter out drastic fluctuations */
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

