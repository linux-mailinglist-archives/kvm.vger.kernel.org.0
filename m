Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3180B4902
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 10:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387401AbfIQIQl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 04:16:41 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44219 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfIQIQk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 04:16:40 -0400
Received: by mail-pl1-f193.google.com with SMTP id k24so347723pll.11;
        Tue, 17 Sep 2019 01:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mgukzCtnclCW/hH0uFMjnqXIijt7Mvy5DsHXeaPWECE=;
        b=aY+iFmHYIF6t7XIv33dW0IGxufDOC4JFNAtk94pzw3JQrwBFs9vJdyD6pJjIBE2LKR
         O1EecKgPXResbqetQCjLqch20H+MWmr+FYQHtg1NAC9/jOi6902463MXTIqk822fwbHd
         xbYLoDlLJdKCiFb3Zndd60LWYkFgf8IfTWkqxPR05TDyExYQJ2wxTncnHEZDsZz301oY
         z8SlDDsZFLBSEMQIYHj8Zlos6PYzC6UcDlAbYC8tzSt23STldWChc27x5yZAJPL9fbpI
         RK82f14lTEwSfz1jhcSv7I+uJUMB9xVc4P3ApKhnOp0d7MKrPpFpPfkLrnmn8MkTGaNL
         ABAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mgukzCtnclCW/hH0uFMjnqXIijt7Mvy5DsHXeaPWECE=;
        b=kyDojjPeZVmDH1HWh2r/PZ6eKjy/6RGA+wdyGvApCTquGivRFB0L5/1lLHGz44REH0
         8ignW2OI/IlpXn053kTFVtV6ewhpVl1OfoYJ9iFL8YuzBwbIWQ88tQx0PIUgEOAxRqoC
         xfcVfy1dj5yaHhzgQfjlVmCgsr81aZ3KGRaTzy90kEMawIOFUvBGZFRJFDPAIOdfJDGX
         cSFaupI2RNRPJhxUTNTK/j0d3bugsyPg+3Pq8HTaAio5zIIoRvjVjEus+XKQBVQLTygT
         Jw1WJ0GSsRkn7dwzEhcOma2vhh2muiPViguv4eFbfHx+SKEapbBZGDHoWkkrSxha+qSA
         dfjg==
X-Gm-Message-State: APjAAAVqpJg1hJlMmw4ic6+FpHEEStyKp28+tuehGlcp8VxOTDoxUczS
        w/4bciDWePZORX6yGjPtiK4oW1Ti
X-Google-Smtp-Source: APXvYqzGqOXY+sIUFWupOkrIA0xrZ4XOZ746IgCkW0V7c3zoO9XbpqMSLA+PA/hpRbm2meAV2xArtw==
X-Received: by 2002:a17:902:9a92:: with SMTP id w18mr2345703plp.255.1568708199199;
        Tue, 17 Sep 2019 01:16:39 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id j10sm1924142pfh.137.2019.09.17.01.16.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 17 Sep 2019 01:16:38 -0700 (PDT)
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
Subject: [PATCH v5 3/3] KVM: LAPIC: Tune lapic_timer_advance_ns smoothly
Date:   Tue, 17 Sep 2019 16:16:26 +0800
Message-Id: <1568708186-20260-3-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1568708186-20260-1-git-send-email-wanpengli@tencent.com>
References: <1568708186-20260-1-git-send-email-wanpengli@tencent.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Filter out drastic fluctuation and random fluctuation, remove
timer_advance_adjust_done altogether, the adjustment would be
continuous.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 28 ++++++++++++++--------------
 arch/x86/kvm/lapic.h |  1 -
 2 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index dbbe478..323bdca 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -65,7 +65,9 @@
 #define APIC_BROADCAST			0xFF
 #define X2APIC_BROADCAST		0xFFFFFFFFul
 
