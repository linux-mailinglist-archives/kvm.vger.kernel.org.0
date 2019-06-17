Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7984808F
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 13:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728208AbfFQLZC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 07:25:02 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38482 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728192AbfFQLZB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 07:25:01 -0400
Received: by mail-pf1-f195.google.com with SMTP id a186so5526298pfa.5;
        Mon, 17 Jun 2019 04:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZPMmGlggKRyLg49Kb0BImDI3ZVEGWjwFFMRfu+tAPEY=;
        b=Rs4nxynFTiOIoXaRb+b4NRojRVkTvoHG/kGDW1fiQgudxsEwYLq1N1/I7BWearZEZX
         kE5d9K2hpaoESVES/ysvWG6vQqAMzpqg3g2Ahz6YqISutTlubrwwi8Xw2hQI5WytYIAu
         YNh0KpsyR7kHdbm0jrU5zsQPAqY1t1E4MPZCbP6dJGQ1au7B/uo4RIck9cywjzjCiD4V
         /qxZxC9KUt60wJIWoJlNMGe0QuSTNy3EdLO2eGgKfXunKQInaRLIAoeU+plcXeK04Uue
         GnIsYhvudjqwhHEUwf7ORCLruEKRKDjK6LXvdWdUpAHF3gD1cCekTXeO/E+WNyTsWO0X
         zKEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZPMmGlggKRyLg49Kb0BImDI3ZVEGWjwFFMRfu+tAPEY=;
        b=C197ZEvF7QzbLw6mbhtw4nDDysyY6uLoZz+eeORoECB619+VXdGg6Rj0oDIlc4y/aU
         ZvkFqgd/yHmV2uLePWkcLJiOhdABzzEpYTUfroccD5j1GUJn6lD3UElQx7ntVDr4AkVn
         paePu/SswhpfC11ASvYP4beHbocufSCNFGKzHFWPIa8OWdJUlSmDumhSjlAoj2xVIONp
         PVMFc3mBISR2MkCzBAZzOJzN7nC7Gr914ybFyp6GK2h3dnNuTtmRwPMuiQq+zUBTR/0X
         u1frxCnNLpzQzlKQ/HreNb+bqcvDM6crKLhrzyq3BPl4cmsxIVsKzKuvvfXgl5GxAWxQ
         blfw==
X-Gm-Message-State: APjAAAU0VJZCy48pdOxpdRmoDFxdNpXhVmPOgGCx78vHfcYm2nGZ2HYe
        pZv8zuOcameKOPc9RtBV1djEMTcK
X-Google-Smtp-Source: APXvYqxmVSoAkrmrfdYOldw4nzbyV8eRNbsMphgir1DMpt8nLOocrIjgNWYr/XWAvNWYpqGxuInLkg==
X-Received: by 2002:a63:6cc3:: with SMTP id h186mr47951870pgc.292.1560770700848;
        Mon, 17 Jun 2019 04:25:00 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id d4sm12535751pfc.149.2019.06.17.04.24.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 17 Jun 2019 04:25:00 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v4 4/5] KVM: LAPIC: Don't posted inject already-expired timer
Date:   Mon, 17 Jun 2019 19:24:46 +0800
Message-Id: <1560770687-23227-5-git-send-email-wanpengli@tencent.com>
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

already-expired timer interrupt can be injected to guest when vCPU who 
arms the lapic timer re-vmentry, don't posted inject in this case.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 665b1bb..1a31389 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1452,7 +1452,7 @@ static void kvm_apic_inject_pending_timer_irqs(struct kvm_lapic *apic)
 	}
 }
 
-static void apic_timer_expired(struct kvm_lapic *apic)
+static void apic_timer_expired(struct kvm_lapic *apic, bool can_pi_inject)
 {
 	struct kvm_vcpu *vcpu = apic->vcpu;
 	struct swait_queue_head *q = &vcpu->wq;
@@ -1461,7 +1461,7 @@ static void apic_timer_expired(struct kvm_lapic *apic)
 	if (atomic_read(&apic->lapic_timer.pending))
 		return;
 
-	if (posted_interrupt_inject_timer(apic->vcpu)) {
+	if (can_pi_inject && posted_interrupt_inject_timer(apic->vcpu)) {
 		kvm_apic_inject_pending_timer_irqs(apic);
 		return;
 	}
@@ -1605,7 +1605,7 @@ static void start_sw_tscdeadline(struct kvm_lapic *apic)
 		expire = ktime_sub_ns(expire, ktimer->timer_advance_ns);
 		hrtimer_start(&ktimer->timer, expire, HRTIMER_MODE_ABS);
 	} else
-		apic_timer_expired(apic);
+		apic_timer_expired(apic, false);
 
 	local_irq_restore(flags);
 }
@@ -1695,7 +1695,7 @@ static void start_sw_period(struct kvm_lapic *apic)
 
 	if (ktime_after(ktime_get(),
 			apic->lapic_timer.target_expiration)) {
-		apic_timer_expired(apic);
+		apic_timer_expired(apic, false);
 
 		if (apic_lvtt_oneshot(apic))
 			return;
@@ -1757,7 +1757,7 @@ static bool start_hv_timer(struct kvm_lapic *apic)
 		if (atomic_read(&ktimer->pending)) {
 			cancel_hv_timer(apic);
 		} else if (expired) {
-			apic_timer_expired(apic);
+			apic_timer_expired(apic, false);
 			cancel_hv_timer(apic);
 		}
 	}
@@ -1807,7 +1807,7 @@ void kvm_lapic_expired_hv_timer(struct kvm_vcpu *vcpu)
 		goto out;
 	WARN_ON(swait_active(&vcpu->wq));
 	cancel_hv_timer(apic);
-	apic_timer_expired(apic);
+	apic_timer_expired(apic, false);
 
 	if (apic_lvtt_period(apic) && apic->lapic_timer.period) {
 		advance_periodic_target_expiration(apic);
@@ -2310,7 +2310,7 @@ static enum hrtimer_restart apic_timer_fn(struct hrtimer *data)
 	struct kvm_timer *ktimer = container_of(data, struct kvm_timer, timer);
 	struct kvm_lapic *apic = container_of(ktimer, struct kvm_lapic, lapic_timer);
 
-	apic_timer_expired(apic);
+	apic_timer_expired(apic, true);
 
 	if (lapic_is_periodic(apic)) {
 		advance_periodic_target_expiration(apic);
-- 
2.7.4

