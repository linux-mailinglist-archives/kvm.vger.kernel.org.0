Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79D6660873
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2019 16:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbfGEOxG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jul 2019 10:53:06 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37796 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbfGEOxG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jul 2019 10:53:06 -0400
Received: by mail-pl1-f196.google.com with SMTP id b3so1413603plr.4;
        Fri, 05 Jul 2019 07:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ihm5DpKPiZqHZiGf2urEAcUqgCIC8HB8qMNwTNzvb/E=;
        b=k94ubNtx20wcgVGnjkc9C/o8zjZMbnzaVk8Vjsv7zmfizvcTK2YCyPiZvhF0q9acau
         AfKWGwHXbdbXRGNggE01duA891l/8kYvukN65EGMG1BJTgoPtpc69aPTe14lfUw/DSIU
         HDKDLt7p+jdkWeEVo3QNMOLMMH4jHodRBwvswmG3IpmlFJ9LoHvcQ6MJ10kGN5n+jmPq
         g0jwS9jRQ8nWkkYaW61pFm6vbAob03MWBQmljJur1xz0mlKzFJSlZ2u9ugKO7kYMQxkR
         4KyEmZjscs+aXdYrA8bmf2HWZK6ETFOuHlSDvH5/1aNUwpo+46j9PR160rP+aQT5w6l9
         7MdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ihm5DpKPiZqHZiGf2urEAcUqgCIC8HB8qMNwTNzvb/E=;
        b=WQ0cB5noKQZX7xl+tPPgmYfWz25oFh7WxV3BWqoXezCgCUkkZgE/AxyibnEr1L+6Ue
         Nt4Kk0Lx1h9OTffJQ20pV7RWbpv6DfZNxACsnxBhYBha2MnDzuN9QzK4DTzB8eaNmGI2
         CFpfyxbq9FVhBhK+Wq2Echoa8FKSMYMvM/w1MjQ/04V9tbva7YaodD3faBJ4Jpkeec9/
         mjQdMWYlPwlcNp2n9zSiTjwgj627HBhUkkIQwdqTEa6fzoHr7ABIr9TZ6+Wgj0XpY8Pg
         K9IZwSH8t+cxWcPhGBnaSAr09zlMas5Mv3O6Ez3LolcoSl5xm63vA7sD9xACAmW8URdd
         GTIQ==
X-Gm-Message-State: APjAAAXupR5bgvWz+IJjV4hNvMyMj3fZBDl1urkXyCIYpDmhzUC67JwO
        K6vlxKqePd1V6TFOu7ETqZYu5uCzIPE=
X-Google-Smtp-Source: APXvYqwdgZ0xw4G5h5mtmB4enHQ3opKAMcNn2SBJGAys8lv2SsKtZHX2IvBT5IS2vIB1Vl8dyaiy9g==
X-Received: by 2002:a17:902:b48f:: with SMTP id y15mr955134plr.268.1562338385844;
        Fri, 05 Jul 2019 07:53:05 -0700 (PDT)
Received: from localhost ([2409:8a00:7815:93e0:4a4d:7eff:feb0:5c9a])
        by smtp.gmail.com with ESMTPSA id r15sm9567601pfh.121.2019.07.05.07.53.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 07:53:05 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v6 1/2] KVM: LAPIC: Make lapic timer unpinned
Date:   Fri,  5 Jul 2019 22:52:44 +0800
Message-Id: <1562338365-22789-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562338365-22789-1-git-send-email-wanpengli@tencent.com>
References: <1562338365-22789-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Commit 61abdbe0bcc2 ("kvm: x86: make lapic hrtimer pinned") pinned the
lapic timer to avoid to wait until the next kvm exit for the guest to
see KVM_REQ_PENDING_TIMER set. There is another solution to give a kick
after setting the KVM_REQ_PENDING_TIMER bit, make lapic timer unpinned
will be used in follow up patches.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 8 ++++----
 arch/x86/kvm/x86.c   | 6 +-----
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index fcf42a3..9f09100 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1581,7 +1581,7 @@ static void start_sw_tscdeadline(struct kvm_lapic *apic)
 	    likely(ns > apic->lapic_timer.timer_advance_ns)) {
 		expire = ktime_add_ns(now, ns);
 		expire = ktime_sub_ns(expire, ktimer->timer_advance_ns);
-		hrtimer_start(&ktimer->timer, expire, HRTIMER_MODE_ABS_PINNED);
+		hrtimer_start(&ktimer->timer, expire, HRTIMER_MODE_ABS);
 	} else
 		apic_timer_expired(apic);
 
@@ -1683,7 +1683,7 @@ static void start_sw_period(struct kvm_lapic *apic)
 
 	hrtimer_start(&apic->lapic_timer.timer,
 		apic->lapic_timer.target_expiration,
-		HRTIMER_MODE_ABS_PINNED);
+		HRTIMER_MODE_ABS);
 }
 
 bool kvm_lapic_hv_timer_in_use(struct kvm_vcpu *vcpu)
@@ -2320,7 +2320,7 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
 	apic->vcpu = vcpu;
 
 	hrtimer_init(&apic->lapic_timer.timer, CLOCK_MONOTONIC,
-		     HRTIMER_MODE_ABS_PINNED);
+		     HRTIMER_MODE_ABS);
 	apic->lapic_timer.timer.function = apic_timer_fn;
 	if (timer_advance_ns == -1) {
 		apic->lapic_timer.timer_advance_ns = 1000;
@@ -2509,7 +2509,7 @@ void __kvm_migrate_apic_timer(struct kvm_vcpu *vcpu)
 
 	timer = &vcpu->arch.apic->lapic_timer.timer;
 	if (hrtimer_cancel(timer))
-		hrtimer_start_expires(timer, HRTIMER_MODE_ABS_PINNED);
+		hrtimer_start_expires(timer, HRTIMER_MODE_ABS);
 }
 
 /*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3a7cd935..e199ac7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1437,12 +1437,8 @@ static void update_pvclock_gtod(struct timekeeper *tk)
 
 void kvm_set_pending_timer(struct kvm_vcpu *vcpu)
 {
-	/*
-	 * Note: KVM_REQ_PENDING_TIMER is implicitly checked in
-	 * vcpu_enter_guest.  This function is only called from
-	 * the physical CPU that is running vcpu.
-	 */
 	kvm_make_request(KVM_REQ_PENDING_TIMER, vcpu);
+	kvm_vcpu_kick(vcpu);
 }
 
 static void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock)
-- 
1.8.3.1

