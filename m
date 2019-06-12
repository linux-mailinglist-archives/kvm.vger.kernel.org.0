Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8DB420FC
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 11:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437512AbfFLJgU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 05:36:20 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39955 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437503AbfFLJgT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 05:36:19 -0400
Received: by mail-pl1-f193.google.com with SMTP id a93so6408628pla.7;
        Wed, 12 Jun 2019 02:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XpEnBE6bGmJdt1K4+jFodyaadPKkbgqY+88bNzccZ0Y=;
        b=RX83D3kfSfz2ttjlAg5kltFuEKTsQhd1Hp5CMH+sKKNjyV2R/nRdt03FHbCoCHbeH2
         c2CHMzShfy4JUsNBWNlCPOSWs/Kboo5aA6J21/TWY0k183hs4PJDvkj71drzOwBsUxXg
         OSWvXPtlEArFMeKzYgEyCR30N1fpfArZRO1Mb/bRXdx2MPW3dyzJ5NfWJMJsxvQYuJSM
         IeUCIOKgRt0+h9yLAVRgVJ0Lo51GQXxz2+9hGm4Ddb01aTWRsARZTsslcf+MmFiQ82BR
         LgKWuQ03cB7t4PlT+hIZUWgwKMbobcO1Eyf25d2uDAm+l5eH4IPuRICTCtbDJQlyhzbi
         2sHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XpEnBE6bGmJdt1K4+jFodyaadPKkbgqY+88bNzccZ0Y=;
        b=mZEAB4UoJC9mJWTBYCu03wlVRc7yZltnLDSSrMG4i2wRmbkLY9uK7BcUT3jbnEZ4ZY
         Xvla1Rc3rKABz/W1aolj3LWl+G0tcCtPkv2tNPTqa8Sn5vwXhkCU66hPf4NtAk7aYsUG
         iCi26qrsWnauQELw8mxF8/ZEP8fs/gr1Ev8+qrN8JOAKuVzsQcmjSOHFDOM/DBWXaRly
         uKSC40HzJtRxockCnPz/ssG5yYD2zs6tzwLuQoN+QZ08jMTj+DYOl3U4iyF4QdkaRRrW
         LugHhSt9x+jgaM4dpTZ1yI7V7vIFffuNlAF+Of0tF20otuUSN4jOP+/1StIiAUHw125X
         XTng==
X-Gm-Message-State: APjAAAUO1WARUpZ5+r5HQVszdNX9SBG2aQWjR+yD5+8pDxoDDOE2ATKC
        yudb7RyZ8nZNJHMFPJHWJa+jZ9fL
X-Google-Smtp-Source: APXvYqxW/4jY4bnjpg3tE9zUuZVmrDGHHptuTCc/LGAfkeBoJ6/NCjAgSZNHsfZYNVckFCL4nO+U5Q==
X-Received: by 2002:a17:902:ba82:: with SMTP id k2mr73161407pls.323.1560332178485;
        Wed, 12 Jun 2019 02:36:18 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id 27sm6148936pgl.82.2019.06.12.02.36.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 12 Jun 2019 02:36:18 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v3 4/5] KVM: LAPIC: Delay trace advance expire delta
Date:   Wed, 12 Jun 2019 17:35:59 +0800
Message-Id: <1560332160-17050-5-git-send-email-wanpengli@tencent.com>
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

wait_lapic_expire() call was moved above guest_enter_irqoff() because of 
its tracepoint, which violated the RCU extended quiescent state invoked 
by guest_enter_irqoff()[1][2]. This patch simply moves the tracepoint 
below guest_exit_irqoff() in vcpu_enter_guest(). Snapshot the delta before 
VM-Enter, but trace it after VM-Exit. This can help us to move 
wait_lapic_expire() just before vmentry in the later patch.

[1] Commit 8b89fe1f6c43 ("kvm: x86: move tracepoints outside extended quiescent state")
[2] https://patchwork.kernel.org/patch/7821111/

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 16 ++++++++--------
 arch/x86/kvm/lapic.h |  1 +
 arch/x86/kvm/x86.c   |  2 ++
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 2f364fe..af38ece 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1502,27 +1502,27 @@ static inline void __wait_lapic_expire(struct kvm_vcpu *vcpu, u64 guest_cycles)
 }
 
 static inline void adaptive_tune_timer_advancement(struct kvm_vcpu *vcpu,
-				u64 guest_tsc, u64 tsc_deadline)
+				s64 advance_expire_delta)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	u32 timer_advance_ns = apic->lapic_timer.timer_advance_ns;
 	u64 ns;
 
 	/* too early */
-	if (guest_tsc < tsc_deadline) {
-		ns = (tsc_deadline - guest_tsc) * 1000000ULL;
+	if (advance_expire_delta < 0) {
+		ns = -advance_expire_delta * 1000000ULL;
 		do_div(ns, vcpu->arch.virtual_tsc_khz);
 		timer_advance_ns -= min((u32)ns,
 			timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
 	} else {
 	/* too late */
-		ns = (guest_tsc - tsc_deadline) * 1000000ULL;
+		ns = advance_expire_delta * 1000000ULL;
 		do_div(ns, vcpu->arch.virtual_tsc_khz);
 		timer_advance_ns += min((u32)ns,
 			timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
 	}
 
-	if (abs(guest_tsc - tsc_deadline) < LAPIC_TIMER_ADVANCE_ADJUST_DONE)
+	if (abs(advance_expire_delta) < LAPIC_TIMER_ADVANCE_ADJUST_DONE)
 		apic->lapic_timer.timer_advance_adjust_done = true;
 	if (unlikely(timer_advance_ns > 5000)) {
 		timer_advance_ns = 0;
@@ -1545,13 +1545,13 @@ void wait_lapic_expire(struct kvm_vcpu *vcpu)
 	tsc_deadline = apic->lapic_timer.expired_tscdeadline;
 	apic->lapic_timer.expired_tscdeadline = 0;
 	guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
-	trace_kvm_wait_lapic_expire(vcpu->vcpu_id, guest_tsc - tsc_deadline);
+	apic->lapic_timer.advance_expire_delta = guest_tsc - tsc_deadline;
 
-	if (guest_tsc < tsc_deadline)
+	if (apic->lapic_timer.advance_expire_delta < 0)
 		__wait_lapic_expire(vcpu, tsc_deadline - guest_tsc);
 
 	if (unlikely(!apic->lapic_timer.timer_advance_adjust_done))
-		adaptive_tune_timer_advancement(vcpu, guest_tsc, tsc_deadline);
+		adaptive_tune_timer_advancement(vcpu, apic->lapic_timer.advance_expire_delta);
 }
 
 static void start_sw_tscdeadline(struct kvm_lapic *apic)
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index d6d049b..3e72a25 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -32,6 +32,7 @@ struct kvm_timer {
 	u64 tscdeadline;
 	u64 expired_tscdeadline;
 	u32 timer_advance_ns;
+	s64 advance_expire_delta;
 	atomic_t pending;			/* accumulated triggered timers */
 	bool hv_timer_in_use;
 	bool timer_advance_adjust_done;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f2e3847..4a7b00c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7961,6 +7961,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	++vcpu->stat.exits;
 
 	guest_exit_irqoff();
+	trace_kvm_wait_lapic_expire(vcpu->vcpu_id,
+		vcpu->arch.apic->lapic_timer.advance_expire_delta);
 
 	local_irq_enable();
 	preempt_enable();
-- 
2.7.4

