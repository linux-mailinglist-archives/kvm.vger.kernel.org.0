Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53E1635A3A
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2019 12:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbfFEKJk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jun 2019 06:09:40 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39175 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727203AbfFEKJc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jun 2019 06:09:32 -0400
Received: by mail-pl1-f195.google.com with SMTP id g9so9512972plm.6;
        Wed, 05 Jun 2019 03:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qkxXjj4yDg1YqzQ56xMNaH8WCEkd0pao4XID5lR33u0=;
        b=qq4KcFpg6V/NYUJmTiK0L3VbS952jUCLbUCBYxxjqzMweeyqhdQOXFElFN5S7+7tqJ
         SPbduEujYwjMkH4nr99Lh36WjKYgleWwZR7MqFL9sPZ0Cm3bX47+LoiY/19mRV6N9a8h
         NKfuw3wSPlkPb/SxvvoSIlKNETvT7rCzhO5jY/T4UI3b1oXdYKbe9eN98QyeQo1/O2BW
         vJGLyb+XAKbnrA/HxVehYxHiS5LNPGqny+laQicKqxwFUvANC2YwkT9YEIF5F3ZSYgI6
         eyFoWgFcc0GVO8xzRKli5A7RW+rjjSI8r+Z/DfJgwACJGbgSy245Fcp9dGUabbEvAAsd
         4iwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qkxXjj4yDg1YqzQ56xMNaH8WCEkd0pao4XID5lR33u0=;
        b=p1RcEw6h/3HvmYDWcSA3BqKNeUsKe6z2VLYEaSJQsKTjGV4B3vm+pOuVG83Xjo/dca
         6rr0MuBARTbL5DwxBCnZnyQ07Zh93D8ZgPobCZ3IiMMMG7c3oV1/gG7WUG9hvX0EcdmS
         WVBDrflrB0WNhqsNS+lTgsHbVDOl5r5/1FKL5DrcCMsp1UPAAQe6c8NWeMvLBMYCt8xU
         HilsSSpABInA1Mln3cYiF+KrySc8i4buUPKfu3tbl8b90JqjE0nMv/hXFr5k+y4hqjse
         KC3+Y8a13FMDeQPHyj+Up4xMRAs+5zWTKwcUgiHezueH6i2tyrf6qsFiRywkpiLuF7Mx
         7YTg==
X-Gm-Message-State: APjAAAVAIMiUeRyaLhpUD9EOzenUprqw4tLmZN4LiMLwQpFDbtdRXIEZ
        RVWBLky82wpsIgdvtG7fvz87GtJO
X-Google-Smtp-Source: APXvYqxtALWInCOxeqKT/4oHumokJPlHOQVmMyB+FdMSWRr48iiVjvrZcg0Ag76eYJlpIMGO2v+dAw==
X-Received: by 2002:a17:902:2862:: with SMTP id e89mr42874547plb.258.1559729372086;
        Wed, 05 Jun 2019 03:09:32 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id v9sm19030010pfm.34.2019.06.05.03.09.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 05 Jun 2019 03:09:31 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 2/3] KVM: LAPIC: lapic timer is injected by posted interrupt
Date:   Wed,  5 Jun 2019 18:09:10 +0800
Message-Id: <1559729351-20244-3-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559729351-20244-1-git-send-email-wanpengli@tencent.com>
References: <1559729351-20244-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Dedicated instances are currently disturbed by unnecessary jitter due 
to the emulated lapic timers fire on the same pCPUs which vCPUs resident.
There is no hardware virtual timer on Intel for guest like ARM. Both 
programming timer in guest and the emulated timer fires incur vmexits.
This patchset tries to avoid vmexit which is incurred by the emulated 
timer fires in dedicated instance scenario. 

When nohz_full is enabled in dedicated instances scenario, the unpinned 
timer will be moved to the nearest busy housekeepers after commit 444969223c8
("sched/nohz: Fix affine unpinned timers mess"). However, KVM always makes 
lapic timer pinned to the pCPU which vCPU residents, the reason is explained 
by commit 61abdbe0 (kvm: x86: make lapic hrtimer pinned). Actually, these 
emulated timers can be offload to the housekeeping cpus since APICv 
is really common in recent years. The guest timer interrupt is injected by 
posted-interrupt which is delivered by housekeeping cpu once the emulated 
timer fires. 

3%~5% redis performance benefit can be observed on Skylake server.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 8c9c14d..e9db086 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1465,6 +1465,23 @@ static void apic_timer_expired(struct kvm_lapic *apic)
 }
 
 /*
+ * On APICv, lapic timer is injected by posted interrupt
+ * to dedicated instance.
+ */
+static void apic_timer_expired_pi(struct kvm_lapic *apic)
+{
+	struct kvm_timer *ktimer = &apic->lapic_timer;
+
+	kvm_apic_local_deliver(apic, APIC_LVTT);
+	if (apic_lvtt_tscdeadline(apic))
+		ktimer->tscdeadline = 0;
+	if (apic_lvtt_oneshot(apic)) {
+		ktimer->tscdeadline = 0;
+		ktimer->target_expiration = 0;
+	}
+}
+
+/*
  * On APICv, this test will cause a busy wait
  * during a higher-priority task.
  */
@@ -2297,7 +2314,10 @@ static enum hrtimer_restart apic_timer_fn(struct hrtimer *data)
 	struct kvm_timer *ktimer = container_of(data, struct kvm_timer, timer);
 	struct kvm_lapic *apic = container_of(ktimer, struct kvm_lapic, lapic_timer);
 
-	apic_timer_expired(apic);
+	if (unlikely(posted_interrupt_inject_timer(apic->vcpu)))
+		apic_timer_expired_pi(apic);
+	else
+		apic_timer_expired(apic);
 
 	if (lapic_is_periodic(apic)) {
 		advance_periodic_target_expiration(apic);
-- 
2.7.4

