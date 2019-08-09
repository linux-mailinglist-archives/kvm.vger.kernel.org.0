Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B623A871AD
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 07:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405423AbfHIFpm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 01:45:42 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46422 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728823AbfHIFpl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Aug 2019 01:45:41 -0400
Received: by mail-pf1-f195.google.com with SMTP id c3so22286380pfa.13;
        Thu, 08 Aug 2019 22:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ue6XQOVELq822OL849VifImiATioxfu/TeuZwZ8ImaU=;
        b=i5mJ24dj0cY9P0PFAkhFAQMwXDmNXe6yn9jSB1SKUxOhhdQ3sbdEyW7QKzLX9hW3ac
         uhR18WP8/H3o/bCrn+HGoXCDhQxT/OiiznrZST3tAFkwO42W20XdVtXpNsFko8gr1SXL
         kJcaT5XGeCAfWIyo0Q2BDs53mqBeITXLsrwCR+JUNWANQIiBFUlUcd4CFtarcfVge6dP
         Ehb51ogx9/HXI8YgWci4vqJkb5Ad4Ub8IGNX2C3InfFG2kB2fazs0bkbOz8vHH+lRMtd
         +72g7jWlqKUc10ovgls967zFaS8qm26eJvFH5Rsrg9nyYExzZgOSna60rBzOvD/FurO/
         Df+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ue6XQOVELq822OL849VifImiATioxfu/TeuZwZ8ImaU=;
        b=Xcmsy79jJNJvsUF8MYrfcZbo5JV20YFiU0m499QnS0BM/iqnGF0xW+2cLqhgKrxt0R
         FUE8b4w5PtwYmNEO25cJckCETN6WZeH3FKbP4uCCXm8InkX+/QRTnBIJT9LAMagJRTIQ
         4FYzRsEgrcX/ptN2nfcFHaKsP+2uxP2JqUqY+15AMLZltwNNKpIVCx7QVgczFzzDPKvs
         Fc/+HZbhZhR6Xrg5ZIj84dyW+E0kDnku0W9YyPdCyFKxOyulICHJShzgCHo7AHZ4oLCm
         Vofv/fe3vEH2Nx8L4OrwUwsSHTJP1gCo7Bgoio3viGTxzAm0Nei2gn3zTAJ3vl9PLmPF
         fbTg==
X-Gm-Message-State: APjAAAV0rYhFBcABmJFauPX9VpF0GNkL7tEEASukKDLx60ulWQKzfHNm
        XmWV09Jc1Lw12pXVM6vSl8Gdmegb
X-Google-Smtp-Source: APXvYqz6aMQmF1wFSgot6F6bpSHRmLbub+V9kgYra0iqiBf3fMNKa1WTCcIw4PNc5W1csX0RZlW3MA==
X-Received: by 2002:a63:29c4:: with SMTP id p187mr16304648pgp.330.1565329541085;
        Thu, 08 Aug 2019 22:45:41 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id c12sm1167614pfc.22.2019.08.08.22.45.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 08 Aug 2019 22:45:40 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH] KVM: LAPIC: Periodically revaluate appropriate lapic_timer_advance_ns
Date:   Fri,  9 Aug 2019 13:45:31 +0800
Message-Id: <1565329531-12327-1-git-send-email-wanpengli@tencent.com>
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
of higher-priority RT tasks, etc can cause different response. These 
interferences should be considered and periodically revaluate whether 
or not the lapic_timer_advance_ns value is the best, do nothing if it is,
otherwise recaluate again. 

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 16 +++++++++++++++-
 arch/x86/kvm/lapic.h |  1 +
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index df5cd07..8b62008 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -69,6 +69,7 @@
 #define LAPIC_TIMER_ADVANCE_ADJUST_INIT 1000
 /* step-by-step approximation to mitigate fluctuation */
 #define LAPIC_TIMER_ADVANCE_ADJUST_STEP 8
+#define LAPIC_TIMER_ADVANCE_RECALC_PERIOD (600 * HZ)
 
 static inline int apic_test_vector(int vec, void *bitmap)
 {
@@ -1484,6 +1485,17 @@ static inline void adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
 	u32 timer_advance_ns = apic->lapic_timer.timer_advance_ns;
 	u64 ns;
 
+	/* periodic revaluate */
+	if (unlikely(apic->lapic_timer.timer_advance_adjust_done)) {
+		apic->lapic_timer.recalc_timer_advance_ns = jiffies +
+			LAPIC_TIMER_ADVANCE_RECALC_PERIOD;
+		if (abs(advance_expire_delta) > LAPIC_TIMER_ADVANCE_ADJUST_DONE) {
+			timer_advance_ns = LAPIC_TIMER_ADVANCE_ADJUST_INIT;
+			apic->lapic_timer.timer_advance_adjust_done = false;
+		} else
+			return;
+	}
+
 	/* too early */
 	if (advance_expire_delta < 0) {
 		ns = -advance_expire_delta * 1000000ULL;
@@ -1523,7 +1535,8 @@ static void __kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
 	if (guest_tsc < tsc_deadline)
 		__wait_lapic_expire(vcpu, tsc_deadline - guest_tsc);
 
-	if (unlikely(!apic->lapic_timer.timer_advance_adjust_done))
+	if (unlikely(!apic->lapic_timer.timer_advance_adjust_done) ||
+		time_before(apic->lapic_timer.recalc_timer_advance_ns, jiffies))
 		adjust_lapic_timer_advance(vcpu, apic->lapic_timer.advance_expire_delta);
 }
 
@@ -2301,6 +2314,7 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
 	if (timer_advance_ns == -1) {
 		apic->lapic_timer.timer_advance_ns = LAPIC_TIMER_ADVANCE_ADJUST_INIT;
 		apic->lapic_timer.timer_advance_adjust_done = false;
+		apic->lapic_timer.recalc_timer_advance_ns = jiffies;
 	} else {
 		apic->lapic_timer.timer_advance_ns = timer_advance_ns;
 		apic->lapic_timer.timer_advance_adjust_done = true;
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 50053d2..31ced36 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -31,6 +31,7 @@ struct kvm_timer {
 	u32 timer_mode_mask;
 	u64 tscdeadline;
 	u64 expired_tscdeadline;
+	unsigned long recalc_timer_advance_ns;
 	u32 timer_advance_ns;
 	s64 advance_expire_delta;
 	atomic_t pending;			/* accumulated triggered timers */
-- 
2.7.4

