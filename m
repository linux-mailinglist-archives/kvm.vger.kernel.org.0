Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 642DCB3681
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2019 10:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731131AbfIPIkG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Sep 2019 04:40:06 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33475 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfIPIkG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Sep 2019 04:40:06 -0400
Received: by mail-pl1-f196.google.com with SMTP id t11so16600262plo.0;
        Mon, 16 Sep 2019 01:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=7SaNALNS0XQc4DieafiXumuTeR5mH5E0tN6UvZLTouA=;
        b=HvpZyV9l4lsF6zOrXsLRLOTScgXD3xzucd73QTuHe3FvGhOcEZNClZ9+KW4+C1AN7U
         uOzr/xPcA2ddEC2LFDwaQYJb1+5JlxLcpjRDaERbOK/gMDgKTamLCOVC0rnOL/eHqsUK
         OwIkyMxGS6TBBvm31jLiTYA8RWW+pGf3YTj9Y1eGaL2Af/+3emPQ13fsX3cGtirgToEv
         5MLibt6SEgk6PvzhdWo7uMQlzl9w5oKCVnyVyWOpZ+kZEA1lvN+cw2ueUAz2VDlos9Lu
         4G8ZRuh/vT3LgNrSdecr5PqVmyU58xpkstcAC2c7FFmy8ZOduSIq9ydpiclr8gLMbFBP
         bNvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7SaNALNS0XQc4DieafiXumuTeR5mH5E0tN6UvZLTouA=;
        b=PfbW52FHT16AZeQ2fXHg19LQ134yFU9QSPqqk+gOHYAvik1rHuPXsUTrUBSkp0zFQC
         DZ1RRb5zIR8Hdk9CIuAvCgdD/WP7giqq9ZNzM5O704vU46m8rZw7R/XTGMQ+AEwrbZSC
         Dy8p+qerXUzvGX+zjp2u2C2VO0yrfyHfwmk+yqUbjBlGBwk9RxuqjjX4Vw79QI/werLr
         VqK0W8uHLyLxUILlMp9tyN4ULtziwYiYNxfzuNecqJ7I5NjyCjdjaIAdkUwSvTqJ0dQ/
         mqP9eW3txUjgDFXEiqXZDZ9UaCZNg3YBULztYzKCHtZB0a0jglkOD22X/USjOp48DH/J
         r9Fw==
X-Gm-Message-State: APjAAAWXQsWR67AJt6P8wFlTzm+EhlYziTKrQFjYE73WumJYGn5kvKI1
        Bwh3Xi29elk1OseJMOh6Yvy+wEgg
X-Google-Smtp-Source: APXvYqwu5cITqeiAEi4QFL9pRpNDpoDeJfXYSOvd9YwqHTvOD69wHbpDN7UWVLcnsyMqq7KXJJq/jw==
X-Received: by 2002:a17:902:b40c:: with SMTP id x12mr63973886plr.145.1568623204869;
        Mon, 16 Sep 2019 01:40:04 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id l124sm32781547pgl.54.2019.09.16.01.40.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 16 Sep 2019 01:40:04 -0700 (PDT)
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
Subject: [PATCH v4] KVM: LAPIC: Tune lapic_timer_advance_ns smoothly
Date:   Mon, 16 Sep 2019 16:39:59 +0800
Message-Id: <1568623199-5294-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
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
 arch/x86/kvm/lapic.c | 26 ++++++++++++--------------
 arch/x86/kvm/lapic.h |  1 -
 arch/x86/kvm/x86.c   |  2 +-
 arch/x86/kvm/x86.h   |  1 +
 4 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index dbbe478..2585b86 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -69,6 +69,7 @@
 #define LAPIC_TIMER_ADVANCE_ADJUST_INIT 1000
 /* step-by-step approximation to mitigate fluctuation */
 #define LAPIC_TIMER_ADVANCE_ADJUST_STEP 8
+#define LAPIC_TIMER_ADVANCE_FILTER 5000
 
 static inline int apic_test_vector(int vec, void *bitmap)
 {
@@ -1482,29 +1483,28 @@ static inline void adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
 					      s64 advance_expire_delta)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
-	u32 timer_advance_ns = apic->lapic_timer.timer_advance_ns;
-	u64 ns;
+	u32 timer_advance_ns = apic->lapic_timer.timer_advance_ns, ns;
+
+	if (abs(advance_expire_delta) > LAPIC_TIMER_ADVANCE_FILTER ||
+		abs(advance_expire_delta) < LAPIC_TIMER_ADVANCE_ADJUST_DONE) {
+		/* filter out random fluctuations */
+		return;
+	}
 
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
+	if (unlikely(timer_advance_ns > 5000))
 		timer_advance_ns = LAPIC_TIMER_ADVANCE_ADJUST_INIT;
-		apic->lapic_timer.timer_advance_adjust_done = false;
-	}
 	apic->lapic_timer.timer_advance_ns = timer_advance_ns;
 }
 
@@ -1524,7 +1524,7 @@ static void __kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
 	if (guest_tsc < tsc_deadline)
 		__wait_lapic_expire(vcpu, tsc_deadline - guest_tsc);
 
-	if (unlikely(!apic->lapic_timer.timer_advance_adjust_done))
+	if (lapic_timer_advance_ns == -1)
 		adjust_lapic_timer_advance(vcpu, apic->lapic_timer.advance_expire_delta);
 }
 
@@ -2302,10 +2302,8 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
 	apic->lapic_timer.timer.function = apic_timer_fn;
 	if (timer_advance_ns == -1) {
 		apic->lapic_timer.timer_advance_ns = LAPIC_TIMER_ADVANCE_ADJUST_INIT;
-		apic->lapic_timer.timer_advance_adjust_done = false;
 	} else {
 		apic->lapic_timer.timer_advance_ns = timer_advance_ns;
-		apic->lapic_timer.timer_advance_adjust_done = true;
 	}
 
 
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
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 83288ba..bb4574c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -141,7 +141,7 @@ module_param(tsc_tolerance_ppm, uint, S_IRUGO | S_IWUSR);
  * advancement entirely.  Any other value is used as-is and disables adaptive
  * tuning, i.e. allows priveleged userspace to set an exact advancement time.
  */
-static int __read_mostly lapic_timer_advance_ns = -1;
+int __read_mostly lapic_timer_advance_ns = -1;
 module_param(lapic_timer_advance_ns, int, S_IRUGO | S_IWUSR);
 
 static bool __read_mostly vector_hashing = true;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index b5274e2..1bf2d82 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -301,6 +301,7 @@ extern unsigned int min_timer_period_us;
 
 extern bool enable_vmware_backdoor;
 
+extern int lapic_timer_advance_ns;
 extern int pi_inject_timer;
 
 extern struct static_key kvm_no_apic_vcpu;
-- 
2.7.4

