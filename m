Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A28CE1FDE5
	for <lists+kvm@lfdr.de>; Thu, 16 May 2019 05:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbfEPDGa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 23:06:30 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45113 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfEPDG2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 May 2019 23:06:28 -0400
Received: by mail-pf1-f196.google.com with SMTP id s11so1011056pfm.12;
        Wed, 15 May 2019 20:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=88lmluIaE7kKZILXvo6NHqb4oRYbdykbJ9/sXwZnO1M=;
        b=tiX3j7JmDXzYxaPL6JWewN3LHzlrHspcL3zRiV2Zxu8drpny4BHvYbELtEFeHhoGTI
         q+2nhFOIdLuUY5aagHyn7DT/NjUGNp9Y/eDWN0NUdUA01JA0ehUZ1yZJvC5KqqYx+2qT
         l87zl4yPZ/dEUMmvXmq7FKgxonKykiccYtRYIp1TSOdGhCSXKkgsaFdJAL8TxGfZQUQk
         pyNKKAOakkLPgbhIbRgv+1TfRwKoRUZEXSgKOThEz9oIkDlM8jLyGUKjLpVysAa1fTSg
         7vQpb8Y8lLt/AF3h4YWktXc+N/ss8wWTjUgRH5LkgevABsOsDdIwftejt8QDFn+kre64
         z9gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=88lmluIaE7kKZILXvo6NHqb4oRYbdykbJ9/sXwZnO1M=;
        b=EfsEUXKsExr5vc4TewFWmGQ9orYla6oWB9tcccoRrzr6x98Z+6+mofhmm3TqKsDhj0
         1ULYXmDv+LiPYRnZXdLfCEpISH4ltMOQj8qRT2wT8/YNZOpb+nWJOuT84gQwgog7GB5j
         X4tU2CzO+Yq9DnbjSTpD6zv0abZpzlhAmyFJOCdgU9YNKf3JO8a7osai0rze09BJcSsE
         iRpjrrODaQvG0VEmwWjzfjt48ooOFR377LwEpG0S7NjFNOceaUzwd0DMxPF/BQn7Rp2W
         hmwKLuUAcbuER5MVVPwFvdTDAyG/4wCd4YgX/jFUs5SaCRYFE3CVbn/5daYTKCH9KI3M
         bUAQ==
X-Gm-Message-State: APjAAAXbbyhcz+BmolBUVOR1IVfJkeF0M5W+3X78J8Ot9FHFiwboZx8I
        Z74K3COS7+trpUGkrSKbwkiyRsPD
X-Google-Smtp-Source: APXvYqx7ZC1/6AkuGVNTg4hrPL5fa57mq4htdPFSC3LCkl2pjeMkIWyGd1/wyoLCa+43a5j99NhylA==
X-Received: by 2002:a65:4802:: with SMTP id h2mr44535635pgs.98.1557975987340;
        Wed, 15 May 2019 20:06:27 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id 204sm4247614pgh.50.2019.05.15.20.06.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 15 May 2019 20:06:26 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v3 1/5] KVM: LAPIC: Extract adaptive tune timer advancement logic
Date:   Thu, 16 May 2019 11:06:16 +0800
Message-Id: <1557975980-9875-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1557975980-9875-1-git-send-email-wanpengli@tencent.com>
References: <1557975980-9875-1-git-send-email-wanpengli@tencent.com>
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

