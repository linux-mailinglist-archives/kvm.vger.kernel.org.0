Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42EDB420F7
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 11:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437467AbfFLJgN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 05:36:13 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43711 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436605AbfFLJgM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 05:36:12 -0400
Received: by mail-pf1-f195.google.com with SMTP id i189so9308016pfg.10;
        Wed, 12 Jun 2019 02:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=88lmluIaE7kKZILXvo6NHqb4oRYbdykbJ9/sXwZnO1M=;
        b=UxcPVoPge84gHKa9lkF71A9zos8xXimiSmSTNVkzubPoS7hwAzD8wS4pBLPW/GPQCd
         NqSjLmqqRUQeGzpC2IdQHwMcgNocDNceuU4XUhWuX9T/c5uLsb8ekeSgYhsA68KPBpdQ
         UwFnsLEG/VCauoc757MpET1YncY8eFTZ3qTJVgp95Rs6IkuqsDfGnsUq0ZWOrsiVX84b
         wdnmvsVCfOjCn7Sb9lOb+Wgf37S0IMwXUVEhbzzbuZD7RhJXWke4GvHHYXDICCt4KpW8
         WfY1CA3apdDOMSNOfUkETH+FfhdmdDfcJBoxytO1RGBnLt16vLRbcWcu/0xLvD0zcOOv
         8NqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=88lmluIaE7kKZILXvo6NHqb4oRYbdykbJ9/sXwZnO1M=;
        b=LXegbZnSYVvHTm0VYfSvkNXh4+ZpYTew82te+sBfRbW+7oQwyTfshDNt7jfS/pRgIa
         T+330vZb3FXkLUc4gT3nrCitjO/Ex5Xs2iqNI1Z+NW2ZDYbxiodY9ttt+B16MOG++hdA
         2xAwaUTs+emFp7fHnVaaNTnuj9RM7R9+ApLSP73fyA7vpJCUgsalUsFM2goK4sJU+uxt
         MfNYPcTZ5mGOsod5SV67/Jb06Nde7YlVXBb9Szpq0lhHtUfg7I0x+7HdbCb9Mu5i13PY
         FV03difH5leVVxIXxBASEDoiK+N977SlhjjMTjhFbt9N1yYhqxbIJu5L6Cp53UElwUEX
         Kkqg==
X-Gm-Message-State: APjAAAWFwKNpn2Vd2C7xd9OJnuNUPQca9iiyrg22EqXUWpZLU6VFM33z
        r0M8CWrDajQHrlXD7YLtyFdZMpQB
X-Google-Smtp-Source: APXvYqzx6SQmo43U9ZA704N0c1Y0btJ8Y2tYi1EoZ4svBE7THvNxsSr+dDoHWQ5xMnqNWUgLTVLzVw==
X-Received: by 2002:a62:ce4f:: with SMTP id y76mr2602196pfg.21.1560332171442;
        Wed, 12 Jun 2019 02:36:11 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id 27sm6148936pgl.82.2019.06.12.02.36.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 12 Jun 2019 02:36:10 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v3 1/5] KVM: LAPIC: Extract adaptive tune timer advancement logic
Date:   Wed, 12 Jun 2019 17:35:56 +0800
Message-Id: <1560332160-17050-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560332160-17050-1-git-send-email-wanpengli@tencent.com>
References: <1560332160-17050-1-git-send-email-wanpengli@tencent.com>
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