-#define LAPIC_TIMER_ADVANCE_ADJUST_DONE 100
+static bool dynamically_adjust_timer_advance __read_mostly;
+#define LAPIC_TIMER_ADVANCE_ADJUST_MIN 100
+#define LAPIC_TIMER_ADVANCE_ADJUST_MAX 5000
 #define LAPIC_TIMER_ADVANCE_ADJUST_INIT 1000
 /* step-by-step approximation to mitigate fluctuation */
 #define LAPIC_TIMER_ADVANCE_ADJUST_STEP 8
@@ -1485,26 +1487,25 @@ static inline void adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
 	u32 timer_advance_ns = apic->lapic_timer.timer_advance_ns;
 	u64 ns;
 
+	/* Do not adjust for tiny fluctuations or large random spikes. */
+	if (abs(advance_expire_delta) > LAPIC_TIMER_ADVANCE_ADJUST_MAX ||
+	    abs(advance_expire_delta) < LAPIC_TIMER_ADVANCE_ADJUST_MIN)
+		return;
+
 	/* too early */
 	if (advance_expire_delta < 0) {
 		ns = -advance_expire_delta * 1000000ULL;
 		do_div(ns, vcpu->arch.virtual_tsc_khz);
-		timer_advance_ns -= min((u32)ns,
-			timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
+		timer_advance_ns -= ns/LAPIC_TIMER_ADVANCE_ADJUST_STEP;
 	} else {
 	/* too late */
 		ns = advance_expire_delta * 1000000ULL;
 		do_div(ns, vcpu->arch.virtual_tsc_khz);
-		timer_advance_ns += min((u32)ns,
-			timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
+		timer_advance_ns += ns/LAPIC_TIMER_ADVANCE_ADJUST_STEP;
 	}
 
-	if (abs(advance_expire_delta) < LAPIC_TIMER_ADVANCE_ADJUST_DONE)
-		apic->lapic_timer.timer_advance_adjust_done = true;
-	if (unlikely(timer_advance_ns > 5000)) {
+	if (unlikely(timer_advance_ns > LAPIC_TIMER_ADVANCE_ADJUST_MAX))
 		timer_advance_ns = LAPIC_TIMER_ADVANCE_ADJUST_INIT;
-		apic->lapic_timer.timer_advance_adjust_done = false;
-	}
 	apic->lapic_timer.timer_advance_ns = timer_advance_ns;
 }
 
@@ -1524,7 +1525,7 @@ static void __kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
 	if (guest_tsc < tsc_deadline)
 		__wait_lapic_expire(vcpu, tsc_deadline - guest_tsc);
 
-	if (unlikely(!apic->lapic_timer.timer_advance_adjust_done))
+	if (dynamically_adjust_timer_advance)
 		adjust_lapic_timer_advance(vcpu, apic->lapic_timer.advance_expire_delta);
 }
 
@@ -2302,13 +2303,12 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
 	apic->lapic_timer.timer.function = apic_timer_fn;
 	if (timer_advance_ns == -1) {
 		apic->lapic_timer.timer_advance_ns = LAPIC_TIMER_ADVANCE_ADJUST_INIT;
-		apic->lapic_timer.timer_advance_adjust_done = false;
+		dynamically_adjust_timer_advance = true;
 	} else {
 		apic->lapic_timer.timer_advance_ns = timer_advance_ns;
-		apic->lapic_timer.timer_advance_adjust_done = true;
+		dynamically_adjust_timer_advance = false;
 	}
 
-
 	/*
 	 * APIC is created enabled. This will prevent kvm_lapic_set_base from
 	 * thinking that APIC state has changed.
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 50053d2..2aad7e2 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -35,7 +35,6 @@ struct kvm_timer {
 	s64 advance_expire_delta;
 	atomic_t pending;			/* accumulated triggered timers */
 	bool hv_timer_in_use;
-	bool timer_advance_adjust_done;
 };
 
 struct kvm_lapic {
-- 
2.7.4

