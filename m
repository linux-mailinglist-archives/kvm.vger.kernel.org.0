Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F46B3CAEB
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 14:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390190AbfFKMRZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 08:17:25 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45007 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387814AbfFKMRY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jun 2019 08:17:24 -0400
Received: by mail-pg1-f195.google.com with SMTP id n2so6870404pgp.11;
        Tue, 11 Jun 2019 05:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4jHs27FTKy0dRUgrWNghDEXPvRuXCxHm03+a+AGR4s4=;
        b=VOk1M317Lbm7Sbfn7Nxj7qZAfCpr0V4lAH690E3N9YjdmwnCIvePrixx9WG0r2iN56
         OS9VEg1d2pW50ceSW0Uz1CQ2L3H9xxCAX5Jsw7IcVBBrWoL8Nro2rI3lR/5+rV9nUSMN
         MKxtGmvpwwlB1cKnOi+j4GsO2P2Ttal+SlOvHFSxnd7lNF4dcN3ejk2MDg4g6DxKTd1i
         0m7YuDJEaRYnj1B5EqEhK6SKHpHMc125SkEQz/P2ob7OHTrL2cp0CAMjkFxZMq5v5ykh
         fuCHrI2iEoqpksdtEUWQvRQcCMtie0sAToKn/Jckwkp5VZJT51diN1CnOr7T58+YZ8vR
         rlXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4jHs27FTKy0dRUgrWNghDEXPvRuXCxHm03+a+AGR4s4=;
        b=qwJV0aXGDwPr3RCP1LdWlljNCwslzMwTZ4s1hZa08OsnHh7OgIJ9oVNeIY86R2ScX5
         PQCs0GOyEUZI4XN6b+O1y4ZJkmIZD3o1zl63gWzBXL46MpgPhFo8Gd8zwqOmS7w8Q/Ks
         HEDRgkyPBZSbSGNdqM3sR5sVqi1ReELXL3Y3IWpx8EGZ9i2AVzH7IZ9Wd9euE21rtDRu
         3KU2RYWs1VZGw+hWAZb52p/G5FploK6lBxHy4geHBrB7rQzam9WNw0ZxsmyRMB/hMVuV
         CiIV1eyUwiTV3G6jFNaE5wFMyGi4wykOm27arSuxVtazWMUqscZ1mi1CI6aYYvg3F9x1
         lTPA==
X-Gm-Message-State: APjAAAW6IPdEUPJQrvhiCneUkpn74Z8ei2kzfzxGR0RbhnCqEwn/2NYV
        ZF99fY5iyo7JOfoKzik+s8wu4ABP
X-Google-Smtp-Source: APXvYqzX1CcHC3CySDnfEisveM4xqkQFrHz1g4OtmNuGGahNNSDnfH7dPxOTVyO/w6LX5pnR2ujNVA==
X-Received: by 2002:a63:2c14:: with SMTP id s20mr19676175pgs.182.1560255443619;
        Tue, 11 Jun 2019 05:17:23 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id v4sm19649478pff.45.2019.06.11.05.17.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 11 Jun 2019 05:17:23 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH v3 2/4] KVM: LAPIC: lapic timer interrupt is injected by posted interrupt
Date:   Tue, 11 Jun 2019 20:17:07 +0800
Message-Id: <1560255429-7105-3-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560255429-7105-1-git-send-email-wanpengli@tencent.com>
References: <1560255429-7105-1-git-send-email-wanpengli@tencent.com>
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
This patch tries to avoid vmexit which is incurred by the emulated 
timer fires in dedicated instance scenario. 

When nohz_full is enabled in dedicated instances scenario, the emulated 
timers can be offload to the nearest busy housekeeping cpus since APICv 
is really common in recent years. The guest timer interrupt is injected 
by posted-interrupt which is delivered by housekeeping cpu once the emulated 
timer fires. 

~3% redis performance benefit can be observed on Skylake server.

w/o patch:

            VM-EXIT  Samples  Samples%  Time%   Min Time  Max Time   Avg time

EXTERNAL_INTERRUPT    42916    49.43%   39.30%   0.47us   106.09us   0.71us ( +-   1.09% )

w/ patch:

            VM-EXIT  Samples  Samples%  Time%   Min Time  Max Time         Avg time

EXTERNAL_INTERRUPT    6871     9.29%     2.96%   0.44us    57.88us   0.72us ( +-   4.02% )

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index e57eeba..020599f 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -133,6 +133,12 @@ inline bool posted_interrupt_inject_timer_enabled(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(posted_interrupt_inject_timer_enabled);
 
+static inline bool can_posted_interrupt_inject_timer(struct kvm_vcpu *vcpu)
+{
+	return posted_interrupt_inject_timer_enabled(vcpu) &&
+		kvm_hlt_in_guest(vcpu->kvm);
+}
+
 static inline bool kvm_apic_map_get_logical_dest(struct kvm_apic_map *map,
 		u32 dest_id, struct kvm_lapic ***cluster, u16 *mask) {
 	switch (map->mode) {
@@ -1441,6 +1447,19 @@ static void apic_update_lvtt(struct kvm_lapic *apic)
 	}
 }
 
+static void kvm_apic_inject_pending_timer_irqs(struct kvm_lapic *apic)
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
 static void apic_timer_expired(struct kvm_lapic *apic)
 {
 	struct kvm_vcpu *vcpu = apic->vcpu;
@@ -1450,6 +1469,11 @@ static void apic_timer_expired(struct kvm_lapic *apic)
 	if (atomic_read(&apic->lapic_timer.pending))
 		return;
 
+	if (can_posted_interrupt_inject_timer(apic->vcpu)) {
+		kvm_apic_inject_pending_timer_irqs(apic);
+		return;
+	}
+
 	atomic_inc(&apic->lapic_timer.pending);
 	kvm_set_pending_timer(vcpu);
 
@@ -2386,13 +2410,7 @@ void kvm_inject_apic_timer_irqs(struct kvm_vcpu *vcpu)
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
 	if (atomic_read(&apic->lapic_timer.pending) > 0) {
-		kvm_apic_local_deliver(apic, APIC_LVTT);
-		if (apic_lvtt_tscdeadline(apic))
-			apic->lapic_timer.tscdeadline = 0;
-		if (apic_lvtt_oneshot(apic)) {
-			apic->lapic_timer.tscdeadline = 0;
-			apic->lapic_timer.target_expiration = 0;
-		}
+		kvm_apic_inject_pending_timer_irqs(apic);
 		atomic_set(&apic->lapic_timer.pending, 0);
 	}
 }
-- 
2.7.4

