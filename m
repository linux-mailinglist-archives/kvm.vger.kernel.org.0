Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7871C1E759
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 06:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbfEOEMD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 00:12:03 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33187 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbfEOEMB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 May 2019 00:12:01 -0400
Received: by mail-pf1-f193.google.com with SMTP id z28so657411pfk.0;
        Tue, 14 May 2019 21:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=88lmluIaE7kKZILXvo6NHqb4oRYbdykbJ9/sXwZnO1M=;
        b=VEKD1RihQsjByTZaFKgrBFq7YnLekfq/6ZbnVEPhLWHToM3Fecybghl7GfXoarZ8KV
         FOhflvVi7klC5v4H2/eb6vraz4PjAclv2p8He48ifljEcNfUOU3kS0JelXoZtlPnaxsL
         Sv3Aa4ctKY3YmDweoZLbfqCEPqWlrzVsjw2NXp4ynDmFMpNnEZtuBjEorjK0yAuSbxGe
         myDqOlAI6oD4LC+GtKDpDu5XIZCn8u4QRKfs1GniCHxW09payuT16VvsJh6jrT1XYXAa
         KNY2SKvaHDb9DYFkyokGOJwDL4P3sSBEHGupj1e0+vyVyIHhtw6U0j7qomtEx+ocXAmm
         X+qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=88lmluIaE7kKZILXvo6NHqb4oRYbdykbJ9/sXwZnO1M=;
        b=lg5e1lLG3jKyv3t9zaXvevREinlOblodghjyaJqv0sHMnDAEhqhCJ73YlaB6VqcbIx
         iZFul3oVHsMd59hHypzHrDyTMtX+w60mjbJb2qYK/0N60bQeF2KDaBzYfUJHQt4B/PDL
         33yg11VTAc+KyElVXYUCqeHlpJKSJl230O+KdtLrvEubPY7ZujUS/JwIcXSyYiy3pEHZ
         Za/rr6YEqD2u9lRK+6Egge8LmKEkG6JDHbsYtj3dh2EMbOSn11YvEZ4D4e9ip2j8KJ98
         6DZSU0HbR4PICgWmJSu1uoLCTtIyRTkkMK5YU5/fbXkXjnhCB44oa+xX/jg9CJybura4
         wEuA==
X-Gm-Message-State: APjAAAWSal6Lzc5G31dxVYF5cHH1vAz/jAl9NvJP2+caj+yFIipoCrub
        McXHuHX9f3eDPK+mL5mwhCc69QSC
X-Google-Smtp-Source: APXvYqxgkv0gpmM3wx6cDOWZdp3F6HzS05wnnxx11adiI92NmO1+TDTJv3P0qsaIFwe3lniTp5Gqjg==
X-Received: by 2002:a63:4346:: with SMTP id q67mr41809012pga.241.1557893520902;
        Tue, 14 May 2019 21:12:00 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id z187sm886788pfb.132.2019.05.14.21.11.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 14 May 2019 21:12:00 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v2 1/4] KVM: LAPIC: Extract adaptive tune timer advancement logic
Date:   Wed, 15 May 2019 12:11:51 +0800
Message-Id: <1557893514-5815-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1557893514-5815-1-git-send-email-wanpengli@tencent.com>
References: <1557893514-5815-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Extract adaptive tune timer advancement logic to a single function.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 57 ++++++++++++++++++++++++++++++----------------------
 1 file changed, 33 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index bd13fdd..2f364fe 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1501,11 +1501,40 @@ static inline void __wait_lapic_expire(struct kvm_vcpu *vcpu, u64 guest_cycles)
 	}
 }
 
-void wait_lapic_expire(struct kvm_vcpu *vcpu)
+static inline void adaptive_tune_timer_advancement(struct kvm_vcpu *vcpu,
+				u64 guest_tsc, u64 tsc_deadline)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	u32 timer_advance_ns = apic->lapic_timer.timer_advance_ns;
-	u64 guest_tsc, tsc_deadline, ns;
+	u64 ns;
+
+	/* too early */
+	if (guest_tsc < tsc_deadline) {
+		ns = (tsc_deadline - guest_tsc) * 1000000ULL;
+		do_div(ns, vcpu->arch.virtual_tsc_khz);
+		timer_advance_ns -= min((u32)ns,
+			timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
+	} else {
+	/* too late */
+		ns = (guest_tsc - tsc_deadline) * 1000000ULL;
+		do_div(ns, vcpu->arch.virtual_tsc_khz);
+		timer_advance_ns += min((u32)ns,
+			timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
+	}
+
+	if (abs(guest_tsc - tsc_deadline) < LAPIC_TIMER_ADVANCE_ADJUST_DONE)
+		apic->lapic_timer.timer_advance_adjust_done = true;
+	if (unlikely(timer_advance_ns > 5000)) {
+		timer_advance_ns = 0;
+		apic->lapic_timer.timer_advance_adjust_done = true;
+	}
+	apic->lapic_timer.timer_advance_ns = timer_advance_ns;
+}
+
+void wait_lapic_expire(struct kvm_vcpu *vcpu)
+{
+	struct kvm_lapic *apic = vcpu->arch.apic;
+	u64 guest_tsc, tsc_deadline;
 
 	if (apic->lapic_timer.expired_tscdeadline == 0)
 		return;
@@ -1521,28 +1550,8 @@ void wait_lapic_expire(struct kvm_vcpu *vcpu)
 	if (guest_tsc < tsc_deadline)
 		__wait_lapic_expire(vcpu, tsc_deadline - guest_tsc);
 
-	if (!apic->lapic_timer.timer_advance_adjust_done) {
-		/* too early */
-		if (guest_tsc < tsc_deadline) {
-			ns = (tsc_deadline - guest_tsc) * 1000000ULL;
-			do_div(ns, vcpu->arch.virtual_tsc_khz);
-			timer_advance_ns -= min((u32)ns,
-				timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
-		} else {
-		/* too late */
-			ns = (guest_tsc - tsc_deadline) * 1000000ULL;
-			do_div(ns, vcpu->arch.virtual_tsc_khz);
-			timer_advance_ns += min((u32)ns,
-				timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
-		}
-		if (abs(guest_tsc - tsc_deadline) < LAPIC_TIMER_ADVANCE_ADJUST_DONE)
-			apic->lapic_timer.timer_advance_adjust_done = true;
-		if (unlikely(timer_advance_ns > 5000)) {
-			timer_advance_ns = 0;
-			apic->lapic_timer.timer_advance_adjust_done = true;
-		}
-		apic->lapic_timer.timer_advance_ns = timer_advance_ns;
-	}
+	if (unlikely(!apic->lapic_timer.timer_advance_adjust_done))
+		adaptive_tune_timer_advancement(vcpu, guest_tsc, tsc_deadline);
 }
 
 static void start_sw_tscdeadline(struct kvm_lapic *apic)
-- 
2.7.4

