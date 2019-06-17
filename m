Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF6D4808A
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 13:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbfFQLY4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 07:24:56 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46815 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbfFQLYz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 07:24:55 -0400
Received: by mail-pf1-f194.google.com with SMTP id 81so5512603pfy.13;
        Mon, 17 Jun 2019 04:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VPkm7l4VeiELN51pZzP+PaqYBLqHW5sgirUO1tigA+g=;
        b=G87a2jhJkEOOjCiBrYGFMNC8zPCsOK6ab/xLFtyqdf/Z+1JP0TS2+X+eQQsE4OSQuV
         y3xLkH6tCSUuwt+Mnk7qTewAYxeQrP5fV/SRqbP/tbae+cgYep8FNUamVLZgZGruWatV
         g5ZluZPcmnd3Qd7swbFZabNlAxJJEjfjSfxOQWjph/ADFGlqztRCIfrjOOjR2UfRUBvv
         dwpHyZYIDPq0qBbB9JSEpUqrJeoUengrwm9JjzfOihiGMkUYfgshw7ytWJaV3Vq9u1rx
         enB5/neixifc+fl3UWSHPppFl+8clUxxtsWzNqWP0aLjycnlbK4lmr7nl0p9kBOZsb88
         NgDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VPkm7l4VeiELN51pZzP+PaqYBLqHW5sgirUO1tigA+g=;
        b=QBKzKQAoMzgbZ+mA1DRPB8Xl2dUDUBQg4Se70Q6CiDPNFF292/067FHF08E4qyo1Ki
         G/kVePHfcyetBc+XQH4qhdOG6leKg7auvmzE7UpFLVvcuEC1OAyHJFUx1FJftEqzyp1/
         zQuEiw7I8uFHl8XJ0ogafNDq2U2BU32i2djJvBu8xZhTNI/afOeFs0+B7Sf78mJc/6je
         UfCL+WcO89IJmr8kc0RA5CKxyyOk6bemp2adnABrtIDij+Jv5Oop1MwAIjJov/Eo1eia
         WSBjVxJLTs25i3DuTCsleBuej/+ST2uG5UdlZzba/mKYCi7X5I5NdsWjwMc+yhNwYWEp
         4WjA==
X-Gm-Message-State: APjAAAXwRK+ewct+14vJkEF2vpdWvx1TTsiK/biqmgo4xfuHq6acI92Y
        bOhx3TN6UjyIxq46OJtBzXEsxoTT
X-Google-Smtp-Source: APXvYqwxhtoBEkhaFfY8r0zFwcCzukJ7n98p0AE6tvjddXpQIKC1jgoEx9ua8oayHUL6ZomMTNlKzA==
X-Received: by 2002:a63:e50c:: with SMTP id r12mr48546521pgh.284.1560770694727;
        Mon, 17 Jun 2019 04:24:54 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id d4sm12535751pfc.149.2019.06.17.04.24.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 17 Jun 2019 04:24:54 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v4 1/5] KVM: LAPIC: Make lapic timer unpinned
Date:   Mon, 17 Jun 2019 19:24:43 +0800
Message-Id: <1560770687-23227-2-git-send-email-wanpengli@tencent.com>
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

Make lapic timer unpinned when timer is injected by posted-interrupt,
the emulated timer can be offload to the housekeeping cpus, kick after 
setting the pending timer request as alternative to commit 61abdbe0bcc.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 8 ++++----
 arch/x86/kvm/x86.c   | 6 +-----
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index e82a18c..87ecb56 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1578,7 +1578,7 @@ static void start_sw_tscdeadline(struct kvm_lapic *apic)
 	    likely(ns > apic->lapic_timer.timer_advance_ns)) {
 		expire = ktime_add_ns(now, ns);
 		expire = ktime_sub_ns(expire, ktimer->timer_advance_ns);
-		hrtimer_start(&ktimer->timer, expire, HRTIMER_MODE_ABS_PINNED);
+		hrtimer_start(&ktimer->timer, expire, HRTIMER_MODE_ABS);
 	} else
 		apic_timer_expired(apic);
 
@@ -1680,7 +1680,7 @@ static void start_sw_period(struct kvm_lapic *apic)
 
 	hrtimer_start(&apic->lapic_timer.timer,
 		apic->lapic_timer.target_expiration,
-		HRTIMER_MODE_ABS_PINNED);
+		HRTIMER_MODE_ABS);
 }
 
 bool kvm_lapic_hv_timer_in_use(struct kvm_vcpu *vcpu)
@@ -2317,7 +2317,7 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
 	apic->vcpu = vcpu;
 
 	hrtimer_init(&apic->lapic_timer.timer, CLOCK_MONOTONIC,
-		     HRTIMER_MODE_ABS_PINNED);
+		     HRTIMER_MODE_ABS);
 	apic->lapic_timer.timer.function = apic_timer_fn;
 	if (timer_advance_ns == -1) {
 		apic->lapic_timer.timer_advance_ns = 1000;
@@ -2506,7 +2506,7 @@ void __kvm_migrate_apic_timer(struct kvm_vcpu *vcpu)
 
 	timer = &vcpu->arch.apic->lapic_timer.timer;
 	if (hrtimer_cancel(timer))
-		hrtimer_start_expires(timer, HRTIMER_MODE_ABS_PINNED);
+		hrtimer_start_expires(timer, HRTIMER_MODE_ABS);
 }
 
 /*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0a05a4e..9450a16 100644
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
2.7.4

