Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41FCD22E3F
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 10:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731128AbfETIS2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 04:18:28 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44808 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbfETIS1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 04:18:27 -0400
Received: by mail-pl1-f196.google.com with SMTP id c5so6336013pll.11;
        Mon, 20 May 2019 01:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J5bitq098SqofmjAE5nftP3h9LGv7b07N9P0DWT5GlE=;
        b=fyOTnQuktMtfnTjwqSLI7MVSKSd2i7bDA6gvWxiU0bGuka3sRSIORPO2vLQ/eEXr/k
         6r4ev2vt4Ax6a4ncHZLI+etDN30xgCkiiFxkktMzZjcXt7gsCB3+65TwzCpXqGbcNLE+
         3no6O1ezS6g0AZyHPWr16KSKs3jDDDWsmnj5wNrjIGVbGGLr4nVsR51aRhwHGpeTgHI+
         0uQ2a/wdV185C5pfOpXrV+pMJhRLInEDN8IwzGNzz1pljS6cADO/lqcsNFsf98aJnMAm
         HHGewJYbhbsCfP/UJcXk4fm6kfrNd+NGwEwvfhMpEkcPnegq5OKkPAb4Qv82l5gfEMHw
         9NhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J5bitq098SqofmjAE5nftP3h9LGv7b07N9P0DWT5GlE=;
        b=PyDsQ4hAxZxffYLzKAolVT+U4u95b2i5UeEKqPxZzXOdgznXpiXXwLTL06wgZU55yY
         yXdZcPy6I3EIjfsLxQaUT0iOIaptiHsg5r8Ww64OD1/QFDworRFMMvsHw5szESjg1Gpq
         7VE2KAgmEdUkb51fb3i/XDx3xRM6biJBp54y7mGxTFci6maR88oaIW61C1qWuo/fRqaQ
         /hOWd/ExmI5dKz+6WwaUAF3Pnl2ljhDjmNaQ/R+43hkbm9UuMND7fMIB39Tfsq4puupW
         AAHBCuryLECN/kfrZZ0DCMLIAKs/02/E/SDZZSwRxafH2T+HNn6KssEm0KuGImucFwyi
         qZcw==
X-Gm-Message-State: APjAAAWfoachacrddo9nRkUBv5lLNxiCeF1XhBOkd155rgnL0xgGWO3W
        ZuYMDxs6g4tdPDosoc/J5gKEvf8k
X-Google-Smtp-Source: APXvYqzmKdXp2DhAH1bpNOXf99i/3TxFkPAtAT2PodIzUOWxELgNlXwBt+34bIEEhnqOcmgPqagVpw==
X-Received: by 2002:a17:902:b713:: with SMTP id d19mr13364987pls.123.1558340306174;
        Mon, 20 May 2019 01:18:26 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id z9sm18522110pgc.82.2019.05.20.01.18.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 20 May 2019 01:18:25 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v4 1/5] KVM: LAPIC: Extract adaptive tune timer advancement logic
Date:   Mon, 20 May 2019 16:18:05 +0800
Message-Id: <1558340289-6857-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558340289-6857-1-git-send-email-wanpengli@tencent.com>
References: <1558340289-6857-1-git-send-email-wanpengli@tencent.com>
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
index 4924f83..89ac82d 100644
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

