Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDD4C4E456
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 11:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbfFUJmB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 05:42:01 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42652 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726780AbfFUJkP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 05:40:15 -0400
Received: by mail-pf1-f196.google.com with SMTP id q10so3302354pff.9;
        Fri, 21 Jun 2019 02:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VFFDwCFq2HrwKhsHNYdr3dT1d0gmmMXbwXl7POD+wiY=;
        b=sbgpcQM2m9MBSvQd3EUe0CH/Mk4+9lsnZbyu5Mu/IkNvbK4yFK8dEevd3McuKRNa2f
         a9RGuZ9PaUsNqOBjv6djvkLxwtprLnPhhERbPWDLVYh/ZBKgdeacG/G0IKAkPEqKIlE9
         sZLPEcaPSJMQgVcyOPlZA2/MRc7GEp2a0s6bqpFJWPAksLT2QgK6j4qxwkbONTAOJ1GN
         kKtnyYYcI9d9Y0vzOaFN2P4gip/9QgWNsyCC8PyLJJ5C/rDUEKR1rF1A5msD/eFEkdsp
         l1nnuQ8lWndjdxsQ8nps+mDjxGIitmLZbhaJd5ehXGINdOpuF2QFk+Br+V1Bqp1+6yI5
         l5QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VFFDwCFq2HrwKhsHNYdr3dT1d0gmmMXbwXl7POD+wiY=;
        b=W4qcF5LHgsAVuWCYBpPpyXt7/BEGQgg+HDuPldMiZz0f1oirI6YnzDZz3S7siot4UU
         PGZIsf0JoP7XVVALH9NphMPgH5wXyN9vNNvD5A4CIrW3IWxhkl6tsocCBsgsjVHHnrmg
         jWI1uD6hU7oFLd9PJZwLosi89K/N9HTAYvZpqexBQYRvwxufFEZQwwAUVZ9VwJ1rD+ap
         UlxdO2L53qmPjVZx1meZhALkWuFHshBz4ti61lI9oc5DUuNK3E1ZRepXRfSVt/M9S1Qx
         +DIYGQbFjIqwSIKI/Qs1Gwt9Cbe3ZyKDr2xkIaCOaCoG0V1elezacLORaBnK+unbdgsO
         HBSA==
X-Gm-Message-State: APjAAAWXV+/6fFBjr7FaU1ut4tziUWP8YcnIlp6aDTKtETjpXP8kUCnE
        WDVVof5DlY5GVpFSZfXKupBVHtBu
X-Google-Smtp-Source: APXvYqyHehEeolnb2QZc6Z006tgVoFjj482pMwpaJUF2twxMM4abrBgp+fBdMFxhFpPjJwxEYg6xxQ==
X-Received: by 2002:a17:90a:bb8b:: with SMTP id v11mr5356446pjr.64.1561110014949;
        Fri, 21 Jun 2019 02:40:14 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id y14sm1999506pjr.13.2019.06.21.02.40.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 21 Jun 2019 02:40:14 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v5 1/4] KVM: LAPIC: Make lapic timer unpinned
Date:   Fri, 21 Jun 2019 17:39:59 +0800
Message-Id: <1561110002-4438-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1561110002-4438-1-git-send-email-wanpengli@tencent.com>
References: <1561110002-4438-1-git-send-email-wanpengli@tencent.com>
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
index eb5cd25..d7c757d 100644
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

