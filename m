Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFD1BAB023
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 03:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391901AbfIFBaQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Sep 2019 21:30:16 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46396 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732899AbfIFBaQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Sep 2019 21:30:16 -0400
Received: by mail-pg1-f194.google.com with SMTP id m3so2469674pgv.13;
        Thu, 05 Sep 2019 18:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7A2filp88gYNW30KqtsTddaPW1vJgWmE/N1oJgsUja0=;
        b=XklUKNyKTyc8Hs/8yMz9srJeGYceQ07QmpMhvNcGHY0j4mDq7EZxkMStITo3oi2SSL
         TEE1SoOfl8PMBs2woEl3CWqFQjanlC25C4Lpvl0M5X5f45VcFoCyoenBiKcRZ0WsdGWj
         Mxi9Ycgn4YInJoKs6WWbqU3uahUSK2fzZ7JPuwuHtLhALEqujI/GcfNlg+dLByduWDJC
         9u8EmoB1gmmfutKEDWhph/H2xjA1VKKjaKtAss/qGopsF8ahpeiNB6nlzlCBidRaj3gg
         mKJlz/3t59Lh0tNrV6Y+ncQK8hZmtXqzQ2VrppvCRM/gZhxMaSgbym1jnKmS1QscDfQs
         TPQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7A2filp88gYNW30KqtsTddaPW1vJgWmE/N1oJgsUja0=;
        b=Es6MjbV/6v6+Nxr7uBcXzKAVjqGj0aDV046pg49m/lVDRry4WJZLn9TR62mX2qglfF
         wCfDHjAVbogJEcnSDkPw2KGdMBzIWl4cVopuZ8xkOtxmYVqB6H2W1qUpLA24InP2LLK/
         I1IYOc9UU7AO6fuFzZNS0lkUKA+29PYLOabls3gjj4+6B0K33oJvaH0/Wnq8hndRwE0H
         ek0QTm4oMRANLKtoM1JO+SvIFNzlO4k5lh/pEnS1FjruU3WU7+lIw/66P5V507Qgmpnc
         Sro9uFFUAgVrp9tDKknjsEIWbFR8QkerFkwA+KfhtwWCOIsqwUKvMpT8mUY9PTp3nChk
         pDKA==
X-Gm-Message-State: APjAAAWp5UdGCnNl9oqAtYx+ulom1tQhkKX4mCle7tfS4uyRAmmWrn3m
        /mNltoW49PauVFyCIkZNwzbgLlUi
X-Google-Smtp-Source: APXvYqxFnG3Y8aMXP4FrpIDRhqZF/OXp0uMbOHjN2dV0BlzC+z2Y978K+5JoexAfJO0pNIphklpvPA==
X-Received: by 2002:a17:90a:983:: with SMTP id 3mr7227355pjo.57.1567733415131;
        Thu, 05 Sep 2019 18:30:15 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id g11sm3332294pgu.11.2019.09.05.18.30.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 05 Sep 2019 18:30:14 -0700 (PDT)
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
Subject: [PATCH RESEND v3 1/5] KVM: LAPIC: Tune lapic_timer_advance_ns smoothly
Date:   Fri,  6 Sep 2019 09:30:00 +0800
Message-Id: <1567733404-7759-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Using a moving average based on per-vCPU lapic_timer_advance_ns to tune
smoothly, filter out drastic fluctuation which prevents this before,
let's assume it is 10000 cycles.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index e904ff0..2f4a48a 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -69,6 +69,7 @@
 #define LAPIC_TIMER_ADVANCE_ADJUST_INIT 1000
 /* step-by-step approximation to mitigate fluctuation */
 #define LAPIC_TIMER_ADVANCE_ADJUST_STEP 8
+#define LAPIC_TIMER_ADVANCE_FILTER 10000
 
 static inline int apic_test_vector(int vec, void *bitmap)
 {
@@ -1484,23 +1485,28 @@ static inline void adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
 					      s64 advance_expire_delta)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
-	u32 timer_advance_ns = apic->lapic_timer.timer_advance_ns;
-	u64 ns;
+	u32 timer_advance_ns = apic->lapic_timer.timer_advance_ns, ns;
+
+	if (abs(advance_expire_delta) > LAPIC_TIMER_ADVANCE_FILTER)
+		/* filter out drastic fluctuations */
+		return;
 
 	/* too early */
 	if (advance_expire_delta < 0) {
 		ns = -advance_expire_delta * 1000000ULL;
 		do_div(ns, vcpu->arch.virtual_tsc_khz);
-		timer_advance_ns -= min((u32)ns,
-			timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
+		timer_advance_ns -= ns;
 	} else {
 	/* too late */
 		ns = advance_expire_delta * 1000000ULL;
 		do_div(ns, vcpu->arch.virtual_tsc_khz);
-		timer_advance_ns += min((u32)ns,
-			timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
+		timer_advance_ns += ns;
 	}
 
+	timer_advance_ns = (apic->lapic_timer.timer_advance_ns *
+		(LAPIC_TIMER_ADVANCE_ADJUST_STEP - 1) + advance_expire_delta) /
+		LAPIC_TIMER_ADVANCE_ADJUST_STEP;
+
 	if (abs(advance_expire_delta) < LAPIC_TIMER_ADVANCE_ADJUST_DONE)
 		apic->lapic_timer.timer_advance_adjust_done = true;
 	if (unlikely(timer_advance_ns > 5000)) {
-- 
2.7.4

