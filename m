Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB09E18905
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 13:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbfEIL33 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 07:29:29 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37646 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbfEIL32 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 May 2019 07:29:28 -0400
Received: by mail-pl1-f193.google.com with SMTP id p15so1023268pll.4;
        Thu, 09 May 2019 04:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kmGfVV6xMnKEH1Nw/+sZ6in9OeGvjzHFhQvxNu73uPA=;
        b=lZ+7dgwNi4xSZFMnOMgt6+YnXWQydzk/rEIKBWWYgNir/GYcwekJBvoYneXUuHf5m6
         ZP+Ns/p6TypS+o88fVAYzyfPjxCYMfBpR6M8jWMyG0+smRHKzGKpuDdiBSULLcZo+ted
         QffaFfoB7U/Y1+F+su3ktavDtGl0VMaMPU4DtPWr7i5QR1xLaH2jhxT+d2T/0r0Cnjo5
         pHZOtpS0q1SJxlAN59sp5DOqEIBhkcaY1JjMZj/+4s7ry7KKUUnIbZT3/9sc34IhZq5h
         eSwDVtvXntNMd3WHqnH4waOrvoiSWoZfnqGvs7TXJp+Lt38sWqwEvuejp1ekV/GX++vJ
         pgtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kmGfVV6xMnKEH1Nw/+sZ6in9OeGvjzHFhQvxNu73uPA=;
        b=ioxz/cmFMs2Y8vf/fDaHPlNokJ2RVr7RG1ic67RQE2D8yQRedIPwTLs+kUJ03kOz0Z
         F6hfqtqkdtZ+hKzdIY0TmYQCJUNVHtVovzeKOqdV78keGJe9CX5pr7LA8/B6Br104+Fi
         WvdB/vVSrL72Chb6C+md808olfMeDNqRmozxf/L5Ki+j2/evYK30aBsnwI4dAAA+WqOC
         z33BFi8YSR1+lhz0SQF/XSaPxZSBzOjojJwEwM5/wlO2lzHVr6WveaDjIWb7BwrpjZ/6
         pOqtNDPxSOiY1EOY9656jQzfkiNGD2pzDtQB0nYxCEHbRQReXc7AOq94g7l1o6F1Bf7F
         QIfg==
X-Gm-Message-State: APjAAAV+8JoQ9pdjHwDxCtbyFCyYR3tP3AeLeClfA8hyle7wO1/8zNNT
        4TtjFseAgoc3RskhlsL9VRz0Fiot
X-Google-Smtp-Source: APXvYqxTj9IdFC4fToQziuY7q99z7gwEsiT2cqmr8tK/32rIJgOGXN/BYECKiqcFoi1BHSlwVWYY+w==
X-Received: by 2002:a17:902:b589:: with SMTP id a9mr4435112pls.66.1557401367858;
        Thu, 09 May 2019 04:29:27 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id j10sm2762002pfa.37.2019.05.09.04.29.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 09 May 2019 04:29:27 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH 1/3] KVM: LAPIC: Extract adaptive tune timer advancement logic
Date:   Thu,  9 May 2019 19:29:19 +0800
Message-Id: <1557401361-3828-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1557401361-3828-1-git-send-email-wanpengli@tencent.com>
References: <1557401361-3828-1-git-send-email-wanpengli@tencent.com>
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
index bd13fdd..e7a0660 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1501,11 +1501,41 @@ static inline void __wait_lapic_expire(struct kvm_vcpu *vcpu, u64 guest_cycles)
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
+	if (!apic->lapic_timer.timer_advance_adjust_done) {
+			/* too early */
+			if (guest_tsc < tsc_deadline) {
+				ns = (tsc_deadline - guest_tsc) * 1000000ULL;
+				do_div(ns, vcpu->arch.virtual_tsc_khz);
+				timer_advance_ns -= min((u32)ns,
+					timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
+			} else {
+			/* too late */
+				ns = (guest_tsc - tsc_deadline) * 1000000ULL;
+				do_div(ns, vcpu->arch.virtual_tsc_khz);
+				timer_advance_ns += min((u32)ns,
+					timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
+			}
+			if (abs(guest_tsc - tsc_deadline) < LAPIC_TIMER_ADVANCE_ADJUST_DONE)
+				apic->lapic_timer.timer_advance_adjust_done = true;
+			if (unlikely(timer_advance_ns > 5000)) {
+				timer_advance_ns = 0;
+				apic->lapic_timer.timer_advance_adjust_done = true;
+			}
+			apic->lapic_timer.timer_advance_ns = timer_advance_ns;
+		}
+}
+
+void wait_lapic_expire(struct kvm_vcpu *vcpu)
+{
+	struct kvm_lapic *apic = vcpu->arch.apic;
+	u64 guest_tsc, tsc_deadline;
 
 	if (apic->lapic_timer.expired_tscdeadline == 0)
 		return;
@@ -1521,28 +1551,7 @@ void wait_lapic_expire(struct kvm_vcpu *vcpu)
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
+	adaptive_tune_timer_advancement(vcpu, guest_tsc, tsc_deadline);
 }
 
 static void start_sw_tscdeadline(struct kvm_lapic *apic)
-- 
2.7.4

