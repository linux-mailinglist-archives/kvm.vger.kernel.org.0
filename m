Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60EC360E6D
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2019 03:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbfGFB1C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jul 2019 21:27:02 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34709 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbfGFB1B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jul 2019 21:27:01 -0400
Received: by mail-pf1-f195.google.com with SMTP id b13so357995pfo.1;
        Fri, 05 Jul 2019 18:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yNvToFIJovK2pBeJ7epra0lfm0gCiwq1cqi8D6XJ5nM=;
        b=WvTz2Vkj7YDqaZu+NdecjBdrXts9mPL6tCGtIYxvCZRPCO4CZOPnV8M9C99jxxUevB
         tyBnFlUfiyvYfEDbuqGztJU7WDMmriKKgvzgKEUYeGAcFLHyPpYPw6oUwUHgiS5PKoHK
         oQWYII9kv4Wx74XchFCTBTmEcozO2OKXerFsJ1LlzaktucI6m/vsbrQwHDqhz0+Xom+H
         JUe6i0fEkefWF20IriLBUNn9NjdxmxLqdV54wb6+DZelToxMXH+LMezXAu8FPgTdEI/E
         zZ2zNgpR7M1P6zDC1WeSemJghM+k/kp5YXlJQzlv2+m6OawMwuTjC1kHiewwWpinstze
         bxzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yNvToFIJovK2pBeJ7epra0lfm0gCiwq1cqi8D6XJ5nM=;
        b=qt31ILhIKNOd77ywKoBrBAXSIqCkAognTu2txzhS3V5rljBFqDluxNsw08NC6kMsVw
         aXLMIDHsCtv/kNj5E77vH7Gww9ZVpc/PXFVpye3sUB/Xh3SBdEYBAFV19AD3E9dgc4oN
         3pp8RKq/677OVO9D7W0LULpQe3OEKmE1tcPfHBYs0+iTpXQAb9RBs2dAN4QWfU1Bz05f
         Ct2tQ8V+Qc59dWSmpCqAyzhv1qEfGKcOL2WYfSJqzO+SOyLYrRHSU40u9kALDvI6IwV6
         OKLgUDRCTcEv+TukX1DwBWYRPKnoEHtb0SdCBovE5ADBAAlTLX43WUCPT8wKT0mpmnEA
         7ZTw==
X-Gm-Message-State: APjAAAW4JqP40tiUhOLj8ELcIiBJhh6hs9VsYASx/s0HRtXnIp3eAw37
        QP17dNGAVO2vy/BrtX+SXM3uZOasvts=
X-Google-Smtp-Source: APXvYqzT5sVGM8yVchcEA0zSfIZAAd4+RYDey/AG3Sd1NdTYpieqtlS35uIQJoqnX/TFHHzeL63hAg==
X-Received: by 2002:a65:420c:: with SMTP id c12mr8541393pgq.125.1562376420931;
        Fri, 05 Jul 2019 18:27:00 -0700 (PDT)
Received: from localhost ([2409:8a00:7815:93e0:4a4d:7eff:feb0:5c9a])
        by smtp.gmail.com with ESMTPSA id cx22sm9806830pjb.25.2019.07.05.18.26.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 18:27:00 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v7 1/2] KVM: LAPIC: Make lapic timer unpinned
Date:   Sat,  6 Jul 2019 09:26:50 +0800
Message-Id: <1562376411-3533-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562376411-3533-1-git-send-email-wanpengli@tencent.com>
References: <1562376411-3533-1-git-send-email-wanpengli@tencent.com>
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
index 459d1ee..707ca9c 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1582,7 +1582,7 @@ static void start_sw_tscdeadline(struct kvm_lapic *apic)
 	    likely(ns > apic->lapic_timer.timer_advance_ns)) {
 		expire = ktime_add_ns(now, ns);
 		expire = ktime_sub_ns(expire, ktimer->timer_advance_ns);
-		hrtimer_start(&ktimer->timer, expire, HRTIMER_MODE_ABS_PINNED);
+		hrtimer_start(&ktimer->timer, expire, HRTIMER_MODE_ABS);
 	} else
 		apic_timer_expired(apic);
 
@@ -1684,7 +1684,7 @@ static void start_sw_period(struct kvm_lapic *apic)
 
 	hrtimer_start(&apic->lapic_timer.timer,
 		apic->lapic_timer.target_expiration,
-		HRTIMER_MODE_ABS_PINNED);
+		HRTIMER_MODE_ABS);
 }
 
 bool kvm_lapic_hv_timer_in_use(struct kvm_vcpu *vcpu)
@@ -2321,7 +2321,7 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
 	apic->vcpu = vcpu;
 
 	hrtimer_init(&apic->lapic_timer.timer, CLOCK_MONOTONIC,
-		     HRTIMER_MODE_ABS_PINNED);
+		     HRTIMER_MODE_ABS);
 	apic->lapic_timer.timer.function = apic_timer_fn;
 	if (timer_advance_ns == -1) {
 		apic->lapic_timer.timer_advance_ns = LAPIC_TIMER_ADVANCE_ADJUST_INIT;
@@ -2510,7 +2510,7 @@ void __kvm_migrate_apic_timer(struct kvm_vcpu *vcpu)
 
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

